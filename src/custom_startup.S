.section .vectors, "ax"
.global __vectors, __VECTOR_TABLE, __vectors_end
__VECTOR_TABLE:
__vectors:
.word __StackTop
.word _reset_handler

.rept 46
.word default_handler
.endr
__vectors_end:

.section .reset, "ax"
.global _entry_point
.thumb_func
_entry_point:

.global _reset_handler
.thumb_func
_reset_handler:
    ldr r0, =__StackTop
    msr msp, r0
    ldr r0, =__bss_start__
    ldr r1, =__bss_end__
    cmp r0, r1
    bhs 2f
    mov r2, #0
1:  str r2, [r0]
    add r0, #4
    cmp r0, r1
    blo 1b
2:
    cpsie i
    bl main
    b .

.section .text
.global default_handler
.thumb_func
default_handler:
.global __unhandled_user_irq
.thumb_func
__unhandled_user_irq:
.global hard_assertion_failure
.thumb_func
hard_assertion_failure:
.global runtime_run_initializers
.thumb_func
runtime_run_initializers:
    bx lr
