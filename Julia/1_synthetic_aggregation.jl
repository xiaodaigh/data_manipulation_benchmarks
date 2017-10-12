using Feather, DataFrames, BenchmarkTools

@benchmark aggregate(+, DT, by=(:id1,), with=:v1)

# about 1min
#@time const DT = Feather.read(data_path * "/dt.feather")
# aggr(dt) = by(dt,:id1, subdt -> sum(subdt[:v1]))
# aggr2(dt) = aggregate(dt[:,[:id1,:v1]], :id1, sum)
#
# @benchmark aggr2(DT)
# @benchmark aggr2(DT)
#
# @benchmark aggr(DT)
# @benchmark aggr(DT)
