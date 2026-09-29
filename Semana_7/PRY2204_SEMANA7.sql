-- 1. Se crea un DROP TABLE para todas las tablas:

DROP TABLE TITULACION CASCADE CONSTRAINTS;
DROP TABLE DOMINIO CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE COMPANIA CASCADE CONSTRAINTS;
DROP TABLE PERSONAL CASCADE CONSTRAINTS;

DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE ESTADO_CIVIL CASCADE CONSTRAINTS;
DROP TABLE IDIOMA CASCADE CONSTRAINTS;
DROP TABLE GENERO CASCADE CONSTRAINTS;
DROP TABLE TITULO CASCADE CONSTRAINTS;

-- 2. Se crean las tablas
CREATE TABLE REGION(
id_region NUMBER(2) NOT NULL,
nombre_region VARCHAR2(25) NOT NULL
);

CREATE TABLE COMUNA(
id_comuna NUMBER(5) NOT NULL,
comuna_nombre VARCHAR2(25) NOT NULL,
cod_region NUMBER(2) NOT NULL
);

CREATE TABLE COMPANIA(
id_empresa NUMBER(2) NOT NULL,
nombre_empresa VARCHAR2(25) NOT NULL,
calle VARCHAR2(50) NOT NULL,
numeracion NUMBER(5) NOT NULL,
renta_promedio NUMBER(10) NOT NULL,
pct_aumento NUMBER(4,3),
cod_comuna NUMBER(5) NOT NULL,
cod_region NUMBER(2) NOT NULL
);

CREATE TABLE ESTADO_CIVIL(
id_estado_civil VARCHAR2(2) NOT NULL,
descripcion_est_civil VARCHAR2(25) NOT NULL
);

CREATE TABLE IDIOMA(
id_idioma NUMBER(3) NOT NULL,
nombre_idioma VARCHAR2(30) NOT NULL
);

CREATE TABLE DOMINIO(
id_idioma NUMBER(3) NOT NULL,
persona_rut NUMBER(8) NOT NULL,
nivel VARCHAR2(25) NOT NULL
);

CREATE TABLE TITULO(
id_titulo VARCHAR2(3) NOT NULL,
descripcion_titulo VARCHAR2(60) NOT NULL
);

CREATE TABLE GENERO(
id_genero VARCHAR2(3) NOT NULL,
descripcion_genero VARCHAR2(25) NOT NULL
);

CREATE TABLE TITULACION(
cod_titulo VARCHAR2(3) NOT NULL,
persona_rut NUMBER(8) NOT NULL,
fecha_titulacion DATE NOT NULL
);

CREATE TABLE PERSONAL(
rut_persona NUMBER(8) NOT NULL,
dv_persona CHAR(1),
primer_nombre VARCHAR2(25) NOT NULL,
segundo_nombre VARCHAR2(25),
primer_apellido VARCHAR2(25) NOT NULL,
segundo_apellido VARCHAR2(25) NOT NULL,
fecha_contratacion DATE NOT NULL,
fecha_nacimiento DATE NOT NULL,
email VARCHAR2(100),
calle VARCHAR2(50) NOT NULL,
numeracion NUMBER(5) NOT NULL,
sueldo NUMBER(5) NOT NULL,
cod_comuna NUMBER(5) NOT NULL,
cod_region NUMBER(2) NOT NULL,
cod_genero VARCHAR2(3),
cod_estado_civil VARCHAR2(2),
cod_empresa NUMBER(2) NOT NULL,
encargado_rut NUMBER(8)
);

-- 3. Se establece la relación de claves primarias y foráneas:

-- PK para la tabla REGION:
ALTER TABLE REGION
ADD CONSTRAINT pk_region PRIMARY KEY (id_region);

-- PK para la tabla COMPANIA:
ALTER TABLE COMPANIA
ADD CONSTRAINT pk_compania PRIMARY KEY (id_empresa);

-- PK para la tabla ESTADO_CIVIL:
ALTER TABLE ESTADO_CIVIL
ADD CONSTRAINT pk_estadoCivil PRIMARY KEY (id_estado_civil);

-- PK para la tabla IDIOMA:
ALTER TABLE IDIOMA
ADD CONSTRAINT pk_idioma PRIMARY KEY (id_idioma);

-- PK para la tabla TITULO:
ALTER TABLE TITULO
ADD CONSTRAINT pk_titulo PRIMARY KEY (id_titulo);

-- PK para la tabla GENERO:
ALTER TABLE GENERO
ADD CONSTRAINT pk_genero PRIMARY KEY (id_genero);

-- PK para la tabla PERSONAL:
ALTER TABLE PERSONAL
ADD CONSTRAINT pk_personal PRIMARY KEY (rut_persona);

-- PK para la tabla TITULACION:
ALTER TABLE TITULACION
ADD (
CONSTRAINT pk_titulacion PRIMARY KEY (cod_titulo, persona_rut),
CONSTRAINT fk_titulacion_personal FOREIGN KEY (persona_rut) REFERENCES PERSONAL (rut_persona),
CONSTRAINT fk_titulacion_titulo FOREIGN KEY (cod_titulo) REFERENCES TITULO (id_titulo)
);

-- PK para la tabla DOMINIO:
ALTER TABLE DOMINIO
ADD (
CONSTRAINT pk_dominio PRIMARY KEY (id_idioma, persona_rut),
CONSTRAINT fk_dominio_personal FOREIGN KEY (persona_rut) REFERENCES PERSONAL (rut_persona),
CONSTRAINT fk_dominio_idioma FOREIGN KEY (id_idioma) REFERENCES IDIOMA (id_idioma)
);


-- 4. Se añaden las FOREIGN KEYS a las tablas:
-- Se añade la FK a COMUNA
ALTER TABLE COMUNA
ADD (
CONSTRAINT pk_comuna PRIMARY KEY (id_comuna, cod_region),

CONSTRAINT fk_comuna_region
FOREIGN KEY (cod_region)
REFERENCES REGION(id_region)
);

-- Se añade la FK a COMPANIA (desde comuna y region)
ALTER TABLE COMPANIA
ADD CONSTRAINT fk_compania_comuna
FOREIGN KEY (cod_comuna, cod_region)
REFERENCES COMUNA (id_comuna, cod_region);

-- Se añaden las FK a la tabla PERSONAL:
ALTER TABLE PERSONAL
ADD(
CONSTRAINT fk_codComuna_persona FOREIGN KEY (cod_comuna,cod_region) REFERENCES COMUNA(id_comuna,cod_region),
CONSTRAINT fk_codGenero_persona FOREIGN KEY (cod_genero) REFERENCES GENERO(id_genero),
CONSTRAINT fk_estadoCivil_persona FOREIGN KEY (cod_estado_civil) REFERENCES ESTADO_CIVIL (id_estado_civil),
CONSTRAINT fk_codEmpresa_persona FOREIGN KEY (cod_empresa) REFERENCES COMPANIA(id_empresa),
CONSTRAINT fk_encargadoRut_persona FOREIGN KEY (encargado_rut) REFERENCES PERSONAL(rut_persona)
);

-- 5. Se añaden las restricciones específicas a cada tabla:

-- Se añade UNIQUE a una columna de la tabla COMPANIA
ALTER TABLE COMPANIA
ADD CONSTRAINT UN_compania UNIQUE (nombre_empresa);

-- Se añade un ID autoincrementable en la tabla IDIOMA:


ALTER TABLE DOMINIO
DROP CONSTRAINT fk_dominio_idioma;

ALTER TABLE DOMINIO
DROP CONSTRAINT fk_dominio_personal;

ALTER TABLE DOMINIO
DROP CONSTRAINT pk_dominio;



ALTER TABLE IDIOMA
DROP CONSTRAINT pk_idioma;

ALTER TABLE IDIOMA
DROP COLUMN id_idioma;

ALTER TABLE IDIOMA
ADD id_idioma_AUTO NUMBER GENERATED ALWAYS AS IDENTITY
(START WITH 25 INCREMENT BY 3);

ALTER TABLE IDIOMA
ADD CONSTRAINT pk_id_idioma_auto PRIMARY KEY (id_idioma_AUTO);

ALTER TABLE DOMINIO
ADD CONSTRAINT fk_dominio_idioma
FOREIGN KEY (id_idioma)
REFERENCES IDIOMA (id_idioma_AUTO);

-- Se añade un ID autoincrementable en la tabla REGION:
ALTER TABLE PERSONAL
DROP CONSTRAINT fk_codComuna_persona;

ALTER TABLE COMPANIA
DROP CONSTRAINT fk_compania_comuna;

ALTER TABLE COMUNA
DROP CONSTRAINT pk_comuna;

ALTER TABLE COMUNA
DROP CONSTRAINT fk_comuna_region;

ALTER TABLE REGION
DROP CONSTRAINT pk_region;

ALTER TABLE REGION
DROP COLUMN id_region;

ALTER TABLE REGION
ADD id_region_AUTO NUMBER GENERATED ALWAYS AS IDENTITY
(START WITH 7 INCREMENT BY 2);

ALTER TABLE REGION
ADD CONSTRAINT pk_id_region PRIMARY KEY (id_region_AUTO);

-- Se añade la restriccion UNIQUE a la tabla PERSONAL:
ALTER TABLE PERSONAL
ADD CONSTRAINT UN_personal UNIQUE (email);

-- Se añade la restriccion CHECKED a la tabla PERSONAL:

-- restricción al dígito verificador:
ALTER TABLE PERSONAL
ADD CONSTRAINT CK_personal_dv 
CHECK (UPPER(dv_persona) IN ('0','1','2','3','4','5','6','7','8','9','K'));

-- Restricción al sueldo mínimo:
ALTER TABLE PERSONAL
ADD CONSTRAINT CK_personal_sueldo
CHECK (sueldo >= 450000);

-- Se crea una secuencia para poblar la TABLA COMUNA
CREATE SEQUENCE seq_comuna
START WITH 1001
INCREMENT BY 6;

-- Se crea una sequencia para poblar la TABLA COMPANIA
CREATE SEQUENCE seq_compania
START WITH 10
INCREMENT BY 5;

-- SE DROPEAN LAS SECUENCIAS PARA EMPEZAR DESDE CERO:
DELETE FROM REGION;
DELETE FROM COMUNA;
DELETE FROM COMPANIA;
DELETE FROM ESTADO_CIVIL;
DELETE FROM DOMINIO;
DELETE FROM IDIOMA;
DELETE FROM TITULO;
DELETE FROM TITULACION;
DELETE FROM GENERO;
DELETE FROM PERSONAL;

COMMIT;

DROP SEQUENCE seq_comuna;
DROP SEQUENCE seq_compania;

-- Se crean nuevamente:
CREATE SEQUENCE seq_comuna
    START WITH 1001
    INCREMENT BY 6;

CREATE SEQUENCE seq_compania
    START WITH 10
    INCREMENT BY 5;

-- Se comienza a poblar la Tabla REGION:
INSERT INTO REGION (nombre_region)
VALUES ('ARICA Y PARINACOTA');

INSERT INTO REGION (nombre_region)
VALUES ('METROPOLITANA');

INSERT INTO REGION (nombre_region)
VALUES ('LA ARAUCANIA');

-- Se comienza a poblar la Tabla IDIOMA:
INSERT INTO IDIOMA (nombre_idioma) VALUES ('INGLES');

INSERT INTO IDIOMA (nombre_idioma) VALUES ('CHINO');

INSERT INTO IDIOMA (nombre_idioma) VALUES ('ALEMAN');

INSERT INTO IDIOMA (nombre_idioma) VALUES ('ESPAÑOL');

INSERT INTO IDIOMA (nombre_idioma) VALUES ('INGLES');

-- Se comienza a poblar la Tabla COMUNA:
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (seq_comuna.NEXTVAL, 'ARICA', 7);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (seq_comuna.NEXTVAL, 'SANTIAGO', 9);
INSERT INTO COMUNA (id_comuna, comuna_nombre, cod_region) VALUES (seq_comuna.NEXTVAL, 'TEMUCO', 11);
       
-- Se comienza a poblar la Tabla COMPANIA

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (seq_compania.NEXTVAL, 'CC y Rojas', 'Amapolas', 506, 1857000, 0.5, 1101,7);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (seq_compania.NEXTVAL, 'SenTTy', 'Los Alamos', 3490, 897000, 0.025, 1101,7);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (seq_compania.NEXTVAL, 'Praxia LTDA', 'las Camelias', 11098, 2157000, 0.035, 1107,9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (seq_compania.NEXTVAL, 'TIC spa', 'FLORES SA', 4357, 857000, null, 1107,9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (seq_compania.NEXTVAL, 'SANTANA LTDA', 'AVDA. VIC MACKENA', 106, 757000, 0.015, 1101,7);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (seq_compania.NEXTVAL, 'FLORES Y ASOCIADOS', 'Pedro Latorre', 557, 589000, 0.015, 1107,9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (seq_compania.NEXTVAL, 'J.A. HOFFMAN', 'LATINA D32', 509, 1857000, 0.025, 1113, 11);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (seq_compania.NEXTVAL, 'CAGLIARI D.', 'ALAMEDA', 206, 1857000, null, 1107, 9);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (seq_compania.NEXTVAL, 'Rojas HNOS LTDA', 'SUCRE', 106, 957000, 0.005, 1113, 11);
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region) VALUES (seq_compania.NEXTVAL, 'FRIENDS P. S.A', 'SUECIA', 506, 857000, 0.015, 1113, 11);

-- INFORME 1: Simulacion de renta promedio
-- Orden: Renta Promedio de mayor a menor; en caso de empate, Nombre Empresa A-Z
SELECT nombre_empresa                          AS "Nombre Empresa",
       calle || ' ' || numeracion              AS "Dirección",
       renta_promedio                          AS "Renta Promedio",
       renta_promedio * (1 + pct_aumento)      AS "Simulación de Renta"
FROM   compania
ORDER BY renta_promedio DESC, nombre_empresa ASC;

-- INFORME 2: Nueva simulacion de renta (aumento adicional del 15%)
-- Orden: Renta Promedio Actual ascendente; luego Nombre Empresa descendente
SELECT id_empresa                              AS "CODIGO",
       nombre_empresa                          AS "EMPRESA",
       renta_promedio                          AS "PROM RENTA ACTUAL",
       pct_aumento + 0.15                      AS "PCT AUMENTADO EN 15%",
       renta_promedio * (pct_aumento + 0.15)   AS "RENTA AUMENTADA"
FROM   compania
ORDER BY renta_promedio ASC, nombre_empresa DESC;


















