using Revise
using Flipping
##
Directory_path = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/";
Exp_type = "Stimulations";
Exp_name = "DRN_Nac_Sert_ChR2"
Mice_suffix = "DN";
##
Directory_path = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/";
Exp_type = "Stimulations";
Exp_name = "DRN_Opto_Flipping"
Mice_suffix = "SD"
##
pokes, streaks, DataIndex = create_exp_dataframes(Directory_path,Exp_type,Exp_name, Mice_suffix)
##
DataIndex = Flipping.find_behavior(Directory_path,Exp_type,Exp_name, Mice_suffix)
findall(DataIndex[:Session].== "SD2_190131a.csv")
pokes, streaks, DataIndex = create_exp_dataframes(DataIndex[443:447,:])
pokes, streaks, DataIndex = create_exp_dataframes(DataIndex[1:10,:])
##
fn = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/run_task_photo/raw_data/SD2_190131a.csv"
check = process_pokes("/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/run_task_photo/raw_data/SD2_190131a.csv")
check[:,:PokeIn]
println(DataIndex[445,:])
union(DataIndex[:,:Session])
union(pokes[:,:Session])
findall(DataIndex[:,:Bhv_Path].== fn)
occursin("ddr","r")
DataIndex[:,:Session]
##
function tipi(df)
    res = DataFrame(Colonna = [], Tipo = [])
    for x in names(df)
        push!(res,(x,eltype(df[!,x])))
    end
    return sort!(res,:Colonna)
end
loaded = tipi(pokes_data)
done = tipi(pokes)
println((loaded,done))
check = DataFrame(Colonna = done[!,:Colonna], Tipo = done[!,:Tipo] .== loaded[!,:Tipo])
print(check)
##
DataIndex[1,:Preprocessed_Path]
##
DataIndex = Flipping.find_behavior(Directory_path, Exp_type, Exp_name,Mice_suffix)
##
Directory = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/run_task_2/All_LM"
Exp_name = "Learning"
Mice_suffix = "LM"
pokes, streaks, DataIndex = create_exp_dataframes(Directory)
DataIndex = Flipping.find_behavior(Directory)
union(DataIndex[:Day])
verify = by(DataIndex,:Day) do dd
    DataFrame(which = [SVector{size(dd,1),String}(union(dd[:MouseID]))])
end
println(verify)
