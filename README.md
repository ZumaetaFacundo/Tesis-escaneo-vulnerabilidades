# Plataforma de Escaneo de Vulnerabilidades

## Autores
- Facundo Zumaeta
- Marcos Vega
- Luciano Molaro

## Descripción
Plataforma automatizada para el escaneo, priorización y reporte de vulnerabilidades
en entornos controlados. Integra descubrimiento de activos, escaneo no autenticado
y análisis basado en riesgo.

## Tecnologías
- Java 17
- Maven
- MySQL
- Nmap (ejecución externa)
- Git / GitHub

## Arquitectura
- Aplicación Java (consola)
- Base de datos MySQL
- Escáneres externos (Nmap)

## Implementación en n8n (dividido por etapas)
Basado en la base actual (Java + MySQL + Nmap), la implementación en n8n se puede
dividir en flujos independientes para que cada parte del pipeline sea orquestable
y trazable. A continuación se indica qué hace cada uno y cómo se integra con lo existente.

### Flujo 1: Descubrimiento de activos
**Objetivo:** Detectar hosts/servicios y registrar activos.
- **Nodos sugeridos:** Cron Trigger → Execute Command (Nmap discovery) → Function
  (parseo) → MySQL (insert/update activos).
- **Integración con base actual:** Guarda resultados en la misma base MySQL usada
  por la app Java.
- **Salida:** Tabla de activos actualizada para alimentar escaneos posteriores.

### Flujo 2: Escaneo no autenticado
**Objetivo:** Escanear activos detectados sin credenciales.
- **Nodos sugeridos:** MySQL (select activos) → Split in Batches →
  Execute Command (Nmap -sV/-sC) → Function (normalización) →
  MySQL (insert hallazgos).
- **Integración con base actual:** Reutiliza la DB para almacenar hallazgos
  y metadatos del escaneo.

### Flujo 3: Escaneo autenticado (activos críticos)
**Objetivo:** Ejecutar escaneos con credenciales seguras según criticidad.
- **Nodos sugeridos:** MySQL (select activos críticos) → Vault/Secrets →
  Execute Command (scanner autenticado) → Function →
  MySQL (insert hallazgos).
- **Integración con base actual:** Usa la misma DB y añade campos de trazabilidad
  (usuario, fecha, tipo de escaneo).

### Flujo 4: Enriquecimiento y priorización
**Objetivo:** Enriquecer hallazgos con CVE/NVD/EPSS y calcular el riesgo.
- **Nodos sugeridos:** MySQL (select hallazgos) → HTTP Request (NVD/EPSS) →
  Function (cálculo risk score) → MySQL (update priorización).
- **Integración con base actual:** Actualiza la tabla de hallazgos con score y
  criticidad.

### Flujo 5: Notificación / ticketing
**Objetivo:** Generar tickets o alertas cuando se superen umbrales.
- **Nodos sugeridos:** MySQL (select hallazgos críticos) →
  If (umbral) → Jira/Slack/Email → MySQL (update estado).
- **Integración con base actual:** Marca hallazgos como “notificados” para auditoría.

### Flujo 6: Auditoría y métricas
**Objetivo:** Registrar evidencia y calcular métricas (cobertura, TTR, falsos positivos).
- **Nodos sugeridos:** MySQL (queries agregadas) → Function (métricas) →
  Spreadsheet/CSV/Notion/Email.
- **Integración con base actual:** Produce reportes basados en los mismos datos
  del pipeline.

### Flujo 7: Feedback y mejora continua
**Objetivo:** Re-entrenar reglas de priorización con el feedback del analista.
- **Nodos sugeridos:** MySQL (feedback) → Function (ajuste de pesos) →
  MySQL (update reglas).
- **Integración con base actual:** Ajusta la lógica de scoring sin romper la estructura existente.

## Qué queda por hacer (resumen por componente)
1. **Base de datos:** definir tablas para activos, hallazgos, priorización,
   tickets y auditoría (puede ampliar `/db/schema.sql`).
2. **App Java:** reutilizar la conexión actual para consultas y validaciones
   internas si se decide mantenerla como consola de apoyo.
3. **n8n:** construir los 7 flujos anteriores usando MySQL, Execute Command y
   HTTP Request como nodos base.

## Cómo ejecutar
1. Crear la base de datos MySQL
2. Ejecutar el script `/db/schema.sql`
3. Configurar credenciales locales
4. Ejecutar `Main`
