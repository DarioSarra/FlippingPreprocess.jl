"""
`process_sessions`
"""

function process_sessions(DataIndex::DataFrames.AbstractDataFrame)
    c=0
    b=0
    pokes = DataFrame()
    streaks = DataFrame()
    for i=1:size(DataIndex,1)
        #println(i," ",DataIndex[i,:Bhv_Path])
        path = DataIndex[i,:Bhv_Path]
        session = DataIndex[i,:Session]
        filetosave = DataIndex[i,:Preprocessed_Path]
        if ~isfile(filetosave)
            pokes_data = process_pokes(path)
            FileIO.save(filetosave,pokes_data)
            streaks_data = process_streaks(pokes_data)
            b=b+1
        else
            pokes_data = FileIO.load(filetosave)|> DataFrame
            booleans=[:Reward,:Stim,:Wall,:Correct,:Stim_Day,:LastPoke]#columns to convert to Bool removed :Side,:SideHigh
            for x in booleans
                pokes_data[!,x] = eltype(pokes_data[!,x]) == Bool ? pokes_data[!,x] : occursin.(pokes_data[!,x],"true")
            end
            streaks_data = process_streaks(pokes_data)
            c=c+1
        end
        if isempty(pokes)
            pokes = pokes_data
            streaks = streaks_data
        else
            try
                append!(pokes, pokes_data)
                append!(streaks, streaks_data)
            catch
                println(DataIndex[i,:Bhv_Path])
                append!(pokes, pokes_data[:, names(pokes)])
                append!(streaks, streaks_data[:, names(streaks)])
            end
        end
    end
    println("Existing file = ",c," Preprocessed = ",b)
    return pokes, streaks
end

"""
`create_exp_dataframes`
"""

function create_exp_dataframes(DataIndex::DataFrames.AbstractDataFrame)
    exp_dir = DataIndex[1,:Saving_Path]
    pokes, streaks = process_sessions(DataIndex)
    exp_calendar = by(pokes,:MouseID) do dd
        Flipping.create_exp_calendar(dd,:Day)
    end
    protocol_calendar = by(pokes,:MouseID) do dd
        Flipping.create_exp_calendar(dd,:Day,:Protocol)
    end
    if !any(protocol_calendar[:,:Flexi])
        select!(protocol_calendar,DataFrames.Not([:Manipulation,:Flexi]))
    end
    pokes = join(pokes, exp_calendar, on = [:MouseID,:Day], kind = :inner,makeunique=true);
    pokes = join(pokes, protocol_calendar, on = [:MouseID,:Day], kind = :inner,makeunique=true);
    mask = occursin.(String.(names(pokes)),"_1")
    for x in[names(pokes)[mask]]
        DataFrames.select!(pokes,DataFrames.Not(x))
        #deletecols!(pokes, x)
    end
    pokes = Flipping.check_fiberlocation(pokes,exp_dir)
    filetosave = joinpath(exp_dir,"pokes"*splitdir(exp_dir)[end]*".jld2")
    @save filetosave pokes
    filetosave = joinpath(exp_dir,"pokes"*splitdir(exp_dir)[end]*".csv")
    CSVFiles.save(filetosave,pokes)
    streaks = join(streaks, exp_calendar, on = [:MouseID,:Day], kind = :inner,makeunique=true);
    streaks = join(streaks, protocol_calendar, on = [:MouseID,:Day], kind = :inner,makeunique=true);
    mask = occursin.(String.(names(streaks)),"_1")
    for x in[names(streaks)[mask]]
        DataFrames.select!(streaks,DataFrames.Not(x))
        #deletecols!(streaks, x)
    end
    streaks = Flipping.check_fiberlocation(streaks,exp_dir)
    filetosave = joinpath(exp_dir,"streaks"*splitdir(exp_dir)[end]*".jld2")
    @save filetosave streaks
    simple = DataFrames.select(streaks,DataFrames.Not(:PokeSequence))
    filetosave = joinpath(exp_dir,"streaks"*splitdir(exp_dir)[end]*".csv")
    CSVFiles.save(filetosave,simple)
    return pokes, streaks, DataIndex
end

function create_exp_dataframes(Directory_path::String,Exp_type::String,Exp_name::String, Mice_suffix::String)
    DataIndex = Flipping.find_behavior(Directory_path, Exp_type, Exp_name,Mice_suffix)
    create_exp_dataframes(DataIndex)
end


function create_exp_dataframes(Raw_data_dir::String)
    DataIndex = Flipping.find_behavior(Raw_data_dir)
    create_exp_dataframes(DataIndex)
end
