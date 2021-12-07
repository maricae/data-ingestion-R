library(readr)
library(RMySQL)
library(DBI)

braip_homologacao <- dbConnect(MySQL(),
                               dbname="tabelas_alternativas",
                               host="44.193.3.160",
                               user="braip_homologacao",
                               password= "v4aC0Sji$u9m",
                               port = 3306
)

for(i in 1:10) {

url1 <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vQFxvwnIEHlyLjp2oaSJ_PD1HeqpefS_T-ulcj01DkAJclJHTCOSshXbaXZVd1tCsuDICqhy133vrT4/pub?gid=0&single=true&output=csv"
destfile1 <- "C:/Users/maric/Desktop/R/suporte.csv"
download.file(url1, destfile1)
suporte1 <- read.csv("C:/Users/maric/Desktop/R/suporte.csv", sep=",", header=FALSE, encoding="utf-8")
colnames(suporte1) <- c("motivo", "ticket", "data", "venda_chave", "produto_chave")
suporte1$motivo[suporte1$motivo == "ReclamaÃ§Ã£o"] <- "Reclamações"
suporte <- suporte1[!(suporte1$motivo == ""),]
suporte["fonte"] <- rep(1, nrow(suporte))

url2 <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vQFxvwnIEHlyLjp2oaSJ_PD1HeqpefS_T-ulcj01DkAJclJHTCOSshXbaXZVd1tCsuDICqhy133vrT4/pub?gid=814209284&single=true&output=csv"
destfile2 <- "C:/Users/maric/Desktop/R/reclameaqui.csv"
download.file(url2, destfile2)
reclameaqui1 <- read.csv("C:/Users/maric/Desktop/R/reclameaqui.csv", sep=",", header=TRUE, encoding="utf-8")
colnames(reclameaqui1) <- c("motivo", "ticket", "data", "venda_chave", "produto_chave")
reclameaqui1$motivo[reclameaqui1$motivo == "ReclamaÃ§Ã£o"] <- "Reclamação"
reclameaqui <- reclameaqui1[!(reclameaqui1$motivo == ""),]
reclameaqui["fonte"] <- rep(2, nrow(reclameaqui))

reclamacoes <- rbind(suporte, reclameaqui)
reclamacoes["data"] <- as.Date(reclamacoes$data,format="%d/%m/%Y")
reclamacoes["id"] <- tibble::rowid_to_column(reclamacoes, "id")


n_row <- nrow(reclamacoes) 
n_row

tuplas.values <- c('')

for(i in 1:n_row) {
tuplas.values <- paste( tuplas.values,
                 "('",trimws(reclamacoes[i,1]),"'",
                 ",", reclamacoes[i,2],",",
                 "'", trimws(reclamacoes[i,3]),"'",
                 ",","'", trimws(reclamacoes[i,4]),"'",
                 ",","'", trimws(reclamacoes[i,5]),"'",
                 ",", reclamacoes[i,6],
                 ",", reclamacoes[i,7],"),",
                sep='')
}

query <- paste("INSERT IGNORE INTO reclamacoes VALUES", substring(tuplas.values,1, nchar(tuplas.values)-1))
dbGetQuery(braip_homologacao, query)

Sys.sleep(3600)
}
