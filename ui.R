library(shiny)
library(ggplot2)
library(mathjaxr)
library(knitr)

shinyUI(fluidPage(

    # Application title
    titlePanel("Explore Linear Regression"),
    
    sidebarLayout(
        sidebarPanel(
          wellPanel(
            h3("Simulate some data:"),
            radioButtons('n',
                         'Number of points',
                         choices = c(5,10,50,100), selected = 50, 
                         inline = TRUE),
            radioButtons('s',
                         'Spread',
                         choices = c('small', 'medium', 'large'), selected = 'medium', 
                         inline = TRUE),
            numericInput("alpha", "$$ \\alpha \\ (intercept) $$ ", value = 1, min = -100, max = 100, step = 0.01),
            numericInput("beta", "$$ \\beta \\ (slope)$$ ", value = 1, min = -100, max = 100, step = 0.01)
            ),
          wellPanel(
          sliderInput('alpha_hat',
                      "$$ \\hat{\\alpha} $$",
                      min = -10,
                      max = 10,
                      value = 0,
                      step = 0.01),
          sliderInput('beta_hat',
                      "$$ \\hat{\\beta} $$",
                      min = -5,
                      max = 5,
                      value = 1,
                      step = 0.01)),
            
            
            uiOutput('out')
        ),
        mainPanel(
          fluidRow(
            h2(uiOutput('eq_linear_reg')),
            column(8,plotOutput("scatterPlot"))
            ),
            fluidRow(
            column(4,DT::dataTableOutput('outputTable'))
            )
        )
    )
))
