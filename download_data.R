# Routines to load PM25 Data into memory
# The raw data these routines import may be found in
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#
# The url is the url to the dataset.  The destdir is the directory you want 
# the datafiles downloaded to.
#
# They are specified by environemnt.NEI.data.  You can customize code for your
# system by modifying those environmental variables

environment.NEI.data <- function() {
  
  NEI.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  NEI.datadir <- "data"
  
  NEI.PM25.filename <- paste(NEI.datadir,"summarySCC_PM25.rds", sep = "/")
  NEI.SClassCode.filename <- paste(NEI.datadir, "Source_Classification_Code.rds", sep = "/")
  
  return (
          list(url = NEI.url, 
               datadir =  NEI.datadir, 
               PM25.filename = NEI.PM25.filename, 
               ClassCode.filename = NEI.SClassCode.filename
               )
          )
  
}


download.NEI.data <- function(destdir,url) {
  
  my.env.variables <- environment.NEI.data()
  
  if (missing(url)) {
    url <- my.env.variables$url
  }
  
  if (missing(destdir)) {
    destdir <- my.env.variables$NEI.datadir
  }
  
  my.zipfile.path = paste(destdir,"dataset.zip",sep = "/")
  
  download(url,my.zipfile.path)
  unzip (my.zipfile.path, exdir = destdir)
}


load.NEI.data <- function(datafile) {
  if (file.exists(datafile)) {
    return (readRDS(datafile))
  } else {
    warning(paste(datafile, "is missing. Please execute download.NEI.data to download and unzip the file"))
  }  
  
}

NEI.PM25.data <- function() {
  my.env.variables <- environment.NEI.data()
  
  return (load.NEI.data( my.env.variables$PM25.filename))
}

NEI.ClassCodes <- function() {
  my.env.variables <- environment.NEI.data()
  
  return (load.NEI.data( my.env.variables$ClassCode.filename))  
}