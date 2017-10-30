# Sashi' IndexedTable version
using Distributions, PooledArrays, Nulls
#using DataFrames

#using IndexedTables

const N=Int64(2e9); const K=100;

const pool = [@sprintf "id%03d" k for k in 1:K]
const pool1 = [@sprintf "id%010d" k for k in 1:(N/K)]
#const pool_withmissing = vcat(null, pool)
#const pool1_withmssing = vcat(null, pool1)

function randstrarray(pool, N)
    PooledArray(PooledArrays.RefArray(rand(UInt8(1):UInt8(K), N)), pool)
end

using JuliaDB
srand(1)

DT = IndexedTable(
  Columns(
    row_id = [1:N;]
    ),
  Columns(
    id1 = randstrarray(pool, N),
    id2 = randstrarray(pool, N),
    id3 = randstrarray(pool1, N),
    id4 = rand(1:K, N),                          # large groups (int)
    id5 = rand(1:K, N),                          # large groups (int)
    id6 = rand(1:(N/K), N),                        # small groups (int)
    v1 =  rand(1:5, N),                          # int in range [1,5]
    v2 =  rand(1:5, N),                          # int in range [1,5]
    v3 =  rand(round.(rand(Uniform(0,100),100),4), N) # numeric e.g. 23.5749
    ));

# using DataFrames
# srand(1)
# @time dtdf = DataFrame(
#   :id1 => randstrarray(pool, N),
#   :id2 => randstrarray(pool, N),
#   :id3 => randstrarray(pool1, N),
#   :id4 => rand(1:K, N),                          # large groups (int)
#   :id5 => rand(1:K, N),                          # large groups (int)
#   :id6 => rand(1:(N/K), N),                        # small groups (int)
#   :v1 =>  rand(1:5, N),                          # int in range [1,5]
#   :v2 =>  rand(1:5, N),                          # int in range [1,5]
#   :v3 =>  rand(round.(rand(Uniform(0,100),100),4), N) # numeric e.g. 23.5749
#  );
# srand(1)
# @time dtdf = DataFrame(
#   id1 = randstrarray(pool, N),
#   id2 = randstrarray(pool, N),
#   id3 = randstrarray(pool1, N),
#   id4 = rand(1:K, N),                          # large groups (int)
#   id5 = rand(1:K, N),                          # large groups (int)
#   id6 = rand(1:(N/K), N),                        # small groups (int)
#   v1 =  rand(1:5, N),                          # int in range [1,5]
#   v2 =  rand(1:5, N),                          # int in range [1,5]
#   v3 =  rand(round.(rand(Uniform(0,100),100),4), N) # numeric e.g. 23.5749
# );


# Oringal version
# using DataFrames, Distributions, BenchmarkTools;
#
# function gen_dict(N,K)
#     Dict(
#       :id1 => sample([@sprintf "id%03d" k for k in 1:K], N),      # large groups (char)
#       :id2 => sample([@sprintf "id%03d" k for k in 1:K], N),      # large groups (char)
#       :id3 => sample([@sprintf "id%010d" k for k in 1:(N/K)], N), # small groups (char)
#       :id4 => sample(1:K, N),                          # large groups (int)
#       :id5 => sample(1:K, N),                          # large groups (int)
#       :id6 => sample(1:(N/K), N),                        # small groups (int)
#       :v1 =>  sample(1:5, N),                          # int in range [1,5]
#       :v2 =>  sample(1:5, N),                          # int in range [1,5]
#       :v3 =>  sample(round.(rand(Uniform(0,100),100),4), N) # numeric e.g. 23.5749
#     )
# end
#
# function gen_datatable_synthetic(N, K)
#     DataFrame(;gen_dict(N,K)...)
# end
#
# # @benchmark d1 = gen_dict(1,1)
# # @benchmark d1 = gen_dict(N,K)
# @time DT_orig = gen_datatable_synthetic(N,K);
# @benchmark DT_orig = gen_datatable_synthetic(N,K);
