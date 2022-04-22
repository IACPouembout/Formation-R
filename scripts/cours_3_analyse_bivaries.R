#######################Cours 3  : Analyses bivariées  ##############################################################################

if(!require("pacman"))install.packages("pacman")
pacman::p_load("questionr")


#################### 3.1 Croisement de 2 variables qualitatives #####################################################################
data(hdv2003)
d <- hdv2003


table(d$qualif, d$sexe)

tab <- table(d$qualif, d$sexe)
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
boxplot(d$age ~ d$sport)
#calcul d'indicateurs
d_sport <- subset(d, sport == "Oui")
d_nonsport <- subset(d, sport == "Non")
mean(d_sport$age)
mean(d_nonsport$age)

tapply(d$age, d$sport, mean)



#tests statistiques
t.test(d$age ~ d$sport)
###Avant de faire un t.test, il faut vérifier la normalité des données

hist(d_sport$age)
hist(d_nonsport$age)

shapiro.test(d_sport$age)
shapiro.test(d_nonsport$age)

wilcox.test(d$age ~ d$sport)

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
data("hdv2003")

####################################################Exercice 1################################################################

#Dans le jeu de données `hdv2003`, faire le tableau croisé entre la catégorie socio-professionnelle (variable `qualif`) 
#et le fait de croire ou non en l'existence des classes sociales (variable `clso`). Identifier la variable indépendante et la variable dépendante, 
#et calculer les pourcentages ligne ou colonne. Interpréter le résultat.

#Identifier la variable indépendante et la variable dépendante, et calculer les pourcentages ligne ou colonne. Interpréter le résultat.

#Faire un test du χ². Peut-on rejeter l’hypothèse d’indépendance ?

#Représenter ce tableau croisé sous la forme d’un mosaicplot en colorant les cases selon les résidus du test du χ².
####################################################Exercice 2################################################################
#Sur le jeu de données hdv2003, faire le boxplot qui croise le nombre d’heures passées devant la télévision (variable heures.tv) 
#avec le statut d’occupation (variable occup).


#Calculer la durée moyenne devant la télévision en fonction du statut d’occupation à l’aide de tapply.


####################################################Exercice 3################################################################
data("rp2018")
#Sur le jeu de données rp2018, représenter le nuage de points croisant le pourcentage de personnes sans diplôme (variable dipl_aucun) 
#et le pourcentage de propriétaires (variable proprio).


#Calculer le coefficient de corrélation linéaire correspondant.

