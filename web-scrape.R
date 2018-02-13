#install package rvest
install.packages("rvest")

#load the librarys
library(rvest)
library(RCurl)
library(XML)
library(magrittr)

#extracting links to american film acresses
url<-"https://en.wikipedia.org/wiki/List_of_American_film_actresses"
url2<-getURL(url)
parsed<-htmlParse(url2)
links<-xpathSApply(parsed,path = "//a",xmlGetAttr,"href")

df <- as.data.frame(matrix(unlist(links), nrow=2011, byrow=T),stringsAsFactors=FALSE)
string <- as.character(df$V1)
df <- as.data.frame(paste0("https://en.wikipedia.org", string))
colnames(df) <- "list"

df <- read.csv("D:/Ongair/tal/Wikipedia/actresses.csv")

#create empty data frame
data <- as.data.frame(matrix(ncol=1))

#define column names
cols <-c('actresses')

#assign column names
colnames(data) <-c(cols)

for(i in 1:nrow(df)) {
  row <- as.character(df[i,])
  
#Specifying the url for desired website to be scrapped
url <- row

#Reading the HTML code from the website
webpage <- read_html(url)

#Using CSS selectors to scrap the rankings section
actress_data_html <- html_nodes(webpage,'.fn')

#Converting the ranking data to text
actress_data <- as.data.frame(html_text(actress_data_html))
colnames(actress_data) <- "actresses"

#mapping
data$link[i] = df$list

data <- rbind(data,actress_data)
print(i)

}

#scraping a table from a
head(rank_data)

webpage <- read_html("https://en.wikipedia.org/wiki/Brooke_Adams_(actress)")
results <- webpage %>% html_nodes("table.vcard")
results

table <- webpage %>%
  html_nodes("table.vcard") %>%
  html_table(header=T)

# You can clean up the table with the following code, or something like it. 
# table[[1]]
dict <- as.data.frame(table)
accounts_df <- table[[1]][1:6,-1]

names <- c('name', 'desc')
colnames(accounts_df) <- names

accounts_df #%>% str()