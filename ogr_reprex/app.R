library(shiny)
library(codec)
library(cincy)
library(bslib)
library(leaflet)
library(tmap)
library(dplyr)

{
  tmap_mode("view")
  
  d <- codec_data("tract_indices") |> 
    left_join(cincy::tract_tigris_2010, by = 'census_tract_id_2010') |> 
    sf::st_as_sf()
  
  d <- d |> 
    select(!where(is.logical))
  
  
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
  
  nav("Showcase",
      ex_card
  ),
  
)

server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    map <- 
      tm_basemap("CartoDB.Positron") +
      tm_shape(d, unit = 'miles') +
      tm_polygons(col ="dep_index", alpha = 0.7, palette = codec_colors(), legend.show = FALSE,
                  popup.vars = c("dep_index"))
    
    map |> 
      tmap_leaflet(in.shiny = TRUE) |> 
      removeLayersControl() 
  })
    
  
  
}

shinyApp(ui, server)
