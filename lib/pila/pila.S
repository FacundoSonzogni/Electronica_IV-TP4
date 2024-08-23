.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.macro defun nombre
    .section .text.\nombre
    .global \nombre
    .type \nombre, %function
\nombre:
.endm

.macro endfun nombre
    .size \nombre, . - \nombre
.endm


/**
 * @brief Inicializa un descriptor de pila. Inicialmente la pila está vacía
 * 
 * @param descriptor Descriptor a inicializar (R0)
 * @param base Dirección base (menor dirección) de la pila (R1)
 * @param capacidad Capacidad de la pila (en elementos) (R2)
 */
defun Pila_init
    add R3, R1, R2, lsl #2
    str R1,[R0, #0]
    str R3,[R0, #4]
    str R1,[R0, #8]
    bx lr
endfun Pila_init

/**
 * @brief Ingresa un valor en la pila descrita
 * 
 * @param descriptor Descriptor de pila (R0)
 * @param valor Valor a ingresar (R1)
 * @return int 0 si la operación se realizó, -1 si la pila estaba llena
 */
defun Pila_push
    ldr R2, [R0, #8]
    ldr R3, [R0, #4]
    
    cmp R2, R3
    bhs 1f
    
    str R1, [R2]
    add R2, #4
    str R2, [R0, #8]
    mov R0, #0
    b fin
    
1:
    mov R0, #-1
    
fin:
    bx lr
endfun Pila_push

/**
 * @brief Quita el último elemento de la pila descrita y copia su valor en
 * destino
 * 
 * @param descriptor Descriptor de pila (R0)
 * @param destino Dirección de la variable de destino (R1)
 * @return int 0 si la operación se realizó, -1 si la pila estaba vacía
 */
defun Pila_pop
    ldr R2, [R0, #8]
    ldr R3, [R0, #0]
    
    cmp R2, R3
    bls 1f
    
    sub R2, R2, #4
    ldr R12, [R2]
    str R12, [R1]
    str R2, [R0, #8]
    mov R0, #0
    b 2f

1:
    mov R0, #-1

2:
    bx lr
endfun Pila_pop
