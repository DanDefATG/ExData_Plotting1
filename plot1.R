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

#create and save chart
hist(electric_power_consumption$Global_active_power, col = c("red"), main="Distribution of Global active power (KW)", xlab="Global active power (KW)")
dev.copy(png,'./plot1.png') #default size  480x480 pixels
dev.off()


unlink(temp)