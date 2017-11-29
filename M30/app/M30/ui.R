# Define UI 

id <- "1g10ZUEiH7S1cSP5feU1wiEMQbZ79_Mcb"
cameras <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))

shinyUI(pageWithSidebar(
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Application title
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  headerPanel("M30 - Gestión Inteligente del Tráfico"),
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Sidebar Panel
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sidebarPanel(
    
    wellPanel(
      helpText(HTML("<b>ACTUALIZAR</b>")),
      HTML("Cada vez que cambies los ajustes de cualquier de los apartados o selecciones una opción pulsa el botón para reflejar los cambios."),
      submitButton("Actualizar Datos")
    ),
    
    wellPanel(
      helpText(HTML("<b>AJUSTES BÁSICOS</b>")),
      
      textInput("poi", "Introduce un lugar de interés:", "Madrid"),
      helpText("Ejemplos: Madrid, Manoteras, etc")#,
  
   ),
    
    wellPanel(
      helpText(HTML("<b>MAPA</b>")),
      selectInput("map_type", "Selecciona los datos del mapa:", choice = c("vmed_actual", "carga_actual", "carga_30min", "vmed_30min")),
      selectInput("type", "Selecciona tipo de Google Map:", choice = c("roadmap", "satellite", "hybrid","terrain")),    
      checkboxInput("bw", "Blanco y Negro?", FALSE)
    #  sliderInput("zoom", "Zoom Level (Recommended - 14):", min = 13, max = 15, step = 1, value = 14)
    ),
 
    wellPanel(
      helpText(HTML("<b>CONTROL DE VERSIONES</b>")),
      HTML('Version 0.2.2'),
      HTML('<br>'),
      HTML('Desplegado el 29-Nov-2017'),
      HTML('<br>'),
      HTML('<a href="https://github.com/medialab-prado/m30trafico" target="_blank">Código en GitHub</a>')
    ),
    
    wellPanel(
      helpText(HTML("<b>AUTOR</b>")),
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
     
      tabPanel("Introducción",
               mainPanel(
                 h1("M30 - Gestión Inteligente del Tráfico"),
                 img(src = "https://upload.wikimedia.org/wikipedia/commons/f/f0/Indicador_M30.png", height = 140, width = 400),
                 p(""),
                 p(""),
                 p(""),
                 h2("Introducción"),
                 p(""),
                 p("Gracias a la plataforma Open Data del Ayuntamiento de Madrid podemos extraer y procesar las distintas fuente de información disponibles sobre el tráfico en la ciudad. De esta forma podemos analizar, diseñar modelos predictivos (buscando patrones y armonía)  y, finalmente, visualizar lso resultados que ayudarán al usuario a tomar decisiones más informadas en relación a la movilidad en una ciudad un poco más smart."),
                 p(""),
                 p(""),
                 h2("Secciones"),
                 p(""),
                 h3("Mapa"),
                 h4("Visualización de los datos del tráfico, tanto en directo como predictivos, sobre el mapa de la ciudad "),
                 p("El mapa muestra los distintos puntos de medida del tráfico en la M30 y sus entradas. Cada uno de ellos estará representado por un color en función del estado de la carretera para la variable seleccionada:"),
                 p("* Verde    - Bueno"),
                 p("* Amarillo - Mediocre"),
                 p("* Rojo     - Malo"),
                 p("* Gris     -Error en los datos [2017/11/29: Desde hace varios días los puntos de medida de la M30 envían un valor de carga 0 de forma invariable ]"),
                 p(""),
                 p("Los tipos de datos a mostrar en estos momentos son los siguientes:"),
                 p("* Velocidad media actual"),
                 p("* Predicción de Velocidad media dentro de 30 minutos"),
                 p("* Carga de la vía actual"),
                 p("* Predicción de Carga de la vía dentro de 30 minutos"),
                 p(""),
                 p("También se dispone de la posibilidad de cambiar el tipo de mapa para poder tener una visualización óptima en función de las necesidaded del usuario"),
                 p(""),
                 h3("Tendencias"), 
                 h4("Cómo va a ir desarrollándose el tráfico a lo largo del día"),
                 p(""),
                 p("Gráfico 1 - Vmed: Tendencia a desarrollar durante el día de la velocidad media en la M30 "),
                 p("Gráfico 2 - Carga: Tendencia a desarrollar durante el día de la carga de vía en la M30 "),
                 p(""),
                 h3("Cámaras"),
                 h4("Échale un vistazo a la situación real del tráfico"),
                 p(""),
                 p("Una selección de las instantáneas tomadas por las cámaras de tráfico de la M30 cada 10 minutos"),
                 p(""),
                 h3("Datos"),
                 h4("Comprueba el detalle de los datos en directo"),
                 p(""),
                 p("El detalle de los datos en crudo obtenidos de las APIs de los puntos de medida de la M30 cada 15 minutos"),
                 p(""),
                 h3("Status"),
                 h4("Un resumen de los KPIs del estado de salud de la M30"),
                 p(""),
                 p("Información en directo sobre el estado de la vía de la M30, como reparaciones o retenciones"),
                 p(""),
                 h3("Cambios"),
                 h4("El habitual log de cambios"),
                 p(""),
                 p(""),
                 p(""),
                 p(""),
                 h2("IMPORTATE!"),
                 p("Cada vez que interactúes con cualquiera de las opciones de la app, debes pulsar el botón de ACTUALIZAR de la esquina superior izquierda")
                 
               )),
      tabPanel("Mapa", plotOutput("map")),
      tabPanel("Tendencias", plotOutput("trends1")),
      tabPanel("Cámaras", 
               sidebarPanel(
                 selectInput('camera', 'Elige Cámara:', choice = cameras$nombre)
               ),
               htmlOutput("camera")),
      tabPanel("Datos", dataTableOutput("datatable")),
      tabPanel("Status", dataTableOutput("status")),
      tabPanel("Cambios",
              mainPanel(
                h2("Cambios"),
                p(""),
                p("25-Nov-2017 --- Versión 0.1.0 --- Primer prototipo."),
                p("26-Nov-2017 --- Versión 0.1.1 --- cambios menores, información adicional."),
                p("27-Nov-2017 --- Versión 0.1.1 --- añadidas cámaras."),
                p("28-Nov-2017 --- Versión 0.2.0 --- Segundo prototipo."),
                p("29-Nov-2017 --- Versión 0.2.1 --- añadidas tendencias, aselección de datos y status."),
                p("29-Nov-2017 --- Versión 0.2.2 --- cambios estéticos."),
                p("")
              
                ))
      
    ) 
  )
  
))