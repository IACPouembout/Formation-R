#######################Cours 7 : tidy data et pivotage ##############################################################################


pacman::p_load("tidyverse")


##########################################Pivot longer######################################
##Exemple de données désorganisées
table4a
table4b
#1999 et 2000 sont des colonnes différentes alors qu'il s'agit de la même variable : l'année
#On transforme donc ces données en tidy data via le pivotage
tidy4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")
left_join(tidy4a, tidy4b)


##########################################Pivot wider######################################

#autre type de données désorganisées : deux variables différentes en une seule
table2
#il faut alors pivoter les données dans l'autre sens
table2 %>%
  pivot_wider(names_from = type, values_from = count)


##########################################Exercice 1 ######################################

#Expliquez pourquoi cette ligne de code ne fonctionne pas ?

table4a %>% 
  pivot_longer(c(1999, 2000), names_to = "year", values_to = "cases")

#sur l'exemple ci-dessous, combien y a t-il de variables ? Quelle opération effectuer ? 
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

##########################################Exercice 2######################################
#Le jeu de données relig_income présente la répartition des revenus par religion
#quel est le problème de ce jeu de données ? Effectuez l'opération nécessaire
relig_income

##########################################Exercice 3######################################
#Le jeu de données world_bank présente des indicateurs de la banque mondiale
#quel est le problème de ce jeu de données ? Combien d'opérations sont nécessaires ?
#Effectuez les opérations nécessaires pour restructurer ce jeu de données
world_bank_pop



##########################################Separate ######################################

#separate permet de separer une seule colonne en 2, via un séparateur de type caractere
#exemple ici
table3
#la variable rate contient les données de deux variables, les cas et la population

table3 %>% 
  separate(rate, into = c("cases", "population"))

#par défaut, le caractere non alphanumérique sera utilisé comme séparateur
#mais il est possible de désigner tout caractère comme étant le séparateur
table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")
#ou de désigner une position

table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

##########################################Unite ######################################

#Unite est la fonction inverse de separate
table5 %>% 
  unite(new, century, year)

#par defaut, unite placera un _ entre les deux variables réunies, si l'on n'en veut pas, on désigne soit même le séparateur souhaité

table5 %>% 
  unite(new, century, year, sep = "")





##########################################Gestion des valeurs manquantes ######################################

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)


stocks %>% 
  pivot_wider(names_from = year, values_from = return)

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE)


