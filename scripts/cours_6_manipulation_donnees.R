#######################Cours 6 : Manipulation de données ##############################################################################
if(!require("devtools"))install.packages("devtools")
if(!require("pacman"))install.packages("pacman")
if(!require("Caledocensus"))devtools::install_github("https://github.com/IACPouembout/Caledocensus",force = TRUE,dependencies = FALSE)

pacman::p_load("tidyverse",
               "here","questionr","nycflights13")

library(Caledocensus)
rp19_ind <- Caledocensus::rp19_ind


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
filter(rp19_ind,GENRE=="Homme" & AGER >95)

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


####################################################### Enchainer les opérations avec % #######################################################

# Les lignes de codes sont liées les unes aux autres tant que le % est utilisé
rp19_ind%>%
  filter(PROV=="Sud")%>%
  select(ID,PROV,AGEA)%>%
  arrange(desc(AGEA))



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

#filtrage de l'age 
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



evo_pop_communes <- Caledocensus::evo_pop_communes

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

rp19_log <- Caledocensus::rp19_log

rp19_log%>%
  select(IDLOG)

rp19_ind%>%
  select(IDLOG)


#left_join pour les jointures de tables
left_join(rp19_ind,rp19_log)%>%
  select(IDLOG,AGEA,REFRI)

#by= pour sélectionner la variable de jointure
left_join(rp19_ind,rp19_log,by="IDLOG")%>%
  select(IDLOG,AGEA,REFRI,PROV.x,PROV.y)

#imaginons une clé qui ne porte pas le même non selon le jeu de données
rp19_log2 <- rp19_log%>%rename("id"="IDLOG")

#on le précise dans la fonction
left_join(rp19_ind,rp19_log2,by=c("IDLOG"="id"))

left_join(rp19_log2,rp19_ind,by=c("id"="IDLOG"))




personnes <- tibble(
  nom = c("Sylvie", "Sylvie", "Monique", "Gunter", "Rayan", "Rayan"),
  voiture = c("Twingo", "Ferrari", "Scenic", "Lada", "Twingo", "Clio")
)
voitures <- tibble(
  voiture = c("Twingo", "Ferrari", "Clio", "Lada", "208"),
  vitesse = c("140", "280", "160", "85", "160")
)

#La première colonne dépend de la 1ere table de jointure
voitures %>% left_join(personnes)
personnes %>% left_join(voitures)

#Différents types de jointures
personnes %>% inner_join(voitures)
personnes %>% full_join(voitures)
personnes %>% semi_join(voitures)
personnes %>% anti_join(voitures)


################################################################EXERCICES######################################################################

library(nycflights13)
data(flights)
data(airports)
data(airlines)

flights


####################################################Exercice 1################################################################

############Exo 1.1
#Sélectionner la dixième ligne du tableau des aéroports (airports).

#Sélectionner les 5 premières lignes de la table airlines.

#Sélectionner l’aéroport avec l’altitude la plus basse (variable alt).


###########Exo 1.2

#Sélectionnez les vols du mois de juillet (variable month).

#Sélectionnez les vols avec un retard à l’arrivée (variable arr_delay) compris entre 5 et 15 minutes.

#Sélectionnez les vols des compagnies Delta, United et American (codes DL, UA et AA de la variable carrier).

##########Exo 1.3

#Sélectionnez les vols des compagnies Delta, United et American (codes DL, UA et AA de la variable carrier).


##########Exo 1.4

#Sélectionnez les colonnes name, lat et lon de la table airports

#Sélectionnez toutes les colonnes de la table airports sauf les colonnes tz et tzone

#Sélectionnez toutes les colonnes de la table flights dont les noms se terminent par “delay”.

#Dans la table airports, renommez la colonne alt en altitude et la colonne tzone en fuseau_horaire.

##########Exo 1.5

#Dans la table airports, la colonne alt contient l’altitude de l’aéroport en pieds. 
#Créer une nouvelle variable alt_m contenant l’altitude en mètres 
#(on convertit des pieds en mètres en les divisant par 3.2808). 
#Sélectionner dans la table obtenue uniquement les deux colonnes alt et alt_m.



####################################################Exercice 2################################################################

#Réécrire le code de l’exercice précédent en utilisant le pipe %>%.

#En utilisant le pipe, sélectionnez les vols à destination de San Francico (code SFO de la variable dest) et triez-les selon le retard au départ décroissant (variable dep_delay).

#Sélectionnez les vols des mois de septembre et octobre, conservez les colonnes dest et dep_delay, 
#créez une nouvelle variable retard_h contenant le retard au départ en heures, et conservez uniquement les 5 lignes avec les plus grandes valeurs de retard_h.
  
####################################################Exercice 3################################################################

#Affichez le nombre de vols par mois

#Triez la table résultat selon le nombre de vols croissant.

#Calculer la distance moyenne des vols selon l’aéroport de départ (variable origin).

#Calculer le nombre de vols à destination de Los Angeles (code LAX) pour chaque mois de l’année.

#Calculer le nombre de vols selon le mois et la destination.

#Ne conserver, pour chaque mois, que la destination avec le nombre maximal de vols.

####################################################Exercice 4################################################################

#Faire la jointure de la table airlines sur la table flights à l’aide de left_join.

#À partir de la table résultat de l’exercice précédent, calculer le retard moyen au départ pour chaque compagnie, et trier selon ce retard décroissant.

#Faire la jointure de la table airports sur la table flights en utilisant comme clé le code de l’aéroport de destination. (dest et faa)

#À partir de cette table, afficher pour chaque mois le nom de l’aéroport de destination ayant eu le plus petit nombre de vol.