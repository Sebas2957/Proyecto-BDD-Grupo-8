SET search_path TO tienda;

SELECT c.nombre AS cliente, p.nombre AS producto, d.cantidad, (d.cantidad * d.precio_unitario) AS subtotal
FROM pedido ped
JOIN cliente c ON ped.id_cliente = c.id_cliente
JOIN detalle d ON ped.id_pedido = d.id_pedido
JOIN producto p ON d.id_producto = p.id_producto
WHERE ped.id_pedido = 1003;

SELECT c.nombre AS cliente, ref.nombre AS referido_por
FROM cliente c
LEFT JOIN cliente ref ON c.referido_por = ref.id_cliente;

SELECT * 
FROM producto
WHERE id_producto NOT IN (SELECT id_producto FROM detalle);

SELECT c.nombre, COUNT(ped.id_pedido) AS total_pedidos
FROM cliente c
LEFT JOIN pedido ped ON c.id_cliente = ped.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY total_pedidos DESC;

SELECT p.categoria, SUM(d.cantidad * d.precio_unitario) AS total_vendido
FROM detalle d
JOIN pedido ped ON d.id_pedido = ped.id_pedido
JOIN producto p ON d.id_producto = p.id_producto
WHERE ped.estado != 'cancelado'
GROUP BY p.categoria
ORDER BY total_vendido DESC;

SELECT EXTRACT(month FROM ped.fecha) AS mes, SUM(d.cantidad * d.precio_unitario) AS total_mes
FROM pedido ped
JOIN detalle d ON ped.id_pedido = d.id_pedido
WHERE ped.estado != 'cancelado' 
  AND EXTRACT(year FROM ped.fecha) = 2026
GROUP BY mes
HAVING SUM(d.cantidad * d.precio_unitario) > 200000;

SELECT p1.nombre, p1.categoria, p1.precio
FROM producto p1
WHERE p1.precio > (
    SELECT AVG(p2.precio)
    FROM producto p2
    WHERE p2.categoria = p1.categoria
);

SELECT DISTINCT c.nombre
FROM cliente c
JOIN pedido ped ON c.id_cliente = ped.id_cliente
JOIN detalle d ON ped.id_pedido = d.id_pedido
JOIN producto p ON d.id_producto = p.id_producto
WHERE c.ciudad = 'Cali' 
  AND p.categoria = 'Accesorio' 
  AND ped.estado != 'cancelado';

SELECT nombre 
FROM cliente c1
WHERE NOT EXISTS (
    SELECT 1 FROM cliente c2 WHERE c2.referido_por = c1.id_cliente
);

WITH gastado AS (
    SELECT c.id_cliente, c.nombre, SUM(d.cantidad * d.precio_unitario) AS total_gastado
    FROM cliente c
    JOIN pedido ped ON c.id_cliente = ped.id_cliente
    JOIN detalle d ON ped.id_pedido = d.id_pedido
    WHERE ped.estado != 'cancelado'
    GROUP BY c.id_cliente, c.nombre
)
SELECT nombre, total_gastado
FROM gastado
WHERE total_gastado = (SELECT MAX(total_gastado) FROM gastado);

SELECT c.nombre
FROM cliente c
WHERE NOT EXISTS (
    SELECT p.id_producto FROM producto p WHERE p.categoria = 'Grano'
    EXCEPT
    SELECT d.id_producto 
    FROM pedido ped 
    JOIN detalle d ON ped.id_pedido = d.id_pedido
    WHERE ped.id_cliente = c.id_cliente AND ped.estado != 'cancelado'
);