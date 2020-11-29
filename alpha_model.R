
tar -xzf R402.tar.gz
tar -xzf packages.tar.gz

export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

data=read.csv("alpha.csv")
alpha=data$V2
pdf(file="alpha.pdf")
plot(alpha,type="l")
dev.off()

#what model should we use for alpha?

#require(
