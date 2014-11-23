Peer_Assessments_Getting_and_Cleaning_Data_Course_Project
=========================================================

Peer_Assessments_Getting_and_Cleaning_Data_Course_Project

How the script run_analysis.R works:
====================================

01) line 2 - clears environment

02) line 5 - saves current WD in OLD.WD variable

03) line 11 - loads data.table package (user must install the package)

04) line 16 - sets up new WD with directory ".../UCI HAR Dataset" as root (user must write one)

05) lines 18 to 26 - reads up file activity_labels.txt, make it data.table, sets names and key, checks head

06) lines 28 to 34 - reads up file features.txt, make it data.table, sets names, check head

07) lines 36 to 52 - reads up files ./train/X_train.txt, ./train/subject_train.txt ./train/y_train.txt and makes them data.tables, sets up names, checks X_train's head and object size

08) lines 54 to 70 - reads up files ./train/X_test.txt, ./train/subject_test.txt ./train/y_test.txt and makes them data.tables, sets up names, checks X_test's head and object size

09) lines 72 to 78 - creates two data.tables: total_train and total_test based on 3 "train" tables and 3 "test" tables

10) line 83 - bind total_train and total_test in one table using data.table::rbindlist function

11) line 87 - clears environment

12) lines 89 to 91 - create vector with indexes of columns which will be kept

13) line 93 - creates "final" data tale which contains only selected columns

14) line 96 - clears environment

15) lines 98 to 104 - changes activity id to activity label in "final" data tale, creates "final.labeled" set

16) line 106 - clears environment

17) line 110 - sets first two columns of "final.labeled" set as keys to perform final aggregation

18) lines 112 to 120 - creates final aggregated set

19) line 123 - clears environment

20) lines 126 to 131 - saves final aggregated set as TIDY.TXT in WD using write.table() with options: quote = F, sep = "|", row.names = F, col.names = T)

