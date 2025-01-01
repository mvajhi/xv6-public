#include "types.h"
#include "stat.h"
#include "user.h"







void test_with_competition() {
    int pid;

    printf(1, "Starting competition test\n");

    if ((pid = fork()) == 0) {
        
        sleep(10); 
        test(20);
    } else {
       
        test(20);

        
        wait();
    }

    printf(1, "Finished competition test\n");
}

int main(int argc, char *argv[]) {

    printf(1, "Initializing reentrant lock\n");

    printf(1, "Running tests\n");
    test_with_competition();

    exit();
}
