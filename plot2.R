library(data.table)
library(lubridate)
library(dplyr)

# Source Data file name
filename <- "household_power_consumption.txt"

# Read filtered data: Only first three columns
epc <- fread(
                filename, sep = ";",
                header = TRUE, na.strings = "?", stringsAsFactors = FALSE,
                select = c(1:3) 
              )                                                %>%
        
        # Convert to Date/Time
        mutate(DateTime=dmy_hms(paste(Date,Time)))             %>%
        
        # Remove previous Date and Time columns
        select(DateTime, Global_active_power)                  %>%
        
        # Select only rows for Feb 1-2, 2007
        filter(DateTime >= ymd("2007-02-01") & DateTime < ymd("2007-02-03")) %>%
        
        # Sort by DateTime
        arrange (DateTime)

# Open plot devices
png(file = "plot2.png", width = 480, height = 480)

# Plot
with(epc, 
     plot(
             DateTime, 
             Global_active_power, 
             type="l",
             xlab = "",
             ylab = "Global Active Power (kilowatts)"
        )
)

# Close plot device
dev.off()