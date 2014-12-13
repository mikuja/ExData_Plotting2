library(data.table)
library(ggplot2)

# Read files from working directory to memory
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# Question is:
# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
# variable, which of these four sources have seen decreases in emissions from 1999-2008
# for Baltimore City? Which have seen increases in emissions from 1999-2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

# Select only baltimore values
baltimore <- subset(NEI, fips=="24510")

#Calculate yearly sum by type in the Baltimore city.
DT <- data.table(baltimore)
DT <- DT[, sum(Emissions), by = list(year, type)]

# Draw values to a plot with a linear regression
baltimore <- DT
plot <- qplot(x=year, y=V1, data=baltimore, ylab="Total emissions", xlab="Year", 
              main="PM2.5 Emissions by type from 1999-2008 in Baltimore City", 
              facets=.~type, geom=c("point", "smooth"), method="lm")

ggsave("plot3.png", plot, width=8, dpi=100)


