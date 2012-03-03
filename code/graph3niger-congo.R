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

# Remove the V's from the colnames
#names(sorted.features) = substr(names(sorted.features),2,4)

# Get the 15 best-represented features
best.features = sorted.features[1:15]

# Extract the features, label the data
data.subset = t(family_data[,as.numeric(names(best.features))])
colnames(data.subset) = get.language(family_data$wals_code)
rownames(data.subset) = get.feature(names(best.features),shift=0)

# Quick fix for names.
rownames(data.subset)[1] = "Order of O & V and the Order of RC & N"
rownames(data.subset)[11] = "Position of Neg Morphs in SOV Languages"

par(oma=c(2,2,2,15))
heatmap(data.subset,Rowv=NA,Colv=NA,scale="none")