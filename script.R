library(readr)
library(RMySQL)
library(DBI)

nome_da_conexao <- dbConnect(MySQL(),
                               dbname="***",
                               host="***",
                               user="***",
                               password= "***",
                               port = ***
)

for(i in 1:10) {

url <- "url do download automatico do seu arquivo"
destfile <- "diretório do arquivo será baixado"
download.file(url, destfile1)
tabela <- read.csv("diretório do arquivo", sep=",", header=TRUE, encoding="utf-8")
tabela["id"] <- tibble::rowid_to_column(tabela, "id") # Criando coluna com id

n_row <- nrow(tabela) 

tuplas.values <- c('')

for(i in 1:n_row) {

tuplas.values <- paste( tuplas.values,
                 "('",trimws(tabela[i,1]),"'",
                 ",", tabela[i,2],",",
                 "'", trimws(tabela[i,3]),"'",
                 ",","'", trimws(tabela[i,4]),"'",
                 ",","'", trimws(tabela[i,5]),"'",
                 ",", tabela[i,6],
                 ",", tabela[i,7],"),",
                sep='')
}

query <- paste("INSERT IGNORE INTO tabela VALUES", substring(tuplas.values,1, nchar(tuplas.values)-1))

dbGetQuery(nome_da_conexao, query)

Sys.sleep(3600)
}
