using Revise
using Flipping
using Guilia
using MixedModels
using Distributions
##
Directory = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/run_task_2/Test"
Directory = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/run_task_2/Dev_raw_data"
pokes, streaks, DataIndex = create_exp_dataframes(Directory)
###
Directory = "/home/beatriz/mainen.flipping.5ht@gmail.com/Flipping/run_task_2/Dev_raw_data/Results/"
file = joinpath(Directory,"streaksResults.csv")
streaks = Guilia.carica(file)
exclude_mice = ["CN21", "CN22","CN23","CN24","CN41","CN42","CN43"]# CNO GROUP WITHOUT CNO THE FIRST DAy
streaks = @filter streaks !in(:MouseID, exclude_mice)
Ncs = ["NC"* string(i) for i in collect(1:14)]
Ccs = ["CC"* string(i) for i in [3,4,5,9,10,14,15,16]]
Rcs = ["RC"* string(i) for i in [1,2,3,4]]
Nbs = ["NB"* string(i) for i in [21,22,23,24,25,41,42,43,44,45]]
Bns = ["BN"* string(i) for i in [21,22,23,24,41,42,43,44]]
Its = ["IT"* string(i) for i in [21,22,23,24,41,42,43,44]]
age_exp = vcat(Nbs,Bns,Its)
youngs = ["BN21", "BN22", "BN41", "BN42", "IT21", "IT22","IT41", "IT42", "NB21", "NB22","NB23","NB41","NB42"]
dev_below15_day1 = ["BN21","BN23","BN41","BN42","BN44","IT23","NB25","NB43","NB45"]
proj_below15_day1 = ["CC9","NC10","NC12","NC14","RC3","RC8"]
below_thrs = vcat(dev_below15_day1,proj_below15_day1)
cnos_animals = vcat(Ncs,Ccs,Rcs)
wt =  append!(["NC"* string(i) for i in [1,2,3,4,9,10,11,12]],age_exp)
"BN21" in youngs
streaks = @apply streaks begin
    @transform {Age = :MouseID in youngs ? "Young" : "Adult"}
    @transform {Exp_type = :MouseID in age_exp ? "Development" : "Projections"}
    @transform {Treatment = :MouseID in cnos ? "CNO" : "SAL"}
    @transform {Gen = :MouseID in wt ? "WT" : "HET"}
    @transform {Low_performance = :MouseID in below_thrs}
    @transform {Combo = :Gen*"_"*:Treatment}
end

union(column(streaks,:MouseID))
union(column(streaks,:Age))
filetosave = joinpath(Directory,"Full_info_streaks.csv")
CSV.write(filetosave,streaks)


cno_only = @apply streaks begin
    @filter !in(:MouseID,age_exp)
    @filter :Exp_Day == 1
end

check = @filter cno_only :Treatment == "CNO"
filetosave = joinpath(Directory,"All_dreadds_streaks.csv")
CSV.write(filetosave,streaks)
#######
data = launch()
t = data[][:data][]
df = DataFrame(t)

categorical!(df,:Treatment)
categorical!(df,:Gen)
##
function Likelyhood_Ratio_test(simple,full)
    degrees = dof(full) - dof(simple)
    ccdf(Distributions.Chisq(degrees), deviance(simple) - deviance(full))
end

function AIC_test(candidate, simpler)
    exp((aic(candidate) - aic(simpler))/2)
end
function AICc(model)
    aic(model) + ((2*(dof(model)^2) + 2*dof(model))/(nobs(model) - dof(model) - 1))
end
function AICc_test(candidate, simpler)
    exp((AICc(candidate) - AICc(simpler))/2)
end
##
No_interaction = fit(LinearMixedModel, @formula( AfterLast ~ 1 + Treatment + Gen + (1|MouseID)), df)
Interaction = fit(LinearMixedModel, @formula( AfterLast ~ 1 + Treatment + Gen + Treatment * Gen + (1|MouseID)), df)

AIC_test(protocol_effect,zero_effects)
AICc_test(protocol_effect,zero_effects)
Likelyhood_Ratio_test(zero_effects,protocol_effect)
