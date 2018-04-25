#Now we are going to create a exploratory "small" sample

# load data
load("blogs.RData")
load("news.RData")
load("twitter.RData")

# sample data (100,000 of each)
sample_blogs   <- sample(blogs, 3000)
sample_news    <- sample(news, 3000)
sample_twitter <- sample(twitter, 3000)

#Join all 3 samples in one
sample<-rbind(sample_blogs,sample_news,sample_twitter)

#remove obsolete variables
rm(blogs,news,twitter)

#The package tm is really powerful:  VectorSource creates a text source from the sample and VCorpus (Volatile Corpus because it will dissapear) 
# creates a corpus where each element of the previous matrix is considered a document.
mycorpus<-VCorpus(VectorSource(sample))
mycorpus <- tm_map(mycorpus, content_transformer(tolower))
mycorpus <- tm_map(mycorpus, removePunctuation) # remove punctuation
mycorpus <- tm_map(mycorpus, removeNumbers)
mycorpus <- tm_map(mycorpus, stripWhitespace)
changetospace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
mycorpus <- tm_map(mycorpus, changetospace, "/|@|\\|")
# save samples
save(sample, file= "sampleData.RData")
