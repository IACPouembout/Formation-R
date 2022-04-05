#######################Cours 4  : Recodage de variables ##############################################################################
if(!require("pacman"))install.packages("pacman")
if(!require("devtools"))install.packages("devtools")
pacman::p_load("tidyverse","questionr","here","writexl")
if(!require("Caledocensus"))devtools::install_github("https://github.com/IACPouembout/Caledocensus",force = TRUE,dependencies = FALSE)
library(Caledocensus)



##############################################Tests et comparaisons################################################################

# == pour egalite
# != pour tester la difference
# >, < <=, >= pour tester superiorite ou inferiorite
# %in% pour l'appartenance à une valeur

# exemples

2 ==3 

2!=3

x <- 1:10 

x<5

# le & permet de combiner les conditions

x >= 3 & x <= 6

#on peut sélectionner de façon conditionnel

x[x>3]


#Le | permet de tester l'une ou l'autre condition

vec <- c("Jaune", "Jaune", "Rouge", "Vert")
vec == "Jaune" | vec == "Vert"


#On peux inverser l’opérateur avec !
!(vec %in% c("Jaune", "Vert"))



################################################Import et export de fichiers#########################################################
library(Caledocensus)

rp19 <- rp19_ind[1:5000,]

#########Lire un fichier csv#######

write.csv(rp19,here("RGP_2019_ind_ISEE.csv"))

rp19 <- read_csv(here("RGP_2019_ind_ISEE.csv"))

#On peut aussi passer par l'interface

#######Lire un fichier excel#####

writexl::write_xlsx(rp19,here(  "RGP_2019_ind_ISEE.xlsx"))

rp19 <- read_xlsx(here( "RGP_2019_ind_ISEE.xlsx"))


#####Lire un fichier stata####

write_dta(rp19,here("RGP_2019_ind_ISEE.dta"))

rp19 <- read_dta(here("RGP_2019_ind_ISEE.dta"))



rm(list = ls())


###################################################Recodage de variables##############################################################


#La fonction fct_recode permet de recoder des variables

f <- c("Pomme", "Poire", "Pomme", "Cerise")
f <- fct_recode(
  f,
  "Fraise" = "Pomme",
  "Ananas" = "Poire"
)



library(Caledocensus)
rp19 <- rp19_ind[1:5000,]

#On va recoder la variable TACT


levels(rp19$TACT)
freq(rp19$TACT)



rp19$TACT6 <- fct_recode(
  rp19$TACT,
  "Etudes,stage ou apprentissage" = "Apprentissage sous contrat ou stage rémunéré",
  "Etudes,stage ou apprentissage" = "Études ou stage non rémunéré",
)

freq(rp19$TACT6)



#pour transformer une modalite en NA, on lui assigne la valeur NULL

rp19$TACT6 <- fct_recode(
  rp19$TACT6, 
  NULL = "Autre situation"
)


freq(rp19$TACT6)



#pour recoder les variables manquantes, on utilise fct_explicit_na

rp19$TACT6 <- fct_explicit_na(rp19$TACT6, na_level = "Non renseigné")

freq(rp19$TACT6)

# d'autres fonctions de recodage


#fct_other pour transformer une liste de modalites en "others
rp19$TACT_rec <- fct_other(
  rp19$TACT,
  drop = c("Autre situation",
           "Apprentissage sous contrat ou stage rémunéré",
           "Études ou stage non rémunéré")
)

freq(rp19$TACT_rec)


#fct_lump pour transformer en "others" les modalites les moins frequentes

rp19$TACT_rec <- fct_lump(rp19$TACT)

freq(rp19$TACT_rec)


##inteface graphique de recodage

#on peux directement selectionner la variable a recoder et utiliser l'interface graphique de questionr dans "addins"

irec(rp19$TACT)


#ordonner les variables avec fct_reorder
rp19$TACT_rec <- fct_relevel(rp19$TACT ,
    "Emploi", "Retraite ou pré-retraite", "Études ou stage non rémunéré","Chômage", "Femme ou homme au foyer",
    "Autre situation",  "Apprentissage sous contrat ou stage rémunéré"
    
  )

freq(rp19$TACT_rec)


##ordonner les variables en fonction d'une autre

plot(rp19$TACT6,rp19$AGER)

#avec fct_reorder on reordonne les modalites selon l'age median
rp19$TACT_age <- fct_reorder(rp19$TACT6,rp19$AGER, median)

plot(rp19$TACT_age,rp19$AGER)


##ici aussi on peux utiliser l'interface graphique de questionr

iorder(rp19$TACT)


#######################################Recodage conditionnel avec ifelse#############################################################
 
## ifelse = Si condition est verifie, ceci, sinon cela.

v <- c(12, 14, 8, 16)
ifelse(v > 10, "Supérieur à 10", "Inférieur à 10")




rp19$statut <- ifelse(
 rp19$GENRE == "Homme" & rp19$AGER > 60,
  "Homme de plus de 60 ans",
  "Autre"
)

freq(rp19$statut)



#########################################Recodage conditionnel avec case_when########################################################

rp19$statut <- case_when(
  rp19$AGER > 60 &  rp19$GENRE == "Homme" ~ "Homme de plus de 60 ans",
  rp19$AGER > 60 &  rp19$GENRE == "Femme" ~ "Femme de plus de 60 ans",
  TRUE ~ "Autre"
)

freq(rp19$statut)

#l'ordre des conditions est important, elles sont testees les unes apres les autres

# exemple de recodage qui ne fonctionne pas
rp19$statut <- case_when(
  rp19$GENRE == "Homme" ~ "Homme",
  rp19$GENRE == "Homme" & rp19$AGER > 60 ~ "Homme de plus de 60 ans",
  TRUE ~ "Autre"
)

freq(rp19$statut)


#pour que ça fonctionne, il faut que les conditions les plus generales soit apres les conditions specifiques


rp19$statut <- case_when(
  rp19$GENRE == "Homme" & rp19$AGER > 60 ~ "Homme de plus de 60 ans",
  rp19$GENRE == "Homme" ~ "Homme",
  TRUE ~ "Autre"
)

freq(rp19$statut)



###############################################Découper une variable numérique en classe#############################################

#avec la fonction cut, la variable est automatiquement découpée en un nombre de classes spécifiées
rp19$AGER_gp <- cut(rp19$AGER, breaks = 5)

freq(rp19$AGER_gp)

#il est possible de préciser manuellement les classes
rp19$AGER_gp <- cut(
  rp19$AGER,
  breaks = c(0,18, 25, 35, 45, 55, 65, 104),
  include.lowest = TRUE
)

freq(rp19$AGER_gp)

#on peut egalement utiliser l'interface graphique


icut(rp19$AGER)


################################################################EXERCICES######################################################################


####################################################Exercice 1.1################################################################
x <- c(1, 20, 21, 15.5, 14, 12, 8)


#Écrire le test qui indique si les éléments du vecteur sont strictement supérieurs à 15.
#Utiliser ce test pour extraire du vecteur les éléments correspondants.


####################################################Exercice 1.2################################################################

#ce vecteur genere 1000 nombres aleatoires entre 0 et 10
x <- runif(1000, 0, 10)

#Combien d'element sont compris entre 2 et 4

####################################################Exercice 2.1################################################################


f <- c("Jan", "Jan", "Fev", "Juil")


#Recoder le vecteur à l’aide de la fonction fct_recode pour obtenir le résultat suivant :

  #> [1] Janvier Janvier Février Juillet
  #> Levels: Février Janvier Juillet



####################################################Exercice 2.2################################################################

data("hdv2003")

#A l’aide de l’interface graphique de questionr, 
#recoder la variable relig du jeu de données hdv2003 pour obtenir le tri à plat suivant 

  #>                               n    % val%
  #> Pratiquant                  708 35.4 35.4
  #> Appartenance                760 38.0 38.0
  #> Ni croyance ni appartenance 399 20.0 20.0
  #> Rejet                        93  4.7  4.7
  #> NSP                          40  2.0  2.0
  
  
####################################################Exercice 2.3################################################################

#À l’aide de l’interface graphique de questionr, 
#recoder la variable nivetud pour obtenir le tri à plat suivant :
  
  #>                                           n    % val%
  #> N'a jamais fait d'etudes                 39  2.0  2.1
  #> Études primaires                        427 21.3 22.6
  #> 1er cycle                               204 10.2 10.8
  #> 2eme cycle                              183  9.2  9.7
  #> Enseignement technique ou professionnel 594 29.7 31.5
  #> Enseignement superieur                  441 22.0 23.4
  #> NA    

#Toujours à l’aide de l’interface graphique, réordonner les modalités de cette variable recodée pour obtenir le tri à plat suivant :
  
  #>                                           n    % val%
  #> Enseignement superieur                  441 22.0 23.4
  #> Enseignement technique ou professionnel 594 29.7 31.5
  #> 2eme cycle                              183  9.2  9.7
  #> 1er cycle                               204 10.2 10.8
  #> Études primaires                        427 21.3 22.6
  #> N'a jamais fait d'etudes                 39  2.0  2.1
  #> NA                                      112  5.6   NA



####################################################Exercice 2.4################################################################

#À l’aide de la fonction fct_reorder, trier les modalités de la variable relig du jeu de données hdv2003 selon leur âge médian.
#Produisez la boxplot correspondante



####################################################Exercice 3.1################################################################

#À l’aide de la fonction ifelse, créer une nouvelle variable cinema_bd 
#permettant d’identifier les personnes qui vont au cinéma et déclarent lire des bandes dessinées.

#Vous devriez obtenir le tri à plat suivant pour cette nouvelle variable :
  
  #>                 n    % val%
  #> Autre        1971 98.6 98.6
  #> Cinéma et BD   29  1.5  1.5

####################################################Exercice 3.2################################################################

#À l’aide de la fonction case_when, créer une nouvelle variable ayant les modalités suivantes :
  
#Homme ayant plus de 2 frères et soeurs
#Femme ayant plus de 2 frères et soeurs
#Autre

#Vous devriez obtenir le tri à plat suivant :
  
  #>                                           n    % val%
  #> Autre                                  1001 50.0 50.0
  #> Femme ayant plus de 2 frères et soeurs  546 27.3 27.3
  #> Homme ayant plus de 2 frères et soeurs  453 22.7 22.7


####################################################Exercice 3.3################################################################

#À l’aide de la fonction case_when, créer une nouvelle variable ayant les modalités suivantes :
  
#Homme de plus de 30 ans
#Homme de plus de 40 ans satisfait par son travail
#Femme pratiquant le sport ou le bricolage
#Autre

#Vous devriez obtenir le tri à plat suivant :
  
  #>                                                     n    % val%
  #> Autre                                             714 35.7 35.7
  #> Femme pratiquant le sport ou le bricolage         549 27.5 27.5
  #> Homme de plus de 30 ans                           610 30.5 30.5
  #> Homme de plus de 40 ans satisfait par son travail 127  6.3  6.3