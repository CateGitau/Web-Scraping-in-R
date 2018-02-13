#install package rvest
install.packages("rvest")

#load the libraries
library(rvest)
library(RCurl)
library(XML)
library(magrittr)
library(dplyr)

#extracting links to american film acresses
url<-"https://en.wikipedia.org/wiki/List_of_American_film_actresses"
url2<-getURL(url)
parsed<-htmlParse(url2)
links<-xpathSApply(parsed,path = "//a",xmlGetAttr,"href")

df <- as.data.frame(matrix(unlist(links), nrow=2011, byrow=T),stringsAsFactors=FALSE)
string <- as.character(df$V1)
df <- as.data.frame(paste0("https://en.wikipedia.org", string))
colnames(df) <- "list"

#create empty data frame
data <- as.data.frame(matrix(ncol=1))

#define column names
cols <-c('topic')

#assign column names
colnames(data) <-c(cols)

# df <- read.csv("D:/Ongair/tal/Wikipedia/actresses.csv")

for(i in 1:nrow(df)) {
  tryCatch({
  row <- as.character(df[i,])
  
  webpage <- read_html("https://en.wikipedia.org/wiki/Brooke_Adams_(actress)")
  results <- webpage %>% html_nodes("table.vcard") %>% html_table(trim = TRUE) %>% ifelse(. == "", NA, .)
  
  if (is.logical(results) && length(results) == 0) next
  
  #  a <- bind_rows(lapply(xml_attrs(results), function(x) data.frame(as.list(x), stringsAsFactors=FALSE)))
  # 
  # if(!is.data.frame(a) || !nrow(a)) next
  
  table <- webpage %>%
    html_nodes("table.vcard") %>%
    html_table(header=F)
  table <- table[[1]]
  
  # You can clean up the table with the following code, or something like it. 
  # table[[1]]
  dict <- as.data.frame(table)
  dict[1, 1] <- NA
  
  if(dict[3,1]=="Born"){
    dict <- dict[-c(2), ]
  }
  
  colnames(dict) <- c("topic",dict[1,2])
  
  data <- merge(data, dict, by="topic", all = T)
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  
  
  print(i)
  
}
