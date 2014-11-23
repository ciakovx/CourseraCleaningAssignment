# Set your working directory to the UCI HAR Dataset
setwd("Your Directory/UCI HAR Dataset")

library(reshape2)
library(stringr)

# Read in the features and coerce to character vector
features <- read.table(file = "./features.txt")
ft <- as.character(features$V2)

# Read in the train data
xtrain <- read.table(file = "./train/X_train.txt"
                     , col.names = ft)
ytrain <- read.table(file = "./train/y_train.txt")
sbj_train <- read.table(file = "./train/subject_train.txt")

# Read in the test data
xtest <- read.table(file = "./test/X_test.txt"
                    , col.names = ft)
ytest <- read.table(file = "./test/y_test.txt")
sbj_test <- read.table(file = "./test/subject_test.txt")

# Read in the activity labels
activity <- read.table(file = "./activity_labels.txt")

# Bind the variables in each dataframe
train <- cbind("subject" = factor(sbj_train$V1)
               , "activity" = factor(ytrain$V1
                                     , levels = c(1:6)
                                     , labels = activity$V2)
               , xtrain)
test <- cbind("subject" = factor(sbj_test$V1)
              , "activity" = factor(ytest$V1
                                    , levels = c(1:6)
                                    , labels = activity$V2)
              , xtest)

# Merge the test and train datasets
merged.df <- rbind(train, test)

# Extract only the measurements on the mean and standard deviation for each measurement
  # Subset column headers by applying a regular expression searching for the strings 'mean' or 'std'
temp.extracted.df <- merged.df[, 3:563][, grepl("(mean\\()|(std)", ft)]
working.df <- cbind(merged.df[, 1:2], temp.extracted.df)

# Clean up the column names strings
x <- colnames(working.df)
x <- str_replace_all(x, "[[:punct:]]", "")  # Remove all punctuation
x <- str_replace_all(x, "mean", "Mean")
x <- str_replace_all(x, "std", "Std")
x <- str_replace_all(x, "^t", "time")
x <- str_replace_all(x, "^f", "frequency")
colnames(working.df) <- x

# Melt & cast
molten.df <- melt(working.df
          , id.vars = 1:2
          , variable.name = "signal"
          , value.name = "measurement")
final.df <- dcast(molten.df
                  , subject + activity + signal ~ .
                  , value.var = "measurement"
                  , mean)

# Rename column, order by subject, drop rownames.
colnames(final.df)[4] <- "avgMeasurement"
final.df <- final.df[order(as.numeric(as.character(final.df$subject))), ]
rownames(final.df) <- NULL

# Write the table
write.table(final.df
            , file="./tidyData.csv"
            , row.names = FALSE
            , sep = ",")