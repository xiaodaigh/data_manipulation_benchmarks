# using BenchmarkTools
#using IndexedTables

# Pkg.checkout("JuliaDB")
# Pkg.checkout("IndexedTables")
# Pkg.checkout("PooledArrays")
using NamedTuples
julia_timings = [
(@elapsed JuliaDB.aggregate(+, DT, by=(:id1,), with=:v1)),
(@elapsed JuliaDB.aggregate(+, DT, by=(:id1,), with=:v1)),
(@elapsed JuliaDB.aggregate(+, DT, by=(:id1,:id2), with=:v1)),
(@elapsed JuliaDB.aggregate(+, DT, by=(:id1,:id2), with=:v1)),

#res <- c(res, list(system.time( DT[, list(sum(v1),mean(v3)), keyby=id3] )))
# (
# @time aggregate_vec(
#   v -> @NT(sum = sum(t->t.v1, v), mean=mean(t->t.v3, v)), DT, by =(:id3,))
# ),
(@elapsed aggregate_vec(v -> @NT(sum = sum(column(v, :v1)), mean = mean(column(v, :v3))), DT, by =(:id3,), with = (:v1, :v3))),
(@elapsed aggregate_vec(v -> @NT(sum = sum(column(v, :v1)), mean = mean(column(v, :v3))), DT, by =(:id3,), with = (:v1, :v3))),
# ((@elapsed dt1 = aggregate_vec(sum, DT, by =(:id3,), with =:v1))+
# (@elapsed dt2 = aggregate_vec(mean, DT, by =(:id3,), with =:v3))),
# ((@elapsed dt1 = aggregate_vec(sum, DT, by =(:id3,), with =:v1))+
# (@elapsed dt2 = aggregate_vec(mean, DT, by =(:id3,), with =:v3))),
#dt2 = aggregate_vec([mean, sum], DT, by =(:id3,), with =(:v3, :v3))
#dt2 = aggregate_vec((mean, sum), DT, by =(:id3,), with =(:v3, :v3))

#res <- c(res, list(system.time( DT[, lapply(.SD, mean), keyby=id4, .SDcols=7:9] )))
(@elapsed aggregate_vec(
  v -> @NT(
    mean1 = mean(column(v, :v1)),
    mean2 = mean(column(v, :v2)),
    mean3 = mean(column(v, :v3))
    ), DT, by =(:id4,), with = (:v1, :v2, :v3))),
(@elapsed aggregate_vec(
    v -> @NT(
      mean1 = mean(column(v, :v1)),
      mean2 = mean(column(v, :v2)),
      mean3 = mean(column(v, :v3))
      ), DT, by =(:id4,), with = (:v1, :v2, :v3))),
#res <- c(res, list(system.time( DT[, lapply(.SD, sum), keyby=id6, .SDcols=7:9] )))
(@elapsed aggregate_vec(
  v -> @NT(
    sum1 = sum(column(v, :v1)),
    sum2 = sum(column(v, :v2)),
    sum3 = sum(column(v, :v3))
    ), DT, by =(:id6,), with = (:v1, :v2, :v3))),
(@elapsed aggregate_vec(
  v -> @NT(
    sum1 = sum(column(v, :v1)),
    sum2 = sum(column(v, :v2)),
    sum3 = sum(column(v, :v3))
    ), DT, by =(:id6,), with = (:v1, :v2, :v3)))
]

using uCSV,DataFrames
f = "../julia $(now()).csv"
uCSV.write(replace(f,":",""), DataFrame(julia_timings = julia_timings))
