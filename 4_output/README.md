# 4_output — Resultados del procesamiento de datos
Estos archivos no se incluyen en el repositorio debido a su tamaño, ya que son demasiado pesados para ser versionados de forma eficiente. Por ello, el repositorio contiene únicamente el script `main.R`, que permite reproducir todo el proceso de generación de los datos desde cero.

Esta carpeta contiene los archivos finales generados a partir del script principal en R (`main.R`). Estos archivos representan el resultado del proceso de limpieza, estandarización, integración y análisis de los datos provenientes de remisiones, adjudicaciones y catálogo CPV20.

El objetivo del pipeline fue transformar datos administrativos dispersos en un conjunto estructurado, consistente y listo para análisis, permitiendo explorar relaciones entre procedimientos, entidades, proveedores e insumos médicos.

---

## Proceso realizado en `main.R`

El script `main.R` sigue una serie de etapas encadenadas para preparar los datos:

Primero se realiza la carga de las bases originales (remisiones, adjudicaciones y CPV20).

Después se aplica un proceso de limpieza y estandarización, donde se corrigen formatos inconsistentes, se eliminan caracteres invisibles, se normalizan textos y se ajustan tipos de variables para su uso analítico.

Posteriormente se lleva a cabo la depuración de duplicados y la validación de llaves de unión, con el fin de asegurar coherencia entre campos clave como procedimiento, entidad, clave de insumo y proveedor.

Durante esta etapa se encontraron algunos casos en los que ciertos campos venían vacíos desde la fuente original. En particular, algunos tipos de procedimiento y descripciones de medicamento no estaban disponibles. Para evitar perder registros en el análisis, estos valores se estandarizaron posteriormente como **“DESCONOCIDO”**. Es importante aclarar que esto no corresponde a una categoría real del sistema, sino a información faltante en la fuente.

Finalmente, se generan variables derivadas y agregaciones, como totales, rankings y concentraciones por entidad y proveedor, que permiten el análisis exploratorio y la construcción de visualizaciones.

---

## Archivos generados

### remisiones.xlsx  
Contiene el dataset de remisiones ya limpio y estandarizado.

Incluye registros válidos, claves normalizadas y variables listas para análisis.

Es la base principal para análisis posteriores.

---

### adjudicaciones.xlsx  
Contiene la base de adjudicaciones depurada y estructurada.

Permite analizar la asignación de procedimientos y su relación con proveedores e insumos.

En algunos casos, ciertos campos aparecen como **“DESCONOCIDO”**, lo cual corresponde a información que no venía capturada en la fuente original.

---

### cpv20.xlsx  
Contiene el catálogo CPV20 limpio y normalizado.

Sirve para clasificar y estandarizar las claves de insumos utilizadas en el análisis.



## Nota final

Todo el contenido de esta carpeta se genera automáticamente desde el script `main.R`, asegurando que el proceso sea reproducible y trazable en cualquier momento.
