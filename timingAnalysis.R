library("zoo")
library("quantmod")
#library(performanceCharts)
quotesFile <- "/Volumes/superFly/Users/davidshanabrook/ShinyApps/tosAsync/out/quotes.csv"
theClasses <- c("zoo", "character", rep("numeric",5))
data <- read.table(quotesFile, sep=",", header=T)
data.zoo <- read.zoo(quotesFile,format="%Y-%m-%d %H:%M:%S",FUN = as.POSIXct,
 header=T, sep=",")


data.xts <- as.xts(data.zoo)

#***************************
#deal with opening.  painful method.  
opening <- data.xts['T07:50/T09:35']
opening$diff <- c(0,diff(as.numeric(opening$bid),1))
opening <- opening['T09:30/T09:35']
mean(opening$diff)
names(data)

#closing difference
closing <- data.xts['T15:50/T16:05']
closing$diff <- c(0,diff(as.numeric(closing$bid),1))
closing <- closing['T16:00/T16:05']
mean(closing$diff)

barplot(closing$diff, main="15:59 vs 16:03", sub="Positive: higher after close")
abline(h=mean(closing$diff))
barplot(y, add=T)
barplot(opening$diff, main="08:01 vs 09:30", sub="Positive: higher at open")
abline(h=mean(opening$diff))
barplot(y, add=T)
********************************
#find the difference in the opening 8am and 9:30
