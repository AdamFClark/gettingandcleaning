## Coursera: Getting and Cleaning Data
## Course Project

run_analysis <- function() {
  # Get the data, read it into R
  # The file is too large to download every time, so check to see if it is already downloaded
  if(!file.exists("./getdata-projectfiles-UCI-HAR-Dataset.zip") | !file.exists("./UCI HAR Dataset/test/X_test.txt")){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL,destfile="getdata-projectfiles-UCI-HAR-Dataset.zip")
    unzip(zipfile="getdata-projectfiles-UCI-HAR-Dataset.zip",exdir="UCI HAR Dataset") 
  }
  
  # It is necessary to make sure the column names are set early, as some functions change the column order
  yfeatures <- read.table("UCI HAR Dataset/features.txt")
  xtestdata1 <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = yfeatures[,2])
  atestdata1 <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")
  stestdata1 <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
  xtraindata1 <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = yfeatures[,2])
  atraindata1 <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
  straindata1 <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
  
  ###########
  #Part 1: Merges the training and the test sets and the labels to create one data set.
  # first bind the three test datasets into one frame
  xtestdata2 <- cbind(atestdata1,stestdata1,xtestdata1)
  # then bind the three training datasets into one frame
  xtraindata2 <- cbind(atraindata1,straindata1,xtraindata1)
  # Since the data sets were given the correct labels when they were read in, then the two datasets are easy to stick together
  xdata3 <- rbind(xtestdata2,xtraindata2)
  finalFeatures <- c("activity","subject",as.character(yfeatures[,2]))
  
  ###########
  #Part 2: Extracts only the measurements on the mean and standard deviation for each measurement
  # The approach is to make a list the same length as finalFeatures with a TRUE if we keep the field and a FALSE if we want to remove the field
  #  The steps are: use "str_count" to count the number of occurances the specific characters show up in the feature name
  #                 then use "sapply" to turn "1" and "0" in to "TRUE" and "FALSE"
  #                 Do this for each specific string (mean(), std(), meanFreq()) and then combine the TRUE/FALSE strings using logic statements
  library(stringr)
  meanCount <- str_count(finalFeatures, "mean()")
  stdvCount <- str_count(finalFeatures, "std()")
  freqCount <- str_count(finalFeatures, "meanFreq()")
  hasMean <- sapply(meanCount, function(x) ifelse(x[1] > 0, TRUE, FALSE))
  hasStdv <- sapply(stdvCount, function(x) ifelse(x[1] > 0, TRUE, FALSE))
  hasFreq <- sapply(freqCount, function(x) ifelse(x[1] > 0, TRUE, FALSE))
  keepFeature <- hasMean | hasStdv #This is a vector of T/F values.  "TRUE" indicates the field has either mean() or std() in the name
  keepFeature <- keepFeature & !hasFreq #must remove the fields with Freq in them, we don't want MeanFreq(), just Mean()
  keepFeature[1:2] <- TRUE #keep activity and subject
  # Now the list keepFeature is the final list of fields we want to keep, save that in xdata4
  xdata4 <- xdata3[,keepFeature] #There are 66+ remaining variables plus the Activity and Subject for 68
  
  ###########
  #Part 3: Uses descriptive activity names to name the activities in the data set
  ActivityNames <- data.frame("code" = c(1:6), "activity" = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
  Activity <- sapply(xdata4[,1], function(x) gsub(ActivityNames[x[1],1],ActivityNames[x[1],2],x[1]) )
  xdata5 <- cbind(Activity,xdata3[2:68])
  
  ###########
  #Part 4: Appropriately labels the data set with descriptive variable names
  NewNames1 <- finalFeatures[keepFeature]
  NewNames1 <- gsub("\\()-","",NewNames1) #To get rid of "()-" I had to Escape the paranthesis with "\\"
  NewNames1 <- gsub("\\()$","",NewNames1) #To get rid of "()" when it appears at the end of the string
  NewNames1 <- gsub("BodyBody","Body",NewNames1)
  NewNames1 <- gsub("fBody","Fourier.Body.",NewNames1)
  NewNames1 <- gsub("tBody","TimeSeries.Body.",NewNames1)
  NewNames1 <- gsub("fGravity","Fourier.Grav.",NewNames1)
  NewNames1 <- gsub("tGravity","TimeSeries.Grav.",NewNames1)
  NewNames1 <- gsub("-",".",NewNames1)
  names(xdata5) <- NewNames1
  
  #Part 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  library(tidyr) # To use the gather, separate, group_by and summarize
  library(dplyr) # To use the %>% operator
  xdata6 <- xdata5 %>%
            gather(Measure,Reading,-activity, -subject) %>%
            separate(Measure,into=c("Filter","Signal","Accelerometer","MeasureType"),sep="\\.") %>%
            group_by(activity,subject) %>%
            summarize(MeanReading = mean(Reading))
  
  write.table(xdata6, "GettingData-CourseProject.txt", row.name=FALSE )
    
}