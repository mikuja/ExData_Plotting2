library(data.table)
library(ggplot2)
library(dplyr) 

# Read files from working directory to memory

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# The Question is:
# 4. Across the United States, how have emissions from coal combustion-related sources changed
# from 1999-2008?

# Change the SCC column to contain the Short.Names
# read sources and create mapping table from the sources
SCC_mapping <- tbl_dt(SCC[, c("SCC", "Short.Name")])
SCC_mapping <- setNames(SCC_mapping, c("id", "source"))
SCC_mapping <- setkey(SCC_mapping, id)
# Transform data to use descriptive source names  
data <- transform(NEI, SCC = SCC_mapping[SCC]$source, check.names = FALSE)

# Select all the SCC's which start with the string "Coal" to choose 
# coal combustion-related sources 
coalData <- data[grep("^Coal", data$SCC), ]

# Calculate emission sum by year
DT <- data.table(coalData)
sumByYear <- DT[, sum(Emissions), by = year]

# Draw the plot: PM2.5 Emissions from coal combustion-related sources 1999-2008 in US
plot <- qplot(x=year, y=V1, data=sumByYear, ylab="Total emissions", xlab="Year", 
              main="PM2.5 Emissions from coal combustion-related sources during years 1999-2008 in US", 
              geom=c("point", "smooth"), method="lm")

ggsave("plot4.png", plot, width=9, dpi=100)
