##------------------------------------------------------------------------
##  Function to get Reconstructed MSE score using H20 anomaly function  --
##------------------------------------------------------------------------
getAnomalyScore <- function(model, trainData, perFeature=FALSE){
  
  reconstructMSE <- h2o.anomaly(model, trainData, per_feature = perFeature) %>% as.data.frame() %>% mutate(Class = as.vector(trainData[, 31]))
  return(reconstructMSE)
}

##----------------------------------------------------------------
##     Function to calculate Threshold value using quantile     --
##----------------------------------------------------------------
calculateThreshold <- function(reconstructMSE,probValue){
  
  return(quantile(reconstructMSE, probs = probValue))
}


##----------------------------------------------------------------
##     Function to calculate Metrics for Unsupervised Model     --
##----------------------------------------------------------------
calculateMetricsUnSup <- function(testReconstructMSE, threshold, testData){
  results_unsup <- data.frame(as.integer(testReconstructMSE > threshold),as.vector(testData[, 31]))
  colnames(results_unsup) <- c("predict","actual")
  df <- results_unsup %>% group_by(actual, predict) %>% summarise(n = n()) %>% mutate(freq = n / sum(n))
  txt <- paste(round(df[[4]][4]*100,2),'% of fraud cases were correctly identified\n',round(df[[4]][1]*100,2),'% of non-fraud cases were correctly identified')
  banner(txt, centre = TRUE, bandChar = "-")
}

##---------------------------------------------------------------
##      Function to Plot Anomaly Detection with Threshold      --
##---------------------------------------------------------------
plotUnSupResults <- function(reconstructMSE,testReconstructMSE,threshold){
  results <- data.frame(rbind(reconstructMSE,testReconstructMSE), threshold)
  results$rowname = seq.int(nrow(results))
  cat('\n')
  options(repr.plot.width=8, repr.plot.height=6)
  ggplot(results, aes(x = as.numeric(rowname), y = Reconstruction.MSE, color = as.factor(Class))) +
    geom_point(alpha = 1,size = 3) +
    geom_hline(yintercept = threshold,linetype="dashed", size=2) +
    scale_color_brewer(palette = "Set2") +
    labs(x = "instance number", color = "Class") +
    theme(axis.text=element_text(size=14),
          axis.title=element_text(size=14,face="bold"),
          legend.text=element_text(size=14),
          legend.title=element_text(size=14),
          plot.title = element_text(size=22,hjust = 0.5)) +
    ggtitle("Anomaly Detection Results") 
}
##---------------------------------------------------------------------



##----------------------------------------------------------------
##      Function to calculate Metrics for Supervised Model      --
##----------------------------------------------------------------
calculateMetrics <- function(predict){
  cat('\n')
  options(repr.plot.width=6, repr.plot.height=4)
  predict %>%
    ggplot(aes(x = actual, fill = predict)) +
    geom_bar() +
    theme_bw() +
    scale_fill_brewer(palette = "Set1") +
    facet_wrap( ~ actual, scales = "free", ncol = 2)+
    theme(axis.text=element_text(size=14),
          axis.title=element_text(size=14,face="bold"),
          legend.text=element_text(size=14),
          legend.title=element_text(size=14),
          plot.title = element_text(size=22,hjust = 0.5)) +
    ggtitle("Anomaly Classification")
}

##---------------------------------------------------------------
##               Function to print Model Summary               --
##---------------------------------------------------------------
printSummary <- function(predict){
  df <- predict %>% group_by(actual, predict) %>% summarise(n = n()) %>% mutate(freq = n / sum(n))
  txt <- paste('Total test records : ' , dim(test)[1],'\n Total Fraud Cases : ',df[[3]][4]+df[[3]][3],'\n True Positive : ',df[[3]][4],
               '\n False Positive : ', df[[3]][2],'\n True Negative : ', df[[3]][1],
               '\n False Negative : ', df[[3]][3],'\n',round(df[[4]][4]*100,2),'% of fraud cases were correctly identified',
               '\n',round(df[[4]][1]*100,2),'% of non-fraud cases were correctly identified')
  banner(txt, centre = TRUE, bandChar = "-")
}

##-----------------------------------------------------------------
##  Function to plot Precision-Recall & Sensitivity-Specificity  --
##-----------------------------------------------------------------
plotMetrics <- function(pred){
  cat('\n')
  options(repr.plot.width=8, repr.plot.height=4)
  library(ROCR)
  line_integral <- function(x, y) {
    dx <- diff(x)
    end <- length(y)
    my <- (y[1:(end - 1)] + y[2:end]) / 2
    sum(dx * my)
  } 
  prediction_obj <- prediction(pred$p1, pred$actual)
  par(mfrow = c(1, 2))
  par(mar = c(5.1,4.1,4.1,2.1))
  # precision-recall curve
  perf1 <- performance(prediction_obj, measure = "prec", x.measure = "rec") 
  x <- perf1@x.values[[1]]
  y <- perf1@y.values[[1]]
  y[1] <- 0
  plot(perf1, main = paste("Area Under the\nPrecision-Recall Curve:\n", round(abs(line_integral(x,y)), digits = 3)))

}
