library(leaflet)

library(RColorBrewer)
library(lattice)
library(dplyr)
library(ggplot2)





# creating_circles = function (data1, pal, colorData, stmed_sal, radius) {
#   leafletProxy("map", data = data1) %>%
#     clearShapes() %>%
#     addCircles(~Long, ~Lat, radius=radius, layerId=NULL,
#                stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
#     addLegend("bottomleft", pal=pal, values=colorData, title=stmed_sal,
#               layerId="colorLegend")
# }


function(input, output, session) {
  
  
  
  ## Explore Data ############################
  
  
  
  
  observe({
    
    output$plot1<-renderPlot({
      select(college_data, matches(input$inputX), matches(input$inputY)) %>% na.omit() %>% ggplot(aes_string(x = input$inputX, y = input$inputY)) + 
        geom_line() + 
        geom_smooth(method='lm')
      
    })
    
  })
  

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
    req(input$var_to_view)
    param <- input$var_to_view
    
    # reactive slider values for user chosen parameters
    adm_rate <- input$admission_rate
    in_state_cost <- input$instate_tuition
    out_state_cost <- input$outstate_tuition
    faculty_sal <- input$faculty_salary
    graduation_debt <- input$graduation_debt
    starting_10_percentile <- input$`10th_starting_income`
    starting_25_percentile <- input$`25th_starting_income`
    starting_75_percentile <- input$`75th_starting_income`
    starting_90_percentile <- input$`90th_starting_income`
    mid_10_percentile <- input$`10th_mid_income`
    mid_25_percentile <- input$`25th_mid_income`
    mid_75_percentile <- input$`75th_mid_income`
    mid_90_percentile <- input$`90th_mid_income`


    # colorData <- "no"
    # pal <- colorFactor("blue", colorData)
    zip = college_data
    
    if(param == 'adm_rate') {
      data_adm = select(college_data, college_names, college_admission_rates, college_latitudes, college_longitudes)
      college_adm_rate = data_adm[complete.cases(data_adm),]
      zip = filter(college_adm_rate, college_admission_rates <= adm_rate)
    } 
    
    if(param == 'in_state_cost') {
      data_in_cost = select(college_data, college_names, college_in_state_cost, college_latitudes, college_longitudes)
      college_in_cost = data_in_cost[complete.cases(data_in_cost),]
      zip = filter(college_in_cost, college_in_state_cost <= in_state_cost)
    }
    
    if(param == 'out_state_cost') {
      data_out_cost = select(college_data, college_names, college_out_state_cost, college_latitudes, college_longitudes)
      college_out_cost = data_out_cost[complete.cases(data_out_cost),]
      zip = filter(college_out_cost, college_out_state_cost <= out_state_cost)
    }
    
    if(param == 'faculty_sal') {
      data_facsal = select(college_data, college_names, faculty_salary, college_latitudes, college_longitudes)
      college_facsal = data_facsal[complete.cases(data_facsal),]
      zip = filter(college_facsal, faculty_salary == faculty_sal)
    }
    # zip = filter(zip, faculty_salary > faculty_sal)
    # zip = filter(zip, median_grad_debt > graduation_debt)
    # zip = filter(zip, grad_income_10th.2 > starting_10_percentile)
    # zip = filter(zip, grad_income_25th.2 > starting_25_percentile)
    # zip = filter(zip, grad_income_75th.2 > starting_75_percentile)
    # zip = filter(zip, grad_income_90th.2 > starting_90_percentile)
    # zip = filter(zip, grad_income_10th.6 > mid_10_percentile)
    # zip = filter(zip, grad_income_25th.6 > mid_25_percentile)
    # zip = filter(zip, grad_income_75th.6 > mid_75_percentile)
    # zip = filter(zip, grad_income_90th.6 > mid_90_percentile)
    
    leafletProxy("map", data = college_data) %>%
      clearShapes() %>%
      addCircles(zip$college_longitudes, zip$college_latitudes, radius = 60000,
                 stroke = FALSE, fillOpacity = 0.4, fillColor = "blue")
  })


  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    isolate({
      showZipcodePopup(event$lat, event$lng)
    })
  })

  # Show a popup at the given location
  showZipcodePopup <- function(lat, lng) {
    selectedZip <- college_data[college_data$college_latitudes == lat,]
    print(selectedZip)
    if (selectedZip$college_longitudes != lng) {
      print("Wrong one")
    }
    # selectedZip should only be one college at this point
    content <- as.character(tagList(
      sprintf("%s", selectedZip$college_names),
      tags$br(),
      sprintf("Zip Code: %s", selectedZip$college_zipcodes),
      tags$br()
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content)
  }


}


