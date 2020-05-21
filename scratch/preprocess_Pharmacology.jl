using Revise
using Flipping
using CSV
##
Directory_path = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/Datasets/Pharmacology/PharmacologyFlipping"
pokes, bouts, streaks, DataIndex  = Flipping.create_exp_dataframes(Directory_path)
bouts
##
groupA = ["WJ0"*string(x) for x in 1:8]
groupB = ["WJ09"]
append!(groupB,["WJ1"*string(x) for x in 0:6])
groupB
groupdic = Dict()
for x in groupA
    groupdic[x]="A"
end
for x in groupB
    groupdic[x]="B"
end
drugDic = Dict(
    "A1a" => "None",
    "A1b" => "None",
    "A2a" => "Veh",
    "A2b" => "Veh",
    "A3a" => "PreVeh",
    "A3b" => "Altanserin_0.5",
    "A4a" => "PostVeh",
    "A5a" => "None",
    "A5b" => "None",
    "A6a" => "Veh",
    "A6b" => "PreVeh",
    "A7a" => "Altanserin_0.5",
    "A7b" => "PostVeh",
    "A8a" => "Veh",
    "B1a" => "None",
    "B1b" => "None",
    "B2a" => "Veh",
    "B2b" => "PreVeh",
    "B3a" => "Altanserin_0.5",
    "B3b" => "PostVeh",
    "B4a" => "Veh",
    "B5a" => "None",
    "B5b" => "None",
    "B6a" => "Veh",
    "B6b" => "Veh",
    "B7a" => "PreVeh",
    "B7b" => "Altanserin_0.5",
    "B8a" => "PostVeh",
    "A9a" => "None",
    "A9b" => "None",
    "A10a" => "Veh",
    "A10b" => "Veh",
    "A11a" => "PreVeh",
    "A11b" => "Altanserin_0.25",
    "A12a" => "PostVeh",
    "A13a" => "None",
    "A13b" => "None",
    "A14a" => "Veh",
    "A14b" => "PreVeh",
    "A15a" => "Altanserin_0.25",
    "A15b" => "PostVeh",
    "A16a" => "Veh",
    "B9a" => "None",
    "B9b" => "None",
    "B10a" => "Veh",
    "B10b" => "PreVeh",
    "B11a" => "Altanserin_0.25",
    "B11b" => "PostVeh",
    "B12a" => "Veh",
    "B13a" => "None",
    "B13b" => "None",
    "B14a" => "Veh",
    "B14b" => "Veh",
    "B15a" => "PreVeh",
    "B15b" => "Altanserin_0.25",
    "B16a" => "PostVeh",)
##
streaks.Group = [get(groupdic,x,"missing") for x in streaks.MouseID]
streaks.ExpSession = string.(streaks.Exp_Day).*streaks.Daily_Session
streaks.GroupSession = streaks.Group .* streaks.ExpSession
println(union(streaks.GroupSession))
streaks.Drug = [get(drugDic,x,missing) for x in streaks.GroupSession]
findall(ismissing,streaks.Drug)
filetosave = joinpath(Directory_path,"Results","Full_info_streaks.csv")
CSV.write(filetosave,streaks)
##
bouts.Group = [get(groupdic,x,"missing") for x in bouts.MouseID]
bouts.ExpSession = string.(bouts.Exp_Day).*bouts.Daily_Session
bouts.GroupSession = bouts.Group .* bouts.ExpSession
println(union(bouts.GroupSession))
bouts.Drug = [get(drugDic,x,missing) for x in bouts.GroupSession]
findall(ismissing,bouts.Drug)
filetosave = joinpath(Directory_path,"Results","Full_info_bouts.csv")
CSV.write(filetosave,bouts)
##
using FlippingModel
