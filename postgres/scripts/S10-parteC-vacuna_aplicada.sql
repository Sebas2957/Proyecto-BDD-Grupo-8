SET search_path TO veterinaria;

DROP TABLE IF EXISTS vacuna_aplicada;

CREATE TABLE vacuna_aplicada (
    id_mascota        integer      NOT NULL REFERENCES mascota (id_mascota),
    nombre_vacuna     varchar(60)  NOT NULL,
    fecha_aplicacion  date         NOT NULL,
    lote              varchar(20)  NOT NULL,
    tarjeta_vet       varchar(10)  NOT NULL REFERENCES veterinario (tarjeta_profesional),
    fecha_proxima     date,
    PRIMARY KEY (id_mascota, nombre_vacuna, fecha_aplicacion),
    CHECK (fecha_proxima > fecha_aplicacion)
);

INSERT INTO vacuna_aplicada (id_mascota, nombre_vacuna, fecha_aplicacion, lote, tarjeta_vet, fecha_proxima)
VALUES (1, 'Rabia', '2026-10-05', 'L-2026-0457', 'TP-1001', '2027-10-05');

INSERT INTO vacuna_aplicada (id_mascota, nombre_vacuna, fecha_aplicacion, lote, tarjeta_vet, fecha_proxima)
VALUES (1, 'Rabia', '2026-10-05', 'L-2026-0999', 'TP-1002', NULL);

INSERT INTO vacuna_aplicada (id_mascota, nombre_vacuna, fecha_aplicacion, lote, tarjeta_vet, fecha_proxima)
VALUES (2, 'Triple felina', '2026-10-05', 'L-2026-0123', 'TP-1001', '2026-09-01');

INSERT INTO vacuna_aplicada (id_mascota, nombre_vacuna, fecha_aplicacion, lote, tarjeta_vet, fecha_proxima)
VALUES (2, 'Triple felina', '2026-10-05', 'L-2026-0123', 'TP-9999', NULL);

INSERT INTO vacuna_aplicada (id_mascota, nombre_vacuna, fecha_aplicacion, lote, tarjeta_vet, fecha_proxima)
VALUES (5, 'Newcastle', '2026-10-06', NULL, 'TP-1003', NULL);

SELECT * FROM vacuna_aplicada;
