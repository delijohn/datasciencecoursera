
## Read in data
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE)
stest <- read.table("UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE)

## prepare for merging test data
colnames(ytest) <- c("activity")  
colnames(stest) <- c("subject") 

## merge test data
combined_test_data <- bind_cols(stest,xtest)
combined_test_data <- bind_cols(ytest,combined_test_data)

## Read train data
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE)
strain <- read.table("UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE)

## prepare for merging train data
colnames(ytrain) <- c("activity")  
colnames(strain) <- c("subject")

## merge test data
combined_train_data <- bind_cols(strain,xtrain)
combined_train_data <- bind_cols(ytrain,combined_train_data)

## merge test and train data
combined_data <- bind_rows(combined_test_data,combined_train_data)

## remove all intermediate data
rm(xtest)
rm(ytest)
rm(stest)
rm(xtrain)
rm(ytrain)
rm(strain)
rm(combined_test_data)
rm(combined_train_data)

## readin features list
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

## remove duplicate Columns names
combined_data <- select(combined_data, -( num_range("V", which(duplicated(features[,2]))) ) ) 
features <- features[,2]
features <- features[!duplicated(features)]

## assign column names to combined_data
colnames(combined_data) <- c("activity","subject",features)

## Extracts only the measurements on the mean and standard deviation for each measurement
p.2 <- select(combined_data, activity,subject ,contains("mean()") , contains("std()") )

## prepare for aply discriptive names
act_lab <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(act_lab) <- c("activity","activity_label")
## Uses descriptive activity names to name the activities in the data set
p.3 <- left_join(act_lab,p.2, by = "activity")
p.3 <- select(p.3,-activity)

## Appropriately labels the data set with descriptive variable names. 
## p.3 contains descriptive variable names


## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
grouped <- group_by(p.4,activity_label,subject)
p.5 <- summarise_each(grouped,funs(mean))

write.table(p.5,row.name=FALSE, file = "p.5.txt")
