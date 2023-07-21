#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# 
# 


library(shiny)
library(SummarizedExperiment)
library(EnhancedVolcano)
library(tidyverse)
library(shinyjs)
library(dplyr)

#load the data
load("~/FGT/week7/Pipeline.RData")
# Define UI for application that draws a Volcano plot
ui <- fluidPage(
    sidebarLayout(
    
    # Application title
    titlePanel("Shiny app for Volcano plot"),
    
    # Sidebar panel for Pvalue and logFC and other parameters 
    sidebarPanel(width = 3,
                 numericInput("padj_threshold", "Set significance threshold", value = 0.05, max = 0.05, min = 0),
                 numericInput("logFC_threshold", "Set logFC significance threshold", value = 1.0, max = 2.0, min = -2.0),
                 numericInput("pointsize", "pointSize", value = 2.0),
                 numericInput("labsize", "labSize", value = 3.0),
                 numericInput("cutofflinewidth", "cutoffLineWidth", value = 0.8),
                 numericInput("legendlabsize", "legendLabSize", value = 10.0),
                 numericInput("legendiconsize", "legendIconSize", value = 5.0),
                 numericInput("widthconnectors", "widthConnectors", value = 1.0),
                 selectInput("colconnectors", "colConnectors", choices = c("Black" = "black", "Red" = "red")),
                 selectInput("cutofflinetype", "cutoffLineType", choices = c("blank", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash")),
                 selectInput("legendposition","Legend position: ", choices = c("Top" = "top", "Bottom" = "bottom", "Left" = "left", "Right" = "right")),
                 submitButton(text = "Apply Changes"),
        # Show the Volcano plot
        mainPanel(
            plotOutput("Volcano_plot", width = "100%")
            )
        )
    )
)
            
# Define server to draw a Volcano plot
server <- function(input, output) {
        #volcanoplot(limma_fit2, coef = 1L, highlight = 10)
        vol <- reactive({
            EnhancedVolcano(results, 
                            lab = results$Symbol, 
                            x= "logFC", 
                            y= "adj.P.Val",
                            pCutoff = input$padj_threshold, 
                            FCcutoff = input$logFC_threshold, 
                            ylim = c(0, -log10(10e-4)), 
                            xlim= c(-8, 6), 
                            title = 'Wild type (WT) vs Knock out (KO)', 
                            pointSize = input$pointsize, 
                            labSize = input$labsize, 
                            xlab = bquote(~Log[2]~ 'fold change'), 
                            ylab = bquote(~-Log[10]~adjusted~italic(P)), 
                            boxedLabels = TRUE,
                            legendLabels=c('Not sig.','Log2FC','adj.p-value', 'adj.p-value & Log2FC'), 
                            cutoffLineType = input$cutofflinetype,
                            cutoffLineWidth = input$cutofflinewidth,
                            legendPosition = input$legendposition,
                            legendLabSize = input$legendlabsize,
                            legendIconSize = input$legendiconsize,
                            drawConnectors = TRUE,
                            widthConnectors = input$widthconnectors,
                            colConnectors = input$colconnectors)
        })
        output$Volcano_plot <- renderPlot({
                vol()
        }, height = 600, width = 600)
}

# Run the application 
shinyApp(ui = ui, server = server)
