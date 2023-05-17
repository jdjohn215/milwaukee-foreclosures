rm(list = ls())

library(tidyverse)
library(tmap)

foreclosures <- read_csv("processed-data/ForeclosuresGeocoded.csv")
parcels <- read_rds("source-data/ParcelsWithGeographies.rds")

################################################################################
cumulative.by.neighborhood <- foreclosures %>%
  group_by(neighborhood) %>%
  summarise(foreclosures = n(),
            foreclosed_properties = n_distinct(TAXKEY))

parcels.by.neighborhood <- parcels %>%
  filter(between(year, 2007, 2016)) %>%
  group_by(neighborhood) %>%
  summarise(parcels = n_distinct(TAXKEY))

foreclosure.totals.by.neighorhood <- left_join(parcels.by.neighborhood,
                                               cumulative.by.neighborhood) %>%
  mutate(foreclosed_properties = if_else(is.na(foreclosed_properties), 0, as.numeric(foreclosed_properties)),
         foreclosure_share = (foreclosed_properties/parcels)*100)

neighborhood.shp <- st_read("source-data/cityNeighborhoods.geojson")

tm.neighborhood.foreclosures <- neighborhood.shp %>%
  inner_join(foreclosure.totals.by.neighorhood) %>%
  mutate(foreclosure_share = if_else(parcels < 10, NA_real_, foreclosure_share)) %>%
  tm_shape() +
  tm_borders(col = "black") +
  tm_fill(col = "foreclosure_share", style = "cont",
          textNA = "<10 houses", title = "houses foreclosed") +
  tm_layout(frame = FALSE, legend.position = c(0.6, 0.78),
            legend.format = list(fun = function(x){paste0(x, "%")}),
            main.title = "Share of houses experiencing\nforeclosure from 2007-2016") +
  tm_credits("in Milwaukee neighborhoods", position = c("left", "bottom"))
tmap_save(tm.neighborhood.foreclosures, "images/NeighborhoodForeclosures_2007to2016_cumulative.png",
          width = 4.25, height = 7.5)


foreclosure.totals.by.neighorhood %>%
  filter(parcels > 9) %>%
  select(neighborhood, parcels, foreclosure_share) %>%
  slice_max(foreclosure_share, n = 10) %>%
  mutate(neighborhood = str_to_title(neighborhood),
         parcels = prettyNum(parcels, ","),
         foreclosure_share = paste0(round(foreclosure_share, 1), "%"))
