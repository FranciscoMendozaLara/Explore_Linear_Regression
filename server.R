library(shiny)
library(mathjaxr)
library(knitr)

shinyServer(function(input, output, session) {

  vals <- reactiveValues()

    output$eq_linear_reg <-renderUI({
        withMathJax(helpText("$$ y = \\alpha + \\beta x $$"))
    })

    stDev <- eventReactive(input$s,{
      if(input$s == "small"){
        0.1
      }else if(input$s == "medium"){
        1
      }else if(input$s == "large"){
        3
      }
    })
    
    x_sim <- eventReactive(c(input$n,input$alpha, input$beta,input$s), {
      runif(input$n, min = 0, max = 10)
    })
    
    y_sim <- eventReactive(c(input$n,input$alpha, input$beta,input$s), {
      input$alpha + input$beta*x_sim() + rnorm(input$n,0,stDev())
    })
    
    y_hat_man <- eventReactive(c(input$n,input$alpha, input$beta,input$s,
                                 input$alpha_hat, input$beta_hat), {
      input$alpha_hat + input$beta_hat*x_sim()
    })
    
    R2 <- eventReactive(c(input$n,input$alpha, input$beta,input$s,
                          input$alpha_hat, input$beta_hat), {
      cor(y_sim(), y_hat_man())^2
    })
    
    RMSE <- eventReactive(c(input$n,input$alpha, input$beta,input$s,
                            input$alpha_hat, input$beta_hat), {
      sqrt(mean((y_sim() - y_hat_man())^2))
    })
      
    output$scatterPlot <-renderPlot({
        dat <- data.frame(x = x_sim(), y = y_sim())
        ggplot(data = dat, aes(x = x , y=y))+
          geom_point(colour = 'blue')+
          geom_abline(aes(intercept  = input$alpha_hat, slope = input$beta_hat), colour = 'red', linetype = "dashed")
    })
    
    dataForTable <- shiny::reactive(
      data.frame('RMSE' =  round(RMSE(),2),
                 "R^2" =  round(R2(),6))
    )
      
    output$outputTable <- DT::renderDataTable({
      DT::datatable(dataForTable(), options = list(lengthChange = FALSE))
    })

})
