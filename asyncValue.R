#async value
#Copyright (c) 2013 david hilton shanabrook. All rights reserved.
#TDALogin,  getAccount, facToNum
library(quantmod)
library("XML2R")
library("RCurl")
source("~/ShinyApps/tosAsync/source/functions.R")
source("~/ShinyApps/tosAsync/private/details.R")
valueFile <- "~/ShinyApps/tosAsync/out/value.csv"
dDebug <<- F

acctV <- function(accountid) {
	account <- getAccount(sessionid, accountid)
	return(round(facToNum(account$balance$account.value$current)))
}

sessionid <<- TDALogin("TSLU", "1.0", myLoginName, myPassWord)

value.df <- data.frame(time=Sys.time(),reg=acctV(dhsID),ira=acctV(iraID),roll=acctV(rollID),roth=acctV(rothID),mom=acctV(momID),dad=acctV(dadID))
write.table(value.df, valueFile, append=T, sep=",",row.names=F, col.names=F)