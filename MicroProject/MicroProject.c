

#include <io.h>
#include <delay.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define LED_R      PORTD.0
#define LED_G      PORTD.1
#define LED_B      PORTD.2
#define key_prt  PORTC
#define key_ddr  DDRC
#define key_pin  PINC
#define lcd_dprt PORTA
#define lcd_dddr DDRA
#define lcd_dpin PINA
#define lcd_cprt PORTB
#define lcd_cddr DDRB
#define lcd_cpin PINB
#define lcd_rs 0
#define lcd_rw 1
#define lcd_en 2
#define NameSize 4


unsigned char*  keypad[3][4] =  { "1","4","7","*",
                                  "2","5","8","0",
                                  "3","6","9","#",};   
                 


unsigned char* AllowList[NameSize+1][3]={{"10","0","0"},{"20","0","0"},{"","0","0"},{"","0","0"},{"","0","0"}};


unsigned char colloc , rowloc;
unsigned char* CodeID = "";
unsigned char counter=0;
unsigned char ShowMenu = 0;
unsigned char MenuOption = 0;
unsigned char RegisteredCount = 2;  
unsigned char registration = 0;
unsigned char code = 4;
unsigned char* AccessResult1 = "";
unsigned char* list = "";
unsigned char * menu= "1)Delete   2)Insert 3)History->";

                                    
void lcdCommand(unsigned char cmnd){
   lcd_dprt = cmnd;
   lcd_cprt &= ~(1<<lcd_rs);
   lcd_cprt &= ~(1<<lcd_rw);  
   lcd_cprt |= (1<<lcd_en);
   delay_us(1);
   lcd_cprt &= ~(1<<lcd_en);
   delay_us(100);
}

void lcdData(unsigned char data){

    lcd_dprt = data;
    lcd_cprt |= (1<<lcd_rs);
    lcd_cprt &= ~(1<<lcd_rw);
    lcd_cprt |= (1<<lcd_en);    
    delay_us(1);
    lcd_cprt &= ~(1<<lcd_en);
    delay_us(100);
}

void lcd_init(){
    lcd_dddr = 0xff;
    lcd_cddr = 0xff; 
    lcd_cprt &= ~(1<<lcd_en);
    delay_us(2000);
    lcdCommand(0x38);  
    lcdCommand(0x0C);
    lcdCommand(0x01);
    delay_us(2000); 
    lcdCommand(0x06);
}

void lcd_gotoxy(unsigned char x , unsigned char y){
   unsigned char firstCharAdr[] = {0x80,0xc0,0x94,0xd4};
   lcdCommand(firstCharAdr[y-1] + x-1 );
   delay_us(100);

}

void lcd_print(char* str){
    unsigned char i = 0;
    while( i < strlen(str)){
       lcdData(str[i]);  
       i++;
    }
}

void CleenLCD(){
     lcdCommand(0x01); 
     delay_us(100);
     lcd_gotoxy(1,1);
     delay_us(100);
}



void LED_Ok(){
    LED_R = 0;
    LED_G = 255;
    LED_B = 0;
    delay_ms(100);
    LED_R = 0;
    LED_G = 0;
    LED_B = 0;
}

void LED_Error(){
    LED_R = 255;
    LED_G = 0;
    LED_B = 0;
    delay_ms(100);
    LED_R = 0;
    LED_G = 0;
    LED_B = 0;
}

void LED_Warning(){
    LED_R = 255;
    LED_G = 255;
    LED_B = 0;
    delay_ms(100);
    LED_R = 0;
    LED_G = 0;
    LED_B = 0;
}


void ShowMyMenu(){
    
    CleenLCD();
    sprintf(menu,"1)Delete   2)Insert 3)History ->");
    lcd_print(menu);
    MenuOption = 1;

}
//*********************************************************************************************************

void History(){
    
    unsigned char i = 0;
    sprintf(list,"");
    CleenLCD();
    for(i = 0; i < NameSize ; i++){
        if(strcmp(AllowList[i][0],"") && strcmp(AllowList[i][0],"10")){
            strcat(list,AllowList[i][0]);
            strcat(list,"->");
            strcat(list,AllowList[i][2]);
            strcat(list," ");
        }
    }
    lcd_print(list);
    delay_ms(100);
    CleenLCD();
    strcmp(list,""); 
    registration = 0;
    MenuOption = 0;
    code = 4;
    strcpy(CodeID,"");
    
}


void InsertORDelete(){
    unsigned char * menu_options = "Enter ID For Delete -> "; 
    CleenLCD();
    
    
    if(code == 1){
          strcpy(menu_options,"Enter ID For Delete -> ");
          registration = 1; 
          lcd_print(menu_options); 
    }
    else if(code == 2){
           strcpy(menu_options,"Enter ID For Insert -> ");
           registration = 2;
           lcd_print(menu_options); 
    }
    else if(code == 3){
        History();
       registration = 3;
    }
    else{        
         strcpy(menu_options,"unknown Command!"); 
         lcd_print(menu_options); 
         delay_ms(100);
         CleenLCD(); 
         registration = 0;
    }
             
     MenuOption = 0;
     code = 4;  
}



void Delete(){

    unsigned char* result = "Memory Is Empty";
    unsigned char* error = "Memory Is Empty"; 
    unsigned char find = 0;
    CleenLCD();
    counter = 1;

    
    if (RegisteredCount < 2){
       strcpy(error,"Memory Is Empty");
       result = error;
    }
    else{
        while(counter<NameSize){
            if(!strncmp(AllowList[counter][0],CodeID,2)){
               strcpy(AllowList[counter][0],"");
               strcpy(AllowList[counter][2],"0");
               RegisteredCount--;
               find = 1; 
               break;
            }
            counter = counter + 1;
        }
        if(find == 1){
            strcpy(result,"Access ");
            result=strcat(result,CodeID);
            result=strcat(result," Deleted.");
        }else{
            strcpy(result,CodeID);
            result=strcat(result," Not Found.");
        }  
    }

    lcd_print(result);
    LED_Warning();
    CleenLCD(); 
    registration = 0;
    strcpy(CodeID,"");
    counter = 0; 
}


void Insert(){
    
    unsigned char* value = "0";
    counter = 0;
  
    CleenLCD(); 
    if( RegisteredCount < NameSize){

        while(counter < NameSize){
            strcpy(value, AllowList[counter][0]);
            if(!strncmp(value,"",2)){
                sprintf(AllowList[counter][0],"%s",CodeID);
                RegisteredCount = RegisteredCount+1;
                break;
            }
            counter = counter + 1;
        }
        strcpy(AccessResult1,"Access ");
        AccessResult1=strcat(AccessResult1,AllowList[counter][0]);
        AccessResult1=strcat(AccessResult1," Granted"); 
    }
    else{
        strcpy(AccessResult1,"Memory Is Full");
    }
    lcd_print(AccessResult1);
    LED_Warning();
    CleenLCD(); 
    registration = 0;
    strcpy(CodeID,"");
    strcpy(AccessResult1,""); 
    counter = 0;
}


// (flag=1 means Admin)  (flag=2 means Valid Login)  (flag=* means Invalid Login)
unsigned char* CheckAccess(){
    unsigned char value = 0;
    
    unsigned char empty;
    unsigned char* flag = "*";
    CleenLCD();
     
    while(counter < NameSize & strlen(CodeID)>0 ){
        
        if(!strncmp(CodeID,AllowList[counter][0],2)){
            empty = 1;
            value = atoi(AllowList[counter][2]);
            value++;
            strcpy(AllowList[counter][2],"");
            sprintf(AllowList[counter][2],"%d",value);
            if(counter == 0)
                strcpy(flag , "1");
            else{
                strcpy(flag , "2");
                }
           break;  
        }
        counter = counter +1;
    }
    if(empty != 1)
       strcpy(flag , "*");
    strcpy(CodeID,"");     
    counter = 0;
    return flag;
}




void ReadKeyPad(){
    unsigned char * result = "-";
    do{
        key_prt &=0x0F;
        colloc = (key_pin & 0x0F); 
        
    }while(colloc !=0x0F);
    
    do{       
        do{                    
            delay_ms(20);
            colloc = (key_pin & 0x0F);
        }while(colloc == 0x0F);
        delay_ms(20);
        colloc = (key_pin & 0x0F);
    }while(colloc == 0x0F);   
    
    
    
    while(1){ 

        key_prt = 0xEF;
        colloc = (key_pin &0x0F);
        if(colloc != 0x0F){ 
            rowloc = 0;
            break;
        }
        
            
        key_prt = 0xDF;
        colloc = (key_pin & 0x0F);
        if(colloc != 0x0F){
           rowloc = 1;
            break;               
        }  
            

        key_prt = 0xBF;
        colloc = (key_pin & 0x0F);
        if(colloc != 0x0F){
           rowloc = 2;
            break;               
        }   
    }   
    
    
    if(colloc == 0x0E){
        if(MenuOption == 1){
           if(rowloc == 0 ){
              code = 1;
              InsertORDelete();
           }
           else if (rowloc == 1){
              code = 2;
              InsertORDelete();
           }
           else if (rowloc == 2){
              code = 3;
              InsertORDelete();
           }
        }
          
        else{   
            CodeID = strcat(CodeID, keypad[rowloc][0]);
            lcd_print(keypad[rowloc][0]);
        }
    }
    else if(colloc == 0x0D){  
            CodeID = strcat(CodeID, keypad[rowloc][1]);
            lcd_print(keypad[rowloc][1]); 
    }
    else if(colloc == 0x0B){
            CodeID = strcat(CodeID, keypad[rowloc][2]);
            lcd_print(keypad[rowloc][2]);
    } 
    else{
    
        if(rowloc == 0 & registration == 2){
            Insert();
        }
        else if(rowloc == 0 & registration == 1){
            Delete();
        }
        else if(rowloc == 0){
            strcpy(result,CheckAccess());
            if(ShowMenu == 1){
                if(!(strcmp(result,"1"))){
                    ShowMyMenu();
                }
                else{
                    lcd_print("Access Denied!");
                    delay_ms(100);
                    CleenLCD();}
                ShowMenu = 0;
            }
            else if(!strcmp(result,"*")){
                lcd_print("Access Denied!");
                LED_Error();
                CleenLCD();
            }
            else{
                lcd_print("Access Granted!");
                LED_Ok();
                CleenLCD();
            } 
        }
        else if( rowloc == 2 ){
            lcd_print("Enter ID -> ");
            ShowMenu = 1;
        }
        else {
                 CodeID = strcat(CodeID, keypad[rowloc][3]);
                 lcd_print(keypad[rowloc][3]);
        }
    }
}









void main(void)
{   
    
    DDRD.0 = 1;
    DDRD.1 = 1;
    DDRD.2 = 1;
    LED_R = 0;
    LED_G = 0;
    LED_B = 0;
    
    key_ddr = 0xF0;
    key_prt = 0xFF;
    
    lcd_init();
    
    lcd_gotoxy(1,1);    
     
    
    while(1){
        ReadKeyPad();
    }
}