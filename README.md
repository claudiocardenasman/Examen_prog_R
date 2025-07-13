# Exámen de programación en R
### Elaboración de la  función “imputar_completo_con_outliers” para imputación de datos, detección y tratamiento de Outliers (Clase S3), de manera automatizada, en Dataframe de Salud Pública, del Servicio de Salud Chiloé.

## Introducción.
En el contexto de la gestión de salud pública y la administración hospitalaria, la disponibilidad de datos completos y de calidad constituye un pilar fundamental para la formulación de políticas sanitarias, la evaluación de indicadores de desempeño y la toma de decisiones clínicas y administrativas. Sin embargo, las bases de datos provenientes de Atención Primaria, Atención Hospitalaria y redes asistenciales suelen adolecer de registros incompletos y de valores atípicos (“outliers”) que, si no son identificados y tratados adecuadamente, pueden inducir sesgos en los análisis epidemiológicos, distorsionar estimaciones de prevalencia y comprometer la eficacia de intervenciones en pabellones quirúrgicos, listas de espera y programas de control de enfermedades crónicas.
Frente a esta necesidad, la imputación de datos faltantes y la detección sistemática de outliers se presentan como estrategias complementarias imprescindibles. Mientras la imputación múltiple permite restituir
la información ausente a partir de patrones de correlación entre variables, la identificación de valores extremos salvaguarda la integridad de los resultados al excluir o corregir observaciones potencialmente erróneas.
Este trabajo propone el desarrollo y la validación de un protocolo automatizado en R, diseñado bajo el paradigma de programación orientada a objetos mediante una clase S3, que integra de manera integral la
imputación de datos faltantes y la detección de outliers en bases de datos sanitarias. El protocolo está orientado a su aplicación en la gestión de pabellones quirúrgicos, la administración de listas de espera de
consultas de especialidad e intervenciones quirúrgicas, y en el seguimiento de pacientes con enfermedades crónicas y atención de urgencias.
Mediante casos de prueba basados en conjuntos de datos reales y simulados, se evaluará la capacidad del protocolo para restaurar la completitud de la información, preservar la estructura poblacional original y
facilitar la trazabilidad de los métodos empleados. Se espera que esta herramienta contribuya a robustecer el análisis epidemiológico, a optimizar la calidad de la información y a fortalecer la toma de decisiones en la gestión hospitalaria y en la planificación de servicios asistenciales.

## Objetivo general del estudio.
Desarrollar y validar un protocolo automatizado en R, implementado como clase S3, para la imputación integral de datos faltantes y la detección sistemática de outliers en bases de datos sanitarias de atención
primaria, hospitalaria y redes asistenciales, con el fin de mejorar la calidad de la información, robustecer el análisis epidemiológico y optimizar la toma de decisiones en la gestión hospitalaria (incluyendo pabellones quirúrgicos y listas de espera), así como en programas de control de enfermedades crónicas y la atención de urgencias en los distintos niveles de la red de salud.
