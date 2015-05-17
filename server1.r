#rid = "ddb80380-f1b3-4f8e-8016-7ed9cba571d5"
#datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire
                # &rid=",rid,"&format=xml",sep="")
#runApp("C:/Users/user/Desktop/R_UI/shiny_ui")

shinyServer(function(input, output) {
  
  output$table <- renderDataTable({
    rid = input$text
    datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",input$text,"&format=csv",sep="")
    data = read.csv(url(paste(datapath)))
  }, options = list(orderClasses = TRUE))
  
  output$plot <- renderPlot({
    rid = input$text
    datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",input$text,"&format=csv",sep="")
    data = read.csv(url(paste(datapath)))
    hist(data[,9],main = paste("Data from",input$text)) })
  # You can access the value of the widget with input$text, e.g.
  #output$value <- renderPrint({ input$text })
  
  
})


