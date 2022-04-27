#######################Cours 5 : visualisation de donnees ##############################################################################
if(!require("pacman"))install.packages("pacman")

pacman::p_load("tidyverse",
               "here","ggthemes","ggThemeAssist","questionr")



######################################################Grammaire de ggplot##########################################################

data("rp2018")
rp <- filter(
  rp2018,
  departement %in% c("Oise", "Rhône", "Hauts-de-Seine", "Lozère", "Bouches-du-Rhône")
)

# avec ggplot() on definit la source de donnees
# avec aes (aesthetics) on definit les variables x et y
# avec les geom_ on choisit le type de graphique

ggplot(rp) + geom_point(aes(x = dipl_sup, y = cadres))


# On peut rajouter divers parametres
# size pour changer la taille
# color pour changer la couleur
#alpha pour la transparence
ggplot(rp,aes(x = dipl_sup, y = cadres)) +
  geom_point(color = "darkgreen", size = 3, alpha = 0.3
  )

# Un mappage, dans ggplot2, est une mise en relation entre un attribut graphique du geom (position, couleur, taille…) 
# et une variable du tableau de données.
# exemple ici :
# en abscisse la part des diplômés du supérieur, en ordonnée la part des cadres
# La couleur représente le département, la taille le nombre d'habitant, la transparence la part de maisons

ggplot(rp) +
  geom_point(
    aes(x = dipl_sup, y = cadres, size = pop_tot,color=departement))




#On peut sauvegarder les graphiques avec ggsave
ggsave(width = 13,height = 9,here("geom_point.png"))

##########################################################Exemples de geom###########################################################

######################################################Geom_text et Geom_label######################################################

ggplot(rp) +
  geom_text(
    aes(x = dipl_sup, y = cadres, label = commune)
  )

#Si on veut changer une couleur sans la mettre en relation avec une variable
#il faut le faire à l'extérieur de aes()

ggplot(rp) +
  geom_text(
    aes(x = dipl_sup, y = cadres, label = commune),
    color = "darkred", size = 2
  )



#geom_label fonctionne sur le même principe que geom_text
ggplot(rp) + geom_label(aes(x = dipl_sup, y = cadres, label = commune))



######################################################Geom_line#####################################################


ggplot(economics) + geom_line(aes(x =date, y = pop))


###################################################Geom_boxplot######################################################
ggplot(rp) + geom_boxplot(aes(x = departement, y = maison))

# fill = couleur de remplissage

ggplot(rp) +
  geom_boxplot(aes(x = departement, y = maison),
    fill = "wheat", color = "tomato4"
  )

# avec varwidht = TRUE on peut faire varier la largeur des boites selon les effectifs d'une classe
ggplot(rp) +
  geom_boxplot(aes(x = departement, y = maison), varwidth = TRUE)



##################################################Geom_bar###################################################

# avec les graphiques en baton, on peut faire du simple comptage en ne designant qu'une seule variable
ggplot(rp) + geom_bar(aes(x = departement))
#dans ce cas, la variable manquante sera simplement l'effectif du jeu de donnees

#on peut changer le sens de l'axe en le mettant en y
ggplot(rp) + geom_bar(aes(y = departement))

#ou en utilisant la fonction coord_flip
ggplot(rp) + geom_bar(aes(x = departement))+
  coord_flip()



#ici aussi on peut visualiser plusieurs variables avec le mapping

ggplot(rp) + geom_bar(aes(x = departement, fill = pop_cl))


# avec l'argument position, on peut changer la position des batons

#les uns a cotes des autres
ggplot(rp) + geom_bar(aes(x = departement, fill = pop_cl),position = position_dodge2()) +
  coord_flip()

#ou en valeur relative
ggplot(rp) +
  geom_bar(
    aes(x = departement, fill = pop_cl),
    position = "fill"
  )


########################################Utiliser plusieurs sources de donnnées#####################################

#On peut associer à différents geom des sources de données différentes. 
#exemple ici, on va afficher uniquement le label des communes de plus de 5k habitants
com50 <- filter(rp, pop_tot >= 50000)


ggplot(data = rp, aes(x = dipl_sup, y = cadres)) +
  geom_point(alpha = 0.2) +
  geom_text(
    data = com50, aes(label = commune),
    color = "red", size = 3
  )
#####################################Faceting###########################################################

#Le faceting permet d’effectuer plusieurs fois le même graphique selon les valeurs d’une ou plusieurs variables qualitatives.
#Exemple  la part des cadres selon le département, avec un histogramme pour chacun de ces départements.
ggplot(data = rp) +
  geom_histogram(aes(x = cadres)) +
  facet_wrap(~departement)

#facet_grid fonctionne sur le meme principe
ggplot(data = rp) +
  geom_histogram(aes(x = cadres)) +
  facet_grid(~departement)


#On peut combiner deux variables pour le faceting
ggplot(data = rp) +
  geom_histogram(aes(x = cadres)) +
  facet_grid(departement~pop_cl)
  

#####################################Scales###########################################################



#Les scales dans ggplot2 permettent de modifier la manière dont un attribut graphique va être relié aux valeurs d’une variable, 
#et dont la légende correspondante va être affichée. Par exemple, 
#pour l’attribut color, on pourra définir la palette de couleur utilisée. 
#Pour size, les tailles minimales et maximales, etc.

#scale_size

ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, size = pop_tot)) +
  scale_size(range = c(0, 20))


ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, size = pop_tot)) +
  scale_size(range = c(2, 8))


ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, size = pop_tot)) +
  scale_size(
    "Population",
    range = c(0, 15),
    breaks = c(1000, 5000, 10000, 50000)
  )

#scale_continuous

ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres)) +
  scale_x_continuous(limits = c(0,100)) +
  scale_y_continuous(limits = c(0,100))



ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres)) +
  scale_x_continuous("Part des diplômés du supérieur (%)", limits = c(0,100)) +
  scale_y_continuous("Part des cadres (%)", limits = c(0,100))


#scale_log
ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres)) +
  scale_x_log10("Diplômés du supérieur")

# scale_color et scale_fill


#variables quantitatives
ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, color = chom))

#scale_color_gradient
ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, color = chom)) +
  scale_color_gradient("Taux de chômage", low = "white", high = "red")


#viridis
ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, color = chom)) +
  scale_color_viridis_c("Taux de chômage")


ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, color = chom)) +
  scale_color_viridis_c("Taux de chômage", option = "plasma")
#distiller

ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, color = chom)) +
  scale_color_distiller("Taux de chômage", palette = "Spectral")
#variables qualitatives

ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, color = departement))


ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, color = departement)) +
  scale_color_manual(
    "Département",
    values = c("red", "#FFDD45", rgb(0.1,0.2,0.6), "darkgreen", "grey80")
  )

ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, color = departement)) +
  scale_color_brewer("Département", palette = "Set1")

#liste des couleurs
RColorBrewer::display.brewer.all()

#themes
ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, color = departement)) +
  scale_color_brewer("Département", palette = "Set1")+
  theme_minimal()

#labs
ggplot(rp) +
  geom_point(aes(x = dipl_sup, y = cadres, color = departement)) +
  scale_color_brewer( palette = "Set1")+
  theme_minimal()+
  labs(y="Part des cadres (%)",x="Part des diplomés du supérieur (%)",title = "Cadres et diplomes")

#package esquisse pour s'entrainer 


#install.packages("esquisse")
#library(esquisse)


#############################################Exercices##########################################################################################

# on commence par charger les extensions nécessaires et les données du jeu de données rp2018. 
#On crée alors un objet rp69 comprenant uniquement les communes du Rhône et de la Loire.

library(tidyverse)
library(questionr)
data(rp2018)

rp69 <- filter(rp2018, departement %in% c("Rhône", "Loire"))

#############################################Exercice 1 ############################################################

#Faire un nuage de points croisant le pourcentage de sans diplôme (dipl_aucun) et le pourcentage d’ouvriers (ouvr).

#############################################Exercice 2 ############################################################
#Représenter la répartition du pourcentage de propriétaires (variable proprio) 
#selon la taille de la commune en classes (variable pop_cl) sous forme de boîtes à moustaches.


#############################################Exercice 3 ############################################################

#Représenter la répartition du nombre de communes selon la taille de la commune en classes sous la forme d’un diagramme en bâtons.

#############################################Exercice 4 ############################################################

#Faire un nuage de points croisant le pourcentage de sans diplôme et le pourcentage d’ouvriers. 


#############################################Exercice 5 ############################################################

#Représenter la répartition du pourcentage de propriétaires (variable proprio) selon la taille de la commune en classes (variable pop_cl) 
#sous forme de boîtes à moustaches. Faire varier la couleur de remplissage (attribut fill) selon le département.


#############################################Exercice 6 ############################################################

#Faire le nuage de points croisant pourcentage de chômeurs (chom) et pourcentage de sans diplôme. 
#Y ajouter les noms des communes correspondant (variable commune), en rouge et en taille 2.5
#Faire varier la couleur selon le département (departement).
#Essayer de n'afficher que le nom des communes ayant plus de 15% de chômage
