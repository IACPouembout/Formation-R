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


####################################################### Remplacer des motifs #######################################################

str_replace_all(d$nom, "Mr", "M.")

str_replace_all(
  d$adresse,
  c("avenue" = "Avenue", "ave" = "Avenue", "rue" = "Rue")
)

