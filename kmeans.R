datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=","51839ac9-6454-49f2-aaf2-abd05c5405c8","&format=csv",sep="")
data = read.csv(url(paste(datapath)))
head(data)
