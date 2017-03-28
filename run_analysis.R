## Set working directory
setwd("~/R_working/DataCleaningWeek4")

## Load reshape2 package
## From: http://seananderson.ca/2013/10/19/reshape.html
## "...an R package...that makes it easy to transform data between wide and long formats."
## "...melt takes wide-format data and melts it into long-format data."
## "...cast takes long-format data and casts it into wide-format data."
library(reshape2)

## Detect data - download it and/or unzip it if not found
if (!file.exists("UCI HAR Dataset")){
  zipFile <- "UCIHARdataset.zip"
  if (!file.exists(zipFile)){
    zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(zipURL,zipFile)
  }
  unzip(zipFile)
}

# Load activity labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract just the mean and std data
featuresExtracted <- grep(".*mean.*|.*std.*",features[,2])
featuresExtracted.names <- features[featuresExtracted,2]
featuresExtracted.names = gsub('-mean','Mean',featuresExtracted.names)
featuresExtracted.names = gsub('-std','Std',featuresExtracted.names)
featuresExtracted.names <- gsub('[-()]','',featuresExtracted.names)

# Load and bind the test and train data by column
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresExtracted]
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresExtracted]
testActivities <- read.table("UCI HAR Dataset/test/y_test.txt")
trainActivities <- read.table("UCI HAR Dataset/train/y_train.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
test <- cbind(testSubjects,testActivities,test)
train <- cbind(trainSubjects,trainActivities,train)

# bind (merge) test and train data sets by row and assign column labels
combined <- rbind(test,train)
colnames(combined) <- c("subject","activity",featuresExtracted.names)

# "factorize" activities and subjects
combined$activity <- factor(combined$activity,levels=activityLabels[,1],labels=activityLabels[,2])
combined$subject <- as.factor(combined$subject)

# stack rows with melt
molten <- melt(combined,id=c("subject","activity"),na.rm=TRUE)
# reshape molten data with average value per variable for each subject and activity
combinedMean <- dcast(molten,subject+activity~variable,mean)

# Write out file with tidy data set 
write.table(combinedMean,"UCIHAR_averages_tidy.txt") 