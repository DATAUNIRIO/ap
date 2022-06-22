##------------------------------------------------------------------------------------------------------##
##    Nome: Preparação do Banco de Dados                                                                ##
##                                                                                                      ##
##    Comissão Permanente QDD UNIRIO                                                             ##
##    prof. Steven Dutt-Ross                                                                            ##
##    UNIRIO                                                                                            ##
##------------------------------------------------------------------------------------------------------##

library(readxl)
library(janitor)
library(dplyr)

# Importar das bases de dados
list.files("C:/Users/Hp/Documents/GitHub/ap/adunirio/nova_versao")

caminho <- "C:/Users/Hp/Documents/GitHub/ap/adunirio/nova_versao/"
UO_26269 <- read_excel(paste0(caminho,"unirio_26269.xlsx"))  %>% clean_names()
UO_26391 <- read_excel(paste0(caminho,"hugg_26391.xlsx")) %>% clean_names()
remove(caminho)

# Inserindo a variável Unidade Orçamentária
UO_26269$Unidade_Orcamentaria<-"UNIRIO"
UO_26391$Unidade_Orcamentaria<-"HUGG"


# Retirando GND == PESSOAL E ENCARGOS SOCIAIS
names(UO_26269)
table(UO_26269$gnd_desp)
table(UO_26269$gnd_desp,UO_26269$gnd_cod_desp)
UO_26269<- UO_26269 %>% filter(gnd_cod_desp !=1)
UO_26391<- UO_26391 %>% filter(gnd_cod_desp !=1)

# Retirando 2022
UO_26269<- UO_26269 %>% filter(ano !=2022)
UO_26391<- UO_26391 %>% filter(ano !=2022)

# Merge/Join via tidyverse
Orc_UNIRIO <- bind_rows(UO_26269, UO_26391)


# Verificando
table(Orc_UNIRIO$uo_cod_desp,Orc_UNIRIO$Unidade_Orcamentaria)

names(Orc_UNIRIO)
### Retirando o excesso
nomes <-c("uo_cod_desp","uo_desp","Ano","categoria_economica_cod",
"Categoria Econômica","gnd_cod_desp","gnd_desp","autorizado",             
"Empenhado","Liquidado","Pago","Unidade_Orcamentaria")  

names(Orc_UNIRIO) <-nomes
names(UO_26269) <-nomes
names(UO_26391) <-nomes
remove(nomes)
#------------------------------------------------------------------------------
library(scales)
library(ggplot2)
table(UO_26269$Ano)
grafico1<-UO_26269 %>% group_by(Ano,`Categoria Econômica`) %>% summarise(Empenhado=sum(Empenhado)) %>%
ggplot() +
  aes(x = Ano, y = Empenhado,color = `Categoria Econômica`) +
  geom_line( size = 2)

grafico1 <- grafico1 + scale_x_discrete(limits=2010:2021)
grafico1 <- grafico1 +scale_color_manual(values = c("royalblue", "darkred")) +
  labs(subtitle = "Despesas Correntes e de Capital da U.O. UNIRIO (26269)",
       y="",x="", caption = 'Valores corrigidos pelo IPCA. Foi excluída categoria GND "pessoal e encargos sociais')+
  theme_minimal()+
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))

grafico1
#-------------------------------------------------------------------------------------------------------------------
# UNIRIO Liquidado
grafico2<-UO_26269 %>% group_by(Ano,`Categoria Econômica`) %>% summarise(Liquidado=sum(Liquidado)) %>%
  ggplot() +
  aes(x = Ano, y = Liquidado,color = `Categoria Econômica`) +
  geom_line( size = 2)

grafico2 <- grafico2 + scale_x_discrete(limits=2010:2021)
grafico2 <- grafico2 +scale_color_manual(values = c("royalblue", "red")) +
  labs(subtitle = "Despesas Correntes e de Capital da U.O. UNIRIO (26269)",
       y="",x="", caption = 'Valores corrigidos pelo IPCA. Foi excluída categoria GND "pessoal e encargos sociais')+
  theme_minimal()+
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))
grafico2
#-------------------------------------------------------------------------------------------------------------------
# HUGG Liquidado
#UO_26391 %>% group_by(Ano,`Categoria Econômica`) %>% summarise(Liquidado=sum(Liquidado))%>% View()  
grafico3<-UO_26391 %>% group_by(Ano,`Categoria Econômica`) %>% summarise(Liquidado=sum(Liquidado)) %>%
  ggplot() +
  aes(x = Ano, y = Liquidado,color = `Categoria Econômica`) +
  geom_line( size = 2)

grafico3 <- grafico3 + scale_x_discrete(limits=2010:2021)
grafico3 <- grafico3 +scale_color_manual(values = c("royalblue", "red")) +
  labs(subtitle = "Despesas Correntes e de Capital da U.O. HUGG (26391)",
       y="",x="", caption = 'Valores corrigidos pelo IPCA. Foi excluída categoria GND "pessoal e encargos sociais')+
  theme_minimal()+
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))
grafico3

#-------------------------------------------------------------------------------------------------------------------
# UNIRIO + HUGG Liquidado
Orc_UNIRIO %>% group_by(Ano,`Categoria Econômica`,Unidade_Orcamentaria) %>% summarise(Liquidado=sum(Liquidado))%>% data.frame()%>% print()  

grafico4<-Orc_UNIRIO %>% group_by(Ano,`Categoria Econômica`) %>% summarise(Liquidado=sum(Liquidado)) %>%
  ggplot() +
  aes(x = Ano, y = Liquidado,color = `Categoria Econômica`) +
  geom_line( size = 2)

grafico4 <- grafico4 + scale_x_discrete(limits=2010:2021)
grafico4 <- grafico4 +scale_color_manual(values = c("royalblue", "red")) +
  labs(subtitle = "Despesas Correntes e de Capital da UNIRIO (26269) & HUGG (26391)",
       y="",x="", caption = 'Valores corrigidos pelo IPCA. Foi excluída categoria GND "pessoal e encargos sociais')+
  theme_minimal()+
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))
grafico4




dados <-data.frame(
  Emenda  = c(
    "01.-.71200004.Bancada.RJ.pdf",
    "02 - 13100010 Benedita da Silva.pdf",
    "03 - 39410011 Chiquinho Brazão.pdf",
    "04 - 39410012 Chiquinho Brazão.pdf",
    "05 - 39930004 Gelson Azevedo.pdf",
    "06 - 40130020 Gurgel.pdf","07 - 17750014 Jandira Feghali.pdf",
    "08 - 40260022 Juninho do Pneu.pdf",
    "09 - 13380007 Paulo Ramos.pdf",
    "10 - 35780010 Rodrigo Maia.pdf","11 - 37990006 Romário.pdf",
    "12 - 37560004 Rosangela Gomes.pdf",
    "13 - 37660006 Sóstenes Cavalcante.pdf"),
  Valor = c("R$ 133.170.000,00","R$ 1.250.000,00","R$ 2.100.000,00",
            "R$ 2.000.000,00","R$ 3.000.000,00","R$ 8.329.682,00",
            "R$ 270.000,00","R$ 1.000.000,00","R$ 750.000,00",
            "R$ 3.411.000,00","R$ 4.939.680,00","R$ 400.000,00",
            "R$ 2.000.000,00"),
  Nome = c("UNIRIO.MEC" ,"Educação UNIRIO","Caravana Animal",
           "São João de Meriti - projeto cultural",
           "Emenda UNIRIO","Educação","Escola de Enfermagem",
           "UNIRIO","UNIRIO","RM UNIRIO",
           "20GK UNIRIO","Universidade Federal","UNIRIO")
)

dados$Valor <- gsub("\\." , "",dados$Valor)
dados$Valor <- gsub("\\," , ".",dados$Valor)
dados$Valor <- gsub("R\\$ " , "",dados$Valor)
dados$Valor <- as.double(dados$Valor)
sum(dados$Valor)
133170000/162620362 