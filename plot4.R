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
xdata <- xdata["2007-02-01 00:01:00/2007-02-03 00:00:00"]

#set up panels
par(mfrow = c(2, 2), mar=c(4, 4, 2, 1))

#generate plot 4
png("plot4.png")

plot(xdata$global.active.power, main = "",
     ylab = "Global Active Power",
     major.ticks = "days", major.format = "%a")

plot(xdata$voltage, main = "",
     ylab = "Voltage", xlab = "datetime",
     major.ticks = "days", major.format = "%a")

plot(xdata$sub.metering.1, main = "",
     ylab = "Energy sub metering",
     major.ticks = "days", major.format = "%a")
lines(xdata$sub.metering.2,
      col = "red")
lines(xdata$sub.metering.3,
      col = "blue")
legend("topright",
       lty = 1, col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

plot(xdata$global.reactive.power, main = "",
     ylab = "Global_reactive_power",
     xlab = "datetime",
     major.ticks = "days", major.format = "%a")

dev.off()