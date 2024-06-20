#' Convert a number to radians (e.g., for day of year or time of day).
#'
#' A function that converts a number (e.g., for day of year or time of day) to radians, usually needed before using the harmnonic function in statistical models.
#' # Anthony J. Richardson 21/6/24.
#' 
#' @param Number A numeric variable
#' @param Max A numeric variable for the maximum possible value of the variable (note that this might be larger than in the observations).
#'
#' @return An `sf` dataframe with additional longhurst columns (`ProvCode`, `ProvDescr`)
#' @export Num2Radians A numeric variable in radians
#'
#' @examples
#' df <- df <- data.frame(Number = runif(10, 1, 365))
#' Max <- 365
#' Num2Radians(df$Number, Max)




Num2Radians <- function(Number, Max){
  Num2Radians = (Number/Max) * 2 * pi
}