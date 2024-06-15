Spotify Data Visualization (Data Science Project)

Skills: R, R Shiny, plotly, ggplot

Goal: Allow people to explore Spotify data (from Kaggle) involving their favorite Spotify artists/songs

App Features:
User-interface separates data exploration options in different tabs 

First tab: 
- Explanation of variables in the dataset (as defined and calculated by Spotify)
  
Second tab:
- Search table of the entire dataset sorted in alphabetical order by artist name
  
Third tab: 
- Plotly bar plot that allows the user to select artists, a variable to be used for comparison, and a color palette. This tab displays a bar
  plot for the average value of the selected variable (calculated using all of the songs for a chosen artist in the dataset), displaying a
  visual comparison between different artists
- Plot only updates when the button is pressed, not every time the input is changed
- Prevents users from selecting over 8 artists, ensuring all color palettes are usable 
- Title of plot changes based on the comparison variable selected
- Axes and legend update based on user input
- All labels for plot are properly capitalized
- User can hover over a given bar to view the artist and the average value (helps when two bars are very similar in height)
- Plot is centered at the bottom of the page, instead of on the left and is set to a certain width and height to display data consistently
  in a visually appealing way
  
Fourth Tab: 
- Plotly scatter plot showing song data for a given artist
- Allows the user to select the three variables they would like to visualize, not allowing for repeated selection of a variable
- Allows the user to select an artist and view all their song data 
- x and y axis labels, as well as the legend title vary based on which variables the user selects for each, and are properly capitalized
- The title of the plot varies based on artist name, is properly capitalized, and accounts for the apostrophe rules for artist names that end in s or ‘s
- Plot is centered at the bottom of the page, instead of on the left and is set to a certain width and height to display data consistently in a visually appealing way 
- Users can hover over each point to view the songs they represent and the values for each song based on the selected variable
