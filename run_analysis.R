##Downloading the file from internet
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

##Unzipping the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

setwd("C:/Bharath/Bharath's/Data Science using R John HPKNS/Getting and Cleaning Data - Course3")

path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

##Reading the Activity files

data_ActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
data_ActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

data_SubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
data_SubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

data_FeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
data_FeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

## 1. Merges the training and the test sets to create one data set
data_Combined_Subject <- rbind(data_SubjectTrain, data_SubjectTest)
data_Combined_Activity<- rbind(data_ActivityTrain, data_ActivityTest)
data_Combined_Features<- rbind(data_FeaturesTrain, data_FeaturesTest)

head(data_Combined_Subject)

##Setting Names to Variables
names(data_Combined_Subject)<-c("Subject")
names(data_Combined_Activity)<- c("Activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(data_Combined_Features)<- dataFeaturesNames$V2

##Building a data frame by merging all the data sets
data_Combined <- cbind(data_Combined_Subject, data_Combined_Activity)
Final_Data <- cbind(data_Combined_Features, data_Combined)

head(Final_Data)

##Extracts only the measurements on the mean and standard deviation for each measurement
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data <- subset(Final_Data,select=selectedNames)
str(Data)

##Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
head(Data$activity,30)

##Appropriately labels the data set with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

head(Data)
names(Data)

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity 
#and each subject.

library(plyr);
Final_Data2<-aggregate(. ~Subject + Activity, Data, mean)
Final_Data2<-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Final_Data2, file = "My_Final_Tidy_Data.txt",row.name=FALSE)

##Producing of the Code Book
library(knitr);
knit2html(codebook.Rmd);






