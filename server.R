#server.R

library(data.table)
library(googleVis)
library(shiny)
library(ggplot2)


# Define server logic required to draw a histogram of disaster
shinyServer(function(input, output) {
  
  FEMADeclFile <- "FEMADecl.csv"
  
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  getDataForYear <- function(year) {
    FEMADecl <- read.csv(FEMADeclFile)
    FEMADeclDT <- data.table(FEMADecl)
    # Usage example:
    # 1. To get # of Decl by state for a year use:  for bar/histogram
    FEMADeclDT[DeclYear == year,list(NumDecl=.N),by=State]
    # 2. To get # of Decl by state and Incident type use:  This would be good for stacked bar/histogram
    #PlotData <- FEMADeclDT[DeclYear==2013,list(NumDecl=.N),by=list(State, Incident.Type)]
  }
  
  # This Reactive function is triggered when the user changes the value in the 
  # "alertOnNumDecl" text box.
  # The function will find the maximum number of declarations in any state and if that
  # value exceeds the entered alert value return a text string to be displayed to the user
  # The message returned is of the form "*** Max # of Declarations reached" or
  # "*** Max # of Declarations exceeded by xxx%" depending upon whether the max is reached
  # or exceeded.  If the max is not reached a null string is returned.
  output$numDeclExceededMessage <- reactive( {
    # Initialize message to empty string
    exceedMessage <- ""
    if (length(input$alertOnNumDecl) > 0 ) {
      AlertDecl <- strtoi(input$alertOnNumDecl)
      pData <- plotData()
      maxNumDecl <- max(pData$FEMAData$NumDecl)
      if ( (AlertDecl > 0) && (maxNumDecl >= AlertDecl) ) {
        pOver <- ((maxNumDecl - AlertDecl)/AlertDecl) * 100
        exceedMessage <- "*** Max # of Declarations"
        #exceedMessage <- sprintf("AlertDecl: %d, maxNumDecl: %d, pOver: %f", AlertDecl, maxNumDecl, pOver)
        if ( pOver > 0) {
          exceedMessage <- paste(exceedMessage, 
                                 sprintf(" exceeded by %d (%2.0f%%).", 
                                         (maxNumDecl - AlertDecl), pOver))
        } 
        else {
          exceedMessage <- paste(exceedMessage, " reached.")
        }
      }
    }
    # return the message
    exceedMessage
  })
  
  
  # Since retrieving the plot data can take a long time we want to avoid doing it unless something 
  # that effects the plot data has changed.  To do this we wrap the call to 
  # getDataForYear() in the reactive construct.  This will ensure we only update the 
  # plotData when the year changes.  Otherwise the data returned by a reference to 
  # getDataForYear() will be the last retrieved value
  plotData <- reactive( {
    FEMAD <- getDataForYear( strtoi(input$year)) 
    # return the FEMA Disaster Declaration Data and the year for which the data was retrieved
    list(FEMAData = FEMAD, currentYear = input$year )      
    } )
  
  
  
  # Render the histogram plot when the user changes any input value (ex. input$SortOrder) 
  # except input$year. The reactive code above handles changes in input$year.  
  output$histPlot <- renderPlot({
    pData <- plotData()
    # draw the histogram with the specified number of bins
    # Plot the disaster data
    #   Define the title
    titleText <- paste("Declarations by State - ", pData$currentYear)
    #   get the total number of declarations so we can calculate the % for a state
    totalDecl <- sum(pData$FEMAData$NumDecl)
    pData$FEMAData$PercentDecl <- ( (pData$FEMAData$NumDecl/totalDecl) * 100)
    # sort states by declining or ascending number of declarations
    if (input$sortOrder == 'mostToLeast') {
      pData$FEMAData$StateByNumDecl <- reorder(pData$FEMAData$State, -pData$FEMAData$NumDecl)
    } else {
      pData$FEMAData$StateByNumDecl <- reorder(pData$FEMAData$State, pData$FEMAData$NumDecl)
    }
    x <- ggplot(data=pData$FEMAData, aes(x = StateByNumDecl, y = NumDecl)) + geom_bar(stat = "identity") +
      theme(axis.text.x=element_text(size=11, angle=40, vjust=.8, hjust=1.01)) +
      labs(title=titleText, x="State", y="Number of Declarations")    
    x
  })
  
  output$USMap <- renderGvis({
    gvisGeoChart(plotData()$FEMAData,locationvar = "State", colorvar = "NumDecl",
                 options=list(region="US", displayMode="regions", 
                              resolution="provinces",
                              width=600, height=500,
                              colorAxis="{colors:['#FFFFFF', '#0000FF']}" 
                  ))
  })
})