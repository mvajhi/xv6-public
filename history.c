#include "types.h"
#include "stat.h"
#include "user.h"
char* str(char a){
    return &a;
}
void print_history(char** history_buffer,int recent_lines_num){
    int i;
    for(i=0;i<recent_lines_num;i++){
        int j = 0;
        while(1){
            if(history_buffer[i][j]!='\0'){
            printf(1,str(history_buffer[i][j]),1);j++;}
            else{
                printf(1,"\n",1);
                continue;
            }
        }
    }
}