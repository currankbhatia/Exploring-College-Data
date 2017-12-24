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

## Explore Data ############################

  function(input, output, session) {
    observe({
      output$plot1<-renderPlot({
        
          select(college_data, matches(input$inputX), matches(input$inputY)) %>% na.omit() %>% ggplot(aes_string(x = input$inputX, y = input$inputY)) + 
            geom_point() +
            geom_smooth(method='lm')
      })
   })
    
  
## Interactive Map ##########################

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
    facsal <- input$faculty_salary
    grad_debt <- input$graduation_debt
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
      data_adm = data_adm[complete.cases(data_adm),]
      zip = filter(data_adm, college_admission_rates <= adm_rate)
    } 
    
    if(param == 'in_state_cost') {
      data_in_cost = select(college_data, college_names, college_in_state_cost, college_latitudes, college_longitudes)
      data_in_cost = data_in_cost[complete.cases(data_in_cost),]
      zip = filter(data_in_cost, college_in_state_cost <= in_state_cost)
    }

    if(param == 'out_state_cost') {
      data_out_cost = select(college_data, college_names, college_out_state_cost, college_latitudes, college_longitudes)
      data_out_cost = data_out_cost[complete.cases(data_out_cost),]
      zip = filter(data_out_cost, college_out_state_cost <= out_state_cost)
    }

    if(param == 'facsal') {
      data_facsal = select(college_data, college_names, faculty_salary, college_latitudes, college_longitudes)
      data_facsal = data_facsal[complete.cases(data_facsal),]
      zip = filter(data_facsal, faculty_salary > facsal)
    }

    if(param == 'grad_debt') {
      data_grad_debt = select(college_data, college_names, median_grad_debt, college_latitudes, college_longitudes)
      data_grad_debt = data_grad_debt[complete.cases(data_grad_debt),]
      zip = filter(data_grad_debt, median_grad_debt > grad_debt)
    }

    if(param == 'starting_10_percentile') {
      data_starting_10_percentile = select(college_data, college_names, grad_income_10th.2, college_latitudes, college_longitudes)
      data_starting_10_percentile = data_starting_10_percentile[complete.cases(data_starting_10_percentile),]
      zip = filter(data_starting_10_percentile, grad_income_10th.2 > starting_10_percentile)
    }

    if(param == 'starting_25_percentile') {
      data_starting_25_percentile = select(college_data, college_names, grad_income_25th.2, college_latitudes, college_longitudes)
      data_starting_25_percentile = data_starting_25_percentile[complete.cases(data_starting_25_percentile),]
      zip = filter(data_starting_25_percentile, grad_income_25th.2 > starting_25_percentile)
    }

    if(param == 'starting_75_percentile') {
      data_starting_75_percentile = select(college_data, college_names, grad_income_75th.2, college_latitudes, college_longitudes)
      data_starting_75_percentile = data_starting_75_percentile[complete.cases(data_starting_75_percentile),]
      zip = filter(data_starting_75_percentile, grad_income_75th.2 > starting_75_percentile)
    }

    if(param == 'starting_90_percentile') {
      data_starting_90_percentile = select(college_data, college_names, grad_income_90th.2, college_latitudes, college_longitudes)
      data_starting_90_percentile = data_starting_90_percentile[complete.cases(data_starting_90_percentile),]
      zip = filter(data_starting_90_percentile, grad_income_90th.2 > starting_90_percentile)
    }

    if(param == 'mid_10_percentile') {
      data_mid_10_percentile = select(college_data, college_names, grad_income_10th.6, college_latitudes, college_longitudes)
      data_mid_10_percentile = data_mid_10_percentile[complete.cases(data_mid_10_percentile),]
      zip = filter(data_mid_10_percentile, grad_income_10th.6 > mid_10_percentile)
    }

    if(param == 'mid_25_percentile') {
      data_mid_25_percentile = select(college_data, college_names, grad_income_25th.6, college_latitudes, college_longitudes)
      data_mid_25_percentile = data_mid_25_percentile[complete.cases(data_mid_25_percentile),]
      zip = filter(data_mid_25_percentile, grad_income_25th.6 > mid_25_percentile)
    }

    if(param == 'mid_75_percentile') {
      data_mid_75_percentile = select(college_data, college_names, grad_income_75th.6, college_latitudes, college_longitudes)
      data_mid_75_percentile = data_mid_75_percentile[complete.cases(data_mid_75_percentile),]
      zip = filter(data_mid_75_percentile, grad_income_75th.6 > mid_75_percentile)
    }

    if(param == 'mid_90_percentile') {
      data_mid_90_percentile = select(college_data, college_names, grad_income_90th.6, college_latitudes, college_longitudes)
      data_mid_90_percentile = data_mid_90_percentile[complete.cases(data_mid_90_percentile),]
      zip = filter(data_mid_90_percentile, grad_income_90th.6 > mid_90_percentile)
    }
    
    
    
    leafletProxy("map", data = zip) %>%
      clearShapes() %>%
      addCircles(zip$college_longitudes, zip$college_latitudes, radius = 30000,
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
      if(input$var_to_view == 'adm_rate') 
        sprintf("Admission Rate: %f", selectedZip$college_admission_rates)
      else if(input$var_to_view == 'in_state_cost') 
        sprintf("In State Cost: %d", selectedZip$college_in_state_cost)
      else if(input$var_to_view == 'out_state_cost')
        sprintf("Out of State Cost: %d", selectedZip$college_out_state_cost)
      else if(input$var_to_view == 'faculty_sal')
        sprintf("Faculty Salary: %d", selectedZip$faculty_salary)
      else if(input$var_to_view == 'graduation_debt')
        sprintf("Grad Debt: %d", selectedZip$median_grad_debt)
      else if(input$var_to_view == 'starting_10_percentile')
        sprintf("Starting 10th percentile salary: %d", selectedZip$grad_income_10th.2)
      else if(input$var_to_view == 'starting_25_percentile')
        sprintf("Starting 25th percentile salary: %d", selectedZip$grad_income_25th.2)
      else if(input$var_to_view == 'starting_75_percentile')
        sprintf("Starting 75th percentile salary: %d", selectedZip$grad_income_75th.2)
      else if(input$var_to_view == 'starting_90_percentile')
        sprintf("Starting 90th percentile salary: %d", selectedZip$grad_income_90th.2)
      else if(input$var_to_view == 'mid_10_percentile')
        sprintf("Mid-Career 10th percentile salary: %d", selectedZip$grad_income_10th.6)
      else if(input$var_to_view == 'mid_25_percentile')
        sprintf("Mid-Career 25th percentile salary: %d", selectedZip$grad_income_25th.6)
      else if(input$var_to_view == 'mid_75_percentile')
        sprintf("Mid-Career 75th percentile salary: %d", selectedZip$grad_income_75th.6)
      else if(input$var_to_view == 'mid_90_percentile')
        sprintf("Mid-Career 90th percentile salary: %d", selectedZip$grad_income_90th.6)
      
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content)
  }
}


