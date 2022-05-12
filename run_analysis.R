#Load the datasets
#features names
features = read.table("UCI HAR Dataset/features.txt")
labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

#Numeric data
X_test=read.table("UCI HAR Dataset/test/X_test.txt",col.names = features[,2])
Y_test=read.table("UCI HAR Dataset/test/Y_test.txt",col.names = "code")
X_train=read.table("UCI HAR Dataset/train/X_train.txt",col.names = features[,2])
Y_train=read.table("UCI HAR Dataset/train/y_train.txt",col.names = "code")

#labels
subject_test=read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
subject_train=read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subject")

# Merge the training and test set with the metadata
X=rbind(X_train,X_test)
Y=rbind(Y_train,Y_test)
subject=rbind(subject_train,subject_test)
data=cbind(X,Y,subject)

#extract the mean and sd for each measurement
library(dplyr)
tidy_data = data %>% select(contains(c("mean","std")),subject, code) %>% rename(activity = code)

#convert numeric
tidy_data$activity=labels[tidy_data$activity,2]
tidy_data$activity=as.factor(tidy_data$activity)

#appropriate descriptive names for the columns
colname = c("Acc"= "Accelerometer","Gyro"= "Gyroscope","BodyBody"= "Body","Mag"= "Magnitude","^t"= "Time","^f"= "Frequency","tBody"= "TimeBody","-freq()"= "Frequency","angle"= "Angle","gravity"= "Gravity")

for(a in names(colname)){
  names(tidy_data)=gsub(a, colname[a], names(tidy_data))
}

#Averages of each variable for each activity and subject
final_tidy = tidy_data %>% group_by(subject,activity) %>% summarise_all(list(mean))
final_tidy

write.table(final_tidy, "final_tidy.txt", row.name=FALSE)