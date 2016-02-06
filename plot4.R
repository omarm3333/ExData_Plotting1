library(data.table)
library(lubridate)
library(dplyr)

# Source Data file name
filename <- "household_power_consumption.txt"

# Read filtered data: Date, Time and Global Active Power
epc <- fread(
                filename, sep = ";",
                header = TRUE, na.strings = "?", stringsAsFactors = FALSE
              )                                                %>%
        
        # Convert to Date/Time
        mutate(DateTime=dmy_hms(paste(Date,Time)))             %>%
        
        # Remove previous Date and Time columns
        select(-Date, -Time, -Global_intensity)  %>%
        
        # Select only rows for Feb 1-2, 2007
        filter(DateTime >= ymd("2007-02-01") & DateTime < ymd("2007-02-03")) %>%
        
        # Sort by DateTime
        arrange (DateTime)

# Open plot devices
png(file = "plot4.png", width = 480, height = 480)

# Activate 4x4 overlay plots
par(mfcol = c(2, 2))

# Plot 1
with(epc, 
     plot(
             DateTime, 
             Global_active_power, 
             type="l",
             xlab = "",
             ylab = "Global Active Power (kilowatts)"
     )
)

# Plot 2
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

# Plot 3
with (epc, plot(
        DateTime,
        Voltage,
        xlab = "datetime",
        ylab = "Voltage",
        type = "l"
))

# Plot 4
with(epc, plot(
        DateTime,
        Global_reactive_power,
        xlab = "datetime",
        type = "l"
))

# Close plot device
dev.off()