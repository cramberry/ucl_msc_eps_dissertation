library(spdep)
library(rgdal)
library(rgeos)
library(tmap)
library(ggplot2)
library(ggmap)
library(sf)
library(sp)
library(mapview)
library(tidyverse)
library(sp)
library(sf)
library(rnaturalearth)


woredas<-readOGR(".", "Eth_Woreda_2013")
addis<-subset(woredas, REGIONNAME=="Addis Ababa")
woreda_name<-data.frame(addis@data$WOREDANAME)
plot(addis)

powerpoints<-read.csv("addis_power.csv", stringsAsFactors = F)
tickets<-read.csv("tickets.csv", stringsAsFactors = F)

powerpoints_points <- st_as_sf(powerpoints, coords = c("long", "lat"), crs = 4326)
mapview(powerpoints_points)

getClass("Spatial")


coords <- select(powerpoints, long, lat)

# Create SpatialPoints object with coords and CRS
points_sp <- SpatialPoints(coords = coords,
                           proj4string = CRS("+proj=longlat +datum=WGS84"))
points_sp


points_spdf <- SpatialPointsDataFrame(powerpoints[,3:4],
                                      powerpoints,
                                      proj4string = CRS("+proj=longlat +datum=WGS84"))







