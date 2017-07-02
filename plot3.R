library(data.table)

#load the data
data <- fread("household_power_consumption.txt", na.strings = "?")

#make col names easier to work with
colnames(data) <- tolower(gsub("_",".",colnames(data)))

#and a posixc type column from date and time char columns
data[,datetime:=as.POSIXct(paste(date,time), format="%d/%m/%Y %H:%M:%S")]

#move the posix time to the front, and date and time to the last
setcolorder(data, c(10,3:9,1:2))

#convert data to XTS
xdata <- as.xts.data.table(data[, !c("date", "time"), with=F])

#subset to the time period we are examining
xdata <- xdata["2007-02-01/2007-02-03 00:01:00"]

#generate plot 3
plot(xdata$sub.metering.1,
     ylab = "Energy sub metering", main="",
     major.ticks = "days", major.format = "%a")
lines(xdata$sub.metering.2,
     col = "red")
lines(xdata$sub.metering.3,
      col = "blue")
legend("topright",
       lty = 1, col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))