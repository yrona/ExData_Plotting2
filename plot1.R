# Routine to produce a plot of total PM2.5 emissions throughout the US
# The raw data these routines work with may be found in
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#
# The location of the data is specified by environment.NEI.data.  You can customize code for your
# system by modifying those environmental variables
#
# Prior to executing this function, please make sure you have downloaded and uncompressed the data
# using the appropriate routines.
#
#
make.NEI.plot1 <- function() {
  
  my.full.data <- NEI.PM25.data()
  
  plot1.data <- aggregate(my.full.data$Emissions, list(my.full.data$year), FUN = sum)
  
  png("plot1.png")
  
  plot(plot1.data,
       type = "l",
       xlab = "Year", 
       ylab = "Total Emissions",
       main = "US PM2.5 Emissions")
  
  dev.off()
}