#include "vowel.data.h"
#include "stdio.h"

/*
 * #define NO_SPEAKERS 90
#define NO_TRAIN    48
#define NO_VOWELS   11
#define NO_INPUTS   10
*/
int main(int argc, char **argv, char **envp, char **apple) {

    int ii, jj, kk;
    char firstTime = 0;
    for (ii = 0; ii < NO_SPEAKERS ; ii++) {
        for (jj = 0; jj < NO_VOWELS ; jj++) {
            firstTime = 1;
            for (kk = 0; kk < NO_INPUTS; kk++) {
                if (!firstTime) {
                    printf(",");
                }
                firstTime = 0;
                printf("%f", voweldata[ii][jj][kk]);
            }
            printf(",%d\n", jj);
        }
    }
    return 0;
}
