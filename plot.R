a = read.csv("~/Downloads/archive/430001-432999.csv")
a[,5] = as.POSIXct(a[,5], format="%Y-%m-%d %H:%M:%OS")
a$Unix_Time = as.numeric(a[,5])
a$Month = format(trunc(a$Time, units = "months"), format = "%Y-%m")
a$Day = format(trunc(a$Time, units = "days"), format = "%d")
a$Hour = format(trunc(a$Time, units = "hours"), format = "%H")
a$Minute = format(trunc(a$Time, units = "mins"), format = "%M")
sorted.a = a[with(a, order(Height, Unix_Time)),]

library(stringr)
Sum = str_extract(sorted.a$Sum, "[0-9]*[0-9.][0-9]*")

x=Sum[1:100000]

pdf(file="myplot.pdf")
plot(x,type="l")
dev.off()
