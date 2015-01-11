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

# Convert date fields to readable dates, combine into a single table
small_data_1$Date <- '2007-02-01'
small_data_2$Date <- '2007-02-02'
small_data <- rbind(small_data_1, small_data_2)

# create combined date_time  field, convert GAP & submetering fields into numerical values
small_data <- mutate(small_data, datetime = as.POSIXct(paste(small_data$Date, small_data$Time), format="%Y-%m-%d %H:%M:%S"))
small_data$Global_active_power <- as.numeric(levels(small_data$Global_active_power))[small_data$Global_active_power]
small_data$Sub_metering_1 <- as.numeric(levels(small_data$Sub_metering_1))[small_data$Sub_metering_1]
small_data$Sub_metering_2 <- as.numeric(levels(small_data$Sub_metering_2))[small_data$Sub_metering_2]
small_data$Sub_metering_3 <- as.numeric(levels(small_data$Sub_metering_3))[small_data$Sub_metering_3]

# Make plot
png('plot3.png', width = 480, height = 480, units = "px") #turn on png device
plot(small_data$datetime, small_data$Sub_metering_1, type='n', xlab = '', ylab = 'Energy sub metering')
with(small_data, lines(datetime, Sub_metering_1, col = 'black'))
with(small_data, lines(datetime, Sub_metering_2, col = 'red'))
with(small_data, lines(datetime, Sub_metering_3, col = 'blue'))
legend('topright', c("Sub_metering_1","Sub_metering_2", "Sun_metering_3"), lty=c(1,1,1), lwd=c(2.5,2.5,2.5),col=c("black", "red", "blue"))
dev.off() #turn off png device