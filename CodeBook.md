Course Project Codebook
===============
Initial Transformations
------------------------
Training data and test data were merged by reading the respective files into dataframes and combining using rbind.
Column names were added based on the contents of the file (i.e Subject and Activity), or in the case of the measurement data the variable names from the feature file.
Activity codes were mapped to descriptive names using a CASE statement in a SQL query provided by the sqldf library.

Combining Data
-------------------
Individual data sets were then combined using cbind and then written to disk using write.table.
