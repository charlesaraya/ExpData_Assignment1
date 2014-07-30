## We'll use dcast function later.
library(reshape2)
## Wee'll use ggplot2 graphics
library(ggplot2)

## Download the Data that will be used in the assignment.

td <- tempdir()
temp = tempfile(tmpdir=td, fileext=".zip")

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, temp)
dateDownloaded <- date()


##  Get the file names from the zip
sourceClassificationCode <- unzip(temp, list=TRUE)$Name[1] # Source Classification Code Table
summary_PM25 <- unzip(temp, list=TRUE)$Name[2] #PM2.5 Emissions Data

##  Unzip both files
unzip(temp, files=sourceClassificationCode, exdir=td, overwrite=TRUE)
unzip(temp, files=summary_PM25, exdir=td, overwrite=TRUE)

##  Get the file paths
sourceClassificationCode_Path = file.path(td, sourceClassificationCode)
summary_PM25_Path = file.path(td, summary_PM25)

## Read the RData (.rds) files

##  Table that provides a mapping from the SCC digit in spm25 to the actual name of the PM2.5 source.
scc <- readRDS(sourceClassificationCode_Path)

##  Data Frame with the PM2.5 emissions data for 1999, 2002, 2005, and 2008
spm25 <- readRDS(summary_PM25_Path)

setwd("C:\\Users\\Rizzo\\Documents\\Academics\\coursera\\Exploring Data")
##  __________________________________________________
##  Questions

##  1.  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
##      Using the base plotting system, make a plot showing the total PM2.5 emission from 
##      all sources for each of the years 1999, 2002, 2005, and 2008.

##  Lets take all the PM2.5 EMissions of all USA
##  and dcast the Year (EPY) by the sum of Emissions
EPY<- dcast(spm25, year ~., sum, value.var = "Emissions")
##  set descriptive name variables
names(EPY) <- c("Year", "Emissions")

png(filename = "Qplot1.png", width = 480, height = 480, units = "px", bg = "transparent")

with(EPY, plot(Year, Emissions, ylab = "Emissions (in tons)"))
with(EPY, lines(Year, Emissions))
title(main = "Total Emissions per Year")

dev.off()

##  Answer: PM2.5 emissions have decresed in USA from 1999 to 2008 year by year.

##_________________________________________________________________________________________________

##  2.  Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
##      from 1999 to 2008? Use the base plotting system to make a plot answering this question.

##  Lets take all the PM2.5 Emissions of Baltimore City (fips code = 24510)
##  and dcast the Year (EPY) by the sum of Emissions
EPY_Baltimore<- dcast(spm25[spm25$fips=="24510",], year ~., sum, value.var = "Emissions")

##  set descriptive name variables
names(EPY_Baltimore) <- c("Year", "Emissions")

png(filename = "Qplot2.png", width = 480, height = 480, units = "px", bg = "transparent")

##  plot
with(EPY_Baltimore, plot(Year, Emissions, ylab = "Emissions (in tons)"))
with(EPY_Baltimore, lines(Year, Emissions))
title(main = "Total Emissions per Year in the Baltimore City")

dev.off()

##  Answer: PM2.5 emissions have decresed in Baltimore city from 1999 to 2008 
##          but in 2005 PM2.5 emissions had a peek up rasining to 3091.354 and 
##          then falling to 1862.282 in 2008.

##_________________________________________________________________________________________________

##  3.  Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
##      variable, which of these four sources have seen decreases in emissions from 1999-2008
##      for Baltimore City? 
##      Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system 
##      to make a plot answer this question.

##  Lets take all the PM2.5 EMissions of Baltimore City (fips code = 24510)
##  and dcast the Year and Type (EPYT) by the sum of Emissions
EPYT_Baltimore<- dcast(spm25[spm25$fips=="24510",], year + type ~., sum, value.var = "Emissions")

##  set descriptive name variables
names(EPYT_Baltimore) <- c("Year","Type", "Emissions")

png(filename = "Qplot3.png", width = 480, height = 480, units = "px", bg = "transparent")

## plot with ggplot
##  qplot(Year, Emissions, color = Type, data = EPYT_Baltimore)
g <- ggplot(EPYT_Baltimore, aes(x = Year, y = Emissions, color = Type))
g + geom_point() + geom_line()

dev.off()

##  Answer: NON-POINT emissions have seen decreasesduring the period between 1999-2008 but still
##          very high above the other types of emissions. NON-ROAD and ON-ROAD emissions have 
##          decreased during the period previously mentioned. 
##          It is visible that the absolute difference between emissions in 2002 and 2006 for
##          types NONPOINT, NON-ROAD and ON-ROAD were next to 0. On the other hand, POINT emissions
##          suffered a big increase and that same period, but decreasing again in 2008. Nevertheless
##          it fell to values near 1999, the balance is negative. so we can conclude that this type 
##          of emission have decreased          

##_________________________________________________________________________________________________

##  4.  Across the United States, how have emissions from coal combustion-related sources 
##      changed from 1999-2008?


##  5.  How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

##  6.  Compare emissions from motor vehicle sources in Baltimore City with emissions from motor
##      vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen 
##      greater changes over time in motor vehicle emissions?