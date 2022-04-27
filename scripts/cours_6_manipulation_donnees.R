#######################Cours 6 : Manipulation de données ##############################################################################
if(!require("pacman"))install.packages("pacman")

pacman::p_load("tidyverse",
               "here","questionr")

rp19_ind <-read_delim(url("https://raw.githubusercontent.com/IACPouembout/Formation-R/main/data/rp19_ind.csv"))
  
#######################################################Les verbes de dplyr######################################################

####################################################### Slice #######################################################

#sélectionner une ligne
slice(rp19_ind,30)

#sélectionner un ensemble de lignes
slice(rp19_ind,1:30)

#sélectionner les dernières lignes

slice_tail(rp19_ind,n=30)

#sélectionner les premiere lignes

slice_head(rp19_ind, prop = 0.2)

#sélectionner à partir de valeurs maximum et minimum

slice_max(rp19_ind,AGER)

slice_min(rp19_ind,AGER)

####################################################### Filter #######################################################

#filtrer des donnees a partir d'une conditions
filter(rp19_ind,GENRE=="Homme")

#ou de plusieurs
filter(rp19_ind,GENRE=="Homme" & AGER >90)

#ou d'un calcul
filter(rp19_ind,AGER == median(AGER))


####################################################### Select et rename #######################################################

#select permet de sélectionner directement les variables qui nous intéressent
select(rp19_ind,COUPLE,GENRE)

#ou de sélectionner toutes les variables sauf certaines, avec -, ou -c()
select(rp19_ind,-COUPLE,-GENRE)

select(rp19_ind,-c(COUPLE,-GENRE))

#il y a des verbes pour sélectionner des variables selon le debut ou la fin de leur nom
select(rp19_ind, starts_with("CS"))
select(rp19_ind, ends_with("RA"))

#les : pour sélectionner les variables de_à
select(rp19_ind, ILN:NAT)


#rename pour renommer les variables, rename("nouveau nom"="ancien nom")
rename(rp19_ind,  "Age atteint"=AGEA,"Age révolu"=AGER)


####################################################### Arrange #######################################################

#Trier les variables, par ordre croissant par défaut
arrange(rp19_ind,AGEA)

#Selon plusieurs variables
arrange(rp19_ind,AGEA,GENRE)

#ou par ordre décroissant
arrange(rp19_ind,desc(AGEA),GENRE)


####################################################### Mutate #######################################################

# Mutate() pour créer de nouvelles variables
rp19_ind <- mutate(rp19_ind,ANAIS=2019-AGEA)
select(rp19_ind,AGEA,ANAIS)

# On peut utiliser le recodage conditionnel vu lors du cours 4
rp19_ind <- mutate(rp19_ind,ANAIS=2019-AGEA,
                   ANAIS_cl=case_when(ANAIS %in% c(2000:2019)~"Né(e) après 1999",
                                      ANAIS < 2000 & ANAIS > 1979 ~"Né(e) entre 1980 et 1999",
                                      TRUE~"Né(e) avant 1980"
                                      ) )


select(rp19_ind,ANAIS,ANAIS_cl)

####################################################Exercice 1################################################################

data("starwars")
############Exo 1.1
#Sélectionner la 1ere ligne de la table starwars

#Sélectionner les 5 premières lignes de la table starwars.

#Sélectionner le personnage avec la taille (height) la plus élevée


###########Exo 1.2

#Sélectionnez les personnages humains

#Sélectionnez les personnages nés avant 150

##########Exo 1.4

#Sélectionnez toutes les colonnes de la table sauf les colonnes films et vehicles

#Sélectionnez toutes les colonnes de la table dont les noms se terminent par “color”.

#Dans la table star wars renommez la colonne mass en poids et la colonne height en taille.

##########Exo 1.5

##Dans la table starwars, la colonne height contient la height en centimetre
#Créer une nouvelle variable height_m contenant la taille en mètres 
#Sélectionner dans la table obtenue uniquement les deux colonnes height et height_m.


####################################################### Enchainer les opérations avec le pipe %>% #######################################################

# Les lignes de codes sont liées les unes aux autres tant que le %>% est utilisé
rp19_ind%>%
  filter(PROV=="Sud")%>%
  select(ID,PROV,AGEA)%>%
  arrange(desc(AGEA))

####################################################Exercice 2################################################################


#En utilisant le pipe, sélectionnez les humains dans la stable starwars et triez-les selon leur date de naissance.


####################################################### Opérations groupées #######################################################

rp19_ind%>%
  group_by(PROV)

#sélection de la 1ere ligne de chaque province
rp19_ind%>%
  group_by(PROV)%>%
  slice(1)

#sélection de l'âge max pour chaque province
rp19_ind%>%
  group_by(PROV)%>%
  slice_max(AGEA)%>%
  select(PROV,AGEA)

#calcul de l'âge moyen à l'échelle des provinces
rp19_ind%>%
  group_by(PROV)%>%
  mutate(Age_moyen=mean(AGER))%>%
  select(PROV,Age_moyen)%>%
  unique()

#recodage conditionnel basé sur une opération groupée
rp19_ind%>%
  group_by(PROV)%>%
  mutate(Age_moyen=mean(AGER),
         Age_cl=ifelse(AGEA>Age_moyen,"Âge supérieur à l'âge moyen","Âge inférieur à l'âge moyen"))%>%
  select(PROV,AGEA,Age_cl,Age_moyen)

#filtrage basé sur une opération groupée
rp19_ind%>%
  group_by(PROV)%>%
  mutate(Age_moyen=mean(AGER))%>%
  select(PROV,AGEA,Age_moyen)%>%
  filter(AGEA<=Age_moyen)



####################################################### Summarise #######################################################


#operation qui écrase les autres variables sauf les variables de groupement
rp19_ind%>%
  group_by(PROV)%>%
  summarise(Age_moyen=mean(AGEA),
            Age_median=median(AGEA))

#d'autres version de summarise existe, exemple summarise_if
rp19_ind%>%
  group_by(PROV)%>%
  summarise_if(is.numeric,mean,na.rm=T)


# n() pour compter les observations
rp19_ind%>%
  group_by(PROV)%>%
  summarise(n=n())

# ou count
rp19_ind%>%
  count(PROV)


####################################################### Grouper selon plusieurs variables #######################################################


# exemple : par province et lieu de naissance
rp19_ind%>%
  group_by(PROV,ILN)%>%
  summarise(Age_moyen=mean(AGEA),
            Age_median=median(AGEA))

#par province et par genre
rp19_ind%>%
  group_by(PROV,GENRE)%>%
  summarise(n=n())

#filtrage de l'age moyen max
rp19_ind%>%
  group_by(PROV,ILN)%>%
  summarise(Age_moyen=mean(AGEA))%>%
  group_by(PROV)%>%
  slice_max(Age_moyen)


#ungroup pour dégrouper
rp19_ind%>%
  group_by(PROV,ILN)%>%
  summarise(Age_moyen=mean(AGEA))%>%
ungroup()%>%
    slice_max(Age_moyen)


####################################################### Autres fonctions #######################################################


#slice_sample pour sélectionner des lignes au hasard
rp19_ind%>%
  slice_sample(n=5)

#possible en proportion
rp19_ind%>%
  slice_sample(prop=0.1)



evo_pop_communes <-  read_delim(url("https://raw.githubusercontent.com/IACPouembout/Formation-R/main/data/evo_pop_communes.csv"))

#lead = ligne suivante, lag = ligne précédente
evo_pop_communes%>%
  group_by(Commune)%>%
  mutate(Pop_prev=lag(Pop),
         Taux_croissance = (Pop-Pop_prev)/Pop_prev)


# n() = compter des lignes, n_distinct()= compter les lignes différentes
rp19_ind%>%
  group_by(PROV)%>%
  summarise(n=n(),nlog=n_distinct(IDLOG))

rp19_ind%>%
  distinct(IDLOG)

#relocate pour modifier l'emplacement d'une variable, la replace au début par défaut
rp19_ind%>%
  relocate(PROV)


#mais il est possible de choisir l'emplacement exact
rp19_ind%>%
  relocate(PROV,.after = IDLOG)

####################################################### Tables multiples #######################################################


#concatenation

#Si les colonnes sont les memes
t1 <- rp19_ind%>%
  select(ID,IDLOG,PROV,AGEA)%>%
  slice(1:100)

t2 <- rp19_ind%>%
  select(ID,IDLOG,PROV,AGEA)%>%
  slice(101:200)



t1_t2 <- rbind(t1,t2)

#Si le nombre de colonnes est différent
t1 <- rp19_ind%>%
  select(ID,IDLOG,PROV,AGEA)%>%
  slice(1:100)

t2 <- rp19_ind%>%
  select(ID,IDLOG,AGEA)%>%
  slice(101:200)



t1_t2 <-bind_rows(t1,t2)


# Si on veut fusionner des colonnes différentes issues des memes lignes

t1 <- rp19_ind%>%
  select(ID,IDLOG)%>%
  slice(1:100)

t2 <- rp19_ind%>%
  select(PROV,AGEA)%>%
  slice(1:100)

t1_t2 <- bind_cols(t1,t2)


###################################Jointures de tables########################


personnes <- tibble(
  nom = c("Sylvie", "Sylvie", "Monique", "Gunter", "Rayan", "Rayan"),
  voiture = c("Twingo", "Ferrari", "Scenic", "Lada", "Twingo", "Clio")
)
voitures <- tibble(
  voiture = c("Twingo", "Ferrari", "Clio", "Lada", "208"),
  vitesse = c("140", "280", "160", "85", "160")
)


#left_join pour les jointures de tables
#La première colonne dépend de la 1ere table de jointure
voitures %>% left_join(personnes)
personnes %>% left_join(voitures)



#Différents types de jointures
personnes %>% inner_join(voitures)
personnes %>% full_join(voitures)
personnes %>% semi_join(voitures)
personnes %>% anti_join(voitures)

#si les noms des clé identifiants sont différents, on le précise
voitures <- tibble(
  voit = c("Twingo", "Ferrari", "Clio", "Lada", "208"),
  vitesse = c("140", "280", "160", "85", "160")
)

# by=c("x"="y") pour préciser les noms des identifiants
voitures%>%left_join(personnes,by=c("voit"="voiture"))
personnes %>% left_join(voitures,by=c("voiture"="voit"))


# on ne peut faire de jointures que si les identifiants sont de même type
personnes <- tibble(
  nom = c("Sylvie", "Sylvie", "Monique", "Gunter", "Rayan", "Rayan"),
id=c("1","2","3","4","5","6")
  )
voitures <- tibble(
  voiture = c("Twingo", "Ferrari", "Clio", "Lada", "208"),
  vitesse = c("140", "280", "160", "85", "160"),
  id=c(1,2,4,5,6)
)


personnes%>%left_join(voitures)

class(personnes$id)
class(voitures$id)

#pour que cela fonctionne, on transforme l'id numérique en caractère
voitures$id <- as.character(voitures$id)

personnes%>%left_join(voitures)



####################################################Exercice 3################################################################
superheroes_stats <- read_delim(url("https://raw.githubusercontent.com/IACPouembout/Formation-R/main/data/superheroes_stats.csv"))


#Affichez le nombre de super héros par année

#Triez la table résultat selon le nombre croissant.

#Calculer l'intelligence moyenne selon le bien/mal (variable Alignment)

superheroes_info <- read_delim(url("https://raw.githubusercontent.com/IACPouembout/Formation-R/main/data/superheroes_info.csv"))

#Calculer le nombre de super héros par éditeur pour chaque année

#Ne conserver, pour chaque année, que le super héros ayant fait le plus d'apparitions au total

####################################################Exercice 4################################################################

#Faire la jointure de la table superheroes_stats sur la table superheroes_info à l’aide de left_join.

#À partir de la table résultant de l'exercice précédent, calculer l'intelligence moyenne des super héros gentils selon que leur identité soit secrète ou non
