using Feather, DataFrames, BenchmarkTools
# about 1min
@time const dt = Feather.read(data_path * "/dt.feather")
aggr(dt) = by(dt,:id1, subdt -> sum(subdt[:v1]))

@benchmark aggr(dt)
