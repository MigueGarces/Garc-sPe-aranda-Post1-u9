# Post-Contenido 1 - Unidad 9
## Acceso Directo a Puertos de E/S — Unidad 9
### Miguel Ángel Garcés Peñaranda - 1152432

---

## Objetivo

Implementar programas en lenguaje ensamblador x86 (NASM + DOSBox) que
accedan directamente a puertos de E/S mediante las instrucciones IN y OUT,
aplicando la tecnica de polling para sincronizacion con dispositivos de hardware.

---

## Programa 1 — TECL.ASM

**Descripcion:** Lee el puerto de estado del controlador de teclado 8042
(puerto 64h) mediante polling. Cuando detecta que el bit OBF (Output Buffer
Full, bit 0) esta en 1, lee el scancode del puerto 60h y lo muestra en
pantalla en formato hexadecimal.

**Puertos usados:**
- `60h` — Data Port: scancode de la tecla presionada
- `64h` — Status Register: bit 0 indica si hay dato disponible

---

## Programa 2 — POLL_T.ASM

**Descripcion:** Implementa polling con timeout usando el registro CX como
contador de reintentos. Si el contador llega a 0 sin recibir dato del teclado,
muestra un mensaje de timeout y termina.

**Constante clave:**
- `MAX_RETRY EQU 0005h` — valor pequeño para forzar el timeout en pruebas

**Comportamiento observado en DOSBox:**
Con MAX_RETRY = 0005h y sin presionar teclas, el mensaje de timeout aparece
de inmediato, demostrando el funcionamiento correcto del contador de reintentos.

---

## Programa 3 — LPT1.ASM

**Descripcion:** Envia el caracter 'A' (0x41) al puerto paralelo LPT1
siguiendo el protocolo Centronics: espera BUSY=1, coloca el dato en 378h
y genera un pulso STROBE en el registro de control (37Ah).

**Puertos usados:**
- `378h` — Data Register: byte de datos a enviar
- `379h` — Status Register: bit 7 = BUSY#
- `37Ah` — Control Register: bit 0 = STROBE#

**Comportamiento observado en DOSBox:**
En DOSBox no hay impresora fisica conectada. El bit BUSY# del puerto 379h
aparece siempre en alto, por lo que el bucle de espera termina de inmediato
y el programa finaliza sin bloquearse. El acceso al puerto no genera error,
lo que confirma que las instrucciones OUT e IN funcionan correctamente
dentro del entorno emulado.

---
