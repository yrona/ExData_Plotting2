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
# # make.NEI.plot4 prepares a plot of total PM2.5 emissions across the US broken down by EI Sector
#
make.NEI.plot4 <- function() {
  
  #First we need the SCC codes that relate to Coal combustion. 
  my.cc.complete <- NEI.ClassCodes()
  
  #We extract the EI Sector data 
  my.cc.types <- levels(my.cc.complete$EI.Sector)
  
  #Next we find a subset of the Sector data that has the word 'Coal' in it.
  my.cc.coal <- my.cc.types[grep(".*Coal.*", my.cc.types) ]
  
  #We can then subset the SCC data frame so that we only have rows related to Coal combustion
  my.cc.coalsubset <- subset(my.cc.complete, EI.Sector %in% my.cc.coal)
  
  #Finally we prepare a data frame that we will merge NEI PM25 data
  my.cc.premerge <- data.frame(my.cc.coalsubset$SCC,my.cc.coalsubset$EI.Sector)
  
  #We subset the data without storing it, using is the fips code for Baltimore City
  my.full.data <- subset( NEI.PM25.data(),  SCC %in% my.cc.coalsubset$SCC)
  
  #We now extend the data with the Sector names (using SCC codes as the table join)
  my.full.data.extended <- merge(my.full.data,my.cc.premerge, by.x = c("SCC"), by.y = c("my.cc.coalsubset.SCC"))
  
  #The aggregate function behaves like tapply, except we get a dataframe as output
  #With col1 containing years, col2 containing types, col3 containing total emissions
  plot4.data <- aggregate(my.full.data.extended$Emissions, list(Year = my.full.data.extended$year, Source = my.full.data.extended$type), FUN = sum)
  names(plot4.data)[names(plot4.data)=='x'] <- 'Emission'
  
  #Now we turn to the order in which the layers will be stacked in the eventual plot
  
  #We start by getting the total emissions for each sector type over all years
  plot4.order.data <-  aggregate(my.full.data.extended$Emissions, list(Source = my.full.data.extended$type), FUN = sum)
  
  #We then rename the column x to TotalEmissions so that it's less confusing down the road
  names(plot4.order.data)[names(plot4.order.data)=='x'] <- 'TotalEmission'
  
  #Now we add the Total Emissions column to the plot 4 data (we will use it for sorting the data)
  plot4.data <-  merge(plot4.data,plot4.order.data, by.x = "Source", by.y = "Source")
  
  #Now we sort the data so that when qplot is executed, the smallest emission source goes on the bottom, and larger goes on top
  plot4.data <- plot4.data[order(plot4.data$Year,plot4.data$TotalEmission),]
  
  #png("plot2.png")
  
  cplot <- qplot(Year,Emission, data = plot4.data, colour = Source)  #Plots Emissions (x) vs Year using different colors 
  #for the points based on EI.Sector
  #Automatically generates the legend as well.
  
  
  cplot <- cplot + geom_area(aes(colour = Source, fill = Source),position = 'stack') #Stacked layer plot
  
  cplot <- cplot + ylab("Total Emissions")  # Labels the y axis (the x is automatically labeles 
  # with the name of the Year column in the original data frame).
  
  cplot <- cplot + ggtitle("Coal Combustion PM2.5 Emissions Accross U.S.")  # Adds a Chart title.
  
  ggsave("plot4.png",cplot)
  
  #dev.off()
}