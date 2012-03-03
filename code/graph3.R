source("subs.R")

genus_data = read.table("data/w_genus_data.csv",sep=",",quote="\"",header=F,skip=2)

width = ncol(genus_data)
names(genus_data) = c("source.family","source.genus","source.subfam","target.family","target.genus","target.subfam","lat","long","wals_code",10:width)

# Let's determine which features to plot. We want to use
# the features with the fewest most data, i.e. fewest NAs 
# in them. First, we take the relevant columns (11 and up)
# and ensure that they are numeric.
genus_data[,10:width] = sapply(genus_data[,10:width],as.numeric)

# Normalize all the feature columns.
genus_data[,10:width] = scale(genus_data[,10:width])

# Sort the languages by north to south
genus_data = genus_data[order(genus_data$lat),]

#This function sorts all the columns of the data
# by how many NAs they have. The numbers in this
# vector are the proportion of the column that is
# NA.
sorted.features = sort(colMeans(is.na(genus_data[,10:width])))

# Remove the V's from the colnames
#names(sorted.features) = substr(names(sorted.features),2,4)

# Get the 15 best-represented features
best.features = sorted.features[1:15]

# Extract the features, label the data
data.subset = t(genus_data[,as.numeric(names(best.features))])
colnames(data.subset) = get.language(genus_data$wals_code)
rownames(data.subset) = get.feature(names(best.features),shift=0)

par(oma=c(2,2,2,16))
heatmap(data.subset,Rowv=NA,Colv=NA,scale="none")
