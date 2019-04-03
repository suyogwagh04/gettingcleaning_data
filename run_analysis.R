library(plyr)

# ---------------------- STEP 1
# -------- Merge the training and the test sets to create one data set


# Load the train and test data sets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Create the 'x', 'y' and 'subject data sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
names(subject) <-"SubjectId"


## ---------------------- STEP 2
# -------- Extract only the measurements on the mean and standard deviation for each measurement


# Load the 'features' data set
features <- read.table("UCI HAR Dataset/features.txt")

# Subset only columns with mean() and std(), and adjust column names
extracted_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x_data <- x_data[, extracted_features]
names(x_data) <- features[extracted_features, 2]


### ---------------------- STEP 3
# -------- Use descriptive activity names to name the activities in the data set


# Load 'activity_labels' data set, update correct activity names and adjust column names
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
y_data[, 1] <- activity_labels[y_data[, 1], 2]
names(y_data) <- "Activity"

# Bind all data in a single data set
all_data <- cbind(x_data, y_data, subject)


#### ---------------------- STEP 4
# -------- Appropriately labels the data set with descriptive variable names


# Adjust variable names not adjusted earlier
names(all_data) <- gsub("Acc", "Accelerometer", names(all_data))
names(all_data) <- gsub("Gyro", "Gyroscope", names(all_data))
names(all_data) <- gsub("BodyBody", "Body", names(all_data))
names(all_data) <- gsub("Mag", "Magnitude", names(all_data))
names(all_data) <- gsub("angle", "Angle", names(all_data))
names(all_data) <- gsub("gravity", "Gravity", names(all_data))
names(all_data) <- gsub("^t", "Time", names(all_data))
names(all_data) <- gsub("^f", "Frequency", names(all_data))
names(all_data) <- gsub("-mean()", "Mean", names(all_data))
names(all_data) <- gsub("-std()", "Std", names(all_data))


##### ---------------------- STEP 5
# -------- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject


# Create a tidy dataset with the mean value of each variable for each subject and each activity
tidy_data <- ddply(all_data, .(SubjectId, Activity), function(x) colMeans(x[, 1:66]))
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
