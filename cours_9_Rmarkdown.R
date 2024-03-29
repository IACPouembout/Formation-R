## ----setup, include=FALSE-----------------------------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
#pacman::p_load("tinytex")
#tinytex::install_tinytex()
pacman::p_load(knitr,kableExtra,flextable,gt,tidyverse)




## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
summary(cars)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
plot(pressure)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
x <- 1:5


## ----mon_bloc, echo = FALSE, warning = TRUE-----------------------------------------------------------------------------------------------------------------------------------
x <- 1:5


## ----echo = FALSE, warning = FALSE--------------------------------------------------------------------------------------------------------------------------------------------
x <- 1:5



## ----mon_bloc2----------------------------------------------------------------------------------------------------------------------------------------------------------------
x <- 1:5
print(x)


## ----mon_bloc3, echo=FALSE----------------------------------------------------------------------------------------------------------------------------------------------------
x <- 1:5
print(x)


## ----mon_bloc4----------------------------------------------------------------------------------------------------------------------------------------------------------------

tailles <- c(160,170,200,157,168,190)
poids <-  c(45, 59, 110, 44, 88, 100)
au_hasard <- runif(1,min = 0,max=100000)
taille_moyenne <- mean(tailles)
poids_moyen <- mean(poids)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

tailles_poids <- tibble::tibble(Taille=tailles,Poids=poids)
knitr::kable(tailles_poids)



## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

tailles_poids%>%
  flextable()%>%
  autofit()



## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
tailles_poids%>%
  gt()


