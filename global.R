# Initialisation des bibliothèques utilisées ----
library(shiny)
library(shinydashboard)
library(tidyverse)
library(ade4)
library(FactoMineR)
library(factoextra)
library(DT)
library(plotly)
library(graphics)
#library(fontawesome) # pour avoir de jolie icon <3

interest.variables.quanti = c("Purchasing.Power.Value", "Safety.Value", "Health.Care.Value", "Pollution.Value")
interest.variables.quali = c("Purchasing.Power.Category", "Safety.Category", "Health.Care.Category", "Pollution.Category")

# Import et préparation des données ----
## Import des données ----
df = read.csv2("data/Quality_of_Life.csv")
row.names(df) = df$country
df = df[,-1]
numeric.variables = c()
qualitative.variables = c()

## Préparation des données ----
for (variable in names(df)){
  ### Remplacement des valeurs "0.0" par des NULL ----
  # Cette étape est facilité par le fait que la fonction read.csv2() ne transforme aucune variable, les laissant en chaine de caractères.
  # On fait donc cette étape en première, avant le changement du type des variables.
  # Nous ne pouvons pas faire cette étape après, car la transformation en type numeric va mixer les valeurs "0.0" (NULL) et les "0.00" (vrai 0)
  df[[variable]] = replace(df[[variable]], df[[variable]] == "0.0", NA)

  ### Changement du type des variables ----
  if (substring(variable, nchar(variable) - 4, nchar(variable)) == "Value"){
    df[[variable]] = as.numeric(df[[variable]])
    numeric.variables = c(numeric.variables, variable)
  } else if (substring(variable, nchar(variable) - 7, nchar(variable)) == "Category"){
    df[[variable]] = as.factor(df[[variable]])
    qualitative.variables = c(qualitative.variables, variable)
  }
}


# AFCM
df.acm <- dudi.acm(df[,interest.variables.quali], scannf=FALSE, nf=2)





