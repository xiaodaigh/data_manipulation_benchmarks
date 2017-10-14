#system.time(fst::write.fst(DT,file.path(data_path, "DT100.fst"), compress = 100))

system.time(DT <- fst::read.fst(file.path(data_path,"DT.fst")))
system.time(DT <- feather::read_feather(file.path(data_path,"DT.feather")))