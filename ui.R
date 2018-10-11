library(shiny)
library(ggplot2)
library(leaflet)
library(dplyr)
library(shinythemes)

# Define UI for application that analyzes Street/Alley repair investigations on public property in WASHINGTON DC
shinyUI(fluidPage(
  
  # Change the theme
  theme = shinytheme("darkly"),
  
  # Application title
  titlePanel("This data layer shows 311 Service Requests in the last 30 days for street and alley cleaning requests on public property in WASHINGTON DC"),
  
  # Three sidebars for uploading files, selecting attributes to analysis
  sidebarLayout(
    sidebarPanel(
      # Create a file input
      fileInput("file","Choose A CSV File Please",
                multiple = TRUE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Create a multiple checkbox input for SERVICE STATUS
      checkboxGroupInput("SERVICEORDERSTATUS",
                         "service order status:",
                         c("CLOSED","OPEN","VOIDED")
      ),
      hr(),
      helpText("Please Select SERVICE ORDER STATUS"),
      helpText("You Can Choose More Than One"),
      
      hr(),
      hr(),
      # Create a multiple checkbox input for investigations accord to zipcode
      checkboxGroupInput("ZIPCODE",
                         "investigations ZIPCODE:",
                         c("20019","20002","20011","20001","20020","20010","20018","20032","20009","20003","20012","20017","20016","20005","20008","20007","20015","20037","20036","20004","20006","20024","20613")
      ),
      hr(),
      helpText("Please Select investigations according to the zipcode"),
      helpText("You Can Choose More Than One")
    ),
    # Make the sidebar on the left of the webpage
    position = "left",
    fluid = TRUE,
    
    
    # Show the descriptive analysis, the plots, and the map in tab panels
    mainPanel(
      h5("What SERVICE CODE DESCRIPTION in where and at what status of investigations?"),
      h5("If there is INSPECTION FLAG exist and its locations and at what status of investigations?"),
      hr(),
      tabsetPanel(type="tabs",
                  tabPanel("Descriptive Analysis", 
                           tabsetPanel(
                             tabPanel("SERVICECODEDESCRIPTION",verbatimTextOutput("table1"), plotOutput("plot1", height=500)),
                             tabPanel("INSPECTIONFLAG reslut",verbatimTextOutput("table2"), plotOutput("plot2", height=500))
                           )),
                  tabPanel("Two-Way Plot", plotOutput("twplot", height=650)),
                  tabPanel("Map", leafletOutput("map", height=600))
      )
    )
  )
))
