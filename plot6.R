##  Course Project 2 : plot5.R

##  Questions

##  6.  Compare emissions from motor vehicle sources in Baltimore City with emissions from motor
##      vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen 
##      greater changes over time in motor vehicle emissions?

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

##  Emissions from Motor Vehicles in Baltimore City.
spm25_Baltimore_MV <- spm25[spm25$type %in% c("ON-ROAD","NON-ROAD") & spm25$fips == "24510",]
##  Emissions from Motor Vehicles in Los Angeles County.
spm25_LA_MV <- spm25[spm25$type %in% c("ON-ROAD","NON-ROAD") & spm25$fips == "06037",]

##  Tidy Data
EPY_MV<- dcast(rbind(spm25_Baltimore_MV, spm25_LA_MV), year + fips ~., sum, value.var = "Emissions")
##  Set descriptive values
EPY_MV[EPY_MV$fips=="06037",2] <- "Los Angeles County"
EPY_MV[EPY_MV$fips=="24510",2] <- "Baltimore city"
names(EPY_MV) <- c("Year", "U.S.County", "Emissions")

png(filename = "plot6.png", width = 480, height = 480, units = "px", bg = "transparent")

##  Plot with ggplot
g <- ggplot(EPY_MV, aes(x = Year, y = Emissions, color = U.S.County))
g + geom_point() + geom_line()

dev.off()