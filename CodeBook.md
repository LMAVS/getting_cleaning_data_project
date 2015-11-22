codebook
==========

if 'data' folder with all data is not present in directory, download and unzip it from url

unzips it

loads data and only reads certain variables

merges data from different text files into  common data frame : train_Set and test_set

assigns proper names to variables 

merges train_set and test_set data frames as full_set

creates a new data frame tidy_set, which holds the means of variables of full_set grouped by subject and activity 

sets proper names for activities in tidy_set

writes tidy_set data set to text file