##  Course Project 2 : plot5.R

##  Questions

##  5.  How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
##      Emissions in Baltimore City from Motor Vehicles. They are divided in on-road mobile sources, that include
##      emissions from motorized vehicles that are normally operated on public roadways and non-road, 
##      were aircraft and agriculture field equipment are included.

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

##  Read the RData (.rds) files

##  Table that provides a mapping from the SCC digit in spm25 to the actual name of the PM2.5 source.
scc <- readRDS(sourceClassificationCode_Path)
##  Data Frame with the PM2.5 emissions data for 1999, 2002, 2005, and 2008
spm25 <- readRDS(summary_PM25_Path)

spm25_Baltimore_MV <- spm25[spm25$type %in% c("ON-ROAD","NON-ROAD") & spm25$fips == "24510",]

##  Tidy Data
EPY_Baltimore_MV<- dcast(spm25_Baltimore_MV, year ~., sum, value.var = "Emissions")
names(EPY_Baltimore_MV) <- c("Year", "Emissions")

png(filename = "plot5.png", width = 480, height = 480, units = "px", bg = "transparent")

##  Plot with ggplot

g <- ggplot(EPY_Baltimore_MV, aes(x = Year, y = Emissions))
g + geom_point() + geom_line()

dev.off()