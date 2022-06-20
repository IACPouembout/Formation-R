#######################Cours 1  : Prise en main  ##############################################################################

#########################1.1 Opérations basiques ###################################################################

#additions
2+2

##multiplication
34*7

##divisions 
39/7

##puissance
5^3


##########################  1.2 objets simples########################################################################

#on peut stocker des chiffres dans des objets
#alt+6 pour déclarer avec <-  ou alt + 8 
x <- 2

#et effectuer des opérations sur ces objets
x+4

y <- 5

#et avec ces objets
resultat <- x + y
resultat


###On peut aussi stocker du texte 

chien <- "bouledogue"

chien

#on ne peut pas mélanger des objets de natures différentes !

chien + x



#########################  1.3 Vecteurs########################################################################################


#On peut créer plusieurs objets et effectuer des opérations
taille1 <- 156
taille2 <- 164
taille3 <- 197
taille4 <- 147
taille5 <- 173
(taille1 + taille2 + taille3 + taille4 + taille5) / 5

#on peut aussi stocker plusieurs valeurs dans un objet, celui-ci devient un vecteur

tailles <- c(156, 164, 197, 147, 173)



#les opérations sur les vecteurs se font sur l'ensemble des valeurs stockées
tailles_m <- tailles / 100
tailles_m


#exemple de manipulation de vecteurs : on a le poids et la taille des individus 
# on crée un objet imc stockant les valeurs calculées a partir de ces deux vecteurs
poids <- c(45, 59, 110, 44, 88)
imc <- poids / (tailles / 100) ^ 2
imc

####################################################Exercice 1################################################################

#Construire le vecteur x suivant :

#> [1] 120 134 256  12
x <- c(120, 134 ,256,  12)

#Utiliser ce vecteur x pour générer les deux vecteurs suivants :

#> [1] 220 234 356 112
#> [1] 240 268 512  24

x+100

x*2


###########################################################################################################################

# les vecteurs peuvent aussi stocker du texte
diplome <- c("CAP", "Bac", "Bac+2", "CAP", "Bac+3")
diplome

#ou etre de type logical

faux <- FALSE

# class() pour connaire le type de vecteur

class(poids)
class(diplome)
class(faux)
class(as.factor(diplome))
as.factor(diplome)


#exemple de coercicion quand on mélange des vecteurs de différents types

x <- 1
y <- "2"
z <- c(x,y)
z

class(z)


# pour sélectionner une valeur particulière, on utilise les []

diplome[2]


#on peut aussi choisir de sélectionner toutes les valeurs sauf certaines avec -c()

diplome[-c(2)]

#Autre exemple de création de vecteur, les ":"
x <- 1:10

x

############################  1.4 Les fonctions###################################################################################

#Mesurer la taille des données
length(tailles)

#valeurs minimales et maximales
min(tailles)
max(tailles)

#moyenne
mean(tailles)

#somme
sum(tailles)

#étendue
range(tailles)

#filtrer les doublons
diplome <- c("CAP", "Bac", "Bac+2", "CAP", "Bac+3")

unique(diplome)

#les valeurs manquantes sont notées NA (not applicable) 
tailles <- c(156, 164, 197, NA, 173)

#pour vérifier la présence de valeurs manquantes, on utilise is.na()
is.na(tailles)

#Les opérations sont impossibles sur les NA
mean(tailles)

#Il faut indiquer à R de les ignorer avec na.rm=TRUE
mean(tailles,na.rm = TRUE)



######################################################Exercice 2################################################################


#On a demandé à 4 ménages le revenu des deux conjoints, et le nombre de personnes du ménage :

conjoint1 <- c(1200, 1180, 1750, 2100)
conjoint2 <- c(1450, 1870, 1690, 0)
nb_personnes <- c(4, 2, 3, 2)


#Calculer le revenu total de chaque ménage, 

revenu_total <- conjoint1 + conjoint2

#puis diviser par le nombre de personnes pour obtenir le revenu par personne de chaque ménage.


revenu_individuel <- (revenu_total)/nb_personnes

######################################################Exercice 3################################################################

#Calculer le revenu minimum et maximum parmi ceux du premier conjoint.

conjoint1 <- c(1200, 1180, 1750, 2100)
min(conjoint1)
max(conjoint1)

#Recommencer avec les revenus suivants, parmi lesquels une non réponse

conjoint1 <- c(1200, 1180, 1750, NA)
  
min(conjoint1, na.rm = T )
max(conjoint1, na.rm = T )
range(conjoint1,na.rm = T)
range(conjoint1,na.rm = T)



######################################################Exercice 4################################################################


#Les deux vecteurs suivants représentent les précipitations (en mm) et la température (en °C) moyennes 
#pour chaque mois de l’année pour la ville de Lyon (moyennes calculées sur la période 1981-2010) :

temperature <- c(3.4, 4.8, 8.4, 11.4, 15.8, 19.4, 22.2, 21.6, 17.6, 13.4, 7.6, 4.4)
precipitations <- c(47.2, 44.1, 50.4, 74.9, 90.8, 75.6, 63.7, 62, 87.5, 98.6, 81.9, 55.2)

#Calculer la température moyenne sur l’année.
mean(temperature)


#Calculer la quantité totale de précipitations sur l’année.
sum(precipitations)



#À quoi correspond et comment peut-on interpréter le résultat des fonctions suivantes ? 

cumsum(precipitations)

diff(temperature)


######################################################Exercice 5################################################################

#On a relevé les notes en maths, anglais et sport d’une classe de 6 élèves et on a stocké ces données dans trois vecteurs :
 
  maths <- c(12, 16, 8, 18, 6, 10)
anglais <- c(14, 9, 13, 15, 17, 11)
sport <- c(18, 11, 14, 10, 8, 12)


#Calculer la moyenne des élèves de la classe en anglais.
mean(anglais)
#Calculer la moyenne générale de chaque élève (la moyenne des ses notes dans les trois matières).
(maths+anglais+sport)/3


#Essayez de comprendre le résultat des deux fonctions suivantes (vous pouvez vous aider de la page d’aide de ces fonctions) :
  
pmin(maths, anglais, sport)


pmax(maths, anglais, sport)
