# install.packages("RCurl")
# install.packages("XML")
library(RCurl)
library(XML)
# by 分類爬梳
html = getURL(url = "http://data.taipei/opendata/datalist/listDataset")
xml = htmlParse(html)
# category name
XpathCatName = "//ul[@id='categoryList' and @class='unstyled nav nav-simple nav-facet']/li[@class='nav-item']/a/span/text()"
allCatName <- unlist(xpathApply(xml, XpathCatName, xmlValue))
# category href
Xpath = "//ul[@id='categoryList' and @class='unstyled nav nav-simple nav-facet']/li[@class='nav-item']/a/@href"
allCat = xml[Xpath]
# get all data belong each category 
ridByCategory <- list()
for (i in 1:length(allCat)){
  print(i/length(allCat))
  categoty <- strsplit(as.character(allCat[i]), "oid=")[[1]][2]
  CatUrl <- paste("http://data.taipei/opendata/datalist/datasetByCategory?oid=", categoty, sep = "")
  htmlCatPage <- getURI(url = CatUrl)
  xmlCat = htmlParse(htmlCatPage)
  XpathCat = "//h3[@class='dataset-heading']/a/@href"
  hrefCat = xmlCat[XpathCat]
  XpathCatDataName = "//h3[@class='dataset-heading']/a/text()"
  hrefCatDataName = unlist(xpathApply(xmlCat, XpathCatDataName, xmlValue))
  #
  if (length(hrefCat) != 0){
    RID <- 0
    for (j in 1:length(hrefCat)){
      id <- strsplit(as.character(hrefCat[j]), "oid=")[[1]][2]
      dataUrl <- paste("http://data.taipei/opendata/datalist/datasetMeta?oid=", id, sep = "")
      htmlData <- getURI(url = dataUrl) 
      xmlDat = htmlParse(htmlData)
      XpathData = "//li[@class='resource-item']/a/@href"
      hrefData = xmlDat[XpathData]
      rid <- strsplit(as.character(hrefData), "rid=")[[1]][2]
      RID[j] <- rid
    }
    outtab <- matrix(c(hrefCatDataName, RID), ncol = 2)
  }else{
    outtab <- matrix(0, ncol = 2)
  }
  colnames(outtab) <- c(allCatName[i], "rid")
  ridByCategory[[i]] <- outtab
}

names(ridByCategory) <- allCatName

########
########
########
## by report from website
report <- read.csv("C:\\Users\\David79.Tseng\\Dropbox\\HomeOffice\\report.csv")
allURL <- as.character(report[, 13])
allName <- as.character(report[, 9])
allCategory <- as.character(report[, 3])
ridMapping <- matrix(0, ncol = 3, nrow = length(allURL))
for (u in 1:length(allURL)){
  print(u/length(allURL))
  htmlBy = getURL(url = allURL[u])
  xmlBy <- htmlParse(htmlBy)
  XpathBy <- "//li[@class='resource-item']/a/@href"
  hrefBy = xmlBy[XpathBy]
  if (is.null(hrefBy)){
    rid <- NA
  }else{
    rid <- strsplit(as.character(hrefBy), "rid=")[[1]][2]
  }
  #
  #   XpathByDataName = "//li[@class='active']/a[@class=' active']"
  #   hrefByDataName = unlist(xpathApply(xmlBy, XpathByDataName, xmlValue))
  ridMapping[u, ] <- c(allName[u], allCategory[u], rid)
}



###
# html = getURL(url = "http://data.taipei/opendata/datalist/listDataset")
# xml = htmlParse(html)
# Xpath = "//h3[@class='dataset-heading']/a/@href"
# allData = xml[Xpath]
# XpathName = "//h3[@class='dataset-heading']/a/text()"
# allDataName <- unlist(xpathApply(xml, XpathName, xmlValue))
# 
# #
# RID <- 0
# for (i in 1:length(allData)){
#   print(i)
#   id <- strsplit(as.character(allData[i]), "oid=")[[1]][2]
#   urlID <- paste("http://data.taipei/opendata/datalist/datasetMeta?oid=", id, sep = "")
#   htmlDataPage <- getURI(url = urlID)
#   xmlData = htmlParse(htmlDataPage)
#   XpathData = "//li[@class='resource-item']/a/@href"
#   href = xmlData[XpathData]
#   rid <- strsplit(as.character(href), "rid=")[[1]][2]
#   RID[i] <- rid
# }
# 
# class(allDataName[[2]])





