# Ingestão de Dados com R
A ingestão de dados é o transporte de dados de diferentes fontes para um meio de armazenamento onde podem ser acessados, usados e analisados por uma organização. O destino normalmente é um data warehouse, data mart, banco de dados ou armazenamento de documentos. Neste caso, tranferi dados de uma planilha do Google Drive para um Data Warehouse no MySQL utilizando um script em R. Também acrescentei um looping para o script rodar a cada 1 hora.

### 1. Instalando os Pacotes 
Instale (caso necessário) e faça a leitura dos pacotes:
```
library(readr)
library(RMySQL)
library(DBI)
```

### 2. Crie a conexão com seu banco de dados
Neste caso, usei um script próprio pro MySQL, se estiver usando outra ferramente, pesquise qual pacote é necessário.
Insira o nome da base de dados, servidor, user, senha e porta.
```
nome_da_conexao <- dbConnect(MySQL(),
                               dbname="***",
                               host="***",
                               user="***",
                               password= "***",
                               port = ***
)
```
# 3. Baixando Dados
Com o objetivo de deixar o script rodando várias vezes, o looping é aberto na parte de fazer o download da planilha, lembrando que ela será alimentada ao longo do dia. Com isso, crie uma variável com o link direto de download e uma variável indicando qual diretório será direcionado o arquivo. Após isso, faça o download do arquivo, insira a tabela no ambiente do RStudio e acrescente uma coluna de id (caso necessário).
Obs: O looping será fechado no final deste script.
```
for(i in 1:10) {

url <- "url do download automatico do seu arquivo"
destfile <- "diretório do arquivo será baixado"
download.file(url, destfile1)
tabela <- read.csv("diretório do arquivo", sep=",", header=TRUE, encoding="utf-8")
tabela["id"] <- tibble::rowid_to_column(tabela, "id") # Criando coluna com id
```
### 4. Criando Consulta
Agora será necessário criar um insert (linguagem SQL). Para acelerar o processo de ingestão, a estrutura dos dados será feita em uma variável e depois será criada uma nova variável com a concatenação com "insert into". Além disso, essa parte também será feita em looping com o número de linhas. Lembrando que as coluna de strings devem estar entre aspas.
```
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
```
### 5. Enviando os Dados
Enviando a consulta elaborada no passo 4 para o banco de dados MySQL, utlizando o nome da conexão criada no passo 2 e a concatenação feita no passo a cima.
```
dbGetQuery(nome_da_conexao, query)
```
### 6. Limitando Looping
Colocando os dados para atualizar a cada 3600 segundos e finalizando fechando o primeiro *for*
```
Sys.sleep(3600)
}
```
