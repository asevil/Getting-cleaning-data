##Course Project Getting and Cleaning Data



filename <- "zipfile.zip"            ## Download and unzip the dataset
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, destfile=filename)
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}
idtrain<-read.table("./UCI HAR Dataset/train/Y_train.txt") ## Reads rows identifier for train dataset
train<-read.table("./UCI HAR Dataset/train/X_train.txt")  ## Reads train dataset
trainsub<-read.table("./UCI HAR Dataset/train/subject_train.txt")  ## Reads subject data
train<-cbind(idtrain,trainsub,train)                             ## Merges row identifier with dataset
idtest<-read.table("./UCI HAR Dataset/test/Y_test.txt") ## Reads rows identifier for test dataset
test<-read.table("./UCI HAR Dataset/test/X_test.txt")   ## Reads test dataset
testsub<-read.table("./UCI HAR Dataset/test/subject_test.txt")  ## Reads subject data
test<-cbind(idtest,testsub,test)                                ## Merges row identifier with dataset
alldata<-rbind(train,test)                               ## Merges train and test datasets`

features<-read.table("./UCI HAR Dataset/features.txt")   ## Reads column names
names(alldata)<-c("activity","subject",as.character(features[,2]))    ## Assigns column names to the merged file

datawanted<-alldata[,grepl("[Mm]ean|[Ss]td",features[,2])]       ## Filters mean and std columns

activities<-read.table("./UCI HAR Dataset/activity_labels.txt")         ##Reads activity labels, the row labels
for (i in 1:6){                                                         ##Inserts activity names
        datawanted[,1]<-gsub(i,activities[i,2],datawanted[,1])
}

datawanted$activity<-as.factor(datawanted$activity)             ## Converts activity variable into a factor to use xtabs function
datawanted$subject<-as.factor(datawanted$subject)               ## Converts subject variable into a factor to use xtabs function
Allaverage<-xtabs(mean~activity+subject,data=datawanted)    ## Crosstable activity vs subject (mean)

write.table(Allaverage, "tidy.txt", row.names = FALSE, quote = FALSE)  ## Creates the file in the working directory with the tidy data

