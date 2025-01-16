rm(list = ls())

library(tidyverse)
library(sf)

old.processed <- read_csv("processed-data/ForeclosuresGeocoded.csv")
updated.foreclosures <- read_csv("source-data/ResidentialForeclosures_1995to2024.csv")
new.foreclosures <- updated.foreclosures |>
  filter(! legal_doc %in% old.processed$legal_doc)

# identify the unique coordinate points and convert to simple features object
unique.coordinates <- new.foreclosures %>%
  group_by(x, y) %>%
  summarise() %>%
  ungroup() %>%
  st_as_sf(coords = c("x", "y"), crs = 32054, remove = FALSE)

# target geographies
tracts.2010 <- tigris::tracts(state = "WI", county = "MILWAUKEE", cb = T,
                              year = 2010) %>%
  mutate(tract_2010 = paste0(STATEFP, COUNTYFP, TRACT)) %>%
  select(tract_2010)
tracts.2020 <- tigris::tracts(state = "WI", county = "MILWAUKEE", cb = T,
                              year = 2020) %>%
  select(tract_2020 = GEOID)
alder.2022 <- st_read("https://github.com/jdjohn215/City-of-Milwaukee-Elections/raw/main/boundaries/CityofMilwaukeeAldermanicDistrict2022.geojson")
neighborhoods <- st_read("source-data/CityNeighborhoods.geojson")

# intersect coordinate points with target geographies
coords.in.tracts.2010 <- unique.coordinates %>%
  st_as_sf(coords = c("x","y"), crs = 32054) %>%
  st_transform(crs = st_crs(tracts.2010)) %>%
  st_intersection(tracts.2010)

coords.in.tracts.2020 <- unique.coordinates %>%
  st_as_sf(coords = c("x","y"), crs = 32054) %>%
  st_transform(crs = st_crs(tracts.2020)) %>%
  st_intersection(tracts.2020)

coords.in.tracts.alder <- unique.coordinates %>%
  st_as_sf(coords = c("x","y"), crs = 32054) %>%
  st_transform(crs = st_crs(alder.2022)) %>%
  st_intersection(alder.2022)

coords.in.neighborhoods <- unique.coordinates %>%
  st_as_sf(coords = c("x","y"), crs = 32054) %>%
  st_transform(crs = st_crs(neighborhoods)) %>%
  st_intersection(neighborhoods)

# merge add geography codes to foreclosure data
geocoded.foreclosures <- new.foreclosures %>%
  left_join(st_drop_geometry(coords.in.neighborhoods)) %>%
  left_join(st_drop_geometry(coords.in.tracts.2010)) %>%
  left_join(st_drop_geometry(coords.in.tracts.2020)) %>%
  left_join(st_drop_geometry(coords.in.tracts.alder))

all.updated <- old.processed |>
  filter(legal_doc %in% updated.foreclosures$legal_doc) |>
  mutate(tract_2010 = as.character(tract_2010),
         tract_2020 = as.character(tract_2020),
         aldermanic_2022 = as.character(aldermanic_2022)) |>
  bind_rows(geocoded.foreclosures)

write_csv(all.updated, "processed-data/ForeclosuresGeocoded.csv")

