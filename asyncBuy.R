#Copyright (c) 2013 david hilton shanabrook. All rights reserved.
#TDALogin, getOrder, TDATrade, TDAQuote, getAccount, facToNum
library("XML2R")
library("RCurl")
source("~/ShinyApps/tosAsync/source/functions.R")
source("~/ShinyApps/tosAsync/private/details.R")
logFile <<- "~/ShinyApps/tosAsync/out/logFile.txt"
dDebug <<- F

slipPercent <- 0.005
ticker <- "AAPL"

allOrders <<- data.frame()

sessionid <- TDALogin("TSLU", "1.0", myLoginName, myPassWord)
account <- getAccount(sessionid,rollID)
stockBuyingPower <- facToNum(account$balance$stock.buying.power)
quote <- TDAQuote(sessionid,ticker)
maxShares <- round(stockBuyingPower/quote)
dhsShares <- maxShares - round(maxShares*slipPercent)

dadBuy 	<- getOrder(dadID, "buy", "moc","market",dadShares,ticker)
momBuy 	<- getOrder(momID, "buy", "moc","market",momShares,ticker)
dhsBuy 	<- getOrder(rollID, "buy","moc","market",dhsShares,ticker)
dhsTrade <- TDATrade(sessionid, "TSLU", dhsBuy,logFile)
momTrade <- TDATrade(sessionid, "TSLU", momBuy,logFile)
dadTrade <- TDATrade(sessionid, "TSLU", dadBuy,logFile)




		
