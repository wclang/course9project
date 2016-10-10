#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)

# Define UI for application that draws a histogram
navbarPage("Predict diamond prices",
    tabPanel("App",
        sidebarLayout(
            sidebarPanel(
                numericInput('carats', 'carats', 0.24, min = 0.1, max = 0.355, step = 0.005),
                submitButton('submit')
            ),
            mainPanel(
                h4('predicted price (Singapore $)'),
                verbatimTextOutput("price"),
                h4('95% prediction interval'),
                verbatimTextOutput("price.ci"),
                plotOutput("regPlot")
            )
        )
    ),
    tabPanel("Documentation",
        includeHTML("documentation.html")
    )
)



