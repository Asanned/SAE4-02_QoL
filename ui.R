dashboardPage(
  dashboardHeader(
    title = "Niveau de vie"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Analyse univariée", tabName = "univar"),
      menuItem("Analyse bivariée", tabName = "tab_anabi", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    includeCSS("www/styles.css"),
    tabItems(
      tabItem(tabName = "univar",
        box(
          selectInput("univar.variable", "Variable à afficher", choices = c(names(df)[-1])),
          textOutput("univar.out1"),
          plotOutput("univar.plot")
        )
      ),

      tabItem(
        tabName = "tab_anabi",
        fluidRow(
          box(
            width = 3,
            title = "Choix des variables",
            selectInput("select_varx_anabi", "Choix de la variable x:", choices = numeric.variables, selected = "Purchasing.Power.Value"),
            selectInput("select_vary_anabi", "Choix de la variable y:", choices = numeric.variables, selected = "Cost.of.Living.Value")
          ),
          box(
            width = 9,
            title = "Affichage du scatterplot",
            plotOutput("scatterplot_anabi")
          )
        )
      ),
    )
  )
)