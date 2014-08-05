##  Course Project 2 : plot1.R

##  Questions

##  1.  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
##      Using the base plotting system, make a plot showing the total PM2.5 emission from 
##      all sources for each of the years 1999, 2002, 2005, and 2008.

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

##  Lets take all the PM2.5 EMissions of all USA and dcast the Year (EPY) by the sum of Emissions
EPY<- dcast(spm25, year ~., sum, value.var = "Emissions")
names(EPY) <- c("Year", "Emissions")

png(filename = "plot1.png", width = 480, height = 480, units = "px", bg = "transparent")

with(EPY, plot(Year, Emissions, ylab = "Emissions (in tons)"))
with(EPY, lines(Year, Emissions))
title(main = "Total Emissions per Year")

dev.off()