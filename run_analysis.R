UCI_HAR_Dataset <- file.path("C:/--Coursera/projs" , "UCI HAR Dataset")
files<-list.files(UCI_HAR_Dataset, recursive=TRUE)

# Read data

features_test_data  <- read.table(file.path(UCI_HAR_Dataset, "test" , "X_test.txt" ),header = FALSE)
activity_test_data  <- read.table(file.path(UCI_HAR_Dataset, "test" , "Y_test.txt" ),header = FALSE)
subject_test_data  <- read.table(file.path(UCI_HAR_Dataset, "test" , "subject_test.txt"),header = FALSE)
features_train_data <- read.table(file.path(UCI_HAR_Dataset, "train", "X_train.txt"),header = FALSE)
activity_train_data <- read.table(file.path(UCI_HAR_Dataset, "train", "Y_train.txt"),header = FALSE)
subject_train_data <- read.table(file.path(UCI_HAR_Dataset, "train", "subject_train.txt"),header = FALSE)



# Merge train & test for each dataset 

features_data <- rbind(features_train_data, features_test_data)
subject_data <- rbind(subject_train_data, subject_test_data)
activity_data <- rbind(activity_train_data, activity_test_data)


# Set names to variables

features_names <- read.table(file.path(UCI_HAR_Dataset, "features.txt"),head=FALSE)
names(features_data) <-  features_names$V2
names(subject_data) <-c("subject")
names(activity_data) <- c("activity")


# Merge all data sets

all_data_set <- cbind( features_data, subject_data, activity_data)


# Get columns with mean() or std()

subset_features_names<-features_names$V2[grep("mean\\(\\)|std\\(\\)", features_names$V2)]

# Subset names of features

selected_names<-c(as.character(subset_features_names), "subject", "activity" )
all_data_set <- subset(all_data_set ,select=selected_names)


# Use descriptive activity names

activity_labels <- read.table(file.path(UCI_HAR_Dataset, "activity_labels.txt"),header = FALSE)


# label all data set with descriptive variable names

names(all_data_set)<-gsub("Acc", "Accelerometer", names(all_data_set))
names(all_data_set)<-gsub("Gyro", "Gyroscope", names(all_data_set))
names(all_data_set)<-gsub("Mag", "Magnitude", names(all_data_set))
names(all_data_set)<-gsub("BodyBody", "Body", names(all_data_set))
names(all_data_set)<-gsub("^t", "time", names(all_data_set))
names(all_data_set)<-gsub("^f", "frequency", names(all_data_set))

# Write tidy data set

library(plyr);
tidy_data<-aggregate(. ~subject + activity, all_data_set, mean)
tidy_data<-tidy_data[order(tidy_data$subject,tidy_data$activity),]
write.table(tidy_data, file = "tidy_data.txt",row.name=FALSE)


