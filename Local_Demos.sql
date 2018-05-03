--TABLE CREATION

CREATE TABLE BEAR (
    BEAR_ID INTEGER PRIMARY KEY,
    BEAR_NAME VARCHAR2(100),
    BEAR_BIRTHDATE DATE,
    BEAR_WEIGHT NUMBER(5,2) DEFAULT 200.00,
    BEAR_TYPE_ID INTEGER NOT NULL,
    CAVE_ID INTEGER
);
/
CREATE TABLE BEAR_TYPE (
    BEAR_TYPE_ID INTEGER PRIMARY KEY,
    BEAR_TYPE_NAME VARCHAR2(100)
);
/
CREATE TABLE CAVE (
    CAVE_ID INTEGER PRIMARY KEY,
    CAVE_NAME VARCHAR2(100),
    MAX_BEARS INTEGER DEFAULT 4
);
/
CREATE TABLE BEEHIVE (
    BEEHIVE_ID INTEGER PRIMARY KEY,
    BEEHIVE_WEIGHT NUMBER(5,2) DEFAULT 75.00
);
/
CREATE TABLE BEAR_BEEHIVE (
    BEAR_ID INTEGER,
    BEEHIVE_ID INTEGER,
    PRIMARY KEY (BEAR_ID, BEEHIVE_ID)
);
/

--FOREIGN KEY CONSTRAINTS 

ALTER TABLE BEAR
ADD CONSTRAINT FK_BEAR_BEAR_TYPE
FOREIGN KEY (BEAR_TYPE_ID) REFERENCES BEAR_TYPE(BEAR_TYPE_ID);
/

ALTER TABLE BEAR
ADD CONSTRAINT FK_BEAR_CAVE
FOREIGN KEY (CAVE_ID) REFERENCES CAVE(CAVE_ID);
/

ALTER TABLE BEAR_BEEHIVE 
ADD CONSTRAINT FK_BEAR_BEAR_BEEHIVE 
FOREIGN KEY (BEAR_ID) REFERENCES BEAR(BEAR_ID);
/

ALTER TABLE BEAR_BEEHIVE 
ADD CONSTRAINT FK_BEEHIVE_BEAR_BEEHIVE 
FOREIGN KEY (BEEHIVE_ID) REFERENCES BEEHIVE(BEEHIVE_ID);
/

--ADD SOME DATA

INSERT INTO BEAR_TYPE VALUES (1,'Grizzly'); 
INSERT INTO BEAR_TYPE(BEAR_TYPE_ID,BEAR_TYPE_NAME) VALUES (2,'Polar');

INSERT ALL 
INTO CAVE 
VALUES (1,'AWESOMECAVE1',9)
INTO CAVE(CAVE_ID, CAVE_NAME)
VALUES (2,'AWESOMECAVE2')
SELECT * FROM DUAL;

INSERT ALL 
INTO BEAR(BEAR_ID, BEAR_NAME, BEAR_BIRTHDATE, BEAR_TYPE_ID, CAVE_ID)
VALUES (3, 'Ferdinand', TO_DATE('1987-08-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), 1, 2)
INTO BEAR(BEAR_ID, BEAR_NAME, BEAR_BIRTHDATE, BEAR_TYPE_ID, CAVE_ID)
VALUES (8, 'Ernest', TO_DATE('1989-08-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), 1, 1)
INTO BEAR
VALUES (9, 'Elon', TO_DATE('2000-02-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), 400.00, 2, 1)
INTO BEAR
VALUES (10, 'Jeff', TO_DATE('1597-02-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), 450.00, 2, 1)
SELECT * FROM DUAL;

INSERT ALL 
INTO BEEHIVE
VALUES (1,30)
INTO BEEHIVE(BEEHIVE_ID)
VALUES (2)
SELECT * FROM DUAL;

INSERT ALL 
INTO BEAR_BEEHIVE
VALUES (3,1)
INTO BEAR_BEEHIVE
VALUES (3,2)
INTO BEAR_BEEHIVE
VALUES (10,1)
INTO BEAR_BEEHIVE
VALUES (9,1)
SELECT * FROM DUAL;
/

--ALTER TABLE 

ALTER TABLE BEAR_TYPE 
ADD SURVIVAL_PROCEDURE VARCHAR2(200);
/

--ADD SOME NEW VALUES FOR ALTERED COLUMN

UPDATE BEAR_TYPE 
SET SURVIVAL_PROCEDURE = 'play dead'
WHERE BEAR_TYPE_ID = 1;
/

UPDATE BEAR_TYPE
SET SURVIVAL_PROCEDURE = 'lol none'
WHERE BEAR_TYPE_ID = 2;
/

--JOIN BEARS
INSERT INTO BEAR
VALUES(92, 'Stacy', TO_DATE('2000-02-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), 300.00, 2, null);

SELECT *--BEAR.BEAR_NAME, CAVE.CAVE_NAME 
FROM BEAR B
FULL OUTER JOIN CAVE ON B.CAVE_ID = CAVE.CAVE_ID; --ALIAS BEAR TABLE 

--CREATE SEQUENCES AND TRIGGERS TO PROVIDE PRIMARY KEY VALUES

CREATE SEQUENCE SQ_BEAR_PK
START WITH 93 
INCREMENT BY 1;
/

CREATE SEQUENCE SQ_CAVE_PK
START WITH 3 
INCREMENT BY 1;
/

CREATE SEQUENCE SQ_BEAR_TYPE_PK
START WITH 3 
INCREMENT BY 1;
/

CREATE SEQUENCE SQ_BEEHIVE_PK
START WITH 3 
INCREMENT BY 1;
/

CREATE OR REPLACE TRIGGER TR_INSERT_BEAR
BEFORE INSERT ON BEAR
FOR EACH ROW
BEGIN
    SELECT SQ_BEAR_PK.NEXTVAL INTO :NEW.BEAR_ID FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER TR_INSERT_CAVE
BEFORE INSERT ON CAVE
FOR EACH ROW
BEGIN
    SELECT SQ_CAVE_PK.NEXTVAL INTO :NEW.CAVE_ID FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER TR_INSERT_BEAR_TYPE
BEFORE INSERT ON BEAR_TYPE
FOR EACH ROW
BEGIN
    SELECT SQ_BEAR_TYPE_PK.NEXTVAL INTO :NEW.BEAR_TYPE_ID FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER TR_INSERT_BEEHIVE
BEFORE INSERT ON BEEHIVE
FOR EACH ROW
BEGIN
    SELECT SQ_BEEHIVE_PK.NEXTVAL INTO :NEW.BEEHIVE_ID FROM DUAL;
END;
/

--USE TRIGGERS TO GENERATE PRIMARY KEYS...
INSERT INTO BEAR(BEAR_NAME, BEAR_BIRTHDATE, BEAR_WEIGHT, BEAR_TYPE_ID, CAVE_ID)  
VALUES ('Stacy2', TO_DATE('2000-02-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), DEFAULT, 2, 2);

--ADD A CHECK CONSTRAINT ON BEAR_WEIGHT AND BEEHIVE_WEIGHT 

ALTER TABLE BEAR ADD CONSTRAINT CK_BEAR_WEIGHT_POSITIVE 
CHECK (BEAR_WEIGHT > 0);

ALTER TABLE BEEHIVE ADD CONSTRAINT CK_BEEHIVE_WEIGHT_POSITIVE 
CHECK (BEEHIVE_WEIGHT > 0);

--ADD A UNIQUE CONSTRAINT ON BEAR_NAME

ALTER TABLE BEAR ADD CONSTRAINT UQ_BEAR_NAME
UNIQUE (BEAR_NAME);

--VIEWS

--HOW MANY BEARS PER CAVE? 
--NOTE: THIS USES A SYSTEM-DEFINED AGGREGATE FUNCTION 'COUNT'
--UNDERSTAND THE DIFFERENCE BETWEEN SCALAR AND AGGREGATE FUNCTIONS 
CREATE VIEW VW_BEARS_PER_CAVE(CAVE,NUMBEAR)
AS 
SELECT CAVE_NAME, COUNT(BEAR_ID)
FROM BEAR, CAVE
WHERE BEAR.CAVE_ID = CAVE.CAVE_ID
GROUP BY CAVE_NAME;

SELECT * FROM VW_BEARS_PER_CAVE;

--FUNCTIONS

--SOME JAVA-LIKE FUNCTIONALITY
CREATE OR REPLACE FUNCTION FIND_MAX_NUMBER( X IN NUMBER, Y IN NUMBER)
RETURN NUMBER
IS 
Z NUMBER;
BEGIN 
    IF X>Y THEN 
    Z := X; --PL/SQL ASSIGNMENT OPERATOR
    ELSE
    Z := Y;
    END IF;
    RETURN Z;
END;

DECLARE 
FIRST_NUM NUMBER;
SECOND_NUM NUMBER;
MAX_NUM NUMBER;
BEGIN
    FIRST_NUM := 22;
    SECOND_NUM := 42;
    MAX_NUM := FIND_MAX_NUMBER(FIRST_NUM, SECOND_NUM);
    DBMS_OUTPUT.PUT_LINE('MAX: '||MAX_NUM);
END;

--STORED PROCEDURES

--SP WITH A INVOCATION FEATURE CURSOR AND LOOPING 
CREATE OR REPLACE PROCEDURE GET_ALL_BEARS( S OUT SYS_REFCURSOR)
IS 
BEGIN
OPEN S FOR 
SELECT BEAR_ID, BEAR_NAME FROM BEAR;
END;

DECLARE 
S SYS_REFCURSOR ;
SOME_ID BEAR.BEAR_ID%TYPE; --SET SOME_ID AS WHATEVER DATATYPE BEAR_ID IS
SOME_NAME BEAR.BEAR_NAME%TYPE;
BEGIN
    GET_ALL_BEARS(S);
    LOOP
        FETCH S INTO SOME_ID, SOME_NAME;
        EXIT WHEN S%NOTFOUND; --BREAK OUT OF LOOP WHEN NO MORE ROWS ARE AVAILABLE 
        DBMS_OUTPUT.PUT_LINE(SOME_ID||' IS CURRENT ID, '||SOME_NAME||' IS CURRENT NAME');
    END LOOP;
    CLOSE S;
END;


--FEED THE BEAR! 
CREATE OR REPLACE PROCEDURE SP_FEED_BEAR(B_ID IN NUMBER, H_ID IN NUMBER, 
HONEY_AMT IN NUMBER)
IS 
BB_EXISTS INTEGER;
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    --CHECK THAT THIS BEAR IS MATCHED WITH THIS BEEHIVE 
    SELECT COUNT(BB.BEAR_ID) INTO BB_EXISTS FROM BEAR_BEEHIVE BB
        WHERE BB.BEAR_ID = B_ID
        AND BB.BEEHIVE_ID = H_ID;
    DBMS_OUTPUT.PUT_LINE(BB_EXISTS);
    IF BB_EXISTS > 0 THEN
        --DECREASE BEEHIVE WEIGHT
        UPDATE BEEHIVE 
        SET BEEHIVE_WEIGHT = BEEHIVE_WEIGHT-HONEY_AMT
        WHERE BEEHIVE_ID = H_ID;
        --INCREASE BEAR WEIGHT
        UPDATE BEAR 
        SET BEAR_WEIGHT = BEAR_WEIGHT + HONEY_AMT 
        WHERE BEAR_ID = B_ID;
        DBMS_OUTPUT.PUT_LINE('FED BEAR '||HONEY_AMT||' POUNDS OF HONEY');
    ELSE 
    DBMS_OUTPUT.PUT_LINE('FAILED TO FEED BEAR');
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('FAILED TO FEED BEAR');
    --https://docs.oracle.com/cd/B10501_01/appdev.920/a96624/07_errs.htm 
    ROLLBACK;
END;

BEGIN
SP_FEED_BEAR(3,2,5);
END;






