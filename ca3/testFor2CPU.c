#include "types.h"
#include "stat.h"
#include "user.h"

// Function to perform CPU-intensive work
void cpu_work(int iterations) {
    int x = 0;
    for(int i = 0; i < iterations; i++) {
        for(int j = 0; j < 100000; j++) {
            x = x + j;
        }
    }
}

void create_test_processes(void) {
    // Initialize values for the first process (init)
    init_estimations(1, 2, 50);
    change_queue(1, 0);

    // Fork test processes for different queues and CPU affinity patterns
    for(int i = 0; i < 8; i++) {
        int pid = fork();
        
        if(pid == 0) {  // Child process
            // Set different estimations and queue assignments for testing
            init_estimations(getpid(), (i + 1) * 2, 50 + i * 5);
            
            // Distribute processes across queues
            int queue;
            if(i < 2) {
                queue = 0;      // High priority queue
            } else if(i < 4) {
                queue = 1;      // Medium priority queue
            } else {
                queue = 2;      // Low priority queue
            }
            change_queue(getpid(), queue);
            
            printf(1, "Process %d: PID=%d, Queue=%d\n", i, getpid(), queue);
            
            // Different workloads for different processes
            while(1) {
                // Vary the workload based on process number
                if(i % 2 == 0) {
                    // CPU-intensive work
                    cpu_work(1000000);
                } else {
                    // Mixed workload with some sleep
                    cpu_work(500000);
                    sleep(10);
                }
                
                // Print progress periodically
                printf(1, "Process %d (PID=%d, Queue=%d) running on CPU\n", 
                       i, getpid(), queue);
            }
            
            exit();
        }
    }
}

int
main(void)
{
    printf(1, "Starting dual-CPU scheduler test...\n");
    printf(1, "Creating 8 test processes with different priorities and workloads\n");
    
    create_test_processes();
    
    // Initial state
    printf(1, "\nInitial process state:\n");
    print_info();
    
    // Let processes run for a while
    sleep(200);
    
    // Print intermediate state
    printf(1, "\nIntermediate process state:\n");
    print_info();
    
    // Wait longer to observe scheduling patterns
    sleep(500);
    
    // Print final state
    printf(1, "\nFinal process state:\n");
    print_info();
    
    // Clean up processes
    for(int i = 0; i < 8; i++) {
        kill(i+4);  // Assuming PIDs start from 4
        wait();
    }
    
    printf(1, "Test completed\n");
    exit();
}