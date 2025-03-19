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

cl <- kmeans(df.acm$li, centers=6, nstart=250, iter.max = 25)

centers = sort_by(data.frame(cl$centers), data.frame(cl$centers)[,c("Axis1", "Axis2")])

cl <- kmeans(df.acm$li, centers=centers)

df_ordre_pays = sort_by(df[,interest.variables.quali], df.acm$tab[,c(
      "Purchasing.Power.Category.Very.High",
      "Health.Care.Category.Very.High",
      "Safety.Category.Very.High",
      "Pollution.Category.Very.Low",
      
      "Purchasing.Power.Category.High",
      "Health.Care.Category.High",
      "Safety.Category.High",
      "Pollution.Category.Low", 

      "Purchasing.Power.Category.Moderate",
      "Health.Care.Category.Moderate",
      "Safety.Category.Moderate",
      "Pollution.Category.Moderate", 

      "Purchasing.Power.Category.Low",
      "Health.Care.Category.Low",
      "Safety.Category.Low",
      "Pollution.Category.High", 

      "Purchasing.Power.Category.Very.Low",
      "Health.Care.Category.Very.Low",
      "Safety.Category.Very.Low",
      "Pollution.Category.Very.High"
    )], decreasing = TRUE)

df_ordre_pays$ordre = 1:dim(df_ordre_pays)[1]


noms_correspondance <- c(
  "Guadeloupe" = "Guadeloupe",
  "Aland Islands" = "Åland",
  "Isle Of Man" = "Isle of Man",
  "Cayman Islands" = "Cayman Is.",
  "United States" = "United States of America",
  "Alderney" = "Alderney",
  "Sao Tome And Principe" = "São Tomé and Principe",
  "French Polynesia" = "Fr. Polynesia",
  "Vatican City" = "Vatican",
  "Faroe Islands" = "Faeroe Is.",
  "Saint-Pierre And Miquelon" = "St. Pierre and Miquelon",
  "Cook Islands" = "Cook Is.",
  "Us Virgin Islands" = "U.S. Virgin Is.",
  "Falkland Islands" = "Falkland Is.",
  "Czech Republic" = "Czechia",
  "Gibraltar" = "Gibraltar",
  "Hong Kong (China)" = "Hong Kong",
  "Reunion" = "Réunion",
  "Martinique" = "Martinique",
  "Macao (China)" = "Macao",
  "Eswatini" = "eSwatini",
  "Kosovo (Disputed Territory)" = "Kosovo",
  "Republic of the Congo" = "Congo",
  "Cape Verde" = "Cabo Verde",
  "Northern Mariana Islands" = "N. Mariana Is.",
  "Saint Vincent And The Grenadines" = "St. Vin. and Gren.",
  "Marshall Islands" = "Marshall Is.",
  "Bonaire" = "Bonaire",
  "Western Sahara" = "W. Sahara",
  "Saint Kitts And Nevis" = "St. Kitts and Nevis",
  "Turks And Caicos Islands" = "Turks and Caicos Is.",
  "French Guiana" = "French Guiana",
  "French Southern Territories" = "Fr. S. Antarctic Lands",
  "Bosnia And Herzegovina" = "Bosnia and Herz.",
  "Equatorial Guinea" = "Eq. Guinea",
  "Curacao" = "Curaçao",
  "Ivory Coast" = "Côte d'Ivoire",
  "Trinidad And Tobago" = "Trinidad and Tobago",
  "Dominican Republic" = "Dominican Rep.",
  "Solomon Islands" = "Solomon Is.",
  "Central African Republic" = "Central African Rep.",
  "Antigua And Barbuda" = "Antigua and Barb.",
  "British Virgin Islands" = "British Virgin Is.",
  "South Sudan" = "S. Sudan",
  "Democratic Republic of the Congo" = "Dem. Rep. Congo",
  "Wallis And Futuna" = "Wallis and Futuna Is."
)

nouveaux_noms <- rownames(df_ordre_pays)
for (nom in names(noms_correspondance)) {
  nouveaux_noms[nouveaux_noms == nom] <- noms_correspondance[nom]
}
rownames(df_ordre_pays) <- nouveaux_noms


# Map

couleurs <- colorRampPalette(c("blue", "red"))(nrow(df_ordre_pays))

library(leaflet)
library(sf)
library(rnaturalearth)
library(colorRamps)


# Obtenir les données géospatiales des pays
world <- ne_countries(scale = "medium", returnclass = "sf")

# Filtrer les pays présents dans le dataframe
world_filtered <- world[world$name %in% rownames(df_ordre_pays), ]


