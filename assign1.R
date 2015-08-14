
if (!file.exists("data")) {
    dir.create("data")
}

setwd("data")

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
data_file = "housing_survey_2006.csv"
download.file(url, destfile = data_file, method = "curl")
data <- read.csv(data_file)
nrow(data[ which(data[,"VAL"] >= 24), ])

library(xlsx)
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
x_file <- "gov_NGAP.xlsx"
download.file(url, destfile = x_file, method = "curl")
dat <- read.xlsx(x_file, 1, rowIndex = 18:23)
sum(dat$Zip*dat$Ext,na.rm=T) 

library(XML)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
xml_file <- "restaurants.xml"
download.file(url, destfile = xml_file, method = "curl")
doc <- xmlTreeParse(xml_file, useInternalNodes = TRUE)

rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

zip <- xpathSApply(rootNode, "//zipcode", function(x) {xmlValue(x) == "21231"})
length(zip[zip])


library(data.table)
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
file = "housing_survey_Idaho_2006.csv"
download.file(url, destfile = file)

DT = fread(url)



