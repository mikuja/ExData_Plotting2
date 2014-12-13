library(data.table)

# Read files from workind directory to memory
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# Question is:
# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# Select only baltimore values
baltimore <- subset(NEI, fips=="24510")

#Calculate yearly sum in the Baltimore city.
DT <- data.table(baltimore)
DT <- DT[, sum(Emissions), by = year]

# Draw values to a plot
png(filename="plot2.png", width=480, height=480)

with(DT, plot(year, V1, xlab="Year", ylab="Total Emissions", main="Sum of the PM2.5 emissions per year in Baltimore"))
# Add a linear model line to the plot
model <- lm(V1 ~ year, DT)
abline(model, lwd=2) 

dev.off()
