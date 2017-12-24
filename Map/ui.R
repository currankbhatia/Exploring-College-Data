library(leaflet)

# Choices for drop-downs
vars <- c(
  "Admission Rates" = "adm_rate",
  "Percentage of STEM degrees" = "STEM_deg_rate",
  "In-state tuition" = "in_state_cost",
  "Out-of-state tuition" = "out_state_cost",
  "Faculty Salary" = "facsal",
  "Debt upon Graduation" = "grad_debt",
  "Starting 10th Percentile Salary" = "grad_income_10th.2",
  "Starting 25th Percentile Salary" = "grad_income_25th.2",
  "Starting 75th Percentile Salary" = "grad_income_75th.2",
  "Starting 90th Percentile Salary" = "grad_income_90th.2",
  "Mid-Career 10th Percentile Salary" = "grad_income_10th.6",
  "Mid-Career 25th Percentile Salary" = "grad_income_25th.6",
  "Mid-Career 75th Percentile Salary" = "grad_income_75th.6",
  "Mid-Career 90th Percentile Salary" = "grad_income_90th.6"
)


# vars_data <- colnames(data)



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

        selectInput("var_to_view", "Select parameter to view", vars, selected = "adm_rate"),

         conditionalPanel("input.var_to_view == 'adm_rate'",
                          sliderInput("admission_rate", "Admission Rates:",
                                      min = min(college_data$college_admission_rates, na.rm = TRUE),
                                      max = max(college_data$college_admission_rates, na.rm = TRUE),
                                      value = min(college_data$college_admission_rates, na.rm = TRUE),
                                      step = 0.01)),
         
        conditionalPanel("input.var_to_view == 'STEM_deg_rate'",
                          sliderInput("percent_STEM", "Percentage of STEM degrees awarded:",
                                      min = min(college_data$college_STEM_degrees, na.rm = TRUE),
                                      max = max(college_data$college_STEM_degrees, na.rm = TRUE),
                                      value = min(college_data$college_STEM_degrees, na.rm = TRUE),
                                      step = 0.01)),
        
        conditionalPanel("input.var_to_view == 'in_state_cost'",
                          sliderInput("instate_tuition", "In State Tuition:",
                                      min = min(college_data$college_in_state_cost, na.rm = TRUE),
                                      max = max(college_data$college_in_state_cost, na.rm = TRUE),
                                      value = min(college_data$college_in_state_cost, na.rm = TRUE),
                                      step = 1000)),
         
        conditionalPanel("input.var_to_view == 'out_state_cost'",
                          sliderInput("outstate_tuition", "Out of State Tuition:",
                                      min = min(college_data$college_out_state_cost, na.rm = TRUE),
                                      max = max(college_data$college_out_state_cost, na.rm = TRUE),
                                      value = min(college_data$college_out_state_cost, na.rm = TRUE),
                                      step = 1000)),
        
        conditionalPanel("input.var_to_view == 'facsal'",
                          sliderInput("faculty_salary", "Faculty Salary:",
                                      min = min(college_data$faculty_salary, na.rm = TRUE),
                                      max = max(college_data$faculty_salary, na.rm = TRUE),
                                      value = min(college_data$faculty_salary, na.rm = TRUE),
                                      step = 1000)),
        
        conditionalPanel("input.var_to_view == 'grad_debt'",
                          sliderInput("graduation_debt", "Amount of debt upon graduation:",
                                      min = min(college_data$median_grad_debt, na.rm = TRUE),
                                      max = max(college_data$median_grad_debt, na.rm = TRUE),
                                      value = min(college_data$median_grad_debt, na.rm = TRUE),
                                      step = 1000)),
         
        conditionalPanel("input.var_to_view == 'grad_income_10th.2'",
                          sliderInput("10th_starting_income", "10th Percentile of Starting Income:",
                                      min = min(college_data$grad_income_10th.2, na.rm = TRUE),
                                      max = max(college_data$grad_income_10th.2, na.rm = TRUE),
                                      value = min(college_data$grad_income_10th.2, na.rm = TRUE),
                                      step = 1000)),
         
        conditionalPanel("input.var_to_view == 'grad_income_25th.2'",
                          sliderInput("25th_starting_income", "25th percentile of starting income:",
                                      min = min(college_data$grad_income_25th.2, na.rm = TRUE),
                                      max = max(college_data$grad_income_25th.2, na.rm = TRUE),
                                      value = min(college_data$grad_income_25th.2, na.rm = TRUE),
                                      step = 1000)),
        
        conditionalPanel("input.var_to_view == 'grad_income_75th.2'",
                         sliderInput("75th_starting_income", "75th percentile of starting income:",
                                     min = min(college_data$grad_income_75th.2, na.rm = TRUE),
                                     max = max(college_data$grad_income_75th.2, na.rm = TRUE),
                                     value = min(college_data$grad_income_75th.2, na.rm = TRUE),
                                     step = 1000)),

        conditionalPanel("input.var_to_view == 'grad_income_90th.2'",
                         sliderInput("90th_starting_income", "90th percentile of starting income:",
                                     min = min(college_data$grad_income_90th.2, na.rm = TRUE),
                                     max = max(college_data$grad_income_90th.2, na.rm = TRUE),
                                     value = min(college_data$grad_income_90th.2, na.rm = TRUE),
                                     step = 1000)),

        conditionalPanel("input.var_to_view == 'grad_income_10th.6'",
                         sliderInput("10th_mid_income", "10th Percentile of Mid-Career Income:",
                                     min = min(college_data$grad_income_10th.6, na.rm = TRUE),
                                     max = max(college_data$grad_income_10th.6, na.rm = TRUE),
                                     value = min(college_data$grad_income_10th.6, na.rm = TRUE),
                                     step = 1000)),

        conditionalPanel("input.var_to_view == 'grad_income_25th.6'",
                         sliderInput("25th_mid_income", "25th percentile of Mid-Career income:",
                                     min = min(college_data$grad_income_25th.6, na.rm = TRUE),
                                     max = max(college_data$grad_income_25th.6, na.rm = TRUE),
                                     value = min(college_data$grad_income_25th.6, na.rm = TRUE),
                                     step = 1000)),

        conditionalPanel("input.var_to_view == 'grad_income_75th.6'",
                         sliderInput("75th_mid_income", "75th percentile of Mid-Career income:",
                                     min = min(college_data$grad_income_75th.6, na.rm = TRUE),
                                     max = max(college_data$grad_income_75th.6, na.rm = TRUE),
                                     value = min(college_data$grad_income_75th.6, na.rm = TRUE),
                                     step = 1000)),

        conditionalPanel("input.var_to_view == 'grad_income_90th.6'",
                         sliderInput("90th_mid_income", "90th percentile of Mid-Career income:",
                                     min = min(college_data$grad_income_90th.6, na.rm = TRUE),
                                     max = max(college_data$grad_income_90th.6, na.rm = TRUE),
                                     value = min(college_data$grad_income_90th.6, na.rm = TRUE),
                                     step = 1000))
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
        selectInput("inputY", "Y- value", vars, selected = "adm_rate"),
        selectInput("inputX", "X- value", vars, selected = "grad_income_10th.2")
        ),
      
      mainPanel(
        helpText("Data"),
        plotOutput("plot1")
        
        
      )
    )
  ),

  conditionalPanel("false", icon("crosshair"))
)
