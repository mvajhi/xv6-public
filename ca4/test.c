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

void simple_test() {
    printf(1, "Starting simple test\n");

    recursive_function(3);

    printf(1, "Finished simple test\n");
}

int main(int argc, char *argv[]) {
    printf(1, "Initializing reentrant lock\n");
    InitReentrantLock(&test_lock, "test_lock");

    printf(1, "Running tests\n");
    simple_test();

    exit();
}
