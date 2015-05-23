library(shiny)
load("allCateFrame.RData")
uniCat <- as.character(unique(allCateFrame[, 1]))
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hello Shiny!"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput(
        'category', '資料分類:', choices = uniCat,
        selected = uniCat[1]
        ), 
      
      selectInput(
        "dataName", label = "資料名稱", 
        choices = NULL, 
        selected = NULL
        )
      
        #       selectInput(
        #         "RID", label = "RID", 
        #         choices = NULL, 
        #         selected = NULL
        #       )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      textOutput("text1")
    )
  )
))