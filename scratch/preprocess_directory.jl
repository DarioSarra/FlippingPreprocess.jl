using Revise
using Flipping
##
Directory_path = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/Datasets/Stimulations/Rbp4_gen_control"
Directory_path = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/Datasets/Stimulations/WT_new_protocols"
pokes, streaks, DataIndex  = Flipping.create_exp_dataframes(Directory_path)
d = Flipping.find_behavior(Directory_path)
names(pokes)
###
filepath = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/Datasets/Stimulations/WT_new_protocols/WJ16_200105a.csv"
Flipping.session_info(filepath)
findmax(streaks[:,:Day])
curr_data = FileIO.load(filepath) |> DataFrame
names(curr_data)
DataFrames.rename!(curr_data, Symbol("") => :Poke)
##
pokes, streaks, DataIndex = Flipping.create_exp_dataframes(d[1:2,:])
###
###
