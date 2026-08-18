library(tidyverse)
library(here)
library(sf)
library(mapview)
library(leaflet)
library(RColorBrewer)

ag_2015 <- st_read(here("data/Agricultural_Land_Use_-_2015_Baseline.geojson"))

ag_2020 <- st_read(here("data/Agricultural_Land_Use_-_2020_Update.geojson"))

# (Optional) make sure it's a factor
ag_2015$cropcatego <- as.factor(ag_2015$cropcatego)

mapview(
  ag_2015,
  zcol          = "cropcatego",
  alpha.regions = 0.6,
  color         = "white",
  lwd           = 0.5,
  layer.name    = "2015 Agriculture",
  popup = leafpop::popupTable(
    ag_2015[, c("cropcatego", "island", "acreage")],
    feature.id = FALSE
  )
)


## Change
total_2015 <- sum(ag_2015$acreage, na.rm = TRUE)
total_2020 <- sum(ag_2020$acreage, na.rm = TRUE)

total_2015
total_2020
total_2020 - total_2015  # change
(total_2020 / total_2015 - 1) * 100  # percent change



## Slider 
# install.packages(c("leaflet", "leaflet.extras2", "RColorBrewer"))
library(leaflet)
library(leaflet.extras2)
library(RColorBrewer)
library(rmapshaper)

ag_2015 <- ms_simplify(ag_2015, keep = 0.2, keep_shapes = TRUE)
ag_2020 <- ms_simplify(ag_2020, keep = 0.2, keep_shapes = TRUE)

# 1) One unified category list + palette (same colors on both sides)
cats <- sort(unique(c(as.character(ag_2015$cropcatego),
                      as.character(ag_2020$crops_2020))))
pal_vec <- colorRampPalette(brewer.pal(12, "Set3"))(length(cats))
names(pal_vec) <- cats
pal_fn <- colorFactor(palette = pal_vec, domain = cats, na.color = "gray")

# 2) Compute a shared bounding box (no joins; just use both bboxes)
b15 <- sf::st_bbox(ag_2015)
b20 <- sf::st_bbox(ag_2020)
xmin <- min(b15["xmin"], b20["xmin"])
ymin <- min(b15["ymin"], b20["ymin"])
xmax <- max(b15["xmax"], b20["xmax"])
ymax <- max(b15["ymax"], b20["ymax"])

# 3) Build the map with two polygon groups, then add the side-by-side slider
leaflet(options = leafletOptions(preferCanvas = TRUE)) |>
  addProviderTiles(providers$CartoDB.Positron) |>
  fitBounds(lng1 = xmin, lat1 = ymin, lng2 = xmax, lat2 = ymax) |>
  
  # LEFT: 2015
  addPolygons(
    data = ag_2015,
    group = "2015",
    weight = 0.5, color = "white",
    fillOpacity = 0.7,
    fillColor = pal_fn(as.character(ag_2015$cropcatego)),
    label = ~cropcatego,
    popup = ~paste0("<b>Crop:</b> ", cropcatego,
                    "<br><b>Island:</b> ", island)
  ) |>
  
  # RIGHT: 2020
  addPolygons(
    data = ag_2020,
    group = "2020",
    weight = 0.5, color = "white",
    fillOpacity = 0.7,
    fillColor = pal_fn(as.character(ag_2020$crops_2020)),
    label = ~crops_2020,
    popup = ~paste0("<b>Crop:</b> ", crops_2020,
                    "<br><b>Island:</b> ", island)
  ) |>
  
  # Slider comparing the two groups
  addSidebyside(left = "2015", right = "2020") |>
  
  # Unified legend (same colors for both sides)
  addLegend(
    position = "bottomleft",
    title = "Crop Category (2015 vs 2020)",
    colors = pal_vec,
    labels = names(pal_vec)
  )
