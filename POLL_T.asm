; POLL_T.ASM — Polling con timeout para el puerto de teclado
; Compila: nasm -f bin POLL_T.ASM -o POLL_T.COM

[BITS 16]
[ORG 0x100]

MAX_RETRY EQU 0005h     ; valor pequeno para forzar timeout

start:
    MOV CX, MAX_RETRY

.poll:
    IN  AL, 64h
    TEST AL, 01h
    JNZ .dato_listo
    LOOP .poll          ; decrementa CX; salta si CX no es 0

    ; Timeout: CX llego a 0 sin dato
    MOV AH, 09h
    MOV DX, msg_timeout
    INT 21h
    JMP .fin

.dato_listo:
    IN  AL, 60h
    MOV AH, 02h
    MOV DL, AL
    INT 21h             ; mostrar byte leido

.fin:
    MOV AH, 4Ch
    INT 21h

msg_timeout DB 'Timeout: sin respuesta del dispositivo$'