
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 52 11 80       	mov    $0x801152f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 30 10 80       	mov    $0x80103080,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 74 10 80       	push   $0x80107440
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 85 44 00 00       	call   801044e0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 74 10 80       	push   $0x80107447
80100097:	50                   	push   %eax
80100098:	e8 13 43 00 00       	call   801043b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 e7 45 00 00       	call   801046d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 09 45 00 00       	call   80104670 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 42 00 00       	call   801043f0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 8f 21 00 00       	call   80102320 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 4e 74 10 80       	push   $0x8010744e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 cd 42 00 00       	call   80104490 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 47 21 00 00       	jmp    80102320 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 74 10 80       	push   $0x8010745f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 42 00 00       	call   80104490 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 3c 42 00 00       	call   80104450 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 b0 44 00 00       	call   801046d0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 02 44 00 00       	jmp    80104670 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 66 74 10 80       	push   $0x80107466
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 37 16 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 2b 44 00 00       	call   801046d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 be 3d 00 00       	call   80104090 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 e9 36 00 00       	call   801039d0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 75 43 00 00       	call   80104670 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 ec 14 00 00       	call   801017f0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 1f 43 00 00       	call   80104670 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 96 14 00 00       	call   801017f0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 82 25 00 00       	call   80102920 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 74 10 80       	push   $0x8010746d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 12 79 10 80 	movl   $0x80107912,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 33 41 00 00       	call   80104500 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 74 10 80       	push   $0x80107481
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 5c 5b 00 00       	call   80105f80 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 91 5a 00 00       	call   80105f80 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 85 5a 00 00       	call   80105f80 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 79 5a 00 00       	call   80105f80 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 da 43 00 00       	call   80104940 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 35 43 00 00       	call   801048b0 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 85 74 10 80       	push   $0x80107485
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 0c 13 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 00 41 00 00       	call   801046d0 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ef 10 80       	push   $0x8010ef20
80100604:	e8 67 40 00 00       	call   80104670 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 de 11 00 00       	call   801017f0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 64 79 10 80 	movzbl -0x7fef869c(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ef 10 80       	push   $0x8010ef20
801007d8:	e8 f3 3e 00 00       	call   801046d0 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ef 10 80       	push   $0x8010ef20
801007fb:	e8 70 3e 00 00       	call   80104670 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 98 74 10 80       	mov    $0x80107498,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 9f 74 10 80       	push   $0x8010749f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ef 10 80       	push   $0x8010ef20
801008b3:	e8 18 3e 00 00       	call   801046d0 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ef 10 80       	push   $0x8010ef20
801008ed:	e8 7e 3d 00 00       	call   80104670 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100914:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100933:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010094a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010095e:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100998:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100a05:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a27:	68 00 ef 10 80       	push   $0x8010ef00
80100a2c:	e8 1f 37 00 00       	call   80104150 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 dc 37 00 00       	jmp    80104230 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 a8 74 10 80       	push   $0x801074a8
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 6b 3a 00 00       	call   801044e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 12 1a 00 00       	call   801024b0 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "elf.h"
#include "mp.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 0f 2f 00 00       	call   801039d0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 c4 22 00 00       	call   80102d90 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 f9 15 00 00       	call   801020d0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 7a 03 00 00    	je     80100e5c <exec+0x3ac>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 03 0d 00 00       	call   801017f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 02 10 00 00       	call   80101b00 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 d1 65 00 00       	call   801070f0 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 eb 02 00 00    	je     80100e2c <exec+0x37c>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 90 63 00 00       	call   80106f20 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 8a 62 00 00       	call   80106e50 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 12 0f 00 00       	call   80101b00 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  cpus[3].nsyscall = 0;
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 68 64 00 00       	call   80107070 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 6c 0e 00 00       	call   80101a80 <iunlockput>
    end_op();
80100c14:	e8 e7 21 00 00       	call   80102e00 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 2f 0e 00 00       	call   80101a80 <iunlockput>
  end_op();
80100c51:	e8 aa 21 00 00       	call   80102e00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 b9 62 00 00       	call   80106f20 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 08 65 00 00       	call   80107190 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 a0 01 00 00    	je     80100e38 <exec+0x388>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 d1 3d 00 00       	call   80104aa0 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 c0 3d 00 00       	call   80104aa0 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 6d 66 00 00       	call   80107360 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 68 63 00 00       	call   80107070 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 fc 65 00 00       	call   80107360 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 bc 3c 00 00       	call   80104a60 <safestrcpy>
  curproc->pgdir = pgdir;
80100da4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100daa:	89 f0                	mov    %esi,%eax
80100dac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100daf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100db1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db4:	89 c1                	mov    %eax,%ecx
80100db6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbc:	8b 40 18             	mov    0x18(%eax),%eax
80100dbf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc2:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc8:	89 0c 24             	mov    %ecx,(%esp)
80100dcb:	e8 f0 5e 00 00       	call   80106cc0 <switchuvm>
  freevm(oldpgdir);
80100dd0:	89 34 24             	mov    %esi,(%esp)
80100dd3:	e8 98 62 00 00       	call   80107070 <freevm>
  acquire(&nsys.lk);
80100dd8:	c7 04 24 40 3a 11 80 	movl   $0x80113a40,(%esp)
80100ddf:	e8 ec 38 00 00       	call   801046d0 <acquire>
  nsys.n = 0;
80100de4:	c7 05 74 3a 11 80 00 	movl   $0x0,0x80113a74
80100deb:	00 00 00 
  release(&nsys.lk);
80100dee:	c7 04 24 40 3a 11 80 	movl   $0x80113a40,(%esp)
80100df5:	e8 76 38 00 00       	call   80104670 <release>
  return 0;
80100dfa:	83 c4 10             	add    $0x10,%esp
80100dfd:	31 c0                	xor    %eax,%eax
  cpus[0].nsyscall = 0;
80100dff:	c7 05 50 18 11 80 00 	movl   $0x0,0x80111850
80100e06:	00 00 00 
  cpus[1].nsyscall = 0;
80100e09:	c7 05 04 19 11 80 00 	movl   $0x0,0x80111904
80100e10:	00 00 00 
  cpus[2].nsyscall = 0;
80100e13:	c7 05 b8 19 11 80 00 	movl   $0x0,0x801119b8
80100e1a:	00 00 00 
  cpus[3].nsyscall = 0;
80100e1d:	c7 05 6c 1a 11 80 00 	movl   $0x0,0x80111a6c
80100e24:	00 00 00 
  return 0;
80100e27:	e9 f5 fd ff ff       	jmp    80100c21 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e2c:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e31:	31 f6                	xor    %esi,%esi
80100e33:	e9 10 fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e38:	be 10 00 00 00       	mov    $0x10,%esi
80100e3d:	ba 04 00 00 00       	mov    $0x4,%edx
80100e42:	b8 03 00 00 00       	mov    $0x3,%eax
80100e47:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e4e:	00 00 00 
80100e51:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e57:	e9 cd fe ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e5c:	e8 9f 1f 00 00       	call   80102e00 <end_op>
    cprintf("exec: fail\n");
80100e61:	83 ec 0c             	sub    $0xc,%esp
80100e64:	68 b0 74 10 80       	push   $0x801074b0
80100e69:	e8 42 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e6e:	83 c4 10             	add    $0x10,%esp
80100e71:	e9 a6 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e76:	66 90                	xchg   %ax,%ax
80100e78:	66 90                	xchg   %ax,%ax
80100e7a:	66 90                	xchg   %ax,%ax
80100e7c:	66 90                	xchg   %ax,%ax
80100e7e:	66 90                	xchg   %ax,%ax

80100e80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e86:	68 bc 74 10 80       	push   $0x801074bc
80100e8b:	68 60 ef 10 80       	push   $0x8010ef60
80100e90:	e8 4b 36 00 00       	call   801044e0 <initlock>
}
80100e95:	83 c4 10             	add    $0x10,%esp
80100e98:	c9                   	leave
80100e99:	c3                   	ret
80100e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ea0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea4:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100ea9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100eac:	68 60 ef 10 80       	push   $0x8010ef60
80100eb1:	e8 1a 38 00 00       	call   801046d0 <acquire>
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	eb 10                	jmp    80100ecb <filealloc+0x2b>
80100ebb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec0:	83 c3 18             	add    $0x18,%ebx
80100ec3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ec9:	74 25                	je     80100ef0 <filealloc+0x50>
    if(f->ref == 0){
80100ecb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ece:	85 c0                	test   %eax,%eax
80100ed0:	75 ee                	jne    80100ec0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ed2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ed5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100edc:	68 60 ef 10 80       	push   $0x8010ef60
80100ee1:	e8 8a 37 00 00       	call   80104670 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ee6:	89 d8                	mov    %ebx,%eax
      return f;
80100ee8:	83 c4 10             	add    $0x10,%esp
}
80100eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eee:	c9                   	leave
80100eef:	c3                   	ret
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ef3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ef5:	68 60 ef 10 80       	push   $0x8010ef60
80100efa:	e8 71 37 00 00       	call   80104670 <release>
}
80100eff:	89 d8                	mov    %ebx,%eax
  return 0;
80100f01:	83 c4 10             	add    $0x10,%esp
}
80100f04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f07:	c9                   	leave
80100f08:	c3                   	ret
80100f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 10             	sub    $0x10,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f1a:	68 60 ef 10 80       	push   $0x8010ef60
80100f1f:	e8 ac 37 00 00       	call   801046d0 <acquire>
  if(f->ref < 1)
80100f24:	8b 43 04             	mov    0x4(%ebx),%eax
80100f27:	83 c4 10             	add    $0x10,%esp
80100f2a:	85 c0                	test   %eax,%eax
80100f2c:	7e 1a                	jle    80100f48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f31:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f37:	68 60 ef 10 80       	push   $0x8010ef60
80100f3c:	e8 2f 37 00 00       	call   80104670 <release>
  return f;
}
80100f41:	89 d8                	mov    %ebx,%eax
80100f43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f46:	c9                   	leave
80100f47:	c3                   	ret
    panic("filedup");
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	68 c3 74 10 80       	push   $0x801074c3
80100f50:	e8 2b f4 ff ff       	call   80100380 <panic>
80100f55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f5c:	00 
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi

80100f60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 28             	sub    $0x28,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f6c:	68 60 ef 10 80       	push   $0x8010ef60
80100f71:	e8 5a 37 00 00       	call   801046d0 <acquire>
  if(f->ref < 1)
80100f76:	8b 53 04             	mov    0x4(%ebx),%edx
80100f79:	83 c4 10             	add    $0x10,%esp
80100f7c:	85 d2                	test   %edx,%edx
80100f7e:	0f 8e a5 00 00 00    	jle    80101029 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f84:	83 ea 01             	sub    $0x1,%edx
80100f87:	89 53 04             	mov    %edx,0x4(%ebx)
80100f8a:	75 44                	jne    80100fd0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f8c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f90:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f93:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f95:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f9b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f9e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fa1:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fa7:	68 60 ef 10 80       	push   $0x8010ef60
80100fac:	e8 bf 36 00 00       	call   80104670 <release>

  if(ff.type == FD_PIPE)
80100fb1:	83 c4 10             	add    $0x10,%esp
80100fb4:	83 ff 01             	cmp    $0x1,%edi
80100fb7:	74 57                	je     80101010 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fb9:	83 ff 02             	cmp    $0x2,%edi
80100fbc:	74 2a                	je     80100fe8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc1:	5b                   	pop    %ebx
80100fc2:	5e                   	pop    %esi
80100fc3:	5f                   	pop    %edi
80100fc4:	5d                   	pop    %ebp
80100fc5:	c3                   	ret
80100fc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fcd:	00 
80100fce:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100fd0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fda:	5b                   	pop    %ebx
80100fdb:	5e                   	pop    %esi
80100fdc:	5f                   	pop    %edi
80100fdd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fde:	e9 8d 36 00 00       	jmp    80104670 <release>
80100fe3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100fe8:	e8 a3 1d 00 00       	call   80102d90 <begin_op>
    iput(ff.ip);
80100fed:	83 ec 0c             	sub    $0xc,%esp
80100ff0:	ff 75 e0             	push   -0x20(%ebp)
80100ff3:	e8 28 09 00 00       	call   80101920 <iput>
    end_op();
80100ff8:	83 c4 10             	add    $0x10,%esp
}
80100ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ffe:	5b                   	pop    %ebx
80100fff:	5e                   	pop    %esi
80101000:	5f                   	pop    %edi
80101001:	5d                   	pop    %ebp
    end_op();
80101002:	e9 f9 1d 00 00       	jmp    80102e00 <end_op>
80101007:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010100e:	00 
8010100f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101010:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101014:	83 ec 08             	sub    $0x8,%esp
80101017:	53                   	push   %ebx
80101018:	56                   	push   %esi
80101019:	e8 52 25 00 00       	call   80103570 <pipeclose>
8010101e:	83 c4 10             	add    $0x10,%esp
}
80101021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101024:	5b                   	pop    %ebx
80101025:	5e                   	pop    %esi
80101026:	5f                   	pop    %edi
80101027:	5d                   	pop    %ebp
80101028:	c3                   	ret
    panic("fileclose");
80101029:	83 ec 0c             	sub    $0xc,%esp
8010102c:	68 cb 74 10 80       	push   $0x801074cb
80101031:	e8 4a f3 ff ff       	call   80100380 <panic>
80101036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010103d:	00 
8010103e:	66 90                	xchg   %ax,%ax

80101040 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	53                   	push   %ebx
80101044:	83 ec 04             	sub    $0x4,%esp
80101047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010104a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010104d:	75 31                	jne    80101080 <filestat+0x40>
    ilock(f->ip);
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	ff 73 10             	push   0x10(%ebx)
80101055:	e8 96 07 00 00       	call   801017f0 <ilock>
    stati(f->ip, st);
8010105a:	58                   	pop    %eax
8010105b:	5a                   	pop    %edx
8010105c:	ff 75 0c             	push   0xc(%ebp)
8010105f:	ff 73 10             	push   0x10(%ebx)
80101062:	e8 69 0a 00 00       	call   80101ad0 <stati>
    iunlock(f->ip);
80101067:	59                   	pop    %ecx
80101068:	ff 73 10             	push   0x10(%ebx)
8010106b:	e8 60 08 00 00       	call   801018d0 <iunlock>
    return 0;
  }
  return -1;
}
80101070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101073:	83 c4 10             	add    $0x10,%esp
80101076:	31 c0                	xor    %eax,%eax
}
80101078:	c9                   	leave
80101079:	c3                   	ret
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101080:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101088:	c9                   	leave
80101089:	c3                   	ret
8010108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101090 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010109c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010109f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010a2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010a6:	74 60                	je     80101108 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010a8:	8b 03                	mov    (%ebx),%eax
801010aa:	83 f8 01             	cmp    $0x1,%eax
801010ad:	74 41                	je     801010f0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010af:	83 f8 02             	cmp    $0x2,%eax
801010b2:	75 5b                	jne    8010110f <fileread+0x7f>
    ilock(f->ip);
801010b4:	83 ec 0c             	sub    $0xc,%esp
801010b7:	ff 73 10             	push   0x10(%ebx)
801010ba:	e8 31 07 00 00       	call   801017f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010bf:	57                   	push   %edi
801010c0:	ff 73 14             	push   0x14(%ebx)
801010c3:	56                   	push   %esi
801010c4:	ff 73 10             	push   0x10(%ebx)
801010c7:	e8 34 0a 00 00       	call   80101b00 <readi>
801010cc:	83 c4 20             	add    $0x20,%esp
801010cf:	89 c6                	mov    %eax,%esi
801010d1:	85 c0                	test   %eax,%eax
801010d3:	7e 03                	jle    801010d8 <fileread+0x48>
      f->off += r;
801010d5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010d8:	83 ec 0c             	sub    $0xc,%esp
801010db:	ff 73 10             	push   0x10(%ebx)
801010de:	e8 ed 07 00 00       	call   801018d0 <iunlock>
    return r;
801010e3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	89 f0                	mov    %esi,%eax
801010eb:	5b                   	pop    %ebx
801010ec:	5e                   	pop    %esi
801010ed:	5f                   	pop    %edi
801010ee:	5d                   	pop    %ebp
801010ef:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010f0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010f3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f9:	5b                   	pop    %ebx
801010fa:	5e                   	pop    %esi
801010fb:	5f                   	pop    %edi
801010fc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010fd:	e9 2e 26 00 00       	jmp    80103730 <piperead>
80101102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101108:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010110d:	eb d7                	jmp    801010e6 <fileread+0x56>
  panic("fileread");
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 d5 74 10 80       	push   $0x801074d5
80101117:	e8 64 f2 ff ff       	call   80100380 <panic>
8010111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101120 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 1c             	sub    $0x1c,%esp
80101129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010112c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010112f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101132:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101135:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010113c:	0f 84 bb 00 00 00    	je     801011fd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101142:	8b 03                	mov    (%ebx),%eax
80101144:	83 f8 01             	cmp    $0x1,%eax
80101147:	0f 84 bf 00 00 00    	je     8010120c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010114d:	83 f8 02             	cmp    $0x2,%eax
80101150:	0f 85 c8 00 00 00    	jne    8010121e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101159:	31 f6                	xor    %esi,%esi
    while(i < n){
8010115b:	85 c0                	test   %eax,%eax
8010115d:	7f 30                	jg     8010118f <filewrite+0x6f>
8010115f:	e9 94 00 00 00       	jmp    801011f8 <filewrite+0xd8>
80101164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101168:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010116b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010116e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101171:	ff 73 10             	push   0x10(%ebx)
80101174:	e8 57 07 00 00       	call   801018d0 <iunlock>
      end_op();
80101179:	e8 82 1c 00 00       	call   80102e00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010117e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101181:	83 c4 10             	add    $0x10,%esp
80101184:	39 c7                	cmp    %eax,%edi
80101186:	75 5c                	jne    801011e4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101188:	01 fe                	add    %edi,%esi
    while(i < n){
8010118a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010118d:	7e 69                	jle    801011f8 <filewrite+0xd8>
      int n1 = n - i;
8010118f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101192:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101197:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101199:	39 c7                	cmp    %eax,%edi
8010119b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010119e:	e8 ed 1b 00 00       	call   80102d90 <begin_op>
      ilock(f->ip);
801011a3:	83 ec 0c             	sub    $0xc,%esp
801011a6:	ff 73 10             	push   0x10(%ebx)
801011a9:	e8 42 06 00 00       	call   801017f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011ae:	57                   	push   %edi
801011af:	ff 73 14             	push   0x14(%ebx)
801011b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b5:	01 f0                	add    %esi,%eax
801011b7:	50                   	push   %eax
801011b8:	ff 73 10             	push   0x10(%ebx)
801011bb:	e8 40 0a 00 00       	call   80101c00 <writei>
801011c0:	83 c4 20             	add    $0x20,%esp
801011c3:	85 c0                	test   %eax,%eax
801011c5:	7f a1                	jg     80101168 <filewrite+0x48>
801011c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011ca:	83 ec 0c             	sub    $0xc,%esp
801011cd:	ff 73 10             	push   0x10(%ebx)
801011d0:	e8 fb 06 00 00       	call   801018d0 <iunlock>
      end_op();
801011d5:	e8 26 1c 00 00       	call   80102e00 <end_op>
      if(r < 0)
801011da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011dd:	83 c4 10             	add    $0x10,%esp
801011e0:	85 c0                	test   %eax,%eax
801011e2:	75 14                	jne    801011f8 <filewrite+0xd8>
        panic("short filewrite");
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	68 de 74 10 80       	push   $0x801074de
801011ec:	e8 8f f1 ff ff       	call   80100380 <panic>
801011f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011f8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011fb:	74 05                	je     80101202 <filewrite+0xe2>
801011fd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101202:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101205:	89 f0                	mov    %esi,%eax
80101207:	5b                   	pop    %ebx
80101208:	5e                   	pop    %esi
80101209:	5f                   	pop    %edi
8010120a:	5d                   	pop    %ebp
8010120b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010120c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010120f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101212:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101215:	5b                   	pop    %ebx
80101216:	5e                   	pop    %esi
80101217:	5f                   	pop    %edi
80101218:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101219:	e9 f2 23 00 00       	jmp    80103610 <pipewrite>
  panic("filewrite");
8010121e:	83 ec 0c             	sub    $0xc,%esp
80101221:	68 e4 74 10 80       	push   $0x801074e4
80101226:	e8 55 f1 ff ff       	call   80100380 <panic>
8010122b:	66 90                	xchg   %ax,%ax
8010122d:	66 90                	xchg   %ax,%ax
8010122f:	90                   	nop

80101230 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010123f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 8c 00 00 00    	je     801012d6 <balloc+0xa6>
8010124a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010124c:	89 f8                	mov    %edi,%eax
8010124e:	83 ec 08             	sub    $0x8,%esp
80101251:	89 fe                	mov    %edi,%esi
80101253:	c1 f8 0c             	sar    $0xc,%eax
80101256:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010125c:	50                   	push   %eax
8010125d:	ff 75 dc             	push   -0x24(%ebp)
80101260:	e8 6b ee ff ff       	call   801000d0 <bread>
80101265:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101268:	83 c4 10             	add    $0x10,%esp
8010126b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010126e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101273:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101276:	31 c0                	xor    %eax,%eax
80101278:	eb 32                	jmp    801012ac <balloc+0x7c>
8010127a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 49                	je     801012e8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 07                	je     801012b3 <balloc+0x83>
801012ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
801012af:	39 d6                	cmp    %edx,%esi
801012b1:	72 cd                	jb     80101280 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012b3:	8b 7d d8             	mov    -0x28(%ebp),%edi
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012c2:	e8 29 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012c7:	83 c4 10             	add    $0x10,%esp
801012ca:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
801012d0:	0f 82 76 ff ff ff    	jb     8010124c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012d6:	83 ec 0c             	sub    $0xc,%esp
801012d9:	68 ee 74 10 80       	push   $0x801074ee
801012de:	e8 9d f0 ff ff       	call   80100380 <panic>
801012e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801012e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012eb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ee:	09 da                	or     %ebx,%edx
801012f0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012f4:	57                   	push   %edi
801012f5:	e8 76 1c 00 00       	call   80102f70 <log_write>
        brelse(bp);
801012fa:	89 3c 24             	mov    %edi,(%esp)
801012fd:	e8 ee ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101302:	58                   	pop    %eax
80101303:	5a                   	pop    %edx
80101304:	56                   	push   %esi
80101305:	ff 75 dc             	push   -0x24(%ebp)
80101308:	e8 c3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010130d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101310:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101312:	8d 40 5c             	lea    0x5c(%eax),%eax
80101315:	68 00 02 00 00       	push   $0x200
8010131a:	6a 00                	push   $0x0
8010131c:	50                   	push   %eax
8010131d:	e8 8e 35 00 00       	call   801048b0 <memset>
  log_write(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 46 1c 00 00       	call   80102f70 <log_write>
  brelse(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 be ee ff ff       	call   801001f0 <brelse>
}
80101332:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101335:	89 f0                	mov    %esi,%eax
80101337:	5b                   	pop    %ebx
80101338:	5e                   	pop    %esi
80101339:	5f                   	pop    %edi
8010133a:	5d                   	pop    %ebp
8010133b:	c3                   	ret
8010133c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101344:	31 ff                	xor    %edi,%edi
{
80101346:	56                   	push   %esi
80101347:	89 c6                	mov    %eax,%esi
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 60 f9 10 80       	push   $0x8010f960
8010135a:	e8 71 33 00 00       	call   801046d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010136e:	00 
8010136f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 33                	cmp    %esi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010137a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101380:	74 26                	je     801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 43 08             	mov    0x8(%ebx),%eax
80101385:	85 c0                	test   %eax,%eax
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 ff                	test   %edi,%edi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	85 c0                	test   %eax,%eax
8010138f:	75 76                	jne    80101407 <iget+0xc7>
      empty = ip;
80101391:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101393:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101399:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010139f:	75 e1                	jne    80101382 <iget+0x42>
801013a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 ff                	test   %edi,%edi
801013aa:	74 79                	je     80101425 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
801013b1:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
801013b4:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
801013bb:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013c2:	68 60 f9 10 80       	push   $0x8010f960
801013c7:	e8 a4 32 00 00       	call   80104670 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f8                	mov    %edi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      ip->ref++;
801013e5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013e8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013eb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013ed:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013f0:	68 60 f9 10 80       	push   $0x8010f960
801013f5:	e8 76 32 00 00       	call   80104670 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f8                	mov    %edi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010140d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101413:	74 10                	je     80101425 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101415:	8b 43 08             	mov    0x8(%ebx),%eax
80101418:	85 c0                	test   %eax,%eax
8010141a:	0f 8f 50 ff ff ff    	jg     80101370 <iget+0x30>
80101420:	e9 68 ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
80101425:	83 ec 0c             	sub    $0xc,%esp
80101428:	68 04 75 10 80       	push   $0x80107504
8010142d:	e8 4e ef ff ff       	call   80100380 <panic>
80101432:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101439:	00 
8010143a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101440 <bfree>:
{
80101440:	55                   	push   %ebp
80101441:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101443:	89 d0                	mov    %edx,%eax
80101445:	c1 e8 0c             	shr    $0xc,%eax
{
80101448:	89 e5                	mov    %esp,%ebp
8010144a:	56                   	push   %esi
8010144b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010144c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101452:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101454:	83 ec 08             	sub    $0x8,%esp
80101457:	50                   	push   %eax
80101458:	51                   	push   %ecx
80101459:	e8 72 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010145e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101460:	c1 fb 03             	sar    $0x3,%ebx
80101463:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101466:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101468:	83 e1 07             	and    $0x7,%ecx
8010146b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101470:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101476:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101478:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010147d:	85 c1                	test   %eax,%ecx
8010147f:	74 23                	je     801014a4 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101481:	f7 d0                	not    %eax
  log_write(bp);
80101483:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101486:	21 c8                	and    %ecx,%eax
80101488:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010148c:	56                   	push   %esi
8010148d:	e8 de 1a 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101492:	89 34 24             	mov    %esi,(%esp)
80101495:	e8 56 ed ff ff       	call   801001f0 <brelse>
}
8010149a:	83 c4 10             	add    $0x10,%esp
8010149d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014a0:	5b                   	pop    %ebx
801014a1:	5e                   	pop    %esi
801014a2:	5d                   	pop    %ebp
801014a3:	c3                   	ret
    panic("freeing free block");
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	68 14 75 10 80       	push   $0x80107514
801014ac:	e8 cf ee ff ff       	call   80100380 <panic>
801014b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014b8:	00 
801014b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	57                   	push   %edi
801014c4:	56                   	push   %esi
801014c5:	89 c6                	mov    %eax,%esi
801014c7:	53                   	push   %ebx
801014c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014cb:	83 fa 0b             	cmp    $0xb,%edx
801014ce:	0f 86 8c 00 00 00    	jbe    80101560 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014d4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014d7:	83 fb 7f             	cmp    $0x7f,%ebx
801014da:	0f 87 a2 00 00 00    	ja     80101582 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014e0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014e6:	85 c0                	test   %eax,%eax
801014e8:	74 5e                	je     80101548 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ea:	83 ec 08             	sub    $0x8,%esp
801014ed:	50                   	push   %eax
801014ee:	ff 36                	push   (%esi)
801014f0:	e8 db eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014f5:	83 c4 10             	add    $0x10,%esp
801014f8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014fc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014fe:	8b 3b                	mov    (%ebx),%edi
80101500:	85 ff                	test   %edi,%edi
80101502:	74 1c                	je     80101520 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	52                   	push   %edx
80101508:	e8 e3 ec ff ff       	call   801001f0 <brelse>
8010150d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101510:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101513:	89 f8                	mov    %edi,%eax
80101515:	5b                   	pop    %ebx
80101516:	5e                   	pop    %esi
80101517:	5f                   	pop    %edi
80101518:	5d                   	pop    %ebp
80101519:	c3                   	ret
8010151a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101523:	8b 06                	mov    (%esi),%eax
80101525:	e8 06 fd ff ff       	call   80101230 <balloc>
      log_write(bp);
8010152a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010152d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101530:	89 03                	mov    %eax,(%ebx)
80101532:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101534:	52                   	push   %edx
80101535:	e8 36 1a 00 00       	call   80102f70 <log_write>
8010153a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010153d:	83 c4 10             	add    $0x10,%esp
80101540:	eb c2                	jmp    80101504 <bmap+0x44>
80101542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101548:	8b 06                	mov    (%esi),%eax
8010154a:	e8 e1 fc ff ff       	call   80101230 <balloc>
8010154f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101555:	eb 93                	jmp    801014ea <bmap+0x2a>
80101557:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010155e:	00 
8010155f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101560:	8d 5a 14             	lea    0x14(%edx),%ebx
80101563:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101567:	85 ff                	test   %edi,%edi
80101569:	75 a5                	jne    80101510 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010156b:	8b 00                	mov    (%eax),%eax
8010156d:	e8 be fc ff ff       	call   80101230 <balloc>
80101572:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101576:	89 c7                	mov    %eax,%edi
}
80101578:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010157b:	5b                   	pop    %ebx
8010157c:	89 f8                	mov    %edi,%eax
8010157e:	5e                   	pop    %esi
8010157f:	5f                   	pop    %edi
80101580:	5d                   	pop    %ebp
80101581:	c3                   	ret
  panic("bmap: out of range");
80101582:	83 ec 0c             	sub    $0xc,%esp
80101585:	68 27 75 10 80       	push   $0x80107527
8010158a:	e8 f1 ed ff ff       	call   80100380 <panic>
8010158f:	90                   	nop

80101590 <readsb>:
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	56                   	push   %esi
80101594:	53                   	push   %ebx
80101595:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	6a 01                	push   $0x1
8010159d:	ff 75 08             	push   0x8(%ebp)
801015a0:	e8 2b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015a5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015a8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015aa:	8d 40 5c             	lea    0x5c(%eax),%eax
801015ad:	6a 1c                	push   $0x1c
801015af:	50                   	push   %eax
801015b0:	56                   	push   %esi
801015b1:	e8 8a 33 00 00       	call   80104940 <memmove>
  brelse(bp);
801015b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015b9:	83 c4 10             	add    $0x10,%esp
}
801015bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015bf:	5b                   	pop    %ebx
801015c0:	5e                   	pop    %esi
801015c1:	5d                   	pop    %ebp
  brelse(bp);
801015c2:	e9 29 ec ff ff       	jmp    801001f0 <brelse>
801015c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ce:	00 
801015cf:	90                   	nop

801015d0 <iinit>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	53                   	push   %ebx
801015d4:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801015d9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015dc:	68 3a 75 10 80       	push   $0x8010753a
801015e1:	68 60 f9 10 80       	push   $0x8010f960
801015e6:	e8 f5 2e 00 00       	call   801044e0 <initlock>
  for(i = 0; i < NINODE; i++) {
801015eb:	83 c4 10             	add    $0x10,%esp
801015ee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015f0:	83 ec 08             	sub    $0x8,%esp
801015f3:	68 41 75 10 80       	push   $0x80107541
801015f8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015f9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ff:	e8 ac 2d 00 00       	call   801043b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101604:	83 c4 10             	add    $0x10,%esp
80101607:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010160d:	75 e1                	jne    801015f0 <iinit+0x20>
  bp = bread(dev, 1);
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	6a 01                	push   $0x1
80101614:	ff 75 08             	push   0x8(%ebp)
80101617:	e8 b4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010161c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010161f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101621:	8d 40 5c             	lea    0x5c(%eax),%eax
80101624:	6a 1c                	push   $0x1c
80101626:	50                   	push   %eax
80101627:	68 b4 15 11 80       	push   $0x801115b4
8010162c:	e8 0f 33 00 00       	call   80104940 <memmove>
  brelse(bp);
80101631:	89 1c 24             	mov    %ebx,(%esp)
80101634:	e8 b7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101639:	ff 35 cc 15 11 80    	push   0x801115cc
8010163f:	ff 35 c8 15 11 80    	push   0x801115c8
80101645:	ff 35 c4 15 11 80    	push   0x801115c4
8010164b:	ff 35 c0 15 11 80    	push   0x801115c0
80101651:	ff 35 bc 15 11 80    	push   0x801115bc
80101657:	ff 35 b8 15 11 80    	push   0x801115b8
8010165d:	ff 35 b4 15 11 80    	push   0x801115b4
80101663:	68 78 79 10 80       	push   $0x80107978
80101668:	e8 43 f0 ff ff       	call   801006b0 <cprintf>
}
8010166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101670:	83 c4 30             	add    $0x30,%esp
80101673:	c9                   	leave
80101674:	c3                   	ret
80101675:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010167c:	00 
8010167d:	8d 76 00             	lea    0x0(%esi),%esi

80101680 <ialloc>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	83 ec 1c             	sub    $0x1c,%esp
80101689:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010168c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101693:	8b 75 08             	mov    0x8(%ebp),%esi
80101696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101699:	0f 86 91 00 00 00    	jbe    80101730 <ialloc+0xb0>
8010169f:	bf 01 00 00 00       	mov    $0x1,%edi
801016a4:	eb 21                	jmp    801016c7 <ialloc+0x47>
801016a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016ad:	00 
801016ae:	66 90                	xchg   %ax,%ax
    brelse(bp);
801016b0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016b3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016b6:	53                   	push   %ebx
801016b7:	e8 34 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016bc:	83 c4 10             	add    $0x10,%esp
801016bf:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801016c5:	73 69                	jae    80101730 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016c7:	89 f8                	mov    %edi,%eax
801016c9:	83 ec 08             	sub    $0x8,%esp
801016cc:	c1 e8 03             	shr    $0x3,%eax
801016cf:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016d5:	50                   	push   %eax
801016d6:	56                   	push   %esi
801016d7:	e8 f4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016dc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016df:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016e1:	89 f8                	mov    %edi,%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016f1:	75 bd                	jne    801016b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016f3:	83 ec 04             	sub    $0x4,%esp
801016f6:	6a 40                	push   $0x40
801016f8:	6a 00                	push   $0x0
801016fa:	51                   	push   %ecx
801016fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016fe:	e8 ad 31 00 00       	call   801048b0 <memset>
      dip->type = type;
80101703:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101707:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010170a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010170d:	89 1c 24             	mov    %ebx,(%esp)
80101710:	e8 5b 18 00 00       	call   80102f70 <log_write>
      brelse(bp);
80101715:	89 1c 24             	mov    %ebx,(%esp)
80101718:	e8 d3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010171d:	83 c4 10             	add    $0x10,%esp
}
80101720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101723:	89 fa                	mov    %edi,%edx
}
80101725:	5b                   	pop    %ebx
      return iget(dev, inum);
80101726:	89 f0                	mov    %esi,%eax
}
80101728:	5e                   	pop    %esi
80101729:	5f                   	pop    %edi
8010172a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010172b:	e9 10 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101730:	83 ec 0c             	sub    $0xc,%esp
80101733:	68 47 75 10 80       	push   $0x80107547
80101738:	e8 43 ec ff ff       	call   80100380 <panic>
8010173d:	8d 76 00             	lea    0x0(%esi),%esi

80101740 <iupdate>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101748:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	c1 e8 03             	shr    $0x3,%eax
80101754:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010175a:	50                   	push   %eax
8010175b:	ff 73 a4             	push   -0x5c(%ebx)
8010175e:	e8 6d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101763:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101767:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101779:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010177c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101780:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101783:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101787:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010178b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010178f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101793:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101797:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010179a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010179d:	6a 34                	push   $0x34
8010179f:	53                   	push   %ebx
801017a0:	50                   	push   %eax
801017a1:	e8 9a 31 00 00       	call   80104940 <memmove>
  log_write(bp);
801017a6:	89 34 24             	mov    %esi,(%esp)
801017a9:	e8 c2 17 00 00       	call   80102f70 <log_write>
  brelse(bp);
801017ae:	89 75 08             	mov    %esi,0x8(%ebp)
801017b1:	83 c4 10             	add    $0x10,%esp
}
801017b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b7:	5b                   	pop    %ebx
801017b8:	5e                   	pop    %esi
801017b9:	5d                   	pop    %ebp
  brelse(bp);
801017ba:	e9 31 ea ff ff       	jmp    801001f0 <brelse>
801017bf:	90                   	nop

801017c0 <idup>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ca:	68 60 f9 10 80       	push   $0x8010f960
801017cf:	e8 fc 2e 00 00       	call   801046d0 <acquire>
  ip->ref++;
801017d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017d8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801017df:	e8 8c 2e 00 00       	call   80104670 <release>
}
801017e4:	89 d8                	mov    %ebx,%eax
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave
801017ea:	c3                   	ret
801017eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017f0 <ilock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	0f 84 b7 00 00 00    	je     801018b7 <ilock+0xc7>
80101800:	8b 53 08             	mov    0x8(%ebx),%edx
80101803:	85 d2                	test   %edx,%edx
80101805:	0f 8e ac 00 00 00    	jle    801018b7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010180b:	83 ec 0c             	sub    $0xc,%esp
8010180e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101811:	50                   	push   %eax
80101812:	e8 d9 2b 00 00       	call   801043f0 <acquiresleep>
  if(ip->valid == 0){
80101817:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010181a:	83 c4 10             	add    $0x10,%esp
8010181d:	85 c0                	test   %eax,%eax
8010181f:	74 0f                	je     80101830 <ilock+0x40>
}
80101821:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101824:	5b                   	pop    %ebx
80101825:	5e                   	pop    %esi
80101826:	5d                   	pop    %ebp
80101827:	c3                   	ret
80101828:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010182f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101830:	8b 43 04             	mov    0x4(%ebx),%eax
80101833:	83 ec 08             	sub    $0x8,%esp
80101836:	c1 e8 03             	shr    $0x3,%eax
80101839:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010183f:	50                   	push   %eax
80101840:	ff 33                	push   (%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 04             	mov    0x4(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101859:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010185f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101863:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101867:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010186b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010186f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101873:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101877:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010187b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010187e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101881:	6a 34                	push   $0x34
80101883:	50                   	push   %eax
80101884:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101887:	50                   	push   %eax
80101888:	e8 b3 30 00 00       	call   80104940 <memmove>
    brelse(bp);
8010188d:	89 34 24             	mov    %esi,(%esp)
80101890:	e8 5b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101895:	83 c4 10             	add    $0x10,%esp
80101898:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010189d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018a4:	0f 85 77 ff ff ff    	jne    80101821 <ilock+0x31>
      panic("ilock: no type");
801018aa:	83 ec 0c             	sub    $0xc,%esp
801018ad:	68 5f 75 10 80       	push   $0x8010755f
801018b2:	e8 c9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	68 59 75 10 80       	push   $0x80107559
801018bf:	e8 bc ea ff ff       	call   80100380 <panic>
801018c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018cb:	00 
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iunlock>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018d8:	85 db                	test   %ebx,%ebx
801018da:	74 28                	je     80101904 <iunlock+0x34>
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	8d 73 0c             	lea    0xc(%ebx),%esi
801018e2:	56                   	push   %esi
801018e3:	e8 a8 2b 00 00       	call   80104490 <holdingsleep>
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 c0                	test   %eax,%eax
801018ed:	74 15                	je     80101904 <iunlock+0x34>
801018ef:	8b 43 08             	mov    0x8(%ebx),%eax
801018f2:	85 c0                	test   %eax,%eax
801018f4:	7e 0e                	jle    80101904 <iunlock+0x34>
  releasesleep(&ip->lock);
801018f6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018ff:	e9 4c 2b 00 00       	jmp    80104450 <releasesleep>
    panic("iunlock");
80101904:	83 ec 0c             	sub    $0xc,%esp
80101907:	68 6e 75 10 80       	push   $0x8010756e
8010190c:	e8 6f ea ff ff       	call   80100380 <panic>
80101911:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101918:	00 
80101919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101920 <iput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 28             	sub    $0x28,%esp
80101929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010192c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010192f:	57                   	push   %edi
80101930:	e8 bb 2a 00 00       	call   801043f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101935:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101938:	83 c4 10             	add    $0x10,%esp
8010193b:	85 d2                	test   %edx,%edx
8010193d:	74 07                	je     80101946 <iput+0x26>
8010193f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101944:	74 32                	je     80101978 <iput+0x58>
  releasesleep(&ip->lock);
80101946:	83 ec 0c             	sub    $0xc,%esp
80101949:	57                   	push   %edi
8010194a:	e8 01 2b 00 00       	call   80104450 <releasesleep>
  acquire(&icache.lock);
8010194f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101956:	e8 75 2d 00 00       	call   801046d0 <acquire>
  ip->ref--;
8010195b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010195f:	83 c4 10             	add    $0x10,%esp
80101962:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010196c:	5b                   	pop    %ebx
8010196d:	5e                   	pop    %esi
8010196e:	5f                   	pop    %edi
8010196f:	5d                   	pop    %ebp
  release(&icache.lock);
80101970:	e9 fb 2c 00 00       	jmp    80104670 <release>
80101975:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101978:	83 ec 0c             	sub    $0xc,%esp
8010197b:	68 60 f9 10 80       	push   $0x8010f960
80101980:	e8 4b 2d 00 00       	call   801046d0 <acquire>
    int r = ip->ref;
80101985:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101988:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010198f:	e8 dc 2c 00 00       	call   80104670 <release>
    if(r == 1){
80101994:	83 c4 10             	add    $0x10,%esp
80101997:	83 fe 01             	cmp    $0x1,%esi
8010199a:	75 aa                	jne    80101946 <iput+0x26>
8010199c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019a8:	89 df                	mov    %ebx,%edi
801019aa:	89 cb                	mov    %ecx,%ebx
801019ac:	eb 09                	jmp    801019b7 <iput+0x97>
801019ae:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 de                	cmp    %ebx,%esi
801019b5:	74 19                	je     801019d0 <iput+0xb0>
    if(ip->addrs[i]){
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019bd:	8b 07                	mov    (%edi),%eax
801019bf:	e8 7c fa ff ff       	call   80101440 <bfree>
      ip->addrs[i] = 0;
801019c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ca:	eb e4                	jmp    801019b0 <iput+0x90>
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019d0:	89 fb                	mov    %edi,%ebx
801019d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019d5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019db:	85 c0                	test   %eax,%eax
801019dd:	75 2d                	jne    80101a0c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019df:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019e2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019e9:	53                   	push   %ebx
801019ea:	e8 51 fd ff ff       	call   80101740 <iupdate>
      ip->type = 0;
801019ef:	31 c0                	xor    %eax,%eax
801019f1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019f5:	89 1c 24             	mov    %ebx,(%esp)
801019f8:	e8 43 fd ff ff       	call   80101740 <iupdate>
      ip->valid = 0;
801019fd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a04:	83 c4 10             	add    $0x10,%esp
80101a07:	e9 3a ff ff ff       	jmp    80101946 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a0c:	83 ec 08             	sub    $0x8,%esp
80101a0f:	50                   	push   %eax
80101a10:	ff 33                	push   (%ebx)
80101a12:	e8 b9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a17:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a26:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a29:	89 cf                	mov    %ecx,%edi
80101a2b:	eb 0a                	jmp    80101a37 <iput+0x117>
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 fe                	cmp    %edi,%esi
80101a35:	74 0f                	je     80101a46 <iput+0x126>
      if(a[j])
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 fc f9 ff ff       	call   80101440 <bfree>
80101a44:	eb ea                	jmp    80101a30 <iput+0x110>
    brelse(bp);
80101a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a49:	83 ec 0c             	sub    $0xc,%esp
80101a4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a4f:	50                   	push   %eax
80101a50:	e8 9b e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a55:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a5b:	8b 03                	mov    (%ebx),%eax
80101a5d:	e8 de f9 ff ff       	call   80101440 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a62:	83 c4 10             	add    $0x10,%esp
80101a65:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a6c:	00 00 00 
80101a6f:	e9 6b ff ff ff       	jmp    801019df <iput+0xbf>
80101a74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a7b:	00 
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a80 <iunlockput>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	56                   	push   %esi
80101a84:	53                   	push   %ebx
80101a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a88:	85 db                	test   %ebx,%ebx
80101a8a:	74 34                	je     80101ac0 <iunlockput+0x40>
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a92:	56                   	push   %esi
80101a93:	e8 f8 29 00 00       	call   80104490 <holdingsleep>
80101a98:	83 c4 10             	add    $0x10,%esp
80101a9b:	85 c0                	test   %eax,%eax
80101a9d:	74 21                	je     80101ac0 <iunlockput+0x40>
80101a9f:	8b 43 08             	mov    0x8(%ebx),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	7e 1a                	jle    80101ac0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 a1 29 00 00       	call   80104450 <releasesleep>
  iput(ip);
80101aaf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ab2:	83 c4 10             	add    $0x10,%esp
}
80101ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5d                   	pop    %ebp
  iput(ip);
80101abb:	e9 60 fe ff ff       	jmp    80101920 <iput>
    panic("iunlock");
80101ac0:	83 ec 0c             	sub    $0xc,%esp
80101ac3:	68 6e 75 10 80       	push   $0x8010756e
80101ac8:	e8 b3 e8 ff ff       	call   80100380 <panic>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi

80101ad0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ad9:	8b 0a                	mov    (%edx),%ecx
80101adb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ade:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ae1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ae4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ae8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101aeb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101af3:	8b 52 58             	mov    0x58(%edx),%edx
80101af6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101af9:	5d                   	pop    %ebp
80101afa:	c3                   	ret
80101afb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 75 08             	mov    0x8(%ebp),%esi
80101b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b1a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b1d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b20:	0f 84 aa 00 00 00    	je     80101bd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b26:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b29:	8b 56 58             	mov    0x58(%esi),%edx
80101b2c:	39 fa                	cmp    %edi,%edx
80101b2e:	0f 82 bd 00 00 00    	jb     80101bf1 <readi+0xf1>
80101b34:	89 f9                	mov    %edi,%ecx
80101b36:	31 db                	xor    %ebx,%ebx
80101b38:	01 c1                	add    %eax,%ecx
80101b3a:	0f 92 c3             	setb   %bl
80101b3d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b40:	0f 82 ab 00 00 00    	jb     80101bf1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b46:	89 d3                	mov    %edx,%ebx
80101b48:	29 fb                	sub    %edi,%ebx
80101b4a:	39 ca                	cmp    %ecx,%edx
80101b4c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	85 c0                	test   %eax,%eax
80101b51:	74 73                	je     80101bc6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b53:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b63:	89 fa                	mov    %edi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 d8                	mov    %ebx,%eax
80101b6a:	e8 51 f9 ff ff       	call   801014c0 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 33                	push   (%ebx)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b7d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b82:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b84:	89 f8                	mov    %edi,%eax
80101b86:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b8b:	29 f3                	sub    %esi,%ebx
80101b8d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b93:	39 d9                	cmp    %ebx,%ecx
80101b95:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b98:	83 c4 0c             	add    $0xc,%esp
80101b9b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9c:	01 de                	add    %ebx,%esi
80101b9e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ba0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ba3:	50                   	push   %eax
80101ba4:	ff 75 e0             	push   -0x20(%ebp)
80101ba7:	e8 94 2d 00 00       	call   80104940 <memmove>
    brelse(bp);
80101bac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101baf:	89 14 24             	mov    %edx,(%esp)
80101bb2:	e8 39 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bbd:	83 c4 10             	add    $0x10,%esp
80101bc0:	39 de                	cmp    %ebx,%esi
80101bc2:	72 9c                	jb     80101b60 <readi+0x60>
80101bc4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc9:	5b                   	pop    %ebx
80101bca:	5e                   	pop    %esi
80101bcb:	5f                   	pop    %edi
80101bcc:	5d                   	pop    %ebp
80101bcd:	c3                   	ret
80101bce:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bd0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bd4:	66 83 fa 09          	cmp    $0x9,%dx
80101bd8:	77 17                	ja     80101bf1 <readi+0xf1>
80101bda:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101be1:	85 d2                	test   %edx,%edx
80101be3:	74 0c                	je     80101bf1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101be5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bef:	ff e2                	jmp    *%edx
      return -1;
80101bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bf6:	eb ce                	jmp    80101bc6 <readi+0xc6>
80101bf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101bff:	00 

80101c00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 1c             	sub    $0x1c,%esp
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c0f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c17:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c1a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c1d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c20:	0f 84 ba 00 00 00    	je     80101ce0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c26:	39 78 58             	cmp    %edi,0x58(%eax)
80101c29:	0f 82 ea 00 00 00    	jb     80101d19 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c2f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c32:	89 f2                	mov    %esi,%edx
80101c34:	01 fa                	add    %edi,%edx
80101c36:	0f 82 dd 00 00 00    	jb     80101d19 <writei+0x119>
80101c3c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c42:	0f 87 d1 00 00 00    	ja     80101d19 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	85 f6                	test   %esi,%esi
80101c4a:	0f 84 85 00 00 00    	je     80101cd5 <writei+0xd5>
80101c50:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c57:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c60:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c63:	89 fa                	mov    %edi,%edx
80101c65:	c1 ea 09             	shr    $0x9,%edx
80101c68:	89 f0                	mov    %esi,%eax
80101c6a:	e8 51 f8 ff ff       	call   801014c0 <bmap>
80101c6f:	83 ec 08             	sub    $0x8,%esp
80101c72:	50                   	push   %eax
80101c73:	ff 36                	push   (%esi)
80101c75:	e8 56 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c7d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c80:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c85:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c87:	89 f8                	mov    %edi,%eax
80101c89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c8e:	29 d3                	sub    %edx,%ebx
80101c90:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c92:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c96:	39 d9                	cmp    %ebx,%ecx
80101c98:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c9b:	83 c4 0c             	add    $0xc,%esp
80101c9e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c9f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101ca1:	ff 75 dc             	push   -0x24(%ebp)
80101ca4:	50                   	push   %eax
80101ca5:	e8 96 2c 00 00       	call   80104940 <memmove>
    log_write(bp);
80101caa:	89 34 24             	mov    %esi,(%esp)
80101cad:	e8 be 12 00 00       	call   80102f70 <log_write>
    brelse(bp);
80101cb2:	89 34 24             	mov    %esi,(%esp)
80101cb5:	e8 36 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cba:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cc0:	83 c4 10             	add    $0x10,%esp
80101cc3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cc6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cc9:	39 d8                	cmp    %ebx,%eax
80101ccb:	72 93                	jb     80101c60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ccd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cd0:	39 78 58             	cmp    %edi,0x58(%eax)
80101cd3:	72 33                	jb     80101d08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cdb:	5b                   	pop    %ebx
80101cdc:	5e                   	pop    %esi
80101cdd:	5f                   	pop    %edi
80101cde:	5d                   	pop    %ebp
80101cdf:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ce0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ce4:	66 83 f8 09          	cmp    $0x9,%ax
80101ce8:	77 2f                	ja     80101d19 <writei+0x119>
80101cea:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101cf1:	85 c0                	test   %eax,%eax
80101cf3:	74 24                	je     80101d19 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101cf5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cfb:	5b                   	pop    %ebx
80101cfc:	5e                   	pop    %esi
80101cfd:	5f                   	pop    %edi
80101cfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cff:	ff e0                	jmp    *%eax
80101d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d0b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d0e:	50                   	push   %eax
80101d0f:	e8 2c fa ff ff       	call   80101740 <iupdate>
80101d14:	83 c4 10             	add    $0x10,%esp
80101d17:	eb bc                	jmp    80101cd5 <writei+0xd5>
      return -1;
80101d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d1e:	eb b8                	jmp    80101cd8 <writei+0xd8>

80101d20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d26:	6a 0e                	push   $0xe
80101d28:	ff 75 0c             	push   0xc(%ebp)
80101d2b:	ff 75 08             	push   0x8(%ebp)
80101d2e:	e8 7d 2c 00 00       	call   801049b0 <strncmp>
}
80101d33:	c9                   	leave
80101d34:	c3                   	ret
80101d35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d3c:	00 
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi

80101d40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	83 ec 1c             	sub    $0x1c,%esp
80101d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d51:	0f 85 85 00 00 00    	jne    80101ddc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d57:	8b 53 58             	mov    0x58(%ebx),%edx
80101d5a:	31 ff                	xor    %edi,%edi
80101d5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d5f:	85 d2                	test   %edx,%edx
80101d61:	74 3e                	je     80101da1 <dirlookup+0x61>
80101d63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d68:	6a 10                	push   $0x10
80101d6a:	57                   	push   %edi
80101d6b:	56                   	push   %esi
80101d6c:	53                   	push   %ebx
80101d6d:	e8 8e fd ff ff       	call   80101b00 <readi>
80101d72:	83 c4 10             	add    $0x10,%esp
80101d75:	83 f8 10             	cmp    $0x10,%eax
80101d78:	75 55                	jne    80101dcf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d7f:	74 18                	je     80101d99 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d81:	83 ec 04             	sub    $0x4,%esp
80101d84:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d87:	6a 0e                	push   $0xe
80101d89:	50                   	push   %eax
80101d8a:	ff 75 0c             	push   0xc(%ebp)
80101d8d:	e8 1e 2c 00 00       	call   801049b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d92:	83 c4 10             	add    $0x10,%esp
80101d95:	85 c0                	test   %eax,%eax
80101d97:	74 17                	je     80101db0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d99:	83 c7 10             	add    $0x10,%edi
80101d9c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d9f:	72 c7                	jb     80101d68 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101da4:	31 c0                	xor    %eax,%eax
}
80101da6:	5b                   	pop    %ebx
80101da7:	5e                   	pop    %esi
80101da8:	5f                   	pop    %edi
80101da9:	5d                   	pop    %ebp
80101daa:	c3                   	ret
80101dab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101db0:	8b 45 10             	mov    0x10(%ebp),%eax
80101db3:	85 c0                	test   %eax,%eax
80101db5:	74 05                	je     80101dbc <dirlookup+0x7c>
        *poff = off;
80101db7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dba:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dbc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dc0:	8b 03                	mov    (%ebx),%eax
80101dc2:	e8 79 f5 ff ff       	call   80101340 <iget>
}
80101dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dca:	5b                   	pop    %ebx
80101dcb:	5e                   	pop    %esi
80101dcc:	5f                   	pop    %edi
80101dcd:	5d                   	pop    %ebp
80101dce:	c3                   	ret
      panic("dirlookup read");
80101dcf:	83 ec 0c             	sub    $0xc,%esp
80101dd2:	68 88 75 10 80       	push   $0x80107588
80101dd7:	e8 a4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101ddc:	83 ec 0c             	sub    $0xc,%esp
80101ddf:	68 76 75 10 80       	push   $0x80107576
80101de4:	e8 97 e5 ff ff       	call   80100380 <panic>
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101df0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	89 c3                	mov    %eax,%ebx
80101df8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dfb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dfe:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e01:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e04:	0f 84 9e 01 00 00    	je     80101fa8 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e0a:	e8 c1 1b 00 00       	call   801039d0 <myproc>
  acquire(&icache.lock);
80101e0f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e12:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e15:	68 60 f9 10 80       	push   $0x8010f960
80101e1a:	e8 b1 28 00 00       	call   801046d0 <acquire>
  ip->ref++;
80101e1f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e23:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101e2a:	e8 41 28 00 00       	call   80104670 <release>
80101e2f:	83 c4 10             	add    $0x10,%esp
80101e32:	eb 07                	jmp    80101e3b <namex+0x4b>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	0f b6 03             	movzbl (%ebx),%eax
80101e3e:	3c 2f                	cmp    $0x2f,%al
80101e40:	74 f6                	je     80101e38 <namex+0x48>
  if(*path == 0)
80101e42:	84 c0                	test   %al,%al
80101e44:	0f 84 06 01 00 00    	je     80101f50 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e4a:	0f b6 03             	movzbl (%ebx),%eax
80101e4d:	84 c0                	test   %al,%al
80101e4f:	0f 84 10 01 00 00    	je     80101f65 <namex+0x175>
80101e55:	89 df                	mov    %ebx,%edi
80101e57:	3c 2f                	cmp    $0x2f,%al
80101e59:	0f 84 06 01 00 00    	je     80101f65 <namex+0x175>
80101e5f:	90                   	nop
80101e60:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e64:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e67:	3c 2f                	cmp    $0x2f,%al
80101e69:	74 04                	je     80101e6f <namex+0x7f>
80101e6b:	84 c0                	test   %al,%al
80101e6d:	75 f1                	jne    80101e60 <namex+0x70>
  len = path - s;
80101e6f:	89 f8                	mov    %edi,%eax
80101e71:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e73:	83 f8 0d             	cmp    $0xd,%eax
80101e76:	0f 8e ac 00 00 00    	jle    80101f28 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e7c:	83 ec 04             	sub    $0x4,%esp
80101e7f:	6a 0e                	push   $0xe
80101e81:	53                   	push   %ebx
80101e82:	89 fb                	mov    %edi,%ebx
80101e84:	ff 75 e4             	push   -0x1c(%ebp)
80101e87:	e8 b4 2a 00 00       	call   80104940 <memmove>
80101e8c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e8f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e92:	75 0c                	jne    80101ea0 <namex+0xb0>
80101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e98:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e9b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e9e:	74 f8                	je     80101e98 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ea0:	83 ec 0c             	sub    $0xc,%esp
80101ea3:	56                   	push   %esi
80101ea4:	e8 47 f9 ff ff       	call   801017f0 <ilock>
    if(ip->type != T_DIR){
80101ea9:	83 c4 10             	add    $0x10,%esp
80101eac:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101eb1:	0f 85 b7 00 00 00    	jne    80101f6e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101eb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eba:	85 c0                	test   %eax,%eax
80101ebc:	74 09                	je     80101ec7 <namex+0xd7>
80101ebe:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ec1:	0f 84 f7 00 00 00    	je     80101fbe <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ec7:	83 ec 04             	sub    $0x4,%esp
80101eca:	6a 00                	push   $0x0
80101ecc:	ff 75 e4             	push   -0x1c(%ebp)
80101ecf:	56                   	push   %esi
80101ed0:	e8 6b fe ff ff       	call   80101d40 <dirlookup>
80101ed5:	83 c4 10             	add    $0x10,%esp
80101ed8:	89 c7                	mov    %eax,%edi
80101eda:	85 c0                	test   %eax,%eax
80101edc:	0f 84 8c 00 00 00    	je     80101f6e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ee2:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	51                   	push   %ecx
80101ee9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101eec:	e8 9f 25 00 00       	call   80104490 <holdingsleep>
80101ef1:	83 c4 10             	add    $0x10,%esp
80101ef4:	85 c0                	test   %eax,%eax
80101ef6:	0f 84 02 01 00 00    	je     80101ffe <namex+0x20e>
80101efc:	8b 56 08             	mov    0x8(%esi),%edx
80101eff:	85 d2                	test   %edx,%edx
80101f01:	0f 8e f7 00 00 00    	jle    80101ffe <namex+0x20e>
  releasesleep(&ip->lock);
80101f07:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f0a:	83 ec 0c             	sub    $0xc,%esp
80101f0d:	51                   	push   %ecx
80101f0e:	e8 3d 25 00 00       	call   80104450 <releasesleep>
  iput(ip);
80101f13:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101f16:	89 fe                	mov    %edi,%esi
  iput(ip);
80101f18:	e8 03 fa ff ff       	call   80101920 <iput>
80101f1d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f20:	e9 16 ff ff ff       	jmp    80101e3b <namex+0x4b>
80101f25:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f2b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101f2e:	83 ec 04             	sub    $0x4,%esp
80101f31:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f34:	50                   	push   %eax
80101f35:	53                   	push   %ebx
    name[len] = 0;
80101f36:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f38:	ff 75 e4             	push   -0x1c(%ebp)
80101f3b:	e8 00 2a 00 00       	call   80104940 <memmove>
    name[len] = 0;
80101f40:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f43:	83 c4 10             	add    $0x10,%esp
80101f46:	c6 01 00             	movb   $0x0,(%ecx)
80101f49:	e9 41 ff ff ff       	jmp    80101e8f <namex+0x9f>
80101f4e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f50:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 85 93 00 00 00    	jne    80101fee <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5e:	89 f0                	mov    %esi,%eax
80101f60:	5b                   	pop    %ebx
80101f61:	5e                   	pop    %esi
80101f62:	5f                   	pop    %edi
80101f63:	5d                   	pop    %ebp
80101f64:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f65:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f68:	89 df                	mov    %ebx,%edi
80101f6a:	31 c0                	xor    %eax,%eax
80101f6c:	eb c0                	jmp    80101f2e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 16 25 00 00       	call   80104490 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 7d                	je     80101ffe <namex+0x20e>
80101f81:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f84:	85 c9                	test   %ecx,%ecx
80101f86:	7e 76                	jle    80101ffe <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 bf 24 00 00       	call   80104450 <releasesleep>
  iput(ip);
80101f91:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f94:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f96:	e8 85 f9 ff ff       	call   80101920 <iput>
      return 0;
80101f9b:	83 c4 10             	add    $0x10,%esp
}
80101f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa1:	89 f0                	mov    %esi,%eax
80101fa3:	5b                   	pop    %ebx
80101fa4:	5e                   	pop    %esi
80101fa5:	5f                   	pop    %edi
80101fa6:	5d                   	pop    %ebp
80101fa7:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101fa8:	ba 01 00 00 00       	mov    $0x1,%edx
80101fad:	b8 01 00 00 00       	mov    $0x1,%eax
80101fb2:	e8 89 f3 ff ff       	call   80101340 <iget>
80101fb7:	89 c6                	mov    %eax,%esi
80101fb9:	e9 7d fe ff ff       	jmp    80101e3b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fbe:	83 ec 0c             	sub    $0xc,%esp
80101fc1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fc4:	53                   	push   %ebx
80101fc5:	e8 c6 24 00 00       	call   80104490 <holdingsleep>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	85 c0                	test   %eax,%eax
80101fcf:	74 2d                	je     80101ffe <namex+0x20e>
80101fd1:	8b 7e 08             	mov    0x8(%esi),%edi
80101fd4:	85 ff                	test   %edi,%edi
80101fd6:	7e 26                	jle    80101ffe <namex+0x20e>
  releasesleep(&ip->lock);
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	53                   	push   %ebx
80101fdc:	e8 6f 24 00 00       	call   80104450 <releasesleep>
}
80101fe1:	83 c4 10             	add    $0x10,%esp
}
80101fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe7:	89 f0                	mov    %esi,%eax
80101fe9:	5b                   	pop    %ebx
80101fea:	5e                   	pop    %esi
80101feb:	5f                   	pop    %edi
80101fec:	5d                   	pop    %ebp
80101fed:	c3                   	ret
    iput(ip);
80101fee:	83 ec 0c             	sub    $0xc,%esp
80101ff1:	56                   	push   %esi
      return 0;
80101ff2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ff4:	e8 27 f9 ff ff       	call   80101920 <iput>
    return 0;
80101ff9:	83 c4 10             	add    $0x10,%esp
80101ffc:	eb a0                	jmp    80101f9e <namex+0x1ae>
    panic("iunlock");
80101ffe:	83 ec 0c             	sub    $0xc,%esp
80102001:	68 6e 75 10 80       	push   $0x8010756e
80102006:	e8 75 e3 ff ff       	call   80100380 <panic>
8010200b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102010 <dirlink>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	57                   	push   %edi
80102014:	56                   	push   %esi
80102015:	53                   	push   %ebx
80102016:	83 ec 20             	sub    $0x20,%esp
80102019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010201c:	6a 00                	push   $0x0
8010201e:	ff 75 0c             	push   0xc(%ebp)
80102021:	53                   	push   %ebx
80102022:	e8 19 fd ff ff       	call   80101d40 <dirlookup>
80102027:	83 c4 10             	add    $0x10,%esp
8010202a:	85 c0                	test   %eax,%eax
8010202c:	75 67                	jne    80102095 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010202e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102031:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102034:	85 ff                	test   %edi,%edi
80102036:	74 29                	je     80102061 <dirlink+0x51>
80102038:	31 ff                	xor    %edi,%edi
8010203a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010203d:	eb 09                	jmp    80102048 <dirlink+0x38>
8010203f:	90                   	nop
80102040:	83 c7 10             	add    $0x10,%edi
80102043:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102046:	73 19                	jae    80102061 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102048:	6a 10                	push   $0x10
8010204a:	57                   	push   %edi
8010204b:	56                   	push   %esi
8010204c:	53                   	push   %ebx
8010204d:	e8 ae fa ff ff       	call   80101b00 <readi>
80102052:	83 c4 10             	add    $0x10,%esp
80102055:	83 f8 10             	cmp    $0x10,%eax
80102058:	75 4e                	jne    801020a8 <dirlink+0x98>
    if(de.inum == 0)
8010205a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010205f:	75 df                	jne    80102040 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102061:	83 ec 04             	sub    $0x4,%esp
80102064:	8d 45 da             	lea    -0x26(%ebp),%eax
80102067:	6a 0e                	push   $0xe
80102069:	ff 75 0c             	push   0xc(%ebp)
8010206c:	50                   	push   %eax
8010206d:	e8 8e 29 00 00       	call   80104a00 <strncpy>
  de.inum = inum;
80102072:	8b 45 10             	mov    0x10(%ebp),%eax
80102075:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102079:	6a 10                	push   $0x10
8010207b:	57                   	push   %edi
8010207c:	56                   	push   %esi
8010207d:	53                   	push   %ebx
8010207e:	e8 7d fb ff ff       	call   80101c00 <writei>
80102083:	83 c4 20             	add    $0x20,%esp
80102086:	83 f8 10             	cmp    $0x10,%eax
80102089:	75 2a                	jne    801020b5 <dirlink+0xa5>
  return 0;
8010208b:	31 c0                	xor    %eax,%eax
}
8010208d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102090:	5b                   	pop    %ebx
80102091:	5e                   	pop    %esi
80102092:	5f                   	pop    %edi
80102093:	5d                   	pop    %ebp
80102094:	c3                   	ret
    iput(ip);
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	50                   	push   %eax
80102099:	e8 82 f8 ff ff       	call   80101920 <iput>
    return -1;
8010209e:	83 c4 10             	add    $0x10,%esp
801020a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a6:	eb e5                	jmp    8010208d <dirlink+0x7d>
      panic("dirlink read");
801020a8:	83 ec 0c             	sub    $0xc,%esp
801020ab:	68 97 75 10 80       	push   $0x80107597
801020b0:	e8 cb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	68 16 78 10 80       	push   $0x80107816
801020bd:	e8 be e2 ff ff       	call   80100380 <panic>
801020c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020c9:	00 
801020ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020d0 <namei>:

struct inode*
namei(char *path)
{
801020d0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020d1:	31 d2                	xor    %edx,%edx
{
801020d3:	89 e5                	mov    %esp,%ebp
801020d5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020d8:	8b 45 08             	mov    0x8(%ebp),%eax
801020db:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020de:	e8 0d fd ff ff       	call   80101df0 <namex>
}
801020e3:	c9                   	leave
801020e4:	c3                   	ret
801020e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020ec:	00 
801020ed:	8d 76 00             	lea    0x0(%esi),%esi

801020f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020f0:	55                   	push   %ebp
  return namex(path, 1, name);
801020f1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020f6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020fe:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020ff:	e9 ec fc ff ff       	jmp    80101df0 <namex>
80102104:	66 90                	xchg   %ax,%ax
80102106:	66 90                	xchg   %ax,%ax
80102108:	66 90                	xchg   %ax,%ax
8010210a:	66 90                	xchg   %ax,%ax
8010210c:	66 90                	xchg   %ax,%ax
8010210e:	66 90                	xchg   %ax,%ax

80102110 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	57                   	push   %edi
80102114:	56                   	push   %esi
80102115:	53                   	push   %ebx
80102116:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102119:	85 c0                	test   %eax,%eax
8010211b:	0f 84 b4 00 00 00    	je     801021d5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102121:	8b 70 08             	mov    0x8(%eax),%esi
80102124:	89 c3                	mov    %eax,%ebx
80102126:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010212c:	0f 87 96 00 00 00    	ja     801021c8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102132:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102137:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010213e:	00 
8010213f:	90                   	nop
80102140:	89 ca                	mov    %ecx,%edx
80102142:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102143:	83 e0 c0             	and    $0xffffffc0,%eax
80102146:	3c 40                	cmp    $0x40,%al
80102148:	75 f6                	jne    80102140 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010214a:	31 ff                	xor    %edi,%edi
8010214c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102151:	89 f8                	mov    %edi,%eax
80102153:	ee                   	out    %al,(%dx)
80102154:	b8 01 00 00 00       	mov    $0x1,%eax
80102159:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010215e:	ee                   	out    %al,(%dx)
8010215f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102164:	89 f0                	mov    %esi,%eax
80102166:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102167:	89 f0                	mov    %esi,%eax
80102169:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010216e:	c1 f8 08             	sar    $0x8,%eax
80102171:	ee                   	out    %al,(%dx)
80102172:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102177:	89 f8                	mov    %edi,%eax
80102179:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010217a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010217e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102183:	c1 e0 04             	shl    $0x4,%eax
80102186:	83 e0 10             	and    $0x10,%eax
80102189:	83 c8 e0             	or     $0xffffffe0,%eax
8010218c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010218d:	f6 03 04             	testb  $0x4,(%ebx)
80102190:	75 16                	jne    801021a8 <idestart+0x98>
80102192:	b8 20 00 00 00       	mov    $0x20,%eax
80102197:	89 ca                	mov    %ecx,%edx
80102199:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010219a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010219d:	5b                   	pop    %ebx
8010219e:	5e                   	pop    %esi
8010219f:	5f                   	pop    %edi
801021a0:	5d                   	pop    %ebp
801021a1:	c3                   	ret
801021a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021a8:	b8 30 00 00 00       	mov    $0x30,%eax
801021ad:	89 ca                	mov    %ecx,%edx
801021af:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021b0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021b5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021b8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021bd:	fc                   	cld
801021be:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021c3:	5b                   	pop    %ebx
801021c4:	5e                   	pop    %esi
801021c5:	5f                   	pop    %edi
801021c6:	5d                   	pop    %ebp
801021c7:	c3                   	ret
    panic("incorrect blockno");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 ad 75 10 80       	push   $0x801075ad
801021d0:	e8 ab e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 a4 75 10 80       	push   $0x801075a4
801021dd:	e8 9e e1 ff ff       	call   80100380 <panic>
801021e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021e9:	00 
801021ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021f0 <ideinit>:
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021f6:	68 bf 75 10 80       	push   $0x801075bf
801021fb:	68 00 16 11 80       	push   $0x80111600
80102200:	e8 db 22 00 00       	call   801044e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102205:	58                   	pop    %eax
80102206:	a1 84 17 11 80       	mov    0x80111784,%eax
8010220b:	5a                   	pop    %edx
8010220c:	83 e8 01             	sub    $0x1,%eax
8010220f:	50                   	push   %eax
80102210:	6a 0e                	push   $0xe
80102212:	e8 99 02 00 00       	call   801024b0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102217:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010221a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010221f:	90                   	nop
80102220:	89 ca                	mov    %ecx,%edx
80102222:	ec                   	in     (%dx),%al
80102223:	83 e0 c0             	and    $0xffffffc0,%eax
80102226:	3c 40                	cmp    $0x40,%al
80102228:	75 f6                	jne    80102220 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010222a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010222f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102234:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102235:	89 ca                	mov    %ecx,%edx
80102237:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102238:	84 c0                	test   %al,%al
8010223a:	75 1e                	jne    8010225a <ideinit+0x6a>
8010223c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102241:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102246:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010224d:	00 
8010224e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102250:	83 e9 01             	sub    $0x1,%ecx
80102253:	74 0f                	je     80102264 <ideinit+0x74>
80102255:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102256:	84 c0                	test   %al,%al
80102258:	74 f6                	je     80102250 <ideinit+0x60>
      havedisk1 = 1;
8010225a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102261:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102264:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102269:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010226e:	ee                   	out    %al,(%dx)
}
8010226f:	c9                   	leave
80102270:	c3                   	ret
80102271:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102278:	00 
80102279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102280 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	57                   	push   %edi
80102284:	56                   	push   %esi
80102285:	53                   	push   %ebx
80102286:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102289:	68 00 16 11 80       	push   $0x80111600
8010228e:	e8 3d 24 00 00       	call   801046d0 <acquire>

  if((b = idequeue) == 0){
80102293:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102299:	83 c4 10             	add    $0x10,%esp
8010229c:	85 db                	test   %ebx,%ebx
8010229e:	74 63                	je     80102303 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022a0:	8b 43 58             	mov    0x58(%ebx),%eax
801022a3:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022a8:	8b 33                	mov    (%ebx),%esi
801022aa:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022b0:	75 2f                	jne    801022e1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022be:	00 
801022bf:	90                   	nop
801022c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c1:	89 c1                	mov    %eax,%ecx
801022c3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022c6:	80 f9 40             	cmp    $0x40,%cl
801022c9:	75 f5                	jne    801022c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022cb:	a8 21                	test   $0x21,%al
801022cd:	75 12                	jne    801022e1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022cf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022d2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022d7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022dc:	fc                   	cld
801022dd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022df:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022e1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022e4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022e7:	83 ce 02             	or     $0x2,%esi
801022ea:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ec:	53                   	push   %ebx
801022ed:	e8 5e 1e 00 00       	call   80104150 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022f2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022f7:	83 c4 10             	add    $0x10,%esp
801022fa:	85 c0                	test   %eax,%eax
801022fc:	74 05                	je     80102303 <ideintr+0x83>
    idestart(idequeue);
801022fe:	e8 0d fe ff ff       	call   80102110 <idestart>
    release(&idelock);
80102303:	83 ec 0c             	sub    $0xc,%esp
80102306:	68 00 16 11 80       	push   $0x80111600
8010230b:	e8 60 23 00 00       	call   80104670 <release>

  release(&idelock);
}
80102310:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102313:	5b                   	pop    %ebx
80102314:	5e                   	pop    %esi
80102315:	5f                   	pop    %edi
80102316:	5d                   	pop    %ebp
80102317:	c3                   	ret
80102318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010231f:	00 

80102320 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 10             	sub    $0x10,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010232a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010232d:	50                   	push   %eax
8010232e:	e8 5d 21 00 00       	call   80104490 <holdingsleep>
80102333:	83 c4 10             	add    $0x10,%esp
80102336:	85 c0                	test   %eax,%eax
80102338:	0f 84 c3 00 00 00    	je     80102401 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010233e:	8b 03                	mov    (%ebx),%eax
80102340:	83 e0 06             	and    $0x6,%eax
80102343:	83 f8 02             	cmp    $0x2,%eax
80102346:	0f 84 a8 00 00 00    	je     801023f4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010234c:	8b 53 04             	mov    0x4(%ebx),%edx
8010234f:	85 d2                	test   %edx,%edx
80102351:	74 0d                	je     80102360 <iderw+0x40>
80102353:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102358:	85 c0                	test   %eax,%eax
8010235a:	0f 84 87 00 00 00    	je     801023e7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102360:	83 ec 0c             	sub    $0xc,%esp
80102363:	68 00 16 11 80       	push   $0x80111600
80102368:	e8 63 23 00 00       	call   801046d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010236d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102372:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102379:	83 c4 10             	add    $0x10,%esp
8010237c:	85 c0                	test   %eax,%eax
8010237e:	74 60                	je     801023e0 <iderw+0xc0>
80102380:	89 c2                	mov    %eax,%edx
80102382:	8b 40 58             	mov    0x58(%eax),%eax
80102385:	85 c0                	test   %eax,%eax
80102387:	75 f7                	jne    80102380 <iderw+0x60>
80102389:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010238c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010238e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102394:	74 3a                	je     801023d0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102396:	8b 03                	mov    (%ebx),%eax
80102398:	83 e0 06             	and    $0x6,%eax
8010239b:	83 f8 02             	cmp    $0x2,%eax
8010239e:	74 1b                	je     801023bb <iderw+0x9b>
    sleep(b, &idelock);
801023a0:	83 ec 08             	sub    $0x8,%esp
801023a3:	68 00 16 11 80       	push   $0x80111600
801023a8:	53                   	push   %ebx
801023a9:	e8 e2 1c 00 00       	call   80104090 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ae:	8b 03                	mov    (%ebx),%eax
801023b0:	83 c4 10             	add    $0x10,%esp
801023b3:	83 e0 06             	and    $0x6,%eax
801023b6:	83 f8 02             	cmp    $0x2,%eax
801023b9:	75 e5                	jne    801023a0 <iderw+0x80>
  }


  release(&idelock);
801023bb:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801023c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023c5:	c9                   	leave
  release(&idelock);
801023c6:	e9 a5 22 00 00       	jmp    80104670 <release>
801023cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801023d0:	89 d8                	mov    %ebx,%eax
801023d2:	e8 39 fd ff ff       	call   80102110 <idestart>
801023d7:	eb bd                	jmp    80102396 <iderw+0x76>
801023d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023e0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023e5:	eb a5                	jmp    8010238c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023e7:	83 ec 0c             	sub    $0xc,%esp
801023ea:	68 ee 75 10 80       	push   $0x801075ee
801023ef:	e8 8c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023f4:	83 ec 0c             	sub    $0xc,%esp
801023f7:	68 d9 75 10 80       	push   $0x801075d9
801023fc:	e8 7f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102401:	83 ec 0c             	sub    $0xc,%esp
80102404:	68 c3 75 10 80       	push   $0x801075c3
80102409:	e8 72 df ff ff       	call   80100380 <panic>
8010240e:	66 90                	xchg   %ax,%ax

80102410 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102415:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
8010241c:	00 c0 fe 
  ioapic->reg = reg;
8010241f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102426:	00 00 00 
  return ioapic->data;
80102429:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010242f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102432:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102438:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010243e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102445:	c1 ee 10             	shr    $0x10,%esi
80102448:	89 f0                	mov    %esi,%eax
8010244a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010244d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102450:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102453:	39 c2                	cmp    %eax,%edx
80102455:	74 16                	je     8010246d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102457:	83 ec 0c             	sub    $0xc,%esp
8010245a:	68 cc 79 10 80       	push   $0x801079cc
8010245f:	e8 4c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102464:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010246a:	83 c4 10             	add    $0x10,%esp
{
8010246d:	ba 10 00 00 00       	mov    $0x10,%edx
80102472:	31 c0                	xor    %eax,%eax
80102474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102478:	89 13                	mov    %edx,(%ebx)
8010247a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010247d:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102483:	83 c0 01             	add    $0x1,%eax
80102486:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010248c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010248f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102492:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102495:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102497:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010249d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024a4:	39 c6                	cmp    %eax,%esi
801024a6:	7d d0                	jge    80102478 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024ab:	5b                   	pop    %ebx
801024ac:	5e                   	pop    %esi
801024ad:	5d                   	pop    %ebp
801024ae:	c3                   	ret
801024af:	90                   	nop

801024b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024b0:	55                   	push   %ebp
  ioapic->reg = reg;
801024b1:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
801024b7:	89 e5                	mov    %esp,%ebp
801024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024bc:	8d 50 20             	lea    0x20(%eax),%edx
801024bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024c5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024d6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024de:	89 50 10             	mov    %edx,0x10(%eax)
}
801024e1:	5d                   	pop    %ebp
801024e2:	c3                   	ret
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	53                   	push   %ebx
801024f4:	83 ec 04             	sub    $0x4,%esp
801024f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102500:	75 76                	jne    80102578 <kfree+0x88>
80102502:	81 fb f0 52 11 80    	cmp    $0x801152f0,%ebx
80102508:	72 6e                	jb     80102578 <kfree+0x88>
8010250a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102510:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102515:	77 61                	ja     80102578 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102517:	83 ec 04             	sub    $0x4,%esp
8010251a:	68 00 10 00 00       	push   $0x1000
8010251f:	6a 01                	push   $0x1
80102521:	53                   	push   %ebx
80102522:	e8 89 23 00 00       	call   801048b0 <memset>

  if(kmem.use_lock)
80102527:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	85 d2                	test   %edx,%edx
80102532:	75 1c                	jne    80102550 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102534:	a1 78 16 11 80       	mov    0x80111678,%eax
80102539:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010253b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102540:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102546:	85 c0                	test   %eax,%eax
80102548:	75 1e                	jne    80102568 <kfree+0x78>
    release(&kmem.lock);
}
8010254a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010254d:	c9                   	leave
8010254e:	c3                   	ret
8010254f:	90                   	nop
    acquire(&kmem.lock);
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 40 16 11 80       	push   $0x80111640
80102558:	e8 73 21 00 00       	call   801046d0 <acquire>
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	eb d2                	jmp    80102534 <kfree+0x44>
80102562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102568:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010256f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102572:	c9                   	leave
    release(&kmem.lock);
80102573:	e9 f8 20 00 00       	jmp    80104670 <release>
    panic("kfree");
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	68 0c 76 10 80       	push   $0x8010760c
80102580:	e8 fb dd ff ff       	call   80100380 <panic>
80102585:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010258c:	00 
8010258d:	8d 76 00             	lea    0x0(%esi),%esi

80102590 <freerange>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
80102594:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102595:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102598:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010259b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ad:	39 de                	cmp    %ebx,%esi
801025af:	72 23                	jb     801025d4 <freerange+0x44>
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 23 ff ff ff       	call   801024f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <freerange+0x28>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret
801025db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801025e0 <kinit2>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <kinit2+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 d3 fe ff ff       	call   801024f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret
80102635:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010263c:	00 
8010263d:	8d 76 00             	lea    0x0(%esi),%esi

80102640 <kinit1>:
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	56                   	push   %esi
80102644:	53                   	push   %ebx
80102645:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102648:	83 ec 08             	sub    $0x8,%esp
8010264b:	68 12 76 10 80       	push   $0x80107612
80102650:	68 40 16 11 80       	push   $0x80111640
80102655:	e8 86 1e 00 00       	call   801044e0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010265a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010265d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102660:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102667:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010266a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102670:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102676:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267c:	39 de                	cmp    %ebx,%esi
8010267e:	72 1c                	jb     8010269c <kinit1+0x5c>
    kfree(p);
80102680:	83 ec 0c             	sub    $0xc,%esp
80102683:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102689:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010268f:	50                   	push   %eax
80102690:	e8 5b fe ff ff       	call   801024f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102695:	83 c4 10             	add    $0x10,%esp
80102698:	39 de                	cmp    %ebx,%esi
8010269a:	73 e4                	jae    80102680 <kinit1+0x40>
}
8010269c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010269f:	5b                   	pop    %ebx
801026a0:	5e                   	pop    %esi
801026a1:	5d                   	pop    %ebp
801026a2:	c3                   	ret
801026a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026aa:	00 
801026ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801026b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	53                   	push   %ebx
801026b4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801026b7:	a1 74 16 11 80       	mov    0x80111674,%eax
801026bc:	85 c0                	test   %eax,%eax
801026be:	75 20                	jne    801026e0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026c0:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801026c6:	85 db                	test   %ebx,%ebx
801026c8:	74 07                	je     801026d1 <kalloc+0x21>
    kmem.freelist = r->next;
801026ca:	8b 03                	mov    (%ebx),%eax
801026cc:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026d1:	89 d8                	mov    %ebx,%eax
801026d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026d6:	c9                   	leave
801026d7:	c3                   	ret
801026d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026df:	00 
    acquire(&kmem.lock);
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	68 40 16 11 80       	push   $0x80111640
801026e8:	e8 e3 1f 00 00       	call   801046d0 <acquire>
  r = kmem.freelist;
801026ed:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
801026f3:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
801026f8:	83 c4 10             	add    $0x10,%esp
801026fb:	85 db                	test   %ebx,%ebx
801026fd:	74 08                	je     80102707 <kalloc+0x57>
    kmem.freelist = r->next;
801026ff:	8b 13                	mov    (%ebx),%edx
80102701:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
80102707:	85 c0                	test   %eax,%eax
80102709:	74 c6                	je     801026d1 <kalloc+0x21>
    release(&kmem.lock);
8010270b:	83 ec 0c             	sub    $0xc,%esp
8010270e:	68 40 16 11 80       	push   $0x80111640
80102713:	e8 58 1f 00 00       	call   80104670 <release>
}
80102718:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010271a:	83 c4 10             	add    $0x10,%esp
}
8010271d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102720:	c9                   	leave
80102721:	c3                   	ret
80102722:	66 90                	xchg   %ax,%ax
80102724:	66 90                	xchg   %ax,%ax
80102726:	66 90                	xchg   %ax,%ax
80102728:	66 90                	xchg   %ax,%ax
8010272a:	66 90                	xchg   %ax,%ax
8010272c:	66 90                	xchg   %ax,%ax
8010272e:	66 90                	xchg   %ax,%ax

80102730 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102730:	ba 64 00 00 00       	mov    $0x64,%edx
80102735:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102736:	a8 01                	test   $0x1,%al
80102738:	0f 84 c2 00 00 00    	je     80102800 <kbdgetc+0xd0>
{
8010273e:	55                   	push   %ebp
8010273f:	ba 60 00 00 00       	mov    $0x60,%edx
80102744:	89 e5                	mov    %esp,%ebp
80102746:	53                   	push   %ebx
80102747:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102748:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010274e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102751:	3c e0                	cmp    $0xe0,%al
80102753:	74 5b                	je     801027b0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102755:	89 da                	mov    %ebx,%edx
80102757:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010275a:	84 c0                	test   %al,%al
8010275c:	78 62                	js     801027c0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010275e:	85 d2                	test   %edx,%edx
80102760:	74 09                	je     8010276b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102762:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102765:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102768:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010276b:	0f b6 91 c0 7c 10 80 	movzbl -0x7fef8340(%ecx),%edx
  shift ^= togglecode[data];
80102772:	0f b6 81 c0 7b 10 80 	movzbl -0x7fef8440(%ecx),%eax
  shift |= shiftcode[data];
80102779:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010277b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010277d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010277f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102785:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102788:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010278b:	8b 04 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%eax
80102792:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102796:	74 0b                	je     801027a3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102798:	8d 50 9f             	lea    -0x61(%eax),%edx
8010279b:	83 fa 19             	cmp    $0x19,%edx
8010279e:	77 48                	ja     801027e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027a0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a6:	c9                   	leave
801027a7:	c3                   	ret
801027a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027af:	00 
    shift |= E0ESC;
801027b0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027b3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027b5:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
801027bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027be:	c9                   	leave
801027bf:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
801027c0:	83 e0 7f             	and    $0x7f,%eax
801027c3:	85 d2                	test   %edx,%edx
801027c5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027c8:	0f b6 81 c0 7c 10 80 	movzbl -0x7fef8340(%ecx),%eax
801027cf:	83 c8 40             	or     $0x40,%eax
801027d2:	0f b6 c0             	movzbl %al,%eax
801027d5:	f7 d0                	not    %eax
801027d7:	21 d8                	and    %ebx,%eax
801027d9:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027de:	31 c0                	xor    %eax,%eax
801027e0:	eb d9                	jmp    801027bb <kbdgetc+0x8b>
801027e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027f1:	c9                   	leave
      c += 'a' - 'A';
801027f2:	83 f9 1a             	cmp    $0x1a,%ecx
801027f5:	0f 42 c2             	cmovb  %edx,%eax
}
801027f8:	c3                   	ret
801027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102805:	c3                   	ret
80102806:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010280d:	00 
8010280e:	66 90                	xchg   %ax,%ax

80102810 <kbdintr>:

void
kbdintr(void)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102816:	68 30 27 10 80       	push   $0x80102730
8010281b:	e8 80 e0 ff ff       	call   801008a0 <consoleintr>
}
80102820:	83 c4 10             	add    $0x10,%esp
80102823:	c9                   	leave
80102824:	c3                   	ret
80102825:	66 90                	xchg   %ax,%ax
80102827:	66 90                	xchg   %ax,%ax
80102829:	66 90                	xchg   %ax,%ax
8010282b:	66 90                	xchg   %ax,%ax
8010282d:	66 90                	xchg   %ax,%ax
8010282f:	90                   	nop

80102830 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102830:	a1 80 16 11 80       	mov    0x80111680,%eax
80102835:	85 c0                	test   %eax,%eax
80102837:	0f 84 c3 00 00 00    	je     80102900 <lapicinit+0xd0>
  lapic[index] = value;
8010283d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102844:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102847:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102851:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102854:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102857:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010285e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102861:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102864:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010286b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010286e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102871:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102878:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010287b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102885:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102888:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010288b:	8b 50 30             	mov    0x30(%eax),%edx
8010288e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102894:	75 72                	jne    80102908 <lapicinit+0xd8>
  lapic[index] = value;
80102896:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010289d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b0:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028bd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ca:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028d1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028de:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028e8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028ee:	80 e6 10             	and    $0x10,%dh
801028f1:	75 f5                	jne    801028e8 <lapicinit+0xb8>
  lapic[index] = value;
801028f3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028fd:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102900:	c3                   	ret
80102901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102908:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010290f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102912:	8b 50 20             	mov    0x20(%eax),%edx
}
80102915:	e9 7c ff ff ff       	jmp    80102896 <lapicinit+0x66>
8010291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102920 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102920:	a1 80 16 11 80       	mov    0x80111680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 07                	je     80102930 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102929:	8b 40 20             	mov    0x20(%eax),%eax
8010292c:	c1 e8 18             	shr    $0x18,%eax
8010292f:	c3                   	ret
    return 0;
80102930:	31 c0                	xor    %eax,%eax
}
80102932:	c3                   	ret
80102933:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010293a:	00 
8010293b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102940 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102940:	a1 80 16 11 80       	mov    0x80111680,%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	74 0d                	je     80102956 <lapiceoi+0x16>
  lapic[index] = value;
80102949:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102950:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102953:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102956:	c3                   	ret
80102957:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010295e:	00 
8010295f:	90                   	nop

80102960 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102960:	c3                   	ret
80102961:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102968:	00 
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102970 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102970:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102971:	b8 0f 00 00 00       	mov    $0xf,%eax
80102976:	ba 70 00 00 00       	mov    $0x70,%edx
8010297b:	89 e5                	mov    %esp,%ebp
8010297d:	53                   	push   %ebx
8010297e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102981:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102984:	ee                   	out    %al,(%dx)
80102985:	b8 0a 00 00 00       	mov    $0xa,%eax
8010298a:	ba 71 00 00 00       	mov    $0x71,%edx
8010298f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102990:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102992:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102995:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010299b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010299d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
801029a0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029a2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029a5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029a8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ae:	a1 80 16 11 80       	mov    0x80111680,%eax
801029b3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029c3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029d0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029d6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029dc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029df:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029e8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029fd:	c9                   	leave
801029fe:	c3                   	ret
801029ff:	90                   	nop

80102a00 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a00:	55                   	push   %ebp
80102a01:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a06:	ba 70 00 00 00       	mov    $0x70,%edx
80102a0b:	89 e5                	mov    %esp,%ebp
80102a0d:	57                   	push   %edi
80102a0e:	56                   	push   %esi
80102a0f:	53                   	push   %ebx
80102a10:	83 ec 4c             	sub    $0x4c,%esp
80102a13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	ba 71 00 00 00       	mov    $0x71,%edx
80102a19:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a1a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a22:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a25:	8d 76 00             	lea    0x0(%esi),%esi
80102a28:	31 c0                	xor    %eax,%eax
80102a2a:	89 fa                	mov    %edi,%edx
80102a2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a32:	89 ca                	mov    %ecx,%edx
80102a34:	ec                   	in     (%dx),%al
80102a35:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 fa                	mov    %edi,%edx
80102a3a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a40:	89 ca                	mov    %ecx,%edx
80102a42:	ec                   	in     (%dx),%al
80102a43:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a46:	89 fa                	mov    %edi,%edx
80102a48:	b8 04 00 00 00       	mov    $0x4,%eax
80102a4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4e:	89 ca                	mov    %ecx,%edx
80102a50:	ec                   	in     (%dx),%al
80102a51:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a54:	89 fa                	mov    %edi,%edx
80102a56:	b8 07 00 00 00       	mov    $0x7,%eax
80102a5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5c:	89 ca                	mov    %ecx,%edx
80102a5e:	ec                   	in     (%dx),%al
80102a5f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a62:	89 fa                	mov    %edi,%edx
80102a64:	b8 08 00 00 00       	mov    $0x8,%eax
80102a69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6a:	89 ca                	mov    %ecx,%edx
80102a6c:	ec                   	in     (%dx),%al
80102a6d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6f:	89 fa                	mov    %edi,%edx
80102a71:	b8 09 00 00 00       	mov    $0x9,%eax
80102a76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a77:	89 ca                	mov    %ecx,%edx
80102a79:	ec                   	in     (%dx),%al
80102a7a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7d:	89 fa                	mov    %edi,%edx
80102a7f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a84:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a85:	89 ca                	mov    %ecx,%edx
80102a87:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a88:	84 c0                	test   %al,%al
80102a8a:	78 9c                	js     80102a28 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a8c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a90:	89 f2                	mov    %esi,%edx
80102a92:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102a95:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a98:	89 fa                	mov    %edi,%edx
80102a9a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a9d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102aa1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102aa4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102aa7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aab:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aae:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ab2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ab5:	31 c0                	xor    %eax,%eax
80102ab7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab8:	89 ca                	mov    %ecx,%edx
80102aba:	ec                   	in     (%dx),%al
80102abb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abe:	89 fa                	mov    %edi,%edx
80102ac0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ac3:	b8 02 00 00 00       	mov    $0x2,%eax
80102ac8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac9:	89 ca                	mov    %ecx,%edx
80102acb:	ec                   	in     (%dx),%al
80102acc:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acf:	89 fa                	mov    %edi,%edx
80102ad1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ad4:	b8 04 00 00 00       	mov    $0x4,%eax
80102ad9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ada:	89 ca                	mov    %ecx,%edx
80102adc:	ec                   	in     (%dx),%al
80102add:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae0:	89 fa                	mov    %edi,%edx
80102ae2:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ae5:	b8 07 00 00 00       	mov    $0x7,%eax
80102aea:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aeb:	89 ca                	mov    %ecx,%edx
80102aed:	ec                   	in     (%dx),%al
80102aee:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af1:	89 fa                	mov    %edi,%edx
80102af3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102af6:	b8 08 00 00 00       	mov    $0x8,%eax
80102afb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afc:	89 ca                	mov    %ecx,%edx
80102afe:	ec                   	in     (%dx),%al
80102aff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b02:	89 fa                	mov    %edi,%edx
80102b04:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b07:	b8 09 00 00 00       	mov    $0x9,%eax
80102b0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0d:	89 ca                	mov    %ecx,%edx
80102b0f:	ec                   	in     (%dx),%al
80102b10:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b13:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b19:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b1c:	6a 18                	push   $0x18
80102b1e:	50                   	push   %eax
80102b1f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b22:	50                   	push   %eax
80102b23:	e8 c8 1d 00 00       	call   801048f0 <memcmp>
80102b28:	83 c4 10             	add    $0x10,%esp
80102b2b:	85 c0                	test   %eax,%eax
80102b2d:	0f 85 f5 fe ff ff    	jne    80102a28 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b33:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b3a:	89 f0                	mov    %esi,%eax
80102b3c:	84 c0                	test   %al,%al
80102b3e:	75 78                	jne    80102bb8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b40:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b43:	89 c2                	mov    %eax,%edx
80102b45:	83 e0 0f             	and    $0xf,%eax
80102b48:	c1 ea 04             	shr    $0x4,%edx
80102b4b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b51:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b54:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b57:	89 c2                	mov    %eax,%edx
80102b59:	83 e0 0f             	and    $0xf,%eax
80102b5c:	c1 ea 04             	shr    $0x4,%edx
80102b5f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b62:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b65:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b68:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b6b:	89 c2                	mov    %eax,%edx
80102b6d:	83 e0 0f             	and    $0xf,%eax
80102b70:	c1 ea 04             	shr    $0x4,%edx
80102b73:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b76:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b79:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b7c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7f:	89 c2                	mov    %eax,%edx
80102b81:	83 e0 0f             	and    $0xf,%eax
80102b84:	c1 ea 04             	shr    $0x4,%edx
80102b87:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b90:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b93:	89 c2                	mov    %eax,%edx
80102b95:	83 e0 0f             	and    $0xf,%eax
80102b98:	c1 ea 04             	shr    $0x4,%edx
80102b9b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ba4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba7:	89 c2                	mov    %eax,%edx
80102ba9:	83 e0 0f             	and    $0xf,%eax
80102bac:	c1 ea 04             	shr    $0x4,%edx
80102baf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bbb:	89 03                	mov    %eax,(%ebx)
80102bbd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bc0:	89 43 04             	mov    %eax,0x4(%ebx)
80102bc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bc6:	89 43 08             	mov    %eax,0x8(%ebx)
80102bc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bcc:	89 43 0c             	mov    %eax,0xc(%ebx)
80102bcf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bd2:	89 43 10             	mov    %eax,0x10(%ebx)
80102bd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bd8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102bdb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102be2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102be5:	5b                   	pop    %ebx
80102be6:	5e                   	pop    %esi
80102be7:	5f                   	pop    %edi
80102be8:	5d                   	pop    %ebp
80102be9:	c3                   	ret
80102bea:	66 90                	xchg   %ax,%ax
80102bec:	66 90                	xchg   %ax,%ax
80102bee:	66 90                	xchg   %ax,%ax

80102bf0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bf0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102bf6:	85 c9                	test   %ecx,%ecx
80102bf8:	0f 8e 8a 00 00 00    	jle    80102c88 <install_trans+0x98>
{
80102bfe:	55                   	push   %ebp
80102bff:	89 e5                	mov    %esp,%ebp
80102c01:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c02:	31 ff                	xor    %edi,%edi
{
80102c04:	56                   	push   %esi
80102c05:	53                   	push   %ebx
80102c06:	83 ec 0c             	sub    $0xc,%esp
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c10:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102c15:	83 ec 08             	sub    $0x8,%esp
80102c18:	01 f8                	add    %edi,%eax
80102c1a:	83 c0 01             	add    $0x1,%eax
80102c1d:	50                   	push   %eax
80102c1e:	ff 35 e4 16 11 80    	push   0x801116e4
80102c24:	e8 a7 d4 ff ff       	call   801000d0 <bread>
80102c29:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2b:	58                   	pop    %eax
80102c2c:	5a                   	pop    %edx
80102c2d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c34:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c3a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c3d:	e8 8e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c45:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c47:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c4a:	68 00 02 00 00       	push   $0x200
80102c4f:	50                   	push   %eax
80102c50:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c53:	50                   	push   %eax
80102c54:	e8 e7 1c 00 00       	call   80104940 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 4f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 87 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c69:	89 1c 24             	mov    %ebx,(%esp)
80102c6c:	e8 7f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c71:	83 c4 10             	add    $0x10,%esp
80102c74:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c7a:	7f 94                	jg     80102c10 <install_trans+0x20>
  }
}
80102c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c7f:	5b                   	pop    %ebx
80102c80:	5e                   	pop    %esi
80102c81:	5f                   	pop    %edi
80102c82:	5d                   	pop    %ebp
80102c83:	c3                   	ret
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c88:	c3                   	ret
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	53                   	push   %ebx
80102c94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c97:	ff 35 d4 16 11 80    	push   0x801116d4
80102c9d:	ff 35 e4 16 11 80    	push   0x801116e4
80102ca3:	e8 28 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ca8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102cad:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102cb2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cb5:	85 c0                	test   %eax,%eax
80102cb7:	7e 19                	jle    80102cd2 <write_head+0x42>
80102cb9:	31 d2                	xor    %edx,%edx
80102cbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102cc0:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102cc7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ccb:	83 c2 01             	add    $0x1,%edx
80102cce:	39 d0                	cmp    %edx,%eax
80102cd0:	75 ee                	jne    80102cc0 <write_head+0x30>
  }
  bwrite(buf);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
80102cd5:	53                   	push   %ebx
80102cd6:	e8 d5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cdb:	89 1c 24             	mov    %ebx,(%esp)
80102cde:	e8 0d d5 ff ff       	call   801001f0 <brelse>
}
80102ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce6:	83 c4 10             	add    $0x10,%esp
80102ce9:	c9                   	leave
80102cea:	c3                   	ret
80102ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102cf0 <initlog>:
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	53                   	push   %ebx
80102cf4:	83 ec 2c             	sub    $0x2c,%esp
80102cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cfa:	68 17 76 10 80       	push   $0x80107617
80102cff:	68 a0 16 11 80       	push   $0x801116a0
80102d04:	e8 d7 17 00 00       	call   801044e0 <initlock>
  readsb(dev, &sb);
80102d09:	58                   	pop    %eax
80102d0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 7b e8 ff ff       	call   80101590 <readsb>
  log.start = sb.logstart;
80102d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d18:	59                   	pop    %ecx
  log.dev = dev;
80102d19:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102d1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d22:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102d27:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102d2d:	5a                   	pop    %edx
80102d2e:	50                   	push   %eax
80102d2f:	53                   	push   %ebx
80102d30:	e8 9b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d35:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d38:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d3b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d41:	85 db                	test   %ebx,%ebx
80102d43:	7e 1d                	jle    80102d62 <initlog+0x72>
80102d45:	31 d2                	xor    %edx,%edx
80102d47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d4e:	00 
80102d4f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d50:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d54:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d5b:	83 c2 01             	add    $0x1,%edx
80102d5e:	39 d3                	cmp    %edx,%ebx
80102d60:	75 ee                	jne    80102d50 <initlog+0x60>
  brelse(buf);
80102d62:	83 ec 0c             	sub    $0xc,%esp
80102d65:	50                   	push   %eax
80102d66:	e8 85 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d6b:	e8 80 fe ff ff       	call   80102bf0 <install_trans>
  log.lh.n = 0;
80102d70:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d77:	00 00 00 
  write_head(); // clear the log
80102d7a:	e8 11 ff ff ff       	call   80102c90 <write_head>
}
80102d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d82:	83 c4 10             	add    $0x10,%esp
80102d85:	c9                   	leave
80102d86:	c3                   	ret
80102d87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d8e:	00 
80102d8f:	90                   	nop

80102d90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d96:	68 a0 16 11 80       	push   $0x801116a0
80102d9b:	e8 30 19 00 00       	call   801046d0 <acquire>
80102da0:	83 c4 10             	add    $0x10,%esp
80102da3:	eb 18                	jmp    80102dbd <begin_op+0x2d>
80102da5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102da8:	83 ec 08             	sub    $0x8,%esp
80102dab:	68 a0 16 11 80       	push   $0x801116a0
80102db0:	68 a0 16 11 80       	push   $0x801116a0
80102db5:	e8 d6 12 00 00       	call   80104090 <sleep>
80102dba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dbd:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102dc2:	85 c0                	test   %eax,%eax
80102dc4:	75 e2                	jne    80102da8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dc6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102dcb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102dd1:	83 c0 01             	add    $0x1,%eax
80102dd4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dd7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dda:	83 fa 1e             	cmp    $0x1e,%edx
80102ddd:	7f c9                	jg     80102da8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ddf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102de2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102de7:	68 a0 16 11 80       	push   $0x801116a0
80102dec:	e8 7f 18 00 00       	call   80104670 <release>
      break;
    }
  }
}
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	c9                   	leave
80102df5:	c3                   	ret
80102df6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dfd:	00 
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	57                   	push   %edi
80102e04:	56                   	push   %esi
80102e05:	53                   	push   %ebx
80102e06:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e09:	68 a0 16 11 80       	push   $0x801116a0
80102e0e:	e8 bd 18 00 00       	call   801046d0 <acquire>
  log.outstanding -= 1;
80102e13:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102e18:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102e1e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e21:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e24:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102e2a:	85 f6                	test   %esi,%esi
80102e2c:	0f 85 22 01 00 00    	jne    80102f54 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e32:	85 db                	test   %ebx,%ebx
80102e34:	0f 85 f6 00 00 00    	jne    80102f30 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e3a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e41:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e44:	83 ec 0c             	sub    $0xc,%esp
80102e47:	68 a0 16 11 80       	push   $0x801116a0
80102e4c:	e8 1f 18 00 00       	call   80104670 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e51:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e57:	83 c4 10             	add    $0x10,%esp
80102e5a:	85 c9                	test   %ecx,%ecx
80102e5c:	7f 42                	jg     80102ea0 <end_op+0xa0>
    acquire(&log.lock);
80102e5e:	83 ec 0c             	sub    $0xc,%esp
80102e61:	68 a0 16 11 80       	push   $0x801116a0
80102e66:	e8 65 18 00 00       	call   801046d0 <acquire>
    log.committing = 0;
80102e6b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e72:	00 00 00 
    wakeup(&log);
80102e75:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e7c:	e8 cf 12 00 00       	call   80104150 <wakeup>
    release(&log.lock);
80102e81:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e88:	e8 e3 17 00 00       	call   80104670 <release>
80102e8d:	83 c4 10             	add    $0x10,%esp
}
80102e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e93:	5b                   	pop    %ebx
80102e94:	5e                   	pop    %esi
80102e95:	5f                   	pop    %edi
80102e96:	5d                   	pop    %ebp
80102e97:	c3                   	ret
80102e98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e9f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ea0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102ea5:	83 ec 08             	sub    $0x8,%esp
80102ea8:	01 d8                	add    %ebx,%eax
80102eaa:	83 c0 01             	add    $0x1,%eax
80102ead:	50                   	push   %eax
80102eae:	ff 35 e4 16 11 80    	push   0x801116e4
80102eb4:	e8 17 d2 ff ff       	call   801000d0 <bread>
80102eb9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebb:	58                   	pop    %eax
80102ebc:	5a                   	pop    %edx
80102ebd:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102ec4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ecd:	e8 fe d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ed2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ed5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ed7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eda:	68 00 02 00 00       	push   $0x200
80102edf:	50                   	push   %eax
80102ee0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ee3:	50                   	push   %eax
80102ee4:	e8 57 1a 00 00       	call   80104940 <memmove>
    bwrite(to);  // write the log
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 bf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ef1:	89 3c 24             	mov    %edi,(%esp)
80102ef4:	e8 f7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ef9:	89 34 24             	mov    %esi,(%esp)
80102efc:	e8 ef d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f01:	83 c4 10             	add    $0x10,%esp
80102f04:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102f0a:	7c 94                	jl     80102ea0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f0c:	e8 7f fd ff ff       	call   80102c90 <write_head>
    install_trans(); // Now install writes to home locations
80102f11:	e8 da fc ff ff       	call   80102bf0 <install_trans>
    log.lh.n = 0;
80102f16:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102f1d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f20:	e8 6b fd ff ff       	call   80102c90 <write_head>
80102f25:	e9 34 ff ff ff       	jmp    80102e5e <end_op+0x5e>
80102f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f30:	83 ec 0c             	sub    $0xc,%esp
80102f33:	68 a0 16 11 80       	push   $0x801116a0
80102f38:	e8 13 12 00 00       	call   80104150 <wakeup>
  release(&log.lock);
80102f3d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f44:	e8 27 17 00 00       	call   80104670 <release>
80102f49:	83 c4 10             	add    $0x10,%esp
}
80102f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f4f:	5b                   	pop    %ebx
80102f50:	5e                   	pop    %esi
80102f51:	5f                   	pop    %edi
80102f52:	5d                   	pop    %ebp
80102f53:	c3                   	ret
    panic("log.committing");
80102f54:	83 ec 0c             	sub    $0xc,%esp
80102f57:	68 1b 76 10 80       	push   $0x8010761b
80102f5c:	e8 1f d4 ff ff       	call   80100380 <panic>
80102f61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f68:	00 
80102f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	53                   	push   %ebx
80102f74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f77:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f80:	83 fa 1d             	cmp    $0x1d,%edx
80102f83:	7f 7d                	jg     80103002 <log_write+0x92>
80102f85:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f8a:	83 e8 01             	sub    $0x1,%eax
80102f8d:	39 c2                	cmp    %eax,%edx
80102f8f:	7d 71                	jge    80103002 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f91:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f96:	85 c0                	test   %eax,%eax
80102f98:	7e 75                	jle    8010300f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f9a:	83 ec 0c             	sub    $0xc,%esp
80102f9d:	68 a0 16 11 80       	push   $0x801116a0
80102fa2:	e8 29 17 00 00       	call   801046d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102faa:	83 c4 10             	add    $0x10,%esp
80102fad:	31 c0                	xor    %eax,%eax
80102faf:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102fb5:	85 d2                	test   %edx,%edx
80102fb7:	7f 0e                	jg     80102fc7 <log_write+0x57>
80102fb9:	eb 15                	jmp    80102fd0 <log_write+0x60>
80102fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fc0:	83 c0 01             	add    $0x1,%eax
80102fc3:	39 c2                	cmp    %eax,%edx
80102fc5:	74 29                	je     80102ff0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102fce:	75 f0                	jne    80102fc0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102fd7:	39 c2                	cmp    %eax,%edx
80102fd9:	74 1c                	je     80102ff7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fdb:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fe1:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102fe8:	c9                   	leave
  release(&log.lock);
80102fe9:	e9 82 16 00 00       	jmp    80104670 <release>
80102fee:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102ff7:	83 c2 01             	add    $0x1,%edx
80102ffa:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103000:	eb d9                	jmp    80102fdb <log_write+0x6b>
    panic("too big a transaction");
80103002:	83 ec 0c             	sub    $0xc,%esp
80103005:	68 2a 76 10 80       	push   $0x8010762a
8010300a:	e8 71 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010300f:	83 ec 0c             	sub    $0xc,%esp
80103012:	68 40 76 10 80       	push   $0x80107640
80103017:	e8 64 d3 ff ff       	call   80100380 <panic>
8010301c:	66 90                	xchg   %ax,%ax
8010301e:	66 90                	xchg   %ax,%ax

80103020 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	53                   	push   %ebx
80103024:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103027:	e8 84 09 00 00       	call   801039b0 <cpuid>
8010302c:	89 c3                	mov    %eax,%ebx
8010302e:	e8 7d 09 00 00       	call   801039b0 <cpuid>
80103033:	83 ec 04             	sub    $0x4,%esp
80103036:	53                   	push   %ebx
80103037:	50                   	push   %eax
80103038:	68 5b 76 10 80       	push   $0x8010765b
8010303d:	e8 6e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103042:	e8 69 2b 00 00       	call   80105bb0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103047:	e8 04 09 00 00       	call   80103950 <mycpu>
8010304c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010304e:	b8 01 00 00 00       	mov    $0x1,%eax
80103053:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010305a:	e8 21 0c 00 00       	call   80103c80 <scheduler>
8010305f:	90                   	nop

80103060 <mpenter>:
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103066:	e8 45 3c 00 00       	call   80106cb0 <switchkvm>
  seginit();
8010306b:	e8 b0 3b 00 00       	call   80106c20 <seginit>
  lapicinit();
80103070:	e8 bb f7 ff ff       	call   80102830 <lapicinit>
  mpmain();
80103075:	e8 a6 ff ff ff       	call   80103020 <mpmain>
8010307a:	66 90                	xchg   %ax,%ax
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <main>:
{
80103080:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103084:	83 e4 f0             	and    $0xfffffff0,%esp
80103087:	ff 71 fc             	push   -0x4(%ecx)
8010308a:	55                   	push   %ebp
8010308b:	89 e5                	mov    %esp,%ebp
8010308d:	53                   	push   %ebx
8010308e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010308f:	83 ec 08             	sub    $0x8,%esp
80103092:	68 00 00 40 80       	push   $0x80400000
80103097:	68 f0 52 11 80       	push   $0x801152f0
8010309c:	e8 9f f5 ff ff       	call   80102640 <kinit1>
  kvmalloc();      // kernel page table
801030a1:	e8 ca 40 00 00       	call   80107170 <kvmalloc>
  mpinit();        // detect other processors
801030a6:	e8 a5 01 00 00       	call   80103250 <mpinit>
  lapicinit();     // interrupt controller
801030ab:	e8 80 f7 ff ff       	call   80102830 <lapicinit>
  seginit();       // segment descriptors
801030b0:	e8 6b 3b 00 00       	call   80106c20 <seginit>
  picinit();       // disable pic
801030b5:	e8 a6 03 00 00       	call   80103460 <picinit>
  ioapicinit();    // another interrupt controller
801030ba:	e8 51 f3 ff ff       	call   80102410 <ioapicinit>
  consoleinit();   // console hardware
801030bf:	e8 9c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030c4:	e8 c7 2d 00 00       	call   80105e90 <uartinit>
  pinit();         // process table
801030c9:	e8 62 08 00 00       	call   80103930 <pinit>
  cprintf("salam");
801030ce:	c7 04 24 6f 76 10 80 	movl   $0x8010766f,(%esp)
801030d5:	e8 d6 d5 ff ff       	call   801006b0 <cprintf>
  rinit();
801030da:	e8 11 12 00 00       	call   801042f0 <rinit>
  cprintf("kh");
801030df:	c7 04 24 75 76 10 80 	movl   $0x80107675,(%esp)
801030e6:	e8 c5 d5 ff ff       	call   801006b0 <cprintf>
  tvinit();        // trap vectors
801030eb:	e8 40 2a 00 00       	call   80105b30 <tvinit>
  binit();         // buffer cache
801030f0:	e8 4b cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030f5:	e8 86 dd ff ff       	call   80100e80 <fileinit>
  ideinit();       // disk 
801030fa:	e8 f1 f0 ff ff       	call   801021f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030ff:	83 c4 0c             	add    $0xc,%esp
80103102:	68 8a 00 00 00       	push   $0x8a
80103107:	68 8c a4 10 80       	push   $0x8010a48c
8010310c:	68 00 70 00 80       	push   $0x80007000
80103111:	e8 2a 18 00 00       	call   80104940 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103116:	83 c4 10             	add    $0x10,%esp
80103119:	69 05 84 17 11 80 b4 	imul   $0xb4,0x80111784,%eax
80103120:	00 00 00 
80103123:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103128:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
8010312d:	0f 86 7d 00 00 00    	jbe    801031b0 <main+0x130>
80103133:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103138:	eb 1f                	jmp    80103159 <main+0xd9>
8010313a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103140:	69 05 84 17 11 80 b4 	imul   $0xb4,0x80111784,%eax
80103147:	00 00 00 
8010314a:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80103150:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103155:	39 c3                	cmp    %eax,%ebx
80103157:	73 57                	jae    801031b0 <main+0x130>
    if(c == mycpu())  // We've started already.
80103159:	e8 f2 07 00 00       	call   80103950 <mycpu>
8010315e:	39 c3                	cmp    %eax,%ebx
80103160:	74 de                	je     80103140 <main+0xc0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103162:	e8 49 f5 ff ff       	call   801026b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103167:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010316a:	c7 05 f8 6f 00 80 60 	movl   $0x80103060,0x80006ff8
80103171:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103174:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010317b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010317e:	05 00 10 00 00       	add    $0x1000,%eax
80103183:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103188:	0f b6 03             	movzbl (%ebx),%eax
8010318b:	68 00 70 00 00       	push   $0x7000
80103190:	50                   	push   %eax
80103191:	e8 da f7 ff ff       	call   80102970 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103196:	83 c4 10             	add    $0x10,%esp
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031a6:	85 c0                	test   %eax,%eax
801031a8:	74 f6                	je     801031a0 <main+0x120>
801031aa:	eb 94                	jmp    80103140 <main+0xc0>
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031b0:	83 ec 08             	sub    $0x8,%esp
801031b3:	68 00 00 00 8e       	push   $0x8e000000
801031b8:	68 00 00 40 80       	push   $0x80400000
801031bd:	e8 1e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
801031c2:	e8 39 08 00 00       	call   80103a00 <userinit>
  mpmain();        // finish this processor's setup
801031c7:	e8 54 fe ff ff       	call   80103020 <mpmain>
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031db:	53                   	push   %ebx
  e = addr+len;
801031dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031e2:	39 de                	cmp    %ebx,%esi
801031e4:	72 10                	jb     801031f6 <mpsearch1+0x26>
801031e6:	eb 50                	jmp    80103238 <mpsearch1+0x68>
801031e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031ef:	00 
801031f0:	89 fe                	mov    %edi,%esi
801031f2:	39 df                	cmp    %ebx,%edi
801031f4:	73 42                	jae    80103238 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f6:	83 ec 04             	sub    $0x4,%esp
801031f9:	8d 7e 10             	lea    0x10(%esi),%edi
801031fc:	6a 04                	push   $0x4
801031fe:	68 78 76 10 80       	push   $0x80107678
80103203:	56                   	push   %esi
80103204:	e8 e7 16 00 00       	call   801048f0 <memcmp>
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	85 c0                	test   %eax,%eax
8010320e:	75 e0                	jne    801031f0 <mpsearch1+0x20>
80103210:	89 f2                	mov    %esi,%edx
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103218:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010321b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010321e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103220:	39 fa                	cmp    %edi,%edx
80103222:	75 f4                	jne    80103218 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103224:	84 c0                	test   %al,%al
80103226:	75 c8                	jne    801031f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010322b:	89 f0                	mov    %esi,%eax
8010322d:	5b                   	pop    %ebx
8010322e:	5e                   	pop    %esi
8010322f:	5f                   	pop    %edi
80103230:	5d                   	pop    %ebp
80103231:	c3                   	ret
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010323b:	31 f6                	xor    %esi,%esi
}
8010323d:	5b                   	pop    %ebx
8010323e:	89 f0                	mov    %esi,%eax
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret
80103244:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010324b:	00 
8010324c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103250 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103259:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103260:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103267:	c1 e0 08             	shl    $0x8,%eax
8010326a:	09 d0                	or     %edx,%eax
8010326c:	c1 e0 04             	shl    $0x4,%eax
8010326f:	75 1b                	jne    8010328c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103271:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103278:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010327f:	c1 e0 08             	shl    $0x8,%eax
80103282:	09 d0                	or     %edx,%eax
80103284:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103287:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010328c:	ba 00 04 00 00       	mov    $0x400,%edx
80103291:	e8 3a ff ff ff       	call   801031d0 <mpsearch1>
80103296:	89 c3                	mov    %eax,%ebx
80103298:	85 c0                	test   %eax,%eax
8010329a:	0f 84 58 01 00 00    	je     801033f8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032a0:	8b 73 04             	mov    0x4(%ebx),%esi
801032a3:	85 f6                	test   %esi,%esi
801032a5:	0f 84 3d 01 00 00    	je     801033e8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801032ab:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ae:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801032b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032b7:	6a 04                	push   $0x4
801032b9:	68 7d 76 10 80       	push   $0x8010767d
801032be:	50                   	push   %eax
801032bf:	e8 2c 16 00 00       	call   801048f0 <memcmp>
801032c4:	83 c4 10             	add    $0x10,%esp
801032c7:	85 c0                	test   %eax,%eax
801032c9:	0f 85 19 01 00 00    	jne    801033e8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
801032cf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032d6:	3c 01                	cmp    $0x1,%al
801032d8:	74 08                	je     801032e2 <mpinit+0x92>
801032da:	3c 04                	cmp    $0x4,%al
801032dc:	0f 85 06 01 00 00    	jne    801033e8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801032e2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032e9:	66 85 d2             	test   %dx,%dx
801032ec:	74 22                	je     80103310 <mpinit+0xc0>
801032ee:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032f1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032f3:	31 d2                	xor    %edx,%edx
801032f5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032f8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032ff:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103302:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103304:	39 f8                	cmp    %edi,%eax
80103306:	75 f0                	jne    801032f8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103308:	84 d2                	test   %dl,%dl
8010330a:	0f 85 d8 00 00 00    	jne    801033e8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103310:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103316:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103319:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010331c:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103321:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103328:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010332e:	01 d7                	add    %edx,%edi
80103330:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103332:	bf 01 00 00 00       	mov    $0x1,%edi
80103337:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010333e:	00 
8010333f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103340:	39 d0                	cmp    %edx,%eax
80103342:	73 19                	jae    8010335d <mpinit+0x10d>
    switch(*p){
80103344:	0f b6 08             	movzbl (%eax),%ecx
80103347:	80 f9 02             	cmp    $0x2,%cl
8010334a:	0f 84 80 00 00 00    	je     801033d0 <mpinit+0x180>
80103350:	77 6e                	ja     801033c0 <mpinit+0x170>
80103352:	84 c9                	test   %cl,%cl
80103354:	74 3a                	je     80103390 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103356:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103359:	39 d0                	cmp    %edx,%eax
8010335b:	72 e7                	jb     80103344 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010335d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103360:	85 ff                	test   %edi,%edi
80103362:	0f 84 dd 00 00 00    	je     80103445 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103368:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010336c:	74 15                	je     80103383 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336e:	b8 70 00 00 00       	mov    $0x70,%eax
80103373:	ba 22 00 00 00       	mov    $0x22,%edx
80103378:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103379:	ba 23 00 00 00       	mov    $0x23,%edx
8010337e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010337f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103382:	ee                   	out    %al,(%dx)
  }
}
80103383:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103386:	5b                   	pop    %ebx
80103387:	5e                   	pop    %esi
80103388:	5f                   	pop    %edi
80103389:	5d                   	pop    %ebp
8010338a:	c3                   	ret
8010338b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103390:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103396:	83 f9 03             	cmp    $0x3,%ecx
80103399:	7f 19                	jg     801033b4 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339b:	69 f1 b4 00 00 00    	imul   $0xb4,%ecx,%esi
801033a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033a5:	83 c1 01             	add    $0x1,%ecx
801033a8:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ae:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
      p += sizeof(struct mpproc);
801033b4:	83 c0 14             	add    $0x14,%eax
      continue;
801033b7:	eb 87                	jmp    80103340 <mpinit+0xf0>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
801033c0:	83 e9 03             	sub    $0x3,%ecx
801033c3:	80 f9 01             	cmp    $0x1,%cl
801033c6:	76 8e                	jbe    80103356 <mpinit+0x106>
801033c8:	31 ff                	xor    %edi,%edi
801033ca:	e9 71 ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033cf:	90                   	nop
      ioapicid = ioapic->apicno;
801033d0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033d4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033d7:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
801033dd:	e9 5e ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033e8:	83 ec 0c             	sub    $0xc,%esp
801033eb:	68 82 76 10 80       	push   $0x80107682
801033f0:	e8 8b cf ff ff       	call   80100380 <panic>
801033f5:	8d 76 00             	lea    0x0(%esi),%esi
{
801033f8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033fd:	eb 0b                	jmp    8010340a <mpinit+0x1ba>
801033ff:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103400:	89 f3                	mov    %esi,%ebx
80103402:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103408:	74 de                	je     801033e8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010340a:	83 ec 04             	sub    $0x4,%esp
8010340d:	8d 73 10             	lea    0x10(%ebx),%esi
80103410:	6a 04                	push   $0x4
80103412:	68 78 76 10 80       	push   $0x80107678
80103417:	53                   	push   %ebx
80103418:	e8 d3 14 00 00       	call   801048f0 <memcmp>
8010341d:	83 c4 10             	add    $0x10,%esp
80103420:	85 c0                	test   %eax,%eax
80103422:	75 dc                	jne    80103400 <mpinit+0x1b0>
80103424:	89 da                	mov    %ebx,%edx
80103426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010342d:	00 
8010342e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103430:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103433:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103436:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103438:	39 d6                	cmp    %edx,%esi
8010343a:	75 f4                	jne    80103430 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010343c:	84 c0                	test   %al,%al
8010343e:	75 c0                	jne    80103400 <mpinit+0x1b0>
80103440:	e9 5b fe ff ff       	jmp    801032a0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103445:	83 ec 0c             	sub    $0xc,%esp
80103448:	68 00 7a 10 80       	push   $0x80107a00
8010344d:	e8 2e cf ff ff       	call   80100380 <panic>
80103452:	66 90                	xchg   %ax,%ax
80103454:	66 90                	xchg   %ax,%ax
80103456:	66 90                	xchg   %ax,%ax
80103458:	66 90                	xchg   %ax,%ax
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <picinit>:
80103460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103465:	ba 21 00 00 00       	mov    $0x21,%edx
8010346a:	ee                   	out    %al,(%dx)
8010346b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103470:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103471:	c3                   	ret
80103472:	66 90                	xchg   %ax,%ax
80103474:	66 90                	xchg   %ax,%ax
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 0c             	sub    $0xc,%esp
80103489:	8b 75 08             	mov    0x8(%ebp),%esi
8010348c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010348f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103495:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010349b:	e8 00 da ff ff       	call   80100ea0 <filealloc>
801034a0:	89 06                	mov    %eax,(%esi)
801034a2:	85 c0                	test   %eax,%eax
801034a4:	0f 84 a5 00 00 00    	je     8010354f <pipealloc+0xcf>
801034aa:	e8 f1 d9 ff ff       	call   80100ea0 <filealloc>
801034af:	89 07                	mov    %eax,(%edi)
801034b1:	85 c0                	test   %eax,%eax
801034b3:	0f 84 84 00 00 00    	je     8010353d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034b9:	e8 f2 f1 ff ff       	call   801026b0 <kalloc>
801034be:	89 c3                	mov    %eax,%ebx
801034c0:	85 c0                	test   %eax,%eax
801034c2:	0f 84 a0 00 00 00    	je     80103568 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801034c8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034cf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034d2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034dc:	00 00 00 
  p->nwrite = 0;
801034df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034e6:	00 00 00 
  p->nread = 0;
801034e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034f0:	00 00 00 
  initlock(&p->lock, "pipe");
801034f3:	68 9a 76 10 80       	push   $0x8010769a
801034f8:	50                   	push   %eax
801034f9:	e8 e2 0f 00 00       	call   801044e0 <initlock>
  (*f0)->type = FD_PIPE;
801034fe:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103500:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103503:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103509:	8b 06                	mov    (%esi),%eax
8010350b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010350f:	8b 06                	mov    (%esi),%eax
80103511:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103515:	8b 06                	mov    (%esi),%eax
80103517:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010351a:	8b 07                	mov    (%edi),%eax
8010351c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103522:	8b 07                	mov    (%edi),%eax
80103524:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103528:	8b 07                	mov    (%edi),%eax
8010352a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010352e:	8b 07                	mov    (%edi),%eax
80103530:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103533:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103535:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103538:	5b                   	pop    %ebx
80103539:	5e                   	pop    %esi
8010353a:	5f                   	pop    %edi
8010353b:	5d                   	pop    %ebp
8010353c:	c3                   	ret
  if(*f0)
8010353d:	8b 06                	mov    (%esi),%eax
8010353f:	85 c0                	test   %eax,%eax
80103541:	74 1e                	je     80103561 <pipealloc+0xe1>
    fileclose(*f0);
80103543:	83 ec 0c             	sub    $0xc,%esp
80103546:	50                   	push   %eax
80103547:	e8 14 da ff ff       	call   80100f60 <fileclose>
8010354c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010354f:	8b 07                	mov    (%edi),%eax
80103551:	85 c0                	test   %eax,%eax
80103553:	74 0c                	je     80103561 <pipealloc+0xe1>
    fileclose(*f1);
80103555:	83 ec 0c             	sub    $0xc,%esp
80103558:	50                   	push   %eax
80103559:	e8 02 da ff ff       	call   80100f60 <fileclose>
8010355e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103566:	eb cd                	jmp    80103535 <pipealloc+0xb5>
  if(*f0)
80103568:	8b 06                	mov    (%esi),%eax
8010356a:	85 c0                	test   %eax,%eax
8010356c:	75 d5                	jne    80103543 <pipealloc+0xc3>
8010356e:	eb df                	jmp    8010354f <pipealloc+0xcf>

80103570 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
80103575:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103578:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010357b:	83 ec 0c             	sub    $0xc,%esp
8010357e:	53                   	push   %ebx
8010357f:	e8 4c 11 00 00       	call   801046d0 <acquire>
  if(writable){
80103584:	83 c4 10             	add    $0x10,%esp
80103587:	85 f6                	test   %esi,%esi
80103589:	74 65                	je     801035f0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010358b:	83 ec 0c             	sub    $0xc,%esp
8010358e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103594:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010359b:	00 00 00 
    wakeup(&p->nread);
8010359e:	50                   	push   %eax
8010359f:	e8 ac 0b 00 00       	call   80104150 <wakeup>
801035a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035ad:	85 d2                	test   %edx,%edx
801035af:	75 0a                	jne    801035bb <pipeclose+0x4b>
801035b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035b7:	85 c0                	test   %eax,%eax
801035b9:	74 15                	je     801035d0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c1:	5b                   	pop    %ebx
801035c2:	5e                   	pop    %esi
801035c3:	5d                   	pop    %ebp
    release(&p->lock);
801035c4:	e9 a7 10 00 00       	jmp    80104670 <release>
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	53                   	push   %ebx
801035d4:	e8 97 10 00 00       	call   80104670 <release>
    kfree((char*)p);
801035d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035dc:	83 c4 10             	add    $0x10,%esp
}
801035df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e2:	5b                   	pop    %ebx
801035e3:	5e                   	pop    %esi
801035e4:	5d                   	pop    %ebp
    kfree((char*)p);
801035e5:	e9 06 ef ff ff       	jmp    801024f0 <kfree>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103600:	00 00 00 
    wakeup(&p->nwrite);
80103603:	50                   	push   %eax
80103604:	e8 47 0b 00 00       	call   80104150 <wakeup>
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	eb 99                	jmp    801035a7 <pipeclose+0x37>
8010360e:	66 90                	xchg   %ax,%ax

80103610 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 28             	sub    $0x28,%esp
80103619:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010361c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010361f:	53                   	push   %ebx
80103620:	e8 ab 10 00 00       	call   801046d0 <acquire>
  for(i = 0; i < n; i++){
80103625:	83 c4 10             	add    $0x10,%esp
80103628:	85 ff                	test   %edi,%edi
8010362a:	0f 8e ce 00 00 00    	jle    801036fe <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103630:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103636:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103639:	89 7d 10             	mov    %edi,0x10(%ebp)
8010363c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010363f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103642:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103645:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010364b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103651:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103657:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010365d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103660:	0f 85 b6 00 00 00    	jne    8010371c <pipewrite+0x10c>
80103666:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103669:	eb 3b                	jmp    801036a6 <pipewrite+0x96>
8010366b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103670:	e8 5b 03 00 00       	call   801039d0 <myproc>
80103675:	8b 48 24             	mov    0x24(%eax),%ecx
80103678:	85 c9                	test   %ecx,%ecx
8010367a:	75 34                	jne    801036b0 <pipewrite+0xa0>
      wakeup(&p->nread);
8010367c:	83 ec 0c             	sub    $0xc,%esp
8010367f:	56                   	push   %esi
80103680:	e8 cb 0a 00 00       	call   80104150 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103685:	58                   	pop    %eax
80103686:	5a                   	pop    %edx
80103687:	53                   	push   %ebx
80103688:	57                   	push   %edi
80103689:	e8 02 0a 00 00       	call   80104090 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010368e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103694:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	05 00 02 00 00       	add    $0x200,%eax
801036a2:	39 c2                	cmp    %eax,%edx
801036a4:	75 2a                	jne    801036d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036a6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036ac:	85 c0                	test   %eax,%eax
801036ae:	75 c0                	jne    80103670 <pipewrite+0x60>
        release(&p->lock);
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	53                   	push   %ebx
801036b4:	e8 b7 0f 00 00       	call   80104670 <release>
        return -1;
801036b9:	83 c4 10             	add    $0x10,%esp
801036bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036c4:	5b                   	pop    %ebx
801036c5:	5e                   	pop    %esi
801036c6:	5f                   	pop    %edi
801036c7:	5d                   	pop    %ebp
801036c8:	c3                   	ret
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036d3:	8d 42 01             	lea    0x1(%edx),%eax
801036d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801036dc:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036df:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036e8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801036ec:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801036f3:	39 c1                	cmp    %eax,%ecx
801036f5:	0f 85 50 ff ff ff    	jne    8010364b <pipewrite+0x3b>
801036fb:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036fe:	83 ec 0c             	sub    $0xc,%esp
80103701:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103707:	50                   	push   %eax
80103708:	e8 43 0a 00 00       	call   80104150 <wakeup>
  release(&p->lock);
8010370d:	89 1c 24             	mov    %ebx,(%esp)
80103710:	e8 5b 0f 00 00       	call   80104670 <release>
  return n;
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	89 f8                	mov    %edi,%eax
8010371a:	eb a5                	jmp    801036c1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010371c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010371f:	eb b2                	jmp    801036d3 <pipewrite+0xc3>
80103721:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103728:	00 
80103729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103730 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 18             	sub    $0x18,%esp
80103739:	8b 75 08             	mov    0x8(%ebp),%esi
8010373c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010373f:	56                   	push   %esi
80103740:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103746:	e8 85 0f 00 00       	call   801046d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010374b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103751:	83 c4 10             	add    $0x10,%esp
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	74 2f                	je     8010378b <piperead+0x5b>
8010375c:	eb 37                	jmp    80103795 <piperead+0x65>
8010375e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103760:	e8 6b 02 00 00       	call   801039d0 <myproc>
80103765:	8b 40 24             	mov    0x24(%eax),%eax
80103768:	85 c0                	test   %eax,%eax
8010376a:	0f 85 80 00 00 00    	jne    801037f0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	56                   	push   %esi
80103774:	53                   	push   %ebx
80103775:	e8 16 09 00 00       	call   80104090 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010377a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103780:	83 c4 10             	add    $0x10,%esp
80103783:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103789:	75 0a                	jne    80103795 <piperead+0x65>
8010378b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103791:	85 d2                	test   %edx,%edx
80103793:	75 cb                	jne    80103760 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103795:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103798:	31 db                	xor    %ebx,%ebx
8010379a:	85 c9                	test   %ecx,%ecx
8010379c:	7f 26                	jg     801037c4 <piperead+0x94>
8010379e:	eb 2c                	jmp    801037cc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037a0:	8d 48 01             	lea    0x1(%eax),%ecx
801037a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b6:	83 c3 01             	add    $0x1,%ebx
801037b9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037bc:	74 0e                	je     801037cc <piperead+0x9c>
801037be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
801037c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ca:	75 d4                	jne    801037a0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037cc:	83 ec 0c             	sub    $0xc,%esp
801037cf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037d5:	50                   	push   %eax
801037d6:	e8 75 09 00 00       	call   80104150 <wakeup>
  release(&p->lock);
801037db:	89 34 24             	mov    %esi,(%esp)
801037de:	e8 8d 0e 00 00       	call   80104670 <release>
  return i;
801037e3:	83 c4 10             	add    $0x10,%esp
}
801037e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e9:	89 d8                	mov    %ebx,%eax
801037eb:	5b                   	pop    %ebx
801037ec:	5e                   	pop    %esi
801037ed:	5f                   	pop    %edi
801037ee:	5d                   	pop    %ebp
801037ef:	c3                   	ret
      release(&p->lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037f8:	56                   	push   %esi
801037f9:	e8 72 0e 00 00       	call   80104670 <release>
      return -1;
801037fe:	83 c4 10             	add    $0x10,%esp
}
80103801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103804:	89 d8                	mov    %ebx,%eax
80103806:	5b                   	pop    %ebx
80103807:	5e                   	pop    %esi
80103808:	5f                   	pop    %edi
80103809:	5d                   	pop    %ebp
8010380a:	c3                   	ret
8010380b:	66 90                	xchg   %ax,%ax
8010380d:	66 90                	xchg   %ax,%ax
8010380f:	90                   	nop

80103810 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103814:	bb 34 1b 11 80       	mov    $0x80111b34,%ebx
{
80103819:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010381c:	68 00 1b 11 80       	push   $0x80111b00
80103821:	e8 aa 0e 00 00       	call   801046d0 <acquire>
80103826:	83 c4 10             	add    $0x10,%esp
80103829:	eb 10                	jmp    8010383b <allocproc+0x2b>
8010382b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103830:	83 c3 7c             	add    $0x7c,%ebx
80103833:	81 fb 34 3a 11 80    	cmp    $0x80113a34,%ebx
80103839:	74 75                	je     801038b0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010383b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010383e:	85 c0                	test   %eax,%eax
80103840:	75 ee                	jne    80103830 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103842:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103847:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010384a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103851:	89 43 10             	mov    %eax,0x10(%ebx)
80103854:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103857:	68 00 1b 11 80       	push   $0x80111b00
  p->pid = nextpid++;
8010385c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103862:	e8 09 0e 00 00       	call   80104670 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103867:	e8 44 ee ff ff       	call   801026b0 <kalloc>
8010386c:	83 c4 10             	add    $0x10,%esp
8010386f:	89 43 08             	mov    %eax,0x8(%ebx)
80103872:	85 c0                	test   %eax,%eax
80103874:	74 53                	je     801038c9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103876:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010387c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010387f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103884:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103887:	c7 40 14 1d 5b 10 80 	movl   $0x80105b1d,0x14(%eax)
  p->context = (struct context*)sp;
8010388e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103891:	6a 14                	push   $0x14
80103893:	6a 00                	push   $0x0
80103895:	50                   	push   %eax
80103896:	e8 15 10 00 00       	call   801048b0 <memset>
  p->context->eip = (uint)forkret;
8010389b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010389e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038a1:	c7 40 10 e0 38 10 80 	movl   $0x801038e0,0x10(%eax)
}
801038a8:	89 d8                	mov    %ebx,%eax
801038aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ad:	c9                   	leave
801038ae:	c3                   	ret
801038af:	90                   	nop
  release(&ptable.lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038b5:	68 00 1b 11 80       	push   $0x80111b00
801038ba:	e8 b1 0d 00 00       	call   80104670 <release>
  return 0;
801038bf:	83 c4 10             	add    $0x10,%esp
}
801038c2:	89 d8                	mov    %ebx,%eax
801038c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c7:	c9                   	leave
801038c8:	c3                   	ret
    p->state = UNUSED;
801038c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801038d0:	31 db                	xor    %ebx,%ebx
801038d2:	eb ee                	jmp    801038c2 <allocproc+0xb2>
801038d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038db:	00 
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038e6:	68 00 1b 11 80       	push   $0x80111b00
801038eb:	e8 80 0d 00 00       	call   80104670 <release>

  if (first) {
801038f0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	85 c0                	test   %eax,%eax
801038fa:	75 04                	jne    80103900 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038fc:	c9                   	leave
801038fd:	c3                   	ret
801038fe:	66 90                	xchg   %ax,%ax
    first = 0;
80103900:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103907:	00 00 00 
    iinit(ROOTDEV);
8010390a:	83 ec 0c             	sub    $0xc,%esp
8010390d:	6a 01                	push   $0x1
8010390f:	e8 bc dc ff ff       	call   801015d0 <iinit>
    initlog(ROOTDEV);
80103914:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010391b:	e8 d0 f3 ff ff       	call   80102cf0 <initlog>
}
80103920:	83 c4 10             	add    $0x10,%esp
80103923:	c9                   	leave
80103924:	c3                   	ret
80103925:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010392c:	00 
8010392d:	8d 76 00             	lea    0x0(%esi),%esi

80103930 <pinit>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103936:	68 9f 76 10 80       	push   $0x8010769f
8010393b:	68 00 1b 11 80       	push   $0x80111b00
80103940:	e8 9b 0b 00 00       	call   801044e0 <initlock>
}
80103945:	83 c4 10             	add    $0x10,%esp
80103948:	c9                   	leave
80103949:	c3                   	ret
8010394a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103950 <mycpu>:
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	56                   	push   %esi
80103954:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103955:	9c                   	pushf
80103956:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103957:	f6 c4 02             	test   $0x2,%ah
8010395a:	75 46                	jne    801039a2 <mycpu+0x52>
  apicid = lapicid();
8010395c:	e8 bf ef ff ff       	call   80102920 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103961:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103967:	85 f6                	test   %esi,%esi
80103969:	7e 2a                	jle    80103995 <mycpu+0x45>
8010396b:	31 d2                	xor    %edx,%edx
8010396d:	eb 08                	jmp    80103977 <mycpu+0x27>
8010396f:	90                   	nop
80103970:	83 c2 01             	add    $0x1,%edx
80103973:	39 f2                	cmp    %esi,%edx
80103975:	74 1e                	je     80103995 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103977:	69 ca b4 00 00 00    	imul   $0xb4,%edx,%ecx
8010397d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103984:	39 c3                	cmp    %eax,%ebx
80103986:	75 e8                	jne    80103970 <mycpu+0x20>
}
80103988:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010398b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103991:	5b                   	pop    %ebx
80103992:	5e                   	pop    %esi
80103993:	5d                   	pop    %ebp
80103994:	c3                   	ret
  panic("unknown apicid\n");
80103995:	83 ec 0c             	sub    $0xc,%esp
80103998:	68 a6 76 10 80       	push   $0x801076a6
8010399d:	e8 de c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039a2:	83 ec 0c             	sub    $0xc,%esp
801039a5:	68 20 7a 10 80       	push   $0x80107a20
801039aa:	e8 d1 c9 ff ff       	call   80100380 <panic>
801039af:	90                   	nop

801039b0 <cpuid>:
cpuid() {
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039b6:	e8 95 ff ff ff       	call   80103950 <mycpu>
}
801039bb:	c9                   	leave
  return mycpu()-cpus;
801039bc:	2d a0 17 11 80       	sub    $0x801117a0,%eax
801039c1:	c1 f8 02             	sar    $0x2,%eax
801039c4:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
801039ca:	c3                   	ret
801039cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039d0 <myproc>:
myproc(void) {
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
801039d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039d7:	e8 a4 0b 00 00       	call   80104580 <pushcli>
  c = mycpu();
801039dc:	e8 6f ff ff ff       	call   80103950 <mycpu>
  p = c->proc;
801039e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039e7:	e8 e4 0b 00 00       	call   801045d0 <popcli>
}
801039ec:	89 d8                	mov    %ebx,%eax
801039ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039f1:	c9                   	leave
801039f2:	c3                   	ret
801039f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039fa:	00 
801039fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a00 <userinit>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	53                   	push   %ebx
80103a04:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a07:	e8 04 fe ff ff       	call   80103810 <allocproc>
80103a0c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a0e:	a3 34 3a 11 80       	mov    %eax,0x80113a34
  if((p->pgdir = setupkvm()) == 0)
80103a13:	e8 d8 36 00 00       	call   801070f0 <setupkvm>
80103a18:	89 43 04             	mov    %eax,0x4(%ebx)
80103a1b:	85 c0                	test   %eax,%eax
80103a1d:	0f 84 bd 00 00 00    	je     80103ae0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a23:	83 ec 04             	sub    $0x4,%esp
80103a26:	68 2c 00 00 00       	push   $0x2c
80103a2b:	68 60 a4 10 80       	push   $0x8010a460
80103a30:	50                   	push   %eax
80103a31:	e8 9a 33 00 00       	call   80106dd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a36:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a39:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a3f:	6a 4c                	push   $0x4c
80103a41:	6a 00                	push   $0x0
80103a43:	ff 73 18             	push   0x18(%ebx)
80103a46:	e8 65 0e 00 00       	call   801048b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a4b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a53:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a56:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a5b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a62:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a66:	8b 43 18             	mov    0x18(%ebx),%eax
80103a69:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a6d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a71:	8b 43 18             	mov    0x18(%ebx),%eax
80103a74:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a78:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a7c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a7f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a86:	8b 43 18             	mov    0x18(%ebx),%eax
80103a89:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a90:	8b 43 18             	mov    0x18(%ebx),%eax
80103a93:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a9a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a9d:	6a 10                	push   $0x10
80103a9f:	68 cf 76 10 80       	push   $0x801076cf
80103aa4:	50                   	push   %eax
80103aa5:	e8 b6 0f 00 00       	call   80104a60 <safestrcpy>
  p->cwd = namei("/");
80103aaa:	c7 04 24 d8 76 10 80 	movl   $0x801076d8,(%esp)
80103ab1:	e8 1a e6 ff ff       	call   801020d0 <namei>
80103ab6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ab9:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80103ac0:	e8 0b 0c 00 00       	call   801046d0 <acquire>
  p->state = RUNNABLE;
80103ac5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103acc:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80103ad3:	e8 98 0b 00 00       	call   80104670 <release>
}
80103ad8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103adb:	83 c4 10             	add    $0x10,%esp
80103ade:	c9                   	leave
80103adf:	c3                   	ret
    panic("userinit: out of memory?");
80103ae0:	83 ec 0c             	sub    $0xc,%esp
80103ae3:	68 b6 76 10 80       	push   $0x801076b6
80103ae8:	e8 93 c8 ff ff       	call   80100380 <panic>
80103aed:	8d 76 00             	lea    0x0(%esi),%esi

80103af0 <growproc>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
80103af4:	53                   	push   %ebx
80103af5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103af8:	e8 83 0a 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103afd:	e8 4e fe ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103b02:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b08:	e8 c3 0a 00 00       	call   801045d0 <popcli>
  sz = curproc->sz;
80103b0d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b0f:	85 f6                	test   %esi,%esi
80103b11:	7f 1d                	jg     80103b30 <growproc+0x40>
  } else if(n < 0){
80103b13:	75 3b                	jne    80103b50 <growproc+0x60>
  switchuvm(curproc);
80103b15:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b18:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b1a:	53                   	push   %ebx
80103b1b:	e8 a0 31 00 00       	call   80106cc0 <switchuvm>
  return 0;
80103b20:	83 c4 10             	add    $0x10,%esp
80103b23:	31 c0                	xor    %eax,%eax
}
80103b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b28:	5b                   	pop    %ebx
80103b29:	5e                   	pop    %esi
80103b2a:	5d                   	pop    %ebp
80103b2b:	c3                   	ret
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 c6                	add    %eax,%esi
80103b35:	56                   	push   %esi
80103b36:	50                   	push   %eax
80103b37:	ff 73 04             	push   0x4(%ebx)
80103b3a:	e8 e1 33 00 00       	call   80106f20 <allocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 cf                	jne    80103b15 <growproc+0x25>
      return -1;
80103b46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b4b:	eb d8                	jmp    80103b25 <growproc+0x35>
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b50:	83 ec 04             	sub    $0x4,%esp
80103b53:	01 c6                	add    %eax,%esi
80103b55:	56                   	push   %esi
80103b56:	50                   	push   %eax
80103b57:	ff 73 04             	push   0x4(%ebx)
80103b5a:	e8 e1 34 00 00       	call   80107040 <deallocuvm>
80103b5f:	83 c4 10             	add    $0x10,%esp
80103b62:	85 c0                	test   %eax,%eax
80103b64:	75 af                	jne    80103b15 <growproc+0x25>
80103b66:	eb de                	jmp    80103b46 <growproc+0x56>
80103b68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b6f:	00 

80103b70 <fork>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b79:	e8 02 0a 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103b7e:	e8 cd fd ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103b83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b89:	e8 42 0a 00 00       	call   801045d0 <popcli>
  if((np = allocproc()) == 0){
80103b8e:	e8 7d fc ff ff       	call   80103810 <allocproc>
80103b93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b96:	85 c0                	test   %eax,%eax
80103b98:	0f 84 d6 00 00 00    	je     80103c74 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b9e:	83 ec 08             	sub    $0x8,%esp
80103ba1:	ff 33                	push   (%ebx)
80103ba3:	89 c7                	mov    %eax,%edi
80103ba5:	ff 73 04             	push   0x4(%ebx)
80103ba8:	e8 33 36 00 00       	call   801071e0 <copyuvm>
80103bad:	83 c4 10             	add    $0x10,%esp
80103bb0:	89 47 04             	mov    %eax,0x4(%edi)
80103bb3:	85 c0                	test   %eax,%eax
80103bb5:	0f 84 9a 00 00 00    	je     80103c55 <fork+0xe5>
  np->sz = curproc->sz;
80103bbb:	8b 03                	mov    (%ebx),%eax
80103bbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bc0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103bc2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103bc5:	89 c8                	mov    %ecx,%eax
80103bc7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bca:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bcf:	8b 73 18             	mov    0x18(%ebx),%esi
80103bd2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bd4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bd6:	8b 40 18             	mov    0x18(%eax),%eax
80103bd9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103be0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 13                	je     80103bfb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	50                   	push   %eax
80103bec:	e8 1f d3 ff ff       	call   80100f10 <filedup>
80103bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bf4:	83 c4 10             	add    $0x10,%esp
80103bf7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bfb:	83 c6 01             	add    $0x1,%esi
80103bfe:	83 fe 10             	cmp    $0x10,%esi
80103c01:	75 dd                	jne    80103be0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c03:	83 ec 0c             	sub    $0xc,%esp
80103c06:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c09:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c0c:	e8 af db ff ff       	call   801017c0 <idup>
80103c11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c17:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	53                   	push   %ebx
80103c20:	50                   	push   %eax
80103c21:	e8 3a 0e 00 00       	call   80104a60 <safestrcpy>
  pid = np->pid;
80103c26:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c29:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80103c30:	e8 9b 0a 00 00       	call   801046d0 <acquire>
  np->state = RUNNABLE;
80103c35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c3c:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80103c43:	e8 28 0a 00 00       	call   80104670 <release>
  return pid;
80103c48:	83 c4 10             	add    $0x10,%esp
}
80103c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c4e:	89 d8                	mov    %ebx,%eax
80103c50:	5b                   	pop    %ebx
80103c51:	5e                   	pop    %esi
80103c52:	5f                   	pop    %edi
80103c53:	5d                   	pop    %ebp
80103c54:	c3                   	ret
    kfree(np->kstack);
80103c55:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c58:	83 ec 0c             	sub    $0xc,%esp
80103c5b:	ff 73 08             	push   0x8(%ebx)
80103c5e:	e8 8d e8 ff ff       	call   801024f0 <kfree>
    np->kstack = 0;
80103c63:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c6a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c6d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c74:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c79:	eb d0                	jmp    80103c4b <fork+0xdb>
80103c7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103c80 <scheduler>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c89:	e8 c2 fc ff ff       	call   80103950 <mycpu>
  c->proc = 0;
80103c8e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c95:	00 00 00 
  struct cpu *c = mycpu();
80103c98:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c9a:	8d 78 04             	lea    0x4(%eax),%edi
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ca0:	fb                   	sti
    acquire(&ptable.lock);
80103ca1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca4:	bb 34 1b 11 80       	mov    $0x80111b34,%ebx
    acquire(&ptable.lock);
80103ca9:	68 00 1b 11 80       	push   $0x80111b00
80103cae:	e8 1d 0a 00 00       	call   801046d0 <acquire>
80103cb3:	83 c4 10             	add    $0x10,%esp
80103cb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cbd:	00 
80103cbe:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103cc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103cc4:	75 33                	jne    80103cf9 <scheduler+0x79>
      switchuvm(p);
80103cc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103cc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ccf:	53                   	push   %ebx
80103cd0:	e8 eb 2f 00 00       	call   80106cc0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103cd5:	58                   	pop    %eax
80103cd6:	5a                   	pop    %edx
80103cd7:	ff 73 1c             	push   0x1c(%ebx)
80103cda:	57                   	push   %edi
      p->state = RUNNING;
80103cdb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ce2:	e8 d4 0d 00 00       	call   80104abb <swtch>
      switchkvm();
80103ce7:	e8 c4 2f 00 00       	call   80106cb0 <switchkvm>
      c->proc = 0;
80103cec:	83 c4 10             	add    $0x10,%esp
80103cef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cf6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf9:	83 c3 7c             	add    $0x7c,%ebx
80103cfc:	81 fb 34 3a 11 80    	cmp    $0x80113a34,%ebx
80103d02:	75 bc                	jne    80103cc0 <scheduler+0x40>
    release(&ptable.lock);
80103d04:	83 ec 0c             	sub    $0xc,%esp
80103d07:	68 00 1b 11 80       	push   $0x80111b00
80103d0c:	e8 5f 09 00 00       	call   80104670 <release>
    sti();
80103d11:	83 c4 10             	add    $0x10,%esp
80103d14:	eb 8a                	jmp    80103ca0 <scheduler+0x20>
80103d16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d1d:	00 
80103d1e:	66 90                	xchg   %ax,%ax

80103d20 <sched>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	56                   	push   %esi
80103d24:	53                   	push   %ebx
  pushcli();
80103d25:	e8 56 08 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103d2a:	e8 21 fc ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103d2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d35:	e8 96 08 00 00       	call   801045d0 <popcli>
  if(!holding(&ptable.lock))
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 00 1b 11 80       	push   $0x80111b00
80103d42:	e8 e9 08 00 00       	call   80104630 <holding>
80103d47:	83 c4 10             	add    $0x10,%esp
80103d4a:	85 c0                	test   %eax,%eax
80103d4c:	74 4f                	je     80103d9d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d4e:	e8 fd fb ff ff       	call   80103950 <mycpu>
80103d53:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d5a:	75 68                	jne    80103dc4 <sched+0xa4>
  if(p->state == RUNNING)
80103d5c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d60:	74 55                	je     80103db7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d62:	9c                   	pushf
80103d63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d64:	f6 c4 02             	test   $0x2,%ah
80103d67:	75 41                	jne    80103daa <sched+0x8a>
  intena = mycpu()->intena;
80103d69:	e8 e2 fb ff ff       	call   80103950 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d6e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d71:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d77:	e8 d4 fb ff ff       	call   80103950 <mycpu>
80103d7c:	83 ec 08             	sub    $0x8,%esp
80103d7f:	ff 70 04             	push   0x4(%eax)
80103d82:	53                   	push   %ebx
80103d83:	e8 33 0d 00 00       	call   80104abb <swtch>
  mycpu()->intena = intena;
80103d88:	e8 c3 fb ff ff       	call   80103950 <mycpu>
}
80103d8d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d90:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d99:	5b                   	pop    %ebx
80103d9a:	5e                   	pop    %esi
80103d9b:	5d                   	pop    %ebp
80103d9c:	c3                   	ret
    panic("sched ptable.lock");
80103d9d:	83 ec 0c             	sub    $0xc,%esp
80103da0:	68 da 76 10 80       	push   $0x801076da
80103da5:	e8 d6 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 06 77 10 80       	push   $0x80107706
80103db2:	e8 c9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103db7:	83 ec 0c             	sub    $0xc,%esp
80103dba:	68 f8 76 10 80       	push   $0x801076f8
80103dbf:	e8 bc c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103dc4:	83 ec 0c             	sub    $0xc,%esp
80103dc7:	68 ec 76 10 80       	push   $0x801076ec
80103dcc:	e8 af c5 ff ff       	call   80100380 <panic>
80103dd1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dd8:	00 
80103dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103de0 <exit>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103de9:	e8 e2 fb ff ff       	call   801039d0 <myproc>
  if(curproc == initproc)
80103dee:	39 05 34 3a 11 80    	cmp    %eax,0x80113a34
80103df4:	0f 84 fd 00 00 00    	je     80103ef7 <exit+0x117>
80103dfa:	89 c3                	mov    %eax,%ebx
80103dfc:	8d 70 28             	lea    0x28(%eax),%esi
80103dff:	8d 78 68             	lea    0x68(%eax),%edi
80103e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e08:	8b 06                	mov    (%esi),%eax
80103e0a:	85 c0                	test   %eax,%eax
80103e0c:	74 12                	je     80103e20 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e0e:	83 ec 0c             	sub    $0xc,%esp
80103e11:	50                   	push   %eax
80103e12:	e8 49 d1 ff ff       	call   80100f60 <fileclose>
      curproc->ofile[fd] = 0;
80103e17:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e1d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e20:	83 c6 04             	add    $0x4,%esi
80103e23:	39 f7                	cmp    %esi,%edi
80103e25:	75 e1                	jne    80103e08 <exit+0x28>
  begin_op();
80103e27:	e8 64 ef ff ff       	call   80102d90 <begin_op>
  iput(curproc->cwd);
80103e2c:	83 ec 0c             	sub    $0xc,%esp
80103e2f:	ff 73 68             	push   0x68(%ebx)
80103e32:	e8 e9 da ff ff       	call   80101920 <iput>
  end_op();
80103e37:	e8 c4 ef ff ff       	call   80102e00 <end_op>
  curproc->cwd = 0;
80103e3c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e43:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80103e4a:	e8 81 08 00 00       	call   801046d0 <acquire>
  wakeup1(curproc->parent);
80103e4f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e52:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e55:	b8 34 1b 11 80       	mov    $0x80111b34,%eax
80103e5a:	eb 0e                	jmp    80103e6a <exit+0x8a>
80103e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e60:	83 c0 7c             	add    $0x7c,%eax
80103e63:	3d 34 3a 11 80       	cmp    $0x80113a34,%eax
80103e68:	74 1c                	je     80103e86 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e6e:	75 f0                	jne    80103e60 <exit+0x80>
80103e70:	3b 50 20             	cmp    0x20(%eax),%edx
80103e73:	75 eb                	jne    80103e60 <exit+0x80>
      p->state = RUNNABLE;
80103e75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e7c:	83 c0 7c             	add    $0x7c,%eax
80103e7f:	3d 34 3a 11 80       	cmp    $0x80113a34,%eax
80103e84:	75 e4                	jne    80103e6a <exit+0x8a>
      p->parent = initproc;
80103e86:	8b 0d 34 3a 11 80    	mov    0x80113a34,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8c:	ba 34 1b 11 80       	mov    $0x80111b34,%edx
80103e91:	eb 10                	jmp    80103ea3 <exit+0xc3>
80103e93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e98:	83 c2 7c             	add    $0x7c,%edx
80103e9b:	81 fa 34 3a 11 80    	cmp    $0x80113a34,%edx
80103ea1:	74 3b                	je     80103ede <exit+0xfe>
    if(p->parent == curproc){
80103ea3:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103ea6:	75 f0                	jne    80103e98 <exit+0xb8>
      if(p->state == ZOMBIE)
80103ea8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103eac:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103eaf:	75 e7                	jne    80103e98 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eb1:	b8 34 1b 11 80       	mov    $0x80111b34,%eax
80103eb6:	eb 12                	jmp    80103eca <exit+0xea>
80103eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ebf:	00 
80103ec0:	83 c0 7c             	add    $0x7c,%eax
80103ec3:	3d 34 3a 11 80       	cmp    $0x80113a34,%eax
80103ec8:	74 ce                	je     80103e98 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103eca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ece:	75 f0                	jne    80103ec0 <exit+0xe0>
80103ed0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ed3:	75 eb                	jne    80103ec0 <exit+0xe0>
      p->state = RUNNABLE;
80103ed5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103edc:	eb e2                	jmp    80103ec0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103ede:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ee5:	e8 36 fe ff ff       	call   80103d20 <sched>
  panic("zombie exit");
80103eea:	83 ec 0c             	sub    $0xc,%esp
80103eed:	68 27 77 10 80       	push   $0x80107727
80103ef2:	e8 89 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ef7:	83 ec 0c             	sub    $0xc,%esp
80103efa:	68 1a 77 10 80       	push   $0x8010771a
80103eff:	e8 7c c4 ff ff       	call   80100380 <panic>
80103f04:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f0b:	00 
80103f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f10 <wait>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
  pushcli();
80103f15:	e8 66 06 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103f1a:	e8 31 fa ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103f1f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f25:	e8 a6 06 00 00       	call   801045d0 <popcli>
  acquire(&ptable.lock);
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 00 1b 11 80       	push   $0x80111b00
80103f32:	e8 99 07 00 00       	call   801046d0 <acquire>
80103f37:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f3a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f3c:	bb 34 1b 11 80       	mov    $0x80111b34,%ebx
80103f41:	eb 10                	jmp    80103f53 <wait+0x43>
80103f43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f48:	83 c3 7c             	add    $0x7c,%ebx
80103f4b:	81 fb 34 3a 11 80    	cmp    $0x80113a34,%ebx
80103f51:	74 1b                	je     80103f6e <wait+0x5e>
      if(p->parent != curproc)
80103f53:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f56:	75 f0                	jne    80103f48 <wait+0x38>
      if(p->state == ZOMBIE){
80103f58:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f5c:	74 62                	je     80103fc0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f61:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f66:	81 fb 34 3a 11 80    	cmp    $0x80113a34,%ebx
80103f6c:	75 e5                	jne    80103f53 <wait+0x43>
    if(!havekids || curproc->killed){
80103f6e:	85 c0                	test   %eax,%eax
80103f70:	0f 84 a0 00 00 00    	je     80104016 <wait+0x106>
80103f76:	8b 46 24             	mov    0x24(%esi),%eax
80103f79:	85 c0                	test   %eax,%eax
80103f7b:	0f 85 95 00 00 00    	jne    80104016 <wait+0x106>
  pushcli();
80103f81:	e8 fa 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103f86:	e8 c5 f9 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103f8b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f91:	e8 3a 06 00 00       	call   801045d0 <popcli>
  if(p == 0)
80103f96:	85 db                	test   %ebx,%ebx
80103f98:	0f 84 8f 00 00 00    	je     8010402d <wait+0x11d>
  p->chan = chan;
80103f9e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103fa1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fa8:	e8 73 fd ff ff       	call   80103d20 <sched>
  p->chan = 0;
80103fad:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fb4:	eb 84                	jmp    80103f3a <wait+0x2a>
80103fb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fbd:	00 
80103fbe:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80103fc0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103fc3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fc6:	ff 73 08             	push   0x8(%ebx)
80103fc9:	e8 22 e5 ff ff       	call   801024f0 <kfree>
        p->kstack = 0;
80103fce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fd5:	5a                   	pop    %edx
80103fd6:	ff 73 04             	push   0x4(%ebx)
80103fd9:	e8 92 30 00 00       	call   80107070 <freevm>
        p->pid = 0;
80103fde:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fe5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fec:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ff0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ff7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103ffe:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80104005:	e8 66 06 00 00       	call   80104670 <release>
        return pid;
8010400a:	83 c4 10             	add    $0x10,%esp
}
8010400d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104010:	89 f0                	mov    %esi,%eax
80104012:	5b                   	pop    %ebx
80104013:	5e                   	pop    %esi
80104014:	5d                   	pop    %ebp
80104015:	c3                   	ret
      release(&ptable.lock);
80104016:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104019:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010401e:	68 00 1b 11 80       	push   $0x80111b00
80104023:	e8 48 06 00 00       	call   80104670 <release>
      return -1;
80104028:	83 c4 10             	add    $0x10,%esp
8010402b:	eb e0                	jmp    8010400d <wait+0xfd>
    panic("sleep");
8010402d:	83 ec 0c             	sub    $0xc,%esp
80104030:	68 33 77 10 80       	push   $0x80107733
80104035:	e8 46 c3 ff ff       	call   80100380 <panic>
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104040 <yield>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104047:	68 00 1b 11 80       	push   $0x80111b00
8010404c:	e8 7f 06 00 00       	call   801046d0 <acquire>
  pushcli();
80104051:	e8 2a 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104056:	e8 f5 f8 ff ff       	call   80103950 <mycpu>
  p = c->proc;
8010405b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104061:	e8 6a 05 00 00       	call   801045d0 <popcli>
  myproc()->state = RUNNABLE;
80104066:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010406d:	e8 ae fc ff ff       	call   80103d20 <sched>
  release(&ptable.lock);
80104072:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
80104079:	e8 f2 05 00 00       	call   80104670 <release>
}
8010407e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104081:	83 c4 10             	add    $0x10,%esp
80104084:	c9                   	leave
80104085:	c3                   	ret
80104086:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010408d:	00 
8010408e:	66 90                	xchg   %ax,%ax

80104090 <sleep>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 0c             	sub    $0xc,%esp
80104099:	8b 7d 08             	mov    0x8(%ebp),%edi
8010409c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010409f:	e8 dc 04 00 00       	call   80104580 <pushcli>
  c = mycpu();
801040a4:	e8 a7 f8 ff ff       	call   80103950 <mycpu>
  p = c->proc;
801040a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040af:	e8 1c 05 00 00       	call   801045d0 <popcli>
  if(p == 0)
801040b4:	85 db                	test   %ebx,%ebx
801040b6:	0f 84 87 00 00 00    	je     80104143 <sleep+0xb3>
  if(lk == 0)
801040bc:	85 f6                	test   %esi,%esi
801040be:	74 76                	je     80104136 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040c0:	81 fe 00 1b 11 80    	cmp    $0x80111b00,%esi
801040c6:	74 50                	je     80104118 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	68 00 1b 11 80       	push   $0x80111b00
801040d0:	e8 fb 05 00 00       	call   801046d0 <acquire>
    release(lk);
801040d5:	89 34 24             	mov    %esi,(%esp)
801040d8:	e8 93 05 00 00       	call   80104670 <release>
  p->chan = chan;
801040dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040e7:	e8 34 fc ff ff       	call   80103d20 <sched>
  p->chan = 0;
801040ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040f3:	c7 04 24 00 1b 11 80 	movl   $0x80111b00,(%esp)
801040fa:	e8 71 05 00 00       	call   80104670 <release>
    acquire(lk);
801040ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104102:	83 c4 10             	add    $0x10,%esp
}
80104105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104108:	5b                   	pop    %ebx
80104109:	5e                   	pop    %esi
8010410a:	5f                   	pop    %edi
8010410b:	5d                   	pop    %ebp
    acquire(lk);
8010410c:	e9 bf 05 00 00       	jmp    801046d0 <acquire>
80104111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104118:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010411b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104122:	e8 f9 fb ff ff       	call   80103d20 <sched>
  p->chan = 0;
80104127:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010412e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104131:	5b                   	pop    %ebx
80104132:	5e                   	pop    %esi
80104133:	5f                   	pop    %edi
80104134:	5d                   	pop    %ebp
80104135:	c3                   	ret
    panic("sleep without lk");
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	68 39 77 10 80       	push   $0x80107739
8010413e:	e8 3d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104143:	83 ec 0c             	sub    $0xc,%esp
80104146:	68 33 77 10 80       	push   $0x80107733
8010414b:	e8 30 c2 ff ff       	call   80100380 <panic>

80104150 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
80104157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010415a:	68 00 1b 11 80       	push   $0x80111b00
8010415f:	e8 6c 05 00 00       	call   801046d0 <acquire>
80104164:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104167:	b8 34 1b 11 80       	mov    $0x80111b34,%eax
8010416c:	eb 0c                	jmp    8010417a <wakeup+0x2a>
8010416e:	66 90                	xchg   %ax,%ax
80104170:	83 c0 7c             	add    $0x7c,%eax
80104173:	3d 34 3a 11 80       	cmp    $0x80113a34,%eax
80104178:	74 1c                	je     80104196 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010417a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010417e:	75 f0                	jne    80104170 <wakeup+0x20>
80104180:	3b 58 20             	cmp    0x20(%eax),%ebx
80104183:	75 eb                	jne    80104170 <wakeup+0x20>
      p->state = RUNNABLE;
80104185:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010418c:	83 c0 7c             	add    $0x7c,%eax
8010418f:	3d 34 3a 11 80       	cmp    $0x80113a34,%eax
80104194:	75 e4                	jne    8010417a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104196:	c7 45 08 00 1b 11 80 	movl   $0x80111b00,0x8(%ebp)
}
8010419d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041a0:	c9                   	leave
  release(&ptable.lock);
801041a1:	e9 ca 04 00 00       	jmp    80104670 <release>
801041a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801041ad:	00 
801041ae:	66 90                	xchg   %ax,%ax

801041b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 10             	sub    $0x10,%esp
801041b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ba:	68 00 1b 11 80       	push   $0x80111b00
801041bf:	e8 0c 05 00 00       	call   801046d0 <acquire>
801041c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041c7:	b8 34 1b 11 80       	mov    $0x80111b34,%eax
801041cc:	eb 0c                	jmp    801041da <kill+0x2a>
801041ce:	66 90                	xchg   %ax,%ax
801041d0:	83 c0 7c             	add    $0x7c,%eax
801041d3:	3d 34 3a 11 80       	cmp    $0x80113a34,%eax
801041d8:	74 36                	je     80104210 <kill+0x60>
    if(p->pid == pid){
801041da:	39 58 10             	cmp    %ebx,0x10(%eax)
801041dd:	75 f1                	jne    801041d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041df:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041ea:	75 07                	jne    801041f3 <kill+0x43>
        p->state = RUNNABLE;
801041ec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041f3:	83 ec 0c             	sub    $0xc,%esp
801041f6:	68 00 1b 11 80       	push   $0x80111b00
801041fb:	e8 70 04 00 00       	call   80104670 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104203:	83 c4 10             	add    $0x10,%esp
80104206:	31 c0                	xor    %eax,%eax
}
80104208:	c9                   	leave
80104209:	c3                   	ret
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	68 00 1b 11 80       	push   $0x80111b00
80104218:	e8 53 04 00 00       	call   80104670 <release>
}
8010421d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104220:	83 c4 10             	add    $0x10,%esp
80104223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104228:	c9                   	leave
80104229:	c3                   	ret
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104230 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	57                   	push   %edi
80104234:	56                   	push   %esi
80104235:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104238:	53                   	push   %ebx
80104239:	bb a0 1b 11 80       	mov    $0x80111ba0,%ebx
8010423e:	83 ec 3c             	sub    $0x3c,%esp
80104241:	eb 24                	jmp    80104267 <procdump+0x37>
80104243:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104248:	83 ec 0c             	sub    $0xc,%esp
8010424b:	68 12 79 10 80       	push   $0x80107912
80104250:	e8 5b c4 ff ff       	call   801006b0 <cprintf>
80104255:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104258:	83 c3 7c             	add    $0x7c,%ebx
8010425b:	81 fb a0 3a 11 80    	cmp    $0x80113aa0,%ebx
80104261:	0f 84 81 00 00 00    	je     801042e8 <procdump+0xb8>
    if(p->state == UNUSED)
80104267:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010426a:	85 c0                	test   %eax,%eax
8010426c:	74 ea                	je     80104258 <procdump+0x28>
      state = "???";
8010426e:	ba 4a 77 10 80       	mov    $0x8010774a,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104273:	83 f8 05             	cmp    $0x5,%eax
80104276:	77 11                	ja     80104289 <procdump+0x59>
80104278:	8b 14 85 c0 7d 10 80 	mov    -0x7fef8240(,%eax,4),%edx
      state = "???";
8010427f:	b8 4a 77 10 80       	mov    $0x8010774a,%eax
80104284:	85 d2                	test   %edx,%edx
80104286:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104289:	53                   	push   %ebx
8010428a:	52                   	push   %edx
8010428b:	ff 73 a4             	push   -0x5c(%ebx)
8010428e:	68 4e 77 10 80       	push   $0x8010774e
80104293:	e8 18 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104298:	83 c4 10             	add    $0x10,%esp
8010429b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010429f:	75 a7                	jne    80104248 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042a1:	83 ec 08             	sub    $0x8,%esp
801042a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042a7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042aa:	50                   	push   %eax
801042ab:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042ae:	8b 40 0c             	mov    0xc(%eax),%eax
801042b1:	83 c0 08             	add    $0x8,%eax
801042b4:	50                   	push   %eax
801042b5:	e8 46 02 00 00       	call   80104500 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042ba:	83 c4 10             	add    $0x10,%esp
801042bd:	8d 76 00             	lea    0x0(%esi),%esi
801042c0:	8b 17                	mov    (%edi),%edx
801042c2:	85 d2                	test   %edx,%edx
801042c4:	74 82                	je     80104248 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042c6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042c9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801042cc:	52                   	push   %edx
801042cd:	68 81 74 10 80       	push   $0x80107481
801042d2:	e8 d9 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042d7:	83 c4 10             	add    $0x10,%esp
801042da:	39 f7                	cmp    %esi,%edi
801042dc:	75 e2                	jne    801042c0 <procdump+0x90>
801042de:	e9 65 ff ff ff       	jmp    80104248 <procdump+0x18>
801042e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801042e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042eb:	5b                   	pop    %ebx
801042ec:	5e                   	pop    %esi
801042ed:	5f                   	pop    %edi
801042ee:	5d                   	pop    %ebp
801042ef:	c3                   	ret

801042f0 <rinit>:

void rinit(void){
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	83 ec 10             	sub    $0x10,%esp
  InitReentrantLock(&rlock,"salam");
801042f6:	68 6f 76 10 80       	push   $0x8010766f
801042fb:	68 c0 1a 11 80       	push   $0x80111ac0
80104300:	e8 cb 04 00 00       	call   801047d0 <InitReentrantLock>
}
80104305:	83 c4 10             	add    $0x10,%esp
80104308:	c9                   	leave
80104309:	c3                   	ret
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104310 <test>:

int test(int depth) {
80104310:	55                   	push   %ebp
80104311:	b8 01 00 00 00       	mov    $0x1,%eax
80104316:	89 e5                	mov    %esp,%ebp
80104318:	56                   	push   %esi
80104319:	53                   	push   %ebx
8010431a:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (depth <= 0)
8010431d:	85 db                	test   %ebx,%ebx
8010431f:	7e 75                	jle    80104396 <test+0x86>
        return 1;

    // printf(1, "Thread %d acquiring lock at depth %d\n", getpid(), depth);
    reentrant_acquire(&rlock);
80104321:	83 ec 0c             	sub    $0xc,%esp
80104324:	68 c0 1a 11 80       	push   $0x80111ac0
80104329:	e8 d2 04 00 00       	call   80104800 <reentrant_acquire>
  pushcli();
8010432e:	e8 4d 02 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104333:	e8 18 f6 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80104338:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010433e:	e8 8d 02 00 00       	call   801045d0 <popcli>

    cprintf("Thread %d acquired lock at depth %d\n", myproc()->pid, depth);
80104343:	83 c4 0c             	add    $0xc,%esp
80104346:	53                   	push   %ebx
80104347:	ff 76 10             	push   0x10(%esi)
8010434a:	68 48 7a 10 80       	push   $0x80107a48
8010434f:	e8 5c c3 ff ff       	call   801006b0 <cprintf>
    test(depth - 1);
80104354:	8d 43 ff             	lea    -0x1(%ebx),%eax
80104357:	89 04 24             	mov    %eax,(%esp)
8010435a:	e8 b1 ff ff ff       	call   80104310 <test>
  pushcli();
8010435f:	e8 1c 02 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104364:	e8 e7 f5 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80104369:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010436f:	e8 5c 02 00 00       	call   801045d0 <popcli>

    cprintf("Thread %d releasing lock at depth %d\n", myproc()->pid, depth);
80104374:	83 c4 0c             	add    $0xc,%esp
80104377:	53                   	push   %ebx
80104378:	ff 76 10             	push   0x10(%esi)
8010437b:	68 70 7a 10 80       	push   $0x80107a70
80104380:	e8 2b c3 ff ff       	call   801006b0 <cprintf>
    release_reentrant_lock(&rlock);
80104385:	c7 04 24 c0 1a 11 80 	movl   $0x80111ac0,(%esp)
8010438c:	e8 bf 04 00 00       	call   80104850 <release_reentrant_lock>
    return 0;
80104391:	83 c4 10             	add    $0x10,%esp
80104394:	31 c0                	xor    %eax,%eax
}
80104396:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104399:	5b                   	pop    %ebx
8010439a:	5e                   	pop    %esi
8010439b:	5d                   	pop    %ebp
8010439c:	c3                   	ret
8010439d:	8d 76 00             	lea    0x0(%esi),%esi

801043a0 <nsyscalls>:

int nsyscalls(void) {
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	83 ec 08             	sub    $0x8,%esp
    getnsyscall();
801043a6:	e8 95 09 00 00       	call   80104d40 <getnsyscall>
    return 0;
801043ab:	31 c0                	xor    %eax,%eax
801043ad:	c9                   	leave
801043ae:	c3                   	ret
801043af:	90                   	nop

801043b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 0c             	sub    $0xc,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043ba:	68 81 77 10 80       	push   $0x80107781
801043bf:	8d 43 04             	lea    0x4(%ebx),%eax
801043c2:	50                   	push   %eax
801043c3:	e8 18 01 00 00       	call   801044e0 <initlock>
  lk->name = name;
801043c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043d1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043db:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e1:	c9                   	leave
801043e2:	c3                   	ret
801043e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043ea:	00 
801043eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801043f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
801043f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043f8:	8d 73 04             	lea    0x4(%ebx),%esi
801043fb:	83 ec 0c             	sub    $0xc,%esp
801043fe:	56                   	push   %esi
801043ff:	e8 cc 02 00 00       	call   801046d0 <acquire>
  while (lk->locked) {
80104404:	8b 13                	mov    (%ebx),%edx
80104406:	83 c4 10             	add    $0x10,%esp
80104409:	85 d2                	test   %edx,%edx
8010440b:	74 16                	je     80104423 <acquiresleep+0x33>
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104410:	83 ec 08             	sub    $0x8,%esp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
80104415:	e8 76 fc ff ff       	call   80104090 <sleep>
  while (lk->locked) {
8010441a:	8b 03                	mov    (%ebx),%eax
8010441c:	83 c4 10             	add    $0x10,%esp
8010441f:	85 c0                	test   %eax,%eax
80104421:	75 ed                	jne    80104410 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104423:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104429:	e8 a2 f5 ff ff       	call   801039d0 <myproc>
8010442e:	8b 40 10             	mov    0x10(%eax),%eax
80104431:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104434:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104437:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010443a:	5b                   	pop    %ebx
8010443b:	5e                   	pop    %esi
8010443c:	5d                   	pop    %ebp
  release(&lk->lk);
8010443d:	e9 2e 02 00 00       	jmp    80104670 <release>
80104442:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104449:	00 
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104450 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
80104455:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104458:	8d 73 04             	lea    0x4(%ebx),%esi
8010445b:	83 ec 0c             	sub    $0xc,%esp
8010445e:	56                   	push   %esi
8010445f:	e8 6c 02 00 00       	call   801046d0 <acquire>
  lk->locked = 0;
80104464:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010446a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104471:	89 1c 24             	mov    %ebx,(%esp)
80104474:	e8 d7 fc ff ff       	call   80104150 <wakeup>
  release(&lk->lk);
80104479:	89 75 08             	mov    %esi,0x8(%ebp)
8010447c:	83 c4 10             	add    $0x10,%esp
}
8010447f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104482:	5b                   	pop    %ebx
80104483:	5e                   	pop    %esi
80104484:	5d                   	pop    %ebp
  release(&lk->lk);
80104485:	e9 e6 01 00 00       	jmp    80104670 <release>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	31 ff                	xor    %edi,%edi
80104496:	56                   	push   %esi
80104497:	53                   	push   %ebx
80104498:	83 ec 18             	sub    $0x18,%esp
8010449b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010449e:	8d 73 04             	lea    0x4(%ebx),%esi
801044a1:	56                   	push   %esi
801044a2:	e8 29 02 00 00       	call   801046d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044a7:	8b 03                	mov    (%ebx),%eax
801044a9:	83 c4 10             	add    $0x10,%esp
801044ac:	85 c0                	test   %eax,%eax
801044ae:	75 18                	jne    801044c8 <holdingsleep+0x38>
  release(&lk->lk);
801044b0:	83 ec 0c             	sub    $0xc,%esp
801044b3:	56                   	push   %esi
801044b4:	e8 b7 01 00 00       	call   80104670 <release>
  return r;
}
801044b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044bc:	89 f8                	mov    %edi,%eax
801044be:	5b                   	pop    %ebx
801044bf:	5e                   	pop    %esi
801044c0:	5f                   	pop    %edi
801044c1:	5d                   	pop    %ebp
801044c2:	c3                   	ret
801044c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801044c8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044cb:	e8 00 f5 ff ff       	call   801039d0 <myproc>
801044d0:	39 58 10             	cmp    %ebx,0x10(%eax)
801044d3:	0f 94 c0             	sete   %al
801044d6:	0f b6 c0             	movzbl %al,%eax
801044d9:	89 c7                	mov    %eax,%edi
801044db:	eb d3                	jmp    801044b0 <holdingsleep+0x20>
801044dd:	66 90                	xchg   %ax,%ax
801044df:	90                   	nop

801044e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801044e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801044e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801044ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044f9:	5d                   	pop    %ebp
801044fa:	c3                   	ret
801044fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104500 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	53                   	push   %ebx
80104504:	8b 45 08             	mov    0x8(%ebp),%eax
80104507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010450a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010450d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104512:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104517:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010451c:	76 10                	jbe    8010452e <getcallerpcs+0x2e>
8010451e:	eb 28                	jmp    80104548 <getcallerpcs+0x48>
80104520:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104526:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010452c:	77 1a                	ja     80104548 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010452e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104531:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104534:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104537:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104539:	83 f8 0a             	cmp    $0xa,%eax
8010453c:	75 e2                	jne    80104520 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010453e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104541:	c9                   	leave
80104542:	c3                   	ret
80104543:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104548:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010454b:	83 c1 28             	add    $0x28,%ecx
8010454e:	89 ca                	mov    %ecx,%edx
80104550:	29 c2                	sub    %eax,%edx
80104552:	83 e2 04             	and    $0x4,%edx
80104555:	74 11                	je     80104568 <getcallerpcs+0x68>
    pcs[i] = 0;
80104557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010455d:	83 c0 04             	add    $0x4,%eax
80104560:	39 c1                	cmp    %eax,%ecx
80104562:	74 da                	je     8010453e <getcallerpcs+0x3e>
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104568:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010456e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104571:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104578:	39 c1                	cmp    %eax,%ecx
8010457a:	75 ec                	jne    80104568 <getcallerpcs+0x68>
8010457c:	eb c0                	jmp    8010453e <getcallerpcs+0x3e>
8010457e:	66 90                	xchg   %ax,%ax

80104580 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 04             	sub    $0x4,%esp
80104587:	9c                   	pushf
80104588:	5b                   	pop    %ebx
  asm volatile("cli");
80104589:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010458a:	e8 c1 f3 ff ff       	call   80103950 <mycpu>
8010458f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104595:	85 c0                	test   %eax,%eax
80104597:	74 17                	je     801045b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104599:	e8 b2 f3 ff ff       	call   80103950 <mycpu>
8010459e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a8:	c9                   	leave
801045a9:	c3                   	ret
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801045b0:	e8 9b f3 ff ff       	call   80103950 <mycpu>
801045b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045c1:	eb d6                	jmp    80104599 <pushcli+0x19>
801045c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045ca:	00 
801045cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801045d0 <popcli>:

void
popcli(void)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045d6:	9c                   	pushf
801045d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045d8:	f6 c4 02             	test   $0x2,%ah
801045db:	75 35                	jne    80104612 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045dd:	e8 6e f3 ff ff       	call   80103950 <mycpu>
801045e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045e9:	78 34                	js     8010461f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045eb:	e8 60 f3 ff ff       	call   80103950 <mycpu>
801045f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045f6:	85 d2                	test   %edx,%edx
801045f8:	74 06                	je     80104600 <popcli+0x30>
    sti();
}
801045fa:	c9                   	leave
801045fb:	c3                   	ret
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104600:	e8 4b f3 ff ff       	call   80103950 <mycpu>
80104605:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010460b:	85 c0                	test   %eax,%eax
8010460d:	74 eb                	je     801045fa <popcli+0x2a>
  asm volatile("sti");
8010460f:	fb                   	sti
}
80104610:	c9                   	leave
80104611:	c3                   	ret
    panic("popcli - interruptible");
80104612:	83 ec 0c             	sub    $0xc,%esp
80104615:	68 8c 77 10 80       	push   $0x8010778c
8010461a:	e8 61 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010461f:	83 ec 0c             	sub    $0xc,%esp
80104622:	68 a3 77 10 80       	push   $0x801077a3
80104627:	e8 54 bd ff ff       	call   80100380 <panic>
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <holding>:
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 75 08             	mov    0x8(%ebp),%esi
80104638:	31 db                	xor    %ebx,%ebx
  pushcli();
8010463a:	e8 41 ff ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010463f:	8b 06                	mov    (%esi),%eax
80104641:	85 c0                	test   %eax,%eax
80104643:	75 0b                	jne    80104650 <holding+0x20>
  popcli();
80104645:	e8 86 ff ff ff       	call   801045d0 <popcli>
}
8010464a:	89 d8                	mov    %ebx,%eax
8010464c:	5b                   	pop    %ebx
8010464d:	5e                   	pop    %esi
8010464e:	5d                   	pop    %ebp
8010464f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104650:	8b 5e 08             	mov    0x8(%esi),%ebx
80104653:	e8 f8 f2 ff ff       	call   80103950 <mycpu>
80104658:	39 c3                	cmp    %eax,%ebx
8010465a:	0f 94 c3             	sete   %bl
  popcli();
8010465d:	e8 6e ff ff ff       	call   801045d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104662:	0f b6 db             	movzbl %bl,%ebx
}
80104665:	89 d8                	mov    %ebx,%eax
80104667:	5b                   	pop    %ebx
80104668:	5e                   	pop    %esi
80104669:	5d                   	pop    %ebp
8010466a:	c3                   	ret
8010466b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104670 <release>:
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104678:	e8 03 ff ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010467d:	8b 03                	mov    (%ebx),%eax
8010467f:	85 c0                	test   %eax,%eax
80104681:	75 15                	jne    80104698 <release+0x28>
  popcli();
80104683:	e8 48 ff ff ff       	call   801045d0 <popcli>
    panic("release");
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	68 aa 77 10 80       	push   $0x801077aa
80104690:	e8 eb bc ff ff       	call   80100380 <panic>
80104695:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104698:	8b 73 08             	mov    0x8(%ebx),%esi
8010469b:	e8 b0 f2 ff ff       	call   80103950 <mycpu>
801046a0:	39 c6                	cmp    %eax,%esi
801046a2:	75 df                	jne    80104683 <release+0x13>
  popcli();
801046a4:	e8 27 ff ff ff       	call   801045d0 <popcli>
  lk->pcs[0] = 0;
801046a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c5:	5b                   	pop    %ebx
801046c6:	5e                   	pop    %esi
801046c7:	5d                   	pop    %ebp
  popcli();
801046c8:	e9 03 ff ff ff       	jmp    801045d0 <popcli>
801046cd:	8d 76 00             	lea    0x0(%esi),%esi

801046d0 <acquire>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801046d7:	e8 a4 fe ff ff       	call   80104580 <pushcli>
  if(holding(lk))
801046dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046df:	e8 9c fe ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046e4:	8b 03                	mov    (%ebx),%eax
801046e6:	85 c0                	test   %eax,%eax
801046e8:	0f 85 b2 00 00 00    	jne    801047a0 <acquire+0xd0>
  popcli();
801046ee:	e8 dd fe ff ff       	call   801045d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801046f3:	b9 01 00 00 00       	mov    $0x1,%ecx
801046f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046ff:	00 
  while(xchg(&lk->locked, 1) != 0)
80104700:	8b 55 08             	mov    0x8(%ebp),%edx
80104703:	89 c8                	mov    %ecx,%eax
80104705:	f0 87 02             	lock xchg %eax,(%edx)
80104708:	85 c0                	test   %eax,%eax
8010470a:	75 f4                	jne    80104700 <acquire+0x30>
  __sync_synchronize();
8010470c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104711:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104714:	e8 37 f2 ff ff       	call   80103950 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104719:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010471c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010471e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104721:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104727:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010472c:	77 32                	ja     80104760 <acquire+0x90>
  ebp = (uint*)v - 2;
8010472e:	89 e8                	mov    %ebp,%eax
80104730:	eb 14                	jmp    80104746 <acquire+0x76>
80104732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104738:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010473e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104744:	77 1a                	ja     80104760 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104746:	8b 58 04             	mov    0x4(%eax),%ebx
80104749:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010474d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104750:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104752:	83 fa 0a             	cmp    $0xa,%edx
80104755:	75 e1                	jne    80104738 <acquire+0x68>
}
80104757:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010475a:	c9                   	leave
8010475b:	c3                   	ret
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104760:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104764:	83 c1 34             	add    $0x34,%ecx
80104767:	89 ca                	mov    %ecx,%edx
80104769:	29 c2                	sub    %eax,%edx
8010476b:	83 e2 04             	and    $0x4,%edx
8010476e:	74 10                	je     80104780 <acquire+0xb0>
    pcs[i] = 0;
80104770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104776:	83 c0 04             	add    $0x4,%eax
80104779:	39 c1                	cmp    %eax,%ecx
8010477b:	74 da                	je     80104757 <acquire+0x87>
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104786:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104789:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104790:	39 c1                	cmp    %eax,%ecx
80104792:	75 ec                	jne    80104780 <acquire+0xb0>
80104794:	eb c1                	jmp    80104757 <acquire+0x87>
80104796:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010479d:	00 
8010479e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801047a0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801047a3:	e8 a8 f1 ff ff       	call   80103950 <mycpu>
801047a8:	39 c3                	cmp    %eax,%ebx
801047aa:	0f 85 3e ff ff ff    	jne    801046ee <acquire+0x1e>
  popcli();
801047b0:	e8 1b fe ff ff       	call   801045d0 <popcli>
    panic("acquire");
801047b5:	83 ec 0c             	sub    $0xc,%esp
801047b8:	68 b2 77 10 80       	push   $0x801077b2
801047bd:	e8 be bb ff ff       	call   80100380 <panic>
801047c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047c9:	00 
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <InitReentrantLock>:

void InitReentrantLock(struct reentrant_lock *rlock, char *name) {
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801047d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801047d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801047df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801047e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    initlock(&rlock->lock, name);
    rlock->holder = 0;
801047e9:	c7 40 34 00 00 00 00 	movl   $0x0,0x34(%eax)
    rlock->recursion_depth = 0;
801047f0:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
}
801047f7:	5d                   	pop    %ebp
801047f8:	c3                   	ret
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104800 <reentrant_acquire>:
void reentrant_acquire(struct reentrant_lock *rlock) {
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 75 08             	mov    0x8(%ebp),%esi
  
    struct proc *current_proc = myproc();
80104808:	e8 c3 f1 ff ff       	call   801039d0 <myproc>
8010480d:	89 c3                	mov    %eax,%ebx

    
    if (rlock->holder->pid == current_proc->pid) {
8010480f:	8b 46 34             	mov    0x34(%esi),%eax
80104812:	8b 53 10             	mov    0x10(%ebx),%edx
80104815:	39 50 10             	cmp    %edx,0x10(%eax)
80104818:	74 26                	je     80104840 <reentrant_acquire+0x40>
        rlock->recursion_depth++;

        return;
    }
    
    acquire(&rlock->lock);
8010481a:	83 ec 0c             	sub    $0xc,%esp
8010481d:	56                   	push   %esi
8010481e:	e8 ad fe ff ff       	call   801046d0 <acquire>
    rlock->holder = current_proc;
80104823:	b8 01 00 00 00       	mov    $0x1,%eax
80104828:	89 5e 34             	mov    %ebx,0x34(%esi)
8010482b:	83 c4 10             	add    $0x10,%esp
        rlock->recursion_depth++;
8010482e:	89 46 38             	mov    %eax,0x38(%esi)
    rlock->recursion_depth = 1;
    
    
    
}
80104831:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104834:	5b                   	pop    %ebx
80104835:	5e                   	pop    %esi
80104836:	5d                   	pop    %ebp
80104837:	c3                   	ret
80104838:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010483f:	00 
        rlock->recursion_depth++;
80104840:	8b 46 38             	mov    0x38(%esi),%eax
80104843:	83 c0 01             	add    $0x1,%eax
80104846:	89 46 38             	mov    %eax,0x38(%esi)
}
80104849:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010484c:	5b                   	pop    %ebx
8010484d:	5e                   	pop    %esi
8010484e:	5d                   	pop    %ebp
8010484f:	c3                   	ret

80104850 <release_reentrant_lock>:

void release_reentrant_lock(struct reentrant_lock *rlock) {
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (rlock->holder != myproc()) {
80104858:	8b 73 34             	mov    0x34(%ebx),%esi
8010485b:	e8 70 f1 ff ff       	call   801039d0 <myproc>
80104860:	39 c6                	cmp    %eax,%esi
80104862:	75 39                	jne    8010489d <release_reentrant_lock+0x4d>
        panic("release_reentrant_lock: lock not held by current process");
    }

    rlock->recursion_depth--;
80104864:	83 6b 38 01          	subl   $0x1,0x38(%ebx)

    if (rlock->recursion_depth == 0) {
80104868:	74 0e                	je     80104878 <release_reentrant_lock+0x28>
        
        cprintf("release\n");
        release(&rlock->lock);
        
    }
}
8010486a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010486d:	5b                   	pop    %ebx
8010486e:	5e                   	pop    %esi
8010486f:	5d                   	pop    %ebp
80104870:	c3                   	ret
80104871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf("release\n");
80104878:	83 ec 0c             	sub    $0xc,%esp
        rlock->holder = 0;
8010487b:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
        cprintf("release\n");
80104882:	68 ba 77 10 80       	push   $0x801077ba
80104887:	e8 24 be ff ff       	call   801006b0 <cprintf>
        release(&rlock->lock);
8010488c:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010488f:	83 c4 10             	add    $0x10,%esp
}
80104892:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104895:	5b                   	pop    %ebx
80104896:	5e                   	pop    %esi
80104897:	5d                   	pop    %ebp
        release(&rlock->lock);
80104898:	e9 d3 fd ff ff       	jmp    80104670 <release>
        panic("release_reentrant_lock: lock not held by current process");
8010489d:	83 ec 0c             	sub    $0xc,%esp
801048a0:	68 98 7a 10 80       	push   $0x80107a98
801048a5:	e8 d6 ba ff ff       	call   80100380 <panic>
801048aa:	66 90                	xchg   %ax,%ax
801048ac:	66 90                	xchg   %ax,%ax
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	8b 55 08             	mov    0x8(%ebp),%edx
801048b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801048ba:	89 d0                	mov    %edx,%eax
801048bc:	09 c8                	or     %ecx,%eax
801048be:	a8 03                	test   $0x3,%al
801048c0:	75 1e                	jne    801048e0 <memset+0x30>
    c &= 0xFF;
801048c2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048c6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
801048c9:	89 d7                	mov    %edx,%edi
801048cb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801048d1:	fc                   	cld
801048d2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048d4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801048d7:	89 d0                	mov    %edx,%eax
801048d9:	c9                   	leave
801048da:	c3                   	ret
801048db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801048e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801048e3:	89 d7                	mov    %edx,%edi
801048e5:	fc                   	cld
801048e6:	f3 aa                	rep stos %al,%es:(%edi)
801048e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801048eb:	89 d0                	mov    %edx,%eax
801048ed:	c9                   	leave
801048ee:	c3                   	ret
801048ef:	90                   	nop

801048f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	8b 75 10             	mov    0x10(%ebp),%esi
801048f7:	8b 45 08             	mov    0x8(%ebp),%eax
801048fa:	53                   	push   %ebx
801048fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048fe:	85 f6                	test   %esi,%esi
80104900:	74 2e                	je     80104930 <memcmp+0x40>
80104902:	01 c6                	add    %eax,%esi
80104904:	eb 14                	jmp    8010491a <memcmp+0x2a>
80104906:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010490d:	00 
8010490e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104910:	83 c0 01             	add    $0x1,%eax
80104913:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104916:	39 f0                	cmp    %esi,%eax
80104918:	74 16                	je     80104930 <memcmp+0x40>
    if(*s1 != *s2)
8010491a:	0f b6 08             	movzbl (%eax),%ecx
8010491d:	0f b6 1a             	movzbl (%edx),%ebx
80104920:	38 d9                	cmp    %bl,%cl
80104922:	74 ec                	je     80104910 <memcmp+0x20>
      return *s1 - *s2;
80104924:	0f b6 c1             	movzbl %cl,%eax
80104927:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104929:	5b                   	pop    %ebx
8010492a:	5e                   	pop    %esi
8010492b:	5d                   	pop    %ebp
8010492c:	c3                   	ret
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
80104930:	5b                   	pop    %ebx
  return 0;
80104931:	31 c0                	xor    %eax,%eax
}
80104933:	5e                   	pop    %esi
80104934:	5d                   	pop    %ebp
80104935:	c3                   	ret
80104936:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010493d:	00 
8010493e:	66 90                	xchg   %ax,%ax

80104940 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	8b 55 08             	mov    0x8(%ebp),%edx
80104947:	8b 45 10             	mov    0x10(%ebp),%eax
8010494a:	56                   	push   %esi
8010494b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010494e:	39 d6                	cmp    %edx,%esi
80104950:	73 26                	jae    80104978 <memmove+0x38>
80104952:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104955:	39 ca                	cmp    %ecx,%edx
80104957:	73 1f                	jae    80104978 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104959:	85 c0                	test   %eax,%eax
8010495b:	74 0f                	je     8010496c <memmove+0x2c>
8010495d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104960:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104964:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104967:	83 e8 01             	sub    $0x1,%eax
8010496a:	73 f4                	jae    80104960 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010496c:	5e                   	pop    %esi
8010496d:	89 d0                	mov    %edx,%eax
8010496f:	5f                   	pop    %edi
80104970:	5d                   	pop    %ebp
80104971:	c3                   	ret
80104972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104978:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010497b:	89 d7                	mov    %edx,%edi
8010497d:	85 c0                	test   %eax,%eax
8010497f:	74 eb                	je     8010496c <memmove+0x2c>
80104981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104988:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104989:	39 ce                	cmp    %ecx,%esi
8010498b:	75 fb                	jne    80104988 <memmove+0x48>
}
8010498d:	5e                   	pop    %esi
8010498e:	89 d0                	mov    %edx,%eax
80104990:	5f                   	pop    %edi
80104991:	5d                   	pop    %ebp
80104992:	c3                   	ret
80104993:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010499a:	00 
8010499b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801049a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801049a0:	eb 9e                	jmp    80104940 <memmove>
801049a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049a9:	00 
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	53                   	push   %ebx
801049b4:	8b 55 10             	mov    0x10(%ebp),%edx
801049b7:	8b 45 08             	mov    0x8(%ebp),%eax
801049ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801049bd:	85 d2                	test   %edx,%edx
801049bf:	75 16                	jne    801049d7 <strncmp+0x27>
801049c1:	eb 2d                	jmp    801049f0 <strncmp+0x40>
801049c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801049c8:	3a 19                	cmp    (%ecx),%bl
801049ca:	75 12                	jne    801049de <strncmp+0x2e>
    n--, p++, q++;
801049cc:	83 c0 01             	add    $0x1,%eax
801049cf:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049d2:	83 ea 01             	sub    $0x1,%edx
801049d5:	74 19                	je     801049f0 <strncmp+0x40>
801049d7:	0f b6 18             	movzbl (%eax),%ebx
801049da:	84 db                	test   %bl,%bl
801049dc:	75 ea                	jne    801049c8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049de:	0f b6 00             	movzbl (%eax),%eax
801049e1:	0f b6 11             	movzbl (%ecx),%edx
}
801049e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049e7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801049e8:	29 d0                	sub    %edx,%eax
}
801049ea:	c3                   	ret
801049eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801049f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801049f3:	31 c0                	xor    %eax,%eax
}
801049f5:	c9                   	leave
801049f6:	c3                   	ret
801049f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049fe:	00 
801049ff:	90                   	nop

80104a00 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	56                   	push   %esi
80104a05:	8b 75 08             	mov    0x8(%ebp),%esi
80104a08:	53                   	push   %ebx
80104a09:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a0c:	89 f0                	mov    %esi,%eax
80104a0e:	eb 15                	jmp    80104a25 <strncpy+0x25>
80104a10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a14:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a17:	83 c0 01             	add    $0x1,%eax
80104a1a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104a1e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104a21:	84 c9                	test   %cl,%cl
80104a23:	74 13                	je     80104a38 <strncpy+0x38>
80104a25:	89 d3                	mov    %edx,%ebx
80104a27:	83 ea 01             	sub    $0x1,%edx
80104a2a:	85 db                	test   %ebx,%ebx
80104a2c:	7f e2                	jg     80104a10 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104a2e:	5b                   	pop    %ebx
80104a2f:	89 f0                	mov    %esi,%eax
80104a31:	5e                   	pop    %esi
80104a32:	5f                   	pop    %edi
80104a33:	5d                   	pop    %ebp
80104a34:	c3                   	ret
80104a35:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104a38:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104a3b:	83 e9 01             	sub    $0x1,%ecx
80104a3e:	85 d2                	test   %edx,%edx
80104a40:	74 ec                	je     80104a2e <strncpy+0x2e>
80104a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104a48:	83 c0 01             	add    $0x1,%eax
80104a4b:	89 ca                	mov    %ecx,%edx
80104a4d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104a51:	29 c2                	sub    %eax,%edx
80104a53:	85 d2                	test   %edx,%edx
80104a55:	7f f1                	jg     80104a48 <strncpy+0x48>
}
80104a57:	5b                   	pop    %ebx
80104a58:	89 f0                	mov    %esi,%eax
80104a5a:	5e                   	pop    %esi
80104a5b:	5f                   	pop    %edi
80104a5c:	5d                   	pop    %ebp
80104a5d:	c3                   	ret
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	8b 55 10             	mov    0x10(%ebp),%edx
80104a67:	8b 75 08             	mov    0x8(%ebp),%esi
80104a6a:	53                   	push   %ebx
80104a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a6e:	85 d2                	test   %edx,%edx
80104a70:	7e 25                	jle    80104a97 <safestrcpy+0x37>
80104a72:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a76:	89 f2                	mov    %esi,%edx
80104a78:	eb 16                	jmp    80104a90 <safestrcpy+0x30>
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a80:	0f b6 08             	movzbl (%eax),%ecx
80104a83:	83 c0 01             	add    $0x1,%eax
80104a86:	83 c2 01             	add    $0x1,%edx
80104a89:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a8c:	84 c9                	test   %cl,%cl
80104a8e:	74 04                	je     80104a94 <safestrcpy+0x34>
80104a90:	39 d8                	cmp    %ebx,%eax
80104a92:	75 ec                	jne    80104a80 <safestrcpy+0x20>
    ;
  *s = 0;
80104a94:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a97:	89 f0                	mov    %esi,%eax
80104a99:	5b                   	pop    %ebx
80104a9a:	5e                   	pop    %esi
80104a9b:	5d                   	pop    %ebp
80104a9c:	c3                   	ret
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi

80104aa0 <strlen>:

int
strlen(const char *s)
{
80104aa0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104aa1:	31 c0                	xor    %eax,%eax
{
80104aa3:	89 e5                	mov    %esp,%ebp
80104aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104aa8:	80 3a 00             	cmpb   $0x0,(%edx)
80104aab:	74 0c                	je     80104ab9 <strlen+0x19>
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
80104ab0:	83 c0 01             	add    $0x1,%eax
80104ab3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ab7:	75 f7                	jne    80104ab0 <strlen+0x10>
    ;
  return n;
}
80104ab9:	5d                   	pop    %ebp
80104aba:	c3                   	ret

80104abb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104abb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104abf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ac3:	55                   	push   %ebp
  pushl %ebx
80104ac4:	53                   	push   %ebx
  pushl %esi
80104ac5:	56                   	push   %esi
  pushl %edi
80104ac6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ac7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ac9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104acb:	5f                   	pop    %edi
  popl %esi
80104acc:	5e                   	pop    %esi
  popl %ebx
80104acd:	5b                   	pop    %ebx
  popl %ebp
80104ace:	5d                   	pop    %ebp
  ret
80104acf:	c3                   	ret

80104ad0 <fetchint>:
// Fetch the int at addr from the current process.
struct nsyslock nsys;

int
fetchint(uint addr, int *ip)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
80104ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104ada:	e8 f1 ee ff ff       	call   801039d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104adf:	8b 00                	mov    (%eax),%eax
80104ae1:	39 c3                	cmp    %eax,%ebx
80104ae3:	73 1b                	jae    80104b00 <fetchint+0x30>
80104ae5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ae8:	39 d0                	cmp    %edx,%eax
80104aea:	72 14                	jb     80104b00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104aec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aef:	8b 13                	mov    (%ebx),%edx
80104af1:	89 10                	mov    %edx,(%eax)
  return 0;
80104af3:	31 c0                	xor    %eax,%eax
}
80104af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af8:	c9                   	leave
80104af9:	c3                   	ret
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b05:	eb ee                	jmp    80104af5 <fetchint+0x25>
80104b07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b0e:	00 
80104b0f:	90                   	nop

80104b10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
80104b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b1a:	e8 b1 ee ff ff       	call   801039d0 <myproc>

  if(addr >= curproc->sz)
80104b1f:	3b 18                	cmp    (%eax),%ebx
80104b21:	73 2d                	jae    80104b50 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b23:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b26:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b28:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b2a:	39 d3                	cmp    %edx,%ebx
80104b2c:	73 22                	jae    80104b50 <fetchstr+0x40>
80104b2e:	89 d8                	mov    %ebx,%eax
80104b30:	eb 0d                	jmp    80104b3f <fetchstr+0x2f>
80104b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b38:	83 c0 01             	add    $0x1,%eax
80104b3b:	39 d0                	cmp    %edx,%eax
80104b3d:	73 11                	jae    80104b50 <fetchstr+0x40>
    if(*s == 0)
80104b3f:	80 38 00             	cmpb   $0x0,(%eax)
80104b42:	75 f4                	jne    80104b38 <fetchstr+0x28>
      return s - *pp;
80104b44:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b49:	c9                   	leave
80104b4a:	c3                   	ret
80104b4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b58:	c9                   	leave
80104b59:	c3                   	ret
80104b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b65:	e8 66 ee ff ff       	call   801039d0 <myproc>
80104b6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b6d:	8b 40 18             	mov    0x18(%eax),%eax
80104b70:	8b 40 44             	mov    0x44(%eax),%eax
80104b73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b76:	e8 55 ee ff ff       	call   801039d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b7e:	8b 00                	mov    (%eax),%eax
80104b80:	39 c6                	cmp    %eax,%esi
80104b82:	73 1c                	jae    80104ba0 <argint+0x40>
80104b84:	8d 53 08             	lea    0x8(%ebx),%edx
80104b87:	39 d0                	cmp    %edx,%eax
80104b89:	72 15                	jb     80104ba0 <argint+0x40>
  *ip = *(int*)(addr);
80104b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b8e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b91:	89 10                	mov    %edx,(%eax)
  return 0;
80104b93:	31 c0                	xor    %eax,%eax
}
80104b95:	5b                   	pop    %ebx
80104b96:	5e                   	pop    %esi
80104b97:	5d                   	pop    %ebp
80104b98:	c3                   	ret
80104b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ba5:	eb ee                	jmp    80104b95 <argint+0x35>
80104ba7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bae:	00 
80104baf:	90                   	nop

80104bb0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104bb9:	e8 12 ee ff ff       	call   801039d0 <myproc>
80104bbe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc0:	e8 0b ee ff ff       	call   801039d0 <myproc>
80104bc5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bc8:	8b 40 18             	mov    0x18(%eax),%eax
80104bcb:	8b 40 44             	mov    0x44(%eax),%eax
80104bce:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bd1:	e8 fa ed ff ff       	call   801039d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bd9:	8b 00                	mov    (%eax),%eax
80104bdb:	39 c7                	cmp    %eax,%edi
80104bdd:	73 31                	jae    80104c10 <argptr+0x60>
80104bdf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104be2:	39 c8                	cmp    %ecx,%eax
80104be4:	72 2a                	jb     80104c10 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104be6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104be9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bec:	85 d2                	test   %edx,%edx
80104bee:	78 20                	js     80104c10 <argptr+0x60>
80104bf0:	8b 16                	mov    (%esi),%edx
80104bf2:	39 d0                	cmp    %edx,%eax
80104bf4:	73 1a                	jae    80104c10 <argptr+0x60>
80104bf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104bf9:	01 c3                	add    %eax,%ebx
80104bfb:	39 da                	cmp    %ebx,%edx
80104bfd:	72 11                	jb     80104c10 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c02:	89 02                	mov    %eax,(%edx)
  return 0;
80104c04:	31 c0                	xor    %eax,%eax
}
80104c06:	83 c4 0c             	add    $0xc,%esp
80104c09:	5b                   	pop    %ebx
80104c0a:	5e                   	pop    %esi
80104c0b:	5f                   	pop    %edi
80104c0c:	5d                   	pop    %ebp
80104c0d:	c3                   	ret
80104c0e:	66 90                	xchg   %ax,%ax
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c15:	eb ef                	jmp    80104c06 <argptr+0x56>
80104c17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c1e:	00 
80104c1f:	90                   	nop

80104c20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c25:	e8 a6 ed ff ff       	call   801039d0 <myproc>
80104c2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c2d:	8b 40 18             	mov    0x18(%eax),%eax
80104c30:	8b 40 44             	mov    0x44(%eax),%eax
80104c33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c36:	e8 95 ed ff ff       	call   801039d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3e:	8b 00                	mov    (%eax),%eax
80104c40:	39 c6                	cmp    %eax,%esi
80104c42:	73 44                	jae    80104c88 <argstr+0x68>
80104c44:	8d 53 08             	lea    0x8(%ebx),%edx
80104c47:	39 d0                	cmp    %edx,%eax
80104c49:	72 3d                	jb     80104c88 <argstr+0x68>
  *ip = *(int*)(addr);
80104c4b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c4e:	e8 7d ed ff ff       	call   801039d0 <myproc>
  if(addr >= curproc->sz)
80104c53:	3b 18                	cmp    (%eax),%ebx
80104c55:	73 31                	jae    80104c88 <argstr+0x68>
  *pp = (char*)addr;
80104c57:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c5e:	39 d3                	cmp    %edx,%ebx
80104c60:	73 26                	jae    80104c88 <argstr+0x68>
80104c62:	89 d8                	mov    %ebx,%eax
80104c64:	eb 11                	jmp    80104c77 <argstr+0x57>
80104c66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c6d:	00 
80104c6e:	66 90                	xchg   %ax,%ax
80104c70:	83 c0 01             	add    $0x1,%eax
80104c73:	39 d0                	cmp    %edx,%eax
80104c75:	73 11                	jae    80104c88 <argstr+0x68>
    if(*s == 0)
80104c77:	80 38 00             	cmpb   $0x0,(%eax)
80104c7a:	75 f4                	jne    80104c70 <argstr+0x50>
      return s - *pp;
80104c7c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c7e:	5b                   	pop    %ebx
80104c7f:	5e                   	pop    %esi
80104c80:	5d                   	pop    %ebp
80104c81:	c3                   	ret
80104c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c88:	5b                   	pop    %ebx
    return -1;
80104c89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c8e:	5e                   	pop    %esi
80104c8f:	5d                   	pop    %ebp
80104c90:	c3                   	ret
80104c91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c98:	00 
80104c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ca0 <syscall>:
[SYS_nsyscalls]  sys_nsyscalls,
};

void
syscall(void)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	53                   	push   %ebx
80104ca4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ca7:	e8 24 ed ff ff       	call   801039d0 <myproc>
80104cac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cae:	8b 40 18             	mov    0x18(%eax),%eax
80104cb1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cb4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cb7:	83 fa 19             	cmp    $0x19,%edx
80104cba:	77 1c                	ja     80104cd8 <syscall+0x38>
80104cbc:	8b 14 85 e0 7d 10 80 	mov    -0x7fef8220(,%eax,4),%edx
80104cc3:	85 d2                	test   %edx,%edx
80104cc5:	74 11                	je     80104cd8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104cc7:	ff d2                	call   *%edx
80104cc9:	89 c2                	mov    %eax,%edx
80104ccb:	8b 43 18             	mov    0x18(%ebx),%eax
80104cce:	89 50 1c             	mov    %edx,0x1c(%eax)
80104cd1:	eb 24                	jmp    80104cf7 <syscall+0x57>
80104cd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104cd8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cd9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cdc:	50                   	push   %eax
80104cdd:	ff 73 10             	push   0x10(%ebx)
80104ce0:	68 c3 77 10 80       	push   $0x801077c3
80104ce5:	e8 c6 b9 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104cea:	8b 43 18             	mov    0x18(%ebx),%eax
80104ced:	83 c4 10             	add    $0x10,%esp
80104cf0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  asm volatile("cli");
80104cf7:	fa                   	cli
  }
  cli();
  int CPUid = cpuid();
80104cf8:	e8 b3 ec ff ff       	call   801039b0 <cpuid>
  asm volatile("sti");
80104cfd:	fb                   	sti
  sti();
  cpus[CPUid].nsyscall++;
  acquire(&nsys.lk);
80104cfe:	83 ec 0c             	sub    $0xc,%esp
  cpus[CPUid].nsyscall++;
80104d01:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
  acquire(&nsys.lk);
80104d07:	68 40 3a 11 80       	push   $0x80113a40
  cpus[CPUid].nsyscall++;
80104d0c:	83 80 50 18 11 80 01 	addl   $0x1,-0x7feee7b0(%eax)
  acquire(&nsys.lk);
80104d13:	e8 b8 f9 ff ff       	call   801046d0 <acquire>
  nsys.n++;
  release(&nsys.lk);
80104d18:	c7 04 24 40 3a 11 80 	movl   $0x80113a40,(%esp)
  nsys.n++;
80104d1f:	83 05 74 3a 11 80 01 	addl   $0x1,0x80113a74
  release(&nsys.lk);
80104d26:	e8 45 f9 ff ff       	call   80104670 <release>
}
80104d2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d2e:	83 c4 10             	add    $0x10,%esp
80104d31:	c9                   	leave
80104d32:	c3                   	ret
80104d33:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d3a:	00 
80104d3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104d40 <getnsyscall>:

void getnsyscall(void) {
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	83 ec 14             	sub    $0x14,%esp
    cprintf("%d, %d, %d, %d, ",
80104d46:	ff 35 6c 1a 11 80    	push   0x80111a6c
80104d4c:	ff 35 b8 19 11 80    	push   0x801119b8
80104d52:	ff 35 04 19 11 80    	push   0x80111904
80104d58:	ff 35 50 18 11 80    	push   0x80111850
80104d5e:	68 df 77 10 80       	push   $0x801077df
80104d63:	e8 48 b9 ff ff       	call   801006b0 <cprintf>
            cpus[0].nsyscall,
            cpus[1].nsyscall,
            cpus[2].nsyscall,
            cpus[3].nsyscall);
    acquire(&nsys.lk);
80104d68:	83 c4 14             	add    $0x14,%esp
80104d6b:	68 40 3a 11 80       	push   $0x80113a40
80104d70:	e8 5b f9 ff ff       	call   801046d0 <acquire>
    cprintf("%d\n",
80104d75:	58                   	pop    %eax
80104d76:	5a                   	pop    %edx
80104d77:	ff 35 74 3a 11 80    	push   0x80113a74
80104d7d:	68 6b 76 10 80       	push   $0x8010766b
80104d82:	e8 29 b9 ff ff       	call   801006b0 <cprintf>
            nsys.n);
    release(&nsys.lk);
80104d87:	c7 04 24 40 3a 11 80 	movl   $0x80113a40,(%esp)
80104d8e:	e8 dd f8 ff ff       	call   80104670 <release>
}
80104d93:	83 c4 10             	add    $0x10,%esp
80104d96:	c9                   	leave
80104d97:	c3                   	ret
80104d98:	66 90                	xchg   %ax,%ax
80104d9a:	66 90                	xchg   %ax,%ax
80104d9c:	66 90                	xchg   %ax,%ax
80104d9e:	66 90                	xchg   %ax,%ax

80104da0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	57                   	push   %edi
80104da4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104da5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104da8:	53                   	push   %ebx
80104da9:	83 ec 34             	sub    $0x34,%esp
80104dac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104daf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104db2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104db5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104db8:	57                   	push   %edi
80104db9:	50                   	push   %eax
80104dba:	e8 31 d3 ff ff       	call   801020f0 <nameiparent>
80104dbf:	83 c4 10             	add    $0x10,%esp
80104dc2:	85 c0                	test   %eax,%eax
80104dc4:	74 5e                	je     80104e24 <create+0x84>
    return 0;
  ilock(dp);
80104dc6:	83 ec 0c             	sub    $0xc,%esp
80104dc9:	89 c3                	mov    %eax,%ebx
80104dcb:	50                   	push   %eax
80104dcc:	e8 1f ca ff ff       	call   801017f0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104dd1:	83 c4 0c             	add    $0xc,%esp
80104dd4:	6a 00                	push   $0x0
80104dd6:	57                   	push   %edi
80104dd7:	53                   	push   %ebx
80104dd8:	e8 63 cf ff ff       	call   80101d40 <dirlookup>
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	89 c6                	mov    %eax,%esi
80104de2:	85 c0                	test   %eax,%eax
80104de4:	74 4a                	je     80104e30 <create+0x90>
    iunlockput(dp);
80104de6:	83 ec 0c             	sub    $0xc,%esp
80104de9:	53                   	push   %ebx
80104dea:	e8 91 cc ff ff       	call   80101a80 <iunlockput>
    ilock(ip);
80104def:	89 34 24             	mov    %esi,(%esp)
80104df2:	e8 f9 c9 ff ff       	call   801017f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104df7:	83 c4 10             	add    $0x10,%esp
80104dfa:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104dff:	75 17                	jne    80104e18 <create+0x78>
80104e01:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e06:	75 10                	jne    80104e18 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e0b:	89 f0                	mov    %esi,%eax
80104e0d:	5b                   	pop    %ebx
80104e0e:	5e                   	pop    %esi
80104e0f:	5f                   	pop    %edi
80104e10:	5d                   	pop    %ebp
80104e11:	c3                   	ret
80104e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e18:	83 ec 0c             	sub    $0xc,%esp
80104e1b:	56                   	push   %esi
80104e1c:	e8 5f cc ff ff       	call   80101a80 <iunlockput>
    return 0;
80104e21:	83 c4 10             	add    $0x10,%esp
}
80104e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e27:	31 f6                	xor    %esi,%esi
}
80104e29:	5b                   	pop    %ebx
80104e2a:	89 f0                	mov    %esi,%eax
80104e2c:	5e                   	pop    %esi
80104e2d:	5f                   	pop    %edi
80104e2e:	5d                   	pop    %ebp
80104e2f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104e30:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e34:	83 ec 08             	sub    $0x8,%esp
80104e37:	50                   	push   %eax
80104e38:	ff 33                	push   (%ebx)
80104e3a:	e8 41 c8 ff ff       	call   80101680 <ialloc>
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	89 c6                	mov    %eax,%esi
80104e44:	85 c0                	test   %eax,%eax
80104e46:	0f 84 bc 00 00 00    	je     80104f08 <create+0x168>
  ilock(ip);
80104e4c:	83 ec 0c             	sub    $0xc,%esp
80104e4f:	50                   	push   %eax
80104e50:	e8 9b c9 ff ff       	call   801017f0 <ilock>
  ip->major = major;
80104e55:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e59:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e5d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e61:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e65:	b8 01 00 00 00       	mov    $0x1,%eax
80104e6a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e6e:	89 34 24             	mov    %esi,(%esp)
80104e71:	e8 ca c8 ff ff       	call   80101740 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e76:	83 c4 10             	add    $0x10,%esp
80104e79:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e7e:	74 30                	je     80104eb0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104e80:	83 ec 04             	sub    $0x4,%esp
80104e83:	ff 76 04             	push   0x4(%esi)
80104e86:	57                   	push   %edi
80104e87:	53                   	push   %ebx
80104e88:	e8 83 d1 ff ff       	call   80102010 <dirlink>
80104e8d:	83 c4 10             	add    $0x10,%esp
80104e90:	85 c0                	test   %eax,%eax
80104e92:	78 67                	js     80104efb <create+0x15b>
  iunlockput(dp);
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	53                   	push   %ebx
80104e98:	e8 e3 cb ff ff       	call   80101a80 <iunlockput>
  return ip;
80104e9d:	83 c4 10             	add    $0x10,%esp
}
80104ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ea3:	89 f0                	mov    %esi,%eax
80104ea5:	5b                   	pop    %ebx
80104ea6:	5e                   	pop    %esi
80104ea7:	5f                   	pop    %edi
80104ea8:	5d                   	pop    %ebp
80104ea9:	c3                   	ret
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104eb0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104eb3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104eb8:	53                   	push   %ebx
80104eb9:	e8 82 c8 ff ff       	call   80101740 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104ebe:	83 c4 0c             	add    $0xc,%esp
80104ec1:	ff 76 04             	push   0x4(%esi)
80104ec4:	68 0c 78 10 80       	push   $0x8010780c
80104ec9:	56                   	push   %esi
80104eca:	e8 41 d1 ff ff       	call   80102010 <dirlink>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	78 18                	js     80104eee <create+0x14e>
80104ed6:	83 ec 04             	sub    $0x4,%esp
80104ed9:	ff 73 04             	push   0x4(%ebx)
80104edc:	68 0b 78 10 80       	push   $0x8010780b
80104ee1:	56                   	push   %esi
80104ee2:	e8 29 d1 ff ff       	call   80102010 <dirlink>
80104ee7:	83 c4 10             	add    $0x10,%esp
80104eea:	85 c0                	test   %eax,%eax
80104eec:	79 92                	jns    80104e80 <create+0xe0>
      panic("create dots");
80104eee:	83 ec 0c             	sub    $0xc,%esp
80104ef1:	68 ff 77 10 80       	push   $0x801077ff
80104ef6:	e8 85 b4 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104efb:	83 ec 0c             	sub    $0xc,%esp
80104efe:	68 0e 78 10 80       	push   $0x8010780e
80104f03:	e8 78 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f08:	83 ec 0c             	sub    $0xc,%esp
80104f0b:	68 f0 77 10 80       	push   $0x801077f0
80104f10:	e8 6b b4 ff ff       	call   80100380 <panic>
80104f15:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f1c:	00 
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi

80104f20 <sys_dup>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	50                   	push   %eax
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 2d fc ff ff       	call   80104b60 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 36                	js     80104f70 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 30                	ja     80104f70 <sys_dup+0x50>
80104f40:	e8 8b ea ff ff       	call   801039d0 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f4c:	85 f6                	test   %esi,%esi
80104f4e:	74 20                	je     80104f70 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f50:	e8 7b ea ff ff       	call   801039d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f55:	31 db                	xor    %ebx,%ebx
80104f57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f5e:	00 
80104f5f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104f60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f64:	85 d2                	test   %edx,%edx
80104f66:	74 18                	je     80104f80 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f68:	83 c3 01             	add    $0x1,%ebx
80104f6b:	83 fb 10             	cmp    $0x10,%ebx
80104f6e:	75 f0                	jne    80104f60 <sys_dup+0x40>
}
80104f70:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f78:	89 d8                	mov    %ebx,%eax
80104f7a:	5b                   	pop    %ebx
80104f7b:	5e                   	pop    %esi
80104f7c:	5d                   	pop    %ebp
80104f7d:	c3                   	ret
80104f7e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f80:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f83:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f87:	56                   	push   %esi
80104f88:	e8 83 bf ff ff       	call   80100f10 <filedup>
  return fd;
80104f8d:	83 c4 10             	add    $0x10,%esp
}
80104f90:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f93:	89 d8                	mov    %ebx,%eax
80104f95:	5b                   	pop    %ebx
80104f96:	5e                   	pop    %esi
80104f97:	5d                   	pop    %ebp
80104f98:	c3                   	ret
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <sys_read>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	53                   	push   %ebx
80104fac:	6a 00                	push   $0x0
80104fae:	e8 ad fb ff ff       	call   80104b60 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 5e                	js     80105018 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 58                	ja     80105018 <sys_read+0x78>
80104fc0:	e8 0b ea ff ff       	call   801039d0 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 48                	je     80105018 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd0:	83 ec 08             	sub    $0x8,%esp
80104fd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd6:	50                   	push   %eax
80104fd7:	6a 02                	push   $0x2
80104fd9:	e8 82 fb ff ff       	call   80104b60 <argint>
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	78 33                	js     80105018 <sys_read+0x78>
80104fe5:	83 ec 04             	sub    $0x4,%esp
80104fe8:	ff 75 f0             	push   -0x10(%ebp)
80104feb:	53                   	push   %ebx
80104fec:	6a 01                	push   $0x1
80104fee:	e8 bd fb ff ff       	call   80104bb0 <argptr>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 1e                	js     80105018 <sys_read+0x78>
  return fileread(f, p, n);
80104ffa:	83 ec 04             	sub    $0x4,%esp
80104ffd:	ff 75 f0             	push   -0x10(%ebp)
80105000:	ff 75 f4             	push   -0xc(%ebp)
80105003:	56                   	push   %esi
80105004:	e8 87 c0 ff ff       	call   80101090 <fileread>
80105009:	83 c4 10             	add    $0x10,%esp
}
8010500c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010500f:	5b                   	pop    %ebx
80105010:	5e                   	pop    %esi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret
80105013:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501d:	eb ed                	jmp    8010500c <sys_read+0x6c>
8010501f:	90                   	nop

80105020 <sys_write>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	53                   	push   %ebx
8010502c:	6a 00                	push   $0x0
8010502e:	e8 2d fb ff ff       	call   80104b60 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 5e                	js     80105098 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 58                	ja     80105098 <sys_write+0x78>
80105040:	e8 8b e9 ff ff       	call   801039d0 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010504c:	85 f6                	test   %esi,%esi
8010504e:	74 48                	je     80105098 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105050:	83 ec 08             	sub    $0x8,%esp
80105053:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105056:	50                   	push   %eax
80105057:	6a 02                	push   $0x2
80105059:	e8 02 fb ff ff       	call   80104b60 <argint>
8010505e:	83 c4 10             	add    $0x10,%esp
80105061:	85 c0                	test   %eax,%eax
80105063:	78 33                	js     80105098 <sys_write+0x78>
80105065:	83 ec 04             	sub    $0x4,%esp
80105068:	ff 75 f0             	push   -0x10(%ebp)
8010506b:	53                   	push   %ebx
8010506c:	6a 01                	push   $0x1
8010506e:	e8 3d fb ff ff       	call   80104bb0 <argptr>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 1e                	js     80105098 <sys_write+0x78>
  return filewrite(f, p, n);
8010507a:	83 ec 04             	sub    $0x4,%esp
8010507d:	ff 75 f0             	push   -0x10(%ebp)
80105080:	ff 75 f4             	push   -0xc(%ebp)
80105083:	56                   	push   %esi
80105084:	e8 97 c0 ff ff       	call   80101120 <filewrite>
80105089:	83 c4 10             	add    $0x10,%esp
}
8010508c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010508f:	5b                   	pop    %ebx
80105090:	5e                   	pop    %esi
80105091:	5d                   	pop    %ebp
80105092:	c3                   	ret
80105093:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb ed                	jmp    8010508c <sys_write+0x6c>
8010509f:	90                   	nop

801050a0 <sys_close>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050ab:	50                   	push   %eax
801050ac:	6a 00                	push   $0x0
801050ae:	e8 ad fa ff ff       	call   80104b60 <argint>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	78 3e                	js     801050f8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050be:	77 38                	ja     801050f8 <sys_close+0x58>
801050c0:	e8 0b e9 ff ff       	call   801039d0 <myproc>
801050c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c8:	8d 5a 08             	lea    0x8(%edx),%ebx
801050cb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801050cf:	85 f6                	test   %esi,%esi
801050d1:	74 25                	je     801050f8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801050d3:	e8 f8 e8 ff ff       	call   801039d0 <myproc>
  fileclose(f);
801050d8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050db:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801050e2:	00 
  fileclose(f);
801050e3:	56                   	push   %esi
801050e4:	e8 77 be ff ff       	call   80100f60 <fileclose>
  return 0;
801050e9:	83 c4 10             	add    $0x10,%esp
801050ec:	31 c0                	xor    %eax,%eax
}
801050ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050f1:	5b                   	pop    %ebx
801050f2:	5e                   	pop    %esi
801050f3:	5d                   	pop    %ebp
801050f4:	c3                   	ret
801050f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fd:	eb ef                	jmp    801050ee <sys_close+0x4e>
801050ff:	90                   	nop

80105100 <sys_fstat>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105105:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105108:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010510b:	53                   	push   %ebx
8010510c:	6a 00                	push   $0x0
8010510e:	e8 4d fa ff ff       	call   80104b60 <argint>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 46                	js     80105160 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010511a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010511e:	77 40                	ja     80105160 <sys_fstat+0x60>
80105120:	e8 ab e8 ff ff       	call   801039d0 <myproc>
80105125:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105128:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010512c:	85 f6                	test   %esi,%esi
8010512e:	74 30                	je     80105160 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105130:	83 ec 04             	sub    $0x4,%esp
80105133:	6a 14                	push   $0x14
80105135:	53                   	push   %ebx
80105136:	6a 01                	push   $0x1
80105138:	e8 73 fa ff ff       	call   80104bb0 <argptr>
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	85 c0                	test   %eax,%eax
80105142:	78 1c                	js     80105160 <sys_fstat+0x60>
  return filestat(f, st);
80105144:	83 ec 08             	sub    $0x8,%esp
80105147:	ff 75 f4             	push   -0xc(%ebp)
8010514a:	56                   	push   %esi
8010514b:	e8 f0 be ff ff       	call   80101040 <filestat>
80105150:	83 c4 10             	add    $0x10,%esp
}
80105153:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105156:	5b                   	pop    %ebx
80105157:	5e                   	pop    %esi
80105158:	5d                   	pop    %ebp
80105159:	c3                   	ret
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105165:	eb ec                	jmp    80105153 <sys_fstat+0x53>
80105167:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010516e:	00 
8010516f:	90                   	nop

80105170 <sys_link>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105175:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105178:	53                   	push   %ebx
80105179:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010517c:	50                   	push   %eax
8010517d:	6a 00                	push   $0x0
8010517f:	e8 9c fa ff ff       	call   80104c20 <argstr>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	0f 88 fb 00 00 00    	js     8010528a <sys_link+0x11a>
8010518f:	83 ec 08             	sub    $0x8,%esp
80105192:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105195:	50                   	push   %eax
80105196:	6a 01                	push   $0x1
80105198:	e8 83 fa ff ff       	call   80104c20 <argstr>
8010519d:	83 c4 10             	add    $0x10,%esp
801051a0:	85 c0                	test   %eax,%eax
801051a2:	0f 88 e2 00 00 00    	js     8010528a <sys_link+0x11a>
  begin_op();
801051a8:	e8 e3 db ff ff       	call   80102d90 <begin_op>
  if((ip = namei(old)) == 0){
801051ad:	83 ec 0c             	sub    $0xc,%esp
801051b0:	ff 75 d4             	push   -0x2c(%ebp)
801051b3:	e8 18 cf ff ff       	call   801020d0 <namei>
801051b8:	83 c4 10             	add    $0x10,%esp
801051bb:	89 c3                	mov    %eax,%ebx
801051bd:	85 c0                	test   %eax,%eax
801051bf:	0f 84 df 00 00 00    	je     801052a4 <sys_link+0x134>
  ilock(ip);
801051c5:	83 ec 0c             	sub    $0xc,%esp
801051c8:	50                   	push   %eax
801051c9:	e8 22 c6 ff ff       	call   801017f0 <ilock>
  if(ip->type == T_DIR){
801051ce:	83 c4 10             	add    $0x10,%esp
801051d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051d6:	0f 84 b5 00 00 00    	je     80105291 <sys_link+0x121>
  iupdate(ip);
801051dc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051df:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051e7:	53                   	push   %ebx
801051e8:	e8 53 c5 ff ff       	call   80101740 <iupdate>
  iunlock(ip);
801051ed:	89 1c 24             	mov    %ebx,(%esp)
801051f0:	e8 db c6 ff ff       	call   801018d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051f5:	58                   	pop    %eax
801051f6:	5a                   	pop    %edx
801051f7:	57                   	push   %edi
801051f8:	ff 75 d0             	push   -0x30(%ebp)
801051fb:	e8 f0 ce ff ff       	call   801020f0 <nameiparent>
80105200:	83 c4 10             	add    $0x10,%esp
80105203:	89 c6                	mov    %eax,%esi
80105205:	85 c0                	test   %eax,%eax
80105207:	74 5b                	je     80105264 <sys_link+0xf4>
  ilock(dp);
80105209:	83 ec 0c             	sub    $0xc,%esp
8010520c:	50                   	push   %eax
8010520d:	e8 de c5 ff ff       	call   801017f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105212:	8b 03                	mov    (%ebx),%eax
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	39 06                	cmp    %eax,(%esi)
80105219:	75 3d                	jne    80105258 <sys_link+0xe8>
8010521b:	83 ec 04             	sub    $0x4,%esp
8010521e:	ff 73 04             	push   0x4(%ebx)
80105221:	57                   	push   %edi
80105222:	56                   	push   %esi
80105223:	e8 e8 cd ff ff       	call   80102010 <dirlink>
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	85 c0                	test   %eax,%eax
8010522d:	78 29                	js     80105258 <sys_link+0xe8>
  iunlockput(dp);
8010522f:	83 ec 0c             	sub    $0xc,%esp
80105232:	56                   	push   %esi
80105233:	e8 48 c8 ff ff       	call   80101a80 <iunlockput>
  iput(ip);
80105238:	89 1c 24             	mov    %ebx,(%esp)
8010523b:	e8 e0 c6 ff ff       	call   80101920 <iput>
  end_op();
80105240:	e8 bb db ff ff       	call   80102e00 <end_op>
  return 0;
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	31 c0                	xor    %eax,%eax
}
8010524a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010524d:	5b                   	pop    %ebx
8010524e:	5e                   	pop    %esi
8010524f:	5f                   	pop    %edi
80105250:	5d                   	pop    %ebp
80105251:	c3                   	ret
80105252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105258:	83 ec 0c             	sub    $0xc,%esp
8010525b:	56                   	push   %esi
8010525c:	e8 1f c8 ff ff       	call   80101a80 <iunlockput>
    goto bad;
80105261:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	53                   	push   %ebx
80105268:	e8 83 c5 ff ff       	call   801017f0 <ilock>
  ip->nlink--;
8010526d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105272:	89 1c 24             	mov    %ebx,(%esp)
80105275:	e8 c6 c4 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
8010527a:	89 1c 24             	mov    %ebx,(%esp)
8010527d:	e8 fe c7 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105282:	e8 79 db ff ff       	call   80102e00 <end_op>
  return -1;
80105287:	83 c4 10             	add    $0x10,%esp
    return -1;
8010528a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528f:	eb b9                	jmp    8010524a <sys_link+0xda>
    iunlockput(ip);
80105291:	83 ec 0c             	sub    $0xc,%esp
80105294:	53                   	push   %ebx
80105295:	e8 e6 c7 ff ff       	call   80101a80 <iunlockput>
    end_op();
8010529a:	e8 61 db ff ff       	call   80102e00 <end_op>
    return -1;
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	eb e6                	jmp    8010528a <sys_link+0x11a>
    end_op();
801052a4:	e8 57 db ff ff       	call   80102e00 <end_op>
    return -1;
801052a9:	eb df                	jmp    8010528a <sys_link+0x11a>
801052ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801052b0 <sys_unlink>:
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801052b5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052b8:	53                   	push   %ebx
801052b9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801052bc:	50                   	push   %eax
801052bd:	6a 00                	push   $0x0
801052bf:	e8 5c f9 ff ff       	call   80104c20 <argstr>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	0f 88 54 01 00 00    	js     80105423 <sys_unlink+0x173>
  begin_op();
801052cf:	e8 bc da ff ff       	call   80102d90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052d4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052d7:	83 ec 08             	sub    $0x8,%esp
801052da:	53                   	push   %ebx
801052db:	ff 75 c0             	push   -0x40(%ebp)
801052de:	e8 0d ce ff ff       	call   801020f0 <nameiparent>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052e9:	85 c0                	test   %eax,%eax
801052eb:	0f 84 58 01 00 00    	je     80105449 <sys_unlink+0x199>
  ilock(dp);
801052f1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	57                   	push   %edi
801052f8:	e8 f3 c4 ff ff       	call   801017f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052fd:	58                   	pop    %eax
801052fe:	5a                   	pop    %edx
801052ff:	68 0c 78 10 80       	push   $0x8010780c
80105304:	53                   	push   %ebx
80105305:	e8 16 ca ff ff       	call   80101d20 <namecmp>
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	85 c0                	test   %eax,%eax
8010530f:	0f 84 fb 00 00 00    	je     80105410 <sys_unlink+0x160>
80105315:	83 ec 08             	sub    $0x8,%esp
80105318:	68 0b 78 10 80       	push   $0x8010780b
8010531d:	53                   	push   %ebx
8010531e:	e8 fd c9 ff ff       	call   80101d20 <namecmp>
80105323:	83 c4 10             	add    $0x10,%esp
80105326:	85 c0                	test   %eax,%eax
80105328:	0f 84 e2 00 00 00    	je     80105410 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010532e:	83 ec 04             	sub    $0x4,%esp
80105331:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105334:	50                   	push   %eax
80105335:	53                   	push   %ebx
80105336:	57                   	push   %edi
80105337:	e8 04 ca ff ff       	call   80101d40 <dirlookup>
8010533c:	83 c4 10             	add    $0x10,%esp
8010533f:	89 c3                	mov    %eax,%ebx
80105341:	85 c0                	test   %eax,%eax
80105343:	0f 84 c7 00 00 00    	je     80105410 <sys_unlink+0x160>
  ilock(ip);
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	50                   	push   %eax
8010534d:	e8 9e c4 ff ff       	call   801017f0 <ilock>
  if(ip->nlink < 1)
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010535a:	0f 8e 0a 01 00 00    	jle    8010546a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105360:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105365:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105368:	74 66                	je     801053d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010536a:	83 ec 04             	sub    $0x4,%esp
8010536d:	6a 10                	push   $0x10
8010536f:	6a 00                	push   $0x0
80105371:	57                   	push   %edi
80105372:	e8 39 f5 ff ff       	call   801048b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105377:	6a 10                	push   $0x10
80105379:	ff 75 c4             	push   -0x3c(%ebp)
8010537c:	57                   	push   %edi
8010537d:	ff 75 b4             	push   -0x4c(%ebp)
80105380:	e8 7b c8 ff ff       	call   80101c00 <writei>
80105385:	83 c4 20             	add    $0x20,%esp
80105388:	83 f8 10             	cmp    $0x10,%eax
8010538b:	0f 85 cc 00 00 00    	jne    8010545d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105391:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105396:	0f 84 94 00 00 00    	je     80105430 <sys_unlink+0x180>
  iunlockput(dp);
8010539c:	83 ec 0c             	sub    $0xc,%esp
8010539f:	ff 75 b4             	push   -0x4c(%ebp)
801053a2:	e8 d9 c6 ff ff       	call   80101a80 <iunlockput>
  ip->nlink--;
801053a7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053ac:	89 1c 24             	mov    %ebx,(%esp)
801053af:	e8 8c c3 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
801053b4:	89 1c 24             	mov    %ebx,(%esp)
801053b7:	e8 c4 c6 ff ff       	call   80101a80 <iunlockput>
  end_op();
801053bc:	e8 3f da ff ff       	call   80102e00 <end_op>
  return 0;
801053c1:	83 c4 10             	add    $0x10,%esp
801053c4:	31 c0                	xor    %eax,%eax
}
801053c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053c9:	5b                   	pop    %ebx
801053ca:	5e                   	pop    %esi
801053cb:	5f                   	pop    %edi
801053cc:	5d                   	pop    %ebp
801053cd:	c3                   	ret
801053ce:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053d4:	76 94                	jbe    8010536a <sys_unlink+0xba>
801053d6:	be 20 00 00 00       	mov    $0x20,%esi
801053db:	eb 0b                	jmp    801053e8 <sys_unlink+0x138>
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
801053e0:	83 c6 10             	add    $0x10,%esi
801053e3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053e6:	73 82                	jae    8010536a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053e8:	6a 10                	push   $0x10
801053ea:	56                   	push   %esi
801053eb:	57                   	push   %edi
801053ec:	53                   	push   %ebx
801053ed:	e8 0e c7 ff ff       	call   80101b00 <readi>
801053f2:	83 c4 10             	add    $0x10,%esp
801053f5:	83 f8 10             	cmp    $0x10,%eax
801053f8:	75 56                	jne    80105450 <sys_unlink+0x1a0>
    if(de.inum != 0)
801053fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053ff:	74 df                	je     801053e0 <sys_unlink+0x130>
    iunlockput(ip);
80105401:	83 ec 0c             	sub    $0xc,%esp
80105404:	53                   	push   %ebx
80105405:	e8 76 c6 ff ff       	call   80101a80 <iunlockput>
    goto bad;
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	ff 75 b4             	push   -0x4c(%ebp)
80105416:	e8 65 c6 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010541b:	e8 e0 d9 ff ff       	call   80102e00 <end_op>
  return -1;
80105420:	83 c4 10             	add    $0x10,%esp
    return -1;
80105423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105428:	eb 9c                	jmp    801053c6 <sys_unlink+0x116>
8010542a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105430:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105433:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105436:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010543b:	50                   	push   %eax
8010543c:	e8 ff c2 ff ff       	call   80101740 <iupdate>
80105441:	83 c4 10             	add    $0x10,%esp
80105444:	e9 53 ff ff ff       	jmp    8010539c <sys_unlink+0xec>
    end_op();
80105449:	e8 b2 d9 ff ff       	call   80102e00 <end_op>
    return -1;
8010544e:	eb d3                	jmp    80105423 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105450:	83 ec 0c             	sub    $0xc,%esp
80105453:	68 30 78 10 80       	push   $0x80107830
80105458:	e8 23 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010545d:	83 ec 0c             	sub    $0xc,%esp
80105460:	68 42 78 10 80       	push   $0x80107842
80105465:	e8 16 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010546a:	83 ec 0c             	sub    $0xc,%esp
8010546d:	68 1e 78 10 80       	push   $0x8010781e
80105472:	e8 09 af ff ff       	call   80100380 <panic>
80105477:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010547e:	00 
8010547f:	90                   	nop

80105480 <sys_open>:

int
sys_open(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	57                   	push   %edi
80105484:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105485:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105488:	53                   	push   %ebx
80105489:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010548c:	50                   	push   %eax
8010548d:	6a 00                	push   $0x0
8010548f:	e8 8c f7 ff ff       	call   80104c20 <argstr>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	85 c0                	test   %eax,%eax
80105499:	0f 88 8e 00 00 00    	js     8010552d <sys_open+0xad>
8010549f:	83 ec 08             	sub    $0x8,%esp
801054a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054a5:	50                   	push   %eax
801054a6:	6a 01                	push   $0x1
801054a8:	e8 b3 f6 ff ff       	call   80104b60 <argint>
801054ad:	83 c4 10             	add    $0x10,%esp
801054b0:	85 c0                	test   %eax,%eax
801054b2:	78 79                	js     8010552d <sys_open+0xad>
    return -1;

  begin_op();
801054b4:	e8 d7 d8 ff ff       	call   80102d90 <begin_op>

  if(omode & O_CREATE){
801054b9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054bd:	75 79                	jne    80105538 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054bf:	83 ec 0c             	sub    $0xc,%esp
801054c2:	ff 75 e0             	push   -0x20(%ebp)
801054c5:	e8 06 cc ff ff       	call   801020d0 <namei>
801054ca:	83 c4 10             	add    $0x10,%esp
801054cd:	89 c6                	mov    %eax,%esi
801054cf:	85 c0                	test   %eax,%eax
801054d1:	0f 84 7e 00 00 00    	je     80105555 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054d7:	83 ec 0c             	sub    $0xc,%esp
801054da:	50                   	push   %eax
801054db:	e8 10 c3 ff ff       	call   801017f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054e0:	83 c4 10             	add    $0x10,%esp
801054e3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054e8:	0f 84 ba 00 00 00    	je     801055a8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054ee:	e8 ad b9 ff ff       	call   80100ea0 <filealloc>
801054f3:	89 c7                	mov    %eax,%edi
801054f5:	85 c0                	test   %eax,%eax
801054f7:	74 23                	je     8010551c <sys_open+0x9c>
  struct proc *curproc = myproc();
801054f9:	e8 d2 e4 ff ff       	call   801039d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054fe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105500:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105504:	85 d2                	test   %edx,%edx
80105506:	74 58                	je     80105560 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105508:	83 c3 01             	add    $0x1,%ebx
8010550b:	83 fb 10             	cmp    $0x10,%ebx
8010550e:	75 f0                	jne    80105500 <sys_open+0x80>
    if(f)
      fileclose(f);
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	57                   	push   %edi
80105514:	e8 47 ba ff ff       	call   80100f60 <fileclose>
80105519:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010551c:	83 ec 0c             	sub    $0xc,%esp
8010551f:	56                   	push   %esi
80105520:	e8 5b c5 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105525:	e8 d6 d8 ff ff       	call   80102e00 <end_op>
    return -1;
8010552a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010552d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105532:	eb 65                	jmp    80105599 <sys_open+0x119>
80105534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	31 c9                	xor    %ecx,%ecx
8010553d:	ba 02 00 00 00       	mov    $0x2,%edx
80105542:	6a 00                	push   $0x0
80105544:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105547:	e8 54 f8 ff ff       	call   80104da0 <create>
    if(ip == 0){
8010554c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010554f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105551:	85 c0                	test   %eax,%eax
80105553:	75 99                	jne    801054ee <sys_open+0x6e>
      end_op();
80105555:	e8 a6 d8 ff ff       	call   80102e00 <end_op>
      return -1;
8010555a:	eb d1                	jmp    8010552d <sys_open+0xad>
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105560:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105563:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105567:	56                   	push   %esi
80105568:	e8 63 c3 ff ff       	call   801018d0 <iunlock>
  end_op();
8010556d:	e8 8e d8 ff ff       	call   80102e00 <end_op>

  f->type = FD_INODE;
80105572:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105578:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010557b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010557e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105581:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105583:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010558a:	f7 d0                	not    %eax
8010558c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010558f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105592:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105595:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105599:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010559c:	89 d8                	mov    %ebx,%eax
8010559e:	5b                   	pop    %ebx
8010559f:	5e                   	pop    %esi
801055a0:	5f                   	pop    %edi
801055a1:	5d                   	pop    %ebp
801055a2:	c3                   	ret
801055a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801055a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055ab:	85 c9                	test   %ecx,%ecx
801055ad:	0f 84 3b ff ff ff    	je     801054ee <sys_open+0x6e>
801055b3:	e9 64 ff ff ff       	jmp    8010551c <sys_open+0x9c>
801055b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055bf:	00 

801055c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055c6:	e8 c5 d7 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055cb:	83 ec 08             	sub    $0x8,%esp
801055ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055d1:	50                   	push   %eax
801055d2:	6a 00                	push   $0x0
801055d4:	e8 47 f6 ff ff       	call   80104c20 <argstr>
801055d9:	83 c4 10             	add    $0x10,%esp
801055dc:	85 c0                	test   %eax,%eax
801055de:	78 30                	js     80105610 <sys_mkdir+0x50>
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e6:	31 c9                	xor    %ecx,%ecx
801055e8:	ba 01 00 00 00       	mov    $0x1,%edx
801055ed:	6a 00                	push   $0x0
801055ef:	e8 ac f7 ff ff       	call   80104da0 <create>
801055f4:	83 c4 10             	add    $0x10,%esp
801055f7:	85 c0                	test   %eax,%eax
801055f9:	74 15                	je     80105610 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055fb:	83 ec 0c             	sub    $0xc,%esp
801055fe:	50                   	push   %eax
801055ff:	e8 7c c4 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105604:	e8 f7 d7 ff ff       	call   80102e00 <end_op>
  return 0;
80105609:	83 c4 10             	add    $0x10,%esp
8010560c:	31 c0                	xor    %eax,%eax
}
8010560e:	c9                   	leave
8010560f:	c3                   	ret
    end_op();
80105610:	e8 eb d7 ff ff       	call   80102e00 <end_op>
    return -1;
80105615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010561a:	c9                   	leave
8010561b:	c3                   	ret
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105620 <sys_mknod>:

int
sys_mknod(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105626:	e8 65 d7 ff ff       	call   80102d90 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010562b:	83 ec 08             	sub    $0x8,%esp
8010562e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105631:	50                   	push   %eax
80105632:	6a 00                	push   $0x0
80105634:	e8 e7 f5 ff ff       	call   80104c20 <argstr>
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	85 c0                	test   %eax,%eax
8010563e:	78 60                	js     801056a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105640:	83 ec 08             	sub    $0x8,%esp
80105643:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105646:	50                   	push   %eax
80105647:	6a 01                	push   $0x1
80105649:	e8 12 f5 ff ff       	call   80104b60 <argint>
  if((argstr(0, &path)) < 0 ||
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	85 c0                	test   %eax,%eax
80105653:	78 4b                	js     801056a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105655:	83 ec 08             	sub    $0x8,%esp
80105658:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010565b:	50                   	push   %eax
8010565c:	6a 02                	push   $0x2
8010565e:	e8 fd f4 ff ff       	call   80104b60 <argint>
     argint(1, &major) < 0 ||
80105663:	83 c4 10             	add    $0x10,%esp
80105666:	85 c0                	test   %eax,%eax
80105668:	78 36                	js     801056a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010566a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010566e:	83 ec 0c             	sub    $0xc,%esp
80105671:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105675:	ba 03 00 00 00       	mov    $0x3,%edx
8010567a:	50                   	push   %eax
8010567b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010567e:	e8 1d f7 ff ff       	call   80104da0 <create>
     argint(2, &minor) < 0 ||
80105683:	83 c4 10             	add    $0x10,%esp
80105686:	85 c0                	test   %eax,%eax
80105688:	74 16                	je     801056a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010568a:	83 ec 0c             	sub    $0xc,%esp
8010568d:	50                   	push   %eax
8010568e:	e8 ed c3 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105693:	e8 68 d7 ff ff       	call   80102e00 <end_op>
  return 0;
80105698:	83 c4 10             	add    $0x10,%esp
8010569b:	31 c0                	xor    %eax,%eax
}
8010569d:	c9                   	leave
8010569e:	c3                   	ret
8010569f:	90                   	nop
    end_op();
801056a0:	e8 5b d7 ff ff       	call   80102e00 <end_op>
    return -1;
801056a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056aa:	c9                   	leave
801056ab:	c3                   	ret
801056ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056b0 <sys_chdir>:

int
sys_chdir(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	56                   	push   %esi
801056b4:	53                   	push   %ebx
801056b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056b8:	e8 13 e3 ff ff       	call   801039d0 <myproc>
801056bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056bf:	e8 cc d6 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056c4:	83 ec 08             	sub    $0x8,%esp
801056c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ca:	50                   	push   %eax
801056cb:	6a 00                	push   $0x0
801056cd:	e8 4e f5 ff ff       	call   80104c20 <argstr>
801056d2:	83 c4 10             	add    $0x10,%esp
801056d5:	85 c0                	test   %eax,%eax
801056d7:	78 77                	js     80105750 <sys_chdir+0xa0>
801056d9:	83 ec 0c             	sub    $0xc,%esp
801056dc:	ff 75 f4             	push   -0xc(%ebp)
801056df:	e8 ec c9 ff ff       	call   801020d0 <namei>
801056e4:	83 c4 10             	add    $0x10,%esp
801056e7:	89 c3                	mov    %eax,%ebx
801056e9:	85 c0                	test   %eax,%eax
801056eb:	74 63                	je     80105750 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056ed:	83 ec 0c             	sub    $0xc,%esp
801056f0:	50                   	push   %eax
801056f1:	e8 fa c0 ff ff       	call   801017f0 <ilock>
  if(ip->type != T_DIR){
801056f6:	83 c4 10             	add    $0x10,%esp
801056f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056fe:	75 30                	jne    80105730 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	53                   	push   %ebx
80105704:	e8 c7 c1 ff ff       	call   801018d0 <iunlock>
  iput(curproc->cwd);
80105709:	58                   	pop    %eax
8010570a:	ff 76 68             	push   0x68(%esi)
8010570d:	e8 0e c2 ff ff       	call   80101920 <iput>
  end_op();
80105712:	e8 e9 d6 ff ff       	call   80102e00 <end_op>
  curproc->cwd = ip;
80105717:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	31 c0                	xor    %eax,%eax
}
8010571f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105722:	5b                   	pop    %ebx
80105723:	5e                   	pop    %esi
80105724:	5d                   	pop    %ebp
80105725:	c3                   	ret
80105726:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010572d:	00 
8010572e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	53                   	push   %ebx
80105734:	e8 47 c3 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105739:	e8 c2 d6 ff ff       	call   80102e00 <end_op>
    return -1;
8010573e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105746:	eb d7                	jmp    8010571f <sys_chdir+0x6f>
80105748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010574f:	00 
    end_op();
80105750:	e8 ab d6 ff ff       	call   80102e00 <end_op>
    return -1;
80105755:	eb ea                	jmp    80105741 <sys_chdir+0x91>
80105757:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010575e:	00 
8010575f:	90                   	nop

80105760 <sys_exec>:

int
sys_exec(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	57                   	push   %edi
80105764:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105765:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010576b:	53                   	push   %ebx
8010576c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105772:	50                   	push   %eax
80105773:	6a 00                	push   $0x0
80105775:	e8 a6 f4 ff ff       	call   80104c20 <argstr>
8010577a:	83 c4 10             	add    $0x10,%esp
8010577d:	85 c0                	test   %eax,%eax
8010577f:	0f 88 87 00 00 00    	js     8010580c <sys_exec+0xac>
80105785:	83 ec 08             	sub    $0x8,%esp
80105788:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010578e:	50                   	push   %eax
8010578f:	6a 01                	push   $0x1
80105791:	e8 ca f3 ff ff       	call   80104b60 <argint>
80105796:	83 c4 10             	add    $0x10,%esp
80105799:	85 c0                	test   %eax,%eax
8010579b:	78 6f                	js     8010580c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010579d:	83 ec 04             	sub    $0x4,%esp
801057a0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801057a6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057a8:	68 80 00 00 00       	push   $0x80
801057ad:	6a 00                	push   $0x0
801057af:	56                   	push   %esi
801057b0:	e8 fb f0 ff ff       	call   801048b0 <memset>
801057b5:	83 c4 10             	add    $0x10,%esp
801057b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057bf:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057c0:	83 ec 08             	sub    $0x8,%esp
801057c3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057c9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057d0:	50                   	push   %eax
801057d1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057d7:	01 f8                	add    %edi,%eax
801057d9:	50                   	push   %eax
801057da:	e8 f1 f2 ff ff       	call   80104ad0 <fetchint>
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	85 c0                	test   %eax,%eax
801057e4:	78 26                	js     8010580c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801057e6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057ec:	85 c0                	test   %eax,%eax
801057ee:	74 30                	je     80105820 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801057f6:	52                   	push   %edx
801057f7:	50                   	push   %eax
801057f8:	e8 13 f3 ff ff       	call   80104b10 <fetchstr>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	78 08                	js     8010580c <sys_exec+0xac>
  for(i=0;; i++){
80105804:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105807:	83 fb 20             	cmp    $0x20,%ebx
8010580a:	75 b4                	jne    801057c0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010580c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010580f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105814:	5b                   	pop    %ebx
80105815:	5e                   	pop    %esi
80105816:	5f                   	pop    %edi
80105817:	5d                   	pop    %ebp
80105818:	c3                   	ret
80105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105820:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105827:	00 00 00 00 
  return exec(path, argv);
8010582b:	83 ec 08             	sub    $0x8,%esp
8010582e:	56                   	push   %esi
8010582f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105835:	e8 76 b2 ff ff       	call   80100ab0 <exec>
8010583a:	83 c4 10             	add    $0x10,%esp
}
8010583d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105840:	5b                   	pop    %ebx
80105841:	5e                   	pop    %esi
80105842:	5f                   	pop    %edi
80105843:	5d                   	pop    %ebp
80105844:	c3                   	ret
80105845:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010584c:	00 
8010584d:	8d 76 00             	lea    0x0(%esi),%esi

80105850 <sys_pipe>:

int
sys_pipe(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	57                   	push   %edi
80105854:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105855:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105858:	53                   	push   %ebx
80105859:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010585c:	6a 08                	push   $0x8
8010585e:	50                   	push   %eax
8010585f:	6a 00                	push   $0x0
80105861:	e8 4a f3 ff ff       	call   80104bb0 <argptr>
80105866:	83 c4 10             	add    $0x10,%esp
80105869:	85 c0                	test   %eax,%eax
8010586b:	0f 88 8b 00 00 00    	js     801058fc <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105871:	83 ec 08             	sub    $0x8,%esp
80105874:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105877:	50                   	push   %eax
80105878:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010587b:	50                   	push   %eax
8010587c:	e8 ff db ff ff       	call   80103480 <pipealloc>
80105881:	83 c4 10             	add    $0x10,%esp
80105884:	85 c0                	test   %eax,%eax
80105886:	78 74                	js     801058fc <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105888:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010588b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010588d:	e8 3e e1 ff ff       	call   801039d0 <myproc>
    if(curproc->ofile[fd] == 0){
80105892:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105896:	85 f6                	test   %esi,%esi
80105898:	74 16                	je     801058b0 <sys_pipe+0x60>
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058a0:	83 c3 01             	add    $0x1,%ebx
801058a3:	83 fb 10             	cmp    $0x10,%ebx
801058a6:	74 3d                	je     801058e5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801058a8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058ac:	85 f6                	test   %esi,%esi
801058ae:	75 f0                	jne    801058a0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801058b0:	8d 73 08             	lea    0x8(%ebx),%esi
801058b3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058ba:	e8 11 e1 ff ff       	call   801039d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058bf:	31 d2                	xor    %edx,%edx
801058c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058c8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058cc:	85 c9                	test   %ecx,%ecx
801058ce:	74 38                	je     80105908 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
801058d0:	83 c2 01             	add    $0x1,%edx
801058d3:	83 fa 10             	cmp    $0x10,%edx
801058d6:	75 f0                	jne    801058c8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801058d8:	e8 f3 e0 ff ff       	call   801039d0 <myproc>
801058dd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801058e4:	00 
    fileclose(rf);
801058e5:	83 ec 0c             	sub    $0xc,%esp
801058e8:	ff 75 e0             	push   -0x20(%ebp)
801058eb:	e8 70 b6 ff ff       	call   80100f60 <fileclose>
    fileclose(wf);
801058f0:	58                   	pop    %eax
801058f1:	ff 75 e4             	push   -0x1c(%ebp)
801058f4:	e8 67 b6 ff ff       	call   80100f60 <fileclose>
    return -1;
801058f9:	83 c4 10             	add    $0x10,%esp
    return -1;
801058fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105901:	eb 16                	jmp    80105919 <sys_pipe+0xc9>
80105903:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105908:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010590c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010590f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105911:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105914:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105917:	31 c0                	xor    %eax,%eax
}
80105919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010591c:	5b                   	pop    %ebx
8010591d:	5e                   	pop    %esi
8010591e:	5f                   	pop    %edi
8010591f:	5d                   	pop    %ebp
80105920:	c3                   	ret
80105921:	66 90                	xchg   %ax,%ax
80105923:	66 90                	xchg   %ax,%ax
80105925:	66 90                	xchg   %ax,%ax
80105927:	66 90                	xchg   %ax,%ax
80105929:	66 90                	xchg   %ax,%ax
8010592b:	66 90                	xchg   %ax,%ax
8010592d:	66 90                	xchg   %ax,%ax
8010592f:	90                   	nop

80105930 <sys_fork>:
#include "spinlock.h"

int
sys_fork(void)
{
  return fork();
80105930:	e9 3b e2 ff ff       	jmp    80103b70 <fork>
80105935:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010593c:	00 
8010593d:	8d 76 00             	lea    0x0(%esi),%esi

80105940 <sys_exit>:
}

int
sys_exit(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 08             	sub    $0x8,%esp
  exit();
80105946:	e8 95 e4 ff ff       	call   80103de0 <exit>
  return 0;  // not reached
}
8010594b:	31 c0                	xor    %eax,%eax
8010594d:	c9                   	leave
8010594e:	c3                   	ret
8010594f:	90                   	nop

80105950 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105950:	e9 bb e5 ff ff       	jmp    80103f10 <wait>
80105955:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010595c:	00 
8010595d:	8d 76 00             	lea    0x0(%esi),%esi

80105960 <sys_kill>:
}

int
sys_kill(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105966:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105969:	50                   	push   %eax
8010596a:	6a 00                	push   $0x0
8010596c:	e8 ef f1 ff ff       	call   80104b60 <argint>
80105971:	83 c4 10             	add    $0x10,%esp
80105974:	85 c0                	test   %eax,%eax
80105976:	78 18                	js     80105990 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	ff 75 f4             	push   -0xc(%ebp)
8010597e:	e8 2d e8 ff ff       	call   801041b0 <kill>
80105983:	83 c4 10             	add    $0x10,%esp
}
80105986:	c9                   	leave
80105987:	c3                   	ret
80105988:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010598f:	00 
80105990:	c9                   	leave
    return -1;
80105991:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105996:	c3                   	ret
80105997:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010599e:	00 
8010599f:	90                   	nop

801059a0 <sys_getpid>:

int
sys_getpid(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059a6:	e8 25 e0 ff ff       	call   801039d0 <myproc>
801059ab:	8b 40 10             	mov    0x10(%eax),%eax
}
801059ae:	c9                   	leave
801059af:	c3                   	ret

801059b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ba:	50                   	push   %eax
801059bb:	6a 00                	push   $0x0
801059bd:	e8 9e f1 ff ff       	call   80104b60 <argint>
801059c2:	83 c4 10             	add    $0x10,%esp
801059c5:	85 c0                	test   %eax,%eax
801059c7:	78 27                	js     801059f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059c9:	e8 02 e0 ff ff       	call   801039d0 <myproc>
  if(growproc(n) < 0)
801059ce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059d1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059d3:	ff 75 f4             	push   -0xc(%ebp)
801059d6:	e8 15 e1 ff ff       	call   80103af0 <growproc>
801059db:	83 c4 10             	add    $0x10,%esp
801059de:	85 c0                	test   %eax,%eax
801059e0:	78 0e                	js     801059f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059e2:	89 d8                	mov    %ebx,%eax
801059e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059e7:	c9                   	leave
801059e8:	c3                   	ret
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059f5:	eb eb                	jmp    801059e2 <sys_sbrk+0x32>
801059f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059fe:	00 
801059ff:	90                   	nop

80105a00 <sys_sleep>:

int
sys_sleep(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a0a:	50                   	push   %eax
80105a0b:	6a 00                	push   $0x0
80105a0d:	e8 4e f1 ff ff       	call   80104b60 <argint>
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	85 c0                	test   %eax,%eax
80105a17:	78 64                	js     80105a7d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105a19:	83 ec 0c             	sub    $0xc,%esp
80105a1c:	68 a0 3a 11 80       	push   $0x80113aa0
80105a21:	e8 aa ec ff ff       	call   801046d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a29:	8b 1d 80 3a 11 80    	mov    0x80113a80,%ebx
  while(ticks - ticks0 < n){
80105a2f:	83 c4 10             	add    $0x10,%esp
80105a32:	85 d2                	test   %edx,%edx
80105a34:	75 2b                	jne    80105a61 <sys_sleep+0x61>
80105a36:	eb 58                	jmp    80105a90 <sys_sleep+0x90>
80105a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a3f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a40:	83 ec 08             	sub    $0x8,%esp
80105a43:	68 a0 3a 11 80       	push   $0x80113aa0
80105a48:	68 80 3a 11 80       	push   $0x80113a80
80105a4d:	e8 3e e6 ff ff       	call   80104090 <sleep>
  while(ticks - ticks0 < n){
80105a52:	a1 80 3a 11 80       	mov    0x80113a80,%eax
80105a57:	83 c4 10             	add    $0x10,%esp
80105a5a:	29 d8                	sub    %ebx,%eax
80105a5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a5f:	73 2f                	jae    80105a90 <sys_sleep+0x90>
    if(myproc()->killed){
80105a61:	e8 6a df ff ff       	call   801039d0 <myproc>
80105a66:	8b 40 24             	mov    0x24(%eax),%eax
80105a69:	85 c0                	test   %eax,%eax
80105a6b:	74 d3                	je     80105a40 <sys_sleep+0x40>
      release(&tickslock);
80105a6d:	83 ec 0c             	sub    $0xc,%esp
80105a70:	68 a0 3a 11 80       	push   $0x80113aa0
80105a75:	e8 f6 eb ff ff       	call   80104670 <release>
      return -1;
80105a7a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105a7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a85:	c9                   	leave
80105a86:	c3                   	ret
80105a87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a8e:	00 
80105a8f:	90                   	nop
  release(&tickslock);
80105a90:	83 ec 0c             	sub    $0xc,%esp
80105a93:	68 a0 3a 11 80       	push   $0x80113aa0
80105a98:	e8 d3 eb ff ff       	call   80104670 <release>
}
80105a9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105aa0:	83 c4 10             	add    $0x10,%esp
80105aa3:	31 c0                	xor    %eax,%eax
}
80105aa5:	c9                   	leave
80105aa6:	c3                   	ret
80105aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aae:	00 
80105aaf:	90                   	nop

80105ab0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	53                   	push   %ebx
80105ab4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ab7:	68 a0 3a 11 80       	push   $0x80113aa0
80105abc:	e8 0f ec ff ff       	call   801046d0 <acquire>
  xticks = ticks;
80105ac1:	8b 1d 80 3a 11 80    	mov    0x80113a80,%ebx
  release(&tickslock);
80105ac7:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80105ace:	e8 9d eb ff ff       	call   80104670 <release>
  return xticks;
}
80105ad3:	89 d8                	mov    %ebx,%eax
80105ad5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ad8:	c9                   	leave
80105ad9:	c3                   	ret
80105ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ae0 <sys_test>:
int
sys_test(void){
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	83 ec 20             	sub    $0x20,%esp
  int a;
  argint(0,&a);
80105ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ae9:	50                   	push   %eax
80105aea:	6a 00                	push   $0x0
80105aec:	e8 6f f0 ff ff       	call   80104b60 <argint>
  
  return test(a);
80105af1:	58                   	pop    %eax
80105af2:	ff 75 f4             	push   -0xc(%ebp)
80105af5:	e8 16 e8 ff ff       	call   80104310 <test>
}
80105afa:	c9                   	leave
80105afb:	c3                   	ret
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_nsyscalls>:
int sys_nsyscalls(void) {
    return nsyscalls();
80105b00:	e9 9b e8 ff ff       	jmp    801043a0 <nsyscalls>

80105b05 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b05:	1e                   	push   %ds
  pushl %es
80105b06:	06                   	push   %es
  pushl %fs
80105b07:	0f a0                	push   %fs
  pushl %gs
80105b09:	0f a8                	push   %gs
  pushal
80105b0b:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b0c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b10:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b12:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b14:	54                   	push   %esp
  call trap
80105b15:	e8 c6 00 00 00       	call   80105be0 <trap>
  addl $4, %esp
80105b1a:	83 c4 04             	add    $0x4,%esp

80105b1d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b1d:	61                   	popa
  popl %gs
80105b1e:	0f a9                	pop    %gs
  popl %fs
80105b20:	0f a1                	pop    %fs
  popl %es
80105b22:	07                   	pop    %es
  popl %ds
80105b23:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b24:	83 c4 08             	add    $0x8,%esp
  iret
80105b27:	cf                   	iret
80105b28:	66 90                	xchg   %ax,%ax
80105b2a:	66 90                	xchg   %ax,%ax
80105b2c:	66 90                	xchg   %ax,%ax
80105b2e:	66 90                	xchg   %ax,%ax

80105b30 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b30:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b31:	31 c0                	xor    %eax,%eax
{
80105b33:	89 e5                	mov    %esp,%ebp
80105b35:	83 ec 08             	sub    $0x8,%esp
80105b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b3f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b40:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b47:	c7 04 c5 e2 3a 11 80 	movl   $0x8e000008,-0x7feec51e(,%eax,8)
80105b4e:	08 00 00 8e 
80105b52:	66 89 14 c5 e0 3a 11 	mov    %dx,-0x7feec520(,%eax,8)
80105b59:	80 
80105b5a:	c1 ea 10             	shr    $0x10,%edx
80105b5d:	66 89 14 c5 e6 3a 11 	mov    %dx,-0x7feec51a(,%eax,8)
80105b64:	80 
  for(i = 0; i < 256; i++)
80105b65:	83 c0 01             	add    $0x1,%eax
80105b68:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b6d:	75 d1                	jne    80105b40 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b6f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b72:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105b77:	c7 05 e2 3c 11 80 08 	movl   $0xef000008,0x80113ce2
80105b7e:	00 00 ef 
  initlock(&tickslock, "time");
80105b81:	68 51 78 10 80       	push   $0x80107851
80105b86:	68 a0 3a 11 80       	push   $0x80113aa0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b8b:	66 a3 e0 3c 11 80    	mov    %ax,0x80113ce0
80105b91:	c1 e8 10             	shr    $0x10,%eax
80105b94:	66 a3 e6 3c 11 80    	mov    %ax,0x80113ce6
  initlock(&tickslock, "time");
80105b9a:	e8 41 e9 ff ff       	call   801044e0 <initlock>
}
80105b9f:	83 c4 10             	add    $0x10,%esp
80105ba2:	c9                   	leave
80105ba3:	c3                   	ret
80105ba4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bab:	00 
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <idtinit>:

void
idtinit(void)
{
80105bb0:	55                   	push   %ebp
  pd[0] = size-1;
80105bb1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105bb6:	89 e5                	mov    %esp,%ebp
80105bb8:	83 ec 10             	sub    $0x10,%esp
80105bbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105bbf:	b8 e0 3a 11 80       	mov    $0x80113ae0,%eax
80105bc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105bc8:	c1 e8 10             	shr    $0x10,%eax
80105bcb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bcf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105bd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105bd5:	c9                   	leave
80105bd6:	c3                   	ret
80105bd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bde:	00 
80105bdf:	90                   	nop

80105be0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	57                   	push   %edi
80105be4:	56                   	push   %esi
80105be5:	53                   	push   %ebx
80105be6:	83 ec 1c             	sub    $0x1c,%esp
80105be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105bec:	8b 43 30             	mov    0x30(%ebx),%eax
80105bef:	83 f8 40             	cmp    $0x40,%eax
80105bf2:	0f 84 58 01 00 00    	je     80105d50 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105bf8:	83 e8 20             	sub    $0x20,%eax
80105bfb:	83 f8 1f             	cmp    $0x1f,%eax
80105bfe:	0f 87 7c 00 00 00    	ja     80105c80 <trap+0xa0>
80105c04:	ff 24 85 4c 7e 10 80 	jmp    *-0x7fef81b4(,%eax,4)
80105c0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c10:	e8 6b c6 ff ff       	call   80102280 <ideintr>
    lapiceoi();
80105c15:	e8 26 cd ff ff       	call   80102940 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c1a:	e8 b1 dd ff ff       	call   801039d0 <myproc>
80105c1f:	85 c0                	test   %eax,%eax
80105c21:	74 1a                	je     80105c3d <trap+0x5d>
80105c23:	e8 a8 dd ff ff       	call   801039d0 <myproc>
80105c28:	8b 50 24             	mov    0x24(%eax),%edx
80105c2b:	85 d2                	test   %edx,%edx
80105c2d:	74 0e                	je     80105c3d <trap+0x5d>
80105c2f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c33:	f7 d0                	not    %eax
80105c35:	a8 03                	test   $0x3,%al
80105c37:	0f 84 db 01 00 00    	je     80105e18 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c3d:	e8 8e dd ff ff       	call   801039d0 <myproc>
80105c42:	85 c0                	test   %eax,%eax
80105c44:	74 0f                	je     80105c55 <trap+0x75>
80105c46:	e8 85 dd ff ff       	call   801039d0 <myproc>
80105c4b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c4f:	0f 84 ab 00 00 00    	je     80105d00 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c55:	e8 76 dd ff ff       	call   801039d0 <myproc>
80105c5a:	85 c0                	test   %eax,%eax
80105c5c:	74 1a                	je     80105c78 <trap+0x98>
80105c5e:	e8 6d dd ff ff       	call   801039d0 <myproc>
80105c63:	8b 40 24             	mov    0x24(%eax),%eax
80105c66:	85 c0                	test   %eax,%eax
80105c68:	74 0e                	je     80105c78 <trap+0x98>
80105c6a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c6e:	f7 d0                	not    %eax
80105c70:	a8 03                	test   $0x3,%al
80105c72:	0f 84 05 01 00 00    	je     80105d7d <trap+0x19d>
    exit();
}
80105c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c7b:	5b                   	pop    %ebx
80105c7c:	5e                   	pop    %esi
80105c7d:	5f                   	pop    %edi
80105c7e:	5d                   	pop    %ebp
80105c7f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c80:	e8 4b dd ff ff       	call   801039d0 <myproc>
80105c85:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c88:	85 c0                	test   %eax,%eax
80105c8a:	0f 84 a2 01 00 00    	je     80105e32 <trap+0x252>
80105c90:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c94:	0f 84 98 01 00 00    	je     80105e32 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c9a:	0f 20 d1             	mov    %cr2,%ecx
80105c9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ca0:	e8 0b dd ff ff       	call   801039b0 <cpuid>
80105ca5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ca8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105cab:	8b 43 34             	mov    0x34(%ebx),%eax
80105cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105cb1:	e8 1a dd ff ff       	call   801039d0 <myproc>
80105cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105cb9:	e8 12 dd ff ff       	call   801039d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cbe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105cc1:	51                   	push   %ecx
80105cc2:	57                   	push   %edi
80105cc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105cc6:	52                   	push   %edx
80105cc7:	ff 75 e4             	push   -0x1c(%ebp)
80105cca:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ccb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105cce:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cd1:	56                   	push   %esi
80105cd2:	ff 70 10             	push   0x10(%eax)
80105cd5:	68 2c 7b 10 80       	push   $0x80107b2c
80105cda:	e8 d1 a9 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105cdf:	83 c4 20             	add    $0x20,%esp
80105ce2:	e8 e9 dc ff ff       	call   801039d0 <myproc>
80105ce7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cee:	e8 dd dc ff ff       	call   801039d0 <myproc>
80105cf3:	85 c0                	test   %eax,%eax
80105cf5:	0f 85 28 ff ff ff    	jne    80105c23 <trap+0x43>
80105cfb:	e9 3d ff ff ff       	jmp    80105c3d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105d00:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d04:	0f 85 4b ff ff ff    	jne    80105c55 <trap+0x75>
    yield();
80105d0a:	e8 31 e3 ff ff       	call   80104040 <yield>
80105d0f:	e9 41 ff ff ff       	jmp    80105c55 <trap+0x75>
80105d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d18:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d1b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105d1f:	e8 8c dc ff ff       	call   801039b0 <cpuid>
80105d24:	57                   	push   %edi
80105d25:	56                   	push   %esi
80105d26:	50                   	push   %eax
80105d27:	68 d4 7a 10 80       	push   $0x80107ad4
80105d2c:	e8 7f a9 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105d31:	e8 0a cc ff ff       	call   80102940 <lapiceoi>
    break;
80105d36:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d39:	e8 92 dc ff ff       	call   801039d0 <myproc>
80105d3e:	85 c0                	test   %eax,%eax
80105d40:	0f 85 dd fe ff ff    	jne    80105c23 <trap+0x43>
80105d46:	e9 f2 fe ff ff       	jmp    80105c3d <trap+0x5d>
80105d4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d50:	e8 7b dc ff ff       	call   801039d0 <myproc>
80105d55:	8b 70 24             	mov    0x24(%eax),%esi
80105d58:	85 f6                	test   %esi,%esi
80105d5a:	0f 85 c8 00 00 00    	jne    80105e28 <trap+0x248>
    myproc()->tf = tf;
80105d60:	e8 6b dc ff ff       	call   801039d0 <myproc>
80105d65:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d68:	e8 33 ef ff ff       	call   80104ca0 <syscall>
    if(myproc()->killed)
80105d6d:	e8 5e dc ff ff       	call   801039d0 <myproc>
80105d72:	8b 48 24             	mov    0x24(%eax),%ecx
80105d75:	85 c9                	test   %ecx,%ecx
80105d77:	0f 84 fb fe ff ff    	je     80105c78 <trap+0x98>
}
80105d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d80:	5b                   	pop    %ebx
80105d81:	5e                   	pop    %esi
80105d82:	5f                   	pop    %edi
80105d83:	5d                   	pop    %ebp
      exit();
80105d84:	e9 57 e0 ff ff       	jmp    80103de0 <exit>
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d90:	e8 4b 02 00 00       	call   80105fe0 <uartintr>
    lapiceoi();
80105d95:	e8 a6 cb ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d9a:	e8 31 dc ff ff       	call   801039d0 <myproc>
80105d9f:	85 c0                	test   %eax,%eax
80105da1:	0f 85 7c fe ff ff    	jne    80105c23 <trap+0x43>
80105da7:	e9 91 fe ff ff       	jmp    80105c3d <trap+0x5d>
80105dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105db0:	e8 5b ca ff ff       	call   80102810 <kbdintr>
    lapiceoi();
80105db5:	e8 86 cb ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dba:	e8 11 dc ff ff       	call   801039d0 <myproc>
80105dbf:	85 c0                	test   %eax,%eax
80105dc1:	0f 85 5c fe ff ff    	jne    80105c23 <trap+0x43>
80105dc7:	e9 71 fe ff ff       	jmp    80105c3d <trap+0x5d>
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105dd0:	e8 db db ff ff       	call   801039b0 <cpuid>
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	0f 85 38 fe ff ff    	jne    80105c15 <trap+0x35>
      acquire(&tickslock);
80105ddd:	83 ec 0c             	sub    $0xc,%esp
80105de0:	68 a0 3a 11 80       	push   $0x80113aa0
80105de5:	e8 e6 e8 ff ff       	call   801046d0 <acquire>
      ticks++;
80105dea:	83 05 80 3a 11 80 01 	addl   $0x1,0x80113a80
      wakeup(&ticks);
80105df1:	c7 04 24 80 3a 11 80 	movl   $0x80113a80,(%esp)
80105df8:	e8 53 e3 ff ff       	call   80104150 <wakeup>
      release(&tickslock);
80105dfd:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80105e04:	e8 67 e8 ff ff       	call   80104670 <release>
80105e09:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105e0c:	e9 04 fe ff ff       	jmp    80105c15 <trap+0x35>
80105e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105e18:	e8 c3 df ff ff       	call   80103de0 <exit>
80105e1d:	e9 1b fe ff ff       	jmp    80105c3d <trap+0x5d>
80105e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e28:	e8 b3 df ff ff       	call   80103de0 <exit>
80105e2d:	e9 2e ff ff ff       	jmp    80105d60 <trap+0x180>
80105e32:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e35:	e8 76 db ff ff       	call   801039b0 <cpuid>
80105e3a:	83 ec 0c             	sub    $0xc,%esp
80105e3d:	56                   	push   %esi
80105e3e:	57                   	push   %edi
80105e3f:	50                   	push   %eax
80105e40:	ff 73 30             	push   0x30(%ebx)
80105e43:	68 f8 7a 10 80       	push   $0x80107af8
80105e48:	e8 63 a8 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105e4d:	83 c4 14             	add    $0x14,%esp
80105e50:	68 56 78 10 80       	push   $0x80107856
80105e55:	e8 26 a5 ff ff       	call   80100380 <panic>
80105e5a:	66 90                	xchg   %ax,%ax
80105e5c:	66 90                	xchg   %ax,%ax
80105e5e:	66 90                	xchg   %ax,%ax

80105e60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e60:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80105e65:	85 c0                	test   %eax,%eax
80105e67:	74 17                	je     80105e80 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e69:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e6e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e6f:	a8 01                	test   $0x1,%al
80105e71:	74 0d                	je     80105e80 <uartgetc+0x20>
80105e73:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e78:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e79:	0f b6 c0             	movzbl %al,%eax
80105e7c:	c3                   	ret
80105e7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e85:	c3                   	ret
80105e86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e8d:	00 
80105e8e:	66 90                	xchg   %ax,%ax

80105e90 <uartinit>:
{
80105e90:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e91:	31 c9                	xor    %ecx,%ecx
80105e93:	89 c8                	mov    %ecx,%eax
80105e95:	89 e5                	mov    %esp,%ebp
80105e97:	57                   	push   %edi
80105e98:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e9d:	56                   	push   %esi
80105e9e:	89 fa                	mov    %edi,%edx
80105ea0:	53                   	push   %ebx
80105ea1:	83 ec 1c             	sub    $0x1c,%esp
80105ea4:	ee                   	out    %al,(%dx)
80105ea5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105eaa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105eaf:	89 f2                	mov    %esi,%edx
80105eb1:	ee                   	out    %al,(%dx)
80105eb2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105eb7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ebc:	ee                   	out    %al,(%dx)
80105ebd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105ec2:	89 c8                	mov    %ecx,%eax
80105ec4:	89 da                	mov    %ebx,%edx
80105ec6:	ee                   	out    %al,(%dx)
80105ec7:	b8 03 00 00 00       	mov    $0x3,%eax
80105ecc:	89 f2                	mov    %esi,%edx
80105ece:	ee                   	out    %al,(%dx)
80105ecf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ed4:	89 c8                	mov    %ecx,%eax
80105ed6:	ee                   	out    %al,(%dx)
80105ed7:	b8 01 00 00 00       	mov    $0x1,%eax
80105edc:	89 da                	mov    %ebx,%edx
80105ede:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105edf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ee4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ee5:	3c ff                	cmp    $0xff,%al
80105ee7:	0f 84 7c 00 00 00    	je     80105f69 <uartinit+0xd9>
  uart = 1;
80105eed:	c7 05 e0 42 11 80 01 	movl   $0x1,0x801142e0
80105ef4:	00 00 00 
80105ef7:	89 fa                	mov    %edi,%edx
80105ef9:	ec                   	in     (%dx),%al
80105efa:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eff:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f00:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f03:	bf 5b 78 10 80       	mov    $0x8010785b,%edi
80105f08:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105f0d:	6a 00                	push   $0x0
80105f0f:	6a 04                	push   $0x4
80105f11:	e8 9a c5 ff ff       	call   801024b0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105f16:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105f1a:	83 c4 10             	add    $0x10,%esp
80105f1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105f20:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80105f25:	85 c0                	test   %eax,%eax
80105f27:	74 32                	je     80105f5b <uartinit+0xcb>
80105f29:	89 f2                	mov    %esi,%edx
80105f2b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f2c:	a8 20                	test   $0x20,%al
80105f2e:	75 21                	jne    80105f51 <uartinit+0xc1>
80105f30:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f35:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105f38:	83 ec 0c             	sub    $0xc,%esp
80105f3b:	6a 0a                	push   $0xa
80105f3d:	e8 1e ca ff ff       	call   80102960 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f42:	83 c4 10             	add    $0x10,%esp
80105f45:	83 eb 01             	sub    $0x1,%ebx
80105f48:	74 07                	je     80105f51 <uartinit+0xc1>
80105f4a:	89 f2                	mov    %esi,%edx
80105f4c:	ec                   	in     (%dx),%al
80105f4d:	a8 20                	test   $0x20,%al
80105f4f:	74 e7                	je     80105f38 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f51:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f56:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105f5a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105f5b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105f5f:	83 c7 01             	add    $0x1,%edi
80105f62:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f65:	84 c0                	test   %al,%al
80105f67:	75 b7                	jne    80105f20 <uartinit+0x90>
}
80105f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f6c:	5b                   	pop    %ebx
80105f6d:	5e                   	pop    %esi
80105f6e:	5f                   	pop    %edi
80105f6f:	5d                   	pop    %ebp
80105f70:	c3                   	ret
80105f71:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f78:	00 
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f80 <uartputc>:
  if(!uart)
80105f80:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80105f85:	85 c0                	test   %eax,%eax
80105f87:	74 4f                	je     80105fd8 <uartputc+0x58>
{
80105f89:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f8a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f8f:	89 e5                	mov    %esp,%ebp
80105f91:	56                   	push   %esi
80105f92:	53                   	push   %ebx
80105f93:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f94:	a8 20                	test   $0x20,%al
80105f96:	75 29                	jne    80105fc1 <uartputc+0x41>
80105f98:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105fa8:	83 ec 0c             	sub    $0xc,%esp
80105fab:	6a 0a                	push   $0xa
80105fad:	e8 ae c9 ff ff       	call   80102960 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	83 eb 01             	sub    $0x1,%ebx
80105fb8:	74 07                	je     80105fc1 <uartputc+0x41>
80105fba:	89 f2                	mov    %esi,%edx
80105fbc:	ec                   	in     (%dx),%al
80105fbd:	a8 20                	test   $0x20,%al
80105fbf:	74 e7                	je     80105fa8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80105fc4:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fc9:	ee                   	out    %al,(%dx)
}
80105fca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fcd:	5b                   	pop    %ebx
80105fce:	5e                   	pop    %esi
80105fcf:	5d                   	pop    %ebp
80105fd0:	c3                   	ret
80105fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fd8:	c3                   	ret
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fe0 <uartintr>:

void
uartintr(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fe6:	68 60 5e 10 80       	push   $0x80105e60
80105feb:	e8 b0 a8 ff ff       	call   801008a0 <consoleintr>
}
80105ff0:	83 c4 10             	add    $0x10,%esp
80105ff3:	c9                   	leave
80105ff4:	c3                   	ret

80105ff5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $0
80105ff7:	6a 00                	push   $0x0
  jmp alltraps
80105ff9:	e9 07 fb ff ff       	jmp    80105b05 <alltraps>

80105ffe <vector1>:
.globl vector1
vector1:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $1
80106000:	6a 01                	push   $0x1
  jmp alltraps
80106002:	e9 fe fa ff ff       	jmp    80105b05 <alltraps>

80106007 <vector2>:
.globl vector2
vector2:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $2
80106009:	6a 02                	push   $0x2
  jmp alltraps
8010600b:	e9 f5 fa ff ff       	jmp    80105b05 <alltraps>

80106010 <vector3>:
.globl vector3
vector3:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $3
80106012:	6a 03                	push   $0x3
  jmp alltraps
80106014:	e9 ec fa ff ff       	jmp    80105b05 <alltraps>

80106019 <vector4>:
.globl vector4
vector4:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $4
8010601b:	6a 04                	push   $0x4
  jmp alltraps
8010601d:	e9 e3 fa ff ff       	jmp    80105b05 <alltraps>

80106022 <vector5>:
.globl vector5
vector5:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $5
80106024:	6a 05                	push   $0x5
  jmp alltraps
80106026:	e9 da fa ff ff       	jmp    80105b05 <alltraps>

8010602b <vector6>:
.globl vector6
vector6:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $6
8010602d:	6a 06                	push   $0x6
  jmp alltraps
8010602f:	e9 d1 fa ff ff       	jmp    80105b05 <alltraps>

80106034 <vector7>:
.globl vector7
vector7:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $7
80106036:	6a 07                	push   $0x7
  jmp alltraps
80106038:	e9 c8 fa ff ff       	jmp    80105b05 <alltraps>

8010603d <vector8>:
.globl vector8
vector8:
  pushl $8
8010603d:	6a 08                	push   $0x8
  jmp alltraps
8010603f:	e9 c1 fa ff ff       	jmp    80105b05 <alltraps>

80106044 <vector9>:
.globl vector9
vector9:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $9
80106046:	6a 09                	push   $0x9
  jmp alltraps
80106048:	e9 b8 fa ff ff       	jmp    80105b05 <alltraps>

8010604d <vector10>:
.globl vector10
vector10:
  pushl $10
8010604d:	6a 0a                	push   $0xa
  jmp alltraps
8010604f:	e9 b1 fa ff ff       	jmp    80105b05 <alltraps>

80106054 <vector11>:
.globl vector11
vector11:
  pushl $11
80106054:	6a 0b                	push   $0xb
  jmp alltraps
80106056:	e9 aa fa ff ff       	jmp    80105b05 <alltraps>

8010605b <vector12>:
.globl vector12
vector12:
  pushl $12
8010605b:	6a 0c                	push   $0xc
  jmp alltraps
8010605d:	e9 a3 fa ff ff       	jmp    80105b05 <alltraps>

80106062 <vector13>:
.globl vector13
vector13:
  pushl $13
80106062:	6a 0d                	push   $0xd
  jmp alltraps
80106064:	e9 9c fa ff ff       	jmp    80105b05 <alltraps>

80106069 <vector14>:
.globl vector14
vector14:
  pushl $14
80106069:	6a 0e                	push   $0xe
  jmp alltraps
8010606b:	e9 95 fa ff ff       	jmp    80105b05 <alltraps>

80106070 <vector15>:
.globl vector15
vector15:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $15
80106072:	6a 0f                	push   $0xf
  jmp alltraps
80106074:	e9 8c fa ff ff       	jmp    80105b05 <alltraps>

80106079 <vector16>:
.globl vector16
vector16:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $16
8010607b:	6a 10                	push   $0x10
  jmp alltraps
8010607d:	e9 83 fa ff ff       	jmp    80105b05 <alltraps>

80106082 <vector17>:
.globl vector17
vector17:
  pushl $17
80106082:	6a 11                	push   $0x11
  jmp alltraps
80106084:	e9 7c fa ff ff       	jmp    80105b05 <alltraps>

80106089 <vector18>:
.globl vector18
vector18:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $18
8010608b:	6a 12                	push   $0x12
  jmp alltraps
8010608d:	e9 73 fa ff ff       	jmp    80105b05 <alltraps>

80106092 <vector19>:
.globl vector19
vector19:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $19
80106094:	6a 13                	push   $0x13
  jmp alltraps
80106096:	e9 6a fa ff ff       	jmp    80105b05 <alltraps>

8010609b <vector20>:
.globl vector20
vector20:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $20
8010609d:	6a 14                	push   $0x14
  jmp alltraps
8010609f:	e9 61 fa ff ff       	jmp    80105b05 <alltraps>

801060a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $21
801060a6:	6a 15                	push   $0x15
  jmp alltraps
801060a8:	e9 58 fa ff ff       	jmp    80105b05 <alltraps>

801060ad <vector22>:
.globl vector22
vector22:
  pushl $0
801060ad:	6a 00                	push   $0x0
  pushl $22
801060af:	6a 16                	push   $0x16
  jmp alltraps
801060b1:	e9 4f fa ff ff       	jmp    80105b05 <alltraps>

801060b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $23
801060b8:	6a 17                	push   $0x17
  jmp alltraps
801060ba:	e9 46 fa ff ff       	jmp    80105b05 <alltraps>

801060bf <vector24>:
.globl vector24
vector24:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $24
801060c1:	6a 18                	push   $0x18
  jmp alltraps
801060c3:	e9 3d fa ff ff       	jmp    80105b05 <alltraps>

801060c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801060c8:	6a 00                	push   $0x0
  pushl $25
801060ca:	6a 19                	push   $0x19
  jmp alltraps
801060cc:	e9 34 fa ff ff       	jmp    80105b05 <alltraps>

801060d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801060d1:	6a 00                	push   $0x0
  pushl $26
801060d3:	6a 1a                	push   $0x1a
  jmp alltraps
801060d5:	e9 2b fa ff ff       	jmp    80105b05 <alltraps>

801060da <vector27>:
.globl vector27
vector27:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $27
801060dc:	6a 1b                	push   $0x1b
  jmp alltraps
801060de:	e9 22 fa ff ff       	jmp    80105b05 <alltraps>

801060e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $28
801060e5:	6a 1c                	push   $0x1c
  jmp alltraps
801060e7:	e9 19 fa ff ff       	jmp    80105b05 <alltraps>

801060ec <vector29>:
.globl vector29
vector29:
  pushl $0
801060ec:	6a 00                	push   $0x0
  pushl $29
801060ee:	6a 1d                	push   $0x1d
  jmp alltraps
801060f0:	e9 10 fa ff ff       	jmp    80105b05 <alltraps>

801060f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $30
801060f7:	6a 1e                	push   $0x1e
  jmp alltraps
801060f9:	e9 07 fa ff ff       	jmp    80105b05 <alltraps>

801060fe <vector31>:
.globl vector31
vector31:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $31
80106100:	6a 1f                	push   $0x1f
  jmp alltraps
80106102:	e9 fe f9 ff ff       	jmp    80105b05 <alltraps>

80106107 <vector32>:
.globl vector32
vector32:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $32
80106109:	6a 20                	push   $0x20
  jmp alltraps
8010610b:	e9 f5 f9 ff ff       	jmp    80105b05 <alltraps>

80106110 <vector33>:
.globl vector33
vector33:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $33
80106112:	6a 21                	push   $0x21
  jmp alltraps
80106114:	e9 ec f9 ff ff       	jmp    80105b05 <alltraps>

80106119 <vector34>:
.globl vector34
vector34:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $34
8010611b:	6a 22                	push   $0x22
  jmp alltraps
8010611d:	e9 e3 f9 ff ff       	jmp    80105b05 <alltraps>

80106122 <vector35>:
.globl vector35
vector35:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $35
80106124:	6a 23                	push   $0x23
  jmp alltraps
80106126:	e9 da f9 ff ff       	jmp    80105b05 <alltraps>

8010612b <vector36>:
.globl vector36
vector36:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $36
8010612d:	6a 24                	push   $0x24
  jmp alltraps
8010612f:	e9 d1 f9 ff ff       	jmp    80105b05 <alltraps>

80106134 <vector37>:
.globl vector37
vector37:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $37
80106136:	6a 25                	push   $0x25
  jmp alltraps
80106138:	e9 c8 f9 ff ff       	jmp    80105b05 <alltraps>

8010613d <vector38>:
.globl vector38
vector38:
  pushl $0
8010613d:	6a 00                	push   $0x0
  pushl $38
8010613f:	6a 26                	push   $0x26
  jmp alltraps
80106141:	e9 bf f9 ff ff       	jmp    80105b05 <alltraps>

80106146 <vector39>:
.globl vector39
vector39:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $39
80106148:	6a 27                	push   $0x27
  jmp alltraps
8010614a:	e9 b6 f9 ff ff       	jmp    80105b05 <alltraps>

8010614f <vector40>:
.globl vector40
vector40:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $40
80106151:	6a 28                	push   $0x28
  jmp alltraps
80106153:	e9 ad f9 ff ff       	jmp    80105b05 <alltraps>

80106158 <vector41>:
.globl vector41
vector41:
  pushl $0
80106158:	6a 00                	push   $0x0
  pushl $41
8010615a:	6a 29                	push   $0x29
  jmp alltraps
8010615c:	e9 a4 f9 ff ff       	jmp    80105b05 <alltraps>

80106161 <vector42>:
.globl vector42
vector42:
  pushl $0
80106161:	6a 00                	push   $0x0
  pushl $42
80106163:	6a 2a                	push   $0x2a
  jmp alltraps
80106165:	e9 9b f9 ff ff       	jmp    80105b05 <alltraps>

8010616a <vector43>:
.globl vector43
vector43:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $43
8010616c:	6a 2b                	push   $0x2b
  jmp alltraps
8010616e:	e9 92 f9 ff ff       	jmp    80105b05 <alltraps>

80106173 <vector44>:
.globl vector44
vector44:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $44
80106175:	6a 2c                	push   $0x2c
  jmp alltraps
80106177:	e9 89 f9 ff ff       	jmp    80105b05 <alltraps>

8010617c <vector45>:
.globl vector45
vector45:
  pushl $0
8010617c:	6a 00                	push   $0x0
  pushl $45
8010617e:	6a 2d                	push   $0x2d
  jmp alltraps
80106180:	e9 80 f9 ff ff       	jmp    80105b05 <alltraps>

80106185 <vector46>:
.globl vector46
vector46:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $46
80106187:	6a 2e                	push   $0x2e
  jmp alltraps
80106189:	e9 77 f9 ff ff       	jmp    80105b05 <alltraps>

8010618e <vector47>:
.globl vector47
vector47:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $47
80106190:	6a 2f                	push   $0x2f
  jmp alltraps
80106192:	e9 6e f9 ff ff       	jmp    80105b05 <alltraps>

80106197 <vector48>:
.globl vector48
vector48:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $48
80106199:	6a 30                	push   $0x30
  jmp alltraps
8010619b:	e9 65 f9 ff ff       	jmp    80105b05 <alltraps>

801061a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $49
801061a2:	6a 31                	push   $0x31
  jmp alltraps
801061a4:	e9 5c f9 ff ff       	jmp    80105b05 <alltraps>

801061a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $50
801061ab:	6a 32                	push   $0x32
  jmp alltraps
801061ad:	e9 53 f9 ff ff       	jmp    80105b05 <alltraps>

801061b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $51
801061b4:	6a 33                	push   $0x33
  jmp alltraps
801061b6:	e9 4a f9 ff ff       	jmp    80105b05 <alltraps>

801061bb <vector52>:
.globl vector52
vector52:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $52
801061bd:	6a 34                	push   $0x34
  jmp alltraps
801061bf:	e9 41 f9 ff ff       	jmp    80105b05 <alltraps>

801061c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $53
801061c6:	6a 35                	push   $0x35
  jmp alltraps
801061c8:	e9 38 f9 ff ff       	jmp    80105b05 <alltraps>

801061cd <vector54>:
.globl vector54
vector54:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $54
801061cf:	6a 36                	push   $0x36
  jmp alltraps
801061d1:	e9 2f f9 ff ff       	jmp    80105b05 <alltraps>

801061d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $55
801061d8:	6a 37                	push   $0x37
  jmp alltraps
801061da:	e9 26 f9 ff ff       	jmp    80105b05 <alltraps>

801061df <vector56>:
.globl vector56
vector56:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $56
801061e1:	6a 38                	push   $0x38
  jmp alltraps
801061e3:	e9 1d f9 ff ff       	jmp    80105b05 <alltraps>

801061e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $57
801061ea:	6a 39                	push   $0x39
  jmp alltraps
801061ec:	e9 14 f9 ff ff       	jmp    80105b05 <alltraps>

801061f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $58
801061f3:	6a 3a                	push   $0x3a
  jmp alltraps
801061f5:	e9 0b f9 ff ff       	jmp    80105b05 <alltraps>

801061fa <vector59>:
.globl vector59
vector59:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $59
801061fc:	6a 3b                	push   $0x3b
  jmp alltraps
801061fe:	e9 02 f9 ff ff       	jmp    80105b05 <alltraps>

80106203 <vector60>:
.globl vector60
vector60:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $60
80106205:	6a 3c                	push   $0x3c
  jmp alltraps
80106207:	e9 f9 f8 ff ff       	jmp    80105b05 <alltraps>

8010620c <vector61>:
.globl vector61
vector61:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $61
8010620e:	6a 3d                	push   $0x3d
  jmp alltraps
80106210:	e9 f0 f8 ff ff       	jmp    80105b05 <alltraps>

80106215 <vector62>:
.globl vector62
vector62:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $62
80106217:	6a 3e                	push   $0x3e
  jmp alltraps
80106219:	e9 e7 f8 ff ff       	jmp    80105b05 <alltraps>

8010621e <vector63>:
.globl vector63
vector63:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $63
80106220:	6a 3f                	push   $0x3f
  jmp alltraps
80106222:	e9 de f8 ff ff       	jmp    80105b05 <alltraps>

80106227 <vector64>:
.globl vector64
vector64:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $64
80106229:	6a 40                	push   $0x40
  jmp alltraps
8010622b:	e9 d5 f8 ff ff       	jmp    80105b05 <alltraps>

80106230 <vector65>:
.globl vector65
vector65:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $65
80106232:	6a 41                	push   $0x41
  jmp alltraps
80106234:	e9 cc f8 ff ff       	jmp    80105b05 <alltraps>

80106239 <vector66>:
.globl vector66
vector66:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $66
8010623b:	6a 42                	push   $0x42
  jmp alltraps
8010623d:	e9 c3 f8 ff ff       	jmp    80105b05 <alltraps>

80106242 <vector67>:
.globl vector67
vector67:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $67
80106244:	6a 43                	push   $0x43
  jmp alltraps
80106246:	e9 ba f8 ff ff       	jmp    80105b05 <alltraps>

8010624b <vector68>:
.globl vector68
vector68:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $68
8010624d:	6a 44                	push   $0x44
  jmp alltraps
8010624f:	e9 b1 f8 ff ff       	jmp    80105b05 <alltraps>

80106254 <vector69>:
.globl vector69
vector69:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $69
80106256:	6a 45                	push   $0x45
  jmp alltraps
80106258:	e9 a8 f8 ff ff       	jmp    80105b05 <alltraps>

8010625d <vector70>:
.globl vector70
vector70:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $70
8010625f:	6a 46                	push   $0x46
  jmp alltraps
80106261:	e9 9f f8 ff ff       	jmp    80105b05 <alltraps>

80106266 <vector71>:
.globl vector71
vector71:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $71
80106268:	6a 47                	push   $0x47
  jmp alltraps
8010626a:	e9 96 f8 ff ff       	jmp    80105b05 <alltraps>

8010626f <vector72>:
.globl vector72
vector72:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $72
80106271:	6a 48                	push   $0x48
  jmp alltraps
80106273:	e9 8d f8 ff ff       	jmp    80105b05 <alltraps>

80106278 <vector73>:
.globl vector73
vector73:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $73
8010627a:	6a 49                	push   $0x49
  jmp alltraps
8010627c:	e9 84 f8 ff ff       	jmp    80105b05 <alltraps>

80106281 <vector74>:
.globl vector74
vector74:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $74
80106283:	6a 4a                	push   $0x4a
  jmp alltraps
80106285:	e9 7b f8 ff ff       	jmp    80105b05 <alltraps>

8010628a <vector75>:
.globl vector75
vector75:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $75
8010628c:	6a 4b                	push   $0x4b
  jmp alltraps
8010628e:	e9 72 f8 ff ff       	jmp    80105b05 <alltraps>

80106293 <vector76>:
.globl vector76
vector76:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $76
80106295:	6a 4c                	push   $0x4c
  jmp alltraps
80106297:	e9 69 f8 ff ff       	jmp    80105b05 <alltraps>

8010629c <vector77>:
.globl vector77
vector77:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $77
8010629e:	6a 4d                	push   $0x4d
  jmp alltraps
801062a0:	e9 60 f8 ff ff       	jmp    80105b05 <alltraps>

801062a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $78
801062a7:	6a 4e                	push   $0x4e
  jmp alltraps
801062a9:	e9 57 f8 ff ff       	jmp    80105b05 <alltraps>

801062ae <vector79>:
.globl vector79
vector79:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $79
801062b0:	6a 4f                	push   $0x4f
  jmp alltraps
801062b2:	e9 4e f8 ff ff       	jmp    80105b05 <alltraps>

801062b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $80
801062b9:	6a 50                	push   $0x50
  jmp alltraps
801062bb:	e9 45 f8 ff ff       	jmp    80105b05 <alltraps>

801062c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $81
801062c2:	6a 51                	push   $0x51
  jmp alltraps
801062c4:	e9 3c f8 ff ff       	jmp    80105b05 <alltraps>

801062c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $82
801062cb:	6a 52                	push   $0x52
  jmp alltraps
801062cd:	e9 33 f8 ff ff       	jmp    80105b05 <alltraps>

801062d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $83
801062d4:	6a 53                	push   $0x53
  jmp alltraps
801062d6:	e9 2a f8 ff ff       	jmp    80105b05 <alltraps>

801062db <vector84>:
.globl vector84
vector84:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $84
801062dd:	6a 54                	push   $0x54
  jmp alltraps
801062df:	e9 21 f8 ff ff       	jmp    80105b05 <alltraps>

801062e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $85
801062e6:	6a 55                	push   $0x55
  jmp alltraps
801062e8:	e9 18 f8 ff ff       	jmp    80105b05 <alltraps>

801062ed <vector86>:
.globl vector86
vector86:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $86
801062ef:	6a 56                	push   $0x56
  jmp alltraps
801062f1:	e9 0f f8 ff ff       	jmp    80105b05 <alltraps>

801062f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $87
801062f8:	6a 57                	push   $0x57
  jmp alltraps
801062fa:	e9 06 f8 ff ff       	jmp    80105b05 <alltraps>

801062ff <vector88>:
.globl vector88
vector88:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $88
80106301:	6a 58                	push   $0x58
  jmp alltraps
80106303:	e9 fd f7 ff ff       	jmp    80105b05 <alltraps>

80106308 <vector89>:
.globl vector89
vector89:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $89
8010630a:	6a 59                	push   $0x59
  jmp alltraps
8010630c:	e9 f4 f7 ff ff       	jmp    80105b05 <alltraps>

80106311 <vector90>:
.globl vector90
vector90:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $90
80106313:	6a 5a                	push   $0x5a
  jmp alltraps
80106315:	e9 eb f7 ff ff       	jmp    80105b05 <alltraps>

8010631a <vector91>:
.globl vector91
vector91:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $91
8010631c:	6a 5b                	push   $0x5b
  jmp alltraps
8010631e:	e9 e2 f7 ff ff       	jmp    80105b05 <alltraps>

80106323 <vector92>:
.globl vector92
vector92:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $92
80106325:	6a 5c                	push   $0x5c
  jmp alltraps
80106327:	e9 d9 f7 ff ff       	jmp    80105b05 <alltraps>

8010632c <vector93>:
.globl vector93
vector93:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $93
8010632e:	6a 5d                	push   $0x5d
  jmp alltraps
80106330:	e9 d0 f7 ff ff       	jmp    80105b05 <alltraps>

80106335 <vector94>:
.globl vector94
vector94:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $94
80106337:	6a 5e                	push   $0x5e
  jmp alltraps
80106339:	e9 c7 f7 ff ff       	jmp    80105b05 <alltraps>

8010633e <vector95>:
.globl vector95
vector95:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $95
80106340:	6a 5f                	push   $0x5f
  jmp alltraps
80106342:	e9 be f7 ff ff       	jmp    80105b05 <alltraps>

80106347 <vector96>:
.globl vector96
vector96:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $96
80106349:	6a 60                	push   $0x60
  jmp alltraps
8010634b:	e9 b5 f7 ff ff       	jmp    80105b05 <alltraps>

80106350 <vector97>:
.globl vector97
vector97:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $97
80106352:	6a 61                	push   $0x61
  jmp alltraps
80106354:	e9 ac f7 ff ff       	jmp    80105b05 <alltraps>

80106359 <vector98>:
.globl vector98
vector98:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $98
8010635b:	6a 62                	push   $0x62
  jmp alltraps
8010635d:	e9 a3 f7 ff ff       	jmp    80105b05 <alltraps>

80106362 <vector99>:
.globl vector99
vector99:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $99
80106364:	6a 63                	push   $0x63
  jmp alltraps
80106366:	e9 9a f7 ff ff       	jmp    80105b05 <alltraps>

8010636b <vector100>:
.globl vector100
vector100:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $100
8010636d:	6a 64                	push   $0x64
  jmp alltraps
8010636f:	e9 91 f7 ff ff       	jmp    80105b05 <alltraps>

80106374 <vector101>:
.globl vector101
vector101:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $101
80106376:	6a 65                	push   $0x65
  jmp alltraps
80106378:	e9 88 f7 ff ff       	jmp    80105b05 <alltraps>

8010637d <vector102>:
.globl vector102
vector102:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $102
8010637f:	6a 66                	push   $0x66
  jmp alltraps
80106381:	e9 7f f7 ff ff       	jmp    80105b05 <alltraps>

80106386 <vector103>:
.globl vector103
vector103:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $103
80106388:	6a 67                	push   $0x67
  jmp alltraps
8010638a:	e9 76 f7 ff ff       	jmp    80105b05 <alltraps>

8010638f <vector104>:
.globl vector104
vector104:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $104
80106391:	6a 68                	push   $0x68
  jmp alltraps
80106393:	e9 6d f7 ff ff       	jmp    80105b05 <alltraps>

80106398 <vector105>:
.globl vector105
vector105:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $105
8010639a:	6a 69                	push   $0x69
  jmp alltraps
8010639c:	e9 64 f7 ff ff       	jmp    80105b05 <alltraps>

801063a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $106
801063a3:	6a 6a                	push   $0x6a
  jmp alltraps
801063a5:	e9 5b f7 ff ff       	jmp    80105b05 <alltraps>

801063aa <vector107>:
.globl vector107
vector107:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $107
801063ac:	6a 6b                	push   $0x6b
  jmp alltraps
801063ae:	e9 52 f7 ff ff       	jmp    80105b05 <alltraps>

801063b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $108
801063b5:	6a 6c                	push   $0x6c
  jmp alltraps
801063b7:	e9 49 f7 ff ff       	jmp    80105b05 <alltraps>

801063bc <vector109>:
.globl vector109
vector109:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $109
801063be:	6a 6d                	push   $0x6d
  jmp alltraps
801063c0:	e9 40 f7 ff ff       	jmp    80105b05 <alltraps>

801063c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $110
801063c7:	6a 6e                	push   $0x6e
  jmp alltraps
801063c9:	e9 37 f7 ff ff       	jmp    80105b05 <alltraps>

801063ce <vector111>:
.globl vector111
vector111:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $111
801063d0:	6a 6f                	push   $0x6f
  jmp alltraps
801063d2:	e9 2e f7 ff ff       	jmp    80105b05 <alltraps>

801063d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $112
801063d9:	6a 70                	push   $0x70
  jmp alltraps
801063db:	e9 25 f7 ff ff       	jmp    80105b05 <alltraps>

801063e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $113
801063e2:	6a 71                	push   $0x71
  jmp alltraps
801063e4:	e9 1c f7 ff ff       	jmp    80105b05 <alltraps>

801063e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $114
801063eb:	6a 72                	push   $0x72
  jmp alltraps
801063ed:	e9 13 f7 ff ff       	jmp    80105b05 <alltraps>

801063f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $115
801063f4:	6a 73                	push   $0x73
  jmp alltraps
801063f6:	e9 0a f7 ff ff       	jmp    80105b05 <alltraps>

801063fb <vector116>:
.globl vector116
vector116:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $116
801063fd:	6a 74                	push   $0x74
  jmp alltraps
801063ff:	e9 01 f7 ff ff       	jmp    80105b05 <alltraps>

80106404 <vector117>:
.globl vector117
vector117:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $117
80106406:	6a 75                	push   $0x75
  jmp alltraps
80106408:	e9 f8 f6 ff ff       	jmp    80105b05 <alltraps>

8010640d <vector118>:
.globl vector118
vector118:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $118
8010640f:	6a 76                	push   $0x76
  jmp alltraps
80106411:	e9 ef f6 ff ff       	jmp    80105b05 <alltraps>

80106416 <vector119>:
.globl vector119
vector119:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $119
80106418:	6a 77                	push   $0x77
  jmp alltraps
8010641a:	e9 e6 f6 ff ff       	jmp    80105b05 <alltraps>

8010641f <vector120>:
.globl vector120
vector120:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $120
80106421:	6a 78                	push   $0x78
  jmp alltraps
80106423:	e9 dd f6 ff ff       	jmp    80105b05 <alltraps>

80106428 <vector121>:
.globl vector121
vector121:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $121
8010642a:	6a 79                	push   $0x79
  jmp alltraps
8010642c:	e9 d4 f6 ff ff       	jmp    80105b05 <alltraps>

80106431 <vector122>:
.globl vector122
vector122:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $122
80106433:	6a 7a                	push   $0x7a
  jmp alltraps
80106435:	e9 cb f6 ff ff       	jmp    80105b05 <alltraps>

8010643a <vector123>:
.globl vector123
vector123:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $123
8010643c:	6a 7b                	push   $0x7b
  jmp alltraps
8010643e:	e9 c2 f6 ff ff       	jmp    80105b05 <alltraps>

80106443 <vector124>:
.globl vector124
vector124:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $124
80106445:	6a 7c                	push   $0x7c
  jmp alltraps
80106447:	e9 b9 f6 ff ff       	jmp    80105b05 <alltraps>

8010644c <vector125>:
.globl vector125
vector125:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $125
8010644e:	6a 7d                	push   $0x7d
  jmp alltraps
80106450:	e9 b0 f6 ff ff       	jmp    80105b05 <alltraps>

80106455 <vector126>:
.globl vector126
vector126:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $126
80106457:	6a 7e                	push   $0x7e
  jmp alltraps
80106459:	e9 a7 f6 ff ff       	jmp    80105b05 <alltraps>

8010645e <vector127>:
.globl vector127
vector127:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $127
80106460:	6a 7f                	push   $0x7f
  jmp alltraps
80106462:	e9 9e f6 ff ff       	jmp    80105b05 <alltraps>

80106467 <vector128>:
.globl vector128
vector128:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $128
80106469:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010646e:	e9 92 f6 ff ff       	jmp    80105b05 <alltraps>

80106473 <vector129>:
.globl vector129
vector129:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $129
80106475:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010647a:	e9 86 f6 ff ff       	jmp    80105b05 <alltraps>

8010647f <vector130>:
.globl vector130
vector130:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $130
80106481:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106486:	e9 7a f6 ff ff       	jmp    80105b05 <alltraps>

8010648b <vector131>:
.globl vector131
vector131:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $131
8010648d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106492:	e9 6e f6 ff ff       	jmp    80105b05 <alltraps>

80106497 <vector132>:
.globl vector132
vector132:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $132
80106499:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010649e:	e9 62 f6 ff ff       	jmp    80105b05 <alltraps>

801064a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $133
801064a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064aa:	e9 56 f6 ff ff       	jmp    80105b05 <alltraps>

801064af <vector134>:
.globl vector134
vector134:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $134
801064b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064b6:	e9 4a f6 ff ff       	jmp    80105b05 <alltraps>

801064bb <vector135>:
.globl vector135
vector135:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $135
801064bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064c2:	e9 3e f6 ff ff       	jmp    80105b05 <alltraps>

801064c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $136
801064c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064ce:	e9 32 f6 ff ff       	jmp    80105b05 <alltraps>

801064d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $137
801064d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801064da:	e9 26 f6 ff ff       	jmp    80105b05 <alltraps>

801064df <vector138>:
.globl vector138
vector138:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $138
801064e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064e6:	e9 1a f6 ff ff       	jmp    80105b05 <alltraps>

801064eb <vector139>:
.globl vector139
vector139:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $139
801064ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064f2:	e9 0e f6 ff ff       	jmp    80105b05 <alltraps>

801064f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $140
801064f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064fe:	e9 02 f6 ff ff       	jmp    80105b05 <alltraps>

80106503 <vector141>:
.globl vector141
vector141:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $141
80106505:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010650a:	e9 f6 f5 ff ff       	jmp    80105b05 <alltraps>

8010650f <vector142>:
.globl vector142
vector142:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $142
80106511:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106516:	e9 ea f5 ff ff       	jmp    80105b05 <alltraps>

8010651b <vector143>:
.globl vector143
vector143:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $143
8010651d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106522:	e9 de f5 ff ff       	jmp    80105b05 <alltraps>

80106527 <vector144>:
.globl vector144
vector144:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $144
80106529:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010652e:	e9 d2 f5 ff ff       	jmp    80105b05 <alltraps>

80106533 <vector145>:
.globl vector145
vector145:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $145
80106535:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010653a:	e9 c6 f5 ff ff       	jmp    80105b05 <alltraps>

8010653f <vector146>:
.globl vector146
vector146:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $146
80106541:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106546:	e9 ba f5 ff ff       	jmp    80105b05 <alltraps>

8010654b <vector147>:
.globl vector147
vector147:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $147
8010654d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106552:	e9 ae f5 ff ff       	jmp    80105b05 <alltraps>

80106557 <vector148>:
.globl vector148
vector148:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $148
80106559:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010655e:	e9 a2 f5 ff ff       	jmp    80105b05 <alltraps>

80106563 <vector149>:
.globl vector149
vector149:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $149
80106565:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010656a:	e9 96 f5 ff ff       	jmp    80105b05 <alltraps>

8010656f <vector150>:
.globl vector150
vector150:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $150
80106571:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106576:	e9 8a f5 ff ff       	jmp    80105b05 <alltraps>

8010657b <vector151>:
.globl vector151
vector151:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $151
8010657d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106582:	e9 7e f5 ff ff       	jmp    80105b05 <alltraps>

80106587 <vector152>:
.globl vector152
vector152:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $152
80106589:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010658e:	e9 72 f5 ff ff       	jmp    80105b05 <alltraps>

80106593 <vector153>:
.globl vector153
vector153:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $153
80106595:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010659a:	e9 66 f5 ff ff       	jmp    80105b05 <alltraps>

8010659f <vector154>:
.globl vector154
vector154:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $154
801065a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065a6:	e9 5a f5 ff ff       	jmp    80105b05 <alltraps>

801065ab <vector155>:
.globl vector155
vector155:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $155
801065ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065b2:	e9 4e f5 ff ff       	jmp    80105b05 <alltraps>

801065b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $156
801065b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065be:	e9 42 f5 ff ff       	jmp    80105b05 <alltraps>

801065c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $157
801065c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065ca:	e9 36 f5 ff ff       	jmp    80105b05 <alltraps>

801065cf <vector158>:
.globl vector158
vector158:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $158
801065d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801065d6:	e9 2a f5 ff ff       	jmp    80105b05 <alltraps>

801065db <vector159>:
.globl vector159
vector159:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $159
801065dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065e2:	e9 1e f5 ff ff       	jmp    80105b05 <alltraps>

801065e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $160
801065e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065ee:	e9 12 f5 ff ff       	jmp    80105b05 <alltraps>

801065f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $161
801065f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065fa:	e9 06 f5 ff ff       	jmp    80105b05 <alltraps>

801065ff <vector162>:
.globl vector162
vector162:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $162
80106601:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106606:	e9 fa f4 ff ff       	jmp    80105b05 <alltraps>

8010660b <vector163>:
.globl vector163
vector163:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $163
8010660d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106612:	e9 ee f4 ff ff       	jmp    80105b05 <alltraps>

80106617 <vector164>:
.globl vector164
vector164:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $164
80106619:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010661e:	e9 e2 f4 ff ff       	jmp    80105b05 <alltraps>

80106623 <vector165>:
.globl vector165
vector165:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $165
80106625:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010662a:	e9 d6 f4 ff ff       	jmp    80105b05 <alltraps>

8010662f <vector166>:
.globl vector166
vector166:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $166
80106631:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106636:	e9 ca f4 ff ff       	jmp    80105b05 <alltraps>

8010663b <vector167>:
.globl vector167
vector167:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $167
8010663d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106642:	e9 be f4 ff ff       	jmp    80105b05 <alltraps>

80106647 <vector168>:
.globl vector168
vector168:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $168
80106649:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010664e:	e9 b2 f4 ff ff       	jmp    80105b05 <alltraps>

80106653 <vector169>:
.globl vector169
vector169:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $169
80106655:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010665a:	e9 a6 f4 ff ff       	jmp    80105b05 <alltraps>

8010665f <vector170>:
.globl vector170
vector170:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $170
80106661:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106666:	e9 9a f4 ff ff       	jmp    80105b05 <alltraps>

8010666b <vector171>:
.globl vector171
vector171:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $171
8010666d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106672:	e9 8e f4 ff ff       	jmp    80105b05 <alltraps>

80106677 <vector172>:
.globl vector172
vector172:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $172
80106679:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010667e:	e9 82 f4 ff ff       	jmp    80105b05 <alltraps>

80106683 <vector173>:
.globl vector173
vector173:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $173
80106685:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010668a:	e9 76 f4 ff ff       	jmp    80105b05 <alltraps>

8010668f <vector174>:
.globl vector174
vector174:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $174
80106691:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106696:	e9 6a f4 ff ff       	jmp    80105b05 <alltraps>

8010669b <vector175>:
.globl vector175
vector175:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $175
8010669d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066a2:	e9 5e f4 ff ff       	jmp    80105b05 <alltraps>

801066a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $176
801066a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066ae:	e9 52 f4 ff ff       	jmp    80105b05 <alltraps>

801066b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $177
801066b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066ba:	e9 46 f4 ff ff       	jmp    80105b05 <alltraps>

801066bf <vector178>:
.globl vector178
vector178:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $178
801066c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066c6:	e9 3a f4 ff ff       	jmp    80105b05 <alltraps>

801066cb <vector179>:
.globl vector179
vector179:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $179
801066cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801066d2:	e9 2e f4 ff ff       	jmp    80105b05 <alltraps>

801066d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $180
801066d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066de:	e9 22 f4 ff ff       	jmp    80105b05 <alltraps>

801066e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $181
801066e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066ea:	e9 16 f4 ff ff       	jmp    80105b05 <alltraps>

801066ef <vector182>:
.globl vector182
vector182:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $182
801066f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066f6:	e9 0a f4 ff ff       	jmp    80105b05 <alltraps>

801066fb <vector183>:
.globl vector183
vector183:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $183
801066fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106702:	e9 fe f3 ff ff       	jmp    80105b05 <alltraps>

80106707 <vector184>:
.globl vector184
vector184:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $184
80106709:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010670e:	e9 f2 f3 ff ff       	jmp    80105b05 <alltraps>

80106713 <vector185>:
.globl vector185
vector185:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $185
80106715:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010671a:	e9 e6 f3 ff ff       	jmp    80105b05 <alltraps>

8010671f <vector186>:
.globl vector186
vector186:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $186
80106721:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106726:	e9 da f3 ff ff       	jmp    80105b05 <alltraps>

8010672b <vector187>:
.globl vector187
vector187:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $187
8010672d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106732:	e9 ce f3 ff ff       	jmp    80105b05 <alltraps>

80106737 <vector188>:
.globl vector188
vector188:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $188
80106739:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010673e:	e9 c2 f3 ff ff       	jmp    80105b05 <alltraps>

80106743 <vector189>:
.globl vector189
vector189:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $189
80106745:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010674a:	e9 b6 f3 ff ff       	jmp    80105b05 <alltraps>

8010674f <vector190>:
.globl vector190
vector190:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $190
80106751:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106756:	e9 aa f3 ff ff       	jmp    80105b05 <alltraps>

8010675b <vector191>:
.globl vector191
vector191:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $191
8010675d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106762:	e9 9e f3 ff ff       	jmp    80105b05 <alltraps>

80106767 <vector192>:
.globl vector192
vector192:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $192
80106769:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010676e:	e9 92 f3 ff ff       	jmp    80105b05 <alltraps>

80106773 <vector193>:
.globl vector193
vector193:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $193
80106775:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010677a:	e9 86 f3 ff ff       	jmp    80105b05 <alltraps>

8010677f <vector194>:
.globl vector194
vector194:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $194
80106781:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106786:	e9 7a f3 ff ff       	jmp    80105b05 <alltraps>

8010678b <vector195>:
.globl vector195
vector195:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $195
8010678d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106792:	e9 6e f3 ff ff       	jmp    80105b05 <alltraps>

80106797 <vector196>:
.globl vector196
vector196:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $196
80106799:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010679e:	e9 62 f3 ff ff       	jmp    80105b05 <alltraps>

801067a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $197
801067a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067aa:	e9 56 f3 ff ff       	jmp    80105b05 <alltraps>

801067af <vector198>:
.globl vector198
vector198:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $198
801067b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067b6:	e9 4a f3 ff ff       	jmp    80105b05 <alltraps>

801067bb <vector199>:
.globl vector199
vector199:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $199
801067bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067c2:	e9 3e f3 ff ff       	jmp    80105b05 <alltraps>

801067c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $200
801067c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067ce:	e9 32 f3 ff ff       	jmp    80105b05 <alltraps>

801067d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $201
801067d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801067da:	e9 26 f3 ff ff       	jmp    80105b05 <alltraps>

801067df <vector202>:
.globl vector202
vector202:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $202
801067e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067e6:	e9 1a f3 ff ff       	jmp    80105b05 <alltraps>

801067eb <vector203>:
.globl vector203
vector203:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $203
801067ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067f2:	e9 0e f3 ff ff       	jmp    80105b05 <alltraps>

801067f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $204
801067f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067fe:	e9 02 f3 ff ff       	jmp    80105b05 <alltraps>

80106803 <vector205>:
.globl vector205
vector205:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $205
80106805:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010680a:	e9 f6 f2 ff ff       	jmp    80105b05 <alltraps>

8010680f <vector206>:
.globl vector206
vector206:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $206
80106811:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106816:	e9 ea f2 ff ff       	jmp    80105b05 <alltraps>

8010681b <vector207>:
.globl vector207
vector207:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $207
8010681d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106822:	e9 de f2 ff ff       	jmp    80105b05 <alltraps>

80106827 <vector208>:
.globl vector208
vector208:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $208
80106829:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010682e:	e9 d2 f2 ff ff       	jmp    80105b05 <alltraps>

80106833 <vector209>:
.globl vector209
vector209:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $209
80106835:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010683a:	e9 c6 f2 ff ff       	jmp    80105b05 <alltraps>

8010683f <vector210>:
.globl vector210
vector210:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $210
80106841:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106846:	e9 ba f2 ff ff       	jmp    80105b05 <alltraps>

8010684b <vector211>:
.globl vector211
vector211:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $211
8010684d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106852:	e9 ae f2 ff ff       	jmp    80105b05 <alltraps>

80106857 <vector212>:
.globl vector212
vector212:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $212
80106859:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010685e:	e9 a2 f2 ff ff       	jmp    80105b05 <alltraps>

80106863 <vector213>:
.globl vector213
vector213:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $213
80106865:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010686a:	e9 96 f2 ff ff       	jmp    80105b05 <alltraps>

8010686f <vector214>:
.globl vector214
vector214:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $214
80106871:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106876:	e9 8a f2 ff ff       	jmp    80105b05 <alltraps>

8010687b <vector215>:
.globl vector215
vector215:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $215
8010687d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106882:	e9 7e f2 ff ff       	jmp    80105b05 <alltraps>

80106887 <vector216>:
.globl vector216
vector216:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $216
80106889:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010688e:	e9 72 f2 ff ff       	jmp    80105b05 <alltraps>

80106893 <vector217>:
.globl vector217
vector217:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $217
80106895:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010689a:	e9 66 f2 ff ff       	jmp    80105b05 <alltraps>

8010689f <vector218>:
.globl vector218
vector218:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $218
801068a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068a6:	e9 5a f2 ff ff       	jmp    80105b05 <alltraps>

801068ab <vector219>:
.globl vector219
vector219:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $219
801068ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068b2:	e9 4e f2 ff ff       	jmp    80105b05 <alltraps>

801068b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $220
801068b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068be:	e9 42 f2 ff ff       	jmp    80105b05 <alltraps>

801068c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $221
801068c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068ca:	e9 36 f2 ff ff       	jmp    80105b05 <alltraps>

801068cf <vector222>:
.globl vector222
vector222:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $222
801068d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801068d6:	e9 2a f2 ff ff       	jmp    80105b05 <alltraps>

801068db <vector223>:
.globl vector223
vector223:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $223
801068dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068e2:	e9 1e f2 ff ff       	jmp    80105b05 <alltraps>

801068e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $224
801068e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068ee:	e9 12 f2 ff ff       	jmp    80105b05 <alltraps>

801068f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $225
801068f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068fa:	e9 06 f2 ff ff       	jmp    80105b05 <alltraps>

801068ff <vector226>:
.globl vector226
vector226:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $226
80106901:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106906:	e9 fa f1 ff ff       	jmp    80105b05 <alltraps>

8010690b <vector227>:
.globl vector227
vector227:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $227
8010690d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106912:	e9 ee f1 ff ff       	jmp    80105b05 <alltraps>

80106917 <vector228>:
.globl vector228
vector228:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $228
80106919:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010691e:	e9 e2 f1 ff ff       	jmp    80105b05 <alltraps>

80106923 <vector229>:
.globl vector229
vector229:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $229
80106925:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010692a:	e9 d6 f1 ff ff       	jmp    80105b05 <alltraps>

8010692f <vector230>:
.globl vector230
vector230:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $230
80106931:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106936:	e9 ca f1 ff ff       	jmp    80105b05 <alltraps>

8010693b <vector231>:
.globl vector231
vector231:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $231
8010693d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106942:	e9 be f1 ff ff       	jmp    80105b05 <alltraps>

80106947 <vector232>:
.globl vector232
vector232:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $232
80106949:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010694e:	e9 b2 f1 ff ff       	jmp    80105b05 <alltraps>

80106953 <vector233>:
.globl vector233
vector233:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $233
80106955:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010695a:	e9 a6 f1 ff ff       	jmp    80105b05 <alltraps>

8010695f <vector234>:
.globl vector234
vector234:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $234
80106961:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106966:	e9 9a f1 ff ff       	jmp    80105b05 <alltraps>

8010696b <vector235>:
.globl vector235
vector235:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $235
8010696d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106972:	e9 8e f1 ff ff       	jmp    80105b05 <alltraps>

80106977 <vector236>:
.globl vector236
vector236:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $236
80106979:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010697e:	e9 82 f1 ff ff       	jmp    80105b05 <alltraps>

80106983 <vector237>:
.globl vector237
vector237:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $237
80106985:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010698a:	e9 76 f1 ff ff       	jmp    80105b05 <alltraps>

8010698f <vector238>:
.globl vector238
vector238:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $238
80106991:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106996:	e9 6a f1 ff ff       	jmp    80105b05 <alltraps>

8010699b <vector239>:
.globl vector239
vector239:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $239
8010699d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069a2:	e9 5e f1 ff ff       	jmp    80105b05 <alltraps>

801069a7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $240
801069a9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069ae:	e9 52 f1 ff ff       	jmp    80105b05 <alltraps>

801069b3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $241
801069b5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069ba:	e9 46 f1 ff ff       	jmp    80105b05 <alltraps>

801069bf <vector242>:
.globl vector242
vector242:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $242
801069c1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069c6:	e9 3a f1 ff ff       	jmp    80105b05 <alltraps>

801069cb <vector243>:
.globl vector243
vector243:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $243
801069cd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801069d2:	e9 2e f1 ff ff       	jmp    80105b05 <alltraps>

801069d7 <vector244>:
.globl vector244
vector244:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $244
801069d9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069de:	e9 22 f1 ff ff       	jmp    80105b05 <alltraps>

801069e3 <vector245>:
.globl vector245
vector245:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $245
801069e5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069ea:	e9 16 f1 ff ff       	jmp    80105b05 <alltraps>

801069ef <vector246>:
.globl vector246
vector246:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $246
801069f1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069f6:	e9 0a f1 ff ff       	jmp    80105b05 <alltraps>

801069fb <vector247>:
.globl vector247
vector247:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $247
801069fd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a02:	e9 fe f0 ff ff       	jmp    80105b05 <alltraps>

80106a07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $248
80106a09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a0e:	e9 f2 f0 ff ff       	jmp    80105b05 <alltraps>

80106a13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $249
80106a15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a1a:	e9 e6 f0 ff ff       	jmp    80105b05 <alltraps>

80106a1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $250
80106a21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a26:	e9 da f0 ff ff       	jmp    80105b05 <alltraps>

80106a2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $251
80106a2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a32:	e9 ce f0 ff ff       	jmp    80105b05 <alltraps>

80106a37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $252
80106a39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a3e:	e9 c2 f0 ff ff       	jmp    80105b05 <alltraps>

80106a43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $253
80106a45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a4a:	e9 b6 f0 ff ff       	jmp    80105b05 <alltraps>

80106a4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $254
80106a51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a56:	e9 aa f0 ff ff       	jmp    80105b05 <alltraps>

80106a5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $255
80106a5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a62:	e9 9e f0 ff ff       	jmp    80105b05 <alltraps>
80106a67:	66 90                	xchg   %ax,%ax
80106a69:	66 90                	xchg   %ax,%ax
80106a6b:	66 90                	xchg   %ax,%ax
80106a6d:	66 90                	xchg   %ax,%ax
80106a6f:	90                   	nop

80106a70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	56                   	push   %esi
80106a75:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a76:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a7c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a82:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106a85:	39 d3                	cmp    %edx,%ebx
80106a87:	73 56                	jae    80106adf <deallocuvm.part.0+0x6f>
80106a89:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106a8c:	89 c6                	mov    %eax,%esi
80106a8e:	89 d7                	mov    %edx,%edi
80106a90:	eb 12                	jmp    80106aa4 <deallocuvm.part.0+0x34>
80106a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a98:	83 c2 01             	add    $0x1,%edx
80106a9b:	89 d3                	mov    %edx,%ebx
80106a9d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106aa0:	39 fb                	cmp    %edi,%ebx
80106aa2:	73 38                	jae    80106adc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106aa4:	89 da                	mov    %ebx,%edx
80106aa6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106aa9:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106aac:	a8 01                	test   $0x1,%al
80106aae:	74 e8                	je     80106a98 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106ab0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ab2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106ab7:	c1 e9 0a             	shr    $0xa,%ecx
80106aba:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106ac0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106ac7:	85 c0                	test   %eax,%eax
80106ac9:	74 cd                	je     80106a98 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106acb:	8b 10                	mov    (%eax),%edx
80106acd:	f6 c2 01             	test   $0x1,%dl
80106ad0:	75 1e                	jne    80106af0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106ad2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ad8:	39 fb                	cmp    %edi,%ebx
80106ada:	72 c8                	jb     80106aa4 <deallocuvm.part.0+0x34>
80106adc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106adf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ae2:	89 c8                	mov    %ecx,%eax
80106ae4:	5b                   	pop    %ebx
80106ae5:	5e                   	pop    %esi
80106ae6:	5f                   	pop    %edi
80106ae7:	5d                   	pop    %ebp
80106ae8:	c3                   	ret
80106ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106af0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106af6:	74 26                	je     80106b1e <deallocuvm.part.0+0xae>
      kfree(v);
80106af8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106afb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106b01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b04:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106b0a:	52                   	push   %edx
80106b0b:	e8 e0 b9 ff ff       	call   801024f0 <kfree>
      *pte = 0;
80106b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106b13:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106b16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106b1c:	eb 82                	jmp    80106aa0 <deallocuvm.part.0+0x30>
        panic("kfree");
80106b1e:	83 ec 0c             	sub    $0xc,%esp
80106b21:	68 0c 76 10 80       	push   $0x8010760c
80106b26:	e8 55 98 ff ff       	call   80100380 <panic>
80106b2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106b30 <mappages>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106b36:	89 d3                	mov    %edx,%ebx
80106b38:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b3e:	83 ec 1c             	sub    $0x1c,%esp
80106b41:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b44:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b50:	8b 45 08             	mov    0x8(%ebp),%eax
80106b53:	29 d8                	sub    %ebx,%eax
80106b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b58:	eb 3f                	jmp    80106b99 <mappages+0x69>
80106b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106b60:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106b67:	c1 ea 0a             	shr    $0xa,%edx
80106b6a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b70:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b77:	85 c0                	test   %eax,%eax
80106b79:	74 75                	je     80106bf0 <mappages+0xc0>
    if(*pte & PTE_P)
80106b7b:	f6 00 01             	testb  $0x1,(%eax)
80106b7e:	0f 85 86 00 00 00    	jne    80106c0a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106b84:	0b 75 0c             	or     0xc(%ebp),%esi
80106b87:	83 ce 01             	or     $0x1,%esi
80106b8a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b8f:	39 c3                	cmp    %eax,%ebx
80106b91:	74 6d                	je     80106c00 <mappages+0xd0>
    a += PGSIZE;
80106b93:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106b99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106b9c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106b9f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106ba2:	89 d8                	mov    %ebx,%eax
80106ba4:	c1 e8 16             	shr    $0x16,%eax
80106ba7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106baa:	8b 07                	mov    (%edi),%eax
80106bac:	a8 01                	test   $0x1,%al
80106bae:	75 b0                	jne    80106b60 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bb0:	e8 fb ba ff ff       	call   801026b0 <kalloc>
80106bb5:	85 c0                	test   %eax,%eax
80106bb7:	74 37                	je     80106bf0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106bb9:	83 ec 04             	sub    $0x4,%esp
80106bbc:	68 00 10 00 00       	push   $0x1000
80106bc1:	6a 00                	push   $0x0
80106bc3:	50                   	push   %eax
80106bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106bc7:	e8 e4 dc ff ff       	call   801048b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bcc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106bcf:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bd2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106bd8:	83 c8 07             	or     $0x7,%eax
80106bdb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106bdd:	89 d8                	mov    %ebx,%eax
80106bdf:	c1 e8 0a             	shr    $0xa,%eax
80106be2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106be7:	01 d0                	add    %edx,%eax
80106be9:	eb 90                	jmp    80106b7b <mappages+0x4b>
80106beb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bf8:	5b                   	pop    %ebx
80106bf9:	5e                   	pop    %esi
80106bfa:	5f                   	pop    %edi
80106bfb:	5d                   	pop    %ebp
80106bfc:	c3                   	ret
80106bfd:	8d 76 00             	lea    0x0(%esi),%esi
80106c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c03:	31 c0                	xor    %eax,%eax
}
80106c05:	5b                   	pop    %ebx
80106c06:	5e                   	pop    %esi
80106c07:	5f                   	pop    %edi
80106c08:	5d                   	pop    %ebp
80106c09:	c3                   	ret
      panic("remap");
80106c0a:	83 ec 0c             	sub    $0xc,%esp
80106c0d:	68 63 78 10 80       	push   $0x80107863
80106c12:	e8 69 97 ff ff       	call   80100380 <panic>
80106c17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c1e:	00 
80106c1f:	90                   	nop

80106c20 <seginit>:
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c26:	e8 85 cd ff ff       	call   801039b0 <cpuid>
  pd[0] = size-1;
80106c2b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c30:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80106c36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106c3a:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106c41:	ff 00 00 
80106c44:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106c4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c4e:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106c55:	ff 00 00 
80106c58:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106c5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c62:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106c69:	ff 00 00 
80106c6c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106c73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c76:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106c7d:	ff 00 00 
80106c80:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106c87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c8a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106c8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c93:	c1 e8 10             	shr    $0x10,%eax
80106c96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c9d:	0f 01 10             	lgdtl  (%eax)
}
80106ca0:	c9                   	leave
80106ca1:	c3                   	ret
80106ca2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ca9:	00 
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cb0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cb0:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80106cb5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cba:	0f 22 d8             	mov    %eax,%cr3
}
80106cbd:	c3                   	ret
80106cbe:	66 90                	xchg   %ax,%ax

80106cc0 <switchuvm>:
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	83 ec 1c             	sub    $0x1c,%esp
80106cc9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106ccc:	85 f6                	test   %esi,%esi
80106cce:	0f 84 cb 00 00 00    	je     80106d9f <switchuvm+0xdf>
  if(p->kstack == 0)
80106cd4:	8b 46 08             	mov    0x8(%esi),%eax
80106cd7:	85 c0                	test   %eax,%eax
80106cd9:	0f 84 da 00 00 00    	je     80106db9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106cdf:	8b 46 04             	mov    0x4(%esi),%eax
80106ce2:	85 c0                	test   %eax,%eax
80106ce4:	0f 84 c2 00 00 00    	je     80106dac <switchuvm+0xec>
  pushcli();
80106cea:	e8 91 d8 ff ff       	call   80104580 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cef:	e8 5c cc ff ff       	call   80103950 <mycpu>
80106cf4:	89 c3                	mov    %eax,%ebx
80106cf6:	e8 55 cc ff ff       	call   80103950 <mycpu>
80106cfb:	89 c7                	mov    %eax,%edi
80106cfd:	e8 4e cc ff ff       	call   80103950 <mycpu>
80106d02:	83 c7 08             	add    $0x8,%edi
80106d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d08:	e8 43 cc ff ff       	call   80103950 <mycpu>
80106d0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d10:	ba 67 00 00 00       	mov    $0x67,%edx
80106d15:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d1c:	83 c0 08             	add    $0x8,%eax
80106d1f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d26:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d2b:	83 c1 08             	add    $0x8,%ecx
80106d2e:	c1 e8 18             	shr    $0x18,%eax
80106d31:	c1 e9 10             	shr    $0x10,%ecx
80106d34:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d3a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d45:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106d51:	e8 fa cb ff ff       	call   80103950 <mycpu>
80106d56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d5d:	e8 ee cb ff ff       	call   80103950 <mycpu>
80106d62:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d66:	8b 5e 08             	mov    0x8(%esi),%ebx
80106d69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d6f:	e8 dc cb ff ff       	call   80103950 <mycpu>
80106d74:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d77:	e8 d4 cb ff ff       	call   80103950 <mycpu>
80106d7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d80:	b8 28 00 00 00       	mov    $0x28,%eax
80106d85:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d88:	8b 46 04             	mov    0x4(%esi),%eax
80106d8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d90:	0f 22 d8             	mov    %eax,%cr3
}
80106d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d96:	5b                   	pop    %ebx
80106d97:	5e                   	pop    %esi
80106d98:	5f                   	pop    %edi
80106d99:	5d                   	pop    %ebp
  popcli();
80106d9a:	e9 31 d8 ff ff       	jmp    801045d0 <popcli>
    panic("switchuvm: no process");
80106d9f:	83 ec 0c             	sub    $0xc,%esp
80106da2:	68 69 78 10 80       	push   $0x80107869
80106da7:	e8 d4 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106dac:	83 ec 0c             	sub    $0xc,%esp
80106daf:	68 94 78 10 80       	push   $0x80107894
80106db4:	e8 c7 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106db9:	83 ec 0c             	sub    $0xc,%esp
80106dbc:	68 7f 78 10 80       	push   $0x8010787f
80106dc1:	e8 ba 95 ff ff       	call   80100380 <panic>
80106dc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dcd:	00 
80106dce:	66 90                	xchg   %ax,%ax

80106dd0 <inituvm>:
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
80106dd9:	8b 45 08             	mov    0x8(%ebp),%eax
80106ddc:	8b 75 10             	mov    0x10(%ebp),%esi
80106ddf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106de2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106de5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106deb:	77 49                	ja     80106e36 <inituvm+0x66>
  mem = kalloc();
80106ded:	e8 be b8 ff ff       	call   801026b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106df2:	83 ec 04             	sub    $0x4,%esp
80106df5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106dfa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106dfc:	6a 00                	push   $0x0
80106dfe:	50                   	push   %eax
80106dff:	e8 ac da ff ff       	call   801048b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e04:	58                   	pop    %eax
80106e05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e0b:	5a                   	pop    %edx
80106e0c:	6a 06                	push   $0x6
80106e0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e13:	31 d2                	xor    %edx,%edx
80106e15:	50                   	push   %eax
80106e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e19:	e8 12 fd ff ff       	call   80106b30 <mappages>
  memmove(mem, init, sz);
80106e1e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e21:	83 c4 10             	add    $0x10,%esp
80106e24:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e27:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e2d:	5b                   	pop    %ebx
80106e2e:	5e                   	pop    %esi
80106e2f:	5f                   	pop    %edi
80106e30:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e31:	e9 0a db ff ff       	jmp    80104940 <memmove>
    panic("inituvm: more than a page");
80106e36:	83 ec 0c             	sub    $0xc,%esp
80106e39:	68 a8 78 10 80       	push   $0x801078a8
80106e3e:	e8 3d 95 ff ff       	call   80100380 <panic>
80106e43:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e4a:	00 
80106e4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106e50 <loaduvm>:
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
80106e56:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106e59:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106e5c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106e5f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106e65:	0f 85 a2 00 00 00    	jne    80106f0d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106e6b:	85 ff                	test   %edi,%edi
80106e6d:	74 7d                	je     80106eec <loaduvm+0x9c>
80106e6f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106e73:	8b 55 08             	mov    0x8(%ebp),%edx
80106e76:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106e78:	89 c1                	mov    %eax,%ecx
80106e7a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106e7d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106e80:	f6 c1 01             	test   $0x1,%cl
80106e83:	75 13                	jne    80106e98 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106e85:	83 ec 0c             	sub    $0xc,%esp
80106e88:	68 c2 78 10 80       	push   $0x801078c2
80106e8d:	e8 ee 94 ff ff       	call   80100380 <panic>
80106e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e98:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e9b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106ea1:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ea6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ead:	85 c9                	test   %ecx,%ecx
80106eaf:	74 d4                	je     80106e85 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106eb1:	89 fb                	mov    %edi,%ebx
80106eb3:	b8 00 10 00 00       	mov    $0x1000,%eax
80106eb8:	29 f3                	sub    %esi,%ebx
80106eba:	39 c3                	cmp    %eax,%ebx
80106ebc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ebf:	53                   	push   %ebx
80106ec0:	8b 45 14             	mov    0x14(%ebp),%eax
80106ec3:	01 f0                	add    %esi,%eax
80106ec5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106ec6:	8b 01                	mov    (%ecx),%eax
80106ec8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ecd:	05 00 00 00 80       	add    $0x80000000,%eax
80106ed2:	50                   	push   %eax
80106ed3:	ff 75 10             	push   0x10(%ebp)
80106ed6:	e8 25 ac ff ff       	call   80101b00 <readi>
80106edb:	83 c4 10             	add    $0x10,%esp
80106ede:	39 d8                	cmp    %ebx,%eax
80106ee0:	75 1e                	jne    80106f00 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106ee2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ee8:	39 fe                	cmp    %edi,%esi
80106eea:	72 84                	jb     80106e70 <loaduvm+0x20>
}
80106eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106eef:	31 c0                	xor    %eax,%eax
}
80106ef1:	5b                   	pop    %ebx
80106ef2:	5e                   	pop    %esi
80106ef3:	5f                   	pop    %edi
80106ef4:	5d                   	pop    %ebp
80106ef5:	c3                   	ret
80106ef6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106efd:	00 
80106efe:	66 90                	xchg   %ax,%ax
80106f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f08:	5b                   	pop    %ebx
80106f09:	5e                   	pop    %esi
80106f0a:	5f                   	pop    %edi
80106f0b:	5d                   	pop    %ebp
80106f0c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106f0d:	83 ec 0c             	sub    $0xc,%esp
80106f10:	68 70 7b 10 80       	push   $0x80107b70
80106f15:	e8 66 94 ff ff       	call   80100380 <panic>
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f20 <allocuvm>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 1c             	sub    $0x1c,%esp
80106f29:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106f2c:	85 f6                	test   %esi,%esi
80106f2e:	0f 88 98 00 00 00    	js     80106fcc <allocuvm+0xac>
80106f34:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106f36:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f39:	0f 82 a1 00 00 00    	jb     80106fe0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f42:	05 ff 0f 00 00       	add    $0xfff,%eax
80106f47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f4c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106f4e:	39 f0                	cmp    %esi,%eax
80106f50:	0f 83 8d 00 00 00    	jae    80106fe3 <allocuvm+0xc3>
80106f56:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106f59:	eb 44                	jmp    80106f9f <allocuvm+0x7f>
80106f5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106f60:	83 ec 04             	sub    $0x4,%esp
80106f63:	68 00 10 00 00       	push   $0x1000
80106f68:	6a 00                	push   $0x0
80106f6a:	50                   	push   %eax
80106f6b:	e8 40 d9 ff ff       	call   801048b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f70:	58                   	pop    %eax
80106f71:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f77:	5a                   	pop    %edx
80106f78:	6a 06                	push   $0x6
80106f7a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f7f:	89 fa                	mov    %edi,%edx
80106f81:	50                   	push   %eax
80106f82:	8b 45 08             	mov    0x8(%ebp),%eax
80106f85:	e8 a6 fb ff ff       	call   80106b30 <mappages>
80106f8a:	83 c4 10             	add    $0x10,%esp
80106f8d:	85 c0                	test   %eax,%eax
80106f8f:	78 5f                	js     80106ff0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106f91:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106f97:	39 f7                	cmp    %esi,%edi
80106f99:	0f 83 89 00 00 00    	jae    80107028 <allocuvm+0x108>
    mem = kalloc();
80106f9f:	e8 0c b7 ff ff       	call   801026b0 <kalloc>
80106fa4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106fa6:	85 c0                	test   %eax,%eax
80106fa8:	75 b6                	jne    80106f60 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106faa:	83 ec 0c             	sub    $0xc,%esp
80106fad:	68 e0 78 10 80       	push   $0x801078e0
80106fb2:	e8 f9 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106fb7:	83 c4 10             	add    $0x10,%esp
80106fba:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106fbd:	74 0d                	je     80106fcc <allocuvm+0xac>
80106fbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc5:	89 f2                	mov    %esi,%edx
80106fc7:	e8 a4 fa ff ff       	call   80106a70 <deallocuvm.part.0>
    return 0;
80106fcc:	31 d2                	xor    %edx,%edx
}
80106fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fd1:	89 d0                	mov    %edx,%eax
80106fd3:	5b                   	pop    %ebx
80106fd4:	5e                   	pop    %esi
80106fd5:	5f                   	pop    %edi
80106fd6:	5d                   	pop    %ebp
80106fd7:	c3                   	ret
80106fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fdf:	00 
    return oldsz;
80106fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fe6:	89 d0                	mov    %edx,%eax
80106fe8:	5b                   	pop    %ebx
80106fe9:	5e                   	pop    %esi
80106fea:	5f                   	pop    %edi
80106feb:	5d                   	pop    %ebp
80106fec:	c3                   	ret
80106fed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ff0:	83 ec 0c             	sub    $0xc,%esp
80106ff3:	68 f8 78 10 80       	push   $0x801078f8
80106ff8:	e8 b3 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106ffd:	83 c4 10             	add    $0x10,%esp
80107000:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107003:	74 0d                	je     80107012 <allocuvm+0xf2>
80107005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107008:	8b 45 08             	mov    0x8(%ebp),%eax
8010700b:	89 f2                	mov    %esi,%edx
8010700d:	e8 5e fa ff ff       	call   80106a70 <deallocuvm.part.0>
      kfree(mem);
80107012:	83 ec 0c             	sub    $0xc,%esp
80107015:	53                   	push   %ebx
80107016:	e8 d5 b4 ff ff       	call   801024f0 <kfree>
      return 0;
8010701b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010701e:	31 d2                	xor    %edx,%edx
80107020:	eb ac                	jmp    80106fce <allocuvm+0xae>
80107022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107028:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010702b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010702e:	5b                   	pop    %ebx
8010702f:	5e                   	pop    %esi
80107030:	89 d0                	mov    %edx,%eax
80107032:	5f                   	pop    %edi
80107033:	5d                   	pop    %ebp
80107034:	c3                   	ret
80107035:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010703c:	00 
8010703d:	8d 76 00             	lea    0x0(%esi),%esi

80107040 <deallocuvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	8b 55 0c             	mov    0xc(%ebp),%edx
80107046:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107049:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010704c:	39 d1                	cmp    %edx,%ecx
8010704e:	73 10                	jae    80107060 <deallocuvm+0x20>
}
80107050:	5d                   	pop    %ebp
80107051:	e9 1a fa ff ff       	jmp    80106a70 <deallocuvm.part.0>
80107056:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010705d:	00 
8010705e:	66 90                	xchg   %ax,%ax
80107060:	89 d0                	mov    %edx,%eax
80107062:	5d                   	pop    %ebp
80107063:	c3                   	ret
80107064:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010706b:	00 
8010706c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107070 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 0c             	sub    $0xc,%esp
80107079:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010707c:	85 f6                	test   %esi,%esi
8010707e:	74 59                	je     801070d9 <freevm+0x69>
  if(newsz >= oldsz)
80107080:	31 c9                	xor    %ecx,%ecx
80107082:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107087:	89 f0                	mov    %esi,%eax
80107089:	89 f3                	mov    %esi,%ebx
8010708b:	e8 e0 f9 ff ff       	call   80106a70 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107090:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107096:	eb 0f                	jmp    801070a7 <freevm+0x37>
80107098:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010709f:	00 
801070a0:	83 c3 04             	add    $0x4,%ebx
801070a3:	39 fb                	cmp    %edi,%ebx
801070a5:	74 23                	je     801070ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801070a7:	8b 03                	mov    (%ebx),%eax
801070a9:	a8 01                	test   $0x1,%al
801070ab:	74 f3                	je     801070a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801070b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801070bd:	50                   	push   %eax
801070be:	e8 2d b4 ff ff       	call   801024f0 <kfree>
801070c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070c6:	39 fb                	cmp    %edi,%ebx
801070c8:	75 dd                	jne    801070a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801070ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801070cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070d0:	5b                   	pop    %ebx
801070d1:	5e                   	pop    %esi
801070d2:	5f                   	pop    %edi
801070d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801070d4:	e9 17 b4 ff ff       	jmp    801024f0 <kfree>
    panic("freevm: no pgdir");
801070d9:	83 ec 0c             	sub    $0xc,%esp
801070dc:	68 14 79 10 80       	push   $0x80107914
801070e1:	e8 9a 92 ff ff       	call   80100380 <panic>
801070e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070ed:	00 
801070ee:	66 90                	xchg   %ax,%ax

801070f0 <setupkvm>:
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	56                   	push   %esi
801070f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801070f5:	e8 b6 b5 ff ff       	call   801026b0 <kalloc>
801070fa:	85 c0                	test   %eax,%eax
801070fc:	74 5e                	je     8010715c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801070fe:	83 ec 04             	sub    $0x4,%esp
80107101:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107103:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107108:	68 00 10 00 00       	push   $0x1000
8010710d:	6a 00                	push   $0x0
8010710f:	50                   	push   %eax
80107110:	e8 9b d7 ff ff       	call   801048b0 <memset>
80107115:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107118:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010711b:	83 ec 08             	sub    $0x8,%esp
8010711e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107121:	8b 13                	mov    (%ebx),%edx
80107123:	ff 73 0c             	push   0xc(%ebx)
80107126:	50                   	push   %eax
80107127:	29 c1                	sub    %eax,%ecx
80107129:	89 f0                	mov    %esi,%eax
8010712b:	e8 00 fa ff ff       	call   80106b30 <mappages>
80107130:	83 c4 10             	add    $0x10,%esp
80107133:	85 c0                	test   %eax,%eax
80107135:	78 19                	js     80107150 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107137:	83 c3 10             	add    $0x10,%ebx
8010713a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107140:	75 d6                	jne    80107118 <setupkvm+0x28>
}
80107142:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107145:	89 f0                	mov    %esi,%eax
80107147:	5b                   	pop    %ebx
80107148:	5e                   	pop    %esi
80107149:	5d                   	pop    %ebp
8010714a:	c3                   	ret
8010714b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107150:	83 ec 0c             	sub    $0xc,%esp
80107153:	56                   	push   %esi
80107154:	e8 17 ff ff ff       	call   80107070 <freevm>
      return 0;
80107159:	83 c4 10             	add    $0x10,%esp
}
8010715c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010715f:	31 f6                	xor    %esi,%esi
}
80107161:	89 f0                	mov    %esi,%eax
80107163:	5b                   	pop    %ebx
80107164:	5e                   	pop    %esi
80107165:	5d                   	pop    %ebp
80107166:	c3                   	ret
80107167:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010716e:	00 
8010716f:	90                   	nop

80107170 <kvmalloc>:
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107176:	e8 75 ff ff ff       	call   801070f0 <setupkvm>
8010717b:	a3 e4 42 11 80       	mov    %eax,0x801142e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107180:	05 00 00 00 80       	add    $0x80000000,%eax
80107185:	0f 22 d8             	mov    %eax,%cr3
}
80107188:	c9                   	leave
80107189:	c3                   	ret
8010718a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107190 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	83 ec 08             	sub    $0x8,%esp
80107196:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107199:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010719c:	89 c1                	mov    %eax,%ecx
8010719e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801071a4:	f6 c2 01             	test   $0x1,%dl
801071a7:	75 17                	jne    801071c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801071a9:	83 ec 0c             	sub    $0xc,%esp
801071ac:	68 25 79 10 80       	push   $0x80107925
801071b1:	e8 ca 91 ff ff       	call   80100380 <panic>
801071b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071bd:	00 
801071be:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801071c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801071c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801071ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801071d5:	85 c0                	test   %eax,%eax
801071d7:	74 d0                	je     801071a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801071d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071dc:	c9                   	leave
801071dd:	c3                   	ret
801071de:	66 90                	xchg   %ax,%ax

801071e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	57                   	push   %edi
801071e4:	56                   	push   %esi
801071e5:	53                   	push   %ebx
801071e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071e9:	e8 02 ff ff ff       	call   801070f0 <setupkvm>
801071ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071f1:	85 c0                	test   %eax,%eax
801071f3:	0f 84 e9 00 00 00    	je     801072e2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801071f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071fc:	85 c9                	test   %ecx,%ecx
801071fe:	0f 84 b2 00 00 00    	je     801072b6 <copyuvm+0xd6>
80107204:	31 f6                	xor    %esi,%esi
80107206:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010720d:	00 
8010720e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107213:	89 f0                	mov    %esi,%eax
80107215:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107218:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010721b:	a8 01                	test   $0x1,%al
8010721d:	75 11                	jne    80107230 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010721f:	83 ec 0c             	sub    $0xc,%esp
80107222:	68 2f 79 10 80       	push   $0x8010792f
80107227:	e8 54 91 ff ff       	call   80100380 <panic>
8010722c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107230:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107232:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107237:	c1 ea 0a             	shr    $0xa,%edx
8010723a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107240:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107247:	85 c0                	test   %eax,%eax
80107249:	74 d4                	je     8010721f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010724b:	8b 00                	mov    (%eax),%eax
8010724d:	a8 01                	test   $0x1,%al
8010724f:	0f 84 9f 00 00 00    	je     801072f4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107255:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107257:	25 ff 0f 00 00       	and    $0xfff,%eax
8010725c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010725f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107265:	e8 46 b4 ff ff       	call   801026b0 <kalloc>
8010726a:	89 c3                	mov    %eax,%ebx
8010726c:	85 c0                	test   %eax,%eax
8010726e:	74 64                	je     801072d4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107270:	83 ec 04             	sub    $0x4,%esp
80107273:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107279:	68 00 10 00 00       	push   $0x1000
8010727e:	57                   	push   %edi
8010727f:	50                   	push   %eax
80107280:	e8 bb d6 ff ff       	call   80104940 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107285:	58                   	pop    %eax
80107286:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010728c:	5a                   	pop    %edx
8010728d:	ff 75 e4             	push   -0x1c(%ebp)
80107290:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107295:	89 f2                	mov    %esi,%edx
80107297:	50                   	push   %eax
80107298:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010729b:	e8 90 f8 ff ff       	call   80106b30 <mappages>
801072a0:	83 c4 10             	add    $0x10,%esp
801072a3:	85 c0                	test   %eax,%eax
801072a5:	78 21                	js     801072c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801072a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072ad:	3b 75 0c             	cmp    0xc(%ebp),%esi
801072b0:	0f 82 5a ff ff ff    	jb     80107210 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801072b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072bc:	5b                   	pop    %ebx
801072bd:	5e                   	pop    %esi
801072be:	5f                   	pop    %edi
801072bf:	5d                   	pop    %ebp
801072c0:	c3                   	ret
801072c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801072c8:	83 ec 0c             	sub    $0xc,%esp
801072cb:	53                   	push   %ebx
801072cc:	e8 1f b2 ff ff       	call   801024f0 <kfree>
      goto bad;
801072d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801072d4:	83 ec 0c             	sub    $0xc,%esp
801072d7:	ff 75 e0             	push   -0x20(%ebp)
801072da:	e8 91 fd ff ff       	call   80107070 <freevm>
  return 0;
801072df:	83 c4 10             	add    $0x10,%esp
    return 0;
801072e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801072e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ef:	5b                   	pop    %ebx
801072f0:	5e                   	pop    %esi
801072f1:	5f                   	pop    %edi
801072f2:	5d                   	pop    %ebp
801072f3:	c3                   	ret
      panic("copyuvm: page not present");
801072f4:	83 ec 0c             	sub    $0xc,%esp
801072f7:	68 49 79 10 80       	push   $0x80107949
801072fc:	e8 7f 90 ff ff       	call   80100380 <panic>
80107301:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107308:	00 
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107310 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107316:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107319:	89 c1                	mov    %eax,%ecx
8010731b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010731e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107321:	f6 c2 01             	test   $0x1,%dl
80107324:	0f 84 f8 00 00 00    	je     80107422 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010732a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010732d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107333:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107334:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107339:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107340:	89 d0                	mov    %edx,%eax
80107342:	f7 d2                	not    %edx
80107344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107349:	05 00 00 00 80       	add    $0x80000000,%eax
8010734e:	83 e2 05             	and    $0x5,%edx
80107351:	ba 00 00 00 00       	mov    $0x0,%edx
80107356:	0f 45 c2             	cmovne %edx,%eax
}
80107359:	c3                   	ret
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107360 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 0c             	sub    $0xc,%esp
80107369:	8b 75 14             	mov    0x14(%ebp),%esi
8010736c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010736f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107372:	85 f6                	test   %esi,%esi
80107374:	75 51                	jne    801073c7 <copyout+0x67>
80107376:	e9 9d 00 00 00       	jmp    80107418 <copyout+0xb8>
8010737b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107380:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107386:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010738c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107392:	74 74                	je     80107408 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107394:	89 fb                	mov    %edi,%ebx
80107396:	29 c3                	sub    %eax,%ebx
80107398:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010739e:	39 f3                	cmp    %esi,%ebx
801073a0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073a3:	29 f8                	sub    %edi,%eax
801073a5:	83 ec 04             	sub    $0x4,%esp
801073a8:	01 c1                	add    %eax,%ecx
801073aa:	53                   	push   %ebx
801073ab:	52                   	push   %edx
801073ac:	89 55 10             	mov    %edx,0x10(%ebp)
801073af:	51                   	push   %ecx
801073b0:	e8 8b d5 ff ff       	call   80104940 <memmove>
    len -= n;
    buf += n;
801073b5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801073b8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801073be:	83 c4 10             	add    $0x10,%esp
    buf += n;
801073c1:	01 da                	add    %ebx,%edx
  while(len > 0){
801073c3:	29 de                	sub    %ebx,%esi
801073c5:	74 51                	je     80107418 <copyout+0xb8>
  if(*pde & PTE_P){
801073c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801073ca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801073cc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801073ce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801073d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801073d7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801073da:	f6 c1 01             	test   $0x1,%cl
801073dd:	0f 84 46 00 00 00    	je     80107429 <copyout.cold>
  return &pgtab[PTX(va)];
801073e3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801073eb:	c1 eb 0c             	shr    $0xc,%ebx
801073ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801073f4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801073fb:	89 d9                	mov    %ebx,%ecx
801073fd:	f7 d1                	not    %ecx
801073ff:	83 e1 05             	and    $0x5,%ecx
80107402:	0f 84 78 ff ff ff    	je     80107380 <copyout+0x20>
  }
  return 0;
}
80107408:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010740b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107410:	5b                   	pop    %ebx
80107411:	5e                   	pop    %esi
80107412:	5f                   	pop    %edi
80107413:	5d                   	pop    %ebp
80107414:	c3                   	ret
80107415:	8d 76 00             	lea    0x0(%esi),%esi
80107418:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010741b:	31 c0                	xor    %eax,%eax
}
8010741d:	5b                   	pop    %ebx
8010741e:	5e                   	pop    %esi
8010741f:	5f                   	pop    %edi
80107420:	5d                   	pop    %ebp
80107421:	c3                   	ret

80107422 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107422:	a1 00 00 00 00       	mov    0x0,%eax
80107427:	0f 0b                	ud2

80107429 <copyout.cold>:
80107429:	a1 00 00 00 00       	mov    0x0,%eax
8010742e:	0f 0b                	ud2
