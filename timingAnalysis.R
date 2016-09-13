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
opening$diff <- c(0,diff(as.numeric(opening$last),1))
opening <- opening['T09:30/T09:35']
mean(opening$diff)
names(data)

#closing difference
closing <- data.xts['T15:50/T16:05']
closing$diff <- c(0,diff(as.numeric(closing$last),1))
closing <- closing['T16:00/T16:05']
mean(closing$diff)

barplot(closing$diff, main="15:59 vs 16:03", sub="Positive: higher after close")
abline(h=mean(closing$diff))
barplot(y, add=T)
barplot(opening$diff, main="08:01 vs 09:30", sub="Positive: higher at open")
abline(h=mean(opening$diff))
barplot(y, add=T)
#********************************
#find the difference in the opening 8am and 9:30

openingAfter <- data.xts['T09:30/T10:00']
openingAfter$diff <- c(0,diff(as.numeric(openingAfter$last),1))
openingAfter <- openingAfter['T09:58/T10:00']
mean(openingAfter$diff)

#this is wrong.  calculates 8:30 to 10 when really want close to 10
preOpenToPostOpen <- data.xts['T07:50/T10:00']
perOpenToPostOpen <- preOpenToPostOpen["2015-10-19/"]
preOpenToPostOpen <- preOpenToPostOpen["T09:30/T09:35"]
preOpenToPostOpen$diff <- c(0,0,diff(as.numeric(preOpenToPostOpen$last),lag=2))
preOpenToPostOpen <- preOpenToPostOpen['T09:58/T10:00']
mean(preOpenToPostOpen$diff)

#difference between 8am and open
#last to 8am, last to open, then diff
data8am <- data.xts['T07:50/T08:10']
data8am$mid <- (as.numeric(data8am$bid) + as.numeric(data8am$ask)) /2
data8am$fromClose <-  as.numeric(data8am$mid) - as.numeric(data8am$close)
#this will show mean difference between open close
data10am <- data.xts['T09:50/T10:02']
data10am$toOpen <- as.numeric(data10am$open) - as.numeric(data10am$close)
#now the diff
data8am$toOpen <- data8am$fromClose-data10am$toOpen
barplot(data8am$toOpen, main="8am ", sub="Positive: higher at 8am",names.arg=format(index(data8am$toOpen), "%m-%d"))
abline(h=mean(data8am$toOpen))


############better!!!!!!!!!!!!!!!!!!!!!!!
#this way, use open and close
data10am <- data.xts['T09:50/T10:02']
#this will show mean difference from close to 10am
data10am$fromClose <- as.numeric(data10am$last) - as.numeric(data10am$close)
mean(data10am$fromClose)
#this will show mean difference between open and 10am
data10am$toOpen <- as.numeric(data10am$open) - as.numeric(data10am$close)
mean(data10am$toOpen)

#open to 10am
data10am$fromOpen <- data10am$last-data10am$open
barplot(data10am$fromOpen, main="open to 10am", sub="Positive: higher at 10am",names.arg=format(index(data10am$fromOpen), "%m-%d"))
abline(h=mean(data10am$fromOpen))



############better!!!!!!!!!!!!!!!!!!!!!!!

barplot(openingAfter$diff, main="15:59 vs 16:03", sub="Positive: higher after close")
abline(h=mean(openingAfter$diff))

