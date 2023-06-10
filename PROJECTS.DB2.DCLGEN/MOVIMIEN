      ******************************************************************
      * DCLGEN TABLE(IBMUSER.MOVIMIENTO)                               *
      *        LIBRARY(PROJECTS.DB2.DCLGEN(MOVIMIEN))                  *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        QUOTE                                                   *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE IBMUSER.MOVIMIENTO TABLE                    
           ( CLAVE_MOVIMIENTO               INTEGER NOT NULL,           
             ORIGEN                         INTEGER,                    
             DESTINO                        INTEGER,                    
             DESCRIPCION                    CHAR(50) NOT NULL,          
             IMPORTE                        DECIMAL(13, 2) NOT NULL     
           ) END-EXEC.                                                  
      ******************************************************************
      * COBOL DECLARATION FOR TABLE IBMUSER.MOVIMIENTO                 *
      ******************************************************************
       01  DCLMOVIMIENTO.                                               
           10 CLAVE-MOVIMIENTO     PIC S9(9) USAGE COMP.                
           10 ORIGEN               PIC S9(9) USAGE COMP.                
           10 DESTINO              PIC S9(9) USAGE COMP.                
           10 DESCRIPCION          PIC X(50).                           
           10 IMPORTE              PIC S9(11)V9(2) USAGE COMP-3.        
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 5       *
      ******************************************************************