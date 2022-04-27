pacman::p_load("ggplot2movies","tidyverse")
data('movies')

#1 Créez une nouvelle variable présentant la note (rating) centrée (dont on a soustrait la moyenne)
#2 Créez un nouveau dataframe ne contenant que les films sortis après 2000
#3 Utilisez select pour ne garder que les variables title, year, budget, length, rating et votes, de 3 façons différentes 
#4 Groupez les films par année et calculez le budget moyen par année
#5 Représentez graphiquement cette évolution
#6 Avec le pipe, enchainez les opérations suivantes : 
    #filtrez les films sortis après 1990,
    #sélectionnez les mêmes variables que prédemment, avec les variables mpaa, Action et Drama
    #Groupez par mpaa et Action
    #Obtenez la note moyenne


pacman::p_load("gapminder","tidyverse")

data("gapminder")

#1 Calculez l'espérance de vie moyenne par continent en 1952, 1962, 1972, 1982,1992 et 2002
#2 Représentez graphiquement le lien entre PIB/hab et espèrance de vie en 1952 et en 2007, 
    #en colorant par continent et en faisant appraitre la taille de la population
#3 Calculez le PIB/hab le plus élevé et le moins élevé par continent en 1952 et en 2007
#4 utilisez pivot_longer pour réunir les 3 variables en une seule (une colonne indiquant la variable concernée, une autre la valeur)
   #calculez la valeur moyenne de chaque variable par continent et année
   #visulalisez l'évolution de ces 3 indicateurs par continent en même temps, via ggplot() et facet_grid()
