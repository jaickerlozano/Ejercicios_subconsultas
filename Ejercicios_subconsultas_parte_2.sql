use academia;

/*
 Ejercicios de Subconsultas (parte II)
*/

-- 1. Usar una subconsulta en el FROM para devolver los cursos entre 1 y 5. Visualizar el
-- número de alumnos de cada uno de ellos
select * from cursos;
select cursos.nombre, count(alumnos.cod_curso) as num_alumnos
from (select * from cursos where cod_curso between 1 and 5) as Cursos inner join alumnos
on alumnos.cod_curso=cursos.cod_curso
group by cursos.nombre;

-- 2. Usar una subconsulta en el FROM para devolver los profesores y el número de
-- asignaturas que imparten. Luego visualiza solo los que tengan más de 3 asignaturas
select nombre, apellidos from profesores;
select * from (
select profesores.nombre, count(asignaturas.cod_asignatura) as num_asignaturas
from asignaturas inner join profesores
on asignaturas.cod_profesor=profesores.cod_profesor
group by profesores.nombre
) as profesor_asignaturas;

-- Solución visualizando solo los profesores que tienen mas de 3 asignaturas
select nombre, apellidos from profesores;
select * from (
select profesores.nombre, count(asignaturas.cod_asignatura) as num_asignaturas
from asignaturas inner join profesores
on asignaturas.cod_profesor=profesores.cod_profesor
group by profesores.nombre
) as profesor_asignaturas
where num_asignaturas > 3;

-- 3. Indicar el curso más caro
select * from cursos where precio = (select max(precio) from cursos);

-- 4. Indicar la asignatura o asignaturas que menos duración tienen
select * from asignaturas;
select * from asignaturas 
where duracion = (select min(duracion) from asignaturas);

-- 5. Indicar las que más y menos duración tienen
select * from asignaturas;
select * from asignaturas 
where duracion = (select min(duracion) from asignaturas) or duracion = (select max(duracion) from asignaturas);

-- 6. Alumnos de informática que tengan una nota mayor que la media de la asignatura).
-- Deberían salir todos los de más de 5.9 que es la nota media
-- Solución con un Inner Join con Where
select alumnos.nombre, notas_alumnos.nota, asignaturas.nombre
from alumnos, notas_alumnos, asignaturas
where alumnos.cod_alumno=notas_alumnos.cod_alumno and notas_alumnos.cod_asignatura=asignaturas.cod_asignatura 
and asignaturas.nombre='Informatica' and notas_alumnos.nota > (
select avg(notas_alumnos.nota) from notas_alumnos, asignaturas
where notas_alumnos.cod_asignatura = asignaturas.cod_asignatura and asignaturas.nombre = 'Informatica'
);
-- Solución con un Inner Join / Join
select alumnos.nombre, notas_alumnos.nota, asignaturas.nombre
from alumnos inner join notas_alumnos inner join asignaturas
on alumnos.cod_alumno=notas_alumnos.cod_alumno and notas_alumnos.cod_asignatura=asignaturas.cod_asignatura 
where asignaturas.nombre='Informatica' and notas_alumnos.nota > (
select avg(notas_alumnos.nota) from notas_alumnos, asignaturas
where notas_alumnos.cod_asignatura = asignaturas.cod_asignatura and asignaturas.nombre = 'Informatica'
);

-- 7. Utilizando una subconsulta (no un JOIN) visualiza los nombres de los alumnos que
-- están en el curso ‘CURSO1’
select cod_curso, nombre, apellidos from alumnos where cod_curso = (select cod_curso from cursos where nombre = 'CURSO1');

-- 8. Visualiza los cursos que cuestan más que CURSO9
select * from cursos where precio > (select precio from cursos where nombre = 'CURSO9');

-- 9. Nombre de los alumnos que estén en CURSO1 o CURSO2
select cod_curso, nombre from alumnos 
where cod_curso = (
select cod_curso from cursos where nombre = 'CURSO1') or cod_curso = (select cod_curso from cursos where nombre = 'CURSO2');
-- Una solución más optimizada sería
select cod_curso, nombre from alumnos 
where cod_curso in (select cod_curso from cursos where nombre in ('CURSO1','CURSO2'));

-- 10. Alumnos que están cursando informática, matemáticas o dibujo
select nombre from alumnos
where cod_curso in (select cod_curso from asignaturas where nombre in ('informática','matemáticas','dibujo'));

-- 11. Nombre y precio de los cursos que valgan más que CURSO6 O CURSO7
select nombre, precio from cursos where precio > any (select precio from cursos where nombre in ('CURSO6','CURSO7'));

-- 12. Nombre y precio de los cursos que valgan más que CURSO6 Y CURSO7
select nombre, precio from cursos where precio > all (select precio from cursos where nombre in ('CURSO6','CURSO7'));

-- 13. Averiguar si existe algún curso que tenga más de un 6 de nota media. Solo debería salir CURSO3
select nombre from cursos where cod_curso = (select cod_curso from notas_alumnos group by cod_curso having avg(nota) > 6);

-- Otra solución se puede hallar utilizando el operador EXISTS
select nombre from cursos where 
	exists (select cod_curso from notas_alumnos where cod_curso = CURSOS.COD_CURSO
    group by cod_curso
    having avg(nota)>6);

-- 14. Cursos que tengan más asignaturas que CURSO9
select cursos.nombre, count(asignaturas.nombre) as num_asignaturas 
from asignaturas inner join cursos
on asignaturas.cod_curso = cursos.cod_curso
group by asignaturas.cod_curso 
having num_asignaturas > (select count(nombre) from asignaturas where cod_curso = (select cod_curso from cursos where nombre = 'CURSO9') group by cod_curso);

-- Una solución más corta puede ser
select cursos.nombre, count(*) from asignaturas inner join cursos on asignatuRas.cod_curso = cursos.cod_curso
group by asignaturas.cod_curso
having count(*) > (select count(*) from asignaturas inner join cursos on asignaturas.cod_curso=cursos.cod_curso where cursos.nombre = 'CURSO9');

-- 15. Alumnos con nota media mayor que la del alumno llamado Gayle
select nombre, avg(nota) from alumnos inner join notas_alumnos on notas_alumnos.cod_alumno=alumnos.cod_alumno
group by nombre
having avg(nota) > (select avg(nota) from notas_alumnos inner join alumnos on notas_alumnos.cod_alumno=alumnos.cod_alumno where alumnos.nombre = 'Gayle');

-- 16. Visualiza el nombre del departamento o departamentos que tienen más alumnos
-- Con esta query obtengo el número máximo de alumnos de todos los departamentos
select max(alumnos) from (select count(*) as alumnos 
from alumnos, cursos
where alumnos.cod_curso=cursos.cod_curso 
group by cursos.cod_curso) as alumnos;

-- Solución
select cursos.nombre, count(*) as alumnos 
from alumnos, cursos 
where alumnos.cod_curso=cursos.cod_curso 
group by cursos.nombre
having alumnos = (select max(alumnos) from (select count(*) as alumnos 
	from alumnos, cursos
	where alumnos.cod_curso=cursos.cod_curso 
	group by cursos.cod_curso) as alumnos);
    
-- Solución más corta
select cursos.nombre, count(*) as alumnos 
from alumnos, cursos 
where alumnos.cod_curso=cursos.cod_curso 
group by cursos.nombre
having alumnos = (select count(*) from alumnos group by cod_curso order by count(*) desc limit 1);

-- 17. Mostrar el curso o los cursos que tengan más alumnos matriculados en matemáticas
select cursos.nombre, count(*) from alumnos inner join asignaturas inner join cursos
on asignaturas.cod_curso=alumnos.cod_curso and cursos.cod_curso=asignaturas.cod_curso
where asignaturas.nombre = 'Matematicas'
group by cursos.nombre
having count(*) = (

select max(num_max) from (
	select cursos.nombre, count(*) as num_max from alumnos inner join asignaturas inner join cursos
	on asignaturas.cod_curso=alumnos.cod_curso and cursos.cod_curso=asignaturas.cod_curso
	where asignaturas.nombre = 'Matematicas'
	group by cursos.nombre) as tabla
);

