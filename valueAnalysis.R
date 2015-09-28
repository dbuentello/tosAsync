library("zoo")
library("ggplot2")
library("PerformanceAnalytics")
library("xts")
library(scales)

toWealth <- function(x) {
	initial <- as.vector(x[1,])
	coredata(x) <- sweep(x,MARGIN=2,initial,'/')
	return(x)
}

valueFile <- "~/ShinyApps/tosAsync/out/value.csv"
data.zoo <- read.zoo(valueFile, header=T, sep=",")
data.zoo <- subset(data.zoo, select=-c(mom,dad))

#wealth or not
theData <- data.zoo
theData <- toWealth(data.zoo)

#http://www.inside-r.org/packages/cran/zoo/docs/autoplot.zoo
zoo.df = fortify(data.zoo, melt = TRUE)

p <- ggplot(aes(x = Index, y = Value, group=Series,colour=Series), data = zoo.df) + geom_line() + xlab("Index") +  scale_y_continuous("Value $", labels=comma) 
#+ scale_x_date()
  p + facet_grid(Series~., scale="free_y", labeller="label_value")  
  p  
