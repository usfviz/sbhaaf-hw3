library(shiny)
library(ggplot2)
library(plotly)
library(ggvis)
library(GGally)
library(pairsD3)

facebook <- na.omit(read.table('Facebook_metrics/dataset_Facebook.csv', sep = ';', header = T))
facebook[facebook[,7]==1,7] <- 'Paid'
facebook[facebook[,7]==0,7] <- 'Not paid'
facebook[,7] <- factor(facebook[,7])

ui <- shinyUI(fluidPage(
  
   # Application title
   titlePanel("Homework 3"),
   
   # Sidebar with a slider input for number of bins 
   mainPanel(tabsetPanel(tabPanel("Bubble Plot", plotOutput("bubble")),
                         tabPanel("Scatterplot Matrix",pairsD3Output("pairs", width = '800px', height = '700px')),
                         tabPanel("Parallel Coordinates Plot", plotlyOutput("pcp", height = "500px", width = '900px'))))
  
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
  
    output$bubble <- renderPlot({
      ggplot(facebook, aes(y=Total.Interactions, x=Page.total.likes, size=like)) +
        geom_point(aes(color=Paid)) + xlab('Total page likes') + ylab('Total post interactions')
    })
    
   output$pairs <- renderPairsD3({
     pairsD3(facebook[,c(1,9,17,19)])
   })
  
   
  output$pcp <- renderPlotly({
    ggplotly(ggparcoord(facebook, c(1,9,17,19), groupColumn = 7, alphaLines = 0.6, showPoints = T, scale = "uniminmax"))
  })
  
})

# Run the application 
shinyApp(ui = ui, server = server)


