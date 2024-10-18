#include "types.h"
#include "stat.h"
#include "user.h"


#include "fcntl.h"
int len(char* str){
    int i =0;
    while(1){
        if(str[i]=='\0'){
            break;
        }
        else{
            i+=1;
        }
    }
    return i;
}
char* encode(char* str) {
    int key = 4;
    int lengh = len(str);
    

    for (int i = 0; i <= lengh; i++) {
        if (str[i]<='z' && str[i]>= 'a') {
            int base = 'a' ;
            str[i] = base + (str[i] - base - key+26) % 26;
        } else if(str[i] <= 'Z' && str[i]>='A'){
            int base = 'A' ;
            str[i] = base + (str[i] - base - key+26) % 26;
        }else{
            str[i] = str[i];
        }
    }

    return str;
}
int main(int argc,char *argv[]){
    int fd = open("result.txt",O_WRONLY|O_CREATE);
    if(fd < 0){
        printf(2,"can not open");
        exit();
    }
    int i;
    
    for(i=1;i<argc;i++){
       argv[i] = encode(argv[i]) ;
       if(i+1 == argc){
       if(write(fd,argv[i],len(argv[i]))!=len(argv[i])){
        printf(2,"can not write");
        exit();
       }
       write(fd,"\n",1);}
       else{
       if(write(fd,argv[i],len(argv[i]))!=len(argv[i])){
        printf(2,"can not write");
        exit();
       }
       write(fd," ",1);}       
       }
close(fd);
exit();
    
}