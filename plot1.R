fileurl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
# create a temporary directory
td = tempdir()
# create the placeholder file
tf = tempfile(tmpdir=td, fileext=".zip")
# download into the placeholder file
download.file(fileurl, tf)
# unzip the file to root directory
unzip(tf)

# Filter for desired dates
library(dplyr)
data <- read.csv('household_power_consumption.txt', header=TRUE, sep = ";")
small_data_2 <- filter(data, Date == '2/2/2007')
small_data_1 <- filter(data, Date == '1/2/2007')
small_data <- rbind(small_data_1, small_data_2)
small_data$Global_active_power <- as.numeric(levels(small_data$Global_active_power))[small_data$Global_active_power]

#Make the plot
png('plot1.png', width = 480, height = 480, units = "px") #turn on png device
hist(small_data$Global_active_power, xlab = 'Global Active Power (kilowatts)', main = 'Global Active Power', col = 'red')
dev.off() #turn off png device