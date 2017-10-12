using Distributions
using PooledArrays
#using DataFrames

N=Int64(2e9); K=100;

pool = [@sprintf "id%03d" k for k in 1:K]
pool1 = [@sprintf "id%010d" k for k in 1:K]

function randstrarray(pool, N)
    PooledArray(PooledArrays.RefArray(rand(UInt8(1):UInt8(100), N)), pool)
end

using JuliaDB
@time T = IndexedTable(Columns([1:N;]), Columns(
  id1 = randstrarray(pool, N),
  id2 = randstrarray(pool, N),
  id3 = randstrarray(pool1, N),
  id4 = rand(1:K, N),                          # large groups (int)
  id5 = rand(1:K, N),                          # large groups (int)
  id6 = rand(1:(N/K), N),                        # small groups (int)
  v1 =  rand(1:5, N),                          # int in range [1,5]
  v2 =  rand(1:5, N),                          # int in range [1,5]
  v3 =  rand(round.(rand(Uniform(0,100),100),4), N) # numeric e.g. 23.5749
 ))

using BenchmarkTools

@benchmark aggregate(+, T, by=(:id1,), with=:v1)
