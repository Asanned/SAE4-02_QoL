# Initialisation des bibliothèques utilisées ----
library(shiny)
library(shinydashboard)

# Import et préparation des données ----
## Import des données ----
df = read.csv2("data/Quality_of_Life.csv")

## Préparation des données ----
### Remplacement des valeurs "0.0" par des NULL ----
# Cette étape est facilité par le fait que la fonction read.csv2() ne transforme aucune variable, les laissant en chaine de caractères.
# On fait donc cette étape en première, avant le changement du type des variables.
# Nous ne pouvons pas faire cette étape après, car la transformation en type numeric va mixer les valeurs "0.0" (NULL) et les "0.00" (vrai 0)
for (variable in names(df)){
  df[[variable]] = replace(df[[variable]], df[[variable]] == "0.0", NA)
}

### Changement du type des variables ----


print(str(df))
