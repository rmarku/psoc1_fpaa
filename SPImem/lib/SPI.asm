;;*****************************************************************************
;;*****************************************************************************
;;  FILENAME: SPI.asm
;;   Version: 2.80, Updated on 2015/3/4 at 22:27:42
;;  Generated by PSoC Designer 5.4.3191
;;
;;  DESCRIPTION: SPIS User Module software implementation file.
;;
;;  NOTE: User Module APIs conform to the fastcall16 convention for marshalling
;;        arguments and observe the associated "Registers are volatile" policy.
;;        This means it is the caller's responsibility to preserve any values
;;        in the X and A registers that are still needed after the API functions
;;        returns. For Large Memory Model devices it is also the caller's 
;;        responsibility to perserve any value in the CUR_PP, IDX_PP, MVR_PP and 
;;        MVW_PP registers. Even though some of these registers may not be modified
;;        now, there is no guarantee that will remain the case in future releases.
;;-----------------------------------------------------------------------------
;;  Copyright (c) Cypress Semiconductor 2015. All Rights Reserved.
;;*****************************************************************************
;;*****************************************************************************

include "m8c.inc"
include "memory.inc"
include "SPI.inc"

;-----------------------------------------------
;  Global Symbols
;-----------------------------------------------
export   SPI_EnableInt
export  _SPI_EnableInt
export   SPI_DisableInt
export  _SPI_DisableInt
export   SPI_Start
export  _SPI_Start
export   SPI_Stop
export  _SPI_Stop
export   SPI_SetupTxData
export  _SPI_SetupTxData
export   SPI_bReadRxData
export  _SPI_bReadRxData
export   SPI_bReadStatus
export  _SPI_bReadStatus

IF (SPI_SW_SS_Feature)
export   SPI_DisableSS
export  _SPI_DisableSS
export   SPI_EnableSS
export  _SPI_EnableSS

export   SPI_SetSS	             ; Deprecated
export  _SPI_SetSS              ; Deprecated
export   SPI_ClearSS            ; Deprecated
export  _SPI_ClearSS            ; Deprecated
ENDIF

;  Old exports.  Will be removed in future release.
;  Do not use
export   bSPI_ReadRxData
export  _bSPI_ReadRxData
export   bSPI_ReadStatus
export  _bSPI_ReadStatus

;-----------------------------------------------
;  Constant Definitions
;-----------------------------------------------
bfCONTROL_REG_START_BIT:   equ   1     ; Control register start bit


area UserModules (ROM, REL)


.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: SPI_EnableInt
;
;  DESCRIPTION:
;     Enables the SPIS interrupt by setting the interrupt enable mask
;     bit associated with this User Module.
;
;     NOTE:  Remember to enable the global interrupt by calling the
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS: none
;
;  RETURNS: none
;
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 SPI_EnableInt:
_SPI_EnableInt:
   RAM_PROLOGUE RAM_USE_CLASS_1
   M8C_EnableIntMask SPI_INT_REG, SPI_bINT_MASK
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret

.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: SPI_DisableInt
;
;  DESCRIPTION:
;     Disables this SPIS's interrupt by clearing the interrupt enable mask bit
;     associated with this User Module.
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:  none
;
;  RETURNS: none
;
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 SPI_DisableInt:
_SPI_DisableInt:
   RAM_PROLOGUE RAM_USE_CLASS_1
   M8C_DisableIntMask   SPI_INT_REG, SPI_bINT_MASK
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret

.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: SPI_Start
;
;  DESCRIPTION:
;     Sets the start bit, SPI mode, and LSB/MSB first configuration of the SPIS
;     user module.
;
;     SPIS User Module will be ready to receive data, when an SPI Master initiates
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:
;     BYTE bConfiguration - Consists of SPI Mode and LSB/MSB first bit.
;           Use defined masks - masks can be OR'd together.
;     PASSED in Accumulator.
;
;  RETURNS:  none
;
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 SPI_Start:
_SPI_Start:
   RAM_PROLOGUE RAM_USE_CLASS_1
   ; setup the SPIS configuration setting
   or    A, bfCONTROL_REG_START_BIT
   mov   REG[SPI_CONTROL_REG], A
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret

.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: SPI_Stop
;
;  DESCRIPTION:
;     Disables SPIS operation, and de-asserts the slave select signals.
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:  none
;
;  RETURNS:  none
;
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 SPI_Stop:
_SPI_Stop:
   RAM_PROLOGUE RAM_USE_CLASS_1
   ; clear the SPIS stop bits
   and   REG[SPI_CONTROL_REG], ~bfCONTROL_REG_START_BIT
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret

.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: SPI_SetupTxData
;
;  DESCRIPTION:
;     Loads data into the SPI Tx Buffer in readiness for an SPI Tx/Rx cycle.
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:
;     BYTE  bTxData - data to transmit.
;        Passed in A register
;
;  RETURNS:  none
;
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 SPI_SetupTxData:
_SPI_SetupTxData:
   RAM_PROLOGUE RAM_USE_CLASS_1
   mov REG[SPI_TX_BUFFER_REG], A
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret

.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: SPI_bReadRxData
;
;  DESCRIPTION:
;     Reads the RX buffer register.  Should check the status regiser to make
;     sure data is valid.
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:  none
;
;  RETURNS:
;     bRxData - returned in A.
;
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 SPI_bReadRxData:
_SPI_bReadRxData:
 bSPI_ReadRxData:
_bSPI_ReadRxData:
   RAM_PROLOGUE RAM_USE_CLASS_1
   mov A, REG[SPI_RX_BUFFER_REG]
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret

.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: SPI_bReadStatus
;
;  DESCRIPTION:
;     Reads the SPIS Status bits in the Control/Status register.
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:  none
;
;  RETURNS:
;     BYTE  bStatus - transmit status data.  Use the defined bit masks.
;        Returned in Accumulator.
;
;  SIDE EFFECTS: 
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
 SPI_bReadStatus:
_SPI_bReadStatus:
 bSPI_ReadStatus:
_bSPI_ReadStatus:
   RAM_PROLOGUE RAM_USE_CLASS_1
   mov A,  REG[SPI_CONTROL_REG]
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret

.ENDSECTION

IF (SPI_SW_SS_Feature)

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: SPI_DisableSS
;
;  DESCRIPTION:
;     Set the active-low "SS" Slave Select signal to the HIGH state
;     via firmware
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:  none
;
;  RETURNS: none
;
;  SIDE EFFECTS:
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
;    If the software slave select mode is not enabled.  This function
;    may change the hardware SS input signal.
;
 SPI_DisableSS:
_SPI_DisableSS:
 SPI_SetSS:		; This name deprecated
_SPI_SetSS:		; This name deprecated
   RAM_PROLOGUE RAM_USE_CLASS_1
   M8C_SetBank1
   or  reg[SPI_OUTPUT_REG],SPI_SPIS_SLAVE_SELECT
   M8C_SetBank0
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret

.ENDSECTION

.SECTION
;-----------------------------------------------------------------------------
;  FUNCTION NAME: SPI_EnableSS
;
;  DESCRIPTION:
;     Set the active-low "SS" Slave select signal to the LOW state
;     via firmware
;
;-----------------------------------------------------------------------------
;
;  ARGUMENTS:  none
;
;  RETURNS: none
;
;  SIDE EFFECTS:   
;    The A and X registers may be modified by this or future implementations
;    of this function.  The same is true for all RAM page pointer registers in
;    the Large Memory Model.  When necessary, it is the calling function's
;    responsibility to perserve their values across calls to fastcall16 
;    functions.
;
;    If the software slave select mode is not enabled.  This function
;    may change the hardware SS input signal.
;
 SPI_EnableSS:
_SPI_EnableSS:
 SPI_ClearSS:		; This name deprecated
_SPI_ClearSS:		; This name deprecated
   RAM_PROLOGUE RAM_USE_CLASS_1
   M8C_SetBank1
   and  reg[SPI_OUTPUT_REG],~SPI_SPIS_SLAVE_SELECT
   M8C_SetBank0
   RAM_EPILOGUE RAM_USE_CLASS_1
   ret

.ENDSECTION

ENDIF

; End of File SPI.asm
