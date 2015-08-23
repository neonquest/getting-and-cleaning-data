set.seed(13435)

X = data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
X = X[sample(1:5), ]; X$var2[c(1,3)] = "NA"

X[1:2, "var2"]

X[(X$var1 > 2 & X$var2 < 9),]
sort(X$var1)
X[order(X$var1),]

library(plyr)
arrange(X, desc(var3))

X$var4 = rnorm(5)
X

# cbind
# rbind

url = "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
if (!file.exists("data")) {dir.create("./data")}
restaurants_file = "./data/restaurants.csv"
#download.file(url, destfile = restaurants_file, method = "curl")

library(RCurl)
data = getURL(url, ssl.verifypeer = FALSE)
restData <- read.csv(textConnection(data))

head(restData, n=4)
summary(restData)

quantile(restData$councilDistrict, na.rm = TRUE)

table(restData$councilDistrict, restData$zipCode)
any(is.na(restData$councilDistrict))
all(restData$zipCode > 0)

table(restData$zipCode %in% c(21224, 21225) )


data("UCBAdmissions")
df = as.data.frame(UCBAdmissions)
str(df)

xt = xtabs(Freq ~ Gender + Admit, data = df)
xt

xt = xtabs(Freq ~ ., data = df)
xt
ftable(xt)

object.size(xt)

s1 = seq(1, 10, by=2)
s1

s2 = seq(1, 10, length = 3); s2

d = c(1,23,45,57); s3 = seq(along = d); s3

head(restData)

restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)

restData$zipWrong = ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong, restData$nearMe)

restData$zipGroups = cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroups)

table(restData$zipGroups, restData$zipCode)

restData$zcf = factor(restData$zipCode)
restData$zcf[1:10]

library(Hmisc); library(plyr);
restData2 = mutate(restData, zipGroups = cut2(restData$zipCode, g = 4))
table(restData2$zipGroups)


library(reshape2)
head(mtcars)


mtcars$carname = rownames(mtcars)
carMelt = melt(mtcars, id = c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp"))
head(carMelt, n=3)

summary(carMelt)

cylData = dcast(carMelt, cyl ~ variable, mean)
cylData

head(InsectSprays)

tapply(InsectSprays$count, InsectSprays$spray, sum)

library(plyr)
ddply(InsectSprays, .(spray), summarise, sum = sum(count))
spraySums = ddply(InsectSprays, .(spray), summarise, sum = ave(count, FUN=sum)); 
dim(spraySums)

library(dplyr)
url = "https://raw.githubusercontent.com/DataScienceSpecialization/courses/master/03_GettingData/dplyr/chicago.rds"
chicago_data = "./data/chicago.rds"
download.file(url, destfile = chicago_data, method = "curl")

chicago = readRDS(chicago_data)
dim(chicago)

head(select(chicago, -(city:dptp)))

chicago.f = filter(chicago, pm25tmean2 > 30 & tmpd > 80); head(chicago.f)
chicago = arrange(chicago, desc(date))
chicago = rename(chicago, pm2.5 = pm25tmean2, dewpoint = dptp)
names(chicago)

chicago = mutate(chicago, tempcat = factor(1 * (tmpd > 80), labels = c("cold", "hot")))
hotcold = group_by(chicago, tempcat); names(hotcold)
summarise(hotcold, pm25 = mean(pm2.5, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

chicago = mutate(chicago, year2 = as.POSIXlt(date)$year + 1900)
years = group_by(chicago, year)
summarise(years, pm25 = mean(pm2.5, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarise(pm25 = mean(pm2.5, na.rm = TRUE), o3 = max(o3tmean2))

# TODO: Fails with "Error: invalid subscript type 'double'"
chicago %>% mutate(year = as.POSIXlt(date)$year + 1900) %>% group_by(year) %>% summarise(pm25 = mean(pm2.5, na.rm = TRUE), o3 = max(o3tmean2))

reviews_file = "./data/reviews.csv"
solutions_file = "./data/solutions.csv"
if (!file.exists("./data")) {dir.create("./data")}
url1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
url2 = "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(url1, destfile = reviews_file, method = "curl")
download.file(url2, destfile = solutions_file, method = "curl")

reviews = read.csv(reviews_file); solutions = read.csv(solutions_file);

intersect(names(reviews), names(solutions))

mergedData = merge(reviews, solutions, by.x = "solution_id", by.y = "id", all = TRUE)
head(mergedData)

df1 = data.frame(id = sample(1:10), x = rnorm(10))
df2 = data.frame(id = sample(1:10), y = rnorm(10))
df3 = data.frame(id = sample(1:10), z = rnorm(10))
df_all = list(df1, df2, df3)
arrange(join_all(df_all), id)



#Read test data
test_subject = read.table(paste(topdir, "test/subject_test.txt", sep = ""))
test_X = read.table(paste(topdir, "test/X_test.txt", sep = ""))
test_y = read.table(paste(topdir, "test/y_test.txt", sep = ""))

dim(test_X); dim(test_y); dim(test_subject);

#Read train data
train_subject = read.table(paste(topdir, "train/subject_train.txt", sep = ""), col.names = "subject")
train_X = read.table(paste(topdir, "train/X_train.txt", sep = ""), col.names = features)
train_y = read.table(paste(topdir, "train/y_train.txt", sep = ""), col.names = "activity")

dim(train_X); dim(train_y); dim(train_subject);

# Combine subject, feature (X) & label (y) data
test_all = cbind(test_subject, test_X, test_y); dim(test_all)
names(test_all)
train_all = cbind(train_subject, train_X, train_y); dim(train_all)

# Merge the training and the test sets to create one data set.
all_data = rbind(train_all, test_all); dim(all_data)

str(names(all_data))

## str(features)
mean_std_features = filter(features, grepl('mean\\(\\)|std\\(\\)', V2, perl = TRUE)) %>% droplevels()
str(mean_std_features)
mean_std_features$V1
str(all_data)

# Extract only the measurements on the mean and standard deviation for each measurement.
mean_std_data = select(all_data, mean_std_features$V1)
