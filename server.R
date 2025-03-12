shinyServer(function(input, output, session){
  # global ----


  # univar ----

  output$univar.out1 = renderPrint({
    class(df[[input$univar.variable]])
  })

  output$univar.hist = renderPlot({
      ggplot(df) +
        aes_string(x = paste0(input$univar.variable,".Value")) +
        geom_histogram(bins = 30L, fill = "#5050B0") +
        theme_linedraw()
  })
  
  output$univar.bplot = renderPlot({
      boxplot(df[[paste0(input$univar.variable,".Value")]])
  })
  
  output$univar.bar = renderPlot({
    ggplot(df) +
      aes_string(x = paste0(input$univar.variable,".Category")) +
      geom_bar(bins = 30L, fill = "#5050B0") +
      theme_linedraw()
  })
  
  output$univar.moy <- renderValueBox({
    y = paste0(input$univar.variable,".Value")
    x = df[,y]
    valueBox(
      round(mean(x, na.rm = T),4), "Moyenne", icon = icon("calculator"),
      color = "purple"
    )
  })
  
  output$univar.med <- renderValueBox({
    y = paste0(input$univar.variable,".Value")
    x = df[,y]
    valueBox(
      round(median.default(x=x, na.rm = T),4), "Médiane", icon = icon("dashboard"),
      color = "yellow"
    )
  })
  
  output$univar.std <- renderValueBox({
    y = paste0(input$univar.variable,".Value")
    x = df[,y]
    valueBox(
      round(sqrt(var(x, na.rm = T)),4), "Ecart-type", icon = icon("dashboard"),
      color = "blue"
    )
  })
  # bivar ----
  output$bivar.plot <- renderPlot({
    x = input$bivar.varX
    y = input$bivar.varY
    ggplot(df) +
      aes_string(x, y) +
      geom_point(colour = "#112446") +
      labs(x = x, y = y, title = "Analyse bivariée", subtitle = paste(x, y, sep = " + ")) +
      theme_linedraw() +
      theme(legend.justification = "right")
  })
  
  output$bivar.cor <- renderValueBox({
    x = input$bivar.varX
    y = input$bivar.varY
    valueBox(
      paste0(round(cor(df[x],df[y], use="complete.obs", method = "pearson"),4)), "Corrélation", icon = icon("calculator"),
      color = "purple"
    )
  })
  
  output$bivar.nbi <- renderValueBox({
    x = input$bivar.varX
    y = input$bivar.varY
    valueBox(
      paste0(count(df[x])), "Nombre d'individus", icon = icon("dashboard"),
      color = "yellow"
    )
  })


})

