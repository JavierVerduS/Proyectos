	LIST p = 16f876a  
	include "p16f876a.inc"
  __CONFIG _XT_OSC & _WDT_OFF & _LVP_OFF  
;programa que genere secuencia en pines PORTC 3:0 (1100 rotando)
   
	RES_AN0 EQU 0x20
	RES_AN1 EQU 0x21
	RES_AN3 EQU 0x22
	nVecesParaDecima EQU 0x23
	flag_MODO EQU 0x24 ; 0 monitorizacion 1 ajuste local
	antiguoPORTB EQU 0x25
	decimas EQU 0x26
	UMBRAL_CANAL0 EQU 0x27
	UMBRAL_CANAL1 EQU 0x28
	UMBRAL_CANAL3 EQU 0x29
	CONT1 EQU 0x30
	PERIODO EQU 0x31
	resXOR EQU 0x32
	dato1_rx EQU 0x33
	dato2_rx EQU 0x34
	dato3_rx EQU 0x35
	dato4_rx EQU 0x36
	dato5_rx EQU 0x37
	puntero_rx EQU 0x38
	puntero_tx EQU 0x39
	n_datos_rx EQU 0x3A
	n_datos_tx EQU 0x3B
	CANAL EQU 0x3C
	CANAL_ENVIAR EQU 0x3D
	CANAL_UBICADO EQU 0x3E
	CONT2 EQU 0x3F
 	 ORG  0
	 goto inicio 
	 ORG  4
 	 goto  ISR   
	 ORG  5

inicio
	
    bsf  STATUS,RP0  
	clrf TRISC; salida
	bcf TRISB,1 ;para AN0
	bcf TRISB,2;para AN1
	bcf TRISB,3;para AN3
;interrupcion RB0
	bsf TRISB,RB0;entrada
	bsf OPTION_REG,INTEDG;decide si es de flanco ASC 0 DESC 1=ASC  en este caso descendente
 	bsf INTCON,INTE

	bcf STATUS,RP0
	;este flag nos indicará el modo de funcionamiento que estemos
	bcf flag_MODO,0 ;inicialmente en modo monitorización 
	
;interrupcion RB47
	bsf TRISB,RB4
	bsf TRISB,RB5
	bsf TRISB,RB6
	BSF TRISB,RB7
	bsf INTCON,RBIE
;configurafion A/D
	bsf ADCON0,ADCS1; 32 tocs
	bcf ADCON0,CHS2
	bcf ADCON0,CHS0
	bcf ADCON0,CHS1 ;inicialmente chanel0
	bsf ADCON0,0;operativo a falta del GO
	
	bsf STATUS,RP0
	bsf TRISA,RA0
	bsf TRISA,RA1 ;como entradas
	bsf TRISA,RA3
	

	bcf ADCON1,ADFM ;justificado izquierda
	bcf ADCON1,PCFG0
	bcf ADCON1,PCFG1
	bcf ADCON1,PCFG2
;configurar A/D interrupt
	bsf PIE1,ADIE

; configuración USART
	bcf STATUS,RP0
	bsf RCSTA,SPEN
	bcf RCSTA,RX9
	bsf RCSTA,CREN

	bsf STATUS,RP0
	bcf TXSTA,TX9
	bcf TXSTA,SYNC
	bsf TXSTA,TXEN
	bsf TXSTA, BRGH
	movlw .25
	movwf SPBRG
	 
	bcf TRISC,6
	bsf TRISC,7
	bsf PIE1,RCIE
;configurar TMR
	bcf OPTION_REG,T0CS
	bcf OPTION_REG,PSA
	bsf OPTION_REG,PS2
	bsf OPTION_REG,PS1	
	bcf OPTION_REG,PS0;prescaler 1/128 cuento 25ms
 	bsf INTCON,T0IE
	
	bcf STATUS,RP0
	movlw .61
	movwf TMR0
	
	movlw .4
	movwf nVecesParaDecima
	
	movlw .10
	movwf UMBRAL_CANAL0
	movlw .25
	movwf UMBRAL_CANAL1
	movlw .50
	movwf UMBRAL_CANAL3
	
	movlw .1
	movwf PERIODO

	movlw 0x33
	movwf puntero_rx
	movlw .5 
	movwf n_datos_rx

	clrf decimas
	movf PORTB,0
	movwf antiguoPORTB
 	bcf 	flag_MODO,0
	 
	bsf	 INTCON,PEIE
 	bsf  INTCON,GIE
main  
  goto main

ISR
	
	btfsc INTCON,INTF
	goto cambio_MODO
	
	btfsc flag_MODO,0 ;cambio según lo que tenga
	goto ISR_AJUSTE_LOCAL
	goto ISR_MONITOR

cambio_MODO
	call retardo_30ms
	bcf INTCON,INTF
	btfsc flag_MODO,0 ;cambio según lo que tenga
	goto Monitorizacion
	goto ajuste_LOCAL

ajuste_LOCAL
	bsf STATUS,RP0
	bsf OPTION_REG,T0CS;cuando entro aqui paro reloj
	bcf STATUS,RP0
	bsf flag_MODO,0
	retfie
Monitorizacion
	bsf STATUS,RP0
	bcf OPTION_REG,T0CS;cuando entro aqui vuelvo a reloj

	bcf STATUS,RP0
	movlw .61
	movwf TMR0
	clrf decimas 
	movlw .4
	movwf nVecesParaDecima
	bcf flag_MODO,0
	retfie
;-------------AJUSTE_LOCAL--------------;
ISR_AJUSTE_LOCAL
	 
	btfsc INTCON,RBIF
	goto controles
	btfsc PIR1,RCIF
	goto Recepcion
	btfsc PIR1,TXIF
	goto check_Transmision
	retfie
check_Transmision
	bsf STATUS,RP0
	btfsc PIE1,TXIE
	goto SI_Transmision
	bcf STATUS,RP0
	retfie

SI_Transmision
	bcf STATUS,RP0
	goto Transmision	
controles
	
	call retardo_30ms 
	movf PORTB,0
	bcf INTCON,RBIF
 
	btfsc PORTB,7;compruebo a donde voy ahora 
	goto check210_11
	goto check200_01
check200_01
	btfsc PORTB,6
	goto _2_01_RB_76
	goto _2_00_RB_76

check210_11
	btfsc PORTB,6
	goto _2_11_RB_76
	goto _2_10_RB_76
;-------AN0----------;
_2_00_RB_76
	xorwf antiguoPORTB,0
	movwf resXOR
	movf PORTB,0
	movwf antiguoPORTB

	; cargo valores a portC
	movf UMBRAL_CANAL0,0
	movwf PORTC
	
	btfsc resXOR,5
	goto Aumentar_Umbral_AN0
	btfsc resXOR,4
	goto Disminuir_Umbral_AN0
	retfie
Aumentar_Umbral_AN0
	btfss PORTB,5
	retfie
	movlw .60
	subwf UMBRAL_CANAL0,0
	btfsc STATUS,Z; el maximo es 64 si lo pasa no hago nada
	retfie
	incf UMBRAL_CANAL0,1
	movf UMBRAL_CANAL0,0
	movwf PORTC
	retfie
Disminuir_Umbral_AN0
	
	btfss PORTB,4
	retfie
	movlw .4
	subwf UMBRAL_CANAL0,0
	btfsc STATUS,Z; el maximo es 64 si lo pasa no hago nada
	retfie
	decf UMBRAL_CANAL0,1
	movf UMBRAL_CANAL0,0
	movwf PORTC
	retfie
;-------AN1----------;
_2_01_RB_76
	xorwf antiguoPORTB,0
	movwf resXOR
	movf PORTB,0
	movwf antiguoPORTB
	
	movf UMBRAL_CANAL1,0
	movwf PORTC
	btfsc resXOR,5
	goto Aumentar_Umbral_AN1
	btfsc resXOR,4
	goto Disminuir_Umbral_AN1
	retfie
Aumentar_Umbral_AN1
	btfss PORTB,5
	retfie
	movlw .60
	subwf UMBRAL_CANAL1,0
	btfsc STATUS,Z; el maximo es 64 si lo pasa no hago nada
	retfie
	incf UMBRAL_CANAL1,1
	movf UMBRAL_CANAL1,0
	movwf PORTC
	retfie
Disminuir_Umbral_AN1
	btfss PORTB,4
	retfie
	movlw .4
	subwf UMBRAL_CANAL1,0
	btfsc STATUS,Z; el maximo es 64 si lo pasa no hago nada
	retfie
	decf UMBRAL_CANAL1,1
	movf UMBRAL_CANAL1,0
	movwf PORTC
	retfie
;-------AN3----------;
_2_10_RB_76
	xorwf antiguoPORTB,0
	movwf resXOR
	movf PORTB,0
	movwf antiguoPORTB
	
	movf UMBRAL_CANAL3,0
	movwf PORTC
	
	btfsc resXOR,5
	goto Aumentar_Umbral_AN3
	btfsc resXOR,4
	goto Disminuir_Umbral_AN3
	retfie
Aumentar_Umbral_AN3
	btfss PORTB,5
	retfie
	movlw .60
	subwf UMBRAL_CANAL3,0
	btfsc STATUS,Z; el maximo es 64 si lo pasa no hago nada
	retfie
	incf UMBRAL_CANAL3,1
	movf UMBRAL_CANAL3,0
	movwf PORTC
	retfie
Disminuir_Umbral_AN3
	btfss PORTB,4
	retfie
	movlw .4
	subwf UMBRAL_CANAL3,0
	btfsc STATUS,Z; el maximo es 64 si lo pasa no hago nada
	retfie
	decf UMBRAL_CANAL3,1
	movf UMBRAL_CANAL3,0
	movwf PORTC
	retfie

;-------TIME------;
_2_11_RB_76
	xorwf antiguoPORTB,0
	movwf resXOR
	movf PORTB,0
	movwf antiguoPORTB
	
	movf PERIODO,0
	movwf PORTC
	btfsc resXOR,5
	goto Aumentar_Tiempo
	btfsc resXOR,4
	goto Disminuir_Tiempo
	retfie
	
Aumentar_Tiempo
	btfss PORTB,5
	retfie
	movlw .10
	subwf PERIODO,0
	btfsc STATUS,Z; el maximo es 10 si lo pasa no hago nada
	retfie
	incf PERIODO,1
	movf PERIODO,0
	movwf PORTC
	retfie
Disminuir_Tiempo
	btfss PORTB,4
	retfie
	movlw .1
	subwf PERIODO,0
	btfsc STATUS,Z; el minimo  es 1 si lo pasa no hago nada
	retfie
	decf PERIODO,1
 	movf PERIODO,0
	movwf PORTC
	retfie
	 
;-----------------------MONITORIZACIón------------------;

ISR_MONITOR
	btfsc INTCON,T0IF
	goto ISRTIME
	btfsc INTCON,RBIF
	goto controlRB
	btfsc PIR1,ADIF
	goto AD_INT
	btfsc PIR1,RCIF
	goto Recepcion
	btfsc PIR1,TXIF
	goto  check_Transmision
	retfie


AD_INT
	bcf PIR1,ADIF
	btfss ADCON0,CHS0
	goto CANAL0
	btfsc ADCON0,CHS1
	goto CANAL3
	goto CANAL1
CANAL0
	 
	movf ADRESH,0
	movwf RES_AN0

	
	rrf RES_AN0,1
	rrf RES_AN0,1
	bcf RES_AN0,7
	bcf RES_AN0,6; para tener los más significativos
	movf RES_AN0,0
	movwf PORTC
	movwf CANAL_ENVIAR
	btfsc CANAL,0
	call ENVIAR_c1chCONVERSION
	
	
;comprobamos umbrales
	movf UMBRAL_CANAL0,0
	subwf RES_AN0,0
	bcf PORTB,1
	btfsc STATUS,C ;si C=0 el valor es negativo por tanto led apagado
	bsf PORTB,1
	

	
	;ahora cambio al canal 1 ya que es consecutivo
	bsf ADCON0,CHS0
	bcf ADCON0,CHS1;canal 1
	bcf ADCON0,CHS2
	goto controlRB
	retfie

 CANAL1
 
	movf ADRESH,0
	movwf RES_AN1

 	
	rrf RES_AN1,1
	rrf RES_AN1,1
	bcf RES_AN1,7
	bcf RES_AN1,6; para tener los más significativos
	movf RES_AN1,0
	movwf CANAL_ENVIAR
	btfsc CANAL,1
	call ENVIAR_c1chCONVERSION
	
	;comprobamos umbrales
	movf UMBRAL_CANAL1,0
	subwf RES_AN1,0
	bcf PORTB,2
	btfsc STATUS,C ;si C=0 el valor es negativo por tanto led apagado
	bsf PORTB,2
	
	;ahora cambio al canal 3 ya que es consecutivo
	bsf ADCON0,CHS0
	bsf ADCON0,CHS1;canal 3
	bcf ADCON0,CHS2
 	goto controlRB ; porque cada vezq ue se actualize habrá que actualizar lo que pidan los RB67
CANAL3
 
	movf ADRESH,0
	movwf RES_AN3
 	
	bcf RES_AN3,0
	bcf RES_AN3,1; para tener los más significativos
	rrf RES_AN3,1
	rrf RES_AN3,1
	bcf RES_AN3,7
	bcf RES_AN3,6; para tener los más significativos
	
	movf RES_AN3,0
	movwf CANAL_ENVIAR
	btfsc CANAL,3
	call ENVIAR_c1chCONVERSION
	;comprobamos umbrales
	movf UMBRAL_CANAL3,0
	subwf RES_AN3,0
	bcf PORTB,3
	btfsc STATUS,C ;si C=0 el valor es negativo por tanto led apagado
	bsf PORTB,3
	
	;ahora cambio al cana 0 ya que es consecutivo
	bcf ADCON0,CHS0
	bcf ADCON0,CHS1;canal 0
	bcf ADCON0,CHS2
	goto controlRB
ISRTIME
	bcf INTCON,T0IF ;reset flag 
	movlw .60
	movwf TMR0
	decfsz nVecesParaDecima,1
	retfie
	movlw .4
	movwf nVecesParaDecima
	incf decimas,1
	movf decimas,0
	subwf PERIODO,0
	btfss STATUS,Z ;Si no es el periodo A/D correcto sigue
	retfie
	clrf decimas
	;START
	bsf ADCON0,2
	
	retfie
controlRB
	movf PORTB,0
	movwf antiguoPORTB
	btfsc INTCON,RBIF
	call retardo_30ms
	bcf INTCON,RBIF
	btfsc PORTB,7;compruebo a donde voy
	goto check10_11
	goto check00_01
check00_01
	btfsc PORTB,6
	goto _01_RB_76
	goto _00_RB_76

check10_11
	btfsc PORTB,6
	goto _11_RB_76
	goto _10_RB_76

_00_RB_76
 
	movf RES_AN0,0
	movwf PORTC
	retfie
_01_RB_76
	movf RES_AN1,0
	movwf PORTC
	retfie


_10_RB_76
	movf RES_AN3,0
	movwf PORTC
	retfie
_11_RB_76
	movf PERIODO,0
	movwf PORTC
	retfie

;----------USART--------;
Recepcion
	movf puntero_rx,0
	movwf FSR
	movf RCREG,0
	movwf INDF
	
	decfsz n_datos_rx,1
	goto sigue
	goto comprobar
sigue
	incf puntero_rx,1
	retfie
comprobar
	movlw .5
	movwf n_datos_rx
	movlw 0x33
	movwf puntero_rx
	
	movlw 'c'
	subwf dato1_rx,0
	btfsc STATUS,Z
	goto check1
	goto Enviar_not_recognized
check1
	movlw '1'
	subwf dato2_rx,0
	btfsc STATUS,Z
	goto check_c 
	goto Enviar_not_recognized
check_c
	movlw 'c'
	subwf dato3_rx,0
	btfsc STATUS,Z
	goto check_h
	goto check_s
;------c1ch---------
check_h
	movlw'h'
	subwf dato4_rx,0
	btfsc STATUS,Z
	goto check_CANAL_0
	goto ENVIAR_comand_not_found
check_CANAL_0
	movlw '0'
	subwf dato5_rx,0
	btfsc STATUS,Z
	goto preparar_canal_0
	goto check_CANAL_1
	
check_CANAL_1
	movlw '1'
	subwf dato5_rx,0
	btfsc STATUS,Z
	goto preparar_canal_1
	goto check_CANAL_3
check_CANAL_3
	movlw '3'
	subwf dato5_rx,0
	btfsc STATUS,Z
	goto preparar_canal_3
	goto ENVIAR_Parameter_not_valid

preparar_canal_0
	movlw '0'
	movwf CANAL_UBICADO
	
	bsf CANAL,0;flag para saber que canal llega por USART
	retfie
preparar_canal_1
	movlw '1'
	movwf CANAL_UBICADO
	bsf CANAL,1
	retfie
preparar_canal_3
	movlw '3'
	movwf CANAL_UBICADO
	bsf CANAL,3
	retfie
	;------c1st---------;

check_s
	movlw 's'
	subwf dato3_rx,0
	btfsc STATUS,Z
	goto check_t
	goto check_u
check_t
	movlw 't'
	subwf dato4_rx,0
	btfsc STATUS,Z
	goto check_decima
	goto ENVIAR_comand_not_found
 	 
check_decima
	movlw .1
	subwf dato5_rx,0
	btfss STATUS,C
	goto ENVIAR_Parameter_not_valid ;si C=1 es menor que 1 no es valido
	movlw .10
	subwf dato5_rx,0
	btfsc STATUS,C
	goto ENVIAR_Parameter_not_valid
	movf dato5_rx,0
	movwf PERIODO
	retfie
 

	;-----c1u------;
check_u
	movlw 'u
	subwf dato3_rx
	btfsc STATUS,Z
	goto check_CANAL0
	goto ENVIAR_comand_not_found
	
 check_CANAL0
	movlw '0'
	subwf dato4_rx,0
	btfss STATUS,Z
	goto check_CANAL1
	
	movlw .4
	subwf dato5_rx,0
	btfss STATUS,C
	goto ENVIAR_Parameter_not_valid ;si C=1 es menor que 1 no es valido
	 
	movlw .60
	subwf dato5_rx,0
	btfsc STATUS,C
	goto ENVIAR_Parameter_not_valid
	movf dato5_rx,0
	movwf UMBRAL_CANAL0
	retfie 
	
	
check_CANAL1
	movlw '1'
	subwf dato4_rx,0
	btfss STATUS,Z
	goto check_CANAL3
	movlw .4
	subwf dato5_rx,0
	btfss STATUS,C
	goto ENVIAR_Parameter_not_valid ;si C=1 es menor que 1 no es valido
	movlw .60
	subwf dato5_rx,0
	btfsc STATUS,C
	goto ENVIAR_Parameter_not_valid
	movf dato5_rx,0
	movwf UMBRAL_CANAL1
	retfie
 	
check_CANAL3	
	movlw '3'
	subwf dato4_rx,0
	btfss STATUS,Z
	goto ENVIAR_Parameter_not_valid
	movlw .4
	subwf dato5_rx,0
	btfss STATUS,C
	goto ENVIAR_Parameter_not_valid ;si C=1 es menor que 1 no es valido
	movlw .60
	subwf dato5_rx,0
	btfsc STATUS,C
	goto ENVIAR_Parameter_not_valid
	movf dato5_rx,0
	movwf UMBRAL_CANAL3
	retfie
	
Transmision
	movf puntero_tx,0
	movwf FSR
	
	movf INDF,0
	movwf TXREG
	
	decfsz n_datos_tx
	goto sigue_tx
	goto fin

sigue_tx 
	incf puntero_tx,1
	retfie
fin 
	
	bsf STATUS,RP0
	bcf PIE1,TXIE
	bcf STATUS,RP0		
	retfie

ENVIAR_Parameter_not_valid
	movlw 'P'
	movwf 0x40

	movlw 'A'
	movwf 0x41
	
	movlw 'R'
	movwf 0x42
	 
	movlw 'A'
	movwf 0x43

	movlw 'M'
	movwf 0x44
	
	movlw 'E'
	movwf 0x45
	
	movlw 'T'
	movwf 0x46

	movlw 'E'
	movwf 0x47
	
	movlw 'R'
	movwf 0x48
	
	movlw ' '
	movwf 0x49

	movlw 'N'
	movwf 0x4A
	
	movlw 'O'
	movwf 0x4B
	
	movlw 'T'
	movwf 0x4C

	movlw ' '
	movwf 0x4D
	
	movlw 'V'
	movwf 0x4E
	
	movlw 'A'
	movwf 0x4F

	movlw 'L'
	movwf 0x50

	movlw 'I'
	movwf 0x51
	
	movlw 'D'
	movwf 0x52
	
	movlw .10
	movwf 0x53

	movlw .12
	movwf 0x54
	
	movlw 0x40
	movwf puntero_tx

	movlw .21
	movwf n_datos_tx
	
	bsf STATUS,RP0
	bsf PIE1,TXIE
	bcf STATUS,RP0
 	retfie
	 
ENVIAR_comand_not_found

	movlw 'C'
	movwf 0x40

	movlw 'O'
	movwf 0x41
	
	movlw 'M'
	movwf 0x42
	 
	movlw 'A'
	movwf 0x43

	movlw 'N'
	movwf 0x44
	
	movlw 'D'
	movwf 0x45
	
	movlw ' '
	movwf 0x46

	movlw 'N'
	movwf 0x47
	
	movlw 'O'
	movwf 0x48
	
	movlw 'T'
	movwf 0x49

	movlw ' '
	movwf 0x4A
	
	movlw 'F'
	movwf 0x4B
	
	movlw 'O'
	movwf 0x4C

	movlw 'U'
	movwf 0x4D
	
	movlw 'N'
	movwf 0x4E
	
	movlw 'D'
	movwf 0x4F

	
	movlw .10
	movwf 0x50

	movlw .12
	movwf 0x51
	
	movlw 0x52
	movwf puntero_tx

	movlw .18
	movwf n_datos_tx
	
	bsf STATUS,RP0
	bsf PIE1,TXIE
	bcf STATUS,RP0
 	retfie
Enviar_not_recognized
	movf dato1_rx,0
	movwf 0x40
	
	movf dato2_rx,0
	movwf 0x41
	
	movf dato3_rx,0
	movwf 0x42

	movf dato4_rx,0
	movwf 0x43

	movf dato5_rx,0
	movwf 0x44
	
	movlw ' '
	movwf 0x45
	
	movlw 'N'
	movwf 0x46

	movlw '0'
	movwf 0x47
	
	movlw 'T'
	movwf 0x48
	
	movlw ' '
	movlw 0x49
	
	movlw 'R'
	movwf 0x4A

	movlw 'E'
	movwf 0x4B
	
	movlw 'C'
	movwf 0x4C
	
	movlw 'O'
	movwf 0x4D

	movlw 'G'
	movwf 0x4E
	
	movlw 'N'
	movwf 0x4F
	
	movlw 'I'
	movwf 0x50
	
	movlw 'Z'
	movwf 0x51
	
	movlw 'E'
	movwf 0x52
	
	movlw 'D'
	movwf 0x53
	
	movlw .10
	movwf 0x54

	movlw .12
	movwf 0x55
	
	movlw .22
	movwf n_datos_tx
	
	
	movlw 0x40
	movwf puntero_tx
	bsf STATUS,RP0
	bsf PIE1,TXIE
	bcf STATUS,RP0
	retfie
	
 ENVIAR_c1chCONVERSION
 
	
	movlw 'c'
	movwf 0x40
	
	movlw '1'
	movwf 0x41
	
	movlw 'c'
	movwf 0x42

	movlw 'h'
	movwf 0x43

	movf CANAL_UBICADO,0
	movwf 0x44
	
	movlw '0'
	movwf 0x46

	movf CANAL_ENVIAR,0
	movwf 0x47
	
	movlw .10
	movwf 0x48

	movlw .12
	movwf 0x49
 
	clrf CANAL ;pongo todo a 0 para que solo lo haga una vez
	
	movlw .9
	movwf n_datos_tx
	
	movlw 0x40
	movwf puntero_tx
	
	bsf STATUS,RP0
	bsf PIE1,TXIE
	bcf STATUS,RP0
	return

retardo_30ms
	movlw .184
	movwf CONT2
bucle_retardo
	movlw .53
	movwf CONT1
ciclo1
	decfsz CONT1,1
	goto ciclo1
	decfsz CONT2,1
	goto bucle_retardo
	nop
	nop
	nop
	return
 end
