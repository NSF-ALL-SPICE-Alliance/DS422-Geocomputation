library(tidycensus)
library(tidyverse)
library(randomForest)
library(treeshap)



hi_acs_data <- get_acs(
  geography = "tract",
  state = "HI",
  year = 2023,
  geometry = TRUE,
  
  variables = c(
    median_income = "B19013_001",               # Median household income
    poverty_rate = "B17001_002",                # Individuals below poverty level
    unemployment_rate = "B23025_005",           # Unemployed population 16+
    population_total = "B01003_001",            # Total population
    broadband_access = "B28002_004",            # Households with broadband Internet
    no_vehicle = "B25044_003",                  # Households with no vehicles
    renter_occupied = "B25003_003",             # Renter-occupied housing units
    no_health_insurance = "B27010_017",         # Uninsured population under 65
    bachelors_or_higher = "B15003_022",         # Bachelor's degree
    commute_over_30min = "B08303_004"           # Workers with commute > 30 min
  ) 
)|>
  dplyr::filter(GEOID != "15003981200")


hi_acs_data <- hi_acs_data %>%
  select(GEOID, NAME, variable, estimate, geometry) %>%
  mutate(variable = factor(variable))


hi_acs_data_wide <- hi_acs_data %>%
  st_drop_geometry() %>%
  select(-NAME) %>%
  tidyr::pivot_wider(names_from = variable, values_from = estimate)


hi_acs_data_wide <- hi_acs_data %>%
  st_drop_geometry() %>%
  select(-NAME) %>%
  tidyr::pivot_wider(names_from = variable, values_from = estimate) %>%
  mutate(
    poverty_rate_pct = 100 * poverty_rate / population_total,
    unemployment_rate_pct = 100 * unemployment_rate / population_total,
    no_health_insurance_pct = 100 * no_health_insurance / population_total,
    no_vehicle_pct = 100 * no_vehicle / population_total,
    renter_pct = 100 * renter_occupied / population_total,
    broadband_pct = 100 * broadband_access / population_total,
    commute_over_30min_pct = 100 * commute_over_30min / population_total,
    bachelors_or_higher_pct = 100 * bachelors_or_higher / population_total
  )


ggplot(hi_acs_data_wide, aes(x = poverty_rate_pct)) +
  geom_histogram()


hi_acs_data_ml <- hi_acs_data_wide %>% 
  select(poverty_rate_pct, 
         unemployment_rate_pct,
         no_health_insurance_pct,
         no_vehicle_pct,
         renter_pct,
         broadband_pct,
         commute_over_30min_pct,
         bachelors_or_higher_pct,
         median_income)


sum(is.na(hi_acs_data_ml))


hi_acs_data_ml <- hi_acs_data_ml %>% 
  drop_na()


rf = randomForest(unemployment_rate_pct ~ ., data = hi_acs_data_ml, ntree = 500)
rf


unified <- unify(rf, hi_acs_data_ml)
treeshap1 <- treeshap(unified,  hi_acs_data_ml[1:200, ], verbose = 0)

plot_feature_importance(treeshap1, max_vars = 5)


