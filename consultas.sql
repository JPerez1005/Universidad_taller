-- Active: 1709872275066@@127.0.0.1@3307@universidad_postgrest
--Devuelve un listado con el primer apellido, segundo apellido y el nombre de todos los alumnos.
--El listado deberá estar ordenado alfabéticamente de menor a mayor por el primer apellido,
--segundo apellido y nombre.

select id,nombre,apellido1,apellido2 from persona
where tipo='alumno' ORDER BY apellido1 ASC;

--Averigua el nombre y los dos apellidos de los alumnos que no han
--dado de alta su número de teléfono en la base de datos.

select id,nombre,apellido1,apellido2 from persona
WHERE tipo='alumno'
AND telefono is NULL;

--Devuelve el listado de los alumnos que nacieron en 1999.
select id,nombre,apellido1,apellido2 from persona
WHERE tipo='alumno'
AND fecha_nacimiento BETWEEN '1999-01-01' AND '1999-12-31';

--Devuelve el listado de profesores que no han dado de alta su número de teléfono en la base de datos y
--además su nif termina en K.
select persona.id,nombre,apellido1,apellido2 from persona
WHERE tipo='profesor'
AND telefono is NULL
AND nif ILIKE '%k';

--Devuelve el listado de las asignaturas que se imparten en el primer cuatrimestre,
--en el tercer curso del grado que tiene el identificador 7.
select * from asignatura
INNER JOIN grado on grado.id=asignatura.id_grado
WHERE cuatrimestre='1'
AND curso='3'
AND grado.id='7';


--4. Consultas multitabla (Composición interna)

--Devuelve un listado con los datos de todas las alumnas que se han matriculado alguna
--vez en el Grado en Ingeniería Informática (Plan 2015).

SELECT DISTINCT 
persona.nombre || ' ' || persona.apellido1 || ' ' || persona.apellido2 as "alumna",
grado.nombre as "nombre del grado"
from persona
INNER JOIN alumno_se_matricula_asignatura on persona.id=alumno_se_matricula_asignatura.id_alumno
INNER JOIN asignatura on asignatura.id=alumno_se_matricula_asignatura.id_asignatura
INNER JOIN grado on grado.id=asignatura.id_grado
WHERE persona.tipo='alumno'
AND genero='M'
AND grado.nombre='Grado en Ingeniería Informática (Plan 2015)';


--Devuelve un listado con todas las asignaturas ofertadas en el 
--Grado en Ingeniería Informática (Plan 2015).

SELECT DISTINCT asignatura.nombre,grado.nombre from asignatura
INNER JOIN grado on grado.id=asignatura.id_grado
WHERE grado.nombre='Grado en Ingeniería Informática (Plan 2015)';

--Devuelve un listado de los profesores junto con el nombre del departamento al
--que están vinculados. El listado debe devolver cuatro columnas, primer apellido,
--segundo apellido, nombre y nombre del departamento. El resultado estará ordenado
--alfabéticamente de menor a mayor por los apellidos y el nombre.

select DISTINCT persona.nombre || ' ' || persona.apellido1 || ' ' || persona.apellido2 as "profesor", 
departamento.nombre as "departamento academico"
from persona
inner join profesor on persona.id=profesor.id_profesor
inner join departamento on departamento.id=profesor.id_departamento
ORDER BY departamento.nombre asc;--no se puede ordenar por nombre por la concatenación creo


--4. Devuelve un listado con el nombre de las asignaturas, año de inicio y año de fin del curso
--escolar del alumno con nif `26902806M`.

select asignatura.nombre,curso_escolar.anio_inicio,curso_escolar.anio_fin from asignatura
INNER join alumno_se_matricula_asignatura on asignatura.id=alumno_se_matricula_asignatura.id_asignatura
inner join persona on persona.id=alumno_se_matricula_asignatura.id_alumno
INNER JOIN curso_escolar on curso_escolar.id=alumno_se_matricula_asignatura.id_curso_escolar
where persona.tipo='alumno'
and persona.nif='26902806M';


--5. Devuelve un listado con el nombre de todos los departamentos que tienen profesores que
--imparten alguna asignatura en el `Grado en Ingeniería Informática (Plan 2015)`.
select departamento.nombre,asignatura.nombre,grado.nombre from departamento
INNER JOIN profesor on departamento.id=profesor.id_departamento
inner join persona on persona.id=profesor.id_profesor
inner join asignatura on profesor.id=asignatura.id_profesor
inner join grado on grado.id=asignatura.id_grado
WHERE grado.nombre='Grado en Ingeniería Informática (Plan 2015)';

--6. Devuelve un listado con todos los alumnos que se han matriculado en alguna asignatura
--durante el curso escolar 2018/2019.

select DISTINCT persona.nombre || ' ' || persona.apellido1 || ' ' || persona.apellido2 as "alumno",
curso_escolar.anio_inicio,curso_escolar.anio_fin
from persona
inner join alumno_se_matricula_asignatura on persona.id=alumno_se_matricula_asignatura.id_alumno
inner join asignatura on asignatura.id=alumno_se_matricula_asignatura.id_asignatura
inner join curso_escolar on curso_escolar.id=alumno_se_matricula_asignatura.id_curso_escolar
WHERE persona.tipo='alumno'
and curso_escolar.anio_inicio BETWEEN 2018 and 2019;

--*5. Consultas multitabla (Composición externa)

--1.)Devuelve un listado con los nombres de todos los profesores y
--los departamentos que tienen vinculados. El listado también
--debe mostrar aquellos profesores que no tienen ningún departamento asociado.
--El listado debe devolver cuatro columnas, nombre del departamento, primer
--apellido, segundo apellido y nombre del profesor. El resultado estará ordenado
--alfabéticamente de menor a mayor por el nombre del departamento, apellidos y el nombre.

select DISTINCT persona.nombre,departamento.nombre
from persona
RIGHT join profesor on persona.id=profesor.id_profesor
RIGHT join departamento on departamento.id=profesor.id_departamento
where persona.tipo='profesor'
;

SELECT departamento.nombre AS "Nombre del Departamento", 
       persona.apellido1 AS "Primer Apellido", 
       persona.apellido2 AS "Segundo Apellido", 
       persona.nombre AS "Nombre del Profesor"
FROM persona
LEFT JOIN profesor ON persona.id = profesor.id_profesor
LEFT JOIN departamento ON profesor.id_departamento = departamento.id
ORDER BY "Nombre del Departamento", "Primer Apellido", "Segundo Apellido", "Nombre del Profesor";

--2.)Listado de profesores sin departamento:

SELECT persona.apellido1 AS "Primer Apellido", 
       persona.apellido2 AS "Segundo Apellido", 
       persona.nombre AS "Nombre del Profesor",
       departamento.nombre
FROM persona
full JOIN profesor ON persona.id = profesor.id_profesor
full join departamento on departamento.id=profesor.id_departamento
WHERE departamento.nombre is null
and persona.tipo='profesor';

--3.) Devuelve un listado con los departamentos que no
--tienen profesores asociados.

SELECT d.id, d.nombre, p.id_profesor
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
WHERE p.id IS NULL;


--4.) Devuelve un listado con los profesores que no
--imparten ninguna asignatura.

select DISTINCT p1.nombre,p1.apellido1,p1.id,
a.nombre as "nombre asignatura"
from persona p1
left join profesor p2 on p1.id=p2.id_profesor
left join asignatura a on p2.id=a.id_profesor
where a.nombre is null
and p1.tipo='profesor';


--5.) Devuelve un listado con las asignaturas que no
--tienen un profesor asignado.

SELECT DISTINCT *
FROM asignatura a
WHERE a.id_profesor IS NULL;


--6.) Devuelve un listado con todos los departamentos
--que tienen alguna asignatura que no se haya impartido
--en ningún curso escolar. El resultado debe mostrar el
--nombre del departamento y el nombre de la asignatura
--que no se haya impartido nunca.

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



--( 6 )CONSULTAS RESUMEN
--6.1) Devuelve el número total de alumnas que hay.

select * from  persona
where persona.genero='M'
and persona.tipo='alumno';

--6.2) Calcula cuántos alumnos nacieron en 2005.

select * from persona
where persona.tipo='alumno'
and extract(year from persona.fecha_nacimiento)='2005';

--6.3) Calcula cuántos profesores hay en cada departamento.
--El resultado sólo debe mostrar dos columnas, una con el nombre
--del departamento y otra con el número de profesores que hay
--en ese departamento. El resultado sólo debe incluir los departamentos
--que tienen profesores asociados y deberá estar ordenado de mayor
--a menor por el número de profesores.

select departamento.nombre,
count(profesor.id_profesor) as "cantidad profesores"
from departamento
inner join profesor on departamento.id=profesor.id_departamento
group by departamento.nombre
order by count(profesor.id_profesor) desc;

--6.4) Devuelve un listado con todos los departamentos y el número de
--profesores que hay en cada uno de ellos. Tenga en cuenta que pueden
--existir departamentos que no tienen profesores asociados. Estos
--departamentos también tienen que aparecer en el listado.

select departamento.nombre,
count(profesor.id_profesor) as "cantidad profesores"
from departamento
full join profesor on departamento.id=profesor.id_departamento
group by departamento.nombre
order by count(profesor.id_profesor) desc;


--6.5) Devuelve un listado con el nombre de todos los grados existentes en la
--base de datos y el número de asignaturas que tiene cada uno.
--Tenga en cuenta que pueden existir grados que no tienen
--asignaturas asociadas. Estos grados también tienen que aparecer en el
--listado. El resultado deberá estar ordenado de mayor a menor
--por el número de asignaturas.

select grado.nombre,count(asignatura.id)
from grado
full join asignatura on grado.id=asignatura.id_grado
group by grado.nombre
order by count(asignatura.id) desc;

--6.6) Devuelve un listado con el nombre de todos los grados existentes en la
--base de datos y el número de asignaturas que tiene cada uno, 
--de los grados que tengan más de 40 asignaturas asociadas.

select grado.nombre,count(asignatura.id)
from grado
inner join asignatura on grado.id=asignatura.id_grado
group by grado.nombre
having count(asignatura.id)>40
order by count(asignatura.id) desc;

--6.7) Devuelve un listado que muestre el nombre de los grados y
--la suma del número total de créditos que hay para cada tipo de asignatura.
--El resultado debe tener tres columnas: nombre del grado, tipo de asignatura
--y la suma de los créditos de todas las asignaturas que hay de ese tipo.
--Ordene el resultado de mayor a menor por el número total de crédidos.

select grado.nombre,asignatura.tipo,sum(asignatura.creditos)
from grado
full join asignatura on grado.id=asignatura.id_grado
group by grado.nombre,asignatura.tipo
order by count(asignatura.creditos) desc;


--6.8) Devuelve un listado que muestre cuántos alumnos se han
--matriculado de alguna asignatura en cada uno de los cursos escolares.
--El resultado deberá mostrar dos columnas, una columna con el año de
--inicio del curso escolar y otra con el número de alumnos matriculados.

select DISTINCT curso_escolar.anio_inicio,count(asma.id_alumno)
from curso_escolar
inner join alumno_se_matricula_asignatura asma on curso_escolar.id=asma.id_curso_escolar
group by curso_escolar.anio_inicio;


--6.9) Devuelve un listado con el número de asignaturas que imparte
--cada profesor. El listado debe tener en cuenta aquellos profesores
--que no imparten ninguna asignatura. El resultado mostrará cinco
--columnas: id, nombre, primer apellido, segundo apellido y número
--de asignaturas. El resultado estará ordenado de mayor a menor por
--el número de asignaturas.

select DISTINCT p1.id,p1.nombre as "profesor",p1.apellido1,p1.apellido2,
count(a.id) as "numero asignaturas"
from persona p1
full join profesor p2 on p1.id=p2.id_profesor
full join asignatura a on p2.id_profesor=a.id_profesor
where p1.tipo='profesor'
group by p1.id,p1.nombre,p1.apellido1,p1.apellido2
order by count(a.id) desc;

--( 7 )SUBCONSULTAS

--7.1) Devuelve todos los datos del alumno más joven.

select persona.*
from persona
where persona.tipo='alumno'
and extract(year from persona.fecha_nacimiento)=(
    select max(extract(year from persona.fecha_nacimiento)) 
    from persona);
;

--7.2) Devuelve un listado con los profesores que no están
--asociados a un departamento.

select DISTINCT persona.nombre,departamento.nombre from persona
full join profesor on persona.id=profesor.id_profesor
full join departamento on departamento.id=profesor.id_departamento
where persona.tipo='profesor'
and departamento.nombre is null;

--7.3) Devuelve un listado con los departamentos que no tienen
--profesores asociados.

select DISTINCT * from persona
full join profesor on persona.id=profesor.id_profesor
full join departamento on departamento.id=profesor.id_departamento
where persona.tipo='profesor'
and profesor.id is null;

SELECT d.id, d.nombre
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
WHERE p.id IS NULL;


--7.4) Devuelve un listado con los profesores que tienen un
--departamento asociado y que no imparten ninguna asignatura.

SELECT p.*
FROM profesor p
LEFT JOIN asignatura a ON p.id_profesor = a.id_profesor
WHERE a.id_profesor IS NULL
AND p.id_departamento IS NOT NULL;


--7.5) Devuelve un listado con las asignaturas que no tienen un
--profesor asignado.

SELECT distinct *
FROM asignatura
WHERE id_profesor IS NULL;

--7.6) Devuelve un listado con todos los departamentos que no han
--impartido asignaturas en ningún curso escolar.

select DISTINCT departamento.nombre
from departamento
full join profesor on departamento.id=profesor.id_departamento
full join persona on persona.id=profesor.id_profesor
full join alumno_se_matricula_asignatura asma on persona.id=asma.id_alumno
full join curso_escolar on curso_escolar.id=asma.id_curso_escolar
full join asignatura on asignatura.id=asma.id_asignatura
full join grado on grado.id=asignatura.id_grado
where asignatura.id is null
and curso_escolar.id is null;