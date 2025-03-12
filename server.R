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

  # contingence ----
  output$contingence.table = renderTable(contingence, rownames = TRUE)

  # AFC ----
  output$AFC.plot1 = renderPlot({
    if (FALSE){
      afc = ade4::dudi.coa(contingence, nf = 2, scannf = FALSE)
      
      ade4::s.label(afc$li,xax=1,yax=2)
      ade4::s.label(afc$co,xax=1,yax=2,add.plot=T,boxes=F)
    } else {
      afc = CA(contingence, graph = FALSE)

      factoextra::fviz_ca_biplot(afc, repel = TRUE, col.col = "red", col.row = "blue")
    }
  })


})

