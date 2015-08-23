# gettingdataproject

This is the readme file for the following
Coursera "Getting Data" project
August 2015
R version 3.2.1 (2015-06-18) -- "World-Famous Astronaut"
Platform: x86_64-w64-mingw32/x64 (64-bit)

It is course project for the Coursera Getting Data project

Instructions for project:
"The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected."


The script run_analysis.R does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Background on dataset
The data comes from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The background to the data is at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The dataset has been split for machine learning (test and train components) so both test and train come from same DGP
X_* is actual data, y_* is label of the activity they are doing (walking etc), subject_* identifies the subject

##Steps in tackling project
Part 1
1. The script initially create a file that links activity names and numbers - each activity "eg walking" then is matched to its identifying number. It names these columns appropriately
2. Then brings in the subject identifier file and names the column appropriately.
3. Reads in the data "X_"
4. Reads in the variable names and uses these to name the columns in the data
5. Column binds the subject identifier, the activities and data together to create a dataset
6. Repeats this for the second part of the spliot dataset
7. Row binds the two datasets together to create the full dataset

Part 2.
1. Drops columns with duplicated names
2. Extracts only those columns with "mean." This identifies those variables that are means.
3. Does the same for "std.". This identifies those variables that are standard deviations.
4. Column binds these.

Part 3.
1. Descriptive names for the activities are created in Part 1.

Part 4.
1. Slightly lengthens the variable names to make them more self-explanatory

Comment: I have left mean and std since these are 'standard' abbreviations (in the std case). There are also BodyBody names - this looks like a typo but left as is since these are named like this in the features file.

Part 5.
This is similar to 'collapsing' by subject_id and activity so that there is only one observation per subject per activity (i.e. each subject fills 6 lines but each line is a different activity)
We could make this dataset even 'longer' by stacking each variable by each of its dimensions - make each variable 3 lines - X,Y,X
I have not done this since not all variables have these 3 dimensions
1. This is done through the ddply function (make sure the correct library is loaded)
2. File is then written as required for projcet.
