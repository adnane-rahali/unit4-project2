library(dplyr)

#reading the data form the files -----------------------------------------------
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#extraction the  coal combustion-related data       
coal_data <- merge(NEI, SCC, by = "SCC") %>%
                filter(grepl("Coal", EI.Sector) & grepl("Comb", EI.Sector))
#summing the data by year
total_coal_by_year <- tapply(coal_data$Emissions, coal_data$year, FUN = sum)
#changing the unit to 10,000 tons
total_coal_by_year <- total_coal_by_year/10000

#creating the png file for plot1------------------------------------------------
png(filename = "plot4.png", width = 480, height = 480, units = "px")

#plotting the data
plot(total_coal_by_year, xlab = "", ylab = "", tick = F, labels = "",
     type = "l", col = "purple", cex.lab = 0.75)
#customizing the axes
axis(1, col.axis="dodgerblue", at = 1:4,
     labels = c("1999", "2002", "2005", "2008"))
axis(2, col.axis="dodgerblue")
#customizing the labels
mtext("Years", side=1, line=3, col="darkgrey", cex=0.75)
mtext("Total PM2.5 Emission (10,000 tons)", side=2, line=3, col="darkgrey",
      cex=0.75)

dev.off()