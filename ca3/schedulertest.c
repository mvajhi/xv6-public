#include "types.h"
#include "stat.h"
#include "user.h"

void run_calculations(int iterations) {
    volatile int x = 0;
    for (int i = 0; i < iterations; i++) {
        x = (x + i) % 1000; // Simulate computation
    }
}

void create_test_processes(void) {
    printf(1, "Initializing estimation and queue for the init process (PID=1)\n");
    init_estimations(1, 2, 50);
    change_queue(1, 0);

    // Fork multiple test processes
    for (int i = 0; i < 7; i++) {
        int pid = fork();
        if (pid == 0) {  // Child process
            // Child: Initialize estimations
            printf(1, "Process %d: Initializing estimations (burst=2, confidence=50)\n", getpid());
            init_estimations(getpid(), 2, 50);

            // Child: Assign to queue
            if (i < 2) {
                printf(1, "Process %d: Assigned to queue 0\n", getpid());
                change_queue(getpid(), 0);
                print_info();
            } else {
                printf(1, "Process %d: Assigned to queue 2\n", getpid());
                change_queue(getpid(), 2);
                print_info();
            }

            // Simulate workload
            for (int j = 0; j < 5; j++) {
                run_calculations(1000000 + i * 500000);
                sleep(1); // Yield CPU
            }

            printf(1, "Process %d: Exiting...\n", getpid());
            exit();
        }
    }
}

int main(void) {
    printf(1, "Starting scheduler test program...\n");

    // Step 1: Create test processes
    create_test_processes();

    // Step 2: Let processes run for a while
    printf(1, "\nRunning initial calculations to simulate wait...\n");
    run_calculations(10000000);

    // Step 3: Print initial process information
    printf(1, "\nInitial Process State:\n");
    print_info();

    // Step 4: Allow processes to run and age
    printf(1, "\nLetting processes run for a while to accumulate CPU time...\n");
    sleep(100);

    // Step 5: Print updated process information
    printf(1, "\nUpdated Process State:\n");
    print_info();

    // Step 6: Wait for all child processes to exit
    for (int i = 0; i < 7; i++) {
        wait();
    }

    // Step 7: Print final process information
    printf(1, "\nFinal Process State (after cleanup):\n");
    print_info();

    printf(1, "\nTest program completed.\n");
    exit();
}