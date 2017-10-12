using DataFrames, Distributions, BenchmarkTools;

function gen_dict(N,K)
    Dict(
      :id1 => sample([@sprintf "id%03d" k for k in 1:K], N),      # large groups (char)
      :id2 => sample([@sprintf "id%03d" k for k in 1:K], N),      # large groups (char)
      :id3 => sample([@sprintf "id%010d" k for k in 1:(N/K)], N), # small groups (char)
      :id4 => sample(1:K, N),                          # large groups (int)
      :id5 => sample(1:K, N),                          # large groups (int)
      :id6 => sample(1:(N/K), N),                        # small groups (int)
      :v1 =>  sample(1:5, N),                          # int in range [1,5]
      :v2 =>  sample(1:5, N),                          # int in range [1,5]
      :v3 =>  sample(round.(rand(Uniform(0,100),100),4), N) # numeric e.g. 23.5749
    )
end

function gen_datatable_synthetic(N, K)
    DataFrame(;gen_dict(N,K)...)
end

const N=Int64(2e8);
const K=100;

# @benchmark d1 = gen_dict(1,1)
# @benchmark d1 = gen_dict(N,K)
@time DT = gen_datatable_synthetic(N,K);
@benchmark DT = gen_datatable_synthetic(N,K);

const smallN=Int32(2e7)
@benchmark DTsmall = gen_datatable_synthetic(smallN,K)
