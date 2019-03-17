;**************************************************************************
; SBM 2019. Programa pract1a.asm
; Grupo 2301
; Javier Delgado del Cerro y Javier López Cano
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
	MATRIZ DB 2, -3, 1, -3, 5, 7, 1, 7, -1
	CLR_PANT 	DB 	1BH,"[2","J$"
	DET_LIN_SUP	DB	1BH,"[14;2f      $"
	DET_LINEA 	DB 	1BH,"[15;2f|A| = $"
	DET_LIN_INF	DB 	1BH,"[16;2f      $"
	
	SIGNO 		DB	?
	
	TEMP		DB	20 DUP(?)
	TEXTO		DB	10 dup (?)
	NUM_DIG		DW	?
	
	SPACE		DB	" $"
DATOS ENDS

;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
	DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0
PILA ENDS

;**************************************************************************
; DEFINICION DEL SEGMENTO EXTRA
EXTRA SEGMENT
	RESULT DW 0,0 ;ejemplo de inicialización. 2 PALABRAS (4 BYTES)
EXTRA ENDS

;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
INICIO PROC
	; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
	MOV AX, DATOS
	MOV DS, AX
	MOV AX, PILA
	MOV SS, AX
	MOV AX, EXTRA
	MOV ES, AX
	MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO
	; FIN DE LAS INICIALIZACIONES
	; COMIENZO DEL PROGRAMA
	
	MOV AH, 9h	; BORRA LA PANTALLA
	MOV DX, OFFSET CLR_PANT
	INT 21H

	;;; IMPRIMIMOS LA LINEA SUPERIOR
	MOV DX, OFFSET DET_LIN_SUP
	INT 21H
	
	MOV AH, 2h
	MOV DL, '|'
	INT 21H

	; Primer numero
	MOV AL, MATRIZ[0]
	CALL NUM_8_DIGITS
	CALL DIGITS_ASCII
	
	MOV AH, 9h
	MOV DX, OFFSET TEXTO
	INT 21H

	MOV AH, 2h
	MOV DL, ' '
	INT 21H

	; Segundo numero
	MOV AL, MATRIZ[1]
	CALL NUM_8_DIGITS
	CALL DIGITS_ASCII

	MOV AH, 9h
	MOV DX, OFFSET TEXTO
	INT 21H

	MOV AH, 2h
	MOV DL, ' '
	INT 21H
	
	; Tercer numero
	MOV AL, MATRIZ[2]
	CALL NUM_8_DIGITS
	CALL DIGITS_ASCII

	MOV AH, 9h
	MOV DX, OFFSET TEXTO
	INT 21H

	MOV AH, 2h
	MOV DL, '|'
	INT 21H

	;;; IMPRIMIMOS LA LINEA CENTRAL
	MOV AH, 9h
	MOV DX,OFFSET DET_LINEA
	INT 21H

	MOV AH, 2h
	MOV DL, '|'
	INT 21H

	; Primer numero
	MOV AL, MATRIZ[3]
	CALL NUM_8_DIGITS
	CALL DIGITS_ASCII
	
	MOV AH, 9h
	MOV DX, OFFSET TEXTO
	INT 21H

	MOV AH, 2h
	MOV DL, ' '
	INT 21H

	; Segundo numero
	MOV AL, MATRIZ[4]
	CALL NUM_8_DIGITS
	CALL DIGITS_ASCII
	
	MOV AH, 9h
	MOV DX, OFFSET TEXTO
	INT 21H

	MOV AH, 2h
	MOV DL, ' '
	INT 21H
	
	; Tercer numero
	MOV AL, MATRIZ[5]
	CALL NUM_8_DIGITS
	CALL DIGITS_ASCII
	
	MOV AH, 9h
	MOV DX, OFFSET TEXTO
	INT 21H

	MOV AH, 2h
	MOV DL, '|'
	INT 21H
	
	; Resultado del determinante
	MOV AH, 2h
	MOV DL, ' '
	INT 21H

	MOV DL, '='
	INT 21H

	MOV DL, ' '
	INT 21H

	CALL DETERMINANTE
	MOV AX, BX
	CALL NUM_DIGITS
	CALL DIGITS_ASCII
	
	MOV AH, 9h
	MOV DX, OFFSET TEXTO
	INT 21H

	;;; IMPRIMIMOS LA LINEA INFERIOR
	MOV DX, OFFSET DET_LIN_INF
	INT 21H
	
	MOV AH, 2h
	MOV DL, '|'
	INT 21H

	; Primer numero
	MOV AL, MATRIZ[6]
	CALL NUM_8_DIGITS
	CALL DIGITS_ASCII
	
	MOV AH, 9h
	MOV DX, OFFSET TEXTO
	INT 21H

	MOV AH, 2h
	MOV DL, ' '
	INT 21H

	; Segundo numero
	MOV AL, MATRIZ[7]
	CALL NUM_8_DIGITS
	CALL DIGITS_ASCII
	
	MOV AH, 9h
	MOV DX, OFFSET TEXTO
	INT 21H

	MOV AH, 2h
	MOV DL, ' '
	INT 21H
	
	; Tercer numero
	MOV AL, MATRIZ[8]
	CALL NUM_8_DIGITS
	CALL DIGITS_ASCII
	
	MOV AH, 9h
	MOV DX, OFFSET TEXTO
	INT 21H

	MOV AH, 2h
	MOV DL, '|'
	INT 21H
	
	; FIN DEL PROGRAMA
	MOV AX, 4C00h
	INT 21h
INICIO ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA CALCULAR EL DETERMINANTE DE UNA MATRIZ 
; 3x3 CON NUMEROS DE 5bits con signo 
; SALIDA BX
;_______________________________________________________________ 

DETERMINANTE PROC NEAR 
    ;;;Sumamos las tres lineas
	MOV AL, MATRIZ
	IMUL MATRIZ[4]
	IMUL MATRIZ[8]
	MOV BX, AX
	
	MOV AL, MATRIZ[1]
	IMUL MATRIZ[5]
	IMUL MATRIZ[6]
	ADD BX, AX
	
	MOV AL, MATRIZ[2]
	IMUL MATRIZ[3]
	IMUL MATRIZ[7]
	ADD BX, AX
	
	;;; Restamos las otras tres lineas
	MOV AL, MATRIZ[2]
	IMUL MATRIZ[4]
	IMUL MATRIZ[6]
	SUB BX, AX
	
	MOV AL, MATRIZ
	IMUL MATRIZ[5]
	IMUL MATRIZ[7]
	SUB BX, AX
	
	MOV AL, MATRIZ[1]
	IMUL MATRIZ[3]
	IMUL MATRIZ[8]
	SUB BX, AX
    RET 
DETERMINANTE ENDP 

;_______________________________________________________________ 
; SUBRUTINA PARA OBTENER LOS DIGITOS Y EL SIGNO DE UN 
; NUMERO DE 2 Bytes 
; ENTRADA AX
; SALIDA TEMP, SIGNO Y NUM_DIG
;_______________________________________________________________ 
NUM_DIGITS PROC NEAR
	MOV DI, 0
	MOV DL, 10
	ADD AX, 0
	JS	NEGATIVO
	MOV SIGNO, " "
	
COMUN:
	DIV DL
	MOV TEMP[DI], AH
	
	CMP AL, 0
	JZ FIN
	MOV AH, 0
	INC DI
	JMP COMUN
	
FIN:
	MOV NUM_DIG, DI
	RET
	
NEGATIVO:
	MOV SIGNO, "-"
	NEG AX
	JMP COMUN
NUM_DIGITS ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA OBTENER LOS DIGITOS Y EL SIGNO DE UN 
; NUMERO DE 1 Byte 
; ENTRADA AL
; SALIDA TEMP, SIGNO Y NUM_DIG
;_______________________________________________________________ 
NUM_8_DIGITS PROC NEAR
	ADD AL, 0
	JS	NEGATIVO_8
	MOV AH, 0
	
COMUN_8:
	CALL NUM_DIGITS
	RET
	
NEGATIVO_8:
	MOV AH, -1
	JMP COMUN_8
NUM_8_DIGITS ENDP

;_______________________________________________________________ 
; SUBRUTINA PARA OBTENER EL CODIGO ASCII A PARTIR DE SU
; SIGNO Y DIGITOS 
; ENTRADA SIGNO, TEMP, NUM_DIG
; SALIDA TEXTO
;_______________________________________________________________ 
DIGITS_ASCII PROC NEAR
	MOV SI, [NUM_DIG]
	MOV DI, 1
	MOV DL, SIGNO
	MOV TEXTO[1], DL
BUCLE:
	MOV AL, TEMP[SI]
	ADD AL, 30h
	MOV TEXTO[DI], AL
	
	INC DI
	DEC SI
	JNS BUCLE
	MOV TEXTO[DI], "$"
	RET
	
DIGITS_ASCII ENDP


; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 