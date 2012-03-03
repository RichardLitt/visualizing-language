source("subs.R")
library(reshape)

clean.data = read.table("data/geo-clean-30-datapoints-r-500",sep=",",header=F)


make.heatmap = function(data,language,features) {
	shifted.features = features+4
	data.subset = t(data[clean.data$V1==language,shifted.features])
	colnames(data.subset) = get.language(data$V4[data$V1==language])
	rownames(data.subset) = get.feature(shifted.features)
	data.subset = remove.empty((data.subset))
# Rescale the data
#	data.subset.m = melt(data.subset)
#	data.subset.m = ddply(data.subset.m, .(variable), transform, #rescale = rescale(value))
	par(oma=c(2,2,2,10))
	heatmap((data.matrix(data.subset)),Rowv=NA,Colv=NA,main=get.language(language),col=heat.colors(12),scale="none")
#	heatmap((data.matrix(data.subset)),main=get.language(language),col=heat.colors(12),scale="none")

#	image(t(data.matrix(data.subset)))
}


pdf("data/ala.pdf")
make.heatmap(clean.data,"ala",1:14)
dev.off()

pdf("data/arp.pdf")
make.heatmap(clean.data,"arp",1:14)
dev.off()

pdf("data/awt.pdf")
make.heatmap(clean.data,"awt",1:14)
dev.off()

pdf("data/kew.pdf")
make.heatmap(clean.data,"kew",1:14)
dev.off()

pdf("data/kob.pdf")
make.heatmap(clean.data,"kob",1:14)
dev.off()

pdf("data/yim.pdf")
make.heatmap(clean.data,"yim",1:14)
dev.off()