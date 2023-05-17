rm(list = ls())

library(tidyverse)
library(sf)

foreclosures.by.ald <- read_csv("processed-data/AnnualForeclosureStats_aldermanic2022.csv")

alder.shp <- st_read("source-data/aldermanic2022.geojson") %>%
  mutate(aldermanic_2022 = as.numeric(aldermanic_2022))

alder.shp %>%
  inner_join(foreclosures.by.ald) %>%
  ggplot() +
  geom_sf(aes(fill = foreclosures_per_1k)) +
  scale_fill_distiller(direction = 1) +
  facet_wrap(~start_year, ncol = 7) +
  labs(title = "Residential foreclosure rates in Milwaukee aldermanic districts",
       subtitle = "using aldermanic district boundaries adopted in 2022",
       caption = str_wrap("Dataset created by John D. Johnson using a combination of state and city records. These statistics likely undercount the true number of foreclosures. See github.com/jdjohn215/milwaukee-foreclosures for details.", 110),
       fill = "foreclosures per 1,000 non-city owned houses") +
  theme_void() +
  theme(plot.background = element_rect(fill = "white", colour = "white"),
        plot.title.position = "plot",
        plot.title = element_text(face = "bold"),
        legend.position = "top",
        legend.background = element_rect(fill = "linen", colour = "linen"),
        legend.title = element_text(face = "bold", size = 8),
        legend.text = element_text(size = 8),
        panel.background = element_rect(fill = "linen", colour = "linen"),
        strip.background = element_rect(fill = "linen", colour = "linen"),
        strip.text = element_text(face = "bold"))
ggsave("images/AldermanicForeclosureRates.png", width = 7, height = 8)
