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
# # make.NEI.plot5 prepares a plot of total of motor vehicle sourced PM2.5 emissions in Baltimore City broken down by EI Sector
#
make.NEI.plot5 <- function() {
  
  #First we need the SCC codes that relate to Coal combustion. 
  my.cc.complete <- NEI.ClassCodes()
  
  
  #We subset the data without storing it, using is the fips code for Baltimore City and a type of ON-ROAD
  my.full.data <- subset( NEI.PM25.data(),  type == "ON-ROAD" & fips == "24510")
  
  #Now we pull out the SCC's associated with this data
  my.motor.scc <- levels ( factor(my.full.data$SCC) ) 
  
  #Now we get a subset of the Sector Data that matches these SCC's
  my.cc.mv <- subset( my.cc.complete, SCC %in% my.motor.scc )              
  
  #Finally we prepare a data frame that we will merge NEI PM25 data
  my.cc.premerge <- data.frame(my.cc.mv$SCC,my.cc.mv$EI.Sector)
  
  
  #We now extend the data with the Sector names (using SCC codes as the table join)
  my.full.data.extended <- merge(my.full.data,my.cc.premerge, by.x = c("SCC"), by.y = c("my.cc.mv.SCC"))
  
  #The aggregate function behaves like tapply, except we get a dataframe as output
  #With col1 containing years, col2 containing types, col3 containing total emissions
  plot5.data <- aggregate(my.full.data.extended$Emissions, list(Year = my.full.data.extended$year, Sector = my.full.data.extended$my.cc.mv.EI.Sector), FUN = sum)
  names(plot5.data)[names(plot5.data)=='x'] <- 'Emission'
  
  #Now we turn to the order in which the layers will be stacked in the eventual plot
  
  #We start by getting the total emissions for each sector type over all years
  plot5.order.data <-  aggregate(my.full.data.extended$Emissions, list(Sector = my.full.data.extended$my.cc.mv.EI.Sector), FUN = sum)
  
  #We then rename the column x to TotalEmissions so that it's less confusing down the road
  names(plot5.order.data)[names(plot5.order.data)=='x'] <- 'TotalEmission'
  
  #Now we add the Total Emissions column to the plot 4 data (we will use it for sorting the data)
  plot5.data <-  merge(plot5.data,plot5.order.data, by.x = "Sector", by.y = "Sector")
  
  #Now we sort the data so that when qplot is executed, the smallest emission source goes on the bottom, and larger goes on top
  plot5.data <- plot5.data[order(plot5.data$Year,plot5.data$TotalEmission),]
  
  #png("plot2.png")
  
  cplot <- qplot(Year,Emission, data = plot5.data, colour = Sector)  #Plots Emissions (x) vs Year using different colors 
  #for the points based on EI.Sector
  #Automatically generates the legend as well.
  
  
  cplot <- cplot + geom_area(aes(colour = Sector, fill = Sector),position = 'stack') #Stacked layer plot
  
  cplot <- cplot + ylab("Total Emissions")  # Labels the y axis (the x is automatically labeles 
  # with the name of the Year column in the original data frame).
  
  cplot <- cplot + ggtitle("Motor Vehicle PM2.5 Emissions Baltimore City")  # Adds a Chart title.
  
  ggsave("plot5.png",cplot)
  
  #dev.off()
}