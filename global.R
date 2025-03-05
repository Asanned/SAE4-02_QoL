# Initialisation des bibliothèques utilisées ----
library(shiny)
library(shinydashboard)

# Import et préparation des données ----
## Import des données ----
df = read.csv2("data/Quality_of_Life.csv")

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
  } else if (substring(variable, nchar(variable) - 7, nchar(variable)) == "Category"){
    df[[variable]] = as.factor(df[[variable]])
  }
}




print(str(df))
