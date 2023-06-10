      ******************************************************************
      * DCLGEN TABLE(IBMUSER.CONTRATO)                                 *
      *        LIBRARY(PROJECTS.DB2.DCLGEN(CONTRATO))                  *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        QUOTE                                                   *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE IBMUSER.CONTRATO TABLE                      
           ( CLAVE_CONTRATO                 INTEGER NOT NULL,           
             DESCRIPCION                    CHAR(50) NOT NULL,          
             IMPORTE                        DECIMAL(13, 2) NOT NULL,    
             ESTADO                         CHAR(1) NOT NULL            
           ) END-EXEC.                                                  
      ******************************************************************
      * COBOL DECLARATION FOR TABLE IBMUSER.CONTRATO                   *
      ******************************************************************
       01  DCLCONTRATO.                                                 
           10 CLAVE-CONTRATO       PIC S9(9) USAGE COMP.                
           10 DESCRIPCION          PIC X(50).                           
           10 IMPORTE              PIC S9(11)V9(2) USAGE COMP-3.        
           10 ESTADO               PIC X(1).                            
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 4       *
      ******************************************************************