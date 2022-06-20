setwd("set the path here")

# Import package installaion script
source("ML_Pipeline/packages.R")
source("ML_Pipeline/utils.R")
source("ML_Pipeline/data_prep.R")
source("ML_Pipeline/build_model.R")
source("ML_Pipeline/model_eval.R")
Req_Packages()

creditcard <- loadSourceData("../input/creditcard.csv")


# Convert Data to H2oFrame
h2o.init()
creditcard_hf <- as.h2o(creditcard)

# Split Data
rtList <- splitData(creditcard_hf, ratios = c(0.7))
train <- rtList[[1]]
test <- rtList[[2]]

# Define Feature space
response <- "Class" 
features <- setdiff(colnames(train), response)





### Supervised Learning with AutoEncoder Features

# extracting feature names
features <- setdiff(colnames(train), response)

# converting class into factor

features_new <- train %>%
  as.data.frame() %>%
  mutate(Class = as.factor(as.vector(train[, 31]))) %>%
  as.h2o()


# Build Supervised Model with output Hidden Layer
modelSup <- buildModel(features = features,labels = response,trainData = features_new,hiddenUnits = c(20, 5, 20))

saveRDS(modelSup, "../output/modelSup.rds")


# Lets predict using the above model for test data

pred <- as.data.frame(h2o.predict(object = modelSup, newdata = test)) %>%  mutate(actual = as.vector(test[, 31]))

Cmatrix <- confusionMatrix(data=factor(pred$predict), reference = factor(as.vector(test[, 31])))
Cmatrix


# Calculate and plot Model Metrics
printSummary(pred)
calculateMetrics(pred)



# Build Unsupervised model with Auto Encoders
modelUnSup <- buildModel(features = features,trainData = train, hiddenUnits = c(20, 5, 20)
                         ,enableAutoEncode=TRUE,model_name='modelUnSup')

# save the model to disk
saveRDS(modelUnSup, "../output/modelUnSup.rds")

# Get Reconstructed MSE score for each observation in training data
reconstructMSE <- getAnomalyScore(modelUnSup,train)

# Calculate threshold
threshold <- calculateThreshold(reconstructMSE$Reconstruction.MSE,0.995)

# Get Reconstructed MSE score for test data
testReconstructMSE <- getAnomalyScore(modelUnSup,test)

# Calculate and plot model performance
calculateMetricsUnSup(testReconstructMSE$Reconstruction.MSE,threshold,test)




