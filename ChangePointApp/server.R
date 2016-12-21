library(shiny)
library(shinydashboard)
library(DT)
library(dygraphs)
library(magrittr)
library(DT)
library(quantmod)
library(bcp)
library(dplyr)


shinyServer(function(input, output, session) {
  
  output$SymbolUI <- renderUI({
    
    inpt_lastprice <- input$lastprice
    inpt_exchange <- input$exchange
    
    out <- switch(inpt_exchange, 
                  `All` = {
                    stockSymbols(quiet = TRUE) %>%
                      filter(LastSale < inpt_lastprice) %$%
                      Symbol
                  },
                  
                  `NASDAQ` = {
                    stockSymbols("NASDAQ", quiet = TRUE) %>%
                      filter(LastSale < inpt_lastprice) %$%
                      Symbol
                  },
                  
                  `NYSE` = {
                    stockSymbols("NYSE", quiet = TRUE) %>%
                      filter(LastSale < inpt_lastprice) %$%
                      Symbol
                  },
                  
                  `AMEX` = {
                    stockSymbols("AMEX", quiet = TRUE) %>%
                      filter(LastSale < inpt_lastprice) %$%
                      Symbol
                  },
                  
                  `FX` = c("EUR/USD", "EUR/GBP", "EUR/JPY", "USD/JPY", "AUD/JPY"),
                  
                  `Metals` = c("XAU", "XAG", "XPD", "XPT")
    )
    
    
   selectizeInput("symbol", "Select Stock Symbol", choices = out)
   
  })
  
  
  Data <- eventReactive(input$get_stock, {
    
    inpt_symbol <- input$symbol
    dat <- getSymbols(inpt_symbol, auto.assign = FALSE)
    
    returns = dailyReturn(dat)
    
    bcp_post <- bcp(returns) %$% 
      posterior.prob 
    
    bcp_events <- index(dat)[which(bcp_post > 0.9)]
    
    returns <- cbind(returns, bcp_post)
    colnames(returns) <- c("Returns", "Postieror Probability")

    list(Data = dat,
         Returns = returns,
         Events = bcp_events)

    
  })
  
  
  output$PriceTable <- renderDataTable({
    
    DT::datatable(round(Data()[["Data"]], 2), 
                  filter = "top",
                  options = list(pageLength = 20))
    
  })

  output$PriceGraph <- renderDygraph({
    
    dygraph(Data()[["Data"]][,1:4], group = "group1") %>%
      dyCandlestick() %>%
      dyEvent(Data()[["Events"]])

  })
  
  
  output$DailyReturnGraph <- renderDygraph({

   dygraph(Data()[["Returns"]], group = "group1") %>%
      dyHighlight(highlightSeriesOpts = list(strokeWidth = 3))

  })
  
  
  output$ViewQuote <- renderText({
    
    getQuote(input$symbol)

  })

  output$ViewFinancials <- renderText({

    getFin(input$symbol, auto.assign = F) %>%
      viewFin()

  })
  
  

})
