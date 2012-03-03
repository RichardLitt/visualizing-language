source("subs.R")

geo_data = read.table("data_new/geo-clean-30-datapoints-r-500-fixed.csv",sep="\t",quote="\"",header=T)

# Let's determine which features to plot. We want to use
# the features with the fewest most data, i.e. fewest NAs 
# in them. First, we take the relevant columns (11 and up)
# and ensure that they are numeric.
width = ncol(geo_data)
geo_data[,11:width] = sapply(geo_data[,11:width],as.numeric)

# Normalize all the feature columns.
geo_data[,11:width] = scale(geo_data[,11:width])

# Change the feature column names to simple numbers. This
# aids the lookup process later.
names(geo_data)[11:width] = as.character((11:width))

#This function sorts all the columns of the data
# by how many NAs they have. The numbers in this
# vector are the proportion of the column that is
# NA.
sorted.features = sort(colMeans(is.na(geo_data[,11:width])))

# Remove the V's from the colnames
#names(sorted.features) = substr(names(sorted.features),2,4)

# Get the 15 best-represented features
best.features = sorted.features[1:15]


make.feature.subset.heatmap = function(language,path) {
# Get the subset of the features we want, relative to
# the center language we want
	data.subset = geo_data[which(geo_data$center.language==language),c(1:10,(as.numeric(names(best.features))))]

# Find the family information; this will allow us
# to plot the right colors in the heatmap.
	colcolors = sapply(data.subset$family,function(x) if(x=="Border") {"pink"} else if(x=="Lower Sepik-Ramu") {"brown"} else if(x == "Marind") {"yellow"} else if(x == "Sentani") {"orange"} else if (x == "Sepik") {"blue"} else if(x=="Skou") {"green"} else if(x =="Torricelli") {"purple"} else if(x == "Trans-New Guinea") {"red"} else {"white"})

# Remove the non-feature columns and transpose the data
	data.subset = t(data.subset[,11:ncol(data.subset)])

# Set the names of the columns and rows
	colnames(data.subset) = get.language(geo_data$wals_code[as.numeric(colnames(data.subset))])
	rownames(data.subset) = get.feature(names(best.features),shift=10)

# And voila!
	pdf(path)
	par(oma=c(2,2,2,16))
	heatmap(data.subset,Rowv=NA,Colv=NA,ColSideColors=colcolors)
	dev.off()
}

make.feature.subset.heatmap("ala","graphs/graph2ala.pdf")
make.feature.subset.heatmap("arp","graphs/graph2arp.pdf")
make.feature.subset.heatmap("awt","graphs/graph2awt.pdf")
make.feature.subset.heatmap("kew","graphs/graph2kew.pdf")
make.feature.subset.heatmap("kob","graphs/graph2kob.pdf")
make.feature.subset.heatmap("yim","graphs/graph2yim.pdf")


#rownames(data.subset) = paste("F",names(best.features),sep="")
#pdf("graphs/graph2wnumbers.pdf")
#par(oma=c(2,2,2,2))
#heatmap(data.subset,Rowv=NA,Colv=NA)
#dev.off()