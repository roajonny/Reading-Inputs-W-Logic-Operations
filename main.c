#include <stdio.h>
#include <string.h>
#include <math.h>
#define M_PI   3.14159265358979323846264338327950288
int main() {
	int i;
	int index = 0;
	signed int j[92];
	float sin_val;
	FILE *fp;
	
	if((fp=fopen("sindata.txt" , "w")) == NULL) {
		printf("File could not be opened for writing\n");
		exit(1);
	}
	for (i = 0; i <= 90; i++) {
		/* convert to radians */
		sin_val = sin(M_PI*i/180.0);
		/* convert to Q31 notation */
		j[i] = sin_val * (2147483648);
	}
	for (i = 1; i <= 23; i++) {
		fprintf(fp, "DCD");
		fprintf(fp, "0x%x,", j[index]);
		fprintf(fp, "0x%x,", j[index+1]);
		fprintf(fp, "0x%x,", j[index+2]);
		fprintf(fp, "0x%x,", j[index+3]);
		fprintf(fp, "\n");
		index += 4;
	}
fclose(fp);
}
