dashboardPage(
  dashboardHeader(
    title = "a"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Analyse univariée", tabName = "univar")
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
      )

  )
)