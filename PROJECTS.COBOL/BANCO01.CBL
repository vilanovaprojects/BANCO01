000010* PROGRAMA QUE LEE UNA LISTA DE MOVIMIENTOS DE UN FICHERO         
000020* SECUENCIAL Y LOS ALMACENA EN UNA TABLA                          
000100 IDENTIFICATION DIVISION.                                         
000200 PROGRAM-ID.BANCO01.                                              
000210                                                                  
000300 ENVIRONMENT DIVISION.                                            
000400 INPUT-OUTPUT SECTION.                                            
000500 FILE-CONTROL.                                                    
000510                                                                  
000520* FICHERO DE ENTRADA DE MOVIMIENTOS                               
000600     SELECT FICHERO-ENT ASSIGN TO ENTRADA                         
000700     ORGANIZATION IS SEQUENTIAL                                   
000800     ACCESS IS SEQUENTIAL                                         
000900     FILE STATUS IS FS-ENTRADA.                                   
001810                                                                  
001820* FICHERO DE SALIDA DE INCIDENCIAS                                
001831     SELECT FICHERO-SAL ASSIGN TO SALIDA                          
001832     ORGANIZATION IS SEQUENTIAL                                   
001833     ACCESS IS SEQUENTIAL                                         
001834     FILE STATUS IS FS-SALIDA.                                    
001893                                                                  
001900 DATA DIVISION.                                                   
002000 FILE SECTION.                                                    
002010                                                                  
002020* REGISTRO DEL FICHERO DE ENTRADA                                 
002100 FD FICHERO-ENT DATA RECORD IS REG-ENTRADA.                       
002300 01 REG-ENTRADA    PIC X(81).                                     
002400                                                                  
002410* REGISTRO DEL FICHERO DE SALIDA                                  
002420 FD FICHERO-SAL DATA RECORD IS REG-SALIDA.                        
002430 01 REG-SALIDA     PIC X(80).                                     
002500                                                                  
003200 WORKING-STORAGE SECTION.                                         
003210                                                                  
003220* CAMPOS DE ENTRADA                                               
003300 01 WS-ENTRADA.                                                   
003400     05 WS-E-CONT-ORIGEN   PIC 9(9).                              
003500     05 WS-E-CONT-DESTINO  PIC 9(9).                              
003510     05 WS-E-IMPORTE       PIC 9(11)V9(2).                        
003520     05 WS-E-DESCRIPCION   PIC X(50).                             
003521                                                                  
003530* CAMPOS DE SALIDA                                                
003540 01 WS-SALIDA.                                                    
003550     05 WS-S-SQLCODE       PIC -999.                              
003560     05 WS-S-DESCRIPCION   PIC X(76).                             
003600                                                                  
004210* FILESTATUS DEL FICHERO DE ENTRADA                               
004211 01 FS-ENTRADA           PIC 99.                                  
004212     88 FICHERO-ENT-FIN  VALUE 10.                                
004213                                                                  
004214* FILESTATUS DEL FICHERO DE SALIDA.                               
004215 01 FS-SALIDA            PIC 99.                                  
004217                                                                  
004218* VARIABLES UTILIZADAS EN EL PROGRAMA                             
004219 01 WS-COMMIT            PIC 99.                                  
004220 01 WS-NUEVA-OPERACION   PIC 9(9).                                
004221 01 IND-NULL             PIC S9(4) COMP.                          
004222 01 WS-ERROR             PIC X.                                   
004223     88 WS-ERROR-SI      VALUE 'S'.                               
004224     88 WS-ERROR-NO      VALUE 'N'.                               
004226                                                                  
004227* SQLCA Y DCLGE DE LA TABLA                                       
004230     EXEC SQL INCLUDE SQLCA END-EXEC.                             
004240     EXEC SQL INCLUDE MOVIMIEN END-EXEC,                          
004241     EXEC SQL INCLUDE CONTRATO END-EXEC,                          
004301                                                                  
004310 PROCEDURE DIVISION.                                              
004400     PERFORM 1000-INICIO.                                         
004500     PERFORM 2000-PROCESO UNTIL FICHERO-ENT-FIN.                  
004600     PERFORM 3000-FIN.                                            
004610                                                                  
004620* **********************************************************      
004630* PARRAFO DE INICIO                                               
004640* **********************************************************      
004700 1000-INICIO.                                                     
004710                                                                  
004720     DISPLAY 'INICIO'.                                            
004730                                                                  
004740     MOVE 0 TO WS-COMMIT.                                         
004750                                                                  
004760* APERTURA DE FICHEROS DE ENTRADA Y SALIDA                        
004770     OPEN INPUT  FICHERO-ENT.                                     
004800     OPEN OUTPUT FICHERO-SAL.                                     
004810                                                                  
004820* PRIMERA LECTURA DEL FICHERO DE ENTRADA                          
004830     READ FICHERO-ENT INTO WS-ENTRADA.                            
004840                                                                  
004850* CALCULAMOS EL NUMERO DEL PRIMER MOVIMIENTO                      
004860     PERFORM 1200-CALCULA-NUEVO-MOVIMIENTO.                       
004870                                                                  
004880* *********************************************************       
004890* CALCULAMOS EL ID DEL MOVIMIENTO, RECUPERANDO EL                 
004891* MAYOR DE LOS ALMACENADOS EN LA TABLA DE MOVIMIENTO Y            
004892* SUMANDOLE 1 O PONIENDOLO DIRECTAMENTE A 1 SI EN LA TALBA        
004893* NO HAY NINGUNO                                                  
004894* *********************************************************       
004895 1200-CALCULA-NUEVO-MOVIMIENTO.                                   
004896                                                                  
004897     DISPLAY 'CALCULA NUEVO MOVIMIENTO'.                          
004898                                                                  
004900     EXEC SQL                                                     
005000        SELECT MAX(CLAVE_MOVIMIENTO)                              
005010        INTO :CLAVE-MOVIMIENTO:IND-NULL                           
005020        FROM IBMUSER.MOVIMIENTO                                   
005040     END-EXEC.                                                    
005041                                                                  
005050* SI SE PRODUCE ALGUN ERROR, SALIMOS DEL PROGRAMA                 
005060     IF SQLCODE NOT EQUAL 0                                       
005070       MOVE SQLCODE                       TO WS-S-SQLCODE         
005080       MOVE 'ERROR AL RECUPERAR CLAVE '   TO WS-S-DESCRIPCION     
005090                                                                  
005100       MOVE WS-SALIDA                     TO REG-SALIDA           
005101       WRITE REG-SALIDA                                           
005102       PERFORM 9999-ERROR                                         
005103     END-IF.                                                      
005110                                                                  
005120* SI IND-NULL ES -1 ES PORQUE NO HABIA MOVIMIENTO EN LA           
005130* TABLA, PONEMOS EL NUMERO DE MOVIMIENTO A 1                      
005140     IF IND-NULL EQUAL -1                                         
005150       MOVE 1                             TO CLAVE-MOVIMIENTO     
005160     ELSE                                                         
005170* INCREMENTAMOS LA CLAVE DEL MOVIMIENTO                           
005180       PERFORM 2400-INCREMENTA-CLAVE-MOV                          
005190     END-IF.                                                      
005191                                                                  
005192* ************************************************************    
005200 2000-PROCESO.                                                    
005210* ************************************************************    
005220     DISPLAY 'PROCEDO'.                                           
005230                                                                  
005240     ADD 1                 TO WS-COMMIT.                          
005250     MOVE 'N'              TO WS-ERROR.                           
005260                                                                  
005270* COMPROBAMOS QUE EL CONTRATO DESTINO ES CORRECTO.                
005280     PERFORM 2200-COMPRUEBA-CONTRATO-DES.                         
005290                                                                  
005291* COMPROBAMOS QUE EL CONTRATO ORIGEN ES CORRECTO.                 
005292     IF WS-ERROR-NO                                               
005293         PERFORM 2300-COMPRUEBA-CONTRATO-ORI.                     
005294                                                                  
005295* ACTUALIZAMOS EL IMPORTE DE LOS CONTRATOS                        
005296     IF WS-ERROR-NO                                               
005297         PERFORM 2500-ACTUALIZA-IMPORTE-CONT.                     
005298                                                                  
005299* INSERTAMOS EL REGISTRO EN LA TABLA DE MOVIMIENTOS               
005300     IF WS-ERROR-NO                                               
005301         PERFORM 2700-INSERTA-MOVIMIENTO.                         
005302                                                                  
005303* INCREMENTAMOS LA CLAVE DEL MOVIMIENTO                           
005304     IF WS-ERROR-NO                                               
005305     PERFORM 2400-INCREMENTA-CLAVE-MOV.                           
005306                                                                  
005307* SIGUIENTE LECTURA DEL FICHERO DE ENTRADA                        
005308     READ FICHERO-ENT INTO WS-ENTRADA.                            
005309                                                                  
005310     IF WS-COMMIT EQUAL 10                                        
005311        MOVE 0 TO WS-COMMIT                                       
005312        EXEC SQL COMMIT END-EXEC                                  
005313     END-IF.                                                      
005314                                                                  
005315* ********************************************************        
005316* COMPRUEBA QUE EL CONTRATO DESTINO ESTA VIGENTE                  
005317* ********************************************************        
005318 2200-COMPRUEBA-CONTRATO-DES.                                     
005319                                                                  
005320     DISPLAY 'COMPROBAMOS ESTADO CONTRATO DESTINO'.               
005321                                                                  
005322* RECUPERAMOS EL IMPORTE DEL CONTRATO ORIGEN DEL MOVIMIENTO       
005323     MOVE WS-E-CONT-DESTINO     TO CLAVE-CONTRATO OF DCLCONTRATO. 
005324                                                                  
005325     EXEC SQL                                                     
005326        SELECT  ESTADO                                            
005327          INTO :DCLCONTRATO.ESTADO                                
005328          FROM  IBMUSER.CONTRATO                                  
005329         WHERE  CLAVE_CONTRATO = :DCLCONTRATO.CLAVE-CONTRATO      
005330     END-EXEC.                                                    
005331                                                                  
005332* EN CASO DE ERROR SALIMOS DEL PROGRAMA                           
005333     IF SQLCODE NOT EQUAL 0                                       
005334       MOVE SQLCODE                      TO WS-S-SQLCODE          
005335       MOVE 'ERROR AL RECUPERAR ESTADO DESTINO'                   
005336                                         TO WS-S-DESCRIPCION      
005337                                                                  
005338       MOVE WS-SALIDA                    TO REG-SALIDA            
005339       WRITE REG-SALIDA                                           
005340       PERFORM 9999-ERROR                                         
005341     END-IF.                                                      
005342       IF ESTADO OF DCLCONTRATO NOT EQUAL 'V'                     
005343         MOVE 0                             TO WS-S-SQLCODE       
005344         MOVE 'CONTRATO DESTINO NO OPERATIVO. MOVIMIENTO ERRONEO' 
005345                                            TO WS-S-DESCRIPCION   
005346                                                                  
005376                                                                  
005377         MOVE WS-SALIDA                     TO REG-SALIDA         
005378         WRITE REG-SALIDA                                         
005379                                                                  
005380         MOVE 'S'                           TO WS-ERROR           
005381     END-IF.                                                      
005382                                                                  
005383* *************************************************************** 
005384* COMPRUEBA QUE EL CONTRATO ORIGEN PUEDE SOPORTAR EL MOVIMIENTO   
005385* CONTROLANDO QUE EL ESTADO SEA ABIERTO Y QUE EL IMPORTE FINAL    
005386* ES MAYOR QUE CERO                                               
005387* *************************************************************** 
005388 2300-COMPRUEBA-CONTRATO-ORI.                                     
005389                                                                  
005390     DISPLAY 'RECUPERAMOS ESTADO/IMPORTE CONTRATO ORIGEN'         
005391             WS-E-CONT-ORIGEN.                                    
005392                                                                  
005393* RECUPERAMOS EL IMPORTE DEL CONTRATO ORIGEN DEL MOVIMIENTO       
005394     MOVE WS-E-CONT-ORIGEN TO CLAVE-CONTRATO OF DCLCONTRATO.      
005395                                                                  
005396     EXEC SQL                                                     
005397        SELECT  IMPORTE, ESTADO                                   
005398          INTO :DCLCONTRATO.IMPORTE, :DCLCONTRATO.ESTADO          
005399          FROM  IBMUSER.CONTRATO                                  
005400         WHERE  CLAVE_CONTRATO = :DCLCONTRATO.CLAVE-CONTRATO      
005401     END-EXEC.                                                    
005402                                                                  
005403* DISPLAY 'PROCESO'    IMOS DEL PROGRAMA                          
005404     IF SQLCODE NOT EQUAL 0                                       
005405       MOVE SQLCODE                         TO WS-S-SQLCODE       
005406       MOVE 'ERROR AL RECUPERAR IMPORTE ORIGEN'                   
005407                                            TO WS-S-DESCRIPCION   
005408                                                                  
005409       MOVE WS-SALIDA                       TO REG-SALIDA         
005410       WRITE REG-SALIDA                                           
005411       PERFORM 9999-ERROR                                         
005412     END-IF.                                                      
005413                                                                  
005414     DISPLAY 'CALCULAMOS EL NUEVO IMPORTE'.                       
005415                                                                  
005416* CALCULAMOS EL NUEVO IMPORTE DEL CONTRATO, RESTANDOLE AL INICIAL 
005417* EL IMPORTE DEL MOVIMIENTO                                       
005418     COMPUTE IMPORTE OF DCLCONTRATO = IMPORTE OF DCLCONTRATO -    
005419             WS-E-IMPORTE.                                        
005420                                                                  
005421* EN CASO DE QUE EL IMPORTE CALCULADO SEA MENOR QUE CERO,         
005422* NO PODEMOS CONTINUAR, PORQUE UN CONTRATO NO PUEDE QUEDAR        
005423* AL DESCUBIERTO.                                                 
005424     IF ESTADO OF DCLCONTRATO NOT EQUAL 'V'                       
005425       MOVE 0                             TO WS-S-SQLCODE         
005426       MOVE 'CONTRATO ORIGEN NO OPERATIVO. MOVIMIENTO ERRONEO'    
005427                                          TO WS-S-DESCRIPCION     
005432                                                                  
005433       MOVE WS-SALIDA                     TO REG-SALIDA           
005434       WRITE REG-SALIDA                                           
005435                                                                  
005436       MOVE 'S'                           TO WS-ERROR             
005437     ELSE                                                         
005438       IF IMPORTE OF DCLCONTRATO LESS THAN ZERO                   
005439         MOVE 0                             TO WS-S-SQLCODE       
005440         MOVE 'CONTRATO ORIGEN AL DESCUBIERTO.MOVIMIENTO ERRONEO' 
005441                                            TO WS-S-DESCRIPCION   
005442                                                                  
005443         MOVE WS-SALIDA                     TO REG-SALIDA         
005444         WRITE REG-SALIDA                                         
005445                                                                  
005446         MOVE 'S'                           TO WS-ERROR           
005447       END-IF                                                     
005448     END-IF.                                                      
005449                                                                  
005450* *************************************************************** 
005451* ACTUALIZAMOS LOS IMPORTES DE LOS CONTRATO ORIGEN Y DESTINO      
005452* *************************************************************** 
005453 2500-ACTUALIZA-IMPORTE-CONT.                                     
005454                                                                  
005455     DISPLAY 'ACTUALIZAMOS IMPORTES EN CONTRATO'.                 
005456                                                                  
005457* ACTUALIZAMOS EL IMPORTE DEL CONTRATO CON EL NUEVO VALOR         
005458     EXEC SQL                                                     
005459       UPDATE  IBMUSER.CONTRATO                                   
005460          SET  IMPORTE = :DCLCONTRATO.IMPORTE                     
005461        WHERE  CLAVE_CONTRATO = :DCLCONTRATO.CLAVE-CONTRATO       
005462     END-EXEC.                                                    
005463                                                                  
005464* EN CASO DE ERROR SALIMOS DEL PROGRAMA                           
005465     IF SQLCODE NOT EQUAL 0                                       
005466       MOVE SQLCODE                      TO WS-S-SQLCODE          
005467       MOVE 'ERROR AL ACTUALIZAR IMPORTE ORIGEN'                  
005468                                         TO WS-S-DESCRIPCION      
005469                                                                  
005470       MOVE WS-SALIDA                    TO REG-SALIDA            
005471       WRITE REG-SALIDA                                           
005472       PERFORM 9999-ERROR                                         
005473     END-IF.                                                      
005474                                                                  
005475* RECUPERAMOS EL IMPORTE DEL CONTRATO DESTINO                     
005476     MOVE WS-E-CONT-DESTINO TO CLAVE-CONTRATO OF DCLCONTRATO.     
005477                                                                  
005478     EXEC SQL                                                     
005479        SELECT  IMPORTE                                           
005480          INTO :DCLCONTRATO.IMPORTE                               
005481          FROM  IBMUSER.CONTRATO                                  
005482         WHERE  CLAVE_CONTRATO = :DCLCONTRATO.CLAVE-CONTRATO      
005483     END-EXEC.                                                    
005484                                                                  
005485* EN CASO DE ERROR SALIMOS DEL PROGRAMA                           
005486     IF SQLCODE NOT EQUAL 0                                       
005487       MOVE SQLCODE                       TO WS-S-SQLCODE         
005488       MOVE 'ERROR AL RECUPERAR IMPORTE DESTINO'                  
005489                                          TO WS-S-DESCRIPCION     
005490                                                                  
005491       MOVE WS-SALIDA                    TO REG-SALIDA            
005492       WRITE REG-SALIDA                                           
005493       PERFORM 9999-ERROR                                         
005494     END-IF.                                                      
005495                                                                  
005496* CALCULAMOS EL IMPORTE DEL CONTRATO DESTINO, SUMANDOLE EL DEL    
005497* MOVIMIENTO                                                      
005498     COMPUTE IMPORTE OF DCLCONTRATO = IMPORTE OF DCLCONTRATO +    
005499             WS-E-IMPORTE.                                        
005500                                                                  
005501* ACTUALIZAMOS EL IMPORTE DEL CONTRATO DESTINO                    
005502     EXEC SQL                                                     
005503       UPDATE  IBMUSER.CONTRATO                                   
005504          SET  IMPORTE = :DCLCONTRATO.IMPORTE                     
005505        WHERE  CLAVE_CONTRATO = :DCLCONTRATO.CLAVE-CONTRATO       
005506     END-EXEC.                                                    
005507                                                                  
005508* EN CASO DE ERROE SALIMOS DEL PROGRAMA                           
005509     IF SQLCODE NOT EQUAL 0                                       
005510       MOVE SQLCODE                       TO WS-S-SQLCODE         
005511       MOVE 'ERROR AL ACTUALIZAR IMPORTE DESTINO'                 
005512                                          TO WS-S-DESCRIPCION     
005513                                                                  
005514       MOVE WS-SALIDA                    TO REG-SALIDA            
005515       WRITE REG-SALIDA                                           
005516       PERFORM 9999-ERROR                                         
005517     END-IF.                                                      
005518                                                                  
005519* **************************************************************  
005520* INCREMENTA EN 1 LA CLAVE DEL MOVIMIENTO ANTES DE INSERTARLA     
005521* EN LA TABLA DE MOVIMIENTO                                       
005522* **************************************************************  
005523 2700-INSERTA-MOVIMIENTO.                                         
005524                                                                  
005525     DISPLAY 'INSERTAMOS DATOS DE MOVIMIENTO'.                    
005526                                                                  
005527* MOVEMOS LOS CAMPOS DEL REGISTRO LEIDO A LAS VARIABLES HOST      
005528     MOVE WS-E-CONT-ORIGEN     TO ORIGEN.                         
005529     MOVE WS-E-CONT-DESTINO    TO DESTINO.                        
005530     MOVE WS-E-IMPORTE         TO IMPORTE     OF DCLMOVIMIENTO.   
005531     MOVE WS-E-DESCRIPCION     TO DESCRIPCION OF DCLMOVIMIENTO.   
005532                                                                  
005533* INSERTAMOS EL REGISTRO EN LA TABLA                              
005534     EXEC SQL                                                     
005535         INSERT INTO IBMUSER.MOVIMIENTO                           
005536               (CLAVE_MOVIMIENTO,                                 
005537                ORIGEN,                                           
005538                DESTINO,                                          
005539                DESCRIPCION,                                      
005540                IMPORTE)                                          
005542        VALUES (:CLAVE-MOVIMIENTO,                                
005543                :ORIGEN,                                          
005544                :DESTINO,                                         
005545                :DCLMOVIMIENTO.DESCRIPCION,                       
005546                :DCLMOVIMIENTO.IMPORTE)                           
005548     END-EXEC.                                                    
005549                                                                  
005550* EN CASO DE ERROR TERMINAMOS EL PROGRAMA                         
005551     IF SQLCODE NOT EQUAL 0                                       
005552       MOVE SQLCODE                       TO WS-S-SQLCODE         
005553       MOVE 'ERROR AL INSERTAR MOVIMIENTO' TO WS-S-DESCRIPCION    
005554                                                                  
005555       MOVE WS-SALIDA                     TO REG-SALIDA           
005556       WRITE REG-SALIDA                                           
005557       PERFORM 9999-ERROR                                         
005558     END-IF.                                                      
005559                                                                  
005560* **************************************************************  
005561* INCREMENTA EN 1 LA CLAVE DEL MOVIMIENTO ANTES DE INSERTARLA     
005562* EN LA TABLA DE MOVIMIENTOS                                      
005563* **************************************************************  
005564 2400-INCREMENTA-CLAVE-MOV.                                       
005565                                                                  
005566     DISPLAY ' INCREMENTAMOS CLAVE MOVIMIENTO'.                   
005567                                                                  
005568* CALCULAMOS EL SIGUIENTE ID DE MOVIMIENTO, SUMANDO 1 AL ANTERIOR 
005569     COMPUTE CLAVE-MOVIMIENTO = CLAVE-MOVIMIENTO + 1.             
005570                                                                  
005571* *************************************************************** 
005572* PARRAFO DE FIN DEL PROGRAMA                                     
005580* *************************************************************** 
006600 3000-FIN.                                                        
006610                                                                  
006620     DISPLAY 'FIN'.                                               
006621                                                                  
006622* CERRAMOS FICHEROS Y DEVOLVEMOS EL CONTROL AL S.O.               
006623     CLOSE FICHERO-ENT.                                           
006624     CLOSE FICHERO-SAL.                                           
006625     STOP RUN.                                                    
006630                                                                  
006640* **************************************************************  
006650* PARRAFO DE ERROR.REALIZAMOS UN ROLLBACK DE LA BASE DE DATOS     
006660* Y DEVOLVEMOS AL SISTEMA UN RC=8 (ERROR NO CONTROLADO)           
006670* **************************************************************  
006680 9999-ERROR.                                                      
006690                                                                  
006691     DISPLAY 'ERROR'.                                             
006692                                                                  
006693     EXEC SQL ROLLBACK END-EXEC                                   
006694     MOVE 8 TO RETURN-CODE.                                       
006695     GOBACK.                                                      