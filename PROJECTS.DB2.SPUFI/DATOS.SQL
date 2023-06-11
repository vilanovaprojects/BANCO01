-- *****************************     
-- ELIMINAR CONTENIDO                
-- *****************************     
-- DELETE FROM CONTRATO;             
-- DELETE FROM ESTADO;               
-- COMMIT;                           
                                     
-- *****************************     
-- TABLA DE ESTADOS                  
-- *****************************     
   INSERT INTO ESTADO                
   VALUES ('V', 'VIGENTE');          
   INSERT INTO ESTADO                
   VALUES ('C', 'CANCELADO');        
   COMMIT;                           
                                     
-- *****************************     
-- TABLA DE CONTRATO                 
-- *****************************     
INSERT INTO CONTRATO                 
VALUES (1, 'CONTRATO 1', 50000, 'V');
INSERT INTO CONTRATO                 
VALUES (2, 'CONTRATO 2', 50000, 'V');
INSERT INTO CONTRATO                 
VALUES (3, 'CONTRATO 3', 50000, 'V');
INSERT INTO CONTRATO                 
VALUES (4, 'CONTRATO 4', 50000, 'V');
INSERT INTO CONTRATO                 
VALUES (5, 'CONTRATO 5', 50000, 'V');
INSERT INTO CONTRATO                 
VALUES (6, 'CONTRATO 6', 50000, 'V');
INSERT INTO CONTRATO                 
VALUES (7, 'CONTRATO 7', 50000, 'V');
INSERT INTO CONTRATO                 
VALUES (8, 'CONTRATO 8', 50000, 'V');
INSERT INTO CONTRATO                 
VALUES (9, 'CONTRATO 9', 50000, 'V');  
INSERT INTO CONTRATO                   
VALUES (10, 'CONTRATO 10', 0, 'C');    
INSERT INTO CONTRATO                   
VALUES (11, 'CONTRATO 11', 50000, 'V');
INSERT INTO CONTRATO                   
VALUES (12, 'CONTRATO 12', 50000, 'V');
INSERT INTO CONTRATO                   
VALUES (13, 'CONTRATO 13', 50000, 'V');
INSERT INTO CONTRATO                   
VALUES (14, 'CONTRATO 14', 50000, 'V');
INSERT INTO CONTRATO                   
VALUES (15, 'CONTRATO 15', 50000, 'V');
INSERT INTO CONTRATO                   
VALUES (16, 'CONTRATO 16', 50000, 'V');
INSERT INTO CONTRATO                   
VALUES (17, 'CONTRATO 17', 50000, 'V');
INSERT INTO CONTRATO                   
VALUES (18, 'CONTRATO 18', 50000, 'V');
INSERT INTO CONTRATO                   
VALUES (19, 'CONTRATO 19', 50000, 'V');
INSERT INTO CONTRATO                   
VALUES (20, 'CONTRATO 20', 50000, 'V');
COMMIT;                                