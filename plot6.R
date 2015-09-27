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
# # make.NEI.plot6 prepares a plot of total of motor vehicle sourced PM2.5 emissions in Baltimore City broken down by EI Sector
#
make.NEI.plot6 <- function() {
  
  #First we need the SCC codes 
  my.cc.complete <- NEI.ClassCodes()
  
  
  #We subset the data without storing it, using is the fips code for Baltimore City and a type of ON-ROAD
  my.full.data <- subset( NEI.PM25.data(),  type == "ON-ROAD" & (fips == "24510" | fips == "06037"))
  
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
  plot6.data <- aggregate(my.full.data.extended$Emissions, list(Year = my.full.data.extended$year, Sector = my.full.data.extended$my.cc.mv.EI.Sector, fips = my.full.data.extended$fips), FUN = sum)
  names(plot6.data)[names(plot6.data)=='x'] <- 'Emission'
  
  #Now we turn to the order in which the layers will be stacked in the eventual plot
  
  #We start by getting the total emissions for each sector type over all years
  plot6.order.data <-  aggregate(my.full.data.extended$Emissions, list(Sector = my.full.data.extended$my.cc.mv.EI.Sector, fips = my.full.data.extended$fips), FUN = sum)
  
  #We then rename the column x to TotalEmissions so that it's less confusing down the road
  names(plot6.order.data)[names(plot6.order.data)=='x'] <- 'TotalEmission'
  
  #Now we add the Total Emissions column to the plot 4 data (we will use it for sorting the data)
  plot6.data <-  merge(plot6.data,plot6.order.data, by.x = c("Sector","fips"), by.y = c("Sector","fips"))
  
  #Now we sort the data so that when qplot is executed, the smallest emission source goes on the bottom, and larger goes on top
  plot6.data <- plot6.data[order(plot6.data$Year,plot6.data$TotalEmission),]
  
  plot6.data$location = as.character("")
  plot6.data$location[plot6.data$fips == "06037"] = "LA County"
  plot6.data$location[plot6.data$fips == "24510"] = "Baltimore City"
  
#   #png("plot2.png")
#   
#   cplot.bc <- qplot(Year,Emission, data = subset(plot6.data, fips == "24510"), colour = Sector)  #Plots Emissions (x) vs Year using different colors 
#                                                                                                   #for the points based on EI.Sector fo Bal
#                                                                                                   #Automatically generates the legend as well.
#   
#   cplot.la <- qplot(Year,Emission, data = subset(plot6.data, fips == "06037"), colour = Sector) #LA
#  
#   
#   
#   dressplot_layer <- function (cplot) {
#   
#     cplot <- cplot + geom_area(aes(colour = Sector, fill = Sector),position = 'stack') #Stacked layer plot
#     
#     cplot <- cplot + ylab("Total Emissions")  # Labels the y axis (the x is automatically labeles 
#     # with the name of the Year column in the original data frame).
#     
#     return (cplot)
#   }
#   
#   cplot.bc <- dressplot_layer(cplot.bc) + ggtitle("Motor Vehicle PM2.5 Emissions Baltimore City")
# 
#   cplot.la <- dressplot_layer(cplot.la) + ggtitle("Motor Vehicle PM2.5 Emissions LA County")  # Adds a Chart title.
  
#   cplot.all <- qplot(Year,Emission, data = plot6.data, colour = Sector, aes(Sector,fips)) + facet_grid(. ~location)  + geom_point(aes(shape = factor(fips), size=3)) + scale_size_identity(guide=FALSE) 
#                
#   
#   for (i in unique(plot6.data$Sector)) {
#     for (j in unique(plot6.data$fips)) {
#       cplot.all <- cplot.all + geom_line(data = subset(plot6.data, (fips == j) & (Sector == i)))
#     }
#   }
#   
#   cplot.all <- cplot.all  + coord_trans(y="log10")  + scale_shape_discrete(name = "Location",breaks=c("06037","24510"),labels=c("LA County","Baltimore City")) + ggtitle("Motor Vehicle PM2.5 Emission Levels LA County and Baltimore City")
  
  cplot.all <- qplot(Year,Emission, data = plot6.data, colour = Sector)  + facet_grid(. ~location)  #Plots Emissions (x) vs Year using different colors 
                                                                                                     #for the points based on EI.Sector fo Bal
                                                                                                     #Automatically generates the legend as well.
  
  cplot.all <- cplot.all + geom_area(aes(colour = Sector, fill = Sector),position = 'stack')
  
  cplot.all <- cplot.all +  ylab("Total Emissions")  # Labels the y axis and makes it a log scale
  
  cplot.all <- cplot.all + ggtitle("Motor Vehicle PM2.5 Emissions Baltimore City vd LA County")
     
  ggsave("plot6.png",cplot.all)
  
  #dev.off()
}