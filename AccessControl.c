#include "GT_511_C3.h"
#include <ff.h>

/*  the DS1302 is connected to ATmega8515 PORTC
    the IO signal is bit 3
    the SCLK signal is bit 4
    the RST signal is bit 5 */
#asm
    .equ __ds1302_port=0x08
    .equ __ds1302_io=0
    .equ __ds1302_sclk=1
    .equ __ds1302_rst=2
#endasm
#include "ds1302.h"

//BUTTONS
#define Bot1 PINC.7
#define Bot2 PINC.6
#define Bot3 PINC.5

//MENUS - VARIABLES
char car0[]={0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E};
unsigned int id_menu;
unsigned char menu_lock;

//VARIABLES
eeprom char registry[20];
unsigned char h, m, s, d, mo, y, ID_aux, ID_aux_del;
char print_aux[30];


char NombreArchivo[] = "0:Registry.txt";


//INTERRUPT TO CHECK CONNECTION
interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
  disk_timerproc();
}

//MENUS
void menu0() {
    BorrarLCD();
    MoverCursor(3,1);
    StringLCD("Digital Access");
    MoverCursor(1,3);
    StringLCD("Reg.");
    MoverCursor(6,3);
    LetraLCD(0);
    MoverCursor(8,3);
    StringLCD("Time");
    MoverCursor(13,3);
    LetraLCD(0);
    MoverCursor(14,3);
    StringLCD("Access");
}

void menu0_1() {
    BorrarLCD();
    MoverCursor(3,1);
    StringLCD("User Register");
    MoverCursor(1,3);
    StringLCD("Add");
    MoverCursor(5,3);
    LetraLCD(0);
    MoverCursor(7,3);
    StringLCD("Remove");
    MoverCursor(14,3);
    LetraLCD(0);
    MoverCursor(16,3);
    StringLCD("Back");
}

void menu0_1_1() {
    BorrarLCD();
    MoverCursor(3,0);
    StringLCD("Put your finger");
    MoverCursor(4,1);
    StringLCD("in the reader");
    MoverCursor(6,3);
    LetraDatoLCD(0);
    MoverCursor(13,3);
    LetraDatoLCD(0);
    MoverCursor(15,3);
    StringLCD("Back");
}

void menu0_1_2() {
    BorrarLCD();
    MoverCursor(3,0);
    StringLCD("Select user id");
    MoverCursor(1,1);
    StringLCD("to remove from list");
    MoverCursor(2,3);
    StringLCD("+");
    MoverCursor(5,3);
    LetraLCD(0);
    MoverCursor(7,3);
    StringLCD("Select");
    MoverCursor(14,3);
    LetraLCD(0);
    MoverCursor(17,3);
    StringLCD("-");
}

void menu0_2() {
    BorrarLCD();
    MoverCursor(2,3);
    StringLCD("Hour");
    MoverCursor(6,3);
    LetraDatoLCD(0);
    MoverCursor(9,3);
    StringLCD("Min");
    MoverCursor(13,3);
    LetraDatoLCD(0);
    MoverCursor(16,3);
    StringLCD("OK");
}

void menu0_3() {
    BorrarLCD();
    MoverCursor(3,0);
    StringLCD("Put your finger");
    MoverCursor(4,1);
    StringLCD("in the reader");
    MoverCursor(6,3);
    LetraLCD(0);
    MoverCursor(13,3);
    LetraLCD(0);
    MoverCursor(15,3);
    StringLCD("Back");
}

//FUNCTIONS AND PROCEDURES
char Next(unsigned char j) {
    char i;
    for (i=j-1; i<19; i++)
        if (registry[i]!=0)
            return i+1;
    return 0;
}

char Prev(unsigned char j) {
    char i;
    for (i=j-1; i>0; i--)
        if (registry[i]!=0)
            return i+1;
    return 0;
}

void Delete(unsigned char ID1){
    DeleteID(ID1);
    if(ResponseFromScanner() == 0x30)
       registry[ID1-1] = 0;
}

void EnrollProcess(unsigned char ID1) {
    BorrarLCD();
    MoverCursor(0,0);
    StringLCD("Registrar");
    delay_ms(1000);


    //Enroll
    EnrollStart(ID1);
    if(ResponseFromScanner() == 0x30) {
        Enroll1();
        if(ResponseFromScanner() == 0x30) {
            Enroll2();
            if(ResponseFromScanner() == 0x30) {
                Enroll3();
                if(ResponseFromScanner() == 0x30) {
                    StringLCD("ID Registrado");
                    registry[ID1-1] = 1;
                }
            }
        }
    }
    Reset();
    delay_ms(500);
}



void main(){
    char aux[40];
    unsigned int br;


    /* FAT function result */
    FRESULT res;

    /* will hold the information for logical drive 0: */
    FATFS drive;
    FIL archivo; // file objects

    ConfiguraLCD();
    rtc_init(0,0,0);

    // USART1 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART1 Receiver: On
    // USART1 Transmitter: On
    // USART1 Mode: Asynchronous
    // USART1 Baud Rate: 9600 (Double Speed Mode)
    UCSR1A=0x02;
    UCSR1B=0x18;
    UCSR1C=0x06;
    UBRR1H=0x00;
    UBRR1L=0x19;

    //PULL-UPS (BUTTONS)
    PORTC = 0xE0;

    /*Configurar el PORTB I/O*/
    DDRB=0b11101101;

    // C?digo para hacer una interrupci?n peri?dica cada 10ms
    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 1000.000 kHz
    // Mode: CTC top=OCR1A
    // Compare A Match Interrupt: On
    TCCR1B=0x09;
    OCR1AH=0x27;
    OCR1AL=0x10;
    TIMSK1=0x02;
    #asm("sei")

    ConfiguraLCD();
    CreaCaracter(0,car0);

    /* Inicia el puerto SPI para la SD */
    disk_initialize(0);
    delay_ms(200);

    BacklightON();


    Initialization();
    LedControl(0x00);
    GetEnrollCount();

    ID_aux = 0;
    ID_aux_del = 1;
    id_menu = 0;
    menu_lock =0;


    while(1) {

        switch (id_menu){
        case 0:
            menu0();
            while(Bot1 == 1 && Bot2 == 1 && Bot3 == 1);
            if(Bot1 == 0)
                id_menu = 1;
            else if(Bot2 == 0)
                id_menu = 2;
            else if(Bot3 == 0)
                id_menu = 3;
            break;
        case 1:
            menu0_1();
            while(Bot1 == 1 && Bot2 == 1 && Bot3 == 1);
            if(Bot1 == 0)
                id_menu = 11;
            else if(Bot2 == 0)
                id_menu = 12;
            else if(Bot3 == 0)
                id_menu = 0;
            break;
        case 11:
            BorrarLCD();
            MoverCursor(3,0);
            StringLCD("Put your finger");
            MoverCursor(4,1);
            StringLCD("in the reader");
            while(Identify() == NACK_FINGER_IS_NOT_PRESSED);
               if(Response_1 == 0x30) {
                   menu0_1_1();
                ID_aux = Next(1);
                if (ID_aux != 0) {
                    EnrollProcess(ID_aux);
                    BorrarLCD();
                    MoverCursor(4,0);
                    sprintf(print_aux,"   ID #%i ENROLLED",ID_aux);
                    StringLCDVar(print_aux);
                } else {
                    BorrarLCD();
                    MoverCursor(4,0);
                    StringLCD("Memory Full");
                }
               } else {
                   id_menu = 0;
                   BorrarLCD();
                   MoverCursor(0,1);
                   StringLCD("    Access Denied");
                   delay_ms(1000);
               }

            while(Bot3 == 1);
            if(Bot3 == 0)
                id_menu = 1;
            break;
        case 12:
            if(menu_lock == 0) {
                while(Identify() == NACK_FINGER_IS_NOT_PRESSED);
                if(Response_1 == 0x30) {
                    menu_lock = 1;
                    ID_aux_del = 1;
                   } else {
                    id_menu = 0;
                       BorrarLCD();
                       MoverCursor(0,1);
                       StringLCD("    Access Denied");
                       delay_ms(1000);
                    menu_lock = 1;
                    break;
                   }
            }
            menu0_1_2();
            MoverCursor(0,2);
            sprintf(print_aux,"      #%i", ID_aux_del);
            StringLCDVar(print_aux);
            while(Bot2 == 1 && Bot1 == 1 && Bot3 == 1);
            if(Bot1 == 0 && Bot3 == 0) {
                id_menu = 0;
                ID_aux_del = 1;
                menu_lock = 1;
            } else if(Bot1 == 0 && ID_aux_del>1) {
                ID_aux_del = Prev(ID_aux_del);
            } else if(Bot3 == 0 && ID_aux_del<20) {
                ID_aux_del = Next(ID_aux_del);
            } else if(Bot2 == 0) {
                id_menu = 0;
                menu_lock = 1;
                Delete(ID_aux_del);
                BorrarLCD();
                MoverCursor(4,1);
                StringLCD("User removed");
                MoverCursor(5,2);
                StringLCD("from list!");
                delay_ms(1000);
            }

            break;
        case 2:
            menu0_2();
            rtc_get_time(&h,&m,&s);

            MoverCursor(8,1);
            sprintf(print_aux, "%i:%i", h, m);
            StringLCDVar(print_aux);

            while(Bot3 == 1 && Bot2 == 1 && Bot1 == 1);
            if(Bot1==0) {
                h++;
                rtc_set_time(h,m,0);
            } else if(Bot2==0) {
                m++;
                rtc_set_time(h,m,0);
            } else if(Bot3 == 0) {
                id_menu = 0;
                BorrarLCD();
                MoverCursor(6,1);
                StringLCD("Set time");
                MoverCursor(6,2);
                StringLCD("success!");
                delay_ms(1000);
            }
            break;
        case 3:
            menu0_3();
            while(Identify() == NACK_FINGER_IS_NOT_PRESSED);
            if(Response_1 == 0x30) {
                rtc_get_time(&h,&m,&s);
                rtc_get_date(&d,&mo,&y);
                sprintf(aux, "%i/%i/%i | %i:%i:%i | ID: 0%i \n", d, mo, y, h, m , s, (Parameter_1 + 1));
                /* mount logical drive 0: */
                if ((res=f_mount(0,&drive))==FR_OK){
                    /*Lectura de Archivo*/
                    res = f_open(&archivo, NombreArchivo, FA_OPEN_ALWAYS | FA_WRITE | FA_READ);
                    if (res==FR_OK) {
                        f_write(&archivo,aux,sizeof(aux),&br);
                        f_close(&archivo);
                        delay_ms(500);
                    }
                }
                f_mount(0, 0); //Cerrar drive de SD
                BorrarLCD();
                MoverCursor(0,1);
                StringLCD("       Welcome");
                MoverCursor(0,2);
                sprintf(print_aux,"    %i", (Parameter_1 + 1));
                StringLCDVar(print_aux);
                delay_ms(1000);
            } else {
                BorrarLCD();
                MoverCursor(0,1);
                StringLCD("    Access Denied");
                delay_ms(1000);
            }
            while(Bot3 == 1);
            if(Bot3 == 0)
                id_menu = 0;

            break;
        }
    }
}