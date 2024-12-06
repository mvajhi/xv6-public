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
            // printf(1,"%d\n",1);
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
            // printf(1,"%d\n",2);
        }
        exit();
    }
    for (int i = 0; i < 400; i++)
    {
        printf(1, "%d for parent\n", i);
        // printf(1,"%d\n",0);
    }
    wait();
    wait();
    exit();

    return 0;
}