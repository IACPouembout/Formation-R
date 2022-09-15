
######################Exercice 1##############################
pacman::p_load("ggplot2movies","tidyverse")
data('movies')
 
#1 Créez une nouvelle variable présentant la note (rating) centrée (dont on a soustrait la moyenne)

movies <- mutate(movies,rating_cent=rating-mean(rating,na.rm=T))
movies$rating_cent <-  movies$rating - mean(movies$rating)

#2 Créez un nouveau dataframe ne contenant que les films sortis après 2000

movies_2000 <- filter(movies,year>2000)

#3 Utilisez select pour ne garder que les variables title, year, budget, length, rating et votes, de 3 façons différentes 

select(movies,title, year, budget, length, rating, votes)

movies%>%
  select(c(1:6,8))

movies%>%
  select(-c(7:27))


#4 Groupez les films par année et calculez le budget moyen par année

budget_moyen <- movies%>%
  group_by(year)%>%
  summarise(budget_moyen=mean(budget,na.rm=T))


#5 Représentez graphiquement cette évolution
options(scipen = 999)
ggplot(budget_moyen,aes(x=year,y=budget_moyen))+
  geom_line()

#6 Avec le pipe, enchainez les opérations suivantes : 
    #filtrez les films sortis après 1990,
    #sélectionnez les mêmes variables que prédemment, avec les variables mpaa, Action et Drama
    #Groupez par mpaa et Action
    #Obtenez la note moyenne

note_moyenne <-  movies%>%
  filter(year>1990)%>%
  select(1:6,mpaa,Action,Drama)%>%
  group_by(mpaa,Action)%>%
  summarise(note_moyenne=mean(rating,na.rm=T))



######################Exercice 2##############################
pokemon <- read_delim(url("https://raw.githubusercontent.com/mwdray/datasets/master/pokemon_go_captures.csv"))
pokedex <- read_delim(url("https://raw.githubusercontent.com/mwdray/datasets/master/pokedex_simple.csv"))

#1 Joignez les tables pokemon et pokedex pour obtenir des informations supplémentaires
pokemon2 <- inner_join(pokedex,pokemon)

#2 Comptez le nombre de pokemon par type1
pokemon2%>%
  count(type1)


#3 Créez une variable "Double type" séparant les pokemon entre ceux qui n'ont qu'un seul type, et ceux qui en ont 2
pokemon2 <- pokemon2%>%
  mutate(double_type=ifelse(is.na(type2)==TRUE,"Un seul type","Deux types"))



#4 Comptez le nombre de pokemon par double type et type1, quel type1 comprend la part la plus importante de double type ?
pokemon2%>%
  count(type1,double_type)%>%
  group_by(type1)%>%
  mutate(percent=n/sum(n,na.rm = T))%>%
filter(double_type=="Deux types")%>%
    arrange(desc(percent))





#5 Calculez les statistiques de combat moyenne, médianes, minimum et maximum selon le double type

pokemon2%>%
  group_by(double_type)%>%
  summarise(combat_mean=mean(combat_power,na.rm=T),
            combat_median=median(combat_power,na.rm = T),
            combat_min=min(combat_power,na.rm = T),
            combat_max=max(combat_power,na.rm = T))



######################Exercice 3##############################

pacman::p_load("gapminder","tidyverse")

data("gapminder")

#1 Calculez l'espérance de vie moyenne par continent en 1952, 1962, 1972, 1982,1992 et 2002
gapminder%>%
  filter(year %in% c(1952, 1962, 1972, 1982,1992, 2002))%>%
  group_by(year,continent)%>%
  summarise(life_exp_mean=mean(lifeExp,na.rm=T))



#2 Représentez graphiquement, le lien entre PIB/hab et espérance de vie par pays en 1952 et en 2007, 
#en colorant par continent et en faisant apparaître la taille de la population
gap2 <-   gapminder%>%filter(year %in% c(1952,2007))
ggplot(gap2,aes(x=gdpPercap,y=lifeExp,color=continent,size=pop))+
  geom_point()+
  facet_wrap(~year,scales = "free_x")+
  theme_bw()+
  scale_color_brewer(palette ="Set2")


#3 Quel pays a le PIB/hab le plus élevé et le moins élevé par continent en 1952 et en 2007 ?

gapminder%>%
  filter(year%in% c(1952,2007))%>%
  group_by(year,continent)%>%
  slice_max(gdpPercap)

gapminder%>%
  filter(year%in% c(1952,2007))%>%
  group_by(year,continent)%>%
  slice_min(gdpPercap)


######################Exercice 4##############################

pacman::p_load("tidyverse")
poll <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-05-31/poll.csv')
reputation <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-05-31/reputation.csv')

#1 Calculez, par thématique, la réputation par secteur industriel
#2 Quel secteur a la meilleure réputation dans le domaine 'ETHICS' ? lequel a la pire réputation dans ce domaine ?
#3 Par rapport à 2021, quelles sont les 10 entreprises ayant connu la plus forte progression de rang en 2022 ? Quelles sont les 10 ayant connu la plus forte baisse ?
#4 Représentez graphiquement ces changements de rangs

######################Exercice 5##############################

unvotes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-23/unvotes.csv')
#unvotes contient la liste de tous les votes à l'ONU par pays, l'objet du vote est identifié par rcid
roll_calls <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-23/roll_calls.csv')
#roll_calls contient la liste de chaque vote par session depuis 1946, classés comme importants ou non par le département d'Etat américain
issues <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-23/issues.csv')
#issue identifie la thématique selon le vote

#1 Ne gardez que les votes considérés comme importants pour les USA, calculez  par année le nombre de vote en accord avec les USA selon les sujets

#2 Représentez graphiquement cette évolution

#3 Calculez, sur les votes considérés comme importants pour les USA, les 10 pays votant le plus en accord avec les USA, et les dix pays votant le plus en désaccords

#4 Au sein des votes en désaccords avec les USA, quelle est la thématique la plus importante ? quelle part des désaccords représente t-elle?

######################Exercice 6##############################
colony <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-01-11/colony.csv')
stressor <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-01-11/stressor.csv')

#1 Calculez, pour chaque Etat, le nombre moyen de colonies d'abeilles en 2015 et en 2020, puis le nombre moyen de colonies d'abeilles en +/- entre ces 2 périodes
   #quel Etat a le plus gagné de colonies d'abeilles entre les 2 périodes, lequel en a le plus perdu ?


#2 Calculez, pour chaque Etat en 2015 en 2020, le nombre de colonies d'abeilles atteints par des facteurs de stress
 #quelle est la 1ere cause de stress des abeilles pour chacune de ces années ?


