#ifndef GT_511_C3_H
#define GT_511_C3_H

#include <90USB1286.h>
#include <stdlib.h>
#include <stdio.h>
#include <delay.h> 
#include "display.h"


// Default values
#define START1      0x55
#define START2      0xAA
#define DEVICE_ID   0x0001

#define ZERO        0x00
#define NONZERO     0x01
#define ON          0x01
#define OFF         0x00

// Commnad Summary
#define OPEN                0x01
#define CLOSE               0x02
#define CHANGE_BAUD_RATE    0x04
#define CMOS_LED            0x12
#define GET_ENROLL_COUNT    0x20 
#define CHECK_ENROLLED      0x21
#define ENROLL_START        0x22
#define ENROLL1             0x23
#define ENROLL2             0x24
#define ENROLL3             0x25
#define IS_PRESS_FINGER     0x26
#define DELETE_ID           0x40
#define DELETE_ALL          0x41
#define VERIFY              0x50
#define IDENTIFY            0x51
#define CAPTURE_FINGER      0x60

#define ACK                 0x30
#define NACK                0x31 


//Error codes
//#define NACK_TIMEOUT 0x1001
//#define NACK_INVALID_BAUDRATE 0x1002
#define NACK_INVALID_POS            0x1003
#define NACK_IS_NOT_USED            0x1004
#define NACK_IS_ALREADY_USED        0x1005
#define NACK_COMM_ERR               0x1006
#define NACK_VERIFY_FAILED          0x1007
#define NACK_IDENTIFY_FAILED        0x1008
#define NACK_DB_IS_FULL             0x1009
#define NACK_DB_IS_EMPTY            0x100A
//#define NACK_TURN_ERR 0x100B
#define NACK_BAD_FINGER             0x100C
#define NACK_ENROLL_FAILED          0x100D
#define NACK_IS_NOT_SUPPORTED       0x100E
#define NACK_DEV_ERR                0x100F 
//#define NACK_CAPTURE_CANCELED 0x1010
#define NACK_INVALID_PARAM          0x1011
#define NACK_FINGER_IS_NOT_PRESSED  0x1012


//Global variables
char CommandStart_1, CommandStart_2;
char DeviceID_1, DeviceID_2;
char Parameter_1, Parameter_2, Parameter_3, Parameter_4;
char Command_1, Command_2;
char Response_1, Response_2;
char CheckSum_1, CheckSum_2;  

char sumLO, sumHI;
unsigned int ErrorCode;

void imprimeByte(char by) 
{
     char byte[10]; 
     //StringLCD("0x");
     sprintf(byte, "%02X ", by);
     StringLCDVar(byte);   
     //delay_ms(1000);
}
  

/******* COMMAND PACKET *******/
//  0x55        CommandStart1
//  0xAA        CommandStart2
//  0x0001      DeviceID
//  0xXXXXXXXX  Parameter
//  0xXXXX      Command
//  0xXXXX      CheckSum
/*******************************/

//General functions 
void Reset()
{
    //Reset
    Parameter_1 = 0;
    Parameter_2 = 0;
    Parameter_3 = 0;
    Parameter_4 = 0; 
    Command_1 = 0;
    Command_2 = 0; 
    Response_1 = 0;
    Response_2 = 0;
}

void DefaultInfo()
{
    //Default info  
    CommandStart_1 = START1;
    putchar(CommandStart_1);   
        
    CommandStart_2 = START2;
    putchar(CommandStart_2); 
    
    DeviceID_1 = DEVICE_ID;
    putchar(DeviceID_1);
    
    DeviceID_2 = DEVICE_ID >> 8;
    putchar(DeviceID_2); 
    
    Reset();
}

void CalculateSum()
{
    unsigned int sum;
    
    sum = CommandStart_1 + CommandStart_2 + DeviceID_1 + DeviceID_2 + \
          Parameter_1 + Parameter_2 + Parameter_3 + Parameter_4 + \
          Command_1 + Command_2;
    
    sumLO = (char)sum;
    sumHI = (char)(sum >> 8); 
}

void CommandToScanner(unsigned char Param, unsigned char Com)
{
    //SerialConfigNormal();    
    DefaultInfo();
    
    //Parametro
    Parameter_1 = Param;
    putchar(Param);
    putchar(0x00);
    putchar(0x00);
    putchar(0x00);
    
    //Comando 
    Command_1 = Com;
    putchar(Com);
    putchar(0x00); 

    //CheckSum
    CalculateSum();
    putchar(sumLO);
    putchar(sumHI); 
    
    CommandStart_1 = getchar();
    CommandStart_2 = getchar();
    DeviceID_1 = getchar();
    DeviceID_2 = getchar();
    Parameter_1 = getchar();
    Parameter_2 = getchar();
    Parameter_3 = getchar();
    Parameter_4 = getchar();
    Response_1 = getchar();
    Response_2 = getchar();
    CheckSum_1 = getchar();
    CheckSum_2 = getchar();    
}

//Scanner functions
void Initialization()
{
    //Parameter = 0: Not to get extra info
    CommandToScanner(0x00, OPEN);
}

void Termination()
{
    CommandToScanner(0x00, CLOSE); 
}

void LedControl(unsigned char Parameter)
{ 
    //Parameter = 0: OFF 
    //Parameter = 1: ON
    CommandToScanner(Parameter, CMOS_LED);  
}

void GetEnrollCount()
{
    CommandToScanner(0x00, GET_ENROLL_COUNT);   
}

void CheckEnrolled(unsigned char Param_ID)
{
    CommandToScanner(Param_ID, CHECK_ENROLLED);
}

char EnrollStart(unsigned char Param_ID)
{
    CommandToScanner(Param_ID, ENROLL_START); 
    return Response_1;
}

int CaptureFinger(unsigned char Parameter)
{
    //Zero: not best image, but fast
    //Nonzero: best image, but slow
    CommandToScanner(Parameter, CAPTURE_FINGER);
    return (Parameter_2 << 8) + Parameter_1;
}

void Enroll1()
{  
    LedControl(0x01);

    BorrarLCD();
    MoverCursor(0,1);
    StringLCD("Coloca tu dedo ");
    MoverCursor(0,2);
    StringLCD("sobre el scaner"); 
        
    while(CaptureFinger(0x01) == NACK_FINGER_IS_NOT_PRESSED);
    LedControl(0x00); 
    
    CommandToScanner(0x00, ENROLL1);
}

void Enroll2()
{
    LedControl(0x01); 
    
    BorrarLCD();
    MoverCursor(0,1);
    StringLCD("Coloca tu dedo ");
    MoverCursor(0,2);
    StringLCD("sobre el scaner"); 
        
    while(CaptureFinger(0x01) == NACK_FINGER_IS_NOT_PRESSED);
    LedControl(0x00);
    
    CommandToScanner(0x00, ENROLL2);
}

void Enroll3()
{
    LedControl(0x01);
    
    BorrarLCD();
    MoverCursor(0,1);
    StringLCD("Coloca tu dedo ");
    MoverCursor(0,2);
    StringLCD("sobre el scaner"); 
        
    while(CaptureFinger(0x01) == NACK_FINGER_IS_NOT_PRESSED);
    LedControl(0x00);
    
    CommandToScanner(0x00, ENROLL3);
}

void IsPressFinger()
{    
    CommandToScanner(0x00, IS_PRESS_FINGER); 
}

void DeleteID(unsigned char Param_ID)
{
    CommandToScanner(Param_ID, DELETE_ID);
}

void DeleteAll()
{
    CommandToScanner(0x00, DELETE_ALL);
}

void Verify(unsigned char Param_ID)
{
    CommandToScanner(Param_ID, VERIFY);
}

int Identify()
{
    unsigned int press;
    
    LedControl(0x01);
    press = CaptureFinger(0x01); 
    LedControl(0x00); 
     
    if(press != NACK_FINGER_IS_NOT_PRESSED) 
    {
        CommandToScanner(0x00, IDENTIFY);
        return (int)Response_1;    
    }
    else
    {
        return NACK_FINGER_IS_NOT_PRESSED;
    }
    
}



/******* RESPONSE PACKET *******/
//  0x55        ResponseStart1
//  0xAA        ResponseStart2
//  0x0001      DeviceID
//  0xXXXXXXXX  Parameter
//  0xXXXX      Response
//  0xXXXX      CheckSum
/*******************************/
void NackError(unsigned int Error)
{
    BorrarLCD();
    MoverCursor(0,1);
    
    switch(Error)
    {
        case NACK_INVALID_POS:
            StringLCD("Invalid position");
            break;
        
        case NACK_IS_NOT_USED:
            StringLCD("The ID is not used");
            break;
        
        case NACK_IS_ALREADY_USED:
            StringLCD("ID already used");
            break;
            
        case NACK_COMM_ERR:
            StringLCD("Communication error");
            break;
        
        case NACK_VERIFY_FAILED:
            StringLCD("Verification failure");
            break;
            
        case NACK_IDENTIFY_FAILED:
            StringLCD("Identification fail");
            break;
            
        case NACK_DB_IS_FULL:
            StringLCD("Database is full");
            break;
        
        case NACK_DB_IS_EMPTY:
            StringLCD("Database is empty");
            break; 
        
        case NACK_BAD_FINGER:
            StringLCD("Too bad fingerprint");
            break; 
        
        case NACK_ENROLL_FAILED:
            StringLCD("Enrollment failure");
            break; 
            
        case NACK_IS_NOT_SUPPORTED:
            StringLCD("Command not supported");
            break;  
        
        case NACK_DEV_ERR:
            StringLCD("Device error");
            break;  
        
        case NACK_INVALID_PARAM:
            StringLCD("Invalid parameter");
            break;
        
        case NACK_FINGER_IS_NOT_PRESSED:
            StringLCD("Finger not pressed");
            break;
        
        default:
            break;
    }
}       
  
char ResponseFromScanner()
{
//    BorrarLCD();
//    MoverCursor(0,1);
//    imprimeByte(CommandStart_1);
//    imprimeByte(CommandStart_2);
//    imprimeByte(DeviceID_1);
//    imprimeByte(DeviceID_2);
//    imprimeByte(Parameter_1);
//    imprimeByte(Parameter_2);
//    imprimeByte(Parameter_3);
//    imprimeByte(Parameter_4);
//    imprimeByte(Response_1);
//    imprimeByte(Response_2);
//    imprimeByte(CheckSum_1);
//    imprimeByte(CheckSum_2);  
//        
//    delay_ms(1000);ç
    
    ErrorCode = (Parameter_2 << 8) + Parameter_1;
    NackError(ErrorCode);
    return Response_1;     
}


//Pase de lista


#endif