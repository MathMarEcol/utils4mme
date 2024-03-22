
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
#' out <- utils4mme::PUs_Tasman %>%
#'   match_MEOW()
#'
match_MEOW <- function(df){

  if(!"cellID" %in% colnames(df)){
    df <- df %>%
      dplyr::mutate(cellID = dplyr::row_number())
  }

  meow_trans <- sf::st_transform(utils4mme::meow, sf::st_crs(df)) # Transform to the projection of the input

  overlap <- sf::st_intersection(df, meow_trans) %>%
    dplyr::mutate(Area = units::set_units(sf::st_area(.), "km2")) %>%
    sf::st_drop_geometry() %>%
    dplyr::select("cellID", "ECOREGION", "PROVINCE", "REALM", "Lat_Zone", "Area") %>%
    dplyr::group_by(.data$cellID, .data$ECOREGION, .data$PROVINCE, .data$REALM, .data$Lat_Zone,) %>%
    dplyr::summarise(Area = sum(.data$Area, na.rm = TRUE)) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(.data$cellID) %>%
    dplyr::mutate(EcoRegion = .data$ECOREGION[which.max(.data$Area)],
                  Province = .data$PROVINCE[which.max(.data$Area)],
                  Realm = .data$REALM[which.max(.data$Area)],
                  LatZone = .data$Lat_Zone[which.max(.data$Area)],
                  Area_MEOW = max(.data$Area)) %>%
    dplyr::ungroup() %>%
    dplyr::select("cellID", "EcoRegion", "Province", "Realm", "LatZone", "Area_MEOW") %>%
    dplyr::distinct() %>%
    dplyr::right_join(df, by = "cellID") %>%
    sf::st_sf()

  return(overlap)
}
