## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Get data from traffic API
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(xml2)
library(readr)
library(dplyr)

path <-"~/RStudio/Dataton2017/M30/"
setwd(path)

api_url <- "http://informo.munimadrid.es/informo/tmadrid/pm.xml"

data <- read_xml(api_url)

codigo <- data %>% xml_find_all("//codigo") %>% xml_text()
carga <- data %>% xml_find_all("//carga") %>% xml_integer()
intensidad <- data %>% xml_find_all("//intensidad") %>% xml_integer()
ocupacion <- data %>% xml_find_all("//ocupacion") %>% xml_integer()
velocidad <- data %>% xml_find_all("//velocidad") %>% xml_integer()



pm <- as.data.frame(cbind(codigo, carga, intensidad, ocupacion,velocidad))


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Georeference
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

pm_Georeferencia <- read_csv("./data/pm/PM_Georeferencia.csv")

pm30 <- pm %>% filter(codigo %in% pm_Georeferencia$identif)

Hora <- format(Sys.time(), "%H")
diaSemana <- weekdays(as.Date(Sys.Date()))
diaMes <- format(Sys.Date(), "%d")
Mes <- format(Sys.Date(), "%m")

pm30 <- as.data.frame(cbind(pm30, Hora, diaSemana, diaMes, Mes))


colnames(pm30) <- c("identif", "carga.15", "intensidad.15", "ocupacion.15", "velocidad.15", "Hora", "diaSemana", "diaMes", "Mes")



## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Save Data
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


file_path <- "./data/traffic/"
file_name <- paste0(format(Sys.Date(), "%Y"), format(Sys.Date(), "%m"), format(Sys.Date(), "%d"), format(Sys.time(), "%H"),format(Sys.time(), "%M") ,".csv")


write.csv(pm30, paste(file_path, file_name, sep=''), row.names=FALSE)

