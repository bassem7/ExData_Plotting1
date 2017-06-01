#For each plot: 
#       Create a separate R code file (𝚙𝚕𝚘𝚝𝟷.𝚁, 𝚙𝚕𝚘𝚝𝟸.𝚁, etc.) that constructs the corresponding plot, i.e. code in 𝚙𝚕𝚘𝚝𝟷.𝚁 constructs the 𝚙𝚕𝚘𝚝𝟷.𝚙𝚗𝚐 plot.
#       Your code file should include code for reading the data so that the plot can be fully reproduced. 
#       You must also include the code that creates the PNG file.
#       Construct the plot,  
#       save it to a PNG file with a width of 480 pixels and a height of 480 pixels. 
#       Name each of the plot files as 𝚙𝚕𝚘𝚝𝟷.𝚙𝚗𝚐, 𝚙𝚕𝚘𝚝𝟸.𝚙𝚗𝚐, etc.

#       Add the PNG file and R code file to the top-level folder of your git repository (no need for separate sub-folders)
#       When you are finished with the assignment, push your git repository to GitHub so that the GitHub version of your repository is up to date. There should be four PNG files and four R code files, a total of eight files in the top-level folder of the repo.

library("dplyr")

getwd()
list.files()

# Import Data from file
file#setwd("...")
nm = "household_power_consumption.txt"
dt<-read.table(filenm, header= FALSE, sep = ";",skip = 1, na.strings = "?")
#dt<- dt[2:length(dt$Date),]

# Rename columnns
# Date;Time;Global_active_power;Global_reactive_power;Voltage;Global_intensity;Sub_metering_1;Sub_metering_2;Sub_metering_3
colnames(dt) <- c("Date", "Time",
                  "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity",
                  "Sub_metering_1","Sub_metering_2","Sub_metering_3")
head(dt)
tail(dt)

# calculate a rough estimate of how much memory the dataset will require in memory before reading into R.

# Note that in this dataset missing values are coded as ?.


#  convert the Date and Time variables to Date/Time classes in R using the 𝚜𝚝𝚛𝚙𝚝𝚒𝚖𝚎()  and 𝚊𝚜.𝙳𝚊𝚝𝚎() functions.
#as.Date(as.character(dt$Date[1:10]),"%d/%m/%Y")
#strptime(as.character(dt$Time[1:10]), format = "%H:%M:%S")
strptime(paste(dt$Date[1:10],dt$Time[1:10]), format = "%d/%m/%Y %H:%M:%S")
dt$datetime <- strptime(paste(dt$Date,dt$Time), format = "%d/%m/%Y %H:%M:%S")
dt$datetime<- as.POSIXct(dt$datetime)

# Filter out data for the dates 2007-02-01 and 2007-02-02. 
dt2<- filter(dt,
             ((difftime(datetime, strptime("2007-02-01", format = "%Y-%m-%d")) >= 0) &  
                      (difftime(datetime, strptime("2007-02-03", format = "%Y-%m-%d")) <= 0)))
# (difftime(dt$datetime[1:10],strptime("2007-02-01", format = "%Y-%m-%d"))>0)    & (difftime(dt$datetime[1:10], strptime("2007-02-02", format = "%Y-%m-%d"))<0)
head(dt2)
tail(dt2)

dt2$Global_active_power <-  as.numeric(as.character(dt2$Global_active_power))
dt2$Global_reactive_power <-  as.numeric(as.character(dt2$Global_reactive_power))
dt2$Voltage <-  as.numeric(as.character(dt2$Voltage))
dt2$Global_intensity <-  as.numeric(as.character(dt2$Global_intensity))
dt2$Sub_metering_1 <-  as.numeric(as.character(dt2$Sub_metering_1))
dt2$Sub_metering_2 <-  as.numeric(as.character(dt2$Sub_metering_2))
dt2$Sub_metering_3 <-  as.numeric(as.character(dt2$Sub_metering_3))


#Plot 4: 2x2 
par(mfrow = c(2,2))
#               1)  Global Active Power (kilowatts) vs "Time/Day of the Week" main="". col =""  (Thurs: Sat)
plot(dt2$datetime,dt2$Global_active_power, ylab="Global Active Power (kilowatts)",type ="l", xlab="")
#               2) Voltage vs date/time.  (Thurs: Sat)
plot(dt2$datetime,dt2$Voltage, ylab="Voltage",xlab="datetime",type ="l")
#               3) Energy sub metering vs  "Time/Day of the Week" main="". col = "" Legend submetering 1 black, submetering 2 red, submetering 3 blue  (Thurs: Sat)
plot(dt2$datetime,dt2$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab="")
points(dt2$datetime,dt2$Sub_metering_1, col = "black",type ="l")
points(dt2$datetime,dt2$Sub_metering_2, col = "red",type ="l")
points(dt2$datetime,dt2$Sub_metering_3, col = "blue",type ="l")
legend ("topright", pch =1, col= c("black", "red", "blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty = "n")
#               4) Global reactive power vs date/time (Thurs: Sat)
plot(dt2$datetime,dt2$Global_reactive_power, ylab="Global_reactive_power",xlab="datetime",type ="l")
dev.copy(png,"plot4.png", width = 480, height = 480); dev.off()


