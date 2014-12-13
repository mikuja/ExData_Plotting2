library(data.table)
library(ggplot2)
library(dplyr) 

# Read files from working directory to memory

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# The Question is:
# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
# vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# Select only Baltimore City and Los angeles county data
baltimore <- subset(NEI, fips=="24510" | fips=="06037")

# Change the SCC column to contain the Short.Names
# read sources and create mapping table from the sources
SCC_mapping <- tbl_dt(SCC[, c("SCC", "Short.Name")])
SCC_mapping <- setNames(SCC_mapping, c("id", "source"))
SCC_mapping <- setkey(SCC_mapping, id)
# Transform data to use descriptive source names  
baltimore <- transform(baltimore, SCC = SCC_mapping[SCC]$source, check.names = FALSE)

# Select all the SCC's which contain the string "Motor" to choose motor vehicle sources
baltimoreMotors <- baltimore[grep("Motor", baltimore$SCC), ]

# Calculate emission sum by year
DT <- data.table(baltimoreMotors)
sumByYearAndCity <- DT[, sum(Emissions), by = list(year, fips)]

# Draw the plot: PM2.5 Emissions from motor vehicle sources 1999-2008 in Baltimore City
plot <- ggplot(data=sumByYearAndCity, aes(x=year, y=V1, group=fips, colour=fips)) + 
  #geom_line() + 
  geom_point() + 
  scale_colour_discrete(name="Areas", breaks=c("06037", "24510"), labels=c("Los Angeles County", "Baltimore City")) + 
  ylab("Total emissions") + 
  xlab("Year") + 
  ggtitle("PM2.5 Emissions from motor vehicle sources 1999-2008 in Baltimore City and Los Angeles County")

# Add a linear model to the plot
plot <- plot + geom_smooth(method="lm")

# Save the plot on the working directory
ggsave("plot6.png", plot, width=11, dpi=100)
