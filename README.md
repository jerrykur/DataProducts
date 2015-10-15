# Data Products Project
## Jerry Kurata
### October 14, 2015

This repo contains the source files for my Data Products class project.

## The Application

The project is a Shiny Application which lets the user review the FEMA Disaster Declarations for 
the years 1997-2014.  Using the Application the user can specify a year and then review the 
number of declarations that year by state.  The data is displayed in two formats.

First, the data is displayed as a histogram that can be sorted from most to least or least to most. The
user can also enter a number and a message will display if maximum number of declarations meets or 
exceeds this value.  The value stays the same as the year is changed so the user can see which 
years exceeded a desired threshold.

Second, the data is displayed as an interactive map of the US.  This may is color coded with the 
darker color representing states with more disaster declarations.  If the user hovers over a state 
the number of disaster declartions for the specified year will be displayed
   
## Application Files

The following files make up the application.

* ui.R - the shiny UI that the user the user sees.  The UI contain 4 tabs, Histogram, Map, Info about 
the app, and Grading Notes on how the application meets the rubric of the project.

* server.R - the shiny server.  This is where the users actions result in retrieval of data that is
displayed on the UI.  The server uses shiny's reactive technology to ensure on the minimal
amount of data manipulation occurs when the user uses the UI controls to change the parameters.

* infoTab.html - text displayed on the Info tab
 
* GraderInfo.html - text display on the Grader Notes tab
 
* FEMADecl.csv - FEMA disaster declation data.  This raw data used to create this file was downloaded
from the FEMA site.  I used an R script to preprocess the data into the summaries found
in this file.