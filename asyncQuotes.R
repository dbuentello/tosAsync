#record stock prices
#TDALogin
#Copyright (c) 2013 david hilton shanabrook. All rights reserved.

library("XML2R")
library("RCurl")
source("~/ShinyApps/tos/source/functions.R")
source("~/ShinyApps/tos/private/details.R")

dDebug <<- F
quoteFile <- "~/ShinyApps/tos/out/quotes.csv"

sessionid <- TDALogin("TSLU", "1.0", myLoginName, myPassWord)

url = paste("https://apis.tdameritrade.com/apps/100/Quote;jsessionid=", sessionid,"?source=TSLU&symbol=", ticker, sep="" )
xmlResult = postForm(url,  style = "post")
theQuote <-xmlToList(gsub("-", ".", xmlResult)) 

if (is.null(theQuote$quote.list$quote$ask))
	theQuote$quote.list$quote$ask <- NA
if (is.null(theQuote$quote.list$quote$bid))
	theQuote$quote.list$quote$bid <- NA
if (is.null(theQuote$quote.list$quote$last))
	theQuote$quote.list$quote$last <- NA
if (is.null(theQuote$quote.list$quote$open))
	theQuote$quote.list$quote$open <- NA
if (is.null(theQuote$quote.list$quote$close))
	theQuote$quote.list$quote$close <- NA
	
quote.df <- with(theQuote$quote.list$quote, data.frame(time=Sys.time(), ticker=ticker,bid=bid,ask=ask,last=last, open=open,close=close))
write.table(quote.df,quoteFile, append=T, sep=",",row.names=F, col.names=F)