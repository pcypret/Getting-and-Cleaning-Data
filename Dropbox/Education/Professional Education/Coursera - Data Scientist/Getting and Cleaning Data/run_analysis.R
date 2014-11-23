
library("reshape2")
library("data.table")
# Load data 
x_test <- read.table("/home/pcypret/R/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("/home/pcypret/R/UCI HAR Dataset/test/y_test.txt")
x_train <- read.table("/home/pcypret/R/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("/home/pcypret/R/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("/home/pcypret/R/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("/home/pcypret/R/UCI HAR Dataset/test/subject_test.txt")
features <- read.table("/home/pcypret/R/UCI HAR Dataset/features.txt")[,2]
activity_labels <- read.table("/home/pcypret/R/UCI HAR Dataset/activity_labels.txt")[,2]

# Loading labels 
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")

# Mean and standard dev.
names(x_test) = features
extract_features <- grepl("mean|std", features)
x_test = x_test[,extract_features]


names(subject_test) = "subject"

y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"
# Merge datasets using row and column bind
test_data <- cbind(subject_test, y_test, x_test)
tr_data <- cbind(as.data.table(subject_train), y_test, x_test)
xdata= rbind(test_data, tr_data)

id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)

#create single factor
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

# write file out
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, , row.names= FALSE, file = "/home/pcypret/R/UCI HAR Dataset/tidy_data.txt")

