

include "m8c.inc"
include "memory.inc"
include "UART.inc"



export  io_read
export _io_read

export  io_write
export _io_write



.SECTION
; en A tengo el banco y en X tengo el address
 io_read:
_io_read:
   RAM_PROLOGUE RAM_USE_CLASS_1
   cmp	A, 0
   jz READ_REG
   M8C_SetBank1    ; iopage = 1
READ_REG:
   mov A, reg[X+0]  ; Leo el registro y lo guardo en A (valor de retorno)
   M8C_SetBank0    ; iopage = 0
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret
.ENDSECTION

.SECTION
; en A tengo el banco y en X tengo el address
;           data -> X-6
;            add -> X-5
;           bank -> X-4
 io_write:
_io_write:
   RAM_PROLOGUE RAM_USE_CLASS_1
   push X
   mov X, SP
   mov A,[X-4] ; bank
   cmp	A, 0
   jz ESCRIBIR  ; Si es 1 cambio de pagina
   or F,0x10    ; iopage = 1
ESCRIBIR:
   mov A,[X-6]
   mov X,[X-5]
   mov REG[X],A
   call pulse
TXDATO:
   and F,0xCF   ; iopage = 0
   pop X
   ret
.ENDSECTION



pulse:
   	or REG[PRT2DR], 0x80
    and REG[PRT2DR], ~0x80
	ret