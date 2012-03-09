require("RColorBrewer")
source("subs.R")

family_data = read.table("data/w_family_data.csv",sep=",",quote="\"",header=F,skip=2)

width = ncol(family_data)
names(family_data) = c("source.family","source.family","source.subfam","target.family","target.family","target.subfam","lat","long","wals_code",10:width)

# Grab the Niger-Congo subfamily
family_data = family_data[which(family_data$target.family=="Niger-Congo"),]

# Let's determine which features to plot. We want to use
# the features with the fewest most data, i.e. fewest NAs 
# in them. First, we take the relevant columns (11 and up)
# and ensure that they are numeric.
family_data[,10:width] = sapply(family_data[,10:width],as.numeric)

# Normalize all the feature columns.
family_data[,10:width] = scale(family_data[,10:width])

# Sort the languages from west to east
family_data = family_data[order(family_data$long),]

#This function sorts all the columns of the data
# by how many NAs they have. The numbers in this
# vector are the proportion of the column that is
# NA.
sorted.features = sort(colMeans(is.na(family_data[,10:width])))

# Transpose the data and remove non-feature columns
data.subset = t(family_data[,11:ncol(family_data)])

# Make sure we have the 15-best represented features, and
# throw out invariant features. Normalize the feature values.
best.features = names(sorted.features[1:15])

nlevels = rep(NA,15)
difference = Inf
index = 15
while(difference!=0) {
	new.best.features = best.features
	for(i in 1:length(best.features)) {
		feature.row = data.subset[best.features[i],]
		nlevels[i] = length(levels(as.factor(feature.row)))
		if(nlevels[i]==1) {
			new.best.features = new.best.features[-i]
		} else {
			data.subset[best.features[i],] = as.numeric(factor(data.subset[best.features[i],],labels=1:nlevels[i]))
		}
	}

	difference = 15-length(new.best.features)
	if(difference > 0) {
		best.features = c(new.best.features,names(sorted.features[(index+1):(index+difference)]))
		index = index+difference
	}
}

# Get rid of all of the other features
data.subset = data.subset[(best.features),]

# Set the names of the languages and the features.
colnames(data.subset) = get.language(family_data$wals_code)
rownames(data.subset) = get.feature(best.features,shift=0)

# Output the file
pdf("graphs/graph3nigercongo.pdf")
par(oma=c(2,2,2,15))
heatmap(data.subset,Rowv=NA,Colv=NA,scale="none",col=brewer.pal(max(nlevels),"Set1"))
dev.off()