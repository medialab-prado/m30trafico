# Define UI 
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
      helpText(HTML("<b>READY?</b>")),
      HTML("Continue to scroll down and modify the settings. Come back and click this when you are ready to render new plots."),
      submitButton("Update Graphs and Tables")
    ),
    
    wellPanel(
      helpText(HTML("<b>BASIC SETTINGS</b>")),
      
      textInput("poi", "Enter a Location of Interest:", "Madrid"),
      helpText("Examples: Madrid, Manoteras, etc")#,
      
      
      
   #   sliderInput("Minutes", "Prediction Time:", 
   #              min = 15, max = 180, step = 1, value = 3) 
   ),
    
    wellPanel(
      helpText(HTML("<b>MAP SETTINGS</b>")),
      # selectInput("lang", "Display Langauge:", choice = c("en-GB","fr")),
      selectInput("facet", "Choose Facet Type:", choice = c("none","type", "month", "category")),
      selectInput("type", "Choose Google Map Type:", choice = c("roadmap", "satellite", "hybrid","terrain")),    
      checkboxInput("res", "High Resolution?", TRUE),
      checkboxInput("bw", "Black & White?", FALSE),
      sliderInput("zoom", "Zoom Level (Recommended - 14):", 
                  min = 13, max = 15, step = 1, value = 14)
    ),
    
 #   wellPanel(
 #     helpText(HTML("<b>DENSITY PLOT SETTINGS</b>")),
 #      sliderInput("alpharange", "Alpha Range:",
 #                  min = 0, max = 1, step = 0.1, value = c(0.1, 0.4)),
 #      sliderInput("bins", "Number of Bins:", 
 #                  min = 5, max = 50, step = 5, value = 15),
 #      sliderInput("boundwidth", "Boundary Lines Width:", 
 #                  min = 0, max = 1, step = 0.1, value = 0.1),
 #      selectInput("boundcolour", "Boundary Lines Colour:", 
 #                  choice = c("grey95","black", "white", "red", "orange", "yellow", "green", "blue", "purple")),
 #      selectInput("low", "Fill Gradient (Low):", 
 #                  choice = c("yellow", "red", "orange", "green", "blue", "purple", "white", "black", "grey")),
 #      selectInput("high", "Fill Gradient (High):", 
 #                  choice = c("red", "orange", "yellow", "green", "blue", "purple", "white", "black", "grey"))
 #   ),
    
 #   wellPanel(   
 #     helpText(HTML("<b>MISC. SETTINGS</b>")),
 #     checkboxInput("watermark", "Use Watermark?", TRUE),
 #     helpText("Note: automatically disabled when 'Facet' is used.")
 #   ),
    
    wellPanel(
      helpText(HTML("<b>VERSION CONTROL</b>")),
      HTML('Version 0.2.0'),
      HTML('<br>'),
      HTML('Deployed on 27-Nov-2017'),
      HTML('<br>'),
      HTML('<a href="https://github.com/medialab-prado/m30trafico" target="_blank">Code on GitHub</a>')
    ),
    
    wellPanel(
      helpText(HTML("<b>ABOUT ME</b>")),
      HTML('Mikel Uranga'),
      HTML('<br>'),
      HTML('<a href="https://github.com/perogrullo" target="_blank">https://github.com/perogrullo</a>')
    ),
    
 #    wellPanel(
 #     helpText(HTML("<b>OTHER LINKS</b>")),
 #     HTML('<a href="http://bit.ly/blenditbayes" target="_blank">Blog</a>, '),
 #      HTML('<a href="http://bit.ly/github_woobe" target="_blank">Github</a>, '),
 #     HTML('<a href="http://bit.ly/linkedin_jofaichow" target="_blank">LinkedIn</a>, '),
 #     HTML('<a href="http://bit.ly/kaggle_woobe" target="_blank">Kaggle</a>, '),
 #     HTML('<a href="http://bit.ly/cv_jofaichow" target="_blank">Résumé</a>.')
 #   ),
    
 #    wellPanel(
 #     helpText(HTML("<b>OTHER STUFF</b>")),
 #     HTML('<a href="http://bit.ly/bib_heatmapStock" target="_blank">heatmapStock</a>, '),
 #     HTML('<a href="http://bit.ly/rCrimemap" target="_blank">rCrimemap</a>.'),
 #     HTML('<a href="http://bit.ly/bib_colour1" target="_blank">Funky Colour Palette</a>.')
 #   ),
    
    width = 3
    
  ),
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Main Panel
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  mainPanel(
    tabsetPanel(
      
      ## Core tabs
      # tabPanel("Introduction", includeMarkdown("docs/introduction.md")),
      tabPanel("Introduction"),
      tabPanel("Data", dataTableOutput("datatable")),
      tabPanel("Map", plotOutput("map")),
      tabPanel("Trends", plotOutput("trends1")),
      #tabPanel("Related News", includeMarkdown("docs/related_news.md")),
      #tabPanel("Related News"),
      #tabPanel("Changes", includeMarkdown("docs/changes.md"))
      tabPanel("Changes")
      
    ) 
  )
  
))