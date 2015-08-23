url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

if (!file.exists("data")) {dir.create("./data")}
housing_file = "./data/restaurants.csv"
download.file(url, destfile = housing_file, method = "curl")

housing_data = read.csv(housing_file)
str(housing_data)

# 1
agricultureLogical = housing_data$ACR == 3 & housing_data$AGS == 6
rownames(housing_data[which(agricultureLogical), ])[1:3]

# 2
library(jpeg)
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
img_file = "./data/jeff.jpg"
download.file(url, destfile = img_file, method = "curl")

img = readJPEG(img_file, native = TRUE)
quantile(img, c(.30, .80))


# 3
gdp_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
edu_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

gdp_file = "./data/gdp.csv"
download.file(gdp_url, destfile = gdp_file, method = "curl")

edu_file = "./data/edu.csv"
download.file(edu_url, destfile = edu_file, method = "curl")

gdp_data = read.csv(gdp_file, skip = 5, header = FALSE)[,c(1,2,4,5)] 
names(gdp_data) = c("CountryCode", "Ranking", "Economy","GDP")
gdp_data = transform(gdp_data, c(Ranking = as.numeric(as.character(Ranking)), GDP = as.numeric(as.character(GDP)))) 
gdp_data = gdp_data[which(!is.na(gdp_data$Ranking)),]

edu_data = read.csv(edu_file)

merged_data = merge(edu_data, gdp_data, by = "CountryCode") %>% 
              arrange(desc(Ranking)) %>%
              transform(GDP = as.numeric(as.character(GDP)))

#3
str(merged_data)
merged_data[13, c("CountryCode", "Ranking", "Economy", "GDP")]

#4
merged_data %>% group_by(Income.Group) %>% summarise(mean(Ranking))

#5
merged_data = transform(merged_data, 
                        ranking_breaks = cut(merged_data$Ranking, 
                                             breaks=c(quantile(merged_data$Ranking, probs = seq(0, 1, by = 0.20))), 
                                             labels=c("0-20","20-40","40-60","60-80","80-100"), include.lowest=TRUE))

table(md$ranking_breaks, md$Income.Group)
