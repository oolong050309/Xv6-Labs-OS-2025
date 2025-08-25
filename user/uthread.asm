
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
extern void thread_switch(struct context* old, struct context* new);// 修改 thread_switch 函数声明

              
void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d9a78793          	addi	a5,a5,-614 # da0 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d8f73123          	sd	a5,-638(a4) # d90 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d8f72423          	sw	a5,-632(a4) # 2da0 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001517          	auipc	a0,0x1
  32:	d6253503          	ld	a0,-670(a0) # d90 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0xb07>
  3c:	95aa                	add	a1,a1,a0
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009897          	auipc	a7,0x9
  44:	f4088893          	addi	a7,a7,-192 # 8f80 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6809                	lui	a6,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	6689                	lui	a3,0x2
  4e:	07868693          	addi	a3,a3,120 # 2078 <__global_pointer$+0xb07>
  52:	a809                	j	64 <thread_schedule+0x3e>
    if(t->state == RUNNABLE) {
  54:	01058733          	add	a4,a1,a6
  58:	4318                	lw	a4,0(a4)
  5a:	02c70963          	beq	a4,a2,8c <thread_schedule+0x66>
    t = t + 1;
  5e:	95b6                	add	a1,a1,a3
  for(int i = 0; i < MAX_THREAD; i++){
  60:	37fd                	addiw	a5,a5,-1
  62:	cb81                	beqz	a5,72 <thread_schedule+0x4c>
    if(t >= all_thread + MAX_THREAD)
  64:	ff15e8e3          	bltu	a1,a7,54 <thread_schedule+0x2e>
      t = all_thread;
  68:	00001597          	auipc	a1,0x1
  6c:	d3858593          	addi	a1,a1,-712 # da0 <all_thread>
  70:	b7d5                	j	54 <thread_schedule+0x2e>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  72:	00001517          	auipc	a0,0x1
  76:	b8e50513          	addi	a0,a0,-1138 # c00 <malloc+0x100>
  7a:	00001097          	auipc	ra,0x1
  7e:	9ce080e7          	jalr	-1586(ra) # a48 <printf>
    exit(-1);
  82:	557d                	li	a0,-1
  84:	00000097          	auipc	ra,0x0
  88:	65c080e7          	jalr	1628(ra) # 6e0 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8c:	02b50263          	beq	a0,a1,b0 <thread_schedule+0x8a>
    next_thread->state = RUNNING;
  90:	6789                	lui	a5,0x2
  92:	97ae                	add	a5,a5,a1
  94:	4705                	li	a4,1
  96:	c398                	sw	a4,0(a5)
    t = current_thread;
    current_thread = next_thread;
  98:	00001797          	auipc	a5,0x1
  9c:	ceb7bc23          	sd	a1,-776(a5) # d90 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
     thread_switch(&t->ctx, &next_thread->ctx); // 切换线程
  a0:	6789                	lui	a5,0x2
  a2:	07a1                	addi	a5,a5,8 # 2008 <__global_pointer$+0xa97>
  a4:	95be                	add	a1,a1,a5
  a6:	953e                	add	a0,a0,a5
  a8:	00000097          	auipc	ra,0x0
  ac:	362080e7          	jalr	866(ra) # 40a <thread_switch>
  } else
    next_thread = 0;
}
  b0:	60a2                	ld	ra,8(sp)
  b2:	6402                	ld	s0,0(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <thread_create>:

void 
thread_create(void (*func)())
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  be:	00001797          	auipc	a5,0x1
  c2:	ce278793          	addi	a5,a5,-798 # da0 <all_thread>
    if (t->state == FREE) break;
  c6:	6609                	lui	a2,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c8:	6689                	lui	a3,0x2
  ca:	07868693          	addi	a3,a3,120 # 2078 <__global_pointer$+0xb07>
  ce:	00009597          	auipc	a1,0x9
  d2:	eb258593          	addi	a1,a1,-334 # 8f80 <base>
    if (t->state == FREE) break;
  d6:	00c78733          	add	a4,a5,a2
  da:	4318                	lw	a4,0(a4)
  dc:	c701                	beqz	a4,e4 <thread_create+0x2c>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  de:	97b6                	add	a5,a5,a3
  e0:	feb79be3          	bne	a5,a1,d6 <thread_create+0x1e>
  }
  t->state = RUNNABLE;
  e4:	6709                	lui	a4,0x2
  e6:	00e786b3          	add	a3,a5,a4
  ea:	4609                	li	a2,2
  ec:	c290                	sw	a2,0(a3)
  // YOUR CODE HERE
  t->ctx.ra = (uint64)func;       // 返回地址
  ee:	e688                	sd	a0,8(a3)
  // thread_switch 的结尾会返回到 ra，从而运行线程代码
  t->ctx.sp = (uint64)&t->stack + (STACK_SIZE - 1);  // 栈指针
  f0:	177d                	addi	a4,a4,-1 # 1fff <__global_pointer$+0xa8e>
  f2:	97ba                	add	a5,a5,a4
  f4:	ea9c                	sd	a5,16(a3)
  // 将线程的栈指针指向其独立的栈，注意到栈的生长是从高地址到低地址，所以
  // 要将 sp 设置为指向 stack 的最高地址
}
  f6:	6422                	ld	s0,8(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <thread_yield>:

void 
thread_yield(void)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e406                	sd	ra,8(sp)
 100:	e022                	sd	s0,0(sp)
 102:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
 104:	00001797          	auipc	a5,0x1
 108:	c8c7b783          	ld	a5,-884(a5) # d90 <current_thread>
 10c:	6709                	lui	a4,0x2
 10e:	97ba                	add	a5,a5,a4
 110:	4709                	li	a4,2
 112:	c398                	sw	a4,0(a5)
  thread_schedule();
 114:	00000097          	auipc	ra,0x0
 118:	f12080e7          	jalr	-238(ra) # 26 <thread_schedule>
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 124:	7179                	addi	sp,sp,-48
 126:	f406                	sd	ra,40(sp)
 128:	f022                	sd	s0,32(sp)
 12a:	ec26                	sd	s1,24(sp)
 12c:	e84a                	sd	s2,16(sp)
 12e:	e44e                	sd	s3,8(sp)
 130:	e052                	sd	s4,0(sp)
 132:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 134:	00001517          	auipc	a0,0x1
 138:	af450513          	addi	a0,a0,-1292 # c28 <malloc+0x128>
 13c:	00001097          	auipc	ra,0x1
 140:	90c080e7          	jalr	-1780(ra) # a48 <printf>
  a_started = 1;
 144:	4785                	li	a5,1
 146:	00001717          	auipc	a4,0x1
 14a:	c4f72323          	sw	a5,-954(a4) # d8c <a_started>
  while(b_started == 0 || c_started == 0)
 14e:	00001497          	auipc	s1,0x1
 152:	c3a48493          	addi	s1,s1,-966 # d88 <b_started>
 156:	00001917          	auipc	s2,0x1
 15a:	c2e90913          	addi	s2,s2,-978 # d84 <c_started>
 15e:	a029                	j	168 <thread_a+0x44>
    thread_yield();
 160:	00000097          	auipc	ra,0x0
 164:	f9c080e7          	jalr	-100(ra) # fc <thread_yield>
  while(b_started == 0 || c_started == 0)
 168:	409c                	lw	a5,0(s1)
 16a:	2781                	sext.w	a5,a5
 16c:	dbf5                	beqz	a5,160 <thread_a+0x3c>
 16e:	00092783          	lw	a5,0(s2)
 172:	2781                	sext.w	a5,a5
 174:	d7f5                	beqz	a5,160 <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 176:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 178:	00001a17          	auipc	s4,0x1
 17c:	ac8a0a13          	addi	s4,s4,-1336 # c40 <malloc+0x140>
    a_n += 1;
 180:	00001917          	auipc	s2,0x1
 184:	c0090913          	addi	s2,s2,-1024 # d80 <a_n>
  for (i = 0; i < 100; i++) {
 188:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 18c:	85a6                	mv	a1,s1
 18e:	8552                	mv	a0,s4
 190:	00001097          	auipc	ra,0x1
 194:	8b8080e7          	jalr	-1864(ra) # a48 <printf>
    a_n += 1;
 198:	00092783          	lw	a5,0(s2)
 19c:	2785                	addiw	a5,a5,1
 19e:	00f92023          	sw	a5,0(s2)
    thread_yield();
 1a2:	00000097          	auipc	ra,0x0
 1a6:	f5a080e7          	jalr	-166(ra) # fc <thread_yield>
  for (i = 0; i < 100; i++) {
 1aa:	2485                	addiw	s1,s1,1
 1ac:	ff3490e3          	bne	s1,s3,18c <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1b0:	00001597          	auipc	a1,0x1
 1b4:	bd05a583          	lw	a1,-1072(a1) # d80 <a_n>
 1b8:	00001517          	auipc	a0,0x1
 1bc:	a9850513          	addi	a0,a0,-1384 # c50 <malloc+0x150>
 1c0:	00001097          	auipc	ra,0x1
 1c4:	888080e7          	jalr	-1912(ra) # a48 <printf>

  current_thread->state = FREE;
 1c8:	00001797          	auipc	a5,0x1
 1cc:	bc87b783          	ld	a5,-1080(a5) # d90 <current_thread>
 1d0:	6709                	lui	a4,0x2
 1d2:	97ba                	add	a5,a5,a4
 1d4:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1d8:	00000097          	auipc	ra,0x0
 1dc:	e4e080e7          	jalr	-434(ra) # 26 <thread_schedule>
}
 1e0:	70a2                	ld	ra,40(sp)
 1e2:	7402                	ld	s0,32(sp)
 1e4:	64e2                	ld	s1,24(sp)
 1e6:	6942                	ld	s2,16(sp)
 1e8:	69a2                	ld	s3,8(sp)
 1ea:	6a02                	ld	s4,0(sp)
 1ec:	6145                	addi	sp,sp,48
 1ee:	8082                	ret

00000000000001f0 <thread_b>:

void 
thread_b(void)
{
 1f0:	7179                	addi	sp,sp,-48
 1f2:	f406                	sd	ra,40(sp)
 1f4:	f022                	sd	s0,32(sp)
 1f6:	ec26                	sd	s1,24(sp)
 1f8:	e84a                	sd	s2,16(sp)
 1fa:	e44e                	sd	s3,8(sp)
 1fc:	e052                	sd	s4,0(sp)
 1fe:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 200:	00001517          	auipc	a0,0x1
 204:	a7050513          	addi	a0,a0,-1424 # c70 <malloc+0x170>
 208:	00001097          	auipc	ra,0x1
 20c:	840080e7          	jalr	-1984(ra) # a48 <printf>
  b_started = 1;
 210:	4785                	li	a5,1
 212:	00001717          	auipc	a4,0x1
 216:	b6f72b23          	sw	a5,-1162(a4) # d88 <b_started>
  while(a_started == 0 || c_started == 0)
 21a:	00001497          	auipc	s1,0x1
 21e:	b7248493          	addi	s1,s1,-1166 # d8c <a_started>
 222:	00001917          	auipc	s2,0x1
 226:	b6290913          	addi	s2,s2,-1182 # d84 <c_started>
 22a:	a029                	j	234 <thread_b+0x44>
    thread_yield();
 22c:	00000097          	auipc	ra,0x0
 230:	ed0080e7          	jalr	-304(ra) # fc <thread_yield>
  while(a_started == 0 || c_started == 0)
 234:	409c                	lw	a5,0(s1)
 236:	2781                	sext.w	a5,a5
 238:	dbf5                	beqz	a5,22c <thread_b+0x3c>
 23a:	00092783          	lw	a5,0(s2)
 23e:	2781                	sext.w	a5,a5
 240:	d7f5                	beqz	a5,22c <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 242:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 244:	00001a17          	auipc	s4,0x1
 248:	a44a0a13          	addi	s4,s4,-1468 # c88 <malloc+0x188>
    b_n += 1;
 24c:	00001917          	auipc	s2,0x1
 250:	b3090913          	addi	s2,s2,-1232 # d7c <b_n>
  for (i = 0; i < 100; i++) {
 254:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 258:	85a6                	mv	a1,s1
 25a:	8552                	mv	a0,s4
 25c:	00000097          	auipc	ra,0x0
 260:	7ec080e7          	jalr	2028(ra) # a48 <printf>
    b_n += 1;
 264:	00092783          	lw	a5,0(s2)
 268:	2785                	addiw	a5,a5,1
 26a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 26e:	00000097          	auipc	ra,0x0
 272:	e8e080e7          	jalr	-370(ra) # fc <thread_yield>
  for (i = 0; i < 100; i++) {
 276:	2485                	addiw	s1,s1,1
 278:	ff3490e3          	bne	s1,s3,258 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 27c:	00001597          	auipc	a1,0x1
 280:	b005a583          	lw	a1,-1280(a1) # d7c <b_n>
 284:	00001517          	auipc	a0,0x1
 288:	a1450513          	addi	a0,a0,-1516 # c98 <malloc+0x198>
 28c:	00000097          	auipc	ra,0x0
 290:	7bc080e7          	jalr	1980(ra) # a48 <printf>

  current_thread->state = FREE;
 294:	00001797          	auipc	a5,0x1
 298:	afc7b783          	ld	a5,-1284(a5) # d90 <current_thread>
 29c:	6709                	lui	a4,0x2
 29e:	97ba                	add	a5,a5,a4
 2a0:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 2a4:	00000097          	auipc	ra,0x0
 2a8:	d82080e7          	jalr	-638(ra) # 26 <thread_schedule>
}
 2ac:	70a2                	ld	ra,40(sp)
 2ae:	7402                	ld	s0,32(sp)
 2b0:	64e2                	ld	s1,24(sp)
 2b2:	6942                	ld	s2,16(sp)
 2b4:	69a2                	ld	s3,8(sp)
 2b6:	6a02                	ld	s4,0(sp)
 2b8:	6145                	addi	sp,sp,48
 2ba:	8082                	ret

00000000000002bc <thread_c>:

void 
thread_c(void)
{
 2bc:	7179                	addi	sp,sp,-48
 2be:	f406                	sd	ra,40(sp)
 2c0:	f022                	sd	s0,32(sp)
 2c2:	ec26                	sd	s1,24(sp)
 2c4:	e84a                	sd	s2,16(sp)
 2c6:	e44e                	sd	s3,8(sp)
 2c8:	e052                	sd	s4,0(sp)
 2ca:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2cc:	00001517          	auipc	a0,0x1
 2d0:	9ec50513          	addi	a0,a0,-1556 # cb8 <malloc+0x1b8>
 2d4:	00000097          	auipc	ra,0x0
 2d8:	774080e7          	jalr	1908(ra) # a48 <printf>
  c_started = 1;
 2dc:	4785                	li	a5,1
 2de:	00001717          	auipc	a4,0x1
 2e2:	aaf72323          	sw	a5,-1370(a4) # d84 <c_started>
  while(a_started == 0 || b_started == 0)
 2e6:	00001497          	auipc	s1,0x1
 2ea:	aa648493          	addi	s1,s1,-1370 # d8c <a_started>
 2ee:	00001917          	auipc	s2,0x1
 2f2:	a9a90913          	addi	s2,s2,-1382 # d88 <b_started>
 2f6:	a029                	j	300 <thread_c+0x44>
    thread_yield();
 2f8:	00000097          	auipc	ra,0x0
 2fc:	e04080e7          	jalr	-508(ra) # fc <thread_yield>
  while(a_started == 0 || b_started == 0)
 300:	409c                	lw	a5,0(s1)
 302:	2781                	sext.w	a5,a5
 304:	dbf5                	beqz	a5,2f8 <thread_c+0x3c>
 306:	00092783          	lw	a5,0(s2)
 30a:	2781                	sext.w	a5,a5
 30c:	d7f5                	beqz	a5,2f8 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 30e:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 310:	00001a17          	auipc	s4,0x1
 314:	9c0a0a13          	addi	s4,s4,-1600 # cd0 <malloc+0x1d0>
    c_n += 1;
 318:	00001917          	auipc	s2,0x1
 31c:	a6090913          	addi	s2,s2,-1440 # d78 <c_n>
  for (i = 0; i < 100; i++) {
 320:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 324:	85a6                	mv	a1,s1
 326:	8552                	mv	a0,s4
 328:	00000097          	auipc	ra,0x0
 32c:	720080e7          	jalr	1824(ra) # a48 <printf>
    c_n += 1;
 330:	00092783          	lw	a5,0(s2)
 334:	2785                	addiw	a5,a5,1
 336:	00f92023          	sw	a5,0(s2)
    thread_yield();
 33a:	00000097          	auipc	ra,0x0
 33e:	dc2080e7          	jalr	-574(ra) # fc <thread_yield>
  for (i = 0; i < 100; i++) {
 342:	2485                	addiw	s1,s1,1
 344:	ff3490e3          	bne	s1,s3,324 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 348:	00001597          	auipc	a1,0x1
 34c:	a305a583          	lw	a1,-1488(a1) # d78 <c_n>
 350:	00001517          	auipc	a0,0x1
 354:	99050513          	addi	a0,a0,-1648 # ce0 <malloc+0x1e0>
 358:	00000097          	auipc	ra,0x0
 35c:	6f0080e7          	jalr	1776(ra) # a48 <printf>

  current_thread->state = FREE;
 360:	00001797          	auipc	a5,0x1
 364:	a307b783          	ld	a5,-1488(a5) # d90 <current_thread>
 368:	6709                	lui	a4,0x2
 36a:	97ba                	add	a5,a5,a4
 36c:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 370:	00000097          	auipc	ra,0x0
 374:	cb6080e7          	jalr	-842(ra) # 26 <thread_schedule>
}
 378:	70a2                	ld	ra,40(sp)
 37a:	7402                	ld	s0,32(sp)
 37c:	64e2                	ld	s1,24(sp)
 37e:	6942                	ld	s2,16(sp)
 380:	69a2                	ld	s3,8(sp)
 382:	6a02                	ld	s4,0(sp)
 384:	6145                	addi	sp,sp,48
 386:	8082                	ret

0000000000000388 <main>:

int 
main(int argc, char *argv[]) 
{
 388:	1141                	addi	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 390:	00001797          	auipc	a5,0x1
 394:	9e07aa23          	sw	zero,-1548(a5) # d84 <c_started>
 398:	00001797          	auipc	a5,0x1
 39c:	9e07a823          	sw	zero,-1552(a5) # d88 <b_started>
 3a0:	00001797          	auipc	a5,0x1
 3a4:	9e07a623          	sw	zero,-1556(a5) # d8c <a_started>
  a_n = b_n = c_n = 0;
 3a8:	00001797          	auipc	a5,0x1
 3ac:	9c07a823          	sw	zero,-1584(a5) # d78 <c_n>
 3b0:	00001797          	auipc	a5,0x1
 3b4:	9c07a623          	sw	zero,-1588(a5) # d7c <b_n>
 3b8:	00001797          	auipc	a5,0x1
 3bc:	9c07a423          	sw	zero,-1592(a5) # d80 <a_n>
  thread_init();
 3c0:	00000097          	auipc	ra,0x0
 3c4:	c40080e7          	jalr	-960(ra) # 0 <thread_init>
  thread_create(thread_a);
 3c8:	00000517          	auipc	a0,0x0
 3cc:	d5c50513          	addi	a0,a0,-676 # 124 <thread_a>
 3d0:	00000097          	auipc	ra,0x0
 3d4:	ce8080e7          	jalr	-792(ra) # b8 <thread_create>
  thread_create(thread_b);
 3d8:	00000517          	auipc	a0,0x0
 3dc:	e1850513          	addi	a0,a0,-488 # 1f0 <thread_b>
 3e0:	00000097          	auipc	ra,0x0
 3e4:	cd8080e7          	jalr	-808(ra) # b8 <thread_create>
  thread_create(thread_c);
 3e8:	00000517          	auipc	a0,0x0
 3ec:	ed450513          	addi	a0,a0,-300 # 2bc <thread_c>
 3f0:	00000097          	auipc	ra,0x0
 3f4:	cc8080e7          	jalr	-824(ra) # b8 <thread_create>
  thread_schedule();
 3f8:	00000097          	auipc	ra,0x0
 3fc:	c2e080e7          	jalr	-978(ra) # 26 <thread_schedule>
  exit(0);
 400:	4501                	li	a0,0
 402:	00000097          	auipc	ra,0x0
 406:	2de080e7          	jalr	734(ra) # 6e0 <exit>

000000000000040a <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	sd ra, 0(a0)
 40a:	00153023          	sd	ra,0(a0)
	sd sp, 8(a0)
 40e:	00253423          	sd	sp,8(a0)
	sd s0, 16(a0)
 412:	e900                	sd	s0,16(a0)
	sd s1, 24(a0)
 414:	ed04                	sd	s1,24(a0)
	sd s2, 32(a0)
 416:	03253023          	sd	s2,32(a0)
	sd s3, 40(a0)
 41a:	03353423          	sd	s3,40(a0)
	sd s4, 48(a0)
 41e:	03453823          	sd	s4,48(a0)
	sd s5, 56(a0)
 422:	03553c23          	sd	s5,56(a0)
	sd s6, 64(a0)
 426:	05653023          	sd	s6,64(a0)
	sd s7, 72(a0)
 42a:	05753423          	sd	s7,72(a0)
	sd s8, 80(a0)
 42e:	05853823          	sd	s8,80(a0)
	sd s9, 88(a0)
 432:	05953c23          	sd	s9,88(a0)
	sd s10, 96(a0)
 436:	07a53023          	sd	s10,96(a0)
	sd s11, 104(a0)
 43a:	07b53423          	sd	s11,104(a0)

	ld ra, 0(a1)
 43e:	0005b083          	ld	ra,0(a1)
	ld sp, 8(a1)
 442:	0085b103          	ld	sp,8(a1)
	ld s0, 16(a1)
 446:	6980                	ld	s0,16(a1)
	ld s1, 24(a1)
 448:	6d84                	ld	s1,24(a1)
	ld s2, 32(a1)
 44a:	0205b903          	ld	s2,32(a1)
	ld s3, 40(a1)
 44e:	0285b983          	ld	s3,40(a1)
	ld s4, 48(a1)
 452:	0305ba03          	ld	s4,48(a1)
	ld s5, 56(a1)
 456:	0385ba83          	ld	s5,56(a1)
	ld s6, 64(a1)
 45a:	0405bb03          	ld	s6,64(a1)
	ld s7, 72(a1)
 45e:	0485bb83          	ld	s7,72(a1)
	ld s8, 80(a1)
 462:	0505bc03          	ld	s8,80(a1)
	ld s9, 88(a1)
 466:	0585bc83          	ld	s9,88(a1)
	ld s10, 96(a1)
 46a:	0605bd03          	ld	s10,96(a1)
	ld s11, 104(a1)
 46e:	0685bd83          	ld	s11,104(a1)

	ret    /* return to ra */
 472:	8082                	ret

0000000000000474 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 474:	1141                	addi	sp,sp,-16
 476:	e422                	sd	s0,8(sp)
 478:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 47a:	87aa                	mv	a5,a0
 47c:	0585                	addi	a1,a1,1
 47e:	0785                	addi	a5,a5,1
 480:	fff5c703          	lbu	a4,-1(a1)
 484:	fee78fa3          	sb	a4,-1(a5)
 488:	fb75                	bnez	a4,47c <strcpy+0x8>
    ;
  return os;
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret

0000000000000490 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 490:	1141                	addi	sp,sp,-16
 492:	e422                	sd	s0,8(sp)
 494:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 496:	00054783          	lbu	a5,0(a0)
 49a:	cb91                	beqz	a5,4ae <strcmp+0x1e>
 49c:	0005c703          	lbu	a4,0(a1)
 4a0:	00f71763          	bne	a4,a5,4ae <strcmp+0x1e>
    p++, q++;
 4a4:	0505                	addi	a0,a0,1
 4a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4a8:	00054783          	lbu	a5,0(a0)
 4ac:	fbe5                	bnez	a5,49c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4ae:	0005c503          	lbu	a0,0(a1)
}
 4b2:	40a7853b          	subw	a0,a5,a0
 4b6:	6422                	ld	s0,8(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret

00000000000004bc <strlen>:

uint
strlen(const char *s)
{
 4bc:	1141                	addi	sp,sp,-16
 4be:	e422                	sd	s0,8(sp)
 4c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4c2:	00054783          	lbu	a5,0(a0)
 4c6:	cf91                	beqz	a5,4e2 <strlen+0x26>
 4c8:	0505                	addi	a0,a0,1
 4ca:	87aa                	mv	a5,a0
 4cc:	86be                	mv	a3,a5
 4ce:	0785                	addi	a5,a5,1
 4d0:	fff7c703          	lbu	a4,-1(a5)
 4d4:	ff65                	bnez	a4,4cc <strlen+0x10>
 4d6:	40a6853b          	subw	a0,a3,a0
 4da:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 4dc:	6422                	ld	s0,8(sp)
 4de:	0141                	addi	sp,sp,16
 4e0:	8082                	ret
  for(n = 0; s[n]; n++)
 4e2:	4501                	li	a0,0
 4e4:	bfe5                	j	4dc <strlen+0x20>

00000000000004e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4e6:	1141                	addi	sp,sp,-16
 4e8:	e422                	sd	s0,8(sp)
 4ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4ec:	ca19                	beqz	a2,502 <memset+0x1c>
 4ee:	87aa                	mv	a5,a0
 4f0:	1602                	slli	a2,a2,0x20
 4f2:	9201                	srli	a2,a2,0x20
 4f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4fc:	0785                	addi	a5,a5,1
 4fe:	fee79de3          	bne	a5,a4,4f8 <memset+0x12>
  }
  return dst;
}
 502:	6422                	ld	s0,8(sp)
 504:	0141                	addi	sp,sp,16
 506:	8082                	ret

0000000000000508 <strchr>:

char*
strchr(const char *s, char c)
{
 508:	1141                	addi	sp,sp,-16
 50a:	e422                	sd	s0,8(sp)
 50c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 50e:	00054783          	lbu	a5,0(a0)
 512:	cb99                	beqz	a5,528 <strchr+0x20>
    if(*s == c)
 514:	00f58763          	beq	a1,a5,522 <strchr+0x1a>
  for(; *s; s++)
 518:	0505                	addi	a0,a0,1
 51a:	00054783          	lbu	a5,0(a0)
 51e:	fbfd                	bnez	a5,514 <strchr+0xc>
      return (char*)s;
  return 0;
 520:	4501                	li	a0,0
}
 522:	6422                	ld	s0,8(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret
  return 0;
 528:	4501                	li	a0,0
 52a:	bfe5                	j	522 <strchr+0x1a>

000000000000052c <gets>:

char*
gets(char *buf, int max)
{
 52c:	711d                	addi	sp,sp,-96
 52e:	ec86                	sd	ra,88(sp)
 530:	e8a2                	sd	s0,80(sp)
 532:	e4a6                	sd	s1,72(sp)
 534:	e0ca                	sd	s2,64(sp)
 536:	fc4e                	sd	s3,56(sp)
 538:	f852                	sd	s4,48(sp)
 53a:	f456                	sd	s5,40(sp)
 53c:	f05a                	sd	s6,32(sp)
 53e:	ec5e                	sd	s7,24(sp)
 540:	1080                	addi	s0,sp,96
 542:	8baa                	mv	s7,a0
 544:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 546:	892a                	mv	s2,a0
 548:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 54a:	4aa9                	li	s5,10
 54c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 54e:	89a6                	mv	s3,s1
 550:	2485                	addiw	s1,s1,1
 552:	0344d863          	bge	s1,s4,582 <gets+0x56>
    cc = read(0, &c, 1);
 556:	4605                	li	a2,1
 558:	faf40593          	addi	a1,s0,-81
 55c:	4501                	li	a0,0
 55e:	00000097          	auipc	ra,0x0
 562:	19a080e7          	jalr	410(ra) # 6f8 <read>
    if(cc < 1)
 566:	00a05e63          	blez	a0,582 <gets+0x56>
    buf[i++] = c;
 56a:	faf44783          	lbu	a5,-81(s0)
 56e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 572:	01578763          	beq	a5,s5,580 <gets+0x54>
 576:	0905                	addi	s2,s2,1
 578:	fd679be3          	bne	a5,s6,54e <gets+0x22>
    buf[i++] = c;
 57c:	89a6                	mv	s3,s1
 57e:	a011                	j	582 <gets+0x56>
 580:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 582:	99de                	add	s3,s3,s7
 584:	00098023          	sb	zero,0(s3)
  return buf;
}
 588:	855e                	mv	a0,s7
 58a:	60e6                	ld	ra,88(sp)
 58c:	6446                	ld	s0,80(sp)
 58e:	64a6                	ld	s1,72(sp)
 590:	6906                	ld	s2,64(sp)
 592:	79e2                	ld	s3,56(sp)
 594:	7a42                	ld	s4,48(sp)
 596:	7aa2                	ld	s5,40(sp)
 598:	7b02                	ld	s6,32(sp)
 59a:	6be2                	ld	s7,24(sp)
 59c:	6125                	addi	sp,sp,96
 59e:	8082                	ret

00000000000005a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 5a0:	1101                	addi	sp,sp,-32
 5a2:	ec06                	sd	ra,24(sp)
 5a4:	e822                	sd	s0,16(sp)
 5a6:	e04a                	sd	s2,0(sp)
 5a8:	1000                	addi	s0,sp,32
 5aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5ac:	4581                	li	a1,0
 5ae:	00000097          	auipc	ra,0x0
 5b2:	172080e7          	jalr	370(ra) # 720 <open>
  if(fd < 0)
 5b6:	02054663          	bltz	a0,5e2 <stat+0x42>
 5ba:	e426                	sd	s1,8(sp)
 5bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5be:	85ca                	mv	a1,s2
 5c0:	00000097          	auipc	ra,0x0
 5c4:	178080e7          	jalr	376(ra) # 738 <fstat>
 5c8:	892a                	mv	s2,a0
  close(fd);
 5ca:	8526                	mv	a0,s1
 5cc:	00000097          	auipc	ra,0x0
 5d0:	13c080e7          	jalr	316(ra) # 708 <close>
  return r;
 5d4:	64a2                	ld	s1,8(sp)
}
 5d6:	854a                	mv	a0,s2
 5d8:	60e2                	ld	ra,24(sp)
 5da:	6442                	ld	s0,16(sp)
 5dc:	6902                	ld	s2,0(sp)
 5de:	6105                	addi	sp,sp,32
 5e0:	8082                	ret
    return -1;
 5e2:	597d                	li	s2,-1
 5e4:	bfcd                	j	5d6 <stat+0x36>

00000000000005e6 <atoi>:

int
atoi(const char *s)
{
 5e6:	1141                	addi	sp,sp,-16
 5e8:	e422                	sd	s0,8(sp)
 5ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5ec:	00054683          	lbu	a3,0(a0)
 5f0:	fd06879b          	addiw	a5,a3,-48
 5f4:	0ff7f793          	zext.b	a5,a5
 5f8:	4625                	li	a2,9
 5fa:	02f66863          	bltu	a2,a5,62a <atoi+0x44>
 5fe:	872a                	mv	a4,a0
  n = 0;
 600:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 602:	0705                	addi	a4,a4,1 # 2001 <__global_pointer$+0xa90>
 604:	0025179b          	slliw	a5,a0,0x2
 608:	9fa9                	addw	a5,a5,a0
 60a:	0017979b          	slliw	a5,a5,0x1
 60e:	9fb5                	addw	a5,a5,a3
 610:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 614:	00074683          	lbu	a3,0(a4)
 618:	fd06879b          	addiw	a5,a3,-48
 61c:	0ff7f793          	zext.b	a5,a5
 620:	fef671e3          	bgeu	a2,a5,602 <atoi+0x1c>
  return n;
}
 624:	6422                	ld	s0,8(sp)
 626:	0141                	addi	sp,sp,16
 628:	8082                	ret
  n = 0;
 62a:	4501                	li	a0,0
 62c:	bfe5                	j	624 <atoi+0x3e>

000000000000062e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 62e:	1141                	addi	sp,sp,-16
 630:	e422                	sd	s0,8(sp)
 632:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 634:	02b57463          	bgeu	a0,a1,65c <memmove+0x2e>
    while(n-- > 0)
 638:	00c05f63          	blez	a2,656 <memmove+0x28>
 63c:	1602                	slli	a2,a2,0x20
 63e:	9201                	srli	a2,a2,0x20
 640:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 644:	872a                	mv	a4,a0
      *dst++ = *src++;
 646:	0585                	addi	a1,a1,1
 648:	0705                	addi	a4,a4,1
 64a:	fff5c683          	lbu	a3,-1(a1)
 64e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 652:	fef71ae3          	bne	a4,a5,646 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 656:	6422                	ld	s0,8(sp)
 658:	0141                	addi	sp,sp,16
 65a:	8082                	ret
    dst += n;
 65c:	00c50733          	add	a4,a0,a2
    src += n;
 660:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 662:	fec05ae3          	blez	a2,656 <memmove+0x28>
 666:	fff6079b          	addiw	a5,a2,-1 # 1fff <__global_pointer$+0xa8e>
 66a:	1782                	slli	a5,a5,0x20
 66c:	9381                	srli	a5,a5,0x20
 66e:	fff7c793          	not	a5,a5
 672:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 674:	15fd                	addi	a1,a1,-1
 676:	177d                	addi	a4,a4,-1
 678:	0005c683          	lbu	a3,0(a1)
 67c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 680:	fee79ae3          	bne	a5,a4,674 <memmove+0x46>
 684:	bfc9                	j	656 <memmove+0x28>

0000000000000686 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 686:	1141                	addi	sp,sp,-16
 688:	e422                	sd	s0,8(sp)
 68a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 68c:	ca05                	beqz	a2,6bc <memcmp+0x36>
 68e:	fff6069b          	addiw	a3,a2,-1
 692:	1682                	slli	a3,a3,0x20
 694:	9281                	srli	a3,a3,0x20
 696:	0685                	addi	a3,a3,1
 698:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 69a:	00054783          	lbu	a5,0(a0)
 69e:	0005c703          	lbu	a4,0(a1)
 6a2:	00e79863          	bne	a5,a4,6b2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6a6:	0505                	addi	a0,a0,1
    p2++;
 6a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6aa:	fed518e3          	bne	a0,a3,69a <memcmp+0x14>
  }
  return 0;
 6ae:	4501                	li	a0,0
 6b0:	a019                	j	6b6 <memcmp+0x30>
      return *p1 - *p2;
 6b2:	40e7853b          	subw	a0,a5,a4
}
 6b6:	6422                	ld	s0,8(sp)
 6b8:	0141                	addi	sp,sp,16
 6ba:	8082                	ret
  return 0;
 6bc:	4501                	li	a0,0
 6be:	bfe5                	j	6b6 <memcmp+0x30>

00000000000006c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6c0:	1141                	addi	sp,sp,-16
 6c2:	e406                	sd	ra,8(sp)
 6c4:	e022                	sd	s0,0(sp)
 6c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6c8:	00000097          	auipc	ra,0x0
 6cc:	f66080e7          	jalr	-154(ra) # 62e <memmove>
}
 6d0:	60a2                	ld	ra,8(sp)
 6d2:	6402                	ld	s0,0(sp)
 6d4:	0141                	addi	sp,sp,16
 6d6:	8082                	ret

00000000000006d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6d8:	4885                	li	a7,1
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6e0:	4889                	li	a7,2
 ecall
 6e2:	00000073          	ecall
 ret
 6e6:	8082                	ret

00000000000006e8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6e8:	488d                	li	a7,3
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6f0:	4891                	li	a7,4
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <read>:
.global read
read:
 li a7, SYS_read
 6f8:	4895                	li	a7,5
 ecall
 6fa:	00000073          	ecall
 ret
 6fe:	8082                	ret

0000000000000700 <write>:
.global write
write:
 li a7, SYS_write
 700:	48c1                	li	a7,16
 ecall
 702:	00000073          	ecall
 ret
 706:	8082                	ret

0000000000000708 <close>:
.global close
close:
 li a7, SYS_close
 708:	48d5                	li	a7,21
 ecall
 70a:	00000073          	ecall
 ret
 70e:	8082                	ret

0000000000000710 <kill>:
.global kill
kill:
 li a7, SYS_kill
 710:	4899                	li	a7,6
 ecall
 712:	00000073          	ecall
 ret
 716:	8082                	ret

0000000000000718 <exec>:
.global exec
exec:
 li a7, SYS_exec
 718:	489d                	li	a7,7
 ecall
 71a:	00000073          	ecall
 ret
 71e:	8082                	ret

0000000000000720 <open>:
.global open
open:
 li a7, SYS_open
 720:	48bd                	li	a7,15
 ecall
 722:	00000073          	ecall
 ret
 726:	8082                	ret

0000000000000728 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 728:	48c5                	li	a7,17
 ecall
 72a:	00000073          	ecall
 ret
 72e:	8082                	ret

0000000000000730 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 730:	48c9                	li	a7,18
 ecall
 732:	00000073          	ecall
 ret
 736:	8082                	ret

0000000000000738 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 738:	48a1                	li	a7,8
 ecall
 73a:	00000073          	ecall
 ret
 73e:	8082                	ret

0000000000000740 <link>:
.global link
link:
 li a7, SYS_link
 740:	48cd                	li	a7,19
 ecall
 742:	00000073          	ecall
 ret
 746:	8082                	ret

0000000000000748 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 748:	48d1                	li	a7,20
 ecall
 74a:	00000073          	ecall
 ret
 74e:	8082                	ret

0000000000000750 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 750:	48a5                	li	a7,9
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <dup>:
.global dup
dup:
 li a7, SYS_dup
 758:	48a9                	li	a7,10
 ecall
 75a:	00000073          	ecall
 ret
 75e:	8082                	ret

0000000000000760 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 760:	48ad                	li	a7,11
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 768:	48b1                	li	a7,12
 ecall
 76a:	00000073          	ecall
 ret
 76e:	8082                	ret

0000000000000770 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 770:	48b5                	li	a7,13
 ecall
 772:	00000073          	ecall
 ret
 776:	8082                	ret

0000000000000778 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 778:	48b9                	li	a7,14
 ecall
 77a:	00000073          	ecall
 ret
 77e:	8082                	ret

0000000000000780 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 780:	1101                	addi	sp,sp,-32
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 78c:	4605                	li	a2,1
 78e:	fef40593          	addi	a1,s0,-17
 792:	00000097          	auipc	ra,0x0
 796:	f6e080e7          	jalr	-146(ra) # 700 <write>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6105                	addi	sp,sp,32
 7a0:	8082                	ret

00000000000007a2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7a2:	7139                	addi	sp,sp,-64
 7a4:	fc06                	sd	ra,56(sp)
 7a6:	f822                	sd	s0,48(sp)
 7a8:	f426                	sd	s1,40(sp)
 7aa:	0080                	addi	s0,sp,64
 7ac:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7ae:	c299                	beqz	a3,7b4 <printint+0x12>
 7b0:	0805cb63          	bltz	a1,846 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7b4:	2581                	sext.w	a1,a1
  neg = 0;
 7b6:	4881                	li	a7,0
 7b8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7bc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7be:	2601                	sext.w	a2,a2
 7c0:	00000517          	auipc	a0,0x0
 7c4:	5a050513          	addi	a0,a0,1440 # d60 <digits>
 7c8:	883a                	mv	a6,a4
 7ca:	2705                	addiw	a4,a4,1
 7cc:	02c5f7bb          	remuw	a5,a1,a2
 7d0:	1782                	slli	a5,a5,0x20
 7d2:	9381                	srli	a5,a5,0x20
 7d4:	97aa                	add	a5,a5,a0
 7d6:	0007c783          	lbu	a5,0(a5)
 7da:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7de:	0005879b          	sext.w	a5,a1
 7e2:	02c5d5bb          	divuw	a1,a1,a2
 7e6:	0685                	addi	a3,a3,1
 7e8:	fec7f0e3          	bgeu	a5,a2,7c8 <printint+0x26>
  if(neg)
 7ec:	00088c63          	beqz	a7,804 <printint+0x62>
    buf[i++] = '-';
 7f0:	fd070793          	addi	a5,a4,-48
 7f4:	00878733          	add	a4,a5,s0
 7f8:	02d00793          	li	a5,45
 7fc:	fef70823          	sb	a5,-16(a4)
 800:	0028071b          	addiw	a4,a6,2 # 2002 <__global_pointer$+0xa91>

  while(--i >= 0)
 804:	02e05c63          	blez	a4,83c <printint+0x9a>
 808:	f04a                	sd	s2,32(sp)
 80a:	ec4e                	sd	s3,24(sp)
 80c:	fc040793          	addi	a5,s0,-64
 810:	00e78933          	add	s2,a5,a4
 814:	fff78993          	addi	s3,a5,-1
 818:	99ba                	add	s3,s3,a4
 81a:	377d                	addiw	a4,a4,-1
 81c:	1702                	slli	a4,a4,0x20
 81e:	9301                	srli	a4,a4,0x20
 820:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 824:	fff94583          	lbu	a1,-1(s2)
 828:	8526                	mv	a0,s1
 82a:	00000097          	auipc	ra,0x0
 82e:	f56080e7          	jalr	-170(ra) # 780 <putc>
  while(--i >= 0)
 832:	197d                	addi	s2,s2,-1
 834:	ff3918e3          	bne	s2,s3,824 <printint+0x82>
 838:	7902                	ld	s2,32(sp)
 83a:	69e2                	ld	s3,24(sp)
}
 83c:	70e2                	ld	ra,56(sp)
 83e:	7442                	ld	s0,48(sp)
 840:	74a2                	ld	s1,40(sp)
 842:	6121                	addi	sp,sp,64
 844:	8082                	ret
    x = -xx;
 846:	40b005bb          	negw	a1,a1
    neg = 1;
 84a:	4885                	li	a7,1
    x = -xx;
 84c:	b7b5                	j	7b8 <printint+0x16>

000000000000084e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 84e:	715d                	addi	sp,sp,-80
 850:	e486                	sd	ra,72(sp)
 852:	e0a2                	sd	s0,64(sp)
 854:	f84a                	sd	s2,48(sp)
 856:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 858:	0005c903          	lbu	s2,0(a1)
 85c:	1a090a63          	beqz	s2,a10 <vprintf+0x1c2>
 860:	fc26                	sd	s1,56(sp)
 862:	f44e                	sd	s3,40(sp)
 864:	f052                	sd	s4,32(sp)
 866:	ec56                	sd	s5,24(sp)
 868:	e85a                	sd	s6,16(sp)
 86a:	e45e                	sd	s7,8(sp)
 86c:	8aaa                	mv	s5,a0
 86e:	8bb2                	mv	s7,a2
 870:	00158493          	addi	s1,a1,1
  state = 0;
 874:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 876:	02500a13          	li	s4,37
 87a:	4b55                	li	s6,21
 87c:	a839                	j	89a <vprintf+0x4c>
        putc(fd, c);
 87e:	85ca                	mv	a1,s2
 880:	8556                	mv	a0,s5
 882:	00000097          	auipc	ra,0x0
 886:	efe080e7          	jalr	-258(ra) # 780 <putc>
 88a:	a019                	j	890 <vprintf+0x42>
    } else if(state == '%'){
 88c:	01498d63          	beq	s3,s4,8a6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 890:	0485                	addi	s1,s1,1
 892:	fff4c903          	lbu	s2,-1(s1)
 896:	16090763          	beqz	s2,a04 <vprintf+0x1b6>
    if(state == 0){
 89a:	fe0999e3          	bnez	s3,88c <vprintf+0x3e>
      if(c == '%'){
 89e:	ff4910e3          	bne	s2,s4,87e <vprintf+0x30>
        state = '%';
 8a2:	89d2                	mv	s3,s4
 8a4:	b7f5                	j	890 <vprintf+0x42>
      if(c == 'd'){
 8a6:	13490463          	beq	s2,s4,9ce <vprintf+0x180>
 8aa:	f9d9079b          	addiw	a5,s2,-99
 8ae:	0ff7f793          	zext.b	a5,a5
 8b2:	12fb6763          	bltu	s6,a5,9e0 <vprintf+0x192>
 8b6:	f9d9079b          	addiw	a5,s2,-99
 8ba:	0ff7f713          	zext.b	a4,a5
 8be:	12eb6163          	bltu	s6,a4,9e0 <vprintf+0x192>
 8c2:	00271793          	slli	a5,a4,0x2
 8c6:	00000717          	auipc	a4,0x0
 8ca:	44270713          	addi	a4,a4,1090 # d08 <malloc+0x208>
 8ce:	97ba                	add	a5,a5,a4
 8d0:	439c                	lw	a5,0(a5)
 8d2:	97ba                	add	a5,a5,a4
 8d4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8d6:	008b8913          	addi	s2,s7,8
 8da:	4685                	li	a3,1
 8dc:	4629                	li	a2,10
 8de:	000ba583          	lw	a1,0(s7)
 8e2:	8556                	mv	a0,s5
 8e4:	00000097          	auipc	ra,0x0
 8e8:	ebe080e7          	jalr	-322(ra) # 7a2 <printint>
 8ec:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8ee:	4981                	li	s3,0
 8f0:	b745                	j	890 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8f2:	008b8913          	addi	s2,s7,8
 8f6:	4681                	li	a3,0
 8f8:	4629                	li	a2,10
 8fa:	000ba583          	lw	a1,0(s7)
 8fe:	8556                	mv	a0,s5
 900:	00000097          	auipc	ra,0x0
 904:	ea2080e7          	jalr	-350(ra) # 7a2 <printint>
 908:	8bca                	mv	s7,s2
      state = 0;
 90a:	4981                	li	s3,0
 90c:	b751                	j	890 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 90e:	008b8913          	addi	s2,s7,8
 912:	4681                	li	a3,0
 914:	4641                	li	a2,16
 916:	000ba583          	lw	a1,0(s7)
 91a:	8556                	mv	a0,s5
 91c:	00000097          	auipc	ra,0x0
 920:	e86080e7          	jalr	-378(ra) # 7a2 <printint>
 924:	8bca                	mv	s7,s2
      state = 0;
 926:	4981                	li	s3,0
 928:	b7a5                	j	890 <vprintf+0x42>
 92a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 92c:	008b8c13          	addi	s8,s7,8
 930:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 934:	03000593          	li	a1,48
 938:	8556                	mv	a0,s5
 93a:	00000097          	auipc	ra,0x0
 93e:	e46080e7          	jalr	-442(ra) # 780 <putc>
  putc(fd, 'x');
 942:	07800593          	li	a1,120
 946:	8556                	mv	a0,s5
 948:	00000097          	auipc	ra,0x0
 94c:	e38080e7          	jalr	-456(ra) # 780 <putc>
 950:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 952:	00000b97          	auipc	s7,0x0
 956:	40eb8b93          	addi	s7,s7,1038 # d60 <digits>
 95a:	03c9d793          	srli	a5,s3,0x3c
 95e:	97de                	add	a5,a5,s7
 960:	0007c583          	lbu	a1,0(a5)
 964:	8556                	mv	a0,s5
 966:	00000097          	auipc	ra,0x0
 96a:	e1a080e7          	jalr	-486(ra) # 780 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 96e:	0992                	slli	s3,s3,0x4
 970:	397d                	addiw	s2,s2,-1
 972:	fe0914e3          	bnez	s2,95a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 976:	8be2                	mv	s7,s8
      state = 0;
 978:	4981                	li	s3,0
 97a:	6c02                	ld	s8,0(sp)
 97c:	bf11                	j	890 <vprintf+0x42>
        s = va_arg(ap, char*);
 97e:	008b8993          	addi	s3,s7,8
 982:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 986:	02090163          	beqz	s2,9a8 <vprintf+0x15a>
        while(*s != 0){
 98a:	00094583          	lbu	a1,0(s2)
 98e:	c9a5                	beqz	a1,9fe <vprintf+0x1b0>
          putc(fd, *s);
 990:	8556                	mv	a0,s5
 992:	00000097          	auipc	ra,0x0
 996:	dee080e7          	jalr	-530(ra) # 780 <putc>
          s++;
 99a:	0905                	addi	s2,s2,1
        while(*s != 0){
 99c:	00094583          	lbu	a1,0(s2)
 9a0:	f9e5                	bnez	a1,990 <vprintf+0x142>
        s = va_arg(ap, char*);
 9a2:	8bce                	mv	s7,s3
      state = 0;
 9a4:	4981                	li	s3,0
 9a6:	b5ed                	j	890 <vprintf+0x42>
          s = "(null)";
 9a8:	00000917          	auipc	s2,0x0
 9ac:	35890913          	addi	s2,s2,856 # d00 <malloc+0x200>
        while(*s != 0){
 9b0:	02800593          	li	a1,40
 9b4:	bff1                	j	990 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 9b6:	008b8913          	addi	s2,s7,8
 9ba:	000bc583          	lbu	a1,0(s7)
 9be:	8556                	mv	a0,s5
 9c0:	00000097          	auipc	ra,0x0
 9c4:	dc0080e7          	jalr	-576(ra) # 780 <putc>
 9c8:	8bca                	mv	s7,s2
      state = 0;
 9ca:	4981                	li	s3,0
 9cc:	b5d1                	j	890 <vprintf+0x42>
        putc(fd, c);
 9ce:	02500593          	li	a1,37
 9d2:	8556                	mv	a0,s5
 9d4:	00000097          	auipc	ra,0x0
 9d8:	dac080e7          	jalr	-596(ra) # 780 <putc>
      state = 0;
 9dc:	4981                	li	s3,0
 9de:	bd4d                	j	890 <vprintf+0x42>
        putc(fd, '%');
 9e0:	02500593          	li	a1,37
 9e4:	8556                	mv	a0,s5
 9e6:	00000097          	auipc	ra,0x0
 9ea:	d9a080e7          	jalr	-614(ra) # 780 <putc>
        putc(fd, c);
 9ee:	85ca                	mv	a1,s2
 9f0:	8556                	mv	a0,s5
 9f2:	00000097          	auipc	ra,0x0
 9f6:	d8e080e7          	jalr	-626(ra) # 780 <putc>
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	bd51                	j	890 <vprintf+0x42>
        s = va_arg(ap, char*);
 9fe:	8bce                	mv	s7,s3
      state = 0;
 a00:	4981                	li	s3,0
 a02:	b579                	j	890 <vprintf+0x42>
 a04:	74e2                	ld	s1,56(sp)
 a06:	79a2                	ld	s3,40(sp)
 a08:	7a02                	ld	s4,32(sp)
 a0a:	6ae2                	ld	s5,24(sp)
 a0c:	6b42                	ld	s6,16(sp)
 a0e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 a10:	60a6                	ld	ra,72(sp)
 a12:	6406                	ld	s0,64(sp)
 a14:	7942                	ld	s2,48(sp)
 a16:	6161                	addi	sp,sp,80
 a18:	8082                	ret

0000000000000a1a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a1a:	715d                	addi	sp,sp,-80
 a1c:	ec06                	sd	ra,24(sp)
 a1e:	e822                	sd	s0,16(sp)
 a20:	1000                	addi	s0,sp,32
 a22:	e010                	sd	a2,0(s0)
 a24:	e414                	sd	a3,8(s0)
 a26:	e818                	sd	a4,16(s0)
 a28:	ec1c                	sd	a5,24(s0)
 a2a:	03043023          	sd	a6,32(s0)
 a2e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a32:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a36:	8622                	mv	a2,s0
 a38:	00000097          	auipc	ra,0x0
 a3c:	e16080e7          	jalr	-490(ra) # 84e <vprintf>
}
 a40:	60e2                	ld	ra,24(sp)
 a42:	6442                	ld	s0,16(sp)
 a44:	6161                	addi	sp,sp,80
 a46:	8082                	ret

0000000000000a48 <printf>:

void
printf(const char *fmt, ...)
{
 a48:	711d                	addi	sp,sp,-96
 a4a:	ec06                	sd	ra,24(sp)
 a4c:	e822                	sd	s0,16(sp)
 a4e:	1000                	addi	s0,sp,32
 a50:	e40c                	sd	a1,8(s0)
 a52:	e810                	sd	a2,16(s0)
 a54:	ec14                	sd	a3,24(s0)
 a56:	f018                	sd	a4,32(s0)
 a58:	f41c                	sd	a5,40(s0)
 a5a:	03043823          	sd	a6,48(s0)
 a5e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a62:	00840613          	addi	a2,s0,8
 a66:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a6a:	85aa                	mv	a1,a0
 a6c:	4505                	li	a0,1
 a6e:	00000097          	auipc	ra,0x0
 a72:	de0080e7          	jalr	-544(ra) # 84e <vprintf>
}
 a76:	60e2                	ld	ra,24(sp)
 a78:	6442                	ld	s0,16(sp)
 a7a:	6125                	addi	sp,sp,96
 a7c:	8082                	ret

0000000000000a7e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a7e:	1141                	addi	sp,sp,-16
 a80:	e422                	sd	s0,8(sp)
 a82:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a84:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a88:	00000797          	auipc	a5,0x0
 a8c:	3107b783          	ld	a5,784(a5) # d98 <freep>
 a90:	a02d                	j	aba <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a92:	4618                	lw	a4,8(a2)
 a94:	9f2d                	addw	a4,a4,a1
 a96:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a9a:	6398                	ld	a4,0(a5)
 a9c:	6310                	ld	a2,0(a4)
 a9e:	a83d                	j	adc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aa0:	ff852703          	lw	a4,-8(a0)
 aa4:	9f31                	addw	a4,a4,a2
 aa6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 aa8:	ff053683          	ld	a3,-16(a0)
 aac:	a091                	j	af0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aae:	6398                	ld	a4,0(a5)
 ab0:	00e7e463          	bltu	a5,a4,ab8 <free+0x3a>
 ab4:	00e6ea63          	bltu	a3,a4,ac8 <free+0x4a>
{
 ab8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aba:	fed7fae3          	bgeu	a5,a3,aae <free+0x30>
 abe:	6398                	ld	a4,0(a5)
 ac0:	00e6e463          	bltu	a3,a4,ac8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac4:	fee7eae3          	bltu	a5,a4,ab8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 ac8:	ff852583          	lw	a1,-8(a0)
 acc:	6390                	ld	a2,0(a5)
 ace:	02059813          	slli	a6,a1,0x20
 ad2:	01c85713          	srli	a4,a6,0x1c
 ad6:	9736                	add	a4,a4,a3
 ad8:	fae60de3          	beq	a2,a4,a92 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 adc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ae0:	4790                	lw	a2,8(a5)
 ae2:	02061593          	slli	a1,a2,0x20
 ae6:	01c5d713          	srli	a4,a1,0x1c
 aea:	973e                	add	a4,a4,a5
 aec:	fae68ae3          	beq	a3,a4,aa0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 af0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 af2:	00000717          	auipc	a4,0x0
 af6:	2af73323          	sd	a5,678(a4) # d98 <freep>
}
 afa:	6422                	ld	s0,8(sp)
 afc:	0141                	addi	sp,sp,16
 afe:	8082                	ret

0000000000000b00 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b00:	7139                	addi	sp,sp,-64
 b02:	fc06                	sd	ra,56(sp)
 b04:	f822                	sd	s0,48(sp)
 b06:	f426                	sd	s1,40(sp)
 b08:	ec4e                	sd	s3,24(sp)
 b0a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b0c:	02051493          	slli	s1,a0,0x20
 b10:	9081                	srli	s1,s1,0x20
 b12:	04bd                	addi	s1,s1,15
 b14:	8091                	srli	s1,s1,0x4
 b16:	0014899b          	addiw	s3,s1,1
 b1a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b1c:	00000517          	auipc	a0,0x0
 b20:	27c53503          	ld	a0,636(a0) # d98 <freep>
 b24:	c915                	beqz	a0,b58 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b26:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b28:	4798                	lw	a4,8(a5)
 b2a:	08977e63          	bgeu	a4,s1,bc6 <malloc+0xc6>
 b2e:	f04a                	sd	s2,32(sp)
 b30:	e852                	sd	s4,16(sp)
 b32:	e456                	sd	s5,8(sp)
 b34:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b36:	8a4e                	mv	s4,s3
 b38:	0009871b          	sext.w	a4,s3
 b3c:	6685                	lui	a3,0x1
 b3e:	00d77363          	bgeu	a4,a3,b44 <malloc+0x44>
 b42:	6a05                	lui	s4,0x1
 b44:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b48:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b4c:	00000917          	auipc	s2,0x0
 b50:	24c90913          	addi	s2,s2,588 # d98 <freep>
  if(p == (char*)-1)
 b54:	5afd                	li	s5,-1
 b56:	a091                	j	b9a <malloc+0x9a>
 b58:	f04a                	sd	s2,32(sp)
 b5a:	e852                	sd	s4,16(sp)
 b5c:	e456                	sd	s5,8(sp)
 b5e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b60:	00008797          	auipc	a5,0x8
 b64:	42078793          	addi	a5,a5,1056 # 8f80 <base>
 b68:	00000717          	auipc	a4,0x0
 b6c:	22f73823          	sd	a5,560(a4) # d98 <freep>
 b70:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b72:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b76:	b7c1                	j	b36 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b78:	6398                	ld	a4,0(a5)
 b7a:	e118                	sd	a4,0(a0)
 b7c:	a08d                	j	bde <malloc+0xde>
  hp->s.size = nu;
 b7e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b82:	0541                	addi	a0,a0,16
 b84:	00000097          	auipc	ra,0x0
 b88:	efa080e7          	jalr	-262(ra) # a7e <free>
  return freep;
 b8c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b90:	c13d                	beqz	a0,bf6 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b92:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b94:	4798                	lw	a4,8(a5)
 b96:	02977463          	bgeu	a4,s1,bbe <malloc+0xbe>
    if(p == freep)
 b9a:	00093703          	ld	a4,0(s2)
 b9e:	853e                	mv	a0,a5
 ba0:	fef719e3          	bne	a4,a5,b92 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 ba4:	8552                	mv	a0,s4
 ba6:	00000097          	auipc	ra,0x0
 baa:	bc2080e7          	jalr	-1086(ra) # 768 <sbrk>
  if(p == (char*)-1)
 bae:	fd5518e3          	bne	a0,s5,b7e <malloc+0x7e>
        return 0;
 bb2:	4501                	li	a0,0
 bb4:	7902                	ld	s2,32(sp)
 bb6:	6a42                	ld	s4,16(sp)
 bb8:	6aa2                	ld	s5,8(sp)
 bba:	6b02                	ld	s6,0(sp)
 bbc:	a03d                	j	bea <malloc+0xea>
 bbe:	7902                	ld	s2,32(sp)
 bc0:	6a42                	ld	s4,16(sp)
 bc2:	6aa2                	ld	s5,8(sp)
 bc4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bc6:	fae489e3          	beq	s1,a4,b78 <malloc+0x78>
        p->s.size -= nunits;
 bca:	4137073b          	subw	a4,a4,s3
 bce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bd0:	02071693          	slli	a3,a4,0x20
 bd4:	01c6d713          	srli	a4,a3,0x1c
 bd8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bda:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bde:	00000717          	auipc	a4,0x0
 be2:	1aa73d23          	sd	a0,442(a4) # d98 <freep>
      return (void*)(p + 1);
 be6:	01078513          	addi	a0,a5,16
  }
}
 bea:	70e2                	ld	ra,56(sp)
 bec:	7442                	ld	s0,48(sp)
 bee:	74a2                	ld	s1,40(sp)
 bf0:	69e2                	ld	s3,24(sp)
 bf2:	6121                	addi	sp,sp,64
 bf4:	8082                	ret
 bf6:	7902                	ld	s2,32(sp)
 bf8:	6a42                	ld	s4,16(sp)
 bfa:	6aa2                	ld	s5,8(sp)
 bfc:	6b02                	ld	s6,0(sp)
 bfe:	b7f5                	j	bea <malloc+0xea>
