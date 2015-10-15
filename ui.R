# UI.R
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("FEMA Disaster Declarations"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      #slider allowing selection of the year
      sliderInput("year",
                  "For year:",
                  sep="",
                  min = 1997,
                  max = 2014,
                  value = 2014)
     
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Histogram",
          plotOutput("histPlot"),
          # radios that set the sort order for the histogram
          radioButtons("sortOrder", "# Declaration Display Order:",
                       c("most to least" = "mostToLeast",
                         "least to most" = "leastToMost") ),
          # input to specific to alert with the # of declaration exceeds the entered
          # value
          textInput("alertOnNumDecl", "Show alert when # of declaration exceeds:"),
          h4(textOutput("numDeclExceededMessage"))
        ),
        tabPanel("Map", 
          htmlOutput("USMap")
        ),
        tabPanel("Info", 
          includeHTML("./infoTab.html")
        ),
        tabPanel("For Coursera Graders",
          includeHTML('./GraderInfo.html')
        )
      )
    )
  )
))
