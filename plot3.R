##  Course Project 2 : plot3.R

##  Questions

##  3.  Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
##      variable, which of these four sources have seen decreases in emissions from 1999-2008
##      for Baltimore City? 
##      Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system 
##      to make a plot answer this question.

##  Libraries
library(reshape2)   ## dcast function used
library(ggplot2)    ## ggplot2 graphic functions used

##  Download the Data that will be used in the assignment.
td <- tempdir()
temp = tempfile(tmpdir=td, fileext=".zip")
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, temp)
dateDownloaded <- date()

##  Unzip the files
sourceClassificationCode <- unzip(temp, list=TRUE)$Name[1] # Source Classification Code Table
summary_PM25 <- unzip(temp, list=TRUE)$Name[2] #PM2.5 Emissions Data
unzip(temp, files=sourceClassificationCode, exdir=td, overwrite=TRUE)
unzip(temp, files=summary_PM25, exdir=td, overwrite=TRUE)
sourceClassificationCode_Path = file.path(td, sourceClassificationCode)
summary_PM25_Path = file.path(td, summary_PM25)

## Read the RData (.rds) files

##  Table that provides a mapping from the SCC digit in spm25 to the actual name of the PM2.5 source.
scc <- readRDS(sourceClassificationCode_Path)
##  Data Frame with the PM2.5 emissions data for 1999, 2002, 2005, and 2008
spm25 <- readRDS(summary_PM25_Path)

##  Lets take all the PM2.5 EMissions of Baltimore City (fips code = 24510)
##  and dcast the Year and Type (EPYT) by the sum of Emissions
EPYT_Baltimore<- dcast(spm25[spm25$fips=="24510",], year + type ~., sum, value.var = "Emissions")

##  set descriptive name variables
names(EPYT_Baltimore) <- c("Year","Type", "Emissions")

png(filename = "plot3.png", width = 480, height = 480, units = "px", bg = "transparent")

## plot with ggplot

g <- ggplot(EPYT_Baltimore, aes(x = Year, y = Emissions, color = Type))
g + geom_point() + geom_line()

##  Also:
##  qplot(Year, Emissions, color = Type, data = EPYT_Baltimore)

dev.off()