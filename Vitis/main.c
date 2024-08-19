#include <stdio.h>
#include <math.h>
#include "xil_printf.h"
#include "xil_io.h"

#define C_BASE_MAX31865 0x44A00000

float calculateTemperature(unsigned short RTDraw){
	const float RTD_A = 3.9083e-3;
	const float RTD_B = -5.775e-7;

	const float RTDnominal = 100.0;
	const float refResistor = 430.0;

	float Z1, Z2, Z3, Z4, Rt, temp;

	Rt = RTDraw;
	Rt /= 32768;
	Rt *= refResistor;

	// Serial.print("\nResistance: "); Serial.println(Rt, 8);

	Z1 = -RTD_A;
	Z2 = RTD_A * RTD_A - (4 * RTD_B);
	Z3 = (4 * RTD_B) / RTDnominal;
	Z4 = 2 * RTD_B;

	temp = Z2 + (Z3 * Rt);
	temp = (sqrt(temp) + Z1) / Z4;

	if (temp >= 0)
	return temp;

	// ugh.
	Rt /= RTDnominal;
	Rt *= 100; // normalize to 100 ohm

	float rpoly = Rt;

	temp = -242.02;
	temp += 2.2228 * rpoly;
	rpoly *= Rt; // square
	temp += 2.5859e-3 * rpoly;
	rpoly *= Rt; // ^3
	temp -= 4.8260e-6 * rpoly;
	rpoly *= Rt; // ^4
	temp -= 2.8183e-8 * rpoly;
	rpoly *= Rt; // ^5
	temp += 1.5243e-10 * rpoly;

	return temp;
}

unsigned short read_MAX31865(){
	return Xil_In32(C_BASE_MAX31865);
}

void printFloat(float f){
	int whole = f;
	int thousandths = (f - whole) * 1000;
	xil_printf("%d.%03d ", whole, thousandths);
}


int main()
{
    print("\nMicroBlaze and MAX31865\n\r");
    print("RTD  | T(C)\n\r");

    while(1){
    	unsigned short rtd = read_MAX31865() >> 1;
    	float temp = calculateTemperature(rtd);
    	xil_printf("%d | ", rtd);
    	printFloat(temp);
    	print("\r");

    	asm("LOOP1:");
    	asm("addi r20, r20, -512");     // 1 clock
    	asm("bnei r20, LOOP1");   // 1 clock if branch not taken, 3 clocks if taken
    }
    return 0;
}
