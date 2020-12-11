rm(list = ls())

require(aTSA) #adf.test()
require(forecast) #auto.arima()
require(xts)
require(vars)

trans = read.csv('sum_day.csv')
trans = xts(trans$sum[-length(trans)][-1], as.Date(trans$V1[-length(trans)][-1], format='%Y-%m-%d'))
length(trans)
par(mfrow = c(1,1))
plot.xts(trans)
exchange = read.csv('BTC_USD.csv')
exchange <- exchange[which(exchange$Date=="2016-09-16"):which(exchange$Date=="2017-07-31"),]
exchange = xts(exchange$Closing.Price..USD., as.Date(exchange$Date, format='%Y-%m-%d'))
plot.xts(exchange)

# trans
adf.test(as.numeric(trans))
par(mfrow = c(2,2))
acf(trans, main = expression("Series W"[t]))
pacf(trans, main = expression("Series W"[t]))


# trans.dif
trans.dif = diff(trans)[-1]
par(mfrow = c(1,1))
plot.xts(trans.dif, type = 'l')
trans.dif = trans.dif/1000
adf.test(as.numeric(trans.dif), nlag = 10)
acf(trans.dif, main = expression(paste("Series ", Delta*"W"[t])))
pacf(trans.dif, main = expression(paste("Series ", Delta*"W"[t])))


#exchange
adf.test(as.numeric(exchange))
acf(exchange, main = expression("Series P"[t]))
pacf(exchange, main = expression("Series P"[t]))

#exchange.dif
ex.dif = diff(exchange)[-1]
adf.test(as.numeric(ex.dif))

#VAR
Data = ts.union(as.ts(ex.dif), as.ts(trans.dif))
sum(is.na(Data))
length(ex.dif)
length(trans.dif)
mod = VAR(Data, p = 4, type = "const")
VARselect(Data, lag.max = 8, type = 'const')[['selection']]


# var.trans
par(mfrow = c(2,1))
plot.ts(trans.dif, ylab = expression(paste(Delta*"W"[t])), 
        main = expression(bold(paste("Fitted VAR for Series ", Delta*"W"[t]))),
        cex.lab = 1.25, cex.main = 1.25)
points(mod$varresult$as.ts.trans.dif.$fitted.values, type = 'l', col = 2, lty = 2)

# var.exchange
plot.ts(ex.dif, ylab = expression(paste(Delta*"P"[t])), 
        main = expression(bold(paste("Fitted VAR for Series ", Delta*"P"[t]))),
        cex.lab = 1.25, cex.main = 1.25)
points(mod$varresult$as.ts.ex.dif.$fitted.values, type = 'l', col = 2, lty = 2)

#forecast
fc = forecast(mod)
plot(fc$forecast$as.ts.ex.dif., ylab = expression(paste(Delta*"W"[t])), xlab = "Time", 
     main = expression(bold(paste("Forecasted Values for Series ", Delta*"W"[t]))),
     cex.lab = 1.25, cex.main = 1.25)
plot(fc$forecast$as.ts.trans.dif., ylab = expression(paste(Delta*"P"[t])), xlab = "Time", 
     main = expression(bold(paste("Forecasted Values for Series ", Delta*"P"[t]))),
     cex.lab = 1.25, cex.main = 1.25)

