library(leaflet)

# Choices for drop-downs
vars <- c(
  "High Salary" = "salhigh",
  "Low Salary" = "sallow"
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
        width = 200, height = 600,

        h4("Interactive Map"),

        selectInput("color", "A series of options", vars, selected = "salhigh")
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
