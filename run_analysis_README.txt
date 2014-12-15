## Coursera: Getting and Cleaning Data
## Course Project

### Introduction

The Function "run_analysis" performs all of the steps requested in the "Getting and Cleaning Data" course project.  Each part will be further explained below.  To repeat the course project, the purpose is to create a tidy dataset from the "Human Activity Recognition Using Smartphones" originally found at "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones" and archived by JHU for use in the course at "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip".

### run_analysis

First, we must have access to the data.  Since the dataset is very large, it didn't make sense to download and unzip the dataset every time the code is executed.  So a check is made to see if the unzipped file exists on the computer.  If the file does not exist, the code will download and unzip the dataset.

The dataset is certainly a messy dataset (perfect for a course on Tidy Data).  The data represents the accelerometer readings from a smart phone when the user is in one of 6 activity states ("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING").  There were 10 users, simply numbered 1-10.  Each reading's raw data were recorded, along with hundreds of derived and fitted transformations of the data.  There are 561 such variables related to the readings, and when combined with the user (subject) and the activity create a data set with 563 variables, and a total of 10299 observations.  Unfortunately, the data is spread across 6 files and the will be combined.

Not all of the variables are required, so once the whole dataset is formed, it will be filtered to only those reading variables related to the mean and standard deviation.  (Some care is needed to exclude the meanFreq variables, as they are not of interest).

The only modification to the raw data was to change the activity names from a number (1-6) to the name "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING".  The variable names were updated to have more meaningful names (and to fix some typos in the original data).  The original time series data was denoted with a "t" and the derived fourier series data was denoted with an "f".  Each of these was updated to reflect the full word "TimeSeries" or "Fourier" respectively.

Each of the original 561 variables related to the reading, actually contained 4 or more variables that should be stored in separately.  For example, the variable named "tBodyAcc-Mean()-X" contains information that this reading is for the "TimeSeries" Filter, from the Body acceleromter (as opposed to the gyroscope), from the "Acc" = acceleration derivative and is the mean in the X dimension.  The data is tranformed so that these variables are separately.

Lastly, now that the data is fairly tidy, some summariziation statistics are gathered.  For each subject and activity, the function calculates the mean across each variable.  This final tidy dataset is written back to a file, called "GettingData-CourseProject.txt".

