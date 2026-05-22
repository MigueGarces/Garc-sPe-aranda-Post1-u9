; TECL.ASM — Lectura del teclado compatible con DOSBox
; Compila: nasm -f bin TECL.ASM -o TECL.COM

[BITS 16]
[ORG 0x100]

start:
    ; INT 16h funcion 00h: espera tecla y devuelve
    ; AL = codigo ASCII,  AH = scancode
    MOV AH, 00h
    INT 16h         ; esperar hasta que se presione una tecla

    MOV BL, AH      ; guardar scancode en BL

    ; Mostrar scancode en pantalla en formato hexadecimal
    MOV AH, 02h
    MOV DL, BL
    SHR DL, 4       ; nibble alto
    ADD DL, 30h
    CMP DL, 3Ah
    JL  .printH
    ADD DL, 07h     ; ajuste para letras A-F
.printH:
    INT 21h

    MOV DL, BL
    AND DL, 0Fh     ; nibble bajo
    ADD DL, 30h
    CMP DL, 3Ah
    JL  .printL
    ADD DL, 07h
.printL:
    INT 21h

    ; Salto de linea
    MOV AH, 02h
    MOV DL, 0Dh     ; CR
    INT 21h
    MOV DL, 0Ah     ; LF
    INT 21h

    MOV AH, 4Ch
    INT 21h         ; terminar programa