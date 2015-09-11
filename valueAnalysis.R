library("zoo")
library("PerformanceAnalytics")
library("xts")
valueFile <- "~/ShinyApps/tosAsync/out/value.csv"
timeFormat <- "%Y-%m-%d %H:%M:%S"
data <- read.csv(valueFile)
data.zoo <- read.zoo(valueFile, header=T, sep=",")
data.xts <- as.xts(data.zoo)
data.zoo$all <- rowSums(data.zoo)
hour <- as.POSIXlt(time(data.zoo))$hour
plot(data)
plot(data.zoo$reg)
plot(data.zoo$ira)
plot(data.zoo$roll)
plot(data.zoo$roth)
plot(data.zoo$mom)
plot(data.zoo$dad)


plot.zoo(data.xts$roll)
#plot.zoo(data$all)
#chart.TimeSeries(data$roll )
chart.CumReturns(data.zoo$roll, wealth.index=T)

for (i in 1:5)
	plot(data.zoo[,i])
