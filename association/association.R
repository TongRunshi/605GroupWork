library(data.table)
options(scipen = 8)

price = fread("BTC_USD Bitfinex Historical Data.csv")[319:1, ]
transection = fread("sum_day.csv")[c(-1, -321), -1]


transection$Date = as.POSIXct(transection$V1, format="%Y-%m-%d %H:%M:%OS")
transection$Month = format(trunc(transection$Date, units = "months"), format = "%Y-%m")
price$Month = transection$Month
dat = data.frame(Sum = transection$sum, price[, c(2:5,7)], Month = price$Month)
dat$Change.. = as.numeric(sub("%", "", dat$Change..))/100
rm(price, transection)

arg=(commandArgs(trailingOnly=TRUE))
a = read.csv(arg[1])

dat = dat[dat$Month == a, ]

tab = data.frame(price = vector(), open = vector(), high = vector(), 
                 low = vector(), change = vector())

for (i in 1:5) {
  test = cor.test(dat$Sum, dat[,i+1], method = "spearman")
  tab[1,i] = test$estimate
  tab[2,i] = test$p.value
}
rownames(tab) = c("Spearman rho", "P-Value")

write.table(tab, a)
