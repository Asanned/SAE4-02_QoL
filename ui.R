dashboardPage(
  dashboardHeader(
    title = "Niveau de vie"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Analyse univariée", tabName = "univar"),
      menuItem("Analyse bivariée", tabName = "bivar", icon = icon("dashboard")),
      menuItem("Tableau de contingence", tabName = "contingence"),
      menuItem("AFC", tabName = "AFC"),
      menuItem("ACP", tabName = "ACP")
    )
  ),
  dashboardBody(
    includeCSS("www/styles.css"),
    tabItems(
      tabItem(tabName = "univar",
        box(
          selectInput("univar.variable", "Variable à afficher", choices = c(names(df))),
          textOutput("univar.out1"),
          plotOutput("univar.plot")
        )
      ),

      tabItem(
        tabName = "bivar",
        fluidRow(
          box(
            width = 3,
            title = "Choix des variables",
            selectInput("bivar.varX", "Choix de la variable x:", choices = numeric.variables, selected = "Purchasing.Power.Value"),
            selectInput("bivar.varY", "Choix de la variable y:", choices = numeric.variables, selected = "Cost.of.Living.Value")
          ),
          box(
            width = 9,
            title = "Affichage du scatterplot",
            plotOutput("bivar.plot")
          )
        )
      ),

      tabItem(
        tabName = "contingence",
        box(
          width = 12,
          title = "Tableau de contingence",
          tableOutput("contingence.table")
        )
      ),

      tabItem(
        tabName = "AFC",
        plotOutput("AFC.plot1")
      ),

      tabItem(
        tabName = "ACP",
        box(
          plotOutput("ACP.plot.individuals"),
          plotOutput("ACP.plot.variables")
        )
      )
    )
  )
)