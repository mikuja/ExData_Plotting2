library(data.table)

# Read files from workind directory to memory
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# Question is:
# 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission 
# from all sources for each of the years 1999, 2002, 2005, and 2008.

# Calculate yearly sum of the emissions
DT <- data.table(NEI)
DT <- DT[, sum(Emissions), by = year]

# Draw values to a plot
png(filename="plot1.png", width=480, height=480)
with(DT, plot(year, V1, xlab="Year", ylab="Total Emissions", main="Sum of the PM2.5 emissions in US per year"))
# Add a linear model line to the plot
model <- lm(V1 ~ year, DT)
abline(model, lwd=2) 

dev.off()
