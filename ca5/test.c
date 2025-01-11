#include "types.h"
#include "stat.h"
#include "user.h"

#define PAGE 82

void factorial(int count) {
    char* adr = openshmem(PAGE);
    adr[0] = 1;
    printf(1, "%d\n", adr[0]);

    for (int i = 1; i <= count; i++) {
        if (fork() == 0) {
            int* adrs = (int*)openshmem(PAGE);
            adrs[0] *= i;
            printf(1, "%d\n", adrs[0]);
            closeshmem(PAGE);
            exit();
        }
    }
    for (int i = 0; i < count; i++)
        wait();
    closeshmem(PAGE);
}

int main(int argc, char* argv[]) {
    if(argc <= 1){
        printf(2, "Usage: test number\n");
        exit();
    }

    factorial(atoi(argv[1]));
    exit();
}