library(tidycensus)
library(dplyr)
library(tidyr)
library(stringr)
library(mapgl)
library(viridis)

# 1) Add SNAP to your variable list (household-level)
hi_vars <- c(
  # Person-level
  poverty_n            = "B17001_002",
  uninsured_u65_n      = "B27010_017",
  unemployed_n         = "B23025_005",
  pop_total            = "B01003_001",
  
  # Households + housing
  households_total     = "B11001_001",
  broadband_hh_n       = "B28002_004",
  renter_hh_n          = "B25003_003",
  novehicle_hh_n       = "B25044_003",
  snap_hh_n            = "B22001_002",     # <-- NEW: SNAP households (numerator)
  
  # Education
  edu_25plus_total     = "B15003_001",
  bachelors_n          = "B15003_022",
  
  # Labor force + workers
  labor_force_total    = "B23025_003",
  workers_total        = "B08301_001",
  
  # Income level (kept as level)
  median_income        = "B19013_001"
)

# 2) Pull core variables (long -> wide)
hi_acs_long <- get_acs(
  geography = "tract",
  state = "HI",
  year = 2023,
  geometry = TRUE,
  variables = hi_vars
)|>
  dplyr::filter(GEOID != "15003981200")

hi_acs <- hi_acs_long %>%
  select(GEOID, variable, estimate) %>%
  pivot_wider(names_from = variable, values_from = estimate)

# 3) Build commute ≥30 min numerator (unchanged)
commute_tbl <- get_acs(
  geography = "tract",
  state = "HI",
  year = 2023,
  table = "B08303",
  geometry = FALSE
)|>
  dplyr::filter(GEOID != "15003981200")

commute_30plus <- commute_tbl %>%
  filter(variable == "B08303_004") %>%
  group_by(GEOID) %>%
  summarize(commute_30plus_n = sum(estimate, na.rm = TRUE), .groups = "drop")

# 4) Join + compute correctly normalized percentages (including SNAP)
hi_acs <- hi_acs %>%
  left_join(commute_30plus, by = "GEOID") %>%
  mutate(
    # Person-based
    poverty_rate_pct        = 100 * poverty_n       / pmax(pop_total, 1),
    uninsured_u65_pct       = 100 * uninsured_u65_n / pmax(pop_total, 1),
    
    # Labor-force based
    unemployment_rate_pct   = 100 * unemployed_n    / pmax(labor_force_total, 1),
    
    # Household-based
    broadband_pct           = 100 * broadband_hh_n  / pmax(households_total, 1),
    renter_pct              = 100 * renter_hh_n     / pmax(households_total, 1),
    no_vehicle_pct          = 100 * novehicle_hh_n  / pmax(households_total, 1),
    snap_pct                = 100 * snap_hh_n       / pmax(households_total, 1),  # <-- SNAP %
    
    # Education (25+)
    bachelors_or_higher_pct = 100 * bachelors_n     / pmax(edu_25plus_total, 1),
    
    # Commute-based
    commute_30plus_pct      = 100 * commute_30plus_n / pmax(workers_total, 1)
  )


## Challenge - use mapgl to map the snap_pct by census tract in Hawaii

ggplot(hi_acs) +
  geom_sf(aes(fill = snap_pct), color = NA) +
  scale_fill_viridis(
    option = "plasma", direction = -1,
    name = "% of Households with SNAP",
    limits = c(0, max(hi_acs$snap_pct, na.rm = TRUE)),
    labels = scales::label_number(accuracy = 1)
  ) +
  labs(
    title = "SNAP Participation by Census Tract, Hawaiʻi (ACS 2023)",
    subtitle = "Percent of households receiving food assistance",
    caption = "Source: U.S. Census Bureau, 2023 ACS 5-Year Estimates"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "right",
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    panel.grid = element_blank()
  )

library(mapview)
library(sf)

# Make an interactive leaflet-style map
mapview(hi_acs, 
        zcol = "snap_pct", 
        legend = TRUE,
        layer.name = "SNAP Participation (%)",
        at = seq(0, max(hi_acs$snap_pct, na.rm = TRUE), by = 5),
        col.regions = viridis::viridis(10, direction = -1))


# 5) ML-ready frame (add snap_pct to your features)
hi_acs_data_ml <- hi_acs %>%
  select(GEOID, median_income, poverty_rate_pct, uninsured_u65_pct, unemployment_rate_pct,
         broadband_pct, renter_pct, no_vehicle_pct, snap_pct,
         bachelors_or_higher_pct, commute_30plus_pct) %>%
  filter(if_all(-GEOID, ~ is.finite(.))) %>%
  tidyr::drop_na() %>% 
  select(-GEOID)



## Challenge - use ggplot to make a histogram of snap_pct


ggplot(hi_acs_data_ml, aes(x = snap_pct)) +
  geom_histogram()



## Challenge - Create a random forest model to predict and understand patterns of snap pct
rf = randomForest(snap_pct ~ ., data = hi_acs_data_ml, ntree = 500)
rf


## Use unify and treeshap to prepare the model for explainable machine learning outputs (shap)
unified <- unify(rf, hi_acs_data_ml)
treeshap1 <- treeshap(unified,  hi_acs_data_ml[1:200, ], verbose = 0)


## Challenge - plot feature importance (top 5 most important features)
plot_feature_importance(treeshap1, max_vars = 5)


## Challenge - plot feature dependence (top 5 most important features)
plot_feature_dependence(treeshap1, "bachelors_or_higher_pct")

plot_feature_dependence(treeshap1, "poverty_rate_pct")

plot_feature_dependence(treeshap1, "median_income")

plot_feature_dependence(treeshap1, "broadband_pct")

plot_feature_dependence(treeshap1, "unemployment_rate_pct")


## Plot contribution effects for Census Tract 304.04, Maui, HI (hint obs = 154)
plot_contribution(treeshap1, obs = 154)








