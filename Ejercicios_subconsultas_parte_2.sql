use academia;

/*
 Ejercicios de Subconsultas (parte II)
 4. Indicar la asignatura o asignaturas que menos duración tienen
 5. Indicar las que más y menos duración tienen
 6. Alumnos de informática que tengan una nota mayor que la media de la asignatura).
 Deberían salir todos los de más de 5.9 que es la nota media
 7. Utilizando una subconsulta (no un JOIN) visualiza los nombres de los alumnos que
 están en el curso ‘CURSO1’
 8. Visualiza los cursos que cuestan más que CURSO9
 9. Nombre de los alumnos que estén en CURSO1 o CURSO2
 10. Alumnos que están cursando informática, matemáticas o dibujo
 11. Nombre y precio de los cursos que valgan más que CURSO6 O CURSO7
 12. Nombre y precio de los cursos que valgan más que CURSO6 Y CURSO7
 13. Averiguar si existe algún curso que tenga más de un 6 de nota media. Solo debería
 salir CURSO3
 14. Cursos que tengan más asignaturas que CURSO9
 15. Alumnos con nota media mayor que la del alumno llamado Gayle
 16. Visualiza el nombre del departamento o departamentos que tienen más alumnos
 17. Mostrar el curso o los cursos que tengan más alumnos matriculados en matemáticas
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
