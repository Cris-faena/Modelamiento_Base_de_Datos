-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2026-10-10 15:31:44 CLST
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE


-- 1 - Se dropean las tablas
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE CLUB_FUTBOL CASCADE CONSTRAINTS;
DROP TABLE ASOCIACION CASCADE CONSTRAINTS;
DROP TABLE NIVEL_IDIOMA CASCADE CONSTRAINTS;
DROP TABLE JUGADOR CASCADE CONSTRAINTS;
DROP TABLE HISTORIAL_CLUB CASCADE CONSTRAINTS;
DROP TABLE PERSONAL_PLANTA CASCADE CONSTRAINTS;
DROP TABLE TRABAJADOR CASCADE CONSTRAINTS;


DROP TABLE NACIONALIDAD CASCADE CONSTRAINTS;
DROP TABLE GENERO CASCADE CONSTRAINTS;
DROP TABLE ESTADO_CIVIL CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE TIPO CASCADE CONSTRAINTS;
DROP TABLE IDIOMA CASCADE CONSTRAINTS;
DROP TABLE ESCUELA CASCADE CONSTRAINTS;

-- 1B : SECUENCIAS:
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_CLUB_FUTBOL';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

-- 2 - Se crean las tablas con el SCRIPT DATA MODELER
CREATE TABLE ASOCIACION 
    ( 
     cod_asociacion    NUMBER (4)  NOT NULL , 
     nombre_asociacion VARCHAR2 (50)  NOT NULL , 
     fecha_creacion    DATE  NOT NULL , 
     TIPO_cod_tipo     CHAR (1)  NOT NULL 
    ) 
;

ALTER TABLE ASOCIACION 
    ADD CONSTRAINT ASOCIACION_PK PRIMARY KEY ( cod_asociacion ) ;

CREATE TABLE CLUB_FUTBOL 
    ( 
     cod_club         NUMBER (4)  NOT NULL , 
     nombre_club      VARCHAR2 (30)  NOT NULL , 
     patrimonio_club  NUMBER (11,2)  NOT NULL , 
     calle_club       VARCHAR2 (30)  NOT NULL , 
     numero_calleClub NUMBER (5)  NOT NULL , 
     COMUNA_id_comuna NUMBER (3)  NOT NULL , 
     COMUNA_id_region NUMBER (2)  NOT NULL , 
     TIPO_cod_tipo    CHAR (1)  NOT NULL 
    ) 
;

ALTER TABLE CLUB_FUTBOL 
    ADD CONSTRAINT CLUB_FUTBOL_PK PRIMARY KEY ( cod_club ) ;

ALTER TABLE CLUB_FUTBOL 
    ADD CONSTRAINT CLUB_FUTBOL_nombre_club_UN UNIQUE ( nombre_club ) ;

CREATE TABLE COMUNA 
    ( 
     id_comuna        NUMBER (3)  NOT NULL , 
     nombre_comuna    VARCHAR2 (30)  NOT NULL , 
     REGION_id_region NUMBER (2)  NOT NULL 
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( id_comuna, REGION_id_region ) ;

CREATE TABLE ESCUELA 
    ( 
     cod_escuela       NUMBER (4)  NOT NULL , 
     nombre_escuela    VARCHAR2 (50)  NOT NULL , 
     capacidad_alumnos NUMBER (3)  NOT NULL , 
     fecha_fundacion   DATE  NOT NULL 
    ) 
;

ALTER TABLE ESCUELA 
    ADD CONSTRAINT ESCUELA_PK PRIMARY KEY ( cod_escuela ) ;

CREATE TABLE ESTADO_CIVIL 
    ( 
     id_estadoCivil          CHAR (1)  NOT NULL , 
     descripcion_estadoCivil VARCHAR2 (10)  NOT NULL 
    ) 
;

ALTER TABLE ESTADO_CIVIL 
    ADD CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY ( id_estadoCivil ) ;

CREATE TABLE GENERO 
    ( 
     id_genero          CHAR (1)  NOT NULL , 
     descripcion_genero VARCHAR2 (10)  NOT NULL 
    ) 
;

ALTER TABLE GENERO 
    ADD CONSTRAINT GENERO_PK PRIMARY KEY ( id_genero ) ;

CREATE TABLE HISTORIAL_CLUB
    ( 
     CLUB_FUTBOL_cod_club NUMBER (4)  NOT NULL , 
     JUGADOR_id           NUMBER (9)  NOT NULL , 
     fecha_ingreso        DATE  NOT NULL , 
     fecha_salida         DATE  NOT NULL 
    ) 
;

ALTER TABLE HISTORIAL_CLUB 
    ADD CONSTRAINT HISTORIAL_CLUB_PK PRIMARY KEY ( CLUB_FUTBOL_cod_club, JUGADOR_id ) ;

CREATE TABLE IDIOMA 
    ( 
     cod_idioma  NUMBER (2)  NOT NULL , 
     tipo_idioma VARCHAR2 (20)  NOT NULL 
    ) 
;

ALTER TABLE IDIOMA 
    ADD CONSTRAINT IDIOMA_PK PRIMARY KEY ( cod_idioma ) ;

CREATE TABLE JUGADOR 
    ( 
     id                        NUMBER (9)  NOT NULL , 
     puesto                    VARCHAR2 (7)  NOT NULL , 
     monto_acumulado_premios   NUMBER (10,2)  NOT NULL , 
     año_salidaAmateur         DATE , 
     ESCUELA_cod_escuela       NUMBER (4) , 
     ASOCIACION_cod_asociacion NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE JUGADOR 
    ADD CONSTRAINT JUGADOR_PK PRIMARY KEY ( id ) ;

CREATE TABLE NACIONALIDAD 
    ( 
     id_nacion                NUMBER (3)  NOT NULL , 
     descripcion_nacionalidad VARCHAR2 (20)  NOT NULL 
    ) 
;

ALTER TABLE NACIONALIDAD 
    ADD CONSTRAINT NACIONALIDAD_PK PRIMARY KEY ( id_nacion ) ;

CREATE TABLE NIVEL_IDIOMA 
    ( 
     IDIOMA_cod_idioma NUMBER (2)  NOT NULL , 
     JUGADOR_id        NUMBER (9)  NOT NULL , 
     nivel_idioma      VARCHAR2 (2)  NOT NULL 
    ) 
;

ALTER TABLE NIVEL_IDIOMA
    ADD CONSTRAINT NIVEL_IDIOMA_PK PRIMARY KEY ( IDIOMA_cod_idioma, JUGADOR_id ) ;

CREATE TABLE PERSONAL_PLANTA 
    ( 
     id               NUMBER (9)  NOT NULL , 
     horas_trabajadas NUMBER (3)  NOT NULL , 
     valor_hora_extra NUMBER (9,2) 
    ) 
;


ALTER TABLE PERSONAL_PLANTA 
    ADD CONSTRAINT PERSONAL_PLANTA_PK PRIMARY KEY ( id ) ;

CREATE TABLE REGION 
    ( 
     id_region     NUMBER (2)  NOT NULL , 
     nombre_region VARCHAR2 (30)  NOT NULL 
    ) 
;

ALTER TABLE REGION 
    ADD CONSTRAINT REGION_PK PRIMARY KEY ( id_region ) ;

CREATE TABLE TIPO 
    ( 
     cod_tipo         CHAR (1)  NOT NULL , 
     descripcion_tipo VARCHAR2 (12)  NOT NULL 
    ) 
;

ALTER TABLE TIPO 
    ADD CONSTRAINT TIPO_PK PRIMARY KEY ( cod_tipo ) ;

CREATE TABLE TRABAJADOR 
    ( 
     id                          NUMBER (9)  NOT NULL , 
     rut                         VARCHAR2 (8)  NOT NULL , 
     dv                          CHAR (1)  NOT NULL , 
     pnombre                     VARCHAR2 (20)  NOT NULL , 
     snombre                     VARCHAR2 (20)  NOT NULL , 
     apaterno                    VARCHAR2 (20)  NOT NULL , 
     amaterno                    VARCHAR2 (20)  NOT NULL , 
     sueldo_base                 NUMBER (10,2)  NOT NULL , 
     fecha_nacimiento            DATE  NOT NULL , 
     estado_civil                VARCHAR2 (10)  NOT NULL , 
     telefono_movil              VARCHAR2 (12)  NOT NULL , 
     calle_jugador               VARCHAR2 (50)  NOT NULL , 
     numero_calle                NUMBER (5)  NOT NULL , 
     email                       VARCHAR2 (50)  NOT NULL , 
     GENERO_id_genero            CHAR (1)  NOT NULL , 
     ESTADO_CIVIL_id_estadoCivil CHAR (1)  NOT NULL , 
     COMUNA_id_comuna            NUMBER (3)  NOT NULL , 
     COMUNA_REGION_id_region     NUMBER (2)  NOT NULL , 
     NACIONALIDAD_id_nacion      NUMBER (3)  NOT NULL 
    ) 
;

ALTER TABLE TRABAJADOR 
    ADD CONSTRAINT TRABAJADOR_PK PRIMARY KEY ( id ) ;

ALTER TABLE ASOCIACION 
    ADD CONSTRAINT ASOCIACION_TIPO_FK FOREIGN KEY 
    ( 
     TIPO_cod_tipo
    ) 
    REFERENCES TIPO 
    ( 
     cod_tipo
    ) 
;

ALTER TABLE CLUB_FUTBOL 
    ADD CONSTRAINT CLUB_FUTBOL_COMUNA_FK FOREIGN KEY 
    ( 
     COMUNA_id_comuna,
     COMUNA_id_region
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna,
     REGION_id_region
    ) 
;

ALTER TABLE CLUB_FUTBOL 
    ADD CONSTRAINT CLUB_FUTBOL_TIPO_FK FOREIGN KEY 
    ( 
     TIPO_cod_tipo
    ) 
    REFERENCES TIPO 
    ( 
     cod_tipo
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_REGION_FK FOREIGN KEY 
    ( 
     REGION_id_region
    ) 
    REFERENCES REGION 
    ( 
     id_region
    ) 
;

ALTER TABLE HISTORIAL_CLUB 
    ADD CONSTRAINT HISTORIAL_CLUB_FUTBOL_FK FOREIGN KEY 
    ( 
     CLUB_FUTBOL_cod_club
    ) 
    REFERENCES CLUB_FUTBOL 
    ( 
     cod_club
    ) 
;

ALTER TABLE HISTORIAL_CLUB 
    ADD CONSTRAINT HISTORIAL_JUGADOR_FK FOREIGN KEY 
    ( 
     JUGADOR_id
    ) 
    REFERENCES JUGADOR 
    ( 
     id
    ) 
;

ALTER TABLE JUGADOR 
    ADD CONSTRAINT JUGADOR_ASOCIACION_FK FOREIGN KEY 
    ( 
     ASOCIACION_cod_asociacion
    ) 
    REFERENCES ASOCIACION 
    ( 
     cod_asociacion
    ) 
;

ALTER TABLE JUGADOR 
    ADD CONSTRAINT JUGADOR_ESCUELA_FK FOREIGN KEY 
    ( 
     ESCUELA_cod_escuela
    ) 
    REFERENCES ESCUELA 
    ( 
     cod_escuela
    ) 
;

ALTER TABLE JUGADOR 
    ADD CONSTRAINT JUGADOR_TRABAJADOR_FK FOREIGN KEY 
    ( 
     id
    ) 
    REFERENCES TRABAJADOR 
    ( 
     id
    ) 
;

ALTER TABLE NIVEL_IDIOMA
    ADD CONSTRAINT NIVEL_IDIOMA_FK FOREIGN KEY 
    ( 
     IDIOMA_cod_idioma
    ) 
    REFERENCES IDIOMA 
    ( 
     cod_idioma
    ) 
;

ALTER TABLE NIVEL_IDIOMA
    ADD CONSTRAINT NIVEL_JUGADOR_FK FOREIGN KEY 
    ( 
     JUGADOR_id
    ) 
    REFERENCES JUGADOR 
    ( 
     id
    ) 
;

ALTER TABLE PERSONAL_PLANTA 
    ADD CONSTRAINT PERSONAL_PLANTA_TRABAJADOR_FK FOREIGN KEY 
    ( 
     id
    ) 
    REFERENCES TRABAJADOR 
    ( 
     id
    ) 
;

ALTER TABLE TRABAJADOR 
    ADD CONSTRAINT TRABAJADOR_COMUNA_FK FOREIGN KEY 
    ( 
     COMUNA_id_comuna,
     COMUNA_REGION_id_region
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna,
     REGION_id_region
    ) 
;

ALTER TABLE TRABAJADOR 
    ADD CONSTRAINT TRABAJADOR_ESTADO_CIVIL_FK FOREIGN KEY 
    ( 
     ESTADO_CIVIL_id_estadoCivil
    ) 
    REFERENCES ESTADO_CIVIL 
    ( 
     id_estadoCivil
    ) 
;

ALTER TABLE TRABAJADOR 
    ADD CONSTRAINT TRABAJADOR_GENERO_FK FOREIGN KEY 
    ( 
     GENERO_id_genero
    ) 
    REFERENCES GENERO 
    ( 
     id_genero
    ) 
;

ALTER TABLE TRABAJADOR 
    ADD CONSTRAINT TRABAJADOR_NACIONALIDAD_FK FOREIGN KEY 
    ( 
     NACIONALIDAD_id_nacion
    ) 
    REFERENCES NACIONALIDAD 
    ( 
     id_nacion
    ) 
;

-- 3 - Se agregan los requerimientos del caso

--3.1 - La tabla NACIONALIDAD de generarse mediante IDENTITY, comenzando en 210 e incrementarse de dos en dos:
ALTER TABLE TRABAJADOR
DROP CONSTRAINT TRABAJADOR_NACIONALIDAD_FK;

ALTER TABLE NACIONALIDAD
DROP CONSTRAINT NACIONALIDAD_PK;

ALTER TABLE NACIONALIDAD
DROP COLUMN id_nacion;

ALTER TABLE NACIONALIDAD
ADD id_nacion NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 2);

ALTER TABLE NACIONALIDAD
ADD CONSTRAINT NACIONALIDAD_PK PRIMARY KEY (id_nacion);

ALTER TABLE TRABAJADOR
ADD CONSTRAINT TRABAJADOR_NACIONALIDAD_FK
FOREIGN KEY (NACIONALIDAD_id_nacion)
REFERENCES NACIONALIDAD (id_nacion);

-- 3.2 Se modifica la tabla ASOCIACION para establecer la restriccion de la fecha:
ALTER TABLE ASOCIACION
ADD CONSTRAINT FECHA_CREACION_ASOCIACION_CK
CHECK (fecha_creacion >= DATE '1980-12-31');

-- 3.3 Se crea una secuencia para modificar que el ID comience en 703 y se incremente  de 4 en 4.

CREATE SEQUENCE SEQ_CLUB_FUTBOL
START WITH 703
INCREMENT BY 4;

-- 3.4 Se crea una restriccion para que los valores de la ASOCIACION sean "A" o "P"
ALTER TABLE TIPO
ADD CONSTRAINT TIPO_ASOCIACION_CK
CHECK (cod_tipo IN ('A','P'));

-- 4 - Se comienza con el poblado de las TABLAS

-- 4.0 inserta valores en la tabla TIPO:

INSERT INTO TIPO (cod_tipo, descripcion_tipo)
VALUES ('A', 'Amateur');

INSERT INTO TIPO (cod_tipo, descripcion_tipo)
VALUES ('P', 'Profesional');


-- 4.1 inserta valores en la tabla REGION:

INSERT INTO REGION
VALUES (1,'ARICA Y PARINACOTA Y TARAPACA');

INSERT INTO REGION
VALUES (2, 'ANTOFAGASTA');

INSERT INTO REGION
VALUES (3, 'ATACAMA Y COQUIMBO');

INSERT INTO REGION
VALUES (5, 'VALPARAISO');

INSERT INTO REGION
VALUES (8, 'BIOBIO');

INSERT INTO REGION
VALUES (13, 'METROPOLITANA');

INSERT INTO REGION
VALUES (16, 'ÑUBLE');

-- 4.2 inserta valores en la tabla nacionalidad
INSERT INTO NACIONALIDAD (descripcion_nacionalidad)
VALUES ('Chilena');

INSERT INTO NACIONALIDAD (descripcion_nacionalidad)
VALUES ('Argentina');

INSERT INTO NACIONALIDAD (descripcion_nacionalidad)
VALUES ('Peruana');

INSERT INTO NACIONALIDAD (descripcion_nacionalidad)
VALUES ('Boliviana');

INSERT INTO NACIONALIDAD (descripcion_nacionalidad)
VALUES ('Brasileña');

-- 4.3 inserta valores en la tabla COMUNA. Se añade la restricción del AVA
INSERT INTO COMUNA
VALUES (101,'Santiago', 13);

INSERT INTO COMUNA
VALUES (102,'Valparaíso', 5);

INSERT INTO COMUNA
VALUES (103,'Concepción', 8);

INSERT INTO COMUNA
VALUES (104,'Antofagasta', 2);

INSERT INTO COMUNA
VALUES (105,'Chillán', 16);

-- 4.3 inserta valores a la tabla ASOCIACION
INSERT INTO ASOCIACION
VALUES(25, 'Asociación de Fútbol de Santiago', DATE '2001-05-15', 'P');

INSERT INTO ASOCIACION
VALUES(26, 'Asociación Nacional de Fútbol Amateur', DATE '1998-03-10', 'A');

INSERT INTO ASOCIACION
VALUES(27, 'Asociación de Fútbol de Valparaíso', DATE '1987-07-21', 'P');

INSERT INTO ASOCIACION
VALUES(28, 'Asociación de Fútbol de Concepción', DATE '1995-11-30', 'A');

INSERT INTO ASOCIACION
VALUES(29, 'Asociación de Fútbol de Antofagasta', DATE '2003-06-25', 'P');

INSERT INTO ASOCIACION
VALUES(30, 'Asociación de Fútbol de Temuco', DATE '2010-01-12', 'A');

INSERT INTO ASOCIACION
VALUES(31, 'Asociación de Fútbol de Rancagua', DATE '1999-09-08', 'P');

INSERT INTO ASOCIACION
VALUES(32, 'Asociación de Fútbol de Puerto Montt', DATE '2005-04-20', 'A');

INSERT INTO ASOCIACION
VALUES(33, 'Asociación de Fútbol de La Serena', DATE '2012-08-14', 'P');

INSERT INTO ASOCIACION
VALUES(34, 'Asociación de Fútbol de Chillán', DATE '2018-12-01', 'A');

-- 4.4 inserta valores en la tabla CLUB_FUTBOL
INSERT INTO CLUB_FUTBOL
VALUES(SEQ_CLUB_FUTBOL.NEXTVAL, 'Colo-Colo', 500000000, 'Av. Marathon',5300, 101,13,'P');

INSERT INTO CLUB_FUTBOL
VALUES(SEQ_CLUB_FUTBOL.NEXTVAL, 'Universidad de Chile', 450000000, 'Av. El Parrón',0931, 101,13,'P');

INSERT INTO CLUB_FUTBOL
VALUES(SEQ_CLUB_FUTBOL.NEXTVAL, 'Deportes Antofagasta', 180000000, 'Avenida Angamos',01606, 104,2,'P');

INSERT INTO CLUB_FUTBOL
VALUES(SEQ_CLUB_FUTBOL.NEXTVAL, 'Huachipato', 220000000, 'Avenida Desiderio García',909, 103,8,'P');

INSERT INTO CLUB_FUTBOL
VALUES(SEQ_CLUB_FUTBOL.NEXTVAL, 'Ñublense', 170000000, 'Avenida Pedro Aguirre Cerda',1003, 105,16,'P');

COMMIT;

-- 5 Recuperación de datos:

-- INFORME N°1:

SELECT 
SUBSTR('ID:' || cod_asociacion || ' * ' || nombre_asociacion,1,50) AS "ASOCIACION",
TO_CHAR(fecha_creacion, 'DD-MM-YYYY') AS "CREADA",
TIPO_cod_tipo AS "TIPO"
FROM ASOCIACION
WHERE TIPO_cod_tipo = 'P'
AND EXTRACT (YEAR FROM fecha_creacion) > 2000
ORDER BY fecha_creacion DESC;

-- INFORME N° 2:

SELECT
cod_club AS "CLUB",
nombre_club AS "NOMBRE CLUB",
patrimonio_club AS "PATRIMONIO EN PESOS",
patrimonio_club / 955 AS "PATRIMONIO EN DOLARES"
FROM CLUB_FUTBOL
WHERE nombre_club LIKE '%a%'
AND patrimonio_club > 200000000
AND TIPO_cod_tipo = 'P'
ORDER BY cod_club DESC;

-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            15
-- CREATE INDEX                             0
-- ALTER TABLE                             34
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
