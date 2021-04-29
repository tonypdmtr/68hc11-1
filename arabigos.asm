;*******************************************************************************
; PROJECT 2
;*******************************************************************************
          ;-------------------------------------- ; CONSTANTS
REGS                equ       $1000
SCDR                equ       REGS+$2F
SCCR2               equ       REGS+$2D
SCSR                equ       REGS+$2E
SCCR1               equ       REGS+$2C
BAUD                equ       REGS+$2B
HPRIO               equ       REGS+$3C
SPCR                equ       REGS+$28
CSCTL               equ       REGS+$5D
OPT2                equ       REGS+$38
DDRD                equ       REGS+$09
          ;--------------------------------------
ORDEN               equ       $0000
DIR                 equ       $0070
NUMCARAC            equ       $0010
BERROR2             equ       $0003
OK                  equ       $0023               ; BANDERA DEL OK
BANDERA_ERROR       equ       $0011               ; BANDERA DE ERROR PARA ARABIGOS

;*******************************************************************************
                    #ROM      $3000
;*******************************************************************************

                    fcc       'ERROR, INVALID ROMAN NUMERAL. '   ; 30 CHARS
MENSAJE_E_ARABIGO   fcc       'ERROR, INVALID ARABIC NUMERAL. '  ; 31
                    fcc       'ERROR, NUMERO FUERA DE RANGO.'    ; 29
          ;--------------------------------------
R_C                 fcc       'C '                ; 100
R_CC                fcc       'CC '               ; 200
R_CCC               fcc       'CCC '              ; 300
R_CD                fcc       'CD '               ; 400
R_D                 fcc       'D '                ; 500
R_DC                fcc       'DC '               ; 600
R_DCC               fcc       'DCC '              ; 700
R_DCCC              fcc       'DCCC '             ; 800
R_CM                fcc       'CM '               ; 900
          ;--------------------------------------
R_X                 fcc       'X '                ; 10
R_XX                fcc       'XX '               ; 20
R_XXX               fcc       'XXX '              ; 30
R_XL                fcc       'XL '               ; 40
R_L                 fcc       'L '                ; 50
R_LX                fcc       'LX '               ; 60
R_LXX               fcc       'LXX '              ; 70
R_LXXX              fcc       'LXXX '             ; 80
R_XC                fcc       'XC '               ; 90
          ;--------------------------------------
R_I                 fcc       'I '                ; 1
R_II                fcc       'II '               ; 2
R_III               fcc       'III '              ; 3
R_IV                fcc       'IV '               ; 4
R_V                 fcc       'V '                ; 5
R_VI                fcc       'VI '               ; 6
R_VII               fcc       'VII '              ; 7
R_VIII              fcc       'VIII '             ; 8
R_XI                fcc       'XI '               ; 9

; NUMEROS EN LETRA
; AQUI VAN
;*******************************************************************************
                    #ROM      $8000
;*******************************************************************************

Start               proc
                    lds       #$00FF
                    jsr       ConfigSerial
                    jsr       Initialize
;                   bra       MainLoop

;*******************************************************************************

MainLoop            proc
                    lda       #'?'
                    sta       ORDEN

WaitChar@@          lda       ORDEN
                    cmpa      #'?'
                    beq       WaitChar@@

;                   jsr       ValidateRoman
          ;-------------------------------------- ; conversion to Roman
                    cmpa      #'='                ; Valida que le llegue un = para saber que es fin de la cadena que mete el usuario
                    beq       ConvertToRoman

                    cmpa      #'O'                ; CASO EN QUE RECIBA OK
                    beq       CASOO

                    cmpa      #'K'
                    beq       CASOOK              ; CASO EN QUE RECIBA UNA K

                    jsr       ValidateArabic
                    cmpb      #1                  ; LLEVA $?
                    bne       MainLoop

                    ldb       NUMCARAC
                    cmpb      #3
                    bhi       CandidateError      ; POR SI YA LLEGARON LOS 4 CARACTERES ES UN ERROR

                    incb
                    stb       NUMCARAC            ; INCREMENTAMOS EL DE CARACTERES

                    sta       ,x
                    inx                           ; CAMBIAMOS EL CONTADOR DE LA SIGUIENTE MEMORIA A ESCRIBIR
                    bra       MainLoop

CASOO               ldb       OK
                    incb
                    stb       OK
                    bra       MainLoop

CASOOK              ldb       OK
                    beq       MainLoop
                    bsr       Initialize
                    bra       MainLoop

;*******************************************************************************

ConvertToRoman      proc
                    lda       BANDERA_ERROR
                    cmpa      #1
                    beq       Done@@
                    ldx       #$0070              ; REGRESAMOS A LA CIFRA MAS SIGNIFICATIVA
                    lda       NUMCARAC            ; COMPARAMOS EL NUMERO DE CARACTERES
                    cmpa      #1
                    beq       _1@@
                    cmpa      #2
                    beq       _2@@
                    cmpa      #3
                    beq       _3@@
                    cmpa      #4
                    bne       Done@@              ; POR SI NO SE VALIDA BIEN
          ;--------------------------------------
                    ldy       #$0050              ; DIRECCION DE ESCRITURA
                    ldx       #$0070              ; DIRECCION DE NUM
                    ldb       ,x                  ; TOMAR EL PRIMER NUM CHAR Y PONERLO EN B
                    cmpb      #'1'
                    blo       _3@@                ; VALIDA QUE SEA MAYOR A 0 EN ASCII
          ;--------------------------------------
Loop@@              lda       #'M'                ; CARGA UNA M EN EL ACUMULADOR A
                    sta       ,y                  ; ESCRIBE EN LA DIR DE Y
                    iny                           ; INCREMENTAMOS Y PARA CONTINUAR ESCRIBIENDO
                    decb                          ; DECREMENTAMOS B
                    cmpb      #'0'                ; ASCII DE 0
                    bne       Loop@@              ; MIENTRAS NO ENCONTREMOS UN PUNTO(.) SE REPITE
                    inx                           ; PASAMOS AL SIGUIENTE NUM DIGITO
          ;--------------------------------------
_3@@                jsr       ESCRIBE_CENTENA
                    inx
_2@@                jsr       ESCRIBE_DECENA
                    inx
_1@@                jsr       ESCRIBE_UNIDAD
Done@@              bra       MainLoop

CandidateError      ldx       #$0050              ; DIRECCION DEL MENSAJE
                    ldy       #MENSAJE_E_ARABIGO
                    bsr       ERROR
                    bra       Done@@

;*******************************************************************************
; Configution of serial port

ConfigSerial        proc
                    ldd       #$302C              ; CONFIGURA PUERTO SERIAL
                    sta       BAUD                ; BAUD 9600 para cristal de 8MHz
                    stb       SCCR2               ; HABILITA RX Y TX PERO INTERRUPCN SOLO RX
                    clr       SCCR1               ; 8 BITS

                    lda       #$FE                ; CONFIG PUERTO D COMO SALIDAS (EXCEPTO PD0)
                    sta       DDRD                ; SEA ENABLE DEL DISPLAY PD4 Y RS PD3

                    lda       #$04
                    sta       HPRIO

                    clra
                    tap
                    rts

;*******************************************************************************

Initialize          proc
                    ldx       #$0070
                    ldy       #$0070
                    clr       OK
                    clr       R_I
                    clr       BERROR2             ; DEJA EN CERO LAS VARIABLES
                    clr       NUMCARAC
                    clr       BANDERA_ERROR
_1@@                clr       ,y
                    iny
                    cpy       #$008F
                    bne       _1@@
                    ldy       #$0050
_2@@                clr       ,y
                    iny
                    cpy       #$006F
                    bne       _2@@
                    rts

;*******************************************************************************

ValidateArabic      proc
                    cmpa      #'0'
                    blo       Fail@@
                    cmpa      #'9'
                    bhi       Fail@@
                    ldb       #1
Done@@              rts

Fail@@              ldx       #$0050              ; DIRECCION DEL MENSAJE
                    ldy       #MENSAJE_E_ARABIGO
                    bra       ERROR

;*******************************************************************************

ValidateRoman       proc
                    pshx
                    ldx       #Table@@
Loop@@              cmpa      ,x
                    bne       Fail@@
                    inx
                    cmpx      #Table@@+::Table@@
                    blo       Loop@@
                    pulx
                    rts

Table@@             fcc       'MDCLXVI'

Fail@@              pulx
;                   bra       ERROR

;*******************************************************************************

ERROR               proc
                    lda       #1
                    sta       BANDERA_ERROR
Loop@@              ldb       ,y                  ; TOMA CARACTER DEL FCC
                    stb       ,x                  ; ESCRIBE EL CHAR EN LA DIR DE X
                    inx
                    iny                           ; INCREMENTAMOS X Y Y
                    cmpb      #'.'                ; ASCII DE PUNTO
                    bne       Loop@@              ; MIENTRAS NO ENCONTREMOS UN PUNTO(.) SE REPITE
                    rts

;*******************************************************************************

ESCRIBE_CENTENA     proc
                    pshx
                    lda       ,x
                    suba      #'0'
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 100
                    ldx       #R_C
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 200
                    ldx       #R_CC
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 300
                    ldx       #R_CCC
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 400
                    ldx       #R_CD
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 500
                    ldx       #R_D
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 600
                    ldx       #R_DC
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 700
                    ldx       #R_DCC
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 800
                    ldx       #R_DCCC
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 900
                    ldx       #R_CM
                    deca
                    bne       Done@@
          ;--------------------------------------
Go@@                bsr       CICLO_ESCRITURA
Done@@              pulx
                    rts

;*******************************************************************************

CICLO_ESCRITURA     proc
Loop@@              ldb       ,x                  ; TOMA CARACTER DEL FCC
                    stb       ,y                  ; ESCRIBE EL CHAR EN LA DIR DE X
                    inx
                    iny                           ; INCREMENTAMOS X Y Y
                    cmpb      #' '                ; space
                    bne       Loop@@              ; MIENTRAS NO ENCONTREMOS UN PUNTO(.) SE REPITE
                    dey
                    rts

;*******************************************************************************

ESCRIBE_DECENA      proc
                    pshx
                    lda       ,x
                    suba      #'0'
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 10
                    ldx       #R_X
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 20
                    ldx       #R_XX
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 30
                    ldx       #R_XXX
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 40
                    ldx       #R_XL
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 50
                    ldx       #R_L
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 60
                    ldx       #R_LX
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 70
                    ldx       #R_LXX
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 80
                    ldx       #R_LXXX
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 90
                    ldx       #R_XC
                    deca
                    bne       Done@@
          ;--------------------------------------
Go@@                bsr       CICLO_ESCRITURA
Done@@              pulx
                    rts

;*******************************************************************************

ESCRIBE_UNIDAD      proc
                    pshx
                    lda       ,x
                    suba      #'0'
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 1
                    ldx       #R_I
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 2
                    ldx       #R_II
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 3
                    ldx       #R_III
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 4
                    ldx       #R_IV
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 5
                    ldx       #R_V
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 6
                    ldx       #R_VI
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 7
                    ldx       #R_VII
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 8
                    ldx       #R_VIII
                    deca
                    beq       Go@@
          ;-------------------------------------- ; DIRECCION DE MEMORIA DE 9
                    ldx       #R_XI
                    deca
                    bne       Done@@
          ;--------------------------------------
Go@@                jsr       CICLO_ESCRITURA
Done@@              pulx
                    rts

;*******************************************************************************

SCI_Handler         proc
                    lda       SCSR
                    lda       SCDR
                    sta       ORDEN
                    rti

;*******************************************************************************
                    #VECTORS
;*******************************************************************************

                    org       $FFD6               ; SCI vector
Vsci                dw        SCI_Handler

                    org       $FFFE
Vreset              dw        Start               ;reset vector

                    end       Start
