; LPT1.ASM — Envio de un caracter al puerto paralelo LPT1
; Compila: nasm -f bin LPT1.ASM -o LPT1.COM

[BITS 16]
[ORG 0x100]

DATA_PORT   EQU 0378h
STATUS_PORT EQU 0379h
CTRL_PORT   EQU 037Ah

start:
    ; Esperar BUSY=1 (impresora lista)
    ; En DOSBox BUSY# es siempre alto, termina de inmediato
.wait_ready:
    MOV DX, STATUS_PORT
    IN  AL, DX          ; leer registro de estado por DX
    TEST AL, 80h        ; bit 7: BUSY#
    JZ  .wait_ready

    ; Enviar caracter 'A' (0x41)
    MOV DX, DATA_PORT
    MOV AL, 41h
    OUT DX, AL          ; colocar dato en el bus de datos

    ; Pulso STROBE (bit 0 del control, activo en bajo)
    MOV DX, CTRL_PORT
    IN  AL, DX          ; leer estado actual del control
    AND AL, 0FEh        ; STROBE=0 activo
    OUT DX, AL

    ; Retardo minimo (~1us en DOSBox)
    MOV CX, 0Fh
.delay:
    LOOP .delay

    ; Desactivar STROBE
    MOV DX, CTRL_PORT
    IN  AL, DX
    OR  AL, 01h         ; STROBE=1 inactivo
    OUT DX, AL

    MOV AH, 4Ch
    INT 21h             ; terminar programa