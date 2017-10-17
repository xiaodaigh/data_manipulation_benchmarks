# using BenchmarkTools
#using IndexedTables

# Pkg.checkout("JuliaDB")
# Pkg.checkout("IndexedTables")
# Pkg.checkout("PooledArrays")
julia_timings = [
(@elapsed JuliaDB.aggregate(+, DT, by=(:id1,), with=:v1)),
(@elapsed JuliaDB.aggregate(+, DT, by=(:id1,), with=:v1)),
(@elapsed JuliaDB.aggregate(+, DT, by=(:id1,:id2), with=:v1)),
(@elapsed JuliaDB.aggregate(+, DT, by=(:id1,:id2), with=:v1)),

#res <- c(res, list(system.time( DT[, list(sum(v1),mean(v3)), keyby=id3] )))
((@elapsed dt1 = aggregate_vec(sum, DT, by =(:id3,), with =:v1)) +
(@elapsed dt2 = aggregate_vec(mean, DT, by =(:id3,), with =:v3))),
((@elapsed dt1 = aggregate_vec(sum, DT, by =(:id3,), with =:v1))+
(@elapsed dt2 = aggregate_vec(mean, DT, by =(:id3,), with =:v3))),
#dt2 = aggregate_vec([mean, sum], DT, by =(:id3,), with =(:v3, :v3))
#dt2 = aggregate_vec((mean, sum), DT, by =(:id3,), with =(:v3, :v3))

#res <- c(res, list(system.time( DT[, lapply(.SD, mean), keyby=id4, .SDcols=7:9] )))
((@elapsed dt3 = aggregate_vec(mean, DT, by =(:id4,), with =:v1))+
(@elapsed dt4 = aggregate_vec(mean, DT, by =(:id4,), with =:v2))+
(@elapsed dt5 = aggregate_vec(mean, DT, by =(:id4,), with =:v3))),
((@elapsed dt3 = aggregate_vec(mean, DT, by =(:id4,), with =:v1))+
(@elapsed dt4 = aggregate_vec(mean, DT, by =(:id4,), with =:v2))+
(@elapsed dt5 = aggregate_vec(mean, DT, by =(:id4,), with =:v3))),

#res <- c(res, list(system.time( DT[, lapply(.SD, sum), keyby=id6, .SDcols=7:9] )))
((@elapsed dt6 = aggregate_vec(sum, DT, by =(:id6,), with =:v1))+
(@elapsed dt7 = aggregate_vec(sum, DT, by =(:id6,), with =:v2))+
(@elapsed dt8 = aggregate_vec(sum, DT, by =(:id6,), with =:v3))),
((@elapsed dt6 = aggregate_vec(sum, DT, by =(:id6,), with =:v1))+
(@elapsed dt7 = aggregate_vec(sum, DT, by =(:id6,), with =:v2))+
(@elapsed dt8 = aggregate_vec(sum, DT, by =(:id6,), with =:v3))),
]

f = open("julia_results.jld","w")
serialize(f,julia_timings)
close(f)
