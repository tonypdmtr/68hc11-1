                    #MaxLabel 20
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

; *DECLARACION DE VARIABLES PARA NUMEROS ROMANOS
ORDEN               equ       $0000
M                   equ       $0016               ; *BANDERA DE LETRAS M
D                   equ       $0017               ; *BANDERA DE LETRA D
C                   equ       $0018               ; *BANDERA DE LETRA C
L                   equ       $0019               ; *BANDERA DE LETRA L
XB                  equ       $0020               ; *BANDERA DE LETRA X
V                   equ       $0021               ; *BANDERA DE LETRA U
I                   equ       $0022               ; *BANDERA DE LETRA I
O                   equ       $0023               ; *BANDERA DEL OK
A                   equ       $0001               ; *BANDERA FIN DE CADENA
BERROR              equ       $0002               ; BANDERA DE ERROR
UNIDAD              equ       $0053               ; DIRECCION PARA ESCRIBIR UNIDADES
DECENA              equ       $0052               ; DIRECCION PARA ESCRIBIR DECENAS
CENTENA             equ       $0051               ; DIRECCION PARA ESCRIBIR CENTENA
MIL                 equ       $0050               ; DIRECCION PARA ESCRIBIR UNIDADES DE MILLAR

; *DECLARACION DE VARIABLES PARA NUMEROS ARABIGOS
DIR_RESULTADO       equ       $0050
DIR_INPUT           equ       $0030
DIR_TEXTUAL         equ       $0070
BANDERA_TIPO_TRADUCCION equ       $0024

NUMCARAC            equ       $0010
BERROR2             equ       $0003               ; ESTA CREO QUE NO SE USA...
BANDERA_ERROR       equ       $0011               ; BANDERA DE ERROR PARA ARABIGOS
BANDERA_TRADUCCION  equ       $0012               ; BANDERA PARA SABER QUE TRADUCCION ES
CONTADOR            equ       $0028
CONTADOR_EXT        equ       $0010
; *--------------------------------------
;  ESPACIO PARA LAS CADENAS A MOSTRAR
; *--------------------------------------
                    org       $3000
MENSAJE_E_ROMANO    fcc       'ERROR, NUMERO ROMANO INVALIDO.'  ; *29 CARACTERES
MENSAJE_E_ARABIGO   fcc       'ERROR, NUMERO ARABIGO INVALIDO.'  ; *30
MENSAJE_E_RANGO     fcc       'ERROR, NUMERO FUERA DE RANGO.'  ; *28
; *--------------------------------------
; FCC PARA LA TRADUCCION A LETRAS
; *--------------------------------------
UNO_L               fcc       'uno  '
DOS_L               fcc       'dos '
TRES_L              fcc       'tres '
CUATRO_L            fcc       'cuatro '
CINCO_L             fcc       'cinco '
SEIS_L              fcc       'seis '
SIETE_L             fcc       'siete '
OCHO_L              fcc       'ocho '
NUEVE_L             fcc       'nueve '
DIECI_L             fcc       'dieci '
DIEZ_L              fcc       'diez '
ONCE_L              fcc       'once '
DOCE_L              fcc       'doce '
TRECE_L             fcc       'trece '
CATORCE_L           fcc       'catorce '
QUINCE_L            fcc       'quince '
DIECISEIS_L         fcc       'diecisEis '
DIECISIETE_L        fcc       'diecisiete '
DIECIOCHO_L         fcc       'dieciocho '
DIECINUEVE_L        fcc       'diecinueve '
VEINTE_L            fcc       'veinte '
VEINTIUNO_L         fcc       'veintiuno '
VEINTIDOS_L         fcc       'veintidOs'
VEINTITRES_L        fcc       'veintitrEs'
VEINTICUATRO_L      fcc       'veinticuatro '
VEINTICINCO_L       fcc       'veinticinco '
VEINTISEIS_L        fcc       'veintisEis '
VEINTISIETE_L       fcc       'veintisiete '
VEINTIOCHO_L        fcc       'veintiocho '
VEINTINUEVE_L       fcc       'veintinueve '
Y_L                 fcc       'y '
TREINTA_L           fcc       'treinta '
CUARENTA_L          fcc       'cuarenta '
CINCUENTA_L         fcc       'cincuenta '
SESENTA_L           fcc       'sesenta '
SETENTA_L           fcc       'setenta '
OCHENTA_L           fcc       'ochenta '
NOVENTA_L           fcc       'noventa '
CIEN_L              fcc       'cien '
CIENTO_L            fcc       'ciento '
CIENTOS_L           fcc       'cientos '
QUINIENTOS_L        fcc       'quinientos '
SETECIENTOS_L       fcc       'setecientos '
NOVECIENTOS_L       fcc       'novecientos '
MIL_L               fcc       'mil '
; *--------------------------------------
;  FCC PARA LA TRADUCCION ARABIGO - ROMANO
; *--------------------------------------
CIEN                fcc       'C '                ; *100
DOSCIENTOS          fcc       'CC '               ; *200
TRESCIENTOS         fcc       'CCC '              ; *300
CUATROCIENTOS       fcc       'CD '               ; *400
QUINIENTOS          fcc       'D '                ; *500
SEISCIENTOS         fcc       'DC '               ; *600
SETECIENTOS         fcc       'DCC '              ; *700
OCHOCIENTOS         fcc       'DCCC '             ; *800
NOVECIENTOS         fcc       'CM '               ; *900
DIEZ                fcc       'X '                ; *10
VEINTE              fcc       'XX '               ; *20
TREINTA             fcc       'XXX '              ; *30
CUARENTA            fcc       'XL '               ; *40
CINCUENTA           fcc       'L '                ; *50
SESENTA             fcc       'LX '               ; *60
SETENTA             fcc       'LXX '              ; *70
OCHENTA             fcc       'LXXX '             ; *80
NOVENTA             fcc       'XC '               ; *90
UNO                 fcc       'I '                ; *1
DOS                 fcc       'II '               ; *2
TRES                fcc       'III '              ; *3
CUATRO              fcc       'IV '               ; *4
CINCO               fcc       'V '                ; *5
SEIS                fcc       'VI '               ; *6
SIETE               fcc       'VII '              ; *7
OCHO                fcc       'VIII '             ; *8
NUEVE               fcc       'IX '               ; *9

                    org       $8000
INICIO
                    lds       #$00FF              ; Configuracion del puerto serial
                    jsr       SERIAL              ; SUBRUTINA PARA CONFIG EL PUERTO SERIAL
                    jsr       LIMPIEZA
                    jsr       INICIALIZAR

CICLATE1
                    lda       #'?'
                    sta       ORDEN
CICLO
                    lda       ORDEN
                    cmpa      #'?'
                    beq       CICLO

ENTRADA
                    cmpa      #61                 ; *Valida que le llegue un = para saber que es fin de la cadena que mete el usuario
                    beq       TRADUCCION_A_ROMANO

                    cmpa      #'O'                ; *CASO EN QUE RECIBA OK
                    beq       CASOO_ARABIGO
                    cmpa      #'K'
                    beq       CASOOK_ARABIGO      ; *CASO EN QUE RECIBA UNA K

                    jsr       VALIDACION_ARABIGO  ; *REGRESA UN 1 EN B SI ES ARABIGO
                    cmpb      #1
                    bne       ENTRADA_INTERMEDIO_ROMANO

                    ldb       NUMCARAC
                    cmpb      #3
                    bhi       ERROR_CANTIDAD      ; *POR SI YA LLEGARON LOS 4 CARACTERES ES UN ERROR

                    incb
                    stb       NUMCARAC            ; *INCREMENTAMOS EL DE CARACTERES

                    sta       ,x
                    inx                           ; *CAMBIAMOS EL CONTADOR DE LA SIGUIENTE MEMORIA A ESCRIBIR

                    bra       CICLATE1

ENTRADA_INTERMEDIO_ROMANO

                    ldb       #2
                    stb       BANDERA_TIPO_TRADUCCION
                    jmp       ENTRADA_ROMANO

CASOO_ARABIGO
                    ldb       O
                    incb
                    stb       O
                    bra       CICLATE1

CASOOK_ARABIGO
                    ldb       O
                    cmpb      #0
                    beq       ERROR_CANTIDAD
                    bsr       INICIALIZAR
; *JSR LIMPIEZA
                    bra       CICLATE1

TRADUCCION_A_ROMANO
                    ldb       #1
                    stb       BANDERA_TIPO_TRADUCCION

                    lda       BANDERA_ERROR
                    cmpa      #1
                    beq       CICLATE1
                    ldy       #DIR_RESULTADO      ; *DIRECCION DE ESCRITURA
                    ldx       #DIR_INPUT          ; *DIRECCION DE NUMS
                    lda       NUMCARAC            ; *COMPARAMOS EL NUMERO DE CARACTERES
                    cmpa      #1
                    beq       CASO_UNIDAD
                    cmpa      #2
                    beq       CASO_DECENA
                    cmpa      #3
                    beq       CASO_CENTENA
                    cmpa      #4
                    beq       CASO_MILLAR

                    bra       CICLATE1            ; *POR SI NO SE VALIDA BIEN

CASO_MILLAR

                    ldb       ,x                  ; *TOMAR EL PRIMER NUM CHAR Y PONERLO EN B
                    cmpb      #$31                ;
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
                    bsr       ESCRIBE_CENTENA
                    inx
CASO_DECENA
; GUARDA EN A, EL VALOR DE X
                    jsr       ESCRIBE_DECENA
                    inx
CASO_UNIDAD
                    jsr       ESCRIBE_UNIDAD
                    jmp       MUCHO_TEXTO

                    jmp       CICLATE1

ERROR_CANTIDAD
                    ldx       #DIR_RESULTADO      ; DIRECCION DEL MENSAJE
                    ldy       #MENSAJE_E_RANGO    ; ORG DE LOS FCC
                    bsr       ERROR
                    jmp       CICLATE1

INICIALIZAR
                    ldx       #DIR_INPUT
                    ldy       #DIR_RESULTADO      ; *ES 50
                    clr       BANDERA_TIPO_TRADUCCION
                    clr       O
                    clr       UNO
                    clr       BERROR2             ; *DEJA EN CERO LAS VARIABLES
                    clr       NUMCARAC
                    clr       BANDERA_ERROR
LIMONES
                    ldb       #00
                    stb       ,y
                    iny
                    cpy       #$00C0
                    bne       LIMONES
                    ldy       #DIR_INPUT          ;** LA 30
LIMAS
                    ldb       #00
                    stb       ,y
                    iny
                    cpy       #$0040
                    bne       LIMAS
                    rts

VALIDACION_ARABIGO
                    cmpa      #$30                ; *Valor 0
                    blo       ERROR_ARABIGO
                    cmpa      #$3A                ; Valor 9
                    bhi       ERROR_ARABIGO
                    ldb       #1
FIN_VALIDACION_ARABIGO

                    rts

ERROR_ARABIGO
                    ldb       #4
                    bra       FIN_VALIDACION_ARABIGO

ERROR
                    ldb       #1
                    stb       BANDERA_ERROR
ERROR_CICLO1
                    ldb       ,y                  ; *TOMA CARACTER DEL FCC
                    stb       ,x                  ; *ESCRIBE EL CHAR EN LA DIR DE X
                    inx
                    iny                           ; INCREMENTAMOS X Y Y
                    cmpb      #46                 ; ASCII DE PUNTO
                    bne       ERROR_CICLO1        ; MIENTRAS NO ENCONTREMOS UN PUNTO(.) SE REPITE
                    rts

ESCRIBE_CENTENA
                    pshx      *                   ; RESPALDA/COPIA EL VALOR DE X
                    lda       ,x                  ; GUARDA EN A, EL CARACTER DE X
                    suba      #$30                ; RESTA 30 PARA VER QUE NUMERO ES
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
                    ldx       #CIEN               ; DIRECCION DE MEMORIA DE 100
; *LDY #CIEN_L
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_2_CENTENA
                    ldx       #DOSCIENTOS         ; DIRECCION DE MEMORIA DE 200
; *LDY #DOS_L
; *LDY #MIL_L
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_3_CENTENA
                    ldx       #TRESCIENTOS        ; DIRECCION DE MEMORIA DE 300
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_4_CENTENA
                    ldx       #CUATROCIENTOS      ; DIRECCION DE MEMORIA DE 400
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_5_CENTENA
                    ldx       #QUINIENTOS         ; DIRECCION DE MEMORIA DE 500
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_6_CENTENA
                    ldx       #SEISCIENTOS        ; DIRECCION DE MEMORIA DE 600
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_7_CENTENA
                    ldx       #SETECIENTOS        ; DIRECCION DE MEMORIA DE 700
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_8_CENTENA
                    ldx       #OCHOCIENTOS        ; DIRECCION DE MEMORIA DE 800
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_9_CENTENA
                    ldx       #NOVECIENTOS        ; DIRECCION DE MEMORIA DE 900
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

CICLO_ESCRITURA
                    ldb       ,x                  ; TOMA CARACTER DEL FCC
                    stb       ,y                  ; ESCRIBE EL CHAR EN LA DIR DE Y
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
                    ldx       #DIEZ               ; DIRECCION DE MEMORIA DE 10
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_2_DECENA
                    ldx       #VEINTE             ; DIRECCION DE MEMORIA DE 20
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_3_DECENA
                    ldx       #TREINTA            ; DIRECCION DE MEMORIA DE 30
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_4_DECENA
                    ldx       #CUARENTA           ; DIRECCION DE MEMORIA DE 40
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_5_DECENA
                    ldx       #CINCUENTA          ; DIRECCION DE MEMORIA DE 50
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_6_DECENA
                    ldx       #SESENTA            ; DIRECCION DE MEMORIA DE 60
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_7_DECENA
                    ldx       #SETENTA            ; DIRECCION DE MEMORIA DE 70
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_8_DECENA
                    ldx       #OCHENTA            ; DIRECCION DE MEMORIA DE 80
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_9_DECENA
                    ldx       #NOVENTA            ; DIRECCION DE MEMORIA DE 90
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
                    ldx       #UNO                ; DIRECCION DE MEMORIA DE 1
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_2_UNIDAD
                    ldx       #DOS                ; DIRECCION DE MEMORIA DE 2
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_3_UNIDAD
                    ldx       #TRES               ; DIRECCION DE MEMORIA DE 3
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_4_UNIDAD
                    ldx       #CUATRO             ; DIRECCION DE MEMORIA DE 4
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_5_UNIDAD
                    ldx       #CINCO              ; DIRECCION DE MEMORIA DE 5
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_6_UNIDAD
                    ldx       #SEIS               ; DIRECCION DE MEMORIA DE 6
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_7_UNIDAD
                    ldx       #SIETE              ; DIRECCION DE MEMORIA DE 7
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_8_UNIDAD
                    ldx       #OCHO               ; DIRECCION DE MEMORIA DE 8
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_9_UNIDAD
                    ldx       #NUEVE              ; DIRECCION DE MEMORIA DE 9
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

;***********************************************************************************
;***********************************************************************************
;***********************************************************************************
;***********************************************************************************
;                   TRADUCCION DE ROMANO
;***********************************************************************************
;***********************************************************************************
;***********************************************************************************
;***********************************************************************************

CICLATE
                    lda       #'?'
                    sta       ORDEN
CUENTA
                    lda       ORDEN
                    cmpa      #'?'
                    beq       CUENTA

ENTRADA_ROMANO
                    ldb       NUMCARAC
                    cmpb      #0
                    bne       ERROR1
                    cmpa      #'M'
                    beq       CASOM
                    cmpa      #'D'
                    beq       CASOD
                    bra       SALTOINTERMEDIO1

ERROR1
                    jsr       ERROR_ESCRITURA
                    jmp       FIN

CASOM
                    ldb       C                   ; *Verifica que le haya llegado una C ANTES para el caso de CM
                    cmpb      #0
                    bne       CASOM1

                    ldb       M
                    cmpb      #8                  ; *Verifica que no sean más de 9 M's
                    bhi       ERROR1

                    jsr       D_ERROR

                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx
                    ldb       M
                    incb
                    stb       M
                    ldb       MIL
                    incb
                    stb       MIL
                    bra       CICLATE

; *CASO DONDE LLEGUE CM
CASOM1
                    cmpb      #1                  ; *Compara si hay una segunda C
                    bhi       ERROR1
                    addb      #5
                    stb       C                   ; *Carga en C el valor de 5
                    ldb       #9
                    stb       CENTENA             ; *Carga en las centenas el valor de 9
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx                           ; *Aumenta la X en 1
                    bra       CICLATE             ; *Regresa a esperar

CASOD

                    jsr       L_ERROR
                    ldb       D
                    incb
                    stb       D
                    cmpb      #2
                    beq       ERROR1              ; *VALIDA QUE NO LLEGUEN 2 O MÁS D's
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx
                    ldb       C
                    cmpb      #0
                    bne       CASOD1
                    ldb       #5
                    stb       CENTENA
                    bra       CICLATE

CASOD1
;***** CASO CD
                    cmpb      #1
                    bhi       ERROR_1             ; *Compara si hay más de una C
                    addb      #5
                    stb       C                   ; *Carga en C el valor de 5, ¿porque? ####
                    ldb       #4
                    stb       CENTENA             ; *Carga en las centenas el valor de 4
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx                           ; *Aumenta la X en 1
                    bra       CICLATE             ; *Regresa a esperar

SALTOINTERMEDIO1
                    cmpa      #'C'
                    beq       CASOC
                    cmpa      #'L'
                    beq       CASOL
                    bra       SALTOINTERMEDIO

; *C ES UNA BANDERA A FUTURO PARA ERRORES
CASOC
                    ldb       XB                  ; *VERIFICA QUE LLEGUE UN XC
                    cmpb      #0
                    bne       CASOC1
                    ldb       C
                    cmpb      #4
                    bhi       ERROR_1

                    jsr       L_ERROR

                    ldb       C
                    incb
                    stb       C
                    cmpb      #4
                    beq       ERROR_1             ; *VALIDA QUE NO LLEGUEN 4 O MÁS C's
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx
                    ldb       CENTENA
                    incb
                    stb       CENTENA
                    jmp       CICLATE

; *CASO POR SI LLEGA UN XC
CASOC1
                    cmpb      #1
                    bhi       ERROR_1             ; SI ES HAY MÁS DE UNA C ES ERROR
                    addb      #5                  ; *PARA FUTURO ERROR XCX
                    stb       XB
                    ldb       #9
                    stb       DECENA
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx
                    jmp       CICLATE

ERROR_1
                    jsr       ERROR_ESCRITURA
                    jmp       FIN

CASOL
                    ldb       XB
                    cmpb      #0
                    bne       CASOL1
                    jsr       V_ERROR
                    ldb       L
                    incb
                    stb       L
                    cmpb      #2
                    beq       ERROR_1             ; *VALIDA QUE NO LLEGUEN 2 O MÁS L's
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx
                    ldb       #5
                    stb       DECENA

                    jmp       CICLATE

; *PARA CUANDO LLEGA XL
CASOL1
                    cmpb      #1
                    bhi       ERROR_1             ; *Compara si hay más de una X
                    addb      #5
                    stb       XB                  ; *Suma en X el valor de 5, ¿porque? ####
                    ldb       #4
                    stb       DECENA              ; *Carga en las centenas el valor de 4
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx                           ; *Siguiente Direccion de escritura
                    jmp       CICLATE             ; *Regresa a esperar

;**********SALTO INTERMEDIO
SALTOINTERMEDIO
                    cmpa      #'X'
                    beq       CASOX
                    cmpa      #'V'
                    beq       CASOV
                    cmpa      #'I'
                    beq       CASOI

                    bra       SALTOINTERMEDIO2

CASOX
                    jsr       V_ERROR
                    ldb       I
                    cmpb      #0                  ; *VALIDA EL CASO IX
                    bne       CASOX1
                    ldb       XB
                    incb
                    stb       XB
                    cmpb      #3
                    bhi       ERROR_1
                    ldb       V
                    cmpb      #0                  ; *VALIDA QUE NO HAYA V's ANTES DE LA X
                    bne       ERROR_1

                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx
                    ldb       DECENA
                    incb
                    stb       DECENA
                    jmp       CICLATE

ERROR_2
                    jsr       ERROR_ESCRITURA
                    jmp       FIN

; *CUANDO LLEGUE UN IX
CASOX1
                    cmpb      #1
                    bhi       ERROR_1
                    addb      #6
                    stb       I
                    ldb       #9
                    stb       UNIDAD
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx
                    jmp       CICLATE

CASOV
                    ldb       I
                    cmpb      #0
                    bne       CASOV1
                    ldb       V
                    incb
                    stb       V
                    cmpb      #2
                    beq       ERROR_2             ; *VALIDA QUE NO LLEGUEN 2 O MÁS V's     _2
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx
                    ldb       #5
                    stb       UNIDAD
                    jmp       CICLATE

; *CUANDO LLEGUE UN IV
CASOV1
                    cmpb      #1
                    bhi       ERROR_2
                    addb      #6
                    stb       I
                    ldb       #4
                    stb       UNIDAD
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx
                    jmp       CICLATE

SALTOINTERMEDIO2
                    cmpa      #'O'                ; *CASO EN QUE RECIBA OK
                    beq       CASOO
                    cmpa      #'K'
                    beq       CASOOK
                    cmpa      #61                 ; *Valida que le llegue un = para saber que es fin de la cadena que mete el usuario
                    beq       ESCRIBECHAR
                    bra       SALTOINTERMEDIO1_ERROR

CASOI

                    ldb       I
                    incb
                    stb       I
                    cmpb      #3
                    bhi       ERROR_2
                    sta       ,x                  ; *Escribir a partir de la memoria $70 lo que le mande el usuario
                    inx
                    ldb       UNIDAD
                    incb
                    stb       UNIDAD
                    jmp       CICLATE

CASOO
                    ldb       O
                    incb
                    stb       O
                    bra       FIN

CASOOK
                    ldb       O
                    cmpb      #0
                    bne       LIMPIEZA_SALTO      ; Si existe una O
                    jmp       CICLATE1

LIMPIEZA_SALTO
                    jsr       LIMPIEZA
                    jsr       INICIALIZAR
                    jmp       CICLATE1

SALTOINTERMEDIO1_ERROR

                    jmp       ERROR1

ESCRIBECHAR
                    ldb       BERROR
                    cmpb      #1
                    beq       SALTOINTERMEDIO1_ERROR
                    ldb       #48                 ; Es el ascii de 0 en decimal
                    lda       MIL
                    aba
                    sta       MIL
                    lda       CENTENA
                    aba
                    sta       CENTENA
                    lda       DECENA
                    aba
                    sta       DECENA
                    lda       UNIDAD
                    aba
                    sta       UNIDAD
                    jmp       MUCHO_TEXTO

FIN
                    lda       #'?'
                    sta       ORDEN
CICLO1
                    lda       ORDEN
                    cmpa      #'?'

                    beq       CICLO1
                    cmpa      #'O'
                    beq       CASOO
                    cmpa      #'K'
                    beq       CASOOK
                    bra       FIN

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

ERROR_ESCRITURA
                    ldb       BERROR
                    incb
                    stb       BERROR
                    ldx       #DIR_RESULTADO      ; DIRECCION DEL MENSAJE
                    ldy       #$3000              ; ORG DE LOS FCC
ERROR_CICLO
                    ldb       ,y
                    stb       ,x
                    inx
                    iny
                    cmpb      #46                 ; ASCII DE PUNTO
                    bne       ERROR_CICLO
                    rts

ERROR_SALTO
                    bsr       ERROR_ESCRITURA
                    bra       FIN_ERROR

D_ERROR
                    ldb       D
                    cmpb      #0                  ; *VALIDA QUE NO HAYA D's ANTES DE LA M
                    bne       ERROR_SALTO

                    cmpa      #'M'
                    beq       L_ERROR             ; VALIDAR QUE M SI PUEDE TENER UNA C ANTES
C_ERROR
                    ldb       C
                    cmpb      #0                  ; *VALIDA QUE NO HAYA D's ANTES DE LA M
                    bne       ERROR_SALTO
L_ERROR
                    ldb       L
                    cmpb      #0                  ; *VALIDA QUE NO HAYA L's ANTES DE LA M
                    bne       ERROR_SALTO
                    cmpa      #'C'
                    beq       V_ERROR             ; VALIDAR QUE C SI PUEDE TENER UNA X ANTES
X_ERROR
                    ldb       XB
                    cmpb      #0                  ; *VALIDA QUE NO HAYA X's ANTES DE LA M
                    bne       ERROR_SALTO
V_ERROR
                    ldb       V
                    cmpb      #0                  ; *VALIDA QUE NO HAYA V's ANTES DE LA M
                    bne       ERROR_SALTO
                    cmpa      #'X'
                    beq       FIN_ERROR           ; VALIDAR QUE X SI PUEDE TENER UNA I ANTES
I_ERROR
                    ldb       I
                    cmpb      #0                  ; *VALIDA QUE NO HAYA I's ANTES DE LA M
                    bne       ERROR_SALTO
FIN_ERROR
                    rts

LIMPIEZA
                    clr       M
                    clr       D
                    clr       C
                    clr       L
                    clr       XB
                    clr       V
                    clr       I
                    clr       A
                    clr       NUMCARAC
                    clr       BANDERA_TIPO_TRADUCCION
                    clr       BERROR
                    clr       UNIDAD
                    clr       DECENA
                    clr       CENTENA
                    clr       MIL
                    clr       BANDERA_TRADUCCION
                    ldx       #DIR_RESULTADO
                    ldy       #DIR_INPUT
LIM
                    ldb       #00
                    stb       ,y                  ;** EMPIEZA EN LA $50
                    iny
                    cpy       #$00C0              ;** TERMINA EN LA 70
                    bne       LIM
                    ldy       #DIR_INPUT          ;** EMPIEZA EN LA 30
LIM2
                    ldb       #00
                    stb       ,y
                    iny
                    cpy       #$0040              ;** TERMINA EN LA 40
                    bne       LIM2
                    rts

ORIGEN_ARABIGO
; JSR DESPLAZA_ARABIGOS
                    ldy       #DIR_INPUT          ;** EL INPUT
                    bra       ESCRIBE_MUCHO_TEXTO

ORIGEN_ROMANO
                    ldy       #DIR_RESULTADO      ;** LA TRADUCCION
                    lda       ,y
                    bra       ENTRADA_MILES

ENTRADA_INTERMEDIA_UNIDADES

                    jmp       ENTRADA_UNIDADES

ENTRADA_INTERMEDIA_DECENAS

                    jmp       ENTRADA_DECENAS

ENTRADA_INTERMEDIA_CENTENAS

                    jmp       ENTRADA_CENTENAS

;**SUBRUTINA PARA ESCRIBIR LOS NUMEROS TEXTUALES
MUCHO_TEXTO
                    ldb       BANDERA_TIPO_TRADUCCION
                    cmpb      #1
                    beq       ORIGEN_ARABIGO
                    cmpb      #2
                    beq       ORIGEN_ROMANO
ESCRIBE_MUCHO_TEXTO
                    ldx       #DIR_TEXTUAL
                    ldb       NUMCARAC
                    stb       $00A0
                    cmpb      #1
                    beq       ENTRADA_INTERMEDIA_UNIDADES
                    cmpb      #2
                    beq       ENTRADA_INTERMEDIA_DECENAS
                    cmpb      #3
                    beq       ENTRADA_INTERMEDIA_CENTENAS
ENTRADA_MILES
                    ldx       #DIR_TEXTUAL
                    ldb       ,y                  ;** CARACTER
                    pshy
                    cmpb      #'0'
                    beq       ESCRIBE_MIL_FIN
                    cmpb      #'1'
                    beq       ESCRIBE_MIL
                    cmpb      #'2'
                    beq       ESCRIBE_DOS_MIL
                    cmpb      #'3'
                    beq       ESCRIBE_TRES_MIL
                    cmpb      #'4'
                    beq       ESCRIBE_CUATRO_MIL
                    cmpb      #'5'
                    beq       ESCRIBE_CINCO_MIL
                    cmpb      #'6'
                    beq       ESCRIBE_SEIS_MIL
                    cmpb      #'7'
                    beq       ESCRIBE_SIETE_MIL
                    cmpb      #'8'
                    beq       ESCRIBE_OCHO_MIL
                    cmpb      #'9'
                    beq       ESCRIBE_NUEVE_MIL

ESCRIBE_MIL_FIN
                    puly
                    iny
                    bra       ENTRADA_CENTENAS

ESCRIBE_MIL
                    ldy       #MIL_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_MIL_FIN

ESCRIBE_DOS_MIL
                    ldy       #DOS_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_TRES_MIL
                    ldy       #TRES_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_CUATRO_MIL
                    ldy       #CUATRO_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_CINCO_MIL
                    ldy       #CINCO_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_SEIS_MIL
                    ldy       #SEIS_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_SIETE_MIL
                    ldy       #SIETE_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_OCHO_MIL
                    ldy       #OCHO_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_NUEVE_MIL
                    ldy       #NUEVE_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_MIL

ENTRADA_CENTENAS
                    ldb       ,y                  ;** CARACTER
                    pshy
                    cmpb      #'0'
                    beq       ESCRIBE_CIENTOS_FIN
                    cmpb      #'1'
                    beq       ESCRIBE_CIEN
                    cmpb      #'2'
                    beq       ESCRIBE_DOS_CIENTOS
                    cmpb      #'3'
                    beq       ESCRIBE_TRES_CIENTOS
                    cmpb      #'4'
                    beq       ESCRIBE_CUATRO_CIENTOS
                    cmpb      #'5'
                    beq       ESCRIBE_CINCO_CIENTOS
                    bra       OTRAS_CENTENAS

ESCRIBE_CIENTOS
                    ldy       #CIENTOS_L
                    jsr       CICLO_MUCHO_TEXTO
ESCRIBE_CIENTOS_FIN
                    puly
                    iny
                    jmp       ENTRADA_DECENAS

ESCRIBE_CIEN
; *CHECAMOS DECENAS
                    puly
                    iny
                    ldb       ,y
                    cmpb      #'0'
                    bne       ESCRIBE_CIENTO_DEC
                    dey
                    pshy
; CHECAMOS UNIDADES
                    puly
                    iny
                    iny
                    ldb       ,y
                    cmpb      #'0'
                    bne       ESCRIBE_CIENTO_UNI
                    dey
                    dey
                    pshy
                    ldy       #CIEN_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_CIENTOS_FIN

ESCRIBE_CIENTO_DEC
                    dey
                    pshy
                    bra       ESCRIBE_CIENTO

ESCRIBE_CIENTO_UNI
                    dey
                    dey
                    pshy

ESCRIBE_CIENTO
                    ldy       #CIENTO_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_CIENTOS_FIN

ESCRIBE_DOS_CIENTOS
                    ldy       #DOS_L
                    jsr       CICLO_MUCHO_TEXTO
                    dex
                    bra       ESCRIBE_CIENTOS

ESCRIBE_TRES_CIENTOS

                    ldy       #TRES_L
                    jsr       CICLO_MUCHO_TEXTO
                    dex
                    bra       ESCRIBE_CIENTOS

ESCRIBE_CUATRO_CIENTOS

                    ldy       #CUATRO_L
                    jsr       CICLO_MUCHO_TEXTO
                    dex
                    bra       ESCRIBE_CIENTOS

ESCRIBE_CINCO_CIENTOS

                    ldy       #QUINIENTOS_L
                    jsr       CICLO_MUCHO_TEXTO
                    bra       ESCRIBE_CIENTOS_FIN

OTRAS_CENTENAS
                    cmpb      #'6'
                    beq       ESCRIBE_SEIS_CIENTOS
                    cmpb      #'7'
                    beq       ESCRIBE_SIETE_CIENTOS
                    cmpb      #'8'
                    beq       ESCRIBE_OCHO_CIENTOS
                    cmpb      #'9'
                    beq       ESCRIBE_NUEVE_CIENTOS
                    jmp       ESCRIBE_CIENTOS

ESCRIBE_SEIS_CIENTOS

                    ldy       #SEIS_L
                    jsr       CICLO_MUCHO_TEXTO
                    dex
                    jmp       ESCRIBE_CIENTOS

ESCRIBE_SIETE_CIENTOS

                    ldy       #SETECIENTOS_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       ESCRIBE_CIENTOS_FIN

ESCRIBE_OCHO_CIENTOS

                    ldy       #OCHO_L
                    jsr       CICLO_MUCHO_TEXTO
                    dex
                    jmp       ESCRIBE_CIENTOS

ESCRIBE_NUEVE_CIENTOS

                    ldy       #NOVECIENTOS_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       ESCRIBE_CIENTOS_FIN

ENTRADA_DECENAS
                    ldb       ,y                  ;** CARACTER
                    pshy
                    cmpb      #'0'
                    beq       FIN_ENTRADA_DECENAS
                    cmpb      #'1'
                    beq       ESCRIBE_DIECI
                    cmpb      #'2'
                    beq       ESCRIBE_VEINTI
                    jmp       COMPARA_TANTOS

FIN_ENTRADA_DECENAS
                    puly
                    iny
                    jmp       ENTRADA_UNIDADES

ESCRIBE_DIECI
                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       ESCRIBE_DIEZ
                    cmpb      #'1'
                    beq       ESCRIBE_ONCE
                    cmpb      #'2'
                    beq       ESCRIBE_DOCE
                    cmpb      #'3'
                    beq       ESCRIBE_TRECE
                    cmpb      #'4'
                    beq       ESCRIBE_CATORCE
                    cmpb      #'5'
                    beq       ESCRIBE_QUINCE
                    bra       ESCRIBE_DIECI_L

                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_DIEZ
                    ldy       #DIEZ_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_ONCE
                    ldy       #ONCE_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_DOCE
                    ldy       #DOCE_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_TRECE
                    ldy       #TRECE_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_CATORCE
                    ldy       #CATORCE_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_QUINCE
                    ldy       #QUINCE_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_DIECI_L
                    ldy       #DIECI_L
                    jsr       CICLO_MUCHO_TEXTO
                    dex
                    bra       FIN_ENTRADA_DECENAS

ESCRIBE_VEINTI
                    puly                          ;**ESTO SE VE MEDIO RARO
                    iny
                    ldb       ,y                  ;** CARACTER
                    pshy
                    cmpb      #'0'
                    beq       ESCRIBE_VEINTE
                    cmpb      #'1'
                    beq       ESCRIBE_VEINTIUNO
                    cmpb      #'2'
                    beq       ESCRIBE_VEINTIDOS
                    cmpb      #'3'
                    beq       ESCRIBE_VEINTITRES
                    cmpb      #'4'
                    beq       ESCRIBE_VEINTICUATRO
                    cmpb      #'5'
                    beq       ESCRIBE_VEINTICINCO
                    cmpb      #'6'
                    beq       ESCRIBE_VEINTISEIS
                    cmpb      #'7'
                    beq       ESCRIBE_VEINTISIETE
                    cmpb      #'8'
                    beq       ESCRIBE_VEINTIOCHO
                    cmpb      #'9'
                    beq       ESCRIBE_VEINTINUEVE
                    jmp       FIN_MUCHO_TEXTO     ;**SE IRIA AL FIN

; *VEINTES

ESCRIBE_VEINTE
                    ldy       #VEINTE_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_VEINTIUNO
                    ldy       #VEINTIUNO_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_VEINTIDOS
                    ldy       #VEINTIDOS_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_VEINTITRES
                    ldy       #VEINTITRES_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_VEINTICUATRO

                    ldy       #VEINTICUATRO_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_VEINTICINCO
                    ldy       #VEINTICINCO_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_VEINTISEIS
                    ldy       #VEINTISEIS_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_VEINTISIETE
                    ldy       #VEINTISIETE_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_VEINTIOCHO
                    ldy       #VEINTIOCHO_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

ESCRIBE_VEINTINUEVE
                    ldy       #VEINTINUEVE_L
                    jsr       CICLO_MUCHO_TEXTO
                    jmp       FIN_MUCHO_TEXTO

COMPARA_TANTOS
                    cmpb      #'3'
                    beq       ESCRIBE_TREINTA
                    cmpb      #'4'
                    beq       ESCRIBE_CUARENTA
                    cmpb      #'5'
                    beq       ESCRIBE_CINCUENTA
                    cmpb      #'6'
                    beq       ESCRIBE_SESENTA
                    jmp       COMPARA_OTROS_TANTOS

;***TREINTAS

ESCRIBE_TREINTA
                    ldy       #TREINTA_L
                    jsr       CICLO_MUCHO_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_TREINTA

                    ldy       #Y_L
                    jsr       CICLO_MUCHO_TEXTO
FIN_ESCRIBE_TREINTA
                    jmp       FIN_ENTRADA_DECENAS

;**CUARENTAS
ESCRIBE_CUARENTA
                    ldy       #CUARENTA_L
                    jsr       CICLO_MUCHO_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_CUARENTA

                    ldy       #Y_L
                    jsr       CICLO_MUCHO_TEXTO
FIN_ESCRIBE_CUARENTA

                    jmp       FIN_ENTRADA_DECENAS

;**CINCUENTAS
ESCRIBE_CINCUENTA
                    ldy       #CINCUENTA_L
                    jsr       CICLO_MUCHO_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_CINCUENTA

                    ldy       #Y_L
                    jsr       CICLO_MUCHO_TEXTO
FIN_ESCRIBE_CINCUENTA

                    jmp       FIN_ENTRADA_DECENAS

;**SESENTAS
ESCRIBE_SESENTA
                    ldy       #SESENTA_L
                    jsr       CICLO_MUCHO_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_SESENTA

                    ldy       #Y_L
                    jsr       CICLO_MUCHO_TEXTO
FIN_ESCRIBE_SESENTA
                    jmp       FIN_ENTRADA_DECENAS

COMPARA_OTROS_TANTOS

                    cmpb      #'7'
                    beq       ESCRIBE_SETENTA
                    cmpb      #'8'
                    beq       ESCRIBE_OCHENTA
                    cmpb      #'9'
                    beq       ESCRIBE_NOVENTA
                    jmp       FIN_ENTRADA_DECENAS

; *SETENTAS
ESCRIBE_SETENTA
                    ldy       #SETENTA_L
                    jsr       CICLO_MUCHO_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_SETENTA

                    ldy       #Y_L
                    jsr       CICLO_MUCHO_TEXTO
FIN_ESCRIBE_SETENTA
                    jmp       FIN_ENTRADA_DECENAS

; *OCHENTAS
ESCRIBE_OCHENTA
                    ldy       #OCHENTA_L
                    jsr       CICLO_MUCHO_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_OCHENTA

                    ldy       #Y_L
                    jsr       CICLO_MUCHO_TEXTO
FIN_ESCRIBE_OCHENTA
                    jmp       FIN_ENTRADA_DECENAS

; *NOVENTAS
ESCRIBE_NOVENTA
                    ldy       #NOVENTA_L
                    jsr       CICLO_MUCHO_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_NOVENTA

                    ldy       #Y_L
                    bsr       CICLO_MUCHO_TEXTO
FIN_ESCRIBE_NOVENTA
                    jmp       FIN_ENTRADA_DECENAS

ENTRADA_UNIDADES
                    ldb       ,y                  ;** CARACTER
                    pshy
;       CMPB #'0'
;       BEQ CICLO_MUCHO_TEXTO
                    cmpb      #'1'
                    beq       ESCRIBE_UNO
                    cmpb      #'2'
                    beq       ESCRIBE_DOS
                    cmpb      #'3'
                    beq       ESCRIBE_TRES
                    cmpb      #'4'
                    beq       ESCRIBE_CUATRO
                    cmpb      #'5'
                    beq       ESCRIBE_CINCO
                    cmpb      #'6'
                    beq       ESCRIBE_SEIS
                    cmpb      #'7'
                    beq       ESCRIBE_SIETE
                    cmpb      #'8'
                    beq       ESCRIBE_OCHO
                    cmpb      #'9'
                    beq       ESCRIBE_NUEVE

                    bra       FIN_MUCHO_TEXTO

ESCRIBE_UNO
                    ldy       #UNO_L
                    bsr       CICLO_MUCHO_TEXTO
                    bra       FIN_MUCHO_TEXTO

ESCRIBE_DOS
                    ldy       #DOS_L
                    bsr       CICLO_MUCHO_TEXTO
                    bra       FIN_MUCHO_TEXTO

ESCRIBE_TRES
                    ldy       #TRES_L
                    bsr       CICLO_MUCHO_TEXTO
                    bra       FIN_MUCHO_TEXTO

ESCRIBE_CUATRO
                    ldy       #CUATRO_L
                    bsr       CICLO_MUCHO_TEXTO
                    bra       FIN_MUCHO_TEXTO

ESCRIBE_CINCO
                    ldy       #CINCO_L
                    bsr       CICLO_MUCHO_TEXTO
                    bra       FIN_MUCHO_TEXTO

ESCRIBE_SEIS
                    ldy       #SEIS_L
                    bsr       CICLO_MUCHO_TEXTO
                    bra       FIN_MUCHO_TEXTO

ESCRIBE_SIETE
                    ldy       #SIETE_L
                    bsr       CICLO_MUCHO_TEXTO
                    bra       FIN_MUCHO_TEXTO

ESCRIBE_OCHO
                    ldy       #OCHO_L
                    bsr       CICLO_MUCHO_TEXTO
                    bra       FIN_MUCHO_TEXTO

ESCRIBE_NUEVE
                    ldy       #NUEVE_L
                    bsr       CICLO_MUCHO_TEXTO
;                   bra       FIN_MUCHO_TEXTO

;*************************************************

FIN_MUCHO_TEXTO
                    jmp       CICLATE1

YA_MATE_ME_POR_FA_T_T

CICLO_MUCHO_TEXTO
                    ldb       ,y                  ; TOMA CARACTER DEL FCC
                    stb       ,x                  ; ESCRIBE EL CHAR EN LA DIR DE X
                    inx
                    iny                           ; INCREMENTAMOS X Y Y
                    cmpb      #$20                ; ASCII DE ESPACIO
                    bne       CICLO_MUCHO_TEXTO   ; MIENTRAS NO ENCONTREMOS UN PUNTO(.) SE REPITE
                    dey
                    rts

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
