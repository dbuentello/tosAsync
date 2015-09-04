#Copyright (c) 2013 david hilton shanabrook. All rights reserved.
#TDALogin, getOrder, TDATrade, TDAQuote, getAccount, facToNum, getPosition
library("XML2R")
library("RCurl")
source("~/ShinyApps/tosAsync/source/functions.R")
source("~/ShinyApps/tosAsync/private/details.R")

logFile <<- "~/ShinyApps/tos/out/logFile.txt"
dDebug <<- F
ticker <- "AAPL"
allOrders <<- data.frame()

sessionid <- TDALogin("TSLU", "1.0", myLoginName, myPassWord)
account <- getAccount(sessionid,rollID)
dhsStock <- getPosition(account$positions$stocks, ticker)

if (dhsShares == 0){
	dhsSell  <- getOrder(rollID,"sell","day","market", dhsStock$quantity, ticker)
} else {
	dhsSell  <- getOrder(rollID,"sell","day","market", dhsShares, ticker)
}
dadSell 	<- getOrder(dadID, "sell","day","market", dadShares, ticker)
momSell 	<- getOrder(momID, "sell","day","market", momShares, ticker)

dhsTrade <- TDATrade(sessionid, "TSLU", dhsSell, logFile)
momTrade <- TDATrade(sessionid, "TSLU", momSell, logFile)
dadTrade <- TDATrade(sessionid, "TSLU", dadSell, logFile)