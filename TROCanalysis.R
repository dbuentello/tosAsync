library("XML2R")
library("RCurl")
source("~/ShinyApps/tosAsync/source/functions.R")
source("~/ShinyApps/tosAsync/private/details.R")
logFile <<- "~/ShinyApps/tosAsync/out/logFile.txt"
dDebug <<- F

slipPercent <- 0.003
ticker <- "AAPL"

allOrders <<- data.frame()

sessionid <- TDALogin("TSLU", "1.0", myLoginName, myPassWord)
account <- getAccount(sessionid,dhsID)
optionData <- getOptions(account)
TROC <- sum(as.numeric(optionData$theta)) * 365 / as.numeric(account$balance$account.value$current)
