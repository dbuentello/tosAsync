library(shiny)
library(shinyapps)
setwd("~/shinyapps/")
#in browser use command f3
options(shiny.reactlog=TRUE)
runApp("openinterest")
runApp("wealthAnalysis")
deployApp("babynames")

deployApp("openinterest")
