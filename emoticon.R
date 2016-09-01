df <- do.call("rbind", lapply(junglebook.tweets, as.data.frame))
df$text <- sapply(df$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
sample <- df$text
