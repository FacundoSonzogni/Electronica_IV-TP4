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
 * @brief Inicializa un descriptor de cola
 * 
 * @param descriptor Descriptor (R0)
 * @param base Dirección base de memoria (R1)
 * @param tamano Tamano de memoria para la cola (R2)
 */
defun Cola_init
    add R3, R1, R2, lsl #2
    mov R12, #0
    str R1 ,[R0, #0]
    str R3 ,[R0, #4]
    str R1 ,[R0, #8]
    str R1 ,[R0, #12]
    str R12,[R0, #16]
    bx lr
endfun Cola_init

/**
 * @brief Pone un nuevo valor en cola.
 * 
 * @param descriptor Descriptor de cola (R0)
 * @param valor Valor a introducir  (R1)
 * @return int 0 si la operación fue exitosa. -1 si la cola estaba llena.
 */
defun Cola_pone
    push {r4-r5, lr}             

    ldr r2, [r0, #4]               // Carga el valor de la dirección [R0 + 4] en R2 (final de la cola)
    ldr r3, [r0, #8]               // Carga el valor de la dirección [R0 + 8] en R3 (puntero al final de los datos en la cola)
    ldr r4, [r0, #12]              // Carga el valor de la dirección [R0 + 12] en R4 (puntero al inicio de los datos en la cola)
    ldr r5, [r0, #0]               // Carga el valor de la dirección [R0 + 0] en R5 (base de la cola)
    ldr r12, [r0, #16]             // Carga el valor de la dirección [R0 + 16] en R12 (bandera de cola llena/vacía)

    cmp r12, #0                    
    bne 1f                         

    str r1, [r3]                   
    add r3, r3, #4                 
    cmp r3, r2                     
    beq 2f                         

    0:                             
        cmp r3, r4                 
        beq 3f                     
        str r3, [r0, #8]           
        mov r0, #0                 
        b fin                      

    1:                             
        mov r0, #-1                
        b fin                      

    2:                             
        mov r3, r5                 
        b 0b                       

    3:                             
        mov r12, #1                
        str r12, [r0, #16]         
        str r3, [r0, #8]           
        mov r0, #0                 
        b fin                      

    fin:
        pop {r4-r5, pc}            
endfun Cola_pone

/**
 * @brief Quita el elemento más antiguo de la cola y escribe su valor en 
 * destino.
 * 
 * @param descriptor Descriptor de cola (R0)
 * @param destino Puntero a variable donde guardar el valor quitado (R1)
 * @return int 0 si la operación tuvo éxito. -1 si la cola estaba vacía.
 */
defun Cola_quita
   push {r4-r6, lr}               

    ldr r2, [r0, #4]               // Carga el valor de la dirección [R0 + 4] en R2 (final de la cola)
    ldr r3, [r0, #8]               // Carga el valor de la dirección [R0 + 8] en R3 (puntero al final de los datos en la cola)
    ldr r4, [r0, #12]              // Carga el valor de la dirección [R0 + 12] en R4 (puntero al inicio de los datos en la cola)
    ldr r5, [r0, #0]               // Carga el valor de la dirección [R0 + 0] en R5 (base de la cola)
    ldr r12, [r0, #16]             // Carga el valor de la dirección [R0 + 16] en R12 (bandera de cola llena/vacía)

    cmp r12, #1                    
    bne 1f                         
    mov r12, #0                    
    str r12, [r0, #16]             
    
    0:                             
        ldr r6, [r4]               
        str r6, [r1]               
        add r4, r4, #4             
        cmp r4, r2                 
        beq 2f                     
        str r4, [r0, #12]          
        mov r0, #0                 
        b salida                   

    1:                             
        cmp r3, r4                 
        bne 0b                     
        mov r0, #-1                
        b salida                   

    2:                             
        mov r4, r5                 
        str r4, [r0, #12]          
        mov r0, #0                 
        b salida                   

    salida:                        
        pop {r4-r6, pc}
endfun Cola_quita
