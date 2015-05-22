#rid = "ddb80380-f1b3-4f8e-8016-7ed9cba571d5"
#datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire
                # &rid=",rid,"&format=xml",sep="")
#runApp("C:/Users/user/Desktop/R_UI/shiny_ui")
#runApp("C:/Users/Asus_D760/Downloads/excel/Taipei_city/shiny_ui")
library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
 
########################character column for data table###################  
  output$choose_char_columns <- renderUI({
    rid = input$text
    if (rid == "") return ()
    
    else {
      datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
      data = read.csv(url(paste(datapath)))
      col_names = names(data)
      numeric_index = c()
      numeric_column = c()
      for (i in 1:length(col_names)){
        if (is.numeric(data[1,i])){
          numeric_index = c(numeric_index,i)
          numeric_column = c(numeric_column,col_names[i])
        }
      }    
      char_column = col_names[-numeric_index]
      selectizeInput(
        'char_column', 'categorical column', choices = char_column, multiple = TRUE
      )
    }
  }
  )
##########################################################################

#######################numeric column for data table######################
  output$choose_numeric_columns <- renderUI({
    rid = input$text
    if (rid == "") return ()
    
    else {
      datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
      data = read.csv(url(paste(datapath)))
      col_names = names(data)
      numeric_index = c()
      numeric_column = c()
      for (i in 1:length(col_names)){
        if (is.numeric(data[1,i])){
          numeric_index = c(numeric_index,i)
          numeric_column = c(numeric_column,col_names[i])
        }
      }
      selectizeInput(
        'numeric_column', 'numeric column', choices = numeric_column, multiple = TRUE
      )
    }
  }
  )
###########################################################################

##############################Data Table Page##############################
  output$table <- renderDataTable({
    rid = input$text
    if (rid == "") return ()
    
    else {
      datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
      column = c(input$numeric_column,input$char_column)
      if (is.null(column))
        data = read.csv(url(paste(datapath)))
      else
        data = read.csv(url(paste(datapath)))[,column]
    }
  }, options = list(orderClasses = TRUE)
  
  )
###########################################################################

#################################option for point plot####################
  #rid = "ddb80380-f1b3-4f8e-8016-7ed9cba571d5"
  output$pp_X_all_columns <- renderUI({
    rid = input$text
    if (rid == "") return ()
    
    else {
      datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
      data = read.csv(url(paste(datapath)))
      col_names = names(data)
      selectizeInput(
        'X_pp_variable', 'X variable', choices = col_names, multiple = FALSE
      )
    }
  }
  )
  
  output$pp_Y_all_columns <- renderUI({
    rid = input$text
    if (rid == "") return ()
    
    else {
      datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
      data = read.csv(url(paste(datapath)))
      col_names = names(data)
      selectizeInput(
        'Y_pp_variable', 'Y variable', choices = col_names, multiple = FALSE
      )
    }
  }
  )
  
  output$pp_group_char_columns <- renderUI({
    rid = input$text
    if (rid == "") return ()
    
    else {
      datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
      data = read.csv(url(paste(datapath)))
      col_names = names(data)
      numeric_index = c()
      numeric_column = c()
      for (i in 1:length(col_names)){
        if (is.numeric(data[1,i])){
          numeric_index = c(numeric_index,i)
          numeric_column = c(numeric_column,col_names[i])
        }
      }    
      char_column = col_names[-numeric_index]
      selectizeInput(
        'group_pp_variable', 'Group', choices = char_column, multiple = FALSE
      )
    }
  }
  )
  
#################################options for boxplot#######################
  output$BP_char_columns <- renderUI({
    rid = input$text
    if (rid == "") return ()
    
    else {
      datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
      data = read.csv(url(paste(datapath)))
      col_names = names(data)
      numeric_index = c()
      numeric_column = c()
      for (i in 1:length(col_names)){
        if (is.numeric(data[1,i])){
          numeric_index = c(numeric_index,i)
          numeric_column = c(numeric_column,col_names[i])
        }
      }    
      char_column = col_names[-numeric_index]
      selectizeInput(
        'X_BP_variable', 'X variable (catagorical)', choices = char_column, multiple = FALSE
      )
    }
  }
  )
  
  output$BP_numeric_columns <- renderUI({
    rid = input$text
    if (rid == "") return ()
    
    else {
      datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
      data = read.csv(url(paste(datapath)))
      col_names = names(data)
      numeric_index = c()
      numeric_column = c()
      for (i in 1:length(col_names)){
        if (is.numeric(data[1,i])){
          numeric_index = c(numeric_index,i)
          numeric_column = c(numeric_column,col_names[i])
        }
      }    
      char_column = col_names[-numeric_index]
      selectizeInput(
        'Y_BP_variable', 'Y variable (numerical)', choices = numeric_column, multiple = FALSE
      )
    }
  }
  )
  
  output$BP_group_columns <- renderUI({
    rid = input$text
    if (rid == "") return ()
    
    else {
      datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
      data = read.csv(url(paste(datapath)))
      col_names = names(data)
      numeric_index = c()
      numeric_column = c()
      for (i in 1:length(col_names)){
        if (is.numeric(data[1,i])){
          numeric_index = c(numeric_index,i)
        numeric_column = c(numeric_column,col_names[i])
        }
      }    
      char_column = col_names[-numeric_index]
      selectizeInput(
        'group_BP_variable', 'Group (catagorical)', choices = char_column, multiple = FALSE
      )
    }
  }
  )

###########################################################################

#################################numeric column for graphic################



#################################graphical page############################

 output$plot <- renderPlot({
    rid = input$text
    datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
    dataInput = read.csv(url(datapath))
    #data = read.csv("C:/Users/Asus_D760/Downloads/excel/Taipei_city/data.csv", header = T)
    name = names(dataInput)
    #attach(dataInput)
#     a=dataInput[,c(3,24)]
#     b=c(1,2,3)
#     c=CASE_T
#     assign("UPRICE",dataInput[,3])
    if (input$plot_type == "pp"){
      frame = ggplot(data = dataInput,aes_string(x=input$X_pp_variable,y=input$Y_pp_variable,col=input$group_pp_variable))
      point_main = geom_point()
      print(frame+point_main)
    }
    
    else if (input$plot_type == "BP"){
      if(((is.null(input$X_BP_variable))||(is.null(input$Y_BP_variable)))||(is.null(input$group_BP_variable)))
        return ()
      else {
        frame = ggplot(data = dataInput)
        boxplot_main = geom_boxplot(aes_string(x=input$X_BP_variable,y=input$Y_BP_variable,col=input$group_BP_variable))
        print(frame+boxplot_main)
      }
    }
      
      
  }
  )
    
  # You can access the value of the widget with input$text, e.g.
  output$summary <- renderPrint({ 
    rid = input$text
    datapath = paste("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=",rid,"&format=csv",sep="")
    data = read.csv(url(datapath))
    #data = read.csv("C:/Users/Asus_D760/Downloads/excel/Taipei_city/data.csv", header = T)
    name = names(data)
    a=which(name == input$X_pp_variable)
    a     
      
                                   })
})
