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

## Cómo ejecutar
1. Crear la base de datos MySQL
2. Ejecutar el script `/db/schema.sql`
3. Configurar credenciales locales
4. Ejecutar `Main`
