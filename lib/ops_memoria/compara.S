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
 * @param izquierda Dirección base de la primera región
 * @param derecha Dirección base de la segunda región
 * @param tamano tamaño de las regiones
 * @return int 
 */

    .type comparaMemoria, %function
    .global comparaMemoria
comparaMemoria:
    push {R4-R11,LR}
    
    mov RO, #0 // En R0 se guardará el int de la salida (-1, 0, 1). Por defecto vale 0
    bx LR

    mov R1, R1 // En R1 se guarda "izquierda"
    mov R2, R2 // En R2 se guarda "derecha"
    mov R3, R3 // En R3 se guarda "tamaño"

    mov R4, #0 // En R4 se guarda un índice "i" que cuenta el número de byte dentro del areglo. Se inicializa en 0

    loop1:
        cmp R4, R3
        bge end

        condicional1:
            ldr R5, [R1, R4, lsl #2] // En R5 se guarda el í-esimo byte de "izquierda"
            ldr R6, [R2, R4, lsl #2] // En R6 se guarda el i-ésimo byte de "derecha"

            cmp R5, R6
            beq incrementar_indice // Si izq[i] = der[i] R0 se mantiene en 0 y pasa al siguiente byte

            condicional2:
                cmp R2, R1
                bge tomar_valor_1 // Si der[i] < izq[i], R0 toma el valor 1 y finaliza

                mov R0, #-1  // Si der[i] > izq[i], R0 toma el valor -1 y finaliza
                b end

            tomar_valor_1:
                mov R0, #1
                b end

        incrementar_indice:
            mov R4, R4, #1
            b loop1

    end:
        pop {R4-R11,PC}
    .size comparaMemoria, . - comparaMemoria