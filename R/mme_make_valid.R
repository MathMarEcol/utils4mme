
#' Make sf polygons valid
#'
#' This function uses an alternative method to try and make sf polygons valid.
#' sf::st_make_valid often results in incorrect polygons with weird lines.
#'
#' @param x sf object with invalid geometries
#' @param group Group of original data to add the fixed data back into
#'
#' @return a corrected sf object with valid geometries
#' @export
#' @importFrom rlang .data
#'
#' @examples
mme_make_valid <- function(x, group){

  sf_func <- function(x){
    x %>%
      sf::st_union() %>%
      sf::st_sf() %>%
      sf::st_cast("MULTIPOLYGON") %>%
      dplyr::bind_cols(x %>% sf::st_drop_geometry() %>% dplyr::distinct())
  }

  x_split <- x %>%
    dplyr::mutate(Valid = x %>% sf::st_is_valid()) %>%
    dplyr::group_by(.data$Valid) %>%
    dplyr::group_split()

  out <-  x_split[[1]] %>% # I wish we could name the list. FALSE will be the first alphabetically.
    sfdct::ct_triangulate() %>%
    sf::st_collection_extract() %>%
    dplyr::group_by({{group}}) %>%
    dplyr::group_split() %>%
    purrr::map(sf_func) %>%
    data.table::rbindlist() %>%
    sf::st_sf() %>%
    dplyr::bind_rows(x_split[[2]])

}

