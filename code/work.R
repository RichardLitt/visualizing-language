# Load in a script that defines three distance functions
# and a degrees-to-radians function.
# (see http://www.r-bloggers.com/great-circle-distance-calculations-in-r/)
source("gcd.R")

# Read in the data and language info.
wals_data = read.table("datapoints.csv",header=TRUE,sep=",")
languages = read.table("languages.csv",header=TRUE,sep="\t",quote="\"")

# Change the lat/long measurements to radians.
languages$longitude.rad = deg2rad(languages$longitude)
languages$latitude.rad = deg2rad(languages$latitude)

# Figure out the size of the dataset
size = nrow(languages)


# Prepare our matrix of distances.
distances=matrix(NA,nrow=size,ncol=size)
rownames(distances) = languages$wals.code
colnames(distances) = languages$wals.code

# This for loop takes about 2.5 minutes on my machine.
# Theoretically, it should be faster using an *apply
# function, but I haven't actually been able to improve
# the speed. Go figure.
for(l1 in 1:size) {
	for(l2 in l1:size) {
#		compare l1 with l2
		distances[l1,l2] = gcd.hf(languages$longitude.rad[l1],languages$latitude.rad[l1],languages$longitude.rad[l2],languages$latitude.rad[l2])
	}
}

# Our distances matrix now has distances (km) for each language
# pair; a diagonal of 0s, and the other half is full of NAs.
# Output to csv:
write.table(distances,"distances.csv",quote=FALSE,sep="\t")