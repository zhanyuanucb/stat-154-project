library(glmnet)
library(ggplot2)
library(dplyr)
library(HDCI)
library(caret)
library(MASS)
library(e1071)
library(glmnet)
library(tidyr)
library(ROCR)
library(randomForest)
library(purrr)
library(tidyr)
library(ggpubr)

CVgeneric <- function(train_x, train_y, k, loss_fn, model, thresh=0.5, mtry = 7, nodesize=50, ntree=10) {
  flds = createFolds(1:nrow(train_x), k = k)
  avg_acc = c()
  for (i in 1:k) {
    cv_train = data.frame()
    for (j in 1:(k-1)) {
      cv_train = rbind.data.frame(cv_train, train_x[flds[[j]], ])
    }
    cv_val = train_x[flds[[i]], ]
    cv_val_label = train_y[flds[[i]]]
    if (model == 'lda') {
      clf = lda(label ~ ., data = cv_train)
    } else if (model == 'qda') {
      clf = qda(label ~ ., data = cv_train)
    } else if (model == 'logit') {
      clf = glm(label ~ ., data = cv_train, family = binomial(link = "logit"))
      
      y_hat = get_logit_pred(clf, cv_val, thresh = thresh)
      temp = loss_fn(cv_val_label, y_hat)
      
      avg_acc = c(avg_acc, temp)
    } else if (model == "rf") { #randomForest(size_train[, -1], factor(size_train[, 1]), mtry = 7, nodesize = 50 , ntree = 10)
      clf = randomForest(train_x[, -1], factor(train_x[, 1]), mtry = mtry, nodesize = nodesize, ntree = ntree)
      
      temp = loss_fn(cv_val_label, predict(clf, cv_val))
      avg_acc = c(avg_acc, temp)
    }
    if (model != "logit" && model != "rf") {
      y_hat = predict(clf, cv_val)$class
      temp = loss_fn(cv_val_label, y_hat)
      
      avg_acc = c(avg_acc, temp)
    }
  }
  return(list(fold_acc = avg_acc, error_rate = 1 - avg_acc))
}