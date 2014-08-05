##  Course Project 2 : plot2.R

##  Questions

##  2.  Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
##      from 1999 to 2008? Use the base plotting system to make a plot answering this question.

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

##  Lets take all the PM2.5 Emissions of Baltimore City (fips code = 24510)
##  and dcast the Year (EPY) by the sum of Emissions
EPY_Baltimore<- dcast(spm25[spm25$fips=="24510",], year ~., sum, value.var = "Emissions")
names(EPY_Baltimore) <- c("Year", "Emissions")

png(filename = "plot2.png", width = 480, height = 480, units = "px", bg = "transparent")

##  plot
with(EPY_Baltimore, plot(Year, Emissions, ylab = "Emissions (in tons)"))
with(EPY_Baltimore, lines(Year, Emissions))
title(main = "Total Emissions per Year in the Baltimore City")

dev.off()