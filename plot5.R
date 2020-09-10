library(dplyr)

#reading the data form the files -----------------------------------------------
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
levels(SCC$EI.Sector)
#extraction the Baltimore MV related data       
BalMV_data <- merge(NEI, SCC, by = "SCC") %>%
        filter(grepl("Mobile", EI.Sector)) %>%
        filter(fips == "24510")
#summing the data by year
total_BalMV_by_year <- tapply(BalMV_data$Emissions, BalMV_data$year, FUN = sum)

#creating the png file for plot1------------------------------------------------
png(filename = "plot5.png", width = 480, height = 480, units = "px")

#plotting the data
plot(total_BalMV_by_year, xlab = "", ylab = "", tick = F, labels = "",
     type = "l", col = "purple", cex.lab = 0.75)
#customizing the axes
axis(1, col.axis="dodgerblue", at = 1:4,
     labels = c("1999", "2002", "2005", "2008"))
axis(2, col.axis="dodgerblue")
#customizing the labels
mtext("Years", side=1, line=3, col="darkgrey", cex=0.75)
mtext("Total PM2.5 Emission (tons)", side=2, line=3, col="darkgrey",
      cex=0.75)

dev.off()