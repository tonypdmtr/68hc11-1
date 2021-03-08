                    #MaxLabel 20
; *PROYECTO TRADUCCION DE NUMERO ROMANO A DECIMAL Y VICEVERSA
; *PARADA PÉREZ JESÚS BRYAN
; *VAN DER WERFF VARGAS PIETER ALEXANDER
; *MAYA ORTEGA MARIA FERNANDA

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
DIRECCION_RESULTADO equ       $0050
DIRECCION_INPUT     equ       $0030
DIRECCION_TEXTUAL   equ       $0070
BANDERA_TIPO_TRADUCCION equ       $0024

NUMCARAC            equ       $0010
BANDERA_ERROR       equ       $0011               ; BANDERA DE ERROR PARA NUMEROS DECIMALES
BANDERA_TRADUCCION  equ       $0012               ; BANDERA PARA IDENTIFICAR LA TRADUCCION
CONTADOR            equ       $0028
CONTADOR_EXT        equ       $0010

ORDEN               equ       $0000
BANDERAM            equ       $0016               ; BANDERA DE LETRAS M (MIL)
BANDERAD            equ       $0017               ; BANDERA DE LETRAS D (QUININETOS)
BANDERAC            equ       $0018               ; BANDERA DE LETRAS C (CIEN)
BANDERAL            equ       $0019               ; BANDERA DE LETRAS L (CINCUENTA)
BANDERAX            equ       $0020               ; BANDERA DE LETRAS X (DIEZ)
BANDERAV            equ       $0021               ; BANDERA DE LETRAS V (CINCO)
BANDERAI            equ       $0022               ; BANDERA DE LETRAS I (UNO)
BANDERAOK           equ       $0023               ; BANDERA DEL OK
BANDERAERROR        equ       $0002               ; BANDERA DE ERROR
UNIDAD              equ       $0053               ; DIRECCION PARA ESCRIBIR UNIDADES
DECENA              equ       $0052               ; DIRECCION PARA ESCRIBIR DECENAS
CENTENA             equ       $0051               ; DIRECCION PARA ESCRIBIR CENTENAS
MIL                 equ       $0050               ; DIRECCION PARA ESCRIBIR UNIDADES DE MIL

                    org       $3000
MENSAJE_E_ROMANO    fcc       'ERROR, NUMERO ROMANO INVALIDO.'
MENSAJE_E_DECIMAL   fcc       'ERROR, NUMERO DECIMAL INVALIDO.'
MENSAJE_E_RANGO     fcc       'ERROR, NUMERO FUERA DE RANGO.'

; NUMEROS DECIMALES

UNO_D               fcc       'uno  '
DOS_D               fcc       'dos '
TRES_D              fcc       'tres '
CUATRO_D            fcc       'cuatro '
CINCO_D             fcc       'cinco '
SEIS_D              fcc       'seis '
SIETE_D             fcc       'siete '
OCHO_D              fcc       'ocho '
NUEVE_D             fcc       'nueve '
DIECI_D             fcc       'dieci '
DIEZ_D              fcc       'diez '
ONCE_D              fcc       'once '
DOCE_D              fcc       'doce '
TRECE_D             fcc       'trece '
CATORCE_D           fcc       'catorce '
DIECISEIS_D         fcc       'diecisEis '
QUINCE_D            fcc       'quince '
VEINTE_D            fcc       'veinte '
VEINTIUNO_D         fcc       'veintiuno '
VEINTIDOS_D         fcc       'veintidOs '
VEINTITRES_D        fcc       'veintitrEs '
VEINTICUATRO_D      fcc       'veinticuatro '
VEINTICINCO_D       fcc       'veinticinco '
VEINTISEIS_D        fcc       'veintisEis '
VEINTISIETE_D       fcc       'veintisiete '
VEINTIOCHO_D        fcc       'veintiocho '
VEINTINUEVE_D       fcc       'veintinueve '
Y_D                 fcc       'y '
TREINTA_D           fcc       'treinta '
CUARENTA_D          fcc       'cuarenta '
CINCUENTA_D         fcc       'cincuenta '
SESENTA_D           fcc       'sesenta '
SETENTA_D           fcc       'setenta '
OCHENTA_D           fcc       'ochenta '
NOVENTA_D           fcc       'noventa '
CIEN_D              fcc       'cien '
CIENTO_D            fcc       'ciento '
CIENTOS_D           fcc       'cientos '
QUINIENTOS_D        fcc       'quinientos '
SETECIENTOS_D       fcc       'setecientos '
NOVECIENTOS_D       fcc       'novecientos '
MIL_D               fcc       'mil '

; NUMEROS ROMANOS

CIEN_R              fcc       'C '
DOSCIENTOS_R        fcc       'CC '
TRESCIENTOS_R       fcc       'CCC '
CUATROCIENTOS_R     fcc       'CD '
QUINIENTOS_R        fcc       'D '
SEISCIENTOS_R       fcc       'DC '
SETECIENTOS_R       fcc       'DCC '
OCHOCIENTOS_R       fcc       'DCCC '
NOVECIENTOS_R       fcc       'CM '
DIEZ_R              fcc       'X '
VEINTE_R            fcc       'XX '
TREINTA_R           fcc       'XXX '
CUARENTA_R          fcc       'XL '
CINCUENTA_R         fcc       'L '
SESENTA_R           fcc       'LX '
SETENTA_R           fcc       'LXX '
OCHENTA_R           fcc       'LXXX '
NOVENTA_R           fcc       'XC '
UNO_R               fcc       'I '
DOS_R               fcc       'II '
TRES_R              fcc       'III '
CUATRO_R            fcc       'IV '
CINCO_R             fcc       'V '
SEIS_R              fcc       'VI '
SIETE_R             fcc       'VII '
OCHO_R              fcc       'VIII '
NUEVE_R             fcc       'IX '

                    org       $8000

INICIO
                    lds       #$00FF              ; Configuracion del puerto serial
                    jsr       SERIAL              ; SUBRUTINA PARA CONFIG EL PUERTO SERIAL
                    jsr       LIMPIEZA
                    jsr       INICIALIZAR
                    jmp       CICLATE1

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
                    ldb       BANDERAC            ; PARA EL CASO CM REVISA QUE LLEGUE C ANTES
                    cmpb      #0
                    bne       CASOCM

                    ldb       BANDERAM
                    cmpb      #8                  ; REVISA QUE NO SEAN MAS DE 9 M's
                    bhi       ERROR1

                    jsr       D_ERROR

                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    ldb       BANDERAM
                    incb
                    stb       BANDERAM
                    ldb       MIL
                    incb
                    stb       MIL
                    bra       CICLATE

; *CASO DONDE LLEGUE CM
CASOCM
                    cmpb      #1                  ; REVISA SI HAY UNA SEGUNDA C
                    bhi       ERROR1
                    addb      #5
                    stb       BANDERAC            ; CARGA 5 EN C
                    ldb       #9
                    stb       CENTENA             ; CARGA 9 EN CENTENA
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx                           ; AUMENTA EN 1 X
                    bra       CICLATE

CASOD

                    jsr       L_ERROR
                    ldb       BANDERAD
                    incb
                    stb       BANDERAD
                    cmpb      #2
                    beq       ERROR1              ; VALIDA QUE NO LLEGUE MAS DE UNA D
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    ldb       BANDERAC
                    cmpb      #0
                    bne       CASOCD
                    ldb       #5
                    stb       CENTENA
                    bra       CICLATE

CASOCD
; CASO CUATROCIENTOS (CD)
                    cmpb      #1
                    bhi       ERROR_1
                    addb      #5
                    stb       BANDERAC            ; CARGA 5 EN C
                    ldb       #4
                    stb       CENTENA             ; CARGA 4 EN CENTENA
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx                           ; AUMENTA EN 1 X
                    bra       CICLATE

SALTOINTERMEDIO1
                    cmpa      #'C'
                    beq       CASOC
                    cmpa      #'L'
                    beq       CASOL
                    bra       SALTOINTERMEDIO

CASOC
; BANDERA A FUTURO PARA IDENTIFICAR LOS ERRORES
                    ldb       BANDERAX            ; IDENTIFICA SI LLEGA UN NOVENTA (XC)
                    cmpb      #0
                    bne       CASOXC
                    ldb       BANDERAC
                    cmpb      #4
                    bhi       ERROR_1

                    jsr       L_ERROR

                    ldb       BANDERAC
                    incb
                    stb       BANDERAC
                    cmpb      #4
                    beq       ERROR_1             ; VALIDA QUE NO LLEGUEN MAS DE 4 C'S
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    ldb       CENTENA
                    incb
                    stb       CENTENA
                    jmp       CICLATE

; *CASO POR SI LLEGA UN XC
CASOXC
                    cmpb      #1
                    bhi       ERROR_1             ; ERROR CUANDO HAY MÁS DE UNA C
                    addb      #5                  ; SE USA CON EL ERROR XCX
                    stb       BANDERAX
                    ldb       #9
                    stb       DECENA
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    jmp       CICLATE

ERROR_1
                    jsr       ERROR_ESCRITURA
                    jmp       FIN

CASOL
                    ldb       BANDERAX
                    cmpb      #0
                    bne       CASOXL
                    jsr       V_ERROR
                    ldb       BANDERAL
                    incb
                    stb       BANDERAL
                    cmpb      #2
                    beq       ERROR_1             ; VERIFICA QUE NO LLEGUE MAS DE UNA L
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    ldb       #5
                    stb       DECENA

                    jmp       CICLATE

; *PARA CUANDO LLEGA XL
CASOXL
                    cmpb      #1
                    bhi       ERROR_1             ; IDENTIFICA SI HAY MAS DE UNA X
                    addb      #5
                    stb       BANDERAX            ; SUMA 5 A X
                    ldb       #4
                    stb       DECENA              ; CARGA 4 A LAS CENTENAS
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    jmp       CICLATE

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
                    ldb       BANDERAI
                    cmpb      #0                  ; VALIDA EL CASO DE NUEVE (IX)
                    bne       CASOIX
                    ldb       BANDERAX
                    incb
                    stb       BANDERAX
                    cmpb      #3
                    bhi       ERROR_1
                    ldb       BANDERAV
                    cmpb      #0                  ; VALIDA QUE NO EXISTAN V's ANTES DE X
                    bne       ERROR_1

                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    ldb       DECENA
                    incb
                    stb       DECENA
                    jmp       CICLATE

ERROR_2
                    jsr       ERROR_ESCRITURA
                    jmp       FIN

; *CUANDO LLEGUE UN IX
CASOIX
                    cmpb      #1
                    bhi       ERROR_1
                    addb      #6
                    stb       BANDERAI
                    ldb       #9
                    stb       UNIDAD
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    jmp       CICLATE

CASOV
                    ldb       BANDERAI
                    cmpb      #0
                    bne       CASOIV
                    ldb       BANDERAV
                    incb
                    stb       BANDERAV
                    cmpb      #2
                    beq       ERROR_2             ; VERIFICA QUE NO HAYA MAS DE DE UNA V
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    ldb       #5
                    stb       UNIDAD
                    jmp       CICLATE

; *CUANDO LLEGUE UN IV
CASOIV
                    cmpb      #1
                    bhi       ERROR_2
                    addb      #6
                    stb       BANDERAI
                    ldb       #4
                    stb       UNIDAD
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    jmp       CICLATE

SALTOINTERMEDIO2
                    cmpa      #'O'                ; SI RECIBE UN OK
                    beq       CASOO
                    cmpa      #'K'
                    beq       CASOOK
                    cmpa      #61                 ; IDENTIFICA EL FINAL DE LA CADENA UNA VEZ RECIBIDO EL =
                    beq       ESCRIBECHAR
                    bra       SALTOINTERMEDIO1_ERROR

CASOI
                    ldb       BANDERAI
                    incb
                    stb       BANDERAI
                    cmpb      #3
                    bhi       ERROR_2
                    sta       ,x                  ; LO QUE MANDA EL USUARIO SE ESCRIBE A PARTIR DE LA DIRECCION $70
                    inx
                    ldb       UNIDAD
                    incb
                    stb       UNIDAD
                    jmp       CICLATE

CASOO
                    ldb       BANDERAOK
                    incb
                    stb       BANDERAOK
                    bra       FIN

CASOOK
                    ldb       BANDERAOK
                    cmpb      #0
                    bne       LIMPIEZA_SALTO
                    bra       CICLATE1

LIMPIEZA_SALTO
                    jsr       LIMPIEZA
                    jsr       INICIALIZAR
                    bra       CICLATE1

SALTOINTERMEDIO1_ERROR

                    jmp       ERROR1

ESCRIBECHAR
                    ldb       BANDERAERROR
                    cmpb      #1
                    beq       SALTOINTERMEDIO1_ERROR
                    ldb       #48                 ; CÓDIGO ASCII DE 0
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
                    jmp       INSERTAR_TEXTO

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

;*****************************************************************************************
; *TRADUCCION DE NUMEROS ROMANOS A DECIMAL*
;*****************************************************************************************
CICLATE1
                    lda       #'?'
                    sta       ORDEN
CICLO
                    lda       ORDEN
                    cmpa      #'?'
                    beq       CICLO

ENTRADA
                    cmpa      #61                 ; IDENTIFICA EL FINAL DE LA CADENA CON EL =
                    beq       TRADUCCION_A_ROMANO

                    cmpa      #'O'                ; *CASO EN QUE RECIBA OK
                    beq       CASOO_DECIMAL
                    cmpa      #'K'
                    beq       CASOOK_DECIMAL      ; RECIBE UNA K

                    jsr       VALIDACION_DECIMAL  ; SI ES UN NUMERO DECIMAL REGRESA UN 1
                    cmpb      #1
                    bne       ENTRADA_INTERMEDIO_ROMANO

                    ldb       NUMCARAC
                    cmpb      #3
                    bhi       ERROR_CANTIDAD      ; HAY ERROR SI LLEGAN MAS DE 4 CARACTERES

                    incb
                    stb       NUMCARAC            ; SE INCREMENTA EL NUMERO DE CARACTERES

                    sta       ,x
                    inx

                    bra       CICLATE1

ENTRADA_INTERMEDIO_ROMANO

                    ldb       #2
                    stb       BANDERA_TIPO_TRADUCCION
                    jmp       ENTRADA_ROMANO

CASOO_DECIMAL
                    ldb       BANDERAOK
                    incb
                    stb       BANDERAOK
                    bra       CICLATE1

CASOOK_DECIMAL
                    ldb       BANDERAOK
                    cmpb      #0
                    beq       ERROR_CANTIDAD
                    bsr       INICIALIZAR
                    bra       CICLATE1

TRADUCCION_A_ROMANO
                    ldb       #1
                    stb       BANDERA_TIPO_TRADUCCION

                    lda       BANDERA_ERROR
                    cmpa      #1
                    beq       CICLATE1
                    ldy       #DIRECCION_RESULTADO  ; DIRECCION EN MEMORIA PARA ESCRIBIR
                    ldx       #DIRECCION_INPUT    ; DIRECCION EN MEMORIA DE LOS NUMEROS
                    lda       NUMCARAC            ; COMPARACION DE NUMERO DE CARACTERES
                    cmpa      #1
                    beq       CASO_UNIDAD
                    cmpa      #2
                    beq       CASO_DECENA
                    cmpa      #3
                    beq       CASO_CENTENA
                    cmpa      #4
                    beq       CASO_MILLAR

                    bra       CICLATE1            ; EN EL CASO DE QUE NO SE HAGA NIEN LA VALIDACION

CASO_MILLAR

                    ldb       ,x                  ; EL PRIMER CHAR SE PONE EN B
                    cmpb      #$31
                    blo       CASO_CENTENA        ; IDENTIFICA SI EL VALOR ES MAYOR A 0

CASO_ESCRIBE_MILLAR
                    lda       #'M'                ; CARGA EN EL ACUMULADOR A UNA M
                    sta       ,y                  ; ESCRIBE EN LA DIR DE Y
                    iny                           ; INCREMENTAMOS Y PARA CONTINUAR ESCRIBIENDO
                    decb                          ; SE DECREMENTAN B
                    cmpb      #$30                ; ASCII DE 0
                    bne       CASO_ESCRIBE_MILLAR  ; EN CASO DE RECIBIR UN PUNTO(.) SE REPITE
                    inx                           ; SE PASA AL SIGUIENTE DIGITO

CASO_CENTENA
                    bsr       ESCRIBE_CENTENA
                    inx
CASO_DECENA
; GUARDA EN A, EL VALOR DE X
                    jsr       ESCRIBE_DECENA
                    inx
CASO_UNIDAD
                    jsr       ESCRIBE_UNIDAD
                    jmp       INSERTAR_TEXTO

                    jmp       CICLATE1

ERROR_CANTIDAD
                    ldx       #DIRECCION_RESULTADO  ; DIRECCION EN MEMORIA DEL MENSAJE
                    ldy       #MENSAJE_E_RANGO    ; ORG FCC
                    bsr       ERROR
                    jmp       CICLATE1

INICIALIZAR
                    ldx       #DIRECCION_INPUT
                    ldy       #DIRECCION_RESULTADO  ; ES LA DIRECCION $50
                    clr       BANDERA_TIPO_TRADUCCION
                    clr       BANDERAOK
                    clr       UNO_R
                    clr       NUMCARAC
                    clr       BANDERA_ERROR
LIM3
                    ldb       #00
                    stb       ,y
                    iny
                    cpy       #$00C0
                    bne       LIM3
                    ldy       #DIRECCION_INPUT    ; ES LA DIRECCION $30
LIM4
                    ldb       #00
                    stb       ,y
                    iny
                    cpy       #$0040
                    bne       LIM4
                    rts

VALIDACION_DECIMAL
                    cmpa      #$30                ; VALOR EN ASCCI DE 0
                    blo       ERROR_DECIMAL
                    cmpa      #$3A                ; VALOR EN ASCII DE 9
                    bhi       ERROR_DECIMAL
                    ldb       #1
FIN_VALIDACION_DECIMAL

                    rts

ERROR_DECIMAL
                    ldb       #4
                    bra       FIN_VALIDACION_DECIMAL

ERROR
                    ldb       #1
                    stb       BANDERA_ERROR
ERROR_CICLO1
                    ldb       ,y                  ; CARACTER DEL FCC
                    stb       ,x                  ; EN LA DIRECCION DE X ESCRIBE EL CHAR
                    inx                           ; INCREMENTA X
                    iny                           ; INCREMENTA Y
                    cmpb      #46                 ; VALOR EN ASCII DE PUNTO
                    bne       ERROR_CICLO1        ; SE CICLA HASTA ENCONTAR UN PUNTO(.)
                    rts

ESCRIBE_CENTENA
                    pshx      *                   ; COPIA EL VALOR DE X
                    lda       ,x                  ; GUARDA X EN A
                    suba      #$30                ; RESTA 30
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
                    ldx       #CIEN_R             ; DIRECCION DE CIEN
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_2_CENTENA
                    ldx       #DOSCIENTOS_R       ; DIRECCION DE DOSCIENTOS
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_3_CENTENA
                    ldx       #TRESCIENTOS_R      ; DIRECCION DE TRESCIENTOS
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_4_CENTENA
                    ldx       #CUATROCIENTOS_R    ; DIRECCION DE CUATROCIENTOS
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_5_CENTENA
                    ldx       #QUINIENTOS_R       ; DIRECCION DE QUINIENTOS
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_6_CENTENA
                    ldx       #SEISCIENTOS_R      ; DIRECCION DE SEISCIENTOS
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_7_CENTENA
                    ldx       #SETECIENTOS_R      ; DIRECCION DE SETECIENTOS
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_8_CENTENA
                    ldx       #OCHOCIENTOS_R      ; DIRECCION DE OCHOCIENTOS
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

NUM_9_CENTENA
                    ldx       #NOVECIENTOS_R      ; DIRECCION DE NOVSECIENTOS
                    bsr       CICLO_ESCRITURA
                    bra       FIN_CENTENA

CICLO_ESCRITURA
                    ldb       ,x                  ; TOMA CARACTER DEL FCC
                    stb       ,y                  ; ESCRIBE EN LA DIRECCION DE Y EL CHAR
                    inx
                    iny
                    cmpb      #$20                ; VALOR EN ASCII DEL ESPACIO
                    bne       CICLO_ESCRITURA     ; SE REPITE HASTA QUE NO SE ENCUENTRE UN PUNTO(.)
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
                    ldx       #DIEZ_R             ; DIRECCION DE DIEZ
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_2_DECENA
                    ldx       #VEINTE_R           ; DIRECCION DE VEINTE
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_3_DECENA
                    ldx       #TREINTA_R          ; DIRECCION DE TREINTA
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_4_DECENA
                    ldx       #CUARENTA_R         ; DIRECCION DE CUARENTA
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_5_DECENA
                    ldx       #CINCUENTA_R        ; DIRECCION DE CINCUENTA
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_6_DECENA
                    ldx       #SESENTA_R          ; DIRECCION DE SESENTA
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_7_DECENA
                    ldx       #SETENTA_R          ; DIRECCION DE SETENTA
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_8_DECENA
                    ldx       #OCHENTA_R          ; DIRECCION DE OCHENTA
                    bsr       CICLO_ESCRITURA
                    bra       FIN_DECENA

NUM_9_DECENA
                    ldx       #NOVENTA_R          ; DIRECCION DE NOVENTA
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
                    ldx       #UNO_R              ; DIRECCION DE UNO

                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_2_UNIDAD
                    ldx       #DOS_R              ; DIRECCION DE DOS
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_3_UNIDAD
                    ldx       #TRES_R             ; DIRECCION DE TRES
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_4_UNIDAD
                    ldx       #CUATRO_R           ; DIRECCION DE CUATRO
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_5_UNIDAD
                    ldx       #CINCO_R            ; DIRECCION DE CINCO
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_6_UNIDAD
                    ldx       #SEIS_R             ; DIRECCION DE SEIS
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_7_UNIDAD
                    ldx       #SIETE_R            ; DIRECCION DE SIETE
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_8_UNIDAD
                    ldx       #OCHO_R             ; DIRECCION DE OCHO
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

NUM_9_UNIDAD
                    ldx       #NUEVE_R            ; DIRECCION DE NUEVE
                    jsr       CICLO_ESCRITURA
                    bra       FIN_UNIDAD

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
                    ldb       BANDERAERROR
                    incb
                    stb       BANDERAERROR
                    ldx       #DIRECCION_RESULTADO  ; DIRECCION MENSAJE
                    ldy       #$3000              ; ORG FCC
ERROR_CICLO
                    ldb       ,y
                    stb       ,x
                    inx
                    iny
                    cmpb      #46                 ; VALOR DE ASCII DEL PUNTO
                    bne       ERROR_CICLO
                    rts

ERROR_SALTO
                    bsr       ERROR_ESCRITURA
                    bra       FIN_ERROR

D_ERROR
                    ldb       BANDERAD
                    cmpb      #0                  ; VALIDA QUE ANTES DE LA M NO HAYA D's
                    bne       ERROR_SALTO

                    cmpa      #'M'
                    beq       L_ERROR             ; IDENTIFICA SI M TIENE UNA C ANTES
C_ERROR
                    ldb       BANDERAC
                    cmpb      #0                  ; VALIDA QUE ANTES DE LA M NO HAYA D's
                    bne       ERROR_SALTO
L_ERROR
                    ldb       BANDERAL
                    cmpb      #0                  ; VALIDA QUE ANTES DE LA M NO HAYA L's
                    bne       ERROR_SALTO
                    cmpa      #'C'
                    beq       V_ERROR             ; VALIDAR QUE C SI PUEDE TENER UNA X ANTES
X_ERROR
                    ldb       BANDERAX
                    cmpb      #0                  ; VALIDA QUE ANTES DE LA M NO HAYA X's
                    bne       ERROR_SALTO
V_ERROR
                    ldb       BANDERAV
                    cmpb      #0                  ; VALIDA QUE ANTES DE LA M NO HAYA V's
                    bne       ERROR_SALTO
                    cmpa      #'X'
                    beq       FIN_ERROR           ; VALIDAR QUE X SI PUEDE TENER UNA I ANTES
I_ERROR
                    ldb       BANDERAI
                    cmpb      #0                  ; VALIDA QUE ANTES DE LA M NO HAYA I's
                    bne       ERROR_SALTO
FIN_ERROR
                    rts

LIMPIEZA
                    clr       BANDERAM
                    clr       BANDERAD
                    clr       BANDERAC
                    clr       BANDERAL
                    clr       BANDERAX
                    clr       BANDERAV
                    clr       BANDERAI
                    clr       NUMCARAC
                    clr       BANDERA_TIPO_TRADUCCION
                    clr       BANDERAERROR
                    clr       UNIDAD
                    clr       DECENA
                    clr       CENTENA
                    clr       MIL
                    clr       BANDERA_TRADUCCION
                    ldx       #DIRECCION_RESULTADO
                    ldy       #DIRECCION_INPUT
LIM
                    ldb       #00
                    stb       ,y                  ; EMPIEZA EN LA $50
                    iny
                    cpy       #$00C0              ; TERMINA EN LA $70
                    bne       LIM
                    ldy       #DIRECCION_INPUT    ; EMPIEZA EN LA $30
LIM2
                    ldb       #00
                    stb       ,y
                    iny
                    cpy       #$0040              ; TERMINA EN LA $40
                    bne       LIM2
                    rts

ORIGEN_DECIMAL
; JSR DESPLAZA_DECIMALS
                    ldy       #DIRECCION_INPUT
                    bra       ESCRIBE_INSERTAR_TEXTO

ORIGEN_ROMANO
                    ldy       #DIRECCION_RESULTADO  ; LA TRADUCCION
                    lda       ,y
                    bra       ENTRADA_MILES

ENTRADA_INTERMEDIA_UNIDADES

                    jmp       ENTRADA_UNIDADES

ENTRADA_INTERMEDIA_DECENAS

                    jmp       ENTRADA_DECENAS

ENTRADA_INTERMEDIA_CENTENAS

                    jmp       ENTRADA_CENTENAS

;**SUBRUTINA PARA ESCRIBIR LOS NUMEROS TEXTUALES
INSERTAR_TEXTO
                    ldb       BANDERA_TIPO_TRADUCCION
                    cmpb      #1
                    beq       ORIGEN_DECIMAL
                    cmpb      #2
                    beq       ORIGEN_ROMANO
ESCRIBE_INSERTAR_TEXTO

                    ldx       #DIRECCION_TEXTUAL
                    ldb       NUMCARAC
                    stb       $00A0
                    cmpb      #1
                    beq       ENTRADA_INTERMEDIA_UNIDADES
                    cmpb      #2
                    beq       ENTRADA_INTERMEDIA_DECENAS
                    cmpb      #3
                    beq       ENTRADA_INTERMEDIA_CENTENAS
ENTRADA_MILES
                    ldx       #DIRECCION_TEXTUAL
                    ldb       ,y
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
                    ldy       #MIL_D
                    jsr       CICLO_INSERTAR_TEXTO
                    bra       ESCRIBE_MIL_FIN

ESCRIBE_DOS_MIL
                    ldy       #DOS_D
                    jsr       CICLO_INSERTAR_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_TRES_MIL
                    ldy       #TRES_D
                    jsr       CICLO_INSERTAR_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_CUATRO_MIL
                    ldy       #CUATRO_D
                    jsr       CICLO_INSERTAR_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_CINCO_MIL
                    ldy       #CINCO_D
                    jsr       CICLO_INSERTAR_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_SEIS_MIL
                    ldy       #SEIS_D
                    jsr       CICLO_INSERTAR_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_SIETE_MIL
                    ldy       #SIETE_D
                    jsr       CICLO_INSERTAR_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_OCHO_MIL
                    ldy       #OCHO_D
                    jsr       CICLO_INSERTAR_TEXTO
                    bra       ESCRIBE_MIL

ESCRIBE_NUEVE_MIL
                    ldy       #NUEVE_D
                    jsr       CICLO_INSERTAR_TEXTO
                    bra       ESCRIBE_MIL

ENTRADA_CENTENAS
                    ldb       ,y
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
                    ldy       #CIENTOS_D
                    jsr       CICLO_INSERTAR_TEXTO
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
                    ldy       #CIEN_D
                    jsr       CICLO_INSERTAR_TEXTO
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
                    ldy       #CIENTO_D
                    jsr       CICLO_INSERTAR_TEXTO
                    bra       ESCRIBE_CIENTOS_FIN

ESCRIBE_DOS_CIENTOS
                    ldy       #DOS_D
                    jsr       CICLO_INSERTAR_TEXTO
                    dex
                    bra       ESCRIBE_CIENTOS

ESCRIBE_TRES_CIENTOS

                    ldy       #TRES_D
                    jsr       CICLO_INSERTAR_TEXTO
                    dex
                    bra       ESCRIBE_CIENTOS

ESCRIBE_CUATRO_CIENTOS

                    ldy       #CUATRO_D
                    jsr       CICLO_INSERTAR_TEXTO
                    dex
                    bra       ESCRIBE_CIENTOS

ESCRIBE_CINCO_CIENTOS

                    ldy       #QUINIENTOS_D
                    jsr       CICLO_INSERTAR_TEXTO
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

                    ldy       #SEIS_D
                    jsr       CICLO_INSERTAR_TEXTO
                    dex
                    jmp       ESCRIBE_CIENTOS

ESCRIBE_SIETE_CIENTOS

                    ldy       #SETECIENTOS_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       ESCRIBE_CIENTOS_FIN

ESCRIBE_OCHO_CIENTOS

                    ldy       #OCHO_D
                    jsr       CICLO_INSERTAR_TEXTO
                    dex
                    jmp       ESCRIBE_CIENTOS

ESCRIBE_NUEVE_CIENTOS

                    ldy       #NOVECIENTOS_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       ESCRIBE_CIENTOS_FIN

ENTRADA_DECENAS
                    ldb       ,y
                    pshy
                    cmpb      #'0'
                    beq       FIN_ENTRADA_DECENAS
                    cmpb      #'1'
                    beq       ESCRIBE_DIECI
                    cmpb      #'2'
                    beq       S_ESCRIBE_VEINTI
                    jmp       COMPARA_TANTOS

FIN_ENTRADA_DECENAS
                    puly
                    iny
                    jmp       ENTRADA_UNIDADES

S_ESCRIBE_VEINTI
                    bra       ESCRIBE_VEINTI

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
                    cmpb      #'6'
                    beq       ESCRIBE_DIECISEIS
                    bra       ESCRIBE_DIECI_L

                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_DIEZ
                    ldy       #DIEZ_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_ONCE
                    ldy       #ONCE_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_DOCE
                    ldy       #DOCE_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_TRECE
                    ldy       #TRECE_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_CATORCE
                    ldy       #CATORCE_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_QUINCE
                    ldy       #QUINCE_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_DIECI_L
                    ldy       #DIECI_D
                    jsr       CICLO_INSERTAR_TEXTO
                    dex
                    bra       FIN_ENTRADA_DECENAS

ESCRIBE_DIECISEIS
                    ldy       #DIECISEIS_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_VEINTI
                    puly
                    iny
                    ldb       ,y
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
                    jmp       FIN_INSERTAR_TEXTO  ; SE VA AL FIN

; *VEINTES

ESCRIBE_VEINTE
                    ldy       #VEINTE_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_VEINTIUNO
                    ldy       #VEINTIUNO_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_VEINTIDOS
                    ldy       #VEINTIDOS_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_VEINTITRES
                    ldy       #VEINTITRES_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_VEINTICUATRO

                    ldy       #VEINTICUATRO_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_VEINTICINCO
                    ldy       #VEINTICINCO_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_VEINTISEIS
                    ldy       #VEINTISEIS_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_VEINTISIETE
                    ldy       #VEINTISIETE_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_VEINTIOCHO
                    ldy       #VEINTIOCHO_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

ESCRIBE_VEINTINUEVE
                    ldy       #VEINTINUEVE_D
                    jsr       CICLO_INSERTAR_TEXTO
                    jmp       FIN_INSERTAR_TEXTO

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
                    ldy       #TREINTA_D
                    jsr       CICLO_INSERTAR_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_TREINTA

                    ldy       #Y_D
                    jsr       CICLO_INSERTAR_TEXTO
FIN_ESCRIBE_TREINTA
                    jmp       FIN_ENTRADA_DECENAS

;**CUARENTAS
ESCRIBE_CUARENTA
                    ldy       #CUARENTA_D
                    jsr       CICLO_INSERTAR_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_CUARENTA

                    ldy       #Y_D
                    jsr       CICLO_INSERTAR_TEXTO
FIN_ESCRIBE_CUARENTA

                    jmp       FIN_ENTRADA_DECENAS

;**CINCUENTAS
ESCRIBE_CINCUENTA
                    ldy       #CINCUENTA_D
                    jsr       CICLO_INSERTAR_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_CINCUENTA

                    ldy       #Y_D
                    jsr       CICLO_INSERTAR_TEXTO
FIN_ESCRIBE_CINCUENTA

                    jmp       FIN_ENTRADA_DECENAS

;**SESENTAS
ESCRIBE_SESENTA
                    ldy       #SESENTA_D
                    jsr       CICLO_INSERTAR_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_SESENTA

                    ldy       #Y_D
                    jsr       CICLO_INSERTAR_TEXTO
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
                    ldy       #SETENTA_D
                    jsr       CICLO_INSERTAR_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_SETENTA

                    ldy       #Y_D
                    jsr       CICLO_INSERTAR_TEXTO
FIN_ESCRIBE_SETENTA
                    jmp       FIN_ENTRADA_DECENAS

; *OCHENTAS
ESCRIBE_OCHENTA
                    ldy       #OCHENTA_D
                    jsr       CICLO_INSERTAR_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_OCHENTA

                    ldy       #Y_D
                    jsr       CICLO_INSERTAR_TEXTO
FIN_ESCRIBE_OCHENTA
                    jmp       FIN_ENTRADA_DECENAS

; *NOVENTAS
ESCRIBE_NOVENTA
                    ldy       #NOVENTA_D
                    jsr       CICLO_INSERTAR_TEXTO

                    puly
                    iny
                    ldb       ,y
                    dey
                    pshy
                    cmpb      #'0'
                    beq       FIN_ESCRIBE_NOVENTA

                    ldy       #Y_D
                    bsr       CICLO_INSERTAR_TEXTO
FIN_ESCRIBE_NOVENTA
                    jmp       FIN_ENTRADA_DECENAS

ENTRADA_UNIDADES
                    ldb       ,y
                    pshy
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

                    bra       FIN_INSERTAR_TEXTO

ESCRIBE_UNO
                    ldy       #UNO_D
                    bsr       CICLO_INSERTAR_TEXTO
                    bra       FIN_INSERTAR_TEXTO

ESCRIBE_DOS
                    ldy       #DOS_D
                    bsr       CICLO_INSERTAR_TEXTO
                    bra       FIN_INSERTAR_TEXTO

ESCRIBE_TRES
                    ldy       #TRES_D
                    bsr       CICLO_INSERTAR_TEXTO
                    bra       FIN_INSERTAR_TEXTO

ESCRIBE_CUATRO
                    ldy       #CUATRO_D
                    bsr       CICLO_INSERTAR_TEXTO
                    bra       FIN_INSERTAR_TEXTO

ESCRIBE_CINCO
                    ldy       #CINCO_D
                    bsr       CICLO_INSERTAR_TEXTO
                    bra       FIN_INSERTAR_TEXTO

ESCRIBE_SEIS
                    ldy       #SEIS_D
                    bsr       CICLO_INSERTAR_TEXTO
                    bra       FIN_INSERTAR_TEXTO

ESCRIBE_SIETE
                    ldy       #SIETE_D
                    bsr       CICLO_INSERTAR_TEXTO
                    bra       FIN_INSERTAR_TEXTO

ESCRIBE_OCHO
                    ldy       #OCHO_D
                    bsr       CICLO_INSERTAR_TEXTO
                    bra       FIN_INSERTAR_TEXTO

ESCRIBE_NUEVE
                    ldy       #NUEVE_D
                    bsr       CICLO_INSERTAR_TEXTO
;                   bra       FIN_INSERTAR_TEXTO

;*************************************************

FIN_INSERTAR_TEXTO  jmp       FIN

CICLO_INSERTAR_TEXTO
                    ldb       ,y                  ; TOMA CARACTER DEL FCC
                    stb       ,x                  ; ESCRIBE EN X EL CHAR
                    inx                           ; INCREMENTA X
                    iny                           ; INCREMENTA Y
                    cmpb      #$20                ; VALOR EN ASCII DE ESPACIO
                    bne       CICLO_INSERTAR_TEXTO  ; SE REPITE MIENTRAS NO SE ENCUENTR UN PUNTO(.)
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
