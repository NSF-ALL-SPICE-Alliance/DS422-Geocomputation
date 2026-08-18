library(tidyverse)
library(here)
library(mapview)
library(sf)

wind <- st_read(here("data/Wind_Speed_30m.geojson"))

mapview(
  wind,
  zcol = "speed_mps",     # color by wind speed
  legend = TRUE,
  layer.name = "Wind Speed (m/s)"
)


govt_ownership <- st_read(here("data/Government_Land_Ownership.geojson"))

mapview(
  govt_ownership,
  zcol = "majorowner",     # color by wind speed
  legend = TRUE,
  layer.name = "Ownership"
)


usgs_wind_sites <- st_read(here("data/uswtdb_V8_1_20250522.geojson"))

hi_usgs_wind_sites <- usgs_wind_sites %>% 
  filter(t_state == "HI")

mapview(hi_usgs_wind_sites)


hi_zoning <- st_read(here("data/Zoning_(City_and_County_of_Honolulu).geojson"))

mapview(
  hi_zoning,
  zcol = "zoning_des",     # color by wind speed
  legend = TRUE,
  layer.name = "Ownership"
)

hi_elevation <- st_read(here("data/oahcntrs100.shp/oahcntrs100.shp"))

mapview(hi_elevation, zcol = "contour", legend = TRUE)
