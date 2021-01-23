# Traductor entre Romano y decimal con ensamblador

El programa traduce de Romano a decimal y al revés enviando el dato a traducir por puerto serial al compilador de motorola 68HC11, y el resultado se muestra en la memoria 0x50 y 0x70 

## Requerimientos de uso

- Se necesita un emulador del compilador de motorola 68HC11
- SO Windows
- Establecer mapas de memoria en las direcciones.
    * 8000
    * 3000s