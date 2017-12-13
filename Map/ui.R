library(leaflet)

# Choices for drop-downs
vars <- c(
  "All" = "all",
  "High Salary" = "salhigh",
  "Medium Income Salary" = "sallow"
  
)

type_school <- c(
  "All Colored" = "all_c",
  "All Types" = "all_ty",
  "Party" = "Party", 
  "Engineering" = "Engineering",
  "Liberal Arts"= "Liberal Arts",
  "State" = "State", 
  "Ivy League" = "Ivy League"
  
  
)




navbarPage("Team Curry: Not Just Four Years", id="nav",

  tabPanel("Interactive map",
    div(class="outer",

      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),

      # If not using custom CSS, set height of leafletOutput to a number instead of percent
      leafletOutput("map", width="100%", height="100%"),

      # Shiny versions prior to 0.11 should use class = "modal" instead.
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 300, height = 600,

        h4("Interactive Map"),
        
        
        
        

        #selectInput("color", "A series of options", vars, selected = "all"),
        
          
        
        selectInput("typesch", "Type of School", type_school, selected = "all_c"),
        
        sliderInput("stmed_sal", "Starting Median Salary:",
                    min = min(data_cc$Starting.Median.Salary), 
                    max = max(data_cc$Starting.Median.Salary), 
                    value = min(data_cc$Starting.Median.Salary),
                    step = 2000),
        
        sliderInput("midmed_sal", "Mid-Career Median Salary:",
                    min = min(data_cc$Mid.Career.Median.Salary), 
                    max = max(data_cc$Mid.Career.Median.Salary), 
                    value = min(data_cc$Mid.Career.Median.Salary)),
        

        sliderInput("ninety_sal", "Mid-Career 90th Percentile Salary:",
                    min = min(data_cc$Mid.Career.90th.Percentile.Salary, na.rm = TRUE),
                    max = max(data_cc$Mid.Career.90th.Percentile.Salary, na.rm = TRUE),
                    value = min(data_cc$Mid.Career.90th.Percentile.Salary, na.rm = TRUE))
      ),

      tags$div(id="cite",
        'Data compiled for ', tags$em('A STAT385 Prouction'), ' by Team Curry.'
      )
    )
  ),

  tabPanel("Explore Data",
    hr(),
    DT::dataTableOutput("ziptable")
  ),

  conditionalPanel("false", icon("crosshair"))
)
