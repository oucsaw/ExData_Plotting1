#
# R code to reproduce plot1 as plot1.png
#
# Notes: Our overall goal here is simply to examine how household
# energy usage varies over a 2-day period in February, 2007. Our task
# is to reconstruct a histogram plot as a 480x480 png file plot1.png
#
# This histogram shows the distribution of 'Global Active power' in
# kilowats for our dataset

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

# For the first histogram, we don't need to convert the date and time
# from character vectors into more suitable units, so we omit this
# conversion
#
# Create a png with filename 'plot1.png' and  size 480x480 (the defaults
# - but we specify them to be certian)
png(filename='plot1.png', widt = 480, height=480)

# Plot the histogram as one command - we could split this up, but 
# choose not to in this instance
# We use the data from the Global_active_power part of the data frame
# and plot this as a red histogram with main title
# 'Global Active Power' and the x-axis labelled
# 'Global Active Power (kilowatts)' leaving the y-axis label as the
# default
#
hist(assignmentDataset$Global_active_power,
     col='red',
     main='Global Active Power',
     xlab='Global Active Power (kilowatts)')

# close the created png device
dev.off()

# End
