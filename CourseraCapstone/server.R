library(shiny)
library(NLP)
library(tm)
library(RWeka)
setwd("C:/Users/GL552VW/Documents/NLPwithR")

source("mainF.R")
shinyServer(
  function(input, output) {
    output$inputValue <- renderPrint({input$Tcir})
    output$prediction <- renderPrint({wordproc(input$Tcir)})
    
    
    
  }
)

