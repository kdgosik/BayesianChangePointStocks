library(shiny)
library(shinydashboard)
library(DT)
library(dygraphs)
library(magrittr)
library(DT)
library(quantmod)
library(bcp)

dashboardPage(skin="blue",
               
               dashboardHeader(title = "Data Science"),
               
               dashboardSidebar(
                 
                 sidebarMenu(
                   
                   menuItem("Table", tabName = "dashboard", icon = icon("dashboard")),
                   menuItem("Graph", tabName = "overtime", icon = icon("signal")),
                   
                   
                   sliderInput(inputId = "lastprice", 
                               label = "Max Price of Stock", 
                               min = 0, max = 1000, value = 100),
                   
                   selectizeInput(inputId = "exchange", 
                                  label = "Select Exchange", 
                                  choices = c("All", "NASDAQ", "NYSE", "AMEX", "FX", "Metals"),
                                  selected = "NASDAQ",
                                  multiple = FALSE),
                   

                   uiOutput("SymbolUI"),
                   
                   actionButton("get_stock", "Get Stock")
                   
                 ) #sidebarMenu
                 
               ), #dashboardSidebar
               
               dashboardBody(
                 
                 # Main Dashboard tab section
                 tabItems(
                   
                   ## DataTable ####
                   tabItem(tabName = "Table",
                           
                           fluidRow(
                             
                             box(
                               
                               renderDataTable("PriceTable")
                               
                             )
                             
                           )
                   ),
                   
                   
                   ## Graph ####
                   tabItem(tabName = "Graph",
                           
                           #fluidRow(
                             
                            # box(title = "Price Graph", width = 12, collapsible = TRUE,
                                 
                                dygraphOutput("PriceGraph") , 
                                
                             #) # box
                             
                           #),
                           
                           fluidRow(
                             
                             box(title = "Daily Returns", width = 12, collapsible = TRUE,
                                 dygraphOutput("DailyReturnGraph")           
                             ) # box
                             
                           )#fluidRow
                           
                   ) #tabItem
 
                 ) #tabItems
                 
               ) #dashboardBody
               
) #dashboardPage
