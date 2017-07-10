# GetCleanDataProject

Th GetCleanDataProject is the course project for Getting and Cleaning Data.  The project specifically reads in messy data coorosponding to wearable technology and activity that is recorded via smart phone.  The messy data contains 100s of data points and this project will tidy the data so that the means for a given subject and activity are produced in the tidy.txt file

### Instructions

The R script, run_analysis.R, does the following:

1. Download the dataset from the remote server
2. Read activity and feature data
3. Read both the training and test datasets, keep columns contains means or standard deviations
4. Read the activity and subject data for each dataset
5. Merges the two datasets training and test
6. Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
7. tidy.txt will be outputted to the project directoy
