#######################Cours 2  : Premier travail avec les données et analyses univariées  ##############################################################################





#################### 2.1  Les packages ###########################################################################################

if(!require("pacman"))install.packages("pacman")
if(!require("devtools"))install.packages("devtools")

pacman::p_load("questionr","tidyverse")
if(!require("Caledocensus"))devtools::install_github("https://github.com/IACPouembout/Caledocensus",force = TRUE,dependencies = FALSE)
library(Caledocensus)

#################### 2.2  Les tableaux ###########################################################################################



data <- rp19_ind


#quelle est la structure du tableau ?
nrow(data)
ncol(data)
dim(data)
names(data)
str(data)

##Le signe $ permet de sélectionner les variables du tableau
data$AGER


#On peut regarder les premières ou dernières valeurs de la variable
head(data$AGER)
tail(data$AGER)


#moyenne et mediane
mean(data$AGER)

median(data$AGER)


##dispersion
max(data$AGER) - min(data$AGER)

var(data$AGER)

sd(data$AGER)

quantile(data$AGER)


summary(data$AGER)


##Il est possible de créer directement des nouvelles variables
data$duree_installation <- data$ANNINS -2019



#################### 2.3 representations graphiques ###########################################################################################

#histogramme
hist(data$AGER)

#on peut déterminer l'échelle de l'axe avec breaks
hist(data$AGER, breaks = 10)

hist(data$AGER, breaks = 70)


hist(data$AGER, col = "skyblue",
     main = "Répartition par âge de la population",
     xlab = "Âge",
     ylab = "Effectif")



#################### 2.4 Tri à plat ###########################################################################################



#la fonction table permet de faire un tri a plat
table(data$TACT)

#la fonction freq permet d'avoir egalement les proportions
freq(data$TACT)

#on peut trier par ordre décroissant
freq(data$TACT, valid = FALSE, total = TRUE, sort = "dec")




#################### 2.5 Représentations graphiques ############################################################################

#repartition selon la situation conjugale
tab=table(data$COUPLE)

#graphique en baton
barplot(tab)

#on peut trier avec sort
barplot(sort(tab))

#dotchart est un autre type de graph en baton
dotchart(sort(tab))


################################################################EXERCICES######################################################################
#Travail sur l'enquête "Histoire de vie 2003"
data("hdv2003")

####################################################Exercice 1################################################################


#On souhaite étudier la répartition du temps passé devant la télévision par les enquêtés (variable heures.tv). 
#Pour cela, affichez les principaux indicateurs de cette variable : valeur minimale, maximale, moyenne, médiane et écart-type. 
#Représentez ensuite sa distribution par un histogramme en 10 classes.



####################################################Exercice 2################################################################
#On s’intéresse maintenant à l’importance accordée par les enquêtés à leur travail (variable trav.imp). Faites un tri à plat des effectifs des modalités de cette variable avec la commande table.

#Faites un tri à plat affichant à la fois les effectifs et les pourcentAGERs de chaque modalité. Y’a-t-il des valeurs manquantes ?

#Représentez graphiquement les effectifs des modalités à l’aide d’un graphique en barres.