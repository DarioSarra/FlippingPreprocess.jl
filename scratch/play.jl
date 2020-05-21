using Flipping

test = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/run_task_photo/raw_data/DN1_170807a.csv"
poke = process_pokes(test)
first(poke[:,[:Streak,:Poke,:LastPoke]],10)
union(poke[:,:Protocol])
##
