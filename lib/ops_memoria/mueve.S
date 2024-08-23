.syntax unified
.cpu cortex-m3
.thumb


.text

/**
 * @brief Copia los tamano valores desde origen a destino, si la memoria de
 * destino se solapa con la de origen al final destino tiene que tener la copia
 * completa de los datos (y en ese caso origen no la tendrá más)
 * 
 * @param destino puntero a base (menor dirección) de la región de destino (R0)
 * @param origen puntero a base de la región de origen (R1)
 * @param tamano tamano de las regiones (R2)
 */

    .type mueveMemoria, %function
    .global mueveMemoria 

mueveMemoria:
    push {R4, lr}
    cmp R0, R1
    beq salida
    blt mueve_izquierda_a_derecha
    bgt mueve_derecha_a_izquierda

mueve_izquierda_a_derecha:
    b izquierda_loop

izquierda_loop:
    ldrb R3, [R1], #1
    strb R3, [R0], #1
    subs R2, #1
    bne izquierda_loop
    b salida

mueve_derecha_a_izquierda:
    add R4, R1, R2
    add R12, R0, R2
    b derecha_loop

derecha_loop:
    ldrb R3, [R4, #-1]!
    strb R3, [R12, #-1]!
    subs R2, #1
    bne derecha_loop
    b salida

salida:
    pop {R4, pc}