## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Get data from camera API
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(xml2)
library(readr)
library(dplyr)

path <-"~/RStudio/Dataton2017/M30/"
setwd(path)

api_url <- "http://www.mc30.es/components/com_hotspots/datos/camaras.xml"

data <- read_xml(api_url)

nombre <- data %>% xml_find_all("//Fichero") %>% xml_text()
url <- data %>% xml_find_all("//URL") %>% xml_text()


cfeed <- as.data.frame(cbind(nombre, url))


for (i in 1:nrow(cfeed)) {
  
 link <- as.character(cfeed[i,]$url)
 name <- as.character(cfeed[i,]$nombre)
 
 download.file(link,paste0("./data/camera/",name))
 

}


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Save Data
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


file_path <- "./data/camera/"
file_name <- "camera_feed.csv"


write.csv(cfeed, paste(file_path, file_name, sep=''), row.names=FALSE)
