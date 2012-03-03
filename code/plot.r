# From Simon Greenhill.
# Should calculate heat map from a distance matrix

require(RColorBrewer)

aa54 = read.delim('AA54 2101 matrix.txt')    # load data
# tidy up data a bit.
rownames(aa54) <- aa54$X
aa54 <- aa54[,2:55]
colnames(aa54) <- rownames(aa54)

# convert to a data matrix (just an R data structure - no data changes)
aa54 <- as.matrix(as.dist(aa54))

pdf("aa54.plot.pdf")
heatmap(aa54, symm=TRUE,  Colv=NA, Rowv=NA, col=brewer.pal(9, "Blues"), margins=c(5,10))
dev.off()

# smaller one
aa36 = read.delim('aa36 matrix.txt')# tidy up data a bit.

#aa36 <- aa36[order(aa36$X)]
rownames(aa36) <- aa36$X
aa36 <- aa36[,2:37]
colnames(aa36) <- rownames(aa36)
aa36 <- as.matrix(as.dist(aa36))

par(mfrow=c(2,1))
pdf("aa36.plot.pdf")
heatmap(aa36, symm=TRUE, Colv=NA, Rowv=NA, col=brewer.pal(9, "Blues"), margins=c(5,10))
dev.off()

# trees
require(ape)
pdf("aa36.njtree.pdf")
plot(nj(aa36))
dev.off()

pdf("aa54.njtree.pdf")
plot(nj(aa54))
dev.off()
