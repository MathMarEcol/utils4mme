
#' Assign Spalding's Marine Ecoregions to spatial data
#'
#' A function that assigns Spalding's Marine Ecoregions and description to each spatial feature.
#'
#' @param df An `sf` object to be matched to longhurst
#'
#' @return An `sf` dataframe with additional MEOW columns (`EcoRegion`, `Province`, `Realm` and `LatZone`)
#' @export
#'
#' @examples
match_meow <- function(df){

  spald <- meow %>%
    sf::st_transform(sf::st_crs(df)) # Transform to the projection of the input

  nr <- sf::st_nearest_feature(df, spald)

  MEOW <- df %>%
    dplyr::mutate(EcoRegion = spald$ECOREGION[nr],
                  Province = spald$PROVINCE[nr],
                  Realm = spald$REALM[nr],
                  LatZone = spald$Lat_Zone[nr])

  return(MEOW)
}
