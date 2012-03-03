feature.list = read.table("features.csv",header=T,sep=",",stringsAsFactors=F)
language.list = read.table("languages.csv",header=T,sep="\t",quote="\"",stringsAsFactors=F)

# Given a particular column in a dataset, find what
# feature it corresponds to. Can also shift, if
# the dataset still has the language and distance
# columns attached.
get.feature = function(column,shift=0) {
	column=as.numeric(column)
	return(feature.list[column-shift,2])
}

# Given a particular language code, find the full
# language name
get.language = function(language) {
	names = rep(NA,length(language))
	for(i in 1:length(language)) {
		thisname = language.list[which(language.list[,1]==language[i]),2]
		if(length(thisname)>0) {
			names[i] = thisname
		} else {
			names[i] = NA
		}
	}
	return(names)
}


remove.empty = function(data.subset) {
	# Remove empty columns
	data.subset = data.subset[,which(colMeans(is.na(data.subset)) < 1)]
	# Remove empty rows
	data.subset = data.subset[which(rowMeans(is.na(data.subset)) < 1),]
	return(data.subset)
}
