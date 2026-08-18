#https://geoportal.hawaii.gov/datasets/tsunami-evacuation-zones/explore?showTable=true

library(tidyverse)
library(sf)
library(here)
library(mapgl)
library(tidycensus)
#library(rsocrata)

evac_zones <- st_read(here("data/Tsunami_Evacuation_Zones.geojson"))



# 2) Simple style (semi-transparent fill + outline)
fill_col <- "#ef4444"   # red
line_col <- "#7f1d1d"   # deep red

mapboxgl(bounds = evac_zones) |>
  add_fill_layer(
    id = "tsunami_evac",
    source = evac_zones,
    fill_color = fill_col,
    fill_opacity = 0.55,
    tooltip = "mapname"
  ) |>
  add_legend(
    legend_title = "Tsunami Evacuation Zones",
    values = "Evacuation Area",
    colors = fill_col,
    type = "categorical"
  )



# Question 1: How many hawaii residents live in evacuation zones

# --- 1) Get ACS population with geometry (block groups) ---
bg <- get_acs(
  geography = "block group",
  variables = "B01003_001",   # total population
  state = "HI",
  year = 2023, survey = "acs5",
  geometry = TRUE, cache_table = TRUE
) |>
  st_transform(4326) |>
  st_make_valid() |>
  rename(pop = estimate) |>
  select(GEOID, pop)

hi_total <- sum(bg$pop, na.rm = TRUE)


evac <- evac_zones |>
  st_transform(4326) |>
  st_make_valid() |>
  mutate(evac_id = dplyr::row_number())


# Intersect block groups with evac polygons
int <- st_intersection(
  bg |> mutate(bg_area = st_area(geometry)),
  evac |> select(evac_id, island, zone_type, zone_desc)
)


int <- int |>
  mutate(
    overlap_area = st_area(geometry),
    w = as.numeric(overlap_area / bg_area),  # proportion of BG inside evac zone
    pop_aw = pop * w
  )

# a) Total population living in any evacuation zone (statewide)
pop_in_zones <- int |>
  st_drop_geometry() |>
  summarise(residents_in_evac_zones = round(sum(pop_aw, na.rm = TRUE))) |>
  pull(residents_in_evac_zones)

share_pct <- round(100 * pop_in_zones / hi_total, 2)

cat(sprintf(
  "Estimated Hawaiʻi residents living in tsunami evacuation zones: %s (≈ %s%% of state population).\n",
  format(pop_in_zones, big.mark = ","), share_pct
))


# b) By island (helpful for reporting)
by_island <- int |>
  st_drop_geometry() |>
  group_by(island) |>
  summarise(residents_in_evac_zones = round(sum(pop_aw, na.rm = TRUE))) |>
  arrange(desc(residents_in_evac_zones))

print(by_island)



# Challenge https://github.com/CadeGarcia/DS421-Carto-Design/blob/main/final_data/Tsunami_Evacuation_All_Zones.geojson

# Houw many people live in yellow zones? How many people live in green zones?
