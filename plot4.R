#
# R code to reproduce plot3 as plot3.png
#
# Notes: Our overall goal here is simply to examine how household
# energy usage varies over a 2-day period in February, 2007. Our task
# is to reconstruct four line graphs showing global active power,
# voltage, energy sub meters and global reactive power changes over
# the days between 2007-02-01 between 2007-02-2
#
# Firstly, ensure that the libraries graphics (for hist) and
# grDevices (so we can save these as png files) are loaded
library(graphics)
library(grDevices)

# Load the data (assuming it is in the file 
# data/household_power_consumption.txt as it would be if we had used the 
# download.R script)
dataFile <- 'data/household_power_consumption.txt'

# As this file is large, and we only need a subset of it, we will
# only load the necessary data points; first, however, we load the
# first row of the file so we can use these as column labels:
labels <- read.table(dataFile,
                     header = TRUE,
                     sep = ';',
                     nrow = 1 ) 

# Now we read in the data for the dates 2007-02-01 to 2007-02-02.
# Note that we have previously calcuated skip and nrow using the R
# code:
#     fullDataset <- read.table(dataFile,
#                               header=FALSE, 
#                               sep=';',
#                               na.strings='?',
#                               stringsAsFactors = FALSE)
#     names(fullDataset) <- names(labels)
#     # (header = FASLE as we need to count the first line in our skip)
#     skipLines <-  match('1/2/2007', fullDataset$Date) - 1
#     #  ( subtract one as we need to include the matched argument)
#     nRows <- (match('3/2/2007', fullDataset$Date) -1 ) - skipLines
#
skipLines <- 66637
nRows <- 2880

# Load the data for the dates 2017-02-01 to 2007-02-02 (inclusive)

assignmentDataset <- read.table(dataFile,
                                header=FALSE, 
                                sep=';',
                                skip = skipLines,
                                nrows = nRows)
names(assignmentDataset) <- names(labels)


# We now create a vector of POSIXct to pass to the plot by parsing the
# assignementDataset$Date and assignementDataset$Time columns of our
# date to create an assignementDataset$DateTime column
#
# Firstly, we create paste together the contents of the Date and Time
# columns of our dataset, which we will then use strptime to convert
# to  POSIXct 
dateTime <-
    mapply(paste, assignmentDataset$Date, assignmentDataset$Time )

# The DateTime Colmn has the format 'day/month/year hour:minute:second'
# which we convert via the format string: '%d/%m/%Y %H:%M:%S'
#
# Firstly, we define a helper function to do the conversion, returning
# a POSIXct variable:
convertDateTime <- function(dateTime) {
   as.POSIXct(strptime(dateTime, '%d/%m/%Y %H:%M:%S'))
   #strptime(dateTime, '%d/%m/%Y %H:%M:%S')
}

# We then apply this to out dateTime data, saving this into 
# our data frame:
assignmentDataset$DateTime <- sapply(dateTime, convertDateTime)

# Cleanup some unused variables:
rm(dateTime)

# Now onto the plots: firstly we open the PNG file device called
# 'plot4.png' sized as 480x480  (the default but we specify to
# be certian)
png(filename='plot4.png', widt = 480, height=480)

# Split the device into 2 rows and 2 columns using
# mfrow (so rows will fill first):
par(mfrow = c(2,2))

# In advance of time setup the x-axis labels which are the same on all
# 4 graphs: generate the two vectors: one for the labels (xlabels) and
# one containing the points on the x-axis to mark:
# we create these two vectos using the data at positions
# 1 (nRows / 2 + 1) (middle point), and nRows of 
# the assignmentDataset$DateTime vector
xlabels <- assignmentDataset$DateTime[ c(1, (nRows/2+1), nRows)]
xMarks <- assignmentDataset$DateTime[ c(1, (nRows/2+1), nRows)]

# We convert the labels to the abbreviated weekday name via the helper
# function convertTimeToWeekday:
convertTimeToWeekday <- function(time) {
    weekdays(strptime(time, '%s'), TRUE)
}

xlabels <- sapply(xlabels, convertTimeToWeekday)


# Plot 1 is the same as that in plot2.R - see that file for further 
# comments:
plot(assignmentDataset$DateTime,
     assignmentDataset$Global_active_power,
     type = 'l',  # A line plot
     xaxt = 'n',  # Blank x axis 
     ylab = 'Global Active Power',
     xlab='')

# Label the axis:
axis(1, at = xMarks, labels = xlabels)

# Plot 2 is new: we plot voltage against time
plot(assignmentDataset$DateTime,
     assignmentDataset$Voltage,
     type = 'l',  # A line plot
     xaxt = 'n',  # Blank x axis 
     ylab = 'Voltage',
     xlab='datetime')

# Label the axis:
axis(1, at = xMarks, labels = xlabels)

# Plot 3 is nearly the same as that in plot3.R; this time the legend 
# has no border - howerver see that file for further comments:

# Plot the first sub meter:
plot(assignmentDataset$DateTime,
     assignmentDataset$Sub_metering_1,
     type = 'l',  # A line plot
     xaxt = 'n',  # Blank x axis 
     ylab = 'Energy sub metering',
     xlab='')
# add the second sub meter:
lines(assignmentDataset$DateTime,
     assignmentDataset$Sub_metering_2,
     type = 'l',
     col = 'red' )
# add the third sub meter:
lines(assignmentDataset$DateTime,
     assignmentDataset$Sub_metering_3,
     type = 'l',
     col = 'blue' )
# Now, we create a legend in the top right hand corner
legend('topright',
       legend =  c('Sub_metering_1',
                   'Sub_metering_2',
                   'Sub_metering_3' ),
       col    =  c( 'black', 'red', 'blue' ),
       lwd    = 1, 
       bty = 'n' )


# Plot 4 is new: we plot Global reactive power against time
plot(assignmentDataset$DateTime,
     assignmentDataset$Global_reactive_power,
     type = 'l',  # A line plot
     xaxt = 'n',  # Blank x axis 
     ylab = 'Global_reactive_power',
     xlab='datetime')

# Label the axis:
axis(1, at = xMarks, labels = xlabels)


# close the created png device
dev.off()

# End
