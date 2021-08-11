
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : AT90USB1286
;Program type             : Application
;Clock frequency          : 2.000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME AT90USB1286
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 8447
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU WDTCSR=0x60
	.EQU UCSR1A=0xC8
	.EQU UDR1=0xCE
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x20FF
	.EQU __DSTACK_SIZE=0x0400
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _cursor=R5
	.DEF _CommandStart_1=R4
	.DEF _CommandStart_2=R7
	.DEF _DeviceID_1=R6
	.DEF _DeviceID_2=R9
	.DEF _Parameter_1=R8
	.DEF _Parameter_2=R11
	.DEF _Parameter_3=R10
	.DEF _Parameter_4=R13
	.DEF _Command_1=R12

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

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
	JMP  _timer1_compa_isr
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

_k1:
	.DB  0x20,0x22,0x2A,0x2B,0x2C,0x5B,0x3D,0x5D
	.DB  0x7C,0x7F,0x0

_0x3:
	.DB  0x3,0x3,0x3,0x2,0x2,0xC,0x0,0x8
	.DB  0x0,0x1,0x0,0x6
_0x5D:
	.DB  0xE,0xE,0xE,0xE,0xE,0xE,0xE,0xE
_0x5E:
	.DB  0x30,0x3A,0x52,0x65,0x67,0x69,0x73,0x74
	.DB  0x72,0x79,0x2E,0x74,0x78,0x74
_0x0:
	.DB  0x25,0x30,0x32,0x58,0x20,0x0,0x43,0x6F
	.DB  0x6C,0x6F,0x63,0x61,0x20,0x74,0x75,0x20
	.DB  0x64,0x65,0x64,0x6F,0x20,0x0,0x73,0x6F
	.DB  0x62,0x72,0x65,0x20,0x65,0x6C,0x20,0x73
	.DB  0x63,0x61,0x6E,0x65,0x72,0x0,0x49,0x6E
	.DB  0x76,0x61,0x6C,0x69,0x64,0x20,0x70,0x6F
	.DB  0x73,0x69,0x74,0x69,0x6F,0x6E,0x0,0x54
	.DB  0x68,0x65,0x20,0x49,0x44,0x20,0x69,0x73
	.DB  0x20,0x6E,0x6F,0x74,0x20,0x75,0x73,0x65
	.DB  0x64,0x0,0x49,0x44,0x20,0x61,0x6C,0x72
	.DB  0x65,0x61,0x64,0x79,0x20,0x75,0x73,0x65
	.DB  0x64,0x0,0x43,0x6F,0x6D,0x6D,0x75,0x6E
	.DB  0x69,0x63,0x61,0x74,0x69,0x6F,0x6E,0x20
	.DB  0x65,0x72,0x72,0x6F,0x72,0x0,0x56,0x65
	.DB  0x72,0x69,0x66,0x69,0x63,0x61,0x74,0x69
	.DB  0x6F,0x6E,0x20,0x66,0x61,0x69,0x6C,0x75
	.DB  0x72,0x65,0x0,0x49,0x64,0x65,0x6E,0x74
	.DB  0x69,0x66,0x69,0x63,0x61,0x74,0x69,0x6F
	.DB  0x6E,0x20,0x66,0x61,0x69,0x6C,0x0,0x44
	.DB  0x61,0x74,0x61,0x62,0x61,0x73,0x65,0x20
	.DB  0x69,0x73,0x20,0x66,0x75,0x6C,0x6C,0x0
	.DB  0x44,0x61,0x74,0x61,0x62,0x61,0x73,0x65
	.DB  0x20,0x69,0x73,0x20,0x65,0x6D,0x70,0x74
	.DB  0x79,0x0,0x54,0x6F,0x6F,0x20,0x62,0x61
	.DB  0x64,0x20,0x66,0x69,0x6E,0x67,0x65,0x72
	.DB  0x70,0x72,0x69,0x6E,0x74,0x0,0x45,0x6E
	.DB  0x72,0x6F,0x6C,0x6C,0x6D,0x65,0x6E,0x74
	.DB  0x20,0x66,0x61,0x69,0x6C,0x75,0x72,0x65
	.DB  0x0,0x43,0x6F,0x6D,0x6D,0x61,0x6E,0x64
	.DB  0x20,0x6E,0x6F,0x74,0x20,0x73,0x75,0x70
	.DB  0x70,0x6F,0x72,0x74,0x65,0x64,0x0,0x44
	.DB  0x65,0x76,0x69,0x63,0x65,0x20,0x65,0x72
	.DB  0x72,0x6F,0x72,0x0,0x49,0x6E,0x76,0x61
	.DB  0x6C,0x69,0x64,0x20,0x70,0x61,0x72,0x61
	.DB  0x6D,0x65,0x74,0x65,0x72,0x0,0x46,0x69
	.DB  0x6E,0x67,0x65,0x72,0x20,0x6E,0x6F,0x74
	.DB  0x20,0x70,0x72,0x65,0x73,0x73,0x65,0x64
	.DB  0x0,0x44,0x69,0x67,0x69,0x74,0x61,0x6C
	.DB  0x20,0x41,0x63,0x63,0x65,0x73,0x73,0x0
	.DB  0x52,0x65,0x67,0x2E,0x0,0x54,0x69,0x6D
	.DB  0x65,0x0,0x55,0x73,0x65,0x72,0x20,0x52
	.DB  0x65,0x67,0x69,0x73,0x74,0x65,0x72,0x0
	.DB  0x41,0x64,0x64,0x0,0x52,0x65,0x6D,0x6F
	.DB  0x76,0x65,0x0,0x42,0x61,0x63,0x6B,0x0
	.DB  0x50,0x75,0x74,0x20,0x79,0x6F,0x75,0x72
	.DB  0x20,0x66,0x69,0x6E,0x67,0x65,0x72,0x0
	.DB  0x69,0x6E,0x20,0x74,0x68,0x65,0x20,0x72
	.DB  0x65,0x61,0x64,0x65,0x72,0x0,0x53,0x65
	.DB  0x6C,0x65,0x63,0x74,0x20,0x75,0x73,0x65
	.DB  0x72,0x20,0x69,0x64,0x0,0x74,0x6F,0x20
	.DB  0x72,0x65,0x6D,0x6F,0x76,0x65,0x20,0x66
	.DB  0x72,0x6F,0x6D,0x20,0x6C,0x69,0x73,0x74
	.DB  0x0,0x2B,0x0,0x53,0x65,0x6C,0x65,0x63
	.DB  0x74,0x0,0x2D,0x0,0x48,0x6F,0x75,0x72
	.DB  0x0,0x4D,0x69,0x6E,0x0,0x4F,0x4B,0x0
	.DB  0x52,0x65,0x67,0x69,0x73,0x74,0x72,0x61
	.DB  0x72,0x0,0x49,0x44,0x20,0x52,0x65,0x67
	.DB  0x69,0x73,0x74,0x72,0x61,0x64,0x6F,0x0
	.DB  0x20,0x20,0x20,0x49,0x44,0x20,0x23,0x25
	.DB  0x69,0x20,0x45,0x4E,0x52,0x4F,0x4C,0x4C
	.DB  0x45,0x44,0x0,0x4D,0x65,0x6D,0x6F,0x72
	.DB  0x79,0x20,0x46,0x75,0x6C,0x6C,0x0,0x20
	.DB  0x20,0x20,0x20,0x41,0x63,0x63,0x65,0x73
	.DB  0x73,0x20,0x44,0x65,0x6E,0x69,0x65,0x64
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x23
	.DB  0x25,0x69,0x0,0x55,0x73,0x65,0x72,0x20
	.DB  0x72,0x65,0x6D,0x6F,0x76,0x65,0x64,0x0
	.DB  0x66,0x72,0x6F,0x6D,0x20,0x6C,0x69,0x73
	.DB  0x74,0x21,0x0,0x25,0x69,0x3A,0x25,0x69
	.DB  0x0,0x53,0x65,0x74,0x20,0x74,0x69,0x6D
	.DB  0x65,0x0,0x73,0x75,0x63,0x63,0x65,0x73
	.DB  0x73,0x21,0x0,0x25,0x69,0x2F,0x25,0x69
	.DB  0x2F,0x25,0x69,0x20,0x7C,0x20,0x25,0x69
	.DB  0x3A,0x25,0x69,0x3A,0x25,0x69,0x20,0x7C
	.DB  0x20,0x49,0x44,0x3A,0x20,0x30,0x25,0x69
	.DB  0x20,0xA,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x57,0x65,0x6C,0x63,0x6F,0x6D
	.DB  0x65,0x0,0x20,0x20,0x20,0x20,0x25,0x69
	.DB  0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x1
_0x2040107:
	.DB  0x46,0x41,0x54
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  _car0
	.DW  _0x5D*2

	.DW  0x0E
	.DW  _NombreArchivo
	.DW  _0x5E*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x01
	.DW  _status_G101
	.DW  _0x2020003*2

	.DW  0x03
	.DW  _fatstr_S1020016000
	.DW  _0x2040107*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	OUT  RAMPZ,R24

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

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
	.ORG 0x500

	.CSEG
;#include "GT_511_C3.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_ConfiguraLCD:
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x3*2)
	LDI  R31,HIGH(_0x3*2)
	CALL __INITLOCB
	ST   -Y,R17
;	TablaInicializacion -> Y+1
;	i -> R17
	IN   R30,0x10
	ORI  R30,LOW(0x3F)
	OUT  0x10,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R17,LOW(0)
_0x5:
	CPI  R17,12
	BRSH _0x6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _MandaLineasDatosLCD
	RCALL _PulsoEn
	SUBI R17,-1
	RJMP _0x5
_0x6:
	LDI  R30,LOW(12)
	MOV  R5,R30
	ST   -Y,R5
	RCALL _EscribeComLCD
	LDD  R17,Y+0
	ADIW R28,13
	RET
_BacklightON:
	SBI  0x11,6
	RET
_PulsoEn:
	SBI  0x11,4
	CBI  0x11,4
	RET
_MandaLineasDatosLCD:
;	dato -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x8)
	BREQ _0xF
	SBI  0x11,3
	RJMP _0x12
_0xF:
	CBI  0x11,3
_0x12:
	LD   R30,Y
	ANDI R30,LOW(0x4)
	BREQ _0x15
	SBI  0x11,2
	RJMP _0x18
_0x15:
	CBI  0x11,2
_0x18:
	LD   R30,Y
	ANDI R30,LOW(0x2)
	BREQ _0x1B
	SBI  0x11,1
	RJMP _0x1E
_0x1B:
	CBI  0x11,1
_0x1E:
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BREQ _0x21
	SBI  0x11,0
	RJMP _0x24
_0x21:
	CBI  0x11,0
_0x24:
	RJMP _0x212001F
_EscribeComLCD:
	ST   -Y,R17
;	Comando -> Y+1
;	tempComando -> R17
	CBI  0x11,5
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	MOV  R30,R17
	LDI  R31,0
	CALL __ASRW4
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	RCALL _PulsoEn
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RCALL _PulsoEn
	RJMP _0x2120020
_LetraDatoLCD:
	ST   -Y,R17
;	dato -> Y+1
;	tempdato -> R17
	SBI  0x11,5
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	MOV  R30,R17
	LDI  R31,0
	CALL __ASRW4
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	RCALL _PulsoEn
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RCALL _PulsoEn
	RJMP _0x2120020
_LetraLCD:
	ST   -Y,R17
;	dato -> Y+1
;	tempdato -> R17
	SBI  0x11,5
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	MOV  R30,R17
	LDI  R31,0
	CALL __ASRW4
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	RCALL _PulsoEn
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	ST   -Y,R17
	RCALL _MandaLineasDatosLCD
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RCALL _PulsoEn
	RJMP _0x2120020
_StringLCD:
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x2E:
	MOV  R30,R17
	SUBI R17,-1
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	ST   -Y,R30
	RCALL _LetraLCD
	MOV  R30,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	CPI  R30,0
	BRNE _0x2E
	RJMP _0x2120028
;	tiempo -> Y+1
;	i -> R17
_StringLCDVar:
	ST   -Y,R17
;	Mensaje -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x34:
	MOV  R30,R17
	SUBI R17,-1
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _LetraLCD
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BRNE _0x34
_0x2120028:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_BorrarLCD:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _EscribeComLCD
	RET
_MoverCursor:
;	x -> Y+1
;	y -> Y+0
	LD   R30,Y
	LDI  R31,0
	SBIW R30,0
	BRNE _0x39
	LDD  R30,Y+1
	SUBI R30,-LOW(128)
	RJMP _0xC5
_0x39:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3A
	LDD  R30,Y+1
	SUBI R30,-LOW(192)
	RJMP _0xC5
_0x3A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3B
	LDD  R30,Y+1
	SUBI R30,-LOW(148)
	RJMP _0xC5
_0x3B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x38
	LDD  R30,Y+1
	SUBI R30,-LOW(212)
_0xC5:
	ST   -Y,R30
	RCALL _EscribeComLCD
_0x38:
	RJMP _0x2120022
_CreaCaracter:
	ST   -Y,R17
;	NoCaracter -> Y+3
;	datos -> Y+1
;	i -> R17
	LDD  R30,Y+3
	LSL  R30
	LSL  R30
	LSL  R30
	SUBI R30,-LOW(64)
	ST   -Y,R30
	RCALL _EscribeComLCD
	LDI  R17,LOW(0)
_0x3E:
	CPI  R17,8
	BRSH _0x3F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	ST   -Y,R30
	RCALL _LetraDatoLCD
	SUBI R17,-1
	RJMP _0x3E
_0x3F:
	LDI  R30,LOW(128)
	ST   -Y,R30
	RCALL _EscribeComLCD
	LDD  R17,Y+0
	ADIW R28,4
	RET
;	by -> Y+10
;	byte -> Y+0
_Reset:
	CLR  R8
	CLR  R11
	CLR  R10
	CLR  R13
	CLR  R12
	LDI  R30,LOW(0)
	STS  _Command_2,R30
	STS  _Response_1,R30
	STS  _Response_2,R30
	RET
_DefaultInfo:
	LDI  R30,LOW(85)
	MOV  R4,R30
	ST   -Y,R4
	CALL _putchar
	LDI  R30,LOW(170)
	MOV  R7,R30
	ST   -Y,R7
	CALL _putchar
	LDI  R30,LOW(1)
	MOV  R6,R30
	ST   -Y,R6
	CALL _putchar
	CLR  R9
	ST   -Y,R9
	CALL _putchar
	RCALL _Reset
	RET
_CalculateSum:
	ST   -Y,R17
	ST   -Y,R16
;	sum -> R16,R17
	MOV  R26,R4
	CLR  R27
	CLR  R30
	ADD  R26,R7
	ADC  R27,R30
	CLR  R30
	ADD  R26,R6
	ADC  R27,R30
	CLR  R30
	ADD  R26,R9
	ADC  R27,R30
	CLR  R30
	ADD  R26,R8
	ADC  R27,R30
	CLR  R30
	ADD  R26,R11
	ADC  R27,R30
	CLR  R30
	ADD  R26,R10
	ADC  R27,R30
	CLR  R30
	ADD  R26,R13
	ADC  R27,R30
	CLR  R30
	ADD  R26,R12
	ADC  R27,R30
	LDS  R30,_Command_2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	STS  _sumLO,R16
	STS  _sumHI,R17
	RJMP _0x2120026
_CommandToScanner:
;	Param -> Y+1
;	Com -> Y+0
	RCALL _DefaultInfo
	LDD  R8,Y+1
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
	LDD  R12,Y+0
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
	RCALL _CalculateSum
	LDS  R30,_sumLO
	ST   -Y,R30
	CALL _putchar
	LDS  R30,_sumHI
	ST   -Y,R30
	CALL _putchar
	CALL _getchar
	MOV  R4,R30
	CALL _getchar
	MOV  R7,R30
	CALL _getchar
	MOV  R6,R30
	CALL _getchar
	MOV  R9,R30
	CALL _getchar
	MOV  R8,R30
	CALL _getchar
	MOV  R11,R30
	CALL _getchar
	MOV  R10,R30
	CALL _getchar
	MOV  R13,R30
	CALL _getchar
	STS  _Response_1,R30
	CALL _getchar
	STS  _Response_2,R30
	CALL _getchar
	STS  _CheckSum_1,R30
	CALL _getchar
	STS  _CheckSum_2,R30
	RJMP _0x2120022
_Initialization:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	RJMP _0x2120027
_LedControl:
;	Parameter -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDI  R30,LOW(18)
	ST   -Y,R30
	RCALL _CommandToScanner
	RJMP _0x212001F
_GetEnrollCount:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(32)
	RJMP _0x2120027
;	Param_ID -> Y+0
_EnrollStart:
;	Param_ID -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDI  R30,LOW(34)
	ST   -Y,R30
	RCALL _CommandToScanner
	LDS  R30,_Response_1
	RJMP _0x212001F
_CaptureFinger:
;	Parameter -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDI  R30,LOW(96)
	ST   -Y,R30
	RCALL _CommandToScanner
	MOV  R31,R11
	LDI  R30,LOW(0)
	MOVW R26,R30
	MOV  R30,R8
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x212001F
_Enroll1:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LedControl
	RCALL _BorrarLCD
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _MoverCursor
	__POINTW1FN _0x0,22
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
_0x40:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _CaptureFinger
	CPI  R30,LOW(0x1012)
	LDI  R26,HIGH(0x1012)
	CPC  R31,R26
	BREQ _0x40
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LedControl
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(35)
	RJMP _0x2120027
_Enroll2:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LedControl
	RCALL _BorrarLCD
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _MoverCursor
	__POINTW1FN _0x0,22
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
_0x43:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _CaptureFinger
	CPI  R30,LOW(0x1012)
	LDI  R26,HIGH(0x1012)
	CPC  R31,R26
	BREQ _0x43
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LedControl
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(36)
	RJMP _0x2120027
_Enroll3:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LedControl
	RCALL _BorrarLCD
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _MoverCursor
	__POINTW1FN _0x0,22
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
_0x46:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _CaptureFinger
	CPI  R30,LOW(0x1012)
	LDI  R26,HIGH(0x1012)
	CPC  R31,R26
	BREQ _0x46
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LedControl
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(37)
_0x2120027:
	ST   -Y,R30
	RCALL _CommandToScanner
	RET
_DeleteID:
;	Param_ID -> Y+0
	LD   R30,Y
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	RCALL _CommandToScanner
	RJMP _0x212001F
;	Param_ID -> Y+0
_Identify:
	ST   -Y,R17
	ST   -Y,R16
;	press -> R16,R17
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LedControl
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _CaptureFinger
	MOVW R16,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LedControl
	LDI  R30,LOW(4114)
	LDI  R31,HIGH(4114)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x49
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(81)
	ST   -Y,R30
	RCALL _CommandToScanner
	LDS  R30,_Response_1
	LDI  R31,0
	RJMP _0x2120026
_0x49:
	LDI  R30,LOW(4114)
	LDI  R31,HIGH(4114)
_0x2120026:
	LD   R16,Y+
	LD   R17,Y+
	RET
_NackError:
;	Error -> Y+0
	RCALL _BorrarLCD
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
	LD   R30,Y
	LDD  R31,Y+1
	CPI  R30,LOW(0x1003)
	LDI  R26,HIGH(0x1003)
	CPC  R31,R26
	BRNE _0x4E
	__POINTW1FN _0x0,38
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x4E:
	CPI  R30,LOW(0x1004)
	LDI  R26,HIGH(0x1004)
	CPC  R31,R26
	BRNE _0x4F
	__POINTW1FN _0x0,55
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x4F:
	CPI  R30,LOW(0x1005)
	LDI  R26,HIGH(0x1005)
	CPC  R31,R26
	BRNE _0x50
	__POINTW1FN _0x0,74
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x50:
	CPI  R30,LOW(0x1006)
	LDI  R26,HIGH(0x1006)
	CPC  R31,R26
	BRNE _0x51
	__POINTW1FN _0x0,90
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x51:
	CPI  R30,LOW(0x1007)
	LDI  R26,HIGH(0x1007)
	CPC  R31,R26
	BRNE _0x52
	__POINTW1FN _0x0,110
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x52:
	CPI  R30,LOW(0x1008)
	LDI  R26,HIGH(0x1008)
	CPC  R31,R26
	BRNE _0x53
	__POINTW1FN _0x0,131
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x53:
	CPI  R30,LOW(0x1009)
	LDI  R26,HIGH(0x1009)
	CPC  R31,R26
	BRNE _0x54
	__POINTW1FN _0x0,151
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x54:
	CPI  R30,LOW(0x100A)
	LDI  R26,HIGH(0x100A)
	CPC  R31,R26
	BRNE _0x55
	__POINTW1FN _0x0,168
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x55:
	CPI  R30,LOW(0x100C)
	LDI  R26,HIGH(0x100C)
	CPC  R31,R26
	BRNE _0x56
	__POINTW1FN _0x0,186
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x56:
	CPI  R30,LOW(0x100D)
	LDI  R26,HIGH(0x100D)
	CPC  R31,R26
	BRNE _0x57
	__POINTW1FN _0x0,206
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x57:
	CPI  R30,LOW(0x100E)
	LDI  R26,HIGH(0x100E)
	CPC  R31,R26
	BRNE _0x58
	__POINTW1FN _0x0,225
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x58:
	CPI  R30,LOW(0x100F)
	LDI  R26,HIGH(0x100F)
	CPC  R31,R26
	BRNE _0x59
	__POINTW1FN _0x0,247
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x59:
	CPI  R30,LOW(0x1011)
	LDI  R26,HIGH(0x1011)
	CPC  R31,R26
	BRNE _0x5A
	__POINTW1FN _0x0,260
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
	RJMP _0x4D
_0x5A:
	CPI  R30,LOW(0x1012)
	LDI  R26,HIGH(0x1012)
	CPC  R31,R26
	BRNE _0x5C
	__POINTW1FN _0x0,278
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
_0x5C:
_0x4D:
	RJMP _0x2120022
_ResponseFromScanner:
	MOV  R31,R11
	LDI  R30,LOW(0)
	MOVW R26,R30
	MOV  R30,R8
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STS  _ErrorCode,R30
	STS  _ErrorCode+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RCALL _NackError
	LDS  R30,_Response_1
	RET
;#include <ff.h>
;
;/*  the DS1302 is connected to ATmega8515 PORTC
;    the IO signal is bit 3
;    the SCLK signal is bit 4
;    the RST signal is bit 5 */
;#asm
    .equ __ds1302_port=0x08
    .equ __ds1302_io=0
    .equ __ds1302_sclk=1
    .equ __ds1302_rst=2
; 0000 000D #endasm
;#include "ds1302.h"
;
;//BUTTONS
;#define Bot1 PINC.7
;#define Bot2 PINC.6
;#define Bot3 PINC.5
;
;//MENUS - VARIABLES
;char car0[]={0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E};

	.DSEG
;unsigned int id_menu;
;unsigned char menu_lock;
;
;//VARIABLES
;eeprom char registry[20];
;unsigned char h, m, s, d, mo, y, ID_aux, ID_aux_del;
;char print_aux[30];
;
;
;char NombreArchivo[] = "0:Registry.txt";
;
;
;//INTERRUPT TO CHECK CONNECTION
;interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
; 0000 0024 interrupt [18] void timer1_compa_isr(void) {

	.CSEG
_timer1_compa_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0025   disk_timerproc();
	CALL _disk_timerproc
; 0000 0026 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;//MENUS
;void menu0() {
; 0000 0029 void menu0() {
_menu0:
; 0000 002A     BorrarLCD();
	RCALL _BorrarLCD
; 0000 002B     MoverCursor(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 002C     StringLCD("Digital Access");
	__POINTW1FN _0x0,297
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 002D     MoverCursor(1,3);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 002E     StringLCD("Reg.");
	__POINTW1FN _0x0,312
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 002F     MoverCursor(6,3);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0030     LetraLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0031     MoverCursor(8,3);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0032     StringLCD("Time");
	__POINTW1FN _0x0,317
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0033     MoverCursor(13,3);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0034     LetraLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0035     MoverCursor(14,3);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0036     StringLCD("Access");
	__POINTW1FN _0x0,305
	RJMP _0x2120023
; 0000 0037 }
;
;void menu0_1() {
; 0000 0039 void menu0_1() {
_menu0_1:
; 0000 003A     BorrarLCD();
	RCALL _BorrarLCD
; 0000 003B     MoverCursor(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 003C     StringLCD("User Register");
	__POINTW1FN _0x0,322
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 003D     MoverCursor(1,3);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 003E     StringLCD("Add");
	__POINTW1FN _0x0,336
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 003F     MoverCursor(5,3);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0040     LetraLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0041     MoverCursor(7,3);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0042     StringLCD("Remove");
	__POINTW1FN _0x0,340
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0043     MoverCursor(14,3);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0044     LetraLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0045     MoverCursor(16,3);
	LDI  R30,LOW(16)
	RJMP _0x2120025
; 0000 0046     StringLCD("Back");
; 0000 0047 }
;
;void menu0_1_1() {
; 0000 0049 void menu0_1_1() {
_menu0_1_1:
; 0000 004A     BorrarLCD();
	RCALL _BorrarLCD
; 0000 004B     MoverCursor(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 004C     StringLCD("Put your finger");
	__POINTW1FN _0x0,352
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 004D     MoverCursor(4,1);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 004E     StringLCD("in the reader");
	__POINTW1FN _0x0,368
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 004F     MoverCursor(6,3);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0050     LetraDatoLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraDatoLCD
; 0000 0051     MoverCursor(13,3);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0052     LetraDatoLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraDatoLCD
; 0000 0053     MoverCursor(15,3);
	RJMP _0x2120024
; 0000 0054     StringLCD("Back");
; 0000 0055 }
;
;void menu0_1_2() {
; 0000 0057 void menu0_1_2() {
_menu0_1_2:
; 0000 0058     BorrarLCD();
	RCALL _BorrarLCD
; 0000 0059     MoverCursor(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 005A     StringLCD("Select user id");
	__POINTW1FN _0x0,382
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 005B     MoverCursor(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 005C     StringLCD("to remove from list");
	__POINTW1FN _0x0,397
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 005D     MoverCursor(2,3);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 005E     StringLCD("+");
	__POINTW1FN _0x0,417
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 005F     MoverCursor(5,3);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0060     LetraLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0061     MoverCursor(7,3);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0062     StringLCD("Select");
	__POINTW1FN _0x0,419
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0063     MoverCursor(14,3);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0064     LetraLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0065     MoverCursor(17,3);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0066     StringLCD("-");
	__POINTW1FN _0x0,426
	RJMP _0x2120023
; 0000 0067 }
;
;void menu0_2() {
; 0000 0069 void menu0_2() {
_menu0_2:
; 0000 006A     BorrarLCD();
	RCALL _BorrarLCD
; 0000 006B     MoverCursor(2,3);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 006C     StringLCD("Hour");
	__POINTW1FN _0x0,428
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 006D     MoverCursor(6,3);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 006E     LetraDatoLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraDatoLCD
; 0000 006F     MoverCursor(9,3);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0070     StringLCD("Min");
	__POINTW1FN _0x0,433
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0071     MoverCursor(13,3);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0072     LetraDatoLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraDatoLCD
; 0000 0073     MoverCursor(16,3);
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0074     StringLCD("OK");
	__POINTW1FN _0x0,437
	RJMP _0x2120023
; 0000 0075 }
;
;void menu0_3() {
; 0000 0077 void menu0_3() {
_menu0_3:
; 0000 0078     BorrarLCD();
	RCALL _BorrarLCD
; 0000 0079     MoverCursor(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 007A     StringLCD("Put your finger");
	__POINTW1FN _0x0,352
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 007B     MoverCursor(4,1);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 007C     StringLCD("in the reader");
	__POINTW1FN _0x0,368
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 007D     MoverCursor(6,3);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 007E     LetraLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 007F     MoverCursor(13,3);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0080     LetraLCD(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LetraLCD
; 0000 0081     MoverCursor(15,3);
_0x2120024:
	LDI  R30,LOW(15)
_0x2120025:
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0082     StringLCD("Back");
	__POINTW1FN _0x0,347
_0x2120023:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0083 }
	RET
;
;//FUNCTIONS AND PROCEDURES
;char Next(unsigned char j) {
; 0000 0086 char Next(unsigned char j) {
_Next:
; 0000 0087     char i;
; 0000 0088     for (i=j-1; i<19; i++)
	ST   -Y,R17
;	j -> Y+1
;	i -> R17
	LDD  R30,Y+1
	LDI  R31,0
	SBIW R30,1
	MOV  R17,R30
_0x60:
	CPI  R17,19
	BRSH _0x61
; 0000 0089         if (registry[i]!=0)
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_registry)
	SBCI R27,HIGH(-_registry)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0x62
; 0000 008A             return i+1;
	MOV  R30,R17
	SUBI R30,-LOW(1)
	RJMP _0x2120020
; 0000 008B     return 0;
_0x62:
	SUBI R17,-1
	RJMP _0x60
_0x61:
	RJMP _0x2120021
; 0000 008C }
;
;char Prev(unsigned char j) {
; 0000 008E char Prev(unsigned char j) {
_Prev:
; 0000 008F     char i;
; 0000 0090     for (i=j-1; i>0; i--)
	ST   -Y,R17
;	j -> Y+1
;	i -> R17
	LDD  R30,Y+1
	LDI  R31,0
	SBIW R30,1
	MOV  R17,R30
_0x64:
	CPI  R17,1
	BRLO _0x65
; 0000 0091         if (registry[i]!=0)
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_registry)
	SBCI R27,HIGH(-_registry)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0x66
; 0000 0092             return i+1;
	MOV  R30,R17
	SUBI R30,-LOW(1)
	RJMP _0x2120020
; 0000 0093     return 0;
_0x66:
	SUBI R17,1
	RJMP _0x64
_0x65:
_0x2120021:
	LDI  R30,LOW(0)
_0x2120020:
	LDD  R17,Y+0
_0x2120022:
	ADIW R28,2
	RET
; 0000 0094 }
;
;void Delete(unsigned char ID1){
; 0000 0096 void Delete(unsigned char ID1){
_Delete:
; 0000 0097     DeleteID(ID1);
;	ID1 -> Y+0
	LD   R30,Y
	ST   -Y,R30
	RCALL _DeleteID
; 0000 0098     if(ResponseFromScanner() == 0x30)
	RCALL _ResponseFromScanner
	CPI  R30,LOW(0x30)
	BRNE _0x67
; 0000 0099        registry[ID1-1] = 0;
	LD   R30,Y
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_registry)
	SBCI R31,HIGH(-_registry)
	MOVW R26,R30
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 009A }
_0x67:
_0x212001F:
	ADIW R28,1
	RET
;
;void EnrollProcess(unsigned char ID1) {
; 0000 009C void EnrollProcess(unsigned char ID1) {
_EnrollProcess:
; 0000 009D     BorrarLCD();
;	ID1 -> Y+0
	RCALL _BorrarLCD
; 0000 009E     MoverCursor(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 009F     StringLCD("Registrar");
	__POINTW1FN _0x0,440
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 00A0     delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00A1 
; 0000 00A2 
; 0000 00A3     //Enroll
; 0000 00A4     EnrollStart(ID1);
	LD   R30,Y
	ST   -Y,R30
	RCALL _EnrollStart
; 0000 00A5     if(ResponseFromScanner() == 0x30) {
	RCALL _ResponseFromScanner
	CPI  R30,LOW(0x30)
	BRNE _0x68
; 0000 00A6         Enroll1();
	RCALL _Enroll1
; 0000 00A7         if(ResponseFromScanner() == 0x30) {
	RCALL _ResponseFromScanner
	CPI  R30,LOW(0x30)
	BRNE _0x69
; 0000 00A8             Enroll2();
	RCALL _Enroll2
; 0000 00A9             if(ResponseFromScanner() == 0x30) {
	RCALL _ResponseFromScanner
	CPI  R30,LOW(0x30)
	BRNE _0x6A
; 0000 00AA                 Enroll3();
	RCALL _Enroll3
; 0000 00AB                 if(ResponseFromScanner() == 0x30) {
	RCALL _ResponseFromScanner
	CPI  R30,LOW(0x30)
	BRNE _0x6B
; 0000 00AC                     StringLCD("ID Registrado");
	__POINTW1FN _0x0,450
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 00AD                     registry[ID1-1] = 1;
	LD   R30,Y
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_registry)
	SBCI R31,HIGH(-_registry)
	MOVW R26,R30
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 00AE                 }
; 0000 00AF             }
_0x6B:
; 0000 00B0         }
_0x6A:
; 0000 00B1     }
_0x69:
; 0000 00B2     Reset();
_0x68:
	RCALL _Reset
; 0000 00B3     delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00B4 }
	JMP  _0x212001A
;
;
;
;void main(){
; 0000 00B8 void main(){
_main:
; 0000 00B9     char aux[40];
; 0000 00BA     unsigned int br;
; 0000 00BB 
; 0000 00BC 
; 0000 00BD     /* FAT function result */
; 0000 00BE     FRESULT res;
; 0000 00BF 
; 0000 00C0     /* will hold the information for logical drive 0: */
; 0000 00C1     FATFS drive;
; 0000 00C2     FIL archivo; // file objects
; 0000 00C3 
; 0000 00C4     ConfiguraLCD();
	SBIW R28,63
	SBIW R28,59
	SUBI R29,4
;	aux -> Y+1106
;	br -> R16,R17
;	res -> R19
;	drive -> Y+544
;	archivo -> Y+0
	RCALL _ConfiguraLCD
; 0000 00C5     rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _rtc_init
; 0000 00C6 
; 0000 00C7     // USART1 initialization
; 0000 00C8     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00C9     // USART1 Receiver: On
; 0000 00CA     // USART1 Transmitter: On
; 0000 00CB     // USART1 Mode: Asynchronous
; 0000 00CC     // USART1 Baud Rate: 9600 (Double Speed Mode)
; 0000 00CD     UCSR1A=0x02;
	LDI  R30,LOW(2)
	STS  200,R30
; 0000 00CE     UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  201,R30
; 0000 00CF     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  202,R30
; 0000 00D0     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  205,R30
; 0000 00D1     UBRR1L=0x19;
	LDI  R30,LOW(25)
	STS  204,R30
; 0000 00D2 
; 0000 00D3     //PULL-UPS (BUTTONS)
; 0000 00D4     PORTC = 0xE0;
	LDI  R30,LOW(224)
	OUT  0x8,R30
; 0000 00D5 
; 0000 00D6     /*Configurar el PORTB I/O*/
; 0000 00D7     DDRB=0b11101101;
	LDI  R30,LOW(237)
	OUT  0x4,R30
; 0000 00D8 
; 0000 00D9     // C?digo para hacer una interrupci?n peri?dica cada 10ms
; 0000 00DA     // Timer/Counter 1 initialization
; 0000 00DB     // Clock source: System Clock
; 0000 00DC     // Clock value: 1000.000 kHz
; 0000 00DD     // Mode: CTC top=OCR1A
; 0000 00DE     // Compare A Match Interrupt: On
; 0000 00DF     TCCR1B=0x09;
	LDI  R30,LOW(9)
	STS  129,R30
; 0000 00E0     OCR1AH=0x27;
	LDI  R30,LOW(39)
	STS  137,R30
; 0000 00E1     OCR1AL=0x10;
	LDI  R30,LOW(16)
	STS  136,R30
; 0000 00E2     TIMSK1=0x02;
	LDI  R30,LOW(2)
	STS  111,R30
; 0000 00E3     #asm("sei")
	sei
; 0000 00E4 
; 0000 00E5     ConfiguraLCD();
	RCALL _ConfiguraLCD
; 0000 00E6     CreaCaracter(0,car0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_car0)
	LDI  R31,HIGH(_car0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _CreaCaracter
; 0000 00E7 
; 0000 00E8     /* Inicia el puerto SPI para la SD */
; 0000 00E9     disk_initialize(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _disk_initialize
; 0000 00EA     delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00EB 
; 0000 00EC     BacklightON();
	RCALL _BacklightON
; 0000 00ED 
; 0000 00EE 
; 0000 00EF     Initialization();
	RCALL _Initialization
; 0000 00F0     LedControl(0x00);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LedControl
; 0000 00F1     GetEnrollCount();
	RCALL _GetEnrollCount
; 0000 00F2 
; 0000 00F3     ID_aux = 0;
	LDI  R30,LOW(0)
	STS  _ID_aux,R30
; 0000 00F4     ID_aux_del = 1;
	LDI  R30,LOW(1)
	STS  _ID_aux_del,R30
; 0000 00F5     id_menu = 0;
	LDI  R30,LOW(0)
	STS  _id_menu,R30
	STS  _id_menu+1,R30
; 0000 00F6     menu_lock =0;
	STS  _menu_lock,R30
; 0000 00F7 
; 0000 00F8 
; 0000 00F9     while(1) {
_0x6C:
; 0000 00FA 
; 0000 00FB         switch (id_menu){
	LDS  R30,_id_menu
	LDS  R31,_id_menu+1
; 0000 00FC         case 0:
	SBIW R30,0
	BRNE _0x72
; 0000 00FD             menu0();
	RCALL _menu0
; 0000 00FE             while(Bot1 == 1 && Bot2 == 1 && Bot3 == 1);
_0x73:
	SBIS 0x6,7
	RJMP _0x76
	SBIS 0x6,6
	RJMP _0x76
	SBIC 0x6,5
	RJMP _0x77
_0x76:
	RJMP _0x75
_0x77:
	RJMP _0x73
_0x75:
; 0000 00FF             if(Bot1 == 0)
	SBIC 0x6,7
	RJMP _0x78
; 0000 0100                 id_menu = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xC6
; 0000 0101             else if(Bot2 == 0)
_0x78:
	SBIC 0x6,6
	RJMP _0x7A
; 0000 0102                 id_menu = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0xC6
; 0000 0103             else if(Bot3 == 0)
_0x7A:
	SBIC 0x6,5
	RJMP _0x7C
; 0000 0104                 id_menu = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
_0xC6:
	STS  _id_menu,R30
	STS  _id_menu+1,R31
; 0000 0105             break;
_0x7C:
	RJMP _0x71
; 0000 0106         case 1:
_0x72:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7D
; 0000 0107             menu0_1();
	RCALL _menu0_1
; 0000 0108             while(Bot1 == 1 && Bot2 == 1 && Bot3 == 1);
_0x7E:
	SBIS 0x6,7
	RJMP _0x81
	SBIS 0x6,6
	RJMP _0x81
	SBIC 0x6,5
	RJMP _0x82
_0x81:
	RJMP _0x80
_0x82:
	RJMP _0x7E
_0x80:
; 0000 0109             if(Bot1 == 0)
	SBIC 0x6,7
	RJMP _0x83
; 0000 010A                 id_menu = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STS  _id_menu,R30
	STS  _id_menu+1,R31
; 0000 010B             else if(Bot2 == 0)
	RJMP _0x84
_0x83:
	SBIC 0x6,6
	RJMP _0x85
; 0000 010C                 id_menu = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	STS  _id_menu,R30
	STS  _id_menu+1,R31
; 0000 010D             else if(Bot3 == 0)
	RJMP _0x86
_0x85:
	SBIC 0x6,5
	RJMP _0x87
; 0000 010E                 id_menu = 0;
	LDI  R30,LOW(0)
	STS  _id_menu,R30
	STS  _id_menu+1,R30
; 0000 010F             break;
_0x87:
_0x86:
_0x84:
	RJMP _0x71
; 0000 0110         case 11:
_0x7D:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x88
; 0000 0111             BorrarLCD();
	RCALL _BorrarLCD
; 0000 0112             MoverCursor(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0113             StringLCD("Put your finger");
	__POINTW1FN _0x0,352
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0114             MoverCursor(4,1);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0115             StringLCD("in the reader");
	__POINTW1FN _0x0,368
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0116             while(Identify() == NACK_FINGER_IS_NOT_PRESSED);
_0x89:
	RCALL _Identify
	CPI  R30,LOW(0x1012)
	LDI  R26,HIGH(0x1012)
	CPC  R31,R26
	BREQ _0x89
; 0000 0117                if(Response_1 == 0x30) {
	LDS  R26,_Response_1
	CPI  R26,LOW(0x30)
	BRNE _0x8C
; 0000 0118                    menu0_1_1();
	RCALL _menu0_1_1
; 0000 0119                 ID_aux = Next(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _Next
	STS  _ID_aux,R30
; 0000 011A                 if (ID_aux != 0) {
	CPI  R30,0
	BREQ _0x8D
; 0000 011B                     EnrollProcess(ID_aux);
	ST   -Y,R30
	RCALL _EnrollProcess
; 0000 011C                     BorrarLCD();
	RCALL _BorrarLCD
; 0000 011D                     MoverCursor(4,0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 011E                     sprintf(print_aux,"   ID #%i ENROLLED",ID_aux);
	LDI  R30,LOW(_print_aux)
	LDI  R31,HIGH(_print_aux)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,464
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_ID_aux
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 011F                     StringLCDVar(print_aux);
	LDI  R30,LOW(_print_aux)
	LDI  R31,HIGH(_print_aux)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCDVar
; 0000 0120                 } else {
	RJMP _0x8E
_0x8D:
; 0000 0121                     BorrarLCD();
	RCALL _BorrarLCD
; 0000 0122                     MoverCursor(4,0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0123                     StringLCD("Memory Full");
	__POINTW1FN _0x0,483
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 0124                 }
_0x8E:
; 0000 0125                } else {
	RJMP _0x8F
_0x8C:
; 0000 0126                    id_menu = 0;
	LDI  R30,LOW(0)
	STS  _id_menu,R30
	STS  _id_menu+1,R30
; 0000 0127                    BorrarLCD();
	RCALL _BorrarLCD
; 0000 0128                    MoverCursor(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0129                    StringLCD("    Access Denied");
	__POINTW1FN _0x0,495
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 012A                    delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 012B                }
_0x8F:
; 0000 012C 
; 0000 012D             while(Bot3 == 1);
_0x90:
	SBIC 0x6,5
	RJMP _0x90
; 0000 012E             if(Bot3 == 0)
	SBIC 0x6,5
	RJMP _0x93
; 0000 012F                 id_menu = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _id_menu,R30
	STS  _id_menu+1,R31
; 0000 0130             break;
_0x93:
	RJMP _0x71
; 0000 0131         case 12:
_0x88:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x94
; 0000 0132             if(menu_lock == 0) {
	LDS  R30,_menu_lock
	CPI  R30,0
	BRNE _0x95
; 0000 0133                 while(Identify() == NACK_FINGER_IS_NOT_PRESSED);
_0x96:
	RCALL _Identify
	CPI  R30,LOW(0x1012)
	LDI  R26,HIGH(0x1012)
	CPC  R31,R26
	BREQ _0x96
; 0000 0134                 if(Response_1 == 0x30) {
	LDS  R26,_Response_1
	CPI  R26,LOW(0x30)
	BRNE _0x99
; 0000 0135                     menu_lock = 1;
	LDI  R30,LOW(1)
	STS  _menu_lock,R30
; 0000 0136                     ID_aux_del = 1;
	STS  _ID_aux_del,R30
; 0000 0137                    } else {
	RJMP _0x9A
_0x99:
; 0000 0138                     id_menu = 0;
	LDI  R30,LOW(0)
	STS  _id_menu,R30
	STS  _id_menu+1,R30
; 0000 0139                        BorrarLCD();
	RCALL _BorrarLCD
; 0000 013A                        MoverCursor(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 013B                        StringLCD("    Access Denied");
	__POINTW1FN _0x0,495
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCD
; 0000 013C                        delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 013D                     menu_lock = 1;
	LDI  R30,LOW(1)
	STS  _menu_lock,R30
; 0000 013E                     break;
	RJMP _0x71
; 0000 013F                    }
_0x9A:
; 0000 0140             }
; 0000 0141             menu0_1_2();
_0x95:
	RCALL _menu0_1_2
; 0000 0142             MoverCursor(0,2);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _MoverCursor
; 0000 0143             sprintf(print_aux,"      #%i", ID_aux_del);
	LDI  R30,LOW(_print_aux)
	LDI  R31,HIGH(_print_aux)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,513
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_ID_aux_del
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0144             StringLCDVar(print_aux);
	LDI  R30,LOW(_print_aux)
	LDI  R31,HIGH(_print_aux)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _StringLCDVar
; 0000 0145             while(Bot2 == 1 && Bot1 == 1 && Bot3 == 1);
_0x9B:
	SBIS 0x6,6
	RJMP _0x9E
	SBIS 0x6,7
	RJMP _0x9E
	SBIC 0x6,5
	RJMP _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
	RJMP _0x9B
_0x9D:
; 0000 0146             if(Bot1 == 0 && Bot3 == 0) {
	LDI  R26,0
	SBIC 0x6,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xA1
	LDI  R26,0
	SBIC 0x6,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xA2
_0xA1:
	RJMP _0xA0
_0xA2:
; 0000 0147                 id_menu = 0;
	LDI  R30,LOW(0)
	STS  _id_menu,R30
	STS  _id_menu+1,R30
; 0000 0148                 ID_aux_del = 1;
	LDI  R30,LOW(1)
	STS  _ID_aux_del,R30
; 0000 0149                 menu_lock = 1;
	STS  _menu_lock,R30
; 0000 014A             } else if(Bot1 == 0 && ID_aux_del>1) {
	RJMP _0xA3
_0xA0:
	LDI  R26,0
	SBIC 0x6,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xA5
	LDS  R26,_ID_aux_del
	CPI  R26,LOW(0x2)
	BRSH _0xA6
_0xA5:
	RJMP _0xA4
_0xA6:
; 0000 014B                 ID_aux_del = Prev(ID_aux_del);
	LDS  R30,_ID_aux_del
	ST   -Y,R30
	RCALL _Prev
	STS  _ID_aux_del,R30
; 0000 014C             } else if(Bot3 == 0 && ID_aux_del<20) {
	RJMP _0xA7
_0xA4:
	LDI  R26,0
	SBIC 0x6,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xA9
	LDS  R26,_ID_aux_del
	CPI  R26,LOW(0x14)
	BRLO _0xAA
_0xA9:
	RJMP _0xA8
_0xAA:
; 0000 014D                 ID_aux_del = Next(ID_aux_del);
	LDS  R30,_ID_aux_del
	ST   -Y,R30
	RCALL _Next
	STS  _ID_aux_del,R30
; 0000 014E             } else if(Bot2 == 0) {
	RJMP _0xAB
_0xA8:
	SBIC 0x6,6
	RJMP _0xAC
; 0000 014F                 id_menu = 0;
	LDI  R30,LOW(0)
	STS  _id_menu,R30
	STS  _id_menu+1,R30
; 0000 0150                 menu_lock = 1;
	LDI  R30,LOW(1)
	STS  _menu_lock,R30
; 0000 0151                 Delete(ID_aux_del);
	LDS  R30,_ID_aux_del
	ST   -Y,R30
	RCALL _Delete
; 0000 0152                 BorrarLCD();
	CALL _BorrarLCD
; 0000 0153                 MoverCursor(4,1);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _MoverCursor
; 0000 0154                 StringLCD("User removed");
	__POINTW1FN _0x0,523
	ST   -Y,R31
	ST   -Y,R30
	CALL _StringLCD
; 0000 0155                 MoverCursor(5,2);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _MoverCursor
; 0000 0156                 StringLCD("from list!");
	__POINTW1FN _0x0,536
	ST   -Y,R31
	ST   -Y,R30
	CALL _StringLCD
; 0000 0157                 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0158             }
; 0000 0159 
; 0000 015A             break;
_0xAC:
_0xAB:
_0xA7:
_0xA3:
	RJMP _0x71
; 0000 015B         case 2:
_0x94:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xAD
; 0000 015C             menu0_2();
	RCALL _menu0_2
; 0000 015D             rtc_get_time(&h,&m,&s);
	LDI  R30,LOW(_h)
	LDI  R31,HIGH(_h)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_m)
	LDI  R31,HIGH(_m)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_s)
	LDI  R31,HIGH(_s)
	ST   -Y,R31
	ST   -Y,R30
	CALL _rtc_get_time
; 0000 015E 
; 0000 015F             MoverCursor(8,1);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _MoverCursor
; 0000 0160             sprintf(print_aux, "%i:%i", h, m);
	LDI  R30,LOW(_print_aux)
	LDI  R31,HIGH(_print_aux)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,547
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_h
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_m
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 0161             StringLCDVar(print_aux);
	LDI  R30,LOW(_print_aux)
	LDI  R31,HIGH(_print_aux)
	ST   -Y,R31
	ST   -Y,R30
	CALL _StringLCDVar
; 0000 0162 
; 0000 0163             while(Bot3 == 1 && Bot2 == 1 && Bot1 == 1);
_0xAE:
	SBIS 0x6,5
	RJMP _0xB1
	SBIS 0x6,6
	RJMP _0xB1
	SBIC 0x6,7
	RJMP _0xB2
_0xB1:
	RJMP _0xB0
_0xB2:
	RJMP _0xAE
_0xB0:
; 0000 0164             if(Bot1==0) {
	SBIC 0x6,7
	RJMP _0xB3
; 0000 0165                 h++;
	LDS  R30,_h
	SUBI R30,-LOW(1)
	STS  _h,R30
; 0000 0166                 rtc_set_time(h,m,0);
	ST   -Y,R30
	LDS  R30,_m
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _rtc_set_time
; 0000 0167             } else if(Bot2==0) {
	RJMP _0xB4
_0xB3:
	SBIC 0x6,6
	RJMP _0xB5
; 0000 0168                 m++;
	LDS  R30,_m
	SUBI R30,-LOW(1)
	STS  _m,R30
; 0000 0169                 rtc_set_time(h,m,0);
	LDS  R30,_h
	ST   -Y,R30
	LDS  R30,_m
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _rtc_set_time
; 0000 016A             } else if(Bot3 == 0) {
	RJMP _0xB6
_0xB5:
	SBIC 0x6,5
	RJMP _0xB7
; 0000 016B                 id_menu = 0;
	LDI  R30,LOW(0)
	STS  _id_menu,R30
	STS  _id_menu+1,R30
; 0000 016C                 BorrarLCD();
	CALL _BorrarLCD
; 0000 016D                 MoverCursor(6,1);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _MoverCursor
; 0000 016E                 StringLCD("Set time");
	__POINTW1FN _0x0,553
	ST   -Y,R31
	ST   -Y,R30
	CALL _StringLCD
; 0000 016F                 MoverCursor(6,2);
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _MoverCursor
; 0000 0170                 StringLCD("success!");
	__POINTW1FN _0x0,562
	ST   -Y,R31
	ST   -Y,R30
	CALL _StringLCD
; 0000 0171                 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0172             }
; 0000 0173             break;
_0xB7:
_0xB6:
_0xB4:
	RJMP _0x71
; 0000 0174         case 3:
_0xAD:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x71
; 0000 0175             menu0_3();
	RCALL _menu0_3
; 0000 0176             while(Identify() == NACK_FINGER_IS_NOT_PRESSED);
_0xB9:
	RCALL _Identify
	CPI  R30,LOW(0x1012)
	LDI  R26,HIGH(0x1012)
	CPC  R31,R26
	BREQ _0xB9
; 0000 0177             if(Response_1 == 0x30) {
	LDS  R26,_Response_1
	CPI  R26,LOW(0x30)
	BREQ PC+3
	JMP _0xBC
; 0000 0178                 rtc_get_time(&h,&m,&s);
	LDI  R30,LOW(_h)
	LDI  R31,HIGH(_h)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_m)
	LDI  R31,HIGH(_m)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_s)
	LDI  R31,HIGH(_s)
	ST   -Y,R31
	ST   -Y,R30
	CALL _rtc_get_time
; 0000 0179                 rtc_get_date(&d,&mo,&y);
	LDI  R30,LOW(_d)
	LDI  R31,HIGH(_d)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_mo)
	LDI  R31,HIGH(_mo)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_y)
	LDI  R31,HIGH(_y)
	ST   -Y,R31
	ST   -Y,R30
	CALL _rtc_get_date
; 0000 017A                 sprintf(aux, "%i/%i/%i | %i:%i:%i | ID: 0%i \n", d, mo, y, h, m , s, (Parameter_1 + 1));
	MOVW R30,R28
	SUBI R30,LOW(-(1106))
	SBCI R31,HIGH(-(1106))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,571
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_d
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_mo
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_y
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_h
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_m
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_s
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R8
	LDI  R31,0
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,28
	CALL _sprintf
	ADIW R28,32
; 0000 017B                 /* mount logical drive 0: */
; 0000 017C                 if ((res=f_mount(0,&drive))==FR_OK){
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(545))
	SBCI R31,HIGH(-(545))
	ST   -Y,R31
	ST   -Y,R30
	CALL _f_mount
	MOV  R19,R30
	CPI  R30,0
	BRNE _0xBD
; 0000 017D                     /*Lectura de Archivo*/
; 0000 017E                     res = f_open(&archivo, NombreArchivo, FA_OPEN_ALWAYS | FA_WRITE | FA_READ);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_NombreArchivo)
	LDI  R31,HIGH(_NombreArchivo)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(19)
	ST   -Y,R30
	CALL _f_open
	MOV  R19,R30
; 0000 017F                     if (res==FR_OK) {
	CPI  R19,0
	BRNE _0xBE
; 0000 0180                         f_write(&archivo,aux,sizeof(aux),&br);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(1108))
	SBCI R31,HIGH(-(1108))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	CALL _f_write
	POP  R16
	POP  R17
; 0000 0181                         f_close(&archivo);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	CALL _f_close
; 0000 0182                         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0183                     }
; 0000 0184                 }
_0xBE:
; 0000 0185                 f_mount(0, 0); //Cerrar drive de SD
_0xBD:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL _f_mount
; 0000 0186                 BorrarLCD();
	CALL _BorrarLCD
; 0000 0187                 MoverCursor(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _MoverCursor
; 0000 0188                 StringLCD("       Welcome");
	__POINTW1FN _0x0,603
	ST   -Y,R31
	ST   -Y,R30
	CALL _StringLCD
; 0000 0189                 MoverCursor(0,2);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _MoverCursor
; 0000 018A                 sprintf(print_aux,"    %i", (Parameter_1 + 1));
	LDI  R30,LOW(_print_aux)
	LDI  R31,HIGH(_print_aux)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,618
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R8
	LDI  R31,0
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 018B                 StringLCDVar(print_aux);
	LDI  R30,LOW(_print_aux)
	LDI  R31,HIGH(_print_aux)
	ST   -Y,R31
	ST   -Y,R30
	CALL _StringLCDVar
; 0000 018C                 delay_ms(1000);
	RJMP _0xC7
; 0000 018D             } else {
_0xBC:
; 0000 018E                 BorrarLCD();
	CALL _BorrarLCD
; 0000 018F                 MoverCursor(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _MoverCursor
; 0000 0190                 StringLCD("    Access Denied");
	__POINTW1FN _0x0,495
	ST   -Y,R31
	ST   -Y,R30
	CALL _StringLCD
; 0000 0191                 delay_ms(1000);
_0xC7:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0192             }
; 0000 0193             while(Bot3 == 1);
_0xC0:
	SBIC 0x6,5
	RJMP _0xC0
; 0000 0194             if(Bot3 == 0)
	SBIC 0x6,5
	RJMP _0xC3
; 0000 0195                 id_menu = 0;
	LDI  R30,LOW(0)
	STS  _id_menu,R30
	STS  _id_menu+1,R30
; 0000 0196 
; 0000 0197             break;
_0xC3:
; 0000 0198         }
_0x71:
; 0000 0199     }
	RJMP _0x6C
; 0000 019A }
_0xC4:
	RJMP _0xC4

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200000D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x212001E
_0x200000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200000C
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x212001E
_0x200000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x200000F
	__GETD1S 9
	CALL __ANEGF1
	__PUTD1S 9
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(45)
	ST   X,R30
_0x200000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2000010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2000010:
	LDD  R17,Y+8
_0x2000011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000013
	__GETD2S 2
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 2
	RJMP _0x2000011
_0x2000013:
	__GETD1S 2
	__GETD2S 9
	CALL __ADDF12
	__PUTD1S 9
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	__PUTD1S 2
_0x2000014:
	__GETD1S 2
	__GETD2S 9
	CALL __CMPF12
	BRLO _0x2000016
	__GETD2S 2
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 2
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2000017
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,5
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x212001E
_0x2000017:
	RJMP _0x2000014
_0x2000016:
	CPI  R17,0
	BRNE _0x2000018
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2000019
_0x2000018:
_0x200001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BRNE PC+3
	JMP _0x200001C
	__GETD2S 2
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 2
	__GETD2S 9
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	__GETD2S 2
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	__GETD2S 9
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 9
	RJMP _0x200001A
_0x200001C:
_0x2000019:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x200001D
	RJMP _0x212001D
_0x200001D:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(46)
	ST   X,R30
_0x200001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2000020
	__GETD2S 9
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 9
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	__GETD2S 9
	CALL __CWD1
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 9
	RJMP _0x200001E
_0x2000020:
_0x212001D:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x212001E:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
_wait_ready_G101:
	ST   -Y,R17
	LDI  R30,LOW(50)
	STS  _timer2_G101,R30
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x2020004:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020004
_0x2020008:
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x202000A:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202000A
	IN   R17,46
	CPI  R17,255
	BREQ _0x202000D
	LDS  R30,_timer2_G101
	CPI  R30,0
	BRNE _0x202000E
_0x202000D:
	RJMP _0x2020009
_0x202000E:
	RJMP _0x2020008
_0x2020009:
	MOV  R30,R17
	LD   R17,Y+
	RET
_release_spi_G101:
	SBI  0x5,0
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x202000F:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202000F
	RET
_rx_datablock_G101:
	CALL __SAVELOCR4
	LDI  R30,LOW(10)
	STS  _timer1_G101,R30
_0x2020013:
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x2020015:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020015
	IN   R17,46
	CPI  R17,255
	BRNE _0x2020018
	LDS  R30,_timer1_G101
	CPI  R30,0
	BRNE _0x2020019
_0x2020018:
	RJMP _0x2020014
_0x2020019:
	RJMP _0x2020013
_0x2020014:
	CPI  R17,254
	BREQ _0x202001A
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	RJMP _0x2120017
_0x202001A:
	__GETWRS 18,19,6
_0x202001C:
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x202001E:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202001E
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	IN   R30,0x2E
	POP  R26
	POP  R27
	ST   X,R30
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x2020021:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020021
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	IN   R30,0x2E
	POP  R26
	POP  R27
	ST   X,R30
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x2020024:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020024
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	IN   R30,0x2E
	POP  R26
	POP  R27
	ST   X,R30
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x2020027:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020027
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	IN   R30,0x2E
	POP  R26
	POP  R27
	ST   X,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,4
	STD  Y+4,R30
	STD  Y+4+1,R31
	BRNE _0x202001C
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x202002A:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202002A
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x202002D:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202002D
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	RJMP _0x2120017
_tx_datablock_G101:
	CALL __SAVELOCR4
	RCALL _wait_ready_G101
	CPI  R30,LOW(0xFF)
	BREQ _0x2020030
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	RJMP _0x2120018
_0x2020030:
	LDD  R30,Y+4
	OUT  0x2E,R30
_0x2020031:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020031
	LDD  R26,Y+4
	CPI  R26,LOW(0xFD)
	BREQ _0x2020034
	LDI  R16,LOW(0)
	__GETWRS 18,19,5
_0x2020036:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	OUT  0x2E,R30
_0x2020038:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020038
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	OUT  0x2E,R30
_0x202003B:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202003B
	SUBI R16,LOW(1)
	CPI  R16,0
	BRNE _0x2020036
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x202003E:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202003E
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x2020041:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020041
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x2020044:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020044
	IN   R17,46
	MOV  R30,R17
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0x5)
	BREQ _0x2020047
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	RJMP _0x2120018
_0x2020047:
_0x2020034:
	LDI  R30,LOW(1)
	CALL __LOADLOCR4
	RJMP _0x2120018
_send_cmd_G101:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+6
	ANDI R30,LOW(0x80)
	BREQ _0x2020048
	LDD  R30,Y+6
	ANDI R30,0x7F
	STD  Y+6,R30
	LDI  R30,LOW(119)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	MOV  R16,R30
	CPI  R16,2
	BRLO _0x2020049
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120018
_0x2020049:
_0x2020048:
	SBI  0x5,0
	CBI  0x5,0
	RCALL _wait_ready_G101
	CPI  R30,LOW(0xFF)
	BREQ _0x202004A
	LDI  R30,LOW(255)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120018
_0x202004A:
	LDD  R30,Y+6
	OUT  0x2E,R30
_0x202004B:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202004B
	LDD  R30,Y+5
	OUT  0x2E,R30
_0x202004E:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202004E
	LDD  R30,Y+4
	OUT  0x2E,R30
_0x2020051:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020051
	LDD  R30,Y+3
	OUT  0x2E,R30
_0x2020054:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020054
	LDD  R30,Y+2
	OUT  0x2E,R30
_0x2020057:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020057
	LDI  R17,LOW(1)
	LDD  R26,Y+6
	CPI  R26,LOW(0x40)
	BRNE _0x202005A
	LDI  R17,LOW(149)
	RJMP _0x202005B
_0x202005A:
	LDD  R26,Y+6
	CPI  R26,LOW(0x48)
	BRNE _0x202005C
	LDI  R17,LOW(135)
_0x202005C:
_0x202005B:
	OUT  0x2E,R17
_0x202005D:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202005D
	LDD  R26,Y+6
	CPI  R26,LOW(0x4C)
	BRNE _0x2020060
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x2020061:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020061
_0x2020060:
	LDI  R17,LOW(255)
_0x2020065:
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x2020067:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020067
	IN   R16,46
	SBRS R16,7
	RJMP _0x202006A
	SUBI R17,LOW(1)
	CPI  R17,0
	BRNE _0x202006B
_0x202006A:
	RJMP _0x2020066
_0x202006B:
	RJMP _0x2020065
_0x2020066:
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120018
_rx_spi4_G101:
	ST   -Y,R17
	LDI  R17,4
_0x202006D:
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x202006F:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202006F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	STD  Y+1,R26
	STD  Y+1+1,R27
	SBIW R26,1
	IN   R30,0x2E
	ST   X,R30
	SUBI R17,LOW(1)
	CPI  R17,0
	BRNE _0x202006D
	RJMP _0x2120016
_disk_initialize:
	SBIW R28,4
	CALL __SAVELOCR4
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2020072
	LDI  R30,LOW(1)
	RJMP _0x212001C
_0x2020072:
	CBI  0x4,4
	CBI  0x4,5
	LDI  R30,LOW(10)
	STS  _timer1_G101,R30
_0x2020073:
	LDS  R30,_timer1_G101
	CPI  R30,0
	BRNE _0x2020073
	LDS  R30,_status_G101
	ANDI R30,LOW(0x2)
	BREQ _0x2020076
	RJMP _0x212001B
_0x2020076:
	SBI  0x4,0
	SBI  0x5,0
	IN   R30,0x5
	ANDI R30,LOW(0xF9)
	OUT  0x5,R30
	SBI  0x5,3
	CBI  0x4,3
	IN   R30,0x4
	ORI  R30,LOW(0x7)
	OUT  0x4,R30
	LDI  R30,LOW(81)
	OUT  0x2C,R30
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	LDI  R19,LOW(255)
_0x2020078:
	LDI  R17,LOW(10)
_0x202007B:
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x202007D:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x202007D
	SUBI R17,LOW(1)
	CPI  R17,0
	BRNE _0x202007B
	LDI  R30,LOW(64)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	MOV  R16,R30
	SUBI R19,LOW(1)
	CPI  R16,1
	BREQ _0x2020080
	CPI  R19,0
	BRNE _0x2020081
_0x2020080:
	RJMP _0x2020079
_0x2020081:
	RJMP _0x2020078
_0x2020079:
	LDI  R19,LOW(0)
	CPI  R16,1
	BREQ PC+3
	JMP _0x2020082
	LDI  R30,LOW(100)
	STS  _timer1_G101,R30
	LDI  R30,LOW(72)
	ST   -Y,R30
	__GETD1N 0x1AA
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,LOW(0x1)
	BRNE _0x2020083
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rx_spi4_G101
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x2020085
	LDD  R26,Y+7
	CPI  R26,LOW(0xAA)
	BREQ _0x2020086
_0x2020085:
	RJMP _0x2020084
_0x2020086:
_0x2020087:
	LDS  R30,_timer1_G101
	CPI  R30,0
	BREQ _0x202008A
	LDI  R30,LOW(233)
	ST   -Y,R30
	__GETD1N 0x40000000
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x202008B
_0x202008A:
	RJMP _0x2020089
_0x202008B:
	RJMP _0x2020087
_0x2020089:
	LDS  R30,_timer1_G101
	CPI  R30,0
	BREQ _0x202008D
	LDI  R30,LOW(122)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BREQ _0x202008E
_0x202008D:
	RJMP _0x202008C
_0x202008E:
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rx_spi4_G101
	LDD  R30,Y+4
	ANDI R30,LOW(0x40)
	BREQ _0x202008F
	LDI  R30,LOW(12)
	RJMP _0x2020090
_0x202008F:
	LDI  R30,LOW(4)
_0x2020090:
	MOV  R19,R30
_0x202008C:
_0x2020084:
	RJMP _0x2020092
_0x2020083:
	LDI  R30,LOW(233)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,LOW(0x2)
	BRSH _0x2020093
	LDI  R19,LOW(2)
	LDI  R16,LOW(233)
	RJMP _0x2020094
_0x2020093:
	LDI  R19,LOW(1)
	LDI  R16,LOW(65)
_0x2020094:
_0x2020095:
	LDS  R30,_timer1_G101
	CPI  R30,0
	BREQ _0x2020098
	ST   -Y,R16
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x2020099
_0x2020098:
	RJMP _0x2020097
_0x2020099:
	RJMP _0x2020095
_0x2020097:
	LDS  R30,_timer1_G101
	CPI  R30,0
	BREQ _0x202009B
	LDI  R30,LOW(80)
	ST   -Y,R30
	__GETD1N 0x200
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BREQ _0x202009A
_0x202009B:
	LDI  R19,LOW(0)
_0x202009A:
_0x2020092:
_0x2020082:
	STS  _card_type_G101,R19
	RCALL _release_spi_G101
	CPI  R19,0
	BREQ _0x202009D
	LDS  R30,_status_G101
	ANDI R30,0xFE
	STS  _status_G101,R30
	LDI  R30,LOW(80)
	OUT  0x2C,R30
	LDI  R30,LOW(1)
	OUT  0x2D,R30
	RJMP _0x202009E
_0x202009D:
	CBI  0x5,0
	RCALL _wait_ready_G101
	RCALL _release_spi_G101
	LDI  R30,LOW(0)
	OUT  0x2C,R30
	IN   R30,0x4
	ANDI R30,LOW(0xF0)
	OUT  0x4,R30
	IN   R30,0x5
	ANDI R30,LOW(0xF0)
	OUT  0x5,R30
	CBI  0x4,0
	LDS  R30,_status_G101
	ORI  R30,1
	STS  _status_G101,R30
_0x202009E:
_0x212001B:
	LDS  R30,_status_G101
_0x212001C:
	CALL __LOADLOCR4
	ADIW R28,9
	RET
_disk_status:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x202009F
	LDI  R30,LOW(1)
	RJMP _0x212001A
_0x202009F:
	LDS  R30,_status_G101
_0x212001A:
	ADIW R28,1
	RET
_disk_read:
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x20200A1
	LD   R30,Y
	CPI  R30,0
	BRNE _0x20200A0
_0x20200A1:
	LDI  R30,LOW(4)
	RJMP _0x2120017
_0x20200A0:
	LDS  R30,_status_G101
	ANDI R30,LOW(0x1)
	BREQ _0x20200A3
	LDI  R30,LOW(3)
	RJMP _0x2120017
_0x20200A3:
	LDS  R30,_card_type_G101
	ANDI R30,LOW(0x8)
	BRNE _0x20200A4
	__GETD1S 1
	__GETD2N 0x200
	CALL __MULD12U
	__PUTD1S 1
_0x20200A4:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x20200A5
	LDI  R30,LOW(81)
	ST   -Y,R30
	__GETD1S 2
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200A7
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rx_datablock_G101
	CPI  R30,0
	BRNE _0x20200A8
_0x20200A7:
	RJMP _0x20200A6
_0x20200A8:
	LDI  R30,LOW(0)
	ST   Y,R30
_0x20200A6:
	RJMP _0x20200A9
_0x20200A5:
	LDI  R30,LOW(82)
	ST   -Y,R30
	__GETD1S 2
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200AA
_0x20200AC:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rx_datablock_G101
	CPI  R30,0
	BREQ _0x20200AD
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SUBI R30,LOW(-512)
	SBCI R31,HIGH(-512)
	STD  Y+5,R30
	STD  Y+5+1,R31
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
	BRNE _0x20200AC
_0x20200AD:
	LDI  R30,LOW(76)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
_0x20200AA:
_0x20200A9:
	RCALL _release_spi_G101
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20200AF
	LDI  R30,LOW(1)
	RJMP _0x20200B0
_0x20200AF:
	LDI  R30,LOW(0)
_0x20200B0:
	RJMP _0x2120017
_disk_write:
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x20200B3
	LD   R30,Y
	CPI  R30,0
	BRNE _0x20200B2
_0x20200B3:
	LDI  R30,LOW(4)
	RJMP _0x2120017
_0x20200B2:
	LDS  R30,_status_G101
	ANDI R30,LOW(0x1)
	BREQ _0x20200B5
	LDI  R30,LOW(3)
	RJMP _0x2120017
_0x20200B5:
	LDS  R30,_status_G101
	ANDI R30,LOW(0x4)
	BREQ _0x20200B6
	LDI  R30,LOW(2)
	RJMP _0x2120017
_0x20200B6:
	LDS  R30,_card_type_G101
	ANDI R30,LOW(0x8)
	BRNE _0x20200B7
	__GETD1S 1
	__GETD2N 0x200
	CALL __MULD12U
	__PUTD1S 1
_0x20200B7:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x20200B8
	LDI  R30,LOW(88)
	ST   -Y,R30
	__GETD1S 2
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200BA
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(254)
	ST   -Y,R30
	RCALL _tx_datablock_G101
	CPI  R30,0
	BRNE _0x20200BB
_0x20200BA:
	RJMP _0x20200B9
_0x20200BB:
	LDI  R30,LOW(0)
	ST   Y,R30
_0x20200B9:
	RJMP _0x20200BC
_0x20200B8:
	LDS  R30,_card_type_G101
	ANDI R30,LOW(0x6)
	BREQ _0x20200BD
	LDI  R30,LOW(215)
	ST   -Y,R30
	LDD  R30,Y+1
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RCALL _send_cmd_G101
_0x20200BD:
	LDI  R30,LOW(89)
	ST   -Y,R30
	__GETD1S 2
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200BE
_0x20200C0:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(252)
	ST   -Y,R30
	RCALL _tx_datablock_G101
	CPI  R30,0
	BREQ _0x20200C1
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SUBI R30,LOW(-512)
	SBCI R31,HIGH(-512)
	STD  Y+5,R30
	STD  Y+5+1,R31
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
	BRNE _0x20200C0
_0x20200C1:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(253)
	ST   -Y,R30
	RCALL _tx_datablock_G101
	CPI  R30,0
	BRNE _0x20200C3
	LDI  R30,LOW(1)
	ST   Y,R30
_0x20200C3:
_0x20200BE:
_0x20200BC:
	RCALL _release_spi_G101
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20200C4
	LDI  R30,LOW(1)
	RJMP _0x20200C5
_0x20200C4:
	LDI  R30,LOW(0)
_0x20200C5:
	RJMP _0x2120017
_disk_ioctl:
	SBIW R28,16
	CALL __SAVELOCR6
	LDD  R30,Y+25
	CPI  R30,0
	BREQ _0x20200C7
	LDI  R30,LOW(4)
	RJMP _0x2120019
_0x20200C7:
	LDI  R17,LOW(1)
	LDS  R30,_status_G101
	ANDI R30,LOW(0x1)
	BREQ _0x20200C8
	LDI  R30,LOW(3)
	RJMP _0x2120019
_0x20200C8:
	__GETWRS 20,21,22
	LDD  R30,Y+24
	CPI  R30,0
	BRNE _0x20200CC
	CBI  0x5,0
	RCALL _wait_ready_G101
	CPI  R30,LOW(0xFF)
	BRNE _0x20200CD
	LDI  R17,LOW(0)
_0x20200CD:
	RJMP _0x20200CB
_0x20200CC:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x20200CE
	LDI  R30,LOW(73)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200D0
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rx_datablock_G101
	CPI  R30,0
	BRNE _0x20200D1
_0x20200D0:
	RJMP _0x20200CF
_0x20200D1:
	LDD  R30,Y+6
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	CPI  R30,LOW(0x1)
	BRNE _0x20200D2
	LDI  R30,0
	LDD  R31,Y+14
	LDD  R26,Y+15
	LDI  R27,0
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	MOVW R18,R30
	MOVW R26,R18
	CLR  R24
	CLR  R25
	LDI  R30,LOW(10)
	RJMP _0x2020101
_0x20200D2:
	LDD  R30,Y+11
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LDD  R30,Y+16
	ANDI R30,LOW(0x80)
	ROL  R30
	LDI  R30,0
	ROL  R30
	ADD  R26,R30
	LDD  R30,Y+15
	ANDI R30,LOW(0x3)
	LSL  R30
	ADD  R30,R26
	SUBI R30,-LOW(2)
	MOV  R16,R30
	LDD  R30,Y+14
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	MOV  R26,R30
	LDD  R30,Y+13
	LDI  R31,0
	CALL __LSLW2
	LDI  R27,0
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+12
	ANDI R30,LOW(0x3)
	LDI  R31,0
	CALL __LSLW2
	MOV  R31,R30
	LDI  R30,0
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	MOVW R18,R30
	MOVW R26,R18
	CLR  R24
	CLR  R25
	MOV  R30,R16
	SUBI R30,LOW(9)
_0x2020101:
	CALL __LSLD12
	MOVW R26,R20
	CALL __PUTDP1
	LDI  R17,LOW(0)
_0x20200CF:
	RJMP _0x20200CB
_0x20200CE:
	CPI  R30,LOW(0x2)
	BRNE _0x20200D4
	MOVW R26,R20
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	ST   X+,R30
	ST   X,R31
	LDI  R17,LOW(0)
	RJMP _0x20200CB
_0x20200D4:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x20200D5
	LDS  R30,_card_type_G101
	ANDI R30,LOW(0x4)
	BREQ _0x20200D6
	LDI  R30,LOW(205)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200D7
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x20200D8:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x20200D8
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rx_datablock_G101
	CPI  R30,0
	BREQ _0x20200DB
	LDI  R16,LOW(48)
_0x20200DD:
	CPI  R16,0
	BREQ _0x20200DE
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x20200DF:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x20200DF
	SUBI R16,1
	RJMP _0x20200DD
_0x20200DE:
	LDD  R30,Y+16
	SWAP R30
	ANDI R30,0xF
	__GETD2N 0x10
	CALL __LSLD12
	MOVW R26,R20
	CALL __PUTDP1
	LDI  R17,LOW(0)
_0x20200DB:
_0x20200D7:
	RJMP _0x20200E2
_0x20200D6:
	LDI  R30,LOW(73)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200E4
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rx_datablock_G101
	CPI  R30,0
	BRNE _0x20200E5
_0x20200E4:
	RJMP _0x20200E3
_0x20200E5:
	LDS  R30,_card_type_G101
	ANDI R30,LOW(0x2)
	BREQ _0x20200E6
	LDD  R30,Y+16
	ANDI R30,LOW(0x3F)
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+17
	ANDI R30,LOW(0x80)
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(7)
	CALL __LSRD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	__ADDD1N 1
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+19
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	SUBI R30,LOW(1)
	CALL __LSLD12
	RJMP _0x2020102
_0x20200E6:
	LDD  R30,Y+16
	ANDI R30,LOW(0x7C)
	LSR  R30
	LSR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	__ADDD1N 1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+17
	ANDI R30,LOW(0x3)
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(3)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+17
	ANDI R30,LOW(0xE0)
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__ADDD1N 1
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULD12U
_0x2020102:
	MOVW R26,R20
	CALL __PUTDP1
	LDI  R17,LOW(0)
_0x20200E3:
_0x20200E2:
	RJMP _0x20200CB
_0x20200D5:
	CPI  R30,LOW(0xA)
	BRNE _0x20200E8
	LDS  R30,_card_type_G101
	MOVW R26,R20
	ST   X,R30
	LDI  R17,LOW(0)
	RJMP _0x20200CB
_0x20200E8:
	CPI  R30,LOW(0xB)
	BRNE _0x20200E9
	LDI  R30,LOW(73)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200EB
	ST   -Y,R21
	ST   -Y,R20
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rx_datablock_G101
	CPI  R30,0
	BRNE _0x20200EC
_0x20200EB:
	RJMP _0x20200EA
_0x20200EC:
	LDI  R17,LOW(0)
_0x20200EA:
	RJMP _0x20200CB
_0x20200E9:
	CPI  R30,LOW(0xC)
	BRNE _0x20200ED
	LDI  R30,LOW(74)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200EF
	ST   -Y,R21
	ST   -Y,R20
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rx_datablock_G101
	CPI  R30,0
	BRNE _0x20200F0
_0x20200EF:
	RJMP _0x20200EE
_0x20200F0:
	LDI  R17,LOW(0)
_0x20200EE:
	RJMP _0x20200CB
_0x20200ED:
	CPI  R30,LOW(0xD)
	BRNE _0x20200F1
	LDI  R30,LOW(122)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200F2
	ST   -Y,R21
	ST   -Y,R20
	RCALL _rx_spi4_G101
	LDI  R17,LOW(0)
_0x20200F2:
	RJMP _0x20200CB
_0x20200F1:
	CPI  R30,LOW(0xE)
	BRNE _0x20200F9
	LDI  R30,LOW(205)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _send_cmd_G101
	CPI  R30,0
	BRNE _0x20200F4
	LDI  R30,LOW(255)
	OUT  0x2E,R30
_0x20200F5:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x20200F5
	ST   -Y,R21
	ST   -Y,R20
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rx_datablock_G101
	CPI  R30,0
	BREQ _0x20200F8
	LDI  R17,LOW(0)
_0x20200F8:
_0x20200F4:
	RJMP _0x20200CB
_0x20200F9:
	LDI  R17,LOW(4)
_0x20200CB:
	RCALL _release_spi_G101
	MOV  R30,R17
_0x2120019:
	CALL __LOADLOCR6
	ADIW R28,26
	RET
_disk_timerproc:
	ST   -Y,R17
	ST   -Y,R16
	LDS  R17,_timer1_G101
	CPI  R17,0
	BREQ _0x20200FA
	SUBI R17,LOW(1)
	STS  _timer1_G101,R17
_0x20200FA:
	LDS  R17,_timer2_G101
	CPI  R17,0
	BREQ _0x20200FB
	SUBI R17,LOW(1)
	STS  _timer2_G101,R17
_0x20200FB:
	LDS  R17,_pv_S101000B000
	IN   R30,0x3
	ANDI R30,LOW(0x20)
	MOV  R26,R30
	IN   R30,0x3
	ANDI R30,LOW(0x10)
	OR   R30,R26
	STS  _pv_S101000B000,R30
	CP   R30,R17
	BRNE _0x20200FC
	LDS  R16,_status_G101
	ANDI R30,LOW(0x20)
	BREQ _0x20200FD
	ORI  R16,LOW(4)
	RJMP _0x20200FE
_0x20200FD:
	ANDI R16,LOW(251)
_0x20200FE:
	LDS  R30,_pv_S101000B000
	ANDI R30,LOW(0x10)
	BREQ _0x20200FF
	ORI  R16,LOW(3)
	RJMP _0x2020100
_0x20200FF:
	ANDI R16,LOW(253)
_0x2020100:
	STS  _status_G101,R16
_0x20200FC:
	LD   R16,Y+
	LD   R17,Y+
	RET

	.CSEG
_get_fattime:
	SBIW R28,7
	LDS  R26,_prtc_get_time
	LDS  R27,_prtc_get_time+1
	SBIW R26,0
	BREQ _0x2040004
	LDS  R26,_prtc_get_date
	LDS  R27,_prtc_get_date+1
	SBIW R26,0
	BRNE _0x2040003
_0x2040004:
	__GETD1N 0x3A210000
	RJMP _0x2120018
_0x2040003:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	__CALL1MN _prtc_get_time,0
	MOVW R30,R28
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	__CALL1MN _prtc_get_date,0
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(1980)
	SBCI R31,HIGH(1980)
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(25)
	CALL __LSLD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+2
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(21)
	CALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+3
	LDI  R31,0
	CALL __CWD1
	CALL __LSLD16
	CALL __ORD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+6
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(11)
	CALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+5
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(5)
	CALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDI  R31,0
	ASR  R31
	ROR  R30
	CALL __CWD1
	CALL __ORD12
_0x2120018:
	ADIW R28,7
	RET
_mem_cpy_G102:
	CALL __SAVELOCR4
	__GETWRS 16,17,8
	__GETWRS 18,19,6
_0x2040006:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	ADIW R30,1
	BREQ _0x2040008
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x2040006
_0x2040008:
	CALL __LOADLOCR4
	RJMP _0x2120013
_mem_set_G102:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRS 16,17,6
_0x204000C:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
	ADIW R30,1
	BREQ _0x204000E
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	LDD  R30,Y+4
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x204000C
_0x204000E:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2120017:
	ADIW R28,8
	RET
_mem_cmp_G102:
	CALL __SAVELOCR6
	__GETWRS 16,17,10
	__GETWRS 18,19,8
	__GETWRN 20,21,0
_0x204000F:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	ADIW R30,1
	BREQ _0x2040012
	MOVW R26,R16
	__ADDWRN 16,17,1
	LD   R0,X
	CLR  R1
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R26,X
	CLR  R27
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	MOVW R20,R30
	SBIW R30,0
	BREQ _0x2040013
_0x2040012:
	RJMP _0x2040011
_0x2040013:
	RJMP _0x204000F
_0x2040011:
	MOVW R30,R20
	CALL __LOADLOCR6
	ADIW R28,12
	RET
_chk_chrf_G102:
_0x2040014:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x2040017
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LPM  R26,Z
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x2040018
_0x2040017:
	RJMP _0x2040016
_0x2040018:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
	RJMP _0x2040014
_0x2040016:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LPM  R30,Z
	LDI  R31,0
	ADIW R28,4
	RET
_move_window_G102:
	SBIW R28,4
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,46
	CALL __GETD1P
	CALL __PUTD1S0
	__GETD1S 4
	CALL __GETD2S0
	CALL __CPD12
	BRNE PC+3
	JMP _0x2040019
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,4
	LD   R30,X
	CPI  R30,0
	BRNE PC+3
	JMP _0x204001A
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 3
	CALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _disk_write
	CPI  R30,0
	BREQ _0x204001B
	LDI  R30,LOW(1)
	RJMP _0x2120013
_0x204001B:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__GETD2Z 34
	MOVW R0,R26
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,26
	CALL __GETD1P
	MOVW R26,R0
	CALL __ADDD12
	CALL __GETD2S0
	CALL __CPD21
	BRSH _0x204001C
	SBIW R28,1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,3
	LD   R30,X
	ST   Y,R30
_0x204001E:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRLO _0x204001F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,26
	CALL __GETD1P
	__GETD2S 1
	CALL __ADDD12
	__PUTD1S 1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 4
	CALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _disk_write
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
	RJMP _0x204001E
_0x204001F:
	ADIW R28,1
_0x204001C:
_0x204001A:
	__GETD1S 4
	CALL __CPD10
	BREQ _0x2040020
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 7
	CALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _disk_read
	CPI  R30,0
	BREQ _0x2040021
	LDI  R30,LOW(1)
	RJMP _0x2120013
_0x2040021:
	__GETD1S 4
	__PUTD1SNS 8,46
_0x2040020:
_0x2040019:
	LDI  R30,LOW(0)
	RJMP _0x2120013
_sync_G102:
	ST   -Y,R17
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _move_window_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ PC+3
	JMP _0x2040022
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R26,X
	CPI  R26,LOW(0x3)
	BRNE _0x2040024
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,9
	LD   R30,X
	CPI  R30,0
	BRNE _0x2040025
_0x2040024:
	RJMP _0x2040023
_0x2040025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,46
	__GETD1N 0x0
	CALL __PUTDP1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _mem_set_G102
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	SUBI R30,LOW(-510)
	SBCI R31,HIGH(-510)
	LDI  R26,LOW(43605)
	LDI  R27,HIGH(43605)
	STD  Z+0,R26
	STD  Z+1,R27
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	__GETD2N 0x41615252
	CALL __PUTDZ20
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	SUBI R30,LOW(-484)
	SBCI R31,HIGH(-484)
	__GETD2N 0x61417272
	CALL __PUTDZ20
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	SUBI R30,LOW(-488)
	SBCI R31,HIGH(-488)
	MOVW R0,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,14
	CALL __GETD1P
	MOVW R26,R0
	CALL __PUTDP1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,50
	SUBI R30,LOW(-492)
	SBCI R31,HIGH(-492)
	MOVW R0,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,10
	CALL __GETD1P
	MOVW R26,R0
	CALL __PUTDP1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__GETD2Z 18
	CALL __PUTPARD2
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _disk_write
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,9
	LDI  R30,LOW(0)
	ST   X,R30
_0x2040023:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _disk_ioctl
	CPI  R30,0
	BREQ _0x2040026
	LDI  R17,LOW(1)
_0x2040026:
_0x2040022:
	MOV  R30,R17
_0x2120016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_get_fat_G102:
	SBIW R28,4
	CALL __SAVELOCR4
	__GETD2S 8
	__CPD2N 0x2
	BRLO _0x2040028
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,30
	CALL __GETD1P
	__GETD2S 8
	CALL __CPD21
	BRLO _0x2040027
_0x2040028:
	__GETD1N 0x1
	RJMP _0x2120015
_0x2040027:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,34
	CALL __GETD1P
	__PUTD1S 4
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x204002D
	__GETWRS 18,19,8
	MOVW R30,R18
	LSR  R31
	ROR  R30
	__ADDWRR 18,19,30,31
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R18
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	__GETD2S 6
	CLR  R22
	CLR  R23
	CALL __ADDD12
	CALL __PUTPARD1
	RCALL _move_window_G102
	CPI  R30,0
	BREQ _0x204002E
	RJMP _0x204002C
_0x204002E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,50
	MOVW R30,R18
	ANDI R31,HIGH(0x1FF)
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X
	CLR  R17
	__ADDWRN 18,19,1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R18
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	__GETD2S 6
	CLR  R22
	CLR  R23
	CALL __ADDD12
	CALL __PUTPARD1
	RCALL _move_window_G102
	CPI  R30,0
	BREQ _0x204002F
	RJMP _0x204002C
_0x204002F:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,50
	MOVW R30,R18
	ANDI R31,HIGH(0x1FF)
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOV  R31,R30
	LDI  R30,0
	__ORWRR 16,17,30,31
	LDD  R30,Y+8
	ANDI R30,LOW(0x1)
	BREQ _0x2040030
	MOVW R30,R16
	CALL __LSRW4
	RJMP _0x2040229
_0x2040030:
	MOVW R30,R16
	ANDI R31,HIGH(0xFFF)
_0x2040229:
	CLR  R22
	CLR  R23
	RJMP _0x2120015
_0x204002D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2040033
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 10
	__GETD1N 0x100
	CALL __DIVD21U
	__GETD2S 6
	CALL __ADDD12
	CALL __PUTPARD1
	RCALL _move_window_G102
	CPI  R30,0
	BREQ _0x2040034
	RJMP _0x204002C
_0x2040034:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(2)
	CALL __MULB1W2U
	ANDI R31,HIGH(0x1FF)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,50
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CLR  R22
	CLR  R23
	RJMP _0x2120015
_0x2040033:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x204002C
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 10
	__GETD1N 0x80
	CALL __DIVD21U
	__GETD2S 6
	CALL __ADDD12
	CALL __PUTPARD1
	RCALL _move_window_G102
	CPI  R30,0
	BRNE _0x204002C
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(4)
	CALL __MULB1W2U
	ANDI R31,HIGH(0x1FF)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADIW R26,50
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	__ANDD1N 0xFFFFFFF
	RJMP _0x2120015
_0x204002C:
	__GETD1N 0xFFFFFFFF
_0x2120015:
	CALL __LOADLOCR4
	ADIW R28,14
	RET
_put_fat_G102:
	SBIW R28,4
	CALL __SAVELOCR6
	__GETD2S 14
	__CPD2N 0x2
	BRLO _0x2040038
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,30
	CALL __GETD1P
	__GETD2S 14
	CALL __CPD21
	BRLO _0x2040037
_0x2040038:
	LDI  R21,LOW(2)
	RJMP _0x204003A
_0x2040037:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,34
	CALL __GETD1P
	__PUTD1S 6
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LD   R30,X
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x204003E
	__GETWRS 16,17,14
	MOVW R30,R16
	LSR  R31
	ROR  R30
	__ADDWRR 16,17,30,31
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __ADDD12
	CALL __PUTPARD1
	RCALL _move_window_G102
	MOV  R21,R30
	CPI  R21,0
	BREQ _0x204003F
	RJMP _0x204003D
_0x204003F:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,50
	MOVW R30,R16
	ANDI R31,HIGH(0x1FF)
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
	LDD  R30,Y+14
	ANDI R30,LOW(0x1)
	BREQ _0x2040040
	MOVW R26,R18
	LD   R30,X
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LDD  R30,Y+10
	LDI  R31,0
	CALL __LSLW4
	OR   R30,R26
	RJMP _0x2040041
_0x2040040:
	LDD  R30,Y+10
_0x2040041:
	MOVW R26,R18
	ST   X,R30
	__ADDWRN 16,17,1
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,4
	LDI  R30,LOW(1)
	ST   X,R30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __ADDD12
	CALL __PUTPARD1
	RCALL _move_window_G102
	MOV  R21,R30
	CPI  R21,0
	BREQ _0x2040043
	RJMP _0x204003D
_0x2040043:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,50
	MOVW R30,R16
	ANDI R31,HIGH(0x1FF)
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
	LDD  R30,Y+14
	ANDI R30,LOW(0x1)
	BREQ _0x2040044
	__GETD2S 10
	LDI  R30,LOW(4)
	CALL __LSRD12
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP _0x2040045
_0x2040044:
	MOVW R26,R18
	LD   R30,X
	ANDI R30,LOW(0xF0)
	MOV  R1,R30
	__GETD2S 10
	LDI  R30,LOW(8)
	CALL __LSRD12
	CLR  R31
	CLR  R22
	CLR  R23
	ANDI R30,LOW(0xF)
	OR   R30,R1
_0x2040045:
	MOVW R26,R18
	ST   X,R30
	RJMP _0x204003D
_0x204003E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2040047
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 16
	__GETD1N 0x100
	CALL __DIVD21U
	__GETD2S 8
	CALL __ADDD12
	CALL __PUTPARD1
	RCALL _move_window_G102
	MOV  R21,R30
	CPI  R21,0
	BREQ _0x2040048
	RJMP _0x204003D
_0x2040048:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R30,LOW(2)
	CALL __MULB1W2U
	ANDI R31,HIGH(0x1FF)
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,50
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP _0x204003D
_0x2040047:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x204004B
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 16
	__GETD1N 0x80
	CALL __DIVD21U
	__GETD2S 8
	CALL __ADDD12
	CALL __PUTPARD1
	RCALL _move_window_G102
	MOV  R21,R30
	CPI  R21,0
	BRNE _0x204003D
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R30,LOW(4)
	CALL __MULB1W2U
	ANDI R31,HIGH(0x1FF)
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,50
	ADD  R30,R26
	ADC  R31,R27
	__GETD2S 10
	CALL __PUTDZ20
	RJMP _0x204003D
_0x204004B:
	LDI  R21,LOW(2)
_0x204003D:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,4
	LDI  R30,LOW(1)
	ST   X,R30
_0x204003A:
	MOV  R30,R21
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_remove_chain_G102:
	SBIW R28,4
	ST   -Y,R17
	__GETD2S 5
	__CPD2N 0x2
	BRLO _0x204004D
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,30
	CALL __GETD1P
	__GETD2S 5
	CALL __CPD21
	BRLO _0x204004C
_0x204004D:
	LDI  R17,LOW(2)
	RJMP _0x204004F
_0x204004C:
	LDI  R17,LOW(0)
_0x2040050:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,30
	CALL __GETD1P
	__GETD2S 5
	CALL __CPD21
	BRLO PC+3
	JMP _0x2040052
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 7
	CALL __PUTPARD1
	RCALL _get_fat_G102
	__PUTD1S 1
	CALL __CPD10
	BRNE _0x2040053
	RJMP _0x2040052
_0x2040053:
	__GETD2S 1
	__CPD2N 0x1
	BRNE _0x2040054
	LDI  R17,LOW(2)
	RJMP _0x2040052
_0x2040054:
	__GETD2S 1
	__CPD2N 0xFFFFFFFF
	BRNE _0x2040055
	LDI  R17,LOW(1)
	RJMP _0x2040052
_0x2040055:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 7
	CALL __PUTPARD1
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _put_fat_G102
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2040052
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__GETD2Z 14
	__CPD2N 0xFFFFFFFF
	BREQ _0x2040057
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,14
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADIW R26,9
	LDI  R30,LOW(1)
	ST   X,R30
_0x2040057:
	__GETD1S 1
	__PUTD1S 5
	RJMP _0x2040050
_0x2040052:
_0x204004F:
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,11
	RET
_create_chain_G102:
	SBIW R28,16
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	ADIW R26,30
	CALL __GETD1P
	CALL __PUTD1S0
	__GETD1S 16
	CALL __CPD10
	BRNE _0x2040058
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	ADIW R26,10
	CALL __GETD1P
	__PUTD1S 4
	__GETD2S 4
	CALL __CPD02
	BREQ _0x204005A
	CALL __GETD1S0
	CALL __CPD21
	BRLO _0x2040059
_0x204005A:
	__GETD1N 0x1
	__PUTD1S 4
_0x2040059:
	RJMP _0x204005C
_0x2040058:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 18
	CALL __PUTPARD1
	RCALL _get_fat_G102
	__PUTD1S 12
	__GETD2S 12
	__CPD2N 0x2
	BRSH _0x204005D
	__GETD1N 0x1
	RJMP _0x2120014
_0x204005D:
	CALL __GETD1S0
	__GETD2S 12
	CALL __CPD21
	BRSH _0x204005E
	__GETD1S 12
	RJMP _0x2120014
_0x204005E:
	__GETD1S 16
	__PUTD1S 4
_0x204005C:
	__GETD1S 4
	__PUTD1S 8
_0x2040060:
	__GETD1S 8
	__SUBD1N -1
	__PUTD1S 8
	CALL __GETD1S0
	__GETD2S 8
	CALL __CPD21
	BRLO _0x2040062
	__GETD1N 0x2
	__PUTD1S 8
	__GETD1S 4
	__GETD2S 8
	CALL __CPD12
	BRSH _0x2040063
	__GETD1N 0x0
	RJMP _0x2120014
_0x2040063:
_0x2040062:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 10
	CALL __PUTPARD1
	RCALL _get_fat_G102
	__PUTD1S 12
	CALL __CPD10
	BREQ _0x2040061
	__GETD2S 12
	__CPD2N 0xFFFFFFFF
	BREQ _0x2040066
	__CPD2N 0x1
	BRNE _0x2040065
_0x2040066:
	__GETD1S 12
	RJMP _0x2120014
_0x2040065:
	__GETD1S 4
	__GETD2S 8
	CALL __CPD12
	BRNE _0x2040068
	__GETD1N 0x0
	RJMP _0x2120014
_0x2040068:
	RJMP _0x2040060
_0x2040061:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 10
	CALL __PUTPARD1
	__GETD1N 0xFFFFFFF
	CALL __PUTPARD1
	RCALL _put_fat_G102
	CPI  R30,0
	BREQ _0x2040069
	__GETD1N 0xFFFFFFFF
	RJMP _0x2120014
_0x2040069:
	__GETD1S 16
	CALL __CPD10
	BREQ _0x204006A
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 18
	CALL __PUTPARD1
	__GETD1S 14
	CALL __PUTPARD1
	RCALL _put_fat_G102
	CPI  R30,0
	BREQ _0x204006B
	__GETD1N 0xFFFFFFFF
	RJMP _0x2120014
_0x204006B:
_0x204006A:
	__GETD1S 8
	__PUTD1SNS 20,10
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	__GETD2Z 14
	__CPD2N 0xFFFFFFFF
	BREQ _0x204006C
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	ADIW R26,14
	CALL __GETD1P_INC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL __PUTDP1_DEC
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	ADIW R26,9
	LDI  R30,LOW(1)
	ST   X,R30
_0x204006C:
	__GETD1S 8
_0x2120014:
	ADIW R28,22
	RET
_clust2sect_G102:
	CALL __GETD1S0
	__SUBD1N 2
	CALL __PUTD1S0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__GETD2Z 30
	__GETD1N 0x2
	CALL __SWAPD12
	CALL __SUBD12
	CALL __GETD2S0
	CALL __CPD21
	BRLO _0x204006D
	__GETD1N 0x0
	RJMP _0x212000E
_0x204006D:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,2
	LD   R30,X
	LDI  R31,0
	CALL __GETD2S0
	CALL __CWD1
	CALL __MULD12U
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,42
	CALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	RJMP _0x212000E
_dir_seek_G102:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__PUTW1SNS 8,4
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,6
	CALL __GETD1P
	__PUTD1S 2
	__GETD2S 2
	__CPD2N 0x1
	BREQ _0x204006F
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 2
	CALL __CPD21
	BRLO _0x204006E
_0x204006F:
	LDI  R30,LOW(2)
	RJMP _0x2120012
_0x204006E:
	__GETD1S 2
	CALL __CPD10
	BRNE _0x2040072
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	LD   R26,Z
	CPI  R26,LOW(0x3)
	BREQ _0x2040073
_0x2040072:
	RJMP _0x2040071
_0x2040073:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,38
	MOVW R26,R30
	CALL __GETD1P
	__PUTD1S 2
_0x2040071:
	__GETD1S 2
	CALL __CPD10
	BRNE _0x2040074
	__PUTD1SNS 8,10
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,7
	MOVW R26,R30
	CALL __GETW1P
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x2040075
	LDI  R30,LOW(2)
	RJMP _0x2120012
_0x2040075:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,38
	MOVW R26,R30
	CALL __GETD1P
	RJMP _0x204022A
_0x2040074:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	LDD  R30,Z+2
	LDI  R26,LOW(16)
	MUL  R30,R26
	MOVW R16,R0
_0x2040077:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R16
	CPC  R27,R17
	BRSH PC+3
	JMP _0x2040079
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 4
	CALL __PUTPARD1
	RCALL _get_fat_G102
	__PUTD1S 2
	__GETD2S 2
	__CPD2N 0xFFFFFFFF
	BRNE _0x204007A
	LDI  R30,LOW(1)
	RJMP _0x2120012
_0x204007A:
	__GETD2S 2
	__CPD2N 0x2
	BRLO _0x204007C
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 2
	CALL __CPD21
	BRLO _0x204007B
_0x204007C:
	LDI  R30,LOW(2)
	RJMP _0x2120012
_0x204007B:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUB  R30,R16
	SBC  R31,R17
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040077
_0x2040079:
	__GETD1S 2
	__PUTD1SNS 8,10
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 4
	CALL __PUTPARD1
	RCALL _clust2sect_G102
_0x204022A:
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __LSRW4
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1SNS 8,14
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,50
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	LSL  R30
	CALL __LSLW4
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SNS 8,18
	LDI  R30,LOW(0)
_0x2120012:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2120013:
	ADIW R28,10
	RET
_dir_next_G102:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,4
	CALL __GETW1P
	ADIW R30,1
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x204007F
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,14
	CALL __GETD1P
	CALL __CPD10
	BRNE _0x204007E
_0x204007F:
	LDI  R30,LOW(4)
	RJMP _0x2120011
_0x204007E:
	MOVW R30,R16
	ANDI R30,LOW(0xF)
	BREQ PC+3
	JMP _0x2040081
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,14
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,10
	CALL __GETD1P
	CALL __CPD10
	BRNE _0x2040082
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL __GETW1P
	ADIW R30,7
	MOVW R26,R30
	CALL __GETW1P
	CP   R16,R30
	CPC  R17,R31
	BRLO _0x2040083
	LDI  R30,LOW(4)
	RJMP _0x2120011
_0x2040083:
	RJMP _0x2040084
_0x2040082:
	MOVW R30,R16
	CALL __LSRW4
	MOVW R0,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL __GETW1P
	LDD  R30,Z+2
	LDI  R31,0
	SBIW R30,1
	AND  R30,R0
	AND  R31,R1
	SBIW R30,0
	BREQ PC+3
	JMP _0x2040085
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__GETD2Z 10
	CALL __PUTPARD2
	RCALL _get_fat_G102
	__PUTD1S 2
	__GETD2S 2
	__CPD2N 0x2
	BRSH _0x2040086
	LDI  R30,LOW(2)
	RJMP _0x2120011
_0x2040086:
	__GETD2S 2
	__CPD2N 0xFFFFFFFF
	BRNE _0x2040087
	LDI  R30,LOW(1)
	RJMP _0x2120011
_0x2040087:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL __GETW1P
	ADIW R30,30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 2
	CALL __CPD21
	BRSH PC+3
	JMP _0x2040088
	SBIW R28,1
	LDD  R30,Y+7
	CPI  R30,0
	BRNE _0x2040089
	LDI  R30,LOW(4)
	ADIW R28,1
	RJMP _0x2120011
_0x2040089:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	__GETD2Z 10
	CALL __PUTPARD2
	RCALL _create_chain_G102
	__PUTD1S 3
	CALL __CPD10
	BRNE _0x204008A
	LDI  R30,LOW(7)
	ADIW R28,1
	RJMP _0x2120011
_0x204008A:
	__GETD2S 3
	__CPD2N 0x1
	BRNE _0x204008B
	LDI  R30,LOW(2)
	ADIW R28,1
	RJMP _0x2120011
_0x204008B:
	__GETD2S 3
	__CPD2N 0xFFFFFFFF
	BRNE _0x204008C
	LDI  R30,LOW(1)
	ADIW R28,1
	RJMP _0x2120011
_0x204008C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _move_window_G102
	CPI  R30,0
	BREQ _0x204008D
	LDI  R30,LOW(1)
	ADIW R28,1
	RJMP _0x2120011
_0x204008D:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _mem_set_G102
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	MOVW R26,R30
	ADIW R30,46
	PUSH R31
	PUSH R30
	MOVW R30,R26
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 5
	CALL __PUTPARD1
	RCALL _clust2sect_G102
	POP  R26
	POP  R27
	CALL __PUTDP1
	LDI  R30,LOW(0)
	ST   Y,R30
_0x204008F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	LDD  R30,Z+2
	LD   R26,Y
	CP   R26,R30
	BRSH _0x2040090
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,4
	LDI  R26,LOW(1)
	STD  Z+0,R26
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL _move_window_G102
	CPI  R30,0
	BREQ _0x2040091
	LDI  R30,LOW(1)
	ADIW R28,1
	RJMP _0x2120011
_0x2040091:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,46
	MOVW R26,R30
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x204008F
_0x2040090:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,46
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LD   R30,Y
	LDI  R31,0
	CALL __CWD1
	CALL __SWAPD12
	CALL __SUBD12
	POP  R26
	POP  R27
	CALL __PUTDP1
	ADIW R28,1
_0x2040088:
	__GETD1S 2
	__PUTD1SNS 7,10
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 4
	CALL __PUTPARD1
	RCALL _clust2sect_G102
	__PUTD1SNS 7,14
_0x2040085:
_0x2040084:
_0x2040081:
	MOVW R30,R16
	__PUTW1SNS 7,4
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL __GETW1P
	ADIW R30,50
	MOVW R26,R30
	MOVW R30,R16
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	LSL  R30
	CALL __LSLW4
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SNS 7,18
	LDI  R30,LOW(0)
_0x2120011:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,9
	RET
_dir_find_G102:
	CALL __SAVELOCR4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _dir_seek_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2040092
	MOV  R30,R17
	CALL __LOADLOCR4
	RJMP _0x212000E
_0x2040092:
_0x2040094:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 14
	CALL __PUTPARD2
	CALL _move_window_G102
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2040095
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,18
	LD   R18,X+
	LD   R19,X
	MOVW R26,R18
	LD   R16,X
	CPI  R16,0
	BRNE _0x2040097
	LDI  R17,LOW(4)
	RJMP _0x2040095
_0x2040097:
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x8)
	BRNE _0x2040099
	ST   -Y,R19
	ST   -Y,R18
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+20
	LDD  R27,Z+21
	ST   -Y,R27
	ST   -Y,R26
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	CALL _mem_cmp_G102
	SBIW R30,0
	BREQ _0x204009A
_0x2040099:
	RJMP _0x2040098
_0x204009A:
	RJMP _0x2040095
_0x2040098:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _dir_next_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2040094
_0x2040095:
	MOV  R30,R17
	CALL __LOADLOCR4
	RJMP _0x212000E
_dir_register_G102:
	CALL __SAVELOCR4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _dir_seek_G102
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x20400A7
_0x20400A9:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 14
	CALL __PUTPARD2
	CALL _move_window_G102
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x20400AA
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Z+18
	LDD  R27,Z+19
	LD   R16,X
	CPI  R16,229
	BREQ _0x20400AD
	CPI  R16,0
	BRNE _0x20400AC
_0x20400AD:
	RJMP _0x20400AA
_0x20400AC:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _dir_next_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x20400A9
_0x20400AA:
_0x20400A7:
	CPI  R17,0
	BREQ PC+3
	JMP _0x20400AF
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 14
	CALL __PUTPARD2
	CALL _move_window_G102
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x20400B0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,18
	LD   R18,X+
	LD   R19,X
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	CALL _mem_set_G102
	ST   -Y,R19
	ST   -Y,R18
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+20
	LDD  R27,Z+21
	ST   -Y,R27
	ST   -Y,R26
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	CALL _mem_cpy_G102
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,20
	CALL __GETW1P
	LDD  R30,Z+11
	ANDI R30,LOW(0x18)
	__PUTB1RNS 18,12
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	ADIW R30,4
	LDI  R26,LOW(1)
	STD  Z+0,R26
_0x20400B0:
_0x20400AF:
	MOV  R30,R17
	CALL __LOADLOCR4
	RJMP _0x212000E
_create_name_G102:
	SBIW R28,8
	CALL __SAVELOCR6
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,20
	LD   R20,X+
	LD   R21,X
	ST   -Y,R21
	ST   -Y,R20
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	CALL _mem_set_G102
	LDI  R30,LOW(0)
	MOV  R17,R30
	LDI  R31,0
	STD  Y+8,R30
	STD  Y+8+1,R31
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STD  Y+12,R30
	STD  Y+12+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x20400B3
_0x20400B5:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X
	CPI  R16,46
	BRNE _0x20400B8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,3
	BRLT _0x20400B7
_0x20400B8:
	RJMP _0x20400B6
_0x20400B7:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	ADD  R30,R20
	ADC  R31,R21
	ST   Z,R16
	RJMP _0x20400B5
_0x20400B6:
	CPI  R16,47
	BREQ _0x20400BB
	CPI  R16,92
	BREQ _0x20400BB
	CPI  R16,32
	BRSH _0x20400BC
_0x20400BB:
	RJMP _0x20400BA
_0x20400BC:
	LDI  R30,LOW(6)
	RJMP _0x212000F
_0x20400BA:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ST   X+,R30
	ST   X,R31
	CPI  R16,32
	BRSH _0x20400BD
	LDI  R30,LOW(36)
	RJMP _0x20400BE
_0x20400BD:
	LDI  R30,LOW(32)
_0x20400BE:
	__PUTB1RNS 20,11
	RJMP _0x2120010
_0x20400B3:
_0x20400C1:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X
	CPI  R16,32
	BRLO _0x20400C4
	CPI  R16,47
	BREQ _0x20400C4
	CPI  R16,92
	BRNE _0x20400C3
_0x20400C4:
	RJMP _0x20400C2
_0x20400C3:
	CPI  R16,46
	BREQ _0x20400C7
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x20400C6
_0x20400C7:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,8
	BRNE _0x20400CA
	CPI  R16,46
	BREQ _0x20400C9
_0x20400CA:
	LDI  R30,LOW(6)
	RJMP _0x212000F
_0x20400C9:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STD  Y+12,R30
	STD  Y+12+1,R31
	LSL  R17
	LSL  R17
	RJMP _0x20400C0
_0x20400C6:
	CPI  R16,128
	BRLO _0x20400CC
	ORI  R17,LOW(3)
	LDI  R30,LOW(6)
	RJMP _0x212000F
_0x20400CC:
	LDI  R30,LOW(_k1*2)
	LDI  R31,HIGH(_k1*2)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _chk_chrf_G102
	SBIW R30,0
	BREQ _0x20400D2
	LDI  R30,LOW(6)
	RJMP _0x212000F
_0x20400D2:
	CPI  R16,65
	BRLO _0x20400D4
	CPI  R16,91
	BRLO _0x20400D5
_0x20400D4:
	RJMP _0x20400D3
_0x20400D5:
	ORI  R17,LOW(2)
	RJMP _0x20400D6
_0x20400D3:
	CPI  R16,97
	BRLO _0x20400D8
	CPI  R16,123
	BRLO _0x20400D9
_0x20400D8:
	RJMP _0x20400D7
_0x20400D9:
	ORI  R17,LOW(1)
	MOV  R30,R16
	LDI  R31,0
	SBIW R30,32
	MOV  R16,R30
_0x20400D7:
_0x20400D6:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	ADD  R30,R20
	ADC  R31,R21
	ST   Z,R16
_0x20400C0:
	RJMP _0x20400C1
_0x20400C2:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ST   X+,R30
	ST   X,R31
	CPI  R16,32
	BRSH _0x20400DA
	LDI  R30,LOW(4)
	RJMP _0x20400DB
_0x20400DA:
	LDI  R30,LOW(0)
_0x20400DB:
	MOV  R16,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x20400DD
	LDI  R30,LOW(6)
	RJMP _0x212000F
_0x20400DD:
	MOVW R26,R20
	LD   R26,X
	CPI  R26,LOW(0xE5)
	BRNE _0x20400DE
	MOVW R26,R20
	LDI  R30,LOW(5)
	ST   X,R30
_0x20400DE:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,8
	BRNE _0x20400DF
	LSL  R17
	LSL  R17
_0x20400DF:
	MOV  R30,R17
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x1)
	BRNE _0x20400E0
	ORI  R16,LOW(16)
_0x20400E0:
	MOV  R30,R17
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0x4)
	BRNE _0x20400E1
	ORI  R16,LOW(8)
_0x20400E1:
	MOVW R30,R20
	__PUTBZR 16,11
_0x2120010:
	LDI  R30,LOW(0)
_0x212000F:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
_follow_path_G102:
	CALL __SAVELOCR4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	CPI  R26,LOW(0x2F)
	BREQ _0x20400F8
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	CPI  R26,LOW(0x5C)
	BRNE _0x20400F7
_0x20400F8:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,6
	__GETD1N 0x0
	CALL __PUTDP1
	RJMP _0x20400FA
_0x20400F7:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	ADIW R30,22
	MOVW R26,R30
	CALL __GETD1P
	__PUTD1SNS 6,6
_0x20400FA:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	CLR  R27
	SBIW R26,32
	BRSH _0x20400FB
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _dir_seek_G102
	MOV  R17,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RJMP _0x20400FC
_0x20400FB:
_0x20400FE:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	RCALL _create_name_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2040100
	RJMP _0x20400FF
_0x2040100:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _dir_find_G102
	MOV  R17,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	CALL __GETW1P
	LDD  R30,Z+11
	ANDI R30,LOW(0x4)
	MOV  R16,R30
	CPI  R17,0
	BREQ _0x2040101
	CPI  R17,4
	BRNE _0x2040103
	CPI  R16,0
	BREQ _0x2040104
_0x2040103:
	RJMP _0x2040102
_0x2040104:
	LDI  R17,LOW(5)
_0x2040102:
	RJMP _0x20400FF
_0x2040101:
	CPI  R16,0
	BRNE _0x20400FF
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,18
	LD   R18,X+
	LD   R19,X
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x10)
	BRNE _0x2040106
	LDI  R17,LOW(5)
	RJMP _0x20400FF
_0x2040106:
	MOVW R26,R18
	ADIW R26,20
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL __LSLD16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R26,R18
	ADIW R26,26
	CALL __GETW1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1SNS 6,6
	RJMP _0x20400FE
_0x20400FF:
_0x20400FC:
	MOV  R30,R17
	CALL __LOADLOCR4
	ADIW R28,8
	RET
_check_fs_G102:

	.DSEG

	.CSEG
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 3
	CALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _disk_read
	CPI  R30,0
	BREQ _0x2040108
	LDI  R30,LOW(3)
	RJMP _0x212000E
_0x2040108:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,50
	SUBI R30,LOW(-510)
	SBCI R31,HIGH(-510)
	MOVW R26,R30
	CALL __GETW1P
	CPI  R30,LOW(0xAA55)
	LDI  R26,HIGH(0xAA55)
	CPC  R31,R26
	BREQ _0x2040109
	LDI  R30,LOW(2)
	RJMP _0x212000E
_0x2040109:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-104)
	SBCI R31,HIGH(-104)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_fatstr_S1020016000)
	LDI  R31,HIGH(_fatstr_S1020016000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _mem_cmp_G102
	SBIW R30,0
	BRNE _0x204010A
	LDI  R30,LOW(0)
	RJMP _0x212000E
_0x204010A:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,50
	SUBI R30,LOW(-82)
	SBCI R31,HIGH(-82)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_fatstr_S1020016000)
	LDI  R31,HIGH(_fatstr_S1020016000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _mem_cmp_G102
	SBIW R30,0
	BRNE _0x204010C
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-90)
	SBCI R31,HIGH(-90)
	LD   R30,Z
	ANDI R30,LOW(0x80)
	BREQ _0x204010D
_0x204010C:
	RJMP _0x204010B
_0x204010D:
	LDI  R30,LOW(0)
	RJMP _0x212000E
_0x204010B:
	LDI  R30,LOW(1)
_0x212000E:
	ADIW R28,6
	RET
_auto_mount_G102:
	SBIW R28,21
	CALL __SAVELOCR6
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CALL __GETW1P
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
	MOVW R20,R30
	__CPWRN 20,21,10
	BRSH _0x204010F
	ADIW R26,1
	LD   R26,X
	CPI  R26,LOW(0x3A)
	BREQ _0x2040110
_0x204010F:
	RJMP _0x204010E
_0x2040110:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,2
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	ST   X+,R30
	ST   X,R31
	RJMP _0x2040111
_0x204010E:
	LDS  R20,_Drive_G102
	CLR  R21
_0x2040111:
	__CPWRN 20,21,1
	BRLO _0x2040112
	LDI  R30,LOW(11)
	RJMP _0x212000D
_0x2040112:
	MOVW R30,R20
	LDI  R26,LOW(_FatFs_G102)
	LDI  R27,HIGH(_FatFs_G102)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	ST   X+,R30
	ST   X,R31
	SBIW R30,0
	BRNE _0x2040113
	LDI  R30,LOW(12)
	RJMP _0x212000D
_0x2040113:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x2040114
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+1
	ST   -Y,R26
	CALL _disk_status
	STD  Y+26,R30
	ANDI R30,LOW(0x1)
	BRNE _0x2040115
	LDD  R30,Y+27
	CPI  R30,0
	BREQ _0x2040117
	LDD  R30,Y+26
	ANDI R30,LOW(0x4)
	BRNE _0x2040118
_0x2040117:
	RJMP _0x2040116
_0x2040118:
	LDI  R30,LOW(10)
	RJMP _0x212000D
_0x2040116:
	LDI  R30,LOW(0)
	RJMP _0x212000D
_0x2040115:
_0x2040114:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOV  R30,R20
	__PUTB1SNS 6,1
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+1
	ST   -Y,R26
	CALL _disk_initialize
	STD  Y+26,R30
	ANDI R30,LOW(0x1)
	BREQ _0x2040119
	LDI  R30,LOW(3)
	RJMP _0x212000D
_0x2040119:
	LDD  R30,Y+27
	CPI  R30,0
	BREQ _0x204011B
	LDD  R30,Y+26
	ANDI R30,LOW(0x4)
	BRNE _0x204011C
_0x204011B:
	RJMP _0x204011A
_0x204011C:
	LDI  R30,LOW(10)
	RJMP _0x212000D
_0x204011A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	__PUTD1S 24
	CALL __PUTPARD1
	RCALL _check_fs_G102
	MOV  R16,R30
	CPI  R16,1
	BRNE _0x204011D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,50
	SUBI R30,LOW(-446)
	SBCI R31,HIGH(-446)
	MOVW R18,R30
	MOVW R30,R18
	LDD  R30,Z+4
	CPI  R30,0
	BREQ _0x204011E
	MOVW R26,R18
	ADIW R26,8
	CALL __GETD1P
	__PUTD1S 22
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 24
	CALL __PUTPARD1
	RCALL _check_fs_G102
	MOV  R16,R30
_0x204011E:
_0x204011D:
	CPI  R16,3
	BRNE _0x204011F
	LDI  R30,LOW(1)
	RJMP _0x212000D
_0x204011F:
	CPI  R16,0
	BRNE _0x2040121
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,61
	CALL __GETW1P
	CPI  R30,LOW(0x200)
	LDI  R26,HIGH(0x200)
	CPC  R31,R26
	BREQ _0x2040120
_0x2040121:
	LDI  R30,LOW(13)
	RJMP _0x212000D
_0x2040120:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-72)
	SBCI R27,HIGH(-72)
	CALL __GETW1P
	CLR  R22
	CLR  R23
	__PUTD1S 18
	CALL __CPD10
	BRNE _0x2040123
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-86)
	SBCI R27,HIGH(-86)
	CALL __GETD1P
	__PUTD1S 18
_0x2040123:
	__GETD1S 18
	__PUTD1SNS 6,26
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-66)
	SBCI R31,HIGH(-66)
	LD   R30,Z
	__PUTB1SNS 6,3
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,3
	LD   R30,X
	LDI  R31,0
	__GETD2S 18
	CALL __CWD1
	CALL __MULD12U
	__PUTD1S 18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-64)
	SBCI R27,HIGH(-64)
	CALL __GETW1P
	__GETD2S 22
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1SNS 6,34
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R30,Z+63
	__PUTB1SNS 6,2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-67)
	SBCI R27,HIGH(-67)
	CALL __GETW1P
	__PUTW1SNS 6,7
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-69)
	SBCI R27,HIGH(-69)
	CALL __GETW1P
	CLR  R22
	CLR  R23
	__PUTD1S 14
	CALL __CPD10
	BRNE _0x2040124
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-82)
	SBCI R27,HIGH(-82)
	CALL __GETD1P
	__PUTD1S 14
_0x2040124:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-64)
	SBCI R27,HIGH(-64)
	CALL __GETW1P
	__GETD2S 14
	CLR  R22
	CLR  R23
	CALL __SWAPD12
	CALL __SUBD12
	__GETD2S 18
	CALL __SUBD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+7
	LDD  R27,Z+8
	MOVW R30,R26
	CALL __LSRW4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __SWAPD12
	CALL __SUBD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,2
	LD   R30,X
	LDI  R31,0
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CWD1
	CALL __DIVD21U
	__ADDD1N 2
	__PUTD1S 10
	__PUTD1SNS 6,30
	LDI  R16,LOW(1)
	__GETD2S 10
	__CPD2N 0xFF7
	BRLO _0x2040125
	LDI  R16,LOW(2)
_0x2040125:
	__GETD2S 10
	__CPD2N 0xFFF7
	BRLO _0x2040126
	LDI  R16,LOW(3)
_0x2040126:
	CPI  R16,3
	BRNE _0x2040127
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-94)
	SBCI R27,HIGH(-94)
	CALL __GETD1P
	RJMP _0x204022B
_0x2040127:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 34
	__GETD1S 18
	CALL __ADDD12
_0x204022B:
	__PUTD1SNS 6,38
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__GETD2Z 34
	__GETD1S 18
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+7
	LDD  R27,Z+8
	MOVW R30,R26
	CALL __LSRW4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1SNS 6,42
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,14
	__GETD1N 0xFFFFFFFF
	CALL __PUTDP1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
	CPI  R16,3
	BREQ PC+3
	JMP _0x2040129
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,9
	ST   X,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-98)
	SBCI R27,HIGH(-98)
	CALL __GETW1P
	__GETD2S 22
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1SNS 6,18
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+1
	ST   -Y,R26
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__GETD2Z 18
	CALL __PUTPARD2
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _disk_read
	CPI  R30,0
	BRNE _0x204012B
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,50
	SUBI R30,LOW(-510)
	SBCI R31,HIGH(-510)
	MOVW R26,R30
	CALL __GETW1P
	CPI  R30,LOW(0xAA55)
	LDI  R26,HIGH(0xAA55)
	CPC  R31,R26
	BRNE _0x204012B
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,50
	CALL __GETD1P
	__CPD1N 0x41615252
	BRNE _0x204012B
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,50
	SUBI R30,LOW(-484)
	SBCI R31,HIGH(-484)
	MOVW R26,R30
	CALL __GETD1P
	__CPD1N 0x61417272
	BREQ _0x204012C
_0x204012B:
	RJMP _0x204012A
_0x204012C:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,50
	SUBI R30,LOW(-492)
	SBCI R31,HIGH(-492)
	MOVW R26,R30
	CALL __GETD1P
	__PUTD1SNS 6,10
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,50
	SUBI R30,LOW(-488)
	SBCI R31,HIGH(-488)
	MOVW R26,R30
	CALL __GETD1P
	__PUTD1SNS 6,14
_0x204012A:
_0x2040129:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R16
	ADIW R26,46
	__GETD1N 0x0
	CALL __PUTDP1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,22
	CALL __PUTDP1
	LDI  R26,LOW(_Fsid_G102)
	LDI  R27,HIGH(_Fsid_G102)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	__PUTW1SNS 6,5
	LDI  R17,LOW(0)
	MOV  R30,R17
_0x212000D:
	CALL __LOADLOCR6
	ADIW R28,32
	RET
_validate_G102:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BREQ _0x204012E
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x204012E
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Z+5
	LDD  R27,Z+6
	LD   R30,Y
	LDD  R31,Y+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x204012D
_0x204012E:
	LDI  R30,LOW(9)
	RJMP _0x212000C
_0x204012D:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Z+1
	ST   -Y,R26
	CALL _disk_status
	ANDI R30,LOW(0x1)
	BREQ _0x2040130
	LDI  R30,LOW(3)
	RJMP _0x212000C
_0x2040130:
	LDI  R30,LOW(0)
_0x212000C:
	ADIW R28,4
	RET
_f_mount:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRLO _0x2040131
	LDI  R30,LOW(11)
	JMP  _0x2120008
_0x2040131:
	LDD  R30,Y+4
	LDI  R26,LOW(_FatFs_G102)
	LDI  R27,HIGH(_FatFs_G102)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X+
	LD   R17,X
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x2040132
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
_0x2040132:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BREQ _0x2040133
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2040133:
	LDD  R30,Y+4
	LDI  R26,LOW(_FatFs_G102)
	LDI  R27,HIGH(_FatFs_G102)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	STD  Z+0,R26
	STD  Z+1,R27
	LDI  R30,LOW(0)
	JMP  _0x2120008
_f_open:
	SBIW R28,34
	CALL __SAVELOCR4
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LDD  R30,Y+38
	ANDI R30,LOW(0x1F)
	STD  Y+38,R30
	MOVW R30,R28
	ADIW R30,39
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,18
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+42
	ANDI R30,LOW(0x1E)
	ST   -Y,R30
	RCALL _auto_mount_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2040134
	MOV  R30,R17
	RJMP _0x212000B
_0x2040134:
	MOVW R30,R28
	ADIW R30,4
	STD  Y+36,R30
	STD  Y+36+1,R31
	MOVW R30,R28
	ADIW R30,16
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+41
	LDD  R31,Y+41+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _follow_path_G102
	MOV  R17,R30
	LDD  R30,Y+38
	ANDI R30,LOW(0x1C)
	BRNE PC+3
	JMP _0x2040135
	SBIW R28,8
	CPI  R17,0
	BREQ _0x2040136
	CPI  R17,4
	BRNE _0x2040137
	MOVW R30,R28
	ADIW R30,24
	ST   -Y,R31
	ST   -Y,R30
	RCALL _dir_register_G102
	MOV  R17,R30
_0x2040137:
	CPI  R17,0
	BREQ _0x2040138
	MOV  R30,R17
	ADIW R28,8
	RJMP _0x212000B
_0x2040138:
	LDD  R30,Y+46
	ORI  R30,8
	STD  Y+46,R30
	__GETWRS 18,19,42
	RJMP _0x2040139
_0x2040136:
	LDD  R30,Y+46
	ANDI R30,LOW(0x4)
	BREQ _0x204013A
	LDI  R30,LOW(8)
	ADIW R28,8
	RJMP _0x212000B
_0x204013A:
	__GETWRS 18,19,42
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x204013C
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x11)
	BREQ _0x204013B
_0x204013C:
	LDI  R30,LOW(7)
	ADIW R28,8
	RJMP _0x212000B
_0x204013B:
	LDD  R30,Y+46
	ANDI R30,LOW(0x8)
	BRNE PC+3
	JMP _0x204013E
	MOVW R26,R18
	ADIW R26,20
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL __LSLD16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R26,R18
	ADIW R26,26
	CALL __GETW1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __ORD12
	CALL __PUTD1S0
	MOVW R30,R18
	ADIW R30,20
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	MOVW R30,R18
	ADIW R30,26
	STD  Z+0,R26
	STD  Z+1,R27
	MOVW R30,R18
	ADIW R30,28
	__GETD2N 0x0
	CALL __PUTDZ20
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ADIW R26,4
	LDI  R30,LOW(1)
	ST   X,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ADIW R26,46
	CALL __GETD1P
	__PUTD1S 4
	CALL __GETD1S0
	CALL __CPD10
	BREQ _0x204013F
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 2
	CALL __PUTPARD1
	CALL _remove_chain_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2040140
	MOV  R30,R17
	ADIW R28,8
	RJMP _0x212000B
_0x2040140:
	CALL __GETD1S0
	__SUBD1N 1
	__PUTD1SNS 24,10
_0x204013F:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 6
	CALL __PUTPARD1
	CALL _move_window_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2040141
	MOV  R30,R17
	ADIW R28,8
	RJMP _0x212000B
_0x2040141:
_0x204013E:
_0x2040139:
	LDD  R30,Y+46
	ANDI R30,LOW(0x8)
	BREQ _0x2040142
	MOVW R30,R18
	ADIW R30,11
	LDI  R26,LOW(0)
	STD  Z+0,R26
	CALL _get_fattime
	__PUTD1S 4
	__PUTD1RNS 18,14
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ADIW R26,4
	LDI  R30,LOW(1)
	ST   X,R30
	LDD  R30,Y+46
	ORI  R30,0x20
	STD  Y+46,R30
_0x2040142:
	ADIW R28,8
	RJMP _0x2040143
_0x2040135:
	CPI  R17,0
	BREQ _0x2040144
	MOV  R30,R17
	RJMP _0x212000B
_0x2040144:
	__GETWRS 18,19,34
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x2040146
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x10)
	BREQ _0x2040145
_0x2040146:
	LDI  R30,LOW(4)
	RJMP _0x212000B
_0x2040145:
	LDD  R30,Y+38
	ANDI R30,LOW(0x2)
	BREQ _0x2040149
	MOVW R30,R18
	LDD  R30,Z+11
	ANDI R30,LOW(0x1)
	BRNE _0x204014A
_0x2040149:
	RJMP _0x2040148
_0x204014A:
	LDI  R30,LOW(7)
	RJMP _0x212000B
_0x2040148:
_0x2040143:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,46
	CALL __GETD1P
	__PUTD1SNS 41,26
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	__PUTW1SNS 41,30
	LDD  R30,Y+38
	__PUTB1SNS 41,4
	MOVW R26,R18
	ADIW R26,20
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL __LSLD16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R26,R18
	ADIW R26,26
	CALL __GETW1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1SNS 41,14
	MOVW R26,R18
	ADIW R26,28
	CALL __GETD1P
	__PUTD1SNS 41,10
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	ADIW R26,6
	__GETD1N 0x0
	CALL __PUTDP1
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	ADIW R26,5
	LDI  R30,LOW(255)
	ST   X,R30
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	ADIW R26,22
	__GETD1N 0x0
	CALL __PUTDP1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Y+41
	LDD  R27,Y+41+1
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,5
	CALL __GETW1P
	__PUTW1SNS 41,2
	LDI  R30,LOW(0)
_0x212000B:
	CALL __LOADLOCR4
	ADIW R28,43
	RET
_f_write:
	SBIW R28,10
	CALL __SAVELOCR6
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	ST   -Y,R27
	ST   -Y,R26
	RCALL _validate_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2040165
	MOV  R30,R17
	RJMP _0x212000A
_0x2040165:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x80)
	BREQ _0x2040166
	LDI  R30,LOW(2)
	RJMP _0x212000A
_0x2040166:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x2)
	BRNE _0x2040167
	LDI  R30,LOW(7)
	RJMP _0x212000A
_0x2040167:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__GETD2Z 10
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	CLR  R22
	CLR  R23
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,10
	CALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD21
	BRSH _0x2040168
	LDI  R30,LOW(0)
	STD  Y+18,R30
	STD  Y+18+1,R30
_0x2040168:
_0x204016A:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x204016B
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__GETD2Z 6
	MOVW R30,R26
	MOVW R22,R24
	ANDI R31,HIGH(0x1FF)
	SBIW R30,0
	BREQ PC+3
	JMP _0x204016C
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDD  R0,Z+5
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETW1P
	LDD  R30,Z+2
	CP   R0,R30
	BRSH PC+3
	JMP _0x204016D
	ADIW R26,6
	CALL __GETD1P
	CALL __CPD10
	BRNE _0x204016E
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,14
	CALL __GETD1P
	__PUTD1S 12
	CALL __CPD10
	BRNE _0x204016F
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _create_chain_G102
	__PUTD1S 12
	__PUTD1SNS 22,14
_0x204016F:
	RJMP _0x2040170
_0x204016E:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	__GETD2Z 18
	CALL __PUTPARD2
	CALL _create_chain_G102
	__PUTD1S 12
_0x2040170:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x2040171
	RJMP _0x204016B
_0x2040171:
	__GETD2S 12
	__CPD2N 0x1
	BRNE _0x2040172
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(2)
	RJMP _0x212000A
_0x2040172:
	__GETD2S 12
	__CPD2N 0xFFFFFFFF
	BRNE _0x2040173
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x212000A
_0x2040173:
	__GETD1S 12
	__PUTD1SNS 22,18
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,5
	LDI  R30,LOW(0)
	ST   X,R30
_0x204016D:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x40)
	BREQ _0x2040174
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETW1P
	LDD  R30,Z+1
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+25
	LDD  R31,Y+25+1
	__GETD2Z 22
	CALL __PUTPARD2
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _disk_write
	CPI  R30,0
	BREQ _0x2040175
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x212000A
_0x2040175:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X
	ANDI R30,0xBF
	ST   X,R30
_0x2040174:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	__GETD2Z 18
	CALL __PUTPARD2
	CALL _clust2sect_G102
	__PUTD1S 8
	CALL __CPD10
	BRNE _0x2040176
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(2)
	RJMP _0x212000A
_0x2040176:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,5
	LD   R30,X
	LDI  R31,0
	__GETD2S 8
	CALL __CWD1
	CALL __ADDD12
	__PUTD1S 8
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL __DIVW21U
	MOVW R20,R30
	MOV  R0,R20
	OR   R0,R21
	BRNE PC+3
	JMP _0x2040177
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,5
	LD   R30,X
	LDI  R31,0
	ADD  R30,R20
	ADC  R31,R21
	MOVW R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETW1P
	LDD  R30,Z+2
	MOVW R26,R0
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x2040178
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETW1P
	LDD  R0,Z+2
	CLR  R1
	ADIW R26,5
	LD   R30,X
	LDI  R31,0
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
_0x2040178:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETW1P
	LDD  R30,Z+1
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 11
	CALL __PUTPARD1
	ST   -Y,R20
	CALL _disk_write
	CPI  R30,0
	BREQ _0x2040179
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x212000A
_0x2040179:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__GETD2Z 22
	__GETD1S 8
	CALL __SUBD21
	MOVW R30,R20
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRSH _0x204017A
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	__GETD2Z 22
	__GETD1S 10
	CALL __SUBD21
	__GETD1N 0x200
	CALL __MULD12U
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CLR  R24
	CLR  R25
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	ST   -Y,R31
	ST   -Y,R30
	CALL _mem_cpy_G102
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X
	ANDI R30,0xBF
	ST   X,R30
_0x204017A:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,5
	LD   R30,X
	ADD  R30,R20
	ST   X,R30
	MOVW R30,R20
	LSL  R30
	ROL  R31
	MOV  R31,R30
	LDI  R30,0
	MOVW R18,R30
	RJMP _0x2040169
_0x2040177:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__GETD2Z 22
	__GETD1S 8
	CALL __CPD12
	BREQ _0x204017B
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__GETD2Z 6
	MOVW R0,R26
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,10
	CALL __GETD1P
	MOVW R26,R0
	CALL __CPD21
	BRSH _0x204017D
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL __GETW1P
	LDD  R30,Z+1
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 11
	CALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _disk_read
	CPI  R30,0
	BRNE _0x204017E
_0x204017D:
	RJMP _0x204017C
_0x204017E:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x80
	ST   X,R30
	LDI  R30,LOW(1)
	RJMP _0x212000A
_0x204017C:
_0x204017B:
	__GETD1S 8
	__PUTD1SNS 22,22
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,5
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
_0x204016C:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__GETD2Z 6
	MOVW R30,R26
	MOVW R22,R24
	__ANDD1N 0x1FF
	__GETD2N 0x200
	CALL __SWAPD12
	CALL __SUBD12
	MOVW R18,R30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	CP   R30,R18
	CPC  R31,R19
	BRSH _0x204017F
	__GETWRS 18,19,18
_0x204017F:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,32
	MOVW R0,R30
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__GETD2Z 6
	MOVW R30,R26
	MOVW R22,R24
	__ANDD1N 0x1FF
	ADD  R30,R0
	ADC  R31,R1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	CALL _mem_cpy_G102
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x40
	ST   X,R30
_0x2040169:
	MOVW R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,6
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R18
	CLR  R22
	CLR  R23
	CALL __ADDD12
	MOVW R26,R0
	CALL __PUTDP1
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X+
	LD   R31,X+
	ADD  R30,R18
	ADC  R31,R19
	ST   -X,R31
	ST   -X,R30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	SUB  R30,R18
	SBC  R31,R19
	STD  Y+18,R30
	STD  Y+18+1,R31
	RJMP _0x204016A
_0x204016B:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	__GETD2Z 6
	MOVW R0,R26
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,10
	CALL __GETD1P
	MOVW R26,R0
	CALL __CPD12
	BRSH _0x2040180
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,6
	CALL __GETD1P
	__PUTD1SNS 22,10
_0x2040180:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	LD   R30,X
	ORI  R30,0x20
	ST   X,R30
	LDI  R30,LOW(0)
_0x212000A:
	CALL __LOADLOCR6
	ADIW R28,24
	RET
_f_sync:
	SBIW R28,4
	CALL __SAVELOCR4
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	ST   -Y,R27
	ST   -Y,R26
	RCALL _validate_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ PC+3
	JMP _0x2040181
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Z+4
	ANDI R26,LOW(0x20)
	BRNE PC+3
	JMP _0x2040182
	LDD  R26,Z+4
	ANDI R26,LOW(0x40)
	BREQ _0x2040183
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	LDD  R30,Z+1
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 22
	CALL __PUTPARD2
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _disk_write
	CPI  R30,0
	BREQ _0x2040184
	LDI  R30,LOW(1)
	RJMP _0x2120009
_0x2040184:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,4
	LD   R30,X
	ANDI R30,0xBF
	ST   X,R30
_0x2040183:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	__GETD2Z 26
	CALL __PUTPARD2
	CALL _move_window_G102
	MOV  R17,R30
	CPI  R17,0
	BREQ PC+3
	JMP _0x2040185
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,30
	LD   R18,X+
	LD   R19,X
	MOVW R26,R18
	ADIW R26,11
	LD   R30,X
	ORI  R30,0x20
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,10
	CALL __GETD1P
	__PUTD1RNS 18,28
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,14
	CALL __GETW1P
	__PUTW1RNS 18,26
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__GETD2Z 14
	MOVW R30,R26
	MOVW R22,R24
	CALL __LSRD16
	__PUTW1RNS 18,20
	CALL _get_fattime
	__PUTD1S 4
	__PUTD1RNS 18,22
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,4
	LD   R30,X
	ANDI R30,0xDF
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ADIW R30,4
	LDI  R26,LOW(1)
	STD  Z+0,R26
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	CALL _sync_G102
	MOV  R17,R30
_0x2040185:
_0x2040182:
_0x2040181:
	MOV  R30,R17
_0x2120009:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
_f_close:
	ST   -Y,R17
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _f_sync
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2040186
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040186:
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2120004
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_getchar:
_0x2060003:
	LDS  R30,200
	ANDI R30,LOW(0x80)
	BREQ _0x2060003
	LDS  R30,206
	RET
_putchar:
_0x2060006:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x2060006
	LD   R30,Y
	STS  206,R30
	JMP  _0x2120005
_put_buff_G103:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x206002D
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x206002F
	__CPWRN 16,17,2
	BRLO _0x2060030
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x206002F:
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
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060031
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2060031:
_0x2060030:
	RJMP _0x2060032
_0x206002D:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060032:
_0x2120008:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__ftoe_G103:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x206003A
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2060000,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x2120007
_0x206003A:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2060039
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2060000,1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcpyf
	RJMP _0x2120007
_0x2060039:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x206003C
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x206003C:
	LDD  R17,Y+11
_0x206003D:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x206003F
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RJMP _0x206003D
_0x206003F:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x2060040
	LDI  R19,LOW(0)
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RJMP _0x2060041
_0x2060040:
	LDD  R19,Y+11
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2060042
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
_0x2060043:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRLO _0x2060045
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RJMP _0x2060043
_0x2060045:
	RJMP _0x2060046
_0x2060042:
_0x2060047:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRSH _0x2060049
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,LOW(1)
	RJMP _0x2060047
_0x2060049:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
_0x2060046:
	__GETD1S 12
	__GETD2N 0x3F000000
	CALL __ADDF12
	__PUTD1S 12
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	BRLO _0x206004A
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
_0x206004A:
_0x2060041:
	LDI  R17,LOW(0)
_0x206004B:
	LDD  R30,Y+11
	CP   R30,R17
	BRSH PC+3
	JMP _0x206004D
	__GETD2S 4
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 4
	__GETD2S 12
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	__GETD2S 12
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 12
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BREQ _0x206004E
	RJMP _0x206004B
_0x206004E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x206004B
_0x206004D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x206004F
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2060137
_0x206004F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2060137:
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2120007:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G103:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2060051:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2060053
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2060057
	CPI  R18,37
	BRNE _0x2060058
	LDI  R17,LOW(1)
	RJMP _0x2060059
_0x2060058:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
_0x2060059:
	RJMP _0x2060056
_0x2060057:
	CPI  R30,LOW(0x1)
	BRNE _0x206005A
	CPI  R18,37
	BRNE _0x206005B
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x2060138
_0x206005B:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x206005C
	LDI  R16,LOW(1)
	RJMP _0x2060056
_0x206005C:
	CPI  R18,43
	BRNE _0x206005D
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2060056
_0x206005D:
	CPI  R18,32
	BRNE _0x206005E
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2060056
_0x206005E:
	RJMP _0x206005F
_0x206005A:
	CPI  R30,LOW(0x2)
	BRNE _0x2060060
_0x206005F:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060061
	ORI  R16,LOW(128)
	RJMP _0x2060056
_0x2060061:
	RJMP _0x2060062
_0x2060060:
	CPI  R30,LOW(0x3)
	BRNE _0x2060063
_0x2060062:
	CPI  R18,48
	BRLO _0x2060065
	CPI  R18,58
	BRLO _0x2060066
_0x2060065:
	RJMP _0x2060064
_0x2060066:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2060056
_0x2060064:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2060067
	LDI  R17,LOW(4)
	RJMP _0x2060056
_0x2060067:
	RJMP _0x2060068
_0x2060063:
	CPI  R30,LOW(0x4)
	BRNE _0x206006A
	CPI  R18,48
	BRLO _0x206006C
	CPI  R18,58
	BRLO _0x206006D
_0x206006C:
	RJMP _0x206006B
_0x206006D:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2060056
_0x206006B:
_0x2060068:
	CPI  R18,108
	BRNE _0x206006E
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2060056
_0x206006E:
	RJMP _0x206006F
_0x206006A:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2060056
_0x206006F:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2060074
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x2060075
_0x2060074:
	CPI  R30,LOW(0x45)
	BREQ _0x2060078
	CPI  R30,LOW(0x65)
	BRNE _0x2060079
_0x2060078:
	RJMP _0x206007A
_0x2060079:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x206007B
_0x206007A:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	__GETW2SX 90
	CALL __GETD1P
	__PUTD1S 10
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	LDD  R26,Y+13
	TST  R26
	BRMI _0x206007C
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x206007E
	RJMP _0x206007F
_0x206007C:
	__GETD1S 10
	CALL __ANEGF1
	__PUTD1S 10
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x206007E:
	SBRS R16,7
	RJMP _0x2060080
	LDD  R30,Y+21
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x2060081
_0x2060080:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2060081:
_0x206007F:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2060083
	__GETD1S 10
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2060084
_0x2060083:
	__GETD1S 10
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G103
_0x2060084:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060085
_0x206007B:
	CPI  R30,LOW(0x73)
	BRNE _0x2060087
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060088
_0x2060087:
	CPI  R30,LOW(0x70)
	BRNE _0x206008A
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060088:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x206008C
	CP   R20,R17
	BRLO _0x206008D
_0x206008C:
	RJMP _0x206008B
_0x206008D:
	MOV  R17,R20
_0x206008B:
_0x2060085:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x206008E
_0x206008A:
	CPI  R30,LOW(0x64)
	BREQ _0x2060091
	CPI  R30,LOW(0x69)
	BRNE _0x2060092
_0x2060091:
	ORI  R16,LOW(4)
	RJMP _0x2060093
_0x2060092:
	CPI  R30,LOW(0x75)
	BRNE _0x2060094
_0x2060093:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2060095
	__GETD1N 0x3B9ACA00
	__PUTD1S 16
	LDI  R17,LOW(10)
	RJMP _0x2060096
_0x2060095:
	__GETD1N 0x2710
	__PUTD1S 16
	LDI  R17,LOW(5)
	RJMP _0x2060096
_0x2060094:
	CPI  R30,LOW(0x58)
	BRNE _0x2060098
	ORI  R16,LOW(8)
	RJMP _0x2060099
_0x2060098:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20600D7
_0x2060099:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x206009B
	__GETD1N 0x10000000
	__PUTD1S 16
	LDI  R17,LOW(8)
	RJMP _0x2060096
_0x206009B:
	__GETD1N 0x1000
	__PUTD1S 16
	LDI  R17,LOW(4)
_0x2060096:
	CPI  R20,0
	BREQ _0x206009C
	ANDI R16,LOW(127)
	RJMP _0x206009D
_0x206009C:
	LDI  R20,LOW(1)
_0x206009D:
	SBRS R16,1
	RJMP _0x206009E
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2060139
_0x206009E:
	SBRS R16,2
	RJMP _0x20600A0
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x2060139
_0x20600A0:
	__GETW1SX 90
	SBIW R30,4
	__PUTW1SX 90
	__GETW2SX 90
	ADIW R26,4
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x2060139:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x20600A2
	LDD  R26,Y+13
	TST  R26
	BRPL _0x20600A3
	__GETD1S 10
	CALL __ANEGD1
	__PUTD1S 10
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x20600A3:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x20600A4
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x20600A5
_0x20600A4:
	ANDI R16,LOW(251)
_0x20600A5:
_0x20600A2:
	MOV  R19,R20
_0x206008E:
	SBRC R16,0
	RJMP _0x20600A6
_0x20600A7:
	CP   R17,R21
	BRSH _0x20600AA
	CP   R19,R21
	BRLO _0x20600AB
_0x20600AA:
	RJMP _0x20600A9
_0x20600AB:
	SBRS R16,7
	RJMP _0x20600AC
	SBRS R16,2
	RJMP _0x20600AD
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x20600AE
_0x20600AD:
	LDI  R18,LOW(48)
_0x20600AE:
	RJMP _0x20600AF
_0x20600AC:
	LDI  R18,LOW(32)
_0x20600AF:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	SUBI R21,LOW(1)
	RJMP _0x20600A7
_0x20600A9:
_0x20600A6:
_0x20600B0:
	CP   R17,R20
	BRSH _0x20600B2
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20600B3
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	BREQ _0x20600B4
	SUBI R21,LOW(1)
_0x20600B4:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x20600B3:
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	CPI  R21,0
	BREQ _0x20600B5
	SUBI R21,LOW(1)
_0x20600B5:
	SUBI R20,LOW(1)
	RJMP _0x20600B0
_0x20600B2:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x20600B6
_0x20600B7:
	CPI  R19,0
	BREQ _0x20600B9
	SBRS R16,3
	RJMP _0x20600BA
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x20600BB
_0x20600BA:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x20600BB:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	CPI  R21,0
	BREQ _0x20600BC
	SUBI R21,LOW(1)
_0x20600BC:
	SUBI R19,LOW(1)
	RJMP _0x20600B7
_0x20600B9:
	RJMP _0x20600BD
_0x20600B6:
_0x20600BF:
	__GETD1S 16
	__GETD2S 10
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20600C1
	SBRS R16,3
	RJMP _0x20600C2
	SUBI R18,-LOW(55)
	RJMP _0x20600C3
_0x20600C2:
	SUBI R18,-LOW(87)
_0x20600C3:
	RJMP _0x20600C4
_0x20600C1:
	SUBI R18,-LOW(48)
_0x20600C4:
	SBRC R16,4
	RJMP _0x20600C6
	CPI  R18,49
	BRSH _0x20600C8
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20600C7
_0x20600C8:
	RJMP _0x20600CA
_0x20600C7:
	CP   R20,R19
	BRSH _0x206013A
	CP   R21,R19
	BRLO _0x20600CD
	SBRS R16,0
	RJMP _0x20600CE
_0x20600CD:
	RJMP _0x20600CC
_0x20600CE:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20600CF
_0x206013A:
	LDI  R18,LOW(48)
_0x20600CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20600D0
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	BREQ _0x20600D1
	SUBI R21,LOW(1)
_0x20600D1:
_0x20600D0:
_0x20600CF:
_0x20600C6:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	CPI  R21,0
	BREQ _0x20600D2
	SUBI R21,LOW(1)
_0x20600D2:
_0x20600CC:
	SUBI R19,LOW(1)
	__GETD1S 16
	__GETD2S 10
	CALL __MODD21U
	__PUTD1S 10
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 16
	CALL __CPD10
	BREQ _0x20600C0
	RJMP _0x20600BF
_0x20600C0:
_0x20600BD:
	SBRS R16,0
	RJMP _0x20600D3
_0x20600D4:
	CPI  R21,0
	BREQ _0x20600D6
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RJMP _0x20600D4
_0x20600D6:
_0x20600D3:
_0x20600D7:
_0x2060075:
_0x2060138:
	LDI  R17,LOW(0)
_0x2060056:
	RJMP _0x2060051
_0x2060053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x20600D8
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120006
_0x20600D8:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
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
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2120006:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_ds1302_rst0_G104:
	cbi  __ds1302_port,__ds1302_rst
	__DELAY_USB 3
	RET
_ds1302_write0_G104:
    sbi  __ds1302_port-1,__ds1302_sclk
    sbi  __ds1302_port-1,__ds1302_io
    sbi  __ds1302_port-1,__ds1302_rst
    sbi  __ds1302_port,__ds1302_rst
	__DELAY_USB 3
	LD   R30,Y
	ST   -Y,R30
	RCALL _ds1302_write1_G104
	JMP  _0x2120005
_ds1302_write1_G104:
    ld   r30,y+
    ldi  r26,8
ds1302_write2:
    ror  r30
    cbi  __ds1302_port,__ds1302_io
    brcc ds1302_write3
    sbi  __ds1302_port,__ds1302_io
ds1302_write3:
    nop
    nop
    nop
    nop
    sbi  __ds1302_port,__ds1302_sclk
	__DELAY_USB 1
	cbi  __ds1302_port,__ds1302_sclk
	__DELAY_USB 1
    dec  r26
    brne ds1302_write2
    ret
_ds1302_read:
	LD   R30,Y
	ORI  R30,1
	ST   -Y,R30
	CALL _ds1302_write0_G104
    cbi  __ds1302_port,__ds1302_io
    cbi  __ds1302_port-1,__ds1302_io
    ldi  r26,8
ds1302_read0:
    clc
    sbic __ds1302_port-2,__ds1302_io
    sec
    ror  r30
    sbi  __ds1302_port,__ds1302_sclk
	__DELAY_USB 1
	cbi  __ds1302_port,__ds1302_sclk
	__DELAY_USB 1
    dec  r26
    brne ds1302_read0
	CALL _ds1302_rst0_G104
_0x2120005:
	ADIW R28,1
	RET
_ds1302_write:
	LDD  R30,Y+1
	ANDI R30,0xFE
	ST   -Y,R30
	CALL _ds1302_write0_G104
	LD   R30,Y
	ST   -Y,R30
	CALL _ds1302_write1_G104
	CALL _ds1302_rst0_G104
	ADIW R28,2
	RET
_rtc_init:
	LD   R30,Y
	ANDI R30,LOW(0x3)
	ST   Y,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x2080003
	LD   R30,Y
	ORI  R30,LOW(0xA0)
	ST   Y,R30
_0x2080003:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x2080004
	LD   R30,Y
	ORI  R30,4
	RJMP _0x2080008
_0x2080004:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x2080006
	LD   R30,Y
	ORI  R30,8
	RJMP _0x2080008
_0x2080006:
	LDI  R30,LOW(0)
_0x2080008:
	ST   Y,R30
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _ds1302_write
	LDI  R30,LOW(144)
	ST   -Y,R30
	LDD  R30,Y+1
	RJMP _0x2120003
_rtc_get_time:
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL _ds1302_read
	ST   -Y,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(131)
	ST   -Y,R30
	RCALL _ds1302_read
	ST   -Y,R30
	CALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(129)
	RJMP _0x2120002
_rtc_set_time:
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _ds1302_write
	LDI  R30,LOW(132)
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	RCALL _ds1302_write
	LDI  R30,LOW(130)
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	RCALL _ds1302_write
	LDI  R30,LOW(128)
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _bin2bcd
_0x2120003:
	ST   -Y,R30
	RCALL _ds1302_write
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	RCALL _ds1302_write
_0x2120004:
	ADIW R28,3
	RET
_rtc_get_date:
	LDI  R30,LOW(135)
	ST   -Y,R30
	RCALL _ds1302_read
	ST   -Y,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(137)
	ST   -Y,R30
	RCALL _ds1302_read
	ST   -Y,R30
	CALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(141)
_0x2120002:
	ST   -Y,R30
	RCALL _ds1302_read
	ST   -Y,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	ADIW R28,6
	RET

	.CSEG

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL __GETD1S0
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x2120001
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x2120001:
	ADIW R28,4
	RET

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
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
_strlenf:
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

	.CSEG
_bcd2bin:
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
_bin2bcd:
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret

	.DSEG
_prtc_get_time:
	.BYTE 0x2
_prtc_get_date:
	.BYTE 0x2
_Command_2:
	.BYTE 0x1
_Response_1:
	.BYTE 0x1
_Response_2:
	.BYTE 0x1
_CheckSum_1:
	.BYTE 0x1
_CheckSum_2:
	.BYTE 0x1
_sumLO:
	.BYTE 0x1
_sumHI:
	.BYTE 0x1
_ErrorCode:
	.BYTE 0x2
_car0:
	.BYTE 0x8
_id_menu:
	.BYTE 0x2
_menu_lock:
	.BYTE 0x1

	.ESEG
_registry:
	.BYTE 0x14

	.DSEG
_h:
	.BYTE 0x1
_m:
	.BYTE 0x1
_s:
	.BYTE 0x1
_d:
	.BYTE 0x1
_mo:
	.BYTE 0x1
_y:
	.BYTE 0x1
_ID_aux:
	.BYTE 0x1
_ID_aux_del:
	.BYTE 0x1
_print_aux:
	.BYTE 0x1E
_NombreArchivo:
	.BYTE 0xF
__seed_G100:
	.BYTE 0x4
_status_G101:
	.BYTE 0x1
_timer1_G101:
	.BYTE 0x1
_timer2_G101:
	.BYTE 0x1
_card_type_G101:
	.BYTE 0x1
_pv_S101000B000:
	.BYTE 0x1
_FatFs_G102:
	.BYTE 0x2
_Fsid_G102:
	.BYTE 0x2
_Drive_G102:
	.BYTE 0x1
_fatstr_S1020016000:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1F4
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
