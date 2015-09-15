library("zoo")
library("ggplot2")
library("PerformanceAnalytics")
library("xts")
valueFile <- "~/ShinyApps/tosAsync/out/value.csv"
timeFormat <- "%Y-%m-%d %H:%M:%S"
data <- read.csv(valueFile)
data.zoo <- read.zoo(valueFile, header=T, sep=",")
data.xts <- as.xts(data.zoo)
data.zoo <- subset(data.zoo, select=-c(mom,dad))
#data.zoo$all <- rowSums(data.zoo)
data.zoo$mine <- data.zoo$roll + data.zoo$ira + data.zoo$reg

#http://www.inside-r.org/packages/cran/zoo/docs/autoplot.zoo

zoo.df = fortify(data.zoo, melt = TRUE)

ggplot(aes(x = Index, y = Value), data = zoo.df) +
  geom_line() + xlab("Index") + ylab("total") + 
  facet_grid(Series~., scale="free_y")   
plot.zoo(data.xts$roll)
#plot.zoo(data$all)
#chart.TimeSeries(data$roll )
chart.CumReturns(data.zoo$roll, wealth.index=T)
