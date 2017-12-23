library(leaflet)

# Choices for drop-downs
vars <- c(
  "Starting Median Salary" = "medsalary",
  "Mid-Career Median Salary" = "midsalary",
  "Mid-Career 90th Percentile Salary" = "mid90salaray",
  "Tuition" = "cost",
  "Students attending" = "attendance"
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

vars_data <- colnames(data)



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
        width = 350, height = 600,

        h4("Interactive Map"),





        #selectInput("color", "A series of options", vars, selected = "all"),



        selectInput("typesch", "Type of School", type_school, selected = "all_c"),

        selectInput("var_to_view", "Select parameter to view", vars, selected = "all_c"),

        conditionalPanel("input.var_to_view == 'medsalary'",
                         sliderInput("stmed_sal", "Starting Median Salary:",
                                     min = min(data_cc$Starting.Median.Salary),
                                     max = max(data_cc$Starting.Median.Salary),
                                     value = min(data_cc$Starting.Median.Salary),
                                     step = 2000)),

        conditionalPanel("input.var_to_view == 'midsalary'",
                         sliderInput("midmed_sal", "Mid-Career Median Salary:",
                                     min = min(data_cc$Mid.Career.Median.Salary),
                                     max = max(data_cc$Mid.Career.Median.Salary),
                                     value = min(data_cc$Mid.Career.Median.Salary))),

        conditionalPanel("input.var_to_view == 'mid90salary'",
                         sliderInput("ninety_sal", "Mid-Career 90th Percentile Salary:",
                                     min = min(data_cc$Mid.Career.90th.Percentile.Salary, na.rm = TRUE),
                                     max = max(data_cc$Mid.Career.90th.Percentile.Salary, na.rm = TRUE),
                                     value = min(data_cc$Mid.Career.90th.Percentile.Salary, na.rm = TRUE))),

        conditionalPanel("input.var_to_view == 'cost'",
                         sliderInput("attendance_cost", "Cost of Attendance:",
                                     min = min(data_cc$cost, na.rm = TRUE),
                                     max = max(data_cc$cost, na.rm = TRUE),
                                     value = min(data_cc$cost, na.rm = TRUE))),

        conditionalPanel("input.var_to_view == 'attendance'",
                         sliderInput("attendance", "Number of Students Attending:",
                                     min = min(data_cc$attendance, na.rm = TRUE),
                                     max = max(data_cc$attendance, na.rm = TRUE),
                                     value = min(data_cc$attendance, na.rm = TRUE)))
      ),

      tags$div(id="cite",
        'Data compiled for ', tags$em('A STAT385 Prouction'), ' by Team Curry.'
      )
    )
  ),

  tabPanel("Explore Data",
    hr(),
    DT::dataTableOutput("ziptable"),
    
    titlePanel("Explore the Data Set"),
    
    sidebarLayout(
      sidebarPanel(
        helpText("Data"),
        selectInput("inputY", "Y- value", vars_data, selected = "Starting.Median.Salary"),
        selectInput("inputX", "X- value", vars_data, selected = "cost")
        
        
        
        
        ),
      
      mainPanel(
        helpText("Data"),
        plotOutput("plot1")
        
        
      )
    )
  ),

  conditionalPanel("false", icon("crosshair"))
)
