# Download PM25 Data into memory
# The raw data this routine imports may be found in
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#
# The url is the url to the dataset.  The destdir is the directory you want 
# the datafiles downloaded to.
#


download.NEI.data <- function(url,destdir) {
  
  my.zipfile.path = paste(destdir,"dataset.zip",sep = "/")
  
  download(url,my.zipfile.path)
  unzip (my.zipfile.path, exdir = destdir)
}