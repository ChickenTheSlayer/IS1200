#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

#define COLUMNS 6

// print prime numbers in table
int N = 0;
int i = 0;
void print_number(int n){
  if ( i < COLUMNS -1){
    printf("%10d",n);
    i++;
  }
  else{
    printf("%10d ", n);
    printf("\n");
    i = 0;
  }
}

void print_sieves(int n){

  int j;
  bool numbers[n];
  
  for (int i = 0; i < n; i++)
    numbers[i] = true;

  for (int i = 2; i <= (int) sqrt(n); i++) {
    if (numbers[i]) {
      for (j = i*i; j < n; j += i)
	numbers[j] = false;
    }
  }
  int prev = 2;
  for (int i = 2; i < n; i++){
    if ((int) numbers[i])
      {
      if(i - prev == 4)
	N++;
      prev = i;
      print_number(i);
      }
  }

  printf("\n");
}



// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_sieves(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  printf("Number of 4 spaces: %d \n", N);
  return 0;

}
