# Getting and Cleaning Data Course Project

### Overview
This project will use and process the Human Activity Recognition Using Smartphones (HARUS) Dataset to produce new dataset that is ready for analysis.

The link of the raw data can be downloaded here:

```
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
```

The main R script for processing this data is the _run_analysis.R_ script file that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.