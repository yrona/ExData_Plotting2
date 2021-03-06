---
title: "Exploratory Graphing Project 2"
author: "Yilmaz Rona"
date: "September 20, 2015"
output: html_document
---

### Introduction
This is the submission for Project 2 of Exploratory Data Analysis.

It contains all the code needed to generate the plots from the source data, <a href="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip">Project dataset from  EPA National Emissions database</a> [29Mb].

### Preparation
#### Libraries Required
* downloader
* ggplot2

```
library(downloader)
library(ggplot2)
```

#### Files to source
* **download_data.R**
    + **environment.NEI.data**:  Sets environmental variables used to specify file names and locations.  Should be modified as needed to point this software to the appropriate locations on the user's system.
    + **download.NEI.data**: Downloads the dataset from the EPA National Emissions database (only needs to be run once).
    + **load.NEI.data**: Generic function to load one of the RDS files into memory.  Called by other functions.
    + **NEI.PM25.data**: Loads the PM2.5 data frame from disk and returns it.  Called by plotting functions
    + **NEI.ClassCodes**: Loads the Classification Codes data frame from disk and returns it.  Called by plotting functions
* **Plot1.R**
    + **make.NEI.plot1**: Reads the PM2.5 data and produces a plot of total US Emissions by year.
* **Plot2.R**
    + **make.NEI.plot2**: Reads the PM2.5 data and produces a plot of total Emissions by year within Baltimore, MD.
* **Plot3.R**
    + **make.NEI.plot3**: Reads the PM2.5 data and produces a plot of total Emissions by year within Baltimore, MD broken down by type.
* **Plot4.R**
    + **make.NEI.plot4**: Reads the PM2.5 data and SCC data and produces a plot of total Emissions from coal use by year within the US broken down by Type (ie Source).
* **Plot5.R**
    + **make.NEI.plot5**: Reads the PM2.5 data and SCC data and produces a plot of total Emissions from different types of motor vehicles by year within Baltimore city broken down by EI Sector.
* **Plot6.R**
    + **make.NEI.plot6**: Reads the PM2.5 data and SCC data and produces a plots of total Emissions from different types of motor vehicles by year broken down by EI Sector comparing Baltimore City with LA County.

### Execution

1. Modify the function Environment.NEI.data in download_data.R as needed to run the code on your system.
1. Source the files.
1. Execute download.NEI.data
1. Execute desired plot functions.

Plots will be saved to working directory.