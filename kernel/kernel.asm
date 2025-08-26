
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00022117          	auipc	sp,0x22
    80000004:	17010113          	addi	sp,sp,368 # 80022170 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	583050ef          	jal	80005d98 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c9                	bnez	a5,800000b4 <kfree+0x98>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002b797          	auipc	a5,0x2b
    8000003a:	21278793          	addi	a5,a5,530 # 8002b248 <end>
    8000003e:	06f56b63          	bltu	a0,a5,800000b4 <kfree+0x98>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57763          	bgeu	a0,a5,800000b4 <kfree+0x98>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	216080e7          	jalr	534(ra) # 80000264 <memset>

  r = (struct run*)pa;

  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	728080e7          	jalr	1832(ra) # 8000677e <push_off>
  int id = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	eec080e7          	jalr	-276(ra) # 80000f4a <cpuid>
    80000066:	8a2a                	mv	s4,a0
  pop_off();
    80000068:	00006097          	auipc	ra,0x6
    8000006c:	7d2080e7          	jalr	2002(ra) # 8000683a <pop_off>

  acquire(&kmem[id].lock);
    80000070:	00009a97          	auipc	s5,0x9
    80000074:	fc0a8a93          	addi	s5,s5,-64 # 80009030 <kmem>
    80000078:	002a1993          	slli	s3,s4,0x2
    8000007c:	01498933          	add	s2,s3,s4
    80000080:	090e                	slli	s2,s2,0x3
    80000082:	9956                	add	s2,s2,s5
    80000084:	854a                	mv	a0,s2
    80000086:	00006097          	auipc	ra,0x6
    8000008a:	744080e7          	jalr	1860(ra) # 800067ca <acquire>
  r->next = kmem[id].freelist;
    8000008e:	02093783          	ld	a5,32(s2)
    80000092:	e09c                	sd	a5,0(s1)
  kmem[id].freelist = r;
    80000094:	02993023          	sd	s1,32(s2)
  release(&kmem[id].lock);
    80000098:	854a                	mv	a0,s2
    8000009a:	00007097          	auipc	ra,0x7
    8000009e:	800080e7          	jalr	-2048(ra) # 8000689a <release>
}
    800000a2:	70e2                	ld	ra,56(sp)
    800000a4:	7442                	ld	s0,48(sp)
    800000a6:	74a2                	ld	s1,40(sp)
    800000a8:	7902                	ld	s2,32(sp)
    800000aa:	69e2                	ld	s3,24(sp)
    800000ac:	6a42                	ld	s4,16(sp)
    800000ae:	6aa2                	ld	s5,8(sp)
    800000b0:	6121                	addi	sp,sp,64
    800000b2:	8082                	ret
    panic("kfree");
    800000b4:	00008517          	auipc	a0,0x8
    800000b8:	f4c50513          	addi	a0,a0,-180 # 80008000 <etext>
    800000bc:	00006097          	auipc	ra,0x6
    800000c0:	1aa080e7          	jalr	426(ra) # 80006266 <panic>

00000000800000c4 <freerange>:
{
    800000c4:	7179                	addi	sp,sp,-48
    800000c6:	f406                	sd	ra,40(sp)
    800000c8:	f022                	sd	s0,32(sp)
    800000ca:	ec26                	sd	s1,24(sp)
    800000cc:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000ce:	6785                	lui	a5,0x1
    800000d0:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000d4:	00e504b3          	add	s1,a0,a4
    800000d8:	777d                	lui	a4,0xfffff
    800000da:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000dc:	94be                	add	s1,s1,a5
    800000de:	0295e463          	bltu	a1,s1,80000106 <freerange+0x42>
    800000e2:	e84a                	sd	s2,16(sp)
    800000e4:	e44e                	sd	s3,8(sp)
    800000e6:	e052                	sd	s4,0(sp)
    800000e8:	892e                	mv	s2,a1
    kfree(p);
    800000ea:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ec:	6985                	lui	s3,0x1
    kfree(p);
    800000ee:	01448533          	add	a0,s1,s4
    800000f2:	00000097          	auipc	ra,0x0
    800000f6:	f2a080e7          	jalr	-214(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000fa:	94ce                	add	s1,s1,s3
    800000fc:	fe9979e3          	bgeu	s2,s1,800000ee <freerange+0x2a>
    80000100:	6942                	ld	s2,16(sp)
    80000102:	69a2                	ld	s3,8(sp)
    80000104:	6a02                	ld	s4,0(sp)
}
    80000106:	70a2                	ld	ra,40(sp)
    80000108:	7402                	ld	s0,32(sp)
    8000010a:	64e2                	ld	s1,24(sp)
    8000010c:	6145                	addi	sp,sp,48
    8000010e:	8082                	ret

0000000080000110 <kinit>:
{
    80000110:	7179                	addi	sp,sp,-48
    80000112:	f406                	sd	ra,40(sp)
    80000114:	f022                	sd	s0,32(sp)
    80000116:	ec26                	sd	s1,24(sp)
    80000118:	e84a                	sd	s2,16(sp)
    8000011a:	e44e                	sd	s3,8(sp)
    8000011c:	1800                	addi	s0,sp,48
  for (int i = 0; i < NCPU; i++)
    8000011e:	00009497          	auipc	s1,0x9
    80000122:	f1248493          	addi	s1,s1,-238 # 80009030 <kmem>
    80000126:	00009997          	auipc	s3,0x9
    8000012a:	04a98993          	addi	s3,s3,74 # 80009170 <pid_lock>
    initlock(&kmem[i].lock, "kmem");
    8000012e:	00008917          	auipc	s2,0x8
    80000132:	ee290913          	addi	s2,s2,-286 # 80008010 <etext+0x10>
    80000136:	85ca                	mv	a1,s2
    80000138:	8526                	mv	a0,s1
    8000013a:	00007097          	auipc	ra,0x7
    8000013e:	80c080e7          	jalr	-2036(ra) # 80006946 <initlock>
  for (int i = 0; i < NCPU; i++)
    80000142:	02848493          	addi	s1,s1,40
    80000146:	ff3498e3          	bne	s1,s3,80000136 <kinit+0x26>
  freerange(end, (void*)PHYSTOP);
    8000014a:	45c5                	li	a1,17
    8000014c:	05ee                	slli	a1,a1,0x1b
    8000014e:	0002b517          	auipc	a0,0x2b
    80000152:	0fa50513          	addi	a0,a0,250 # 8002b248 <end>
    80000156:	00000097          	auipc	ra,0x0
    8000015a:	f6e080e7          	jalr	-146(ra) # 800000c4 <freerange>
}
    8000015e:	70a2                	ld	ra,40(sp)
    80000160:	7402                	ld	s0,32(sp)
    80000162:	64e2                	ld	s1,24(sp)
    80000164:	6942                	ld	s2,16(sp)
    80000166:	69a2                	ld	s3,8(sp)
    80000168:	6145                	addi	sp,sp,48
    8000016a:	8082                	ret

000000008000016c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000016c:	7139                	addi	sp,sp,-64
    8000016e:	fc06                	sd	ra,56(sp)
    80000170:	f822                	sd	s0,48(sp)
    80000172:	f426                	sd	s1,40(sp)
    80000174:	ec4e                	sd	s3,24(sp)
    80000176:	e852                	sd	s4,16(sp)
    80000178:	0080                	addi	s0,sp,64
  struct run *r;

  push_off();
    8000017a:	00006097          	auipc	ra,0x6
    8000017e:	604080e7          	jalr	1540(ra) # 8000677e <push_off>
  int id = cpuid();
    80000182:	00001097          	auipc	ra,0x1
    80000186:	dc8080e7          	jalr	-568(ra) # 80000f4a <cpuid>
    8000018a:	89aa                	mv	s3,a0
  pop_off();
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	6ae080e7          	jalr	1710(ra) # 8000683a <pop_off>

  acquire(&kmem[id].lock);
    80000194:	00299793          	slli	a5,s3,0x2
    80000198:	97ce                	add	a5,a5,s3
    8000019a:	078e                	slli	a5,a5,0x3
    8000019c:	00009497          	auipc	s1,0x9
    800001a0:	e9448493          	addi	s1,s1,-364 # 80009030 <kmem>
    800001a4:	94be                	add	s1,s1,a5
    800001a6:	8526                	mv	a0,s1
    800001a8:	00006097          	auipc	ra,0x6
    800001ac:	622080e7          	jalr	1570(ra) # 800067ca <acquire>
  r = kmem[id].freelist;
    800001b0:	0204ba03          	ld	s4,32(s1)
  if(r)
    800001b4:	080a0963          	beqz	s4,80000246 <kalloc+0xda>
    kmem[id].freelist = r->next;
    800001b8:	000a3683          	ld	a3,0(s4) # fffffffffffff000 <end+0xffffffff7ffd3db8>
    800001bc:	f094                	sd	a3,32(s1)
  release(&kmem[id].lock);
    800001be:	8526                	mv	a0,s1
    800001c0:	00006097          	auipc	ra,0x6
    800001c4:	6da080e7          	jalr	1754(ra) # 8000689a <release>
      release(&kmem[i].lock);
    }
  }
  
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001c8:	6605                	lui	a2,0x1
    800001ca:	4595                	li	a1,5
    800001cc:	8552                	mv	a0,s4
    800001ce:	00000097          	auipc	ra,0x0
    800001d2:	096080e7          	jalr	150(ra) # 80000264 <memset>
  return (void*)r;
}
    800001d6:	8552                	mv	a0,s4
    800001d8:	70e2                	ld	ra,56(sp)
    800001da:	7442                	ld	s0,48(sp)
    800001dc:	74a2                	ld	s1,40(sp)
    800001de:	69e2                	ld	s3,24(sp)
    800001e0:	6a42                	ld	s4,16(sp)
    800001e2:	6121                	addi	sp,sp,64
    800001e4:	8082                	ret
        kmem[i].freelist = r->next;
    800001e6:	000ab683          	ld	a3,0(s5)
    800001ea:	00249793          	slli	a5,s1,0x2
    800001ee:	97a6                	add	a5,a5,s1
    800001f0:	078e                	slli	a5,a5,0x3
    800001f2:	00009717          	auipc	a4,0x9
    800001f6:	e3e70713          	addi	a4,a4,-450 # 80009030 <kmem>
    800001fa:	97ba                	add	a5,a5,a4
    800001fc:	f394                	sd	a3,32(a5)
        release(&kmem[i].lock);
    800001fe:	854a                	mv	a0,s2
    80000200:	00006097          	auipc	ra,0x6
    80000204:	69a080e7          	jalr	1690(ra) # 8000689a <release>
      r = kmem[i].freelist;
    80000208:	8a56                	mv	s4,s5
    8000020a:	7902                	ld	s2,32(sp)
    8000020c:	6aa2                	ld	s5,8(sp)
    8000020e:	6b02                	ld	s6,0(sp)
    80000210:	bf65                	j	800001c8 <kalloc+0x5c>
    for (int i = 0; i < NCPU; i++)
    80000212:	2485                	addiw	s1,s1,1
    80000214:	02890913          	addi	s2,s2,40
    80000218:	03648363          	beq	s1,s6,8000023e <kalloc+0xd2>
      if (i == id) continue;
    8000021c:	fe998be3          	beq	s3,s1,80000212 <kalloc+0xa6>
      acquire(&kmem[i].lock);
    80000220:	854a                	mv	a0,s2
    80000222:	00006097          	auipc	ra,0x6
    80000226:	5a8080e7          	jalr	1448(ra) # 800067ca <acquire>
      r = kmem[i].freelist;
    8000022a:	02093a83          	ld	s5,32(s2)
      if (r) {
    8000022e:	fa0a9ce3          	bnez	s5,800001e6 <kalloc+0x7a>
      release(&kmem[i].lock);
    80000232:	854a                	mv	a0,s2
    80000234:	00006097          	auipc	ra,0x6
    80000238:	666080e7          	jalr	1638(ra) # 8000689a <release>
    8000023c:	bfd9                	j	80000212 <kalloc+0xa6>
    8000023e:	7902                	ld	s2,32(sp)
    80000240:	6aa2                	ld	s5,8(sp)
    80000242:	6b02                	ld	s6,0(sp)
    80000244:	bf49                	j	800001d6 <kalloc+0x6a>
    80000246:	f04a                	sd	s2,32(sp)
    80000248:	e456                	sd	s5,8(sp)
    8000024a:	e05a                	sd	s6,0(sp)
  release(&kmem[id].lock);
    8000024c:	8526                	mv	a0,s1
    8000024e:	00006097          	auipc	ra,0x6
    80000252:	64c080e7          	jalr	1612(ra) # 8000689a <release>
    for (int i = 0; i < NCPU; i++)
    80000256:	00009917          	auipc	s2,0x9
    8000025a:	dda90913          	addi	s2,s2,-550 # 80009030 <kmem>
    8000025e:	4481                	li	s1,0
    80000260:	4b21                	li	s6,8
    80000262:	bf6d                	j	8000021c <kalloc+0xb0>

0000000080000264 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000264:	1141                	addi	sp,sp,-16
    80000266:	e422                	sd	s0,8(sp)
    80000268:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000026a:	ca19                	beqz	a2,80000280 <memset+0x1c>
    8000026c:	87aa                	mv	a5,a0
    8000026e:	1602                	slli	a2,a2,0x20
    80000270:	9201                	srli	a2,a2,0x20
    80000272:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000276:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000027a:	0785                	addi	a5,a5,1
    8000027c:	fee79de3          	bne	a5,a4,80000276 <memset+0x12>
  }
  return dst;
}
    80000280:	6422                	ld	s0,8(sp)
    80000282:	0141                	addi	sp,sp,16
    80000284:	8082                	ret

0000000080000286 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000028c:	ca05                	beqz	a2,800002bc <memcmp+0x36>
    8000028e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000292:	1682                	slli	a3,a3,0x20
    80000294:	9281                	srli	a3,a3,0x20
    80000296:	0685                	addi	a3,a3,1
    80000298:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000029a:	00054783          	lbu	a5,0(a0)
    8000029e:	0005c703          	lbu	a4,0(a1)
    800002a2:	00e79863          	bne	a5,a4,800002b2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002a6:	0505                	addi	a0,a0,1
    800002a8:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002aa:	fed518e3          	bne	a0,a3,8000029a <memcmp+0x14>
  }

  return 0;
    800002ae:	4501                	li	a0,0
    800002b0:	a019                	j	800002b6 <memcmp+0x30>
      return *s1 - *s2;
    800002b2:	40e7853b          	subw	a0,a5,a4
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret
  return 0;
    800002bc:	4501                	li	a0,0
    800002be:	bfe5                	j	800002b6 <memcmp+0x30>

00000000800002c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002c0:	1141                	addi	sp,sp,-16
    800002c2:	e422                	sd	s0,8(sp)
    800002c4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002c6:	c205                	beqz	a2,800002e6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002c8:	02a5e263          	bltu	a1,a0,800002ec <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002cc:	1602                	slli	a2,a2,0x20
    800002ce:	9201                	srli	a2,a2,0x20
    800002d0:	00c587b3          	add	a5,a1,a2
{
    800002d4:	872a                	mv	a4,a0
      *d++ = *s++;
    800002d6:	0585                	addi	a1,a1,1
    800002d8:	0705                	addi	a4,a4,1
    800002da:	fff5c683          	lbu	a3,-1(a1)
    800002de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002e2:	feb79ae3          	bne	a5,a1,800002d6 <memmove+0x16>

  return dst;
}
    800002e6:	6422                	ld	s0,8(sp)
    800002e8:	0141                	addi	sp,sp,16
    800002ea:	8082                	ret
  if(s < d && s + n > d){
    800002ec:	02061693          	slli	a3,a2,0x20
    800002f0:	9281                	srli	a3,a3,0x20
    800002f2:	00d58733          	add	a4,a1,a3
    800002f6:	fce57be3          	bgeu	a0,a4,800002cc <memmove+0xc>
    d += n;
    800002fa:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002fc:	fff6079b          	addiw	a5,a2,-1
    80000300:	1782                	slli	a5,a5,0x20
    80000302:	9381                	srli	a5,a5,0x20
    80000304:	fff7c793          	not	a5,a5
    80000308:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000030a:	177d                	addi	a4,a4,-1
    8000030c:	16fd                	addi	a3,a3,-1
    8000030e:	00074603          	lbu	a2,0(a4)
    80000312:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000316:	fef71ae3          	bne	a4,a5,8000030a <memmove+0x4a>
    8000031a:	b7f1                	j	800002e6 <memmove+0x26>

000000008000031c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000031c:	1141                	addi	sp,sp,-16
    8000031e:	e406                	sd	ra,8(sp)
    80000320:	e022                	sd	s0,0(sp)
    80000322:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000324:	00000097          	auipc	ra,0x0
    80000328:	f9c080e7          	jalr	-100(ra) # 800002c0 <memmove>
}
    8000032c:	60a2                	ld	ra,8(sp)
    8000032e:	6402                	ld	s0,0(sp)
    80000330:	0141                	addi	sp,sp,16
    80000332:	8082                	ret

0000000080000334 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000334:	1141                	addi	sp,sp,-16
    80000336:	e422                	sd	s0,8(sp)
    80000338:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000033a:	ce11                	beqz	a2,80000356 <strncmp+0x22>
    8000033c:	00054783          	lbu	a5,0(a0)
    80000340:	cf89                	beqz	a5,8000035a <strncmp+0x26>
    80000342:	0005c703          	lbu	a4,0(a1)
    80000346:	00f71a63          	bne	a4,a5,8000035a <strncmp+0x26>
    n--, p++, q++;
    8000034a:	367d                	addiw	a2,a2,-1
    8000034c:	0505                	addi	a0,a0,1
    8000034e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000350:	f675                	bnez	a2,8000033c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000352:	4501                	li	a0,0
    80000354:	a801                	j	80000364 <strncmp+0x30>
    80000356:	4501                	li	a0,0
    80000358:	a031                	j	80000364 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    8000035a:	00054503          	lbu	a0,0(a0)
    8000035e:	0005c783          	lbu	a5,0(a1)
    80000362:	9d1d                	subw	a0,a0,a5
}
    80000364:	6422                	ld	s0,8(sp)
    80000366:	0141                	addi	sp,sp,16
    80000368:	8082                	ret

000000008000036a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000036a:	1141                	addi	sp,sp,-16
    8000036c:	e422                	sd	s0,8(sp)
    8000036e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000370:	87aa                	mv	a5,a0
    80000372:	86b2                	mv	a3,a2
    80000374:	367d                	addiw	a2,a2,-1
    80000376:	02d05563          	blez	a3,800003a0 <strncpy+0x36>
    8000037a:	0785                	addi	a5,a5,1
    8000037c:	0005c703          	lbu	a4,0(a1)
    80000380:	fee78fa3          	sb	a4,-1(a5)
    80000384:	0585                	addi	a1,a1,1
    80000386:	f775                	bnez	a4,80000372 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000388:	873e                	mv	a4,a5
    8000038a:	9fb5                	addw	a5,a5,a3
    8000038c:	37fd                	addiw	a5,a5,-1
    8000038e:	00c05963          	blez	a2,800003a0 <strncpy+0x36>
    *s++ = 0;
    80000392:	0705                	addi	a4,a4,1
    80000394:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000398:	40e786bb          	subw	a3,a5,a4
    8000039c:	fed04be3          	bgtz	a3,80000392 <strncpy+0x28>
  return os;
}
    800003a0:	6422                	ld	s0,8(sp)
    800003a2:	0141                	addi	sp,sp,16
    800003a4:	8082                	ret

00000000800003a6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003a6:	1141                	addi	sp,sp,-16
    800003a8:	e422                	sd	s0,8(sp)
    800003aa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003ac:	02c05363          	blez	a2,800003d2 <safestrcpy+0x2c>
    800003b0:	fff6069b          	addiw	a3,a2,-1
    800003b4:	1682                	slli	a3,a3,0x20
    800003b6:	9281                	srli	a3,a3,0x20
    800003b8:	96ae                	add	a3,a3,a1
    800003ba:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003bc:	00d58963          	beq	a1,a3,800003ce <safestrcpy+0x28>
    800003c0:	0585                	addi	a1,a1,1
    800003c2:	0785                	addi	a5,a5,1
    800003c4:	fff5c703          	lbu	a4,-1(a1)
    800003c8:	fee78fa3          	sb	a4,-1(a5)
    800003cc:	fb65                	bnez	a4,800003bc <safestrcpy+0x16>
    ;
  *s = 0;
    800003ce:	00078023          	sb	zero,0(a5)
  return os;
}
    800003d2:	6422                	ld	s0,8(sp)
    800003d4:	0141                	addi	sp,sp,16
    800003d6:	8082                	ret

00000000800003d8 <strlen>:

int
strlen(const char *s)
{
    800003d8:	1141                	addi	sp,sp,-16
    800003da:	e422                	sd	s0,8(sp)
    800003dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003de:	00054783          	lbu	a5,0(a0)
    800003e2:	cf91                	beqz	a5,800003fe <strlen+0x26>
    800003e4:	0505                	addi	a0,a0,1
    800003e6:	87aa                	mv	a5,a0
    800003e8:	86be                	mv	a3,a5
    800003ea:	0785                	addi	a5,a5,1
    800003ec:	fff7c703          	lbu	a4,-1(a5)
    800003f0:	ff65                	bnez	a4,800003e8 <strlen+0x10>
    800003f2:	40a6853b          	subw	a0,a3,a0
    800003f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800003f8:	6422                	ld	s0,8(sp)
    800003fa:	0141                	addi	sp,sp,16
    800003fc:	8082                	ret
  for(n = 0; s[n]; n++)
    800003fe:	4501                	li	a0,0
    80000400:	bfe5                	j	800003f8 <strlen+0x20>

0000000080000402 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000402:	1101                	addi	sp,sp,-32
    80000404:	ec06                	sd	ra,24(sp)
    80000406:	e822                	sd	s0,16(sp)
    80000408:	e426                	sd	s1,8(sp)
    8000040a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000040c:	00001097          	auipc	ra,0x1
    80000410:	b3e080e7          	jalr	-1218(ra) # 80000f4a <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000414:	00009497          	auipc	s1,0x9
    80000418:	bec48493          	addi	s1,s1,-1044 # 80009000 <started>
  if(cpuid() == 0){
    8000041c:	c531                	beqz	a0,80000468 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    8000041e:	8526                	mv	a0,s1
    80000420:	00006097          	auipc	ra,0x6
    80000424:	5bc080e7          	jalr	1468(ra) # 800069dc <lockfree_read4>
    80000428:	d97d                	beqz	a0,8000041e <main+0x1c>
      ;
    __sync_synchronize();
    8000042a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	b1c080e7          	jalr	-1252(ra) # 80000f4a <cpuid>
    80000436:	85aa                	mv	a1,a0
    80000438:	00008517          	auipc	a0,0x8
    8000043c:	c0050513          	addi	a0,a0,-1024 # 80008038 <etext+0x38>
    80000440:	00006097          	auipc	ra,0x6
    80000444:	e70080e7          	jalr	-400(ra) # 800062b0 <printf>
    kvminithart();    // turn on paging
    80000448:	00000097          	auipc	ra,0x0
    8000044c:	0e0080e7          	jalr	224(ra) # 80000528 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000450:	00001097          	auipc	ra,0x1
    80000454:	77e080e7          	jalr	1918(ra) # 80001bce <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000458:	00005097          	auipc	ra,0x5
    8000045c:	f7c080e7          	jalr	-132(ra) # 800053d4 <plicinithart>
  }

  scheduler();        
    80000460:	00001097          	auipc	ra,0x1
    80000464:	02a080e7          	jalr	42(ra) # 8000148a <scheduler>
    consoleinit();
    80000468:	00006097          	auipc	ra,0x6
    8000046c:	d0e080e7          	jalr	-754(ra) # 80006176 <consoleinit>
    statsinit();
    80000470:	00005097          	auipc	ra,0x5
    80000474:	622080e7          	jalr	1570(ra) # 80005a92 <statsinit>
    printfinit();
    80000478:	00006097          	auipc	ra,0x6
    8000047c:	040080e7          	jalr	64(ra) # 800064b8 <printfinit>
    printf("\n");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	b9850513          	addi	a0,a0,-1128 # 80008018 <etext+0x18>
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	e28080e7          	jalr	-472(ra) # 800062b0 <printf>
    printf("xv6 kernel is booting\n");
    80000490:	00008517          	auipc	a0,0x8
    80000494:	b9050513          	addi	a0,a0,-1136 # 80008020 <etext+0x20>
    80000498:	00006097          	auipc	ra,0x6
    8000049c:	e18080e7          	jalr	-488(ra) # 800062b0 <printf>
    printf("\n");
    800004a0:	00008517          	auipc	a0,0x8
    800004a4:	b7850513          	addi	a0,a0,-1160 # 80008018 <etext+0x18>
    800004a8:	00006097          	auipc	ra,0x6
    800004ac:	e08080e7          	jalr	-504(ra) # 800062b0 <printf>
    kinit();         // physical page allocator
    800004b0:	00000097          	auipc	ra,0x0
    800004b4:	c60080e7          	jalr	-928(ra) # 80000110 <kinit>
    kvminit();       // create kernel page table
    800004b8:	00000097          	auipc	ra,0x0
    800004bc:	322080e7          	jalr	802(ra) # 800007da <kvminit>
    kvminithart();   // turn on paging
    800004c0:	00000097          	auipc	ra,0x0
    800004c4:	068080e7          	jalr	104(ra) # 80000528 <kvminithart>
    procinit();      // process table
    800004c8:	00001097          	auipc	ra,0x1
    800004cc:	9c4080e7          	jalr	-1596(ra) # 80000e8c <procinit>
    trapinit();      // trap vectors
    800004d0:	00001097          	auipc	ra,0x1
    800004d4:	6d6080e7          	jalr	1750(ra) # 80001ba6 <trapinit>
    trapinithart();  // install kernel trap vector
    800004d8:	00001097          	auipc	ra,0x1
    800004dc:	6f6080e7          	jalr	1782(ra) # 80001bce <trapinithart>
    plicinit();      // set up interrupt controller
    800004e0:	00005097          	auipc	ra,0x5
    800004e4:	eda080e7          	jalr	-294(ra) # 800053ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004e8:	00005097          	auipc	ra,0x5
    800004ec:	eec080e7          	jalr	-276(ra) # 800053d4 <plicinithart>
    binit();         // buffer cache
    800004f0:	00002097          	auipc	ra,0x2
    800004f4:	e44080e7          	jalr	-444(ra) # 80002334 <binit>
    iinit();         // inode table
    800004f8:	00002097          	auipc	ra,0x2
    800004fc:	688080e7          	jalr	1672(ra) # 80002b80 <iinit>
    fileinit();      // file table
    80000500:	00003097          	auipc	ra,0x3
    80000504:	62c080e7          	jalr	1580(ra) # 80003b2c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000508:	00005097          	auipc	ra,0x5
    8000050c:	fec080e7          	jalr	-20(ra) # 800054f4 <virtio_disk_init>
    userinit();      // first user process
    80000510:	00001097          	auipc	ra,0x1
    80000514:	d3e080e7          	jalr	-706(ra) # 8000124e <userinit>
    __sync_synchronize();
    80000518:	0ff0000f          	fence
    started = 1;
    8000051c:	4785                	li	a5,1
    8000051e:	00009717          	auipc	a4,0x9
    80000522:	aef72123          	sw	a5,-1310(a4) # 80009000 <started>
    80000526:	bf2d                	j	80000460 <main+0x5e>

0000000080000528 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000528:	1141                	addi	sp,sp,-16
    8000052a:	e422                	sd	s0,8(sp)
    8000052c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000052e:	00009797          	auipc	a5,0x9
    80000532:	ada7b783          	ld	a5,-1318(a5) # 80009008 <kernel_pagetable>
    80000536:	83b1                	srli	a5,a5,0xc
    80000538:	577d                	li	a4,-1
    8000053a:	177e                	slli	a4,a4,0x3f
    8000053c:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000053e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000542:	12000073          	sfence.vma
  sfence_vma();
}
    80000546:	6422                	ld	s0,8(sp)
    80000548:	0141                	addi	sp,sp,16
    8000054a:	8082                	ret

000000008000054c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000054c:	7139                	addi	sp,sp,-64
    8000054e:	fc06                	sd	ra,56(sp)
    80000550:	f822                	sd	s0,48(sp)
    80000552:	f426                	sd	s1,40(sp)
    80000554:	f04a                	sd	s2,32(sp)
    80000556:	ec4e                	sd	s3,24(sp)
    80000558:	e852                	sd	s4,16(sp)
    8000055a:	e456                	sd	s5,8(sp)
    8000055c:	e05a                	sd	s6,0(sp)
    8000055e:	0080                	addi	s0,sp,64
    80000560:	84aa                	mv	s1,a0
    80000562:	89ae                	mv	s3,a1
    80000564:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000566:	57fd                	li	a5,-1
    80000568:	83e9                	srli	a5,a5,0x1a
    8000056a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000056c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000056e:	04b7f263          	bgeu	a5,a1,800005b2 <walk+0x66>
    panic("walk");
    80000572:	00008517          	auipc	a0,0x8
    80000576:	ade50513          	addi	a0,a0,-1314 # 80008050 <etext+0x50>
    8000057a:	00006097          	auipc	ra,0x6
    8000057e:	cec080e7          	jalr	-788(ra) # 80006266 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000582:	060a8663          	beqz	s5,800005ee <walk+0xa2>
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	be6080e7          	jalr	-1050(ra) # 8000016c <kalloc>
    8000058e:	84aa                	mv	s1,a0
    80000590:	c529                	beqz	a0,800005da <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000592:	6605                	lui	a2,0x1
    80000594:	4581                	li	a1,0
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	cce080e7          	jalr	-818(ra) # 80000264 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000059e:	00c4d793          	srli	a5,s1,0xc
    800005a2:	07aa                	slli	a5,a5,0xa
    800005a4:	0017e793          	ori	a5,a5,1
    800005a8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005ac:	3a5d                	addiw	s4,s4,-9
    800005ae:	036a0063          	beq	s4,s6,800005ce <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005b2:	0149d933          	srl	s2,s3,s4
    800005b6:	1ff97913          	andi	s2,s2,511
    800005ba:	090e                	slli	s2,s2,0x3
    800005bc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005be:	00093483          	ld	s1,0(s2)
    800005c2:	0014f793          	andi	a5,s1,1
    800005c6:	dfd5                	beqz	a5,80000582 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005c8:	80a9                	srli	s1,s1,0xa
    800005ca:	04b2                	slli	s1,s1,0xc
    800005cc:	b7c5                	j	800005ac <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005ce:	00c9d513          	srli	a0,s3,0xc
    800005d2:	1ff57513          	andi	a0,a0,511
    800005d6:	050e                	slli	a0,a0,0x3
    800005d8:	9526                	add	a0,a0,s1
}
    800005da:	70e2                	ld	ra,56(sp)
    800005dc:	7442                	ld	s0,48(sp)
    800005de:	74a2                	ld	s1,40(sp)
    800005e0:	7902                	ld	s2,32(sp)
    800005e2:	69e2                	ld	s3,24(sp)
    800005e4:	6a42                	ld	s4,16(sp)
    800005e6:	6aa2                	ld	s5,8(sp)
    800005e8:	6b02                	ld	s6,0(sp)
    800005ea:	6121                	addi	sp,sp,64
    800005ec:	8082                	ret
        return 0;
    800005ee:	4501                	li	a0,0
    800005f0:	b7ed                	j	800005da <walk+0x8e>

00000000800005f2 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800005f2:	57fd                	li	a5,-1
    800005f4:	83e9                	srli	a5,a5,0x1a
    800005f6:	00b7f463          	bgeu	a5,a1,800005fe <walkaddr+0xc>
    return 0;
    800005fa:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005fc:	8082                	ret
{
    800005fe:	1141                	addi	sp,sp,-16
    80000600:	e406                	sd	ra,8(sp)
    80000602:	e022                	sd	s0,0(sp)
    80000604:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000606:	4601                	li	a2,0
    80000608:	00000097          	auipc	ra,0x0
    8000060c:	f44080e7          	jalr	-188(ra) # 8000054c <walk>
  if(pte == 0)
    80000610:	c105                	beqz	a0,80000630 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000612:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000614:	0117f693          	andi	a3,a5,17
    80000618:	4745                	li	a4,17
    return 0;
    8000061a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000061c:	00e68663          	beq	a3,a4,80000628 <walkaddr+0x36>
}
    80000620:	60a2                	ld	ra,8(sp)
    80000622:	6402                	ld	s0,0(sp)
    80000624:	0141                	addi	sp,sp,16
    80000626:	8082                	ret
  pa = PTE2PA(*pte);
    80000628:	83a9                	srli	a5,a5,0xa
    8000062a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000062e:	bfcd                	j	80000620 <walkaddr+0x2e>
    return 0;
    80000630:	4501                	li	a0,0
    80000632:	b7fd                	j	80000620 <walkaddr+0x2e>

0000000080000634 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000634:	715d                	addi	sp,sp,-80
    80000636:	e486                	sd	ra,72(sp)
    80000638:	e0a2                	sd	s0,64(sp)
    8000063a:	fc26                	sd	s1,56(sp)
    8000063c:	f84a                	sd	s2,48(sp)
    8000063e:	f44e                	sd	s3,40(sp)
    80000640:	f052                	sd	s4,32(sp)
    80000642:	ec56                	sd	s5,24(sp)
    80000644:	e85a                	sd	s6,16(sp)
    80000646:	e45e                	sd	s7,8(sp)
    80000648:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000064a:	c639                	beqz	a2,80000698 <mappages+0x64>
    8000064c:	8aaa                	mv	s5,a0
    8000064e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000650:	777d                	lui	a4,0xfffff
    80000652:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000656:	fff58993          	addi	s3,a1,-1
    8000065a:	99b2                	add	s3,s3,a2
    8000065c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000660:	893e                	mv	s2,a5
    80000662:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000666:	6b85                	lui	s7,0x1
    80000668:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000066c:	4605                	li	a2,1
    8000066e:	85ca                	mv	a1,s2
    80000670:	8556                	mv	a0,s5
    80000672:	00000097          	auipc	ra,0x0
    80000676:	eda080e7          	jalr	-294(ra) # 8000054c <walk>
    8000067a:	cd1d                	beqz	a0,800006b8 <mappages+0x84>
    if(*pte & PTE_V)
    8000067c:	611c                	ld	a5,0(a0)
    8000067e:	8b85                	andi	a5,a5,1
    80000680:	e785                	bnez	a5,800006a8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000682:	80b1                	srli	s1,s1,0xc
    80000684:	04aa                	slli	s1,s1,0xa
    80000686:	0164e4b3          	or	s1,s1,s6
    8000068a:	0014e493          	ori	s1,s1,1
    8000068e:	e104                	sd	s1,0(a0)
    if(a == last)
    80000690:	05390063          	beq	s2,s3,800006d0 <mappages+0x9c>
    a += PGSIZE;
    80000694:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000696:	bfc9                	j	80000668 <mappages+0x34>
    panic("mappages: size");
    80000698:	00008517          	auipc	a0,0x8
    8000069c:	9c050513          	addi	a0,a0,-1600 # 80008058 <etext+0x58>
    800006a0:	00006097          	auipc	ra,0x6
    800006a4:	bc6080e7          	jalr	-1082(ra) # 80006266 <panic>
      panic("mappages: remap");
    800006a8:	00008517          	auipc	a0,0x8
    800006ac:	9c050513          	addi	a0,a0,-1600 # 80008068 <etext+0x68>
    800006b0:	00006097          	auipc	ra,0x6
    800006b4:	bb6080e7          	jalr	-1098(ra) # 80006266 <panic>
      return -1;
    800006b8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006ba:	60a6                	ld	ra,72(sp)
    800006bc:	6406                	ld	s0,64(sp)
    800006be:	74e2                	ld	s1,56(sp)
    800006c0:	7942                	ld	s2,48(sp)
    800006c2:	79a2                	ld	s3,40(sp)
    800006c4:	7a02                	ld	s4,32(sp)
    800006c6:	6ae2                	ld	s5,24(sp)
    800006c8:	6b42                	ld	s6,16(sp)
    800006ca:	6ba2                	ld	s7,8(sp)
    800006cc:	6161                	addi	sp,sp,80
    800006ce:	8082                	ret
  return 0;
    800006d0:	4501                	li	a0,0
    800006d2:	b7e5                	j	800006ba <mappages+0x86>

00000000800006d4 <kvmmap>:
{
    800006d4:	1141                	addi	sp,sp,-16
    800006d6:	e406                	sd	ra,8(sp)
    800006d8:	e022                	sd	s0,0(sp)
    800006da:	0800                	addi	s0,sp,16
    800006dc:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006de:	86b2                	mv	a3,a2
    800006e0:	863e                	mv	a2,a5
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f52080e7          	jalr	-174(ra) # 80000634 <mappages>
    800006ea:	e509                	bnez	a0,800006f4 <kvmmap+0x20>
}
    800006ec:	60a2                	ld	ra,8(sp)
    800006ee:	6402                	ld	s0,0(sp)
    800006f0:	0141                	addi	sp,sp,16
    800006f2:	8082                	ret
    panic("kvmmap");
    800006f4:	00008517          	auipc	a0,0x8
    800006f8:	98450513          	addi	a0,a0,-1660 # 80008078 <etext+0x78>
    800006fc:	00006097          	auipc	ra,0x6
    80000700:	b6a080e7          	jalr	-1174(ra) # 80006266 <panic>

0000000080000704 <kvmmake>:
{
    80000704:	1101                	addi	sp,sp,-32
    80000706:	ec06                	sd	ra,24(sp)
    80000708:	e822                	sd	s0,16(sp)
    8000070a:	e426                	sd	s1,8(sp)
    8000070c:	e04a                	sd	s2,0(sp)
    8000070e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000710:	00000097          	auipc	ra,0x0
    80000714:	a5c080e7          	jalr	-1444(ra) # 8000016c <kalloc>
    80000718:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000071a:	6605                	lui	a2,0x1
    8000071c:	4581                	li	a1,0
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	b46080e7          	jalr	-1210(ra) # 80000264 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000726:	4719                	li	a4,6
    80000728:	6685                	lui	a3,0x1
    8000072a:	10000637          	lui	a2,0x10000
    8000072e:	100005b7          	lui	a1,0x10000
    80000732:	8526                	mv	a0,s1
    80000734:	00000097          	auipc	ra,0x0
    80000738:	fa0080e7          	jalr	-96(ra) # 800006d4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000073c:	4719                	li	a4,6
    8000073e:	6685                	lui	a3,0x1
    80000740:	10001637          	lui	a2,0x10001
    80000744:	100015b7          	lui	a1,0x10001
    80000748:	8526                	mv	a0,s1
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	f8a080e7          	jalr	-118(ra) # 800006d4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000752:	4719                	li	a4,6
    80000754:	004006b7          	lui	a3,0x400
    80000758:	0c000637          	lui	a2,0xc000
    8000075c:	0c0005b7          	lui	a1,0xc000
    80000760:	8526                	mv	a0,s1
    80000762:	00000097          	auipc	ra,0x0
    80000766:	f72080e7          	jalr	-142(ra) # 800006d4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000076a:	00008917          	auipc	s2,0x8
    8000076e:	89690913          	addi	s2,s2,-1898 # 80008000 <etext>
    80000772:	4729                	li	a4,10
    80000774:	80008697          	auipc	a3,0x80008
    80000778:	88c68693          	addi	a3,a3,-1908 # 8000 <_entry-0x7fff8000>
    8000077c:	4605                	li	a2,1
    8000077e:	067e                	slli	a2,a2,0x1f
    80000780:	85b2                	mv	a1,a2
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	f50080e7          	jalr	-176(ra) # 800006d4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000078c:	46c5                	li	a3,17
    8000078e:	06ee                	slli	a3,a3,0x1b
    80000790:	4719                	li	a4,6
    80000792:	412686b3          	sub	a3,a3,s2
    80000796:	864a                	mv	a2,s2
    80000798:	85ca                	mv	a1,s2
    8000079a:	8526                	mv	a0,s1
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	f38080e7          	jalr	-200(ra) # 800006d4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007a4:	4729                	li	a4,10
    800007a6:	6685                	lui	a3,0x1
    800007a8:	00007617          	auipc	a2,0x7
    800007ac:	85860613          	addi	a2,a2,-1960 # 80007000 <_trampoline>
    800007b0:	040005b7          	lui	a1,0x4000
    800007b4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007b6:	05b2                	slli	a1,a1,0xc
    800007b8:	8526                	mv	a0,s1
    800007ba:	00000097          	auipc	ra,0x0
    800007be:	f1a080e7          	jalr	-230(ra) # 800006d4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007c2:	8526                	mv	a0,s1
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	624080e7          	jalr	1572(ra) # 80000de8 <proc_mapstacks>
}
    800007cc:	8526                	mv	a0,s1
    800007ce:	60e2                	ld	ra,24(sp)
    800007d0:	6442                	ld	s0,16(sp)
    800007d2:	64a2                	ld	s1,8(sp)
    800007d4:	6902                	ld	s2,0(sp)
    800007d6:	6105                	addi	sp,sp,32
    800007d8:	8082                	ret

00000000800007da <kvminit>:
{
    800007da:	1141                	addi	sp,sp,-16
    800007dc:	e406                	sd	ra,8(sp)
    800007de:	e022                	sd	s0,0(sp)
    800007e0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	f22080e7          	jalr	-222(ra) # 80000704 <kvmmake>
    800007ea:	00009797          	auipc	a5,0x9
    800007ee:	80a7bf23          	sd	a0,-2018(a5) # 80009008 <kernel_pagetable>
}
    800007f2:	60a2                	ld	ra,8(sp)
    800007f4:	6402                	ld	s0,0(sp)
    800007f6:	0141                	addi	sp,sp,16
    800007f8:	8082                	ret

00000000800007fa <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800007fa:	715d                	addi	sp,sp,-80
    800007fc:	e486                	sd	ra,72(sp)
    800007fe:	e0a2                	sd	s0,64(sp)
    80000800:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000802:	03459793          	slli	a5,a1,0x34
    80000806:	e39d                	bnez	a5,8000082c <uvmunmap+0x32>
    80000808:	f84a                	sd	s2,48(sp)
    8000080a:	f44e                	sd	s3,40(sp)
    8000080c:	f052                	sd	s4,32(sp)
    8000080e:	ec56                	sd	s5,24(sp)
    80000810:	e85a                	sd	s6,16(sp)
    80000812:	e45e                	sd	s7,8(sp)
    80000814:	8a2a                	mv	s4,a0
    80000816:	892e                	mv	s2,a1
    80000818:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000081a:	0632                	slli	a2,a2,0xc
    8000081c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000820:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000822:	6b05                	lui	s6,0x1
    80000824:	0935fb63          	bgeu	a1,s3,800008ba <uvmunmap+0xc0>
    80000828:	fc26                	sd	s1,56(sp)
    8000082a:	a8a9                	j	80000884 <uvmunmap+0x8a>
    8000082c:	fc26                	sd	s1,56(sp)
    8000082e:	f84a                	sd	s2,48(sp)
    80000830:	f44e                	sd	s3,40(sp)
    80000832:	f052                	sd	s4,32(sp)
    80000834:	ec56                	sd	s5,24(sp)
    80000836:	e85a                	sd	s6,16(sp)
    80000838:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000083a:	00008517          	auipc	a0,0x8
    8000083e:	84650513          	addi	a0,a0,-1978 # 80008080 <etext+0x80>
    80000842:	00006097          	auipc	ra,0x6
    80000846:	a24080e7          	jalr	-1500(ra) # 80006266 <panic>
      panic("uvmunmap: walk");
    8000084a:	00008517          	auipc	a0,0x8
    8000084e:	84e50513          	addi	a0,a0,-1970 # 80008098 <etext+0x98>
    80000852:	00006097          	auipc	ra,0x6
    80000856:	a14080e7          	jalr	-1516(ra) # 80006266 <panic>
      panic("uvmunmap: not mapped");
    8000085a:	00008517          	auipc	a0,0x8
    8000085e:	84e50513          	addi	a0,a0,-1970 # 800080a8 <etext+0xa8>
    80000862:	00006097          	auipc	ra,0x6
    80000866:	a04080e7          	jalr	-1532(ra) # 80006266 <panic>
      panic("uvmunmap: not a leaf");
    8000086a:	00008517          	auipc	a0,0x8
    8000086e:	85650513          	addi	a0,a0,-1962 # 800080c0 <etext+0xc0>
    80000872:	00006097          	auipc	ra,0x6
    80000876:	9f4080e7          	jalr	-1548(ra) # 80006266 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000087a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000087e:	995a                	add	s2,s2,s6
    80000880:	03397c63          	bgeu	s2,s3,800008b8 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000884:	4601                	li	a2,0
    80000886:	85ca                	mv	a1,s2
    80000888:	8552                	mv	a0,s4
    8000088a:	00000097          	auipc	ra,0x0
    8000088e:	cc2080e7          	jalr	-830(ra) # 8000054c <walk>
    80000892:	84aa                	mv	s1,a0
    80000894:	d95d                	beqz	a0,8000084a <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80000896:	6108                	ld	a0,0(a0)
    80000898:	00157793          	andi	a5,a0,1
    8000089c:	dfdd                	beqz	a5,8000085a <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000089e:	3ff57793          	andi	a5,a0,1023
    800008a2:	fd7784e3          	beq	a5,s7,8000086a <uvmunmap+0x70>
    if(do_free){
    800008a6:	fc0a8ae3          	beqz	s5,8000087a <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800008aa:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008ac:	0532                	slli	a0,a0,0xc
    800008ae:	fffff097          	auipc	ra,0xfffff
    800008b2:	76e080e7          	jalr	1902(ra) # 8000001c <kfree>
    800008b6:	b7d1                	j	8000087a <uvmunmap+0x80>
    800008b8:	74e2                	ld	s1,56(sp)
    800008ba:	7942                	ld	s2,48(sp)
    800008bc:	79a2                	ld	s3,40(sp)
    800008be:	7a02                	ld	s4,32(sp)
    800008c0:	6ae2                	ld	s5,24(sp)
    800008c2:	6b42                	ld	s6,16(sp)
    800008c4:	6ba2                	ld	s7,8(sp)
  }
}
    800008c6:	60a6                	ld	ra,72(sp)
    800008c8:	6406                	ld	s0,64(sp)
    800008ca:	6161                	addi	sp,sp,80
    800008cc:	8082                	ret

00000000800008ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008ce:	1101                	addi	sp,sp,-32
    800008d0:	ec06                	sd	ra,24(sp)
    800008d2:	e822                	sd	s0,16(sp)
    800008d4:	e426                	sd	s1,8(sp)
    800008d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	894080e7          	jalr	-1900(ra) # 8000016c <kalloc>
    800008e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008e2:	c519                	beqz	a0,800008f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008e4:	6605                	lui	a2,0x1
    800008e6:	4581                	li	a1,0
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	97c080e7          	jalr	-1668(ra) # 80000264 <memset>
  return pagetable;
}
    800008f0:	8526                	mv	a0,s1
    800008f2:	60e2                	ld	ra,24(sp)
    800008f4:	6442                	ld	s0,16(sp)
    800008f6:	64a2                	ld	s1,8(sp)
    800008f8:	6105                	addi	sp,sp,32
    800008fa:	8082                	ret

00000000800008fc <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800008fc:	7179                	addi	sp,sp,-48
    800008fe:	f406                	sd	ra,40(sp)
    80000900:	f022                	sd	s0,32(sp)
    80000902:	ec26                	sd	s1,24(sp)
    80000904:	e84a                	sd	s2,16(sp)
    80000906:	e44e                	sd	s3,8(sp)
    80000908:	e052                	sd	s4,0(sp)
    8000090a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000090c:	6785                	lui	a5,0x1
    8000090e:	04f67863          	bgeu	a2,a5,8000095e <uvminit+0x62>
    80000912:	8a2a                	mv	s4,a0
    80000914:	89ae                	mv	s3,a1
    80000916:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000918:	00000097          	auipc	ra,0x0
    8000091c:	854080e7          	jalr	-1964(ra) # 8000016c <kalloc>
    80000920:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000922:	6605                	lui	a2,0x1
    80000924:	4581                	li	a1,0
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	93e080e7          	jalr	-1730(ra) # 80000264 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000092e:	4779                	li	a4,30
    80000930:	86ca                	mv	a3,s2
    80000932:	6605                	lui	a2,0x1
    80000934:	4581                	li	a1,0
    80000936:	8552                	mv	a0,s4
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	cfc080e7          	jalr	-772(ra) # 80000634 <mappages>
  memmove(mem, src, sz);
    80000940:	8626                	mv	a2,s1
    80000942:	85ce                	mv	a1,s3
    80000944:	854a                	mv	a0,s2
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	97a080e7          	jalr	-1670(ra) # 800002c0 <memmove>
}
    8000094e:	70a2                	ld	ra,40(sp)
    80000950:	7402                	ld	s0,32(sp)
    80000952:	64e2                	ld	s1,24(sp)
    80000954:	6942                	ld	s2,16(sp)
    80000956:	69a2                	ld	s3,8(sp)
    80000958:	6a02                	ld	s4,0(sp)
    8000095a:	6145                	addi	sp,sp,48
    8000095c:	8082                	ret
    panic("inituvm: more than a page");
    8000095e:	00007517          	auipc	a0,0x7
    80000962:	77a50513          	addi	a0,a0,1914 # 800080d8 <etext+0xd8>
    80000966:	00006097          	auipc	ra,0x6
    8000096a:	900080e7          	jalr	-1792(ra) # 80006266 <panic>

000000008000096e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000096e:	1101                	addi	sp,sp,-32
    80000970:	ec06                	sd	ra,24(sp)
    80000972:	e822                	sd	s0,16(sp)
    80000974:	e426                	sd	s1,8(sp)
    80000976:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000978:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000097a:	00b67d63          	bgeu	a2,a1,80000994 <uvmdealloc+0x26>
    8000097e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000980:	6785                	lui	a5,0x1
    80000982:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000984:	00f60733          	add	a4,a2,a5
    80000988:	76fd                	lui	a3,0xfffff
    8000098a:	8f75                	and	a4,a4,a3
    8000098c:	97ae                	add	a5,a5,a1
    8000098e:	8ff5                	and	a5,a5,a3
    80000990:	00f76863          	bltu	a4,a5,800009a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000994:	8526                	mv	a0,s1
    80000996:	60e2                	ld	ra,24(sp)
    80000998:	6442                	ld	s0,16(sp)
    8000099a:	64a2                	ld	s1,8(sp)
    8000099c:	6105                	addi	sp,sp,32
    8000099e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009a0:	8f99                	sub	a5,a5,a4
    800009a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009a4:	4685                	li	a3,1
    800009a6:	0007861b          	sext.w	a2,a5
    800009aa:	85ba                	mv	a1,a4
    800009ac:	00000097          	auipc	ra,0x0
    800009b0:	e4e080e7          	jalr	-434(ra) # 800007fa <uvmunmap>
    800009b4:	b7c5                	j	80000994 <uvmdealloc+0x26>

00000000800009b6 <uvmalloc>:
  if(newsz < oldsz)
    800009b6:	0ab66563          	bltu	a2,a1,80000a60 <uvmalloc+0xaa>
{
    800009ba:	7139                	addi	sp,sp,-64
    800009bc:	fc06                	sd	ra,56(sp)
    800009be:	f822                	sd	s0,48(sp)
    800009c0:	ec4e                	sd	s3,24(sp)
    800009c2:	e852                	sd	s4,16(sp)
    800009c4:	e456                	sd	s5,8(sp)
    800009c6:	0080                	addi	s0,sp,64
    800009c8:	8aaa                	mv	s5,a0
    800009ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009cc:	6785                	lui	a5,0x1
    800009ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009d0:	95be                	add	a1,a1,a5
    800009d2:	77fd                	lui	a5,0xfffff
    800009d4:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009d8:	08c9f663          	bgeu	s3,a2,80000a64 <uvmalloc+0xae>
    800009dc:	f426                	sd	s1,40(sp)
    800009de:	f04a                	sd	s2,32(sp)
    800009e0:	894e                	mv	s2,s3
    mem = kalloc();
    800009e2:	fffff097          	auipc	ra,0xfffff
    800009e6:	78a080e7          	jalr	1930(ra) # 8000016c <kalloc>
    800009ea:	84aa                	mv	s1,a0
    if(mem == 0){
    800009ec:	c90d                	beqz	a0,80000a1e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800009ee:	6605                	lui	a2,0x1
    800009f0:	4581                	li	a1,0
    800009f2:	00000097          	auipc	ra,0x0
    800009f6:	872080e7          	jalr	-1934(ra) # 80000264 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800009fa:	4779                	li	a4,30
    800009fc:	86a6                	mv	a3,s1
    800009fe:	6605                	lui	a2,0x1
    80000a00:	85ca                	mv	a1,s2
    80000a02:	8556                	mv	a0,s5
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	c30080e7          	jalr	-976(ra) # 80000634 <mappages>
    80000a0c:	e915                	bnez	a0,80000a40 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a0e:	6785                	lui	a5,0x1
    80000a10:	993e                	add	s2,s2,a5
    80000a12:	fd4968e3          	bltu	s2,s4,800009e2 <uvmalloc+0x2c>
  return newsz;
    80000a16:	8552                	mv	a0,s4
    80000a18:	74a2                	ld	s1,40(sp)
    80000a1a:	7902                	ld	s2,32(sp)
    80000a1c:	a819                	j	80000a32 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000a1e:	864e                	mv	a2,s3
    80000a20:	85ca                	mv	a1,s2
    80000a22:	8556                	mv	a0,s5
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	f4a080e7          	jalr	-182(ra) # 8000096e <uvmdealloc>
      return 0;
    80000a2c:	4501                	li	a0,0
    80000a2e:	74a2                	ld	s1,40(sp)
    80000a30:	7902                	ld	s2,32(sp)
}
    80000a32:	70e2                	ld	ra,56(sp)
    80000a34:	7442                	ld	s0,48(sp)
    80000a36:	69e2                	ld	s3,24(sp)
    80000a38:	6a42                	ld	s4,16(sp)
    80000a3a:	6aa2                	ld	s5,8(sp)
    80000a3c:	6121                	addi	sp,sp,64
    80000a3e:	8082                	ret
      kfree(mem);
    80000a40:	8526                	mv	a0,s1
    80000a42:	fffff097          	auipc	ra,0xfffff
    80000a46:	5da080e7          	jalr	1498(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a4a:	864e                	mv	a2,s3
    80000a4c:	85ca                	mv	a1,s2
    80000a4e:	8556                	mv	a0,s5
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	f1e080e7          	jalr	-226(ra) # 8000096e <uvmdealloc>
      return 0;
    80000a58:	4501                	li	a0,0
    80000a5a:	74a2                	ld	s1,40(sp)
    80000a5c:	7902                	ld	s2,32(sp)
    80000a5e:	bfd1                	j	80000a32 <uvmalloc+0x7c>
    return oldsz;
    80000a60:	852e                	mv	a0,a1
}
    80000a62:	8082                	ret
  return newsz;
    80000a64:	8532                	mv	a0,a2
    80000a66:	b7f1                	j	80000a32 <uvmalloc+0x7c>

0000000080000a68 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a68:	7179                	addi	sp,sp,-48
    80000a6a:	f406                	sd	ra,40(sp)
    80000a6c:	f022                	sd	s0,32(sp)
    80000a6e:	ec26                	sd	s1,24(sp)
    80000a70:	e84a                	sd	s2,16(sp)
    80000a72:	e44e                	sd	s3,8(sp)
    80000a74:	e052                	sd	s4,0(sp)
    80000a76:	1800                	addi	s0,sp,48
    80000a78:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a7a:	84aa                	mv	s1,a0
    80000a7c:	6905                	lui	s2,0x1
    80000a7e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a80:	4985                	li	s3,1
    80000a82:	a829                	j	80000a9c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a84:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a86:	00c79513          	slli	a0,a5,0xc
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	fde080e7          	jalr	-34(ra) # 80000a68 <freewalk>
      pagetable[i] = 0;
    80000a92:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a96:	04a1                	addi	s1,s1,8
    80000a98:	03248163          	beq	s1,s2,80000aba <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a9c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a9e:	00f7f713          	andi	a4,a5,15
    80000aa2:	ff3701e3          	beq	a4,s3,80000a84 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000aa6:	8b85                	andi	a5,a5,1
    80000aa8:	d7fd                	beqz	a5,80000a96 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000aaa:	00007517          	auipc	a0,0x7
    80000aae:	64e50513          	addi	a0,a0,1614 # 800080f8 <etext+0xf8>
    80000ab2:	00005097          	auipc	ra,0x5
    80000ab6:	7b4080e7          	jalr	1972(ra) # 80006266 <panic>
    }
  }
  kfree((void*)pagetable);
    80000aba:	8552                	mv	a0,s4
    80000abc:	fffff097          	auipc	ra,0xfffff
    80000ac0:	560080e7          	jalr	1376(ra) # 8000001c <kfree>
}
    80000ac4:	70a2                	ld	ra,40(sp)
    80000ac6:	7402                	ld	s0,32(sp)
    80000ac8:	64e2                	ld	s1,24(sp)
    80000aca:	6942                	ld	s2,16(sp)
    80000acc:	69a2                	ld	s3,8(sp)
    80000ace:	6a02                	ld	s4,0(sp)
    80000ad0:	6145                	addi	sp,sp,48
    80000ad2:	8082                	ret

0000000080000ad4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ad4:	1101                	addi	sp,sp,-32
    80000ad6:	ec06                	sd	ra,24(sp)
    80000ad8:	e822                	sd	s0,16(sp)
    80000ada:	e426                	sd	s1,8(sp)
    80000adc:	1000                	addi	s0,sp,32
    80000ade:	84aa                	mv	s1,a0
  if(sz > 0)
    80000ae0:	e999                	bnez	a1,80000af6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000ae2:	8526                	mv	a0,s1
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	f84080e7          	jalr	-124(ra) # 80000a68 <freewalk>
}
    80000aec:	60e2                	ld	ra,24(sp)
    80000aee:	6442                	ld	s0,16(sp)
    80000af0:	64a2                	ld	s1,8(sp)
    80000af2:	6105                	addi	sp,sp,32
    80000af4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000af6:	6785                	lui	a5,0x1
    80000af8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000afa:	95be                	add	a1,a1,a5
    80000afc:	4685                	li	a3,1
    80000afe:	00c5d613          	srli	a2,a1,0xc
    80000b02:	4581                	li	a1,0
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	cf6080e7          	jalr	-778(ra) # 800007fa <uvmunmap>
    80000b0c:	bfd9                	j	80000ae2 <uvmfree+0xe>

0000000080000b0e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b0e:	c679                	beqz	a2,80000bdc <uvmcopy+0xce>
{
    80000b10:	715d                	addi	sp,sp,-80
    80000b12:	e486                	sd	ra,72(sp)
    80000b14:	e0a2                	sd	s0,64(sp)
    80000b16:	fc26                	sd	s1,56(sp)
    80000b18:	f84a                	sd	s2,48(sp)
    80000b1a:	f44e                	sd	s3,40(sp)
    80000b1c:	f052                	sd	s4,32(sp)
    80000b1e:	ec56                	sd	s5,24(sp)
    80000b20:	e85a                	sd	s6,16(sp)
    80000b22:	e45e                	sd	s7,8(sp)
    80000b24:	0880                	addi	s0,sp,80
    80000b26:	8b2a                	mv	s6,a0
    80000b28:	8aae                	mv	s5,a1
    80000b2a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b2c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b2e:	4601                	li	a2,0
    80000b30:	85ce                	mv	a1,s3
    80000b32:	855a                	mv	a0,s6
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	a18080e7          	jalr	-1512(ra) # 8000054c <walk>
    80000b3c:	c531                	beqz	a0,80000b88 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b3e:	6118                	ld	a4,0(a0)
    80000b40:	00177793          	andi	a5,a4,1
    80000b44:	cbb1                	beqz	a5,80000b98 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b46:	00a75593          	srli	a1,a4,0xa
    80000b4a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b4e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b52:	fffff097          	auipc	ra,0xfffff
    80000b56:	61a080e7          	jalr	1562(ra) # 8000016c <kalloc>
    80000b5a:	892a                	mv	s2,a0
    80000b5c:	c939                	beqz	a0,80000bb2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b5e:	6605                	lui	a2,0x1
    80000b60:	85de                	mv	a1,s7
    80000b62:	fffff097          	auipc	ra,0xfffff
    80000b66:	75e080e7          	jalr	1886(ra) # 800002c0 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b6a:	8726                	mv	a4,s1
    80000b6c:	86ca                	mv	a3,s2
    80000b6e:	6605                	lui	a2,0x1
    80000b70:	85ce                	mv	a1,s3
    80000b72:	8556                	mv	a0,s5
    80000b74:	00000097          	auipc	ra,0x0
    80000b78:	ac0080e7          	jalr	-1344(ra) # 80000634 <mappages>
    80000b7c:	e515                	bnez	a0,80000ba8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b7e:	6785                	lui	a5,0x1
    80000b80:	99be                	add	s3,s3,a5
    80000b82:	fb49e6e3          	bltu	s3,s4,80000b2e <uvmcopy+0x20>
    80000b86:	a081                	j	80000bc6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b88:	00007517          	auipc	a0,0x7
    80000b8c:	58050513          	addi	a0,a0,1408 # 80008108 <etext+0x108>
    80000b90:	00005097          	auipc	ra,0x5
    80000b94:	6d6080e7          	jalr	1750(ra) # 80006266 <panic>
      panic("uvmcopy: page not present");
    80000b98:	00007517          	auipc	a0,0x7
    80000b9c:	59050513          	addi	a0,a0,1424 # 80008128 <etext+0x128>
    80000ba0:	00005097          	auipc	ra,0x5
    80000ba4:	6c6080e7          	jalr	1734(ra) # 80006266 <panic>
      kfree(mem);
    80000ba8:	854a                	mv	a0,s2
    80000baa:	fffff097          	auipc	ra,0xfffff
    80000bae:	472080e7          	jalr	1138(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bb2:	4685                	li	a3,1
    80000bb4:	00c9d613          	srli	a2,s3,0xc
    80000bb8:	4581                	li	a1,0
    80000bba:	8556                	mv	a0,s5
    80000bbc:	00000097          	auipc	ra,0x0
    80000bc0:	c3e080e7          	jalr	-962(ra) # 800007fa <uvmunmap>
  return -1;
    80000bc4:	557d                	li	a0,-1
}
    80000bc6:	60a6                	ld	ra,72(sp)
    80000bc8:	6406                	ld	s0,64(sp)
    80000bca:	74e2                	ld	s1,56(sp)
    80000bcc:	7942                	ld	s2,48(sp)
    80000bce:	79a2                	ld	s3,40(sp)
    80000bd0:	7a02                	ld	s4,32(sp)
    80000bd2:	6ae2                	ld	s5,24(sp)
    80000bd4:	6b42                	ld	s6,16(sp)
    80000bd6:	6ba2                	ld	s7,8(sp)
    80000bd8:	6161                	addi	sp,sp,80
    80000bda:	8082                	ret
  return 0;
    80000bdc:	4501                	li	a0,0
}
    80000bde:	8082                	ret

0000000080000be0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000be0:	1141                	addi	sp,sp,-16
    80000be2:	e406                	sd	ra,8(sp)
    80000be4:	e022                	sd	s0,0(sp)
    80000be6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000be8:	4601                	li	a2,0
    80000bea:	00000097          	auipc	ra,0x0
    80000bee:	962080e7          	jalr	-1694(ra) # 8000054c <walk>
  if(pte == 0)
    80000bf2:	c901                	beqz	a0,80000c02 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bf4:	611c                	ld	a5,0(a0)
    80000bf6:	9bbd                	andi	a5,a5,-17
    80000bf8:	e11c                	sd	a5,0(a0)
}
    80000bfa:	60a2                	ld	ra,8(sp)
    80000bfc:	6402                	ld	s0,0(sp)
    80000bfe:	0141                	addi	sp,sp,16
    80000c00:	8082                	ret
    panic("uvmclear");
    80000c02:	00007517          	auipc	a0,0x7
    80000c06:	54650513          	addi	a0,a0,1350 # 80008148 <etext+0x148>
    80000c0a:	00005097          	auipc	ra,0x5
    80000c0e:	65c080e7          	jalr	1628(ra) # 80006266 <panic>

0000000080000c12 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c12:	c6bd                	beqz	a3,80000c80 <copyout+0x6e>
{
    80000c14:	715d                	addi	sp,sp,-80
    80000c16:	e486                	sd	ra,72(sp)
    80000c18:	e0a2                	sd	s0,64(sp)
    80000c1a:	fc26                	sd	s1,56(sp)
    80000c1c:	f84a                	sd	s2,48(sp)
    80000c1e:	f44e                	sd	s3,40(sp)
    80000c20:	f052                	sd	s4,32(sp)
    80000c22:	ec56                	sd	s5,24(sp)
    80000c24:	e85a                	sd	s6,16(sp)
    80000c26:	e45e                	sd	s7,8(sp)
    80000c28:	e062                	sd	s8,0(sp)
    80000c2a:	0880                	addi	s0,sp,80
    80000c2c:	8b2a                	mv	s6,a0
    80000c2e:	8c2e                	mv	s8,a1
    80000c30:	8a32                	mv	s4,a2
    80000c32:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c34:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c36:	6a85                	lui	s5,0x1
    80000c38:	a015                	j	80000c5c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c3a:	9562                	add	a0,a0,s8
    80000c3c:	0004861b          	sext.w	a2,s1
    80000c40:	85d2                	mv	a1,s4
    80000c42:	41250533          	sub	a0,a0,s2
    80000c46:	fffff097          	auipc	ra,0xfffff
    80000c4a:	67a080e7          	jalr	1658(ra) # 800002c0 <memmove>

    len -= n;
    80000c4e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c52:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c54:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c58:	02098263          	beqz	s3,80000c7c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c5c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c60:	85ca                	mv	a1,s2
    80000c62:	855a                	mv	a0,s6
    80000c64:	00000097          	auipc	ra,0x0
    80000c68:	98e080e7          	jalr	-1650(ra) # 800005f2 <walkaddr>
    if(pa0 == 0)
    80000c6c:	cd01                	beqz	a0,80000c84 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c6e:	418904b3          	sub	s1,s2,s8
    80000c72:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c74:	fc99f3e3          	bgeu	s3,s1,80000c3a <copyout+0x28>
    80000c78:	84ce                	mv	s1,s3
    80000c7a:	b7c1                	j	80000c3a <copyout+0x28>
  }
  return 0;
    80000c7c:	4501                	li	a0,0
    80000c7e:	a021                	j	80000c86 <copyout+0x74>
    80000c80:	4501                	li	a0,0
}
    80000c82:	8082                	ret
      return -1;
    80000c84:	557d                	li	a0,-1
}
    80000c86:	60a6                	ld	ra,72(sp)
    80000c88:	6406                	ld	s0,64(sp)
    80000c8a:	74e2                	ld	s1,56(sp)
    80000c8c:	7942                	ld	s2,48(sp)
    80000c8e:	79a2                	ld	s3,40(sp)
    80000c90:	7a02                	ld	s4,32(sp)
    80000c92:	6ae2                	ld	s5,24(sp)
    80000c94:	6b42                	ld	s6,16(sp)
    80000c96:	6ba2                	ld	s7,8(sp)
    80000c98:	6c02                	ld	s8,0(sp)
    80000c9a:	6161                	addi	sp,sp,80
    80000c9c:	8082                	ret

0000000080000c9e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c9e:	caa5                	beqz	a3,80000d0e <copyin+0x70>
{
    80000ca0:	715d                	addi	sp,sp,-80
    80000ca2:	e486                	sd	ra,72(sp)
    80000ca4:	e0a2                	sd	s0,64(sp)
    80000ca6:	fc26                	sd	s1,56(sp)
    80000ca8:	f84a                	sd	s2,48(sp)
    80000caa:	f44e                	sd	s3,40(sp)
    80000cac:	f052                	sd	s4,32(sp)
    80000cae:	ec56                	sd	s5,24(sp)
    80000cb0:	e85a                	sd	s6,16(sp)
    80000cb2:	e45e                	sd	s7,8(sp)
    80000cb4:	e062                	sd	s8,0(sp)
    80000cb6:	0880                	addi	s0,sp,80
    80000cb8:	8b2a                	mv	s6,a0
    80000cba:	8a2e                	mv	s4,a1
    80000cbc:	8c32                	mv	s8,a2
    80000cbe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000cc0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cc2:	6a85                	lui	s5,0x1
    80000cc4:	a01d                	j	80000cea <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000cc6:	018505b3          	add	a1,a0,s8
    80000cca:	0004861b          	sext.w	a2,s1
    80000cce:	412585b3          	sub	a1,a1,s2
    80000cd2:	8552                	mv	a0,s4
    80000cd4:	fffff097          	auipc	ra,0xfffff
    80000cd8:	5ec080e7          	jalr	1516(ra) # 800002c0 <memmove>

    len -= n;
    80000cdc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000ce0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000ce2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ce6:	02098263          	beqz	s3,80000d0a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000cea:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cee:	85ca                	mv	a1,s2
    80000cf0:	855a                	mv	a0,s6
    80000cf2:	00000097          	auipc	ra,0x0
    80000cf6:	900080e7          	jalr	-1792(ra) # 800005f2 <walkaddr>
    if(pa0 == 0)
    80000cfa:	cd01                	beqz	a0,80000d12 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000cfc:	418904b3          	sub	s1,s2,s8
    80000d00:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d02:	fc99f2e3          	bgeu	s3,s1,80000cc6 <copyin+0x28>
    80000d06:	84ce                	mv	s1,s3
    80000d08:	bf7d                	j	80000cc6 <copyin+0x28>
  }
  return 0;
    80000d0a:	4501                	li	a0,0
    80000d0c:	a021                	j	80000d14 <copyin+0x76>
    80000d0e:	4501                	li	a0,0
}
    80000d10:	8082                	ret
      return -1;
    80000d12:	557d                	li	a0,-1
}
    80000d14:	60a6                	ld	ra,72(sp)
    80000d16:	6406                	ld	s0,64(sp)
    80000d18:	74e2                	ld	s1,56(sp)
    80000d1a:	7942                	ld	s2,48(sp)
    80000d1c:	79a2                	ld	s3,40(sp)
    80000d1e:	7a02                	ld	s4,32(sp)
    80000d20:	6ae2                	ld	s5,24(sp)
    80000d22:	6b42                	ld	s6,16(sp)
    80000d24:	6ba2                	ld	s7,8(sp)
    80000d26:	6c02                	ld	s8,0(sp)
    80000d28:	6161                	addi	sp,sp,80
    80000d2a:	8082                	ret

0000000080000d2c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d2c:	cacd                	beqz	a3,80000dde <copyinstr+0xb2>
{
    80000d2e:	715d                	addi	sp,sp,-80
    80000d30:	e486                	sd	ra,72(sp)
    80000d32:	e0a2                	sd	s0,64(sp)
    80000d34:	fc26                	sd	s1,56(sp)
    80000d36:	f84a                	sd	s2,48(sp)
    80000d38:	f44e                	sd	s3,40(sp)
    80000d3a:	f052                	sd	s4,32(sp)
    80000d3c:	ec56                	sd	s5,24(sp)
    80000d3e:	e85a                	sd	s6,16(sp)
    80000d40:	e45e                	sd	s7,8(sp)
    80000d42:	0880                	addi	s0,sp,80
    80000d44:	8a2a                	mv	s4,a0
    80000d46:	8b2e                	mv	s6,a1
    80000d48:	8bb2                	mv	s7,a2
    80000d4a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000d4c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d4e:	6985                	lui	s3,0x1
    80000d50:	a825                	j	80000d88 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d52:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d56:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d58:	37fd                	addiw	a5,a5,-1
    80000d5a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d5e:	60a6                	ld	ra,72(sp)
    80000d60:	6406                	ld	s0,64(sp)
    80000d62:	74e2                	ld	s1,56(sp)
    80000d64:	7942                	ld	s2,48(sp)
    80000d66:	79a2                	ld	s3,40(sp)
    80000d68:	7a02                	ld	s4,32(sp)
    80000d6a:	6ae2                	ld	s5,24(sp)
    80000d6c:	6b42                	ld	s6,16(sp)
    80000d6e:	6ba2                	ld	s7,8(sp)
    80000d70:	6161                	addi	sp,sp,80
    80000d72:	8082                	ret
    80000d74:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d78:	9742                	add	a4,a4,a6
      --max;
    80000d7a:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d7e:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000d82:	04e58663          	beq	a1,a4,80000dce <copyinstr+0xa2>
{
    80000d86:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d88:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d8c:	85a6                	mv	a1,s1
    80000d8e:	8552                	mv	a0,s4
    80000d90:	00000097          	auipc	ra,0x0
    80000d94:	862080e7          	jalr	-1950(ra) # 800005f2 <walkaddr>
    if(pa0 == 0)
    80000d98:	cd0d                	beqz	a0,80000dd2 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000d9a:	417486b3          	sub	a3,s1,s7
    80000d9e:	96ce                	add	a3,a3,s3
    if(n > max)
    80000da0:	00d97363          	bgeu	s2,a3,80000da6 <copyinstr+0x7a>
    80000da4:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000da6:	955e                	add	a0,a0,s7
    80000da8:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000daa:	c695                	beqz	a3,80000dd6 <copyinstr+0xaa>
    80000dac:	87da                	mv	a5,s6
    80000dae:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000db0:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000db4:	96da                	add	a3,a3,s6
    80000db6:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000db8:	00f60733          	add	a4,a2,a5
    80000dbc:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd3db8>
    80000dc0:	db49                	beqz	a4,80000d52 <copyinstr+0x26>
        *dst = *p;
    80000dc2:	00e78023          	sb	a4,0(a5)
      dst++;
    80000dc6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000dc8:	fed797e3          	bne	a5,a3,80000db6 <copyinstr+0x8a>
    80000dcc:	b765                	j	80000d74 <copyinstr+0x48>
    80000dce:	4781                	li	a5,0
    80000dd0:	b761                	j	80000d58 <copyinstr+0x2c>
      return -1;
    80000dd2:	557d                	li	a0,-1
    80000dd4:	b769                	j	80000d5e <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000dd6:	6b85                	lui	s7,0x1
    80000dd8:	9ba6                	add	s7,s7,s1
    80000dda:	87da                	mv	a5,s6
    80000ddc:	b76d                	j	80000d86 <copyinstr+0x5a>
  int got_null = 0;
    80000dde:	4781                	li	a5,0
  if(got_null){
    80000de0:	37fd                	addiw	a5,a5,-1
    80000de2:	0007851b          	sext.w	a0,a5
}
    80000de6:	8082                	ret

0000000080000de8 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000de8:	7139                	addi	sp,sp,-64
    80000dea:	fc06                	sd	ra,56(sp)
    80000dec:	f822                	sd	s0,48(sp)
    80000dee:	f426                	sd	s1,40(sp)
    80000df0:	f04a                	sd	s2,32(sp)
    80000df2:	ec4e                	sd	s3,24(sp)
    80000df4:	e852                	sd	s4,16(sp)
    80000df6:	e456                	sd	s5,8(sp)
    80000df8:	e05a                	sd	s6,0(sp)
    80000dfa:	0080                	addi	s0,sp,64
    80000dfc:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfe:	00008497          	auipc	s1,0x8
    80000e02:	7b248493          	addi	s1,s1,1970 # 800095b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e06:	8b26                	mv	s6,s1
    80000e08:	ff4df937          	lui	s2,0xff4df
    80000e0c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b3775>
    80000e10:	0936                	slli	s2,s2,0xd
    80000e12:	6f590913          	addi	s2,s2,1781
    80000e16:	0936                	slli	s2,s2,0xd
    80000e18:	bd390913          	addi	s2,s2,-1069
    80000e1c:	0932                	slli	s2,s2,0xc
    80000e1e:	7a790913          	addi	s2,s2,1959
    80000e22:	040009b7          	lui	s3,0x4000
    80000e26:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e28:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e2a:	0000ea97          	auipc	s5,0xe
    80000e2e:	386a8a93          	addi	s5,s5,902 # 8000f1b0 <tickslock>
    char *pa = kalloc();
    80000e32:	fffff097          	auipc	ra,0xfffff
    80000e36:	33a080e7          	jalr	826(ra) # 8000016c <kalloc>
    80000e3a:	862a                	mv	a2,a0
    if(pa == 0)
    80000e3c:	c121                	beqz	a0,80000e7c <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000e3e:	416485b3          	sub	a1,s1,s6
    80000e42:	8591                	srai	a1,a1,0x4
    80000e44:	032585b3          	mul	a1,a1,s2
    80000e48:	2585                	addiw	a1,a1,1
    80000e4a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e4e:	4719                	li	a4,6
    80000e50:	6685                	lui	a3,0x1
    80000e52:	40b985b3          	sub	a1,s3,a1
    80000e56:	8552                	mv	a0,s4
    80000e58:	00000097          	auipc	ra,0x0
    80000e5c:	87c080e7          	jalr	-1924(ra) # 800006d4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e60:	17048493          	addi	s1,s1,368
    80000e64:	fd5497e3          	bne	s1,s5,80000e32 <proc_mapstacks+0x4a>
  }
}
    80000e68:	70e2                	ld	ra,56(sp)
    80000e6a:	7442                	ld	s0,48(sp)
    80000e6c:	74a2                	ld	s1,40(sp)
    80000e6e:	7902                	ld	s2,32(sp)
    80000e70:	69e2                	ld	s3,24(sp)
    80000e72:	6a42                	ld	s4,16(sp)
    80000e74:	6aa2                	ld	s5,8(sp)
    80000e76:	6b02                	ld	s6,0(sp)
    80000e78:	6121                	addi	sp,sp,64
    80000e7a:	8082                	ret
      panic("kalloc");
    80000e7c:	00007517          	auipc	a0,0x7
    80000e80:	2dc50513          	addi	a0,a0,732 # 80008158 <etext+0x158>
    80000e84:	00005097          	auipc	ra,0x5
    80000e88:	3e2080e7          	jalr	994(ra) # 80006266 <panic>

0000000080000e8c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e8c:	7139                	addi	sp,sp,-64
    80000e8e:	fc06                	sd	ra,56(sp)
    80000e90:	f822                	sd	s0,48(sp)
    80000e92:	f426                	sd	s1,40(sp)
    80000e94:	f04a                	sd	s2,32(sp)
    80000e96:	ec4e                	sd	s3,24(sp)
    80000e98:	e852                	sd	s4,16(sp)
    80000e9a:	e456                	sd	s5,8(sp)
    80000e9c:	e05a                	sd	s6,0(sp)
    80000e9e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ea0:	00007597          	auipc	a1,0x7
    80000ea4:	2c058593          	addi	a1,a1,704 # 80008160 <etext+0x160>
    80000ea8:	00008517          	auipc	a0,0x8
    80000eac:	2c850513          	addi	a0,a0,712 # 80009170 <pid_lock>
    80000eb0:	00006097          	auipc	ra,0x6
    80000eb4:	a96080e7          	jalr	-1386(ra) # 80006946 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000eb8:	00007597          	auipc	a1,0x7
    80000ebc:	2b058593          	addi	a1,a1,688 # 80008168 <etext+0x168>
    80000ec0:	00008517          	auipc	a0,0x8
    80000ec4:	2d050513          	addi	a0,a0,720 # 80009190 <wait_lock>
    80000ec8:	00006097          	auipc	ra,0x6
    80000ecc:	a7e080e7          	jalr	-1410(ra) # 80006946 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed0:	00008497          	auipc	s1,0x8
    80000ed4:	6e048493          	addi	s1,s1,1760 # 800095b0 <proc>
      initlock(&p->lock, "proc");
    80000ed8:	00007b17          	auipc	s6,0x7
    80000edc:	2a0b0b13          	addi	s6,s6,672 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000ee0:	8aa6                	mv	s5,s1
    80000ee2:	ff4df937          	lui	s2,0xff4df
    80000ee6:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b3775>
    80000eea:	0936                	slli	s2,s2,0xd
    80000eec:	6f590913          	addi	s2,s2,1781
    80000ef0:	0936                	slli	s2,s2,0xd
    80000ef2:	bd390913          	addi	s2,s2,-1069
    80000ef6:	0932                	slli	s2,s2,0xc
    80000ef8:	7a790913          	addi	s2,s2,1959
    80000efc:	040009b7          	lui	s3,0x4000
    80000f00:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000f02:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f04:	0000ea17          	auipc	s4,0xe
    80000f08:	2aca0a13          	addi	s4,s4,684 # 8000f1b0 <tickslock>
      initlock(&p->lock, "proc");
    80000f0c:	85da                	mv	a1,s6
    80000f0e:	8526                	mv	a0,s1
    80000f10:	00006097          	auipc	ra,0x6
    80000f14:	a36080e7          	jalr	-1482(ra) # 80006946 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f18:	415487b3          	sub	a5,s1,s5
    80000f1c:	8791                	srai	a5,a5,0x4
    80000f1e:	032787b3          	mul	a5,a5,s2
    80000f22:	2785                	addiw	a5,a5,1
    80000f24:	00d7979b          	slliw	a5,a5,0xd
    80000f28:	40f987b3          	sub	a5,s3,a5
    80000f2c:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2e:	17048493          	addi	s1,s1,368
    80000f32:	fd449de3          	bne	s1,s4,80000f0c <procinit+0x80>
  }
}
    80000f36:	70e2                	ld	ra,56(sp)
    80000f38:	7442                	ld	s0,48(sp)
    80000f3a:	74a2                	ld	s1,40(sp)
    80000f3c:	7902                	ld	s2,32(sp)
    80000f3e:	69e2                	ld	s3,24(sp)
    80000f40:	6a42                	ld	s4,16(sp)
    80000f42:	6aa2                	ld	s5,8(sp)
    80000f44:	6b02                	ld	s6,0(sp)
    80000f46:	6121                	addi	sp,sp,64
    80000f48:	8082                	ret

0000000080000f4a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f4a:	1141                	addi	sp,sp,-16
    80000f4c:	e422                	sd	s0,8(sp)
    80000f4e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f50:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f52:	2501                	sext.w	a0,a0
    80000f54:	6422                	ld	s0,8(sp)
    80000f56:	0141                	addi	sp,sp,16
    80000f58:	8082                	ret

0000000080000f5a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f5a:	1141                	addi	sp,sp,-16
    80000f5c:	e422                	sd	s0,8(sp)
    80000f5e:	0800                	addi	s0,sp,16
    80000f60:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f62:	2781                	sext.w	a5,a5
    80000f64:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f66:	00008517          	auipc	a0,0x8
    80000f6a:	24a50513          	addi	a0,a0,586 # 800091b0 <cpus>
    80000f6e:	953e                	add	a0,a0,a5
    80000f70:	6422                	ld	s0,8(sp)
    80000f72:	0141                	addi	sp,sp,16
    80000f74:	8082                	ret

0000000080000f76 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f76:	1101                	addi	sp,sp,-32
    80000f78:	ec06                	sd	ra,24(sp)
    80000f7a:	e822                	sd	s0,16(sp)
    80000f7c:	e426                	sd	s1,8(sp)
    80000f7e:	1000                	addi	s0,sp,32
  push_off();
    80000f80:	00005097          	auipc	ra,0x5
    80000f84:	7fe080e7          	jalr	2046(ra) # 8000677e <push_off>
    80000f88:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f8a:	2781                	sext.w	a5,a5
    80000f8c:	079e                	slli	a5,a5,0x7
    80000f8e:	00008717          	auipc	a4,0x8
    80000f92:	1e270713          	addi	a4,a4,482 # 80009170 <pid_lock>
    80000f96:	97ba                	add	a5,a5,a4
    80000f98:	63a4                	ld	s1,64(a5)
  pop_off();
    80000f9a:	00006097          	auipc	ra,0x6
    80000f9e:	8a0080e7          	jalr	-1888(ra) # 8000683a <pop_off>
  return p;
}
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	60e2                	ld	ra,24(sp)
    80000fa6:	6442                	ld	s0,16(sp)
    80000fa8:	64a2                	ld	s1,8(sp)
    80000faa:	6105                	addi	sp,sp,32
    80000fac:	8082                	ret

0000000080000fae <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fae:	1141                	addi	sp,sp,-16
    80000fb0:	e406                	sd	ra,8(sp)
    80000fb2:	e022                	sd	s0,0(sp)
    80000fb4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fb6:	00000097          	auipc	ra,0x0
    80000fba:	fc0080e7          	jalr	-64(ra) # 80000f76 <myproc>
    80000fbe:	00006097          	auipc	ra,0x6
    80000fc2:	8dc080e7          	jalr	-1828(ra) # 8000689a <release>

  if (first) {
    80000fc6:	00008797          	auipc	a5,0x8
    80000fca:	90a7a783          	lw	a5,-1782(a5) # 800088d0 <first.1>
    80000fce:	eb89                	bnez	a5,80000fe0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	c16080e7          	jalr	-1002(ra) # 80001be6 <usertrapret>
}
    80000fd8:	60a2                	ld	ra,8(sp)
    80000fda:	6402                	ld	s0,0(sp)
    80000fdc:	0141                	addi	sp,sp,16
    80000fde:	8082                	ret
    first = 0;
    80000fe0:	00008797          	auipc	a5,0x8
    80000fe4:	8e07a823          	sw	zero,-1808(a5) # 800088d0 <first.1>
    fsinit(ROOTDEV);
    80000fe8:	4505                	li	a0,1
    80000fea:	00002097          	auipc	ra,0x2
    80000fee:	b16080e7          	jalr	-1258(ra) # 80002b00 <fsinit>
    80000ff2:	bff9                	j	80000fd0 <forkret+0x22>

0000000080000ff4 <allocpid>:
allocpid() {
    80000ff4:	1101                	addi	sp,sp,-32
    80000ff6:	ec06                	sd	ra,24(sp)
    80000ff8:	e822                	sd	s0,16(sp)
    80000ffa:	e426                	sd	s1,8(sp)
    80000ffc:	e04a                	sd	s2,0(sp)
    80000ffe:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001000:	00008917          	auipc	s2,0x8
    80001004:	17090913          	addi	s2,s2,368 # 80009170 <pid_lock>
    80001008:	854a                	mv	a0,s2
    8000100a:	00005097          	auipc	ra,0x5
    8000100e:	7c0080e7          	jalr	1984(ra) # 800067ca <acquire>
  pid = nextpid;
    80001012:	00008797          	auipc	a5,0x8
    80001016:	8c278793          	addi	a5,a5,-1854 # 800088d4 <nextpid>
    8000101a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000101c:	0014871b          	addiw	a4,s1,1
    80001020:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001022:	854a                	mv	a0,s2
    80001024:	00006097          	auipc	ra,0x6
    80001028:	876080e7          	jalr	-1930(ra) # 8000689a <release>
}
    8000102c:	8526                	mv	a0,s1
    8000102e:	60e2                	ld	ra,24(sp)
    80001030:	6442                	ld	s0,16(sp)
    80001032:	64a2                	ld	s1,8(sp)
    80001034:	6902                	ld	s2,0(sp)
    80001036:	6105                	addi	sp,sp,32
    80001038:	8082                	ret

000000008000103a <proc_pagetable>:
{
    8000103a:	1101                	addi	sp,sp,-32
    8000103c:	ec06                	sd	ra,24(sp)
    8000103e:	e822                	sd	s0,16(sp)
    80001040:	e426                	sd	s1,8(sp)
    80001042:	e04a                	sd	s2,0(sp)
    80001044:	1000                	addi	s0,sp,32
    80001046:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001048:	00000097          	auipc	ra,0x0
    8000104c:	886080e7          	jalr	-1914(ra) # 800008ce <uvmcreate>
    80001050:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001052:	c121                	beqz	a0,80001092 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001054:	4729                	li	a4,10
    80001056:	00006697          	auipc	a3,0x6
    8000105a:	faa68693          	addi	a3,a3,-86 # 80007000 <_trampoline>
    8000105e:	6605                	lui	a2,0x1
    80001060:	040005b7          	lui	a1,0x4000
    80001064:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001066:	05b2                	slli	a1,a1,0xc
    80001068:	fffff097          	auipc	ra,0xfffff
    8000106c:	5cc080e7          	jalr	1484(ra) # 80000634 <mappages>
    80001070:	02054863          	bltz	a0,800010a0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001074:	4719                	li	a4,6
    80001076:	06093683          	ld	a3,96(s2)
    8000107a:	6605                	lui	a2,0x1
    8000107c:	020005b7          	lui	a1,0x2000
    80001080:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001082:	05b6                	slli	a1,a1,0xd
    80001084:	8526                	mv	a0,s1
    80001086:	fffff097          	auipc	ra,0xfffff
    8000108a:	5ae080e7          	jalr	1454(ra) # 80000634 <mappages>
    8000108e:	02054163          	bltz	a0,800010b0 <proc_pagetable+0x76>
}
    80001092:	8526                	mv	a0,s1
    80001094:	60e2                	ld	ra,24(sp)
    80001096:	6442                	ld	s0,16(sp)
    80001098:	64a2                	ld	s1,8(sp)
    8000109a:	6902                	ld	s2,0(sp)
    8000109c:	6105                	addi	sp,sp,32
    8000109e:	8082                	ret
    uvmfree(pagetable, 0);
    800010a0:	4581                	li	a1,0
    800010a2:	8526                	mv	a0,s1
    800010a4:	00000097          	auipc	ra,0x0
    800010a8:	a30080e7          	jalr	-1488(ra) # 80000ad4 <uvmfree>
    return 0;
    800010ac:	4481                	li	s1,0
    800010ae:	b7d5                	j	80001092 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010b0:	4681                	li	a3,0
    800010b2:	4605                	li	a2,1
    800010b4:	040005b7          	lui	a1,0x4000
    800010b8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010ba:	05b2                	slli	a1,a1,0xc
    800010bc:	8526                	mv	a0,s1
    800010be:	fffff097          	auipc	ra,0xfffff
    800010c2:	73c080e7          	jalr	1852(ra) # 800007fa <uvmunmap>
    uvmfree(pagetable, 0);
    800010c6:	4581                	li	a1,0
    800010c8:	8526                	mv	a0,s1
    800010ca:	00000097          	auipc	ra,0x0
    800010ce:	a0a080e7          	jalr	-1526(ra) # 80000ad4 <uvmfree>
    return 0;
    800010d2:	4481                	li	s1,0
    800010d4:	bf7d                	j	80001092 <proc_pagetable+0x58>

00000000800010d6 <proc_freepagetable>:
{
    800010d6:	1101                	addi	sp,sp,-32
    800010d8:	ec06                	sd	ra,24(sp)
    800010da:	e822                	sd	s0,16(sp)
    800010dc:	e426                	sd	s1,8(sp)
    800010de:	e04a                	sd	s2,0(sp)
    800010e0:	1000                	addi	s0,sp,32
    800010e2:	84aa                	mv	s1,a0
    800010e4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010e6:	4681                	li	a3,0
    800010e8:	4605                	li	a2,1
    800010ea:	040005b7          	lui	a1,0x4000
    800010ee:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010f0:	05b2                	slli	a1,a1,0xc
    800010f2:	fffff097          	auipc	ra,0xfffff
    800010f6:	708080e7          	jalr	1800(ra) # 800007fa <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010fa:	4681                	li	a3,0
    800010fc:	4605                	li	a2,1
    800010fe:	020005b7          	lui	a1,0x2000
    80001102:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001104:	05b6                	slli	a1,a1,0xd
    80001106:	8526                	mv	a0,s1
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	6f2080e7          	jalr	1778(ra) # 800007fa <uvmunmap>
  uvmfree(pagetable, sz);
    80001110:	85ca                	mv	a1,s2
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	9c0080e7          	jalr	-1600(ra) # 80000ad4 <uvmfree>
}
    8000111c:	60e2                	ld	ra,24(sp)
    8000111e:	6442                	ld	s0,16(sp)
    80001120:	64a2                	ld	s1,8(sp)
    80001122:	6902                	ld	s2,0(sp)
    80001124:	6105                	addi	sp,sp,32
    80001126:	8082                	ret

0000000080001128 <freeproc>:
{
    80001128:	1101                	addi	sp,sp,-32
    8000112a:	ec06                	sd	ra,24(sp)
    8000112c:	e822                	sd	s0,16(sp)
    8000112e:	e426                	sd	s1,8(sp)
    80001130:	1000                	addi	s0,sp,32
    80001132:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001134:	7128                	ld	a0,96(a0)
    80001136:	c509                	beqz	a0,80001140 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001138:	fffff097          	auipc	ra,0xfffff
    8000113c:	ee4080e7          	jalr	-284(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001140:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001144:	6ca8                	ld	a0,88(s1)
    80001146:	c511                	beqz	a0,80001152 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001148:	68ac                	ld	a1,80(s1)
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	f8c080e7          	jalr	-116(ra) # 800010d6 <proc_freepagetable>
  p->pagetable = 0;
    80001152:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001156:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000115a:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    8000115e:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001162:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001166:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000116a:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    8000116e:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001172:	0204a023          	sw	zero,32(s1)
}
    80001176:	60e2                	ld	ra,24(sp)
    80001178:	6442                	ld	s0,16(sp)
    8000117a:	64a2                	ld	s1,8(sp)
    8000117c:	6105                	addi	sp,sp,32
    8000117e:	8082                	ret

0000000080001180 <allocproc>:
{
    80001180:	1101                	addi	sp,sp,-32
    80001182:	ec06                	sd	ra,24(sp)
    80001184:	e822                	sd	s0,16(sp)
    80001186:	e426                	sd	s1,8(sp)
    80001188:	e04a                	sd	s2,0(sp)
    8000118a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000118c:	00008497          	auipc	s1,0x8
    80001190:	42448493          	addi	s1,s1,1060 # 800095b0 <proc>
    80001194:	0000e917          	auipc	s2,0xe
    80001198:	01c90913          	addi	s2,s2,28 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    8000119c:	8526                	mv	a0,s1
    8000119e:	00005097          	auipc	ra,0x5
    800011a2:	62c080e7          	jalr	1580(ra) # 800067ca <acquire>
    if(p->state == UNUSED) {
    800011a6:	509c                	lw	a5,32(s1)
    800011a8:	cf81                	beqz	a5,800011c0 <allocproc+0x40>
      release(&p->lock);
    800011aa:	8526                	mv	a0,s1
    800011ac:	00005097          	auipc	ra,0x5
    800011b0:	6ee080e7          	jalr	1774(ra) # 8000689a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011b4:	17048493          	addi	s1,s1,368
    800011b8:	ff2492e3          	bne	s1,s2,8000119c <allocproc+0x1c>
  return 0;
    800011bc:	4481                	li	s1,0
    800011be:	a889                	j	80001210 <allocproc+0x90>
  p->pid = allocpid();
    800011c0:	00000097          	auipc	ra,0x0
    800011c4:	e34080e7          	jalr	-460(ra) # 80000ff4 <allocpid>
    800011c8:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011ca:	4785                	li	a5,1
    800011cc:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011ce:	fffff097          	auipc	ra,0xfffff
    800011d2:	f9e080e7          	jalr	-98(ra) # 8000016c <kalloc>
    800011d6:	892a                	mv	s2,a0
    800011d8:	f0a8                	sd	a0,96(s1)
    800011da:	c131                	beqz	a0,8000121e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011dc:	8526                	mv	a0,s1
    800011de:	00000097          	auipc	ra,0x0
    800011e2:	e5c080e7          	jalr	-420(ra) # 8000103a <proc_pagetable>
    800011e6:	892a                	mv	s2,a0
    800011e8:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800011ea:	c531                	beqz	a0,80001236 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011ec:	07000613          	li	a2,112
    800011f0:	4581                	li	a1,0
    800011f2:	06848513          	addi	a0,s1,104
    800011f6:	fffff097          	auipc	ra,0xfffff
    800011fa:	06e080e7          	jalr	110(ra) # 80000264 <memset>
  p->context.ra = (uint64)forkret;
    800011fe:	00000797          	auipc	a5,0x0
    80001202:	db078793          	addi	a5,a5,-592 # 80000fae <forkret>
    80001206:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001208:	64bc                	ld	a5,72(s1)
    8000120a:	6705                	lui	a4,0x1
    8000120c:	97ba                	add	a5,a5,a4
    8000120e:	f8bc                	sd	a5,112(s1)
}
    80001210:	8526                	mv	a0,s1
    80001212:	60e2                	ld	ra,24(sp)
    80001214:	6442                	ld	s0,16(sp)
    80001216:	64a2                	ld	s1,8(sp)
    80001218:	6902                	ld	s2,0(sp)
    8000121a:	6105                	addi	sp,sp,32
    8000121c:	8082                	ret
    freeproc(p);
    8000121e:	8526                	mv	a0,s1
    80001220:	00000097          	auipc	ra,0x0
    80001224:	f08080e7          	jalr	-248(ra) # 80001128 <freeproc>
    release(&p->lock);
    80001228:	8526                	mv	a0,s1
    8000122a:	00005097          	auipc	ra,0x5
    8000122e:	670080e7          	jalr	1648(ra) # 8000689a <release>
    return 0;
    80001232:	84ca                	mv	s1,s2
    80001234:	bff1                	j	80001210 <allocproc+0x90>
    freeproc(p);
    80001236:	8526                	mv	a0,s1
    80001238:	00000097          	auipc	ra,0x0
    8000123c:	ef0080e7          	jalr	-272(ra) # 80001128 <freeproc>
    release(&p->lock);
    80001240:	8526                	mv	a0,s1
    80001242:	00005097          	auipc	ra,0x5
    80001246:	658080e7          	jalr	1624(ra) # 8000689a <release>
    return 0;
    8000124a:	84ca                	mv	s1,s2
    8000124c:	b7d1                	j	80001210 <allocproc+0x90>

000000008000124e <userinit>:
{
    8000124e:	1101                	addi	sp,sp,-32
    80001250:	ec06                	sd	ra,24(sp)
    80001252:	e822                	sd	s0,16(sp)
    80001254:	e426                	sd	s1,8(sp)
    80001256:	1000                	addi	s0,sp,32
  p = allocproc();
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	f28080e7          	jalr	-216(ra) # 80001180 <allocproc>
    80001260:	84aa                	mv	s1,a0
  initproc = p;
    80001262:	00008797          	auipc	a5,0x8
    80001266:	daa7b723          	sd	a0,-594(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000126a:	03400613          	li	a2,52
    8000126e:	00007597          	auipc	a1,0x7
    80001272:	67258593          	addi	a1,a1,1650 # 800088e0 <initcode>
    80001276:	6d28                	ld	a0,88(a0)
    80001278:	fffff097          	auipc	ra,0xfffff
    8000127c:	684080e7          	jalr	1668(ra) # 800008fc <uvminit>
  p->sz = PGSIZE;
    80001280:	6785                	lui	a5,0x1
    80001282:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001284:	70b8                	ld	a4,96(s1)
    80001286:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000128a:	70b8                	ld	a4,96(s1)
    8000128c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000128e:	4641                	li	a2,16
    80001290:	00007597          	auipc	a1,0x7
    80001294:	ef058593          	addi	a1,a1,-272 # 80008180 <etext+0x180>
    80001298:	16048513          	addi	a0,s1,352
    8000129c:	fffff097          	auipc	ra,0xfffff
    800012a0:	10a080e7          	jalr	266(ra) # 800003a6 <safestrcpy>
  p->cwd = namei("/");
    800012a4:	00007517          	auipc	a0,0x7
    800012a8:	eec50513          	addi	a0,a0,-276 # 80008190 <etext+0x190>
    800012ac:	00002097          	auipc	ra,0x2
    800012b0:	29a080e7          	jalr	666(ra) # 80003546 <namei>
    800012b4:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012b8:	478d                	li	a5,3
    800012ba:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    800012bc:	8526                	mv	a0,s1
    800012be:	00005097          	auipc	ra,0x5
    800012c2:	5dc080e7          	jalr	1500(ra) # 8000689a <release>
}
    800012c6:	60e2                	ld	ra,24(sp)
    800012c8:	6442                	ld	s0,16(sp)
    800012ca:	64a2                	ld	s1,8(sp)
    800012cc:	6105                	addi	sp,sp,32
    800012ce:	8082                	ret

00000000800012d0 <growproc>:
{
    800012d0:	1101                	addi	sp,sp,-32
    800012d2:	ec06                	sd	ra,24(sp)
    800012d4:	e822                	sd	s0,16(sp)
    800012d6:	e426                	sd	s1,8(sp)
    800012d8:	e04a                	sd	s2,0(sp)
    800012da:	1000                	addi	s0,sp,32
    800012dc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800012de:	00000097          	auipc	ra,0x0
    800012e2:	c98080e7          	jalr	-872(ra) # 80000f76 <myproc>
    800012e6:	892a                	mv	s2,a0
  sz = p->sz;
    800012e8:	692c                	ld	a1,80(a0)
    800012ea:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800012ee:	00904f63          	bgtz	s1,8000130c <growproc+0x3c>
  } else if(n < 0){
    800012f2:	0204cd63          	bltz	s1,8000132c <growproc+0x5c>
  p->sz = sz;
    800012f6:	1782                	slli	a5,a5,0x20
    800012f8:	9381                	srli	a5,a5,0x20
    800012fa:	04f93823          	sd	a5,80(s2)
  return 0;
    800012fe:	4501                	li	a0,0
}
    80001300:	60e2                	ld	ra,24(sp)
    80001302:	6442                	ld	s0,16(sp)
    80001304:	64a2                	ld	s1,8(sp)
    80001306:	6902                	ld	s2,0(sp)
    80001308:	6105                	addi	sp,sp,32
    8000130a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000130c:	00f4863b          	addw	a2,s1,a5
    80001310:	1602                	slli	a2,a2,0x20
    80001312:	9201                	srli	a2,a2,0x20
    80001314:	1582                	slli	a1,a1,0x20
    80001316:	9181                	srli	a1,a1,0x20
    80001318:	6d28                	ld	a0,88(a0)
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	69c080e7          	jalr	1692(ra) # 800009b6 <uvmalloc>
    80001322:	0005079b          	sext.w	a5,a0
    80001326:	fbe1                	bnez	a5,800012f6 <growproc+0x26>
      return -1;
    80001328:	557d                	li	a0,-1
    8000132a:	bfd9                	j	80001300 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000132c:	00f4863b          	addw	a2,s1,a5
    80001330:	1602                	slli	a2,a2,0x20
    80001332:	9201                	srli	a2,a2,0x20
    80001334:	1582                	slli	a1,a1,0x20
    80001336:	9181                	srli	a1,a1,0x20
    80001338:	6d28                	ld	a0,88(a0)
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	634080e7          	jalr	1588(ra) # 8000096e <uvmdealloc>
    80001342:	0005079b          	sext.w	a5,a0
    80001346:	bf45                	j	800012f6 <growproc+0x26>

0000000080001348 <fork>:
{
    80001348:	7139                	addi	sp,sp,-64
    8000134a:	fc06                	sd	ra,56(sp)
    8000134c:	f822                	sd	s0,48(sp)
    8000134e:	f04a                	sd	s2,32(sp)
    80001350:	e456                	sd	s5,8(sp)
    80001352:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001354:	00000097          	auipc	ra,0x0
    80001358:	c22080e7          	jalr	-990(ra) # 80000f76 <myproc>
    8000135c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000135e:	00000097          	auipc	ra,0x0
    80001362:	e22080e7          	jalr	-478(ra) # 80001180 <allocproc>
    80001366:	12050063          	beqz	a0,80001486 <fork+0x13e>
    8000136a:	e852                	sd	s4,16(sp)
    8000136c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000136e:	050ab603          	ld	a2,80(s5)
    80001372:	6d2c                	ld	a1,88(a0)
    80001374:	058ab503          	ld	a0,88(s5)
    80001378:	fffff097          	auipc	ra,0xfffff
    8000137c:	796080e7          	jalr	1942(ra) # 80000b0e <uvmcopy>
    80001380:	04054a63          	bltz	a0,800013d4 <fork+0x8c>
    80001384:	f426                	sd	s1,40(sp)
    80001386:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001388:	050ab783          	ld	a5,80(s5)
    8000138c:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001390:	060ab683          	ld	a3,96(s5)
    80001394:	87b6                	mv	a5,a3
    80001396:	060a3703          	ld	a4,96(s4)
    8000139a:	12068693          	addi	a3,a3,288
    8000139e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013a2:	6788                	ld	a0,8(a5)
    800013a4:	6b8c                	ld	a1,16(a5)
    800013a6:	6f90                	ld	a2,24(a5)
    800013a8:	01073023          	sd	a6,0(a4)
    800013ac:	e708                	sd	a0,8(a4)
    800013ae:	eb0c                	sd	a1,16(a4)
    800013b0:	ef10                	sd	a2,24(a4)
    800013b2:	02078793          	addi	a5,a5,32
    800013b6:	02070713          	addi	a4,a4,32
    800013ba:	fed792e3          	bne	a5,a3,8000139e <fork+0x56>
  np->trapframe->a0 = 0;
    800013be:	060a3783          	ld	a5,96(s4)
    800013c2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013c6:	0d8a8493          	addi	s1,s5,216
    800013ca:	0d8a0913          	addi	s2,s4,216
    800013ce:	158a8993          	addi	s3,s5,344
    800013d2:	a015                	j	800013f6 <fork+0xae>
    freeproc(np);
    800013d4:	8552                	mv	a0,s4
    800013d6:	00000097          	auipc	ra,0x0
    800013da:	d52080e7          	jalr	-686(ra) # 80001128 <freeproc>
    release(&np->lock);
    800013de:	8552                	mv	a0,s4
    800013e0:	00005097          	auipc	ra,0x5
    800013e4:	4ba080e7          	jalr	1210(ra) # 8000689a <release>
    return -1;
    800013e8:	597d                	li	s2,-1
    800013ea:	6a42                	ld	s4,16(sp)
    800013ec:	a071                	j	80001478 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800013ee:	04a1                	addi	s1,s1,8
    800013f0:	0921                	addi	s2,s2,8
    800013f2:	01348b63          	beq	s1,s3,80001408 <fork+0xc0>
    if(p->ofile[i])
    800013f6:	6088                	ld	a0,0(s1)
    800013f8:	d97d                	beqz	a0,800013ee <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800013fa:	00002097          	auipc	ra,0x2
    800013fe:	7c4080e7          	jalr	1988(ra) # 80003bbe <filedup>
    80001402:	00a93023          	sd	a0,0(s2)
    80001406:	b7e5                	j	800013ee <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001408:	158ab503          	ld	a0,344(s5)
    8000140c:	00002097          	auipc	ra,0x2
    80001410:	92a080e7          	jalr	-1750(ra) # 80002d36 <idup>
    80001414:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001418:	4641                	li	a2,16
    8000141a:	160a8593          	addi	a1,s5,352
    8000141e:	160a0513          	addi	a0,s4,352
    80001422:	fffff097          	auipc	ra,0xfffff
    80001426:	f84080e7          	jalr	-124(ra) # 800003a6 <safestrcpy>
  pid = np->pid;
    8000142a:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    8000142e:	8552                	mv	a0,s4
    80001430:	00005097          	auipc	ra,0x5
    80001434:	46a080e7          	jalr	1130(ra) # 8000689a <release>
  acquire(&wait_lock);
    80001438:	00008497          	auipc	s1,0x8
    8000143c:	d5848493          	addi	s1,s1,-680 # 80009190 <wait_lock>
    80001440:	8526                	mv	a0,s1
    80001442:	00005097          	auipc	ra,0x5
    80001446:	388080e7          	jalr	904(ra) # 800067ca <acquire>
  np->parent = p;
    8000144a:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    8000144e:	8526                	mv	a0,s1
    80001450:	00005097          	auipc	ra,0x5
    80001454:	44a080e7          	jalr	1098(ra) # 8000689a <release>
  acquire(&np->lock);
    80001458:	8552                	mv	a0,s4
    8000145a:	00005097          	auipc	ra,0x5
    8000145e:	370080e7          	jalr	880(ra) # 800067ca <acquire>
  np->state = RUNNABLE;
    80001462:	478d                	li	a5,3
    80001464:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001468:	8552                	mv	a0,s4
    8000146a:	00005097          	auipc	ra,0x5
    8000146e:	430080e7          	jalr	1072(ra) # 8000689a <release>
  return pid;
    80001472:	74a2                	ld	s1,40(sp)
    80001474:	69e2                	ld	s3,24(sp)
    80001476:	6a42                	ld	s4,16(sp)
}
    80001478:	854a                	mv	a0,s2
    8000147a:	70e2                	ld	ra,56(sp)
    8000147c:	7442                	ld	s0,48(sp)
    8000147e:	7902                	ld	s2,32(sp)
    80001480:	6aa2                	ld	s5,8(sp)
    80001482:	6121                	addi	sp,sp,64
    80001484:	8082                	ret
    return -1;
    80001486:	597d                	li	s2,-1
    80001488:	bfc5                	j	80001478 <fork+0x130>

000000008000148a <scheduler>:
{
    8000148a:	7139                	addi	sp,sp,-64
    8000148c:	fc06                	sd	ra,56(sp)
    8000148e:	f822                	sd	s0,48(sp)
    80001490:	f426                	sd	s1,40(sp)
    80001492:	f04a                	sd	s2,32(sp)
    80001494:	ec4e                	sd	s3,24(sp)
    80001496:	e852                	sd	s4,16(sp)
    80001498:	e456                	sd	s5,8(sp)
    8000149a:	e05a                	sd	s6,0(sp)
    8000149c:	0080                	addi	s0,sp,64
    8000149e:	8792                	mv	a5,tp
  int id = r_tp();
    800014a0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014a2:	00779a93          	slli	s5,a5,0x7
    800014a6:	00008717          	auipc	a4,0x8
    800014aa:	cca70713          	addi	a4,a4,-822 # 80009170 <pid_lock>
    800014ae:	9756                	add	a4,a4,s5
    800014b0:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    800014b4:	00008717          	auipc	a4,0x8
    800014b8:	d0470713          	addi	a4,a4,-764 # 800091b8 <cpus+0x8>
    800014bc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014be:	498d                	li	s3,3
        p->state = RUNNING;
    800014c0:	4b11                	li	s6,4
        c->proc = p;
    800014c2:	079e                	slli	a5,a5,0x7
    800014c4:	00008a17          	auipc	s4,0x8
    800014c8:	caca0a13          	addi	s4,s4,-852 # 80009170 <pid_lock>
    800014cc:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014ce:	0000e917          	auipc	s2,0xe
    800014d2:	ce290913          	addi	s2,s2,-798 # 8000f1b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014d6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014da:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014de:	10079073          	csrw	sstatus,a5
    800014e2:	00008497          	auipc	s1,0x8
    800014e6:	0ce48493          	addi	s1,s1,206 # 800095b0 <proc>
    800014ea:	a811                	j	800014fe <scheduler+0x74>
      release(&p->lock);
    800014ec:	8526                	mv	a0,s1
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	3ac080e7          	jalr	940(ra) # 8000689a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014f6:	17048493          	addi	s1,s1,368
    800014fa:	fd248ee3          	beq	s1,s2,800014d6 <scheduler+0x4c>
      acquire(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	00005097          	auipc	ra,0x5
    80001504:	2ca080e7          	jalr	714(ra) # 800067ca <acquire>
      if(p->state == RUNNABLE) {
    80001508:	509c                	lw	a5,32(s1)
    8000150a:	ff3791e3          	bne	a5,s3,800014ec <scheduler+0x62>
        p->state = RUNNING;
    8000150e:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001512:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    80001516:	06848593          	addi	a1,s1,104
    8000151a:	8556                	mv	a0,s5
    8000151c:	00000097          	auipc	ra,0x0
    80001520:	620080e7          	jalr	1568(ra) # 80001b3c <swtch>
        c->proc = 0;
    80001524:	040a3023          	sd	zero,64(s4)
    80001528:	b7d1                	j	800014ec <scheduler+0x62>

000000008000152a <sched>:
{
    8000152a:	7179                	addi	sp,sp,-48
    8000152c:	f406                	sd	ra,40(sp)
    8000152e:	f022                	sd	s0,32(sp)
    80001530:	ec26                	sd	s1,24(sp)
    80001532:	e84a                	sd	s2,16(sp)
    80001534:	e44e                	sd	s3,8(sp)
    80001536:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	a3e080e7          	jalr	-1474(ra) # 80000f76 <myproc>
    80001540:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001542:	00005097          	auipc	ra,0x5
    80001546:	20e080e7          	jalr	526(ra) # 80006750 <holding>
    8000154a:	c93d                	beqz	a0,800015c0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000154c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000154e:	2781                	sext.w	a5,a5
    80001550:	079e                	slli	a5,a5,0x7
    80001552:	00008717          	auipc	a4,0x8
    80001556:	c1e70713          	addi	a4,a4,-994 # 80009170 <pid_lock>
    8000155a:	97ba                	add	a5,a5,a4
    8000155c:	0b87a703          	lw	a4,184(a5)
    80001560:	4785                	li	a5,1
    80001562:	06f71763          	bne	a4,a5,800015d0 <sched+0xa6>
  if(p->state == RUNNING)
    80001566:	5098                	lw	a4,32(s1)
    80001568:	4791                	li	a5,4
    8000156a:	06f70b63          	beq	a4,a5,800015e0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000156e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001572:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001574:	efb5                	bnez	a5,800015f0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001576:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001578:	00008917          	auipc	s2,0x8
    8000157c:	bf890913          	addi	s2,s2,-1032 # 80009170 <pid_lock>
    80001580:	2781                	sext.w	a5,a5
    80001582:	079e                	slli	a5,a5,0x7
    80001584:	97ca                	add	a5,a5,s2
    80001586:	0bc7a983          	lw	s3,188(a5)
    8000158a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000158c:	2781                	sext.w	a5,a5
    8000158e:	079e                	slli	a5,a5,0x7
    80001590:	00008597          	auipc	a1,0x8
    80001594:	c2858593          	addi	a1,a1,-984 # 800091b8 <cpus+0x8>
    80001598:	95be                	add	a1,a1,a5
    8000159a:	06848513          	addi	a0,s1,104
    8000159e:	00000097          	auipc	ra,0x0
    800015a2:	59e080e7          	jalr	1438(ra) # 80001b3c <swtch>
    800015a6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015a8:	2781                	sext.w	a5,a5
    800015aa:	079e                	slli	a5,a5,0x7
    800015ac:	993e                	add	s2,s2,a5
    800015ae:	0b392e23          	sw	s3,188(s2)
}
    800015b2:	70a2                	ld	ra,40(sp)
    800015b4:	7402                	ld	s0,32(sp)
    800015b6:	64e2                	ld	s1,24(sp)
    800015b8:	6942                	ld	s2,16(sp)
    800015ba:	69a2                	ld	s3,8(sp)
    800015bc:	6145                	addi	sp,sp,48
    800015be:	8082                	ret
    panic("sched p->lock");
    800015c0:	00007517          	auipc	a0,0x7
    800015c4:	bd850513          	addi	a0,a0,-1064 # 80008198 <etext+0x198>
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	c9e080e7          	jalr	-866(ra) # 80006266 <panic>
    panic("sched locks");
    800015d0:	00007517          	auipc	a0,0x7
    800015d4:	bd850513          	addi	a0,a0,-1064 # 800081a8 <etext+0x1a8>
    800015d8:	00005097          	auipc	ra,0x5
    800015dc:	c8e080e7          	jalr	-882(ra) # 80006266 <panic>
    panic("sched running");
    800015e0:	00007517          	auipc	a0,0x7
    800015e4:	bd850513          	addi	a0,a0,-1064 # 800081b8 <etext+0x1b8>
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	c7e080e7          	jalr	-898(ra) # 80006266 <panic>
    panic("sched interruptible");
    800015f0:	00007517          	auipc	a0,0x7
    800015f4:	bd850513          	addi	a0,a0,-1064 # 800081c8 <etext+0x1c8>
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	c6e080e7          	jalr	-914(ra) # 80006266 <panic>

0000000080001600 <yield>:
{
    80001600:	1101                	addi	sp,sp,-32
    80001602:	ec06                	sd	ra,24(sp)
    80001604:	e822                	sd	s0,16(sp)
    80001606:	e426                	sd	s1,8(sp)
    80001608:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000160a:	00000097          	auipc	ra,0x0
    8000160e:	96c080e7          	jalr	-1684(ra) # 80000f76 <myproc>
    80001612:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001614:	00005097          	auipc	ra,0x5
    80001618:	1b6080e7          	jalr	438(ra) # 800067ca <acquire>
  p->state = RUNNABLE;
    8000161c:	478d                	li	a5,3
    8000161e:	d09c                	sw	a5,32(s1)
  sched();
    80001620:	00000097          	auipc	ra,0x0
    80001624:	f0a080e7          	jalr	-246(ra) # 8000152a <sched>
  release(&p->lock);
    80001628:	8526                	mv	a0,s1
    8000162a:	00005097          	auipc	ra,0x5
    8000162e:	270080e7          	jalr	624(ra) # 8000689a <release>
}
    80001632:	60e2                	ld	ra,24(sp)
    80001634:	6442                	ld	s0,16(sp)
    80001636:	64a2                	ld	s1,8(sp)
    80001638:	6105                	addi	sp,sp,32
    8000163a:	8082                	ret

000000008000163c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000163c:	7179                	addi	sp,sp,-48
    8000163e:	f406                	sd	ra,40(sp)
    80001640:	f022                	sd	s0,32(sp)
    80001642:	ec26                	sd	s1,24(sp)
    80001644:	e84a                	sd	s2,16(sp)
    80001646:	e44e                	sd	s3,8(sp)
    80001648:	1800                	addi	s0,sp,48
    8000164a:	89aa                	mv	s3,a0
    8000164c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000164e:	00000097          	auipc	ra,0x0
    80001652:	928080e7          	jalr	-1752(ra) # 80000f76 <myproc>
    80001656:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001658:	00005097          	auipc	ra,0x5
    8000165c:	172080e7          	jalr	370(ra) # 800067ca <acquire>
  release(lk);
    80001660:	854a                	mv	a0,s2
    80001662:	00005097          	auipc	ra,0x5
    80001666:	238080e7          	jalr	568(ra) # 8000689a <release>

  // Go to sleep.
  p->chan = chan;
    8000166a:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000166e:	4789                	li	a5,2
    80001670:	d09c                	sw	a5,32(s1)

  sched();
    80001672:	00000097          	auipc	ra,0x0
    80001676:	eb8080e7          	jalr	-328(ra) # 8000152a <sched>

  // Tidy up.
  p->chan = 0;
    8000167a:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000167e:	8526                	mv	a0,s1
    80001680:	00005097          	auipc	ra,0x5
    80001684:	21a080e7          	jalr	538(ra) # 8000689a <release>
  acquire(lk);
    80001688:	854a                	mv	a0,s2
    8000168a:	00005097          	auipc	ra,0x5
    8000168e:	140080e7          	jalr	320(ra) # 800067ca <acquire>
}
    80001692:	70a2                	ld	ra,40(sp)
    80001694:	7402                	ld	s0,32(sp)
    80001696:	64e2                	ld	s1,24(sp)
    80001698:	6942                	ld	s2,16(sp)
    8000169a:	69a2                	ld	s3,8(sp)
    8000169c:	6145                	addi	sp,sp,48
    8000169e:	8082                	ret

00000000800016a0 <wait>:
{
    800016a0:	715d                	addi	sp,sp,-80
    800016a2:	e486                	sd	ra,72(sp)
    800016a4:	e0a2                	sd	s0,64(sp)
    800016a6:	fc26                	sd	s1,56(sp)
    800016a8:	f84a                	sd	s2,48(sp)
    800016aa:	f44e                	sd	s3,40(sp)
    800016ac:	f052                	sd	s4,32(sp)
    800016ae:	ec56                	sd	s5,24(sp)
    800016b0:	e85a                	sd	s6,16(sp)
    800016b2:	e45e                	sd	s7,8(sp)
    800016b4:	e062                	sd	s8,0(sp)
    800016b6:	0880                	addi	s0,sp,80
    800016b8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	8bc080e7          	jalr	-1860(ra) # 80000f76 <myproc>
    800016c2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016c4:	00008517          	auipc	a0,0x8
    800016c8:	acc50513          	addi	a0,a0,-1332 # 80009190 <wait_lock>
    800016cc:	00005097          	auipc	ra,0x5
    800016d0:	0fe080e7          	jalr	254(ra) # 800067ca <acquire>
    havekids = 0;
    800016d4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016d6:	4a15                	li	s4,5
        havekids = 1;
    800016d8:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800016da:	0000e997          	auipc	s3,0xe
    800016de:	ad698993          	addi	s3,s3,-1322 # 8000f1b0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016e2:	00008c17          	auipc	s8,0x8
    800016e6:	aaec0c13          	addi	s8,s8,-1362 # 80009190 <wait_lock>
    800016ea:	a87d                	j	800017a8 <wait+0x108>
          pid = np->pid;
    800016ec:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800016f0:	000b0e63          	beqz	s6,8000170c <wait+0x6c>
    800016f4:	4691                	li	a3,4
    800016f6:	03448613          	addi	a2,s1,52
    800016fa:	85da                	mv	a1,s6
    800016fc:	05893503          	ld	a0,88(s2)
    80001700:	fffff097          	auipc	ra,0xfffff
    80001704:	512080e7          	jalr	1298(ra) # 80000c12 <copyout>
    80001708:	04054163          	bltz	a0,8000174a <wait+0xaa>
          freeproc(np);
    8000170c:	8526                	mv	a0,s1
    8000170e:	00000097          	auipc	ra,0x0
    80001712:	a1a080e7          	jalr	-1510(ra) # 80001128 <freeproc>
          release(&np->lock);
    80001716:	8526                	mv	a0,s1
    80001718:	00005097          	auipc	ra,0x5
    8000171c:	182080e7          	jalr	386(ra) # 8000689a <release>
          release(&wait_lock);
    80001720:	00008517          	auipc	a0,0x8
    80001724:	a7050513          	addi	a0,a0,-1424 # 80009190 <wait_lock>
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	172080e7          	jalr	370(ra) # 8000689a <release>
}
    80001730:	854e                	mv	a0,s3
    80001732:	60a6                	ld	ra,72(sp)
    80001734:	6406                	ld	s0,64(sp)
    80001736:	74e2                	ld	s1,56(sp)
    80001738:	7942                	ld	s2,48(sp)
    8000173a:	79a2                	ld	s3,40(sp)
    8000173c:	7a02                	ld	s4,32(sp)
    8000173e:	6ae2                	ld	s5,24(sp)
    80001740:	6b42                	ld	s6,16(sp)
    80001742:	6ba2                	ld	s7,8(sp)
    80001744:	6c02                	ld	s8,0(sp)
    80001746:	6161                	addi	sp,sp,80
    80001748:	8082                	ret
            release(&np->lock);
    8000174a:	8526                	mv	a0,s1
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	14e080e7          	jalr	334(ra) # 8000689a <release>
            release(&wait_lock);
    80001754:	00008517          	auipc	a0,0x8
    80001758:	a3c50513          	addi	a0,a0,-1476 # 80009190 <wait_lock>
    8000175c:	00005097          	auipc	ra,0x5
    80001760:	13e080e7          	jalr	318(ra) # 8000689a <release>
            return -1;
    80001764:	59fd                	li	s3,-1
    80001766:	b7e9                	j	80001730 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    80001768:	17048493          	addi	s1,s1,368
    8000176c:	03348463          	beq	s1,s3,80001794 <wait+0xf4>
      if(np->parent == p){
    80001770:	60bc                	ld	a5,64(s1)
    80001772:	ff279be3          	bne	a5,s2,80001768 <wait+0xc8>
        acquire(&np->lock);
    80001776:	8526                	mv	a0,s1
    80001778:	00005097          	auipc	ra,0x5
    8000177c:	052080e7          	jalr	82(ra) # 800067ca <acquire>
        if(np->state == ZOMBIE){
    80001780:	509c                	lw	a5,32(s1)
    80001782:	f74785e3          	beq	a5,s4,800016ec <wait+0x4c>
        release(&np->lock);
    80001786:	8526                	mv	a0,s1
    80001788:	00005097          	auipc	ra,0x5
    8000178c:	112080e7          	jalr	274(ra) # 8000689a <release>
        havekids = 1;
    80001790:	8756                	mv	a4,s5
    80001792:	bfd9                	j	80001768 <wait+0xc8>
    if(!havekids || p->killed){
    80001794:	c305                	beqz	a4,800017b4 <wait+0x114>
    80001796:	03092783          	lw	a5,48(s2)
    8000179a:	ef89                	bnez	a5,800017b4 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000179c:	85e2                	mv	a1,s8
    8000179e:	854a                	mv	a0,s2
    800017a0:	00000097          	auipc	ra,0x0
    800017a4:	e9c080e7          	jalr	-356(ra) # 8000163c <sleep>
    havekids = 0;
    800017a8:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800017aa:	00008497          	auipc	s1,0x8
    800017ae:	e0648493          	addi	s1,s1,-506 # 800095b0 <proc>
    800017b2:	bf7d                	j	80001770 <wait+0xd0>
      release(&wait_lock);
    800017b4:	00008517          	auipc	a0,0x8
    800017b8:	9dc50513          	addi	a0,a0,-1572 # 80009190 <wait_lock>
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	0de080e7          	jalr	222(ra) # 8000689a <release>
      return -1;
    800017c4:	59fd                	li	s3,-1
    800017c6:	b7ad                	j	80001730 <wait+0x90>

00000000800017c8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017c8:	7139                	addi	sp,sp,-64
    800017ca:	fc06                	sd	ra,56(sp)
    800017cc:	f822                	sd	s0,48(sp)
    800017ce:	f426                	sd	s1,40(sp)
    800017d0:	f04a                	sd	s2,32(sp)
    800017d2:	ec4e                	sd	s3,24(sp)
    800017d4:	e852                	sd	s4,16(sp)
    800017d6:	e456                	sd	s5,8(sp)
    800017d8:	0080                	addi	s0,sp,64
    800017da:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017dc:	00008497          	auipc	s1,0x8
    800017e0:	dd448493          	addi	s1,s1,-556 # 800095b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017e4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017e6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e8:	0000e917          	auipc	s2,0xe
    800017ec:	9c890913          	addi	s2,s2,-1592 # 8000f1b0 <tickslock>
    800017f0:	a811                	j	80001804 <wakeup+0x3c>
      }
      release(&p->lock);
    800017f2:	8526                	mv	a0,s1
    800017f4:	00005097          	auipc	ra,0x5
    800017f8:	0a6080e7          	jalr	166(ra) # 8000689a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017fc:	17048493          	addi	s1,s1,368
    80001800:	03248663          	beq	s1,s2,8000182c <wakeup+0x64>
    if(p != myproc()){
    80001804:	fffff097          	auipc	ra,0xfffff
    80001808:	772080e7          	jalr	1906(ra) # 80000f76 <myproc>
    8000180c:	fea488e3          	beq	s1,a0,800017fc <wakeup+0x34>
      acquire(&p->lock);
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	fb8080e7          	jalr	-72(ra) # 800067ca <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000181a:	509c                	lw	a5,32(s1)
    8000181c:	fd379be3          	bne	a5,s3,800017f2 <wakeup+0x2a>
    80001820:	749c                	ld	a5,40(s1)
    80001822:	fd4798e3          	bne	a5,s4,800017f2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001826:	0354a023          	sw	s5,32(s1)
    8000182a:	b7e1                	j	800017f2 <wakeup+0x2a>
    }
  }
}
    8000182c:	70e2                	ld	ra,56(sp)
    8000182e:	7442                	ld	s0,48(sp)
    80001830:	74a2                	ld	s1,40(sp)
    80001832:	7902                	ld	s2,32(sp)
    80001834:	69e2                	ld	s3,24(sp)
    80001836:	6a42                	ld	s4,16(sp)
    80001838:	6aa2                	ld	s5,8(sp)
    8000183a:	6121                	addi	sp,sp,64
    8000183c:	8082                	ret

000000008000183e <reparent>:
{
    8000183e:	7179                	addi	sp,sp,-48
    80001840:	f406                	sd	ra,40(sp)
    80001842:	f022                	sd	s0,32(sp)
    80001844:	ec26                	sd	s1,24(sp)
    80001846:	e84a                	sd	s2,16(sp)
    80001848:	e44e                	sd	s3,8(sp)
    8000184a:	e052                	sd	s4,0(sp)
    8000184c:	1800                	addi	s0,sp,48
    8000184e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001850:	00008497          	auipc	s1,0x8
    80001854:	d6048493          	addi	s1,s1,-672 # 800095b0 <proc>
      pp->parent = initproc;
    80001858:	00007a17          	auipc	s4,0x7
    8000185c:	7b8a0a13          	addi	s4,s4,1976 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001860:	0000e997          	auipc	s3,0xe
    80001864:	95098993          	addi	s3,s3,-1712 # 8000f1b0 <tickslock>
    80001868:	a029                	j	80001872 <reparent+0x34>
    8000186a:	17048493          	addi	s1,s1,368
    8000186e:	01348d63          	beq	s1,s3,80001888 <reparent+0x4a>
    if(pp->parent == p){
    80001872:	60bc                	ld	a5,64(s1)
    80001874:	ff279be3          	bne	a5,s2,8000186a <reparent+0x2c>
      pp->parent = initproc;
    80001878:	000a3503          	ld	a0,0(s4)
    8000187c:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000187e:	00000097          	auipc	ra,0x0
    80001882:	f4a080e7          	jalr	-182(ra) # 800017c8 <wakeup>
    80001886:	b7d5                	j	8000186a <reparent+0x2c>
}
    80001888:	70a2                	ld	ra,40(sp)
    8000188a:	7402                	ld	s0,32(sp)
    8000188c:	64e2                	ld	s1,24(sp)
    8000188e:	6942                	ld	s2,16(sp)
    80001890:	69a2                	ld	s3,8(sp)
    80001892:	6a02                	ld	s4,0(sp)
    80001894:	6145                	addi	sp,sp,48
    80001896:	8082                	ret

0000000080001898 <exit>:
{
    80001898:	7179                	addi	sp,sp,-48
    8000189a:	f406                	sd	ra,40(sp)
    8000189c:	f022                	sd	s0,32(sp)
    8000189e:	ec26                	sd	s1,24(sp)
    800018a0:	e84a                	sd	s2,16(sp)
    800018a2:	e44e                	sd	s3,8(sp)
    800018a4:	e052                	sd	s4,0(sp)
    800018a6:	1800                	addi	s0,sp,48
    800018a8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018aa:	fffff097          	auipc	ra,0xfffff
    800018ae:	6cc080e7          	jalr	1740(ra) # 80000f76 <myproc>
    800018b2:	89aa                	mv	s3,a0
  if(p == initproc)
    800018b4:	00007797          	auipc	a5,0x7
    800018b8:	75c7b783          	ld	a5,1884(a5) # 80009010 <initproc>
    800018bc:	0d850493          	addi	s1,a0,216
    800018c0:	15850913          	addi	s2,a0,344
    800018c4:	02a79363          	bne	a5,a0,800018ea <exit+0x52>
    panic("init exiting");
    800018c8:	00007517          	auipc	a0,0x7
    800018cc:	91850513          	addi	a0,a0,-1768 # 800081e0 <etext+0x1e0>
    800018d0:	00005097          	auipc	ra,0x5
    800018d4:	996080e7          	jalr	-1642(ra) # 80006266 <panic>
      fileclose(f);
    800018d8:	00002097          	auipc	ra,0x2
    800018dc:	338080e7          	jalr	824(ra) # 80003c10 <fileclose>
      p->ofile[fd] = 0;
    800018e0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018e4:	04a1                	addi	s1,s1,8
    800018e6:	01248563          	beq	s1,s2,800018f0 <exit+0x58>
    if(p->ofile[fd]){
    800018ea:	6088                	ld	a0,0(s1)
    800018ec:	f575                	bnez	a0,800018d8 <exit+0x40>
    800018ee:	bfdd                	j	800018e4 <exit+0x4c>
  begin_op();
    800018f0:	00002097          	auipc	ra,0x2
    800018f4:	e56080e7          	jalr	-426(ra) # 80003746 <begin_op>
  iput(p->cwd);
    800018f8:	1589b503          	ld	a0,344(s3)
    800018fc:	00001097          	auipc	ra,0x1
    80001900:	636080e7          	jalr	1590(ra) # 80002f32 <iput>
  end_op();
    80001904:	00002097          	auipc	ra,0x2
    80001908:	ebc080e7          	jalr	-324(ra) # 800037c0 <end_op>
  p->cwd = 0;
    8000190c:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001910:	00008497          	auipc	s1,0x8
    80001914:	88048493          	addi	s1,s1,-1920 # 80009190 <wait_lock>
    80001918:	8526                	mv	a0,s1
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	eb0080e7          	jalr	-336(ra) # 800067ca <acquire>
  reparent(p);
    80001922:	854e                	mv	a0,s3
    80001924:	00000097          	auipc	ra,0x0
    80001928:	f1a080e7          	jalr	-230(ra) # 8000183e <reparent>
  wakeup(p->parent);
    8000192c:	0409b503          	ld	a0,64(s3)
    80001930:	00000097          	auipc	ra,0x0
    80001934:	e98080e7          	jalr	-360(ra) # 800017c8 <wakeup>
  acquire(&p->lock);
    80001938:	854e                	mv	a0,s3
    8000193a:	00005097          	auipc	ra,0x5
    8000193e:	e90080e7          	jalr	-368(ra) # 800067ca <acquire>
  p->xstate = status;
    80001942:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001946:	4795                	li	a5,5
    80001948:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    8000194c:	8526                	mv	a0,s1
    8000194e:	00005097          	auipc	ra,0x5
    80001952:	f4c080e7          	jalr	-180(ra) # 8000689a <release>
  sched();
    80001956:	00000097          	auipc	ra,0x0
    8000195a:	bd4080e7          	jalr	-1068(ra) # 8000152a <sched>
  panic("zombie exit");
    8000195e:	00007517          	auipc	a0,0x7
    80001962:	89250513          	addi	a0,a0,-1902 # 800081f0 <etext+0x1f0>
    80001966:	00005097          	auipc	ra,0x5
    8000196a:	900080e7          	jalr	-1792(ra) # 80006266 <panic>

000000008000196e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000196e:	7179                	addi	sp,sp,-48
    80001970:	f406                	sd	ra,40(sp)
    80001972:	f022                	sd	s0,32(sp)
    80001974:	ec26                	sd	s1,24(sp)
    80001976:	e84a                	sd	s2,16(sp)
    80001978:	e44e                	sd	s3,8(sp)
    8000197a:	1800                	addi	s0,sp,48
    8000197c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000197e:	00008497          	auipc	s1,0x8
    80001982:	c3248493          	addi	s1,s1,-974 # 800095b0 <proc>
    80001986:	0000e997          	auipc	s3,0xe
    8000198a:	82a98993          	addi	s3,s3,-2006 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    8000198e:	8526                	mv	a0,s1
    80001990:	00005097          	auipc	ra,0x5
    80001994:	e3a080e7          	jalr	-454(ra) # 800067ca <acquire>
    if(p->pid == pid){
    80001998:	5c9c                	lw	a5,56(s1)
    8000199a:	01278d63          	beq	a5,s2,800019b4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000199e:	8526                	mv	a0,s1
    800019a0:	00005097          	auipc	ra,0x5
    800019a4:	efa080e7          	jalr	-262(ra) # 8000689a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019a8:	17048493          	addi	s1,s1,368
    800019ac:	ff3491e3          	bne	s1,s3,8000198e <kill+0x20>
  }
  return -1;
    800019b0:	557d                	li	a0,-1
    800019b2:	a829                	j	800019cc <kill+0x5e>
      p->killed = 1;
    800019b4:	4785                	li	a5,1
    800019b6:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800019b8:	5098                	lw	a4,32(s1)
    800019ba:	4789                	li	a5,2
    800019bc:	00f70f63          	beq	a4,a5,800019da <kill+0x6c>
      release(&p->lock);
    800019c0:	8526                	mv	a0,s1
    800019c2:	00005097          	auipc	ra,0x5
    800019c6:	ed8080e7          	jalr	-296(ra) # 8000689a <release>
      return 0;
    800019ca:	4501                	li	a0,0
}
    800019cc:	70a2                	ld	ra,40(sp)
    800019ce:	7402                	ld	s0,32(sp)
    800019d0:	64e2                	ld	s1,24(sp)
    800019d2:	6942                	ld	s2,16(sp)
    800019d4:	69a2                	ld	s3,8(sp)
    800019d6:	6145                	addi	sp,sp,48
    800019d8:	8082                	ret
        p->state = RUNNABLE;
    800019da:	478d                	li	a5,3
    800019dc:	d09c                	sw	a5,32(s1)
    800019de:	b7cd                	j	800019c0 <kill+0x52>

00000000800019e0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019e0:	7179                	addi	sp,sp,-48
    800019e2:	f406                	sd	ra,40(sp)
    800019e4:	f022                	sd	s0,32(sp)
    800019e6:	ec26                	sd	s1,24(sp)
    800019e8:	e84a                	sd	s2,16(sp)
    800019ea:	e44e                	sd	s3,8(sp)
    800019ec:	e052                	sd	s4,0(sp)
    800019ee:	1800                	addi	s0,sp,48
    800019f0:	84aa                	mv	s1,a0
    800019f2:	892e                	mv	s2,a1
    800019f4:	89b2                	mv	s3,a2
    800019f6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019f8:	fffff097          	auipc	ra,0xfffff
    800019fc:	57e080e7          	jalr	1406(ra) # 80000f76 <myproc>
  if(user_dst){
    80001a00:	c08d                	beqz	s1,80001a22 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a02:	86d2                	mv	a3,s4
    80001a04:	864e                	mv	a2,s3
    80001a06:	85ca                	mv	a1,s2
    80001a08:	6d28                	ld	a0,88(a0)
    80001a0a:	fffff097          	auipc	ra,0xfffff
    80001a0e:	208080e7          	jalr	520(ra) # 80000c12 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a12:	70a2                	ld	ra,40(sp)
    80001a14:	7402                	ld	s0,32(sp)
    80001a16:	64e2                	ld	s1,24(sp)
    80001a18:	6942                	ld	s2,16(sp)
    80001a1a:	69a2                	ld	s3,8(sp)
    80001a1c:	6a02                	ld	s4,0(sp)
    80001a1e:	6145                	addi	sp,sp,48
    80001a20:	8082                	ret
    memmove((char *)dst, src, len);
    80001a22:	000a061b          	sext.w	a2,s4
    80001a26:	85ce                	mv	a1,s3
    80001a28:	854a                	mv	a0,s2
    80001a2a:	fffff097          	auipc	ra,0xfffff
    80001a2e:	896080e7          	jalr	-1898(ra) # 800002c0 <memmove>
    return 0;
    80001a32:	8526                	mv	a0,s1
    80001a34:	bff9                	j	80001a12 <either_copyout+0x32>

0000000080001a36 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a36:	7179                	addi	sp,sp,-48
    80001a38:	f406                	sd	ra,40(sp)
    80001a3a:	f022                	sd	s0,32(sp)
    80001a3c:	ec26                	sd	s1,24(sp)
    80001a3e:	e84a                	sd	s2,16(sp)
    80001a40:	e44e                	sd	s3,8(sp)
    80001a42:	e052                	sd	s4,0(sp)
    80001a44:	1800                	addi	s0,sp,48
    80001a46:	892a                	mv	s2,a0
    80001a48:	84ae                	mv	s1,a1
    80001a4a:	89b2                	mv	s3,a2
    80001a4c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a4e:	fffff097          	auipc	ra,0xfffff
    80001a52:	528080e7          	jalr	1320(ra) # 80000f76 <myproc>
  if(user_src){
    80001a56:	c08d                	beqz	s1,80001a78 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a58:	86d2                	mv	a3,s4
    80001a5a:	864e                	mv	a2,s3
    80001a5c:	85ca                	mv	a1,s2
    80001a5e:	6d28                	ld	a0,88(a0)
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	23e080e7          	jalr	574(ra) # 80000c9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a68:	70a2                	ld	ra,40(sp)
    80001a6a:	7402                	ld	s0,32(sp)
    80001a6c:	64e2                	ld	s1,24(sp)
    80001a6e:	6942                	ld	s2,16(sp)
    80001a70:	69a2                	ld	s3,8(sp)
    80001a72:	6a02                	ld	s4,0(sp)
    80001a74:	6145                	addi	sp,sp,48
    80001a76:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a78:	000a061b          	sext.w	a2,s4
    80001a7c:	85ce                	mv	a1,s3
    80001a7e:	854a                	mv	a0,s2
    80001a80:	fffff097          	auipc	ra,0xfffff
    80001a84:	840080e7          	jalr	-1984(ra) # 800002c0 <memmove>
    return 0;
    80001a88:	8526                	mv	a0,s1
    80001a8a:	bff9                	j	80001a68 <either_copyin+0x32>

0000000080001a8c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a8c:	715d                	addi	sp,sp,-80
    80001a8e:	e486                	sd	ra,72(sp)
    80001a90:	e0a2                	sd	s0,64(sp)
    80001a92:	fc26                	sd	s1,56(sp)
    80001a94:	f84a                	sd	s2,48(sp)
    80001a96:	f44e                	sd	s3,40(sp)
    80001a98:	f052                	sd	s4,32(sp)
    80001a9a:	ec56                	sd	s5,24(sp)
    80001a9c:	e85a                	sd	s6,16(sp)
    80001a9e:	e45e                	sd	s7,8(sp)
    80001aa0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001aa2:	00006517          	auipc	a0,0x6
    80001aa6:	57650513          	addi	a0,a0,1398 # 80008018 <etext+0x18>
    80001aaa:	00005097          	auipc	ra,0x5
    80001aae:	806080e7          	jalr	-2042(ra) # 800062b0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ab2:	00008497          	auipc	s1,0x8
    80001ab6:	c5e48493          	addi	s1,s1,-930 # 80009710 <proc+0x160>
    80001aba:	0000e917          	auipc	s2,0xe
    80001abe:	85690913          	addi	s2,s2,-1962 # 8000f310 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ac2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ac4:	00006997          	auipc	s3,0x6
    80001ac8:	73c98993          	addi	s3,s3,1852 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001acc:	00006a97          	auipc	s5,0x6
    80001ad0:	73ca8a93          	addi	s5,s5,1852 # 80008208 <etext+0x208>
    printf("\n");
    80001ad4:	00006a17          	auipc	s4,0x6
    80001ad8:	544a0a13          	addi	s4,s4,1348 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001adc:	00007b97          	auipc	s7,0x7
    80001ae0:	cccb8b93          	addi	s7,s7,-820 # 800087a8 <states.0>
    80001ae4:	a00d                	j	80001b06 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ae6:	ed86a583          	lw	a1,-296(a3)
    80001aea:	8556                	mv	a0,s5
    80001aec:	00004097          	auipc	ra,0x4
    80001af0:	7c4080e7          	jalr	1988(ra) # 800062b0 <printf>
    printf("\n");
    80001af4:	8552                	mv	a0,s4
    80001af6:	00004097          	auipc	ra,0x4
    80001afa:	7ba080e7          	jalr	1978(ra) # 800062b0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001afe:	17048493          	addi	s1,s1,368
    80001b02:	03248263          	beq	s1,s2,80001b26 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b06:	86a6                	mv	a3,s1
    80001b08:	ec04a783          	lw	a5,-320(s1)
    80001b0c:	dbed                	beqz	a5,80001afe <procdump+0x72>
      state = "???";
    80001b0e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b10:	fcfb6be3          	bltu	s6,a5,80001ae6 <procdump+0x5a>
    80001b14:	02079713          	slli	a4,a5,0x20
    80001b18:	01d75793          	srli	a5,a4,0x1d
    80001b1c:	97de                	add	a5,a5,s7
    80001b1e:	6390                	ld	a2,0(a5)
    80001b20:	f279                	bnez	a2,80001ae6 <procdump+0x5a>
      state = "???";
    80001b22:	864e                	mv	a2,s3
    80001b24:	b7c9                	j	80001ae6 <procdump+0x5a>
  }
}
    80001b26:	60a6                	ld	ra,72(sp)
    80001b28:	6406                	ld	s0,64(sp)
    80001b2a:	74e2                	ld	s1,56(sp)
    80001b2c:	7942                	ld	s2,48(sp)
    80001b2e:	79a2                	ld	s3,40(sp)
    80001b30:	7a02                	ld	s4,32(sp)
    80001b32:	6ae2                	ld	s5,24(sp)
    80001b34:	6b42                	ld	s6,16(sp)
    80001b36:	6ba2                	ld	s7,8(sp)
    80001b38:	6161                	addi	sp,sp,80
    80001b3a:	8082                	ret

0000000080001b3c <swtch>:
    80001b3c:	00153023          	sd	ra,0(a0)
    80001b40:	00253423          	sd	sp,8(a0)
    80001b44:	e900                	sd	s0,16(a0)
    80001b46:	ed04                	sd	s1,24(a0)
    80001b48:	03253023          	sd	s2,32(a0)
    80001b4c:	03353423          	sd	s3,40(a0)
    80001b50:	03453823          	sd	s4,48(a0)
    80001b54:	03553c23          	sd	s5,56(a0)
    80001b58:	05653023          	sd	s6,64(a0)
    80001b5c:	05753423          	sd	s7,72(a0)
    80001b60:	05853823          	sd	s8,80(a0)
    80001b64:	05953c23          	sd	s9,88(a0)
    80001b68:	07a53023          	sd	s10,96(a0)
    80001b6c:	07b53423          	sd	s11,104(a0)
    80001b70:	0005b083          	ld	ra,0(a1)
    80001b74:	0085b103          	ld	sp,8(a1)
    80001b78:	6980                	ld	s0,16(a1)
    80001b7a:	6d84                	ld	s1,24(a1)
    80001b7c:	0205b903          	ld	s2,32(a1)
    80001b80:	0285b983          	ld	s3,40(a1)
    80001b84:	0305ba03          	ld	s4,48(a1)
    80001b88:	0385ba83          	ld	s5,56(a1)
    80001b8c:	0405bb03          	ld	s6,64(a1)
    80001b90:	0485bb83          	ld	s7,72(a1)
    80001b94:	0505bc03          	ld	s8,80(a1)
    80001b98:	0585bc83          	ld	s9,88(a1)
    80001b9c:	0605bd03          	ld	s10,96(a1)
    80001ba0:	0685bd83          	ld	s11,104(a1)
    80001ba4:	8082                	ret

0000000080001ba6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ba6:	1141                	addi	sp,sp,-16
    80001ba8:	e406                	sd	ra,8(sp)
    80001baa:	e022                	sd	s0,0(sp)
    80001bac:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bae:	00006597          	auipc	a1,0x6
    80001bb2:	69258593          	addi	a1,a1,1682 # 80008240 <etext+0x240>
    80001bb6:	0000d517          	auipc	a0,0xd
    80001bba:	5fa50513          	addi	a0,a0,1530 # 8000f1b0 <tickslock>
    80001bbe:	00005097          	auipc	ra,0x5
    80001bc2:	d88080e7          	jalr	-632(ra) # 80006946 <initlock>
}
    80001bc6:	60a2                	ld	ra,8(sp)
    80001bc8:	6402                	ld	s0,0(sp)
    80001bca:	0141                	addi	sp,sp,16
    80001bcc:	8082                	ret

0000000080001bce <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bce:	1141                	addi	sp,sp,-16
    80001bd0:	e422                	sd	s0,8(sp)
    80001bd2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bd4:	00003797          	auipc	a5,0x3
    80001bd8:	72c78793          	addi	a5,a5,1836 # 80005300 <kernelvec>
    80001bdc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001be0:	6422                	ld	s0,8(sp)
    80001be2:	0141                	addi	sp,sp,16
    80001be4:	8082                	ret

0000000080001be6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001be6:	1141                	addi	sp,sp,-16
    80001be8:	e406                	sd	ra,8(sp)
    80001bea:	e022                	sd	s0,0(sp)
    80001bec:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bee:	fffff097          	auipc	ra,0xfffff
    80001bf2:	388080e7          	jalr	904(ra) # 80000f76 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bf6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bfa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bfc:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c00:	00005697          	auipc	a3,0x5
    80001c04:	40068693          	addi	a3,a3,1024 # 80007000 <_trampoline>
    80001c08:	00005717          	auipc	a4,0x5
    80001c0c:	3f870713          	addi	a4,a4,1016 # 80007000 <_trampoline>
    80001c10:	8f15                	sub	a4,a4,a3
    80001c12:	040007b7          	lui	a5,0x4000
    80001c16:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c18:	07b2                	slli	a5,a5,0xc
    80001c1a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c1c:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c20:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c22:	18002673          	csrr	a2,satp
    80001c26:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c28:	7130                	ld	a2,96(a0)
    80001c2a:	6538                	ld	a4,72(a0)
    80001c2c:	6585                	lui	a1,0x1
    80001c2e:	972e                	add	a4,a4,a1
    80001c30:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c32:	7138                	ld	a4,96(a0)
    80001c34:	00000617          	auipc	a2,0x0
    80001c38:	14060613          	addi	a2,a2,320 # 80001d74 <usertrap>
    80001c3c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c3e:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c40:	8612                	mv	a2,tp
    80001c42:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c44:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c48:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c4c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c50:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c54:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c56:	6f18                	ld	a4,24(a4)
    80001c58:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c5c:	6d2c                	ld	a1,88(a0)
    80001c5e:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c60:	00005717          	auipc	a4,0x5
    80001c64:	43070713          	addi	a4,a4,1072 # 80007090 <userret>
    80001c68:	8f15                	sub	a4,a4,a3
    80001c6a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c6c:	577d                	li	a4,-1
    80001c6e:	177e                	slli	a4,a4,0x3f
    80001c70:	8dd9                	or	a1,a1,a4
    80001c72:	02000537          	lui	a0,0x2000
    80001c76:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c78:	0536                	slli	a0,a0,0xd
    80001c7a:	9782                	jalr	a5
}
    80001c7c:	60a2                	ld	ra,8(sp)
    80001c7e:	6402                	ld	s0,0(sp)
    80001c80:	0141                	addi	sp,sp,16
    80001c82:	8082                	ret

0000000080001c84 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c84:	1101                	addi	sp,sp,-32
    80001c86:	ec06                	sd	ra,24(sp)
    80001c88:	e822                	sd	s0,16(sp)
    80001c8a:	e426                	sd	s1,8(sp)
    80001c8c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c8e:	0000d497          	auipc	s1,0xd
    80001c92:	52248493          	addi	s1,s1,1314 # 8000f1b0 <tickslock>
    80001c96:	8526                	mv	a0,s1
    80001c98:	00005097          	auipc	ra,0x5
    80001c9c:	b32080e7          	jalr	-1230(ra) # 800067ca <acquire>
  ticks++;
    80001ca0:	00007517          	auipc	a0,0x7
    80001ca4:	37850513          	addi	a0,a0,888 # 80009018 <ticks>
    80001ca8:	411c                	lw	a5,0(a0)
    80001caa:	2785                	addiw	a5,a5,1
    80001cac:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cae:	00000097          	auipc	ra,0x0
    80001cb2:	b1a080e7          	jalr	-1254(ra) # 800017c8 <wakeup>
  release(&tickslock);
    80001cb6:	8526                	mv	a0,s1
    80001cb8:	00005097          	auipc	ra,0x5
    80001cbc:	be2080e7          	jalr	-1054(ra) # 8000689a <release>
}
    80001cc0:	60e2                	ld	ra,24(sp)
    80001cc2:	6442                	ld	s0,16(sp)
    80001cc4:	64a2                	ld	s1,8(sp)
    80001cc6:	6105                	addi	sp,sp,32
    80001cc8:	8082                	ret

0000000080001cca <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cca:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cce:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001cd0:	0a07d163          	bgez	a5,80001d72 <devintr+0xa8>
{
    80001cd4:	1101                	addi	sp,sp,-32
    80001cd6:	ec06                	sd	ra,24(sp)
    80001cd8:	e822                	sd	s0,16(sp)
    80001cda:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001cdc:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001ce0:	46a5                	li	a3,9
    80001ce2:	00d70c63          	beq	a4,a3,80001cfa <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001ce6:	577d                	li	a4,-1
    80001ce8:	177e                	slli	a4,a4,0x3f
    80001cea:	0705                	addi	a4,a4,1
    return 0;
    80001cec:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cee:	06e78163          	beq	a5,a4,80001d50 <devintr+0x86>
  }
}
    80001cf2:	60e2                	ld	ra,24(sp)
    80001cf4:	6442                	ld	s0,16(sp)
    80001cf6:	6105                	addi	sp,sp,32
    80001cf8:	8082                	ret
    80001cfa:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001cfc:	00003097          	auipc	ra,0x3
    80001d00:	710080e7          	jalr	1808(ra) # 8000540c <plic_claim>
    80001d04:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d06:	47a9                	li	a5,10
    80001d08:	00f50963          	beq	a0,a5,80001d1a <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001d0c:	4785                	li	a5,1
    80001d0e:	00f50b63          	beq	a0,a5,80001d24 <devintr+0x5a>
    return 1;
    80001d12:	4505                	li	a0,1
    } else if(irq){
    80001d14:	ec89                	bnez	s1,80001d2e <devintr+0x64>
    80001d16:	64a2                	ld	s1,8(sp)
    80001d18:	bfe9                	j	80001cf2 <devintr+0x28>
      uartintr();
    80001d1a:	00005097          	auipc	ra,0x5
    80001d1e:	9e6080e7          	jalr	-1562(ra) # 80006700 <uartintr>
    if(irq)
    80001d22:	a839                	j	80001d40 <devintr+0x76>
      virtio_disk_intr();
    80001d24:	00004097          	auipc	ra,0x4
    80001d28:	bbc080e7          	jalr	-1092(ra) # 800058e0 <virtio_disk_intr>
    if(irq)
    80001d2c:	a811                	j	80001d40 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d2e:	85a6                	mv	a1,s1
    80001d30:	00006517          	auipc	a0,0x6
    80001d34:	51850513          	addi	a0,a0,1304 # 80008248 <etext+0x248>
    80001d38:	00004097          	auipc	ra,0x4
    80001d3c:	578080e7          	jalr	1400(ra) # 800062b0 <printf>
      plic_complete(irq);
    80001d40:	8526                	mv	a0,s1
    80001d42:	00003097          	auipc	ra,0x3
    80001d46:	6ee080e7          	jalr	1774(ra) # 80005430 <plic_complete>
    return 1;
    80001d4a:	4505                	li	a0,1
    80001d4c:	64a2                	ld	s1,8(sp)
    80001d4e:	b755                	j	80001cf2 <devintr+0x28>
    if(cpuid() == 0){
    80001d50:	fffff097          	auipc	ra,0xfffff
    80001d54:	1fa080e7          	jalr	506(ra) # 80000f4a <cpuid>
    80001d58:	c901                	beqz	a0,80001d68 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d5a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d5e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d60:	14479073          	csrw	sip,a5
    return 2;
    80001d64:	4509                	li	a0,2
    80001d66:	b771                	j	80001cf2 <devintr+0x28>
      clockintr();
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	f1c080e7          	jalr	-228(ra) # 80001c84 <clockintr>
    80001d70:	b7ed                	j	80001d5a <devintr+0x90>
}
    80001d72:	8082                	ret

0000000080001d74 <usertrap>:
{
    80001d74:	1101                	addi	sp,sp,-32
    80001d76:	ec06                	sd	ra,24(sp)
    80001d78:	e822                	sd	s0,16(sp)
    80001d7a:	e426                	sd	s1,8(sp)
    80001d7c:	e04a                	sd	s2,0(sp)
    80001d7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d80:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d84:	1007f793          	andi	a5,a5,256
    80001d88:	e3ad                	bnez	a5,80001dea <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d8a:	00003797          	auipc	a5,0x3
    80001d8e:	57678793          	addi	a5,a5,1398 # 80005300 <kernelvec>
    80001d92:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	1e0080e7          	jalr	480(ra) # 80000f76 <myproc>
    80001d9e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001da0:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da2:	14102773          	csrr	a4,sepc
    80001da6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001dac:	47a1                	li	a5,8
    80001dae:	04f71c63          	bne	a4,a5,80001e06 <usertrap+0x92>
    if(p->killed)
    80001db2:	591c                	lw	a5,48(a0)
    80001db4:	e3b9                	bnez	a5,80001dfa <usertrap+0x86>
    p->trapframe->epc += 4;
    80001db6:	70b8                	ld	a4,96(s1)
    80001db8:	6f1c                	ld	a5,24(a4)
    80001dba:	0791                	addi	a5,a5,4
    80001dbc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dbe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dc2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc6:	10079073          	csrw	sstatus,a5
    syscall();
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	2e0080e7          	jalr	736(ra) # 800020aa <syscall>
  if(p->killed)
    80001dd2:	589c                	lw	a5,48(s1)
    80001dd4:	ebc1                	bnez	a5,80001e64 <usertrap+0xf0>
  usertrapret();
    80001dd6:	00000097          	auipc	ra,0x0
    80001dda:	e10080e7          	jalr	-496(ra) # 80001be6 <usertrapret>
}
    80001dde:	60e2                	ld	ra,24(sp)
    80001de0:	6442                	ld	s0,16(sp)
    80001de2:	64a2                	ld	s1,8(sp)
    80001de4:	6902                	ld	s2,0(sp)
    80001de6:	6105                	addi	sp,sp,32
    80001de8:	8082                	ret
    panic("usertrap: not from user mode");
    80001dea:	00006517          	auipc	a0,0x6
    80001dee:	47e50513          	addi	a0,a0,1150 # 80008268 <etext+0x268>
    80001df2:	00004097          	auipc	ra,0x4
    80001df6:	474080e7          	jalr	1140(ra) # 80006266 <panic>
      exit(-1);
    80001dfa:	557d                	li	a0,-1
    80001dfc:	00000097          	auipc	ra,0x0
    80001e00:	a9c080e7          	jalr	-1380(ra) # 80001898 <exit>
    80001e04:	bf4d                	j	80001db6 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e06:	00000097          	auipc	ra,0x0
    80001e0a:	ec4080e7          	jalr	-316(ra) # 80001cca <devintr>
    80001e0e:	892a                	mv	s2,a0
    80001e10:	c501                	beqz	a0,80001e18 <usertrap+0xa4>
  if(p->killed)
    80001e12:	589c                	lw	a5,48(s1)
    80001e14:	c3a1                	beqz	a5,80001e54 <usertrap+0xe0>
    80001e16:	a815                	j	80001e4a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e18:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e1c:	5c90                	lw	a2,56(s1)
    80001e1e:	00006517          	auipc	a0,0x6
    80001e22:	46a50513          	addi	a0,a0,1130 # 80008288 <etext+0x288>
    80001e26:	00004097          	auipc	ra,0x4
    80001e2a:	48a080e7          	jalr	1162(ra) # 800062b0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e32:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e36:	00006517          	auipc	a0,0x6
    80001e3a:	48250513          	addi	a0,a0,1154 # 800082b8 <etext+0x2b8>
    80001e3e:	00004097          	auipc	ra,0x4
    80001e42:	472080e7          	jalr	1138(ra) # 800062b0 <printf>
    p->killed = 1;
    80001e46:	4785                	li	a5,1
    80001e48:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001e4a:	557d                	li	a0,-1
    80001e4c:	00000097          	auipc	ra,0x0
    80001e50:	a4c080e7          	jalr	-1460(ra) # 80001898 <exit>
  if(which_dev == 2)
    80001e54:	4789                	li	a5,2
    80001e56:	f8f910e3          	bne	s2,a5,80001dd6 <usertrap+0x62>
    yield();
    80001e5a:	fffff097          	auipc	ra,0xfffff
    80001e5e:	7a6080e7          	jalr	1958(ra) # 80001600 <yield>
    80001e62:	bf95                	j	80001dd6 <usertrap+0x62>
  int which_dev = 0;
    80001e64:	4901                	li	s2,0
    80001e66:	b7d5                	j	80001e4a <usertrap+0xd6>

0000000080001e68 <kerneltrap>:
{
    80001e68:	7179                	addi	sp,sp,-48
    80001e6a:	f406                	sd	ra,40(sp)
    80001e6c:	f022                	sd	s0,32(sp)
    80001e6e:	ec26                	sd	s1,24(sp)
    80001e70:	e84a                	sd	s2,16(sp)
    80001e72:	e44e                	sd	s3,8(sp)
    80001e74:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e76:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e7a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e7e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e82:	1004f793          	andi	a5,s1,256
    80001e86:	cb85                	beqz	a5,80001eb6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e88:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e8c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e8e:	ef85                	bnez	a5,80001ec6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e90:	00000097          	auipc	ra,0x0
    80001e94:	e3a080e7          	jalr	-454(ra) # 80001cca <devintr>
    80001e98:	cd1d                	beqz	a0,80001ed6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e9a:	4789                	li	a5,2
    80001e9c:	06f50a63          	beq	a0,a5,80001f10 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ea0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ea4:	10049073          	csrw	sstatus,s1
}
    80001ea8:	70a2                	ld	ra,40(sp)
    80001eaa:	7402                	ld	s0,32(sp)
    80001eac:	64e2                	ld	s1,24(sp)
    80001eae:	6942                	ld	s2,16(sp)
    80001eb0:	69a2                	ld	s3,8(sp)
    80001eb2:	6145                	addi	sp,sp,48
    80001eb4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001eb6:	00006517          	auipc	a0,0x6
    80001eba:	42250513          	addi	a0,a0,1058 # 800082d8 <etext+0x2d8>
    80001ebe:	00004097          	auipc	ra,0x4
    80001ec2:	3a8080e7          	jalr	936(ra) # 80006266 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ec6:	00006517          	auipc	a0,0x6
    80001eca:	43a50513          	addi	a0,a0,1082 # 80008300 <etext+0x300>
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	398080e7          	jalr	920(ra) # 80006266 <panic>
    printf("scause %p\n", scause);
    80001ed6:	85ce                	mv	a1,s3
    80001ed8:	00006517          	auipc	a0,0x6
    80001edc:	44850513          	addi	a0,a0,1096 # 80008320 <etext+0x320>
    80001ee0:	00004097          	auipc	ra,0x4
    80001ee4:	3d0080e7          	jalr	976(ra) # 800062b0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ee8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eec:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ef0:	00006517          	auipc	a0,0x6
    80001ef4:	44050513          	addi	a0,a0,1088 # 80008330 <etext+0x330>
    80001ef8:	00004097          	auipc	ra,0x4
    80001efc:	3b8080e7          	jalr	952(ra) # 800062b0 <printf>
    panic("kerneltrap");
    80001f00:	00006517          	auipc	a0,0x6
    80001f04:	44850513          	addi	a0,a0,1096 # 80008348 <etext+0x348>
    80001f08:	00004097          	auipc	ra,0x4
    80001f0c:	35e080e7          	jalr	862(ra) # 80006266 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	066080e7          	jalr	102(ra) # 80000f76 <myproc>
    80001f18:	d541                	beqz	a0,80001ea0 <kerneltrap+0x38>
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	05c080e7          	jalr	92(ra) # 80000f76 <myproc>
    80001f22:	5118                	lw	a4,32(a0)
    80001f24:	4791                	li	a5,4
    80001f26:	f6f71de3          	bne	a4,a5,80001ea0 <kerneltrap+0x38>
    yield();
    80001f2a:	fffff097          	auipc	ra,0xfffff
    80001f2e:	6d6080e7          	jalr	1750(ra) # 80001600 <yield>
    80001f32:	b7bd                	j	80001ea0 <kerneltrap+0x38>

0000000080001f34 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f34:	1101                	addi	sp,sp,-32
    80001f36:	ec06                	sd	ra,24(sp)
    80001f38:	e822                	sd	s0,16(sp)
    80001f3a:	e426                	sd	s1,8(sp)
    80001f3c:	1000                	addi	s0,sp,32
    80001f3e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	036080e7          	jalr	54(ra) # 80000f76 <myproc>
  switch (n) {
    80001f48:	4795                	li	a5,5
    80001f4a:	0497e163          	bltu	a5,s1,80001f8c <argraw+0x58>
    80001f4e:	048a                	slli	s1,s1,0x2
    80001f50:	00007717          	auipc	a4,0x7
    80001f54:	88870713          	addi	a4,a4,-1912 # 800087d8 <states.0+0x30>
    80001f58:	94ba                	add	s1,s1,a4
    80001f5a:	409c                	lw	a5,0(s1)
    80001f5c:	97ba                	add	a5,a5,a4
    80001f5e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f60:	713c                	ld	a5,96(a0)
    80001f62:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f64:	60e2                	ld	ra,24(sp)
    80001f66:	6442                	ld	s0,16(sp)
    80001f68:	64a2                	ld	s1,8(sp)
    80001f6a:	6105                	addi	sp,sp,32
    80001f6c:	8082                	ret
    return p->trapframe->a1;
    80001f6e:	713c                	ld	a5,96(a0)
    80001f70:	7fa8                	ld	a0,120(a5)
    80001f72:	bfcd                	j	80001f64 <argraw+0x30>
    return p->trapframe->a2;
    80001f74:	713c                	ld	a5,96(a0)
    80001f76:	63c8                	ld	a0,128(a5)
    80001f78:	b7f5                	j	80001f64 <argraw+0x30>
    return p->trapframe->a3;
    80001f7a:	713c                	ld	a5,96(a0)
    80001f7c:	67c8                	ld	a0,136(a5)
    80001f7e:	b7dd                	j	80001f64 <argraw+0x30>
    return p->trapframe->a4;
    80001f80:	713c                	ld	a5,96(a0)
    80001f82:	6bc8                	ld	a0,144(a5)
    80001f84:	b7c5                	j	80001f64 <argraw+0x30>
    return p->trapframe->a5;
    80001f86:	713c                	ld	a5,96(a0)
    80001f88:	6fc8                	ld	a0,152(a5)
    80001f8a:	bfe9                	j	80001f64 <argraw+0x30>
  panic("argraw");
    80001f8c:	00006517          	auipc	a0,0x6
    80001f90:	3cc50513          	addi	a0,a0,972 # 80008358 <etext+0x358>
    80001f94:	00004097          	auipc	ra,0x4
    80001f98:	2d2080e7          	jalr	722(ra) # 80006266 <panic>

0000000080001f9c <fetchaddr>:
{
    80001f9c:	1101                	addi	sp,sp,-32
    80001f9e:	ec06                	sd	ra,24(sp)
    80001fa0:	e822                	sd	s0,16(sp)
    80001fa2:	e426                	sd	s1,8(sp)
    80001fa4:	e04a                	sd	s2,0(sp)
    80001fa6:	1000                	addi	s0,sp,32
    80001fa8:	84aa                	mv	s1,a0
    80001faa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	fca080e7          	jalr	-54(ra) # 80000f76 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001fb4:	693c                	ld	a5,80(a0)
    80001fb6:	02f4f863          	bgeu	s1,a5,80001fe6 <fetchaddr+0x4a>
    80001fba:	00848713          	addi	a4,s1,8
    80001fbe:	02e7e663          	bltu	a5,a4,80001fea <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fc2:	46a1                	li	a3,8
    80001fc4:	8626                	mv	a2,s1
    80001fc6:	85ca                	mv	a1,s2
    80001fc8:	6d28                	ld	a0,88(a0)
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	cd4080e7          	jalr	-812(ra) # 80000c9e <copyin>
    80001fd2:	00a03533          	snez	a0,a0
    80001fd6:	40a00533          	neg	a0,a0
}
    80001fda:	60e2                	ld	ra,24(sp)
    80001fdc:	6442                	ld	s0,16(sp)
    80001fde:	64a2                	ld	s1,8(sp)
    80001fe0:	6902                	ld	s2,0(sp)
    80001fe2:	6105                	addi	sp,sp,32
    80001fe4:	8082                	ret
    return -1;
    80001fe6:	557d                	li	a0,-1
    80001fe8:	bfcd                	j	80001fda <fetchaddr+0x3e>
    80001fea:	557d                	li	a0,-1
    80001fec:	b7fd                	j	80001fda <fetchaddr+0x3e>

0000000080001fee <fetchstr>:
{
    80001fee:	7179                	addi	sp,sp,-48
    80001ff0:	f406                	sd	ra,40(sp)
    80001ff2:	f022                	sd	s0,32(sp)
    80001ff4:	ec26                	sd	s1,24(sp)
    80001ff6:	e84a                	sd	s2,16(sp)
    80001ff8:	e44e                	sd	s3,8(sp)
    80001ffa:	1800                	addi	s0,sp,48
    80001ffc:	892a                	mv	s2,a0
    80001ffe:	84ae                	mv	s1,a1
    80002000:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	f74080e7          	jalr	-140(ra) # 80000f76 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000200a:	86ce                	mv	a3,s3
    8000200c:	864a                	mv	a2,s2
    8000200e:	85a6                	mv	a1,s1
    80002010:	6d28                	ld	a0,88(a0)
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	d1a080e7          	jalr	-742(ra) # 80000d2c <copyinstr>
  if(err < 0)
    8000201a:	00054763          	bltz	a0,80002028 <fetchstr+0x3a>
  return strlen(buf);
    8000201e:	8526                	mv	a0,s1
    80002020:	ffffe097          	auipc	ra,0xffffe
    80002024:	3b8080e7          	jalr	952(ra) # 800003d8 <strlen>
}
    80002028:	70a2                	ld	ra,40(sp)
    8000202a:	7402                	ld	s0,32(sp)
    8000202c:	64e2                	ld	s1,24(sp)
    8000202e:	6942                	ld	s2,16(sp)
    80002030:	69a2                	ld	s3,8(sp)
    80002032:	6145                	addi	sp,sp,48
    80002034:	8082                	ret

0000000080002036 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002036:	1101                	addi	sp,sp,-32
    80002038:	ec06                	sd	ra,24(sp)
    8000203a:	e822                	sd	s0,16(sp)
    8000203c:	e426                	sd	s1,8(sp)
    8000203e:	1000                	addi	s0,sp,32
    80002040:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002042:	00000097          	auipc	ra,0x0
    80002046:	ef2080e7          	jalr	-270(ra) # 80001f34 <argraw>
    8000204a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000204c:	4501                	li	a0,0
    8000204e:	60e2                	ld	ra,24(sp)
    80002050:	6442                	ld	s0,16(sp)
    80002052:	64a2                	ld	s1,8(sp)
    80002054:	6105                	addi	sp,sp,32
    80002056:	8082                	ret

0000000080002058 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002058:	1101                	addi	sp,sp,-32
    8000205a:	ec06                	sd	ra,24(sp)
    8000205c:	e822                	sd	s0,16(sp)
    8000205e:	e426                	sd	s1,8(sp)
    80002060:	1000                	addi	s0,sp,32
    80002062:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002064:	00000097          	auipc	ra,0x0
    80002068:	ed0080e7          	jalr	-304(ra) # 80001f34 <argraw>
    8000206c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000206e:	4501                	li	a0,0
    80002070:	60e2                	ld	ra,24(sp)
    80002072:	6442                	ld	s0,16(sp)
    80002074:	64a2                	ld	s1,8(sp)
    80002076:	6105                	addi	sp,sp,32
    80002078:	8082                	ret

000000008000207a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000207a:	1101                	addi	sp,sp,-32
    8000207c:	ec06                	sd	ra,24(sp)
    8000207e:	e822                	sd	s0,16(sp)
    80002080:	e426                	sd	s1,8(sp)
    80002082:	e04a                	sd	s2,0(sp)
    80002084:	1000                	addi	s0,sp,32
    80002086:	84ae                	mv	s1,a1
    80002088:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000208a:	00000097          	auipc	ra,0x0
    8000208e:	eaa080e7          	jalr	-342(ra) # 80001f34 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002092:	864a                	mv	a2,s2
    80002094:	85a6                	mv	a1,s1
    80002096:	00000097          	auipc	ra,0x0
    8000209a:	f58080e7          	jalr	-168(ra) # 80001fee <fetchstr>
}
    8000209e:	60e2                	ld	ra,24(sp)
    800020a0:	6442                	ld	s0,16(sp)
    800020a2:	64a2                	ld	s1,8(sp)
    800020a4:	6902                	ld	s2,0(sp)
    800020a6:	6105                	addi	sp,sp,32
    800020a8:	8082                	ret

00000000800020aa <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800020aa:	1101                	addi	sp,sp,-32
    800020ac:	ec06                	sd	ra,24(sp)
    800020ae:	e822                	sd	s0,16(sp)
    800020b0:	e426                	sd	s1,8(sp)
    800020b2:	e04a                	sd	s2,0(sp)
    800020b4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	ec0080e7          	jalr	-320(ra) # 80000f76 <myproc>
    800020be:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020c0:	06053903          	ld	s2,96(a0)
    800020c4:	0a893783          	ld	a5,168(s2)
    800020c8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020cc:	37fd                	addiw	a5,a5,-1
    800020ce:	4751                	li	a4,20
    800020d0:	00f76f63          	bltu	a4,a5,800020ee <syscall+0x44>
    800020d4:	00369713          	slli	a4,a3,0x3
    800020d8:	00006797          	auipc	a5,0x6
    800020dc:	71878793          	addi	a5,a5,1816 # 800087f0 <syscalls>
    800020e0:	97ba                	add	a5,a5,a4
    800020e2:	639c                	ld	a5,0(a5)
    800020e4:	c789                	beqz	a5,800020ee <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020e6:	9782                	jalr	a5
    800020e8:	06a93823          	sd	a0,112(s2)
    800020ec:	a839                	j	8000210a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020ee:	16048613          	addi	a2,s1,352
    800020f2:	5c8c                	lw	a1,56(s1)
    800020f4:	00006517          	auipc	a0,0x6
    800020f8:	26c50513          	addi	a0,a0,620 # 80008360 <etext+0x360>
    800020fc:	00004097          	auipc	ra,0x4
    80002100:	1b4080e7          	jalr	436(ra) # 800062b0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002104:	70bc                	ld	a5,96(s1)
    80002106:	577d                	li	a4,-1
    80002108:	fbb8                	sd	a4,112(a5)
  }
}
    8000210a:	60e2                	ld	ra,24(sp)
    8000210c:	6442                	ld	s0,16(sp)
    8000210e:	64a2                	ld	s1,8(sp)
    80002110:	6902                	ld	s2,0(sp)
    80002112:	6105                	addi	sp,sp,32
    80002114:	8082                	ret

0000000080002116 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002116:	1101                	addi	sp,sp,-32
    80002118:	ec06                	sd	ra,24(sp)
    8000211a:	e822                	sd	s0,16(sp)
    8000211c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000211e:	fec40593          	addi	a1,s0,-20
    80002122:	4501                	li	a0,0
    80002124:	00000097          	auipc	ra,0x0
    80002128:	f12080e7          	jalr	-238(ra) # 80002036 <argint>
    return -1;
    8000212c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000212e:	00054963          	bltz	a0,80002140 <sys_exit+0x2a>
  exit(n);
    80002132:	fec42503          	lw	a0,-20(s0)
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	762080e7          	jalr	1890(ra) # 80001898 <exit>
  return 0;  // not reached
    8000213e:	4781                	li	a5,0
}
    80002140:	853e                	mv	a0,a5
    80002142:	60e2                	ld	ra,24(sp)
    80002144:	6442                	ld	s0,16(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret

000000008000214a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000214a:	1141                	addi	sp,sp,-16
    8000214c:	e406                	sd	ra,8(sp)
    8000214e:	e022                	sd	s0,0(sp)
    80002150:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	e24080e7          	jalr	-476(ra) # 80000f76 <myproc>
}
    8000215a:	5d08                	lw	a0,56(a0)
    8000215c:	60a2                	ld	ra,8(sp)
    8000215e:	6402                	ld	s0,0(sp)
    80002160:	0141                	addi	sp,sp,16
    80002162:	8082                	ret

0000000080002164 <sys_fork>:

uint64
sys_fork(void)
{
    80002164:	1141                	addi	sp,sp,-16
    80002166:	e406                	sd	ra,8(sp)
    80002168:	e022                	sd	s0,0(sp)
    8000216a:	0800                	addi	s0,sp,16
  return fork();
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	1dc080e7          	jalr	476(ra) # 80001348 <fork>
}
    80002174:	60a2                	ld	ra,8(sp)
    80002176:	6402                	ld	s0,0(sp)
    80002178:	0141                	addi	sp,sp,16
    8000217a:	8082                	ret

000000008000217c <sys_wait>:

uint64
sys_wait(void)
{
    8000217c:	1101                	addi	sp,sp,-32
    8000217e:	ec06                	sd	ra,24(sp)
    80002180:	e822                	sd	s0,16(sp)
    80002182:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002184:	fe840593          	addi	a1,s0,-24
    80002188:	4501                	li	a0,0
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	ece080e7          	jalr	-306(ra) # 80002058 <argaddr>
    80002192:	87aa                	mv	a5,a0
    return -1;
    80002194:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002196:	0007c863          	bltz	a5,800021a6 <sys_wait+0x2a>
  return wait(p);
    8000219a:	fe843503          	ld	a0,-24(s0)
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	502080e7          	jalr	1282(ra) # 800016a0 <wait>
}
    800021a6:	60e2                	ld	ra,24(sp)
    800021a8:	6442                	ld	s0,16(sp)
    800021aa:	6105                	addi	sp,sp,32
    800021ac:	8082                	ret

00000000800021ae <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021ae:	7179                	addi	sp,sp,-48
    800021b0:	f406                	sd	ra,40(sp)
    800021b2:	f022                	sd	s0,32(sp)
    800021b4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800021b6:	fdc40593          	addi	a1,s0,-36
    800021ba:	4501                	li	a0,0
    800021bc:	00000097          	auipc	ra,0x0
    800021c0:	e7a080e7          	jalr	-390(ra) # 80002036 <argint>
    800021c4:	87aa                	mv	a5,a0
    return -1;
    800021c6:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021c8:	0207c263          	bltz	a5,800021ec <sys_sbrk+0x3e>
    800021cc:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	da8080e7          	jalr	-600(ra) # 80000f76 <myproc>
    800021d6:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    800021d8:	fdc42503          	lw	a0,-36(s0)
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	0f4080e7          	jalr	244(ra) # 800012d0 <growproc>
    800021e4:	00054863          	bltz	a0,800021f4 <sys_sbrk+0x46>
    return -1;
  return addr;
    800021e8:	8526                	mv	a0,s1
    800021ea:	64e2                	ld	s1,24(sp)
}
    800021ec:	70a2                	ld	ra,40(sp)
    800021ee:	7402                	ld	s0,32(sp)
    800021f0:	6145                	addi	sp,sp,48
    800021f2:	8082                	ret
    return -1;
    800021f4:	557d                	li	a0,-1
    800021f6:	64e2                	ld	s1,24(sp)
    800021f8:	bfd5                	j	800021ec <sys_sbrk+0x3e>

00000000800021fa <sys_sleep>:

uint64
sys_sleep(void)
{
    800021fa:	7139                	addi	sp,sp,-64
    800021fc:	fc06                	sd	ra,56(sp)
    800021fe:	f822                	sd	s0,48(sp)
    80002200:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002202:	fcc40593          	addi	a1,s0,-52
    80002206:	4501                	li	a0,0
    80002208:	00000097          	auipc	ra,0x0
    8000220c:	e2e080e7          	jalr	-466(ra) # 80002036 <argint>
    return -1;
    80002210:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002212:	06054b63          	bltz	a0,80002288 <sys_sleep+0x8e>
    80002216:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002218:	0000d517          	auipc	a0,0xd
    8000221c:	f9850513          	addi	a0,a0,-104 # 8000f1b0 <tickslock>
    80002220:	00004097          	auipc	ra,0x4
    80002224:	5aa080e7          	jalr	1450(ra) # 800067ca <acquire>
  ticks0 = ticks;
    80002228:	00007917          	auipc	s2,0x7
    8000222c:	df092903          	lw	s2,-528(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002230:	fcc42783          	lw	a5,-52(s0)
    80002234:	c3a1                	beqz	a5,80002274 <sys_sleep+0x7a>
    80002236:	f426                	sd	s1,40(sp)
    80002238:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000223a:	0000d997          	auipc	s3,0xd
    8000223e:	f7698993          	addi	s3,s3,-138 # 8000f1b0 <tickslock>
    80002242:	00007497          	auipc	s1,0x7
    80002246:	dd648493          	addi	s1,s1,-554 # 80009018 <ticks>
    if(myproc()->killed){
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	d2c080e7          	jalr	-724(ra) # 80000f76 <myproc>
    80002252:	591c                	lw	a5,48(a0)
    80002254:	ef9d                	bnez	a5,80002292 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002256:	85ce                	mv	a1,s3
    80002258:	8526                	mv	a0,s1
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	3e2080e7          	jalr	994(ra) # 8000163c <sleep>
  while(ticks - ticks0 < n){
    80002262:	409c                	lw	a5,0(s1)
    80002264:	412787bb          	subw	a5,a5,s2
    80002268:	fcc42703          	lw	a4,-52(s0)
    8000226c:	fce7efe3          	bltu	a5,a4,8000224a <sys_sleep+0x50>
    80002270:	74a2                	ld	s1,40(sp)
    80002272:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002274:	0000d517          	auipc	a0,0xd
    80002278:	f3c50513          	addi	a0,a0,-196 # 8000f1b0 <tickslock>
    8000227c:	00004097          	auipc	ra,0x4
    80002280:	61e080e7          	jalr	1566(ra) # 8000689a <release>
  return 0;
    80002284:	4781                	li	a5,0
    80002286:	7902                	ld	s2,32(sp)
}
    80002288:	853e                	mv	a0,a5
    8000228a:	70e2                	ld	ra,56(sp)
    8000228c:	7442                	ld	s0,48(sp)
    8000228e:	6121                	addi	sp,sp,64
    80002290:	8082                	ret
      release(&tickslock);
    80002292:	0000d517          	auipc	a0,0xd
    80002296:	f1e50513          	addi	a0,a0,-226 # 8000f1b0 <tickslock>
    8000229a:	00004097          	auipc	ra,0x4
    8000229e:	600080e7          	jalr	1536(ra) # 8000689a <release>
      return -1;
    800022a2:	57fd                	li	a5,-1
    800022a4:	74a2                	ld	s1,40(sp)
    800022a6:	7902                	ld	s2,32(sp)
    800022a8:	69e2                	ld	s3,24(sp)
    800022aa:	bff9                	j	80002288 <sys_sleep+0x8e>

00000000800022ac <sys_kill>:

uint64
sys_kill(void)
{
    800022ac:	1101                	addi	sp,sp,-32
    800022ae:	ec06                	sd	ra,24(sp)
    800022b0:	e822                	sd	s0,16(sp)
    800022b2:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800022b4:	fec40593          	addi	a1,s0,-20
    800022b8:	4501                	li	a0,0
    800022ba:	00000097          	auipc	ra,0x0
    800022be:	d7c080e7          	jalr	-644(ra) # 80002036 <argint>
    800022c2:	87aa                	mv	a5,a0
    return -1;
    800022c4:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800022c6:	0007c863          	bltz	a5,800022d6 <sys_kill+0x2a>
  return kill(pid);
    800022ca:	fec42503          	lw	a0,-20(s0)
    800022ce:	fffff097          	auipc	ra,0xfffff
    800022d2:	6a0080e7          	jalr	1696(ra) # 8000196e <kill>
}
    800022d6:	60e2                	ld	ra,24(sp)
    800022d8:	6442                	ld	s0,16(sp)
    800022da:	6105                	addi	sp,sp,32
    800022dc:	8082                	ret

00000000800022de <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022de:	1101                	addi	sp,sp,-32
    800022e0:	ec06                	sd	ra,24(sp)
    800022e2:	e822                	sd	s0,16(sp)
    800022e4:	e426                	sd	s1,8(sp)
    800022e6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022e8:	0000d517          	auipc	a0,0xd
    800022ec:	ec850513          	addi	a0,a0,-312 # 8000f1b0 <tickslock>
    800022f0:	00004097          	auipc	ra,0x4
    800022f4:	4da080e7          	jalr	1242(ra) # 800067ca <acquire>
  xticks = ticks;
    800022f8:	00007497          	auipc	s1,0x7
    800022fc:	d204a483          	lw	s1,-736(s1) # 80009018 <ticks>
  release(&tickslock);
    80002300:	0000d517          	auipc	a0,0xd
    80002304:	eb050513          	addi	a0,a0,-336 # 8000f1b0 <tickslock>
    80002308:	00004097          	auipc	ra,0x4
    8000230c:	592080e7          	jalr	1426(ra) # 8000689a <release>
  return xticks;
}
    80002310:	02049513          	slli	a0,s1,0x20
    80002314:	9101                	srli	a0,a0,0x20
    80002316:	60e2                	ld	ra,24(sp)
    80002318:	6442                	ld	s0,16(sp)
    8000231a:	64a2                	ld	s1,8(sp)
    8000231c:	6105                	addi	sp,sp,32
    8000231e:	8082                	ret

0000000080002320 <HASHNUM>:
#include "defs.h"
#include "fs.h"
#include "buf.h"
#define NBUCKETS 13
int HASHNUM(uint n)
{
    80002320:	1141                	addi	sp,sp,-16
    80002322:	e422                	sd	s0,8(sp)
    80002324:	0800                	addi	s0,sp,16
  return n % NBUCKETS;
    80002326:	47b5                	li	a5,13
    80002328:	02f5753b          	remuw	a0,a0,a5
}
    8000232c:	2501                	sext.w	a0,a0
    8000232e:	6422                	ld	s0,8(sp)
    80002330:	0141                	addi	sp,sp,16
    80002332:	8082                	ret

0000000080002334 <binit>:
  struct buf head[NBUCKETS];           // 哈希桶头
  struct spinlock hash_lock[NBUCKETS]; // 哈希桶锁
} bcache;
 
void binit(void)
{
    80002334:	711d                	addi	sp,sp,-96
    80002336:	ec86                	sd	ra,88(sp)
    80002338:	e8a2                	sd	s0,80(sp)
    8000233a:	e4a6                	sd	s1,72(sp)
    8000233c:	e0ca                	sd	s2,64(sp)
    8000233e:	fc4e                	sd	s3,56(sp)
    80002340:	f852                	sd	s4,48(sp)
    80002342:	f456                	sd	s5,40(sp)
    80002344:	f05a                	sd	s6,32(sp)
    80002346:	ec5e                	sd	s7,24(sp)
    80002348:	e862                	sd	s8,16(sp)
    8000234a:	e466                	sd	s9,8(sp)
    8000234c:	e06a                	sd	s10,0(sp)
    8000234e:	1080                	addi	s0,sp,96
  struct buf *b;
 
  initlock(&bcache.lock, "bcache");
    80002350:	00006597          	auipc	a1,0x6
    80002354:	03058593          	addi	a1,a1,48 # 80008380 <etext+0x380>
    80002358:	0000d517          	auipc	a0,0xd
    8000235c:	e7850513          	addi	a0,a0,-392 # 8000f1d0 <bcache>
    80002360:	00004097          	auipc	ra,0x4
    80002364:	5e6080e7          	jalr	1510(ra) # 80006946 <initlock>
 
  // 哈希桶和哈希桶锁初始化
  for (int i = 0; i < NBUCKETS; i++)
    80002368:	00019917          	auipc	s2,0x19
    8000236c:	aa890913          	addi	s2,s2,-1368 # 8001ae10 <bcache+0xbc40>
    80002370:	00015497          	auipc	s1,0x15
    80002374:	1c048493          	addi	s1,s1,448 # 80017530 <bcache+0x8360>
    80002378:	8a4a                	mv	s4,s2
  {
    // snprintf(name, 20, "bcache.bucket.%d", i);
    // printf("name:%s\n",);
    initlock(&bcache.hash_lock[i], "bcache.bucket");
    8000237a:	00006997          	auipc	s3,0x6
    8000237e:	00e98993          	addi	s3,s3,14 # 80008388 <etext+0x388>
    80002382:	85ce                	mv	a1,s3
    80002384:	854a                	mv	a0,s2
    80002386:	00004097          	auipc	ra,0x4
    8000238a:	5c0080e7          	jalr	1472(ra) # 80006946 <initlock>
    bcache.head[i].prev = &bcache.head[i];
    8000238e:	e8a4                	sd	s1,80(s1)
    bcache.head[i].next = &bcache.head[i];
    80002390:	eca4                	sd	s1,88(s1)
  for (int i = 0; i < NBUCKETS; i++)
    80002392:	02090913          	addi	s2,s2,32
    80002396:	46048493          	addi	s1,s1,1120
    8000239a:	ff4494e3          	bne	s1,s4,80002382 <binit+0x4e>
    8000239e:	0000d497          	auipc	s1,0xd
    800023a2:	e6248493          	addi	s1,s1,-414 # 8000f200 <bcache+0x30>
    800023a6:	67a1                	lui	a5,0x8
    800023a8:	37078793          	addi	a5,a5,880 # 8370 <_entry-0x7fff7c90>
    800023ac:	0000db17          	auipc	s6,0xd
    800023b0:	e24b0b13          	addi	s6,s6,-476 # 8000f1d0 <bcache>
    800023b4:	9b3e                	add	s6,s6,a5
  return n % NBUCKETS;
    800023b6:	4d35                	li	s10,13
  for (int i = 0; i < NBUF; i++)
  {
    b = &bcache.buf[i];
    // printf("blockno:%d\n",b->blockno);
    hash_num = HASHNUM(b->blockno);
    b->next = bcache.head[hash_num].next;
    800023b8:	0000da17          	auipc	s4,0xd
    800023bc:	e18a0a13          	addi	s4,s4,-488 # 8000f1d0 <bcache>
    800023c0:	46000c93          	li	s9,1120
    800023c4:	6c21                	lui	s8,0x8
    b->prev = &bcache.head[hash_num];
    800023c6:	6aa1                	lui	s5,0x8
    800023c8:	360a8a93          	addi	s5,s5,864 # 8360 <_entry-0x7fff7ca0>
    initsleeplock(&b->lock, "buffer");
    800023cc:	00006b97          	auipc	s7,0x6
    800023d0:	fccb8b93          	addi	s7,s7,-52 # 80008398 <etext+0x398>
    b = &bcache.buf[i];
    800023d4:	ff048993          	addi	s3,s1,-16
  return n % NBUCKETS;
    800023d8:	ffc4a783          	lw	a5,-4(s1)
    800023dc:	03a7f7bb          	remuw	a5,a5,s10
    800023e0:	2781                	sext.w	a5,a5
    b->next = bcache.head[hash_num].next;
    800023e2:	039787b3          	mul	a5,a5,s9
    800023e6:	00fa0933          	add	s2,s4,a5
    800023ea:	9962                	add	s2,s2,s8
    800023ec:	3b893703          	ld	a4,952(s2)
    800023f0:	e4b8                	sd	a4,72(s1)
    b->prev = &bcache.head[hash_num];
    800023f2:	97d6                	add	a5,a5,s5
    800023f4:	97d2                	add	a5,a5,s4
    800023f6:	e0bc                	sd	a5,64(s1)
    initsleeplock(&b->lock, "buffer");
    800023f8:	85de                	mv	a1,s7
    800023fa:	8526                	mv	a0,s1
    800023fc:	00001097          	auipc	ra,0x1
    80002400:	606080e7          	jalr	1542(ra) # 80003a02 <initsleeplock>
    bcache.head[hash_num].next->prev = b;
    80002404:	3b893783          	ld	a5,952(s2)
    80002408:	0537b823          	sd	s3,80(a5)
    bcache.head[hash_num].next = b;
    8000240c:	3b393c23          	sd	s3,952(s2)
  for (int i = 0; i < NBUF; i++)
    80002410:	46048493          	addi	s1,s1,1120
    80002414:	fd6490e3          	bne	s1,s6,800023d4 <binit+0xa0>
  }
}
    80002418:	60e6                	ld	ra,88(sp)
    8000241a:	6446                	ld	s0,80(sp)
    8000241c:	64a6                	ld	s1,72(sp)
    8000241e:	6906                	ld	s2,64(sp)
    80002420:	79e2                	ld	s3,56(sp)
    80002422:	7a42                	ld	s4,48(sp)
    80002424:	7aa2                	ld	s5,40(sp)
    80002426:	7b02                	ld	s6,32(sp)
    80002428:	6be2                	ld	s7,24(sp)
    8000242a:	6c42                	ld	s8,16(sp)
    8000242c:	6ca2                	ld	s9,8(sp)
    8000242e:	6d02                	ld	s10,0(sp)
    80002430:	6125                	addi	sp,sp,96
    80002432:	8082                	ret

0000000080002434 <bread>:
  panic("bget: no buffers");
}
// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002434:	711d                	addi	sp,sp,-96
    80002436:	ec86                	sd	ra,88(sp)
    80002438:	e8a2                	sd	s0,80(sp)
    8000243a:	e4a6                	sd	s1,72(sp)
    8000243c:	e0ca                	sd	s2,64(sp)
    8000243e:	fc4e                	sd	s3,56(sp)
    80002440:	f852                	sd	s4,48(sp)
    80002442:	f456                	sd	s5,40(sp)
    80002444:	f05a                	sd	s6,32(sp)
    80002446:	ec5e                	sd	s7,24(sp)
    80002448:	1080                	addi	s0,sp,96
    8000244a:	89aa                	mv	s3,a0
    8000244c:	8a2e                	mv	s4,a1
  return n % NBUCKETS;
    8000244e:	4ab5                	li	s5,13
    80002450:	0355fabb          	remuw	s5,a1,s5
    80002454:	2a81                	sext.w	s5,s5
  acquire(&bcache.hash_lock[hash_num]);
    80002456:	5e2a8b13          	addi	s6,s5,1506
    8000245a:	0b16                	slli	s6,s6,0x5
    8000245c:	0000db97          	auipc	s7,0xd
    80002460:	d74b8b93          	addi	s7,s7,-652 # 8000f1d0 <bcache>
    80002464:	9b5e                	add	s6,s6,s7
    80002466:	855a                	mv	a0,s6
    80002468:	00004097          	auipc	ra,0x4
    8000246c:	362080e7          	jalr	866(ra) # 800067ca <acquire>
  for (b = bcache.head[hash_num].next; b != &bcache.head[hash_num]; b = b->next)
    80002470:	46000913          	li	s2,1120
    80002474:	032a8933          	mul	s2,s5,s2
    80002478:	012b8733          	add	a4,s7,s2
    8000247c:	67a1                	lui	a5,0x8
    8000247e:	97ba                	add	a5,a5,a4
    80002480:	3b87b483          	ld	s1,952(a5) # 83b8 <_entry-0x7fff7c48>
    80002484:	67a1                	lui	a5,0x8
    80002486:	36078793          	addi	a5,a5,864 # 8360 <_entry-0x7fff7ca0>
    8000248a:	993e                	add	s2,s2,a5
    8000248c:	995e                	add	s2,s2,s7
    8000248e:	0b249963          	bne	s1,s2,80002540 <bread+0x10c>
  release(&bcache.hash_lock[hash_num]);
    80002492:	855a                	mv	a0,s6
    80002494:	00004097          	auipc	ra,0x4
    80002498:	406080e7          	jalr	1030(ra) # 8000689a <release>
  acquire(&bcache.lock);
    8000249c:	0000d517          	auipc	a0,0xd
    800024a0:	d3450513          	addi	a0,a0,-716 # 8000f1d0 <bcache>
    800024a4:	00004097          	auipc	ra,0x4
    800024a8:	326080e7          	jalr	806(ra) # 800067ca <acquire>
  acquire(&bcache.hash_lock[hash_num]);
    800024ac:	855a                	mv	a0,s6
    800024ae:	00004097          	auipc	ra,0x4
    800024b2:	31c080e7          	jalr	796(ra) # 800067ca <acquire>
  for (b = bcache.head[hash_num].next; b != &bcache.head[hash_num]; b = b->next)
    800024b6:	46000793          	li	a5,1120
    800024ba:	02fa87b3          	mul	a5,s5,a5
    800024be:	0000d717          	auipc	a4,0xd
    800024c2:	d1270713          	addi	a4,a4,-750 # 8000f1d0 <bcache>
    800024c6:	973e                	add	a4,a4,a5
    800024c8:	67a1                	lui	a5,0x8
    800024ca:	97ba                	add	a5,a5,a4
    800024cc:	3b87b483          	ld	s1,952(a5) # 83b8 <_entry-0x7fff7c48>
    800024d0:	0b249063          	bne	s1,s2,80002570 <bread+0x13c>
    800024d4:	e862                	sd	s8,16(sp)
    800024d6:	e466                	sd	s9,8(sp)
  release(&bcache.hash_lock[hash_num]);
    800024d8:	855a                	mv	a0,s6
    800024da:	00004097          	auipc	ra,0x4
    800024de:	3c0080e7          	jalr	960(ra) # 8000689a <release>
  for (int i = 0; i < NBUCKETS; i++)
    800024e2:	00019c17          	auipc	s8,0x19
    800024e6:	92ec0c13          	addi	s8,s8,-1746 # 8001ae10 <bcache+0xbc40>
    800024ea:	00015b17          	auipc	s6,0x15
    800024ee:	046b0b13          	addi	s6,s6,70 # 80017530 <bcache+0x8360>
    800024f2:	8ce2                	mv	s9,s8
    acquire(&bcache.hash_lock[i]);
    800024f4:	8be2                	mv	s7,s8
    800024f6:	8562                	mv	a0,s8
    800024f8:	00004097          	auipc	ra,0x4
    800024fc:	2d2080e7          	jalr	722(ra) # 800067ca <acquire>
    for (b = bcache.head[i].prev; b != &bcache.head[i]; b = b->prev)
    80002500:	875a                	mv	a4,s6
    80002502:	050b3483          	ld	s1,80(s6)
    80002506:	01648763          	beq	s1,s6,80002514 <bread+0xe0>
      if (b->refcnt==0)
    8000250a:	44bc                	lw	a5,72(s1)
    8000250c:	cfd9                	beqz	a5,800025aa <bread+0x176>
    for (b = bcache.head[i].prev; b != &bcache.head[i]; b = b->prev)
    8000250e:	68a4                	ld	s1,80(s1)
    80002510:	fee49de3          	bne	s1,a4,8000250a <bread+0xd6>
    release(&bcache.hash_lock[i]);
    80002514:	855e                	mv	a0,s7
    80002516:	00004097          	auipc	ra,0x4
    8000251a:	384080e7          	jalr	900(ra) # 8000689a <release>
  for (int i = 0; i < NBUCKETS; i++)
    8000251e:	020c0c13          	addi	s8,s8,32
    80002522:	460b0b13          	addi	s6,s6,1120
    80002526:	fd9b17e3          	bne	s6,s9,800024f4 <bread+0xc0>
  panic("bget: no buffers");
    8000252a:	00006517          	auipc	a0,0x6
    8000252e:	e7650513          	addi	a0,a0,-394 # 800083a0 <etext+0x3a0>
    80002532:	00004097          	auipc	ra,0x4
    80002536:	d34080e7          	jalr	-716(ra) # 80006266 <panic>
  for (b = bcache.head[hash_num].next; b != &bcache.head[hash_num]; b = b->next)
    8000253a:	6ca4                	ld	s1,88(s1)
    8000253c:	f5248be3          	beq	s1,s2,80002492 <bread+0x5e>
    if (b->dev == dev && b->blockno == blockno)
    80002540:	449c                	lw	a5,8(s1)
    80002542:	ff379ce3          	bne	a5,s3,8000253a <bread+0x106>
    80002546:	44dc                	lw	a5,12(s1)
    80002548:	ff4799e3          	bne	a5,s4,8000253a <bread+0x106>
      b->refcnt++;
    8000254c:	44bc                	lw	a5,72(s1)
    8000254e:	2785                	addiw	a5,a5,1
    80002550:	c4bc                	sw	a5,72(s1)
      release(&bcache.hash_lock[hash_num]);
    80002552:	855a                	mv	a0,s6
    80002554:	00004097          	auipc	ra,0x4
    80002558:	346080e7          	jalr	838(ra) # 8000689a <release>
      acquiresleep(&b->lock);
    8000255c:	01048513          	addi	a0,s1,16
    80002560:	00001097          	auipc	ra,0x1
    80002564:	4dc080e7          	jalr	1244(ra) # 80003a3c <acquiresleep>
      return b;
    80002568:	a06d                	j	80002612 <bread+0x1de>
  for (b = bcache.head[hash_num].next; b != &bcache.head[hash_num]; b = b->next)
    8000256a:	6ca4                	ld	s1,88(s1)
    8000256c:	f72484e3          	beq	s1,s2,800024d4 <bread+0xa0>
    if (b->dev == dev && b->blockno == blockno)
    80002570:	449c                	lw	a5,8(s1)
    80002572:	ff379ce3          	bne	a5,s3,8000256a <bread+0x136>
    80002576:	44dc                	lw	a5,12(s1)
    80002578:	ff4799e3          	bne	a5,s4,8000256a <bread+0x136>
      b->refcnt++;
    8000257c:	44bc                	lw	a5,72(s1)
    8000257e:	2785                	addiw	a5,a5,1
    80002580:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    80002582:	0000d517          	auipc	a0,0xd
    80002586:	c4e50513          	addi	a0,a0,-946 # 8000f1d0 <bcache>
    8000258a:	00004097          	auipc	ra,0x4
    8000258e:	310080e7          	jalr	784(ra) # 8000689a <release>
      release(&bcache.hash_lock[hash_num]);
    80002592:	855a                	mv	a0,s6
    80002594:	00004097          	auipc	ra,0x4
    80002598:	306080e7          	jalr	774(ra) # 8000689a <release>
      acquiresleep(&b->lock);
    8000259c:	01048513          	addi	a0,s1,16
    800025a0:	00001097          	auipc	ra,0x1
    800025a4:	49c080e7          	jalr	1180(ra) # 80003a3c <acquiresleep>
      return b;
    800025a8:	a0ad                	j	80002612 <bread+0x1de>
        b->dev=dev;
    800025aa:	0134a423          	sw	s3,8(s1)
        b->blockno=blockno;
    800025ae:	0144a623          	sw	s4,12(s1)
        b->valid=0;
    800025b2:	0004a023          	sw	zero,0(s1)
        b->refcnt=1;
    800025b6:	4785                	li	a5,1
    800025b8:	c4bc                	sw	a5,72(s1)
        b->prev->next=b->next;
    800025ba:	68b8                	ld	a4,80(s1)
    800025bc:	6cbc                	ld	a5,88(s1)
    800025be:	ef3c                	sd	a5,88(a4)
        b->next->prev=b->prev;
    800025c0:	68b8                	ld	a4,80(s1)
    800025c2:	ebb8                	sd	a4,80(a5)
        b->next=bcache.head[hash_num].next;
    800025c4:	0000d997          	auipc	s3,0xd
    800025c8:	c0c98993          	addi	s3,s3,-1012 # 8000f1d0 <bcache>
    800025cc:	46000793          	li	a5,1120
    800025d0:	02fa8ab3          	mul	s5,s5,a5
    800025d4:	9ace                	add	s5,s5,s3
    800025d6:	67a1                	lui	a5,0x8
    800025d8:	97d6                	add	a5,a5,s5
    800025da:	3b87b703          	ld	a4,952(a5) # 83b8 <_entry-0x7fff7c48>
    800025de:	ecb8                	sd	a4,88(s1)
        b->prev=&bcache.head[hash_num];
    800025e0:	0524b823          	sd	s2,80(s1)
        bcache.head[hash_num].next->prev=b;
    800025e4:	3b87b703          	ld	a4,952(a5)
    800025e8:	eb24                	sd	s1,80(a4)
        bcache.head[hash_num].next=b;
    800025ea:	3a97bc23          	sd	s1,952(a5)
        release(&bcache.hash_lock[i]);
    800025ee:	855e                	mv	a0,s7
    800025f0:	00004097          	auipc	ra,0x4
    800025f4:	2aa080e7          	jalr	682(ra) # 8000689a <release>
        release(&bcache.lock);
    800025f8:	854e                	mv	a0,s3
    800025fa:	00004097          	auipc	ra,0x4
    800025fe:	2a0080e7          	jalr	672(ra) # 8000689a <release>
        acquiresleep(&b->lock);
    80002602:	01048513          	addi	a0,s1,16
    80002606:	00001097          	auipc	ra,0x1
    8000260a:	436080e7          	jalr	1078(ra) # 80003a3c <acquiresleep>
        return b;
    8000260e:	6c42                	ld	s8,16(sp)
    80002610:	6ca2                	ld	s9,8(sp)
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002612:	409c                	lw	a5,0(s1)
    80002614:	cf89                	beqz	a5,8000262e <bread+0x1fa>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002616:	8526                	mv	a0,s1
    80002618:	60e6                	ld	ra,88(sp)
    8000261a:	6446                	ld	s0,80(sp)
    8000261c:	64a6                	ld	s1,72(sp)
    8000261e:	6906                	ld	s2,64(sp)
    80002620:	79e2                	ld	s3,56(sp)
    80002622:	7a42                	ld	s4,48(sp)
    80002624:	7aa2                	ld	s5,40(sp)
    80002626:	7b02                	ld	s6,32(sp)
    80002628:	6be2                	ld	s7,24(sp)
    8000262a:	6125                	addi	sp,sp,96
    8000262c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000262e:	4581                	li	a1,0
    80002630:	8526                	mv	a0,s1
    80002632:	00003097          	auipc	ra,0x3
    80002636:	020080e7          	jalr	32(ra) # 80005652 <virtio_disk_rw>
    b->valid = 1;
    8000263a:	4785                	li	a5,1
    8000263c:	c09c                	sw	a5,0(s1)
  return b;
    8000263e:	bfe1                	j	80002616 <bread+0x1e2>

0000000080002640 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002640:	1101                	addi	sp,sp,-32
    80002642:	ec06                	sd	ra,24(sp)
    80002644:	e822                	sd	s0,16(sp)
    80002646:	e426                	sd	s1,8(sp)
    80002648:	1000                	addi	s0,sp,32
    8000264a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000264c:	0541                	addi	a0,a0,16
    8000264e:	00001097          	auipc	ra,0x1
    80002652:	488080e7          	jalr	1160(ra) # 80003ad6 <holdingsleep>
    80002656:	cd01                	beqz	a0,8000266e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002658:	4585                	li	a1,1
    8000265a:	8526                	mv	a0,s1
    8000265c:	00003097          	auipc	ra,0x3
    80002660:	ff6080e7          	jalr	-10(ra) # 80005652 <virtio_disk_rw>
}
    80002664:	60e2                	ld	ra,24(sp)
    80002666:	6442                	ld	s0,16(sp)
    80002668:	64a2                	ld	s1,8(sp)
    8000266a:	6105                	addi	sp,sp,32
    8000266c:	8082                	ret
    panic("bwrite");
    8000266e:	00006517          	auipc	a0,0x6
    80002672:	d4a50513          	addi	a0,a0,-694 # 800083b8 <etext+0x3b8>
    80002676:	00004097          	auipc	ra,0x4
    8000267a:	bf0080e7          	jalr	-1040(ra) # 80006266 <panic>

000000008000267e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b)
{
    8000267e:	1101                	addi	sp,sp,-32
    80002680:	ec06                	sd	ra,24(sp)
    80002682:	e822                	sd	s0,16(sp)
    80002684:	e426                	sd	s1,8(sp)
    80002686:	e04a                	sd	s2,0(sp)
    80002688:	1000                	addi	s0,sp,32
    8000268a:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    8000268c:	01050913          	addi	s2,a0,16
    80002690:	854a                	mv	a0,s2
    80002692:	00001097          	auipc	ra,0x1
    80002696:	444080e7          	jalr	1092(ra) # 80003ad6 <holdingsleep>
    8000269a:	c505                	beqz	a0,800026c2 <brelse+0x44>
    panic("brelse");
 
  releasesleep(&b->lock);
    8000269c:	854a                	mv	a0,s2
    8000269e:	00001097          	auipc	ra,0x1
    800026a2:	3f4080e7          	jalr	1012(ra) # 80003a92 <releasesleep>
 
  // acquire(&bcache.lock);
  
  int hash_num = HASHNUM(b->blockno);
    800026a6:	44dc                	lw	a5,12(s1)
  // acquire(&bcache.hash_lock[hash_num]);
  if (b->refcnt > 0)
    800026a8:	44b8                	lw	a4,72(s1)
    800026aa:	c705                	beqz	a4,800026d2 <brelse+0x54>
  {
    b->refcnt--;
    800026ac:	377d                	addiw	a4,a4,-1
    800026ae:	0007069b          	sext.w	a3,a4
    800026b2:	c4b8                	sw	a4,72(s1)
  }
  if (b->refcnt == 0)
    800026b4:	ce99                	beqz	a3,800026d2 <brelse+0x54>
    b->next = bcache.head[hash_num].next;
    b->prev = &bcache.head[hash_num];
    bcache.head[hash_num].next->prev = b;
    bcache.head[hash_num].next = b;
  }
}
    800026b6:	60e2                	ld	ra,24(sp)
    800026b8:	6442                	ld	s0,16(sp)
    800026ba:	64a2                	ld	s1,8(sp)
    800026bc:	6902                	ld	s2,0(sp)
    800026be:	6105                	addi	sp,sp,32
    800026c0:	8082                	ret
    panic("brelse");
    800026c2:	00006517          	auipc	a0,0x6
    800026c6:	cfe50513          	addi	a0,a0,-770 # 800083c0 <etext+0x3c0>
    800026ca:	00004097          	auipc	ra,0x4
    800026ce:	b9c080e7          	jalr	-1124(ra) # 80006266 <panic>
  return n % NBUCKETS;
    800026d2:	4735                	li	a4,13
    800026d4:	02e7f7bb          	remuw	a5,a5,a4
    800026d8:	2781                	sext.w	a5,a5
    b->next->prev = b->prev;
    800026da:	6cb4                	ld	a3,88(s1)
    800026dc:	68b8                	ld	a4,80(s1)
    800026de:	eab8                	sd	a4,80(a3)
    b->prev->next = b->next;
    800026e0:	6cb4                	ld	a3,88(s1)
    800026e2:	ef34                	sd	a3,88(a4)
    b->next = bcache.head[hash_num].next;
    800026e4:	0000d617          	auipc	a2,0xd
    800026e8:	aec60613          	addi	a2,a2,-1300 # 8000f1d0 <bcache>
    800026ec:	46000713          	li	a4,1120
    800026f0:	02e787b3          	mul	a5,a5,a4
    800026f4:	00f606b3          	add	a3,a2,a5
    800026f8:	6721                	lui	a4,0x8
    800026fa:	9736                	add	a4,a4,a3
    800026fc:	3b873683          	ld	a3,952(a4) # 83b8 <_entry-0x7fff7c48>
    80002700:	ecb4                	sd	a3,88(s1)
    b->prev = &bcache.head[hash_num];
    80002702:	66a1                	lui	a3,0x8
    80002704:	36068693          	addi	a3,a3,864 # 8360 <_entry-0x7fff7ca0>
    80002708:	97b6                	add	a5,a5,a3
    8000270a:	97b2                	add	a5,a5,a2
    8000270c:	e8bc                	sd	a5,80(s1)
    bcache.head[hash_num].next->prev = b;
    8000270e:	3b873783          	ld	a5,952(a4)
    80002712:	eba4                	sd	s1,80(a5)
    bcache.head[hash_num].next = b;
    80002714:	3a973c23          	sd	s1,952(a4)
}
    80002718:	bf79                	j	800026b6 <brelse+0x38>

000000008000271a <bpin>:
void bpin(struct buf *b)
{
    8000271a:	1101                	addi	sp,sp,-32
    8000271c:	ec06                	sd	ra,24(sp)
    8000271e:	e822                	sd	s0,16(sp)
    80002720:	e426                	sd	s1,8(sp)
    80002722:	e04a                	sd	s2,0(sp)
    80002724:	1000                	addi	s0,sp,32
    80002726:	892a                	mv	s2,a0
  return n % NBUCKETS;
    80002728:	4544                	lw	s1,12(a0)
    8000272a:	47b5                	li	a5,13
    8000272c:	02f4f4bb          	remuw	s1,s1,a5
  int hash_num=HASHNUM(b->blockno);
  acquire(&bcache.hash_lock[hash_num]);
    80002730:	5e24849b          	addiw	s1,s1,1506
    80002734:	2481                	sext.w	s1,s1
    80002736:	0496                	slli	s1,s1,0x5
    80002738:	0000d797          	auipc	a5,0xd
    8000273c:	a9878793          	addi	a5,a5,-1384 # 8000f1d0 <bcache>
    80002740:	94be                	add	s1,s1,a5
    80002742:	8526                	mv	a0,s1
    80002744:	00004097          	auipc	ra,0x4
    80002748:	086080e7          	jalr	134(ra) # 800067ca <acquire>
  b->refcnt++;
    8000274c:	04892783          	lw	a5,72(s2)
    80002750:	2785                	addiw	a5,a5,1
    80002752:	04f92423          	sw	a5,72(s2)
  release(&bcache.hash_lock[hash_num]);
    80002756:	8526                	mv	a0,s1
    80002758:	00004097          	auipc	ra,0x4
    8000275c:	142080e7          	jalr	322(ra) # 8000689a <release>
  // acquire(&bcache.lock);
  // b->refcnt++;
  // release(&bcache.lock);
}
    80002760:	60e2                	ld	ra,24(sp)
    80002762:	6442                	ld	s0,16(sp)
    80002764:	64a2                	ld	s1,8(sp)
    80002766:	6902                	ld	s2,0(sp)
    80002768:	6105                	addi	sp,sp,32
    8000276a:	8082                	ret

000000008000276c <bunpin>:
 
void bunpin(struct buf *b)
{
    8000276c:	1101                	addi	sp,sp,-32
    8000276e:	ec06                	sd	ra,24(sp)
    80002770:	e822                	sd	s0,16(sp)
    80002772:	e426                	sd	s1,8(sp)
    80002774:	e04a                	sd	s2,0(sp)
    80002776:	1000                	addi	s0,sp,32
    80002778:	892a                	mv	s2,a0
  return n % NBUCKETS;
    8000277a:	4544                	lw	s1,12(a0)
    8000277c:	47b5                	li	a5,13
    8000277e:	02f4f4bb          	remuw	s1,s1,a5
  int hash_num=HASHNUM(b->blockno);
  acquire(&bcache.hash_lock[hash_num]);
    80002782:	5e24849b          	addiw	s1,s1,1506
    80002786:	2481                	sext.w	s1,s1
    80002788:	0496                	slli	s1,s1,0x5
    8000278a:	0000d797          	auipc	a5,0xd
    8000278e:	a4678793          	addi	a5,a5,-1466 # 8000f1d0 <bcache>
    80002792:	94be                	add	s1,s1,a5
    80002794:	8526                	mv	a0,s1
    80002796:	00004097          	auipc	ra,0x4
    8000279a:	034080e7          	jalr	52(ra) # 800067ca <acquire>
  b->refcnt--;
    8000279e:	04892783          	lw	a5,72(s2)
    800027a2:	37fd                	addiw	a5,a5,-1
    800027a4:	04f92423          	sw	a5,72(s2)
  release(&bcache.hash_lock[hash_num]);
    800027a8:	8526                	mv	a0,s1
    800027aa:	00004097          	auipc	ra,0x4
    800027ae:	0f0080e7          	jalr	240(ra) # 8000689a <release>
  // acquire(&bcache.lock);
  // b->refcnt++;
  // release(&bcache.lock);
}
    800027b2:	60e2                	ld	ra,24(sp)
    800027b4:	6442                	ld	s0,16(sp)
    800027b6:	64a2                	ld	s1,8(sp)
    800027b8:	6902                	ld	s2,0(sp)
    800027ba:	6105                	addi	sp,sp,32
    800027bc:	8082                	ret

00000000800027be <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027be:	1101                	addi	sp,sp,-32
    800027c0:	ec06                	sd	ra,24(sp)
    800027c2:	e822                	sd	s0,16(sp)
    800027c4:	e426                	sd	s1,8(sp)
    800027c6:	e04a                	sd	s2,0(sp)
    800027c8:	1000                	addi	s0,sp,32
    800027ca:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027cc:	00d5d59b          	srliw	a1,a1,0xd
    800027d0:	00018797          	auipc	a5,0x18
    800027d4:	7fc7a783          	lw	a5,2044(a5) # 8001afcc <sb+0x1c>
    800027d8:	9dbd                	addw	a1,a1,a5
    800027da:	00000097          	auipc	ra,0x0
    800027de:	c5a080e7          	jalr	-934(ra) # 80002434 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027e2:	0074f713          	andi	a4,s1,7
    800027e6:	4785                	li	a5,1
    800027e8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027ec:	14ce                	slli	s1,s1,0x33
    800027ee:	90d9                	srli	s1,s1,0x36
    800027f0:	00950733          	add	a4,a0,s1
    800027f4:	06074703          	lbu	a4,96(a4)
    800027f8:	00e7f6b3          	and	a3,a5,a4
    800027fc:	c69d                	beqz	a3,8000282a <bfree+0x6c>
    800027fe:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002800:	94aa                	add	s1,s1,a0
    80002802:	fff7c793          	not	a5,a5
    80002806:	8f7d                	and	a4,a4,a5
    80002808:	06e48023          	sb	a4,96(s1)
  log_write(bp);
    8000280c:	00001097          	auipc	ra,0x1
    80002810:	112080e7          	jalr	274(ra) # 8000391e <log_write>
  brelse(bp);
    80002814:	854a                	mv	a0,s2
    80002816:	00000097          	auipc	ra,0x0
    8000281a:	e68080e7          	jalr	-408(ra) # 8000267e <brelse>
}
    8000281e:	60e2                	ld	ra,24(sp)
    80002820:	6442                	ld	s0,16(sp)
    80002822:	64a2                	ld	s1,8(sp)
    80002824:	6902                	ld	s2,0(sp)
    80002826:	6105                	addi	sp,sp,32
    80002828:	8082                	ret
    panic("freeing free block");
    8000282a:	00006517          	auipc	a0,0x6
    8000282e:	b9e50513          	addi	a0,a0,-1122 # 800083c8 <etext+0x3c8>
    80002832:	00004097          	auipc	ra,0x4
    80002836:	a34080e7          	jalr	-1484(ra) # 80006266 <panic>

000000008000283a <balloc>:
{
    8000283a:	711d                	addi	sp,sp,-96
    8000283c:	ec86                	sd	ra,88(sp)
    8000283e:	e8a2                	sd	s0,80(sp)
    80002840:	e4a6                	sd	s1,72(sp)
    80002842:	e0ca                	sd	s2,64(sp)
    80002844:	fc4e                	sd	s3,56(sp)
    80002846:	f852                	sd	s4,48(sp)
    80002848:	f456                	sd	s5,40(sp)
    8000284a:	f05a                	sd	s6,32(sp)
    8000284c:	ec5e                	sd	s7,24(sp)
    8000284e:	e862                	sd	s8,16(sp)
    80002850:	e466                	sd	s9,8(sp)
    80002852:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002854:	00018797          	auipc	a5,0x18
    80002858:	7607a783          	lw	a5,1888(a5) # 8001afb4 <sb+0x4>
    8000285c:	cbc1                	beqz	a5,800028ec <balloc+0xb2>
    8000285e:	8baa                	mv	s7,a0
    80002860:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002862:	00018b17          	auipc	s6,0x18
    80002866:	74eb0b13          	addi	s6,s6,1870 # 8001afb0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000286a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000286c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000286e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002870:	6c89                	lui	s9,0x2
    80002872:	a831                	j	8000288e <balloc+0x54>
    brelse(bp);
    80002874:	854a                	mv	a0,s2
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	e08080e7          	jalr	-504(ra) # 8000267e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000287e:	015c87bb          	addw	a5,s9,s5
    80002882:	00078a9b          	sext.w	s5,a5
    80002886:	004b2703          	lw	a4,4(s6)
    8000288a:	06eaf163          	bgeu	s5,a4,800028ec <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000288e:	41fad79b          	sraiw	a5,s5,0x1f
    80002892:	0137d79b          	srliw	a5,a5,0x13
    80002896:	015787bb          	addw	a5,a5,s5
    8000289a:	40d7d79b          	sraiw	a5,a5,0xd
    8000289e:	01cb2583          	lw	a1,28(s6)
    800028a2:	9dbd                	addw	a1,a1,a5
    800028a4:	855e                	mv	a0,s7
    800028a6:	00000097          	auipc	ra,0x0
    800028aa:	b8e080e7          	jalr	-1138(ra) # 80002434 <bread>
    800028ae:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028b0:	004b2503          	lw	a0,4(s6)
    800028b4:	000a849b          	sext.w	s1,s5
    800028b8:	8762                	mv	a4,s8
    800028ba:	faa4fde3          	bgeu	s1,a0,80002874 <balloc+0x3a>
      m = 1 << (bi % 8);
    800028be:	00777693          	andi	a3,a4,7
    800028c2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028c6:	41f7579b          	sraiw	a5,a4,0x1f
    800028ca:	01d7d79b          	srliw	a5,a5,0x1d
    800028ce:	9fb9                	addw	a5,a5,a4
    800028d0:	4037d79b          	sraiw	a5,a5,0x3
    800028d4:	00f90633          	add	a2,s2,a5
    800028d8:	06064603          	lbu	a2,96(a2)
    800028dc:	00c6f5b3          	and	a1,a3,a2
    800028e0:	cd91                	beqz	a1,800028fc <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028e2:	2705                	addiw	a4,a4,1
    800028e4:	2485                	addiw	s1,s1,1
    800028e6:	fd471ae3          	bne	a4,s4,800028ba <balloc+0x80>
    800028ea:	b769                	j	80002874 <balloc+0x3a>
  panic("balloc: out of blocks");
    800028ec:	00006517          	auipc	a0,0x6
    800028f0:	af450513          	addi	a0,a0,-1292 # 800083e0 <etext+0x3e0>
    800028f4:	00004097          	auipc	ra,0x4
    800028f8:	972080e7          	jalr	-1678(ra) # 80006266 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028fc:	97ca                	add	a5,a5,s2
    800028fe:	8e55                	or	a2,a2,a3
    80002900:	06c78023          	sb	a2,96(a5)
        log_write(bp);
    80002904:	854a                	mv	a0,s2
    80002906:	00001097          	auipc	ra,0x1
    8000290a:	018080e7          	jalr	24(ra) # 8000391e <log_write>
        brelse(bp);
    8000290e:	854a                	mv	a0,s2
    80002910:	00000097          	auipc	ra,0x0
    80002914:	d6e080e7          	jalr	-658(ra) # 8000267e <brelse>
  bp = bread(dev, bno);
    80002918:	85a6                	mv	a1,s1
    8000291a:	855e                	mv	a0,s7
    8000291c:	00000097          	auipc	ra,0x0
    80002920:	b18080e7          	jalr	-1256(ra) # 80002434 <bread>
    80002924:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002926:	40000613          	li	a2,1024
    8000292a:	4581                	li	a1,0
    8000292c:	06050513          	addi	a0,a0,96
    80002930:	ffffe097          	auipc	ra,0xffffe
    80002934:	934080e7          	jalr	-1740(ra) # 80000264 <memset>
  log_write(bp);
    80002938:	854a                	mv	a0,s2
    8000293a:	00001097          	auipc	ra,0x1
    8000293e:	fe4080e7          	jalr	-28(ra) # 8000391e <log_write>
  brelse(bp);
    80002942:	854a                	mv	a0,s2
    80002944:	00000097          	auipc	ra,0x0
    80002948:	d3a080e7          	jalr	-710(ra) # 8000267e <brelse>
}
    8000294c:	8526                	mv	a0,s1
    8000294e:	60e6                	ld	ra,88(sp)
    80002950:	6446                	ld	s0,80(sp)
    80002952:	64a6                	ld	s1,72(sp)
    80002954:	6906                	ld	s2,64(sp)
    80002956:	79e2                	ld	s3,56(sp)
    80002958:	7a42                	ld	s4,48(sp)
    8000295a:	7aa2                	ld	s5,40(sp)
    8000295c:	7b02                	ld	s6,32(sp)
    8000295e:	6be2                	ld	s7,24(sp)
    80002960:	6c42                	ld	s8,16(sp)
    80002962:	6ca2                	ld	s9,8(sp)
    80002964:	6125                	addi	sp,sp,96
    80002966:	8082                	ret

0000000080002968 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002968:	7179                	addi	sp,sp,-48
    8000296a:	f406                	sd	ra,40(sp)
    8000296c:	f022                	sd	s0,32(sp)
    8000296e:	ec26                	sd	s1,24(sp)
    80002970:	e84a                	sd	s2,16(sp)
    80002972:	e44e                	sd	s3,8(sp)
    80002974:	1800                	addi	s0,sp,48
    80002976:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002978:	47ad                	li	a5,11
    8000297a:	04b7ff63          	bgeu	a5,a1,800029d8 <bmap+0x70>
    8000297e:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002980:	ff45849b          	addiw	s1,a1,-12
    80002984:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002988:	0ff00793          	li	a5,255
    8000298c:	0ae7e463          	bltu	a5,a4,80002a34 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002990:	08852583          	lw	a1,136(a0)
    80002994:	c5b5                	beqz	a1,80002a00 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002996:	00092503          	lw	a0,0(s2)
    8000299a:	00000097          	auipc	ra,0x0
    8000299e:	a9a080e7          	jalr	-1382(ra) # 80002434 <bread>
    800029a2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029a4:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    800029a8:	02049713          	slli	a4,s1,0x20
    800029ac:	01e75593          	srli	a1,a4,0x1e
    800029b0:	00b784b3          	add	s1,a5,a1
    800029b4:	0004a983          	lw	s3,0(s1)
    800029b8:	04098e63          	beqz	s3,80002a14 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029bc:	8552                	mv	a0,s4
    800029be:	00000097          	auipc	ra,0x0
    800029c2:	cc0080e7          	jalr	-832(ra) # 8000267e <brelse>
    return addr;
    800029c6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800029c8:	854e                	mv	a0,s3
    800029ca:	70a2                	ld	ra,40(sp)
    800029cc:	7402                	ld	s0,32(sp)
    800029ce:	64e2                	ld	s1,24(sp)
    800029d0:	6942                	ld	s2,16(sp)
    800029d2:	69a2                	ld	s3,8(sp)
    800029d4:	6145                	addi	sp,sp,48
    800029d6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029d8:	02059793          	slli	a5,a1,0x20
    800029dc:	01e7d593          	srli	a1,a5,0x1e
    800029e0:	00b504b3          	add	s1,a0,a1
    800029e4:	0584a983          	lw	s3,88(s1)
    800029e8:	fe0990e3          	bnez	s3,800029c8 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029ec:	4108                	lw	a0,0(a0)
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	e4c080e7          	jalr	-436(ra) # 8000283a <balloc>
    800029f6:	0005099b          	sext.w	s3,a0
    800029fa:	0534ac23          	sw	s3,88(s1)
    800029fe:	b7e9                	j	800029c8 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a00:	4108                	lw	a0,0(a0)
    80002a02:	00000097          	auipc	ra,0x0
    80002a06:	e38080e7          	jalr	-456(ra) # 8000283a <balloc>
    80002a0a:	0005059b          	sext.w	a1,a0
    80002a0e:	08b92423          	sw	a1,136(s2)
    80002a12:	b751                	j	80002996 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a14:	00092503          	lw	a0,0(s2)
    80002a18:	00000097          	auipc	ra,0x0
    80002a1c:	e22080e7          	jalr	-478(ra) # 8000283a <balloc>
    80002a20:	0005099b          	sext.w	s3,a0
    80002a24:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a28:	8552                	mv	a0,s4
    80002a2a:	00001097          	auipc	ra,0x1
    80002a2e:	ef4080e7          	jalr	-268(ra) # 8000391e <log_write>
    80002a32:	b769                	j	800029bc <bmap+0x54>
  panic("bmap: out of range");
    80002a34:	00006517          	auipc	a0,0x6
    80002a38:	9c450513          	addi	a0,a0,-1596 # 800083f8 <etext+0x3f8>
    80002a3c:	00004097          	auipc	ra,0x4
    80002a40:	82a080e7          	jalr	-2006(ra) # 80006266 <panic>

0000000080002a44 <iget>:
{
    80002a44:	7179                	addi	sp,sp,-48
    80002a46:	f406                	sd	ra,40(sp)
    80002a48:	f022                	sd	s0,32(sp)
    80002a4a:	ec26                	sd	s1,24(sp)
    80002a4c:	e84a                	sd	s2,16(sp)
    80002a4e:	e44e                	sd	s3,8(sp)
    80002a50:	e052                	sd	s4,0(sp)
    80002a52:	1800                	addi	s0,sp,48
    80002a54:	89aa                	mv	s3,a0
    80002a56:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a58:	00018517          	auipc	a0,0x18
    80002a5c:	57850513          	addi	a0,a0,1400 # 8001afd0 <itable>
    80002a60:	00004097          	auipc	ra,0x4
    80002a64:	d6a080e7          	jalr	-662(ra) # 800067ca <acquire>
  empty = 0;
    80002a68:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a6a:	00018497          	auipc	s1,0x18
    80002a6e:	58648493          	addi	s1,s1,1414 # 8001aff0 <itable+0x20>
    80002a72:	0001a697          	auipc	a3,0x1a
    80002a76:	19e68693          	addi	a3,a3,414 # 8001cc10 <log>
    80002a7a:	a039                	j	80002a88 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a7c:	02090b63          	beqz	s2,80002ab2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a80:	09048493          	addi	s1,s1,144
    80002a84:	02d48a63          	beq	s1,a3,80002ab8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a88:	449c                	lw	a5,8(s1)
    80002a8a:	fef059e3          	blez	a5,80002a7c <iget+0x38>
    80002a8e:	4098                	lw	a4,0(s1)
    80002a90:	ff3716e3          	bne	a4,s3,80002a7c <iget+0x38>
    80002a94:	40d8                	lw	a4,4(s1)
    80002a96:	ff4713e3          	bne	a4,s4,80002a7c <iget+0x38>
      ip->ref++;
    80002a9a:	2785                	addiw	a5,a5,1
    80002a9c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a9e:	00018517          	auipc	a0,0x18
    80002aa2:	53250513          	addi	a0,a0,1330 # 8001afd0 <itable>
    80002aa6:	00004097          	auipc	ra,0x4
    80002aaa:	df4080e7          	jalr	-524(ra) # 8000689a <release>
      return ip;
    80002aae:	8926                	mv	s2,s1
    80002ab0:	a03d                	j	80002ade <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ab2:	f7f9                	bnez	a5,80002a80 <iget+0x3c>
      empty = ip;
    80002ab4:	8926                	mv	s2,s1
    80002ab6:	b7e9                	j	80002a80 <iget+0x3c>
  if(empty == 0)
    80002ab8:	02090c63          	beqz	s2,80002af0 <iget+0xac>
  ip->dev = dev;
    80002abc:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ac0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ac4:	4785                	li	a5,1
    80002ac6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002aca:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002ace:	00018517          	auipc	a0,0x18
    80002ad2:	50250513          	addi	a0,a0,1282 # 8001afd0 <itable>
    80002ad6:	00004097          	auipc	ra,0x4
    80002ada:	dc4080e7          	jalr	-572(ra) # 8000689a <release>
}
    80002ade:	854a                	mv	a0,s2
    80002ae0:	70a2                	ld	ra,40(sp)
    80002ae2:	7402                	ld	s0,32(sp)
    80002ae4:	64e2                	ld	s1,24(sp)
    80002ae6:	6942                	ld	s2,16(sp)
    80002ae8:	69a2                	ld	s3,8(sp)
    80002aea:	6a02                	ld	s4,0(sp)
    80002aec:	6145                	addi	sp,sp,48
    80002aee:	8082                	ret
    panic("iget: no inodes");
    80002af0:	00006517          	auipc	a0,0x6
    80002af4:	92050513          	addi	a0,a0,-1760 # 80008410 <etext+0x410>
    80002af8:	00003097          	auipc	ra,0x3
    80002afc:	76e080e7          	jalr	1902(ra) # 80006266 <panic>

0000000080002b00 <fsinit>:
fsinit(int dev) {
    80002b00:	7179                	addi	sp,sp,-48
    80002b02:	f406                	sd	ra,40(sp)
    80002b04:	f022                	sd	s0,32(sp)
    80002b06:	ec26                	sd	s1,24(sp)
    80002b08:	e84a                	sd	s2,16(sp)
    80002b0a:	e44e                	sd	s3,8(sp)
    80002b0c:	1800                	addi	s0,sp,48
    80002b0e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b10:	4585                	li	a1,1
    80002b12:	00000097          	auipc	ra,0x0
    80002b16:	922080e7          	jalr	-1758(ra) # 80002434 <bread>
    80002b1a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b1c:	00018997          	auipc	s3,0x18
    80002b20:	49498993          	addi	s3,s3,1172 # 8001afb0 <sb>
    80002b24:	02000613          	li	a2,32
    80002b28:	06050593          	addi	a1,a0,96
    80002b2c:	854e                	mv	a0,s3
    80002b2e:	ffffd097          	auipc	ra,0xffffd
    80002b32:	792080e7          	jalr	1938(ra) # 800002c0 <memmove>
  brelse(bp);
    80002b36:	8526                	mv	a0,s1
    80002b38:	00000097          	auipc	ra,0x0
    80002b3c:	b46080e7          	jalr	-1210(ra) # 8000267e <brelse>
  if(sb.magic != FSMAGIC)
    80002b40:	0009a703          	lw	a4,0(s3)
    80002b44:	102037b7          	lui	a5,0x10203
    80002b48:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b4c:	02f71263          	bne	a4,a5,80002b70 <fsinit+0x70>
  initlog(dev, &sb);
    80002b50:	00018597          	auipc	a1,0x18
    80002b54:	46058593          	addi	a1,a1,1120 # 8001afb0 <sb>
    80002b58:	854a                	mv	a0,s2
    80002b5a:	00001097          	auipc	ra,0x1
    80002b5e:	b54080e7          	jalr	-1196(ra) # 800036ae <initlog>
}
    80002b62:	70a2                	ld	ra,40(sp)
    80002b64:	7402                	ld	s0,32(sp)
    80002b66:	64e2                	ld	s1,24(sp)
    80002b68:	6942                	ld	s2,16(sp)
    80002b6a:	69a2                	ld	s3,8(sp)
    80002b6c:	6145                	addi	sp,sp,48
    80002b6e:	8082                	ret
    panic("invalid file system");
    80002b70:	00006517          	auipc	a0,0x6
    80002b74:	8b050513          	addi	a0,a0,-1872 # 80008420 <etext+0x420>
    80002b78:	00003097          	auipc	ra,0x3
    80002b7c:	6ee080e7          	jalr	1774(ra) # 80006266 <panic>

0000000080002b80 <iinit>:
{
    80002b80:	7179                	addi	sp,sp,-48
    80002b82:	f406                	sd	ra,40(sp)
    80002b84:	f022                	sd	s0,32(sp)
    80002b86:	ec26                	sd	s1,24(sp)
    80002b88:	e84a                	sd	s2,16(sp)
    80002b8a:	e44e                	sd	s3,8(sp)
    80002b8c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b8e:	00006597          	auipc	a1,0x6
    80002b92:	8aa58593          	addi	a1,a1,-1878 # 80008438 <etext+0x438>
    80002b96:	00018517          	auipc	a0,0x18
    80002b9a:	43a50513          	addi	a0,a0,1082 # 8001afd0 <itable>
    80002b9e:	00004097          	auipc	ra,0x4
    80002ba2:	da8080e7          	jalr	-600(ra) # 80006946 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ba6:	00018497          	auipc	s1,0x18
    80002baa:	45a48493          	addi	s1,s1,1114 # 8001b000 <itable+0x30>
    80002bae:	0001a997          	auipc	s3,0x1a
    80002bb2:	07298993          	addi	s3,s3,114 # 8001cc20 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bb6:	00006917          	auipc	s2,0x6
    80002bba:	88a90913          	addi	s2,s2,-1910 # 80008440 <etext+0x440>
    80002bbe:	85ca                	mv	a1,s2
    80002bc0:	8526                	mv	a0,s1
    80002bc2:	00001097          	auipc	ra,0x1
    80002bc6:	e40080e7          	jalr	-448(ra) # 80003a02 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bca:	09048493          	addi	s1,s1,144
    80002bce:	ff3498e3          	bne	s1,s3,80002bbe <iinit+0x3e>
}
    80002bd2:	70a2                	ld	ra,40(sp)
    80002bd4:	7402                	ld	s0,32(sp)
    80002bd6:	64e2                	ld	s1,24(sp)
    80002bd8:	6942                	ld	s2,16(sp)
    80002bda:	69a2                	ld	s3,8(sp)
    80002bdc:	6145                	addi	sp,sp,48
    80002bde:	8082                	ret

0000000080002be0 <ialloc>:
{
    80002be0:	7139                	addi	sp,sp,-64
    80002be2:	fc06                	sd	ra,56(sp)
    80002be4:	f822                	sd	s0,48(sp)
    80002be6:	f426                	sd	s1,40(sp)
    80002be8:	f04a                	sd	s2,32(sp)
    80002bea:	ec4e                	sd	s3,24(sp)
    80002bec:	e852                	sd	s4,16(sp)
    80002bee:	e456                	sd	s5,8(sp)
    80002bf0:	e05a                	sd	s6,0(sp)
    80002bf2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bf4:	00018717          	auipc	a4,0x18
    80002bf8:	3c872703          	lw	a4,968(a4) # 8001afbc <sb+0xc>
    80002bfc:	4785                	li	a5,1
    80002bfe:	04e7f863          	bgeu	a5,a4,80002c4e <ialloc+0x6e>
    80002c02:	8aaa                	mv	s5,a0
    80002c04:	8b2e                	mv	s6,a1
    80002c06:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c08:	00018a17          	auipc	s4,0x18
    80002c0c:	3a8a0a13          	addi	s4,s4,936 # 8001afb0 <sb>
    80002c10:	00495593          	srli	a1,s2,0x4
    80002c14:	018a2783          	lw	a5,24(s4)
    80002c18:	9dbd                	addw	a1,a1,a5
    80002c1a:	8556                	mv	a0,s5
    80002c1c:	00000097          	auipc	ra,0x0
    80002c20:	818080e7          	jalr	-2024(ra) # 80002434 <bread>
    80002c24:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c26:	06050993          	addi	s3,a0,96
    80002c2a:	00f97793          	andi	a5,s2,15
    80002c2e:	079a                	slli	a5,a5,0x6
    80002c30:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c32:	00099783          	lh	a5,0(s3)
    80002c36:	c785                	beqz	a5,80002c5e <ialloc+0x7e>
    brelse(bp);
    80002c38:	00000097          	auipc	ra,0x0
    80002c3c:	a46080e7          	jalr	-1466(ra) # 8000267e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c40:	0905                	addi	s2,s2,1
    80002c42:	00ca2703          	lw	a4,12(s4)
    80002c46:	0009079b          	sext.w	a5,s2
    80002c4a:	fce7e3e3          	bltu	a5,a4,80002c10 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002c4e:	00005517          	auipc	a0,0x5
    80002c52:	7fa50513          	addi	a0,a0,2042 # 80008448 <etext+0x448>
    80002c56:	00003097          	auipc	ra,0x3
    80002c5a:	610080e7          	jalr	1552(ra) # 80006266 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c5e:	04000613          	li	a2,64
    80002c62:	4581                	li	a1,0
    80002c64:	854e                	mv	a0,s3
    80002c66:	ffffd097          	auipc	ra,0xffffd
    80002c6a:	5fe080e7          	jalr	1534(ra) # 80000264 <memset>
      dip->type = type;
    80002c6e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c72:	8526                	mv	a0,s1
    80002c74:	00001097          	auipc	ra,0x1
    80002c78:	caa080e7          	jalr	-854(ra) # 8000391e <log_write>
      brelse(bp);
    80002c7c:	8526                	mv	a0,s1
    80002c7e:	00000097          	auipc	ra,0x0
    80002c82:	a00080e7          	jalr	-1536(ra) # 8000267e <brelse>
      return iget(dev, inum);
    80002c86:	0009059b          	sext.w	a1,s2
    80002c8a:	8556                	mv	a0,s5
    80002c8c:	00000097          	auipc	ra,0x0
    80002c90:	db8080e7          	jalr	-584(ra) # 80002a44 <iget>
}
    80002c94:	70e2                	ld	ra,56(sp)
    80002c96:	7442                	ld	s0,48(sp)
    80002c98:	74a2                	ld	s1,40(sp)
    80002c9a:	7902                	ld	s2,32(sp)
    80002c9c:	69e2                	ld	s3,24(sp)
    80002c9e:	6a42                	ld	s4,16(sp)
    80002ca0:	6aa2                	ld	s5,8(sp)
    80002ca2:	6b02                	ld	s6,0(sp)
    80002ca4:	6121                	addi	sp,sp,64
    80002ca6:	8082                	ret

0000000080002ca8 <iupdate>:
{
    80002ca8:	1101                	addi	sp,sp,-32
    80002caa:	ec06                	sd	ra,24(sp)
    80002cac:	e822                	sd	s0,16(sp)
    80002cae:	e426                	sd	s1,8(sp)
    80002cb0:	e04a                	sd	s2,0(sp)
    80002cb2:	1000                	addi	s0,sp,32
    80002cb4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cb6:	415c                	lw	a5,4(a0)
    80002cb8:	0047d79b          	srliw	a5,a5,0x4
    80002cbc:	00018597          	auipc	a1,0x18
    80002cc0:	30c5a583          	lw	a1,780(a1) # 8001afc8 <sb+0x18>
    80002cc4:	9dbd                	addw	a1,a1,a5
    80002cc6:	4108                	lw	a0,0(a0)
    80002cc8:	fffff097          	auipc	ra,0xfffff
    80002ccc:	76c080e7          	jalr	1900(ra) # 80002434 <bread>
    80002cd0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cd2:	06050793          	addi	a5,a0,96
    80002cd6:	40d8                	lw	a4,4(s1)
    80002cd8:	8b3d                	andi	a4,a4,15
    80002cda:	071a                	slli	a4,a4,0x6
    80002cdc:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002cde:	04c49703          	lh	a4,76(s1)
    80002ce2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ce6:	04e49703          	lh	a4,78(s1)
    80002cea:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002cee:	05049703          	lh	a4,80(s1)
    80002cf2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cf6:	05249703          	lh	a4,82(s1)
    80002cfa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cfe:	48f8                	lw	a4,84(s1)
    80002d00:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d02:	03400613          	li	a2,52
    80002d06:	05848593          	addi	a1,s1,88
    80002d0a:	00c78513          	addi	a0,a5,12
    80002d0e:	ffffd097          	auipc	ra,0xffffd
    80002d12:	5b2080e7          	jalr	1458(ra) # 800002c0 <memmove>
  log_write(bp);
    80002d16:	854a                	mv	a0,s2
    80002d18:	00001097          	auipc	ra,0x1
    80002d1c:	c06080e7          	jalr	-1018(ra) # 8000391e <log_write>
  brelse(bp);
    80002d20:	854a                	mv	a0,s2
    80002d22:	00000097          	auipc	ra,0x0
    80002d26:	95c080e7          	jalr	-1700(ra) # 8000267e <brelse>
}
    80002d2a:	60e2                	ld	ra,24(sp)
    80002d2c:	6442                	ld	s0,16(sp)
    80002d2e:	64a2                	ld	s1,8(sp)
    80002d30:	6902                	ld	s2,0(sp)
    80002d32:	6105                	addi	sp,sp,32
    80002d34:	8082                	ret

0000000080002d36 <idup>:
{
    80002d36:	1101                	addi	sp,sp,-32
    80002d38:	ec06                	sd	ra,24(sp)
    80002d3a:	e822                	sd	s0,16(sp)
    80002d3c:	e426                	sd	s1,8(sp)
    80002d3e:	1000                	addi	s0,sp,32
    80002d40:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d42:	00018517          	auipc	a0,0x18
    80002d46:	28e50513          	addi	a0,a0,654 # 8001afd0 <itable>
    80002d4a:	00004097          	auipc	ra,0x4
    80002d4e:	a80080e7          	jalr	-1408(ra) # 800067ca <acquire>
  ip->ref++;
    80002d52:	449c                	lw	a5,8(s1)
    80002d54:	2785                	addiw	a5,a5,1
    80002d56:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d58:	00018517          	auipc	a0,0x18
    80002d5c:	27850513          	addi	a0,a0,632 # 8001afd0 <itable>
    80002d60:	00004097          	auipc	ra,0x4
    80002d64:	b3a080e7          	jalr	-1222(ra) # 8000689a <release>
}
    80002d68:	8526                	mv	a0,s1
    80002d6a:	60e2                	ld	ra,24(sp)
    80002d6c:	6442                	ld	s0,16(sp)
    80002d6e:	64a2                	ld	s1,8(sp)
    80002d70:	6105                	addi	sp,sp,32
    80002d72:	8082                	ret

0000000080002d74 <ilock>:
{
    80002d74:	1101                	addi	sp,sp,-32
    80002d76:	ec06                	sd	ra,24(sp)
    80002d78:	e822                	sd	s0,16(sp)
    80002d7a:	e426                	sd	s1,8(sp)
    80002d7c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d7e:	c10d                	beqz	a0,80002da0 <ilock+0x2c>
    80002d80:	84aa                	mv	s1,a0
    80002d82:	451c                	lw	a5,8(a0)
    80002d84:	00f05e63          	blez	a5,80002da0 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002d88:	0541                	addi	a0,a0,16
    80002d8a:	00001097          	auipc	ra,0x1
    80002d8e:	cb2080e7          	jalr	-846(ra) # 80003a3c <acquiresleep>
  if(ip->valid == 0){
    80002d92:	44bc                	lw	a5,72(s1)
    80002d94:	cf99                	beqz	a5,80002db2 <ilock+0x3e>
}
    80002d96:	60e2                	ld	ra,24(sp)
    80002d98:	6442                	ld	s0,16(sp)
    80002d9a:	64a2                	ld	s1,8(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret
    80002da0:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002da2:	00005517          	auipc	a0,0x5
    80002da6:	6be50513          	addi	a0,a0,1726 # 80008460 <etext+0x460>
    80002daa:	00003097          	auipc	ra,0x3
    80002dae:	4bc080e7          	jalr	1212(ra) # 80006266 <panic>
    80002db2:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002db4:	40dc                	lw	a5,4(s1)
    80002db6:	0047d79b          	srliw	a5,a5,0x4
    80002dba:	00018597          	auipc	a1,0x18
    80002dbe:	20e5a583          	lw	a1,526(a1) # 8001afc8 <sb+0x18>
    80002dc2:	9dbd                	addw	a1,a1,a5
    80002dc4:	4088                	lw	a0,0(s1)
    80002dc6:	fffff097          	auipc	ra,0xfffff
    80002dca:	66e080e7          	jalr	1646(ra) # 80002434 <bread>
    80002dce:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dd0:	06050593          	addi	a1,a0,96
    80002dd4:	40dc                	lw	a5,4(s1)
    80002dd6:	8bbd                	andi	a5,a5,15
    80002dd8:	079a                	slli	a5,a5,0x6
    80002dda:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ddc:	00059783          	lh	a5,0(a1)
    80002de0:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002de4:	00259783          	lh	a5,2(a1)
    80002de8:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002dec:	00459783          	lh	a5,4(a1)
    80002df0:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002df4:	00659783          	lh	a5,6(a1)
    80002df8:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002dfc:	459c                	lw	a5,8(a1)
    80002dfe:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e00:	03400613          	li	a2,52
    80002e04:	05b1                	addi	a1,a1,12
    80002e06:	05848513          	addi	a0,s1,88
    80002e0a:	ffffd097          	auipc	ra,0xffffd
    80002e0e:	4b6080e7          	jalr	1206(ra) # 800002c0 <memmove>
    brelse(bp);
    80002e12:	854a                	mv	a0,s2
    80002e14:	00000097          	auipc	ra,0x0
    80002e18:	86a080e7          	jalr	-1942(ra) # 8000267e <brelse>
    ip->valid = 1;
    80002e1c:	4785                	li	a5,1
    80002e1e:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002e20:	04c49783          	lh	a5,76(s1)
    80002e24:	c399                	beqz	a5,80002e2a <ilock+0xb6>
    80002e26:	6902                	ld	s2,0(sp)
    80002e28:	b7bd                	j	80002d96 <ilock+0x22>
      panic("ilock: no type");
    80002e2a:	00005517          	auipc	a0,0x5
    80002e2e:	63e50513          	addi	a0,a0,1598 # 80008468 <etext+0x468>
    80002e32:	00003097          	auipc	ra,0x3
    80002e36:	434080e7          	jalr	1076(ra) # 80006266 <panic>

0000000080002e3a <iunlock>:
{
    80002e3a:	1101                	addi	sp,sp,-32
    80002e3c:	ec06                	sd	ra,24(sp)
    80002e3e:	e822                	sd	s0,16(sp)
    80002e40:	e426                	sd	s1,8(sp)
    80002e42:	e04a                	sd	s2,0(sp)
    80002e44:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e46:	c905                	beqz	a0,80002e76 <iunlock+0x3c>
    80002e48:	84aa                	mv	s1,a0
    80002e4a:	01050913          	addi	s2,a0,16
    80002e4e:	854a                	mv	a0,s2
    80002e50:	00001097          	auipc	ra,0x1
    80002e54:	c86080e7          	jalr	-890(ra) # 80003ad6 <holdingsleep>
    80002e58:	cd19                	beqz	a0,80002e76 <iunlock+0x3c>
    80002e5a:	449c                	lw	a5,8(s1)
    80002e5c:	00f05d63          	blez	a5,80002e76 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e60:	854a                	mv	a0,s2
    80002e62:	00001097          	auipc	ra,0x1
    80002e66:	c30080e7          	jalr	-976(ra) # 80003a92 <releasesleep>
}
    80002e6a:	60e2                	ld	ra,24(sp)
    80002e6c:	6442                	ld	s0,16(sp)
    80002e6e:	64a2                	ld	s1,8(sp)
    80002e70:	6902                	ld	s2,0(sp)
    80002e72:	6105                	addi	sp,sp,32
    80002e74:	8082                	ret
    panic("iunlock");
    80002e76:	00005517          	auipc	a0,0x5
    80002e7a:	60250513          	addi	a0,a0,1538 # 80008478 <etext+0x478>
    80002e7e:	00003097          	auipc	ra,0x3
    80002e82:	3e8080e7          	jalr	1000(ra) # 80006266 <panic>

0000000080002e86 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e86:	7179                	addi	sp,sp,-48
    80002e88:	f406                	sd	ra,40(sp)
    80002e8a:	f022                	sd	s0,32(sp)
    80002e8c:	ec26                	sd	s1,24(sp)
    80002e8e:	e84a                	sd	s2,16(sp)
    80002e90:	e44e                	sd	s3,8(sp)
    80002e92:	1800                	addi	s0,sp,48
    80002e94:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e96:	05850493          	addi	s1,a0,88
    80002e9a:	08850913          	addi	s2,a0,136
    80002e9e:	a021                	j	80002ea6 <itrunc+0x20>
    80002ea0:	0491                	addi	s1,s1,4
    80002ea2:	01248d63          	beq	s1,s2,80002ebc <itrunc+0x36>
    if(ip->addrs[i]){
    80002ea6:	408c                	lw	a1,0(s1)
    80002ea8:	dde5                	beqz	a1,80002ea0 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002eaa:	0009a503          	lw	a0,0(s3)
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	910080e7          	jalr	-1776(ra) # 800027be <bfree>
      ip->addrs[i] = 0;
    80002eb6:	0004a023          	sw	zero,0(s1)
    80002eba:	b7dd                	j	80002ea0 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ebc:	0889a583          	lw	a1,136(s3)
    80002ec0:	ed99                	bnez	a1,80002ede <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ec2:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002ec6:	854e                	mv	a0,s3
    80002ec8:	00000097          	auipc	ra,0x0
    80002ecc:	de0080e7          	jalr	-544(ra) # 80002ca8 <iupdate>
}
    80002ed0:	70a2                	ld	ra,40(sp)
    80002ed2:	7402                	ld	s0,32(sp)
    80002ed4:	64e2                	ld	s1,24(sp)
    80002ed6:	6942                	ld	s2,16(sp)
    80002ed8:	69a2                	ld	s3,8(sp)
    80002eda:	6145                	addi	sp,sp,48
    80002edc:	8082                	ret
    80002ede:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ee0:	0009a503          	lw	a0,0(s3)
    80002ee4:	fffff097          	auipc	ra,0xfffff
    80002ee8:	550080e7          	jalr	1360(ra) # 80002434 <bread>
    80002eec:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002eee:	06050493          	addi	s1,a0,96
    80002ef2:	46050913          	addi	s2,a0,1120
    80002ef6:	a021                	j	80002efe <itrunc+0x78>
    80002ef8:	0491                	addi	s1,s1,4
    80002efa:	01248b63          	beq	s1,s2,80002f10 <itrunc+0x8a>
      if(a[j])
    80002efe:	408c                	lw	a1,0(s1)
    80002f00:	dde5                	beqz	a1,80002ef8 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002f02:	0009a503          	lw	a0,0(s3)
    80002f06:	00000097          	auipc	ra,0x0
    80002f0a:	8b8080e7          	jalr	-1864(ra) # 800027be <bfree>
    80002f0e:	b7ed                	j	80002ef8 <itrunc+0x72>
    brelse(bp);
    80002f10:	8552                	mv	a0,s4
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	76c080e7          	jalr	1900(ra) # 8000267e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f1a:	0889a583          	lw	a1,136(s3)
    80002f1e:	0009a503          	lw	a0,0(s3)
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	89c080e7          	jalr	-1892(ra) # 800027be <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f2a:	0809a423          	sw	zero,136(s3)
    80002f2e:	6a02                	ld	s4,0(sp)
    80002f30:	bf49                	j	80002ec2 <itrunc+0x3c>

0000000080002f32 <iput>:
{
    80002f32:	1101                	addi	sp,sp,-32
    80002f34:	ec06                	sd	ra,24(sp)
    80002f36:	e822                	sd	s0,16(sp)
    80002f38:	e426                	sd	s1,8(sp)
    80002f3a:	1000                	addi	s0,sp,32
    80002f3c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f3e:	00018517          	auipc	a0,0x18
    80002f42:	09250513          	addi	a0,a0,146 # 8001afd0 <itable>
    80002f46:	00004097          	auipc	ra,0x4
    80002f4a:	884080e7          	jalr	-1916(ra) # 800067ca <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f4e:	4498                	lw	a4,8(s1)
    80002f50:	4785                	li	a5,1
    80002f52:	02f70263          	beq	a4,a5,80002f76 <iput+0x44>
  ip->ref--;
    80002f56:	449c                	lw	a5,8(s1)
    80002f58:	37fd                	addiw	a5,a5,-1
    80002f5a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f5c:	00018517          	auipc	a0,0x18
    80002f60:	07450513          	addi	a0,a0,116 # 8001afd0 <itable>
    80002f64:	00004097          	auipc	ra,0x4
    80002f68:	936080e7          	jalr	-1738(ra) # 8000689a <release>
}
    80002f6c:	60e2                	ld	ra,24(sp)
    80002f6e:	6442                	ld	s0,16(sp)
    80002f70:	64a2                	ld	s1,8(sp)
    80002f72:	6105                	addi	sp,sp,32
    80002f74:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f76:	44bc                	lw	a5,72(s1)
    80002f78:	dff9                	beqz	a5,80002f56 <iput+0x24>
    80002f7a:	05249783          	lh	a5,82(s1)
    80002f7e:	ffe1                	bnez	a5,80002f56 <iput+0x24>
    80002f80:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002f82:	01048913          	addi	s2,s1,16
    80002f86:	854a                	mv	a0,s2
    80002f88:	00001097          	auipc	ra,0x1
    80002f8c:	ab4080e7          	jalr	-1356(ra) # 80003a3c <acquiresleep>
    release(&itable.lock);
    80002f90:	00018517          	auipc	a0,0x18
    80002f94:	04050513          	addi	a0,a0,64 # 8001afd0 <itable>
    80002f98:	00004097          	auipc	ra,0x4
    80002f9c:	902080e7          	jalr	-1790(ra) # 8000689a <release>
    itrunc(ip);
    80002fa0:	8526                	mv	a0,s1
    80002fa2:	00000097          	auipc	ra,0x0
    80002fa6:	ee4080e7          	jalr	-284(ra) # 80002e86 <itrunc>
    ip->type = 0;
    80002faa:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80002fae:	8526                	mv	a0,s1
    80002fb0:	00000097          	auipc	ra,0x0
    80002fb4:	cf8080e7          	jalr	-776(ra) # 80002ca8 <iupdate>
    ip->valid = 0;
    80002fb8:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80002fbc:	854a                	mv	a0,s2
    80002fbe:	00001097          	auipc	ra,0x1
    80002fc2:	ad4080e7          	jalr	-1324(ra) # 80003a92 <releasesleep>
    acquire(&itable.lock);
    80002fc6:	00018517          	auipc	a0,0x18
    80002fca:	00a50513          	addi	a0,a0,10 # 8001afd0 <itable>
    80002fce:	00003097          	auipc	ra,0x3
    80002fd2:	7fc080e7          	jalr	2044(ra) # 800067ca <acquire>
    80002fd6:	6902                	ld	s2,0(sp)
    80002fd8:	bfbd                	j	80002f56 <iput+0x24>

0000000080002fda <iunlockput>:
{
    80002fda:	1101                	addi	sp,sp,-32
    80002fdc:	ec06                	sd	ra,24(sp)
    80002fde:	e822                	sd	s0,16(sp)
    80002fe0:	e426                	sd	s1,8(sp)
    80002fe2:	1000                	addi	s0,sp,32
    80002fe4:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fe6:	00000097          	auipc	ra,0x0
    80002fea:	e54080e7          	jalr	-428(ra) # 80002e3a <iunlock>
  iput(ip);
    80002fee:	8526                	mv	a0,s1
    80002ff0:	00000097          	auipc	ra,0x0
    80002ff4:	f42080e7          	jalr	-190(ra) # 80002f32 <iput>
}
    80002ff8:	60e2                	ld	ra,24(sp)
    80002ffa:	6442                	ld	s0,16(sp)
    80002ffc:	64a2                	ld	s1,8(sp)
    80002ffe:	6105                	addi	sp,sp,32
    80003000:	8082                	ret

0000000080003002 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003002:	1141                	addi	sp,sp,-16
    80003004:	e422                	sd	s0,8(sp)
    80003006:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003008:	411c                	lw	a5,0(a0)
    8000300a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000300c:	415c                	lw	a5,4(a0)
    8000300e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003010:	04c51783          	lh	a5,76(a0)
    80003014:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003018:	05251783          	lh	a5,82(a0)
    8000301c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003020:	05456783          	lwu	a5,84(a0)
    80003024:	e99c                	sd	a5,16(a1)
}
    80003026:	6422                	ld	s0,8(sp)
    80003028:	0141                	addi	sp,sp,16
    8000302a:	8082                	ret

000000008000302c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000302c:	497c                	lw	a5,84(a0)
    8000302e:	0ed7ef63          	bltu	a5,a3,8000312c <readi+0x100>
{
    80003032:	7159                	addi	sp,sp,-112
    80003034:	f486                	sd	ra,104(sp)
    80003036:	f0a2                	sd	s0,96(sp)
    80003038:	eca6                	sd	s1,88(sp)
    8000303a:	fc56                	sd	s5,56(sp)
    8000303c:	f85a                	sd	s6,48(sp)
    8000303e:	f45e                	sd	s7,40(sp)
    80003040:	f062                	sd	s8,32(sp)
    80003042:	1880                	addi	s0,sp,112
    80003044:	8baa                	mv	s7,a0
    80003046:	8c2e                	mv	s8,a1
    80003048:	8ab2                	mv	s5,a2
    8000304a:	84b6                	mv	s1,a3
    8000304c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000304e:	9f35                	addw	a4,a4,a3
    return 0;
    80003050:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003052:	0ad76c63          	bltu	a4,a3,8000310a <readi+0xde>
    80003056:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003058:	00e7f463          	bgeu	a5,a4,80003060 <readi+0x34>
    n = ip->size - off;
    8000305c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003060:	0c0b0463          	beqz	s6,80003128 <readi+0xfc>
    80003064:	e8ca                	sd	s2,80(sp)
    80003066:	e0d2                	sd	s4,64(sp)
    80003068:	ec66                	sd	s9,24(sp)
    8000306a:	e86a                	sd	s10,16(sp)
    8000306c:	e46e                	sd	s11,8(sp)
    8000306e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003070:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003074:	5cfd                	li	s9,-1
    80003076:	a82d                	j	800030b0 <readi+0x84>
    80003078:	020a1d93          	slli	s11,s4,0x20
    8000307c:	020ddd93          	srli	s11,s11,0x20
    80003080:	06090613          	addi	a2,s2,96
    80003084:	86ee                	mv	a3,s11
    80003086:	963a                	add	a2,a2,a4
    80003088:	85d6                	mv	a1,s5
    8000308a:	8562                	mv	a0,s8
    8000308c:	fffff097          	auipc	ra,0xfffff
    80003090:	954080e7          	jalr	-1708(ra) # 800019e0 <either_copyout>
    80003094:	05950d63          	beq	a0,s9,800030ee <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003098:	854a                	mv	a0,s2
    8000309a:	fffff097          	auipc	ra,0xfffff
    8000309e:	5e4080e7          	jalr	1508(ra) # 8000267e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030a2:	013a09bb          	addw	s3,s4,s3
    800030a6:	009a04bb          	addw	s1,s4,s1
    800030aa:	9aee                	add	s5,s5,s11
    800030ac:	0769f863          	bgeu	s3,s6,8000311c <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030b0:	000ba903          	lw	s2,0(s7)
    800030b4:	00a4d59b          	srliw	a1,s1,0xa
    800030b8:	855e                	mv	a0,s7
    800030ba:	00000097          	auipc	ra,0x0
    800030be:	8ae080e7          	jalr	-1874(ra) # 80002968 <bmap>
    800030c2:	0005059b          	sext.w	a1,a0
    800030c6:	854a                	mv	a0,s2
    800030c8:	fffff097          	auipc	ra,0xfffff
    800030cc:	36c080e7          	jalr	876(ra) # 80002434 <bread>
    800030d0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030d2:	3ff4f713          	andi	a4,s1,1023
    800030d6:	40ed07bb          	subw	a5,s10,a4
    800030da:	413b06bb          	subw	a3,s6,s3
    800030de:	8a3e                	mv	s4,a5
    800030e0:	2781                	sext.w	a5,a5
    800030e2:	0006861b          	sext.w	a2,a3
    800030e6:	f8f679e3          	bgeu	a2,a5,80003078 <readi+0x4c>
    800030ea:	8a36                	mv	s4,a3
    800030ec:	b771                	j	80003078 <readi+0x4c>
      brelse(bp);
    800030ee:	854a                	mv	a0,s2
    800030f0:	fffff097          	auipc	ra,0xfffff
    800030f4:	58e080e7          	jalr	1422(ra) # 8000267e <brelse>
      tot = -1;
    800030f8:	59fd                	li	s3,-1
      break;
    800030fa:	6946                	ld	s2,80(sp)
    800030fc:	6a06                	ld	s4,64(sp)
    800030fe:	6ce2                	ld	s9,24(sp)
    80003100:	6d42                	ld	s10,16(sp)
    80003102:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003104:	0009851b          	sext.w	a0,s3
    80003108:	69a6                	ld	s3,72(sp)
}
    8000310a:	70a6                	ld	ra,104(sp)
    8000310c:	7406                	ld	s0,96(sp)
    8000310e:	64e6                	ld	s1,88(sp)
    80003110:	7ae2                	ld	s5,56(sp)
    80003112:	7b42                	ld	s6,48(sp)
    80003114:	7ba2                	ld	s7,40(sp)
    80003116:	7c02                	ld	s8,32(sp)
    80003118:	6165                	addi	sp,sp,112
    8000311a:	8082                	ret
    8000311c:	6946                	ld	s2,80(sp)
    8000311e:	6a06                	ld	s4,64(sp)
    80003120:	6ce2                	ld	s9,24(sp)
    80003122:	6d42                	ld	s10,16(sp)
    80003124:	6da2                	ld	s11,8(sp)
    80003126:	bff9                	j	80003104 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003128:	89da                	mv	s3,s6
    8000312a:	bfe9                	j	80003104 <readi+0xd8>
    return 0;
    8000312c:	4501                	li	a0,0
}
    8000312e:	8082                	ret

0000000080003130 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003130:	497c                	lw	a5,84(a0)
    80003132:	10d7ee63          	bltu	a5,a3,8000324e <writei+0x11e>
{
    80003136:	7159                	addi	sp,sp,-112
    80003138:	f486                	sd	ra,104(sp)
    8000313a:	f0a2                	sd	s0,96(sp)
    8000313c:	e8ca                	sd	s2,80(sp)
    8000313e:	fc56                	sd	s5,56(sp)
    80003140:	f85a                	sd	s6,48(sp)
    80003142:	f45e                	sd	s7,40(sp)
    80003144:	f062                	sd	s8,32(sp)
    80003146:	1880                	addi	s0,sp,112
    80003148:	8b2a                	mv	s6,a0
    8000314a:	8c2e                	mv	s8,a1
    8000314c:	8ab2                	mv	s5,a2
    8000314e:	8936                	mv	s2,a3
    80003150:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003152:	00e687bb          	addw	a5,a3,a4
    80003156:	0ed7ee63          	bltu	a5,a3,80003252 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000315a:	00043737          	lui	a4,0x43
    8000315e:	0ef76c63          	bltu	a4,a5,80003256 <writei+0x126>
    80003162:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003164:	0c0b8d63          	beqz	s7,8000323e <writei+0x10e>
    80003168:	eca6                	sd	s1,88(sp)
    8000316a:	e4ce                	sd	s3,72(sp)
    8000316c:	ec66                	sd	s9,24(sp)
    8000316e:	e86a                	sd	s10,16(sp)
    80003170:	e46e                	sd	s11,8(sp)
    80003172:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003174:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003178:	5cfd                	li	s9,-1
    8000317a:	a091                	j	800031be <writei+0x8e>
    8000317c:	02099d93          	slli	s11,s3,0x20
    80003180:	020ddd93          	srli	s11,s11,0x20
    80003184:	06048513          	addi	a0,s1,96
    80003188:	86ee                	mv	a3,s11
    8000318a:	8656                	mv	a2,s5
    8000318c:	85e2                	mv	a1,s8
    8000318e:	953a                	add	a0,a0,a4
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	8a6080e7          	jalr	-1882(ra) # 80001a36 <either_copyin>
    80003198:	07950263          	beq	a0,s9,800031fc <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000319c:	8526                	mv	a0,s1
    8000319e:	00000097          	auipc	ra,0x0
    800031a2:	780080e7          	jalr	1920(ra) # 8000391e <log_write>
    brelse(bp);
    800031a6:	8526                	mv	a0,s1
    800031a8:	fffff097          	auipc	ra,0xfffff
    800031ac:	4d6080e7          	jalr	1238(ra) # 8000267e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031b0:	01498a3b          	addw	s4,s3,s4
    800031b4:	0129893b          	addw	s2,s3,s2
    800031b8:	9aee                	add	s5,s5,s11
    800031ba:	057a7663          	bgeu	s4,s7,80003206 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031be:	000b2483          	lw	s1,0(s6)
    800031c2:	00a9559b          	srliw	a1,s2,0xa
    800031c6:	855a                	mv	a0,s6
    800031c8:	fffff097          	auipc	ra,0xfffff
    800031cc:	7a0080e7          	jalr	1952(ra) # 80002968 <bmap>
    800031d0:	0005059b          	sext.w	a1,a0
    800031d4:	8526                	mv	a0,s1
    800031d6:	fffff097          	auipc	ra,0xfffff
    800031da:	25e080e7          	jalr	606(ra) # 80002434 <bread>
    800031de:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031e0:	3ff97713          	andi	a4,s2,1023
    800031e4:	40ed07bb          	subw	a5,s10,a4
    800031e8:	414b86bb          	subw	a3,s7,s4
    800031ec:	89be                	mv	s3,a5
    800031ee:	2781                	sext.w	a5,a5
    800031f0:	0006861b          	sext.w	a2,a3
    800031f4:	f8f674e3          	bgeu	a2,a5,8000317c <writei+0x4c>
    800031f8:	89b6                	mv	s3,a3
    800031fa:	b749                	j	8000317c <writei+0x4c>
      brelse(bp);
    800031fc:	8526                	mv	a0,s1
    800031fe:	fffff097          	auipc	ra,0xfffff
    80003202:	480080e7          	jalr	1152(ra) # 8000267e <brelse>
  }

  if(off > ip->size)
    80003206:	054b2783          	lw	a5,84(s6)
    8000320a:	0327fc63          	bgeu	a5,s2,80003242 <writei+0x112>
    ip->size = off;
    8000320e:	052b2a23          	sw	s2,84(s6)
    80003212:	64e6                	ld	s1,88(sp)
    80003214:	69a6                	ld	s3,72(sp)
    80003216:	6ce2                	ld	s9,24(sp)
    80003218:	6d42                	ld	s10,16(sp)
    8000321a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000321c:	855a                	mv	a0,s6
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	a8a080e7          	jalr	-1398(ra) # 80002ca8 <iupdate>

  return tot;
    80003226:	000a051b          	sext.w	a0,s4
    8000322a:	6a06                	ld	s4,64(sp)
}
    8000322c:	70a6                	ld	ra,104(sp)
    8000322e:	7406                	ld	s0,96(sp)
    80003230:	6946                	ld	s2,80(sp)
    80003232:	7ae2                	ld	s5,56(sp)
    80003234:	7b42                	ld	s6,48(sp)
    80003236:	7ba2                	ld	s7,40(sp)
    80003238:	7c02                	ld	s8,32(sp)
    8000323a:	6165                	addi	sp,sp,112
    8000323c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000323e:	8a5e                	mv	s4,s7
    80003240:	bff1                	j	8000321c <writei+0xec>
    80003242:	64e6                	ld	s1,88(sp)
    80003244:	69a6                	ld	s3,72(sp)
    80003246:	6ce2                	ld	s9,24(sp)
    80003248:	6d42                	ld	s10,16(sp)
    8000324a:	6da2                	ld	s11,8(sp)
    8000324c:	bfc1                	j	8000321c <writei+0xec>
    return -1;
    8000324e:	557d                	li	a0,-1
}
    80003250:	8082                	ret
    return -1;
    80003252:	557d                	li	a0,-1
    80003254:	bfe1                	j	8000322c <writei+0xfc>
    return -1;
    80003256:	557d                	li	a0,-1
    80003258:	bfd1                	j	8000322c <writei+0xfc>

000000008000325a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000325a:	1141                	addi	sp,sp,-16
    8000325c:	e406                	sd	ra,8(sp)
    8000325e:	e022                	sd	s0,0(sp)
    80003260:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003262:	4639                	li	a2,14
    80003264:	ffffd097          	auipc	ra,0xffffd
    80003268:	0d0080e7          	jalr	208(ra) # 80000334 <strncmp>
}
    8000326c:	60a2                	ld	ra,8(sp)
    8000326e:	6402                	ld	s0,0(sp)
    80003270:	0141                	addi	sp,sp,16
    80003272:	8082                	ret

0000000080003274 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003274:	7139                	addi	sp,sp,-64
    80003276:	fc06                	sd	ra,56(sp)
    80003278:	f822                	sd	s0,48(sp)
    8000327a:	f426                	sd	s1,40(sp)
    8000327c:	f04a                	sd	s2,32(sp)
    8000327e:	ec4e                	sd	s3,24(sp)
    80003280:	e852                	sd	s4,16(sp)
    80003282:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003284:	04c51703          	lh	a4,76(a0)
    80003288:	4785                	li	a5,1
    8000328a:	00f71a63          	bne	a4,a5,8000329e <dirlookup+0x2a>
    8000328e:	892a                	mv	s2,a0
    80003290:	89ae                	mv	s3,a1
    80003292:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003294:	497c                	lw	a5,84(a0)
    80003296:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003298:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000329a:	e79d                	bnez	a5,800032c8 <dirlookup+0x54>
    8000329c:	a8a5                	j	80003314 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000329e:	00005517          	auipc	a0,0x5
    800032a2:	1e250513          	addi	a0,a0,482 # 80008480 <etext+0x480>
    800032a6:	00003097          	auipc	ra,0x3
    800032aa:	fc0080e7          	jalr	-64(ra) # 80006266 <panic>
      panic("dirlookup read");
    800032ae:	00005517          	auipc	a0,0x5
    800032b2:	1ea50513          	addi	a0,a0,490 # 80008498 <etext+0x498>
    800032b6:	00003097          	auipc	ra,0x3
    800032ba:	fb0080e7          	jalr	-80(ra) # 80006266 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032be:	24c1                	addiw	s1,s1,16
    800032c0:	05492783          	lw	a5,84(s2)
    800032c4:	04f4f763          	bgeu	s1,a5,80003312 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c8:	4741                	li	a4,16
    800032ca:	86a6                	mv	a3,s1
    800032cc:	fc040613          	addi	a2,s0,-64
    800032d0:	4581                	li	a1,0
    800032d2:	854a                	mv	a0,s2
    800032d4:	00000097          	auipc	ra,0x0
    800032d8:	d58080e7          	jalr	-680(ra) # 8000302c <readi>
    800032dc:	47c1                	li	a5,16
    800032de:	fcf518e3          	bne	a0,a5,800032ae <dirlookup+0x3a>
    if(de.inum == 0)
    800032e2:	fc045783          	lhu	a5,-64(s0)
    800032e6:	dfe1                	beqz	a5,800032be <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032e8:	fc240593          	addi	a1,s0,-62
    800032ec:	854e                	mv	a0,s3
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	f6c080e7          	jalr	-148(ra) # 8000325a <namecmp>
    800032f6:	f561                	bnez	a0,800032be <dirlookup+0x4a>
      if(poff)
    800032f8:	000a0463          	beqz	s4,80003300 <dirlookup+0x8c>
        *poff = off;
    800032fc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003300:	fc045583          	lhu	a1,-64(s0)
    80003304:	00092503          	lw	a0,0(s2)
    80003308:	fffff097          	auipc	ra,0xfffff
    8000330c:	73c080e7          	jalr	1852(ra) # 80002a44 <iget>
    80003310:	a011                	j	80003314 <dirlookup+0xa0>
  return 0;
    80003312:	4501                	li	a0,0
}
    80003314:	70e2                	ld	ra,56(sp)
    80003316:	7442                	ld	s0,48(sp)
    80003318:	74a2                	ld	s1,40(sp)
    8000331a:	7902                	ld	s2,32(sp)
    8000331c:	69e2                	ld	s3,24(sp)
    8000331e:	6a42                	ld	s4,16(sp)
    80003320:	6121                	addi	sp,sp,64
    80003322:	8082                	ret

0000000080003324 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003324:	711d                	addi	sp,sp,-96
    80003326:	ec86                	sd	ra,88(sp)
    80003328:	e8a2                	sd	s0,80(sp)
    8000332a:	e4a6                	sd	s1,72(sp)
    8000332c:	e0ca                	sd	s2,64(sp)
    8000332e:	fc4e                	sd	s3,56(sp)
    80003330:	f852                	sd	s4,48(sp)
    80003332:	f456                	sd	s5,40(sp)
    80003334:	f05a                	sd	s6,32(sp)
    80003336:	ec5e                	sd	s7,24(sp)
    80003338:	e862                	sd	s8,16(sp)
    8000333a:	e466                	sd	s9,8(sp)
    8000333c:	1080                	addi	s0,sp,96
    8000333e:	84aa                	mv	s1,a0
    80003340:	8b2e                	mv	s6,a1
    80003342:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003344:	00054703          	lbu	a4,0(a0)
    80003348:	02f00793          	li	a5,47
    8000334c:	02f70263          	beq	a4,a5,80003370 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003350:	ffffe097          	auipc	ra,0xffffe
    80003354:	c26080e7          	jalr	-986(ra) # 80000f76 <myproc>
    80003358:	15853503          	ld	a0,344(a0)
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	9da080e7          	jalr	-1574(ra) # 80002d36 <idup>
    80003364:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003366:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000336a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000336c:	4b85                	li	s7,1
    8000336e:	a875                	j	8000342a <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003370:	4585                	li	a1,1
    80003372:	4505                	li	a0,1
    80003374:	fffff097          	auipc	ra,0xfffff
    80003378:	6d0080e7          	jalr	1744(ra) # 80002a44 <iget>
    8000337c:	8a2a                	mv	s4,a0
    8000337e:	b7e5                	j	80003366 <namex+0x42>
      iunlockput(ip);
    80003380:	8552                	mv	a0,s4
    80003382:	00000097          	auipc	ra,0x0
    80003386:	c58080e7          	jalr	-936(ra) # 80002fda <iunlockput>
      return 0;
    8000338a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000338c:	8552                	mv	a0,s4
    8000338e:	60e6                	ld	ra,88(sp)
    80003390:	6446                	ld	s0,80(sp)
    80003392:	64a6                	ld	s1,72(sp)
    80003394:	6906                	ld	s2,64(sp)
    80003396:	79e2                	ld	s3,56(sp)
    80003398:	7a42                	ld	s4,48(sp)
    8000339a:	7aa2                	ld	s5,40(sp)
    8000339c:	7b02                	ld	s6,32(sp)
    8000339e:	6be2                	ld	s7,24(sp)
    800033a0:	6c42                	ld	s8,16(sp)
    800033a2:	6ca2                	ld	s9,8(sp)
    800033a4:	6125                	addi	sp,sp,96
    800033a6:	8082                	ret
      iunlock(ip);
    800033a8:	8552                	mv	a0,s4
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	a90080e7          	jalr	-1392(ra) # 80002e3a <iunlock>
      return ip;
    800033b2:	bfe9                	j	8000338c <namex+0x68>
      iunlockput(ip);
    800033b4:	8552                	mv	a0,s4
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	c24080e7          	jalr	-988(ra) # 80002fda <iunlockput>
      return 0;
    800033be:	8a4e                	mv	s4,s3
    800033c0:	b7f1                	j	8000338c <namex+0x68>
  len = path - s;
    800033c2:	40998633          	sub	a2,s3,s1
    800033c6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800033ca:	099c5863          	bge	s8,s9,8000345a <namex+0x136>
    memmove(name, s, DIRSIZ);
    800033ce:	4639                	li	a2,14
    800033d0:	85a6                	mv	a1,s1
    800033d2:	8556                	mv	a0,s5
    800033d4:	ffffd097          	auipc	ra,0xffffd
    800033d8:	eec080e7          	jalr	-276(ra) # 800002c0 <memmove>
    800033dc:	84ce                	mv	s1,s3
  while(*path == '/')
    800033de:	0004c783          	lbu	a5,0(s1)
    800033e2:	01279763          	bne	a5,s2,800033f0 <namex+0xcc>
    path++;
    800033e6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033e8:	0004c783          	lbu	a5,0(s1)
    800033ec:	ff278de3          	beq	a5,s2,800033e6 <namex+0xc2>
    ilock(ip);
    800033f0:	8552                	mv	a0,s4
    800033f2:	00000097          	auipc	ra,0x0
    800033f6:	982080e7          	jalr	-1662(ra) # 80002d74 <ilock>
    if(ip->type != T_DIR){
    800033fa:	04ca1783          	lh	a5,76(s4)
    800033fe:	f97791e3          	bne	a5,s7,80003380 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003402:	000b0563          	beqz	s6,8000340c <namex+0xe8>
    80003406:	0004c783          	lbu	a5,0(s1)
    8000340a:	dfd9                	beqz	a5,800033a8 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000340c:	4601                	li	a2,0
    8000340e:	85d6                	mv	a1,s5
    80003410:	8552                	mv	a0,s4
    80003412:	00000097          	auipc	ra,0x0
    80003416:	e62080e7          	jalr	-414(ra) # 80003274 <dirlookup>
    8000341a:	89aa                	mv	s3,a0
    8000341c:	dd41                	beqz	a0,800033b4 <namex+0x90>
    iunlockput(ip);
    8000341e:	8552                	mv	a0,s4
    80003420:	00000097          	auipc	ra,0x0
    80003424:	bba080e7          	jalr	-1094(ra) # 80002fda <iunlockput>
    ip = next;
    80003428:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000342a:	0004c783          	lbu	a5,0(s1)
    8000342e:	01279763          	bne	a5,s2,8000343c <namex+0x118>
    path++;
    80003432:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003434:	0004c783          	lbu	a5,0(s1)
    80003438:	ff278de3          	beq	a5,s2,80003432 <namex+0x10e>
  if(*path == 0)
    8000343c:	cb9d                	beqz	a5,80003472 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000343e:	0004c783          	lbu	a5,0(s1)
    80003442:	89a6                	mv	s3,s1
  len = path - s;
    80003444:	4c81                	li	s9,0
    80003446:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003448:	01278963          	beq	a5,s2,8000345a <namex+0x136>
    8000344c:	dbbd                	beqz	a5,800033c2 <namex+0x9e>
    path++;
    8000344e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003450:	0009c783          	lbu	a5,0(s3)
    80003454:	ff279ce3          	bne	a5,s2,8000344c <namex+0x128>
    80003458:	b7ad                	j	800033c2 <namex+0x9e>
    memmove(name, s, len);
    8000345a:	2601                	sext.w	a2,a2
    8000345c:	85a6                	mv	a1,s1
    8000345e:	8556                	mv	a0,s5
    80003460:	ffffd097          	auipc	ra,0xffffd
    80003464:	e60080e7          	jalr	-416(ra) # 800002c0 <memmove>
    name[len] = 0;
    80003468:	9cd6                	add	s9,s9,s5
    8000346a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000346e:	84ce                	mv	s1,s3
    80003470:	b7bd                	j	800033de <namex+0xba>
  if(nameiparent){
    80003472:	f00b0de3          	beqz	s6,8000338c <namex+0x68>
    iput(ip);
    80003476:	8552                	mv	a0,s4
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	aba080e7          	jalr	-1350(ra) # 80002f32 <iput>
    return 0;
    80003480:	4a01                	li	s4,0
    80003482:	b729                	j	8000338c <namex+0x68>

0000000080003484 <dirlink>:
{
    80003484:	7139                	addi	sp,sp,-64
    80003486:	fc06                	sd	ra,56(sp)
    80003488:	f822                	sd	s0,48(sp)
    8000348a:	f04a                	sd	s2,32(sp)
    8000348c:	ec4e                	sd	s3,24(sp)
    8000348e:	e852                	sd	s4,16(sp)
    80003490:	0080                	addi	s0,sp,64
    80003492:	892a                	mv	s2,a0
    80003494:	8a2e                	mv	s4,a1
    80003496:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003498:	4601                	li	a2,0
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	dda080e7          	jalr	-550(ra) # 80003274 <dirlookup>
    800034a2:	ed25                	bnez	a0,8000351a <dirlink+0x96>
    800034a4:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034a6:	05492483          	lw	s1,84(s2)
    800034aa:	c49d                	beqz	s1,800034d8 <dirlink+0x54>
    800034ac:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034ae:	4741                	li	a4,16
    800034b0:	86a6                	mv	a3,s1
    800034b2:	fc040613          	addi	a2,s0,-64
    800034b6:	4581                	li	a1,0
    800034b8:	854a                	mv	a0,s2
    800034ba:	00000097          	auipc	ra,0x0
    800034be:	b72080e7          	jalr	-1166(ra) # 8000302c <readi>
    800034c2:	47c1                	li	a5,16
    800034c4:	06f51163          	bne	a0,a5,80003526 <dirlink+0xa2>
    if(de.inum == 0)
    800034c8:	fc045783          	lhu	a5,-64(s0)
    800034cc:	c791                	beqz	a5,800034d8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034ce:	24c1                	addiw	s1,s1,16
    800034d0:	05492783          	lw	a5,84(s2)
    800034d4:	fcf4ede3          	bltu	s1,a5,800034ae <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034d8:	4639                	li	a2,14
    800034da:	85d2                	mv	a1,s4
    800034dc:	fc240513          	addi	a0,s0,-62
    800034e0:	ffffd097          	auipc	ra,0xffffd
    800034e4:	e8a080e7          	jalr	-374(ra) # 8000036a <strncpy>
  de.inum = inum;
    800034e8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034ec:	4741                	li	a4,16
    800034ee:	86a6                	mv	a3,s1
    800034f0:	fc040613          	addi	a2,s0,-64
    800034f4:	4581                	li	a1,0
    800034f6:	854a                	mv	a0,s2
    800034f8:	00000097          	auipc	ra,0x0
    800034fc:	c38080e7          	jalr	-968(ra) # 80003130 <writei>
    80003500:	872a                	mv	a4,a0
    80003502:	47c1                	li	a5,16
  return 0;
    80003504:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003506:	02f71863          	bne	a4,a5,80003536 <dirlink+0xb2>
    8000350a:	74a2                	ld	s1,40(sp)
}
    8000350c:	70e2                	ld	ra,56(sp)
    8000350e:	7442                	ld	s0,48(sp)
    80003510:	7902                	ld	s2,32(sp)
    80003512:	69e2                	ld	s3,24(sp)
    80003514:	6a42                	ld	s4,16(sp)
    80003516:	6121                	addi	sp,sp,64
    80003518:	8082                	ret
    iput(ip);
    8000351a:	00000097          	auipc	ra,0x0
    8000351e:	a18080e7          	jalr	-1512(ra) # 80002f32 <iput>
    return -1;
    80003522:	557d                	li	a0,-1
    80003524:	b7e5                	j	8000350c <dirlink+0x88>
      panic("dirlink read");
    80003526:	00005517          	auipc	a0,0x5
    8000352a:	f8250513          	addi	a0,a0,-126 # 800084a8 <etext+0x4a8>
    8000352e:	00003097          	auipc	ra,0x3
    80003532:	d38080e7          	jalr	-712(ra) # 80006266 <panic>
    panic("dirlink");
    80003536:	00005517          	auipc	a0,0x5
    8000353a:	08250513          	addi	a0,a0,130 # 800085b8 <etext+0x5b8>
    8000353e:	00003097          	auipc	ra,0x3
    80003542:	d28080e7          	jalr	-728(ra) # 80006266 <panic>

0000000080003546 <namei>:

struct inode*
namei(char *path)
{
    80003546:	1101                	addi	sp,sp,-32
    80003548:	ec06                	sd	ra,24(sp)
    8000354a:	e822                	sd	s0,16(sp)
    8000354c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000354e:	fe040613          	addi	a2,s0,-32
    80003552:	4581                	li	a1,0
    80003554:	00000097          	auipc	ra,0x0
    80003558:	dd0080e7          	jalr	-560(ra) # 80003324 <namex>
}
    8000355c:	60e2                	ld	ra,24(sp)
    8000355e:	6442                	ld	s0,16(sp)
    80003560:	6105                	addi	sp,sp,32
    80003562:	8082                	ret

0000000080003564 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003564:	1141                	addi	sp,sp,-16
    80003566:	e406                	sd	ra,8(sp)
    80003568:	e022                	sd	s0,0(sp)
    8000356a:	0800                	addi	s0,sp,16
    8000356c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000356e:	4585                	li	a1,1
    80003570:	00000097          	auipc	ra,0x0
    80003574:	db4080e7          	jalr	-588(ra) # 80003324 <namex>
}
    80003578:	60a2                	ld	ra,8(sp)
    8000357a:	6402                	ld	s0,0(sp)
    8000357c:	0141                	addi	sp,sp,16
    8000357e:	8082                	ret

0000000080003580 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003580:	1101                	addi	sp,sp,-32
    80003582:	ec06                	sd	ra,24(sp)
    80003584:	e822                	sd	s0,16(sp)
    80003586:	e426                	sd	s1,8(sp)
    80003588:	e04a                	sd	s2,0(sp)
    8000358a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000358c:	00019917          	auipc	s2,0x19
    80003590:	68490913          	addi	s2,s2,1668 # 8001cc10 <log>
    80003594:	02092583          	lw	a1,32(s2)
    80003598:	03092503          	lw	a0,48(s2)
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	e98080e7          	jalr	-360(ra) # 80002434 <bread>
    800035a4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035a6:	03492603          	lw	a2,52(s2)
    800035aa:	d130                	sw	a2,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035ac:	00c05f63          	blez	a2,800035ca <write_head+0x4a>
    800035b0:	00019717          	auipc	a4,0x19
    800035b4:	69870713          	addi	a4,a4,1688 # 8001cc48 <log+0x38>
    800035b8:	87aa                	mv	a5,a0
    800035ba:	060a                	slli	a2,a2,0x2
    800035bc:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800035be:	4314                	lw	a3,0(a4)
    800035c0:	d3f4                	sw	a3,100(a5)
  for (i = 0; i < log.lh.n; i++) {
    800035c2:	0711                	addi	a4,a4,4
    800035c4:	0791                	addi	a5,a5,4
    800035c6:	fec79ce3          	bne	a5,a2,800035be <write_head+0x3e>
  }
  bwrite(buf);
    800035ca:	8526                	mv	a0,s1
    800035cc:	fffff097          	auipc	ra,0xfffff
    800035d0:	074080e7          	jalr	116(ra) # 80002640 <bwrite>
  brelse(buf);
    800035d4:	8526                	mv	a0,s1
    800035d6:	fffff097          	auipc	ra,0xfffff
    800035da:	0a8080e7          	jalr	168(ra) # 8000267e <brelse>
}
    800035de:	60e2                	ld	ra,24(sp)
    800035e0:	6442                	ld	s0,16(sp)
    800035e2:	64a2                	ld	s1,8(sp)
    800035e4:	6902                	ld	s2,0(sp)
    800035e6:	6105                	addi	sp,sp,32
    800035e8:	8082                	ret

00000000800035ea <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ea:	00019797          	auipc	a5,0x19
    800035ee:	65a7a783          	lw	a5,1626(a5) # 8001cc44 <log+0x34>
    800035f2:	0af05d63          	blez	a5,800036ac <install_trans+0xc2>
{
    800035f6:	7139                	addi	sp,sp,-64
    800035f8:	fc06                	sd	ra,56(sp)
    800035fa:	f822                	sd	s0,48(sp)
    800035fc:	f426                	sd	s1,40(sp)
    800035fe:	f04a                	sd	s2,32(sp)
    80003600:	ec4e                	sd	s3,24(sp)
    80003602:	e852                	sd	s4,16(sp)
    80003604:	e456                	sd	s5,8(sp)
    80003606:	e05a                	sd	s6,0(sp)
    80003608:	0080                	addi	s0,sp,64
    8000360a:	8b2a                	mv	s6,a0
    8000360c:	00019a97          	auipc	s5,0x19
    80003610:	63ca8a93          	addi	s5,s5,1596 # 8001cc48 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003614:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003616:	00019997          	auipc	s3,0x19
    8000361a:	5fa98993          	addi	s3,s3,1530 # 8001cc10 <log>
    8000361e:	a00d                	j	80003640 <install_trans+0x56>
    brelse(lbuf);
    80003620:	854a                	mv	a0,s2
    80003622:	fffff097          	auipc	ra,0xfffff
    80003626:	05c080e7          	jalr	92(ra) # 8000267e <brelse>
    brelse(dbuf);
    8000362a:	8526                	mv	a0,s1
    8000362c:	fffff097          	auipc	ra,0xfffff
    80003630:	052080e7          	jalr	82(ra) # 8000267e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003634:	2a05                	addiw	s4,s4,1
    80003636:	0a91                	addi	s5,s5,4
    80003638:	0349a783          	lw	a5,52(s3)
    8000363c:	04fa5e63          	bge	s4,a5,80003698 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003640:	0209a583          	lw	a1,32(s3)
    80003644:	014585bb          	addw	a1,a1,s4
    80003648:	2585                	addiw	a1,a1,1
    8000364a:	0309a503          	lw	a0,48(s3)
    8000364e:	fffff097          	auipc	ra,0xfffff
    80003652:	de6080e7          	jalr	-538(ra) # 80002434 <bread>
    80003656:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003658:	000aa583          	lw	a1,0(s5)
    8000365c:	0309a503          	lw	a0,48(s3)
    80003660:	fffff097          	auipc	ra,0xfffff
    80003664:	dd4080e7          	jalr	-556(ra) # 80002434 <bread>
    80003668:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000366a:	40000613          	li	a2,1024
    8000366e:	06090593          	addi	a1,s2,96
    80003672:	06050513          	addi	a0,a0,96
    80003676:	ffffd097          	auipc	ra,0xffffd
    8000367a:	c4a080e7          	jalr	-950(ra) # 800002c0 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000367e:	8526                	mv	a0,s1
    80003680:	fffff097          	auipc	ra,0xfffff
    80003684:	fc0080e7          	jalr	-64(ra) # 80002640 <bwrite>
    if(recovering == 0)
    80003688:	f80b1ce3          	bnez	s6,80003620 <install_trans+0x36>
      bunpin(dbuf);
    8000368c:	8526                	mv	a0,s1
    8000368e:	fffff097          	auipc	ra,0xfffff
    80003692:	0de080e7          	jalr	222(ra) # 8000276c <bunpin>
    80003696:	b769                	j	80003620 <install_trans+0x36>
}
    80003698:	70e2                	ld	ra,56(sp)
    8000369a:	7442                	ld	s0,48(sp)
    8000369c:	74a2                	ld	s1,40(sp)
    8000369e:	7902                	ld	s2,32(sp)
    800036a0:	69e2                	ld	s3,24(sp)
    800036a2:	6a42                	ld	s4,16(sp)
    800036a4:	6aa2                	ld	s5,8(sp)
    800036a6:	6b02                	ld	s6,0(sp)
    800036a8:	6121                	addi	sp,sp,64
    800036aa:	8082                	ret
    800036ac:	8082                	ret

00000000800036ae <initlog>:
{
    800036ae:	7179                	addi	sp,sp,-48
    800036b0:	f406                	sd	ra,40(sp)
    800036b2:	f022                	sd	s0,32(sp)
    800036b4:	ec26                	sd	s1,24(sp)
    800036b6:	e84a                	sd	s2,16(sp)
    800036b8:	e44e                	sd	s3,8(sp)
    800036ba:	1800                	addi	s0,sp,48
    800036bc:	892a                	mv	s2,a0
    800036be:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036c0:	00019497          	auipc	s1,0x19
    800036c4:	55048493          	addi	s1,s1,1360 # 8001cc10 <log>
    800036c8:	00005597          	auipc	a1,0x5
    800036cc:	df058593          	addi	a1,a1,-528 # 800084b8 <etext+0x4b8>
    800036d0:	8526                	mv	a0,s1
    800036d2:	00003097          	auipc	ra,0x3
    800036d6:	274080e7          	jalr	628(ra) # 80006946 <initlock>
  log.start = sb->logstart;
    800036da:	0149a583          	lw	a1,20(s3)
    800036de:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    800036e0:	0109a783          	lw	a5,16(s3)
    800036e4:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    800036e6:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036ea:	854a                	mv	a0,s2
    800036ec:	fffff097          	auipc	ra,0xfffff
    800036f0:	d48080e7          	jalr	-696(ra) # 80002434 <bread>
  log.lh.n = lh->n;
    800036f4:	5130                	lw	a2,96(a0)
    800036f6:	d8d0                	sw	a2,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036f8:	00c05f63          	blez	a2,80003716 <initlog+0x68>
    800036fc:	87aa                	mv	a5,a0
    800036fe:	00019717          	auipc	a4,0x19
    80003702:	54a70713          	addi	a4,a4,1354 # 8001cc48 <log+0x38>
    80003706:	060a                	slli	a2,a2,0x2
    80003708:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000370a:	53f4                	lw	a3,100(a5)
    8000370c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000370e:	0791                	addi	a5,a5,4
    80003710:	0711                	addi	a4,a4,4
    80003712:	fec79ce3          	bne	a5,a2,8000370a <initlog+0x5c>
  brelse(buf);
    80003716:	fffff097          	auipc	ra,0xfffff
    8000371a:	f68080e7          	jalr	-152(ra) # 8000267e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000371e:	4505                	li	a0,1
    80003720:	00000097          	auipc	ra,0x0
    80003724:	eca080e7          	jalr	-310(ra) # 800035ea <install_trans>
  log.lh.n = 0;
    80003728:	00019797          	auipc	a5,0x19
    8000372c:	5007ae23          	sw	zero,1308(a5) # 8001cc44 <log+0x34>
  write_head(); // clear the log
    80003730:	00000097          	auipc	ra,0x0
    80003734:	e50080e7          	jalr	-432(ra) # 80003580 <write_head>
}
    80003738:	70a2                	ld	ra,40(sp)
    8000373a:	7402                	ld	s0,32(sp)
    8000373c:	64e2                	ld	s1,24(sp)
    8000373e:	6942                	ld	s2,16(sp)
    80003740:	69a2                	ld	s3,8(sp)
    80003742:	6145                	addi	sp,sp,48
    80003744:	8082                	ret

0000000080003746 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003746:	1101                	addi	sp,sp,-32
    80003748:	ec06                	sd	ra,24(sp)
    8000374a:	e822                	sd	s0,16(sp)
    8000374c:	e426                	sd	s1,8(sp)
    8000374e:	e04a                	sd	s2,0(sp)
    80003750:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003752:	00019517          	auipc	a0,0x19
    80003756:	4be50513          	addi	a0,a0,1214 # 8001cc10 <log>
    8000375a:	00003097          	auipc	ra,0x3
    8000375e:	070080e7          	jalr	112(ra) # 800067ca <acquire>
  while(1){
    if(log.committing){
    80003762:	00019497          	auipc	s1,0x19
    80003766:	4ae48493          	addi	s1,s1,1198 # 8001cc10 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000376a:	4979                	li	s2,30
    8000376c:	a039                	j	8000377a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000376e:	85a6                	mv	a1,s1
    80003770:	8526                	mv	a0,s1
    80003772:	ffffe097          	auipc	ra,0xffffe
    80003776:	eca080e7          	jalr	-310(ra) # 8000163c <sleep>
    if(log.committing){
    8000377a:	54dc                	lw	a5,44(s1)
    8000377c:	fbed                	bnez	a5,8000376e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000377e:	5498                	lw	a4,40(s1)
    80003780:	2705                	addiw	a4,a4,1
    80003782:	0027179b          	slliw	a5,a4,0x2
    80003786:	9fb9                	addw	a5,a5,a4
    80003788:	0017979b          	slliw	a5,a5,0x1
    8000378c:	58d4                	lw	a3,52(s1)
    8000378e:	9fb5                	addw	a5,a5,a3
    80003790:	00f95963          	bge	s2,a5,800037a2 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003794:	85a6                	mv	a1,s1
    80003796:	8526                	mv	a0,s1
    80003798:	ffffe097          	auipc	ra,0xffffe
    8000379c:	ea4080e7          	jalr	-348(ra) # 8000163c <sleep>
    800037a0:	bfe9                	j	8000377a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037a2:	00019517          	auipc	a0,0x19
    800037a6:	46e50513          	addi	a0,a0,1134 # 8001cc10 <log>
    800037aa:	d518                	sw	a4,40(a0)
      release(&log.lock);
    800037ac:	00003097          	auipc	ra,0x3
    800037b0:	0ee080e7          	jalr	238(ra) # 8000689a <release>
      break;
    }
  }
}
    800037b4:	60e2                	ld	ra,24(sp)
    800037b6:	6442                	ld	s0,16(sp)
    800037b8:	64a2                	ld	s1,8(sp)
    800037ba:	6902                	ld	s2,0(sp)
    800037bc:	6105                	addi	sp,sp,32
    800037be:	8082                	ret

00000000800037c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037c0:	7139                	addi	sp,sp,-64
    800037c2:	fc06                	sd	ra,56(sp)
    800037c4:	f822                	sd	s0,48(sp)
    800037c6:	f426                	sd	s1,40(sp)
    800037c8:	f04a                	sd	s2,32(sp)
    800037ca:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037cc:	00019497          	auipc	s1,0x19
    800037d0:	44448493          	addi	s1,s1,1092 # 8001cc10 <log>
    800037d4:	8526                	mv	a0,s1
    800037d6:	00003097          	auipc	ra,0x3
    800037da:	ff4080e7          	jalr	-12(ra) # 800067ca <acquire>
  log.outstanding -= 1;
    800037de:	549c                	lw	a5,40(s1)
    800037e0:	37fd                	addiw	a5,a5,-1
    800037e2:	0007891b          	sext.w	s2,a5
    800037e6:	d49c                	sw	a5,40(s1)
  if(log.committing)
    800037e8:	54dc                	lw	a5,44(s1)
    800037ea:	e7b9                	bnez	a5,80003838 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800037ec:	06091163          	bnez	s2,8000384e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037f0:	00019497          	auipc	s1,0x19
    800037f4:	42048493          	addi	s1,s1,1056 # 8001cc10 <log>
    800037f8:	4785                	li	a5,1
    800037fa:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037fc:	8526                	mv	a0,s1
    800037fe:	00003097          	auipc	ra,0x3
    80003802:	09c080e7          	jalr	156(ra) # 8000689a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003806:	58dc                	lw	a5,52(s1)
    80003808:	06f04763          	bgtz	a5,80003876 <end_op+0xb6>
    acquire(&log.lock);
    8000380c:	00019497          	auipc	s1,0x19
    80003810:	40448493          	addi	s1,s1,1028 # 8001cc10 <log>
    80003814:	8526                	mv	a0,s1
    80003816:	00003097          	auipc	ra,0x3
    8000381a:	fb4080e7          	jalr	-76(ra) # 800067ca <acquire>
    log.committing = 0;
    8000381e:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    80003822:	8526                	mv	a0,s1
    80003824:	ffffe097          	auipc	ra,0xffffe
    80003828:	fa4080e7          	jalr	-92(ra) # 800017c8 <wakeup>
    release(&log.lock);
    8000382c:	8526                	mv	a0,s1
    8000382e:	00003097          	auipc	ra,0x3
    80003832:	06c080e7          	jalr	108(ra) # 8000689a <release>
}
    80003836:	a815                	j	8000386a <end_op+0xaa>
    80003838:	ec4e                	sd	s3,24(sp)
    8000383a:	e852                	sd	s4,16(sp)
    8000383c:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000383e:	00005517          	auipc	a0,0x5
    80003842:	c8250513          	addi	a0,a0,-894 # 800084c0 <etext+0x4c0>
    80003846:	00003097          	auipc	ra,0x3
    8000384a:	a20080e7          	jalr	-1504(ra) # 80006266 <panic>
    wakeup(&log);
    8000384e:	00019497          	auipc	s1,0x19
    80003852:	3c248493          	addi	s1,s1,962 # 8001cc10 <log>
    80003856:	8526                	mv	a0,s1
    80003858:	ffffe097          	auipc	ra,0xffffe
    8000385c:	f70080e7          	jalr	-144(ra) # 800017c8 <wakeup>
  release(&log.lock);
    80003860:	8526                	mv	a0,s1
    80003862:	00003097          	auipc	ra,0x3
    80003866:	038080e7          	jalr	56(ra) # 8000689a <release>
}
    8000386a:	70e2                	ld	ra,56(sp)
    8000386c:	7442                	ld	s0,48(sp)
    8000386e:	74a2                	ld	s1,40(sp)
    80003870:	7902                	ld	s2,32(sp)
    80003872:	6121                	addi	sp,sp,64
    80003874:	8082                	ret
    80003876:	ec4e                	sd	s3,24(sp)
    80003878:	e852                	sd	s4,16(sp)
    8000387a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000387c:	00019a97          	auipc	s5,0x19
    80003880:	3cca8a93          	addi	s5,s5,972 # 8001cc48 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003884:	00019a17          	auipc	s4,0x19
    80003888:	38ca0a13          	addi	s4,s4,908 # 8001cc10 <log>
    8000388c:	020a2583          	lw	a1,32(s4)
    80003890:	012585bb          	addw	a1,a1,s2
    80003894:	2585                	addiw	a1,a1,1
    80003896:	030a2503          	lw	a0,48(s4)
    8000389a:	fffff097          	auipc	ra,0xfffff
    8000389e:	b9a080e7          	jalr	-1126(ra) # 80002434 <bread>
    800038a2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038a4:	000aa583          	lw	a1,0(s5)
    800038a8:	030a2503          	lw	a0,48(s4)
    800038ac:	fffff097          	auipc	ra,0xfffff
    800038b0:	b88080e7          	jalr	-1144(ra) # 80002434 <bread>
    800038b4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038b6:	40000613          	li	a2,1024
    800038ba:	06050593          	addi	a1,a0,96
    800038be:	06048513          	addi	a0,s1,96
    800038c2:	ffffd097          	auipc	ra,0xffffd
    800038c6:	9fe080e7          	jalr	-1538(ra) # 800002c0 <memmove>
    bwrite(to);  // write the log
    800038ca:	8526                	mv	a0,s1
    800038cc:	fffff097          	auipc	ra,0xfffff
    800038d0:	d74080e7          	jalr	-652(ra) # 80002640 <bwrite>
    brelse(from);
    800038d4:	854e                	mv	a0,s3
    800038d6:	fffff097          	auipc	ra,0xfffff
    800038da:	da8080e7          	jalr	-600(ra) # 8000267e <brelse>
    brelse(to);
    800038de:	8526                	mv	a0,s1
    800038e0:	fffff097          	auipc	ra,0xfffff
    800038e4:	d9e080e7          	jalr	-610(ra) # 8000267e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038e8:	2905                	addiw	s2,s2,1
    800038ea:	0a91                	addi	s5,s5,4
    800038ec:	034a2783          	lw	a5,52(s4)
    800038f0:	f8f94ee3          	blt	s2,a5,8000388c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038f4:	00000097          	auipc	ra,0x0
    800038f8:	c8c080e7          	jalr	-884(ra) # 80003580 <write_head>
    install_trans(0); // Now install writes to home locations
    800038fc:	4501                	li	a0,0
    800038fe:	00000097          	auipc	ra,0x0
    80003902:	cec080e7          	jalr	-788(ra) # 800035ea <install_trans>
    log.lh.n = 0;
    80003906:	00019797          	auipc	a5,0x19
    8000390a:	3207af23          	sw	zero,830(a5) # 8001cc44 <log+0x34>
    write_head();    // Erase the transaction from the log
    8000390e:	00000097          	auipc	ra,0x0
    80003912:	c72080e7          	jalr	-910(ra) # 80003580 <write_head>
    80003916:	69e2                	ld	s3,24(sp)
    80003918:	6a42                	ld	s4,16(sp)
    8000391a:	6aa2                	ld	s5,8(sp)
    8000391c:	bdc5                	j	8000380c <end_op+0x4c>

000000008000391e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000391e:	1101                	addi	sp,sp,-32
    80003920:	ec06                	sd	ra,24(sp)
    80003922:	e822                	sd	s0,16(sp)
    80003924:	e426                	sd	s1,8(sp)
    80003926:	e04a                	sd	s2,0(sp)
    80003928:	1000                	addi	s0,sp,32
    8000392a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000392c:	00019917          	auipc	s2,0x19
    80003930:	2e490913          	addi	s2,s2,740 # 8001cc10 <log>
    80003934:	854a                	mv	a0,s2
    80003936:	00003097          	auipc	ra,0x3
    8000393a:	e94080e7          	jalr	-364(ra) # 800067ca <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000393e:	03492603          	lw	a2,52(s2)
    80003942:	47f5                	li	a5,29
    80003944:	06c7c563          	blt	a5,a2,800039ae <log_write+0x90>
    80003948:	00019797          	auipc	a5,0x19
    8000394c:	2ec7a783          	lw	a5,748(a5) # 8001cc34 <log+0x24>
    80003950:	37fd                	addiw	a5,a5,-1
    80003952:	04f65e63          	bge	a2,a5,800039ae <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003956:	00019797          	auipc	a5,0x19
    8000395a:	2e27a783          	lw	a5,738(a5) # 8001cc38 <log+0x28>
    8000395e:	06f05063          	blez	a5,800039be <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003962:	4781                	li	a5,0
    80003964:	06c05563          	blez	a2,800039ce <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003968:	44cc                	lw	a1,12(s1)
    8000396a:	00019717          	auipc	a4,0x19
    8000396e:	2de70713          	addi	a4,a4,734 # 8001cc48 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003972:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003974:	4314                	lw	a3,0(a4)
    80003976:	04b68c63          	beq	a3,a1,800039ce <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000397a:	2785                	addiw	a5,a5,1
    8000397c:	0711                	addi	a4,a4,4
    8000397e:	fef61be3          	bne	a2,a5,80003974 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003982:	0631                	addi	a2,a2,12
    80003984:	060a                	slli	a2,a2,0x2
    80003986:	00019797          	auipc	a5,0x19
    8000398a:	28a78793          	addi	a5,a5,650 # 8001cc10 <log>
    8000398e:	97b2                	add	a5,a5,a2
    80003990:	44d8                	lw	a4,12(s1)
    80003992:	c798                	sw	a4,8(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003994:	8526                	mv	a0,s1
    80003996:	fffff097          	auipc	ra,0xfffff
    8000399a:	d84080e7          	jalr	-636(ra) # 8000271a <bpin>
    log.lh.n++;
    8000399e:	00019717          	auipc	a4,0x19
    800039a2:	27270713          	addi	a4,a4,626 # 8001cc10 <log>
    800039a6:	5b5c                	lw	a5,52(a4)
    800039a8:	2785                	addiw	a5,a5,1
    800039aa:	db5c                	sw	a5,52(a4)
    800039ac:	a82d                	j	800039e6 <log_write+0xc8>
    panic("too big a transaction");
    800039ae:	00005517          	auipc	a0,0x5
    800039b2:	b2250513          	addi	a0,a0,-1246 # 800084d0 <etext+0x4d0>
    800039b6:	00003097          	auipc	ra,0x3
    800039ba:	8b0080e7          	jalr	-1872(ra) # 80006266 <panic>
    panic("log_write outside of trans");
    800039be:	00005517          	auipc	a0,0x5
    800039c2:	b2a50513          	addi	a0,a0,-1238 # 800084e8 <etext+0x4e8>
    800039c6:	00003097          	auipc	ra,0x3
    800039ca:	8a0080e7          	jalr	-1888(ra) # 80006266 <panic>
  log.lh.block[i] = b->blockno;
    800039ce:	00c78693          	addi	a3,a5,12
    800039d2:	068a                	slli	a3,a3,0x2
    800039d4:	00019717          	auipc	a4,0x19
    800039d8:	23c70713          	addi	a4,a4,572 # 8001cc10 <log>
    800039dc:	9736                	add	a4,a4,a3
    800039de:	44d4                	lw	a3,12(s1)
    800039e0:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039e2:	faf609e3          	beq	a2,a5,80003994 <log_write+0x76>
  }
  release(&log.lock);
    800039e6:	00019517          	auipc	a0,0x19
    800039ea:	22a50513          	addi	a0,a0,554 # 8001cc10 <log>
    800039ee:	00003097          	auipc	ra,0x3
    800039f2:	eac080e7          	jalr	-340(ra) # 8000689a <release>
}
    800039f6:	60e2                	ld	ra,24(sp)
    800039f8:	6442                	ld	s0,16(sp)
    800039fa:	64a2                	ld	s1,8(sp)
    800039fc:	6902                	ld	s2,0(sp)
    800039fe:	6105                	addi	sp,sp,32
    80003a00:	8082                	ret

0000000080003a02 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a02:	1101                	addi	sp,sp,-32
    80003a04:	ec06                	sd	ra,24(sp)
    80003a06:	e822                	sd	s0,16(sp)
    80003a08:	e426                	sd	s1,8(sp)
    80003a0a:	e04a                	sd	s2,0(sp)
    80003a0c:	1000                	addi	s0,sp,32
    80003a0e:	84aa                	mv	s1,a0
    80003a10:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a12:	00005597          	auipc	a1,0x5
    80003a16:	af658593          	addi	a1,a1,-1290 # 80008508 <etext+0x508>
    80003a1a:	0521                	addi	a0,a0,8
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	f2a080e7          	jalr	-214(ra) # 80006946 <initlock>
  lk->name = name;
    80003a24:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003a28:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a2c:	0204a823          	sw	zero,48(s1)
}
    80003a30:	60e2                	ld	ra,24(sp)
    80003a32:	6442                	ld	s0,16(sp)
    80003a34:	64a2                	ld	s1,8(sp)
    80003a36:	6902                	ld	s2,0(sp)
    80003a38:	6105                	addi	sp,sp,32
    80003a3a:	8082                	ret

0000000080003a3c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a3c:	1101                	addi	sp,sp,-32
    80003a3e:	ec06                	sd	ra,24(sp)
    80003a40:	e822                	sd	s0,16(sp)
    80003a42:	e426                	sd	s1,8(sp)
    80003a44:	e04a                	sd	s2,0(sp)
    80003a46:	1000                	addi	s0,sp,32
    80003a48:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a4a:	00850913          	addi	s2,a0,8
    80003a4e:	854a                	mv	a0,s2
    80003a50:	00003097          	auipc	ra,0x3
    80003a54:	d7a080e7          	jalr	-646(ra) # 800067ca <acquire>
  while (lk->locked) {
    80003a58:	409c                	lw	a5,0(s1)
    80003a5a:	cb89                	beqz	a5,80003a6c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a5c:	85ca                	mv	a1,s2
    80003a5e:	8526                	mv	a0,s1
    80003a60:	ffffe097          	auipc	ra,0xffffe
    80003a64:	bdc080e7          	jalr	-1060(ra) # 8000163c <sleep>
  while (lk->locked) {
    80003a68:	409c                	lw	a5,0(s1)
    80003a6a:	fbed                	bnez	a5,80003a5c <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a6c:	4785                	li	a5,1
    80003a6e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a70:	ffffd097          	auipc	ra,0xffffd
    80003a74:	506080e7          	jalr	1286(ra) # 80000f76 <myproc>
    80003a78:	5d1c                	lw	a5,56(a0)
    80003a7a:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003a7c:	854a                	mv	a0,s2
    80003a7e:	00003097          	auipc	ra,0x3
    80003a82:	e1c080e7          	jalr	-484(ra) # 8000689a <release>
}
    80003a86:	60e2                	ld	ra,24(sp)
    80003a88:	6442                	ld	s0,16(sp)
    80003a8a:	64a2                	ld	s1,8(sp)
    80003a8c:	6902                	ld	s2,0(sp)
    80003a8e:	6105                	addi	sp,sp,32
    80003a90:	8082                	ret

0000000080003a92 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a92:	1101                	addi	sp,sp,-32
    80003a94:	ec06                	sd	ra,24(sp)
    80003a96:	e822                	sd	s0,16(sp)
    80003a98:	e426                	sd	s1,8(sp)
    80003a9a:	e04a                	sd	s2,0(sp)
    80003a9c:	1000                	addi	s0,sp,32
    80003a9e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003aa0:	00850913          	addi	s2,a0,8
    80003aa4:	854a                	mv	a0,s2
    80003aa6:	00003097          	auipc	ra,0x3
    80003aaa:	d24080e7          	jalr	-732(ra) # 800067ca <acquire>
  lk->locked = 0;
    80003aae:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ab2:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003ab6:	8526                	mv	a0,s1
    80003ab8:	ffffe097          	auipc	ra,0xffffe
    80003abc:	d10080e7          	jalr	-752(ra) # 800017c8 <wakeup>
  release(&lk->lk);
    80003ac0:	854a                	mv	a0,s2
    80003ac2:	00003097          	auipc	ra,0x3
    80003ac6:	dd8080e7          	jalr	-552(ra) # 8000689a <release>
}
    80003aca:	60e2                	ld	ra,24(sp)
    80003acc:	6442                	ld	s0,16(sp)
    80003ace:	64a2                	ld	s1,8(sp)
    80003ad0:	6902                	ld	s2,0(sp)
    80003ad2:	6105                	addi	sp,sp,32
    80003ad4:	8082                	ret

0000000080003ad6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ad6:	7179                	addi	sp,sp,-48
    80003ad8:	f406                	sd	ra,40(sp)
    80003ada:	f022                	sd	s0,32(sp)
    80003adc:	ec26                	sd	s1,24(sp)
    80003ade:	e84a                	sd	s2,16(sp)
    80003ae0:	1800                	addi	s0,sp,48
    80003ae2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ae4:	00850913          	addi	s2,a0,8
    80003ae8:	854a                	mv	a0,s2
    80003aea:	00003097          	auipc	ra,0x3
    80003aee:	ce0080e7          	jalr	-800(ra) # 800067ca <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003af2:	409c                	lw	a5,0(s1)
    80003af4:	ef91                	bnez	a5,80003b10 <holdingsleep+0x3a>
    80003af6:	4481                	li	s1,0
  release(&lk->lk);
    80003af8:	854a                	mv	a0,s2
    80003afa:	00003097          	auipc	ra,0x3
    80003afe:	da0080e7          	jalr	-608(ra) # 8000689a <release>
  return r;
}
    80003b02:	8526                	mv	a0,s1
    80003b04:	70a2                	ld	ra,40(sp)
    80003b06:	7402                	ld	s0,32(sp)
    80003b08:	64e2                	ld	s1,24(sp)
    80003b0a:	6942                	ld	s2,16(sp)
    80003b0c:	6145                	addi	sp,sp,48
    80003b0e:	8082                	ret
    80003b10:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b12:	0304a983          	lw	s3,48(s1)
    80003b16:	ffffd097          	auipc	ra,0xffffd
    80003b1a:	460080e7          	jalr	1120(ra) # 80000f76 <myproc>
    80003b1e:	5d04                	lw	s1,56(a0)
    80003b20:	413484b3          	sub	s1,s1,s3
    80003b24:	0014b493          	seqz	s1,s1
    80003b28:	69a2                	ld	s3,8(sp)
    80003b2a:	b7f9                	j	80003af8 <holdingsleep+0x22>

0000000080003b2c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b2c:	1141                	addi	sp,sp,-16
    80003b2e:	e406                	sd	ra,8(sp)
    80003b30:	e022                	sd	s0,0(sp)
    80003b32:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b34:	00005597          	auipc	a1,0x5
    80003b38:	9e458593          	addi	a1,a1,-1564 # 80008518 <etext+0x518>
    80003b3c:	00019517          	auipc	a0,0x19
    80003b40:	22450513          	addi	a0,a0,548 # 8001cd60 <ftable>
    80003b44:	00003097          	auipc	ra,0x3
    80003b48:	e02080e7          	jalr	-510(ra) # 80006946 <initlock>
}
    80003b4c:	60a2                	ld	ra,8(sp)
    80003b4e:	6402                	ld	s0,0(sp)
    80003b50:	0141                	addi	sp,sp,16
    80003b52:	8082                	ret

0000000080003b54 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b54:	1101                	addi	sp,sp,-32
    80003b56:	ec06                	sd	ra,24(sp)
    80003b58:	e822                	sd	s0,16(sp)
    80003b5a:	e426                	sd	s1,8(sp)
    80003b5c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b5e:	00019517          	auipc	a0,0x19
    80003b62:	20250513          	addi	a0,a0,514 # 8001cd60 <ftable>
    80003b66:	00003097          	auipc	ra,0x3
    80003b6a:	c64080e7          	jalr	-924(ra) # 800067ca <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b6e:	00019497          	auipc	s1,0x19
    80003b72:	21248493          	addi	s1,s1,530 # 8001cd80 <ftable+0x20>
    80003b76:	0001a717          	auipc	a4,0x1a
    80003b7a:	1aa70713          	addi	a4,a4,426 # 8001dd20 <ftable+0xfc0>
    if(f->ref == 0){
    80003b7e:	40dc                	lw	a5,4(s1)
    80003b80:	cf99                	beqz	a5,80003b9e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b82:	02848493          	addi	s1,s1,40
    80003b86:	fee49ce3          	bne	s1,a4,80003b7e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b8a:	00019517          	auipc	a0,0x19
    80003b8e:	1d650513          	addi	a0,a0,470 # 8001cd60 <ftable>
    80003b92:	00003097          	auipc	ra,0x3
    80003b96:	d08080e7          	jalr	-760(ra) # 8000689a <release>
  return 0;
    80003b9a:	4481                	li	s1,0
    80003b9c:	a819                	j	80003bb2 <filealloc+0x5e>
      f->ref = 1;
    80003b9e:	4785                	li	a5,1
    80003ba0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ba2:	00019517          	auipc	a0,0x19
    80003ba6:	1be50513          	addi	a0,a0,446 # 8001cd60 <ftable>
    80003baa:	00003097          	auipc	ra,0x3
    80003bae:	cf0080e7          	jalr	-784(ra) # 8000689a <release>
}
    80003bb2:	8526                	mv	a0,s1
    80003bb4:	60e2                	ld	ra,24(sp)
    80003bb6:	6442                	ld	s0,16(sp)
    80003bb8:	64a2                	ld	s1,8(sp)
    80003bba:	6105                	addi	sp,sp,32
    80003bbc:	8082                	ret

0000000080003bbe <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bbe:	1101                	addi	sp,sp,-32
    80003bc0:	ec06                	sd	ra,24(sp)
    80003bc2:	e822                	sd	s0,16(sp)
    80003bc4:	e426                	sd	s1,8(sp)
    80003bc6:	1000                	addi	s0,sp,32
    80003bc8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bca:	00019517          	auipc	a0,0x19
    80003bce:	19650513          	addi	a0,a0,406 # 8001cd60 <ftable>
    80003bd2:	00003097          	auipc	ra,0x3
    80003bd6:	bf8080e7          	jalr	-1032(ra) # 800067ca <acquire>
  if(f->ref < 1)
    80003bda:	40dc                	lw	a5,4(s1)
    80003bdc:	02f05263          	blez	a5,80003c00 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003be0:	2785                	addiw	a5,a5,1
    80003be2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003be4:	00019517          	auipc	a0,0x19
    80003be8:	17c50513          	addi	a0,a0,380 # 8001cd60 <ftable>
    80003bec:	00003097          	auipc	ra,0x3
    80003bf0:	cae080e7          	jalr	-850(ra) # 8000689a <release>
  return f;
}
    80003bf4:	8526                	mv	a0,s1
    80003bf6:	60e2                	ld	ra,24(sp)
    80003bf8:	6442                	ld	s0,16(sp)
    80003bfa:	64a2                	ld	s1,8(sp)
    80003bfc:	6105                	addi	sp,sp,32
    80003bfe:	8082                	ret
    panic("filedup");
    80003c00:	00005517          	auipc	a0,0x5
    80003c04:	92050513          	addi	a0,a0,-1760 # 80008520 <etext+0x520>
    80003c08:	00002097          	auipc	ra,0x2
    80003c0c:	65e080e7          	jalr	1630(ra) # 80006266 <panic>

0000000080003c10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c10:	7139                	addi	sp,sp,-64
    80003c12:	fc06                	sd	ra,56(sp)
    80003c14:	f822                	sd	s0,48(sp)
    80003c16:	f426                	sd	s1,40(sp)
    80003c18:	0080                	addi	s0,sp,64
    80003c1a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c1c:	00019517          	auipc	a0,0x19
    80003c20:	14450513          	addi	a0,a0,324 # 8001cd60 <ftable>
    80003c24:	00003097          	auipc	ra,0x3
    80003c28:	ba6080e7          	jalr	-1114(ra) # 800067ca <acquire>
  if(f->ref < 1)
    80003c2c:	40dc                	lw	a5,4(s1)
    80003c2e:	04f05c63          	blez	a5,80003c86 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003c32:	37fd                	addiw	a5,a5,-1
    80003c34:	0007871b          	sext.w	a4,a5
    80003c38:	c0dc                	sw	a5,4(s1)
    80003c3a:	06e04263          	bgtz	a4,80003c9e <fileclose+0x8e>
    80003c3e:	f04a                	sd	s2,32(sp)
    80003c40:	ec4e                	sd	s3,24(sp)
    80003c42:	e852                	sd	s4,16(sp)
    80003c44:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c46:	0004a903          	lw	s2,0(s1)
    80003c4a:	0094ca83          	lbu	s5,9(s1)
    80003c4e:	0104ba03          	ld	s4,16(s1)
    80003c52:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c56:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c5a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c5e:	00019517          	auipc	a0,0x19
    80003c62:	10250513          	addi	a0,a0,258 # 8001cd60 <ftable>
    80003c66:	00003097          	auipc	ra,0x3
    80003c6a:	c34080e7          	jalr	-972(ra) # 8000689a <release>

  if(ff.type == FD_PIPE){
    80003c6e:	4785                	li	a5,1
    80003c70:	04f90463          	beq	s2,a5,80003cb8 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c74:	3979                	addiw	s2,s2,-2
    80003c76:	4785                	li	a5,1
    80003c78:	0527fb63          	bgeu	a5,s2,80003cce <fileclose+0xbe>
    80003c7c:	7902                	ld	s2,32(sp)
    80003c7e:	69e2                	ld	s3,24(sp)
    80003c80:	6a42                	ld	s4,16(sp)
    80003c82:	6aa2                	ld	s5,8(sp)
    80003c84:	a02d                	j	80003cae <fileclose+0x9e>
    80003c86:	f04a                	sd	s2,32(sp)
    80003c88:	ec4e                	sd	s3,24(sp)
    80003c8a:	e852                	sd	s4,16(sp)
    80003c8c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c8e:	00005517          	auipc	a0,0x5
    80003c92:	89a50513          	addi	a0,a0,-1894 # 80008528 <etext+0x528>
    80003c96:	00002097          	auipc	ra,0x2
    80003c9a:	5d0080e7          	jalr	1488(ra) # 80006266 <panic>
    release(&ftable.lock);
    80003c9e:	00019517          	auipc	a0,0x19
    80003ca2:	0c250513          	addi	a0,a0,194 # 8001cd60 <ftable>
    80003ca6:	00003097          	auipc	ra,0x3
    80003caa:	bf4080e7          	jalr	-1036(ra) # 8000689a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003cae:	70e2                	ld	ra,56(sp)
    80003cb0:	7442                	ld	s0,48(sp)
    80003cb2:	74a2                	ld	s1,40(sp)
    80003cb4:	6121                	addi	sp,sp,64
    80003cb6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cb8:	85d6                	mv	a1,s5
    80003cba:	8552                	mv	a0,s4
    80003cbc:	00000097          	auipc	ra,0x0
    80003cc0:	3a2080e7          	jalr	930(ra) # 8000405e <pipeclose>
    80003cc4:	7902                	ld	s2,32(sp)
    80003cc6:	69e2                	ld	s3,24(sp)
    80003cc8:	6a42                	ld	s4,16(sp)
    80003cca:	6aa2                	ld	s5,8(sp)
    80003ccc:	b7cd                	j	80003cae <fileclose+0x9e>
    begin_op();
    80003cce:	00000097          	auipc	ra,0x0
    80003cd2:	a78080e7          	jalr	-1416(ra) # 80003746 <begin_op>
    iput(ff.ip);
    80003cd6:	854e                	mv	a0,s3
    80003cd8:	fffff097          	auipc	ra,0xfffff
    80003cdc:	25a080e7          	jalr	602(ra) # 80002f32 <iput>
    end_op();
    80003ce0:	00000097          	auipc	ra,0x0
    80003ce4:	ae0080e7          	jalr	-1312(ra) # 800037c0 <end_op>
    80003ce8:	7902                	ld	s2,32(sp)
    80003cea:	69e2                	ld	s3,24(sp)
    80003cec:	6a42                	ld	s4,16(sp)
    80003cee:	6aa2                	ld	s5,8(sp)
    80003cf0:	bf7d                	j	80003cae <fileclose+0x9e>

0000000080003cf2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cf2:	715d                	addi	sp,sp,-80
    80003cf4:	e486                	sd	ra,72(sp)
    80003cf6:	e0a2                	sd	s0,64(sp)
    80003cf8:	fc26                	sd	s1,56(sp)
    80003cfa:	f44e                	sd	s3,40(sp)
    80003cfc:	0880                	addi	s0,sp,80
    80003cfe:	84aa                	mv	s1,a0
    80003d00:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d02:	ffffd097          	auipc	ra,0xffffd
    80003d06:	274080e7          	jalr	628(ra) # 80000f76 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d0a:	409c                	lw	a5,0(s1)
    80003d0c:	37f9                	addiw	a5,a5,-2
    80003d0e:	4705                	li	a4,1
    80003d10:	04f76863          	bltu	a4,a5,80003d60 <filestat+0x6e>
    80003d14:	f84a                	sd	s2,48(sp)
    80003d16:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d18:	6c88                	ld	a0,24(s1)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	05a080e7          	jalr	90(ra) # 80002d74 <ilock>
    stati(f->ip, &st);
    80003d22:	fb840593          	addi	a1,s0,-72
    80003d26:	6c88                	ld	a0,24(s1)
    80003d28:	fffff097          	auipc	ra,0xfffff
    80003d2c:	2da080e7          	jalr	730(ra) # 80003002 <stati>
    iunlock(f->ip);
    80003d30:	6c88                	ld	a0,24(s1)
    80003d32:	fffff097          	auipc	ra,0xfffff
    80003d36:	108080e7          	jalr	264(ra) # 80002e3a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d3a:	46e1                	li	a3,24
    80003d3c:	fb840613          	addi	a2,s0,-72
    80003d40:	85ce                	mv	a1,s3
    80003d42:	05893503          	ld	a0,88(s2)
    80003d46:	ffffd097          	auipc	ra,0xffffd
    80003d4a:	ecc080e7          	jalr	-308(ra) # 80000c12 <copyout>
    80003d4e:	41f5551b          	sraiw	a0,a0,0x1f
    80003d52:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003d54:	60a6                	ld	ra,72(sp)
    80003d56:	6406                	ld	s0,64(sp)
    80003d58:	74e2                	ld	s1,56(sp)
    80003d5a:	79a2                	ld	s3,40(sp)
    80003d5c:	6161                	addi	sp,sp,80
    80003d5e:	8082                	ret
  return -1;
    80003d60:	557d                	li	a0,-1
    80003d62:	bfcd                	j	80003d54 <filestat+0x62>

0000000080003d64 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d64:	7179                	addi	sp,sp,-48
    80003d66:	f406                	sd	ra,40(sp)
    80003d68:	f022                	sd	s0,32(sp)
    80003d6a:	e84a                	sd	s2,16(sp)
    80003d6c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d6e:	00854783          	lbu	a5,8(a0)
    80003d72:	cbc5                	beqz	a5,80003e22 <fileread+0xbe>
    80003d74:	ec26                	sd	s1,24(sp)
    80003d76:	e44e                	sd	s3,8(sp)
    80003d78:	84aa                	mv	s1,a0
    80003d7a:	89ae                	mv	s3,a1
    80003d7c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d7e:	411c                	lw	a5,0(a0)
    80003d80:	4705                	li	a4,1
    80003d82:	04e78963          	beq	a5,a4,80003dd4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d86:	470d                	li	a4,3
    80003d88:	04e78f63          	beq	a5,a4,80003de6 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d8c:	4709                	li	a4,2
    80003d8e:	08e79263          	bne	a5,a4,80003e12 <fileread+0xae>
    ilock(f->ip);
    80003d92:	6d08                	ld	a0,24(a0)
    80003d94:	fffff097          	auipc	ra,0xfffff
    80003d98:	fe0080e7          	jalr	-32(ra) # 80002d74 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d9c:	874a                	mv	a4,s2
    80003d9e:	5094                	lw	a3,32(s1)
    80003da0:	864e                	mv	a2,s3
    80003da2:	4585                	li	a1,1
    80003da4:	6c88                	ld	a0,24(s1)
    80003da6:	fffff097          	auipc	ra,0xfffff
    80003daa:	286080e7          	jalr	646(ra) # 8000302c <readi>
    80003dae:	892a                	mv	s2,a0
    80003db0:	00a05563          	blez	a0,80003dba <fileread+0x56>
      f->off += r;
    80003db4:	509c                	lw	a5,32(s1)
    80003db6:	9fa9                	addw	a5,a5,a0
    80003db8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003dba:	6c88                	ld	a0,24(s1)
    80003dbc:	fffff097          	auipc	ra,0xfffff
    80003dc0:	07e080e7          	jalr	126(ra) # 80002e3a <iunlock>
    80003dc4:	64e2                	ld	s1,24(sp)
    80003dc6:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003dc8:	854a                	mv	a0,s2
    80003dca:	70a2                	ld	ra,40(sp)
    80003dcc:	7402                	ld	s0,32(sp)
    80003dce:	6942                	ld	s2,16(sp)
    80003dd0:	6145                	addi	sp,sp,48
    80003dd2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003dd4:	6908                	ld	a0,16(a0)
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	404080e7          	jalr	1028(ra) # 800041da <piperead>
    80003dde:	892a                	mv	s2,a0
    80003de0:	64e2                	ld	s1,24(sp)
    80003de2:	69a2                	ld	s3,8(sp)
    80003de4:	b7d5                	j	80003dc8 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003de6:	02451783          	lh	a5,36(a0)
    80003dea:	03079693          	slli	a3,a5,0x30
    80003dee:	92c1                	srli	a3,a3,0x30
    80003df0:	4725                	li	a4,9
    80003df2:	02d76a63          	bltu	a4,a3,80003e26 <fileread+0xc2>
    80003df6:	0792                	slli	a5,a5,0x4
    80003df8:	00019717          	auipc	a4,0x19
    80003dfc:	ec870713          	addi	a4,a4,-312 # 8001ccc0 <devsw>
    80003e00:	97ba                	add	a5,a5,a4
    80003e02:	639c                	ld	a5,0(a5)
    80003e04:	c78d                	beqz	a5,80003e2e <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003e06:	4505                	li	a0,1
    80003e08:	9782                	jalr	a5
    80003e0a:	892a                	mv	s2,a0
    80003e0c:	64e2                	ld	s1,24(sp)
    80003e0e:	69a2                	ld	s3,8(sp)
    80003e10:	bf65                	j	80003dc8 <fileread+0x64>
    panic("fileread");
    80003e12:	00004517          	auipc	a0,0x4
    80003e16:	72650513          	addi	a0,a0,1830 # 80008538 <etext+0x538>
    80003e1a:	00002097          	auipc	ra,0x2
    80003e1e:	44c080e7          	jalr	1100(ra) # 80006266 <panic>
    return -1;
    80003e22:	597d                	li	s2,-1
    80003e24:	b755                	j	80003dc8 <fileread+0x64>
      return -1;
    80003e26:	597d                	li	s2,-1
    80003e28:	64e2                	ld	s1,24(sp)
    80003e2a:	69a2                	ld	s3,8(sp)
    80003e2c:	bf71                	j	80003dc8 <fileread+0x64>
    80003e2e:	597d                	li	s2,-1
    80003e30:	64e2                	ld	s1,24(sp)
    80003e32:	69a2                	ld	s3,8(sp)
    80003e34:	bf51                	j	80003dc8 <fileread+0x64>

0000000080003e36 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003e36:	00954783          	lbu	a5,9(a0)
    80003e3a:	12078963          	beqz	a5,80003f6c <filewrite+0x136>
{
    80003e3e:	715d                	addi	sp,sp,-80
    80003e40:	e486                	sd	ra,72(sp)
    80003e42:	e0a2                	sd	s0,64(sp)
    80003e44:	f84a                	sd	s2,48(sp)
    80003e46:	f052                	sd	s4,32(sp)
    80003e48:	e85a                	sd	s6,16(sp)
    80003e4a:	0880                	addi	s0,sp,80
    80003e4c:	892a                	mv	s2,a0
    80003e4e:	8b2e                	mv	s6,a1
    80003e50:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e52:	411c                	lw	a5,0(a0)
    80003e54:	4705                	li	a4,1
    80003e56:	02e78763          	beq	a5,a4,80003e84 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e5a:	470d                	li	a4,3
    80003e5c:	02e78a63          	beq	a5,a4,80003e90 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e60:	4709                	li	a4,2
    80003e62:	0ee79863          	bne	a5,a4,80003f52 <filewrite+0x11c>
    80003e66:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e68:	0cc05463          	blez	a2,80003f30 <filewrite+0xfa>
    80003e6c:	fc26                	sd	s1,56(sp)
    80003e6e:	ec56                	sd	s5,24(sp)
    80003e70:	e45e                	sd	s7,8(sp)
    80003e72:	e062                	sd	s8,0(sp)
    int i = 0;
    80003e74:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003e76:	6b85                	lui	s7,0x1
    80003e78:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e7c:	6c05                	lui	s8,0x1
    80003e7e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e82:	a851                	j	80003f16 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e84:	6908                	ld	a0,16(a0)
    80003e86:	00000097          	auipc	ra,0x0
    80003e8a:	252080e7          	jalr	594(ra) # 800040d8 <pipewrite>
    80003e8e:	a85d                	j	80003f44 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e90:	02451783          	lh	a5,36(a0)
    80003e94:	03079693          	slli	a3,a5,0x30
    80003e98:	92c1                	srli	a3,a3,0x30
    80003e9a:	4725                	li	a4,9
    80003e9c:	0cd76a63          	bltu	a4,a3,80003f70 <filewrite+0x13a>
    80003ea0:	0792                	slli	a5,a5,0x4
    80003ea2:	00019717          	auipc	a4,0x19
    80003ea6:	e1e70713          	addi	a4,a4,-482 # 8001ccc0 <devsw>
    80003eaa:	97ba                	add	a5,a5,a4
    80003eac:	679c                	ld	a5,8(a5)
    80003eae:	c3f9                	beqz	a5,80003f74 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003eb0:	4505                	li	a0,1
    80003eb2:	9782                	jalr	a5
    80003eb4:	a841                	j	80003f44 <filewrite+0x10e>
      if(n1 > max)
    80003eb6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003eba:	00000097          	auipc	ra,0x0
    80003ebe:	88c080e7          	jalr	-1908(ra) # 80003746 <begin_op>
      ilock(f->ip);
    80003ec2:	01893503          	ld	a0,24(s2)
    80003ec6:	fffff097          	auipc	ra,0xfffff
    80003eca:	eae080e7          	jalr	-338(ra) # 80002d74 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ece:	8756                	mv	a4,s5
    80003ed0:	02092683          	lw	a3,32(s2)
    80003ed4:	01698633          	add	a2,s3,s6
    80003ed8:	4585                	li	a1,1
    80003eda:	01893503          	ld	a0,24(s2)
    80003ede:	fffff097          	auipc	ra,0xfffff
    80003ee2:	252080e7          	jalr	594(ra) # 80003130 <writei>
    80003ee6:	84aa                	mv	s1,a0
    80003ee8:	00a05763          	blez	a0,80003ef6 <filewrite+0xc0>
        f->off += r;
    80003eec:	02092783          	lw	a5,32(s2)
    80003ef0:	9fa9                	addw	a5,a5,a0
    80003ef2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ef6:	01893503          	ld	a0,24(s2)
    80003efa:	fffff097          	auipc	ra,0xfffff
    80003efe:	f40080e7          	jalr	-192(ra) # 80002e3a <iunlock>
      end_op();
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	8be080e7          	jalr	-1858(ra) # 800037c0 <end_op>

      if(r != n1){
    80003f0a:	029a9563          	bne	s5,s1,80003f34 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003f0e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f12:	0149da63          	bge	s3,s4,80003f26 <filewrite+0xf0>
      int n1 = n - i;
    80003f16:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003f1a:	0004879b          	sext.w	a5,s1
    80003f1e:	f8fbdce3          	bge	s7,a5,80003eb6 <filewrite+0x80>
    80003f22:	84e2                	mv	s1,s8
    80003f24:	bf49                	j	80003eb6 <filewrite+0x80>
    80003f26:	74e2                	ld	s1,56(sp)
    80003f28:	6ae2                	ld	s5,24(sp)
    80003f2a:	6ba2                	ld	s7,8(sp)
    80003f2c:	6c02                	ld	s8,0(sp)
    80003f2e:	a039                	j	80003f3c <filewrite+0x106>
    int i = 0;
    80003f30:	4981                	li	s3,0
    80003f32:	a029                	j	80003f3c <filewrite+0x106>
    80003f34:	74e2                	ld	s1,56(sp)
    80003f36:	6ae2                	ld	s5,24(sp)
    80003f38:	6ba2                	ld	s7,8(sp)
    80003f3a:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003f3c:	033a1e63          	bne	s4,s3,80003f78 <filewrite+0x142>
    80003f40:	8552                	mv	a0,s4
    80003f42:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f44:	60a6                	ld	ra,72(sp)
    80003f46:	6406                	ld	s0,64(sp)
    80003f48:	7942                	ld	s2,48(sp)
    80003f4a:	7a02                	ld	s4,32(sp)
    80003f4c:	6b42                	ld	s6,16(sp)
    80003f4e:	6161                	addi	sp,sp,80
    80003f50:	8082                	ret
    80003f52:	fc26                	sd	s1,56(sp)
    80003f54:	f44e                	sd	s3,40(sp)
    80003f56:	ec56                	sd	s5,24(sp)
    80003f58:	e45e                	sd	s7,8(sp)
    80003f5a:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003f5c:	00004517          	auipc	a0,0x4
    80003f60:	5ec50513          	addi	a0,a0,1516 # 80008548 <etext+0x548>
    80003f64:	00002097          	auipc	ra,0x2
    80003f68:	302080e7          	jalr	770(ra) # 80006266 <panic>
    return -1;
    80003f6c:	557d                	li	a0,-1
}
    80003f6e:	8082                	ret
      return -1;
    80003f70:	557d                	li	a0,-1
    80003f72:	bfc9                	j	80003f44 <filewrite+0x10e>
    80003f74:	557d                	li	a0,-1
    80003f76:	b7f9                	j	80003f44 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003f78:	557d                	li	a0,-1
    80003f7a:	79a2                	ld	s3,40(sp)
    80003f7c:	b7e1                	j	80003f44 <filewrite+0x10e>

0000000080003f7e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f7e:	7179                	addi	sp,sp,-48
    80003f80:	f406                	sd	ra,40(sp)
    80003f82:	f022                	sd	s0,32(sp)
    80003f84:	ec26                	sd	s1,24(sp)
    80003f86:	e052                	sd	s4,0(sp)
    80003f88:	1800                	addi	s0,sp,48
    80003f8a:	84aa                	mv	s1,a0
    80003f8c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f8e:	0005b023          	sd	zero,0(a1)
    80003f92:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f96:	00000097          	auipc	ra,0x0
    80003f9a:	bbe080e7          	jalr	-1090(ra) # 80003b54 <filealloc>
    80003f9e:	e088                	sd	a0,0(s1)
    80003fa0:	cd49                	beqz	a0,8000403a <pipealloc+0xbc>
    80003fa2:	00000097          	auipc	ra,0x0
    80003fa6:	bb2080e7          	jalr	-1102(ra) # 80003b54 <filealloc>
    80003faa:	00aa3023          	sd	a0,0(s4)
    80003fae:	c141                	beqz	a0,8000402e <pipealloc+0xb0>
    80003fb0:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fb2:	ffffc097          	auipc	ra,0xffffc
    80003fb6:	1ba080e7          	jalr	442(ra) # 8000016c <kalloc>
    80003fba:	892a                	mv	s2,a0
    80003fbc:	c13d                	beqz	a0,80004022 <pipealloc+0xa4>
    80003fbe:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003fc0:	4985                	li	s3,1
    80003fc2:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80003fc6:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003fca:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80003fce:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80003fd2:	00004597          	auipc	a1,0x4
    80003fd6:	58658593          	addi	a1,a1,1414 # 80008558 <etext+0x558>
    80003fda:	00003097          	auipc	ra,0x3
    80003fde:	96c080e7          	jalr	-1684(ra) # 80006946 <initlock>
  (*f0)->type = FD_PIPE;
    80003fe2:	609c                	ld	a5,0(s1)
    80003fe4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fe8:	609c                	ld	a5,0(s1)
    80003fea:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fee:	609c                	ld	a5,0(s1)
    80003ff0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ff4:	609c                	ld	a5,0(s1)
    80003ff6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ffa:	000a3783          	ld	a5,0(s4)
    80003ffe:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004002:	000a3783          	ld	a5,0(s4)
    80004006:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000400a:	000a3783          	ld	a5,0(s4)
    8000400e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004012:	000a3783          	ld	a5,0(s4)
    80004016:	0127b823          	sd	s2,16(a5)
  return 0;
    8000401a:	4501                	li	a0,0
    8000401c:	6942                	ld	s2,16(sp)
    8000401e:	69a2                	ld	s3,8(sp)
    80004020:	a03d                	j	8000404e <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004022:	6088                	ld	a0,0(s1)
    80004024:	c119                	beqz	a0,8000402a <pipealloc+0xac>
    80004026:	6942                	ld	s2,16(sp)
    80004028:	a029                	j	80004032 <pipealloc+0xb4>
    8000402a:	6942                	ld	s2,16(sp)
    8000402c:	a039                	j	8000403a <pipealloc+0xbc>
    8000402e:	6088                	ld	a0,0(s1)
    80004030:	c50d                	beqz	a0,8000405a <pipealloc+0xdc>
    fileclose(*f0);
    80004032:	00000097          	auipc	ra,0x0
    80004036:	bde080e7          	jalr	-1058(ra) # 80003c10 <fileclose>
  if(*f1)
    8000403a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000403e:	557d                	li	a0,-1
  if(*f1)
    80004040:	c799                	beqz	a5,8000404e <pipealloc+0xd0>
    fileclose(*f1);
    80004042:	853e                	mv	a0,a5
    80004044:	00000097          	auipc	ra,0x0
    80004048:	bcc080e7          	jalr	-1076(ra) # 80003c10 <fileclose>
  return -1;
    8000404c:	557d                	li	a0,-1
}
    8000404e:	70a2                	ld	ra,40(sp)
    80004050:	7402                	ld	s0,32(sp)
    80004052:	64e2                	ld	s1,24(sp)
    80004054:	6a02                	ld	s4,0(sp)
    80004056:	6145                	addi	sp,sp,48
    80004058:	8082                	ret
  return -1;
    8000405a:	557d                	li	a0,-1
    8000405c:	bfcd                	j	8000404e <pipealloc+0xd0>

000000008000405e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000405e:	1101                	addi	sp,sp,-32
    80004060:	ec06                	sd	ra,24(sp)
    80004062:	e822                	sd	s0,16(sp)
    80004064:	e426                	sd	s1,8(sp)
    80004066:	e04a                	sd	s2,0(sp)
    80004068:	1000                	addi	s0,sp,32
    8000406a:	84aa                	mv	s1,a0
    8000406c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000406e:	00002097          	auipc	ra,0x2
    80004072:	75c080e7          	jalr	1884(ra) # 800067ca <acquire>
  if(writable){
    80004076:	04090263          	beqz	s2,800040ba <pipeclose+0x5c>
    pi->writeopen = 0;
    8000407a:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    8000407e:	22048513          	addi	a0,s1,544
    80004082:	ffffd097          	auipc	ra,0xffffd
    80004086:	746080e7          	jalr	1862(ra) # 800017c8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000408a:	2284b783          	ld	a5,552(s1)
    8000408e:	ef9d                	bnez	a5,800040cc <pipeclose+0x6e>
    release(&pi->lock);
    80004090:	8526                	mv	a0,s1
    80004092:	00003097          	auipc	ra,0x3
    80004096:	808080e7          	jalr	-2040(ra) # 8000689a <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    8000409a:	8526                	mv	a0,s1
    8000409c:	00003097          	auipc	ra,0x3
    800040a0:	846080e7          	jalr	-1978(ra) # 800068e2 <freelock>
#endif    
    kfree((char*)pi);
    800040a4:	8526                	mv	a0,s1
    800040a6:	ffffc097          	auipc	ra,0xffffc
    800040aa:	f76080e7          	jalr	-138(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040ae:	60e2                	ld	ra,24(sp)
    800040b0:	6442                	ld	s0,16(sp)
    800040b2:	64a2                	ld	s1,8(sp)
    800040b4:	6902                	ld	s2,0(sp)
    800040b6:	6105                	addi	sp,sp,32
    800040b8:	8082                	ret
    pi->readopen = 0;
    800040ba:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    800040be:	22448513          	addi	a0,s1,548
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	706080e7          	jalr	1798(ra) # 800017c8 <wakeup>
    800040ca:	b7c1                	j	8000408a <pipeclose+0x2c>
    release(&pi->lock);
    800040cc:	8526                	mv	a0,s1
    800040ce:	00002097          	auipc	ra,0x2
    800040d2:	7cc080e7          	jalr	1996(ra) # 8000689a <release>
}
    800040d6:	bfe1                	j	800040ae <pipeclose+0x50>

00000000800040d8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040d8:	711d                	addi	sp,sp,-96
    800040da:	ec86                	sd	ra,88(sp)
    800040dc:	e8a2                	sd	s0,80(sp)
    800040de:	e4a6                	sd	s1,72(sp)
    800040e0:	e0ca                	sd	s2,64(sp)
    800040e2:	fc4e                	sd	s3,56(sp)
    800040e4:	f852                	sd	s4,48(sp)
    800040e6:	f456                	sd	s5,40(sp)
    800040e8:	1080                	addi	s0,sp,96
    800040ea:	84aa                	mv	s1,a0
    800040ec:	8aae                	mv	s5,a1
    800040ee:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040f0:	ffffd097          	auipc	ra,0xffffd
    800040f4:	e86080e7          	jalr	-378(ra) # 80000f76 <myproc>
    800040f8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040fa:	8526                	mv	a0,s1
    800040fc:	00002097          	auipc	ra,0x2
    80004100:	6ce080e7          	jalr	1742(ra) # 800067ca <acquire>
  while(i < n){
    80004104:	0d405563          	blez	s4,800041ce <pipewrite+0xf6>
    80004108:	f05a                	sd	s6,32(sp)
    8000410a:	ec5e                	sd	s7,24(sp)
    8000410c:	e862                	sd	s8,16(sp)
  int i = 0;
    8000410e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004110:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004112:	22048c13          	addi	s8,s1,544
      sleep(&pi->nwrite, &pi->lock);
    80004116:	22448b93          	addi	s7,s1,548
    8000411a:	a089                	j	8000415c <pipewrite+0x84>
      release(&pi->lock);
    8000411c:	8526                	mv	a0,s1
    8000411e:	00002097          	auipc	ra,0x2
    80004122:	77c080e7          	jalr	1916(ra) # 8000689a <release>
      return -1;
    80004126:	597d                	li	s2,-1
    80004128:	7b02                	ld	s6,32(sp)
    8000412a:	6be2                	ld	s7,24(sp)
    8000412c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000412e:	854a                	mv	a0,s2
    80004130:	60e6                	ld	ra,88(sp)
    80004132:	6446                	ld	s0,80(sp)
    80004134:	64a6                	ld	s1,72(sp)
    80004136:	6906                	ld	s2,64(sp)
    80004138:	79e2                	ld	s3,56(sp)
    8000413a:	7a42                	ld	s4,48(sp)
    8000413c:	7aa2                	ld	s5,40(sp)
    8000413e:	6125                	addi	sp,sp,96
    80004140:	8082                	ret
      wakeup(&pi->nread);
    80004142:	8562                	mv	a0,s8
    80004144:	ffffd097          	auipc	ra,0xffffd
    80004148:	684080e7          	jalr	1668(ra) # 800017c8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000414c:	85a6                	mv	a1,s1
    8000414e:	855e                	mv	a0,s7
    80004150:	ffffd097          	auipc	ra,0xffffd
    80004154:	4ec080e7          	jalr	1260(ra) # 8000163c <sleep>
  while(i < n){
    80004158:	05495c63          	bge	s2,s4,800041b0 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    8000415c:	2284a783          	lw	a5,552(s1)
    80004160:	dfd5                	beqz	a5,8000411c <pipewrite+0x44>
    80004162:	0309a783          	lw	a5,48(s3)
    80004166:	fbdd                	bnez	a5,8000411c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004168:	2204a783          	lw	a5,544(s1)
    8000416c:	2244a703          	lw	a4,548(s1)
    80004170:	2007879b          	addiw	a5,a5,512
    80004174:	fcf707e3          	beq	a4,a5,80004142 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004178:	4685                	li	a3,1
    8000417a:	01590633          	add	a2,s2,s5
    8000417e:	faf40593          	addi	a1,s0,-81
    80004182:	0589b503          	ld	a0,88(s3)
    80004186:	ffffd097          	auipc	ra,0xffffd
    8000418a:	b18080e7          	jalr	-1256(ra) # 80000c9e <copyin>
    8000418e:	05650263          	beq	a0,s6,800041d2 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004192:	2244a783          	lw	a5,548(s1)
    80004196:	0017871b          	addiw	a4,a5,1
    8000419a:	22e4a223          	sw	a4,548(s1)
    8000419e:	1ff7f793          	andi	a5,a5,511
    800041a2:	97a6                	add	a5,a5,s1
    800041a4:	faf44703          	lbu	a4,-81(s0)
    800041a8:	02e78023          	sb	a4,32(a5)
      i++;
    800041ac:	2905                	addiw	s2,s2,1
    800041ae:	b76d                	j	80004158 <pipewrite+0x80>
    800041b0:	7b02                	ld	s6,32(sp)
    800041b2:	6be2                	ld	s7,24(sp)
    800041b4:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800041b6:	22048513          	addi	a0,s1,544
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	60e080e7          	jalr	1550(ra) # 800017c8 <wakeup>
  release(&pi->lock);
    800041c2:	8526                	mv	a0,s1
    800041c4:	00002097          	auipc	ra,0x2
    800041c8:	6d6080e7          	jalr	1750(ra) # 8000689a <release>
  return i;
    800041cc:	b78d                	j	8000412e <pipewrite+0x56>
  int i = 0;
    800041ce:	4901                	li	s2,0
    800041d0:	b7dd                	j	800041b6 <pipewrite+0xde>
    800041d2:	7b02                	ld	s6,32(sp)
    800041d4:	6be2                	ld	s7,24(sp)
    800041d6:	6c42                	ld	s8,16(sp)
    800041d8:	bff9                	j	800041b6 <pipewrite+0xde>

00000000800041da <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041da:	715d                	addi	sp,sp,-80
    800041dc:	e486                	sd	ra,72(sp)
    800041de:	e0a2                	sd	s0,64(sp)
    800041e0:	fc26                	sd	s1,56(sp)
    800041e2:	f84a                	sd	s2,48(sp)
    800041e4:	f44e                	sd	s3,40(sp)
    800041e6:	f052                	sd	s4,32(sp)
    800041e8:	ec56                	sd	s5,24(sp)
    800041ea:	0880                	addi	s0,sp,80
    800041ec:	84aa                	mv	s1,a0
    800041ee:	892e                	mv	s2,a1
    800041f0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041f2:	ffffd097          	auipc	ra,0xffffd
    800041f6:	d84080e7          	jalr	-636(ra) # 80000f76 <myproc>
    800041fa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041fc:	8526                	mv	a0,s1
    800041fe:	00002097          	auipc	ra,0x2
    80004202:	5cc080e7          	jalr	1484(ra) # 800067ca <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004206:	2204a703          	lw	a4,544(s1)
    8000420a:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000420e:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004212:	02f71663          	bne	a4,a5,8000423e <piperead+0x64>
    80004216:	22c4a783          	lw	a5,556(s1)
    8000421a:	cb9d                	beqz	a5,80004250 <piperead+0x76>
    if(pr->killed){
    8000421c:	030a2783          	lw	a5,48(s4)
    80004220:	e38d                	bnez	a5,80004242 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004222:	85a6                	mv	a1,s1
    80004224:	854e                	mv	a0,s3
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	416080e7          	jalr	1046(ra) # 8000163c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000422e:	2204a703          	lw	a4,544(s1)
    80004232:	2244a783          	lw	a5,548(s1)
    80004236:	fef700e3          	beq	a4,a5,80004216 <piperead+0x3c>
    8000423a:	e85a                	sd	s6,16(sp)
    8000423c:	a819                	j	80004252 <piperead+0x78>
    8000423e:	e85a                	sd	s6,16(sp)
    80004240:	a809                	j	80004252 <piperead+0x78>
      release(&pi->lock);
    80004242:	8526                	mv	a0,s1
    80004244:	00002097          	auipc	ra,0x2
    80004248:	656080e7          	jalr	1622(ra) # 8000689a <release>
      return -1;
    8000424c:	59fd                	li	s3,-1
    8000424e:	a0a5                	j	800042b6 <piperead+0xdc>
    80004250:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004252:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004254:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004256:	05505463          	blez	s5,8000429e <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    8000425a:	2204a783          	lw	a5,544(s1)
    8000425e:	2244a703          	lw	a4,548(s1)
    80004262:	02f70e63          	beq	a4,a5,8000429e <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004266:	0017871b          	addiw	a4,a5,1
    8000426a:	22e4a023          	sw	a4,544(s1)
    8000426e:	1ff7f793          	andi	a5,a5,511
    80004272:	97a6                	add	a5,a5,s1
    80004274:	0207c783          	lbu	a5,32(a5)
    80004278:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000427c:	4685                	li	a3,1
    8000427e:	fbf40613          	addi	a2,s0,-65
    80004282:	85ca                	mv	a1,s2
    80004284:	058a3503          	ld	a0,88(s4)
    80004288:	ffffd097          	auipc	ra,0xffffd
    8000428c:	98a080e7          	jalr	-1654(ra) # 80000c12 <copyout>
    80004290:	01650763          	beq	a0,s6,8000429e <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004294:	2985                	addiw	s3,s3,1
    80004296:	0905                	addi	s2,s2,1
    80004298:	fd3a91e3          	bne	s5,s3,8000425a <piperead+0x80>
    8000429c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000429e:	22448513          	addi	a0,s1,548
    800042a2:	ffffd097          	auipc	ra,0xffffd
    800042a6:	526080e7          	jalr	1318(ra) # 800017c8 <wakeup>
  release(&pi->lock);
    800042aa:	8526                	mv	a0,s1
    800042ac:	00002097          	auipc	ra,0x2
    800042b0:	5ee080e7          	jalr	1518(ra) # 8000689a <release>
    800042b4:	6b42                	ld	s6,16(sp)
  return i;
}
    800042b6:	854e                	mv	a0,s3
    800042b8:	60a6                	ld	ra,72(sp)
    800042ba:	6406                	ld	s0,64(sp)
    800042bc:	74e2                	ld	s1,56(sp)
    800042be:	7942                	ld	s2,48(sp)
    800042c0:	79a2                	ld	s3,40(sp)
    800042c2:	7a02                	ld	s4,32(sp)
    800042c4:	6ae2                	ld	s5,24(sp)
    800042c6:	6161                	addi	sp,sp,80
    800042c8:	8082                	ret

00000000800042ca <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042ca:	df010113          	addi	sp,sp,-528
    800042ce:	20113423          	sd	ra,520(sp)
    800042d2:	20813023          	sd	s0,512(sp)
    800042d6:	ffa6                	sd	s1,504(sp)
    800042d8:	fbca                	sd	s2,496(sp)
    800042da:	0c00                	addi	s0,sp,528
    800042dc:	892a                	mv	s2,a0
    800042de:	dea43c23          	sd	a0,-520(s0)
    800042e2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	c90080e7          	jalr	-880(ra) # 80000f76 <myproc>
    800042ee:	84aa                	mv	s1,a0

  begin_op();
    800042f0:	fffff097          	auipc	ra,0xfffff
    800042f4:	456080e7          	jalr	1110(ra) # 80003746 <begin_op>

  if((ip = namei(path)) == 0){
    800042f8:	854a                	mv	a0,s2
    800042fa:	fffff097          	auipc	ra,0xfffff
    800042fe:	24c080e7          	jalr	588(ra) # 80003546 <namei>
    80004302:	c135                	beqz	a0,80004366 <exec+0x9c>
    80004304:	f3d2                	sd	s4,480(sp)
    80004306:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	a6c080e7          	jalr	-1428(ra) # 80002d74 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004310:	04000713          	li	a4,64
    80004314:	4681                	li	a3,0
    80004316:	e5040613          	addi	a2,s0,-432
    8000431a:	4581                	li	a1,0
    8000431c:	8552                	mv	a0,s4
    8000431e:	fffff097          	auipc	ra,0xfffff
    80004322:	d0e080e7          	jalr	-754(ra) # 8000302c <readi>
    80004326:	04000793          	li	a5,64
    8000432a:	00f51a63          	bne	a0,a5,8000433e <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000432e:	e5042703          	lw	a4,-432(s0)
    80004332:	464c47b7          	lui	a5,0x464c4
    80004336:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000433a:	02f70c63          	beq	a4,a5,80004372 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000433e:	8552                	mv	a0,s4
    80004340:	fffff097          	auipc	ra,0xfffff
    80004344:	c9a080e7          	jalr	-870(ra) # 80002fda <iunlockput>
    end_op();
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	478080e7          	jalr	1144(ra) # 800037c0 <end_op>
  }
  return -1;
    80004350:	557d                	li	a0,-1
    80004352:	7a1e                	ld	s4,480(sp)
}
    80004354:	20813083          	ld	ra,520(sp)
    80004358:	20013403          	ld	s0,512(sp)
    8000435c:	74fe                	ld	s1,504(sp)
    8000435e:	795e                	ld	s2,496(sp)
    80004360:	21010113          	addi	sp,sp,528
    80004364:	8082                	ret
    end_op();
    80004366:	fffff097          	auipc	ra,0xfffff
    8000436a:	45a080e7          	jalr	1114(ra) # 800037c0 <end_op>
    return -1;
    8000436e:	557d                	li	a0,-1
    80004370:	b7d5                	j	80004354 <exec+0x8a>
    80004372:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004374:	8526                	mv	a0,s1
    80004376:	ffffd097          	auipc	ra,0xffffd
    8000437a:	cc4080e7          	jalr	-828(ra) # 8000103a <proc_pagetable>
    8000437e:	8b2a                	mv	s6,a0
    80004380:	30050563          	beqz	a0,8000468a <exec+0x3c0>
    80004384:	f7ce                	sd	s3,488(sp)
    80004386:	efd6                	sd	s5,472(sp)
    80004388:	e7de                	sd	s7,456(sp)
    8000438a:	e3e2                	sd	s8,448(sp)
    8000438c:	ff66                	sd	s9,440(sp)
    8000438e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004390:	e7042d03          	lw	s10,-400(s0)
    80004394:	e8845783          	lhu	a5,-376(s0)
    80004398:	14078563          	beqz	a5,800044e2 <exec+0x218>
    8000439c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000439e:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043a0:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    800043a2:	6c85                	lui	s9,0x1
    800043a4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043a8:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800043ac:	6a85                	lui	s5,0x1
    800043ae:	a0b5                	j	8000441a <exec+0x150>
      panic("loadseg: address should exist");
    800043b0:	00004517          	auipc	a0,0x4
    800043b4:	1b050513          	addi	a0,a0,432 # 80008560 <etext+0x560>
    800043b8:	00002097          	auipc	ra,0x2
    800043bc:	eae080e7          	jalr	-338(ra) # 80006266 <panic>
    if(sz - i < PGSIZE)
    800043c0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043c2:	8726                	mv	a4,s1
    800043c4:	012c06bb          	addw	a3,s8,s2
    800043c8:	4581                	li	a1,0
    800043ca:	8552                	mv	a0,s4
    800043cc:	fffff097          	auipc	ra,0xfffff
    800043d0:	c60080e7          	jalr	-928(ra) # 8000302c <readi>
    800043d4:	2501                	sext.w	a0,a0
    800043d6:	26a49e63          	bne	s1,a0,80004652 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800043da:	012a893b          	addw	s2,s5,s2
    800043de:	03397563          	bgeu	s2,s3,80004408 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800043e2:	02091593          	slli	a1,s2,0x20
    800043e6:	9181                	srli	a1,a1,0x20
    800043e8:	95de                	add	a1,a1,s7
    800043ea:	855a                	mv	a0,s6
    800043ec:	ffffc097          	auipc	ra,0xffffc
    800043f0:	206080e7          	jalr	518(ra) # 800005f2 <walkaddr>
    800043f4:	862a                	mv	a2,a0
    if(pa == 0)
    800043f6:	dd4d                	beqz	a0,800043b0 <exec+0xe6>
    if(sz - i < PGSIZE)
    800043f8:	412984bb          	subw	s1,s3,s2
    800043fc:	0004879b          	sext.w	a5,s1
    80004400:	fcfcf0e3          	bgeu	s9,a5,800043c0 <exec+0xf6>
    80004404:	84d6                	mv	s1,s5
    80004406:	bf6d                	j	800043c0 <exec+0xf6>
    sz = sz1;
    80004408:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000440c:	2d85                	addiw	s11,s11,1
    8000440e:	038d0d1b          	addiw	s10,s10,56
    80004412:	e8845783          	lhu	a5,-376(s0)
    80004416:	06fddf63          	bge	s11,a5,80004494 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000441a:	2d01                	sext.w	s10,s10
    8000441c:	03800713          	li	a4,56
    80004420:	86ea                	mv	a3,s10
    80004422:	e1840613          	addi	a2,s0,-488
    80004426:	4581                	li	a1,0
    80004428:	8552                	mv	a0,s4
    8000442a:	fffff097          	auipc	ra,0xfffff
    8000442e:	c02080e7          	jalr	-1022(ra) # 8000302c <readi>
    80004432:	03800793          	li	a5,56
    80004436:	1ef51863          	bne	a0,a5,80004626 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    8000443a:	e1842783          	lw	a5,-488(s0)
    8000443e:	4705                	li	a4,1
    80004440:	fce796e3          	bne	a5,a4,8000440c <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004444:	e4043603          	ld	a2,-448(s0)
    80004448:	e3843783          	ld	a5,-456(s0)
    8000444c:	1ef66163          	bltu	a2,a5,8000462e <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004450:	e2843783          	ld	a5,-472(s0)
    80004454:	963e                	add	a2,a2,a5
    80004456:	1ef66063          	bltu	a2,a5,80004636 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000445a:	85a6                	mv	a1,s1
    8000445c:	855a                	mv	a0,s6
    8000445e:	ffffc097          	auipc	ra,0xffffc
    80004462:	558080e7          	jalr	1368(ra) # 800009b6 <uvmalloc>
    80004466:	e0a43423          	sd	a0,-504(s0)
    8000446a:	1c050a63          	beqz	a0,8000463e <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    8000446e:	e2843b83          	ld	s7,-472(s0)
    80004472:	df043783          	ld	a5,-528(s0)
    80004476:	00fbf7b3          	and	a5,s7,a5
    8000447a:	1c079a63          	bnez	a5,8000464e <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000447e:	e2042c03          	lw	s8,-480(s0)
    80004482:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004486:	00098463          	beqz	s3,8000448e <exec+0x1c4>
    8000448a:	4901                	li	s2,0
    8000448c:	bf99                	j	800043e2 <exec+0x118>
    sz = sz1;
    8000448e:	e0843483          	ld	s1,-504(s0)
    80004492:	bfad                	j	8000440c <exec+0x142>
    80004494:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004496:	8552                	mv	a0,s4
    80004498:	fffff097          	auipc	ra,0xfffff
    8000449c:	b42080e7          	jalr	-1214(ra) # 80002fda <iunlockput>
  end_op();
    800044a0:	fffff097          	auipc	ra,0xfffff
    800044a4:	320080e7          	jalr	800(ra) # 800037c0 <end_op>
  p = myproc();
    800044a8:	ffffd097          	auipc	ra,0xffffd
    800044ac:	ace080e7          	jalr	-1330(ra) # 80000f76 <myproc>
    800044b0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800044b2:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    800044b6:	6985                	lui	s3,0x1
    800044b8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800044ba:	99a6                	add	s3,s3,s1
    800044bc:	77fd                	lui	a5,0xfffff
    800044be:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800044c2:	6609                	lui	a2,0x2
    800044c4:	964e                	add	a2,a2,s3
    800044c6:	85ce                	mv	a1,s3
    800044c8:	855a                	mv	a0,s6
    800044ca:	ffffc097          	auipc	ra,0xffffc
    800044ce:	4ec080e7          	jalr	1260(ra) # 800009b6 <uvmalloc>
    800044d2:	892a                	mv	s2,a0
    800044d4:	e0a43423          	sd	a0,-504(s0)
    800044d8:	e519                	bnez	a0,800044e6 <exec+0x21c>
  if(pagetable)
    800044da:	e1343423          	sd	s3,-504(s0)
    800044de:	4a01                	li	s4,0
    800044e0:	aa95                	j	80004654 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044e2:	4481                	li	s1,0
    800044e4:	bf4d                	j	80004496 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800044e6:	75f9                	lui	a1,0xffffe
    800044e8:	95aa                	add	a1,a1,a0
    800044ea:	855a                	mv	a0,s6
    800044ec:	ffffc097          	auipc	ra,0xffffc
    800044f0:	6f4080e7          	jalr	1780(ra) # 80000be0 <uvmclear>
  stackbase = sp - PGSIZE;
    800044f4:	7bfd                	lui	s7,0xfffff
    800044f6:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800044f8:	e0043783          	ld	a5,-512(s0)
    800044fc:	6388                	ld	a0,0(a5)
    800044fe:	c52d                	beqz	a0,80004568 <exec+0x29e>
    80004500:	e9040993          	addi	s3,s0,-368
    80004504:	f9040c13          	addi	s8,s0,-112
    80004508:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000450a:	ffffc097          	auipc	ra,0xffffc
    8000450e:	ece080e7          	jalr	-306(ra) # 800003d8 <strlen>
    80004512:	0015079b          	addiw	a5,a0,1
    80004516:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000451a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000451e:	13796463          	bltu	s2,s7,80004646 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004522:	e0043d03          	ld	s10,-512(s0)
    80004526:	000d3a03          	ld	s4,0(s10)
    8000452a:	8552                	mv	a0,s4
    8000452c:	ffffc097          	auipc	ra,0xffffc
    80004530:	eac080e7          	jalr	-340(ra) # 800003d8 <strlen>
    80004534:	0015069b          	addiw	a3,a0,1
    80004538:	8652                	mv	a2,s4
    8000453a:	85ca                	mv	a1,s2
    8000453c:	855a                	mv	a0,s6
    8000453e:	ffffc097          	auipc	ra,0xffffc
    80004542:	6d4080e7          	jalr	1748(ra) # 80000c12 <copyout>
    80004546:	10054263          	bltz	a0,8000464a <exec+0x380>
    ustack[argc] = sp;
    8000454a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000454e:	0485                	addi	s1,s1,1
    80004550:	008d0793          	addi	a5,s10,8
    80004554:	e0f43023          	sd	a5,-512(s0)
    80004558:	008d3503          	ld	a0,8(s10)
    8000455c:	c909                	beqz	a0,8000456e <exec+0x2a4>
    if(argc >= MAXARG)
    8000455e:	09a1                	addi	s3,s3,8
    80004560:	fb8995e3          	bne	s3,s8,8000450a <exec+0x240>
  ip = 0;
    80004564:	4a01                	li	s4,0
    80004566:	a0fd                	j	80004654 <exec+0x38a>
  sp = sz;
    80004568:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000456c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000456e:	00349793          	slli	a5,s1,0x3
    80004572:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd3d48>
    80004576:	97a2                	add	a5,a5,s0
    80004578:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000457c:	00148693          	addi	a3,s1,1
    80004580:	068e                	slli	a3,a3,0x3
    80004582:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004586:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000458a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000458e:	f57966e3          	bltu	s2,s7,800044da <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004592:	e9040613          	addi	a2,s0,-368
    80004596:	85ca                	mv	a1,s2
    80004598:	855a                	mv	a0,s6
    8000459a:	ffffc097          	auipc	ra,0xffffc
    8000459e:	678080e7          	jalr	1656(ra) # 80000c12 <copyout>
    800045a2:	0e054663          	bltz	a0,8000468e <exec+0x3c4>
  p->trapframe->a1 = sp;
    800045a6:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    800045aa:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045ae:	df843783          	ld	a5,-520(s0)
    800045b2:	0007c703          	lbu	a4,0(a5)
    800045b6:	cf11                	beqz	a4,800045d2 <exec+0x308>
    800045b8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045ba:	02f00693          	li	a3,47
    800045be:	a039                	j	800045cc <exec+0x302>
      last = s+1;
    800045c0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800045c4:	0785                	addi	a5,a5,1
    800045c6:	fff7c703          	lbu	a4,-1(a5)
    800045ca:	c701                	beqz	a4,800045d2 <exec+0x308>
    if(*s == '/')
    800045cc:	fed71ce3          	bne	a4,a3,800045c4 <exec+0x2fa>
    800045d0:	bfc5                	j	800045c0 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    800045d2:	4641                	li	a2,16
    800045d4:	df843583          	ld	a1,-520(s0)
    800045d8:	160a8513          	addi	a0,s5,352
    800045dc:	ffffc097          	auipc	ra,0xffffc
    800045e0:	dca080e7          	jalr	-566(ra) # 800003a6 <safestrcpy>
  oldpagetable = p->pagetable;
    800045e4:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    800045e8:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    800045ec:	e0843783          	ld	a5,-504(s0)
    800045f0:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045f4:	060ab783          	ld	a5,96(s5)
    800045f8:	e6843703          	ld	a4,-408(s0)
    800045fc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045fe:	060ab783          	ld	a5,96(s5)
    80004602:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004606:	85e6                	mv	a1,s9
    80004608:	ffffd097          	auipc	ra,0xffffd
    8000460c:	ace080e7          	jalr	-1330(ra) # 800010d6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004610:	0004851b          	sext.w	a0,s1
    80004614:	79be                	ld	s3,488(sp)
    80004616:	7a1e                	ld	s4,480(sp)
    80004618:	6afe                	ld	s5,472(sp)
    8000461a:	6b5e                	ld	s6,464(sp)
    8000461c:	6bbe                	ld	s7,456(sp)
    8000461e:	6c1e                	ld	s8,448(sp)
    80004620:	7cfa                	ld	s9,440(sp)
    80004622:	7d5a                	ld	s10,432(sp)
    80004624:	bb05                	j	80004354 <exec+0x8a>
    80004626:	e0943423          	sd	s1,-504(s0)
    8000462a:	7dba                	ld	s11,424(sp)
    8000462c:	a025                	j	80004654 <exec+0x38a>
    8000462e:	e0943423          	sd	s1,-504(s0)
    80004632:	7dba                	ld	s11,424(sp)
    80004634:	a005                	j	80004654 <exec+0x38a>
    80004636:	e0943423          	sd	s1,-504(s0)
    8000463a:	7dba                	ld	s11,424(sp)
    8000463c:	a821                	j	80004654 <exec+0x38a>
    8000463e:	e0943423          	sd	s1,-504(s0)
    80004642:	7dba                	ld	s11,424(sp)
    80004644:	a801                	j	80004654 <exec+0x38a>
  ip = 0;
    80004646:	4a01                	li	s4,0
    80004648:	a031                	j	80004654 <exec+0x38a>
    8000464a:	4a01                	li	s4,0
  if(pagetable)
    8000464c:	a021                	j	80004654 <exec+0x38a>
    8000464e:	7dba                	ld	s11,424(sp)
    80004650:	a011                	j	80004654 <exec+0x38a>
    80004652:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004654:	e0843583          	ld	a1,-504(s0)
    80004658:	855a                	mv	a0,s6
    8000465a:	ffffd097          	auipc	ra,0xffffd
    8000465e:	a7c080e7          	jalr	-1412(ra) # 800010d6 <proc_freepagetable>
  return -1;
    80004662:	557d                	li	a0,-1
  if(ip){
    80004664:	000a1b63          	bnez	s4,8000467a <exec+0x3b0>
    80004668:	79be                	ld	s3,488(sp)
    8000466a:	7a1e                	ld	s4,480(sp)
    8000466c:	6afe                	ld	s5,472(sp)
    8000466e:	6b5e                	ld	s6,464(sp)
    80004670:	6bbe                	ld	s7,456(sp)
    80004672:	6c1e                	ld	s8,448(sp)
    80004674:	7cfa                	ld	s9,440(sp)
    80004676:	7d5a                	ld	s10,432(sp)
    80004678:	b9f1                	j	80004354 <exec+0x8a>
    8000467a:	79be                	ld	s3,488(sp)
    8000467c:	6afe                	ld	s5,472(sp)
    8000467e:	6b5e                	ld	s6,464(sp)
    80004680:	6bbe                	ld	s7,456(sp)
    80004682:	6c1e                	ld	s8,448(sp)
    80004684:	7cfa                	ld	s9,440(sp)
    80004686:	7d5a                	ld	s10,432(sp)
    80004688:	b95d                	j	8000433e <exec+0x74>
    8000468a:	6b5e                	ld	s6,464(sp)
    8000468c:	b94d                	j	8000433e <exec+0x74>
  sz = sz1;
    8000468e:	e0843983          	ld	s3,-504(s0)
    80004692:	b5a1                	j	800044da <exec+0x210>

0000000080004694 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004694:	7179                	addi	sp,sp,-48
    80004696:	f406                	sd	ra,40(sp)
    80004698:	f022                	sd	s0,32(sp)
    8000469a:	ec26                	sd	s1,24(sp)
    8000469c:	e84a                	sd	s2,16(sp)
    8000469e:	1800                	addi	s0,sp,48
    800046a0:	892e                	mv	s2,a1
    800046a2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800046a4:	fdc40593          	addi	a1,s0,-36
    800046a8:	ffffe097          	auipc	ra,0xffffe
    800046ac:	98e080e7          	jalr	-1650(ra) # 80002036 <argint>
    800046b0:	04054063          	bltz	a0,800046f0 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046b4:	fdc42703          	lw	a4,-36(s0)
    800046b8:	47bd                	li	a5,15
    800046ba:	02e7ed63          	bltu	a5,a4,800046f4 <argfd+0x60>
    800046be:	ffffd097          	auipc	ra,0xffffd
    800046c2:	8b8080e7          	jalr	-1864(ra) # 80000f76 <myproc>
    800046c6:	fdc42703          	lw	a4,-36(s0)
    800046ca:	01a70793          	addi	a5,a4,26
    800046ce:	078e                	slli	a5,a5,0x3
    800046d0:	953e                	add	a0,a0,a5
    800046d2:	651c                	ld	a5,8(a0)
    800046d4:	c395                	beqz	a5,800046f8 <argfd+0x64>
    return -1;
  if(pfd)
    800046d6:	00090463          	beqz	s2,800046de <argfd+0x4a>
    *pfd = fd;
    800046da:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046de:	4501                	li	a0,0
  if(pf)
    800046e0:	c091                	beqz	s1,800046e4 <argfd+0x50>
    *pf = f;
    800046e2:	e09c                	sd	a5,0(s1)
}
    800046e4:	70a2                	ld	ra,40(sp)
    800046e6:	7402                	ld	s0,32(sp)
    800046e8:	64e2                	ld	s1,24(sp)
    800046ea:	6942                	ld	s2,16(sp)
    800046ec:	6145                	addi	sp,sp,48
    800046ee:	8082                	ret
    return -1;
    800046f0:	557d                	li	a0,-1
    800046f2:	bfcd                	j	800046e4 <argfd+0x50>
    return -1;
    800046f4:	557d                	li	a0,-1
    800046f6:	b7fd                	j	800046e4 <argfd+0x50>
    800046f8:	557d                	li	a0,-1
    800046fa:	b7ed                	j	800046e4 <argfd+0x50>

00000000800046fc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046fc:	1101                	addi	sp,sp,-32
    800046fe:	ec06                	sd	ra,24(sp)
    80004700:	e822                	sd	s0,16(sp)
    80004702:	e426                	sd	s1,8(sp)
    80004704:	1000                	addi	s0,sp,32
    80004706:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004708:	ffffd097          	auipc	ra,0xffffd
    8000470c:	86e080e7          	jalr	-1938(ra) # 80000f76 <myproc>
    80004710:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004712:	0d850793          	addi	a5,a0,216
    80004716:	4501                	li	a0,0
    80004718:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000471a:	6398                	ld	a4,0(a5)
    8000471c:	cb19                	beqz	a4,80004732 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000471e:	2505                	addiw	a0,a0,1
    80004720:	07a1                	addi	a5,a5,8
    80004722:	fed51ce3          	bne	a0,a3,8000471a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004726:	557d                	li	a0,-1
}
    80004728:	60e2                	ld	ra,24(sp)
    8000472a:	6442                	ld	s0,16(sp)
    8000472c:	64a2                	ld	s1,8(sp)
    8000472e:	6105                	addi	sp,sp,32
    80004730:	8082                	ret
      p->ofile[fd] = f;
    80004732:	01a50793          	addi	a5,a0,26
    80004736:	078e                	slli	a5,a5,0x3
    80004738:	963e                	add	a2,a2,a5
    8000473a:	e604                	sd	s1,8(a2)
      return fd;
    8000473c:	b7f5                	j	80004728 <fdalloc+0x2c>

000000008000473e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000473e:	715d                	addi	sp,sp,-80
    80004740:	e486                	sd	ra,72(sp)
    80004742:	e0a2                	sd	s0,64(sp)
    80004744:	fc26                	sd	s1,56(sp)
    80004746:	f84a                	sd	s2,48(sp)
    80004748:	f44e                	sd	s3,40(sp)
    8000474a:	f052                	sd	s4,32(sp)
    8000474c:	ec56                	sd	s5,24(sp)
    8000474e:	0880                	addi	s0,sp,80
    80004750:	8aae                	mv	s5,a1
    80004752:	8a32                	mv	s4,a2
    80004754:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004756:	fb040593          	addi	a1,s0,-80
    8000475a:	fffff097          	auipc	ra,0xfffff
    8000475e:	e0a080e7          	jalr	-502(ra) # 80003564 <nameiparent>
    80004762:	892a                	mv	s2,a0
    80004764:	12050c63          	beqz	a0,8000489c <create+0x15e>
    return 0;

  ilock(dp);
    80004768:	ffffe097          	auipc	ra,0xffffe
    8000476c:	60c080e7          	jalr	1548(ra) # 80002d74 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004770:	4601                	li	a2,0
    80004772:	fb040593          	addi	a1,s0,-80
    80004776:	854a                	mv	a0,s2
    80004778:	fffff097          	auipc	ra,0xfffff
    8000477c:	afc080e7          	jalr	-1284(ra) # 80003274 <dirlookup>
    80004780:	84aa                	mv	s1,a0
    80004782:	c539                	beqz	a0,800047d0 <create+0x92>
    iunlockput(dp);
    80004784:	854a                	mv	a0,s2
    80004786:	fffff097          	auipc	ra,0xfffff
    8000478a:	854080e7          	jalr	-1964(ra) # 80002fda <iunlockput>
    ilock(ip);
    8000478e:	8526                	mv	a0,s1
    80004790:	ffffe097          	auipc	ra,0xffffe
    80004794:	5e4080e7          	jalr	1508(ra) # 80002d74 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004798:	4789                	li	a5,2
    8000479a:	02fa9463          	bne	s5,a5,800047c2 <create+0x84>
    8000479e:	04c4d783          	lhu	a5,76(s1)
    800047a2:	37f9                	addiw	a5,a5,-2
    800047a4:	17c2                	slli	a5,a5,0x30
    800047a6:	93c1                	srli	a5,a5,0x30
    800047a8:	4705                	li	a4,1
    800047aa:	00f76c63          	bltu	a4,a5,800047c2 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800047ae:	8526                	mv	a0,s1
    800047b0:	60a6                	ld	ra,72(sp)
    800047b2:	6406                	ld	s0,64(sp)
    800047b4:	74e2                	ld	s1,56(sp)
    800047b6:	7942                	ld	s2,48(sp)
    800047b8:	79a2                	ld	s3,40(sp)
    800047ba:	7a02                	ld	s4,32(sp)
    800047bc:	6ae2                	ld	s5,24(sp)
    800047be:	6161                	addi	sp,sp,80
    800047c0:	8082                	ret
    iunlockput(ip);
    800047c2:	8526                	mv	a0,s1
    800047c4:	fffff097          	auipc	ra,0xfffff
    800047c8:	816080e7          	jalr	-2026(ra) # 80002fda <iunlockput>
    return 0;
    800047cc:	4481                	li	s1,0
    800047ce:	b7c5                	j	800047ae <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047d0:	85d6                	mv	a1,s5
    800047d2:	00092503          	lw	a0,0(s2)
    800047d6:	ffffe097          	auipc	ra,0xffffe
    800047da:	40a080e7          	jalr	1034(ra) # 80002be0 <ialloc>
    800047de:	84aa                	mv	s1,a0
    800047e0:	c139                	beqz	a0,80004826 <create+0xe8>
  ilock(ip);
    800047e2:	ffffe097          	auipc	ra,0xffffe
    800047e6:	592080e7          	jalr	1426(ra) # 80002d74 <ilock>
  ip->major = major;
    800047ea:	05449723          	sh	s4,78(s1)
  ip->minor = minor;
    800047ee:	05349823          	sh	s3,80(s1)
  ip->nlink = 1;
    800047f2:	4985                	li	s3,1
    800047f4:	05349923          	sh	s3,82(s1)
  iupdate(ip);
    800047f8:	8526                	mv	a0,s1
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	4ae080e7          	jalr	1198(ra) # 80002ca8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004802:	033a8a63          	beq	s5,s3,80004836 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004806:	40d0                	lw	a2,4(s1)
    80004808:	fb040593          	addi	a1,s0,-80
    8000480c:	854a                	mv	a0,s2
    8000480e:	fffff097          	auipc	ra,0xfffff
    80004812:	c76080e7          	jalr	-906(ra) # 80003484 <dirlink>
    80004816:	06054b63          	bltz	a0,8000488c <create+0x14e>
  iunlockput(dp);
    8000481a:	854a                	mv	a0,s2
    8000481c:	ffffe097          	auipc	ra,0xffffe
    80004820:	7be080e7          	jalr	1982(ra) # 80002fda <iunlockput>
  return ip;
    80004824:	b769                	j	800047ae <create+0x70>
    panic("create: ialloc");
    80004826:	00004517          	auipc	a0,0x4
    8000482a:	d5a50513          	addi	a0,a0,-678 # 80008580 <etext+0x580>
    8000482e:	00002097          	auipc	ra,0x2
    80004832:	a38080e7          	jalr	-1480(ra) # 80006266 <panic>
    dp->nlink++;  // for ".."
    80004836:	05295783          	lhu	a5,82(s2)
    8000483a:	2785                	addiw	a5,a5,1
    8000483c:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    80004840:	854a                	mv	a0,s2
    80004842:	ffffe097          	auipc	ra,0xffffe
    80004846:	466080e7          	jalr	1126(ra) # 80002ca8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000484a:	40d0                	lw	a2,4(s1)
    8000484c:	00004597          	auipc	a1,0x4
    80004850:	d4458593          	addi	a1,a1,-700 # 80008590 <etext+0x590>
    80004854:	8526                	mv	a0,s1
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	c2e080e7          	jalr	-978(ra) # 80003484 <dirlink>
    8000485e:	00054f63          	bltz	a0,8000487c <create+0x13e>
    80004862:	00492603          	lw	a2,4(s2)
    80004866:	00004597          	auipc	a1,0x4
    8000486a:	d3258593          	addi	a1,a1,-718 # 80008598 <etext+0x598>
    8000486e:	8526                	mv	a0,s1
    80004870:	fffff097          	auipc	ra,0xfffff
    80004874:	c14080e7          	jalr	-1004(ra) # 80003484 <dirlink>
    80004878:	f80557e3          	bgez	a0,80004806 <create+0xc8>
      panic("create dots");
    8000487c:	00004517          	auipc	a0,0x4
    80004880:	d2450513          	addi	a0,a0,-732 # 800085a0 <etext+0x5a0>
    80004884:	00002097          	auipc	ra,0x2
    80004888:	9e2080e7          	jalr	-1566(ra) # 80006266 <panic>
    panic("create: dirlink");
    8000488c:	00004517          	auipc	a0,0x4
    80004890:	d2450513          	addi	a0,a0,-732 # 800085b0 <etext+0x5b0>
    80004894:	00002097          	auipc	ra,0x2
    80004898:	9d2080e7          	jalr	-1582(ra) # 80006266 <panic>
    return 0;
    8000489c:	84aa                	mv	s1,a0
    8000489e:	bf01                	j	800047ae <create+0x70>

00000000800048a0 <sys_dup>:
{
    800048a0:	7179                	addi	sp,sp,-48
    800048a2:	f406                	sd	ra,40(sp)
    800048a4:	f022                	sd	s0,32(sp)
    800048a6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048a8:	fd840613          	addi	a2,s0,-40
    800048ac:	4581                	li	a1,0
    800048ae:	4501                	li	a0,0
    800048b0:	00000097          	auipc	ra,0x0
    800048b4:	de4080e7          	jalr	-540(ra) # 80004694 <argfd>
    return -1;
    800048b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048ba:	02054763          	bltz	a0,800048e8 <sys_dup+0x48>
    800048be:	ec26                	sd	s1,24(sp)
    800048c0:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800048c2:	fd843903          	ld	s2,-40(s0)
    800048c6:	854a                	mv	a0,s2
    800048c8:	00000097          	auipc	ra,0x0
    800048cc:	e34080e7          	jalr	-460(ra) # 800046fc <fdalloc>
    800048d0:	84aa                	mv	s1,a0
    return -1;
    800048d2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048d4:	00054f63          	bltz	a0,800048f2 <sys_dup+0x52>
  filedup(f);
    800048d8:	854a                	mv	a0,s2
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	2e4080e7          	jalr	740(ra) # 80003bbe <filedup>
  return fd;
    800048e2:	87a6                	mv	a5,s1
    800048e4:	64e2                	ld	s1,24(sp)
    800048e6:	6942                	ld	s2,16(sp)
}
    800048e8:	853e                	mv	a0,a5
    800048ea:	70a2                	ld	ra,40(sp)
    800048ec:	7402                	ld	s0,32(sp)
    800048ee:	6145                	addi	sp,sp,48
    800048f0:	8082                	ret
    800048f2:	64e2                	ld	s1,24(sp)
    800048f4:	6942                	ld	s2,16(sp)
    800048f6:	bfcd                	j	800048e8 <sys_dup+0x48>

00000000800048f8 <sys_read>:
{
    800048f8:	7179                	addi	sp,sp,-48
    800048fa:	f406                	sd	ra,40(sp)
    800048fc:	f022                	sd	s0,32(sp)
    800048fe:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004900:	fe840613          	addi	a2,s0,-24
    80004904:	4581                	li	a1,0
    80004906:	4501                	li	a0,0
    80004908:	00000097          	auipc	ra,0x0
    8000490c:	d8c080e7          	jalr	-628(ra) # 80004694 <argfd>
    return -1;
    80004910:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004912:	04054163          	bltz	a0,80004954 <sys_read+0x5c>
    80004916:	fe440593          	addi	a1,s0,-28
    8000491a:	4509                	li	a0,2
    8000491c:	ffffd097          	auipc	ra,0xffffd
    80004920:	71a080e7          	jalr	1818(ra) # 80002036 <argint>
    return -1;
    80004924:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004926:	02054763          	bltz	a0,80004954 <sys_read+0x5c>
    8000492a:	fd840593          	addi	a1,s0,-40
    8000492e:	4505                	li	a0,1
    80004930:	ffffd097          	auipc	ra,0xffffd
    80004934:	728080e7          	jalr	1832(ra) # 80002058 <argaddr>
    return -1;
    80004938:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000493a:	00054d63          	bltz	a0,80004954 <sys_read+0x5c>
  return fileread(f, p, n);
    8000493e:	fe442603          	lw	a2,-28(s0)
    80004942:	fd843583          	ld	a1,-40(s0)
    80004946:	fe843503          	ld	a0,-24(s0)
    8000494a:	fffff097          	auipc	ra,0xfffff
    8000494e:	41a080e7          	jalr	1050(ra) # 80003d64 <fileread>
    80004952:	87aa                	mv	a5,a0
}
    80004954:	853e                	mv	a0,a5
    80004956:	70a2                	ld	ra,40(sp)
    80004958:	7402                	ld	s0,32(sp)
    8000495a:	6145                	addi	sp,sp,48
    8000495c:	8082                	ret

000000008000495e <sys_write>:
{
    8000495e:	7179                	addi	sp,sp,-48
    80004960:	f406                	sd	ra,40(sp)
    80004962:	f022                	sd	s0,32(sp)
    80004964:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004966:	fe840613          	addi	a2,s0,-24
    8000496a:	4581                	li	a1,0
    8000496c:	4501                	li	a0,0
    8000496e:	00000097          	auipc	ra,0x0
    80004972:	d26080e7          	jalr	-730(ra) # 80004694 <argfd>
    return -1;
    80004976:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004978:	04054163          	bltz	a0,800049ba <sys_write+0x5c>
    8000497c:	fe440593          	addi	a1,s0,-28
    80004980:	4509                	li	a0,2
    80004982:	ffffd097          	auipc	ra,0xffffd
    80004986:	6b4080e7          	jalr	1716(ra) # 80002036 <argint>
    return -1;
    8000498a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000498c:	02054763          	bltz	a0,800049ba <sys_write+0x5c>
    80004990:	fd840593          	addi	a1,s0,-40
    80004994:	4505                	li	a0,1
    80004996:	ffffd097          	auipc	ra,0xffffd
    8000499a:	6c2080e7          	jalr	1730(ra) # 80002058 <argaddr>
    return -1;
    8000499e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049a0:	00054d63          	bltz	a0,800049ba <sys_write+0x5c>
  return filewrite(f, p, n);
    800049a4:	fe442603          	lw	a2,-28(s0)
    800049a8:	fd843583          	ld	a1,-40(s0)
    800049ac:	fe843503          	ld	a0,-24(s0)
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	486080e7          	jalr	1158(ra) # 80003e36 <filewrite>
    800049b8:	87aa                	mv	a5,a0
}
    800049ba:	853e                	mv	a0,a5
    800049bc:	70a2                	ld	ra,40(sp)
    800049be:	7402                	ld	s0,32(sp)
    800049c0:	6145                	addi	sp,sp,48
    800049c2:	8082                	ret

00000000800049c4 <sys_close>:
{
    800049c4:	1101                	addi	sp,sp,-32
    800049c6:	ec06                	sd	ra,24(sp)
    800049c8:	e822                	sd	s0,16(sp)
    800049ca:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049cc:	fe040613          	addi	a2,s0,-32
    800049d0:	fec40593          	addi	a1,s0,-20
    800049d4:	4501                	li	a0,0
    800049d6:	00000097          	auipc	ra,0x0
    800049da:	cbe080e7          	jalr	-834(ra) # 80004694 <argfd>
    return -1;
    800049de:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049e0:	02054463          	bltz	a0,80004a08 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049e4:	ffffc097          	auipc	ra,0xffffc
    800049e8:	592080e7          	jalr	1426(ra) # 80000f76 <myproc>
    800049ec:	fec42783          	lw	a5,-20(s0)
    800049f0:	07e9                	addi	a5,a5,26
    800049f2:	078e                	slli	a5,a5,0x3
    800049f4:	953e                	add	a0,a0,a5
    800049f6:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800049fa:	fe043503          	ld	a0,-32(s0)
    800049fe:	fffff097          	auipc	ra,0xfffff
    80004a02:	212080e7          	jalr	530(ra) # 80003c10 <fileclose>
  return 0;
    80004a06:	4781                	li	a5,0
}
    80004a08:	853e                	mv	a0,a5
    80004a0a:	60e2                	ld	ra,24(sp)
    80004a0c:	6442                	ld	s0,16(sp)
    80004a0e:	6105                	addi	sp,sp,32
    80004a10:	8082                	ret

0000000080004a12 <sys_fstat>:
{
    80004a12:	1101                	addi	sp,sp,-32
    80004a14:	ec06                	sd	ra,24(sp)
    80004a16:	e822                	sd	s0,16(sp)
    80004a18:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a1a:	fe840613          	addi	a2,s0,-24
    80004a1e:	4581                	li	a1,0
    80004a20:	4501                	li	a0,0
    80004a22:	00000097          	auipc	ra,0x0
    80004a26:	c72080e7          	jalr	-910(ra) # 80004694 <argfd>
    return -1;
    80004a2a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a2c:	02054563          	bltz	a0,80004a56 <sys_fstat+0x44>
    80004a30:	fe040593          	addi	a1,s0,-32
    80004a34:	4505                	li	a0,1
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	622080e7          	jalr	1570(ra) # 80002058 <argaddr>
    return -1;
    80004a3e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a40:	00054b63          	bltz	a0,80004a56 <sys_fstat+0x44>
  return filestat(f, st);
    80004a44:	fe043583          	ld	a1,-32(s0)
    80004a48:	fe843503          	ld	a0,-24(s0)
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	2a6080e7          	jalr	678(ra) # 80003cf2 <filestat>
    80004a54:	87aa                	mv	a5,a0
}
    80004a56:	853e                	mv	a0,a5
    80004a58:	60e2                	ld	ra,24(sp)
    80004a5a:	6442                	ld	s0,16(sp)
    80004a5c:	6105                	addi	sp,sp,32
    80004a5e:	8082                	ret

0000000080004a60 <sys_link>:
{
    80004a60:	7169                	addi	sp,sp,-304
    80004a62:	f606                	sd	ra,296(sp)
    80004a64:	f222                	sd	s0,288(sp)
    80004a66:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a68:	08000613          	li	a2,128
    80004a6c:	ed040593          	addi	a1,s0,-304
    80004a70:	4501                	li	a0,0
    80004a72:	ffffd097          	auipc	ra,0xffffd
    80004a76:	608080e7          	jalr	1544(ra) # 8000207a <argstr>
    return -1;
    80004a7a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a7c:	12054663          	bltz	a0,80004ba8 <sys_link+0x148>
    80004a80:	08000613          	li	a2,128
    80004a84:	f5040593          	addi	a1,s0,-176
    80004a88:	4505                	li	a0,1
    80004a8a:	ffffd097          	auipc	ra,0xffffd
    80004a8e:	5f0080e7          	jalr	1520(ra) # 8000207a <argstr>
    return -1;
    80004a92:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a94:	10054a63          	bltz	a0,80004ba8 <sys_link+0x148>
    80004a98:	ee26                	sd	s1,280(sp)
  begin_op();
    80004a9a:	fffff097          	auipc	ra,0xfffff
    80004a9e:	cac080e7          	jalr	-852(ra) # 80003746 <begin_op>
  if((ip = namei(old)) == 0){
    80004aa2:	ed040513          	addi	a0,s0,-304
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	aa0080e7          	jalr	-1376(ra) # 80003546 <namei>
    80004aae:	84aa                	mv	s1,a0
    80004ab0:	c949                	beqz	a0,80004b42 <sys_link+0xe2>
  ilock(ip);
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	2c2080e7          	jalr	706(ra) # 80002d74 <ilock>
  if(ip->type == T_DIR){
    80004aba:	04c49703          	lh	a4,76(s1)
    80004abe:	4785                	li	a5,1
    80004ac0:	08f70863          	beq	a4,a5,80004b50 <sys_link+0xf0>
    80004ac4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004ac6:	0524d783          	lhu	a5,82(s1)
    80004aca:	2785                	addiw	a5,a5,1
    80004acc:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004ad0:	8526                	mv	a0,s1
    80004ad2:	ffffe097          	auipc	ra,0xffffe
    80004ad6:	1d6080e7          	jalr	470(ra) # 80002ca8 <iupdate>
  iunlock(ip);
    80004ada:	8526                	mv	a0,s1
    80004adc:	ffffe097          	auipc	ra,0xffffe
    80004ae0:	35e080e7          	jalr	862(ra) # 80002e3a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ae4:	fd040593          	addi	a1,s0,-48
    80004ae8:	f5040513          	addi	a0,s0,-176
    80004aec:	fffff097          	auipc	ra,0xfffff
    80004af0:	a78080e7          	jalr	-1416(ra) # 80003564 <nameiparent>
    80004af4:	892a                	mv	s2,a0
    80004af6:	cd35                	beqz	a0,80004b72 <sys_link+0x112>
  ilock(dp);
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	27c080e7          	jalr	636(ra) # 80002d74 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b00:	00092703          	lw	a4,0(s2)
    80004b04:	409c                	lw	a5,0(s1)
    80004b06:	06f71163          	bne	a4,a5,80004b68 <sys_link+0x108>
    80004b0a:	40d0                	lw	a2,4(s1)
    80004b0c:	fd040593          	addi	a1,s0,-48
    80004b10:	854a                	mv	a0,s2
    80004b12:	fffff097          	auipc	ra,0xfffff
    80004b16:	972080e7          	jalr	-1678(ra) # 80003484 <dirlink>
    80004b1a:	04054763          	bltz	a0,80004b68 <sys_link+0x108>
  iunlockput(dp);
    80004b1e:	854a                	mv	a0,s2
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	4ba080e7          	jalr	1210(ra) # 80002fda <iunlockput>
  iput(ip);
    80004b28:	8526                	mv	a0,s1
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	408080e7          	jalr	1032(ra) # 80002f32 <iput>
  end_op();
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	c8e080e7          	jalr	-882(ra) # 800037c0 <end_op>
  return 0;
    80004b3a:	4781                	li	a5,0
    80004b3c:	64f2                	ld	s1,280(sp)
    80004b3e:	6952                	ld	s2,272(sp)
    80004b40:	a0a5                	j	80004ba8 <sys_link+0x148>
    end_op();
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	c7e080e7          	jalr	-898(ra) # 800037c0 <end_op>
    return -1;
    80004b4a:	57fd                	li	a5,-1
    80004b4c:	64f2                	ld	s1,280(sp)
    80004b4e:	a8a9                	j	80004ba8 <sys_link+0x148>
    iunlockput(ip);
    80004b50:	8526                	mv	a0,s1
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	488080e7          	jalr	1160(ra) # 80002fda <iunlockput>
    end_op();
    80004b5a:	fffff097          	auipc	ra,0xfffff
    80004b5e:	c66080e7          	jalr	-922(ra) # 800037c0 <end_op>
    return -1;
    80004b62:	57fd                	li	a5,-1
    80004b64:	64f2                	ld	s1,280(sp)
    80004b66:	a089                	j	80004ba8 <sys_link+0x148>
    iunlockput(dp);
    80004b68:	854a                	mv	a0,s2
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	470080e7          	jalr	1136(ra) # 80002fda <iunlockput>
  ilock(ip);
    80004b72:	8526                	mv	a0,s1
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	200080e7          	jalr	512(ra) # 80002d74 <ilock>
  ip->nlink--;
    80004b7c:	0524d783          	lhu	a5,82(s1)
    80004b80:	37fd                	addiw	a5,a5,-1
    80004b82:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004b86:	8526                	mv	a0,s1
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	120080e7          	jalr	288(ra) # 80002ca8 <iupdate>
  iunlockput(ip);
    80004b90:	8526                	mv	a0,s1
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	448080e7          	jalr	1096(ra) # 80002fda <iunlockput>
  end_op();
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	c26080e7          	jalr	-986(ra) # 800037c0 <end_op>
  return -1;
    80004ba2:	57fd                	li	a5,-1
    80004ba4:	64f2                	ld	s1,280(sp)
    80004ba6:	6952                	ld	s2,272(sp)
}
    80004ba8:	853e                	mv	a0,a5
    80004baa:	70b2                	ld	ra,296(sp)
    80004bac:	7412                	ld	s0,288(sp)
    80004bae:	6155                	addi	sp,sp,304
    80004bb0:	8082                	ret

0000000080004bb2 <sys_unlink>:
{
    80004bb2:	7151                	addi	sp,sp,-240
    80004bb4:	f586                	sd	ra,232(sp)
    80004bb6:	f1a2                	sd	s0,224(sp)
    80004bb8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004bba:	08000613          	li	a2,128
    80004bbe:	f3040593          	addi	a1,s0,-208
    80004bc2:	4501                	li	a0,0
    80004bc4:	ffffd097          	auipc	ra,0xffffd
    80004bc8:	4b6080e7          	jalr	1206(ra) # 8000207a <argstr>
    80004bcc:	1a054a63          	bltz	a0,80004d80 <sys_unlink+0x1ce>
    80004bd0:	eda6                	sd	s1,216(sp)
  begin_op();
    80004bd2:	fffff097          	auipc	ra,0xfffff
    80004bd6:	b74080e7          	jalr	-1164(ra) # 80003746 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bda:	fb040593          	addi	a1,s0,-80
    80004bde:	f3040513          	addi	a0,s0,-208
    80004be2:	fffff097          	auipc	ra,0xfffff
    80004be6:	982080e7          	jalr	-1662(ra) # 80003564 <nameiparent>
    80004bea:	84aa                	mv	s1,a0
    80004bec:	cd71                	beqz	a0,80004cc8 <sys_unlink+0x116>
  ilock(dp);
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	186080e7          	jalr	390(ra) # 80002d74 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bf6:	00004597          	auipc	a1,0x4
    80004bfa:	99a58593          	addi	a1,a1,-1638 # 80008590 <etext+0x590>
    80004bfe:	fb040513          	addi	a0,s0,-80
    80004c02:	ffffe097          	auipc	ra,0xffffe
    80004c06:	658080e7          	jalr	1624(ra) # 8000325a <namecmp>
    80004c0a:	14050c63          	beqz	a0,80004d62 <sys_unlink+0x1b0>
    80004c0e:	00004597          	auipc	a1,0x4
    80004c12:	98a58593          	addi	a1,a1,-1654 # 80008598 <etext+0x598>
    80004c16:	fb040513          	addi	a0,s0,-80
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	640080e7          	jalr	1600(ra) # 8000325a <namecmp>
    80004c22:	14050063          	beqz	a0,80004d62 <sys_unlink+0x1b0>
    80004c26:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c28:	f2c40613          	addi	a2,s0,-212
    80004c2c:	fb040593          	addi	a1,s0,-80
    80004c30:	8526                	mv	a0,s1
    80004c32:	ffffe097          	auipc	ra,0xffffe
    80004c36:	642080e7          	jalr	1602(ra) # 80003274 <dirlookup>
    80004c3a:	892a                	mv	s2,a0
    80004c3c:	12050263          	beqz	a0,80004d60 <sys_unlink+0x1ae>
  ilock(ip);
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	134080e7          	jalr	308(ra) # 80002d74 <ilock>
  if(ip->nlink < 1)
    80004c48:	05291783          	lh	a5,82(s2)
    80004c4c:	08f05563          	blez	a5,80004cd6 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c50:	04c91703          	lh	a4,76(s2)
    80004c54:	4785                	li	a5,1
    80004c56:	08f70963          	beq	a4,a5,80004ce8 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004c5a:	4641                	li	a2,16
    80004c5c:	4581                	li	a1,0
    80004c5e:	fc040513          	addi	a0,s0,-64
    80004c62:	ffffb097          	auipc	ra,0xffffb
    80004c66:	602080e7          	jalr	1538(ra) # 80000264 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c6a:	4741                	li	a4,16
    80004c6c:	f2c42683          	lw	a3,-212(s0)
    80004c70:	fc040613          	addi	a2,s0,-64
    80004c74:	4581                	li	a1,0
    80004c76:	8526                	mv	a0,s1
    80004c78:	ffffe097          	auipc	ra,0xffffe
    80004c7c:	4b8080e7          	jalr	1208(ra) # 80003130 <writei>
    80004c80:	47c1                	li	a5,16
    80004c82:	0af51b63          	bne	a0,a5,80004d38 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004c86:	04c91703          	lh	a4,76(s2)
    80004c8a:	4785                	li	a5,1
    80004c8c:	0af70f63          	beq	a4,a5,80004d4a <sys_unlink+0x198>
  iunlockput(dp);
    80004c90:	8526                	mv	a0,s1
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	348080e7          	jalr	840(ra) # 80002fda <iunlockput>
  ip->nlink--;
    80004c9a:	05295783          	lhu	a5,82(s2)
    80004c9e:	37fd                	addiw	a5,a5,-1
    80004ca0:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004ca4:	854a                	mv	a0,s2
    80004ca6:	ffffe097          	auipc	ra,0xffffe
    80004caa:	002080e7          	jalr	2(ra) # 80002ca8 <iupdate>
  iunlockput(ip);
    80004cae:	854a                	mv	a0,s2
    80004cb0:	ffffe097          	auipc	ra,0xffffe
    80004cb4:	32a080e7          	jalr	810(ra) # 80002fda <iunlockput>
  end_op();
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	b08080e7          	jalr	-1272(ra) # 800037c0 <end_op>
  return 0;
    80004cc0:	4501                	li	a0,0
    80004cc2:	64ee                	ld	s1,216(sp)
    80004cc4:	694e                	ld	s2,208(sp)
    80004cc6:	a84d                	j	80004d78 <sys_unlink+0x1c6>
    end_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	af8080e7          	jalr	-1288(ra) # 800037c0 <end_op>
    return -1;
    80004cd0:	557d                	li	a0,-1
    80004cd2:	64ee                	ld	s1,216(sp)
    80004cd4:	a055                	j	80004d78 <sys_unlink+0x1c6>
    80004cd6:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004cd8:	00004517          	auipc	a0,0x4
    80004cdc:	8e850513          	addi	a0,a0,-1816 # 800085c0 <etext+0x5c0>
    80004ce0:	00001097          	auipc	ra,0x1
    80004ce4:	586080e7          	jalr	1414(ra) # 80006266 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ce8:	05492703          	lw	a4,84(s2)
    80004cec:	02000793          	li	a5,32
    80004cf0:	f6e7f5e3          	bgeu	a5,a4,80004c5a <sys_unlink+0xa8>
    80004cf4:	e5ce                	sd	s3,200(sp)
    80004cf6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cfa:	4741                	li	a4,16
    80004cfc:	86ce                	mv	a3,s3
    80004cfe:	f1840613          	addi	a2,s0,-232
    80004d02:	4581                	li	a1,0
    80004d04:	854a                	mv	a0,s2
    80004d06:	ffffe097          	auipc	ra,0xffffe
    80004d0a:	326080e7          	jalr	806(ra) # 8000302c <readi>
    80004d0e:	47c1                	li	a5,16
    80004d10:	00f51c63          	bne	a0,a5,80004d28 <sys_unlink+0x176>
    if(de.inum != 0)
    80004d14:	f1845783          	lhu	a5,-232(s0)
    80004d18:	e7b5                	bnez	a5,80004d84 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d1a:	29c1                	addiw	s3,s3,16
    80004d1c:	05492783          	lw	a5,84(s2)
    80004d20:	fcf9ede3          	bltu	s3,a5,80004cfa <sys_unlink+0x148>
    80004d24:	69ae                	ld	s3,200(sp)
    80004d26:	bf15                	j	80004c5a <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004d28:	00004517          	auipc	a0,0x4
    80004d2c:	8b050513          	addi	a0,a0,-1872 # 800085d8 <etext+0x5d8>
    80004d30:	00001097          	auipc	ra,0x1
    80004d34:	536080e7          	jalr	1334(ra) # 80006266 <panic>
    80004d38:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004d3a:	00004517          	auipc	a0,0x4
    80004d3e:	8b650513          	addi	a0,a0,-1866 # 800085f0 <etext+0x5f0>
    80004d42:	00001097          	auipc	ra,0x1
    80004d46:	524080e7          	jalr	1316(ra) # 80006266 <panic>
    dp->nlink--;
    80004d4a:	0524d783          	lhu	a5,82(s1)
    80004d4e:	37fd                	addiw	a5,a5,-1
    80004d50:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004d54:	8526                	mv	a0,s1
    80004d56:	ffffe097          	auipc	ra,0xffffe
    80004d5a:	f52080e7          	jalr	-174(ra) # 80002ca8 <iupdate>
    80004d5e:	bf0d                	j	80004c90 <sys_unlink+0xde>
    80004d60:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004d62:	8526                	mv	a0,s1
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	276080e7          	jalr	630(ra) # 80002fda <iunlockput>
  end_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	a54080e7          	jalr	-1452(ra) # 800037c0 <end_op>
  return -1;
    80004d74:	557d                	li	a0,-1
    80004d76:	64ee                	ld	s1,216(sp)
}
    80004d78:	70ae                	ld	ra,232(sp)
    80004d7a:	740e                	ld	s0,224(sp)
    80004d7c:	616d                	addi	sp,sp,240
    80004d7e:	8082                	ret
    return -1;
    80004d80:	557d                	li	a0,-1
    80004d82:	bfdd                	j	80004d78 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004d84:	854a                	mv	a0,s2
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	254080e7          	jalr	596(ra) # 80002fda <iunlockput>
    goto bad;
    80004d8e:	694e                	ld	s2,208(sp)
    80004d90:	69ae                	ld	s3,200(sp)
    80004d92:	bfc1                	j	80004d62 <sys_unlink+0x1b0>

0000000080004d94 <sys_open>:

uint64
sys_open(void)
{
    80004d94:	7131                	addi	sp,sp,-192
    80004d96:	fd06                	sd	ra,184(sp)
    80004d98:	f922                	sd	s0,176(sp)
    80004d9a:	f526                	sd	s1,168(sp)
    80004d9c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d9e:	08000613          	li	a2,128
    80004da2:	f5040593          	addi	a1,s0,-176
    80004da6:	4501                	li	a0,0
    80004da8:	ffffd097          	auipc	ra,0xffffd
    80004dac:	2d2080e7          	jalr	722(ra) # 8000207a <argstr>
    return -1;
    80004db0:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004db2:	0c054463          	bltz	a0,80004e7a <sys_open+0xe6>
    80004db6:	f4c40593          	addi	a1,s0,-180
    80004dba:	4505                	li	a0,1
    80004dbc:	ffffd097          	auipc	ra,0xffffd
    80004dc0:	27a080e7          	jalr	634(ra) # 80002036 <argint>
    80004dc4:	0a054b63          	bltz	a0,80004e7a <sys_open+0xe6>
    80004dc8:	f14a                	sd	s2,160(sp)

  begin_op();
    80004dca:	fffff097          	auipc	ra,0xfffff
    80004dce:	97c080e7          	jalr	-1668(ra) # 80003746 <begin_op>

  if(omode & O_CREATE){
    80004dd2:	f4c42783          	lw	a5,-180(s0)
    80004dd6:	2007f793          	andi	a5,a5,512
    80004dda:	cfc5                	beqz	a5,80004e92 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ddc:	4681                	li	a3,0
    80004dde:	4601                	li	a2,0
    80004de0:	4589                	li	a1,2
    80004de2:	f5040513          	addi	a0,s0,-176
    80004de6:	00000097          	auipc	ra,0x0
    80004dea:	958080e7          	jalr	-1704(ra) # 8000473e <create>
    80004dee:	892a                	mv	s2,a0
    if(ip == 0){
    80004df0:	c959                	beqz	a0,80004e86 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004df2:	04c91703          	lh	a4,76(s2)
    80004df6:	478d                	li	a5,3
    80004df8:	00f71763          	bne	a4,a5,80004e06 <sys_open+0x72>
    80004dfc:	04e95703          	lhu	a4,78(s2)
    80004e00:	47a5                	li	a5,9
    80004e02:	0ce7ef63          	bltu	a5,a4,80004ee0 <sys_open+0x14c>
    80004e06:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	d4c080e7          	jalr	-692(ra) # 80003b54 <filealloc>
    80004e10:	89aa                	mv	s3,a0
    80004e12:	c965                	beqz	a0,80004f02 <sys_open+0x16e>
    80004e14:	00000097          	auipc	ra,0x0
    80004e18:	8e8080e7          	jalr	-1816(ra) # 800046fc <fdalloc>
    80004e1c:	84aa                	mv	s1,a0
    80004e1e:	0c054d63          	bltz	a0,80004ef8 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e22:	04c91703          	lh	a4,76(s2)
    80004e26:	478d                	li	a5,3
    80004e28:	0ef70a63          	beq	a4,a5,80004f1c <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e2c:	4789                	li	a5,2
    80004e2e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e32:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e36:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e3a:	f4c42783          	lw	a5,-180(s0)
    80004e3e:	0017c713          	xori	a4,a5,1
    80004e42:	8b05                	andi	a4,a4,1
    80004e44:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e48:	0037f713          	andi	a4,a5,3
    80004e4c:	00e03733          	snez	a4,a4
    80004e50:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e54:	4007f793          	andi	a5,a5,1024
    80004e58:	c791                	beqz	a5,80004e64 <sys_open+0xd0>
    80004e5a:	04c91703          	lh	a4,76(s2)
    80004e5e:	4789                	li	a5,2
    80004e60:	0cf70563          	beq	a4,a5,80004f2a <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004e64:	854a                	mv	a0,s2
    80004e66:	ffffe097          	auipc	ra,0xffffe
    80004e6a:	fd4080e7          	jalr	-44(ra) # 80002e3a <iunlock>
  end_op();
    80004e6e:	fffff097          	auipc	ra,0xfffff
    80004e72:	952080e7          	jalr	-1710(ra) # 800037c0 <end_op>
    80004e76:	790a                	ld	s2,160(sp)
    80004e78:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004e7a:	8526                	mv	a0,s1
    80004e7c:	70ea                	ld	ra,184(sp)
    80004e7e:	744a                	ld	s0,176(sp)
    80004e80:	74aa                	ld	s1,168(sp)
    80004e82:	6129                	addi	sp,sp,192
    80004e84:	8082                	ret
      end_op();
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	93a080e7          	jalr	-1734(ra) # 800037c0 <end_op>
      return -1;
    80004e8e:	790a                	ld	s2,160(sp)
    80004e90:	b7ed                	j	80004e7a <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004e92:	f5040513          	addi	a0,s0,-176
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	6b0080e7          	jalr	1712(ra) # 80003546 <namei>
    80004e9e:	892a                	mv	s2,a0
    80004ea0:	c90d                	beqz	a0,80004ed2 <sys_open+0x13e>
    ilock(ip);
    80004ea2:	ffffe097          	auipc	ra,0xffffe
    80004ea6:	ed2080e7          	jalr	-302(ra) # 80002d74 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004eaa:	04c91703          	lh	a4,76(s2)
    80004eae:	4785                	li	a5,1
    80004eb0:	f4f711e3          	bne	a4,a5,80004df2 <sys_open+0x5e>
    80004eb4:	f4c42783          	lw	a5,-180(s0)
    80004eb8:	d7b9                	beqz	a5,80004e06 <sys_open+0x72>
      iunlockput(ip);
    80004eba:	854a                	mv	a0,s2
    80004ebc:	ffffe097          	auipc	ra,0xffffe
    80004ec0:	11e080e7          	jalr	286(ra) # 80002fda <iunlockput>
      end_op();
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	8fc080e7          	jalr	-1796(ra) # 800037c0 <end_op>
      return -1;
    80004ecc:	54fd                	li	s1,-1
    80004ece:	790a                	ld	s2,160(sp)
    80004ed0:	b76d                	j	80004e7a <sys_open+0xe6>
      end_op();
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	8ee080e7          	jalr	-1810(ra) # 800037c0 <end_op>
      return -1;
    80004eda:	54fd                	li	s1,-1
    80004edc:	790a                	ld	s2,160(sp)
    80004ede:	bf71                	j	80004e7a <sys_open+0xe6>
    iunlockput(ip);
    80004ee0:	854a                	mv	a0,s2
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	0f8080e7          	jalr	248(ra) # 80002fda <iunlockput>
    end_op();
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	8d6080e7          	jalr	-1834(ra) # 800037c0 <end_op>
    return -1;
    80004ef2:	54fd                	li	s1,-1
    80004ef4:	790a                	ld	s2,160(sp)
    80004ef6:	b751                	j	80004e7a <sys_open+0xe6>
      fileclose(f);
    80004ef8:	854e                	mv	a0,s3
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	d16080e7          	jalr	-746(ra) # 80003c10 <fileclose>
    iunlockput(ip);
    80004f02:	854a                	mv	a0,s2
    80004f04:	ffffe097          	auipc	ra,0xffffe
    80004f08:	0d6080e7          	jalr	214(ra) # 80002fda <iunlockput>
    end_op();
    80004f0c:	fffff097          	auipc	ra,0xfffff
    80004f10:	8b4080e7          	jalr	-1868(ra) # 800037c0 <end_op>
    return -1;
    80004f14:	54fd                	li	s1,-1
    80004f16:	790a                	ld	s2,160(sp)
    80004f18:	69ea                	ld	s3,152(sp)
    80004f1a:	b785                	j	80004e7a <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004f1c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f20:	04e91783          	lh	a5,78(s2)
    80004f24:	02f99223          	sh	a5,36(s3)
    80004f28:	b739                	j	80004e36 <sys_open+0xa2>
    itrunc(ip);
    80004f2a:	854a                	mv	a0,s2
    80004f2c:	ffffe097          	auipc	ra,0xffffe
    80004f30:	f5a080e7          	jalr	-166(ra) # 80002e86 <itrunc>
    80004f34:	bf05                	j	80004e64 <sys_open+0xd0>

0000000080004f36 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f36:	7175                	addi	sp,sp,-144
    80004f38:	e506                	sd	ra,136(sp)
    80004f3a:	e122                	sd	s0,128(sp)
    80004f3c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f3e:	fffff097          	auipc	ra,0xfffff
    80004f42:	808080e7          	jalr	-2040(ra) # 80003746 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f46:	08000613          	li	a2,128
    80004f4a:	f7040593          	addi	a1,s0,-144
    80004f4e:	4501                	li	a0,0
    80004f50:	ffffd097          	auipc	ra,0xffffd
    80004f54:	12a080e7          	jalr	298(ra) # 8000207a <argstr>
    80004f58:	02054963          	bltz	a0,80004f8a <sys_mkdir+0x54>
    80004f5c:	4681                	li	a3,0
    80004f5e:	4601                	li	a2,0
    80004f60:	4585                	li	a1,1
    80004f62:	f7040513          	addi	a0,s0,-144
    80004f66:	fffff097          	auipc	ra,0xfffff
    80004f6a:	7d8080e7          	jalr	2008(ra) # 8000473e <create>
    80004f6e:	cd11                	beqz	a0,80004f8a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	06a080e7          	jalr	106(ra) # 80002fda <iunlockput>
  end_op();
    80004f78:	fffff097          	auipc	ra,0xfffff
    80004f7c:	848080e7          	jalr	-1976(ra) # 800037c0 <end_op>
  return 0;
    80004f80:	4501                	li	a0,0
}
    80004f82:	60aa                	ld	ra,136(sp)
    80004f84:	640a                	ld	s0,128(sp)
    80004f86:	6149                	addi	sp,sp,144
    80004f88:	8082                	ret
    end_op();
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	836080e7          	jalr	-1994(ra) # 800037c0 <end_op>
    return -1;
    80004f92:	557d                	li	a0,-1
    80004f94:	b7fd                	j	80004f82 <sys_mkdir+0x4c>

0000000080004f96 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f96:	7135                	addi	sp,sp,-160
    80004f98:	ed06                	sd	ra,152(sp)
    80004f9a:	e922                	sd	s0,144(sp)
    80004f9c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	7a8080e7          	jalr	1960(ra) # 80003746 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fa6:	08000613          	li	a2,128
    80004faa:	f7040593          	addi	a1,s0,-144
    80004fae:	4501                	li	a0,0
    80004fb0:	ffffd097          	auipc	ra,0xffffd
    80004fb4:	0ca080e7          	jalr	202(ra) # 8000207a <argstr>
    80004fb8:	04054a63          	bltz	a0,8000500c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004fbc:	f6c40593          	addi	a1,s0,-148
    80004fc0:	4505                	li	a0,1
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	074080e7          	jalr	116(ra) # 80002036 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fca:	04054163          	bltz	a0,8000500c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004fce:	f6840593          	addi	a1,s0,-152
    80004fd2:	4509                	li	a0,2
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	062080e7          	jalr	98(ra) # 80002036 <argint>
     argint(1, &major) < 0 ||
    80004fdc:	02054863          	bltz	a0,8000500c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fe0:	f6841683          	lh	a3,-152(s0)
    80004fe4:	f6c41603          	lh	a2,-148(s0)
    80004fe8:	458d                	li	a1,3
    80004fea:	f7040513          	addi	a0,s0,-144
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	750080e7          	jalr	1872(ra) # 8000473e <create>
     argint(2, &minor) < 0 ||
    80004ff6:	c919                	beqz	a0,8000500c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ff8:	ffffe097          	auipc	ra,0xffffe
    80004ffc:	fe2080e7          	jalr	-30(ra) # 80002fda <iunlockput>
  end_op();
    80005000:	ffffe097          	auipc	ra,0xffffe
    80005004:	7c0080e7          	jalr	1984(ra) # 800037c0 <end_op>
  return 0;
    80005008:	4501                	li	a0,0
    8000500a:	a031                	j	80005016 <sys_mknod+0x80>
    end_op();
    8000500c:	ffffe097          	auipc	ra,0xffffe
    80005010:	7b4080e7          	jalr	1972(ra) # 800037c0 <end_op>
    return -1;
    80005014:	557d                	li	a0,-1
}
    80005016:	60ea                	ld	ra,152(sp)
    80005018:	644a                	ld	s0,144(sp)
    8000501a:	610d                	addi	sp,sp,160
    8000501c:	8082                	ret

000000008000501e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000501e:	7135                	addi	sp,sp,-160
    80005020:	ed06                	sd	ra,152(sp)
    80005022:	e922                	sd	s0,144(sp)
    80005024:	e14a                	sd	s2,128(sp)
    80005026:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005028:	ffffc097          	auipc	ra,0xffffc
    8000502c:	f4e080e7          	jalr	-178(ra) # 80000f76 <myproc>
    80005030:	892a                	mv	s2,a0
  
  begin_op();
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	714080e7          	jalr	1812(ra) # 80003746 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000503a:	08000613          	li	a2,128
    8000503e:	f6040593          	addi	a1,s0,-160
    80005042:	4501                	li	a0,0
    80005044:	ffffd097          	auipc	ra,0xffffd
    80005048:	036080e7          	jalr	54(ra) # 8000207a <argstr>
    8000504c:	04054d63          	bltz	a0,800050a6 <sys_chdir+0x88>
    80005050:	e526                	sd	s1,136(sp)
    80005052:	f6040513          	addi	a0,s0,-160
    80005056:	ffffe097          	auipc	ra,0xffffe
    8000505a:	4f0080e7          	jalr	1264(ra) # 80003546 <namei>
    8000505e:	84aa                	mv	s1,a0
    80005060:	c131                	beqz	a0,800050a4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005062:	ffffe097          	auipc	ra,0xffffe
    80005066:	d12080e7          	jalr	-750(ra) # 80002d74 <ilock>
  if(ip->type != T_DIR){
    8000506a:	04c49703          	lh	a4,76(s1)
    8000506e:	4785                	li	a5,1
    80005070:	04f71163          	bne	a4,a5,800050b2 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005074:	8526                	mv	a0,s1
    80005076:	ffffe097          	auipc	ra,0xffffe
    8000507a:	dc4080e7          	jalr	-572(ra) # 80002e3a <iunlock>
  iput(p->cwd);
    8000507e:	15893503          	ld	a0,344(s2)
    80005082:	ffffe097          	auipc	ra,0xffffe
    80005086:	eb0080e7          	jalr	-336(ra) # 80002f32 <iput>
  end_op();
    8000508a:	ffffe097          	auipc	ra,0xffffe
    8000508e:	736080e7          	jalr	1846(ra) # 800037c0 <end_op>
  p->cwd = ip;
    80005092:	14993c23          	sd	s1,344(s2)
  return 0;
    80005096:	4501                	li	a0,0
    80005098:	64aa                	ld	s1,136(sp)
}
    8000509a:	60ea                	ld	ra,152(sp)
    8000509c:	644a                	ld	s0,144(sp)
    8000509e:	690a                	ld	s2,128(sp)
    800050a0:	610d                	addi	sp,sp,160
    800050a2:	8082                	ret
    800050a4:	64aa                	ld	s1,136(sp)
    end_op();
    800050a6:	ffffe097          	auipc	ra,0xffffe
    800050aa:	71a080e7          	jalr	1818(ra) # 800037c0 <end_op>
    return -1;
    800050ae:	557d                	li	a0,-1
    800050b0:	b7ed                	j	8000509a <sys_chdir+0x7c>
    iunlockput(ip);
    800050b2:	8526                	mv	a0,s1
    800050b4:	ffffe097          	auipc	ra,0xffffe
    800050b8:	f26080e7          	jalr	-218(ra) # 80002fda <iunlockput>
    end_op();
    800050bc:	ffffe097          	auipc	ra,0xffffe
    800050c0:	704080e7          	jalr	1796(ra) # 800037c0 <end_op>
    return -1;
    800050c4:	557d                	li	a0,-1
    800050c6:	64aa                	ld	s1,136(sp)
    800050c8:	bfc9                	j	8000509a <sys_chdir+0x7c>

00000000800050ca <sys_exec>:

uint64
sys_exec(void)
{
    800050ca:	7121                	addi	sp,sp,-448
    800050cc:	ff06                	sd	ra,440(sp)
    800050ce:	fb22                	sd	s0,432(sp)
    800050d0:	f34a                	sd	s2,416(sp)
    800050d2:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050d4:	08000613          	li	a2,128
    800050d8:	f5040593          	addi	a1,s0,-176
    800050dc:	4501                	li	a0,0
    800050de:	ffffd097          	auipc	ra,0xffffd
    800050e2:	f9c080e7          	jalr	-100(ra) # 8000207a <argstr>
    return -1;
    800050e6:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050e8:	0e054a63          	bltz	a0,800051dc <sys_exec+0x112>
    800050ec:	e4840593          	addi	a1,s0,-440
    800050f0:	4505                	li	a0,1
    800050f2:	ffffd097          	auipc	ra,0xffffd
    800050f6:	f66080e7          	jalr	-154(ra) # 80002058 <argaddr>
    800050fa:	0e054163          	bltz	a0,800051dc <sys_exec+0x112>
    800050fe:	f726                	sd	s1,424(sp)
    80005100:	ef4e                	sd	s3,408(sp)
    80005102:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005104:	10000613          	li	a2,256
    80005108:	4581                	li	a1,0
    8000510a:	e5040513          	addi	a0,s0,-432
    8000510e:	ffffb097          	auipc	ra,0xffffb
    80005112:	156080e7          	jalr	342(ra) # 80000264 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005116:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000511a:	89a6                	mv	s3,s1
    8000511c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000511e:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005122:	00391513          	slli	a0,s2,0x3
    80005126:	e4040593          	addi	a1,s0,-448
    8000512a:	e4843783          	ld	a5,-440(s0)
    8000512e:	953e                	add	a0,a0,a5
    80005130:	ffffd097          	auipc	ra,0xffffd
    80005134:	e6c080e7          	jalr	-404(ra) # 80001f9c <fetchaddr>
    80005138:	02054a63          	bltz	a0,8000516c <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    8000513c:	e4043783          	ld	a5,-448(s0)
    80005140:	c7b1                	beqz	a5,8000518c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005142:	ffffb097          	auipc	ra,0xffffb
    80005146:	02a080e7          	jalr	42(ra) # 8000016c <kalloc>
    8000514a:	85aa                	mv	a1,a0
    8000514c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005150:	cd11                	beqz	a0,8000516c <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005152:	6605                	lui	a2,0x1
    80005154:	e4043503          	ld	a0,-448(s0)
    80005158:	ffffd097          	auipc	ra,0xffffd
    8000515c:	e96080e7          	jalr	-362(ra) # 80001fee <fetchstr>
    80005160:	00054663          	bltz	a0,8000516c <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005164:	0905                	addi	s2,s2,1
    80005166:	09a1                	addi	s3,s3,8
    80005168:	fb491de3          	bne	s2,s4,80005122 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000516c:	f5040913          	addi	s2,s0,-176
    80005170:	6088                	ld	a0,0(s1)
    80005172:	c12d                	beqz	a0,800051d4 <sys_exec+0x10a>
    kfree(argv[i]);
    80005174:	ffffb097          	auipc	ra,0xffffb
    80005178:	ea8080e7          	jalr	-344(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000517c:	04a1                	addi	s1,s1,8
    8000517e:	ff2499e3          	bne	s1,s2,80005170 <sys_exec+0xa6>
  return -1;
    80005182:	597d                	li	s2,-1
    80005184:	74ba                	ld	s1,424(sp)
    80005186:	69fa                	ld	s3,408(sp)
    80005188:	6a5a                	ld	s4,400(sp)
    8000518a:	a889                	j	800051dc <sys_exec+0x112>
      argv[i] = 0;
    8000518c:	0009079b          	sext.w	a5,s2
    80005190:	078e                	slli	a5,a5,0x3
    80005192:	fd078793          	addi	a5,a5,-48
    80005196:	97a2                	add	a5,a5,s0
    80005198:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000519c:	e5040593          	addi	a1,s0,-432
    800051a0:	f5040513          	addi	a0,s0,-176
    800051a4:	fffff097          	auipc	ra,0xfffff
    800051a8:	126080e7          	jalr	294(ra) # 800042ca <exec>
    800051ac:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051ae:	f5040993          	addi	s3,s0,-176
    800051b2:	6088                	ld	a0,0(s1)
    800051b4:	cd01                	beqz	a0,800051cc <sys_exec+0x102>
    kfree(argv[i]);
    800051b6:	ffffb097          	auipc	ra,0xffffb
    800051ba:	e66080e7          	jalr	-410(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051be:	04a1                	addi	s1,s1,8
    800051c0:	ff3499e3          	bne	s1,s3,800051b2 <sys_exec+0xe8>
    800051c4:	74ba                	ld	s1,424(sp)
    800051c6:	69fa                	ld	s3,408(sp)
    800051c8:	6a5a                	ld	s4,400(sp)
    800051ca:	a809                	j	800051dc <sys_exec+0x112>
  return ret;
    800051cc:	74ba                	ld	s1,424(sp)
    800051ce:	69fa                	ld	s3,408(sp)
    800051d0:	6a5a                	ld	s4,400(sp)
    800051d2:	a029                	j	800051dc <sys_exec+0x112>
  return -1;
    800051d4:	597d                	li	s2,-1
    800051d6:	74ba                	ld	s1,424(sp)
    800051d8:	69fa                	ld	s3,408(sp)
    800051da:	6a5a                	ld	s4,400(sp)
}
    800051dc:	854a                	mv	a0,s2
    800051de:	70fa                	ld	ra,440(sp)
    800051e0:	745a                	ld	s0,432(sp)
    800051e2:	791a                	ld	s2,416(sp)
    800051e4:	6139                	addi	sp,sp,448
    800051e6:	8082                	ret

00000000800051e8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051e8:	7139                	addi	sp,sp,-64
    800051ea:	fc06                	sd	ra,56(sp)
    800051ec:	f822                	sd	s0,48(sp)
    800051ee:	f426                	sd	s1,40(sp)
    800051f0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051f2:	ffffc097          	auipc	ra,0xffffc
    800051f6:	d84080e7          	jalr	-636(ra) # 80000f76 <myproc>
    800051fa:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800051fc:	fd840593          	addi	a1,s0,-40
    80005200:	4501                	li	a0,0
    80005202:	ffffd097          	auipc	ra,0xffffd
    80005206:	e56080e7          	jalr	-426(ra) # 80002058 <argaddr>
    return -1;
    8000520a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000520c:	0e054063          	bltz	a0,800052ec <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005210:	fc840593          	addi	a1,s0,-56
    80005214:	fd040513          	addi	a0,s0,-48
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	d66080e7          	jalr	-666(ra) # 80003f7e <pipealloc>
    return -1;
    80005220:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005222:	0c054563          	bltz	a0,800052ec <sys_pipe+0x104>
  fd0 = -1;
    80005226:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000522a:	fd043503          	ld	a0,-48(s0)
    8000522e:	fffff097          	auipc	ra,0xfffff
    80005232:	4ce080e7          	jalr	1230(ra) # 800046fc <fdalloc>
    80005236:	fca42223          	sw	a0,-60(s0)
    8000523a:	08054c63          	bltz	a0,800052d2 <sys_pipe+0xea>
    8000523e:	fc843503          	ld	a0,-56(s0)
    80005242:	fffff097          	auipc	ra,0xfffff
    80005246:	4ba080e7          	jalr	1210(ra) # 800046fc <fdalloc>
    8000524a:	fca42023          	sw	a0,-64(s0)
    8000524e:	06054963          	bltz	a0,800052c0 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005252:	4691                	li	a3,4
    80005254:	fc440613          	addi	a2,s0,-60
    80005258:	fd843583          	ld	a1,-40(s0)
    8000525c:	6ca8                	ld	a0,88(s1)
    8000525e:	ffffc097          	auipc	ra,0xffffc
    80005262:	9b4080e7          	jalr	-1612(ra) # 80000c12 <copyout>
    80005266:	02054063          	bltz	a0,80005286 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000526a:	4691                	li	a3,4
    8000526c:	fc040613          	addi	a2,s0,-64
    80005270:	fd843583          	ld	a1,-40(s0)
    80005274:	0591                	addi	a1,a1,4
    80005276:	6ca8                	ld	a0,88(s1)
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	99a080e7          	jalr	-1638(ra) # 80000c12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005280:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005282:	06055563          	bgez	a0,800052ec <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005286:	fc442783          	lw	a5,-60(s0)
    8000528a:	07e9                	addi	a5,a5,26
    8000528c:	078e                	slli	a5,a5,0x3
    8000528e:	97a6                	add	a5,a5,s1
    80005290:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005294:	fc042783          	lw	a5,-64(s0)
    80005298:	07e9                	addi	a5,a5,26
    8000529a:	078e                	slli	a5,a5,0x3
    8000529c:	00f48533          	add	a0,s1,a5
    800052a0:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800052a4:	fd043503          	ld	a0,-48(s0)
    800052a8:	fffff097          	auipc	ra,0xfffff
    800052ac:	968080e7          	jalr	-1688(ra) # 80003c10 <fileclose>
    fileclose(wf);
    800052b0:	fc843503          	ld	a0,-56(s0)
    800052b4:	fffff097          	auipc	ra,0xfffff
    800052b8:	95c080e7          	jalr	-1700(ra) # 80003c10 <fileclose>
    return -1;
    800052bc:	57fd                	li	a5,-1
    800052be:	a03d                	j	800052ec <sys_pipe+0x104>
    if(fd0 >= 0)
    800052c0:	fc442783          	lw	a5,-60(s0)
    800052c4:	0007c763          	bltz	a5,800052d2 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800052c8:	07e9                	addi	a5,a5,26
    800052ca:	078e                	slli	a5,a5,0x3
    800052cc:	97a6                	add	a5,a5,s1
    800052ce:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800052d2:	fd043503          	ld	a0,-48(s0)
    800052d6:	fffff097          	auipc	ra,0xfffff
    800052da:	93a080e7          	jalr	-1734(ra) # 80003c10 <fileclose>
    fileclose(wf);
    800052de:	fc843503          	ld	a0,-56(s0)
    800052e2:	fffff097          	auipc	ra,0xfffff
    800052e6:	92e080e7          	jalr	-1746(ra) # 80003c10 <fileclose>
    return -1;
    800052ea:	57fd                	li	a5,-1
}
    800052ec:	853e                	mv	a0,a5
    800052ee:	70e2                	ld	ra,56(sp)
    800052f0:	7442                	ld	s0,48(sp)
    800052f2:	74a2                	ld	s1,40(sp)
    800052f4:	6121                	addi	sp,sp,64
    800052f6:	8082                	ret
	...

0000000080005300 <kernelvec>:
    80005300:	7111                	addi	sp,sp,-256
    80005302:	e006                	sd	ra,0(sp)
    80005304:	e40a                	sd	sp,8(sp)
    80005306:	e80e                	sd	gp,16(sp)
    80005308:	ec12                	sd	tp,24(sp)
    8000530a:	f016                	sd	t0,32(sp)
    8000530c:	f41a                	sd	t1,40(sp)
    8000530e:	f81e                	sd	t2,48(sp)
    80005310:	fc22                	sd	s0,56(sp)
    80005312:	e0a6                	sd	s1,64(sp)
    80005314:	e4aa                	sd	a0,72(sp)
    80005316:	e8ae                	sd	a1,80(sp)
    80005318:	ecb2                	sd	a2,88(sp)
    8000531a:	f0b6                	sd	a3,96(sp)
    8000531c:	f4ba                	sd	a4,104(sp)
    8000531e:	f8be                	sd	a5,112(sp)
    80005320:	fcc2                	sd	a6,120(sp)
    80005322:	e146                	sd	a7,128(sp)
    80005324:	e54a                	sd	s2,136(sp)
    80005326:	e94e                	sd	s3,144(sp)
    80005328:	ed52                	sd	s4,152(sp)
    8000532a:	f156                	sd	s5,160(sp)
    8000532c:	f55a                	sd	s6,168(sp)
    8000532e:	f95e                	sd	s7,176(sp)
    80005330:	fd62                	sd	s8,184(sp)
    80005332:	e1e6                	sd	s9,192(sp)
    80005334:	e5ea                	sd	s10,200(sp)
    80005336:	e9ee                	sd	s11,208(sp)
    80005338:	edf2                	sd	t3,216(sp)
    8000533a:	f1f6                	sd	t4,224(sp)
    8000533c:	f5fa                	sd	t5,232(sp)
    8000533e:	f9fe                	sd	t6,240(sp)
    80005340:	b29fc0ef          	jal	80001e68 <kerneltrap>
    80005344:	6082                	ld	ra,0(sp)
    80005346:	6122                	ld	sp,8(sp)
    80005348:	61c2                	ld	gp,16(sp)
    8000534a:	7282                	ld	t0,32(sp)
    8000534c:	7322                	ld	t1,40(sp)
    8000534e:	73c2                	ld	t2,48(sp)
    80005350:	7462                	ld	s0,56(sp)
    80005352:	6486                	ld	s1,64(sp)
    80005354:	6526                	ld	a0,72(sp)
    80005356:	65c6                	ld	a1,80(sp)
    80005358:	6666                	ld	a2,88(sp)
    8000535a:	7686                	ld	a3,96(sp)
    8000535c:	7726                	ld	a4,104(sp)
    8000535e:	77c6                	ld	a5,112(sp)
    80005360:	7866                	ld	a6,120(sp)
    80005362:	688a                	ld	a7,128(sp)
    80005364:	692a                	ld	s2,136(sp)
    80005366:	69ca                	ld	s3,144(sp)
    80005368:	6a6a                	ld	s4,152(sp)
    8000536a:	7a8a                	ld	s5,160(sp)
    8000536c:	7b2a                	ld	s6,168(sp)
    8000536e:	7bca                	ld	s7,176(sp)
    80005370:	7c6a                	ld	s8,184(sp)
    80005372:	6c8e                	ld	s9,192(sp)
    80005374:	6d2e                	ld	s10,200(sp)
    80005376:	6dce                	ld	s11,208(sp)
    80005378:	6e6e                	ld	t3,216(sp)
    8000537a:	7e8e                	ld	t4,224(sp)
    8000537c:	7f2e                	ld	t5,232(sp)
    8000537e:	7fce                	ld	t6,240(sp)
    80005380:	6111                	addi	sp,sp,256
    80005382:	10200073          	sret
    80005386:	00000013          	nop
    8000538a:	00000013          	nop
    8000538e:	0001                	nop

0000000080005390 <timervec>:
    80005390:	34051573          	csrrw	a0,mscratch,a0
    80005394:	e10c                	sd	a1,0(a0)
    80005396:	e510                	sd	a2,8(a0)
    80005398:	e914                	sd	a3,16(a0)
    8000539a:	6d0c                	ld	a1,24(a0)
    8000539c:	7110                	ld	a2,32(a0)
    8000539e:	6194                	ld	a3,0(a1)
    800053a0:	96b2                	add	a3,a3,a2
    800053a2:	e194                	sd	a3,0(a1)
    800053a4:	4589                	li	a1,2
    800053a6:	14459073          	csrw	sip,a1
    800053aa:	6914                	ld	a3,16(a0)
    800053ac:	6510                	ld	a2,8(a0)
    800053ae:	610c                	ld	a1,0(a0)
    800053b0:	34051573          	csrrw	a0,mscratch,a0
    800053b4:	30200073          	mret
	...

00000000800053ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053ba:	1141                	addi	sp,sp,-16
    800053bc:	e422                	sd	s0,8(sp)
    800053be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053c0:	0c0007b7          	lui	a5,0xc000
    800053c4:	4705                	li	a4,1
    800053c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053c8:	0c0007b7          	lui	a5,0xc000
    800053cc:	c3d8                	sw	a4,4(a5)
}
    800053ce:	6422                	ld	s0,8(sp)
    800053d0:	0141                	addi	sp,sp,16
    800053d2:	8082                	ret

00000000800053d4 <plicinithart>:

void
plicinithart(void)
{
    800053d4:	1141                	addi	sp,sp,-16
    800053d6:	e406                	sd	ra,8(sp)
    800053d8:	e022                	sd	s0,0(sp)
    800053da:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053dc:	ffffc097          	auipc	ra,0xffffc
    800053e0:	b6e080e7          	jalr	-1170(ra) # 80000f4a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053e4:	0085171b          	slliw	a4,a0,0x8
    800053e8:	0c0027b7          	lui	a5,0xc002
    800053ec:	97ba                	add	a5,a5,a4
    800053ee:	40200713          	li	a4,1026
    800053f2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053f6:	00d5151b          	slliw	a0,a0,0xd
    800053fa:	0c2017b7          	lui	a5,0xc201
    800053fe:	97aa                	add	a5,a5,a0
    80005400:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005404:	60a2                	ld	ra,8(sp)
    80005406:	6402                	ld	s0,0(sp)
    80005408:	0141                	addi	sp,sp,16
    8000540a:	8082                	ret

000000008000540c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000540c:	1141                	addi	sp,sp,-16
    8000540e:	e406                	sd	ra,8(sp)
    80005410:	e022                	sd	s0,0(sp)
    80005412:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005414:	ffffc097          	auipc	ra,0xffffc
    80005418:	b36080e7          	jalr	-1226(ra) # 80000f4a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000541c:	00d5151b          	slliw	a0,a0,0xd
    80005420:	0c2017b7          	lui	a5,0xc201
    80005424:	97aa                	add	a5,a5,a0
  return irq;
}
    80005426:	43c8                	lw	a0,4(a5)
    80005428:	60a2                	ld	ra,8(sp)
    8000542a:	6402                	ld	s0,0(sp)
    8000542c:	0141                	addi	sp,sp,16
    8000542e:	8082                	ret

0000000080005430 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005430:	1101                	addi	sp,sp,-32
    80005432:	ec06                	sd	ra,24(sp)
    80005434:	e822                	sd	s0,16(sp)
    80005436:	e426                	sd	s1,8(sp)
    80005438:	1000                	addi	s0,sp,32
    8000543a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000543c:	ffffc097          	auipc	ra,0xffffc
    80005440:	b0e080e7          	jalr	-1266(ra) # 80000f4a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005444:	00d5151b          	slliw	a0,a0,0xd
    80005448:	0c2017b7          	lui	a5,0xc201
    8000544c:	97aa                	add	a5,a5,a0
    8000544e:	c3c4                	sw	s1,4(a5)
}
    80005450:	60e2                	ld	ra,24(sp)
    80005452:	6442                	ld	s0,16(sp)
    80005454:	64a2                	ld	s1,8(sp)
    80005456:	6105                	addi	sp,sp,32
    80005458:	8082                	ret

000000008000545a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000545a:	1141                	addi	sp,sp,-16
    8000545c:	e406                	sd	ra,8(sp)
    8000545e:	e022                	sd	s0,0(sp)
    80005460:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005462:	479d                	li	a5,7
    80005464:	06a7c863          	blt	a5,a0,800054d4 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005468:	00019717          	auipc	a4,0x19
    8000546c:	b9870713          	addi	a4,a4,-1128 # 8001e000 <disk>
    80005470:	972a                	add	a4,a4,a0
    80005472:	6789                	lui	a5,0x2
    80005474:	97ba                	add	a5,a5,a4
    80005476:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000547a:	e7ad                	bnez	a5,800054e4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000547c:	00451793          	slli	a5,a0,0x4
    80005480:	0001b717          	auipc	a4,0x1b
    80005484:	b8070713          	addi	a4,a4,-1152 # 80020000 <disk+0x2000>
    80005488:	6314                	ld	a3,0(a4)
    8000548a:	96be                	add	a3,a3,a5
    8000548c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005490:	6314                	ld	a3,0(a4)
    80005492:	96be                	add	a3,a3,a5
    80005494:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005498:	6314                	ld	a3,0(a4)
    8000549a:	96be                	add	a3,a3,a5
    8000549c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800054a0:	6318                	ld	a4,0(a4)
    800054a2:	97ba                	add	a5,a5,a4
    800054a4:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800054a8:	00019717          	auipc	a4,0x19
    800054ac:	b5870713          	addi	a4,a4,-1192 # 8001e000 <disk>
    800054b0:	972a                	add	a4,a4,a0
    800054b2:	6789                	lui	a5,0x2
    800054b4:	97ba                	add	a5,a5,a4
    800054b6:	4705                	li	a4,1
    800054b8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800054bc:	0001b517          	auipc	a0,0x1b
    800054c0:	b5c50513          	addi	a0,a0,-1188 # 80020018 <disk+0x2018>
    800054c4:	ffffc097          	auipc	ra,0xffffc
    800054c8:	304080e7          	jalr	772(ra) # 800017c8 <wakeup>
}
    800054cc:	60a2                	ld	ra,8(sp)
    800054ce:	6402                	ld	s0,0(sp)
    800054d0:	0141                	addi	sp,sp,16
    800054d2:	8082                	ret
    panic("free_desc 1");
    800054d4:	00003517          	auipc	a0,0x3
    800054d8:	12c50513          	addi	a0,a0,300 # 80008600 <etext+0x600>
    800054dc:	00001097          	auipc	ra,0x1
    800054e0:	d8a080e7          	jalr	-630(ra) # 80006266 <panic>
    panic("free_desc 2");
    800054e4:	00003517          	auipc	a0,0x3
    800054e8:	12c50513          	addi	a0,a0,300 # 80008610 <etext+0x610>
    800054ec:	00001097          	auipc	ra,0x1
    800054f0:	d7a080e7          	jalr	-646(ra) # 80006266 <panic>

00000000800054f4 <virtio_disk_init>:
{
    800054f4:	1141                	addi	sp,sp,-16
    800054f6:	e406                	sd	ra,8(sp)
    800054f8:	e022                	sd	s0,0(sp)
    800054fa:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054fc:	00003597          	auipc	a1,0x3
    80005500:	12458593          	addi	a1,a1,292 # 80008620 <etext+0x620>
    80005504:	0001b517          	auipc	a0,0x1b
    80005508:	c2450513          	addi	a0,a0,-988 # 80020128 <disk+0x2128>
    8000550c:	00001097          	auipc	ra,0x1
    80005510:	43a080e7          	jalr	1082(ra) # 80006946 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005514:	100017b7          	lui	a5,0x10001
    80005518:	4398                	lw	a4,0(a5)
    8000551a:	2701                	sext.w	a4,a4
    8000551c:	747277b7          	lui	a5,0x74727
    80005520:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005524:	0ef71f63          	bne	a4,a5,80005622 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005528:	100017b7          	lui	a5,0x10001
    8000552c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000552e:	439c                	lw	a5,0(a5)
    80005530:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005532:	4705                	li	a4,1
    80005534:	0ee79763          	bne	a5,a4,80005622 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005538:	100017b7          	lui	a5,0x10001
    8000553c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000553e:	439c                	lw	a5,0(a5)
    80005540:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005542:	4709                	li	a4,2
    80005544:	0ce79f63          	bne	a5,a4,80005622 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005548:	100017b7          	lui	a5,0x10001
    8000554c:	47d8                	lw	a4,12(a5)
    8000554e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005550:	554d47b7          	lui	a5,0x554d4
    80005554:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005558:	0cf71563          	bne	a4,a5,80005622 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000555c:	100017b7          	lui	a5,0x10001
    80005560:	4705                	li	a4,1
    80005562:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005564:	470d                	li	a4,3
    80005566:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005568:	10001737          	lui	a4,0x10001
    8000556c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000556e:	c7ffe737          	lui	a4,0xc7ffe
    80005572:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd3517>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005576:	8ef9                	and	a3,a3,a4
    80005578:	10001737          	lui	a4,0x10001
    8000557c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000557e:	472d                	li	a4,11
    80005580:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005582:	473d                	li	a4,15
    80005584:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005586:	100017b7          	lui	a5,0x10001
    8000558a:	6705                	lui	a4,0x1
    8000558c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000558e:	100017b7          	lui	a5,0x10001
    80005592:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005596:	100017b7          	lui	a5,0x10001
    8000559a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000559e:	439c                	lw	a5,0(a5)
    800055a0:	2781                	sext.w	a5,a5
  if(max == 0)
    800055a2:	cbc1                	beqz	a5,80005632 <virtio_disk_init+0x13e>
  if(max < NUM)
    800055a4:	471d                	li	a4,7
    800055a6:	08f77e63          	bgeu	a4,a5,80005642 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055aa:	100017b7          	lui	a5,0x10001
    800055ae:	4721                	li	a4,8
    800055b0:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800055b2:	6609                	lui	a2,0x2
    800055b4:	4581                	li	a1,0
    800055b6:	00019517          	auipc	a0,0x19
    800055ba:	a4a50513          	addi	a0,a0,-1462 # 8001e000 <disk>
    800055be:	ffffb097          	auipc	ra,0xffffb
    800055c2:	ca6080e7          	jalr	-858(ra) # 80000264 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800055c6:	00019697          	auipc	a3,0x19
    800055ca:	a3a68693          	addi	a3,a3,-1478 # 8001e000 <disk>
    800055ce:	00c6d713          	srli	a4,a3,0xc
    800055d2:	2701                	sext.w	a4,a4
    800055d4:	100017b7          	lui	a5,0x10001
    800055d8:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    800055da:	0001b797          	auipc	a5,0x1b
    800055de:	a2678793          	addi	a5,a5,-1498 # 80020000 <disk+0x2000>
    800055e2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800055e4:	00019717          	auipc	a4,0x19
    800055e8:	a9c70713          	addi	a4,a4,-1380 # 8001e080 <disk+0x80>
    800055ec:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800055ee:	0001a717          	auipc	a4,0x1a
    800055f2:	a1270713          	addi	a4,a4,-1518 # 8001f000 <disk+0x1000>
    800055f6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800055f8:	4705                	li	a4,1
    800055fa:	00e78c23          	sb	a4,24(a5)
    800055fe:	00e78ca3          	sb	a4,25(a5)
    80005602:	00e78d23          	sb	a4,26(a5)
    80005606:	00e78da3          	sb	a4,27(a5)
    8000560a:	00e78e23          	sb	a4,28(a5)
    8000560e:	00e78ea3          	sb	a4,29(a5)
    80005612:	00e78f23          	sb	a4,30(a5)
    80005616:	00e78fa3          	sb	a4,31(a5)
}
    8000561a:	60a2                	ld	ra,8(sp)
    8000561c:	6402                	ld	s0,0(sp)
    8000561e:	0141                	addi	sp,sp,16
    80005620:	8082                	ret
    panic("could not find virtio disk");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	00e50513          	addi	a0,a0,14 # 80008630 <etext+0x630>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	c3c080e7          	jalr	-964(ra) # 80006266 <panic>
    panic("virtio disk has no queue 0");
    80005632:	00003517          	auipc	a0,0x3
    80005636:	01e50513          	addi	a0,a0,30 # 80008650 <etext+0x650>
    8000563a:	00001097          	auipc	ra,0x1
    8000563e:	c2c080e7          	jalr	-980(ra) # 80006266 <panic>
    panic("virtio disk max queue too short");
    80005642:	00003517          	auipc	a0,0x3
    80005646:	02e50513          	addi	a0,a0,46 # 80008670 <etext+0x670>
    8000564a:	00001097          	auipc	ra,0x1
    8000564e:	c1c080e7          	jalr	-996(ra) # 80006266 <panic>

0000000080005652 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005652:	7159                	addi	sp,sp,-112
    80005654:	f486                	sd	ra,104(sp)
    80005656:	f0a2                	sd	s0,96(sp)
    80005658:	eca6                	sd	s1,88(sp)
    8000565a:	e8ca                	sd	s2,80(sp)
    8000565c:	e4ce                	sd	s3,72(sp)
    8000565e:	e0d2                	sd	s4,64(sp)
    80005660:	fc56                	sd	s5,56(sp)
    80005662:	f85a                	sd	s6,48(sp)
    80005664:	f45e                	sd	s7,40(sp)
    80005666:	f062                	sd	s8,32(sp)
    80005668:	ec66                	sd	s9,24(sp)
    8000566a:	1880                	addi	s0,sp,112
    8000566c:	8a2a                	mv	s4,a0
    8000566e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005670:	00c52c03          	lw	s8,12(a0)
    80005674:	001c1c1b          	slliw	s8,s8,0x1
    80005678:	1c02                	slli	s8,s8,0x20
    8000567a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000567e:	0001b517          	auipc	a0,0x1b
    80005682:	aaa50513          	addi	a0,a0,-1366 # 80020128 <disk+0x2128>
    80005686:	00001097          	auipc	ra,0x1
    8000568a:	144080e7          	jalr	324(ra) # 800067ca <acquire>
  for(int i = 0; i < 3; i++){
    8000568e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005690:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005692:	00019b97          	auipc	s7,0x19
    80005696:	96eb8b93          	addi	s7,s7,-1682 # 8001e000 <disk>
    8000569a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000569c:	4a8d                	li	s5,3
    8000569e:	a88d                	j	80005710 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    800056a0:	00fb8733          	add	a4,s7,a5
    800056a4:	975a                	add	a4,a4,s6
    800056a6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056aa:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056ac:	0207c563          	bltz	a5,800056d6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800056b0:	2905                	addiw	s2,s2,1
    800056b2:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800056b4:	1b590163          	beq	s2,s5,80005856 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    800056b8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056ba:	0001b717          	auipc	a4,0x1b
    800056be:	95e70713          	addi	a4,a4,-1698 # 80020018 <disk+0x2018>
    800056c2:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056c4:	00074683          	lbu	a3,0(a4)
    800056c8:	fee1                	bnez	a3,800056a0 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    800056ca:	2785                	addiw	a5,a5,1
    800056cc:	0705                	addi	a4,a4,1
    800056ce:	fe979be3          	bne	a5,s1,800056c4 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800056d2:	57fd                	li	a5,-1
    800056d4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056d6:	03205163          	blez	s2,800056f8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800056da:	f9042503          	lw	a0,-112(s0)
    800056de:	00000097          	auipc	ra,0x0
    800056e2:	d7c080e7          	jalr	-644(ra) # 8000545a <free_desc>
      for(int j = 0; j < i; j++)
    800056e6:	4785                	li	a5,1
    800056e8:	0127d863          	bge	a5,s2,800056f8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800056ec:	f9442503          	lw	a0,-108(s0)
    800056f0:	00000097          	auipc	ra,0x0
    800056f4:	d6a080e7          	jalr	-662(ra) # 8000545a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056f8:	0001b597          	auipc	a1,0x1b
    800056fc:	a3058593          	addi	a1,a1,-1488 # 80020128 <disk+0x2128>
    80005700:	0001b517          	auipc	a0,0x1b
    80005704:	91850513          	addi	a0,a0,-1768 # 80020018 <disk+0x2018>
    80005708:	ffffc097          	auipc	ra,0xffffc
    8000570c:	f34080e7          	jalr	-204(ra) # 8000163c <sleep>
  for(int i = 0; i < 3; i++){
    80005710:	f9040613          	addi	a2,s0,-112
    80005714:	894e                	mv	s2,s3
    80005716:	b74d                	j	800056b8 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005718:	0001b717          	auipc	a4,0x1b
    8000571c:	8e873703          	ld	a4,-1816(a4) # 80020000 <disk+0x2000>
    80005720:	973e                	add	a4,a4,a5
    80005722:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005726:	00019897          	auipc	a7,0x19
    8000572a:	8da88893          	addi	a7,a7,-1830 # 8001e000 <disk>
    8000572e:	0001b717          	auipc	a4,0x1b
    80005732:	8d270713          	addi	a4,a4,-1838 # 80020000 <disk+0x2000>
    80005736:	6314                	ld	a3,0(a4)
    80005738:	96be                	add	a3,a3,a5
    8000573a:	00c6d583          	lhu	a1,12(a3)
    8000573e:	0015e593          	ori	a1,a1,1
    80005742:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005746:	f9842683          	lw	a3,-104(s0)
    8000574a:	630c                	ld	a1,0(a4)
    8000574c:	97ae                	add	a5,a5,a1
    8000574e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005752:	20050593          	addi	a1,a0,512
    80005756:	0592                	slli	a1,a1,0x4
    80005758:	95c6                	add	a1,a1,a7
    8000575a:	57fd                	li	a5,-1
    8000575c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005760:	00469793          	slli	a5,a3,0x4
    80005764:	00073803          	ld	a6,0(a4)
    80005768:	983e                	add	a6,a6,a5
    8000576a:	6689                	lui	a3,0x2
    8000576c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005770:	96b2                	add	a3,a3,a2
    80005772:	96c6                	add	a3,a3,a7
    80005774:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005778:	6314                	ld	a3,0(a4)
    8000577a:	96be                	add	a3,a3,a5
    8000577c:	4605                	li	a2,1
    8000577e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005780:	6314                	ld	a3,0(a4)
    80005782:	96be                	add	a3,a3,a5
    80005784:	4809                	li	a6,2
    80005786:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000578a:	6314                	ld	a3,0(a4)
    8000578c:	97b6                	add	a5,a5,a3
    8000578e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005792:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005796:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000579a:	6714                	ld	a3,8(a4)
    8000579c:	0026d783          	lhu	a5,2(a3)
    800057a0:	8b9d                	andi	a5,a5,7
    800057a2:	0786                	slli	a5,a5,0x1
    800057a4:	96be                	add	a3,a3,a5
    800057a6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057aa:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057ae:	6718                	ld	a4,8(a4)
    800057b0:	00275783          	lhu	a5,2(a4)
    800057b4:	2785                	addiw	a5,a5,1
    800057b6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057ba:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057be:	100017b7          	lui	a5,0x10001
    800057c2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057c6:	004a2783          	lw	a5,4(s4)
    800057ca:	02c79163          	bne	a5,a2,800057ec <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    800057ce:	0001b917          	auipc	s2,0x1b
    800057d2:	95a90913          	addi	s2,s2,-1702 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    800057d6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057d8:	85ca                	mv	a1,s2
    800057da:	8552                	mv	a0,s4
    800057dc:	ffffc097          	auipc	ra,0xffffc
    800057e0:	e60080e7          	jalr	-416(ra) # 8000163c <sleep>
  while(b->disk == 1) {
    800057e4:	004a2783          	lw	a5,4(s4)
    800057e8:	fe9788e3          	beq	a5,s1,800057d8 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800057ec:	f9042903          	lw	s2,-112(s0)
    800057f0:	20090713          	addi	a4,s2,512
    800057f4:	0712                	slli	a4,a4,0x4
    800057f6:	00019797          	auipc	a5,0x19
    800057fa:	80a78793          	addi	a5,a5,-2038 # 8001e000 <disk>
    800057fe:	97ba                	add	a5,a5,a4
    80005800:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005804:	0001a997          	auipc	s3,0x1a
    80005808:	7fc98993          	addi	s3,s3,2044 # 80020000 <disk+0x2000>
    8000580c:	00491713          	slli	a4,s2,0x4
    80005810:	0009b783          	ld	a5,0(s3)
    80005814:	97ba                	add	a5,a5,a4
    80005816:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000581a:	854a                	mv	a0,s2
    8000581c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005820:	00000097          	auipc	ra,0x0
    80005824:	c3a080e7          	jalr	-966(ra) # 8000545a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005828:	8885                	andi	s1,s1,1
    8000582a:	f0ed                	bnez	s1,8000580c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000582c:	0001b517          	auipc	a0,0x1b
    80005830:	8fc50513          	addi	a0,a0,-1796 # 80020128 <disk+0x2128>
    80005834:	00001097          	auipc	ra,0x1
    80005838:	066080e7          	jalr	102(ra) # 8000689a <release>
}
    8000583c:	70a6                	ld	ra,104(sp)
    8000583e:	7406                	ld	s0,96(sp)
    80005840:	64e6                	ld	s1,88(sp)
    80005842:	6946                	ld	s2,80(sp)
    80005844:	69a6                	ld	s3,72(sp)
    80005846:	6a06                	ld	s4,64(sp)
    80005848:	7ae2                	ld	s5,56(sp)
    8000584a:	7b42                	ld	s6,48(sp)
    8000584c:	7ba2                	ld	s7,40(sp)
    8000584e:	7c02                	ld	s8,32(sp)
    80005850:	6ce2                	ld	s9,24(sp)
    80005852:	6165                	addi	sp,sp,112
    80005854:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005856:	f9042503          	lw	a0,-112(s0)
    8000585a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000585e:	00018597          	auipc	a1,0x18
    80005862:	7a258593          	addi	a1,a1,1954 # 8001e000 <disk>
    80005866:	20050793          	addi	a5,a0,512
    8000586a:	0792                	slli	a5,a5,0x4
    8000586c:	97ae                	add	a5,a5,a1
    8000586e:	01903733          	snez	a4,s9
    80005872:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005876:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000587a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000587e:	0001a717          	auipc	a4,0x1a
    80005882:	78270713          	addi	a4,a4,1922 # 80020000 <disk+0x2000>
    80005886:	6314                	ld	a3,0(a4)
    80005888:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000588a:	6789                	lui	a5,0x2
    8000588c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005890:	97b2                	add	a5,a5,a2
    80005892:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005894:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005896:	631c                	ld	a5,0(a4)
    80005898:	97b2                	add	a5,a5,a2
    8000589a:	46c1                	li	a3,16
    8000589c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000589e:	631c                	ld	a5,0(a4)
    800058a0:	97b2                	add	a5,a5,a2
    800058a2:	4685                	li	a3,1
    800058a4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800058a8:	f9442783          	lw	a5,-108(s0)
    800058ac:	6314                	ld	a3,0(a4)
    800058ae:	96b2                	add	a3,a3,a2
    800058b0:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800058b4:	0792                	slli	a5,a5,0x4
    800058b6:	6314                	ld	a3,0(a4)
    800058b8:	96be                	add	a3,a3,a5
    800058ba:	060a0593          	addi	a1,s4,96
    800058be:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    800058c0:	6318                	ld	a4,0(a4)
    800058c2:	973e                	add	a4,a4,a5
    800058c4:	40000693          	li	a3,1024
    800058c8:	c714                	sw	a3,8(a4)
  if(write)
    800058ca:	e40c97e3          	bnez	s9,80005718 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058ce:	0001a717          	auipc	a4,0x1a
    800058d2:	73273703          	ld	a4,1842(a4) # 80020000 <disk+0x2000>
    800058d6:	973e                	add	a4,a4,a5
    800058d8:	4689                	li	a3,2
    800058da:	00d71623          	sh	a3,12(a4)
    800058de:	b5a1                	j	80005726 <virtio_disk_rw+0xd4>

00000000800058e0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058e0:	1101                	addi	sp,sp,-32
    800058e2:	ec06                	sd	ra,24(sp)
    800058e4:	e822                	sd	s0,16(sp)
    800058e6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058e8:	0001b517          	auipc	a0,0x1b
    800058ec:	84050513          	addi	a0,a0,-1984 # 80020128 <disk+0x2128>
    800058f0:	00001097          	auipc	ra,0x1
    800058f4:	eda080e7          	jalr	-294(ra) # 800067ca <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058f8:	100017b7          	lui	a5,0x10001
    800058fc:	53b8                	lw	a4,96(a5)
    800058fe:	8b0d                	andi	a4,a4,3
    80005900:	100017b7          	lui	a5,0x10001
    80005904:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005906:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000590a:	0001a797          	auipc	a5,0x1a
    8000590e:	6f678793          	addi	a5,a5,1782 # 80020000 <disk+0x2000>
    80005912:	6b94                	ld	a3,16(a5)
    80005914:	0207d703          	lhu	a4,32(a5)
    80005918:	0026d783          	lhu	a5,2(a3)
    8000591c:	06f70563          	beq	a4,a5,80005986 <virtio_disk_intr+0xa6>
    80005920:	e426                	sd	s1,8(sp)
    80005922:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005924:	00018917          	auipc	s2,0x18
    80005928:	6dc90913          	addi	s2,s2,1756 # 8001e000 <disk>
    8000592c:	0001a497          	auipc	s1,0x1a
    80005930:	6d448493          	addi	s1,s1,1748 # 80020000 <disk+0x2000>
    __sync_synchronize();
    80005934:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005938:	6898                	ld	a4,16(s1)
    8000593a:	0204d783          	lhu	a5,32(s1)
    8000593e:	8b9d                	andi	a5,a5,7
    80005940:	078e                	slli	a5,a5,0x3
    80005942:	97ba                	add	a5,a5,a4
    80005944:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005946:	20078713          	addi	a4,a5,512
    8000594a:	0712                	slli	a4,a4,0x4
    8000594c:	974a                	add	a4,a4,s2
    8000594e:	03074703          	lbu	a4,48(a4)
    80005952:	e731                	bnez	a4,8000599e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005954:	20078793          	addi	a5,a5,512
    80005958:	0792                	slli	a5,a5,0x4
    8000595a:	97ca                	add	a5,a5,s2
    8000595c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000595e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005962:	ffffc097          	auipc	ra,0xffffc
    80005966:	e66080e7          	jalr	-410(ra) # 800017c8 <wakeup>

    disk.used_idx += 1;
    8000596a:	0204d783          	lhu	a5,32(s1)
    8000596e:	2785                	addiw	a5,a5,1
    80005970:	17c2                	slli	a5,a5,0x30
    80005972:	93c1                	srli	a5,a5,0x30
    80005974:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005978:	6898                	ld	a4,16(s1)
    8000597a:	00275703          	lhu	a4,2(a4)
    8000597e:	faf71be3          	bne	a4,a5,80005934 <virtio_disk_intr+0x54>
    80005982:	64a2                	ld	s1,8(sp)
    80005984:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005986:	0001a517          	auipc	a0,0x1a
    8000598a:	7a250513          	addi	a0,a0,1954 # 80020128 <disk+0x2128>
    8000598e:	00001097          	auipc	ra,0x1
    80005992:	f0c080e7          	jalr	-244(ra) # 8000689a <release>
}
    80005996:	60e2                	ld	ra,24(sp)
    80005998:	6442                	ld	s0,16(sp)
    8000599a:	6105                	addi	sp,sp,32
    8000599c:	8082                	ret
      panic("virtio_disk_intr status");
    8000599e:	00003517          	auipc	a0,0x3
    800059a2:	cf250513          	addi	a0,a0,-782 # 80008690 <etext+0x690>
    800059a6:	00001097          	auipc	ra,0x1
    800059aa:	8c0080e7          	jalr	-1856(ra) # 80006266 <panic>

00000000800059ae <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    800059ae:	1141                	addi	sp,sp,-16
    800059b0:	e422                	sd	s0,8(sp)
    800059b2:	0800                	addi	s0,sp,16
  return -1;
}
    800059b4:	557d                	li	a0,-1
    800059b6:	6422                	ld	s0,8(sp)
    800059b8:	0141                	addi	sp,sp,16
    800059ba:	8082                	ret

00000000800059bc <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    800059bc:	7179                	addi	sp,sp,-48
    800059be:	f406                	sd	ra,40(sp)
    800059c0:	f022                	sd	s0,32(sp)
    800059c2:	ec26                	sd	s1,24(sp)
    800059c4:	e84a                	sd	s2,16(sp)
    800059c6:	e44e                	sd	s3,8(sp)
    800059c8:	1800                	addi	s0,sp,48
    800059ca:	892a                	mv	s2,a0
    800059cc:	89ae                	mv	s3,a1
    800059ce:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    800059d0:	0001b517          	auipc	a0,0x1b
    800059d4:	63050513          	addi	a0,a0,1584 # 80021000 <stats>
    800059d8:	00001097          	auipc	ra,0x1
    800059dc:	df2080e7          	jalr	-526(ra) # 800067ca <acquire>

  if(stats.sz == 0) {
    800059e0:	0001c797          	auipc	a5,0x1c
    800059e4:	6407a783          	lw	a5,1600(a5) # 80022020 <stats+0x1020>
    800059e8:	cbbd                	beqz	a5,80005a5e <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    800059ea:	0001c797          	auipc	a5,0x1c
    800059ee:	61678793          	addi	a5,a5,1558 # 80022000 <stats+0x1000>
    800059f2:	53d8                	lw	a4,36(a5)
    800059f4:	539c                	lw	a5,32(a5)
    800059f6:	9f99                	subw	a5,a5,a4
    800059f8:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    800059fc:	06d05f63          	blez	a3,80005a7a <statsread+0xbe>
    80005a00:	e052                	sd	s4,0(sp)
    if(m > n)
    80005a02:	8a3e                	mv	s4,a5
    80005a04:	00d4d363          	bge	s1,a3,80005a0a <statsread+0x4e>
    80005a08:	8a26                	mv	s4,s1
    80005a0a:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005a0e:	86a6                	mv	a3,s1
    80005a10:	0001b617          	auipc	a2,0x1b
    80005a14:	61060613          	addi	a2,a2,1552 # 80021020 <stats+0x20>
    80005a18:	963a                	add	a2,a2,a4
    80005a1a:	85ce                	mv	a1,s3
    80005a1c:	854a                	mv	a0,s2
    80005a1e:	ffffc097          	auipc	ra,0xffffc
    80005a22:	fc2080e7          	jalr	-62(ra) # 800019e0 <either_copyout>
    80005a26:	57fd                	li	a5,-1
    80005a28:	06f50363          	beq	a0,a5,80005a8e <statsread+0xd2>
      stats.off += m;
    80005a2c:	0001c717          	auipc	a4,0x1c
    80005a30:	5d470713          	addi	a4,a4,1492 # 80022000 <stats+0x1000>
    80005a34:	535c                	lw	a5,36(a4)
    80005a36:	00fa07bb          	addw	a5,s4,a5
    80005a3a:	d35c                	sw	a5,36(a4)
    80005a3c:	6a02                	ld	s4,0(sp)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005a3e:	0001b517          	auipc	a0,0x1b
    80005a42:	5c250513          	addi	a0,a0,1474 # 80021000 <stats>
    80005a46:	00001097          	auipc	ra,0x1
    80005a4a:	e54080e7          	jalr	-428(ra) # 8000689a <release>
  return m;
}
    80005a4e:	8526                	mv	a0,s1
    80005a50:	70a2                	ld	ra,40(sp)
    80005a52:	7402                	ld	s0,32(sp)
    80005a54:	64e2                	ld	s1,24(sp)
    80005a56:	6942                	ld	s2,16(sp)
    80005a58:	69a2                	ld	s3,8(sp)
    80005a5a:	6145                	addi	sp,sp,48
    80005a5c:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005a5e:	6585                	lui	a1,0x1
    80005a60:	0001b517          	auipc	a0,0x1b
    80005a64:	5c050513          	addi	a0,a0,1472 # 80021020 <stats+0x20>
    80005a68:	00001097          	auipc	ra,0x1
    80005a6c:	fb8080e7          	jalr	-72(ra) # 80006a20 <statslock>
    80005a70:	0001c797          	auipc	a5,0x1c
    80005a74:	5aa7a823          	sw	a0,1456(a5) # 80022020 <stats+0x1020>
    80005a78:	bf8d                	j	800059ea <statsread+0x2e>
    stats.sz = 0;
    80005a7a:	0001c797          	auipc	a5,0x1c
    80005a7e:	58678793          	addi	a5,a5,1414 # 80022000 <stats+0x1000>
    80005a82:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005a86:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005a8a:	54fd                	li	s1,-1
    80005a8c:	bf4d                	j	80005a3e <statsread+0x82>
    80005a8e:	6a02                	ld	s4,0(sp)
    80005a90:	b77d                	j	80005a3e <statsread+0x82>

0000000080005a92 <statsinit>:

void
statsinit(void)
{
    80005a92:	1141                	addi	sp,sp,-16
    80005a94:	e406                	sd	ra,8(sp)
    80005a96:	e022                	sd	s0,0(sp)
    80005a98:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005a9a:	00003597          	auipc	a1,0x3
    80005a9e:	c0e58593          	addi	a1,a1,-1010 # 800086a8 <etext+0x6a8>
    80005aa2:	0001b517          	auipc	a0,0x1b
    80005aa6:	55e50513          	addi	a0,a0,1374 # 80021000 <stats>
    80005aaa:	00001097          	auipc	ra,0x1
    80005aae:	e9c080e7          	jalr	-356(ra) # 80006946 <initlock>

  devsw[STATS].read = statsread;
    80005ab2:	00017797          	auipc	a5,0x17
    80005ab6:	20e78793          	addi	a5,a5,526 # 8001ccc0 <devsw>
    80005aba:	00000717          	auipc	a4,0x0
    80005abe:	f0270713          	addi	a4,a4,-254 # 800059bc <statsread>
    80005ac2:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005ac4:	00000717          	auipc	a4,0x0
    80005ac8:	eea70713          	addi	a4,a4,-278 # 800059ae <statswrite>
    80005acc:	f798                	sd	a4,40(a5)
}
    80005ace:	60a2                	ld	ra,8(sp)
    80005ad0:	6402                	ld	s0,0(sp)
    80005ad2:	0141                	addi	sp,sp,16
    80005ad4:	8082                	ret

0000000080005ad6 <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005ad6:	1101                	addi	sp,sp,-32
    80005ad8:	ec22                	sd	s0,24(sp)
    80005ada:	1000                	addi	s0,sp,32
    80005adc:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005ade:	c299                	beqz	a3,80005ae4 <sprintint+0xe>
    80005ae0:	0805c263          	bltz	a1,80005b64 <sprintint+0x8e>
    x = -xx;
  else
    x = xx;
    80005ae4:	2581                	sext.w	a1,a1
    80005ae6:	4301                	li	t1,0

  i = 0;
    80005ae8:	fe040713          	addi	a4,s0,-32
    80005aec:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005aee:	2601                	sext.w	a2,a2
    80005af0:	00003697          	auipc	a3,0x3
    80005af4:	db068693          	addi	a3,a3,-592 # 800088a0 <digits>
    80005af8:	88aa                	mv	a7,a0
    80005afa:	2505                	addiw	a0,a0,1
    80005afc:	02c5f7bb          	remuw	a5,a1,a2
    80005b00:	1782                	slli	a5,a5,0x20
    80005b02:	9381                	srli	a5,a5,0x20
    80005b04:	97b6                	add	a5,a5,a3
    80005b06:	0007c783          	lbu	a5,0(a5)
    80005b0a:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005b0e:	0005879b          	sext.w	a5,a1
    80005b12:	02c5d5bb          	divuw	a1,a1,a2
    80005b16:	0705                	addi	a4,a4,1
    80005b18:	fec7f0e3          	bgeu	a5,a2,80005af8 <sprintint+0x22>

  if(sign)
    80005b1c:	00030b63          	beqz	t1,80005b32 <sprintint+0x5c>
    buf[i++] = '-';
    80005b20:	ff050793          	addi	a5,a0,-16
    80005b24:	97a2                	add	a5,a5,s0
    80005b26:	02d00713          	li	a4,45
    80005b2a:	fee78823          	sb	a4,-16(a5)
    80005b2e:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005b32:	02a05d63          	blez	a0,80005b6c <sprintint+0x96>
    80005b36:	fe040793          	addi	a5,s0,-32
    80005b3a:	00a78733          	add	a4,a5,a0
    80005b3e:	87c2                	mv	a5,a6
    80005b40:	00180613          	addi	a2,a6,1
    80005b44:	fff5069b          	addiw	a3,a0,-1
    80005b48:	1682                	slli	a3,a3,0x20
    80005b4a:	9281                	srli	a3,a3,0x20
    80005b4c:	9636                	add	a2,a2,a3
  *s = c;
    80005b4e:	fff74683          	lbu	a3,-1(a4)
    80005b52:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005b56:	177d                	addi	a4,a4,-1
    80005b58:	0785                	addi	a5,a5,1
    80005b5a:	fec79ae3          	bne	a5,a2,80005b4e <sprintint+0x78>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005b5e:	6462                	ld	s0,24(sp)
    80005b60:	6105                	addi	sp,sp,32
    80005b62:	8082                	ret
    x = -xx;
    80005b64:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005b68:	4305                	li	t1,1
    x = -xx;
    80005b6a:	bfbd                	j	80005ae8 <sprintint+0x12>
  while(--i >= 0)
    80005b6c:	4501                	li	a0,0
    80005b6e:	bfc5                	j	80005b5e <sprintint+0x88>

0000000080005b70 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005b70:	7135                	addi	sp,sp,-160
    80005b72:	f486                	sd	ra,104(sp)
    80005b74:	f0a2                	sd	s0,96(sp)
    80005b76:	1880                	addi	s0,sp,112
    80005b78:	e414                	sd	a3,8(s0)
    80005b7a:	e818                	sd	a4,16(s0)
    80005b7c:	ec1c                	sd	a5,24(s0)
    80005b7e:	03043023          	sd	a6,32(s0)
    80005b82:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005b86:	ce15                	beqz	a2,80005bc2 <snprintf+0x52>
    80005b88:	eca6                	sd	s1,88(sp)
    80005b8a:	e8ca                	sd	s2,80(sp)
    80005b8c:	e4ce                	sd	s3,72(sp)
    80005b8e:	fc56                	sd	s5,56(sp)
    80005b90:	f85a                	sd	s6,48(sp)
    80005b92:	8b2a                	mv	s6,a0
    80005b94:	8aae                	mv	s5,a1
    80005b96:	89b2                	mv	s3,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005b98:	00840793          	addi	a5,s0,8
    80005b9c:	f8f43c23          	sd	a5,-104(s0)
  int off = 0;
    80005ba0:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005ba2:	4901                	li	s2,0
    80005ba4:	04b05063          	blez	a1,80005be4 <snprintf+0x74>
    80005ba8:	e0d2                	sd	s4,64(sp)
    80005baa:	f45e                	sd	s7,40(sp)
    80005bac:	f062                	sd	s8,32(sp)
    80005bae:	ec66                	sd	s9,24(sp)
    if(c != '%'){
    80005bb0:	02500a13          	li	s4,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005bb4:	07300b93          	li	s7,115
    80005bb8:	07800c93          	li	s9,120
    80005bbc:	06400c13          	li	s8,100
    80005bc0:	a825                	j	80005bf8 <snprintf+0x88>
    80005bc2:	eca6                	sd	s1,88(sp)
    80005bc4:	e8ca                	sd	s2,80(sp)
    80005bc6:	e4ce                	sd	s3,72(sp)
    80005bc8:	e0d2                	sd	s4,64(sp)
    80005bca:	fc56                	sd	s5,56(sp)
    80005bcc:	f85a                	sd	s6,48(sp)
    80005bce:	f45e                	sd	s7,40(sp)
    80005bd0:	f062                	sd	s8,32(sp)
    80005bd2:	ec66                	sd	s9,24(sp)
    panic("null fmt");
    80005bd4:	00003517          	auipc	a0,0x3
    80005bd8:	ae450513          	addi	a0,a0,-1308 # 800086b8 <etext+0x6b8>
    80005bdc:	00000097          	auipc	ra,0x0
    80005be0:	68a080e7          	jalr	1674(ra) # 80006266 <panic>
  int off = 0;
    80005be4:	4481                	li	s1,0
    80005be6:	a8d9                	j	80005cbc <snprintf+0x14c>
  *s = c;
    80005be8:	009b0733          	add	a4,s6,s1
    80005bec:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005bf0:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005bf2:	2905                	addiw	s2,s2,1
    80005bf4:	1354d563          	bge	s1,s5,80005d1e <snprintf+0x1ae>
    80005bf8:	012987b3          	add	a5,s3,s2
    80005bfc:	0007c783          	lbu	a5,0(a5)
    80005c00:	0007871b          	sext.w	a4,a5
    80005c04:	cff5                	beqz	a5,80005d00 <snprintf+0x190>
    if(c != '%'){
    80005c06:	ff4711e3          	bne	a4,s4,80005be8 <snprintf+0x78>
    c = fmt[++i] & 0xff;
    80005c0a:	2905                	addiw	s2,s2,1
    80005c0c:	012987b3          	add	a5,s3,s2
    80005c10:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005c14:	cbfd                	beqz	a5,80005d0a <snprintf+0x19a>
    switch(c){
    80005c16:	05778c63          	beq	a5,s7,80005c6e <snprintf+0xfe>
    80005c1a:	02fbe763          	bltu	s7,a5,80005c48 <snprintf+0xd8>
    80005c1e:	0d478063          	beq	a5,s4,80005cde <snprintf+0x16e>
    80005c22:	0d879463          	bne	a5,s8,80005cea <snprintf+0x17a>
    case 'd':
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005c26:	f9843783          	ld	a5,-104(s0)
    80005c2a:	00878713          	addi	a4,a5,8
    80005c2e:	f8e43c23          	sd	a4,-104(s0)
    80005c32:	4685                	li	a3,1
    80005c34:	4629                	li	a2,10
    80005c36:	438c                	lw	a1,0(a5)
    80005c38:	009b0533          	add	a0,s6,s1
    80005c3c:	00000097          	auipc	ra,0x0
    80005c40:	e9a080e7          	jalr	-358(ra) # 80005ad6 <sprintint>
    80005c44:	9ca9                	addw	s1,s1,a0
      break;
    80005c46:	b775                	j	80005bf2 <snprintf+0x82>
    switch(c){
    80005c48:	0b979163          	bne	a5,s9,80005cea <snprintf+0x17a>
    case 'x':
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005c4c:	f9843783          	ld	a5,-104(s0)
    80005c50:	00878713          	addi	a4,a5,8
    80005c54:	f8e43c23          	sd	a4,-104(s0)
    80005c58:	4685                	li	a3,1
    80005c5a:	4641                	li	a2,16
    80005c5c:	438c                	lw	a1,0(a5)
    80005c5e:	009b0533          	add	a0,s6,s1
    80005c62:	00000097          	auipc	ra,0x0
    80005c66:	e74080e7          	jalr	-396(ra) # 80005ad6 <sprintint>
    80005c6a:	9ca9                	addw	s1,s1,a0
      break;
    80005c6c:	b759                	j	80005bf2 <snprintf+0x82>
    case 's':
      if((s = va_arg(ap, char*)) == 0)
    80005c6e:	f9843783          	ld	a5,-104(s0)
    80005c72:	00878713          	addi	a4,a5,8
    80005c76:	f8e43c23          	sd	a4,-104(s0)
    80005c7a:	6388                	ld	a0,0(a5)
    80005c7c:	c931                	beqz	a0,80005cd0 <snprintf+0x160>
        s = "(null)";
      for(; *s && off < sz; s++)
    80005c7e:	00054703          	lbu	a4,0(a0)
    80005c82:	db25                	beqz	a4,80005bf2 <snprintf+0x82>
    80005c84:	0954d863          	bge	s1,s5,80005d14 <snprintf+0x1a4>
    80005c88:	009b06b3          	add	a3,s6,s1
    80005c8c:	409a863b          	subw	a2,s5,s1
    80005c90:	1602                	slli	a2,a2,0x20
    80005c92:	9201                	srli	a2,a2,0x20
    80005c94:	962a                	add	a2,a2,a0
    80005c96:	87aa                	mv	a5,a0
        off += sputc(buf+off, *s);
    80005c98:	0014859b          	addiw	a1,s1,1
    80005c9c:	9d89                	subw	a1,a1,a0
  *s = c;
    80005c9e:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005ca2:	00f584bb          	addw	s1,a1,a5
      for(; *s && off < sz; s++)
    80005ca6:	0785                	addi	a5,a5,1
    80005ca8:	0007c703          	lbu	a4,0(a5)
    80005cac:	d339                	beqz	a4,80005bf2 <snprintf+0x82>
    80005cae:	0685                	addi	a3,a3,1
    80005cb0:	fec797e3          	bne	a5,a2,80005c9e <snprintf+0x12e>
    80005cb4:	6a06                	ld	s4,64(sp)
    80005cb6:	7ba2                	ld	s7,40(sp)
    80005cb8:	7c02                	ld	s8,32(sp)
    80005cba:	6ce2                	ld	s9,24(sp)
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005cbc:	8526                	mv	a0,s1
    80005cbe:	64e6                	ld	s1,88(sp)
    80005cc0:	6946                	ld	s2,80(sp)
    80005cc2:	69a6                	ld	s3,72(sp)
    80005cc4:	7ae2                	ld	s5,56(sp)
    80005cc6:	7b42                	ld	s6,48(sp)
    80005cc8:	70a6                	ld	ra,104(sp)
    80005cca:	7406                	ld	s0,96(sp)
    80005ccc:	610d                	addi	sp,sp,160
    80005cce:	8082                	ret
      for(; *s && off < sz; s++)
    80005cd0:	02800713          	li	a4,40
        s = "(null)";
    80005cd4:	00003517          	auipc	a0,0x3
    80005cd8:	9dc50513          	addi	a0,a0,-1572 # 800086b0 <etext+0x6b0>
    80005cdc:	b765                	j	80005c84 <snprintf+0x114>
  *s = c;
    80005cde:	009b07b3          	add	a5,s6,s1
    80005ce2:	01478023          	sb	s4,0(a5)
      off += sputc(buf+off, '%');
    80005ce6:	2485                	addiw	s1,s1,1
      break;
    80005ce8:	b729                	j	80005bf2 <snprintf+0x82>
  *s = c;
    80005cea:	009b0733          	add	a4,s6,s1
    80005cee:	01470023          	sb	s4,0(a4)
      off += sputc(buf+off, c);
    80005cf2:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005cf6:	975a                	add	a4,a4,s6
    80005cf8:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005cfc:	2489                	addiw	s1,s1,2
      break;
    80005cfe:	bdd5                	j	80005bf2 <snprintf+0x82>
    80005d00:	6a06                	ld	s4,64(sp)
    80005d02:	7ba2                	ld	s7,40(sp)
    80005d04:	7c02                	ld	s8,32(sp)
    80005d06:	6ce2                	ld	s9,24(sp)
    80005d08:	bf55                	j	80005cbc <snprintf+0x14c>
    80005d0a:	6a06                	ld	s4,64(sp)
    80005d0c:	7ba2                	ld	s7,40(sp)
    80005d0e:	7c02                	ld	s8,32(sp)
    80005d10:	6ce2                	ld	s9,24(sp)
    80005d12:	b76d                	j	80005cbc <snprintf+0x14c>
    80005d14:	6a06                	ld	s4,64(sp)
    80005d16:	7ba2                	ld	s7,40(sp)
    80005d18:	7c02                	ld	s8,32(sp)
    80005d1a:	6ce2                	ld	s9,24(sp)
    80005d1c:	b745                	j	80005cbc <snprintf+0x14c>
    80005d1e:	6a06                	ld	s4,64(sp)
    80005d20:	7ba2                	ld	s7,40(sp)
    80005d22:	7c02                	ld	s8,32(sp)
    80005d24:	6ce2                	ld	s9,24(sp)
    80005d26:	bf59                	j	80005cbc <snprintf+0x14c>

0000000080005d28 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005d28:	1141                	addi	sp,sp,-16
    80005d2a:	e422                	sd	s0,8(sp)
    80005d2c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d2e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005d32:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005d36:	0037979b          	slliw	a5,a5,0x3
    80005d3a:	02004737          	lui	a4,0x2004
    80005d3e:	97ba                	add	a5,a5,a4
    80005d40:	0200c737          	lui	a4,0x200c
    80005d44:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005d46:	6318                	ld	a4,0(a4)
    80005d48:	000f4637          	lui	a2,0xf4
    80005d4c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005d50:	9732                	add	a4,a4,a2
    80005d52:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005d54:	00259693          	slli	a3,a1,0x2
    80005d58:	96ae                	add	a3,a3,a1
    80005d5a:	068e                	slli	a3,a3,0x3
    80005d5c:	0001c717          	auipc	a4,0x1c
    80005d60:	2d470713          	addi	a4,a4,724 # 80022030 <timer_scratch>
    80005d64:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005d66:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005d68:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005d6a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005d6e:	fffff797          	auipc	a5,0xfffff
    80005d72:	62278793          	addi	a5,a5,1570 # 80005390 <timervec>
    80005d76:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005d7a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005d7e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d82:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005d86:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005d8a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005d8e:	30479073          	csrw	mie,a5
}
    80005d92:	6422                	ld	s0,8(sp)
    80005d94:	0141                	addi	sp,sp,16
    80005d96:	8082                	ret

0000000080005d98 <start>:
{
    80005d98:	1141                	addi	sp,sp,-16
    80005d9a:	e406                	sd	ra,8(sp)
    80005d9c:	e022                	sd	s0,0(sp)
    80005d9e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005da0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005da4:	7779                	lui	a4,0xffffe
    80005da6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd35b7>
    80005daa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005dac:	6705                	lui	a4,0x1
    80005dae:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005db2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005db4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005db8:	ffffa797          	auipc	a5,0xffffa
    80005dbc:	64a78793          	addi	a5,a5,1610 # 80000402 <main>
    80005dc0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005dc4:	4781                	li	a5,0
    80005dc6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005dca:	67c1                	lui	a5,0x10
    80005dcc:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005dce:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005dd2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005dd6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005dda:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005dde:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005de2:	57fd                	li	a5,-1
    80005de4:	83a9                	srli	a5,a5,0xa
    80005de6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005dea:	47bd                	li	a5,15
    80005dec:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005df0:	00000097          	auipc	ra,0x0
    80005df4:	f38080e7          	jalr	-200(ra) # 80005d28 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005df8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005dfc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005dfe:	823e                	mv	tp,a5
  asm volatile("mret");
    80005e00:	30200073          	mret
}
    80005e04:	60a2                	ld	ra,8(sp)
    80005e06:	6402                	ld	s0,0(sp)
    80005e08:	0141                	addi	sp,sp,16
    80005e0a:	8082                	ret

0000000080005e0c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005e0c:	715d                	addi	sp,sp,-80
    80005e0e:	e486                	sd	ra,72(sp)
    80005e10:	e0a2                	sd	s0,64(sp)
    80005e12:	f84a                	sd	s2,48(sp)
    80005e14:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005e16:	04c05663          	blez	a2,80005e62 <consolewrite+0x56>
    80005e1a:	fc26                	sd	s1,56(sp)
    80005e1c:	f44e                	sd	s3,40(sp)
    80005e1e:	f052                	sd	s4,32(sp)
    80005e20:	ec56                	sd	s5,24(sp)
    80005e22:	8a2a                	mv	s4,a0
    80005e24:	84ae                	mv	s1,a1
    80005e26:	89b2                	mv	s3,a2
    80005e28:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005e2a:	5afd                	li	s5,-1
    80005e2c:	4685                	li	a3,1
    80005e2e:	8626                	mv	a2,s1
    80005e30:	85d2                	mv	a1,s4
    80005e32:	fbf40513          	addi	a0,s0,-65
    80005e36:	ffffc097          	auipc	ra,0xffffc
    80005e3a:	c00080e7          	jalr	-1024(ra) # 80001a36 <either_copyin>
    80005e3e:	03550463          	beq	a0,s5,80005e66 <consolewrite+0x5a>
      break;
    uartputc(c);
    80005e42:	fbf44503          	lbu	a0,-65(s0)
    80005e46:	00000097          	auipc	ra,0x0
    80005e4a:	7de080e7          	jalr	2014(ra) # 80006624 <uartputc>
  for(i = 0; i < n; i++){
    80005e4e:	2905                	addiw	s2,s2,1
    80005e50:	0485                	addi	s1,s1,1
    80005e52:	fd299de3          	bne	s3,s2,80005e2c <consolewrite+0x20>
    80005e56:	894e                	mv	s2,s3
    80005e58:	74e2                	ld	s1,56(sp)
    80005e5a:	79a2                	ld	s3,40(sp)
    80005e5c:	7a02                	ld	s4,32(sp)
    80005e5e:	6ae2                	ld	s5,24(sp)
    80005e60:	a039                	j	80005e6e <consolewrite+0x62>
    80005e62:	4901                	li	s2,0
    80005e64:	a029                	j	80005e6e <consolewrite+0x62>
    80005e66:	74e2                	ld	s1,56(sp)
    80005e68:	79a2                	ld	s3,40(sp)
    80005e6a:	7a02                	ld	s4,32(sp)
    80005e6c:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005e6e:	854a                	mv	a0,s2
    80005e70:	60a6                	ld	ra,72(sp)
    80005e72:	6406                	ld	s0,64(sp)
    80005e74:	7942                	ld	s2,48(sp)
    80005e76:	6161                	addi	sp,sp,80
    80005e78:	8082                	ret

0000000080005e7a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005e7a:	711d                	addi	sp,sp,-96
    80005e7c:	ec86                	sd	ra,88(sp)
    80005e7e:	e8a2                	sd	s0,80(sp)
    80005e80:	e4a6                	sd	s1,72(sp)
    80005e82:	e0ca                	sd	s2,64(sp)
    80005e84:	fc4e                	sd	s3,56(sp)
    80005e86:	f852                	sd	s4,48(sp)
    80005e88:	f456                	sd	s5,40(sp)
    80005e8a:	f05a                	sd	s6,32(sp)
    80005e8c:	1080                	addi	s0,sp,96
    80005e8e:	8aaa                	mv	s5,a0
    80005e90:	8a2e                	mv	s4,a1
    80005e92:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005e94:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005e98:	00024517          	auipc	a0,0x24
    80005e9c:	2d850513          	addi	a0,a0,728 # 8002a170 <cons>
    80005ea0:	00001097          	auipc	ra,0x1
    80005ea4:	92a080e7          	jalr	-1750(ra) # 800067ca <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ea8:	00024497          	auipc	s1,0x24
    80005eac:	2c848493          	addi	s1,s1,712 # 8002a170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005eb0:	00024917          	auipc	s2,0x24
    80005eb4:	36090913          	addi	s2,s2,864 # 8002a210 <cons+0xa0>
  while(n > 0){
    80005eb8:	0d305463          	blez	s3,80005f80 <consoleread+0x106>
    while(cons.r == cons.w){
    80005ebc:	0a04a783          	lw	a5,160(s1)
    80005ec0:	0a44a703          	lw	a4,164(s1)
    80005ec4:	0af71963          	bne	a4,a5,80005f76 <consoleread+0xfc>
      if(myproc()->killed){
    80005ec8:	ffffb097          	auipc	ra,0xffffb
    80005ecc:	0ae080e7          	jalr	174(ra) # 80000f76 <myproc>
    80005ed0:	591c                	lw	a5,48(a0)
    80005ed2:	e7ad                	bnez	a5,80005f3c <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005ed4:	85a6                	mv	a1,s1
    80005ed6:	854a                	mv	a0,s2
    80005ed8:	ffffb097          	auipc	ra,0xffffb
    80005edc:	764080e7          	jalr	1892(ra) # 8000163c <sleep>
    while(cons.r == cons.w){
    80005ee0:	0a04a783          	lw	a5,160(s1)
    80005ee4:	0a44a703          	lw	a4,164(s1)
    80005ee8:	fef700e3          	beq	a4,a5,80005ec8 <consoleread+0x4e>
    80005eec:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005eee:	00024717          	auipc	a4,0x24
    80005ef2:	28270713          	addi	a4,a4,642 # 8002a170 <cons>
    80005ef6:	0017869b          	addiw	a3,a5,1
    80005efa:	0ad72023          	sw	a3,160(a4)
    80005efe:	07f7f693          	andi	a3,a5,127
    80005f02:	9736                	add	a4,a4,a3
    80005f04:	02074703          	lbu	a4,32(a4)
    80005f08:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005f0c:	4691                	li	a3,4
    80005f0e:	04db8a63          	beq	s7,a3,80005f62 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005f12:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005f16:	4685                	li	a3,1
    80005f18:	faf40613          	addi	a2,s0,-81
    80005f1c:	85d2                	mv	a1,s4
    80005f1e:	8556                	mv	a0,s5
    80005f20:	ffffc097          	auipc	ra,0xffffc
    80005f24:	ac0080e7          	jalr	-1344(ra) # 800019e0 <either_copyout>
    80005f28:	57fd                	li	a5,-1
    80005f2a:	04f50a63          	beq	a0,a5,80005f7e <consoleread+0x104>
      break;

    dst++;
    80005f2e:	0a05                	addi	s4,s4,1
    --n;
    80005f30:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005f32:	47a9                	li	a5,10
    80005f34:	06fb8163          	beq	s7,a5,80005f96 <consoleread+0x11c>
    80005f38:	6be2                	ld	s7,24(sp)
    80005f3a:	bfbd                	j	80005eb8 <consoleread+0x3e>
        release(&cons.lock);
    80005f3c:	00024517          	auipc	a0,0x24
    80005f40:	23450513          	addi	a0,a0,564 # 8002a170 <cons>
    80005f44:	00001097          	auipc	ra,0x1
    80005f48:	956080e7          	jalr	-1706(ra) # 8000689a <release>
        return -1;
    80005f4c:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005f4e:	60e6                	ld	ra,88(sp)
    80005f50:	6446                	ld	s0,80(sp)
    80005f52:	64a6                	ld	s1,72(sp)
    80005f54:	6906                	ld	s2,64(sp)
    80005f56:	79e2                	ld	s3,56(sp)
    80005f58:	7a42                	ld	s4,48(sp)
    80005f5a:	7aa2                	ld	s5,40(sp)
    80005f5c:	7b02                	ld	s6,32(sp)
    80005f5e:	6125                	addi	sp,sp,96
    80005f60:	8082                	ret
      if(n < target){
    80005f62:	0009871b          	sext.w	a4,s3
    80005f66:	01677a63          	bgeu	a4,s6,80005f7a <consoleread+0x100>
        cons.r--;
    80005f6a:	00024717          	auipc	a4,0x24
    80005f6e:	2af72323          	sw	a5,678(a4) # 8002a210 <cons+0xa0>
    80005f72:	6be2                	ld	s7,24(sp)
    80005f74:	a031                	j	80005f80 <consoleread+0x106>
    80005f76:	ec5e                	sd	s7,24(sp)
    80005f78:	bf9d                	j	80005eee <consoleread+0x74>
    80005f7a:	6be2                	ld	s7,24(sp)
    80005f7c:	a011                	j	80005f80 <consoleread+0x106>
    80005f7e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005f80:	00024517          	auipc	a0,0x24
    80005f84:	1f050513          	addi	a0,a0,496 # 8002a170 <cons>
    80005f88:	00001097          	auipc	ra,0x1
    80005f8c:	912080e7          	jalr	-1774(ra) # 8000689a <release>
  return target - n;
    80005f90:	413b053b          	subw	a0,s6,s3
    80005f94:	bf6d                	j	80005f4e <consoleread+0xd4>
    80005f96:	6be2                	ld	s7,24(sp)
    80005f98:	b7e5                	j	80005f80 <consoleread+0x106>

0000000080005f9a <consputc>:
{
    80005f9a:	1141                	addi	sp,sp,-16
    80005f9c:	e406                	sd	ra,8(sp)
    80005f9e:	e022                	sd	s0,0(sp)
    80005fa0:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005fa2:	10000793          	li	a5,256
    80005fa6:	00f50a63          	beq	a0,a5,80005fba <consputc+0x20>
    uartputc_sync(c);
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	59c080e7          	jalr	1436(ra) # 80006546 <uartputc_sync>
}
    80005fb2:	60a2                	ld	ra,8(sp)
    80005fb4:	6402                	ld	s0,0(sp)
    80005fb6:	0141                	addi	sp,sp,16
    80005fb8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005fba:	4521                	li	a0,8
    80005fbc:	00000097          	auipc	ra,0x0
    80005fc0:	58a080e7          	jalr	1418(ra) # 80006546 <uartputc_sync>
    80005fc4:	02000513          	li	a0,32
    80005fc8:	00000097          	auipc	ra,0x0
    80005fcc:	57e080e7          	jalr	1406(ra) # 80006546 <uartputc_sync>
    80005fd0:	4521                	li	a0,8
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	574080e7          	jalr	1396(ra) # 80006546 <uartputc_sync>
    80005fda:	bfe1                	j	80005fb2 <consputc+0x18>

0000000080005fdc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005fdc:	1101                	addi	sp,sp,-32
    80005fde:	ec06                	sd	ra,24(sp)
    80005fe0:	e822                	sd	s0,16(sp)
    80005fe2:	e426                	sd	s1,8(sp)
    80005fe4:	1000                	addi	s0,sp,32
    80005fe6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005fe8:	00024517          	auipc	a0,0x24
    80005fec:	18850513          	addi	a0,a0,392 # 8002a170 <cons>
    80005ff0:	00000097          	auipc	ra,0x0
    80005ff4:	7da080e7          	jalr	2010(ra) # 800067ca <acquire>

  switch(c){
    80005ff8:	47d5                	li	a5,21
    80005ffa:	0af48563          	beq	s1,a5,800060a4 <consoleintr+0xc8>
    80005ffe:	0297c963          	blt	a5,s1,80006030 <consoleintr+0x54>
    80006002:	47a1                	li	a5,8
    80006004:	0ef48c63          	beq	s1,a5,800060fc <consoleintr+0x120>
    80006008:	47c1                	li	a5,16
    8000600a:	10f49f63          	bne	s1,a5,80006128 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    8000600e:	ffffc097          	auipc	ra,0xffffc
    80006012:	a7e080e7          	jalr	-1410(ra) # 80001a8c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80006016:	00024517          	auipc	a0,0x24
    8000601a:	15a50513          	addi	a0,a0,346 # 8002a170 <cons>
    8000601e:	00001097          	auipc	ra,0x1
    80006022:	87c080e7          	jalr	-1924(ra) # 8000689a <release>
}
    80006026:	60e2                	ld	ra,24(sp)
    80006028:	6442                	ld	s0,16(sp)
    8000602a:	64a2                	ld	s1,8(sp)
    8000602c:	6105                	addi	sp,sp,32
    8000602e:	8082                	ret
  switch(c){
    80006030:	07f00793          	li	a5,127
    80006034:	0cf48463          	beq	s1,a5,800060fc <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006038:	00024717          	auipc	a4,0x24
    8000603c:	13870713          	addi	a4,a4,312 # 8002a170 <cons>
    80006040:	0a872783          	lw	a5,168(a4)
    80006044:	0a072703          	lw	a4,160(a4)
    80006048:	9f99                	subw	a5,a5,a4
    8000604a:	07f00713          	li	a4,127
    8000604e:	fcf764e3          	bltu	a4,a5,80006016 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80006052:	47b5                	li	a5,13
    80006054:	0cf48d63          	beq	s1,a5,8000612e <consoleintr+0x152>
      consputc(c);
    80006058:	8526                	mv	a0,s1
    8000605a:	00000097          	auipc	ra,0x0
    8000605e:	f40080e7          	jalr	-192(ra) # 80005f9a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006062:	00024797          	auipc	a5,0x24
    80006066:	10e78793          	addi	a5,a5,270 # 8002a170 <cons>
    8000606a:	0a87a703          	lw	a4,168(a5)
    8000606e:	0017069b          	addiw	a3,a4,1
    80006072:	0006861b          	sext.w	a2,a3
    80006076:	0ad7a423          	sw	a3,168(a5)
    8000607a:	07f77713          	andi	a4,a4,127
    8000607e:	97ba                	add	a5,a5,a4
    80006080:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80006084:	47a9                	li	a5,10
    80006086:	0cf48b63          	beq	s1,a5,8000615c <consoleintr+0x180>
    8000608a:	4791                	li	a5,4
    8000608c:	0cf48863          	beq	s1,a5,8000615c <consoleintr+0x180>
    80006090:	00024797          	auipc	a5,0x24
    80006094:	1807a783          	lw	a5,384(a5) # 8002a210 <cons+0xa0>
    80006098:	0807879b          	addiw	a5,a5,128
    8000609c:	f6f61de3          	bne	a2,a5,80006016 <consoleintr+0x3a>
    800060a0:	863e                	mv	a2,a5
    800060a2:	a86d                	j	8000615c <consoleintr+0x180>
    800060a4:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800060a6:	00024717          	auipc	a4,0x24
    800060aa:	0ca70713          	addi	a4,a4,202 # 8002a170 <cons>
    800060ae:	0a872783          	lw	a5,168(a4)
    800060b2:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800060b6:	00024497          	auipc	s1,0x24
    800060ba:	0ba48493          	addi	s1,s1,186 # 8002a170 <cons>
    while(cons.e != cons.w &&
    800060be:	4929                	li	s2,10
    800060c0:	02f70a63          	beq	a4,a5,800060f4 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800060c4:	37fd                	addiw	a5,a5,-1
    800060c6:	07f7f713          	andi	a4,a5,127
    800060ca:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800060cc:	02074703          	lbu	a4,32(a4)
    800060d0:	03270463          	beq	a4,s2,800060f8 <consoleintr+0x11c>
      cons.e--;
    800060d4:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    800060d8:	10000513          	li	a0,256
    800060dc:	00000097          	auipc	ra,0x0
    800060e0:	ebe080e7          	jalr	-322(ra) # 80005f9a <consputc>
    while(cons.e != cons.w &&
    800060e4:	0a84a783          	lw	a5,168(s1)
    800060e8:	0a44a703          	lw	a4,164(s1)
    800060ec:	fcf71ce3          	bne	a4,a5,800060c4 <consoleintr+0xe8>
    800060f0:	6902                	ld	s2,0(sp)
    800060f2:	b715                	j	80006016 <consoleintr+0x3a>
    800060f4:	6902                	ld	s2,0(sp)
    800060f6:	b705                	j	80006016 <consoleintr+0x3a>
    800060f8:	6902                	ld	s2,0(sp)
    800060fa:	bf31                	j	80006016 <consoleintr+0x3a>
    if(cons.e != cons.w){
    800060fc:	00024717          	auipc	a4,0x24
    80006100:	07470713          	addi	a4,a4,116 # 8002a170 <cons>
    80006104:	0a872783          	lw	a5,168(a4)
    80006108:	0a472703          	lw	a4,164(a4)
    8000610c:	f0f705e3          	beq	a4,a5,80006016 <consoleintr+0x3a>
      cons.e--;
    80006110:	37fd                	addiw	a5,a5,-1
    80006112:	00024717          	auipc	a4,0x24
    80006116:	10f72323          	sw	a5,262(a4) # 8002a218 <cons+0xa8>
      consputc(BACKSPACE);
    8000611a:	10000513          	li	a0,256
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	e7c080e7          	jalr	-388(ra) # 80005f9a <consputc>
    80006126:	bdc5                	j	80006016 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006128:	ee0487e3          	beqz	s1,80006016 <consoleintr+0x3a>
    8000612c:	b731                	j	80006038 <consoleintr+0x5c>
      consputc(c);
    8000612e:	4529                	li	a0,10
    80006130:	00000097          	auipc	ra,0x0
    80006134:	e6a080e7          	jalr	-406(ra) # 80005f9a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006138:	00024797          	auipc	a5,0x24
    8000613c:	03878793          	addi	a5,a5,56 # 8002a170 <cons>
    80006140:	0a87a703          	lw	a4,168(a5)
    80006144:	0017069b          	addiw	a3,a4,1
    80006148:	0006861b          	sext.w	a2,a3
    8000614c:	0ad7a423          	sw	a3,168(a5)
    80006150:	07f77713          	andi	a4,a4,127
    80006154:	97ba                	add	a5,a5,a4
    80006156:	4729                	li	a4,10
    80006158:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    8000615c:	00024797          	auipc	a5,0x24
    80006160:	0ac7ac23          	sw	a2,184(a5) # 8002a214 <cons+0xa4>
        wakeup(&cons.r);
    80006164:	00024517          	auipc	a0,0x24
    80006168:	0ac50513          	addi	a0,a0,172 # 8002a210 <cons+0xa0>
    8000616c:	ffffb097          	auipc	ra,0xffffb
    80006170:	65c080e7          	jalr	1628(ra) # 800017c8 <wakeup>
    80006174:	b54d                	j	80006016 <consoleintr+0x3a>

0000000080006176 <consoleinit>:

void
consoleinit(void)
{
    80006176:	1141                	addi	sp,sp,-16
    80006178:	e406                	sd	ra,8(sp)
    8000617a:	e022                	sd	s0,0(sp)
    8000617c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000617e:	00002597          	auipc	a1,0x2
    80006182:	54a58593          	addi	a1,a1,1354 # 800086c8 <etext+0x6c8>
    80006186:	00024517          	auipc	a0,0x24
    8000618a:	fea50513          	addi	a0,a0,-22 # 8002a170 <cons>
    8000618e:	00000097          	auipc	ra,0x0
    80006192:	7b8080e7          	jalr	1976(ra) # 80006946 <initlock>

  uartinit();
    80006196:	00000097          	auipc	ra,0x0
    8000619a:	354080e7          	jalr	852(ra) # 800064ea <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000619e:	00017797          	auipc	a5,0x17
    800061a2:	b2278793          	addi	a5,a5,-1246 # 8001ccc0 <devsw>
    800061a6:	00000717          	auipc	a4,0x0
    800061aa:	cd470713          	addi	a4,a4,-812 # 80005e7a <consoleread>
    800061ae:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800061b0:	00000717          	auipc	a4,0x0
    800061b4:	c5c70713          	addi	a4,a4,-932 # 80005e0c <consolewrite>
    800061b8:	ef98                	sd	a4,24(a5)
}
    800061ba:	60a2                	ld	ra,8(sp)
    800061bc:	6402                	ld	s0,0(sp)
    800061be:	0141                	addi	sp,sp,16
    800061c0:	8082                	ret

00000000800061c2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800061c2:	7179                	addi	sp,sp,-48
    800061c4:	f406                	sd	ra,40(sp)
    800061c6:	f022                	sd	s0,32(sp)
    800061c8:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800061ca:	c219                	beqz	a2,800061d0 <printint+0xe>
    800061cc:	08054963          	bltz	a0,8000625e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800061d0:	2501                	sext.w	a0,a0
    800061d2:	4881                	li	a7,0
    800061d4:	fd040693          	addi	a3,s0,-48

  i = 0;
    800061d8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800061da:	2581                	sext.w	a1,a1
    800061dc:	00002617          	auipc	a2,0x2
    800061e0:	6dc60613          	addi	a2,a2,1756 # 800088b8 <digits>
    800061e4:	883a                	mv	a6,a4
    800061e6:	2705                	addiw	a4,a4,1
    800061e8:	02b577bb          	remuw	a5,a0,a1
    800061ec:	1782                	slli	a5,a5,0x20
    800061ee:	9381                	srli	a5,a5,0x20
    800061f0:	97b2                	add	a5,a5,a2
    800061f2:	0007c783          	lbu	a5,0(a5)
    800061f6:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800061fa:	0005079b          	sext.w	a5,a0
    800061fe:	02b5553b          	divuw	a0,a0,a1
    80006202:	0685                	addi	a3,a3,1
    80006204:	feb7f0e3          	bgeu	a5,a1,800061e4 <printint+0x22>

  if(sign)
    80006208:	00088c63          	beqz	a7,80006220 <printint+0x5e>
    buf[i++] = '-';
    8000620c:	fe070793          	addi	a5,a4,-32
    80006210:	00878733          	add	a4,a5,s0
    80006214:	02d00793          	li	a5,45
    80006218:	fef70823          	sb	a5,-16(a4)
    8000621c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006220:	02e05b63          	blez	a4,80006256 <printint+0x94>
    80006224:	ec26                	sd	s1,24(sp)
    80006226:	e84a                	sd	s2,16(sp)
    80006228:	fd040793          	addi	a5,s0,-48
    8000622c:	00e784b3          	add	s1,a5,a4
    80006230:	fff78913          	addi	s2,a5,-1
    80006234:	993a                	add	s2,s2,a4
    80006236:	377d                	addiw	a4,a4,-1
    80006238:	1702                	slli	a4,a4,0x20
    8000623a:	9301                	srli	a4,a4,0x20
    8000623c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006240:	fff4c503          	lbu	a0,-1(s1)
    80006244:	00000097          	auipc	ra,0x0
    80006248:	d56080e7          	jalr	-682(ra) # 80005f9a <consputc>
  while(--i >= 0)
    8000624c:	14fd                	addi	s1,s1,-1
    8000624e:	ff2499e3          	bne	s1,s2,80006240 <printint+0x7e>
    80006252:	64e2                	ld	s1,24(sp)
    80006254:	6942                	ld	s2,16(sp)
}
    80006256:	70a2                	ld	ra,40(sp)
    80006258:	7402                	ld	s0,32(sp)
    8000625a:	6145                	addi	sp,sp,48
    8000625c:	8082                	ret
    x = -xx;
    8000625e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006262:	4885                	li	a7,1
    x = -xx;
    80006264:	bf85                	j	800061d4 <printint+0x12>

0000000080006266 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006266:	1101                	addi	sp,sp,-32
    80006268:	ec06                	sd	ra,24(sp)
    8000626a:	e822                	sd	s0,16(sp)
    8000626c:	e426                	sd	s1,8(sp)
    8000626e:	1000                	addi	s0,sp,32
    80006270:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006272:	00024797          	auipc	a5,0x24
    80006276:	fc07a723          	sw	zero,-50(a5) # 8002a240 <pr+0x20>
  printf("panic: ");
    8000627a:	00002517          	auipc	a0,0x2
    8000627e:	45650513          	addi	a0,a0,1110 # 800086d0 <etext+0x6d0>
    80006282:	00000097          	auipc	ra,0x0
    80006286:	02e080e7          	jalr	46(ra) # 800062b0 <printf>
  printf(s);
    8000628a:	8526                	mv	a0,s1
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	024080e7          	jalr	36(ra) # 800062b0 <printf>
  printf("\n");
    80006294:	00002517          	auipc	a0,0x2
    80006298:	d8450513          	addi	a0,a0,-636 # 80008018 <etext+0x18>
    8000629c:	00000097          	auipc	ra,0x0
    800062a0:	014080e7          	jalr	20(ra) # 800062b0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800062a4:	4785                	li	a5,1
    800062a6:	00003717          	auipc	a4,0x3
    800062aa:	d6f72b23          	sw	a5,-650(a4) # 8000901c <panicked>
  for(;;)
    800062ae:	a001                	j	800062ae <panic+0x48>

00000000800062b0 <printf>:
{
    800062b0:	7131                	addi	sp,sp,-192
    800062b2:	fc86                	sd	ra,120(sp)
    800062b4:	f8a2                	sd	s0,112(sp)
    800062b6:	e8d2                	sd	s4,80(sp)
    800062b8:	f06a                	sd	s10,32(sp)
    800062ba:	0100                	addi	s0,sp,128
    800062bc:	8a2a                	mv	s4,a0
    800062be:	e40c                	sd	a1,8(s0)
    800062c0:	e810                	sd	a2,16(s0)
    800062c2:	ec14                	sd	a3,24(s0)
    800062c4:	f018                	sd	a4,32(s0)
    800062c6:	f41c                	sd	a5,40(s0)
    800062c8:	03043823          	sd	a6,48(s0)
    800062cc:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800062d0:	00024d17          	auipc	s10,0x24
    800062d4:	f70d2d03          	lw	s10,-144(s10) # 8002a240 <pr+0x20>
  if(locking)
    800062d8:	040d1463          	bnez	s10,80006320 <printf+0x70>
  if (fmt == 0)
    800062dc:	040a0b63          	beqz	s4,80006332 <printf+0x82>
  va_start(ap, fmt);
    800062e0:	00840793          	addi	a5,s0,8
    800062e4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800062e8:	000a4503          	lbu	a0,0(s4)
    800062ec:	18050b63          	beqz	a0,80006482 <printf+0x1d2>
    800062f0:	f4a6                	sd	s1,104(sp)
    800062f2:	f0ca                	sd	s2,96(sp)
    800062f4:	ecce                	sd	s3,88(sp)
    800062f6:	e4d6                	sd	s5,72(sp)
    800062f8:	e0da                	sd	s6,64(sp)
    800062fa:	fc5e                	sd	s7,56(sp)
    800062fc:	f862                	sd	s8,48(sp)
    800062fe:	f466                	sd	s9,40(sp)
    80006300:	ec6e                	sd	s11,24(sp)
    80006302:	4981                	li	s3,0
    if(c != '%'){
    80006304:	02500b13          	li	s6,37
    switch(c){
    80006308:	07000b93          	li	s7,112
  consputc('x');
    8000630c:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000630e:	00002a97          	auipc	s5,0x2
    80006312:	5aaa8a93          	addi	s5,s5,1450 # 800088b8 <digits>
    switch(c){
    80006316:	07300c13          	li	s8,115
    8000631a:	06400d93          	li	s11,100
    8000631e:	a0b1                	j	8000636a <printf+0xba>
    acquire(&pr.lock);
    80006320:	00024517          	auipc	a0,0x24
    80006324:	f0050513          	addi	a0,a0,-256 # 8002a220 <pr>
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	4a2080e7          	jalr	1186(ra) # 800067ca <acquire>
    80006330:	b775                	j	800062dc <printf+0x2c>
    80006332:	f4a6                	sd	s1,104(sp)
    80006334:	f0ca                	sd	s2,96(sp)
    80006336:	ecce                	sd	s3,88(sp)
    80006338:	e4d6                	sd	s5,72(sp)
    8000633a:	e0da                	sd	s6,64(sp)
    8000633c:	fc5e                	sd	s7,56(sp)
    8000633e:	f862                	sd	s8,48(sp)
    80006340:	f466                	sd	s9,40(sp)
    80006342:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80006344:	00002517          	auipc	a0,0x2
    80006348:	37450513          	addi	a0,a0,884 # 800086b8 <etext+0x6b8>
    8000634c:	00000097          	auipc	ra,0x0
    80006350:	f1a080e7          	jalr	-230(ra) # 80006266 <panic>
      consputc(c);
    80006354:	00000097          	auipc	ra,0x0
    80006358:	c46080e7          	jalr	-954(ra) # 80005f9a <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000635c:	2985                	addiw	s3,s3,1
    8000635e:	013a07b3          	add	a5,s4,s3
    80006362:	0007c503          	lbu	a0,0(a5)
    80006366:	10050563          	beqz	a0,80006470 <printf+0x1c0>
    if(c != '%'){
    8000636a:	ff6515e3          	bne	a0,s6,80006354 <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000636e:	2985                	addiw	s3,s3,1
    80006370:	013a07b3          	add	a5,s4,s3
    80006374:	0007c783          	lbu	a5,0(a5)
    80006378:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000637c:	10078b63          	beqz	a5,80006492 <printf+0x1e2>
    switch(c){
    80006380:	05778a63          	beq	a5,s7,800063d4 <printf+0x124>
    80006384:	02fbf663          	bgeu	s7,a5,800063b0 <printf+0x100>
    80006388:	09878863          	beq	a5,s8,80006418 <printf+0x168>
    8000638c:	07800713          	li	a4,120
    80006390:	0ce79563          	bne	a5,a4,8000645a <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80006394:	f8843783          	ld	a5,-120(s0)
    80006398:	00878713          	addi	a4,a5,8
    8000639c:	f8e43423          	sd	a4,-120(s0)
    800063a0:	4605                	li	a2,1
    800063a2:	85e6                	mv	a1,s9
    800063a4:	4388                	lw	a0,0(a5)
    800063a6:	00000097          	auipc	ra,0x0
    800063aa:	e1c080e7          	jalr	-484(ra) # 800061c2 <printint>
      break;
    800063ae:	b77d                	j	8000635c <printf+0xac>
    switch(c){
    800063b0:	09678f63          	beq	a5,s6,8000644e <printf+0x19e>
    800063b4:	0bb79363          	bne	a5,s11,8000645a <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800063b8:	f8843783          	ld	a5,-120(s0)
    800063bc:	00878713          	addi	a4,a5,8
    800063c0:	f8e43423          	sd	a4,-120(s0)
    800063c4:	4605                	li	a2,1
    800063c6:	45a9                	li	a1,10
    800063c8:	4388                	lw	a0,0(a5)
    800063ca:	00000097          	auipc	ra,0x0
    800063ce:	df8080e7          	jalr	-520(ra) # 800061c2 <printint>
      break;
    800063d2:	b769                	j	8000635c <printf+0xac>
      printptr(va_arg(ap, uint64));
    800063d4:	f8843783          	ld	a5,-120(s0)
    800063d8:	00878713          	addi	a4,a5,8
    800063dc:	f8e43423          	sd	a4,-120(s0)
    800063e0:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800063e4:	03000513          	li	a0,48
    800063e8:	00000097          	auipc	ra,0x0
    800063ec:	bb2080e7          	jalr	-1102(ra) # 80005f9a <consputc>
  consputc('x');
    800063f0:	07800513          	li	a0,120
    800063f4:	00000097          	auipc	ra,0x0
    800063f8:	ba6080e7          	jalr	-1114(ra) # 80005f9a <consputc>
    800063fc:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800063fe:	03c95793          	srli	a5,s2,0x3c
    80006402:	97d6                	add	a5,a5,s5
    80006404:	0007c503          	lbu	a0,0(a5)
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	b92080e7          	jalr	-1134(ra) # 80005f9a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006410:	0912                	slli	s2,s2,0x4
    80006412:	34fd                	addiw	s1,s1,-1
    80006414:	f4ed                	bnez	s1,800063fe <printf+0x14e>
    80006416:	b799                	j	8000635c <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80006418:	f8843783          	ld	a5,-120(s0)
    8000641c:	00878713          	addi	a4,a5,8
    80006420:	f8e43423          	sd	a4,-120(s0)
    80006424:	6384                	ld	s1,0(a5)
    80006426:	cc89                	beqz	s1,80006440 <printf+0x190>
      for(; *s; s++)
    80006428:	0004c503          	lbu	a0,0(s1)
    8000642c:	d905                	beqz	a0,8000635c <printf+0xac>
        consputc(*s);
    8000642e:	00000097          	auipc	ra,0x0
    80006432:	b6c080e7          	jalr	-1172(ra) # 80005f9a <consputc>
      for(; *s; s++)
    80006436:	0485                	addi	s1,s1,1
    80006438:	0004c503          	lbu	a0,0(s1)
    8000643c:	f96d                	bnez	a0,8000642e <printf+0x17e>
    8000643e:	bf39                	j	8000635c <printf+0xac>
        s = "(null)";
    80006440:	00002497          	auipc	s1,0x2
    80006444:	27048493          	addi	s1,s1,624 # 800086b0 <etext+0x6b0>
      for(; *s; s++)
    80006448:	02800513          	li	a0,40
    8000644c:	b7cd                	j	8000642e <printf+0x17e>
      consputc('%');
    8000644e:	855a                	mv	a0,s6
    80006450:	00000097          	auipc	ra,0x0
    80006454:	b4a080e7          	jalr	-1206(ra) # 80005f9a <consputc>
      break;
    80006458:	b711                	j	8000635c <printf+0xac>
      consputc('%');
    8000645a:	855a                	mv	a0,s6
    8000645c:	00000097          	auipc	ra,0x0
    80006460:	b3e080e7          	jalr	-1218(ra) # 80005f9a <consputc>
      consputc(c);
    80006464:	8526                	mv	a0,s1
    80006466:	00000097          	auipc	ra,0x0
    8000646a:	b34080e7          	jalr	-1228(ra) # 80005f9a <consputc>
      break;
    8000646e:	b5fd                	j	8000635c <printf+0xac>
    80006470:	74a6                	ld	s1,104(sp)
    80006472:	7906                	ld	s2,96(sp)
    80006474:	69e6                	ld	s3,88(sp)
    80006476:	6aa6                	ld	s5,72(sp)
    80006478:	6b06                	ld	s6,64(sp)
    8000647a:	7be2                	ld	s7,56(sp)
    8000647c:	7c42                	ld	s8,48(sp)
    8000647e:	7ca2                	ld	s9,40(sp)
    80006480:	6de2                	ld	s11,24(sp)
  if(locking)
    80006482:	020d1263          	bnez	s10,800064a6 <printf+0x1f6>
}
    80006486:	70e6                	ld	ra,120(sp)
    80006488:	7446                	ld	s0,112(sp)
    8000648a:	6a46                	ld	s4,80(sp)
    8000648c:	7d02                	ld	s10,32(sp)
    8000648e:	6129                	addi	sp,sp,192
    80006490:	8082                	ret
    80006492:	74a6                	ld	s1,104(sp)
    80006494:	7906                	ld	s2,96(sp)
    80006496:	69e6                	ld	s3,88(sp)
    80006498:	6aa6                	ld	s5,72(sp)
    8000649a:	6b06                	ld	s6,64(sp)
    8000649c:	7be2                	ld	s7,56(sp)
    8000649e:	7c42                	ld	s8,48(sp)
    800064a0:	7ca2                	ld	s9,40(sp)
    800064a2:	6de2                	ld	s11,24(sp)
    800064a4:	bff9                	j	80006482 <printf+0x1d2>
    release(&pr.lock);
    800064a6:	00024517          	auipc	a0,0x24
    800064aa:	d7a50513          	addi	a0,a0,-646 # 8002a220 <pr>
    800064ae:	00000097          	auipc	ra,0x0
    800064b2:	3ec080e7          	jalr	1004(ra) # 8000689a <release>
}
    800064b6:	bfc1                	j	80006486 <printf+0x1d6>

00000000800064b8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800064b8:	1101                	addi	sp,sp,-32
    800064ba:	ec06                	sd	ra,24(sp)
    800064bc:	e822                	sd	s0,16(sp)
    800064be:	e426                	sd	s1,8(sp)
    800064c0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800064c2:	00024497          	auipc	s1,0x24
    800064c6:	d5e48493          	addi	s1,s1,-674 # 8002a220 <pr>
    800064ca:	00002597          	auipc	a1,0x2
    800064ce:	20e58593          	addi	a1,a1,526 # 800086d8 <etext+0x6d8>
    800064d2:	8526                	mv	a0,s1
    800064d4:	00000097          	auipc	ra,0x0
    800064d8:	472080e7          	jalr	1138(ra) # 80006946 <initlock>
  pr.locking = 1;
    800064dc:	4785                	li	a5,1
    800064de:	d09c                	sw	a5,32(s1)
}
    800064e0:	60e2                	ld	ra,24(sp)
    800064e2:	6442                	ld	s0,16(sp)
    800064e4:	64a2                	ld	s1,8(sp)
    800064e6:	6105                	addi	sp,sp,32
    800064e8:	8082                	ret

00000000800064ea <uartinit>:

void uartstart();

void
uartinit(void)
{
    800064ea:	1141                	addi	sp,sp,-16
    800064ec:	e406                	sd	ra,8(sp)
    800064ee:	e022                	sd	s0,0(sp)
    800064f0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800064f2:	100007b7          	lui	a5,0x10000
    800064f6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800064fa:	10000737          	lui	a4,0x10000
    800064fe:	f8000693          	li	a3,-128
    80006502:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006506:	468d                	li	a3,3
    80006508:	10000637          	lui	a2,0x10000
    8000650c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006510:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006514:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006518:	10000737          	lui	a4,0x10000
    8000651c:	461d                	li	a2,7
    8000651e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006522:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006526:	00002597          	auipc	a1,0x2
    8000652a:	1ba58593          	addi	a1,a1,442 # 800086e0 <etext+0x6e0>
    8000652e:	00024517          	auipc	a0,0x24
    80006532:	d1a50513          	addi	a0,a0,-742 # 8002a248 <uart_tx_lock>
    80006536:	00000097          	auipc	ra,0x0
    8000653a:	410080e7          	jalr	1040(ra) # 80006946 <initlock>
}
    8000653e:	60a2                	ld	ra,8(sp)
    80006540:	6402                	ld	s0,0(sp)
    80006542:	0141                	addi	sp,sp,16
    80006544:	8082                	ret

0000000080006546 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006546:	1101                	addi	sp,sp,-32
    80006548:	ec06                	sd	ra,24(sp)
    8000654a:	e822                	sd	s0,16(sp)
    8000654c:	e426                	sd	s1,8(sp)
    8000654e:	1000                	addi	s0,sp,32
    80006550:	84aa                	mv	s1,a0
  push_off();
    80006552:	00000097          	auipc	ra,0x0
    80006556:	22c080e7          	jalr	556(ra) # 8000677e <push_off>

  if(panicked){
    8000655a:	00003797          	auipc	a5,0x3
    8000655e:	ac27a783          	lw	a5,-1342(a5) # 8000901c <panicked>
    80006562:	eb85                	bnez	a5,80006592 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006564:	10000737          	lui	a4,0x10000
    80006568:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000656a:	00074783          	lbu	a5,0(a4)
    8000656e:	0207f793          	andi	a5,a5,32
    80006572:	dfe5                	beqz	a5,8000656a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006574:	0ff4f513          	zext.b	a0,s1
    80006578:	100007b7          	lui	a5,0x10000
    8000657c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006580:	00000097          	auipc	ra,0x0
    80006584:	2ba080e7          	jalr	698(ra) # 8000683a <pop_off>
}
    80006588:	60e2                	ld	ra,24(sp)
    8000658a:	6442                	ld	s0,16(sp)
    8000658c:	64a2                	ld	s1,8(sp)
    8000658e:	6105                	addi	sp,sp,32
    80006590:	8082                	ret
    for(;;)
    80006592:	a001                	j	80006592 <uartputc_sync+0x4c>

0000000080006594 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006594:	00003797          	auipc	a5,0x3
    80006598:	a8c7b783          	ld	a5,-1396(a5) # 80009020 <uart_tx_r>
    8000659c:	00003717          	auipc	a4,0x3
    800065a0:	a8c73703          	ld	a4,-1396(a4) # 80009028 <uart_tx_w>
    800065a4:	06f70f63          	beq	a4,a5,80006622 <uartstart+0x8e>
{
    800065a8:	7139                	addi	sp,sp,-64
    800065aa:	fc06                	sd	ra,56(sp)
    800065ac:	f822                	sd	s0,48(sp)
    800065ae:	f426                	sd	s1,40(sp)
    800065b0:	f04a                	sd	s2,32(sp)
    800065b2:	ec4e                	sd	s3,24(sp)
    800065b4:	e852                	sd	s4,16(sp)
    800065b6:	e456                	sd	s5,8(sp)
    800065b8:	e05a                	sd	s6,0(sp)
    800065ba:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065bc:	10000937          	lui	s2,0x10000
    800065c0:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065c2:	00024a97          	auipc	s5,0x24
    800065c6:	c86a8a93          	addi	s5,s5,-890 # 8002a248 <uart_tx_lock>
    uart_tx_r += 1;
    800065ca:	00003497          	auipc	s1,0x3
    800065ce:	a5648493          	addi	s1,s1,-1450 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800065d2:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800065d6:	00003997          	auipc	s3,0x3
    800065da:	a5298993          	addi	s3,s3,-1454 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800065de:	00094703          	lbu	a4,0(s2)
    800065e2:	02077713          	andi	a4,a4,32
    800065e6:	c705                	beqz	a4,8000660e <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800065e8:	01f7f713          	andi	a4,a5,31
    800065ec:	9756                	add	a4,a4,s5
    800065ee:	02074b03          	lbu	s6,32(a4)
    uart_tx_r += 1;
    800065f2:	0785                	addi	a5,a5,1
    800065f4:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800065f6:	8526                	mv	a0,s1
    800065f8:	ffffb097          	auipc	ra,0xffffb
    800065fc:	1d0080e7          	jalr	464(ra) # 800017c8 <wakeup>
    WriteReg(THR, c);
    80006600:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006604:	609c                	ld	a5,0(s1)
    80006606:	0009b703          	ld	a4,0(s3)
    8000660a:	fcf71ae3          	bne	a4,a5,800065de <uartstart+0x4a>
  }
}
    8000660e:	70e2                	ld	ra,56(sp)
    80006610:	7442                	ld	s0,48(sp)
    80006612:	74a2                	ld	s1,40(sp)
    80006614:	7902                	ld	s2,32(sp)
    80006616:	69e2                	ld	s3,24(sp)
    80006618:	6a42                	ld	s4,16(sp)
    8000661a:	6aa2                	ld	s5,8(sp)
    8000661c:	6b02                	ld	s6,0(sp)
    8000661e:	6121                	addi	sp,sp,64
    80006620:	8082                	ret
    80006622:	8082                	ret

0000000080006624 <uartputc>:
{
    80006624:	7179                	addi	sp,sp,-48
    80006626:	f406                	sd	ra,40(sp)
    80006628:	f022                	sd	s0,32(sp)
    8000662a:	e052                	sd	s4,0(sp)
    8000662c:	1800                	addi	s0,sp,48
    8000662e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006630:	00024517          	auipc	a0,0x24
    80006634:	c1850513          	addi	a0,a0,-1000 # 8002a248 <uart_tx_lock>
    80006638:	00000097          	auipc	ra,0x0
    8000663c:	192080e7          	jalr	402(ra) # 800067ca <acquire>
  if(panicked){
    80006640:	00003797          	auipc	a5,0x3
    80006644:	9dc7a783          	lw	a5,-1572(a5) # 8000901c <panicked>
    80006648:	c391                	beqz	a5,8000664c <uartputc+0x28>
    for(;;)
    8000664a:	a001                	j	8000664a <uartputc+0x26>
    8000664c:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000664e:	00003717          	auipc	a4,0x3
    80006652:	9da73703          	ld	a4,-1574(a4) # 80009028 <uart_tx_w>
    80006656:	00003797          	auipc	a5,0x3
    8000665a:	9ca7b783          	ld	a5,-1590(a5) # 80009020 <uart_tx_r>
    8000665e:	02078793          	addi	a5,a5,32
    80006662:	02e79f63          	bne	a5,a4,800066a0 <uartputc+0x7c>
    80006666:	e84a                	sd	s2,16(sp)
    80006668:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    8000666a:	00024997          	auipc	s3,0x24
    8000666e:	bde98993          	addi	s3,s3,-1058 # 8002a248 <uart_tx_lock>
    80006672:	00003497          	auipc	s1,0x3
    80006676:	9ae48493          	addi	s1,s1,-1618 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000667a:	00003917          	auipc	s2,0x3
    8000667e:	9ae90913          	addi	s2,s2,-1618 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006682:	85ce                	mv	a1,s3
    80006684:	8526                	mv	a0,s1
    80006686:	ffffb097          	auipc	ra,0xffffb
    8000668a:	fb6080e7          	jalr	-74(ra) # 8000163c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000668e:	00093703          	ld	a4,0(s2)
    80006692:	609c                	ld	a5,0(s1)
    80006694:	02078793          	addi	a5,a5,32
    80006698:	fee785e3          	beq	a5,a4,80006682 <uartputc+0x5e>
    8000669c:	6942                	ld	s2,16(sp)
    8000669e:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800066a0:	00024497          	auipc	s1,0x24
    800066a4:	ba848493          	addi	s1,s1,-1112 # 8002a248 <uart_tx_lock>
    800066a8:	01f77793          	andi	a5,a4,31
    800066ac:	97a6                	add	a5,a5,s1
    800066ae:	03478023          	sb	s4,32(a5)
      uart_tx_w += 1;
    800066b2:	0705                	addi	a4,a4,1
    800066b4:	00003797          	auipc	a5,0x3
    800066b8:	96e7ba23          	sd	a4,-1676(a5) # 80009028 <uart_tx_w>
      uartstart();
    800066bc:	00000097          	auipc	ra,0x0
    800066c0:	ed8080e7          	jalr	-296(ra) # 80006594 <uartstart>
      release(&uart_tx_lock);
    800066c4:	8526                	mv	a0,s1
    800066c6:	00000097          	auipc	ra,0x0
    800066ca:	1d4080e7          	jalr	468(ra) # 8000689a <release>
    800066ce:	64e2                	ld	s1,24(sp)
}
    800066d0:	70a2                	ld	ra,40(sp)
    800066d2:	7402                	ld	s0,32(sp)
    800066d4:	6a02                	ld	s4,0(sp)
    800066d6:	6145                	addi	sp,sp,48
    800066d8:	8082                	ret

00000000800066da <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800066da:	1141                	addi	sp,sp,-16
    800066dc:	e422                	sd	s0,8(sp)
    800066de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800066e0:	100007b7          	lui	a5,0x10000
    800066e4:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800066e6:	0007c783          	lbu	a5,0(a5)
    800066ea:	8b85                	andi	a5,a5,1
    800066ec:	cb81                	beqz	a5,800066fc <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800066ee:	100007b7          	lui	a5,0x10000
    800066f2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800066f6:	6422                	ld	s0,8(sp)
    800066f8:	0141                	addi	sp,sp,16
    800066fa:	8082                	ret
    return -1;
    800066fc:	557d                	li	a0,-1
    800066fe:	bfe5                	j	800066f6 <uartgetc+0x1c>

0000000080006700 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006700:	1101                	addi	sp,sp,-32
    80006702:	ec06                	sd	ra,24(sp)
    80006704:	e822                	sd	s0,16(sp)
    80006706:	e426                	sd	s1,8(sp)
    80006708:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000670a:	54fd                	li	s1,-1
    8000670c:	a029                	j	80006716 <uartintr+0x16>
      break;
    consoleintr(c);
    8000670e:	00000097          	auipc	ra,0x0
    80006712:	8ce080e7          	jalr	-1842(ra) # 80005fdc <consoleintr>
    int c = uartgetc();
    80006716:	00000097          	auipc	ra,0x0
    8000671a:	fc4080e7          	jalr	-60(ra) # 800066da <uartgetc>
    if(c == -1)
    8000671e:	fe9518e3          	bne	a0,s1,8000670e <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006722:	00024497          	auipc	s1,0x24
    80006726:	b2648493          	addi	s1,s1,-1242 # 8002a248 <uart_tx_lock>
    8000672a:	8526                	mv	a0,s1
    8000672c:	00000097          	auipc	ra,0x0
    80006730:	09e080e7          	jalr	158(ra) # 800067ca <acquire>
  uartstart();
    80006734:	00000097          	auipc	ra,0x0
    80006738:	e60080e7          	jalr	-416(ra) # 80006594 <uartstart>
  release(&uart_tx_lock);
    8000673c:	8526                	mv	a0,s1
    8000673e:	00000097          	auipc	ra,0x0
    80006742:	15c080e7          	jalr	348(ra) # 8000689a <release>
}
    80006746:	60e2                	ld	ra,24(sp)
    80006748:	6442                	ld	s0,16(sp)
    8000674a:	64a2                	ld	s1,8(sp)
    8000674c:	6105                	addi	sp,sp,32
    8000674e:	8082                	ret

0000000080006750 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006750:	411c                	lw	a5,0(a0)
    80006752:	e399                	bnez	a5,80006758 <holding+0x8>
    80006754:	4501                	li	a0,0
  return r;
}
    80006756:	8082                	ret
{
    80006758:	1101                	addi	sp,sp,-32
    8000675a:	ec06                	sd	ra,24(sp)
    8000675c:	e822                	sd	s0,16(sp)
    8000675e:	e426                	sd	s1,8(sp)
    80006760:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006762:	6904                	ld	s1,16(a0)
    80006764:	ffffa097          	auipc	ra,0xffffa
    80006768:	7f6080e7          	jalr	2038(ra) # 80000f5a <mycpu>
    8000676c:	40a48533          	sub	a0,s1,a0
    80006770:	00153513          	seqz	a0,a0
}
    80006774:	60e2                	ld	ra,24(sp)
    80006776:	6442                	ld	s0,16(sp)
    80006778:	64a2                	ld	s1,8(sp)
    8000677a:	6105                	addi	sp,sp,32
    8000677c:	8082                	ret

000000008000677e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000677e:	1101                	addi	sp,sp,-32
    80006780:	ec06                	sd	ra,24(sp)
    80006782:	e822                	sd	s0,16(sp)
    80006784:	e426                	sd	s1,8(sp)
    80006786:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006788:	100024f3          	csrr	s1,sstatus
    8000678c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006790:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006792:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006796:	ffffa097          	auipc	ra,0xffffa
    8000679a:	7c4080e7          	jalr	1988(ra) # 80000f5a <mycpu>
    8000679e:	5d3c                	lw	a5,120(a0)
    800067a0:	cf89                	beqz	a5,800067ba <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800067a2:	ffffa097          	auipc	ra,0xffffa
    800067a6:	7b8080e7          	jalr	1976(ra) # 80000f5a <mycpu>
    800067aa:	5d3c                	lw	a5,120(a0)
    800067ac:	2785                	addiw	a5,a5,1
    800067ae:	dd3c                	sw	a5,120(a0)
}
    800067b0:	60e2                	ld	ra,24(sp)
    800067b2:	6442                	ld	s0,16(sp)
    800067b4:	64a2                	ld	s1,8(sp)
    800067b6:	6105                	addi	sp,sp,32
    800067b8:	8082                	ret
    mycpu()->intena = old;
    800067ba:	ffffa097          	auipc	ra,0xffffa
    800067be:	7a0080e7          	jalr	1952(ra) # 80000f5a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800067c2:	8085                	srli	s1,s1,0x1
    800067c4:	8885                	andi	s1,s1,1
    800067c6:	dd64                	sw	s1,124(a0)
    800067c8:	bfe9                	j	800067a2 <push_off+0x24>

00000000800067ca <acquire>:
{
    800067ca:	1101                	addi	sp,sp,-32
    800067cc:	ec06                	sd	ra,24(sp)
    800067ce:	e822                	sd	s0,16(sp)
    800067d0:	e426                	sd	s1,8(sp)
    800067d2:	1000                	addi	s0,sp,32
    800067d4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800067d6:	00000097          	auipc	ra,0x0
    800067da:	fa8080e7          	jalr	-88(ra) # 8000677e <push_off>
  if(holding(lk))
    800067de:	8526                	mv	a0,s1
    800067e0:	00000097          	auipc	ra,0x0
    800067e4:	f70080e7          	jalr	-144(ra) # 80006750 <holding>
    800067e8:	e911                	bnez	a0,800067fc <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    800067ea:	4785                	li	a5,1
    800067ec:	01c48713          	addi	a4,s1,28
    800067f0:	0f50000f          	fence	iorw,ow
    800067f4:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800067f8:	4705                	li	a4,1
    800067fa:	a839                	j	80006818 <acquire+0x4e>
    panic("acquire");
    800067fc:	00002517          	auipc	a0,0x2
    80006800:	eec50513          	addi	a0,a0,-276 # 800086e8 <etext+0x6e8>
    80006804:	00000097          	auipc	ra,0x0
    80006808:	a62080e7          	jalr	-1438(ra) # 80006266 <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    8000680c:	01848793          	addi	a5,s1,24
    80006810:	0f50000f          	fence	iorw,ow
    80006814:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006818:	87ba                	mv	a5,a4
    8000681a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000681e:	2781                	sext.w	a5,a5
    80006820:	f7f5                	bnez	a5,8000680c <acquire+0x42>
  __sync_synchronize();
    80006822:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006826:	ffffa097          	auipc	ra,0xffffa
    8000682a:	734080e7          	jalr	1844(ra) # 80000f5a <mycpu>
    8000682e:	e888                	sd	a0,16(s1)
}
    80006830:	60e2                	ld	ra,24(sp)
    80006832:	6442                	ld	s0,16(sp)
    80006834:	64a2                	ld	s1,8(sp)
    80006836:	6105                	addi	sp,sp,32
    80006838:	8082                	ret

000000008000683a <pop_off>:

void
pop_off(void)
{
    8000683a:	1141                	addi	sp,sp,-16
    8000683c:	e406                	sd	ra,8(sp)
    8000683e:	e022                	sd	s0,0(sp)
    80006840:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006842:	ffffa097          	auipc	ra,0xffffa
    80006846:	718080e7          	jalr	1816(ra) # 80000f5a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000684a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000684e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006850:	e78d                	bnez	a5,8000687a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006852:	5d3c                	lw	a5,120(a0)
    80006854:	02f05b63          	blez	a5,8000688a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006858:	37fd                	addiw	a5,a5,-1
    8000685a:	0007871b          	sext.w	a4,a5
    8000685e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006860:	eb09                	bnez	a4,80006872 <pop_off+0x38>
    80006862:	5d7c                	lw	a5,124(a0)
    80006864:	c799                	beqz	a5,80006872 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006866:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000686a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000686e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006872:	60a2                	ld	ra,8(sp)
    80006874:	6402                	ld	s0,0(sp)
    80006876:	0141                	addi	sp,sp,16
    80006878:	8082                	ret
    panic("pop_off - interruptible");
    8000687a:	00002517          	auipc	a0,0x2
    8000687e:	e7650513          	addi	a0,a0,-394 # 800086f0 <etext+0x6f0>
    80006882:	00000097          	auipc	ra,0x0
    80006886:	9e4080e7          	jalr	-1564(ra) # 80006266 <panic>
    panic("pop_off");
    8000688a:	00002517          	auipc	a0,0x2
    8000688e:	e7e50513          	addi	a0,a0,-386 # 80008708 <etext+0x708>
    80006892:	00000097          	auipc	ra,0x0
    80006896:	9d4080e7          	jalr	-1580(ra) # 80006266 <panic>

000000008000689a <release>:
{
    8000689a:	1101                	addi	sp,sp,-32
    8000689c:	ec06                	sd	ra,24(sp)
    8000689e:	e822                	sd	s0,16(sp)
    800068a0:	e426                	sd	s1,8(sp)
    800068a2:	1000                	addi	s0,sp,32
    800068a4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800068a6:	00000097          	auipc	ra,0x0
    800068aa:	eaa080e7          	jalr	-342(ra) # 80006750 <holding>
    800068ae:	c115                	beqz	a0,800068d2 <release+0x38>
  lk->cpu = 0;
    800068b0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800068b4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800068b8:	0f50000f          	fence	iorw,ow
    800068bc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800068c0:	00000097          	auipc	ra,0x0
    800068c4:	f7a080e7          	jalr	-134(ra) # 8000683a <pop_off>
}
    800068c8:	60e2                	ld	ra,24(sp)
    800068ca:	6442                	ld	s0,16(sp)
    800068cc:	64a2                	ld	s1,8(sp)
    800068ce:	6105                	addi	sp,sp,32
    800068d0:	8082                	ret
    panic("release");
    800068d2:	00002517          	auipc	a0,0x2
    800068d6:	e3e50513          	addi	a0,a0,-450 # 80008710 <etext+0x710>
    800068da:	00000097          	auipc	ra,0x0
    800068de:	98c080e7          	jalr	-1652(ra) # 80006266 <panic>

00000000800068e2 <freelock>:
{
    800068e2:	1101                	addi	sp,sp,-32
    800068e4:	ec06                	sd	ra,24(sp)
    800068e6:	e822                	sd	s0,16(sp)
    800068e8:	e426                	sd	s1,8(sp)
    800068ea:	1000                	addi	s0,sp,32
    800068ec:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    800068ee:	00024517          	auipc	a0,0x24
    800068f2:	99a50513          	addi	a0,a0,-1638 # 8002a288 <lock_locks>
    800068f6:	00000097          	auipc	ra,0x0
    800068fa:	ed4080e7          	jalr	-300(ra) # 800067ca <acquire>
  for (i = 0; i < NLOCK; i++) {
    800068fe:	00024717          	auipc	a4,0x24
    80006902:	9aa70713          	addi	a4,a4,-1622 # 8002a2a8 <locks>
    80006906:	4781                	li	a5,0
    80006908:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    8000690c:	6314                	ld	a3,0(a4)
    8000690e:	00968763          	beq	a3,s1,8000691c <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    80006912:	2785                	addiw	a5,a5,1
    80006914:	0721                	addi	a4,a4,8
    80006916:	fec79be3          	bne	a5,a2,8000690c <freelock+0x2a>
    8000691a:	a809                	j	8000692c <freelock+0x4a>
      locks[i] = 0;
    8000691c:	078e                	slli	a5,a5,0x3
    8000691e:	00024717          	auipc	a4,0x24
    80006922:	98a70713          	addi	a4,a4,-1654 # 8002a2a8 <locks>
    80006926:	97ba                	add	a5,a5,a4
    80006928:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    8000692c:	00024517          	auipc	a0,0x24
    80006930:	95c50513          	addi	a0,a0,-1700 # 8002a288 <lock_locks>
    80006934:	00000097          	auipc	ra,0x0
    80006938:	f66080e7          	jalr	-154(ra) # 8000689a <release>
}
    8000693c:	60e2                	ld	ra,24(sp)
    8000693e:	6442                	ld	s0,16(sp)
    80006940:	64a2                	ld	s1,8(sp)
    80006942:	6105                	addi	sp,sp,32
    80006944:	8082                	ret

0000000080006946 <initlock>:
{
    80006946:	1101                	addi	sp,sp,-32
    80006948:	ec06                	sd	ra,24(sp)
    8000694a:	e822                	sd	s0,16(sp)
    8000694c:	e426                	sd	s1,8(sp)
    8000694e:	1000                	addi	s0,sp,32
    80006950:	84aa                	mv	s1,a0
  lk->name = name;
    80006952:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006954:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006958:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    8000695c:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    80006960:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    80006964:	00024517          	auipc	a0,0x24
    80006968:	92450513          	addi	a0,a0,-1756 # 8002a288 <lock_locks>
    8000696c:	00000097          	auipc	ra,0x0
    80006970:	e5e080e7          	jalr	-418(ra) # 800067ca <acquire>
  for (i = 0; i < NLOCK; i++) {
    80006974:	00024717          	auipc	a4,0x24
    80006978:	93470713          	addi	a4,a4,-1740 # 8002a2a8 <locks>
    8000697c:	4781                	li	a5,0
    8000697e:	1f400613          	li	a2,500
    if(locks[i] == 0) {
    80006982:	6314                	ld	a3,0(a4)
    80006984:	ce89                	beqz	a3,8000699e <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    80006986:	2785                	addiw	a5,a5,1
    80006988:	0721                	addi	a4,a4,8
    8000698a:	fec79ce3          	bne	a5,a2,80006982 <initlock+0x3c>
  panic("findslot");
    8000698e:	00002517          	auipc	a0,0x2
    80006992:	d8a50513          	addi	a0,a0,-630 # 80008718 <etext+0x718>
    80006996:	00000097          	auipc	ra,0x0
    8000699a:	8d0080e7          	jalr	-1840(ra) # 80006266 <panic>
      locks[i] = lk;
    8000699e:	078e                	slli	a5,a5,0x3
    800069a0:	00024717          	auipc	a4,0x24
    800069a4:	90870713          	addi	a4,a4,-1784 # 8002a2a8 <locks>
    800069a8:	97ba                	add	a5,a5,a4
    800069aa:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    800069ac:	00024517          	auipc	a0,0x24
    800069b0:	8dc50513          	addi	a0,a0,-1828 # 8002a288 <lock_locks>
    800069b4:	00000097          	auipc	ra,0x0
    800069b8:	ee6080e7          	jalr	-282(ra) # 8000689a <release>
}
    800069bc:	60e2                	ld	ra,24(sp)
    800069be:	6442                	ld	s0,16(sp)
    800069c0:	64a2                	ld	s1,8(sp)
    800069c2:	6105                	addi	sp,sp,32
    800069c4:	8082                	ret

00000000800069c6 <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    800069c6:	1141                	addi	sp,sp,-16
    800069c8:	e422                	sd	s0,8(sp)
    800069ca:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800069cc:	0ff0000f          	fence
    800069d0:	6108                	ld	a0,0(a0)
    800069d2:	0ff0000f          	fence
  return val;
}
    800069d6:	6422                	ld	s0,8(sp)
    800069d8:	0141                	addi	sp,sp,16
    800069da:	8082                	ret

00000000800069dc <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    800069dc:	1141                	addi	sp,sp,-16
    800069de:	e422                	sd	s0,8(sp)
    800069e0:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800069e2:	0ff0000f          	fence
    800069e6:	4108                	lw	a0,0(a0)
    800069e8:	0ff0000f          	fence
  return val;
}
    800069ec:	6422                	ld	s0,8(sp)
    800069ee:	0141                	addi	sp,sp,16
    800069f0:	8082                	ret

00000000800069f2 <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    800069f2:	4e5c                	lw	a5,28(a2)
    800069f4:	00f04463          	bgtz	a5,800069fc <snprint_lock+0xa>
  int n = 0;
    800069f8:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    800069fa:	8082                	ret
{
    800069fc:	1141                	addi	sp,sp,-16
    800069fe:	e406                	sd	ra,8(sp)
    80006a00:	e022                	sd	s0,0(sp)
    80006a02:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    80006a04:	4e18                	lw	a4,24(a2)
    80006a06:	6614                	ld	a3,8(a2)
    80006a08:	00002617          	auipc	a2,0x2
    80006a0c:	d2060613          	addi	a2,a2,-736 # 80008728 <etext+0x728>
    80006a10:	fffff097          	auipc	ra,0xfffff
    80006a14:	160080e7          	jalr	352(ra) # 80005b70 <snprintf>
}
    80006a18:	60a2                	ld	ra,8(sp)
    80006a1a:	6402                	ld	s0,0(sp)
    80006a1c:	0141                	addi	sp,sp,16
    80006a1e:	8082                	ret

0000000080006a20 <statslock>:

int
statslock(char *buf, int sz) {
    80006a20:	7159                	addi	sp,sp,-112
    80006a22:	f486                	sd	ra,104(sp)
    80006a24:	f0a2                	sd	s0,96(sp)
    80006a26:	eca6                	sd	s1,88(sp)
    80006a28:	e8ca                	sd	s2,80(sp)
    80006a2a:	e4ce                	sd	s3,72(sp)
    80006a2c:	e0d2                	sd	s4,64(sp)
    80006a2e:	fc56                	sd	s5,56(sp)
    80006a30:	f85a                	sd	s6,48(sp)
    80006a32:	f45e                	sd	s7,40(sp)
    80006a34:	f062                	sd	s8,32(sp)
    80006a36:	ec66                	sd	s9,24(sp)
    80006a38:	e86a                	sd	s10,16(sp)
    80006a3a:	e46e                	sd	s11,8(sp)
    80006a3c:	1880                	addi	s0,sp,112
    80006a3e:	8aaa                	mv	s5,a0
    80006a40:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    80006a42:	00024517          	auipc	a0,0x24
    80006a46:	84650513          	addi	a0,a0,-1978 # 8002a288 <lock_locks>
    80006a4a:	00000097          	auipc	ra,0x0
    80006a4e:	d80080e7          	jalr	-640(ra) # 800067ca <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006a52:	00002617          	auipc	a2,0x2
    80006a56:	d0660613          	addi	a2,a2,-762 # 80008758 <etext+0x758>
    80006a5a:	85da                	mv	a1,s6
    80006a5c:	8556                	mv	a0,s5
    80006a5e:	fffff097          	auipc	ra,0xfffff
    80006a62:	112080e7          	jalr	274(ra) # 80005b70 <snprintf>
    80006a66:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    80006a68:	00024c97          	auipc	s9,0x24
    80006a6c:	840c8c93          	addi	s9,s9,-1984 # 8002a2a8 <locks>
    80006a70:	00024c17          	auipc	s8,0x24
    80006a74:	7d8c0c13          	addi	s8,s8,2008 # 8002b248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006a78:	84e6                	mv	s1,s9
  int tot = 0;
    80006a7a:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a7c:	00002b97          	auipc	s7,0x2
    80006a80:	904b8b93          	addi	s7,s7,-1788 # 80008380 <etext+0x380>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a84:	00001d17          	auipc	s10,0x1
    80006a88:	58cd0d13          	addi	s10,s10,1420 # 80008010 <etext+0x10>
    80006a8c:	a01d                	j	80006ab2 <statslock+0x92>
      tot += locks[i]->nts;
    80006a8e:	0009b603          	ld	a2,0(s3)
    80006a92:	4e1c                	lw	a5,24(a2)
    80006a94:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    80006a98:	412b05bb          	subw	a1,s6,s2
    80006a9c:	012a8533          	add	a0,s5,s2
    80006aa0:	00000097          	auipc	ra,0x0
    80006aa4:	f52080e7          	jalr	-174(ra) # 800069f2 <snprint_lock>
    80006aa8:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006aac:	04a1                	addi	s1,s1,8
    80006aae:	05848763          	beq	s1,s8,80006afc <statslock+0xdc>
    if(locks[i] == 0)
    80006ab2:	89a6                	mv	s3,s1
    80006ab4:	609c                	ld	a5,0(s1)
    80006ab6:	c3b9                	beqz	a5,80006afc <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006ab8:	0087bd83          	ld	s11,8(a5)
    80006abc:	855e                	mv	a0,s7
    80006abe:	ffffa097          	auipc	ra,0xffffa
    80006ac2:	91a080e7          	jalr	-1766(ra) # 800003d8 <strlen>
    80006ac6:	0005061b          	sext.w	a2,a0
    80006aca:	85de                	mv	a1,s7
    80006acc:	856e                	mv	a0,s11
    80006ace:	ffffa097          	auipc	ra,0xffffa
    80006ad2:	866080e7          	jalr	-1946(ra) # 80000334 <strncmp>
    80006ad6:	dd45                	beqz	a0,80006a8e <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006ad8:	609c                	ld	a5,0(s1)
    80006ada:	0087bd83          	ld	s11,8(a5)
    80006ade:	856a                	mv	a0,s10
    80006ae0:	ffffa097          	auipc	ra,0xffffa
    80006ae4:	8f8080e7          	jalr	-1800(ra) # 800003d8 <strlen>
    80006ae8:	0005061b          	sext.w	a2,a0
    80006aec:	85ea                	mv	a1,s10
    80006aee:	856e                	mv	a0,s11
    80006af0:	ffffa097          	auipc	ra,0xffffa
    80006af4:	844080e7          	jalr	-1980(ra) # 80000334 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006af8:	f955                	bnez	a0,80006aac <statslock+0x8c>
    80006afa:	bf51                	j	80006a8e <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    80006afc:	00002617          	auipc	a2,0x2
    80006b00:	c7c60613          	addi	a2,a2,-900 # 80008778 <etext+0x778>
    80006b04:	412b05bb          	subw	a1,s6,s2
    80006b08:	012a8533          	add	a0,s5,s2
    80006b0c:	fffff097          	auipc	ra,0xfffff
    80006b10:	064080e7          	jalr	100(ra) # 80005b70 <snprintf>
    80006b14:	012509bb          	addw	s3,a0,s2
    80006b18:	4b95                	li	s7,5
  int last = 100000000;
    80006b1a:	05f5e537          	lui	a0,0x5f5e
    80006b1e:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80006b22:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006b24:	00023497          	auipc	s1,0x23
    80006b28:	78448493          	addi	s1,s1,1924 # 8002a2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006b2c:	1f400913          	li	s2,500
    80006b30:	a891                	j	80006b84 <statslock+0x164>
    80006b32:	2705                	addiw	a4,a4,1
    80006b34:	06a1                	addi	a3,a3,8
    80006b36:	03270063          	beq	a4,s2,80006b56 <statslock+0x136>
      if(locks[i] == 0)
    80006b3a:	629c                	ld	a5,0(a3)
    80006b3c:	cf89                	beqz	a5,80006b56 <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006b3e:	4f90                	lw	a2,24(a5)
    80006b40:	00359793          	slli	a5,a1,0x3
    80006b44:	97a6                	add	a5,a5,s1
    80006b46:	639c                	ld	a5,0(a5)
    80006b48:	4f9c                	lw	a5,24(a5)
    80006b4a:	fec7d4e3          	bge	a5,a2,80006b32 <statslock+0x112>
    80006b4e:	fea652e3          	bge	a2,a0,80006b32 <statslock+0x112>
        top = i;
    80006b52:	85ba                	mv	a1,a4
    80006b54:	bff9                	j	80006b32 <statslock+0x112>
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    80006b56:	058e                	slli	a1,a1,0x3
    80006b58:	00b48d33          	add	s10,s1,a1
    80006b5c:	000d3603          	ld	a2,0(s10)
    80006b60:	413b05bb          	subw	a1,s6,s3
    80006b64:	013a8533          	add	a0,s5,s3
    80006b68:	00000097          	auipc	ra,0x0
    80006b6c:	e8a080e7          	jalr	-374(ra) # 800069f2 <snprint_lock>
    80006b70:	01350dbb          	addw	s11,a0,s3
    80006b74:	000d899b          	sext.w	s3,s11
    last = locks[top]->nts;
    80006b78:	000d3783          	ld	a5,0(s10)
    80006b7c:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006b7e:	3bfd                	addiw	s7,s7,-1
    80006b80:	000b8663          	beqz	s7,80006b8c <statslock+0x16c>
  int tot = 0;
    80006b84:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006b86:	8762                	mv	a4,s8
    int top = 0;
    80006b88:	85e2                	mv	a1,s8
    80006b8a:	bf45                	j	80006b3a <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006b8c:	86d2                	mv	a3,s4
    80006b8e:	00002617          	auipc	a2,0x2
    80006b92:	c0a60613          	addi	a2,a2,-1014 # 80008798 <etext+0x798>
    80006b96:	41bb05bb          	subw	a1,s6,s11
    80006b9a:	013a8533          	add	a0,s5,s3
    80006b9e:	fffff097          	auipc	ra,0xfffff
    80006ba2:	fd2080e7          	jalr	-46(ra) # 80005b70 <snprintf>
    80006ba6:	00ad8dbb          	addw	s11,s11,a0
  release(&lock_locks);  
    80006baa:	00023517          	auipc	a0,0x23
    80006bae:	6de50513          	addi	a0,a0,1758 # 8002a288 <lock_locks>
    80006bb2:	00000097          	auipc	ra,0x0
    80006bb6:	ce8080e7          	jalr	-792(ra) # 8000689a <release>
  return n;
}
    80006bba:	856e                	mv	a0,s11
    80006bbc:	70a6                	ld	ra,104(sp)
    80006bbe:	7406                	ld	s0,96(sp)
    80006bc0:	64e6                	ld	s1,88(sp)
    80006bc2:	6946                	ld	s2,80(sp)
    80006bc4:	69a6                	ld	s3,72(sp)
    80006bc6:	6a06                	ld	s4,64(sp)
    80006bc8:	7ae2                	ld	s5,56(sp)
    80006bca:	7b42                	ld	s6,48(sp)
    80006bcc:	7ba2                	ld	s7,40(sp)
    80006bce:	7c02                	ld	s8,32(sp)
    80006bd0:	6ce2                	ld	s9,24(sp)
    80006bd2:	6d42                	ld	s10,16(sp)
    80006bd4:	6da2                	ld	s11,8(sp)
    80006bd6:	6165                	addi	sp,sp,112
    80006bd8:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
