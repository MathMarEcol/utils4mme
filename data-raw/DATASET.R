## code to prepare `DATASET` dataset goes here
library(sf)
library(tidyverse)


longhurst <- sf::st_read(file.path("data-raw", "longhurst_v4_2010","longhurst_world_v4_2010.shp")) %>%
  st_wrap_dateline(options = c("WRAPDATELINE=YES")) %>%
  utils4mme::mme_make_valid()

# ggplot(data = longhurst, aes(fill = ProvDescr)) +
  # geom_sf(show.legend = FALSE)

meow <- sf::st_read(file.path("data-raw", "MEOW","meow_ecos.shp")) %>%
  st_wrap_dateline(options = c("WRAPDATELINE=YES"))

# ggplot(data = meow, aes(fill = ECOREGION)) +
#   geom_sf(show.legend = FALSE)


Tasman <- rnaturalearth::ne_download(scale = "medium",  category = "physical",  type = "geography_marine_polys") %>%
  dplyr::filter(name == "Tasman Sea")

PUs_Tasman <- Tasman %>%
  st_make_grid(cellsize = 1, square = FALSE) %>%
  sf::st_sf()

PUs_Tasman <- PUs_Tasman[PUs_Tasman %>%
  sf::st_intersects(Tasman) %>%
  lengths(.)>0,]

# ggplot() + geom_sf(data = PUs_Tasman) + geom_sf(data = Tasman, fill = NA, colour = "red")


usethis::use_data(longhurst, meow, PUs_Tasman, overwrite = TRUE)
