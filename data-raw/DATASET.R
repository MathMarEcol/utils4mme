## code to prepare `DATASET` dataset goes here

longhurst <- sf::st_read(file.path("data-raw", "longhurst_v4_2010","longhurst_world_v4_2010.shp"))
meow <- sf::st_read(file.path("data-raw", "MEOW","meow_ecos.shp"))

usethis::use_data(longhurst, meow, overwrite = TRUE)
