; PROYECTO 2

; *DECLARACION CONSTANTES

SCDR                equ       $102F
SCCR2               equ       $102D
SCSR                equ       $102E
SCCR1               equ       $102C
BAUD                equ       $102B
HPRIO               equ       $103C
SPCR                equ       $1028
CSCTL               equ       $105D
OPT2                equ       $1038
DDRD                equ       $1009

ORDEN               equ       $0000
DIR                 equ       $0070
NUMCARAC            equ       $0010
BERROR2             equ       $0003
O                   equ       $0023               ; *BANDERA DEL OK
BANDERA_ERROR       equ       $0011               ; BANDERA DE ERROR PARA ARABIGOS

                    org       $3000
                    fcc       'ERROR, NUMERO ROMANO INVALIDO.'  ; *29 CARACTERES
MENSAJE_E_ARABIGO   fcc       'ERROR, NUMERO ARABIGO INVALIDO.'  ; *30
                    fcc       'ERROR, NUMERO FUERA DE RANGO.'  ; *28
CIEN_R              fcc       'C '                ; *100
DOSCIEN_RTOS        fcc       'CC '               ; *200
TRESCIEN_RTOS       fcc       'CCC '              ; *300
CUATROCIEN_RTOS     fcc       'CD '               ; *400
QUINIENTOS          fcc       'D '                ; *500
SEISCIEN_RTOS       fcc       'DC '               ; *600
SETECIEN_RTOS       fcc       'DCC '              ; *700
OCHOCIEN_RTOS       fcc       'DCCC '             ; *800
NOVECIEN_RTOS       fcc       'CM '               ; *900
DIEZ_R              fcc       'X '                ; *10
VEINTE_R            fcc       'XX '               ; *20
TREINTA_R           fcc       'XXX '              ; *30
CUARENTA_R          fcc       'XL '               ; *40
CINCUENTA_R         fcc       'L '                ; *50
SESENTA_R           fcc       'LX '               ; *60
SETENTA_R           fcc       'LXX '              ; *70
OCHENTA_R           fcc       'LXXX '             ; *80
NOVENTA_R           fcc       'XC '               ; *90
UNO_R               fcc       'I '                ; *1
DOS_R               fcc       'II '               ; *2
TRES_R              fcc       'III '              ; *3
CUATRO_R            fcc       'IV '               ; *4
CINCO_R             fcc       'V '                ; *5
SEIS_R              fcc       'VI '               ; *6
SIETE_R             fcc       'VII '              ; *7
OCHO_R              fcc       'VIII '             ; *8
NUEVE_R             fcc       'XI '               ; *9

;*** NUMEROS EN LETRA
;**AQUI VAN
                    org       $8000
INICIO
                    lds       #$00FF              ; *Configuracion del puerto serial
                    jsr       SERIAL              ; SUBRUTINA PARA CONFIG EL PUERTO SERIAL
                    jsr       INICIALIZAR

CICLATE
                    lda       #'?'
                    sta       ORDEN
CUENTA
                    lda       ORDEN
                    cmpa      #'?'
                    beq       CUENTA

; *JSR VALIDACION_ROMANO
; *SALTAR A LA CONVERSION DE ROMANOS

ENTRADA
                    cmpa      #61                 ; *Valida que le llegue un = para saber que es fin de la cadena que mete el usuario
                    beq       TRADUCCION_A_ROMANO

                    cmpa      #'O'                ; *CASO EN QUE RECIBA OK
                    beq       CASOO
                    cmpa      #'K'
                    beq       CASOOK              ; *CASO EN QUE RECIBA UNA K
                    jsr       VALIDACION_ARABIGO
                    cmpb      #1                  ; *LLEVA $?
                    bne       CICLATE

                    ldb       NUMCARAC
                    cmpb      #3
                    bhi       ERROR_CANTIDAD      ; *POR SI YA LLEGARON LOS 4 CARACTERES ES UN ERROR

                    incb
                    stb       NUMCARAC            ; *INCREMENTAMOS EL DE CARACTERES

                    sta       ,x
                    inx                           ; *CAMBIAMOS EL CONTADOR DE LA SIGUIENTE MEMORIA A ESCRIBIR

                    bra       CICLATE

CASOO
                    ldb       O
                    incb
                    stb       O
                    bra       FIN

CASOOK
                    ldb       O
                    cmpb      #0
                    beq       CICLATE
                    bsr       INICIALIZAR
                    bra       CICLATE

TRADUCCION_A_ROMANO
                    lda       BANDERA_ERROR
                    cmpa      #1
                    beq       CICLATE
                    ldx       #$0070              ; *REGRESAMOS A LA CIFRA MAS SIGNIFICATIVA
                    lda       NUMCARAC            ; *COMPARAMOS EL NUMERO DE CARACTERES
                    cmpa      #1
                    beq       CASO_UNIDAD
                    cmpa      #2
                    beq       CASO_DECENA
                    cmpa      #3
                    beq       CASO_CENTENA
                    cmpa      #4
                    beq       CASO_MILLAR
                    bra       CICLATE             ; *POR SI NO SE VALIDA BIEN

CASO_MILLAR

                    ldy       #$0050              ; *DIRECCION DE ESCRITURA
                    ldx       #$0070              ; *DIRECCION DE NUM
                    ldb       ,x                  ; *TOMAR EL PRIMER NUM CHAR Y PONERLO EN B
                    cmpb      #$31
                    blo       CASO_CENTENA        ; VALIDA QUE SEA MAYOR A 0 EN ASCII

CASO_ESCRIBE_MILLAR
                    lda       #'M'                ; CARGA UNA M EN EL ACUMULADOR A
                    sta       ,y                  ; ESCRIBE EN LA DIR DE Y
                    iny                           ; INCREMENTAMOS Y PARA CONTINUAR ESCRIBIENDO
                    decb                          ; DECREMENTAMOS B
                    cmpb      #$30                ; ASCII DE 0
                    bne       CASO_ESCRIBE_MILLAR  ; MIENTRAS NO ENCONTREMOS UN PUNTO(.) SE REPITE
                    inx                           ; PASAMOS AL SIGUIENTE NUM DIGITO
CASO_CENTENA
                    jsr       ESCRIBE_CENTENA
                    inx
CASO_DECENA
                    jsr       ESCRIBE_DECENA
                    inx
CASO_UNIDAD
                    jsr       ESCRIBE_UNIDAD
                    bra       CICLATE

COMPARADOR

ERROR_CANTIDAD
                    ldx       #$0050              ; DIRECCION DEL MENSAJE
                    ldy       #MENSAJE_E_ARABIGO  ; ORG DE LOS FCC
                    jsr       ERROR
                    jmp       CICLATE

FIN
                    lda       #'?'
                    sta       ORDEN
CICLO1
                    lda       ORDEN
                    cmpa      #'?'
                    beq       CICLO1
                    jmp       ENTRADA

; *Configuracion del puerto serial
SERIAL
                    ldd       #$302C              ; CONFIGURA PUERTO SERIAL
                    sta       BAUD                ; BAUD 9600 para cristal de 8MHz
                    stb       SCCR2               ; HABILITA RX Y TX PERO INTERRUPCN SOLO RX
                    lda       #$00
                    sta       SCCR1               ; 8 BITS

                    lda       #$FE                ; CONFIG PUERTO D COMO SALIDAS (EXCEPTO PD0)
                    sta       DDRD                ; SEA ENABLE DEL DISPLAY PD4 Y RS PD3

                    lda       #$04
                    sta       HPRIO

                    lda       #$00
                    tap
                    rts

INICIALIZAR
                    ldx       #$0070
                    ldy       #$0070
                    clr       O
                    clr       UNO_R
                    clr       BERROR2             ; *DEJA EN CERO LAS VARIABLES
                    clr       NUMCARAC
                    clr       BANDERA_ERROR
LIM
                    lda       #00
                    sta       ,y
                    iny
                    cpy       #$008F
                    bne       LIM
                    ldy       #$0050
LIM2
                    lda       #00
                    sta       ,y
                    iny
                    cpy       #$006F
                    bne       LIM2
                    rts

VALIDACION_ARABIGO
                    cmpa      #$30                ; *Valor 0
                    blo       ERROR_ARABIGO
                    cmpa      #$3A                ; Valor 9
                    bhi       ERROR_ARABIGO
                    ldb       #$1
FIN_VALIDACION_ARABIGO

                    rts

ERROR_ARABIGO
                    ldx       #$0050              ; DIRECCION DEL MENSAJE
                    ldy       #MENSAJE_E_ARABIGO  ; MENSAJE
                    bsr       ERROR
                    bra       FIN_VALIDACION_ARABIGO

VALIDACION_ROMANO
                    cmpa      #$4D                ; *VALOR M
                    bne       ERROR
                    cmpa      #$44                ; *VALOR D
                    bne       ERROR
                    cmpa      #$43                ; *VALOR C
                    bne       ERROR
                    cmpa      #$4C                ; *VALOR L
                    bne       ERROR
                    cmpa      #$58                ; *VALORD X
                    bne       ERROR
                    cmpa      #$56                ; *VALOR V
                    bne       ERROR
                    cmpa      #49                 ; *VALOR I
                    bne       ERROR
                    rts

ERROR
                    lda       #1
                    sta       BANDERA_ERROR
ERROR_CICLO
                    ldb       ,y                  ; *TOMA CARACTER DEL FCC
                    stb       ,x                  ; *ESCRIBE EL CHAR EN LA DIR DE X
                    inx
                    iny                           ; INCREMENTAMOS X Y Y
                    cmpb      #46                 ; ASCII DE PUNTO
                    bne       ERROR_CICLO         ; MIENTRAS NO ENCONTREMOS UN PUNTO(.) SE REPITE
                    rts

ESCRIBE_CENTENA
                    pshx
                    lda       ,x
                    suba      #$30
                    cmpa      #1
                    beq       NUM_1_CENTENA
                    cmpa      #2
                    beq       NUM_2_CENTENA
                    cmpa      #3
                    beq       NUM_3_CENTENA
                    cmpa      #4
                    beq       NUM_4_CENTENA
                    cmpa      #5
                    beq       NUM_5_CENTENA
                    cmpa      #6
                    beq       NUM_6_CENTENA
                    cmpa      #7
                    beq       NUM_7_CENTENA
                    cmpa      #8
                    beq       NUM_8_CENTENA
                    cmpa      #9
                    beq       NUM_9_CENTENA
FIN_CENTENA
                    pulx
                    rts

NUM_1_CENTENA
                    ldx       #CIEN_R             ; DIRECCION DE MEMORIA DE 100
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_2_CENTENA
                    ldx       #DOSCIEN_RTOS       ; DIRECCION DE MEMORIA DE 200
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_3_CENTENA
                    ldx       #TRESCIEN_RTOS      ; DIRECCION DE MEMORIA DE 300
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_4_CENTENA
                    ldx       #CUATROCIEN_RTOS    ; DIRECCION DE MEMORIA DE 400
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_5_CENTENA
                    ldx       #QUINIENTOS         ; DIRECCION DE MEMORIA DE 500
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_6_CENTENA
                    ldx       #SEISCIEN_RTOS      ; DIRECCION DE MEMORIA DE 600
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_7_CENTENA
                    ldx       #SETECIEN_RTOS      ; DIRECCION DE MEMORIA DE 700
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_8_CENTENA
                    ldx       #OCHOCIEN_RTOS      ; DIRECCION DE MEMORIA DE 800
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_9_CENTENA
                    ldx       #NOVECIEN_RTOS      ; DIRECCION DE MEMORIA DE 900
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

CICLO_ESCRITURA
                    ldb       ,x                  ; TOMA CARACTER DEL FCC
                    stb       ,y                  ; ESCRIBE EL CHAR EN LA DIR DE X
                    inx
                    iny                           ; INCREMENTAMOS X Y Y
                    cmpb      #$20                ; ASCII DE ESPACIO
                    bne       CICLO_ESCRITURA     ; MIENTRAS NO ENCONTREMOS UN PUNTO(.) SE REPITE
                    dey
                    rts

ESCRIBE_DECENA
                    pshx
                    lda       ,x
                    suba      #$30
                    cmpa      #1
                    beq       NUM_1_DECENA
                    cmpa      #2
                    beq       NUM_2_DECENA
                    cmpa      #3
                    beq       NUM_3_DECENA
                    cmpa      #4
                    beq       NUM_4_DECENA
                    cmpa      #5
                    beq       NUM_5_DECENA
                    cmpa      #6
                    beq       NUM_6_DECENA
                    cmpa      #7
                    beq       NUM_7_DECENA
                    cmpa      #8
                    beq       NUM_8_DECENA
                    cmpa      #9
                    beq       NUM_9_DECENA
FIN_DECENA
                    pulx
                    rts

NUM_1_DECENA
                    ldx       #DIEZ_R             ; DIRECCION DE MEMORIA DE 10
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_2_DECENA
                    ldx       #VEINTE_R           ; DIRECCION DE MEMORIA DE 20
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_3_DECENA
                    ldx       #TREINTA_R          ; DIRECCION DE MEMORIA DE 30
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_4_DECENA
                    ldx       #CUARENTA_R         ; DIRECCION DE MEMORIA DE 40
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_5_DECENA
                    ldx       #CINCUENTA_R        ; DIRECCION DE MEMORIA DE 50
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_6_DECENA
                    ldx       #SESENTA_R          ; DIRECCION DE MEMORIA DE 60
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_7_DECENA
                    ldx       #SETENTA_R          ; DIRECCION DE MEMORIA DE 70
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_8_DECENA
                    ldx       #OCHENTA_R          ; DIRECCION DE MEMORIA DE 80
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_9_DECENA
                    ldx       #NOVENTA_R          ; DIRECCION DE MEMORIA DE 90
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

ESCRIBE_UNIDAD
                    pshx
                    lda       ,x
                    suba      #$30
                    cmpa      #1
                    beq       NUM_1_UNIDAD
                    cmpa      #2
                    beq       NUM_2_UNIDAD
                    cmpa      #3
                    beq       NUM_3_UNIDAD
                    cmpa      #4
                    beq       NUM_4_UNIDAD
                    cmpa      #5
                    beq       NUM_5_UNIDAD
                    cmpa      #6
                    beq       NUM_6_UNIDAD
                    cmpa      #7
                    beq       NUM_7_UNIDAD
                    cmpa      #8
                    beq       NUM_8_UNIDAD
                    cmpa      #9
                    beq       NUM_9_UNIDAD
FIN_UNIDAD
                    pulx
                    rts

NUM_1_UNIDAD
                    ldx       #UNO_R              ; DIRECCION DE MEMORIA DE 1
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_2_UNIDAD
                    ldx       #DOS_R              ; DIRECCION DE MEMORIA DE 2
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_3_UNIDAD
                    ldx       #TRES_R             ; DIRECCION DE MEMORIA DE 3
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_4_UNIDAD
                    ldx       #CUATRO_R           ; DIRECCION DE MEMORIA DE 4
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_5_UNIDAD
                    ldx       #CINCO_R            ; DIRECCION DE MEMORIA DE 5
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_6_UNIDAD
                    ldx       #SEIS_R             ; DIRECCION DE MEMORIA DE 6
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_7_UNIDAD
                    ldx       #SIETE_R            ; DIRECCION DE MEMORIA DE 7
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_8_UNIDAD
                    ldx       #OCHO_R             ; DIRECCION DE MEMORIA DE 8
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_9_UNIDAD
                    ldx       #NUEVE_R            ; DIRECCION DE MEMORIA DE 9
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

;***********************************
; ATENCION A INTERRUPCION SERIAL
;***********************************
                    org       $F100
                    lda       SCSR
                    lda       SCDR
                    sta       ORDEN
                    rti

;***********************************
; VECTOR INTERRUPCION SERIAL
;***********************************
                    org       $FFD6
                    fcb       $F1,$00

;***********************************
; *RESET
;***********************************
                    org       $FFFE
RESET               fcb       $80,$00
;***********************************

                    end       $8000
