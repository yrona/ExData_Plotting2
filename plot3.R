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
# # make.NEI.plot3 prepares a plot of total PM2.5 emissions across Baltimore broken down by Type
#
make.NEI.plot3 <- function() {
  
  #We subset the data without storing it, using the fips code for Baltimore City
  my.full.data <- subset( NEI.PM25.data(), fips == "24510")
  
  
  
  #The aggregate function behaves like tapply, except we get a dataframe as output
  #With col1 containing years, col2 containing types, col3 containing total emissions
  plot3.data <- aggregate(my.full.data$Emissions, list(Year = my.full.data$year, Type = my.full.data$type), FUN = sum)
  
  #png("plot2.png")
  
  cplot <- qplot(Year,x, data = plot3.data, colour = Type)  #Plots Emissions (x) vs Year using different colors 
                                                            #for the points based on type
                                                            #Automatically generates the legend as well.
  
  
  cplot <- cplot + geom_line() #Adds colored lines connecting the points sharing the same Type
  
  cplot <- cplot + ylab("Total Emissions")  # Labels the y axis (the x is automatically labeles 
                                            # with the name of the Year column in the original data frame).

  cplot <- cplot + ggtitle("Baltimore City PM2.5 Emissions")  # Adds a Chart title.
    
  ggsave("plot3.png",cplot)
  
  #dev.off()
}