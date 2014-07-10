#Course Project 1 - PLOT2
#
#Dataset: 
#Electric power consumption
#

#download data & extract Data Set
td <- tempdir()
temp <- tempfile(tmpdir=td, fileext = ".zip")
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, temp)
fname <- unzip(temp, list = TRUE)$Name[1]
unzip(temp, files = fname, exdir = td, overwrite = TRUE)
fpath <- file.path(td, fname)

#Process Raw Data
cc <- c("character","NULL","numeric","NULL","NULL","NULL","NULL","NULL","NULL")
ds <- read.table(fpath, header=TRUE, sep = ";", na.strings = "?", colClasses=cc)
ds$Date <- as.Date(ds$Date, format  ="%d/%m/%Y")


#We'll work with the data from the dates 2007-02-01 and 2007-02-02
startDate <- as.Date("2007-02-01");
endDate <- as.Date("2007-02-02");
dstidy <- ds[(ds$Date >= startDate & ds$Date <= endDate),]
remove(ds)

#Plot in a PNG graphic device
png(filename = "plot1.png", width = 480, height = 480, units = "px", bg = "transparent")
hist(dstidy$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off()
