library(shiny)
library(ggplot2)
library(ggmap)
library(jsonlite)
library(png)
library(grid)
library(RCurl)
library(markdown)
library(xml2)
library(readr)
library(dplyr)

## Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  ## Testing values
  if (FALSE) {
    input <- list(poi = "Madrid",
             #     start = "2013-01-01",
            #      months = 6,
                  facet = "none",
                  type = "roadmap",
                  res = TRUE,
                  bw = FALSE,
                  zoom = 14,
                  alpharange = c(0.1, 0.4),
            #      bins = 15,
                  boundwidth = 0.1,
                  boundcolour = "grey95",
                  low = "yellow",
                  high = "red",
                  watermark = "TRUE")
  }
  
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Georeference
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  id <- "1070Wbe1C2qad2VooAmbftHG4Rdxt97mE"
  PM_Georeferencia <- read.csv(sprintf("https://drive.google.com/open?id=1YCYGw744frurRnwBd6UKFSvI6mP3X1hU"))
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Get data from API
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  data <- read_xml("http://informo.munimadrid.es/informo/tmadrid/pm.xml")
  
  codigo <- data %>% xml_find_all("//codigo") %>% xml_text()
  carga <- data %>% xml_find_all("//carga") %>% xml_text()
  
  pm <- as.data.frame(cbind(codigo, carga))
  #PM_seleccionados <- read_csv("~/RStudio/Dataton2017/shiny/M30_v2/data/PM_seleccionados.csv", col_types = cols(n = col_skip()))
  pm30 <- pm %>% filter(codigo %in% PM_Georeferencia$identif)
  
  Hora <- format(Sys.time(), "%H")
  diaSemana <- weekdays(as.Date(Sys.Date()))
  diaMes <- format(Sys.Date(), "%d")
  Mes <- format(Sys.Date(), "%m")
  
  pm30 <- as.data.frame(cbind(pm30, Hora, diaSemana, diaMes, Mes))
  
  
  colnames(pm30) <- c("identif", "carga.15", "Hora", "diaSemana", "diaMes", "Mes")
  
  pm30$carga.15 <- as.numeric(pm30$carga.15)
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Prediction
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  load("~/RStudio/Dataton2017/shiny/M30_v2/model/mRLM15min.RData")
  
  #http://informo.munimadrid.es/informo/tmadrid/pm.xml
  
  prediction <- predict(model, newdata=pm30)
  
  pred_pm30 <- as.data.frame(cbind(pm30$identif, prediction))
  
  colnames(pred_pm30) <- c("identif", "carga")
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output 1 - Data Table
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$datatable <- renderDataTable({
    
    ## Display df
    pm30
    
  })
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output 2 - Map
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$map <- renderPlot({
    
    #Definir data frame coordenadas
    
    
    
    map_center = as.numeric(geocode("Madrid"))
    
    Map = ggmap(get_googlemap(center=map_center, scale=2, zoom=12), extent="device")
    
    
    #prediccion <- left_join(PM_Georeferencia, pred_pm30, by = c(identif = "identif"))
    
    
    p <-Map +
      
      geom_point(aes(x=st_x, y=st_y), data=PM_Georeferencia, col="red", alpha=1.0) + labs(x = "Longitud", y = "Latitud")
    
    
    
    
    
    print(p)
    
    
    
  }, width = 900, height = 900)
  
  
  
})