library(shiny)



shinyUI(
    fluidPage(
        titlePanel("Z-Score based on control samples"),
        
        sidebarLayout(
            sidebarPanel(
                helpText("The analysis need two files"),
                
                fileInput("expr", label = "The expression file: ", 
                    accept = c(".xlsx"), multiple = FALSE, buttonLabel = "Browse"),

                fileInput("info", label = "The sample information file: ",
                    accept = c(".xlsx"), multiple = FALSE, buttonLabel = "Browse"),
                
                uiOutput("contCaseLabel"),

                sliderInput(
                    "point_size",
                    label = "The size of point",
                    min = 0, max = 10, value = 2,
                    dragRange = TRUE, step = 0.5
                ),

                numericInput("w", "Width:", value = 500, min = 300, max = 1000, step = 10),
                numericInput("h", "Height:", value = 500, min = 300, max = 1000, step = 10),

                # Button
                actionButton("submit", label = "submit"),

                # download zip file
                downloadButton("dzip", label = "Download .zip"),

                # The width of sidebar
                width = 2
            ),

            mainPanel(
                tabsetPanel(
                    tabPanel(
                        "Figure", 
                        plotOutput("zsplot", width = "400px", height = "400px")
                    ),
                    tabPanel(
                        "Table",
                        dataTableOutput("show_table")
                    )
                )
               
            )
        )
    )
)