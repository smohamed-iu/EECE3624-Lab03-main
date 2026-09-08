/**************************************************************************
 *     File: Lab03.asm
 * Lab Name: Lab 03
 *   Author: Sammy Mohamed
 *  Created: 09/07/2026
 *
 * This program reads simulated sensor data from SRAM, 
 *compares the values, and stores the result in SRAM
 *************************************************************************/

/************************************************************************
 * NOTE!  To populate the sensor data to memory, follow these steps!
 * 1) Set breakpoint on 1st instruction RJMP
 * 2) Set the stimulus file
 *    - Debug->Set Stimufile.  Select Lab03.stim
 *    - This only needs to be done ONCE (will save in project file)
 *    - Should be in your Project file from the Repo, but do once to be sure.
 * 3) Execute stimulus file
 *    - Debug->Execute Stimufile
 *    - This needs to be run EVERY TIME you restart a debug session.  :-(
 * 4) single step code
 * 5) Check that data IRAM at 0x0100 has changed "61 97"
 * 
 * Sensor1 Located at 0x0100 (preset to 0x61)
 * Sensor2 Located at 0x0101 (preset to 0x97)
 * 
 * NOTE:  For testing, you can modify these after loading them
 * to make sure all of your branches work properly
 ***********************************************************************/
.equ THRESHOLD = 0x90
.def Sensor1 = R20
.def Sensor2 = R21
.org 0x0000 ; next instruction will be written to address 0x0000
            ; (the location of the reset vector)
RJMP main	; set reset vector to point to the main code entry point

main:       ; jump here on reset

	; initialize the stack (RAMEND = 0x10FF by default for the ATmega128A)
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	LDI R16, low(RAMEND)
	OUT SPL, R16

    ;----------------------------------
    ; student-written code begins here    
LDI R16, 0x61
LDI R17, 0x97

LDI XH, high(0x0100)
LDI XL, low(0x0100)

ST X+, R16
ST X, R17

LDI YH, high(0x0100)
LDI YL, low(0x0100)

LD Sensor1, Y+
LD Sensor2, Y

LDI YH, high(0x0110)
LDI YL, low(0x0110)

CPI Sensor1, THRESHOLD
BRSH sensor1_ge

LDI R18, 0x50
ST Y+, R18
RJMP store_sensor1

sensor1_ge:
LDI R18, 0x46
ST Y+, R18

store_sensor1:
ST Y+, Sensor1

CPI Sensor2, THRESHOLD
BRLT sensor2_less

LDI R18, 0x73
ST Y+, R18
RJMP compare_sensors

sensor2_less:
LDI R18, 0x69
ST Y+, R18

compare_sensors:
CP Sensor1, Sensor2
BREQ sensors_equal

LDI R18, 115
ST Y, R18
RJMP done

sensors_equal:
LDI R18, 108
ST Y, R18

done:
NOP