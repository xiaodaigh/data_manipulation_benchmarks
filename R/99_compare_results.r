fs <- dir("Results")
fsfull <- dir("Results",full.names = T)

library(data.table)
library(magrittr)
library(tidyr)

hehe <- lapply(split(fsfull, substr(fs,1,1) == "r"), function(fss) {
  lapply(fss, fread) %>% rbindlist
})

hehe$`FALSE`$test <- paste0("test",2:11)

comp <- merge(hehe$`FALSE`,hehe$`TRUE`)

comp_for_plotting <- comp[,.(Julia = mean(julia_timings), R = mean(elapsed)), test] %>% 
  gather(key = jr, value = timings, -test)

library(ggplot2)

comp_for_plotting %>% ggplot + 
  geom_bar(aes(fill = jr,x = test, y = timings), 
           stat = "identity", position = "dodge")
