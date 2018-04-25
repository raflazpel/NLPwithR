library(tm)
library(RWeka)
library(dplyr)
library(magrittr)

load("sampleData.RData")

words<-strsplit("melon melon nar nar nar perro"," ")
#Calculate word frequencies
words.freq<-table(unlist(words))