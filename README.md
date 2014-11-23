CourseraCleaningAssignment
==========================

==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 2.0: Tidy Dataset
==================================================================
Dataset tidied by Clarke Iakovakis for Coursera Course "Getting and Cleaning Data"
https://class.coursera.org/getdata-009


Data originally collected by 
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit‡ degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The tidyData.csv file has been generated with the script run_analysis.R, which is on GitHub at +++. 

Before running the script, the UCI HAR Dataset must be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzipped. In R, set your working directory to the 'UCI HAR Dataset" directory using the command setwd(). 

The run_analysis script will access that directory and read in the files to be used in creating the tidy dataset. Those files are:

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- - 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- - 'test/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

features.txt is coerced to a character and used as the column names for the signals in intermediate processing datasets, and will be later cleaned and used as the basis for the "signal" column in the final dataset. Specifically, all punctuation is removed, strings beginning with 't' now begin with 'time,' strings beginning with 'f' now begin with 'frequency,' and the words 'mean' and 'std' are capitalized. 

The train and test data are bound together, with the respective activity and subject values. Items in the activity_labels.txt file are used as the basis for the activity factors, and are assigned as levels when the subject data is bound to the activities and the measurements as merged.df. This includes 563 variables: the subject, the activity, and 561 separate signal measurements. 

run_analysis then uses the grep function to identify instances of the string mean() or std() in the column names of those 561 measurements. The purpose of this is to extract only the measurements on the mean and standard deviation for each measurement. Other instances of the string 'mean' (such as angle(tBodyGyroJerkMean,gravityMean)) will not be detected as the parentheses do not follow the word 'mean.' This locates 66 signal variables which will be the basis for the final dataframe.

The merged.df is then subset using the index created by the above function and bound back together with the subject and activity columns, creating a working dataframe (working.df). This dataframe is molten, identifying the subject and activity as ID variables and the signal measurements as measured variables. This molten dataframe (molten.df) is then dcast, calculating the average of each signal variable for each activity and each subject. This results in a final dataframe (final.df) of 11,880 observations of 4 variables: the subject, activity, signal, and the calculated mean, which is renamed to "avgMeasurement." The dataframe is ordered by subject, and the old rownames are dropped.

After running the script, the tidy dataset file, called tidyDataset.csv, is saved to the UCI HAR Dataset directory.
]
