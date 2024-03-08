# Consultas SQL Convertidas a Markdown

## Consultas Simples

### Listado de Alumnos Ordenados Alfabéticamente
```sql
SELECT id, nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1 ASC;
```

### Alumnos sin Número de Teléfono
```sql
SELECT id, nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno'
AND telefono IS NULL;
```

### Alumnos Nacidos en 1999
```sql
SELECT id, nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno'
AND fecha_nacimiento BETWEEN '1999-01-01' AND '1999-12-31';

```

### Profesores sin Número de Teléfono y NIF que Termina en 'K'
```sql
SELECT persona.id, nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'profesor'
AND telefono IS NULL
AND nif ILIKE '%k';
```

### Asignaturas del Primer Cuatrimestre del Tercer Curso de un Grado Específico
```sql
SELECT *
FROM asignatura
INNER JOIN grado ON grado.id = asignatura.id_grado
WHERE cuatrimestre = '1'
AND curso = '3'
AND grado.id = '7';

```
## Consultas Multitabla (Composición Interna)

### Alumnas Matriculadas en Grado de Ingeniería Informática (Plan 2015)
```sql
SELECT DISTINCT 
    persona.nombre || ' ' || persona.apellido1 || ' ' || persona.apellido2 AS "alumna",
    grado.nombre AS "nombre del grado"
FROM persona
INNER JOIN alumno_se_matricula_asignatura ON persona.id = alumno_se_matricula_asignatura.id_alumno
INNER JOIN asignatura ON asignatura.id = alumno_se_matricula_asignatura.id_asignatura
INNER JOIN grado ON grado.id = asignatura.id_grado
WHERE persona.tipo = 'alumno'
AND genero = 'M'
AND grado.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

```


### Asignaturas Ofertadas en Grado de Ingeniería Informática (Plan 2015)
```sql
SELECT DISTINCT asignatura.nombre, grado.nombre
FROM asignatura
INNER JOIN grado ON grado.id = asignatura.id_grado
WHERE grado.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

```


### Profesores y su Departamento
```sql
SELECT DISTINCT 
    persona.nombre || ' ' || persona.apellido1 || ' ' || persona.apellido2 AS "profesor", 
    departamento.nombre AS "departamento academico"
FROM persona
INNER JOIN profesor ON persona.id = profesor.id_profesor
INNER JOIN departamento ON departamento.id = profesor.id_departamento
ORDER BY departamento.nombre ASC;

```


### Asignaturas de un Alumno Específico
```sql
SELECT asignatura.nombre, curso_escolar.anio_inicio, curso_escolar.anio_fin
FROM asignatura
INNER JOIN alumno_se_matricula_asignatura ON asignatura.id = alumno_se_matricula_asignatura.id_asignatura
INNER JOIN persona ON persona.id = alumno_se_matricula_asignatura.id_alumno
INNER JOIN curso_escolar ON curso_escolar.id = alumno_se_matricula_asignatura.id_curso_escolar
WHERE persona.tipo = 'alumno'
AND persona.nif = '26902806M';

```

## Consultas Multitabla (Composición Externa)

### Profesores y Departamentos Asociados
```sql
SELECT DISTINCT 
    persona.nombre,
    departamento.nombre
FROM persona
RIGHT JOIN profesor ON persona.id = profesor.id_profesor
RIGHT JOIN departamento ON departamento.id = profesor.id_departamento
WHERE persona.tipo = 'profesor';

```



### Profesores Sin Departamento
```sql
SELECT 
    persona.apellido1 AS "Primer Apellido", 
    persona.apellido2 AS "Segundo Apellido", 
    persona.nombre AS "Nombre del Profesor",
    departamento.nombre
FROM persona
FULL JOIN profesor ON persona.id = profesor.id_profesor
FULL JOIN departamento ON departamento.id = profesor.id_departamento
WHERE departamento.nombre IS NULL
AND persona.tipo = 'profesor';

```


### Departamentos Sin Profesores
```sql
SELECT d.id, d.nombre
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
WHERE p.id IS NULL;

```


### Profesores Sin Asignaturas
```sql
SELECT DISTINCT 
    p1.nombre,
    p1.apellido1,
    p1.id,
    a.nombre AS "nombre asignatura"
FROM persona p1
LEFT JOIN profesor p2 ON p1.id = p2.id_profesor
LEFT JOIN asignatura a ON p2.id = a.id_profesor
WHERE a.nombre IS NULL
AND p1.tipo = 'profesor';

```


### Asignaturas Sin Profesor Asignado
```sql
SELECT DISTINCT *
FROM asignatura a
WHERE a.id_profesor IS NULL;

```


### Departamentos Sin Asignaturas Impartidas
```sql
SELECT d.nombre AS nombre_departamento, a.nombre AS nombre_asignatura
FROM departamento d
INNER JOIN profesor p ON d.id = p.id_departamento
INNER JOIN asignatura a ON p.id_profesor = a.id_profesor
WHERE NOT EXISTS (
    SELECT 1
    FROM curso_escolar ce
    LEFT JOIN alumno_se_matricula_asignatura ama ON ce.id = ama.id_curso_escolar
    WHERE ama.id_asignatura = a.id
)
GROUP BY d.nombre, a.nombre;

```

## Consultas Resumen


### Número Total de Alumnas
```sql
SELECT * FROM persona
WHERE persona.genero = 'M'
AND persona.tipo = 'alumno';

```


### Alumnos Nacidos en 2005
```sql
SELECT * FROM persona
WHERE persona.tipo = 'alumno'
AND EXTRACT(year FROM persona.fecha_nacimiento) = '2005';

```


### Número de Profesores por Departamento
```sql
SELECT 
    departamento.nombre,
    COUNT(profesor.id_profesor) AS "cantidad profesores"
FROM departamento
INNER JOIN profesor ON departamento.id = profesor.id_departamento
GROUP BY departamento.nombre
ORDER BY COUNT(profesor.id_profesor) DESC;

```

### Número de Profesores por Departamento (Incluyendo los sin Asociación)
```sql
SELECT 
    departamento.nombre,
    COUNT(profesor.id_profesor) AS "cantidad profesores"
FROM departamento
FULL JOIN profesor ON departamento.id = profesor.id_departamento
GROUP BY departamento.nombre
ORDER BY COUNT(profesor.id_profesor) DESC;

```


### Grados y Número de Asignaturas
```sql
SELECT grado.nombre, COUNT(asignatura.id)
FROM grado
FULL JOIN asignatura ON grado.id = asign

```


###
```sql
```
