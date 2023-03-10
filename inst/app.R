# AML's Perceptron
# by Jake Vestal

rm(list=ls())

library(AMLPerceptron)
library(shiny)
library(ggplot2)
library(tibble)
library(purrr)
library(shinyWidgets)
library(kableExtra)

# Load up all ui components:
#   List all of the files found in the 'ui' folder and source them.
list.files("functions", full.names = TRUE) %>%
  walk(source)

# Define UI
ui <- navbarPage(

  title = "AML's Perceptron",

  main_panel(),

  tabPanel(
    title = "Iris Example",
    # Row 1
    fluidRow(
      style = "margin-left: 25px;margin-right:25px;",
      materialSwitch(
        inputId = "show_species",
        label = "Show Species",
        status = "primary"
      ),
      plotOutput("main_plot"),
      tabsetPanel(
        type = "tabs",
        tabPanel(
          title = "Data",
          htmlOutput("iris_kable")
        ),
        tabPanel(
          title = "Understanding the Iris Dataset",
          source("ui/iris_info_tab.R")
        )
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

  interactive_ggplot_data <- reactiveVal({
    tibble(
      "x0" = list(),
      "x1" = list(),
      "x2" = list(),
      "y"  = list()
    )
  })

  w_vector <- reactive({
    c(input$w0, input$w1, input$w2)
  })

  observeEvent(
    input$update_perceptron_bttn,
    {
      iggpd  <- interactive_ggplot_data()
      hx_vec <- hx_vector()
      w_vec  <- w_vector()

      if(nrow(iggpd) == 0){
        sendSweetAlert(
          session = session,
          title = "Please enter data before updating perceptron.",
          text = "You can add points by single-clicking on graph.",
          type = "error"
        )
      } else if (all(iggpd$y == hx_vec)){
        sendSweetAlert(
          session = session,
          title = "You win",
          text = "All data points successfully classified.",
          type = "success"
        )
      } else {
        # save(iggpd, file="iggpd.RData")
        # save(hx_vec, file="hx_vec.RData")
        # save(w_vec, file="w_vec.RData")
        #
        # load("iggpd.RData")
        # load("hx_vec.RData")
        # load("w_vec.RData")
        #
        # print(iggpd)
        # print(hx_vec)
        # print(w_vec)

        randomly_selected_misclasified_pt <- sample(
          which(iggpd$y != hx_vec),
          size = 1
        )


        new_w_vec <- w_vec + iggpd[
          randomly_selected_misclasified_pt,
          c("x0","x1","x2")
          ] * iggpd$y[randomly_selected_misclasified_pt]

        updateNumericInput(
          session = session,
          inputId = "w0",
          value = new_w_vec$x0
        )

        updateNumericInput(
          session = session,
          inputId = "w1",
          value = new_w_vec$x1
        )

        updateNumericInput(
          session = session,
          inputId = "w2",
          value = new_w_vec$x2
        )
      }

    }
  )

  hx_vector <- reactive({

    iggpd <- interactive_ggplot_data()[,c("x0", "x1", "x2")]
    wvec  <- w_vector()

    # save(iggpd, file = "iggpd.RData")
    # save(wvec, file = "wvec.RData")
    #
    # load("iggpd.RData")
    # load("wvec.RData")

    if(nrow(iggpd) > 0){
      iggpd %>%
        apply(
          MARGIN = 1,
          function(xrow){
            sign(sum(xrow * wvec))
          }
        )
    } else {
      return(NULL)
    }

  })

  output$x_y_table <- reactive({
    iggpd <- interactive_ggplot_data()

    if(nrow(iggpd) < 2){return()}
    
    # save(iggpd, file = "iggpd.RData")
    # load("iggpd.RData")

    while(nrow(iggpd) < 10){
      iggpd <- iggpd %>%
        add_row(x0 = NA, x1 = NA, x2 = NA, y = NA)
    }

    iggpd$x <- iggpd[,c("x0","x1", "x2")] %>%
      apply(
        MARGIN = 1,
        function(xrow){
          if(any(is.na(xrow))){
            return(" ")
          } else {
            return(
              paste0(
                "(1,",
                round(as.numeric(xrow["x1"]), digits = 2),
                ",",
                round(as.numeric(xrow["x2"]), digits = 2),
                ")"
              )
            )
          }
        }
      )

    iggpd <- iggpd[,c("x", "y")] %>%
      t()

    colnames(iggpd) <- paste0("n=", 1:10)

    iggpd %>%
      kable() %>%
      kable_styling()


  })

  output$hx_table <- reactive({
    validate(
      need(
        length(hx_vector()) > 0,
        "Please add some data points."
      )
    )

    hx_vec <- hx_vector()

    tibble(
      "h(x)" = {
        padded_hx <- hx_vec
        while(length(padded_hx) < 10){
          padded_hx <- padded_hx %>%
            c("")
        }
        padded_hx
      }
    ) %>%
      t() %>%
      kable() %>%
      kable_styling(bootstrap_options = "bordered")
  })

  output$interactive_ggplot <- renderPlot({
    validate(
      need(
        !any(is.na(w_vector())) > 0,
        "Please fully enter a weights vector."
      )
    )

    iggpd  <- interactive_ggplot_data()
    w_vec  <- w_vector()
    hx_vec <- hx_vector()

    iggp <- ggplot(iggpd) +
      geom_point(
        mapping = aes(
          x = x1,
          y = x2,
          fill = as.factor(y)
        ),
        size = 15,
        pch = 21,
        stroke = 3
      ) +
      xlim(-10, 10) +
      ylim(-10, 10) +
      coord_fixed() +
      guides(
        fill = guide_legend(title = "y")
      ) + geom_abline(
        slope = {
          - w_vec[2] / w_vec[3]
        },
        intercept = - w_vec[1] / w_vec[3]
      )

    if(isTRUE(nrow(iggp$data) > 0)){

      iggp <- iggp +
        annotate(
          geom = "text",
          x = iggp$data$x1,
          y = iggp$data$x2,
          label= paste0("x[N=", 1:nrow(iggp$data), "]"),
          parse=TRUE
        )

      if(all(iggpd$y == hx_vec)){
        sendSweetAlert(
          session = session,
          title = "You win",
          text = "All data points successfully classified.",
          type = "success"
        )
      }
    }

    iggp

  })

  # What to do if interactive_ggplot is single-clicked

  observeEvent(
    input$plot_click,
    {

      if (isTRUE(nrow(interactive_ggplot_data()) > 0)){

        iggd <- interactive_ggplot_data()
        ipc <- input$plot_click

        switch_y <- which(
          sqrt((iggd$x1 - ipc$x)^2 + (iggd$x2 - ipc$y)^2) <= 1
        )

        if(length(switch_y) > 0){
          iggd$y[switch_y] <- iggd$y[switch_y] * -1
          interactive_ggplot_data(iggd)
        } else if(isTRUE(nrow(interactive_ggplot_data()) == 10)){
          sendSweetAlert(
            session = session,
            title = "Max of 10 Data Points Allowed",
            text = "You can remove points by double-clicking.",
            type = "error"
          )
        } else {
          interactive_ggplot_data() %>%
            rbind2(
              c(
                "x0" = 1,
                "x1" = input$plot_click$x,
                "x2" = input$plot_click$y,
                "y"  = -1
              )
            ) %>%
            interactive_ggplot_data()
        }

      } else {

        interactive_ggplot_data(
          tibble(
            "x0" = 1,
            "x1" = input$plot_click$x,
            "x2" = input$plot_click$y,
            "y"  = -1
          )
        )

      }

    },
    ignoreInit = TRUE
  )

  # If a data point on interactive_ggplot is double-clicked, then remove that
  #   data point, otherwise do nothing.

  observeEvent(
    input$plot_dblclick,
    {

      if(isTRUE(nrow(interactive_ggplot_data()) > 0)){

        iggd <- interactive_ggplot_data()
        ipdc <- input$plot_dblclick

        # Use the distance formula to determine if the user clicked within a
        #  radius of 1 from the center of a point (i.e., within the point)
        row_to_delete <- which(
          sqrt((iggd$x1 - ipdc$x)^2 + (iggd$x2 - ipdc$y)^2) <= 1
        )

        if(length(row_to_delete) > 0){
          if(nrow(iggd) == 1){
            tibble(
              "x1" = list(),
              "x2" = list(),
              "y"  = list()
            ) %>%
              interactive_ggplot_data()
          } else {
            interactive_ggplot_data(iggd[-row_to_delete,])
          }
        }

      }
    },
    ignoreInit = TRUE
  )

  ##############################################################################



  linearly_seperable_iris_data <- reactiveVal(
    # take out a few points from Iris to make the data clearly linearly seperable
    value = {
      tibble(
        "x0" = 1,
        "x1" = log(iris$Sepal.Length/iris$Petal.Length),
        "x2" = log(iris$Sepal.Width/iris$Petal.Width),
        "Known Species" = iris$Species,
        "w0_setosa" = runif(length(x0), min = -100, max = 100),
        "w1_setosa" = runif(length(x0), min = -100, max = 100),
        "w2_setosa" = runif(length(x0), min = -100, max = 100),
        "w0_versicolor" = runif(length(x0), min = -100, max = 100),
        "w1_versicolor" = runif(length(x0), min = -100, max = 100),
        "w2_versicolor" = runif(length(x0), min = -100, max = 100),
        "setosa?" = sign(
          rowSums(
            cbind(w0_setosa, w1_setosa, w2_setosa) * cbind(x0, x1, x2)
          )
        ) %>%
          (function(x){
            x[which(x == 0)] <- -1
            return(
              as.logical((x + 1) / 2)
            )
          }),
        "versicolor?" = sign(
          rowSums(
            cbind(w0_versicolor, w1_versicolor, w2_versicolor) * cbind(x0, x1, x2)
          )
        ) %>%
          (function(x){
            x <<- x
            x[which(x == 0)] <- -1
            return(
              as.logical((x + 1) / 2)
            )
          })
      )[-c(67, 69, 71, 73, 84, 85),]
    }
  )

  output$iris_kable <- renderText({
    kable(linearly_seperable_iris_data()) %>%
      kable_styling(
        bootstrap_options = c("striped", "hover"),
        full_width = FALSE,
        position = "left"
      )
  })

  output$main_plot <- renderPlot({

    main_plot <- ggplot(
      data = linearly_seperable_iris_data(),
      aes(x = x1, y = x2)
    ) +
      xlab("x: log(Sepal Length/Petal Length)") +
      ylab("y: log(Sepal Width/Petal Width)") +
      ggtitle("Iris Dataset")

    if(input$show_species){
      main_plot <- main_plot + geom_point(aes(colour=`Known Species`, shape=`Known Species`), size = 3)
    } else {
      main_plot <- main_plot + geom_point(size = 3)
    }

    main_plot

  })

  output$iris_dataset_wiki_frame <- renderUI({
    tags$iframe(
      src = 'https://en.wikipedia.org/wiki/Iris_flower_data_set',
      height = 300,
      width = '100%'
    )
  })

}

# Run the application
shinyApp(ui = ui, server = server)

