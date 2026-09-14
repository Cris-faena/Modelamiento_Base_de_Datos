-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2026-09-14 15:14:17 CLST
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE BOLETA 
    ( 
     numero_boleta      VARCHAR2 (8)  NOT NULL , 
     fecha_emision      DATE  NOT NULL , 
     total_venta        NUMBER (10,2)  NOT NULL , 
     CLIENTE_id_cliente VARCHAR2 (12)  NOT NULL 
    ) 
;

ALTER TABLE BOLETA 
    ADD CONSTRAINT BOLETA_PK PRIMARY KEY ( numero_boleta ) ;

CREATE TABLE CATEGORIA 
    ( 
     id_categoria     VARCHAR2 (6)  NOT NULL , 
     nombre_categoria VARCHAR2 (30)  NOT NULL 
    ) 
;

ALTER TABLE CATEGORIA 
    ADD CONSTRAINT CATEGORIA_PK PRIMARY KEY ( id_categoria ) ;

CREATE TABLE CLIENTE 
    ( 
     id_cliente       VARCHAR2 (12)  NOT NULL , 
     primer_nombre    VARCHAR2 (20)  NOT NULL , 
     segundo_nombre   VARCHAR2 (20) , 
     apellido_paterno VARCHAR2 (20)  NOT NULL , 
     apellido_materno VARCHAR2 (20)  NOT NULL , 
     telefono_cliente VARCHAR2 (12)  NOT NULL , 
     COMUNA_id_comuna VARCHAR2 (6)  NOT NULL 
    ) 
;

ALTER TABLE CLIENTE 
    ADD CONSTRAINT CLIENTE_PK PRIMARY KEY ( id_cliente ) ;

CREATE TABLE COMUNA 
    ( 
     id_comuna        VARCHAR2 (6)  NOT NULL , 
     nombre_comuna    VARCHAR2 (30)  NOT NULL , 
     REGION_id_region VARCHAR2 (6)  NOT NULL 
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY ( id_comuna ) ;

CREATE TABLE DET_BOLETA 
    ( 
     BOLETA_numero_boleta    VARCHAR2 (8)  NOT NULL , 
     PRODUCTO_id_producto    VARCHAR2 (10)  NOT NULL , 
     PRODUCTO_SUCURSAL_sigla VARCHAR2 (6)  NOT NULL , 
     cantidad_prod           NUMBER (4)  NOT NULL , 
     precio_unitario         NUMBER (10,2)  NOT NULL 
    ) 
;

ALTER TABLE DET_BOLETA 
    ADD CONSTRAINT Relation_8_PK PRIMARY KEY ( BOLETA_numero_boleta, PRODUCTO_id_producto, PRODUCTO_SUCURSAL_sigla ) ;

CREATE TABLE MARCA 
    ( 
     id_marca     VARCHAR2 (6)  NOT NULL , 
     nombre_marca VARCHAR2 (20)  NOT NULL 
    ) 
;

ALTER TABLE MARCA 
    ADD CONSTRAINT MARCA_PK PRIMARY KEY ( id_marca ) ;

CREATE TABLE MODELO 
    ( 
     id_modelo          VARCHAR2 (6)  NOT NULL , 
     nombre_modelo      VARCHAR2 (50)  NOT NULL , 
     descripcion_modelo VARCHAR2 (50)  NOT NULL , 
     MARCA_id_marca     VARCHAR2 (6)  NOT NULL 
    ) 
;

ALTER TABLE MODELO 
    ADD CONSTRAINT MODELO_PK PRIMARY KEY ( id_modelo, MARCA_id_marca ) ;

CREATE TABLE PRODUCTO 
    ( 
     id_producto             VARCHAR2 (10)  NOT NULL , 
     nombre_prod             VARCHAR2 (20)  NOT NULL , 
     fecha_vencimiento       DATE , 
     precio_actual           NUMBER (10,2)  NOT NULL , 
     stock_prod              NUMBER (4) , 
     MODELO_id_modelo        VARCHAR2 (6)  NOT NULL , 
     MODELO_MARCA_id_marca   VARCHAR2 (6)  NOT NULL , 
     CATEGORIA_id_categoria  VARCHAR2 (6)  NOT NULL , 
     PROVEEDOR_rut_proveedor VARCHAR2 (10)  NOT NULL , 
     SUCURSAL_sigla          VARCHAR2 (6)  NOT NULL 
    ) 
;

ALTER TABLE PRODUCTO 
    ADD CONSTRAINT PRODUCTO_PK PRIMARY KEY ( id_producto, SUCURSAL_sigla ) ;

CREATE TABLE PROVEDOR_PROD 
    ( 
     PROVEEDOR_rut_proveedor VARCHAR2 (10)  NOT NULL , 
     PRODUCTO_id_producto    VARCHAR2 (10)  NOT NULL , 
     PRODUCTO_SUCURSAL_sigla VARCHAR2 (6)  NOT NULL , 
     precio_proveedor        NUMBER (10,2)  NOT NULL , 
     stock_proveedor         NUMBER (4)  NOT NULL 
    ) 
;

ALTER TABLE PROVEDOR_PROD 
    ADD CONSTRAINT PROVEDOR_PROD_PK PRIMARY KEY ( PROVEEDOR_rut_proveedor, PRODUCTO_id_producto, PRODUCTO_SUCURSAL_sigla ) ;

CREATE TABLE PROVEEDOR 
    ( 
     rut_proveedor      VARCHAR2 (10)  NOT NULL , 
     dv_proveedor       VARCHAR2 (1)  NOT NULL , 
     telefono_proveedor VARCHAR2 (12)  NOT NULL , 
     direccion_nombre   VARCHAR2 (50)  NOT NULL , 
     direccion_numero   VARCHAR2 (5)  NOT NULL , 
     codigo_postal      VARCHAR2 (8) , 
     email_proveedor    VARCHAR2 (50) , 
     tipo_proveedor     VARCHAR2 (7)  NOT NULL , 
     primer_nombre      VARCHAR2 (20) , 
     segundo_nombre     VARCHAR2 (20) , 
     apellido_paterno   VARCHAR2 (20) , 
     apellido_materno   VARCHAR2 (20) , 
     nombre_empresa     VARCHAR2 (50) , 
     sitio_web          VARCHAR2 (50) 
    ) 
;

ALTER TABLE PROVEEDOR 
    ADD CONSTRAINT CH_INH_PROVEEDOR 
    CHECK (tipo_proveedor IN ('EMPRESA', 'PERSONA')) 
;


ALTER TABLE PROVEEDOR 
    ADD CONSTRAINT PROVEEDOR_ExDep 
    CHECK ( (tipo_proveedor = 'EMPRESA' AND primer_nombre IS NULL AND segundo_nombre IS NULL AND apellido_paterno IS NULL AND apellido_materno IS NULL AND nombre_empresa IS NOT NULL)
 OR (tipo_proveedor = 'PERSONA' AND primer_nombre IS NOT NULL AND apellido_paterno IS NOT NULL AND apellido_materno IS NOT NULL AND nombre_empresa IS NULL AND sitio_web IS NULL)) 
;

ALTER TABLE PROVEEDOR 
    ADD CONSTRAINT PROVEEDOR_PK PRIMARY KEY ( rut_proveedor ) ;

CREATE TABLE REGION 
    ( 
     id_region     VARCHAR2 (6)  NOT NULL , 
     nombre_region VARCHAR2 (30)  NOT NULL 
    ) 
;

ALTER TABLE REGION 
    ADD CONSTRAINT REGION_PK PRIMARY KEY ( id_region ) ;

CREATE TABLE SUCURSAL 
    ( 
     sigla              VARCHAR2 (6)  NOT NULL , 
     nombre_sucursal    VARCHAR2 (30)  NOT NULL , 
     direccion_sucursal VARCHAR2 (50)  NOT NULL , 
     COMUNA_id_comuna   VARCHAR2 (6)  NOT NULL 
    ) 
;

ALTER TABLE SUCURSAL 
    ADD CONSTRAINT SUCURSAL_PK PRIMARY KEY ( sigla ) ;

ALTER TABLE BOLETA 
    ADD CONSTRAINT BOLETA_CLIENTE_FK FOREIGN KEY 
    ( 
     CLIENTE_id_cliente
    ) 
    REFERENCES CLIENTE 
    ( 
     id_cliente
    ) 
;

ALTER TABLE CLIENTE 
    ADD CONSTRAINT CLIENTE_COMUNA_FK FOREIGN KEY 
    ( 
     COMUNA_id_comuna
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna
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

ALTER TABLE MODELO 
    ADD CONSTRAINT MODELO_MARCA_FK FOREIGN KEY 
    ( 
     MARCA_id_marca
    ) 
    REFERENCES MARCA 
    ( 
     id_marca
    ) 
;

ALTER TABLE PRODUCTO 
    ADD CONSTRAINT PRODUCTO_CATEGORIA_FK FOREIGN KEY 
    ( 
     CATEGORIA_id_categoria
    ) 
    REFERENCES CATEGORIA 
    ( 
     id_categoria
    ) 
;

ALTER TABLE PRODUCTO 
    ADD CONSTRAINT PRODUCTO_MODELO_FK FOREIGN KEY 
    ( 
     MODELO_id_modelo,
     MODELO_MARCA_id_marca
    ) 
    REFERENCES MODELO 
    ( 
     id_modelo,
     MARCA_id_marca
    ) 
;

ALTER TABLE PRODUCTO 
    ADD CONSTRAINT PRODUCTO_PROVEEDOR_FK FOREIGN KEY 
    ( 
     PROVEEDOR_rut_proveedor
    ) 
    REFERENCES PROVEEDOR 
    ( 
     rut_proveedor
    ) 
;

ALTER TABLE PRODUCTO 
    ADD CONSTRAINT PRODUCTO_SUCURSAL_FK FOREIGN KEY 
    ( 
     SUCURSAL_sigla
    ) 
    REFERENCES SUCURSAL 
    ( 
     sigla
    ) 
;

ALTER TABLE PROVEDOR_PROD 
    ADD CONSTRAINT PROVEDOR_PROD_PRODUCTO_FK FOREIGN KEY 
    ( 
     PRODUCTO_id_producto,
     PRODUCTO_SUCURSAL_sigla
    ) 
    REFERENCES PRODUCTO 
    ( 
     id_producto,
     SUCURSAL_sigla
    ) 
;

ALTER TABLE PROVEDOR_PROD 
    ADD CONSTRAINT PROVEDOR_PROD_PROVEEDOR_FK FOREIGN KEY 
    ( 
     PROVEEDOR_rut_proveedor
    ) 
    REFERENCES PROVEEDOR 
    ( 
     rut_proveedor
    ) 
;

ALTER TABLE DET_BOLETA 
    ADD CONSTRAINT Relation_8_BOLETA_FK FOREIGN KEY 
    ( 
     BOLETA_numero_boleta
    ) 
    REFERENCES BOLETA 
    ( 
     numero_boleta
    ) 
;

ALTER TABLE DET_BOLETA 
    ADD CONSTRAINT Relation_8_PRODUCTO_FK FOREIGN KEY 
    ( 
     PRODUCTO_id_producto,
     PRODUCTO_SUCURSAL_sigla
    ) 
    REFERENCES PRODUCTO 
    ( 
     id_producto,
     SUCURSAL_sigla
    ) 
;

ALTER TABLE SUCURSAL 
    ADD CONSTRAINT SUCURSAL_COMUNA_FK FOREIGN KEY 
    ( 
     COMUNA_id_comuna
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna
    ) 
;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            12
-- CREATE INDEX                             0
-- ALTER TABLE                             27
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
