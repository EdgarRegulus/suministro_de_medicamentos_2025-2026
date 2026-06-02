# 2_conjunto_de_datos

Esta carpeta contiene las fuentes de datos utilizadas para analizar la adquisición y distribución de medicamentos en instituciones públicas de salud de México.

## Fuentes de datos

### Remisiones de medicamentos e insumos
https://monitoreocompra.salud.gob.mx/compra/

Base de datos operativa que registra las solicitudes de medicamentos e insumos médicos realizadas por instituciones públicas de salud.

### Adjudicaciones de medicamentos
https://entregamedicamentos.salud.gob.mx/insumos/

Base de datos de procedimientos de contratación y adquisición de medicamentos, incluyendo precios, cantidades y proveedores adjudicados.

### Censo de Población y Vivienda 2020 (INEGI)
https://www.inegi.org.mx/programas/ccpv/2020/

Fuente demográfica utilizada para contextualizar territorialmente la distribución de medicamentos y construir indicadores per cápita.

> Del Censo de Población y Vivienda 2020 únicamente se utilizaron los registros agregados a nivel entidad federativa.

---

## Archivos

### remisiones.csv

Registro de solicitudes y entregas de medicamentos e insumos médicos.

Variables principales:

- Clave del medicamento.
- Descripción.
- Institución solicitante.
- Entidad federativa.
- Unidad médica.
- Procedimiento de compra.
- Proveedor.
- Fecha de solicitud.
- Fecha de entrega.
- Piezas solicitadas.
- Piezas entregadas.

Uso en el proyecto:

- Análisis de demanda.
- Distribución temporal.
- Distribución geográfica.
- Evaluación logística de entregas.

---

### adjudicaciones.xlsx

Información de procedimientos de adquisición de medicamentos.

Variables principales:

- Clave del medicamento.
- Grupo terapéutico.
- Procedimiento de contratación.
- Tipo de procedimiento.
- Proveedor.
- Precio unitario.
- Cantidad adjudicada.
- Valor total.

Uso en el proyecto:

- Identificación de sobreprecios.
- Estimación de oportunidades de ahorro.
- Comparación de precios entre procedimientos de compra.

---

### cpv20.csv

Datos del Censo de Población y Vivienda 2020 del INEGI.

Variables principales:

- Entidad federativa.
- Población total.
- Población afiliada a servicios de salud.
- Indicadores demográficos seleccionados.

Uso en el proyecto:

- Cálculo de indicadores per cápita.
- Comparación territorial.
- Análisis de cobertura y distribución de medicamentos.

---

## Integración de datos

Las tablas se relacionan mediante las siguientes claves:

| Tabla origen | Tabla destino | Campo de relación |
|-------------|--------------|------------------|
| remisiones | adjudicaciones | procedimiento |
| remisiones | cpv20 | entidad |

---

## Consideraciones

- Los datos provienen de fuentes públicas del Gobierno de México y del INEGI.
- Se realizaron procesos de limpieza, estandarización y validación antes del análisis.
- Los archivos contenidos en esta carpeta corresponden a los datos originales utilizados como insumo para el proyecto.
- Algunas transformaciones y filtros aplicados se documentan en el script `main.R`.
