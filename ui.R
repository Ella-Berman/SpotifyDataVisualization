library(shiny)
library(rsconnect)
library(shinythemes)
library(ggplot2)
library(DT)
library(plotly)
library(dplyr)
library(stringr)
library(shinyWidgets)

spotifyHits <- read.csv("songs_normalize.csv")
#remove any repeated rows.
spotifyHits <- distinct(spotifyHits)

# list of song attributes to analyze: 
variableList <- c("popularity", "danceability", "energy", "key", "loudness", "speechiness", 
                  "acousticness", "instrumentalness", "liveness", "valence", "tempo")

# list of color palettes for the bar chart visualization:
paletteList <- c("BrBG", "PiYG", "PRGn", "PuOr", "RdBu", "RdGy", "RdYlBu", "RdYlGn", 
                 "Spectral", "Accent", "Dark2", "Paired", "Pastel1", "Pastel2", "Set1", "Set2", "Set3",
                 "Sequential", "Blues", "BuGn", "BuPu", "GnBu", "Greens", "Greys", "Oranges", "OrRd", 
                 "PuBu", "PuBuGn", "PuRd", "Purples", "RdPu", "Reds", "YlGn", "YlGnBu", "YlOrBr", "YlOrRd")

# Definition for each of the song attributes:
acousticness <- "A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high 
                  confidence the track is acoustic."

danceability <- "Describes how suitable a track is for dancing based on a combination of 
                            musical elements including tempo, rhythm stability, beat strength, and overall regularity. 
                            A value of 0.0 is least danceable and 1.0 is most danceable."

energy <- "Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of 
                            intensity and activity. Typically, energetic tracks feel fast, loud, and noisy."

key <- "This is an estimated key of the track. Integer values are mapped to the pitches 
                            of Pitch class notation. In case lack of key, the song takes value equal to -1."

instrumentalness <- "Predicts whether a track contains no vocals. \"Ooh\" and \"aah\" sounds are treated as 
                      instrumental in this context. Rap or spoken word tracks are clearly \"vocal\". 
                      The closer the instrumentalness value is to 1.0, the greater likelihood the track 
                      contains no vocal content. Values above 0.5 are intended to represent instrumental 
                      tracks, but confidence is higher as the value approaches 1.0."

liveness <- "Detects the presence of an audience in the recording. Higher liveness values represent an increased probability 
            that the track was performed live. A value above 0.8 provides strong likelihood that the track is live."

loudness <- "The overall loudness of a track in decibels (dB). Loudness values are averaged across the entire track and 
            are useful for comparing relative loudness of tracks. Loudness is the quality of a sound that is the primary
            psychological correlate of physical strength (amplitude). Values typically range between -60 and 0 db."

popularity <- "Shows how popular a song is on Spotify, summing up the popularity of 
                            all songs from every artist (scale from 0-100)."

speechiness <- "Detects the presence of spoken words in a track. The more exclusively speech-like the recording 
              (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value. Values above 0.66 
              describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 
              describe tracks that may contain both music and speech, either in sections or layered, 
              including such cases as rap music. Values below 0.33 most likely represent music and 
              other non-speech-like tracks"

tempo <- "The overall estimated tempo of a track in beats per minute (BPM). In musical terminology, tempo is the speed or
          pace of a given piece and derives directly from the average beat duration."

valence <- "A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence 
            sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. 
            sad, depressed, angry)."

# user input
ui <- navbarPage(theme = shinytheme("cerulean"), "Spotify Data Visualization Options",
                 
                 # tab containing descriptions for each variable
                 tabPanel("Descriptions of Variables",
                          h2("Description of Each Song Attribute:"),
                          h3("Acousticness"), acousticness,
                          h3("Danceability"), danceability,
                          h3("Energy"), energy,
                          h3("Key"), key,
                          h3("Instrumentalness"), instrumentalness,
                          h3("Liveness"), liveness,
                          h3("Loudness"), loudness,
                          h3("Popularity"), popularity,
                          h3("Speechiness"), speechiness,
                          h3("Tempo"), tempo,
                          h3("Valence"), valence
                 ),
                 
                 # tab with table displaying data for user to search through
                 tabPanel("Song List",
                          DT::DTOutput("mytab")
                 ),
                 
                 # tab with bar chart to compare artists
                 tabPanel("Compare Artists", 
                          
                          # limits user by allowing them to select no more than 8 artists, so all color palettes have
                          # enough colors to display all selected artists. 
                          selectizeInput("artistSub", label = "Choose artists to subset:",
                                         choices = unique(spotifyHits$artist), multiple = TRUE, options = list(maxItems = 8)),
                          
                          selectInput("exploreBy", label = "Please select the variable that you would like to explore: ", 
                                      choices = variableList),
                          
                          selectInput("palette", label = "Please select a palette for the plot: ", 
                                      choices = paletteList),
                          
                          actionButton("simulateComparison", label = "Generate barchart", class = "btn-success"),
                          
                          div(plotly::plotlyOutput("mybar2"), align = "middle")
                 ),
                 
                 # tab with scatter plot showing song data for an individual artist. 
                 tabPanel("Song Attributes by Artist",
                          
                          selectInput("artist", label = "Enter an artist to see their vibes:",
                                      choices = unique(spotifyHits$artist), multiple = FALSE),
                          
                          # user cannot select the same song attribute for multiple categories
                          virtualSelectInput("x", label = "x-axis song attribute:", 
                                             choices = variableList, selected = variableList[1]),
                          
                          virtualSelectInput("y", label = "y-axis song attribute:", 
                                             choices = variableList, selected = variableList[5]),
                          
                          virtualSelectInput("color", label = "Color points based on:", 
                                             choices = variableList, selected = variableList[7]),
                          
                          div(plotlyOutput(outputId = "vibePlot"), align = "middle")
                 )
)