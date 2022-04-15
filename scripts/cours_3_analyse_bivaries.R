#######################Cours 3  : Analyses bivariées  ##############################################################################

if(!require("pacman"))install.packages("pacman")
if(!require("devtools"))install.packages("devtools")
pacman::p_load("questionr","tidyverse")
if(!require("Caledocensus"))devtools::install_github("https://github.com/IACPouembout/Caledocensus",force = TRUE,dependencies = FALSE)
library(Caledocensus)

#################### 3.1 Croisement de 2 variables qualitatives #####################################################################
rp19 <- rp19_ind[1:5000,]



table(rp19$TACT, rp19$GENRE)
tab <- table(rp19$TACT, rp19$GENRE)
lprop(tab)
cprop(tab)

#test du chi 2

chisq.test(tab)
chisq.residuals(tab)

#representation graphique 
mosaicplot(tab)
mosaicplot(tab, las = 3, shade = TRUE)

#################### 3.2 Croisement d'une variables qualitative et d'une variable quantitative ########################################

#representation graphique
boxplot(rp19$AGER~ rp19$TP)

#calcul d'indicateurs
temps_partiel <- filter(rp19, COUPLE == "Vit en couple")
noncouple <- filter(rp19, COUPLE == "Ne vit pas en couple")

mean(couple$AGER)
mean(noncouple$AGER)


tapply(rp19$AGER, rp19$COUPLE, mean,na.rm=T)




#tests statistiques
t.test(rp19$AGER~ rp19$COUPLE)

###Avant de faire un t.test, il faut vérifier la normalité des données

hist(couple$AGER)
hist(noncouple$AGER)

shapiro.test(couple$AGER)
shapiro.test(noncouple$AGER)

wilcox.test(rp19$AGER~ rp19$COUPLE)

#################### 3.2 Croisement de deux variables quantitatives ########################################
data(rp2018)


plot(rp2018$cadres, rp2018$proprio)
plot(rp2018$cadres, rp2018$dipl_sup)

#coefficient de correlation
cor(rp2018$cadres, rp2018$dipl_sup)

cor(rp2018$cadres, rp2018$proprio)

cor(rp2018$cadres, rp2018$dipl_sup, method = "spearman")

lm(rp2018$cadres ~ rp2018$dipl_sup)
reg <- lm(rp2018$cadres ~ rp2018$dipl_sup)
summary(reg)


plot(rp2018$dipl_sup, rp2018$cadres)
abline(reg, col = "red")
################################################################EXERCICES######################################################################

rp19_log <- Caledocensus::rp19_log
####################################################Exercice 1################################################################

#Dans le jeu de données rp19_log, faire le tableau croisé entre le diplome de la personne de référence et 
#le fait que le logement dispose d'un accès à internet. 


#Identifier la variable indépendante et la variable dépendante, et calculer les pourcentages ligne ou colonne. Interpréter le résultat.

#Faire un test du χ². Peut-on rejeter l’hypothèse d’indépendance ?

#Représenter ce tableau croisé sous la forme d’un mosaicplot en colorant les cases selon les résidus du test du χ².
####################################################Exercice 2################################################################

#Toujours sur le jeu de données rp19_log, faire le boxplot qui croise le nombre d’heures passées devant la télévision (variable heures.tv) 
#avec le statut d’occupation (variable occup).


#Calculer la durée moyenne devant la télévision en fonction du statut d’occupation à l’aide de tapply.


####################################################Exercice 3################################################################
data("rp2018")
#Sur le jeu de données rp2018, représenter le nuage de points croisant le pourcentage de personnes sans diplôme (variable dipl_aucun) 
#et le pourcentage de propriétaires (variable proprio).


#Calculer le coefficient de corrélation linéaire correspondant.

