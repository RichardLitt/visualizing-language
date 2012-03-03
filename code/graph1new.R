library(ggplot2)

require(maps)

geo_yim = read.table("data/geo-yim",sep=",",quote="\"",header=T)

geo_yim$color_scaling = sapply(geo_yim$percentage.filled,function(x) if(x >= 0.5) { 255*1 } else if(x >= 0.25) { 255*0.75 } else if (x >= 0.1 ) { 255*0.5 } else { 255*0.25 } )

families = c("Trans-New Guinea","Austronesian","Sepik","Torricelli","Other")

geo_tg = geo_yim[geo_yim$genus==families[1],]
geo_au = geo_yim[geo_yim$genus==families[2],]
geo_sp = geo_yim[geo_yim$genus==families[3],]
geo_tr = geo_yim[geo_yim$genus==families[4],]
geo_ot = geo_yim[geo_yim$genus!=families[1] & geo_yim$genus!=families[2] & geo_yim$genus!=families[3] & geo_yim$genus!=families[4],]


# Columns coordinates 1 and 2 are long and lat respectively
yimx = geo_yim$coordinate.2[which(geo_yim$wals.code=="yim")]
yimy = geo_yim$coordinate.1[which(geo_yim$wals.code=="yim")]


# Refactor family into fewer categories
geo_yim$newfam = sapply(geo_yim$genus,function(x) if(x!=families[1] & x!=families[2] & x!=families[3] & x!=families[4]) { "Other" } else { as.character(geo_yim$genus[x]) } )

# Refactor percentage into strings
#geo_yim$newperc = sapply(geo_yim$percentage.filled,function(x) paste((x*100),"%",sep=""))


geo_au = geo_yim[geo_yim$genus==families[2],]
geo_sp = geo_yim[geo_yim$genus==families[3],]
geo_tr = geo_yim[geo_yim$genus==families[4],]
geo_ot = geo_yim[geo_yim$genus!=families[1] & geo_yim$genus!=families[2] & geo_yim$genus!=families[3] & geo_yim$genus!=families[4],]



p = ggplot(geo_yim,aes(coordinate.2,coordinate.1))
p + geom_point(aes(size=geo_yim$percentage.filled,colour=geo_yim$newfam)) + scale_x_continuous("Latitude") + scale_y_continuous("Longitude") + scale_color_hue(l=50) + labs(size = "Feature density", colour = "Language Family") + opts(panel.grid.major=theme_line(colour=NA), panel.grid.minor=theme_line(colour=NA),axis.line=theme_segment(colour="black",linetype="solid",size=0.8),axis.text.x=theme_text(size=11),axis.text.y=theme_text(size=11),panel.background=theme_rect(colour=NA))


ngmap = data.frame(map("world", c("papua new guinea","indonesia"), plot=FALSE,xlim=c(138,148),ylim=c(-9,-2))[c("x","y")])
ng <- qplot(x, y, data=ngmap, geom="path")

#p <- p + ggpath(p, data = data.frame(map("Papua New Guinea", plot=FALSE)[c("x","y")]), aes = list(x = x, y = y))

p <- p + geom_path(data = ngmap, aes(x=y,y=y))


+ opts(legend.justification="left", legend.position=c(0.75, 0.75)))


colour=rgb(0,0,0,geo_tg$color_scaling,maxColorValue=255))

pdf("graphs/graph1.pdf")

plot(geo_yim$coordinate.2,geo_yim$coordinate.1,xlab="Latitude",ylab="Longitude",type="n")

points(geo_tg$coordinate.2,geo_tg$coordinate.1,col=rgb(0,0,0,geo_tg$color_scaling,maxColorValue=255),pch=15)
points(geo_au$coordinate.2,geo_au$coordinate.1,col=rgb(0,0,0,geo_au$color_scaling,maxColorValue=255),pch=16)
points(geo_sp$coordinate.2,geo_sp$coordinate.1,col=rgb(0,0,0,geo_sp$color_scaling,maxColorValue=255),pch=17)
points(geo_tr$coordinate.2,geo_tr$coordinate.1,col=rgb(0,0,0,geo_tr$color_scaling,maxColorValue=255),pch=18)
points(geo_ot$coordinate.2,geo_ot$coordinate.1,col=rgb(0,0,0,geo_ot$color_scaling,maxColorValue=255),pch=7)

# Add a circle of approximately 500km radius
symbols(yimx,yimy,circles=4.96,lty=2,add=T,inches=F)

# Add an overlay of the landmass, although it doesn't
# quite line up :(
#map("world","papua new guinea",add=TRUE)
#map("world","indonesia",add=TRUE)

legend("topright",inset=c(0.15,0),pch=c(15,16,17,18,7),c("Trans-NNG","Austronesian","Sepik","Torricelli","Other"),bg="white")
legend("topright",inset=c(0,0.15),pch=15,c("50%+","25%+","10%+","0%+"),col=rgb(0,0,0,c(255,255*0.75,255*0.5,255*0.25),maxColorValue=255),bg="white")

dev.off()
