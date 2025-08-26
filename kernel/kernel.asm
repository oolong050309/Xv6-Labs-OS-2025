
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00019117          	auipc	sp,0x19
    80000004:	14010113          	addi	sp,sp,320 # 80019140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	229050ef          	jal	80005a3e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	21078793          	addi	a5,a5,528 # 80021240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	42c080e7          	jalr	1068(ra) # 80006486 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	4cc080e7          	jalr	1228(ra) # 8000653a <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	addi	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	e82080e7          	jalr	-382(ra) # 80005f0c <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	300080e7          	jalr	768(ra) # 800063f6 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00021517          	auipc	a0,0x21
    80000106:	13e50513          	addi	a0,a0,318 # 80021240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	358080e7          	jalr	856(ra) # 80006486 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	3f4080e7          	jalr	1012(ra) # 8000653a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	3ca080e7          	jalr	970(ra) # 8000653a <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdddc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	addi	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addiw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	addi	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addiw	a3,a2,-1
    800002ca:	1682                	slli	a3,a3,0x20
    800002cc:	9281                	srli	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	addi	a1,a1,1
    800002d8:	0785                	addi	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	addi	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	addi	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	b30080e7          	jalr	-1232(ra) # 80000e50 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	00009717          	auipc	a4,0x9
    8000032c:	cd870713          	addi	a4,a4,-808 # 80009000 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	b14080e7          	jalr	-1260(ra) # 80000e50 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	c08080e7          	jalr	-1016(ra) # 80005f56 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	770080e7          	jalr	1904(ra) # 80001ace <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	08e080e7          	jalr	142(ra) # 800053f4 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	022080e7          	jalr	34(ra) # 80001390 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	aa6080e7          	jalr	-1370(ra) # 80005e1c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	de0080e7          	jalr	-544(ra) # 8000615e <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	bc8080e7          	jalr	-1080(ra) # 80005f56 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	bb8080e7          	jalr	-1096(ra) # 80005f56 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	ba8080e7          	jalr	-1112(ra) # 80005f56 <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	322080e7          	jalr	802(ra) # 800006e0 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	9c4080e7          	jalr	-1596(ra) # 80000d92 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	6d0080e7          	jalr	1744(ra) # 80001aa6 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	6f0080e7          	jalr	1776(ra) # 80001ace <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	ff4080e7          	jalr	-12(ra) # 800053da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	006080e7          	jalr	6(ra) # 800053f4 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	e2a080e7          	jalr	-470(ra) # 80002220 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	582080e7          	jalr	1410(ra) # 80002980 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	5d6080e7          	jalr	1494(ra) # 800039dc <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	106080e7          	jalr	262(ra) # 80005514 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d3e080e7          	jalr	-706(ra) # 80001154 <userinit>
    __sync_synchronize();
    8000041e:	0ff0000f          	fence
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	00009717          	auipc	a4,0x9
    80000428:	bcf72e23          	sw	a5,-1060(a4) # 80009000 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000042e:	1141                	addi	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000434:	00009797          	auipc	a5,0x9
    80000438:	bd47b783          	ld	a5,-1068(a5) # 80009008 <kernel_pagetable>
    8000043c:	83b1                	srli	a5,a5,0xc
    8000043e:	577d                	li	a4,-1
    80000440:	177e                	slli	a4,a4,0x3f
    80000442:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000444:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000448:	12000073          	sfence.vma
  sfence_vma();
}
    8000044c:	6422                	ld	s0,8(sp)
    8000044e:	0141                	addi	sp,sp,16
    80000450:	8082                	ret

0000000080000452 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000452:	7139                	addi	sp,sp,-64
    80000454:	fc06                	sd	ra,56(sp)
    80000456:	f822                	sd	s0,48(sp)
    80000458:	f426                	sd	s1,40(sp)
    8000045a:	f04a                	sd	s2,32(sp)
    8000045c:	ec4e                	sd	s3,24(sp)
    8000045e:	e852                	sd	s4,16(sp)
    80000460:	e456                	sd	s5,8(sp)
    80000462:	e05a                	sd	s6,0(sp)
    80000464:	0080                	addi	s0,sp,64
    80000466:	84aa                	mv	s1,a0
    80000468:	89ae                	mv	s3,a1
    8000046a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000046c:	57fd                	li	a5,-1
    8000046e:	83e9                	srli	a5,a5,0x1a
    80000470:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000472:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000474:	04b7f263          	bgeu	a5,a1,800004b8 <walk+0x66>
    panic("walk");
    80000478:	00008517          	auipc	a0,0x8
    8000047c:	bd850513          	addi	a0,a0,-1064 # 80008050 <etext+0x50>
    80000480:	00006097          	auipc	ra,0x6
    80000484:	a8c080e7          	jalr	-1396(ra) # 80005f0c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000488:	060a8663          	beqz	s5,800004f4 <walk+0xa2>
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	c8e080e7          	jalr	-882(ra) # 8000011a <kalloc>
    80000494:	84aa                	mv	s1,a0
    80000496:	c529                	beqz	a0,800004e0 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000498:	6605                	lui	a2,0x1
    8000049a:	4581                	li	a1,0
    8000049c:	00000097          	auipc	ra,0x0
    800004a0:	cde080e7          	jalr	-802(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a4:	00c4d793          	srli	a5,s1,0xc
    800004a8:	07aa                	slli	a5,a5,0xa
    800004aa:	0017e793          	ori	a5,a5,1
    800004ae:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdddb7>
    800004b4:	036a0063          	beq	s4,s6,800004d4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004b8:	0149d933          	srl	s2,s3,s4
    800004bc:	1ff97913          	andi	s2,s2,511
    800004c0:	090e                	slli	s2,s2,0x3
    800004c2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004c4:	00093483          	ld	s1,0(s2)
    800004c8:	0014f793          	andi	a5,s1,1
    800004cc:	dfd5                	beqz	a5,80000488 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004ce:	80a9                	srli	s1,s1,0xa
    800004d0:	04b2                	slli	s1,s1,0xc
    800004d2:	b7c5                	j	800004b2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d4:	00c9d513          	srli	a0,s3,0xc
    800004d8:	1ff57513          	andi	a0,a0,511
    800004dc:	050e                	slli	a0,a0,0x3
    800004de:	9526                	add	a0,a0,s1
}
    800004e0:	70e2                	ld	ra,56(sp)
    800004e2:	7442                	ld	s0,48(sp)
    800004e4:	74a2                	ld	s1,40(sp)
    800004e6:	7902                	ld	s2,32(sp)
    800004e8:	69e2                	ld	s3,24(sp)
    800004ea:	6a42                	ld	s4,16(sp)
    800004ec:	6aa2                	ld	s5,8(sp)
    800004ee:	6b02                	ld	s6,0(sp)
    800004f0:	6121                	addi	sp,sp,64
    800004f2:	8082                	ret
        return 0;
    800004f4:	4501                	li	a0,0
    800004f6:	b7ed                	j	800004e0 <walk+0x8e>

00000000800004f8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004f8:	57fd                	li	a5,-1
    800004fa:	83e9                	srli	a5,a5,0x1a
    800004fc:	00b7f463          	bgeu	a5,a1,80000504 <walkaddr+0xc>
    return 0;
    80000500:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000502:	8082                	ret
{
    80000504:	1141                	addi	sp,sp,-16
    80000506:	e406                	sd	ra,8(sp)
    80000508:	e022                	sd	s0,0(sp)
    8000050a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000050c:	4601                	li	a2,0
    8000050e:	00000097          	auipc	ra,0x0
    80000512:	f44080e7          	jalr	-188(ra) # 80000452 <walk>
  if(pte == 0)
    80000516:	c105                	beqz	a0,80000536 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000518:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000051a:	0117f693          	andi	a3,a5,17
    8000051e:	4745                	li	a4,17
    return 0;
    80000520:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000522:	00e68663          	beq	a3,a4,8000052e <walkaddr+0x36>
}
    80000526:	60a2                	ld	ra,8(sp)
    80000528:	6402                	ld	s0,0(sp)
    8000052a:	0141                	addi	sp,sp,16
    8000052c:	8082                	ret
  pa = PTE2PA(*pte);
    8000052e:	83a9                	srli	a5,a5,0xa
    80000530:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000534:	bfcd                	j	80000526 <walkaddr+0x2e>
    return 0;
    80000536:	4501                	li	a0,0
    80000538:	b7fd                	j	80000526 <walkaddr+0x2e>

000000008000053a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053a:	715d                	addi	sp,sp,-80
    8000053c:	e486                	sd	ra,72(sp)
    8000053e:	e0a2                	sd	s0,64(sp)
    80000540:	fc26                	sd	s1,56(sp)
    80000542:	f84a                	sd	s2,48(sp)
    80000544:	f44e                	sd	s3,40(sp)
    80000546:	f052                	sd	s4,32(sp)
    80000548:	ec56                	sd	s5,24(sp)
    8000054a:	e85a                	sd	s6,16(sp)
    8000054c:	e45e                	sd	s7,8(sp)
    8000054e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000550:	c639                	beqz	a2,8000059e <mappages+0x64>
    80000552:	8aaa                	mv	s5,a0
    80000554:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000556:	777d                	lui	a4,0xfffff
    80000558:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000055c:	fff58993          	addi	s3,a1,-1
    80000560:	99b2                	add	s3,s3,a2
    80000562:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000566:	893e                	mv	s2,a5
    80000568:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000056c:	6b85                	lui	s7,0x1
    8000056e:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000572:	4605                	li	a2,1
    80000574:	85ca                	mv	a1,s2
    80000576:	8556                	mv	a0,s5
    80000578:	00000097          	auipc	ra,0x0
    8000057c:	eda080e7          	jalr	-294(ra) # 80000452 <walk>
    80000580:	cd1d                	beqz	a0,800005be <mappages+0x84>
    if(*pte & PTE_V)
    80000582:	611c                	ld	a5,0(a0)
    80000584:	8b85                	andi	a5,a5,1
    80000586:	e785                	bnez	a5,800005ae <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000588:	80b1                	srli	s1,s1,0xc
    8000058a:	04aa                	slli	s1,s1,0xa
    8000058c:	0164e4b3          	or	s1,s1,s6
    80000590:	0014e493          	ori	s1,s1,1
    80000594:	e104                	sd	s1,0(a0)
    if(a == last)
    80000596:	05390063          	beq	s2,s3,800005d6 <mappages+0x9c>
    a += PGSIZE;
    8000059a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000059c:	bfc9                	j	8000056e <mappages+0x34>
    panic("mappages: size");
    8000059e:	00008517          	auipc	a0,0x8
    800005a2:	aba50513          	addi	a0,a0,-1350 # 80008058 <etext+0x58>
    800005a6:	00006097          	auipc	ra,0x6
    800005aa:	966080e7          	jalr	-1690(ra) # 80005f0c <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	956080e7          	jalr	-1706(ra) # 80005f0c <panic>
      return -1;
    800005be:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c0:	60a6                	ld	ra,72(sp)
    800005c2:	6406                	ld	s0,64(sp)
    800005c4:	74e2                	ld	s1,56(sp)
    800005c6:	7942                	ld	s2,48(sp)
    800005c8:	79a2                	ld	s3,40(sp)
    800005ca:	7a02                	ld	s4,32(sp)
    800005cc:	6ae2                	ld	s5,24(sp)
    800005ce:	6b42                	ld	s6,16(sp)
    800005d0:	6ba2                	ld	s7,8(sp)
    800005d2:	6161                	addi	sp,sp,80
    800005d4:	8082                	ret
  return 0;
    800005d6:	4501                	li	a0,0
    800005d8:	b7e5                	j	800005c0 <mappages+0x86>

00000000800005da <kvmmap>:
{
    800005da:	1141                	addi	sp,sp,-16
    800005dc:	e406                	sd	ra,8(sp)
    800005de:	e022                	sd	s0,0(sp)
    800005e0:	0800                	addi	s0,sp,16
    800005e2:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005e4:	86b2                	mv	a3,a2
    800005e6:	863e                	mv	a2,a5
    800005e8:	00000097          	auipc	ra,0x0
    800005ec:	f52080e7          	jalr	-174(ra) # 8000053a <mappages>
    800005f0:	e509                	bnez	a0,800005fa <kvmmap+0x20>
}
    800005f2:	60a2                	ld	ra,8(sp)
    800005f4:	6402                	ld	s0,0(sp)
    800005f6:	0141                	addi	sp,sp,16
    800005f8:	8082                	ret
    panic("kvmmap");
    800005fa:	00008517          	auipc	a0,0x8
    800005fe:	a7e50513          	addi	a0,a0,-1410 # 80008078 <etext+0x78>
    80000602:	00006097          	auipc	ra,0x6
    80000606:	90a080e7          	jalr	-1782(ra) # 80005f0c <panic>

000000008000060a <kvmmake>:
{
    8000060a:	1101                	addi	sp,sp,-32
    8000060c:	ec06                	sd	ra,24(sp)
    8000060e:	e822                	sd	s0,16(sp)
    80000610:	e426                	sd	s1,8(sp)
    80000612:	e04a                	sd	s2,0(sp)
    80000614:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	b04080e7          	jalr	-1276(ra) # 8000011a <kalloc>
    8000061e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000620:	6605                	lui	a2,0x1
    80000622:	4581                	li	a1,0
    80000624:	00000097          	auipc	ra,0x0
    80000628:	b56080e7          	jalr	-1194(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000062c:	4719                	li	a4,6
    8000062e:	6685                	lui	a3,0x1
    80000630:	10000637          	lui	a2,0x10000
    80000634:	100005b7          	lui	a1,0x10000
    80000638:	8526                	mv	a0,s1
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	fa0080e7          	jalr	-96(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000642:	4719                	li	a4,6
    80000644:	6685                	lui	a3,0x1
    80000646:	10001637          	lui	a2,0x10001
    8000064a:	100015b7          	lui	a1,0x10001
    8000064e:	8526                	mv	a0,s1
    80000650:	00000097          	auipc	ra,0x0
    80000654:	f8a080e7          	jalr	-118(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000658:	4719                	li	a4,6
    8000065a:	004006b7          	lui	a3,0x400
    8000065e:	0c000637          	lui	a2,0xc000
    80000662:	0c0005b7          	lui	a1,0xc000
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	f72080e7          	jalr	-142(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000670:	00008917          	auipc	s2,0x8
    80000674:	99090913          	addi	s2,s2,-1648 # 80008000 <etext>
    80000678:	4729                	li	a4,10
    8000067a:	80008697          	auipc	a3,0x80008
    8000067e:	98668693          	addi	a3,a3,-1658 # 8000 <_entry-0x7fff8000>
    80000682:	4605                	li	a2,1
    80000684:	067e                	slli	a2,a2,0x1f
    80000686:	85b2                	mv	a1,a2
    80000688:	8526                	mv	a0,s1
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	f50080e7          	jalr	-176(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000692:	46c5                	li	a3,17
    80000694:	06ee                	slli	a3,a3,0x1b
    80000696:	4719                	li	a4,6
    80000698:	412686b3          	sub	a3,a3,s2
    8000069c:	864a                	mv	a2,s2
    8000069e:	85ca                	mv	a1,s2
    800006a0:	8526                	mv	a0,s1
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	f38080e7          	jalr	-200(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006aa:	4729                	li	a4,10
    800006ac:	6685                	lui	a3,0x1
    800006ae:	00007617          	auipc	a2,0x7
    800006b2:	95260613          	addi	a2,a2,-1710 # 80007000 <_trampoline>
    800006b6:	040005b7          	lui	a1,0x4000
    800006ba:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006bc:	05b2                	slli	a1,a1,0xc
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f1a080e7          	jalr	-230(ra) # 800005da <kvmmap>
  proc_mapstacks(kpgtbl);
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	624080e7          	jalr	1572(ra) # 80000cee <proc_mapstacks>
}
    800006d2:	8526                	mv	a0,s1
    800006d4:	60e2                	ld	ra,24(sp)
    800006d6:	6442                	ld	s0,16(sp)
    800006d8:	64a2                	ld	s1,8(sp)
    800006da:	6902                	ld	s2,0(sp)
    800006dc:	6105                	addi	sp,sp,32
    800006de:	8082                	ret

00000000800006e0 <kvminit>:
{
    800006e0:	1141                	addi	sp,sp,-16
    800006e2:	e406                	sd	ra,8(sp)
    800006e4:	e022                	sd	s0,0(sp)
    800006e6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f22080e7          	jalr	-222(ra) # 8000060a <kvmmake>
    800006f0:	00009797          	auipc	a5,0x9
    800006f4:	90a7bc23          	sd	a0,-1768(a5) # 80009008 <kernel_pagetable>
}
    800006f8:	60a2                	ld	ra,8(sp)
    800006fa:	6402                	ld	s0,0(sp)
    800006fc:	0141                	addi	sp,sp,16
    800006fe:	8082                	ret

0000000080000700 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000700:	715d                	addi	sp,sp,-80
    80000702:	e486                	sd	ra,72(sp)
    80000704:	e0a2                	sd	s0,64(sp)
    80000706:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000708:	03459793          	slli	a5,a1,0x34
    8000070c:	e39d                	bnez	a5,80000732 <uvmunmap+0x32>
    8000070e:	f84a                	sd	s2,48(sp)
    80000710:	f44e                	sd	s3,40(sp)
    80000712:	f052                	sd	s4,32(sp)
    80000714:	ec56                	sd	s5,24(sp)
    80000716:	e85a                	sd	s6,16(sp)
    80000718:	e45e                	sd	s7,8(sp)
    8000071a:	8a2a                	mv	s4,a0
    8000071c:	892e                	mv	s2,a1
    8000071e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000720:	0632                	slli	a2,a2,0xc
    80000722:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000726:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	6b05                	lui	s6,0x1
    8000072a:	0935fb63          	bgeu	a1,s3,800007c0 <uvmunmap+0xc0>
    8000072e:	fc26                	sd	s1,56(sp)
    80000730:	a8a9                	j	8000078a <uvmunmap+0x8a>
    80000732:	fc26                	sd	s1,56(sp)
    80000734:	f84a                	sd	s2,48(sp)
    80000736:	f44e                	sd	s3,40(sp)
    80000738:	f052                	sd	s4,32(sp)
    8000073a:	ec56                	sd	s5,24(sp)
    8000073c:	e85a                	sd	s6,16(sp)
    8000073e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000740:	00008517          	auipc	a0,0x8
    80000744:	94050513          	addi	a0,a0,-1728 # 80008080 <etext+0x80>
    80000748:	00005097          	auipc	ra,0x5
    8000074c:	7c4080e7          	jalr	1988(ra) # 80005f0c <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	7b4080e7          	jalr	1972(ra) # 80005f0c <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	7a4080e7          	jalr	1956(ra) # 80005f0c <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	794080e7          	jalr	1940(ra) # 80005f0c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000780:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000784:	995a                	add	s2,s2,s6
    80000786:	03397c63          	bgeu	s2,s3,800007be <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000078a:	4601                	li	a2,0
    8000078c:	85ca                	mv	a1,s2
    8000078e:	8552                	mv	a0,s4
    80000790:	00000097          	auipc	ra,0x0
    80000794:	cc2080e7          	jalr	-830(ra) # 80000452 <walk>
    80000798:	84aa                	mv	s1,a0
    8000079a:	d95d                	beqz	a0,80000750 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000079c:	6108                	ld	a0,0(a0)
    8000079e:	00157793          	andi	a5,a0,1
    800007a2:	dfdd                	beqz	a5,80000760 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a4:	3ff57793          	andi	a5,a0,1023
    800007a8:	fd7784e3          	beq	a5,s7,80000770 <uvmunmap+0x70>
    if(do_free){
    800007ac:	fc0a8ae3          	beqz	s5,80000780 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007b0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007b2:	0532                	slli	a0,a0,0xc
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	868080e7          	jalr	-1944(ra) # 8000001c <kfree>
    800007bc:	b7d1                	j	80000780 <uvmunmap+0x80>
    800007be:	74e2                	ld	s1,56(sp)
    800007c0:	7942                	ld	s2,48(sp)
    800007c2:	79a2                	ld	s3,40(sp)
    800007c4:	7a02                	ld	s4,32(sp)
    800007c6:	6ae2                	ld	s5,24(sp)
    800007c8:	6b42                	ld	s6,16(sp)
    800007ca:	6ba2                	ld	s7,8(sp)
  }
}
    800007cc:	60a6                	ld	ra,72(sp)
    800007ce:	6406                	ld	s0,64(sp)
    800007d0:	6161                	addi	sp,sp,80
    800007d2:	8082                	ret

00000000800007d4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d4:	1101                	addi	sp,sp,-32
    800007d6:	ec06                	sd	ra,24(sp)
    800007d8:	e822                	sd	s0,16(sp)
    800007da:	e426                	sd	s1,8(sp)
    800007dc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	93c080e7          	jalr	-1732(ra) # 8000011a <kalloc>
    800007e6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e8:	c519                	beqz	a0,800007f6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ea:	6605                	lui	a2,0x1
    800007ec:	4581                	li	a1,0
    800007ee:	00000097          	auipc	ra,0x0
    800007f2:	98c080e7          	jalr	-1652(ra) # 8000017a <memset>
  return pagetable;
}
    800007f6:	8526                	mv	a0,s1
    800007f8:	60e2                	ld	ra,24(sp)
    800007fa:	6442                	ld	s0,16(sp)
    800007fc:	64a2                	ld	s1,8(sp)
    800007fe:	6105                	addi	sp,sp,32
    80000800:	8082                	ret

0000000080000802 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000802:	7179                	addi	sp,sp,-48
    80000804:	f406                	sd	ra,40(sp)
    80000806:	f022                	sd	s0,32(sp)
    80000808:	ec26                	sd	s1,24(sp)
    8000080a:	e84a                	sd	s2,16(sp)
    8000080c:	e44e                	sd	s3,8(sp)
    8000080e:	e052                	sd	s4,0(sp)
    80000810:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000812:	6785                	lui	a5,0x1
    80000814:	04f67863          	bgeu	a2,a5,80000864 <uvminit+0x62>
    80000818:	8a2a                	mv	s4,a0
    8000081a:	89ae                	mv	s3,a1
    8000081c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	8fc080e7          	jalr	-1796(ra) # 8000011a <kalloc>
    80000826:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000828:	6605                	lui	a2,0x1
    8000082a:	4581                	li	a1,0
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	94e080e7          	jalr	-1714(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000834:	4779                	li	a4,30
    80000836:	86ca                	mv	a3,s2
    80000838:	6605                	lui	a2,0x1
    8000083a:	4581                	li	a1,0
    8000083c:	8552                	mv	a0,s4
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	cfc080e7          	jalr	-772(ra) # 8000053a <mappages>
  memmove(mem, src, sz);
    80000846:	8626                	mv	a2,s1
    80000848:	85ce                	mv	a1,s3
    8000084a:	854a                	mv	a0,s2
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	98a080e7          	jalr	-1654(ra) # 800001d6 <memmove>
}
    80000854:	70a2                	ld	ra,40(sp)
    80000856:	7402                	ld	s0,32(sp)
    80000858:	64e2                	ld	s1,24(sp)
    8000085a:	6942                	ld	s2,16(sp)
    8000085c:	69a2                	ld	s3,8(sp)
    8000085e:	6a02                	ld	s4,0(sp)
    80000860:	6145                	addi	sp,sp,48
    80000862:	8082                	ret
    panic("inituvm: more than a page");
    80000864:	00008517          	auipc	a0,0x8
    80000868:	87450513          	addi	a0,a0,-1932 # 800080d8 <etext+0xd8>
    8000086c:	00005097          	auipc	ra,0x5
    80000870:	6a0080e7          	jalr	1696(ra) # 80005f0c <panic>

0000000080000874 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000874:	1101                	addi	sp,sp,-32
    80000876:	ec06                	sd	ra,24(sp)
    80000878:	e822                	sd	s0,16(sp)
    8000087a:	e426                	sd	s1,8(sp)
    8000087c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000880:	00b67d63          	bgeu	a2,a1,8000089a <uvmdealloc+0x26>
    80000884:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000886:	6785                	lui	a5,0x1
    80000888:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000088a:	00f60733          	add	a4,a2,a5
    8000088e:	76fd                	lui	a3,0xfffff
    80000890:	8f75                	and	a4,a4,a3
    80000892:	97ae                	add	a5,a5,a1
    80000894:	8ff5                	and	a5,a5,a3
    80000896:	00f76863          	bltu	a4,a5,800008a6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089a:	8526                	mv	a0,s1
    8000089c:	60e2                	ld	ra,24(sp)
    8000089e:	6442                	ld	s0,16(sp)
    800008a0:	64a2                	ld	s1,8(sp)
    800008a2:	6105                	addi	sp,sp,32
    800008a4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a6:	8f99                	sub	a5,a5,a4
    800008a8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008aa:	4685                	li	a3,1
    800008ac:	0007861b          	sext.w	a2,a5
    800008b0:	85ba                	mv	a1,a4
    800008b2:	00000097          	auipc	ra,0x0
    800008b6:	e4e080e7          	jalr	-434(ra) # 80000700 <uvmunmap>
    800008ba:	b7c5                	j	8000089a <uvmdealloc+0x26>

00000000800008bc <uvmalloc>:
  if(newsz < oldsz)
    800008bc:	0ab66563          	bltu	a2,a1,80000966 <uvmalloc+0xaa>
{
    800008c0:	7139                	addi	sp,sp,-64
    800008c2:	fc06                	sd	ra,56(sp)
    800008c4:	f822                	sd	s0,48(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f663          	bgeu	s3,a2,8000096a <uvmalloc+0xae>
    800008e2:	f426                	sd	s1,40(sp)
    800008e4:	f04a                	sd	s2,32(sp)
    800008e6:	894e                	mv	s2,s3
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c90d                	beqz	a0,80000924 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000900:	4779                	li	a4,30
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c30080e7          	jalr	-976(ra) # 8000053a <mappages>
    80000912:	e915                	bnez	a0,80000946 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x2c>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	a819                	j	80000938 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000924:	864e                	mv	a2,s3
    80000926:	85ca                	mv	a1,s2
    80000928:	8556                	mv	a0,s5
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	f4a080e7          	jalr	-182(ra) # 80000874 <uvmdealloc>
      return 0;
    80000932:	4501                	li	a0,0
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	69e2                	ld	s3,24(sp)
    8000093e:	6a42                	ld	s4,16(sp)
    80000940:	6aa2                	ld	s5,8(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1e080e7          	jalr	-226(ra) # 80000874 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	bfd1                	j	80000938 <uvmalloc+0x7c>
    return oldsz;
    80000966:	852e                	mv	a0,a1
}
    80000968:	8082                	ret
  return newsz;
    8000096a:	8532                	mv	a0,a2
    8000096c:	b7f1                	j	80000938 <uvmalloc+0x7c>

000000008000096e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000096e:	7179                	addi	sp,sp,-48
    80000970:	f406                	sd	ra,40(sp)
    80000972:	f022                	sd	s0,32(sp)
    80000974:	ec26                	sd	s1,24(sp)
    80000976:	e84a                	sd	s2,16(sp)
    80000978:	e44e                	sd	s3,8(sp)
    8000097a:	e052                	sd	s4,0(sp)
    8000097c:	1800                	addi	s0,sp,48
    8000097e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000980:	84aa                	mv	s1,a0
    80000982:	6905                	lui	s2,0x1
    80000984:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000986:	4985                	li	s3,1
    80000988:	a829                	j	800009a2 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000098c:	00c79513          	slli	a0,a5,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fde080e7          	jalr	-34(ra) # 8000096e <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009a2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f7f713          	andi	a4,a5,15
    800009a8:	ff3701e3          	beq	a4,s3,8000098a <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8b85                	andi	a5,a5,1
    800009ae:	d7fd                	beqz	a5,8000099c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	554080e7          	jalr	1364(ra) # 80005f0c <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f84080e7          	jalr	-124(ra) # 8000096e <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6785                	lui	a5,0x1
    800009fe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a00:	95be                	add	a1,a1,a5
    80000a02:	4685                	li	a3,1
    80000a04:	00c5d613          	srli	a2,a1,0xc
    80000a08:	4581                	li	a1,0
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	cf6080e7          	jalr	-778(ra) # 80000700 <uvmunmap>
    80000a12:	bfd9                	j	800009e8 <uvmfree+0xe>

0000000080000a14 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a14:	c679                	beqz	a2,80000ae2 <uvmcopy+0xce>
{
    80000a16:	715d                	addi	sp,sp,-80
    80000a18:	e486                	sd	ra,72(sp)
    80000a1a:	e0a2                	sd	s0,64(sp)
    80000a1c:	fc26                	sd	s1,56(sp)
    80000a1e:	f84a                	sd	s2,48(sp)
    80000a20:	f44e                	sd	s3,40(sp)
    80000a22:	f052                	sd	s4,32(sp)
    80000a24:	ec56                	sd	s5,24(sp)
    80000a26:	e85a                	sd	s6,16(sp)
    80000a28:	e45e                	sd	s7,8(sp)
    80000a2a:	0880                	addi	s0,sp,80
    80000a2c:	8b2a                	mv	s6,a0
    80000a2e:	8aae                	mv	s5,a1
    80000a30:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a32:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a34:	4601                	li	a2,0
    80000a36:	85ce                	mv	a1,s3
    80000a38:	855a                	mv	a0,s6
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	a18080e7          	jalr	-1512(ra) # 80000452 <walk>
    80000a42:	c531                	beqz	a0,80000a8e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a44:	6118                	ld	a4,0(a0)
    80000a46:	00177793          	andi	a5,a4,1
    80000a4a:	cbb1                	beqz	a5,80000a9e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4c:	00a75593          	srli	a1,a4,0xa
    80000a50:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a54:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	6c2080e7          	jalr	1730(ra) # 8000011a <kalloc>
    80000a60:	892a                	mv	s2,a0
    80000a62:	c939                	beqz	a0,80000ab8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85de                	mv	a1,s7
    80000a68:	fffff097          	auipc	ra,0xfffff
    80000a6c:	76e080e7          	jalr	1902(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a70:	8726                	mv	a4,s1
    80000a72:	86ca                	mv	a3,s2
    80000a74:	6605                	lui	a2,0x1
    80000a76:	85ce                	mv	a1,s3
    80000a78:	8556                	mv	a0,s5
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ac0080e7          	jalr	-1344(ra) # 8000053a <mappages>
    80000a82:	e515                	bnez	a0,80000aae <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a84:	6785                	lui	a5,0x1
    80000a86:	99be                	add	s3,s3,a5
    80000a88:	fb49e6e3          	bltu	s3,s4,80000a34 <uvmcopy+0x20>
    80000a8c:	a081                	j	80000acc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	67a50513          	addi	a0,a0,1658 # 80008108 <etext+0x108>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	476080e7          	jalr	1142(ra) # 80005f0c <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	466080e7          	jalr	1126(ra) # 80005f0c <panic>
      kfree(mem);
    80000aae:	854a                	mv	a0,s2
    80000ab0:	fffff097          	auipc	ra,0xfffff
    80000ab4:	56c080e7          	jalr	1388(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab8:	4685                	li	a3,1
    80000aba:	00c9d613          	srli	a2,s3,0xc
    80000abe:	4581                	li	a1,0
    80000ac0:	8556                	mv	a0,s5
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	c3e080e7          	jalr	-962(ra) # 80000700 <uvmunmap>
  return -1;
    80000aca:	557d                	li	a0,-1
}
    80000acc:	60a6                	ld	ra,72(sp)
    80000ace:	6406                	ld	s0,64(sp)
    80000ad0:	74e2                	ld	s1,56(sp)
    80000ad2:	7942                	ld	s2,48(sp)
    80000ad4:	79a2                	ld	s3,40(sp)
    80000ad6:	7a02                	ld	s4,32(sp)
    80000ad8:	6ae2                	ld	s5,24(sp)
    80000ada:	6b42                	ld	s6,16(sp)
    80000adc:	6ba2                	ld	s7,8(sp)
    80000ade:	6161                	addi	sp,sp,80
    80000ae0:	8082                	ret
  return 0;
    80000ae2:	4501                	li	a0,0
}
    80000ae4:	8082                	ret

0000000080000ae6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae6:	1141                	addi	sp,sp,-16
    80000ae8:	e406                	sd	ra,8(sp)
    80000aea:	e022                	sd	s0,0(sp)
    80000aec:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aee:	4601                	li	a2,0
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	962080e7          	jalr	-1694(ra) # 80000452 <walk>
  if(pte == 0)
    80000af8:	c901                	beqz	a0,80000b08 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000afa:	611c                	ld	a5,0(a0)
    80000afc:	9bbd                	andi	a5,a5,-17
    80000afe:	e11c                	sd	a5,0(a0)
}
    80000b00:	60a2                	ld	ra,8(sp)
    80000b02:	6402                	ld	s0,0(sp)
    80000b04:	0141                	addi	sp,sp,16
    80000b06:	8082                	ret
    panic("uvmclear");
    80000b08:	00007517          	auipc	a0,0x7
    80000b0c:	64050513          	addi	a0,a0,1600 # 80008148 <etext+0x148>
    80000b10:	00005097          	auipc	ra,0x5
    80000b14:	3fc080e7          	jalr	1020(ra) # 80005f0c <panic>

0000000080000b18 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b18:	c6bd                	beqz	a3,80000b86 <copyout+0x6e>
{
    80000b1a:	715d                	addi	sp,sp,-80
    80000b1c:	e486                	sd	ra,72(sp)
    80000b1e:	e0a2                	sd	s0,64(sp)
    80000b20:	fc26                	sd	s1,56(sp)
    80000b22:	f84a                	sd	s2,48(sp)
    80000b24:	f44e                	sd	s3,40(sp)
    80000b26:	f052                	sd	s4,32(sp)
    80000b28:	ec56                	sd	s5,24(sp)
    80000b2a:	e85a                	sd	s6,16(sp)
    80000b2c:	e45e                	sd	s7,8(sp)
    80000b2e:	e062                	sd	s8,0(sp)
    80000b30:	0880                	addi	s0,sp,80
    80000b32:	8b2a                	mv	s6,a0
    80000b34:	8c2e                	mv	s8,a1
    80000b36:	8a32                	mv	s4,a2
    80000b38:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b3a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3c:	6a85                	lui	s5,0x1
    80000b3e:	a015                	j	80000b62 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b40:	9562                	add	a0,a0,s8
    80000b42:	0004861b          	sext.w	a2,s1
    80000b46:	85d2                	mv	a1,s4
    80000b48:	41250533          	sub	a0,a0,s2
    80000b4c:	fffff097          	auipc	ra,0xfffff
    80000b50:	68a080e7          	jalr	1674(ra) # 800001d6 <memmove>

    len -= n;
    80000b54:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b58:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b5a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5e:	02098263          	beqz	s3,80000b82 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b62:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b66:	85ca                	mv	a1,s2
    80000b68:	855a                	mv	a0,s6
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	98e080e7          	jalr	-1650(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000b72:	cd01                	beqz	a0,80000b8a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b74:	418904b3          	sub	s1,s2,s8
    80000b78:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b7a:	fc99f3e3          	bgeu	s3,s1,80000b40 <copyout+0x28>
    80000b7e:	84ce                	mv	s1,s3
    80000b80:	b7c1                	j	80000b40 <copyout+0x28>
  }
  return 0;
    80000b82:	4501                	li	a0,0
    80000b84:	a021                	j	80000b8c <copyout+0x74>
    80000b86:	4501                	li	a0,0
}
    80000b88:	8082                	ret
      return -1;
    80000b8a:	557d                	li	a0,-1
}
    80000b8c:	60a6                	ld	ra,72(sp)
    80000b8e:	6406                	ld	s0,64(sp)
    80000b90:	74e2                	ld	s1,56(sp)
    80000b92:	7942                	ld	s2,48(sp)
    80000b94:	79a2                	ld	s3,40(sp)
    80000b96:	7a02                	ld	s4,32(sp)
    80000b98:	6ae2                	ld	s5,24(sp)
    80000b9a:	6b42                	ld	s6,16(sp)
    80000b9c:	6ba2                	ld	s7,8(sp)
    80000b9e:	6c02                	ld	s8,0(sp)
    80000ba0:	6161                	addi	sp,sp,80
    80000ba2:	8082                	ret

0000000080000ba4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba4:	caa5                	beqz	a3,80000c14 <copyin+0x70>
{
    80000ba6:	715d                	addi	sp,sp,-80
    80000ba8:	e486                	sd	ra,72(sp)
    80000baa:	e0a2                	sd	s0,64(sp)
    80000bac:	fc26                	sd	s1,56(sp)
    80000bae:	f84a                	sd	s2,48(sp)
    80000bb0:	f44e                	sd	s3,40(sp)
    80000bb2:	f052                	sd	s4,32(sp)
    80000bb4:	ec56                	sd	s5,24(sp)
    80000bb6:	e85a                	sd	s6,16(sp)
    80000bb8:	e45e                	sd	s7,8(sp)
    80000bba:	e062                	sd	s8,0(sp)
    80000bbc:	0880                	addi	s0,sp,80
    80000bbe:	8b2a                	mv	s6,a0
    80000bc0:	8a2e                	mv	s4,a1
    80000bc2:	8c32                	mv	s8,a2
    80000bc4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc8:	6a85                	lui	s5,0x1
    80000bca:	a01d                	j	80000bf0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bcc:	018505b3          	add	a1,a0,s8
    80000bd0:	0004861b          	sext.w	a2,s1
    80000bd4:	412585b3          	sub	a1,a1,s2
    80000bd8:	8552                	mv	a0,s4
    80000bda:	fffff097          	auipc	ra,0xfffff
    80000bde:	5fc080e7          	jalr	1532(ra) # 800001d6 <memmove>

    len -= n;
    80000be2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bec:	02098263          	beqz	s3,80000c10 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bf0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf4:	85ca                	mv	a1,s2
    80000bf6:	855a                	mv	a0,s6
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	900080e7          	jalr	-1792(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c00:	cd01                	beqz	a0,80000c18 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c02:	418904b3          	sub	s1,s2,s8
    80000c06:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c08:	fc99f2e3          	bgeu	s3,s1,80000bcc <copyin+0x28>
    80000c0c:	84ce                	mv	s1,s3
    80000c0e:	bf7d                	j	80000bcc <copyin+0x28>
  }
  return 0;
    80000c10:	4501                	li	a0,0
    80000c12:	a021                	j	80000c1a <copyin+0x76>
    80000c14:	4501                	li	a0,0
}
    80000c16:	8082                	ret
      return -1;
    80000c18:	557d                	li	a0,-1
}
    80000c1a:	60a6                	ld	ra,72(sp)
    80000c1c:	6406                	ld	s0,64(sp)
    80000c1e:	74e2                	ld	s1,56(sp)
    80000c20:	7942                	ld	s2,48(sp)
    80000c22:	79a2                	ld	s3,40(sp)
    80000c24:	7a02                	ld	s4,32(sp)
    80000c26:	6ae2                	ld	s5,24(sp)
    80000c28:	6b42                	ld	s6,16(sp)
    80000c2a:	6ba2                	ld	s7,8(sp)
    80000c2c:	6c02                	ld	s8,0(sp)
    80000c2e:	6161                	addi	sp,sp,80
    80000c30:	8082                	ret

0000000080000c32 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c32:	cacd                	beqz	a3,80000ce4 <copyinstr+0xb2>
{
    80000c34:	715d                	addi	sp,sp,-80
    80000c36:	e486                	sd	ra,72(sp)
    80000c38:	e0a2                	sd	s0,64(sp)
    80000c3a:	fc26                	sd	s1,56(sp)
    80000c3c:	f84a                	sd	s2,48(sp)
    80000c3e:	f44e                	sd	s3,40(sp)
    80000c40:	f052                	sd	s4,32(sp)
    80000c42:	ec56                	sd	s5,24(sp)
    80000c44:	e85a                	sd	s6,16(sp)
    80000c46:	e45e                	sd	s7,8(sp)
    80000c48:	0880                	addi	s0,sp,80
    80000c4a:	8a2a                	mv	s4,a0
    80000c4c:	8b2e                	mv	s6,a1
    80000c4e:	8bb2                	mv	s7,a2
    80000c50:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c52:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c54:	6985                	lui	s3,0x1
    80000c56:	a825                	j	80000c8e <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c58:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c5c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5e:	37fd                	addiw	a5,a5,-1
    80000c60:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c64:	60a6                	ld	ra,72(sp)
    80000c66:	6406                	ld	s0,64(sp)
    80000c68:	74e2                	ld	s1,56(sp)
    80000c6a:	7942                	ld	s2,48(sp)
    80000c6c:	79a2                	ld	s3,40(sp)
    80000c6e:	7a02                	ld	s4,32(sp)
    80000c70:	6ae2                	ld	s5,24(sp)
    80000c72:	6b42                	ld	s6,16(sp)
    80000c74:	6ba2                	ld	s7,8(sp)
    80000c76:	6161                	addi	sp,sp,80
    80000c78:	8082                	ret
    80000c7a:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000c7e:	9742                	add	a4,a4,a6
      --max;
    80000c80:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000c84:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000c88:	04e58663          	beq	a1,a4,80000cd4 <copyinstr+0xa2>
{
    80000c8c:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000c8e:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c92:	85a6                	mv	a1,s1
    80000c94:	8552                	mv	a0,s4
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	862080e7          	jalr	-1950(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c9e:	cd0d                	beqz	a0,80000cd8 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000ca0:	417486b3          	sub	a3,s1,s7
    80000ca4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000ca6:	00d97363          	bgeu	s2,a3,80000cac <copyinstr+0x7a>
    80000caa:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000cac:	955e                	add	a0,a0,s7
    80000cae:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000cb0:	c695                	beqz	a3,80000cdc <copyinstr+0xaa>
    80000cb2:	87da                	mv	a5,s6
    80000cb4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000cb6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000cba:	96da                	add	a3,a3,s6
    80000cbc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cbe:	00f60733          	add	a4,a2,a5
    80000cc2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdddc0>
    80000cc6:	db49                	beqz	a4,80000c58 <copyinstr+0x26>
        *dst = *p;
    80000cc8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000ccc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cce:	fed797e3          	bne	a5,a3,80000cbc <copyinstr+0x8a>
    80000cd2:	b765                	j	80000c7a <copyinstr+0x48>
    80000cd4:	4781                	li	a5,0
    80000cd6:	b761                	j	80000c5e <copyinstr+0x2c>
      return -1;
    80000cd8:	557d                	li	a0,-1
    80000cda:	b769                	j	80000c64 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000cdc:	6b85                	lui	s7,0x1
    80000cde:	9ba6                	add	s7,s7,s1
    80000ce0:	87da                	mv	a5,s6
    80000ce2:	b76d                	j	80000c8c <copyinstr+0x5a>
  int got_null = 0;
    80000ce4:	4781                	li	a5,0
  if(got_null){
    80000ce6:	37fd                	addiw	a5,a5,-1
    80000ce8:	0007851b          	sext.w	a0,a5
}
    80000cec:	8082                	ret

0000000080000cee <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cee:	7139                	addi	sp,sp,-64
    80000cf0:	fc06                	sd	ra,56(sp)
    80000cf2:	f822                	sd	s0,48(sp)
    80000cf4:	f426                	sd	s1,40(sp)
    80000cf6:	f04a                	sd	s2,32(sp)
    80000cf8:	ec4e                	sd	s3,24(sp)
    80000cfa:	e852                	sd	s4,16(sp)
    80000cfc:	e456                	sd	s5,8(sp)
    80000cfe:	e05a                	sd	s6,0(sp)
    80000d00:	0080                	addi	s0,sp,64
    80000d02:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d04:	00008497          	auipc	s1,0x8
    80000d08:	77c48493          	addi	s1,s1,1916 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d0c:	8b26                	mv	s6,s1
    80000d0e:	04fa5937          	lui	s2,0x4fa5
    80000d12:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d16:	0932                	slli	s2,s2,0xc
    80000d18:	fa590913          	addi	s2,s2,-91
    80000d1c:	0932                	slli	s2,s2,0xc
    80000d1e:	fa590913          	addi	s2,s2,-91
    80000d22:	0932                	slli	s2,s2,0xc
    80000d24:	fa590913          	addi	s2,s2,-91
    80000d28:	040009b7          	lui	s3,0x4000
    80000d2c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d2e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d30:	00009a97          	auipc	s5,0x9
    80000d34:	560a8a93          	addi	s5,s5,1376 # 8000a290 <tickslock>
    char *pa = kalloc();
    80000d38:	fffff097          	auipc	ra,0xfffff
    80000d3c:	3e2080e7          	jalr	994(ra) # 8000011a <kalloc>
    80000d40:	862a                	mv	a2,a0
    if(pa == 0)
    80000d42:	c121                	beqz	a0,80000d82 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d44:	416485b3          	sub	a1,s1,s6
    80000d48:	858d                	srai	a1,a1,0x3
    80000d4a:	032585b3          	mul	a1,a1,s2
    80000d4e:	2585                	addiw	a1,a1,1
    80000d50:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d54:	4719                	li	a4,6
    80000d56:	6685                	lui	a3,0x1
    80000d58:	40b985b3          	sub	a1,s3,a1
    80000d5c:	8552                	mv	a0,s4
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	87c080e7          	jalr	-1924(ra) # 800005da <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d66:	16848493          	addi	s1,s1,360
    80000d6a:	fd5497e3          	bne	s1,s5,80000d38 <proc_mapstacks+0x4a>
  }
}
    80000d6e:	70e2                	ld	ra,56(sp)
    80000d70:	7442                	ld	s0,48(sp)
    80000d72:	74a2                	ld	s1,40(sp)
    80000d74:	7902                	ld	s2,32(sp)
    80000d76:	69e2                	ld	s3,24(sp)
    80000d78:	6a42                	ld	s4,16(sp)
    80000d7a:	6aa2                	ld	s5,8(sp)
    80000d7c:	6b02                	ld	s6,0(sp)
    80000d7e:	6121                	addi	sp,sp,64
    80000d80:	8082                	ret
      panic("kalloc");
    80000d82:	00007517          	auipc	a0,0x7
    80000d86:	3d650513          	addi	a0,a0,982 # 80008158 <etext+0x158>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	182080e7          	jalr	386(ra) # 80005f0c <panic>

0000000080000d92 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d92:	7139                	addi	sp,sp,-64
    80000d94:	fc06                	sd	ra,56(sp)
    80000d96:	f822                	sd	s0,48(sp)
    80000d98:	f426                	sd	s1,40(sp)
    80000d9a:	f04a                	sd	s2,32(sp)
    80000d9c:	ec4e                	sd	s3,24(sp)
    80000d9e:	e852                	sd	s4,16(sp)
    80000da0:	e456                	sd	s5,8(sp)
    80000da2:	e05a                	sd	s6,0(sp)
    80000da4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000da6:	00007597          	auipc	a1,0x7
    80000daa:	3ba58593          	addi	a1,a1,954 # 80008160 <etext+0x160>
    80000dae:	00008517          	auipc	a0,0x8
    80000db2:	2a250513          	addi	a0,a0,674 # 80009050 <pid_lock>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	640080e7          	jalr	1600(ra) # 800063f6 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	addi	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	00008517          	auipc	a0,0x8
    80000dca:	2a250513          	addi	a0,a0,674 # 80009068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	628080e7          	jalr	1576(ra) # 800063f6 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	00008497          	auipc	s1,0x8
    80000dda:	6aa48493          	addi	s1,s1,1706 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dde:	00007b17          	auipc	s6,0x7
    80000de2:	39ab0b13          	addi	s6,s6,922 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	8aa6                	mv	s5,s1
    80000de8:	04fa5937          	lui	s2,0x4fa5
    80000dec:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000df0:	0932                	slli	s2,s2,0xc
    80000df2:	fa590913          	addi	s2,s2,-91
    80000df6:	0932                	slli	s2,s2,0xc
    80000df8:	fa590913          	addi	s2,s2,-91
    80000dfc:	0932                	slli	s2,s2,0xc
    80000dfe:	fa590913          	addi	s2,s2,-91
    80000e02:	040009b7          	lui	s3,0x4000
    80000e06:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e08:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	00009a17          	auipc	s4,0x9
    80000e0e:	486a0a13          	addi	s4,s4,1158 # 8000a290 <tickslock>
      initlock(&p->lock, "proc");
    80000e12:	85da                	mv	a1,s6
    80000e14:	8526                	mv	a0,s1
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	5e0080e7          	jalr	1504(ra) # 800063f6 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e1e:	415487b3          	sub	a5,s1,s5
    80000e22:	878d                	srai	a5,a5,0x3
    80000e24:	032787b3          	mul	a5,a5,s2
    80000e28:	2785                	addiw	a5,a5,1
    80000e2a:	00d7979b          	slliw	a5,a5,0xd
    80000e2e:	40f987b3          	sub	a5,s3,a5
    80000e32:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	16848493          	addi	s1,s1,360
    80000e38:	fd449de3          	bne	s1,s4,80000e12 <procinit+0x80>
  }
}
    80000e3c:	70e2                	ld	ra,56(sp)
    80000e3e:	7442                	ld	s0,48(sp)
    80000e40:	74a2                	ld	s1,40(sp)
    80000e42:	7902                	ld	s2,32(sp)
    80000e44:	69e2                	ld	s3,24(sp)
    80000e46:	6a42                	ld	s4,16(sp)
    80000e48:	6aa2                	ld	s5,8(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
    80000e4c:	6121                	addi	sp,sp,64
    80000e4e:	8082                	ret

0000000080000e50 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e56:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e58:	2501                	sext.w	a0,a0
    80000e5a:	6422                	ld	s0,8(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret

0000000080000e60 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	addi	s0,sp,16
    80000e66:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e6c:	00008517          	auipc	a0,0x8
    80000e70:	21450513          	addi	a0,a0,532 # 80009080 <cpus>
    80000e74:	953e                	add	a0,a0,a5
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	addi	sp,sp,16
    80000e7a:	8082                	ret

0000000080000e7c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e7c:	1101                	addi	sp,sp,-32
    80000e7e:	ec06                	sd	ra,24(sp)
    80000e80:	e822                	sd	s0,16(sp)
    80000e82:	e426                	sd	s1,8(sp)
    80000e84:	1000                	addi	s0,sp,32
  push_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	5b4080e7          	jalr	1460(ra) # 8000643a <push_off>
    80000e8e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e90:	2781                	sext.w	a5,a5
    80000e92:	079e                	slli	a5,a5,0x7
    80000e94:	00008717          	auipc	a4,0x8
    80000e98:	1bc70713          	addi	a4,a4,444 # 80009050 <pid_lock>
    80000e9c:	97ba                	add	a5,a5,a4
    80000e9e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	63a080e7          	jalr	1594(ra) # 800064da <pop_off>
  return p;
}
    80000ea8:	8526                	mv	a0,s1
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	64a2                	ld	s1,8(sp)
    80000eb0:	6105                	addi	sp,sp,32
    80000eb2:	8082                	ret

0000000080000eb4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e406                	sd	ra,8(sp)
    80000eb8:	e022                	sd	s0,0(sp)
    80000eba:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ebc:	00000097          	auipc	ra,0x0
    80000ec0:	fc0080e7          	jalr	-64(ra) # 80000e7c <myproc>
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	676080e7          	jalr	1654(ra) # 8000653a <release>

  if (first) {
    80000ecc:	00008797          	auipc	a5,0x8
    80000ed0:	9547a783          	lw	a5,-1708(a5) # 80008820 <first.1>
    80000ed4:	eb89                	bnez	a5,80000ee6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	c10080e7          	jalr	-1008(ra) # 80001ae6 <usertrapret>
}
    80000ede:	60a2                	ld	ra,8(sp)
    80000ee0:	6402                	ld	s0,0(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
    first = 0;
    80000ee6:	00008797          	auipc	a5,0x8
    80000eea:	9207ad23          	sw	zero,-1734(a5) # 80008820 <first.1>
    fsinit(ROOTDEV);
    80000eee:	4505                	li	a0,1
    80000ef0:	00002097          	auipc	ra,0x2
    80000ef4:	a10080e7          	jalr	-1520(ra) # 80002900 <fsinit>
    80000ef8:	bff9                	j	80000ed6 <forkret+0x22>

0000000080000efa <allocpid>:
allocpid() {
    80000efa:	1101                	addi	sp,sp,-32
    80000efc:	ec06                	sd	ra,24(sp)
    80000efe:	e822                	sd	s0,16(sp)
    80000f00:	e426                	sd	s1,8(sp)
    80000f02:	e04a                	sd	s2,0(sp)
    80000f04:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f06:	00008917          	auipc	s2,0x8
    80000f0a:	14a90913          	addi	s2,s2,330 # 80009050 <pid_lock>
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	576080e7          	jalr	1398(ra) # 80006486 <acquire>
  pid = nextpid;
    80000f18:	00008797          	auipc	a5,0x8
    80000f1c:	90c78793          	addi	a5,a5,-1780 # 80008824 <nextpid>
    80000f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f22:	0014871b          	addiw	a4,s1,1
    80000f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	610080e7          	jalr	1552(ra) # 8000653a <release>
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6902                	ld	s2,0(sp)
    80000f3c:	6105                	addi	sp,sp,32
    80000f3e:	8082                	ret

0000000080000f40 <proc_pagetable>:
{
    80000f40:	1101                	addi	sp,sp,-32
    80000f42:	ec06                	sd	ra,24(sp)
    80000f44:	e822                	sd	s0,16(sp)
    80000f46:	e426                	sd	s1,8(sp)
    80000f48:	e04a                	sd	s2,0(sp)
    80000f4a:	1000                	addi	s0,sp,32
    80000f4c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	886080e7          	jalr	-1914(ra) # 800007d4 <uvmcreate>
    80000f56:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f58:	c121                	beqz	a0,80000f98 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f5a:	4729                	li	a4,10
    80000f5c:	00006697          	auipc	a3,0x6
    80000f60:	0a468693          	addi	a3,a3,164 # 80007000 <_trampoline>
    80000f64:	6605                	lui	a2,0x1
    80000f66:	040005b7          	lui	a1,0x4000
    80000f6a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f6c:	05b2                	slli	a1,a1,0xc
    80000f6e:	fffff097          	auipc	ra,0xfffff
    80000f72:	5cc080e7          	jalr	1484(ra) # 8000053a <mappages>
    80000f76:	02054863          	bltz	a0,80000fa6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f7a:	4719                	li	a4,6
    80000f7c:	05893683          	ld	a3,88(s2)
    80000f80:	6605                	lui	a2,0x1
    80000f82:	020005b7          	lui	a1,0x2000
    80000f86:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f88:	05b6                	slli	a1,a1,0xd
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	5ae080e7          	jalr	1454(ra) # 8000053a <mappages>
    80000f94:	02054163          	bltz	a0,80000fb6 <proc_pagetable+0x76>
}
    80000f98:	8526                	mv	a0,s1
    80000f9a:	60e2                	ld	ra,24(sp)
    80000f9c:	6442                	ld	s0,16(sp)
    80000f9e:	64a2                	ld	s1,8(sp)
    80000fa0:	6902                	ld	s2,0(sp)
    80000fa2:	6105                	addi	sp,sp,32
    80000fa4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fa6:	4581                	li	a1,0
    80000fa8:	8526                	mv	a0,s1
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	a30080e7          	jalr	-1488(ra) # 800009da <uvmfree>
    return 0;
    80000fb2:	4481                	li	s1,0
    80000fb4:	b7d5                	j	80000f98 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	040005b7          	lui	a1,0x4000
    80000fbe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fc0:	05b2                	slli	a1,a1,0xc
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	73c080e7          	jalr	1852(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fcc:	4581                	li	a1,0
    80000fce:	8526                	mv	a0,s1
    80000fd0:	00000097          	auipc	ra,0x0
    80000fd4:	a0a080e7          	jalr	-1526(ra) # 800009da <uvmfree>
    return 0;
    80000fd8:	4481                	li	s1,0
    80000fda:	bf7d                	j	80000f98 <proc_pagetable+0x58>

0000000080000fdc <proc_freepagetable>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	e04a                	sd	s2,0(sp)
    80000fe6:	1000                	addi	s0,sp,32
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fec:	4681                	li	a3,0
    80000fee:	4605                	li	a2,1
    80000ff0:	040005b7          	lui	a1,0x4000
    80000ff4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff6:	05b2                	slli	a1,a1,0xc
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	708080e7          	jalr	1800(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	020005b7          	lui	a1,0x2000
    80001008:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000100a:	05b6                	slli	a1,a1,0xd
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	6f2080e7          	jalr	1778(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    80001016:	85ca                	mv	a1,s2
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	9c0080e7          	jalr	-1600(ra) # 800009da <uvmfree>
}
    80001022:	60e2                	ld	ra,24(sp)
    80001024:	6442                	ld	s0,16(sp)
    80001026:	64a2                	ld	s1,8(sp)
    80001028:	6902                	ld	s2,0(sp)
    8000102a:	6105                	addi	sp,sp,32
    8000102c:	8082                	ret

000000008000102e <freeproc>:
{
    8000102e:	1101                	addi	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	addi	s0,sp,32
    80001038:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000103a:	6d28                	ld	a0,88(a0)
    8000103c:	c509                	beqz	a0,80001046 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	fde080e7          	jalr	-34(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001046:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000104a:	68a8                	ld	a0,80(s1)
    8000104c:	c511                	beqz	a0,80001058 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000104e:	64ac                	ld	a1,72(s1)
    80001050:	00000097          	auipc	ra,0x0
    80001054:	f8c080e7          	jalr	-116(ra) # 80000fdc <proc_freepagetable>
  p->pagetable = 0;
    80001058:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000105c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001060:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001064:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001068:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000106c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001070:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001074:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001078:	0004ac23          	sw	zero,24(s1)
}
    8000107c:	60e2                	ld	ra,24(sp)
    8000107e:	6442                	ld	s0,16(sp)
    80001080:	64a2                	ld	s1,8(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret

0000000080001086 <allocproc>:
{
    80001086:	1101                	addi	sp,sp,-32
    80001088:	ec06                	sd	ra,24(sp)
    8000108a:	e822                	sd	s0,16(sp)
    8000108c:	e426                	sd	s1,8(sp)
    8000108e:	e04a                	sd	s2,0(sp)
    80001090:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001092:	00008497          	auipc	s1,0x8
    80001096:	3ee48493          	addi	s1,s1,1006 # 80009480 <proc>
    8000109a:	00009917          	auipc	s2,0x9
    8000109e:	1f690913          	addi	s2,s2,502 # 8000a290 <tickslock>
    acquire(&p->lock);
    800010a2:	8526                	mv	a0,s1
    800010a4:	00005097          	auipc	ra,0x5
    800010a8:	3e2080e7          	jalr	994(ra) # 80006486 <acquire>
    if(p->state == UNUSED) {
    800010ac:	4c9c                	lw	a5,24(s1)
    800010ae:	c395                	beqz	a5,800010d2 <allocproc+0x4c>
      release(&p->lock);
    800010b0:	8526                	mv	a0,s1
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	488080e7          	jalr	1160(ra) # 8000653a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ba:	16848493          	addi	s1,s1,360
    800010be:	ff2492e3          	bne	s1,s2,800010a2 <allocproc+0x1c>
  return 0;
    800010c2:	4481                	li	s1,0
}
    800010c4:	8526                	mv	a0,s1
    800010c6:	60e2                	ld	ra,24(sp)
    800010c8:	6442                	ld	s0,16(sp)
    800010ca:	64a2                	ld	s1,8(sp)
    800010cc:	6902                	ld	s2,0(sp)
    800010ce:	6105                	addi	sp,sp,32
    800010d0:	8082                	ret
  p->pid = allocpid();
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	e28080e7          	jalr	-472(ra) # 80000efa <allocpid>
    800010da:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010dc:	4785                	li	a5,1
    800010de:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010e0:	fffff097          	auipc	ra,0xfffff
    800010e4:	03a080e7          	jalr	58(ra) # 8000011a <kalloc>
    800010e8:	892a                	mv	s2,a0
    800010ea:	eca8                	sd	a0,88(s1)
    800010ec:	cd05                	beqz	a0,80001124 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ee:	8526                	mv	a0,s1
    800010f0:	00000097          	auipc	ra,0x0
    800010f4:	e50080e7          	jalr	-432(ra) # 80000f40 <proc_pagetable>
    800010f8:	892a                	mv	s2,a0
    800010fa:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010fc:	c121                	beqz	a0,8000113c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010fe:	07000613          	li	a2,112
    80001102:	4581                	li	a1,0
    80001104:	06048513          	addi	a0,s1,96
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	072080e7          	jalr	114(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001110:	00000797          	auipc	a5,0x0
    80001114:	da478793          	addi	a5,a5,-604 # 80000eb4 <forkret>
    80001118:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000111a:	60bc                	ld	a5,64(s1)
    8000111c:	6705                	lui	a4,0x1
    8000111e:	97ba                	add	a5,a5,a4
    80001120:	f4bc                	sd	a5,104(s1)
  return p;
    80001122:	b74d                	j	800010c4 <allocproc+0x3e>
    freeproc(p);
    80001124:	8526                	mv	a0,s1
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f08080e7          	jalr	-248(ra) # 8000102e <freeproc>
    release(&p->lock);
    8000112e:	8526                	mv	a0,s1
    80001130:	00005097          	auipc	ra,0x5
    80001134:	40a080e7          	jalr	1034(ra) # 8000653a <release>
    return 0;
    80001138:	84ca                	mv	s1,s2
    8000113a:	b769                	j	800010c4 <allocproc+0x3e>
    freeproc(p);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	ef0080e7          	jalr	-272(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001146:	8526                	mv	a0,s1
    80001148:	00005097          	auipc	ra,0x5
    8000114c:	3f2080e7          	jalr	1010(ra) # 8000653a <release>
    return 0;
    80001150:	84ca                	mv	s1,s2
    80001152:	bf8d                	j	800010c4 <allocproc+0x3e>

0000000080001154 <userinit>:
{
    80001154:	1101                	addi	sp,sp,-32
    80001156:	ec06                	sd	ra,24(sp)
    80001158:	e822                	sd	s0,16(sp)
    8000115a:	e426                	sd	s1,8(sp)
    8000115c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000115e:	00000097          	auipc	ra,0x0
    80001162:	f28080e7          	jalr	-216(ra) # 80001086 <allocproc>
    80001166:	84aa                	mv	s1,a0
  initproc = p;
    80001168:	00008797          	auipc	a5,0x8
    8000116c:	eaa7b423          	sd	a0,-344(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001170:	03400613          	li	a2,52
    80001174:	00007597          	auipc	a1,0x7
    80001178:	6bc58593          	addi	a1,a1,1724 # 80008830 <initcode>
    8000117c:	6928                	ld	a0,80(a0)
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	684080e7          	jalr	1668(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    80001186:	6785                	lui	a5,0x1
    80001188:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000118a:	6cb8                	ld	a4,88(s1)
    8000118c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001190:	6cb8                	ld	a4,88(s1)
    80001192:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001194:	4641                	li	a2,16
    80001196:	00007597          	auipc	a1,0x7
    8000119a:	fea58593          	addi	a1,a1,-22 # 80008180 <etext+0x180>
    8000119e:	15848513          	addi	a0,s1,344
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	11a080e7          	jalr	282(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800011aa:	00007517          	auipc	a0,0x7
    800011ae:	fe650513          	addi	a0,a0,-26 # 80008190 <etext+0x190>
    800011b2:	00002097          	auipc	ra,0x2
    800011b6:	244080e7          	jalr	580(ra) # 800033f6 <namei>
    800011ba:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011be:	478d                	li	a5,3
    800011c0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011c2:	8526                	mv	a0,s1
    800011c4:	00005097          	auipc	ra,0x5
    800011c8:	376080e7          	jalr	886(ra) # 8000653a <release>
}
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <growproc>:
{
    800011d6:	1101                	addi	sp,sp,-32
    800011d8:	ec06                	sd	ra,24(sp)
    800011da:	e822                	sd	s0,16(sp)
    800011dc:	e426                	sd	s1,8(sp)
    800011de:	e04a                	sd	s2,0(sp)
    800011e0:	1000                	addi	s0,sp,32
    800011e2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	c98080e7          	jalr	-872(ra) # 80000e7c <myproc>
    800011ec:	892a                	mv	s2,a0
  sz = p->sz;
    800011ee:	652c                	ld	a1,72(a0)
    800011f0:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011f4:	00904f63          	bgtz	s1,80001212 <growproc+0x3c>
  } else if(n < 0){
    800011f8:	0204cd63          	bltz	s1,80001232 <growproc+0x5c>
  p->sz = sz;
    800011fc:	1782                	slli	a5,a5,0x20
    800011fe:	9381                	srli	a5,a5,0x20
    80001200:	04f93423          	sd	a5,72(s2)
  return 0;
    80001204:	4501                	li	a0,0
}
    80001206:	60e2                	ld	ra,24(sp)
    80001208:	6442                	ld	s0,16(sp)
    8000120a:	64a2                	ld	s1,8(sp)
    8000120c:	6902                	ld	s2,0(sp)
    8000120e:	6105                	addi	sp,sp,32
    80001210:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001212:	00f4863b          	addw	a2,s1,a5
    80001216:	1602                	slli	a2,a2,0x20
    80001218:	9201                	srli	a2,a2,0x20
    8000121a:	1582                	slli	a1,a1,0x20
    8000121c:	9181                	srli	a1,a1,0x20
    8000121e:	6928                	ld	a0,80(a0)
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	69c080e7          	jalr	1692(ra) # 800008bc <uvmalloc>
    80001228:	0005079b          	sext.w	a5,a0
    8000122c:	fbe1                	bnez	a5,800011fc <growproc+0x26>
      return -1;
    8000122e:	557d                	li	a0,-1
    80001230:	bfd9                	j	80001206 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001232:	00f4863b          	addw	a2,s1,a5
    80001236:	1602                	slli	a2,a2,0x20
    80001238:	9201                	srli	a2,a2,0x20
    8000123a:	1582                	slli	a1,a1,0x20
    8000123c:	9181                	srli	a1,a1,0x20
    8000123e:	6928                	ld	a0,80(a0)
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	634080e7          	jalr	1588(ra) # 80000874 <uvmdealloc>
    80001248:	0005079b          	sext.w	a5,a0
    8000124c:	bf45                	j	800011fc <growproc+0x26>

000000008000124e <fork>:
{
    8000124e:	7139                	addi	sp,sp,-64
    80001250:	fc06                	sd	ra,56(sp)
    80001252:	f822                	sd	s0,48(sp)
    80001254:	f04a                	sd	s2,32(sp)
    80001256:	e456                	sd	s5,8(sp)
    80001258:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	c22080e7          	jalr	-990(ra) # 80000e7c <myproc>
    80001262:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001264:	00000097          	auipc	ra,0x0
    80001268:	e22080e7          	jalr	-478(ra) # 80001086 <allocproc>
    8000126c:	12050063          	beqz	a0,8000138c <fork+0x13e>
    80001270:	e852                	sd	s4,16(sp)
    80001272:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001274:	048ab603          	ld	a2,72(s5)
    80001278:	692c                	ld	a1,80(a0)
    8000127a:	050ab503          	ld	a0,80(s5)
    8000127e:	fffff097          	auipc	ra,0xfffff
    80001282:	796080e7          	jalr	1942(ra) # 80000a14 <uvmcopy>
    80001286:	04054a63          	bltz	a0,800012da <fork+0x8c>
    8000128a:	f426                	sd	s1,40(sp)
    8000128c:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000128e:	048ab783          	ld	a5,72(s5)
    80001292:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001296:	058ab683          	ld	a3,88(s5)
    8000129a:	87b6                	mv	a5,a3
    8000129c:	058a3703          	ld	a4,88(s4)
    800012a0:	12068693          	addi	a3,a3,288
    800012a4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012a8:	6788                	ld	a0,8(a5)
    800012aa:	6b8c                	ld	a1,16(a5)
    800012ac:	6f90                	ld	a2,24(a5)
    800012ae:	01073023          	sd	a6,0(a4)
    800012b2:	e708                	sd	a0,8(a4)
    800012b4:	eb0c                	sd	a1,16(a4)
    800012b6:	ef10                	sd	a2,24(a4)
    800012b8:	02078793          	addi	a5,a5,32
    800012bc:	02070713          	addi	a4,a4,32
    800012c0:	fed792e3          	bne	a5,a3,800012a4 <fork+0x56>
  np->trapframe->a0 = 0;
    800012c4:	058a3783          	ld	a5,88(s4)
    800012c8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012cc:	0d0a8493          	addi	s1,s5,208
    800012d0:	0d0a0913          	addi	s2,s4,208
    800012d4:	150a8993          	addi	s3,s5,336
    800012d8:	a015                	j	800012fc <fork+0xae>
    freeproc(np);
    800012da:	8552                	mv	a0,s4
    800012dc:	00000097          	auipc	ra,0x0
    800012e0:	d52080e7          	jalr	-686(ra) # 8000102e <freeproc>
    release(&np->lock);
    800012e4:	8552                	mv	a0,s4
    800012e6:	00005097          	auipc	ra,0x5
    800012ea:	254080e7          	jalr	596(ra) # 8000653a <release>
    return -1;
    800012ee:	597d                	li	s2,-1
    800012f0:	6a42                	ld	s4,16(sp)
    800012f2:	a071                	j	8000137e <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800012f4:	04a1                	addi	s1,s1,8
    800012f6:	0921                	addi	s2,s2,8
    800012f8:	01348b63          	beq	s1,s3,8000130e <fork+0xc0>
    if(p->ofile[i])
    800012fc:	6088                	ld	a0,0(s1)
    800012fe:	d97d                	beqz	a0,800012f4 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001300:	00002097          	auipc	ra,0x2
    80001304:	76e080e7          	jalr	1902(ra) # 80003a6e <filedup>
    80001308:	00a93023          	sd	a0,0(s2)
    8000130c:	b7e5                	j	800012f4 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000130e:	150ab503          	ld	a0,336(s5)
    80001312:	00002097          	auipc	ra,0x2
    80001316:	824080e7          	jalr	-2012(ra) # 80002b36 <idup>
    8000131a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000131e:	4641                	li	a2,16
    80001320:	158a8593          	addi	a1,s5,344
    80001324:	158a0513          	addi	a0,s4,344
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	f94080e7          	jalr	-108(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001330:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001334:	8552                	mv	a0,s4
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	204080e7          	jalr	516(ra) # 8000653a <release>
  acquire(&wait_lock);
    8000133e:	00008497          	auipc	s1,0x8
    80001342:	d2a48493          	addi	s1,s1,-726 # 80009068 <wait_lock>
    80001346:	8526                	mv	a0,s1
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	13e080e7          	jalr	318(ra) # 80006486 <acquire>
  np->parent = p;
    80001350:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001354:	8526                	mv	a0,s1
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	1e4080e7          	jalr	484(ra) # 8000653a <release>
  acquire(&np->lock);
    8000135e:	8552                	mv	a0,s4
    80001360:	00005097          	auipc	ra,0x5
    80001364:	126080e7          	jalr	294(ra) # 80006486 <acquire>
  np->state = RUNNABLE;
    80001368:	478d                	li	a5,3
    8000136a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000136e:	8552                	mv	a0,s4
    80001370:	00005097          	auipc	ra,0x5
    80001374:	1ca080e7          	jalr	458(ra) # 8000653a <release>
  return pid;
    80001378:	74a2                	ld	s1,40(sp)
    8000137a:	69e2                	ld	s3,24(sp)
    8000137c:	6a42                	ld	s4,16(sp)
}
    8000137e:	854a                	mv	a0,s2
    80001380:	70e2                	ld	ra,56(sp)
    80001382:	7442                	ld	s0,48(sp)
    80001384:	7902                	ld	s2,32(sp)
    80001386:	6aa2                	ld	s5,8(sp)
    80001388:	6121                	addi	sp,sp,64
    8000138a:	8082                	ret
    return -1;
    8000138c:	597d                	li	s2,-1
    8000138e:	bfc5                	j	8000137e <fork+0x130>

0000000080001390 <scheduler>:
{
    80001390:	7139                	addi	sp,sp,-64
    80001392:	fc06                	sd	ra,56(sp)
    80001394:	f822                	sd	s0,48(sp)
    80001396:	f426                	sd	s1,40(sp)
    80001398:	f04a                	sd	s2,32(sp)
    8000139a:	ec4e                	sd	s3,24(sp)
    8000139c:	e852                	sd	s4,16(sp)
    8000139e:	e456                	sd	s5,8(sp)
    800013a0:	e05a                	sd	s6,0(sp)
    800013a2:	0080                	addi	s0,sp,64
    800013a4:	8792                	mv	a5,tp
  int id = r_tp();
    800013a6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a8:	00779a93          	slli	s5,a5,0x7
    800013ac:	00008717          	auipc	a4,0x8
    800013b0:	ca470713          	addi	a4,a4,-860 # 80009050 <pid_lock>
    800013b4:	9756                	add	a4,a4,s5
    800013b6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ba:	00008717          	auipc	a4,0x8
    800013be:	cce70713          	addi	a4,a4,-818 # 80009088 <cpus+0x8>
    800013c2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013c4:	498d                	li	s3,3
        p->state = RUNNING;
    800013c6:	4b11                	li	s6,4
        c->proc = p;
    800013c8:	079e                	slli	a5,a5,0x7
    800013ca:	00008a17          	auipc	s4,0x8
    800013ce:	c86a0a13          	addi	s4,s4,-890 # 80009050 <pid_lock>
    800013d2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d4:	00009917          	auipc	s2,0x9
    800013d8:	ebc90913          	addi	s2,s2,-324 # 8000a290 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013dc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013e0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013e4:	10079073          	csrw	sstatus,a5
    800013e8:	00008497          	auipc	s1,0x8
    800013ec:	09848493          	addi	s1,s1,152 # 80009480 <proc>
    800013f0:	a811                	j	80001404 <scheduler+0x74>
      release(&p->lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	00005097          	auipc	ra,0x5
    800013f8:	146080e7          	jalr	326(ra) # 8000653a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013fc:	16848493          	addi	s1,s1,360
    80001400:	fd248ee3          	beq	s1,s2,800013dc <scheduler+0x4c>
      acquire(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	080080e7          	jalr	128(ra) # 80006486 <acquire>
      if(p->state == RUNNABLE) {
    8000140e:	4c9c                	lw	a5,24(s1)
    80001410:	ff3791e3          	bne	a5,s3,800013f2 <scheduler+0x62>
        p->state = RUNNING;
    80001414:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001418:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000141c:	06048593          	addi	a1,s1,96
    80001420:	8556                	mv	a0,s5
    80001422:	00000097          	auipc	ra,0x0
    80001426:	61a080e7          	jalr	1562(ra) # 80001a3c <swtch>
        c->proc = 0;
    8000142a:	020a3823          	sd	zero,48(s4)
    8000142e:	b7d1                	j	800013f2 <scheduler+0x62>

0000000080001430 <sched>:
{
    80001430:	7179                	addi	sp,sp,-48
    80001432:	f406                	sd	ra,40(sp)
    80001434:	f022                	sd	s0,32(sp)
    80001436:	ec26                	sd	s1,24(sp)
    80001438:	e84a                	sd	s2,16(sp)
    8000143a:	e44e                	sd	s3,8(sp)
    8000143c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	a3e080e7          	jalr	-1474(ra) # 80000e7c <myproc>
    80001446:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001448:	00005097          	auipc	ra,0x5
    8000144c:	fc4080e7          	jalr	-60(ra) # 8000640c <holding>
    80001450:	c93d                	beqz	a0,800014c6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001452:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	00008717          	auipc	a4,0x8
    8000145c:	bf870713          	addi	a4,a4,-1032 # 80009050 <pid_lock>
    80001460:	97ba                	add	a5,a5,a4
    80001462:	0a87a703          	lw	a4,168(a5)
    80001466:	4785                	li	a5,1
    80001468:	06f71763          	bne	a4,a5,800014d6 <sched+0xa6>
  if(p->state == RUNNING)
    8000146c:	4c98                	lw	a4,24(s1)
    8000146e:	4791                	li	a5,4
    80001470:	06f70b63          	beq	a4,a5,800014e6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001474:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001478:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000147a:	efb5                	bnez	a5,800014f6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000147c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000147e:	00008917          	auipc	s2,0x8
    80001482:	bd290913          	addi	s2,s2,-1070 # 80009050 <pid_lock>
    80001486:	2781                	sext.w	a5,a5
    80001488:	079e                	slli	a5,a5,0x7
    8000148a:	97ca                	add	a5,a5,s2
    8000148c:	0ac7a983          	lw	s3,172(a5)
    80001490:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001492:	2781                	sext.w	a5,a5
    80001494:	079e                	slli	a5,a5,0x7
    80001496:	00008597          	auipc	a1,0x8
    8000149a:	bf258593          	addi	a1,a1,-1038 # 80009088 <cpus+0x8>
    8000149e:	95be                	add	a1,a1,a5
    800014a0:	06048513          	addi	a0,s1,96
    800014a4:	00000097          	auipc	ra,0x0
    800014a8:	598080e7          	jalr	1432(ra) # 80001a3c <swtch>
    800014ac:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014ae:	2781                	sext.w	a5,a5
    800014b0:	079e                	slli	a5,a5,0x7
    800014b2:	993e                	add	s2,s2,a5
    800014b4:	0b392623          	sw	s3,172(s2)
}
    800014b8:	70a2                	ld	ra,40(sp)
    800014ba:	7402                	ld	s0,32(sp)
    800014bc:	64e2                	ld	s1,24(sp)
    800014be:	6942                	ld	s2,16(sp)
    800014c0:	69a2                	ld	s3,8(sp)
    800014c2:	6145                	addi	sp,sp,48
    800014c4:	8082                	ret
    panic("sched p->lock");
    800014c6:	00007517          	auipc	a0,0x7
    800014ca:	cd250513          	addi	a0,a0,-814 # 80008198 <etext+0x198>
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	a3e080e7          	jalr	-1474(ra) # 80005f0c <panic>
    panic("sched locks");
    800014d6:	00007517          	auipc	a0,0x7
    800014da:	cd250513          	addi	a0,a0,-814 # 800081a8 <etext+0x1a8>
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	a2e080e7          	jalr	-1490(ra) # 80005f0c <panic>
    panic("sched running");
    800014e6:	00007517          	auipc	a0,0x7
    800014ea:	cd250513          	addi	a0,a0,-814 # 800081b8 <etext+0x1b8>
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	a1e080e7          	jalr	-1506(ra) # 80005f0c <panic>
    panic("sched interruptible");
    800014f6:	00007517          	auipc	a0,0x7
    800014fa:	cd250513          	addi	a0,a0,-814 # 800081c8 <etext+0x1c8>
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	a0e080e7          	jalr	-1522(ra) # 80005f0c <panic>

0000000080001506 <yield>:
{
    80001506:	1101                	addi	sp,sp,-32
    80001508:	ec06                	sd	ra,24(sp)
    8000150a:	e822                	sd	s0,16(sp)
    8000150c:	e426                	sd	s1,8(sp)
    8000150e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001510:	00000097          	auipc	ra,0x0
    80001514:	96c080e7          	jalr	-1684(ra) # 80000e7c <myproc>
    80001518:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	f6c080e7          	jalr	-148(ra) # 80006486 <acquire>
  p->state = RUNNABLE;
    80001522:	478d                	li	a5,3
    80001524:	cc9c                	sw	a5,24(s1)
  sched();
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	f0a080e7          	jalr	-246(ra) # 80001430 <sched>
  release(&p->lock);
    8000152e:	8526                	mv	a0,s1
    80001530:	00005097          	auipc	ra,0x5
    80001534:	00a080e7          	jalr	10(ra) # 8000653a <release>
}
    80001538:	60e2                	ld	ra,24(sp)
    8000153a:	6442                	ld	s0,16(sp)
    8000153c:	64a2                	ld	s1,8(sp)
    8000153e:	6105                	addi	sp,sp,32
    80001540:	8082                	ret

0000000080001542 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001542:	7179                	addi	sp,sp,-48
    80001544:	f406                	sd	ra,40(sp)
    80001546:	f022                	sd	s0,32(sp)
    80001548:	ec26                	sd	s1,24(sp)
    8000154a:	e84a                	sd	s2,16(sp)
    8000154c:	e44e                	sd	s3,8(sp)
    8000154e:	1800                	addi	s0,sp,48
    80001550:	89aa                	mv	s3,a0
    80001552:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001554:	00000097          	auipc	ra,0x0
    80001558:	928080e7          	jalr	-1752(ra) # 80000e7c <myproc>
    8000155c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	f28080e7          	jalr	-216(ra) # 80006486 <acquire>
  release(lk);
    80001566:	854a                	mv	a0,s2
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	fd2080e7          	jalr	-46(ra) # 8000653a <release>

  // Go to sleep.
  p->chan = chan;
    80001570:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001574:	4789                	li	a5,2
    80001576:	cc9c                	sw	a5,24(s1)

  sched();
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	eb8080e7          	jalr	-328(ra) # 80001430 <sched>

  // Tidy up.
  p->chan = 0;
    80001580:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	fb4080e7          	jalr	-76(ra) # 8000653a <release>
  acquire(lk);
    8000158e:	854a                	mv	a0,s2
    80001590:	00005097          	auipc	ra,0x5
    80001594:	ef6080e7          	jalr	-266(ra) # 80006486 <acquire>
}
    80001598:	70a2                	ld	ra,40(sp)
    8000159a:	7402                	ld	s0,32(sp)
    8000159c:	64e2                	ld	s1,24(sp)
    8000159e:	6942                	ld	s2,16(sp)
    800015a0:	69a2                	ld	s3,8(sp)
    800015a2:	6145                	addi	sp,sp,48
    800015a4:	8082                	ret

00000000800015a6 <wait>:
{
    800015a6:	715d                	addi	sp,sp,-80
    800015a8:	e486                	sd	ra,72(sp)
    800015aa:	e0a2                	sd	s0,64(sp)
    800015ac:	fc26                	sd	s1,56(sp)
    800015ae:	f84a                	sd	s2,48(sp)
    800015b0:	f44e                	sd	s3,40(sp)
    800015b2:	f052                	sd	s4,32(sp)
    800015b4:	ec56                	sd	s5,24(sp)
    800015b6:	e85a                	sd	s6,16(sp)
    800015b8:	e45e                	sd	s7,8(sp)
    800015ba:	e062                	sd	s8,0(sp)
    800015bc:	0880                	addi	s0,sp,80
    800015be:	8c2a                	mv	s8,a0
  struct proc *p = myproc();
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	8bc080e7          	jalr	-1860(ra) # 80000e7c <myproc>
    800015c8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ca:	00008517          	auipc	a0,0x8
    800015ce:	a9e50513          	addi	a0,a0,-1378 # 80009068 <wait_lock>
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	eb4080e7          	jalr	-332(ra) # 80006486 <acquire>
    havekids = 0;
    800015da:	4b01                	li	s6,0
        if(np->state == ZOMBIE){
    800015dc:	4a15                	li	s4,5
        havekids = 1;
    800015de:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015e0:	00009997          	auipc	s3,0x9
    800015e4:	cb098993          	addi	s3,s3,-848 # 8000a290 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015e8:	00008b97          	auipc	s7,0x8
    800015ec:	a80b8b93          	addi	s7,s7,-1408 # 80009068 <wait_lock>
    800015f0:	a87d                	j	800016ae <wait+0x108>
          pid = np->pid;
    800015f2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015f6:	000c0e63          	beqz	s8,80001612 <wait+0x6c>
    800015fa:	4691                	li	a3,4
    800015fc:	02c48613          	addi	a2,s1,44
    80001600:	85e2                	mv	a1,s8
    80001602:	05093503          	ld	a0,80(s2)
    80001606:	fffff097          	auipc	ra,0xfffff
    8000160a:	512080e7          	jalr	1298(ra) # 80000b18 <copyout>
    8000160e:	04054163          	bltz	a0,80001650 <wait+0xaa>
          freeproc(np);
    80001612:	8526                	mv	a0,s1
    80001614:	00000097          	auipc	ra,0x0
    80001618:	a1a080e7          	jalr	-1510(ra) # 8000102e <freeproc>
          release(&np->lock);
    8000161c:	8526                	mv	a0,s1
    8000161e:	00005097          	auipc	ra,0x5
    80001622:	f1c080e7          	jalr	-228(ra) # 8000653a <release>
          release(&wait_lock);
    80001626:	00008517          	auipc	a0,0x8
    8000162a:	a4250513          	addi	a0,a0,-1470 # 80009068 <wait_lock>
    8000162e:	00005097          	auipc	ra,0x5
    80001632:	f0c080e7          	jalr	-244(ra) # 8000653a <release>
}
    80001636:	854e                	mv	a0,s3
    80001638:	60a6                	ld	ra,72(sp)
    8000163a:	6406                	ld	s0,64(sp)
    8000163c:	74e2                	ld	s1,56(sp)
    8000163e:	7942                	ld	s2,48(sp)
    80001640:	79a2                	ld	s3,40(sp)
    80001642:	7a02                	ld	s4,32(sp)
    80001644:	6ae2                	ld	s5,24(sp)
    80001646:	6b42                	ld	s6,16(sp)
    80001648:	6ba2                	ld	s7,8(sp)
    8000164a:	6c02                	ld	s8,0(sp)
    8000164c:	6161                	addi	sp,sp,80
    8000164e:	8082                	ret
            release(&np->lock);
    80001650:	8526                	mv	a0,s1
    80001652:	00005097          	auipc	ra,0x5
    80001656:	ee8080e7          	jalr	-280(ra) # 8000653a <release>
            release(&wait_lock);
    8000165a:	00008517          	auipc	a0,0x8
    8000165e:	a0e50513          	addi	a0,a0,-1522 # 80009068 <wait_lock>
    80001662:	00005097          	auipc	ra,0x5
    80001666:	ed8080e7          	jalr	-296(ra) # 8000653a <release>
            return -1;
    8000166a:	59fd                	li	s3,-1
    8000166c:	b7e9                	j	80001636 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    8000166e:	16848493          	addi	s1,s1,360
    80001672:	03348463          	beq	s1,s3,8000169a <wait+0xf4>
      if(np->parent == p){
    80001676:	7c9c                	ld	a5,56(s1)
    80001678:	ff279be3          	bne	a5,s2,8000166e <wait+0xc8>
        acquire(&np->lock);
    8000167c:	8526                	mv	a0,s1
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	e08080e7          	jalr	-504(ra) # 80006486 <acquire>
        if(np->state == ZOMBIE){
    80001686:	4c9c                	lw	a5,24(s1)
    80001688:	f74785e3          	beq	a5,s4,800015f2 <wait+0x4c>
        release(&np->lock);
    8000168c:	8526                	mv	a0,s1
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	eac080e7          	jalr	-340(ra) # 8000653a <release>
        havekids = 1;
    80001696:	8756                	mv	a4,s5
    80001698:	bfd9                	j	8000166e <wait+0xc8>
    if(!havekids || p->killed){
    8000169a:	c305                	beqz	a4,800016ba <wait+0x114>
    8000169c:	02892783          	lw	a5,40(s2)
    800016a0:	ef89                	bnez	a5,800016ba <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016a2:	85de                	mv	a1,s7
    800016a4:	854a                	mv	a0,s2
    800016a6:	00000097          	auipc	ra,0x0
    800016aa:	e9c080e7          	jalr	-356(ra) # 80001542 <sleep>
    havekids = 0;
    800016ae:	875a                	mv	a4,s6
    for(np = proc; np < &proc[NPROC]; np++){
    800016b0:	00008497          	auipc	s1,0x8
    800016b4:	dd048493          	addi	s1,s1,-560 # 80009480 <proc>
    800016b8:	bf7d                	j	80001676 <wait+0xd0>
      release(&wait_lock);
    800016ba:	00008517          	auipc	a0,0x8
    800016be:	9ae50513          	addi	a0,a0,-1618 # 80009068 <wait_lock>
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	e78080e7          	jalr	-392(ra) # 8000653a <release>
      return -1;
    800016ca:	59fd                	li	s3,-1
    800016cc:	b7ad                	j	80001636 <wait+0x90>

00000000800016ce <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ce:	7179                	addi	sp,sp,-48
    800016d0:	f406                	sd	ra,40(sp)
    800016d2:	f022                	sd	s0,32(sp)
    800016d4:	ec26                	sd	s1,24(sp)
    800016d6:	e84a                	sd	s2,16(sp)
    800016d8:	e44e                	sd	s3,8(sp)
    800016da:	e052                	sd	s4,0(sp)
    800016dc:	1800                	addi	s0,sp,48
    800016de:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016e0:	00008497          	auipc	s1,0x8
    800016e4:	da048493          	addi	s1,s1,-608 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016e8:	4989                	li	s3,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ea:	00009917          	auipc	s2,0x9
    800016ee:	ba690913          	addi	s2,s2,-1114 # 8000a290 <tickslock>
    800016f2:	a811                	j	80001706 <wakeup+0x38>
        p->state = RUNNABLE;
      }
      release(&p->lock);
    800016f4:	8526                	mv	a0,s1
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	e44080e7          	jalr	-444(ra) # 8000653a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016fe:	16848493          	addi	s1,s1,360
    80001702:	03248663          	beq	s1,s2,8000172e <wakeup+0x60>
    if(p != myproc()){
    80001706:	fffff097          	auipc	ra,0xfffff
    8000170a:	776080e7          	jalr	1910(ra) # 80000e7c <myproc>
    8000170e:	fea488e3          	beq	s1,a0,800016fe <wakeup+0x30>
      acquire(&p->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	d72080e7          	jalr	-654(ra) # 80006486 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000171c:	4c9c                	lw	a5,24(s1)
    8000171e:	fd379be3          	bne	a5,s3,800016f4 <wakeup+0x26>
    80001722:	709c                	ld	a5,32(s1)
    80001724:	fd4798e3          	bne	a5,s4,800016f4 <wakeup+0x26>
        p->state = RUNNABLE;
    80001728:	478d                	li	a5,3
    8000172a:	cc9c                	sw	a5,24(s1)
    8000172c:	b7e1                	j	800016f4 <wakeup+0x26>
    }
  }
}
    8000172e:	70a2                	ld	ra,40(sp)
    80001730:	7402                	ld	s0,32(sp)
    80001732:	64e2                	ld	s1,24(sp)
    80001734:	6942                	ld	s2,16(sp)
    80001736:	69a2                	ld	s3,8(sp)
    80001738:	6a02                	ld	s4,0(sp)
    8000173a:	6145                	addi	sp,sp,48
    8000173c:	8082                	ret

000000008000173e <reparent>:
{
    8000173e:	7179                	addi	sp,sp,-48
    80001740:	f406                	sd	ra,40(sp)
    80001742:	f022                	sd	s0,32(sp)
    80001744:	ec26                	sd	s1,24(sp)
    80001746:	e84a                	sd	s2,16(sp)
    80001748:	e44e                	sd	s3,8(sp)
    8000174a:	e052                	sd	s4,0(sp)
    8000174c:	1800                	addi	s0,sp,48
    8000174e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001750:	00008497          	auipc	s1,0x8
    80001754:	d3048493          	addi	s1,s1,-720 # 80009480 <proc>
      pp->parent = initproc;
    80001758:	00008a17          	auipc	s4,0x8
    8000175c:	8b8a0a13          	addi	s4,s4,-1864 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001760:	00009997          	auipc	s3,0x9
    80001764:	b3098993          	addi	s3,s3,-1232 # 8000a290 <tickslock>
    80001768:	a029                	j	80001772 <reparent+0x34>
    8000176a:	16848493          	addi	s1,s1,360
    8000176e:	01348d63          	beq	s1,s3,80001788 <reparent+0x4a>
    if(pp->parent == p){
    80001772:	7c9c                	ld	a5,56(s1)
    80001774:	ff279be3          	bne	a5,s2,8000176a <reparent+0x2c>
      pp->parent = initproc;
    80001778:	000a3503          	ld	a0,0(s4)
    8000177c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000177e:	00000097          	auipc	ra,0x0
    80001782:	f50080e7          	jalr	-176(ra) # 800016ce <wakeup>
    80001786:	b7d5                	j	8000176a <reparent+0x2c>
}
    80001788:	70a2                	ld	ra,40(sp)
    8000178a:	7402                	ld	s0,32(sp)
    8000178c:	64e2                	ld	s1,24(sp)
    8000178e:	6942                	ld	s2,16(sp)
    80001790:	69a2                	ld	s3,8(sp)
    80001792:	6a02                	ld	s4,0(sp)
    80001794:	6145                	addi	sp,sp,48
    80001796:	8082                	ret

0000000080001798 <exit>:
{
    80001798:	7179                	addi	sp,sp,-48
    8000179a:	f406                	sd	ra,40(sp)
    8000179c:	f022                	sd	s0,32(sp)
    8000179e:	ec26                	sd	s1,24(sp)
    800017a0:	e84a                	sd	s2,16(sp)
    800017a2:	e44e                	sd	s3,8(sp)
    800017a4:	e052                	sd	s4,0(sp)
    800017a6:	1800                	addi	s0,sp,48
    800017a8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017aa:	fffff097          	auipc	ra,0xfffff
    800017ae:	6d2080e7          	jalr	1746(ra) # 80000e7c <myproc>
    800017b2:	89aa                	mv	s3,a0
  if(p == initproc)
    800017b4:	00008797          	auipc	a5,0x8
    800017b8:	85c7b783          	ld	a5,-1956(a5) # 80009010 <initproc>
    800017bc:	0d050493          	addi	s1,a0,208
    800017c0:	15050913          	addi	s2,a0,336
    800017c4:	02a79363          	bne	a5,a0,800017ea <exit+0x52>
    panic("init exiting");
    800017c8:	00007517          	auipc	a0,0x7
    800017cc:	a1850513          	addi	a0,a0,-1512 # 800081e0 <etext+0x1e0>
    800017d0:	00004097          	auipc	ra,0x4
    800017d4:	73c080e7          	jalr	1852(ra) # 80005f0c <panic>
      fileclose(f);
    800017d8:	00002097          	auipc	ra,0x2
    800017dc:	2e8080e7          	jalr	744(ra) # 80003ac0 <fileclose>
      p->ofile[fd] = 0;
    800017e0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017e4:	04a1                	addi	s1,s1,8
    800017e6:	01248563          	beq	s1,s2,800017f0 <exit+0x58>
    if(p->ofile[fd]){
    800017ea:	6088                	ld	a0,0(s1)
    800017ec:	f575                	bnez	a0,800017d8 <exit+0x40>
    800017ee:	bfdd                	j	800017e4 <exit+0x4c>
  begin_op();
    800017f0:	00002097          	auipc	ra,0x2
    800017f4:	e06080e7          	jalr	-506(ra) # 800035f6 <begin_op>
  iput(p->cwd);
    800017f8:	1509b503          	ld	a0,336(s3)
    800017fc:	00001097          	auipc	ra,0x1
    80001800:	5e4080e7          	jalr	1508(ra) # 80002de0 <iput>
  end_op();
    80001804:	00002097          	auipc	ra,0x2
    80001808:	e6c080e7          	jalr	-404(ra) # 80003670 <end_op>
  p->cwd = 0;
    8000180c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001810:	00008497          	auipc	s1,0x8
    80001814:	85848493          	addi	s1,s1,-1960 # 80009068 <wait_lock>
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	c6c080e7          	jalr	-916(ra) # 80006486 <acquire>
  reparent(p);
    80001822:	854e                	mv	a0,s3
    80001824:	00000097          	auipc	ra,0x0
    80001828:	f1a080e7          	jalr	-230(ra) # 8000173e <reparent>
  wakeup(p->parent);
    8000182c:	0389b503          	ld	a0,56(s3)
    80001830:	00000097          	auipc	ra,0x0
    80001834:	e9e080e7          	jalr	-354(ra) # 800016ce <wakeup>
  acquire(&p->lock);
    80001838:	854e                	mv	a0,s3
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	c4c080e7          	jalr	-948(ra) # 80006486 <acquire>
  p->xstate = status;
    80001842:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001846:	4795                	li	a5,5
    80001848:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000184c:	8526                	mv	a0,s1
    8000184e:	00005097          	auipc	ra,0x5
    80001852:	cec080e7          	jalr	-788(ra) # 8000653a <release>
  sched();
    80001856:	00000097          	auipc	ra,0x0
    8000185a:	bda080e7          	jalr	-1062(ra) # 80001430 <sched>
  panic("zombie exit");
    8000185e:	00007517          	auipc	a0,0x7
    80001862:	99250513          	addi	a0,a0,-1646 # 800081f0 <etext+0x1f0>
    80001866:	00004097          	auipc	ra,0x4
    8000186a:	6a6080e7          	jalr	1702(ra) # 80005f0c <panic>

000000008000186e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000186e:	7179                	addi	sp,sp,-48
    80001870:	f406                	sd	ra,40(sp)
    80001872:	f022                	sd	s0,32(sp)
    80001874:	ec26                	sd	s1,24(sp)
    80001876:	e84a                	sd	s2,16(sp)
    80001878:	e44e                	sd	s3,8(sp)
    8000187a:	1800                	addi	s0,sp,48
    8000187c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000187e:	00008497          	auipc	s1,0x8
    80001882:	c0248493          	addi	s1,s1,-1022 # 80009480 <proc>
    80001886:	00009997          	auipc	s3,0x9
    8000188a:	a0a98993          	addi	s3,s3,-1526 # 8000a290 <tickslock>
    acquire(&p->lock);
    8000188e:	8526                	mv	a0,s1
    80001890:	00005097          	auipc	ra,0x5
    80001894:	bf6080e7          	jalr	-1034(ra) # 80006486 <acquire>
    if(p->pid == pid){
    80001898:	589c                	lw	a5,48(s1)
    8000189a:	03278363          	beq	a5,s2,800018c0 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	c9a080e7          	jalr	-870(ra) # 8000653a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018a8:	16848493          	addi	s1,s1,360
    800018ac:	ff3491e3          	bne	s1,s3,8000188e <kill+0x20>
  }
  return -1;
    800018b0:	557d                	li	a0,-1
}
    800018b2:	70a2                	ld	ra,40(sp)
    800018b4:	7402                	ld	s0,32(sp)
    800018b6:	64e2                	ld	s1,24(sp)
    800018b8:	6942                	ld	s2,16(sp)
    800018ba:	69a2                	ld	s3,8(sp)
    800018bc:	6145                	addi	sp,sp,48
    800018be:	8082                	ret
      p->killed = 1;
    800018c0:	4785                	li	a5,1
    800018c2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018c4:	4c98                	lw	a4,24(s1)
    800018c6:	4789                	li	a5,2
    800018c8:	00f70963          	beq	a4,a5,800018da <kill+0x6c>
      release(&p->lock);
    800018cc:	8526                	mv	a0,s1
    800018ce:	00005097          	auipc	ra,0x5
    800018d2:	c6c080e7          	jalr	-916(ra) # 8000653a <release>
      return 0;
    800018d6:	4501                	li	a0,0
    800018d8:	bfe9                	j	800018b2 <kill+0x44>
        p->state = RUNNABLE;
    800018da:	478d                	li	a5,3
    800018dc:	cc9c                	sw	a5,24(s1)
    800018de:	b7fd                	j	800018cc <kill+0x5e>

00000000800018e0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018e0:	7179                	addi	sp,sp,-48
    800018e2:	f406                	sd	ra,40(sp)
    800018e4:	f022                	sd	s0,32(sp)
    800018e6:	ec26                	sd	s1,24(sp)
    800018e8:	e84a                	sd	s2,16(sp)
    800018ea:	e44e                	sd	s3,8(sp)
    800018ec:	e052                	sd	s4,0(sp)
    800018ee:	1800                	addi	s0,sp,48
    800018f0:	84aa                	mv	s1,a0
    800018f2:	892e                	mv	s2,a1
    800018f4:	89b2                	mv	s3,a2
    800018f6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018f8:	fffff097          	auipc	ra,0xfffff
    800018fc:	584080e7          	jalr	1412(ra) # 80000e7c <myproc>
  if(user_dst){
    80001900:	c08d                	beqz	s1,80001922 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001902:	86d2                	mv	a3,s4
    80001904:	864e                	mv	a2,s3
    80001906:	85ca                	mv	a1,s2
    80001908:	6928                	ld	a0,80(a0)
    8000190a:	fffff097          	auipc	ra,0xfffff
    8000190e:	20e080e7          	jalr	526(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001912:	70a2                	ld	ra,40(sp)
    80001914:	7402                	ld	s0,32(sp)
    80001916:	64e2                	ld	s1,24(sp)
    80001918:	6942                	ld	s2,16(sp)
    8000191a:	69a2                	ld	s3,8(sp)
    8000191c:	6a02                	ld	s4,0(sp)
    8000191e:	6145                	addi	sp,sp,48
    80001920:	8082                	ret
    memmove((char *)dst, src, len);
    80001922:	000a061b          	sext.w	a2,s4
    80001926:	85ce                	mv	a1,s3
    80001928:	854a                	mv	a0,s2
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	8ac080e7          	jalr	-1876(ra) # 800001d6 <memmove>
    return 0;
    80001932:	8526                	mv	a0,s1
    80001934:	bff9                	j	80001912 <either_copyout+0x32>

0000000080001936 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001936:	7179                	addi	sp,sp,-48
    80001938:	f406                	sd	ra,40(sp)
    8000193a:	f022                	sd	s0,32(sp)
    8000193c:	ec26                	sd	s1,24(sp)
    8000193e:	e84a                	sd	s2,16(sp)
    80001940:	e44e                	sd	s3,8(sp)
    80001942:	e052                	sd	s4,0(sp)
    80001944:	1800                	addi	s0,sp,48
    80001946:	892a                	mv	s2,a0
    80001948:	84ae                	mv	s1,a1
    8000194a:	89b2                	mv	s3,a2
    8000194c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	52e080e7          	jalr	1326(ra) # 80000e7c <myproc>
  if(user_src){
    80001956:	c08d                	beqz	s1,80001978 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001958:	86d2                	mv	a3,s4
    8000195a:	864e                	mv	a2,s3
    8000195c:	85ca                	mv	a1,s2
    8000195e:	6928                	ld	a0,80(a0)
    80001960:	fffff097          	auipc	ra,0xfffff
    80001964:	244080e7          	jalr	580(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001968:	70a2                	ld	ra,40(sp)
    8000196a:	7402                	ld	s0,32(sp)
    8000196c:	64e2                	ld	s1,24(sp)
    8000196e:	6942                	ld	s2,16(sp)
    80001970:	69a2                	ld	s3,8(sp)
    80001972:	6a02                	ld	s4,0(sp)
    80001974:	6145                	addi	sp,sp,48
    80001976:	8082                	ret
    memmove(dst, (char*)src, len);
    80001978:	000a061b          	sext.w	a2,s4
    8000197c:	85ce                	mv	a1,s3
    8000197e:	854a                	mv	a0,s2
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	856080e7          	jalr	-1962(ra) # 800001d6 <memmove>
    return 0;
    80001988:	8526                	mv	a0,s1
    8000198a:	bff9                	j	80001968 <either_copyin+0x32>

000000008000198c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000198c:	715d                	addi	sp,sp,-80
    8000198e:	e486                	sd	ra,72(sp)
    80001990:	e0a2                	sd	s0,64(sp)
    80001992:	fc26                	sd	s1,56(sp)
    80001994:	f84a                	sd	s2,48(sp)
    80001996:	f44e                	sd	s3,40(sp)
    80001998:	f052                	sd	s4,32(sp)
    8000199a:	ec56                	sd	s5,24(sp)
    8000199c:	e85a                	sd	s6,16(sp)
    8000199e:	e45e                	sd	s7,8(sp)
    800019a0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019a2:	00006517          	auipc	a0,0x6
    800019a6:	67650513          	addi	a0,a0,1654 # 80008018 <etext+0x18>
    800019aa:	00004097          	auipc	ra,0x4
    800019ae:	5ac080e7          	jalr	1452(ra) # 80005f56 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b2:	00008497          	auipc	s1,0x8
    800019b6:	c2648493          	addi	s1,s1,-986 # 800095d8 <proc+0x158>
    800019ba:	00009917          	auipc	s2,0x9
    800019be:	a2e90913          	addi	s2,s2,-1490 # 8000a3e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019c2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019c4:	00007997          	auipc	s3,0x7
    800019c8:	83c98993          	addi	s3,s3,-1988 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019cc:	00007a97          	auipc	s5,0x7
    800019d0:	83ca8a93          	addi	s5,s5,-1988 # 80008208 <etext+0x208>
    printf("\n");
    800019d4:	00006a17          	auipc	s4,0x6
    800019d8:	644a0a13          	addi	s4,s4,1604 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019dc:	00007b97          	auipc	s7,0x7
    800019e0:	d24b8b93          	addi	s7,s7,-732 # 80008700 <states.0>
    800019e4:	a00d                	j	80001a06 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019e6:	ed86a583          	lw	a1,-296(a3)
    800019ea:	8556                	mv	a0,s5
    800019ec:	00004097          	auipc	ra,0x4
    800019f0:	56a080e7          	jalr	1386(ra) # 80005f56 <printf>
    printf("\n");
    800019f4:	8552                	mv	a0,s4
    800019f6:	00004097          	auipc	ra,0x4
    800019fa:	560080e7          	jalr	1376(ra) # 80005f56 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019fe:	16848493          	addi	s1,s1,360
    80001a02:	03248263          	beq	s1,s2,80001a26 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a06:	86a6                	mv	a3,s1
    80001a08:	ec04a783          	lw	a5,-320(s1)
    80001a0c:	dbed                	beqz	a5,800019fe <procdump+0x72>
      state = "???";
    80001a0e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a10:	fcfb6be3          	bltu	s6,a5,800019e6 <procdump+0x5a>
    80001a14:	02079713          	slli	a4,a5,0x20
    80001a18:	01d75793          	srli	a5,a4,0x1d
    80001a1c:	97de                	add	a5,a5,s7
    80001a1e:	6390                	ld	a2,0(a5)
    80001a20:	f279                	bnez	a2,800019e6 <procdump+0x5a>
      state = "???";
    80001a22:	864e                	mv	a2,s3
    80001a24:	b7c9                	j	800019e6 <procdump+0x5a>
  }
}
    80001a26:	60a6                	ld	ra,72(sp)
    80001a28:	6406                	ld	s0,64(sp)
    80001a2a:	74e2                	ld	s1,56(sp)
    80001a2c:	7942                	ld	s2,48(sp)
    80001a2e:	79a2                	ld	s3,40(sp)
    80001a30:	7a02                	ld	s4,32(sp)
    80001a32:	6ae2                	ld	s5,24(sp)
    80001a34:	6b42                	ld	s6,16(sp)
    80001a36:	6ba2                	ld	s7,8(sp)
    80001a38:	6161                	addi	sp,sp,80
    80001a3a:	8082                	ret

0000000080001a3c <swtch>:
    80001a3c:	00153023          	sd	ra,0(a0)
    80001a40:	00253423          	sd	sp,8(a0)
    80001a44:	e900                	sd	s0,16(a0)
    80001a46:	ed04                	sd	s1,24(a0)
    80001a48:	03253023          	sd	s2,32(a0)
    80001a4c:	03353423          	sd	s3,40(a0)
    80001a50:	03453823          	sd	s4,48(a0)
    80001a54:	03553c23          	sd	s5,56(a0)
    80001a58:	05653023          	sd	s6,64(a0)
    80001a5c:	05753423          	sd	s7,72(a0)
    80001a60:	05853823          	sd	s8,80(a0)
    80001a64:	05953c23          	sd	s9,88(a0)
    80001a68:	07a53023          	sd	s10,96(a0)
    80001a6c:	07b53423          	sd	s11,104(a0)
    80001a70:	0005b083          	ld	ra,0(a1)
    80001a74:	0085b103          	ld	sp,8(a1)
    80001a78:	6980                	ld	s0,16(a1)
    80001a7a:	6d84                	ld	s1,24(a1)
    80001a7c:	0205b903          	ld	s2,32(a1)
    80001a80:	0285b983          	ld	s3,40(a1)
    80001a84:	0305ba03          	ld	s4,48(a1)
    80001a88:	0385ba83          	ld	s5,56(a1)
    80001a8c:	0405bb03          	ld	s6,64(a1)
    80001a90:	0485bb83          	ld	s7,72(a1)
    80001a94:	0505bc03          	ld	s8,80(a1)
    80001a98:	0585bc83          	ld	s9,88(a1)
    80001a9c:	0605bd03          	ld	s10,96(a1)
    80001aa0:	0685bd83          	ld	s11,104(a1)
    80001aa4:	8082                	ret

0000000080001aa6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001aa6:	1141                	addi	sp,sp,-16
    80001aa8:	e406                	sd	ra,8(sp)
    80001aaa:	e022                	sd	s0,0(sp)
    80001aac:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001aae:	00006597          	auipc	a1,0x6
    80001ab2:	79258593          	addi	a1,a1,1938 # 80008240 <etext+0x240>
    80001ab6:	00008517          	auipc	a0,0x8
    80001aba:	7da50513          	addi	a0,a0,2010 # 8000a290 <tickslock>
    80001abe:	00005097          	auipc	ra,0x5
    80001ac2:	938080e7          	jalr	-1736(ra) # 800063f6 <initlock>
}
    80001ac6:	60a2                	ld	ra,8(sp)
    80001ac8:	6402                	ld	s0,0(sp)
    80001aca:	0141                	addi	sp,sp,16
    80001acc:	8082                	ret

0000000080001ace <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ace:	1141                	addi	sp,sp,-16
    80001ad0:	e422                	sd	s0,8(sp)
    80001ad2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ad4:	00004797          	auipc	a5,0x4
    80001ad8:	84c78793          	addi	a5,a5,-1972 # 80005320 <kernelvec>
    80001adc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ae0:	6422                	ld	s0,8(sp)
    80001ae2:	0141                	addi	sp,sp,16
    80001ae4:	8082                	ret

0000000080001ae6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ae6:	1141                	addi	sp,sp,-16
    80001ae8:	e406                	sd	ra,8(sp)
    80001aea:	e022                	sd	s0,0(sp)
    80001aec:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001aee:	fffff097          	auipc	ra,0xfffff
    80001af2:	38e080e7          	jalr	910(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001af6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001afa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001afc:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b00:	00005697          	auipc	a3,0x5
    80001b04:	50068693          	addi	a3,a3,1280 # 80007000 <_trampoline>
    80001b08:	00005717          	auipc	a4,0x5
    80001b0c:	4f870713          	addi	a4,a4,1272 # 80007000 <_trampoline>
    80001b10:	8f15                	sub	a4,a4,a3
    80001b12:	040007b7          	lui	a5,0x4000
    80001b16:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b18:	07b2                	slli	a5,a5,0xc
    80001b1a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b1c:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b20:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b22:	18002673          	csrr	a2,satp
    80001b26:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b28:	6d30                	ld	a2,88(a0)
    80001b2a:	6138                	ld	a4,64(a0)
    80001b2c:	6585                	lui	a1,0x1
    80001b2e:	972e                	add	a4,a4,a1
    80001b30:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b32:	6d38                	ld	a4,88(a0)
    80001b34:	00000617          	auipc	a2,0x0
    80001b38:	14060613          	addi	a2,a2,320 # 80001c74 <usertrap>
    80001b3c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b3e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b40:	8612                	mv	a2,tp
    80001b42:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b44:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b48:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b4c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b50:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b54:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b56:	6f18                	ld	a4,24(a4)
    80001b58:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b5c:	692c                	ld	a1,80(a0)
    80001b5e:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b60:	00005717          	auipc	a4,0x5
    80001b64:	53070713          	addi	a4,a4,1328 # 80007090 <userret>
    80001b68:	8f15                	sub	a4,a4,a3
    80001b6a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b6c:	577d                	li	a4,-1
    80001b6e:	177e                	slli	a4,a4,0x3f
    80001b70:	8dd9                	or	a1,a1,a4
    80001b72:	02000537          	lui	a0,0x2000
    80001b76:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b78:	0536                	slli	a0,a0,0xd
    80001b7a:	9782                	jalr	a5
}
    80001b7c:	60a2                	ld	ra,8(sp)
    80001b7e:	6402                	ld	s0,0(sp)
    80001b80:	0141                	addi	sp,sp,16
    80001b82:	8082                	ret

0000000080001b84 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b84:	1101                	addi	sp,sp,-32
    80001b86:	ec06                	sd	ra,24(sp)
    80001b88:	e822                	sd	s0,16(sp)
    80001b8a:	e426                	sd	s1,8(sp)
    80001b8c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b8e:	00008497          	auipc	s1,0x8
    80001b92:	70248493          	addi	s1,s1,1794 # 8000a290 <tickslock>
    80001b96:	8526                	mv	a0,s1
    80001b98:	00005097          	auipc	ra,0x5
    80001b9c:	8ee080e7          	jalr	-1810(ra) # 80006486 <acquire>
  ticks++;
    80001ba0:	00007517          	auipc	a0,0x7
    80001ba4:	47850513          	addi	a0,a0,1144 # 80009018 <ticks>
    80001ba8:	411c                	lw	a5,0(a0)
    80001baa:	2785                	addiw	a5,a5,1
    80001bac:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	b20080e7          	jalr	-1248(ra) # 800016ce <wakeup>
  release(&tickslock);
    80001bb6:	8526                	mv	a0,s1
    80001bb8:	00005097          	auipc	ra,0x5
    80001bbc:	982080e7          	jalr	-1662(ra) # 8000653a <release>
}
    80001bc0:	60e2                	ld	ra,24(sp)
    80001bc2:	6442                	ld	s0,16(sp)
    80001bc4:	64a2                	ld	s1,8(sp)
    80001bc6:	6105                	addi	sp,sp,32
    80001bc8:	8082                	ret

0000000080001bca <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bca:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bce:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001bd0:	0a07d163          	bgez	a5,80001c72 <devintr+0xa8>
{
    80001bd4:	1101                	addi	sp,sp,-32
    80001bd6:	ec06                	sd	ra,24(sp)
    80001bd8:	e822                	sd	s0,16(sp)
    80001bda:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001bdc:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001be0:	46a5                	li	a3,9
    80001be2:	00d70c63          	beq	a4,a3,80001bfa <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001be6:	577d                	li	a4,-1
    80001be8:	177e                	slli	a4,a4,0x3f
    80001bea:	0705                	addi	a4,a4,1
    return 0;
    80001bec:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bee:	06e78163          	beq	a5,a4,80001c50 <devintr+0x86>
  }
}
    80001bf2:	60e2                	ld	ra,24(sp)
    80001bf4:	6442                	ld	s0,16(sp)
    80001bf6:	6105                	addi	sp,sp,32
    80001bf8:	8082                	ret
    80001bfa:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001bfc:	00004097          	auipc	ra,0x4
    80001c00:	830080e7          	jalr	-2000(ra) # 8000542c <plic_claim>
    80001c04:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c06:	47a9                	li	a5,10
    80001c08:	00f50963          	beq	a0,a5,80001c1a <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c0c:	4785                	li	a5,1
    80001c0e:	00f50b63          	beq	a0,a5,80001c24 <devintr+0x5a>
    return 1;
    80001c12:	4505                	li	a0,1
    } else if(irq){
    80001c14:	ec89                	bnez	s1,80001c2e <devintr+0x64>
    80001c16:	64a2                	ld	s1,8(sp)
    80001c18:	bfe9                	j	80001bf2 <devintr+0x28>
      uartintr();
    80001c1a:	00004097          	auipc	ra,0x4
    80001c1e:	78c080e7          	jalr	1932(ra) # 800063a6 <uartintr>
    if(irq)
    80001c22:	a839                	j	80001c40 <devintr+0x76>
      virtio_disk_intr();
    80001c24:	00004097          	auipc	ra,0x4
    80001c28:	cdc080e7          	jalr	-804(ra) # 80005900 <virtio_disk_intr>
    if(irq)
    80001c2c:	a811                	j	80001c40 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c2e:	85a6                	mv	a1,s1
    80001c30:	00006517          	auipc	a0,0x6
    80001c34:	61850513          	addi	a0,a0,1560 # 80008248 <etext+0x248>
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	31e080e7          	jalr	798(ra) # 80005f56 <printf>
      plic_complete(irq);
    80001c40:	8526                	mv	a0,s1
    80001c42:	00004097          	auipc	ra,0x4
    80001c46:	80e080e7          	jalr	-2034(ra) # 80005450 <plic_complete>
    return 1;
    80001c4a:	4505                	li	a0,1
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	b755                	j	80001bf2 <devintr+0x28>
    if(cpuid() == 0){
    80001c50:	fffff097          	auipc	ra,0xfffff
    80001c54:	200080e7          	jalr	512(ra) # 80000e50 <cpuid>
    80001c58:	c901                	beqz	a0,80001c68 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c5a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c5e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c60:	14479073          	csrw	sip,a5
    return 2;
    80001c64:	4509                	li	a0,2
    80001c66:	b771                	j	80001bf2 <devintr+0x28>
      clockintr();
    80001c68:	00000097          	auipc	ra,0x0
    80001c6c:	f1c080e7          	jalr	-228(ra) # 80001b84 <clockintr>
    80001c70:	b7ed                	j	80001c5a <devintr+0x90>
}
    80001c72:	8082                	ret

0000000080001c74 <usertrap>:
{
    80001c74:	1101                	addi	sp,sp,-32
    80001c76:	ec06                	sd	ra,24(sp)
    80001c78:	e822                	sd	s0,16(sp)
    80001c7a:	e426                	sd	s1,8(sp)
    80001c7c:	e04a                	sd	s2,0(sp)
    80001c7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c80:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c84:	1007f793          	andi	a5,a5,256
    80001c88:	e3ad                	bnez	a5,80001cea <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c8a:	00003797          	auipc	a5,0x3
    80001c8e:	69678793          	addi	a5,a5,1686 # 80005320 <kernelvec>
    80001c92:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c96:	fffff097          	auipc	ra,0xfffff
    80001c9a:	1e6080e7          	jalr	486(ra) # 80000e7c <myproc>
    80001c9e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ca0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ca2:	14102773          	csrr	a4,sepc
    80001ca6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cac:	47a1                	li	a5,8
    80001cae:	04f71c63          	bne	a4,a5,80001d06 <usertrap+0x92>
    if(p->killed)
    80001cb2:	551c                	lw	a5,40(a0)
    80001cb4:	e3b9                	bnez	a5,80001cfa <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cb6:	6cb8                	ld	a4,88(s1)
    80001cb8:	6f1c                	ld	a5,24(a4)
    80001cba:	0791                	addi	a5,a5,4
    80001cbc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cbe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cc2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cc6:	10079073          	csrw	sstatus,a5
    syscall();
    80001cca:	00000097          	auipc	ra,0x0
    80001cce:	2e0080e7          	jalr	736(ra) # 80001faa <syscall>
  if(p->killed)
    80001cd2:	549c                	lw	a5,40(s1)
    80001cd4:	ebc1                	bnez	a5,80001d64 <usertrap+0xf0>
  usertrapret();
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	e10080e7          	jalr	-496(ra) # 80001ae6 <usertrapret>
}
    80001cde:	60e2                	ld	ra,24(sp)
    80001ce0:	6442                	ld	s0,16(sp)
    80001ce2:	64a2                	ld	s1,8(sp)
    80001ce4:	6902                	ld	s2,0(sp)
    80001ce6:	6105                	addi	sp,sp,32
    80001ce8:	8082                	ret
    panic("usertrap: not from user mode");
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	57e50513          	addi	a0,a0,1406 # 80008268 <etext+0x268>
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	21a080e7          	jalr	538(ra) # 80005f0c <panic>
      exit(-1);
    80001cfa:	557d                	li	a0,-1
    80001cfc:	00000097          	auipc	ra,0x0
    80001d00:	a9c080e7          	jalr	-1380(ra) # 80001798 <exit>
    80001d04:	bf4d                	j	80001cb6 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d06:	00000097          	auipc	ra,0x0
    80001d0a:	ec4080e7          	jalr	-316(ra) # 80001bca <devintr>
    80001d0e:	892a                	mv	s2,a0
    80001d10:	c501                	beqz	a0,80001d18 <usertrap+0xa4>
  if(p->killed)
    80001d12:	549c                	lw	a5,40(s1)
    80001d14:	c3a1                	beqz	a5,80001d54 <usertrap+0xe0>
    80001d16:	a815                	j	80001d4a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d18:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d1c:	5890                	lw	a2,48(s1)
    80001d1e:	00006517          	auipc	a0,0x6
    80001d22:	56a50513          	addi	a0,a0,1386 # 80008288 <etext+0x288>
    80001d26:	00004097          	auipc	ra,0x4
    80001d2a:	230080e7          	jalr	560(ra) # 80005f56 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d2e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d32:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d36:	00006517          	auipc	a0,0x6
    80001d3a:	58250513          	addi	a0,a0,1410 # 800082b8 <etext+0x2b8>
    80001d3e:	00004097          	auipc	ra,0x4
    80001d42:	218080e7          	jalr	536(ra) # 80005f56 <printf>
    p->killed = 1;
    80001d46:	4785                	li	a5,1
    80001d48:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d4a:	557d                	li	a0,-1
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	a4c080e7          	jalr	-1460(ra) # 80001798 <exit>
  if(which_dev == 2)
    80001d54:	4789                	li	a5,2
    80001d56:	f8f910e3          	bne	s2,a5,80001cd6 <usertrap+0x62>
    yield();
    80001d5a:	fffff097          	auipc	ra,0xfffff
    80001d5e:	7ac080e7          	jalr	1964(ra) # 80001506 <yield>
    80001d62:	bf95                	j	80001cd6 <usertrap+0x62>
  int which_dev = 0;
    80001d64:	4901                	li	s2,0
    80001d66:	b7d5                	j	80001d4a <usertrap+0xd6>

0000000080001d68 <kerneltrap>:
{
    80001d68:	7179                	addi	sp,sp,-48
    80001d6a:	f406                	sd	ra,40(sp)
    80001d6c:	f022                	sd	s0,32(sp)
    80001d6e:	ec26                	sd	s1,24(sp)
    80001d70:	e84a                	sd	s2,16(sp)
    80001d72:	e44e                	sd	s3,8(sp)
    80001d74:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d76:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d7a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d82:	1004f793          	andi	a5,s1,256
    80001d86:	cb85                	beqz	a5,80001db6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d88:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d8c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d8e:	ef85                	bnez	a5,80001dc6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d90:	00000097          	auipc	ra,0x0
    80001d94:	e3a080e7          	jalr	-454(ra) # 80001bca <devintr>
    80001d98:	cd1d                	beqz	a0,80001dd6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d9a:	4789                	li	a5,2
    80001d9c:	06f50a63          	beq	a0,a5,80001e10 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001da0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001da4:	10049073          	csrw	sstatus,s1
}
    80001da8:	70a2                	ld	ra,40(sp)
    80001daa:	7402                	ld	s0,32(sp)
    80001dac:	64e2                	ld	s1,24(sp)
    80001dae:	6942                	ld	s2,16(sp)
    80001db0:	69a2                	ld	s3,8(sp)
    80001db2:	6145                	addi	sp,sp,48
    80001db4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001db6:	00006517          	auipc	a0,0x6
    80001dba:	52250513          	addi	a0,a0,1314 # 800082d8 <etext+0x2d8>
    80001dbe:	00004097          	auipc	ra,0x4
    80001dc2:	14e080e7          	jalr	334(ra) # 80005f0c <panic>
    panic("kerneltrap: interrupts enabled");
    80001dc6:	00006517          	auipc	a0,0x6
    80001dca:	53a50513          	addi	a0,a0,1338 # 80008300 <etext+0x300>
    80001dce:	00004097          	auipc	ra,0x4
    80001dd2:	13e080e7          	jalr	318(ra) # 80005f0c <panic>
    printf("scause %p\n", scause);
    80001dd6:	85ce                	mv	a1,s3
    80001dd8:	00006517          	auipc	a0,0x6
    80001ddc:	54850513          	addi	a0,a0,1352 # 80008320 <etext+0x320>
    80001de0:	00004097          	auipc	ra,0x4
    80001de4:	176080e7          	jalr	374(ra) # 80005f56 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dec:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	54050513          	addi	a0,a0,1344 # 80008330 <etext+0x330>
    80001df8:	00004097          	auipc	ra,0x4
    80001dfc:	15e080e7          	jalr	350(ra) # 80005f56 <printf>
    panic("kerneltrap");
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	54850513          	addi	a0,a0,1352 # 80008348 <etext+0x348>
    80001e08:	00004097          	auipc	ra,0x4
    80001e0c:	104080e7          	jalr	260(ra) # 80005f0c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e10:	fffff097          	auipc	ra,0xfffff
    80001e14:	06c080e7          	jalr	108(ra) # 80000e7c <myproc>
    80001e18:	d541                	beqz	a0,80001da0 <kerneltrap+0x38>
    80001e1a:	fffff097          	auipc	ra,0xfffff
    80001e1e:	062080e7          	jalr	98(ra) # 80000e7c <myproc>
    80001e22:	4d18                	lw	a4,24(a0)
    80001e24:	4791                	li	a5,4
    80001e26:	f6f71de3          	bne	a4,a5,80001da0 <kerneltrap+0x38>
    yield();
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	6dc080e7          	jalr	1756(ra) # 80001506 <yield>
    80001e32:	b7bd                	j	80001da0 <kerneltrap+0x38>

0000000080001e34 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e34:	1101                	addi	sp,sp,-32
    80001e36:	ec06                	sd	ra,24(sp)
    80001e38:	e822                	sd	s0,16(sp)
    80001e3a:	e426                	sd	s1,8(sp)
    80001e3c:	1000                	addi	s0,sp,32
    80001e3e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e40:	fffff097          	auipc	ra,0xfffff
    80001e44:	03c080e7          	jalr	60(ra) # 80000e7c <myproc>
  switch (n) {
    80001e48:	4795                	li	a5,5
    80001e4a:	0497e163          	bltu	a5,s1,80001e8c <argraw+0x58>
    80001e4e:	048a                	slli	s1,s1,0x2
    80001e50:	00007717          	auipc	a4,0x7
    80001e54:	8e070713          	addi	a4,a4,-1824 # 80008730 <states.0+0x30>
    80001e58:	94ba                	add	s1,s1,a4
    80001e5a:	409c                	lw	a5,0(s1)
    80001e5c:	97ba                	add	a5,a5,a4
    80001e5e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e60:	6d3c                	ld	a5,88(a0)
    80001e62:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e64:	60e2                	ld	ra,24(sp)
    80001e66:	6442                	ld	s0,16(sp)
    80001e68:	64a2                	ld	s1,8(sp)
    80001e6a:	6105                	addi	sp,sp,32
    80001e6c:	8082                	ret
    return p->trapframe->a1;
    80001e6e:	6d3c                	ld	a5,88(a0)
    80001e70:	7fa8                	ld	a0,120(a5)
    80001e72:	bfcd                	j	80001e64 <argraw+0x30>
    return p->trapframe->a2;
    80001e74:	6d3c                	ld	a5,88(a0)
    80001e76:	63c8                	ld	a0,128(a5)
    80001e78:	b7f5                	j	80001e64 <argraw+0x30>
    return p->trapframe->a3;
    80001e7a:	6d3c                	ld	a5,88(a0)
    80001e7c:	67c8                	ld	a0,136(a5)
    80001e7e:	b7dd                	j	80001e64 <argraw+0x30>
    return p->trapframe->a4;
    80001e80:	6d3c                	ld	a5,88(a0)
    80001e82:	6bc8                	ld	a0,144(a5)
    80001e84:	b7c5                	j	80001e64 <argraw+0x30>
    return p->trapframe->a5;
    80001e86:	6d3c                	ld	a5,88(a0)
    80001e88:	6fc8                	ld	a0,152(a5)
    80001e8a:	bfe9                	j	80001e64 <argraw+0x30>
  panic("argraw");
    80001e8c:	00006517          	auipc	a0,0x6
    80001e90:	4cc50513          	addi	a0,a0,1228 # 80008358 <etext+0x358>
    80001e94:	00004097          	auipc	ra,0x4
    80001e98:	078080e7          	jalr	120(ra) # 80005f0c <panic>

0000000080001e9c <fetchaddr>:
{
    80001e9c:	1101                	addi	sp,sp,-32
    80001e9e:	ec06                	sd	ra,24(sp)
    80001ea0:	e822                	sd	s0,16(sp)
    80001ea2:	e426                	sd	s1,8(sp)
    80001ea4:	e04a                	sd	s2,0(sp)
    80001ea6:	1000                	addi	s0,sp,32
    80001ea8:	84aa                	mv	s1,a0
    80001eaa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	fd0080e7          	jalr	-48(ra) # 80000e7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001eb4:	653c                	ld	a5,72(a0)
    80001eb6:	02f4f863          	bgeu	s1,a5,80001ee6 <fetchaddr+0x4a>
    80001eba:	00848713          	addi	a4,s1,8
    80001ebe:	02e7e663          	bltu	a5,a4,80001eea <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ec2:	46a1                	li	a3,8
    80001ec4:	8626                	mv	a2,s1
    80001ec6:	85ca                	mv	a1,s2
    80001ec8:	6928                	ld	a0,80(a0)
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	cda080e7          	jalr	-806(ra) # 80000ba4 <copyin>
    80001ed2:	00a03533          	snez	a0,a0
    80001ed6:	40a00533          	neg	a0,a0
}
    80001eda:	60e2                	ld	ra,24(sp)
    80001edc:	6442                	ld	s0,16(sp)
    80001ede:	64a2                	ld	s1,8(sp)
    80001ee0:	6902                	ld	s2,0(sp)
    80001ee2:	6105                	addi	sp,sp,32
    80001ee4:	8082                	ret
    return -1;
    80001ee6:	557d                	li	a0,-1
    80001ee8:	bfcd                	j	80001eda <fetchaddr+0x3e>
    80001eea:	557d                	li	a0,-1
    80001eec:	b7fd                	j	80001eda <fetchaddr+0x3e>

0000000080001eee <fetchstr>:
{
    80001eee:	7179                	addi	sp,sp,-48
    80001ef0:	f406                	sd	ra,40(sp)
    80001ef2:	f022                	sd	s0,32(sp)
    80001ef4:	ec26                	sd	s1,24(sp)
    80001ef6:	e84a                	sd	s2,16(sp)
    80001ef8:	e44e                	sd	s3,8(sp)
    80001efa:	1800                	addi	s0,sp,48
    80001efc:	892a                	mv	s2,a0
    80001efe:	84ae                	mv	s1,a1
    80001f00:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	f7a080e7          	jalr	-134(ra) # 80000e7c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f0a:	86ce                	mv	a3,s3
    80001f0c:	864a                	mv	a2,s2
    80001f0e:	85a6                	mv	a1,s1
    80001f10:	6928                	ld	a0,80(a0)
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	d20080e7          	jalr	-736(ra) # 80000c32 <copyinstr>
  if(err < 0)
    80001f1a:	00054763          	bltz	a0,80001f28 <fetchstr+0x3a>
  return strlen(buf);
    80001f1e:	8526                	mv	a0,s1
    80001f20:	ffffe097          	auipc	ra,0xffffe
    80001f24:	3ce080e7          	jalr	974(ra) # 800002ee <strlen>
}
    80001f28:	70a2                	ld	ra,40(sp)
    80001f2a:	7402                	ld	s0,32(sp)
    80001f2c:	64e2                	ld	s1,24(sp)
    80001f2e:	6942                	ld	s2,16(sp)
    80001f30:	69a2                	ld	s3,8(sp)
    80001f32:	6145                	addi	sp,sp,48
    80001f34:	8082                	ret

0000000080001f36 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f36:	1101                	addi	sp,sp,-32
    80001f38:	ec06                	sd	ra,24(sp)
    80001f3a:	e822                	sd	s0,16(sp)
    80001f3c:	e426                	sd	s1,8(sp)
    80001f3e:	1000                	addi	s0,sp,32
    80001f40:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f42:	00000097          	auipc	ra,0x0
    80001f46:	ef2080e7          	jalr	-270(ra) # 80001e34 <argraw>
    80001f4a:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f4c:	4501                	li	a0,0
    80001f4e:	60e2                	ld	ra,24(sp)
    80001f50:	6442                	ld	s0,16(sp)
    80001f52:	64a2                	ld	s1,8(sp)
    80001f54:	6105                	addi	sp,sp,32
    80001f56:	8082                	ret

0000000080001f58 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f58:	1101                	addi	sp,sp,-32
    80001f5a:	ec06                	sd	ra,24(sp)
    80001f5c:	e822                	sd	s0,16(sp)
    80001f5e:	e426                	sd	s1,8(sp)
    80001f60:	1000                	addi	s0,sp,32
    80001f62:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f64:	00000097          	auipc	ra,0x0
    80001f68:	ed0080e7          	jalr	-304(ra) # 80001e34 <argraw>
    80001f6c:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f6e:	4501                	li	a0,0
    80001f70:	60e2                	ld	ra,24(sp)
    80001f72:	6442                	ld	s0,16(sp)
    80001f74:	64a2                	ld	s1,8(sp)
    80001f76:	6105                	addi	sp,sp,32
    80001f78:	8082                	ret

0000000080001f7a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f7a:	1101                	addi	sp,sp,-32
    80001f7c:	ec06                	sd	ra,24(sp)
    80001f7e:	e822                	sd	s0,16(sp)
    80001f80:	e426                	sd	s1,8(sp)
    80001f82:	e04a                	sd	s2,0(sp)
    80001f84:	1000                	addi	s0,sp,32
    80001f86:	84ae                	mv	s1,a1
    80001f88:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f8a:	00000097          	auipc	ra,0x0
    80001f8e:	eaa080e7          	jalr	-342(ra) # 80001e34 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f92:	864a                	mv	a2,s2
    80001f94:	85a6                	mv	a1,s1
    80001f96:	00000097          	auipc	ra,0x0
    80001f9a:	f58080e7          	jalr	-168(ra) # 80001eee <fetchstr>
}
    80001f9e:	60e2                	ld	ra,24(sp)
    80001fa0:	6442                	ld	s0,16(sp)
    80001fa2:	64a2                	ld	s1,8(sp)
    80001fa4:	6902                	ld	s2,0(sp)
    80001fa6:	6105                	addi	sp,sp,32
    80001fa8:	8082                	ret

0000000080001faa <syscall>:
[SYS_symlink]   sys_symlink,
};

void
syscall(void)
{
    80001faa:	1101                	addi	sp,sp,-32
    80001fac:	ec06                	sd	ra,24(sp)
    80001fae:	e822                	sd	s0,16(sp)
    80001fb0:	e426                	sd	s1,8(sp)
    80001fb2:	e04a                	sd	s2,0(sp)
    80001fb4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	ec6080e7          	jalr	-314(ra) # 80000e7c <myproc>
    80001fbe:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fc0:	05853903          	ld	s2,88(a0)
    80001fc4:	0a893783          	ld	a5,168(s2)
    80001fc8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fcc:	37fd                	addiw	a5,a5,-1
    80001fce:	4755                	li	a4,21
    80001fd0:	00f76f63          	bltu	a4,a5,80001fee <syscall+0x44>
    80001fd4:	00369713          	slli	a4,a3,0x3
    80001fd8:	00006797          	auipc	a5,0x6
    80001fdc:	77078793          	addi	a5,a5,1904 # 80008748 <syscalls>
    80001fe0:	97ba                	add	a5,a5,a4
    80001fe2:	639c                	ld	a5,0(a5)
    80001fe4:	c789                	beqz	a5,80001fee <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fe6:	9782                	jalr	a5
    80001fe8:	06a93823          	sd	a0,112(s2)
    80001fec:	a839                	j	8000200a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fee:	15848613          	addi	a2,s1,344
    80001ff2:	588c                	lw	a1,48(s1)
    80001ff4:	00006517          	auipc	a0,0x6
    80001ff8:	36c50513          	addi	a0,a0,876 # 80008360 <etext+0x360>
    80001ffc:	00004097          	auipc	ra,0x4
    80002000:	f5a080e7          	jalr	-166(ra) # 80005f56 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002004:	6cbc                	ld	a5,88(s1)
    80002006:	577d                	li	a4,-1
    80002008:	fbb8                	sd	a4,112(a5)
  }
}
    8000200a:	60e2                	ld	ra,24(sp)
    8000200c:	6442                	ld	s0,16(sp)
    8000200e:	64a2                	ld	s1,8(sp)
    80002010:	6902                	ld	s2,0(sp)
    80002012:	6105                	addi	sp,sp,32
    80002014:	8082                	ret

0000000080002016 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000201e:	fec40593          	addi	a1,s0,-20
    80002022:	4501                	li	a0,0
    80002024:	00000097          	auipc	ra,0x0
    80002028:	f12080e7          	jalr	-238(ra) # 80001f36 <argint>
    return -1;
    8000202c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000202e:	00054963          	bltz	a0,80002040 <sys_exit+0x2a>
  exit(n);
    80002032:	fec42503          	lw	a0,-20(s0)
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	762080e7          	jalr	1890(ra) # 80001798 <exit>
  return 0;  // not reached
    8000203e:	4781                	li	a5,0
}
    80002040:	853e                	mv	a0,a5
    80002042:	60e2                	ld	ra,24(sp)
    80002044:	6442                	ld	s0,16(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000204a:	1141                	addi	sp,sp,-16
    8000204c:	e406                	sd	ra,8(sp)
    8000204e:	e022                	sd	s0,0(sp)
    80002050:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	e2a080e7          	jalr	-470(ra) # 80000e7c <myproc>
}
    8000205a:	5908                	lw	a0,48(a0)
    8000205c:	60a2                	ld	ra,8(sp)
    8000205e:	6402                	ld	s0,0(sp)
    80002060:	0141                	addi	sp,sp,16
    80002062:	8082                	ret

0000000080002064 <sys_fork>:

uint64
sys_fork(void)
{
    80002064:	1141                	addi	sp,sp,-16
    80002066:	e406                	sd	ra,8(sp)
    80002068:	e022                	sd	s0,0(sp)
    8000206a:	0800                	addi	s0,sp,16
  return fork();
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	1e2080e7          	jalr	482(ra) # 8000124e <fork>
}
    80002074:	60a2                	ld	ra,8(sp)
    80002076:	6402                	ld	s0,0(sp)
    80002078:	0141                	addi	sp,sp,16
    8000207a:	8082                	ret

000000008000207c <sys_wait>:

uint64
sys_wait(void)
{
    8000207c:	1101                	addi	sp,sp,-32
    8000207e:	ec06                	sd	ra,24(sp)
    80002080:	e822                	sd	s0,16(sp)
    80002082:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002084:	fe840593          	addi	a1,s0,-24
    80002088:	4501                	li	a0,0
    8000208a:	00000097          	auipc	ra,0x0
    8000208e:	ece080e7          	jalr	-306(ra) # 80001f58 <argaddr>
    80002092:	87aa                	mv	a5,a0
    return -1;
    80002094:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002096:	0007c863          	bltz	a5,800020a6 <sys_wait+0x2a>
  return wait(p);
    8000209a:	fe843503          	ld	a0,-24(s0)
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	508080e7          	jalr	1288(ra) # 800015a6 <wait>
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	6105                	addi	sp,sp,32
    800020ac:	8082                	ret

00000000800020ae <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020ae:	7179                	addi	sp,sp,-48
    800020b0:	f406                	sd	ra,40(sp)
    800020b2:	f022                	sd	s0,32(sp)
    800020b4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020b6:	fdc40593          	addi	a1,s0,-36
    800020ba:	4501                	li	a0,0
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	e7a080e7          	jalr	-390(ra) # 80001f36 <argint>
    800020c4:	87aa                	mv	a5,a0
    return -1;
    800020c6:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020c8:	0207c263          	bltz	a5,800020ec <sys_sbrk+0x3e>
    800020cc:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	dae080e7          	jalr	-594(ra) # 80000e7c <myproc>
    800020d6:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800020d8:	fdc42503          	lw	a0,-36(s0)
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	0fa080e7          	jalr	250(ra) # 800011d6 <growproc>
    800020e4:	00054863          	bltz	a0,800020f4 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020e8:	8526                	mv	a0,s1
    800020ea:	64e2                	ld	s1,24(sp)
}
    800020ec:	70a2                	ld	ra,40(sp)
    800020ee:	7402                	ld	s0,32(sp)
    800020f0:	6145                	addi	sp,sp,48
    800020f2:	8082                	ret
    return -1;
    800020f4:	557d                	li	a0,-1
    800020f6:	64e2                	ld	s1,24(sp)
    800020f8:	bfd5                	j	800020ec <sys_sbrk+0x3e>

00000000800020fa <sys_sleep>:

uint64
sys_sleep(void)
{
    800020fa:	7139                	addi	sp,sp,-64
    800020fc:	fc06                	sd	ra,56(sp)
    800020fe:	f822                	sd	s0,48(sp)
    80002100:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002102:	fcc40593          	addi	a1,s0,-52
    80002106:	4501                	li	a0,0
    80002108:	00000097          	auipc	ra,0x0
    8000210c:	e2e080e7          	jalr	-466(ra) # 80001f36 <argint>
    return -1;
    80002110:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002112:	06054b63          	bltz	a0,80002188 <sys_sleep+0x8e>
    80002116:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002118:	00008517          	auipc	a0,0x8
    8000211c:	17850513          	addi	a0,a0,376 # 8000a290 <tickslock>
    80002120:	00004097          	auipc	ra,0x4
    80002124:	366080e7          	jalr	870(ra) # 80006486 <acquire>
  ticks0 = ticks;
    80002128:	00007917          	auipc	s2,0x7
    8000212c:	ef092903          	lw	s2,-272(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002130:	fcc42783          	lw	a5,-52(s0)
    80002134:	c3a1                	beqz	a5,80002174 <sys_sleep+0x7a>
    80002136:	f426                	sd	s1,40(sp)
    80002138:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000213a:	00008997          	auipc	s3,0x8
    8000213e:	15698993          	addi	s3,s3,342 # 8000a290 <tickslock>
    80002142:	00007497          	auipc	s1,0x7
    80002146:	ed648493          	addi	s1,s1,-298 # 80009018 <ticks>
    if(myproc()->killed){
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	d32080e7          	jalr	-718(ra) # 80000e7c <myproc>
    80002152:	551c                	lw	a5,40(a0)
    80002154:	ef9d                	bnez	a5,80002192 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002156:	85ce                	mv	a1,s3
    80002158:	8526                	mv	a0,s1
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	3e8080e7          	jalr	1000(ra) # 80001542 <sleep>
  while(ticks - ticks0 < n){
    80002162:	409c                	lw	a5,0(s1)
    80002164:	412787bb          	subw	a5,a5,s2
    80002168:	fcc42703          	lw	a4,-52(s0)
    8000216c:	fce7efe3          	bltu	a5,a4,8000214a <sys_sleep+0x50>
    80002170:	74a2                	ld	s1,40(sp)
    80002172:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002174:	00008517          	auipc	a0,0x8
    80002178:	11c50513          	addi	a0,a0,284 # 8000a290 <tickslock>
    8000217c:	00004097          	auipc	ra,0x4
    80002180:	3be080e7          	jalr	958(ra) # 8000653a <release>
  return 0;
    80002184:	4781                	li	a5,0
    80002186:	7902                	ld	s2,32(sp)
}
    80002188:	853e                	mv	a0,a5
    8000218a:	70e2                	ld	ra,56(sp)
    8000218c:	7442                	ld	s0,48(sp)
    8000218e:	6121                	addi	sp,sp,64
    80002190:	8082                	ret
      release(&tickslock);
    80002192:	00008517          	auipc	a0,0x8
    80002196:	0fe50513          	addi	a0,a0,254 # 8000a290 <tickslock>
    8000219a:	00004097          	auipc	ra,0x4
    8000219e:	3a0080e7          	jalr	928(ra) # 8000653a <release>
      return -1;
    800021a2:	57fd                	li	a5,-1
    800021a4:	74a2                	ld	s1,40(sp)
    800021a6:	7902                	ld	s2,32(sp)
    800021a8:	69e2                	ld	s3,24(sp)
    800021aa:	bff9                	j	80002188 <sys_sleep+0x8e>

00000000800021ac <sys_kill>:

uint64
sys_kill(void)
{
    800021ac:	1101                	addi	sp,sp,-32
    800021ae:	ec06                	sd	ra,24(sp)
    800021b0:	e822                	sd	s0,16(sp)
    800021b2:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021b4:	fec40593          	addi	a1,s0,-20
    800021b8:	4501                	li	a0,0
    800021ba:	00000097          	auipc	ra,0x0
    800021be:	d7c080e7          	jalr	-644(ra) # 80001f36 <argint>
    800021c2:	87aa                	mv	a5,a0
    return -1;
    800021c4:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021c6:	0007c863          	bltz	a5,800021d6 <sys_kill+0x2a>
  return kill(pid);
    800021ca:	fec42503          	lw	a0,-20(s0)
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	6a0080e7          	jalr	1696(ra) # 8000186e <kill>
}
    800021d6:	60e2                	ld	ra,24(sp)
    800021d8:	6442                	ld	s0,16(sp)
    800021da:	6105                	addi	sp,sp,32
    800021dc:	8082                	ret

00000000800021de <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021de:	1101                	addi	sp,sp,-32
    800021e0:	ec06                	sd	ra,24(sp)
    800021e2:	e822                	sd	s0,16(sp)
    800021e4:	e426                	sd	s1,8(sp)
    800021e6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021e8:	00008517          	auipc	a0,0x8
    800021ec:	0a850513          	addi	a0,a0,168 # 8000a290 <tickslock>
    800021f0:	00004097          	auipc	ra,0x4
    800021f4:	296080e7          	jalr	662(ra) # 80006486 <acquire>
  xticks = ticks;
    800021f8:	00007497          	auipc	s1,0x7
    800021fc:	e204a483          	lw	s1,-480(s1) # 80009018 <ticks>
  release(&tickslock);
    80002200:	00008517          	auipc	a0,0x8
    80002204:	09050513          	addi	a0,a0,144 # 8000a290 <tickslock>
    80002208:	00004097          	auipc	ra,0x4
    8000220c:	332080e7          	jalr	818(ra) # 8000653a <release>
  return xticks;
}
    80002210:	02049513          	slli	a0,s1,0x20
    80002214:	9101                	srli	a0,a0,0x20
    80002216:	60e2                	ld	ra,24(sp)
    80002218:	6442                	ld	s0,16(sp)
    8000221a:	64a2                	ld	s1,8(sp)
    8000221c:	6105                	addi	sp,sp,32
    8000221e:	8082                	ret

0000000080002220 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002220:	7179                	addi	sp,sp,-48
    80002222:	f406                	sd	ra,40(sp)
    80002224:	f022                	sd	s0,32(sp)
    80002226:	ec26                	sd	s1,24(sp)
    80002228:	e84a                	sd	s2,16(sp)
    8000222a:	e44e                	sd	s3,8(sp)
    8000222c:	e052                	sd	s4,0(sp)
    8000222e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002230:	00006597          	auipc	a1,0x6
    80002234:	15058593          	addi	a1,a1,336 # 80008380 <etext+0x380>
    80002238:	00008517          	auipc	a0,0x8
    8000223c:	07050513          	addi	a0,a0,112 # 8000a2a8 <bcache>
    80002240:	00004097          	auipc	ra,0x4
    80002244:	1b6080e7          	jalr	438(ra) # 800063f6 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002248:	00010797          	auipc	a5,0x10
    8000224c:	06078793          	addi	a5,a5,96 # 800122a8 <bcache+0x8000>
    80002250:	00010717          	auipc	a4,0x10
    80002254:	2c070713          	addi	a4,a4,704 # 80012510 <bcache+0x8268>
    80002258:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000225c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002260:	00008497          	auipc	s1,0x8
    80002264:	06048493          	addi	s1,s1,96 # 8000a2c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002268:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000226a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000226c:	00006a17          	auipc	s4,0x6
    80002270:	11ca0a13          	addi	s4,s4,284 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    80002274:	2b893783          	ld	a5,696(s2)
    80002278:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000227a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000227e:	85d2                	mv	a1,s4
    80002280:	01048513          	addi	a0,s1,16
    80002284:	00001097          	auipc	ra,0x1
    80002288:	62e080e7          	jalr	1582(ra) # 800038b2 <initsleeplock>
    bcache.head.next->prev = b;
    8000228c:	2b893783          	ld	a5,696(s2)
    80002290:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002292:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002296:	45848493          	addi	s1,s1,1112
    8000229a:	fd349de3          	bne	s1,s3,80002274 <binit+0x54>
  }
}
    8000229e:	70a2                	ld	ra,40(sp)
    800022a0:	7402                	ld	s0,32(sp)
    800022a2:	64e2                	ld	s1,24(sp)
    800022a4:	6942                	ld	s2,16(sp)
    800022a6:	69a2                	ld	s3,8(sp)
    800022a8:	6a02                	ld	s4,0(sp)
    800022aa:	6145                	addi	sp,sp,48
    800022ac:	8082                	ret

00000000800022ae <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022ae:	7179                	addi	sp,sp,-48
    800022b0:	f406                	sd	ra,40(sp)
    800022b2:	f022                	sd	s0,32(sp)
    800022b4:	ec26                	sd	s1,24(sp)
    800022b6:	e84a                	sd	s2,16(sp)
    800022b8:	e44e                	sd	s3,8(sp)
    800022ba:	1800                	addi	s0,sp,48
    800022bc:	892a                	mv	s2,a0
    800022be:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022c0:	00008517          	auipc	a0,0x8
    800022c4:	fe850513          	addi	a0,a0,-24 # 8000a2a8 <bcache>
    800022c8:	00004097          	auipc	ra,0x4
    800022cc:	1be080e7          	jalr	446(ra) # 80006486 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022d0:	00010497          	auipc	s1,0x10
    800022d4:	2904b483          	ld	s1,656(s1) # 80012560 <bcache+0x82b8>
    800022d8:	00010797          	auipc	a5,0x10
    800022dc:	23878793          	addi	a5,a5,568 # 80012510 <bcache+0x8268>
    800022e0:	02f48f63          	beq	s1,a5,8000231e <bread+0x70>
    800022e4:	873e                	mv	a4,a5
    800022e6:	a021                	j	800022ee <bread+0x40>
    800022e8:	68a4                	ld	s1,80(s1)
    800022ea:	02e48a63          	beq	s1,a4,8000231e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022ee:	449c                	lw	a5,8(s1)
    800022f0:	ff279ce3          	bne	a5,s2,800022e8 <bread+0x3a>
    800022f4:	44dc                	lw	a5,12(s1)
    800022f6:	ff3799e3          	bne	a5,s3,800022e8 <bread+0x3a>
      b->refcnt++;
    800022fa:	40bc                	lw	a5,64(s1)
    800022fc:	2785                	addiw	a5,a5,1
    800022fe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002300:	00008517          	auipc	a0,0x8
    80002304:	fa850513          	addi	a0,a0,-88 # 8000a2a8 <bcache>
    80002308:	00004097          	auipc	ra,0x4
    8000230c:	232080e7          	jalr	562(ra) # 8000653a <release>
      acquiresleep(&b->lock);
    80002310:	01048513          	addi	a0,s1,16
    80002314:	00001097          	auipc	ra,0x1
    80002318:	5d8080e7          	jalr	1496(ra) # 800038ec <acquiresleep>
      return b;
    8000231c:	a8b9                	j	8000237a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000231e:	00010497          	auipc	s1,0x10
    80002322:	23a4b483          	ld	s1,570(s1) # 80012558 <bcache+0x82b0>
    80002326:	00010797          	auipc	a5,0x10
    8000232a:	1ea78793          	addi	a5,a5,490 # 80012510 <bcache+0x8268>
    8000232e:	00f48863          	beq	s1,a5,8000233e <bread+0x90>
    80002332:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002334:	40bc                	lw	a5,64(s1)
    80002336:	cf81                	beqz	a5,8000234e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002338:	64a4                	ld	s1,72(s1)
    8000233a:	fee49de3          	bne	s1,a4,80002334 <bread+0x86>
  panic("bget: no buffers");
    8000233e:	00006517          	auipc	a0,0x6
    80002342:	05250513          	addi	a0,a0,82 # 80008390 <etext+0x390>
    80002346:	00004097          	auipc	ra,0x4
    8000234a:	bc6080e7          	jalr	-1082(ra) # 80005f0c <panic>
      b->dev = dev;
    8000234e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002352:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002356:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000235a:	4785                	li	a5,1
    8000235c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000235e:	00008517          	auipc	a0,0x8
    80002362:	f4a50513          	addi	a0,a0,-182 # 8000a2a8 <bcache>
    80002366:	00004097          	auipc	ra,0x4
    8000236a:	1d4080e7          	jalr	468(ra) # 8000653a <release>
      acquiresleep(&b->lock);
    8000236e:	01048513          	addi	a0,s1,16
    80002372:	00001097          	auipc	ra,0x1
    80002376:	57a080e7          	jalr	1402(ra) # 800038ec <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000237a:	409c                	lw	a5,0(s1)
    8000237c:	cb89                	beqz	a5,8000238e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000237e:	8526                	mv	a0,s1
    80002380:	70a2                	ld	ra,40(sp)
    80002382:	7402                	ld	s0,32(sp)
    80002384:	64e2                	ld	s1,24(sp)
    80002386:	6942                	ld	s2,16(sp)
    80002388:	69a2                	ld	s3,8(sp)
    8000238a:	6145                	addi	sp,sp,48
    8000238c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000238e:	4581                	li	a1,0
    80002390:	8526                	mv	a0,s1
    80002392:	00003097          	auipc	ra,0x3
    80002396:	2e0080e7          	jalr	736(ra) # 80005672 <virtio_disk_rw>
    b->valid = 1;
    8000239a:	4785                	li	a5,1
    8000239c:	c09c                	sw	a5,0(s1)
  return b;
    8000239e:	b7c5                	j	8000237e <bread+0xd0>

00000000800023a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023a0:	1101                	addi	sp,sp,-32
    800023a2:	ec06                	sd	ra,24(sp)
    800023a4:	e822                	sd	s0,16(sp)
    800023a6:	e426                	sd	s1,8(sp)
    800023a8:	1000                	addi	s0,sp,32
    800023aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023ac:	0541                	addi	a0,a0,16
    800023ae:	00001097          	auipc	ra,0x1
    800023b2:	5d8080e7          	jalr	1496(ra) # 80003986 <holdingsleep>
    800023b6:	cd01                	beqz	a0,800023ce <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023b8:	4585                	li	a1,1
    800023ba:	8526                	mv	a0,s1
    800023bc:	00003097          	auipc	ra,0x3
    800023c0:	2b6080e7          	jalr	694(ra) # 80005672 <virtio_disk_rw>
}
    800023c4:	60e2                	ld	ra,24(sp)
    800023c6:	6442                	ld	s0,16(sp)
    800023c8:	64a2                	ld	s1,8(sp)
    800023ca:	6105                	addi	sp,sp,32
    800023cc:	8082                	ret
    panic("bwrite");
    800023ce:	00006517          	auipc	a0,0x6
    800023d2:	fda50513          	addi	a0,a0,-38 # 800083a8 <etext+0x3a8>
    800023d6:	00004097          	auipc	ra,0x4
    800023da:	b36080e7          	jalr	-1226(ra) # 80005f0c <panic>

00000000800023de <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023de:	1101                	addi	sp,sp,-32
    800023e0:	ec06                	sd	ra,24(sp)
    800023e2:	e822                	sd	s0,16(sp)
    800023e4:	e426                	sd	s1,8(sp)
    800023e6:	e04a                	sd	s2,0(sp)
    800023e8:	1000                	addi	s0,sp,32
    800023ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023ec:	01050913          	addi	s2,a0,16
    800023f0:	854a                	mv	a0,s2
    800023f2:	00001097          	auipc	ra,0x1
    800023f6:	594080e7          	jalr	1428(ra) # 80003986 <holdingsleep>
    800023fa:	c925                	beqz	a0,8000246a <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800023fc:	854a                	mv	a0,s2
    800023fe:	00001097          	auipc	ra,0x1
    80002402:	544080e7          	jalr	1348(ra) # 80003942 <releasesleep>

  acquire(&bcache.lock);
    80002406:	00008517          	auipc	a0,0x8
    8000240a:	ea250513          	addi	a0,a0,-350 # 8000a2a8 <bcache>
    8000240e:	00004097          	auipc	ra,0x4
    80002412:	078080e7          	jalr	120(ra) # 80006486 <acquire>
  b->refcnt--;
    80002416:	40bc                	lw	a5,64(s1)
    80002418:	37fd                	addiw	a5,a5,-1
    8000241a:	0007871b          	sext.w	a4,a5
    8000241e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002420:	e71d                	bnez	a4,8000244e <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002422:	68b8                	ld	a4,80(s1)
    80002424:	64bc                	ld	a5,72(s1)
    80002426:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002428:	68b8                	ld	a4,80(s1)
    8000242a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000242c:	00010797          	auipc	a5,0x10
    80002430:	e7c78793          	addi	a5,a5,-388 # 800122a8 <bcache+0x8000>
    80002434:	2b87b703          	ld	a4,696(a5)
    80002438:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000243a:	00010717          	auipc	a4,0x10
    8000243e:	0d670713          	addi	a4,a4,214 # 80012510 <bcache+0x8268>
    80002442:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002444:	2b87b703          	ld	a4,696(a5)
    80002448:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000244a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000244e:	00008517          	auipc	a0,0x8
    80002452:	e5a50513          	addi	a0,a0,-422 # 8000a2a8 <bcache>
    80002456:	00004097          	auipc	ra,0x4
    8000245a:	0e4080e7          	jalr	228(ra) # 8000653a <release>
}
    8000245e:	60e2                	ld	ra,24(sp)
    80002460:	6442                	ld	s0,16(sp)
    80002462:	64a2                	ld	s1,8(sp)
    80002464:	6902                	ld	s2,0(sp)
    80002466:	6105                	addi	sp,sp,32
    80002468:	8082                	ret
    panic("brelse");
    8000246a:	00006517          	auipc	a0,0x6
    8000246e:	f4650513          	addi	a0,a0,-186 # 800083b0 <etext+0x3b0>
    80002472:	00004097          	auipc	ra,0x4
    80002476:	a9a080e7          	jalr	-1382(ra) # 80005f0c <panic>

000000008000247a <bpin>:

void
bpin(struct buf *b) {
    8000247a:	1101                	addi	sp,sp,-32
    8000247c:	ec06                	sd	ra,24(sp)
    8000247e:	e822                	sd	s0,16(sp)
    80002480:	e426                	sd	s1,8(sp)
    80002482:	1000                	addi	s0,sp,32
    80002484:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002486:	00008517          	auipc	a0,0x8
    8000248a:	e2250513          	addi	a0,a0,-478 # 8000a2a8 <bcache>
    8000248e:	00004097          	auipc	ra,0x4
    80002492:	ff8080e7          	jalr	-8(ra) # 80006486 <acquire>
  b->refcnt++;
    80002496:	40bc                	lw	a5,64(s1)
    80002498:	2785                	addiw	a5,a5,1
    8000249a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000249c:	00008517          	auipc	a0,0x8
    800024a0:	e0c50513          	addi	a0,a0,-500 # 8000a2a8 <bcache>
    800024a4:	00004097          	auipc	ra,0x4
    800024a8:	096080e7          	jalr	150(ra) # 8000653a <release>
}
    800024ac:	60e2                	ld	ra,24(sp)
    800024ae:	6442                	ld	s0,16(sp)
    800024b0:	64a2                	ld	s1,8(sp)
    800024b2:	6105                	addi	sp,sp,32
    800024b4:	8082                	ret

00000000800024b6 <bunpin>:

void
bunpin(struct buf *b) {
    800024b6:	1101                	addi	sp,sp,-32
    800024b8:	ec06                	sd	ra,24(sp)
    800024ba:	e822                	sd	s0,16(sp)
    800024bc:	e426                	sd	s1,8(sp)
    800024be:	1000                	addi	s0,sp,32
    800024c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024c2:	00008517          	auipc	a0,0x8
    800024c6:	de650513          	addi	a0,a0,-538 # 8000a2a8 <bcache>
    800024ca:	00004097          	auipc	ra,0x4
    800024ce:	fbc080e7          	jalr	-68(ra) # 80006486 <acquire>
  b->refcnt--;
    800024d2:	40bc                	lw	a5,64(s1)
    800024d4:	37fd                	addiw	a5,a5,-1
    800024d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024d8:	00008517          	auipc	a0,0x8
    800024dc:	dd050513          	addi	a0,a0,-560 # 8000a2a8 <bcache>
    800024e0:	00004097          	auipc	ra,0x4
    800024e4:	05a080e7          	jalr	90(ra) # 8000653a <release>
}
    800024e8:	60e2                	ld	ra,24(sp)
    800024ea:	6442                	ld	s0,16(sp)
    800024ec:	64a2                	ld	s1,8(sp)
    800024ee:	6105                	addi	sp,sp,32
    800024f0:	8082                	ret

00000000800024f2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024f2:	1101                	addi	sp,sp,-32
    800024f4:	ec06                	sd	ra,24(sp)
    800024f6:	e822                	sd	s0,16(sp)
    800024f8:	e426                	sd	s1,8(sp)
    800024fa:	e04a                	sd	s2,0(sp)
    800024fc:	1000                	addi	s0,sp,32
    800024fe:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002500:	00d5d59b          	srliw	a1,a1,0xd
    80002504:	00010797          	auipc	a5,0x10
    80002508:	4807a783          	lw	a5,1152(a5) # 80012984 <sb+0x1c>
    8000250c:	9dbd                	addw	a1,a1,a5
    8000250e:	00000097          	auipc	ra,0x0
    80002512:	da0080e7          	jalr	-608(ra) # 800022ae <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002516:	0074f713          	andi	a4,s1,7
    8000251a:	4785                	li	a5,1
    8000251c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002520:	14ce                	slli	s1,s1,0x33
    80002522:	90d9                	srli	s1,s1,0x36
    80002524:	00950733          	add	a4,a0,s1
    80002528:	05874703          	lbu	a4,88(a4)
    8000252c:	00e7f6b3          	and	a3,a5,a4
    80002530:	c69d                	beqz	a3,8000255e <bfree+0x6c>
    80002532:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002534:	94aa                	add	s1,s1,a0
    80002536:	fff7c793          	not	a5,a5
    8000253a:	8f7d                	and	a4,a4,a5
    8000253c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002540:	00001097          	auipc	ra,0x1
    80002544:	28e080e7          	jalr	654(ra) # 800037ce <log_write>
  brelse(bp);
    80002548:	854a                	mv	a0,s2
    8000254a:	00000097          	auipc	ra,0x0
    8000254e:	e94080e7          	jalr	-364(ra) # 800023de <brelse>
}
    80002552:	60e2                	ld	ra,24(sp)
    80002554:	6442                	ld	s0,16(sp)
    80002556:	64a2                	ld	s1,8(sp)
    80002558:	6902                	ld	s2,0(sp)
    8000255a:	6105                	addi	sp,sp,32
    8000255c:	8082                	ret
    panic("freeing free block");
    8000255e:	00006517          	auipc	a0,0x6
    80002562:	e5a50513          	addi	a0,a0,-422 # 800083b8 <etext+0x3b8>
    80002566:	00004097          	auipc	ra,0x4
    8000256a:	9a6080e7          	jalr	-1626(ra) # 80005f0c <panic>

000000008000256e <balloc>:
{
    8000256e:	711d                	addi	sp,sp,-96
    80002570:	ec86                	sd	ra,88(sp)
    80002572:	e8a2                	sd	s0,80(sp)
    80002574:	e4a6                	sd	s1,72(sp)
    80002576:	e0ca                	sd	s2,64(sp)
    80002578:	fc4e                	sd	s3,56(sp)
    8000257a:	f852                	sd	s4,48(sp)
    8000257c:	f456                	sd	s5,40(sp)
    8000257e:	f05a                	sd	s6,32(sp)
    80002580:	ec5e                	sd	s7,24(sp)
    80002582:	e862                	sd	s8,16(sp)
    80002584:	e466                	sd	s9,8(sp)
    80002586:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002588:	00010797          	auipc	a5,0x10
    8000258c:	3e47a783          	lw	a5,996(a5) # 8001296c <sb+0x4>
    80002590:	cbc1                	beqz	a5,80002620 <balloc+0xb2>
    80002592:	8baa                	mv	s7,a0
    80002594:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002596:	00010b17          	auipc	s6,0x10
    8000259a:	3d2b0b13          	addi	s6,s6,978 # 80012968 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000259e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025a0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025a2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025a4:	6c89                	lui	s9,0x2
    800025a6:	a831                	j	800025c2 <balloc+0x54>
    brelse(bp);
    800025a8:	854a                	mv	a0,s2
    800025aa:	00000097          	auipc	ra,0x0
    800025ae:	e34080e7          	jalr	-460(ra) # 800023de <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025b2:	015c87bb          	addw	a5,s9,s5
    800025b6:	00078a9b          	sext.w	s5,a5
    800025ba:	004b2703          	lw	a4,4(s6)
    800025be:	06eaf163          	bgeu	s5,a4,80002620 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800025c2:	41fad79b          	sraiw	a5,s5,0x1f
    800025c6:	0137d79b          	srliw	a5,a5,0x13
    800025ca:	015787bb          	addw	a5,a5,s5
    800025ce:	40d7d79b          	sraiw	a5,a5,0xd
    800025d2:	01cb2583          	lw	a1,28(s6)
    800025d6:	9dbd                	addw	a1,a1,a5
    800025d8:	855e                	mv	a0,s7
    800025da:	00000097          	auipc	ra,0x0
    800025de:	cd4080e7          	jalr	-812(ra) # 800022ae <bread>
    800025e2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025e4:	004b2503          	lw	a0,4(s6)
    800025e8:	000a849b          	sext.w	s1,s5
    800025ec:	8762                	mv	a4,s8
    800025ee:	faa4fde3          	bgeu	s1,a0,800025a8 <balloc+0x3a>
      m = 1 << (bi % 8);
    800025f2:	00777693          	andi	a3,a4,7
    800025f6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025fa:	41f7579b          	sraiw	a5,a4,0x1f
    800025fe:	01d7d79b          	srliw	a5,a5,0x1d
    80002602:	9fb9                	addw	a5,a5,a4
    80002604:	4037d79b          	sraiw	a5,a5,0x3
    80002608:	00f90633          	add	a2,s2,a5
    8000260c:	05864603          	lbu	a2,88(a2)
    80002610:	00c6f5b3          	and	a1,a3,a2
    80002614:	cd91                	beqz	a1,80002630 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002616:	2705                	addiw	a4,a4,1
    80002618:	2485                	addiw	s1,s1,1
    8000261a:	fd471ae3          	bne	a4,s4,800025ee <balloc+0x80>
    8000261e:	b769                	j	800025a8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002620:	00006517          	auipc	a0,0x6
    80002624:	db050513          	addi	a0,a0,-592 # 800083d0 <etext+0x3d0>
    80002628:	00004097          	auipc	ra,0x4
    8000262c:	8e4080e7          	jalr	-1820(ra) # 80005f0c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002630:	97ca                	add	a5,a5,s2
    80002632:	8e55                	or	a2,a2,a3
    80002634:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002638:	854a                	mv	a0,s2
    8000263a:	00001097          	auipc	ra,0x1
    8000263e:	194080e7          	jalr	404(ra) # 800037ce <log_write>
        brelse(bp);
    80002642:	854a                	mv	a0,s2
    80002644:	00000097          	auipc	ra,0x0
    80002648:	d9a080e7          	jalr	-614(ra) # 800023de <brelse>
  bp = bread(dev, bno);
    8000264c:	85a6                	mv	a1,s1
    8000264e:	855e                	mv	a0,s7
    80002650:	00000097          	auipc	ra,0x0
    80002654:	c5e080e7          	jalr	-930(ra) # 800022ae <bread>
    80002658:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000265a:	40000613          	li	a2,1024
    8000265e:	4581                	li	a1,0
    80002660:	05850513          	addi	a0,a0,88
    80002664:	ffffe097          	auipc	ra,0xffffe
    80002668:	b16080e7          	jalr	-1258(ra) # 8000017a <memset>
  log_write(bp);
    8000266c:	854a                	mv	a0,s2
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	160080e7          	jalr	352(ra) # 800037ce <log_write>
  brelse(bp);
    80002676:	854a                	mv	a0,s2
    80002678:	00000097          	auipc	ra,0x0
    8000267c:	d66080e7          	jalr	-666(ra) # 800023de <brelse>
}
    80002680:	8526                	mv	a0,s1
    80002682:	60e6                	ld	ra,88(sp)
    80002684:	6446                	ld	s0,80(sp)
    80002686:	64a6                	ld	s1,72(sp)
    80002688:	6906                	ld	s2,64(sp)
    8000268a:	79e2                	ld	s3,56(sp)
    8000268c:	7a42                	ld	s4,48(sp)
    8000268e:	7aa2                	ld	s5,40(sp)
    80002690:	7b02                	ld	s6,32(sp)
    80002692:	6be2                	ld	s7,24(sp)
    80002694:	6c42                	ld	s8,16(sp)
    80002696:	6ca2                	ld	s9,8(sp)
    80002698:	6125                	addi	sp,sp,96
    8000269a:	8082                	ret

000000008000269c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000269c:	7139                	addi	sp,sp,-64
    8000269e:	fc06                	sd	ra,56(sp)
    800026a0:	f822                	sd	s0,48(sp)
    800026a2:	f426                	sd	s1,40(sp)
    800026a4:	f04a                	sd	s2,32(sp)
    800026a6:	ec4e                	sd	s3,24(sp)
    800026a8:	0080                	addi	s0,sp,64
    800026aa:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026ac:	47a9                	li	a5,10
    800026ae:	0ab7f063          	bgeu	a5,a1,8000274e <bmap+0xb2>
    800026b2:	e852                	sd	s4,16(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026b4:	ff55849b          	addiw	s1,a1,-11
    800026b8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026bc:	0ff00793          	li	a5,255
    800026c0:	0ae7fb63          	bgeu	a5,a4,80002776 <bmap+0xda>
    800026c4:	e456                	sd	s5,8(sp)
    }
    brelse(bp);
    return addr;
  }
  
     bn -= NINDIRECT;
    800026c6:	ef55859b          	addiw	a1,a1,-267
    800026ca:	0005871b          	sext.w	a4,a1
   if(bn < NDINDIRECT){
    800026ce:	67c1                	lui	a5,0x10
    800026d0:	16f77263          	bgeu	a4,a5,80002834 <bmap+0x198>
       int idx1 = bn / NINDIRECT;
    800026d4:	0085da9b          	srliw	s5,a1,0x8
       int idx2 = bn % NINDIRECT;
    800026d8:	0ff5f493          	zext.b	s1,a1
       if((addr = ip->addrs[NDIRECT+1]) == 0)
    800026dc:	08052583          	lw	a1,128(a0)
    800026e0:	10058063          	beqz	a1,800027e0 <bmap+0x144>
          ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
       bp = bread(ip->dev,addr);
    800026e4:	00092503          	lw	a0,0(s2)
    800026e8:	00000097          	auipc	ra,0x0
    800026ec:	bc6080e7          	jalr	-1082(ra) # 800022ae <bread>
    800026f0:	89aa                	mv	s3,a0
       a = (uint*)bp->data;
    800026f2:	05850a13          	addi	s4,a0,88
       if((addr = a[idx1]) == 0){
    800026f6:	0a8a                	slli	s5,s5,0x2
    800026f8:	9a56                	add	s4,s4,s5
    800026fa:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
    800026fe:	0e0a8b63          	beqz	s5,800027f4 <bmap+0x158>
           a[idx1] = addr = balloc(ip->dev);
           log_write(bp);
       }
       brelse(bp);
    80002702:	854e                	mv	a0,s3
    80002704:	00000097          	auipc	ra,0x0
    80002708:	cda080e7          	jalr	-806(ra) # 800023de <brelse>
       bp = bread(ip->dev,addr);
    8000270c:	85d6                	mv	a1,s5
    8000270e:	00092503          	lw	a0,0(s2)
    80002712:	00000097          	auipc	ra,0x0
    80002716:	b9c080e7          	jalr	-1124(ra) # 800022ae <bread>
    8000271a:	8a2a                	mv	s4,a0
       a = (uint*)bp->data;
    8000271c:	05850793          	addi	a5,a0,88
       if((addr = a[idx2]) == 0){
    80002720:	00249593          	slli	a1,s1,0x2
    80002724:	00b784b3          	add	s1,a5,a1
    80002728:	0004a983          	lw	s3,0(s1)
    8000272c:	0e098463          	beqz	s3,80002814 <bmap+0x178>
           a[idx2] = addr = balloc(ip->dev);
           log_write(bp);
       }
       brelse(bp);
    80002730:	8552                	mv	a0,s4
    80002732:	00000097          	auipc	ra,0x0
    80002736:	cac080e7          	jalr	-852(ra) # 800023de <brelse>
       return addr;
    8000273a:	6a42                	ld	s4,16(sp)
    8000273c:	6aa2                	ld	s5,8(sp)
   }
  
  
  panic("bmap: out of range");
}
    8000273e:	854e                	mv	a0,s3
    80002740:	70e2                	ld	ra,56(sp)
    80002742:	7442                	ld	s0,48(sp)
    80002744:	74a2                	ld	s1,40(sp)
    80002746:	7902                	ld	s2,32(sp)
    80002748:	69e2                	ld	s3,24(sp)
    8000274a:	6121                	addi	sp,sp,64
    8000274c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000274e:	02059793          	slli	a5,a1,0x20
    80002752:	01e7d593          	srli	a1,a5,0x1e
    80002756:	00b504b3          	add	s1,a0,a1
    8000275a:	0504a983          	lw	s3,80(s1)
    8000275e:	fe0990e3          	bnez	s3,8000273e <bmap+0xa2>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002762:	4108                	lw	a0,0(a0)
    80002764:	00000097          	auipc	ra,0x0
    80002768:	e0a080e7          	jalr	-502(ra) # 8000256e <balloc>
    8000276c:	0005099b          	sext.w	s3,a0
    80002770:	0534a823          	sw	s3,80(s1)
    80002774:	b7e9                	j	8000273e <bmap+0xa2>
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002776:	5d6c                	lw	a1,124(a0)
    80002778:	c995                	beqz	a1,800027ac <bmap+0x110>
    bp = bread(ip->dev, addr);
    8000277a:	00092503          	lw	a0,0(s2)
    8000277e:	00000097          	auipc	ra,0x0
    80002782:	b30080e7          	jalr	-1232(ra) # 800022ae <bread>
    80002786:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002788:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000278c:	02049713          	slli	a4,s1,0x20
    80002790:	01e75493          	srli	s1,a4,0x1e
    80002794:	94be                	add	s1,s1,a5
    80002796:	0004a983          	lw	s3,0(s1)
    8000279a:	02098363          	beqz	s3,800027c0 <bmap+0x124>
    brelse(bp);
    8000279e:	8552                	mv	a0,s4
    800027a0:	00000097          	auipc	ra,0x0
    800027a4:	c3e080e7          	jalr	-962(ra) # 800023de <brelse>
    return addr;
    800027a8:	6a42                	ld	s4,16(sp)
    800027aa:	bf51                	j	8000273e <bmap+0xa2>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800027ac:	4108                	lw	a0,0(a0)
    800027ae:	00000097          	auipc	ra,0x0
    800027b2:	dc0080e7          	jalr	-576(ra) # 8000256e <balloc>
    800027b6:	0005059b          	sext.w	a1,a0
    800027ba:	06b92e23          	sw	a1,124(s2)
    800027be:	bf75                	j	8000277a <bmap+0xde>
      a[bn] = addr = balloc(ip->dev);
    800027c0:	00092503          	lw	a0,0(s2)
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	daa080e7          	jalr	-598(ra) # 8000256e <balloc>
    800027cc:	0005099b          	sext.w	s3,a0
    800027d0:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800027d4:	8552                	mv	a0,s4
    800027d6:	00001097          	auipc	ra,0x1
    800027da:	ff8080e7          	jalr	-8(ra) # 800037ce <log_write>
    800027de:	b7c1                	j	8000279e <bmap+0x102>
          ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    800027e0:	4108                	lw	a0,0(a0)
    800027e2:	00000097          	auipc	ra,0x0
    800027e6:	d8c080e7          	jalr	-628(ra) # 8000256e <balloc>
    800027ea:	0005059b          	sext.w	a1,a0
    800027ee:	08b92023          	sw	a1,128(s2)
    800027f2:	bdcd                	j	800026e4 <bmap+0x48>
           a[idx1] = addr = balloc(ip->dev);
    800027f4:	00092503          	lw	a0,0(s2)
    800027f8:	00000097          	auipc	ra,0x0
    800027fc:	d76080e7          	jalr	-650(ra) # 8000256e <balloc>
    80002800:	00050a9b          	sext.w	s5,a0
    80002804:	015a2023          	sw	s5,0(s4)
           log_write(bp);
    80002808:	854e                	mv	a0,s3
    8000280a:	00001097          	auipc	ra,0x1
    8000280e:	fc4080e7          	jalr	-60(ra) # 800037ce <log_write>
    80002812:	bdc5                	j	80002702 <bmap+0x66>
           a[idx2] = addr = balloc(ip->dev);
    80002814:	00092503          	lw	a0,0(s2)
    80002818:	00000097          	auipc	ra,0x0
    8000281c:	d56080e7          	jalr	-682(ra) # 8000256e <balloc>
    80002820:	0005099b          	sext.w	s3,a0
    80002824:	0134a023          	sw	s3,0(s1)
           log_write(bp);
    80002828:	8552                	mv	a0,s4
    8000282a:	00001097          	auipc	ra,0x1
    8000282e:	fa4080e7          	jalr	-92(ra) # 800037ce <log_write>
    80002832:	bdfd                	j	80002730 <bmap+0x94>
  panic("bmap: out of range");
    80002834:	00006517          	auipc	a0,0x6
    80002838:	bb450513          	addi	a0,a0,-1100 # 800083e8 <etext+0x3e8>
    8000283c:	00003097          	auipc	ra,0x3
    80002840:	6d0080e7          	jalr	1744(ra) # 80005f0c <panic>

0000000080002844 <iget>:
{
    80002844:	7179                	addi	sp,sp,-48
    80002846:	f406                	sd	ra,40(sp)
    80002848:	f022                	sd	s0,32(sp)
    8000284a:	ec26                	sd	s1,24(sp)
    8000284c:	e84a                	sd	s2,16(sp)
    8000284e:	e44e                	sd	s3,8(sp)
    80002850:	e052                	sd	s4,0(sp)
    80002852:	1800                	addi	s0,sp,48
    80002854:	89aa                	mv	s3,a0
    80002856:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002858:	00010517          	auipc	a0,0x10
    8000285c:	13050513          	addi	a0,a0,304 # 80012988 <itable>
    80002860:	00004097          	auipc	ra,0x4
    80002864:	c26080e7          	jalr	-986(ra) # 80006486 <acquire>
  empty = 0;
    80002868:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000286a:	00010497          	auipc	s1,0x10
    8000286e:	13648493          	addi	s1,s1,310 # 800129a0 <itable+0x18>
    80002872:	00012697          	auipc	a3,0x12
    80002876:	bbe68693          	addi	a3,a3,-1090 # 80014430 <log>
    8000287a:	a039                	j	80002888 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000287c:	02090b63          	beqz	s2,800028b2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002880:	08848493          	addi	s1,s1,136
    80002884:	02d48a63          	beq	s1,a3,800028b8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002888:	449c                	lw	a5,8(s1)
    8000288a:	fef059e3          	blez	a5,8000287c <iget+0x38>
    8000288e:	4098                	lw	a4,0(s1)
    80002890:	ff3716e3          	bne	a4,s3,8000287c <iget+0x38>
    80002894:	40d8                	lw	a4,4(s1)
    80002896:	ff4713e3          	bne	a4,s4,8000287c <iget+0x38>
      ip->ref++;
    8000289a:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    8000289c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000289e:	00010517          	auipc	a0,0x10
    800028a2:	0ea50513          	addi	a0,a0,234 # 80012988 <itable>
    800028a6:	00004097          	auipc	ra,0x4
    800028aa:	c94080e7          	jalr	-876(ra) # 8000653a <release>
      return ip;
    800028ae:	8926                	mv	s2,s1
    800028b0:	a03d                	j	800028de <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028b2:	f7f9                	bnez	a5,80002880 <iget+0x3c>
      empty = ip;
    800028b4:	8926                	mv	s2,s1
    800028b6:	b7e9                	j	80002880 <iget+0x3c>
  if(empty == 0)
    800028b8:	02090c63          	beqz	s2,800028f0 <iget+0xac>
  ip->dev = dev;
    800028bc:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028c0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028c4:	4785                	li	a5,1
    800028c6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028ca:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028ce:	00010517          	auipc	a0,0x10
    800028d2:	0ba50513          	addi	a0,a0,186 # 80012988 <itable>
    800028d6:	00004097          	auipc	ra,0x4
    800028da:	c64080e7          	jalr	-924(ra) # 8000653a <release>
}
    800028de:	854a                	mv	a0,s2
    800028e0:	70a2                	ld	ra,40(sp)
    800028e2:	7402                	ld	s0,32(sp)
    800028e4:	64e2                	ld	s1,24(sp)
    800028e6:	6942                	ld	s2,16(sp)
    800028e8:	69a2                	ld	s3,8(sp)
    800028ea:	6a02                	ld	s4,0(sp)
    800028ec:	6145                	addi	sp,sp,48
    800028ee:	8082                	ret
    panic("iget: no inodes");
    800028f0:	00006517          	auipc	a0,0x6
    800028f4:	b1050513          	addi	a0,a0,-1264 # 80008400 <etext+0x400>
    800028f8:	00003097          	auipc	ra,0x3
    800028fc:	614080e7          	jalr	1556(ra) # 80005f0c <panic>

0000000080002900 <fsinit>:
fsinit(int dev) {
    80002900:	7179                	addi	sp,sp,-48
    80002902:	f406                	sd	ra,40(sp)
    80002904:	f022                	sd	s0,32(sp)
    80002906:	ec26                	sd	s1,24(sp)
    80002908:	e84a                	sd	s2,16(sp)
    8000290a:	e44e                	sd	s3,8(sp)
    8000290c:	1800                	addi	s0,sp,48
    8000290e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002910:	4585                	li	a1,1
    80002912:	00000097          	auipc	ra,0x0
    80002916:	99c080e7          	jalr	-1636(ra) # 800022ae <bread>
    8000291a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000291c:	00010997          	auipc	s3,0x10
    80002920:	04c98993          	addi	s3,s3,76 # 80012968 <sb>
    80002924:	02000613          	li	a2,32
    80002928:	05850593          	addi	a1,a0,88
    8000292c:	854e                	mv	a0,s3
    8000292e:	ffffe097          	auipc	ra,0xffffe
    80002932:	8a8080e7          	jalr	-1880(ra) # 800001d6 <memmove>
  brelse(bp);
    80002936:	8526                	mv	a0,s1
    80002938:	00000097          	auipc	ra,0x0
    8000293c:	aa6080e7          	jalr	-1370(ra) # 800023de <brelse>
  if(sb.magic != FSMAGIC)
    80002940:	0009a703          	lw	a4,0(s3)
    80002944:	102037b7          	lui	a5,0x10203
    80002948:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000294c:	02f71263          	bne	a4,a5,80002970 <fsinit+0x70>
  initlog(dev, &sb);
    80002950:	00010597          	auipc	a1,0x10
    80002954:	01858593          	addi	a1,a1,24 # 80012968 <sb>
    80002958:	854a                	mv	a0,s2
    8000295a:	00001097          	auipc	ra,0x1
    8000295e:	c04080e7          	jalr	-1020(ra) # 8000355e <initlog>
}
    80002962:	70a2                	ld	ra,40(sp)
    80002964:	7402                	ld	s0,32(sp)
    80002966:	64e2                	ld	s1,24(sp)
    80002968:	6942                	ld	s2,16(sp)
    8000296a:	69a2                	ld	s3,8(sp)
    8000296c:	6145                	addi	sp,sp,48
    8000296e:	8082                	ret
    panic("invalid file system");
    80002970:	00006517          	auipc	a0,0x6
    80002974:	aa050513          	addi	a0,a0,-1376 # 80008410 <etext+0x410>
    80002978:	00003097          	auipc	ra,0x3
    8000297c:	594080e7          	jalr	1428(ra) # 80005f0c <panic>

0000000080002980 <iinit>:
{
    80002980:	7179                	addi	sp,sp,-48
    80002982:	f406                	sd	ra,40(sp)
    80002984:	f022                	sd	s0,32(sp)
    80002986:	ec26                	sd	s1,24(sp)
    80002988:	e84a                	sd	s2,16(sp)
    8000298a:	e44e                	sd	s3,8(sp)
    8000298c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000298e:	00006597          	auipc	a1,0x6
    80002992:	a9a58593          	addi	a1,a1,-1382 # 80008428 <etext+0x428>
    80002996:	00010517          	auipc	a0,0x10
    8000299a:	ff250513          	addi	a0,a0,-14 # 80012988 <itable>
    8000299e:	00004097          	auipc	ra,0x4
    800029a2:	a58080e7          	jalr	-1448(ra) # 800063f6 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029a6:	00010497          	auipc	s1,0x10
    800029aa:	00a48493          	addi	s1,s1,10 # 800129b0 <itable+0x28>
    800029ae:	00012997          	auipc	s3,0x12
    800029b2:	a9298993          	addi	s3,s3,-1390 # 80014440 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029b6:	00006917          	auipc	s2,0x6
    800029ba:	a7a90913          	addi	s2,s2,-1414 # 80008430 <etext+0x430>
    800029be:	85ca                	mv	a1,s2
    800029c0:	8526                	mv	a0,s1
    800029c2:	00001097          	auipc	ra,0x1
    800029c6:	ef0080e7          	jalr	-272(ra) # 800038b2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029ca:	08848493          	addi	s1,s1,136
    800029ce:	ff3498e3          	bne	s1,s3,800029be <iinit+0x3e>
}
    800029d2:	70a2                	ld	ra,40(sp)
    800029d4:	7402                	ld	s0,32(sp)
    800029d6:	64e2                	ld	s1,24(sp)
    800029d8:	6942                	ld	s2,16(sp)
    800029da:	69a2                	ld	s3,8(sp)
    800029dc:	6145                	addi	sp,sp,48
    800029de:	8082                	ret

00000000800029e0 <ialloc>:
{
    800029e0:	7139                	addi	sp,sp,-64
    800029e2:	fc06                	sd	ra,56(sp)
    800029e4:	f822                	sd	s0,48(sp)
    800029e6:	f426                	sd	s1,40(sp)
    800029e8:	f04a                	sd	s2,32(sp)
    800029ea:	ec4e                	sd	s3,24(sp)
    800029ec:	e852                	sd	s4,16(sp)
    800029ee:	e456                	sd	s5,8(sp)
    800029f0:	e05a                	sd	s6,0(sp)
    800029f2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800029f4:	00010717          	auipc	a4,0x10
    800029f8:	f8072703          	lw	a4,-128(a4) # 80012974 <sb+0xc>
    800029fc:	4785                	li	a5,1
    800029fe:	04e7f863          	bgeu	a5,a4,80002a4e <ialloc+0x6e>
    80002a02:	8aaa                	mv	s5,a0
    80002a04:	8b2e                	mv	s6,a1
    80002a06:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a08:	00010a17          	auipc	s4,0x10
    80002a0c:	f60a0a13          	addi	s4,s4,-160 # 80012968 <sb>
    80002a10:	00495593          	srli	a1,s2,0x4
    80002a14:	018a2783          	lw	a5,24(s4)
    80002a18:	9dbd                	addw	a1,a1,a5
    80002a1a:	8556                	mv	a0,s5
    80002a1c:	00000097          	auipc	ra,0x0
    80002a20:	892080e7          	jalr	-1902(ra) # 800022ae <bread>
    80002a24:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a26:	05850993          	addi	s3,a0,88
    80002a2a:	00f97793          	andi	a5,s2,15
    80002a2e:	079a                	slli	a5,a5,0x6
    80002a30:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a32:	00099783          	lh	a5,0(s3)
    80002a36:	c785                	beqz	a5,80002a5e <ialloc+0x7e>
    brelse(bp);
    80002a38:	00000097          	auipc	ra,0x0
    80002a3c:	9a6080e7          	jalr	-1626(ra) # 800023de <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a40:	0905                	addi	s2,s2,1
    80002a42:	00ca2703          	lw	a4,12(s4)
    80002a46:	0009079b          	sext.w	a5,s2
    80002a4a:	fce7e3e3          	bltu	a5,a4,80002a10 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002a4e:	00006517          	auipc	a0,0x6
    80002a52:	9ea50513          	addi	a0,a0,-1558 # 80008438 <etext+0x438>
    80002a56:	00003097          	auipc	ra,0x3
    80002a5a:	4b6080e7          	jalr	1206(ra) # 80005f0c <panic>
      memset(dip, 0, sizeof(*dip));
    80002a5e:	04000613          	li	a2,64
    80002a62:	4581                	li	a1,0
    80002a64:	854e                	mv	a0,s3
    80002a66:	ffffd097          	auipc	ra,0xffffd
    80002a6a:	714080e7          	jalr	1812(ra) # 8000017a <memset>
      dip->type = type;
    80002a6e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a72:	8526                	mv	a0,s1
    80002a74:	00001097          	auipc	ra,0x1
    80002a78:	d5a080e7          	jalr	-678(ra) # 800037ce <log_write>
      brelse(bp);
    80002a7c:	8526                	mv	a0,s1
    80002a7e:	00000097          	auipc	ra,0x0
    80002a82:	960080e7          	jalr	-1696(ra) # 800023de <brelse>
      return iget(dev, inum);
    80002a86:	0009059b          	sext.w	a1,s2
    80002a8a:	8556                	mv	a0,s5
    80002a8c:	00000097          	auipc	ra,0x0
    80002a90:	db8080e7          	jalr	-584(ra) # 80002844 <iget>
}
    80002a94:	70e2                	ld	ra,56(sp)
    80002a96:	7442                	ld	s0,48(sp)
    80002a98:	74a2                	ld	s1,40(sp)
    80002a9a:	7902                	ld	s2,32(sp)
    80002a9c:	69e2                	ld	s3,24(sp)
    80002a9e:	6a42                	ld	s4,16(sp)
    80002aa0:	6aa2                	ld	s5,8(sp)
    80002aa2:	6b02                	ld	s6,0(sp)
    80002aa4:	6121                	addi	sp,sp,64
    80002aa6:	8082                	ret

0000000080002aa8 <iupdate>:
{
    80002aa8:	1101                	addi	sp,sp,-32
    80002aaa:	ec06                	sd	ra,24(sp)
    80002aac:	e822                	sd	s0,16(sp)
    80002aae:	e426                	sd	s1,8(sp)
    80002ab0:	e04a                	sd	s2,0(sp)
    80002ab2:	1000                	addi	s0,sp,32
    80002ab4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ab6:	415c                	lw	a5,4(a0)
    80002ab8:	0047d79b          	srliw	a5,a5,0x4
    80002abc:	00010597          	auipc	a1,0x10
    80002ac0:	ec45a583          	lw	a1,-316(a1) # 80012980 <sb+0x18>
    80002ac4:	9dbd                	addw	a1,a1,a5
    80002ac6:	4108                	lw	a0,0(a0)
    80002ac8:	fffff097          	auipc	ra,0xfffff
    80002acc:	7e6080e7          	jalr	2022(ra) # 800022ae <bread>
    80002ad0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ad2:	05850793          	addi	a5,a0,88
    80002ad6:	40d8                	lw	a4,4(s1)
    80002ad8:	8b3d                	andi	a4,a4,15
    80002ada:	071a                	slli	a4,a4,0x6
    80002adc:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002ade:	04449703          	lh	a4,68(s1)
    80002ae2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ae6:	04649703          	lh	a4,70(s1)
    80002aea:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002aee:	04849703          	lh	a4,72(s1)
    80002af2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002af6:	04a49703          	lh	a4,74(s1)
    80002afa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002afe:	44f8                	lw	a4,76(s1)
    80002b00:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b02:	03400613          	li	a2,52
    80002b06:	05048593          	addi	a1,s1,80
    80002b0a:	00c78513          	addi	a0,a5,12
    80002b0e:	ffffd097          	auipc	ra,0xffffd
    80002b12:	6c8080e7          	jalr	1736(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b16:	854a                	mv	a0,s2
    80002b18:	00001097          	auipc	ra,0x1
    80002b1c:	cb6080e7          	jalr	-842(ra) # 800037ce <log_write>
  brelse(bp);
    80002b20:	854a                	mv	a0,s2
    80002b22:	00000097          	auipc	ra,0x0
    80002b26:	8bc080e7          	jalr	-1860(ra) # 800023de <brelse>
}
    80002b2a:	60e2                	ld	ra,24(sp)
    80002b2c:	6442                	ld	s0,16(sp)
    80002b2e:	64a2                	ld	s1,8(sp)
    80002b30:	6902                	ld	s2,0(sp)
    80002b32:	6105                	addi	sp,sp,32
    80002b34:	8082                	ret

0000000080002b36 <idup>:
{
    80002b36:	1101                	addi	sp,sp,-32
    80002b38:	ec06                	sd	ra,24(sp)
    80002b3a:	e822                	sd	s0,16(sp)
    80002b3c:	e426                	sd	s1,8(sp)
    80002b3e:	1000                	addi	s0,sp,32
    80002b40:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b42:	00010517          	auipc	a0,0x10
    80002b46:	e4650513          	addi	a0,a0,-442 # 80012988 <itable>
    80002b4a:	00004097          	auipc	ra,0x4
    80002b4e:	93c080e7          	jalr	-1732(ra) # 80006486 <acquire>
  ip->ref++;
    80002b52:	449c                	lw	a5,8(s1)
    80002b54:	2785                	addiw	a5,a5,1
    80002b56:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b58:	00010517          	auipc	a0,0x10
    80002b5c:	e3050513          	addi	a0,a0,-464 # 80012988 <itable>
    80002b60:	00004097          	auipc	ra,0x4
    80002b64:	9da080e7          	jalr	-1574(ra) # 8000653a <release>
}
    80002b68:	8526                	mv	a0,s1
    80002b6a:	60e2                	ld	ra,24(sp)
    80002b6c:	6442                	ld	s0,16(sp)
    80002b6e:	64a2                	ld	s1,8(sp)
    80002b70:	6105                	addi	sp,sp,32
    80002b72:	8082                	ret

0000000080002b74 <ilock>:
{
    80002b74:	1101                	addi	sp,sp,-32
    80002b76:	ec06                	sd	ra,24(sp)
    80002b78:	e822                	sd	s0,16(sp)
    80002b7a:	e426                	sd	s1,8(sp)
    80002b7c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b7e:	c10d                	beqz	a0,80002ba0 <ilock+0x2c>
    80002b80:	84aa                	mv	s1,a0
    80002b82:	451c                	lw	a5,8(a0)
    80002b84:	00f05e63          	blez	a5,80002ba0 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002b88:	0541                	addi	a0,a0,16
    80002b8a:	00001097          	auipc	ra,0x1
    80002b8e:	d62080e7          	jalr	-670(ra) # 800038ec <acquiresleep>
  if(ip->valid == 0){
    80002b92:	40bc                	lw	a5,64(s1)
    80002b94:	cf99                	beqz	a5,80002bb2 <ilock+0x3e>
}
    80002b96:	60e2                	ld	ra,24(sp)
    80002b98:	6442                	ld	s0,16(sp)
    80002b9a:	64a2                	ld	s1,8(sp)
    80002b9c:	6105                	addi	sp,sp,32
    80002b9e:	8082                	ret
    80002ba0:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002ba2:	00006517          	auipc	a0,0x6
    80002ba6:	8ae50513          	addi	a0,a0,-1874 # 80008450 <etext+0x450>
    80002baa:	00003097          	auipc	ra,0x3
    80002bae:	362080e7          	jalr	866(ra) # 80005f0c <panic>
    80002bb2:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bb4:	40dc                	lw	a5,4(s1)
    80002bb6:	0047d79b          	srliw	a5,a5,0x4
    80002bba:	00010597          	auipc	a1,0x10
    80002bbe:	dc65a583          	lw	a1,-570(a1) # 80012980 <sb+0x18>
    80002bc2:	9dbd                	addw	a1,a1,a5
    80002bc4:	4088                	lw	a0,0(s1)
    80002bc6:	fffff097          	auipc	ra,0xfffff
    80002bca:	6e8080e7          	jalr	1768(ra) # 800022ae <bread>
    80002bce:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bd0:	05850593          	addi	a1,a0,88
    80002bd4:	40dc                	lw	a5,4(s1)
    80002bd6:	8bbd                	andi	a5,a5,15
    80002bd8:	079a                	slli	a5,a5,0x6
    80002bda:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bdc:	00059783          	lh	a5,0(a1)
    80002be0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002be4:	00259783          	lh	a5,2(a1)
    80002be8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bec:	00459783          	lh	a5,4(a1)
    80002bf0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bf4:	00659783          	lh	a5,6(a1)
    80002bf8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bfc:	459c                	lw	a5,8(a1)
    80002bfe:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c00:	03400613          	li	a2,52
    80002c04:	05b1                	addi	a1,a1,12
    80002c06:	05048513          	addi	a0,s1,80
    80002c0a:	ffffd097          	auipc	ra,0xffffd
    80002c0e:	5cc080e7          	jalr	1484(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c12:	854a                	mv	a0,s2
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	7ca080e7          	jalr	1994(ra) # 800023de <brelse>
    ip->valid = 1;
    80002c1c:	4785                	li	a5,1
    80002c1e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c20:	04449783          	lh	a5,68(s1)
    80002c24:	c399                	beqz	a5,80002c2a <ilock+0xb6>
    80002c26:	6902                	ld	s2,0(sp)
    80002c28:	b7bd                	j	80002b96 <ilock+0x22>
      panic("ilock: no type");
    80002c2a:	00006517          	auipc	a0,0x6
    80002c2e:	82e50513          	addi	a0,a0,-2002 # 80008458 <etext+0x458>
    80002c32:	00003097          	auipc	ra,0x3
    80002c36:	2da080e7          	jalr	730(ra) # 80005f0c <panic>

0000000080002c3a <iunlock>:
{
    80002c3a:	1101                	addi	sp,sp,-32
    80002c3c:	ec06                	sd	ra,24(sp)
    80002c3e:	e822                	sd	s0,16(sp)
    80002c40:	e426                	sd	s1,8(sp)
    80002c42:	e04a                	sd	s2,0(sp)
    80002c44:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c46:	c905                	beqz	a0,80002c76 <iunlock+0x3c>
    80002c48:	84aa                	mv	s1,a0
    80002c4a:	01050913          	addi	s2,a0,16
    80002c4e:	854a                	mv	a0,s2
    80002c50:	00001097          	auipc	ra,0x1
    80002c54:	d36080e7          	jalr	-714(ra) # 80003986 <holdingsleep>
    80002c58:	cd19                	beqz	a0,80002c76 <iunlock+0x3c>
    80002c5a:	449c                	lw	a5,8(s1)
    80002c5c:	00f05d63          	blez	a5,80002c76 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c60:	854a                	mv	a0,s2
    80002c62:	00001097          	auipc	ra,0x1
    80002c66:	ce0080e7          	jalr	-800(ra) # 80003942 <releasesleep>
}
    80002c6a:	60e2                	ld	ra,24(sp)
    80002c6c:	6442                	ld	s0,16(sp)
    80002c6e:	64a2                	ld	s1,8(sp)
    80002c70:	6902                	ld	s2,0(sp)
    80002c72:	6105                	addi	sp,sp,32
    80002c74:	8082                	ret
    panic("iunlock");
    80002c76:	00005517          	auipc	a0,0x5
    80002c7a:	7f250513          	addi	a0,a0,2034 # 80008468 <etext+0x468>
    80002c7e:	00003097          	auipc	ra,0x3
    80002c82:	28e080e7          	jalr	654(ra) # 80005f0c <panic>

0000000080002c86 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c86:	715d                	addi	sp,sp,-80
    80002c88:	e486                	sd	ra,72(sp)
    80002c8a:	e0a2                	sd	s0,64(sp)
    80002c8c:	fc26                	sd	s1,56(sp)
    80002c8e:	f84a                	sd	s2,48(sp)
    80002c90:	f44e                	sd	s3,40(sp)
    80002c92:	0880                	addi	s0,sp,80
    80002c94:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp,*subbp;
  uint *a,*suba;

  for(i = 0; i < NDIRECT; i++){
    80002c96:	05050493          	addi	s1,a0,80
    80002c9a:	07c50913          	addi	s2,a0,124
    80002c9e:	a021                	j	80002ca6 <itrunc+0x20>
    80002ca0:	0491                	addi	s1,s1,4
    80002ca2:	01248d63          	beq	s1,s2,80002cbc <itrunc+0x36>
    if(ip->addrs[i]){
    80002ca6:	408c                	lw	a1,0(s1)
    80002ca8:	dde5                	beqz	a1,80002ca0 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002caa:	0009a503          	lw	a0,0(s3)
    80002cae:	00000097          	auipc	ra,0x0
    80002cb2:	844080e7          	jalr	-1980(ra) # 800024f2 <bfree>
      ip->addrs[i] = 0;
    80002cb6:	0004a023          	sw	zero,0(s1)
    80002cba:	b7dd                	j	80002ca0 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cbc:	07c9a583          	lw	a1,124(s3)
    80002cc0:	e195                	bnez	a1,80002ce4 <itrunc+0x5e>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  
  
   if(ip->addrs[NDIRECT+1]){
    80002cc2:	0809a583          	lw	a1,128(s3)
    80002cc6:	e9ad                	bnez	a1,80002d38 <itrunc+0xb2>
         brelse(bp);
         bfree(ip->dev, ip->addrs[NDIRECT+1]);
         ip->addrs[NDIRECT+1] = 0;
     }

  ip->size = 0;
    80002cc8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ccc:	854e                	mv	a0,s3
    80002cce:	00000097          	auipc	ra,0x0
    80002cd2:	dda080e7          	jalr	-550(ra) # 80002aa8 <iupdate>
}
    80002cd6:	60a6                	ld	ra,72(sp)
    80002cd8:	6406                	ld	s0,64(sp)
    80002cda:	74e2                	ld	s1,56(sp)
    80002cdc:	7942                	ld	s2,48(sp)
    80002cde:	79a2                	ld	s3,40(sp)
    80002ce0:	6161                	addi	sp,sp,80
    80002ce2:	8082                	ret
    80002ce4:	f052                	sd	s4,32(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ce6:	0009a503          	lw	a0,0(s3)
    80002cea:	fffff097          	auipc	ra,0xfffff
    80002cee:	5c4080e7          	jalr	1476(ra) # 800022ae <bread>
    80002cf2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cf4:	05850493          	addi	s1,a0,88
    80002cf8:	45850913          	addi	s2,a0,1112
    80002cfc:	a021                	j	80002d04 <itrunc+0x7e>
    80002cfe:	0491                	addi	s1,s1,4
    80002d00:	01248b63          	beq	s1,s2,80002d16 <itrunc+0x90>
      if(a[j])
    80002d04:	408c                	lw	a1,0(s1)
    80002d06:	dde5                	beqz	a1,80002cfe <itrunc+0x78>
        bfree(ip->dev, a[j]);
    80002d08:	0009a503          	lw	a0,0(s3)
    80002d0c:	fffff097          	auipc	ra,0xfffff
    80002d10:	7e6080e7          	jalr	2022(ra) # 800024f2 <bfree>
    80002d14:	b7ed                	j	80002cfe <itrunc+0x78>
    brelse(bp);
    80002d16:	8552                	mv	a0,s4
    80002d18:	fffff097          	auipc	ra,0xfffff
    80002d1c:	6c6080e7          	jalr	1734(ra) # 800023de <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d20:	07c9a583          	lw	a1,124(s3)
    80002d24:	0009a503          	lw	a0,0(s3)
    80002d28:	fffff097          	auipc	ra,0xfffff
    80002d2c:	7ca080e7          	jalr	1994(ra) # 800024f2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d30:	0609ae23          	sw	zero,124(s3)
    80002d34:	7a02                	ld	s4,32(sp)
    80002d36:	b771                	j	80002cc2 <itrunc+0x3c>
    80002d38:	f052                	sd	s4,32(sp)
    80002d3a:	ec56                	sd	s5,24(sp)
    80002d3c:	e85a                	sd	s6,16(sp)
    80002d3e:	e45e                	sd	s7,8(sp)
    80002d40:	e062                	sd	s8,0(sp)
         bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
    80002d42:	0009a503          	lw	a0,0(s3)
    80002d46:	fffff097          	auipc	ra,0xfffff
    80002d4a:	568080e7          	jalr	1384(ra) # 800022ae <bread>
    80002d4e:	8c2a                	mv	s8,a0
         for(i = 0; i < NINDIRECT; i++){
    80002d50:	05850a13          	addi	s4,a0,88
    80002d54:	45850b13          	addi	s6,a0,1112
    80002d58:	a83d                	j	80002d96 <itrunc+0x110>
                 for(j = 0; j < NINDIRECT; j++){
    80002d5a:	0491                	addi	s1,s1,4
    80002d5c:	01248b63          	beq	s1,s2,80002d72 <itrunc+0xec>
                     if(suba[j])
    80002d60:	408c                	lw	a1,0(s1)
    80002d62:	dde5                	beqz	a1,80002d5a <itrunc+0xd4>
                         bfree(ip->dev,suba[j]);
    80002d64:	0009a503          	lw	a0,0(s3)
    80002d68:	fffff097          	auipc	ra,0xfffff
    80002d6c:	78a080e7          	jalr	1930(ra) # 800024f2 <bfree>
    80002d70:	b7ed                	j	80002d5a <itrunc+0xd4>
                 brelse(subbp);
    80002d72:	855e                	mv	a0,s7
    80002d74:	fffff097          	auipc	ra,0xfffff
    80002d78:	66a080e7          	jalr	1642(ra) # 800023de <brelse>
                 bfree(ip->dev,a[i]);
    80002d7c:	000aa583          	lw	a1,0(s5)
    80002d80:	0009a503          	lw	a0,0(s3)
    80002d84:	fffff097          	auipc	ra,0xfffff
    80002d88:	76e080e7          	jalr	1902(ra) # 800024f2 <bfree>
                 a[i] = 0;
    80002d8c:	000aa023          	sw	zero,0(s5)
         for(i = 0; i < NINDIRECT; i++){
    80002d90:	0a11                	addi	s4,s4,4
    80002d92:	036a0263          	beq	s4,s6,80002db6 <itrunc+0x130>
             if(a[i]){
    80002d96:	8ad2                	mv	s5,s4
    80002d98:	000a2583          	lw	a1,0(s4)
    80002d9c:	d9f5                	beqz	a1,80002d90 <itrunc+0x10a>
                 subbp = bread(ip->dev,a[i]);
    80002d9e:	0009a503          	lw	a0,0(s3)
    80002da2:	fffff097          	auipc	ra,0xfffff
    80002da6:	50c080e7          	jalr	1292(ra) # 800022ae <bread>
    80002daa:	8baa                	mv	s7,a0
                 for(j = 0; j < NINDIRECT; j++){
    80002dac:	05850493          	addi	s1,a0,88
    80002db0:	45850913          	addi	s2,a0,1112
    80002db4:	b775                	j	80002d60 <itrunc+0xda>
         brelse(bp);
    80002db6:	8562                	mv	a0,s8
    80002db8:	fffff097          	auipc	ra,0xfffff
    80002dbc:	626080e7          	jalr	1574(ra) # 800023de <brelse>
         bfree(ip->dev, ip->addrs[NDIRECT+1]);
    80002dc0:	0809a583          	lw	a1,128(s3)
    80002dc4:	0009a503          	lw	a0,0(s3)
    80002dc8:	fffff097          	auipc	ra,0xfffff
    80002dcc:	72a080e7          	jalr	1834(ra) # 800024f2 <bfree>
         ip->addrs[NDIRECT+1] = 0;
    80002dd0:	0809a023          	sw	zero,128(s3)
    80002dd4:	7a02                	ld	s4,32(sp)
    80002dd6:	6ae2                	ld	s5,24(sp)
    80002dd8:	6b42                	ld	s6,16(sp)
    80002dda:	6ba2                	ld	s7,8(sp)
    80002ddc:	6c02                	ld	s8,0(sp)
    80002dde:	b5ed                	j	80002cc8 <itrunc+0x42>

0000000080002de0 <iput>:
{
    80002de0:	1101                	addi	sp,sp,-32
    80002de2:	ec06                	sd	ra,24(sp)
    80002de4:	e822                	sd	s0,16(sp)
    80002de6:	e426                	sd	s1,8(sp)
    80002de8:	1000                	addi	s0,sp,32
    80002dea:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dec:	00010517          	auipc	a0,0x10
    80002df0:	b9c50513          	addi	a0,a0,-1124 # 80012988 <itable>
    80002df4:	00003097          	auipc	ra,0x3
    80002df8:	692080e7          	jalr	1682(ra) # 80006486 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dfc:	4498                	lw	a4,8(s1)
    80002dfe:	4785                	li	a5,1
    80002e00:	02f70263          	beq	a4,a5,80002e24 <iput+0x44>
  ip->ref--;
    80002e04:	449c                	lw	a5,8(s1)
    80002e06:	37fd                	addiw	a5,a5,-1
    80002e08:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e0a:	00010517          	auipc	a0,0x10
    80002e0e:	b7e50513          	addi	a0,a0,-1154 # 80012988 <itable>
    80002e12:	00003097          	auipc	ra,0x3
    80002e16:	728080e7          	jalr	1832(ra) # 8000653a <release>
}
    80002e1a:	60e2                	ld	ra,24(sp)
    80002e1c:	6442                	ld	s0,16(sp)
    80002e1e:	64a2                	ld	s1,8(sp)
    80002e20:	6105                	addi	sp,sp,32
    80002e22:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e24:	40bc                	lw	a5,64(s1)
    80002e26:	dff9                	beqz	a5,80002e04 <iput+0x24>
    80002e28:	04a49783          	lh	a5,74(s1)
    80002e2c:	ffe1                	bnez	a5,80002e04 <iput+0x24>
    80002e2e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e30:	01048913          	addi	s2,s1,16
    80002e34:	854a                	mv	a0,s2
    80002e36:	00001097          	auipc	ra,0x1
    80002e3a:	ab6080e7          	jalr	-1354(ra) # 800038ec <acquiresleep>
    release(&itable.lock);
    80002e3e:	00010517          	auipc	a0,0x10
    80002e42:	b4a50513          	addi	a0,a0,-1206 # 80012988 <itable>
    80002e46:	00003097          	auipc	ra,0x3
    80002e4a:	6f4080e7          	jalr	1780(ra) # 8000653a <release>
    itrunc(ip);
    80002e4e:	8526                	mv	a0,s1
    80002e50:	00000097          	auipc	ra,0x0
    80002e54:	e36080e7          	jalr	-458(ra) # 80002c86 <itrunc>
    ip->type = 0;
    80002e58:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e5c:	8526                	mv	a0,s1
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	c4a080e7          	jalr	-950(ra) # 80002aa8 <iupdate>
    ip->valid = 0;
    80002e66:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e6a:	854a                	mv	a0,s2
    80002e6c:	00001097          	auipc	ra,0x1
    80002e70:	ad6080e7          	jalr	-1322(ra) # 80003942 <releasesleep>
    acquire(&itable.lock);
    80002e74:	00010517          	auipc	a0,0x10
    80002e78:	b1450513          	addi	a0,a0,-1260 # 80012988 <itable>
    80002e7c:	00003097          	auipc	ra,0x3
    80002e80:	60a080e7          	jalr	1546(ra) # 80006486 <acquire>
    80002e84:	6902                	ld	s2,0(sp)
    80002e86:	bfbd                	j	80002e04 <iput+0x24>

0000000080002e88 <iunlockput>:
{
    80002e88:	1101                	addi	sp,sp,-32
    80002e8a:	ec06                	sd	ra,24(sp)
    80002e8c:	e822                	sd	s0,16(sp)
    80002e8e:	e426                	sd	s1,8(sp)
    80002e90:	1000                	addi	s0,sp,32
    80002e92:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	da6080e7          	jalr	-602(ra) # 80002c3a <iunlock>
  iput(ip);
    80002e9c:	8526                	mv	a0,s1
    80002e9e:	00000097          	auipc	ra,0x0
    80002ea2:	f42080e7          	jalr	-190(ra) # 80002de0 <iput>
}
    80002ea6:	60e2                	ld	ra,24(sp)
    80002ea8:	6442                	ld	s0,16(sp)
    80002eaa:	64a2                	ld	s1,8(sp)
    80002eac:	6105                	addi	sp,sp,32
    80002eae:	8082                	ret

0000000080002eb0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002eb0:	1141                	addi	sp,sp,-16
    80002eb2:	e422                	sd	s0,8(sp)
    80002eb4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002eb6:	411c                	lw	a5,0(a0)
    80002eb8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002eba:	415c                	lw	a5,4(a0)
    80002ebc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ebe:	04451783          	lh	a5,68(a0)
    80002ec2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ec6:	04a51783          	lh	a5,74(a0)
    80002eca:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ece:	04c56783          	lwu	a5,76(a0)
    80002ed2:	e99c                	sd	a5,16(a1)
}
    80002ed4:	6422                	ld	s0,8(sp)
    80002ed6:	0141                	addi	sp,sp,16
    80002ed8:	8082                	ret

0000000080002eda <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eda:	457c                	lw	a5,76(a0)
    80002edc:	0ed7ef63          	bltu	a5,a3,80002fda <readi+0x100>
{
    80002ee0:	7159                	addi	sp,sp,-112
    80002ee2:	f486                	sd	ra,104(sp)
    80002ee4:	f0a2                	sd	s0,96(sp)
    80002ee6:	eca6                	sd	s1,88(sp)
    80002ee8:	fc56                	sd	s5,56(sp)
    80002eea:	f85a                	sd	s6,48(sp)
    80002eec:	f45e                	sd	s7,40(sp)
    80002eee:	f062                	sd	s8,32(sp)
    80002ef0:	1880                	addi	s0,sp,112
    80002ef2:	8baa                	mv	s7,a0
    80002ef4:	8c2e                	mv	s8,a1
    80002ef6:	8ab2                	mv	s5,a2
    80002ef8:	84b6                	mv	s1,a3
    80002efa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002efc:	9f35                	addw	a4,a4,a3
    return 0;
    80002efe:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f00:	0ad76c63          	bltu	a4,a3,80002fb8 <readi+0xde>
    80002f04:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002f06:	00e7f463          	bgeu	a5,a4,80002f0e <readi+0x34>
    n = ip->size - off;
    80002f0a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f0e:	0c0b0463          	beqz	s6,80002fd6 <readi+0xfc>
    80002f12:	e8ca                	sd	s2,80(sp)
    80002f14:	e0d2                	sd	s4,64(sp)
    80002f16:	ec66                	sd	s9,24(sp)
    80002f18:	e86a                	sd	s10,16(sp)
    80002f1a:	e46e                	sd	s11,8(sp)
    80002f1c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f1e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f22:	5cfd                	li	s9,-1
    80002f24:	a82d                	j	80002f5e <readi+0x84>
    80002f26:	020a1d93          	slli	s11,s4,0x20
    80002f2a:	020ddd93          	srli	s11,s11,0x20
    80002f2e:	05890613          	addi	a2,s2,88
    80002f32:	86ee                	mv	a3,s11
    80002f34:	963a                	add	a2,a2,a4
    80002f36:	85d6                	mv	a1,s5
    80002f38:	8562                	mv	a0,s8
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	9a6080e7          	jalr	-1626(ra) # 800018e0 <either_copyout>
    80002f42:	05950d63          	beq	a0,s9,80002f9c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f46:	854a                	mv	a0,s2
    80002f48:	fffff097          	auipc	ra,0xfffff
    80002f4c:	496080e7          	jalr	1174(ra) # 800023de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f50:	013a09bb          	addw	s3,s4,s3
    80002f54:	009a04bb          	addw	s1,s4,s1
    80002f58:	9aee                	add	s5,s5,s11
    80002f5a:	0769f863          	bgeu	s3,s6,80002fca <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f5e:	000ba903          	lw	s2,0(s7)
    80002f62:	00a4d59b          	srliw	a1,s1,0xa
    80002f66:	855e                	mv	a0,s7
    80002f68:	fffff097          	auipc	ra,0xfffff
    80002f6c:	734080e7          	jalr	1844(ra) # 8000269c <bmap>
    80002f70:	0005059b          	sext.w	a1,a0
    80002f74:	854a                	mv	a0,s2
    80002f76:	fffff097          	auipc	ra,0xfffff
    80002f7a:	338080e7          	jalr	824(ra) # 800022ae <bread>
    80002f7e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f80:	3ff4f713          	andi	a4,s1,1023
    80002f84:	40ed07bb          	subw	a5,s10,a4
    80002f88:	413b06bb          	subw	a3,s6,s3
    80002f8c:	8a3e                	mv	s4,a5
    80002f8e:	2781                	sext.w	a5,a5
    80002f90:	0006861b          	sext.w	a2,a3
    80002f94:	f8f679e3          	bgeu	a2,a5,80002f26 <readi+0x4c>
    80002f98:	8a36                	mv	s4,a3
    80002f9a:	b771                	j	80002f26 <readi+0x4c>
      brelse(bp);
    80002f9c:	854a                	mv	a0,s2
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	440080e7          	jalr	1088(ra) # 800023de <brelse>
      tot = -1;
    80002fa6:	59fd                	li	s3,-1
      break;
    80002fa8:	6946                	ld	s2,80(sp)
    80002faa:	6a06                	ld	s4,64(sp)
    80002fac:	6ce2                	ld	s9,24(sp)
    80002fae:	6d42                	ld	s10,16(sp)
    80002fb0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002fb2:	0009851b          	sext.w	a0,s3
    80002fb6:	69a6                	ld	s3,72(sp)
}
    80002fb8:	70a6                	ld	ra,104(sp)
    80002fba:	7406                	ld	s0,96(sp)
    80002fbc:	64e6                	ld	s1,88(sp)
    80002fbe:	7ae2                	ld	s5,56(sp)
    80002fc0:	7b42                	ld	s6,48(sp)
    80002fc2:	7ba2                	ld	s7,40(sp)
    80002fc4:	7c02                	ld	s8,32(sp)
    80002fc6:	6165                	addi	sp,sp,112
    80002fc8:	8082                	ret
    80002fca:	6946                	ld	s2,80(sp)
    80002fcc:	6a06                	ld	s4,64(sp)
    80002fce:	6ce2                	ld	s9,24(sp)
    80002fd0:	6d42                	ld	s10,16(sp)
    80002fd2:	6da2                	ld	s11,8(sp)
    80002fd4:	bff9                	j	80002fb2 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fd6:	89da                	mv	s3,s6
    80002fd8:	bfe9                	j	80002fb2 <readi+0xd8>
    return 0;
    80002fda:	4501                	li	a0,0
}
    80002fdc:	8082                	ret

0000000080002fde <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fde:	457c                	lw	a5,76(a0)
    80002fe0:	10d7ef63          	bltu	a5,a3,800030fe <writei+0x120>
{
    80002fe4:	7159                	addi	sp,sp,-112
    80002fe6:	f486                	sd	ra,104(sp)
    80002fe8:	f0a2                	sd	s0,96(sp)
    80002fea:	e8ca                	sd	s2,80(sp)
    80002fec:	fc56                	sd	s5,56(sp)
    80002fee:	f85a                	sd	s6,48(sp)
    80002ff0:	f45e                	sd	s7,40(sp)
    80002ff2:	f062                	sd	s8,32(sp)
    80002ff4:	1880                	addi	s0,sp,112
    80002ff6:	8b2a                	mv	s6,a0
    80002ff8:	8c2e                	mv	s8,a1
    80002ffa:	8ab2                	mv	s5,a2
    80002ffc:	8936                	mv	s2,a3
    80002ffe:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003000:	9f35                	addw	a4,a4,a3
    80003002:	10d76063          	bltu	a4,a3,80003102 <writei+0x124>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003006:	040437b7          	lui	a5,0x4043
    8000300a:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    8000300e:	0ee7ec63          	bltu	a5,a4,80003106 <writei+0x128>
    80003012:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003014:	0c0b8d63          	beqz	s7,800030ee <writei+0x110>
    80003018:	eca6                	sd	s1,88(sp)
    8000301a:	e4ce                	sd	s3,72(sp)
    8000301c:	ec66                	sd	s9,24(sp)
    8000301e:	e86a                	sd	s10,16(sp)
    80003020:	e46e                	sd	s11,8(sp)
    80003022:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003024:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003028:	5cfd                	li	s9,-1
    8000302a:	a091                	j	8000306e <writei+0x90>
    8000302c:	02099d93          	slli	s11,s3,0x20
    80003030:	020ddd93          	srli	s11,s11,0x20
    80003034:	05848513          	addi	a0,s1,88
    80003038:	86ee                	mv	a3,s11
    8000303a:	8656                	mv	a2,s5
    8000303c:	85e2                	mv	a1,s8
    8000303e:	953a                	add	a0,a0,a4
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	8f6080e7          	jalr	-1802(ra) # 80001936 <either_copyin>
    80003048:	07950263          	beq	a0,s9,800030ac <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000304c:	8526                	mv	a0,s1
    8000304e:	00000097          	auipc	ra,0x0
    80003052:	780080e7          	jalr	1920(ra) # 800037ce <log_write>
    brelse(bp);
    80003056:	8526                	mv	a0,s1
    80003058:	fffff097          	auipc	ra,0xfffff
    8000305c:	386080e7          	jalr	902(ra) # 800023de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003060:	01498a3b          	addw	s4,s3,s4
    80003064:	0129893b          	addw	s2,s3,s2
    80003068:	9aee                	add	s5,s5,s11
    8000306a:	057a7663          	bgeu	s4,s7,800030b6 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000306e:	000b2483          	lw	s1,0(s6)
    80003072:	00a9559b          	srliw	a1,s2,0xa
    80003076:	855a                	mv	a0,s6
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	624080e7          	jalr	1572(ra) # 8000269c <bmap>
    80003080:	0005059b          	sext.w	a1,a0
    80003084:	8526                	mv	a0,s1
    80003086:	fffff097          	auipc	ra,0xfffff
    8000308a:	228080e7          	jalr	552(ra) # 800022ae <bread>
    8000308e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003090:	3ff97713          	andi	a4,s2,1023
    80003094:	40ed07bb          	subw	a5,s10,a4
    80003098:	414b86bb          	subw	a3,s7,s4
    8000309c:	89be                	mv	s3,a5
    8000309e:	2781                	sext.w	a5,a5
    800030a0:	0006861b          	sext.w	a2,a3
    800030a4:	f8f674e3          	bgeu	a2,a5,8000302c <writei+0x4e>
    800030a8:	89b6                	mv	s3,a3
    800030aa:	b749                	j	8000302c <writei+0x4e>
      brelse(bp);
    800030ac:	8526                	mv	a0,s1
    800030ae:	fffff097          	auipc	ra,0xfffff
    800030b2:	330080e7          	jalr	816(ra) # 800023de <brelse>
  }

  if(off > ip->size)
    800030b6:	04cb2783          	lw	a5,76(s6)
    800030ba:	0327fc63          	bgeu	a5,s2,800030f2 <writei+0x114>
    ip->size = off;
    800030be:	052b2623          	sw	s2,76(s6)
    800030c2:	64e6                	ld	s1,88(sp)
    800030c4:	69a6                	ld	s3,72(sp)
    800030c6:	6ce2                	ld	s9,24(sp)
    800030c8:	6d42                	ld	s10,16(sp)
    800030ca:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030cc:	855a                	mv	a0,s6
    800030ce:	00000097          	auipc	ra,0x0
    800030d2:	9da080e7          	jalr	-1574(ra) # 80002aa8 <iupdate>

  return tot;
    800030d6:	000a051b          	sext.w	a0,s4
    800030da:	6a06                	ld	s4,64(sp)
}
    800030dc:	70a6                	ld	ra,104(sp)
    800030de:	7406                	ld	s0,96(sp)
    800030e0:	6946                	ld	s2,80(sp)
    800030e2:	7ae2                	ld	s5,56(sp)
    800030e4:	7b42                	ld	s6,48(sp)
    800030e6:	7ba2                	ld	s7,40(sp)
    800030e8:	7c02                	ld	s8,32(sp)
    800030ea:	6165                	addi	sp,sp,112
    800030ec:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ee:	8a5e                	mv	s4,s7
    800030f0:	bff1                	j	800030cc <writei+0xee>
    800030f2:	64e6                	ld	s1,88(sp)
    800030f4:	69a6                	ld	s3,72(sp)
    800030f6:	6ce2                	ld	s9,24(sp)
    800030f8:	6d42                	ld	s10,16(sp)
    800030fa:	6da2                	ld	s11,8(sp)
    800030fc:	bfc1                	j	800030cc <writei+0xee>
    return -1;
    800030fe:	557d                	li	a0,-1
}
    80003100:	8082                	ret
    return -1;
    80003102:	557d                	li	a0,-1
    80003104:	bfe1                	j	800030dc <writei+0xfe>
    return -1;
    80003106:	557d                	li	a0,-1
    80003108:	bfd1                	j	800030dc <writei+0xfe>

000000008000310a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000310a:	1141                	addi	sp,sp,-16
    8000310c:	e406                	sd	ra,8(sp)
    8000310e:	e022                	sd	s0,0(sp)
    80003110:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003112:	4639                	li	a2,14
    80003114:	ffffd097          	auipc	ra,0xffffd
    80003118:	136080e7          	jalr	310(ra) # 8000024a <strncmp>
}
    8000311c:	60a2                	ld	ra,8(sp)
    8000311e:	6402                	ld	s0,0(sp)
    80003120:	0141                	addi	sp,sp,16
    80003122:	8082                	ret

0000000080003124 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003124:	7139                	addi	sp,sp,-64
    80003126:	fc06                	sd	ra,56(sp)
    80003128:	f822                	sd	s0,48(sp)
    8000312a:	f426                	sd	s1,40(sp)
    8000312c:	f04a                	sd	s2,32(sp)
    8000312e:	ec4e                	sd	s3,24(sp)
    80003130:	e852                	sd	s4,16(sp)
    80003132:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003134:	04451703          	lh	a4,68(a0)
    80003138:	4785                	li	a5,1
    8000313a:	00f71a63          	bne	a4,a5,8000314e <dirlookup+0x2a>
    8000313e:	892a                	mv	s2,a0
    80003140:	89ae                	mv	s3,a1
    80003142:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003144:	457c                	lw	a5,76(a0)
    80003146:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003148:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000314a:	e79d                	bnez	a5,80003178 <dirlookup+0x54>
    8000314c:	a8a5                	j	800031c4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000314e:	00005517          	auipc	a0,0x5
    80003152:	32250513          	addi	a0,a0,802 # 80008470 <etext+0x470>
    80003156:	00003097          	auipc	ra,0x3
    8000315a:	db6080e7          	jalr	-586(ra) # 80005f0c <panic>
      panic("dirlookup read");
    8000315e:	00005517          	auipc	a0,0x5
    80003162:	32a50513          	addi	a0,a0,810 # 80008488 <etext+0x488>
    80003166:	00003097          	auipc	ra,0x3
    8000316a:	da6080e7          	jalr	-602(ra) # 80005f0c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000316e:	24c1                	addiw	s1,s1,16
    80003170:	04c92783          	lw	a5,76(s2)
    80003174:	04f4f763          	bgeu	s1,a5,800031c2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003178:	4741                	li	a4,16
    8000317a:	86a6                	mv	a3,s1
    8000317c:	fc040613          	addi	a2,s0,-64
    80003180:	4581                	li	a1,0
    80003182:	854a                	mv	a0,s2
    80003184:	00000097          	auipc	ra,0x0
    80003188:	d56080e7          	jalr	-682(ra) # 80002eda <readi>
    8000318c:	47c1                	li	a5,16
    8000318e:	fcf518e3          	bne	a0,a5,8000315e <dirlookup+0x3a>
    if(de.inum == 0)
    80003192:	fc045783          	lhu	a5,-64(s0)
    80003196:	dfe1                	beqz	a5,8000316e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003198:	fc240593          	addi	a1,s0,-62
    8000319c:	854e                	mv	a0,s3
    8000319e:	00000097          	auipc	ra,0x0
    800031a2:	f6c080e7          	jalr	-148(ra) # 8000310a <namecmp>
    800031a6:	f561                	bnez	a0,8000316e <dirlookup+0x4a>
      if(poff)
    800031a8:	000a0463          	beqz	s4,800031b0 <dirlookup+0x8c>
        *poff = off;
    800031ac:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031b0:	fc045583          	lhu	a1,-64(s0)
    800031b4:	00092503          	lw	a0,0(s2)
    800031b8:	fffff097          	auipc	ra,0xfffff
    800031bc:	68c080e7          	jalr	1676(ra) # 80002844 <iget>
    800031c0:	a011                	j	800031c4 <dirlookup+0xa0>
  return 0;
    800031c2:	4501                	li	a0,0
}
    800031c4:	70e2                	ld	ra,56(sp)
    800031c6:	7442                	ld	s0,48(sp)
    800031c8:	74a2                	ld	s1,40(sp)
    800031ca:	7902                	ld	s2,32(sp)
    800031cc:	69e2                	ld	s3,24(sp)
    800031ce:	6a42                	ld	s4,16(sp)
    800031d0:	6121                	addi	sp,sp,64
    800031d2:	8082                	ret

00000000800031d4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031d4:	711d                	addi	sp,sp,-96
    800031d6:	ec86                	sd	ra,88(sp)
    800031d8:	e8a2                	sd	s0,80(sp)
    800031da:	e4a6                	sd	s1,72(sp)
    800031dc:	e0ca                	sd	s2,64(sp)
    800031de:	fc4e                	sd	s3,56(sp)
    800031e0:	f852                	sd	s4,48(sp)
    800031e2:	f456                	sd	s5,40(sp)
    800031e4:	f05a                	sd	s6,32(sp)
    800031e6:	ec5e                	sd	s7,24(sp)
    800031e8:	e862                	sd	s8,16(sp)
    800031ea:	e466                	sd	s9,8(sp)
    800031ec:	1080                	addi	s0,sp,96
    800031ee:	84aa                	mv	s1,a0
    800031f0:	8b2e                	mv	s6,a1
    800031f2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031f4:	00054703          	lbu	a4,0(a0)
    800031f8:	02f00793          	li	a5,47
    800031fc:	02f70263          	beq	a4,a5,80003220 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003200:	ffffe097          	auipc	ra,0xffffe
    80003204:	c7c080e7          	jalr	-900(ra) # 80000e7c <myproc>
    80003208:	15053503          	ld	a0,336(a0)
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	92a080e7          	jalr	-1750(ra) # 80002b36 <idup>
    80003214:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003216:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000321a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000321c:	4b85                	li	s7,1
    8000321e:	a875                	j	800032da <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003220:	4585                	li	a1,1
    80003222:	4505                	li	a0,1
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	620080e7          	jalr	1568(ra) # 80002844 <iget>
    8000322c:	8a2a                	mv	s4,a0
    8000322e:	b7e5                	j	80003216 <namex+0x42>
      iunlockput(ip);
    80003230:	8552                	mv	a0,s4
    80003232:	00000097          	auipc	ra,0x0
    80003236:	c56080e7          	jalr	-938(ra) # 80002e88 <iunlockput>
      return 0;
    8000323a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000323c:	8552                	mv	a0,s4
    8000323e:	60e6                	ld	ra,88(sp)
    80003240:	6446                	ld	s0,80(sp)
    80003242:	64a6                	ld	s1,72(sp)
    80003244:	6906                	ld	s2,64(sp)
    80003246:	79e2                	ld	s3,56(sp)
    80003248:	7a42                	ld	s4,48(sp)
    8000324a:	7aa2                	ld	s5,40(sp)
    8000324c:	7b02                	ld	s6,32(sp)
    8000324e:	6be2                	ld	s7,24(sp)
    80003250:	6c42                	ld	s8,16(sp)
    80003252:	6ca2                	ld	s9,8(sp)
    80003254:	6125                	addi	sp,sp,96
    80003256:	8082                	ret
      iunlock(ip);
    80003258:	8552                	mv	a0,s4
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	9e0080e7          	jalr	-1568(ra) # 80002c3a <iunlock>
      return ip;
    80003262:	bfe9                	j	8000323c <namex+0x68>
      iunlockput(ip);
    80003264:	8552                	mv	a0,s4
    80003266:	00000097          	auipc	ra,0x0
    8000326a:	c22080e7          	jalr	-990(ra) # 80002e88 <iunlockput>
      return 0;
    8000326e:	8a4e                	mv	s4,s3
    80003270:	b7f1                	j	8000323c <namex+0x68>
  len = path - s;
    80003272:	40998633          	sub	a2,s3,s1
    80003276:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000327a:	099c5863          	bge	s8,s9,8000330a <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000327e:	4639                	li	a2,14
    80003280:	85a6                	mv	a1,s1
    80003282:	8556                	mv	a0,s5
    80003284:	ffffd097          	auipc	ra,0xffffd
    80003288:	f52080e7          	jalr	-174(ra) # 800001d6 <memmove>
    8000328c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000328e:	0004c783          	lbu	a5,0(s1)
    80003292:	01279763          	bne	a5,s2,800032a0 <namex+0xcc>
    path++;
    80003296:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003298:	0004c783          	lbu	a5,0(s1)
    8000329c:	ff278de3          	beq	a5,s2,80003296 <namex+0xc2>
    ilock(ip);
    800032a0:	8552                	mv	a0,s4
    800032a2:	00000097          	auipc	ra,0x0
    800032a6:	8d2080e7          	jalr	-1838(ra) # 80002b74 <ilock>
    if(ip->type != T_DIR){
    800032aa:	044a1783          	lh	a5,68(s4)
    800032ae:	f97791e3          	bne	a5,s7,80003230 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800032b2:	000b0563          	beqz	s6,800032bc <namex+0xe8>
    800032b6:	0004c783          	lbu	a5,0(s1)
    800032ba:	dfd9                	beqz	a5,80003258 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032bc:	4601                	li	a2,0
    800032be:	85d6                	mv	a1,s5
    800032c0:	8552                	mv	a0,s4
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	e62080e7          	jalr	-414(ra) # 80003124 <dirlookup>
    800032ca:	89aa                	mv	s3,a0
    800032cc:	dd41                	beqz	a0,80003264 <namex+0x90>
    iunlockput(ip);
    800032ce:	8552                	mv	a0,s4
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	bb8080e7          	jalr	-1096(ra) # 80002e88 <iunlockput>
    ip = next;
    800032d8:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032da:	0004c783          	lbu	a5,0(s1)
    800032de:	01279763          	bne	a5,s2,800032ec <namex+0x118>
    path++;
    800032e2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032e4:	0004c783          	lbu	a5,0(s1)
    800032e8:	ff278de3          	beq	a5,s2,800032e2 <namex+0x10e>
  if(*path == 0)
    800032ec:	cb9d                	beqz	a5,80003322 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032ee:	0004c783          	lbu	a5,0(s1)
    800032f2:	89a6                	mv	s3,s1
  len = path - s;
    800032f4:	4c81                	li	s9,0
    800032f6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032f8:	01278963          	beq	a5,s2,8000330a <namex+0x136>
    800032fc:	dbbd                	beqz	a5,80003272 <namex+0x9e>
    path++;
    800032fe:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003300:	0009c783          	lbu	a5,0(s3)
    80003304:	ff279ce3          	bne	a5,s2,800032fc <namex+0x128>
    80003308:	b7ad                	j	80003272 <namex+0x9e>
    memmove(name, s, len);
    8000330a:	2601                	sext.w	a2,a2
    8000330c:	85a6                	mv	a1,s1
    8000330e:	8556                	mv	a0,s5
    80003310:	ffffd097          	auipc	ra,0xffffd
    80003314:	ec6080e7          	jalr	-314(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003318:	9cd6                	add	s9,s9,s5
    8000331a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000331e:	84ce                	mv	s1,s3
    80003320:	b7bd                	j	8000328e <namex+0xba>
  if(nameiparent){
    80003322:	f00b0de3          	beqz	s6,8000323c <namex+0x68>
    iput(ip);
    80003326:	8552                	mv	a0,s4
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	ab8080e7          	jalr	-1352(ra) # 80002de0 <iput>
    return 0;
    80003330:	4a01                	li	s4,0
    80003332:	b729                	j	8000323c <namex+0x68>

0000000080003334 <dirlink>:
{
    80003334:	7139                	addi	sp,sp,-64
    80003336:	fc06                	sd	ra,56(sp)
    80003338:	f822                	sd	s0,48(sp)
    8000333a:	f04a                	sd	s2,32(sp)
    8000333c:	ec4e                	sd	s3,24(sp)
    8000333e:	e852                	sd	s4,16(sp)
    80003340:	0080                	addi	s0,sp,64
    80003342:	892a                	mv	s2,a0
    80003344:	8a2e                	mv	s4,a1
    80003346:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003348:	4601                	li	a2,0
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	dda080e7          	jalr	-550(ra) # 80003124 <dirlookup>
    80003352:	ed25                	bnez	a0,800033ca <dirlink+0x96>
    80003354:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003356:	04c92483          	lw	s1,76(s2)
    8000335a:	c49d                	beqz	s1,80003388 <dirlink+0x54>
    8000335c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000335e:	4741                	li	a4,16
    80003360:	86a6                	mv	a3,s1
    80003362:	fc040613          	addi	a2,s0,-64
    80003366:	4581                	li	a1,0
    80003368:	854a                	mv	a0,s2
    8000336a:	00000097          	auipc	ra,0x0
    8000336e:	b70080e7          	jalr	-1168(ra) # 80002eda <readi>
    80003372:	47c1                	li	a5,16
    80003374:	06f51163          	bne	a0,a5,800033d6 <dirlink+0xa2>
    if(de.inum == 0)
    80003378:	fc045783          	lhu	a5,-64(s0)
    8000337c:	c791                	beqz	a5,80003388 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000337e:	24c1                	addiw	s1,s1,16
    80003380:	04c92783          	lw	a5,76(s2)
    80003384:	fcf4ede3          	bltu	s1,a5,8000335e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003388:	4639                	li	a2,14
    8000338a:	85d2                	mv	a1,s4
    8000338c:	fc240513          	addi	a0,s0,-62
    80003390:	ffffd097          	auipc	ra,0xffffd
    80003394:	ef0080e7          	jalr	-272(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003398:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000339c:	4741                	li	a4,16
    8000339e:	86a6                	mv	a3,s1
    800033a0:	fc040613          	addi	a2,s0,-64
    800033a4:	4581                	li	a1,0
    800033a6:	854a                	mv	a0,s2
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	c36080e7          	jalr	-970(ra) # 80002fde <writei>
    800033b0:	872a                	mv	a4,a0
    800033b2:	47c1                	li	a5,16
  return 0;
    800033b4:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033b6:	02f71863          	bne	a4,a5,800033e6 <dirlink+0xb2>
    800033ba:	74a2                	ld	s1,40(sp)
}
    800033bc:	70e2                	ld	ra,56(sp)
    800033be:	7442                	ld	s0,48(sp)
    800033c0:	7902                	ld	s2,32(sp)
    800033c2:	69e2                	ld	s3,24(sp)
    800033c4:	6a42                	ld	s4,16(sp)
    800033c6:	6121                	addi	sp,sp,64
    800033c8:	8082                	ret
    iput(ip);
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	a16080e7          	jalr	-1514(ra) # 80002de0 <iput>
    return -1;
    800033d2:	557d                	li	a0,-1
    800033d4:	b7e5                	j	800033bc <dirlink+0x88>
      panic("dirlink read");
    800033d6:	00005517          	auipc	a0,0x5
    800033da:	0c250513          	addi	a0,a0,194 # 80008498 <etext+0x498>
    800033de:	00003097          	auipc	ra,0x3
    800033e2:	b2e080e7          	jalr	-1234(ra) # 80005f0c <panic>
    panic("dirlink");
    800033e6:	00005517          	auipc	a0,0x5
    800033ea:	1c250513          	addi	a0,a0,450 # 800085a8 <etext+0x5a8>
    800033ee:	00003097          	auipc	ra,0x3
    800033f2:	b1e080e7          	jalr	-1250(ra) # 80005f0c <panic>

00000000800033f6 <namei>:

struct inode*
namei(char *path)
{
    800033f6:	1101                	addi	sp,sp,-32
    800033f8:	ec06                	sd	ra,24(sp)
    800033fa:	e822                	sd	s0,16(sp)
    800033fc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033fe:	fe040613          	addi	a2,s0,-32
    80003402:	4581                	li	a1,0
    80003404:	00000097          	auipc	ra,0x0
    80003408:	dd0080e7          	jalr	-560(ra) # 800031d4 <namex>
}
    8000340c:	60e2                	ld	ra,24(sp)
    8000340e:	6442                	ld	s0,16(sp)
    80003410:	6105                	addi	sp,sp,32
    80003412:	8082                	ret

0000000080003414 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003414:	1141                	addi	sp,sp,-16
    80003416:	e406                	sd	ra,8(sp)
    80003418:	e022                	sd	s0,0(sp)
    8000341a:	0800                	addi	s0,sp,16
    8000341c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000341e:	4585                	li	a1,1
    80003420:	00000097          	auipc	ra,0x0
    80003424:	db4080e7          	jalr	-588(ra) # 800031d4 <namex>
}
    80003428:	60a2                	ld	ra,8(sp)
    8000342a:	6402                	ld	s0,0(sp)
    8000342c:	0141                	addi	sp,sp,16
    8000342e:	8082                	ret

0000000080003430 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003430:	1101                	addi	sp,sp,-32
    80003432:	ec06                	sd	ra,24(sp)
    80003434:	e822                	sd	s0,16(sp)
    80003436:	e426                	sd	s1,8(sp)
    80003438:	e04a                	sd	s2,0(sp)
    8000343a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000343c:	00011917          	auipc	s2,0x11
    80003440:	ff490913          	addi	s2,s2,-12 # 80014430 <log>
    80003444:	01892583          	lw	a1,24(s2)
    80003448:	02892503          	lw	a0,40(s2)
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	e62080e7          	jalr	-414(ra) # 800022ae <bread>
    80003454:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003456:	02c92603          	lw	a2,44(s2)
    8000345a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000345c:	00c05f63          	blez	a2,8000347a <write_head+0x4a>
    80003460:	00011717          	auipc	a4,0x11
    80003464:	00070713          	mv	a4,a4
    80003468:	87aa                	mv	a5,a0
    8000346a:	060a                	slli	a2,a2,0x2
    8000346c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000346e:	4314                	lw	a3,0(a4)
    80003470:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003472:	0711                	addi	a4,a4,4 # 80014464 <log+0x34>
    80003474:	0791                	addi	a5,a5,4
    80003476:	fec79ce3          	bne	a5,a2,8000346e <write_head+0x3e>
  }
  bwrite(buf);
    8000347a:	8526                	mv	a0,s1
    8000347c:	fffff097          	auipc	ra,0xfffff
    80003480:	f24080e7          	jalr	-220(ra) # 800023a0 <bwrite>
  brelse(buf);
    80003484:	8526                	mv	a0,s1
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	f58080e7          	jalr	-168(ra) # 800023de <brelse>
}
    8000348e:	60e2                	ld	ra,24(sp)
    80003490:	6442                	ld	s0,16(sp)
    80003492:	64a2                	ld	s1,8(sp)
    80003494:	6902                	ld	s2,0(sp)
    80003496:	6105                	addi	sp,sp,32
    80003498:	8082                	ret

000000008000349a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000349a:	00011797          	auipc	a5,0x11
    8000349e:	fc27a783          	lw	a5,-62(a5) # 8001445c <log+0x2c>
    800034a2:	0af05d63          	blez	a5,8000355c <install_trans+0xc2>
{
    800034a6:	7139                	addi	sp,sp,-64
    800034a8:	fc06                	sd	ra,56(sp)
    800034aa:	f822                	sd	s0,48(sp)
    800034ac:	f426                	sd	s1,40(sp)
    800034ae:	f04a                	sd	s2,32(sp)
    800034b0:	ec4e                	sd	s3,24(sp)
    800034b2:	e852                	sd	s4,16(sp)
    800034b4:	e456                	sd	s5,8(sp)
    800034b6:	e05a                	sd	s6,0(sp)
    800034b8:	0080                	addi	s0,sp,64
    800034ba:	8b2a                	mv	s6,a0
    800034bc:	00011a97          	auipc	s5,0x11
    800034c0:	fa4a8a93          	addi	s5,s5,-92 # 80014460 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034c6:	00011997          	auipc	s3,0x11
    800034ca:	f6a98993          	addi	s3,s3,-150 # 80014430 <log>
    800034ce:	a00d                	j	800034f0 <install_trans+0x56>
    brelse(lbuf);
    800034d0:	854a                	mv	a0,s2
    800034d2:	fffff097          	auipc	ra,0xfffff
    800034d6:	f0c080e7          	jalr	-244(ra) # 800023de <brelse>
    brelse(dbuf);
    800034da:	8526                	mv	a0,s1
    800034dc:	fffff097          	auipc	ra,0xfffff
    800034e0:	f02080e7          	jalr	-254(ra) # 800023de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034e4:	2a05                	addiw	s4,s4,1
    800034e6:	0a91                	addi	s5,s5,4
    800034e8:	02c9a783          	lw	a5,44(s3)
    800034ec:	04fa5e63          	bge	s4,a5,80003548 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034f0:	0189a583          	lw	a1,24(s3)
    800034f4:	014585bb          	addw	a1,a1,s4
    800034f8:	2585                	addiw	a1,a1,1
    800034fa:	0289a503          	lw	a0,40(s3)
    800034fe:	fffff097          	auipc	ra,0xfffff
    80003502:	db0080e7          	jalr	-592(ra) # 800022ae <bread>
    80003506:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003508:	000aa583          	lw	a1,0(s5)
    8000350c:	0289a503          	lw	a0,40(s3)
    80003510:	fffff097          	auipc	ra,0xfffff
    80003514:	d9e080e7          	jalr	-610(ra) # 800022ae <bread>
    80003518:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000351a:	40000613          	li	a2,1024
    8000351e:	05890593          	addi	a1,s2,88
    80003522:	05850513          	addi	a0,a0,88
    80003526:	ffffd097          	auipc	ra,0xffffd
    8000352a:	cb0080e7          	jalr	-848(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000352e:	8526                	mv	a0,s1
    80003530:	fffff097          	auipc	ra,0xfffff
    80003534:	e70080e7          	jalr	-400(ra) # 800023a0 <bwrite>
    if(recovering == 0)
    80003538:	f80b1ce3          	bnez	s6,800034d0 <install_trans+0x36>
      bunpin(dbuf);
    8000353c:	8526                	mv	a0,s1
    8000353e:	fffff097          	auipc	ra,0xfffff
    80003542:	f78080e7          	jalr	-136(ra) # 800024b6 <bunpin>
    80003546:	b769                	j	800034d0 <install_trans+0x36>
}
    80003548:	70e2                	ld	ra,56(sp)
    8000354a:	7442                	ld	s0,48(sp)
    8000354c:	74a2                	ld	s1,40(sp)
    8000354e:	7902                	ld	s2,32(sp)
    80003550:	69e2                	ld	s3,24(sp)
    80003552:	6a42                	ld	s4,16(sp)
    80003554:	6aa2                	ld	s5,8(sp)
    80003556:	6b02                	ld	s6,0(sp)
    80003558:	6121                	addi	sp,sp,64
    8000355a:	8082                	ret
    8000355c:	8082                	ret

000000008000355e <initlog>:
{
    8000355e:	7179                	addi	sp,sp,-48
    80003560:	f406                	sd	ra,40(sp)
    80003562:	f022                	sd	s0,32(sp)
    80003564:	ec26                	sd	s1,24(sp)
    80003566:	e84a                	sd	s2,16(sp)
    80003568:	e44e                	sd	s3,8(sp)
    8000356a:	1800                	addi	s0,sp,48
    8000356c:	892a                	mv	s2,a0
    8000356e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003570:	00011497          	auipc	s1,0x11
    80003574:	ec048493          	addi	s1,s1,-320 # 80014430 <log>
    80003578:	00005597          	auipc	a1,0x5
    8000357c:	f3058593          	addi	a1,a1,-208 # 800084a8 <etext+0x4a8>
    80003580:	8526                	mv	a0,s1
    80003582:	00003097          	auipc	ra,0x3
    80003586:	e74080e7          	jalr	-396(ra) # 800063f6 <initlock>
  log.start = sb->logstart;
    8000358a:	0149a583          	lw	a1,20(s3)
    8000358e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003590:	0109a783          	lw	a5,16(s3)
    80003594:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003596:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000359a:	854a                	mv	a0,s2
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	d12080e7          	jalr	-750(ra) # 800022ae <bread>
  log.lh.n = lh->n;
    800035a4:	4d30                	lw	a2,88(a0)
    800035a6:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035a8:	00c05f63          	blez	a2,800035c6 <initlog+0x68>
    800035ac:	87aa                	mv	a5,a0
    800035ae:	00011717          	auipc	a4,0x11
    800035b2:	eb270713          	addi	a4,a4,-334 # 80014460 <log+0x30>
    800035b6:	060a                	slli	a2,a2,0x2
    800035b8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035ba:	4ff4                	lw	a3,92(a5)
    800035bc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035be:	0791                	addi	a5,a5,4
    800035c0:	0711                	addi	a4,a4,4
    800035c2:	fec79ce3          	bne	a5,a2,800035ba <initlog+0x5c>
  brelse(buf);
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	e18080e7          	jalr	-488(ra) # 800023de <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035ce:	4505                	li	a0,1
    800035d0:	00000097          	auipc	ra,0x0
    800035d4:	eca080e7          	jalr	-310(ra) # 8000349a <install_trans>
  log.lh.n = 0;
    800035d8:	00011797          	auipc	a5,0x11
    800035dc:	e807a223          	sw	zero,-380(a5) # 8001445c <log+0x2c>
  write_head(); // clear the log
    800035e0:	00000097          	auipc	ra,0x0
    800035e4:	e50080e7          	jalr	-432(ra) # 80003430 <write_head>
}
    800035e8:	70a2                	ld	ra,40(sp)
    800035ea:	7402                	ld	s0,32(sp)
    800035ec:	64e2                	ld	s1,24(sp)
    800035ee:	6942                	ld	s2,16(sp)
    800035f0:	69a2                	ld	s3,8(sp)
    800035f2:	6145                	addi	sp,sp,48
    800035f4:	8082                	ret

00000000800035f6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035f6:	1101                	addi	sp,sp,-32
    800035f8:	ec06                	sd	ra,24(sp)
    800035fa:	e822                	sd	s0,16(sp)
    800035fc:	e426                	sd	s1,8(sp)
    800035fe:	e04a                	sd	s2,0(sp)
    80003600:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003602:	00011517          	auipc	a0,0x11
    80003606:	e2e50513          	addi	a0,a0,-466 # 80014430 <log>
    8000360a:	00003097          	auipc	ra,0x3
    8000360e:	e7c080e7          	jalr	-388(ra) # 80006486 <acquire>
  while(1){
    if(log.committing){
    80003612:	00011497          	auipc	s1,0x11
    80003616:	e1e48493          	addi	s1,s1,-482 # 80014430 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000361a:	4979                	li	s2,30
    8000361c:	a039                	j	8000362a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000361e:	85a6                	mv	a1,s1
    80003620:	8526                	mv	a0,s1
    80003622:	ffffe097          	auipc	ra,0xffffe
    80003626:	f20080e7          	jalr	-224(ra) # 80001542 <sleep>
    if(log.committing){
    8000362a:	50dc                	lw	a5,36(s1)
    8000362c:	fbed                	bnez	a5,8000361e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000362e:	5098                	lw	a4,32(s1)
    80003630:	2705                	addiw	a4,a4,1
    80003632:	0027179b          	slliw	a5,a4,0x2
    80003636:	9fb9                	addw	a5,a5,a4
    80003638:	0017979b          	slliw	a5,a5,0x1
    8000363c:	54d4                	lw	a3,44(s1)
    8000363e:	9fb5                	addw	a5,a5,a3
    80003640:	00f95963          	bge	s2,a5,80003652 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003644:	85a6                	mv	a1,s1
    80003646:	8526                	mv	a0,s1
    80003648:	ffffe097          	auipc	ra,0xffffe
    8000364c:	efa080e7          	jalr	-262(ra) # 80001542 <sleep>
    80003650:	bfe9                	j	8000362a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003652:	00011517          	auipc	a0,0x11
    80003656:	dde50513          	addi	a0,a0,-546 # 80014430 <log>
    8000365a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	ede080e7          	jalr	-290(ra) # 8000653a <release>
      break;
    }
  }
}
    80003664:	60e2                	ld	ra,24(sp)
    80003666:	6442                	ld	s0,16(sp)
    80003668:	64a2                	ld	s1,8(sp)
    8000366a:	6902                	ld	s2,0(sp)
    8000366c:	6105                	addi	sp,sp,32
    8000366e:	8082                	ret

0000000080003670 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003670:	7139                	addi	sp,sp,-64
    80003672:	fc06                	sd	ra,56(sp)
    80003674:	f822                	sd	s0,48(sp)
    80003676:	f426                	sd	s1,40(sp)
    80003678:	f04a                	sd	s2,32(sp)
    8000367a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000367c:	00011497          	auipc	s1,0x11
    80003680:	db448493          	addi	s1,s1,-588 # 80014430 <log>
    80003684:	8526                	mv	a0,s1
    80003686:	00003097          	auipc	ra,0x3
    8000368a:	e00080e7          	jalr	-512(ra) # 80006486 <acquire>
  log.outstanding -= 1;
    8000368e:	509c                	lw	a5,32(s1)
    80003690:	37fd                	addiw	a5,a5,-1
    80003692:	0007891b          	sext.w	s2,a5
    80003696:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003698:	50dc                	lw	a5,36(s1)
    8000369a:	e7b9                	bnez	a5,800036e8 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000369c:	06091163          	bnez	s2,800036fe <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036a0:	00011497          	auipc	s1,0x11
    800036a4:	d9048493          	addi	s1,s1,-624 # 80014430 <log>
    800036a8:	4785                	li	a5,1
    800036aa:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ac:	8526                	mv	a0,s1
    800036ae:	00003097          	auipc	ra,0x3
    800036b2:	e8c080e7          	jalr	-372(ra) # 8000653a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036b6:	54dc                	lw	a5,44(s1)
    800036b8:	06f04763          	bgtz	a5,80003726 <end_op+0xb6>
    acquire(&log.lock);
    800036bc:	00011497          	auipc	s1,0x11
    800036c0:	d7448493          	addi	s1,s1,-652 # 80014430 <log>
    800036c4:	8526                	mv	a0,s1
    800036c6:	00003097          	auipc	ra,0x3
    800036ca:	dc0080e7          	jalr	-576(ra) # 80006486 <acquire>
    log.committing = 0;
    800036ce:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036d2:	8526                	mv	a0,s1
    800036d4:	ffffe097          	auipc	ra,0xffffe
    800036d8:	ffa080e7          	jalr	-6(ra) # 800016ce <wakeup>
    release(&log.lock);
    800036dc:	8526                	mv	a0,s1
    800036de:	00003097          	auipc	ra,0x3
    800036e2:	e5c080e7          	jalr	-420(ra) # 8000653a <release>
}
    800036e6:	a815                	j	8000371a <end_op+0xaa>
    800036e8:	ec4e                	sd	s3,24(sp)
    800036ea:	e852                	sd	s4,16(sp)
    800036ec:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800036ee:	00005517          	auipc	a0,0x5
    800036f2:	dc250513          	addi	a0,a0,-574 # 800084b0 <etext+0x4b0>
    800036f6:	00003097          	auipc	ra,0x3
    800036fa:	816080e7          	jalr	-2026(ra) # 80005f0c <panic>
    wakeup(&log);
    800036fe:	00011497          	auipc	s1,0x11
    80003702:	d3248493          	addi	s1,s1,-718 # 80014430 <log>
    80003706:	8526                	mv	a0,s1
    80003708:	ffffe097          	auipc	ra,0xffffe
    8000370c:	fc6080e7          	jalr	-58(ra) # 800016ce <wakeup>
  release(&log.lock);
    80003710:	8526                	mv	a0,s1
    80003712:	00003097          	auipc	ra,0x3
    80003716:	e28080e7          	jalr	-472(ra) # 8000653a <release>
}
    8000371a:	70e2                	ld	ra,56(sp)
    8000371c:	7442                	ld	s0,48(sp)
    8000371e:	74a2                	ld	s1,40(sp)
    80003720:	7902                	ld	s2,32(sp)
    80003722:	6121                	addi	sp,sp,64
    80003724:	8082                	ret
    80003726:	ec4e                	sd	s3,24(sp)
    80003728:	e852                	sd	s4,16(sp)
    8000372a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000372c:	00011a97          	auipc	s5,0x11
    80003730:	d34a8a93          	addi	s5,s5,-716 # 80014460 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003734:	00011a17          	auipc	s4,0x11
    80003738:	cfca0a13          	addi	s4,s4,-772 # 80014430 <log>
    8000373c:	018a2583          	lw	a1,24(s4)
    80003740:	012585bb          	addw	a1,a1,s2
    80003744:	2585                	addiw	a1,a1,1
    80003746:	028a2503          	lw	a0,40(s4)
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	b64080e7          	jalr	-1180(ra) # 800022ae <bread>
    80003752:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003754:	000aa583          	lw	a1,0(s5)
    80003758:	028a2503          	lw	a0,40(s4)
    8000375c:	fffff097          	auipc	ra,0xfffff
    80003760:	b52080e7          	jalr	-1198(ra) # 800022ae <bread>
    80003764:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003766:	40000613          	li	a2,1024
    8000376a:	05850593          	addi	a1,a0,88
    8000376e:	05848513          	addi	a0,s1,88
    80003772:	ffffd097          	auipc	ra,0xffffd
    80003776:	a64080e7          	jalr	-1436(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000377a:	8526                	mv	a0,s1
    8000377c:	fffff097          	auipc	ra,0xfffff
    80003780:	c24080e7          	jalr	-988(ra) # 800023a0 <bwrite>
    brelse(from);
    80003784:	854e                	mv	a0,s3
    80003786:	fffff097          	auipc	ra,0xfffff
    8000378a:	c58080e7          	jalr	-936(ra) # 800023de <brelse>
    brelse(to);
    8000378e:	8526                	mv	a0,s1
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	c4e080e7          	jalr	-946(ra) # 800023de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003798:	2905                	addiw	s2,s2,1
    8000379a:	0a91                	addi	s5,s5,4
    8000379c:	02ca2783          	lw	a5,44(s4)
    800037a0:	f8f94ee3          	blt	s2,a5,8000373c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037a4:	00000097          	auipc	ra,0x0
    800037a8:	c8c080e7          	jalr	-884(ra) # 80003430 <write_head>
    install_trans(0); // Now install writes to home locations
    800037ac:	4501                	li	a0,0
    800037ae:	00000097          	auipc	ra,0x0
    800037b2:	cec080e7          	jalr	-788(ra) # 8000349a <install_trans>
    log.lh.n = 0;
    800037b6:	00011797          	auipc	a5,0x11
    800037ba:	ca07a323          	sw	zero,-858(a5) # 8001445c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037be:	00000097          	auipc	ra,0x0
    800037c2:	c72080e7          	jalr	-910(ra) # 80003430 <write_head>
    800037c6:	69e2                	ld	s3,24(sp)
    800037c8:	6a42                	ld	s4,16(sp)
    800037ca:	6aa2                	ld	s5,8(sp)
    800037cc:	bdc5                	j	800036bc <end_op+0x4c>

00000000800037ce <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037ce:	1101                	addi	sp,sp,-32
    800037d0:	ec06                	sd	ra,24(sp)
    800037d2:	e822                	sd	s0,16(sp)
    800037d4:	e426                	sd	s1,8(sp)
    800037d6:	e04a                	sd	s2,0(sp)
    800037d8:	1000                	addi	s0,sp,32
    800037da:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037dc:	00011917          	auipc	s2,0x11
    800037e0:	c5490913          	addi	s2,s2,-940 # 80014430 <log>
    800037e4:	854a                	mv	a0,s2
    800037e6:	00003097          	auipc	ra,0x3
    800037ea:	ca0080e7          	jalr	-864(ra) # 80006486 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037ee:	02c92603          	lw	a2,44(s2)
    800037f2:	47f5                	li	a5,29
    800037f4:	06c7c563          	blt	a5,a2,8000385e <log_write+0x90>
    800037f8:	00011797          	auipc	a5,0x11
    800037fc:	c547a783          	lw	a5,-940(a5) # 8001444c <log+0x1c>
    80003800:	37fd                	addiw	a5,a5,-1
    80003802:	04f65e63          	bge	a2,a5,8000385e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003806:	00011797          	auipc	a5,0x11
    8000380a:	c4a7a783          	lw	a5,-950(a5) # 80014450 <log+0x20>
    8000380e:	06f05063          	blez	a5,8000386e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003812:	4781                	li	a5,0
    80003814:	06c05563          	blez	a2,8000387e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003818:	44cc                	lw	a1,12(s1)
    8000381a:	00011717          	auipc	a4,0x11
    8000381e:	c4670713          	addi	a4,a4,-954 # 80014460 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003822:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003824:	4314                	lw	a3,0(a4)
    80003826:	04b68c63          	beq	a3,a1,8000387e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000382a:	2785                	addiw	a5,a5,1
    8000382c:	0711                	addi	a4,a4,4
    8000382e:	fef61be3          	bne	a2,a5,80003824 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003832:	0621                	addi	a2,a2,8
    80003834:	060a                	slli	a2,a2,0x2
    80003836:	00011797          	auipc	a5,0x11
    8000383a:	bfa78793          	addi	a5,a5,-1030 # 80014430 <log>
    8000383e:	97b2                	add	a5,a5,a2
    80003840:	44d8                	lw	a4,12(s1)
    80003842:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003844:	8526                	mv	a0,s1
    80003846:	fffff097          	auipc	ra,0xfffff
    8000384a:	c34080e7          	jalr	-972(ra) # 8000247a <bpin>
    log.lh.n++;
    8000384e:	00011717          	auipc	a4,0x11
    80003852:	be270713          	addi	a4,a4,-1054 # 80014430 <log>
    80003856:	575c                	lw	a5,44(a4)
    80003858:	2785                	addiw	a5,a5,1
    8000385a:	d75c                	sw	a5,44(a4)
    8000385c:	a82d                	j	80003896 <log_write+0xc8>
    panic("too big a transaction");
    8000385e:	00005517          	auipc	a0,0x5
    80003862:	c6250513          	addi	a0,a0,-926 # 800084c0 <etext+0x4c0>
    80003866:	00002097          	auipc	ra,0x2
    8000386a:	6a6080e7          	jalr	1702(ra) # 80005f0c <panic>
    panic("log_write outside of trans");
    8000386e:	00005517          	auipc	a0,0x5
    80003872:	c6a50513          	addi	a0,a0,-918 # 800084d8 <etext+0x4d8>
    80003876:	00002097          	auipc	ra,0x2
    8000387a:	696080e7          	jalr	1686(ra) # 80005f0c <panic>
  log.lh.block[i] = b->blockno;
    8000387e:	00878693          	addi	a3,a5,8
    80003882:	068a                	slli	a3,a3,0x2
    80003884:	00011717          	auipc	a4,0x11
    80003888:	bac70713          	addi	a4,a4,-1108 # 80014430 <log>
    8000388c:	9736                	add	a4,a4,a3
    8000388e:	44d4                	lw	a3,12(s1)
    80003890:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003892:	faf609e3          	beq	a2,a5,80003844 <log_write+0x76>
  }
  release(&log.lock);
    80003896:	00011517          	auipc	a0,0x11
    8000389a:	b9a50513          	addi	a0,a0,-1126 # 80014430 <log>
    8000389e:	00003097          	auipc	ra,0x3
    800038a2:	c9c080e7          	jalr	-868(ra) # 8000653a <release>
}
    800038a6:	60e2                	ld	ra,24(sp)
    800038a8:	6442                	ld	s0,16(sp)
    800038aa:	64a2                	ld	s1,8(sp)
    800038ac:	6902                	ld	s2,0(sp)
    800038ae:	6105                	addi	sp,sp,32
    800038b0:	8082                	ret

00000000800038b2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038b2:	1101                	addi	sp,sp,-32
    800038b4:	ec06                	sd	ra,24(sp)
    800038b6:	e822                	sd	s0,16(sp)
    800038b8:	e426                	sd	s1,8(sp)
    800038ba:	e04a                	sd	s2,0(sp)
    800038bc:	1000                	addi	s0,sp,32
    800038be:	84aa                	mv	s1,a0
    800038c0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038c2:	00005597          	auipc	a1,0x5
    800038c6:	c3658593          	addi	a1,a1,-970 # 800084f8 <etext+0x4f8>
    800038ca:	0521                	addi	a0,a0,8
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	b2a080e7          	jalr	-1238(ra) # 800063f6 <initlock>
  lk->name = name;
    800038d4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038d8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038dc:	0204a423          	sw	zero,40(s1)
}
    800038e0:	60e2                	ld	ra,24(sp)
    800038e2:	6442                	ld	s0,16(sp)
    800038e4:	64a2                	ld	s1,8(sp)
    800038e6:	6902                	ld	s2,0(sp)
    800038e8:	6105                	addi	sp,sp,32
    800038ea:	8082                	ret

00000000800038ec <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038ec:	1101                	addi	sp,sp,-32
    800038ee:	ec06                	sd	ra,24(sp)
    800038f0:	e822                	sd	s0,16(sp)
    800038f2:	e426                	sd	s1,8(sp)
    800038f4:	e04a                	sd	s2,0(sp)
    800038f6:	1000                	addi	s0,sp,32
    800038f8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038fa:	00850913          	addi	s2,a0,8
    800038fe:	854a                	mv	a0,s2
    80003900:	00003097          	auipc	ra,0x3
    80003904:	b86080e7          	jalr	-1146(ra) # 80006486 <acquire>
  while (lk->locked) {
    80003908:	409c                	lw	a5,0(s1)
    8000390a:	cb89                	beqz	a5,8000391c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000390c:	85ca                	mv	a1,s2
    8000390e:	8526                	mv	a0,s1
    80003910:	ffffe097          	auipc	ra,0xffffe
    80003914:	c32080e7          	jalr	-974(ra) # 80001542 <sleep>
  while (lk->locked) {
    80003918:	409c                	lw	a5,0(s1)
    8000391a:	fbed                	bnez	a5,8000390c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000391c:	4785                	li	a5,1
    8000391e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	55c080e7          	jalr	1372(ra) # 80000e7c <myproc>
    80003928:	591c                	lw	a5,48(a0)
    8000392a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000392c:	854a                	mv	a0,s2
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	c0c080e7          	jalr	-1012(ra) # 8000653a <release>
}
    80003936:	60e2                	ld	ra,24(sp)
    80003938:	6442                	ld	s0,16(sp)
    8000393a:	64a2                	ld	s1,8(sp)
    8000393c:	6902                	ld	s2,0(sp)
    8000393e:	6105                	addi	sp,sp,32
    80003940:	8082                	ret

0000000080003942 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003942:	1101                	addi	sp,sp,-32
    80003944:	ec06                	sd	ra,24(sp)
    80003946:	e822                	sd	s0,16(sp)
    80003948:	e426                	sd	s1,8(sp)
    8000394a:	e04a                	sd	s2,0(sp)
    8000394c:	1000                	addi	s0,sp,32
    8000394e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003950:	00850913          	addi	s2,a0,8
    80003954:	854a                	mv	a0,s2
    80003956:	00003097          	auipc	ra,0x3
    8000395a:	b30080e7          	jalr	-1232(ra) # 80006486 <acquire>
  lk->locked = 0;
    8000395e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003962:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003966:	8526                	mv	a0,s1
    80003968:	ffffe097          	auipc	ra,0xffffe
    8000396c:	d66080e7          	jalr	-666(ra) # 800016ce <wakeup>
  release(&lk->lk);
    80003970:	854a                	mv	a0,s2
    80003972:	00003097          	auipc	ra,0x3
    80003976:	bc8080e7          	jalr	-1080(ra) # 8000653a <release>
}
    8000397a:	60e2                	ld	ra,24(sp)
    8000397c:	6442                	ld	s0,16(sp)
    8000397e:	64a2                	ld	s1,8(sp)
    80003980:	6902                	ld	s2,0(sp)
    80003982:	6105                	addi	sp,sp,32
    80003984:	8082                	ret

0000000080003986 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003986:	7179                	addi	sp,sp,-48
    80003988:	f406                	sd	ra,40(sp)
    8000398a:	f022                	sd	s0,32(sp)
    8000398c:	ec26                	sd	s1,24(sp)
    8000398e:	e84a                	sd	s2,16(sp)
    80003990:	1800                	addi	s0,sp,48
    80003992:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003994:	00850913          	addi	s2,a0,8
    80003998:	854a                	mv	a0,s2
    8000399a:	00003097          	auipc	ra,0x3
    8000399e:	aec080e7          	jalr	-1300(ra) # 80006486 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039a2:	409c                	lw	a5,0(s1)
    800039a4:	ef91                	bnez	a5,800039c0 <holdingsleep+0x3a>
    800039a6:	4481                	li	s1,0
  release(&lk->lk);
    800039a8:	854a                	mv	a0,s2
    800039aa:	00003097          	auipc	ra,0x3
    800039ae:	b90080e7          	jalr	-1136(ra) # 8000653a <release>
  return r;
}
    800039b2:	8526                	mv	a0,s1
    800039b4:	70a2                	ld	ra,40(sp)
    800039b6:	7402                	ld	s0,32(sp)
    800039b8:	64e2                	ld	s1,24(sp)
    800039ba:	6942                	ld	s2,16(sp)
    800039bc:	6145                	addi	sp,sp,48
    800039be:	8082                	ret
    800039c0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800039c2:	0284a983          	lw	s3,40(s1)
    800039c6:	ffffd097          	auipc	ra,0xffffd
    800039ca:	4b6080e7          	jalr	1206(ra) # 80000e7c <myproc>
    800039ce:	5904                	lw	s1,48(a0)
    800039d0:	413484b3          	sub	s1,s1,s3
    800039d4:	0014b493          	seqz	s1,s1
    800039d8:	69a2                	ld	s3,8(sp)
    800039da:	b7f9                	j	800039a8 <holdingsleep+0x22>

00000000800039dc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039dc:	1141                	addi	sp,sp,-16
    800039de:	e406                	sd	ra,8(sp)
    800039e0:	e022                	sd	s0,0(sp)
    800039e2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039e4:	00005597          	auipc	a1,0x5
    800039e8:	b2458593          	addi	a1,a1,-1244 # 80008508 <etext+0x508>
    800039ec:	00011517          	auipc	a0,0x11
    800039f0:	b8c50513          	addi	a0,a0,-1140 # 80014578 <ftable>
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	a02080e7          	jalr	-1534(ra) # 800063f6 <initlock>
}
    800039fc:	60a2                	ld	ra,8(sp)
    800039fe:	6402                	ld	s0,0(sp)
    80003a00:	0141                	addi	sp,sp,16
    80003a02:	8082                	ret

0000000080003a04 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a04:	1101                	addi	sp,sp,-32
    80003a06:	ec06                	sd	ra,24(sp)
    80003a08:	e822                	sd	s0,16(sp)
    80003a0a:	e426                	sd	s1,8(sp)
    80003a0c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a0e:	00011517          	auipc	a0,0x11
    80003a12:	b6a50513          	addi	a0,a0,-1174 # 80014578 <ftable>
    80003a16:	00003097          	auipc	ra,0x3
    80003a1a:	a70080e7          	jalr	-1424(ra) # 80006486 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a1e:	00011497          	auipc	s1,0x11
    80003a22:	b7248493          	addi	s1,s1,-1166 # 80014590 <ftable+0x18>
    80003a26:	00012717          	auipc	a4,0x12
    80003a2a:	b0a70713          	addi	a4,a4,-1270 # 80015530 <ftable+0xfb8>
    if(f->ref == 0){
    80003a2e:	40dc                	lw	a5,4(s1)
    80003a30:	cf99                	beqz	a5,80003a4e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a32:	02848493          	addi	s1,s1,40
    80003a36:	fee49ce3          	bne	s1,a4,80003a2e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a3a:	00011517          	auipc	a0,0x11
    80003a3e:	b3e50513          	addi	a0,a0,-1218 # 80014578 <ftable>
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	af8080e7          	jalr	-1288(ra) # 8000653a <release>
  return 0;
    80003a4a:	4481                	li	s1,0
    80003a4c:	a819                	j	80003a62 <filealloc+0x5e>
      f->ref = 1;
    80003a4e:	4785                	li	a5,1
    80003a50:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a52:	00011517          	auipc	a0,0x11
    80003a56:	b2650513          	addi	a0,a0,-1242 # 80014578 <ftable>
    80003a5a:	00003097          	auipc	ra,0x3
    80003a5e:	ae0080e7          	jalr	-1312(ra) # 8000653a <release>
}
    80003a62:	8526                	mv	a0,s1
    80003a64:	60e2                	ld	ra,24(sp)
    80003a66:	6442                	ld	s0,16(sp)
    80003a68:	64a2                	ld	s1,8(sp)
    80003a6a:	6105                	addi	sp,sp,32
    80003a6c:	8082                	ret

0000000080003a6e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a6e:	1101                	addi	sp,sp,-32
    80003a70:	ec06                	sd	ra,24(sp)
    80003a72:	e822                	sd	s0,16(sp)
    80003a74:	e426                	sd	s1,8(sp)
    80003a76:	1000                	addi	s0,sp,32
    80003a78:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a7a:	00011517          	auipc	a0,0x11
    80003a7e:	afe50513          	addi	a0,a0,-1282 # 80014578 <ftable>
    80003a82:	00003097          	auipc	ra,0x3
    80003a86:	a04080e7          	jalr	-1532(ra) # 80006486 <acquire>
  if(f->ref < 1)
    80003a8a:	40dc                	lw	a5,4(s1)
    80003a8c:	02f05263          	blez	a5,80003ab0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a90:	2785                	addiw	a5,a5,1
    80003a92:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a94:	00011517          	auipc	a0,0x11
    80003a98:	ae450513          	addi	a0,a0,-1308 # 80014578 <ftable>
    80003a9c:	00003097          	auipc	ra,0x3
    80003aa0:	a9e080e7          	jalr	-1378(ra) # 8000653a <release>
  return f;
}
    80003aa4:	8526                	mv	a0,s1
    80003aa6:	60e2                	ld	ra,24(sp)
    80003aa8:	6442                	ld	s0,16(sp)
    80003aaa:	64a2                	ld	s1,8(sp)
    80003aac:	6105                	addi	sp,sp,32
    80003aae:	8082                	ret
    panic("filedup");
    80003ab0:	00005517          	auipc	a0,0x5
    80003ab4:	a6050513          	addi	a0,a0,-1440 # 80008510 <etext+0x510>
    80003ab8:	00002097          	auipc	ra,0x2
    80003abc:	454080e7          	jalr	1108(ra) # 80005f0c <panic>

0000000080003ac0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ac0:	7139                	addi	sp,sp,-64
    80003ac2:	fc06                	sd	ra,56(sp)
    80003ac4:	f822                	sd	s0,48(sp)
    80003ac6:	f426                	sd	s1,40(sp)
    80003ac8:	0080                	addi	s0,sp,64
    80003aca:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003acc:	00011517          	auipc	a0,0x11
    80003ad0:	aac50513          	addi	a0,a0,-1364 # 80014578 <ftable>
    80003ad4:	00003097          	auipc	ra,0x3
    80003ad8:	9b2080e7          	jalr	-1614(ra) # 80006486 <acquire>
  if(f->ref < 1)
    80003adc:	40dc                	lw	a5,4(s1)
    80003ade:	04f05c63          	blez	a5,80003b36 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003ae2:	37fd                	addiw	a5,a5,-1
    80003ae4:	0007871b          	sext.w	a4,a5
    80003ae8:	c0dc                	sw	a5,4(s1)
    80003aea:	06e04263          	bgtz	a4,80003b4e <fileclose+0x8e>
    80003aee:	f04a                	sd	s2,32(sp)
    80003af0:	ec4e                	sd	s3,24(sp)
    80003af2:	e852                	sd	s4,16(sp)
    80003af4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003af6:	0004a903          	lw	s2,0(s1)
    80003afa:	0094ca83          	lbu	s5,9(s1)
    80003afe:	0104ba03          	ld	s4,16(s1)
    80003b02:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b06:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b0a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b0e:	00011517          	auipc	a0,0x11
    80003b12:	a6a50513          	addi	a0,a0,-1430 # 80014578 <ftable>
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	a24080e7          	jalr	-1500(ra) # 8000653a <release>

  if(ff.type == FD_PIPE){
    80003b1e:	4785                	li	a5,1
    80003b20:	04f90463          	beq	s2,a5,80003b68 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b24:	3979                	addiw	s2,s2,-2
    80003b26:	4785                	li	a5,1
    80003b28:	0527fb63          	bgeu	a5,s2,80003b7e <fileclose+0xbe>
    80003b2c:	7902                	ld	s2,32(sp)
    80003b2e:	69e2                	ld	s3,24(sp)
    80003b30:	6a42                	ld	s4,16(sp)
    80003b32:	6aa2                	ld	s5,8(sp)
    80003b34:	a02d                	j	80003b5e <fileclose+0x9e>
    80003b36:	f04a                	sd	s2,32(sp)
    80003b38:	ec4e                	sd	s3,24(sp)
    80003b3a:	e852                	sd	s4,16(sp)
    80003b3c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b3e:	00005517          	auipc	a0,0x5
    80003b42:	9da50513          	addi	a0,a0,-1574 # 80008518 <etext+0x518>
    80003b46:	00002097          	auipc	ra,0x2
    80003b4a:	3c6080e7          	jalr	966(ra) # 80005f0c <panic>
    release(&ftable.lock);
    80003b4e:	00011517          	auipc	a0,0x11
    80003b52:	a2a50513          	addi	a0,a0,-1494 # 80014578 <ftable>
    80003b56:	00003097          	auipc	ra,0x3
    80003b5a:	9e4080e7          	jalr	-1564(ra) # 8000653a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b5e:	70e2                	ld	ra,56(sp)
    80003b60:	7442                	ld	s0,48(sp)
    80003b62:	74a2                	ld	s1,40(sp)
    80003b64:	6121                	addi	sp,sp,64
    80003b66:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b68:	85d6                	mv	a1,s5
    80003b6a:	8552                	mv	a0,s4
    80003b6c:	00000097          	auipc	ra,0x0
    80003b70:	3a2080e7          	jalr	930(ra) # 80003f0e <pipeclose>
    80003b74:	7902                	ld	s2,32(sp)
    80003b76:	69e2                	ld	s3,24(sp)
    80003b78:	6a42                	ld	s4,16(sp)
    80003b7a:	6aa2                	ld	s5,8(sp)
    80003b7c:	b7cd                	j	80003b5e <fileclose+0x9e>
    begin_op();
    80003b7e:	00000097          	auipc	ra,0x0
    80003b82:	a78080e7          	jalr	-1416(ra) # 800035f6 <begin_op>
    iput(ff.ip);
    80003b86:	854e                	mv	a0,s3
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	258080e7          	jalr	600(ra) # 80002de0 <iput>
    end_op();
    80003b90:	00000097          	auipc	ra,0x0
    80003b94:	ae0080e7          	jalr	-1312(ra) # 80003670 <end_op>
    80003b98:	7902                	ld	s2,32(sp)
    80003b9a:	69e2                	ld	s3,24(sp)
    80003b9c:	6a42                	ld	s4,16(sp)
    80003b9e:	6aa2                	ld	s5,8(sp)
    80003ba0:	bf7d                	j	80003b5e <fileclose+0x9e>

0000000080003ba2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ba2:	715d                	addi	sp,sp,-80
    80003ba4:	e486                	sd	ra,72(sp)
    80003ba6:	e0a2                	sd	s0,64(sp)
    80003ba8:	fc26                	sd	s1,56(sp)
    80003baa:	f44e                	sd	s3,40(sp)
    80003bac:	0880                	addi	s0,sp,80
    80003bae:	84aa                	mv	s1,a0
    80003bb0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bb2:	ffffd097          	auipc	ra,0xffffd
    80003bb6:	2ca080e7          	jalr	714(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bba:	409c                	lw	a5,0(s1)
    80003bbc:	37f9                	addiw	a5,a5,-2
    80003bbe:	4705                	li	a4,1
    80003bc0:	04f76863          	bltu	a4,a5,80003c10 <filestat+0x6e>
    80003bc4:	f84a                	sd	s2,48(sp)
    80003bc6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bc8:	6c88                	ld	a0,24(s1)
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	faa080e7          	jalr	-86(ra) # 80002b74 <ilock>
    stati(f->ip, &st);
    80003bd2:	fb840593          	addi	a1,s0,-72
    80003bd6:	6c88                	ld	a0,24(s1)
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	2d8080e7          	jalr	728(ra) # 80002eb0 <stati>
    iunlock(f->ip);
    80003be0:	6c88                	ld	a0,24(s1)
    80003be2:	fffff097          	auipc	ra,0xfffff
    80003be6:	058080e7          	jalr	88(ra) # 80002c3a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bea:	46e1                	li	a3,24
    80003bec:	fb840613          	addi	a2,s0,-72
    80003bf0:	85ce                	mv	a1,s3
    80003bf2:	05093503          	ld	a0,80(s2)
    80003bf6:	ffffd097          	auipc	ra,0xffffd
    80003bfa:	f22080e7          	jalr	-222(ra) # 80000b18 <copyout>
    80003bfe:	41f5551b          	sraiw	a0,a0,0x1f
    80003c02:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c04:	60a6                	ld	ra,72(sp)
    80003c06:	6406                	ld	s0,64(sp)
    80003c08:	74e2                	ld	s1,56(sp)
    80003c0a:	79a2                	ld	s3,40(sp)
    80003c0c:	6161                	addi	sp,sp,80
    80003c0e:	8082                	ret
  return -1;
    80003c10:	557d                	li	a0,-1
    80003c12:	bfcd                	j	80003c04 <filestat+0x62>

0000000080003c14 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c14:	7179                	addi	sp,sp,-48
    80003c16:	f406                	sd	ra,40(sp)
    80003c18:	f022                	sd	s0,32(sp)
    80003c1a:	e84a                	sd	s2,16(sp)
    80003c1c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c1e:	00854783          	lbu	a5,8(a0)
    80003c22:	cbc5                	beqz	a5,80003cd2 <fileread+0xbe>
    80003c24:	ec26                	sd	s1,24(sp)
    80003c26:	e44e                	sd	s3,8(sp)
    80003c28:	84aa                	mv	s1,a0
    80003c2a:	89ae                	mv	s3,a1
    80003c2c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c2e:	411c                	lw	a5,0(a0)
    80003c30:	4705                	li	a4,1
    80003c32:	04e78963          	beq	a5,a4,80003c84 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c36:	470d                	li	a4,3
    80003c38:	04e78f63          	beq	a5,a4,80003c96 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c3c:	4709                	li	a4,2
    80003c3e:	08e79263          	bne	a5,a4,80003cc2 <fileread+0xae>
    ilock(f->ip);
    80003c42:	6d08                	ld	a0,24(a0)
    80003c44:	fffff097          	auipc	ra,0xfffff
    80003c48:	f30080e7          	jalr	-208(ra) # 80002b74 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c4c:	874a                	mv	a4,s2
    80003c4e:	5094                	lw	a3,32(s1)
    80003c50:	864e                	mv	a2,s3
    80003c52:	4585                	li	a1,1
    80003c54:	6c88                	ld	a0,24(s1)
    80003c56:	fffff097          	auipc	ra,0xfffff
    80003c5a:	284080e7          	jalr	644(ra) # 80002eda <readi>
    80003c5e:	892a                	mv	s2,a0
    80003c60:	00a05563          	blez	a0,80003c6a <fileread+0x56>
      f->off += r;
    80003c64:	509c                	lw	a5,32(s1)
    80003c66:	9fa9                	addw	a5,a5,a0
    80003c68:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c6a:	6c88                	ld	a0,24(s1)
    80003c6c:	fffff097          	auipc	ra,0xfffff
    80003c70:	fce080e7          	jalr	-50(ra) # 80002c3a <iunlock>
    80003c74:	64e2                	ld	s1,24(sp)
    80003c76:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c78:	854a                	mv	a0,s2
    80003c7a:	70a2                	ld	ra,40(sp)
    80003c7c:	7402                	ld	s0,32(sp)
    80003c7e:	6942                	ld	s2,16(sp)
    80003c80:	6145                	addi	sp,sp,48
    80003c82:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c84:	6908                	ld	a0,16(a0)
    80003c86:	00000097          	auipc	ra,0x0
    80003c8a:	3fa080e7          	jalr	1018(ra) # 80004080 <piperead>
    80003c8e:	892a                	mv	s2,a0
    80003c90:	64e2                	ld	s1,24(sp)
    80003c92:	69a2                	ld	s3,8(sp)
    80003c94:	b7d5                	j	80003c78 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c96:	02451783          	lh	a5,36(a0)
    80003c9a:	03079693          	slli	a3,a5,0x30
    80003c9e:	92c1                	srli	a3,a3,0x30
    80003ca0:	4725                	li	a4,9
    80003ca2:	02d76a63          	bltu	a4,a3,80003cd6 <fileread+0xc2>
    80003ca6:	0792                	slli	a5,a5,0x4
    80003ca8:	00011717          	auipc	a4,0x11
    80003cac:	83070713          	addi	a4,a4,-2000 # 800144d8 <devsw>
    80003cb0:	97ba                	add	a5,a5,a4
    80003cb2:	639c                	ld	a5,0(a5)
    80003cb4:	c78d                	beqz	a5,80003cde <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003cb6:	4505                	li	a0,1
    80003cb8:	9782                	jalr	a5
    80003cba:	892a                	mv	s2,a0
    80003cbc:	64e2                	ld	s1,24(sp)
    80003cbe:	69a2                	ld	s3,8(sp)
    80003cc0:	bf65                	j	80003c78 <fileread+0x64>
    panic("fileread");
    80003cc2:	00005517          	auipc	a0,0x5
    80003cc6:	86650513          	addi	a0,a0,-1946 # 80008528 <etext+0x528>
    80003cca:	00002097          	auipc	ra,0x2
    80003cce:	242080e7          	jalr	578(ra) # 80005f0c <panic>
    return -1;
    80003cd2:	597d                	li	s2,-1
    80003cd4:	b755                	j	80003c78 <fileread+0x64>
      return -1;
    80003cd6:	597d                	li	s2,-1
    80003cd8:	64e2                	ld	s1,24(sp)
    80003cda:	69a2                	ld	s3,8(sp)
    80003cdc:	bf71                	j	80003c78 <fileread+0x64>
    80003cde:	597d                	li	s2,-1
    80003ce0:	64e2                	ld	s1,24(sp)
    80003ce2:	69a2                	ld	s3,8(sp)
    80003ce4:	bf51                	j	80003c78 <fileread+0x64>

0000000080003ce6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003ce6:	00954783          	lbu	a5,9(a0)
    80003cea:	12078963          	beqz	a5,80003e1c <filewrite+0x136>
{
    80003cee:	715d                	addi	sp,sp,-80
    80003cf0:	e486                	sd	ra,72(sp)
    80003cf2:	e0a2                	sd	s0,64(sp)
    80003cf4:	f84a                	sd	s2,48(sp)
    80003cf6:	f052                	sd	s4,32(sp)
    80003cf8:	e85a                	sd	s6,16(sp)
    80003cfa:	0880                	addi	s0,sp,80
    80003cfc:	892a                	mv	s2,a0
    80003cfe:	8b2e                	mv	s6,a1
    80003d00:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d02:	411c                	lw	a5,0(a0)
    80003d04:	4705                	li	a4,1
    80003d06:	02e78763          	beq	a5,a4,80003d34 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d0a:	470d                	li	a4,3
    80003d0c:	02e78a63          	beq	a5,a4,80003d40 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d10:	4709                	li	a4,2
    80003d12:	0ee79863          	bne	a5,a4,80003e02 <filewrite+0x11c>
    80003d16:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d18:	0cc05463          	blez	a2,80003de0 <filewrite+0xfa>
    80003d1c:	fc26                	sd	s1,56(sp)
    80003d1e:	ec56                	sd	s5,24(sp)
    80003d20:	e45e                	sd	s7,8(sp)
    80003d22:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d24:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d26:	6b85                	lui	s7,0x1
    80003d28:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d2c:	6c05                	lui	s8,0x1
    80003d2e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d32:	a851                	j	80003dc6 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d34:	6908                	ld	a0,16(a0)
    80003d36:	00000097          	auipc	ra,0x0
    80003d3a:	248080e7          	jalr	584(ra) # 80003f7e <pipewrite>
    80003d3e:	a85d                	j	80003df4 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d40:	02451783          	lh	a5,36(a0)
    80003d44:	03079693          	slli	a3,a5,0x30
    80003d48:	92c1                	srli	a3,a3,0x30
    80003d4a:	4725                	li	a4,9
    80003d4c:	0cd76a63          	bltu	a4,a3,80003e20 <filewrite+0x13a>
    80003d50:	0792                	slli	a5,a5,0x4
    80003d52:	00010717          	auipc	a4,0x10
    80003d56:	78670713          	addi	a4,a4,1926 # 800144d8 <devsw>
    80003d5a:	97ba                	add	a5,a5,a4
    80003d5c:	679c                	ld	a5,8(a5)
    80003d5e:	c3f9                	beqz	a5,80003e24 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d60:	4505                	li	a0,1
    80003d62:	9782                	jalr	a5
    80003d64:	a841                	j	80003df4 <filewrite+0x10e>
      if(n1 > max)
    80003d66:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d6a:	00000097          	auipc	ra,0x0
    80003d6e:	88c080e7          	jalr	-1908(ra) # 800035f6 <begin_op>
      ilock(f->ip);
    80003d72:	01893503          	ld	a0,24(s2)
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	dfe080e7          	jalr	-514(ra) # 80002b74 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d7e:	8756                	mv	a4,s5
    80003d80:	02092683          	lw	a3,32(s2)
    80003d84:	01698633          	add	a2,s3,s6
    80003d88:	4585                	li	a1,1
    80003d8a:	01893503          	ld	a0,24(s2)
    80003d8e:	fffff097          	auipc	ra,0xfffff
    80003d92:	250080e7          	jalr	592(ra) # 80002fde <writei>
    80003d96:	84aa                	mv	s1,a0
    80003d98:	00a05763          	blez	a0,80003da6 <filewrite+0xc0>
        f->off += r;
    80003d9c:	02092783          	lw	a5,32(s2)
    80003da0:	9fa9                	addw	a5,a5,a0
    80003da2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003da6:	01893503          	ld	a0,24(s2)
    80003daa:	fffff097          	auipc	ra,0xfffff
    80003dae:	e90080e7          	jalr	-368(ra) # 80002c3a <iunlock>
      end_op();
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	8be080e7          	jalr	-1858(ra) # 80003670 <end_op>

      if(r != n1){
    80003dba:	029a9563          	bne	s5,s1,80003de4 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003dbe:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dc2:	0149da63          	bge	s3,s4,80003dd6 <filewrite+0xf0>
      int n1 = n - i;
    80003dc6:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003dca:	0004879b          	sext.w	a5,s1
    80003dce:	f8fbdce3          	bge	s7,a5,80003d66 <filewrite+0x80>
    80003dd2:	84e2                	mv	s1,s8
    80003dd4:	bf49                	j	80003d66 <filewrite+0x80>
    80003dd6:	74e2                	ld	s1,56(sp)
    80003dd8:	6ae2                	ld	s5,24(sp)
    80003dda:	6ba2                	ld	s7,8(sp)
    80003ddc:	6c02                	ld	s8,0(sp)
    80003dde:	a039                	j	80003dec <filewrite+0x106>
    int i = 0;
    80003de0:	4981                	li	s3,0
    80003de2:	a029                	j	80003dec <filewrite+0x106>
    80003de4:	74e2                	ld	s1,56(sp)
    80003de6:	6ae2                	ld	s5,24(sp)
    80003de8:	6ba2                	ld	s7,8(sp)
    80003dea:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003dec:	033a1e63          	bne	s4,s3,80003e28 <filewrite+0x142>
    80003df0:	8552                	mv	a0,s4
    80003df2:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003df4:	60a6                	ld	ra,72(sp)
    80003df6:	6406                	ld	s0,64(sp)
    80003df8:	7942                	ld	s2,48(sp)
    80003dfa:	7a02                	ld	s4,32(sp)
    80003dfc:	6b42                	ld	s6,16(sp)
    80003dfe:	6161                	addi	sp,sp,80
    80003e00:	8082                	ret
    80003e02:	fc26                	sd	s1,56(sp)
    80003e04:	f44e                	sd	s3,40(sp)
    80003e06:	ec56                	sd	s5,24(sp)
    80003e08:	e45e                	sd	s7,8(sp)
    80003e0a:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003e0c:	00004517          	auipc	a0,0x4
    80003e10:	72c50513          	addi	a0,a0,1836 # 80008538 <etext+0x538>
    80003e14:	00002097          	auipc	ra,0x2
    80003e18:	0f8080e7          	jalr	248(ra) # 80005f0c <panic>
    return -1;
    80003e1c:	557d                	li	a0,-1
}
    80003e1e:	8082                	ret
      return -1;
    80003e20:	557d                	li	a0,-1
    80003e22:	bfc9                	j	80003df4 <filewrite+0x10e>
    80003e24:	557d                	li	a0,-1
    80003e26:	b7f9                	j	80003df4 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e28:	557d                	li	a0,-1
    80003e2a:	79a2                	ld	s3,40(sp)
    80003e2c:	b7e1                	j	80003df4 <filewrite+0x10e>

0000000080003e2e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e2e:	7179                	addi	sp,sp,-48
    80003e30:	f406                	sd	ra,40(sp)
    80003e32:	f022                	sd	s0,32(sp)
    80003e34:	ec26                	sd	s1,24(sp)
    80003e36:	e052                	sd	s4,0(sp)
    80003e38:	1800                	addi	s0,sp,48
    80003e3a:	84aa                	mv	s1,a0
    80003e3c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e3e:	0005b023          	sd	zero,0(a1)
    80003e42:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e46:	00000097          	auipc	ra,0x0
    80003e4a:	bbe080e7          	jalr	-1090(ra) # 80003a04 <filealloc>
    80003e4e:	e088                	sd	a0,0(s1)
    80003e50:	cd49                	beqz	a0,80003eea <pipealloc+0xbc>
    80003e52:	00000097          	auipc	ra,0x0
    80003e56:	bb2080e7          	jalr	-1102(ra) # 80003a04 <filealloc>
    80003e5a:	00aa3023          	sd	a0,0(s4)
    80003e5e:	c141                	beqz	a0,80003ede <pipealloc+0xb0>
    80003e60:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e62:	ffffc097          	auipc	ra,0xffffc
    80003e66:	2b8080e7          	jalr	696(ra) # 8000011a <kalloc>
    80003e6a:	892a                	mv	s2,a0
    80003e6c:	c13d                	beqz	a0,80003ed2 <pipealloc+0xa4>
    80003e6e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e70:	4985                	li	s3,1
    80003e72:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e76:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e7a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e7e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e82:	00004597          	auipc	a1,0x4
    80003e86:	6c658593          	addi	a1,a1,1734 # 80008548 <etext+0x548>
    80003e8a:	00002097          	auipc	ra,0x2
    80003e8e:	56c080e7          	jalr	1388(ra) # 800063f6 <initlock>
  (*f0)->type = FD_PIPE;
    80003e92:	609c                	ld	a5,0(s1)
    80003e94:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e98:	609c                	ld	a5,0(s1)
    80003e9a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e9e:	609c                	ld	a5,0(s1)
    80003ea0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ea4:	609c                	ld	a5,0(s1)
    80003ea6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eaa:	000a3783          	ld	a5,0(s4)
    80003eae:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003eb2:	000a3783          	ld	a5,0(s4)
    80003eb6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eba:	000a3783          	ld	a5,0(s4)
    80003ebe:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ec2:	000a3783          	ld	a5,0(s4)
    80003ec6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eca:	4501                	li	a0,0
    80003ecc:	6942                	ld	s2,16(sp)
    80003ece:	69a2                	ld	s3,8(sp)
    80003ed0:	a03d                	j	80003efe <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ed2:	6088                	ld	a0,0(s1)
    80003ed4:	c119                	beqz	a0,80003eda <pipealloc+0xac>
    80003ed6:	6942                	ld	s2,16(sp)
    80003ed8:	a029                	j	80003ee2 <pipealloc+0xb4>
    80003eda:	6942                	ld	s2,16(sp)
    80003edc:	a039                	j	80003eea <pipealloc+0xbc>
    80003ede:	6088                	ld	a0,0(s1)
    80003ee0:	c50d                	beqz	a0,80003f0a <pipealloc+0xdc>
    fileclose(*f0);
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	bde080e7          	jalr	-1058(ra) # 80003ac0 <fileclose>
  if(*f1)
    80003eea:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eee:	557d                	li	a0,-1
  if(*f1)
    80003ef0:	c799                	beqz	a5,80003efe <pipealloc+0xd0>
    fileclose(*f1);
    80003ef2:	853e                	mv	a0,a5
    80003ef4:	00000097          	auipc	ra,0x0
    80003ef8:	bcc080e7          	jalr	-1076(ra) # 80003ac0 <fileclose>
  return -1;
    80003efc:	557d                	li	a0,-1
}
    80003efe:	70a2                	ld	ra,40(sp)
    80003f00:	7402                	ld	s0,32(sp)
    80003f02:	64e2                	ld	s1,24(sp)
    80003f04:	6a02                	ld	s4,0(sp)
    80003f06:	6145                	addi	sp,sp,48
    80003f08:	8082                	ret
  return -1;
    80003f0a:	557d                	li	a0,-1
    80003f0c:	bfcd                	j	80003efe <pipealloc+0xd0>

0000000080003f0e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f0e:	1101                	addi	sp,sp,-32
    80003f10:	ec06                	sd	ra,24(sp)
    80003f12:	e822                	sd	s0,16(sp)
    80003f14:	e426                	sd	s1,8(sp)
    80003f16:	e04a                	sd	s2,0(sp)
    80003f18:	1000                	addi	s0,sp,32
    80003f1a:	84aa                	mv	s1,a0
    80003f1c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f1e:	00002097          	auipc	ra,0x2
    80003f22:	568080e7          	jalr	1384(ra) # 80006486 <acquire>
  if(writable){
    80003f26:	02090d63          	beqz	s2,80003f60 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f2a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f2e:	21848513          	addi	a0,s1,536
    80003f32:	ffffd097          	auipc	ra,0xffffd
    80003f36:	79c080e7          	jalr	1948(ra) # 800016ce <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f3a:	2204b783          	ld	a5,544(s1)
    80003f3e:	eb95                	bnez	a5,80003f72 <pipeclose+0x64>
    release(&pi->lock);
    80003f40:	8526                	mv	a0,s1
    80003f42:	00002097          	auipc	ra,0x2
    80003f46:	5f8080e7          	jalr	1528(ra) # 8000653a <release>
    kfree((char*)pi);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	ffffc097          	auipc	ra,0xffffc
    80003f50:	0d0080e7          	jalr	208(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f54:	60e2                	ld	ra,24(sp)
    80003f56:	6442                	ld	s0,16(sp)
    80003f58:	64a2                	ld	s1,8(sp)
    80003f5a:	6902                	ld	s2,0(sp)
    80003f5c:	6105                	addi	sp,sp,32
    80003f5e:	8082                	ret
    pi->readopen = 0;
    80003f60:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f64:	21c48513          	addi	a0,s1,540
    80003f68:	ffffd097          	auipc	ra,0xffffd
    80003f6c:	766080e7          	jalr	1894(ra) # 800016ce <wakeup>
    80003f70:	b7e9                	j	80003f3a <pipeclose+0x2c>
    release(&pi->lock);
    80003f72:	8526                	mv	a0,s1
    80003f74:	00002097          	auipc	ra,0x2
    80003f78:	5c6080e7          	jalr	1478(ra) # 8000653a <release>
}
    80003f7c:	bfe1                	j	80003f54 <pipeclose+0x46>

0000000080003f7e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f7e:	711d                	addi	sp,sp,-96
    80003f80:	ec86                	sd	ra,88(sp)
    80003f82:	e8a2                	sd	s0,80(sp)
    80003f84:	e4a6                	sd	s1,72(sp)
    80003f86:	e0ca                	sd	s2,64(sp)
    80003f88:	fc4e                	sd	s3,56(sp)
    80003f8a:	f852                	sd	s4,48(sp)
    80003f8c:	f456                	sd	s5,40(sp)
    80003f8e:	1080                	addi	s0,sp,96
    80003f90:	84aa                	mv	s1,a0
    80003f92:	8aae                	mv	s5,a1
    80003f94:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f96:	ffffd097          	auipc	ra,0xffffd
    80003f9a:	ee6080e7          	jalr	-282(ra) # 80000e7c <myproc>
    80003f9e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	00002097          	auipc	ra,0x2
    80003fa6:	4e4080e7          	jalr	1252(ra) # 80006486 <acquire>
  while(i < n){
    80003faa:	0d405563          	blez	s4,80004074 <pipewrite+0xf6>
    80003fae:	f05a                	sd	s6,32(sp)
    80003fb0:	ec5e                	sd	s7,24(sp)
    80003fb2:	e862                	sd	s8,16(sp)
  int i = 0;
    80003fb4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fb6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fb8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fbc:	21c48b93          	addi	s7,s1,540
    80003fc0:	a089                	j	80004002 <pipewrite+0x84>
      release(&pi->lock);
    80003fc2:	8526                	mv	a0,s1
    80003fc4:	00002097          	auipc	ra,0x2
    80003fc8:	576080e7          	jalr	1398(ra) # 8000653a <release>
      return -1;
    80003fcc:	597d                	li	s2,-1
    80003fce:	7b02                	ld	s6,32(sp)
    80003fd0:	6be2                	ld	s7,24(sp)
    80003fd2:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fd4:	854a                	mv	a0,s2
    80003fd6:	60e6                	ld	ra,88(sp)
    80003fd8:	6446                	ld	s0,80(sp)
    80003fda:	64a6                	ld	s1,72(sp)
    80003fdc:	6906                	ld	s2,64(sp)
    80003fde:	79e2                	ld	s3,56(sp)
    80003fe0:	7a42                	ld	s4,48(sp)
    80003fe2:	7aa2                	ld	s5,40(sp)
    80003fe4:	6125                	addi	sp,sp,96
    80003fe6:	8082                	ret
      wakeup(&pi->nread);
    80003fe8:	8562                	mv	a0,s8
    80003fea:	ffffd097          	auipc	ra,0xffffd
    80003fee:	6e4080e7          	jalr	1764(ra) # 800016ce <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ff2:	85a6                	mv	a1,s1
    80003ff4:	855e                	mv	a0,s7
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	54c080e7          	jalr	1356(ra) # 80001542 <sleep>
  while(i < n){
    80003ffe:	05495c63          	bge	s2,s4,80004056 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80004002:	2204a783          	lw	a5,544(s1)
    80004006:	dfd5                	beqz	a5,80003fc2 <pipewrite+0x44>
    80004008:	0289a783          	lw	a5,40(s3)
    8000400c:	fbdd                	bnez	a5,80003fc2 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000400e:	2184a783          	lw	a5,536(s1)
    80004012:	21c4a703          	lw	a4,540(s1)
    80004016:	2007879b          	addiw	a5,a5,512
    8000401a:	fcf707e3          	beq	a4,a5,80003fe8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000401e:	4685                	li	a3,1
    80004020:	01590633          	add	a2,s2,s5
    80004024:	faf40593          	addi	a1,s0,-81
    80004028:	0509b503          	ld	a0,80(s3)
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	b78080e7          	jalr	-1160(ra) # 80000ba4 <copyin>
    80004034:	05650263          	beq	a0,s6,80004078 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004038:	21c4a783          	lw	a5,540(s1)
    8000403c:	0017871b          	addiw	a4,a5,1
    80004040:	20e4ae23          	sw	a4,540(s1)
    80004044:	1ff7f793          	andi	a5,a5,511
    80004048:	97a6                	add	a5,a5,s1
    8000404a:	faf44703          	lbu	a4,-81(s0)
    8000404e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004052:	2905                	addiw	s2,s2,1
    80004054:	b76d                	j	80003ffe <pipewrite+0x80>
    80004056:	7b02                	ld	s6,32(sp)
    80004058:	6be2                	ld	s7,24(sp)
    8000405a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000405c:	21848513          	addi	a0,s1,536
    80004060:	ffffd097          	auipc	ra,0xffffd
    80004064:	66e080e7          	jalr	1646(ra) # 800016ce <wakeup>
  release(&pi->lock);
    80004068:	8526                	mv	a0,s1
    8000406a:	00002097          	auipc	ra,0x2
    8000406e:	4d0080e7          	jalr	1232(ra) # 8000653a <release>
  return i;
    80004072:	b78d                	j	80003fd4 <pipewrite+0x56>
  int i = 0;
    80004074:	4901                	li	s2,0
    80004076:	b7dd                	j	8000405c <pipewrite+0xde>
    80004078:	7b02                	ld	s6,32(sp)
    8000407a:	6be2                	ld	s7,24(sp)
    8000407c:	6c42                	ld	s8,16(sp)
    8000407e:	bff9                	j	8000405c <pipewrite+0xde>

0000000080004080 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004080:	715d                	addi	sp,sp,-80
    80004082:	e486                	sd	ra,72(sp)
    80004084:	e0a2                	sd	s0,64(sp)
    80004086:	fc26                	sd	s1,56(sp)
    80004088:	f84a                	sd	s2,48(sp)
    8000408a:	f44e                	sd	s3,40(sp)
    8000408c:	f052                	sd	s4,32(sp)
    8000408e:	ec56                	sd	s5,24(sp)
    80004090:	0880                	addi	s0,sp,80
    80004092:	84aa                	mv	s1,a0
    80004094:	892e                	mv	s2,a1
    80004096:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	de4080e7          	jalr	-540(ra) # 80000e7c <myproc>
    800040a0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	3e2080e7          	jalr	994(ra) # 80006486 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ac:	2184a703          	lw	a4,536(s1)
    800040b0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040b4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b8:	02f71663          	bne	a4,a5,800040e4 <piperead+0x64>
    800040bc:	2244a783          	lw	a5,548(s1)
    800040c0:	cb9d                	beqz	a5,800040f6 <piperead+0x76>
    if(pr->killed){
    800040c2:	028a2783          	lw	a5,40(s4)
    800040c6:	e38d                	bnez	a5,800040e8 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040c8:	85a6                	mv	a1,s1
    800040ca:	854e                	mv	a0,s3
    800040cc:	ffffd097          	auipc	ra,0xffffd
    800040d0:	476080e7          	jalr	1142(ra) # 80001542 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040d4:	2184a703          	lw	a4,536(s1)
    800040d8:	21c4a783          	lw	a5,540(s1)
    800040dc:	fef700e3          	beq	a4,a5,800040bc <piperead+0x3c>
    800040e0:	e85a                	sd	s6,16(sp)
    800040e2:	a819                	j	800040f8 <piperead+0x78>
    800040e4:	e85a                	sd	s6,16(sp)
    800040e6:	a809                	j	800040f8 <piperead+0x78>
      release(&pi->lock);
    800040e8:	8526                	mv	a0,s1
    800040ea:	00002097          	auipc	ra,0x2
    800040ee:	450080e7          	jalr	1104(ra) # 8000653a <release>
      return -1;
    800040f2:	59fd                	li	s3,-1
    800040f4:	a0a5                	j	8000415c <piperead+0xdc>
    800040f6:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040fa:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040fc:	05505463          	blez	s5,80004144 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004100:	2184a783          	lw	a5,536(s1)
    80004104:	21c4a703          	lw	a4,540(s1)
    80004108:	02f70e63          	beq	a4,a5,80004144 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000410c:	0017871b          	addiw	a4,a5,1
    80004110:	20e4ac23          	sw	a4,536(s1)
    80004114:	1ff7f793          	andi	a5,a5,511
    80004118:	97a6                	add	a5,a5,s1
    8000411a:	0187c783          	lbu	a5,24(a5)
    8000411e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004122:	4685                	li	a3,1
    80004124:	fbf40613          	addi	a2,s0,-65
    80004128:	85ca                	mv	a1,s2
    8000412a:	050a3503          	ld	a0,80(s4)
    8000412e:	ffffd097          	auipc	ra,0xffffd
    80004132:	9ea080e7          	jalr	-1558(ra) # 80000b18 <copyout>
    80004136:	01650763          	beq	a0,s6,80004144 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000413a:	2985                	addiw	s3,s3,1
    8000413c:	0905                	addi	s2,s2,1
    8000413e:	fd3a91e3          	bne	s5,s3,80004100 <piperead+0x80>
    80004142:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004144:	21c48513          	addi	a0,s1,540
    80004148:	ffffd097          	auipc	ra,0xffffd
    8000414c:	586080e7          	jalr	1414(ra) # 800016ce <wakeup>
  release(&pi->lock);
    80004150:	8526                	mv	a0,s1
    80004152:	00002097          	auipc	ra,0x2
    80004156:	3e8080e7          	jalr	1000(ra) # 8000653a <release>
    8000415a:	6b42                	ld	s6,16(sp)
  return i;
}
    8000415c:	854e                	mv	a0,s3
    8000415e:	60a6                	ld	ra,72(sp)
    80004160:	6406                	ld	s0,64(sp)
    80004162:	74e2                	ld	s1,56(sp)
    80004164:	7942                	ld	s2,48(sp)
    80004166:	79a2                	ld	s3,40(sp)
    80004168:	7a02                	ld	s4,32(sp)
    8000416a:	6ae2                	ld	s5,24(sp)
    8000416c:	6161                	addi	sp,sp,80
    8000416e:	8082                	ret

0000000080004170 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004170:	df010113          	addi	sp,sp,-528
    80004174:	20113423          	sd	ra,520(sp)
    80004178:	20813023          	sd	s0,512(sp)
    8000417c:	ffa6                	sd	s1,504(sp)
    8000417e:	fbca                	sd	s2,496(sp)
    80004180:	0c00                	addi	s0,sp,528
    80004182:	892a                	mv	s2,a0
    80004184:	dea43c23          	sd	a0,-520(s0)
    80004188:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000418c:	ffffd097          	auipc	ra,0xffffd
    80004190:	cf0080e7          	jalr	-784(ra) # 80000e7c <myproc>
    80004194:	84aa                	mv	s1,a0

  begin_op();
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	460080e7          	jalr	1120(ra) # 800035f6 <begin_op>

  if((ip = namei(path)) == 0){
    8000419e:	854a                	mv	a0,s2
    800041a0:	fffff097          	auipc	ra,0xfffff
    800041a4:	256080e7          	jalr	598(ra) # 800033f6 <namei>
    800041a8:	c135                	beqz	a0,8000420c <exec+0x9c>
    800041aa:	f3d2                	sd	s4,480(sp)
    800041ac:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041ae:	fffff097          	auipc	ra,0xfffff
    800041b2:	9c6080e7          	jalr	-1594(ra) # 80002b74 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041b6:	04000713          	li	a4,64
    800041ba:	4681                	li	a3,0
    800041bc:	e5040613          	addi	a2,s0,-432
    800041c0:	4581                	li	a1,0
    800041c2:	8552                	mv	a0,s4
    800041c4:	fffff097          	auipc	ra,0xfffff
    800041c8:	d16080e7          	jalr	-746(ra) # 80002eda <readi>
    800041cc:	04000793          	li	a5,64
    800041d0:	00f51a63          	bne	a0,a5,800041e4 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041d4:	e5042703          	lw	a4,-432(s0)
    800041d8:	464c47b7          	lui	a5,0x464c4
    800041dc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041e0:	02f70c63          	beq	a4,a5,80004218 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041e4:	8552                	mv	a0,s4
    800041e6:	fffff097          	auipc	ra,0xfffff
    800041ea:	ca2080e7          	jalr	-862(ra) # 80002e88 <iunlockput>
    end_op();
    800041ee:	fffff097          	auipc	ra,0xfffff
    800041f2:	482080e7          	jalr	1154(ra) # 80003670 <end_op>
  }
  return -1;
    800041f6:	557d                	li	a0,-1
    800041f8:	7a1e                	ld	s4,480(sp)
}
    800041fa:	20813083          	ld	ra,520(sp)
    800041fe:	20013403          	ld	s0,512(sp)
    80004202:	74fe                	ld	s1,504(sp)
    80004204:	795e                	ld	s2,496(sp)
    80004206:	21010113          	addi	sp,sp,528
    8000420a:	8082                	ret
    end_op();
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	464080e7          	jalr	1124(ra) # 80003670 <end_op>
    return -1;
    80004214:	557d                	li	a0,-1
    80004216:	b7d5                	j	800041fa <exec+0x8a>
    80004218:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000421a:	8526                	mv	a0,s1
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	d24080e7          	jalr	-732(ra) # 80000f40 <proc_pagetable>
    80004224:	8b2a                	mv	s6,a0
    80004226:	30050563          	beqz	a0,80004530 <exec+0x3c0>
    8000422a:	f7ce                	sd	s3,488(sp)
    8000422c:	efd6                	sd	s5,472(sp)
    8000422e:	e7de                	sd	s7,456(sp)
    80004230:	e3e2                	sd	s8,448(sp)
    80004232:	ff66                	sd	s9,440(sp)
    80004234:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004236:	e7042d03          	lw	s10,-400(s0)
    8000423a:	e8845783          	lhu	a5,-376(s0)
    8000423e:	14078563          	beqz	a5,80004388 <exec+0x218>
    80004242:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004244:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004246:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004248:	6c85                	lui	s9,0x1
    8000424a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000424e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004252:	6a85                	lui	s5,0x1
    80004254:	a0b5                	j	800042c0 <exec+0x150>
      panic("loadseg: address should exist");
    80004256:	00004517          	auipc	a0,0x4
    8000425a:	2fa50513          	addi	a0,a0,762 # 80008550 <etext+0x550>
    8000425e:	00002097          	auipc	ra,0x2
    80004262:	cae080e7          	jalr	-850(ra) # 80005f0c <panic>
    if(sz - i < PGSIZE)
    80004266:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004268:	8726                	mv	a4,s1
    8000426a:	012c06bb          	addw	a3,s8,s2
    8000426e:	4581                	li	a1,0
    80004270:	8552                	mv	a0,s4
    80004272:	fffff097          	auipc	ra,0xfffff
    80004276:	c68080e7          	jalr	-920(ra) # 80002eda <readi>
    8000427a:	2501                	sext.w	a0,a0
    8000427c:	26a49e63          	bne	s1,a0,800044f8 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    80004280:	012a893b          	addw	s2,s5,s2
    80004284:	03397563          	bgeu	s2,s3,800042ae <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004288:	02091593          	slli	a1,s2,0x20
    8000428c:	9181                	srli	a1,a1,0x20
    8000428e:	95de                	add	a1,a1,s7
    80004290:	855a                	mv	a0,s6
    80004292:	ffffc097          	auipc	ra,0xffffc
    80004296:	266080e7          	jalr	614(ra) # 800004f8 <walkaddr>
    8000429a:	862a                	mv	a2,a0
    if(pa == 0)
    8000429c:	dd4d                	beqz	a0,80004256 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000429e:	412984bb          	subw	s1,s3,s2
    800042a2:	0004879b          	sext.w	a5,s1
    800042a6:	fcfcf0e3          	bgeu	s9,a5,80004266 <exec+0xf6>
    800042aa:	84d6                	mv	s1,s5
    800042ac:	bf6d                	j	80004266 <exec+0xf6>
    sz = sz1;
    800042ae:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042b2:	2d85                	addiw	s11,s11,1
    800042b4:	038d0d1b          	addiw	s10,s10,56
    800042b8:	e8845783          	lhu	a5,-376(s0)
    800042bc:	06fddf63          	bge	s11,a5,8000433a <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042c0:	2d01                	sext.w	s10,s10
    800042c2:	03800713          	li	a4,56
    800042c6:	86ea                	mv	a3,s10
    800042c8:	e1840613          	addi	a2,s0,-488
    800042cc:	4581                	li	a1,0
    800042ce:	8552                	mv	a0,s4
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	c0a080e7          	jalr	-1014(ra) # 80002eda <readi>
    800042d8:	03800793          	li	a5,56
    800042dc:	1ef51863          	bne	a0,a5,800044cc <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800042e0:	e1842783          	lw	a5,-488(s0)
    800042e4:	4705                	li	a4,1
    800042e6:	fce796e3          	bne	a5,a4,800042b2 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800042ea:	e4043603          	ld	a2,-448(s0)
    800042ee:	e3843783          	ld	a5,-456(s0)
    800042f2:	1ef66163          	bltu	a2,a5,800044d4 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042f6:	e2843783          	ld	a5,-472(s0)
    800042fa:	963e                	add	a2,a2,a5
    800042fc:	1ef66063          	bltu	a2,a5,800044dc <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004300:	85a6                	mv	a1,s1
    80004302:	855a                	mv	a0,s6
    80004304:	ffffc097          	auipc	ra,0xffffc
    80004308:	5b8080e7          	jalr	1464(ra) # 800008bc <uvmalloc>
    8000430c:	e0a43423          	sd	a0,-504(s0)
    80004310:	1c050a63          	beqz	a0,800044e4 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004314:	e2843b83          	ld	s7,-472(s0)
    80004318:	df043783          	ld	a5,-528(s0)
    8000431c:	00fbf7b3          	and	a5,s7,a5
    80004320:	1c079a63          	bnez	a5,800044f4 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004324:	e2042c03          	lw	s8,-480(s0)
    80004328:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000432c:	00098463          	beqz	s3,80004334 <exec+0x1c4>
    80004330:	4901                	li	s2,0
    80004332:	bf99                	j	80004288 <exec+0x118>
    sz = sz1;
    80004334:	e0843483          	ld	s1,-504(s0)
    80004338:	bfad                	j	800042b2 <exec+0x142>
    8000433a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000433c:	8552                	mv	a0,s4
    8000433e:	fffff097          	auipc	ra,0xfffff
    80004342:	b4a080e7          	jalr	-1206(ra) # 80002e88 <iunlockput>
  end_op();
    80004346:	fffff097          	auipc	ra,0xfffff
    8000434a:	32a080e7          	jalr	810(ra) # 80003670 <end_op>
  p = myproc();
    8000434e:	ffffd097          	auipc	ra,0xffffd
    80004352:	b2e080e7          	jalr	-1234(ra) # 80000e7c <myproc>
    80004356:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004358:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000435c:	6985                	lui	s3,0x1
    8000435e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004360:	99a6                	add	s3,s3,s1
    80004362:	77fd                	lui	a5,0xfffff
    80004364:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004368:	6609                	lui	a2,0x2
    8000436a:	964e                	add	a2,a2,s3
    8000436c:	85ce                	mv	a1,s3
    8000436e:	855a                	mv	a0,s6
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	54c080e7          	jalr	1356(ra) # 800008bc <uvmalloc>
    80004378:	892a                	mv	s2,a0
    8000437a:	e0a43423          	sd	a0,-504(s0)
    8000437e:	e519                	bnez	a0,8000438c <exec+0x21c>
  if(pagetable)
    80004380:	e1343423          	sd	s3,-504(s0)
    80004384:	4a01                	li	s4,0
    80004386:	aa95                	j	800044fa <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004388:	4481                	li	s1,0
    8000438a:	bf4d                	j	8000433c <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000438c:	75f9                	lui	a1,0xffffe
    8000438e:	95aa                	add	a1,a1,a0
    80004390:	855a                	mv	a0,s6
    80004392:	ffffc097          	auipc	ra,0xffffc
    80004396:	754080e7          	jalr	1876(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000439a:	7bfd                	lui	s7,0xfffff
    8000439c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000439e:	e0043783          	ld	a5,-512(s0)
    800043a2:	6388                	ld	a0,0(a5)
    800043a4:	c52d                	beqz	a0,8000440e <exec+0x29e>
    800043a6:	e9040993          	addi	s3,s0,-368
    800043aa:	f9040c13          	addi	s8,s0,-112
    800043ae:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043b0:	ffffc097          	auipc	ra,0xffffc
    800043b4:	f3e080e7          	jalr	-194(ra) # 800002ee <strlen>
    800043b8:	0015079b          	addiw	a5,a0,1
    800043bc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043c0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043c4:	13796463          	bltu	s2,s7,800044ec <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043c8:	e0043d03          	ld	s10,-512(s0)
    800043cc:	000d3a03          	ld	s4,0(s10)
    800043d0:	8552                	mv	a0,s4
    800043d2:	ffffc097          	auipc	ra,0xffffc
    800043d6:	f1c080e7          	jalr	-228(ra) # 800002ee <strlen>
    800043da:	0015069b          	addiw	a3,a0,1
    800043de:	8652                	mv	a2,s4
    800043e0:	85ca                	mv	a1,s2
    800043e2:	855a                	mv	a0,s6
    800043e4:	ffffc097          	auipc	ra,0xffffc
    800043e8:	734080e7          	jalr	1844(ra) # 80000b18 <copyout>
    800043ec:	10054263          	bltz	a0,800044f0 <exec+0x380>
    ustack[argc] = sp;
    800043f0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043f4:	0485                	addi	s1,s1,1
    800043f6:	008d0793          	addi	a5,s10,8
    800043fa:	e0f43023          	sd	a5,-512(s0)
    800043fe:	008d3503          	ld	a0,8(s10)
    80004402:	c909                	beqz	a0,80004414 <exec+0x2a4>
    if(argc >= MAXARG)
    80004404:	09a1                	addi	s3,s3,8
    80004406:	fb8995e3          	bne	s3,s8,800043b0 <exec+0x240>
  ip = 0;
    8000440a:	4a01                	li	s4,0
    8000440c:	a0fd                	j	800044fa <exec+0x38a>
  sp = sz;
    8000440e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004412:	4481                	li	s1,0
  ustack[argc] = 0;
    80004414:	00349793          	slli	a5,s1,0x3
    80004418:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffddd50>
    8000441c:	97a2                	add	a5,a5,s0
    8000441e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004422:	00148693          	addi	a3,s1,1
    80004426:	068e                	slli	a3,a3,0x3
    80004428:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000442c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004430:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004434:	f57966e3          	bltu	s2,s7,80004380 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004438:	e9040613          	addi	a2,s0,-368
    8000443c:	85ca                	mv	a1,s2
    8000443e:	855a                	mv	a0,s6
    80004440:	ffffc097          	auipc	ra,0xffffc
    80004444:	6d8080e7          	jalr	1752(ra) # 80000b18 <copyout>
    80004448:	0e054663          	bltz	a0,80004534 <exec+0x3c4>
  p->trapframe->a1 = sp;
    8000444c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004450:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004454:	df843783          	ld	a5,-520(s0)
    80004458:	0007c703          	lbu	a4,0(a5)
    8000445c:	cf11                	beqz	a4,80004478 <exec+0x308>
    8000445e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004460:	02f00693          	li	a3,47
    80004464:	a039                	j	80004472 <exec+0x302>
      last = s+1;
    80004466:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000446a:	0785                	addi	a5,a5,1
    8000446c:	fff7c703          	lbu	a4,-1(a5)
    80004470:	c701                	beqz	a4,80004478 <exec+0x308>
    if(*s == '/')
    80004472:	fed71ce3          	bne	a4,a3,8000446a <exec+0x2fa>
    80004476:	bfc5                	j	80004466 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004478:	4641                	li	a2,16
    8000447a:	df843583          	ld	a1,-520(s0)
    8000447e:	158a8513          	addi	a0,s5,344
    80004482:	ffffc097          	auipc	ra,0xffffc
    80004486:	e3a080e7          	jalr	-454(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    8000448a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000448e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004492:	e0843783          	ld	a5,-504(s0)
    80004496:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000449a:	058ab783          	ld	a5,88(s5)
    8000449e:	e6843703          	ld	a4,-408(s0)
    800044a2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044a4:	058ab783          	ld	a5,88(s5)
    800044a8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044ac:	85e6                	mv	a1,s9
    800044ae:	ffffd097          	auipc	ra,0xffffd
    800044b2:	b2e080e7          	jalr	-1234(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044b6:	0004851b          	sext.w	a0,s1
    800044ba:	79be                	ld	s3,488(sp)
    800044bc:	7a1e                	ld	s4,480(sp)
    800044be:	6afe                	ld	s5,472(sp)
    800044c0:	6b5e                	ld	s6,464(sp)
    800044c2:	6bbe                	ld	s7,456(sp)
    800044c4:	6c1e                	ld	s8,448(sp)
    800044c6:	7cfa                	ld	s9,440(sp)
    800044c8:	7d5a                	ld	s10,432(sp)
    800044ca:	bb05                	j	800041fa <exec+0x8a>
    800044cc:	e0943423          	sd	s1,-504(s0)
    800044d0:	7dba                	ld	s11,424(sp)
    800044d2:	a025                	j	800044fa <exec+0x38a>
    800044d4:	e0943423          	sd	s1,-504(s0)
    800044d8:	7dba                	ld	s11,424(sp)
    800044da:	a005                	j	800044fa <exec+0x38a>
    800044dc:	e0943423          	sd	s1,-504(s0)
    800044e0:	7dba                	ld	s11,424(sp)
    800044e2:	a821                	j	800044fa <exec+0x38a>
    800044e4:	e0943423          	sd	s1,-504(s0)
    800044e8:	7dba                	ld	s11,424(sp)
    800044ea:	a801                	j	800044fa <exec+0x38a>
  ip = 0;
    800044ec:	4a01                	li	s4,0
    800044ee:	a031                	j	800044fa <exec+0x38a>
    800044f0:	4a01                	li	s4,0
  if(pagetable)
    800044f2:	a021                	j	800044fa <exec+0x38a>
    800044f4:	7dba                	ld	s11,424(sp)
    800044f6:	a011                	j	800044fa <exec+0x38a>
    800044f8:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800044fa:	e0843583          	ld	a1,-504(s0)
    800044fe:	855a                	mv	a0,s6
    80004500:	ffffd097          	auipc	ra,0xffffd
    80004504:	adc080e7          	jalr	-1316(ra) # 80000fdc <proc_freepagetable>
  return -1;
    80004508:	557d                	li	a0,-1
  if(ip){
    8000450a:	000a1b63          	bnez	s4,80004520 <exec+0x3b0>
    8000450e:	79be                	ld	s3,488(sp)
    80004510:	7a1e                	ld	s4,480(sp)
    80004512:	6afe                	ld	s5,472(sp)
    80004514:	6b5e                	ld	s6,464(sp)
    80004516:	6bbe                	ld	s7,456(sp)
    80004518:	6c1e                	ld	s8,448(sp)
    8000451a:	7cfa                	ld	s9,440(sp)
    8000451c:	7d5a                	ld	s10,432(sp)
    8000451e:	b9f1                	j	800041fa <exec+0x8a>
    80004520:	79be                	ld	s3,488(sp)
    80004522:	6afe                	ld	s5,472(sp)
    80004524:	6b5e                	ld	s6,464(sp)
    80004526:	6bbe                	ld	s7,456(sp)
    80004528:	6c1e                	ld	s8,448(sp)
    8000452a:	7cfa                	ld	s9,440(sp)
    8000452c:	7d5a                	ld	s10,432(sp)
    8000452e:	b95d                	j	800041e4 <exec+0x74>
    80004530:	6b5e                	ld	s6,464(sp)
    80004532:	b94d                	j	800041e4 <exec+0x74>
  sz = sz1;
    80004534:	e0843983          	ld	s3,-504(s0)
    80004538:	b5a1                	j	80004380 <exec+0x210>

000000008000453a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000453a:	7179                	addi	sp,sp,-48
    8000453c:	f406                	sd	ra,40(sp)
    8000453e:	f022                	sd	s0,32(sp)
    80004540:	ec26                	sd	s1,24(sp)
    80004542:	e84a                	sd	s2,16(sp)
    80004544:	1800                	addi	s0,sp,48
    80004546:	892e                	mv	s2,a1
    80004548:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000454a:	fdc40593          	addi	a1,s0,-36
    8000454e:	ffffe097          	auipc	ra,0xffffe
    80004552:	9e8080e7          	jalr	-1560(ra) # 80001f36 <argint>
    80004556:	04054063          	bltz	a0,80004596 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000455a:	fdc42703          	lw	a4,-36(s0)
    8000455e:	47bd                	li	a5,15
    80004560:	02e7ed63          	bltu	a5,a4,8000459a <argfd+0x60>
    80004564:	ffffd097          	auipc	ra,0xffffd
    80004568:	918080e7          	jalr	-1768(ra) # 80000e7c <myproc>
    8000456c:	fdc42703          	lw	a4,-36(s0)
    80004570:	01a70793          	addi	a5,a4,26
    80004574:	078e                	slli	a5,a5,0x3
    80004576:	953e                	add	a0,a0,a5
    80004578:	611c                	ld	a5,0(a0)
    8000457a:	c395                	beqz	a5,8000459e <argfd+0x64>
    return -1;
  if(pfd)
    8000457c:	00090463          	beqz	s2,80004584 <argfd+0x4a>
    *pfd = fd;
    80004580:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004584:	4501                	li	a0,0
  if(pf)
    80004586:	c091                	beqz	s1,8000458a <argfd+0x50>
    *pf = f;
    80004588:	e09c                	sd	a5,0(s1)
}
    8000458a:	70a2                	ld	ra,40(sp)
    8000458c:	7402                	ld	s0,32(sp)
    8000458e:	64e2                	ld	s1,24(sp)
    80004590:	6942                	ld	s2,16(sp)
    80004592:	6145                	addi	sp,sp,48
    80004594:	8082                	ret
    return -1;
    80004596:	557d                	li	a0,-1
    80004598:	bfcd                	j	8000458a <argfd+0x50>
    return -1;
    8000459a:	557d                	li	a0,-1
    8000459c:	b7fd                	j	8000458a <argfd+0x50>
    8000459e:	557d                	li	a0,-1
    800045a0:	b7ed                	j	8000458a <argfd+0x50>

00000000800045a2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045a2:	1101                	addi	sp,sp,-32
    800045a4:	ec06                	sd	ra,24(sp)
    800045a6:	e822                	sd	s0,16(sp)
    800045a8:	e426                	sd	s1,8(sp)
    800045aa:	1000                	addi	s0,sp,32
    800045ac:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045ae:	ffffd097          	auipc	ra,0xffffd
    800045b2:	8ce080e7          	jalr	-1842(ra) # 80000e7c <myproc>
    800045b6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045b8:	0d050793          	addi	a5,a0,208
    800045bc:	4501                	li	a0,0
    800045be:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045c0:	6398                	ld	a4,0(a5)
    800045c2:	cb19                	beqz	a4,800045d8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045c4:	2505                	addiw	a0,a0,1
    800045c6:	07a1                	addi	a5,a5,8
    800045c8:	fed51ce3          	bne	a0,a3,800045c0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045cc:	557d                	li	a0,-1
}
    800045ce:	60e2                	ld	ra,24(sp)
    800045d0:	6442                	ld	s0,16(sp)
    800045d2:	64a2                	ld	s1,8(sp)
    800045d4:	6105                	addi	sp,sp,32
    800045d6:	8082                	ret
      p->ofile[fd] = f;
    800045d8:	01a50793          	addi	a5,a0,26
    800045dc:	078e                	slli	a5,a5,0x3
    800045de:	963e                	add	a2,a2,a5
    800045e0:	e204                	sd	s1,0(a2)
      return fd;
    800045e2:	b7f5                	j	800045ce <fdalloc+0x2c>

00000000800045e4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045e4:	715d                	addi	sp,sp,-80
    800045e6:	e486                	sd	ra,72(sp)
    800045e8:	e0a2                	sd	s0,64(sp)
    800045ea:	fc26                	sd	s1,56(sp)
    800045ec:	f84a                	sd	s2,48(sp)
    800045ee:	f44e                	sd	s3,40(sp)
    800045f0:	f052                	sd	s4,32(sp)
    800045f2:	ec56                	sd	s5,24(sp)
    800045f4:	0880                	addi	s0,sp,80
    800045f6:	8aae                	mv	s5,a1
    800045f8:	8a32                	mv	s4,a2
    800045fa:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045fc:	fb040593          	addi	a1,s0,-80
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	e14080e7          	jalr	-492(ra) # 80003414 <nameiparent>
    80004608:	892a                	mv	s2,a0
    8000460a:	12050c63          	beqz	a0,80004742 <create+0x15e>
    return 0;

  ilock(dp);
    8000460e:	ffffe097          	auipc	ra,0xffffe
    80004612:	566080e7          	jalr	1382(ra) # 80002b74 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004616:	4601                	li	a2,0
    80004618:	fb040593          	addi	a1,s0,-80
    8000461c:	854a                	mv	a0,s2
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	b06080e7          	jalr	-1274(ra) # 80003124 <dirlookup>
    80004626:	84aa                	mv	s1,a0
    80004628:	c539                	beqz	a0,80004676 <create+0x92>
    iunlockput(dp);
    8000462a:	854a                	mv	a0,s2
    8000462c:	fffff097          	auipc	ra,0xfffff
    80004630:	85c080e7          	jalr	-1956(ra) # 80002e88 <iunlockput>
    ilock(ip);
    80004634:	8526                	mv	a0,s1
    80004636:	ffffe097          	auipc	ra,0xffffe
    8000463a:	53e080e7          	jalr	1342(ra) # 80002b74 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000463e:	4789                	li	a5,2
    80004640:	02fa9463          	bne	s5,a5,80004668 <create+0x84>
    80004644:	0444d783          	lhu	a5,68(s1)
    80004648:	37f9                	addiw	a5,a5,-2
    8000464a:	17c2                	slli	a5,a5,0x30
    8000464c:	93c1                	srli	a5,a5,0x30
    8000464e:	4705                	li	a4,1
    80004650:	00f76c63          	bltu	a4,a5,80004668 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004654:	8526                	mv	a0,s1
    80004656:	60a6                	ld	ra,72(sp)
    80004658:	6406                	ld	s0,64(sp)
    8000465a:	74e2                	ld	s1,56(sp)
    8000465c:	7942                	ld	s2,48(sp)
    8000465e:	79a2                	ld	s3,40(sp)
    80004660:	7a02                	ld	s4,32(sp)
    80004662:	6ae2                	ld	s5,24(sp)
    80004664:	6161                	addi	sp,sp,80
    80004666:	8082                	ret
    iunlockput(ip);
    80004668:	8526                	mv	a0,s1
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	81e080e7          	jalr	-2018(ra) # 80002e88 <iunlockput>
    return 0;
    80004672:	4481                	li	s1,0
    80004674:	b7c5                	j	80004654 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004676:	85d6                	mv	a1,s5
    80004678:	00092503          	lw	a0,0(s2)
    8000467c:	ffffe097          	auipc	ra,0xffffe
    80004680:	364080e7          	jalr	868(ra) # 800029e0 <ialloc>
    80004684:	84aa                	mv	s1,a0
    80004686:	c139                	beqz	a0,800046cc <create+0xe8>
  ilock(ip);
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	4ec080e7          	jalr	1260(ra) # 80002b74 <ilock>
  ip->major = major;
    80004690:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004694:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004698:	4985                	li	s3,1
    8000469a:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000469e:	8526                	mv	a0,s1
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	408080e7          	jalr	1032(ra) # 80002aa8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046a8:	033a8a63          	beq	s5,s3,800046dc <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800046ac:	40d0                	lw	a2,4(s1)
    800046ae:	fb040593          	addi	a1,s0,-80
    800046b2:	854a                	mv	a0,s2
    800046b4:	fffff097          	auipc	ra,0xfffff
    800046b8:	c80080e7          	jalr	-896(ra) # 80003334 <dirlink>
    800046bc:	06054b63          	bltz	a0,80004732 <create+0x14e>
  iunlockput(dp);
    800046c0:	854a                	mv	a0,s2
    800046c2:	ffffe097          	auipc	ra,0xffffe
    800046c6:	7c6080e7          	jalr	1990(ra) # 80002e88 <iunlockput>
  return ip;
    800046ca:	b769                	j	80004654 <create+0x70>
    panic("create: ialloc");
    800046cc:	00004517          	auipc	a0,0x4
    800046d0:	ea450513          	addi	a0,a0,-348 # 80008570 <etext+0x570>
    800046d4:	00002097          	auipc	ra,0x2
    800046d8:	838080e7          	jalr	-1992(ra) # 80005f0c <panic>
    dp->nlink++;  // for ".."
    800046dc:	04a95783          	lhu	a5,74(s2)
    800046e0:	2785                	addiw	a5,a5,1
    800046e2:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046e6:	854a                	mv	a0,s2
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	3c0080e7          	jalr	960(ra) # 80002aa8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046f0:	40d0                	lw	a2,4(s1)
    800046f2:	00004597          	auipc	a1,0x4
    800046f6:	e8e58593          	addi	a1,a1,-370 # 80008580 <etext+0x580>
    800046fa:	8526                	mv	a0,s1
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	c38080e7          	jalr	-968(ra) # 80003334 <dirlink>
    80004704:	00054f63          	bltz	a0,80004722 <create+0x13e>
    80004708:	00492603          	lw	a2,4(s2)
    8000470c:	00004597          	auipc	a1,0x4
    80004710:	e7c58593          	addi	a1,a1,-388 # 80008588 <etext+0x588>
    80004714:	8526                	mv	a0,s1
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	c1e080e7          	jalr	-994(ra) # 80003334 <dirlink>
    8000471e:	f80557e3          	bgez	a0,800046ac <create+0xc8>
      panic("create dots");
    80004722:	00004517          	auipc	a0,0x4
    80004726:	e6e50513          	addi	a0,a0,-402 # 80008590 <etext+0x590>
    8000472a:	00001097          	auipc	ra,0x1
    8000472e:	7e2080e7          	jalr	2018(ra) # 80005f0c <panic>
    panic("create: dirlink");
    80004732:	00004517          	auipc	a0,0x4
    80004736:	e6e50513          	addi	a0,a0,-402 # 800085a0 <etext+0x5a0>
    8000473a:	00001097          	auipc	ra,0x1
    8000473e:	7d2080e7          	jalr	2002(ra) # 80005f0c <panic>
    return 0;
    80004742:	84aa                	mv	s1,a0
    80004744:	bf01                	j	80004654 <create+0x70>

0000000080004746 <sys_dup>:
{
    80004746:	7179                	addi	sp,sp,-48
    80004748:	f406                	sd	ra,40(sp)
    8000474a:	f022                	sd	s0,32(sp)
    8000474c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000474e:	fd840613          	addi	a2,s0,-40
    80004752:	4581                	li	a1,0
    80004754:	4501                	li	a0,0
    80004756:	00000097          	auipc	ra,0x0
    8000475a:	de4080e7          	jalr	-540(ra) # 8000453a <argfd>
    return -1;
    8000475e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004760:	02054763          	bltz	a0,8000478e <sys_dup+0x48>
    80004764:	ec26                	sd	s1,24(sp)
    80004766:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004768:	fd843903          	ld	s2,-40(s0)
    8000476c:	854a                	mv	a0,s2
    8000476e:	00000097          	auipc	ra,0x0
    80004772:	e34080e7          	jalr	-460(ra) # 800045a2 <fdalloc>
    80004776:	84aa                	mv	s1,a0
    return -1;
    80004778:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000477a:	00054f63          	bltz	a0,80004798 <sys_dup+0x52>
  filedup(f);
    8000477e:	854a                	mv	a0,s2
    80004780:	fffff097          	auipc	ra,0xfffff
    80004784:	2ee080e7          	jalr	750(ra) # 80003a6e <filedup>
  return fd;
    80004788:	87a6                	mv	a5,s1
    8000478a:	64e2                	ld	s1,24(sp)
    8000478c:	6942                	ld	s2,16(sp)
}
    8000478e:	853e                	mv	a0,a5
    80004790:	70a2                	ld	ra,40(sp)
    80004792:	7402                	ld	s0,32(sp)
    80004794:	6145                	addi	sp,sp,48
    80004796:	8082                	ret
    80004798:	64e2                	ld	s1,24(sp)
    8000479a:	6942                	ld	s2,16(sp)
    8000479c:	bfcd                	j	8000478e <sys_dup+0x48>

000000008000479e <sys_read>:
{
    8000479e:	7179                	addi	sp,sp,-48
    800047a0:	f406                	sd	ra,40(sp)
    800047a2:	f022                	sd	s0,32(sp)
    800047a4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047a6:	fe840613          	addi	a2,s0,-24
    800047aa:	4581                	li	a1,0
    800047ac:	4501                	li	a0,0
    800047ae:	00000097          	auipc	ra,0x0
    800047b2:	d8c080e7          	jalr	-628(ra) # 8000453a <argfd>
    return -1;
    800047b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047b8:	04054163          	bltz	a0,800047fa <sys_read+0x5c>
    800047bc:	fe440593          	addi	a1,s0,-28
    800047c0:	4509                	li	a0,2
    800047c2:	ffffd097          	auipc	ra,0xffffd
    800047c6:	774080e7          	jalr	1908(ra) # 80001f36 <argint>
    return -1;
    800047ca:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047cc:	02054763          	bltz	a0,800047fa <sys_read+0x5c>
    800047d0:	fd840593          	addi	a1,s0,-40
    800047d4:	4505                	li	a0,1
    800047d6:	ffffd097          	auipc	ra,0xffffd
    800047da:	782080e7          	jalr	1922(ra) # 80001f58 <argaddr>
    return -1;
    800047de:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047e0:	00054d63          	bltz	a0,800047fa <sys_read+0x5c>
  return fileread(f, p, n);
    800047e4:	fe442603          	lw	a2,-28(s0)
    800047e8:	fd843583          	ld	a1,-40(s0)
    800047ec:	fe843503          	ld	a0,-24(s0)
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	424080e7          	jalr	1060(ra) # 80003c14 <fileread>
    800047f8:	87aa                	mv	a5,a0
}
    800047fa:	853e                	mv	a0,a5
    800047fc:	70a2                	ld	ra,40(sp)
    800047fe:	7402                	ld	s0,32(sp)
    80004800:	6145                	addi	sp,sp,48
    80004802:	8082                	ret

0000000080004804 <sys_write>:
{
    80004804:	7179                	addi	sp,sp,-48
    80004806:	f406                	sd	ra,40(sp)
    80004808:	f022                	sd	s0,32(sp)
    8000480a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000480c:	fe840613          	addi	a2,s0,-24
    80004810:	4581                	li	a1,0
    80004812:	4501                	li	a0,0
    80004814:	00000097          	auipc	ra,0x0
    80004818:	d26080e7          	jalr	-730(ra) # 8000453a <argfd>
    return -1;
    8000481c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000481e:	04054163          	bltz	a0,80004860 <sys_write+0x5c>
    80004822:	fe440593          	addi	a1,s0,-28
    80004826:	4509                	li	a0,2
    80004828:	ffffd097          	auipc	ra,0xffffd
    8000482c:	70e080e7          	jalr	1806(ra) # 80001f36 <argint>
    return -1;
    80004830:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004832:	02054763          	bltz	a0,80004860 <sys_write+0x5c>
    80004836:	fd840593          	addi	a1,s0,-40
    8000483a:	4505                	li	a0,1
    8000483c:	ffffd097          	auipc	ra,0xffffd
    80004840:	71c080e7          	jalr	1820(ra) # 80001f58 <argaddr>
    return -1;
    80004844:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004846:	00054d63          	bltz	a0,80004860 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000484a:	fe442603          	lw	a2,-28(s0)
    8000484e:	fd843583          	ld	a1,-40(s0)
    80004852:	fe843503          	ld	a0,-24(s0)
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	490080e7          	jalr	1168(ra) # 80003ce6 <filewrite>
    8000485e:	87aa                	mv	a5,a0
}
    80004860:	853e                	mv	a0,a5
    80004862:	70a2                	ld	ra,40(sp)
    80004864:	7402                	ld	s0,32(sp)
    80004866:	6145                	addi	sp,sp,48
    80004868:	8082                	ret

000000008000486a <sys_close>:
{
    8000486a:	1101                	addi	sp,sp,-32
    8000486c:	ec06                	sd	ra,24(sp)
    8000486e:	e822                	sd	s0,16(sp)
    80004870:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004872:	fe040613          	addi	a2,s0,-32
    80004876:	fec40593          	addi	a1,s0,-20
    8000487a:	4501                	li	a0,0
    8000487c:	00000097          	auipc	ra,0x0
    80004880:	cbe080e7          	jalr	-834(ra) # 8000453a <argfd>
    return -1;
    80004884:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004886:	02054463          	bltz	a0,800048ae <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000488a:	ffffc097          	auipc	ra,0xffffc
    8000488e:	5f2080e7          	jalr	1522(ra) # 80000e7c <myproc>
    80004892:	fec42783          	lw	a5,-20(s0)
    80004896:	07e9                	addi	a5,a5,26
    80004898:	078e                	slli	a5,a5,0x3
    8000489a:	953e                	add	a0,a0,a5
    8000489c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800048a0:	fe043503          	ld	a0,-32(s0)
    800048a4:	fffff097          	auipc	ra,0xfffff
    800048a8:	21c080e7          	jalr	540(ra) # 80003ac0 <fileclose>
  return 0;
    800048ac:	4781                	li	a5,0
}
    800048ae:	853e                	mv	a0,a5
    800048b0:	60e2                	ld	ra,24(sp)
    800048b2:	6442                	ld	s0,16(sp)
    800048b4:	6105                	addi	sp,sp,32
    800048b6:	8082                	ret

00000000800048b8 <sys_fstat>:
{
    800048b8:	1101                	addi	sp,sp,-32
    800048ba:	ec06                	sd	ra,24(sp)
    800048bc:	e822                	sd	s0,16(sp)
    800048be:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048c0:	fe840613          	addi	a2,s0,-24
    800048c4:	4581                	li	a1,0
    800048c6:	4501                	li	a0,0
    800048c8:	00000097          	auipc	ra,0x0
    800048cc:	c72080e7          	jalr	-910(ra) # 8000453a <argfd>
    return -1;
    800048d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048d2:	02054563          	bltz	a0,800048fc <sys_fstat+0x44>
    800048d6:	fe040593          	addi	a1,s0,-32
    800048da:	4505                	li	a0,1
    800048dc:	ffffd097          	auipc	ra,0xffffd
    800048e0:	67c080e7          	jalr	1660(ra) # 80001f58 <argaddr>
    return -1;
    800048e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048e6:	00054b63          	bltz	a0,800048fc <sys_fstat+0x44>
  return filestat(f, st);
    800048ea:	fe043583          	ld	a1,-32(s0)
    800048ee:	fe843503          	ld	a0,-24(s0)
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	2b0080e7          	jalr	688(ra) # 80003ba2 <filestat>
    800048fa:	87aa                	mv	a5,a0
}
    800048fc:	853e                	mv	a0,a5
    800048fe:	60e2                	ld	ra,24(sp)
    80004900:	6442                	ld	s0,16(sp)
    80004902:	6105                	addi	sp,sp,32
    80004904:	8082                	ret

0000000080004906 <sys_link>:
{
    80004906:	7169                	addi	sp,sp,-304
    80004908:	f606                	sd	ra,296(sp)
    8000490a:	f222                	sd	s0,288(sp)
    8000490c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000490e:	08000613          	li	a2,128
    80004912:	ed040593          	addi	a1,s0,-304
    80004916:	4501                	li	a0,0
    80004918:	ffffd097          	auipc	ra,0xffffd
    8000491c:	662080e7          	jalr	1634(ra) # 80001f7a <argstr>
    return -1;
    80004920:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004922:	12054663          	bltz	a0,80004a4e <sys_link+0x148>
    80004926:	08000613          	li	a2,128
    8000492a:	f5040593          	addi	a1,s0,-176
    8000492e:	4505                	li	a0,1
    80004930:	ffffd097          	auipc	ra,0xffffd
    80004934:	64a080e7          	jalr	1610(ra) # 80001f7a <argstr>
    return -1;
    80004938:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000493a:	10054a63          	bltz	a0,80004a4e <sys_link+0x148>
    8000493e:	ee26                	sd	s1,280(sp)
  begin_op();
    80004940:	fffff097          	auipc	ra,0xfffff
    80004944:	cb6080e7          	jalr	-842(ra) # 800035f6 <begin_op>
  if((ip = namei(old)) == 0){
    80004948:	ed040513          	addi	a0,s0,-304
    8000494c:	fffff097          	auipc	ra,0xfffff
    80004950:	aaa080e7          	jalr	-1366(ra) # 800033f6 <namei>
    80004954:	84aa                	mv	s1,a0
    80004956:	c949                	beqz	a0,800049e8 <sys_link+0xe2>
  ilock(ip);
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	21c080e7          	jalr	540(ra) # 80002b74 <ilock>
  if(ip->type == T_DIR){
    80004960:	04449703          	lh	a4,68(s1)
    80004964:	4785                	li	a5,1
    80004966:	08f70863          	beq	a4,a5,800049f6 <sys_link+0xf0>
    8000496a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000496c:	04a4d783          	lhu	a5,74(s1)
    80004970:	2785                	addiw	a5,a5,1
    80004972:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004976:	8526                	mv	a0,s1
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	130080e7          	jalr	304(ra) # 80002aa8 <iupdate>
  iunlock(ip);
    80004980:	8526                	mv	a0,s1
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	2b8080e7          	jalr	696(ra) # 80002c3a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000498a:	fd040593          	addi	a1,s0,-48
    8000498e:	f5040513          	addi	a0,s0,-176
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	a82080e7          	jalr	-1406(ra) # 80003414 <nameiparent>
    8000499a:	892a                	mv	s2,a0
    8000499c:	cd35                	beqz	a0,80004a18 <sys_link+0x112>
  ilock(dp);
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	1d6080e7          	jalr	470(ra) # 80002b74 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049a6:	00092703          	lw	a4,0(s2)
    800049aa:	409c                	lw	a5,0(s1)
    800049ac:	06f71163          	bne	a4,a5,80004a0e <sys_link+0x108>
    800049b0:	40d0                	lw	a2,4(s1)
    800049b2:	fd040593          	addi	a1,s0,-48
    800049b6:	854a                	mv	a0,s2
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	97c080e7          	jalr	-1668(ra) # 80003334 <dirlink>
    800049c0:	04054763          	bltz	a0,80004a0e <sys_link+0x108>
  iunlockput(dp);
    800049c4:	854a                	mv	a0,s2
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	4c2080e7          	jalr	1218(ra) # 80002e88 <iunlockput>
  iput(ip);
    800049ce:	8526                	mv	a0,s1
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	410080e7          	jalr	1040(ra) # 80002de0 <iput>
  end_op();
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	c98080e7          	jalr	-872(ra) # 80003670 <end_op>
  return 0;
    800049e0:	4781                	li	a5,0
    800049e2:	64f2                	ld	s1,280(sp)
    800049e4:	6952                	ld	s2,272(sp)
    800049e6:	a0a5                	j	80004a4e <sys_link+0x148>
    end_op();
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	c88080e7          	jalr	-888(ra) # 80003670 <end_op>
    return -1;
    800049f0:	57fd                	li	a5,-1
    800049f2:	64f2                	ld	s1,280(sp)
    800049f4:	a8a9                	j	80004a4e <sys_link+0x148>
    iunlockput(ip);
    800049f6:	8526                	mv	a0,s1
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	490080e7          	jalr	1168(ra) # 80002e88 <iunlockput>
    end_op();
    80004a00:	fffff097          	auipc	ra,0xfffff
    80004a04:	c70080e7          	jalr	-912(ra) # 80003670 <end_op>
    return -1;
    80004a08:	57fd                	li	a5,-1
    80004a0a:	64f2                	ld	s1,280(sp)
    80004a0c:	a089                	j	80004a4e <sys_link+0x148>
    iunlockput(dp);
    80004a0e:	854a                	mv	a0,s2
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	478080e7          	jalr	1144(ra) # 80002e88 <iunlockput>
  ilock(ip);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	15a080e7          	jalr	346(ra) # 80002b74 <ilock>
  ip->nlink--;
    80004a22:	04a4d783          	lhu	a5,74(s1)
    80004a26:	37fd                	addiw	a5,a5,-1
    80004a28:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a2c:	8526                	mv	a0,s1
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	07a080e7          	jalr	122(ra) # 80002aa8 <iupdate>
  iunlockput(ip);
    80004a36:	8526                	mv	a0,s1
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	450080e7          	jalr	1104(ra) # 80002e88 <iunlockput>
  end_op();
    80004a40:	fffff097          	auipc	ra,0xfffff
    80004a44:	c30080e7          	jalr	-976(ra) # 80003670 <end_op>
  return -1;
    80004a48:	57fd                	li	a5,-1
    80004a4a:	64f2                	ld	s1,280(sp)
    80004a4c:	6952                	ld	s2,272(sp)
}
    80004a4e:	853e                	mv	a0,a5
    80004a50:	70b2                	ld	ra,296(sp)
    80004a52:	7412                	ld	s0,288(sp)
    80004a54:	6155                	addi	sp,sp,304
    80004a56:	8082                	ret

0000000080004a58 <sys_unlink>:
{
    80004a58:	7151                	addi	sp,sp,-240
    80004a5a:	f586                	sd	ra,232(sp)
    80004a5c:	f1a2                	sd	s0,224(sp)
    80004a5e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a60:	08000613          	li	a2,128
    80004a64:	f3040593          	addi	a1,s0,-208
    80004a68:	4501                	li	a0,0
    80004a6a:	ffffd097          	auipc	ra,0xffffd
    80004a6e:	510080e7          	jalr	1296(ra) # 80001f7a <argstr>
    80004a72:	1a054a63          	bltz	a0,80004c26 <sys_unlink+0x1ce>
    80004a76:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	b7e080e7          	jalr	-1154(ra) # 800035f6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a80:	fb040593          	addi	a1,s0,-80
    80004a84:	f3040513          	addi	a0,s0,-208
    80004a88:	fffff097          	auipc	ra,0xfffff
    80004a8c:	98c080e7          	jalr	-1652(ra) # 80003414 <nameiparent>
    80004a90:	84aa                	mv	s1,a0
    80004a92:	cd71                	beqz	a0,80004b6e <sys_unlink+0x116>
  ilock(dp);
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	0e0080e7          	jalr	224(ra) # 80002b74 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a9c:	00004597          	auipc	a1,0x4
    80004aa0:	ae458593          	addi	a1,a1,-1308 # 80008580 <etext+0x580>
    80004aa4:	fb040513          	addi	a0,s0,-80
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	662080e7          	jalr	1634(ra) # 8000310a <namecmp>
    80004ab0:	14050c63          	beqz	a0,80004c08 <sys_unlink+0x1b0>
    80004ab4:	00004597          	auipc	a1,0x4
    80004ab8:	ad458593          	addi	a1,a1,-1324 # 80008588 <etext+0x588>
    80004abc:	fb040513          	addi	a0,s0,-80
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	64a080e7          	jalr	1610(ra) # 8000310a <namecmp>
    80004ac8:	14050063          	beqz	a0,80004c08 <sys_unlink+0x1b0>
    80004acc:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ace:	f2c40613          	addi	a2,s0,-212
    80004ad2:	fb040593          	addi	a1,s0,-80
    80004ad6:	8526                	mv	a0,s1
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	64c080e7          	jalr	1612(ra) # 80003124 <dirlookup>
    80004ae0:	892a                	mv	s2,a0
    80004ae2:	12050263          	beqz	a0,80004c06 <sys_unlink+0x1ae>
  ilock(ip);
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	08e080e7          	jalr	142(ra) # 80002b74 <ilock>
  if(ip->nlink < 1)
    80004aee:	04a91783          	lh	a5,74(s2)
    80004af2:	08f05563          	blez	a5,80004b7c <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004af6:	04491703          	lh	a4,68(s2)
    80004afa:	4785                	li	a5,1
    80004afc:	08f70963          	beq	a4,a5,80004b8e <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004b00:	4641                	li	a2,16
    80004b02:	4581                	li	a1,0
    80004b04:	fc040513          	addi	a0,s0,-64
    80004b08:	ffffb097          	auipc	ra,0xffffb
    80004b0c:	672080e7          	jalr	1650(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b10:	4741                	li	a4,16
    80004b12:	f2c42683          	lw	a3,-212(s0)
    80004b16:	fc040613          	addi	a2,s0,-64
    80004b1a:	4581                	li	a1,0
    80004b1c:	8526                	mv	a0,s1
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	4c0080e7          	jalr	1216(ra) # 80002fde <writei>
    80004b26:	47c1                	li	a5,16
    80004b28:	0af51b63          	bne	a0,a5,80004bde <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b2c:	04491703          	lh	a4,68(s2)
    80004b30:	4785                	li	a5,1
    80004b32:	0af70f63          	beq	a4,a5,80004bf0 <sys_unlink+0x198>
  iunlockput(dp);
    80004b36:	8526                	mv	a0,s1
    80004b38:	ffffe097          	auipc	ra,0xffffe
    80004b3c:	350080e7          	jalr	848(ra) # 80002e88 <iunlockput>
  ip->nlink--;
    80004b40:	04a95783          	lhu	a5,74(s2)
    80004b44:	37fd                	addiw	a5,a5,-1
    80004b46:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b4a:	854a                	mv	a0,s2
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	f5c080e7          	jalr	-164(ra) # 80002aa8 <iupdate>
  iunlockput(ip);
    80004b54:	854a                	mv	a0,s2
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	332080e7          	jalr	818(ra) # 80002e88 <iunlockput>
  end_op();
    80004b5e:	fffff097          	auipc	ra,0xfffff
    80004b62:	b12080e7          	jalr	-1262(ra) # 80003670 <end_op>
  return 0;
    80004b66:	4501                	li	a0,0
    80004b68:	64ee                	ld	s1,216(sp)
    80004b6a:	694e                	ld	s2,208(sp)
    80004b6c:	a84d                	j	80004c1e <sys_unlink+0x1c6>
    end_op();
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	b02080e7          	jalr	-1278(ra) # 80003670 <end_op>
    return -1;
    80004b76:	557d                	li	a0,-1
    80004b78:	64ee                	ld	s1,216(sp)
    80004b7a:	a055                	j	80004c1e <sys_unlink+0x1c6>
    80004b7c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b7e:	00004517          	auipc	a0,0x4
    80004b82:	a3250513          	addi	a0,a0,-1486 # 800085b0 <etext+0x5b0>
    80004b86:	00001097          	auipc	ra,0x1
    80004b8a:	386080e7          	jalr	902(ra) # 80005f0c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b8e:	04c92703          	lw	a4,76(s2)
    80004b92:	02000793          	li	a5,32
    80004b96:	f6e7f5e3          	bgeu	a5,a4,80004b00 <sys_unlink+0xa8>
    80004b9a:	e5ce                	sd	s3,200(sp)
    80004b9c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ba0:	4741                	li	a4,16
    80004ba2:	86ce                	mv	a3,s3
    80004ba4:	f1840613          	addi	a2,s0,-232
    80004ba8:	4581                	li	a1,0
    80004baa:	854a                	mv	a0,s2
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	32e080e7          	jalr	814(ra) # 80002eda <readi>
    80004bb4:	47c1                	li	a5,16
    80004bb6:	00f51c63          	bne	a0,a5,80004bce <sys_unlink+0x176>
    if(de.inum != 0)
    80004bba:	f1845783          	lhu	a5,-232(s0)
    80004bbe:	e7b5                	bnez	a5,80004c2a <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bc0:	29c1                	addiw	s3,s3,16
    80004bc2:	04c92783          	lw	a5,76(s2)
    80004bc6:	fcf9ede3          	bltu	s3,a5,80004ba0 <sys_unlink+0x148>
    80004bca:	69ae                	ld	s3,200(sp)
    80004bcc:	bf15                	j	80004b00 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004bce:	00004517          	auipc	a0,0x4
    80004bd2:	9fa50513          	addi	a0,a0,-1542 # 800085c8 <etext+0x5c8>
    80004bd6:	00001097          	auipc	ra,0x1
    80004bda:	336080e7          	jalr	822(ra) # 80005f0c <panic>
    80004bde:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004be0:	00004517          	auipc	a0,0x4
    80004be4:	a0050513          	addi	a0,a0,-1536 # 800085e0 <etext+0x5e0>
    80004be8:	00001097          	auipc	ra,0x1
    80004bec:	324080e7          	jalr	804(ra) # 80005f0c <panic>
    dp->nlink--;
    80004bf0:	04a4d783          	lhu	a5,74(s1)
    80004bf4:	37fd                	addiw	a5,a5,-1
    80004bf6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	eac080e7          	jalr	-340(ra) # 80002aa8 <iupdate>
    80004c04:	bf0d                	j	80004b36 <sys_unlink+0xde>
    80004c06:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004c08:	8526                	mv	a0,s1
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	27e080e7          	jalr	638(ra) # 80002e88 <iunlockput>
  end_op();
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	a5e080e7          	jalr	-1442(ra) # 80003670 <end_op>
  return -1;
    80004c1a:	557d                	li	a0,-1
    80004c1c:	64ee                	ld	s1,216(sp)
}
    80004c1e:	70ae                	ld	ra,232(sp)
    80004c20:	740e                	ld	s0,224(sp)
    80004c22:	616d                	addi	sp,sp,240
    80004c24:	8082                	ret
    return -1;
    80004c26:	557d                	li	a0,-1
    80004c28:	bfdd                	j	80004c1e <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c2a:	854a                	mv	a0,s2
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	25c080e7          	jalr	604(ra) # 80002e88 <iunlockput>
    goto bad;
    80004c34:	694e                	ld	s2,208(sp)
    80004c36:	69ae                	ld	s3,200(sp)
    80004c38:	bfc1                	j	80004c08 <sys_unlink+0x1b0>

0000000080004c3a <sys_open>:

uint64
sys_open(void)
{
    80004c3a:	7155                	addi	sp,sp,-208
    80004c3c:	e586                	sd	ra,200(sp)
    80004c3e:	e1a2                	sd	s0,192(sp)
    80004c40:	f94a                	sd	s2,176(sp)
    80004c42:	0980                	addi	s0,sp,208
  int fd, omode;
  struct file *f;
  struct inode *ip, *oldip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c44:	08000613          	li	a2,128
    80004c48:	f4040593          	addi	a1,s0,-192
    80004c4c:	4501                	li	a0,0
    80004c4e:	ffffd097          	auipc	ra,0xffffd
    80004c52:	32c080e7          	jalr	812(ra) # 80001f7a <argstr>
    return -1;
    80004c56:	597d                	li	s2,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c58:	1c054663          	bltz	a0,80004e24 <sys_open+0x1ea>
    80004c5c:	f3c40593          	addi	a1,s0,-196
    80004c60:	4505                	li	a0,1
    80004c62:	ffffd097          	auipc	ra,0xffffd
    80004c66:	2d4080e7          	jalr	724(ra) # 80001f36 <argint>
    80004c6a:	1a054d63          	bltz	a0,80004e24 <sys_open+0x1ea>
    80004c6e:	fd26                	sd	s1,184(sp)
    80004c70:	f54e                	sd	s3,168(sp)

  begin_op();
    80004c72:	fffff097          	auipc	ra,0xfffff
    80004c76:	984080e7          	jalr	-1660(ra) # 800035f6 <begin_op>

  if(omode & O_CREATE){
    80004c7a:	f3c42783          	lw	a5,-196(s0)
    80004c7e:	2007f793          	andi	a5,a5,512
    80004c82:	c3d5                	beqz	a5,80004d26 <sys_open+0xec>
    ip = create(path, T_FILE, 0, 0);
    80004c84:	4681                	li	a3,0
    80004c86:	4601                	li	a2,0
    80004c88:	4589                	li	a1,2
    80004c8a:	f4040513          	addi	a0,s0,-192
    80004c8e:	00000097          	auipc	ra,0x0
    80004c92:	956080e7          	jalr	-1706(ra) # 800045e4 <create>
    80004c96:	892a                	mv	s2,a0
    if(ip == 0){
    80004c98:	cd3d                	beqz	a0,80004d16 <sys_open+0xdc>
    }
  }
  
  
  int cnt = 0;
  while(ip->type == T_SYMLINK && cnt < 10 && !(omode & O_NOFOLLOW)){
    80004c9a:	04491703          	lh	a4,68(s2)
    80004c9e:	4791                	li	a5,4
    80004ca0:	4981                	li	s3,0
    80004ca2:	0af71663          	bne	a4,a5,80004d4e <sys_open+0x114>
    80004ca6:	f152                	sd	s4,160(sp)
    80004ca8:	ed56                	sd	s5,152(sp)
    80004caa:	e95a                	sd	s6,144(sp)
    80004cac:	6a05                	lui	s4,0x1
    80004cae:	800a0a13          	addi	s4,s4,-2048 # 800 <_entry-0x7ffff800>
    80004cb2:	4a91                	li	s5,4
    80004cb4:	4b29                	li	s6,10
    80004cb6:	f3c42783          	lw	a5,-196(s0)
    80004cba:	0147f7b3          	and	a5,a5,s4
    80004cbe:	eff9                	bnez	a5,80004d9c <sys_open+0x162>
       oldip = ip;
       if(readi(ip,0,(uint64)path,0,ip->size) != ip->size || (ip = namei(path)) == 0){
    80004cc0:	04c92703          	lw	a4,76(s2)
    80004cc4:	4681                	li	a3,0
    80004cc6:	f4040613          	addi	a2,s0,-192
    80004cca:	4581                	li	a1,0
    80004ccc:	854a                	mv	a0,s2
    80004cce:	ffffe097          	auipc	ra,0xffffe
    80004cd2:	20c080e7          	jalr	524(ra) # 80002eda <readi>
    80004cd6:	04c92783          	lw	a5,76(s2)
    80004cda:	2501                	sext.w	a0,a0
    80004cdc:	0aa79063          	bne	a5,a0,80004d7c <sys_open+0x142>
    80004ce0:	f4040513          	addi	a0,s0,-192
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	712080e7          	jalr	1810(ra) # 800033f6 <namei>
    80004cec:	84aa                	mv	s1,a0
    80004cee:	c559                	beqz	a0,80004d7c <sys_open+0x142>
           iunlockput(oldip);
           end_op();
           return -1;
       }
       iunlockput(oldip);
    80004cf0:	854a                	mv	a0,s2
    80004cf2:	ffffe097          	auipc	ra,0xffffe
    80004cf6:	196080e7          	jalr	406(ra) # 80002e88 <iunlockput>
       ilock(ip);
    80004cfa:	8526                	mv	a0,s1
    80004cfc:	ffffe097          	auipc	ra,0xffffe
    80004d00:	e78080e7          	jalr	-392(ra) # 80002b74 <ilock>
       cnt++;
    80004d04:	2985                	addiw	s3,s3,1
  while(ip->type == T_SYMLINK && cnt < 10 && !(omode & O_NOFOLLOW)){
    80004d06:	04449783          	lh	a5,68(s1)
    80004d0a:	09579e63          	bne	a5,s5,80004da6 <sys_open+0x16c>
    80004d0e:	13698163          	beq	s3,s6,80004e30 <sys_open+0x1f6>
    80004d12:	8926                	mv	s2,s1
    80004d14:	b74d                	j	80004cb6 <sys_open+0x7c>
      end_op();
    80004d16:	fffff097          	auipc	ra,0xfffff
    80004d1a:	95a080e7          	jalr	-1702(ra) # 80003670 <end_op>
      return -1;
    80004d1e:	597d                	li	s2,-1
    80004d20:	74ea                	ld	s1,184(sp)
    80004d22:	79aa                	ld	s3,168(sp)
    80004d24:	a201                	j	80004e24 <sys_open+0x1ea>
    if((ip = namei(path)) == 0){
    80004d26:	f4040513          	addi	a0,s0,-192
    80004d2a:	ffffe097          	auipc	ra,0xffffe
    80004d2e:	6cc080e7          	jalr	1740(ra) # 800033f6 <namei>
    80004d32:	892a                	mv	s2,a0
    80004d34:	cd19                	beqz	a0,80004d52 <sys_open+0x118>
    ilock(ip);
    80004d36:	ffffe097          	auipc	ra,0xffffe
    80004d3a:	e3e080e7          	jalr	-450(ra) # 80002b74 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d3e:	04491703          	lh	a4,68(s2)
    80004d42:	4785                	li	a5,1
    80004d44:	f4f71be3          	bne	a4,a5,80004c9a <sys_open+0x60>
    80004d48:	f3c42783          	lw	a5,-196(s0)
    80004d4c:	eb99                	bnez	a5,80004d62 <sys_open+0x128>
  while(ip->type == T_SYMLINK && cnt < 10 && !(omode & O_NOFOLLOW)){
    80004d4e:	84ca                	mv	s1,s2
    80004d50:	a08d                	j	80004db2 <sys_open+0x178>
      end_op();
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	91e080e7          	jalr	-1762(ra) # 80003670 <end_op>
      return -1;
    80004d5a:	597d                	li	s2,-1
    80004d5c:	74ea                	ld	s1,184(sp)
    80004d5e:	79aa                	ld	s3,168(sp)
    80004d60:	a0d1                	j	80004e24 <sys_open+0x1ea>
      iunlockput(ip);
    80004d62:	854a                	mv	a0,s2
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	124080e7          	jalr	292(ra) # 80002e88 <iunlockput>
      end_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	904080e7          	jalr	-1788(ra) # 80003670 <end_op>
      return -1;
    80004d74:	597d                	li	s2,-1
    80004d76:	74ea                	ld	s1,184(sp)
    80004d78:	79aa                	ld	s3,168(sp)
    80004d7a:	a06d                	j	80004e24 <sys_open+0x1ea>
           iunlockput(oldip);
    80004d7c:	854a                	mv	a0,s2
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	10a080e7          	jalr	266(ra) # 80002e88 <iunlockput>
           end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	8ea080e7          	jalr	-1814(ra) # 80003670 <end_op>
           return -1;
    80004d8e:	597d                	li	s2,-1
    80004d90:	74ea                	ld	s1,184(sp)
    80004d92:	79aa                	ld	s3,168(sp)
    80004d94:	7a0a                	ld	s4,160(sp)
    80004d96:	6aea                	ld	s5,152(sp)
    80004d98:	6b4a                	ld	s6,144(sp)
    80004d9a:	a069                	j	80004e24 <sys_open+0x1ea>
    80004d9c:	84ca                	mv	s1,s2
    80004d9e:	7a0a                	ld	s4,160(sp)
    80004da0:	6aea                	ld	s5,152(sp)
    80004da2:	6b4a                	ld	s6,144(sp)
    80004da4:	a039                	j	80004db2 <sys_open+0x178>
   }
 
   if(cnt == 10){
    80004da6:	47a9                	li	a5,10
    80004da8:	08f98463          	beq	s3,a5,80004e30 <sys_open+0x1f6>
    80004dac:	7a0a                	ld	s4,160(sp)
    80004dae:	6aea                	ld	s5,152(sp)
    80004db0:	6b4a                	ld	s6,144(sp)
       iunlockput(ip);
       end_op();
       return -1;
   }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	c52080e7          	jalr	-942(ra) # 80003a04 <filealloc>
    80004dba:	89aa                	mv	s3,a0
    80004dbc:	cd59                	beqz	a0,80004e5a <sys_open+0x220>
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	7e4080e7          	jalr	2020(ra) # 800045a2 <fdalloc>
    80004dc6:	892a                	mv	s2,a0
    80004dc8:	08054463          	bltz	a0,80004e50 <sys_open+0x216>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dcc:	04449703          	lh	a4,68(s1)
    80004dd0:	478d                	li	a5,3
    80004dd2:	0af70163          	beq	a4,a5,80004e74 <sys_open+0x23a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dd6:	4789                	li	a5,2
    80004dd8:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ddc:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004de0:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004de4:	f3c42783          	lw	a5,-196(s0)
    80004de8:	0017c713          	xori	a4,a5,1
    80004dec:	8b05                	andi	a4,a4,1
    80004dee:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004df2:	0037f713          	andi	a4,a5,3
    80004df6:	00e03733          	snez	a4,a4
    80004dfa:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004dfe:	4007f793          	andi	a5,a5,1024
    80004e02:	c791                	beqz	a5,80004e0e <sys_open+0x1d4>
    80004e04:	04449703          	lh	a4,68(s1)
    80004e08:	4789                	li	a5,2
    80004e0a:	06f70c63          	beq	a4,a5,80004e82 <sys_open+0x248>
    itrunc(ip);
  }

  iunlock(ip);
    80004e0e:	8526                	mv	a0,s1
    80004e10:	ffffe097          	auipc	ra,0xffffe
    80004e14:	e2a080e7          	jalr	-470(ra) # 80002c3a <iunlock>
  end_op();
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	858080e7          	jalr	-1960(ra) # 80003670 <end_op>

  return fd;
    80004e20:	74ea                	ld	s1,184(sp)
    80004e22:	79aa                	ld	s3,168(sp)
}
    80004e24:	854a                	mv	a0,s2
    80004e26:	60ae                	ld	ra,200(sp)
    80004e28:	640e                	ld	s0,192(sp)
    80004e2a:	794a                	ld	s2,176(sp)
    80004e2c:	6169                	addi	sp,sp,208
    80004e2e:	8082                	ret
       iunlockput(ip);
    80004e30:	8526                	mv	a0,s1
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	056080e7          	jalr	86(ra) # 80002e88 <iunlockput>
       end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	836080e7          	jalr	-1994(ra) # 80003670 <end_op>
       return -1;
    80004e42:	597d                	li	s2,-1
    80004e44:	74ea                	ld	s1,184(sp)
    80004e46:	79aa                	ld	s3,168(sp)
    80004e48:	7a0a                	ld	s4,160(sp)
    80004e4a:	6aea                	ld	s5,152(sp)
    80004e4c:	6b4a                	ld	s6,144(sp)
    80004e4e:	bfd9                	j	80004e24 <sys_open+0x1ea>
      fileclose(f);
    80004e50:	854e                	mv	a0,s3
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	c6e080e7          	jalr	-914(ra) # 80003ac0 <fileclose>
    iunlockput(ip);
    80004e5a:	8526                	mv	a0,s1
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	02c080e7          	jalr	44(ra) # 80002e88 <iunlockput>
    end_op();
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	80c080e7          	jalr	-2036(ra) # 80003670 <end_op>
    return -1;
    80004e6c:	597d                	li	s2,-1
    80004e6e:	74ea                	ld	s1,184(sp)
    80004e70:	79aa                	ld	s3,168(sp)
    80004e72:	bf4d                	j	80004e24 <sys_open+0x1ea>
    f->type = FD_DEVICE;
    80004e74:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e78:	04649783          	lh	a5,70(s1)
    80004e7c:	02f99223          	sh	a5,36(s3)
    80004e80:	b785                	j	80004de0 <sys_open+0x1a6>
    itrunc(ip);
    80004e82:	8526                	mv	a0,s1
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	e02080e7          	jalr	-510(ra) # 80002c86 <itrunc>
    80004e8c:	b749                	j	80004e0e <sys_open+0x1d4>

0000000080004e8e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e8e:	7175                	addi	sp,sp,-144
    80004e90:	e506                	sd	ra,136(sp)
    80004e92:	e122                	sd	s0,128(sp)
    80004e94:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	760080e7          	jalr	1888(ra) # 800035f6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e9e:	08000613          	li	a2,128
    80004ea2:	f7040593          	addi	a1,s0,-144
    80004ea6:	4501                	li	a0,0
    80004ea8:	ffffd097          	auipc	ra,0xffffd
    80004eac:	0d2080e7          	jalr	210(ra) # 80001f7a <argstr>
    80004eb0:	02054963          	bltz	a0,80004ee2 <sys_mkdir+0x54>
    80004eb4:	4681                	li	a3,0
    80004eb6:	4601                	li	a2,0
    80004eb8:	4585                	li	a1,1
    80004eba:	f7040513          	addi	a0,s0,-144
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	726080e7          	jalr	1830(ra) # 800045e4 <create>
    80004ec6:	cd11                	beqz	a0,80004ee2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ec8:	ffffe097          	auipc	ra,0xffffe
    80004ecc:	fc0080e7          	jalr	-64(ra) # 80002e88 <iunlockput>
  end_op();
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	7a0080e7          	jalr	1952(ra) # 80003670 <end_op>
  return 0;
    80004ed8:	4501                	li	a0,0
}
    80004eda:	60aa                	ld	ra,136(sp)
    80004edc:	640a                	ld	s0,128(sp)
    80004ede:	6149                	addi	sp,sp,144
    80004ee0:	8082                	ret
    end_op();
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	78e080e7          	jalr	1934(ra) # 80003670 <end_op>
    return -1;
    80004eea:	557d                	li	a0,-1
    80004eec:	b7fd                	j	80004eda <sys_mkdir+0x4c>

0000000080004eee <sys_mknod>:

uint64
sys_mknod(void)
{
    80004eee:	7135                	addi	sp,sp,-160
    80004ef0:	ed06                	sd	ra,152(sp)
    80004ef2:	e922                	sd	s0,144(sp)
    80004ef4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	700080e7          	jalr	1792(ra) # 800035f6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004efe:	08000613          	li	a2,128
    80004f02:	f7040593          	addi	a1,s0,-144
    80004f06:	4501                	li	a0,0
    80004f08:	ffffd097          	auipc	ra,0xffffd
    80004f0c:	072080e7          	jalr	114(ra) # 80001f7a <argstr>
    80004f10:	04054a63          	bltz	a0,80004f64 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f14:	f6c40593          	addi	a1,s0,-148
    80004f18:	4505                	li	a0,1
    80004f1a:	ffffd097          	auipc	ra,0xffffd
    80004f1e:	01c080e7          	jalr	28(ra) # 80001f36 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f22:	04054163          	bltz	a0,80004f64 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f26:	f6840593          	addi	a1,s0,-152
    80004f2a:	4509                	li	a0,2
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	00a080e7          	jalr	10(ra) # 80001f36 <argint>
     argint(1, &major) < 0 ||
    80004f34:	02054863          	bltz	a0,80004f64 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f38:	f6841683          	lh	a3,-152(s0)
    80004f3c:	f6c41603          	lh	a2,-148(s0)
    80004f40:	458d                	li	a1,3
    80004f42:	f7040513          	addi	a0,s0,-144
    80004f46:	fffff097          	auipc	ra,0xfffff
    80004f4a:	69e080e7          	jalr	1694(ra) # 800045e4 <create>
     argint(2, &minor) < 0 ||
    80004f4e:	c919                	beqz	a0,80004f64 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f50:	ffffe097          	auipc	ra,0xffffe
    80004f54:	f38080e7          	jalr	-200(ra) # 80002e88 <iunlockput>
  end_op();
    80004f58:	ffffe097          	auipc	ra,0xffffe
    80004f5c:	718080e7          	jalr	1816(ra) # 80003670 <end_op>
  return 0;
    80004f60:	4501                	li	a0,0
    80004f62:	a031                	j	80004f6e <sys_mknod+0x80>
    end_op();
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	70c080e7          	jalr	1804(ra) # 80003670 <end_op>
    return -1;
    80004f6c:	557d                	li	a0,-1
}
    80004f6e:	60ea                	ld	ra,152(sp)
    80004f70:	644a                	ld	s0,144(sp)
    80004f72:	610d                	addi	sp,sp,160
    80004f74:	8082                	ret

0000000080004f76 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f76:	7135                	addi	sp,sp,-160
    80004f78:	ed06                	sd	ra,152(sp)
    80004f7a:	e922                	sd	s0,144(sp)
    80004f7c:	e14a                	sd	s2,128(sp)
    80004f7e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f80:	ffffc097          	auipc	ra,0xffffc
    80004f84:	efc080e7          	jalr	-260(ra) # 80000e7c <myproc>
    80004f88:	892a                	mv	s2,a0
  
  begin_op();
    80004f8a:	ffffe097          	auipc	ra,0xffffe
    80004f8e:	66c080e7          	jalr	1644(ra) # 800035f6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f92:	08000613          	li	a2,128
    80004f96:	f6040593          	addi	a1,s0,-160
    80004f9a:	4501                	li	a0,0
    80004f9c:	ffffd097          	auipc	ra,0xffffd
    80004fa0:	fde080e7          	jalr	-34(ra) # 80001f7a <argstr>
    80004fa4:	04054d63          	bltz	a0,80004ffe <sys_chdir+0x88>
    80004fa8:	e526                	sd	s1,136(sp)
    80004faa:	f6040513          	addi	a0,s0,-160
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	448080e7          	jalr	1096(ra) # 800033f6 <namei>
    80004fb6:	84aa                	mv	s1,a0
    80004fb8:	c131                	beqz	a0,80004ffc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	bba080e7          	jalr	-1094(ra) # 80002b74 <ilock>
  if(ip->type != T_DIR){
    80004fc2:	04449703          	lh	a4,68(s1)
    80004fc6:	4785                	li	a5,1
    80004fc8:	04f71163          	bne	a4,a5,8000500a <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fcc:	8526                	mv	a0,s1
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	c6c080e7          	jalr	-916(ra) # 80002c3a <iunlock>
  iput(p->cwd);
    80004fd6:	15093503          	ld	a0,336(s2)
    80004fda:	ffffe097          	auipc	ra,0xffffe
    80004fde:	e06080e7          	jalr	-506(ra) # 80002de0 <iput>
  end_op();
    80004fe2:	ffffe097          	auipc	ra,0xffffe
    80004fe6:	68e080e7          	jalr	1678(ra) # 80003670 <end_op>
  p->cwd = ip;
    80004fea:	14993823          	sd	s1,336(s2)
  return 0;
    80004fee:	4501                	li	a0,0
    80004ff0:	64aa                	ld	s1,136(sp)
}
    80004ff2:	60ea                	ld	ra,152(sp)
    80004ff4:	644a                	ld	s0,144(sp)
    80004ff6:	690a                	ld	s2,128(sp)
    80004ff8:	610d                	addi	sp,sp,160
    80004ffa:	8082                	ret
    80004ffc:	64aa                	ld	s1,136(sp)
    end_op();
    80004ffe:	ffffe097          	auipc	ra,0xffffe
    80005002:	672080e7          	jalr	1650(ra) # 80003670 <end_op>
    return -1;
    80005006:	557d                	li	a0,-1
    80005008:	b7ed                	j	80004ff2 <sys_chdir+0x7c>
    iunlockput(ip);
    8000500a:	8526                	mv	a0,s1
    8000500c:	ffffe097          	auipc	ra,0xffffe
    80005010:	e7c080e7          	jalr	-388(ra) # 80002e88 <iunlockput>
    end_op();
    80005014:	ffffe097          	auipc	ra,0xffffe
    80005018:	65c080e7          	jalr	1628(ra) # 80003670 <end_op>
    return -1;
    8000501c:	557d                	li	a0,-1
    8000501e:	64aa                	ld	s1,136(sp)
    80005020:	bfc9                	j	80004ff2 <sys_chdir+0x7c>

0000000080005022 <sys_exec>:

uint64
sys_exec(void)
{
    80005022:	7121                	addi	sp,sp,-448
    80005024:	ff06                	sd	ra,440(sp)
    80005026:	fb22                	sd	s0,432(sp)
    80005028:	f34a                	sd	s2,416(sp)
    8000502a:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000502c:	08000613          	li	a2,128
    80005030:	f5040593          	addi	a1,s0,-176
    80005034:	4501                	li	a0,0
    80005036:	ffffd097          	auipc	ra,0xffffd
    8000503a:	f44080e7          	jalr	-188(ra) # 80001f7a <argstr>
    return -1;
    8000503e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005040:	0e054a63          	bltz	a0,80005134 <sys_exec+0x112>
    80005044:	e4840593          	addi	a1,s0,-440
    80005048:	4505                	li	a0,1
    8000504a:	ffffd097          	auipc	ra,0xffffd
    8000504e:	f0e080e7          	jalr	-242(ra) # 80001f58 <argaddr>
    80005052:	0e054163          	bltz	a0,80005134 <sys_exec+0x112>
    80005056:	f726                	sd	s1,424(sp)
    80005058:	ef4e                	sd	s3,408(sp)
    8000505a:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000505c:	10000613          	li	a2,256
    80005060:	4581                	li	a1,0
    80005062:	e5040513          	addi	a0,s0,-432
    80005066:	ffffb097          	auipc	ra,0xffffb
    8000506a:	114080e7          	jalr	276(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000506e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005072:	89a6                	mv	s3,s1
    80005074:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005076:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000507a:	00391513          	slli	a0,s2,0x3
    8000507e:	e4040593          	addi	a1,s0,-448
    80005082:	e4843783          	ld	a5,-440(s0)
    80005086:	953e                	add	a0,a0,a5
    80005088:	ffffd097          	auipc	ra,0xffffd
    8000508c:	e14080e7          	jalr	-492(ra) # 80001e9c <fetchaddr>
    80005090:	02054a63          	bltz	a0,800050c4 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005094:	e4043783          	ld	a5,-448(s0)
    80005098:	c7b1                	beqz	a5,800050e4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000509a:	ffffb097          	auipc	ra,0xffffb
    8000509e:	080080e7          	jalr	128(ra) # 8000011a <kalloc>
    800050a2:	85aa                	mv	a1,a0
    800050a4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050a8:	cd11                	beqz	a0,800050c4 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050aa:	6605                	lui	a2,0x1
    800050ac:	e4043503          	ld	a0,-448(s0)
    800050b0:	ffffd097          	auipc	ra,0xffffd
    800050b4:	e3e080e7          	jalr	-450(ra) # 80001eee <fetchstr>
    800050b8:	00054663          	bltz	a0,800050c4 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    800050bc:	0905                	addi	s2,s2,1
    800050be:	09a1                	addi	s3,s3,8
    800050c0:	fb491de3          	bne	s2,s4,8000507a <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c4:	f5040913          	addi	s2,s0,-176
    800050c8:	6088                	ld	a0,0(s1)
    800050ca:	c12d                	beqz	a0,8000512c <sys_exec+0x10a>
    kfree(argv[i]);
    800050cc:	ffffb097          	auipc	ra,0xffffb
    800050d0:	f50080e7          	jalr	-176(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050d4:	04a1                	addi	s1,s1,8
    800050d6:	ff2499e3          	bne	s1,s2,800050c8 <sys_exec+0xa6>
  return -1;
    800050da:	597d                	li	s2,-1
    800050dc:	74ba                	ld	s1,424(sp)
    800050de:	69fa                	ld	s3,408(sp)
    800050e0:	6a5a                	ld	s4,400(sp)
    800050e2:	a889                	j	80005134 <sys_exec+0x112>
      argv[i] = 0;
    800050e4:	0009079b          	sext.w	a5,s2
    800050e8:	078e                	slli	a5,a5,0x3
    800050ea:	fd078793          	addi	a5,a5,-48
    800050ee:	97a2                	add	a5,a5,s0
    800050f0:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800050f4:	e5040593          	addi	a1,s0,-432
    800050f8:	f5040513          	addi	a0,s0,-176
    800050fc:	fffff097          	auipc	ra,0xfffff
    80005100:	074080e7          	jalr	116(ra) # 80004170 <exec>
    80005104:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005106:	f5040993          	addi	s3,s0,-176
    8000510a:	6088                	ld	a0,0(s1)
    8000510c:	cd01                	beqz	a0,80005124 <sys_exec+0x102>
    kfree(argv[i]);
    8000510e:	ffffb097          	auipc	ra,0xffffb
    80005112:	f0e080e7          	jalr	-242(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005116:	04a1                	addi	s1,s1,8
    80005118:	ff3499e3          	bne	s1,s3,8000510a <sys_exec+0xe8>
    8000511c:	74ba                	ld	s1,424(sp)
    8000511e:	69fa                	ld	s3,408(sp)
    80005120:	6a5a                	ld	s4,400(sp)
    80005122:	a809                	j	80005134 <sys_exec+0x112>
  return ret;
    80005124:	74ba                	ld	s1,424(sp)
    80005126:	69fa                	ld	s3,408(sp)
    80005128:	6a5a                	ld	s4,400(sp)
    8000512a:	a029                	j	80005134 <sys_exec+0x112>
  return -1;
    8000512c:	597d                	li	s2,-1
    8000512e:	74ba                	ld	s1,424(sp)
    80005130:	69fa                	ld	s3,408(sp)
    80005132:	6a5a                	ld	s4,400(sp)
}
    80005134:	854a                	mv	a0,s2
    80005136:	70fa                	ld	ra,440(sp)
    80005138:	745a                	ld	s0,432(sp)
    8000513a:	791a                	ld	s2,416(sp)
    8000513c:	6139                	addi	sp,sp,448
    8000513e:	8082                	ret

0000000080005140 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005140:	7139                	addi	sp,sp,-64
    80005142:	fc06                	sd	ra,56(sp)
    80005144:	f822                	sd	s0,48(sp)
    80005146:	f426                	sd	s1,40(sp)
    80005148:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000514a:	ffffc097          	auipc	ra,0xffffc
    8000514e:	d32080e7          	jalr	-718(ra) # 80000e7c <myproc>
    80005152:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005154:	fd840593          	addi	a1,s0,-40
    80005158:	4501                	li	a0,0
    8000515a:	ffffd097          	auipc	ra,0xffffd
    8000515e:	dfe080e7          	jalr	-514(ra) # 80001f58 <argaddr>
    return -1;
    80005162:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005164:	0e054063          	bltz	a0,80005244 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005168:	fc840593          	addi	a1,s0,-56
    8000516c:	fd040513          	addi	a0,s0,-48
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	cbe080e7          	jalr	-834(ra) # 80003e2e <pipealloc>
    return -1;
    80005178:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000517a:	0c054563          	bltz	a0,80005244 <sys_pipe+0x104>
  fd0 = -1;
    8000517e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005182:	fd043503          	ld	a0,-48(s0)
    80005186:	fffff097          	auipc	ra,0xfffff
    8000518a:	41c080e7          	jalr	1052(ra) # 800045a2 <fdalloc>
    8000518e:	fca42223          	sw	a0,-60(s0)
    80005192:	08054c63          	bltz	a0,8000522a <sys_pipe+0xea>
    80005196:	fc843503          	ld	a0,-56(s0)
    8000519a:	fffff097          	auipc	ra,0xfffff
    8000519e:	408080e7          	jalr	1032(ra) # 800045a2 <fdalloc>
    800051a2:	fca42023          	sw	a0,-64(s0)
    800051a6:	06054963          	bltz	a0,80005218 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051aa:	4691                	li	a3,4
    800051ac:	fc440613          	addi	a2,s0,-60
    800051b0:	fd843583          	ld	a1,-40(s0)
    800051b4:	68a8                	ld	a0,80(s1)
    800051b6:	ffffc097          	auipc	ra,0xffffc
    800051ba:	962080e7          	jalr	-1694(ra) # 80000b18 <copyout>
    800051be:	02054063          	bltz	a0,800051de <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051c2:	4691                	li	a3,4
    800051c4:	fc040613          	addi	a2,s0,-64
    800051c8:	fd843583          	ld	a1,-40(s0)
    800051cc:	0591                	addi	a1,a1,4
    800051ce:	68a8                	ld	a0,80(s1)
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	948080e7          	jalr	-1720(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051d8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051da:	06055563          	bgez	a0,80005244 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051de:	fc442783          	lw	a5,-60(s0)
    800051e2:	07e9                	addi	a5,a5,26
    800051e4:	078e                	slli	a5,a5,0x3
    800051e6:	97a6                	add	a5,a5,s1
    800051e8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051ec:	fc042783          	lw	a5,-64(s0)
    800051f0:	07e9                	addi	a5,a5,26
    800051f2:	078e                	slli	a5,a5,0x3
    800051f4:	00f48533          	add	a0,s1,a5
    800051f8:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051fc:	fd043503          	ld	a0,-48(s0)
    80005200:	fffff097          	auipc	ra,0xfffff
    80005204:	8c0080e7          	jalr	-1856(ra) # 80003ac0 <fileclose>
    fileclose(wf);
    80005208:	fc843503          	ld	a0,-56(s0)
    8000520c:	fffff097          	auipc	ra,0xfffff
    80005210:	8b4080e7          	jalr	-1868(ra) # 80003ac0 <fileclose>
    return -1;
    80005214:	57fd                	li	a5,-1
    80005216:	a03d                	j	80005244 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005218:	fc442783          	lw	a5,-60(s0)
    8000521c:	0007c763          	bltz	a5,8000522a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005220:	07e9                	addi	a5,a5,26
    80005222:	078e                	slli	a5,a5,0x3
    80005224:	97a6                	add	a5,a5,s1
    80005226:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000522a:	fd043503          	ld	a0,-48(s0)
    8000522e:	fffff097          	auipc	ra,0xfffff
    80005232:	892080e7          	jalr	-1902(ra) # 80003ac0 <fileclose>
    fileclose(wf);
    80005236:	fc843503          	ld	a0,-56(s0)
    8000523a:	fffff097          	auipc	ra,0xfffff
    8000523e:	886080e7          	jalr	-1914(ra) # 80003ac0 <fileclose>
    return -1;
    80005242:	57fd                	li	a5,-1
}
    80005244:	853e                	mv	a0,a5
    80005246:	70e2                	ld	ra,56(sp)
    80005248:	7442                	ld	s0,48(sp)
    8000524a:	74a2                	ld	s1,40(sp)
    8000524c:	6121                	addi	sp,sp,64
    8000524e:	8082                	ret

0000000080005250 <sys_symlink>:




uint64
sys_symlink(void){
    80005250:	712d                	addi	sp,sp,-288
    80005252:	ee06                	sd	ra,280(sp)
    80005254:	ea22                	sd	s0,272(sp)
    80005256:	1200                	addi	s0,sp,288
     char target[MAXPATH], path[MAXPATH];
     struct inode *ip;
 
     if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005258:	08000613          	li	a2,128
    8000525c:	f6040593          	addi	a1,s0,-160
    80005260:	4501                	li	a0,0
    80005262:	ffffd097          	auipc	ra,0xffffd
    80005266:	d18080e7          	jalr	-744(ra) # 80001f7a <argstr>
         return -1;
    8000526a:	57fd                	li	a5,-1
     if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    8000526c:	08054563          	bltz	a0,800052f6 <sys_symlink+0xa6>
    80005270:	08000613          	li	a2,128
    80005274:	ee040593          	addi	a1,s0,-288
    80005278:	4505                	li	a0,1
    8000527a:	ffffd097          	auipc	ra,0xffffd
    8000527e:	d00080e7          	jalr	-768(ra) # 80001f7a <argstr>
         return -1;
    80005282:	57fd                	li	a5,-1
     if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    80005284:	06054963          	bltz	a0,800052f6 <sys_symlink+0xa6>
    80005288:	e626                	sd	s1,264(sp)
 
     begin_op();
    8000528a:	ffffe097          	auipc	ra,0xffffe
    8000528e:	36c080e7          	jalr	876(ra) # 800035f6 <begin_op>
     if((ip = create(path,T_SYMLINK,0,0)) == 0){
    80005292:	4681                	li	a3,0
    80005294:	4601                	li	a2,0
    80005296:	4591                	li	a1,4
    80005298:	ee040513          	addi	a0,s0,-288
    8000529c:	fffff097          	auipc	ra,0xfffff
    800052a0:	348080e7          	jalr	840(ra) # 800045e4 <create>
    800052a4:	84aa                	mv	s1,a0
    800052a6:	cd29                	beqz	a0,80005300 <sys_symlink+0xb0>
    800052a8:	e24a                	sd	s2,256(sp)
         end_op();
         return -1;
     }
 
     if(writei(ip, 0, (uint64)target, 0, strlen(target)) != strlen(target)){
    800052aa:	f6040513          	addi	a0,s0,-160
    800052ae:	ffffb097          	auipc	ra,0xffffb
    800052b2:	040080e7          	jalr	64(ra) # 800002ee <strlen>
    800052b6:	0005071b          	sext.w	a4,a0
    800052ba:	4681                	li	a3,0
    800052bc:	f6040613          	addi	a2,s0,-160
    800052c0:	4581                	li	a1,0
    800052c2:	8526                	mv	a0,s1
    800052c4:	ffffe097          	auipc	ra,0xffffe
    800052c8:	d1a080e7          	jalr	-742(ra) # 80002fde <writei>
    800052cc:	892a                	mv	s2,a0
    800052ce:	f6040513          	addi	a0,s0,-160
    800052d2:	ffffb097          	auipc	ra,0xffffb
    800052d6:	01c080e7          	jalr	28(ra) # 800002ee <strlen>
    800052da:	02a91a63          	bne	s2,a0,8000530e <sys_symlink+0xbe>
         end_op();
         return -1;
     }
     end_op();
    800052de:	ffffe097          	auipc	ra,0xffffe
    800052e2:	392080e7          	jalr	914(ra) # 80003670 <end_op>
     iunlockput(ip);
    800052e6:	8526                	mv	a0,s1
    800052e8:	ffffe097          	auipc	ra,0xffffe
    800052ec:	ba0080e7          	jalr	-1120(ra) # 80002e88 <iunlockput>
     return 0;
    800052f0:	4781                	li	a5,0
    800052f2:	64b2                	ld	s1,264(sp)
    800052f4:	6912                	ld	s2,256(sp)
 }
    800052f6:	853e                	mv	a0,a5
    800052f8:	60f2                	ld	ra,280(sp)
    800052fa:	6452                	ld	s0,272(sp)
    800052fc:	6115                	addi	sp,sp,288
    800052fe:	8082                	ret
         end_op();
    80005300:	ffffe097          	auipc	ra,0xffffe
    80005304:	370080e7          	jalr	880(ra) # 80003670 <end_op>
         return -1;
    80005308:	57fd                	li	a5,-1
    8000530a:	64b2                	ld	s1,264(sp)
    8000530c:	b7ed                	j	800052f6 <sys_symlink+0xa6>
         end_op();
    8000530e:	ffffe097          	auipc	ra,0xffffe
    80005312:	362080e7          	jalr	866(ra) # 80003670 <end_op>
         return -1;
    80005316:	57fd                	li	a5,-1
    80005318:	64b2                	ld	s1,264(sp)
    8000531a:	6912                	ld	s2,256(sp)
    8000531c:	bfe9                	j	800052f6 <sys_symlink+0xa6>
	...

0000000080005320 <kernelvec>:
    80005320:	7111                	addi	sp,sp,-256
    80005322:	e006                	sd	ra,0(sp)
    80005324:	e40a                	sd	sp,8(sp)
    80005326:	e80e                	sd	gp,16(sp)
    80005328:	ec12                	sd	tp,24(sp)
    8000532a:	f016                	sd	t0,32(sp)
    8000532c:	f41a                	sd	t1,40(sp)
    8000532e:	f81e                	sd	t2,48(sp)
    80005330:	fc22                	sd	s0,56(sp)
    80005332:	e0a6                	sd	s1,64(sp)
    80005334:	e4aa                	sd	a0,72(sp)
    80005336:	e8ae                	sd	a1,80(sp)
    80005338:	ecb2                	sd	a2,88(sp)
    8000533a:	f0b6                	sd	a3,96(sp)
    8000533c:	f4ba                	sd	a4,104(sp)
    8000533e:	f8be                	sd	a5,112(sp)
    80005340:	fcc2                	sd	a6,120(sp)
    80005342:	e146                	sd	a7,128(sp)
    80005344:	e54a                	sd	s2,136(sp)
    80005346:	e94e                	sd	s3,144(sp)
    80005348:	ed52                	sd	s4,152(sp)
    8000534a:	f156                	sd	s5,160(sp)
    8000534c:	f55a                	sd	s6,168(sp)
    8000534e:	f95e                	sd	s7,176(sp)
    80005350:	fd62                	sd	s8,184(sp)
    80005352:	e1e6                	sd	s9,192(sp)
    80005354:	e5ea                	sd	s10,200(sp)
    80005356:	e9ee                	sd	s11,208(sp)
    80005358:	edf2                	sd	t3,216(sp)
    8000535a:	f1f6                	sd	t4,224(sp)
    8000535c:	f5fa                	sd	t5,232(sp)
    8000535e:	f9fe                	sd	t6,240(sp)
    80005360:	a09fc0ef          	jal	80001d68 <kerneltrap>
    80005364:	6082                	ld	ra,0(sp)
    80005366:	6122                	ld	sp,8(sp)
    80005368:	61c2                	ld	gp,16(sp)
    8000536a:	7282                	ld	t0,32(sp)
    8000536c:	7322                	ld	t1,40(sp)
    8000536e:	73c2                	ld	t2,48(sp)
    80005370:	7462                	ld	s0,56(sp)
    80005372:	6486                	ld	s1,64(sp)
    80005374:	6526                	ld	a0,72(sp)
    80005376:	65c6                	ld	a1,80(sp)
    80005378:	6666                	ld	a2,88(sp)
    8000537a:	7686                	ld	a3,96(sp)
    8000537c:	7726                	ld	a4,104(sp)
    8000537e:	77c6                	ld	a5,112(sp)
    80005380:	7866                	ld	a6,120(sp)
    80005382:	688a                	ld	a7,128(sp)
    80005384:	692a                	ld	s2,136(sp)
    80005386:	69ca                	ld	s3,144(sp)
    80005388:	6a6a                	ld	s4,152(sp)
    8000538a:	7a8a                	ld	s5,160(sp)
    8000538c:	7b2a                	ld	s6,168(sp)
    8000538e:	7bca                	ld	s7,176(sp)
    80005390:	7c6a                	ld	s8,184(sp)
    80005392:	6c8e                	ld	s9,192(sp)
    80005394:	6d2e                	ld	s10,200(sp)
    80005396:	6dce                	ld	s11,208(sp)
    80005398:	6e6e                	ld	t3,216(sp)
    8000539a:	7e8e                	ld	t4,224(sp)
    8000539c:	7f2e                	ld	t5,232(sp)
    8000539e:	7fce                	ld	t6,240(sp)
    800053a0:	6111                	addi	sp,sp,256
    800053a2:	10200073          	sret
    800053a6:	00000013          	nop
    800053aa:	00000013          	nop
    800053ae:	0001                	nop

00000000800053b0 <timervec>:
    800053b0:	34051573          	csrrw	a0,mscratch,a0
    800053b4:	e10c                	sd	a1,0(a0)
    800053b6:	e510                	sd	a2,8(a0)
    800053b8:	e914                	sd	a3,16(a0)
    800053ba:	6d0c                	ld	a1,24(a0)
    800053bc:	7110                	ld	a2,32(a0)
    800053be:	6194                	ld	a3,0(a1)
    800053c0:	96b2                	add	a3,a3,a2
    800053c2:	e194                	sd	a3,0(a1)
    800053c4:	4589                	li	a1,2
    800053c6:	14459073          	csrw	sip,a1
    800053ca:	6914                	ld	a3,16(a0)
    800053cc:	6510                	ld	a2,8(a0)
    800053ce:	610c                	ld	a1,0(a0)
    800053d0:	34051573          	csrrw	a0,mscratch,a0
    800053d4:	30200073          	mret
	...

00000000800053da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053da:	1141                	addi	sp,sp,-16
    800053dc:	e422                	sd	s0,8(sp)
    800053de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053e0:	0c0007b7          	lui	a5,0xc000
    800053e4:	4705                	li	a4,1
    800053e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053e8:	0c0007b7          	lui	a5,0xc000
    800053ec:	c3d8                	sw	a4,4(a5)
}
    800053ee:	6422                	ld	s0,8(sp)
    800053f0:	0141                	addi	sp,sp,16
    800053f2:	8082                	ret

00000000800053f4 <plicinithart>:

void
plicinithart(void)
{
    800053f4:	1141                	addi	sp,sp,-16
    800053f6:	e406                	sd	ra,8(sp)
    800053f8:	e022                	sd	s0,0(sp)
    800053fa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053fc:	ffffc097          	auipc	ra,0xffffc
    80005400:	a54080e7          	jalr	-1452(ra) # 80000e50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005404:	0085171b          	slliw	a4,a0,0x8
    80005408:	0c0027b7          	lui	a5,0xc002
    8000540c:	97ba                	add	a5,a5,a4
    8000540e:	40200713          	li	a4,1026
    80005412:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005416:	00d5151b          	slliw	a0,a0,0xd
    8000541a:	0c2017b7          	lui	a5,0xc201
    8000541e:	97aa                	add	a5,a5,a0
    80005420:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005424:	60a2                	ld	ra,8(sp)
    80005426:	6402                	ld	s0,0(sp)
    80005428:	0141                	addi	sp,sp,16
    8000542a:	8082                	ret

000000008000542c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000542c:	1141                	addi	sp,sp,-16
    8000542e:	e406                	sd	ra,8(sp)
    80005430:	e022                	sd	s0,0(sp)
    80005432:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005434:	ffffc097          	auipc	ra,0xffffc
    80005438:	a1c080e7          	jalr	-1508(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000543c:	00d5151b          	slliw	a0,a0,0xd
    80005440:	0c2017b7          	lui	a5,0xc201
    80005444:	97aa                	add	a5,a5,a0
  return irq;
}
    80005446:	43c8                	lw	a0,4(a5)
    80005448:	60a2                	ld	ra,8(sp)
    8000544a:	6402                	ld	s0,0(sp)
    8000544c:	0141                	addi	sp,sp,16
    8000544e:	8082                	ret

0000000080005450 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005450:	1101                	addi	sp,sp,-32
    80005452:	ec06                	sd	ra,24(sp)
    80005454:	e822                	sd	s0,16(sp)
    80005456:	e426                	sd	s1,8(sp)
    80005458:	1000                	addi	s0,sp,32
    8000545a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000545c:	ffffc097          	auipc	ra,0xffffc
    80005460:	9f4080e7          	jalr	-1548(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005464:	00d5151b          	slliw	a0,a0,0xd
    80005468:	0c2017b7          	lui	a5,0xc201
    8000546c:	97aa                	add	a5,a5,a0
    8000546e:	c3c4                	sw	s1,4(a5)
}
    80005470:	60e2                	ld	ra,24(sp)
    80005472:	6442                	ld	s0,16(sp)
    80005474:	64a2                	ld	s1,8(sp)
    80005476:	6105                	addi	sp,sp,32
    80005478:	8082                	ret

000000008000547a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000547a:	1141                	addi	sp,sp,-16
    8000547c:	e406                	sd	ra,8(sp)
    8000547e:	e022                	sd	s0,0(sp)
    80005480:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005482:	479d                	li	a5,7
    80005484:	06a7c863          	blt	a5,a0,800054f4 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005488:	00011717          	auipc	a4,0x11
    8000548c:	b7870713          	addi	a4,a4,-1160 # 80016000 <disk>
    80005490:	972a                	add	a4,a4,a0
    80005492:	6789                	lui	a5,0x2
    80005494:	97ba                	add	a5,a5,a4
    80005496:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000549a:	e7ad                	bnez	a5,80005504 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000549c:	00451793          	slli	a5,a0,0x4
    800054a0:	00013717          	auipc	a4,0x13
    800054a4:	b6070713          	addi	a4,a4,-1184 # 80018000 <disk+0x2000>
    800054a8:	6314                	ld	a3,0(a4)
    800054aa:	96be                	add	a3,a3,a5
    800054ac:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800054b0:	6314                	ld	a3,0(a4)
    800054b2:	96be                	add	a3,a3,a5
    800054b4:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800054b8:	6314                	ld	a3,0(a4)
    800054ba:	96be                	add	a3,a3,a5
    800054bc:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800054c0:	6318                	ld	a4,0(a4)
    800054c2:	97ba                	add	a5,a5,a4
    800054c4:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800054c8:	00011717          	auipc	a4,0x11
    800054cc:	b3870713          	addi	a4,a4,-1224 # 80016000 <disk>
    800054d0:	972a                	add	a4,a4,a0
    800054d2:	6789                	lui	a5,0x2
    800054d4:	97ba                	add	a5,a5,a4
    800054d6:	4705                	li	a4,1
    800054d8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800054dc:	00013517          	auipc	a0,0x13
    800054e0:	b3c50513          	addi	a0,a0,-1220 # 80018018 <disk+0x2018>
    800054e4:	ffffc097          	auipc	ra,0xffffc
    800054e8:	1ea080e7          	jalr	490(ra) # 800016ce <wakeup>
}
    800054ec:	60a2                	ld	ra,8(sp)
    800054ee:	6402                	ld	s0,0(sp)
    800054f0:	0141                	addi	sp,sp,16
    800054f2:	8082                	ret
    panic("free_desc 1");
    800054f4:	00003517          	auipc	a0,0x3
    800054f8:	0fc50513          	addi	a0,a0,252 # 800085f0 <etext+0x5f0>
    800054fc:	00001097          	auipc	ra,0x1
    80005500:	a10080e7          	jalr	-1520(ra) # 80005f0c <panic>
    panic("free_desc 2");
    80005504:	00003517          	auipc	a0,0x3
    80005508:	0fc50513          	addi	a0,a0,252 # 80008600 <etext+0x600>
    8000550c:	00001097          	auipc	ra,0x1
    80005510:	a00080e7          	jalr	-1536(ra) # 80005f0c <panic>

0000000080005514 <virtio_disk_init>:
{
    80005514:	1141                	addi	sp,sp,-16
    80005516:	e406                	sd	ra,8(sp)
    80005518:	e022                	sd	s0,0(sp)
    8000551a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000551c:	00003597          	auipc	a1,0x3
    80005520:	0f458593          	addi	a1,a1,244 # 80008610 <etext+0x610>
    80005524:	00013517          	auipc	a0,0x13
    80005528:	c0450513          	addi	a0,a0,-1020 # 80018128 <disk+0x2128>
    8000552c:	00001097          	auipc	ra,0x1
    80005530:	eca080e7          	jalr	-310(ra) # 800063f6 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005534:	100017b7          	lui	a5,0x10001
    80005538:	4398                	lw	a4,0(a5)
    8000553a:	2701                	sext.w	a4,a4
    8000553c:	747277b7          	lui	a5,0x74727
    80005540:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005544:	0ef71f63          	bne	a4,a5,80005642 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005548:	100017b7          	lui	a5,0x10001
    8000554c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000554e:	439c                	lw	a5,0(a5)
    80005550:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005552:	4705                	li	a4,1
    80005554:	0ee79763          	bne	a5,a4,80005642 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005558:	100017b7          	lui	a5,0x10001
    8000555c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000555e:	439c                	lw	a5,0(a5)
    80005560:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005562:	4709                	li	a4,2
    80005564:	0ce79f63          	bne	a5,a4,80005642 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005568:	100017b7          	lui	a5,0x10001
    8000556c:	47d8                	lw	a4,12(a5)
    8000556e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005570:	554d47b7          	lui	a5,0x554d4
    80005574:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005578:	0cf71563          	bne	a4,a5,80005642 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000557c:	100017b7          	lui	a5,0x10001
    80005580:	4705                	li	a4,1
    80005582:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005584:	470d                	li	a4,3
    80005586:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005588:	10001737          	lui	a4,0x10001
    8000558c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000558e:	c7ffe737          	lui	a4,0xc7ffe
    80005592:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd51f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005596:	8ef9                	and	a3,a3,a4
    80005598:	10001737          	lui	a4,0x10001
    8000559c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000559e:	472d                	li	a4,11
    800055a0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055a2:	473d                	li	a4,15
    800055a4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800055a6:	100017b7          	lui	a5,0x10001
    800055aa:	6705                	lui	a4,0x1
    800055ac:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055ae:	100017b7          	lui	a5,0x10001
    800055b2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055b6:	100017b7          	lui	a5,0x10001
    800055ba:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800055be:	439c                	lw	a5,0(a5)
    800055c0:	2781                	sext.w	a5,a5
  if(max == 0)
    800055c2:	cbc1                	beqz	a5,80005652 <virtio_disk_init+0x13e>
  if(max < NUM)
    800055c4:	471d                	li	a4,7
    800055c6:	08f77e63          	bgeu	a4,a5,80005662 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055ca:	100017b7          	lui	a5,0x10001
    800055ce:	4721                	li	a4,8
    800055d0:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800055d2:	6609                	lui	a2,0x2
    800055d4:	4581                	li	a1,0
    800055d6:	00011517          	auipc	a0,0x11
    800055da:	a2a50513          	addi	a0,a0,-1494 # 80016000 <disk>
    800055de:	ffffb097          	auipc	ra,0xffffb
    800055e2:	b9c080e7          	jalr	-1124(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800055e6:	00011697          	auipc	a3,0x11
    800055ea:	a1a68693          	addi	a3,a3,-1510 # 80016000 <disk>
    800055ee:	00c6d713          	srli	a4,a3,0xc
    800055f2:	2701                	sext.w	a4,a4
    800055f4:	100017b7          	lui	a5,0x10001
    800055f8:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    800055fa:	00013797          	auipc	a5,0x13
    800055fe:	a0678793          	addi	a5,a5,-1530 # 80018000 <disk+0x2000>
    80005602:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005604:	00011717          	auipc	a4,0x11
    80005608:	a7c70713          	addi	a4,a4,-1412 # 80016080 <disk+0x80>
    8000560c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000560e:	00012717          	auipc	a4,0x12
    80005612:	9f270713          	addi	a4,a4,-1550 # 80017000 <disk+0x1000>
    80005616:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005618:	4705                	li	a4,1
    8000561a:	00e78c23          	sb	a4,24(a5)
    8000561e:	00e78ca3          	sb	a4,25(a5)
    80005622:	00e78d23          	sb	a4,26(a5)
    80005626:	00e78da3          	sb	a4,27(a5)
    8000562a:	00e78e23          	sb	a4,28(a5)
    8000562e:	00e78ea3          	sb	a4,29(a5)
    80005632:	00e78f23          	sb	a4,30(a5)
    80005636:	00e78fa3          	sb	a4,31(a5)
}
    8000563a:	60a2                	ld	ra,8(sp)
    8000563c:	6402                	ld	s0,0(sp)
    8000563e:	0141                	addi	sp,sp,16
    80005640:	8082                	ret
    panic("could not find virtio disk");
    80005642:	00003517          	auipc	a0,0x3
    80005646:	fde50513          	addi	a0,a0,-34 # 80008620 <etext+0x620>
    8000564a:	00001097          	auipc	ra,0x1
    8000564e:	8c2080e7          	jalr	-1854(ra) # 80005f0c <panic>
    panic("virtio disk has no queue 0");
    80005652:	00003517          	auipc	a0,0x3
    80005656:	fee50513          	addi	a0,a0,-18 # 80008640 <etext+0x640>
    8000565a:	00001097          	auipc	ra,0x1
    8000565e:	8b2080e7          	jalr	-1870(ra) # 80005f0c <panic>
    panic("virtio disk max queue too short");
    80005662:	00003517          	auipc	a0,0x3
    80005666:	ffe50513          	addi	a0,a0,-2 # 80008660 <etext+0x660>
    8000566a:	00001097          	auipc	ra,0x1
    8000566e:	8a2080e7          	jalr	-1886(ra) # 80005f0c <panic>

0000000080005672 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005672:	7159                	addi	sp,sp,-112
    80005674:	f486                	sd	ra,104(sp)
    80005676:	f0a2                	sd	s0,96(sp)
    80005678:	eca6                	sd	s1,88(sp)
    8000567a:	e8ca                	sd	s2,80(sp)
    8000567c:	e4ce                	sd	s3,72(sp)
    8000567e:	e0d2                	sd	s4,64(sp)
    80005680:	fc56                	sd	s5,56(sp)
    80005682:	f85a                	sd	s6,48(sp)
    80005684:	f45e                	sd	s7,40(sp)
    80005686:	f062                	sd	s8,32(sp)
    80005688:	ec66                	sd	s9,24(sp)
    8000568a:	1880                	addi	s0,sp,112
    8000568c:	8a2a                	mv	s4,a0
    8000568e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005690:	00c52c03          	lw	s8,12(a0)
    80005694:	001c1c1b          	slliw	s8,s8,0x1
    80005698:	1c02                	slli	s8,s8,0x20
    8000569a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000569e:	00013517          	auipc	a0,0x13
    800056a2:	a8a50513          	addi	a0,a0,-1398 # 80018128 <disk+0x2128>
    800056a6:	00001097          	auipc	ra,0x1
    800056aa:	de0080e7          	jalr	-544(ra) # 80006486 <acquire>
  for(int i = 0; i < 3; i++){
    800056ae:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800056b0:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056b2:	00011b97          	auipc	s7,0x11
    800056b6:	94eb8b93          	addi	s7,s7,-1714 # 80016000 <disk>
    800056ba:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800056bc:	4a8d                	li	s5,3
    800056be:	a88d                	j	80005730 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    800056c0:	00fb8733          	add	a4,s7,a5
    800056c4:	975a                	add	a4,a4,s6
    800056c6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056ca:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056cc:	0207c563          	bltz	a5,800056f6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800056d0:	2905                	addiw	s2,s2,1
    800056d2:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800056d4:	1b590163          	beq	s2,s5,80005876 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    800056d8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056da:	00013717          	auipc	a4,0x13
    800056de:	93e70713          	addi	a4,a4,-1730 # 80018018 <disk+0x2018>
    800056e2:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056e4:	00074683          	lbu	a3,0(a4)
    800056e8:	fee1                	bnez	a3,800056c0 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    800056ea:	2785                	addiw	a5,a5,1
    800056ec:	0705                	addi	a4,a4,1
    800056ee:	fe979be3          	bne	a5,s1,800056e4 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800056f2:	57fd                	li	a5,-1
    800056f4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056f6:	03205163          	blez	s2,80005718 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800056fa:	f9042503          	lw	a0,-112(s0)
    800056fe:	00000097          	auipc	ra,0x0
    80005702:	d7c080e7          	jalr	-644(ra) # 8000547a <free_desc>
      for(int j = 0; j < i; j++)
    80005706:	4785                	li	a5,1
    80005708:	0127d863          	bge	a5,s2,80005718 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000570c:	f9442503          	lw	a0,-108(s0)
    80005710:	00000097          	auipc	ra,0x0
    80005714:	d6a080e7          	jalr	-662(ra) # 8000547a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005718:	00013597          	auipc	a1,0x13
    8000571c:	a1058593          	addi	a1,a1,-1520 # 80018128 <disk+0x2128>
    80005720:	00013517          	auipc	a0,0x13
    80005724:	8f850513          	addi	a0,a0,-1800 # 80018018 <disk+0x2018>
    80005728:	ffffc097          	auipc	ra,0xffffc
    8000572c:	e1a080e7          	jalr	-486(ra) # 80001542 <sleep>
  for(int i = 0; i < 3; i++){
    80005730:	f9040613          	addi	a2,s0,-112
    80005734:	894e                	mv	s2,s3
    80005736:	b74d                	j	800056d8 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005738:	00013717          	auipc	a4,0x13
    8000573c:	8c873703          	ld	a4,-1848(a4) # 80018000 <disk+0x2000>
    80005740:	973e                	add	a4,a4,a5
    80005742:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005746:	00011897          	auipc	a7,0x11
    8000574a:	8ba88893          	addi	a7,a7,-1862 # 80016000 <disk>
    8000574e:	00013717          	auipc	a4,0x13
    80005752:	8b270713          	addi	a4,a4,-1870 # 80018000 <disk+0x2000>
    80005756:	6314                	ld	a3,0(a4)
    80005758:	96be                	add	a3,a3,a5
    8000575a:	00c6d583          	lhu	a1,12(a3)
    8000575e:	0015e593          	ori	a1,a1,1
    80005762:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005766:	f9842683          	lw	a3,-104(s0)
    8000576a:	630c                	ld	a1,0(a4)
    8000576c:	97ae                	add	a5,a5,a1
    8000576e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005772:	20050593          	addi	a1,a0,512
    80005776:	0592                	slli	a1,a1,0x4
    80005778:	95c6                	add	a1,a1,a7
    8000577a:	57fd                	li	a5,-1
    8000577c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005780:	00469793          	slli	a5,a3,0x4
    80005784:	00073803          	ld	a6,0(a4)
    80005788:	983e                	add	a6,a6,a5
    8000578a:	6689                	lui	a3,0x2
    8000578c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005790:	96b2                	add	a3,a3,a2
    80005792:	96c6                	add	a3,a3,a7
    80005794:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005798:	6314                	ld	a3,0(a4)
    8000579a:	96be                	add	a3,a3,a5
    8000579c:	4605                	li	a2,1
    8000579e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057a0:	6314                	ld	a3,0(a4)
    800057a2:	96be                	add	a3,a3,a5
    800057a4:	4809                	li	a6,2
    800057a6:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800057aa:	6314                	ld	a3,0(a4)
    800057ac:	97b6                	add	a5,a5,a3
    800057ae:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057b2:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    800057b6:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057ba:	6714                	ld	a3,8(a4)
    800057bc:	0026d783          	lhu	a5,2(a3)
    800057c0:	8b9d                	andi	a5,a5,7
    800057c2:	0786                	slli	a5,a5,0x1
    800057c4:	96be                	add	a3,a3,a5
    800057c6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057ca:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057ce:	6718                	ld	a4,8(a4)
    800057d0:	00275783          	lhu	a5,2(a4)
    800057d4:	2785                	addiw	a5,a5,1
    800057d6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057da:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057de:	100017b7          	lui	a5,0x10001
    800057e2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057e6:	004a2783          	lw	a5,4(s4)
    800057ea:	02c79163          	bne	a5,a2,8000580c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    800057ee:	00013917          	auipc	s2,0x13
    800057f2:	93a90913          	addi	s2,s2,-1734 # 80018128 <disk+0x2128>
  while(b->disk == 1) {
    800057f6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057f8:	85ca                	mv	a1,s2
    800057fa:	8552                	mv	a0,s4
    800057fc:	ffffc097          	auipc	ra,0xffffc
    80005800:	d46080e7          	jalr	-698(ra) # 80001542 <sleep>
  while(b->disk == 1) {
    80005804:	004a2783          	lw	a5,4(s4)
    80005808:	fe9788e3          	beq	a5,s1,800057f8 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000580c:	f9042903          	lw	s2,-112(s0)
    80005810:	20090713          	addi	a4,s2,512
    80005814:	0712                	slli	a4,a4,0x4
    80005816:	00010797          	auipc	a5,0x10
    8000581a:	7ea78793          	addi	a5,a5,2026 # 80016000 <disk>
    8000581e:	97ba                	add	a5,a5,a4
    80005820:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005824:	00012997          	auipc	s3,0x12
    80005828:	7dc98993          	addi	s3,s3,2012 # 80018000 <disk+0x2000>
    8000582c:	00491713          	slli	a4,s2,0x4
    80005830:	0009b783          	ld	a5,0(s3)
    80005834:	97ba                	add	a5,a5,a4
    80005836:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000583a:	854a                	mv	a0,s2
    8000583c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005840:	00000097          	auipc	ra,0x0
    80005844:	c3a080e7          	jalr	-966(ra) # 8000547a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005848:	8885                	andi	s1,s1,1
    8000584a:	f0ed                	bnez	s1,8000582c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000584c:	00013517          	auipc	a0,0x13
    80005850:	8dc50513          	addi	a0,a0,-1828 # 80018128 <disk+0x2128>
    80005854:	00001097          	auipc	ra,0x1
    80005858:	ce6080e7          	jalr	-794(ra) # 8000653a <release>
}
    8000585c:	70a6                	ld	ra,104(sp)
    8000585e:	7406                	ld	s0,96(sp)
    80005860:	64e6                	ld	s1,88(sp)
    80005862:	6946                	ld	s2,80(sp)
    80005864:	69a6                	ld	s3,72(sp)
    80005866:	6a06                	ld	s4,64(sp)
    80005868:	7ae2                	ld	s5,56(sp)
    8000586a:	7b42                	ld	s6,48(sp)
    8000586c:	7ba2                	ld	s7,40(sp)
    8000586e:	7c02                	ld	s8,32(sp)
    80005870:	6ce2                	ld	s9,24(sp)
    80005872:	6165                	addi	sp,sp,112
    80005874:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005876:	f9042503          	lw	a0,-112(s0)
    8000587a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000587e:	00010597          	auipc	a1,0x10
    80005882:	78258593          	addi	a1,a1,1922 # 80016000 <disk>
    80005886:	20050793          	addi	a5,a0,512
    8000588a:	0792                	slli	a5,a5,0x4
    8000588c:	97ae                	add	a5,a5,a1
    8000588e:	01903733          	snez	a4,s9
    80005892:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005896:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000589a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000589e:	00012717          	auipc	a4,0x12
    800058a2:	76270713          	addi	a4,a4,1890 # 80018000 <disk+0x2000>
    800058a6:	6314                	ld	a3,0(a4)
    800058a8:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058aa:	6789                	lui	a5,0x2
    800058ac:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800058b0:	97b2                	add	a5,a5,a2
    800058b2:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058b4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058b6:	631c                	ld	a5,0(a4)
    800058b8:	97b2                	add	a5,a5,a2
    800058ba:	46c1                	li	a3,16
    800058bc:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058be:	631c                	ld	a5,0(a4)
    800058c0:	97b2                	add	a5,a5,a2
    800058c2:	4685                	li	a3,1
    800058c4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800058c8:	f9442783          	lw	a5,-108(s0)
    800058cc:	6314                	ld	a3,0(a4)
    800058ce:	96b2                	add	a3,a3,a2
    800058d0:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800058d4:	0792                	slli	a5,a5,0x4
    800058d6:	6314                	ld	a3,0(a4)
    800058d8:	96be                	add	a3,a3,a5
    800058da:	058a0593          	addi	a1,s4,88
    800058de:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    800058e0:	6318                	ld	a4,0(a4)
    800058e2:	973e                	add	a4,a4,a5
    800058e4:	40000693          	li	a3,1024
    800058e8:	c714                	sw	a3,8(a4)
  if(write)
    800058ea:	e40c97e3          	bnez	s9,80005738 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058ee:	00012717          	auipc	a4,0x12
    800058f2:	71273703          	ld	a4,1810(a4) # 80018000 <disk+0x2000>
    800058f6:	973e                	add	a4,a4,a5
    800058f8:	4689                	li	a3,2
    800058fa:	00d71623          	sh	a3,12(a4)
    800058fe:	b5a1                	j	80005746 <virtio_disk_rw+0xd4>

0000000080005900 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005900:	1101                	addi	sp,sp,-32
    80005902:	ec06                	sd	ra,24(sp)
    80005904:	e822                	sd	s0,16(sp)
    80005906:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005908:	00013517          	auipc	a0,0x13
    8000590c:	82050513          	addi	a0,a0,-2016 # 80018128 <disk+0x2128>
    80005910:	00001097          	auipc	ra,0x1
    80005914:	b76080e7          	jalr	-1162(ra) # 80006486 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005918:	100017b7          	lui	a5,0x10001
    8000591c:	53b8                	lw	a4,96(a5)
    8000591e:	8b0d                	andi	a4,a4,3
    80005920:	100017b7          	lui	a5,0x10001
    80005924:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005926:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000592a:	00012797          	auipc	a5,0x12
    8000592e:	6d678793          	addi	a5,a5,1750 # 80018000 <disk+0x2000>
    80005932:	6b94                	ld	a3,16(a5)
    80005934:	0207d703          	lhu	a4,32(a5)
    80005938:	0026d783          	lhu	a5,2(a3)
    8000593c:	06f70563          	beq	a4,a5,800059a6 <virtio_disk_intr+0xa6>
    80005940:	e426                	sd	s1,8(sp)
    80005942:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005944:	00010917          	auipc	s2,0x10
    80005948:	6bc90913          	addi	s2,s2,1724 # 80016000 <disk>
    8000594c:	00012497          	auipc	s1,0x12
    80005950:	6b448493          	addi	s1,s1,1716 # 80018000 <disk+0x2000>
    __sync_synchronize();
    80005954:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005958:	6898                	ld	a4,16(s1)
    8000595a:	0204d783          	lhu	a5,32(s1)
    8000595e:	8b9d                	andi	a5,a5,7
    80005960:	078e                	slli	a5,a5,0x3
    80005962:	97ba                	add	a5,a5,a4
    80005964:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005966:	20078713          	addi	a4,a5,512
    8000596a:	0712                	slli	a4,a4,0x4
    8000596c:	974a                	add	a4,a4,s2
    8000596e:	03074703          	lbu	a4,48(a4)
    80005972:	e731                	bnez	a4,800059be <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005974:	20078793          	addi	a5,a5,512
    80005978:	0792                	slli	a5,a5,0x4
    8000597a:	97ca                	add	a5,a5,s2
    8000597c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000597e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005982:	ffffc097          	auipc	ra,0xffffc
    80005986:	d4c080e7          	jalr	-692(ra) # 800016ce <wakeup>

    disk.used_idx += 1;
    8000598a:	0204d783          	lhu	a5,32(s1)
    8000598e:	2785                	addiw	a5,a5,1
    80005990:	17c2                	slli	a5,a5,0x30
    80005992:	93c1                	srli	a5,a5,0x30
    80005994:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005998:	6898                	ld	a4,16(s1)
    8000599a:	00275703          	lhu	a4,2(a4)
    8000599e:	faf71be3          	bne	a4,a5,80005954 <virtio_disk_intr+0x54>
    800059a2:	64a2                	ld	s1,8(sp)
    800059a4:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800059a6:	00012517          	auipc	a0,0x12
    800059aa:	78250513          	addi	a0,a0,1922 # 80018128 <disk+0x2128>
    800059ae:	00001097          	auipc	ra,0x1
    800059b2:	b8c080e7          	jalr	-1140(ra) # 8000653a <release>
}
    800059b6:	60e2                	ld	ra,24(sp)
    800059b8:	6442                	ld	s0,16(sp)
    800059ba:	6105                	addi	sp,sp,32
    800059bc:	8082                	ret
      panic("virtio_disk_intr status");
    800059be:	00003517          	auipc	a0,0x3
    800059c2:	cc250513          	addi	a0,a0,-830 # 80008680 <etext+0x680>
    800059c6:	00000097          	auipc	ra,0x0
    800059ca:	546080e7          	jalr	1350(ra) # 80005f0c <panic>

00000000800059ce <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800059ce:	1141                	addi	sp,sp,-16
    800059d0:	e422                	sd	s0,8(sp)
    800059d2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059d4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800059d8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800059dc:	0037979b          	slliw	a5,a5,0x3
    800059e0:	02004737          	lui	a4,0x2004
    800059e4:	97ba                	add	a5,a5,a4
    800059e6:	0200c737          	lui	a4,0x200c
    800059ea:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    800059ec:	6318                	ld	a4,0(a4)
    800059ee:	000f4637          	lui	a2,0xf4
    800059f2:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059f6:	9732                	add	a4,a4,a2
    800059f8:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059fa:	00259693          	slli	a3,a1,0x2
    800059fe:	96ae                	add	a3,a3,a1
    80005a00:	068e                	slli	a3,a3,0x3
    80005a02:	00013717          	auipc	a4,0x13
    80005a06:	5fe70713          	addi	a4,a4,1534 # 80019000 <timer_scratch>
    80005a0a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005a0c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005a0e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005a10:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005a14:	00000797          	auipc	a5,0x0
    80005a18:	99c78793          	addi	a5,a5,-1636 # 800053b0 <timervec>
    80005a1c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a20:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a24:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a28:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005a2c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a30:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a34:	30479073          	csrw	mie,a5
}
    80005a38:	6422                	ld	s0,8(sp)
    80005a3a:	0141                	addi	sp,sp,16
    80005a3c:	8082                	ret

0000000080005a3e <start>:
{
    80005a3e:	1141                	addi	sp,sp,-16
    80005a40:	e406                	sd	ra,8(sp)
    80005a42:	e022                	sd	s0,0(sp)
    80005a44:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a46:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a4a:	7779                	lui	a4,0xffffe
    80005a4c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd5bf>
    80005a50:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a52:	6705                	lui	a4,0x1
    80005a54:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a58:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a5a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a5e:	ffffb797          	auipc	a5,0xffffb
    80005a62:	8ba78793          	addi	a5,a5,-1862 # 80000318 <main>
    80005a66:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a6a:	4781                	li	a5,0
    80005a6c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a70:	67c1                	lui	a5,0x10
    80005a72:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a74:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a78:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a7c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a80:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a84:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a88:	57fd                	li	a5,-1
    80005a8a:	83a9                	srli	a5,a5,0xa
    80005a8c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a90:	47bd                	li	a5,15
    80005a92:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a96:	00000097          	auipc	ra,0x0
    80005a9a:	f38080e7          	jalr	-200(ra) # 800059ce <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a9e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005aa2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005aa4:	823e                	mv	tp,a5
  asm volatile("mret");
    80005aa6:	30200073          	mret
}
    80005aaa:	60a2                	ld	ra,8(sp)
    80005aac:	6402                	ld	s0,0(sp)
    80005aae:	0141                	addi	sp,sp,16
    80005ab0:	8082                	ret

0000000080005ab2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005ab2:	715d                	addi	sp,sp,-80
    80005ab4:	e486                	sd	ra,72(sp)
    80005ab6:	e0a2                	sd	s0,64(sp)
    80005ab8:	f84a                	sd	s2,48(sp)
    80005aba:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005abc:	04c05663          	blez	a2,80005b08 <consolewrite+0x56>
    80005ac0:	fc26                	sd	s1,56(sp)
    80005ac2:	f44e                	sd	s3,40(sp)
    80005ac4:	f052                	sd	s4,32(sp)
    80005ac6:	ec56                	sd	s5,24(sp)
    80005ac8:	8a2a                	mv	s4,a0
    80005aca:	84ae                	mv	s1,a1
    80005acc:	89b2                	mv	s3,a2
    80005ace:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005ad0:	5afd                	li	s5,-1
    80005ad2:	4685                	li	a3,1
    80005ad4:	8626                	mv	a2,s1
    80005ad6:	85d2                	mv	a1,s4
    80005ad8:	fbf40513          	addi	a0,s0,-65
    80005adc:	ffffc097          	auipc	ra,0xffffc
    80005ae0:	e5a080e7          	jalr	-422(ra) # 80001936 <either_copyin>
    80005ae4:	03550463          	beq	a0,s5,80005b0c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005ae8:	fbf44503          	lbu	a0,-65(s0)
    80005aec:	00000097          	auipc	ra,0x0
    80005af0:	7de080e7          	jalr	2014(ra) # 800062ca <uartputc>
  for(i = 0; i < n; i++){
    80005af4:	2905                	addiw	s2,s2,1
    80005af6:	0485                	addi	s1,s1,1
    80005af8:	fd299de3          	bne	s3,s2,80005ad2 <consolewrite+0x20>
    80005afc:	894e                	mv	s2,s3
    80005afe:	74e2                	ld	s1,56(sp)
    80005b00:	79a2                	ld	s3,40(sp)
    80005b02:	7a02                	ld	s4,32(sp)
    80005b04:	6ae2                	ld	s5,24(sp)
    80005b06:	a039                	j	80005b14 <consolewrite+0x62>
    80005b08:	4901                	li	s2,0
    80005b0a:	a029                	j	80005b14 <consolewrite+0x62>
    80005b0c:	74e2                	ld	s1,56(sp)
    80005b0e:	79a2                	ld	s3,40(sp)
    80005b10:	7a02                	ld	s4,32(sp)
    80005b12:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005b14:	854a                	mv	a0,s2
    80005b16:	60a6                	ld	ra,72(sp)
    80005b18:	6406                	ld	s0,64(sp)
    80005b1a:	7942                	ld	s2,48(sp)
    80005b1c:	6161                	addi	sp,sp,80
    80005b1e:	8082                	ret

0000000080005b20 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005b20:	711d                	addi	sp,sp,-96
    80005b22:	ec86                	sd	ra,88(sp)
    80005b24:	e8a2                	sd	s0,80(sp)
    80005b26:	e4a6                	sd	s1,72(sp)
    80005b28:	e0ca                	sd	s2,64(sp)
    80005b2a:	fc4e                	sd	s3,56(sp)
    80005b2c:	f852                	sd	s4,48(sp)
    80005b2e:	f456                	sd	s5,40(sp)
    80005b30:	f05a                	sd	s6,32(sp)
    80005b32:	1080                	addi	s0,sp,96
    80005b34:	8aaa                	mv	s5,a0
    80005b36:	8a2e                	mv	s4,a1
    80005b38:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b3a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005b3e:	0001b517          	auipc	a0,0x1b
    80005b42:	60250513          	addi	a0,a0,1538 # 80021140 <cons>
    80005b46:	00001097          	auipc	ra,0x1
    80005b4a:	940080e7          	jalr	-1728(ra) # 80006486 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b4e:	0001b497          	auipc	s1,0x1b
    80005b52:	5f248493          	addi	s1,s1,1522 # 80021140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b56:	0001b917          	auipc	s2,0x1b
    80005b5a:	68290913          	addi	s2,s2,1666 # 800211d8 <cons+0x98>
  while(n > 0){
    80005b5e:	0d305463          	blez	s3,80005c26 <consoleread+0x106>
    while(cons.r == cons.w){
    80005b62:	0984a783          	lw	a5,152(s1)
    80005b66:	09c4a703          	lw	a4,156(s1)
    80005b6a:	0af71963          	bne	a4,a5,80005c1c <consoleread+0xfc>
      if(myproc()->killed){
    80005b6e:	ffffb097          	auipc	ra,0xffffb
    80005b72:	30e080e7          	jalr	782(ra) # 80000e7c <myproc>
    80005b76:	551c                	lw	a5,40(a0)
    80005b78:	e7ad                	bnez	a5,80005be2 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005b7a:	85a6                	mv	a1,s1
    80005b7c:	854a                	mv	a0,s2
    80005b7e:	ffffc097          	auipc	ra,0xffffc
    80005b82:	9c4080e7          	jalr	-1596(ra) # 80001542 <sleep>
    while(cons.r == cons.w){
    80005b86:	0984a783          	lw	a5,152(s1)
    80005b8a:	09c4a703          	lw	a4,156(s1)
    80005b8e:	fef700e3          	beq	a4,a5,80005b6e <consoleread+0x4e>
    80005b92:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005b94:	0001b717          	auipc	a4,0x1b
    80005b98:	5ac70713          	addi	a4,a4,1452 # 80021140 <cons>
    80005b9c:	0017869b          	addiw	a3,a5,1
    80005ba0:	08d72c23          	sw	a3,152(a4)
    80005ba4:	07f7f693          	andi	a3,a5,127
    80005ba8:	9736                	add	a4,a4,a3
    80005baa:	01874703          	lbu	a4,24(a4)
    80005bae:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005bb2:	4691                	li	a3,4
    80005bb4:	04db8a63          	beq	s7,a3,80005c08 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005bb8:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005bbc:	4685                	li	a3,1
    80005bbe:	faf40613          	addi	a2,s0,-81
    80005bc2:	85d2                	mv	a1,s4
    80005bc4:	8556                	mv	a0,s5
    80005bc6:	ffffc097          	auipc	ra,0xffffc
    80005bca:	d1a080e7          	jalr	-742(ra) # 800018e0 <either_copyout>
    80005bce:	57fd                	li	a5,-1
    80005bd0:	04f50a63          	beq	a0,a5,80005c24 <consoleread+0x104>
      break;

    dst++;
    80005bd4:	0a05                	addi	s4,s4,1
    --n;
    80005bd6:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005bd8:	47a9                	li	a5,10
    80005bda:	06fb8163          	beq	s7,a5,80005c3c <consoleread+0x11c>
    80005bde:	6be2                	ld	s7,24(sp)
    80005be0:	bfbd                	j	80005b5e <consoleread+0x3e>
        release(&cons.lock);
    80005be2:	0001b517          	auipc	a0,0x1b
    80005be6:	55e50513          	addi	a0,a0,1374 # 80021140 <cons>
    80005bea:	00001097          	auipc	ra,0x1
    80005bee:	950080e7          	jalr	-1712(ra) # 8000653a <release>
        return -1;
    80005bf2:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005bf4:	60e6                	ld	ra,88(sp)
    80005bf6:	6446                	ld	s0,80(sp)
    80005bf8:	64a6                	ld	s1,72(sp)
    80005bfa:	6906                	ld	s2,64(sp)
    80005bfc:	79e2                	ld	s3,56(sp)
    80005bfe:	7a42                	ld	s4,48(sp)
    80005c00:	7aa2                	ld	s5,40(sp)
    80005c02:	7b02                	ld	s6,32(sp)
    80005c04:	6125                	addi	sp,sp,96
    80005c06:	8082                	ret
      if(n < target){
    80005c08:	0009871b          	sext.w	a4,s3
    80005c0c:	01677a63          	bgeu	a4,s6,80005c20 <consoleread+0x100>
        cons.r--;
    80005c10:	0001b717          	auipc	a4,0x1b
    80005c14:	5cf72423          	sw	a5,1480(a4) # 800211d8 <cons+0x98>
    80005c18:	6be2                	ld	s7,24(sp)
    80005c1a:	a031                	j	80005c26 <consoleread+0x106>
    80005c1c:	ec5e                	sd	s7,24(sp)
    80005c1e:	bf9d                	j	80005b94 <consoleread+0x74>
    80005c20:	6be2                	ld	s7,24(sp)
    80005c22:	a011                	j	80005c26 <consoleread+0x106>
    80005c24:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005c26:	0001b517          	auipc	a0,0x1b
    80005c2a:	51a50513          	addi	a0,a0,1306 # 80021140 <cons>
    80005c2e:	00001097          	auipc	ra,0x1
    80005c32:	90c080e7          	jalr	-1780(ra) # 8000653a <release>
  return target - n;
    80005c36:	413b053b          	subw	a0,s6,s3
    80005c3a:	bf6d                	j	80005bf4 <consoleread+0xd4>
    80005c3c:	6be2                	ld	s7,24(sp)
    80005c3e:	b7e5                	j	80005c26 <consoleread+0x106>

0000000080005c40 <consputc>:
{
    80005c40:	1141                	addi	sp,sp,-16
    80005c42:	e406                	sd	ra,8(sp)
    80005c44:	e022                	sd	s0,0(sp)
    80005c46:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c48:	10000793          	li	a5,256
    80005c4c:	00f50a63          	beq	a0,a5,80005c60 <consputc+0x20>
    uartputc_sync(c);
    80005c50:	00000097          	auipc	ra,0x0
    80005c54:	59c080e7          	jalr	1436(ra) # 800061ec <uartputc_sync>
}
    80005c58:	60a2                	ld	ra,8(sp)
    80005c5a:	6402                	ld	s0,0(sp)
    80005c5c:	0141                	addi	sp,sp,16
    80005c5e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c60:	4521                	li	a0,8
    80005c62:	00000097          	auipc	ra,0x0
    80005c66:	58a080e7          	jalr	1418(ra) # 800061ec <uartputc_sync>
    80005c6a:	02000513          	li	a0,32
    80005c6e:	00000097          	auipc	ra,0x0
    80005c72:	57e080e7          	jalr	1406(ra) # 800061ec <uartputc_sync>
    80005c76:	4521                	li	a0,8
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	574080e7          	jalr	1396(ra) # 800061ec <uartputc_sync>
    80005c80:	bfe1                	j	80005c58 <consputc+0x18>

0000000080005c82 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c82:	1101                	addi	sp,sp,-32
    80005c84:	ec06                	sd	ra,24(sp)
    80005c86:	e822                	sd	s0,16(sp)
    80005c88:	e426                	sd	s1,8(sp)
    80005c8a:	1000                	addi	s0,sp,32
    80005c8c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c8e:	0001b517          	auipc	a0,0x1b
    80005c92:	4b250513          	addi	a0,a0,1202 # 80021140 <cons>
    80005c96:	00000097          	auipc	ra,0x0
    80005c9a:	7f0080e7          	jalr	2032(ra) # 80006486 <acquire>

  switch(c){
    80005c9e:	47d5                	li	a5,21
    80005ca0:	0af48563          	beq	s1,a5,80005d4a <consoleintr+0xc8>
    80005ca4:	0297c963          	blt	a5,s1,80005cd6 <consoleintr+0x54>
    80005ca8:	47a1                	li	a5,8
    80005caa:	0ef48c63          	beq	s1,a5,80005da2 <consoleintr+0x120>
    80005cae:	47c1                	li	a5,16
    80005cb0:	10f49f63          	bne	s1,a5,80005dce <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005cb4:	ffffc097          	auipc	ra,0xffffc
    80005cb8:	cd8080e7          	jalr	-808(ra) # 8000198c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005cbc:	0001b517          	auipc	a0,0x1b
    80005cc0:	48450513          	addi	a0,a0,1156 # 80021140 <cons>
    80005cc4:	00001097          	auipc	ra,0x1
    80005cc8:	876080e7          	jalr	-1930(ra) # 8000653a <release>
}
    80005ccc:	60e2                	ld	ra,24(sp)
    80005cce:	6442                	ld	s0,16(sp)
    80005cd0:	64a2                	ld	s1,8(sp)
    80005cd2:	6105                	addi	sp,sp,32
    80005cd4:	8082                	ret
  switch(c){
    80005cd6:	07f00793          	li	a5,127
    80005cda:	0cf48463          	beq	s1,a5,80005da2 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cde:	0001b717          	auipc	a4,0x1b
    80005ce2:	46270713          	addi	a4,a4,1122 # 80021140 <cons>
    80005ce6:	0a072783          	lw	a5,160(a4)
    80005cea:	09872703          	lw	a4,152(a4)
    80005cee:	9f99                	subw	a5,a5,a4
    80005cf0:	07f00713          	li	a4,127
    80005cf4:	fcf764e3          	bltu	a4,a5,80005cbc <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005cf8:	47b5                	li	a5,13
    80005cfa:	0cf48d63          	beq	s1,a5,80005dd4 <consoleintr+0x152>
      consputc(c);
    80005cfe:	8526                	mv	a0,s1
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	f40080e7          	jalr	-192(ra) # 80005c40 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d08:	0001b797          	auipc	a5,0x1b
    80005d0c:	43878793          	addi	a5,a5,1080 # 80021140 <cons>
    80005d10:	0a07a703          	lw	a4,160(a5)
    80005d14:	0017069b          	addiw	a3,a4,1
    80005d18:	0006861b          	sext.w	a2,a3
    80005d1c:	0ad7a023          	sw	a3,160(a5)
    80005d20:	07f77713          	andi	a4,a4,127
    80005d24:	97ba                	add	a5,a5,a4
    80005d26:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005d2a:	47a9                	li	a5,10
    80005d2c:	0cf48b63          	beq	s1,a5,80005e02 <consoleintr+0x180>
    80005d30:	4791                	li	a5,4
    80005d32:	0cf48863          	beq	s1,a5,80005e02 <consoleintr+0x180>
    80005d36:	0001b797          	auipc	a5,0x1b
    80005d3a:	4a27a783          	lw	a5,1186(a5) # 800211d8 <cons+0x98>
    80005d3e:	0807879b          	addiw	a5,a5,128
    80005d42:	f6f61de3          	bne	a2,a5,80005cbc <consoleintr+0x3a>
    80005d46:	863e                	mv	a2,a5
    80005d48:	a86d                	j	80005e02 <consoleintr+0x180>
    80005d4a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005d4c:	0001b717          	auipc	a4,0x1b
    80005d50:	3f470713          	addi	a4,a4,1012 # 80021140 <cons>
    80005d54:	0a072783          	lw	a5,160(a4)
    80005d58:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d5c:	0001b497          	auipc	s1,0x1b
    80005d60:	3e448493          	addi	s1,s1,996 # 80021140 <cons>
    while(cons.e != cons.w &&
    80005d64:	4929                	li	s2,10
    80005d66:	02f70a63          	beq	a4,a5,80005d9a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d6a:	37fd                	addiw	a5,a5,-1
    80005d6c:	07f7f713          	andi	a4,a5,127
    80005d70:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d72:	01874703          	lbu	a4,24(a4)
    80005d76:	03270463          	beq	a4,s2,80005d9e <consoleintr+0x11c>
      cons.e--;
    80005d7a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d7e:	10000513          	li	a0,256
    80005d82:	00000097          	auipc	ra,0x0
    80005d86:	ebe080e7          	jalr	-322(ra) # 80005c40 <consputc>
    while(cons.e != cons.w &&
    80005d8a:	0a04a783          	lw	a5,160(s1)
    80005d8e:	09c4a703          	lw	a4,156(s1)
    80005d92:	fcf71ce3          	bne	a4,a5,80005d6a <consoleintr+0xe8>
    80005d96:	6902                	ld	s2,0(sp)
    80005d98:	b715                	j	80005cbc <consoleintr+0x3a>
    80005d9a:	6902                	ld	s2,0(sp)
    80005d9c:	b705                	j	80005cbc <consoleintr+0x3a>
    80005d9e:	6902                	ld	s2,0(sp)
    80005da0:	bf31                	j	80005cbc <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005da2:	0001b717          	auipc	a4,0x1b
    80005da6:	39e70713          	addi	a4,a4,926 # 80021140 <cons>
    80005daa:	0a072783          	lw	a5,160(a4)
    80005dae:	09c72703          	lw	a4,156(a4)
    80005db2:	f0f705e3          	beq	a4,a5,80005cbc <consoleintr+0x3a>
      cons.e--;
    80005db6:	37fd                	addiw	a5,a5,-1
    80005db8:	0001b717          	auipc	a4,0x1b
    80005dbc:	42f72423          	sw	a5,1064(a4) # 800211e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005dc0:	10000513          	li	a0,256
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	e7c080e7          	jalr	-388(ra) # 80005c40 <consputc>
    80005dcc:	bdc5                	j	80005cbc <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005dce:	ee0487e3          	beqz	s1,80005cbc <consoleintr+0x3a>
    80005dd2:	b731                	j	80005cde <consoleintr+0x5c>
      consputc(c);
    80005dd4:	4529                	li	a0,10
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	e6a080e7          	jalr	-406(ra) # 80005c40 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005dde:	0001b797          	auipc	a5,0x1b
    80005de2:	36278793          	addi	a5,a5,866 # 80021140 <cons>
    80005de6:	0a07a703          	lw	a4,160(a5)
    80005dea:	0017069b          	addiw	a3,a4,1
    80005dee:	0006861b          	sext.w	a2,a3
    80005df2:	0ad7a023          	sw	a3,160(a5)
    80005df6:	07f77713          	andi	a4,a4,127
    80005dfa:	97ba                	add	a5,a5,a4
    80005dfc:	4729                	li	a4,10
    80005dfe:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005e02:	0001b797          	auipc	a5,0x1b
    80005e06:	3cc7ad23          	sw	a2,986(a5) # 800211dc <cons+0x9c>
        wakeup(&cons.r);
    80005e0a:	0001b517          	auipc	a0,0x1b
    80005e0e:	3ce50513          	addi	a0,a0,974 # 800211d8 <cons+0x98>
    80005e12:	ffffc097          	auipc	ra,0xffffc
    80005e16:	8bc080e7          	jalr	-1860(ra) # 800016ce <wakeup>
    80005e1a:	b54d                	j	80005cbc <consoleintr+0x3a>

0000000080005e1c <consoleinit>:

void
consoleinit(void)
{
    80005e1c:	1141                	addi	sp,sp,-16
    80005e1e:	e406                	sd	ra,8(sp)
    80005e20:	e022                	sd	s0,0(sp)
    80005e22:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e24:	00003597          	auipc	a1,0x3
    80005e28:	87458593          	addi	a1,a1,-1932 # 80008698 <etext+0x698>
    80005e2c:	0001b517          	auipc	a0,0x1b
    80005e30:	31450513          	addi	a0,a0,788 # 80021140 <cons>
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	5c2080e7          	jalr	1474(ra) # 800063f6 <initlock>

  uartinit();
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	354080e7          	jalr	852(ra) # 80006190 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e44:	0000e797          	auipc	a5,0xe
    80005e48:	69478793          	addi	a5,a5,1684 # 800144d8 <devsw>
    80005e4c:	00000717          	auipc	a4,0x0
    80005e50:	cd470713          	addi	a4,a4,-812 # 80005b20 <consoleread>
    80005e54:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e56:	00000717          	auipc	a4,0x0
    80005e5a:	c5c70713          	addi	a4,a4,-932 # 80005ab2 <consolewrite>
    80005e5e:	ef98                	sd	a4,24(a5)
}
    80005e60:	60a2                	ld	ra,8(sp)
    80005e62:	6402                	ld	s0,0(sp)
    80005e64:	0141                	addi	sp,sp,16
    80005e66:	8082                	ret

0000000080005e68 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e68:	7179                	addi	sp,sp,-48
    80005e6a:	f406                	sd	ra,40(sp)
    80005e6c:	f022                	sd	s0,32(sp)
    80005e6e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e70:	c219                	beqz	a2,80005e76 <printint+0xe>
    80005e72:	08054963          	bltz	a0,80005f04 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e76:	2501                	sext.w	a0,a0
    80005e78:	4881                	li	a7,0
    80005e7a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e7e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e80:	2581                	sext.w	a1,a1
    80005e82:	00003617          	auipc	a2,0x3
    80005e86:	97e60613          	addi	a2,a2,-1666 # 80008800 <digits>
    80005e8a:	883a                	mv	a6,a4
    80005e8c:	2705                	addiw	a4,a4,1
    80005e8e:	02b577bb          	remuw	a5,a0,a1
    80005e92:	1782                	slli	a5,a5,0x20
    80005e94:	9381                	srli	a5,a5,0x20
    80005e96:	97b2                	add	a5,a5,a2
    80005e98:	0007c783          	lbu	a5,0(a5)
    80005e9c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ea0:	0005079b          	sext.w	a5,a0
    80005ea4:	02b5553b          	divuw	a0,a0,a1
    80005ea8:	0685                	addi	a3,a3,1
    80005eaa:	feb7f0e3          	bgeu	a5,a1,80005e8a <printint+0x22>

  if(sign)
    80005eae:	00088c63          	beqz	a7,80005ec6 <printint+0x5e>
    buf[i++] = '-';
    80005eb2:	fe070793          	addi	a5,a4,-32
    80005eb6:	00878733          	add	a4,a5,s0
    80005eba:	02d00793          	li	a5,45
    80005ebe:	fef70823          	sb	a5,-16(a4)
    80005ec2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ec6:	02e05b63          	blez	a4,80005efc <printint+0x94>
    80005eca:	ec26                	sd	s1,24(sp)
    80005ecc:	e84a                	sd	s2,16(sp)
    80005ece:	fd040793          	addi	a5,s0,-48
    80005ed2:	00e784b3          	add	s1,a5,a4
    80005ed6:	fff78913          	addi	s2,a5,-1
    80005eda:	993a                	add	s2,s2,a4
    80005edc:	377d                	addiw	a4,a4,-1
    80005ede:	1702                	slli	a4,a4,0x20
    80005ee0:	9301                	srli	a4,a4,0x20
    80005ee2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005ee6:	fff4c503          	lbu	a0,-1(s1)
    80005eea:	00000097          	auipc	ra,0x0
    80005eee:	d56080e7          	jalr	-682(ra) # 80005c40 <consputc>
  while(--i >= 0)
    80005ef2:	14fd                	addi	s1,s1,-1
    80005ef4:	ff2499e3          	bne	s1,s2,80005ee6 <printint+0x7e>
    80005ef8:	64e2                	ld	s1,24(sp)
    80005efa:	6942                	ld	s2,16(sp)
}
    80005efc:	70a2                	ld	ra,40(sp)
    80005efe:	7402                	ld	s0,32(sp)
    80005f00:	6145                	addi	sp,sp,48
    80005f02:	8082                	ret
    x = -xx;
    80005f04:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005f08:	4885                	li	a7,1
    x = -xx;
    80005f0a:	bf85                	j	80005e7a <printint+0x12>

0000000080005f0c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005f0c:	1101                	addi	sp,sp,-32
    80005f0e:	ec06                	sd	ra,24(sp)
    80005f10:	e822                	sd	s0,16(sp)
    80005f12:	e426                	sd	s1,8(sp)
    80005f14:	1000                	addi	s0,sp,32
    80005f16:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f18:	0001b797          	auipc	a5,0x1b
    80005f1c:	2e07a423          	sw	zero,744(a5) # 80021200 <pr+0x18>
  printf("panic: ");
    80005f20:	00002517          	auipc	a0,0x2
    80005f24:	78050513          	addi	a0,a0,1920 # 800086a0 <etext+0x6a0>
    80005f28:	00000097          	auipc	ra,0x0
    80005f2c:	02e080e7          	jalr	46(ra) # 80005f56 <printf>
  printf(s);
    80005f30:	8526                	mv	a0,s1
    80005f32:	00000097          	auipc	ra,0x0
    80005f36:	024080e7          	jalr	36(ra) # 80005f56 <printf>
  printf("\n");
    80005f3a:	00002517          	auipc	a0,0x2
    80005f3e:	0de50513          	addi	a0,a0,222 # 80008018 <etext+0x18>
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	014080e7          	jalr	20(ra) # 80005f56 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f4a:	4785                	li	a5,1
    80005f4c:	00003717          	auipc	a4,0x3
    80005f50:	0cf72823          	sw	a5,208(a4) # 8000901c <panicked>
  for(;;)
    80005f54:	a001                	j	80005f54 <panic+0x48>

0000000080005f56 <printf>:
{
    80005f56:	7131                	addi	sp,sp,-192
    80005f58:	fc86                	sd	ra,120(sp)
    80005f5a:	f8a2                	sd	s0,112(sp)
    80005f5c:	e8d2                	sd	s4,80(sp)
    80005f5e:	f06a                	sd	s10,32(sp)
    80005f60:	0100                	addi	s0,sp,128
    80005f62:	8a2a                	mv	s4,a0
    80005f64:	e40c                	sd	a1,8(s0)
    80005f66:	e810                	sd	a2,16(s0)
    80005f68:	ec14                	sd	a3,24(s0)
    80005f6a:	f018                	sd	a4,32(s0)
    80005f6c:	f41c                	sd	a5,40(s0)
    80005f6e:	03043823          	sd	a6,48(s0)
    80005f72:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f76:	0001bd17          	auipc	s10,0x1b
    80005f7a:	28ad2d03          	lw	s10,650(s10) # 80021200 <pr+0x18>
  if(locking)
    80005f7e:	040d1463          	bnez	s10,80005fc6 <printf+0x70>
  if (fmt == 0)
    80005f82:	040a0b63          	beqz	s4,80005fd8 <printf+0x82>
  va_start(ap, fmt);
    80005f86:	00840793          	addi	a5,s0,8
    80005f8a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f8e:	000a4503          	lbu	a0,0(s4)
    80005f92:	18050b63          	beqz	a0,80006128 <printf+0x1d2>
    80005f96:	f4a6                	sd	s1,104(sp)
    80005f98:	f0ca                	sd	s2,96(sp)
    80005f9a:	ecce                	sd	s3,88(sp)
    80005f9c:	e4d6                	sd	s5,72(sp)
    80005f9e:	e0da                	sd	s6,64(sp)
    80005fa0:	fc5e                	sd	s7,56(sp)
    80005fa2:	f862                	sd	s8,48(sp)
    80005fa4:	f466                	sd	s9,40(sp)
    80005fa6:	ec6e                	sd	s11,24(sp)
    80005fa8:	4981                	li	s3,0
    if(c != '%'){
    80005faa:	02500b13          	li	s6,37
    switch(c){
    80005fae:	07000b93          	li	s7,112
  consputc('x');
    80005fb2:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fb4:	00003a97          	auipc	s5,0x3
    80005fb8:	84ca8a93          	addi	s5,s5,-1972 # 80008800 <digits>
    switch(c){
    80005fbc:	07300c13          	li	s8,115
    80005fc0:	06400d93          	li	s11,100
    80005fc4:	a0b1                	j	80006010 <printf+0xba>
    acquire(&pr.lock);
    80005fc6:	0001b517          	auipc	a0,0x1b
    80005fca:	22250513          	addi	a0,a0,546 # 800211e8 <pr>
    80005fce:	00000097          	auipc	ra,0x0
    80005fd2:	4b8080e7          	jalr	1208(ra) # 80006486 <acquire>
    80005fd6:	b775                	j	80005f82 <printf+0x2c>
    80005fd8:	f4a6                	sd	s1,104(sp)
    80005fda:	f0ca                	sd	s2,96(sp)
    80005fdc:	ecce                	sd	s3,88(sp)
    80005fde:	e4d6                	sd	s5,72(sp)
    80005fe0:	e0da                	sd	s6,64(sp)
    80005fe2:	fc5e                	sd	s7,56(sp)
    80005fe4:	f862                	sd	s8,48(sp)
    80005fe6:	f466                	sd	s9,40(sp)
    80005fe8:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005fea:	00002517          	auipc	a0,0x2
    80005fee:	6c650513          	addi	a0,a0,1734 # 800086b0 <etext+0x6b0>
    80005ff2:	00000097          	auipc	ra,0x0
    80005ff6:	f1a080e7          	jalr	-230(ra) # 80005f0c <panic>
      consputc(c);
    80005ffa:	00000097          	auipc	ra,0x0
    80005ffe:	c46080e7          	jalr	-954(ra) # 80005c40 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006002:	2985                	addiw	s3,s3,1
    80006004:	013a07b3          	add	a5,s4,s3
    80006008:	0007c503          	lbu	a0,0(a5)
    8000600c:	10050563          	beqz	a0,80006116 <printf+0x1c0>
    if(c != '%'){
    80006010:	ff6515e3          	bne	a0,s6,80005ffa <printf+0xa4>
    c = fmt[++i] & 0xff;
    80006014:	2985                	addiw	s3,s3,1
    80006016:	013a07b3          	add	a5,s4,s3
    8000601a:	0007c783          	lbu	a5,0(a5)
    8000601e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006022:	10078b63          	beqz	a5,80006138 <printf+0x1e2>
    switch(c){
    80006026:	05778a63          	beq	a5,s7,8000607a <printf+0x124>
    8000602a:	02fbf663          	bgeu	s7,a5,80006056 <printf+0x100>
    8000602e:	09878863          	beq	a5,s8,800060be <printf+0x168>
    80006032:	07800713          	li	a4,120
    80006036:	0ce79563          	bne	a5,a4,80006100 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000603a:	f8843783          	ld	a5,-120(s0)
    8000603e:	00878713          	addi	a4,a5,8
    80006042:	f8e43423          	sd	a4,-120(s0)
    80006046:	4605                	li	a2,1
    80006048:	85e6                	mv	a1,s9
    8000604a:	4388                	lw	a0,0(a5)
    8000604c:	00000097          	auipc	ra,0x0
    80006050:	e1c080e7          	jalr	-484(ra) # 80005e68 <printint>
      break;
    80006054:	b77d                	j	80006002 <printf+0xac>
    switch(c){
    80006056:	09678f63          	beq	a5,s6,800060f4 <printf+0x19e>
    8000605a:	0bb79363          	bne	a5,s11,80006100 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    8000605e:	f8843783          	ld	a5,-120(s0)
    80006062:	00878713          	addi	a4,a5,8
    80006066:	f8e43423          	sd	a4,-120(s0)
    8000606a:	4605                	li	a2,1
    8000606c:	45a9                	li	a1,10
    8000606e:	4388                	lw	a0,0(a5)
    80006070:	00000097          	auipc	ra,0x0
    80006074:	df8080e7          	jalr	-520(ra) # 80005e68 <printint>
      break;
    80006078:	b769                	j	80006002 <printf+0xac>
      printptr(va_arg(ap, uint64));
    8000607a:	f8843783          	ld	a5,-120(s0)
    8000607e:	00878713          	addi	a4,a5,8
    80006082:	f8e43423          	sd	a4,-120(s0)
    80006086:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000608a:	03000513          	li	a0,48
    8000608e:	00000097          	auipc	ra,0x0
    80006092:	bb2080e7          	jalr	-1102(ra) # 80005c40 <consputc>
  consputc('x');
    80006096:	07800513          	li	a0,120
    8000609a:	00000097          	auipc	ra,0x0
    8000609e:	ba6080e7          	jalr	-1114(ra) # 80005c40 <consputc>
    800060a2:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060a4:	03c95793          	srli	a5,s2,0x3c
    800060a8:	97d6                	add	a5,a5,s5
    800060aa:	0007c503          	lbu	a0,0(a5)
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	b92080e7          	jalr	-1134(ra) # 80005c40 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800060b6:	0912                	slli	s2,s2,0x4
    800060b8:	34fd                	addiw	s1,s1,-1
    800060ba:	f4ed                	bnez	s1,800060a4 <printf+0x14e>
    800060bc:	b799                	j	80006002 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800060be:	f8843783          	ld	a5,-120(s0)
    800060c2:	00878713          	addi	a4,a5,8
    800060c6:	f8e43423          	sd	a4,-120(s0)
    800060ca:	6384                	ld	s1,0(a5)
    800060cc:	cc89                	beqz	s1,800060e6 <printf+0x190>
      for(; *s; s++)
    800060ce:	0004c503          	lbu	a0,0(s1)
    800060d2:	d905                	beqz	a0,80006002 <printf+0xac>
        consputc(*s);
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	b6c080e7          	jalr	-1172(ra) # 80005c40 <consputc>
      for(; *s; s++)
    800060dc:	0485                	addi	s1,s1,1
    800060de:	0004c503          	lbu	a0,0(s1)
    800060e2:	f96d                	bnez	a0,800060d4 <printf+0x17e>
    800060e4:	bf39                	j	80006002 <printf+0xac>
        s = "(null)";
    800060e6:	00002497          	auipc	s1,0x2
    800060ea:	5c248493          	addi	s1,s1,1474 # 800086a8 <etext+0x6a8>
      for(; *s; s++)
    800060ee:	02800513          	li	a0,40
    800060f2:	b7cd                	j	800060d4 <printf+0x17e>
      consputc('%');
    800060f4:	855a                	mv	a0,s6
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	b4a080e7          	jalr	-1206(ra) # 80005c40 <consputc>
      break;
    800060fe:	b711                	j	80006002 <printf+0xac>
      consputc('%');
    80006100:	855a                	mv	a0,s6
    80006102:	00000097          	auipc	ra,0x0
    80006106:	b3e080e7          	jalr	-1218(ra) # 80005c40 <consputc>
      consputc(c);
    8000610a:	8526                	mv	a0,s1
    8000610c:	00000097          	auipc	ra,0x0
    80006110:	b34080e7          	jalr	-1228(ra) # 80005c40 <consputc>
      break;
    80006114:	b5fd                	j	80006002 <printf+0xac>
    80006116:	74a6                	ld	s1,104(sp)
    80006118:	7906                	ld	s2,96(sp)
    8000611a:	69e6                	ld	s3,88(sp)
    8000611c:	6aa6                	ld	s5,72(sp)
    8000611e:	6b06                	ld	s6,64(sp)
    80006120:	7be2                	ld	s7,56(sp)
    80006122:	7c42                	ld	s8,48(sp)
    80006124:	7ca2                	ld	s9,40(sp)
    80006126:	6de2                	ld	s11,24(sp)
  if(locking)
    80006128:	020d1263          	bnez	s10,8000614c <printf+0x1f6>
}
    8000612c:	70e6                	ld	ra,120(sp)
    8000612e:	7446                	ld	s0,112(sp)
    80006130:	6a46                	ld	s4,80(sp)
    80006132:	7d02                	ld	s10,32(sp)
    80006134:	6129                	addi	sp,sp,192
    80006136:	8082                	ret
    80006138:	74a6                	ld	s1,104(sp)
    8000613a:	7906                	ld	s2,96(sp)
    8000613c:	69e6                	ld	s3,88(sp)
    8000613e:	6aa6                	ld	s5,72(sp)
    80006140:	6b06                	ld	s6,64(sp)
    80006142:	7be2                	ld	s7,56(sp)
    80006144:	7c42                	ld	s8,48(sp)
    80006146:	7ca2                	ld	s9,40(sp)
    80006148:	6de2                	ld	s11,24(sp)
    8000614a:	bff9                	j	80006128 <printf+0x1d2>
    release(&pr.lock);
    8000614c:	0001b517          	auipc	a0,0x1b
    80006150:	09c50513          	addi	a0,a0,156 # 800211e8 <pr>
    80006154:	00000097          	auipc	ra,0x0
    80006158:	3e6080e7          	jalr	998(ra) # 8000653a <release>
}
    8000615c:	bfc1                	j	8000612c <printf+0x1d6>

000000008000615e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000615e:	1101                	addi	sp,sp,-32
    80006160:	ec06                	sd	ra,24(sp)
    80006162:	e822                	sd	s0,16(sp)
    80006164:	e426                	sd	s1,8(sp)
    80006166:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006168:	0001b497          	auipc	s1,0x1b
    8000616c:	08048493          	addi	s1,s1,128 # 800211e8 <pr>
    80006170:	00002597          	auipc	a1,0x2
    80006174:	55058593          	addi	a1,a1,1360 # 800086c0 <etext+0x6c0>
    80006178:	8526                	mv	a0,s1
    8000617a:	00000097          	auipc	ra,0x0
    8000617e:	27c080e7          	jalr	636(ra) # 800063f6 <initlock>
  pr.locking = 1;
    80006182:	4785                	li	a5,1
    80006184:	cc9c                	sw	a5,24(s1)
}
    80006186:	60e2                	ld	ra,24(sp)
    80006188:	6442                	ld	s0,16(sp)
    8000618a:	64a2                	ld	s1,8(sp)
    8000618c:	6105                	addi	sp,sp,32
    8000618e:	8082                	ret

0000000080006190 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006190:	1141                	addi	sp,sp,-16
    80006192:	e406                	sd	ra,8(sp)
    80006194:	e022                	sd	s0,0(sp)
    80006196:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006198:	100007b7          	lui	a5,0x10000
    8000619c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800061a0:	10000737          	lui	a4,0x10000
    800061a4:	f8000693          	li	a3,-128
    800061a8:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800061ac:	468d                	li	a3,3
    800061ae:	10000637          	lui	a2,0x10000
    800061b2:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800061b6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800061ba:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800061be:	10000737          	lui	a4,0x10000
    800061c2:	461d                	li	a2,7
    800061c4:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800061c8:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800061cc:	00002597          	auipc	a1,0x2
    800061d0:	4fc58593          	addi	a1,a1,1276 # 800086c8 <etext+0x6c8>
    800061d4:	0001b517          	auipc	a0,0x1b
    800061d8:	03450513          	addi	a0,a0,52 # 80021208 <uart_tx_lock>
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	21a080e7          	jalr	538(ra) # 800063f6 <initlock>
}
    800061e4:	60a2                	ld	ra,8(sp)
    800061e6:	6402                	ld	s0,0(sp)
    800061e8:	0141                	addi	sp,sp,16
    800061ea:	8082                	ret

00000000800061ec <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800061ec:	1101                	addi	sp,sp,-32
    800061ee:	ec06                	sd	ra,24(sp)
    800061f0:	e822                	sd	s0,16(sp)
    800061f2:	e426                	sd	s1,8(sp)
    800061f4:	1000                	addi	s0,sp,32
    800061f6:	84aa                	mv	s1,a0
  push_off();
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	242080e7          	jalr	578(ra) # 8000643a <push_off>

  if(panicked){
    80006200:	00003797          	auipc	a5,0x3
    80006204:	e1c7a783          	lw	a5,-484(a5) # 8000901c <panicked>
    80006208:	eb85                	bnez	a5,80006238 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000620a:	10000737          	lui	a4,0x10000
    8000620e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006210:	00074783          	lbu	a5,0(a4)
    80006214:	0207f793          	andi	a5,a5,32
    80006218:	dfe5                	beqz	a5,80006210 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000621a:	0ff4f513          	zext.b	a0,s1
    8000621e:	100007b7          	lui	a5,0x10000
    80006222:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006226:	00000097          	auipc	ra,0x0
    8000622a:	2b4080e7          	jalr	692(ra) # 800064da <pop_off>
}
    8000622e:	60e2                	ld	ra,24(sp)
    80006230:	6442                	ld	s0,16(sp)
    80006232:	64a2                	ld	s1,8(sp)
    80006234:	6105                	addi	sp,sp,32
    80006236:	8082                	ret
    for(;;)
    80006238:	a001                	j	80006238 <uartputc_sync+0x4c>

000000008000623a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000623a:	00003797          	auipc	a5,0x3
    8000623e:	de67b783          	ld	a5,-538(a5) # 80009020 <uart_tx_r>
    80006242:	00003717          	auipc	a4,0x3
    80006246:	de673703          	ld	a4,-538(a4) # 80009028 <uart_tx_w>
    8000624a:	06f70f63          	beq	a4,a5,800062c8 <uartstart+0x8e>
{
    8000624e:	7139                	addi	sp,sp,-64
    80006250:	fc06                	sd	ra,56(sp)
    80006252:	f822                	sd	s0,48(sp)
    80006254:	f426                	sd	s1,40(sp)
    80006256:	f04a                	sd	s2,32(sp)
    80006258:	ec4e                	sd	s3,24(sp)
    8000625a:	e852                	sd	s4,16(sp)
    8000625c:	e456                	sd	s5,8(sp)
    8000625e:	e05a                	sd	s6,0(sp)
    80006260:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006262:	10000937          	lui	s2,0x10000
    80006266:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006268:	0001ba97          	auipc	s5,0x1b
    8000626c:	fa0a8a93          	addi	s5,s5,-96 # 80021208 <uart_tx_lock>
    uart_tx_r += 1;
    80006270:	00003497          	auipc	s1,0x3
    80006274:	db048493          	addi	s1,s1,-592 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006278:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000627c:	00003997          	auipc	s3,0x3
    80006280:	dac98993          	addi	s3,s3,-596 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006284:	00094703          	lbu	a4,0(s2)
    80006288:	02077713          	andi	a4,a4,32
    8000628c:	c705                	beqz	a4,800062b4 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000628e:	01f7f713          	andi	a4,a5,31
    80006292:	9756                	add	a4,a4,s5
    80006294:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006298:	0785                	addi	a5,a5,1
    8000629a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000629c:	8526                	mv	a0,s1
    8000629e:	ffffb097          	auipc	ra,0xffffb
    800062a2:	430080e7          	jalr	1072(ra) # 800016ce <wakeup>
    WriteReg(THR, c);
    800062a6:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800062aa:	609c                	ld	a5,0(s1)
    800062ac:	0009b703          	ld	a4,0(s3)
    800062b0:	fcf71ae3          	bne	a4,a5,80006284 <uartstart+0x4a>
  }
}
    800062b4:	70e2                	ld	ra,56(sp)
    800062b6:	7442                	ld	s0,48(sp)
    800062b8:	74a2                	ld	s1,40(sp)
    800062ba:	7902                	ld	s2,32(sp)
    800062bc:	69e2                	ld	s3,24(sp)
    800062be:	6a42                	ld	s4,16(sp)
    800062c0:	6aa2                	ld	s5,8(sp)
    800062c2:	6b02                	ld	s6,0(sp)
    800062c4:	6121                	addi	sp,sp,64
    800062c6:	8082                	ret
    800062c8:	8082                	ret

00000000800062ca <uartputc>:
{
    800062ca:	7179                	addi	sp,sp,-48
    800062cc:	f406                	sd	ra,40(sp)
    800062ce:	f022                	sd	s0,32(sp)
    800062d0:	e052                	sd	s4,0(sp)
    800062d2:	1800                	addi	s0,sp,48
    800062d4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800062d6:	0001b517          	auipc	a0,0x1b
    800062da:	f3250513          	addi	a0,a0,-206 # 80021208 <uart_tx_lock>
    800062de:	00000097          	auipc	ra,0x0
    800062e2:	1a8080e7          	jalr	424(ra) # 80006486 <acquire>
  if(panicked){
    800062e6:	00003797          	auipc	a5,0x3
    800062ea:	d367a783          	lw	a5,-714(a5) # 8000901c <panicked>
    800062ee:	c391                	beqz	a5,800062f2 <uartputc+0x28>
    for(;;)
    800062f0:	a001                	j	800062f0 <uartputc+0x26>
    800062f2:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062f4:	00003717          	auipc	a4,0x3
    800062f8:	d3473703          	ld	a4,-716(a4) # 80009028 <uart_tx_w>
    800062fc:	00003797          	auipc	a5,0x3
    80006300:	d247b783          	ld	a5,-732(a5) # 80009020 <uart_tx_r>
    80006304:	02078793          	addi	a5,a5,32
    80006308:	02e79f63          	bne	a5,a4,80006346 <uartputc+0x7c>
    8000630c:	e84a                	sd	s2,16(sp)
    8000630e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006310:	0001b997          	auipc	s3,0x1b
    80006314:	ef898993          	addi	s3,s3,-264 # 80021208 <uart_tx_lock>
    80006318:	00003497          	auipc	s1,0x3
    8000631c:	d0848493          	addi	s1,s1,-760 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006320:	00003917          	auipc	s2,0x3
    80006324:	d0890913          	addi	s2,s2,-760 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006328:	85ce                	mv	a1,s3
    8000632a:	8526                	mv	a0,s1
    8000632c:	ffffb097          	auipc	ra,0xffffb
    80006330:	216080e7          	jalr	534(ra) # 80001542 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006334:	00093703          	ld	a4,0(s2)
    80006338:	609c                	ld	a5,0(s1)
    8000633a:	02078793          	addi	a5,a5,32
    8000633e:	fee785e3          	beq	a5,a4,80006328 <uartputc+0x5e>
    80006342:	6942                	ld	s2,16(sp)
    80006344:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006346:	0001b497          	auipc	s1,0x1b
    8000634a:	ec248493          	addi	s1,s1,-318 # 80021208 <uart_tx_lock>
    8000634e:	01f77793          	andi	a5,a4,31
    80006352:	97a6                	add	a5,a5,s1
    80006354:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006358:	0705                	addi	a4,a4,1
    8000635a:	00003797          	auipc	a5,0x3
    8000635e:	cce7b723          	sd	a4,-818(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006362:	00000097          	auipc	ra,0x0
    80006366:	ed8080e7          	jalr	-296(ra) # 8000623a <uartstart>
      release(&uart_tx_lock);
    8000636a:	8526                	mv	a0,s1
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	1ce080e7          	jalr	462(ra) # 8000653a <release>
    80006374:	64e2                	ld	s1,24(sp)
}
    80006376:	70a2                	ld	ra,40(sp)
    80006378:	7402                	ld	s0,32(sp)
    8000637a:	6a02                	ld	s4,0(sp)
    8000637c:	6145                	addi	sp,sp,48
    8000637e:	8082                	ret

0000000080006380 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006380:	1141                	addi	sp,sp,-16
    80006382:	e422                	sd	s0,8(sp)
    80006384:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006386:	100007b7          	lui	a5,0x10000
    8000638a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000638c:	0007c783          	lbu	a5,0(a5)
    80006390:	8b85                	andi	a5,a5,1
    80006392:	cb81                	beqz	a5,800063a2 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006394:	100007b7          	lui	a5,0x10000
    80006398:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000639c:	6422                	ld	s0,8(sp)
    8000639e:	0141                	addi	sp,sp,16
    800063a0:	8082                	ret
    return -1;
    800063a2:	557d                	li	a0,-1
    800063a4:	bfe5                	j	8000639c <uartgetc+0x1c>

00000000800063a6 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800063a6:	1101                	addi	sp,sp,-32
    800063a8:	ec06                	sd	ra,24(sp)
    800063aa:	e822                	sd	s0,16(sp)
    800063ac:	e426                	sd	s1,8(sp)
    800063ae:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800063b0:	54fd                	li	s1,-1
    800063b2:	a029                	j	800063bc <uartintr+0x16>
      break;
    consoleintr(c);
    800063b4:	00000097          	auipc	ra,0x0
    800063b8:	8ce080e7          	jalr	-1842(ra) # 80005c82 <consoleintr>
    int c = uartgetc();
    800063bc:	00000097          	auipc	ra,0x0
    800063c0:	fc4080e7          	jalr	-60(ra) # 80006380 <uartgetc>
    if(c == -1)
    800063c4:	fe9518e3          	bne	a0,s1,800063b4 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800063c8:	0001b497          	auipc	s1,0x1b
    800063cc:	e4048493          	addi	s1,s1,-448 # 80021208 <uart_tx_lock>
    800063d0:	8526                	mv	a0,s1
    800063d2:	00000097          	auipc	ra,0x0
    800063d6:	0b4080e7          	jalr	180(ra) # 80006486 <acquire>
  uartstart();
    800063da:	00000097          	auipc	ra,0x0
    800063de:	e60080e7          	jalr	-416(ra) # 8000623a <uartstart>
  release(&uart_tx_lock);
    800063e2:	8526                	mv	a0,s1
    800063e4:	00000097          	auipc	ra,0x0
    800063e8:	156080e7          	jalr	342(ra) # 8000653a <release>
}
    800063ec:	60e2                	ld	ra,24(sp)
    800063ee:	6442                	ld	s0,16(sp)
    800063f0:	64a2                	ld	s1,8(sp)
    800063f2:	6105                	addi	sp,sp,32
    800063f4:	8082                	ret

00000000800063f6 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800063f6:	1141                	addi	sp,sp,-16
    800063f8:	e422                	sd	s0,8(sp)
    800063fa:	0800                	addi	s0,sp,16
  lk->name = name;
    800063fc:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800063fe:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006402:	00053823          	sd	zero,16(a0)
}
    80006406:	6422                	ld	s0,8(sp)
    80006408:	0141                	addi	sp,sp,16
    8000640a:	8082                	ret

000000008000640c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000640c:	411c                	lw	a5,0(a0)
    8000640e:	e399                	bnez	a5,80006414 <holding+0x8>
    80006410:	4501                	li	a0,0
  return r;
}
    80006412:	8082                	ret
{
    80006414:	1101                	addi	sp,sp,-32
    80006416:	ec06                	sd	ra,24(sp)
    80006418:	e822                	sd	s0,16(sp)
    8000641a:	e426                	sd	s1,8(sp)
    8000641c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000641e:	6904                	ld	s1,16(a0)
    80006420:	ffffb097          	auipc	ra,0xffffb
    80006424:	a40080e7          	jalr	-1472(ra) # 80000e60 <mycpu>
    80006428:	40a48533          	sub	a0,s1,a0
    8000642c:	00153513          	seqz	a0,a0
}
    80006430:	60e2                	ld	ra,24(sp)
    80006432:	6442                	ld	s0,16(sp)
    80006434:	64a2                	ld	s1,8(sp)
    80006436:	6105                	addi	sp,sp,32
    80006438:	8082                	ret

000000008000643a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000643a:	1101                	addi	sp,sp,-32
    8000643c:	ec06                	sd	ra,24(sp)
    8000643e:	e822                	sd	s0,16(sp)
    80006440:	e426                	sd	s1,8(sp)
    80006442:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006444:	100024f3          	csrr	s1,sstatus
    80006448:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000644c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000644e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006452:	ffffb097          	auipc	ra,0xffffb
    80006456:	a0e080e7          	jalr	-1522(ra) # 80000e60 <mycpu>
    8000645a:	5d3c                	lw	a5,120(a0)
    8000645c:	cf89                	beqz	a5,80006476 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000645e:	ffffb097          	auipc	ra,0xffffb
    80006462:	a02080e7          	jalr	-1534(ra) # 80000e60 <mycpu>
    80006466:	5d3c                	lw	a5,120(a0)
    80006468:	2785                	addiw	a5,a5,1
    8000646a:	dd3c                	sw	a5,120(a0)
}
    8000646c:	60e2                	ld	ra,24(sp)
    8000646e:	6442                	ld	s0,16(sp)
    80006470:	64a2                	ld	s1,8(sp)
    80006472:	6105                	addi	sp,sp,32
    80006474:	8082                	ret
    mycpu()->intena = old;
    80006476:	ffffb097          	auipc	ra,0xffffb
    8000647a:	9ea080e7          	jalr	-1558(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000647e:	8085                	srli	s1,s1,0x1
    80006480:	8885                	andi	s1,s1,1
    80006482:	dd64                	sw	s1,124(a0)
    80006484:	bfe9                	j	8000645e <push_off+0x24>

0000000080006486 <acquire>:
{
    80006486:	1101                	addi	sp,sp,-32
    80006488:	ec06                	sd	ra,24(sp)
    8000648a:	e822                	sd	s0,16(sp)
    8000648c:	e426                	sd	s1,8(sp)
    8000648e:	1000                	addi	s0,sp,32
    80006490:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006492:	00000097          	auipc	ra,0x0
    80006496:	fa8080e7          	jalr	-88(ra) # 8000643a <push_off>
  if(holding(lk))
    8000649a:	8526                	mv	a0,s1
    8000649c:	00000097          	auipc	ra,0x0
    800064a0:	f70080e7          	jalr	-144(ra) # 8000640c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064a4:	4705                	li	a4,1
  if(holding(lk))
    800064a6:	e115                	bnez	a0,800064ca <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064a8:	87ba                	mv	a5,a4
    800064aa:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800064ae:	2781                	sext.w	a5,a5
    800064b0:	ffe5                	bnez	a5,800064a8 <acquire+0x22>
  __sync_synchronize();
    800064b2:	0ff0000f          	fence
  lk->cpu = mycpu();
    800064b6:	ffffb097          	auipc	ra,0xffffb
    800064ba:	9aa080e7          	jalr	-1622(ra) # 80000e60 <mycpu>
    800064be:	e888                	sd	a0,16(s1)
}
    800064c0:	60e2                	ld	ra,24(sp)
    800064c2:	6442                	ld	s0,16(sp)
    800064c4:	64a2                	ld	s1,8(sp)
    800064c6:	6105                	addi	sp,sp,32
    800064c8:	8082                	ret
    panic("acquire");
    800064ca:	00002517          	auipc	a0,0x2
    800064ce:	20650513          	addi	a0,a0,518 # 800086d0 <etext+0x6d0>
    800064d2:	00000097          	auipc	ra,0x0
    800064d6:	a3a080e7          	jalr	-1478(ra) # 80005f0c <panic>

00000000800064da <pop_off>:

void
pop_off(void)
{
    800064da:	1141                	addi	sp,sp,-16
    800064dc:	e406                	sd	ra,8(sp)
    800064de:	e022                	sd	s0,0(sp)
    800064e0:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800064e2:	ffffb097          	auipc	ra,0xffffb
    800064e6:	97e080e7          	jalr	-1666(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064ea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800064ee:	8b89                	andi	a5,a5,2
  if(intr_get())
    800064f0:	e78d                	bnez	a5,8000651a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800064f2:	5d3c                	lw	a5,120(a0)
    800064f4:	02f05b63          	blez	a5,8000652a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800064f8:	37fd                	addiw	a5,a5,-1
    800064fa:	0007871b          	sext.w	a4,a5
    800064fe:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006500:	eb09                	bnez	a4,80006512 <pop_off+0x38>
    80006502:	5d7c                	lw	a5,124(a0)
    80006504:	c799                	beqz	a5,80006512 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006506:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000650a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000650e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006512:	60a2                	ld	ra,8(sp)
    80006514:	6402                	ld	s0,0(sp)
    80006516:	0141                	addi	sp,sp,16
    80006518:	8082                	ret
    panic("pop_off - interruptible");
    8000651a:	00002517          	auipc	a0,0x2
    8000651e:	1be50513          	addi	a0,a0,446 # 800086d8 <etext+0x6d8>
    80006522:	00000097          	auipc	ra,0x0
    80006526:	9ea080e7          	jalr	-1558(ra) # 80005f0c <panic>
    panic("pop_off");
    8000652a:	00002517          	auipc	a0,0x2
    8000652e:	1c650513          	addi	a0,a0,454 # 800086f0 <etext+0x6f0>
    80006532:	00000097          	auipc	ra,0x0
    80006536:	9da080e7          	jalr	-1574(ra) # 80005f0c <panic>

000000008000653a <release>:
{
    8000653a:	1101                	addi	sp,sp,-32
    8000653c:	ec06                	sd	ra,24(sp)
    8000653e:	e822                	sd	s0,16(sp)
    80006540:	e426                	sd	s1,8(sp)
    80006542:	1000                	addi	s0,sp,32
    80006544:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006546:	00000097          	auipc	ra,0x0
    8000654a:	ec6080e7          	jalr	-314(ra) # 8000640c <holding>
    8000654e:	c115                	beqz	a0,80006572 <release+0x38>
  lk->cpu = 0;
    80006550:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006554:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006558:	0f50000f          	fence	iorw,ow
    8000655c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006560:	00000097          	auipc	ra,0x0
    80006564:	f7a080e7          	jalr	-134(ra) # 800064da <pop_off>
}
    80006568:	60e2                	ld	ra,24(sp)
    8000656a:	6442                	ld	s0,16(sp)
    8000656c:	64a2                	ld	s1,8(sp)
    8000656e:	6105                	addi	sp,sp,32
    80006570:	8082                	ret
    panic("release");
    80006572:	00002517          	auipc	a0,0x2
    80006576:	18650513          	addi	a0,a0,390 # 800086f8 <etext+0x6f8>
    8000657a:	00000097          	auipc	ra,0x0
    8000657e:	992080e7          	jalr	-1646(ra) # 80005f0c <panic>
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
