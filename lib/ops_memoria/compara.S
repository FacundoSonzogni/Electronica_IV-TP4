.syntax unified
.cpu cortex-m3
.thumb

.text

/**
 * @brief Compara dos regiones de memoria byte a byte como valores *sin signo*. 
 * Retorna 0 si son iguales, -1 si en la primera diferencia el valor de
 * izquierda es el menor y 1 si en la primera diferencia el valor de la
 * izquierda es mayor
 * 
 * @param izquierda Dirección base de la primera región (R0)
 * @param derecha Dirección base de la segunda región (R1)
 * @param tamano tamaño de las regiones (R2)
 * @return int 
 */

    .type comparaMemoria, %function
    .global comparaMemoria

comparaMemoria:

    ldrb r3, [r0], #1        // Carga el byte de R0 en R3 y aumenta R0
    ldrb r12, [r1], #1       // Carga el byte de R1 en R12 y aumenta R1
    cmp r3, r12              
    bne comparacion_distintos // Salta si R3 no es igual a R12

    subs r2, #1             
    bne comparaMemoria        

    movs r0, #0              
    b fin

comparacion_distintos:
    cmp r3, r12
    bgt izquierda_mayor      // Salta si R3 > R12
    movs r0, #-1             
    b fin

izquierda_mayor:
    movs r0, #1             

fin:
    bx lr