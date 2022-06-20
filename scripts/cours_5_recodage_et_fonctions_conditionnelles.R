#######################Cours 4  : Recodage de variables ##############################################################################
if(!require("pacman"))install.packages("pacman")
pacman::p_load("tidyverse","questionr","here","writexl","readxl","haven")


################################################Import et export de fichiers#########################################################

data("hdv2003")

data <- hdv2003


#######Lire un fichier excel#####

writexl::write_xlsx(data,here(  "data.xlsx"))


data <- read_xlsx(here( "data.xlsx"))




#########Lire un fichier csv#######

write.csv(data,here("data.csv") )

data <- read_csv(here("data.csv"))

#On peut aussi passer par l'interface



rm(list = ls())


##############################################Tests et comparaisons################################################################

# == pour egalite
# != pour tester la difference
# >, < <=, >= pour tester superiorite ou inferiorite
# %in% pour l'appartenance à une valeur

# exemples

2==3 

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


vec %in% c("Jaune", "Vert")


#On peux inverser l’opérateur avec !
!(vec %in% c("Jaune", "Vert"))



####################################################Exercice 1.1################################################################
x <- c(1, 20, 21, 15.5, 14, 12, 8)


#Écrire le test qui indique si les éléments du vecteur sont strictement supérieurs à 15.
#Utiliser ce test pour extraire du vecteur les éléments correspondants.
x>15
x[x>15]


####################################################Exercice 1.2################################################################

#ce vecteur genere 1000 nombres aleatoires entre 0 et 10
x <- runif(1000, 0, 10)

#Combien d'element sont compris entre 2 et 4 ?
obj <- x[x>=2 & x <=4] 
length(obj)



###################################################Recodage de variables##############################################################


#La fonction fct_recode permet de recoder des variables
f <- c("Pomme", "Poire", "Pomme", "Cerise")
f <- fct_recode(f,"Fraise" = "Pomme","Ananas" = "Poire")
f


data("hdv2003")

#On va recoder la variable qualif


levels(hdv2003$qualif)


freq(hdv2003$qualif)

hdv2003$qualif5 <- fct_recode(
  hdv2003$qualif,
  "Ouvrier" = "Ouvrier specialise",
  "Ouvrier" = "Ouvrier qualifie",
  "Interm" = "Technicien",
  "Interm" = "Profession intermediaire"
)



freq(hdv2003$qualif5)



#pour transformer une modalite en NA, on lui assigne la valeur NULL

hdv2003$qualif_rec <- fct_recode(
  hdv2003$qualif, 
  NULL = "Autre"
)


freq(hdv2003$qualif_rec)



#pour recoder les variables manquantes, on utilise fct_explicit_na

hdv2003$qualif_rec <- fct_explicit_na(hdv2003$qualif, na_level = "truc")

freq(hdv2003$qualif_rec)

# d'autres fonctions de recodage


#fct_other pour transformer une liste de modalites en "others
hdv2003$qualif_rec <- fct_other(
  hdv2003$qualif,
  drop = c("Ouvrier specialise", "Ouvrier qualifie", "Cadre", "Autre")
)

freq(hdv2003$qualif_rec)


#fct_lump pour transformer en "others" les modalites les moins frequentes

hdv2003$qualif_rec <- fct_lump(hdv2003$qualif,prop = 0.1)

freq(hdv2003$qualif_rec)


####################################################Exercice 2.1################################################################


f <- c("Jan", "Jan", "Fev", "Juil")


#Recoder le vecteur à l’aide de la fonction fct_recode pour obtenir le résultat suivant :

#> [1] Janvier Janvier Février Juillet
#> Levels: Février Janvier Juillet

f <- fct_recode(f,"Janvier"="Jan","Février"="Fev","Juillet"="Juil")


#########################################interface graphique de recodage#################################################################


#on peux directement selectionner la variable a recoder et utiliser l'interface graphique de questionr dans "addins"

irec(hdv2003$qualif)


####################################################Exercice 2.2################################################################


#A l’aide de l’interface graphique de questionr, 
#recoder la variable relig du jeu de données hdv2003 pour obtenir le tri à plat suivant 

#>                               n    % val%
#> Pratiquant                  708 35.4 35.4
#> Appartenance                760 38.0 38.0
#> Ni croyance ni appartenance 399 20.0 20.0
#> Rejet                        93  4.7  4.7
#> NSP                          40  2.0  2.0

irec(hdv2003$relig)



## Recodage de hdv2003$relig en hdv2003$relig_rec
hdv2003$relig_rec <- hdv2003$relig %>%
  fct_recode(
    "Pratiquant" = "Pratiquant regulier",
    "Pratiquant" = "Pratiquant occasionnel",
    "Appartenance" = "Appartenance sans pratique",
    "NSP" = "NSP ou NVPR"
  )


freq(hdv2003$relig_rec)



####################################################################################################################

#ordonner les variables avec fct_relevel
hdv2003$qualif_rec <- fct_relevel(
  hdv2003$qualif,
  "Cadre", "Profession intermediaire", "Technicien",
  "Employe", "Ouvrier qualifie", "Ouvrier specialise",
  "Autre"
)


freq(hdv2003$qualif_rec)



##ordonner les variables en fonction d'une autre

plot(hdv2003$occup,hdv2003$age)


#avec fct_reorder on reordonne les modalites selon l'age median
hdv2003$occup_age <- fct_reorder(hdv2003$occup,hdv2003$age, median)




plot(hdv2003$occup_age,hdv2003$age)


ggplot(hdv2003,aes(x=occup_age,y=age))+geom_boxplot()


##ici aussi on peux utiliser l'interface graphique de questionr

iorder(hdv2003$qualif)



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

irec(hdv2003$nivetud)

hdv2003$nivetud_rec <- hdv2003$nivetud %>%
  fct_recode(
    "Études primaires" = "A arrete ses etudes, avant la derniere annee d'etudes primaires",
    "Études primaires" = "Derniere annee d'etudes primaires",
    "Enseignement technique ou professionnel" = "Enseignement technique ou professionnel court",
    "Enseignement technique ou professionnel" = "Enseignement technique ou professionnel long",
    "Enseignement superieur" = "Enseignement superieur y compris technique superieur"
  )


freq(hdv2003$nivetud_rec)


#Toujours à l’aide de l’interface graphique, réordonner les modalités de cette variable recodée pour obtenir le tri à plat suivant :

#>                                           n    % val%
#> Enseignement superieur                  441 22.0 23.4
#> Enseignement technique ou professionnel 594 29.7 31.5
#> 2eme cycle                              183  9.2  9.7
#> 1er cycle                               204 10.2 10.8
#> Études primaires                        427 21.3 22.6
#> N'a jamais fait d'etudes                 39  2.0  2.1
#> NA                                      112  5.6   NA
iorder(hdv2003$nivetud_rec)

hdv2003$nivetud_rec <- hdv2003$nivetud_rec %>%
  fct_relevel(
    "Enseignement superieur", "Enseignement technique ou professionnel",
    "2eme cycle", "1er cycle", "Études primaires", "N'a jamais fait d'etudes"
  )





####################################################Exercice 2.4################################################################

#À l’aide de la fonction fct_reorder, trier les modalités de la variable relig du jeu de données hdv2003 selon leur âge médian.
#Produisez la boxplot correspondante
hdv2003$reglig_rec <- fct_reorder(hdv2003$relig,hdv2003$age,median)

boxplot(hdv2003$rel)

ggplot()+
  geom_boxplot(data=hdv2003,aes(x=reglig_rec,y=age))


#######################################Recodage conditionnel avec ifelse#############################################################
 
## ifelse = Si condition est verifie, ceci, sinon cela.

v <- c(12, 14, 8, 16)
ifelse(v > 10, "Supérieur à 10", "Inférieur à 10")



hdv2003$statut <- ifelse(hdv2003$sexe == "Homme" & hdv2003$age > 60,
  "Homme de plus de 60 ans",
  "Autre"
)



freq(hdv2003$statut)


###################################################Exercice 3.1################################################################

#À l’aide de la fonction ifelse, créer une nouvelle variable cinema_bd 
#permettant d’identifier les personnes qui vont au cinéma et déclarent lire des bandes dessinées.

#Vous devriez obtenir le tri à plat suivant pour cette nouvelle variable :

#>                 n    % val%
#> Autre        1971 98.6 98.6
#> Cinéma et BD   29  1.5  1.5

hdv2003$cinema_bd <- ifelse(hdv2003$cinema=="Oui" & hdv2003$lecture.bd=="Oui","Cinéma et BD","Autre")

freq(hdv2003$cinema_bd)


#########################################Recodage conditionnel avec case_when########################################################

hdv2003$statut <- case_when(
  hdv2003$age > 60 & hdv2003$sexe == "Homme" ~ "Homme de plus de 60 ans",
  hdv2003$age > 60 & hdv2003$sexe == "Femme" ~ "Femme de plus de 60 ans",
  TRUE ~ "Autre")


freq(hdv2003$statut)

#l'ordre des conditions est important, elles sont testees les unes apres les autres

# exemple de recodage qui ne fonctionne pas
hdv2003$statut <- case_when(
  hdv2003$sexe == "Homme" ~ "Homme",
  hdv2003$sexe == "Homme" & hdv2003$age > 60 ~ "Homme de plus de 60 ans",
  TRUE ~ "Autre"
)

freq(hdv2003$statut)



#pour que ça fonctionne, il faut que les conditions les plus generales soit apres les conditions specifiques


hdv2003$statut <- case_when(
  hdv2003$sexe == "Homme" & hdv2003$age > 60 ~ "Homme de plus de 60 ans",
  hdv2003$sexe == "Homme" ~ "Homme",
  TRUE ~ "Autre"
)
freq(hdv2003$statut)

###############################################Découper une variable numérique en classe#############################################

#avec la fonction cut, la variable est automatiquement découpée en un nombre de classes spécifiées
hdv2003$agecl <- cut(hdv2003$age, breaks = 5)

freq(hdv2003$agecl)

#il est possible de préciser manuellement les classes
hdv2003$agecl <- cut(
  hdv2003$age,
  breaks = c(18, 25, 35, 45, 55, 65, 97),
  include.lowest = TRUE
)


freq(hdv2003$agecl)

#on peut egalement utiliser l'interface graphique


icut(hdv2003$age)


################################################################EXERCICES######################################################################


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

hdv2003$statut <- case_when(hdv2003$sexe=="Femme" & hdv2003$freres.soeurs>2~"Femme ayant plus de 2 frères et soeurs",
                            hdv2003$sexe=="Homme" & hdv2003$freres.soeurs>2~"Homme ayant plus de 2 frères et soeurs",
                            TRUE~"Autre"
                            
                            )

freq(hdv2003$statut)




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
  #> 
  #> 
  #> 

hdv2003$statut <- case_when(hdv2003$sexe=="Homme" & hdv2003$age>40 & 
                              hdv2003$trav.satisf=="Satisfaction"~ "Homme de plus de 40 ans satisfait par son travail",
                            hdv2003$sexe=="Homme" & hdv2003$age>30~"Homme de plus de 30 ans",
                            hdv2003$sexe=="Femme" & hdv2003$bricol=="Oui"| hdv2003$sexe=="Femme" & hdv2003$sport=="Oui"~"Femme pratiquant le sport ou le bricolage",
                            TRUE~"Autre" )



freq(hdv2003$statut)

#####Exo 3.4

#Decoupez la variable heure.tv en 4 classes
#représentez l'age selon la classe du nbre d'heures passées devant la tv avec un boxplot

hdv2003$heures.tv_cl <- cut(hdv2003$heures.tv,breaks = 4,include.lowest = T)
## Recodage de hdv2003$heures.tv_cl en hdv2003$heures.tv_cl_rec
hdv2003$heures.tv_cl_rec <- hdv2003$heures.tv_cl %>%
  fct_recode(
    "Moins de 3h de tv" = "[-0.012,3]",
    
    "De 3 à 6h" = "(3,6]",
    "De 6 à 9h" = "(6,9]",
    "De 9 à 12h" = "(9,12]"
  ) %>%
  fct_explicit_na("Manquant")


hdv2003$heures.tv_cl_rec <- fct_reorder()


ggplot(hdv2003,aes(x=fct_reorder(heures.tv_cl_rec,heures.tv)  ,y=age))+
  geom_boxplot()

