#using CSV
# r_results = CSV.read(data_path*"\\output2017-10-14.csv")
using RCall
data_path = "D:\\git\\julia_r_python_ge_flight_quest"
fp = data_path*"\\output2017-10-14.csv"
R"a<-read.csv($fp)"

@rget a

using HypothesisTests
using DataFrames

aa = a[:test] .== "test2"
aaa = a[:test] .== "test3"
r_results = a[aa | aaa,:elapsed]

ff = open("julia_results.jld","r")
julia_results = deserialize(ff)
close(ff)

evtt = EqualVarianceTTest(julia_results, r_results)
uvtt = UnequalVarianceTTest(julia_results, r_results)

pvalue(evtt, tail = :left)
pvalue(evtt, tail = :right)

pvalue(uvtt, tail = :left)
pvalue(uvtt, tail = :right)

mean(julia_results) > mean(r_results)

mean(julia_results)/mean(r_results)

mean(julia_results)
mean(r_results)


aa = a[:test] .== "test4"
aaa = a[:test] .== "test5"
r_results = a[aa | aaa,:elapsed]

mean(r_results)

using DataFrames
by(a, :test, df -> mean(df[:elapsed]))
