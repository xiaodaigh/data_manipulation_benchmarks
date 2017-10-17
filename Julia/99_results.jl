# library(readr)
# output2017_10_14 <- read_csv("output2017-10-14.csv")
# View(output2017_10_14)
#
# library(data.table)
# setDT(output2017_10_14)
#
# output2017_10_14[,mean(elapsed), test]
#
# setDT(julia_results_2017_10_17T234750_019)

using uCSV,DataFrames

results_files = readdir("../Results")

rresults = results_files[[rs[1] for rs in results_files] .== 'r']


uCSV.read("../Results/"*rresults[1])
