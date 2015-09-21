# load shiny package
library(shiny)
# begin shiny UI
shinyUI(fluidPage(
    
    # navigation menu
    navbarPage("Investment Fund Fee Analyser",

    # first tab
    tabPanel("Illustration",
        sidebarPanel(
            sliderInput("Return", label = p("Rate of Return (in %)"), min = 0, max = 30, value = 6, step = 0.5),
            sliderInput("Expense", label = p("Expense Ratio (in %)"), min = 0, max = 5, value = 2, step = 0.05),
            sliderInput("Horizon", label = p("Horizon (in Years)"), min = 1, max = 50, value = 30)
        ),
        mainPanel(
            h4("Investment Fund Growth"),
            plotOutput('plot1'),
            h4("Growth Summary"),
            wellPanel(div(tableOutput(outputId="table"), align = "center"))
        )
    ),

    # second tab    
    tabPanel("Help",
             p("This application displays a graph showing the accumulation of $1,000 dollars
                invested in a mutual fund or exchange traded fund (ETF) under two assumptions.
                The first is the fund earns the input rate of return without investment management
                fees (gross). The second is the fund earns the input rate of return less investment
                management fees (net).  The difference between these curves is shaded in red and
                represents investment returns lost to fees."),
             p("You have control over the following inputs:"),
             tags$ol(
                tags$li("Rate of Return: How much the fund earns each year in percentage terms."),
                tags$li("Expense Ratio: Annual investment management fees as a percentage of the fund balance."),
                tags$li("Investment Horizon: How many years the funds will be invested.")
             ),
             p("It may seem unrealistic for an investment fund not to be subject to any fees. There
                are however some very low cost Exchange Traded Funds who's expense ratios are 0.05%.
                Try it out in the calculator and you'll see that the net return is very close to the
                gross.")
             
        )
    )
))