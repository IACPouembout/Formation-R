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

#on peut aussi concatener l'ensemble des catacteres d'un vecteur
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
  c("avenue" = "Avenue", "ave" = "Avenue", "rue" = "Rue")
)

####################################################### Exercices #######################################################

d <- tibble(
  nom = c("M. rené Bézigue", "Mme Paulette fouchin", "Mme yvonne duluc", "M. Jean-Yves Pernoud"),
  naissance = c("18/04/1937 Vesoul", "En 1947 à Grenoble (38)", "Le 5 mars 1931 à Bar-le-Duc", "Marseille, juin 1938"),
  profession = c("Ouvrier agric", "ouvrière qualifiée", "Institutrice", "Exploitant agric")
)

# 1 Capitalisez les noms des personnes avec str_to_title 
# 2 Dans la variable profession, remplacer toutes les occurrences de l’abbréviation “agric” par “agricole” 
# 3 À l’aide de str_detect, identifier les personnes de catégorie professionnelle “Ouvrier”. Indication : pensez au modificateur ignore_case.
# 4 À l’aide de case_when et de str_detect, créer une nouvelle variable sexe identifiant le sexe de chaque personne en fonction de la présence de M. ou de Mme dans son nom.
