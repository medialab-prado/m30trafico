## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Prediction
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


library(readr)
library(dplyr)

path <-"~/RStudio/Dataton2017/M30/"
setwd(path)


#load selected model
load("./models/mRLM15min.RData")


#get a vector of all filenames
files <- list.files(path="./data/traffic",pattern=".csv",full.names = TRUE,recursive = TRUE)

#get the directory names of these (for grouping)
dirs <- dirname(files)

#find the last file  (i.e. latest modified time)
lastfile <- tapply(files,dirs,function(v) v[which.max(file.mtime(v))])

#load data
data <- read_csv(lastfile, 
                 col_types = cols(Mes = col_character(), 
                                  diaMes = col_character(), intensidad.15 = col_skip(), 
                                  ocupacion.15 = col_skip(), velocidad.15 = col_skip()))

#calculate prediction
prediction <- predict(model, newdata=data)

pred_pm30 <- as.data.frame(cbind(data$identif, prediction))

colnames(pred_pm30) <- c("identif", "carga")


#Save Data

file_path <- "./data/prediction/"
file_name <- paste0("pred",format(Sys.Date(), "%Y"), format(Sys.Date(), "%m"), format(Sys.Date(), "%d"), format(Sys.time(), "%H"),format(Sys.time(), "%M") ,".csv")


write.csv(pm30, paste(file_path, file_name, sep=''), row.names=FALSE)
