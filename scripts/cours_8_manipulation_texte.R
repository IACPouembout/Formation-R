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


####################################################### Remplacer des motifs #######################################################

str_replace_all(d$nom, "Mr", "M.")

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
