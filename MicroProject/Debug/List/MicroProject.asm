
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _colloc=R5
	.DEF _rowloc=R4
	.DEF _CodeID=R6
	.DEF _CodeID_msb=R7
	.DEF _counter=R9
	.DEF _ShowMenu=R8
	.DEF _MenuOption=R11
	.DEF _RegisteredCount=R10
	.DEF _registration=R13
	.DEF _code=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  LOW(_0x7),HIGH(_0x7),0x0,0x0
	.DB  0x2,0x0,0x4,0x0

_0x4:
	.DB  LOW(_0x3),HIGH(_0x3),LOW(_0x3+2),HIGH(_0x3+2),LOW(_0x3+4),HIGH(_0x3+4),LOW(_0x3+6),HIGH(_0x3+6)
	.DB  LOW(_0x3+8),HIGH(_0x3+8),LOW(_0x3+10),HIGH(_0x3+10),LOW(_0x3+12),HIGH(_0x3+12),LOW(_0x3+14),HIGH(_0x3+14)
	.DB  LOW(_0x3+16),HIGH(_0x3+16),LOW(_0x3+18),HIGH(_0x3+18),LOW(_0x3+20),HIGH(_0x3+20),LOW(_0x3+22),HIGH(_0x3+22)
_0x6:
	.DB  LOW(_0x5),HIGH(_0x5),LOW(_0x5+3),HIGH(_0x5+3),LOW(_0x5+5),HIGH(_0x5+5),LOW(_0x5+7),HIGH(_0x5+7)
	.DB  LOW(_0x5+10),HIGH(_0x5+10),LOW(_0x5+12),HIGH(_0x5+12),LOW(_0x5+14),HIGH(_0x5+14),LOW(_0x5+15),HIGH(_0x5+15)
	.DB  LOW(_0x5+17),HIGH(_0x5+17),LOW(_0x5+19),HIGH(_0x5+19),LOW(_0x5+20),HIGH(_0x5+20),LOW(_0x5+22),HIGH(_0x5+22)
	.DB  LOW(_0x5+24),HIGH(_0x5+24),LOW(_0x5+25),HIGH(_0x5+25),LOW(_0x5+27),HIGH(_0x5+27)
_0x9:
	.DB  LOW(_0x8),HIGH(_0x8)
_0xB:
	.DB  LOW(_0xA),HIGH(_0xA)
_0xD:
	.DB  LOW(_0xC),HIGH(_0xC)
_0x0:
	.DB  0x31,0x0,0x34,0x0,0x37,0x0,0x2A,0x0
	.DB  0x32,0x0,0x35,0x0,0x38,0x0,0x30,0x0
	.DB  0x33,0x0,0x36,0x0,0x39,0x0,0x23,0x0
	.DB  0x31,0x30,0x0,0x32,0x30,0x0,0x31,0x29
	.DB  0x44,0x65,0x6C,0x65,0x74,0x65,0x20,0x20
	.DB  0x20,0x32,0x29,0x49,0x6E,0x73,0x65,0x72
	.DB  0x74,0x20,0x33,0x29,0x48,0x69,0x73,0x74
	.DB  0x6F,0x72,0x79,0x2D,0x3E,0x0,0x31,0x29
	.DB  0x44,0x65,0x6C,0x65,0x74,0x65,0x20,0x20
	.DB  0x20,0x32,0x29,0x49,0x6E,0x73,0x65,0x72
	.DB  0x74,0x20,0x33,0x29,0x48,0x69,0x73,0x74
	.DB  0x6F,0x72,0x79,0x20,0x2D,0x3E,0x0,0x20
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x49
	.DB  0x44,0x20,0x46,0x6F,0x72,0x20,0x44,0x65
	.DB  0x6C,0x65,0x74,0x65,0x20,0x2D,0x3E,0x20
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x49
	.DB  0x44,0x20,0x46,0x6F,0x72,0x20,0x49,0x6E
	.DB  0x73,0x65,0x72,0x74,0x20,0x2D,0x3E,0x20
	.DB  0x0,0x75,0x6E,0x6B,0x6E,0x6F,0x77,0x6E
	.DB  0x20,0x43,0x6F,0x6D,0x6D,0x61,0x6E,0x64
	.DB  0x21,0x0,0x4D,0x65,0x6D,0x6F,0x72,0x79
	.DB  0x20,0x49,0x73,0x20,0x45,0x6D,0x70,0x74
	.DB  0x79,0x0,0x41,0x63,0x63,0x65,0x73,0x73
	.DB  0x20,0x0,0x20,0x44,0x65,0x6C,0x65,0x74
	.DB  0x65,0x64,0x2E,0x0,0x20,0x4E,0x6F,0x74
	.DB  0x20,0x46,0x6F,0x75,0x6E,0x64,0x2E,0x0
	.DB  0x25,0x73,0x0,0x20,0x47,0x72,0x61,0x6E
	.DB  0x74,0x65,0x64,0x0,0x4D,0x65,0x6D,0x6F
	.DB  0x72,0x79,0x20,0x49,0x73,0x20,0x46,0x75
	.DB  0x6C,0x6C,0x0,0x25,0x64,0x0,0x2D,0x0
	.DB  0x41,0x63,0x63,0x65,0x73,0x73,0x20,0x44
	.DB  0x65,0x6E,0x69,0x65,0x64,0x21,0x0,0x41
	.DB  0x63,0x63,0x65,0x73,0x73,0x20,0x47,0x72
	.DB  0x61,0x6E,0x74,0x65,0x64,0x21,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x49,0x44,0x20
	.DB  0x2D,0x3E,0x20,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x3+2
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x3+4
	.DW  _0x0*2+4

	.DW  0x02
	.DW  _0x3+6
	.DW  _0x0*2+6

	.DW  0x02
	.DW  _0x3+8
	.DW  _0x0*2+8

	.DW  0x02
	.DW  _0x3+10
	.DW  _0x0*2+10

	.DW  0x02
	.DW  _0x3+12
	.DW  _0x0*2+12

	.DW  0x02
	.DW  _0x3+14
	.DW  _0x0*2+14

	.DW  0x02
	.DW  _0x3+16
	.DW  _0x0*2+16

	.DW  0x02
	.DW  _0x3+18
	.DW  _0x0*2+18

	.DW  0x02
	.DW  _0x3+20
	.DW  _0x0*2+20

	.DW  0x02
	.DW  _0x3+22
	.DW  _0x0*2+22

	.DW  0x18
	.DW  _keypad
	.DW  _0x4*2

	.DW  0x03
	.DW  _0x5
	.DW  _0x0*2+24

	.DW  0x02
	.DW  _0x5+3
	.DW  _0x0*2+14

	.DW  0x02
	.DW  _0x5+5
	.DW  _0x0*2+14

	.DW  0x03
	.DW  _0x5+7
	.DW  _0x0*2+27

	.DW  0x02
	.DW  _0x5+10
	.DW  _0x0*2+14

	.DW  0x02
	.DW  _0x5+12
	.DW  _0x0*2+14

	.DW  0x01
	.DW  _0x5+14
	.DW  _0x0*2+1

	.DW  0x02
	.DW  _0x5+15
	.DW  _0x0*2+14

	.DW  0x02
	.DW  _0x5+17
	.DW  _0x0*2+14

	.DW  0x01
	.DW  _0x5+19
	.DW  _0x0*2+1

	.DW  0x02
	.DW  _0x5+20
	.DW  _0x0*2+14

	.DW  0x02
	.DW  _0x5+22
	.DW  _0x0*2+14

	.DW  0x01
	.DW  _0x5+24
	.DW  _0x0*2+1

	.DW  0x02
	.DW  _0x5+25
	.DW  _0x0*2+14

	.DW  0x02
	.DW  _0x5+27
	.DW  _0x0*2+14

	.DW  0x1E
	.DW  _AllowList
	.DW  _0x6*2

	.DW  0x01
	.DW  _0x7
	.DW  _0x0*2+1

	.DW  0x01
	.DW  _0x8
	.DW  _0x0*2+1

	.DW  0x02
	.DW  _AccessResult1
	.DW  _0x9*2

	.DW  0x01
	.DW  _0xA
	.DW  _0x0*2+1

	.DW  0x02
	.DW  _list
	.DW  _0xB*2

	.DW  0x20
	.DW  _0xC
	.DW  _0x0*2+30

	.DW  0x02
	.DW  _menu
	.DW  _0xD*2

	.DW  0x01
	.DW  _0x39
	.DW  _0x0*2+1

	.DW  0x03
	.DW  _0x39+1
	.DW  _0x0*2+24

	.DW  0x03
	.DW  _0x39+4
	.DW  _0x0*2+59

	.DW  0x02
	.DW  _0x39+7
	.DW  _0x0*2+95

	.DW  0x01
	.DW  _0x39+9
	.DW  _0x0*2+1

	.DW  0x01
	.DW  _0x39+10
	.DW  _0x0*2+1

	.DW  0x18
	.DW  _0x3C
	.DW  _0x0*2+97

	.DW  0x18
	.DW  _0x3C+24
	.DW  _0x0*2+97

	.DW  0x18
	.DW  _0x3C+48
	.DW  _0x0*2+121

	.DW  0x11
	.DW  _0x3C+72
	.DW  _0x0*2+145

	.DW  0x10
	.DW  _0x43
	.DW  _0x0*2+162

	.DW  0x10
	.DW  _0x43+16
	.DW  _0x0*2+162

	.DW  0x10
	.DW  _0x43+32
	.DW  _0x0*2+162

	.DW  0x01
	.DW  _0x43+48
	.DW  _0x0*2+1

	.DW  0x02
	.DW  _0x43+49
	.DW  _0x0*2+14

	.DW  0x08
	.DW  _0x43+51
	.DW  _0x0*2+178

	.DW  0x0A
	.DW  _0x43+59
	.DW  _0x0*2+186

	.DW  0x0C
	.DW  _0x43+69
	.DW  _0x0*2+196

	.DW  0x01
	.DW  _0x43+81
	.DW  _0x0*2+1

	.DW  0x02
	.DW  _0x4C
	.DW  _0x0*2+14

	.DW  0x01
	.DW  _0x4C+2
	.DW  _0x0*2+1

	.DW  0x08
	.DW  _0x4C+3
	.DW  _0x0*2+178

	.DW  0x09
	.DW  _0x4C+11
	.DW  _0x0*2+211

	.DW  0x0F
	.DW  _0x4C+20
	.DW  _0x0*2+220

	.DW  0x01
	.DW  _0x4C+35
	.DW  _0x0*2+1

	.DW  0x01
	.DW  _0x4C+36
	.DW  _0x0*2+1

	.DW  0x02
	.DW  _0x53
	.DW  _0x0*2+6

	.DW  0x01
	.DW  _0x53+2
	.DW  _0x0*2+1

	.DW  0x02
	.DW  _0x53+3
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x53+5
	.DW  _0x0*2+8

	.DW  0x02
	.DW  _0x53+7
	.DW  _0x0*2+6

	.DW  0x01
	.DW  _0x53+9
	.DW  _0x0*2+1

	.DW  0x02
	.DW  _0x5B
	.DW  _0x0*2+238

	.DW  0x02
	.DW  _0x5B+2
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0x5B+4
	.DW  _0x0*2+240

	.DW  0x02
	.DW  _0x5B+19
	.DW  _0x0*2+6

	.DW  0x0F
	.DW  _0x5B+21
	.DW  _0x0*2+240

	.DW  0x10
	.DW  _0x5B+36
	.DW  _0x0*2+255

	.DW  0x0D
	.DW  _0x5B+52
	.DW  _0x0*2+271

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdio.h>
;#include <stdlib.h>
;
;
;#define LED_R      PORTD.0
;#define LED_G      PORTD.1
;#define LED_B      PORTD.2
;#define key_prt  PORTC
;#define key_ddr  DDRC
;#define key_pin  PINC
;#define lcd_dprt PORTA
;#define lcd_dddr DDRA
;#define lcd_dpin PINA
;#define lcd_cprt PORTB
;#define lcd_cddr DDRB
;#define lcd_cpin PINB
;#define lcd_rs 0
;#define lcd_rw 1
;#define lcd_en 2
;#define NameSize 4
;
;
;unsigned char*  keypad[3][4] =  { "1","4","7","*",
;                                  "2","5","8","0",
;                                  "3","6","9","#",};

	.DSEG
_0x3:
	.BYTE 0x18
;
;
;
;unsigned char* AllowList[NameSize+1][3]={{"10","0","0"},{"20","0","0"},{"","0","0"},{"","0","0"},{"","0","0"}};
_0x5:
	.BYTE 0x1D
;
;
;unsigned char colloc , rowloc;
;unsigned char* CodeID = "";
_0x7:
	.BYTE 0x1
;unsigned char counter=0;
;unsigned char ShowMenu = 0;
;unsigned char MenuOption = 0;
;unsigned char RegisteredCount = 2;
;unsigned char registration = 0;
;unsigned char code = 4;
;unsigned char* AccessResult1 = "";
_0x8:
	.BYTE 0x1
;unsigned char* list = "";
_0xA:
	.BYTE 0x1
;unsigned char * menu= "1)Delete   2)Insert 3)History->";
_0xC:
	.BYTE 0x20
;
;
;void lcdCommand(unsigned char cmnd){
; 0000 0032 void lcdCommand(unsigned char cmnd){

	.CSEG
_lcdCommand:
; .FSTART _lcdCommand
; 0000 0033    lcd_dprt = cmnd;
	ST   -Y,R26
;	cmnd -> Y+0
	LD   R30,Y
	OUT  0x1B,R30
; 0000 0034    lcd_cprt &= ~(1<<lcd_rs);
	CBI  0x18,0
; 0000 0035    lcd_cprt &= ~(1<<lcd_rw);
	RJMP _0x20A0006
; 0000 0036    lcd_cprt |= (1<<lcd_en);
; 0000 0037    delay_us(1);
; 0000 0038    lcd_cprt &= ~(1<<lcd_en);
; 0000 0039    delay_us(100);
; 0000 003A }
; .FEND
;
;void lcdData(unsigned char data){
; 0000 003C void lcdData(unsigned char data){
_lcdData:
; .FSTART _lcdData
; 0000 003D 
; 0000 003E     lcd_dprt = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x1B,R30
; 0000 003F     lcd_cprt |= (1<<lcd_rs);
	SBI  0x18,0
; 0000 0040     lcd_cprt &= ~(1<<lcd_rw);
_0x20A0006:
	CBI  0x18,1
; 0000 0041     lcd_cprt |= (1<<lcd_en);
	SBI  0x18,2
; 0000 0042     delay_us(1);
	__DELAY_USB 3
; 0000 0043     lcd_cprt &= ~(1<<lcd_en);
	CBI  0x18,2
; 0000 0044     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0045 }
	ADIW R28,1
	RET
; .FEND
;
;void lcd_init(){
; 0000 0047 void lcd_init(){
_lcd_init:
; .FSTART _lcd_init
; 0000 0048     lcd_dddr = 0xff;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0049     lcd_cddr = 0xff;
	OUT  0x17,R30
; 0000 004A     lcd_cprt &= ~(1<<lcd_en);
	CBI  0x18,2
; 0000 004B     delay_us(2000);
	__DELAY_USW 4000
; 0000 004C     lcdCommand(0x38);
	LDI  R26,LOW(56)
	RCALL _lcdCommand
; 0000 004D     lcdCommand(0x0C);
	LDI  R26,LOW(12)
	RCALL _lcdCommand
; 0000 004E     lcdCommand(0x01);
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 004F     delay_us(2000);
	__DELAY_USW 4000
; 0000 0050     lcdCommand(0x06);
	LDI  R26,LOW(6)
	RCALL _lcdCommand
; 0000 0051 }
	RET
; .FEND
;
;void lcd_gotoxy(unsigned char x , unsigned char y){
; 0000 0053 void lcd_gotoxy(unsigned char x , unsigned char y){
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
; 0000 0054    unsigned char firstCharAdr[] = {0x80,0xc0,0x94,0xd4};
; 0000 0055    lcdCommand(firstCharAdr[y-1] + x-1 );
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(128)
	ST   Y,R30
	LDI  R30,LOW(192)
	STD  Y+1,R30
	LDI  R30,LOW(148)
	STD  Y+2,R30
	LDI  R30,LOW(212)
	STD  Y+3,R30
;	x -> Y+5
;	y -> Y+4
;	firstCharAdr -> Y+0
	LDD  R30,Y+4
	LDI  R31,0
	SBIW R30,1
	MOVW R26,R28
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDD  R26,Y+5
	ADD  R26,R30
	SUBI R26,LOW(1)
	RCALL _lcdCommand
; 0000 0056    delay_us(100);
	CALL SUBOPT_0x0
; 0000 0057 
; 0000 0058 }
	RJMP _0x20A0003
; .FEND
;
;void lcd_print(char* str){
; 0000 005A void lcd_print(char* str){
_lcd_print:
; .FSTART _lcd_print
; 0000 005B     unsigned char i = 0;
; 0000 005C     while( i < strlen(str)){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	i -> R17
	LDI  R17,0
_0xE:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL _strlen
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x10
; 0000 005D        lcdData(str[i]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _lcdData
; 0000 005E        i++;
	SUBI R17,-1
; 0000 005F     }
	RJMP _0xE
_0x10:
; 0000 0060 }
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
;
;void CleenLCD(){
; 0000 0062 void CleenLCD(){
_CleenLCD:
; .FSTART _CleenLCD
; 0000 0063      lcdCommand(0x01);
	LDI  R26,LOW(1)
	RCALL _lcdCommand
; 0000 0064      delay_us(100);
	CALL SUBOPT_0x0
; 0000 0065      lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0066      delay_us(100);
	CALL SUBOPT_0x0
; 0000 0067 }
	RET
; .FEND
;
;
;
;void LED_Ok(){
; 0000 006B void LED_Ok(){
_LED_Ok:
; .FSTART _LED_Ok
; 0000 006C     LED_R = 0;
	CBI  0x12,0
; 0000 006D     LED_G = 255;
	RJMP _0x20A0005
; 0000 006E     LED_B = 0;
; 0000 006F     delay_ms(100);
; 0000 0070     LED_R = 0;
; 0000 0071     LED_G = 0;
; 0000 0072     LED_B = 0;
; 0000 0073 }
; .FEND
;
;void LED_Error(){
; 0000 0075 void LED_Error(){
_LED_Error:
; .FSTART _LED_Error
; 0000 0076     LED_R = 255;
	SBI  0x12,0
; 0000 0077     LED_G = 0;
	CBI  0x12,1
; 0000 0078     LED_B = 0;
	RJMP _0x20A0004
; 0000 0079     delay_ms(100);
; 0000 007A     LED_R = 0;
; 0000 007B     LED_G = 0;
; 0000 007C     LED_B = 0;
; 0000 007D }
; .FEND
;
;void LED_Warning(){
; 0000 007F void LED_Warning(){
_LED_Warning:
; .FSTART _LED_Warning
; 0000 0080     LED_R = 255;
	SBI  0x12,0
; 0000 0081     LED_G = 255;
_0x20A0005:
	SBI  0x12,1
; 0000 0082     LED_B = 0;
_0x20A0004:
	CBI  0x12,2
; 0000 0083     delay_ms(100);
	CALL SUBOPT_0x1
; 0000 0084     LED_R = 0;
	CBI  0x12,0
; 0000 0085     LED_G = 0;
	CBI  0x12,1
; 0000 0086     LED_B = 0;
	CBI  0x12,2
; 0000 0087 }
	RET
; .FEND
;
;
;void ShowMyMenu(){
; 0000 008A void ShowMyMenu(){
_ShowMyMenu:
; .FSTART _ShowMyMenu
; 0000 008B 
; 0000 008C     CleenLCD();
	RCALL _CleenLCD
; 0000 008D     sprintf(menu,"1)Delete   2)Insert 3)History ->");
	LDS  R30,_menu
	LDS  R31,_menu+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,62
	CALL SUBOPT_0x2
; 0000 008E     lcd_print(menu);
	LDS  R26,_menu
	LDS  R27,_menu+1
	RCALL _lcd_print
; 0000 008F     MenuOption = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0090 
; 0000 0091 }
	RET
; .FEND
;//*********************************************************************************************************
;
;void History(){
; 0000 0094 void History(){
_History:
; .FSTART _History
; 0000 0095 
; 0000 0096     unsigned char i = 0;
; 0000 0097     sprintf(list,"");
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,1
	CALL SUBOPT_0x2
; 0000 0098     CleenLCD();
	RCALL _CleenLCD
; 0000 0099     for(i = 0; i < NameSize ; i++){
	LDI  R17,LOW(0)
_0x36:
	CPI  R17,4
	BRSH _0x37
; 0000 009A         if(strcmp(AllowList[i][0],"") && strcmp(AllowList[i][0],"10")){
	CALL SUBOPT_0x4
	__POINTW2MN _0x39,0
	CALL _strcmp
	CPI  R30,0
	BREQ _0x3A
	CALL SUBOPT_0x4
	__POINTW2MN _0x39,1
	CALL _strcmp
	CPI  R30,0
	BRNE _0x3B
_0x3A:
	RJMP _0x38
_0x3B:
; 0000 009B             strcat(list,AllowList[i][0]);
	CALL SUBOPT_0x3
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	CALL SUBOPT_0x5
	MOVW R26,R30
	CALL SUBOPT_0x6
; 0000 009C             strcat(list,"->");
	__POINTW2MN _0x39,4
	CALL SUBOPT_0x6
; 0000 009D             strcat(list,AllowList[i][2]);
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	CALL SUBOPT_0x7
	MOVW R26,R30
	CALL SUBOPT_0x6
; 0000 009E             strcat(list," ");
	__POINTW2MN _0x39,7
	CALL _strcat
; 0000 009F         }
; 0000 00A0     }
_0x38:
	SUBI R17,-1
	RJMP _0x36
_0x37:
; 0000 00A1     lcd_print(list);
	LDS  R26,_list
	LDS  R27,_list+1
	CALL SUBOPT_0x8
; 0000 00A2     delay_ms(100);
; 0000 00A3     CleenLCD();
	RCALL _CleenLCD
; 0000 00A4     strcmp(list,"");
	CALL SUBOPT_0x3
	__POINTW2MN _0x39,9
	CALL _strcmp
; 0000 00A5     registration = 0;
	CLR  R13
; 0000 00A6     MenuOption = 0;
	CLR  R11
; 0000 00A7     code = 4;
	LDI  R30,LOW(4)
	MOV  R12,R30
; 0000 00A8     strcpy(CodeID,"");
	ST   -Y,R7
	ST   -Y,R6
	__POINTW2MN _0x39,10
	CALL _strcpy
; 0000 00A9 
; 0000 00AA }
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x39:
	.BYTE 0xB
;
;
;void InsertORDelete(){
; 0000 00AD void InsertORDelete(){

	.CSEG
_InsertORDelete:
; .FSTART _InsertORDelete
; 0000 00AE     unsigned char * menu_options = "Enter ID For Delete -> ";
; 0000 00AF     CleenLCD();
	ST   -Y,R17
	ST   -Y,R16
;	*menu_options -> R16,R17
	__POINTWRMN 16,17,_0x3C,0
	RCALL _CleenLCD
; 0000 00B0 
; 0000 00B1 
; 0000 00B2     if(code == 1){
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x3D
; 0000 00B3           strcpy(menu_options,"Enter ID For Delete -> ");
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x3C,24
	CALL _strcpy
; 0000 00B4           registration = 1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 00B5           lcd_print(menu_options);
	MOVW R26,R16
	RCALL _lcd_print
; 0000 00B6     }
; 0000 00B7     else if(code == 2){
	RJMP _0x3E
_0x3D:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x3F
; 0000 00B8            strcpy(menu_options,"Enter ID For Insert -> ");
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x3C,48
	CALL _strcpy
; 0000 00B9            registration = 2;
	LDI  R30,LOW(2)
	MOV  R13,R30
; 0000 00BA            lcd_print(menu_options);
	MOVW R26,R16
	RCALL _lcd_print
; 0000 00BB     }
; 0000 00BC     else if(code == 3){
	RJMP _0x40
_0x3F:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x41
; 0000 00BD         History();
	RCALL _History
; 0000 00BE        registration = 3;
	LDI  R30,LOW(3)
	MOV  R13,R30
; 0000 00BF     }
; 0000 00C0     else{
	RJMP _0x42
_0x41:
; 0000 00C1          strcpy(menu_options,"unknown Command!");
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x3C,72
	CALL _strcpy
; 0000 00C2          lcd_print(menu_options);
	MOVW R26,R16
	CALL SUBOPT_0x8
; 0000 00C3          delay_ms(100);
; 0000 00C4          CleenLCD();
	RCALL _CleenLCD
; 0000 00C5          registration = 0;
	CLR  R13
; 0000 00C6     }
_0x42:
_0x40:
_0x3E:
; 0000 00C7 
; 0000 00C8      MenuOption = 0;
	CLR  R11
; 0000 00C9      code = 4;
	LDI  R30,LOW(4)
	MOV  R12,R30
; 0000 00CA }
	RJMP _0x20A0002
; .FEND

	.DSEG
_0x3C:
	.BYTE 0x59
;
;
;
;void Delete(){
; 0000 00CE void Delete(){

	.CSEG
_Delete:
; .FSTART _Delete
; 0000 00CF 
; 0000 00D0     unsigned char* result = "Memory Is Empty";
; 0000 00D1     unsigned char* error = "Memory Is Empty";
; 0000 00D2     unsigned char find = 0;
; 0000 00D3     CleenLCD();
	CALL __SAVELOCR6
;	*result -> R16,R17
;	*error -> R18,R19
;	find -> R21
	__POINTWRMN 16,17,_0x43,0
	__POINTWRMN 18,19,_0x43,16
	LDI  R21,0
	RCALL _CleenLCD
; 0000 00D4     counter = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 00D5 
; 0000 00D6 
; 0000 00D7     if (RegisteredCount < 2){
	LDI  R30,LOW(2)
	CP   R10,R30
	BRSH _0x44
; 0000 00D8        strcpy(error,"Memory Is Empty");
	ST   -Y,R19
	ST   -Y,R18
	__POINTW2MN _0x43,32
	CALL _strcpy
; 0000 00D9        result = error;
	MOVW R16,R18
; 0000 00DA     }
; 0000 00DB     else{
	RJMP _0x45
_0x44:
; 0000 00DC         while(counter<NameSize){
_0x46:
	LDI  R30,LOW(4)
	CP   R9,R30
	BRSH _0x48
; 0000 00DD             if(!strncmp(AllowList[counter][0],CodeID,2)){
	CALL SUBOPT_0x9
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R7
	ST   -Y,R6
	CALL SUBOPT_0xA
	BRNE _0x49
; 0000 00DE                strcpy(AllowList[counter][0],"");
	CALL SUBOPT_0x9
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x43,48
	CALL SUBOPT_0xB
; 0000 00DF                strcpy(AllowList[counter][2],"0");
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x43,49
	CALL _strcpy
; 0000 00E0                RegisteredCount--;
	DEC  R10
; 0000 00E1                find = 1;
	LDI  R21,LOW(1)
; 0000 00E2                break;
	RJMP _0x48
; 0000 00E3             }
; 0000 00E4             counter = counter + 1;
_0x49:
	INC  R9
; 0000 00E5         }
	RJMP _0x46
_0x48:
; 0000 00E6         if(find == 1){
	CPI  R21,1
	BRNE _0x4A
; 0000 00E7             strcpy(result,"Access ");
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x43,51
	CALL SUBOPT_0xC
; 0000 00E8             result=strcat(result,CodeID);
	MOVW R26,R6
	CALL _strcat
	MOVW R16,R30
; 0000 00E9             result=strcat(result," Deleted.");
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x43,59
	RJMP _0x96
; 0000 00EA         }else{
_0x4A:
; 0000 00EB             strcpy(result,CodeID);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R6
	CALL SUBOPT_0xC
; 0000 00EC             result=strcat(result," Not Found.");
	__POINTW2MN _0x43,69
_0x96:
	CALL _strcat
	MOVW R16,R30
; 0000 00ED         }
; 0000 00EE     }
_0x45:
; 0000 00EF 
; 0000 00F0     lcd_print(result);
	MOVW R26,R16
	CALL SUBOPT_0xD
; 0000 00F1     LED_Warning();
; 0000 00F2     CleenLCD();
; 0000 00F3     registration = 0;
; 0000 00F4     strcpy(CodeID,"");
	__POINTW2MN _0x43,81
	CALL _strcpy
; 0000 00F5     counter = 0;
	CLR  R9
; 0000 00F6 }
	CALL __LOADLOCR6
_0x20A0003:
	ADIW R28,6
	RET
; .FEND

	.DSEG
_0x43:
	.BYTE 0x52
;
;
;void Insert(){
; 0000 00F9 void Insert(){

	.CSEG
_Insert:
; .FSTART _Insert
; 0000 00FA 
; 0000 00FB     unsigned char* value = "0";
; 0000 00FC     counter = 0;
	ST   -Y,R17
	ST   -Y,R16
;	*value -> R16,R17
	__POINTWRMN 16,17,_0x4C,0
	CLR  R9
; 0000 00FD 
; 0000 00FE     CleenLCD();
	RCALL _CleenLCD
; 0000 00FF     if( RegisteredCount < NameSize){
	LDI  R30,LOW(4)
	CP   R10,R30
	BRSH _0x4D
; 0000 0100 
; 0000 0101         while(counter < NameSize){
_0x4E:
	LDI  R30,LOW(4)
	CP   R9,R30
	BRSH _0x50
; 0000 0102             strcpy(value, AllowList[counter][0]);
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x9
	MOVW R26,R30
	CALL SUBOPT_0xC
; 0000 0103             if(!strncmp(value,"",2)){
	__POINTW1MN _0x4C,2
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA
	BRNE _0x51
; 0000 0104                 sprintf(AllowList[counter][0],"%s",CodeID);
	CALL SUBOPT_0x9
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,208
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL SUBOPT_0xE
; 0000 0105                 RegisteredCount = RegisteredCount+1;
	INC  R10
; 0000 0106                 break;
	RJMP _0x50
; 0000 0107             }
; 0000 0108             counter = counter + 1;
_0x51:
	INC  R9
; 0000 0109         }
	RJMP _0x4E
_0x50:
; 0000 010A         strcpy(AccessResult1,"Access ");
	CALL SUBOPT_0xF
	__POINTW2MN _0x4C,3
	CALL _strcpy
; 0000 010B         AccessResult1=strcat(AccessResult1,AllowList[counter][0]);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x9
	MOVW R26,R30
	CALL SUBOPT_0x10
; 0000 010C         AccessResult1=strcat(AccessResult1," Granted");
	CALL SUBOPT_0xF
	__POINTW2MN _0x4C,11
	CALL SUBOPT_0x10
; 0000 010D     }
; 0000 010E     else{
	RJMP _0x52
_0x4D:
; 0000 010F         strcpy(AccessResult1,"Memory Is Full");
	CALL SUBOPT_0xF
	__POINTW2MN _0x4C,20
	CALL _strcpy
; 0000 0110     }
_0x52:
; 0000 0111     lcd_print(AccessResult1);
	LDS  R26,_AccessResult1
	LDS  R27,_AccessResult1+1
	CALL SUBOPT_0xD
; 0000 0112     LED_Warning();
; 0000 0113     CleenLCD();
; 0000 0114     registration = 0;
; 0000 0115     strcpy(CodeID,"");
	__POINTW2MN _0x4C,35
	CALL _strcpy
; 0000 0116     strcpy(AccessResult1,"");
	CALL SUBOPT_0xF
	__POINTW2MN _0x4C,36
	CALL _strcpy
; 0000 0117     counter = 0;
	CLR  R9
; 0000 0118 }
	RJMP _0x20A0002
; .FEND

	.DSEG
_0x4C:
	.BYTE 0x25
;
;
;// (flag=1 means Admin)  (flag=2 means Valid Login)  (flag=* means Invalid Login)
;unsigned char* CheckAccess(){
; 0000 011C unsigned char* CheckAccess(){

	.CSEG
_CheckAccess:
; .FSTART _CheckAccess
; 0000 011D     unsigned char value = 0;
; 0000 011E 
; 0000 011F     unsigned char empty;
; 0000 0120     unsigned char* flag = "*";
; 0000 0121     CleenLCD();
	CALL __SAVELOCR4
;	value -> R17
;	empty -> R16
;	*flag -> R18,R19
	LDI  R17,0
	__POINTWRMN 18,19,_0x53,0
	RCALL _CleenLCD
; 0000 0122 
; 0000 0123     while(counter < NameSize & strlen(CodeID)>0 ){
_0x54:
	MOV  R26,R9
	LDI  R30,LOW(4)
	CALL __LTB12U
	PUSH R30
	MOVW R26,R6
	CALL _strlen
	MOVW R26,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12U
	POP  R26
	AND  R30,R26
	BREQ _0x56
; 0000 0124 
; 0000 0125         if(!strncmp(CodeID,AllowList[counter][0],2)){
	ST   -Y,R7
	ST   -Y,R6
	CALL SUBOPT_0x9
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA
	BRNE _0x57
; 0000 0126             empty = 1;
	LDI  R16,LOW(1)
; 0000 0127             value = atoi(AllowList[counter][2]);
	CALL SUBOPT_0x11
	MOVW R26,R30
	CALL _atoi
	MOV  R17,R30
; 0000 0128             value++;
	SUBI R17,-1
; 0000 0129             strcpy(AllowList[counter][2],"");
	CALL SUBOPT_0x11
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x53,2
	CALL SUBOPT_0xB
; 0000 012A             sprintf(AllowList[counter][2],"%d",value);
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,235
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	CALL SUBOPT_0xE
; 0000 012B             if(counter == 0)
	TST  R9
	BRNE _0x58
; 0000 012C                 strcpy(flag , "1");
	ST   -Y,R19
	ST   -Y,R18
	__POINTW2MN _0x53,3
	RJMP _0x97
; 0000 012D             else{
_0x58:
; 0000 012E                 strcpy(flag , "2");
	ST   -Y,R19
	ST   -Y,R18
	__POINTW2MN _0x53,5
_0x97:
	CALL _strcpy
; 0000 012F                 }
; 0000 0130            break;
	RJMP _0x56
; 0000 0131         }
; 0000 0132         counter = counter +1;
_0x57:
	INC  R9
; 0000 0133     }
	RJMP _0x54
_0x56:
; 0000 0134     if(empty != 1)
	CPI  R16,1
	BREQ _0x5A
; 0000 0135        strcpy(flag , "*");
	ST   -Y,R19
	ST   -Y,R18
	__POINTW2MN _0x53,7
	CALL _strcpy
; 0000 0136     strcpy(CodeID,"");
_0x5A:
	ST   -Y,R7
	ST   -Y,R6
	__POINTW2MN _0x53,9
	CALL _strcpy
; 0000 0137     counter = 0;
	CLR  R9
; 0000 0138     return flag;
	MOVW R30,R18
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; 0000 0139 }
; .FEND

	.DSEG
_0x53:
	.BYTE 0xA
;
;
;
;
;void ReadKeyPad(){
; 0000 013E void ReadKeyPad(){

	.CSEG
_ReadKeyPad:
; .FSTART _ReadKeyPad
; 0000 013F     unsigned char * result = "-";
; 0000 0140     do{
	ST   -Y,R17
	ST   -Y,R16
;	*result -> R16,R17
	__POINTWRMN 16,17,_0x5B,0
_0x5D:
; 0000 0141         key_prt &=0x0F;
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	CALL SUBOPT_0x12
; 0000 0142         colloc = (key_pin & 0x0F);
; 0000 0143 
; 0000 0144     }while(colloc !=0x0F);
	LDI  R30,LOW(15)
	CP   R30,R5
	BRNE _0x5D
; 0000 0145 
; 0000 0146     do{
_0x60:
; 0000 0147         do{
_0x63:
; 0000 0148             delay_ms(20);
	CALL SUBOPT_0x13
; 0000 0149             colloc = (key_pin & 0x0F);
; 0000 014A         }while(colloc == 0x0F);
	LDI  R30,LOW(15)
	CP   R30,R5
	BREQ _0x63
; 0000 014B         delay_ms(20);
	CALL SUBOPT_0x13
; 0000 014C         colloc = (key_pin & 0x0F);
; 0000 014D     }while(colloc == 0x0F);
	LDI  R30,LOW(15)
	CP   R30,R5
	BREQ _0x60
; 0000 014E 
; 0000 014F 
; 0000 0150 
; 0000 0151     while(1){
_0x65:
; 0000 0152 
; 0000 0153         key_prt = 0xEF;
	LDI  R30,LOW(239)
	CALL SUBOPT_0x12
; 0000 0154         colloc = (key_pin &0x0F);
; 0000 0155         if(colloc != 0x0F){
	LDI  R30,LOW(15)
	CP   R30,R5
	BREQ _0x68
; 0000 0156             rowloc = 0;
	CLR  R4
; 0000 0157             break;
	RJMP _0x67
; 0000 0158         }
; 0000 0159 
; 0000 015A 
; 0000 015B         key_prt = 0xDF;
_0x68:
	LDI  R30,LOW(223)
	CALL SUBOPT_0x12
; 0000 015C         colloc = (key_pin & 0x0F);
; 0000 015D         if(colloc != 0x0F){
	LDI  R30,LOW(15)
	CP   R30,R5
	BREQ _0x69
; 0000 015E            rowloc = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 015F             break;
	RJMP _0x67
; 0000 0160         }
; 0000 0161 
; 0000 0162 
; 0000 0163         key_prt = 0xBF;
_0x69:
	LDI  R30,LOW(191)
	CALL SUBOPT_0x12
; 0000 0164         colloc = (key_pin & 0x0F);
; 0000 0165         if(colloc != 0x0F){
	LDI  R30,LOW(15)
	CP   R30,R5
	BREQ _0x6A
; 0000 0166            rowloc = 2;
	LDI  R30,LOW(2)
	MOV  R4,R30
; 0000 0167             break;
	RJMP _0x67
; 0000 0168         }
; 0000 0169     }
_0x6A:
	RJMP _0x65
_0x67:
; 0000 016A 
; 0000 016B 
; 0000 016C     if(colloc == 0x0E){
	LDI  R30,LOW(14)
	CP   R30,R5
	BRNE _0x6B
; 0000 016D         if(MenuOption == 1){
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x6C
; 0000 016E            if(rowloc == 0 ){
	TST  R4
	BRNE _0x6D
; 0000 016F               code = 1;
	RJMP _0x98
; 0000 0170               InsertORDelete();
; 0000 0171            }
; 0000 0172            else if (rowloc == 1){
_0x6D:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x6F
; 0000 0173               code = 2;
	LDI  R30,LOW(2)
	RJMP _0x98
; 0000 0174               InsertORDelete();
; 0000 0175            }
; 0000 0176            else if (rowloc == 2){
_0x6F:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x71
; 0000 0177               code = 3;
	LDI  R30,LOW(3)
_0x98:
	MOV  R12,R30
; 0000 0178               InsertORDelete();
	RCALL _InsertORDelete
; 0000 0179            }
; 0000 017A         }
_0x71:
; 0000 017B 
; 0000 017C         else{
	RJMP _0x72
_0x6C:
; 0000 017D             CodeID = strcat(CodeID, keypad[rowloc][0]);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
; 0000 017E             lcd_print(keypad[rowloc][0]);
	CALL SUBOPT_0x15
	RCALL _lcd_print
; 0000 017F         }
_0x72:
; 0000 0180     }
; 0000 0181     else if(colloc == 0x0D){
	RJMP _0x73
_0x6B:
	LDI  R30,LOW(13)
	CP   R30,R5
	BRNE _0x74
; 0000 0182             CodeID = strcat(CodeID, keypad[rowloc][1]);
	CALL SUBOPT_0x14
	__ADDW1MN _keypad,2
	CALL SUBOPT_0x17
; 0000 0183             lcd_print(keypad[rowloc][1]);
	__ADDW1MN _keypad,2
	RJMP _0x99
; 0000 0184     }
; 0000 0185     else if(colloc == 0x0B){
_0x74:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x76
; 0000 0186             CodeID = strcat(CodeID, keypad[rowloc][2]);
	CALL SUBOPT_0x14
	__ADDW1MN _keypad,4
	CALL SUBOPT_0x17
; 0000 0187             lcd_print(keypad[rowloc][2]);
	__ADDW1MN _keypad,4
	RJMP _0x99
; 0000 0188     }
; 0000 0189     else{
_0x76:
; 0000 018A 
; 0000 018B         if(rowloc == 0 & registration == 2){
	CALL SUBOPT_0x18
	LDI  R30,LOW(2)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x78
; 0000 018C             Insert();
	RCALL _Insert
; 0000 018D         }
; 0000 018E         else if(rowloc == 0 & registration == 1){
	RJMP _0x79
_0x78:
	CALL SUBOPT_0x18
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x7A
; 0000 018F             Delete();
	RCALL _Delete
; 0000 0190         }
; 0000 0191         else if(rowloc == 0){
	RJMP _0x7B
_0x7A:
	TST  R4
	BRNE _0x7C
; 0000 0192             strcpy(result,CheckAccess());
	ST   -Y,R17
	ST   -Y,R16
	RCALL _CheckAccess
	MOVW R26,R30
	CALL _strcpy
; 0000 0193             if(ShowMenu == 1){
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0x7D
; 0000 0194                 if(!(strcmp(result,"1"))){
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x5B,2
	CALL _strcmp
	CPI  R30,0
	BRNE _0x7E
; 0000 0195                     ShowMyMenu();
	RCALL _ShowMyMenu
; 0000 0196                 }
; 0000 0197                 else{
	RJMP _0x7F
_0x7E:
; 0000 0198                     lcd_print("Access Denied!");
	__POINTW2MN _0x5B,4
	CALL SUBOPT_0x8
; 0000 0199                     delay_ms(100);
; 0000 019A                     CleenLCD();}
	RCALL _CleenLCD
_0x7F:
; 0000 019B                 ShowMenu = 0;
	CLR  R8
; 0000 019C             }
; 0000 019D             else if(!strcmp(result,"*")){
	RJMP _0x80
_0x7D:
	ST   -Y,R17
	ST   -Y,R16
	__POINTW2MN _0x5B,19
	CALL _strcmp
	CPI  R30,0
	BRNE _0x81
; 0000 019E                 lcd_print("Access Denied!");
	__POINTW2MN _0x5B,21
	RCALL _lcd_print
; 0000 019F                 LED_Error();
	RCALL _LED_Error
; 0000 01A0                 CleenLCD();
	RJMP _0x9A
; 0000 01A1             }
; 0000 01A2             else{
_0x81:
; 0000 01A3                 lcd_print("Access Granted!");
	__POINTW2MN _0x5B,36
	RCALL _lcd_print
; 0000 01A4                 LED_Ok();
	RCALL _LED_Ok
; 0000 01A5                 CleenLCD();
_0x9A:
	RCALL _CleenLCD
; 0000 01A6             }
_0x80:
; 0000 01A7         }
; 0000 01A8         else if( rowloc == 2 ){
	RJMP _0x83
_0x7C:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x84
; 0000 01A9             lcd_print("Enter ID -> ");
	__POINTW2MN _0x5B,52
	RCALL _lcd_print
; 0000 01AA             ShowMenu = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 01AB         }
; 0000 01AC         else {
	RJMP _0x85
_0x84:
; 0000 01AD                  CodeID = strcat(CodeID, keypad[rowloc][3]);
	CALL SUBOPT_0x14
	__ADDW1MN _keypad,6
	CALL SUBOPT_0x17
; 0000 01AE                  lcd_print(keypad[rowloc][3]);
	__ADDW1MN _keypad,6
_0x99:
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	RCALL _lcd_print
; 0000 01AF         }
_0x85:
_0x83:
_0x7B:
_0x79:
; 0000 01B0     }
_0x73:
; 0000 01B1 }
_0x20A0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x5B:
	.BYTE 0x41
;
;
;
;
;
;
;
;
;
;void main(void)
; 0000 01BC {

	.CSEG
_main:
; .FSTART _main
; 0000 01BD 
; 0000 01BE     DDRD.0 = 1;
	SBI  0x11,0
; 0000 01BF     DDRD.1 = 1;
	SBI  0x11,1
; 0000 01C0     DDRD.2 = 1;
	SBI  0x11,2
; 0000 01C1     LED_R = 0;
	CBI  0x12,0
; 0000 01C2     LED_G = 0;
	CBI  0x12,1
; 0000 01C3     LED_B = 0;
	CBI  0x12,2
; 0000 01C4 
; 0000 01C5     key_ddr = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 01C6     key_prt = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 01C7 
; 0000 01C8     lcd_init();
	RCALL _lcd_init
; 0000 01C9 
; 0000 01CA     lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 01CB 
; 0000 01CC 
; 0000 01CD     while(1){
_0x92:
; 0000 01CE         ReadKeyPad();
	RCALL _ReadKeyPad
; 0000 01CF     }
	RJMP _0x92
; 0000 01D0 }
_0x95:
	RJMP _0x95
; .FEND

	.CSEG
_strcat:
; .FSTART _strcat
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcat0:
    ld   r22,x+
    tst  r22
    brne strcat0
    sbiw r26,1
strcat1:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcat1
    movw r30,r24
    ret
; .FEND
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strncmp:
; .FSTART _strncmp
	ST   -Y,R26
    clr  r22
    clr  r23
    ld   r24,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strncmp0:
    tst  r24
    breq strncmp1
    dec  r24
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strncmp1
    tst  r22
    brne strncmp0
strncmp3:
    clr  r30
    ret
strncmp1:
    sub  r22,r23
    breq strncmp3
    ldi  r30,1
    brcc strncmp2
    subi r30,2
strncmp2:
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x19
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x19
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x1A
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1B
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1D
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1D
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x19
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1B
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x1E
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x1E
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_atoi:
; .FSTART _atoi
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
; .FEND

	.DSEG

	.CSEG

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND

	.CSEG

	.DSEG
_keypad:
	.BYTE 0x18
_AllowList:
	.BYTE 0x1E
_AccessResult1:
	.BYTE 0x2
_list:
	.BYTE 0x2
_menu:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3:
	LDS  R30,_list
	LDS  R31,_list+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_AllowList)
	SBCI R31,HIGH(-_AllowList)
	MOVW R26,R30
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	SUBI R30,LOW(-_AllowList)
	SBCI R31,HIGH(-_AllowList)
	MOVW R26,R30
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL _strcat
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	__ADDW1MN _AllowList,4
	MOVW R26,R30
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL _lcd_print
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9:
	MOV  R30,R9
	LDI  R26,LOW(6)
	MUL  R30,R26
	MOVW R30,R0
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(2)
	CALL _strncmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	CALL _strcpy
	MOV  R30,R9
	LDI  R26,LOW(6)
	MUL  R30,R26
	MOVW R30,R0
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL _strcpy
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	CALL _lcd_print
	CALL _LED_Warning
	CALL _CleenLCD
	CLR  R13
	ST   -Y,R7
	ST   -Y,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xF:
	LDS  R30,_AccessResult1
	LDS  R31,_AccessResult1+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL _strcat
	STS  _AccessResult1,R30
	STS  _AccessResult1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	MOV  R30,R9
	LDI  R26,LOW(6)
	MUL  R30,R26
	MOVW R30,R0
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	OUT  0x15,R30
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	ST   -Y,R7
	ST   -Y,R6
	MOV  R30,R4
	LDI  R31,0
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	SUBI R30,LOW(-_keypad)
	SBCI R31,HIGH(-_keypad)
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x16:
	CALL _strcat
	MOVW R6,R30
	MOV  R30,R4
	LDI  R31,0
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	MOV  R26,R4
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	MOV  R26,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x19:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
	RET

__GTW12U:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLO __GTW12UT
	CLR  R30
__GTW12UT:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
