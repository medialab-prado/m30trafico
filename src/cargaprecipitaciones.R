####################################################################################################################
# Descarga de los datos meteorológicos desde AEMET
####################################################################################################################

# es necesario obtener una API key válida durante 5 días en https://opendata.aemet.es/centrodedescargas/altaUsuario?
# Después, en https://opendata.aemet.es/centrodedescargas/productosAEMET? introducir la API key 
# y seleccionar los parámetros de interés. Cada consulta nos proporcionará una url que contiene
# los datos estilo json. Se guardan en .txt (en este caso "precipitaciones2017.txt) para parsearlo después.

library(rjson)
library(lubridate)

setwd("~/Escritorio/m30/datasets")
json_data <- fromJSON(paste(readLines("precipitaciones2017.txt"), collapse="")) #cargamos el txt

#lo transformamos en un dataframe

df <- data.frame() #creamos un dataframe vacío

for(n in json_data){ #función que va leyendo las variables y va rellenando el dataframe
  fecha <- n$fecha #en nuestro caso solo nos interesan la fecha y las precipitaciones
  # indicativo <- n$indicativo
  # nombre <- n$nombre
  # provincia <- n$provincia
  # altitud <- n$altitud
  # tmed <- n$tmed
  prec <- n$prec
  # tmin <- n$tmin
  # horatmin <- n$horatmin
  # tmax <- n$tmax
  # horatmax <- n$horatmax
  # dir <- n$dir
  # velmedia <- n$velmedia
  # racha <- n$racha
  # horaracha <- n$horaracha
  # presMax <- n$presMax
  # horaPresMax <- n$horaPresMax
  # presMin <- n$presMin
  # horaPresMin <- n$horaPresMin
  newrow <- data.frame(fecha, prec) #(indicativo, nombre, provincia, altitud, tmed, prec, tmin, horatmin, tmax, horatmax, dir, velmedia, racha, horaracha, presMax, horaPresMax, presMin)
  df <- rbind(df, newrow)
  rm(newrow, json_data, fecha, n, prec) #borrar los values creados
  df$prec <- as.numeric(gsub(',', '.', df$prec)) # hay que cambiar las comas por puntos
  df$prec[is.na(df$prec)] <- 0.0   #cuando aparece el valor Ip (inapreciable) lo transforma en NA ahora son 0.0
  df$fecha <- ymd(df$fecha)
}

write.csv(df, "precipitaciones2017.csv", row.names = FALSE) #lo guardamos en un .csv
  
  

