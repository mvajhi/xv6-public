// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

#include "making_math_simple.h"

// Special keycodes
#define KEY_HOME 0xE0
#define KEY_END 0xE1
#define KEY_UP 0xE2
#define KEY_DN 0xE3
#define KEY_LF 0xE4
#define KEY_RT 0xE5
#define KEY_PGUP 0xE6
#define KEY_PGDN 0xE7
#define KEY_INS 0xE8
#define KEY_DEL 0xE9

static void consputc(int);

static int panicked = 0;

static struct
{
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do
  {
    buf[i++] = digits[x % base];
  } while ((x /= base) != 0);

  if (sign)
    buf[i++] = '-';

  while (--i >= 0)
    consputc(buf[i]);
}
// PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if (locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint *)(void *)(&fmt + 1);
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
  {
    if (c != '%')
    {
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if (c == 0)
      break;
    switch (c)
    {
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if ((s = (char *)*argp++) == 0)
        s = "(null)";
      for (; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if (locking)
    release(&cons.lock);
}

void panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for (i = 0; i < 10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for (;;)
    ;
}

// PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort *)P2V(0xb8000); // CGA memory

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT + 1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT + 1);

  if (c == '\n')
    pos += 80 - pos % 80;
  else if (c == KEY_RT)
  {
    pos++;
    outb(CRTPORT + 1, pos);
    return;
  }
  else if (c == KEY_LF)
  {
    --pos;
    outb(CRTPORT + 1, pos);
    return;
  }
  else if (c == BACKSPACE)
  {
    if (pos > 0)
      --pos;
  }
  else
    crt[pos++] = (c & 0xff) | 0x0700; // black on white

  if (pos < 0 || pos > 25 * 80)
    panic("pos under/overflow");

  if ((pos / 80) >= 24)
  { // Scroll up.
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
    pos -= 80;
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT + 1, pos >> 8);
  outb(CRTPORT, 15);
  outb(CRTPORT + 1, pos);
  crt[pos] = ' ' | 0x0700;
}

void hostputc(int c)
{
  if (c == BACKSPACE)
  {
    uartputc('\b');
    uartputc(' ');
    uartputc('\b');
  }
  else if (c == KEY_LF || c == KEY_RT || c == KEY_UP || c == KEY_DN)
  {
    uartputc(0x1b);
    uartputc(0x5b);
    if (c == KEY_LF)
      uartputc(0x44);
    else if (c == KEY_RT)
      uartputc(0x43);
    else if (c == KEY_DN)
      uartputc(0x42);
    else if (c == KEY_UP)
      uartputc(0x41);
  }
  else
    uartputc(c);
}

void consputc(int c)
{
  if (panicked)
  {
    cli();
    for (;;)
      ;
  }

  hostputc(c);
  cgaputc(c);
}

#define INPUT_BUF 128
#define HISTORY_BUF 12 //! one more please :)

struct
{
  char buf[INPUT_BUF];
  char history[HISTORY_BUF][INPUT_BUF];
  int last_line_count;
  int history_line;
  int r; // Read index
  int w; // Write index
  int e; // Edit index
  int newline_pos;
  int end_pos;
  int current_pos;
  int is_press_ctrl_s;
  int index_of_ctrl_s;

} input;

#define C(x) ((x) - '@') // Control-x

#define ALL_OUTPUT 0
#define DEVICE_SCREEN 1
#define HOST_TERMINAL 2

void putc(int c, int output)
{
  if (output == ALL_OUTPUT)
    consputc(c);
  else if (output == DEVICE_SCREEN)
    cgaputc(c);
  else if (output == HOST_TERMINAL)
    hostputc(c);
}

void write_repeated(int count, int character, int output)
{
  for (int i = 0; i < count; i++)
    putc(character, output);
}

int can_move_L()
{
  return input.current_pos > input.newline_pos;
}

int can_move_R()
{
  return input.current_pos < input.end_pos;
}

void move_L()
{
  putc(KEY_LF, ALL_OUTPUT);
  input.current_pos--;
  
}

void move_R()
{
  putc(KEY_RT, ALL_OUTPUT);
  input.current_pos++;
  
}

void copy_array(char dest[], char src[])
{
  for (int i = 0; i < INPUT_BUF; i++)
    dest[i] = src[i];
}

void move_history()
{
  for (int i = HISTORY_BUF - 1; i > 0; i--)
    copy_array(input.history[i], input.history[i - 1]);
}

void store_buf_in_history()
{
  int j = 0;
  for (int i = input.newline_pos; i < input.e - 1; i++)
  {
    input.history[0][j] = input.buf[i];
    j++;
  }
  input.history[0][j] = '\0';
}

char *copy_buf(char *dest)
{
  int j = 0;
  for (int i = input.newline_pos; i < input.e - 1; i++)
  {
    dest[j] = input.buf[i];
    j++;
  }
  dest[j] = '\0';
  return dest;
}

void set_max_history()
{
  input.last_line_count++;
  if (input.last_line_count > HISTORY_BUF)
    input.last_line_count = HISTORY_BUF;
}

void store_line_in_history(char* tmp)
{
  input.history_line = 1;
  set_max_history();
  store_buf_in_history();
  copy_array(input.history[0], tmp);
  copy_array(input.history[1], input.history[0]);
  move_history();
}

void clean_buffer()
{
  for (int i = 0; i < INPUT_BUF; i++)
    input.buf[i] = '\0';
}

int is_history_command()
{
  for (int i = 0; i < INPUT_BUF - 7; i++)
  {
    if (input.history[0][i] == '\0' ||
        (input.history[0][i] != ' ' && input.history[0][i] != 'h'))
      return 0;
    if ((i == 0 || input.history[0][i - 1] == ' ') &&
        input.history[0][i + 0] == 'h' &&
        input.history[0][i + 1] == 'i' &&
        input.history[0][i + 2] == 's' &&
        input.history[0][i + 3] == 't' &&
        input.history[0][i + 4] == 'o' &&
        input.history[0][i + 5] == 'r' &&
        input.history[0][i + 6] == 'y' &&
        (input.history[0][i + 7] == ' ' || input.history[0][i + 7] == '\0'))
      return 1;
  }
  return 0;
}

void print_str_without_buffering(char *str, int output)
{
  for (int i = 0; i < INPUT_BUF; i++)
  {
    if (str[i] == '\0')
      return;
    putc(str[i], output);
  }
}

void print_row_index(int index)
{
  write_repeated(3, ' ', ALL_OUTPUT);
  printint(index, 10, 0);
  write_repeated(2, ' ', ALL_OUTPUT);
}

void handle_history_command()
{
  int oldest_index = input.last_line_count + 1;
  int first_index = 3;
  for (int i = oldest_index; i >= first_index; i--)
  {
    int index = oldest_index - i;
    print_row_index(index + 1);
    print_str_without_buffering(input.history[i], ALL_OUTPUT);
    putc('\n', ALL_OUTPUT);
  }
}

void execute_command()
{
  if (is_history_command())
    handle_history_command();

  wakeup(&input.r);
}

void move_buffer(int pos, int count)
{
  if (count > 0)
    for (int i = INPUT_BUF; i - count >= pos; i--)
      input.buf[i] = input.buf[i - count];
  else
    for (int i = pos; i < INPUT_BUF; i++)
      input.buf[i] = input.buf[i - count];
}


void replace_buf(char *str)
{
  int flag = 0;
  int j = 0;
  for (int i = input.newline_pos; i < input.e - 1; i++)
  {
    if (flag)
    {
      input.buf[i] = ' ';
    }
    else if (str[j] == '\0' || str[j] == '\n')
    {
      flag = 1;
      input.buf[i] = '\0';
    }
    else
    {
      input.buf[i] = str[j];
      j++;
    }
  }
}

void simple_math_expression(char *tmp)
{
  copy_buf(tmp);
  making_math_simple(tmp);
  replace_buf(tmp);
}

void handle_input_line()
{
  char tmp[INPUT_BUF];
  simple_math_expression(tmp);

  store_line_in_history(tmp);

  input.w = input.e;
  input.newline_pos = input.current_pos = input.end_pos = input.w;
  execute_command();
}

int is_end_of_line(int c)
{
  return c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF || input.end_pos - input.newline_pos == INPUT_BUF;
}

int fix_input_char(int c)
{
  return (c == '\r') ? '\n' : c;
}

int is_not_empty_char(int c)
{
  return c != 0 && input.e - input.r < INPUT_BUF;
}

void handle_end_line_in_buffer()
{
  input.current_pos = input.end_pos;
}

void save_char_in_buffer(int c)
{
  if (c == '\n')
    handle_end_line_in_buffer();

  int pos = input.e + (input.current_pos - input.end_pos);
  move_buffer(pos, 1);
  input.buf[pos] = c;
  input.e++;
}

void go_to_left(int count, int output)
{
  write_repeated(count, KEY_LF, output);
}

void clean_with_count(int count, int output)
{
  write_repeated(count, ' ', output);
  write_repeated(count, KEY_LF, output);
}

void print_buffer(int start, int end, int output)
{
  for (int i = start; i < end; i++)
  {
    int pos = input.e + (i - input.end_pos);
    putc(input.buf[pos], output);
  }
}

void print_char(int c)
{
  int len_to_end = input.end_pos - input.current_pos;

  putc(c, ALL_OUTPUT);
  clean_with_count(len_to_end, DEVICE_SCREEN);
  print_buffer(input.current_pos, input.end_pos, ALL_OUTPUT);
  go_to_left(len_to_end, ALL_OUTPUT);
}

void show_char_in_output(int c)
{
  
  input.current_pos++;
  input.end_pos++;
  if(input.is_press_ctrl_s && input.index_of_ctrl_s > input.current_pos){
    input.index_of_ctrl_s++;
  }

  print_char(c);
}

void store_char(int c)
{
  save_char_in_buffer(c);
  show_char_in_output(c);
}

void handle_char_input(int c)
{
  if (is_not_empty_char(c))
  {
    c = fix_input_char(c);
    store_char(c);
    if (is_end_of_line(c))
      handle_input_line();
  }
}

void remove_end_output(int output)
{
  int len_to_end = input.end_pos - input.current_pos;

  write_repeated(len_to_end + 1, KEY_RT, output);
  putc(BACKSPACE, output);
  go_to_left(len_to_end, output);
}

void clean_host_terminal()
{
  remove_end_output(HOST_TERMINAL);
}

void handle_backspace()
{
  
  input.current_pos--;
  input.end_pos--;
  input.e--;
  if(input.is_press_ctrl_s && input.index_of_ctrl_s > input.current_pos){
    input.index_of_ctrl_s--;
  }
  

  int pos = input.e + input.current_pos - input.end_pos;
  move_buffer(pos, -1);

  print_char(BACKSPACE);
  clean_host_terminal();
}

int can_move_U()
{
  return input.history_line <= input.last_line_count;
}

int can_move_D()
{
  return input.history_line > 0;
}

void print_line(char *line)
{
  for (int i = 0; i < INPUT_BUF; i++)
  {
    handle_char_input(line[i]);
    if (line[i] == '\0')
      return;
  }
}

void kill_line()
{
  while (can_move_R())
    move_R();
  while (can_move_L())
    handle_backspace();
}

void print_history_line()
{
  kill_line();
  print_line(input.history[input.history_line]);
}

void move_U()
{
  input.history_line++;
  print_history_line();
}

void move_D()
{
  if (input.history_line <= 2)
  {
    input.history_line = 1;
    kill_line();
  }
  else
  {
    input.history_line--;
    print_history_line();
  }
}
void handle_ctrl_s(){
  input.index_of_ctrl_s = input.current_pos;
  input.is_press_ctrl_s =1;

}
void handle_ctrl_f(){
  if(input.is_press_ctrl_s){
    int current_pos = input.current_pos;
    char buf[INPUT_BUF];
    for(int j = 0;j<INPUT_BUF;j++){
      buf[j] = input.buf[j];
    }
    if(current_pos >input.index_of_ctrl_s){
    for(int i =input.index_of_ctrl_s;i < current_pos;i++){
      if(buf[i]<='z' && buf[i]>='a'){
        handle_char_input(buf[i]);}
    }}
    else{
      for(int i =current_pos;i < input.index_of_ctrl_s;i++){
      if(buf[i]<='z' && buf[i]>='a'){
        handle_char_input(buf[i]);}
    }

    }
    input.is_press_ctrl_s =0;
  }
  

}
// TODO dosent handle arrow in host terminal input
void consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while ((c = getc()) >= 0)
  {
    switch (c)
    {
    case C('P'): // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('S'):
      handle_ctrl_s();
      break;
    case C('F'):
      handle_ctrl_f();
      break;
    case C('U'): // Kill line.
      kill_line();
      break;
    case C('H'): 
    case '\x7f': // Backspace
      if (can_move_L())
        handle_backspace();
      break;
    case KEY_LF: // Left arrow
      if (can_move_L())
        move_L();
      break;
    case KEY_RT: // Right arrow
      if (can_move_R())
        move_R();
      break;
    case KEY_UP:
      if (can_move_U())
        move_U();
      break;
    case KEY_DN:
      if (can_move_D())
        move_D();
      break;
    default:
      handle_char_input(c);
      break;
    }
  }
  release(&cons.lock);
  if (doprocdump)
  {
    procdump(); // now call procdump() wo. cons.lock held
  }
}

int consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while (n > 0)
  {
    while (input.r == input.w)
    {
      if (myproc()->killed)
      {
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if (c == C('D'))
    { // EOF
      if (n < target)
      {
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if (c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

void consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}

int consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for (i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

