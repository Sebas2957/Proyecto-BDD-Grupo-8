   -- Entrega S16 · Parte A — Grupo 8
   -- Los cuatro reportes del proyecto sobre el esquema "biblioteca".

   SET search_path TO biblioteca;

-----------------
--libros mas prestados
 SELECT l.nombre_libro AS titulo,
       count(p.prestamo_id) AS total_prestamos
FROM   libro l
LEFT JOIN ejemplar  e ON e.libro_id    = l.libro_id
LEFT JOIN prestamos p ON p.ejemplar_id = e.ejemplar_id
GROUP BY l.libro_id, l.nombre_libro
ORDER BY total_prestamos DESC
FETCH FIRST 3 ROWS WITH TIES;
-----------------------
--usuario que mas  lee
WITH leidos AS (
    SELECT usuario_id, count(*) AS devueltos
    FROM   prestamos
    WHERE  fecha_fin IS NOT NULL
    GROUP BY usuario_id)

SELECT u.nombre, u.correo, x.devueltos
FROM   leidos x
JOIN   usuario u ON u.usuario_id = x.usuario_id
WHERE  x.devueltos = (SELECT max(devueltos) FROM leidos)
ORDER BY u.nombre;
---------------------
--lectores en mora
SELECT u.usuario_id, u.nombre, u.correo
FROM usuario u
WHERE EXISTS (SELECT 1
			  FROM prestamos p
			  WHERE p.usuario_id = u.usuario_id
			  AND p.fecha_fin IS NULL
			  AND p.fecha_inicio + 14 < CURRENT_DATE
			  )
ORDER BY u.nombre;
--------------------
--prestamos en mora
WITH abiertos AS (
    SELECT prestamo_id, usuario_id, ejemplar_id,
           fecha_inicio + 14 AS fecha_esperada
    FROM   prestamos p
    WHERE  fecha_fin IS NULL
)
SELECT u.nombre, u.correo, u.telefono,
       l.nombre_libro AS titulo,
       a.fecha_esperada,
       CURRENT_DATE - a.fecha_esperada AS dias_mora
FROM   abiertos a
JOIN   usuario  u ON u.usuario_id  = a.usuario_id
JOIN   ejemplar e ON e.ejemplar_id = a.ejemplar_id
JOIN   libro    l ON l.libro_id    = e.libro_id
WHERE  a.fecha_esperada < CURRENT_DATE
ORDER BY dias_mora DESC;