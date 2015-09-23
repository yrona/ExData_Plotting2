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
# # make.NEI.plot1 prepares a plot of total PM2.5 emissions across Baltimore
#
make.NEI.plot2 <- function() {
  
  #We subset the data without storing it
  my.full.data <- subset( NEI.PM25.data(), fips == "24510")
  
  #The aggregate function behaves like tapply, except we get a dataframe as output
  #With col1 containing years, col2 containing total emissions
  plot2.data <- aggregate(my.full.data$Emissions, list(my.full.data$year), FUN = sum)
  
  png("plot2.png")
  
  plot(plot2.data,
       type = "l",
       xlab = "Year", 
       ylab = "Total Emissions",
       main = "Baltimore PM2.5 Emissions")
  
  dev.off()
}