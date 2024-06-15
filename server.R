library(shiny)
library(rsconnect)

# DATA:
#spotifyHits <- read.csv("~/Desktop/SpotifyShiny/songs_normalize.csv", header = TRUE)
spotifyHits <- read.csv("songs_normalize.csv")
#remove any repeated rows.
spotifyHits <- distinct(spotifyHits)

variableList <- c("popularity", "danceability", "energy", "key", "loudness", "speechiness", 
                  "acousticness", "instrumentalness", "liveness", "valence", "tempo")

server <- function(input, output) {
  
  # *** SONG LIST TAB: ***
  output$mytab <- renderDataTable(
    {
      # displays data table with rows alphabetized by artist
      spotifyHits[order(spotifyHits$artist), ]
    })
  
  
  # *** ARTIST COMPARISON TAB ***
  # calculates the average based on an artist and given song attribute
  dat3 <- eventReactive(input$simulateComparison,
                        valueExpr = {
                          subset(spotifyHits, artist %in% input$artistSub) %>%
                            group_by(artist) %>%
                            summarize(average = mean(.data[[input$exploreBy]]))
                        })
  
  # barplot comparing artists
  output$mybar2 <- plotly::renderPlotly({
    
    # Plot only updates when button is pressed
    palette <- eventReactive(input$simulateComparison, input$palette)
    variable <- eventReactive(input$simulateComparison, input$exploreBy)
    
    # Title of plot changes based on variable being compared
    varText <- eventReactive(input$simulateComparison, str_to_title(as.character(input$exploreBy)))
    title <- reactive(paste("Artists Compared by", varText(), sep = " "))
    
    # Code for the plot
    plot <- ggplot(dat3(), aes(x = artist, y = average, fill = artist)) +
      geom_bar(stat = "identity") +
      scale_fill_brewer(palette = palette()) +
      labs(x = "Artist", y = str_to_title(as.character(variable())), title = title(), fill = "Artist")
    
    
    # Allow user to hover over bars and see the artist name and the average values 
    ggplotly(plot, tooltip = c("x", "y"), height = 600, width = 1000) 
  })
  
  # *** ARTIST VIBES TAB ***
  # for the scatter plot: updates the ui selection options for the user based on which choices are selected
  # for other categories. Prevents user from selecting the same attribute for more than one variable.
  # Observe causes the options to update whenever any of the variable selections change.
  
  # x cannot be what is selected for y or color
  observe({
    updateVirtualSelect("x", label = "x-axis song attribute:", choices = variableList, 
                        disabledChoices = c(input$y, input$color), 
                        selected = isolate(input$x))
  })
  
  # y cannot be what is selected for x or color
  observe({
    updateVirtualSelect("y", label = "y-axis song attribute:", choices = variableList, 
                        disabledChoices = c(input$x, input$color),
                        selected = isolate(input$y))
  })
  
  # color cannot be what is selected for x or y
  observe({
    updateVirtualSelect("color", label = "Color points based on:", choices = variableList, 
                        disabledChoices = c(input$x, input$y),
                        selected = isolate(input$color))
  })
  
  output$vibePlot <- renderPlotly(
    {
      # only runs code block below if an artist is selected
      req(input$artist)
      
      # make plot title reactive based on the artist, with correct grammar based on how artist's name ends
      artistString <- as.character(input$artist)
      
      if(endsWith(artistString, "'s")){
        otherString <- " Song Vibes"
      }
      else if(endsWith(artistString, "s")){
        otherString <- "' Song Vibes"
      }
      else{
        otherString <- "'s Song Vibes"
      }
      
      title <- paste(artistString, otherString, sep = "")
      
      # Capitalize axis/legend names
      xString <- str_to_title(as.character(input$x))
      yString <- str_to_title(as.character(input$y))
      cString <- str_to_title(as.character(input$color))
      
      # subset data for an individual artist
      artistHits <- subset(spotifyHits, (artist %in% input$artist))
      
      plot_ly(data = artistHits, type = "scatter", mode = "markers",
              x = as.formula(paste("~", input$x)), 
              y = as.formula(paste("~", input$y)), 
              marker = list(color = as.formula(paste("~", input$color)),
                            colorbar = list(title = cString),
                            colorscale = "Viridis"),
              text = ~song, name = "Song", height = 500, width = 700) %>%
        layout(title = title, xaxis = list(title = xString), yaxis = list(title = yString))
    })
}

#shinyApp(ui=ui, server=server)
