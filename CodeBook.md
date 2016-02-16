### The Raw Data

This uses the Human Activity Recognition Using Smartphones (HARUS) Dataset which contains collected data from an experiment carried out with 30 volunteers between 19-48 years of age. Volunteers are asked to perform six different activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) while wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

### The Processed Data

The processed data contains the following columns:

* activityid    - a numeric value equivalent to a specific activity type
* activityname  - the name of the activity {WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING}
* subjid        - a numeric value identifying a specific volunteer
* _measurement type_ - this applies to the rest of the column which contains the following description:
  + {mean or std} - mean or standard deviation value
  + {acc or gyro} - accelerometer or gyroscopic measurement

### Data Processing

#### Load Required Packages
```{r}
library(data.table)
```

#### Read the required file into a data.table
```{r}
# function to read and process harusd
read.harusd <- function(dataDir, colNames){
	dataType <- basename(dataDir)
	print(paste("Getting", dataType, "data"))
	subjId <- fread(paste0(dataDir,"/subject_",dataType,".txt"))$V1
	y_data <- fread(paste0(dataDir,"/y_",dataType,".txt"))$V1
	x_data <- fread(paste0(dataDir,"/X_",dataType,".txt"))
	names(x_data) <- colNames
	return (data.table(subjid=subjId,activityid=y_data,x_data))
}

dataDir <- "UCIHARDataset"
outDir <- "output"
if (!file.exists(outDir)) dir.create(outDir)

# read column names
featNames <- fread(paste0(dataDir,"/features.txt"))$V2

# read and process the data
testDat <- read.harusd(paste(dataDir,"test",sep="/"),featNames)
trainDat <- read.harusd(paste(dataDir,"train",sep="/"),featNames)
```

#### Merge the training and the test sets to create one data set
```{r}
mergedDat <- rbind(testDat, trainDat)
```

#### Extract only the measurements on the mean and standard deviation for each measurement
```{r}
outDat <- mergedDat[,c(1,2,grep("mean|std", colnames(mergedDat))),with=F]
```

#### Use descriptive activity names to name the activities in the data set
```{r}
activityNames <- fread(paste0(dataDir,"/activity_labels.txt"))
names(activityNames) <- c("activityid","activityname")
outDat <- activityNames[outDat,on="activityid"]

```

#### Label the data set appropriately with descriptive variable names.
```{r}
names(outDat) <- tolower(gsub("\\.$","",gsub("[^a-zA-Z0-9]+","\\.",names(outDat))))
names(outDat) <- gsub("^t","time",names(outDat))
names(outDat) <- gsub("^f","freq",names(outDat))
write.csv(outDat,paste0(outDir,"/tidyData1.csv"))
```

#### Create a second, independent tidy data set with the average of each variable for each activity and each subject.
```{r}
summaryDat <- outDat[, lapply(.SD, mean), by=list(activityid,activityname,subjid)]
```