#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(UsingR)
data(diamond)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    # fit linear regression model
    x    <- diamond$carat
    y    <- diamond$price
    fit <- lm(y ~ x)
    xseq <- seq(0.05,0.375,0.01)
    
    # compute predicted value and CI
    pred.ci <- reactive({ 
        round(as.numeric(predict(fit, newdata = data.frame(x = input$carats), 
                                 interval="prediction")), digits=2)
    })
    # make predicted values available to UI
    output$price <- renderPrint({cat(pred.ci()[1])})
    output$price.ci <- renderPrint({cat(pred.ci()[2:3], sep=", ")})
    # find boundary curves for prediction band for plot
    pred.upper <- reactive({ 
        as.numeric(predict(fit, newdata = data.frame(x = xseq),  
                           interval="prediction")[,3])
    })
    pred.lower <- reactive({ 
        as.numeric(predict(fit, newdata = data.frame(x = xseq), 
                           interval="prediction")[,2])
    })
    
    # build and display plot
    output$regPlot <- renderPlot({
        # blank plot
        plot(x, y, xlab="carats", ylab="price (Singapore $)", type="n", 
             main="predicted price and interval", cex.main=1.5,
             xlim=c(0.1,0.35),ylim=c(0,1100), cex.lab=1.6, cex.axis=1.3, cex=1.3) 
        # add prediction band
        perimeter_x <- c(xseq, rev(xseq))
        perimeter_y <- c(pred.lower(), rev(pred.upper()))
        polygon(perimeter_x, perimeter_y, col="#EEEEEE", border=NA)
        # add diamond plot points and regression line
        points(x, y) 
        abline(fit,col="blue")
        # add red linels showing predicted value and CI on plot
        lines(c(input$carats,input$carats), c(-100, pred.ci()[1]), lty=1, lwd=1, col="red")
        lines(c(input$carats,input$carats), c(pred.ci()[1], pred.ci()[3]), lty=2, col="red")
        lines(c(0,input$carats), c(pred.ci()[3], pred.ci()[3]), 
              col="red", lwd=1, lty=2)
        lines(c(0,input$carats), c(pred.ci()[2], pred.ci()[2]), 
              col="red", lwd=1, lty=2)
        lines(c(0,input$carats), c(pred.ci()[1], pred.ci()[1]), 
              col="red", lwd=1, lty=1)
    })
})
