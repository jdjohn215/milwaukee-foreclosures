rm(list = ls())

library(tidyverse)

foreclosures <- read_csv("processed-data/ForeclosuresGeocoded.csv")

annual.foreclosures <- foreclosures %>%
  mutate(foreclose_type = if_else(str_detect(str_to_upper(deed_type), "TAX") |
                                    str_detect(str_to_upper(grantee_name), "CITY OF MILW"),
                                  "tax", "lender"),
         foreclose_type = if_else(is.na(foreclose_type), "unknown", foreclose_type)) %>%
  group_by(foreclose_year, foreclose_type) %>%
  summarise(count = n())

ggplot(annual.foreclosures, aes(foreclose_year, count)) +
  geom_col(aes(fill = foreclose_type), position = position_stack()) +
  scale_x_continuous(breaks = seq(1995,2020, 5),
                     expand = expansion(0.01)) +
  labs(title = "Annual number of residential foreclosures in the City of Milwaukee",
       x = NULL,
       y = "foreclosured houses",
       fill = "type of foreclosure",
       caption = str_wrap("Dataset created by John D. Johnson using a combination of state and city records. These statistics likely undercount the true number of foreclosures. See github.com/jdjohn215/milwaukee-foreclosures for details.", 110)) +
  theme_linedraw() +
  theme(plot.title.position = "plot",
        plot.title = element_text(face = "bold"),
        legend.position = c(0.2, 0.75),
        legend.background = element_rect(fill = "linen"))
ggsave("images/CitywideTotalsByType.png", width = 6, height = 4)
