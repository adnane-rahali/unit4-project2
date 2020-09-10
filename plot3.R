library(dplyr)
library(ggplot2)

#reading the data form the files -----------------------------------------------
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#extracting the total sums for each year of each type---------------------------
Baltimore <- NEI %>%
        filter(fips == "24510") %>%
        group_by(type, year) %>%
        summarise(Emissions = sum(Emissions))

#creating the png file for plot1------------------------------------------------
png(filename = "plot3.png", width = 480, height = 480, units = "px")

#plotting the data
ggplot(Baltimore, aes(year, Emissions, group = type, color = type)) +
        geom_line() +
        theme_bw()

dev.off()