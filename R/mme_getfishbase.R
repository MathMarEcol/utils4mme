
#' Download and return fishbase and sealifebase data
#'
#' The function will also subset to `names` if wanted but it is recommended you
#' do this outside the function so you can query the results.
#'
#' It is essentially a wrapper around fb_tbl() from the rfishbase package.
#'
#' @param names [optional] A character vector of species names to subset to
#'
#' @returns
#' @export
#'
#' @examples
mme_getfishbase <- function(names = NULL, marine_only = TRUE){

  species1 <- rfishbase::fb_tbl("species", server = "fishbase")
  species2 <- rfishbase::fb_tbl("species", server = "sealifebase")

  # Join species1 and species2 by the common columns
  species <- dplyr::bind_rows(species1 %>% dplyr::select(intersect(colnames(species1), colnames(species2))),
                       species2 %>% dplyr::select(intersect(colnames(species1), colnames(species2))))

  if (!is.null(names)){
    species <- species %>%
      tidyr::unite(col = G_S, Genus, Species, sep = " ") %>%
      dplyr::filter(G_S = names)
  }

  if (marine_only){
    species <- species %>%
      dplyr::filter(Saltwater == 1)
  }

return(species)

}

