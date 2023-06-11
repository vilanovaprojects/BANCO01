-- *************************************************************
-- BORRADO DE LAS TABLAS PARA VOLVER A CREARLAS                 
-- *************************************************************
   DROP TABLE IBMUSER.CONTRATO;                                 
   DROP TABLE IBMUSER.MOVIMIENTO;                               
   DROP TABLE IBMUSER.ESTADO;                                   
   COMMIT;                                                      
                                                                
-- ***************************                                  
-- TABLA DE ESTADO                                              
-- ***************************                                  
CREATE TABLE ESTADO(                                            
  CLAVE_ESTADO      CHAR(1)       NOT NULL,                     
  DESCRIPCION       CHAR(50)      NOT NULL,                     
  PRIMARY KEY (CLAVE_ESTADO));                                  
COMMIT;                                                         
                                                                
-- INDICE                                                       
CREATE UNIQUE INDEX ESTADO_IX ON ESTADO                         
  (CLAVE_ESTADO)                                                
  CLUSTER;                                                      
COMMIT;                                                         
                                                                
-- ***************************                                  
-- TABLA DE CONTRATO                                            
-- ***************************                                  
CREATE TABLE CONTRATO(                                          
  CLAVE_CONTRATO    INTEGER         NOT NULL,                   
  DESCRIPCION       CHAR(50)        NOT NULL,                   
  IMPORTE           DECIMAL(13,2)   NOT NULL WITH DEFAULT 0,    
  ESTADO            CHAR(1)        NOT NULL,                    
  PRIMARY KEY (CLAVE_CONTRATO),                                 
 FOREIGN KEY (ESTADO) REFERENCES ESTADO(CLAVE_ESTADO)           
 );                                                             
COMMIT;                                                         
                                                            
-- INDICE                                                   
CREATE UNIQUE INDEX CONTRATO_IX ON CONTRATO                 
  (CLAVE_CONTRATO)                                          
  CLUSTER;                                                  
COMMIT;                                                     
                                                            
-- ***************************                              
-- TABLA DE MOVIMIENTO                                      
-- ***************************                              
CREATE TABLE MOVIMIENTO(                                    
  CLAVE_MOVIMIENTO  INTEGER         NOT NULL,               
  ORIGEN            INTEGER         ,                       
  DESTINO           INTEGER         ,                       
  DESCRIPCION       CHAR(50)        NOT NULL,               
  IMPORTE           DECIMAL(13,2)   NOT NULL WITH DEFAULT 0,
  PRIMARY KEY (CLAVE_MOVIMIENTO),                           
  FOREIGN KEY (ORIGEN) REFERENCES CONTRATO(CLAVE_CONTRATO), 
  FOREIGN KEY (DESTINO) REFERENCES CONTRATO(CLAVE_CONTRATO) 
  );                                                        
COMMIT;                                                     
                                                            
-- INDICE                                                   
CREATE UNIQUE INDEX MOVIMIENTO_IX ON MOVIMIENTO             
  (CLAVE_MOVIMIENTO)                                        
  CLUSTER;                                                  
COMMIT;                                                     
                                                            
-- INDICE                                                   
CREATE INDEX MOVIMIENTO_IX_2 ON MOVIMIENTO                  
  (ORIGEN);                                                 
COMMIT;                                                     
                                                            
-- INDICE                                                   
CREATE INDEX MOVIMIENTO_IX_3 ON MOVIMIENTO                  
  (DESTINO);                                              
COMMIT;        