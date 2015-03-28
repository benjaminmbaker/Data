# Downloading FERC AMI Data
if(!file.exists("ami.data")) {dir.create("ami.data")}
fileUrl <- "http://www.ferc.gov/industries/electric/indus-act/demand-response/2012/ami-data.xlsx"
download.file(fileUrl, destfile="./ami.data/ami-data2012.xlsx")
dateDown.2012 <- date()

fileUrl <- "http://www.ferc.gov/industries/electric/indus-act/demand-response/2010/ami-data.xlsx"
download.file(fileUrl, destfile="./ami.data/ami-data2010.xlsx")
dateDown.2010 <- date()

detach("package:xlsx", unload=TRUE)
install.packages("gdata")
library("gdata")
fileUrl <- "http://www.ferc.gov/industries/electric/indus-act/demand-response/2008/survey/ami_survey_responses.xls"
download.file(fileUrl, destfile="./ami.data/ami-data2008.xls")
dateDown.2008 <- date()

fileUrl <- "http://www.ferc.gov/industries/electric/indus-act/demand-response/2006/survey/meter-counts-by-type.xls"
download.file(fileUrl, destfile="./ami.data/ami-data2006.xls")
list.files("ami.data")
dateDown.2006 <- date()

list.files("ami.data")

#Converting and filtering Excel data from FERC databases
install.packages("xlsx")
library(xlsx)
ami.data2012 <- read.xlsx("./ami.data/ami-data2012.xlsx", sheetIndex=2,header=TRUE)
ami.data2012.OR <-data.frame()
ami.data2012.OR <- ami.data2012[ami.data2012$State == "OR", ]

ami.data2010 <- read.xlsx("./ami.data/ami-data2010.xlsx", sheetIndex=2,header=TRUE)
ami.data2010.OR <-data.frame()
ami.data2010.OR <- ami.data2010[ami.data2010$State == "OR", ]

ami.data2008 <- read.xls("./ami.data/ami-data2008.xls", sheet=1, quote="", header=TRUE)
ami.data2008.OR <-data.frame()
ami.data2008.OR <- ami.data2008[ami.data2008$State == "OR", ]

ami.data2006 <- read.xls("./ami.data/ami-data2006.xls", sheet=3, header=TRUE)
ami.data2006.OR <-data.frame()
ami.data2006.OR <- ami.data2006[ami.data2006$State == "OR", ]

# Unifying column names and dropping unused variables
ami.data2006.OR <- ami.data2006.OR[c(1,5,3,6,7:46)]
ami.data2008.OR <- ami.data2008.OR[c(1:2,48,3,14:25)]
colnames(ami.data2008.OR)[1] <- "UTILITY_ID"
colnames(ami.data2006.OR)[1] <- "UTILITY_ID"

# Merging datapoints for 2006 & 2008 AMI data to match 2010 & 2012
ami.data2008.OR$ResTotalNumMeters <- colSums(ami.data2008.OR[,c("Q8.15Min.ResAMI","Q8.Hourly.ResAMI")],na.rm=TRUE)
