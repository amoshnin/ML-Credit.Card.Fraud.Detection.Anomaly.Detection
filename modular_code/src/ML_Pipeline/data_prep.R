

##-------------------------------------------------------------------
##  Function to split input data into 2 sets (1 training, 1 test)  --
##------------------------------------------------------------------- 
splitData <- function(inputdf, ratios){
  
  splits <- h2o.splitFrame(creditcard_hf, ratios = ratios, seed = 42)
  return(list(splits[[1]],splits[[2]])) 
}
