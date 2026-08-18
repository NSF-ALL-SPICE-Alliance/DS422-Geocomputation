# Mapping NDVI 🌿

# What is NDVI?






#https://browser.dataspace.copernicus.eu/?zoom=10&lat=21.57149&lng=-157.84854&themeId=DEFAULT-THEME&visualizationUrl=U2FsdGVkX1%2FWd1%2BLr%2FPAUPnIlaQL5Ms66ExyP0%2BJXifJqwcW%2BCkx%2FVLd%2FlKYxIgv%2BhXbuSa7qFaeb3iM0lJm4GTT%2BHj4CkBCG52YnCL4n0dMVjbWpGKoQIqp2IMQPTlC&datasetId=S2_L2A_CDAS&fromTime=2024-06-23T00%3A00%3A00.000Z&toTime=2024-06-23T23%3A59%3A59.999Z&layerId=1_TRUE_COLOR

library(terra)
library(sf)
library(here)

# Paths to your .jp2 files
red_path <- here("data/band_data/T04QFJ_20250906T210919_B04_10m.jp2")
nir_path <- here("data/band_data/T04QFJ_20250906T210919_B08_10m.jp2")

# Read bands directly
red <- rast(red_path)
nir <- rast(nir_path)


# NDVI = (NIR - Red) / (NIR + Red)
ndvi <- (nir - red) / (nir + red)
names(ndvi) <- "NDVI"

# Plot quickly
plot(ndvi, main = "NDVI")






