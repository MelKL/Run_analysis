#getting the data
# Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(url, destfile = "Dataset.zip", mode = "wb")
# unzip("Dataset.zip")

#reading the data 0
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
x_test <- read.table("./test/X_test.txt")
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
feature <- read.table("./features.txt")

#giving label 4
colnames(x_test) <- feature$V2
colnames(x_train) <- feature$V2
colnames(y_test) <- c("activity")
colnames(y_train) <- c("activity")
colnames(subject_test) <- c("subject")
colnames(subject_train) <- c("subject")

#merge the data 1
test <- cbind(x_test, y_test,subject_test)
train <- cbind(x_train,y_train,subject_train)
mergeData <- rbind(test,train)

#extract mean and std deviation 2
xtract <- grep("mean\\(\\)|std\\(\\)", feature[,2])
xx <- mergeData[, xtract]

# adding descriptive activity names 3
mergeData$activity[mergeData$activity == 1] <- "WALKING"
mergeData$activity[mergeData$activity == 2] <- "WALKING_UPSTAIRS"
mergeData$activity[mergeData$activity == 3] <- "WALKING_DOWNSTAIRS"
mergeData$activity[mergeData$activity == 4] <- "SITTING"
mergeData$activity[mergeData$activity == 5] <- "STANDING"
mergeData$activity[mergeData$activity == 6] <- "LAYING"

#Creating tidy data set with average of each variable / activity pair
tidyData <- aggregate(mergeData, by=list(activity = mergeData$activity, subject=mergeData$subject),mean)
tidycolnames <- colnames(tidyData)
tidycolnames <- gsub("-mean()","mean",tidycolnames,fixed=TRUE)
tidycolnames <- gsub("-std()","std",tidycolnames,fixed=TRUE)
tidycolnames <- tolower(tidycolnames)

colnames(tidyData) <- tidycolnames

write.table(tidyData, "./tidyData.txt", sep =",", row.names=FALSE)
