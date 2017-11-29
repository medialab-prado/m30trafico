# Define UI 

id <- "1g10ZUEiH7S1cSP5feU1wiEMQbZ79_Mcb"
cameras <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))

shinyUI(pageWithSidebar(
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Application title
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  headerPanel("M30 - Traffic Analytics"),
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Sidebar Panel
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sidebarPanel(
    
    wellPanel(
      helpText(HTML("<b>UPDATE</b>")),
      HTML("Continue to scroll down and modify the settings. Come back and click this when you are ready to render new plots."),
      submitButton("Update Graphs and Plots")
    ),
    
    wellPanel(
      helpText(HTML("<b>BASIC SETTINGS</b>")),
      
      textInput("poi", "Enter a Location of Interest:", "Madrid"),
      helpText("Examples: Madrid, Manoteras, etc")#,
  
   ),
    
    wellPanel(
      helpText(HTML("<b>MAP SETTINGS</b>")),
      selectInput("map_type", "Select Map Data:", choice = c("vmed_actual", "carga_actual", "carga_30min", "vmed_30min")),
      #selectInput("facet", "Choose Facet Type:", choice = c("none","type", "month", "category")),
      selectInput("type", "Choose Google Map Type:", choice = c("roadmap", "satellite", "hybrid","terrain")),    
      #checkboxInput("res", "High Resolution?", TRUE),
      checkboxInput("bw", "Black & White?", FALSE)
    #  sliderInput("zoom", "Zoom Level (Recommended - 14):", min = 13, max = 15, step = 1, value = 14)
    ),
 
    wellPanel(
      helpText(HTML("<b>VERSION CONTROL</b>")),
      HTML('Version 0.2.1'),
      HTML('<br>'),
      HTML('Deployed on 29-Nov-2017'),
      HTML('<br>'),
      HTML('<a href="https://github.com/medialab-prado/m30trafico" target="_blank">Code on GitHub</a>')
    ),
    
    wellPanel(
      helpText(HTML("<b>ABOUT ME</b>")),
      HTML('Mikel Uranga'),
      HTML('<br>'),
      HTML('<a href="https://github.com/perogrullo" target="_blank">https://github.com/perogrullo</a>')
    ),
    
 
    width = 3
    
  ),
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Main Panel
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  mainPanel(
    tabsetPanel(
      
      ## Core tabs
     
      tabPanel("Introduction",
               mainPanel(
                 h1("M30 - Traffic Analysis"),
                 img(src = "https://upload.wikimedia.org/wikipedia/commons/f/f0/Indicador_M30.png", height = 140, width = 400),
                 p(""),
                 p(""),
                 p(""),
                 h2("Introduction"),
                 p(""),
                 p("Using the Open Data platform of the Madrid City Council we extract and process the existing data sources on car traffic in the city of Madrid, analyze it, design predictive models (looking for patterns) and harmony) and finally  visualize the results that will help the user making smart decisions regarding mobility in a smarter city."),
                 p(""),
                 p(""),
                 h2("Sections"),
                 p(""),
                 p("Map - Visualization of live and predictive data"),
                 p("Trends - How will the traffic develop over the day"),
                 p("Cameras - Take a look at the real situation of the traffic"),
                 p("Data - Check the detail of the live data"),
                 p("Status - The highlights of the M30 health KPIs"),
                 p("Changes - Just the usual change log"),
                 p(""),
                 p(""),
                 p(""),
                 p(""),
                 h2("REMEMBER!"),
                 p("Each time you make a selection or change any setting you must push the UPDATE button in the upper left corner")
                 
               )),
      tabPanel("Map", plotOutput("map")),
      tabPanel("Trends", plotOutput("trends1")),
      tabPanel("Cameras", 
               sidebarPanel(
                 selectInput('camera', 'Choose Camera Feed:', choice = cameras$nombre)
               ),
               htmlOutput("camera")),
      tabPanel("Data", dataTableOutput("datatable")),
      tabPanel("Status", dataTableOutput("status")),
      tabPanel("Changes",
              mainPanel(
                h2("Changes"),
                p(""),
                p("25-Nov-2017 --- Version 0.1.0 --- First prototype deployed."),
                p("26-Nov-2017 --- Version 0.1.1 --- minor changes, added information."),
                p("27-Nov-2017 --- Version 0.1.1 --- added camera feed."),
                p("28-Nov-2017 --- Version 0.2.0 --- Second prototype deployed."),
                p("29-Nov-2017 --- Version 0.2.1 --- added trends, added data selection, added status."),
                p("")
              
                ))
      
    ) 
  )
  
))