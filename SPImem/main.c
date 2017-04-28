//----------------------------------------------------------------------------
// C main line
//----------------------------------------------------------------------------

#include <m8c.h>        // part specific constants and macros
#include "PSoCAPI.h"    // PSoC API definitions for all User Modules


void main(void)
{
	// M8C_EnableGInt ; // Uncomment this line to enable Global Interrupts
	// Insert your main routine code here.
	 BYTE bData = 'H';
	
	//-------------------------------------------------
	//    Prototypes of the SPIS_1 API.
	//-------------------------------------------------
	SPI_Start(SPI_SPIS_MODE_0|SPI_SPIS_MSB_FIRST);
	//SPI_EnableInt();

	PRT2DR &= ~ 0x80 ; //Turns the LED On.
	PRT2DR |= 0x80 ; //Turns the LED Off.
	
	while (TRUE){
 		SPI_SetupTxData(bData);
		while(!(SPI_bReadStatus() & SPI_SPIS_SPI_COMPLETE));/* 		this loop waits until slave done receiving one character 	*/
		bData = SPI_bReadRxData();
		if (bData == 'H'){
			//PRT2DR &= ~ 0x80 ; //Turns the LED On.
		}else{
			//PRT2DR |= 0x80 ; //Turns the LED Off.
		}
	}	
}
