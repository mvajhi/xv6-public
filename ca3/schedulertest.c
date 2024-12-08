#include "types.h"
#include "stat.h"
#include "user.h"

void create_test_processes(void) {
    // Initialize values for the first process (init)
    init_estimations(1, 2, 50);
    change_queue(1, 0);

    // Fork multiple test processes
    for(int i = 0; i < 7; i++) {
        int pid = fork();
        
        if(pid == 0) {  // Child process
            // Set name for the test process
            // Note: The name will be set automatically to "scheduletest"
            
            // Initialize estimations for each process
            init_estimations(getpid(), 2, 50);
            
            // Set different queues for processes
            if(i < 2) {
                change_queue(getpid(), 0);
            } else {
                change_queue(getpid(), 2);
            }
            
            // Do some computation to create wait time
            int x = 0;
            for(int j = 0; j < i * 1000000; j++) {
                x = x + j;
            }
            
            // Keep the process running
            while(1) {
                // Busy wait
                for(int j = 0; j < 1000000; j++) {
                    x = x + j;
                }
            }
            
            exit();
        }
    }
}

int
main(void)
{
    printf(1, "Starting scheduler test...\n");
    
    // Create test processes
    create_test_processes();
    
    // Wait a bit to let processes run
    int x = 0;
    for(int i = 0; i < 1000000; i++) {
        x = x + i;
    }
    
    // Print process information
    print_info();
    
    // Wait for a while to see the scheduling in action
    sleep(100);
    
    // Print final state
    print_info();
    
    // Clean up by killing all test processes
    for(int i = 0; i < 7; i++) {
        wait();
    }
    
    exit();
}