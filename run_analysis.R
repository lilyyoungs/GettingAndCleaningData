setwd("C:/Users/li.yang/Documents/Projects/Data Scientist/R")

# download and unzip the ZIP data file.
filename<-"download.zip"
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, method="curl")
    unzip(filename) 
}  

#get working directory
path<-getwd()

# Load activity labels + features
activityLabels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
featureIndex<-grepl("mean|std",features[,2])
featureWanted<-as.character(features[featureIndex,2])

#Load train and test Datasets
#file.path(path,"train/X_train.txt")
traindata<-read.table(file.path(path,"train/X_train.txt"))[,featureIndex]
trainActivities <- read.table(file.path(path,"train/Y_train.txt"))
trainSubjects <- read.table(file.path(path,"train/subject_train.txt"))
train<-cbind(trainSubjects, trainActivities, traindata)

testdata<-read.table(file.path(path,"test/X_test.txt"))[,featureIndex]
testActivities <- read.table(file.path(path,"test/Y_test.txt"))
testSubjects <- read.table(file.path(path,"test/subject_test.txt"))
test<-cbind(testSubjects, testActivities, testdata)

# combine the datasets
fulldata<-rbind(train, test)

# rename the column names
colnames(fulldata)<-c("subject", "activity",featureWanted)

#convert subject and activity to factor
fulldata$activity<-factor(fulldata$activity, levels=activityLabels[,1], labels=activityLabels[,2])
fulldata$subject<-as.factor(fulldata$subject)

#create the tidy dataset
library(plyr)
tidydata<-ddply(fulldata, .(subject, activity), numcolwise(mean))
write.csv(tidydata, "tidydata.csv")
