//----------------------------------------------------------------------------
// C main line
//----------------------------------------------------------------------------

#include <m8c.h>        // part specific constants and macros
#include "PSoCAPI.h"    // PSoC API definitions for all User Modules


extern BYTE io_read(BYTE bank, BYTE add);
#pragma fastcall16 io_read;

extern void io_write(BYTE bank, BYTE add, BYTE data);
#pragma fastcall16 io_write;



BYTE test(BYTE bank, BYTE add, BYTE data){
	return (bank + add + data);
	
}

#pragma fastcall16 test;

#define RX_BUFFER_SIZE 64
BYTE rx_buffer[RX_BUFFER_SIZE];
BYTE rx_start = 0;
BYTE rx_end = 0;

void RX_ISR(void);
BYTE read_data(void);
BYTE buffer_cant(void);


BYTE buffer_cant(void){
	BYTE rx_end_tmp = rx_end;
	if (rx_end_tmp < rx_start){
		rx_end_tmp += RX_BUFFER_SIZE;
	}
	return rx_end_tmp-rx_start;
}

void main(void)
{
	int i;
	BYTE tmp;
	
	BYTE cantidad;
	BOOL rw;
	BYTE bank;
	BYTE address;
	
	
	BYTE numDato=0;
	WORD timeout=0;
	
	//-------------------------------------------------
	//    Prototypes of the SPIS_1 API.
	//-------------------------------------------------
	LPF2_1_Start(LPF2_1_HIGHPOWER);
	
    UART_EnableInt();
	//UART_IntCntl(UART_ENABLE_RX_INT);     // Enable RX interrupts
	//UART_IntCntl(UART_DISABLE_TX_INT);    // Disable TX interrupts
	UART_Start(UART_PARITY_NONE);
	M8C_EnableGInt ; // Uncomment this line to enable Global Interrupts
	
	
   	//PRT2DR |= 0x80;
	while (1){
		if (timeout == 0){
			numDato = 0;  // reseteo el procesamiento
		}else 
			timeout--;		
		
		// Si hay datos proceso
		if (buffer_cant() > 0){
			timeout = 0xfff;
			
			switch  (numDato){
				case 0:   // es el primer byte recibido, parsear datos
					tmp = read_data();
					bank = (tmp & 0x01);					
        			cantidad = 1 + ((tmp & 0x7E) >> 1);
					rw = (tmp & 0x80) == 0;
					numDato++;
					
					break;
				
				case 1:   // siempre es la address
					address = read_data();
					
					if (rw){ // Si tengo que leer, no espero tercer byte y leo
						numDato = 0;
						for(i=0;i<cantidad;i++){
							//UART_TX_BUFFER_REG = add[i];
							while(!(UART_bReadTxStatus()&UART_TX_BUFFER_EMPTY)){}
							tmp = io_read(bank, address+i);
							UART_SendData(tmp);
						}
					}else{
						numDato++;
					}
					
					break;
					
				default: // numDato = 2 o mas
					tmp = read_data();
					io_write(bank, address + numDato - 2, tmp);
					
					numDato++;
					if (numDato-2 == cantidad){// Si era el ultimo dato envio FF
						numDato = 0;
					
						while(!(UART_bReadTxStatus()&UART_TX_BUFFER_EMPTY)){}
							
						UART_SendData(0xff);
					}
					break;
			}
		}
	}
}

BYTE read_data(void){
	rx_start++;
  	rx_start &= (RX_BUFFER_SIZE-1);
	return rx_buffer[rx_start];
}


void RX_ISR(void){

}
