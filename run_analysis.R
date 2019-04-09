# You should create one R script called run_analysis.R that does the following.
# 
# -Merges the training and the test sets to create one data set.
# -Extracts only the measurements on the mean and standard deviation for each measurement.
# -Uses descriptive activity names to name the activities in the data set
# -Appropriately labels the data set with descriptive variable names.
# -From the data set in step 4, creates a second, independent tidy data set with the average of each variable
#   for each activity and each subject.
library(plyr)

# download data files
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/data.zip")

# Unzip
unzip(zipfile="./data/data.zip",exdir="./data")

# # read tables

# test directory
x_test <- read.table("./data/UCI HAR dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR dataset/test/subject_test.txt")

# train directory
x_train <- read.table("./data/UCI HAR dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR dataset/train/subject_train.txt"

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")


# assign col names
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityid"
colnames(subject_test) <- "subjectid"

colnames(x_train) <- features[,2]
colnames(y_train) <- "activityid"
colnames(subject_train) <- "subjectid"

colnames(activity_labels) <- c('activityid','activitytype')

# Merges the training and the test sets to create one data set
merge_test <- cbind(y_test,subject_test,x_test)
merge_train <- cbind (y_train,subject_train,x_train)
merge_all <- rbind(merge_train,merge_test)

# Extracts only the measurements on the mean and standard deviation for each measurement
all_col_names <- colnames(merge_all)
mean_std <- (grepl ("activityid", all_col_names) | grepl ("subjectid",all_col_names) | 
               grepl("mean..",all_col_names) | grepl("std..",all_col_names))
mean_std_true <- merge_all[ , mean_std == TRUE]
set_activity_names <- merge(mean_std_true, activity_labels, by='activityid', all.x=TRUE)
set2 <- aggregate(. ~subjectid + activityid, set_activity_names, mean)
set2 <- set2[order(set2$subjectid, set2$activityid),]
write.table(set2, "tidy_data.txt", row.name=FALSE)
