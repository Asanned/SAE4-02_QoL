dashboardPage(
  dashboardHeader(
    title = "Niveau de vie"
  ),
  dashboardSidebar(
    sidebarMenu(menuItem("Analyse bivariée", tabName = "tab_anabi", icon = icon("dashboard")))
  ),
  dashboardBody(
    includeCSS("www/styles.css"),
    tabItem(tabName = "tab_anabi",
            fluidRow(
              box(
                width = 3,
                title = "Choix des variables",
                selectInput("select_varx_anabi", "Choix de la variable x:", choices = list_var_num, selected = "Purchasing.Power.Value"),
                selectInput("select_vary_anabi", "Choix de la variable y:", choices = list_var_num, selected = "Cost.of.Living.Value")
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