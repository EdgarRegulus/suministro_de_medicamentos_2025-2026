# 5_visualizacion

Esta carpeta contiene el archivo de Tableau utilizado para la exploración, análisis y visualización de los resultados del proyecto **Análisis de solicitudes y entrega de medicamentos en el sector salud**, así como las exportaciones individuales de cada visualización utilizadas en la presentación final.

## Contenido

| Archivo                    | Descripción                                                                            |
| -------------------------- | -------------------------------------------------------------------------------------- |
| `vis.twb` / `vis.twbx`     | Libro de trabajo de Tableau con todas las visualizaciones del proyecto.                |
| `vis1.pptx` – `vis10.pptx` | Exportaciones individuales de las visualizaciones utilizadas en la presentación final. |

## Origen de los datos

Las visualizaciones fueron construidas a partir de los conjuntos de datos depurados y estandarizados generados en la carpeta `Output`.

### Fuentes integradas

* Remisiones de medicamentos e insumos.
* Adjudicaciones de medicamentos.
* Censo de Población y Vivienda 2020 (INEGI).
* Información complementaria de proveedores.

### Relaciones utilizadas

| Tabla origen | Tabla destino  | Campo de relación |
| ------------ | -------------- | ----------------- |
| remisiones   | adjudicaciones | procedimiento     |
| remisiones   | cpv20          | entidad           |

## Objetivos de las visualizaciones

Las visualizaciones fueron desarrolladas para responder cuatro preguntas principales:

### 1. Tipos de procedimiento

Comparar el volumen total de piezas entregadas entre procedimientos consolidados y no consolidados, identificando la participación relativa de cada esquema de adquisición.

### 2. Distribución temporal

Analizar el comportamiento de las solicitudes y entregas de medicamentos a nivel mensual y semanal, diferenciando instituciones y patrones de demanda.

### 3. Oportunidades de ahorro

Identificar adjudicaciones con diferencias significativas entre el precio pagado y el precio mínimo observado para una misma clave de medicamento, estimando posibles oportunidades de ahorro.

### 4. Distribución geográfica

Evaluar la distribución territorial de medicamentos mediante indicadores de volumen, diversidad de claves y métricas per cápita por entidad federativa.

## Visualizaciones incluidas

Las visualizaciones del workbook abarcan los siguientes temas:

### Participación por tipo de procedimiento

Comparación del volumen de piezas entregadas entre compras consolidadas y no consolidadas, así como su distribución por institución.

### Distribución temporal mensual

Evolución mensual de las piezas solicitadas y entregadas, permitiendo identificar estacionalidad, picos de demanda y periodos de menor actividad.

### Distribución temporal semanal

Análisis de alta resolución temporal para detectar variaciones semanales, concentraciones de demanda y sincronización entre solicitudes y entregas.

### Identificación de sobreprecios

Clasificación de adjudicaciones según su margen porcentual respecto al precio mínimo observado para cada medicamento.

### Oportunidades de ahorro

Estimación del ahorro potencial asociado a adjudicaciones realizadas por encima del precio mínimo disponible.

### Diversidad de medicamentos

Número de claves únicas de medicamentos entregadas por entidad federativa como indicador de cobertura terapéutica.

### Volumen de medicamentos

Distribución territorial de piezas entregadas para identificar regiones con mayor concentración logística.

### Indicadores per cápita

Relación entre volumen de medicamentos entregados y población estatal utilizando información del Censo de Población y Vivienda 2020.

### Distribución por tipo de unidad

Comparación entre entregas destinadas a almacenes y entregas dirigidas directamente a unidades médicas.

## Herramientas utilizadas

* Tableau
* R
* tidyverse
* readxl

## Dependencias

Las visualizaciones dependen de los archivos procesados generados en la carpeta `Output`. Cualquier actualización de los datos requiere la actualización correspondiente de las fuentes de datos dentro del workbook de Tableau.

## Nota

Las presentaciones PowerPoint incluidas en esta carpeta corresponden a exportaciones de apoyo utilizadas para la elaboración de la presentación ejecutiva final. El archivo de Tableau constituye la fuente principal de las visualizaciones y permite la exploración interactiva de los resultados.
