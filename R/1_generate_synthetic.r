source("R/0_setup.r")

#require(data.table)
#' Generate Synthetic dat
#' @import data.table
gen_datatable_synthetic <- function(N=2e8, K=100) {
  data.table(
    id1 = sample(sprintf("id%03d",1:K), N, TRUE),      # large groups (char)
    id2 = sample(sprintf("id%03d",1:K), N, TRUE),      # large groups (char)
    id3 = sample(sprintf("id%010d",1:(N/K)), N, TRUE), # small groups (char)
    id4 = sample(K, N, TRUE),                          # large groups (int)
    id5 = sample(K, N, TRUE),                          # large groups (int)
    id6 = sample(N/K, N, TRUE),                        # small groups (int)
    v1 =  sample(5, N, TRUE),                          # int in range [1,5]
    v2 =  sample(5, N, TRUE),                          # int in range [1,5]
    v3 =  sample(round(runif(100,max=100),4), N, TRUE) # numeric e.g. 23.5749
  )
}

library(data.table)
system.time(DT <- gen_datatable_synthetic())
system.time(fst::write.fst(DT,file.path(data_path, "DT.fst")))
system.time(feather::write_feather(DT,file.path(data_path, "DT.feather")))

md = fst::fst.metadata(file.path(data_path, "DT.fst"))
as.integer(md$NrOfRows)

pt <- proc.time()
for (i in seq(1,md$NrOfRows,1000000)) {
  d = fst::read.fst(file.path(data_path, "DT.fst"),
                from = i, to = i+1000000-1)
  
  summary(d)
}
timetaken(pt) #3:43

library(future)
plan(multiprocess)

md <- fst::fst.metadata(file.path(data_path, "DT.fst"))
pt <- proc.time()
dd1 = future_lapply(seq(1,md$NrOfRows,1000000), function(i) {
  d = fst::read.fst(file.path(data_path, "DT.fst"),
                    from = i, to = i+1000000-1, columns = c("id1","v1"), as.data.table = T)
  
  d[,sum(v1),keyby = id1]
})
fnl1 = setDT(rbindlist(dd1))[,sum(V1),keyby=id1]
timetaken(pt)


pt <- proc.time()
dd2 = future_lapply(seq(1,md$NrOfRows,1000000), function(i) {
  d = fst::read.fst(file.path(data_path, "DT.fst"),
                    from = i, to = i+1000000-1, columns = c("id1","v1"), as.data.table = T)
  
  d[,sum(v1),keyby = id1]
})
fnl2 = setDT(rbindlist(dd1))[,sum(V1),keyby=id1]
timetaken(pt)


cat("GB =", round(sum(gc()[,2])/1024, 3), "\n")
#system.time(DT[, sum(v1), keyby=id1])  # elapsed is almost doubled
pt <- proc.time()
DT[, sum(v1), keyby=id1]
timetaken(pt)

# experiment with future
# library(future)
# plan(multiprocess)

# pt <- proc.time()
# id1 <- future(sample(sprintf("id%03d",1:K), N, TRUE)      )# large groups (char)
# id2 <- future(sample(sprintf("id%03d",1:K), N, TRUE)      )# large groups (char)
# id3 <- future(sample(sprintf("id%010d",1:(N/K)), N, TRUE) )# small groups (char)
# id4 <- future(sample(K, N, TRUE)                       )# large groups (int)
# id5 <- future(sample(K, N, TRUE)                          )# large groups (int)
# id6 <- future(sample(N/K, N, TRUE)                        )# small groups (int)
# v1 <- future( sample(5, N, TRUE)                        )# int in range [1,5]
# v2 <- future( sample(5, N, TRUE)                          )# int in range [1,5]
# v3 <- future( sample(round(runif(100,max=100),4), N, TRUE)) # numeric e.g. 23.5749
# DT <- data.table::rbindlist(list(
#   data.table(value(id1)),
#   data.table(value(id2)),
#   data.table(value(id3)),
#   data.table(value(id4)),
#   data.table(value(id5)),
#   data.table(value(id6)),
#   data.table(value(v1)),
#   data.table(value(v2)),
#   data.table(value(v3))));
# timetaken(pt)

# #rbindlist(eval(parse(text=sprintf("list(%s)",paste(paste0("id",1:6, collapse = ","),paste0("v",1:3, collapse = ","), sep=",")))))

# cat("GB =", round(sum(gc()[,2])/1024, 3), "\n")
# #system.time(DT[, sum(v1), keyby=id1])  # elapsed is almost doubled
# pt <- proc.time()
# DT[, sum(v1), keyby=id1]
# timetaken(pt)

# 
# N=2e7; K=100
# set.seed(1)
# system.time(DT <- data.table(
#   id1 = sample(sprintf("id%03d",1:K), N, TRUE),      # large groups (char)
#   id2 = sample(sprintf("id%03d",1:K), N, TRUE),      # large groups (char)
#   id3 = sample(sprintf("id%010d",1:(N/K)), N, TRUE), # small groups (char)
#   id4 = sample(K, N, TRUE),                          # large groups (int)
#   id5 = sample(K, N, TRUE),                          # large groups (int)
#   id6 = sample(N/K, N, TRUE),                        # small groups (int)
#   v1 =  sample(5, N, TRUE),                          # int in range [1,5]
#   v2 =  sample(5, N, TRUE),                          # int in range [1,5]
#   v3 =  sample(round(runif(100,max=100),4), N, TRUE) # numeric e.g. 23.5749
# ))
# cat("GB =", round(sum(gc()[,2])/1024, 3), "\n")
# #system.time(DT[, sum(v1), keyby=id1])  # elapsed is almost doubled
# pt <- proc.time()
# DT[, sum(v1), keyby=id1]
# timetaken(pt)