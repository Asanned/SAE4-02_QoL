dashboardPage(skin = "purple",
  dashboardHeader(
    title = "Qualité de vie des pays du mondes",
    titleWidth = 450
  ),
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      h3("Analyse descriptive"),
      menuItem("Analyse univariée", tabName = "univar", icon = icon("chart-bar")),
      menuItem("Analyse bivariée", tabName = "bivar", icon = icon("chart-line")),
      div(class="separator_bar"),
      h3("Analyses Factorielles"),
      menuItem("AFCM Axe", tabName="AFCM_axe", icon = icon("dashboard")),
      menuItem("AFCM Habillage", tabName="AFCM_hab", icon = icon("dashboard")),
      menuItem("ACP", tabName = "ACP",icon=icon("crosshairs")),
      div(class="separator_bar"),
      h3("Résultats"),
      menuItem("Résultats", tabName = "resultats",icon=icon("trophy"))
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
          width = 3,
          title = "Variable à afficher",
          radioButtons("univar.variable","",choices = substr(numeric.variables, 0,nchar(numeric.variables)-6))
        ),
        tabBox(
          title = tagList(shiny::icon("gear"), "Graphique"),
          width=9,
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
          status = "primary",
          color="purple",
          width = 6,
          selectInput("bivar.varX", "Choix de la variable x:", choices = numeric.variables, selected = "Purchasing.Power.Value")
               ),
        box(
          solidHeader = TRUE,
          status = "primary",
          color="purple",
          width = 6,
          selectInput("bivar.varY", "Choix de la variable y:", choices = numeric.variables, selected = "Cost.of.Living.Value")
            )
        ),
        
        fluidRow(
        
          box(
            solidHeader = TRUE,
            color="purple",
            width = 12,
            title = "Affichage du scatterplot",
            plotOutput("bivar.plot")
          )
                ),
        
        fluidRow(
          valueBoxOutput("bivar.cor"),
          valueBoxOutput("bivar.nbi")
        
        )
      ),

      tabItem(
        tabName = "AFCM_axe",
        fluidRow(
          box(plotOutput("AFCM.eigen")),
          box(plotOutput("AFCM.axe12"))
        ),
        fluidRow(
          box(plotOutput("AFCM.axe1")),
          box(plotOutput("AFCM.axe2"))
        )
      ),
      
      tabItem(
        tabName = "AFCM_hab",
        fluidRow(
          box(title = "Habillage de la catégorie pollution", plotOutput("AFCM.hab.pollution")),
          box(title = "Habillage de la catégorie pouvoir d'achat", plotOutput("AFCM.hab.ppower"))
        ),
        fluidRow(
          box(title = "Habillage de la catégorie sécurité", plotOutput("AFCM.hab.safety")),
          box(title = "Habillage de la catégorie santé", plotOutput("AFCM.hab.health"))
        )
      ),

      tabItem(
        tabName = "ACP",
        fluidRow(
        box(plotOutput("ACP.plot.variables")),
        box(plotOutput("ACP.plot.inertie")),
        ),
        fluidRow(
          box(width = 12, plotOutput("ACP.plot.individuals")),
        )),
      
      tabItem(
        tabName = "resultats",
        fluidRow(
          box(width = 12,solidHeader = TRUE,status = "primary",
            numericInput("results.CTR_threshold", label = "CTR threshold", 2.5, min = 0, max = 10, step = 0.1)
          ),
          box(width = 6,
            DTOutput("results.ACP.table")
          ),
          box(width = 6,
            DTOutput("results.AFCM.table")  
          ),
        ))
      )
    )
  )
