shinyServer(function(input, output, session){
  output$scatterplot_anabi <- renderPlot({
    x = input$select_varx_anabi
    y = input$select_vary_anabi
    ggplot(df) +
      aes_string(x, y) +
      geom_point(colour = "#112446") +
      labs(x = x, y = y, title = "Analyse bivariée", subtitle = paste(x, y, sep = " + ")) +
      theme_linedraw() +
      theme(legend.justification = "right")
  })


})

