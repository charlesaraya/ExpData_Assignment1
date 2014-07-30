
## Download the Data that will be used in the assignment.

td <- tempdir()
temp = tempfile(tmpdir=td, fileext=".zip")

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, temp)
dateDownloaded <- date()

sourceClassificationCode <- unzip(temp, list=TRUE)$Name[1]
summarySCC_PM25 <- unzip(temp, list=TRUE)$Name[2]

