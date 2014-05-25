run_analysis<-function(){
    #Read in measurements and rbind test and training data into one dataset
    x.test<-read.table("X_test.txt")
    x.train<-read.table("X_train.txt")
    x.data<-rbind(x.test,x.train)
    #Combine subject lines into one dataset
    subject.test<-read.table("subject_test.txt")
    subject.train<-read.table("subject_train.txt")
    subject.data<-rbind(subject.test,subject.train)
    #Combine activities into one dataset
    y.test<-read.table("y_test.txt")
    y.train<-read.table("y_train.txt")
    y<-rbind(y.test,y.train)
    #Convert activity codes to char for use in sqldf query
    y[,1]<-as.character(y[,1])
    #Read in variable names
    headers<-read.table("features.txt")    
    #Set column names
    colnames(x.data)<-headers[,2]
    colnames(y)<-c("Activity")
    #Map activity codes to activity descriptors
    y<-sqldf("SELECT (case when Activity=1 then 'Walking' when Activity=2 then 
             'Walking Upstairs' when Activity=3 then 'Walking Downstairs' when 
             Activity=4 then 'Sitting' when Activity=5 then 'Standing' when 
             Activity=6 then 'Laying' END) as Activity from y")
    colnames(subject.data)<-c("Subject")
    #Get the list of variables we are interested in (mean and standard deviation)
    vars<-headers[grepl("mean", headers$V2, ignore.case=TRUE) |
                      grepl("std", headers$V2, ignore.case=TRUE),]
    #Just pull the vars we interested in from x
    x.data<-x.data[,names(x.data) %in% vars[,2]]
    #cbind all of them together
    samsung.data<-cbind(subject.data,y,x.data)
    #write dataset out to file
    write.table(samsung.data,sep="\t",file="samsung.csv",row.names=FALSE)
}
