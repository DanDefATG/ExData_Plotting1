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

#create and save chart
with(electric_power_consumption, plot(x=DateTime, y=Sub_metering_1,
                                      type="l", xlab="Day Hour", ylab="Energy Sub metering") )
with(electric_power_consumption,lines(x=DateTime, y=Sub_metering_2, col = "red", type= "l" ))
with(electric_power_consumption,lines(x=DateTime, y=Sub_metering_3, col = "blue", type= "l" ))
          
legend("topright",legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),lty=c(1,2,3),col=c("black","red","blue"),bg="white",lwd=2)
          
grid()
title("Hourly Energy Sub metering")
dev.copy(png,'./plot3.png') #default size  480x480 pixels
dev.off()


unlink(temp)