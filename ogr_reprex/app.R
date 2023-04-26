library(shiny)
library(bslib)
library(leaflet)
library(tmap)
library(dplyr)

{
  tmap_mode("view")
  
  d <- tigris::tracts(state = 'OH', county = "Hamilton", year = 2010) |> 
    sf::st_as_sf()
  
  
}
ex_card <- card(
  full_screen = TRUE,
  card_header("Data Explorer"),
  leafletOutput("map")
)

ui <- page_navbar(
  theme = bs_theme(version = 5,
                   # bootswatch = "litera",
                   "bg" = "#FFFFFF",
                   "fg" = "#396175",
                   "primary" = "#C28273",
                   "grid-gutter-width" = "0.0rem",
                   "border-radius" = "0.5rem",
                   "btn-border-radius" = "0.25rem" ),
  
  title = "OGR Reprex",
  
  fillable = TRUE,
  
  nav("Example",
      ex_card
  ),
  
)

server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    map <- 
      tm_basemap("CartoDB.Positron") +
      tm_shape(d, unit = 'miles') +
      tm_polygons(col ="ALAND10", alpha = 0.7, legend.show = FALSE,
                  popup.vars = c("ALAND10"))
    
    map |> 
      tmap_leaflet(in.shiny = TRUE) |> 
      removeLayersControl() 
  })
    
  
  
}

shinyApp(ui, server)
