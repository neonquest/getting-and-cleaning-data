# 1 Github
library(httr)
library(httpuv)

appname = "github"
key = "58755f8b0120ec2d00bf"
secret = "e736a445241203e99ddbf7ae815d993518495a62"

myapp = oauth_app(appname, key, secret)

Sys.setenv(HTTR_LOCALHOST = "0.0.0.0", HTTR_SERVER = "hidenseek.cloudapp.net")
github_token = oauth2.0_token(oauth_endpoints("github"), myapp)

github_token$credentials

# 2
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
data_file = "sqltest.csv"
download.file(url, destfile = data_file, method = "curl")

library(data.table)
acs = fread(data_file)

library(RMySQL)
library(sqldf)
sqldf("select distinct AGEP from acs;", drv="SQLite")


# 4
url = "http://biostat.jhsph.edu/~jleek/contact.html"
t = readLines(url)
head(t)
t[10]
sapply(c(10, 20, 30, 100), function(x) {nchar(t[x])})

# 5
url_for = "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
file = "testfile.for"
download.file(url_for, destfile = file, method="curl")

df_for <- read.fwf(file, skip=4,
                 widths=c(27,5,30))

sum(df_for[,2])
