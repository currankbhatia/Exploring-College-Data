library(dplyr)

allzips <- readRDS("data/superzip.rds")
allzips <- allzips[1:10,]
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)
allzips$college <- allzips$college * 100
allzips$zipcode <- formatC(allzips$zipcode, width=5, format="d", flag="0")
row.names(allzips) <- allzips$zipcode

cleantable <- allzips %>%
  select(
    City = city.x,
    State = state.x,
    Zipcode = zipcode,
    Population = adultpop,
    Lat = latitude,
    Long = longitude
  )


