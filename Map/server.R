library(leaflet)

library(RColorBrewer)
library(lattice)
library(dplyr)

zipdata <- data_cc

creating_circles = function (data1, pal, colorData, stmed_sal, radius) {
  
  
  leafletProxy("map", data = data1) %>%
    clearShapes() %>%
    addCircles(~Long, ~Lat, radius=radius, layerId=NULL,
               stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
    addLegend("bottomleft", pal=pal, values=colorData, title=stmed_sal,
              layerId="colorLegend")
  
}


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
    stmed_sal <- input$stmed_sal
    midmed_sal <- input$midmed_sal
    ninety_sal <- input$ninety_sal
    
    #print(colorBy)
    typesch <- input$typesch
    

    colorData <- "no"
    pal <- colorFactor("blue", colorData)

    radius <- 60000
    # if (colorBy == "all") {
    #   zip = data
    # }
    # else if (colorBy == "salhigh") {
    #   zip = filter(data, Starting.Median.Salary > 60000)
    # }
    # 
    # else if (colorBy == "sallow") {
    #   zip = filter(data, Starting.Median.Salary < 50000)
    # }
    
    zip = filter(data, Starting.Median.Salary > stmed_sal)
    zip = filter(zip, Mid.Career.Median.Salary > midmed_sal)
    zip = filter(zip, Mid.Career.90th.Percentile.Salary > ninety_sal)
    
    if (typesch != "all_ty" &&  typesch != "all_c" ) {
      zip = filter(zip, School.Type == typesch)
      
    }
    
    if (typesch == "all_c") {
      
      zip_party = filter(zip, School.Type == "Party")
      zip_state = filter(zip, School.Type == "State")
      zip_ivy = filter(zip, School.Type == "Ivy League")
      zip_lib = filter(zip, School.Type == "Liberal Arts")
      zip_eng = filter(zip, School.Type == "Engineering")
      
      colorData <- "Party"
      pal <- colorFactor(c("red", "yellow", "orange", "green", "blue"),
                         c("Party", "State", "Ivy League", "Liberal Arts",
                           "Engineering"))
      
      total_colors = c("Party", "State", "Ivy League", "Liberal Arts",
                       "Engineering")
      
      
      leafletProxy("map", data = zip_state) %>%
        clearShapes() %>%
        addCircles(zip_party$Long, zip_party$Lat, radius=radius, layerId=NULL,
                   stroke=FALSE, fillOpacity=0.4, fillColor=pal("Party")) %>%
        addCircles(zip_state$Long, zip_state$Lat, radius=radius, layerId=NULL,
                   stroke=FALSE, fillOpacity=0.4, fillColor=pal("State")) %>%
        addCircles(zip_ivy$Long, zip_ivy$Lat, radius=radius, layerId=NULL,
                   stroke=FALSE, fillOpacity=0.4, fillColor=pal("Ivy League")) %>%
        addCircles(zip_lib$Long, zip_lib$Lat, radius=radius, layerId=NULL,
                   stroke=FALSE, fillOpacity=0.4, fillColor=pal("Liberal Arts")) %>%
        addCircles(zip_eng$Long, zip_eng$Lat, radius=radius, layerId=NULL,
                   stroke=FALSE, fillOpacity=0.4, fillColor=pal("Engineering")) %>%
        addLegend("bottomleft", pal, values=total_colors, title=stmed_sal,
                  layerId="colorLegend")
      
      
      # creating_circles(filter(zip, School.Type == "State"), 
      #                  pal, colorData, stmed_sal, radius)
      
      # colorData <- "no"
      # pal <- colorFactor("yellow", colorData)
      
      # creating_circles(filter(zip, School.Type == "Party"), 
      #                  pal, colorData, stmed_sal, radius)
      
      # colorData <- "no"
      # pal <- colorFactor("green", colorData)
      # 
      # creating_circles(filter(zip, School.Type == "Ivy League"), 
      #                  pal, colorData, stmed_sal, radius)
      # 
      # colorData <- "no"
      # pal <- colorFactor("grey", colorData)
      # 
      # creating_circles(filter(zip, School.Type == "Liberal Arts"), 
      #                  pal, colorData, stmed_sal, radius)
      # 
      # colorData <- "no"
      # pal <- colorFactor("red", colorData)
      # 
      # creating_circles(filter(zip, School.Type == "Engineering"), 
      #                  pal, colorData, stmed_sal, radius)
      
      
    }else {
      
      leafletProxy("map", data = zip) %>%
        clearShapes() %>%
        addCircles(~Long, ~Lat, radius=radius, layerId=NULL,
                   stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
        addLegend("bottomleft", pal=pal, values=colorData, title=stmed_sal,
                  layerId="colorLegend")
      
    }
    

    
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
    print(selectedZip)
    if (selectedZip$Long != lng) {
      print("Wrong one") 
    }
    content <- as.character(tagList(
      sprintf("%s", selectedZip$School.Name),
      tags$br(),
      sprintf("School Type: %s", selectedZip$School.Type),
      tags$br(),
      sprintf("Mid-Career Median: %s", selectedZip$Mid.Career.Median.Salary),
      tags$br()
      
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content)
    
  }

  
}


