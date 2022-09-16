#######################Cours 8 : manipuler du texte##############################################################################


pacman::p_load("tidyverse",
               "snakecase")


#######################################################Manipuler du texte avec stringr#####################################################
d <- tibble(
  nom = c("mr Félicien Machin", "mme Raymonde Bidule", "m. Martial Truc", "mme Huguette Chose"),
  adresse = c("3 rue des Fleurs", "47 ave de la Libération", "12 rue du 17 octobre 1961", "221 avenue de la Libération"),
  ville = c("Nouméa", "Marseille", "Vénissieux", "Marseille")
)




####################################################### Concaténation #######################################################
#paste pour concatener 2 caracteres, sep= pour choisir le separateur

paste(d$adresse, d$ville)

paste(d$adresse, d$ville, sep = " - ")

#paste0 pour une concatenation sans espace
paste0(d$adresse, d$ville)

#on peut aussi concatener l'ensemble des caracteres d'un vecteur
paste(d$ville, collapse = ", ")

####################################################### Convertir en majuscule/minuscule #######################################################

#package stringr
str_to_lower(d$nom)

str_to_upper(d$nom)

str_to_title(d$nom)

str_to_sentence(d$nom)

#package snakecase
to_snake_case(d$nom)

to_lower_upper_case(d$nom)

to_lower_camel_case(d$nom)

to_screaming_snake_case(d$nom)
####################################################### Découper des chaines #######################################################

#stringr
str_split("un-deux-trois", "-")

str_split(d$nom, " ")

str_split(d$nom, " ", simplify = TRUE)

#tidyr
d%>%
  separate(nom,c("genre", "prenom", "nom"),sep=" ")


#######################################################Extraire des sous chaines par position #######################################################

#str_sub(vecteur,debut,fin)
str_sub(d$ville, 1, 3)

#nombres négatifs pour partir de la fin
str_sub(d$ville,-3)


#######################################################Détecter des motifs #######################################################

str_count(d$ville, "s")

str_subset(d$adresse, "Libération")

bananas <- c("banana", "Banana", "BANANA")
str_detect(bananas, "banana")

#regex et ignore_case pour ignorer la case
str_detect(bananas, regex("banana", ignore_case = TRUE))


####################################################### Extraire des motifs #######################################################
x <- c("apple", "banana", "pear")

str_extract(x, "an")

#avec le . , on extrait le motif et les lettres avant et après, ne fonctionne pas si pas de lettre avant
str_extract(x, ".a.")
#un . apres = le a et la lettre qui suit
str_extract(x, "a.")

#comment détecter un point du coup ?
#il faut utiliser les \\ pour mentionner explicitement une ponctuation

str_extract(c("abc", "a.c", "bef"), "a\\.c")

# deux \\ = un seul \
x <- "a\\b"
cat(x)
#pour mentionner explicitement \\, il faut utiliser \\\\\
str_extract(x, "\\\\")

#extraire des nombres
#l'expression [:digit:] permet d'extraire des chiffres allant de 1 à 9
str_extract(d$adresse,"[:digit:]")

#les expressions régulières sont basés sur le standard POSIX 1003.2
#– [:alnum:] : tous les caractères alphanumériques.
#– [:alpha:] : les caractères alphabétiques uniquement, en majuscule et en minuscule.
#– [:blank:] : des caractères « blancs », types espace ou tabulation
#– [:cntrl:] : un caractère de contrôle
#– [:digit:] : un chiffre de 0 à 9
#– [:graph:] : un caractère graphique, c’est-à-dire alphanumérique ou de ponctuation.
#– [:lower:] : un caractère en minuscule
#– [:print:] : un caractère imprimable
#– [:punct:] : une ponctuation : !  » # $ % & ‘ ( ) * + , – . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~.
#– [:space:] : un espace (tabulation, nouvelle ligne, retour chariot…)
#– [:upper:] : un caractère en majuscule
#– [:xdigit:] : un caractère du système hexadécimal : 0 1 2 3 4 5 6 7 8 9 A B C D E F a b c d e f.

# on peut utiliser série de quantifieurs, pour déterminer la position ou la répétition d’un caractère de substitution :
#  . : renvoie à n’importe quel caractère
#^ : le caractère suivant est au début d’une chaine
#$ : le caractère suivant est en fin de chaine
#– ? : le caractère précédent est optionnel, et ne devra être trouvé qu’une seule fois
#– * : le caractère sera trouvé zéro fois ou plus
#– + : le caractère sera trouvé une fois ou plus
#– {n} : le caractère sera trouvé n fois
#– {n,} : le caractère sera trouvé au moins n fois
#{n,m} : le caractère sera trouvé entre n et m fois.


#si on veut extraire des nombres, il faut utiliser l'expression régulière \\d+
str_extract(d$adresse, "\\d+")

#la fonction parse_number remplit également ce role
parse_number(d$adresse)

#avec str_extract_all on peut extraire plus d'un motif

str_extract_all(d$adresse,"[:digit:]")

str_extract_all(d$adresse, "\\d+")


#la fonction extract permet de créer directement une variable qui contiendra le motif extrait
#ici l'expression régulière ^\\d+ (.*?) va extraire le motif qui suit le nombre

d %>% extract(adresse, "type_rue", "^\\d+ (.*?) ", remove = FALSE)



####################################################### Remplacer des motifs #######################################################

str_replace_all(d$nom, "Mr", "M.")
#on remarque ici que "mr" étant en majuscule, il n'a pas été remplacé par M.
#mais si on ignore la case avec regex, on remplace les Mr majuscules et minuscules
str_replace_all(d$nom, regex("Mr",ignore_case = T), "M.")

#on peut mentionner plusieurs remplacements
str_replace_all(
  d$adresse,
  regex(c( "avenue" = "Avenue", "ave" = "Avenue", "rue" = "Rue"),ignore_case = T))


####################################################### Supprimer des espaces #######################################################


d <- tibble(
  nom = c("        mr Félicien Machin", "mme Raymonde Bidule        ", "   m. Martial          Truc      ", "     mme Huguette Chose"))

d$nom2 <- str_trim(d$nom)

d$nom3 <-  str_squish(d$nom)


####################################################### Exercices #######################################################
#########Exercice 1#######################
d <- tibble(
  nom = c("M. rené Bézigue", "Mme Paulette fouchin", "Mme yvonne duluc", "M. Jean-Yves Pernoud"),
  naissance = c("18/04/1937 Vesoul", "En 1947 à Grenoble (38)", "Le 5 mars 1931 à Bar-le-Duc", "Marseille, juin 1938"),
  profession = c("Ouvrier agric", "ouvrière qualifiée", "Institutrice", "Exploitant agric")
)

# 1 Capitalisez les noms des personnes 
# 2 Dans la variable profession, remplacer toutes les occurrences de l’abbréviation “agric” par “agricole” 
# 3 À l’aide de str_detect, identifier les personnes de catégorie professionnelle “Ouvrier”.

d1 <- d%>%
  mutate(nom=str_to_title(nom),
         profession=str_replace_all(profession,"agric","agricole"),
         ouvrier=str_detect(profession,regex("ouvr",ignore_case = T)),
         
         sexe=case_when(str_detect(nom ,regex("M\\.",ignore_case = T))==T~"Homme",
                        str_detect(nom,regex("Mme",ignore_case = T))==T~"Femme"),
         sexe2=ifelse(str_detect(nom ,regex("M\\.",ignore_case = T))==T,"Homme","Femme"))
      
# 4 créer une nouvelle variable sexe identifiant le sexe de chaque personne en fonction de la présence de M. ou de Mme dans son nom.


#########Exercice 2#######################
pacman::p_load(gapminder,tidyverse)
data("gapminder")

df <- gapminder%>%
  select(country,continent)%>%
  unique()
df%>%
  summarise(longueur_m=mean(str_length(country)))
# 1 Quelle est la longueur moyenne des noms de pays ?
# 2 Extraire les première et dernière lettre de chaque nom de pays. Et représenter graphiquement leur distribution respective.
df <- df%>%
  mutate(premiere_lettre=str_sub(country,0,1),
         derniere_lettre=str_sub(country,-1)
         )
df2 <-  df%>%
  pivot_longer(3:4,names_to = "type_lettre",values_to = "lettre")

comptage_lettre <- df2%>%
  count(type_lettre,lettre)

ggplot(comptage_lettre,aes(x = n,y=fct_reorder(lettre,n)))+
  geom_bar(stat = "identity")+
  facet_wrap(~type_lettre,scales = "free")


# 3 Quel pays a le mot and dans son nom ?
# 4 Supprimer toutes les occurences de “,” et “.” dans les noms de pays.
# 5 Raccourcir les noms de pays plus long en arrêtant au 11ème caractère et en ajoutant un point. Par exemple, United States becomes United Stat..
# 6 Convertir les noms de pays en minuscule et trouve le caractère le plus fréquent dans les noms de pays. Est-ce similaire dans les différents continents ?
# 7 Maintenant que vous savez quelle est la lettre la plus fréquente, quel est le pays qui la contient le plus de fois ?
  
####################################### Gestion des dates avec lubdridate############################################
pacman::p_load("lubridate")

today()
now()

#Il existe 3 classes de date/temps dans R: Date, POSIXct (calendar time) et POSIXlt (local time)
class(today())
class(now())

#on peut extraire des informations sur les dates avec les fonctions de lubridate
#il faut tenir compte de l'ordre année/mois/jour (fonction ymd dans ce cas) 
ymd("06 02 04")
ymd("20060204")
ymd("2006 2 4")
ymd("2006 : 2///04")
ymd(060204)  

#si les dates sont de type jour/mois/année, fonction dmy
dmy("4 2 06")
dmy("04 02 2006")

#si les dates sont de type mois/jour/année, fonction mdy
mdy("02 04 06")
mdy(020406)  


#toutes les combinaisons sont possibles
myd("06 02 04")
dym("06 02 04")


#on peut créer nos propres dates avec make_date
make_date(year = 2020, month = 7, day = 13) 

#il s'agit de données de classe Date
is.Date(make_date(year = 2020))
is.POSIXct(make_date(year = 2020))


d1 <- make_date(year = 2020, month = 7, day = 13) 
d2 <- make_date(year = 2019, month = 7, day = 13) 

#on peut faire des opérations de calculs
d1-d2 # différence en jour

as.numeric(d1-d2) # différence en jour
interval(d2,d1)/days(1)
as.period(interval(d2, d1), unit = "days")


as.numeric(d1-d2)/30.5 # différence en mois
interval(d2,d1)/months(1)
as.period(interval(d2, d1), unit = "months")


as.numeric(d1-d2)/365.25 # en année
interval(d2,d1)/years(1)
as.period(interval(d2, d1), unit = "year")


#on peut arrondir avec floor_date

floor_date(d1,unit = "month")
floor_date(d1,unit = "year")


#on peut passer en format POSIXct avec make_dattime
make_datetime(year = 2020, month = 7, day = 13, 
              hour = 10, min = 30, sec = 45, tz = "Europe/Zurich")

make_datetime(year = 2020, month = 7, day = 13, 
              hour = 10, min = 30, sec = 45, tz = "Pacific/Guadalcanal")


is.Date(make_datetime(year = 2020))
is.POSIXct(make_datetime(year = 2020))


#on peut extraire des élements de date avec les fonctions correspondantes
year(today())
month(today())
week(today())
day(today())
wday(today())
wday(today(),label = T)
wday(today(),label = T,locale = "eng")
hour(now())
minute(now())
second(now())


Sys.timezone() 

#######################################Exercice##############################################

#1 utilisez les fonctions appropriées pour extraire chacune des dates
d1 <- "January 20, 2020"
d2 <- "2020-Apr-01"
d3 <- "11-Nov-2020"
d4 <- c("July 13 (1969)", "August 23 (1972)", "July 1 (1975)")
                 # Date: 
d5 <- "08/12/10" # Oct 12, 2008
d6 <- d5         # Aug 12, 2010
d7 <- d5         # Oct 08, 2012


pacman::p_load("ds4psy")
data("fame")
# 2 le jeu de données fame contient les dates de naissances (DOB) et de décès (DOD) de personnes célèbres
# convertissez ces deux variables au format date

# 3 Créez deux variables indiquant pour l'une le jour (de lundi à dimanche) de leur naissance et l'autre de leur décès

# 4 Créez une variable mesurant leur âge en jour et une autre en année
# attention à la différence de traitement entre les personnes décédées et celles encore en vie
