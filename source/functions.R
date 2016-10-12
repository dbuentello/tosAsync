#tos functions
convert <- function(dataframe) {
	if (dDebug) print("convert")
	class.data <- sapply(dataframe, class)
	factor.vars <- class.data[class.data == "factor"]
	for (colname in names(factor.vars)) {
		dataframe[, colname] <- as.character(dataframe[, colname])
	}
	return(dataframe)
}

TDAKeepAlive <- function(source,sessionid){
	if (dDebug) print("TDAKeepAlive")
	url = paste("https://apis.tdameritrade.com/apps/KeepAlive;jsessionid=", sessionid,"?source=",source,sep="")
	if (dDebug) print(url)		
	txtResult = postForm(url,  style = "post")
	return(txtResult)
}
TDALogin = function(source, version, user, pass, ..., url) {
	if (dDebug) print("TDALogin")
	url = paste("https://apis.tdameritrade.com/apps/100/LogIn?", 
		"source=", source, "&version=", version, sep = "")
	xmlResult = postForm(url, userid = user, password = pass, 
		source = source, version = version, style = "post")
	#	resultsOK(xmlResult)
	return(xmlToList(gsub("-", ".", xmlResult))$xml.log.in$session.id)
}

getOrder = function(accountid, action="buy", expire="moc", ordtype="market", quantity="1",symbol="AAPL"){
	if (dDebug) print("TDAOrderSTring")
	quantity <- round(facToNum(quantity))
	orderString <- paste("accountid=",accountid,"~action=",action,"~expire=",expire,"~ordtype=",ordtype,"~quantity=",quantity,"~symbol=",symbol, sep="")
	return(orderString)
}


#	https://apis.tdameritrade.com/apps/100/EquityTrade source=<##SourceID#>&orderstring=<#ORDERSTRING#>


TDATrade <- function(sessionid, tdsource="TSLU", orderString, logFile,..., url){
	if (dDebug) print("TDATrade")
	url = paste("https://apis.tdameritrade.com/apps/100/EquityTrade;jsessionid=", sessionid, "?source=", tdsource, "&orderstring=", orderString, sep="" )
	
	if (dDebug) print(url)		
	xmlResult = postForm(url,  style = "post")
	theTrade <- xmlToList(gsub("-", ".", xmlResult))
	
	if (is.null(theTrade$order.wrapper$error)){
	attach(theTrade$order.wrapper$order)
		logEvent(logFile, action, account.id, quantity, order.type)
    		notify("TDATrader", paste(action,quantity,order.type,"account",account.id))
    detach(theTrade$order.wrapper$order)
    } else 
    	   notify("TDATrader", theTrade$order.wrapper$error)

	return(theTrade)
}
TDAQuote = function(sessionid,symbol="AAPL"){
	if (dDebug) print("TDAQuote")
	url = paste("https://apis.tdameritrade.com/apps/100/Quote;jsessionid=", sessionid,"?source=TSLU&symbol=", symbol, sep="" )
	if (dDebug) print(url)		
	xmlResult = postForm(url,  style = "post")
	theQuote <-xmlToList(gsub("-", ".", xmlResult)) 
	ask <- facToNum(theQuote$quote.list$quote$ask)
	return(ask)
}


facToNum <- function(theFact) return(as.numeric(as.character(theFact)))
getAccount = function(sessionid, accountid, tdSource="TSLU", sl="AAPL") {
	if (dDebug) print("getAccount")
	url = paste("https://apis.tdameritrade.com/apps/100/BalancesAndPositions;jsessionid=", sessionid, "?source=", tdSource, "&symbol=", paste(sl, collapse = ","),"&accountid=",accountid, sep = "")
	if (dDebug) print(url)
	xmlResult = postForm(url, style = "post")
	#	resultsOK(xmlResult)
	return(xmlToList(gsub("-", ".", xmlResult)))
}



# getStocks <- function(account) {
	# if (dDebug) print("getStocks")
	# stocks <- account$positions$stocks
	# attributes(stocks$position)
	# x <- data.frame(matrix(unlist(stocks, recursive=F), nrow=length(stocks), byrow = T))
	# xx <- subset(x, select = c(X1, X2, X8, X9, X10,  X31))
	# x10 <- data.frame(matrix(unlist(X10)))
	# names(xx) <- c("quantity","ticker","mark","type","avePrice", "percent")
	# xxx <- convert(xx)
	# xxx$quantity <- as.numeric(xxx$quantity)
	# xxx$mark <- as.numeric(xxx$mark)
	# xxx[xxx$quantity < 1, ]$quantity <- -xxx[xxx$quantity < 1,]$quantity * 1000
	# return(xxx)
# }
# getStocks <- function(account) {
	# if (dDebug) print("getStocks")
	# stocks <- account$positions$stocks
	# attributes(stocks$position)
	# x <- data.frame(matrix(unlist(stocks), nrow=length(stocks), byrow = T))
	# xx <- subset(x, select = c(X1, X2, X8, X9, X10,  X31))
	# names(xx) <- c("quantity","ticker","mark","type","avePrice", "percent")
	# xxx <- convert(xx)
	# xxx$quantity <- as.numeric(xxx$quantity)
	# xxx$mark <- as.numeric(xxx$mark)
	# xxx[xxx$quantity < 1, ]$quantity <- -xxx[xxx$quantity < 1,]$quantity * 1000
	# return(xxx)
# }
# getStocks2 <- function(account) {
	# if (dDebug) print("getStocks2")
	# stocks <- account$positions$stocks
	# attributes(stocks$position)
	# x <- data.frame(matrix(unlist(stocks,recursive=
	# F), nrow=length(stocks), byrow = T))
	# xx <- subset(x, select = c(X2, X3, X5,X6,X7,X8))
	# names(xx) <- c("quantity","ticker","mark","avePrice", "value")
	# xxx <- convert(xx)
	# xxx$quantity <- as.numeric(xxx$quantity)
	# xxx$mark <- as.numeric(xxx$mark)
	# xxx[xxx$quantity < 1, ]$quantity <- -xxx[xxx$quantity < 1,]$quantity * 1000
	# return(xxx)
# }

getOptions <- function(account) {
	options <- account$positions$options
	attributes(options$position)
	x <- data.frame(matrix(unlist(options,recursive=T), nrow=length(options), byrow = T))
	y <- x[,c(36,20,49)]
	names(y) <- c("symbol","theta","BP")
	return(y)
}
convertChain <- function(chain){
	if (dDebug) print("convertChain")
	chaindf <- chain$option.chain.result
	attributes(chaindf)
	optionStartAt <- 16
	optionEndAt <- length(chaindf)
	chaindf <- chaindf[optionStartAt:optionEndAt]
	x <- data.frame(matrix(unlist(chain, recursive=F), nrow=length(chaindf), byrow=F))
	}
getBalances <- function(account){
	if (dDebug) print("getBalances")
	balances <- account$balance
	x <- data.frame(matrix(unlist(balances), nrow=1,byrow=T))
	xx <- subset(x, select = c(X1, X5, X27, X49))
	names(xx) <- c("acctNum", "cash", "availTrade", "shortValue")
	return(xx)
	}
	
getPosition <- function(stocks, ticker="AAPL"){
	if (dDebug) print("getPosition")
	for (i in 1:length(stocks)){
		if (stocks[[i]]$quote$symbol==ticker)
			theStock <- stocks[[i]]
		}
	stock.df<- with(theStock, 
	data.frame(security$symbol, quantity, average.price, current.value, quote$last, quote$bid, quote$ask))
	return(stock.df)
	}
	
getMaxShares <- function(stockBuyingPower, quote.ask, slippage){
	if (dDebug) print("getMaxShares")
	maxShares <- round(facToNum(stockBuyingPower)/facToNum(quote.ask))
 	tryShares <- maxShares - round(maxShares*slippage)
 	return(tryShares)
}


cancelOrder <- function(orderid, accountid,sessionid) {
	url <- paste("https://apis.tdameritrade.com/apps/100/OrderCancel?source=TSLU;jsessionid=", sessionid,"?orderid=",orderid,sep="")
	if (dDebug) print(url)
	xmlResult = postForm(url,  style = "post")
	return(xmlToList(gsub("-", ".", xmlResult)))
}



logEvent <- function(theFile, action, accountid, quantity, ordertype) {
		theText <- 
		paste(accountid, action, ordertype, quantity,Sys.time(),sep=",")
		write.table(theText, theFile, append=T,row.names=F,col.names=F)
	}


	
acctV <- function(accountid) {
	account <- getAccount(sessionid,accountid)
	return(round(facToNum(account$balance$account.value$current)))
}



#simple notify
notify <- function(msg="Operation complete",title = "R GUI",sound = 'default') {
	sound = 'default'
    sender <- activate <- "org.R-project.R"
    theCommand <- sprintf("/usr/local/bin/terminal-notifier -title '%s' -message '%s' -sender %s -activate %s -sound %s",title, msg, sender, activate, sound )    
  x <-  system(theCommand,ignore.stdout=F, ignore.stderr=F, wait=T)
}
	