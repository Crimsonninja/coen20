/*
 * @author Jonathan Trinh
 * @date 09262017
 * This lab is to implement two functions that will convert decimal to binary and vice versa.
 */
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "library.h"

/*
 * Function: Dec2Bin
 * @param x - the number that we will convert to binary
 * @param bin - the array that we will store the binary numbers in
 * Summary: Dec2Bin converts a base 10 (decimal) number to binary with rounding. Because, the input is
 *          restricted between 0 and 1, the number is multiplied by 256 and is subsequently rounded.
 *          We then perform integer division on that number.
 */
void Dec2Bin(float x, int bin[8]) {
	// To be implemented by student
	// Input Parameter: 0.0 < X < 1.0
	// Output Parameter: bin[0] = Least significant bit
	//                   bin[7] = Most significant bit
	// Return value: None

	double theNum = x * 256;                // We define another double that holds the number multiplied by 256
    int actualNum = (int)theNum;            // For now, we assume that the real number that we are operating on is rounded down

	if ((theNum-actualNum)>=0.5) {          // If theNum's fractional part is greater or equal to 0.5, then we add 1 to actualNum
        actualNum =  (int) theNum + 1;
	}

	for (int i = 0; i < 8; i++) {           // We perform integer division and loop 8 times
        bin[i] = actualNum%2;               // Each time we store the remainder in the the array
        actualNum = actualNum/2;            // and divide actualNum by 2
	}
}

/*
 * Function: Bin2Dec
 * @param bin - the array that represents the binary number given
 * Summary: Dec2Bin converts a binary number to decimal with rounding using a modified version of polynomial
 *          evaluation. We start by assuming that the number is an integer, perform the polynomial evaluation,
 *          and divide by 256 (2 to the 8).
 */
float Bin2Dec(int bin[8]) {
	// To be implemented by student
	// Input Parameter: bin[0] = Least significant bit
	//                  bin[7] = Most significant bit
	// Return value: 0.0 < float < 1.0
	int theNum = 0;                     // we define a variable to hold the number (that will be divided by 256)
	for (int i = 7; i >=0; i--) {       // we loop backwards (since 7 is the most significant bit) and perform polynomial evaluation
    	theNum = 2 * theNum + bin[i];
	}
	return (float) theNum/256;          // return the number by 256
}

void PrintBinary(int bin[8]) ;

#define ENTRIES(a) (sizeof(a)/sizeof(a[0]))

typedef struct
	{
	float	x ;
	int		rounded ;
	int     truncated ;
	} TESTCASE ;

int Correct(int [8], TESTCASE *) ;

int main(void)
	{
	TESTCASE testcase[] =
		{
		{0.005,	  1,    1},
		{0.010,	  3,    2},
		{0.050,  13,   12},
		{0.100,  26,   25},
		{0.300,  77,   76},
		{0.700, 179,  179},
		{0.900, 230,  230}
		} ;
	int k ;

	InitializeHardware(HEADER, "LAB #1") ;

	for (k= 0; k < ENTRIES(testcase); k++)
		{
		float x1, x2, abserr, percent ;
		int bin[8] ;

		x1 = testcase[k].x ;
		printf("Testcase #%d:  x = %f\n", k + 1, x1) ;

		Dec2Bin(x1, bin) ;
		PrintBinary(bin) ;
		switch (Correct(bin, &testcase[k]))
			{
            case 0: // correct (rounded)
                x2 = Bin2Dec(bin) ;
                printf("Back to Decimal = %f\n", x2) ;
                abserr = fabs(x1 - x2) ;
                percent = 100 * abserr / x1 ;
                printf("Difference = %f (%.2f%c)\n", abserr, percent, '%') ;
                break ;
            case 1: // incorrect (truncated)
                printf("--- ERROR: NOT ROUNDED! ---\n") ;
                break ;
            case 2: // incorrect (wrong)
                printf("--- ERROR: BAD CONVERSION! ---\n") ;
                break ;
			}

		printf("\nPress blue push button to continue\n") ;
		WaitForPushButton() ;
		ClearDisplay() ;
		}

	printf("--- FINISHED ---\n") ;
	while (1) ;


	return 0 ;
	}

void PrintBinary(int bin[8])
	{
	// bin[0] = Least significant bit
	// bin[7] = Most significant bit
	int k ;

	printf("Converted 2 Bin = 0.") ;
	for (k = 7; k >= 0; k--) printf("%d", bin[k]) ;
	printf("\n") ;
	}

int Correct(int bin[8], TESTCASE *t)
	{
	// bin[0] = Least significant bit
	// bin[7] = Most significant bit
	int k, dec ;

    dec = 0 ;
	for (k = 7; k >= 0; k--)
		{
        dec = 2 * dec + bin[k] ;
		}
    if (dec == t->rounded) return 0 ;
    if (dec == t->truncated) return 1 ;
    return 2 ;
	}
