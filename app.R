

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(readxl)
library(ggplot2)
library(officer)
library(rvg)
#sidebar menu are used to provide for the navigation menu in 
#the sidebar of a dashboard
ui <- dashboardPage(
  dashboardHeader(title = "Plotting basic graphs in Shiny"),
  dashboardSidebar(
    #function for loading the file
    fileInput("file", label = "Upload a file ", multiple = FALSE,
              accept = c(".xlsx", ".csv"), placeholder = "No file selected"),
    #multiple = FALSE limits a user from uploading more than one file 
    #>placeholder displays a default text on a the upload box 
    #>before uploading a file
    
    #UNIVARIATE PLOTTING
    h3("Univariate graphs "),
    uiOutput("univariate_var"),
    
    #selcting the type of the variable 
    selectInput("variable_type", "Select Variable Type",
                choices = c("Please specify" = "",
                            "Categorical" = "cat",
                            "Numeric " = "numeric")),
    
    #slider for setting the bins
    conditionalPanel(
      condition = "input.variable_type == 'numeric'",
      sliderInput("bins", "Select no of bins for Hist:", min = 5, max = 50, value = 10)
    ),
    
    
    #action button
    actionButton("plot_uni", "Plot the graph", class = "btn-success"),
    br(),
    #CREATING A CODE TO CHOOSE ONE OF THE VARIOABLES 
    h3("Two-Variable Plot"),
    uiOutput("varselect_x"),
    uiOutput("varselect_y"),
    
    selectInput("plot_type", "Select Plot Type",
                choices = c("Scatter plot" = "scatter", "Box Plot" = "box")),
    actionButton("plot", "Plot", class = "btn-success"),
    br(),
    downloadButton("download_plots", "Download Word Document", 
                   class = "btn-primary")
    
  ),
  dashboardBody(
    tableOutput("table"),
    h3(" Single Variable plot"),
    plotOutput("uni_graph"),
    h3("Two- Variable Plot"),
    plotOutput("graph"),
    
    #footer 
    # add spacing to avoid overlap with footer
    tags$br(), tags$br(), tags$br(), tags$br(),
    
    # footer added here
    tags$div(
      class = "footer",
      style = "text-align: right; padding: 10px 20px; background-color: #f9f9f9; position: fixed; bottom: 0; width: 100%; z-index: 1000;",
      HTML(
        paste0(
          '<p>Contact us: ',
          '<a href="mailto:dataquestsolutions2@gmail.com">dataquestsolutions2@gmail.com</a>',
          ' | ',
          '<a href="https://wa.me/254707612395?text=Hello%20I%20am%20interested%20in%20your%20services" target="_blank">',
          '<i class="fab fa-whatsapp"></i> Chat on WhatsApp</a>',
          ' | Powered By DataQuest Solutions</p>'
        )
      )
    )
    
    
    
  )
  
)


server <- function(input, output, session){
  data <- reactive({
    req(input$file)
    ext <- tools::file_ext(input$file$name)
    switch(ext,
           csv = read.csv(input$file$datapath),
           xlsx = read_excel(input$file$datapath)
    )
    
  })
  output$table <- renderTable({
    req(data())
    head(data())
  } )
  #Univariate Plotting 
  output$univariate_var <- renderUI({
    req(data())
    selectInput("uni_var", "Select a variable for plotting",
                choices = c("Choose a variable to plot" = "",
                            names(data())) )
  })
  
  
  #specifying the plot 
  observeEvent(input$plot_uni, {
    output$uni_graph <- renderPlot({
      req(input$uni_var)
      if(input$variable_type == "cat"){
        df <- data()
        #i gave my data object df to improve readability in conversion
        
        # converting the the variable if not numeric
        df[[input$uni_var]] <- as.factor(df[[input$uni_var]])
        ggplot(df, aes_string(input$uni_var, fill = input$uni_var))+
          geom_bar(show.legend = FALSE)+ theme_minimal()+
          labs(title = paste("Bar Plot of", input$uni_var))
      }else if (input$variable_type == "numeric"){
        ggplot(data(), aes_string(input$uni_var))+
          geom_histogram(bins = input$bins, fill = "steelblue",
                         colour = "black")+
          labs(title = paste("A histogram of", input$uni_var))
      }
    })
  })
  
  #defining the reactive plot for downloading 
  uni_plot_reactive <- reactive({
    req(input$uni_var)
    if(input$variable_type == "cat"){
      df <- data()
      #i gave my data object df to improve readability in conversion
      
      # converting the the variable if not numeric
      df[[input$uni_var]] <- as.factor(df[[input$uni_var]])
      ggplot(df, aes_string(input$uni_var, fill = input$uni_var))+
        geom_bar(show.legend = FALSE)+ theme_minimal()+
        labs(title = paste("Bar Plot of", input$uni_var))
    }else if (input$variable_type == "numeric"){
      ggplot(data(), aes_string(input$uni_var))+
        geom_histogram(bins = input$bins, fill = "steelblue",
                       colour = "black")+
        labs(title = paste("A histogram of", input$uni_var))
    }
  })
  
  
  
  output$varselect_x <- renderUI({
    req(data())
    #how to select the x variable
    selectInput("xvar", "X Variable", 
                choices = c(" Choose an X variable" = "", names(data())))
  })
  output$varselect_y <- renderUI({
    req(data())
    selectInput("yvar", "Y variable", 
                choices = c("Choose the Y variable", names(data())))
  })
  #plotting the data 
  observeEvent(input$plot, {
    output$graph <- renderPlot({
      req(input$xvar, input$yvar)
      ##defining the plots 
      if(input$plot_type == "scatter") {
        ggplot(data(), aes_string(x = input$xvar, y = input$yvar))+
          geom_point()+ theme_bw()+
          labs(title = paste("A scatter plot of", input$yvar, "against", 
                             input$xvar))
      } else if (input$plot_type == "box") {
        ggplot(data(), aes_string( x = input$xvar, y = input$yvar, fill = input$xvar))+
          geom_boxplot(show.legend = FALSE)+ theme_bw()+
          labs(title = 
                 paste("A boxplot of", input$yvar, "against", input$xvar))
      }
    })
  })
  #defining reactive plot for bivariate analysis
  bivar_plot_reactive <- reactive({
    req(input$xvar, input$yvar)
    ##defining the plots 
    if(input$plot_type == "scatter") {
      ggplot(data(), aes_string(x = input$xvar, y = input$yvar))+
        geom_point()+ theme_bw()+
        labs(title = paste("A scatter plot of", input$yvar, "against", 
                           input$xvar))
    } else if (input$plot_type == "box") {
      ggplot(data(), aes_string( x = input$xvar, y = input$yvar,
                                 fill = input$xvar))+
        geom_boxplot(show.legend = FALSE)+ theme_bw()+
        labs(title = 
               paste("A Boxplot of ", input$yvar, "against", input$xvar))
    }
  })
  
  
  
  #download handler to save as word document 
  output$download_plots <- downloadHandler(
    filename = function() {
      paste0("plots_", Sys.Date(), ".docx")
    },
    content = function(file) {
      # Temp files for plots
      tmpfile1 <- tempfile(fileext = ".png")
      tmpfile2 <- tempfile(fileext = ".png")
      
      # Save plots as images
      ggsave(tmpfile1, plot = uni_plot_reactive(), width = 6, height = 4)
      ggsave(tmpfile2, plot = bivar_plot_reactive(), width = 6, height = 4)
      
      # Create Word doc and add both plots
      doc <- read_docx()
      doc <- body_add_par(doc, "Univariate Plot", style = "heading 1")
      doc <- body_add_img(doc, src = tmpfile1, width = 6, height = 4)
      doc <- body_add_par(doc, "Two-Variable Plot", style = "heading 1")
      doc <- body_add_img(doc, src = tmpfile2, width = 6, height = 4)
      
      # Save
      print(doc, target = file)
    }
  )
  
  
}


shinyApp(ui, server)

