-- 1. Se dropean las tablas y las secuencias:

-- 1A : TABLAS
DROP TABLE ESTANDAR CASCADE CONSTRAINTS;
DROP TABLE PREMIUM CASCADE CONSTRAINTS;
DROP TABLE CIUDAD CASCADE CONSTRAINTS;
DROP TABLE MODELO CASCADE CONSTRAINTS;
DROP TABLE AUTOMOVIL CASCADE CONSTRAINTS;
DROP TABLE SUCURSAL CASCADE CONSTRAINTS;
DROP TABLE MANTENCION CASCADE CONSTRAINTS;
DROP TABLE DETALLE_SERVICIO CASCADE CONSTRAINTS;

DROP TABLE SERVICIO CASCADE CONSTRAINTS;
DROP TABLE MARCA CASCADE CONSTRAINTS;
DROP TABLE TIPO_AUTOMOVIL CASCADE CONSTRAINTS;
DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE MECANICO CASCADE CONSTRAINTS;
DROP TABLE PAIS CASCADE CONSTRAINTS;

-- 1B : SECUENCIAS:
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_SERVICIO';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_CIUDAD';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_MANTENCION';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_MECANICO';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

-- 2 . Se crean las tablas del modelo.
CREATE TABLE SERVICIO(
id_servicio NUMBER(3) NOT NULL,
descripcion VARCHAR2(100) NOT NULL,
costo NUMBER(7) NOT NULL
);

CREATE TABLE MARCA(
id_marca NUMBER(2) NOT NULL,
descripcion VARCHAR2(20) NOT NULL
);

CREATE TABLE TIPO_AUTOMOVIL(
id_tipo CHAR(3) NOT NULL,
descripcion VARCHAR2(20) NOT NULL
);

CREATE TABLE PAIS(
id_pais NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 9 INCREMENT BY 3),  
nom_pais VARCHAR2(30)NOT NULL
);

CREATE TABLE MECANICO(
cod_mecanico NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 460 INCREMENT BY 7),
pnombre VARCHAR2(20) NOT NULL,
snombre VARCHAR2(20) NOT NULL,
apaterno VARCHAR2(20) NOT NULL,
amaterno VARCHAR2(20) NOT NULL,
bono_jefatura NUMBER(10),
sueldo NUMBER(10) NOT NULL,
monto_impuesto NUMBER(10) NOT NULL,
cod_supervisor NUMBER(5)
);

CREATE TABLE CLIENTE(
rut NUMBER(8) NOT NULL,
dv CHAR(1) NOT NULL,
pnombre VARCHAR2(20) NOT NULL,
snombre VARCHAR2(20),
apaterno VARCHAR2(20) NOT NULL,
amaterno VARCHAR2(20) NOT NULL,
telefono VARCHAR2(12),
email VARCHAR2(40),
tipo_cli CHAR(1)
);

CREATE TABLE ESTANDAR(
cl_rut NUMBER(8) NOT NULL,
puntaje_fidelidad NUMBER(10) NOT NULL
);

CREATE TABLE PREMIUM(
cl_rut NUMBER(8) NOT NULL,
pesos_clientes NUMBER(10) NOT NULL,
monto_credito NUMBER(10) 
);

CREATE TABLE CIUDAD(
id_ciudad NUMBER(3) NOT NULL,
nom_ciudad VARCHAR2(30) NOT NULL,
cod_pais NUMBER(3) NOT NULL
);

CREATE TABLE MODELO(
id_modelo NUMBER(5) NOT NULL,
marca_id NUMBER(2) NOT NULL,
descripcion VARCHAR2(20) NOT NULL
);

CREATE TABLE AUTOMOVIL(
patente CHAR(8) NOT NULL,
aniio NUMBER(4) NOT NULL,
cant_puertas NUMBER(1) NOT NULL,
km NUMBER(6) NOT NULL,
color VARCHAR2(30) NOT NULL,
cod_tipo_auto CHAR(3) NOT NULL,
cod_modelo NUMBER(5) NOT NULL,
cod_marca NUMBER(2) NOT NULL,
cl_rut NUMBER(8) NOT NULL
);

CREATE TABLE SUCURSAL(
id_sucursal CHAR(3) NOT NULL,
nom_sucursal VARCHAR2(20) NOT NULL,
calle VARCHAR2(20) NOT NULL,
num_calle NUMBER(4) NOT NULL,
cod_ciudad NUMBER(3) NOT NULL
);

CREATE TABLE MANTENCION(
num_mantencion NUMBER(4) NOT NULL,
cod_sucursal CHAR(3) NOT NULL,
fecha_ingreso DATE NOT NULL,
fecha_salida DATE,
patente_auto CHAR(8),
cod_mecanico NUMBER(5) NOT NULL,
costo_total NUMBER(7) NOT NULL,
estado VARCHAR2(15)
);

CREATE TABLE DETALLE_SERVICIO(
mantencion_num NUMBER(4) NOT NULL,
cod_servicio NUMBER(3) NOT NULL,
descuento_serv NUMBER(4,3) NOT NULL,
cantidad NUMBER(3) NOT NULL
);

-- 3. Se establecen las restricciones:
ALTER TABLE SERVICIO
ADD CONSTRAINT  PK_SERVICIO PRIMARY KEY (id_servicio);

ALTER TABLE MARCA
ADD CONSTRAINT PK_MARCA PRIMARY KEY (id_marca);

ALTER TABLE TIPO_AUTOMOVIL
ADD CONSTRAINT PK_TIPO_AUTOMOVIL PRIMARY KEY (id_tipo);

ALTER TABLE CLIENTE
ADD CONSTRAINT PK_CLIENTE PRIMARY KEY (rut);

ALTER TABLE PAIS
ADD CONSTRAINT PK_PAIS PRIMARY KEY (id_pais);

ALTER TABLE MECANICO
ADD(
CONSTRAINT PK_MECANICO PRIMARY KEY (cod_mecanico),
CONSTRAINT FK_MECANICO FOREIGN KEY (cod_supervisor) REFERENCES MECANICO (cod_mecanico)
);

ALTER TABLE ESTANDAR
ADD (
CONSTRAINT PK_NORMAL PRIMARY KEY (cl_rut),
CONSTRAINT FK_NORMAL_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut)
);

ALTER TABLE PREMIUM
ADD(
CONSTRAINT PK_PREMIUM PRIMARY KEY (cl_rut),
CONSTRAINT FK_PREMIUM_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut)
);

ALTER TABLE CIUDAD
ADD( 
CONSTRAINT PK_CIUDAD PRIMARY KEY (id_ciudad),
CONSTRAINT FK_CIUDAD_PAIS FOREIGN KEY (cod_pais) REFERENCES PAIS (id_pais)
);

ALTER TABLE MODELO
ADD(
CONSTRAINT PK_MODELO PRIMARY KEY (id_modelo, marca_id),
CONSTRAINT FK_MODELO_MARCA FOREIGN KEY (marca_id) REFERENCES MARCA (id_marca)
);

ALTER TABLE AUTOMOVIL
ADD(
CONSTRAINT PK_AUTOMOVIL PRIMARY KEY (patente),
CONSTRAINT FK_AUTOMOVIL_MODELO FOREIGN KEY (cod_modelo, cod_marca) REFERENCES MODELO (id_modelo, marca_id),
CONSTRAINT FK_AUTOMOVIL_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut),
CONSTRAINT FK_AUTOMOVIL_TIPOAUTO FOREIGN KEY (cod_tipo_auto) REFERENCES TIPO_AUTOMOVIL (id_tipo)
);

ALTER TABLE SUCURSAL
ADD(
CONSTRAINT PK_SUCURSAL PRIMARY KEY (id_sucursal),
CONSTRAINT FK_SUCURSAL_CIUDAD FOREIGN KEY (cod_ciudad) REFERENCES CIUDAD (id_ciudad)
);

ALTER TABLE MANTENCION
ADD(
CONSTRAINT PK_MANTENCION PRIMARY KEY (num_mantencion),
CONSTRAINT FK_MANT_SUCURSAL FOREIGN KEY (cod_sucursal) REFERENCES SUCURSAL (id_sucursal),
CONSTRAINT FK_MANT_AUTO FOREIGN KEY (patente_auto) REFERENCES AUTOMOVIL (patente),
CONSTRAINT FK_MANT_MECANICO FOREIGN KEY (cod_mecanico) REFERENCES MECANICO (cod_mecanico)
);

ALTER TABLE DETALLE_SERVICIO
ADD(
CONSTRAINT PK_DETALLE_SERVICIO PRIMARY KEY (cod_servicio, mantencion_num),
CONSTRAINT FK_DETSERV_MANT FOREIGN KEY (mantencion_num) REFERENCES MANTENCION (num_mantencion),
CONSTRAINT FK_DETSERV_SERV FOREIGN KEY (cod_servicio) REFERENCES SERVICIO (id_servicio)
);

-- 4. Se agregan las modificaciones establecidas en las reglas de negocio.

-- 4a: elimnar columna costo_total de la tabla MANTENCION:
-- 4b: ajustar la FK de la tabla DETALLE_SERVICIO:

ALTER TABLE MANTENCION
DROP COLUMN costo_total;

-- 4b: modificar la PK de MANTENCION. (PASOS A DESARROLLAR):

-- 4b.1 : la PK MANTENCION debe contener la PK de SUCURSAL:

-- paso 1: DROPEAR CONSTRAINTS desde SUCURSAL a MANTENCION.
ALTER TABLE MANTENCION
DROP CONSTRAINT FK_MANT_SUCURSAL;

-- paso 2: DROPEAR CONSTRAINTS tipo FK desde DETALLE_SERVICIO a MANTENCION.
ALTER TABLE DETALLE_SERVICIO
DROP CONSTRAINT FK_DETSERV_MANT;

-- paso 3: DROPEAR CONSTRAINTS tipo PK en DETALLE_SERVICIO.
ALTER TABLE DETALLE_SERVICIO
DROP CONSTRAINT PK_DETALLE_SERVICIO;

-- paso 5: DROPEAR la columna mantencion_num de la tabla DETALLE_SERVICIO.
ALTER TABLE DETALLE_SERVICIO
DROP COLUMN mantencion_num;

-- paso 6: CREAR una columna mantencion_num y cod_SUCURSAL para la tabla DETALLE_SERVICIO.
-- esta albergará la nueva PF compuesta de la TABLA MANTENCION
ALTER TABLE DETALLE_SERVICIO
ADD (
mantencion_num NUMBER(4) NOT NULL,
cod_sucursal CHAR(3) NOT NULL
);

-- paso 7: DROPEAR CONSTRAINT PK de la tabla MANTENCION.
ALTER TABLE MANTENCION
DROP CONSTRAINT PK_MANTENCION;

-- paso 8: DROPEAR la columna num_mantencion de la TABLA MANTENCION.
ALTER TABLE MANTENCION
DROP COLUMN num_mantencion;

-- paso 9: CREAR la columna num_mantencion de la TABLA MANTENCION.
ALTER TABLE MANTENCION
ADD num_mantencion NUMBER(4) NOT NULL;

-- paso 8: crea una PK compuesta por MANTENCION y SUCURSAL.
ALTER TABLE MANTENCION
ADD CONSTRAINT PK_MANTENCION PRIMARY KEY (num_mantencion, cod_sucursal);

-- paso 9: crea una FK entre MANTENCION y DETALLE_SERVICIO.
ALTER TABLE DETALLE_SERVICIO
ADD CONSTRAINT PK_DETALLE_SERVICIO PRIMARY KEY (mantencion_num, cod_servicio);

-- paso 9: crea una PK compuesta por DETALLESERV y MANTENCION.
ALTER TABLE DETALLE_SERVICIO
ADD CONSTRAINT FK_DETSERV_MANT FOREIGN KEY (mantencion_num, cod_sucursal) REFERENCES MANTENCION (num_mantencion, cod_sucursal);

-- 4c : Se modifica el valor de la columna EMAIL de la TABLA CLIENTE, para que sea UNIQUE:
ALTER TABLE CLIENTE
ADD CONSTRAINT UN_CLIENTE UNIQUE (email);

-- 4D: Se modifica el valor de la TABLA CLIENTE, en la columna dv, para agregar CHECKED:
ALTER TABLE CLIENTE
ADD CONSTRAINT CK_DV CHECK (UPPER(dv) IN ('0','1','2','3','4','5','6','7','8','9','K'));

-- 4E: Se modifica la tabla MECANICO, en la columna sueldo, agregando una restriccion de sueldo:
ALTER TABLE MECANICO
ADD CONSTRAINT CK_SUELDO CHECK (sueldo >= 510000);

-- 4F: Se modifica la tabla MANTENCION para agregar restricciones CHECKED a la columna estado:
ALTER TABLE MANTENCION
ADD CONSTRAINT CK_MANTENCION 
CHECK (estado IN ('RESERVA','INGRESADO','ENTREGADO','ANULADO'));

-- 5 : Se agregan secuencias a las TABLAS SERVICIO y CIUDAD

-- 5a: Se implementa una secuencia para la tabla SERVICIO:
CREATE SEQUENCE SEQ_SERVICIO
START WITH 400 INCREMENT BY 2;

-- 5b: Se agrega una secuencia para la tabla CIUDAD:
CREATE SEQUENCE SEQ_CIUDAD
START WITH 165 INCREMENT BY 5;

-- 5c: Comienza el poblado de las tablas:

-- 5c.1 poblado de tabla SERVICIO:
INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL,'Cambio de luces',45000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL,'Desabolladura',67000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL,'Revision frenos',30000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL,'Cambio puerta trasera',50000);

-- 5c.2: poblado de tabla MECANICO:

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuesto, cod_supervisor)
VALUES ('Jorge', 'Pablo','Soto','Sierpe',5400000,2759000,223580,null);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuesto, cod_supervisor)
VALUES ('Pedro','Jose','Manriquez','Corral',null,759000,23980,null);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuesto, cod_supervisor)
VALUES ('Sandra','Josefa','Letelier','S.',0,659000,22358,460);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuesto, cod_supervisor)
VALUES ('Felipe','M.','Vidal','A.',null,759000,23580,460);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuesto, cod_supervisor)
VALUES ('Jose','Miguel','Troncoso','B.',null,659000,44580,474);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuesto, cod_supervisor)
VALUES ('Juan','Pablo','Sanchez','R.',null,859000,23380,474);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuesto, cod_supervisor)
VALUES ('Carlos','Felipe','Soto','J.',0,597000,23580,474);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuesto, cod_supervisor)
VALUES ('Alberto','P.','Cerda','Ramirez',null,559000,22380,460);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuesto, cod_supervisor)
VALUES ('Alejandra','Gabriela','Infanti','R.',null,659000,22380,460);

INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuesto, cod_supervisor)
VALUES ('Roberto','Patricio','Gutierrez','Soza',null,859000,22380,460);

-- 5c.3 poblado de tabla PAIS
INSERT INTO PAIS (nom_pais)
VALUES ('Chile');

INSERT INTO PAIS (nom_pais)
VALUES ('Perú');

INSERT INTO PAIS (nom_pais)
VALUES ('Colombia');

-- 5c.4 poblado de tabla CIUDAD
INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
VALUES (SEQ_CIUDAD.NEXTVAL,'Santiago',9);

INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
VALUES (SEQ_CIUDAD.NEXTVAL,'Lima',12);

INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
VALUES (SEQ_CIUDAD.NEXTVAL,'Bogotá',15);

-- 5C.5 poblado de tabla SUCURSAL:
INSERT INTO SUCURSAL (id_sucursal,nom_sucursal,calle,num_calle,cod_ciudad)
VALUES ('S01','Providencia','Av. A. Varas',234,165);

INSERT INTO SUCURSAL (id_sucursal,nom_sucursal,calle,num_calle,cod_ciudad)
VALUES ('S02','Las 4 esquinas','Av. Latina',669,170);

INSERT INTO SUCURSAL (id_sucursal,nom_sucursal,calle,num_calle,cod_ciudad)
VALUES ('S03','El Cafetero','Av. El Faro',900,175);

-- 5c.6 poblado de tabla MANTENCION:
CREATE SEQUENCE SEQ_MANTENCION
START WITH 101 INCREMENT BY 1;

INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (SEQ_MANTENCION.NEXTVAL,'S01','12-04-2023',null,null,'481','RESERVA');

INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (SEQ_MANTENCION.NEXTVAL,'S02','21-02-2023','21-02-2023',null,'502','ENTREGADO');

INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (SEQ_MANTENCION.NEXTVAL,'S03','09-10-2023',null,null,'502','ANULADO');

INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (SEQ_MANTENCION.NEXTVAL,'S04','11-08-2023','18-08-2023',null,'509','ENTREGADO');

INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (SEQ_MANTENCION.NEXTVAL,'S05','03-12-2023',null,null,'509','INGRESADO');

-- 6. Se elaboran los informes solicitados:

-- INFORME N° 1:

SELECT  
cod_mecanico AS "ID MECANICO",
pnombre || ' ' || apaterno AS "NOMBRE MECANICO",
sueldo AS "SALARIO",
monto_impuesto AS "IMPUESTO ACTUAL",
monto_impuesto * 0.8 AS "IMPUESTO REBAJADO",
sueldo - (monto_impuesto * 0.8) AS "SUELDO CON REBAJA IMPUESTOS"
FROM MECANICO
WHERE bono_jefatura IS NULL AND monto_impuesto < 40000
ORDER BY monto_impuesto DESC, apaterno ASC;

-- INFORME N° 2:

SELECT
cod_mecanico AS "IDENTIFICADOR",
pnombre || ' ' || snombre || ' ' || apaterno AS "MECANICO",
sueldo AS "SALARIO ACTUAL",
sueldo * 0.05 AS "AJUSTE",
sueldo + (sueldo * 0.05) AS "SUELDO_REAJUSTADO"
FROM MECANICO
WHERE sueldo BETWEEN 600000 AND 900000 OR cod_supervisor IS NULL
ORDER BY sueldo ASC, "MECANICO" DESC;
