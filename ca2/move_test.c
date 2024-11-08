#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int main(int argc, char *argv[]) {
  

  if (move_file(argv[1], argv[2]) < 0) {
    printf(2, "move: failed to mov\n");
  } else {
    printf(1, "File moved successfully from\n");
  }
    exit();

}