#include "types.h"
#include "stat.h"
#include "user.h"

void print_separator() {
    printf(1, "\n----------------------------------------\n");
}

void test_init_estimations(int pid) {
    printf(1, "Testing init_estimations syscall:\n");
    
    // Test case 1: Valid inputs
    int result = init_estimations(pid, 50, 75);
    if(result == 0) {
        printf(1, "Test 1 Passed: Successfully initialized process %d with burst_time=50, confidence=75\n", pid);
    } else {
        printf(1, "Test 1 Failed: Could not initialize process %d\n", pid);
    }

    // Test case 2: Invalid confidence (>100)
    result = init_estimations(pid, 50, 150);
    if(result == -1) {
        printf(1, "Test 2 Passed: Correctly rejected invalid confidence value (150)\n");
    } else {
        printf(1, "Test 2 Failed: Accepted invalid confidence value\n");
    }

    // Test case 3: Invalid confidence (<0)
    result = init_estimations(pid, 50, -10);
    if(result == -1) {
        printf(1, "Test 3 Passed: Correctly rejected negative confidence value\n");
    } else {
        printf(1, "Test 3 Failed: Accepted negative confidence value\n");
    }

    print_separator();
}

void test_change_queue(int pid) {
    printf(1, "Testing change_queue syscall:\n");
    
    // Test moving to different queues
    int queues[] = {0, 1, 2};
    for(int i = 0; i < 3; i++) {
        int result = change_queue(pid, queues[i]);
        if(result == 0) {
            printf(1, "Successfully moved process %d to queue %d\n", pid, queues[i]);
        } else {
            printf(1, "Failed to move process %d to queue %d\n", pid, queues[i]);
        }
        // Print current state after each change
        print_info();
    }

    print_separator();
}

void test_print_info() {
    printf(1, "Testing print_info syscall:\n");
    printf(1, "Current system state:\n");
    print_info();
    print_separator();
}

int main(int argc, char *argv[]) {
    printf(1, "Starting System Calls Test Program\n");
    print_separator();

    int pid = getpid();
    printf(1, "Current process PID: %d\n", pid);
    print_separator();

    // Create a child process for additional testing
    int child_pid = fork();
    
    if(child_pid < 0) {
        printf(1, "Fork failed\n");
        exit();
    }

    if(child_pid == 0) {
        // Child process
        printf(1, "Child process (PID: %d) tests:\n", getpid());
        print_separator();
        
        // Test syscalls in child process
        test_init_estimations(getpid());
        test_change_queue(getpid());
        test_print_info();
        
        exit();
    } else {
        // Parent process
        printf(1, "Parent process (PID: %d) tests:\n", pid);
        print_separator();
        
        // Test syscalls in parent process
        test_init_estimations(pid);
        test_change_queue(pid);
        test_print_info();
        
        // Wait for child to finish
        wait();
    }

    printf(1, "All tests completed.\n");
    exit();
}