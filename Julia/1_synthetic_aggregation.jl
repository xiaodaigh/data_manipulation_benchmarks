# using BenchmarkTools
using IndexedTables

# Pkg.checkout("JuliaDB")
# Pkg.checkout("IndexedTables")
# Pkg.checkout("PooledArrays")
julia_results = [@elapsed IndexedTables.aggregate(+, DT, by=(:id1,), with=:v1) for i in 1:10]
f = open("julia_results.jld","w")
serialize(f,julia_results)
close(f)
