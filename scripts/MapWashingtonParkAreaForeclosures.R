rm(list = ls())

library(tidyverse)
library(sf)
library(tmap)

foreclosures <- read_csv("processed-data/ForeclosuresGeocoded.csv")

# neighborhoods shape
gwp.shp <- st_read("source-data/CityNeighborhoods.geojson") %>%
  filter(neighborhood %in% c("WASHINGTON PARK", "WASHINGTON HEIGHTS",
                             "MARTIN DRIVE"))

gwp.osm <- tmaptools::read_osm(gwp.shp, zoom = 16, type = "stamen-toner")


housing.crisis.gwp <- foreclosures %>%
  filter(neighborhood %in% c("WASHINGTON PARK", "WASHINGTON HEIGHTS",
                             "MARTIN DRIVE", "WICK FIELD", "HAWTHORNE GLEN")) %>%
  filter(foreclose_year %in% 2005:2016) %>%
  st_as_sf(coords = c("x","y"), crs = 32054) %>%
  st_transform(crs = st_crs(gwp.osm)) %>%
  mutate(foreclose_type = if_else(str_detect(str_to_upper(deed_type), "TAX") |
                                    str_detect(str_to_upper(grantee_name), "CITY OF MILW"),
                                  "tax", "other"))

gwp.map <- tm_shape(gwp.osm, raster.downsample = F) +
  tm_rgb() +
  tm_shape(housing.crisis.gwp) +
  tm_dots(col = "foreclose_type", palette = c("red", "blue"), title = "Type",
          textNA = "unknown") +
  tm_layout(main.title = "Foreclosures near Washington Park, 2005-2016",
            frame = FALSE, legend.position = c(.6,.5), legend.bg.color = "white",
            legend.bg.alpha = 1)
tmap_save(gwp.map, "images/GreaterWashingtonPark_2005to2016.png",
          width = 7)
