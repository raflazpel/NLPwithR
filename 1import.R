datafolder <- "data"
url  <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
fname <- "Coursera-SwiftKey.zip"
fpath <- paste(datafolder, fname, sep="/")
if (!file.exists(fpath)){
  download.file(url, destfile=fpath, method="curl")
}
unzip(zipfile=fpath, exdir=datafolder)