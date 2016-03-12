#
# R script to download and extract the data files 
# for the assignment
#

# The URL for the data (as provided in the assignment)
zipfileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'

# We store the downloaded file in the dowloads directory
downloadedDIR <- './downloads/'
downloadedZIP <- './downloads/dataset.zip'

# We extract the zipfile into the data directory
dataDIR <- './data/'

# Create any missing directories
if ( ! file.exists( downloadedDIR ) ) { dir.create( downloadedDIR ) }
if ( ! file.exists( dataDIR )       ) { dir.create( dataDIR )       }

# See if we have already downloaded the file - and only download this
# file if it is not already present
if ( ! file.exists( downloadedZIP ) ) {
     # Download the file (which as it is https, means that we need to use
     # method = 'curl' on this Mac)
     download.file(zipfileURL, dest=downloadedZIP, method='curl')
}

# Extract the ZIP file into the data directory
# We always overwrite the data; this might not be the best choice
# but we assume that as we are trying to get the data, we need to
# ensure we have a valid, unedited copy. 
#
unzip(downloadedZIP, exdir=dataDIR, overwrite=TRUE)

