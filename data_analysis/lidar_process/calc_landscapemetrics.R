library(raster)
library(rgdal)
library(sf)
library(dplyr)

library(spatialEco)
library(landscapemetrics)

library(reshape)

source("D:/Koma/GitHub/PhDPaper2_wetlandniche/src/bird_data_process/Func_ProcessOcc.R")

##

workingdir="D:/Koma/_PhD/Sync/_Amsterdam/_PhD/Chapter3_wetlandniche/3_Dataprocessing/Niche_v9/"
setwd(workingdir)

lidarfile="D:/Koma/_PhD/Sync/_Amsterdam/_PhD/Chapter3_wetlandniche/2_Dataset/lidar/wh_waterfilt/lidar_metric_perc_95_normalized_height_masked_all.tif"

lidar=stack(lidarfile)
proj4string(lidar) <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

GrW=read.csv("GrW_territory_intersected.csv")
GrW_shp=CreateShape(GrW)

KK=read.csv("KK_territory_intersected.csv")
KK_shp=CreateShape(KK)

Sn=read.csv("Sn_territory_intersected.csv")
Sn_shp=CreateShape(Sn)

Bgr=read.csv("Bgr_territory_intersected.csv")
Bgr_shp=CreateShape(Bgr)

# Reclassify
height_class=reclassify(lidar, c(-Inf,1,1,1,3,2,3,5,3,5,Inf,4))
#writeRaster(height_class,"height_classified.tif",overwrite=TRUE)

# calculate landscape metrics

#200m
my_metric_npte_GrW2 = sample_lsm(height_class, GrW_shp,size=200,level = "class", metric = c("np","te"),plot_id=GrW_shp@data$rID,return_raster=TRUE,count_boundary = FALSE,directions = 8)
df_GrW2=cast(my_metric_npte_GrW2 ,plot_id~metric+class)

my_metric_npte_KK2 = sample_lsm(height_class, KK_shp,size=200,level = "class", metric = c("np","te"),plot_id=KK_shp@data$rID,return_raster=TRUE,count_boundary = FALSE,directions = 8)
df_KK2=cast(my_metric_npte_KK2 ,plot_id~metric+class)

my_metric_npte_Sn2 = sample_lsm(height_class, Sn_shp,size=200,level = "class", metric = c("np","te"),plot_id=Sn_shp@data$rID,return_raster=TRUE,count_boundary = FALSE,directions = 8)
df_Sn2=cast(my_metric_npte_Sn2 ,plot_id~metric+class)

my_metric_npte_Bgr2 = sample_lsm(height_class, Bgr_shp,size=200,level = "class", metric = c("np","te"),plot_id=Bgr_shp@data$rID,return_raster=TRUE,count_boundary = FALSE,directions = 8)
df_Bgr2=cast(my_metric_npte_Bgr2 ,plot_id~metric+class)

# add to the intersected data
GrW_wlandsc2=merge(GrW,df_GrW2, by.x=c('rID'), by.y=c('plot_id'))
write.csv(GrW_wlandsc2,"GrW_wlandsc.csv")

KK_wlandsc2=merge(KK,df_KK2, by.x=c('rID'), by.y=c('plot_id'))
write.csv(KK_wlandsc2,"KK_wlandsc.csv")

Sn_wlandsc2=merge(Sn,df_Sn2, by.x=c('rID'), by.y=c('plot_id'))
write.csv(Sn_wlandsc2,"Sn_wlandsc.csv")

Bgr_wlandsc2=merge(Bgr,df_Bgr2, by.x=c('rID'), by.y=c('plot_id'))
write.csv(Bgr_wlandsc2,"Bgr_wlandsc.csv")
