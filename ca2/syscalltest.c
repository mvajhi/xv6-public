// syscalltest.c
#include "types.h"
#include "stat.h"
#include "user.h"

void test_syscalls(void) {
    printf(1, "=== Test 1: Basic System Call Counting ===\n");
    
    // Make specific number of system calls
    for(int i = 0; i < 200; i++) {
        getpid();  // SYS_getpid will be called 10 times
    }
    
    for(int i = 0; i < 5; i++) {
        sleep(1);  // SYS_sleep will be called 5 times
    }
    
    int pid = getpid();
    printf(1, "Current PID: %d\n", pid);
    
    // Test get_most_invoked_syscall
    int most_called = get_most_invoked_syscall(pid);
    printf(1, "Most called syscall ID: %d\n", most_called);
    printf(1, "Expected: SYS_getpid (11)\n");
    
    printf(1, "\n=== Test 2: Process Listing ===\n");
    list_all_processes();
}

void test_fork_behavior(void) {
    printf(1, "\n=== Test 3: Fork Behavior ===\n");
    
    int pid = fork();
    
    if(pid == 0) {
        // Child process
        for(int i = 0; i < 8; i++) {
            write(1, ".", 1);  // SYS_write will be called 8 times
        }
        printf(1, "\nChild process (PID: %d)\n", getpid());
        list_all_processes();
        exit();
    } else {
        // Parent process
        for(int i = 0; i < 3; i++) {
            sleep(1);  // SYS_sleep will be called 3 times
        }
        wait();
        printf(1, "Parent process (PID: %d)\n", getpid());
        list_all_processes();
    }
}

int
main(void)
{
    printf(1, "Starting System Call Tests...\n\n");
    
    test_syscalls();
    test_fork_behavior();
    
    printf(1, "\nAll tests completed!\n");
    exit();
}