#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

const int FIFO = 0;
const int SJF = 1;
const int RR = 2;

struct
{
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int cpuid()
{
  return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void)
{
  int apicid, i;

  if (readeflags() & FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i)
  {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void)
{
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

// PAGEBREAK: 32
//  Look in the process table for an UNUSED proc.
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->burst_time = 2;
  p->confidence = 50;
  p->enter_time = ticks;
  p->queue_number = FIFO;
  if (p->pid <= 2)
    p->queue_number = RR;
  cprintf("Burst time: %d\n", p->burst_time);

  release(&ptable.lock);

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
  {
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe *)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

// PAGEBREAK: 32
//  Set up first user process.
void userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if ((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0; // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if (n > 0)
  {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  else if (n < 0)
  {
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
  {
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for (i = 0; i < NOFILE; i++)
    if (curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if (curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++)
  {
    if (curproc->ofile[fd])
    {
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->parent == curproc)
    {
      p->parent = initproc;
      if (p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE)
      {
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
    {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
  }
}

void sort_processes(void)
{
  struct proc *p;
  struct proc *arg_min;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state != RUNNABLE || p->queue_number != SJF)
      continue;
    arg_min = p;
    for (struct proc *i = p + 1; i < &ptable.proc[NPROC]; i++)
    {
      if (i->state != RUNNABLE || i->queue_number != SJF)
        continue;
      if (arg_min->burst_time > i->burst_time && arg_min->pid != i->pid)
      {
        arg_min = i;
      }
    }
    if (arg_min != p)
    {
      // cprintf("Swapped %d with %d\n", p->pid, arg_min->pid);
      // cprintf("state pid %d: %d\n", p->pid, p->state);
      // cprintf("state pid %d: %d\n", arg_min->pid, arg_min->state);
      struct proc temp = *p;
      *p = *arg_min;
      *arg_min = temp;
    }
  }
}

void handle_change_queue(void)
{
  struct proc *p;

  int queue = RR;
  if (mycpu()->RR > 0)
    queue = RR;
  else if (mycpu()->SJF > 0)
    queue = SJF;
  else if (mycpu()->FCFS > 0)
    queue = FIFO;
  else
  {
    mycpu()->RR = 3;
    mycpu()->ticks = 0;
  }

  int is_empty = 1;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state != RUNNABLE)
      continue;
    if (p->queue_number != queue)
      continue;
    is_empty = 0;
  }

  if (is_empty)
  {
    mycpu()->ticks = 0;
    if (queue == RR)
    {
      mycpu()->RR = 0;
      mycpu()->SJF = 2;
      mycpu()->FCFS = 0;
      mycpu()->RR_proc = ptable.proc;
    }
    else if (queue == SJF)
    {
      mycpu()->RR = 0;
      mycpu()->SJF = 0;
      mycpu()->FCFS = 1;
    }
    else if (queue == FIFO)
    {
      mycpu()->RR = 3;
      mycpu()->SJF = 0;
      mycpu()->FCFS = 0;
    }
  }
}

void RR_scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  for (int i = 0; i < NPROC; i++)
  {
    p = ((mycpu()->RR_proc - &ptable.proc[0]) + i) % NPROC + &ptable.proc[0];
    if (p->state != RUNNABLE || p->queue_number != RR)
      continue;
    c->proc = p;
    switchuvm(p);
    p->state = RUNNING;
    p->age = 0;
    swtch(&(c->scheduler), p->context);
    switchkvm();
    mycpu()->RR_proc = p + 1;

    c->proc = 0;
    return;
  }
}

void SJF_scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  sort_processes();

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state != RUNNABLE || p->queue_number != SJF)
      continue;

    int random = ticks * (p->pid + 1) + ((int)p->name[0] + 1) * 357 + 666;
    random = ((random * random) % 100);

    // cprintf("Random number: %d for pid: %d\n", random, p->pid);
    if (random > p->confidence)
      continue;
    // cprintf("Random number: %d for pid: %d\n", random, p->pid);

    c->proc = p;
    switchuvm(p);
    p->state = RUNNING;
    p->age = 0;

    swtch(&(c->scheduler), p->context);
    switchkvm();

    c->proc = 0;
    return;
  }
}

void FCFS_scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  struct proc *first = ptable.proc;

  int iter = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state != RUNNABLE || p->queue_number != FIFO)
      continue;
    iter += 1;
    if (iter == 1)
    {
      first = p;
      continue;
    }
    else
    {
      if (p->enter_time < first->enter_time)
      {
        first = p;
        continue;
      }
    }
  }
  // Switch to chosen process.  It is the process's job
  // to release ptable.lock and then reacquire it
  // before jumping back to us.
  if (iter == 0)
  {
    c->proc = 0;
    return;
  }

  c->proc = first;

  switchuvm(first);
  first->state = RUNNING;
  p->age = 0;

  swtch(&(c->scheduler), first->context);
  switchkvm();

  // Process is done running for now.
  // It should have changed its p->state before coming back.
  c->proc = 0;
}

// PAGEBREAK: 42
//  Per-CPU process scheduler.
//  Each CPU calls scheduler() after setting itself up.
//  Scheduler never returns.  It loops, doing:
//   - choose a process to run
//   - swtch to start running that process
//   - eventually that process transfers control
//       via swtch back to the scheduler.
void scheduler(void)
{
  for (;;)
  {
    sti();

    acquire(&ptable.lock);
    handle_change_queue();

    if (mycpu()->RR > 0)
      RR_scheduler();
    else if (mycpu()->SJF > 0)
      SJF_scheduler();
    else if (mycpu()->FCFS > 0)
      FCFS_scheduler();

    else
      panic("No queue selected");

    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&ptable.lock))
    panic("sched ptable.lock");
  if (mycpu()->ncli != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (readeflags() & FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  acquire(&ptable.lock); // DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first)
  {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock)
  {                        // DOC: sleeplock0
    acquire(&ptable.lock); // DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if (lk != &ptable.lock)
  { // DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

// PAGEBREAK!
//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [EMBRYO] "embryo",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if (p->state == SLEEPING)
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

void update_age(void)
{
  struct proc *p;
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state != RUNNABLE || p->pid < 3)
    {
      p->age = 0;
      continue;
    }
    p->age++;
  }
  release(&ptable.lock);
}

void update_queue_number(void)
{
  acquire(&ptable.lock);
  for (struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    // TODO 80 -> 800
    if (p->queue_number == RR || p->age < 80 || p->pid < 3)
      continue;
    p->queue_number++;
    p->age = 0;
    p->enter_time = ticks;
    cprintf("Process %d moved to queue %d\n", p->pid, p->queue_number);
  }
  release(&ptable.lock);
}

void update_ticks(void)
{
  acquire(&ptable.lock);
  for (struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state != RUNNABLE || p->pid < 3)
      continue;
    p->burst_time--;
    cprintf("Burst time for %d: %d\n", p->pid, p->burst_time);
  }
  release(&ptable.lock);
}

// TODO

// sysproc.c (add these implementations)
int sys_init_estimations(void)
{
  int pid, burst_time, confidence;

  if (argint(0, &pid) < 0 || argint(1, &burst_time) < 0 || argint(2, &confidence) < 0)
    return -1;

  if (confidence < 0 || confidence > 100)
    return -1;

  struct proc *p;
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->burst_time = burst_time;
      p->confidence = confidence;
      break;
    }
  }
  release(&ptable.lock);
  return 0;
}

int sys_change_queue(void)
{
  int pid, queue_num;

  if (argint(0, &pid) < 0 || argint(1, &queue_num) < 0)
    return -1;

  struct proc *p;
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->queue_number = queue_num;
      break;
    }
  }
  release(&ptable.lock);
  return 0;
}





int digitcount(int num) {
    if (num == 0) return 1;
    int count = 0;
    while (num != 0) {
        num = num / 10;
        count++;
    }
    return count;
}


void printspaces(int count) {
    for (int i = 0; i < count; i++) {
        cprintf(" ");
    }
}


int
sys_print_info(void)
{
    static char *states[] = {
        [UNUSED]    "unused",
        [EMBRYO]    "embryo",
        [SLEEPING]  "sleep",
        [RUNNABLE]  "runnable",
        [RUNNING]   "running",
        [ZOMBIE]    "zombie"
    };
    
    static int columns[] = {16, 8, 12, 8, 8, 8, 8, 8};
    
    acquire(&ptable.lock);
    
    cprintf("Name           PID     State       Queue   Burst   Conf    Age     Enter\n");
    cprintf("-------------------------------------------------------------------------\n");
    
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if(p->state == UNUSED)
            continue;
            
        const char *state;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
            
        cprintf("%s", p->name);
        printspaces(columns[0] - strlen(p->name));
        
        cprintf("%d", p->pid);
        printspaces(columns[1] - digitcount(p->pid));
        
        cprintf("%s", state);
        printspaces(columns[2] - strlen(state));
        
        cprintf("%d", p->queue_number);
        printspaces(columns[3] - digitcount(p->queue_number));
        
        cprintf("%d", p->burst_time);
        printspaces(columns[4] - digitcount(p->burst_time));
        
        cprintf("%d", p->confidence);
        printspaces(columns[5] - digitcount(p->confidence));
        
        cprintf("%d", p->age);
        printspaces(columns[6] - digitcount(p->age));
        

        cprintf("%d", p->enter_time);
        printspaces(columns[7] - digitcount(p->enter_time));
        
        cprintf("\n");
    }
    
    release(&ptable.lock);
    return 0;
}