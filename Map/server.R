library(leaflet)

library(RColorBrewer)
library(lattice)
library(dplyr)

zipdata <- data_c

function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })

  

  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    colorBy <- input$color
    #print(colorBy)
    

    colorData <- "no"
    pal <- colorFactor("viridis", colorData)

    radius <- 60000
    if (colorBy == "salhigh") {
      zip = filter(data, Starting.Median.Salary > 60000)
    }
    
    if (colorBy == "sallow") {
      zip = filter(data, Starting.Median.Salary < 50000)
    }
    

    leafletProxy("map", data = zip) %>%
      clearShapes() %>%
      addCircles(~Long, ~Lat, radius=radius, layerId=NULL,
        stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
        layerId="colorLegend")
  })
  
  
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showZipcodePopup( event$lat, event$lng)
    })
  })
  
  # Show a popup at the given location
  showZipcodePopup <- function( lat, lng) {
    selectedZip <- zipdata[zipdata$Lat == lat,]
    if (selectedZip$Long != lng) {
      print("Wrong one") 
    }
    content <- as.character(tagList(
       tags$br(),
      sprintf("%s", selectedZip$School.Name),
      tags$br()
      
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content)
    
  }

  
}
