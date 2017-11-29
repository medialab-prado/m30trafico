######################################################################
# Funcion:   f.carga.ficheros                                        #
#   Descripcion: carga los ficheros de los puntos de la M-30 defini- #
#                dos en el fichero de muestra                        #
#   Parametros:                                                      #
#               sfichero: nombre del fichero donde se encuentran los #
#                         datos con los que trabajamos               #
#               dt.puntos : nombre del fichero donde se encuentra la #
#                         muestra de puntos                          #
#   Salida    :                                                      #
#               tmp.file: data table con los registros y las colum-  #
#                         nas con los que vamos a trabajar.          #
######################################################################
f.carga.ficheros <- function(s.fichero, dt.punto){
  tmp.file <- as.data.table(read.csv(s.fichero, 
                                     sep=',',
                                     header = TRUE))
  tmp.file <- merge(tmp.file[tipo_elem == 'PUNTOS MEDIDA M-30'],
                    dt.punto[,list(identif)],
                    by.x='identif', by.y='identif',
                    all.x = FALSE, all.y = FALSE)
  tmp.file[, ds:=as.POSIXct(as.character(fecha), 
                            '%Y-%m-%d %H:%M:%S', 
                            tz="CET")]
  return(tmp.file[,list(ds,identif, carga, intensidad, ocupacion, vmed)])
}

######################################################################
# Funcion:   f.datos.previos                                         #
#   Descripcion: obtener los datos previos de cada punto en los      #
#                minutos previos indicados                           #
#   Parametros:                                                      #
#               dt.tabla: data table sobre el que trabajamos para    #
#                         buscar la información                      #
#               i.minutos : número de minutos hacia atras sobre los  #
#                         que buscamos la información.               #
#   Salida    :                                                      #
#               salida    : data table con los registros y las co-   #
#                         lumnas con los que vamos a trabajar.       #
######################################################################

f.datos.previos <-function(dt.tabla, i.minutos) {
  
  salida <- merge(dt.tabla[,list(identif, ds)], 
                  dt.tabla[,list(identif, 
                                 ds.xmin= ds-minutes(i.minutos),
                                 carga, vmed, intensidad, ocupacion)],
                  by.x= c('identif', 'ds'),
                  by.y= c('identif','ds.xmin'),
                  all.x = FALSE,
                  all.y = FALSE)
  colnames(salida)<-c("identif", 
                      "ds", 
                      paste0("carga.", i.minutos),
                      paste0("vmed.", i.minutos), 
                      paste0("intensidad.", i.minutos), 
                      paste0("ocupacion.", i.minutos)  )
  return(salida)
}

######################################################################
# Funcion:   calculo_error                                           #
#   Descripcion: calcular el RMSE de la predicción                   #
#   Parametros:                                                      #
#               dt.real: datos reales.                               #
#               dt.estimados: datos estimados.                       #
#   Salida    :                                                      #
#               salida    : RMSE                                     #
######################################################################
calculo_error <- function(dt.real, dt.estimado){
  
  error <- data.table(dt.real$identif,
                      dt.real$carga,
                      dif = dt.estimado$fit - dt.real$carga)
  
  error[, list(error=sum(as.numeric(dif))^2/.N)]
  
}


######################################################################
# Funcion:   Transformacion_variables                                #
#   Descripcion: Modifica el data set calculando los campos          #
#                necesarios.                                         #
#   Parametros:                                                      #
#               dt.real: datos reales.                               #
#   Salida    :                                                      #
#               salida    : Tabla con nuevos campos                  #
######################################################################
Transformacion_variables <- function(dt.real){
  
  #Carga: 
  dt.real[, var.carga.1:=(carga.2-carga.1)]
  dt.real[, var.carga.2:=(carga.3-carga.2)]
  dt.real[, var.carga.3:=(carga.4-carga.3)]
  
  #Velocidad:
  dt.real[, var.vmed.1:=0]
  dt.real[vmed.2!=vmed.1 & vmed.2==0, var.vmed.1:=1]
  dt.real[vmed.2!=vmed.1 & vmed.2!=0, var.vmed.1:=(vmed.2-vmed.1)/vmed.2]
  dt.real[, var.vmed.2:=0]
  dt.real[vmed.3!=vmed.2 & vmed.3==0, var.vmed.1:=1]
  dt.real[vmed.3!=vmed.2 & vmed.3!=0, var.vmed.2:=(vmed.3-vmed.2)/vmed.3]
  dt.real[, var.vmed.3:=0]
  dt.real[vmed.4!=vmed.3 & vmed.4==0, var.vmed.1:=1]
  dt.real[vmed.4!=vmed.3 & vmed.4!=0, var.vmed.3:=(vmed.4-vmed.3)/vmed.4]

  #Calculamos el dia de la semana como una variable secuencial:
  dt.real[, diaLunes:=0]
  dt.real[diaSemana  == 'Monday'   , diaLunes:=1]
  dt.real[, diaMartes:=0]
  dt.real[diaSemana == 'Tuesday'  , diaMartes:=1]
  dt.real[, diaMiercoles:=0]
  dt.real[diaSemana == 'Wednesday', diaMiercoles:=1]
  dt.real[, diaJueves:=0]
  dt.real[diaSemana == 'Thursday' , diaJueves:=1]
  dt.real[, diaViernes:=0]
  dt.real[diaSemana == 'Friday'   , diaViernes:=1]
  dt.real[, diaSabado:=0]
  dt.real[diaSemana == 'Saturday' , diaSabado:=1]
  dt.real[, diaDomingo:=0]
  dt.real[diaSemana == 'Sunday'   , diaDomingo:=1]
  
  #Calculamos los laborables y festivos dando mas peso a los festivos:
  dt.real <- dt.real[!is.na(laborable...festivo...domingo.festivo)]
  dt.real[laborable...festivo...domingo.festivo == 'laborable'   ,
              n.festivo:=0]
  dt.real[laborable...festivo...domingo.festivo == 'sabado',
              n.festivo:=1]
  dt.real[laborable...festivo...domingo.festivo == 'domingo' ,
              n.festivo:=2]
  dt.real[laborable...festivo...domingo.festivo == 'festivo'   ,
              n.festivo:=3]
  
  return(dt.real)
}

