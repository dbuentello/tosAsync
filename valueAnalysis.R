	⁃	library("zoo")
	⁃	library("ggplot2")
	⁃	library("PerformanceAnalytics")
	⁃	library("xts")
	⁃	library(scales)
	⁃	valueFile <- "~/ShinyApps/tosAsync/out/value.csv"
	⁃	timeFormat <- "%Y-%m-%d %H:%M:%S"
	⁃	data <- read.csv(valueFile)
	⁃	data.zoo <- read.zoo(valueFile, header=T, sep=",")
	⁃	data.xts <- as.xts(data.zoo)
	⁃	data.zoo <- subset(data.zoo, select=-c(mom,dad))
	⁃	data.zoo$all <- rowSums(data.zoo)
	⁃	#data.zoo$mine <- data.zoo$roll + data.zoo$ira + data.zoo$reg
	⁃	
	⁃	#http://www.inside-r.org/packages/cran/zoo/docs/autoplot.zoo
	⁃	zoo.df = fortify(data.zoo, melt = TRUE)
	⁃	
	⁃	p <- ggplot(aes(x = Index, y = Value, group=Series,colour=Series), data = zoo.df) + geom_line() + xlab("Index") +  scale_y_continuous("Value $", labels=comma) 
	⁃	#+ scale_x_date()
	⁃	  p + facet_grid(Series~., scale="free_y", labeller="label_value")  
	⁃	  p  

# chart.CumReturns(data.zoo$, wealth.index=F)
# charts.PerformanceSummary(theReturn(data.zoo), wealth.index=F)



# theReturn <- function(new) {
	# old <- lag(new)
	# ret <- (new-old)/old
	# return(ret)
# }

# data.zoo <- subset(data.zoo, select=all)