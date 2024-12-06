#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
int main(int argc, char *argv[])
{
    int pid = fork();
    if (pid < 0)
    {
        return 1;
    }
    if (pid == 0)
    {
        for (int i = 0; i < 100; i++)
        {
            printf(1, "%d for child1\n", i);
        }
        exit();
    }
    pid = fork();
    if (pid < 0)
    {
        return 1;
    }
    if (pid == 0)
    {
        for (int i = 0; i < 100; i++)
        {
            printf(1, "%d for child2\n", i);
        }
        exit();
    }
    for (int i = 0; i < 400; i++)
    {
        printf(1, "%d for parent\n", i);
    }
    wait();
    wait();
    exit();

    return 0;
}