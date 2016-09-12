df <- do.call("rbind", lapply(junglebook.tweets, as.data.frame))
#remove emoticons
df$text <- sapply(df$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
#remove URLs
df$text = gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", df$text)
sample <- df$text
