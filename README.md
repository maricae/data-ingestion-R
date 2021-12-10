# Ingestão de Dados com R
A ingestão de dados é o transporte de dados de diferentes fontes para um meio de armazenamento onde podem ser acessados, usados e analisados por uma organização. O destino normalmente é um data warehouse, data mart, banco de dados ou armazenamento de documentos. Neste caso, tranferi dados de uma planilha do Google Drive para um Data Warehouse no MySQL utilizando um script em R. Também acrescentei um looping para o script para rodar a cada 1 hora.

### 1. Instalando os Pacotes 
Instale (caso necessário) e faça a leitura dos pacotes
``library(readr)
library(RMySQL)
library(DBI)``

### 2. Crie a conexão com seu banco de dados
``
braip_homologacao <- dbConnect(MySQL(),
                               dbname="***",
                               host="***",
                               user="***",
                               password= "***",
                               port = ***
)
``
# Abrir looping

for(i in 1:10) {

url1 <- "url do download automatico do seu arquivo"
destfile1 <- "diretório do arquivo será baixado"
download.file(url1, destfile1) # baixar arquivo no diretório selecionado
tabela <- read.csv("diretório do arquivo", sep=",", header=FALSE, encoding="utf-8") # Criando variável com separador, sem cabeçalho e aplicando enconding
colnames(tabela) <- c("motivo", "ticket", "data", "venda_chave", "produto_chave") # Dando nome às colunas
tabela["id"] <- tibble::rowid_to_column(tabela, "id") # Criando coluna com id

n_row <- nrow(tabela) 
n_row

tuplas.values <- c('')

# Abrir novamente um looping, somente para a consulta
# Lembrar de colocar aspas nas colunas de strings
  
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

# Enviar o insert para o banco de dados
query <- paste("INSERT IGNORE INTO tabela VALUES", substring(tuplas.values,1, nchar(tuplas.values)-1))
dbGetQuery({dbname}, query)

Sys.sleep(3600) # Atualizar a cada 3600 segundos
}
