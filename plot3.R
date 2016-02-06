library(data.table)
library(lubridate)
library(dplyr)

# Source Data file name
filename <- "household_power_consumption.txt"

# Read filtered data: Exclude columns 3-6
epc <- fread(
                filename, sep = ";",
                header = TRUE, na.strings = "?", stringsAsFactors = FALSE,
                select = c(1:2,7:9) 
              )                                                %>%
        
        # Convert to Date/Time
        mutate(DateTime=dmy_hms(paste(Date,Time)))             %>%
        
        # Remove previous Date and Time columns
        select(DateTime, Sub_metering_1, Sub_metering_2, Sub_metering_3)  %>%
        
        # Select only rows for Feb 1-2, 2007
        filter(DateTime >= ymd("2007-02-01") & DateTime < ymd("2007-02-03")) %>%
        
        # Sort by DateTime
        arrange (DateTime)

# Open plot devices
png(file = "plot3.png", width = 480, height = 480)

# Plot
with (epc, {
        plot(
                DateTime, 
                Sub_metering_1, 
                type="l",
                xlab = "",
                ylab = "Energy sub metering"
        ) 
        
        # Add second plots
        points(
                DateTime, 
                Sub_metering_2, 
                type="l",
                col = "red"
        )

        # Add third plots
        points(
                DateTime, 
                Sub_metering_3, 
                type="l",
                col = "blue"
        )

        # Add Legend
        legend(
                "topright", 
                legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
                col=c("black","red","blue"), 
                lty = 1, lwd = 2
        )
})

# Close plot device
dev.off()