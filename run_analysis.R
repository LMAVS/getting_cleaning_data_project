# download data if not present ....
if (!file.exists("data")){
    dir.create("data")
    setwd('data')
    filename <- 'getdata-projectfiles-UCI HAR Dataset.zip'
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL,destfile=filename,method="curl")
    dateDownloaded <- date()
    unzip(filename)
    setwd('../')
}

#  load labels ............
activity_labels <- read.table('./data/UCI HAR Dataset/activity_labels.txt', stringsAsFactors=FALSE)
features_names <- read.table('./data/UCI HAR Dataset/features.txt',stringsAsFactors=FALSE)
features_names = data.frame(features_names)
features_vector = features_names[,2]

# filtering indices ...............
means <- c(1,2,3,41,42,43,81,82,83,121,122,123,161,162,163)
stds <-  c(4,5,6,44,45,46,84,85,86,124,125,126,164,165,166)

means <- c(means,201,214,227,240,253,266,267,268,345,346,347  )
stds  <- c(stds, 202,215,228,241,254,269,270,271,348,349,350  )

means <- c(means,424,425,426,503,516,529,542    )
stds  <- c(stds ,427,428,429,504,517,530,543    )

filter_c <- c(means,stds)
features_names_filtered <- features_vector[filter_c]



# load the test set ..................
pwd1 = './data/UCI HAR Dataset/test'
test_subj <- read.table(paste(pwd1,'subject_test.txt',sep='/'))
test_act  <- read.table(paste(pwd1,'y_test.txt',sep='/'))

test_var <- read.table(paste(pwd1,'X_test.txt',sep='/'))

test_var_filtered <- test_var[,filter_c]

test_set <- data.frame(test_subj,test_act,test_var_filtered)
names(test_set) <- c("subject","activity",features_names_filtered)
# str(test_set)

# load the train set ..................
pwd2 = './data/UCI HAR Dataset/train'
train_subj <- read.table(paste(pwd2,'subject_train.txt',sep='/'))
train_act  <- read.table(paste(pwd2,'y_train.txt',sep='/'))

train_var <- read.table(paste(pwd2,'X_train.txt',sep='/'))

train_var_filtered <- train_var[,filter_c]

train_set <- data.frame(train_subj,train_act,train_var_filtered)
names(train_set) <- c("subject","activity",features_names_filtered)

# merge ...................................
full_set = rbind(train_set,test_set)

#  calculate means of all variables ....
tidy_set <- aggregate(full_set,by=list(full_set$subject,full_set$activity), FUN=mean)

# convert activities from number to string ...........
activities <- sapply(tidy_set$activity, function(x) activity_labels[x,2] )
tidy_set$activity <- activities

write.table(tidy_set,'./tidy_set.txt',row.name=FALSE)
