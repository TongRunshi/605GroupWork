a = read.csv("~/Downloads/archive/430001-432999.csv")
a[,5] = as.POSIXct(a[,5], format="%Y-%m-%d %H:%M:%OS")
a$Unix_Time = as.numeric(a[,5])
a$Month = format(trunc(a$Time, units = "months"), format = "%Y-%m")
a$Day = trunc(a$Time, units = "days")
a$Hour = trunc(a$Time, units = "hours")
a$Minute = trunc(a$Time, units = "mins")
sorted.a = a[with(a, order(Height, Unix_Time)),]

library(stringr)
Sum = str_extract(sorted.a$Sum, "[0-9]*[0-9.][0-9]*")
Sum = as.numeric(Sum)

x=Sum[1:100000]
n=length(x)
fac=factor(rep(1:1000,each=(n/1000)))
Q=tapply(x,fac,max)

require(ismev)

#static gev
fit_staticgev=gev.fit(Q)
#location, scale and shape
shape=fit_staticgev$mle[3]
#so alpha=1/shape
alpha=1/shape

require(bizdays)
cal <- create.calendar(name = "cal", weekdays = c("saturday", "sunday"), start.date = "2001-1-1", end.date = "2020-9-1")
date=bizseq("2001-1-1", "2020-9-1", cal)

#moving window gev   window length=300
alpha_movingwindow=rep(0,length(Q))
for (t in 150:(length(Q)-150)){
  fifi=gev.fit(Q[(t-149):(t+150)],show = FALSE)
  alpha_movingwindow[t]=1/(fifi$mle[3])
}
plot(date[150:(length(Q)-150)],alpha_movingwindow[150:(length(Q)-150)],ylim=c(-10,2),type="l",xlab="time",ylab="Tail index",main="Moving Window Estimation of Tail Index")
abline(h=alpha,col="red")
legend("topright", legend=c("Moving Window GEV", "Static GEV"),
       col=c("black", "red"), lty=1,cex=0.7)
