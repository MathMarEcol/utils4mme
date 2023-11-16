
#' Very simple function to return a global land-sea mask.
#'
#' The function uses rnaturalearth for masking the land. It defaults to 1
#' degree but any resolution can be used by changing `nrow` and `ncol`.
#'
#' @param nrow Number of rows in global raster
#' @param ncol Number of columns in global raster
#' @param scale The scale of the data to be downloaded from rnaturalearth.
#'
#' @return A SpatRaster from `terra`
#' @export
#'
#' @examples
#' r <- get_landMask(nrow = 180, ncol = 360, scale = "large")
get_landMask <- function(nrow = 180, ncol = 360, scale = "large") {

  land <- rnaturalearth::ne_countries(scale = scale, returnclass = "sf") %>%
    dplyr::mutate(value = 1) %>%
    dplyr::select("value") %>%
    terra::vect()

  mask <- terra::rast(ncol = ncol, nrow = nrow)

  r <- terra::rasterize(land, mask, field = "value", cover = TRUE)

}
