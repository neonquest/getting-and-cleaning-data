install.packages('RMySQL')

library(RMySQL)

ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;");
dbDisconnect(ucscDb)

head(result)

ucsc_hg19 <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu", db="hg19")
result <- dbListTables(ucsc_hg19);
dbDisconnect(ucsc_hg19)

head(result)

table <- "affyU133Plus2"
ucsc_hg19 <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu", db="hg19")
dbListFields(ucsc_hg19, table)
dbGetQuery(ucsc_hg19, paste("select count(*) from ", table, ";", sep=""))

query <- dbSendQuery(ucsc_hg19, paste("select * from ", table, " where misMatches between 1 and 3", sep=""))
warnings()
affyMis <- fetch(query, n=10); dbClearResult(query)

dim(affyMis)
quantile(affyMis$misMatches)

dbDisconnect(ucsc_hg19)


source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")

library(rhdf5)
created = h5createFile("example.h5")
created

h5file = "example.h5"
h5createGroup(h5file, "foo")
h5createGroup(h5file, "baa")
h5createGroup(h5file, "foo/foobaa")
h5ls(h5file)


A <- matrix(1:10, nr=5, nc=2)
h5write(c(12,13,14), h5file, "foo/A", index=list(1:3, 1))
B <- array(seq(0.1, 2.0, by=0.1), dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, h5file, "foo/foobaa/B")
h5read(h5file, "foo")


# Webscraping
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)

library(XML)
url = "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html = htmlTreeParse(url, useInternalNodes = T)
xpathSApply(html, "//title", xmlValue)

xpathSApply(url, "//td[@id='col-citedBy']", xmlValue)


library(httr)
html2 = GET(url)
content2 = content(html2, as="text")
parsedHtml = htmlParse(content2, asText=TRUE)

xpathSApply(parsedHtml, "//title", xmlValue)

url2 = "http://httpbin.org/basic-auth/user/passwd"
pg1 = GET(url2, authenticate("user", "passwd"))
pg1
names(pg1)

google = handle("http://google.com")
pg2 = GET(handle=google, path="/")
pg2


#Twitter
appname = ""
key = "appkey"
secret = "appsecret"
myapp = oauth_app("HNSTweetSense", key=key, secret = secret)

token = "token"
token_secret = "token_secret"
sig = sign_oauth1.0(myapp, token = token, token_secret = token_secret)

hometl_url = "https://api.twitter.com/1.1/statuses/home_timelines.json"
homeTL = GET(hometl_url, sig)

library(jsonlite)
json1 = content(homeTL)
json2 = fromJSON(toJSON(json1))
json2
json1

