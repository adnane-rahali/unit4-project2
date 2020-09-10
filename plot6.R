library(dplyr)
library(ggplot2)

#reading the data form the files -----------------------------------------------
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
levels(SCC$EI.Sector)
#extraction the Baltimore MV related data       
BalMV_data <- merge(NEI, SCC, by = "SCC") %>%
        filter(grepl("Mobile", EI.Sector)) %>%
        filter(fips == "24510")
#extraction the LA MV related data       
LAMV_data <- merge(NEI, SCC, by = "SCC") %>%
        filter(grepl("Mobile", EI.Sector)) %>%
        filter(fips == "06037")
#summing the data by year
total_BalMV_by_year <- tapply(BalMV_data$Emissions, BalMV_data$year, FUN = sum)
total_LAMV_by_year <- tapply(LAMV_data$Emissions, LAMV_data$year, FUN = sum)
#determining MV percentage change in Baltimore and LA for each period
Baltimore_Change <- ((total_BalMV_by_year-lag(total_BalMV_by_year))/lag(total_BalMV_by_year))*100
LA_Change = ((total_LAMV_by_year-lag(total_LAMV_by_year))/lag(total_LAMV_by_year))*100
#creating a data frame to contain all the desired data
df <- data.frame(Periods = rep(c("NA", "1999-2002", "2002-2005", "2005-2008"), 2),
                 Cities = c(rep("Baltimore", 4), rep("LA", 4)),
                 Changes = c(Baltimore_Change,LA_Change))
df <- df %>%
        filter(Periods != "NA")

#creating the png file for plot1------------------------------------------------
png(filename = "plot6.png", width = 480, height = 480, units = "px")

#plotting the data
ggplot(df, aes(fill=Cities, y=Changes, x=Periods)) +
        geom_bar(position="dodge", stat="identity") +
        ggtitle("MV Emissions' Percentage Change Over Time") +
        ylab("Change (%)") +
        theme_bw()

dev.off()


