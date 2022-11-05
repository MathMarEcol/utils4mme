
#' A function to fix incorrect column types from fishbase and sealifebase
#'
#' A function to fix incorrect column types from fishbase and sealifebase.
#' This may be able to be removed. These errors should be fixed in a future FB version.
#'
#' @param df The species dataframe
#' @param datab Which server to use "fishbase" (default) or "sealifebase"
#'
#' @return The species dataframe with names corrected.
#'
#' @examples
SpatPlan_fix_FBtype<- function(df, datab = "fishbase"){

  if(datab == "fishbase"){ # Need to convert type of different columns depending on database
    nm <- c("SpecCode", "DepthRangeShallow", "CommonLength", "CommonLengthF", "LongevityWildRef", "MaxLengthRef", "DangerousRef")
  } else if(datab == "sealifebase"){
    nm <- c("SpecCode", "SpeciesRefNo", "GenCode", "DepthRangeRef", "LongevityWildRef", "Weight")
  }

  df <- df %>%
    dplyr::mutate(dplyr::across(dplyr::any_of(nm), as.numeric)) # Convert `nm` variables to numeric
}


#' Code to loop through and try and validate names with fishbase and sealifebase
#'
#' @param spp A dataframe with the species to be checked.
#' @param datab  Which server to use "fishbase" (default) or "sealifebase"
#'
#' @return A dataframe with corrected species names
#' @export
#'
#' @examples
#' SpatPlan_validate_FBNAs(data.frame(Species = "Thunnus maccoyii"))
#' @importFrom rlang .data
SpatPlan_validate_FBNAs <- function(spp, datab = "fishbase"){
  spp <- spp %>%
    dplyr::mutate(ValidSpecies = NA, valid = FALSE)

  # For some reason we are getting multiple names back for some species. Check which ones....
  for (a in 1:dim(spp)[1]){
    out <- rfishbase::validate_names(spp$Species[a], server = datab)
    if (length(out) == 1 & is.na(out)){ # Maintain original name
      spp$ValidSpecies[a] <- spp$Species[a]
    } else if (length(out) == 1){
      spp$ValidSpecies[a] <- out[1]
      spp$valid[a] <- TRUE
    } else if (length(out) > 1) {
      # First check if any match the original name
      # Sometimes a species comes back as valid, with an alternative.
      # Here we check if the name was in fact in the output
      out2 <- out[which(stringr::str_detect(out, spp$Species[a]))]
      spp$valid[a] <- TRUE
      if (length(out2) == 1){ # Name existed in the original
        spp$ValidSpecies[a] <- out2
      } else {
        spp$ValidSpecies[a] <- out[1] # Guess at the first one.
      }
    }
  }

  spp <- spp %>%
    dplyr::rename(OrigSpecies = .data$Species)
}


#' Crop AquaMaps Data
#'
#' @param df The AquaMaps `stars` object from `SpatPlan_Get_AquaMaps`
#' @param spp A character vector of species
#' @param extent An `sf` object from which to extract the extent
#'
#' @return An `sf` object cropped to `extent`
#'
#' @examples
#' @importFrom rlang .data
SpatPlan_Crop_AQM <- function(df, spp, extent){

  cropped <- df %>%
    sf::st_crop(extent, crop = TRUE) %>%  # TODO replace ex_sf with a polygon to deal with EEZ or coastal areas
    stars:::slice.stars(along = "band", index = spp$SpeciesIDNum) %>% # indexes rows based on SpeciesIDNum
    stars::st_as_stars() %>% # loads it into memory
    stars::st_set_dimensions("band", values = spp$longnames) %>%
    sf::st_as_sf(na.rm = FALSE, as_points = FALSE, merge = FALSE)

  rs <- cropped %>%
    sf::st_drop_geometry() %>%
    is.na() %>%
    rowSums()

  nc <- ncol(cropped) - 1 # Number of cols not including geometry

  cropped <- cropped %>%
    dplyr::filter({rs == nc} == FALSE) # Remove Rows with all NAs (except geometry)

  # Removed this code so I could get rid of . for RMD checks
  # cropped <- df %>%
  #   sf::st_crop(extent, crop = TRUE) %>%  # TODO replace ex_sf with a polygon to deal with EEZ or coastal areas
  #   stars:::slice.stars(along = "band", index = spp$SpeciesIDNum) %>% # indexes rows based on SpeciesIDNum
  #   stars::st_as_stars() %>% # loads it into memory
  #   stars::st_set_dimensions("band", values = spp$longnames) %>%
  #   sf::st_as_sf(na.rm = FALSE, as_points = FALSE, merge = FALSE) %>%
  #   dplyr::filter(sf::st_drop_geometry(.) %>%
  #                   is.na(.) %>%
  #                   {rowSums(.) == ncol(.)} == FALSE) # Remove Rows with all NAs (except geometry)

  return(cropped)
}
