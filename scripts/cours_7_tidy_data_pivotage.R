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
  pivot_longer(c("1999", "2000"), names_to = "year", values_to = "cases")

table4a%>%
  pivot_longer(c(2,3))


#sur l'exemple ci-dessous, combien y a t-il de variables ? Quelle opération effectuer ? 
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

preg%>%
  pivot_longer(male:female,names_to = "sex",values_to = "n")



##########################################Exercice 2######################################
#Le jeu de données relig_income présente la répartition des revenus par religion
#quel est le problème de ce jeu de données ? Effectuez l'opération nécessaire
relig_income
data("relig_income")

relig_income%>%
  pivot_longer(2:11,names_to = "income",values_to = "pop")


##########################################Exercice 3######################################
#Le jeu de données world_bank présente des indicateurs de la banque mondiale
#quel est le problème de ce jeu de données ? Combien d'opérations sont nécessaires ?
#Effectuez les opérations nécessaires pour restructurer ce jeu de données

data("world_bank_pop")
world_bank_pop%>%
  pivot_longer(3:20,names_to = "year")%>%
  pivot_wider(names_from = indicator,values_from = value)

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

##########################Separate_rows###############################################


df <- tibble(
  eleve = c("Félicien Machin", "Raymonde Bidule", "Martial Truc"),
  classe = c("6e", "5e", "6e"),
  notes = c("5,16,11", "15", "11,17")
)


df%>%
  separate_rows(notes)




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


#on peut compléter les valeurs manquantes implicites avec values_fill
stocks %>% 
  pivot_wider(names_from = year, values_from = return,values_fill = list(return = 0),names_expand =T) 

#les valeurs manquantes implicites/explicites peuvent être complétées avec la fonction complete()
stocks%>%  complete(year,qtr,fill = list(return=0))%>%
  pivot_wider(names_from = year, values_from = return) 
#il est important de vérifier que les valeurs manquantes sont complétées lorsqu'il y en a, cela peut avoir des conséquences sur les résultats des opérations

df <- tibble(
  eleve = c("Alain", "Alain", "Barnabé", "Chantal"),
  matiere = c("Maths", "Français", "Maths", "Français"),
  note = c(16, 9, 17, 11)
)



df %>% group_by(eleve)%>%summarise(note_moyenne=mean(note,na.rm=T))

df %>% complete(eleve,matiere, fill = list(note = 0))%>%
  group_by(eleve)%>%summarise(note_moyenne=mean(note,na.rm=T))


#value_drop_na pour omettre les valeurs manquantes
stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE)


stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = FALSE)

