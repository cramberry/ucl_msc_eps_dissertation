install.packages("ggplot2")
library(ggplot2)
library(maps)
library(rgeos)
library(maptools)
library(ggmap)
library(geosphere)
library(dplyr)
install.packages("geonames")
library(geonames)
library(tmap)
library(tmaptools)
library(ggrepel)
install.packages("ggrepel")
library(tidyverse)
install.packages("ggmap")
install.packages("tidyverse")
library(maps)
library(geosphere)
install.packages("shiny")

library(knitr)
library(rmarkdown)
library(maps)


routes<-read.csv("routes_coords.csv")
city_points<-read.csv("city_points.csv", stringsAsFactors = F)
locationsIATA<-geocode_OSM(city_points$IATA_code)
locationsName<- geocode_OSM(city_points$city)
write.csv(locationsName, "locations.csv", row.names = F)
locationsName<-merge(city_points, locationsName, by.x = "city", by.y =  "query")

install.packages("tidyverse")
library(tidyverse)
library(sp)
library(geosphere)
library(sf)
library(rnaturalearth)
install.packages("rnaturalearth")
install.packages("lwgeom")

letters <- read.csv("correspondence.csv")
locations <- read.csv("locations.csv")

countries_sp <- ne_countries(scale = "medium")
countries_sf <- ne_countries(scale = "medium", returnclass = "sf")
plot(countries_sp)
plot(countries_sf)

routes<-read.csv("routes_coords.csv")
city_points<-read.csv("city_points.csv")

routes <- routes %>%
  group_by(fromIATA, toIATA) %>%
  count() %>%
  ungroup() %>%
  arrange(n)

# Create id column to routes
routes_id <- rowid_to_column(routes, var = "id")

# Transform routes to long format
routes_long <- routes_id %>%
  gather(key = "type", value = "place", fromIATA, toIATA)

# Print routes_long
routes_long

#Add coordinate values
routes_long_geo <- left_join(routes_long, locationsName, by = c("place" = "IATA_code"))

# Convert coordinate data to sf object
routes_long_sf <- st_as_sf(routes_long_geo, coords = c("lon", "lat"), crs = 4326)

#correct error missing FBM Lubums...
write.csv(routes_long_geo, "routes_long_geo.csv")
routes_long_geo<-read.csv("routes_long_geo.csv")

# Print routes_long_sf
routes_long_sf

# Convert POINT geometry to MULTIPOINT, then LINESTRING
routes_lines <- routes_long_sf %>% 
  group_by(id) %>% 
  summarise(do_union = FALSE) %>% 
  st_cast("LINESTRING")

# Print routes_lines
routes_lines

# Join sf object with attributes data
routes_lines <- left_join(routes_lines, routes_id, by = "id")

# Convert rhumb lines to great circles
routes_sf_tidy <- routes_lines %>% 
  st_segmentize(units::set_units(20, km))

# Compare number of points in routes_lines and routes_sf_tidy
nrow(st_coordinates(routes_lines))

nrow(st_coordinates(routes_sf_tidy))

# Rhumb lines vs great circles
ggplot() +
  geom_sf(data = countries_sf, fill = gray(0.8), color = gray(0.9)) +
  geom_sf(data = routes_sf_tidy, color = "darkgreen", size = 0.2, fill = 0.3, alpha = 0.3) + 
  ggtitle("ET Network") + 
  theme_minimal()

ggsave("et_asky_malaw_first.png", dpi = 600)












