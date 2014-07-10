#Course Project 1 - PLOT2
#
#Dataset: 
#Electric power consumption
#

#We will use data.table functions
if(!require("data.table")){
  install.packages("data.table")
  library(data.table)
}

#download data & extract Data Set
td <- tempdir()
temp <- tempfile(tmpdir=td, fileext = ".zip")
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, temp)
fname <- unzip(temp, list = TRUE)$Name[1]
unzip(temp, files = fname, exdir = td, overwrite = TRUE)
fpath <- file.path(td, fname)

#Process Raw Data
cc <- c("character","character","numeric","numeric","numeric","NULL","numeric","numeric","numeric")
ds <- read.table(fpath, header=TRUE, sep = ";", na.strings = "?", colClasses=cc)
ds$dateTime <- paste(ds$Date,ds$Time)
ds$Date <- as.Date(ds$Date, format  ="%d/%m/%Y")

#We'll work with the data from the dates 2007-02-01 and 2007-02-02
startDate <- as.Date("2007-02-01")
endDate <- as.Date("2007-02-02")
dstidy <- ds[(ds$Date >= startDate & ds$Date <= endDate),]
remove(ds)
dstidy$dateTime <- strptime(dstidy$dateTime,"%d/%m/%Y %H:%M:%S")


#Plot in a PNG graphic device
png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "transparent")
par(mfrow=c(2,2))
{
  plot(dstidy$dateTime, dstidy$Global_active_power, type = "l", ylab = "Global Active Power", xlab = "")
}
{
  plot(dstidy$dateTime, dstidy$Voltage, type="l", ylab = "Voltage", xlab = "datetime")
}
{
  plot(dstidy$dateTime, dstidy$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
  lines(dstidy$dateTime, dstidy$Sub_metering_2, type="l", col="red")
  lines(dstidy$dateTime, dstidy$Sub_metering_3, type="l", col="blue")
  legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), y.intersp=0.8, bty="n", col=c("black","red","blue"), lty = c(1,1,1))
}
{
  plot(dstidy$dateTime, dstidy$Global_reactive_power, type="l", ylab="Global_reactive_power", xlab = "datetime")
}
dev.off()
