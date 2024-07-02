#' Convert a number to radians (e.g., for day of year or time of day).
#'
#' A function that converts a number (e.g., for day of year or time of day) to radians, usually needed before using the harmnonic function in statistical models.
#'
#' @param Number A numeric variable
#' @param Max A numeric variable for the maximum possible value of the variable (note that this might be larger than in the observations).
#'
#' @export
#'
#' @author Anthony J. Richardson
#'
#' @examples
#' num2radians(runif(10, 1, 365))
num2radians <- function(Number, Max = 365){
  (Number/Max) * 2 * pi
}
