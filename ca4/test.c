#include "types.h"
#include "stat.h"
#include "user.h"
#include "defs.h"
#include "spinlock.h"

struct {
  struct reentrant_lock lock;
  int result;
} fuck_result;

void fuck(int i)
{
    acquire_reentrant(&fuck_result.lock);
    if (i <= 1)
    {
        fuck_result.result *= 1;
    }
    else
    {
        fuck(i-1);
        fuck_result.result *= i;
    }
    release_reentrant(&fuck_result.lock);
}

int
main(int argc, char *argv[])
{
    acquire_reentrant(&fuck_result.lock);
    InitReentrantLock(&fuck_result.lock, "fuck_you");
    fuck_result.result = 1;
    fuck(10);
    printf(1, "%i\n", fuck_result.result);
    fuck_result.result = 1;
    release_reentrant(&fuck_result.lock);
    exit();
}
