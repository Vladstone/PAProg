# load libraries
library(shiny)
library(ggplot2)

# begin shiny server
shinyServer(function(input, output) {
    
    # Initialize reactive variables
    iv <- 1000
    hz <- reactive(as.numeric(input$Horizon))
    gr <- reactive(as.numeric(input$Return) / 100)
    nr <- reactive(gr() - (as.numeric(input$Expense) / 100))
    net <-  reactive(accumulate(hz(),iv,nr()))
    grs <-  reactive(accumulate(hz(),iv,gr()))

    # Plot gross and net fund values over investment horison
    output$plot1 <- renderPlot({
        g <- ggplot(data.frame(x = c(0, hz())), aes(x)) 
        g <- g + stat_function(fun = accumulate, colour = "black", aes(fill="No Expenses"), geom='area', args = list(fund=iv, rate=gr()))
        g <- g + stat_function(fun = accumulate, colour = "black", aes(fill="Expenses"), geom='area', args = list(fund=iv, rate=nr()))
        g <- g + scale_colour_manual(values = c("salmon", "skyblue"))
        g <- g + scale_fill_discrete(name = "Fund Value", guide = guide_legend(reverse=TRUE))
        g <- g + labs(x="Year", y="Fund Value")
        g
    })
    
    # Summary table of final fund values
    output$table <- renderTable({
        data <- c("No Expenses","Expenses")
        data <- cbind(data, format(c(1000,1000), digits=0, big.mark=",", scientific=FALSE))
        data <- cbind(data, format(c(grs(),net()), digits=0, big.mark=",", scientific=FALSE))
        colnames(data) <- c("Category", "Begin Value ($)", "End Value ($)")
        data
    }, 
    include.rownames=FALSE,
    align='rrrr'
    )
})

# Fund accumulation function - continuous compounding
accumulate <- function(x, fund, rate) {
    m <- fund * ((1.0+rate) ^ x)
    m
}
