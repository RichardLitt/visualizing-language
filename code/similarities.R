# Work in progress, possibly not even relevant.

# Calculating the similarities between languages

language.difference = function(language1,language2,threshhold = 5,feature.range=2:193) {
#	nfeatures = ???
	difference = rep(NA,length(feature.range))
	totaldiff = 0
	for(i in feature.range) {
		difference[i] = abs(language1[i] - language2[i])
		if(!is.na(difference[i])) {
			totaldiff = totaldiff + 1
		}
	}
	if(totaldiff < threshhold) {
		return(NA)
	}
	meandiff = sum(as.numeric(difference),na.rm=T) / totaldiff
	return(meandiff)
}

differences=matrix(NA,nrow=size,ncol=size)
rownames(differences) = rownames(locations)
colnames(differences) = rownames(differences)

t = Sys.time()
for(l1 in 1:size) {
	for(l2 in l1:size) {
#		compare l1 with l2
		differences[l1,l2] = language.difference(wals_data[l1,],wals_data[l2,],threshhold = 1, feature.range=2:14)
	}
}
Sys.time() - t
