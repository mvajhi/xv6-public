#include "types.h"
#include "stat.h"
#include "user.h"
#include "spinlock.h"

struct reentrant_lock test_lock;

void recursive_function(int depth) {
    if (depth <= 0)
        return;

    printf(1, "Thread %d acquiring lock at depth %d\n", getpid(), depth);
    reentrant_acquire(&test_lock);

    printf(1, "Thread %d acquired lock at depth %d\n", getpid(), depth);
    recursive_function(depth - 1);

    printf(1, "Thread %d releasing lock at depth %d\n", getpid(), depth);
    release_reentrant_lock(&test_lock);
}

void competing_function() {
    printf(1, "Competing thread %d trying to acquire lock\n", getpid());
    reentrant_acquire(&test_lock);
    printf(1, "Competing thread %d acquired lock (should not happen)\n", getpid());
    release_reentrant_lock(&test_lock);
    exit();
}

void test_with_competition() {
    int pid;

    printf(1, "Starting competition test\n");

    if ((pid = fork()) == 0) {
        // Child process: try to acquire the lock
        sleep(10); // Allow parent process to acquire lock first
        competing_function();
    } else {
        // Parent process: acquire the lock recursively
        recursive_function(50);

        // Wait for the child to finish
        wait();
    }

    printf(1, "Finished competition test\n");
}

int main(int argc, char *argv[]) {
    printf(1, "Initializing reentrant lock\n");
    InitReentrantLock(&test_lock, "test_lock");

    printf(1, "Running tests\n");
    test_with_competition();

    exit();
}
