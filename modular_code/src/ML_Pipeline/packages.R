#' Install's the necessary packages for price prediction model
#'
#' @return the loaded packages with a statement
#' @export
#'
#' @examples
#' Req_Packages <- function()
#' Req_Packages()
#'
#'
Req_Packages <- function(){
  # Package names
  packages <- c("plyr","tidyverse","bannerCommenter","h2o","dplyr","tidyr","zoo","rpart","superml", "textstem", "e1071", "neuralnet", "stringr", "randomForest", "shiny","ROCR", "neuralnet", "caret", "Metrics", "data.table", "ggplot2")
  # Install packages not yet installed
  installed_packages <- packages %in% rownames(installed.packages())
  if (any(installed_packages == FALSE)) {
    install.packages(packages[!installed_packages])
  }
  # Packages loading
  invisible(lapply(packages, library, character.only = TRUE))
}


