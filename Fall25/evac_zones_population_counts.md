## ❓Simple Question:

### 🌊 How many hawaii residents live in tsunami evacuation zones?

1. [Download evacuation zone geojson here](https://geoportal.hawaii.gov/datasets/tsunami-evacuation-zones/explore?showTable=true)

2. I reccommend using [tidycensus](https://walker-data.com/tidycensus/) to pull population data

# 🌊 `sf` Functions in the Tsunami Evacuation Analysis

| Function | General Purpose | Role in This Project |
|----------|-----------------|-----------------------|
| [**st_read()**](https://r-spatial.github.io/sf/reference/st_read.html) | Reads spatial vector data (shapefiles, GeoJSON, etc.) into an `sf` object. | Loads the *Tsunami Evacuation Zones* GeoJSON into R as polygons for mapping and analysis. |
| [**st_transform()**](https://r-spatial.github.io/sf/reference/st_transform.html) | Reprojects geometries into a different coordinate reference system (CRS). | Ensures both evacuation zones and ACS block groups use the same CRS so intersections and areas are valid. |
| [**st_make_valid()**](https://r-spatial.github.io/sf/reference/st_make_valid.html) | Repairs invalid or self-crossing geometries so they can be used in operations. | Fixes any broken evacuation zone or block group polygons to prevent errors in intersections. |
| [**st_intersection()**](https://r-spatial.github.io/sf/reference/geos_unary.html) | Computes geometric intersections between two `sf` objects. | Splits ACS block groups where they overlap evacuation zones, allowing proportional population estimates. |
| [**st_area()**](https://r-spatial.github.io/sf/reference/geos_measures.html) | Calculates the area of a geometry (units depend on CRS). | Measures block group area and overlap area with evacuation zones, used to weight population counts. |


