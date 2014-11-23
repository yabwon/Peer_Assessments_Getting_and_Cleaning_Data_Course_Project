# clear environment
rm(list = ls());gc()

# save location of current working directory
OLD.WD <- getwd() 

# !!! ATTENTION !!!
# load library "data.table", use: install.packages("data.table") if needed
# code below strongly uses data.frame syntax
# !!! ATTENTION !!!
library(data.table)

# !!! ATTENTION !!!
# set up new working directory
# !!! ATTENTION !!!
setwd("C:\\R_WORK\\Peer_Assessments_Getting_and_Cleaning_Data_Course_Project\\UCI HAR Dataset")

# read up file activity_labels.txt and make it data.table
# no extra set upneeded :-)
activity.labels <- data.table(read.table("./activity_labels.txt"))
# rename column names
setnames(activity.labels,1:2,c('activity_id','activity_label_desc'))
# set key for data.table merge
setkey(activity.labels, activity_id)
# check out table's header
head(activity.labels)

# read up file features.txt and make it data.table
# no extra set upneeded :-)
features <- data.table(read.table("./features.txt"))
# rename column names
setnames(features,1:2,c('feature_id','feature_desc'))
# check out table's header
head(features)

# read up file ./train/X_train.txt and make it data.table
# no extra setup needed :-)
X_train <- data.table(read.table("./train/X_train.txt"))
# rename column names according to feature names
setnames(X_train, as.vector(features[, feature_id]), as.vector(features[, feature_desc]))
# check out table
head(X_train)
object.size(X_train)

# read up file ./train/subject_train.txt and make it data.table
subject_train <- data.table(read.table("./train/subject_train.txt"))
# rename column names
setnames(subject_train, "subject")
# read up file ./train/y_train.txt and make it data.table
y_train <- data.table(read.table("./train/y_train.txt"))
# rename column names
setnames(y_train, "activity_id")

# read up file ./test/X_test.txt and make it data.table
# no extra setup needed :-)
X_test <- data.table(read.table("./test/X_test.txt"))
# rename column names according to feature names
setnames(X_test, as.vector(features[, feature_id]), as.vector(features[, feature_desc]))
# check out table
head(X_test)
object.size(X_test)

# read up file ./test/subject_test.txt and make it data.table
subject_test <- data.table(read.table("./test/subject_test.txt"))
# rename column names
setnames(subject_test, "subject")
# read up file ./test/y_test.txt and make it data.table
y_test <- data.table(read.table("./test/y_test.txt"))
# rename column names
setnames(y_test, "activity_id")

# combine 'train' tables
total_train <- data.table(subject_train, y_train, X_train)
# head(total_train)

# combine 'test' tables
total_test <- data.table(subject_test, y_test, X_test)
#head(total_test)

# bind total_train and total_test in one table, rbindlist is data.table function
# use.names=TRUE - bind columns bu names
# fill=TRUE - if column is missing fill it with NAs
total <- rbindlist(list(total_train, total_test), use.names=TRUE, fill=TRUE)
# object.size(total)

# del unnecessary objects
rm(subject_train, y_train, X_train, total_train, subject_test, y_test, X_test, total_test); gc()

# create vector with numbers of collumns which name contain "mean" or "std"
# 1 and 2 are for columns "subject" and "feature_id" that is why other indicis are shifted by 2
mean.and.std.label.subset <- c(1,2,which(grepl('mean|std', features[, feature_desc])) + 2)

final <- total[, mean.and.std.label.subset, with=FALSE]

# del unnecessary object
rm(total); gc()

#set key to perform merge of final and activity.labels
setkey(final, activity_id)

# final data.table which satisfy conditions 1, 2, 3 and 4 from 'Peer Assessments/Getting and Cleaning Data Course Project'
# "activity.labels[final]..." perform SQL's left join of final and activity.labels by activity_id column which is a key
# "...[, activity_id:=NULL]" drops activity_id column
final.labeled <- activity.labels[final][, activity_id:=NULL]

# del unnecessary object
rm(final); gc()

# set first two collumns as keys to perform final aggregation 
setkeyv(final.labeled, names(final.labeled)[1:2])

# vectors of label to perform aggregation
l <- as.vector(features[grepl('mean|std', features[, feature_desc]), feature_desc])

# create final tidy dataset
means.of.final.labeled <- final.labeled[, lapply(.SD, mean), by=key(final.labeled), .SDcol = l] # .SDcol lists columns to aggregate

# rename collumns in tidy data set
mean_of_l <- paste("mean_of_", l , sep="")  
setnames(means.of.final.labeled, c("activity_name", "subject", mean_of_l))

# del unnecessary objects
rm(features, activity.labels, l, mean_of_l, mean.and.std.label.subset); gc()

# save file to txt
write.table(means.of.final.labeled
            ,file = "TIDY.TXT"
            ,quote = F
            ,sep = "|"
            ,row.names = F
            ,col.names = T)
