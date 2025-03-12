dashboardPage(skin = "purple",
  dashboardHeader(
    title = "Qualité de vie des pays du mondes",
    titleWidth = 450
  ),
  dashboardSidebar(
    width = 450,
    sidebarMenu(
      h3("Analyse descriptive"),
      menuItem("Analyse univariée", tabName = "univar", icon = icon("dashboard")),
      menuItem("Analyse bivariée", tabName = "bivar", icon = icon("dashboard")),
      div(class="separator_bar"),
      h3("Analyse Factorielle des Correspondances"),
      menuItem("Tableau de contingence", tabName = "contingence"),
      menuItem("AFC", tabName="afc", icon = icon("dashboard")),
      menuItem("ACP", tabName = "ACP")
    )
  ),
  dashboardBody(
    includeCSS("www/styles.css"),
    
    ### ANALYSE uni
    
    tabItems(
      tabItem(tabName = "univar",
        fluidRow(
        box(
          solidHeader = TRUE,
          color="purple",
          width = 2,
          title = "Variable à afficher",
          selectInput("univar.variable", "", choices = substr(numeric.variables, 0,nchar(numeric.variables)-6))
        ),
        tabBox(
          title = tagList(shiny::icon("gear"), "Graphique"),
          width=10,
          tabPanel("Histogramme",
                   plotOutput("univar.hist")
          ),
          tabPanel("Boxplot", 
                   plotOutput("univar.bplot")
          ),
          tabPanel("Diagramme", 
                   plotOutput("univar.bar")
          )
        )
      ),
      fluidRow(
        valueBoxOutput("univar.moy"),
        valueBoxOutput("univar.med"),
        valueBoxOutput("univar.std")
      )
      ),
    
      ### ANALYSE bi
      
      tabItem(
        tabName = "bivar",
        fluidRow(
          box(
            solidHeader = TRUE,
            color="purple",
            width = 3,
            title = "Choix des variables",
            selectInput("bivar.varX", "Choix de la variable x:", choices = numeric.variables, selected = "Purchasing.Power.Value"),
            selectInput("bivar.varY", "Choix de la variable y:", choices = numeric.variables, selected = "Cost.of.Living.Value")
          ),
          box(
            solidHeader = TRUE,
            color="purple",
            width = 9,
            title = "Affichage du scatterplot",
            plotOutput("bivar.plot")
          )
        ),
        fluidRow(
          valueBoxOutput("bivar.cor"),
          valueBoxOutput("bivar.nbi"),
          valueBoxOutput("bivar.cor")
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