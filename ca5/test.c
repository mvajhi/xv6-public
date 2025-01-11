#include "types.h"
#include "stat.h"
#include "user.h"
#include "spinlock.h"

#define PAGE 82

struct fac {
    int value;
    int index;
    struct spinlock lock;
};

void factorial(int count) {
    struct fac* adr = (struct fac*)openshmem(PAGE);
    initspin(&adr[0].lock);
    accspin(&adr[0].lock);
    adr[0].value = 1;
    adr[0].index = 1;
    printf(1, "%d\n", adr[0].value);
    relspin(&adr[0].lock);

    for (int i = 1; i < count; i++) {
        if (fork() == 0) {
            struct fac* adrs = (struct fac*)openshmem(PAGE);
            for (int j = 0; j < 100000; j++)
                ;
            accspin(&adr[0].lock);


            adrs[0].value *= i;
            // adrs[0].value *= ++adrs[0].index;
            printf(1, "%d\n", adrs[0].value);

            relspin(&adr[0].lock);
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