rm(list = ls())

library(tidyverse)

foreclosures <- read_csv("processed-data/ForeclosuresGeocoded.csv")

############################################################################
# aldermanic district comparison
parcels.by.ald <- read_csv("source-data/AnnualResidentialParcels_Aldermanic2022.csv") %>%
  filter(between(year_end, 1994, 2022))

foreclosures.by.ald <- foreclosures %>%
  group_by(foreclose_year, aldermanic_2022) %>%
  summarise(foreclosures = n()) %>%
  ungroup()

foreclosure.rates.by.ald <- parcels.by.ald %>%
  mutate(start_year = year_end + 1) %>%
  select(start_year, aldermanic_2022, parcels) %>%
  inner_join(foreclosures.by.ald, by = c("start_year" = "foreclose_year", 
                                         "aldermanic_2022" = "aldermanic_2022")) %>%
  mutate(foreclosures_per_1k = (foreclosures/parcels)*1000)
write_csv(foreclosure.rates.by.ald, "processed-data/AnnualForeclosureStats_aldermanic2022.csv")
############################################################################
# tracts 2020 comparison
parcels.by.tract2020 <- read_csv("source-data/AnnualResidentialParcels_Tract2020.csv") %>%
  filter(between(year_end, 1994, 2022))

foreclosures.by.tract2020 <- foreclosures %>%
  group_by(foreclose_year, tract_2020) %>%
  summarise(foreclosures = n()) %>%
  ungroup()

foreclosure.rates.by.tract2020 <- parcels.by.tract2020 %>%
  mutate(start_year = year_end + 1) %>%
  select(start_year, tract_2020, parcels) %>%
  inner_join(foreclosures.by.tract2020, by = c("start_year" = "foreclose_year", 
                                         "tract_2020" = "tract_2020")) %>%
  mutate(foreclosures_per_1k = (foreclosures/parcels)*1000)
write_csv(foreclosure.rates.by.tract2020, "processed-data/AnnualForeclosureStats_tracts2020.csv")

############################################################################
# tracts 2010 comparison
parcels.by.tract2010 <- read_csv("source-data/AnnualResidentialParcels_Tract2010.csv") %>%
  filter(between(year_end, 1994, 2022))

foreclosures.by.tract2010 <- foreclosures %>%
  group_by(foreclose_year, tract_2010) %>%
  summarise(foreclosures = n()) %>%
  ungroup()

foreclosure.rates.by.tract2010 <- parcels.by.tract2010 %>%
  mutate(start_year = year_end + 1) %>%
  select(start_year, tract_2010, parcels) %>%
  inner_join(foreclosures.by.tract2010, by = c("start_year" = "foreclose_year", 
                                               "tract_2010" = "tract_2010")) %>%
  mutate(foreclosures_per_1k = (foreclosures/parcels)*1000)
write_csv(foreclosure.rates.by.tract2010, "processed-data/AnnualForeclosureStats_tracts2010.csv")

############################################################################
# NEIGHBORHOOD comparison
parcels.by.neighborhood <- read_csv("source-data/AnnualResidentialParcels_Neighborhood.csv") %>%
  filter(between(year_end, 1994, 2022))

foreclosures.by.neighborhood <- foreclosures %>%
  group_by(foreclose_year, neighborhood) %>%
  summarise(foreclosures = n()) %>%
  ungroup()

foreclosure.rates.by.neighborhood <- parcels.by.neighborhood %>%
  mutate(start_year = year_end + 1) %>%
  select(start_year, neighborhood, parcels) %>%
  left_join(foreclosures.by.neighborhood, by = c("start_year" = "foreclose_year", 
                                               "neighborhood" = "neighborhood")) %>%
  mutate(foreclosures = if_else(is.na(foreclosures), 0, foreclosures),
         foreclosures_per_1k = (foreclosures/parcels)*1000)
write_csv(foreclosure.rates.by.neighborhood, "processed-data/AnnualForeclosureStats_neighborhood.csv")
