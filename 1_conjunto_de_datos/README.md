# Conjunto de datos

Esta carpeta contiene las fuentes de datos utilizadas para analizar la adquisición y distribución de medicamentos en instituciones públicas de salud de México.

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
- Tipo de procedimiento
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
- Comparación de precios entre proveedores.

### cpv20.csv

Datos del Censo de Población y Vivienda 2020 del INEGI.

Variables principales:

- Entidad federativa.
- Población total.
- Población afiliada a servicios de salud.
- Indicadores demográficos.

Uso en el proyecto:

- Cálculo de indicadores per cápita.
- Comparación territorial.
- Análisis de cobertura y distribución de medicamentos.

## Integración de datos

Las tablas se relacionan mediante las siguientes claves:

| Tabla origen | Tabla destino | Campo de relación |
|-------------|--------------|------------------|
| remisiones | adjudicaciones | procedimiento |
| remisiones | cpv20 | entidad |

## Consideraciones

- Los datos provienen de fuentes públicas.
- Se realizaron procesos de limpieza, estandarización y validación antes del análisis.
- Los archivos contenidos en esta carpeta corresponden a los datos originales utilizados como insumo para el proyecto.
