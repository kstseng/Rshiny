library(shiny)
load("allCateFrame.RData")
shinyServer(function(input, output, session){
  observe({
    if (input$category != "") {
      #       dataName <- (allCateFrame$category[allCateFrame$category == input$category])
      outName <- as.character(allCateFrame$dataName[allCateFrame$category == input$category])
      outRID <- as.character(allCateFrame$rid[allCateFrame$category == input$category])
      
      updateSelectInput(session, "dataName", choices=outName)
      #       updateSelectInput(session, "RID", choices=outRID)
      
      output$text1 <- renderText({ 
        as.character(allCateFrame[which(input$dataName == allCateFrame$dataName), 3])
      })
      
    }
  })
})
