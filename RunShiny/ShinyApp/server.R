library(shiny)
library(ggplot2)
library(openxlsx)
library(stringr)
library(ggprism)
library(reshape2)

source("MetaZS.R")

# dat <- read.xlsx("data/expression.xlsx", rowNames = TRUE, colNames = TRUE)
# vsinfo <- read.xlsx("data/newname.xlsx", rowNames = FALSE, colNames = TRUE)

shinyServer(
    function(input, output){

        dat <- reactive({

            # input$expr will be null initially. After the user selects and uploads a file,
            # it will be a data frame with 'name', 'size', 'type' and 'datapath' columns.
            # The 'datapath' column will contain the local filenames where the data can be 
            # found.
            req(input$expr) # Ensure that the data upload was complete

            ext <- tools::file_ext(input$expr$name) # Get the suffix of file
            # Check file-format and read data
            switch(ext,
                xlsx = read.xlsx(input$expr$datapath, rowNames = TRUE, colNames = TRUE),
                validate("Invalid file; Please upload a .xlsx file")
            )
        })

        vsinfo <- reactive({
            req(input$info)

            ext <- tools::file_ext(input$info$name)
            switch(ext,
                xlsx = read.xlsx(input$info$datapath, rowNames = FALSE, colNames = TRUE),
                validate("Invalid file; Please upload a .xlsx file")
            )
        })

        uniVS <- reactive(groupvs(vsinfo()))

        # Labels
        output$contCaseLabel <- renderUI({
            tagList(
                selectInput("contLabel", label = "Control Label:", choice = uniVS()),
                selectInput("caseLabel", label = "Case Label:", choice = uniVS())
            )
        })

        # Calculate z-score
        ZScore <- eventReactive(input$submit, {
            validate(
                need(input$contLabel != input$caseLabel, "Please select the different case and control labels!")
            )

            statZS(dat = dat(), vsinfo = vsinfo(), cont_label = input$contLabel, case_label = input$caseLabel)
        })

        # Output
        plot_w <- reactive({input$w})
        plot_h <- reactive({input$h})
        zsplot <- reactive({
            MetaZS(zsExpr = ZScore(), point_size = input$point_size, cont_label = input$contLabel, case_label = input$caseLabel)
        })
        output$zsplot <- renderPlot(
            {
                zsplot()
            },
            width = plot_w,
            height = plot_h
        )

        output$show_table <- renderDataTable(
            {
                ZScore()
            },
            options = list(
                pageLength = 5
            )
        )

        output$dzip <- downloadHandler(
            filename = function() {
                "ZScore.zip"
            },
            content = function(file){
                tmpdir <- tempdir()
                setwd(tmpdir)
                ggsave(filename="ZScore.pdf", zsplot(), height = input$h/100, width = input$w/100)
                write.xlsx(ZScore(), file = "ZScore.xlsx", rowNames=FALSE, colNames=TRUE)
                zip::zip(zipfile=file, files = c("ZScore.pdf", "ZScore.xlsx"))
            }
        )
    }
)