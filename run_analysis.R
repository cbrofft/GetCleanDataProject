
setwd("../")
if (!file.exists("GetCleanDataProject"))
{
  dir.create("GetCleanDataProject")
}
setwd("GetCleanDataProject")
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "dataprojectfiles.zip", method = "curl")
unzip("dataprojectfiles.zip")
file.remove("dataprojectfiles.zip")
training <- read.table("UCI HAR Dataset/train/X_train.txt")
trainingact <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainingsubj <- read.table("UCI HAR Dataset/train/subject_train.txt")

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testact <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubj <- read.table("UCI HAR Dataset/test/subject_test.txt")

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])



training <- cbind(trainingsubj, trainingact, training)
test <- cbind(testsubj, testact, test)

featuresclean <- grep(".*mean.*|.*std.*", features[,2])
featuresclean.names = gsub('-mean', 'Mean', featuresclean.names)
featuresclean.names = gsub('-std', 'Std', featuresclean.names)
featuresclean.names <- gsub('[-()]', '', featuresclean.names)


training <- training[featuresclean]
test <- test[featuresclean]

FinalData <- rbind(training, test)
colnames(FinalData) <- featuresclean.names


unlink("UCI HAR Dataset", recursive = TRUE)