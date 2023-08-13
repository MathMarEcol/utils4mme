#' Remove nonsense attributes if we are working for speed and memory efficiency.
#'
#' Written by Bill Venables (CSIRO/UQ)
#'
#' @param tibble The tibble to be converted to a data.frame
#'
#' @return `df` A stripped down dataframe
#' @export
#'
#' @examples
#' df <- tibble::tibble(x = c(1, 2), y = c("January", "February")) %>%
#'   untibble()
#' class(df)
untibble <- function (tibble) {
  df <- data.frame(unclass(tibble), check.names = FALSE, stringsAsFactors = FALSE)
  return(df)
}  ## escape the nonsense
