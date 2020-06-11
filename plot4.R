#Load Libraries
library(dplyr)
library(utils)
library(ggplot2)

#Download file
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile=temp,method="libcurl")
## READING DATASET 
electric_power_consumption <- read.table(unzip(temp, files ="household_power_consumption.txt", list = FALSE), sep=";", header = TRUE, na.strings = "?")

#convert factor to date
electric_power_consumption$Date <- as.Date(as.character(electric_power_consumption$Date), format("%d/%m/%Y"))

#Filter period in analysis
electric_power_consumption <- electric_power_consumption  %>% filter(Date %in% c(as.Date("2007-02-01", format("%Y-%m-%d")),as.Date("2007-02-02", format("%Y-%m-%d"))))

#create date time var
electric_power_consumption$DateTime <- as.POSIXct(paste0(as.character(electric_power_consumption$Date), " ", as.character(electric_power_consumption$Time)), 
                                                  format="%Y-%m-%d %H:%M:%S")

#windows(width=10, height=8)
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0)) # 2x2 window chart

#create and save chart 1
with(electric_power_consumption, plot(x=DateTime, y=Global_active_power, type="l", xlab="Day Hour", ylab="Global active power"))
title("Hourly Distribution of Global active power (KW)")

#create and save chart 2
with(electric_power_consumption, plot(x=DateTime, y=Voltage, type="l", xlab="Day Hour", ylab="Voltage (volt)"))
title("Hourly Voltage")

#create and save chart 3
with(electric_power_consumption, plot(x=DateTime, y=Sub_metering_1,
                                      type="l", xlab="Day Hour", ylab="Energy Sub metering") )
with(electric_power_consumption,lines(x=DateTime, y=Sub_metering_2, col = "red", type= "l" ))
with(electric_power_consumption,lines(x=DateTime, y=Sub_metering_3, col = "blue", type= "l" ))

legend("topright",legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),col=c("black","red","blue"),lty=1,lwd=1,
       cex = 0.75,  bty="n")

grid()
title("Hourly Energy Sub metering")

#create and save chart 4
with(electric_power_consumption, plot(x=DateTime, y=Global_reactive_power, type="l", xlab="Day Hour", ylab="Global active power"))
title("Hourly Global Reactive power (KW)")

dev.copy(png,'./plot4.png') #default size  480x480 pixels
dev.off()


unlink(temp)