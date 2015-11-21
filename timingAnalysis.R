library("zoo")
library("quantmod")
#library(performanceCharts)
quotesFile <- "~/ShinyApps/tosAsync/out/quotes.csv"
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

openingAfter <- data.xts['T09:30/T10:00']
openingAfter$diff <- c(0,diff(as.numeric(openingAfter$bid),1))
openingAfter <- openingAfter['T09:58/T10:00']
mean(openingAfter$diff)

#this is wrong.  calculates 8:30 to 10 when really want close to 10
preOpenToPostOpen <- data.xts['T07:50/T10:00']
perOpenToPostOpen <- preOpenToPostOpen["2015-10-19/"]
preOpenToPostOpen <- preOpenToPostOpen[-"T09:30/T09:35"]
preOpenToPostOpen$diff <- c(0,0,diff(as.numeric(preOpenToPostOpen$bid),lag=2))
preOpenToPostOpen <- preOpenToPostOpen['T09:58/T10:00']
mean(preOpenToPostOpen$diff)

############better!!!!!!!!!!!!!!!!!!!!!!!
#this way, use open and close
closeTo10 <- data.xts['T09:50/T10:02']
closeTo10$diff <- as.numeric(closeTo10$bid) - as.numeric(closeTo10$close)
mean(closeTo10$diff)

closeToOpen <- as.numeric(closeTo10$open) - as.numeric(closeTo10$close)
mean(closeToOpen)

############better!!!!!!!!!!!!!!!!!!!!!!!

barplot(openingAfter$diff, main="15:59 vs 16:03", sub="Positive: higher after close")
abline(h=mean(openingAfter$diff))