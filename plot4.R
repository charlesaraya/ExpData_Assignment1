##  Course Project 2 : plot4.R

##  Questions

##  4.  Across the United States, how have emissions from coal combustion-related sources 
##      changed from 1999-2008?

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

##  Look for all the Coal combustion-related sources in the Source Classification code data set
CoalSourcesShortNames <- grep("Coal", as.character(scc$Short.Name), ignore.case = FALSE, fixed = TRUE)
CoalSCC<- scc[CoalSourcesShortNames, 1] ## get 1st column (SCC variable)

##  Emissions in USA from Coal combustion-related sources
spm25_coal <- spm25[spm25$SCC %in% as.character(CoalSCC),]
##  Tidy Data
EPY_Coal<- dcast(spm25_coal, year ~., sum, value.var = "Emissions")
names(EPY_Coal) <- c("Year", "Emissions")

png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "transparent")

## plot with ggplot
g <- ggplot(EPY_Coal, aes(x = Year, y = Emissions))
g + geom_point() + geom_line()

dev.off()