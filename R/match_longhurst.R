#' Assign Longhurst Provinces to spatial data
#'
#' A function that assigns the Longhurst province and description to each spatial feature.
#'
#' @param df An `sf` object to be matched to longhurst
#'
#' @return An `sf` dataframe with additional longhurst columns (`ProvCode`, `ProvDescr`)
#' @export
#'
#' @examples
#' df <- data.frame(lon = c(150, 160),
#'                  lat = c(-32, -38)) %>%
#'   sf::st_as_sf(coords = c("lon", "lat"), crs = "EPSG:4326") %>%
#'   match_longhurst()
match_longhurst <- function(df){

  longh <- utils4mme::longhurst %>%
    sf::st_transform(sf::st_crs(df)) # Transform to the projection of the input

  nr <- sf::st_nearest_feature(df, longh)

  LPs <- df %>%
    dplyr::mutate(ProvCode = longh$ProvCode[nr],
                  ProvDescr = longh$ProvDescr[nr])

  return(LPs)
}
