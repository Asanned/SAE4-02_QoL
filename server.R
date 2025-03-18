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
      round(mean(x, na.rm = T),2), "Moyenne", icon = icon("calculator"),
      color = "purple"
    )
  })
  
  output$univar.med <- renderValueBox({
    y = paste0(input$univar.variable,".Value")
    x = df[,y]
    valueBox(
      round(median.default(x=x, na.rm = T),2), "Médiane", icon = icon("dashboard"),
      color = "yellow"
    )
  })
  
  output$univar.std <- renderValueBox({
    y = paste0(input$univar.variable,".Value")
    x = df[,y]
    valueBox(
      round(sqrt(var(x, na.rm = T)),2), "Ecart-type", icon = icon("dashboard"),
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

  # AFCM ----
  output$AFCM.eigen = renderPlot({
    fviz_eig(df.acm, geom = "bar") + ggtitle("Eboulis des valeurs propres en %")
  })
  
  output$AFCM.axe12 = renderPlot({
    fviz_mca_biplot(df.acm, axes = c(1,2))
  })
  
  output$AFCM.axe2 = renderPlot({
    modal_comp2 <- df.acm$co[order(df.acm$co$Comp2), ] ## tri par Comp2
    dotchart(modal_comp2[,2],labels = row.names(modal_comp2),cex=0.7,pch=16)
  })
  
  
  output$AFCM.axe1 = renderPlot({
    modal_comp1 <- df.acm$co[order(df.acm$co$Comp1), ]
    dotchart(modal_comp1[,1],labels = row.names(modal_comp1),cex=0.7,pch=16)
  })
  
  output$AFCM.hab.pollution = renderPlot({
    fviz_mca_ind(df.acm, habillage=df$Pollution.Category, label="none", addEllipses=TRUE, mean.point=FALSE) +
    ggtitle("")
  })
  
  output$AFCM.hab.ppower = renderPlot({
    fviz_mca_ind(df.acm, habillage=df$Purchasing.Power.Category, label="none", addEllipses=TRUE, mean.point=FALSE) +
    ggtitle("")
  })
  
  output$AFCM.hab.safety = renderPlot({
    fviz_mca_ind(df.acm, habillage=df$Safety.Category, label="none", addEllipses=TRUE, mean.point=FALSE) +
      ggtitle("")
  })
  
  output$AFCM.hab.health = renderPlot({
    fviz_mca_ind(df.acm, habillage=df$Health.Care.Category, label="none", addEllipses=TRUE, mean.point=FALSE) +
      ggtitle("")
  })
  

  # ACP ----
  ACPres = reactive({
    
    FactoMineR::PCA(
      df[complete.cases(df[,interest.variables.quanti]), interest.variables.quanti], 
      ncp = 4,
      graph = FALSE)
  })

  output$ACP.plot.individuals = renderPlot({
    fviz_pca_ind(ACPres(), col.ind = "contrib")
  })

  output$ACP.plot.variables = renderPlot({
    fviz_pca_var(ACPres(), col.var = "contrib")
  })
  
  output$ACP.plot.inertie = renderPlot({
    fviz_screeplot(ACPres())
  })
  
  output$ACP.table = DT::renderDT({
    #ACPres()$ind$contrib[,c("Dim.1", "Dim.2")]
    df_res1 = df[complete.cases(df[,interest.variables.quanti]),]

    df_res1[,"contrib.sum"] = (ACPres()$ind$contrib[,"Dim.1"] + ACPres()$ind$contrib[,"Dim.2"])
    
    df_res = df_res1[
                (ACPres()$ind$coord[,"Dim.1"] > 0) & 
                (df_res1[,"contrib.sum"] > input$results.CTR_threshold),]
    
    sort_by(df_res,df_res[,"contrib.sum"], decreasing = TRUE)
  })

})

