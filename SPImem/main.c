//----------------------------------------------------------------------------
// C main line
//----------------------------------------------------------------------------

#include <m8c.h>        // part specific constants and macros
#include "PSoCAPI.h"    // PSoC API definitions for all User Modules


void main(void)
{
	// M8C_EnableGInt ; // Uncomment this line to enable Global Interrupts
	// Insert your main routine code here.
	
	
	//-------------------------------------------------
	// Prototypes of the SPIS_1 API.
	//-------------------------------------------------
	SPI_Start(SPI_SPIS_MODE_0|SPI_SPIS_MSB_FIRST);
	
	SPI_EnableInt();
	/**
	extern void  SPIS_1_Stop(void);
	extern void  SPIS_1_SetupTxData(BYTE bTxData);
	extern BYTE  SPIS_1_bReadRxData(void);
	extern BYTE  SPIS_1_bReadStatus(void);
	extern void  SPIS_1_DisableSS(void);
	extern void  SPIS_1_EnableSS(void);
	**/
	
}
