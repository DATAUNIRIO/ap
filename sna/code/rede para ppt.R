# Parte 1 - Teoria & Aplicação no R
# 1. Núcleos & ligações
# 2. Revisão de matriz (matriz quadrada e matriz simétrica)
# 3. Matriz de ligações (matriz de adjacência)
# 4. Graficos de rede
# 5. Conecção and distância
# 6. A distância geodésica
# 7. Medidas de centralidade e poder
# 7.1 closeness
# 7.2 betweenness
# 7.3 degrees
# 7.4 eigenvector centrality
# 8. Grupos e comunidades
#
# Parte 2 - Aplicada com R
# 1 - construindo redes com o R
# 2 - criação de matrizes com o R
# 3 - distância geodésica com o R
# 4 - as quatro medidas de centralidade e poder com o R
# 5 - identificando grupos com o R



load('C:/Users/Hp/Documents/GitHub/Modelos_Basicos_e_Testes/social_network_methods/dados/star/star.Rdata')


set.seed(12345)
selecao = c('LUKE','OBI-WAN','HAN','DARTH VADER','OWEN','JABBA')

library(dplyr)

seres = seres %>% filter(pessoas %in% selecao)
relacoes = relacoes %>% filter(source %in% selecao)
relacoes = relacoes %>% filter(target %in% selecao)


library(igraph)
graph <- graph_from_data_frame(relacoes, directed=TRUE, vertices=seres)
plot(graph)

par(mar=c(0,0,0,0))
plot(graph,
     vertex.color = "grey", # change color of nodes
     vertex.label.color = "black", # change color of labels
     vertex.label.cex = .85, # change size of labels to 75% of original size
     edge.curved=.25, # add a 25% curve to the edges
     edge.arrow.size = 0.5,
     edge.color="grey20") # change edge color to grey

plot(graph,
     vertex.size=30,
     vertex.color = "skyblue", # change color of nodes
     vertex.label.color = "black", # change color of labels
     vertex.label.cex = 1.5, # change size of labels to 75% of original size
     #edge.curved=.25, # add a 25% curve to the edges
     edge.arrow.size = 0.01,
     edge.color="grey20") # change edge color to grey

plot(graph,
     vertex.size=30,
     vertex.color = "lightgreen", # change color of nodes
     vertex.label.color = "black", # change color of labels
     vertex.label.cex = 1.5, # change size of labels to 75% of original size
     #edge.curved=.25, # add a 25% curve to the edges
     edge.arrow.size = 0.8,
     edge.color="grey20") # change edge color to grey

