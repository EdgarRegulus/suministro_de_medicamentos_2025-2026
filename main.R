# ============================================================
# PROYECTO: Análisis de adquisición y distribución de medicamentos
#           Secretaría de Salud - Ciudad de México
#
# OBJETIVO:
# Analizar las órdenes de suministro de medicamentos para:
# - Comparar piezas entregadas entre procedimientos consolidados
#   y no consolidados.
# - Evaluar la distribución temporal (mensual y semanal) de la demanda.
# - Identificar oportunidades de mejora en precios de adquisición.
# - Analizar la distribución geográfica de medicamentos y su relación
#   con la población.
#
# ANALISTA:
# Edgar Muñoz Sánchez
#
# FUENTES DE DATOS:
# - Plataforma de monitoreo de medicamentos (Secretaría de Salud)
# - Seguimiento de adjudicaciones
# - INEGI - Censo de Población y Vivienda 2020
#
# PERIODO DE ANÁLISIS:
# Mayo 2025 – Febrero 2026
#
# CREADO EN:
# 5 de mayo de 2026, 11:53am
#
# ÚLTIMA MODIFICACIÓN:
# 5 de mayo de 2026, 11:53am

library(tidyverse) #Paquete para trabajar de forma coherente y eficiente con datos. tidy: ordenado
library(readxl)
setwd("~/SS_Suministro_de_medicamentos_Mayo_2026") #1. Cambiar a la carpeta de trabajo
rm(list = ls()) #Limpiar el enviroment.

# ATAJOS RECOMENDADOS
# <-: Alt + -
# %>%: Ctrl + Shift + M
# Cursor en varias líneas: Ctrl + Alt

entidades_dic <- c( #Formato de las entidades TABLEAU-friendly
  "AGUASCALIENTES" = "Aguascalientes",
  "BAJA CALIFORNIA" = "Baja California",
  "BAJA CALIFORNIA SUR" = "Baja California Sur",
  "CAMPECHE" = "Campeche",
  "COAHUILA" = "Coahuila",
  "COLIMA" = "Colima",
  "CHIAPAS" = "Chiapas",
  "CHIHUAHUA" = "Chihuahua",
  "CIUDAD DE MÉXICO" = "Ciudad de México",
  "DURANGO" = "Durango",
  "GUANAJUATO" = "Guanajuato",
  "GUERRERO" = "Guerrero",
  "HIDALGO" = "Hidalgo",
  "JALISCO" = "Jalisco",
  "MÉXICO" = "Estado de México",
  "ESTADO DE MÉXICO" = "Estado de México",
  "MICHOACÁN" = "Michoacán",
  "MORELOS" = "Morelos",
  "NAYARIT" = "Nayarit",
  "NUEVO LEÓN" = "Nuevo León",
  "OAXACA" = "Oaxaca",
  "PUEBLA" = "Puebla",
  "QUERÉTARO" = "Querétaro",
  "QUINTANA ROO" = "Quintana Roo",
  "SAN LUIS POTOSÍ" = "San Luis Potosí",
  "SINALOA" = "Sinaloa",
  "SONORA" = "Sonora",
  "TABASCO" = "Tabasco",
  "TAMAULIPAS" = "Tamaulipas",
  "TLAXCALA" = "Tlaxcala",
  "VERACRUZ" = "Veracruz",
  "YUCATÁN" = "Yucatán",
  "ZACATECAS" = "Zacatecas"
)

#FUNCIONES
limpiar_proc <- function(x) {
  x %>%
    str_replace_all("\u00A0", " ") %>%      # espacios invisibles de Excel
    str_to_upper() %>%                      # estandarizar primero
    str_replace_all("[“”\"]", "") %>%       # comillas tipográficas
    str_replace_all(",", "") %>%            # comas
    str_replace_all("FASE\\s*\\d+", "") %>% # más flexible: FASE 1, FASE2, etc.
    str_replace_all("\\(.*?\\)", "") %>%    # no-greedy para evitar borrar de más
    str_squish()                            # reemplaza múltiples espacios + trim
}

conteo_unicos <- function(x) {
  x %>% summarise(across(everything(), ~ n_distinct(.))) %>%
    tidyr::pivot_longer(cols = everything(),
                        names_to = "variable",
                        values_to = "unicos")
}
# ============================================================

# Cargar conjunto de datos remisiones.csv
remisiones <- read_csv("2_conjunto_datos/remisiones.csv", locale = locale(encoding = "UTF-8")) %>%   
  filter(fecha_solicitud >= as.Date("2025-05-01")) %>%     #Seleccion de periodo del análilsis
  select(
    clave,                      # ID del insumo
    descripcion,                # Descripción del insumo
    institucion,                # Institución que realiza la solicitud o entrega (IMSS, ISSSTE, PEMEX, etc)
    entidad,                    # Entidad federativa donde se hace la solicitud o entrega
    unidad_medica,              # Unidad específica donde se hace la solicitud o entrega
    suministro,                 # Orden de suministro ? No completa
    procedimiento = licitacion, # Clave del procedimiento
    tipo_procedimiento_1,       # Tipo de compra (CONSOLIDADO, O NO CONSOLIDADO)
    contrato,                   # Contrato
    estatus,                    # Estado de la orden (COMPLETA, INCOMPLETA, EN TRÁNSITO)
    fecha_solicitud,            # Fecha en la que se solicitó el insumo
    piezas_solicitadas,         # Cantidad de piezas requeridas
    proveedor,                  # Empresa responsable de surtir el medicamento
    fecha_entrega,              # Fecha en la que se entregó el insumo
    piezas_entregadas,          # Cantidad de piezas efectivamente entregadas
    fecha_limite,               # Fecha máxima comprometida para la entrega
    canceladas_activas          # Indica si la orden está activa o cancelada
    ) %>%  
  mutate(                      # Crea o modifica columnas
    tipo_unidad = ifelse(      # Nueva columna 'tipo_unidad' con condición lógica
      str_detect(              # Busca si se cumple una condición en texto
        unidad_medica,         # Columna donde se buscará la palabra
        regex("ALMACEN|ALMACÉN", ignore_case = TRUE)  
        # Expresión regular que busca "ALMACEN" o "ALMACÉN"
        # ignore_case = TRUE permite ignorar mayúsculas/minúsculas
      ),
      "ALMACEN",               # Valor si la condición es TRUE (sí contiene la palabra)
      "UNIDAD MEDICA"          # Valor si la condición es FALSE (no contiene la palabra)
    ),
    .after = unidad_medica     # Coloca la nueva columna justo después de 'unidad_medica'
  ) %>% 
  rename(tipo_procedimiento = tipo_procedimiento_1) %>% #Renombrar la columna
  mutate(  
    tipo_procedimiento = ifelse(is.na(tipo_procedimiento), "DESCONOCIDO", tipo_procedimiento),
    proveedor = ifelse(is.na(proveedor), "DESCONOCIDO", proveedor),
    descripcion = ifelse(is.na(descripcion), "DESCONOCIDO", descripcion),
    contrato = ifelse(is.na(contrato), "DESCONOCIDO", contrato),
    suministro = ifelse(is.na(suministro), "DESCONOCIDO", suministro)
    )%>%      
  arrange(unidad_medica) %>% 
  arrange(tipo_unidad) %>% 
  arrange(fecha_solicitud)

# Cargar conjunto de datos de adjudicaciones.xlsx
adjudicaciones <- read_excel("2_conjunto_datos/adjudicaciones.xlsx", sheet = 1, range = NULL,
                             col_names = c("clave", "descripcion", "tipo_insumo", "grupo_terapeutico", "procedimiento", "tipo_procedimiento", "proveedor", "institucion", "unidad_medica", "precio", "cantidad", "valor"),
                             skip = 1) %>% select(
                               clave,               # ID del insumo
                               descripcion,         # Descripción del insumo
                               tipo_insumo,         # Tipo de insumo
                               grupo_terapeutico,   #Grupo terapéutico al que pertenece el insumo
                               procedimiento,       # Clave del procedimiento
                               tipo_procedimiento,  # Tipo de compra (CONSOLIDADO, O NO CONSOLIDADO)
                               proveedor,
                               institucion,         # Institución que realiza la solicitud o entrega (IMSS, ISSSTE, PEMEX, etc)
                               unidad_medica,       # Unidad específica donde se hace la solicitud o entrega
                               precio,
                               cantidad,
                               valor
                             ) %>% 
  mutate(
    tipo_insumo = ifelse(is.na(tipo_insumo), "DESCONOCIDO", tipo_insumo),
    grupo_terapeutico = ifelse(is.na(grupo_terapeutico), "DESCONOCIDO", grupo_terapeutico),
    tipo_procedimiento = ifelse(is.na(tipo_procedimiento), "DESCONOCIDO", tipo_procedimiento)
  ) %>% 
  arrange(procedimiento)

#cargar conjunto de datos de proveedores.xlsx
proveedores <- read_excel("2_conjunto_datos/proveedores.xlsx", sheet = 1, range = NULL,
                          col_names = c("proveedor", "proveedor_piezas_solicitadas", "proveedor_piezas_entregadas", "proveedor_cumplimiento", "proveedor_grupo"),
                          skip = 1)

# Cargar conjunto de datos poblacionales Censo de Población y Vivienda 2020
cpv <- read_csv("2_conjunto_datos/cpv20.csv", locale = locale(encoding = "UTF-8")) %>% 
  filter(NOM_LOC == "Total de la Entidad" | NOM_LOC == "Total nacional") %>% 
  select(
    id_entidad = ENTIDAD, # ID de la entidad federativa
    entidad = NOM_ENT,    # Nombre oficial de la entidad federativa
    NOM_LOC,              # Localidad "Total de la entidad"
    POBTOT,               # Total de personas que residen en la entidad federativa
    POBFEM,               # Total de mujeres que residen en la entidad
    POBMAS,               # Total de hombres que residen en la entidad
    PSINDER,              # Total de personas no afiliadas a servicios médicos en ninguna institución pública o privada
    PDER_SS,              # Total de personas que están afiliadas a servicios médicos en alguna institución de salud pública o privada
    PDER_IMSS,            # Total de personas afiliadas a servicios médicos en IMSS
    PDER_ISTE,            # Total de personas afiliadas a servicios médicos en ISTEE
    PDER_ISTEE,           # Total de personas afiliadas a servicios médicos en ISTEE estatal
    PAFIL_PDOM,           # Total de personas afiliadas a servicios médicos en PEMEX, SEDENA o SEMAR
    PDER_SEGP,            # Total de personas afiliadas a servicios médicos en Secretaría de Salud mediante el Instituto de Salud para el Bienestar
    PDER_IMSSB,           # Total de personas afiliadas a servicios médicos en IMSS Bienestar
    PAFIL_IPRIV,          # Total de personas afiliadas a servicios médicos en instituciones de salud privadas
    PAFIL_OTRAI)%>%       # Total de personas que están afiliadas a servicios médicos en cualquier otra institución de salud pública o privada
  mutate(    # Formato TABLEAU-Friendly al dataframe de inegi de las entidades
    entidad = case_when(
      entidad == "Coahuila de Zaragoza" ~ "Coahuila",
      entidad == "Veracruz de Ignacio de la Llave" ~ "Veracruz",
      entidad == "Michoacán de Ocampo" ~ "Michoacán",
      entidad == "México" ~ "Estado de México",
      entidad == "Total nacional" ~ "México", 
      TRUE ~ entidad
    ), #Estandarizar tipo de datos de las columnas cadena -> numerico
    POBFEM = as.numeric(POBFEM),
    POBMAS = as.numeric(POBMAS),
    PSINDER = as.numeric(PSINDER),
    PDER_SS = as.numeric(PDER_SS),
    PDER_IMSS = as.numeric(PDER_IMSS),
    PDER_ISTE = as.numeric(PDER_ISTE),
    PDER_ISTEE = as.numeric(PDER_ISTEE),
    PAFIL_PDOM = as.numeric(PAFIL_PDOM),
    PDER_SEGP = as.numeric(PDER_SEGP),
    PDER_IMSSB = as.numeric(PDER_IMSSB),
    PAFIL_PDOM = as.numeric(PAFIL_PDOM),
    PAFIL_IPRIV = as.numeric(PAFIL_IPRIV),
    PAFIL_OTRAI = as.numeric(PAFIL_OTRAI)
  )

#===========================================================
# 2. PREPARAR
# EXPLORACION DE DATOS INICIAL
str(remisiones)
str(adjudicaciones)
str(proveedores)
str(cpv)

glimpse(cpv)                     # (dplyr) Muestra una vista rápida del dataframe 
summary(adjudicaciones)                     # Resumen estadístico de cada columna
head(adjudicaciones)                        # Ver las primeras filas de un df, tibble o vector
#head(remisiones$fecha_limite)          # Ver las primeras filas de una columna

# VALORES ÚNICOS POR COLUMNA  ANTES DE LIMPIEZA
conteo_unicos(remisiones)
conteo_unicos(adjudicaciones)
conteo_unicos(proveedores)
conteo_unicos(cpv)

# DATOS FALTANTES
sum(is.na(remisiones$procedimiento))       # Cuenta cuántos valores NA (faltantes) hay en una columna específica de una tabla específica
colSums(is.na(remisiones))                 # Cuenta cuántos valores NA (faltantes) hay en cada column de una tabla específica
colSums(is.na(adjudicaciones))              
colSums(is.na(proveedores))
colSums(is.na(cpv))


# COHERENCIA ENTRE TABLAS
##procedimiento
#remisiones$procedimiento <- limpiar_proc(remisiones$procedimiento)
#adjudicaciones$procedimiento <- limpiar_proc(adjudicaciones$procedimiento)
#setdiff(unique(remisiones$procedimiento), unique(adjudicaciones$procedimiento)) #Muestra valores en remisiones pero no en adjudicaciones
#setdiff(unique(adjudicaciones$procedimiento), unique(remisiones$procedimiento)) #Muestra valores en adjudciaciones pero no en remisiones
#df <- remisiones %>%select(procedimiento, procedimiento_limpio)
#
##clave
#length(unique(remisiones$clave))
#remisiones$clave <- limpiar_proc(remisiones$clave)
#length(unique(remisiones$clave))
#length(unique(adjudicaciones$clave))
#adjudicaciones$clave <- limpiar_proc(adjudicaciones$clave)
#length(unique(adjudicaciones$clave))

#===========================================================
# 3. PROCESAR 

# LIMPIEZA GENERAL
remisiones <- remisiones %>%
  mutate(across(where(is.character), limpiar_proc))
adjudicaciones <- adjudicaciones %>%
  mutate(across(where(is.character), limpiar_proc))
proveedores <- proveedores %>%
  mutate(across(where(is.character), limpiar_proc))

#Cambiar formatos de las entidades (Tableau-Friendly)
remisiones <- remisiones %>% mutate(  
  entidad = recode(entidad, !!!entidades_dic)) 


# VALORES ÚNICOS POR COLUMNA - DESPUÉS DE LIMPIEZA
sort(unique(remisiones$entidad))                # Revisar los valores únicos de alguna columna (variable)
length(unique(adjudicaciones$procedimiento))        # Contar los valores únicos de alguna columna (variable)
sum(remisiones$canceladas_activas == "CANCELADA") #Cuenta cuántos valores específicos hay en una columna específica

conteo_unicos(remisiones)
conteo_unicos(adjudicaciones)
conteo_unicos(proveedores)
conteo_unicos(cpv)

#DATOS REPETIDOS ¿Serán registros válidos? No cuento con forma de saberlo. 
#Por ende estos 120 registros no serán eliminados.
nrow(remisiones[duplicated(remisiones), ]) #120                                                   # Cuenta número de filas duplicadas
remisiones_dup <- remisiones[duplicated(remisiones) | duplicated(remisiones, fromLast = TRUE), ]  # Muestra todas las filas que están duplicadas
#Conviene usar distinct para eliminar duplicados y dejar solo uno
remisiones_sin_dup <- remisiones %>% distinct() 
nrow(remisiones_sin_dup[duplicated(remisiones_sin_dup), ])  #0   
nrow(adjudicaciones[duplicated(adjudicaciones), ]) #0
nrow(proveedores[duplicated(proveedores), ]) #0
nrow(cpv[duplicated(cpv), ]) #0

conteo_unicos(remisiones_sin_dup)

#MAS OPERACIONES | CALCULOS

#separate(df, column, into = c("new_column_1", "new_column_2", sep = ' ')) # Función que permite dividir una columna en varias mediante un separador
#unite(df, "nombre_de_la_columna", columna1, columna2, sep = ' ') # Función que combina dos columnas en una con un separador
#mutate(new_column = calculos)
#summarize(columna1, columna2, etc)
#pivot_longer() # tidyr: +filas, -columnas
#pivot_wider() # tidyr: +columnas, -filas

# COHERENCIA ENTRE TABLAS
setdiff(unique(adjudicaciones$procedimiento), unique(remisiones$procedimiento)) #Muestra valores en adjudciaciones pero no en remisiones
setdiff(unique(remisiones$procedimiento), unique(adjudicaciones$procedimiento)) #Muestra valores en remisiones pero no en adjudicaciones

adjudicaciones_filt <- adjudicaciones %>% #Garantiza el periodo de adjudicaciones
  mutate(grupo_terapeutico = str_replace_all(grupo_terapeutico, "\\|", "")) %>% 
  filter(procedimiento %in% remisiones$procedimiento)

# COHERENCIA ENTRE TABLAS
setdiff(unique(adjudicaciones$procedimiento), unique(remisiones$procedimiento)) #Muestra valores en adjudciaciones pero no en remisiones
setdiff(unique(remisiones$procedimiento), unique(adjudicaciones$procedimiento)) #Muestra valores en remisiones pero no en adjudicaciones


#REVISION
str(remisiones_sin_dup)
str(adjudicaciones_filt)
str(proveedores)
str(cpv)

# VALORES ÚNICOS POR COLUMNA  ANTES DE LIMPIEZA
conteo_unicos(remisiones_sin_dup)
conteo_unicos(adjudicaciones_filt)
conteo_unicos(proveedores)
conteo_unicos(cpv)

# DATOS FALTANTES
sum(is.na(remisiones$procedimiento))       # Cuenta cuántos valores NA (faltantes) hay en una columna específica de una tabla específica
colSums(is.na(remisiones_sin_dup))        
colSums(is.na(adjudicaciones_filt))              
colSums(is.na(proveedores))
colSums(is.na(cpv))

# CONSISTENCIA POR CATEGORIAS
sort(unique(remisiones_sin_dup$institucion))
sort(unique(remisiones_sin_dup$entidad))
sort(unique(remisiones_sin_dup$tipo_unidad))
sort(unique(remisiones_sin_dup$tipo_procedimiento))
sort(unique(remisiones_sin_dup$estatus))
sort(unique(remisiones_sin_dup$canceladas_activas))

sort(unique(adjudicaciones_filt$tipo_insumo))
sort(unique(adjudicaciones_filt$grupo_terapeutico))
sort(unique(adjudicaciones_filt$entidad))
sort(unique(adjudicaciones_filt$institucion))
sort(unique(adjudicaciones_filt$unidad_medica))

sort(unique(proveedores$proveedor_grupo))
sort(unique(proveedores$proveedor))

sort(unique(cpv$id_entidad))
sort(unique(cpv$entidad))
sort(unique(cpv$NOM_LOC))

#RANGO Y VALORES TÍPICOS
summary(remisiones_sin_dup)
summary(adjudicaciones_filt)
summary(proveedores)
summary(cpv)


# DATOS REPETIDOS
nrow(remisiones_sin_dup[duplicated(remisiones_sin_dup), ])  #0   
nrow(adjudicaciones[duplicated(adjudicaciones), ]) #0
nrow(proveedores[duplicated(proveedores), ]) #0
nrow(cpv[duplicated(cpv), ]) #0

adjudicaciones_filt <- adjudicaciones_filt %>% 
  mutate(
   tipo_procedimiento = ifelse(is.na(tipo_procedimiento), "DESCONOCIDO", tipo_procedimiento)
  )



#==========================================================
# 4.ANÁLISIS
# CONSULTAS ADICIONALES
#df <- full_join(remisiones, adjudicaciones)

#COHERENCIA ENTRE VARIABLES RELACIONADAS
# SOBREENTREGAS POR PEDIDO - 103 (No necesariamente incoherentes)
#df <- remisiones %>%
#  filter(piezas_entregadas > piezas_solicitadas)

# SOBREENTREGAS POR PROVEEDOR - 0
#df <-  proveedores %>% 
#  filter(proveedor_piezas_entregadas > proveedor_piezas_solicitadas)

#df <- remisiones %>% filter(unidad_medica == "# 41 U.P.N. S.E.P")

#=========================================================
# GUARDAR BASES DE DATOS
write_csv(remisiones, "4_output/remisiones.csv") 
write_csv(adjudicaciones_filt, "4_output/adjudicaciones.csv") 
write_csv(cpv, "4_output/cpv.csv") 
write_csv(proveedores, "4_output/proveedores.csv") 
