main_panel <- function(){
  shiny::tabPanel(
    title = "Perceptron Introduction",
    shiny::fluidRow(
      shiny::column(
        width = 4,
        shiny::wellPanel(
          shiny::plotOutput(
            outputId = "interactive_ggplot",
            click = "plot_click",
            dblclick = "plot_dblclick"
          )
        )
      ),
      shiny::column(
        width = 8,
        shiny::h2("Parameters (AML Notation)"),
        shiny::hr(),
        shiny::htmlOutput("x_y_table"),
        shiny::fluidRow(
          shiny::div(
            style = "display:inline-block;",
            shiny::h1(shiny::em("w"), ":")
          ),
          shiny::div(
            style = "display:inline-block;",
            shiny::numericInput(
              inputId = "w0",
              label   = "w0",
              value   = 1,
              width = '165px'
            )
          ),
          shiny::div(
            style = "display:inline-block;",
            shiny::numericInput(
              inputId = "w1",
              label   = "w1",
              value   = 1,
              width = '165px'
            )
          ),
          shiny::div(
            style = "display:inline-block;",
            shiny::numericInput(
              inputId = "w2",
              label   = "w2",
              value   = 1,
              width = '165px'
            )
          ),
          shiny::div(
            style = "display:inline-block;",
            shiny::actionButton(
              inputId = "update_perceptron_bttn",
              label = "Update Perceptron"
            )
          )
        ),
        shiny::htmlOutput("hx_table")
      )
    )
  )
}
