library(data.table)

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

# Merges the training and the test sets to create one data set
mergedDat <- rbind(testDat, trainDat)

# Extracts only the measurements on the mean and standard deviation for each measurement
outDat <- mergedDat[,c(1,2,grep("mean|std", colnames(mergedDat))),with=F]

# Uses descriptive activity names to name the activities in the data set
activityNames <- fread(paste0(dataDir,"/activity_labels.txt"))
names(activityNames) <- c("activityid","activityname")
outDat <- activityNames[outDat,on="activityid"]

# Appropriately labels the data set with descriptive variable names.
names(outDat) <- tolower(gsub("\\.$","",gsub("[^a-zA-Z0-9]+","\\.",names(outDat))))
names(outDat) <- gsub("^t","time",names(outDat))
names(outDat) <- gsub("^f","freq",names(outDat))
write.csv(outDat,paste0(outDir,"/tidyData1.csv"))

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
summaryDat <- outDat[, lapply(.SD, mean), by=list(activityid,activityname,subjid)]
write.csv(summaryDat,paste0(outDir,"/tidyData2.csv"))