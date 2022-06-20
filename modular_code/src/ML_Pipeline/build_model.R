##---------------------------------------------------------------
##            Function to build Deep Learning model            --
##---------------------------------------------------------------
buildModel <- function(features, trainData, hiddenUnits, labels=NULL, enableAutoEncode=FALSE, reproducible=TRUE, 
                       ignoreConstCol=FALSE, balanceClasses=TRUE, seedNo=123,  epochValue=50, activationFunc='Tanh',
                       model_name=NULL,pretrainedEncoder=NULL){
  
  # Check for autoencoder for supervised and unsupervised model
  if(enableAutoEncode){
    model <- h2o.deeplearning(x = features, training_frame = trainData, autoencoder = enableAutoEncode, 
                              reproducible = reproducible, ignore_const_cols = ignoreConstCol, 
                              seed = seedNo, hidden = hiddenUnits, model_id = model_name,
                              epochs = epochValue, activation = activationFunc)
  }
  else{
    model <- h2o.deeplearning(x = features, y=labels, training_frame = trainData, balance_classes = balanceClasses, 
                              reproducible = reproducible, ignore_const_cols = ignoreConstCol, 
                              seed = seedNo, hidden = hiddenUnits, pretrained_autoencoder = pretrainedEncoder,
                              epochs = epochValue, activation = activationFunc)
  }
  return(model)
}

