#######################Cours 2  : Premier travail avec les données et analyses univariées  ##############################################################################





#################### 2.1  Les packages ###########################################################################################

if(!require("pacman"))install.packages("pacman")
pacman::p_load("questionr")

#################### 2.2  Les tableaux ###########################################################################################


data("hdv2003")
data <- hdv2003


#quelle est la structure du tableau ?
nrow(data)
ncol(data)
dim(data)
names(data)
str(data)

##Le signe $ permet de sélectionner les variables du tableau
data$age


#On peut regarder les premières ou dernières valeurs de la variable
head(data$age)
tail(data$age)


#moyenne et mediane
mean(data$age)

median(data$age)


##dispersion
max(data$age) - min(data$age)

var(data$age)

sd(data$age)

quantile(data$age)


summary(data$age)


##Il est possible de créer directement des nouvelles variables
head(d$heures.tv, 10)
d$minutes.tv <- d$heures.tv * 60


#################### 2.3 representations graphiques ###########################################################################################

#histogramme
hist(data$age)

#on peut déterminer l'échelle de l'axe avec breaks
hist(data$age, breaks = 10)

hist(data$age, breaks = 70)


hist(data$age, col = "skyblue",
     main = "Répartition par âge de la population",
     xlab = "Âge",
     ylab = "Effectif")



#################### 2.4 Tri à plat ###########################################################################################



#la fonction table permet de faire un tri a plat
table(data$qualif)

#la fonction freq permet d'avoir egalement les proportions
freq(data$qualif)

#on peut trier par ordre décroissant
freq(data$qualif, valid = FALSE, total = TRUE, sort = "dec")




#################### 2.5 Représentations graphiques ############################################################################

#repartition selon la croyance dans les classes sociales
tab=table(data$cslo)

#graphique en baton
barplot(tab)

#on peut trier avec sort
barplot(sort(tab))

#dotchart est un autre type de graph en baton
dotchart(sort(tab))


################################################################EXERCICES######################################################################


####################################################Exercice 1################################################################


#On souhaite étudier la répartition du temps passé devant la télévision par les enquêtés (variable heures.tv). 
#Pour cela, affichez les principaux indicateurs de cette variable : valeur minimale, maximale, moyenne, médiane et écart-type. 
#Représentez ensuite sa distribution par un histogramme en 10 classes.


####################################################Exercice 2################################################################
#On s’intéresse maintenant à l’importance accordée par les enquêtés à leur travail (variable trav.imp). 
#Faites un tri à plat des effectifs des modalités de cette variable avec la commande table
#Faites un tri à plat affichant à la fois les effectifs et les pourcentages de chaque modalité. Y’a-t-il des valeurs manquantes ?

#Représentez graphiquement les effectifs des modalités à l’aide d’un graphique en barres.