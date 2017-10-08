source("R/0_setup.r")

library(pipeR)
library(data.table)
library(future)
plan(multiprocess)
pt <- proc.time()

aa1 <- dir(file.path(data_path,"InitialTrainingSet_rev1/"), full.names = T) %>>% 
  sapply(function(x) file.path(x,"ASDI","asdifpwaypoint.csv")) %>>% 
  future_lapply(fread)
aaa <- rbindlist(aa1);
data.table::timetaken(pt)
rm(aa1); gc()

system.time(fst::write.fst(aaa,file.path(data_path,"init_training_set.fst")))
system.time(feather::write_feather(aaa,file.path(data_path,"/init_training_set.feather")))

# pt <- proc.time()
# aa2 <- dir("D:/data/InitialTrainingSet_rev1/", full.names = T) %>>% 
#    sapply(function(x) file.path(x,"ASDI","asdifpwaypoint.csv")) %>>% 
#    lapply(fread)
# data.table::timetaken(pt) # 5:53
