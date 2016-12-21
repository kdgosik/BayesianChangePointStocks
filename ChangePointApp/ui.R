shinyUI(fluidPage(
  
  titlePanel("Bayesian Change Point Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "lastprice", 
                  label = "Max Price of Stock", 
                  min = 0, max = 1000, value = 100),
      
      selectizeInput(inputId = "exchange", 
                     label = "Select Exchange", 
                     choices = c("All", "NASDAQ", "NYSE", "AMEX", "FX", "Metals"),
                     selected = "NASDAQ",
                     multiple = FALSE),
      
      
      uiOutput("SymbolUI"),
      actionButton("get_stock", "Get Stock"),
      
      tabsetPanel(
        
        tabPanel("Current Quote",
                 
                 renderText("ViewQuote")
          
        ), # tabPanel
        
        tabPanel("Financials",
                 
                 renderText("ViewFinancials")
          
        ) # tabPanel
        
      ) # tabsetPanel
      
    ), # sidebarPanel
    
    
    mainPanel(
      
      tabsetPanel(
        
        tabPanel("Graphs", 
                 
                 dygraphOutput("PriceGraph"),
                 dygraphOutput("DailyReturnGraph")
                 
                 ), # tabPanel
        
        tabPanel("Table",
                 
                 dataTableOutput("PriceTable")
                 
                 )# tabPanel
        
    ) # tabsetPanel
    
  ) # mainPanel
  
) # sidebarLayout
) # fluidPage
) # shinyUI