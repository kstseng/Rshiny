library(shiny)
library(ggplot2)
shinyUI(fluidPage(
  
  # Copy the line below to make a text input box
  #textInput("text", label = h3("RID input"), value = "Enter text..."),
  
  #hr(),
  #fluidRow(column(3, verbatimTextOutput("value")))
  sidebarLayout(
    #textInput("text", label = h3("RID input"), value = ""),
    sidebarPanel(
      textInput("text", label = h3("RID input"), value = ""),
      
      conditionalPanel(
        'input.dataset === "Data Table"',
        h4("Choose Column to Show"),
        uiOutput("choose_char_columns"),
        uiOutput("choose_numeric_columns")
      ),
      
      conditionalPanel(
        'input.dataset === "Graphic"',
        selectInput(inputId="plot_type", 
                    label="Choose Plot Type:", 
                    choices=c("Pointplot"="pp","Boxplot"="BP","Histogram"="hist" )),
        conditionalPanel(
          condition="input.plot_type =='pp'",
          uiOutput("pp_X_all_columns"),
          uiOutput("pp_Y_all_columns"),
          uiOutput("pp_group_char_columns")
          #checkboxInput("pp_checkbox", label = "Adjust", value = FALSE)
          #uiOutput("graphic_numeric_columns")
        ),
        
        conditionalPanel(
          condition="input.plot_type=='BP'",
          #uiOutput("graphic_all_columns")
          uiOutput("BP_char_columns"),
          uiOutput("BP_numeric_columns"),
          uiOutput("BP_group_columns")
          
        )
      )

    ),
    
    # Show a tabset that includes a plot, summary, and table view
    # of the generated distribution
    mainPanel(  
      tabsetPanel(#type = "tabs", 
                  id = 'dataset',                   
                  tabPanel("Data Table", dataTableOutput("table")),
                  tabPanel("Graphic", plotOutput("plot")),
                  tabPanel("Summary", verbatimTextOutput("summary"))
      )
    )
  )
))