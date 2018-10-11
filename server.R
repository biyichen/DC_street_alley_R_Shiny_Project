options(shiny.maxRequestSize=30*1024^2)
library(shiny)
library(ggplot2)
library(leaflet)
library(dplyr)

# Define server that analyzes Street/Alley repair investigations on public property in WASHINGTON DC
shinyServer(function(input, output) {
  
  # Create a descriptive table for different SERVICECODEDESCRIPTION
  output$table1 <- renderPrint({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    # Assign marks for no file input
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different SERVICEORDERSTATUS and different ZIPCODE
    target1 <- c(input$SERVICEORDERSTATUS)
    target2 <- c(input$ZIPCODE)
    service_df <- filter(mydata, SERVICEORDERSTATUS %in% target1 & ZIPCODE %in% target2)
    # Create a table for SERVICECODEDESCRIPTION
    table(service_df$SERVICECODEDESCRIPTION)
    
  })
  
  
  # Create a bar plot for different SERVICECODEDESCRIPTION
  output$plot1 <- renderPlot({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    # Assign marks for no file input
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different SERVICEORDERSTATUS and different ZIPCODE
    target1 <- c(input$SERVICEORDERSTATUS)
    target2 <- c(input$ZIPCODE)
    service_df <- filter(mydata, SERVICEORDERSTATUS %in% target1 & ZIPCODE %in% target2)
    # Plot the SERVICECODEDESCRIPTION
    ggplot(data = service_df, aes(SERVICECODEDESCRIPTION, fill = SERVICECODEDESCRIPTION)) +
      geom_bar() +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))+
      ggtitle("SERVICECODEDESCRIPTION For Selected different SERVICEORDERSTATUS and different ZIPCODE")+
      theme(plot.title=element_text(hjust=0.5))+
      geom_text(stat="count", aes(label=..count..),vjust=-0.5)
    
  })
  
  
  output$table2 <- renderPrint({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    # Assign marks for no file input
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different SERVICEORDERSTATUS and different ZIPCODE
    target1 <- c(input$SERVICEORDERSTATUS)
    target2 <- c(input$ZIPCODE)
    inspection_df <- filter(mydata, SERVICEORDERSTATUS %in% target1 & ZIPCODE %in% target2)
    # Create a table for INSPECTIONFLAG
    table(inspection_df$INSPECTIONFLAG)
    
  })
  
  # Create a bar plot for different INSPECTIONFLAG
  output$plot2 <- renderPlot({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    # Assign marks for no file input
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different SERVICEORDERSTATUS and different ZIPCODE
    target1 <- c(input$SERVICEORDERSTATUS)
    target2 <- c(input$ZIPCODE)
    method_df <- filter(mydata, SERVICEORDERSTATUS %in% target1 & ZIPCODE %in% target2)
    # Plot the method
    ggplot(data = method_df, aes(INSPECTIONFLAG, fill = INSPECTIONFLAG)) +
      geom_bar()+
      ggtitle("INSPECTIONFLAG For Selected different SERVICEORDERSTATUS and different ZIPCODE")+
      theme(plot.title=element_text(hjust=0.5))+
      geom_text(stat="count", aes(label=..count..),vjust=-0.5)
    
  })
  
  # Create a two-way plot for SERVICECODEDESCRIPTION and INSPECTIONFLAG
  output$twplot <- renderPlot({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    # Assign marks for no file input
    if(is.null(inFile))
      return(NULL)
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data 
    target1 <- c(input$SERVICEORDERSTATUS)
    target2 <- c(input$ZIPCODE)
    plot_df <- filter(mydata, SERVICEORDERSTATUS %in% target1 & ZIPCODE %in% target2)
    
    # Two-way plot 
    ggplot(data = plot_df, aes(x = SERVICECODEDESCRIPTION, fill = SERVICECODEDESCRIPTION)) + 
      geom_bar() + 
      guides(fill=FALSE) + 
      theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
      facet_grid(.~plot_df$INSPECTIONFLAG) +
      ggtitle("SERVICECODEDESCRIPTION And INSPECTIONFLAG For Selected different SERVICEORDERSTATUS and different ZIPCODE")+
      theme(plot.title=element_text(hjust=0.5))+
      geom_text(stat="count", aes(label=..count..),vjust=-1)
    
  })
  
  
  
  # Create a map output variable
  output$map <- renderLeaflet({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    # Assign marks for no file input
    if(is.null(inFile))
      return(NULL)
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data 
    target1 <- c(input$SERVICEORDERSTATUS)
    target2 <- c(input$ZIPCODE)
    map_df <- filter(mydata, SERVICEORDERSTATUS %in% target1 & ZIPCODE %in% target2)
    
    # Create colors with a categorical color function
    color <- colorFactor(topo.colors(9), map_df$SERVICECODEDESCRIPTION)
    # Create the leaflet function for data
    leaflet(map_df) %>%
      # Set the default view
      setView(lng = -77.0369, lat = 38.9072, zoom = 11) %>%
      # Provide tiles
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(noWrap = TRUE)) %>%
      # Add circles
      addCircleMarkers(
        lng= map_df$LONGITUDE,
        lat= map_df$LATITUDE,
        stroke= FALSE,
        fillOpacity=0.1,
        color=color(SERVICECODEDESCRIPTION)
      ) %>%
      # Add legends 
      addLegend(
        "bottomleft",
        pal=color,
        values=SERVICECODEDESCRIPTION,
        opacity=0.5,
        title="Type of SERVICECODEDESCRIPTION"
      )
  })
})
