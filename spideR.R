# install.packages("RCurl")
# install.packages("XML")
library(RCurl)
library(XML)
library(jsonlite)
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
report <- read.csv("report.csv")
allURL <- as.character(report[, 13])
allName <- as.character(report[, 9])
allCategory <- as.character(report[, 3]); uniCat <- unique(allCategory)
ridByCat2 <- lapply(1:length(uniCat), function(u){
  belong <- which(allCategory == uniCat[u])
  urlBelong <- allURL[belong]
  RID <- sapply(1:length(belong), function(b){
    htmlBy = getURL(url = urlBelong[b])
    xmlBy <- htmlParse(htmlBy)
    XpathBy <- "//li[@class='resource-item']/a/@href"
    hrefBy = xmlBy[XpathBy]
    if (is.null(hrefBy)){
      rid <- NA
    }else{
      rid <- strsplit(as.character(hrefBy), "rid=")[[1]][2]
    }
    return(rid)
  })
  outMat <- matrix(c(rep(uniCat[u], length(RID)), allName[belong], RID), ncol = 3)
  colnames(outMat) <- c("category", "dataName", "rid")
  return(outMat)
})

allCateMat <- do.call(rbind, ridByCat2)
colnames(allCateMat) <- c("category", "dataName", "rid")
allCateFrame <- as.data.frame(allCateMat)
save(allCateFrame, file = "allCateFrame.RData")
#### FDA hot data (20 datasets)
fdaURL <- "http://data.fda.gov.tw/frontsite/data/DataAction.do?method=doList&groupType=rank&id=null&sort=null&rowCount=20"
fdahtml = getURL(url = fdaURL)
fdaxml <- htmlParse(fdahtml)
Xpath = "//div[@class='dataset_div']/h3/a/@href"
fdahref = fdaxml[Xpath]

hotFdaUrl <- paste("http://data.fda.gov.tw/", as.character(fdahref), sep = "")
fdaHotMat <- matrix(0, ncol = 2, nrow = length(hotFdaUrl))
for (f in 1:length(hotFdaUrl)){
  print(f)
  urlHot <- hotFdaUrl[f]
  hothtml <- getURL(url = urlHot)
  hotxml <- htmlParse(hothtml)
  Xpath = "//div[@class='format-box']/ul/li[@class='json']/a/@href"
  hothref = hotxml[Xpath]
  id <- strsplit(as.character(hothref), "\\InfoId=|\\&logType=")[[1]][2:3]
  jsonURL <- paste("http://data.fda.gov.tw/cacheData/", id[1], "_", id[2], ".json", sep = "")
  #
  Xpath = "//div[@class='datascont_mobile']/h2/text()"
  hotName = hotxml[Xpath]
  name <- sapply(hotName, xmlValue)
  fdaHotMat[f, ] <- c(name, jsonURL)
}
fdaHotMat

# ridMapping <- matrix(0, ncol = 3, nrow = length(allURL))
# for (u in 1:length(allURL)){
#   print(u/length(allURL))
#   htmlBy = getURL(url = allURL[u])
#   xmlBy <- htmlParse(htmlBy)
#   XpathBy <- "//li[@class='resource-item']/a/@href"
#   hrefBy = xmlBy[XpathBy]
#   if (is.null(hrefBy)){
#     rid <- NA
#   }else{
#     rid <- strsplit(as.character(hrefBy), "rid=")[[1]][2]
#   }
#   #
#   #   XpathByDataName = "//li[@class='active']/a[@class=' active']"
#   #   hrefByDataName = unlist(xpathApply(xmlBy, XpathByDataName, xmlValue))
#   ridMapping[u, ] <- c(allName[u], allCategory[u], rid)
# }

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