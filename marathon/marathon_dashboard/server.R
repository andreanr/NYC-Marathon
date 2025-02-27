# create the server functions for the dashboard
server <- function(input, output) {

  # Read Data
  marathon <- read_csv('marathon.csv')
  source('aux_functions.R')
  # Read inputs
  location <- reactive({input$loc})
  state <- reactive({input$state})
  input_year <- reactive({input$input_year})
  country <- reactive({input$country})

  output$cityyear <- renderText({
    if (location() == 'State'){
      text <- paste(state(), ', USA  -  ', input_year())
    } else{
      text <- paste(country(), '  -  ', input_year())
    }
    return(text)
  })

  output$total <- renderText({
    if (location() == 'State'){
    total <- marathon %>%
      filter(year == input_year() & state_name == state()) %>%
      nrow()
    } else {
      total <- marathon %>%
        filter(year == input_year() & country == country()) %>%
        nrow()
    }
    paste0(prettyNum(total, big.mark = ',')," Total Finishers")
  })

  output$runners <- renderValueBox({
    if (location() == 'State'){
    num_runners <- marathon %>%
      filter(year == input_year() & state_name == state() & type == 'R') %>% nrow()
    } else {
      num_runners <- marathon %>%
        filter(year == input_year() & country == country() & type == 'R') %>% nrow()
    }
    valueBox(prettyNum(num_runners, big.mark = ','), "Runners", color = "purple")
  })

  output$wheelchairs <- renderValueBox({
    if (location() == 'State'){
    num_wheelchairs <- marathon %>%
      filter(year == input_year() & state_name == state() & type == 'W') %>% nrow()
    } else {
      num_wheelchairs <- marathon %>%
        filter(year == input_year() & country == country() & type == 'W') %>% nrow()
    }
    valueBox(prettyNum(num_wheelchairs, big.mark = ','), "Wheelchairs", color = "aqua")
  })

  output$handcycles <- renderValueBox({
    if (location() == 'State'){
      num_handcycles <- marathon %>%
        filter(year == input_year() & state_name == state() & type == 'H') %>% nrow()
    } else {
      num_handcycles <- marathon %>%
        filter(year == input_year() & country == country() & type == 'H') %>% nrow()
    }
    valueBox(num_handcycles, "Handcycles", color = "orange")
  })

  #creating  content
  output$genderRatio <- renderPlot({
    if (location() == 'State'){
      plot_genderRatio(marathon, 1, state(), input_year())
    }
    else {
      plot_genderRatio(marathon, 0, country(), input_year())
    }
  })

  output$densityplot <- renderPlot({
    if (location() == 'State'){
      density_plot_geo(marathon, 1, state(), input_year())
    }
    else {
      density_plot_geo(marathon, 0, country(), input_year())
    }
  })

  output$pyramidplot <- renderPlot({
    if (location() == 'State'){
      pyramid_plot(marathon, 1, state(), input_year())
    }
    else {
      pyramid_plot(marathon, 0, country(), input_year())
    }
  })

  output$boxplot <- renderPlot({
    if (location() == 'State'){
      splint_boxplot(marathon, 1, state(), input_year())
    }
    else {
      splint_boxplot(marathon, 0, country(), input_year())
    }
  })
}


