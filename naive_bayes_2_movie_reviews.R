#Creating the training data set
library(plyr)
library(stringr)
posText <- read.delim(file='C:/Users/hp/Documents/rt-polaritydata/rt-polarity-pos.pos', header=FALSE, stringsAsFactors=FALSE)
posText <- posText$V1
posText <- unlist(lapply(posText, function(x) { str_split(x, "\n") }))

negText <- read.delim(file='C:/Users/hp/Documents/rt-polaritydata/rt-polarity-neg.neg', header=FALSE, stringsAsFactors=FALSE)
negText <- negText$V1
negText <- unlist(lapply(negText, function(x) { str_split(x, "\n") }))    

#Converting it to data frame for simplicity
posdf = as.data.frame(posText)
posdf$sentiment = "positive"

negdf = as.data.frame(negText)
negdf$sentiment = "negative"

library(RTextTools) #contains create_matrix()
library(e1071)

#sample contains the textual part of the extracted tweets.
#See related programs for details
sample_df = as.data.frame(sample)

#Randomly a sentiment is assigned since this serves no purpose in the final result
sample_df$sentiment = "positive"

#tweets = rbind(posdf, negdf, sample_df)

negdf = negdf[1:2000,]
posdf = posdf[1:2000,]
#All data frames are brought to same size(no. of rows)
#negdf = negdf[1:nrow(sample_df),]
#posdf = posdf[1:nrow(sample_df),]

#All the column names are made same to append data frames later on
names(negdf)=c("Text","sentiment")
names(posdf)=c("Text","sentiment")
names(sample_df)=c("Text","sentiment")
combined <- rbind.fill(posdf[c("Text","sentiment")], negdf[c("Text","sentiment")])
tweets <- rbind.fill(combined[c("Text","sentiment")], sample_df[c("Text","sentiment")])

#tweets = rbind(posdf, negdf, sample_df)
matrix = create_matrix(tweets[,1], language = "english", removeStopwords=FALSE, removeNumbers=TRUE, stemWords=FALSE) 

mat = as.matrix(matrix)
#train_dataset_len = 2*nrow(sample_df)
train_dataset_len = nrow(posdf) + nrow(negdf)
classifier = naiveBayes(mat[1:train_dataset_len,], as.factor(tweets[1:train_dataset_len,2]))
#predicted = predict(classifier, mat[train_dataset_len+1:train_dataset_len+nrow(sample_df),]); predicted
predicted = predict(classifier, mat[4001:4500,]); predicted


#following is just for testing purposes(maybe ignored)
table(tweets[train_dataset_len+1:train_dataset_len+nrow(sample_df),2], predicted)
recall_accuracy(tweets[train_dataset_len+1:train_dataset_len+nrow(sample_df)],2], predicted)

