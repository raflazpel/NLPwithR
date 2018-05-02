#Now we are going to create a exploratory "small" sample, first we read the whole file:

blog <- readLines("Coursera-SwiftKey/en_US/en_US.blogs.txt",skipNul = TRUE, warn = TRUE)
news <- readLines("Coursera-SwiftKey/en_US/en_US.news.txt",skipNul = TRUE, warn = TRUE)
twitter <- readLines("Coursera-SwiftKey/en_US/en_US.twitter.txt",skipNul = TRUE, warn = TRUE)

#load libraries:
library(ggplot2)
library(NLP)
library(tm)
library(RWeka)
library(data.table)
library(dplyr)

#Set the random seed for reproducibility:
set.seed(100)


#Selection of the size of the sample:
sampleSize = 1000
sample_blog <- blog[sample(1:length(blog),sampleSize)]
sample_news <- news[sample(1:length(news),sampleSize)]
sample_twitter <- twitter[sample(1:length(twitter),sampleSize)]
sample_data<-rbind(sample_blog,sample_news,sample_twitter)

#Removal of useless variables:
rm(blog,news,twitter)

#Editing of the corpus:
mycorpus<-VCorpus(VectorSource(sample_data))
mycorpus <- tm_map(mycorpus, content_transformer(tolower)) # convert to lowercase
mycorpus <- tm_map(mycorpus, removePunctuation) # remove punctuation
mycorpus <- tm_map(mycorpus, removeNumbers) # remove numbers
mycorpus <- tm_map(mycorpus, stripWhitespace) # remove multiple whitespace
changetospace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
mycorpus <- tm_map(mycorpus, changetospace, "/|@|\\|")

#Definition of tokenizing functions:
uniGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
biGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
triGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
fourGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
OneT <- NGramTokenizer(mycorpus, Weka_control(min = 1, max = 1))
oneGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = uniGramTokenizer))
twoGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = biGramTokenizer))
threeGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = triGramTokenizer))
fourGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = fourGramTokenizer))

#Creation of frequency lists: (Sin ordenar por numero de apariciones)
freqTerms1 <- findFreqTerms(oneGM, lowfreq = 5)
termFreq1 <- rowSums(as.matrix(oneGM[freqTerms1,]))
termFreq1 <- data.frame(unigram=names(termFreq1), frequency=termFreq1)
termFreq1 <- termFreq1[order(-termFreq1$frequency),]
unigramlist <- setDT(termFreq1)
save(unigramlist,file="unigram.Rda")
freqTerms2 <- findFreqTerms(twoGM, lowfreq = 3)
termFreq2 <- rowSums(as.matrix(twoGM[freqTerms2,]))
termFreq2 <- data.frame(bigram=names(termFreq2), frequency=termFreq2)
termFreq2 <- termFreq2[order(-termFreq2$frequency),]
bigramlist <- setDT(termFreq2)
save(bigramlist,file="bigram.Rda")
freqTerms3 <- findFreqTerms(threeGM, lowfreq = 2)
termFreq3 <- rowSums(as.matrix(threeGM[freqTerms3,]))
termFreq3 <- data.frame(trigram=names(termFreq3), frequency=termFreq3)
trigramlist <- setDT(termFreq3)
save(trigramlist,file="trigram.Rda")
freqTerms4 <- findFreqTerms(fourGM, lowfreq = 1)
termFreq4 <- rowSums(as.matrix(fourGM[freqTerms4,]))
termFreq4 <- data.frame(fourgram=names(termFreq4), frequency=termFreq4)
fourgramlist <- setDT(termFreq4)
save(fourgramlist,file="fourgram.Rda")
