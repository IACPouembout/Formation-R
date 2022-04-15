#######################Cours 7 : manipuler du texte##############################################################################


pacman::p_load("tidyverse",
               "snakecase")


#######################################################Manipuler du texte avec stringr#####################################################
d <- tibble(
  nom = c("mr Félicien Machin", "mme Raymonde Bidule", "m. Martial Truc", "mme Huguette Chose"),
  adresse = c("3 rue des Fleurs", "47 ave de la Libération", "12 rue du 17 octobre 1961", "221 avenue de la Libération"),
  ville = c("Nouméa", "Marseille", "Vénissieux", "Marseille")
)





####################################################### Concaténation #######################################################

paste(d$adresse, d$ville)

paste(d$adresse, d$ville, sep = " - ")

paste0(d$adresse, d$ville)

paste(d$ville, collapse = ", ")
####################################################### Convertir en majuscule/minuscule #######################################################

str_to_lower(d$nom)

str_to_upper(d$nom)

str_to_title(d$nom)

str_to_sentence(d$nom)

to_snake_case(d$nom)

to_lower_upper_case(d$nom)

to_lower_camel_case(d$nom)

to_screaming_snake_case(d$nom)
####################################################### Découper des chaines #######################################################

str_split("un-deux-trois", "-")

str_split(d$nom, " ")

str_split(d$nom, " ", simplify = TRUE)

d%>%
  separate(nom,c("genre", "prenom", "nom"),sep=" ")


#######################################################Extraire des sous chaines par position #######################################################


str_sub(d$ville, 1, 3)


#######################################################Détecter des motifs #######################################################

str_count(d$ville, "s")

str_subset(d$adresse, "Libération")

bananas <- c("banana", "Banana", "BANANA")
str_detect(bananas, "banana")

str_detect(bananas, regex("banana", ignore_case = TRUE))

str_detect("\nX\n", regex(".X.", dotall = TRUE))


####################################################### Extraire des motifs #######################################################
x <- c("apple", "banana", "pear")

str_extract(x, "an")

str_extract(x, ".a.")

dot <- "\\."

writeLines(dot)

str_extract(c("abc", "a.c", "bef"), "a\\.c")

x <- "a\\b"
writeLines(x)

str_extract(x, "\\\\")


str_extract(d$adresse, "^\\d+")
str_extract_all(d$adresse, "\\d+")

d %>% extract(adresse, "type_rue", "^\\d+ (.*?) ", remove = FALSE)

parse_number(d$adresse)


str_extract(d$adresse,"[:digit:]")


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

superheroes_info <- read_delim(here("data","superheroes_info.csv"))
superheroes_stats <- read_delim(here("data","superheroes_stats.csv"))


####################################################Exercice 1################################################################

############Exo 1.1
#Sélectionner la 1ere ligne du superheroes_stats .

#Sélectionner les 5 premières lignes de la table superheroes_info.

#Sélectionner le super héros avec les meilleures statistiques totales


###########Exo 1.2

#Sélectionnez les super héros de DC

#Sélectionnez les super héros apparus avant 2000.


##########Exo 1.3

#Sélectionnez les super héros dont les yeux sont verts, bleus, et bruns


##########Exo 1.4

#Sélectionnez les colonnes Identity et Alignment de la tablesuper_heroes info

#Sélectionnez toutes les colonnes de la table super_heroes_info sauf les colonnes SkinColor et FirstAppearance

#Sélectionnez toutes les colonnes de la table super_heroes_info dont les noms se terminent par “color”.

#Dans la table superheroes_info, renommez la colonne Weight en poids et la colonne Height en taille.

##########Exo 1.5

##Dans la table superheroes_info, la colonne taille contient la taille en centimetre
#Créer une nouvelle variable taille_m contenant la taille en mètres 
#Sélectionner dans la table obtenue uniquement les deux colonnes taille et taille_m.



####################################################Exercice 2################################################################

#Réécrire le code de l’exercice précédent en utilisant le pipe %>%.

#En utilisant le pipe, sélectionnez les super héros de DC  et triez-les selon leur apparition par ordre croissant.

#Sélectionnez les super héros apparus entre 1960 et 1990, conservez les colonnes Year et Appearance 
#créez une nouvelle variable anciennete mesurant l'âge du Super héros depuis son apparition.
  
####################################################Exercice 3################################################################

#Affichez le nombre de super héros par année

#Triez la table résultat selon le nombre croissant.

#Calculer l'intelligence moyenne selon le bien/mal (variable Alignment)

#Calculer le nombre de super héros par éditeur pour chaque année

#Ne conserver, pour chaque année, que le super héros ayant fait le plus d'apparitions au total

####################################################Exercice 4################################################################

#Faire la jointure de la table superheroes_stats sur la table superheroes_info à l’aide de left_join.

#À partir de la table résultat de exercice précédent, calculer l'intelligence moyenne des super héros gentils selon que leur identité soit secrète ou non
