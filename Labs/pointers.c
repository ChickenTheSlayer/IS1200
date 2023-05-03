

#include <stdlib.h>
#include <stdio.h>

char* text1 = "This is a string.";
char* text2 = "Yet another thing.";

void copycodes(char* text, int* list, int* count) { //initialized as pointer
    
    while(*text != 0) {
        
        *list = *text; //sw    $t0,0($a1)
        
        text++; //addi    $a0,$a0,1  because char only 1 byte
        list++; //addi    $a1,$a1,4  because int is 4 bytes
        
		    *count = *count + 1;// what pointer points to *dereferencing because we change content inside memory that pointer points to.
    }
}
// increment pointer: you have an adress and you increment and read everything 
// c code has compiler that works with primitive type value, mips you have to specify memory you work with ie. int = 4 bytes
// pointer increment memory, increment variable -> smth that pointer points to 
//A big-endian system stores the most significant byte of a word at the smallest memory address and the least significant byte at the largest. 
// A little-endian system, in contrast, stores the least-significant byte at the smallest address.

void work(){
	copycodes(text1, list1, &count);//& is used to get the address of the variable
	copycodes(text2, list2, &count);

}

void printlist(const int* lst){
  printf("ASCII codes and corresponding characters.\n");
  while(*lst != 0){
    printf("0x%03X '%c' ", *lst, (char)*lst);
    lst++;
  }
  printf("\n");
}

void endian_proof(const char* c){
  printf("\nEndian experiment: 0x%02x,0x%02x,0x%02x,0x%02x\n", 
         (int)*c,(int)*(c+1), (int)*(c+2), (int)*(c+3));
  
}

int main(void){
  work();

  printf("\nlist1: ");
  printlist(list1);
  printf("\nlist2: ");
  printlist(list2);
  printf("\nCount = %d\n", count);

  endian_proof((char*) &count);
}
