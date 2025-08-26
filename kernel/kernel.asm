
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00020117          	auipc	sp,0x20
    80000004:	36010113          	addi	sp,sp,864 # 80020360 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	497050ef          	jal	80005cac <start>

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
    80000030:	00028797          	auipc	a5,0x28
    80000034:	43078793          	addi	a5,a5,1072 # 80028460 <end>
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
    8000005e:	69a080e7          	jalr	1690(ra) # 800066f4 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	73a080e7          	jalr	1850(ra) # 800067a8 <release>
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
    8000008e:	0f0080e7          	jalr	240(ra) # 8000617a <panic>

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
    800000fa:	56e080e7          	jalr	1390(ra) # 80006664 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00028517          	auipc	a0,0x28
    80000106:	35e50513          	addi	a0,a0,862 # 80028460 <end>
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
    80000132:	5c6080e7          	jalr	1478(ra) # 800066f4 <acquire>
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
    8000014a:	662080e7          	jalr	1634(ra) # 800067a8 <release>

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
    80000174:	638080e7          	jalr	1592(ra) # 800067a8 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd6ba1>
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
    80000324:	b1e080e7          	jalr	-1250(ra) # 80000e3e <cpuid>
    userinit();      // first user process
	vma_init();
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
    80000340:	b02080e7          	jalr	-1278(ra) # 80000e3e <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	e76080e7          	jalr	-394(ra) # 800061c4 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0e0080e7          	jalr	224(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	85e080e7          	jalr	-1954(ra) # 80001bbc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	25e080e7          	jalr	606(ra) # 800055c4 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	04a080e7          	jalr	74(ra) # 800013b8 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	d14080e7          	jalr	-748(ra) # 8000608a <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	04e080e7          	jalr	78(ra) # 800063cc <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	e36080e7          	jalr	-458(ra) # 800061c4 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	e26080e7          	jalr	-474(ra) # 800061c4 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	e16080e7          	jalr	-490(ra) # 800061c4 <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	32a080e7          	jalr	810(ra) # 800006e8 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	070080e7          	jalr	112(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	9b2080e7          	jalr	-1614(ra) # 80000d80 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	7be080e7          	jalr	1982(ra) # 80001b94 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	7de080e7          	jalr	2014(ra) # 80001bbc <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	1c4080e7          	jalr	452(ra) # 800055aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	1d6080e7          	jalr	470(ra) # 800055c4 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	044080e7          	jalr	68(ra) # 8000243a <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	6d0080e7          	jalr	1744(ra) # 80002ace <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	674080e7          	jalr	1652(ra) # 80003a7a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	2d6080e7          	jalr	726(ra) # 800056e4 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d2c080e7          	jalr	-724(ra) # 80001142 <userinit>
	vma_init();
    8000041e:	00005097          	auipc	ra,0x5
    80000422:	780080e7          	jalr	1920(ra) # 80005b9e <vma_init>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	bf2d                	j	8000036e <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043c:	00009797          	auipc	a5,0x9
    80000440:	bcc7b783          	ld	a5,-1076(a5) # 80009008 <kernel_pagetable>
    80000444:	83b1                	srli	a5,a5,0xc
    80000446:	577d                	li	a4,-1
    80000448:	177e                	slli	a4,a4,0x3f
    8000044a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000450:	12000073          	sfence.vma
  sfence_vma();
}
    80000454:	6422                	ld	s0,8(sp)
    80000456:	0141                	addi	sp,sp,16
    80000458:	8082                	ret

000000008000045a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045a:	7139                	addi	sp,sp,-64
    8000045c:	fc06                	sd	ra,56(sp)
    8000045e:	f822                	sd	s0,48(sp)
    80000460:	f426                	sd	s1,40(sp)
    80000462:	f04a                	sd	s2,32(sp)
    80000464:	ec4e                	sd	s3,24(sp)
    80000466:	e852                	sd	s4,16(sp)
    80000468:	e456                	sd	s5,8(sp)
    8000046a:	e05a                	sd	s6,0(sp)
    8000046c:	0080                	addi	s0,sp,64
    8000046e:	84aa                	mv	s1,a0
    80000470:	89ae                	mv	s3,a1
    80000472:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	cf2080e7          	jalr	-782(ra) # 8000617a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000490:	060a8663          	beqz	s5,800004fc <walk+0xa2>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000049c:	84aa                	mv	s1,a0
    8000049e:	c529                	beqz	a0,800004e8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a0:	6605                	lui	a2,0x1
    800004a2:	4581                	li	a1,0
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	cd6080e7          	jalr	-810(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ac:	00c4d793          	srli	a5,s1,0xc
    800004b0:	07aa                	slli	a5,a5,0xa
    800004b2:	0017e793          	ori	a5,a5,1
    800004b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd6b97>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004cc:	00093483          	ld	s1,0(s2)
    800004d0:	0014f793          	andi	a5,s1,1
    800004d4:	dfd5                	beqz	a5,80000490 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d6:	80a9                	srli	s1,s1,0xa
    800004d8:	04b2                	slli	s1,s1,0xc
    800004da:	b7c5                	j	800004ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004dc:	00c9d513          	srli	a0,s3,0xc
    800004e0:	1ff57513          	andi	a0,a0,511
    800004e4:	050e                	slli	a0,a0,0x3
    800004e6:	9526                	add	a0,a0,s1
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	74a2                	ld	s1,40(sp)
    800004ee:	7902                	ld	s2,32(sp)
    800004f0:	69e2                	ld	s3,24(sp)
    800004f2:	6a42                	ld	s4,16(sp)
    800004f4:	6aa2                	ld	s5,8(sp)
    800004f6:	6b02                	ld	s6,0(sp)
    800004f8:	6121                	addi	sp,sp,64
    800004fa:	8082                	ret
        return 0;
    800004fc:	4501                	li	a0,0
    800004fe:	b7ed                	j	800004e8 <walk+0x8e>

0000000080000500 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050a:	8082                	ret
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000514:	4601                	li	a2,0
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	f44080e7          	jalr	-188(ra) # 8000045a <walk>
  if(pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052a:	00e68663          	beq	a3,a4,80000536 <walkaddr+0x36>
}
    8000052e:	60a2                	ld	ra,8(sp)
    80000530:	6402                	ld	s0,0(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  pa = PTE2PA(*pte);
    80000536:	83a9                	srli	a5,a5,0xa
    80000538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053c:	bfcd                	j	8000052e <walkaddr+0x2e>
    return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7fd                	j	8000052e <walkaddr+0x2e>

0000000080000542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000542:	715d                	addi	sp,sp,-80
    80000544:	e486                	sd	ra,72(sp)
    80000546:	e0a2                	sd	s0,64(sp)
    80000548:	fc26                	sd	s1,56(sp)
    8000054a:	f84a                	sd	s2,48(sp)
    8000054c:	f44e                	sd	s3,40(sp)
    8000054e:	f052                	sd	s4,32(sp)
    80000550:	ec56                	sd	s5,24(sp)
    80000552:	e85a                	sd	s6,16(sp)
    80000554:	e45e                	sd	s7,8(sp)
    80000556:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000558:	c639                	beqz	a2,800005a6 <mappages+0x64>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055e:	777d                	lui	a4,0xfffff
    80000560:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000564:	fff58993          	addi	s3,a1,-1
    80000568:	99b2                	add	s3,s3,a2
    8000056a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000056e:	893e                	mv	s2,a5
    80000570:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	bcc080e7          	jalr	-1076(ra) # 8000617a <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	bbc080e7          	jalr	-1092(ra) # 8000617a <panic>
      return -1;
    800005c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c8:	60a6                	ld	ra,72(sp)
    800005ca:	6406                	ld	s0,64(sp)
    800005cc:	74e2                	ld	s1,56(sp)
    800005ce:	7942                	ld	s2,48(sp)
    800005d0:	79a2                	ld	s3,40(sp)
    800005d2:	7a02                	ld	s4,32(sp)
    800005d4:	6ae2                	ld	s5,24(sp)
    800005d6:	6b42                	ld	s6,16(sp)
    800005d8:	6ba2                	ld	s7,8(sp)
    800005da:	6161                	addi	sp,sp,80
    800005dc:	8082                	ret
  return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7e5                	j	800005c8 <mappages+0x86>

00000000800005e2 <kvmmap>:
{
    800005e2:	1141                	addi	sp,sp,-16
    800005e4:	e406                	sd	ra,8(sp)
    800005e6:	e022                	sd	s0,0(sp)
    800005e8:	0800                	addi	s0,sp,16
    800005ea:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ec:	86b2                	mv	a3,a2
    800005ee:	863e                	mv	a2,a5
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f52080e7          	jalr	-174(ra) # 80000542 <mappages>
    800005f8:	e509                	bnez	a0,80000602 <kvmmap+0x20>
}
    800005fa:	60a2                	ld	ra,8(sp)
    800005fc:	6402                	ld	s0,0(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret
    panic("kvmmap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a7650513          	addi	a0,a0,-1418 # 80008078 <etext+0x78>
    8000060a:	00006097          	auipc	ra,0x6
    8000060e:	b70080e7          	jalr	-1168(ra) # 8000617a <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	afc080e7          	jalr	-1284(ra) # 8000011a <kalloc>
    80000626:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000628:	6605                	lui	a2,0x1
    8000062a:	4581                	li	a1,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	b4e080e7          	jalr	-1202(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	6685                	lui	a3,0x1
    80000638:	10000637          	lui	a2,0x10000
    8000063c:	100005b7          	lui	a1,0x10000
    80000640:	8526                	mv	a0,s1
    80000642:	00000097          	auipc	ra,0x0
    80000646:	fa0080e7          	jalr	-96(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10001637          	lui	a2,0x10001
    80000652:	100015b7          	lui	a1,0x10001
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f8a080e7          	jalr	-118(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	004006b7          	lui	a3,0x400
    80000666:	0c000637          	lui	a2,0xc000
    8000066a:	0c0005b7          	lui	a1,0xc000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f72080e7          	jalr	-142(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000678:	00008917          	auipc	s2,0x8
    8000067c:	98890913          	addi	s2,s2,-1656 # 80008000 <etext>
    80000680:	4729                	li	a4,10
    80000682:	80008697          	auipc	a3,0x80008
    80000686:	97e68693          	addi	a3,a3,-1666 # 8000 <_entry-0x7fff8000>
    8000068a:	4605                	li	a2,1
    8000068c:	067e                	slli	a2,a2,0x1f
    8000068e:	85b2                	mv	a1,a2
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f50080e7          	jalr	-176(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069a:	46c5                	li	a3,17
    8000069c:	06ee                	slli	a3,a3,0x1b
    8000069e:	4719                	li	a4,6
    800006a0:	412686b3          	sub	a3,a3,s2
    800006a4:	864a                	mv	a2,s2
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f38080e7          	jalr	-200(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b2:	4729                	li	a4,10
    800006b4:	6685                	lui	a3,0x1
    800006b6:	00007617          	auipc	a2,0x7
    800006ba:	94a60613          	addi	a2,a2,-1718 # 80007000 <_trampoline>
    800006be:	040005b7          	lui	a1,0x4000
    800006c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c4:	05b2                	slli	a1,a1,0xc
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f1a080e7          	jalr	-230(ra) # 800005e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	60a080e7          	jalr	1546(ra) # 80000cdc <proc_mapstacks>
}
    800006da:	8526                	mv	a0,s1
    800006dc:	60e2                	ld	ra,24(sp)
    800006de:	6442                	ld	s0,16(sp)
    800006e0:	64a2                	ld	s1,8(sp)
    800006e2:	6902                	ld	s2,0(sp)
    800006e4:	6105                	addi	sp,sp,32
    800006e6:	8082                	ret

00000000800006e8 <kvminit>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f22080e7          	jalr	-222(ra) # 80000612 <kvmmake>
    800006f8:	00009797          	auipc	a5,0x9
    800006fc:	90a7b823          	sd	a0,-1776(a5) # 80009008 <kernel_pagetable>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret

0000000080000708 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000708:	715d                	addi	sp,sp,-80
    8000070a:	e486                	sd	ra,72(sp)
    8000070c:	e0a2                	sd	s0,64(sp)
    8000070e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000710:	03459793          	slli	a5,a1,0x34
    80000714:	e39d                	bnez	a5,8000073a <uvmunmap+0x32>
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	8a2a                	mv	s4,a0
    80000724:	892e                	mv	s2,a1
    80000726:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	0632                	slli	a2,a2,0xc
    8000072a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      continue;
      //panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000072e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	6a85                	lui	s5,0x1
    80000732:	0935f463          	bgeu	a1,s3,800007ba <uvmunmap+0xb2>
    80000736:	fc26                	sd	s1,56(sp)
    80000738:	a0a9                	j	80000782 <uvmunmap+0x7a>
    8000073a:	fc26                	sd	s1,56(sp)
    8000073c:	f84a                	sd	s2,48(sp)
    8000073e:	f44e                	sd	s3,40(sp)
    80000740:	f052                	sd	s4,32(sp)
    80000742:	ec56                	sd	s5,24(sp)
    80000744:	e85a                	sd	s6,16(sp)
    80000746:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000748:	00008517          	auipc	a0,0x8
    8000074c:	93850513          	addi	a0,a0,-1736 # 80008080 <etext+0x80>
    80000750:	00006097          	auipc	ra,0x6
    80000754:	a2a080e7          	jalr	-1494(ra) # 8000617a <panic>
      panic("uvmunmap: walk");
    80000758:	00008517          	auipc	a0,0x8
    8000075c:	94050513          	addi	a0,a0,-1728 # 80008098 <etext+0x98>
    80000760:	00006097          	auipc	ra,0x6
    80000764:	a1a080e7          	jalr	-1510(ra) # 8000617a <panic>
      panic("uvmunmap: not a leaf");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	94050513          	addi	a0,a0,-1728 # 800080a8 <etext+0xa8>
    80000770:	00006097          	auipc	ra,0x6
    80000774:	a0a080e7          	jalr	-1526(ra) # 8000617a <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000778:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077c:	9956                	add	s2,s2,s5
    8000077e:	03397d63          	bgeu	s2,s3,800007b8 <uvmunmap+0xb0>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000782:	4601                	li	a2,0
    80000784:	85ca                	mv	a1,s2
    80000786:	8552                	mv	a0,s4
    80000788:	00000097          	auipc	ra,0x0
    8000078c:	cd2080e7          	jalr	-814(ra) # 8000045a <walk>
    80000790:	84aa                	mv	s1,a0
    80000792:	d179                	beqz	a0,80000758 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80000794:	611c                	ld	a5,0(a0)
    80000796:	0017f713          	andi	a4,a5,1
    8000079a:	d36d                	beqz	a4,8000077c <uvmunmap+0x74>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000079c:	3ff7f713          	andi	a4,a5,1023
    800007a0:	fd7704e3          	beq	a4,s7,80000768 <uvmunmap+0x60>
    if(do_free){
    800007a4:	fc0b0ae3          	beqz	s6,80000778 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    800007a8:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800007aa:	00c79513          	slli	a0,a5,0xc
    800007ae:	00000097          	auipc	ra,0x0
    800007b2:	86e080e7          	jalr	-1938(ra) # 8000001c <kfree>
    800007b6:	b7c9                	j	80000778 <uvmunmap+0x70>
    800007b8:	74e2                	ld	s1,56(sp)
    800007ba:	7942                	ld	s2,48(sp)
    800007bc:	79a2                	ld	s3,40(sp)
    800007be:	7a02                	ld	s4,32(sp)
    800007c0:	6ae2                	ld	s5,24(sp)
    800007c2:	6b42                	ld	s6,16(sp)
    800007c4:	6ba2                	ld	s7,8(sp)
  }
}
    800007c6:	60a6                	ld	ra,72(sp)
    800007c8:	6406                	ld	s0,64(sp)
    800007ca:	6161                	addi	sp,sp,80
    800007cc:	8082                	ret

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	942080e7          	jalr	-1726(ra) # 8000011a <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	992080e7          	jalr	-1646(ra) # 8000017a <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	addi	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvminit+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	902080e7          	jalr	-1790(ra) # 8000011a <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	954080e7          	jalr	-1708(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0a080e7          	jalr	-758(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	990080e7          	jalr	-1648(ra) # 800001d6 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	addi	sp,sp,48
    8000085c:	8082                	ret
    panic("inituvm: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	86250513          	addi	a0,a0,-1950 # 800080c0 <etext+0xc0>
    80000866:	00006097          	auipc	ra,0x6
    8000086a:	914080e7          	jalr	-1772(ra) # 8000617a <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	addi	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	76fd                	lui	a3,0xfffff
    8000088a:	8f75                	and	a4,a4,a3
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff5                	and	a5,a5,a3
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5c080e7          	jalr	-420(ra) # 80000708 <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	ec4e                	sd	s3,24(sp)
    800008c2:	e852                	sd	s4,16(sp)
    800008c4:	e456                	sd	s5,8(sp)
    800008c6:	0080                	addi	s0,sp,64
    800008c8:	8aaa                	mv	s5,a0
    800008ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008cc:	6785                	lui	a5,0x1
    800008ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d0:	95be                	add	a1,a1,a5
    800008d2:	77fd                	lui	a5,0xfffff
    800008d4:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d8:	08c9f663          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008dc:	f426                	sd	s1,40(sp)
    800008de:	f04a                	sd	s2,32(sp)
    800008e0:	894e                	mv	s2,s3
    mem = kalloc();
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	838080e7          	jalr	-1992(ra) # 8000011a <kalloc>
    800008ea:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ec:	c90d                	beqz	a0,8000091e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800008ee:	6605                	lui	a2,0x1
    800008f0:	4581                	li	a1,0
    800008f2:	00000097          	auipc	ra,0x0
    800008f6:	888080e7          	jalr	-1912(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fa:	4779                	li	a4,30
    800008fc:	86a6                	mv	a3,s1
    800008fe:	6605                	lui	a2,0x1
    80000900:	85ca                	mv	a1,s2
    80000902:	8556                	mv	a0,s5
    80000904:	00000097          	auipc	ra,0x0
    80000908:	c3e080e7          	jalr	-962(ra) # 80000542 <mappages>
    8000090c:	e915                	bnez	a0,80000940 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090e:	6785                	lui	a5,0x1
    80000910:	993e                	add	s2,s2,a5
    80000912:	fd4968e3          	bltu	s2,s4,800008e2 <uvmalloc+0x2c>
  return newsz;
    80000916:	8552                	mv	a0,s4
    80000918:	74a2                	ld	s1,40(sp)
    8000091a:	7902                	ld	s2,32(sp)
    8000091c:	a819                	j	80000932 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4a080e7          	jalr	-182(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
    8000092e:	74a2                	ld	s1,40(sp)
    80000930:	7902                	ld	s2,32(sp)
}
    80000932:	70e2                	ld	ra,56(sp)
    80000934:	7442                	ld	s0,48(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f1e080e7          	jalr	-226(ra) # 8000086e <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	74a2                	ld	s1,40(sp)
    8000095c:	7902                	ld	s2,32(sp)
    8000095e:	bfd1                	j	80000932 <uvmalloc+0x7c>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7f1                	j	80000932 <uvmalloc+0x7c>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	addi	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	addi	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a829                	j	8000099c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000986:	00c79513          	slli	a0,a5,0xc
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	fde080e7          	jalr	-34(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000992:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000996:	04a1                	addi	s1,s1,8
    80000998:	03248163          	beq	s1,s2,800009ba <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099e:	00f7f713          	andi	a4,a5,15
    800009a2:	ff3701e3          	beq	a4,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a6:	8b85                	andi	a5,a5,1
    800009a8:	d7fd                	beqz	a5,80000996 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009aa:	00007517          	auipc	a0,0x7
    800009ae:	73650513          	addi	a0,a0,1846 # 800080e0 <etext+0xe0>
    800009b2:	00005097          	auipc	ra,0x5
    800009b6:	7c8080e7          	jalr	1992(ra) # 8000617a <panic>
    }
  }
  kfree((void*)pagetable);
    800009ba:	8552                	mv	a0,s4
    800009bc:	fffff097          	auipc	ra,0xfffff
    800009c0:	660080e7          	jalr	1632(ra) # 8000001c <kfree>
}
    800009c4:	70a2                	ld	ra,40(sp)
    800009c6:	7402                	ld	s0,32(sp)
    800009c8:	64e2                	ld	s1,24(sp)
    800009ca:	6942                	ld	s2,16(sp)
    800009cc:	69a2                	ld	s3,8(sp)
    800009ce:	6a02                	ld	s4,0(sp)
    800009d0:	6145                	addi	sp,sp,48
    800009d2:	8082                	ret

00000000800009d4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d4:	1101                	addi	sp,sp,-32
    800009d6:	ec06                	sd	ra,24(sp)
    800009d8:	e822                	sd	s0,16(sp)
    800009da:	e426                	sd	s1,8(sp)
    800009dc:	1000                	addi	s0,sp,32
    800009de:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e0:	e999                	bnez	a1,800009f6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e2:	8526                	mv	a0,s1
    800009e4:	00000097          	auipc	ra,0x0
    800009e8:	f84080e7          	jalr	-124(ra) # 80000968 <freewalk>
}
    800009ec:	60e2                	ld	ra,24(sp)
    800009ee:	6442                	ld	s0,16(sp)
    800009f0:	64a2                	ld	s1,8(sp)
    800009f2:	6105                	addi	sp,sp,32
    800009f4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f6:	6785                	lui	a5,0x1
    800009f8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fa:	95be                	add	a1,a1,a5
    800009fc:	4685                	li	a3,1
    800009fe:	00c5d613          	srli	a2,a1,0xc
    80000a02:	4581                	li	a1,0
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	d04080e7          	jalr	-764(ra) # 80000708 <uvmunmap>
    80000a0c:	bfd9                	j	800009e2 <uvmfree+0xe>

0000000080000a0e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a0e:	c269                	beqz	a2,80000ad0 <uvmcopy+0xc2>
{
    80000a10:	715d                	addi	sp,sp,-80
    80000a12:	e486                	sd	ra,72(sp)
    80000a14:	e0a2                	sd	s0,64(sp)
    80000a16:	fc26                	sd	s1,56(sp)
    80000a18:	f84a                	sd	s2,48(sp)
    80000a1a:	f44e                	sd	s3,40(sp)
    80000a1c:	f052                	sd	s4,32(sp)
    80000a1e:	ec56                	sd	s5,24(sp)
    80000a20:	e85a                	sd	s6,16(sp)
    80000a22:	e45e                	sd	s7,8(sp)
    80000a24:	0880                	addi	s0,sp,80
    80000a26:	8aaa                	mv	s5,a0
    80000a28:	8b2e                	mv	s6,a1
    80000a2a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a2c:	4481                	li	s1,0
    80000a2e:	a829                	j	80000a48 <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a30:	00007517          	auipc	a0,0x7
    80000a34:	6c050513          	addi	a0,a0,1728 # 800080f0 <etext+0xf0>
    80000a38:	00005097          	auipc	ra,0x5
    80000a3c:	742080e7          	jalr	1858(ra) # 8000617a <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a40:	6785                	lui	a5,0x1
    80000a42:	94be                	add	s1,s1,a5
    80000a44:	0944f463          	bgeu	s1,s4,80000acc <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a48:	4601                	li	a2,0
    80000a4a:	85a6                	mv	a1,s1
    80000a4c:	8556                	mv	a0,s5
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	a0c080e7          	jalr	-1524(ra) # 8000045a <walk>
    80000a56:	dd69                	beqz	a0,80000a30 <uvmcopy+0x22>
    if((*pte & PTE_V) == 0)
    80000a58:	6118                	ld	a4,0(a0)
    80000a5a:	00177793          	andi	a5,a4,1
    80000a5e:	d3ed                	beqz	a5,80000a40 <uvmcopy+0x32>
	    continue;
      //panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a60:	00a75593          	srli	a1,a4,0xa
    80000a64:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a68:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a6c:	fffff097          	auipc	ra,0xfffff
    80000a70:	6ae080e7          	jalr	1710(ra) # 8000011a <kalloc>
    80000a74:	89aa                	mv	s3,a0
    80000a76:	c515                	beqz	a0,80000aa2 <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a78:	6605                	lui	a2,0x1
    80000a7a:	85de                	mv	a1,s7
    80000a7c:	fffff097          	auipc	ra,0xfffff
    80000a80:	75a080e7          	jalr	1882(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a84:	874a                	mv	a4,s2
    80000a86:	86ce                	mv	a3,s3
    80000a88:	6605                	lui	a2,0x1
    80000a8a:	85a6                	mv	a1,s1
    80000a8c:	855a                	mv	a0,s6
    80000a8e:	00000097          	auipc	ra,0x0
    80000a92:	ab4080e7          	jalr	-1356(ra) # 80000542 <mappages>
    80000a96:	d54d                	beqz	a0,80000a40 <uvmcopy+0x32>
      kfree(mem);
    80000a98:	854e                	mv	a0,s3
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	582080e7          	jalr	1410(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa2:	4685                	li	a3,1
    80000aa4:	00c4d613          	srli	a2,s1,0xc
    80000aa8:	4581                	li	a1,0
    80000aaa:	855a                	mv	a0,s6
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	c5c080e7          	jalr	-932(ra) # 80000708 <uvmunmap>
  return -1;
    80000ab4:	557d                	li	a0,-1
}
    80000ab6:	60a6                	ld	ra,72(sp)
    80000ab8:	6406                	ld	s0,64(sp)
    80000aba:	74e2                	ld	s1,56(sp)
    80000abc:	7942                	ld	s2,48(sp)
    80000abe:	79a2                	ld	s3,40(sp)
    80000ac0:	7a02                	ld	s4,32(sp)
    80000ac2:	6ae2                	ld	s5,24(sp)
    80000ac4:	6b42                	ld	s6,16(sp)
    80000ac6:	6ba2                	ld	s7,8(sp)
    80000ac8:	6161                	addi	sp,sp,80
    80000aca:	8082                	ret
  return 0;
    80000acc:	4501                	li	a0,0
    80000ace:	b7e5                	j	80000ab6 <uvmcopy+0xa8>
    80000ad0:	4501                	li	a0,0
}
    80000ad2:	8082                	ret

0000000080000ad4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad4:	1141                	addi	sp,sp,-16
    80000ad6:	e406                	sd	ra,8(sp)
    80000ad8:	e022                	sd	s0,0(sp)
    80000ada:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000adc:	4601                	li	a2,0
    80000ade:	00000097          	auipc	ra,0x0
    80000ae2:	97c080e7          	jalr	-1668(ra) # 8000045a <walk>
  if(pte == 0)
    80000ae6:	c901                	beqz	a0,80000af6 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ae8:	611c                	ld	a5,0(a0)
    80000aea:	9bbd                	andi	a5,a5,-17
    80000aec:	e11c                	sd	a5,0(a0)
}
    80000aee:	60a2                	ld	ra,8(sp)
    80000af0:	6402                	ld	s0,0(sp)
    80000af2:	0141                	addi	sp,sp,16
    80000af4:	8082                	ret
    panic("uvmclear");
    80000af6:	00007517          	auipc	a0,0x7
    80000afa:	61a50513          	addi	a0,a0,1562 # 80008110 <etext+0x110>
    80000afe:	00005097          	auipc	ra,0x5
    80000b02:	67c080e7          	jalr	1660(ra) # 8000617a <panic>

0000000080000b06 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b06:	c6bd                	beqz	a3,80000b74 <copyout+0x6e>
{
    80000b08:	715d                	addi	sp,sp,-80
    80000b0a:	e486                	sd	ra,72(sp)
    80000b0c:	e0a2                	sd	s0,64(sp)
    80000b0e:	fc26                	sd	s1,56(sp)
    80000b10:	f84a                	sd	s2,48(sp)
    80000b12:	f44e                	sd	s3,40(sp)
    80000b14:	f052                	sd	s4,32(sp)
    80000b16:	ec56                	sd	s5,24(sp)
    80000b18:	e85a                	sd	s6,16(sp)
    80000b1a:	e45e                	sd	s7,8(sp)
    80000b1c:	e062                	sd	s8,0(sp)
    80000b1e:	0880                	addi	s0,sp,80
    80000b20:	8b2a                	mv	s6,a0
    80000b22:	8c2e                	mv	s8,a1
    80000b24:	8a32                	mv	s4,a2
    80000b26:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b28:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2a:	6a85                	lui	s5,0x1
    80000b2c:	a015                	j	80000b50 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b2e:	9562                	add	a0,a0,s8
    80000b30:	0004861b          	sext.w	a2,s1
    80000b34:	85d2                	mv	a1,s4
    80000b36:	41250533          	sub	a0,a0,s2
    80000b3a:	fffff097          	auipc	ra,0xfffff
    80000b3e:	69c080e7          	jalr	1692(ra) # 800001d6 <memmove>

    len -= n;
    80000b42:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b46:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b48:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b4c:	02098263          	beqz	s3,80000b70 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b50:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b54:	85ca                	mv	a1,s2
    80000b56:	855a                	mv	a0,s6
    80000b58:	00000097          	auipc	ra,0x0
    80000b5c:	9a8080e7          	jalr	-1624(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b60:	cd01                	beqz	a0,80000b78 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b62:	418904b3          	sub	s1,s2,s8
    80000b66:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b68:	fc99f3e3          	bgeu	s3,s1,80000b2e <copyout+0x28>
    80000b6c:	84ce                	mv	s1,s3
    80000b6e:	b7c1                	j	80000b2e <copyout+0x28>
  }
  return 0;
    80000b70:	4501                	li	a0,0
    80000b72:	a021                	j	80000b7a <copyout+0x74>
    80000b74:	4501                	li	a0,0
}
    80000b76:	8082                	ret
      return -1;
    80000b78:	557d                	li	a0,-1
}
    80000b7a:	60a6                	ld	ra,72(sp)
    80000b7c:	6406                	ld	s0,64(sp)
    80000b7e:	74e2                	ld	s1,56(sp)
    80000b80:	7942                	ld	s2,48(sp)
    80000b82:	79a2                	ld	s3,40(sp)
    80000b84:	7a02                	ld	s4,32(sp)
    80000b86:	6ae2                	ld	s5,24(sp)
    80000b88:	6b42                	ld	s6,16(sp)
    80000b8a:	6ba2                	ld	s7,8(sp)
    80000b8c:	6c02                	ld	s8,0(sp)
    80000b8e:	6161                	addi	sp,sp,80
    80000b90:	8082                	ret

0000000080000b92 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b92:	caa5                	beqz	a3,80000c02 <copyin+0x70>
{
    80000b94:	715d                	addi	sp,sp,-80
    80000b96:	e486                	sd	ra,72(sp)
    80000b98:	e0a2                	sd	s0,64(sp)
    80000b9a:	fc26                	sd	s1,56(sp)
    80000b9c:	f84a                	sd	s2,48(sp)
    80000b9e:	f44e                	sd	s3,40(sp)
    80000ba0:	f052                	sd	s4,32(sp)
    80000ba2:	ec56                	sd	s5,24(sp)
    80000ba4:	e85a                	sd	s6,16(sp)
    80000ba6:	e45e                	sd	s7,8(sp)
    80000ba8:	e062                	sd	s8,0(sp)
    80000baa:	0880                	addi	s0,sp,80
    80000bac:	8b2a                	mv	s6,a0
    80000bae:	8a2e                	mv	s4,a1
    80000bb0:	8c32                	mv	s8,a2
    80000bb2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb6:	6a85                	lui	s5,0x1
    80000bb8:	a01d                	j	80000bde <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bba:	018505b3          	add	a1,a0,s8
    80000bbe:	0004861b          	sext.w	a2,s1
    80000bc2:	412585b3          	sub	a1,a1,s2
    80000bc6:	8552                	mv	a0,s4
    80000bc8:	fffff097          	auipc	ra,0xfffff
    80000bcc:	60e080e7          	jalr	1550(ra) # 800001d6 <memmove>

    len -= n;
    80000bd0:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd4:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bda:	02098263          	beqz	s3,80000bfe <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bde:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be2:	85ca                	mv	a1,s2
    80000be4:	855a                	mv	a0,s6
    80000be6:	00000097          	auipc	ra,0x0
    80000bea:	91a080e7          	jalr	-1766(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000bee:	cd01                	beqz	a0,80000c06 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf0:	418904b3          	sub	s1,s2,s8
    80000bf4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf6:	fc99f2e3          	bgeu	s3,s1,80000bba <copyin+0x28>
    80000bfa:	84ce                	mv	s1,s3
    80000bfc:	bf7d                	j	80000bba <copyin+0x28>
  }
  return 0;
    80000bfe:	4501                	li	a0,0
    80000c00:	a021                	j	80000c08 <copyin+0x76>
    80000c02:	4501                	li	a0,0
}
    80000c04:	8082                	ret
      return -1;
    80000c06:	557d                	li	a0,-1
}
    80000c08:	60a6                	ld	ra,72(sp)
    80000c0a:	6406                	ld	s0,64(sp)
    80000c0c:	74e2                	ld	s1,56(sp)
    80000c0e:	7942                	ld	s2,48(sp)
    80000c10:	79a2                	ld	s3,40(sp)
    80000c12:	7a02                	ld	s4,32(sp)
    80000c14:	6ae2                	ld	s5,24(sp)
    80000c16:	6b42                	ld	s6,16(sp)
    80000c18:	6ba2                	ld	s7,8(sp)
    80000c1a:	6c02                	ld	s8,0(sp)
    80000c1c:	6161                	addi	sp,sp,80
    80000c1e:	8082                	ret

0000000080000c20 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c20:	cacd                	beqz	a3,80000cd2 <copyinstr+0xb2>
{
    80000c22:	715d                	addi	sp,sp,-80
    80000c24:	e486                	sd	ra,72(sp)
    80000c26:	e0a2                	sd	s0,64(sp)
    80000c28:	fc26                	sd	s1,56(sp)
    80000c2a:	f84a                	sd	s2,48(sp)
    80000c2c:	f44e                	sd	s3,40(sp)
    80000c2e:	f052                	sd	s4,32(sp)
    80000c30:	ec56                	sd	s5,24(sp)
    80000c32:	e85a                	sd	s6,16(sp)
    80000c34:	e45e                	sd	s7,8(sp)
    80000c36:	0880                	addi	s0,sp,80
    80000c38:	8a2a                	mv	s4,a0
    80000c3a:	8b2e                	mv	s6,a1
    80000c3c:	8bb2                	mv	s7,a2
    80000c3e:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c40:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c42:	6985                	lui	s3,0x1
    80000c44:	a825                	j	80000c7c <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c46:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4c:	37fd                	addiw	a5,a5,-1
    80000c4e:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c52:	60a6                	ld	ra,72(sp)
    80000c54:	6406                	ld	s0,64(sp)
    80000c56:	74e2                	ld	s1,56(sp)
    80000c58:	7942                	ld	s2,48(sp)
    80000c5a:	79a2                	ld	s3,40(sp)
    80000c5c:	7a02                	ld	s4,32(sp)
    80000c5e:	6ae2                	ld	s5,24(sp)
    80000c60:	6b42                	ld	s6,16(sp)
    80000c62:	6ba2                	ld	s7,8(sp)
    80000c64:	6161                	addi	sp,sp,80
    80000c66:	8082                	ret
    80000c68:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000c6c:	9742                	add	a4,a4,a6
      --max;
    80000c6e:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000c72:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000c76:	04e58663          	beq	a1,a4,80000cc2 <copyinstr+0xa2>
{
    80000c7a:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000c7c:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c80:	85a6                	mv	a1,s1
    80000c82:	8552                	mv	a0,s4
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	87c080e7          	jalr	-1924(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c8c:	cd0d                	beqz	a0,80000cc6 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000c8e:	417486b3          	sub	a3,s1,s7
    80000c92:	96ce                	add	a3,a3,s3
    if(n > max)
    80000c94:	00d97363          	bgeu	s2,a3,80000c9a <copyinstr+0x7a>
    80000c98:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9a:	955e                	add	a0,a0,s7
    80000c9c:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000c9e:	c695                	beqz	a3,80000cca <copyinstr+0xaa>
    80000ca0:	87da                	mv	a5,s6
    80000ca2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ca8:	96da                	add	a3,a3,s6
    80000caa:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cac:	00f60733          	add	a4,a2,a5
    80000cb0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd6ba0>
    80000cb4:	db49                	beqz	a4,80000c46 <copyinstr+0x26>
        *dst = *p;
    80000cb6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cba:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cbc:	fed797e3          	bne	a5,a3,80000caa <copyinstr+0x8a>
    80000cc0:	b765                	j	80000c68 <copyinstr+0x48>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b761                	j	80000c4c <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b769                	j	80000c52 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000cca:	6b85                	lui	s7,0x1
    80000ccc:	9ba6                	add	s7,s7,s1
    80000cce:	87da                	mv	a5,s6
    80000cd0:	b76d                	j	80000c7a <copyinstr+0x5a>
  int got_null = 0;
    80000cd2:	4781                	li	a5,0
  if(got_null){
    80000cd4:	37fd                	addiw	a5,a5,-1
    80000cd6:	0007851b          	sext.w	a0,a5
}
    80000cda:	8082                	ret

0000000080000cdc <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cdc:	7139                	addi	sp,sp,-64
    80000cde:	fc06                	sd	ra,56(sp)
    80000ce0:	f822                	sd	s0,48(sp)
    80000ce2:	f426                	sd	s1,40(sp)
    80000ce4:	f04a                	sd	s2,32(sp)
    80000ce6:	ec4e                	sd	s3,24(sp)
    80000ce8:	e852                	sd	s4,16(sp)
    80000cea:	e456                	sd	s5,8(sp)
    80000cec:	e05a                	sd	s6,0(sp)
    80000cee:	0080                	addi	s0,sp,64
    80000cf0:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	00008497          	auipc	s1,0x8
    80000cf6:	78e48493          	addi	s1,s1,1934 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfa:	8b26                	mv	s6,s1
    80000cfc:	013ef937          	lui	s2,0x13ef
    80000d00:	36990913          	addi	s2,s2,873 # 13ef369 <_entry-0x7ec10c97>
    80000d04:	093a                	slli	s2,s2,0xe
    80000d06:	ac190913          	addi	s2,s2,-1343
    80000d0a:	0932                	slli	s2,s2,0xc
    80000d0c:	0c990913          	addi	s2,s2,201
    80000d10:	0932                	slli	s2,s2,0xc
    80000d12:	71590913          	addi	s2,s2,1813
    80000d16:	040009b7          	lui	s3,0x4000
    80000d1a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d1c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d1e:	00010a97          	auipc	s5,0x10
    80000d22:	162a8a93          	addi	s5,s5,354 # 80010e80 <tickslock>
    char *pa = kalloc();
    80000d26:	fffff097          	auipc	ra,0xfffff
    80000d2a:	3f4080e7          	jalr	1012(ra) # 8000011a <kalloc>
    80000d2e:	862a                	mv	a2,a0
    if(pa == 0)
    80000d30:	c121                	beqz	a0,80000d70 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d32:	416485b3          	sub	a1,s1,s6
    80000d36:	858d                	srai	a1,a1,0x3
    80000d38:	032585b3          	mul	a1,a1,s2
    80000d3c:	2585                	addiw	a1,a1,1
    80000d3e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d42:	4719                	li	a4,6
    80000d44:	6685                	lui	a3,0x1
    80000d46:	40b985b3          	sub	a1,s3,a1
    80000d4a:	8552                	mv	a0,s4
    80000d4c:	00000097          	auipc	ra,0x0
    80000d50:	896080e7          	jalr	-1898(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d54:	1e848493          	addi	s1,s1,488
    80000d58:	fd5497e3          	bne	s1,s5,80000d26 <proc_mapstacks+0x4a>
  }
}
    80000d5c:	70e2                	ld	ra,56(sp)
    80000d5e:	7442                	ld	s0,48(sp)
    80000d60:	74a2                	ld	s1,40(sp)
    80000d62:	7902                	ld	s2,32(sp)
    80000d64:	69e2                	ld	s3,24(sp)
    80000d66:	6a42                	ld	s4,16(sp)
    80000d68:	6aa2                	ld	s5,8(sp)
    80000d6a:	6b02                	ld	s6,0(sp)
    80000d6c:	6121                	addi	sp,sp,64
    80000d6e:	8082                	ret
      panic("kalloc");
    80000d70:	00007517          	auipc	a0,0x7
    80000d74:	3b050513          	addi	a0,a0,944 # 80008120 <etext+0x120>
    80000d78:	00005097          	auipc	ra,0x5
    80000d7c:	402080e7          	jalr	1026(ra) # 8000617a <panic>

0000000080000d80 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d80:	7139                	addi	sp,sp,-64
    80000d82:	fc06                	sd	ra,56(sp)
    80000d84:	f822                	sd	s0,48(sp)
    80000d86:	f426                	sd	s1,40(sp)
    80000d88:	f04a                	sd	s2,32(sp)
    80000d8a:	ec4e                	sd	s3,24(sp)
    80000d8c:	e852                	sd	s4,16(sp)
    80000d8e:	e456                	sd	s5,8(sp)
    80000d90:	e05a                	sd	s6,0(sp)
    80000d92:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d94:	00007597          	auipc	a1,0x7
    80000d98:	39458593          	addi	a1,a1,916 # 80008128 <etext+0x128>
    80000d9c:	00008517          	auipc	a0,0x8
    80000da0:	2b450513          	addi	a0,a0,692 # 80009050 <pid_lock>
    80000da4:	00006097          	auipc	ra,0x6
    80000da8:	8c0080e7          	jalr	-1856(ra) # 80006664 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dac:	00007597          	auipc	a1,0x7
    80000db0:	38458593          	addi	a1,a1,900 # 80008130 <etext+0x130>
    80000db4:	00008517          	auipc	a0,0x8
    80000db8:	2b450513          	addi	a0,a0,692 # 80009068 <wait_lock>
    80000dbc:	00006097          	auipc	ra,0x6
    80000dc0:	8a8080e7          	jalr	-1880(ra) # 80006664 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dc4:	00008497          	auipc	s1,0x8
    80000dc8:	6bc48493          	addi	s1,s1,1724 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dcc:	00007b17          	auipc	s6,0x7
    80000dd0:	374b0b13          	addi	s6,s6,884 # 80008140 <etext+0x140>
      p->kstack = KSTACK((int) (p - proc));
    80000dd4:	8aa6                	mv	s5,s1
    80000dd6:	013ef937          	lui	s2,0x13ef
    80000dda:	36990913          	addi	s2,s2,873 # 13ef369 <_entry-0x7ec10c97>
    80000dde:	093a                	slli	s2,s2,0xe
    80000de0:	ac190913          	addi	s2,s2,-1343
    80000de4:	0932                	slli	s2,s2,0xc
    80000de6:	0c990913          	addi	s2,s2,201
    80000dea:	0932                	slli	s2,s2,0xc
    80000dec:	71590913          	addi	s2,s2,1813
    80000df0:	040009b7          	lui	s3,0x4000
    80000df4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000df6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df8:	00010a17          	auipc	s4,0x10
    80000dfc:	088a0a13          	addi	s4,s4,136 # 80010e80 <tickslock>
      initlock(&p->lock, "proc");
    80000e00:	85da                	mv	a1,s6
    80000e02:	8526                	mv	a0,s1
    80000e04:	00006097          	auipc	ra,0x6
    80000e08:	860080e7          	jalr	-1952(ra) # 80006664 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e0c:	415487b3          	sub	a5,s1,s5
    80000e10:	878d                	srai	a5,a5,0x3
    80000e12:	032787b3          	mul	a5,a5,s2
    80000e16:	2785                	addiw	a5,a5,1
    80000e18:	00d7979b          	slliw	a5,a5,0xd
    80000e1c:	40f987b3          	sub	a5,s3,a5
    80000e20:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e22:	1e848493          	addi	s1,s1,488
    80000e26:	fd449de3          	bne	s1,s4,80000e00 <procinit+0x80>
  }
}
    80000e2a:	70e2                	ld	ra,56(sp)
    80000e2c:	7442                	ld	s0,48(sp)
    80000e2e:	74a2                	ld	s1,40(sp)
    80000e30:	7902                	ld	s2,32(sp)
    80000e32:	69e2                	ld	s3,24(sp)
    80000e34:	6a42                	ld	s4,16(sp)
    80000e36:	6aa2                	ld	s5,8(sp)
    80000e38:	6b02                	ld	s6,0(sp)
    80000e3a:	6121                	addi	sp,sp,64
    80000e3c:	8082                	ret

0000000080000e3e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e3e:	1141                	addi	sp,sp,-16
    80000e40:	e422                	sd	s0,8(sp)
    80000e42:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e44:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e46:	2501                	sext.w	a0,a0
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e422                	sd	s0,8(sp)
    80000e52:	0800                	addi	s0,sp,16
    80000e54:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e56:	2781                	sext.w	a5,a5
    80000e58:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e5a:	00008517          	auipc	a0,0x8
    80000e5e:	22650513          	addi	a0,a0,550 # 80009080 <cpus>
    80000e62:	953e                	add	a0,a0,a5
    80000e64:	6422                	ld	s0,8(sp)
    80000e66:	0141                	addi	sp,sp,16
    80000e68:	8082                	ret

0000000080000e6a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e6a:	1101                	addi	sp,sp,-32
    80000e6c:	ec06                	sd	ra,24(sp)
    80000e6e:	e822                	sd	s0,16(sp)
    80000e70:	e426                	sd	s1,8(sp)
    80000e72:	1000                	addi	s0,sp,32
  push_off();
    80000e74:	00006097          	auipc	ra,0x6
    80000e78:	834080e7          	jalr	-1996(ra) # 800066a8 <push_off>
    80000e7c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e7e:	2781                	sext.w	a5,a5
    80000e80:	079e                	slli	a5,a5,0x7
    80000e82:	00008717          	auipc	a4,0x8
    80000e86:	1ce70713          	addi	a4,a4,462 # 80009050 <pid_lock>
    80000e8a:	97ba                	add	a5,a5,a4
    80000e8c:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e8e:	00006097          	auipc	ra,0x6
    80000e92:	8ba080e7          	jalr	-1862(ra) # 80006748 <pop_off>
  return p;
}
    80000e96:	8526                	mv	a0,s1
    80000e98:	60e2                	ld	ra,24(sp)
    80000e9a:	6442                	ld	s0,16(sp)
    80000e9c:	64a2                	ld	s1,8(sp)
    80000e9e:	6105                	addi	sp,sp,32
    80000ea0:	8082                	ret

0000000080000ea2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ea2:	1141                	addi	sp,sp,-16
    80000ea4:	e406                	sd	ra,8(sp)
    80000ea6:	e022                	sd	s0,0(sp)
    80000ea8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eaa:	00000097          	auipc	ra,0x0
    80000eae:	fc0080e7          	jalr	-64(ra) # 80000e6a <myproc>
    80000eb2:	00006097          	auipc	ra,0x6
    80000eb6:	8f6080e7          	jalr	-1802(ra) # 800067a8 <release>

  if (first) {
    80000eba:	00008797          	auipc	a5,0x8
    80000ebe:	9467a783          	lw	a5,-1722(a5) # 80008800 <first.1>
    80000ec2:	eb89                	bnez	a5,80000ed4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ec4:	00001097          	auipc	ra,0x1
    80000ec8:	d10080e7          	jalr	-752(ra) # 80001bd4 <usertrapret>
}
    80000ecc:	60a2                	ld	ra,8(sp)
    80000ece:	6402                	ld	s0,0(sp)
    80000ed0:	0141                	addi	sp,sp,16
    80000ed2:	8082                	ret
    first = 0;
    80000ed4:	00008797          	auipc	a5,0x8
    80000ed8:	9207a623          	sw	zero,-1748(a5) # 80008800 <first.1>
    fsinit(ROOTDEV);
    80000edc:	4505                	li	a0,1
    80000ede:	00002097          	auipc	ra,0x2
    80000ee2:	b70080e7          	jalr	-1168(ra) # 80002a4e <fsinit>
    80000ee6:	bff9                	j	80000ec4 <forkret+0x22>

0000000080000ee8 <allocpid>:
allocpid() {
    80000ee8:	1101                	addi	sp,sp,-32
    80000eea:	ec06                	sd	ra,24(sp)
    80000eec:	e822                	sd	s0,16(sp)
    80000eee:	e426                	sd	s1,8(sp)
    80000ef0:	e04a                	sd	s2,0(sp)
    80000ef2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ef4:	00008917          	auipc	s2,0x8
    80000ef8:	15c90913          	addi	s2,s2,348 # 80009050 <pid_lock>
    80000efc:	854a                	mv	a0,s2
    80000efe:	00005097          	auipc	ra,0x5
    80000f02:	7f6080e7          	jalr	2038(ra) # 800066f4 <acquire>
  pid = nextpid;
    80000f06:	00008797          	auipc	a5,0x8
    80000f0a:	8fe78793          	addi	a5,a5,-1794 # 80008804 <nextpid>
    80000f0e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f10:	0014871b          	addiw	a4,s1,1
    80000f14:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f16:	854a                	mv	a0,s2
    80000f18:	00006097          	auipc	ra,0x6
    80000f1c:	890080e7          	jalr	-1904(ra) # 800067a8 <release>
}
    80000f20:	8526                	mv	a0,s1
    80000f22:	60e2                	ld	ra,24(sp)
    80000f24:	6442                	ld	s0,16(sp)
    80000f26:	64a2                	ld	s1,8(sp)
    80000f28:	6902                	ld	s2,0(sp)
    80000f2a:	6105                	addi	sp,sp,32
    80000f2c:	8082                	ret

0000000080000f2e <proc_pagetable>:
{
    80000f2e:	1101                	addi	sp,sp,-32
    80000f30:	ec06                	sd	ra,24(sp)
    80000f32:	e822                	sd	s0,16(sp)
    80000f34:	e426                	sd	s1,8(sp)
    80000f36:	e04a                	sd	s2,0(sp)
    80000f38:	1000                	addi	s0,sp,32
    80000f3a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f3c:	00000097          	auipc	ra,0x0
    80000f40:	892080e7          	jalr	-1902(ra) # 800007ce <uvmcreate>
    80000f44:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f46:	c121                	beqz	a0,80000f86 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f48:	4729                	li	a4,10
    80000f4a:	00006697          	auipc	a3,0x6
    80000f4e:	0b668693          	addi	a3,a3,182 # 80007000 <_trampoline>
    80000f52:	6605                	lui	a2,0x1
    80000f54:	040005b7          	lui	a1,0x4000
    80000f58:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f5a:	05b2                	slli	a1,a1,0xc
    80000f5c:	fffff097          	auipc	ra,0xfffff
    80000f60:	5e6080e7          	jalr	1510(ra) # 80000542 <mappages>
    80000f64:	02054863          	bltz	a0,80000f94 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f68:	4719                	li	a4,6
    80000f6a:	05893683          	ld	a3,88(s2)
    80000f6e:	6605                	lui	a2,0x1
    80000f70:	020005b7          	lui	a1,0x2000
    80000f74:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f76:	05b6                	slli	a1,a1,0xd
    80000f78:	8526                	mv	a0,s1
    80000f7a:	fffff097          	auipc	ra,0xfffff
    80000f7e:	5c8080e7          	jalr	1480(ra) # 80000542 <mappages>
    80000f82:	02054163          	bltz	a0,80000fa4 <proc_pagetable+0x76>
}
    80000f86:	8526                	mv	a0,s1
    80000f88:	60e2                	ld	ra,24(sp)
    80000f8a:	6442                	ld	s0,16(sp)
    80000f8c:	64a2                	ld	s1,8(sp)
    80000f8e:	6902                	ld	s2,0(sp)
    80000f90:	6105                	addi	sp,sp,32
    80000f92:	8082                	ret
    uvmfree(pagetable, 0);
    80000f94:	4581                	li	a1,0
    80000f96:	8526                	mv	a0,s1
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	a3c080e7          	jalr	-1476(ra) # 800009d4 <uvmfree>
    return 0;
    80000fa0:	4481                	li	s1,0
    80000fa2:	b7d5                	j	80000f86 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa4:	4681                	li	a3,0
    80000fa6:	4605                	li	a2,1
    80000fa8:	040005b7          	lui	a1,0x4000
    80000fac:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fae:	05b2                	slli	a1,a1,0xc
    80000fb0:	8526                	mv	a0,s1
    80000fb2:	fffff097          	auipc	ra,0xfffff
    80000fb6:	756080e7          	jalr	1878(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fba:	4581                	li	a1,0
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	00000097          	auipc	ra,0x0
    80000fc2:	a16080e7          	jalr	-1514(ra) # 800009d4 <uvmfree>
    return 0;
    80000fc6:	4481                	li	s1,0
    80000fc8:	bf7d                	j	80000f86 <proc_pagetable+0x58>

0000000080000fca <proc_freepagetable>:
{
    80000fca:	1101                	addi	sp,sp,-32
    80000fcc:	ec06                	sd	ra,24(sp)
    80000fce:	e822                	sd	s0,16(sp)
    80000fd0:	e426                	sd	s1,8(sp)
    80000fd2:	e04a                	sd	s2,0(sp)
    80000fd4:	1000                	addi	s0,sp,32
    80000fd6:	84aa                	mv	s1,a0
    80000fd8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fda:	4681                	li	a3,0
    80000fdc:	4605                	li	a2,1
    80000fde:	040005b7          	lui	a1,0x4000
    80000fe2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fe4:	05b2                	slli	a1,a1,0xc
    80000fe6:	fffff097          	auipc	ra,0xfffff
    80000fea:	722080e7          	jalr	1826(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fee:	4681                	li	a3,0
    80000ff0:	4605                	li	a2,1
    80000ff2:	020005b7          	lui	a1,0x2000
    80000ff6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ff8:	05b6                	slli	a1,a1,0xd
    80000ffa:	8526                	mv	a0,s1
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	70c080e7          	jalr	1804(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80001004:	85ca                	mv	a1,s2
    80001006:	8526                	mv	a0,s1
    80001008:	00000097          	auipc	ra,0x0
    8000100c:	9cc080e7          	jalr	-1588(ra) # 800009d4 <uvmfree>
}
    80001010:	60e2                	ld	ra,24(sp)
    80001012:	6442                	ld	s0,16(sp)
    80001014:	64a2                	ld	s1,8(sp)
    80001016:	6902                	ld	s2,0(sp)
    80001018:	6105                	addi	sp,sp,32
    8000101a:	8082                	ret

000000008000101c <freeproc>:
{
    8000101c:	1101                	addi	sp,sp,-32
    8000101e:	ec06                	sd	ra,24(sp)
    80001020:	e822                	sd	s0,16(sp)
    80001022:	e426                	sd	s1,8(sp)
    80001024:	1000                	addi	s0,sp,32
    80001026:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001028:	6d28                	ld	a0,88(a0)
    8000102a:	c509                	beqz	a0,80001034 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000102c:	fffff097          	auipc	ra,0xfffff
    80001030:	ff0080e7          	jalr	-16(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001034:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001038:	68a8                	ld	a0,80(s1)
    8000103a:	c511                	beqz	a0,80001046 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000103c:	64ac                	ld	a1,72(s1)
    8000103e:	00000097          	auipc	ra,0x0
    80001042:	f8c080e7          	jalr	-116(ra) # 80000fca <proc_freepagetable>
  p->pagetable = 0;
    80001046:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000104a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000104e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001052:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001056:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000105a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000105e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001062:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001066:	0004ac23          	sw	zero,24(s1)
}
    8000106a:	60e2                	ld	ra,24(sp)
    8000106c:	6442                	ld	s0,16(sp)
    8000106e:	64a2                	ld	s1,8(sp)
    80001070:	6105                	addi	sp,sp,32
    80001072:	8082                	ret

0000000080001074 <allocproc>:
{
    80001074:	1101                	addi	sp,sp,-32
    80001076:	ec06                	sd	ra,24(sp)
    80001078:	e822                	sd	s0,16(sp)
    8000107a:	e426                	sd	s1,8(sp)
    8000107c:	e04a                	sd	s2,0(sp)
    8000107e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001080:	00008497          	auipc	s1,0x8
    80001084:	40048493          	addi	s1,s1,1024 # 80009480 <proc>
    80001088:	00010917          	auipc	s2,0x10
    8000108c:	df890913          	addi	s2,s2,-520 # 80010e80 <tickslock>
    acquire(&p->lock);
    80001090:	8526                	mv	a0,s1
    80001092:	00005097          	auipc	ra,0x5
    80001096:	662080e7          	jalr	1634(ra) # 800066f4 <acquire>
    if(p->state == UNUSED) {
    8000109a:	4c9c                	lw	a5,24(s1)
    8000109c:	cf81                	beqz	a5,800010b4 <allocproc+0x40>
      release(&p->lock);
    8000109e:	8526                	mv	a0,s1
    800010a0:	00005097          	auipc	ra,0x5
    800010a4:	708080e7          	jalr	1800(ra) # 800067a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a8:	1e848493          	addi	s1,s1,488
    800010ac:	ff2492e3          	bne	s1,s2,80001090 <allocproc+0x1c>
  return 0;
    800010b0:	4481                	li	s1,0
    800010b2:	a889                	j	80001104 <allocproc+0x90>
  p->pid = allocpid();
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	e34080e7          	jalr	-460(ra) # 80000ee8 <allocpid>
    800010bc:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010be:	4785                	li	a5,1
    800010c0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010c2:	fffff097          	auipc	ra,0xfffff
    800010c6:	058080e7          	jalr	88(ra) # 8000011a <kalloc>
    800010ca:	892a                	mv	s2,a0
    800010cc:	eca8                	sd	a0,88(s1)
    800010ce:	c131                	beqz	a0,80001112 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010d0:	8526                	mv	a0,s1
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	e5c080e7          	jalr	-420(ra) # 80000f2e <proc_pagetable>
    800010da:	892a                	mv	s2,a0
    800010dc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010de:	c531                	beqz	a0,8000112a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010e0:	07000613          	li	a2,112
    800010e4:	4581                	li	a1,0
    800010e6:	06048513          	addi	a0,s1,96
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	090080e7          	jalr	144(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010f2:	00000797          	auipc	a5,0x0
    800010f6:	db078793          	addi	a5,a5,-592 # 80000ea2 <forkret>
    800010fa:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010fc:	60bc                	ld	a5,64(s1)
    800010fe:	6705                	lui	a4,0x1
    80001100:	97ba                	add	a5,a5,a4
    80001102:	f4bc                	sd	a5,104(s1)
}
    80001104:	8526                	mv	a0,s1
    80001106:	60e2                	ld	ra,24(sp)
    80001108:	6442                	ld	s0,16(sp)
    8000110a:	64a2                	ld	s1,8(sp)
    8000110c:	6902                	ld	s2,0(sp)
    8000110e:	6105                	addi	sp,sp,32
    80001110:	8082                	ret
    freeproc(p);
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	f08080e7          	jalr	-248(ra) # 8000101c <freeproc>
    release(&p->lock);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00005097          	auipc	ra,0x5
    80001122:	68a080e7          	jalr	1674(ra) # 800067a8 <release>
    return 0;
    80001126:	84ca                	mv	s1,s2
    80001128:	bff1                	j	80001104 <allocproc+0x90>
    freeproc(p);
    8000112a:	8526                	mv	a0,s1
    8000112c:	00000097          	auipc	ra,0x0
    80001130:	ef0080e7          	jalr	-272(ra) # 8000101c <freeproc>
    release(&p->lock);
    80001134:	8526                	mv	a0,s1
    80001136:	00005097          	auipc	ra,0x5
    8000113a:	672080e7          	jalr	1650(ra) # 800067a8 <release>
    return 0;
    8000113e:	84ca                	mv	s1,s2
    80001140:	b7d1                	j	80001104 <allocproc+0x90>

0000000080001142 <userinit>:
{
    80001142:	1101                	addi	sp,sp,-32
    80001144:	ec06                	sd	ra,24(sp)
    80001146:	e822                	sd	s0,16(sp)
    80001148:	e426                	sd	s1,8(sp)
    8000114a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	f28080e7          	jalr	-216(ra) # 80001074 <allocproc>
    80001154:	84aa                	mv	s1,a0
  initproc = p;
    80001156:	00008797          	auipc	a5,0x8
    8000115a:	eaa7bd23          	sd	a0,-326(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000115e:	03400613          	li	a2,52
    80001162:	00007597          	auipc	a1,0x7
    80001166:	6ae58593          	addi	a1,a1,1710 # 80008810 <initcode>
    8000116a:	6928                	ld	a0,80(a0)
    8000116c:	fffff097          	auipc	ra,0xfffff
    80001170:	690080e7          	jalr	1680(ra) # 800007fc <uvminit>
  p->sz = PGSIZE;
    80001174:	6785                	lui	a5,0x1
    80001176:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001178:	6cb8                	ld	a4,88(s1)
    8000117a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000117e:	6cb8                	ld	a4,88(s1)
    80001180:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001182:	4641                	li	a2,16
    80001184:	00007597          	auipc	a1,0x7
    80001188:	fc458593          	addi	a1,a1,-60 # 80008148 <etext+0x148>
    8000118c:	15848513          	addi	a0,s1,344
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	12c080e7          	jalr	300(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    80001198:	00007517          	auipc	a0,0x7
    8000119c:	fc050513          	addi	a0,a0,-64 # 80008158 <etext+0x158>
    800011a0:	00002097          	auipc	ra,0x2
    800011a4:	2f4080e7          	jalr	756(ra) # 80003494 <namei>
    800011a8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011ac:	478d                	li	a5,3
    800011ae:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011b0:	8526                	mv	a0,s1
    800011b2:	00005097          	auipc	ra,0x5
    800011b6:	5f6080e7          	jalr	1526(ra) # 800067a8 <release>
}
    800011ba:	60e2                	ld	ra,24(sp)
    800011bc:	6442                	ld	s0,16(sp)
    800011be:	64a2                	ld	s1,8(sp)
    800011c0:	6105                	addi	sp,sp,32
    800011c2:	8082                	ret

00000000800011c4 <growproc>:
{
    800011c4:	1101                	addi	sp,sp,-32
    800011c6:	ec06                	sd	ra,24(sp)
    800011c8:	e822                	sd	s0,16(sp)
    800011ca:	e426                	sd	s1,8(sp)
    800011cc:	e04a                	sd	s2,0(sp)
    800011ce:	1000                	addi	s0,sp,32
    800011d0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011d2:	00000097          	auipc	ra,0x0
    800011d6:	c98080e7          	jalr	-872(ra) # 80000e6a <myproc>
    800011da:	892a                	mv	s2,a0
  sz = p->sz;
    800011dc:	652c                	ld	a1,72(a0)
    800011de:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011e2:	00904f63          	bgtz	s1,80001200 <growproc+0x3c>
  } else if(n < 0){
    800011e6:	0204cd63          	bltz	s1,80001220 <growproc+0x5c>
  p->sz = sz;
    800011ea:	1782                	slli	a5,a5,0x20
    800011ec:	9381                	srli	a5,a5,0x20
    800011ee:	04f93423          	sd	a5,72(s2)
  return 0;
    800011f2:	4501                	li	a0,0
}
    800011f4:	60e2                	ld	ra,24(sp)
    800011f6:	6442                	ld	s0,16(sp)
    800011f8:	64a2                	ld	s1,8(sp)
    800011fa:	6902                	ld	s2,0(sp)
    800011fc:	6105                	addi	sp,sp,32
    800011fe:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001200:	00f4863b          	addw	a2,s1,a5
    80001204:	1602                	slli	a2,a2,0x20
    80001206:	9201                	srli	a2,a2,0x20
    80001208:	1582                	slli	a1,a1,0x20
    8000120a:	9181                	srli	a1,a1,0x20
    8000120c:	6928                	ld	a0,80(a0)
    8000120e:	fffff097          	auipc	ra,0xfffff
    80001212:	6a8080e7          	jalr	1704(ra) # 800008b6 <uvmalloc>
    80001216:	0005079b          	sext.w	a5,a0
    8000121a:	fbe1                	bnez	a5,800011ea <growproc+0x26>
      return -1;
    8000121c:	557d                	li	a0,-1
    8000121e:	bfd9                	j	800011f4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001220:	00f4863b          	addw	a2,s1,a5
    80001224:	1602                	slli	a2,a2,0x20
    80001226:	9201                	srli	a2,a2,0x20
    80001228:	1582                	slli	a1,a1,0x20
    8000122a:	9181                	srli	a1,a1,0x20
    8000122c:	6928                	ld	a0,80(a0)
    8000122e:	fffff097          	auipc	ra,0xfffff
    80001232:	640080e7          	jalr	1600(ra) # 8000086e <uvmdealloc>
    80001236:	0005079b          	sext.w	a5,a0
    8000123a:	bf45                	j	800011ea <growproc+0x26>

000000008000123c <fork>:
{
    8000123c:	7139                	addi	sp,sp,-64
    8000123e:	fc06                	sd	ra,56(sp)
    80001240:	f822                	sd	s0,48(sp)
    80001242:	f426                	sd	s1,40(sp)
    80001244:	e852                	sd	s4,16(sp)
    80001246:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	c22080e7          	jalr	-990(ra) # 80000e6a <myproc>
    80001250:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    80001252:	00000097          	auipc	ra,0x0
    80001256:	e22080e7          	jalr	-478(ra) # 80001074 <allocproc>
    8000125a:	14050d63          	beqz	a0,800013b4 <fork+0x178>
    8000125e:	ec4e                	sd	s3,24(sp)
    80001260:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001262:	048a3603          	ld	a2,72(s4)
    80001266:	692c                	ld	a1,80(a0)
    80001268:	050a3503          	ld	a0,80(s4)
    8000126c:	fffff097          	auipc	ra,0xfffff
    80001270:	7a2080e7          	jalr	1954(ra) # 80000a0e <uvmcopy>
    80001274:	00054b63          	bltz	a0,8000128a <fork+0x4e>
    80001278:	f04a                	sd	s2,32(sp)
    8000127a:	e456                	sd	s5,8(sp)
    8000127c:	168a0493          	addi	s1,s4,360
    80001280:	16898913          	addi	s2,s3,360
    80001284:	1e8a0a93          	addi	s5,s4,488
    80001288:	a015                	j	800012ac <fork+0x70>
    freeproc(np);
    8000128a:	854e                	mv	a0,s3
    8000128c:	00000097          	auipc	ra,0x0
    80001290:	d90080e7          	jalr	-624(ra) # 8000101c <freeproc>
    release(&np->lock);
    80001294:	854e                	mv	a0,s3
    80001296:	00005097          	auipc	ra,0x5
    8000129a:	512080e7          	jalr	1298(ra) # 800067a8 <release>
    return -1;
    8000129e:	54fd                	li	s1,-1
    800012a0:	69e2                	ld	s3,24(sp)
    800012a2:	a211                	j	800013a6 <fork+0x16a>
  for(i=0;i<NOFILE;i++){
    800012a4:	04a1                	addi	s1,s1,8
    800012a6:	0921                	addi	s2,s2,8
    800012a8:	05548c63          	beq	s1,s5,80001300 <fork+0xc4>
    if(p->areaps[i]){
    800012ac:	609c                	ld	a5,0(s1)
    800012ae:	dbfd                	beqz	a5,800012a4 <fork+0x68>
      np->areaps[i]=vma_alloc();
    800012b0:	00005097          	auipc	ra,0x5
    800012b4:	916080e7          	jalr	-1770(ra) # 80005bc6 <vma_alloc>
    800012b8:	00a93023          	sd	a0,0(s2)
      np->areaps[i]->addr=p->areaps[i]->addr;
    800012bc:	609c                	ld	a5,0(s1)
    800012be:	639c                	ld	a5,0(a5)
    800012c0:	e11c                	sd	a5,0(a0)
      np->areaps[i]->length=p->areaps[i]->length;
    800012c2:	00093783          	ld	a5,0(s2)
    800012c6:	6098                	ld	a4,0(s1)
    800012c8:	6718                	ld	a4,8(a4)
    800012ca:	e798                	sd	a4,8(a5)
      np->areaps[i]->prot=p->areaps[i]->prot;
    800012cc:	00093783          	ld	a5,0(s2)
    800012d0:	6098                	ld	a4,0(s1)
    800012d2:	01074703          	lbu	a4,16(a4)
    800012d6:	00e78823          	sb	a4,16(a5) # 1010 <_entry-0x7fffeff0>
      np->areaps[i]->flags=p->areaps[i]->flags;
    800012da:	00093783          	ld	a5,0(s2)
    800012de:	6098                	ld	a4,0(s1)
    800012e0:	01174703          	lbu	a4,17(a4)
    800012e4:	00e788a3          	sb	a4,17(a5)
      np->areaps[i]->file=p->areaps[i]->file;
    800012e8:	00093783          	ld	a5,0(s2)
    800012ec:	6098                	ld	a4,0(s1)
    800012ee:	6f18                	ld	a4,24(a4)
    800012f0:	ef98                	sd	a4,24(a5)
      filedup(p->areaps[i]->file);
    800012f2:	609c                	ld	a5,0(s1)
    800012f4:	6f88                	ld	a0,24(a5)
    800012f6:	00003097          	auipc	ra,0x3
    800012fa:	816080e7          	jalr	-2026(ra) # 80003b0c <filedup>
    800012fe:	b75d                	j	800012a4 <fork+0x68>
  np->sz = p->sz;
    80001300:	048a3783          	ld	a5,72(s4)
    80001304:	04f9b423          	sd	a5,72(s3)
  np->parent = p;
    80001308:	0349bc23          	sd	s4,56(s3)
  *(np->trapframe) = *(p->trapframe);
    8000130c:	058a3683          	ld	a3,88(s4)
    80001310:	87b6                	mv	a5,a3
    80001312:	0589b703          	ld	a4,88(s3)
    80001316:	12068693          	addi	a3,a3,288
    8000131a:	0007b803          	ld	a6,0(a5)
    8000131e:	6788                	ld	a0,8(a5)
    80001320:	6b8c                	ld	a1,16(a5)
    80001322:	6f90                	ld	a2,24(a5)
    80001324:	01073023          	sd	a6,0(a4)
    80001328:	e708                	sd	a0,8(a4)
    8000132a:	eb0c                	sd	a1,16(a4)
    8000132c:	ef10                	sd	a2,24(a4)
    8000132e:	02078793          	addi	a5,a5,32
    80001332:	02070713          	addi	a4,a4,32
    80001336:	fed792e3          	bne	a5,a3,8000131a <fork+0xde>
  np->trapframe->a0 = 0;
    8000133a:	0589b783          	ld	a5,88(s3)
    8000133e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001342:	0d0a0493          	addi	s1,s4,208
    80001346:	0d098913          	addi	s2,s3,208
    8000134a:	150a0a93          	addi	s5,s4,336
    8000134e:	a029                	j	80001358 <fork+0x11c>
    80001350:	04a1                	addi	s1,s1,8
    80001352:	0921                	addi	s2,s2,8
    80001354:	01548b63          	beq	s1,s5,8000136a <fork+0x12e>
    if(p->ofile[i])
    80001358:	6088                	ld	a0,0(s1)
    8000135a:	d97d                	beqz	a0,80001350 <fork+0x114>
      np->ofile[i] = filedup(p->ofile[i]);
    8000135c:	00002097          	auipc	ra,0x2
    80001360:	7b0080e7          	jalr	1968(ra) # 80003b0c <filedup>
    80001364:	00a93023          	sd	a0,0(s2)
    80001368:	b7e5                	j	80001350 <fork+0x114>
  np->cwd = idup(p->cwd);
    8000136a:	150a3503          	ld	a0,336(s4)
    8000136e:	00002097          	auipc	ra,0x2
    80001372:	916080e7          	jalr	-1770(ra) # 80002c84 <idup>
    80001376:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000137a:	4641                	li	a2,16
    8000137c:	158a0593          	addi	a1,s4,344
    80001380:	15898513          	addi	a0,s3,344
    80001384:	fffff097          	auipc	ra,0xfffff
    80001388:	f38080e7          	jalr	-200(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    8000138c:	0309a483          	lw	s1,48(s3)
  np->state = RUNNABLE;
    80001390:	478d                	li	a5,3
    80001392:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001396:	854e                	mv	a0,s3
    80001398:	00005097          	auipc	ra,0x5
    8000139c:	410080e7          	jalr	1040(ra) # 800067a8 <release>
  return pid;
    800013a0:	7902                	ld	s2,32(sp)
    800013a2:	69e2                	ld	s3,24(sp)
    800013a4:	6aa2                	ld	s5,8(sp)
}
    800013a6:	8526                	mv	a0,s1
    800013a8:	70e2                	ld	ra,56(sp)
    800013aa:	7442                	ld	s0,48(sp)
    800013ac:	74a2                	ld	s1,40(sp)
    800013ae:	6a42                	ld	s4,16(sp)
    800013b0:	6121                	addi	sp,sp,64
    800013b2:	8082                	ret
    return -1;
    800013b4:	54fd                	li	s1,-1
    800013b6:	bfc5                	j	800013a6 <fork+0x16a>

00000000800013b8 <scheduler>:
{
    800013b8:	7139                	addi	sp,sp,-64
    800013ba:	fc06                	sd	ra,56(sp)
    800013bc:	f822                	sd	s0,48(sp)
    800013be:	f426                	sd	s1,40(sp)
    800013c0:	f04a                	sd	s2,32(sp)
    800013c2:	ec4e                	sd	s3,24(sp)
    800013c4:	e852                	sd	s4,16(sp)
    800013c6:	e456                	sd	s5,8(sp)
    800013c8:	e05a                	sd	s6,0(sp)
    800013ca:	0080                	addi	s0,sp,64
    800013cc:	8792                	mv	a5,tp
  int id = r_tp();
    800013ce:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013d0:	00779a93          	slli	s5,a5,0x7
    800013d4:	00008717          	auipc	a4,0x8
    800013d8:	c7c70713          	addi	a4,a4,-900 # 80009050 <pid_lock>
    800013dc:	9756                	add	a4,a4,s5
    800013de:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013e2:	00008717          	auipc	a4,0x8
    800013e6:	ca670713          	addi	a4,a4,-858 # 80009088 <cpus+0x8>
    800013ea:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013ec:	498d                	li	s3,3
        p->state = RUNNING;
    800013ee:	4b11                	li	s6,4
        c->proc = p;
    800013f0:	079e                	slli	a5,a5,0x7
    800013f2:	00008a17          	auipc	s4,0x8
    800013f6:	c5ea0a13          	addi	s4,s4,-930 # 80009050 <pid_lock>
    800013fa:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013fc:	00010917          	auipc	s2,0x10
    80001400:	a8490913          	addi	s2,s2,-1404 # 80010e80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001404:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001408:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000140c:	10079073          	csrw	sstatus,a5
    80001410:	00008497          	auipc	s1,0x8
    80001414:	07048493          	addi	s1,s1,112 # 80009480 <proc>
    80001418:	a811                	j	8000142c <scheduler+0x74>
      release(&p->lock);
    8000141a:	8526                	mv	a0,s1
    8000141c:	00005097          	auipc	ra,0x5
    80001420:	38c080e7          	jalr	908(ra) # 800067a8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001424:	1e848493          	addi	s1,s1,488
    80001428:	fd248ee3          	beq	s1,s2,80001404 <scheduler+0x4c>
      acquire(&p->lock);
    8000142c:	8526                	mv	a0,s1
    8000142e:	00005097          	auipc	ra,0x5
    80001432:	2c6080e7          	jalr	710(ra) # 800066f4 <acquire>
      if(p->state == RUNNABLE) {
    80001436:	4c9c                	lw	a5,24(s1)
    80001438:	ff3791e3          	bne	a5,s3,8000141a <scheduler+0x62>
        p->state = RUNNING;
    8000143c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001440:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001444:	06048593          	addi	a1,s1,96
    80001448:	8556                	mv	a0,s5
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	6e0080e7          	jalr	1760(ra) # 80001b2a <swtch>
        c->proc = 0;
    80001452:	020a3823          	sd	zero,48(s4)
    80001456:	b7d1                	j	8000141a <scheduler+0x62>

0000000080001458 <sched>:
{
    80001458:	7179                	addi	sp,sp,-48
    8000145a:	f406                	sd	ra,40(sp)
    8000145c:	f022                	sd	s0,32(sp)
    8000145e:	ec26                	sd	s1,24(sp)
    80001460:	e84a                	sd	s2,16(sp)
    80001462:	e44e                	sd	s3,8(sp)
    80001464:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	a04080e7          	jalr	-1532(ra) # 80000e6a <myproc>
    8000146e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001470:	00005097          	auipc	ra,0x5
    80001474:	20a080e7          	jalr	522(ra) # 8000667a <holding>
    80001478:	c93d                	beqz	a0,800014ee <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000147a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000147c:	2781                	sext.w	a5,a5
    8000147e:	079e                	slli	a5,a5,0x7
    80001480:	00008717          	auipc	a4,0x8
    80001484:	bd070713          	addi	a4,a4,-1072 # 80009050 <pid_lock>
    80001488:	97ba                	add	a5,a5,a4
    8000148a:	0a87a703          	lw	a4,168(a5)
    8000148e:	4785                	li	a5,1
    80001490:	06f71763          	bne	a4,a5,800014fe <sched+0xa6>
  if(p->state == RUNNING)
    80001494:	4c98                	lw	a4,24(s1)
    80001496:	4791                	li	a5,4
    80001498:	06f70b63          	beq	a4,a5,8000150e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000149c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014a0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014a2:	efb5                	bnez	a5,8000151e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014a6:	00008917          	auipc	s2,0x8
    800014aa:	baa90913          	addi	s2,s2,-1110 # 80009050 <pid_lock>
    800014ae:	2781                	sext.w	a5,a5
    800014b0:	079e                	slli	a5,a5,0x7
    800014b2:	97ca                	add	a5,a5,s2
    800014b4:	0ac7a983          	lw	s3,172(a5)
    800014b8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014ba:	2781                	sext.w	a5,a5
    800014bc:	079e                	slli	a5,a5,0x7
    800014be:	00008597          	auipc	a1,0x8
    800014c2:	bca58593          	addi	a1,a1,-1078 # 80009088 <cpus+0x8>
    800014c6:	95be                	add	a1,a1,a5
    800014c8:	06048513          	addi	a0,s1,96
    800014cc:	00000097          	auipc	ra,0x0
    800014d0:	65e080e7          	jalr	1630(ra) # 80001b2a <swtch>
    800014d4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014d6:	2781                	sext.w	a5,a5
    800014d8:	079e                	slli	a5,a5,0x7
    800014da:	993e                	add	s2,s2,a5
    800014dc:	0b392623          	sw	s3,172(s2)
}
    800014e0:	70a2                	ld	ra,40(sp)
    800014e2:	7402                	ld	s0,32(sp)
    800014e4:	64e2                	ld	s1,24(sp)
    800014e6:	6942                	ld	s2,16(sp)
    800014e8:	69a2                	ld	s3,8(sp)
    800014ea:	6145                	addi	sp,sp,48
    800014ec:	8082                	ret
    panic("sched p->lock");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	c7250513          	addi	a0,a0,-910 # 80008160 <etext+0x160>
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	c84080e7          	jalr	-892(ra) # 8000617a <panic>
    panic("sched locks");
    800014fe:	00007517          	auipc	a0,0x7
    80001502:	c7250513          	addi	a0,a0,-910 # 80008170 <etext+0x170>
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	c74080e7          	jalr	-908(ra) # 8000617a <panic>
    panic("sched running");
    8000150e:	00007517          	auipc	a0,0x7
    80001512:	c7250513          	addi	a0,a0,-910 # 80008180 <etext+0x180>
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	c64080e7          	jalr	-924(ra) # 8000617a <panic>
    panic("sched interruptible");
    8000151e:	00007517          	auipc	a0,0x7
    80001522:	c7250513          	addi	a0,a0,-910 # 80008190 <etext+0x190>
    80001526:	00005097          	auipc	ra,0x5
    8000152a:	c54080e7          	jalr	-940(ra) # 8000617a <panic>

000000008000152e <yield>:
{
    8000152e:	1101                	addi	sp,sp,-32
    80001530:	ec06                	sd	ra,24(sp)
    80001532:	e822                	sd	s0,16(sp)
    80001534:	e426                	sd	s1,8(sp)
    80001536:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	932080e7          	jalr	-1742(ra) # 80000e6a <myproc>
    80001540:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001542:	00005097          	auipc	ra,0x5
    80001546:	1b2080e7          	jalr	434(ra) # 800066f4 <acquire>
  p->state = RUNNABLE;
    8000154a:	478d                	li	a5,3
    8000154c:	cc9c                	sw	a5,24(s1)
  sched();
    8000154e:	00000097          	auipc	ra,0x0
    80001552:	f0a080e7          	jalr	-246(ra) # 80001458 <sched>
  release(&p->lock);
    80001556:	8526                	mv	a0,s1
    80001558:	00005097          	auipc	ra,0x5
    8000155c:	250080e7          	jalr	592(ra) # 800067a8 <release>
}
    80001560:	60e2                	ld	ra,24(sp)
    80001562:	6442                	ld	s0,16(sp)
    80001564:	64a2                	ld	s1,8(sp)
    80001566:	6105                	addi	sp,sp,32
    80001568:	8082                	ret

000000008000156a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000156a:	7179                	addi	sp,sp,-48
    8000156c:	f406                	sd	ra,40(sp)
    8000156e:	f022                	sd	s0,32(sp)
    80001570:	ec26                	sd	s1,24(sp)
    80001572:	e84a                	sd	s2,16(sp)
    80001574:	e44e                	sd	s3,8(sp)
    80001576:	1800                	addi	s0,sp,48
    80001578:	89aa                	mv	s3,a0
    8000157a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	8ee080e7          	jalr	-1810(ra) # 80000e6a <myproc>
    80001584:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	16e080e7          	jalr	366(ra) # 800066f4 <acquire>
  release(lk);
    8000158e:	854a                	mv	a0,s2
    80001590:	00005097          	auipc	ra,0x5
    80001594:	218080e7          	jalr	536(ra) # 800067a8 <release>

  // Go to sleep.
  p->chan = chan;
    80001598:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000159c:	4789                	li	a5,2
    8000159e:	cc9c                	sw	a5,24(s1)

  sched();
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	eb8080e7          	jalr	-328(ra) # 80001458 <sched>

  // Tidy up.
  p->chan = 0;
    800015a8:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015ac:	8526                	mv	a0,s1
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	1fa080e7          	jalr	506(ra) # 800067a8 <release>
  acquire(lk);
    800015b6:	854a                	mv	a0,s2
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	13c080e7          	jalr	316(ra) # 800066f4 <acquire>
}
    800015c0:	70a2                	ld	ra,40(sp)
    800015c2:	7402                	ld	s0,32(sp)
    800015c4:	64e2                	ld	s1,24(sp)
    800015c6:	6942                	ld	s2,16(sp)
    800015c8:	69a2                	ld	s3,8(sp)
    800015ca:	6145                	addi	sp,sp,48
    800015cc:	8082                	ret

00000000800015ce <wait>:
{
    800015ce:	715d                	addi	sp,sp,-80
    800015d0:	e486                	sd	ra,72(sp)
    800015d2:	e0a2                	sd	s0,64(sp)
    800015d4:	fc26                	sd	s1,56(sp)
    800015d6:	f84a                	sd	s2,48(sp)
    800015d8:	f44e                	sd	s3,40(sp)
    800015da:	f052                	sd	s4,32(sp)
    800015dc:	ec56                	sd	s5,24(sp)
    800015de:	e85a                	sd	s6,16(sp)
    800015e0:	e45e                	sd	s7,8(sp)
    800015e2:	e062                	sd	s8,0(sp)
    800015e4:	0880                	addi	s0,sp,80
    800015e6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015e8:	00000097          	auipc	ra,0x0
    800015ec:	882080e7          	jalr	-1918(ra) # 80000e6a <myproc>
    800015f0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015f2:	00008517          	auipc	a0,0x8
    800015f6:	a7650513          	addi	a0,a0,-1418 # 80009068 <wait_lock>
    800015fa:	00005097          	auipc	ra,0x5
    800015fe:	0fa080e7          	jalr	250(ra) # 800066f4 <acquire>
    havekids = 0;
    80001602:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001604:	4a15                	li	s4,5
        havekids = 1;
    80001606:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001608:	00010997          	auipc	s3,0x10
    8000160c:	87898993          	addi	s3,s3,-1928 # 80010e80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001610:	00008c17          	auipc	s8,0x8
    80001614:	a58c0c13          	addi	s8,s8,-1448 # 80009068 <wait_lock>
    80001618:	a87d                	j	800016d6 <wait+0x108>
          pid = np->pid;
    8000161a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000161e:	000b0e63          	beqz	s6,8000163a <wait+0x6c>
    80001622:	4691                	li	a3,4
    80001624:	02c48613          	addi	a2,s1,44
    80001628:	85da                	mv	a1,s6
    8000162a:	05093503          	ld	a0,80(s2)
    8000162e:	fffff097          	auipc	ra,0xfffff
    80001632:	4d8080e7          	jalr	1240(ra) # 80000b06 <copyout>
    80001636:	04054163          	bltz	a0,80001678 <wait+0xaa>
          freeproc(np);
    8000163a:	8526                	mv	a0,s1
    8000163c:	00000097          	auipc	ra,0x0
    80001640:	9e0080e7          	jalr	-1568(ra) # 8000101c <freeproc>
          release(&np->lock);
    80001644:	8526                	mv	a0,s1
    80001646:	00005097          	auipc	ra,0x5
    8000164a:	162080e7          	jalr	354(ra) # 800067a8 <release>
          release(&wait_lock);
    8000164e:	00008517          	auipc	a0,0x8
    80001652:	a1a50513          	addi	a0,a0,-1510 # 80009068 <wait_lock>
    80001656:	00005097          	auipc	ra,0x5
    8000165a:	152080e7          	jalr	338(ra) # 800067a8 <release>
}
    8000165e:	854e                	mv	a0,s3
    80001660:	60a6                	ld	ra,72(sp)
    80001662:	6406                	ld	s0,64(sp)
    80001664:	74e2                	ld	s1,56(sp)
    80001666:	7942                	ld	s2,48(sp)
    80001668:	79a2                	ld	s3,40(sp)
    8000166a:	7a02                	ld	s4,32(sp)
    8000166c:	6ae2                	ld	s5,24(sp)
    8000166e:	6b42                	ld	s6,16(sp)
    80001670:	6ba2                	ld	s7,8(sp)
    80001672:	6c02                	ld	s8,0(sp)
    80001674:	6161                	addi	sp,sp,80
    80001676:	8082                	ret
            release(&np->lock);
    80001678:	8526                	mv	a0,s1
    8000167a:	00005097          	auipc	ra,0x5
    8000167e:	12e080e7          	jalr	302(ra) # 800067a8 <release>
            release(&wait_lock);
    80001682:	00008517          	auipc	a0,0x8
    80001686:	9e650513          	addi	a0,a0,-1562 # 80009068 <wait_lock>
    8000168a:	00005097          	auipc	ra,0x5
    8000168e:	11e080e7          	jalr	286(ra) # 800067a8 <release>
            return -1;
    80001692:	59fd                	li	s3,-1
    80001694:	b7e9                	j	8000165e <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    80001696:	1e848493          	addi	s1,s1,488
    8000169a:	03348463          	beq	s1,s3,800016c2 <wait+0xf4>
      if(np->parent == p){
    8000169e:	7c9c                	ld	a5,56(s1)
    800016a0:	ff279be3          	bne	a5,s2,80001696 <wait+0xc8>
        acquire(&np->lock);
    800016a4:	8526                	mv	a0,s1
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	04e080e7          	jalr	78(ra) # 800066f4 <acquire>
        if(np->state == ZOMBIE){
    800016ae:	4c9c                	lw	a5,24(s1)
    800016b0:	f74785e3          	beq	a5,s4,8000161a <wait+0x4c>
        release(&np->lock);
    800016b4:	8526                	mv	a0,s1
    800016b6:	00005097          	auipc	ra,0x5
    800016ba:	0f2080e7          	jalr	242(ra) # 800067a8 <release>
        havekids = 1;
    800016be:	8756                	mv	a4,s5
    800016c0:	bfd9                	j	80001696 <wait+0xc8>
    if(!havekids || p->killed){
    800016c2:	c305                	beqz	a4,800016e2 <wait+0x114>
    800016c4:	02892783          	lw	a5,40(s2)
    800016c8:	ef89                	bnez	a5,800016e2 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ca:	85e2                	mv	a1,s8
    800016cc:	854a                	mv	a0,s2
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	e9c080e7          	jalr	-356(ra) # 8000156a <sleep>
    havekids = 0;
    800016d6:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016d8:	00008497          	auipc	s1,0x8
    800016dc:	da848493          	addi	s1,s1,-600 # 80009480 <proc>
    800016e0:	bf7d                	j	8000169e <wait+0xd0>
      release(&wait_lock);
    800016e2:	00008517          	auipc	a0,0x8
    800016e6:	98650513          	addi	a0,a0,-1658 # 80009068 <wait_lock>
    800016ea:	00005097          	auipc	ra,0x5
    800016ee:	0be080e7          	jalr	190(ra) # 800067a8 <release>
      return -1;
    800016f2:	59fd                	li	s3,-1
    800016f4:	b7ad                	j	8000165e <wait+0x90>

00000000800016f6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016f6:	7139                	addi	sp,sp,-64
    800016f8:	fc06                	sd	ra,56(sp)
    800016fa:	f822                	sd	s0,48(sp)
    800016fc:	f426                	sd	s1,40(sp)
    800016fe:	f04a                	sd	s2,32(sp)
    80001700:	ec4e                	sd	s3,24(sp)
    80001702:	e852                	sd	s4,16(sp)
    80001704:	e456                	sd	s5,8(sp)
    80001706:	0080                	addi	s0,sp,64
    80001708:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000170a:	00008497          	auipc	s1,0x8
    8000170e:	d7648493          	addi	s1,s1,-650 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001712:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001714:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001716:	0000f917          	auipc	s2,0xf
    8000171a:	76a90913          	addi	s2,s2,1898 # 80010e80 <tickslock>
    8000171e:	a811                	j	80001732 <wakeup+0x3c>
      }
      release(&p->lock);
    80001720:	8526                	mv	a0,s1
    80001722:	00005097          	auipc	ra,0x5
    80001726:	086080e7          	jalr	134(ra) # 800067a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000172a:	1e848493          	addi	s1,s1,488
    8000172e:	03248663          	beq	s1,s2,8000175a <wakeup+0x64>
    if(p != myproc()){
    80001732:	fffff097          	auipc	ra,0xfffff
    80001736:	738080e7          	jalr	1848(ra) # 80000e6a <myproc>
    8000173a:	fea488e3          	beq	s1,a0,8000172a <wakeup+0x34>
      acquire(&p->lock);
    8000173e:	8526                	mv	a0,s1
    80001740:	00005097          	auipc	ra,0x5
    80001744:	fb4080e7          	jalr	-76(ra) # 800066f4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001748:	4c9c                	lw	a5,24(s1)
    8000174a:	fd379be3          	bne	a5,s3,80001720 <wakeup+0x2a>
    8000174e:	709c                	ld	a5,32(s1)
    80001750:	fd4798e3          	bne	a5,s4,80001720 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001754:	0154ac23          	sw	s5,24(s1)
    80001758:	b7e1                	j	80001720 <wakeup+0x2a>
    }
  }
}
    8000175a:	70e2                	ld	ra,56(sp)
    8000175c:	7442                	ld	s0,48(sp)
    8000175e:	74a2                	ld	s1,40(sp)
    80001760:	7902                	ld	s2,32(sp)
    80001762:	69e2                	ld	s3,24(sp)
    80001764:	6a42                	ld	s4,16(sp)
    80001766:	6aa2                	ld	s5,8(sp)
    80001768:	6121                	addi	sp,sp,64
    8000176a:	8082                	ret

000000008000176c <reparent>:
{
    8000176c:	7179                	addi	sp,sp,-48
    8000176e:	f406                	sd	ra,40(sp)
    80001770:	f022                	sd	s0,32(sp)
    80001772:	ec26                	sd	s1,24(sp)
    80001774:	e84a                	sd	s2,16(sp)
    80001776:	e44e                	sd	s3,8(sp)
    80001778:	e052                	sd	s4,0(sp)
    8000177a:	1800                	addi	s0,sp,48
    8000177c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177e:	00008497          	auipc	s1,0x8
    80001782:	d0248493          	addi	s1,s1,-766 # 80009480 <proc>
      pp->parent = initproc;
    80001786:	00008a17          	auipc	s4,0x8
    8000178a:	88aa0a13          	addi	s4,s4,-1910 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000178e:	0000f997          	auipc	s3,0xf
    80001792:	6f298993          	addi	s3,s3,1778 # 80010e80 <tickslock>
    80001796:	a029                	j	800017a0 <reparent+0x34>
    80001798:	1e848493          	addi	s1,s1,488
    8000179c:	01348d63          	beq	s1,s3,800017b6 <reparent+0x4a>
    if(pp->parent == p){
    800017a0:	7c9c                	ld	a5,56(s1)
    800017a2:	ff279be3          	bne	a5,s2,80001798 <reparent+0x2c>
      pp->parent = initproc;
    800017a6:	000a3503          	ld	a0,0(s4)
    800017aa:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	f4a080e7          	jalr	-182(ra) # 800016f6 <wakeup>
    800017b4:	b7d5                	j	80001798 <reparent+0x2c>
}
    800017b6:	70a2                	ld	ra,40(sp)
    800017b8:	7402                	ld	s0,32(sp)
    800017ba:	64e2                	ld	s1,24(sp)
    800017bc:	6942                	ld	s2,16(sp)
    800017be:	69a2                	ld	s3,8(sp)
    800017c0:	6a02                	ld	s4,0(sp)
    800017c2:	6145                	addi	sp,sp,48
    800017c4:	8082                	ret

00000000800017c6 <exit>:
{
    800017c6:	715d                	addi	sp,sp,-80
    800017c8:	e486                	sd	ra,72(sp)
    800017ca:	e0a2                	sd	s0,64(sp)
    800017cc:	fc26                	sd	s1,56(sp)
    800017ce:	f052                	sd	s4,32(sp)
    800017d0:	ec56                	sd	s5,24(sp)
    800017d2:	e85a                	sd	s6,16(sp)
    800017d4:	e45e                	sd	s7,8(sp)
    800017d6:	0880                	addi	s0,sp,80
    800017d8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017da:	fffff097          	auipc	ra,0xfffff
    800017de:	690080e7          	jalr	1680(ra) # 80000e6a <myproc>
    800017e2:	8aaa                	mv	s5,a0
  if(p == initproc)
    800017e4:	00008797          	auipc	a5,0x8
    800017e8:	82c7b783          	ld	a5,-2004(a5) # 80009010 <initproc>
    800017ec:	16850493          	addi	s1,a0,360
    800017f0:	1e850a13          	addi	s4,a0,488
      if(vmap->prot & PROT_WRITE && vmap->flags == MAP_SHARED){
    800017f4:	4b85                	li	s7,1
  if(p == initproc)
    800017f6:	00a78563          	beq	a5,a0,80001800 <exit+0x3a>
    800017fa:	f84a                	sd	s2,48(sp)
    800017fc:	f44e                	sd	s3,40(sp)
    800017fe:	a81d                	j	80001834 <exit+0x6e>
    80001800:	f84a                	sd	s2,48(sp)
    80001802:	f44e                	sd	s3,40(sp)
    panic("init exiting");
    80001804:	00007517          	auipc	a0,0x7
    80001808:	9a450513          	addi	a0,a0,-1628 # 800081a8 <etext+0x1a8>
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	96e080e7          	jalr	-1682(ra) # 8000617a <panic>
      fileclose(vmap->file);
    80001814:	01893503          	ld	a0,24(s2)
    80001818:	00002097          	auipc	ra,0x2
    8000181c:	346080e7          	jalr	838(ra) # 80003b5e <fileclose>
      vma_free(vmap);
    80001820:	854a                	mv	a0,s2
    80001822:	00004097          	auipc	ra,0x4
    80001826:	40a080e7          	jalr	1034(ra) # 80005c2c <vma_free>
      p->areaps[i]=0;
    8000182a:	0009b023          	sd	zero,0(s3)
for(int i=0;i<NOFILE;i++){
    8000182e:	04a1                	addi	s1,s1,8
    80001830:	07448363          	beq	s1,s4,80001896 <exit+0xd0>
    if(p->areaps[i]){
    80001834:	89a6                	mv	s3,s1
    80001836:	0004b903          	ld	s2,0(s1)
    8000183a:	fe090ae3          	beqz	s2,8000182e <exit+0x68>
      if(vmap->prot & PROT_WRITE && vmap->flags == MAP_SHARED){
    8000183e:	01094783          	lbu	a5,16(s2)
    80001842:	8b89                	andi	a5,a5,2
    80001844:	dbe1                	beqz	a5,80001814 <exit+0x4e>
    80001846:	01194783          	lbu	a5,17(s2)
    8000184a:	fd7795e3          	bne	a5,s7,80001814 <exit+0x4e>
        begin_op();
    8000184e:	00002097          	auipc	ra,0x2
    80001852:	e46080e7          	jalr	-442(ra) # 80003694 <begin_op>
        ilock(vmap->file->ip);
    80001856:	01893783          	ld	a5,24(s2)
    8000185a:	6f88                	ld	a0,24(a5)
    8000185c:	00001097          	auipc	ra,0x1
    80001860:	466080e7          	jalr	1126(ra) # 80002cc2 <ilock>
        writei(vmap->file->ip,1,(uint64)vmap->addr,0,vmap->length);
    80001864:	01893783          	ld	a5,24(s2)
    80001868:	00892703          	lw	a4,8(s2)
    8000186c:	4681                	li	a3,0
    8000186e:	00093603          	ld	a2,0(s2)
    80001872:	85de                	mv	a1,s7
    80001874:	6f88                	ld	a0,24(a5)
    80001876:	00002097          	auipc	ra,0x2
    8000187a:	808080e7          	jalr	-2040(ra) # 8000307e <writei>
        iunlock(vmap->file->ip);
    8000187e:	01893783          	ld	a5,24(s2)
    80001882:	6f88                	ld	a0,24(a5)
    80001884:	00001097          	auipc	ra,0x1
    80001888:	504080e7          	jalr	1284(ra) # 80002d88 <iunlock>
        end_op();
    8000188c:	00002097          	auipc	ra,0x2
    80001890:	e82080e7          	jalr	-382(ra) # 8000370e <end_op>
    80001894:	b741                	j	80001814 <exit+0x4e>
    80001896:	0d0a8493          	addi	s1,s5,208
    8000189a:	150a8913          	addi	s2,s5,336
    8000189e:	a021                	j	800018a6 <exit+0xe0>
  for(int fd = 0; fd < NOFILE; fd++){
    800018a0:	04a1                	addi	s1,s1,8
    800018a2:	01248b63          	beq	s1,s2,800018b8 <exit+0xf2>
    if(p->ofile[fd]){
    800018a6:	6088                	ld	a0,0(s1)
    800018a8:	dd65                	beqz	a0,800018a0 <exit+0xda>
      fileclose(f);
    800018aa:	00002097          	auipc	ra,0x2
    800018ae:	2b4080e7          	jalr	692(ra) # 80003b5e <fileclose>
      p->ofile[fd] = 0;
    800018b2:	0004b023          	sd	zero,0(s1)
    800018b6:	b7ed                	j	800018a0 <exit+0xda>
  begin_op();
    800018b8:	00002097          	auipc	ra,0x2
    800018bc:	ddc080e7          	jalr	-548(ra) # 80003694 <begin_op>
  iput(p->cwd);
    800018c0:	150ab503          	ld	a0,336(s5)
    800018c4:	00001097          	auipc	ra,0x1
    800018c8:	5bc080e7          	jalr	1468(ra) # 80002e80 <iput>
  end_op();
    800018cc:	00002097          	auipc	ra,0x2
    800018d0:	e42080e7          	jalr	-446(ra) # 8000370e <end_op>
  p->cwd = 0;
    800018d4:	140ab823          	sd	zero,336(s5)
  acquire(&wait_lock);
    800018d8:	00007497          	auipc	s1,0x7
    800018dc:	79048493          	addi	s1,s1,1936 # 80009068 <wait_lock>
    800018e0:	8526                	mv	a0,s1
    800018e2:	00005097          	auipc	ra,0x5
    800018e6:	e12080e7          	jalr	-494(ra) # 800066f4 <acquire>
  reparent(p);
    800018ea:	8556                	mv	a0,s5
    800018ec:	00000097          	auipc	ra,0x0
    800018f0:	e80080e7          	jalr	-384(ra) # 8000176c <reparent>
  wakeup(p->parent);
    800018f4:	038ab503          	ld	a0,56(s5)
    800018f8:	00000097          	auipc	ra,0x0
    800018fc:	dfe080e7          	jalr	-514(ra) # 800016f6 <wakeup>
  acquire(&p->lock);
    80001900:	8556                	mv	a0,s5
    80001902:	00005097          	auipc	ra,0x5
    80001906:	df2080e7          	jalr	-526(ra) # 800066f4 <acquire>
  p->xstate = status;
    8000190a:	036aa623          	sw	s6,44(s5)
  p->state = ZOMBIE;
    8000190e:	4795                	li	a5,5
    80001910:	00faac23          	sw	a5,24(s5)
  release(&wait_lock);
    80001914:	8526                	mv	a0,s1
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	e92080e7          	jalr	-366(ra) # 800067a8 <release>
  sched();
    8000191e:	00000097          	auipc	ra,0x0
    80001922:	b3a080e7          	jalr	-1222(ra) # 80001458 <sched>
  panic("zombie exit");
    80001926:	00007517          	auipc	a0,0x7
    8000192a:	89250513          	addi	a0,a0,-1902 # 800081b8 <etext+0x1b8>
    8000192e:	00005097          	auipc	ra,0x5
    80001932:	84c080e7          	jalr	-1972(ra) # 8000617a <panic>

0000000080001936 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001936:	7179                	addi	sp,sp,-48
    80001938:	f406                	sd	ra,40(sp)
    8000193a:	f022                	sd	s0,32(sp)
    8000193c:	ec26                	sd	s1,24(sp)
    8000193e:	e84a                	sd	s2,16(sp)
    80001940:	e44e                	sd	s3,8(sp)
    80001942:	1800                	addi	s0,sp,48
    80001944:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001946:	00008497          	auipc	s1,0x8
    8000194a:	b3a48493          	addi	s1,s1,-1222 # 80009480 <proc>
    8000194e:	0000f997          	auipc	s3,0xf
    80001952:	53298993          	addi	s3,s3,1330 # 80010e80 <tickslock>
    acquire(&p->lock);
    80001956:	8526                	mv	a0,s1
    80001958:	00005097          	auipc	ra,0x5
    8000195c:	d9c080e7          	jalr	-612(ra) # 800066f4 <acquire>
    if(p->pid == pid){
    80001960:	589c                	lw	a5,48(s1)
    80001962:	01278d63          	beq	a5,s2,8000197c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001966:	8526                	mv	a0,s1
    80001968:	00005097          	auipc	ra,0x5
    8000196c:	e40080e7          	jalr	-448(ra) # 800067a8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001970:	1e848493          	addi	s1,s1,488
    80001974:	ff3491e3          	bne	s1,s3,80001956 <kill+0x20>
  }
  return -1;
    80001978:	557d                	li	a0,-1
    8000197a:	a829                	j	80001994 <kill+0x5e>
      p->killed = 1;
    8000197c:	4785                	li	a5,1
    8000197e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001980:	4c98                	lw	a4,24(s1)
    80001982:	4789                	li	a5,2
    80001984:	00f70f63          	beq	a4,a5,800019a2 <kill+0x6c>
      release(&p->lock);
    80001988:	8526                	mv	a0,s1
    8000198a:	00005097          	auipc	ra,0x5
    8000198e:	e1e080e7          	jalr	-482(ra) # 800067a8 <release>
      return 0;
    80001992:	4501                	li	a0,0
}
    80001994:	70a2                	ld	ra,40(sp)
    80001996:	7402                	ld	s0,32(sp)
    80001998:	64e2                	ld	s1,24(sp)
    8000199a:	6942                	ld	s2,16(sp)
    8000199c:	69a2                	ld	s3,8(sp)
    8000199e:	6145                	addi	sp,sp,48
    800019a0:	8082                	ret
        p->state = RUNNABLE;
    800019a2:	478d                	li	a5,3
    800019a4:	cc9c                	sw	a5,24(s1)
    800019a6:	b7cd                	j	80001988 <kill+0x52>

00000000800019a8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019a8:	7179                	addi	sp,sp,-48
    800019aa:	f406                	sd	ra,40(sp)
    800019ac:	f022                	sd	s0,32(sp)
    800019ae:	ec26                	sd	s1,24(sp)
    800019b0:	e84a                	sd	s2,16(sp)
    800019b2:	e44e                	sd	s3,8(sp)
    800019b4:	e052                	sd	s4,0(sp)
    800019b6:	1800                	addi	s0,sp,48
    800019b8:	84aa                	mv	s1,a0
    800019ba:	892e                	mv	s2,a1
    800019bc:	89b2                	mv	s3,a2
    800019be:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019c0:	fffff097          	auipc	ra,0xfffff
    800019c4:	4aa080e7          	jalr	1194(ra) # 80000e6a <myproc>
  if(user_dst){
    800019c8:	c08d                	beqz	s1,800019ea <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019ca:	86d2                	mv	a3,s4
    800019cc:	864e                	mv	a2,s3
    800019ce:	85ca                	mv	a1,s2
    800019d0:	6928                	ld	a0,80(a0)
    800019d2:	fffff097          	auipc	ra,0xfffff
    800019d6:	134080e7          	jalr	308(ra) # 80000b06 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019da:	70a2                	ld	ra,40(sp)
    800019dc:	7402                	ld	s0,32(sp)
    800019de:	64e2                	ld	s1,24(sp)
    800019e0:	6942                	ld	s2,16(sp)
    800019e2:	69a2                	ld	s3,8(sp)
    800019e4:	6a02                	ld	s4,0(sp)
    800019e6:	6145                	addi	sp,sp,48
    800019e8:	8082                	ret
    memmove((char *)dst, src, len);
    800019ea:	000a061b          	sext.w	a2,s4
    800019ee:	85ce                	mv	a1,s3
    800019f0:	854a                	mv	a0,s2
    800019f2:	ffffe097          	auipc	ra,0xffffe
    800019f6:	7e4080e7          	jalr	2020(ra) # 800001d6 <memmove>
    return 0;
    800019fa:	8526                	mv	a0,s1
    800019fc:	bff9                	j	800019da <either_copyout+0x32>

00000000800019fe <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019fe:	7179                	addi	sp,sp,-48
    80001a00:	f406                	sd	ra,40(sp)
    80001a02:	f022                	sd	s0,32(sp)
    80001a04:	ec26                	sd	s1,24(sp)
    80001a06:	e84a                	sd	s2,16(sp)
    80001a08:	e44e                	sd	s3,8(sp)
    80001a0a:	e052                	sd	s4,0(sp)
    80001a0c:	1800                	addi	s0,sp,48
    80001a0e:	892a                	mv	s2,a0
    80001a10:	84ae                	mv	s1,a1
    80001a12:	89b2                	mv	s3,a2
    80001a14:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a16:	fffff097          	auipc	ra,0xfffff
    80001a1a:	454080e7          	jalr	1108(ra) # 80000e6a <myproc>
  if(user_src){
    80001a1e:	c08d                	beqz	s1,80001a40 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a20:	86d2                	mv	a3,s4
    80001a22:	864e                	mv	a2,s3
    80001a24:	85ca                	mv	a1,s2
    80001a26:	6928                	ld	a0,80(a0)
    80001a28:	fffff097          	auipc	ra,0xfffff
    80001a2c:	16a080e7          	jalr	362(ra) # 80000b92 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a30:	70a2                	ld	ra,40(sp)
    80001a32:	7402                	ld	s0,32(sp)
    80001a34:	64e2                	ld	s1,24(sp)
    80001a36:	6942                	ld	s2,16(sp)
    80001a38:	69a2                	ld	s3,8(sp)
    80001a3a:	6a02                	ld	s4,0(sp)
    80001a3c:	6145                	addi	sp,sp,48
    80001a3e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a40:	000a061b          	sext.w	a2,s4
    80001a44:	85ce                	mv	a1,s3
    80001a46:	854a                	mv	a0,s2
    80001a48:	ffffe097          	auipc	ra,0xffffe
    80001a4c:	78e080e7          	jalr	1934(ra) # 800001d6 <memmove>
    return 0;
    80001a50:	8526                	mv	a0,s1
    80001a52:	bff9                	j	80001a30 <either_copyin+0x32>

0000000080001a54 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a54:	715d                	addi	sp,sp,-80
    80001a56:	e486                	sd	ra,72(sp)
    80001a58:	e0a2                	sd	s0,64(sp)
    80001a5a:	fc26                	sd	s1,56(sp)
    80001a5c:	f84a                	sd	s2,48(sp)
    80001a5e:	f44e                	sd	s3,40(sp)
    80001a60:	f052                	sd	s4,32(sp)
    80001a62:	ec56                	sd	s5,24(sp)
    80001a64:	e85a                	sd	s6,16(sp)
    80001a66:	e45e                	sd	s7,8(sp)
    80001a68:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a6a:	00006517          	auipc	a0,0x6
    80001a6e:	5ae50513          	addi	a0,a0,1454 # 80008018 <etext+0x18>
    80001a72:	00004097          	auipc	ra,0x4
    80001a76:	752080e7          	jalr	1874(ra) # 800061c4 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a7a:	00008497          	auipc	s1,0x8
    80001a7e:	b5e48493          	addi	s1,s1,-1186 # 800095d8 <proc+0x158>
    80001a82:	0000f917          	auipc	s2,0xf
    80001a86:	55690913          	addi	s2,s2,1366 # 80010fd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a8a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a8c:	00006997          	auipc	s3,0x6
    80001a90:	73c98993          	addi	s3,s3,1852 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    80001a94:	00006a97          	auipc	s5,0x6
    80001a98:	73ca8a93          	addi	s5,s5,1852 # 800081d0 <etext+0x1d0>
    printf("\n");
    80001a9c:	00006a17          	auipc	s4,0x6
    80001aa0:	57ca0a13          	addi	s4,s4,1404 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aa4:	00007b97          	auipc	s7,0x7
    80001aa8:	c34b8b93          	addi	s7,s7,-972 # 800086d8 <states.0>
    80001aac:	a00d                	j	80001ace <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001aae:	ed86a583          	lw	a1,-296(a3)
    80001ab2:	8556                	mv	a0,s5
    80001ab4:	00004097          	auipc	ra,0x4
    80001ab8:	710080e7          	jalr	1808(ra) # 800061c4 <printf>
    printf("\n");
    80001abc:	8552                	mv	a0,s4
    80001abe:	00004097          	auipc	ra,0x4
    80001ac2:	706080e7          	jalr	1798(ra) # 800061c4 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ac6:	1e848493          	addi	s1,s1,488
    80001aca:	03248263          	beq	s1,s2,80001aee <procdump+0x9a>
    if(p->state == UNUSED)
    80001ace:	86a6                	mv	a3,s1
    80001ad0:	ec04a783          	lw	a5,-320(s1)
    80001ad4:	dbed                	beqz	a5,80001ac6 <procdump+0x72>
      state = "???";
    80001ad6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ad8:	fcfb6be3          	bltu	s6,a5,80001aae <procdump+0x5a>
    80001adc:	02079713          	slli	a4,a5,0x20
    80001ae0:	01d75793          	srli	a5,a4,0x1d
    80001ae4:	97de                	add	a5,a5,s7
    80001ae6:	6390                	ld	a2,0(a5)
    80001ae8:	f279                	bnez	a2,80001aae <procdump+0x5a>
      state = "???";
    80001aea:	864e                	mv	a2,s3
    80001aec:	b7c9                	j	80001aae <procdump+0x5a>
  }
}
    80001aee:	60a6                	ld	ra,72(sp)
    80001af0:	6406                	ld	s0,64(sp)
    80001af2:	74e2                	ld	s1,56(sp)
    80001af4:	7942                	ld	s2,48(sp)
    80001af6:	79a2                	ld	s3,40(sp)
    80001af8:	7a02                	ld	s4,32(sp)
    80001afa:	6ae2                	ld	s5,24(sp)
    80001afc:	6b42                	ld	s6,16(sp)
    80001afe:	6ba2                	ld	s7,8(sp)
    80001b00:	6161                	addi	sp,sp,80
    80001b02:	8082                	ret

0000000080001b04 <lazy_grow_proc>:
// add process space
int lazy_grow_proc(int n)
{
    80001b04:	1101                	addi	sp,sp,-32
    80001b06:	ec06                	sd	ra,24(sp)
    80001b08:	e822                	sd	s0,16(sp)
    80001b0a:	e426                	sd	s1,8(sp)
    80001b0c:	1000                	addi	s0,sp,32
    80001b0e:	84aa                	mv	s1,a0
  struct proc *p=myproc();
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	35a080e7          	jalr	858(ra) # 80000e6a <myproc>
  p->sz=p->sz+n;
    80001b18:	653c                	ld	a5,72(a0)
    80001b1a:	97a6                	add	a5,a5,s1
    80001b1c:	e53c                	sd	a5,72(a0)
  return 0;
    80001b1e:	4501                	li	a0,0
    80001b20:	60e2                	ld	ra,24(sp)
    80001b22:	6442                	ld	s0,16(sp)
    80001b24:	64a2                	ld	s1,8(sp)
    80001b26:	6105                	addi	sp,sp,32
    80001b28:	8082                	ret

0000000080001b2a <swtch>:
    80001b2a:	00153023          	sd	ra,0(a0)
    80001b2e:	00253423          	sd	sp,8(a0)
    80001b32:	e900                	sd	s0,16(a0)
    80001b34:	ed04                	sd	s1,24(a0)
    80001b36:	03253023          	sd	s2,32(a0)
    80001b3a:	03353423          	sd	s3,40(a0)
    80001b3e:	03453823          	sd	s4,48(a0)
    80001b42:	03553c23          	sd	s5,56(a0)
    80001b46:	05653023          	sd	s6,64(a0)
    80001b4a:	05753423          	sd	s7,72(a0)
    80001b4e:	05853823          	sd	s8,80(a0)
    80001b52:	05953c23          	sd	s9,88(a0)
    80001b56:	07a53023          	sd	s10,96(a0)
    80001b5a:	07b53423          	sd	s11,104(a0)
    80001b5e:	0005b083          	ld	ra,0(a1)
    80001b62:	0085b103          	ld	sp,8(a1)
    80001b66:	6980                	ld	s0,16(a1)
    80001b68:	6d84                	ld	s1,24(a1)
    80001b6a:	0205b903          	ld	s2,32(a1)
    80001b6e:	0285b983          	ld	s3,40(a1)
    80001b72:	0305ba03          	ld	s4,48(a1)
    80001b76:	0385ba83          	ld	s5,56(a1)
    80001b7a:	0405bb03          	ld	s6,64(a1)
    80001b7e:	0485bb83          	ld	s7,72(a1)
    80001b82:	0505bc03          	ld	s8,80(a1)
    80001b86:	0585bc83          	ld	s9,88(a1)
    80001b8a:	0605bd03          	ld	s10,96(a1)
    80001b8e:	0685bd83          	ld	s11,104(a1)
    80001b92:	8082                	ret

0000000080001b94 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b94:	1141                	addi	sp,sp,-16
    80001b96:	e406                	sd	ra,8(sp)
    80001b98:	e022                	sd	s0,0(sp)
    80001b9a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b9c:	00006597          	auipc	a1,0x6
    80001ba0:	66c58593          	addi	a1,a1,1644 # 80008208 <etext+0x208>
    80001ba4:	0000f517          	auipc	a0,0xf
    80001ba8:	2dc50513          	addi	a0,a0,732 # 80010e80 <tickslock>
    80001bac:	00005097          	auipc	ra,0x5
    80001bb0:	ab8080e7          	jalr	-1352(ra) # 80006664 <initlock>
}
    80001bb4:	60a2                	ld	ra,8(sp)
    80001bb6:	6402                	ld	s0,0(sp)
    80001bb8:	0141                	addi	sp,sp,16
    80001bba:	8082                	ret

0000000080001bbc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bbc:	1141                	addi	sp,sp,-16
    80001bbe:	e422                	sd	s0,8(sp)
    80001bc0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bc2:	00004797          	auipc	a5,0x4
    80001bc6:	92e78793          	addi	a5,a5,-1746 # 800054f0 <kernelvec>
    80001bca:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bce:	6422                	ld	s0,8(sp)
    80001bd0:	0141                	addi	sp,sp,16
    80001bd2:	8082                	ret

0000000080001bd4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bd4:	1141                	addi	sp,sp,-16
    80001bd6:	e406                	sd	ra,8(sp)
    80001bd8:	e022                	sd	s0,0(sp)
    80001bda:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bdc:	fffff097          	auipc	ra,0xfffff
    80001be0:	28e080e7          	jalr	654(ra) # 80000e6a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001be4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001be8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bea:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001bee:	00005697          	auipc	a3,0x5
    80001bf2:	41268693          	addi	a3,a3,1042 # 80007000 <_trampoline>
    80001bf6:	00005717          	auipc	a4,0x5
    80001bfa:	40a70713          	addi	a4,a4,1034 # 80007000 <_trampoline>
    80001bfe:	8f15                	sub	a4,a4,a3
    80001c00:	040007b7          	lui	a5,0x4000
    80001c04:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c06:	07b2                	slli	a5,a5,0xc
    80001c08:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c0a:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c0e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c10:	18002673          	csrr	a2,satp
    80001c14:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c16:	6d30                	ld	a2,88(a0)
    80001c18:	6138                	ld	a4,64(a0)
    80001c1a:	6585                	lui	a1,0x1
    80001c1c:	972e                	add	a4,a4,a1
    80001c1e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c20:	6d38                	ld	a4,88(a0)
    80001c22:	00000617          	auipc	a2,0x0
    80001c26:	14060613          	addi	a2,a2,320 # 80001d62 <usertrap>
    80001c2a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c2c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c2e:	8612                	mv	a2,tp
    80001c30:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c32:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c36:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c3a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c3e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c42:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c44:	6f18                	ld	a4,24(a4)
    80001c46:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c4a:	692c                	ld	a1,80(a0)
    80001c4c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c4e:	00005717          	auipc	a4,0x5
    80001c52:	44270713          	addi	a4,a4,1090 # 80007090 <userret>
    80001c56:	8f15                	sub	a4,a4,a3
    80001c58:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c5a:	577d                	li	a4,-1
    80001c5c:	177e                	slli	a4,a4,0x3f
    80001c5e:	8dd9                	or	a1,a1,a4
    80001c60:	02000537          	lui	a0,0x2000
    80001c64:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c66:	0536                	slli	a0,a0,0xd
    80001c68:	9782                	jalr	a5
}
    80001c6a:	60a2                	ld	ra,8(sp)
    80001c6c:	6402                	ld	s0,0(sp)
    80001c6e:	0141                	addi	sp,sp,16
    80001c70:	8082                	ret

0000000080001c72 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c72:	1101                	addi	sp,sp,-32
    80001c74:	ec06                	sd	ra,24(sp)
    80001c76:	e822                	sd	s0,16(sp)
    80001c78:	e426                	sd	s1,8(sp)
    80001c7a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c7c:	0000f497          	auipc	s1,0xf
    80001c80:	20448493          	addi	s1,s1,516 # 80010e80 <tickslock>
    80001c84:	8526                	mv	a0,s1
    80001c86:	00005097          	auipc	ra,0x5
    80001c8a:	a6e080e7          	jalr	-1426(ra) # 800066f4 <acquire>
  ticks++;
    80001c8e:	00007517          	auipc	a0,0x7
    80001c92:	38a50513          	addi	a0,a0,906 # 80009018 <ticks>
    80001c96:	411c                	lw	a5,0(a0)
    80001c98:	2785                	addiw	a5,a5,1
    80001c9a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c9c:	00000097          	auipc	ra,0x0
    80001ca0:	a5a080e7          	jalr	-1446(ra) # 800016f6 <wakeup>
  release(&tickslock);
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	00005097          	auipc	ra,0x5
    80001caa:	b02080e7          	jalr	-1278(ra) # 800067a8 <release>
}
    80001cae:	60e2                	ld	ra,24(sp)
    80001cb0:	6442                	ld	s0,16(sp)
    80001cb2:	64a2                	ld	s1,8(sp)
    80001cb4:	6105                	addi	sp,sp,32
    80001cb6:	8082                	ret

0000000080001cb8 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb8:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cbc:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001cbe:	0a07d163          	bgez	a5,80001d60 <devintr+0xa8>
{
    80001cc2:	1101                	addi	sp,sp,-32
    80001cc4:	ec06                	sd	ra,24(sp)
    80001cc6:	e822                	sd	s0,16(sp)
    80001cc8:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001cca:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001cce:	46a5                	li	a3,9
    80001cd0:	00d70c63          	beq	a4,a3,80001ce8 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001cd4:	577d                	li	a4,-1
    80001cd6:	177e                	slli	a4,a4,0x3f
    80001cd8:	0705                	addi	a4,a4,1
    return 0;
    80001cda:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cdc:	06e78163          	beq	a5,a4,80001d3e <devintr+0x86>
  }
}
    80001ce0:	60e2                	ld	ra,24(sp)
    80001ce2:	6442                	ld	s0,16(sp)
    80001ce4:	6105                	addi	sp,sp,32
    80001ce6:	8082                	ret
    80001ce8:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001cea:	00004097          	auipc	ra,0x4
    80001cee:	912080e7          	jalr	-1774(ra) # 800055fc <plic_claim>
    80001cf2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cf4:	47a9                	li	a5,10
    80001cf6:	00f50963          	beq	a0,a5,80001d08 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001cfa:	4785                	li	a5,1
    80001cfc:	00f50b63          	beq	a0,a5,80001d12 <devintr+0x5a>
    return 1;
    80001d00:	4505                	li	a0,1
    } else if(irq){
    80001d02:	ec89                	bnez	s1,80001d1c <devintr+0x64>
    80001d04:	64a2                	ld	s1,8(sp)
    80001d06:	bfe9                	j	80001ce0 <devintr+0x28>
      uartintr();
    80001d08:	00005097          	auipc	ra,0x5
    80001d0c:	90c080e7          	jalr	-1780(ra) # 80006614 <uartintr>
    if(irq)
    80001d10:	a839                	j	80001d2e <devintr+0x76>
      virtio_disk_intr();
    80001d12:	00004097          	auipc	ra,0x4
    80001d16:	dbe080e7          	jalr	-578(ra) # 80005ad0 <virtio_disk_intr>
    if(irq)
    80001d1a:	a811                	j	80001d2e <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d1c:	85a6                	mv	a1,s1
    80001d1e:	00006517          	auipc	a0,0x6
    80001d22:	4f250513          	addi	a0,a0,1266 # 80008210 <etext+0x210>
    80001d26:	00004097          	auipc	ra,0x4
    80001d2a:	49e080e7          	jalr	1182(ra) # 800061c4 <printf>
      plic_complete(irq);
    80001d2e:	8526                	mv	a0,s1
    80001d30:	00004097          	auipc	ra,0x4
    80001d34:	8f0080e7          	jalr	-1808(ra) # 80005620 <plic_complete>
    return 1;
    80001d38:	4505                	li	a0,1
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	b755                	j	80001ce0 <devintr+0x28>
    if(cpuid() == 0){
    80001d3e:	fffff097          	auipc	ra,0xfffff
    80001d42:	100080e7          	jalr	256(ra) # 80000e3e <cpuid>
    80001d46:	c901                	beqz	a0,80001d56 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d48:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d4c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d4e:	14479073          	csrw	sip,a5
    return 2;
    80001d52:	4509                	li	a0,2
    80001d54:	b771                	j	80001ce0 <devintr+0x28>
      clockintr();
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	f1c080e7          	jalr	-228(ra) # 80001c72 <clockintr>
    80001d5e:	b7ed                	j	80001d48 <devintr+0x90>
}
    80001d60:	8082                	ret

0000000080001d62 <usertrap>:
{
    80001d62:	7139                	addi	sp,sp,-64
    80001d64:	fc06                	sd	ra,56(sp)
    80001d66:	f822                	sd	s0,48(sp)
    80001d68:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d6a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d6e:	1007f793          	andi	a5,a5,256
    80001d72:	e7a5                	bnez	a5,80001dda <usertrap+0x78>
    80001d74:	f426                	sd	s1,40(sp)
    80001d76:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d78:	00003797          	auipc	a5,0x3
    80001d7c:	77878793          	addi	a5,a5,1912 # 800054f0 <kernelvec>
    80001d80:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	0e6080e7          	jalr	230(ra) # 80000e6a <myproc>
    80001d8c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d8e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d90:	14102773          	csrr	a4,sepc
    80001d94:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d96:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d9a:	47a1                	li	a5,8
    80001d9c:	06f71363          	bne	a4,a5,80001e02 <usertrap+0xa0>
    if(p->killed)
    80001da0:	551c                	lw	a5,40(a0)
    80001da2:	ebb1                	bnez	a5,80001df6 <usertrap+0x94>
    p->trapframe->epc += 4;
    80001da4:	6cb8                	ld	a4,88(s1)
    80001da6:	6f1c                	ld	a5,24(a4)
    80001da8:	0791                	addi	a5,a5,4
    80001daa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001db0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001db4:	10079073          	csrw	sstatus,a5
    syscall();
    80001db8:	00000097          	auipc	ra,0x0
    80001dbc:	40c080e7          	jalr	1036(ra) # 800021c4 <syscall>
  if(p->killed)
    80001dc0:	549c                	lw	a5,40(s1)
    80001dc2:	18079763          	bnez	a5,80001f50 <usertrap+0x1ee>
  usertrapret();
    80001dc6:	00000097          	auipc	ra,0x0
    80001dca:	e0e080e7          	jalr	-498(ra) # 80001bd4 <usertrapret>
    80001dce:	74a2                	ld	s1,40(sp)
    80001dd0:	7902                	ld	s2,32(sp)
}
    80001dd2:	70e2                	ld	ra,56(sp)
    80001dd4:	7442                	ld	s0,48(sp)
    80001dd6:	6121                	addi	sp,sp,64
    80001dd8:	8082                	ret
    80001dda:	f426                	sd	s1,40(sp)
    80001ddc:	f04a                	sd	s2,32(sp)
    80001dde:	ec4e                	sd	s3,24(sp)
    80001de0:	e852                	sd	s4,16(sp)
    80001de2:	e456                	sd	s5,8(sp)
    80001de4:	e05a                	sd	s6,0(sp)
    panic("usertrap: not from user mode");
    80001de6:	00006517          	auipc	a0,0x6
    80001dea:	44a50513          	addi	a0,a0,1098 # 80008230 <etext+0x230>
    80001dee:	00004097          	auipc	ra,0x4
    80001df2:	38c080e7          	jalr	908(ra) # 8000617a <panic>
      exit(-1);
    80001df6:	557d                	li	a0,-1
    80001df8:	00000097          	auipc	ra,0x0
    80001dfc:	9ce080e7          	jalr	-1586(ra) # 800017c6 <exit>
    80001e00:	b755                	j	80001da4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	eb6080e7          	jalr	-330(ra) # 80001cb8 <devintr>
    80001e0a:	892a                	mv	s2,a0
    80001e0c:	12051f63          	bnez	a0,80001f4a <usertrap+0x1e8>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e10:	14202773          	csrr	a4,scause
  } else if(r_scause() == 13 || r_scause() == 15){
    80001e14:	47b5                	li	a5,13
    80001e16:	00f70763          	beq	a4,a5,80001e24 <usertrap+0xc2>
    80001e1a:	14202773          	csrr	a4,scause
    80001e1e:	47bd                	li	a5,15
    80001e20:	0ef71d63          	bne	a4,a5,80001f1a <usertrap+0x1b8>
    80001e24:	e456                	sd	s5,8(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e26:	14302af3          	csrr	s5,stval
    if(stval >= p->sz){
    80001e2a:	64bc                	ld	a5,72(s1)
    80001e2c:	12faf463          	bgeu	s5,a5,80001f54 <usertrap+0x1f2>
      uint64 protectTop =PGROUNDDOWN(p->trapframe->sp);
    80001e30:	6cb4                	ld	a3,88(s1)
      uint64 stvalTop =PGROUNDUP(stval);
    80001e32:	6705                	lui	a4,0x1
    80001e34:	fff70793          	addi	a5,a4,-1 # fff <_entry-0x7ffff001>
    80001e38:	97d6                	add	a5,a5,s5
      if(protectTop != stvalTop){
    80001e3a:	7a94                	ld	a3,48(a3)
    80001e3c:	8fb5                	xor	a5,a5,a3
    80001e3e:	12e7eb63          	bltu	a5,a4,80001f74 <usertrap+0x212>
    80001e42:	ec4e                	sd	s3,24(sp)
    80001e44:	e852                	sd	s4,16(sp)
    80001e46:	16848793          	addi	a5,s1,360
        for(i=0;i<NOFILE;i++){
    80001e4a:	874a                	mv	a4,s2
    80001e4c:	4641                	li	a2,16
    80001e4e:	a029                	j	80001e58 <usertrap+0xf6>
    80001e50:	2705                	addiw	a4,a4,1
    80001e52:	07a1                	addi	a5,a5,8
    80001e54:	0ac70563          	beq	a4,a2,80001efe <usertrap+0x19c>
          if(p->areaps[i]==0){
    80001e58:	0007b983          	ld	s3,0(a5)
    80001e5c:	fe098ae3          	beqz	s3,80001e50 <usertrap+0xee>
          addr = (uint64) (p->areaps[i]->addr);
    80001e60:	0009ba03          	ld	s4,0(s3)
          if(addr <= stval && stval < addr +p->areaps[i]->length){
    80001e64:	ff4ae6e3          	bltu	s5,s4,80001e50 <usertrap+0xee>
    80001e68:	0089b683          	ld	a3,8(s3)
    80001e6c:	96d2                	add	a3,a3,s4
    80001e6e:	fedaf1e3          	bgeu	s5,a3,80001e50 <usertrap+0xee>
    80001e72:	e05a                	sd	s6,0(sp)
          char *mem =kalloc();
    80001e74:	ffffe097          	auipc	ra,0xffffe
    80001e78:	2a6080e7          	jalr	678(ra) # 8000011a <kalloc>
    80001e7c:	8b2a                	mv	s6,a0
          if(mem==0){
    80001e7e:	cd6d                	beqz	a0,80001f78 <usertrap+0x216>
            memset(mem,0,PGSIZE);
    80001e80:	6605                	lui	a2,0x1
    80001e82:	4581                	li	a1,0
    80001e84:	855a                	mv	a0,s6
    80001e86:	ffffe097          	auipc	ra,0xffffe
    80001e8a:	2f4080e7          	jalr	756(ra) # 8000017a <memset>
            ilock(vmap->file->ip);
    80001e8e:	0189b783          	ld	a5,24(s3)
    80001e92:	6f88                	ld	a0,24(a5)
    80001e94:	00001097          	auipc	ra,0x1
    80001e98:	e2e080e7          	jalr	-466(ra) # 80002cc2 <ilock>
            readi(vmap->file->ip,0,(uint64)mem,PGROUNDDOWN(stval-addr),PGSIZE);
    80001e9c:	414a86bb          	subw	a3,s5,s4
    80001ea0:	77fd                	lui	a5,0xfffff
    80001ea2:	8efd                	and	a3,a3,a5
    80001ea4:	0189b783          	ld	a5,24(s3)
    80001ea8:	6705                	lui	a4,0x1
    80001eaa:	2681                	sext.w	a3,a3
    80001eac:	865a                	mv	a2,s6
    80001eae:	4581                	li	a1,0
    80001eb0:	6f88                	ld	a0,24(a5)
    80001eb2:	00001097          	auipc	ra,0x1
    80001eb6:	0c8080e7          	jalr	200(ra) # 80002f7a <readi>
            iunlock(vmap->file->ip);
    80001eba:	0189b783          	ld	a5,24(s3)
    80001ebe:	6f88                	ld	a0,24(a5)
    80001ec0:	00001097          	auipc	ra,0x1
    80001ec4:	ec8080e7          	jalr	-312(ra) # 80002d88 <iunlock>
            if(vmap->prot & PROT_READ){
    80001ec8:	0109c783          	lbu	a5,16(s3)
    80001ecc:	0017f693          	andi	a3,a5,1
              prot |= PTE_R;
    80001ed0:	4749                	li	a4,18
            if(vmap->prot & PROT_READ){
    80001ed2:	e291                	bnez	a3,80001ed6 <usertrap+0x174>
          int prot =PTE_U;
    80001ed4:	4741                	li	a4,16
            if(vmap->prot & PROT_WRITE){
    80001ed6:	8b89                	andi	a5,a5,2
    80001ed8:	c399                	beqz	a5,80001ede <usertrap+0x17c>
              prot |= PTE_W;
    80001eda:	00476713          	ori	a4,a4,4
            if(mappages(p->pagetable,PGROUNDDOWN(stval),PGSIZE,(uint64)mem,prot)!=0){
    80001ede:	86da                	mv	a3,s6
    80001ee0:	6605                	lui	a2,0x1
    80001ee2:	75fd                	lui	a1,0xfffff
    80001ee4:	00baf5b3          	and	a1,s5,a1
    80001ee8:	68a8                	ld	a0,80(s1)
    80001eea:	ffffe097          	auipc	ra,0xffffe
    80001eee:	658080e7          	jalr	1624(ra) # 80000542 <mappages>
    80001ef2:	e911                	bnez	a0,80001f06 <usertrap+0x1a4>
    80001ef4:	69e2                	ld	s3,24(sp)
    80001ef6:	6a42                	ld	s4,16(sp)
    80001ef8:	6aa2                	ld	s5,8(sp)
    80001efa:	6b02                	ld	s6,0(sp)
    80001efc:	b5d1                	j	80001dc0 <usertrap+0x5e>
    80001efe:	69e2                	ld	s3,24(sp)
    80001f00:	6a42                	ld	s4,16(sp)
    80001f02:	6aa2                	ld	s5,8(sp)
    80001f04:	a889                	j	80001f56 <usertrap+0x1f4>
              kfree(mem);
    80001f06:	855a                	mv	a0,s6
    80001f08:	ffffe097          	auipc	ra,0xffffe
    80001f0c:	114080e7          	jalr	276(ra) # 8000001c <kfree>
              p->killed =1;
    80001f10:	69e2                	ld	s3,24(sp)
    80001f12:	6a42                	ld	s4,16(sp)
    80001f14:	6aa2                	ld	s5,8(sp)
    80001f16:	6b02                	ld	s6,0(sp)
    80001f18:	a83d                	j	80001f56 <usertrap+0x1f4>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f1a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f1e:	5890                	lw	a2,48(s1)
    80001f20:	00006517          	auipc	a0,0x6
    80001f24:	33050513          	addi	a0,a0,816 # 80008250 <etext+0x250>
    80001f28:	00004097          	auipc	ra,0x4
    80001f2c:	29c080e7          	jalr	668(ra) # 800061c4 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f30:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f34:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f38:	00006517          	auipc	a0,0x6
    80001f3c:	34850513          	addi	a0,a0,840 # 80008280 <etext+0x280>
    80001f40:	00004097          	auipc	ra,0x4
    80001f44:	284080e7          	jalr	644(ra) # 800061c4 <printf>
    p->killed = 1;
    80001f48:	a039                	j	80001f56 <usertrap+0x1f4>
  if(p->killed)
    80001f4a:	549c                	lw	a5,40(s1)
    80001f4c:	cf81                	beqz	a5,80001f64 <usertrap+0x202>
    80001f4e:	a031                	j	80001f5a <usertrap+0x1f8>
    80001f50:	4901                	li	s2,0
    80001f52:	a021                	j	80001f5a <usertrap+0x1f8>
    80001f54:	6aa2                	ld	s5,8(sp)
        p->killed=1;
    80001f56:	4785                	li	a5,1
    80001f58:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001f5a:	557d                	li	a0,-1
    80001f5c:	00000097          	auipc	ra,0x0
    80001f60:	86a080e7          	jalr	-1942(ra) # 800017c6 <exit>
  if(which_dev == 2)
    80001f64:	4789                	li	a5,2
    80001f66:	e6f910e3          	bne	s2,a5,80001dc6 <usertrap+0x64>
    yield();
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	5c4080e7          	jalr	1476(ra) # 8000152e <yield>
    80001f72:	bd91                	j	80001dc6 <usertrap+0x64>
    80001f74:	6aa2                	ld	s5,8(sp)
    80001f76:	b7c5                	j	80001f56 <usertrap+0x1f4>
    80001f78:	69e2                	ld	s3,24(sp)
    80001f7a:	6a42                	ld	s4,16(sp)
    80001f7c:	6aa2                	ld	s5,8(sp)
    80001f7e:	6b02                	ld	s6,0(sp)
    80001f80:	bfd9                	j	80001f56 <usertrap+0x1f4>

0000000080001f82 <kerneltrap>:
{
    80001f82:	7179                	addi	sp,sp,-48
    80001f84:	f406                	sd	ra,40(sp)
    80001f86:	f022                	sd	s0,32(sp)
    80001f88:	ec26                	sd	s1,24(sp)
    80001f8a:	e84a                	sd	s2,16(sp)
    80001f8c:	e44e                	sd	s3,8(sp)
    80001f8e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f90:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f94:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f98:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f9c:	1004f793          	andi	a5,s1,256
    80001fa0:	cb85                	beqz	a5,80001fd0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fa2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fa6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001fa8:	ef85                	bnez	a5,80001fe0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001faa:	00000097          	auipc	ra,0x0
    80001fae:	d0e080e7          	jalr	-754(ra) # 80001cb8 <devintr>
    80001fb2:	cd1d                	beqz	a0,80001ff0 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fb4:	4789                	li	a5,2
    80001fb6:	06f50a63          	beq	a0,a5,8000202a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fba:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fbe:	10049073          	csrw	sstatus,s1
}
    80001fc2:	70a2                	ld	ra,40(sp)
    80001fc4:	7402                	ld	s0,32(sp)
    80001fc6:	64e2                	ld	s1,24(sp)
    80001fc8:	6942                	ld	s2,16(sp)
    80001fca:	69a2                	ld	s3,8(sp)
    80001fcc:	6145                	addi	sp,sp,48
    80001fce:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fd0:	00006517          	auipc	a0,0x6
    80001fd4:	2d050513          	addi	a0,a0,720 # 800082a0 <etext+0x2a0>
    80001fd8:	00004097          	auipc	ra,0x4
    80001fdc:	1a2080e7          	jalr	418(ra) # 8000617a <panic>
    panic("kerneltrap: interrupts enabled");
    80001fe0:	00006517          	auipc	a0,0x6
    80001fe4:	2e850513          	addi	a0,a0,744 # 800082c8 <etext+0x2c8>
    80001fe8:	00004097          	auipc	ra,0x4
    80001fec:	192080e7          	jalr	402(ra) # 8000617a <panic>
    printf("scause %p\n", scause);
    80001ff0:	85ce                	mv	a1,s3
    80001ff2:	00006517          	auipc	a0,0x6
    80001ff6:	2f650513          	addi	a0,a0,758 # 800082e8 <etext+0x2e8>
    80001ffa:	00004097          	auipc	ra,0x4
    80001ffe:	1ca080e7          	jalr	458(ra) # 800061c4 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002002:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002006:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000200a:	00006517          	auipc	a0,0x6
    8000200e:	2ee50513          	addi	a0,a0,750 # 800082f8 <etext+0x2f8>
    80002012:	00004097          	auipc	ra,0x4
    80002016:	1b2080e7          	jalr	434(ra) # 800061c4 <printf>
    panic("kerneltrap");
    8000201a:	00006517          	auipc	a0,0x6
    8000201e:	2f650513          	addi	a0,a0,758 # 80008310 <etext+0x310>
    80002022:	00004097          	auipc	ra,0x4
    80002026:	158080e7          	jalr	344(ra) # 8000617a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	e40080e7          	jalr	-448(ra) # 80000e6a <myproc>
    80002032:	d541                	beqz	a0,80001fba <kerneltrap+0x38>
    80002034:	fffff097          	auipc	ra,0xfffff
    80002038:	e36080e7          	jalr	-458(ra) # 80000e6a <myproc>
    8000203c:	4d18                	lw	a4,24(a0)
    8000203e:	4791                	li	a5,4
    80002040:	f6f71de3          	bne	a4,a5,80001fba <kerneltrap+0x38>
    yield();
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	4ea080e7          	jalr	1258(ra) # 8000152e <yield>
    8000204c:	b7bd                	j	80001fba <kerneltrap+0x38>

000000008000204e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000204e:	1101                	addi	sp,sp,-32
    80002050:	ec06                	sd	ra,24(sp)
    80002052:	e822                	sd	s0,16(sp)
    80002054:	e426                	sd	s1,8(sp)
    80002056:	1000                	addi	s0,sp,32
    80002058:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	e10080e7          	jalr	-496(ra) # 80000e6a <myproc>
  switch (n) {
    80002062:	4795                	li	a5,5
    80002064:	0497e163          	bltu	a5,s1,800020a6 <argraw+0x58>
    80002068:	048a                	slli	s1,s1,0x2
    8000206a:	00006717          	auipc	a4,0x6
    8000206e:	69e70713          	addi	a4,a4,1694 # 80008708 <states.0+0x30>
    80002072:	94ba                	add	s1,s1,a4
    80002074:	409c                	lw	a5,0(s1)
    80002076:	97ba                	add	a5,a5,a4
    80002078:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000207a:	6d3c                	ld	a5,88(a0)
    8000207c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000207e:	60e2                	ld	ra,24(sp)
    80002080:	6442                	ld	s0,16(sp)
    80002082:	64a2                	ld	s1,8(sp)
    80002084:	6105                	addi	sp,sp,32
    80002086:	8082                	ret
    return p->trapframe->a1;
    80002088:	6d3c                	ld	a5,88(a0)
    8000208a:	7fa8                	ld	a0,120(a5)
    8000208c:	bfcd                	j	8000207e <argraw+0x30>
    return p->trapframe->a2;
    8000208e:	6d3c                	ld	a5,88(a0)
    80002090:	63c8                	ld	a0,128(a5)
    80002092:	b7f5                	j	8000207e <argraw+0x30>
    return p->trapframe->a3;
    80002094:	6d3c                	ld	a5,88(a0)
    80002096:	67c8                	ld	a0,136(a5)
    80002098:	b7dd                	j	8000207e <argraw+0x30>
    return p->trapframe->a4;
    8000209a:	6d3c                	ld	a5,88(a0)
    8000209c:	6bc8                	ld	a0,144(a5)
    8000209e:	b7c5                	j	8000207e <argraw+0x30>
    return p->trapframe->a5;
    800020a0:	6d3c                	ld	a5,88(a0)
    800020a2:	6fc8                	ld	a0,152(a5)
    800020a4:	bfe9                	j	8000207e <argraw+0x30>
  panic("argraw");
    800020a6:	00006517          	auipc	a0,0x6
    800020aa:	27a50513          	addi	a0,a0,634 # 80008320 <etext+0x320>
    800020ae:	00004097          	auipc	ra,0x4
    800020b2:	0cc080e7          	jalr	204(ra) # 8000617a <panic>

00000000800020b6 <fetchaddr>:
{
    800020b6:	1101                	addi	sp,sp,-32
    800020b8:	ec06                	sd	ra,24(sp)
    800020ba:	e822                	sd	s0,16(sp)
    800020bc:	e426                	sd	s1,8(sp)
    800020be:	e04a                	sd	s2,0(sp)
    800020c0:	1000                	addi	s0,sp,32
    800020c2:	84aa                	mv	s1,a0
    800020c4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	da4080e7          	jalr	-604(ra) # 80000e6a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020ce:	653c                	ld	a5,72(a0)
    800020d0:	02f4f863          	bgeu	s1,a5,80002100 <fetchaddr+0x4a>
    800020d4:	00848713          	addi	a4,s1,8
    800020d8:	02e7e663          	bltu	a5,a4,80002104 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020dc:	46a1                	li	a3,8
    800020de:	8626                	mv	a2,s1
    800020e0:	85ca                	mv	a1,s2
    800020e2:	6928                	ld	a0,80(a0)
    800020e4:	fffff097          	auipc	ra,0xfffff
    800020e8:	aae080e7          	jalr	-1362(ra) # 80000b92 <copyin>
    800020ec:	00a03533          	snez	a0,a0
    800020f0:	40a00533          	neg	a0,a0
}
    800020f4:	60e2                	ld	ra,24(sp)
    800020f6:	6442                	ld	s0,16(sp)
    800020f8:	64a2                	ld	s1,8(sp)
    800020fa:	6902                	ld	s2,0(sp)
    800020fc:	6105                	addi	sp,sp,32
    800020fe:	8082                	ret
    return -1;
    80002100:	557d                	li	a0,-1
    80002102:	bfcd                	j	800020f4 <fetchaddr+0x3e>
    80002104:	557d                	li	a0,-1
    80002106:	b7fd                	j	800020f4 <fetchaddr+0x3e>

0000000080002108 <fetchstr>:
{
    80002108:	7179                	addi	sp,sp,-48
    8000210a:	f406                	sd	ra,40(sp)
    8000210c:	f022                	sd	s0,32(sp)
    8000210e:	ec26                	sd	s1,24(sp)
    80002110:	e84a                	sd	s2,16(sp)
    80002112:	e44e                	sd	s3,8(sp)
    80002114:	1800                	addi	s0,sp,48
    80002116:	892a                	mv	s2,a0
    80002118:	84ae                	mv	s1,a1
    8000211a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	d4e080e7          	jalr	-690(ra) # 80000e6a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002124:	86ce                	mv	a3,s3
    80002126:	864a                	mv	a2,s2
    80002128:	85a6                	mv	a1,s1
    8000212a:	6928                	ld	a0,80(a0)
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	af4080e7          	jalr	-1292(ra) # 80000c20 <copyinstr>
  if(err < 0)
    80002134:	00054763          	bltz	a0,80002142 <fetchstr+0x3a>
  return strlen(buf);
    80002138:	8526                	mv	a0,s1
    8000213a:	ffffe097          	auipc	ra,0xffffe
    8000213e:	1b4080e7          	jalr	436(ra) # 800002ee <strlen>
}
    80002142:	70a2                	ld	ra,40(sp)
    80002144:	7402                	ld	s0,32(sp)
    80002146:	64e2                	ld	s1,24(sp)
    80002148:	6942                	ld	s2,16(sp)
    8000214a:	69a2                	ld	s3,8(sp)
    8000214c:	6145                	addi	sp,sp,48
    8000214e:	8082                	ret

0000000080002150 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002150:	1101                	addi	sp,sp,-32
    80002152:	ec06                	sd	ra,24(sp)
    80002154:	e822                	sd	s0,16(sp)
    80002156:	e426                	sd	s1,8(sp)
    80002158:	1000                	addi	s0,sp,32
    8000215a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	ef2080e7          	jalr	-270(ra) # 8000204e <argraw>
    80002164:	c088                	sw	a0,0(s1)
  return 0;
}
    80002166:	4501                	li	a0,0
    80002168:	60e2                	ld	ra,24(sp)
    8000216a:	6442                	ld	s0,16(sp)
    8000216c:	64a2                	ld	s1,8(sp)
    8000216e:	6105                	addi	sp,sp,32
    80002170:	8082                	ret

0000000080002172 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002172:	1101                	addi	sp,sp,-32
    80002174:	ec06                	sd	ra,24(sp)
    80002176:	e822                	sd	s0,16(sp)
    80002178:	e426                	sd	s1,8(sp)
    8000217a:	1000                	addi	s0,sp,32
    8000217c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000217e:	00000097          	auipc	ra,0x0
    80002182:	ed0080e7          	jalr	-304(ra) # 8000204e <argraw>
    80002186:	e088                	sd	a0,0(s1)
  return 0;
}
    80002188:	4501                	li	a0,0
    8000218a:	60e2                	ld	ra,24(sp)
    8000218c:	6442                	ld	s0,16(sp)
    8000218e:	64a2                	ld	s1,8(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	e04a                	sd	s2,0(sp)
    8000219e:	1000                	addi	s0,sp,32
    800021a0:	84ae                	mv	s1,a1
    800021a2:	8932                	mv	s2,a2
  *ip = argraw(n);
    800021a4:	00000097          	auipc	ra,0x0
    800021a8:	eaa080e7          	jalr	-342(ra) # 8000204e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021ac:	864a                	mv	a2,s2
    800021ae:	85a6                	mv	a1,s1
    800021b0:	00000097          	auipc	ra,0x0
    800021b4:	f58080e7          	jalr	-168(ra) # 80002108 <fetchstr>
}
    800021b8:	60e2                	ld	ra,24(sp)
    800021ba:	6442                	ld	s0,16(sp)
    800021bc:	64a2                	ld	s1,8(sp)
    800021be:	6902                	ld	s2,0(sp)
    800021c0:	6105                	addi	sp,sp,32
    800021c2:	8082                	ret

00000000800021c4 <syscall>:
[SYS_munmap]   sys_munmap,
};

void
syscall(void)
{
    800021c4:	1101                	addi	sp,sp,-32
    800021c6:	ec06                	sd	ra,24(sp)
    800021c8:	e822                	sd	s0,16(sp)
    800021ca:	e426                	sd	s1,8(sp)
    800021cc:	e04a                	sd	s2,0(sp)
    800021ce:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	c9a080e7          	jalr	-870(ra) # 80000e6a <myproc>
    800021d8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021da:	05853903          	ld	s2,88(a0)
    800021de:	0a893783          	ld	a5,168(s2)
    800021e2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021e6:	37fd                	addiw	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffd6b9f>
    800021e8:	4759                	li	a4,22
    800021ea:	00f76f63          	bltu	a4,a5,80002208 <syscall+0x44>
    800021ee:	00369713          	slli	a4,a3,0x3
    800021f2:	00006797          	auipc	a5,0x6
    800021f6:	52e78793          	addi	a5,a5,1326 # 80008720 <syscalls>
    800021fa:	97ba                	add	a5,a5,a4
    800021fc:	639c                	ld	a5,0(a5)
    800021fe:	c789                	beqz	a5,80002208 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002200:	9782                	jalr	a5
    80002202:	06a93823          	sd	a0,112(s2)
    80002206:	a839                	j	80002224 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002208:	15848613          	addi	a2,s1,344
    8000220c:	588c                	lw	a1,48(s1)
    8000220e:	00006517          	auipc	a0,0x6
    80002212:	11a50513          	addi	a0,a0,282 # 80008328 <etext+0x328>
    80002216:	00004097          	auipc	ra,0x4
    8000221a:	fae080e7          	jalr	-82(ra) # 800061c4 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000221e:	6cbc                	ld	a5,88(s1)
    80002220:	577d                	li	a4,-1
    80002222:	fbb8                	sd	a4,112(a5)
  }
}
    80002224:	60e2                	ld	ra,24(sp)
    80002226:	6442                	ld	s0,16(sp)
    80002228:	64a2                	ld	s1,8(sp)
    8000222a:	6902                	ld	s2,0(sp)
    8000222c:	6105                	addi	sp,sp,32
    8000222e:	8082                	ret

0000000080002230 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002230:	1101                	addi	sp,sp,-32
    80002232:	ec06                	sd	ra,24(sp)
    80002234:	e822                	sd	s0,16(sp)
    80002236:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002238:	fec40593          	addi	a1,s0,-20
    8000223c:	4501                	li	a0,0
    8000223e:	00000097          	auipc	ra,0x0
    80002242:	f12080e7          	jalr	-238(ra) # 80002150 <argint>
    return -1;
    80002246:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002248:	00054963          	bltz	a0,8000225a <sys_exit+0x2a>
  exit(n);
    8000224c:	fec42503          	lw	a0,-20(s0)
    80002250:	fffff097          	auipc	ra,0xfffff
    80002254:	576080e7          	jalr	1398(ra) # 800017c6 <exit>
  return 0;  // not reached
    80002258:	4781                	li	a5,0
}
    8000225a:	853e                	mv	a0,a5
    8000225c:	60e2                	ld	ra,24(sp)
    8000225e:	6442                	ld	s0,16(sp)
    80002260:	6105                	addi	sp,sp,32
    80002262:	8082                	ret

0000000080002264 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002264:	1141                	addi	sp,sp,-16
    80002266:	e406                	sd	ra,8(sp)
    80002268:	e022                	sd	s0,0(sp)
    8000226a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	bfe080e7          	jalr	-1026(ra) # 80000e6a <myproc>
}
    80002274:	5908                	lw	a0,48(a0)
    80002276:	60a2                	ld	ra,8(sp)
    80002278:	6402                	ld	s0,0(sp)
    8000227a:	0141                	addi	sp,sp,16
    8000227c:	8082                	ret

000000008000227e <sys_fork>:

uint64
sys_fork(void)
{
    8000227e:	1141                	addi	sp,sp,-16
    80002280:	e406                	sd	ra,8(sp)
    80002282:	e022                	sd	s0,0(sp)
    80002284:	0800                	addi	s0,sp,16
  return fork();
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	fb6080e7          	jalr	-74(ra) # 8000123c <fork>
}
    8000228e:	60a2                	ld	ra,8(sp)
    80002290:	6402                	ld	s0,0(sp)
    80002292:	0141                	addi	sp,sp,16
    80002294:	8082                	ret

0000000080002296 <sys_wait>:

uint64
sys_wait(void)
{
    80002296:	1101                	addi	sp,sp,-32
    80002298:	ec06                	sd	ra,24(sp)
    8000229a:	e822                	sd	s0,16(sp)
    8000229c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000229e:	fe840593          	addi	a1,s0,-24
    800022a2:	4501                	li	a0,0
    800022a4:	00000097          	auipc	ra,0x0
    800022a8:	ece080e7          	jalr	-306(ra) # 80002172 <argaddr>
    800022ac:	87aa                	mv	a5,a0
    return -1;
    800022ae:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800022b0:	0007c863          	bltz	a5,800022c0 <sys_wait+0x2a>
  return wait(p);
    800022b4:	fe843503          	ld	a0,-24(s0)
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	316080e7          	jalr	790(ra) # 800015ce <wait>
}
    800022c0:	60e2                	ld	ra,24(sp)
    800022c2:	6442                	ld	s0,16(sp)
    800022c4:	6105                	addi	sp,sp,32
    800022c6:	8082                	ret

00000000800022c8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022c8:	7179                	addi	sp,sp,-48
    800022ca:	f406                	sd	ra,40(sp)
    800022cc:	f022                	sd	s0,32(sp)
    800022ce:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022d0:	fdc40593          	addi	a1,s0,-36
    800022d4:	4501                	li	a0,0
    800022d6:	00000097          	auipc	ra,0x0
    800022da:	e7a080e7          	jalr	-390(ra) # 80002150 <argint>
    800022de:	87aa                	mv	a5,a0
    return -1;
    800022e0:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022e2:	0207c263          	bltz	a5,80002306 <sys_sbrk+0x3e>
    800022e6:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	b82080e7          	jalr	-1150(ra) # 80000e6a <myproc>
    800022f0:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800022f2:	fdc42503          	lw	a0,-36(s0)
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	ece080e7          	jalr	-306(ra) # 800011c4 <growproc>
    800022fe:	00054863          	bltz	a0,8000230e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002302:	8526                	mv	a0,s1
    80002304:	64e2                	ld	s1,24(sp)
}
    80002306:	70a2                	ld	ra,40(sp)
    80002308:	7402                	ld	s0,32(sp)
    8000230a:	6145                	addi	sp,sp,48
    8000230c:	8082                	ret
    return -1;
    8000230e:	557d                	li	a0,-1
    80002310:	64e2                	ld	s1,24(sp)
    80002312:	bfd5                	j	80002306 <sys_sbrk+0x3e>

0000000080002314 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002314:	7139                	addi	sp,sp,-64
    80002316:	fc06                	sd	ra,56(sp)
    80002318:	f822                	sd	s0,48(sp)
    8000231a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000231c:	fcc40593          	addi	a1,s0,-52
    80002320:	4501                	li	a0,0
    80002322:	00000097          	auipc	ra,0x0
    80002326:	e2e080e7          	jalr	-466(ra) # 80002150 <argint>
    return -1;
    8000232a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000232c:	06054b63          	bltz	a0,800023a2 <sys_sleep+0x8e>
    80002330:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002332:	0000f517          	auipc	a0,0xf
    80002336:	b4e50513          	addi	a0,a0,-1202 # 80010e80 <tickslock>
    8000233a:	00004097          	auipc	ra,0x4
    8000233e:	3ba080e7          	jalr	954(ra) # 800066f4 <acquire>
  ticks0 = ticks;
    80002342:	00007917          	auipc	s2,0x7
    80002346:	cd692903          	lw	s2,-810(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000234a:	fcc42783          	lw	a5,-52(s0)
    8000234e:	c3a1                	beqz	a5,8000238e <sys_sleep+0x7a>
    80002350:	f426                	sd	s1,40(sp)
    80002352:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002354:	0000f997          	auipc	s3,0xf
    80002358:	b2c98993          	addi	s3,s3,-1236 # 80010e80 <tickslock>
    8000235c:	00007497          	auipc	s1,0x7
    80002360:	cbc48493          	addi	s1,s1,-836 # 80009018 <ticks>
    if(myproc()->killed){
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	b06080e7          	jalr	-1274(ra) # 80000e6a <myproc>
    8000236c:	551c                	lw	a5,40(a0)
    8000236e:	ef9d                	bnez	a5,800023ac <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002370:	85ce                	mv	a1,s3
    80002372:	8526                	mv	a0,s1
    80002374:	fffff097          	auipc	ra,0xfffff
    80002378:	1f6080e7          	jalr	502(ra) # 8000156a <sleep>
  while(ticks - ticks0 < n){
    8000237c:	409c                	lw	a5,0(s1)
    8000237e:	412787bb          	subw	a5,a5,s2
    80002382:	fcc42703          	lw	a4,-52(s0)
    80002386:	fce7efe3          	bltu	a5,a4,80002364 <sys_sleep+0x50>
    8000238a:	74a2                	ld	s1,40(sp)
    8000238c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000238e:	0000f517          	auipc	a0,0xf
    80002392:	af250513          	addi	a0,a0,-1294 # 80010e80 <tickslock>
    80002396:	00004097          	auipc	ra,0x4
    8000239a:	412080e7          	jalr	1042(ra) # 800067a8 <release>
  return 0;
    8000239e:	4781                	li	a5,0
    800023a0:	7902                	ld	s2,32(sp)
}
    800023a2:	853e                	mv	a0,a5
    800023a4:	70e2                	ld	ra,56(sp)
    800023a6:	7442                	ld	s0,48(sp)
    800023a8:	6121                	addi	sp,sp,64
    800023aa:	8082                	ret
      release(&tickslock);
    800023ac:	0000f517          	auipc	a0,0xf
    800023b0:	ad450513          	addi	a0,a0,-1324 # 80010e80 <tickslock>
    800023b4:	00004097          	auipc	ra,0x4
    800023b8:	3f4080e7          	jalr	1012(ra) # 800067a8 <release>
      return -1;
    800023bc:	57fd                	li	a5,-1
    800023be:	74a2                	ld	s1,40(sp)
    800023c0:	7902                	ld	s2,32(sp)
    800023c2:	69e2                	ld	s3,24(sp)
    800023c4:	bff9                	j	800023a2 <sys_sleep+0x8e>

00000000800023c6 <sys_kill>:

uint64
sys_kill(void)
{
    800023c6:	1101                	addi	sp,sp,-32
    800023c8:	ec06                	sd	ra,24(sp)
    800023ca:	e822                	sd	s0,16(sp)
    800023cc:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023ce:	fec40593          	addi	a1,s0,-20
    800023d2:	4501                	li	a0,0
    800023d4:	00000097          	auipc	ra,0x0
    800023d8:	d7c080e7          	jalr	-644(ra) # 80002150 <argint>
    800023dc:	87aa                	mv	a5,a0
    return -1;
    800023de:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800023e0:	0007c863          	bltz	a5,800023f0 <sys_kill+0x2a>
  return kill(pid);
    800023e4:	fec42503          	lw	a0,-20(s0)
    800023e8:	fffff097          	auipc	ra,0xfffff
    800023ec:	54e080e7          	jalr	1358(ra) # 80001936 <kill>
}
    800023f0:	60e2                	ld	ra,24(sp)
    800023f2:	6442                	ld	s0,16(sp)
    800023f4:	6105                	addi	sp,sp,32
    800023f6:	8082                	ret

00000000800023f8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023f8:	1101                	addi	sp,sp,-32
    800023fa:	ec06                	sd	ra,24(sp)
    800023fc:	e822                	sd	s0,16(sp)
    800023fe:	e426                	sd	s1,8(sp)
    80002400:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002402:	0000f517          	auipc	a0,0xf
    80002406:	a7e50513          	addi	a0,a0,-1410 # 80010e80 <tickslock>
    8000240a:	00004097          	auipc	ra,0x4
    8000240e:	2ea080e7          	jalr	746(ra) # 800066f4 <acquire>
  xticks = ticks;
    80002412:	00007497          	auipc	s1,0x7
    80002416:	c064a483          	lw	s1,-1018(s1) # 80009018 <ticks>
  release(&tickslock);
    8000241a:	0000f517          	auipc	a0,0xf
    8000241e:	a6650513          	addi	a0,a0,-1434 # 80010e80 <tickslock>
    80002422:	00004097          	auipc	ra,0x4
    80002426:	386080e7          	jalr	902(ra) # 800067a8 <release>
  return xticks;
}
    8000242a:	02049513          	slli	a0,s1,0x20
    8000242e:	9101                	srli	a0,a0,0x20
    80002430:	60e2                	ld	ra,24(sp)
    80002432:	6442                	ld	s0,16(sp)
    80002434:	64a2                	ld	s1,8(sp)
    80002436:	6105                	addi	sp,sp,32
    80002438:	8082                	ret

000000008000243a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000243a:	7179                	addi	sp,sp,-48
    8000243c:	f406                	sd	ra,40(sp)
    8000243e:	f022                	sd	s0,32(sp)
    80002440:	ec26                	sd	s1,24(sp)
    80002442:	e84a                	sd	s2,16(sp)
    80002444:	e44e                	sd	s3,8(sp)
    80002446:	e052                	sd	s4,0(sp)
    80002448:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000244a:	00006597          	auipc	a1,0x6
    8000244e:	efe58593          	addi	a1,a1,-258 # 80008348 <etext+0x348>
    80002452:	0000f517          	auipc	a0,0xf
    80002456:	a4650513          	addi	a0,a0,-1466 # 80010e98 <bcache>
    8000245a:	00004097          	auipc	ra,0x4
    8000245e:	20a080e7          	jalr	522(ra) # 80006664 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002462:	00017797          	auipc	a5,0x17
    80002466:	a3678793          	addi	a5,a5,-1482 # 80018e98 <bcache+0x8000>
    8000246a:	00017717          	auipc	a4,0x17
    8000246e:	c9670713          	addi	a4,a4,-874 # 80019100 <bcache+0x8268>
    80002472:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002476:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000247a:	0000f497          	auipc	s1,0xf
    8000247e:	a3648493          	addi	s1,s1,-1482 # 80010eb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002482:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002484:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002486:	00006a17          	auipc	s4,0x6
    8000248a:	ecaa0a13          	addi	s4,s4,-310 # 80008350 <etext+0x350>
    b->next = bcache.head.next;
    8000248e:	2b893783          	ld	a5,696(s2)
    80002492:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002494:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002498:	85d2                	mv	a1,s4
    8000249a:	01048513          	addi	a0,s1,16
    8000249e:	00001097          	auipc	ra,0x1
    800024a2:	4b2080e7          	jalr	1202(ra) # 80003950 <initsleeplock>
    bcache.head.next->prev = b;
    800024a6:	2b893783          	ld	a5,696(s2)
    800024aa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024ac:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024b0:	45848493          	addi	s1,s1,1112
    800024b4:	fd349de3          	bne	s1,s3,8000248e <binit+0x54>
  }
}
    800024b8:	70a2                	ld	ra,40(sp)
    800024ba:	7402                	ld	s0,32(sp)
    800024bc:	64e2                	ld	s1,24(sp)
    800024be:	6942                	ld	s2,16(sp)
    800024c0:	69a2                	ld	s3,8(sp)
    800024c2:	6a02                	ld	s4,0(sp)
    800024c4:	6145                	addi	sp,sp,48
    800024c6:	8082                	ret

00000000800024c8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024c8:	7179                	addi	sp,sp,-48
    800024ca:	f406                	sd	ra,40(sp)
    800024cc:	f022                	sd	s0,32(sp)
    800024ce:	ec26                	sd	s1,24(sp)
    800024d0:	e84a                	sd	s2,16(sp)
    800024d2:	e44e                	sd	s3,8(sp)
    800024d4:	1800                	addi	s0,sp,48
    800024d6:	892a                	mv	s2,a0
    800024d8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800024da:	0000f517          	auipc	a0,0xf
    800024de:	9be50513          	addi	a0,a0,-1602 # 80010e98 <bcache>
    800024e2:	00004097          	auipc	ra,0x4
    800024e6:	212080e7          	jalr	530(ra) # 800066f4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024ea:	00017497          	auipc	s1,0x17
    800024ee:	c664b483          	ld	s1,-922(s1) # 80019150 <bcache+0x82b8>
    800024f2:	00017797          	auipc	a5,0x17
    800024f6:	c0e78793          	addi	a5,a5,-1010 # 80019100 <bcache+0x8268>
    800024fa:	02f48f63          	beq	s1,a5,80002538 <bread+0x70>
    800024fe:	873e                	mv	a4,a5
    80002500:	a021                	j	80002508 <bread+0x40>
    80002502:	68a4                	ld	s1,80(s1)
    80002504:	02e48a63          	beq	s1,a4,80002538 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002508:	449c                	lw	a5,8(s1)
    8000250a:	ff279ce3          	bne	a5,s2,80002502 <bread+0x3a>
    8000250e:	44dc                	lw	a5,12(s1)
    80002510:	ff3799e3          	bne	a5,s3,80002502 <bread+0x3a>
      b->refcnt++;
    80002514:	40bc                	lw	a5,64(s1)
    80002516:	2785                	addiw	a5,a5,1
    80002518:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000251a:	0000f517          	auipc	a0,0xf
    8000251e:	97e50513          	addi	a0,a0,-1666 # 80010e98 <bcache>
    80002522:	00004097          	auipc	ra,0x4
    80002526:	286080e7          	jalr	646(ra) # 800067a8 <release>
      acquiresleep(&b->lock);
    8000252a:	01048513          	addi	a0,s1,16
    8000252e:	00001097          	auipc	ra,0x1
    80002532:	45c080e7          	jalr	1116(ra) # 8000398a <acquiresleep>
      return b;
    80002536:	a8b9                	j	80002594 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002538:	00017497          	auipc	s1,0x17
    8000253c:	c104b483          	ld	s1,-1008(s1) # 80019148 <bcache+0x82b0>
    80002540:	00017797          	auipc	a5,0x17
    80002544:	bc078793          	addi	a5,a5,-1088 # 80019100 <bcache+0x8268>
    80002548:	00f48863          	beq	s1,a5,80002558 <bread+0x90>
    8000254c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000254e:	40bc                	lw	a5,64(s1)
    80002550:	cf81                	beqz	a5,80002568 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002552:	64a4                	ld	s1,72(s1)
    80002554:	fee49de3          	bne	s1,a4,8000254e <bread+0x86>
  panic("bget: no buffers");
    80002558:	00006517          	auipc	a0,0x6
    8000255c:	e0050513          	addi	a0,a0,-512 # 80008358 <etext+0x358>
    80002560:	00004097          	auipc	ra,0x4
    80002564:	c1a080e7          	jalr	-998(ra) # 8000617a <panic>
      b->dev = dev;
    80002568:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000256c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002570:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002574:	4785                	li	a5,1
    80002576:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002578:	0000f517          	auipc	a0,0xf
    8000257c:	92050513          	addi	a0,a0,-1760 # 80010e98 <bcache>
    80002580:	00004097          	auipc	ra,0x4
    80002584:	228080e7          	jalr	552(ra) # 800067a8 <release>
      acquiresleep(&b->lock);
    80002588:	01048513          	addi	a0,s1,16
    8000258c:	00001097          	auipc	ra,0x1
    80002590:	3fe080e7          	jalr	1022(ra) # 8000398a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002594:	409c                	lw	a5,0(s1)
    80002596:	cb89                	beqz	a5,800025a8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002598:	8526                	mv	a0,s1
    8000259a:	70a2                	ld	ra,40(sp)
    8000259c:	7402                	ld	s0,32(sp)
    8000259e:	64e2                	ld	s1,24(sp)
    800025a0:	6942                	ld	s2,16(sp)
    800025a2:	69a2                	ld	s3,8(sp)
    800025a4:	6145                	addi	sp,sp,48
    800025a6:	8082                	ret
    virtio_disk_rw(b, 0);
    800025a8:	4581                	li	a1,0
    800025aa:	8526                	mv	a0,s1
    800025ac:	00003097          	auipc	ra,0x3
    800025b0:	296080e7          	jalr	662(ra) # 80005842 <virtio_disk_rw>
    b->valid = 1;
    800025b4:	4785                	li	a5,1
    800025b6:	c09c                	sw	a5,0(s1)
  return b;
    800025b8:	b7c5                	j	80002598 <bread+0xd0>

00000000800025ba <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025ba:	1101                	addi	sp,sp,-32
    800025bc:	ec06                	sd	ra,24(sp)
    800025be:	e822                	sd	s0,16(sp)
    800025c0:	e426                	sd	s1,8(sp)
    800025c2:	1000                	addi	s0,sp,32
    800025c4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025c6:	0541                	addi	a0,a0,16
    800025c8:	00001097          	auipc	ra,0x1
    800025cc:	45c080e7          	jalr	1116(ra) # 80003a24 <holdingsleep>
    800025d0:	cd01                	beqz	a0,800025e8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025d2:	4585                	li	a1,1
    800025d4:	8526                	mv	a0,s1
    800025d6:	00003097          	auipc	ra,0x3
    800025da:	26c080e7          	jalr	620(ra) # 80005842 <virtio_disk_rw>
}
    800025de:	60e2                	ld	ra,24(sp)
    800025e0:	6442                	ld	s0,16(sp)
    800025e2:	64a2                	ld	s1,8(sp)
    800025e4:	6105                	addi	sp,sp,32
    800025e6:	8082                	ret
    panic("bwrite");
    800025e8:	00006517          	auipc	a0,0x6
    800025ec:	d8850513          	addi	a0,a0,-632 # 80008370 <etext+0x370>
    800025f0:	00004097          	auipc	ra,0x4
    800025f4:	b8a080e7          	jalr	-1142(ra) # 8000617a <panic>

00000000800025f8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025f8:	1101                	addi	sp,sp,-32
    800025fa:	ec06                	sd	ra,24(sp)
    800025fc:	e822                	sd	s0,16(sp)
    800025fe:	e426                	sd	s1,8(sp)
    80002600:	e04a                	sd	s2,0(sp)
    80002602:	1000                	addi	s0,sp,32
    80002604:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002606:	01050913          	addi	s2,a0,16
    8000260a:	854a                	mv	a0,s2
    8000260c:	00001097          	auipc	ra,0x1
    80002610:	418080e7          	jalr	1048(ra) # 80003a24 <holdingsleep>
    80002614:	c925                	beqz	a0,80002684 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002616:	854a                	mv	a0,s2
    80002618:	00001097          	auipc	ra,0x1
    8000261c:	3c8080e7          	jalr	968(ra) # 800039e0 <releasesleep>

  acquire(&bcache.lock);
    80002620:	0000f517          	auipc	a0,0xf
    80002624:	87850513          	addi	a0,a0,-1928 # 80010e98 <bcache>
    80002628:	00004097          	auipc	ra,0x4
    8000262c:	0cc080e7          	jalr	204(ra) # 800066f4 <acquire>
  b->refcnt--;
    80002630:	40bc                	lw	a5,64(s1)
    80002632:	37fd                	addiw	a5,a5,-1
    80002634:	0007871b          	sext.w	a4,a5
    80002638:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000263a:	e71d                	bnez	a4,80002668 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000263c:	68b8                	ld	a4,80(s1)
    8000263e:	64bc                	ld	a5,72(s1)
    80002640:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002642:	68b8                	ld	a4,80(s1)
    80002644:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002646:	00017797          	auipc	a5,0x17
    8000264a:	85278793          	addi	a5,a5,-1966 # 80018e98 <bcache+0x8000>
    8000264e:	2b87b703          	ld	a4,696(a5)
    80002652:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002654:	00017717          	auipc	a4,0x17
    80002658:	aac70713          	addi	a4,a4,-1364 # 80019100 <bcache+0x8268>
    8000265c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000265e:	2b87b703          	ld	a4,696(a5)
    80002662:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002664:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002668:	0000f517          	auipc	a0,0xf
    8000266c:	83050513          	addi	a0,a0,-2000 # 80010e98 <bcache>
    80002670:	00004097          	auipc	ra,0x4
    80002674:	138080e7          	jalr	312(ra) # 800067a8 <release>
}
    80002678:	60e2                	ld	ra,24(sp)
    8000267a:	6442                	ld	s0,16(sp)
    8000267c:	64a2                	ld	s1,8(sp)
    8000267e:	6902                	ld	s2,0(sp)
    80002680:	6105                	addi	sp,sp,32
    80002682:	8082                	ret
    panic("brelse");
    80002684:	00006517          	auipc	a0,0x6
    80002688:	cf450513          	addi	a0,a0,-780 # 80008378 <etext+0x378>
    8000268c:	00004097          	auipc	ra,0x4
    80002690:	aee080e7          	jalr	-1298(ra) # 8000617a <panic>

0000000080002694 <bpin>:

void
bpin(struct buf *b) {
    80002694:	1101                	addi	sp,sp,-32
    80002696:	ec06                	sd	ra,24(sp)
    80002698:	e822                	sd	s0,16(sp)
    8000269a:	e426                	sd	s1,8(sp)
    8000269c:	1000                	addi	s0,sp,32
    8000269e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026a0:	0000e517          	auipc	a0,0xe
    800026a4:	7f850513          	addi	a0,a0,2040 # 80010e98 <bcache>
    800026a8:	00004097          	auipc	ra,0x4
    800026ac:	04c080e7          	jalr	76(ra) # 800066f4 <acquire>
  b->refcnt++;
    800026b0:	40bc                	lw	a5,64(s1)
    800026b2:	2785                	addiw	a5,a5,1
    800026b4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026b6:	0000e517          	auipc	a0,0xe
    800026ba:	7e250513          	addi	a0,a0,2018 # 80010e98 <bcache>
    800026be:	00004097          	auipc	ra,0x4
    800026c2:	0ea080e7          	jalr	234(ra) # 800067a8 <release>
}
    800026c6:	60e2                	ld	ra,24(sp)
    800026c8:	6442                	ld	s0,16(sp)
    800026ca:	64a2                	ld	s1,8(sp)
    800026cc:	6105                	addi	sp,sp,32
    800026ce:	8082                	ret

00000000800026d0 <bunpin>:

void
bunpin(struct buf *b) {
    800026d0:	1101                	addi	sp,sp,-32
    800026d2:	ec06                	sd	ra,24(sp)
    800026d4:	e822                	sd	s0,16(sp)
    800026d6:	e426                	sd	s1,8(sp)
    800026d8:	1000                	addi	s0,sp,32
    800026da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026dc:	0000e517          	auipc	a0,0xe
    800026e0:	7bc50513          	addi	a0,a0,1980 # 80010e98 <bcache>
    800026e4:	00004097          	auipc	ra,0x4
    800026e8:	010080e7          	jalr	16(ra) # 800066f4 <acquire>
  b->refcnt--;
    800026ec:	40bc                	lw	a5,64(s1)
    800026ee:	37fd                	addiw	a5,a5,-1
    800026f0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026f2:	0000e517          	auipc	a0,0xe
    800026f6:	7a650513          	addi	a0,a0,1958 # 80010e98 <bcache>
    800026fa:	00004097          	auipc	ra,0x4
    800026fe:	0ae080e7          	jalr	174(ra) # 800067a8 <release>
}
    80002702:	60e2                	ld	ra,24(sp)
    80002704:	6442                	ld	s0,16(sp)
    80002706:	64a2                	ld	s1,8(sp)
    80002708:	6105                	addi	sp,sp,32
    8000270a:	8082                	ret

000000008000270c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000270c:	1101                	addi	sp,sp,-32
    8000270e:	ec06                	sd	ra,24(sp)
    80002710:	e822                	sd	s0,16(sp)
    80002712:	e426                	sd	s1,8(sp)
    80002714:	e04a                	sd	s2,0(sp)
    80002716:	1000                	addi	s0,sp,32
    80002718:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000271a:	00d5d59b          	srliw	a1,a1,0xd
    8000271e:	00017797          	auipc	a5,0x17
    80002722:	e567a783          	lw	a5,-426(a5) # 80019574 <sb+0x1c>
    80002726:	9dbd                	addw	a1,a1,a5
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	da0080e7          	jalr	-608(ra) # 800024c8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002730:	0074f713          	andi	a4,s1,7
    80002734:	4785                	li	a5,1
    80002736:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000273a:	14ce                	slli	s1,s1,0x33
    8000273c:	90d9                	srli	s1,s1,0x36
    8000273e:	00950733          	add	a4,a0,s1
    80002742:	05874703          	lbu	a4,88(a4)
    80002746:	00e7f6b3          	and	a3,a5,a4
    8000274a:	c69d                	beqz	a3,80002778 <bfree+0x6c>
    8000274c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000274e:	94aa                	add	s1,s1,a0
    80002750:	fff7c793          	not	a5,a5
    80002754:	8f7d                	and	a4,a4,a5
    80002756:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000275a:	00001097          	auipc	ra,0x1
    8000275e:	112080e7          	jalr	274(ra) # 8000386c <log_write>
  brelse(bp);
    80002762:	854a                	mv	a0,s2
    80002764:	00000097          	auipc	ra,0x0
    80002768:	e94080e7          	jalr	-364(ra) # 800025f8 <brelse>
}
    8000276c:	60e2                	ld	ra,24(sp)
    8000276e:	6442                	ld	s0,16(sp)
    80002770:	64a2                	ld	s1,8(sp)
    80002772:	6902                	ld	s2,0(sp)
    80002774:	6105                	addi	sp,sp,32
    80002776:	8082                	ret
    panic("freeing free block");
    80002778:	00006517          	auipc	a0,0x6
    8000277c:	c0850513          	addi	a0,a0,-1016 # 80008380 <etext+0x380>
    80002780:	00004097          	auipc	ra,0x4
    80002784:	9fa080e7          	jalr	-1542(ra) # 8000617a <panic>

0000000080002788 <balloc>:
{
    80002788:	711d                	addi	sp,sp,-96
    8000278a:	ec86                	sd	ra,88(sp)
    8000278c:	e8a2                	sd	s0,80(sp)
    8000278e:	e4a6                	sd	s1,72(sp)
    80002790:	e0ca                	sd	s2,64(sp)
    80002792:	fc4e                	sd	s3,56(sp)
    80002794:	f852                	sd	s4,48(sp)
    80002796:	f456                	sd	s5,40(sp)
    80002798:	f05a                	sd	s6,32(sp)
    8000279a:	ec5e                	sd	s7,24(sp)
    8000279c:	e862                	sd	s8,16(sp)
    8000279e:	e466                	sd	s9,8(sp)
    800027a0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027a2:	00017797          	auipc	a5,0x17
    800027a6:	dba7a783          	lw	a5,-582(a5) # 8001955c <sb+0x4>
    800027aa:	cbc1                	beqz	a5,8000283a <balloc+0xb2>
    800027ac:	8baa                	mv	s7,a0
    800027ae:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027b0:	00017b17          	auipc	s6,0x17
    800027b4:	da8b0b13          	addi	s6,s6,-600 # 80019558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027b8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027ba:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027bc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027be:	6c89                	lui	s9,0x2
    800027c0:	a831                	j	800027dc <balloc+0x54>
    brelse(bp);
    800027c2:	854a                	mv	a0,s2
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	e34080e7          	jalr	-460(ra) # 800025f8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027cc:	015c87bb          	addw	a5,s9,s5
    800027d0:	00078a9b          	sext.w	s5,a5
    800027d4:	004b2703          	lw	a4,4(s6)
    800027d8:	06eaf163          	bgeu	s5,a4,8000283a <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800027dc:	41fad79b          	sraiw	a5,s5,0x1f
    800027e0:	0137d79b          	srliw	a5,a5,0x13
    800027e4:	015787bb          	addw	a5,a5,s5
    800027e8:	40d7d79b          	sraiw	a5,a5,0xd
    800027ec:	01cb2583          	lw	a1,28(s6)
    800027f0:	9dbd                	addw	a1,a1,a5
    800027f2:	855e                	mv	a0,s7
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	cd4080e7          	jalr	-812(ra) # 800024c8 <bread>
    800027fc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fe:	004b2503          	lw	a0,4(s6)
    80002802:	000a849b          	sext.w	s1,s5
    80002806:	8762                	mv	a4,s8
    80002808:	faa4fde3          	bgeu	s1,a0,800027c2 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000280c:	00777693          	andi	a3,a4,7
    80002810:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002814:	41f7579b          	sraiw	a5,a4,0x1f
    80002818:	01d7d79b          	srliw	a5,a5,0x1d
    8000281c:	9fb9                	addw	a5,a5,a4
    8000281e:	4037d79b          	sraiw	a5,a5,0x3
    80002822:	00f90633          	add	a2,s2,a5
    80002826:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    8000282a:	00c6f5b3          	and	a1,a3,a2
    8000282e:	cd91                	beqz	a1,8000284a <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002830:	2705                	addiw	a4,a4,1
    80002832:	2485                	addiw	s1,s1,1
    80002834:	fd471ae3          	bne	a4,s4,80002808 <balloc+0x80>
    80002838:	b769                	j	800027c2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000283a:	00006517          	auipc	a0,0x6
    8000283e:	b5e50513          	addi	a0,a0,-1186 # 80008398 <etext+0x398>
    80002842:	00004097          	auipc	ra,0x4
    80002846:	938080e7          	jalr	-1736(ra) # 8000617a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000284a:	97ca                	add	a5,a5,s2
    8000284c:	8e55                	or	a2,a2,a3
    8000284e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002852:	854a                	mv	a0,s2
    80002854:	00001097          	auipc	ra,0x1
    80002858:	018080e7          	jalr	24(ra) # 8000386c <log_write>
        brelse(bp);
    8000285c:	854a                	mv	a0,s2
    8000285e:	00000097          	auipc	ra,0x0
    80002862:	d9a080e7          	jalr	-614(ra) # 800025f8 <brelse>
  bp = bread(dev, bno);
    80002866:	85a6                	mv	a1,s1
    80002868:	855e                	mv	a0,s7
    8000286a:	00000097          	auipc	ra,0x0
    8000286e:	c5e080e7          	jalr	-930(ra) # 800024c8 <bread>
    80002872:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002874:	40000613          	li	a2,1024
    80002878:	4581                	li	a1,0
    8000287a:	05850513          	addi	a0,a0,88
    8000287e:	ffffe097          	auipc	ra,0xffffe
    80002882:	8fc080e7          	jalr	-1796(ra) # 8000017a <memset>
  log_write(bp);
    80002886:	854a                	mv	a0,s2
    80002888:	00001097          	auipc	ra,0x1
    8000288c:	fe4080e7          	jalr	-28(ra) # 8000386c <log_write>
  brelse(bp);
    80002890:	854a                	mv	a0,s2
    80002892:	00000097          	auipc	ra,0x0
    80002896:	d66080e7          	jalr	-666(ra) # 800025f8 <brelse>
}
    8000289a:	8526                	mv	a0,s1
    8000289c:	60e6                	ld	ra,88(sp)
    8000289e:	6446                	ld	s0,80(sp)
    800028a0:	64a6                	ld	s1,72(sp)
    800028a2:	6906                	ld	s2,64(sp)
    800028a4:	79e2                	ld	s3,56(sp)
    800028a6:	7a42                	ld	s4,48(sp)
    800028a8:	7aa2                	ld	s5,40(sp)
    800028aa:	7b02                	ld	s6,32(sp)
    800028ac:	6be2                	ld	s7,24(sp)
    800028ae:	6c42                	ld	s8,16(sp)
    800028b0:	6ca2                	ld	s9,8(sp)
    800028b2:	6125                	addi	sp,sp,96
    800028b4:	8082                	ret

00000000800028b6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028b6:	7179                	addi	sp,sp,-48
    800028b8:	f406                	sd	ra,40(sp)
    800028ba:	f022                	sd	s0,32(sp)
    800028bc:	ec26                	sd	s1,24(sp)
    800028be:	e84a                	sd	s2,16(sp)
    800028c0:	e44e                	sd	s3,8(sp)
    800028c2:	1800                	addi	s0,sp,48
    800028c4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028c6:	47ad                	li	a5,11
    800028c8:	04b7ff63          	bgeu	a5,a1,80002926 <bmap+0x70>
    800028cc:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028ce:	ff45849b          	addiw	s1,a1,-12
    800028d2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028d6:	0ff00793          	li	a5,255
    800028da:	0ae7e463          	bltu	a5,a4,80002982 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028de:	08052583          	lw	a1,128(a0)
    800028e2:	c5b5                	beqz	a1,8000294e <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028e4:	00092503          	lw	a0,0(s2)
    800028e8:	00000097          	auipc	ra,0x0
    800028ec:	be0080e7          	jalr	-1056(ra) # 800024c8 <bread>
    800028f0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028f2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028f6:	02049713          	slli	a4,s1,0x20
    800028fa:	01e75593          	srli	a1,a4,0x1e
    800028fe:	00b784b3          	add	s1,a5,a1
    80002902:	0004a983          	lw	s3,0(s1)
    80002906:	04098e63          	beqz	s3,80002962 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000290a:	8552                	mv	a0,s4
    8000290c:	00000097          	auipc	ra,0x0
    80002910:	cec080e7          	jalr	-788(ra) # 800025f8 <brelse>
    return addr;
    80002914:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002916:	854e                	mv	a0,s3
    80002918:	70a2                	ld	ra,40(sp)
    8000291a:	7402                	ld	s0,32(sp)
    8000291c:	64e2                	ld	s1,24(sp)
    8000291e:	6942                	ld	s2,16(sp)
    80002920:	69a2                	ld	s3,8(sp)
    80002922:	6145                	addi	sp,sp,48
    80002924:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002926:	02059793          	slli	a5,a1,0x20
    8000292a:	01e7d593          	srli	a1,a5,0x1e
    8000292e:	00b504b3          	add	s1,a0,a1
    80002932:	0504a983          	lw	s3,80(s1)
    80002936:	fe0990e3          	bnez	s3,80002916 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000293a:	4108                	lw	a0,0(a0)
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	e4c080e7          	jalr	-436(ra) # 80002788 <balloc>
    80002944:	0005099b          	sext.w	s3,a0
    80002948:	0534a823          	sw	s3,80(s1)
    8000294c:	b7e9                	j	80002916 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000294e:	4108                	lw	a0,0(a0)
    80002950:	00000097          	auipc	ra,0x0
    80002954:	e38080e7          	jalr	-456(ra) # 80002788 <balloc>
    80002958:	0005059b          	sext.w	a1,a0
    8000295c:	08b92023          	sw	a1,128(s2)
    80002960:	b751                	j	800028e4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002962:	00092503          	lw	a0,0(s2)
    80002966:	00000097          	auipc	ra,0x0
    8000296a:	e22080e7          	jalr	-478(ra) # 80002788 <balloc>
    8000296e:	0005099b          	sext.w	s3,a0
    80002972:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002976:	8552                	mv	a0,s4
    80002978:	00001097          	auipc	ra,0x1
    8000297c:	ef4080e7          	jalr	-268(ra) # 8000386c <log_write>
    80002980:	b769                	j	8000290a <bmap+0x54>
  panic("bmap: out of range");
    80002982:	00006517          	auipc	a0,0x6
    80002986:	a2e50513          	addi	a0,a0,-1490 # 800083b0 <etext+0x3b0>
    8000298a:	00003097          	auipc	ra,0x3
    8000298e:	7f0080e7          	jalr	2032(ra) # 8000617a <panic>

0000000080002992 <iget>:
{
    80002992:	7179                	addi	sp,sp,-48
    80002994:	f406                	sd	ra,40(sp)
    80002996:	f022                	sd	s0,32(sp)
    80002998:	ec26                	sd	s1,24(sp)
    8000299a:	e84a                	sd	s2,16(sp)
    8000299c:	e44e                	sd	s3,8(sp)
    8000299e:	e052                	sd	s4,0(sp)
    800029a0:	1800                	addi	s0,sp,48
    800029a2:	89aa                	mv	s3,a0
    800029a4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029a6:	00017517          	auipc	a0,0x17
    800029aa:	bd250513          	addi	a0,a0,-1070 # 80019578 <itable>
    800029ae:	00004097          	auipc	ra,0x4
    800029b2:	d46080e7          	jalr	-698(ra) # 800066f4 <acquire>
  empty = 0;
    800029b6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029b8:	00017497          	auipc	s1,0x17
    800029bc:	bd848493          	addi	s1,s1,-1064 # 80019590 <itable+0x18>
    800029c0:	00018697          	auipc	a3,0x18
    800029c4:	66068693          	addi	a3,a3,1632 # 8001b020 <log>
    800029c8:	a039                	j	800029d6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029ca:	02090b63          	beqz	s2,80002a00 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029ce:	08848493          	addi	s1,s1,136
    800029d2:	02d48a63          	beq	s1,a3,80002a06 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029d6:	449c                	lw	a5,8(s1)
    800029d8:	fef059e3          	blez	a5,800029ca <iget+0x38>
    800029dc:	4098                	lw	a4,0(s1)
    800029de:	ff3716e3          	bne	a4,s3,800029ca <iget+0x38>
    800029e2:	40d8                	lw	a4,4(s1)
    800029e4:	ff4713e3          	bne	a4,s4,800029ca <iget+0x38>
      ip->ref++;
    800029e8:	2785                	addiw	a5,a5,1
    800029ea:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029ec:	00017517          	auipc	a0,0x17
    800029f0:	b8c50513          	addi	a0,a0,-1140 # 80019578 <itable>
    800029f4:	00004097          	auipc	ra,0x4
    800029f8:	db4080e7          	jalr	-588(ra) # 800067a8 <release>
      return ip;
    800029fc:	8926                	mv	s2,s1
    800029fe:	a03d                	j	80002a2c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a00:	f7f9                	bnez	a5,800029ce <iget+0x3c>
      empty = ip;
    80002a02:	8926                	mv	s2,s1
    80002a04:	b7e9                	j	800029ce <iget+0x3c>
  if(empty == 0)
    80002a06:	02090c63          	beqz	s2,80002a3e <iget+0xac>
  ip->dev = dev;
    80002a0a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a0e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a12:	4785                	li	a5,1
    80002a14:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a18:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a1c:	00017517          	auipc	a0,0x17
    80002a20:	b5c50513          	addi	a0,a0,-1188 # 80019578 <itable>
    80002a24:	00004097          	auipc	ra,0x4
    80002a28:	d84080e7          	jalr	-636(ra) # 800067a8 <release>
}
    80002a2c:	854a                	mv	a0,s2
    80002a2e:	70a2                	ld	ra,40(sp)
    80002a30:	7402                	ld	s0,32(sp)
    80002a32:	64e2                	ld	s1,24(sp)
    80002a34:	6942                	ld	s2,16(sp)
    80002a36:	69a2                	ld	s3,8(sp)
    80002a38:	6a02                	ld	s4,0(sp)
    80002a3a:	6145                	addi	sp,sp,48
    80002a3c:	8082                	ret
    panic("iget: no inodes");
    80002a3e:	00006517          	auipc	a0,0x6
    80002a42:	98a50513          	addi	a0,a0,-1654 # 800083c8 <etext+0x3c8>
    80002a46:	00003097          	auipc	ra,0x3
    80002a4a:	734080e7          	jalr	1844(ra) # 8000617a <panic>

0000000080002a4e <fsinit>:
fsinit(int dev) {
    80002a4e:	7179                	addi	sp,sp,-48
    80002a50:	f406                	sd	ra,40(sp)
    80002a52:	f022                	sd	s0,32(sp)
    80002a54:	ec26                	sd	s1,24(sp)
    80002a56:	e84a                	sd	s2,16(sp)
    80002a58:	e44e                	sd	s3,8(sp)
    80002a5a:	1800                	addi	s0,sp,48
    80002a5c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a5e:	4585                	li	a1,1
    80002a60:	00000097          	auipc	ra,0x0
    80002a64:	a68080e7          	jalr	-1432(ra) # 800024c8 <bread>
    80002a68:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a6a:	00017997          	auipc	s3,0x17
    80002a6e:	aee98993          	addi	s3,s3,-1298 # 80019558 <sb>
    80002a72:	02000613          	li	a2,32
    80002a76:	05850593          	addi	a1,a0,88
    80002a7a:	854e                	mv	a0,s3
    80002a7c:	ffffd097          	auipc	ra,0xffffd
    80002a80:	75a080e7          	jalr	1882(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a84:	8526                	mv	a0,s1
    80002a86:	00000097          	auipc	ra,0x0
    80002a8a:	b72080e7          	jalr	-1166(ra) # 800025f8 <brelse>
  if(sb.magic != FSMAGIC)
    80002a8e:	0009a703          	lw	a4,0(s3)
    80002a92:	102037b7          	lui	a5,0x10203
    80002a96:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a9a:	02f71263          	bne	a4,a5,80002abe <fsinit+0x70>
  initlog(dev, &sb);
    80002a9e:	00017597          	auipc	a1,0x17
    80002aa2:	aba58593          	addi	a1,a1,-1350 # 80019558 <sb>
    80002aa6:	854a                	mv	a0,s2
    80002aa8:	00001097          	auipc	ra,0x1
    80002aac:	b54080e7          	jalr	-1196(ra) # 800035fc <initlog>
}
    80002ab0:	70a2                	ld	ra,40(sp)
    80002ab2:	7402                	ld	s0,32(sp)
    80002ab4:	64e2                	ld	s1,24(sp)
    80002ab6:	6942                	ld	s2,16(sp)
    80002ab8:	69a2                	ld	s3,8(sp)
    80002aba:	6145                	addi	sp,sp,48
    80002abc:	8082                	ret
    panic("invalid file system");
    80002abe:	00006517          	auipc	a0,0x6
    80002ac2:	91a50513          	addi	a0,a0,-1766 # 800083d8 <etext+0x3d8>
    80002ac6:	00003097          	auipc	ra,0x3
    80002aca:	6b4080e7          	jalr	1716(ra) # 8000617a <panic>

0000000080002ace <iinit>:
{
    80002ace:	7179                	addi	sp,sp,-48
    80002ad0:	f406                	sd	ra,40(sp)
    80002ad2:	f022                	sd	s0,32(sp)
    80002ad4:	ec26                	sd	s1,24(sp)
    80002ad6:	e84a                	sd	s2,16(sp)
    80002ad8:	e44e                	sd	s3,8(sp)
    80002ada:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002adc:	00006597          	auipc	a1,0x6
    80002ae0:	91458593          	addi	a1,a1,-1772 # 800083f0 <etext+0x3f0>
    80002ae4:	00017517          	auipc	a0,0x17
    80002ae8:	a9450513          	addi	a0,a0,-1388 # 80019578 <itable>
    80002aec:	00004097          	auipc	ra,0x4
    80002af0:	b78080e7          	jalr	-1160(ra) # 80006664 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002af4:	00017497          	auipc	s1,0x17
    80002af8:	aac48493          	addi	s1,s1,-1364 # 800195a0 <itable+0x28>
    80002afc:	00018997          	auipc	s3,0x18
    80002b00:	53498993          	addi	s3,s3,1332 # 8001b030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b04:	00006917          	auipc	s2,0x6
    80002b08:	8f490913          	addi	s2,s2,-1804 # 800083f8 <etext+0x3f8>
    80002b0c:	85ca                	mv	a1,s2
    80002b0e:	8526                	mv	a0,s1
    80002b10:	00001097          	auipc	ra,0x1
    80002b14:	e40080e7          	jalr	-448(ra) # 80003950 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b18:	08848493          	addi	s1,s1,136
    80002b1c:	ff3498e3          	bne	s1,s3,80002b0c <iinit+0x3e>
}
    80002b20:	70a2                	ld	ra,40(sp)
    80002b22:	7402                	ld	s0,32(sp)
    80002b24:	64e2                	ld	s1,24(sp)
    80002b26:	6942                	ld	s2,16(sp)
    80002b28:	69a2                	ld	s3,8(sp)
    80002b2a:	6145                	addi	sp,sp,48
    80002b2c:	8082                	ret

0000000080002b2e <ialloc>:
{
    80002b2e:	7139                	addi	sp,sp,-64
    80002b30:	fc06                	sd	ra,56(sp)
    80002b32:	f822                	sd	s0,48(sp)
    80002b34:	f426                	sd	s1,40(sp)
    80002b36:	f04a                	sd	s2,32(sp)
    80002b38:	ec4e                	sd	s3,24(sp)
    80002b3a:	e852                	sd	s4,16(sp)
    80002b3c:	e456                	sd	s5,8(sp)
    80002b3e:	e05a                	sd	s6,0(sp)
    80002b40:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b42:	00017717          	auipc	a4,0x17
    80002b46:	a2272703          	lw	a4,-1502(a4) # 80019564 <sb+0xc>
    80002b4a:	4785                	li	a5,1
    80002b4c:	04e7f863          	bgeu	a5,a4,80002b9c <ialloc+0x6e>
    80002b50:	8aaa                	mv	s5,a0
    80002b52:	8b2e                	mv	s6,a1
    80002b54:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b56:	00017a17          	auipc	s4,0x17
    80002b5a:	a02a0a13          	addi	s4,s4,-1534 # 80019558 <sb>
    80002b5e:	00495593          	srli	a1,s2,0x4
    80002b62:	018a2783          	lw	a5,24(s4)
    80002b66:	9dbd                	addw	a1,a1,a5
    80002b68:	8556                	mv	a0,s5
    80002b6a:	00000097          	auipc	ra,0x0
    80002b6e:	95e080e7          	jalr	-1698(ra) # 800024c8 <bread>
    80002b72:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b74:	05850993          	addi	s3,a0,88
    80002b78:	00f97793          	andi	a5,s2,15
    80002b7c:	079a                	slli	a5,a5,0x6
    80002b7e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b80:	00099783          	lh	a5,0(s3)
    80002b84:	c785                	beqz	a5,80002bac <ialloc+0x7e>
    brelse(bp);
    80002b86:	00000097          	auipc	ra,0x0
    80002b8a:	a72080e7          	jalr	-1422(ra) # 800025f8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b8e:	0905                	addi	s2,s2,1
    80002b90:	00ca2703          	lw	a4,12(s4)
    80002b94:	0009079b          	sext.w	a5,s2
    80002b98:	fce7e3e3          	bltu	a5,a4,80002b5e <ialloc+0x30>
  panic("ialloc: no inodes");
    80002b9c:	00006517          	auipc	a0,0x6
    80002ba0:	86450513          	addi	a0,a0,-1948 # 80008400 <etext+0x400>
    80002ba4:	00003097          	auipc	ra,0x3
    80002ba8:	5d6080e7          	jalr	1494(ra) # 8000617a <panic>
      memset(dip, 0, sizeof(*dip));
    80002bac:	04000613          	li	a2,64
    80002bb0:	4581                	li	a1,0
    80002bb2:	854e                	mv	a0,s3
    80002bb4:	ffffd097          	auipc	ra,0xffffd
    80002bb8:	5c6080e7          	jalr	1478(ra) # 8000017a <memset>
      dip->type = type;
    80002bbc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bc0:	8526                	mv	a0,s1
    80002bc2:	00001097          	auipc	ra,0x1
    80002bc6:	caa080e7          	jalr	-854(ra) # 8000386c <log_write>
      brelse(bp);
    80002bca:	8526                	mv	a0,s1
    80002bcc:	00000097          	auipc	ra,0x0
    80002bd0:	a2c080e7          	jalr	-1492(ra) # 800025f8 <brelse>
      return iget(dev, inum);
    80002bd4:	0009059b          	sext.w	a1,s2
    80002bd8:	8556                	mv	a0,s5
    80002bda:	00000097          	auipc	ra,0x0
    80002bde:	db8080e7          	jalr	-584(ra) # 80002992 <iget>
}
    80002be2:	70e2                	ld	ra,56(sp)
    80002be4:	7442                	ld	s0,48(sp)
    80002be6:	74a2                	ld	s1,40(sp)
    80002be8:	7902                	ld	s2,32(sp)
    80002bea:	69e2                	ld	s3,24(sp)
    80002bec:	6a42                	ld	s4,16(sp)
    80002bee:	6aa2                	ld	s5,8(sp)
    80002bf0:	6b02                	ld	s6,0(sp)
    80002bf2:	6121                	addi	sp,sp,64
    80002bf4:	8082                	ret

0000000080002bf6 <iupdate>:
{
    80002bf6:	1101                	addi	sp,sp,-32
    80002bf8:	ec06                	sd	ra,24(sp)
    80002bfa:	e822                	sd	s0,16(sp)
    80002bfc:	e426                	sd	s1,8(sp)
    80002bfe:	e04a                	sd	s2,0(sp)
    80002c00:	1000                	addi	s0,sp,32
    80002c02:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c04:	415c                	lw	a5,4(a0)
    80002c06:	0047d79b          	srliw	a5,a5,0x4
    80002c0a:	00017597          	auipc	a1,0x17
    80002c0e:	9665a583          	lw	a1,-1690(a1) # 80019570 <sb+0x18>
    80002c12:	9dbd                	addw	a1,a1,a5
    80002c14:	4108                	lw	a0,0(a0)
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	8b2080e7          	jalr	-1870(ra) # 800024c8 <bread>
    80002c1e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c20:	05850793          	addi	a5,a0,88
    80002c24:	40d8                	lw	a4,4(s1)
    80002c26:	8b3d                	andi	a4,a4,15
    80002c28:	071a                	slli	a4,a4,0x6
    80002c2a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c2c:	04449703          	lh	a4,68(s1)
    80002c30:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c34:	04649703          	lh	a4,70(s1)
    80002c38:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c3c:	04849703          	lh	a4,72(s1)
    80002c40:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c44:	04a49703          	lh	a4,74(s1)
    80002c48:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c4c:	44f8                	lw	a4,76(s1)
    80002c4e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c50:	03400613          	li	a2,52
    80002c54:	05048593          	addi	a1,s1,80
    80002c58:	00c78513          	addi	a0,a5,12
    80002c5c:	ffffd097          	auipc	ra,0xffffd
    80002c60:	57a080e7          	jalr	1402(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c64:	854a                	mv	a0,s2
    80002c66:	00001097          	auipc	ra,0x1
    80002c6a:	c06080e7          	jalr	-1018(ra) # 8000386c <log_write>
  brelse(bp);
    80002c6e:	854a                	mv	a0,s2
    80002c70:	00000097          	auipc	ra,0x0
    80002c74:	988080e7          	jalr	-1656(ra) # 800025f8 <brelse>
}
    80002c78:	60e2                	ld	ra,24(sp)
    80002c7a:	6442                	ld	s0,16(sp)
    80002c7c:	64a2                	ld	s1,8(sp)
    80002c7e:	6902                	ld	s2,0(sp)
    80002c80:	6105                	addi	sp,sp,32
    80002c82:	8082                	ret

0000000080002c84 <idup>:
{
    80002c84:	1101                	addi	sp,sp,-32
    80002c86:	ec06                	sd	ra,24(sp)
    80002c88:	e822                	sd	s0,16(sp)
    80002c8a:	e426                	sd	s1,8(sp)
    80002c8c:	1000                	addi	s0,sp,32
    80002c8e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c90:	00017517          	auipc	a0,0x17
    80002c94:	8e850513          	addi	a0,a0,-1816 # 80019578 <itable>
    80002c98:	00004097          	auipc	ra,0x4
    80002c9c:	a5c080e7          	jalr	-1444(ra) # 800066f4 <acquire>
  ip->ref++;
    80002ca0:	449c                	lw	a5,8(s1)
    80002ca2:	2785                	addiw	a5,a5,1
    80002ca4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ca6:	00017517          	auipc	a0,0x17
    80002caa:	8d250513          	addi	a0,a0,-1838 # 80019578 <itable>
    80002cae:	00004097          	auipc	ra,0x4
    80002cb2:	afa080e7          	jalr	-1286(ra) # 800067a8 <release>
}
    80002cb6:	8526                	mv	a0,s1
    80002cb8:	60e2                	ld	ra,24(sp)
    80002cba:	6442                	ld	s0,16(sp)
    80002cbc:	64a2                	ld	s1,8(sp)
    80002cbe:	6105                	addi	sp,sp,32
    80002cc0:	8082                	ret

0000000080002cc2 <ilock>:
{
    80002cc2:	1101                	addi	sp,sp,-32
    80002cc4:	ec06                	sd	ra,24(sp)
    80002cc6:	e822                	sd	s0,16(sp)
    80002cc8:	e426                	sd	s1,8(sp)
    80002cca:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ccc:	c10d                	beqz	a0,80002cee <ilock+0x2c>
    80002cce:	84aa                	mv	s1,a0
    80002cd0:	451c                	lw	a5,8(a0)
    80002cd2:	00f05e63          	blez	a5,80002cee <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002cd6:	0541                	addi	a0,a0,16
    80002cd8:	00001097          	auipc	ra,0x1
    80002cdc:	cb2080e7          	jalr	-846(ra) # 8000398a <acquiresleep>
  if(ip->valid == 0){
    80002ce0:	40bc                	lw	a5,64(s1)
    80002ce2:	cf99                	beqz	a5,80002d00 <ilock+0x3e>
}
    80002ce4:	60e2                	ld	ra,24(sp)
    80002ce6:	6442                	ld	s0,16(sp)
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	6105                	addi	sp,sp,32
    80002cec:	8082                	ret
    80002cee:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002cf0:	00005517          	auipc	a0,0x5
    80002cf4:	72850513          	addi	a0,a0,1832 # 80008418 <etext+0x418>
    80002cf8:	00003097          	auipc	ra,0x3
    80002cfc:	482080e7          	jalr	1154(ra) # 8000617a <panic>
    80002d00:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d02:	40dc                	lw	a5,4(s1)
    80002d04:	0047d79b          	srliw	a5,a5,0x4
    80002d08:	00017597          	auipc	a1,0x17
    80002d0c:	8685a583          	lw	a1,-1944(a1) # 80019570 <sb+0x18>
    80002d10:	9dbd                	addw	a1,a1,a5
    80002d12:	4088                	lw	a0,0(s1)
    80002d14:	fffff097          	auipc	ra,0xfffff
    80002d18:	7b4080e7          	jalr	1972(ra) # 800024c8 <bread>
    80002d1c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d1e:	05850593          	addi	a1,a0,88
    80002d22:	40dc                	lw	a5,4(s1)
    80002d24:	8bbd                	andi	a5,a5,15
    80002d26:	079a                	slli	a5,a5,0x6
    80002d28:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d2a:	00059783          	lh	a5,0(a1)
    80002d2e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d32:	00259783          	lh	a5,2(a1)
    80002d36:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d3a:	00459783          	lh	a5,4(a1)
    80002d3e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d42:	00659783          	lh	a5,6(a1)
    80002d46:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d4a:	459c                	lw	a5,8(a1)
    80002d4c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d4e:	03400613          	li	a2,52
    80002d52:	05b1                	addi	a1,a1,12
    80002d54:	05048513          	addi	a0,s1,80
    80002d58:	ffffd097          	auipc	ra,0xffffd
    80002d5c:	47e080e7          	jalr	1150(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d60:	854a                	mv	a0,s2
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	896080e7          	jalr	-1898(ra) # 800025f8 <brelse>
    ip->valid = 1;
    80002d6a:	4785                	li	a5,1
    80002d6c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d6e:	04449783          	lh	a5,68(s1)
    80002d72:	c399                	beqz	a5,80002d78 <ilock+0xb6>
    80002d74:	6902                	ld	s2,0(sp)
    80002d76:	b7bd                	j	80002ce4 <ilock+0x22>
      panic("ilock: no type");
    80002d78:	00005517          	auipc	a0,0x5
    80002d7c:	6a850513          	addi	a0,a0,1704 # 80008420 <etext+0x420>
    80002d80:	00003097          	auipc	ra,0x3
    80002d84:	3fa080e7          	jalr	1018(ra) # 8000617a <panic>

0000000080002d88 <iunlock>:
{
    80002d88:	1101                	addi	sp,sp,-32
    80002d8a:	ec06                	sd	ra,24(sp)
    80002d8c:	e822                	sd	s0,16(sp)
    80002d8e:	e426                	sd	s1,8(sp)
    80002d90:	e04a                	sd	s2,0(sp)
    80002d92:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d94:	c905                	beqz	a0,80002dc4 <iunlock+0x3c>
    80002d96:	84aa                	mv	s1,a0
    80002d98:	01050913          	addi	s2,a0,16
    80002d9c:	854a                	mv	a0,s2
    80002d9e:	00001097          	auipc	ra,0x1
    80002da2:	c86080e7          	jalr	-890(ra) # 80003a24 <holdingsleep>
    80002da6:	cd19                	beqz	a0,80002dc4 <iunlock+0x3c>
    80002da8:	449c                	lw	a5,8(s1)
    80002daa:	00f05d63          	blez	a5,80002dc4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002dae:	854a                	mv	a0,s2
    80002db0:	00001097          	auipc	ra,0x1
    80002db4:	c30080e7          	jalr	-976(ra) # 800039e0 <releasesleep>
}
    80002db8:	60e2                	ld	ra,24(sp)
    80002dba:	6442                	ld	s0,16(sp)
    80002dbc:	64a2                	ld	s1,8(sp)
    80002dbe:	6902                	ld	s2,0(sp)
    80002dc0:	6105                	addi	sp,sp,32
    80002dc2:	8082                	ret
    panic("iunlock");
    80002dc4:	00005517          	auipc	a0,0x5
    80002dc8:	66c50513          	addi	a0,a0,1644 # 80008430 <etext+0x430>
    80002dcc:	00003097          	auipc	ra,0x3
    80002dd0:	3ae080e7          	jalr	942(ra) # 8000617a <panic>

0000000080002dd4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dd4:	7179                	addi	sp,sp,-48
    80002dd6:	f406                	sd	ra,40(sp)
    80002dd8:	f022                	sd	s0,32(sp)
    80002dda:	ec26                	sd	s1,24(sp)
    80002ddc:	e84a                	sd	s2,16(sp)
    80002dde:	e44e                	sd	s3,8(sp)
    80002de0:	1800                	addi	s0,sp,48
    80002de2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002de4:	05050493          	addi	s1,a0,80
    80002de8:	08050913          	addi	s2,a0,128
    80002dec:	a021                	j	80002df4 <itrunc+0x20>
    80002dee:	0491                	addi	s1,s1,4
    80002df0:	01248d63          	beq	s1,s2,80002e0a <itrunc+0x36>
    if(ip->addrs[i]){
    80002df4:	408c                	lw	a1,0(s1)
    80002df6:	dde5                	beqz	a1,80002dee <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002df8:	0009a503          	lw	a0,0(s3)
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	910080e7          	jalr	-1776(ra) # 8000270c <bfree>
      ip->addrs[i] = 0;
    80002e04:	0004a023          	sw	zero,0(s1)
    80002e08:	b7dd                	j	80002dee <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e0a:	0809a583          	lw	a1,128(s3)
    80002e0e:	ed99                	bnez	a1,80002e2c <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e10:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e14:	854e                	mv	a0,s3
    80002e16:	00000097          	auipc	ra,0x0
    80002e1a:	de0080e7          	jalr	-544(ra) # 80002bf6 <iupdate>
}
    80002e1e:	70a2                	ld	ra,40(sp)
    80002e20:	7402                	ld	s0,32(sp)
    80002e22:	64e2                	ld	s1,24(sp)
    80002e24:	6942                	ld	s2,16(sp)
    80002e26:	69a2                	ld	s3,8(sp)
    80002e28:	6145                	addi	sp,sp,48
    80002e2a:	8082                	ret
    80002e2c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e2e:	0009a503          	lw	a0,0(s3)
    80002e32:	fffff097          	auipc	ra,0xfffff
    80002e36:	696080e7          	jalr	1686(ra) # 800024c8 <bread>
    80002e3a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e3c:	05850493          	addi	s1,a0,88
    80002e40:	45850913          	addi	s2,a0,1112
    80002e44:	a021                	j	80002e4c <itrunc+0x78>
    80002e46:	0491                	addi	s1,s1,4
    80002e48:	01248b63          	beq	s1,s2,80002e5e <itrunc+0x8a>
      if(a[j])
    80002e4c:	408c                	lw	a1,0(s1)
    80002e4e:	dde5                	beqz	a1,80002e46 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002e50:	0009a503          	lw	a0,0(s3)
    80002e54:	00000097          	auipc	ra,0x0
    80002e58:	8b8080e7          	jalr	-1864(ra) # 8000270c <bfree>
    80002e5c:	b7ed                	j	80002e46 <itrunc+0x72>
    brelse(bp);
    80002e5e:	8552                	mv	a0,s4
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	798080e7          	jalr	1944(ra) # 800025f8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e68:	0809a583          	lw	a1,128(s3)
    80002e6c:	0009a503          	lw	a0,0(s3)
    80002e70:	00000097          	auipc	ra,0x0
    80002e74:	89c080e7          	jalr	-1892(ra) # 8000270c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e78:	0809a023          	sw	zero,128(s3)
    80002e7c:	6a02                	ld	s4,0(sp)
    80002e7e:	bf49                	j	80002e10 <itrunc+0x3c>

0000000080002e80 <iput>:
{
    80002e80:	1101                	addi	sp,sp,-32
    80002e82:	ec06                	sd	ra,24(sp)
    80002e84:	e822                	sd	s0,16(sp)
    80002e86:	e426                	sd	s1,8(sp)
    80002e88:	1000                	addi	s0,sp,32
    80002e8a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e8c:	00016517          	auipc	a0,0x16
    80002e90:	6ec50513          	addi	a0,a0,1772 # 80019578 <itable>
    80002e94:	00004097          	auipc	ra,0x4
    80002e98:	860080e7          	jalr	-1952(ra) # 800066f4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e9c:	4498                	lw	a4,8(s1)
    80002e9e:	4785                	li	a5,1
    80002ea0:	02f70263          	beq	a4,a5,80002ec4 <iput+0x44>
  ip->ref--;
    80002ea4:	449c                	lw	a5,8(s1)
    80002ea6:	37fd                	addiw	a5,a5,-1
    80002ea8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002eaa:	00016517          	auipc	a0,0x16
    80002eae:	6ce50513          	addi	a0,a0,1742 # 80019578 <itable>
    80002eb2:	00004097          	auipc	ra,0x4
    80002eb6:	8f6080e7          	jalr	-1802(ra) # 800067a8 <release>
}
    80002eba:	60e2                	ld	ra,24(sp)
    80002ebc:	6442                	ld	s0,16(sp)
    80002ebe:	64a2                	ld	s1,8(sp)
    80002ec0:	6105                	addi	sp,sp,32
    80002ec2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ec4:	40bc                	lw	a5,64(s1)
    80002ec6:	dff9                	beqz	a5,80002ea4 <iput+0x24>
    80002ec8:	04a49783          	lh	a5,74(s1)
    80002ecc:	ffe1                	bnez	a5,80002ea4 <iput+0x24>
    80002ece:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002ed0:	01048913          	addi	s2,s1,16
    80002ed4:	854a                	mv	a0,s2
    80002ed6:	00001097          	auipc	ra,0x1
    80002eda:	ab4080e7          	jalr	-1356(ra) # 8000398a <acquiresleep>
    release(&itable.lock);
    80002ede:	00016517          	auipc	a0,0x16
    80002ee2:	69a50513          	addi	a0,a0,1690 # 80019578 <itable>
    80002ee6:	00004097          	auipc	ra,0x4
    80002eea:	8c2080e7          	jalr	-1854(ra) # 800067a8 <release>
    itrunc(ip);
    80002eee:	8526                	mv	a0,s1
    80002ef0:	00000097          	auipc	ra,0x0
    80002ef4:	ee4080e7          	jalr	-284(ra) # 80002dd4 <itrunc>
    ip->type = 0;
    80002ef8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002efc:	8526                	mv	a0,s1
    80002efe:	00000097          	auipc	ra,0x0
    80002f02:	cf8080e7          	jalr	-776(ra) # 80002bf6 <iupdate>
    ip->valid = 0;
    80002f06:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f0a:	854a                	mv	a0,s2
    80002f0c:	00001097          	auipc	ra,0x1
    80002f10:	ad4080e7          	jalr	-1324(ra) # 800039e0 <releasesleep>
    acquire(&itable.lock);
    80002f14:	00016517          	auipc	a0,0x16
    80002f18:	66450513          	addi	a0,a0,1636 # 80019578 <itable>
    80002f1c:	00003097          	auipc	ra,0x3
    80002f20:	7d8080e7          	jalr	2008(ra) # 800066f4 <acquire>
    80002f24:	6902                	ld	s2,0(sp)
    80002f26:	bfbd                	j	80002ea4 <iput+0x24>

0000000080002f28 <iunlockput>:
{
    80002f28:	1101                	addi	sp,sp,-32
    80002f2a:	ec06                	sd	ra,24(sp)
    80002f2c:	e822                	sd	s0,16(sp)
    80002f2e:	e426                	sd	s1,8(sp)
    80002f30:	1000                	addi	s0,sp,32
    80002f32:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f34:	00000097          	auipc	ra,0x0
    80002f38:	e54080e7          	jalr	-428(ra) # 80002d88 <iunlock>
  iput(ip);
    80002f3c:	8526                	mv	a0,s1
    80002f3e:	00000097          	auipc	ra,0x0
    80002f42:	f42080e7          	jalr	-190(ra) # 80002e80 <iput>
}
    80002f46:	60e2                	ld	ra,24(sp)
    80002f48:	6442                	ld	s0,16(sp)
    80002f4a:	64a2                	ld	s1,8(sp)
    80002f4c:	6105                	addi	sp,sp,32
    80002f4e:	8082                	ret

0000000080002f50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f50:	1141                	addi	sp,sp,-16
    80002f52:	e422                	sd	s0,8(sp)
    80002f54:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f56:	411c                	lw	a5,0(a0)
    80002f58:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f5a:	415c                	lw	a5,4(a0)
    80002f5c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f5e:	04451783          	lh	a5,68(a0)
    80002f62:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f66:	04a51783          	lh	a5,74(a0)
    80002f6a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f6e:	04c56783          	lwu	a5,76(a0)
    80002f72:	e99c                	sd	a5,16(a1)
}
    80002f74:	6422                	ld	s0,8(sp)
    80002f76:	0141                	addi	sp,sp,16
    80002f78:	8082                	ret

0000000080002f7a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f7a:	457c                	lw	a5,76(a0)
    80002f7c:	0ed7ef63          	bltu	a5,a3,8000307a <readi+0x100>
{
    80002f80:	7159                	addi	sp,sp,-112
    80002f82:	f486                	sd	ra,104(sp)
    80002f84:	f0a2                	sd	s0,96(sp)
    80002f86:	eca6                	sd	s1,88(sp)
    80002f88:	fc56                	sd	s5,56(sp)
    80002f8a:	f85a                	sd	s6,48(sp)
    80002f8c:	f45e                	sd	s7,40(sp)
    80002f8e:	f062                	sd	s8,32(sp)
    80002f90:	1880                	addi	s0,sp,112
    80002f92:	8baa                	mv	s7,a0
    80002f94:	8c2e                	mv	s8,a1
    80002f96:	8ab2                	mv	s5,a2
    80002f98:	84b6                	mv	s1,a3
    80002f9a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f9c:	9f35                	addw	a4,a4,a3
    return 0;
    80002f9e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fa0:	0ad76c63          	bltu	a4,a3,80003058 <readi+0xde>
    80002fa4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002fa6:	00e7f463          	bgeu	a5,a4,80002fae <readi+0x34>
    n = ip->size - off;
    80002faa:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fae:	0c0b0463          	beqz	s6,80003076 <readi+0xfc>
    80002fb2:	e8ca                	sd	s2,80(sp)
    80002fb4:	e0d2                	sd	s4,64(sp)
    80002fb6:	ec66                	sd	s9,24(sp)
    80002fb8:	e86a                	sd	s10,16(sp)
    80002fba:	e46e                	sd	s11,8(sp)
    80002fbc:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fbe:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fc2:	5cfd                	li	s9,-1
    80002fc4:	a82d                	j	80002ffe <readi+0x84>
    80002fc6:	020a1d93          	slli	s11,s4,0x20
    80002fca:	020ddd93          	srli	s11,s11,0x20
    80002fce:	05890613          	addi	a2,s2,88
    80002fd2:	86ee                	mv	a3,s11
    80002fd4:	963a                	add	a2,a2,a4
    80002fd6:	85d6                	mv	a1,s5
    80002fd8:	8562                	mv	a0,s8
    80002fda:	fffff097          	auipc	ra,0xfffff
    80002fde:	9ce080e7          	jalr	-1586(ra) # 800019a8 <either_copyout>
    80002fe2:	05950d63          	beq	a0,s9,8000303c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fe6:	854a                	mv	a0,s2
    80002fe8:	fffff097          	auipc	ra,0xfffff
    80002fec:	610080e7          	jalr	1552(ra) # 800025f8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ff0:	013a09bb          	addw	s3,s4,s3
    80002ff4:	009a04bb          	addw	s1,s4,s1
    80002ff8:	9aee                	add	s5,s5,s11
    80002ffa:	0769f863          	bgeu	s3,s6,8000306a <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ffe:	000ba903          	lw	s2,0(s7)
    80003002:	00a4d59b          	srliw	a1,s1,0xa
    80003006:	855e                	mv	a0,s7
    80003008:	00000097          	auipc	ra,0x0
    8000300c:	8ae080e7          	jalr	-1874(ra) # 800028b6 <bmap>
    80003010:	0005059b          	sext.w	a1,a0
    80003014:	854a                	mv	a0,s2
    80003016:	fffff097          	auipc	ra,0xfffff
    8000301a:	4b2080e7          	jalr	1202(ra) # 800024c8 <bread>
    8000301e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003020:	3ff4f713          	andi	a4,s1,1023
    80003024:	40ed07bb          	subw	a5,s10,a4
    80003028:	413b06bb          	subw	a3,s6,s3
    8000302c:	8a3e                	mv	s4,a5
    8000302e:	2781                	sext.w	a5,a5
    80003030:	0006861b          	sext.w	a2,a3
    80003034:	f8f679e3          	bgeu	a2,a5,80002fc6 <readi+0x4c>
    80003038:	8a36                	mv	s4,a3
    8000303a:	b771                	j	80002fc6 <readi+0x4c>
      brelse(bp);
    8000303c:	854a                	mv	a0,s2
    8000303e:	fffff097          	auipc	ra,0xfffff
    80003042:	5ba080e7          	jalr	1466(ra) # 800025f8 <brelse>
      tot = -1;
    80003046:	59fd                	li	s3,-1
      break;
    80003048:	6946                	ld	s2,80(sp)
    8000304a:	6a06                	ld	s4,64(sp)
    8000304c:	6ce2                	ld	s9,24(sp)
    8000304e:	6d42                	ld	s10,16(sp)
    80003050:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003052:	0009851b          	sext.w	a0,s3
    80003056:	69a6                	ld	s3,72(sp)
}
    80003058:	70a6                	ld	ra,104(sp)
    8000305a:	7406                	ld	s0,96(sp)
    8000305c:	64e6                	ld	s1,88(sp)
    8000305e:	7ae2                	ld	s5,56(sp)
    80003060:	7b42                	ld	s6,48(sp)
    80003062:	7ba2                	ld	s7,40(sp)
    80003064:	7c02                	ld	s8,32(sp)
    80003066:	6165                	addi	sp,sp,112
    80003068:	8082                	ret
    8000306a:	6946                	ld	s2,80(sp)
    8000306c:	6a06                	ld	s4,64(sp)
    8000306e:	6ce2                	ld	s9,24(sp)
    80003070:	6d42                	ld	s10,16(sp)
    80003072:	6da2                	ld	s11,8(sp)
    80003074:	bff9                	j	80003052 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003076:	89da                	mv	s3,s6
    80003078:	bfe9                	j	80003052 <readi+0xd8>
    return 0;
    8000307a:	4501                	li	a0,0
}
    8000307c:	8082                	ret

000000008000307e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000307e:	457c                	lw	a5,76(a0)
    80003080:	10d7ee63          	bltu	a5,a3,8000319c <writei+0x11e>
{
    80003084:	7159                	addi	sp,sp,-112
    80003086:	f486                	sd	ra,104(sp)
    80003088:	f0a2                	sd	s0,96(sp)
    8000308a:	e8ca                	sd	s2,80(sp)
    8000308c:	fc56                	sd	s5,56(sp)
    8000308e:	f85a                	sd	s6,48(sp)
    80003090:	f45e                	sd	s7,40(sp)
    80003092:	f062                	sd	s8,32(sp)
    80003094:	1880                	addi	s0,sp,112
    80003096:	8b2a                	mv	s6,a0
    80003098:	8c2e                	mv	s8,a1
    8000309a:	8ab2                	mv	s5,a2
    8000309c:	8936                	mv	s2,a3
    8000309e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030a0:	00e687bb          	addw	a5,a3,a4
    800030a4:	0ed7ee63          	bltu	a5,a3,800031a0 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030a8:	00043737          	lui	a4,0x43
    800030ac:	0ef76c63          	bltu	a4,a5,800031a4 <writei+0x126>
    800030b0:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b2:	0c0b8d63          	beqz	s7,8000318c <writei+0x10e>
    800030b6:	eca6                	sd	s1,88(sp)
    800030b8:	e4ce                	sd	s3,72(sp)
    800030ba:	ec66                	sd	s9,24(sp)
    800030bc:	e86a                	sd	s10,16(sp)
    800030be:	e46e                	sd	s11,8(sp)
    800030c0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030c6:	5cfd                	li	s9,-1
    800030c8:	a091                	j	8000310c <writei+0x8e>
    800030ca:	02099d93          	slli	s11,s3,0x20
    800030ce:	020ddd93          	srli	s11,s11,0x20
    800030d2:	05848513          	addi	a0,s1,88
    800030d6:	86ee                	mv	a3,s11
    800030d8:	8656                	mv	a2,s5
    800030da:	85e2                	mv	a1,s8
    800030dc:	953a                	add	a0,a0,a4
    800030de:	fffff097          	auipc	ra,0xfffff
    800030e2:	920080e7          	jalr	-1760(ra) # 800019fe <either_copyin>
    800030e6:	07950263          	beq	a0,s9,8000314a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030ea:	8526                	mv	a0,s1
    800030ec:	00000097          	auipc	ra,0x0
    800030f0:	780080e7          	jalr	1920(ra) # 8000386c <log_write>
    brelse(bp);
    800030f4:	8526                	mv	a0,s1
    800030f6:	fffff097          	auipc	ra,0xfffff
    800030fa:	502080e7          	jalr	1282(ra) # 800025f8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030fe:	01498a3b          	addw	s4,s3,s4
    80003102:	0129893b          	addw	s2,s3,s2
    80003106:	9aee                	add	s5,s5,s11
    80003108:	057a7663          	bgeu	s4,s7,80003154 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000310c:	000b2483          	lw	s1,0(s6)
    80003110:	00a9559b          	srliw	a1,s2,0xa
    80003114:	855a                	mv	a0,s6
    80003116:	fffff097          	auipc	ra,0xfffff
    8000311a:	7a0080e7          	jalr	1952(ra) # 800028b6 <bmap>
    8000311e:	0005059b          	sext.w	a1,a0
    80003122:	8526                	mv	a0,s1
    80003124:	fffff097          	auipc	ra,0xfffff
    80003128:	3a4080e7          	jalr	932(ra) # 800024c8 <bread>
    8000312c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000312e:	3ff97713          	andi	a4,s2,1023
    80003132:	40ed07bb          	subw	a5,s10,a4
    80003136:	414b86bb          	subw	a3,s7,s4
    8000313a:	89be                	mv	s3,a5
    8000313c:	2781                	sext.w	a5,a5
    8000313e:	0006861b          	sext.w	a2,a3
    80003142:	f8f674e3          	bgeu	a2,a5,800030ca <writei+0x4c>
    80003146:	89b6                	mv	s3,a3
    80003148:	b749                	j	800030ca <writei+0x4c>
      brelse(bp);
    8000314a:	8526                	mv	a0,s1
    8000314c:	fffff097          	auipc	ra,0xfffff
    80003150:	4ac080e7          	jalr	1196(ra) # 800025f8 <brelse>
  }

  if(off > ip->size)
    80003154:	04cb2783          	lw	a5,76(s6)
    80003158:	0327fc63          	bgeu	a5,s2,80003190 <writei+0x112>
    ip->size = off;
    8000315c:	052b2623          	sw	s2,76(s6)
    80003160:	64e6                	ld	s1,88(sp)
    80003162:	69a6                	ld	s3,72(sp)
    80003164:	6ce2                	ld	s9,24(sp)
    80003166:	6d42                	ld	s10,16(sp)
    80003168:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000316a:	855a                	mv	a0,s6
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	a8a080e7          	jalr	-1398(ra) # 80002bf6 <iupdate>

  return tot;
    80003174:	000a051b          	sext.w	a0,s4
    80003178:	6a06                	ld	s4,64(sp)
}
    8000317a:	70a6                	ld	ra,104(sp)
    8000317c:	7406                	ld	s0,96(sp)
    8000317e:	6946                	ld	s2,80(sp)
    80003180:	7ae2                	ld	s5,56(sp)
    80003182:	7b42                	ld	s6,48(sp)
    80003184:	7ba2                	ld	s7,40(sp)
    80003186:	7c02                	ld	s8,32(sp)
    80003188:	6165                	addi	sp,sp,112
    8000318a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000318c:	8a5e                	mv	s4,s7
    8000318e:	bff1                	j	8000316a <writei+0xec>
    80003190:	64e6                	ld	s1,88(sp)
    80003192:	69a6                	ld	s3,72(sp)
    80003194:	6ce2                	ld	s9,24(sp)
    80003196:	6d42                	ld	s10,16(sp)
    80003198:	6da2                	ld	s11,8(sp)
    8000319a:	bfc1                	j	8000316a <writei+0xec>
    return -1;
    8000319c:	557d                	li	a0,-1
}
    8000319e:	8082                	ret
    return -1;
    800031a0:	557d                	li	a0,-1
    800031a2:	bfe1                	j	8000317a <writei+0xfc>
    return -1;
    800031a4:	557d                	li	a0,-1
    800031a6:	bfd1                	j	8000317a <writei+0xfc>

00000000800031a8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031a8:	1141                	addi	sp,sp,-16
    800031aa:	e406                	sd	ra,8(sp)
    800031ac:	e022                	sd	s0,0(sp)
    800031ae:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031b0:	4639                	li	a2,14
    800031b2:	ffffd097          	auipc	ra,0xffffd
    800031b6:	098080e7          	jalr	152(ra) # 8000024a <strncmp>
}
    800031ba:	60a2                	ld	ra,8(sp)
    800031bc:	6402                	ld	s0,0(sp)
    800031be:	0141                	addi	sp,sp,16
    800031c0:	8082                	ret

00000000800031c2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031c2:	7139                	addi	sp,sp,-64
    800031c4:	fc06                	sd	ra,56(sp)
    800031c6:	f822                	sd	s0,48(sp)
    800031c8:	f426                	sd	s1,40(sp)
    800031ca:	f04a                	sd	s2,32(sp)
    800031cc:	ec4e                	sd	s3,24(sp)
    800031ce:	e852                	sd	s4,16(sp)
    800031d0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031d2:	04451703          	lh	a4,68(a0)
    800031d6:	4785                	li	a5,1
    800031d8:	00f71a63          	bne	a4,a5,800031ec <dirlookup+0x2a>
    800031dc:	892a                	mv	s2,a0
    800031de:	89ae                	mv	s3,a1
    800031e0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e2:	457c                	lw	a5,76(a0)
    800031e4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031e6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e8:	e79d                	bnez	a5,80003216 <dirlookup+0x54>
    800031ea:	a8a5                	j	80003262 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031ec:	00005517          	auipc	a0,0x5
    800031f0:	24c50513          	addi	a0,a0,588 # 80008438 <etext+0x438>
    800031f4:	00003097          	auipc	ra,0x3
    800031f8:	f86080e7          	jalr	-122(ra) # 8000617a <panic>
      panic("dirlookup read");
    800031fc:	00005517          	auipc	a0,0x5
    80003200:	25450513          	addi	a0,a0,596 # 80008450 <etext+0x450>
    80003204:	00003097          	auipc	ra,0x3
    80003208:	f76080e7          	jalr	-138(ra) # 8000617a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000320c:	24c1                	addiw	s1,s1,16
    8000320e:	04c92783          	lw	a5,76(s2)
    80003212:	04f4f763          	bgeu	s1,a5,80003260 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003216:	4741                	li	a4,16
    80003218:	86a6                	mv	a3,s1
    8000321a:	fc040613          	addi	a2,s0,-64
    8000321e:	4581                	li	a1,0
    80003220:	854a                	mv	a0,s2
    80003222:	00000097          	auipc	ra,0x0
    80003226:	d58080e7          	jalr	-680(ra) # 80002f7a <readi>
    8000322a:	47c1                	li	a5,16
    8000322c:	fcf518e3          	bne	a0,a5,800031fc <dirlookup+0x3a>
    if(de.inum == 0)
    80003230:	fc045783          	lhu	a5,-64(s0)
    80003234:	dfe1                	beqz	a5,8000320c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003236:	fc240593          	addi	a1,s0,-62
    8000323a:	854e                	mv	a0,s3
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	f6c080e7          	jalr	-148(ra) # 800031a8 <namecmp>
    80003244:	f561                	bnez	a0,8000320c <dirlookup+0x4a>
      if(poff)
    80003246:	000a0463          	beqz	s4,8000324e <dirlookup+0x8c>
        *poff = off;
    8000324a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000324e:	fc045583          	lhu	a1,-64(s0)
    80003252:	00092503          	lw	a0,0(s2)
    80003256:	fffff097          	auipc	ra,0xfffff
    8000325a:	73c080e7          	jalr	1852(ra) # 80002992 <iget>
    8000325e:	a011                	j	80003262 <dirlookup+0xa0>
  return 0;
    80003260:	4501                	li	a0,0
}
    80003262:	70e2                	ld	ra,56(sp)
    80003264:	7442                	ld	s0,48(sp)
    80003266:	74a2                	ld	s1,40(sp)
    80003268:	7902                	ld	s2,32(sp)
    8000326a:	69e2                	ld	s3,24(sp)
    8000326c:	6a42                	ld	s4,16(sp)
    8000326e:	6121                	addi	sp,sp,64
    80003270:	8082                	ret

0000000080003272 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003272:	711d                	addi	sp,sp,-96
    80003274:	ec86                	sd	ra,88(sp)
    80003276:	e8a2                	sd	s0,80(sp)
    80003278:	e4a6                	sd	s1,72(sp)
    8000327a:	e0ca                	sd	s2,64(sp)
    8000327c:	fc4e                	sd	s3,56(sp)
    8000327e:	f852                	sd	s4,48(sp)
    80003280:	f456                	sd	s5,40(sp)
    80003282:	f05a                	sd	s6,32(sp)
    80003284:	ec5e                	sd	s7,24(sp)
    80003286:	e862                	sd	s8,16(sp)
    80003288:	e466                	sd	s9,8(sp)
    8000328a:	1080                	addi	s0,sp,96
    8000328c:	84aa                	mv	s1,a0
    8000328e:	8b2e                	mv	s6,a1
    80003290:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003292:	00054703          	lbu	a4,0(a0)
    80003296:	02f00793          	li	a5,47
    8000329a:	02f70263          	beq	a4,a5,800032be <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000329e:	ffffe097          	auipc	ra,0xffffe
    800032a2:	bcc080e7          	jalr	-1076(ra) # 80000e6a <myproc>
    800032a6:	15053503          	ld	a0,336(a0)
    800032aa:	00000097          	auipc	ra,0x0
    800032ae:	9da080e7          	jalr	-1574(ra) # 80002c84 <idup>
    800032b2:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032b4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032b8:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032ba:	4b85                	li	s7,1
    800032bc:	a875                	j	80003378 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800032be:	4585                	li	a1,1
    800032c0:	4505                	li	a0,1
    800032c2:	fffff097          	auipc	ra,0xfffff
    800032c6:	6d0080e7          	jalr	1744(ra) # 80002992 <iget>
    800032ca:	8a2a                	mv	s4,a0
    800032cc:	b7e5                	j	800032b4 <namex+0x42>
      iunlockput(ip);
    800032ce:	8552                	mv	a0,s4
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	c58080e7          	jalr	-936(ra) # 80002f28 <iunlockput>
      return 0;
    800032d8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032da:	8552                	mv	a0,s4
    800032dc:	60e6                	ld	ra,88(sp)
    800032de:	6446                	ld	s0,80(sp)
    800032e0:	64a6                	ld	s1,72(sp)
    800032e2:	6906                	ld	s2,64(sp)
    800032e4:	79e2                	ld	s3,56(sp)
    800032e6:	7a42                	ld	s4,48(sp)
    800032e8:	7aa2                	ld	s5,40(sp)
    800032ea:	7b02                	ld	s6,32(sp)
    800032ec:	6be2                	ld	s7,24(sp)
    800032ee:	6c42                	ld	s8,16(sp)
    800032f0:	6ca2                	ld	s9,8(sp)
    800032f2:	6125                	addi	sp,sp,96
    800032f4:	8082                	ret
      iunlock(ip);
    800032f6:	8552                	mv	a0,s4
    800032f8:	00000097          	auipc	ra,0x0
    800032fc:	a90080e7          	jalr	-1392(ra) # 80002d88 <iunlock>
      return ip;
    80003300:	bfe9                	j	800032da <namex+0x68>
      iunlockput(ip);
    80003302:	8552                	mv	a0,s4
    80003304:	00000097          	auipc	ra,0x0
    80003308:	c24080e7          	jalr	-988(ra) # 80002f28 <iunlockput>
      return 0;
    8000330c:	8a4e                	mv	s4,s3
    8000330e:	b7f1                	j	800032da <namex+0x68>
  len = path - s;
    80003310:	40998633          	sub	a2,s3,s1
    80003314:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003318:	099c5863          	bge	s8,s9,800033a8 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000331c:	4639                	li	a2,14
    8000331e:	85a6                	mv	a1,s1
    80003320:	8556                	mv	a0,s5
    80003322:	ffffd097          	auipc	ra,0xffffd
    80003326:	eb4080e7          	jalr	-332(ra) # 800001d6 <memmove>
    8000332a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000332c:	0004c783          	lbu	a5,0(s1)
    80003330:	01279763          	bne	a5,s2,8000333e <namex+0xcc>
    path++;
    80003334:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003336:	0004c783          	lbu	a5,0(s1)
    8000333a:	ff278de3          	beq	a5,s2,80003334 <namex+0xc2>
    ilock(ip);
    8000333e:	8552                	mv	a0,s4
    80003340:	00000097          	auipc	ra,0x0
    80003344:	982080e7          	jalr	-1662(ra) # 80002cc2 <ilock>
    if(ip->type != T_DIR){
    80003348:	044a1783          	lh	a5,68(s4)
    8000334c:	f97791e3          	bne	a5,s7,800032ce <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003350:	000b0563          	beqz	s6,8000335a <namex+0xe8>
    80003354:	0004c783          	lbu	a5,0(s1)
    80003358:	dfd9                	beqz	a5,800032f6 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000335a:	4601                	li	a2,0
    8000335c:	85d6                	mv	a1,s5
    8000335e:	8552                	mv	a0,s4
    80003360:	00000097          	auipc	ra,0x0
    80003364:	e62080e7          	jalr	-414(ra) # 800031c2 <dirlookup>
    80003368:	89aa                	mv	s3,a0
    8000336a:	dd41                	beqz	a0,80003302 <namex+0x90>
    iunlockput(ip);
    8000336c:	8552                	mv	a0,s4
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	bba080e7          	jalr	-1094(ra) # 80002f28 <iunlockput>
    ip = next;
    80003376:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003378:	0004c783          	lbu	a5,0(s1)
    8000337c:	01279763          	bne	a5,s2,8000338a <namex+0x118>
    path++;
    80003380:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003382:	0004c783          	lbu	a5,0(s1)
    80003386:	ff278de3          	beq	a5,s2,80003380 <namex+0x10e>
  if(*path == 0)
    8000338a:	cb9d                	beqz	a5,800033c0 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000338c:	0004c783          	lbu	a5,0(s1)
    80003390:	89a6                	mv	s3,s1
  len = path - s;
    80003392:	4c81                	li	s9,0
    80003394:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003396:	01278963          	beq	a5,s2,800033a8 <namex+0x136>
    8000339a:	dbbd                	beqz	a5,80003310 <namex+0x9e>
    path++;
    8000339c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000339e:	0009c783          	lbu	a5,0(s3)
    800033a2:	ff279ce3          	bne	a5,s2,8000339a <namex+0x128>
    800033a6:	b7ad                	j	80003310 <namex+0x9e>
    memmove(name, s, len);
    800033a8:	2601                	sext.w	a2,a2
    800033aa:	85a6                	mv	a1,s1
    800033ac:	8556                	mv	a0,s5
    800033ae:	ffffd097          	auipc	ra,0xffffd
    800033b2:	e28080e7          	jalr	-472(ra) # 800001d6 <memmove>
    name[len] = 0;
    800033b6:	9cd6                	add	s9,s9,s5
    800033b8:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800033bc:	84ce                	mv	s1,s3
    800033be:	b7bd                	j	8000332c <namex+0xba>
  if(nameiparent){
    800033c0:	f00b0de3          	beqz	s6,800032da <namex+0x68>
    iput(ip);
    800033c4:	8552                	mv	a0,s4
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	aba080e7          	jalr	-1350(ra) # 80002e80 <iput>
    return 0;
    800033ce:	4a01                	li	s4,0
    800033d0:	b729                	j	800032da <namex+0x68>

00000000800033d2 <dirlink>:
{
    800033d2:	7139                	addi	sp,sp,-64
    800033d4:	fc06                	sd	ra,56(sp)
    800033d6:	f822                	sd	s0,48(sp)
    800033d8:	f04a                	sd	s2,32(sp)
    800033da:	ec4e                	sd	s3,24(sp)
    800033dc:	e852                	sd	s4,16(sp)
    800033de:	0080                	addi	s0,sp,64
    800033e0:	892a                	mv	s2,a0
    800033e2:	8a2e                	mv	s4,a1
    800033e4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033e6:	4601                	li	a2,0
    800033e8:	00000097          	auipc	ra,0x0
    800033ec:	dda080e7          	jalr	-550(ra) # 800031c2 <dirlookup>
    800033f0:	ed25                	bnez	a0,80003468 <dirlink+0x96>
    800033f2:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033f4:	04c92483          	lw	s1,76(s2)
    800033f8:	c49d                	beqz	s1,80003426 <dirlink+0x54>
    800033fa:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033fc:	4741                	li	a4,16
    800033fe:	86a6                	mv	a3,s1
    80003400:	fc040613          	addi	a2,s0,-64
    80003404:	4581                	li	a1,0
    80003406:	854a                	mv	a0,s2
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	b72080e7          	jalr	-1166(ra) # 80002f7a <readi>
    80003410:	47c1                	li	a5,16
    80003412:	06f51163          	bne	a0,a5,80003474 <dirlink+0xa2>
    if(de.inum == 0)
    80003416:	fc045783          	lhu	a5,-64(s0)
    8000341a:	c791                	beqz	a5,80003426 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000341c:	24c1                	addiw	s1,s1,16
    8000341e:	04c92783          	lw	a5,76(s2)
    80003422:	fcf4ede3          	bltu	s1,a5,800033fc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003426:	4639                	li	a2,14
    80003428:	85d2                	mv	a1,s4
    8000342a:	fc240513          	addi	a0,s0,-62
    8000342e:	ffffd097          	auipc	ra,0xffffd
    80003432:	e52080e7          	jalr	-430(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003436:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000343a:	4741                	li	a4,16
    8000343c:	86a6                	mv	a3,s1
    8000343e:	fc040613          	addi	a2,s0,-64
    80003442:	4581                	li	a1,0
    80003444:	854a                	mv	a0,s2
    80003446:	00000097          	auipc	ra,0x0
    8000344a:	c38080e7          	jalr	-968(ra) # 8000307e <writei>
    8000344e:	872a                	mv	a4,a0
    80003450:	47c1                	li	a5,16
  return 0;
    80003452:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003454:	02f71863          	bne	a4,a5,80003484 <dirlink+0xb2>
    80003458:	74a2                	ld	s1,40(sp)
}
    8000345a:	70e2                	ld	ra,56(sp)
    8000345c:	7442                	ld	s0,48(sp)
    8000345e:	7902                	ld	s2,32(sp)
    80003460:	69e2                	ld	s3,24(sp)
    80003462:	6a42                	ld	s4,16(sp)
    80003464:	6121                	addi	sp,sp,64
    80003466:	8082                	ret
    iput(ip);
    80003468:	00000097          	auipc	ra,0x0
    8000346c:	a18080e7          	jalr	-1512(ra) # 80002e80 <iput>
    return -1;
    80003470:	557d                	li	a0,-1
    80003472:	b7e5                	j	8000345a <dirlink+0x88>
      panic("dirlink read");
    80003474:	00005517          	auipc	a0,0x5
    80003478:	fec50513          	addi	a0,a0,-20 # 80008460 <etext+0x460>
    8000347c:	00003097          	auipc	ra,0x3
    80003480:	cfe080e7          	jalr	-770(ra) # 8000617a <panic>
    panic("dirlink");
    80003484:	00005517          	auipc	a0,0x5
    80003488:	0ec50513          	addi	a0,a0,236 # 80008570 <etext+0x570>
    8000348c:	00003097          	auipc	ra,0x3
    80003490:	cee080e7          	jalr	-786(ra) # 8000617a <panic>

0000000080003494 <namei>:

struct inode*
namei(char *path)
{
    80003494:	1101                	addi	sp,sp,-32
    80003496:	ec06                	sd	ra,24(sp)
    80003498:	e822                	sd	s0,16(sp)
    8000349a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000349c:	fe040613          	addi	a2,s0,-32
    800034a0:	4581                	li	a1,0
    800034a2:	00000097          	auipc	ra,0x0
    800034a6:	dd0080e7          	jalr	-560(ra) # 80003272 <namex>
}
    800034aa:	60e2                	ld	ra,24(sp)
    800034ac:	6442                	ld	s0,16(sp)
    800034ae:	6105                	addi	sp,sp,32
    800034b0:	8082                	ret

00000000800034b2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034b2:	1141                	addi	sp,sp,-16
    800034b4:	e406                	sd	ra,8(sp)
    800034b6:	e022                	sd	s0,0(sp)
    800034b8:	0800                	addi	s0,sp,16
    800034ba:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034bc:	4585                	li	a1,1
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	db4080e7          	jalr	-588(ra) # 80003272 <namex>
}
    800034c6:	60a2                	ld	ra,8(sp)
    800034c8:	6402                	ld	s0,0(sp)
    800034ca:	0141                	addi	sp,sp,16
    800034cc:	8082                	ret

00000000800034ce <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034ce:	1101                	addi	sp,sp,-32
    800034d0:	ec06                	sd	ra,24(sp)
    800034d2:	e822                	sd	s0,16(sp)
    800034d4:	e426                	sd	s1,8(sp)
    800034d6:	e04a                	sd	s2,0(sp)
    800034d8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034da:	00018917          	auipc	s2,0x18
    800034de:	b4690913          	addi	s2,s2,-1210 # 8001b020 <log>
    800034e2:	01892583          	lw	a1,24(s2)
    800034e6:	02892503          	lw	a0,40(s2)
    800034ea:	fffff097          	auipc	ra,0xfffff
    800034ee:	fde080e7          	jalr	-34(ra) # 800024c8 <bread>
    800034f2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034f4:	02c92603          	lw	a2,44(s2)
    800034f8:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034fa:	00c05f63          	blez	a2,80003518 <write_head+0x4a>
    800034fe:	00018717          	auipc	a4,0x18
    80003502:	b5270713          	addi	a4,a4,-1198 # 8001b050 <log+0x30>
    80003506:	87aa                	mv	a5,a0
    80003508:	060a                	slli	a2,a2,0x2
    8000350a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000350c:	4314                	lw	a3,0(a4)
    8000350e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003510:	0711                	addi	a4,a4,4
    80003512:	0791                	addi	a5,a5,4
    80003514:	fec79ce3          	bne	a5,a2,8000350c <write_head+0x3e>
  }
  bwrite(buf);
    80003518:	8526                	mv	a0,s1
    8000351a:	fffff097          	auipc	ra,0xfffff
    8000351e:	0a0080e7          	jalr	160(ra) # 800025ba <bwrite>
  brelse(buf);
    80003522:	8526                	mv	a0,s1
    80003524:	fffff097          	auipc	ra,0xfffff
    80003528:	0d4080e7          	jalr	212(ra) # 800025f8 <brelse>
}
    8000352c:	60e2                	ld	ra,24(sp)
    8000352e:	6442                	ld	s0,16(sp)
    80003530:	64a2                	ld	s1,8(sp)
    80003532:	6902                	ld	s2,0(sp)
    80003534:	6105                	addi	sp,sp,32
    80003536:	8082                	ret

0000000080003538 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003538:	00018797          	auipc	a5,0x18
    8000353c:	b147a783          	lw	a5,-1260(a5) # 8001b04c <log+0x2c>
    80003540:	0af05d63          	blez	a5,800035fa <install_trans+0xc2>
{
    80003544:	7139                	addi	sp,sp,-64
    80003546:	fc06                	sd	ra,56(sp)
    80003548:	f822                	sd	s0,48(sp)
    8000354a:	f426                	sd	s1,40(sp)
    8000354c:	f04a                	sd	s2,32(sp)
    8000354e:	ec4e                	sd	s3,24(sp)
    80003550:	e852                	sd	s4,16(sp)
    80003552:	e456                	sd	s5,8(sp)
    80003554:	e05a                	sd	s6,0(sp)
    80003556:	0080                	addi	s0,sp,64
    80003558:	8b2a                	mv	s6,a0
    8000355a:	00018a97          	auipc	s5,0x18
    8000355e:	af6a8a93          	addi	s5,s5,-1290 # 8001b050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003562:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003564:	00018997          	auipc	s3,0x18
    80003568:	abc98993          	addi	s3,s3,-1348 # 8001b020 <log>
    8000356c:	a00d                	j	8000358e <install_trans+0x56>
    brelse(lbuf);
    8000356e:	854a                	mv	a0,s2
    80003570:	fffff097          	auipc	ra,0xfffff
    80003574:	088080e7          	jalr	136(ra) # 800025f8 <brelse>
    brelse(dbuf);
    80003578:	8526                	mv	a0,s1
    8000357a:	fffff097          	auipc	ra,0xfffff
    8000357e:	07e080e7          	jalr	126(ra) # 800025f8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003582:	2a05                	addiw	s4,s4,1
    80003584:	0a91                	addi	s5,s5,4
    80003586:	02c9a783          	lw	a5,44(s3)
    8000358a:	04fa5e63          	bge	s4,a5,800035e6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000358e:	0189a583          	lw	a1,24(s3)
    80003592:	014585bb          	addw	a1,a1,s4
    80003596:	2585                	addiw	a1,a1,1
    80003598:	0289a503          	lw	a0,40(s3)
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	f2c080e7          	jalr	-212(ra) # 800024c8 <bread>
    800035a4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035a6:	000aa583          	lw	a1,0(s5)
    800035aa:	0289a503          	lw	a0,40(s3)
    800035ae:	fffff097          	auipc	ra,0xfffff
    800035b2:	f1a080e7          	jalr	-230(ra) # 800024c8 <bread>
    800035b6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035b8:	40000613          	li	a2,1024
    800035bc:	05890593          	addi	a1,s2,88
    800035c0:	05850513          	addi	a0,a0,88
    800035c4:	ffffd097          	auipc	ra,0xffffd
    800035c8:	c12080e7          	jalr	-1006(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035cc:	8526                	mv	a0,s1
    800035ce:	fffff097          	auipc	ra,0xfffff
    800035d2:	fec080e7          	jalr	-20(ra) # 800025ba <bwrite>
    if(recovering == 0)
    800035d6:	f80b1ce3          	bnez	s6,8000356e <install_trans+0x36>
      bunpin(dbuf);
    800035da:	8526                	mv	a0,s1
    800035dc:	fffff097          	auipc	ra,0xfffff
    800035e0:	0f4080e7          	jalr	244(ra) # 800026d0 <bunpin>
    800035e4:	b769                	j	8000356e <install_trans+0x36>
}
    800035e6:	70e2                	ld	ra,56(sp)
    800035e8:	7442                	ld	s0,48(sp)
    800035ea:	74a2                	ld	s1,40(sp)
    800035ec:	7902                	ld	s2,32(sp)
    800035ee:	69e2                	ld	s3,24(sp)
    800035f0:	6a42                	ld	s4,16(sp)
    800035f2:	6aa2                	ld	s5,8(sp)
    800035f4:	6b02                	ld	s6,0(sp)
    800035f6:	6121                	addi	sp,sp,64
    800035f8:	8082                	ret
    800035fa:	8082                	ret

00000000800035fc <initlog>:
{
    800035fc:	7179                	addi	sp,sp,-48
    800035fe:	f406                	sd	ra,40(sp)
    80003600:	f022                	sd	s0,32(sp)
    80003602:	ec26                	sd	s1,24(sp)
    80003604:	e84a                	sd	s2,16(sp)
    80003606:	e44e                	sd	s3,8(sp)
    80003608:	1800                	addi	s0,sp,48
    8000360a:	892a                	mv	s2,a0
    8000360c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000360e:	00018497          	auipc	s1,0x18
    80003612:	a1248493          	addi	s1,s1,-1518 # 8001b020 <log>
    80003616:	00005597          	auipc	a1,0x5
    8000361a:	e5a58593          	addi	a1,a1,-422 # 80008470 <etext+0x470>
    8000361e:	8526                	mv	a0,s1
    80003620:	00003097          	auipc	ra,0x3
    80003624:	044080e7          	jalr	68(ra) # 80006664 <initlock>
  log.start = sb->logstart;
    80003628:	0149a583          	lw	a1,20(s3)
    8000362c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000362e:	0109a783          	lw	a5,16(s3)
    80003632:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003634:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003638:	854a                	mv	a0,s2
    8000363a:	fffff097          	auipc	ra,0xfffff
    8000363e:	e8e080e7          	jalr	-370(ra) # 800024c8 <bread>
  log.lh.n = lh->n;
    80003642:	4d30                	lw	a2,88(a0)
    80003644:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003646:	00c05f63          	blez	a2,80003664 <initlog+0x68>
    8000364a:	87aa                	mv	a5,a0
    8000364c:	00018717          	auipc	a4,0x18
    80003650:	a0470713          	addi	a4,a4,-1532 # 8001b050 <log+0x30>
    80003654:	060a                	slli	a2,a2,0x2
    80003656:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003658:	4ff4                	lw	a3,92(a5)
    8000365a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000365c:	0791                	addi	a5,a5,4
    8000365e:	0711                	addi	a4,a4,4
    80003660:	fec79ce3          	bne	a5,a2,80003658 <initlog+0x5c>
  brelse(buf);
    80003664:	fffff097          	auipc	ra,0xfffff
    80003668:	f94080e7          	jalr	-108(ra) # 800025f8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000366c:	4505                	li	a0,1
    8000366e:	00000097          	auipc	ra,0x0
    80003672:	eca080e7          	jalr	-310(ra) # 80003538 <install_trans>
  log.lh.n = 0;
    80003676:	00018797          	auipc	a5,0x18
    8000367a:	9c07ab23          	sw	zero,-1578(a5) # 8001b04c <log+0x2c>
  write_head(); // clear the log
    8000367e:	00000097          	auipc	ra,0x0
    80003682:	e50080e7          	jalr	-432(ra) # 800034ce <write_head>
}
    80003686:	70a2                	ld	ra,40(sp)
    80003688:	7402                	ld	s0,32(sp)
    8000368a:	64e2                	ld	s1,24(sp)
    8000368c:	6942                	ld	s2,16(sp)
    8000368e:	69a2                	ld	s3,8(sp)
    80003690:	6145                	addi	sp,sp,48
    80003692:	8082                	ret

0000000080003694 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003694:	1101                	addi	sp,sp,-32
    80003696:	ec06                	sd	ra,24(sp)
    80003698:	e822                	sd	s0,16(sp)
    8000369a:	e426                	sd	s1,8(sp)
    8000369c:	e04a                	sd	s2,0(sp)
    8000369e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036a0:	00018517          	auipc	a0,0x18
    800036a4:	98050513          	addi	a0,a0,-1664 # 8001b020 <log>
    800036a8:	00003097          	auipc	ra,0x3
    800036ac:	04c080e7          	jalr	76(ra) # 800066f4 <acquire>
  while(1){
    if(log.committing){
    800036b0:	00018497          	auipc	s1,0x18
    800036b4:	97048493          	addi	s1,s1,-1680 # 8001b020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036b8:	4979                	li	s2,30
    800036ba:	a039                	j	800036c8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036bc:	85a6                	mv	a1,s1
    800036be:	8526                	mv	a0,s1
    800036c0:	ffffe097          	auipc	ra,0xffffe
    800036c4:	eaa080e7          	jalr	-342(ra) # 8000156a <sleep>
    if(log.committing){
    800036c8:	50dc                	lw	a5,36(s1)
    800036ca:	fbed                	bnez	a5,800036bc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036cc:	5098                	lw	a4,32(s1)
    800036ce:	2705                	addiw	a4,a4,1
    800036d0:	0027179b          	slliw	a5,a4,0x2
    800036d4:	9fb9                	addw	a5,a5,a4
    800036d6:	0017979b          	slliw	a5,a5,0x1
    800036da:	54d4                	lw	a3,44(s1)
    800036dc:	9fb5                	addw	a5,a5,a3
    800036de:	00f95963          	bge	s2,a5,800036f0 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036e2:	85a6                	mv	a1,s1
    800036e4:	8526                	mv	a0,s1
    800036e6:	ffffe097          	auipc	ra,0xffffe
    800036ea:	e84080e7          	jalr	-380(ra) # 8000156a <sleep>
    800036ee:	bfe9                	j	800036c8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036f0:	00018517          	auipc	a0,0x18
    800036f4:	93050513          	addi	a0,a0,-1744 # 8001b020 <log>
    800036f8:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800036fa:	00003097          	auipc	ra,0x3
    800036fe:	0ae080e7          	jalr	174(ra) # 800067a8 <release>
      break;
    }
  }
}
    80003702:	60e2                	ld	ra,24(sp)
    80003704:	6442                	ld	s0,16(sp)
    80003706:	64a2                	ld	s1,8(sp)
    80003708:	6902                	ld	s2,0(sp)
    8000370a:	6105                	addi	sp,sp,32
    8000370c:	8082                	ret

000000008000370e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000370e:	7139                	addi	sp,sp,-64
    80003710:	fc06                	sd	ra,56(sp)
    80003712:	f822                	sd	s0,48(sp)
    80003714:	f426                	sd	s1,40(sp)
    80003716:	f04a                	sd	s2,32(sp)
    80003718:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000371a:	00018497          	auipc	s1,0x18
    8000371e:	90648493          	addi	s1,s1,-1786 # 8001b020 <log>
    80003722:	8526                	mv	a0,s1
    80003724:	00003097          	auipc	ra,0x3
    80003728:	fd0080e7          	jalr	-48(ra) # 800066f4 <acquire>
  log.outstanding -= 1;
    8000372c:	509c                	lw	a5,32(s1)
    8000372e:	37fd                	addiw	a5,a5,-1
    80003730:	0007891b          	sext.w	s2,a5
    80003734:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003736:	50dc                	lw	a5,36(s1)
    80003738:	e7b9                	bnez	a5,80003786 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000373a:	06091163          	bnez	s2,8000379c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000373e:	00018497          	auipc	s1,0x18
    80003742:	8e248493          	addi	s1,s1,-1822 # 8001b020 <log>
    80003746:	4785                	li	a5,1
    80003748:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000374a:	8526                	mv	a0,s1
    8000374c:	00003097          	auipc	ra,0x3
    80003750:	05c080e7          	jalr	92(ra) # 800067a8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003754:	54dc                	lw	a5,44(s1)
    80003756:	06f04763          	bgtz	a5,800037c4 <end_op+0xb6>
    acquire(&log.lock);
    8000375a:	00018497          	auipc	s1,0x18
    8000375e:	8c648493          	addi	s1,s1,-1850 # 8001b020 <log>
    80003762:	8526                	mv	a0,s1
    80003764:	00003097          	auipc	ra,0x3
    80003768:	f90080e7          	jalr	-112(ra) # 800066f4 <acquire>
    log.committing = 0;
    8000376c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003770:	8526                	mv	a0,s1
    80003772:	ffffe097          	auipc	ra,0xffffe
    80003776:	f84080e7          	jalr	-124(ra) # 800016f6 <wakeup>
    release(&log.lock);
    8000377a:	8526                	mv	a0,s1
    8000377c:	00003097          	auipc	ra,0x3
    80003780:	02c080e7          	jalr	44(ra) # 800067a8 <release>
}
    80003784:	a815                	j	800037b8 <end_op+0xaa>
    80003786:	ec4e                	sd	s3,24(sp)
    80003788:	e852                	sd	s4,16(sp)
    8000378a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000378c:	00005517          	auipc	a0,0x5
    80003790:	cec50513          	addi	a0,a0,-788 # 80008478 <etext+0x478>
    80003794:	00003097          	auipc	ra,0x3
    80003798:	9e6080e7          	jalr	-1562(ra) # 8000617a <panic>
    wakeup(&log);
    8000379c:	00018497          	auipc	s1,0x18
    800037a0:	88448493          	addi	s1,s1,-1916 # 8001b020 <log>
    800037a4:	8526                	mv	a0,s1
    800037a6:	ffffe097          	auipc	ra,0xffffe
    800037aa:	f50080e7          	jalr	-176(ra) # 800016f6 <wakeup>
  release(&log.lock);
    800037ae:	8526                	mv	a0,s1
    800037b0:	00003097          	auipc	ra,0x3
    800037b4:	ff8080e7          	jalr	-8(ra) # 800067a8 <release>
}
    800037b8:	70e2                	ld	ra,56(sp)
    800037ba:	7442                	ld	s0,48(sp)
    800037bc:	74a2                	ld	s1,40(sp)
    800037be:	7902                	ld	s2,32(sp)
    800037c0:	6121                	addi	sp,sp,64
    800037c2:	8082                	ret
    800037c4:	ec4e                	sd	s3,24(sp)
    800037c6:	e852                	sd	s4,16(sp)
    800037c8:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800037ca:	00018a97          	auipc	s5,0x18
    800037ce:	886a8a93          	addi	s5,s5,-1914 # 8001b050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037d2:	00018a17          	auipc	s4,0x18
    800037d6:	84ea0a13          	addi	s4,s4,-1970 # 8001b020 <log>
    800037da:	018a2583          	lw	a1,24(s4)
    800037de:	012585bb          	addw	a1,a1,s2
    800037e2:	2585                	addiw	a1,a1,1
    800037e4:	028a2503          	lw	a0,40(s4)
    800037e8:	fffff097          	auipc	ra,0xfffff
    800037ec:	ce0080e7          	jalr	-800(ra) # 800024c8 <bread>
    800037f0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037f2:	000aa583          	lw	a1,0(s5)
    800037f6:	028a2503          	lw	a0,40(s4)
    800037fa:	fffff097          	auipc	ra,0xfffff
    800037fe:	cce080e7          	jalr	-818(ra) # 800024c8 <bread>
    80003802:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003804:	40000613          	li	a2,1024
    80003808:	05850593          	addi	a1,a0,88
    8000380c:	05848513          	addi	a0,s1,88
    80003810:	ffffd097          	auipc	ra,0xffffd
    80003814:	9c6080e7          	jalr	-1594(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003818:	8526                	mv	a0,s1
    8000381a:	fffff097          	auipc	ra,0xfffff
    8000381e:	da0080e7          	jalr	-608(ra) # 800025ba <bwrite>
    brelse(from);
    80003822:	854e                	mv	a0,s3
    80003824:	fffff097          	auipc	ra,0xfffff
    80003828:	dd4080e7          	jalr	-556(ra) # 800025f8 <brelse>
    brelse(to);
    8000382c:	8526                	mv	a0,s1
    8000382e:	fffff097          	auipc	ra,0xfffff
    80003832:	dca080e7          	jalr	-566(ra) # 800025f8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003836:	2905                	addiw	s2,s2,1
    80003838:	0a91                	addi	s5,s5,4
    8000383a:	02ca2783          	lw	a5,44(s4)
    8000383e:	f8f94ee3          	blt	s2,a5,800037da <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003842:	00000097          	auipc	ra,0x0
    80003846:	c8c080e7          	jalr	-884(ra) # 800034ce <write_head>
    install_trans(0); // Now install writes to home locations
    8000384a:	4501                	li	a0,0
    8000384c:	00000097          	auipc	ra,0x0
    80003850:	cec080e7          	jalr	-788(ra) # 80003538 <install_trans>
    log.lh.n = 0;
    80003854:	00017797          	auipc	a5,0x17
    80003858:	7e07ac23          	sw	zero,2040(a5) # 8001b04c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000385c:	00000097          	auipc	ra,0x0
    80003860:	c72080e7          	jalr	-910(ra) # 800034ce <write_head>
    80003864:	69e2                	ld	s3,24(sp)
    80003866:	6a42                	ld	s4,16(sp)
    80003868:	6aa2                	ld	s5,8(sp)
    8000386a:	bdc5                	j	8000375a <end_op+0x4c>

000000008000386c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000386c:	1101                	addi	sp,sp,-32
    8000386e:	ec06                	sd	ra,24(sp)
    80003870:	e822                	sd	s0,16(sp)
    80003872:	e426                	sd	s1,8(sp)
    80003874:	e04a                	sd	s2,0(sp)
    80003876:	1000                	addi	s0,sp,32
    80003878:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000387a:	00017917          	auipc	s2,0x17
    8000387e:	7a690913          	addi	s2,s2,1958 # 8001b020 <log>
    80003882:	854a                	mv	a0,s2
    80003884:	00003097          	auipc	ra,0x3
    80003888:	e70080e7          	jalr	-400(ra) # 800066f4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000388c:	02c92603          	lw	a2,44(s2)
    80003890:	47f5                	li	a5,29
    80003892:	06c7c563          	blt	a5,a2,800038fc <log_write+0x90>
    80003896:	00017797          	auipc	a5,0x17
    8000389a:	7a67a783          	lw	a5,1958(a5) # 8001b03c <log+0x1c>
    8000389e:	37fd                	addiw	a5,a5,-1
    800038a0:	04f65e63          	bge	a2,a5,800038fc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038a4:	00017797          	auipc	a5,0x17
    800038a8:	79c7a783          	lw	a5,1948(a5) # 8001b040 <log+0x20>
    800038ac:	06f05063          	blez	a5,8000390c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038b0:	4781                	li	a5,0
    800038b2:	06c05563          	blez	a2,8000391c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038b6:	44cc                	lw	a1,12(s1)
    800038b8:	00017717          	auipc	a4,0x17
    800038bc:	79870713          	addi	a4,a4,1944 # 8001b050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038c0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038c2:	4314                	lw	a3,0(a4)
    800038c4:	04b68c63          	beq	a3,a1,8000391c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038c8:	2785                	addiw	a5,a5,1
    800038ca:	0711                	addi	a4,a4,4
    800038cc:	fef61be3          	bne	a2,a5,800038c2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038d0:	0621                	addi	a2,a2,8
    800038d2:	060a                	slli	a2,a2,0x2
    800038d4:	00017797          	auipc	a5,0x17
    800038d8:	74c78793          	addi	a5,a5,1868 # 8001b020 <log>
    800038dc:	97b2                	add	a5,a5,a2
    800038de:	44d8                	lw	a4,12(s1)
    800038e0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038e2:	8526                	mv	a0,s1
    800038e4:	fffff097          	auipc	ra,0xfffff
    800038e8:	db0080e7          	jalr	-592(ra) # 80002694 <bpin>
    log.lh.n++;
    800038ec:	00017717          	auipc	a4,0x17
    800038f0:	73470713          	addi	a4,a4,1844 # 8001b020 <log>
    800038f4:	575c                	lw	a5,44(a4)
    800038f6:	2785                	addiw	a5,a5,1
    800038f8:	d75c                	sw	a5,44(a4)
    800038fa:	a82d                	j	80003934 <log_write+0xc8>
    panic("too big a transaction");
    800038fc:	00005517          	auipc	a0,0x5
    80003900:	b8c50513          	addi	a0,a0,-1140 # 80008488 <etext+0x488>
    80003904:	00003097          	auipc	ra,0x3
    80003908:	876080e7          	jalr	-1930(ra) # 8000617a <panic>
    panic("log_write outside of trans");
    8000390c:	00005517          	auipc	a0,0x5
    80003910:	b9450513          	addi	a0,a0,-1132 # 800084a0 <etext+0x4a0>
    80003914:	00003097          	auipc	ra,0x3
    80003918:	866080e7          	jalr	-1946(ra) # 8000617a <panic>
  log.lh.block[i] = b->blockno;
    8000391c:	00878693          	addi	a3,a5,8
    80003920:	068a                	slli	a3,a3,0x2
    80003922:	00017717          	auipc	a4,0x17
    80003926:	6fe70713          	addi	a4,a4,1790 # 8001b020 <log>
    8000392a:	9736                	add	a4,a4,a3
    8000392c:	44d4                	lw	a3,12(s1)
    8000392e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003930:	faf609e3          	beq	a2,a5,800038e2 <log_write+0x76>
  }
  release(&log.lock);
    80003934:	00017517          	auipc	a0,0x17
    80003938:	6ec50513          	addi	a0,a0,1772 # 8001b020 <log>
    8000393c:	00003097          	auipc	ra,0x3
    80003940:	e6c080e7          	jalr	-404(ra) # 800067a8 <release>
}
    80003944:	60e2                	ld	ra,24(sp)
    80003946:	6442                	ld	s0,16(sp)
    80003948:	64a2                	ld	s1,8(sp)
    8000394a:	6902                	ld	s2,0(sp)
    8000394c:	6105                	addi	sp,sp,32
    8000394e:	8082                	ret

0000000080003950 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003950:	1101                	addi	sp,sp,-32
    80003952:	ec06                	sd	ra,24(sp)
    80003954:	e822                	sd	s0,16(sp)
    80003956:	e426                	sd	s1,8(sp)
    80003958:	e04a                	sd	s2,0(sp)
    8000395a:	1000                	addi	s0,sp,32
    8000395c:	84aa                	mv	s1,a0
    8000395e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003960:	00005597          	auipc	a1,0x5
    80003964:	b6058593          	addi	a1,a1,-1184 # 800084c0 <etext+0x4c0>
    80003968:	0521                	addi	a0,a0,8
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	cfa080e7          	jalr	-774(ra) # 80006664 <initlock>
  lk->name = name;
    80003972:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003976:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000397a:	0204a423          	sw	zero,40(s1)
}
    8000397e:	60e2                	ld	ra,24(sp)
    80003980:	6442                	ld	s0,16(sp)
    80003982:	64a2                	ld	s1,8(sp)
    80003984:	6902                	ld	s2,0(sp)
    80003986:	6105                	addi	sp,sp,32
    80003988:	8082                	ret

000000008000398a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000398a:	1101                	addi	sp,sp,-32
    8000398c:	ec06                	sd	ra,24(sp)
    8000398e:	e822                	sd	s0,16(sp)
    80003990:	e426                	sd	s1,8(sp)
    80003992:	e04a                	sd	s2,0(sp)
    80003994:	1000                	addi	s0,sp,32
    80003996:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003998:	00850913          	addi	s2,a0,8
    8000399c:	854a                	mv	a0,s2
    8000399e:	00003097          	auipc	ra,0x3
    800039a2:	d56080e7          	jalr	-682(ra) # 800066f4 <acquire>
  while (lk->locked) {
    800039a6:	409c                	lw	a5,0(s1)
    800039a8:	cb89                	beqz	a5,800039ba <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039aa:	85ca                	mv	a1,s2
    800039ac:	8526                	mv	a0,s1
    800039ae:	ffffe097          	auipc	ra,0xffffe
    800039b2:	bbc080e7          	jalr	-1092(ra) # 8000156a <sleep>
  while (lk->locked) {
    800039b6:	409c                	lw	a5,0(s1)
    800039b8:	fbed                	bnez	a5,800039aa <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039ba:	4785                	li	a5,1
    800039bc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039be:	ffffd097          	auipc	ra,0xffffd
    800039c2:	4ac080e7          	jalr	1196(ra) # 80000e6a <myproc>
    800039c6:	591c                	lw	a5,48(a0)
    800039c8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039ca:	854a                	mv	a0,s2
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	ddc080e7          	jalr	-548(ra) # 800067a8 <release>
}
    800039d4:	60e2                	ld	ra,24(sp)
    800039d6:	6442                	ld	s0,16(sp)
    800039d8:	64a2                	ld	s1,8(sp)
    800039da:	6902                	ld	s2,0(sp)
    800039dc:	6105                	addi	sp,sp,32
    800039de:	8082                	ret

00000000800039e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039e0:	1101                	addi	sp,sp,-32
    800039e2:	ec06                	sd	ra,24(sp)
    800039e4:	e822                	sd	s0,16(sp)
    800039e6:	e426                	sd	s1,8(sp)
    800039e8:	e04a                	sd	s2,0(sp)
    800039ea:	1000                	addi	s0,sp,32
    800039ec:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039ee:	00850913          	addi	s2,a0,8
    800039f2:	854a                	mv	a0,s2
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	d00080e7          	jalr	-768(ra) # 800066f4 <acquire>
  lk->locked = 0;
    800039fc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a00:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a04:	8526                	mv	a0,s1
    80003a06:	ffffe097          	auipc	ra,0xffffe
    80003a0a:	cf0080e7          	jalr	-784(ra) # 800016f6 <wakeup>
  release(&lk->lk);
    80003a0e:	854a                	mv	a0,s2
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	d98080e7          	jalr	-616(ra) # 800067a8 <release>
}
    80003a18:	60e2                	ld	ra,24(sp)
    80003a1a:	6442                	ld	s0,16(sp)
    80003a1c:	64a2                	ld	s1,8(sp)
    80003a1e:	6902                	ld	s2,0(sp)
    80003a20:	6105                	addi	sp,sp,32
    80003a22:	8082                	ret

0000000080003a24 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a24:	7179                	addi	sp,sp,-48
    80003a26:	f406                	sd	ra,40(sp)
    80003a28:	f022                	sd	s0,32(sp)
    80003a2a:	ec26                	sd	s1,24(sp)
    80003a2c:	e84a                	sd	s2,16(sp)
    80003a2e:	1800                	addi	s0,sp,48
    80003a30:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a32:	00850913          	addi	s2,a0,8
    80003a36:	854a                	mv	a0,s2
    80003a38:	00003097          	auipc	ra,0x3
    80003a3c:	cbc080e7          	jalr	-836(ra) # 800066f4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a40:	409c                	lw	a5,0(s1)
    80003a42:	ef91                	bnez	a5,80003a5e <holdingsleep+0x3a>
    80003a44:	4481                	li	s1,0
  release(&lk->lk);
    80003a46:	854a                	mv	a0,s2
    80003a48:	00003097          	auipc	ra,0x3
    80003a4c:	d60080e7          	jalr	-672(ra) # 800067a8 <release>
  return r;
}
    80003a50:	8526                	mv	a0,s1
    80003a52:	70a2                	ld	ra,40(sp)
    80003a54:	7402                	ld	s0,32(sp)
    80003a56:	64e2                	ld	s1,24(sp)
    80003a58:	6942                	ld	s2,16(sp)
    80003a5a:	6145                	addi	sp,sp,48
    80003a5c:	8082                	ret
    80003a5e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a60:	0284a983          	lw	s3,40(s1)
    80003a64:	ffffd097          	auipc	ra,0xffffd
    80003a68:	406080e7          	jalr	1030(ra) # 80000e6a <myproc>
    80003a6c:	5904                	lw	s1,48(a0)
    80003a6e:	413484b3          	sub	s1,s1,s3
    80003a72:	0014b493          	seqz	s1,s1
    80003a76:	69a2                	ld	s3,8(sp)
    80003a78:	b7f9                	j	80003a46 <holdingsleep+0x22>

0000000080003a7a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a7a:	1141                	addi	sp,sp,-16
    80003a7c:	e406                	sd	ra,8(sp)
    80003a7e:	e022                	sd	s0,0(sp)
    80003a80:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a82:	00005597          	auipc	a1,0x5
    80003a86:	a4e58593          	addi	a1,a1,-1458 # 800084d0 <etext+0x4d0>
    80003a8a:	00017517          	auipc	a0,0x17
    80003a8e:	6de50513          	addi	a0,a0,1758 # 8001b168 <ftable>
    80003a92:	00003097          	auipc	ra,0x3
    80003a96:	bd2080e7          	jalr	-1070(ra) # 80006664 <initlock>
}
    80003a9a:	60a2                	ld	ra,8(sp)
    80003a9c:	6402                	ld	s0,0(sp)
    80003a9e:	0141                	addi	sp,sp,16
    80003aa0:	8082                	ret

0000000080003aa2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003aa2:	1101                	addi	sp,sp,-32
    80003aa4:	ec06                	sd	ra,24(sp)
    80003aa6:	e822                	sd	s0,16(sp)
    80003aa8:	e426                	sd	s1,8(sp)
    80003aaa:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003aac:	00017517          	auipc	a0,0x17
    80003ab0:	6bc50513          	addi	a0,a0,1724 # 8001b168 <ftable>
    80003ab4:	00003097          	auipc	ra,0x3
    80003ab8:	c40080e7          	jalr	-960(ra) # 800066f4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003abc:	00017497          	auipc	s1,0x17
    80003ac0:	6c448493          	addi	s1,s1,1732 # 8001b180 <ftable+0x18>
    80003ac4:	00018717          	auipc	a4,0x18
    80003ac8:	65c70713          	addi	a4,a4,1628 # 8001c120 <ftable+0xfb8>
    if(f->ref == 0){
    80003acc:	40dc                	lw	a5,4(s1)
    80003ace:	cf99                	beqz	a5,80003aec <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ad0:	02848493          	addi	s1,s1,40
    80003ad4:	fee49ce3          	bne	s1,a4,80003acc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ad8:	00017517          	auipc	a0,0x17
    80003adc:	69050513          	addi	a0,a0,1680 # 8001b168 <ftable>
    80003ae0:	00003097          	auipc	ra,0x3
    80003ae4:	cc8080e7          	jalr	-824(ra) # 800067a8 <release>
  return 0;
    80003ae8:	4481                	li	s1,0
    80003aea:	a819                	j	80003b00 <filealloc+0x5e>
      f->ref = 1;
    80003aec:	4785                	li	a5,1
    80003aee:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003af0:	00017517          	auipc	a0,0x17
    80003af4:	67850513          	addi	a0,a0,1656 # 8001b168 <ftable>
    80003af8:	00003097          	auipc	ra,0x3
    80003afc:	cb0080e7          	jalr	-848(ra) # 800067a8 <release>
}
    80003b00:	8526                	mv	a0,s1
    80003b02:	60e2                	ld	ra,24(sp)
    80003b04:	6442                	ld	s0,16(sp)
    80003b06:	64a2                	ld	s1,8(sp)
    80003b08:	6105                	addi	sp,sp,32
    80003b0a:	8082                	ret

0000000080003b0c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b0c:	1101                	addi	sp,sp,-32
    80003b0e:	ec06                	sd	ra,24(sp)
    80003b10:	e822                	sd	s0,16(sp)
    80003b12:	e426                	sd	s1,8(sp)
    80003b14:	1000                	addi	s0,sp,32
    80003b16:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b18:	00017517          	auipc	a0,0x17
    80003b1c:	65050513          	addi	a0,a0,1616 # 8001b168 <ftable>
    80003b20:	00003097          	auipc	ra,0x3
    80003b24:	bd4080e7          	jalr	-1068(ra) # 800066f4 <acquire>
  if(f->ref < 1)
    80003b28:	40dc                	lw	a5,4(s1)
    80003b2a:	02f05263          	blez	a5,80003b4e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b2e:	2785                	addiw	a5,a5,1
    80003b30:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b32:	00017517          	auipc	a0,0x17
    80003b36:	63650513          	addi	a0,a0,1590 # 8001b168 <ftable>
    80003b3a:	00003097          	auipc	ra,0x3
    80003b3e:	c6e080e7          	jalr	-914(ra) # 800067a8 <release>
  return f;
}
    80003b42:	8526                	mv	a0,s1
    80003b44:	60e2                	ld	ra,24(sp)
    80003b46:	6442                	ld	s0,16(sp)
    80003b48:	64a2                	ld	s1,8(sp)
    80003b4a:	6105                	addi	sp,sp,32
    80003b4c:	8082                	ret
    panic("filedup");
    80003b4e:	00005517          	auipc	a0,0x5
    80003b52:	98a50513          	addi	a0,a0,-1654 # 800084d8 <etext+0x4d8>
    80003b56:	00002097          	auipc	ra,0x2
    80003b5a:	624080e7          	jalr	1572(ra) # 8000617a <panic>

0000000080003b5e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b5e:	7139                	addi	sp,sp,-64
    80003b60:	fc06                	sd	ra,56(sp)
    80003b62:	f822                	sd	s0,48(sp)
    80003b64:	f426                	sd	s1,40(sp)
    80003b66:	0080                	addi	s0,sp,64
    80003b68:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b6a:	00017517          	auipc	a0,0x17
    80003b6e:	5fe50513          	addi	a0,a0,1534 # 8001b168 <ftable>
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	b82080e7          	jalr	-1150(ra) # 800066f4 <acquire>
  if(f->ref < 1)
    80003b7a:	40dc                	lw	a5,4(s1)
    80003b7c:	04f05c63          	blez	a5,80003bd4 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003b80:	37fd                	addiw	a5,a5,-1
    80003b82:	0007871b          	sext.w	a4,a5
    80003b86:	c0dc                	sw	a5,4(s1)
    80003b88:	06e04263          	bgtz	a4,80003bec <fileclose+0x8e>
    80003b8c:	f04a                	sd	s2,32(sp)
    80003b8e:	ec4e                	sd	s3,24(sp)
    80003b90:	e852                	sd	s4,16(sp)
    80003b92:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b94:	0004a903          	lw	s2,0(s1)
    80003b98:	0094ca83          	lbu	s5,9(s1)
    80003b9c:	0104ba03          	ld	s4,16(s1)
    80003ba0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ba4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ba8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bac:	00017517          	auipc	a0,0x17
    80003bb0:	5bc50513          	addi	a0,a0,1468 # 8001b168 <ftable>
    80003bb4:	00003097          	auipc	ra,0x3
    80003bb8:	bf4080e7          	jalr	-1036(ra) # 800067a8 <release>

  if(ff.type == FD_PIPE){
    80003bbc:	4785                	li	a5,1
    80003bbe:	04f90463          	beq	s2,a5,80003c06 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bc2:	3979                	addiw	s2,s2,-2
    80003bc4:	4785                	li	a5,1
    80003bc6:	0527fb63          	bgeu	a5,s2,80003c1c <fileclose+0xbe>
    80003bca:	7902                	ld	s2,32(sp)
    80003bcc:	69e2                	ld	s3,24(sp)
    80003bce:	6a42                	ld	s4,16(sp)
    80003bd0:	6aa2                	ld	s5,8(sp)
    80003bd2:	a02d                	j	80003bfc <fileclose+0x9e>
    80003bd4:	f04a                	sd	s2,32(sp)
    80003bd6:	ec4e                	sd	s3,24(sp)
    80003bd8:	e852                	sd	s4,16(sp)
    80003bda:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003bdc:	00005517          	auipc	a0,0x5
    80003be0:	90450513          	addi	a0,a0,-1788 # 800084e0 <etext+0x4e0>
    80003be4:	00002097          	auipc	ra,0x2
    80003be8:	596080e7          	jalr	1430(ra) # 8000617a <panic>
    release(&ftable.lock);
    80003bec:	00017517          	auipc	a0,0x17
    80003bf0:	57c50513          	addi	a0,a0,1404 # 8001b168 <ftable>
    80003bf4:	00003097          	auipc	ra,0x3
    80003bf8:	bb4080e7          	jalr	-1100(ra) # 800067a8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003bfc:	70e2                	ld	ra,56(sp)
    80003bfe:	7442                	ld	s0,48(sp)
    80003c00:	74a2                	ld	s1,40(sp)
    80003c02:	6121                	addi	sp,sp,64
    80003c04:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c06:	85d6                	mv	a1,s5
    80003c08:	8552                	mv	a0,s4
    80003c0a:	00000097          	auipc	ra,0x0
    80003c0e:	3a2080e7          	jalr	930(ra) # 80003fac <pipeclose>
    80003c12:	7902                	ld	s2,32(sp)
    80003c14:	69e2                	ld	s3,24(sp)
    80003c16:	6a42                	ld	s4,16(sp)
    80003c18:	6aa2                	ld	s5,8(sp)
    80003c1a:	b7cd                	j	80003bfc <fileclose+0x9e>
    begin_op();
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	a78080e7          	jalr	-1416(ra) # 80003694 <begin_op>
    iput(ff.ip);
    80003c24:	854e                	mv	a0,s3
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	25a080e7          	jalr	602(ra) # 80002e80 <iput>
    end_op();
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	ae0080e7          	jalr	-1312(ra) # 8000370e <end_op>
    80003c36:	7902                	ld	s2,32(sp)
    80003c38:	69e2                	ld	s3,24(sp)
    80003c3a:	6a42                	ld	s4,16(sp)
    80003c3c:	6aa2                	ld	s5,8(sp)
    80003c3e:	bf7d                	j	80003bfc <fileclose+0x9e>

0000000080003c40 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c40:	715d                	addi	sp,sp,-80
    80003c42:	e486                	sd	ra,72(sp)
    80003c44:	e0a2                	sd	s0,64(sp)
    80003c46:	fc26                	sd	s1,56(sp)
    80003c48:	f44e                	sd	s3,40(sp)
    80003c4a:	0880                	addi	s0,sp,80
    80003c4c:	84aa                	mv	s1,a0
    80003c4e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c50:	ffffd097          	auipc	ra,0xffffd
    80003c54:	21a080e7          	jalr	538(ra) # 80000e6a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c58:	409c                	lw	a5,0(s1)
    80003c5a:	37f9                	addiw	a5,a5,-2
    80003c5c:	4705                	li	a4,1
    80003c5e:	04f76863          	bltu	a4,a5,80003cae <filestat+0x6e>
    80003c62:	f84a                	sd	s2,48(sp)
    80003c64:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c66:	6c88                	ld	a0,24(s1)
    80003c68:	fffff097          	auipc	ra,0xfffff
    80003c6c:	05a080e7          	jalr	90(ra) # 80002cc2 <ilock>
    stati(f->ip, &st);
    80003c70:	fb840593          	addi	a1,s0,-72
    80003c74:	6c88                	ld	a0,24(s1)
    80003c76:	fffff097          	auipc	ra,0xfffff
    80003c7a:	2da080e7          	jalr	730(ra) # 80002f50 <stati>
    iunlock(f->ip);
    80003c7e:	6c88                	ld	a0,24(s1)
    80003c80:	fffff097          	auipc	ra,0xfffff
    80003c84:	108080e7          	jalr	264(ra) # 80002d88 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c88:	46e1                	li	a3,24
    80003c8a:	fb840613          	addi	a2,s0,-72
    80003c8e:	85ce                	mv	a1,s3
    80003c90:	05093503          	ld	a0,80(s2)
    80003c94:	ffffd097          	auipc	ra,0xffffd
    80003c98:	e72080e7          	jalr	-398(ra) # 80000b06 <copyout>
    80003c9c:	41f5551b          	sraiw	a0,a0,0x1f
    80003ca0:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003ca2:	60a6                	ld	ra,72(sp)
    80003ca4:	6406                	ld	s0,64(sp)
    80003ca6:	74e2                	ld	s1,56(sp)
    80003ca8:	79a2                	ld	s3,40(sp)
    80003caa:	6161                	addi	sp,sp,80
    80003cac:	8082                	ret
  return -1;
    80003cae:	557d                	li	a0,-1
    80003cb0:	bfcd                	j	80003ca2 <filestat+0x62>

0000000080003cb2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cb2:	7179                	addi	sp,sp,-48
    80003cb4:	f406                	sd	ra,40(sp)
    80003cb6:	f022                	sd	s0,32(sp)
    80003cb8:	e84a                	sd	s2,16(sp)
    80003cba:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cbc:	00854783          	lbu	a5,8(a0)
    80003cc0:	cbc5                	beqz	a5,80003d70 <fileread+0xbe>
    80003cc2:	ec26                	sd	s1,24(sp)
    80003cc4:	e44e                	sd	s3,8(sp)
    80003cc6:	84aa                	mv	s1,a0
    80003cc8:	89ae                	mv	s3,a1
    80003cca:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ccc:	411c                	lw	a5,0(a0)
    80003cce:	4705                	li	a4,1
    80003cd0:	04e78963          	beq	a5,a4,80003d22 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cd4:	470d                	li	a4,3
    80003cd6:	04e78f63          	beq	a5,a4,80003d34 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cda:	4709                	li	a4,2
    80003cdc:	08e79263          	bne	a5,a4,80003d60 <fileread+0xae>
    ilock(f->ip);
    80003ce0:	6d08                	ld	a0,24(a0)
    80003ce2:	fffff097          	auipc	ra,0xfffff
    80003ce6:	fe0080e7          	jalr	-32(ra) # 80002cc2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cea:	874a                	mv	a4,s2
    80003cec:	5094                	lw	a3,32(s1)
    80003cee:	864e                	mv	a2,s3
    80003cf0:	4585                	li	a1,1
    80003cf2:	6c88                	ld	a0,24(s1)
    80003cf4:	fffff097          	auipc	ra,0xfffff
    80003cf8:	286080e7          	jalr	646(ra) # 80002f7a <readi>
    80003cfc:	892a                	mv	s2,a0
    80003cfe:	00a05563          	blez	a0,80003d08 <fileread+0x56>
      f->off += r;
    80003d02:	509c                	lw	a5,32(s1)
    80003d04:	9fa9                	addw	a5,a5,a0
    80003d06:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d08:	6c88                	ld	a0,24(s1)
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	07e080e7          	jalr	126(ra) # 80002d88 <iunlock>
    80003d12:	64e2                	ld	s1,24(sp)
    80003d14:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003d16:	854a                	mv	a0,s2
    80003d18:	70a2                	ld	ra,40(sp)
    80003d1a:	7402                	ld	s0,32(sp)
    80003d1c:	6942                	ld	s2,16(sp)
    80003d1e:	6145                	addi	sp,sp,48
    80003d20:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d22:	6908                	ld	a0,16(a0)
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	3fa080e7          	jalr	1018(ra) # 8000411e <piperead>
    80003d2c:	892a                	mv	s2,a0
    80003d2e:	64e2                	ld	s1,24(sp)
    80003d30:	69a2                	ld	s3,8(sp)
    80003d32:	b7d5                	j	80003d16 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d34:	02451783          	lh	a5,36(a0)
    80003d38:	03079693          	slli	a3,a5,0x30
    80003d3c:	92c1                	srli	a3,a3,0x30
    80003d3e:	4725                	li	a4,9
    80003d40:	02d76a63          	bltu	a4,a3,80003d74 <fileread+0xc2>
    80003d44:	0792                	slli	a5,a5,0x4
    80003d46:	00017717          	auipc	a4,0x17
    80003d4a:	38270713          	addi	a4,a4,898 # 8001b0c8 <devsw>
    80003d4e:	97ba                	add	a5,a5,a4
    80003d50:	639c                	ld	a5,0(a5)
    80003d52:	c78d                	beqz	a5,80003d7c <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003d54:	4505                	li	a0,1
    80003d56:	9782                	jalr	a5
    80003d58:	892a                	mv	s2,a0
    80003d5a:	64e2                	ld	s1,24(sp)
    80003d5c:	69a2                	ld	s3,8(sp)
    80003d5e:	bf65                	j	80003d16 <fileread+0x64>
    panic("fileread");
    80003d60:	00004517          	auipc	a0,0x4
    80003d64:	79050513          	addi	a0,a0,1936 # 800084f0 <etext+0x4f0>
    80003d68:	00002097          	auipc	ra,0x2
    80003d6c:	412080e7          	jalr	1042(ra) # 8000617a <panic>
    return -1;
    80003d70:	597d                	li	s2,-1
    80003d72:	b755                	j	80003d16 <fileread+0x64>
      return -1;
    80003d74:	597d                	li	s2,-1
    80003d76:	64e2                	ld	s1,24(sp)
    80003d78:	69a2                	ld	s3,8(sp)
    80003d7a:	bf71                	j	80003d16 <fileread+0x64>
    80003d7c:	597d                	li	s2,-1
    80003d7e:	64e2                	ld	s1,24(sp)
    80003d80:	69a2                	ld	s3,8(sp)
    80003d82:	bf51                	j	80003d16 <fileread+0x64>

0000000080003d84 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003d84:	00954783          	lbu	a5,9(a0)
    80003d88:	12078963          	beqz	a5,80003eba <filewrite+0x136>
{
    80003d8c:	715d                	addi	sp,sp,-80
    80003d8e:	e486                	sd	ra,72(sp)
    80003d90:	e0a2                	sd	s0,64(sp)
    80003d92:	f84a                	sd	s2,48(sp)
    80003d94:	f052                	sd	s4,32(sp)
    80003d96:	e85a                	sd	s6,16(sp)
    80003d98:	0880                	addi	s0,sp,80
    80003d9a:	892a                	mv	s2,a0
    80003d9c:	8b2e                	mv	s6,a1
    80003d9e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003da0:	411c                	lw	a5,0(a0)
    80003da2:	4705                	li	a4,1
    80003da4:	02e78763          	beq	a5,a4,80003dd2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003da8:	470d                	li	a4,3
    80003daa:	02e78a63          	beq	a5,a4,80003dde <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dae:	4709                	li	a4,2
    80003db0:	0ee79863          	bne	a5,a4,80003ea0 <filewrite+0x11c>
    80003db4:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003db6:	0cc05463          	blez	a2,80003e7e <filewrite+0xfa>
    80003dba:	fc26                	sd	s1,56(sp)
    80003dbc:	ec56                	sd	s5,24(sp)
    80003dbe:	e45e                	sd	s7,8(sp)
    80003dc0:	e062                	sd	s8,0(sp)
    int i = 0;
    80003dc2:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003dc4:	6b85                	lui	s7,0x1
    80003dc6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003dca:	6c05                	lui	s8,0x1
    80003dcc:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003dd0:	a851                	j	80003e64 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003dd2:	6908                	ld	a0,16(a0)
    80003dd4:	00000097          	auipc	ra,0x0
    80003dd8:	248080e7          	jalr	584(ra) # 8000401c <pipewrite>
    80003ddc:	a85d                	j	80003e92 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003dde:	02451783          	lh	a5,36(a0)
    80003de2:	03079693          	slli	a3,a5,0x30
    80003de6:	92c1                	srli	a3,a3,0x30
    80003de8:	4725                	li	a4,9
    80003dea:	0cd76a63          	bltu	a4,a3,80003ebe <filewrite+0x13a>
    80003dee:	0792                	slli	a5,a5,0x4
    80003df0:	00017717          	auipc	a4,0x17
    80003df4:	2d870713          	addi	a4,a4,728 # 8001b0c8 <devsw>
    80003df8:	97ba                	add	a5,a5,a4
    80003dfa:	679c                	ld	a5,8(a5)
    80003dfc:	c3f9                	beqz	a5,80003ec2 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003dfe:	4505                	li	a0,1
    80003e00:	9782                	jalr	a5
    80003e02:	a841                	j	80003e92 <filewrite+0x10e>
      if(n1 > max)
    80003e04:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003e08:	00000097          	auipc	ra,0x0
    80003e0c:	88c080e7          	jalr	-1908(ra) # 80003694 <begin_op>
      ilock(f->ip);
    80003e10:	01893503          	ld	a0,24(s2)
    80003e14:	fffff097          	auipc	ra,0xfffff
    80003e18:	eae080e7          	jalr	-338(ra) # 80002cc2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e1c:	8756                	mv	a4,s5
    80003e1e:	02092683          	lw	a3,32(s2)
    80003e22:	01698633          	add	a2,s3,s6
    80003e26:	4585                	li	a1,1
    80003e28:	01893503          	ld	a0,24(s2)
    80003e2c:	fffff097          	auipc	ra,0xfffff
    80003e30:	252080e7          	jalr	594(ra) # 8000307e <writei>
    80003e34:	84aa                	mv	s1,a0
    80003e36:	00a05763          	blez	a0,80003e44 <filewrite+0xc0>
        f->off += r;
    80003e3a:	02092783          	lw	a5,32(s2)
    80003e3e:	9fa9                	addw	a5,a5,a0
    80003e40:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e44:	01893503          	ld	a0,24(s2)
    80003e48:	fffff097          	auipc	ra,0xfffff
    80003e4c:	f40080e7          	jalr	-192(ra) # 80002d88 <iunlock>
      end_op();
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	8be080e7          	jalr	-1858(ra) # 8000370e <end_op>

      if(r != n1){
    80003e58:	029a9563          	bne	s5,s1,80003e82 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003e5c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e60:	0149da63          	bge	s3,s4,80003e74 <filewrite+0xf0>
      int n1 = n - i;
    80003e64:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003e68:	0004879b          	sext.w	a5,s1
    80003e6c:	f8fbdce3          	bge	s7,a5,80003e04 <filewrite+0x80>
    80003e70:	84e2                	mv	s1,s8
    80003e72:	bf49                	j	80003e04 <filewrite+0x80>
    80003e74:	74e2                	ld	s1,56(sp)
    80003e76:	6ae2                	ld	s5,24(sp)
    80003e78:	6ba2                	ld	s7,8(sp)
    80003e7a:	6c02                	ld	s8,0(sp)
    80003e7c:	a039                	j	80003e8a <filewrite+0x106>
    int i = 0;
    80003e7e:	4981                	li	s3,0
    80003e80:	a029                	j	80003e8a <filewrite+0x106>
    80003e82:	74e2                	ld	s1,56(sp)
    80003e84:	6ae2                	ld	s5,24(sp)
    80003e86:	6ba2                	ld	s7,8(sp)
    80003e88:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003e8a:	033a1e63          	bne	s4,s3,80003ec6 <filewrite+0x142>
    80003e8e:	8552                	mv	a0,s4
    80003e90:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e92:	60a6                	ld	ra,72(sp)
    80003e94:	6406                	ld	s0,64(sp)
    80003e96:	7942                	ld	s2,48(sp)
    80003e98:	7a02                	ld	s4,32(sp)
    80003e9a:	6b42                	ld	s6,16(sp)
    80003e9c:	6161                	addi	sp,sp,80
    80003e9e:	8082                	ret
    80003ea0:	fc26                	sd	s1,56(sp)
    80003ea2:	f44e                	sd	s3,40(sp)
    80003ea4:	ec56                	sd	s5,24(sp)
    80003ea6:	e45e                	sd	s7,8(sp)
    80003ea8:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003eaa:	00004517          	auipc	a0,0x4
    80003eae:	65650513          	addi	a0,a0,1622 # 80008500 <etext+0x500>
    80003eb2:	00002097          	auipc	ra,0x2
    80003eb6:	2c8080e7          	jalr	712(ra) # 8000617a <panic>
    return -1;
    80003eba:	557d                	li	a0,-1
}
    80003ebc:	8082                	ret
      return -1;
    80003ebe:	557d                	li	a0,-1
    80003ec0:	bfc9                	j	80003e92 <filewrite+0x10e>
    80003ec2:	557d                	li	a0,-1
    80003ec4:	b7f9                	j	80003e92 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003ec6:	557d                	li	a0,-1
    80003ec8:	79a2                	ld	s3,40(sp)
    80003eca:	b7e1                	j	80003e92 <filewrite+0x10e>

0000000080003ecc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ecc:	7179                	addi	sp,sp,-48
    80003ece:	f406                	sd	ra,40(sp)
    80003ed0:	f022                	sd	s0,32(sp)
    80003ed2:	ec26                	sd	s1,24(sp)
    80003ed4:	e052                	sd	s4,0(sp)
    80003ed6:	1800                	addi	s0,sp,48
    80003ed8:	84aa                	mv	s1,a0
    80003eda:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003edc:	0005b023          	sd	zero,0(a1)
    80003ee0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ee4:	00000097          	auipc	ra,0x0
    80003ee8:	bbe080e7          	jalr	-1090(ra) # 80003aa2 <filealloc>
    80003eec:	e088                	sd	a0,0(s1)
    80003eee:	cd49                	beqz	a0,80003f88 <pipealloc+0xbc>
    80003ef0:	00000097          	auipc	ra,0x0
    80003ef4:	bb2080e7          	jalr	-1102(ra) # 80003aa2 <filealloc>
    80003ef8:	00aa3023          	sd	a0,0(s4)
    80003efc:	c141                	beqz	a0,80003f7c <pipealloc+0xb0>
    80003efe:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f00:	ffffc097          	auipc	ra,0xffffc
    80003f04:	21a080e7          	jalr	538(ra) # 8000011a <kalloc>
    80003f08:	892a                	mv	s2,a0
    80003f0a:	c13d                	beqz	a0,80003f70 <pipealloc+0xa4>
    80003f0c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003f0e:	4985                	li	s3,1
    80003f10:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f14:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f18:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f1c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f20:	00004597          	auipc	a1,0x4
    80003f24:	5f058593          	addi	a1,a1,1520 # 80008510 <etext+0x510>
    80003f28:	00002097          	auipc	ra,0x2
    80003f2c:	73c080e7          	jalr	1852(ra) # 80006664 <initlock>
  (*f0)->type = FD_PIPE;
    80003f30:	609c                	ld	a5,0(s1)
    80003f32:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f36:	609c                	ld	a5,0(s1)
    80003f38:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f3c:	609c                	ld	a5,0(s1)
    80003f3e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f42:	609c                	ld	a5,0(s1)
    80003f44:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f48:	000a3783          	ld	a5,0(s4)
    80003f4c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f50:	000a3783          	ld	a5,0(s4)
    80003f54:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f58:	000a3783          	ld	a5,0(s4)
    80003f5c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f60:	000a3783          	ld	a5,0(s4)
    80003f64:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f68:	4501                	li	a0,0
    80003f6a:	6942                	ld	s2,16(sp)
    80003f6c:	69a2                	ld	s3,8(sp)
    80003f6e:	a03d                	j	80003f9c <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f70:	6088                	ld	a0,0(s1)
    80003f72:	c119                	beqz	a0,80003f78 <pipealloc+0xac>
    80003f74:	6942                	ld	s2,16(sp)
    80003f76:	a029                	j	80003f80 <pipealloc+0xb4>
    80003f78:	6942                	ld	s2,16(sp)
    80003f7a:	a039                	j	80003f88 <pipealloc+0xbc>
    80003f7c:	6088                	ld	a0,0(s1)
    80003f7e:	c50d                	beqz	a0,80003fa8 <pipealloc+0xdc>
    fileclose(*f0);
    80003f80:	00000097          	auipc	ra,0x0
    80003f84:	bde080e7          	jalr	-1058(ra) # 80003b5e <fileclose>
  if(*f1)
    80003f88:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f8c:	557d                	li	a0,-1
  if(*f1)
    80003f8e:	c799                	beqz	a5,80003f9c <pipealloc+0xd0>
    fileclose(*f1);
    80003f90:	853e                	mv	a0,a5
    80003f92:	00000097          	auipc	ra,0x0
    80003f96:	bcc080e7          	jalr	-1076(ra) # 80003b5e <fileclose>
  return -1;
    80003f9a:	557d                	li	a0,-1
}
    80003f9c:	70a2                	ld	ra,40(sp)
    80003f9e:	7402                	ld	s0,32(sp)
    80003fa0:	64e2                	ld	s1,24(sp)
    80003fa2:	6a02                	ld	s4,0(sp)
    80003fa4:	6145                	addi	sp,sp,48
    80003fa6:	8082                	ret
  return -1;
    80003fa8:	557d                	li	a0,-1
    80003faa:	bfcd                	j	80003f9c <pipealloc+0xd0>

0000000080003fac <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fac:	1101                	addi	sp,sp,-32
    80003fae:	ec06                	sd	ra,24(sp)
    80003fb0:	e822                	sd	s0,16(sp)
    80003fb2:	e426                	sd	s1,8(sp)
    80003fb4:	e04a                	sd	s2,0(sp)
    80003fb6:	1000                	addi	s0,sp,32
    80003fb8:	84aa                	mv	s1,a0
    80003fba:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fbc:	00002097          	auipc	ra,0x2
    80003fc0:	738080e7          	jalr	1848(ra) # 800066f4 <acquire>
  if(writable){
    80003fc4:	02090d63          	beqz	s2,80003ffe <pipeclose+0x52>
    pi->writeopen = 0;
    80003fc8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fcc:	21848513          	addi	a0,s1,536
    80003fd0:	ffffd097          	auipc	ra,0xffffd
    80003fd4:	726080e7          	jalr	1830(ra) # 800016f6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fd8:	2204b783          	ld	a5,544(s1)
    80003fdc:	eb95                	bnez	a5,80004010 <pipeclose+0x64>
    release(&pi->lock);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	00002097          	auipc	ra,0x2
    80003fe4:	7c8080e7          	jalr	1992(ra) # 800067a8 <release>
    kfree((char*)pi);
    80003fe8:	8526                	mv	a0,s1
    80003fea:	ffffc097          	auipc	ra,0xffffc
    80003fee:	032080e7          	jalr	50(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ff2:	60e2                	ld	ra,24(sp)
    80003ff4:	6442                	ld	s0,16(sp)
    80003ff6:	64a2                	ld	s1,8(sp)
    80003ff8:	6902                	ld	s2,0(sp)
    80003ffa:	6105                	addi	sp,sp,32
    80003ffc:	8082                	ret
    pi->readopen = 0;
    80003ffe:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004002:	21c48513          	addi	a0,s1,540
    80004006:	ffffd097          	auipc	ra,0xffffd
    8000400a:	6f0080e7          	jalr	1776(ra) # 800016f6 <wakeup>
    8000400e:	b7e9                	j	80003fd8 <pipeclose+0x2c>
    release(&pi->lock);
    80004010:	8526                	mv	a0,s1
    80004012:	00002097          	auipc	ra,0x2
    80004016:	796080e7          	jalr	1942(ra) # 800067a8 <release>
}
    8000401a:	bfe1                	j	80003ff2 <pipeclose+0x46>

000000008000401c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000401c:	711d                	addi	sp,sp,-96
    8000401e:	ec86                	sd	ra,88(sp)
    80004020:	e8a2                	sd	s0,80(sp)
    80004022:	e4a6                	sd	s1,72(sp)
    80004024:	e0ca                	sd	s2,64(sp)
    80004026:	fc4e                	sd	s3,56(sp)
    80004028:	f852                	sd	s4,48(sp)
    8000402a:	f456                	sd	s5,40(sp)
    8000402c:	1080                	addi	s0,sp,96
    8000402e:	84aa                	mv	s1,a0
    80004030:	8aae                	mv	s5,a1
    80004032:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004034:	ffffd097          	auipc	ra,0xffffd
    80004038:	e36080e7          	jalr	-458(ra) # 80000e6a <myproc>
    8000403c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000403e:	8526                	mv	a0,s1
    80004040:	00002097          	auipc	ra,0x2
    80004044:	6b4080e7          	jalr	1716(ra) # 800066f4 <acquire>
  while(i < n){
    80004048:	0d405563          	blez	s4,80004112 <pipewrite+0xf6>
    8000404c:	f05a                	sd	s6,32(sp)
    8000404e:	ec5e                	sd	s7,24(sp)
    80004050:	e862                	sd	s8,16(sp)
  int i = 0;
    80004052:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004054:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004056:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000405a:	21c48b93          	addi	s7,s1,540
    8000405e:	a089                	j	800040a0 <pipewrite+0x84>
      release(&pi->lock);
    80004060:	8526                	mv	a0,s1
    80004062:	00002097          	auipc	ra,0x2
    80004066:	746080e7          	jalr	1862(ra) # 800067a8 <release>
      return -1;
    8000406a:	597d                	li	s2,-1
    8000406c:	7b02                	ld	s6,32(sp)
    8000406e:	6be2                	ld	s7,24(sp)
    80004070:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004072:	854a                	mv	a0,s2
    80004074:	60e6                	ld	ra,88(sp)
    80004076:	6446                	ld	s0,80(sp)
    80004078:	64a6                	ld	s1,72(sp)
    8000407a:	6906                	ld	s2,64(sp)
    8000407c:	79e2                	ld	s3,56(sp)
    8000407e:	7a42                	ld	s4,48(sp)
    80004080:	7aa2                	ld	s5,40(sp)
    80004082:	6125                	addi	sp,sp,96
    80004084:	8082                	ret
      wakeup(&pi->nread);
    80004086:	8562                	mv	a0,s8
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	66e080e7          	jalr	1646(ra) # 800016f6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004090:	85a6                	mv	a1,s1
    80004092:	855e                	mv	a0,s7
    80004094:	ffffd097          	auipc	ra,0xffffd
    80004098:	4d6080e7          	jalr	1238(ra) # 8000156a <sleep>
  while(i < n){
    8000409c:	05495c63          	bge	s2,s4,800040f4 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    800040a0:	2204a783          	lw	a5,544(s1)
    800040a4:	dfd5                	beqz	a5,80004060 <pipewrite+0x44>
    800040a6:	0289a783          	lw	a5,40(s3)
    800040aa:	fbdd                	bnez	a5,80004060 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040ac:	2184a783          	lw	a5,536(s1)
    800040b0:	21c4a703          	lw	a4,540(s1)
    800040b4:	2007879b          	addiw	a5,a5,512
    800040b8:	fcf707e3          	beq	a4,a5,80004086 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040bc:	4685                	li	a3,1
    800040be:	01590633          	add	a2,s2,s5
    800040c2:	faf40593          	addi	a1,s0,-81
    800040c6:	0509b503          	ld	a0,80(s3)
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	ac8080e7          	jalr	-1336(ra) # 80000b92 <copyin>
    800040d2:	05650263          	beq	a0,s6,80004116 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040d6:	21c4a783          	lw	a5,540(s1)
    800040da:	0017871b          	addiw	a4,a5,1
    800040de:	20e4ae23          	sw	a4,540(s1)
    800040e2:	1ff7f793          	andi	a5,a5,511
    800040e6:	97a6                	add	a5,a5,s1
    800040e8:	faf44703          	lbu	a4,-81(s0)
    800040ec:	00e78c23          	sb	a4,24(a5)
      i++;
    800040f0:	2905                	addiw	s2,s2,1
    800040f2:	b76d                	j	8000409c <pipewrite+0x80>
    800040f4:	7b02                	ld	s6,32(sp)
    800040f6:	6be2                	ld	s7,24(sp)
    800040f8:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800040fa:	21848513          	addi	a0,s1,536
    800040fe:	ffffd097          	auipc	ra,0xffffd
    80004102:	5f8080e7          	jalr	1528(ra) # 800016f6 <wakeup>
  release(&pi->lock);
    80004106:	8526                	mv	a0,s1
    80004108:	00002097          	auipc	ra,0x2
    8000410c:	6a0080e7          	jalr	1696(ra) # 800067a8 <release>
  return i;
    80004110:	b78d                	j	80004072 <pipewrite+0x56>
  int i = 0;
    80004112:	4901                	li	s2,0
    80004114:	b7dd                	j	800040fa <pipewrite+0xde>
    80004116:	7b02                	ld	s6,32(sp)
    80004118:	6be2                	ld	s7,24(sp)
    8000411a:	6c42                	ld	s8,16(sp)
    8000411c:	bff9                	j	800040fa <pipewrite+0xde>

000000008000411e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000411e:	715d                	addi	sp,sp,-80
    80004120:	e486                	sd	ra,72(sp)
    80004122:	e0a2                	sd	s0,64(sp)
    80004124:	fc26                	sd	s1,56(sp)
    80004126:	f84a                	sd	s2,48(sp)
    80004128:	f44e                	sd	s3,40(sp)
    8000412a:	f052                	sd	s4,32(sp)
    8000412c:	ec56                	sd	s5,24(sp)
    8000412e:	0880                	addi	s0,sp,80
    80004130:	84aa                	mv	s1,a0
    80004132:	892e                	mv	s2,a1
    80004134:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	d34080e7          	jalr	-716(ra) # 80000e6a <myproc>
    8000413e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004140:	8526                	mv	a0,s1
    80004142:	00002097          	auipc	ra,0x2
    80004146:	5b2080e7          	jalr	1458(ra) # 800066f4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000414a:	2184a703          	lw	a4,536(s1)
    8000414e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004152:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004156:	02f71663          	bne	a4,a5,80004182 <piperead+0x64>
    8000415a:	2244a783          	lw	a5,548(s1)
    8000415e:	cb9d                	beqz	a5,80004194 <piperead+0x76>
    if(pr->killed){
    80004160:	028a2783          	lw	a5,40(s4)
    80004164:	e38d                	bnez	a5,80004186 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004166:	85a6                	mv	a1,s1
    80004168:	854e                	mv	a0,s3
    8000416a:	ffffd097          	auipc	ra,0xffffd
    8000416e:	400080e7          	jalr	1024(ra) # 8000156a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004172:	2184a703          	lw	a4,536(s1)
    80004176:	21c4a783          	lw	a5,540(s1)
    8000417a:	fef700e3          	beq	a4,a5,8000415a <piperead+0x3c>
    8000417e:	e85a                	sd	s6,16(sp)
    80004180:	a819                	j	80004196 <piperead+0x78>
    80004182:	e85a                	sd	s6,16(sp)
    80004184:	a809                	j	80004196 <piperead+0x78>
      release(&pi->lock);
    80004186:	8526                	mv	a0,s1
    80004188:	00002097          	auipc	ra,0x2
    8000418c:	620080e7          	jalr	1568(ra) # 800067a8 <release>
      return -1;
    80004190:	59fd                	li	s3,-1
    80004192:	a0a5                	j	800041fa <piperead+0xdc>
    80004194:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004196:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004198:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419a:	05505463          	blez	s5,800041e2 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    8000419e:	2184a783          	lw	a5,536(s1)
    800041a2:	21c4a703          	lw	a4,540(s1)
    800041a6:	02f70e63          	beq	a4,a5,800041e2 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041aa:	0017871b          	addiw	a4,a5,1
    800041ae:	20e4ac23          	sw	a4,536(s1)
    800041b2:	1ff7f793          	andi	a5,a5,511
    800041b6:	97a6                	add	a5,a5,s1
    800041b8:	0187c783          	lbu	a5,24(a5)
    800041bc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041c0:	4685                	li	a3,1
    800041c2:	fbf40613          	addi	a2,s0,-65
    800041c6:	85ca                	mv	a1,s2
    800041c8:	050a3503          	ld	a0,80(s4)
    800041cc:	ffffd097          	auipc	ra,0xffffd
    800041d0:	93a080e7          	jalr	-1734(ra) # 80000b06 <copyout>
    800041d4:	01650763          	beq	a0,s6,800041e2 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041d8:	2985                	addiw	s3,s3,1
    800041da:	0905                	addi	s2,s2,1
    800041dc:	fd3a91e3          	bne	s5,s3,8000419e <piperead+0x80>
    800041e0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041e2:	21c48513          	addi	a0,s1,540
    800041e6:	ffffd097          	auipc	ra,0xffffd
    800041ea:	510080e7          	jalr	1296(ra) # 800016f6 <wakeup>
  release(&pi->lock);
    800041ee:	8526                	mv	a0,s1
    800041f0:	00002097          	auipc	ra,0x2
    800041f4:	5b8080e7          	jalr	1464(ra) # 800067a8 <release>
    800041f8:	6b42                	ld	s6,16(sp)
  return i;
}
    800041fa:	854e                	mv	a0,s3
    800041fc:	60a6                	ld	ra,72(sp)
    800041fe:	6406                	ld	s0,64(sp)
    80004200:	74e2                	ld	s1,56(sp)
    80004202:	7942                	ld	s2,48(sp)
    80004204:	79a2                	ld	s3,40(sp)
    80004206:	7a02                	ld	s4,32(sp)
    80004208:	6ae2                	ld	s5,24(sp)
    8000420a:	6161                	addi	sp,sp,80
    8000420c:	8082                	ret

000000008000420e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000420e:	df010113          	addi	sp,sp,-528
    80004212:	20113423          	sd	ra,520(sp)
    80004216:	20813023          	sd	s0,512(sp)
    8000421a:	ffa6                	sd	s1,504(sp)
    8000421c:	fbca                	sd	s2,496(sp)
    8000421e:	0c00                	addi	s0,sp,528
    80004220:	892a                	mv	s2,a0
    80004222:	dea43c23          	sd	a0,-520(s0)
    80004226:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000422a:	ffffd097          	auipc	ra,0xffffd
    8000422e:	c40080e7          	jalr	-960(ra) # 80000e6a <myproc>
    80004232:	84aa                	mv	s1,a0

  begin_op();
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	460080e7          	jalr	1120(ra) # 80003694 <begin_op>

  if((ip = namei(path)) == 0){
    8000423c:	854a                	mv	a0,s2
    8000423e:	fffff097          	auipc	ra,0xfffff
    80004242:	256080e7          	jalr	598(ra) # 80003494 <namei>
    80004246:	c135                	beqz	a0,800042aa <exec+0x9c>
    80004248:	f3d2                	sd	s4,480(sp)
    8000424a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000424c:	fffff097          	auipc	ra,0xfffff
    80004250:	a76080e7          	jalr	-1418(ra) # 80002cc2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004254:	04000713          	li	a4,64
    80004258:	4681                	li	a3,0
    8000425a:	e5040613          	addi	a2,s0,-432
    8000425e:	4581                	li	a1,0
    80004260:	8552                	mv	a0,s4
    80004262:	fffff097          	auipc	ra,0xfffff
    80004266:	d18080e7          	jalr	-744(ra) # 80002f7a <readi>
    8000426a:	04000793          	li	a5,64
    8000426e:	00f51a63          	bne	a0,a5,80004282 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004272:	e5042703          	lw	a4,-432(s0)
    80004276:	464c47b7          	lui	a5,0x464c4
    8000427a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000427e:	02f70c63          	beq	a4,a5,800042b6 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004282:	8552                	mv	a0,s4
    80004284:	fffff097          	auipc	ra,0xfffff
    80004288:	ca4080e7          	jalr	-860(ra) # 80002f28 <iunlockput>
    end_op();
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	482080e7          	jalr	1154(ra) # 8000370e <end_op>
  }
  return -1;
    80004294:	557d                	li	a0,-1
    80004296:	7a1e                	ld	s4,480(sp)
}
    80004298:	20813083          	ld	ra,520(sp)
    8000429c:	20013403          	ld	s0,512(sp)
    800042a0:	74fe                	ld	s1,504(sp)
    800042a2:	795e                	ld	s2,496(sp)
    800042a4:	21010113          	addi	sp,sp,528
    800042a8:	8082                	ret
    end_op();
    800042aa:	fffff097          	auipc	ra,0xfffff
    800042ae:	464080e7          	jalr	1124(ra) # 8000370e <end_op>
    return -1;
    800042b2:	557d                	li	a0,-1
    800042b4:	b7d5                	j	80004298 <exec+0x8a>
    800042b6:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800042b8:	8526                	mv	a0,s1
    800042ba:	ffffd097          	auipc	ra,0xffffd
    800042be:	c74080e7          	jalr	-908(ra) # 80000f2e <proc_pagetable>
    800042c2:	8b2a                	mv	s6,a0
    800042c4:	30050563          	beqz	a0,800045ce <exec+0x3c0>
    800042c8:	f7ce                	sd	s3,488(sp)
    800042ca:	efd6                	sd	s5,472(sp)
    800042cc:	e7de                	sd	s7,456(sp)
    800042ce:	e3e2                	sd	s8,448(sp)
    800042d0:	ff66                	sd	s9,440(sp)
    800042d2:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042d4:	e7042d03          	lw	s10,-400(s0)
    800042d8:	e8845783          	lhu	a5,-376(s0)
    800042dc:	14078563          	beqz	a5,80004426 <exec+0x218>
    800042e0:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042e2:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042e4:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    800042e6:	6c85                	lui	s9,0x1
    800042e8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042ec:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800042f0:	6a85                	lui	s5,0x1
    800042f2:	a0b5                	j	8000435e <exec+0x150>
      panic("loadseg: address should exist");
    800042f4:	00004517          	auipc	a0,0x4
    800042f8:	22450513          	addi	a0,a0,548 # 80008518 <etext+0x518>
    800042fc:	00002097          	auipc	ra,0x2
    80004300:	e7e080e7          	jalr	-386(ra) # 8000617a <panic>
    if(sz - i < PGSIZE)
    80004304:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004306:	8726                	mv	a4,s1
    80004308:	012c06bb          	addw	a3,s8,s2
    8000430c:	4581                	li	a1,0
    8000430e:	8552                	mv	a0,s4
    80004310:	fffff097          	auipc	ra,0xfffff
    80004314:	c6a080e7          	jalr	-918(ra) # 80002f7a <readi>
    80004318:	2501                	sext.w	a0,a0
    8000431a:	26a49e63          	bne	s1,a0,80004596 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000431e:	012a893b          	addw	s2,s5,s2
    80004322:	03397563          	bgeu	s2,s3,8000434c <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004326:	02091593          	slli	a1,s2,0x20
    8000432a:	9181                	srli	a1,a1,0x20
    8000432c:	95de                	add	a1,a1,s7
    8000432e:	855a                	mv	a0,s6
    80004330:	ffffc097          	auipc	ra,0xffffc
    80004334:	1d0080e7          	jalr	464(ra) # 80000500 <walkaddr>
    80004338:	862a                	mv	a2,a0
    if(pa == 0)
    8000433a:	dd4d                	beqz	a0,800042f4 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000433c:	412984bb          	subw	s1,s3,s2
    80004340:	0004879b          	sext.w	a5,s1
    80004344:	fcfcf0e3          	bgeu	s9,a5,80004304 <exec+0xf6>
    80004348:	84d6                	mv	s1,s5
    8000434a:	bf6d                	j	80004304 <exec+0xf6>
    sz = sz1;
    8000434c:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004350:	2d85                	addiw	s11,s11,1
    80004352:	038d0d1b          	addiw	s10,s10,56
    80004356:	e8845783          	lhu	a5,-376(s0)
    8000435a:	06fddf63          	bge	s11,a5,800043d8 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000435e:	2d01                	sext.w	s10,s10
    80004360:	03800713          	li	a4,56
    80004364:	86ea                	mv	a3,s10
    80004366:	e1840613          	addi	a2,s0,-488
    8000436a:	4581                	li	a1,0
    8000436c:	8552                	mv	a0,s4
    8000436e:	fffff097          	auipc	ra,0xfffff
    80004372:	c0c080e7          	jalr	-1012(ra) # 80002f7a <readi>
    80004376:	03800793          	li	a5,56
    8000437a:	1ef51863          	bne	a0,a5,8000456a <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    8000437e:	e1842783          	lw	a5,-488(s0)
    80004382:	4705                	li	a4,1
    80004384:	fce796e3          	bne	a5,a4,80004350 <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004388:	e4043603          	ld	a2,-448(s0)
    8000438c:	e3843783          	ld	a5,-456(s0)
    80004390:	1ef66163          	bltu	a2,a5,80004572 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004394:	e2843783          	ld	a5,-472(s0)
    80004398:	963e                	add	a2,a2,a5
    8000439a:	1ef66063          	bltu	a2,a5,8000457a <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000439e:	85a6                	mv	a1,s1
    800043a0:	855a                	mv	a0,s6
    800043a2:	ffffc097          	auipc	ra,0xffffc
    800043a6:	514080e7          	jalr	1300(ra) # 800008b6 <uvmalloc>
    800043aa:	e0a43423          	sd	a0,-504(s0)
    800043ae:	1c050a63          	beqz	a0,80004582 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    800043b2:	e2843b83          	ld	s7,-472(s0)
    800043b6:	df043783          	ld	a5,-528(s0)
    800043ba:	00fbf7b3          	and	a5,s7,a5
    800043be:	1c079a63          	bnez	a5,80004592 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043c2:	e2042c03          	lw	s8,-480(s0)
    800043c6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043ca:	00098463          	beqz	s3,800043d2 <exec+0x1c4>
    800043ce:	4901                	li	s2,0
    800043d0:	bf99                	j	80004326 <exec+0x118>
    sz = sz1;
    800043d2:	e0843483          	ld	s1,-504(s0)
    800043d6:	bfad                	j	80004350 <exec+0x142>
    800043d8:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800043da:	8552                	mv	a0,s4
    800043dc:	fffff097          	auipc	ra,0xfffff
    800043e0:	b4c080e7          	jalr	-1204(ra) # 80002f28 <iunlockput>
  end_op();
    800043e4:	fffff097          	auipc	ra,0xfffff
    800043e8:	32a080e7          	jalr	810(ra) # 8000370e <end_op>
  p = myproc();
    800043ec:	ffffd097          	auipc	ra,0xffffd
    800043f0:	a7e080e7          	jalr	-1410(ra) # 80000e6a <myproc>
    800043f4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043f6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800043fa:	6985                	lui	s3,0x1
    800043fc:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800043fe:	99a6                	add	s3,s3,s1
    80004400:	77fd                	lui	a5,0xfffff
    80004402:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004406:	6609                	lui	a2,0x2
    80004408:	964e                	add	a2,a2,s3
    8000440a:	85ce                	mv	a1,s3
    8000440c:	855a                	mv	a0,s6
    8000440e:	ffffc097          	auipc	ra,0xffffc
    80004412:	4a8080e7          	jalr	1192(ra) # 800008b6 <uvmalloc>
    80004416:	892a                	mv	s2,a0
    80004418:	e0a43423          	sd	a0,-504(s0)
    8000441c:	e519                	bnez	a0,8000442a <exec+0x21c>
  if(pagetable)
    8000441e:	e1343423          	sd	s3,-504(s0)
    80004422:	4a01                	li	s4,0
    80004424:	aa95                	j	80004598 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004426:	4481                	li	s1,0
    80004428:	bf4d                	j	800043da <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000442a:	75f9                	lui	a1,0xffffe
    8000442c:	95aa                	add	a1,a1,a0
    8000442e:	855a                	mv	a0,s6
    80004430:	ffffc097          	auipc	ra,0xffffc
    80004434:	6a4080e7          	jalr	1700(ra) # 80000ad4 <uvmclear>
  stackbase = sp - PGSIZE;
    80004438:	7bfd                	lui	s7,0xfffff
    8000443a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000443c:	e0043783          	ld	a5,-512(s0)
    80004440:	6388                	ld	a0,0(a5)
    80004442:	c52d                	beqz	a0,800044ac <exec+0x29e>
    80004444:	e9040993          	addi	s3,s0,-368
    80004448:	f9040c13          	addi	s8,s0,-112
    8000444c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000444e:	ffffc097          	auipc	ra,0xffffc
    80004452:	ea0080e7          	jalr	-352(ra) # 800002ee <strlen>
    80004456:	0015079b          	addiw	a5,a0,1
    8000445a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000445e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004462:	13796463          	bltu	s2,s7,8000458a <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004466:	e0043d03          	ld	s10,-512(s0)
    8000446a:	000d3a03          	ld	s4,0(s10)
    8000446e:	8552                	mv	a0,s4
    80004470:	ffffc097          	auipc	ra,0xffffc
    80004474:	e7e080e7          	jalr	-386(ra) # 800002ee <strlen>
    80004478:	0015069b          	addiw	a3,a0,1
    8000447c:	8652                	mv	a2,s4
    8000447e:	85ca                	mv	a1,s2
    80004480:	855a                	mv	a0,s6
    80004482:	ffffc097          	auipc	ra,0xffffc
    80004486:	684080e7          	jalr	1668(ra) # 80000b06 <copyout>
    8000448a:	10054263          	bltz	a0,8000458e <exec+0x380>
    ustack[argc] = sp;
    8000448e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004492:	0485                	addi	s1,s1,1
    80004494:	008d0793          	addi	a5,s10,8
    80004498:	e0f43023          	sd	a5,-512(s0)
    8000449c:	008d3503          	ld	a0,8(s10)
    800044a0:	c909                	beqz	a0,800044b2 <exec+0x2a4>
    if(argc >= MAXARG)
    800044a2:	09a1                	addi	s3,s3,8
    800044a4:	fb8995e3          	bne	s3,s8,8000444e <exec+0x240>
  ip = 0;
    800044a8:	4a01                	li	s4,0
    800044aa:	a0fd                	j	80004598 <exec+0x38a>
  sp = sz;
    800044ac:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800044b0:	4481                	li	s1,0
  ustack[argc] = 0;
    800044b2:	00349793          	slli	a5,s1,0x3
    800044b6:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd6b30>
    800044ba:	97a2                	add	a5,a5,s0
    800044bc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800044c0:	00148693          	addi	a3,s1,1
    800044c4:	068e                	slli	a3,a3,0x3
    800044c6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044ca:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800044ce:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800044d2:	f57966e3          	bltu	s2,s7,8000441e <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044d6:	e9040613          	addi	a2,s0,-368
    800044da:	85ca                	mv	a1,s2
    800044dc:	855a                	mv	a0,s6
    800044de:	ffffc097          	auipc	ra,0xffffc
    800044e2:	628080e7          	jalr	1576(ra) # 80000b06 <copyout>
    800044e6:	0e054663          	bltz	a0,800045d2 <exec+0x3c4>
  p->trapframe->a1 = sp;
    800044ea:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800044ee:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044f2:	df843783          	ld	a5,-520(s0)
    800044f6:	0007c703          	lbu	a4,0(a5)
    800044fa:	cf11                	beqz	a4,80004516 <exec+0x308>
    800044fc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044fe:	02f00693          	li	a3,47
    80004502:	a039                	j	80004510 <exec+0x302>
      last = s+1;
    80004504:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004508:	0785                	addi	a5,a5,1
    8000450a:	fff7c703          	lbu	a4,-1(a5)
    8000450e:	c701                	beqz	a4,80004516 <exec+0x308>
    if(*s == '/')
    80004510:	fed71ce3          	bne	a4,a3,80004508 <exec+0x2fa>
    80004514:	bfc5                	j	80004504 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004516:	4641                	li	a2,16
    80004518:	df843583          	ld	a1,-520(s0)
    8000451c:	158a8513          	addi	a0,s5,344
    80004520:	ffffc097          	auipc	ra,0xffffc
    80004524:	d9c080e7          	jalr	-612(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    80004528:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000452c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004530:	e0843783          	ld	a5,-504(s0)
    80004534:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004538:	058ab783          	ld	a5,88(s5)
    8000453c:	e6843703          	ld	a4,-408(s0)
    80004540:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004542:	058ab783          	ld	a5,88(s5)
    80004546:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000454a:	85e6                	mv	a1,s9
    8000454c:	ffffd097          	auipc	ra,0xffffd
    80004550:	a7e080e7          	jalr	-1410(ra) # 80000fca <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004554:	0004851b          	sext.w	a0,s1
    80004558:	79be                	ld	s3,488(sp)
    8000455a:	7a1e                	ld	s4,480(sp)
    8000455c:	6afe                	ld	s5,472(sp)
    8000455e:	6b5e                	ld	s6,464(sp)
    80004560:	6bbe                	ld	s7,456(sp)
    80004562:	6c1e                	ld	s8,448(sp)
    80004564:	7cfa                	ld	s9,440(sp)
    80004566:	7d5a                	ld	s10,432(sp)
    80004568:	bb05                	j	80004298 <exec+0x8a>
    8000456a:	e0943423          	sd	s1,-504(s0)
    8000456e:	7dba                	ld	s11,424(sp)
    80004570:	a025                	j	80004598 <exec+0x38a>
    80004572:	e0943423          	sd	s1,-504(s0)
    80004576:	7dba                	ld	s11,424(sp)
    80004578:	a005                	j	80004598 <exec+0x38a>
    8000457a:	e0943423          	sd	s1,-504(s0)
    8000457e:	7dba                	ld	s11,424(sp)
    80004580:	a821                	j	80004598 <exec+0x38a>
    80004582:	e0943423          	sd	s1,-504(s0)
    80004586:	7dba                	ld	s11,424(sp)
    80004588:	a801                	j	80004598 <exec+0x38a>
  ip = 0;
    8000458a:	4a01                	li	s4,0
    8000458c:	a031                	j	80004598 <exec+0x38a>
    8000458e:	4a01                	li	s4,0
  if(pagetable)
    80004590:	a021                	j	80004598 <exec+0x38a>
    80004592:	7dba                	ld	s11,424(sp)
    80004594:	a011                	j	80004598 <exec+0x38a>
    80004596:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004598:	e0843583          	ld	a1,-504(s0)
    8000459c:	855a                	mv	a0,s6
    8000459e:	ffffd097          	auipc	ra,0xffffd
    800045a2:	a2c080e7          	jalr	-1492(ra) # 80000fca <proc_freepagetable>
  return -1;
    800045a6:	557d                	li	a0,-1
  if(ip){
    800045a8:	000a1b63          	bnez	s4,800045be <exec+0x3b0>
    800045ac:	79be                	ld	s3,488(sp)
    800045ae:	7a1e                	ld	s4,480(sp)
    800045b0:	6afe                	ld	s5,472(sp)
    800045b2:	6b5e                	ld	s6,464(sp)
    800045b4:	6bbe                	ld	s7,456(sp)
    800045b6:	6c1e                	ld	s8,448(sp)
    800045b8:	7cfa                	ld	s9,440(sp)
    800045ba:	7d5a                	ld	s10,432(sp)
    800045bc:	b9f1                	j	80004298 <exec+0x8a>
    800045be:	79be                	ld	s3,488(sp)
    800045c0:	6afe                	ld	s5,472(sp)
    800045c2:	6b5e                	ld	s6,464(sp)
    800045c4:	6bbe                	ld	s7,456(sp)
    800045c6:	6c1e                	ld	s8,448(sp)
    800045c8:	7cfa                	ld	s9,440(sp)
    800045ca:	7d5a                	ld	s10,432(sp)
    800045cc:	b95d                	j	80004282 <exec+0x74>
    800045ce:	6b5e                	ld	s6,464(sp)
    800045d0:	b94d                	j	80004282 <exec+0x74>
  sz = sz1;
    800045d2:	e0843983          	ld	s3,-504(s0)
    800045d6:	b5a1                	j	8000441e <exec+0x210>

00000000800045d8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045d8:	7179                	addi	sp,sp,-48
    800045da:	f406                	sd	ra,40(sp)
    800045dc:	f022                	sd	s0,32(sp)
    800045de:	ec26                	sd	s1,24(sp)
    800045e0:	e84a                	sd	s2,16(sp)
    800045e2:	1800                	addi	s0,sp,48
    800045e4:	892e                	mv	s2,a1
    800045e6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045e8:	fdc40593          	addi	a1,s0,-36
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	b64080e7          	jalr	-1180(ra) # 80002150 <argint>
    800045f4:	04054063          	bltz	a0,80004634 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045f8:	fdc42703          	lw	a4,-36(s0)
    800045fc:	47bd                	li	a5,15
    800045fe:	02e7ed63          	bltu	a5,a4,80004638 <argfd+0x60>
    80004602:	ffffd097          	auipc	ra,0xffffd
    80004606:	868080e7          	jalr	-1944(ra) # 80000e6a <myproc>
    8000460a:	fdc42703          	lw	a4,-36(s0)
    8000460e:	01a70793          	addi	a5,a4,26
    80004612:	078e                	slli	a5,a5,0x3
    80004614:	953e                	add	a0,a0,a5
    80004616:	611c                	ld	a5,0(a0)
    80004618:	c395                	beqz	a5,8000463c <argfd+0x64>
    return -1;
  if(pfd)
    8000461a:	00090463          	beqz	s2,80004622 <argfd+0x4a>
    *pfd = fd;
    8000461e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004622:	4501                	li	a0,0
  if(pf)
    80004624:	c091                	beqz	s1,80004628 <argfd+0x50>
    *pf = f;
    80004626:	e09c                	sd	a5,0(s1)
}
    80004628:	70a2                	ld	ra,40(sp)
    8000462a:	7402                	ld	s0,32(sp)
    8000462c:	64e2                	ld	s1,24(sp)
    8000462e:	6942                	ld	s2,16(sp)
    80004630:	6145                	addi	sp,sp,48
    80004632:	8082                	ret
    return -1;
    80004634:	557d                	li	a0,-1
    80004636:	bfcd                	j	80004628 <argfd+0x50>
    return -1;
    80004638:	557d                	li	a0,-1
    8000463a:	b7fd                	j	80004628 <argfd+0x50>
    8000463c:	557d                	li	a0,-1
    8000463e:	b7ed                	j	80004628 <argfd+0x50>

0000000080004640 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004640:	1101                	addi	sp,sp,-32
    80004642:	ec06                	sd	ra,24(sp)
    80004644:	e822                	sd	s0,16(sp)
    80004646:	e426                	sd	s1,8(sp)
    80004648:	1000                	addi	s0,sp,32
    8000464a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000464c:	ffffd097          	auipc	ra,0xffffd
    80004650:	81e080e7          	jalr	-2018(ra) # 80000e6a <myproc>
    80004654:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004656:	0d050793          	addi	a5,a0,208
    8000465a:	4501                	li	a0,0
    8000465c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000465e:	6398                	ld	a4,0(a5)
    80004660:	cb19                	beqz	a4,80004676 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004662:	2505                	addiw	a0,a0,1
    80004664:	07a1                	addi	a5,a5,8
    80004666:	fed51ce3          	bne	a0,a3,8000465e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000466a:	557d                	li	a0,-1
}
    8000466c:	60e2                	ld	ra,24(sp)
    8000466e:	6442                	ld	s0,16(sp)
    80004670:	64a2                	ld	s1,8(sp)
    80004672:	6105                	addi	sp,sp,32
    80004674:	8082                	ret
      p->ofile[fd] = f;
    80004676:	01a50793          	addi	a5,a0,26
    8000467a:	078e                	slli	a5,a5,0x3
    8000467c:	963e                	add	a2,a2,a5
    8000467e:	e204                	sd	s1,0(a2)
      return fd;
    80004680:	b7f5                	j	8000466c <fdalloc+0x2c>

0000000080004682 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004682:	715d                	addi	sp,sp,-80
    80004684:	e486                	sd	ra,72(sp)
    80004686:	e0a2                	sd	s0,64(sp)
    80004688:	fc26                	sd	s1,56(sp)
    8000468a:	f84a                	sd	s2,48(sp)
    8000468c:	f44e                	sd	s3,40(sp)
    8000468e:	f052                	sd	s4,32(sp)
    80004690:	ec56                	sd	s5,24(sp)
    80004692:	0880                	addi	s0,sp,80
    80004694:	8aae                	mv	s5,a1
    80004696:	8a32                	mv	s4,a2
    80004698:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000469a:	fb040593          	addi	a1,s0,-80
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	e14080e7          	jalr	-492(ra) # 800034b2 <nameiparent>
    800046a6:	892a                	mv	s2,a0
    800046a8:	12050c63          	beqz	a0,800047e0 <create+0x15e>
    return 0;

  ilock(dp);
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	616080e7          	jalr	1558(ra) # 80002cc2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046b4:	4601                	li	a2,0
    800046b6:	fb040593          	addi	a1,s0,-80
    800046ba:	854a                	mv	a0,s2
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	b06080e7          	jalr	-1274(ra) # 800031c2 <dirlookup>
    800046c4:	84aa                	mv	s1,a0
    800046c6:	c539                	beqz	a0,80004714 <create+0x92>
    iunlockput(dp);
    800046c8:	854a                	mv	a0,s2
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	85e080e7          	jalr	-1954(ra) # 80002f28 <iunlockput>
    ilock(ip);
    800046d2:	8526                	mv	a0,s1
    800046d4:	ffffe097          	auipc	ra,0xffffe
    800046d8:	5ee080e7          	jalr	1518(ra) # 80002cc2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046dc:	4789                	li	a5,2
    800046de:	02fa9463          	bne	s5,a5,80004706 <create+0x84>
    800046e2:	0444d783          	lhu	a5,68(s1)
    800046e6:	37f9                	addiw	a5,a5,-2
    800046e8:	17c2                	slli	a5,a5,0x30
    800046ea:	93c1                	srli	a5,a5,0x30
    800046ec:	4705                	li	a4,1
    800046ee:	00f76c63          	bltu	a4,a5,80004706 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046f2:	8526                	mv	a0,s1
    800046f4:	60a6                	ld	ra,72(sp)
    800046f6:	6406                	ld	s0,64(sp)
    800046f8:	74e2                	ld	s1,56(sp)
    800046fa:	7942                	ld	s2,48(sp)
    800046fc:	79a2                	ld	s3,40(sp)
    800046fe:	7a02                	ld	s4,32(sp)
    80004700:	6ae2                	ld	s5,24(sp)
    80004702:	6161                	addi	sp,sp,80
    80004704:	8082                	ret
    iunlockput(ip);
    80004706:	8526                	mv	a0,s1
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	820080e7          	jalr	-2016(ra) # 80002f28 <iunlockput>
    return 0;
    80004710:	4481                	li	s1,0
    80004712:	b7c5                	j	800046f2 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004714:	85d6                	mv	a1,s5
    80004716:	00092503          	lw	a0,0(s2)
    8000471a:	ffffe097          	auipc	ra,0xffffe
    8000471e:	414080e7          	jalr	1044(ra) # 80002b2e <ialloc>
    80004722:	84aa                	mv	s1,a0
    80004724:	c139                	beqz	a0,8000476a <create+0xe8>
  ilock(ip);
    80004726:	ffffe097          	auipc	ra,0xffffe
    8000472a:	59c080e7          	jalr	1436(ra) # 80002cc2 <ilock>
  ip->major = major;
    8000472e:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004732:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004736:	4985                	li	s3,1
    80004738:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000473c:	8526                	mv	a0,s1
    8000473e:	ffffe097          	auipc	ra,0xffffe
    80004742:	4b8080e7          	jalr	1208(ra) # 80002bf6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004746:	033a8a63          	beq	s5,s3,8000477a <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000474a:	40d0                	lw	a2,4(s1)
    8000474c:	fb040593          	addi	a1,s0,-80
    80004750:	854a                	mv	a0,s2
    80004752:	fffff097          	auipc	ra,0xfffff
    80004756:	c80080e7          	jalr	-896(ra) # 800033d2 <dirlink>
    8000475a:	06054b63          	bltz	a0,800047d0 <create+0x14e>
  iunlockput(dp);
    8000475e:	854a                	mv	a0,s2
    80004760:	ffffe097          	auipc	ra,0xffffe
    80004764:	7c8080e7          	jalr	1992(ra) # 80002f28 <iunlockput>
  return ip;
    80004768:	b769                	j	800046f2 <create+0x70>
    panic("create: ialloc");
    8000476a:	00004517          	auipc	a0,0x4
    8000476e:	dce50513          	addi	a0,a0,-562 # 80008538 <etext+0x538>
    80004772:	00002097          	auipc	ra,0x2
    80004776:	a08080e7          	jalr	-1528(ra) # 8000617a <panic>
    dp->nlink++;  // for ".."
    8000477a:	04a95783          	lhu	a5,74(s2)
    8000477e:	2785                	addiw	a5,a5,1
    80004780:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004784:	854a                	mv	a0,s2
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	470080e7          	jalr	1136(ra) # 80002bf6 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000478e:	40d0                	lw	a2,4(s1)
    80004790:	00004597          	auipc	a1,0x4
    80004794:	db858593          	addi	a1,a1,-584 # 80008548 <etext+0x548>
    80004798:	8526                	mv	a0,s1
    8000479a:	fffff097          	auipc	ra,0xfffff
    8000479e:	c38080e7          	jalr	-968(ra) # 800033d2 <dirlink>
    800047a2:	00054f63          	bltz	a0,800047c0 <create+0x13e>
    800047a6:	00492603          	lw	a2,4(s2)
    800047aa:	00004597          	auipc	a1,0x4
    800047ae:	da658593          	addi	a1,a1,-602 # 80008550 <etext+0x550>
    800047b2:	8526                	mv	a0,s1
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	c1e080e7          	jalr	-994(ra) # 800033d2 <dirlink>
    800047bc:	f80557e3          	bgez	a0,8000474a <create+0xc8>
      panic("create dots");
    800047c0:	00004517          	auipc	a0,0x4
    800047c4:	d9850513          	addi	a0,a0,-616 # 80008558 <etext+0x558>
    800047c8:	00002097          	auipc	ra,0x2
    800047cc:	9b2080e7          	jalr	-1614(ra) # 8000617a <panic>
    panic("create: dirlink");
    800047d0:	00004517          	auipc	a0,0x4
    800047d4:	d9850513          	addi	a0,a0,-616 # 80008568 <etext+0x568>
    800047d8:	00002097          	auipc	ra,0x2
    800047dc:	9a2080e7          	jalr	-1630(ra) # 8000617a <panic>
    return 0;
    800047e0:	84aa                	mv	s1,a0
    800047e2:	bf01                	j	800046f2 <create+0x70>

00000000800047e4 <sys_dup>:
{
    800047e4:	7179                	addi	sp,sp,-48
    800047e6:	f406                	sd	ra,40(sp)
    800047e8:	f022                	sd	s0,32(sp)
    800047ea:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047ec:	fd840613          	addi	a2,s0,-40
    800047f0:	4581                	li	a1,0
    800047f2:	4501                	li	a0,0
    800047f4:	00000097          	auipc	ra,0x0
    800047f8:	de4080e7          	jalr	-540(ra) # 800045d8 <argfd>
    return -1;
    800047fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047fe:	02054763          	bltz	a0,8000482c <sys_dup+0x48>
    80004802:	ec26                	sd	s1,24(sp)
    80004804:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004806:	fd843903          	ld	s2,-40(s0)
    8000480a:	854a                	mv	a0,s2
    8000480c:	00000097          	auipc	ra,0x0
    80004810:	e34080e7          	jalr	-460(ra) # 80004640 <fdalloc>
    80004814:	84aa                	mv	s1,a0
    return -1;
    80004816:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004818:	00054f63          	bltz	a0,80004836 <sys_dup+0x52>
  filedup(f);
    8000481c:	854a                	mv	a0,s2
    8000481e:	fffff097          	auipc	ra,0xfffff
    80004822:	2ee080e7          	jalr	750(ra) # 80003b0c <filedup>
  return fd;
    80004826:	87a6                	mv	a5,s1
    80004828:	64e2                	ld	s1,24(sp)
    8000482a:	6942                	ld	s2,16(sp)
}
    8000482c:	853e                	mv	a0,a5
    8000482e:	70a2                	ld	ra,40(sp)
    80004830:	7402                	ld	s0,32(sp)
    80004832:	6145                	addi	sp,sp,48
    80004834:	8082                	ret
    80004836:	64e2                	ld	s1,24(sp)
    80004838:	6942                	ld	s2,16(sp)
    8000483a:	bfcd                	j	8000482c <sys_dup+0x48>

000000008000483c <sys_read>:
{
    8000483c:	7179                	addi	sp,sp,-48
    8000483e:	f406                	sd	ra,40(sp)
    80004840:	f022                	sd	s0,32(sp)
    80004842:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004844:	fe840613          	addi	a2,s0,-24
    80004848:	4581                	li	a1,0
    8000484a:	4501                	li	a0,0
    8000484c:	00000097          	auipc	ra,0x0
    80004850:	d8c080e7          	jalr	-628(ra) # 800045d8 <argfd>
    return -1;
    80004854:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004856:	04054163          	bltz	a0,80004898 <sys_read+0x5c>
    8000485a:	fe440593          	addi	a1,s0,-28
    8000485e:	4509                	li	a0,2
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	8f0080e7          	jalr	-1808(ra) # 80002150 <argint>
    return -1;
    80004868:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486a:	02054763          	bltz	a0,80004898 <sys_read+0x5c>
    8000486e:	fd840593          	addi	a1,s0,-40
    80004872:	4505                	li	a0,1
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	8fe080e7          	jalr	-1794(ra) # 80002172 <argaddr>
    return -1;
    8000487c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487e:	00054d63          	bltz	a0,80004898 <sys_read+0x5c>
  return fileread(f, p, n);
    80004882:	fe442603          	lw	a2,-28(s0)
    80004886:	fd843583          	ld	a1,-40(s0)
    8000488a:	fe843503          	ld	a0,-24(s0)
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	424080e7          	jalr	1060(ra) # 80003cb2 <fileread>
    80004896:	87aa                	mv	a5,a0
}
    80004898:	853e                	mv	a0,a5
    8000489a:	70a2                	ld	ra,40(sp)
    8000489c:	7402                	ld	s0,32(sp)
    8000489e:	6145                	addi	sp,sp,48
    800048a0:	8082                	ret

00000000800048a2 <sys_write>:
{
    800048a2:	7179                	addi	sp,sp,-48
    800048a4:	f406                	sd	ra,40(sp)
    800048a6:	f022                	sd	s0,32(sp)
    800048a8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048aa:	fe840613          	addi	a2,s0,-24
    800048ae:	4581                	li	a1,0
    800048b0:	4501                	li	a0,0
    800048b2:	00000097          	auipc	ra,0x0
    800048b6:	d26080e7          	jalr	-730(ra) # 800045d8 <argfd>
    return -1;
    800048ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048bc:	04054163          	bltz	a0,800048fe <sys_write+0x5c>
    800048c0:	fe440593          	addi	a1,s0,-28
    800048c4:	4509                	li	a0,2
    800048c6:	ffffe097          	auipc	ra,0xffffe
    800048ca:	88a080e7          	jalr	-1910(ra) # 80002150 <argint>
    return -1;
    800048ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d0:	02054763          	bltz	a0,800048fe <sys_write+0x5c>
    800048d4:	fd840593          	addi	a1,s0,-40
    800048d8:	4505                	li	a0,1
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	898080e7          	jalr	-1896(ra) # 80002172 <argaddr>
    return -1;
    800048e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048e4:	00054d63          	bltz	a0,800048fe <sys_write+0x5c>
  return filewrite(f, p, n);
    800048e8:	fe442603          	lw	a2,-28(s0)
    800048ec:	fd843583          	ld	a1,-40(s0)
    800048f0:	fe843503          	ld	a0,-24(s0)
    800048f4:	fffff097          	auipc	ra,0xfffff
    800048f8:	490080e7          	jalr	1168(ra) # 80003d84 <filewrite>
    800048fc:	87aa                	mv	a5,a0
}
    800048fe:	853e                	mv	a0,a5
    80004900:	70a2                	ld	ra,40(sp)
    80004902:	7402                	ld	s0,32(sp)
    80004904:	6145                	addi	sp,sp,48
    80004906:	8082                	ret

0000000080004908 <sys_close>:
{
    80004908:	1101                	addi	sp,sp,-32
    8000490a:	ec06                	sd	ra,24(sp)
    8000490c:	e822                	sd	s0,16(sp)
    8000490e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004910:	fe040613          	addi	a2,s0,-32
    80004914:	fec40593          	addi	a1,s0,-20
    80004918:	4501                	li	a0,0
    8000491a:	00000097          	auipc	ra,0x0
    8000491e:	cbe080e7          	jalr	-834(ra) # 800045d8 <argfd>
    return -1;
    80004922:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004924:	02054463          	bltz	a0,8000494c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004928:	ffffc097          	auipc	ra,0xffffc
    8000492c:	542080e7          	jalr	1346(ra) # 80000e6a <myproc>
    80004930:	fec42783          	lw	a5,-20(s0)
    80004934:	07e9                	addi	a5,a5,26
    80004936:	078e                	slli	a5,a5,0x3
    80004938:	953e                	add	a0,a0,a5
    8000493a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000493e:	fe043503          	ld	a0,-32(s0)
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	21c080e7          	jalr	540(ra) # 80003b5e <fileclose>
  return 0;
    8000494a:	4781                	li	a5,0
}
    8000494c:	853e                	mv	a0,a5
    8000494e:	60e2                	ld	ra,24(sp)
    80004950:	6442                	ld	s0,16(sp)
    80004952:	6105                	addi	sp,sp,32
    80004954:	8082                	ret

0000000080004956 <sys_fstat>:
{
    80004956:	1101                	addi	sp,sp,-32
    80004958:	ec06                	sd	ra,24(sp)
    8000495a:	e822                	sd	s0,16(sp)
    8000495c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000495e:	fe840613          	addi	a2,s0,-24
    80004962:	4581                	li	a1,0
    80004964:	4501                	li	a0,0
    80004966:	00000097          	auipc	ra,0x0
    8000496a:	c72080e7          	jalr	-910(ra) # 800045d8 <argfd>
    return -1;
    8000496e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004970:	02054563          	bltz	a0,8000499a <sys_fstat+0x44>
    80004974:	fe040593          	addi	a1,s0,-32
    80004978:	4505                	li	a0,1
    8000497a:	ffffd097          	auipc	ra,0xffffd
    8000497e:	7f8080e7          	jalr	2040(ra) # 80002172 <argaddr>
    return -1;
    80004982:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004984:	00054b63          	bltz	a0,8000499a <sys_fstat+0x44>
  return filestat(f, st);
    80004988:	fe043583          	ld	a1,-32(s0)
    8000498c:	fe843503          	ld	a0,-24(s0)
    80004990:	fffff097          	auipc	ra,0xfffff
    80004994:	2b0080e7          	jalr	688(ra) # 80003c40 <filestat>
    80004998:	87aa                	mv	a5,a0
}
    8000499a:	853e                	mv	a0,a5
    8000499c:	60e2                	ld	ra,24(sp)
    8000499e:	6442                	ld	s0,16(sp)
    800049a0:	6105                	addi	sp,sp,32
    800049a2:	8082                	ret

00000000800049a4 <sys_link>:
{
    800049a4:	7169                	addi	sp,sp,-304
    800049a6:	f606                	sd	ra,296(sp)
    800049a8:	f222                	sd	s0,288(sp)
    800049aa:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ac:	08000613          	li	a2,128
    800049b0:	ed040593          	addi	a1,s0,-304
    800049b4:	4501                	li	a0,0
    800049b6:	ffffd097          	auipc	ra,0xffffd
    800049ba:	7de080e7          	jalr	2014(ra) # 80002194 <argstr>
    return -1;
    800049be:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049c0:	12054663          	bltz	a0,80004aec <sys_link+0x148>
    800049c4:	08000613          	li	a2,128
    800049c8:	f5040593          	addi	a1,s0,-176
    800049cc:	4505                	li	a0,1
    800049ce:	ffffd097          	auipc	ra,0xffffd
    800049d2:	7c6080e7          	jalr	1990(ra) # 80002194 <argstr>
    return -1;
    800049d6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d8:	10054a63          	bltz	a0,80004aec <sys_link+0x148>
    800049dc:	ee26                	sd	s1,280(sp)
  begin_op();
    800049de:	fffff097          	auipc	ra,0xfffff
    800049e2:	cb6080e7          	jalr	-842(ra) # 80003694 <begin_op>
  if((ip = namei(old)) == 0){
    800049e6:	ed040513          	addi	a0,s0,-304
    800049ea:	fffff097          	auipc	ra,0xfffff
    800049ee:	aaa080e7          	jalr	-1366(ra) # 80003494 <namei>
    800049f2:	84aa                	mv	s1,a0
    800049f4:	c949                	beqz	a0,80004a86 <sys_link+0xe2>
  ilock(ip);
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	2cc080e7          	jalr	716(ra) # 80002cc2 <ilock>
  if(ip->type == T_DIR){
    800049fe:	04449703          	lh	a4,68(s1)
    80004a02:	4785                	li	a5,1
    80004a04:	08f70863          	beq	a4,a5,80004a94 <sys_link+0xf0>
    80004a08:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004a0a:	04a4d783          	lhu	a5,74(s1)
    80004a0e:	2785                	addiw	a5,a5,1
    80004a10:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a14:	8526                	mv	a0,s1
    80004a16:	ffffe097          	auipc	ra,0xffffe
    80004a1a:	1e0080e7          	jalr	480(ra) # 80002bf6 <iupdate>
  iunlock(ip);
    80004a1e:	8526                	mv	a0,s1
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	368080e7          	jalr	872(ra) # 80002d88 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a28:	fd040593          	addi	a1,s0,-48
    80004a2c:	f5040513          	addi	a0,s0,-176
    80004a30:	fffff097          	auipc	ra,0xfffff
    80004a34:	a82080e7          	jalr	-1406(ra) # 800034b2 <nameiparent>
    80004a38:	892a                	mv	s2,a0
    80004a3a:	cd35                	beqz	a0,80004ab6 <sys_link+0x112>
  ilock(dp);
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	286080e7          	jalr	646(ra) # 80002cc2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a44:	00092703          	lw	a4,0(s2)
    80004a48:	409c                	lw	a5,0(s1)
    80004a4a:	06f71163          	bne	a4,a5,80004aac <sys_link+0x108>
    80004a4e:	40d0                	lw	a2,4(s1)
    80004a50:	fd040593          	addi	a1,s0,-48
    80004a54:	854a                	mv	a0,s2
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	97c080e7          	jalr	-1668(ra) # 800033d2 <dirlink>
    80004a5e:	04054763          	bltz	a0,80004aac <sys_link+0x108>
  iunlockput(dp);
    80004a62:	854a                	mv	a0,s2
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	4c4080e7          	jalr	1220(ra) # 80002f28 <iunlockput>
  iput(ip);
    80004a6c:	8526                	mv	a0,s1
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	412080e7          	jalr	1042(ra) # 80002e80 <iput>
  end_op();
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	c98080e7          	jalr	-872(ra) # 8000370e <end_op>
  return 0;
    80004a7e:	4781                	li	a5,0
    80004a80:	64f2                	ld	s1,280(sp)
    80004a82:	6952                	ld	s2,272(sp)
    80004a84:	a0a5                	j	80004aec <sys_link+0x148>
    end_op();
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	c88080e7          	jalr	-888(ra) # 8000370e <end_op>
    return -1;
    80004a8e:	57fd                	li	a5,-1
    80004a90:	64f2                	ld	s1,280(sp)
    80004a92:	a8a9                	j	80004aec <sys_link+0x148>
    iunlockput(ip);
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	492080e7          	jalr	1170(ra) # 80002f28 <iunlockput>
    end_op();
    80004a9e:	fffff097          	auipc	ra,0xfffff
    80004aa2:	c70080e7          	jalr	-912(ra) # 8000370e <end_op>
    return -1;
    80004aa6:	57fd                	li	a5,-1
    80004aa8:	64f2                	ld	s1,280(sp)
    80004aaa:	a089                	j	80004aec <sys_link+0x148>
    iunlockput(dp);
    80004aac:	854a                	mv	a0,s2
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	47a080e7          	jalr	1146(ra) # 80002f28 <iunlockput>
  ilock(ip);
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	20a080e7          	jalr	522(ra) # 80002cc2 <ilock>
  ip->nlink--;
    80004ac0:	04a4d783          	lhu	a5,74(s1)
    80004ac4:	37fd                	addiw	a5,a5,-1
    80004ac6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aca:	8526                	mv	a0,s1
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	12a080e7          	jalr	298(ra) # 80002bf6 <iupdate>
  iunlockput(ip);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	452080e7          	jalr	1106(ra) # 80002f28 <iunlockput>
  end_op();
    80004ade:	fffff097          	auipc	ra,0xfffff
    80004ae2:	c30080e7          	jalr	-976(ra) # 8000370e <end_op>
  return -1;
    80004ae6:	57fd                	li	a5,-1
    80004ae8:	64f2                	ld	s1,280(sp)
    80004aea:	6952                	ld	s2,272(sp)
}
    80004aec:	853e                	mv	a0,a5
    80004aee:	70b2                	ld	ra,296(sp)
    80004af0:	7412                	ld	s0,288(sp)
    80004af2:	6155                	addi	sp,sp,304
    80004af4:	8082                	ret

0000000080004af6 <sys_unlink>:
{
    80004af6:	7151                	addi	sp,sp,-240
    80004af8:	f586                	sd	ra,232(sp)
    80004afa:	f1a2                	sd	s0,224(sp)
    80004afc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004afe:	08000613          	li	a2,128
    80004b02:	f3040593          	addi	a1,s0,-208
    80004b06:	4501                	li	a0,0
    80004b08:	ffffd097          	auipc	ra,0xffffd
    80004b0c:	68c080e7          	jalr	1676(ra) # 80002194 <argstr>
    80004b10:	1a054a63          	bltz	a0,80004cc4 <sys_unlink+0x1ce>
    80004b14:	eda6                	sd	s1,216(sp)
  begin_op();
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	b7e080e7          	jalr	-1154(ra) # 80003694 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b1e:	fb040593          	addi	a1,s0,-80
    80004b22:	f3040513          	addi	a0,s0,-208
    80004b26:	fffff097          	auipc	ra,0xfffff
    80004b2a:	98c080e7          	jalr	-1652(ra) # 800034b2 <nameiparent>
    80004b2e:	84aa                	mv	s1,a0
    80004b30:	cd71                	beqz	a0,80004c0c <sys_unlink+0x116>
  ilock(dp);
    80004b32:	ffffe097          	auipc	ra,0xffffe
    80004b36:	190080e7          	jalr	400(ra) # 80002cc2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b3a:	00004597          	auipc	a1,0x4
    80004b3e:	a0e58593          	addi	a1,a1,-1522 # 80008548 <etext+0x548>
    80004b42:	fb040513          	addi	a0,s0,-80
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	662080e7          	jalr	1634(ra) # 800031a8 <namecmp>
    80004b4e:	14050c63          	beqz	a0,80004ca6 <sys_unlink+0x1b0>
    80004b52:	00004597          	auipc	a1,0x4
    80004b56:	9fe58593          	addi	a1,a1,-1538 # 80008550 <etext+0x550>
    80004b5a:	fb040513          	addi	a0,s0,-80
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	64a080e7          	jalr	1610(ra) # 800031a8 <namecmp>
    80004b66:	14050063          	beqz	a0,80004ca6 <sys_unlink+0x1b0>
    80004b6a:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b6c:	f2c40613          	addi	a2,s0,-212
    80004b70:	fb040593          	addi	a1,s0,-80
    80004b74:	8526                	mv	a0,s1
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	64c080e7          	jalr	1612(ra) # 800031c2 <dirlookup>
    80004b7e:	892a                	mv	s2,a0
    80004b80:	12050263          	beqz	a0,80004ca4 <sys_unlink+0x1ae>
  ilock(ip);
    80004b84:	ffffe097          	auipc	ra,0xffffe
    80004b88:	13e080e7          	jalr	318(ra) # 80002cc2 <ilock>
  if(ip->nlink < 1)
    80004b8c:	04a91783          	lh	a5,74(s2)
    80004b90:	08f05563          	blez	a5,80004c1a <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b94:	04491703          	lh	a4,68(s2)
    80004b98:	4785                	li	a5,1
    80004b9a:	08f70963          	beq	a4,a5,80004c2c <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004b9e:	4641                	li	a2,16
    80004ba0:	4581                	li	a1,0
    80004ba2:	fc040513          	addi	a0,s0,-64
    80004ba6:	ffffb097          	auipc	ra,0xffffb
    80004baa:	5d4080e7          	jalr	1492(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bae:	4741                	li	a4,16
    80004bb0:	f2c42683          	lw	a3,-212(s0)
    80004bb4:	fc040613          	addi	a2,s0,-64
    80004bb8:	4581                	li	a1,0
    80004bba:	8526                	mv	a0,s1
    80004bbc:	ffffe097          	auipc	ra,0xffffe
    80004bc0:	4c2080e7          	jalr	1218(ra) # 8000307e <writei>
    80004bc4:	47c1                	li	a5,16
    80004bc6:	0af51b63          	bne	a0,a5,80004c7c <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004bca:	04491703          	lh	a4,68(s2)
    80004bce:	4785                	li	a5,1
    80004bd0:	0af70f63          	beq	a4,a5,80004c8e <sys_unlink+0x198>
  iunlockput(dp);
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	352080e7          	jalr	850(ra) # 80002f28 <iunlockput>
  ip->nlink--;
    80004bde:	04a95783          	lhu	a5,74(s2)
    80004be2:	37fd                	addiw	a5,a5,-1
    80004be4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004be8:	854a                	mv	a0,s2
    80004bea:	ffffe097          	auipc	ra,0xffffe
    80004bee:	00c080e7          	jalr	12(ra) # 80002bf6 <iupdate>
  iunlockput(ip);
    80004bf2:	854a                	mv	a0,s2
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	334080e7          	jalr	820(ra) # 80002f28 <iunlockput>
  end_op();
    80004bfc:	fffff097          	auipc	ra,0xfffff
    80004c00:	b12080e7          	jalr	-1262(ra) # 8000370e <end_op>
  return 0;
    80004c04:	4501                	li	a0,0
    80004c06:	64ee                	ld	s1,216(sp)
    80004c08:	694e                	ld	s2,208(sp)
    80004c0a:	a84d                	j	80004cbc <sys_unlink+0x1c6>
    end_op();
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	b02080e7          	jalr	-1278(ra) # 8000370e <end_op>
    return -1;
    80004c14:	557d                	li	a0,-1
    80004c16:	64ee                	ld	s1,216(sp)
    80004c18:	a055                	j	80004cbc <sys_unlink+0x1c6>
    80004c1a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004c1c:	00004517          	auipc	a0,0x4
    80004c20:	95c50513          	addi	a0,a0,-1700 # 80008578 <etext+0x578>
    80004c24:	00001097          	auipc	ra,0x1
    80004c28:	556080e7          	jalr	1366(ra) # 8000617a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c2c:	04c92703          	lw	a4,76(s2)
    80004c30:	02000793          	li	a5,32
    80004c34:	f6e7f5e3          	bgeu	a5,a4,80004b9e <sys_unlink+0xa8>
    80004c38:	e5ce                	sd	s3,200(sp)
    80004c3a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c3e:	4741                	li	a4,16
    80004c40:	86ce                	mv	a3,s3
    80004c42:	f1840613          	addi	a2,s0,-232
    80004c46:	4581                	li	a1,0
    80004c48:	854a                	mv	a0,s2
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	330080e7          	jalr	816(ra) # 80002f7a <readi>
    80004c52:	47c1                	li	a5,16
    80004c54:	00f51c63          	bne	a0,a5,80004c6c <sys_unlink+0x176>
    if(de.inum != 0)
    80004c58:	f1845783          	lhu	a5,-232(s0)
    80004c5c:	e7b5                	bnez	a5,80004cc8 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c5e:	29c1                	addiw	s3,s3,16
    80004c60:	04c92783          	lw	a5,76(s2)
    80004c64:	fcf9ede3          	bltu	s3,a5,80004c3e <sys_unlink+0x148>
    80004c68:	69ae                	ld	s3,200(sp)
    80004c6a:	bf15                	j	80004b9e <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004c6c:	00004517          	auipc	a0,0x4
    80004c70:	92450513          	addi	a0,a0,-1756 # 80008590 <etext+0x590>
    80004c74:	00001097          	auipc	ra,0x1
    80004c78:	506080e7          	jalr	1286(ra) # 8000617a <panic>
    80004c7c:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004c7e:	00004517          	auipc	a0,0x4
    80004c82:	92a50513          	addi	a0,a0,-1750 # 800085a8 <etext+0x5a8>
    80004c86:	00001097          	auipc	ra,0x1
    80004c8a:	4f4080e7          	jalr	1268(ra) # 8000617a <panic>
    dp->nlink--;
    80004c8e:	04a4d783          	lhu	a5,74(s1)
    80004c92:	37fd                	addiw	a5,a5,-1
    80004c94:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c98:	8526                	mv	a0,s1
    80004c9a:	ffffe097          	auipc	ra,0xffffe
    80004c9e:	f5c080e7          	jalr	-164(ra) # 80002bf6 <iupdate>
    80004ca2:	bf0d                	j	80004bd4 <sys_unlink+0xde>
    80004ca4:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004ca6:	8526                	mv	a0,s1
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	280080e7          	jalr	640(ra) # 80002f28 <iunlockput>
  end_op();
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	a5e080e7          	jalr	-1442(ra) # 8000370e <end_op>
  return -1;
    80004cb8:	557d                	li	a0,-1
    80004cba:	64ee                	ld	s1,216(sp)
}
    80004cbc:	70ae                	ld	ra,232(sp)
    80004cbe:	740e                	ld	s0,224(sp)
    80004cc0:	616d                	addi	sp,sp,240
    80004cc2:	8082                	ret
    return -1;
    80004cc4:	557d                	li	a0,-1
    80004cc6:	bfdd                	j	80004cbc <sys_unlink+0x1c6>
    iunlockput(ip);
    80004cc8:	854a                	mv	a0,s2
    80004cca:	ffffe097          	auipc	ra,0xffffe
    80004cce:	25e080e7          	jalr	606(ra) # 80002f28 <iunlockput>
    goto bad;
    80004cd2:	694e                	ld	s2,208(sp)
    80004cd4:	69ae                	ld	s3,200(sp)
    80004cd6:	bfc1                	j	80004ca6 <sys_unlink+0x1b0>

0000000080004cd8 <sys_open>:

uint64
sys_open(void)
{
    80004cd8:	7131                	addi	sp,sp,-192
    80004cda:	fd06                	sd	ra,184(sp)
    80004cdc:	f922                	sd	s0,176(sp)
    80004cde:	f526                	sd	s1,168(sp)
    80004ce0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ce2:	08000613          	li	a2,128
    80004ce6:	f5040593          	addi	a1,s0,-176
    80004cea:	4501                	li	a0,0
    80004cec:	ffffd097          	auipc	ra,0xffffd
    80004cf0:	4a8080e7          	jalr	1192(ra) # 80002194 <argstr>
    return -1;
    80004cf4:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cf6:	0c054463          	bltz	a0,80004dbe <sys_open+0xe6>
    80004cfa:	f4c40593          	addi	a1,s0,-180
    80004cfe:	4505                	li	a0,1
    80004d00:	ffffd097          	auipc	ra,0xffffd
    80004d04:	450080e7          	jalr	1104(ra) # 80002150 <argint>
    80004d08:	0a054b63          	bltz	a0,80004dbe <sys_open+0xe6>
    80004d0c:	f14a                	sd	s2,160(sp)

  begin_op();
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	986080e7          	jalr	-1658(ra) # 80003694 <begin_op>

  if(omode & O_CREATE){
    80004d16:	f4c42783          	lw	a5,-180(s0)
    80004d1a:	2007f793          	andi	a5,a5,512
    80004d1e:	cfc5                	beqz	a5,80004dd6 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d20:	4681                	li	a3,0
    80004d22:	4601                	li	a2,0
    80004d24:	4589                	li	a1,2
    80004d26:	f5040513          	addi	a0,s0,-176
    80004d2a:	00000097          	auipc	ra,0x0
    80004d2e:	958080e7          	jalr	-1704(ra) # 80004682 <create>
    80004d32:	892a                	mv	s2,a0
    if(ip == 0){
    80004d34:	c959                	beqz	a0,80004dca <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d36:	04491703          	lh	a4,68(s2)
    80004d3a:	478d                	li	a5,3
    80004d3c:	00f71763          	bne	a4,a5,80004d4a <sys_open+0x72>
    80004d40:	04695703          	lhu	a4,70(s2)
    80004d44:	47a5                	li	a5,9
    80004d46:	0ce7ef63          	bltu	a5,a4,80004e24 <sys_open+0x14c>
    80004d4a:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	d56080e7          	jalr	-682(ra) # 80003aa2 <filealloc>
    80004d54:	89aa                	mv	s3,a0
    80004d56:	c965                	beqz	a0,80004e46 <sys_open+0x16e>
    80004d58:	00000097          	auipc	ra,0x0
    80004d5c:	8e8080e7          	jalr	-1816(ra) # 80004640 <fdalloc>
    80004d60:	84aa                	mv	s1,a0
    80004d62:	0c054d63          	bltz	a0,80004e3c <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d66:	04491703          	lh	a4,68(s2)
    80004d6a:	478d                	li	a5,3
    80004d6c:	0ef70a63          	beq	a4,a5,80004e60 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d70:	4789                	li	a5,2
    80004d72:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d76:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d7a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d7e:	f4c42783          	lw	a5,-180(s0)
    80004d82:	0017c713          	xori	a4,a5,1
    80004d86:	8b05                	andi	a4,a4,1
    80004d88:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d8c:	0037f713          	andi	a4,a5,3
    80004d90:	00e03733          	snez	a4,a4
    80004d94:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d98:	4007f793          	andi	a5,a5,1024
    80004d9c:	c791                	beqz	a5,80004da8 <sys_open+0xd0>
    80004d9e:	04491703          	lh	a4,68(s2)
    80004da2:	4789                	li	a5,2
    80004da4:	0cf70563          	beq	a4,a5,80004e6e <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004da8:	854a                	mv	a0,s2
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	fde080e7          	jalr	-34(ra) # 80002d88 <iunlock>
  end_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	95c080e7          	jalr	-1700(ra) # 8000370e <end_op>
    80004dba:	790a                	ld	s2,160(sp)
    80004dbc:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004dbe:	8526                	mv	a0,s1
    80004dc0:	70ea                	ld	ra,184(sp)
    80004dc2:	744a                	ld	s0,176(sp)
    80004dc4:	74aa                	ld	s1,168(sp)
    80004dc6:	6129                	addi	sp,sp,192
    80004dc8:	8082                	ret
      end_op();
    80004dca:	fffff097          	auipc	ra,0xfffff
    80004dce:	944080e7          	jalr	-1724(ra) # 8000370e <end_op>
      return -1;
    80004dd2:	790a                	ld	s2,160(sp)
    80004dd4:	b7ed                	j	80004dbe <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004dd6:	f5040513          	addi	a0,s0,-176
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	6ba080e7          	jalr	1722(ra) # 80003494 <namei>
    80004de2:	892a                	mv	s2,a0
    80004de4:	c90d                	beqz	a0,80004e16 <sys_open+0x13e>
    ilock(ip);
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	edc080e7          	jalr	-292(ra) # 80002cc2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dee:	04491703          	lh	a4,68(s2)
    80004df2:	4785                	li	a5,1
    80004df4:	f4f711e3          	bne	a4,a5,80004d36 <sys_open+0x5e>
    80004df8:	f4c42783          	lw	a5,-180(s0)
    80004dfc:	d7b9                	beqz	a5,80004d4a <sys_open+0x72>
      iunlockput(ip);
    80004dfe:	854a                	mv	a0,s2
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	128080e7          	jalr	296(ra) # 80002f28 <iunlockput>
      end_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	906080e7          	jalr	-1786(ra) # 8000370e <end_op>
      return -1;
    80004e10:	54fd                	li	s1,-1
    80004e12:	790a                	ld	s2,160(sp)
    80004e14:	b76d                	j	80004dbe <sys_open+0xe6>
      end_op();
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	8f8080e7          	jalr	-1800(ra) # 8000370e <end_op>
      return -1;
    80004e1e:	54fd                	li	s1,-1
    80004e20:	790a                	ld	s2,160(sp)
    80004e22:	bf71                	j	80004dbe <sys_open+0xe6>
    iunlockput(ip);
    80004e24:	854a                	mv	a0,s2
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	102080e7          	jalr	258(ra) # 80002f28 <iunlockput>
    end_op();
    80004e2e:	fffff097          	auipc	ra,0xfffff
    80004e32:	8e0080e7          	jalr	-1824(ra) # 8000370e <end_op>
    return -1;
    80004e36:	54fd                	li	s1,-1
    80004e38:	790a                	ld	s2,160(sp)
    80004e3a:	b751                	j	80004dbe <sys_open+0xe6>
      fileclose(f);
    80004e3c:	854e                	mv	a0,s3
    80004e3e:	fffff097          	auipc	ra,0xfffff
    80004e42:	d20080e7          	jalr	-736(ra) # 80003b5e <fileclose>
    iunlockput(ip);
    80004e46:	854a                	mv	a0,s2
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	0e0080e7          	jalr	224(ra) # 80002f28 <iunlockput>
    end_op();
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	8be080e7          	jalr	-1858(ra) # 8000370e <end_op>
    return -1;
    80004e58:	54fd                	li	s1,-1
    80004e5a:	790a                	ld	s2,160(sp)
    80004e5c:	69ea                	ld	s3,152(sp)
    80004e5e:	b785                	j	80004dbe <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004e60:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e64:	04691783          	lh	a5,70(s2)
    80004e68:	02f99223          	sh	a5,36(s3)
    80004e6c:	b739                	j	80004d7a <sys_open+0xa2>
    itrunc(ip);
    80004e6e:	854a                	mv	a0,s2
    80004e70:	ffffe097          	auipc	ra,0xffffe
    80004e74:	f64080e7          	jalr	-156(ra) # 80002dd4 <itrunc>
    80004e78:	bf05                	j	80004da8 <sys_open+0xd0>

0000000080004e7a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e7a:	7175                	addi	sp,sp,-144
    80004e7c:	e506                	sd	ra,136(sp)
    80004e7e:	e122                	sd	s0,128(sp)
    80004e80:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e82:	fffff097          	auipc	ra,0xfffff
    80004e86:	812080e7          	jalr	-2030(ra) # 80003694 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e8a:	08000613          	li	a2,128
    80004e8e:	f7040593          	addi	a1,s0,-144
    80004e92:	4501                	li	a0,0
    80004e94:	ffffd097          	auipc	ra,0xffffd
    80004e98:	300080e7          	jalr	768(ra) # 80002194 <argstr>
    80004e9c:	02054963          	bltz	a0,80004ece <sys_mkdir+0x54>
    80004ea0:	4681                	li	a3,0
    80004ea2:	4601                	li	a2,0
    80004ea4:	4585                	li	a1,1
    80004ea6:	f7040513          	addi	a0,s0,-144
    80004eaa:	fffff097          	auipc	ra,0xfffff
    80004eae:	7d8080e7          	jalr	2008(ra) # 80004682 <create>
    80004eb2:	cd11                	beqz	a0,80004ece <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	074080e7          	jalr	116(ra) # 80002f28 <iunlockput>
  end_op();
    80004ebc:	fffff097          	auipc	ra,0xfffff
    80004ec0:	852080e7          	jalr	-1966(ra) # 8000370e <end_op>
  return 0;
    80004ec4:	4501                	li	a0,0
}
    80004ec6:	60aa                	ld	ra,136(sp)
    80004ec8:	640a                	ld	s0,128(sp)
    80004eca:	6149                	addi	sp,sp,144
    80004ecc:	8082                	ret
    end_op();
    80004ece:	fffff097          	auipc	ra,0xfffff
    80004ed2:	840080e7          	jalr	-1984(ra) # 8000370e <end_op>
    return -1;
    80004ed6:	557d                	li	a0,-1
    80004ed8:	b7fd                	j	80004ec6 <sys_mkdir+0x4c>

0000000080004eda <sys_mknod>:

uint64
sys_mknod(void)
{
    80004eda:	7135                	addi	sp,sp,-160
    80004edc:	ed06                	sd	ra,152(sp)
    80004ede:	e922                	sd	s0,144(sp)
    80004ee0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	7b2080e7          	jalr	1970(ra) # 80003694 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eea:	08000613          	li	a2,128
    80004eee:	f7040593          	addi	a1,s0,-144
    80004ef2:	4501                	li	a0,0
    80004ef4:	ffffd097          	auipc	ra,0xffffd
    80004ef8:	2a0080e7          	jalr	672(ra) # 80002194 <argstr>
    80004efc:	04054a63          	bltz	a0,80004f50 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f00:	f6c40593          	addi	a1,s0,-148
    80004f04:	4505                	li	a0,1
    80004f06:	ffffd097          	auipc	ra,0xffffd
    80004f0a:	24a080e7          	jalr	586(ra) # 80002150 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f0e:	04054163          	bltz	a0,80004f50 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f12:	f6840593          	addi	a1,s0,-152
    80004f16:	4509                	li	a0,2
    80004f18:	ffffd097          	auipc	ra,0xffffd
    80004f1c:	238080e7          	jalr	568(ra) # 80002150 <argint>
     argint(1, &major) < 0 ||
    80004f20:	02054863          	bltz	a0,80004f50 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f24:	f6841683          	lh	a3,-152(s0)
    80004f28:	f6c41603          	lh	a2,-148(s0)
    80004f2c:	458d                	li	a1,3
    80004f2e:	f7040513          	addi	a0,s0,-144
    80004f32:	fffff097          	auipc	ra,0xfffff
    80004f36:	750080e7          	jalr	1872(ra) # 80004682 <create>
     argint(2, &minor) < 0 ||
    80004f3a:	c919                	beqz	a0,80004f50 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f3c:	ffffe097          	auipc	ra,0xffffe
    80004f40:	fec080e7          	jalr	-20(ra) # 80002f28 <iunlockput>
  end_op();
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	7ca080e7          	jalr	1994(ra) # 8000370e <end_op>
  return 0;
    80004f4c:	4501                	li	a0,0
    80004f4e:	a031                	j	80004f5a <sys_mknod+0x80>
    end_op();
    80004f50:	ffffe097          	auipc	ra,0xffffe
    80004f54:	7be080e7          	jalr	1982(ra) # 8000370e <end_op>
    return -1;
    80004f58:	557d                	li	a0,-1
}
    80004f5a:	60ea                	ld	ra,152(sp)
    80004f5c:	644a                	ld	s0,144(sp)
    80004f5e:	610d                	addi	sp,sp,160
    80004f60:	8082                	ret

0000000080004f62 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f62:	7135                	addi	sp,sp,-160
    80004f64:	ed06                	sd	ra,152(sp)
    80004f66:	e922                	sd	s0,144(sp)
    80004f68:	e14a                	sd	s2,128(sp)
    80004f6a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f6c:	ffffc097          	auipc	ra,0xffffc
    80004f70:	efe080e7          	jalr	-258(ra) # 80000e6a <myproc>
    80004f74:	892a                	mv	s2,a0
  
  begin_op();
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	71e080e7          	jalr	1822(ra) # 80003694 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f7e:	08000613          	li	a2,128
    80004f82:	f6040593          	addi	a1,s0,-160
    80004f86:	4501                	li	a0,0
    80004f88:	ffffd097          	auipc	ra,0xffffd
    80004f8c:	20c080e7          	jalr	524(ra) # 80002194 <argstr>
    80004f90:	04054d63          	bltz	a0,80004fea <sys_chdir+0x88>
    80004f94:	e526                	sd	s1,136(sp)
    80004f96:	f6040513          	addi	a0,s0,-160
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	4fa080e7          	jalr	1274(ra) # 80003494 <namei>
    80004fa2:	84aa                	mv	s1,a0
    80004fa4:	c131                	beqz	a0,80004fe8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fa6:	ffffe097          	auipc	ra,0xffffe
    80004faa:	d1c080e7          	jalr	-740(ra) # 80002cc2 <ilock>
  if(ip->type != T_DIR){
    80004fae:	04449703          	lh	a4,68(s1)
    80004fb2:	4785                	li	a5,1
    80004fb4:	04f71163          	bne	a4,a5,80004ff6 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fb8:	8526                	mv	a0,s1
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	dce080e7          	jalr	-562(ra) # 80002d88 <iunlock>
  iput(p->cwd);
    80004fc2:	15093503          	ld	a0,336(s2)
    80004fc6:	ffffe097          	auipc	ra,0xffffe
    80004fca:	eba080e7          	jalr	-326(ra) # 80002e80 <iput>
  end_op();
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	740080e7          	jalr	1856(ra) # 8000370e <end_op>
  p->cwd = ip;
    80004fd6:	14993823          	sd	s1,336(s2)
  return 0;
    80004fda:	4501                	li	a0,0
    80004fdc:	64aa                	ld	s1,136(sp)
}
    80004fde:	60ea                	ld	ra,152(sp)
    80004fe0:	644a                	ld	s0,144(sp)
    80004fe2:	690a                	ld	s2,128(sp)
    80004fe4:	610d                	addi	sp,sp,160
    80004fe6:	8082                	ret
    80004fe8:	64aa                	ld	s1,136(sp)
    end_op();
    80004fea:	ffffe097          	auipc	ra,0xffffe
    80004fee:	724080e7          	jalr	1828(ra) # 8000370e <end_op>
    return -1;
    80004ff2:	557d                	li	a0,-1
    80004ff4:	b7ed                	j	80004fde <sys_chdir+0x7c>
    iunlockput(ip);
    80004ff6:	8526                	mv	a0,s1
    80004ff8:	ffffe097          	auipc	ra,0xffffe
    80004ffc:	f30080e7          	jalr	-208(ra) # 80002f28 <iunlockput>
    end_op();
    80005000:	ffffe097          	auipc	ra,0xffffe
    80005004:	70e080e7          	jalr	1806(ra) # 8000370e <end_op>
    return -1;
    80005008:	557d                	li	a0,-1
    8000500a:	64aa                	ld	s1,136(sp)
    8000500c:	bfc9                	j	80004fde <sys_chdir+0x7c>

000000008000500e <sys_exec>:

uint64
sys_exec(void)
{
    8000500e:	7121                	addi	sp,sp,-448
    80005010:	ff06                	sd	ra,440(sp)
    80005012:	fb22                	sd	s0,432(sp)
    80005014:	f34a                	sd	s2,416(sp)
    80005016:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005018:	08000613          	li	a2,128
    8000501c:	f5040593          	addi	a1,s0,-176
    80005020:	4501                	li	a0,0
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	172080e7          	jalr	370(ra) # 80002194 <argstr>
    return -1;
    8000502a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000502c:	0e054a63          	bltz	a0,80005120 <sys_exec+0x112>
    80005030:	e4840593          	addi	a1,s0,-440
    80005034:	4505                	li	a0,1
    80005036:	ffffd097          	auipc	ra,0xffffd
    8000503a:	13c080e7          	jalr	316(ra) # 80002172 <argaddr>
    8000503e:	0e054163          	bltz	a0,80005120 <sys_exec+0x112>
    80005042:	f726                	sd	s1,424(sp)
    80005044:	ef4e                	sd	s3,408(sp)
    80005046:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005048:	10000613          	li	a2,256
    8000504c:	4581                	li	a1,0
    8000504e:	e5040513          	addi	a0,s0,-432
    80005052:	ffffb097          	auipc	ra,0xffffb
    80005056:	128080e7          	jalr	296(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000505a:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000505e:	89a6                	mv	s3,s1
    80005060:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005062:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005066:	00391513          	slli	a0,s2,0x3
    8000506a:	e4040593          	addi	a1,s0,-448
    8000506e:	e4843783          	ld	a5,-440(s0)
    80005072:	953e                	add	a0,a0,a5
    80005074:	ffffd097          	auipc	ra,0xffffd
    80005078:	042080e7          	jalr	66(ra) # 800020b6 <fetchaddr>
    8000507c:	02054a63          	bltz	a0,800050b0 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005080:	e4043783          	ld	a5,-448(s0)
    80005084:	c7b1                	beqz	a5,800050d0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005086:	ffffb097          	auipc	ra,0xffffb
    8000508a:	094080e7          	jalr	148(ra) # 8000011a <kalloc>
    8000508e:	85aa                	mv	a1,a0
    80005090:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005094:	cd11                	beqz	a0,800050b0 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005096:	6605                	lui	a2,0x1
    80005098:	e4043503          	ld	a0,-448(s0)
    8000509c:	ffffd097          	auipc	ra,0xffffd
    800050a0:	06c080e7          	jalr	108(ra) # 80002108 <fetchstr>
    800050a4:	00054663          	bltz	a0,800050b0 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    800050a8:	0905                	addi	s2,s2,1
    800050aa:	09a1                	addi	s3,s3,8
    800050ac:	fb491de3          	bne	s2,s4,80005066 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b0:	f5040913          	addi	s2,s0,-176
    800050b4:	6088                	ld	a0,0(s1)
    800050b6:	c12d                	beqz	a0,80005118 <sys_exec+0x10a>
    kfree(argv[i]);
    800050b8:	ffffb097          	auipc	ra,0xffffb
    800050bc:	f64080e7          	jalr	-156(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c0:	04a1                	addi	s1,s1,8
    800050c2:	ff2499e3          	bne	s1,s2,800050b4 <sys_exec+0xa6>
  return -1;
    800050c6:	597d                	li	s2,-1
    800050c8:	74ba                	ld	s1,424(sp)
    800050ca:	69fa                	ld	s3,408(sp)
    800050cc:	6a5a                	ld	s4,400(sp)
    800050ce:	a889                	j	80005120 <sys_exec+0x112>
      argv[i] = 0;
    800050d0:	0009079b          	sext.w	a5,s2
    800050d4:	078e                	slli	a5,a5,0x3
    800050d6:	fd078793          	addi	a5,a5,-48
    800050da:	97a2                	add	a5,a5,s0
    800050dc:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800050e0:	e5040593          	addi	a1,s0,-432
    800050e4:	f5040513          	addi	a0,s0,-176
    800050e8:	fffff097          	auipc	ra,0xfffff
    800050ec:	126080e7          	jalr	294(ra) # 8000420e <exec>
    800050f0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f2:	f5040993          	addi	s3,s0,-176
    800050f6:	6088                	ld	a0,0(s1)
    800050f8:	cd01                	beqz	a0,80005110 <sys_exec+0x102>
    kfree(argv[i]);
    800050fa:	ffffb097          	auipc	ra,0xffffb
    800050fe:	f22080e7          	jalr	-222(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005102:	04a1                	addi	s1,s1,8
    80005104:	ff3499e3          	bne	s1,s3,800050f6 <sys_exec+0xe8>
    80005108:	74ba                	ld	s1,424(sp)
    8000510a:	69fa                	ld	s3,408(sp)
    8000510c:	6a5a                	ld	s4,400(sp)
    8000510e:	a809                	j	80005120 <sys_exec+0x112>
  return ret;
    80005110:	74ba                	ld	s1,424(sp)
    80005112:	69fa                	ld	s3,408(sp)
    80005114:	6a5a                	ld	s4,400(sp)
    80005116:	a029                	j	80005120 <sys_exec+0x112>
  return -1;
    80005118:	597d                	li	s2,-1
    8000511a:	74ba                	ld	s1,424(sp)
    8000511c:	69fa                	ld	s3,408(sp)
    8000511e:	6a5a                	ld	s4,400(sp)
}
    80005120:	854a                	mv	a0,s2
    80005122:	70fa                	ld	ra,440(sp)
    80005124:	745a                	ld	s0,432(sp)
    80005126:	791a                	ld	s2,416(sp)
    80005128:	6139                	addi	sp,sp,448
    8000512a:	8082                	ret

000000008000512c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000512c:	7139                	addi	sp,sp,-64
    8000512e:	fc06                	sd	ra,56(sp)
    80005130:	f822                	sd	s0,48(sp)
    80005132:	f426                	sd	s1,40(sp)
    80005134:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005136:	ffffc097          	auipc	ra,0xffffc
    8000513a:	d34080e7          	jalr	-716(ra) # 80000e6a <myproc>
    8000513e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005140:	fd840593          	addi	a1,s0,-40
    80005144:	4501                	li	a0,0
    80005146:	ffffd097          	auipc	ra,0xffffd
    8000514a:	02c080e7          	jalr	44(ra) # 80002172 <argaddr>
    return -1;
    8000514e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005150:	0e054063          	bltz	a0,80005230 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005154:	fc840593          	addi	a1,s0,-56
    80005158:	fd040513          	addi	a0,s0,-48
    8000515c:	fffff097          	auipc	ra,0xfffff
    80005160:	d70080e7          	jalr	-656(ra) # 80003ecc <pipealloc>
    return -1;
    80005164:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005166:	0c054563          	bltz	a0,80005230 <sys_pipe+0x104>
  fd0 = -1;
    8000516a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000516e:	fd043503          	ld	a0,-48(s0)
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	4ce080e7          	jalr	1230(ra) # 80004640 <fdalloc>
    8000517a:	fca42223          	sw	a0,-60(s0)
    8000517e:	08054c63          	bltz	a0,80005216 <sys_pipe+0xea>
    80005182:	fc843503          	ld	a0,-56(s0)
    80005186:	fffff097          	auipc	ra,0xfffff
    8000518a:	4ba080e7          	jalr	1210(ra) # 80004640 <fdalloc>
    8000518e:	fca42023          	sw	a0,-64(s0)
    80005192:	06054963          	bltz	a0,80005204 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005196:	4691                	li	a3,4
    80005198:	fc440613          	addi	a2,s0,-60
    8000519c:	fd843583          	ld	a1,-40(s0)
    800051a0:	68a8                	ld	a0,80(s1)
    800051a2:	ffffc097          	auipc	ra,0xffffc
    800051a6:	964080e7          	jalr	-1692(ra) # 80000b06 <copyout>
    800051aa:	02054063          	bltz	a0,800051ca <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051ae:	4691                	li	a3,4
    800051b0:	fc040613          	addi	a2,s0,-64
    800051b4:	fd843583          	ld	a1,-40(s0)
    800051b8:	0591                	addi	a1,a1,4
    800051ba:	68a8                	ld	a0,80(s1)
    800051bc:	ffffc097          	auipc	ra,0xffffc
    800051c0:	94a080e7          	jalr	-1718(ra) # 80000b06 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051c4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051c6:	06055563          	bgez	a0,80005230 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051ca:	fc442783          	lw	a5,-60(s0)
    800051ce:	07e9                	addi	a5,a5,26
    800051d0:	078e                	slli	a5,a5,0x3
    800051d2:	97a6                	add	a5,a5,s1
    800051d4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051d8:	fc042783          	lw	a5,-64(s0)
    800051dc:	07e9                	addi	a5,a5,26
    800051de:	078e                	slli	a5,a5,0x3
    800051e0:	00f48533          	add	a0,s1,a5
    800051e4:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051e8:	fd043503          	ld	a0,-48(s0)
    800051ec:	fffff097          	auipc	ra,0xfffff
    800051f0:	972080e7          	jalr	-1678(ra) # 80003b5e <fileclose>
    fileclose(wf);
    800051f4:	fc843503          	ld	a0,-56(s0)
    800051f8:	fffff097          	auipc	ra,0xfffff
    800051fc:	966080e7          	jalr	-1690(ra) # 80003b5e <fileclose>
    return -1;
    80005200:	57fd                	li	a5,-1
    80005202:	a03d                	j	80005230 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005204:	fc442783          	lw	a5,-60(s0)
    80005208:	0007c763          	bltz	a5,80005216 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000520c:	07e9                	addi	a5,a5,26
    8000520e:	078e                	slli	a5,a5,0x3
    80005210:	97a6                	add	a5,a5,s1
    80005212:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005216:	fd043503          	ld	a0,-48(s0)
    8000521a:	fffff097          	auipc	ra,0xfffff
    8000521e:	944080e7          	jalr	-1724(ra) # 80003b5e <fileclose>
    fileclose(wf);
    80005222:	fc843503          	ld	a0,-56(s0)
    80005226:	fffff097          	auipc	ra,0xfffff
    8000522a:	938080e7          	jalr	-1736(ra) # 80003b5e <fileclose>
    return -1;
    8000522e:	57fd                	li	a5,-1
}
    80005230:	853e                	mv	a0,a5
    80005232:	70e2                	ld	ra,56(sp)
    80005234:	7442                	ld	s0,48(sp)
    80005236:	74a2                	ld	s1,40(sp)
    80005238:	6121                	addi	sp,sp,64
    8000523a:	8082                	ret

000000008000523c <sys_mmap>:
//add by lab10

uint64
sys_mmap(void)
{
    8000523c:	7139                	addi	sp,sp,-64
    8000523e:	fc06                	sd	ra,56(sp)
    80005240:	f822                	sd	s0,48(sp)
    80005242:	f426                	sd	s1,40(sp)
    80005244:	0080                	addi	s0,sp,64
  struct vm_area_struct *vmap;
  struct proc *pr;
  int length,prot,flags,fd,i;
  uint64 sz;

  if(argint(1,&length)<0 || argint(2,&prot)<0 ||
    80005246:	fcc40593          	addi	a1,s0,-52
    8000524a:	4505                	li	a0,1
    8000524c:	ffffd097          	auipc	ra,0xffffd
    80005250:	f04080e7          	jalr	-252(ra) # 80002150 <argint>
  argint(3,&flags)<0 || argint(4,&fd)<0){
    return 0xffffffffffffffff;
    80005254:	54fd                	li	s1,-1
  if(argint(1,&length)<0 || argint(2,&prot)<0 ||
    80005256:	10054963          	bltz	a0,80005368 <sys_mmap+0x12c>
    8000525a:	fc840593          	addi	a1,s0,-56
    8000525e:	4509                	li	a0,2
    80005260:	ffffd097          	auipc	ra,0xffffd
    80005264:	ef0080e7          	jalr	-272(ra) # 80002150 <argint>
    80005268:	10054063          	bltz	a0,80005368 <sys_mmap+0x12c>
  argint(3,&flags)<0 || argint(4,&fd)<0){
    8000526c:	fc440593          	addi	a1,s0,-60
    80005270:	450d                	li	a0,3
    80005272:	ffffd097          	auipc	ra,0xffffd
    80005276:	ede080e7          	jalr	-290(ra) # 80002150 <argint>
  if(argint(1,&length)<0 || argint(2,&prot)<0 ||
    8000527a:	0e054763          	bltz	a0,80005368 <sys_mmap+0x12c>
  argint(3,&flags)<0 || argint(4,&fd)<0){
    8000527e:	fc040593          	addi	a1,s0,-64
    80005282:	4511                	li	a0,4
    80005284:	ffffd097          	auipc	ra,0xffffd
    80005288:	ecc080e7          	jalr	-308(ra) # 80002150 <argint>
    8000528c:	0c054e63          	bltz	a0,80005368 <sys_mmap+0x12c>
    80005290:	f04a                	sd	s2,32(sp)
  }
  pr=myproc();
    80005292:	ffffc097          	auipc	ra,0xffffc
    80005296:	bd8080e7          	jalr	-1064(ra) # 80000e6a <myproc>
    8000529a:	892a                	mv	s2,a0
  if(!pr->ofile[fd]->readable){
    8000529c:	fc042783          	lw	a5,-64(s0)
    800052a0:	07e9                	addi	a5,a5,26
    800052a2:	078e                	slli	a5,a5,0x3
    800052a4:	97aa                	add	a5,a5,a0
    800052a6:	639c                	ld	a5,0(a5)
    800052a8:	0087c703          	lbu	a4,8(a5)
    800052ac:	e709                	bnez	a4,800052b6 <sys_mmap+0x7a>
    if(prot & PROT_READ)
    800052ae:	fc842703          	lw	a4,-56(s0)
    800052b2:	8b05                	andi	a4,a4,1
    800052b4:	eb79                	bnez	a4,8000538a <sys_mmap+0x14e>
      return 0xffffffffffffffff;
  }
  if(!pr->ofile[fd]->writable){
    800052b6:	0097c783          	lbu	a5,9(a5)
    800052ba:	eb91                	bnez	a5,800052ce <sys_mmap+0x92>
    if(prot&PROT_WRITE&&flags==MAP_SHARED)
    800052bc:	fc842783          	lw	a5,-56(s0)
    800052c0:	8b89                	andi	a5,a5,2
    800052c2:	c791                	beqz	a5,800052ce <sys_mmap+0x92>
    800052c4:	fc442703          	lw	a4,-60(s0)
    800052c8:	4785                	li	a5,1
    800052ca:	0af70563          	beq	a4,a5,80005374 <sys_mmap+0x138>
    800052ce:	ec4e                	sd	s3,24(sp)
      return 0xffffffffffffffff;
  }

  if((vmap=vma_alloc())==0){
    800052d0:	00001097          	auipc	ra,0x1
    800052d4:	8f6080e7          	jalr	-1802(ra) # 80005bc6 <vma_alloc>
    800052d8:	89aa                	mv	s3,a0
    800052da:	c145                	beqz	a0,8000537a <sys_mmap+0x13e>
    return 0xffffffffffffffff;
  }

  acquire(&pr->lock);
    800052dc:	854a                	mv	a0,s2
    800052de:	00001097          	auipc	ra,0x1
    800052e2:	416080e7          	jalr	1046(ra) # 800066f4 <acquire>
  for(i=0;i<NOFILE;i++){
    800052e6:	16890713          	addi	a4,s2,360
    800052ea:	4781                	li	a5,0
    800052ec:	4641                	li	a2,16
    if(pr->areaps[i]==0){
    800052ee:	6314                	ld	a3,0(a4)
    800052f0:	ca89                	beqz	a3,80005302 <sys_mmap+0xc6>
  for(i=0;i<NOFILE;i++){
    800052f2:	2785                	addiw	a5,a5,1
    800052f4:	0721                	addi	a4,a4,8
    800052f6:	fec79ce3          	bne	a5,a2,800052ee <sys_mmap+0xb2>
      release(&pr->lock);
      break;
    }
  }
  if(i==NOFILE){
    return 0xffffffffffffffff;
    800052fa:	54fd                	li	s1,-1
    800052fc:	7902                	ld	s2,32(sp)
    800052fe:	69e2                	ld	s3,24(sp)
    80005300:	a0a5                	j	80005368 <sys_mmap+0x12c>
      pr->areaps[i]=vmap;
    80005302:	02c78793          	addi	a5,a5,44
    80005306:	078e                	slli	a5,a5,0x3
    80005308:	97ca                	add	a5,a5,s2
    8000530a:	0137b423          	sd	s3,8(a5)
      release(&pr->lock);
    8000530e:	854a                	mv	a0,s2
    80005310:	00001097          	auipc	ra,0x1
    80005314:	498080e7          	jalr	1176(ra) # 800067a8 <release>
  }
  sz=pr->sz;
    80005318:	04893483          	ld	s1,72(s2)
  if(lazy_grow_proc(length)<0){
    8000531c:	fcc42503          	lw	a0,-52(s0)
    80005320:	ffffc097          	auipc	ra,0xffffc
    80005324:	7e4080e7          	jalr	2020(ra) # 80001b04 <lazy_grow_proc>
    80005328:	04054d63          	bltz	a0,80005382 <sys_mmap+0x146>
    return 0xffffffffffffffff;
  }

  vmap->addr=(char *)sz;
    8000532c:	0099b023          	sd	s1,0(s3)
  vmap->length=length;
    80005330:	fcc42783          	lw	a5,-52(s0)
    80005334:	00f9b423          	sd	a5,8(s3)
  vmap->prot=(prot & PROT_READ) | (prot & PROT_WRITE);
    80005338:	fc842783          	lw	a5,-56(s0)
    8000533c:	8b8d                	andi	a5,a5,3
    8000533e:	00f98823          	sb	a5,16(s3)
  vmap->flags=flags;
    80005342:	fc442783          	lw	a5,-60(s0)
    80005346:	00f988a3          	sb	a5,17(s3)
  vmap->file=pr->ofile[fd];
    8000534a:	fc042783          	lw	a5,-64(s0)
    8000534e:	07e9                	addi	a5,a5,26
    80005350:	078e                	slli	a5,a5,0x3
    80005352:	993e                	add	s2,s2,a5
    80005354:	00093503          	ld	a0,0(s2)
    80005358:	00a9bc23          	sd	a0,24(s3)
  filedup(pr->ofile[fd]);
    8000535c:	ffffe097          	auipc	ra,0xffffe
    80005360:	7b0080e7          	jalr	1968(ra) # 80003b0c <filedup>
  return sz;
    80005364:	7902                	ld	s2,32(sp)
    80005366:	69e2                	ld	s3,24(sp)
}
    80005368:	8526                	mv	a0,s1
    8000536a:	70e2                	ld	ra,56(sp)
    8000536c:	7442                	ld	s0,48(sp)
    8000536e:	74a2                	ld	s1,40(sp)
    80005370:	6121                	addi	sp,sp,64
    80005372:	8082                	ret
      return 0xffffffffffffffff;
    80005374:	54fd                	li	s1,-1
    80005376:	7902                	ld	s2,32(sp)
    80005378:	bfc5                	j	80005368 <sys_mmap+0x12c>
    return 0xffffffffffffffff;
    8000537a:	54fd                	li	s1,-1
    8000537c:	7902                	ld	s2,32(sp)
    8000537e:	69e2                	ld	s3,24(sp)
    80005380:	b7e5                	j	80005368 <sys_mmap+0x12c>
    return 0xffffffffffffffff;
    80005382:	54fd                	li	s1,-1
    80005384:	7902                	ld	s2,32(sp)
    80005386:	69e2                	ld	s3,24(sp)
    80005388:	b7c5                	j	80005368 <sys_mmap+0x12c>
    8000538a:	7902                	ld	s2,32(sp)
    8000538c:	bff1                	j	80005368 <sys_mmap+0x12c>

000000008000538e <sys_munmap>:

uint64
sys_munmap(void)
{
    8000538e:	7139                	addi	sp,sp,-64
    80005390:	fc06                	sd	ra,56(sp)
    80005392:	f822                	sd	s0,48(sp)
    80005394:	f04a                	sd	s2,32(sp)
    80005396:	0080                	addi	s0,sp,64
  struct proc *pr=myproc();
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	ad2080e7          	jalr	-1326(ra) # 80000e6a <myproc>
    800053a0:	892a                	mv	s2,a0
  int startAddr,length;

  if(argint(0,&startAddr)<0 || argint(1,&length)<0){
    800053a2:	fcc40593          	addi	a1,s0,-52
    800053a6:	4501                	li	a0,0
    800053a8:	ffffd097          	auipc	ra,0xffffd
    800053ac:	da8080e7          	jalr	-600(ra) # 80002150 <argint>
    return -1;
    800053b0:	57fd                	li	a5,-1
  if(argint(0,&startAddr)<0 || argint(1,&length)<0){
    800053b2:	12054063          	bltz	a0,800054d2 <sys_munmap+0x144>
    800053b6:	fc840593          	addi	a1,s0,-56
    800053ba:	4505                	li	a0,1
    800053bc:	ffffd097          	auipc	ra,0xffffd
    800053c0:	d94080e7          	jalr	-620(ra) # 80002150 <argint>
    800053c4:	10054d63          	bltz	a0,800054de <sys_munmap+0x150>
    800053c8:	f426                	sd	s1,40(sp)
  }

  for(int i=0;i<NOFILE;i++){
    if(pr->areaps[i]==0)
      continue;
    if((uint64)pr->areaps[i]->addr==startAddr){
    800053ca:	fcc42583          	lw	a1,-52(s0)
    800053ce:	16890793          	addi	a5,s2,360
  for(int i=0;i<NOFILE;i++){
    800053d2:	4481                	li	s1,0
    800053d4:	4641                	li	a2,16
    800053d6:	a049                	j	80005458 <sys_munmap+0xca>
    800053d8:	ec4e                	sd	s3,24(sp)
      if(length>=pr->areaps[i]->length){
        length = pr->areaps[i]->length;
      }
      if(pr->areaps[i]->prot & PROT_WRITE && 
      pr->areaps[i]->flags==MAP_SHARED){
        begin_op();
    800053da:	ffffe097          	auipc	ra,0xffffe
    800053de:	2ba080e7          	jalr	698(ra) # 80003694 <begin_op>
        ilock(pr->areaps[i]->file->ip);
    800053e2:	00349993          	slli	s3,s1,0x3
    800053e6:	99ca                	add	s3,s3,s2
    800053e8:	1689b783          	ld	a5,360(s3)
    800053ec:	6f9c                	ld	a5,24(a5)
    800053ee:	6f88                	ld	a0,24(a5)
    800053f0:	ffffe097          	auipc	ra,0xffffe
    800053f4:	8d2080e7          	jalr	-1838(ra) # 80002cc2 <ilock>
        writei(pr->areaps[i]->file->ip,1,(uint64)startAddr,0,length);
    800053f8:	1689b783          	ld	a5,360(s3)
    800053fc:	6f9c                	ld	a5,24(a5)
    800053fe:	fc842703          	lw	a4,-56(s0)
    80005402:	4681                	li	a3,0
    80005404:	fcc42603          	lw	a2,-52(s0)
    80005408:	4585                	li	a1,1
    8000540a:	6f88                	ld	a0,24(a5)
    8000540c:	ffffe097          	auipc	ra,0xffffe
    80005410:	c72080e7          	jalr	-910(ra) # 8000307e <writei>
        iunlock(pr->areaps[i]->file->ip);
    80005414:	1689b783          	ld	a5,360(s3)
    80005418:	6f9c                	ld	a5,24(a5)
    8000541a:	6f88                	ld	a0,24(a5)
    8000541c:	ffffe097          	auipc	ra,0xffffe
    80005420:	96c080e7          	jalr	-1684(ra) # 80002d88 <iunlock>
        end_op();
    80005424:	ffffe097          	auipc	ra,0xffffe
    80005428:	2ea080e7          	jalr	746(ra) # 8000370e <end_op>
    8000542c:	69e2                	ld	s3,24(sp)
    8000542e:	a891                	j	80005482 <sys_munmap+0xf4>
      }
      uvmunmap(pr->pagetable,(uint64)startAddr,length/PGSIZE,1);
      if(length==pr->areaps[i]->length){
        fileclose(pr->areaps[i]->file);
    80005430:	6f88                	ld	a0,24(a5)
    80005432:	ffffe097          	auipc	ra,0xffffe
    80005436:	72c080e7          	jalr	1836(ra) # 80003b5e <fileclose>
        vma_free(pr->areaps[i]);
    8000543a:	16893503          	ld	a0,360(s2)
    8000543e:	00000097          	auipc	ra,0x0
    80005442:	7ee080e7          	jalr	2030(ra) # 80005c2c <vma_free>
        pr->areaps[i]=0;
    80005446:	16093423          	sd	zero,360(s2)
        return 0;
    8000544a:	4781                	li	a5,0
    8000544c:	74a2                	ld	s1,40(sp)
    8000544e:	a051                	j	800054d2 <sys_munmap+0x144>
  for(int i=0;i<NOFILE;i++){
    80005450:	2485                	addiw	s1,s1,1
    80005452:	07a1                	addi	a5,a5,8
    80005454:	06c48d63          	beq	s1,a2,800054ce <sys_munmap+0x140>
    if(pr->areaps[i]==0)
    80005458:	6398                	ld	a4,0(a5)
    8000545a:	db7d                	beqz	a4,80005450 <sys_munmap+0xc2>
    if((uint64)pr->areaps[i]->addr==startAddr){
    8000545c:	6314                	ld	a3,0(a4)
    8000545e:	feb699e3          	bne	a3,a1,80005450 <sys_munmap+0xc2>
      if(length>=pr->areaps[i]->length){
    80005462:	671c                	ld	a5,8(a4)
    80005464:	fc842683          	lw	a3,-56(s0)
    80005468:	00f6e463          	bltu	a3,a5,80005470 <sys_munmap+0xe2>
        length = pr->areaps[i]->length;
    8000546c:	fcf42423          	sw	a5,-56(s0)
      if(pr->areaps[i]->prot & PROT_WRITE && 
    80005470:	01074783          	lbu	a5,16(a4)
    80005474:	8b89                	andi	a5,a5,2
    80005476:	c791                	beqz	a5,80005482 <sys_munmap+0xf4>
    80005478:	01174703          	lbu	a4,17(a4)
    8000547c:	4785                	li	a5,1
    8000547e:	f4f70de3          	beq	a4,a5,800053d8 <sys_munmap+0x4a>
      uvmunmap(pr->pagetable,(uint64)startAddr,length/PGSIZE,1);
    80005482:	fc842783          	lw	a5,-56(s0)
    80005486:	41f7d61b          	sraiw	a2,a5,0x1f
    8000548a:	0146561b          	srliw	a2,a2,0x14
    8000548e:	9e3d                	addw	a2,a2,a5
    80005490:	4685                	li	a3,1
    80005492:	40c6561b          	sraiw	a2,a2,0xc
    80005496:	fcc42583          	lw	a1,-52(s0)
    8000549a:	05093503          	ld	a0,80(s2)
    8000549e:	ffffb097          	auipc	ra,0xffffb
    800054a2:	26a080e7          	jalr	618(ra) # 80000708 <uvmunmap>
      if(length==pr->areaps[i]->length){
    800054a6:	fc842703          	lw	a4,-56(s0)
    800054aa:	048e                	slli	s1,s1,0x3
    800054ac:	9926                	add	s2,s2,s1
    800054ae:	16893783          	ld	a5,360(s2)
    800054b2:	6794                	ld	a3,8(a5)
    800054b4:	f6d70ee3          	beq	a4,a3,80005430 <sys_munmap+0xa2>
      }else{
        pr->areaps[i]->addr+=length;
    800054b8:	6394                	ld	a3,0(a5)
    800054ba:	96ba                	add	a3,a3,a4
    800054bc:	e394                	sd	a3,0(a5)
        pr->areaps[i]->length-=length;
    800054be:	16893683          	ld	a3,360(s2)
    800054c2:	669c                	ld	a5,8(a3)
    800054c4:	8f99                	sub	a5,a5,a4
    800054c6:	e69c                	sd	a5,8(a3)
        return 0;
    800054c8:	4781                	li	a5,0
    800054ca:	74a2                	ld	s1,40(sp)
    800054cc:	a019                	j	800054d2 <sys_munmap+0x144>
      }
    }
  }
  return -1;
    800054ce:	57fd                	li	a5,-1
    800054d0:	74a2                	ld	s1,40(sp)
}
    800054d2:	853e                	mv	a0,a5
    800054d4:	70e2                	ld	ra,56(sp)
    800054d6:	7442                	ld	s0,48(sp)
    800054d8:	7902                	ld	s2,32(sp)
    800054da:	6121                	addi	sp,sp,64
    800054dc:	8082                	ret
    return -1;
    800054de:	57fd                	li	a5,-1
    800054e0:	bfcd                	j	800054d2 <sys_munmap+0x144>
	...

00000000800054f0 <kernelvec>:
    800054f0:	7111                	addi	sp,sp,-256
    800054f2:	e006                	sd	ra,0(sp)
    800054f4:	e40a                	sd	sp,8(sp)
    800054f6:	e80e                	sd	gp,16(sp)
    800054f8:	ec12                	sd	tp,24(sp)
    800054fa:	f016                	sd	t0,32(sp)
    800054fc:	f41a                	sd	t1,40(sp)
    800054fe:	f81e                	sd	t2,48(sp)
    80005500:	fc22                	sd	s0,56(sp)
    80005502:	e0a6                	sd	s1,64(sp)
    80005504:	e4aa                	sd	a0,72(sp)
    80005506:	e8ae                	sd	a1,80(sp)
    80005508:	ecb2                	sd	a2,88(sp)
    8000550a:	f0b6                	sd	a3,96(sp)
    8000550c:	f4ba                	sd	a4,104(sp)
    8000550e:	f8be                	sd	a5,112(sp)
    80005510:	fcc2                	sd	a6,120(sp)
    80005512:	e146                	sd	a7,128(sp)
    80005514:	e54a                	sd	s2,136(sp)
    80005516:	e94e                	sd	s3,144(sp)
    80005518:	ed52                	sd	s4,152(sp)
    8000551a:	f156                	sd	s5,160(sp)
    8000551c:	f55a                	sd	s6,168(sp)
    8000551e:	f95e                	sd	s7,176(sp)
    80005520:	fd62                	sd	s8,184(sp)
    80005522:	e1e6                	sd	s9,192(sp)
    80005524:	e5ea                	sd	s10,200(sp)
    80005526:	e9ee                	sd	s11,208(sp)
    80005528:	edf2                	sd	t3,216(sp)
    8000552a:	f1f6                	sd	t4,224(sp)
    8000552c:	f5fa                	sd	t5,232(sp)
    8000552e:	f9fe                	sd	t6,240(sp)
    80005530:	a53fc0ef          	jal	80001f82 <kerneltrap>
    80005534:	6082                	ld	ra,0(sp)
    80005536:	6122                	ld	sp,8(sp)
    80005538:	61c2                	ld	gp,16(sp)
    8000553a:	7282                	ld	t0,32(sp)
    8000553c:	7322                	ld	t1,40(sp)
    8000553e:	73c2                	ld	t2,48(sp)
    80005540:	7462                	ld	s0,56(sp)
    80005542:	6486                	ld	s1,64(sp)
    80005544:	6526                	ld	a0,72(sp)
    80005546:	65c6                	ld	a1,80(sp)
    80005548:	6666                	ld	a2,88(sp)
    8000554a:	7686                	ld	a3,96(sp)
    8000554c:	7726                	ld	a4,104(sp)
    8000554e:	77c6                	ld	a5,112(sp)
    80005550:	7866                	ld	a6,120(sp)
    80005552:	688a                	ld	a7,128(sp)
    80005554:	692a                	ld	s2,136(sp)
    80005556:	69ca                	ld	s3,144(sp)
    80005558:	6a6a                	ld	s4,152(sp)
    8000555a:	7a8a                	ld	s5,160(sp)
    8000555c:	7b2a                	ld	s6,168(sp)
    8000555e:	7bca                	ld	s7,176(sp)
    80005560:	7c6a                	ld	s8,184(sp)
    80005562:	6c8e                	ld	s9,192(sp)
    80005564:	6d2e                	ld	s10,200(sp)
    80005566:	6dce                	ld	s11,208(sp)
    80005568:	6e6e                	ld	t3,216(sp)
    8000556a:	7e8e                	ld	t4,224(sp)
    8000556c:	7f2e                	ld	t5,232(sp)
    8000556e:	7fce                	ld	t6,240(sp)
    80005570:	6111                	addi	sp,sp,256
    80005572:	10200073          	sret
    80005576:	00000013          	nop
    8000557a:	00000013          	nop
    8000557e:	0001                	nop

0000000080005580 <timervec>:
    80005580:	34051573          	csrrw	a0,mscratch,a0
    80005584:	e10c                	sd	a1,0(a0)
    80005586:	e510                	sd	a2,8(a0)
    80005588:	e914                	sd	a3,16(a0)
    8000558a:	6d0c                	ld	a1,24(a0)
    8000558c:	7110                	ld	a2,32(a0)
    8000558e:	6194                	ld	a3,0(a1)
    80005590:	96b2                	add	a3,a3,a2
    80005592:	e194                	sd	a3,0(a1)
    80005594:	4589                	li	a1,2
    80005596:	14459073          	csrw	sip,a1
    8000559a:	6914                	ld	a3,16(a0)
    8000559c:	6510                	ld	a2,8(a0)
    8000559e:	610c                	ld	a1,0(a0)
    800055a0:	34051573          	csrrw	a0,mscratch,a0
    800055a4:	30200073          	mret
	...

00000000800055aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800055aa:	1141                	addi	sp,sp,-16
    800055ac:	e422                	sd	s0,8(sp)
    800055ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800055b0:	0c0007b7          	lui	a5,0xc000
    800055b4:	4705                	li	a4,1
    800055b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800055b8:	0c0007b7          	lui	a5,0xc000
    800055bc:	c3d8                	sw	a4,4(a5)
}
    800055be:	6422                	ld	s0,8(sp)
    800055c0:	0141                	addi	sp,sp,16
    800055c2:	8082                	ret

00000000800055c4 <plicinithart>:

void
plicinithart(void)
{
    800055c4:	1141                	addi	sp,sp,-16
    800055c6:	e406                	sd	ra,8(sp)
    800055c8:	e022                	sd	s0,0(sp)
    800055ca:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055cc:	ffffc097          	auipc	ra,0xffffc
    800055d0:	872080e7          	jalr	-1934(ra) # 80000e3e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800055d4:	0085171b          	slliw	a4,a0,0x8
    800055d8:	0c0027b7          	lui	a5,0xc002
    800055dc:	97ba                	add	a5,a5,a4
    800055de:	40200713          	li	a4,1026
    800055e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800055e6:	00d5151b          	slliw	a0,a0,0xd
    800055ea:	0c2017b7          	lui	a5,0xc201
    800055ee:	97aa                	add	a5,a5,a0
    800055f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800055f4:	60a2                	ld	ra,8(sp)
    800055f6:	6402                	ld	s0,0(sp)
    800055f8:	0141                	addi	sp,sp,16
    800055fa:	8082                	ret

00000000800055fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800055fc:	1141                	addi	sp,sp,-16
    800055fe:	e406                	sd	ra,8(sp)
    80005600:	e022                	sd	s0,0(sp)
    80005602:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005604:	ffffc097          	auipc	ra,0xffffc
    80005608:	83a080e7          	jalr	-1990(ra) # 80000e3e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000560c:	00d5151b          	slliw	a0,a0,0xd
    80005610:	0c2017b7          	lui	a5,0xc201
    80005614:	97aa                	add	a5,a5,a0
  return irq;
}
    80005616:	43c8                	lw	a0,4(a5)
    80005618:	60a2                	ld	ra,8(sp)
    8000561a:	6402                	ld	s0,0(sp)
    8000561c:	0141                	addi	sp,sp,16
    8000561e:	8082                	ret

0000000080005620 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005620:	1101                	addi	sp,sp,-32
    80005622:	ec06                	sd	ra,24(sp)
    80005624:	e822                	sd	s0,16(sp)
    80005626:	e426                	sd	s1,8(sp)
    80005628:	1000                	addi	s0,sp,32
    8000562a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000562c:	ffffc097          	auipc	ra,0xffffc
    80005630:	812080e7          	jalr	-2030(ra) # 80000e3e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005634:	00d5151b          	slliw	a0,a0,0xd
    80005638:	0c2017b7          	lui	a5,0xc201
    8000563c:	97aa                	add	a5,a5,a0
    8000563e:	c3c4                	sw	s1,4(a5)
}
    80005640:	60e2                	ld	ra,24(sp)
    80005642:	6442                	ld	s0,16(sp)
    80005644:	64a2                	ld	s1,8(sp)
    80005646:	6105                	addi	sp,sp,32
    80005648:	8082                	ret

000000008000564a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000564a:	1141                	addi	sp,sp,-16
    8000564c:	e406                	sd	ra,8(sp)
    8000564e:	e022                	sd	s0,0(sp)
    80005650:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005652:	479d                	li	a5,7
    80005654:	06a7c863          	blt	a5,a0,800056c4 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005658:	00018717          	auipc	a4,0x18
    8000565c:	9a870713          	addi	a4,a4,-1624 # 8001d000 <disk>
    80005660:	972a                	add	a4,a4,a0
    80005662:	6789                	lui	a5,0x2
    80005664:	97ba                	add	a5,a5,a4
    80005666:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000566a:	e7ad                	bnez	a5,800056d4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000566c:	00451793          	slli	a5,a0,0x4
    80005670:	0001a717          	auipc	a4,0x1a
    80005674:	99070713          	addi	a4,a4,-1648 # 8001f000 <disk+0x2000>
    80005678:	6314                	ld	a3,0(a4)
    8000567a:	96be                	add	a3,a3,a5
    8000567c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005680:	6314                	ld	a3,0(a4)
    80005682:	96be                	add	a3,a3,a5
    80005684:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005688:	6314                	ld	a3,0(a4)
    8000568a:	96be                	add	a3,a3,a5
    8000568c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005690:	6318                	ld	a4,0(a4)
    80005692:	97ba                	add	a5,a5,a4
    80005694:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005698:	00018717          	auipc	a4,0x18
    8000569c:	96870713          	addi	a4,a4,-1688 # 8001d000 <disk>
    800056a0:	972a                	add	a4,a4,a0
    800056a2:	6789                	lui	a5,0x2
    800056a4:	97ba                	add	a5,a5,a4
    800056a6:	4705                	li	a4,1
    800056a8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800056ac:	0001a517          	auipc	a0,0x1a
    800056b0:	96c50513          	addi	a0,a0,-1684 # 8001f018 <disk+0x2018>
    800056b4:	ffffc097          	auipc	ra,0xffffc
    800056b8:	042080e7          	jalr	66(ra) # 800016f6 <wakeup>
}
    800056bc:	60a2                	ld	ra,8(sp)
    800056be:	6402                	ld	s0,0(sp)
    800056c0:	0141                	addi	sp,sp,16
    800056c2:	8082                	ret
    panic("free_desc 1");
    800056c4:	00003517          	auipc	a0,0x3
    800056c8:	ef450513          	addi	a0,a0,-268 # 800085b8 <etext+0x5b8>
    800056cc:	00001097          	auipc	ra,0x1
    800056d0:	aae080e7          	jalr	-1362(ra) # 8000617a <panic>
    panic("free_desc 2");
    800056d4:	00003517          	auipc	a0,0x3
    800056d8:	ef450513          	addi	a0,a0,-268 # 800085c8 <etext+0x5c8>
    800056dc:	00001097          	auipc	ra,0x1
    800056e0:	a9e080e7          	jalr	-1378(ra) # 8000617a <panic>

00000000800056e4 <virtio_disk_init>:
{
    800056e4:	1141                	addi	sp,sp,-16
    800056e6:	e406                	sd	ra,8(sp)
    800056e8:	e022                	sd	s0,0(sp)
    800056ea:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800056ec:	00003597          	auipc	a1,0x3
    800056f0:	eec58593          	addi	a1,a1,-276 # 800085d8 <etext+0x5d8>
    800056f4:	0001a517          	auipc	a0,0x1a
    800056f8:	a3450513          	addi	a0,a0,-1484 # 8001f128 <disk+0x2128>
    800056fc:	00001097          	auipc	ra,0x1
    80005700:	f68080e7          	jalr	-152(ra) # 80006664 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005704:	100017b7          	lui	a5,0x10001
    80005708:	4398                	lw	a4,0(a5)
    8000570a:	2701                	sext.w	a4,a4
    8000570c:	747277b7          	lui	a5,0x74727
    80005710:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005714:	0ef71f63          	bne	a4,a5,80005812 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005718:	100017b7          	lui	a5,0x10001
    8000571c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000571e:	439c                	lw	a5,0(a5)
    80005720:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005722:	4705                	li	a4,1
    80005724:	0ee79763          	bne	a5,a4,80005812 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005728:	100017b7          	lui	a5,0x10001
    8000572c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000572e:	439c                	lw	a5,0(a5)
    80005730:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005732:	4709                	li	a4,2
    80005734:	0ce79f63          	bne	a5,a4,80005812 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005738:	100017b7          	lui	a5,0x10001
    8000573c:	47d8                	lw	a4,12(a5)
    8000573e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005740:	554d47b7          	lui	a5,0x554d4
    80005744:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005748:	0cf71563          	bne	a4,a5,80005812 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000574c:	100017b7          	lui	a5,0x10001
    80005750:	4705                	li	a4,1
    80005752:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005754:	470d                	li	a4,3
    80005756:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005758:	10001737          	lui	a4,0x10001
    8000575c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000575e:	c7ffe737          	lui	a4,0xc7ffe
    80005762:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd62ff>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005766:	8ef9                	and	a3,a3,a4
    80005768:	10001737          	lui	a4,0x10001
    8000576c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000576e:	472d                	li	a4,11
    80005770:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005772:	473d                	li	a4,15
    80005774:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005776:	100017b7          	lui	a5,0x10001
    8000577a:	6705                	lui	a4,0x1
    8000577c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000577e:	100017b7          	lui	a5,0x10001
    80005782:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005786:	100017b7          	lui	a5,0x10001
    8000578a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000578e:	439c                	lw	a5,0(a5)
    80005790:	2781                	sext.w	a5,a5
  if(max == 0)
    80005792:	cbc1                	beqz	a5,80005822 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005794:	471d                	li	a4,7
    80005796:	08f77e63          	bgeu	a4,a5,80005832 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000579a:	100017b7          	lui	a5,0x10001
    8000579e:	4721                	li	a4,8
    800057a0:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800057a2:	6609                	lui	a2,0x2
    800057a4:	4581                	li	a1,0
    800057a6:	00018517          	auipc	a0,0x18
    800057aa:	85a50513          	addi	a0,a0,-1958 # 8001d000 <disk>
    800057ae:	ffffb097          	auipc	ra,0xffffb
    800057b2:	9cc080e7          	jalr	-1588(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800057b6:	00018697          	auipc	a3,0x18
    800057ba:	84a68693          	addi	a3,a3,-1974 # 8001d000 <disk>
    800057be:	00c6d713          	srli	a4,a3,0xc
    800057c2:	2701                	sext.w	a4,a4
    800057c4:	100017b7          	lui	a5,0x10001
    800057c8:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    800057ca:	0001a797          	auipc	a5,0x1a
    800057ce:	83678793          	addi	a5,a5,-1994 # 8001f000 <disk+0x2000>
    800057d2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800057d4:	00018717          	auipc	a4,0x18
    800057d8:	8ac70713          	addi	a4,a4,-1876 # 8001d080 <disk+0x80>
    800057dc:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800057de:	00019717          	auipc	a4,0x19
    800057e2:	82270713          	addi	a4,a4,-2014 # 8001e000 <disk+0x1000>
    800057e6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800057e8:	4705                	li	a4,1
    800057ea:	00e78c23          	sb	a4,24(a5)
    800057ee:	00e78ca3          	sb	a4,25(a5)
    800057f2:	00e78d23          	sb	a4,26(a5)
    800057f6:	00e78da3          	sb	a4,27(a5)
    800057fa:	00e78e23          	sb	a4,28(a5)
    800057fe:	00e78ea3          	sb	a4,29(a5)
    80005802:	00e78f23          	sb	a4,30(a5)
    80005806:	00e78fa3          	sb	a4,31(a5)
}
    8000580a:	60a2                	ld	ra,8(sp)
    8000580c:	6402                	ld	s0,0(sp)
    8000580e:	0141                	addi	sp,sp,16
    80005810:	8082                	ret
    panic("could not find virtio disk");
    80005812:	00003517          	auipc	a0,0x3
    80005816:	dd650513          	addi	a0,a0,-554 # 800085e8 <etext+0x5e8>
    8000581a:	00001097          	auipc	ra,0x1
    8000581e:	960080e7          	jalr	-1696(ra) # 8000617a <panic>
    panic("virtio disk has no queue 0");
    80005822:	00003517          	auipc	a0,0x3
    80005826:	de650513          	addi	a0,a0,-538 # 80008608 <etext+0x608>
    8000582a:	00001097          	auipc	ra,0x1
    8000582e:	950080e7          	jalr	-1712(ra) # 8000617a <panic>
    panic("virtio disk max queue too short");
    80005832:	00003517          	auipc	a0,0x3
    80005836:	df650513          	addi	a0,a0,-522 # 80008628 <etext+0x628>
    8000583a:	00001097          	auipc	ra,0x1
    8000583e:	940080e7          	jalr	-1728(ra) # 8000617a <panic>

0000000080005842 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005842:	7159                	addi	sp,sp,-112
    80005844:	f486                	sd	ra,104(sp)
    80005846:	f0a2                	sd	s0,96(sp)
    80005848:	eca6                	sd	s1,88(sp)
    8000584a:	e8ca                	sd	s2,80(sp)
    8000584c:	e4ce                	sd	s3,72(sp)
    8000584e:	e0d2                	sd	s4,64(sp)
    80005850:	fc56                	sd	s5,56(sp)
    80005852:	f85a                	sd	s6,48(sp)
    80005854:	f45e                	sd	s7,40(sp)
    80005856:	f062                	sd	s8,32(sp)
    80005858:	ec66                	sd	s9,24(sp)
    8000585a:	1880                	addi	s0,sp,112
    8000585c:	8a2a                	mv	s4,a0
    8000585e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005860:	00c52c03          	lw	s8,12(a0)
    80005864:	001c1c1b          	slliw	s8,s8,0x1
    80005868:	1c02                	slli	s8,s8,0x20
    8000586a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000586e:	0001a517          	auipc	a0,0x1a
    80005872:	8ba50513          	addi	a0,a0,-1862 # 8001f128 <disk+0x2128>
    80005876:	00001097          	auipc	ra,0x1
    8000587a:	e7e080e7          	jalr	-386(ra) # 800066f4 <acquire>
  for(int i = 0; i < 3; i++){
    8000587e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005880:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005882:	00017b97          	auipc	s7,0x17
    80005886:	77eb8b93          	addi	s7,s7,1918 # 8001d000 <disk>
    8000588a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000588c:	4a8d                	li	s5,3
    8000588e:	a88d                	j	80005900 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005890:	00fb8733          	add	a4,s7,a5
    80005894:	975a                	add	a4,a4,s6
    80005896:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000589a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000589c:	0207c563          	bltz	a5,800058c6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800058a0:	2905                	addiw	s2,s2,1
    800058a2:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800058a4:	1b590163          	beq	s2,s5,80005a46 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    800058a8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800058aa:	00019717          	auipc	a4,0x19
    800058ae:	76e70713          	addi	a4,a4,1902 # 8001f018 <disk+0x2018>
    800058b2:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800058b4:	00074683          	lbu	a3,0(a4)
    800058b8:	fee1                	bnez	a3,80005890 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    800058ba:	2785                	addiw	a5,a5,1
    800058bc:	0705                	addi	a4,a4,1
    800058be:	fe979be3          	bne	a5,s1,800058b4 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800058c2:	57fd                	li	a5,-1
    800058c4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800058c6:	03205163          	blez	s2,800058e8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800058ca:	f9042503          	lw	a0,-112(s0)
    800058ce:	00000097          	auipc	ra,0x0
    800058d2:	d7c080e7          	jalr	-644(ra) # 8000564a <free_desc>
      for(int j = 0; j < i; j++)
    800058d6:	4785                	li	a5,1
    800058d8:	0127d863          	bge	a5,s2,800058e8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800058dc:	f9442503          	lw	a0,-108(s0)
    800058e0:	00000097          	auipc	ra,0x0
    800058e4:	d6a080e7          	jalr	-662(ra) # 8000564a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058e8:	0001a597          	auipc	a1,0x1a
    800058ec:	84058593          	addi	a1,a1,-1984 # 8001f128 <disk+0x2128>
    800058f0:	00019517          	auipc	a0,0x19
    800058f4:	72850513          	addi	a0,a0,1832 # 8001f018 <disk+0x2018>
    800058f8:	ffffc097          	auipc	ra,0xffffc
    800058fc:	c72080e7          	jalr	-910(ra) # 8000156a <sleep>
  for(int i = 0; i < 3; i++){
    80005900:	f9040613          	addi	a2,s0,-112
    80005904:	894e                	mv	s2,s3
    80005906:	b74d                	j	800058a8 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005908:	00019717          	auipc	a4,0x19
    8000590c:	6f873703          	ld	a4,1784(a4) # 8001f000 <disk+0x2000>
    80005910:	973e                	add	a4,a4,a5
    80005912:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005916:	00017897          	auipc	a7,0x17
    8000591a:	6ea88893          	addi	a7,a7,1770 # 8001d000 <disk>
    8000591e:	00019717          	auipc	a4,0x19
    80005922:	6e270713          	addi	a4,a4,1762 # 8001f000 <disk+0x2000>
    80005926:	6314                	ld	a3,0(a4)
    80005928:	96be                	add	a3,a3,a5
    8000592a:	00c6d583          	lhu	a1,12(a3)
    8000592e:	0015e593          	ori	a1,a1,1
    80005932:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005936:	f9842683          	lw	a3,-104(s0)
    8000593a:	630c                	ld	a1,0(a4)
    8000593c:	97ae                	add	a5,a5,a1
    8000593e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005942:	20050593          	addi	a1,a0,512
    80005946:	0592                	slli	a1,a1,0x4
    80005948:	95c6                	add	a1,a1,a7
    8000594a:	57fd                	li	a5,-1
    8000594c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005950:	00469793          	slli	a5,a3,0x4
    80005954:	00073803          	ld	a6,0(a4)
    80005958:	983e                	add	a6,a6,a5
    8000595a:	6689                	lui	a3,0x2
    8000595c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005960:	96b2                	add	a3,a3,a2
    80005962:	96c6                	add	a3,a3,a7
    80005964:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005968:	6314                	ld	a3,0(a4)
    8000596a:	96be                	add	a3,a3,a5
    8000596c:	4605                	li	a2,1
    8000596e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005970:	6314                	ld	a3,0(a4)
    80005972:	96be                	add	a3,a3,a5
    80005974:	4809                	li	a6,2
    80005976:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000597a:	6314                	ld	a3,0(a4)
    8000597c:	97b6                	add	a5,a5,a3
    8000597e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005982:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005986:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000598a:	6714                	ld	a3,8(a4)
    8000598c:	0026d783          	lhu	a5,2(a3)
    80005990:	8b9d                	andi	a5,a5,7
    80005992:	0786                	slli	a5,a5,0x1
    80005994:	96be                	add	a3,a3,a5
    80005996:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000599a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000599e:	6718                	ld	a4,8(a4)
    800059a0:	00275783          	lhu	a5,2(a4)
    800059a4:	2785                	addiw	a5,a5,1
    800059a6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800059aa:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800059ae:	100017b7          	lui	a5,0x10001
    800059b2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800059b6:	004a2783          	lw	a5,4(s4)
    800059ba:	02c79163          	bne	a5,a2,800059dc <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    800059be:	00019917          	auipc	s2,0x19
    800059c2:	76a90913          	addi	s2,s2,1898 # 8001f128 <disk+0x2128>
  while(b->disk == 1) {
    800059c6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800059c8:	85ca                	mv	a1,s2
    800059ca:	8552                	mv	a0,s4
    800059cc:	ffffc097          	auipc	ra,0xffffc
    800059d0:	b9e080e7          	jalr	-1122(ra) # 8000156a <sleep>
  while(b->disk == 1) {
    800059d4:	004a2783          	lw	a5,4(s4)
    800059d8:	fe9788e3          	beq	a5,s1,800059c8 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800059dc:	f9042903          	lw	s2,-112(s0)
    800059e0:	20090713          	addi	a4,s2,512
    800059e4:	0712                	slli	a4,a4,0x4
    800059e6:	00017797          	auipc	a5,0x17
    800059ea:	61a78793          	addi	a5,a5,1562 # 8001d000 <disk>
    800059ee:	97ba                	add	a5,a5,a4
    800059f0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800059f4:	00019997          	auipc	s3,0x19
    800059f8:	60c98993          	addi	s3,s3,1548 # 8001f000 <disk+0x2000>
    800059fc:	00491713          	slli	a4,s2,0x4
    80005a00:	0009b783          	ld	a5,0(s3)
    80005a04:	97ba                	add	a5,a5,a4
    80005a06:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a0a:	854a                	mv	a0,s2
    80005a0c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	c3a080e7          	jalr	-966(ra) # 8000564a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005a18:	8885                	andi	s1,s1,1
    80005a1a:	f0ed                	bnez	s1,800059fc <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a1c:	00019517          	auipc	a0,0x19
    80005a20:	70c50513          	addi	a0,a0,1804 # 8001f128 <disk+0x2128>
    80005a24:	00001097          	auipc	ra,0x1
    80005a28:	d84080e7          	jalr	-636(ra) # 800067a8 <release>
}
    80005a2c:	70a6                	ld	ra,104(sp)
    80005a2e:	7406                	ld	s0,96(sp)
    80005a30:	64e6                	ld	s1,88(sp)
    80005a32:	6946                	ld	s2,80(sp)
    80005a34:	69a6                	ld	s3,72(sp)
    80005a36:	6a06                	ld	s4,64(sp)
    80005a38:	7ae2                	ld	s5,56(sp)
    80005a3a:	7b42                	ld	s6,48(sp)
    80005a3c:	7ba2                	ld	s7,40(sp)
    80005a3e:	7c02                	ld	s8,32(sp)
    80005a40:	6ce2                	ld	s9,24(sp)
    80005a42:	6165                	addi	sp,sp,112
    80005a44:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a46:	f9042503          	lw	a0,-112(s0)
    80005a4a:	00451613          	slli	a2,a0,0x4
  if(write)
    80005a4e:	00017597          	auipc	a1,0x17
    80005a52:	5b258593          	addi	a1,a1,1458 # 8001d000 <disk>
    80005a56:	20050793          	addi	a5,a0,512
    80005a5a:	0792                	slli	a5,a5,0x4
    80005a5c:	97ae                	add	a5,a5,a1
    80005a5e:	01903733          	snez	a4,s9
    80005a62:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005a66:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    80005a6a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a6e:	00019717          	auipc	a4,0x19
    80005a72:	59270713          	addi	a4,a4,1426 # 8001f000 <disk+0x2000>
    80005a76:	6314                	ld	a3,0(a4)
    80005a78:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a7a:	6789                	lui	a5,0x2
    80005a7c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005a80:	97b2                	add	a5,a5,a2
    80005a82:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a84:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a86:	631c                	ld	a5,0(a4)
    80005a88:	97b2                	add	a5,a5,a2
    80005a8a:	46c1                	li	a3,16
    80005a8c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005a8e:	631c                	ld	a5,0(a4)
    80005a90:	97b2                	add	a5,a5,a2
    80005a92:	4685                	li	a3,1
    80005a94:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005a98:	f9442783          	lw	a5,-108(s0)
    80005a9c:	6314                	ld	a3,0(a4)
    80005a9e:	96b2                	add	a3,a3,a2
    80005aa0:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005aa4:	0792                	slli	a5,a5,0x4
    80005aa6:	6314                	ld	a3,0(a4)
    80005aa8:	96be                	add	a3,a3,a5
    80005aaa:	058a0593          	addi	a1,s4,88
    80005aae:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005ab0:	6318                	ld	a4,0(a4)
    80005ab2:	973e                	add	a4,a4,a5
    80005ab4:	40000693          	li	a3,1024
    80005ab8:	c714                	sw	a3,8(a4)
  if(write)
    80005aba:	e40c97e3          	bnez	s9,80005908 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005abe:	00019717          	auipc	a4,0x19
    80005ac2:	54273703          	ld	a4,1346(a4) # 8001f000 <disk+0x2000>
    80005ac6:	973e                	add	a4,a4,a5
    80005ac8:	4689                	li	a3,2
    80005aca:	00d71623          	sh	a3,12(a4)
    80005ace:	b5a1                	j	80005916 <virtio_disk_rw+0xd4>

0000000080005ad0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005ad0:	1101                	addi	sp,sp,-32
    80005ad2:	ec06                	sd	ra,24(sp)
    80005ad4:	e822                	sd	s0,16(sp)
    80005ad6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005ad8:	00019517          	auipc	a0,0x19
    80005adc:	65050513          	addi	a0,a0,1616 # 8001f128 <disk+0x2128>
    80005ae0:	00001097          	auipc	ra,0x1
    80005ae4:	c14080e7          	jalr	-1004(ra) # 800066f4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005ae8:	100017b7          	lui	a5,0x10001
    80005aec:	53b8                	lw	a4,96(a5)
    80005aee:	8b0d                	andi	a4,a4,3
    80005af0:	100017b7          	lui	a5,0x10001
    80005af4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005af6:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005afa:	00019797          	auipc	a5,0x19
    80005afe:	50678793          	addi	a5,a5,1286 # 8001f000 <disk+0x2000>
    80005b02:	6b94                	ld	a3,16(a5)
    80005b04:	0207d703          	lhu	a4,32(a5)
    80005b08:	0026d783          	lhu	a5,2(a3)
    80005b0c:	06f70563          	beq	a4,a5,80005b76 <virtio_disk_intr+0xa6>
    80005b10:	e426                	sd	s1,8(sp)
    80005b12:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b14:	00017917          	auipc	s2,0x17
    80005b18:	4ec90913          	addi	s2,s2,1260 # 8001d000 <disk>
    80005b1c:	00019497          	auipc	s1,0x19
    80005b20:	4e448493          	addi	s1,s1,1252 # 8001f000 <disk+0x2000>
    __sync_synchronize();
    80005b24:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b28:	6898                	ld	a4,16(s1)
    80005b2a:	0204d783          	lhu	a5,32(s1)
    80005b2e:	8b9d                	andi	a5,a5,7
    80005b30:	078e                	slli	a5,a5,0x3
    80005b32:	97ba                	add	a5,a5,a4
    80005b34:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005b36:	20078713          	addi	a4,a5,512
    80005b3a:	0712                	slli	a4,a4,0x4
    80005b3c:	974a                	add	a4,a4,s2
    80005b3e:	03074703          	lbu	a4,48(a4)
    80005b42:	e731                	bnez	a4,80005b8e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005b44:	20078793          	addi	a5,a5,512
    80005b48:	0792                	slli	a5,a5,0x4
    80005b4a:	97ca                	add	a5,a5,s2
    80005b4c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005b4e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005b52:	ffffc097          	auipc	ra,0xffffc
    80005b56:	ba4080e7          	jalr	-1116(ra) # 800016f6 <wakeup>

    disk.used_idx += 1;
    80005b5a:	0204d783          	lhu	a5,32(s1)
    80005b5e:	2785                	addiw	a5,a5,1
    80005b60:	17c2                	slli	a5,a5,0x30
    80005b62:	93c1                	srli	a5,a5,0x30
    80005b64:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005b68:	6898                	ld	a4,16(s1)
    80005b6a:	00275703          	lhu	a4,2(a4)
    80005b6e:	faf71be3          	bne	a4,a5,80005b24 <virtio_disk_intr+0x54>
    80005b72:	64a2                	ld	s1,8(sp)
    80005b74:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005b76:	00019517          	auipc	a0,0x19
    80005b7a:	5b250513          	addi	a0,a0,1458 # 8001f128 <disk+0x2128>
    80005b7e:	00001097          	auipc	ra,0x1
    80005b82:	c2a080e7          	jalr	-982(ra) # 800067a8 <release>
}
    80005b86:	60e2                	ld	ra,24(sp)
    80005b88:	6442                	ld	s0,16(sp)
    80005b8a:	6105                	addi	sp,sp,32
    80005b8c:	8082                	ret
      panic("virtio_disk_intr status");
    80005b8e:	00003517          	auipc	a0,0x3
    80005b92:	aba50513          	addi	a0,a0,-1350 # 80008648 <etext+0x648>
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	5e4080e7          	jalr	1508(ra) # 8000617a <panic>

0000000080005b9e <vma_init>:
	
}vma_table;

void 
vma_init(void)
{
    80005b9e:	1141                	addi	sp,sp,-16
    80005ba0:	e406                	sd	ra,8(sp)
    80005ba2:	e022                	sd	s0,0(sp)
    80005ba4:	0800                	addi	s0,sp,16
	initlock(&vma_table.lock,"vma_table");
    80005ba6:	00003597          	auipc	a1,0x3
    80005baa:	aba58593          	addi	a1,a1,-1350 # 80008660 <etext+0x660>
    80005bae:	0001a517          	auipc	a0,0x1a
    80005bb2:	45250513          	addi	a0,a0,1106 # 80020000 <vma_table>
    80005bb6:	00001097          	auipc	ra,0x1
    80005bba:	aae080e7          	jalr	-1362(ra) # 80006664 <initlock>
}
    80005bbe:	60a2                	ld	ra,8(sp)
    80005bc0:	6402                	ld	s0,0(sp)
    80005bc2:	0141                	addi	sp,sp,16
    80005bc4:	8082                	ret

0000000080005bc6 <vma_alloc>:

struct vm_area_struct*
vma_alloc(void)
{
    80005bc6:	1101                	addi	sp,sp,-32
    80005bc8:	ec06                	sd	ra,24(sp)
    80005bca:	e822                	sd	s0,16(sp)
    80005bcc:	e426                	sd	s1,8(sp)
    80005bce:	1000                	addi	s0,sp,32
	struct vm_area_struct *vmap;
	acquire(&vma_table.lock);
    80005bd0:	0001a517          	auipc	a0,0x1a
    80005bd4:	43050513          	addi	a0,a0,1072 # 80020000 <vma_table>
    80005bd8:	00001097          	auipc	ra,0x1
    80005bdc:	b1c080e7          	jalr	-1252(ra) # 800066f4 <acquire>
	for(vmap=vma_table.areas;vmap<vma_table.areas+NOFILE;vmap++){
    80005be0:	0001a497          	auipc	s1,0x1a
    80005be4:	43848493          	addi	s1,s1,1080 # 80020018 <vma_table+0x18>
    80005be8:	0001a717          	auipc	a4,0x1a
    80005bec:	63070713          	addi	a4,a4,1584 # 80020218 <vma_table+0x218>
		if(vmap->file==0){
    80005bf0:	6c9c                	ld	a5,24(s1)
    80005bf2:	c785                	beqz	a5,80005c1a <vma_alloc+0x54>
	for(vmap=vma_table.areas;vmap<vma_table.areas+NOFILE;vmap++){
    80005bf4:	02048493          	addi	s1,s1,32
    80005bf8:	fee49ce3          	bne	s1,a4,80005bf0 <vma_alloc+0x2a>
			release(&vma_table.lock);
			return vmap;
		}
	}
	release(&vma_table.lock);
    80005bfc:	0001a517          	auipc	a0,0x1a
    80005c00:	40450513          	addi	a0,a0,1028 # 80020000 <vma_table>
    80005c04:	00001097          	auipc	ra,0x1
    80005c08:	ba4080e7          	jalr	-1116(ra) # 800067a8 <release>
	return 0;
    80005c0c:	4481                	li	s1,0
}
    80005c0e:	8526                	mv	a0,s1
    80005c10:	60e2                	ld	ra,24(sp)
    80005c12:	6442                	ld	s0,16(sp)
    80005c14:	64a2                	ld	s1,8(sp)
    80005c16:	6105                	addi	sp,sp,32
    80005c18:	8082                	ret
			release(&vma_table.lock);
    80005c1a:	0001a517          	auipc	a0,0x1a
    80005c1e:	3e650513          	addi	a0,a0,998 # 80020000 <vma_table>
    80005c22:	00001097          	auipc	ra,0x1
    80005c26:	b86080e7          	jalr	-1146(ra) # 800067a8 <release>
			return vmap;
    80005c2a:	b7d5                	j	80005c0e <vma_alloc+0x48>

0000000080005c2c <vma_free>:
void vma_free(struct vm_area_struct *vmap)
{
    80005c2c:	1141                	addi	sp,sp,-16
    80005c2e:	e422                	sd	s0,8(sp)
    80005c30:	0800                	addi	s0,sp,16
	vmap->file=0;
    80005c32:	00053c23          	sd	zero,24(a0)
}
    80005c36:	6422                	ld	s0,8(sp)
    80005c38:	0141                	addi	sp,sp,16
    80005c3a:	8082                	ret

0000000080005c3c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005c3c:	1141                	addi	sp,sp,-16
    80005c3e:	e422                	sd	s0,8(sp)
    80005c40:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c42:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005c46:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005c4a:	0037979b          	slliw	a5,a5,0x3
    80005c4e:	02004737          	lui	a4,0x2004
    80005c52:	97ba                	add	a5,a5,a4
    80005c54:	0200c737          	lui	a4,0x200c
    80005c58:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005c5a:	6318                	ld	a4,0(a4)
    80005c5c:	000f4637          	lui	a2,0xf4
    80005c60:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c64:	9732                	add	a4,a4,a2
    80005c66:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005c68:	00259693          	slli	a3,a1,0x2
    80005c6c:	96ae                	add	a3,a3,a1
    80005c6e:	068e                	slli	a3,a3,0x3
    80005c70:	0001a717          	auipc	a4,0x1a
    80005c74:	5b070713          	addi	a4,a4,1456 # 80020220 <timer_scratch>
    80005c78:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005c7a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005c7c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005c7e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005c82:	00000797          	auipc	a5,0x0
    80005c86:	8fe78793          	addi	a5,a5,-1794 # 80005580 <timervec>
    80005c8a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c8e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c92:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c96:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c9a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005c9e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005ca2:	30479073          	csrw	mie,a5
}
    80005ca6:	6422                	ld	s0,8(sp)
    80005ca8:	0141                	addi	sp,sp,16
    80005caa:	8082                	ret

0000000080005cac <start>:
{
    80005cac:	1141                	addi	sp,sp,-16
    80005cae:	e406                	sd	ra,8(sp)
    80005cb0:	e022                	sd	s0,0(sp)
    80005cb2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005cb4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005cb8:	7779                	lui	a4,0xffffe
    80005cba:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd639f>
    80005cbe:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005cc0:	6705                	lui	a4,0x1
    80005cc2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005cc6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005cc8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005ccc:	ffffa797          	auipc	a5,0xffffa
    80005cd0:	64c78793          	addi	a5,a5,1612 # 80000318 <main>
    80005cd4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005cd8:	4781                	li	a5,0
    80005cda:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005cde:	67c1                	lui	a5,0x10
    80005ce0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005ce2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005ce6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005cea:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005cee:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005cf2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005cf6:	57fd                	li	a5,-1
    80005cf8:	83a9                	srli	a5,a5,0xa
    80005cfa:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005cfe:	47bd                	li	a5,15
    80005d00:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	f38080e7          	jalr	-200(ra) # 80005c3c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d0c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005d10:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005d12:	823e                	mv	tp,a5
  asm volatile("mret");
    80005d14:	30200073          	mret
}
    80005d18:	60a2                	ld	ra,8(sp)
    80005d1a:	6402                	ld	s0,0(sp)
    80005d1c:	0141                	addi	sp,sp,16
    80005d1e:	8082                	ret

0000000080005d20 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005d20:	715d                	addi	sp,sp,-80
    80005d22:	e486                	sd	ra,72(sp)
    80005d24:	e0a2                	sd	s0,64(sp)
    80005d26:	f84a                	sd	s2,48(sp)
    80005d28:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005d2a:	04c05663          	blez	a2,80005d76 <consolewrite+0x56>
    80005d2e:	fc26                	sd	s1,56(sp)
    80005d30:	f44e                	sd	s3,40(sp)
    80005d32:	f052                	sd	s4,32(sp)
    80005d34:	ec56                	sd	s5,24(sp)
    80005d36:	8a2a                	mv	s4,a0
    80005d38:	84ae                	mv	s1,a1
    80005d3a:	89b2                	mv	s3,a2
    80005d3c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005d3e:	5afd                	li	s5,-1
    80005d40:	4685                	li	a3,1
    80005d42:	8626                	mv	a2,s1
    80005d44:	85d2                	mv	a1,s4
    80005d46:	fbf40513          	addi	a0,s0,-65
    80005d4a:	ffffc097          	auipc	ra,0xffffc
    80005d4e:	cb4080e7          	jalr	-844(ra) # 800019fe <either_copyin>
    80005d52:	03550463          	beq	a0,s5,80005d7a <consolewrite+0x5a>
      break;
    uartputc(c);
    80005d56:	fbf44503          	lbu	a0,-65(s0)
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	7de080e7          	jalr	2014(ra) # 80006538 <uartputc>
  for(i = 0; i < n; i++){
    80005d62:	2905                	addiw	s2,s2,1
    80005d64:	0485                	addi	s1,s1,1
    80005d66:	fd299de3          	bne	s3,s2,80005d40 <consolewrite+0x20>
    80005d6a:	894e                	mv	s2,s3
    80005d6c:	74e2                	ld	s1,56(sp)
    80005d6e:	79a2                	ld	s3,40(sp)
    80005d70:	7a02                	ld	s4,32(sp)
    80005d72:	6ae2                	ld	s5,24(sp)
    80005d74:	a039                	j	80005d82 <consolewrite+0x62>
    80005d76:	4901                	li	s2,0
    80005d78:	a029                	j	80005d82 <consolewrite+0x62>
    80005d7a:	74e2                	ld	s1,56(sp)
    80005d7c:	79a2                	ld	s3,40(sp)
    80005d7e:	7a02                	ld	s4,32(sp)
    80005d80:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005d82:	854a                	mv	a0,s2
    80005d84:	60a6                	ld	ra,72(sp)
    80005d86:	6406                	ld	s0,64(sp)
    80005d88:	7942                	ld	s2,48(sp)
    80005d8a:	6161                	addi	sp,sp,80
    80005d8c:	8082                	ret

0000000080005d8e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d8e:	711d                	addi	sp,sp,-96
    80005d90:	ec86                	sd	ra,88(sp)
    80005d92:	e8a2                	sd	s0,80(sp)
    80005d94:	e4a6                	sd	s1,72(sp)
    80005d96:	e0ca                	sd	s2,64(sp)
    80005d98:	fc4e                	sd	s3,56(sp)
    80005d9a:	f852                	sd	s4,48(sp)
    80005d9c:	f456                	sd	s5,40(sp)
    80005d9e:	f05a                	sd	s6,32(sp)
    80005da0:	1080                	addi	s0,sp,96
    80005da2:	8aaa                	mv	s5,a0
    80005da4:	8a2e                	mv	s4,a1
    80005da6:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005da8:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005dac:	00022517          	auipc	a0,0x22
    80005db0:	5b450513          	addi	a0,a0,1460 # 80028360 <cons>
    80005db4:	00001097          	auipc	ra,0x1
    80005db8:	940080e7          	jalr	-1728(ra) # 800066f4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005dbc:	00022497          	auipc	s1,0x22
    80005dc0:	5a448493          	addi	s1,s1,1444 # 80028360 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005dc4:	00022917          	auipc	s2,0x22
    80005dc8:	63490913          	addi	s2,s2,1588 # 800283f8 <cons+0x98>
  while(n > 0){
    80005dcc:	0d305463          	blez	s3,80005e94 <consoleread+0x106>
    while(cons.r == cons.w){
    80005dd0:	0984a783          	lw	a5,152(s1)
    80005dd4:	09c4a703          	lw	a4,156(s1)
    80005dd8:	0af71963          	bne	a4,a5,80005e8a <consoleread+0xfc>
      if(myproc()->killed){
    80005ddc:	ffffb097          	auipc	ra,0xffffb
    80005de0:	08e080e7          	jalr	142(ra) # 80000e6a <myproc>
    80005de4:	551c                	lw	a5,40(a0)
    80005de6:	e7ad                	bnez	a5,80005e50 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005de8:	85a6                	mv	a1,s1
    80005dea:	854a                	mv	a0,s2
    80005dec:	ffffb097          	auipc	ra,0xffffb
    80005df0:	77e080e7          	jalr	1918(ra) # 8000156a <sleep>
    while(cons.r == cons.w){
    80005df4:	0984a783          	lw	a5,152(s1)
    80005df8:	09c4a703          	lw	a4,156(s1)
    80005dfc:	fef700e3          	beq	a4,a5,80005ddc <consoleread+0x4e>
    80005e00:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005e02:	00022717          	auipc	a4,0x22
    80005e06:	55e70713          	addi	a4,a4,1374 # 80028360 <cons>
    80005e0a:	0017869b          	addiw	a3,a5,1
    80005e0e:	08d72c23          	sw	a3,152(a4)
    80005e12:	07f7f693          	andi	a3,a5,127
    80005e16:	9736                	add	a4,a4,a3
    80005e18:	01874703          	lbu	a4,24(a4)
    80005e1c:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005e20:	4691                	li	a3,4
    80005e22:	04db8a63          	beq	s7,a3,80005e76 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005e26:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e2a:	4685                	li	a3,1
    80005e2c:	faf40613          	addi	a2,s0,-81
    80005e30:	85d2                	mv	a1,s4
    80005e32:	8556                	mv	a0,s5
    80005e34:	ffffc097          	auipc	ra,0xffffc
    80005e38:	b74080e7          	jalr	-1164(ra) # 800019a8 <either_copyout>
    80005e3c:	57fd                	li	a5,-1
    80005e3e:	04f50a63          	beq	a0,a5,80005e92 <consoleread+0x104>
      break;

    dst++;
    80005e42:	0a05                	addi	s4,s4,1
    --n;
    80005e44:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005e46:	47a9                	li	a5,10
    80005e48:	06fb8163          	beq	s7,a5,80005eaa <consoleread+0x11c>
    80005e4c:	6be2                	ld	s7,24(sp)
    80005e4e:	bfbd                	j	80005dcc <consoleread+0x3e>
        release(&cons.lock);
    80005e50:	00022517          	auipc	a0,0x22
    80005e54:	51050513          	addi	a0,a0,1296 # 80028360 <cons>
    80005e58:	00001097          	auipc	ra,0x1
    80005e5c:	950080e7          	jalr	-1712(ra) # 800067a8 <release>
        return -1;
    80005e60:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005e62:	60e6                	ld	ra,88(sp)
    80005e64:	6446                	ld	s0,80(sp)
    80005e66:	64a6                	ld	s1,72(sp)
    80005e68:	6906                	ld	s2,64(sp)
    80005e6a:	79e2                	ld	s3,56(sp)
    80005e6c:	7a42                	ld	s4,48(sp)
    80005e6e:	7aa2                	ld	s5,40(sp)
    80005e70:	7b02                	ld	s6,32(sp)
    80005e72:	6125                	addi	sp,sp,96
    80005e74:	8082                	ret
      if(n < target){
    80005e76:	0009871b          	sext.w	a4,s3
    80005e7a:	01677a63          	bgeu	a4,s6,80005e8e <consoleread+0x100>
        cons.r--;
    80005e7e:	00022717          	auipc	a4,0x22
    80005e82:	56f72d23          	sw	a5,1402(a4) # 800283f8 <cons+0x98>
    80005e86:	6be2                	ld	s7,24(sp)
    80005e88:	a031                	j	80005e94 <consoleread+0x106>
    80005e8a:	ec5e                	sd	s7,24(sp)
    80005e8c:	bf9d                	j	80005e02 <consoleread+0x74>
    80005e8e:	6be2                	ld	s7,24(sp)
    80005e90:	a011                	j	80005e94 <consoleread+0x106>
    80005e92:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005e94:	00022517          	auipc	a0,0x22
    80005e98:	4cc50513          	addi	a0,a0,1228 # 80028360 <cons>
    80005e9c:	00001097          	auipc	ra,0x1
    80005ea0:	90c080e7          	jalr	-1780(ra) # 800067a8 <release>
  return target - n;
    80005ea4:	413b053b          	subw	a0,s6,s3
    80005ea8:	bf6d                	j	80005e62 <consoleread+0xd4>
    80005eaa:	6be2                	ld	s7,24(sp)
    80005eac:	b7e5                	j	80005e94 <consoleread+0x106>

0000000080005eae <consputc>:
{
    80005eae:	1141                	addi	sp,sp,-16
    80005eb0:	e406                	sd	ra,8(sp)
    80005eb2:	e022                	sd	s0,0(sp)
    80005eb4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005eb6:	10000793          	li	a5,256
    80005eba:	00f50a63          	beq	a0,a5,80005ece <consputc+0x20>
    uartputc_sync(c);
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	59c080e7          	jalr	1436(ra) # 8000645a <uartputc_sync>
}
    80005ec6:	60a2                	ld	ra,8(sp)
    80005ec8:	6402                	ld	s0,0(sp)
    80005eca:	0141                	addi	sp,sp,16
    80005ecc:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ece:	4521                	li	a0,8
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	58a080e7          	jalr	1418(ra) # 8000645a <uartputc_sync>
    80005ed8:	02000513          	li	a0,32
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	57e080e7          	jalr	1406(ra) # 8000645a <uartputc_sync>
    80005ee4:	4521                	li	a0,8
    80005ee6:	00000097          	auipc	ra,0x0
    80005eea:	574080e7          	jalr	1396(ra) # 8000645a <uartputc_sync>
    80005eee:	bfe1                	j	80005ec6 <consputc+0x18>

0000000080005ef0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ef0:	1101                	addi	sp,sp,-32
    80005ef2:	ec06                	sd	ra,24(sp)
    80005ef4:	e822                	sd	s0,16(sp)
    80005ef6:	e426                	sd	s1,8(sp)
    80005ef8:	1000                	addi	s0,sp,32
    80005efa:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005efc:	00022517          	auipc	a0,0x22
    80005f00:	46450513          	addi	a0,a0,1124 # 80028360 <cons>
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	7f0080e7          	jalr	2032(ra) # 800066f4 <acquire>

  switch(c){
    80005f0c:	47d5                	li	a5,21
    80005f0e:	0af48563          	beq	s1,a5,80005fb8 <consoleintr+0xc8>
    80005f12:	0297c963          	blt	a5,s1,80005f44 <consoleintr+0x54>
    80005f16:	47a1                	li	a5,8
    80005f18:	0ef48c63          	beq	s1,a5,80006010 <consoleintr+0x120>
    80005f1c:	47c1                	li	a5,16
    80005f1e:	10f49f63          	bne	s1,a5,8000603c <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005f22:	ffffc097          	auipc	ra,0xffffc
    80005f26:	b32080e7          	jalr	-1230(ra) # 80001a54 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005f2a:	00022517          	auipc	a0,0x22
    80005f2e:	43650513          	addi	a0,a0,1078 # 80028360 <cons>
    80005f32:	00001097          	auipc	ra,0x1
    80005f36:	876080e7          	jalr	-1930(ra) # 800067a8 <release>
}
    80005f3a:	60e2                	ld	ra,24(sp)
    80005f3c:	6442                	ld	s0,16(sp)
    80005f3e:	64a2                	ld	s1,8(sp)
    80005f40:	6105                	addi	sp,sp,32
    80005f42:	8082                	ret
  switch(c){
    80005f44:	07f00793          	li	a5,127
    80005f48:	0cf48463          	beq	s1,a5,80006010 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005f4c:	00022717          	auipc	a4,0x22
    80005f50:	41470713          	addi	a4,a4,1044 # 80028360 <cons>
    80005f54:	0a072783          	lw	a5,160(a4)
    80005f58:	09872703          	lw	a4,152(a4)
    80005f5c:	9f99                	subw	a5,a5,a4
    80005f5e:	07f00713          	li	a4,127
    80005f62:	fcf764e3          	bltu	a4,a5,80005f2a <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005f66:	47b5                	li	a5,13
    80005f68:	0cf48d63          	beq	s1,a5,80006042 <consoleintr+0x152>
      consputc(c);
    80005f6c:	8526                	mv	a0,s1
    80005f6e:	00000097          	auipc	ra,0x0
    80005f72:	f40080e7          	jalr	-192(ra) # 80005eae <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f76:	00022797          	auipc	a5,0x22
    80005f7a:	3ea78793          	addi	a5,a5,1002 # 80028360 <cons>
    80005f7e:	0a07a703          	lw	a4,160(a5)
    80005f82:	0017069b          	addiw	a3,a4,1
    80005f86:	0006861b          	sext.w	a2,a3
    80005f8a:	0ad7a023          	sw	a3,160(a5)
    80005f8e:	07f77713          	andi	a4,a4,127
    80005f92:	97ba                	add	a5,a5,a4
    80005f94:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005f98:	47a9                	li	a5,10
    80005f9a:	0cf48b63          	beq	s1,a5,80006070 <consoleintr+0x180>
    80005f9e:	4791                	li	a5,4
    80005fa0:	0cf48863          	beq	s1,a5,80006070 <consoleintr+0x180>
    80005fa4:	00022797          	auipc	a5,0x22
    80005fa8:	4547a783          	lw	a5,1108(a5) # 800283f8 <cons+0x98>
    80005fac:	0807879b          	addiw	a5,a5,128
    80005fb0:	f6f61de3          	bne	a2,a5,80005f2a <consoleintr+0x3a>
    80005fb4:	863e                	mv	a2,a5
    80005fb6:	a86d                	j	80006070 <consoleintr+0x180>
    80005fb8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005fba:	00022717          	auipc	a4,0x22
    80005fbe:	3a670713          	addi	a4,a4,934 # 80028360 <cons>
    80005fc2:	0a072783          	lw	a5,160(a4)
    80005fc6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005fca:	00022497          	auipc	s1,0x22
    80005fce:	39648493          	addi	s1,s1,918 # 80028360 <cons>
    while(cons.e != cons.w &&
    80005fd2:	4929                	li	s2,10
    80005fd4:	02f70a63          	beq	a4,a5,80006008 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005fd8:	37fd                	addiw	a5,a5,-1
    80005fda:	07f7f713          	andi	a4,a5,127
    80005fde:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005fe0:	01874703          	lbu	a4,24(a4)
    80005fe4:	03270463          	beq	a4,s2,8000600c <consoleintr+0x11c>
      cons.e--;
    80005fe8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005fec:	10000513          	li	a0,256
    80005ff0:	00000097          	auipc	ra,0x0
    80005ff4:	ebe080e7          	jalr	-322(ra) # 80005eae <consputc>
    while(cons.e != cons.w &&
    80005ff8:	0a04a783          	lw	a5,160(s1)
    80005ffc:	09c4a703          	lw	a4,156(s1)
    80006000:	fcf71ce3          	bne	a4,a5,80005fd8 <consoleintr+0xe8>
    80006004:	6902                	ld	s2,0(sp)
    80006006:	b715                	j	80005f2a <consoleintr+0x3a>
    80006008:	6902                	ld	s2,0(sp)
    8000600a:	b705                	j	80005f2a <consoleintr+0x3a>
    8000600c:	6902                	ld	s2,0(sp)
    8000600e:	bf31                	j	80005f2a <consoleintr+0x3a>
    if(cons.e != cons.w){
    80006010:	00022717          	auipc	a4,0x22
    80006014:	35070713          	addi	a4,a4,848 # 80028360 <cons>
    80006018:	0a072783          	lw	a5,160(a4)
    8000601c:	09c72703          	lw	a4,156(a4)
    80006020:	f0f705e3          	beq	a4,a5,80005f2a <consoleintr+0x3a>
      cons.e--;
    80006024:	37fd                	addiw	a5,a5,-1
    80006026:	00022717          	auipc	a4,0x22
    8000602a:	3cf72d23          	sw	a5,986(a4) # 80028400 <cons+0xa0>
      consputc(BACKSPACE);
    8000602e:	10000513          	li	a0,256
    80006032:	00000097          	auipc	ra,0x0
    80006036:	e7c080e7          	jalr	-388(ra) # 80005eae <consputc>
    8000603a:	bdc5                	j	80005f2a <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000603c:	ee0487e3          	beqz	s1,80005f2a <consoleintr+0x3a>
    80006040:	b731                	j	80005f4c <consoleintr+0x5c>
      consputc(c);
    80006042:	4529                	li	a0,10
    80006044:	00000097          	auipc	ra,0x0
    80006048:	e6a080e7          	jalr	-406(ra) # 80005eae <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000604c:	00022797          	auipc	a5,0x22
    80006050:	31478793          	addi	a5,a5,788 # 80028360 <cons>
    80006054:	0a07a703          	lw	a4,160(a5)
    80006058:	0017069b          	addiw	a3,a4,1
    8000605c:	0006861b          	sext.w	a2,a3
    80006060:	0ad7a023          	sw	a3,160(a5)
    80006064:	07f77713          	andi	a4,a4,127
    80006068:	97ba                	add	a5,a5,a4
    8000606a:	4729                	li	a4,10
    8000606c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006070:	00022797          	auipc	a5,0x22
    80006074:	38c7a623          	sw	a2,908(a5) # 800283fc <cons+0x9c>
        wakeup(&cons.r);
    80006078:	00022517          	auipc	a0,0x22
    8000607c:	38050513          	addi	a0,a0,896 # 800283f8 <cons+0x98>
    80006080:	ffffb097          	auipc	ra,0xffffb
    80006084:	676080e7          	jalr	1654(ra) # 800016f6 <wakeup>
    80006088:	b54d                	j	80005f2a <consoleintr+0x3a>

000000008000608a <consoleinit>:

void
consoleinit(void)
{
    8000608a:	1141                	addi	sp,sp,-16
    8000608c:	e406                	sd	ra,8(sp)
    8000608e:	e022                	sd	s0,0(sp)
    80006090:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006092:	00002597          	auipc	a1,0x2
    80006096:	5de58593          	addi	a1,a1,1502 # 80008670 <etext+0x670>
    8000609a:	00022517          	auipc	a0,0x22
    8000609e:	2c650513          	addi	a0,a0,710 # 80028360 <cons>
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	5c2080e7          	jalr	1474(ra) # 80006664 <initlock>

  uartinit();
    800060aa:	00000097          	auipc	ra,0x0
    800060ae:	354080e7          	jalr	852(ra) # 800063fe <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800060b2:	00015797          	auipc	a5,0x15
    800060b6:	01678793          	addi	a5,a5,22 # 8001b0c8 <devsw>
    800060ba:	00000717          	auipc	a4,0x0
    800060be:	cd470713          	addi	a4,a4,-812 # 80005d8e <consoleread>
    800060c2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800060c4:	00000717          	auipc	a4,0x0
    800060c8:	c5c70713          	addi	a4,a4,-932 # 80005d20 <consolewrite>
    800060cc:	ef98                	sd	a4,24(a5)
}
    800060ce:	60a2                	ld	ra,8(sp)
    800060d0:	6402                	ld	s0,0(sp)
    800060d2:	0141                	addi	sp,sp,16
    800060d4:	8082                	ret

00000000800060d6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800060d6:	7179                	addi	sp,sp,-48
    800060d8:	f406                	sd	ra,40(sp)
    800060da:	f022                	sd	s0,32(sp)
    800060dc:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800060de:	c219                	beqz	a2,800060e4 <printint+0xe>
    800060e0:	08054963          	bltz	a0,80006172 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800060e4:	2501                	sext.w	a0,a0
    800060e6:	4881                	li	a7,0
    800060e8:	fd040693          	addi	a3,s0,-48

  i = 0;
    800060ec:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800060ee:	2581                	sext.w	a1,a1
    800060f0:	00002617          	auipc	a2,0x2
    800060f4:	6f060613          	addi	a2,a2,1776 # 800087e0 <digits>
    800060f8:	883a                	mv	a6,a4
    800060fa:	2705                	addiw	a4,a4,1
    800060fc:	02b577bb          	remuw	a5,a0,a1
    80006100:	1782                	slli	a5,a5,0x20
    80006102:	9381                	srli	a5,a5,0x20
    80006104:	97b2                	add	a5,a5,a2
    80006106:	0007c783          	lbu	a5,0(a5)
    8000610a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000610e:	0005079b          	sext.w	a5,a0
    80006112:	02b5553b          	divuw	a0,a0,a1
    80006116:	0685                	addi	a3,a3,1
    80006118:	feb7f0e3          	bgeu	a5,a1,800060f8 <printint+0x22>

  if(sign)
    8000611c:	00088c63          	beqz	a7,80006134 <printint+0x5e>
    buf[i++] = '-';
    80006120:	fe070793          	addi	a5,a4,-32
    80006124:	00878733          	add	a4,a5,s0
    80006128:	02d00793          	li	a5,45
    8000612c:	fef70823          	sb	a5,-16(a4)
    80006130:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006134:	02e05b63          	blez	a4,8000616a <printint+0x94>
    80006138:	ec26                	sd	s1,24(sp)
    8000613a:	e84a                	sd	s2,16(sp)
    8000613c:	fd040793          	addi	a5,s0,-48
    80006140:	00e784b3          	add	s1,a5,a4
    80006144:	fff78913          	addi	s2,a5,-1
    80006148:	993a                	add	s2,s2,a4
    8000614a:	377d                	addiw	a4,a4,-1
    8000614c:	1702                	slli	a4,a4,0x20
    8000614e:	9301                	srli	a4,a4,0x20
    80006150:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006154:	fff4c503          	lbu	a0,-1(s1)
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	d56080e7          	jalr	-682(ra) # 80005eae <consputc>
  while(--i >= 0)
    80006160:	14fd                	addi	s1,s1,-1
    80006162:	ff2499e3          	bne	s1,s2,80006154 <printint+0x7e>
    80006166:	64e2                	ld	s1,24(sp)
    80006168:	6942                	ld	s2,16(sp)
}
    8000616a:	70a2                	ld	ra,40(sp)
    8000616c:	7402                	ld	s0,32(sp)
    8000616e:	6145                	addi	sp,sp,48
    80006170:	8082                	ret
    x = -xx;
    80006172:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006176:	4885                	li	a7,1
    x = -xx;
    80006178:	bf85                	j	800060e8 <printint+0x12>

000000008000617a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000617a:	1101                	addi	sp,sp,-32
    8000617c:	ec06                	sd	ra,24(sp)
    8000617e:	e822                	sd	s0,16(sp)
    80006180:	e426                	sd	s1,8(sp)
    80006182:	1000                	addi	s0,sp,32
    80006184:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006186:	00022797          	auipc	a5,0x22
    8000618a:	2807ad23          	sw	zero,666(a5) # 80028420 <pr+0x18>
  printf("panic: ");
    8000618e:	00002517          	auipc	a0,0x2
    80006192:	4ea50513          	addi	a0,a0,1258 # 80008678 <etext+0x678>
    80006196:	00000097          	auipc	ra,0x0
    8000619a:	02e080e7          	jalr	46(ra) # 800061c4 <printf>
  printf(s);
    8000619e:	8526                	mv	a0,s1
    800061a0:	00000097          	auipc	ra,0x0
    800061a4:	024080e7          	jalr	36(ra) # 800061c4 <printf>
  printf("\n");
    800061a8:	00002517          	auipc	a0,0x2
    800061ac:	e7050513          	addi	a0,a0,-400 # 80008018 <etext+0x18>
    800061b0:	00000097          	auipc	ra,0x0
    800061b4:	014080e7          	jalr	20(ra) # 800061c4 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800061b8:	4785                	li	a5,1
    800061ba:	00003717          	auipc	a4,0x3
    800061be:	e6f72123          	sw	a5,-414(a4) # 8000901c <panicked>
  for(;;)
    800061c2:	a001                	j	800061c2 <panic+0x48>

00000000800061c4 <printf>:
{
    800061c4:	7131                	addi	sp,sp,-192
    800061c6:	fc86                	sd	ra,120(sp)
    800061c8:	f8a2                	sd	s0,112(sp)
    800061ca:	e8d2                	sd	s4,80(sp)
    800061cc:	f06a                	sd	s10,32(sp)
    800061ce:	0100                	addi	s0,sp,128
    800061d0:	8a2a                	mv	s4,a0
    800061d2:	e40c                	sd	a1,8(s0)
    800061d4:	e810                	sd	a2,16(s0)
    800061d6:	ec14                	sd	a3,24(s0)
    800061d8:	f018                	sd	a4,32(s0)
    800061da:	f41c                	sd	a5,40(s0)
    800061dc:	03043823          	sd	a6,48(s0)
    800061e0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800061e4:	00022d17          	auipc	s10,0x22
    800061e8:	23cd2d03          	lw	s10,572(s10) # 80028420 <pr+0x18>
  if(locking)
    800061ec:	040d1463          	bnez	s10,80006234 <printf+0x70>
  if (fmt == 0)
    800061f0:	040a0b63          	beqz	s4,80006246 <printf+0x82>
  va_start(ap, fmt);
    800061f4:	00840793          	addi	a5,s0,8
    800061f8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061fc:	000a4503          	lbu	a0,0(s4)
    80006200:	18050b63          	beqz	a0,80006396 <printf+0x1d2>
    80006204:	f4a6                	sd	s1,104(sp)
    80006206:	f0ca                	sd	s2,96(sp)
    80006208:	ecce                	sd	s3,88(sp)
    8000620a:	e4d6                	sd	s5,72(sp)
    8000620c:	e0da                	sd	s6,64(sp)
    8000620e:	fc5e                	sd	s7,56(sp)
    80006210:	f862                	sd	s8,48(sp)
    80006212:	f466                	sd	s9,40(sp)
    80006214:	ec6e                	sd	s11,24(sp)
    80006216:	4981                	li	s3,0
    if(c != '%'){
    80006218:	02500b13          	li	s6,37
    switch(c){
    8000621c:	07000b93          	li	s7,112
  consputc('x');
    80006220:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006222:	00002a97          	auipc	s5,0x2
    80006226:	5bea8a93          	addi	s5,s5,1470 # 800087e0 <digits>
    switch(c){
    8000622a:	07300c13          	li	s8,115
    8000622e:	06400d93          	li	s11,100
    80006232:	a0b1                	j	8000627e <printf+0xba>
    acquire(&pr.lock);
    80006234:	00022517          	auipc	a0,0x22
    80006238:	1d450513          	addi	a0,a0,468 # 80028408 <pr>
    8000623c:	00000097          	auipc	ra,0x0
    80006240:	4b8080e7          	jalr	1208(ra) # 800066f4 <acquire>
    80006244:	b775                	j	800061f0 <printf+0x2c>
    80006246:	f4a6                	sd	s1,104(sp)
    80006248:	f0ca                	sd	s2,96(sp)
    8000624a:	ecce                	sd	s3,88(sp)
    8000624c:	e4d6                	sd	s5,72(sp)
    8000624e:	e0da                	sd	s6,64(sp)
    80006250:	fc5e                	sd	s7,56(sp)
    80006252:	f862                	sd	s8,48(sp)
    80006254:	f466                	sd	s9,40(sp)
    80006256:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80006258:	00002517          	auipc	a0,0x2
    8000625c:	43050513          	addi	a0,a0,1072 # 80008688 <etext+0x688>
    80006260:	00000097          	auipc	ra,0x0
    80006264:	f1a080e7          	jalr	-230(ra) # 8000617a <panic>
      consputc(c);
    80006268:	00000097          	auipc	ra,0x0
    8000626c:	c46080e7          	jalr	-954(ra) # 80005eae <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006270:	2985                	addiw	s3,s3,1
    80006272:	013a07b3          	add	a5,s4,s3
    80006276:	0007c503          	lbu	a0,0(a5)
    8000627a:	10050563          	beqz	a0,80006384 <printf+0x1c0>
    if(c != '%'){
    8000627e:	ff6515e3          	bne	a0,s6,80006268 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80006282:	2985                	addiw	s3,s3,1
    80006284:	013a07b3          	add	a5,s4,s3
    80006288:	0007c783          	lbu	a5,0(a5)
    8000628c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006290:	10078b63          	beqz	a5,800063a6 <printf+0x1e2>
    switch(c){
    80006294:	05778a63          	beq	a5,s7,800062e8 <printf+0x124>
    80006298:	02fbf663          	bgeu	s7,a5,800062c4 <printf+0x100>
    8000629c:	09878863          	beq	a5,s8,8000632c <printf+0x168>
    800062a0:	07800713          	li	a4,120
    800062a4:	0ce79563          	bne	a5,a4,8000636e <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    800062a8:	f8843783          	ld	a5,-120(s0)
    800062ac:	00878713          	addi	a4,a5,8
    800062b0:	f8e43423          	sd	a4,-120(s0)
    800062b4:	4605                	li	a2,1
    800062b6:	85e6                	mv	a1,s9
    800062b8:	4388                	lw	a0,0(a5)
    800062ba:	00000097          	auipc	ra,0x0
    800062be:	e1c080e7          	jalr	-484(ra) # 800060d6 <printint>
      break;
    800062c2:	b77d                	j	80006270 <printf+0xac>
    switch(c){
    800062c4:	09678f63          	beq	a5,s6,80006362 <printf+0x19e>
    800062c8:	0bb79363          	bne	a5,s11,8000636e <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800062cc:	f8843783          	ld	a5,-120(s0)
    800062d0:	00878713          	addi	a4,a5,8
    800062d4:	f8e43423          	sd	a4,-120(s0)
    800062d8:	4605                	li	a2,1
    800062da:	45a9                	li	a1,10
    800062dc:	4388                	lw	a0,0(a5)
    800062de:	00000097          	auipc	ra,0x0
    800062e2:	df8080e7          	jalr	-520(ra) # 800060d6 <printint>
      break;
    800062e6:	b769                	j	80006270 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800062e8:	f8843783          	ld	a5,-120(s0)
    800062ec:	00878713          	addi	a4,a5,8
    800062f0:	f8e43423          	sd	a4,-120(s0)
    800062f4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800062f8:	03000513          	li	a0,48
    800062fc:	00000097          	auipc	ra,0x0
    80006300:	bb2080e7          	jalr	-1102(ra) # 80005eae <consputc>
  consputc('x');
    80006304:	07800513          	li	a0,120
    80006308:	00000097          	auipc	ra,0x0
    8000630c:	ba6080e7          	jalr	-1114(ra) # 80005eae <consputc>
    80006310:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006312:	03c95793          	srli	a5,s2,0x3c
    80006316:	97d6                	add	a5,a5,s5
    80006318:	0007c503          	lbu	a0,0(a5)
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	b92080e7          	jalr	-1134(ra) # 80005eae <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006324:	0912                	slli	s2,s2,0x4
    80006326:	34fd                	addiw	s1,s1,-1
    80006328:	f4ed                	bnez	s1,80006312 <printf+0x14e>
    8000632a:	b799                	j	80006270 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000632c:	f8843783          	ld	a5,-120(s0)
    80006330:	00878713          	addi	a4,a5,8
    80006334:	f8e43423          	sd	a4,-120(s0)
    80006338:	6384                	ld	s1,0(a5)
    8000633a:	cc89                	beqz	s1,80006354 <printf+0x190>
      for(; *s; s++)
    8000633c:	0004c503          	lbu	a0,0(s1)
    80006340:	d905                	beqz	a0,80006270 <printf+0xac>
        consputc(*s);
    80006342:	00000097          	auipc	ra,0x0
    80006346:	b6c080e7          	jalr	-1172(ra) # 80005eae <consputc>
      for(; *s; s++)
    8000634a:	0485                	addi	s1,s1,1
    8000634c:	0004c503          	lbu	a0,0(s1)
    80006350:	f96d                	bnez	a0,80006342 <printf+0x17e>
    80006352:	bf39                	j	80006270 <printf+0xac>
        s = "(null)";
    80006354:	00002497          	auipc	s1,0x2
    80006358:	32c48493          	addi	s1,s1,812 # 80008680 <etext+0x680>
      for(; *s; s++)
    8000635c:	02800513          	li	a0,40
    80006360:	b7cd                	j	80006342 <printf+0x17e>
      consputc('%');
    80006362:	855a                	mv	a0,s6
    80006364:	00000097          	auipc	ra,0x0
    80006368:	b4a080e7          	jalr	-1206(ra) # 80005eae <consputc>
      break;
    8000636c:	b711                	j	80006270 <printf+0xac>
      consputc('%');
    8000636e:	855a                	mv	a0,s6
    80006370:	00000097          	auipc	ra,0x0
    80006374:	b3e080e7          	jalr	-1218(ra) # 80005eae <consputc>
      consputc(c);
    80006378:	8526                	mv	a0,s1
    8000637a:	00000097          	auipc	ra,0x0
    8000637e:	b34080e7          	jalr	-1228(ra) # 80005eae <consputc>
      break;
    80006382:	b5fd                	j	80006270 <printf+0xac>
    80006384:	74a6                	ld	s1,104(sp)
    80006386:	7906                	ld	s2,96(sp)
    80006388:	69e6                	ld	s3,88(sp)
    8000638a:	6aa6                	ld	s5,72(sp)
    8000638c:	6b06                	ld	s6,64(sp)
    8000638e:	7be2                	ld	s7,56(sp)
    80006390:	7c42                	ld	s8,48(sp)
    80006392:	7ca2                	ld	s9,40(sp)
    80006394:	6de2                	ld	s11,24(sp)
  if(locking)
    80006396:	020d1263          	bnez	s10,800063ba <printf+0x1f6>
}
    8000639a:	70e6                	ld	ra,120(sp)
    8000639c:	7446                	ld	s0,112(sp)
    8000639e:	6a46                	ld	s4,80(sp)
    800063a0:	7d02                	ld	s10,32(sp)
    800063a2:	6129                	addi	sp,sp,192
    800063a4:	8082                	ret
    800063a6:	74a6                	ld	s1,104(sp)
    800063a8:	7906                	ld	s2,96(sp)
    800063aa:	69e6                	ld	s3,88(sp)
    800063ac:	6aa6                	ld	s5,72(sp)
    800063ae:	6b06                	ld	s6,64(sp)
    800063b0:	7be2                	ld	s7,56(sp)
    800063b2:	7c42                	ld	s8,48(sp)
    800063b4:	7ca2                	ld	s9,40(sp)
    800063b6:	6de2                	ld	s11,24(sp)
    800063b8:	bff9                	j	80006396 <printf+0x1d2>
    release(&pr.lock);
    800063ba:	00022517          	auipc	a0,0x22
    800063be:	04e50513          	addi	a0,a0,78 # 80028408 <pr>
    800063c2:	00000097          	auipc	ra,0x0
    800063c6:	3e6080e7          	jalr	998(ra) # 800067a8 <release>
}
    800063ca:	bfc1                	j	8000639a <printf+0x1d6>

00000000800063cc <printfinit>:
    ;
}

void
printfinit(void)
{
    800063cc:	1101                	addi	sp,sp,-32
    800063ce:	ec06                	sd	ra,24(sp)
    800063d0:	e822                	sd	s0,16(sp)
    800063d2:	e426                	sd	s1,8(sp)
    800063d4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800063d6:	00022497          	auipc	s1,0x22
    800063da:	03248493          	addi	s1,s1,50 # 80028408 <pr>
    800063de:	00002597          	auipc	a1,0x2
    800063e2:	2ba58593          	addi	a1,a1,698 # 80008698 <etext+0x698>
    800063e6:	8526                	mv	a0,s1
    800063e8:	00000097          	auipc	ra,0x0
    800063ec:	27c080e7          	jalr	636(ra) # 80006664 <initlock>
  pr.locking = 1;
    800063f0:	4785                	li	a5,1
    800063f2:	cc9c                	sw	a5,24(s1)
}
    800063f4:	60e2                	ld	ra,24(sp)
    800063f6:	6442                	ld	s0,16(sp)
    800063f8:	64a2                	ld	s1,8(sp)
    800063fa:	6105                	addi	sp,sp,32
    800063fc:	8082                	ret

00000000800063fe <uartinit>:

void uartstart();

void
uartinit(void)
{
    800063fe:	1141                	addi	sp,sp,-16
    80006400:	e406                	sd	ra,8(sp)
    80006402:	e022                	sd	s0,0(sp)
    80006404:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006406:	100007b7          	lui	a5,0x10000
    8000640a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000640e:	10000737          	lui	a4,0x10000
    80006412:	f8000693          	li	a3,-128
    80006416:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000641a:	468d                	li	a3,3
    8000641c:	10000637          	lui	a2,0x10000
    80006420:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006424:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006428:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000642c:	10000737          	lui	a4,0x10000
    80006430:	461d                	li	a2,7
    80006432:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006436:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000643a:	00002597          	auipc	a1,0x2
    8000643e:	26658593          	addi	a1,a1,614 # 800086a0 <etext+0x6a0>
    80006442:	00022517          	auipc	a0,0x22
    80006446:	fe650513          	addi	a0,a0,-26 # 80028428 <uart_tx_lock>
    8000644a:	00000097          	auipc	ra,0x0
    8000644e:	21a080e7          	jalr	538(ra) # 80006664 <initlock>
}
    80006452:	60a2                	ld	ra,8(sp)
    80006454:	6402                	ld	s0,0(sp)
    80006456:	0141                	addi	sp,sp,16
    80006458:	8082                	ret

000000008000645a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000645a:	1101                	addi	sp,sp,-32
    8000645c:	ec06                	sd	ra,24(sp)
    8000645e:	e822                	sd	s0,16(sp)
    80006460:	e426                	sd	s1,8(sp)
    80006462:	1000                	addi	s0,sp,32
    80006464:	84aa                	mv	s1,a0
  push_off();
    80006466:	00000097          	auipc	ra,0x0
    8000646a:	242080e7          	jalr	578(ra) # 800066a8 <push_off>

  if(panicked){
    8000646e:	00003797          	auipc	a5,0x3
    80006472:	bae7a783          	lw	a5,-1106(a5) # 8000901c <panicked>
    80006476:	eb85                	bnez	a5,800064a6 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006478:	10000737          	lui	a4,0x10000
    8000647c:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000647e:	00074783          	lbu	a5,0(a4)
    80006482:	0207f793          	andi	a5,a5,32
    80006486:	dfe5                	beqz	a5,8000647e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006488:	0ff4f513          	zext.b	a0,s1
    8000648c:	100007b7          	lui	a5,0x10000
    80006490:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006494:	00000097          	auipc	ra,0x0
    80006498:	2b4080e7          	jalr	692(ra) # 80006748 <pop_off>
}
    8000649c:	60e2                	ld	ra,24(sp)
    8000649e:	6442                	ld	s0,16(sp)
    800064a0:	64a2                	ld	s1,8(sp)
    800064a2:	6105                	addi	sp,sp,32
    800064a4:	8082                	ret
    for(;;)
    800064a6:	a001                	j	800064a6 <uartputc_sync+0x4c>

00000000800064a8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800064a8:	00003797          	auipc	a5,0x3
    800064ac:	b787b783          	ld	a5,-1160(a5) # 80009020 <uart_tx_r>
    800064b0:	00003717          	auipc	a4,0x3
    800064b4:	b7873703          	ld	a4,-1160(a4) # 80009028 <uart_tx_w>
    800064b8:	06f70f63          	beq	a4,a5,80006536 <uartstart+0x8e>
{
    800064bc:	7139                	addi	sp,sp,-64
    800064be:	fc06                	sd	ra,56(sp)
    800064c0:	f822                	sd	s0,48(sp)
    800064c2:	f426                	sd	s1,40(sp)
    800064c4:	f04a                	sd	s2,32(sp)
    800064c6:	ec4e                	sd	s3,24(sp)
    800064c8:	e852                	sd	s4,16(sp)
    800064ca:	e456                	sd	s5,8(sp)
    800064cc:	e05a                	sd	s6,0(sp)
    800064ce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800064d0:	10000937          	lui	s2,0x10000
    800064d4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800064d6:	00022a97          	auipc	s5,0x22
    800064da:	f52a8a93          	addi	s5,s5,-174 # 80028428 <uart_tx_lock>
    uart_tx_r += 1;
    800064de:	00003497          	auipc	s1,0x3
    800064e2:	b4248493          	addi	s1,s1,-1214 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800064e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800064ea:	00003997          	auipc	s3,0x3
    800064ee:	b3e98993          	addi	s3,s3,-1218 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800064f2:	00094703          	lbu	a4,0(s2)
    800064f6:	02077713          	andi	a4,a4,32
    800064fa:	c705                	beqz	a4,80006522 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800064fc:	01f7f713          	andi	a4,a5,31
    80006500:	9756                	add	a4,a4,s5
    80006502:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006506:	0785                	addi	a5,a5,1
    80006508:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000650a:	8526                	mv	a0,s1
    8000650c:	ffffb097          	auipc	ra,0xffffb
    80006510:	1ea080e7          	jalr	490(ra) # 800016f6 <wakeup>
    WriteReg(THR, c);
    80006514:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006518:	609c                	ld	a5,0(s1)
    8000651a:	0009b703          	ld	a4,0(s3)
    8000651e:	fcf71ae3          	bne	a4,a5,800064f2 <uartstart+0x4a>
  }
}
    80006522:	70e2                	ld	ra,56(sp)
    80006524:	7442                	ld	s0,48(sp)
    80006526:	74a2                	ld	s1,40(sp)
    80006528:	7902                	ld	s2,32(sp)
    8000652a:	69e2                	ld	s3,24(sp)
    8000652c:	6a42                	ld	s4,16(sp)
    8000652e:	6aa2                	ld	s5,8(sp)
    80006530:	6b02                	ld	s6,0(sp)
    80006532:	6121                	addi	sp,sp,64
    80006534:	8082                	ret
    80006536:	8082                	ret

0000000080006538 <uartputc>:
{
    80006538:	7179                	addi	sp,sp,-48
    8000653a:	f406                	sd	ra,40(sp)
    8000653c:	f022                	sd	s0,32(sp)
    8000653e:	e052                	sd	s4,0(sp)
    80006540:	1800                	addi	s0,sp,48
    80006542:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006544:	00022517          	auipc	a0,0x22
    80006548:	ee450513          	addi	a0,a0,-284 # 80028428 <uart_tx_lock>
    8000654c:	00000097          	auipc	ra,0x0
    80006550:	1a8080e7          	jalr	424(ra) # 800066f4 <acquire>
  if(panicked){
    80006554:	00003797          	auipc	a5,0x3
    80006558:	ac87a783          	lw	a5,-1336(a5) # 8000901c <panicked>
    8000655c:	c391                	beqz	a5,80006560 <uartputc+0x28>
    for(;;)
    8000655e:	a001                	j	8000655e <uartputc+0x26>
    80006560:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006562:	00003717          	auipc	a4,0x3
    80006566:	ac673703          	ld	a4,-1338(a4) # 80009028 <uart_tx_w>
    8000656a:	00003797          	auipc	a5,0x3
    8000656e:	ab67b783          	ld	a5,-1354(a5) # 80009020 <uart_tx_r>
    80006572:	02078793          	addi	a5,a5,32
    80006576:	02e79f63          	bne	a5,a4,800065b4 <uartputc+0x7c>
    8000657a:	e84a                	sd	s2,16(sp)
    8000657c:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    8000657e:	00022997          	auipc	s3,0x22
    80006582:	eaa98993          	addi	s3,s3,-342 # 80028428 <uart_tx_lock>
    80006586:	00003497          	auipc	s1,0x3
    8000658a:	a9a48493          	addi	s1,s1,-1382 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000658e:	00003917          	auipc	s2,0x3
    80006592:	a9a90913          	addi	s2,s2,-1382 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006596:	85ce                	mv	a1,s3
    80006598:	8526                	mv	a0,s1
    8000659a:	ffffb097          	auipc	ra,0xffffb
    8000659e:	fd0080e7          	jalr	-48(ra) # 8000156a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065a2:	00093703          	ld	a4,0(s2)
    800065a6:	609c                	ld	a5,0(s1)
    800065a8:	02078793          	addi	a5,a5,32
    800065ac:	fee785e3          	beq	a5,a4,80006596 <uartputc+0x5e>
    800065b0:	6942                	ld	s2,16(sp)
    800065b2:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800065b4:	00022497          	auipc	s1,0x22
    800065b8:	e7448493          	addi	s1,s1,-396 # 80028428 <uart_tx_lock>
    800065bc:	01f77793          	andi	a5,a4,31
    800065c0:	97a6                	add	a5,a5,s1
    800065c2:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800065c6:	0705                	addi	a4,a4,1
    800065c8:	00003797          	auipc	a5,0x3
    800065cc:	a6e7b023          	sd	a4,-1440(a5) # 80009028 <uart_tx_w>
      uartstart();
    800065d0:	00000097          	auipc	ra,0x0
    800065d4:	ed8080e7          	jalr	-296(ra) # 800064a8 <uartstart>
      release(&uart_tx_lock);
    800065d8:	8526                	mv	a0,s1
    800065da:	00000097          	auipc	ra,0x0
    800065de:	1ce080e7          	jalr	462(ra) # 800067a8 <release>
    800065e2:	64e2                	ld	s1,24(sp)
}
    800065e4:	70a2                	ld	ra,40(sp)
    800065e6:	7402                	ld	s0,32(sp)
    800065e8:	6a02                	ld	s4,0(sp)
    800065ea:	6145                	addi	sp,sp,48
    800065ec:	8082                	ret

00000000800065ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800065ee:	1141                	addi	sp,sp,-16
    800065f0:	e422                	sd	s0,8(sp)
    800065f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800065f4:	100007b7          	lui	a5,0x10000
    800065f8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800065fa:	0007c783          	lbu	a5,0(a5)
    800065fe:	8b85                	andi	a5,a5,1
    80006600:	cb81                	beqz	a5,80006610 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006602:	100007b7          	lui	a5,0x10000
    80006606:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000660a:	6422                	ld	s0,8(sp)
    8000660c:	0141                	addi	sp,sp,16
    8000660e:	8082                	ret
    return -1;
    80006610:	557d                	li	a0,-1
    80006612:	bfe5                	j	8000660a <uartgetc+0x1c>

0000000080006614 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006614:	1101                	addi	sp,sp,-32
    80006616:	ec06                	sd	ra,24(sp)
    80006618:	e822                	sd	s0,16(sp)
    8000661a:	e426                	sd	s1,8(sp)
    8000661c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000661e:	54fd                	li	s1,-1
    80006620:	a029                	j	8000662a <uartintr+0x16>
      break;
    consoleintr(c);
    80006622:	00000097          	auipc	ra,0x0
    80006626:	8ce080e7          	jalr	-1842(ra) # 80005ef0 <consoleintr>
    int c = uartgetc();
    8000662a:	00000097          	auipc	ra,0x0
    8000662e:	fc4080e7          	jalr	-60(ra) # 800065ee <uartgetc>
    if(c == -1)
    80006632:	fe9518e3          	bne	a0,s1,80006622 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006636:	00022497          	auipc	s1,0x22
    8000663a:	df248493          	addi	s1,s1,-526 # 80028428 <uart_tx_lock>
    8000663e:	8526                	mv	a0,s1
    80006640:	00000097          	auipc	ra,0x0
    80006644:	0b4080e7          	jalr	180(ra) # 800066f4 <acquire>
  uartstart();
    80006648:	00000097          	auipc	ra,0x0
    8000664c:	e60080e7          	jalr	-416(ra) # 800064a8 <uartstart>
  release(&uart_tx_lock);
    80006650:	8526                	mv	a0,s1
    80006652:	00000097          	auipc	ra,0x0
    80006656:	156080e7          	jalr	342(ra) # 800067a8 <release>
}
    8000665a:	60e2                	ld	ra,24(sp)
    8000665c:	6442                	ld	s0,16(sp)
    8000665e:	64a2                	ld	s1,8(sp)
    80006660:	6105                	addi	sp,sp,32
    80006662:	8082                	ret

0000000080006664 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006664:	1141                	addi	sp,sp,-16
    80006666:	e422                	sd	s0,8(sp)
    80006668:	0800                	addi	s0,sp,16
  lk->name = name;
    8000666a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000666c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006670:	00053823          	sd	zero,16(a0)
}
    80006674:	6422                	ld	s0,8(sp)
    80006676:	0141                	addi	sp,sp,16
    80006678:	8082                	ret

000000008000667a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000667a:	411c                	lw	a5,0(a0)
    8000667c:	e399                	bnez	a5,80006682 <holding+0x8>
    8000667e:	4501                	li	a0,0
  return r;
}
    80006680:	8082                	ret
{
    80006682:	1101                	addi	sp,sp,-32
    80006684:	ec06                	sd	ra,24(sp)
    80006686:	e822                	sd	s0,16(sp)
    80006688:	e426                	sd	s1,8(sp)
    8000668a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000668c:	6904                	ld	s1,16(a0)
    8000668e:	ffffa097          	auipc	ra,0xffffa
    80006692:	7c0080e7          	jalr	1984(ra) # 80000e4e <mycpu>
    80006696:	40a48533          	sub	a0,s1,a0
    8000669a:	00153513          	seqz	a0,a0
}
    8000669e:	60e2                	ld	ra,24(sp)
    800066a0:	6442                	ld	s0,16(sp)
    800066a2:	64a2                	ld	s1,8(sp)
    800066a4:	6105                	addi	sp,sp,32
    800066a6:	8082                	ret

00000000800066a8 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800066a8:	1101                	addi	sp,sp,-32
    800066aa:	ec06                	sd	ra,24(sp)
    800066ac:	e822                	sd	s0,16(sp)
    800066ae:	e426                	sd	s1,8(sp)
    800066b0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066b2:	100024f3          	csrr	s1,sstatus
    800066b6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800066ba:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066bc:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800066c0:	ffffa097          	auipc	ra,0xffffa
    800066c4:	78e080e7          	jalr	1934(ra) # 80000e4e <mycpu>
    800066c8:	5d3c                	lw	a5,120(a0)
    800066ca:	cf89                	beqz	a5,800066e4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800066cc:	ffffa097          	auipc	ra,0xffffa
    800066d0:	782080e7          	jalr	1922(ra) # 80000e4e <mycpu>
    800066d4:	5d3c                	lw	a5,120(a0)
    800066d6:	2785                	addiw	a5,a5,1
    800066d8:	dd3c                	sw	a5,120(a0)
}
    800066da:	60e2                	ld	ra,24(sp)
    800066dc:	6442                	ld	s0,16(sp)
    800066de:	64a2                	ld	s1,8(sp)
    800066e0:	6105                	addi	sp,sp,32
    800066e2:	8082                	ret
    mycpu()->intena = old;
    800066e4:	ffffa097          	auipc	ra,0xffffa
    800066e8:	76a080e7          	jalr	1898(ra) # 80000e4e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800066ec:	8085                	srli	s1,s1,0x1
    800066ee:	8885                	andi	s1,s1,1
    800066f0:	dd64                	sw	s1,124(a0)
    800066f2:	bfe9                	j	800066cc <push_off+0x24>

00000000800066f4 <acquire>:
{
    800066f4:	1101                	addi	sp,sp,-32
    800066f6:	ec06                	sd	ra,24(sp)
    800066f8:	e822                	sd	s0,16(sp)
    800066fa:	e426                	sd	s1,8(sp)
    800066fc:	1000                	addi	s0,sp,32
    800066fe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006700:	00000097          	auipc	ra,0x0
    80006704:	fa8080e7          	jalr	-88(ra) # 800066a8 <push_off>
  if(holding(lk))
    80006708:	8526                	mv	a0,s1
    8000670a:	00000097          	auipc	ra,0x0
    8000670e:	f70080e7          	jalr	-144(ra) # 8000667a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006712:	4705                	li	a4,1
  if(holding(lk))
    80006714:	e115                	bnez	a0,80006738 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006716:	87ba                	mv	a5,a4
    80006718:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000671c:	2781                	sext.w	a5,a5
    8000671e:	ffe5                	bnez	a5,80006716 <acquire+0x22>
  __sync_synchronize();
    80006720:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006724:	ffffa097          	auipc	ra,0xffffa
    80006728:	72a080e7          	jalr	1834(ra) # 80000e4e <mycpu>
    8000672c:	e888                	sd	a0,16(s1)
}
    8000672e:	60e2                	ld	ra,24(sp)
    80006730:	6442                	ld	s0,16(sp)
    80006732:	64a2                	ld	s1,8(sp)
    80006734:	6105                	addi	sp,sp,32
    80006736:	8082                	ret
    panic("acquire");
    80006738:	00002517          	auipc	a0,0x2
    8000673c:	f7050513          	addi	a0,a0,-144 # 800086a8 <etext+0x6a8>
    80006740:	00000097          	auipc	ra,0x0
    80006744:	a3a080e7          	jalr	-1478(ra) # 8000617a <panic>

0000000080006748 <pop_off>:

void
pop_off(void)
{
    80006748:	1141                	addi	sp,sp,-16
    8000674a:	e406                	sd	ra,8(sp)
    8000674c:	e022                	sd	s0,0(sp)
    8000674e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006750:	ffffa097          	auipc	ra,0xffffa
    80006754:	6fe080e7          	jalr	1790(ra) # 80000e4e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006758:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000675c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000675e:	e78d                	bnez	a5,80006788 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006760:	5d3c                	lw	a5,120(a0)
    80006762:	02f05b63          	blez	a5,80006798 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006766:	37fd                	addiw	a5,a5,-1
    80006768:	0007871b          	sext.w	a4,a5
    8000676c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000676e:	eb09                	bnez	a4,80006780 <pop_off+0x38>
    80006770:	5d7c                	lw	a5,124(a0)
    80006772:	c799                	beqz	a5,80006780 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006774:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006778:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000677c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006780:	60a2                	ld	ra,8(sp)
    80006782:	6402                	ld	s0,0(sp)
    80006784:	0141                	addi	sp,sp,16
    80006786:	8082                	ret
    panic("pop_off - interruptible");
    80006788:	00002517          	auipc	a0,0x2
    8000678c:	f2850513          	addi	a0,a0,-216 # 800086b0 <etext+0x6b0>
    80006790:	00000097          	auipc	ra,0x0
    80006794:	9ea080e7          	jalr	-1558(ra) # 8000617a <panic>
    panic("pop_off");
    80006798:	00002517          	auipc	a0,0x2
    8000679c:	f3050513          	addi	a0,a0,-208 # 800086c8 <etext+0x6c8>
    800067a0:	00000097          	auipc	ra,0x0
    800067a4:	9da080e7          	jalr	-1574(ra) # 8000617a <panic>

00000000800067a8 <release>:
{
    800067a8:	1101                	addi	sp,sp,-32
    800067aa:	ec06                	sd	ra,24(sp)
    800067ac:	e822                	sd	s0,16(sp)
    800067ae:	e426                	sd	s1,8(sp)
    800067b0:	1000                	addi	s0,sp,32
    800067b2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800067b4:	00000097          	auipc	ra,0x0
    800067b8:	ec6080e7          	jalr	-314(ra) # 8000667a <holding>
    800067bc:	c115                	beqz	a0,800067e0 <release+0x38>
  lk->cpu = 0;
    800067be:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800067c2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800067c6:	0f50000f          	fence	iorw,ow
    800067ca:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800067ce:	00000097          	auipc	ra,0x0
    800067d2:	f7a080e7          	jalr	-134(ra) # 80006748 <pop_off>
}
    800067d6:	60e2                	ld	ra,24(sp)
    800067d8:	6442                	ld	s0,16(sp)
    800067da:	64a2                	ld	s1,8(sp)
    800067dc:	6105                	addi	sp,sp,32
    800067de:	8082                	ret
    panic("release");
    800067e0:	00002517          	auipc	a0,0x2
    800067e4:	ef050513          	addi	a0,a0,-272 # 800086d0 <etext+0x6d0>
    800067e8:	00000097          	auipc	ra,0x0
    800067ec:	992080e7          	jalr	-1646(ra) # 8000617a <panic>
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
