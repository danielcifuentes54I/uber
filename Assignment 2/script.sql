/* 1. Vista llamada MEDIOS_PAGO_CLIENTES */

CREATE OR REPLACE VIEW MEDIOS_PAGO_CLIENTES AS
SELECT P.ID_PERSON AS CLIENTE_ID, P.FIRST_NAME || ' ' || P.LAST_NAME AS NOMBRE_CLIENTE, 
PM.ID_PAYMENT AS MEDIO_PAGO_ID, PM.DESCRIPTIONS AS TIPO, PP.DESCRIPTIONS AS DETALLES_MEDIO_PAGO,
(CASE WHEN PP.BUSINESS = 'true' THEN 'VERDADERO' ELSE 'FALSO' END) AS EMPRESARIAL,
(CASE WHEN PP.BUSINESS = 'false' THEN NULL ELSE PP.NAME_BUSINESS END) AS NOMBRE_EMPRESA
FROM PEOPLE P
INNER JOIN PAYMENT_PEOPLE PP ON P.ID_PERSON = PP.ID_PERSON
INNER JOIN PAYMENT_METHODS PM ON PP.ID_PAYMENT = PM.ID_PAYMENT;

/* 2. Vista llamada VIAJES_CLIENTES*/     

CREATE OR REPLACE VIEW VIAJES_CLIENTES AS
SELECT T.DATE_TRAVEL AS FECHA_VIAJE, P.FIRST_NAME || ' ' || P.LAST_NAME AS NOMBRE_CONDUCTOR, 
V.LICENSE_PLATE AS PLACA, PU.FIRST_NAME || ' ' || PU.LAST_NAME AS NOMBRE_CLIENTE, TD.TOTAL AS, 
(CASE WHEN T.TYPE_RATE = 'Dinamica' THEN 'VERDADERO' ELSE 'FALSO' END) AS TARIFA_DINAMICA,
V.VEHICLE_TYPE AS TIPO_SERVICIO, C.NAME_CITY AS CIUDAD_VIAJE
FROM TRAVELS T
INNER JOIN TRAVEL_DETAIL TD ON T.ID_TRAVEL = TD.ID_TRAVEL
INNER JOIN PEOPLE PU ON TD.ID_PERSON = PU.ID_PERSON
INNER JOIN VEHICLES_DRIVERS VD ON T.ID_VEHICLE_DRIVER = VD.ID_VEHICLE_DRIVER
INNER JOIN DRIVERS D ON D.ID_DRIVER = VD.ID_DRIVER
INNER JOIN VEHICLES V ON V.ID_VEHICLE = VD.ID_VEHICLE
INNER JOIN PEOPLE P ON P.ID_PERSON = D.ID_PERSON
INNER JOIN CITIES C ON P.ID_CITY = C.ID_CITY;

SELECT * FROM VEHICLES_DRIVERS;
SELECT * FROM TRAVELS WHERE ID_TRAVEL =1;
SELECT * FROM vehicles_drivers WHERE id_vehicle_driver = 1;
SELECT * FROM drivers WHERE id_driver = 1;
SELECT * FROM people WHERE ID_PERSON = 80;
SELECT* FROM travel_detail WHERE id_travel = 1;
SELECT * FROM PEOPLE WHERE id_person = 1;
SELECT * FROM TRAVELS;

/* 5) FUNCI�N VALOR_DISTANCIA*/
CREATE OR REPLACE FUNCTION VALOR_DISTANCIA (P_KILOMETROS IN NUMBER, P_CIUDAD IN VARCHAR2)
    RETURN NUMERIC AS 
    VALOR_DISTANCIA  NUMERIC := 0;
    V_TARIFA_KILOMETRO CITIES.TARIFA_KILOMETRO%TYPE;
    EXC_CIUDAD_NO_VALIDA EXCEPTION;
    EXC_KILOMETRO_NO_VALIDO EXCEPTION;
    
    BEGIN
        
        IF P_KILOMETROS < 0 THEN
            RAISE EXC_KILOMETRO_NO_VALIDO;
        END IF;
    
        BEGIN
            SELECT TARIFA_KILOMETRO INTO V_TARIFA_KILOMETRO
            FROM CITIES WHERE NAME_CITY = P_CIUDAD;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE EXC_CIUDAD_NO_VALIDA;
        END;
        
        VALOR_DISTANCIA := V_TARIFA_KILOMETRO*P_KILOMETROS;
        
        RETURN VALOR_DISTANCIA;
    EXCEPTION
        WHEN EXC_CIUDAD_NO_VALIDA THEN 
            RAISE_APPLICATION_ERROR(-20000,'CIUDAD NO VALIDA');
        WHEN EXC_KILOMETRO_NO_VALIDO THEN 
            RAISE_APPLICATION_ERROR(-20001,'KILOMETRO NO VALIDO');
    END;

SET SERVEROUT ON;
DECLARE 
    RESUL INTEGER;
BEGIN
    RESUL := VALOR_DISTANCIA(0,'Cartagena');
DBMS_OUTPUT.put_line('PRINT DESDE LA FUNCION: ' || RESUL);
END;

/* 6) FUNCI�N VALOR_TIEMPO*/
CREATE OR REPLACE FUNCTION VALOR_TIEMPO (P_MINUTOS IN NUMBER, P_CIUDAD IN VARCHAR2)
    RETURN NUMERIC AS 
    VALOR_DISTANCIA  NUMERIC := 0;
    V_TARIFA_MINUTOS CITIES.TARIFA_MINUTOS%TYPE;
    EXC_CIUDAD_NO_VALIDA EXCEPTION;
    EXC_MINUTO_NO_VALIDO EXCEPTION;
    
    BEGIN
        
        IF P_MINUTOS < 0 THEN
            RAISE EXC_MINUTO_NO_VALIDO;
        END IF;
    
        BEGIN
            SELECT TARIFA_MINUTOS INTO V_TARIFA_MINUTOS
            FROM CITIES WHERE NAME_CITY = P_CIUDAD;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE EXC_CIUDAD_NO_VALIDA;
        END;
        
        VALOR_DISTANCIA := V_TARIFA_MINUTOS*P_MINUTOS;
        
        RETURN VALOR_DISTANCIA;
    EXCEPTION
        WHEN EXC_CIUDAD_NO_VALIDA THEN 
            RAISE_APPLICATION_ERROR(-20000,'CIUDAD NO VALIDA');
        WHEN EXC_MINUTO_NO_VALIDO THEN 
            RAISE_APPLICATION_ERROR(-20002,'MINUTO NO VALIDO');
    END;


SET SERVEROUT ON;
DECLARE 
    RESUL INTEGER;
BEGIN
    RESUL := VALOR_DISTANCIA(0,'Cartagena');
DBMS_OUTPUT.put_line('PRINT DESDE LA FUNCION: ' || RESUL);
END;
