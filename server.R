shinyServer(function(input, output, session){
  # global ----


  # univar ----

  output$univar.out1 = renderPrint({
    class(df[[input$univar.variable]])
  })

  output$univar.plot = renderPlot({
    if (class(df[[input$univar.variable]]) == "numeric"){
      ggplot(df) +
        aes_string(x = input$univar.variable) +
        geom_histogram(bins = 30L, fill = "#112446") +
        theme_linedraw()
    } else if (class(df[[input$univar.variable]]) == "factor"){
      ggplot(df) +
        aes_string(x = input$univar.variable) +
        geom_bar(fill = "#112446") +
        theme_linedraw()
    }
  })

  # bivar ----
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

