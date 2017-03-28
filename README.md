# Human Activity Recognition
Peer-graded Assignment for Getting and Cleaning Data - Week 4 
## Explanation
The included R script, run_analysis.R:
1. Sets the working directory (optional, commented out in this distribution) and loads the reshape2 package
2. Detects the UCI HAR Dataset; downloads and/or unzips it if not found
3. Loads the activity labels and features
4. Prepares to extract only mean and std data
5. Loads and binds the testing and training data by column
6. Binds (merges) the testing and training data by row and assigns column labels
7. Converts activities and subjects to factors
8. Melts and casts data to include average value per variable for each subject and activity
9. Generates a file called "UCIHAR_averages.tidy.txt" containing tidy data with the average of each variable for each subject and activity