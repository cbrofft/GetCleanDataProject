## Setting up project directory and getting the project files from the source
setwd("../")
if (!file.exists("GetCleanDataProject"))
{
  dir.create("GetCleanDataProject")
}
setwd("GetCleanDataProject")
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "dataprojectfiles.zip", method = "curl")

## Unzipping the project files and then removing the zip file from the project
## directory for space conservation
unzip("dataprojectfiles.zip")
file.remove("dataprojectfiles.zip")

## Reading in the training tables from the project files.  Changing the column names
## for activity and subject in order to better understand what we are dealing with
training <- read.table("UCI HAR Dataset/train/X_train.txt")
trainingact <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainingsubj <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(trainingact) <- "activity"
colnames(trainingsubj) <- "subject"

## Reading in the test tables from the project files.  Changing the column names
## for activity and subject in order to better understand what we are dealing with
test <- read.table("UCI HAR Dataset/test/X_test.txt")
testact <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubj <- read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(testact) <- "activity"
colnames(testsubj) <- "subject"

## Reading in the activity labels that will later be used to update the activity
## column
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])

## Reading in the feature descriptions that will used to narrow our data down and 
## provide more context
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## Narrowing our data down to include mean and std only.  Also cleaning the data
## so that its more understandable by removing unnessesary text elements
featuresclean <- grep(".*mean.*|.*std.*", features[,2])
featuresclean.names <- features[featuresclean,2]
featuresclean.names <- gsub('-mean', 'Mean', featuresclean.names)
featuresclean.names <- gsub('-std', 'Std', featuresclean.names)
featuresclean.names <- gsub('[-()]', '', featuresclean.names)

## Updating the main training and test tables to include only the mean and std
## elements which were previously identified using grep
training <- training[featuresclean]
test <- test[featuresclean]

## Combining subject and activity columns to the main training and test tables
training <- cbind(trainingsubj, trainingact, training)
test <- cbind(testsubj, testact, test)

## Compiling the final data object which will be used by combining rows for training and 
## test.  Adding the column names for the features to the final data
FinalData <- rbind(training, test)
colnames(FinalData) <- c("subject", "activity", featuresclean.names)

## Making activties and subjects into factors in preperation for melting the final data
FinalData$activity <- factor(FinalData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
FinalData$subject <- as.factor(FinalData$subject)

## Melting final data based on subject and activity.  Next we cast the the mean function
## onto the variable column using subject and activity as the formula
meltfinal <- melt(FinalData, id = c("subject", "activity"))
MeanFinal <- dcast(meltfinal, subject + activity ~ variable, mean)

## Write the project output file to the project directory
write.table(MeanFinal, "tidy.txt", row.names = FALSE, quote = FALSE) 

unlink("UCI HAR Dataset", recursive = TRUE)