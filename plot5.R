library(data.table)
library(ggplot2)
library(dplyr) 

# Read files from working directory to memory

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# The Question is:
# 5. How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

# Select only baltimore data
baltimore <- subset(NEI, fips=="24510")

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
sumByYear <- DT[, sum(Emissions), by = year]

# Draw the plot: PM2.5 Emissions from motor vehicle sources 1999-2008 in Baltimore City
plot <- qplot(x=year, y=V1, data=sumByYear, ylab="Total emissions", xlab="Year", 
              main="PM2.5 Emissions from motor vehicle sources 1999-2008 in Baltimore City", 
              geom=c("point", "smooth"), method="lm")

ggsave("plot5.png", plot, width=9, dpi=100)

