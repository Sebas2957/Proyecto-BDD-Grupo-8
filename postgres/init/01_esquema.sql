DROP SCHEMA IF EXISTS biblioteca CASCADE;
CREATE SCHEMA biblioteca;
SET search_path TO biblioteca;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA biblioteca;

CREATE TABLE "usuario" (
  "usuario_id" integer GENERATED ALWAYS AS IDENTITY UNIQUE PRIMARY KEY NOT NULL,
  "nombre" varchar NOT NULL,
  "correo" varchar UNIQUE NOT NULL,
  "telefono" varchar(15),
  "direccion" varchar,
  "contrasena" varchar NOT NULL,
  "rol" integer NOT NULL
);

CREATE TABLE "rol" (
  "rol_id" integer UNIQUE PRIMARY KEY NOT NULL,
  "nombre_rol" varchar UNIQUE,
  "privilegio" varchar
);

CREATE TABLE "ejemplar" (
  "ejemplar_id" integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
  "libro_id" integer NOT NULL,
  "estado" varchar NOT NULL,
  "cantidad" varchar NOT NULL,
  "estanteria" varchar
);

CREATE TABLE "libro" (
  "libro_id" integer GENERATED ALWAYS AS IDENTITY UNIQUE PRIMARY KEY NOT NULL,
  "isbn" varchar(13) UNIQUE NOT NULL,
  "nombre_libro" varchar NOT NULL,
  "autor" varchar,
  "genero" varchar
);

CREATE TABLE "prestamos" (
  "prestamo_id" integer UNIQUE PRIMARY KEY,
  "usuario_id" integer NOT NULL,
  "ejemplar_id" integer NOT NULL,
  "fecha_inicio" date NOT NULL,
  "fecha_fin" date,
  "estado" varchar NOT NULL CHECK ("estado" IN ('activo', 'devuelto', 'vencido')),
  CHECK ("fecha_fin" >= "fecha_inicio")
);

ALTER TABLE "usuario" ADD FOREIGN KEY ("rol") REFERENCES "rol" ("rol_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "ejemplar" ADD FOREIGN KEY ("libro_id") REFERENCES "libro" ("libro_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "prestamos" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("usuario_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "prestamos" ADD FOREIGN KEY ("ejemplar_id") REFERENCES "ejemplar" ("ejemplar_id") DEFERRABLE INITIALLY IMMEDIATE;

INSERT INTO "rol" ("rol_id", "nombre_rol") VALUES (1, 'lector'), (2, 'bibliotecario'), (3, 'administrador'), (4, 'auditor');

CREATE TABLE "rechazo_carga" (
  "id_rechazo" integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "fecha_carga" timestamp NOT NULL DEFAULT now(),
  "archivo" text NOT NULL,
  "linea" integer NOT NULL,
  "contenido" text,
  "motivo" text NOT NULL
);