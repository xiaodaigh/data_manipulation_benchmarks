source("R/0_setup.r")
library(data.table)
library(magrittr)
library(compiler)
enableJIT(3)

#require(data.table)
#' Generate Synthetic dat
#' @import data.table
gen_datatable_synthetic <- function(N=2e9/8, K=100) {
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


r_syn_gen_test <- function() {
  res <- NULL
  DT <- NULL
  res <- c(res, list(system.time(DT <- gen_datatable_synthetic())))
  cat("GB =", round(sum(gc()[,2])/1024, 3), "\n")
  res <- c(res, list(system.time( DT[, sum(v1), keyby=id1] )))
  res <- c(res, list(system.time( DT[, sum(v1), keyby=id1] )))
  res <- c(res, list(system.time( DT[, sum(v1), keyby="id1,id2"] )))
  res <- c(res, list(system.time( DT[, sum(v1), keyby="id1,id2"] )))
  res <- c(res, list(system.time( DT[, list(sum(v1),mean(v3)), keyby=id3] )))
  res <- c(res, list(system.time( DT[, list(sum(v1),mean(v3)), keyby=id3] )))
  res <- c(res, list(system.time( DT[, lapply(.SD, mean), keyby=id4, .SDcols=7:9] )))
  res <- c(res, list(system.time( DT[, lapply(.SD, mean), keyby=id4, .SDcols=7:9] )))
  res <- c(res, list(system.time( DT[, lapply(.SD, sum), keyby=id6, .SDcols=7:9] )))
  res <- c(res, list(system.time( DT[, lapply(.SD, sum), keyby=id6, .SDcols=7:9] )))
  
  
  res1 <- lapply(res, function(rr) rr %>% lapply(function(x) x) %>% as.data.table) %>% rbindlist
  setDT(res1)
  #browser()
  #res1[,test := c("generate_data", paste0("test",1:11))]
  print(res1)
  res1
}

#' Run R synthetic data generation test n times
#' @export
# n_r_syn_gen_test <- function(n) {
#   res2 <- lapply(1:n, function(i) {
#     print(i)
#     r_syn_gen_test()
#   })
#   return(res2)
# }
# 
# system.time(res <- n_r_syn_gen_test(1))

res100 <- NULL
for(i in 1:100) {
  res100 <- c(res100, list(n_r_syn_gen_test(1)))
}

res101 <- lapply(res100, function(x) {
  y = copy(x[[1]])
  setDT(y)
  y[,test:= paste0("test",1:.N)]
  y
}) %>% rbindlist
write.csv(res101,paste0("output",Sys.Date(),".csv"))
