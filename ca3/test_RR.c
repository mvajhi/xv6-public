#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
int main(int argc,char* argv[]){
    int pid = fork();
    if(pid < 0){
        return 1;
    }
    if(pid == 0){
        for (int i=0;i<1000000;i++){
            printf(1,"%d for child\n",i);
        }
    }
    else
    {
        for (int i=0;i<1000000;i++){
            printf(1,"%d for parent\n",i);
        }        
    }
    return 0;
}