library("zoo")
library("ggplot2")
library("PerformanceAnalytics")
library("xts")
library(scales)
fsb <- 2100
tweedy <- 4503
usBonds <- 5634
interactivebroker <- 69000
loan <- 30092
interactivebroker <- interactivebroker + tweedy + usBonds + fsb - loan
toWealth <- function(x) {
	initial <- as.vector(x[1,])
	coredata(x) <- sweep(x,MARGIN=2,initial,'/')
	return(x)
}

valueFile <- "~/ShinyApps/tosAsync/out/value.csv"
data.zoo <- read.zoo(valueFile, header=T, sep=",")
#combine IRAs
data.zoo$ira <- data.zoo$ira + data.zoo$roll
data.zoo$ib <- interactivebroker
data.zoo[1:193,"ib"] <- tweedy + usBonds + fsb
data.zoo$reg <- data.zoo$reg + data.zoo$ib
data.zoo$all <- data.zoo$roth +  data.zoo$ira + data.zoo$reg 
data.zoo <- subset(data.zoo, select=-c(roll, ib, mom, dad))
#wealth or not

theData <- toWealth(data.zoo)

#http://www.inside-r.org/packages/cran/zoo/docs/autoplot.zoo
zoo.df = fortify(theData, melt = TRUE)

p <- ggplot(aes(x = Index, y = Value, group=Series,colour=Series), data = zoo.df) + geom_line() + xlab("Index") +  scale_y_continuous("Value $", labels=comma) 
#+ scale_x_date()
  p + facet_grid(Series~., scale="free_y", labeller="label_value")  
  p  

#dollar amounts

theData <- data.zoo
#theData <- subset(theData, select=-roth)
zoo.df = fortify(theData, melt = TRUE)

p <- ggplot(aes(x = Index, y = Value, group=Series,colour=Series), data = zoo.df) + geom_line() + xlab("Index")  +scale_y_continuous("Value $", labels=comma)
  p + facet_grid(Series~., scale="free_y", labeller="label_value")  
  p    +scale_y_continuous("Value $", labels=comma, breaks=seq(0,600000,20000))
 # p + scale_x_date(xlim=as.POSIXct(c("2016-03-19 00:00:00","2016-04-01 20:00:00")))

 