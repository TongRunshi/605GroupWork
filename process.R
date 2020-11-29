arg=(commandArgs(trailingOnly=TRUE))
data = read.csv(arg[1])

require(ismev)
n=length(data[,3])
hour=floor(n/60)
fac=rep(1:hour,each=60)
n=length(fac)
aaa=data[1:n,3]
#print(aaa)
#print(length(fac))
Q=as.numeric(tapply(aaa,fac,max))

number=floor(length(Q)/180)
alpha_trail=vector(length=number)
for (i in 1:number){
  fifi=gev.fit(Q[((i-1)*180+1):(i*180)],show=F)
  alpha_trail[i]=fifi$mle[3]
}

write.csv(alpha_trail,file=paste("alpha",arg[1],".csv"))

