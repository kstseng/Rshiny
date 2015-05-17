shinyUI(fluidPage(
  
  # Copy the line below to make a text input box
  #textInput("text", label = h3("RID input"), value = "Enter text..."),
  
  #hr(),
  #fluidRow(column(3, verbatimTextOutput("value")))
  sidebarLayout(
    sidebarPanel(
      textInput("text", label = h3("RID input"), value = "Enter text...")
      
    ),
    
    # Show a tabset that includes a plot, summary, and table view
    # of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
                  id = 'dataset',
                  #tabPanel("Summary", verbatimTextOutput("summary")), 
                  tabPanel("Data Table", dataTableOutput("table")),
                  tabPanel("Plot", plotOutput("plot"))
      )
    )
  )
))