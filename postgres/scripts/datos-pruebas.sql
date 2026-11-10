
SET search_path TO biblioteca;

INSERT INTO libro (isbn, nombre_libro, autor, genero) VALUES
    ('9780000000001', 'Cien años de soledad',            'Gabriel García Márquez', 'Novela'),
    ('9780000000003', 'Crónica de una muerte anunciada', 'Gabriel García Márquez', 'Novela'),
    ('9780000000004', 'Rayuela',                         'Julio Cortázar',         'Novela'),
    ('9780000000005', 'Pedro Páramo',                    'Juan Rulfo',             'Novela'),
    ('9780000000007', 'Ficciones',                       'Jorge Luis Borges',      'Cuento'),
    ('9780000000008', 'El Aleph',                        'Jorge Luis Borges',      'Cuento') -- Libro que nadie ha prestado
ON CONFLICT (isbn) DO NOTHING;

INSERT INTO ejemplar (libro_id, estado, cantidad, estanteria) 
SELECT libro_id, 'disponible', '5', 'A1'
FROM libro
ON CONFLICT DO NOTHING;

INSERT INTO "usuario" (nombre, correo, telefono, direccion, contrasena, rol) VALUES
    ('Mariana Gómez',      'mariana.gomez@correo.co',      '3151400001', 'Calle 1', 'contraseña', 1),
    ('Santiago Rodríguez', 'santiago.rodriguez@correo.co', '3151000002', 'Calle 2', 'contraseña', 1),
    ('Valentina López',     'valentina.lopez@correo.co',    '3152000003', 'Calle 3', 'contraseña', 1),
    ('Juan David',      'juan.martinez@correo.co',      '3151000088', 'Calle 4', 'contraseña', 1),
    ('Camila Hernández',  'camila.hernandez@correo.co',   '3157002005', 'Calle 5', 'contraseña', 1)
ON CONFLICT (correo) DO NOTHING;

INSERT INTO "prestamos" (prestamo_id, usuario_id, ejemplar_id, fecha_inicio, fecha_fin, estado) 
VALUES

    (1, 1, 1, CURRENT_DATE - 120, CURRENT_DATE - 110, 'devuelto'),
    (2, 1, 2, CURRENT_DATE - 100, CURRENT_DATE - 90,  'devuelto'),
    (3, 2, 1, CURRENT_DATE - 95,  CURRENT_DATE - 85,  'devuelto'),
    (4, 2, 3, CURRENT_DATE - 75,  CURRENT_DATE - 50,  'devuelto'),
    (5, 3, 1, CURRENT_DATE - 70,  CURRENT_DATE - 60,  'devuelto'),
    (6, 3, 4, CURRENT_DATE - 30,  NULL,               'activo'), -- en mora (más de 14 días)
    (7, 4, 1, CURRENT_DATE - 20,  NULL,               'activo'),
    (8, 4, 3, CURRENT_DATE - 40,  NULL,               'vencido'),

    (9, 5, 3, CURRENT_DATE - 50,  CURRENT_DATE - 45,  'devuelto'),
    (10, 5, 5, CURRENT_DATE - 16, NULL,               'activo')
ON CONFLICT (prestamo_id) DO NOTHING;