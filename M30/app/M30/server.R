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
library(ggpubr)
library(lubridate)

## Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  ## Testing values
  if (FALSE) {
    input <- list(poi = "Madrid",
             #     start = "2013-01-01",
            #      months = 6,
                  facet = "none",
                  type = "roadmap",
                  camera = "camera",
                  map_type = "vmed_actual",
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
  
  id <- "1DJJVJ7e7UAp3a9pK-Qn3SPnbEkkqbaPr"
  PM_Georeferencia <-read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Get data from API
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  
  id <- "1mCwcG_s5_7bum0tS44asu07Oz-M9QS96"
  data <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))
  
  #pm <- as.data.frame(cbind(codigo, carga,vmed))
#  pm30 <- pm %>% filter(codigo %in% PM_Georeferencia$identif)
  
  pm30 <- left_join(data, PM_Georeferencia, identif = c("identif"))

  
  id <- "1NR8y2v0IVkzI2eD24ENJR2oDL4nl7Y1H"
  calendario <-read_delim(sprintf("https://docs.google.com/uc?id=%s&export=download", id), 
               ";", escape_double = FALSE, col_types = cols(Dia = col_date(format = "%d/%m/%Y")), 
               trim_ws = TRUE)
  
#  calendario <- read_delim(calendario, 
#                           ";", escape_double = FALSE, col_types = cols(Dia = col_date(format = "%d/%m/%Y")), 
#                           trim_ws = TRUE)
  
  festivo <- calendario[calendario$Dia == Sys.Date(),]$'laborable / festivo / domingo festivo'
  
  pm30 <- cbind(pm30, festivo)
  
  colnames(pm30) <-  c( "identif","carga.15", "intensidad.15", "ocupacion.15", "vmed.15",  "Hora","diaSemana","diaMes","Mes", "longitud", "latitud", "festivo" )
  
  pm30$carga.15 <- as.double(pm30$carga.15)
  pm30$vmed.15 <- as.double(pm30$vmed.15)
  
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Prediction
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #Carga
  
  id <- "1zowCLr3N-f9k031WntrJ858ICYQYeYSM"
  pred_pm30 <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))
  
  pred_pm30 <- left_join(pred_pm30, PM_Georeferencia, identif = c("identif"))
  
  colnames(pred_pm30) <- c("identif", "carga", "longitud", "latitud")
  
  #Vmed
  
  id <- "1yTWd46633gN2ukMYtMqwD14lq6CvdPy-"
  predV_pm30 <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))
  
  predV_pm30 <- left_join(predV_pm30, PM_Georeferencia, identif = c("identif"))
  
  colnames(predV_pm30) <- c("identif", "vmed", "longitud", "latitud")
  
  predV_pm30$vmed <- predV_pm30$vmed*74
  
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
    
    map_type <- input$map_type
    
    #map_center = as.numeric(geocode("Madrid"))
    map_center = as.numeric(geocode(input$poi))
    
    if(input$bw ==FALSE){
      map_color <- "color"
    }
    else{
      map_color <- "bw"
    }
      
    
    Map = ggmap(get_googlemap(center=map_center, scale=2, zoom=12, maptype=input$type, color = map_color), extent="device")
    
    
    p <-Map
   
    if(map_type =='carga_actual'){
    gray <- subset(pm30, carga.15=0)  
    green <- subset(pm30, carga.15>0 & carga.15<=60)
    yellow <- subset(pm30, carga.15>60 & carga.15<=80)
    red <- subset(pm30, carga.15>80)  
    
    p <- p + geom_point(aes(x=longitud, y=latitud), data=gray, col="gray", alpha=1.0) + labs(x = "longitud", y = "latitud")  
    p <- p + geom_point(aes(x=longitud, y=latitud), data=green, col="green", alpha=1.0) + labs(x = "longitud", y = "latitud")
    p <- p + geom_point(aes(x=longitud, y=latitud), data=yellow, col="yellow", alpha=1.0) + labs(x = "longitud", y = "latitud")
    p <- p + geom_point(aes(x=longitud, y=latitud), data=red, col="red", alpha=1.0) + labs(x = "longitud", y = "latitud")
    }
    
    if(map_type =='vmed_actual'){
      
    vgreen <- subset(pm30, vmed.15>60)
    vyellow <- subset(pm30, vmed.15>20 & vmed.15<=60)
    vred <- subset(pm30, vmed.15<=20)
    
    p <- p + geom_point(aes(x=longitud, y=latitud), data=vgreen, col="green", alpha=1.0) + labs(x = "longitud", y = "latitud")
    p <- p + geom_point(aes(x=longitud, y=latitud), data=vyellow, col="yellow", alpha=1.0) + labs(x = "longitud", y = "latitud")
    p <- p + geom_point(aes(x=longitud, y=latitud), data=vred, col="red", alpha=1.0) + labs(x = "longitud", y = "latitud")
    }
    
    if(map_type =='carga_30min'){
      cgray <- subset(pred_pm30, carga=0 )
      cgreen <- subset(pred_pm30, carga>0 & carga<=0.6)
      cyellow <- subset(pred_pm30, carga>0.6 & carga<=0.8)
      cred <- subset(pred_pm30, carga>0.8)  
      
      p <- p + geom_point(aes(x=longitud, y=latitud), data=cgray, col="gray", alpha=1.0) + labs(x = "longitud", y = "latitud")
      p <- p + geom_point(aes(x=longitud, y=latitud), data=cgreen, col="green", alpha=1.0) + labs(x = "longitud", y = "latitud")
      p <- p + geom_point(aes(x=longitud, y=latitud), data=cyellow, col="yellow", alpha=1.0) + labs(x = "longitud", y = "latitud")
      p <- p + geom_point(aes(x=longitud, y=latitud), data=cred, col="red", alpha=1.0) + labs(x = "longitud", y = "latitud")
    }
    
    if(map_type =='vmed_30min'){
      vgreen <- subset(predV_pm30, vmed>60)
      vyellow <- subset(predV_pm30, vmed>20 & vmed<=60)
      vred <- subset(predV_pm30, vmed<=20)
      
      p <- p + geom_point(aes(x=longitud, y=latitud), data=vgreen, col="green", alpha=1.0) + labs(x = "longitud", y = "latitud")
      p <- p + geom_point(aes(x=longitud, y=latitud), data=vyellow, col="yellow", alpha=1.0) + labs(x = "longitud", y = "latitud")
      p <- p + geom_point(aes(x=longitud, y=latitud), data=vred, col="red", alpha=1.0) + labs(x = "longitud", y = "latitud")
    }
    
   
    print(p)
    
    
    
  }, width = 900, height = 900)
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output 3 - Trend
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  output$trends1 <- renderPlot({
    
    id <- "1VyEqe1KE7uzVJOWvEVDpXjIvbmHPnCTo"
    trend <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))
    
    trend$ds <- as_datetime(trend$ds)
    
    pt1 <- trend %>% 
      ggplot(aes(x=ds,y=vmed)) + 
      geom_smooth() + theme_bw()
    
    pt2 <- trend %>% 
      ggplot(aes(x=ds,y=carga)) + 
      geom_smooth() + theme_bw()
    
    pt <- ggarrange(pt1, pt2 , ncol = 1, nrow = 2)
    
     print(pt)
    
  }, height = 900)
  
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Output 4 - Camera
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  #http://www.mc30.es/components/com_hotspots/datos/camaras.xml
  
 output$camera <- 
  
  renderText({ 
    
  id <- "1g10ZUEiH7S1cSP5feU1wiEMQbZ79_Mcb"
  camera_feed <- read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))
  
  
  cam_id <-  as.character(camera_feed[camera_feed$nombre == input$camera,]$id) 
  cam_url <-  as.character(camera_feed[camera_feed$nombre == input$camera,]$url) 
  
    c(
    '<img src="',
    #paste0("http://drive.google.com/uc?export=view&id=", cam_id),
    paste0("http://", cam_url),
    '">'
  )})
 
 ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ## Output 5 - Status
 ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 output$status <- renderDataTable({
   
   api_url <- "http://www.mc30.es/images/xml/DatosTrafico.xml"
   data <- read_xml(api_url)
   
   nombre <- data %>% xml_find_all("//DatoGlobal//Nombre") %>% xml_text()
   valor <- data %>% xml_find_all("//DatoGlobal//VALOR") %>% xml_integer()
   info <- cbind(nombre,valor)
   
   retenciones <- data %>% xml_find_all("//DatoTrafico//Retenciones") %>% xml_text()
   traficoLento <- data %>% xml_find_all("//DatoTrafico//TraficoLento") %>% xml_text()
   retenciones <- cbind("retenciones",retenciones)
   traficoLento <- cbind("traficoLento",traficoLento)
   
   status <- as.data.frame(rbind(info,retenciones,traficoLento))
   status <- status %>% filter(!nombre == "fechaActualizacionPMTunel") %>% filter(!nombre == "fechaActualizacionPMSuperficie") %>% filter(!nombre == "CortesImportantesWeb")
   
   ## Display df
   status
   
 })
     
   
})