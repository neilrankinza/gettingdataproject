#Coursera "Getting Data" project
#Augsut 2015
#R version 3.2.1 (2015-06-18) -- "World-Famous Astronaut"
#Platform: x86_64-w64-mingw32/x64 (64-bit)


#####Instructions

# You should create one R script called run_analysis.R that does the following. 

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#######Background on dataset
# The dataset has been split for machine learning (test and train components) so both test and train come from same DGP
#
# X_* is actual data, y_* is label of the activity they are doing (walking etc), subject_* identifies the subject



#laoding libraries

library(data.table)
library(RCurl)
library(dplyr)
library(plyr)
library(xlsx)
library(readxl)
library(pastecs)

#getting rid of scientific notation
options(scipen=100)
options(digits=2)


#set a working directory HERE
setwd("C:/Users/neilrankin/Dropbox/neil/1/Courses/Coursera/Getting data/Project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")


#bring in activity_labels from text file
activity_labels <- read.table(("activity_labels.txt"))

#bring in activity_numbers
y_test <- read.table("test/y_test.txt")

#merge - or full_join in dplyr V1 indexes variable to join by
#this creates a data.frame with the activity number and the associated activity name
y_test <- full_join(y_test, activity_labels)

#naming columns in the data.frame
colnames(y_test) <- c("activity_number", "activity_name")

#bring in the data with the subject number and then add a subject identifier
subject_test <- read.table("test/subject_test.txt")
colnames(subject_test) <- "subject_id"


#bring in data
X_test <- read.table("test/X_test.txt")
#bring in names of the variables
names <- read.table(("features.txt"), stringsAsFactors = FALSE)

variable_names <- make.names(unlist(select(names, V2))) #need to do this to get a vector out of the data.frame to use in naming, using make.names to get valid names and avoid a problem later when I try to extract columns by their names

#name the columns with the variable names
colnames(X_test) <- variable_names

#bind these all together
test_dataset <- cbind(subject_test, y_test, X_test) 
head(test_dataset)

#test data done, now do the same for the train data

#bring in activity_numbers
y_train <- read.table("train/y_train.txt")

#merge - or full_join in dplyr V1 indexes variable to join by
#this creates a data.frame with the activity number and the associated activity name
y_train <- full_join(y_train, activity_labels)

#naming columns in the data.frame
colnames(y_train) <- c("activity_number", "activity_name")

#bring in the data with the subject number and then add a subject identifier
subject_train <- read.table("train/subject_train.txt")
colnames(subject_train) <- "subject_id"


#bring in data
X_train <- read.table("train/X_train.txt")

#name the columns with the variable names
colnames(X_train) <- variable_names

#bind these all together
train_dataset <- cbind(subject_train, y_train, X_train) 
head(train_dataset)


full_dataset <- rbind(test_dataset, train_dataset)

#######End of step 1


#Step 2. Extract only the measurements on the mean and standard deviation for each measurement. 

#Have to match mean() and std() but gotten rid of () earlier so match .mean and .std in column names
#First drop columns with duplicated names
full_dataset <- full_dataset[ , !duplicated(colnames(full_dataset))]


###Have not fully figured out regular expressions so match as a two-step process
#have kept variables like meanFreq
mean_dataset <- select(full_dataset, contains(".mean"))

std_dataset <- select(full_dataset, contains(".std"))

mean_std_dataset <- cbind(full_dataset[ , 1:3], mean_dataset, std_dataset) #have full_dataset in there to include subject_id and activities


######End of step 2



#Step 3 Uses descriptive activity names to name the activities in the data set
#done earlier - see activity_names
head(mean_std_dataset[1:3])


#####End of step 3

#Step 4 Appropriately labels the data set with descriptive variable names.


names(mean_std_dataset) <- gsub("^f", "Frequency", names(mean_std_dataset))
names(mean_std_dataset) <- gsub("^t", "Time", names(mean_std_dataset))
names(mean_std_dataset) <- gsub("Acc", "Accelerometer", names(mean_std_dataset))
names(mean_std_dataset) <- gsub("Gyro", "Gyroscope", names(mean_std_dataset))
names(mean_std_dataset) <- gsub("Mag", "Magnitude", names(mean_std_dataset))
names(mean_std_dataset) <- gsub("+Freq", "Frequency", names(mean_std_dataset)) #this picks up the meanFreq variables


#have left mean and std since these are 'standard' abbreviations (in the std case)
#there are also BodyBody names - this looks like a typo but left as is since these are named like this in features file.

#####End of step 4


#Step 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
#This is similar to 'collapsing' by subject_id and activity so that there is only one observation per subject per activity (i.e. each subject fills 6 lines but each line is a different activity)
#We could make this dataset even 'longer' by stacking each variable by each of its dimensions - make each variable 3 lines - X,Y,X
#I have not done this since not all variables have these 3 dimensions

#Collapsing

collapsed_data <- ddply(mean_std_dataset, c("subject_id", "activity_name"), colwise(mean)) #Yes it works!

#check that it really does
head(collapsed_data, n=10)


write.table(collapsed_data, file = "getting_data_dataset.txt", row.name=FALSE) #As per instructions


