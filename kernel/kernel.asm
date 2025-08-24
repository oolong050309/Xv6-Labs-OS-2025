
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	14010113          	addi	sp,sp,320 # 8001e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	209050ef          	jal	80005a1e <start>

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
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
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
    8000005e:	40c080e7          	jalr	1036(ra) # 80006466 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	4ac080e7          	jalr	1196(ra) # 8000651a <release>
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
    8000008e:	e62080e7          	jalr	-414(ra) # 80005eec <panic>

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
    800000fa:	2e0080e7          	jalr	736(ra) # 800063d6 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
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
    80000132:	338080e7          	jalr	824(ra) # 80006466 <acquire>
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
    8000014a:	3d4080e7          	jalr	980(ra) # 8000651a <release>

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
    80000174:	3aa080e7          	jalr	938(ra) # 8000651a <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
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
    80000324:	cc8080e7          	jalr	-824(ra) # 80000fe8 <cpuid>
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
    80000340:	cac080e7          	jalr	-852(ra) # 80000fe8 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	be8080e7          	jalr	-1048(ra) # 80005f36 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	9c2080e7          	jalr	-1598(ra) # 80001d20 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	06e080e7          	jalr	110(ra) # 800053d4 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	26e080e7          	jalr	622(ra) # 800015dc <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	a86080e7          	jalr	-1402(ra) # 80005dfc <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	dc0080e7          	jalr	-576(ra) # 8000613e <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	ba8080e7          	jalr	-1112(ra) # 80005f36 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	b98080e7          	jalr	-1128(ra) # 80005f36 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	b88080e7          	jalr	-1144(ra) # 80005f36 <printf>
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
    800003d2:	b5e080e7          	jalr	-1186(ra) # 80000f2c <procinit>
    trapinit();      // trap vectors
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	922080e7          	jalr	-1758(ra) # 80001cf8 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	942080e7          	jalr	-1726(ra) # 80001d20 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	fd4080e7          	jalr	-44(ra) # 800053ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	fe6080e7          	jalr	-26(ra) # 800053d4 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	0ec080e7          	jalr	236(ra) # 800024e2 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	778080e7          	jalr	1912(ra) # 80002b76 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	71c080e7          	jalr	1820(ra) # 80003b22 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	0e6080e7          	jalr	230(ra) # 800054f4 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	f8a080e7          	jalr	-118(ra) # 800013a0 <userinit>
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
    80000484:	a6c080e7          	jalr	-1428(ra) # 80005eec <panic>
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
    800004b2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
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
    800005aa:	946080e7          	jalr	-1722(ra) # 80005eec <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	936080e7          	jalr	-1738(ra) # 80005eec <panic>
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
    80000606:	8ea080e7          	jalr	-1814(ra) # 80005eec <panic>

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
    800006ce:	7c0080e7          	jalr	1984(ra) # 80000e8a <proc_mapstacks>
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
    8000074c:	7a4080e7          	jalr	1956(ra) # 80005eec <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	794080e7          	jalr	1940(ra) # 80005eec <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	784080e7          	jalr	1924(ra) # 80005eec <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	774080e7          	jalr	1908(ra) # 80005eec <panic>
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
    80000870:	680080e7          	jalr	1664(ra) # 80005eec <panic>

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
    800009bc:	534080e7          	jalr	1332(ra) # 80005eec <panic>
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
    80000a9a:	456080e7          	jalr	1110(ra) # 80005eec <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	446080e7          	jalr	1094(ra) # 80005eec <panic>
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
    80000b14:	3dc080e7          	jalr	988(ra) # 80005eec <panic>

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
    80000cc2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
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

0000000080000cee <printwalk>:

void 
printwalk(pagetable_t pagetable, uint level) {
    80000cee:	715d                	addi	sp,sp,-80
    80000cf0:	e486                	sd	ra,72(sp)
    80000cf2:	e0a2                	sd	s0,64(sp)
    80000cf4:	fc26                	sd	s1,56(sp)
    80000cf6:	f84a                	sd	s2,48(sp)
    80000cf8:	f44e                	sd	s3,40(sp)
    80000cfa:	f052                	sd	s4,32(sp)
    80000cfc:	ec56                	sd	s5,24(sp)
    80000cfe:	e85a                	sd	s6,16(sp)
    80000d00:	e45e                	sd	s7,8(sp)
    80000d02:	e062                	sd	s8,0(sp)
    80000d04:	0880                	addi	s0,sp,80
    80000d06:	89aa                	mv	s3,a0
    80000d08:	8bae                	mv	s7,a1
  char* prefix;
  if (level == 2) prefix = "..";
    80000d0a:	4789                	li	a5,2
    80000d0c:	00007b17          	auipc	s6,0x7
    80000d10:	44cb0b13          	addi	s6,s6,1100 # 80008158 <etext+0x158>
    80000d14:	00f58963          	beq	a1,a5,80000d26 <printwalk+0x38>
  else if (level == 1) prefix = ".. ..";
    80000d18:	4785                	li	a5,1
  else prefix = ".. .. ..";
    80000d1a:	00007b17          	auipc	s6,0x7
    80000d1e:	44eb0b13          	addi	s6,s6,1102 # 80008168 <etext+0x168>
  else if (level == 1) prefix = ".. ..";
    80000d22:	00f58a63          	beq	a1,a5,80000d36 <printwalk+0x48>
  for(int i = 0; i < 512; i++){ // 每个页表有512项
    80000d26:	4901                	li	s2,0
    pte_t pte = pagetable[i];
    if(pte & PTE_V){ // 该页表项有效
      uint64 pa = PTE2PA(pte); // 将虚拟地址转换为物理地址
      printf("%s%d: pte %p pa %p\n", prefix, i, pte, pa);
    80000d28:	00007c17          	auipc	s8,0x7
    80000d2c:	450c0c13          	addi	s8,s8,1104 # 80008178 <etext+0x178>
  for(int i = 0; i < 512; i++){ // 每个页表有512项
    80000d30:	20000a93          	li	s5,512
    80000d34:	a811                	j	80000d48 <printwalk+0x5a>
  else if (level == 1) prefix = ".. ..";
    80000d36:	00007b17          	auipc	s6,0x7
    80000d3a:	42ab0b13          	addi	s6,s6,1066 # 80008160 <etext+0x160>
    80000d3e:	b7e5                	j	80000d26 <printwalk+0x38>
  for(int i = 0; i < 512; i++){ // 每个页表有512项
    80000d40:	2905                	addiw	s2,s2,1
    80000d42:	09a1                	addi	s3,s3,8 # 1008 <_entry-0x7fffeff8>
    80000d44:	03590d63          	beq	s2,s5,80000d7e <printwalk+0x90>
    pte_t pte = pagetable[i];
    80000d48:	0009b483          	ld	s1,0(s3)
    if(pte & PTE_V){ // 该页表项有效
    80000d4c:	0014f793          	andi	a5,s1,1
    80000d50:	dbe5                	beqz	a5,80000d40 <printwalk+0x52>
      uint64 pa = PTE2PA(pte); // 将虚拟地址转换为物理地址
    80000d52:	00a4da13          	srli	s4,s1,0xa
    80000d56:	0a32                	slli	s4,s4,0xc
      printf("%s%d: pte %p pa %p\n", prefix, i, pte, pa);
    80000d58:	8752                	mv	a4,s4
    80000d5a:	86a6                	mv	a3,s1
    80000d5c:	864a                	mv	a2,s2
    80000d5e:	85da                	mv	a1,s6
    80000d60:	8562                	mv	a0,s8
    80000d62:	00005097          	auipc	ra,0x5
    80000d66:	1d4080e7          	jalr	468(ra) # 80005f36 <printf>
      if((pte & (PTE_R|PTE_W|PTE_X)) == 0){ // 有下一级页表
    80000d6a:	88b9                	andi	s1,s1,14
    80000d6c:	f8f1                	bnez	s1,80000d40 <printwalk+0x52>
         printwalk((pagetable_t)pa, level - 1);
    80000d6e:	fffb859b          	addiw	a1,s7,-1 # fff <_entry-0x7ffff001>
    80000d72:	8552                	mv	a0,s4
    80000d74:	00000097          	auipc	ra,0x0
    80000d78:	f7a080e7          	jalr	-134(ra) # 80000cee <printwalk>
    80000d7c:	b7d1                	j	80000d40 <printwalk+0x52>
      }
    }
  }
}
    80000d7e:	60a6                	ld	ra,72(sp)
    80000d80:	6406                	ld	s0,64(sp)
    80000d82:	74e2                	ld	s1,56(sp)
    80000d84:	7942                	ld	s2,48(sp)
    80000d86:	79a2                	ld	s3,40(sp)
    80000d88:	7a02                	ld	s4,32(sp)
    80000d8a:	6ae2                	ld	s5,24(sp)
    80000d8c:	6b42                	ld	s6,16(sp)
    80000d8e:	6ba2                	ld	s7,8(sp)
    80000d90:	6c02                	ld	s8,0(sp)
    80000d92:	6161                	addi	sp,sp,80
    80000d94:	8082                	ret

0000000080000d96 <vmprint>:
 
 //遍历页表并打印
void
vmprint(pagetable_t pagetable) {
    80000d96:	1101                	addi	sp,sp,-32
    80000d98:	ec06                	sd	ra,24(sp)
    80000d9a:	e822                	sd	s0,16(sp)
    80000d9c:	e426                	sd	s1,8(sp)
    80000d9e:	1000                	addi	s0,sp,32
    80000da0:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    80000da2:	85aa                	mv	a1,a0
    80000da4:	00007517          	auipc	a0,0x7
    80000da8:	3ec50513          	addi	a0,a0,1004 # 80008190 <etext+0x190>
    80000dac:	00005097          	auipc	ra,0x5
    80000db0:	18a080e7          	jalr	394(ra) # 80005f36 <printf>
  printwalk(pagetable, 2);
    80000db4:	4589                	li	a1,2
    80000db6:	8526                	mv	a0,s1
    80000db8:	00000097          	auipc	ra,0x0
    80000dbc:	f36080e7          	jalr	-202(ra) # 80000cee <printwalk>
}
    80000dc0:	60e2                	ld	ra,24(sp)
    80000dc2:	6442                	ld	s0,16(sp)
    80000dc4:	64a2                	ld	s1,8(sp)
    80000dc6:	6105                	addi	sp,sp,32
    80000dc8:	8082                	ret

0000000080000dca <pgaccess>:


int pgaccess(pagetable_t pagetable, uint64 start_va, int page_num, uint64 result_va) {
    80000dca:	711d                	addi	sp,sp,-96
    80000dcc:	ec86                	sd	ra,88(sp)
    80000dce:	e8a2                	sd	s0,80(sp)
    80000dd0:	1080                	addi	s0,sp,96
  if (page_num > 64) {
    80000dd2:	04000793          	li	a5,64
    80000dd6:	02c7c563          	blt	a5,a2,80000e00 <pgaccess+0x36>
    80000dda:	e0ca                	sd	s2,64(sp)
    80000ddc:	fc4e                	sd	s3,56(sp)
    80000dde:	f852                	sd	s4,48(sp)
    80000de0:	ec5e                	sd	s7,24(sp)
    80000de2:	8a2a                	mv	s4,a0
    80000de4:	892e                	mv	s2,a1
    80000de6:	89b2                	mv	s3,a2
    80000de8:	8bb6                	mv	s7,a3
    panic("pgaccess: too many pages");
    return -1;
  }

  uint64 va = start_va;
  unsigned int bitmask = 0;
    80000dea:	fa042623          	sw	zero,-84(s0)

  for (int count = 0; count < page_num; ++count, va += PGSIZE) {
    80000dee:	06c05663          	blez	a2,80000e5a <pgaccess+0x90>
    80000df2:	e4a6                	sd	s1,72(sp)
    80000df4:	f456                	sd	s5,40(sp)
    80000df6:	f05a                	sd	s6,32(sp)
    80000df8:	4481                	li	s1,0
    if (pte == 0) {
      return -1; // 页表项不存在，直接返回错误
    }

    if ((*pte & PTE_A)) {
      bitmask |= (1 << count);
    80000dfa:	4b05                	li	s6,1
  for (int count = 0; count < page_num; ++count, va += PGSIZE) {
    80000dfc:	6a85                	lui	s5,0x1
    80000dfe:	a025                	j	80000e26 <pgaccess+0x5c>
    80000e00:	e4a6                	sd	s1,72(sp)
    80000e02:	e0ca                	sd	s2,64(sp)
    80000e04:	fc4e                	sd	s3,56(sp)
    80000e06:	f852                	sd	s4,48(sp)
    80000e08:	f456                	sd	s5,40(sp)
    80000e0a:	f05a                	sd	s6,32(sp)
    80000e0c:	ec5e                	sd	s7,24(sp)
    panic("pgaccess: too many pages");
    80000e0e:	00007517          	auipc	a0,0x7
    80000e12:	39250513          	addi	a0,a0,914 # 800081a0 <etext+0x1a0>
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	0d6080e7          	jalr	214(ra) # 80005eec <panic>
  for (int count = 0; count < page_num; ++count, va += PGSIZE) {
    80000e1e:	2485                	addiw	s1,s1,1
    80000e20:	9956                	add	s2,s2,s5
    80000e22:	02998963          	beq	s3,s1,80000e54 <pgaccess+0x8a>
    pte_t *pte = walk(pagetable, va, 0);
    80000e26:	4601                	li	a2,0
    80000e28:	85ca                	mv	a1,s2
    80000e2a:	8552                	mv	a0,s4
    80000e2c:	fffff097          	auipc	ra,0xfffff
    80000e30:	626080e7          	jalr	1574(ra) # 80000452 <walk>
    if (pte == 0) {
    80000e34:	c531                	beqz	a0,80000e80 <pgaccess+0xb6>
    if ((*pte & PTE_A)) {
    80000e36:	611c                	ld	a5,0(a0)
    80000e38:	0407f713          	andi	a4,a5,64
    80000e3c:	d36d                	beqz	a4,80000e1e <pgaccess+0x54>
      bitmask |= (1 << count);
    80000e3e:	009b16bb          	sllw	a3,s6,s1
    80000e42:	fac42703          	lw	a4,-84(s0)
    80000e46:	8f55                	or	a4,a4,a3
    80000e48:	fae42623          	sw	a4,-84(s0)
      *pte &= ~PTE_A; // 清除访问位
    80000e4c:	fbf7f793          	andi	a5,a5,-65
    80000e50:	e11c                	sd	a5,0(a0)
    80000e52:	b7f1                	j	80000e1e <pgaccess+0x54>
    80000e54:	64a6                	ld	s1,72(sp)
    80000e56:	7aa2                	ld	s5,40(sp)
    80000e58:	7b02                	ld	s6,32(sp)
    }
  }

  if (copyout(pagetable, result_va, (char*)&bitmask, sizeof(bitmask)) < 0) {
    80000e5a:	4691                	li	a3,4
    80000e5c:	fac40613          	addi	a2,s0,-84
    80000e60:	85de                	mv	a1,s7
    80000e62:	8552                	mv	a0,s4
    80000e64:	00000097          	auipc	ra,0x0
    80000e68:	cb4080e7          	jalr	-844(ra) # 80000b18 <copyout>
    80000e6c:	41f5551b          	sraiw	a0,a0,0x1f
    return -1; // 拷贝失败，返回错误
  }

  return 0;
}
    80000e70:	6906                	ld	s2,64(sp)
    80000e72:	79e2                	ld	s3,56(sp)
    80000e74:	7a42                	ld	s4,48(sp)
    80000e76:	6be2                	ld	s7,24(sp)
    80000e78:	60e6                	ld	ra,88(sp)
    80000e7a:	6446                	ld	s0,80(sp)
    80000e7c:	6125                	addi	sp,sp,96
    80000e7e:	8082                	ret
      return -1; // 页表项不存在，直接返回错误
    80000e80:	557d                	li	a0,-1
    80000e82:	64a6                	ld	s1,72(sp)
    80000e84:	7aa2                	ld	s5,40(sp)
    80000e86:	7b02                	ld	s6,32(sp)
    80000e88:	b7e5                	j	80000e70 <pgaccess+0xa6>

0000000080000e8a <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e8a:	7139                	addi	sp,sp,-64
    80000e8c:	fc06                	sd	ra,56(sp)
    80000e8e:	f822                	sd	s0,48(sp)
    80000e90:	f426                	sd	s1,40(sp)
    80000e92:	f04a                	sd	s2,32(sp)
    80000e94:	ec4e                	sd	s3,24(sp)
    80000e96:	e852                	sd	s4,16(sp)
    80000e98:	e456                	sd	s5,8(sp)
    80000e9a:	e05a                	sd	s6,0(sp)
    80000e9c:	0080                	addi	s0,sp,64
    80000e9e:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea0:	00008497          	auipc	s1,0x8
    80000ea4:	5e048493          	addi	s1,s1,1504 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ea8:	8b26                	mv	s6,s1
    80000eaa:	ff4df937          	lui	s2,0xff4df
    80000eae:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000eb2:	0936                	slli	s2,s2,0xd
    80000eb4:	6f590913          	addi	s2,s2,1781
    80000eb8:	0936                	slli	s2,s2,0xd
    80000eba:	bd390913          	addi	s2,s2,-1069
    80000ebe:	0932                	slli	s2,s2,0xc
    80000ec0:	7a790913          	addi	s2,s2,1959
    80000ec4:	010009b7          	lui	s3,0x1000
    80000ec8:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000eca:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ecc:	0000ea97          	auipc	s5,0xe
    80000ed0:	1b4a8a93          	addi	s5,s5,436 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000ed4:	fffff097          	auipc	ra,0xfffff
    80000ed8:	246080e7          	jalr	582(ra) # 8000011a <kalloc>
    80000edc:	862a                	mv	a2,a0
    if(pa == 0)
    80000ede:	cd1d                	beqz	a0,80000f1c <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000ee0:	416485b3          	sub	a1,s1,s6
    80000ee4:	8591                	srai	a1,a1,0x4
    80000ee6:	032585b3          	mul	a1,a1,s2
    80000eea:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000eee:	4719                	li	a4,6
    80000ef0:	6685                	lui	a3,0x1
    80000ef2:	40b985b3          	sub	a1,s3,a1
    80000ef6:	8552                	mv	a0,s4
    80000ef8:	fffff097          	auipc	ra,0xfffff
    80000efc:	6e2080e7          	jalr	1762(ra) # 800005da <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f00:	17048493          	addi	s1,s1,368
    80000f04:	fd5498e3          	bne	s1,s5,80000ed4 <proc_mapstacks+0x4a>
  }
}
    80000f08:	70e2                	ld	ra,56(sp)
    80000f0a:	7442                	ld	s0,48(sp)
    80000f0c:	74a2                	ld	s1,40(sp)
    80000f0e:	7902                	ld	s2,32(sp)
    80000f10:	69e2                	ld	s3,24(sp)
    80000f12:	6a42                	ld	s4,16(sp)
    80000f14:	6aa2                	ld	s5,8(sp)
    80000f16:	6b02                	ld	s6,0(sp)
    80000f18:	6121                	addi	sp,sp,64
    80000f1a:	8082                	ret
      panic("kalloc");
    80000f1c:	00007517          	auipc	a0,0x7
    80000f20:	2a450513          	addi	a0,a0,676 # 800081c0 <etext+0x1c0>
    80000f24:	00005097          	auipc	ra,0x5
    80000f28:	fc8080e7          	jalr	-56(ra) # 80005eec <panic>

0000000080000f2c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f2c:	7139                	addi	sp,sp,-64
    80000f2e:	fc06                	sd	ra,56(sp)
    80000f30:	f822                	sd	s0,48(sp)
    80000f32:	f426                	sd	s1,40(sp)
    80000f34:	f04a                	sd	s2,32(sp)
    80000f36:	ec4e                	sd	s3,24(sp)
    80000f38:	e852                	sd	s4,16(sp)
    80000f3a:	e456                	sd	s5,8(sp)
    80000f3c:	e05a                	sd	s6,0(sp)
    80000f3e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f40:	00007597          	auipc	a1,0x7
    80000f44:	28858593          	addi	a1,a1,648 # 800081c8 <etext+0x1c8>
    80000f48:	00008517          	auipc	a0,0x8
    80000f4c:	10850513          	addi	a0,a0,264 # 80009050 <pid_lock>
    80000f50:	00005097          	auipc	ra,0x5
    80000f54:	486080e7          	jalr	1158(ra) # 800063d6 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f58:	00007597          	auipc	a1,0x7
    80000f5c:	27858593          	addi	a1,a1,632 # 800081d0 <etext+0x1d0>
    80000f60:	00008517          	auipc	a0,0x8
    80000f64:	10850513          	addi	a0,a0,264 # 80009068 <wait_lock>
    80000f68:	00005097          	auipc	ra,0x5
    80000f6c:	46e080e7          	jalr	1134(ra) # 800063d6 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f70:	00008497          	auipc	s1,0x8
    80000f74:	51048493          	addi	s1,s1,1296 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000f78:	00007b17          	auipc	s6,0x7
    80000f7c:	268b0b13          	addi	s6,s6,616 # 800081e0 <etext+0x1e0>
      p->kstack = KSTACK((int) (p - proc));
    80000f80:	8aa6                	mv	s5,s1
    80000f82:	ff4df937          	lui	s2,0xff4df
    80000f86:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000f8a:	0936                	slli	s2,s2,0xd
    80000f8c:	6f590913          	addi	s2,s2,1781
    80000f90:	0936                	slli	s2,s2,0xd
    80000f92:	bd390913          	addi	s2,s2,-1069
    80000f96:	0932                	slli	s2,s2,0xc
    80000f98:	7a790913          	addi	s2,s2,1959
    80000f9c:	010009b7          	lui	s3,0x1000
    80000fa0:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000fa2:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fa4:	0000ea17          	auipc	s4,0xe
    80000fa8:	0dca0a13          	addi	s4,s4,220 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000fac:	85da                	mv	a1,s6
    80000fae:	8526                	mv	a0,s1
    80000fb0:	00005097          	auipc	ra,0x5
    80000fb4:	426080e7          	jalr	1062(ra) # 800063d6 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000fb8:	415487b3          	sub	a5,s1,s5
    80000fbc:	8791                	srai	a5,a5,0x4
    80000fbe:	032787b3          	mul	a5,a5,s2
    80000fc2:	00d7979b          	slliw	a5,a5,0xd
    80000fc6:	40f987b3          	sub	a5,s3,a5
    80000fca:	e8bc                	sd	a5,80(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fcc:	17048493          	addi	s1,s1,368
    80000fd0:	fd449ee3          	bne	s1,s4,80000fac <procinit+0x80>
  }
}
    80000fd4:	70e2                	ld	ra,56(sp)
    80000fd6:	7442                	ld	s0,48(sp)
    80000fd8:	74a2                	ld	s1,40(sp)
    80000fda:	7902                	ld	s2,32(sp)
    80000fdc:	69e2                	ld	s3,24(sp)
    80000fde:	6a42                	ld	s4,16(sp)
    80000fe0:	6aa2                	ld	s5,8(sp)
    80000fe2:	6b02                	ld	s6,0(sp)
    80000fe4:	6121                	addi	sp,sp,64
    80000fe6:	8082                	ret

0000000080000fe8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fe8:	1141                	addi	sp,sp,-16
    80000fea:	e422                	sd	s0,8(sp)
    80000fec:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fee:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ff0:	2501                	sext.w	a0,a0
    80000ff2:	6422                	ld	s0,8(sp)
    80000ff4:	0141                	addi	sp,sp,16
    80000ff6:	8082                	ret

0000000080000ff8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000ff8:	1141                	addi	sp,sp,-16
    80000ffa:	e422                	sd	s0,8(sp)
    80000ffc:	0800                	addi	s0,sp,16
    80000ffe:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001000:	2781                	sext.w	a5,a5
    80001002:	079e                	slli	a5,a5,0x7
  return c;
}
    80001004:	00008517          	auipc	a0,0x8
    80001008:	07c50513          	addi	a0,a0,124 # 80009080 <cpus>
    8000100c:	953e                	add	a0,a0,a5
    8000100e:	6422                	ld	s0,8(sp)
    80001010:	0141                	addi	sp,sp,16
    80001012:	8082                	ret

0000000080001014 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001014:	1101                	addi	sp,sp,-32
    80001016:	ec06                	sd	ra,24(sp)
    80001018:	e822                	sd	s0,16(sp)
    8000101a:	e426                	sd	s1,8(sp)
    8000101c:	1000                	addi	s0,sp,32
  push_off();
    8000101e:	00005097          	auipc	ra,0x5
    80001022:	3fc080e7          	jalr	1020(ra) # 8000641a <push_off>
    80001026:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001028:	2781                	sext.w	a5,a5
    8000102a:	079e                	slli	a5,a5,0x7
    8000102c:	00008717          	auipc	a4,0x8
    80001030:	02470713          	addi	a4,a4,36 # 80009050 <pid_lock>
    80001034:	97ba                	add	a5,a5,a4
    80001036:	7b84                	ld	s1,48(a5)
  pop_off();
    80001038:	00005097          	auipc	ra,0x5
    8000103c:	482080e7          	jalr	1154(ra) # 800064ba <pop_off>
  return p;
}
    80001040:	8526                	mv	a0,s1
    80001042:	60e2                	ld	ra,24(sp)
    80001044:	6442                	ld	s0,16(sp)
    80001046:	64a2                	ld	s1,8(sp)
    80001048:	6105                	addi	sp,sp,32
    8000104a:	8082                	ret

000000008000104c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000104c:	1141                	addi	sp,sp,-16
    8000104e:	e406                	sd	ra,8(sp)
    80001050:	e022                	sd	s0,0(sp)
    80001052:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001054:	00000097          	auipc	ra,0x0
    80001058:	fc0080e7          	jalr	-64(ra) # 80001014 <myproc>
    8000105c:	00005097          	auipc	ra,0x5
    80001060:	4be080e7          	jalr	1214(ra) # 8000651a <release>

  if (first) {
    80001064:	00008797          	auipc	a5,0x8
    80001068:	85c7a783          	lw	a5,-1956(a5) # 800088c0 <first.1>
    8000106c:	eb89                	bnez	a5,8000107e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    8000106e:	00001097          	auipc	ra,0x1
    80001072:	cca080e7          	jalr	-822(ra) # 80001d38 <usertrapret>
}
    80001076:	60a2                	ld	ra,8(sp)
    80001078:	6402                	ld	s0,0(sp)
    8000107a:	0141                	addi	sp,sp,16
    8000107c:	8082                	ret
    first = 0;
    8000107e:	00008797          	auipc	a5,0x8
    80001082:	8407a123          	sw	zero,-1982(a5) # 800088c0 <first.1>
    fsinit(ROOTDEV);
    80001086:	4505                	li	a0,1
    80001088:	00002097          	auipc	ra,0x2
    8000108c:	a6e080e7          	jalr	-1426(ra) # 80002af6 <fsinit>
    80001090:	bff9                	j	8000106e <forkret+0x22>

0000000080001092 <allocpid>:
allocpid() {
    80001092:	1101                	addi	sp,sp,-32
    80001094:	ec06                	sd	ra,24(sp)
    80001096:	e822                	sd	s0,16(sp)
    80001098:	e426                	sd	s1,8(sp)
    8000109a:	e04a                	sd	s2,0(sp)
    8000109c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000109e:	00008917          	auipc	s2,0x8
    800010a2:	fb290913          	addi	s2,s2,-78 # 80009050 <pid_lock>
    800010a6:	854a                	mv	a0,s2
    800010a8:	00005097          	auipc	ra,0x5
    800010ac:	3be080e7          	jalr	958(ra) # 80006466 <acquire>
  pid = nextpid;
    800010b0:	00008797          	auipc	a5,0x8
    800010b4:	81478793          	addi	a5,a5,-2028 # 800088c4 <nextpid>
    800010b8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800010ba:	0014871b          	addiw	a4,s1,1
    800010be:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800010c0:	854a                	mv	a0,s2
    800010c2:	00005097          	auipc	ra,0x5
    800010c6:	458080e7          	jalr	1112(ra) # 8000651a <release>
}
    800010ca:	8526                	mv	a0,s1
    800010cc:	60e2                	ld	ra,24(sp)
    800010ce:	6442                	ld	s0,16(sp)
    800010d0:	64a2                	ld	s1,8(sp)
    800010d2:	6902                	ld	s2,0(sp)
    800010d4:	6105                	addi	sp,sp,32
    800010d6:	8082                	ret

00000000800010d8 <proc_pagetable>:
{
    800010d8:	1101                	addi	sp,sp,-32
    800010da:	ec06                	sd	ra,24(sp)
    800010dc:	e822                	sd	s0,16(sp)
    800010de:	e426                	sd	s1,8(sp)
    800010e0:	e04a                	sd	s2,0(sp)
    800010e2:	1000                	addi	s0,sp,32
    800010e4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010e6:	fffff097          	auipc	ra,0xfffff
    800010ea:	6ee080e7          	jalr	1774(ra) # 800007d4 <uvmcreate>
    800010ee:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010f0:	cd39                	beqz	a0,8000114e <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010f2:	4729                	li	a4,10
    800010f4:	00006697          	auipc	a3,0x6
    800010f8:	f0c68693          	addi	a3,a3,-244 # 80007000 <_trampoline>
    800010fc:	6605                	lui	a2,0x1
    800010fe:	040005b7          	lui	a1,0x4000
    80001102:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001104:	05b2                	slli	a1,a1,0xc
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	434080e7          	jalr	1076(ra) # 8000053a <mappages>
    8000110e:	04054763          	bltz	a0,8000115c <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001112:	4719                	li	a4,6
    80001114:	06893683          	ld	a3,104(s2)
    80001118:	6605                	lui	a2,0x1
    8000111a:	020005b7          	lui	a1,0x2000
    8000111e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001120:	05b6                	slli	a1,a1,0xd
    80001122:	8526                	mv	a0,s1
    80001124:	fffff097          	auipc	ra,0xfffff
    80001128:	416080e7          	jalr	1046(ra) # 8000053a <mappages>
    8000112c:	04054063          	bltz	a0,8000116c <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80001130:	4749                	li	a4,18
    80001132:	16893683          	ld	a3,360(s2)
    80001136:	6605                	lui	a2,0x1
    80001138:	040005b7          	lui	a1,0x4000
    8000113c:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000113e:	05b2                	slli	a1,a1,0xc
    80001140:	8526                	mv	a0,s1
    80001142:	fffff097          	auipc	ra,0xfffff
    80001146:	3f8080e7          	jalr	1016(ra) # 8000053a <mappages>
    8000114a:	04054463          	bltz	a0,80001192 <proc_pagetable+0xba>
}
    8000114e:	8526                	mv	a0,s1
    80001150:	60e2                	ld	ra,24(sp)
    80001152:	6442                	ld	s0,16(sp)
    80001154:	64a2                	ld	s1,8(sp)
    80001156:	6902                	ld	s2,0(sp)
    80001158:	6105                	addi	sp,sp,32
    8000115a:	8082                	ret
    uvmfree(pagetable, 0);
    8000115c:	4581                	li	a1,0
    8000115e:	8526                	mv	a0,s1
    80001160:	00000097          	auipc	ra,0x0
    80001164:	87a080e7          	jalr	-1926(ra) # 800009da <uvmfree>
    return 0;
    80001168:	4481                	li	s1,0
    8000116a:	b7d5                	j	8000114e <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000116c:	4681                	li	a3,0
    8000116e:	4605                	li	a2,1
    80001170:	040005b7          	lui	a1,0x4000
    80001174:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001176:	05b2                	slli	a1,a1,0xc
    80001178:	8526                	mv	a0,s1
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	586080e7          	jalr	1414(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    80001182:	4581                	li	a1,0
    80001184:	8526                	mv	a0,s1
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	854080e7          	jalr	-1964(ra) # 800009da <uvmfree>
    return 0;
    8000118e:	4481                	li	s1,0
    80001190:	bf7d                	j	8000114e <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001192:	4681                	li	a3,0
    80001194:	4605                	li	a2,1
    80001196:	040005b7          	lui	a1,0x4000
    8000119a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000119c:	05b2                	slli	a1,a1,0xc
    8000119e:	8526                	mv	a0,s1
    800011a0:	fffff097          	auipc	ra,0xfffff
    800011a4:	560080e7          	jalr	1376(ra) # 80000700 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011a8:	4681                	li	a3,0
    800011aa:	4605                	li	a2,1
    800011ac:	020005b7          	lui	a1,0x2000
    800011b0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011b2:	05b6                	slli	a1,a1,0xd
    800011b4:	8526                	mv	a0,s1
    800011b6:	fffff097          	auipc	ra,0xfffff
    800011ba:	54a080e7          	jalr	1354(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    800011be:	4581                	li	a1,0
    800011c0:	8526                	mv	a0,s1
    800011c2:	00000097          	auipc	ra,0x0
    800011c6:	818080e7          	jalr	-2024(ra) # 800009da <uvmfree>
    return 0;
    800011ca:	4481                	li	s1,0
    800011cc:	b749                	j	8000114e <proc_pagetable+0x76>

00000000800011ce <proc_freepagetable>:
{
    800011ce:	1101                	addi	sp,sp,-32
    800011d0:	ec06                	sd	ra,24(sp)
    800011d2:	e822                	sd	s0,16(sp)
    800011d4:	e426                	sd	s1,8(sp)
    800011d6:	e04a                	sd	s2,0(sp)
    800011d8:	1000                	addi	s0,sp,32
    800011da:	84aa                	mv	s1,a0
    800011dc:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011de:	4681                	li	a3,0
    800011e0:	4605                	li	a2,1
    800011e2:	040005b7          	lui	a1,0x4000
    800011e6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011e8:	05b2                	slli	a1,a1,0xc
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	516080e7          	jalr	1302(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011f2:	4681                	li	a3,0
    800011f4:	4605                	li	a2,1
    800011f6:	020005b7          	lui	a1,0x2000
    800011fa:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011fc:	05b6                	slli	a1,a1,0xd
    800011fe:	8526                	mv	a0,s1
    80001200:	fffff097          	auipc	ra,0xfffff
    80001204:	500080e7          	jalr	1280(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);//释放页表中共享内存页项
    80001208:	4681                	li	a3,0
    8000120a:	4605                	li	a2,1
    8000120c:	040005b7          	lui	a1,0x4000
    80001210:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001212:	05b2                	slli	a1,a1,0xc
    80001214:	8526                	mv	a0,s1
    80001216:	fffff097          	auipc	ra,0xfffff
    8000121a:	4ea080e7          	jalr	1258(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    8000121e:	85ca                	mv	a1,s2
    80001220:	8526                	mv	a0,s1
    80001222:	fffff097          	auipc	ra,0xfffff
    80001226:	7b8080e7          	jalr	1976(ra) # 800009da <uvmfree>
}
    8000122a:	60e2                	ld	ra,24(sp)
    8000122c:	6442                	ld	s0,16(sp)
    8000122e:	64a2                	ld	s1,8(sp)
    80001230:	6902                	ld	s2,0(sp)
    80001232:	6105                	addi	sp,sp,32
    80001234:	8082                	ret

0000000080001236 <freeproc>:
{
    80001236:	1101                	addi	sp,sp,-32
    80001238:	ec06                	sd	ra,24(sp)
    8000123a:	e822                	sd	s0,16(sp)
    8000123c:	e426                	sd	s1,8(sp)
    8000123e:	1000                	addi	s0,sp,32
    80001240:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001242:	7528                	ld	a0,104(a0)
    80001244:	c509                	beqz	a0,8000124e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001246:	fffff097          	auipc	ra,0xfffff
    8000124a:	dd6080e7          	jalr	-554(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000124e:	0604b423          	sd	zero,104(s1)
  if(p->usyscall)
    80001252:	1684b503          	ld	a0,360(s1)
    80001256:	c509                	beqz	a0,80001260 <freeproc+0x2a>
    kfree((void*)p->usyscall);//释放共享内存块
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	dc4080e7          	jalr	-572(ra) # 8000001c <kfree>
  if(p->pagetable)
    80001260:	70a8                	ld	a0,96(s1)
    80001262:	c511                	beqz	a0,8000126e <freeproc+0x38>
    proc_freepagetable(p->pagetable, p->sz);
    80001264:	6cac                	ld	a1,88(s1)
    80001266:	00000097          	auipc	ra,0x0
    8000126a:	f68080e7          	jalr	-152(ra) # 800011ce <proc_freepagetable>
  p->pagetable = 0;
    8000126e:	0604b023          	sd	zero,96(s1)
  p->sz = 0;
    80001272:	0404bc23          	sd	zero,88(s1)
  p->pid = 0;
    80001276:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000127a:	0404b423          	sd	zero,72(s1)
  p->name[0] = 0;
    8000127e:	02048a23          	sb	zero,52(s1)
  p->chan = 0;
    80001282:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001286:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000128a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000128e:	0004ac23          	sw	zero,24(s1)
}
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret

000000008000129c <allocproc>:
{
    8000129c:	1101                	addi	sp,sp,-32
    8000129e:	ec06                	sd	ra,24(sp)
    800012a0:	e822                	sd	s0,16(sp)
    800012a2:	e426                	sd	s1,8(sp)
    800012a4:	e04a                	sd	s2,0(sp)
    800012a6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800012a8:	00008497          	auipc	s1,0x8
    800012ac:	1d848493          	addi	s1,s1,472 # 80009480 <proc>
    800012b0:	0000e917          	auipc	s2,0xe
    800012b4:	dd090913          	addi	s2,s2,-560 # 8000f080 <tickslock>
    acquire(&p->lock);
    800012b8:	8526                	mv	a0,s1
    800012ba:	00005097          	auipc	ra,0x5
    800012be:	1ac080e7          	jalr	428(ra) # 80006466 <acquire>
    if(p->state == UNUSED) {
    800012c2:	4c9c                	lw	a5,24(s1)
    800012c4:	cf81                	beqz	a5,800012dc <allocproc+0x40>
      release(&p->lock);
    800012c6:	8526                	mv	a0,s1
    800012c8:	00005097          	auipc	ra,0x5
    800012cc:	252080e7          	jalr	594(ra) # 8000651a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012d0:	17048493          	addi	s1,s1,368
    800012d4:	ff2492e3          	bne	s1,s2,800012b8 <allocproc+0x1c>
  return 0;
    800012d8:	4481                	li	s1,0
    800012da:	a885                	j	8000134a <allocproc+0xae>
  p->pid = allocpid();
    800012dc:	00000097          	auipc	ra,0x0
    800012e0:	db6080e7          	jalr	-586(ra) # 80001092 <allocpid>
    800012e4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012e6:	4785                	li	a5,1
    800012e8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012ea:	fffff097          	auipc	ra,0xfffff
    800012ee:	e30080e7          	jalr	-464(ra) # 8000011a <kalloc>
    800012f2:	892a                	mv	s2,a0
    800012f4:	f4a8                	sd	a0,104(s1)
    800012f6:	c12d                	beqz	a0,80001358 <allocproc+0xbc>
  if((p->usyscall=(struct usyscall *)kalloc())==0){
    800012f8:	fffff097          	auipc	ra,0xfffff
    800012fc:	e22080e7          	jalr	-478(ra) # 8000011a <kalloc>
    80001300:	892a                	mv	s2,a0
    80001302:	16a4b423          	sd	a0,360(s1)
    80001306:	c52d                	beqz	a0,80001370 <allocproc+0xd4>
  memmove(p->usyscall,&p->pid,8);
    80001308:	4621                	li	a2,8
    8000130a:	03048593          	addi	a1,s1,48
    8000130e:	fffff097          	auipc	ra,0xfffff
    80001312:	ec8080e7          	jalr	-312(ra) # 800001d6 <memmove>
  p->pagetable = proc_pagetable(p);
    80001316:	8526                	mv	a0,s1
    80001318:	00000097          	auipc	ra,0x0
    8000131c:	dc0080e7          	jalr	-576(ra) # 800010d8 <proc_pagetable>
    80001320:	892a                	mv	s2,a0
    80001322:	f0a8                	sd	a0,96(s1)
  if(p->pagetable == 0){
    80001324:	c135                	beqz	a0,80001388 <allocproc+0xec>
  memset(&p->context, 0, sizeof(p->context));
    80001326:	07000613          	li	a2,112
    8000132a:	4581                	li	a1,0
    8000132c:	07048513          	addi	a0,s1,112
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	e4a080e7          	jalr	-438(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001338:	00000797          	auipc	a5,0x0
    8000133c:	d1478793          	addi	a5,a5,-748 # 8000104c <forkret>
    80001340:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001342:	68bc                	ld	a5,80(s1)
    80001344:	6705                	lui	a4,0x1
    80001346:	97ba                	add	a5,a5,a4
    80001348:	fcbc                	sd	a5,120(s1)
}
    8000134a:	8526                	mv	a0,s1
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6902                	ld	s2,0(sp)
    80001354:	6105                	addi	sp,sp,32
    80001356:	8082                	ret
    freeproc(p);
    80001358:	8526                	mv	a0,s1
    8000135a:	00000097          	auipc	ra,0x0
    8000135e:	edc080e7          	jalr	-292(ra) # 80001236 <freeproc>
    release(&p->lock);
    80001362:	8526                	mv	a0,s1
    80001364:	00005097          	auipc	ra,0x5
    80001368:	1b6080e7          	jalr	438(ra) # 8000651a <release>
    return 0;
    8000136c:	84ca                	mv	s1,s2
    8000136e:	bff1                	j	8000134a <allocproc+0xae>
    freeproc(p);
    80001370:	8526                	mv	a0,s1
    80001372:	00000097          	auipc	ra,0x0
    80001376:	ec4080e7          	jalr	-316(ra) # 80001236 <freeproc>
    release(&p->lock);
    8000137a:	8526                	mv	a0,s1
    8000137c:	00005097          	auipc	ra,0x5
    80001380:	19e080e7          	jalr	414(ra) # 8000651a <release>
    return 0;
    80001384:	84ca                	mv	s1,s2
    80001386:	b7d1                	j	8000134a <allocproc+0xae>
    freeproc(p);
    80001388:	8526                	mv	a0,s1
    8000138a:	00000097          	auipc	ra,0x0
    8000138e:	eac080e7          	jalr	-340(ra) # 80001236 <freeproc>
    release(&p->lock);
    80001392:	8526                	mv	a0,s1
    80001394:	00005097          	auipc	ra,0x5
    80001398:	186080e7          	jalr	390(ra) # 8000651a <release>
    return 0;
    8000139c:	84ca                	mv	s1,s2
    8000139e:	b775                	j	8000134a <allocproc+0xae>

00000000800013a0 <userinit>:
{
    800013a0:	1101                	addi	sp,sp,-32
    800013a2:	ec06                	sd	ra,24(sp)
    800013a4:	e822                	sd	s0,16(sp)
    800013a6:	e426                	sd	s1,8(sp)
    800013a8:	1000                	addi	s0,sp,32
  p = allocproc();
    800013aa:	00000097          	auipc	ra,0x0
    800013ae:	ef2080e7          	jalr	-270(ra) # 8000129c <allocproc>
    800013b2:	84aa                	mv	s1,a0
  initproc = p;
    800013b4:	00008797          	auipc	a5,0x8
    800013b8:	c4a7be23          	sd	a0,-932(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800013bc:	03400613          	li	a2,52
    800013c0:	00007597          	auipc	a1,0x7
    800013c4:	51058593          	addi	a1,a1,1296 # 800088d0 <initcode>
    800013c8:	7128                	ld	a0,96(a0)
    800013ca:	fffff097          	auipc	ra,0xfffff
    800013ce:	438080e7          	jalr	1080(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    800013d2:	6785                	lui	a5,0x1
    800013d4:	ecbc                	sd	a5,88(s1)
  p->trapframe->epc = 0;      // user program counter
    800013d6:	74b8                	ld	a4,104(s1)
    800013d8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800013dc:	74b8                	ld	a4,104(s1)
    800013de:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800013e0:	4641                	li	a2,16
    800013e2:	00007597          	auipc	a1,0x7
    800013e6:	e0658593          	addi	a1,a1,-506 # 800081e8 <etext+0x1e8>
    800013ea:	03448513          	addi	a0,s1,52
    800013ee:	fffff097          	auipc	ra,0xfffff
    800013f2:	ece080e7          	jalr	-306(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800013f6:	00007517          	auipc	a0,0x7
    800013fa:	e0250513          	addi	a0,a0,-510 # 800081f8 <etext+0x1f8>
    800013fe:	00002097          	auipc	ra,0x2
    80001402:	13e080e7          	jalr	318(ra) # 8000353c <namei>
    80001406:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    8000140a:	478d                	li	a5,3
    8000140c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000140e:	8526                	mv	a0,s1
    80001410:	00005097          	auipc	ra,0x5
    80001414:	10a080e7          	jalr	266(ra) # 8000651a <release>
}
    80001418:	60e2                	ld	ra,24(sp)
    8000141a:	6442                	ld	s0,16(sp)
    8000141c:	64a2                	ld	s1,8(sp)
    8000141e:	6105                	addi	sp,sp,32
    80001420:	8082                	ret

0000000080001422 <growproc>:
{
    80001422:	1101                	addi	sp,sp,-32
    80001424:	ec06                	sd	ra,24(sp)
    80001426:	e822                	sd	s0,16(sp)
    80001428:	e426                	sd	s1,8(sp)
    8000142a:	e04a                	sd	s2,0(sp)
    8000142c:	1000                	addi	s0,sp,32
    8000142e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001430:	00000097          	auipc	ra,0x0
    80001434:	be4080e7          	jalr	-1052(ra) # 80001014 <myproc>
    80001438:	892a                	mv	s2,a0
  sz = p->sz;
    8000143a:	6d2c                	ld	a1,88(a0)
    8000143c:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001440:	00904f63          	bgtz	s1,8000145e <growproc+0x3c>
  } else if(n < 0){
    80001444:	0204cd63          	bltz	s1,8000147e <growproc+0x5c>
  p->sz = sz;
    80001448:	1782                	slli	a5,a5,0x20
    8000144a:	9381                	srli	a5,a5,0x20
    8000144c:	04f93c23          	sd	a5,88(s2)
  return 0;
    80001450:	4501                	li	a0,0
}
    80001452:	60e2                	ld	ra,24(sp)
    80001454:	6442                	ld	s0,16(sp)
    80001456:	64a2                	ld	s1,8(sp)
    80001458:	6902                	ld	s2,0(sp)
    8000145a:	6105                	addi	sp,sp,32
    8000145c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000145e:	00f4863b          	addw	a2,s1,a5
    80001462:	1602                	slli	a2,a2,0x20
    80001464:	9201                	srli	a2,a2,0x20
    80001466:	1582                	slli	a1,a1,0x20
    80001468:	9181                	srli	a1,a1,0x20
    8000146a:	7128                	ld	a0,96(a0)
    8000146c:	fffff097          	auipc	ra,0xfffff
    80001470:	450080e7          	jalr	1104(ra) # 800008bc <uvmalloc>
    80001474:	0005079b          	sext.w	a5,a0
    80001478:	fbe1                	bnez	a5,80001448 <growproc+0x26>
      return -1;
    8000147a:	557d                	li	a0,-1
    8000147c:	bfd9                	j	80001452 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000147e:	00f4863b          	addw	a2,s1,a5
    80001482:	1602                	slli	a2,a2,0x20
    80001484:	9201                	srli	a2,a2,0x20
    80001486:	1582                	slli	a1,a1,0x20
    80001488:	9181                	srli	a1,a1,0x20
    8000148a:	7128                	ld	a0,96(a0)
    8000148c:	fffff097          	auipc	ra,0xfffff
    80001490:	3e8080e7          	jalr	1000(ra) # 80000874 <uvmdealloc>
    80001494:	0005079b          	sext.w	a5,a0
    80001498:	bf45                	j	80001448 <growproc+0x26>

000000008000149a <fork>:
{
    8000149a:	7139                	addi	sp,sp,-64
    8000149c:	fc06                	sd	ra,56(sp)
    8000149e:	f822                	sd	s0,48(sp)
    800014a0:	f04a                	sd	s2,32(sp)
    800014a2:	e456                	sd	s5,8(sp)
    800014a4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800014a6:	00000097          	auipc	ra,0x0
    800014aa:	b6e080e7          	jalr	-1170(ra) # 80001014 <myproc>
    800014ae:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	dec080e7          	jalr	-532(ra) # 8000129c <allocproc>
    800014b8:	12050063          	beqz	a0,800015d8 <fork+0x13e>
    800014bc:	e852                	sd	s4,16(sp)
    800014be:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800014c0:	058ab603          	ld	a2,88(s5)
    800014c4:	712c                	ld	a1,96(a0)
    800014c6:	060ab503          	ld	a0,96(s5)
    800014ca:	fffff097          	auipc	ra,0xfffff
    800014ce:	54a080e7          	jalr	1354(ra) # 80000a14 <uvmcopy>
    800014d2:	04054a63          	bltz	a0,80001526 <fork+0x8c>
    800014d6:	f426                	sd	s1,40(sp)
    800014d8:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800014da:	058ab783          	ld	a5,88(s5)
    800014de:	04fa3c23          	sd	a5,88(s4)
  *(np->trapframe) = *(p->trapframe);
    800014e2:	068ab683          	ld	a3,104(s5)
    800014e6:	87b6                	mv	a5,a3
    800014e8:	068a3703          	ld	a4,104(s4)
    800014ec:	12068693          	addi	a3,a3,288
    800014f0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800014f4:	6788                	ld	a0,8(a5)
    800014f6:	6b8c                	ld	a1,16(a5)
    800014f8:	6f90                	ld	a2,24(a5)
    800014fa:	01073023          	sd	a6,0(a4)
    800014fe:	e708                	sd	a0,8(a4)
    80001500:	eb0c                	sd	a1,16(a4)
    80001502:	ef10                	sd	a2,24(a4)
    80001504:	02078793          	addi	a5,a5,32
    80001508:	02070713          	addi	a4,a4,32
    8000150c:	fed792e3          	bne	a5,a3,800014f0 <fork+0x56>
  np->trapframe->a0 = 0;
    80001510:	068a3783          	ld	a5,104(s4)
    80001514:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001518:	0e0a8493          	addi	s1,s5,224
    8000151c:	0e0a0913          	addi	s2,s4,224
    80001520:	160a8993          	addi	s3,s5,352
    80001524:	a015                	j	80001548 <fork+0xae>
    freeproc(np);
    80001526:	8552                	mv	a0,s4
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	d0e080e7          	jalr	-754(ra) # 80001236 <freeproc>
    release(&np->lock);
    80001530:	8552                	mv	a0,s4
    80001532:	00005097          	auipc	ra,0x5
    80001536:	fe8080e7          	jalr	-24(ra) # 8000651a <release>
    return -1;
    8000153a:	597d                	li	s2,-1
    8000153c:	6a42                	ld	s4,16(sp)
    8000153e:	a071                	j	800015ca <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001540:	04a1                	addi	s1,s1,8
    80001542:	0921                	addi	s2,s2,8
    80001544:	01348b63          	beq	s1,s3,8000155a <fork+0xc0>
    if(p->ofile[i])
    80001548:	6088                	ld	a0,0(s1)
    8000154a:	d97d                	beqz	a0,80001540 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000154c:	00002097          	auipc	ra,0x2
    80001550:	668080e7          	jalr	1640(ra) # 80003bb4 <filedup>
    80001554:	00a93023          	sd	a0,0(s2)
    80001558:	b7e5                	j	80001540 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000155a:	160ab503          	ld	a0,352(s5)
    8000155e:	00001097          	auipc	ra,0x1
    80001562:	7ce080e7          	jalr	1998(ra) # 80002d2c <idup>
    80001566:	16aa3023          	sd	a0,352(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000156a:	4641                	li	a2,16
    8000156c:	034a8593          	addi	a1,s5,52
    80001570:	034a0513          	addi	a0,s4,52
    80001574:	fffff097          	auipc	ra,0xfffff
    80001578:	d48080e7          	jalr	-696(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    8000157c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001580:	8552                	mv	a0,s4
    80001582:	00005097          	auipc	ra,0x5
    80001586:	f98080e7          	jalr	-104(ra) # 8000651a <release>
  acquire(&wait_lock);
    8000158a:	00008497          	auipc	s1,0x8
    8000158e:	ade48493          	addi	s1,s1,-1314 # 80009068 <wait_lock>
    80001592:	8526                	mv	a0,s1
    80001594:	00005097          	auipc	ra,0x5
    80001598:	ed2080e7          	jalr	-302(ra) # 80006466 <acquire>
  np->parent = p;
    8000159c:	055a3423          	sd	s5,72(s4)
  release(&wait_lock);
    800015a0:	8526                	mv	a0,s1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	f78080e7          	jalr	-136(ra) # 8000651a <release>
  acquire(&np->lock);
    800015aa:	8552                	mv	a0,s4
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	eba080e7          	jalr	-326(ra) # 80006466 <acquire>
  np->state = RUNNABLE;
    800015b4:	478d                	li	a5,3
    800015b6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800015ba:	8552                	mv	a0,s4
    800015bc:	00005097          	auipc	ra,0x5
    800015c0:	f5e080e7          	jalr	-162(ra) # 8000651a <release>
  return pid;
    800015c4:	74a2                	ld	s1,40(sp)
    800015c6:	69e2                	ld	s3,24(sp)
    800015c8:	6a42                	ld	s4,16(sp)
}
    800015ca:	854a                	mv	a0,s2
    800015cc:	70e2                	ld	ra,56(sp)
    800015ce:	7442                	ld	s0,48(sp)
    800015d0:	7902                	ld	s2,32(sp)
    800015d2:	6aa2                	ld	s5,8(sp)
    800015d4:	6121                	addi	sp,sp,64
    800015d6:	8082                	ret
    return -1;
    800015d8:	597d                	li	s2,-1
    800015da:	bfc5                	j	800015ca <fork+0x130>

00000000800015dc <scheduler>:
{
    800015dc:	7139                	addi	sp,sp,-64
    800015de:	fc06                	sd	ra,56(sp)
    800015e0:	f822                	sd	s0,48(sp)
    800015e2:	f426                	sd	s1,40(sp)
    800015e4:	f04a                	sd	s2,32(sp)
    800015e6:	ec4e                	sd	s3,24(sp)
    800015e8:	e852                	sd	s4,16(sp)
    800015ea:	e456                	sd	s5,8(sp)
    800015ec:	e05a                	sd	s6,0(sp)
    800015ee:	0080                	addi	s0,sp,64
    800015f0:	8792                	mv	a5,tp
  int id = r_tp();
    800015f2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015f4:	00779a93          	slli	s5,a5,0x7
    800015f8:	00008717          	auipc	a4,0x8
    800015fc:	a5870713          	addi	a4,a4,-1448 # 80009050 <pid_lock>
    80001600:	9756                	add	a4,a4,s5
    80001602:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001606:	00008717          	auipc	a4,0x8
    8000160a:	a8270713          	addi	a4,a4,-1406 # 80009088 <cpus+0x8>
    8000160e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001610:	498d                	li	s3,3
        p->state = RUNNING;
    80001612:	4b11                	li	s6,4
        c->proc = p;
    80001614:	079e                	slli	a5,a5,0x7
    80001616:	00008a17          	auipc	s4,0x8
    8000161a:	a3aa0a13          	addi	s4,s4,-1478 # 80009050 <pid_lock>
    8000161e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001620:	0000e917          	auipc	s2,0xe
    80001624:	a6090913          	addi	s2,s2,-1440 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001628:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000162c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001630:	10079073          	csrw	sstatus,a5
    80001634:	00008497          	auipc	s1,0x8
    80001638:	e4c48493          	addi	s1,s1,-436 # 80009480 <proc>
    8000163c:	a811                	j	80001650 <scheduler+0x74>
      release(&p->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	eda080e7          	jalr	-294(ra) # 8000651a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001648:	17048493          	addi	s1,s1,368
    8000164c:	fd248ee3          	beq	s1,s2,80001628 <scheduler+0x4c>
      acquire(&p->lock);
    80001650:	8526                	mv	a0,s1
    80001652:	00005097          	auipc	ra,0x5
    80001656:	e14080e7          	jalr	-492(ra) # 80006466 <acquire>
      if(p->state == RUNNABLE) {
    8000165a:	4c9c                	lw	a5,24(s1)
    8000165c:	ff3791e3          	bne	a5,s3,8000163e <scheduler+0x62>
        p->state = RUNNING;
    80001660:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001664:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001668:	07048593          	addi	a1,s1,112
    8000166c:	8556                	mv	a0,s5
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	620080e7          	jalr	1568(ra) # 80001c8e <swtch>
        c->proc = 0;
    80001676:	020a3823          	sd	zero,48(s4)
    8000167a:	b7d1                	j	8000163e <scheduler+0x62>

000000008000167c <sched>:
{
    8000167c:	7179                	addi	sp,sp,-48
    8000167e:	f406                	sd	ra,40(sp)
    80001680:	f022                	sd	s0,32(sp)
    80001682:	ec26                	sd	s1,24(sp)
    80001684:	e84a                	sd	s2,16(sp)
    80001686:	e44e                	sd	s3,8(sp)
    80001688:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000168a:	00000097          	auipc	ra,0x0
    8000168e:	98a080e7          	jalr	-1654(ra) # 80001014 <myproc>
    80001692:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001694:	00005097          	auipc	ra,0x5
    80001698:	d58080e7          	jalr	-680(ra) # 800063ec <holding>
    8000169c:	c93d                	beqz	a0,80001712 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000169e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800016a0:	2781                	sext.w	a5,a5
    800016a2:	079e                	slli	a5,a5,0x7
    800016a4:	00008717          	auipc	a4,0x8
    800016a8:	9ac70713          	addi	a4,a4,-1620 # 80009050 <pid_lock>
    800016ac:	97ba                	add	a5,a5,a4
    800016ae:	0a87a703          	lw	a4,168(a5)
    800016b2:	4785                	li	a5,1
    800016b4:	06f71763          	bne	a4,a5,80001722 <sched+0xa6>
  if(p->state == RUNNING)
    800016b8:	4c98                	lw	a4,24(s1)
    800016ba:	4791                	li	a5,4
    800016bc:	06f70b63          	beq	a4,a5,80001732 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800016c0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800016c4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800016c6:	efb5                	bnez	a5,80001742 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800016c8:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800016ca:	00008917          	auipc	s2,0x8
    800016ce:	98690913          	addi	s2,s2,-1658 # 80009050 <pid_lock>
    800016d2:	2781                	sext.w	a5,a5
    800016d4:	079e                	slli	a5,a5,0x7
    800016d6:	97ca                	add	a5,a5,s2
    800016d8:	0ac7a983          	lw	s3,172(a5)
    800016dc:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016de:	2781                	sext.w	a5,a5
    800016e0:	079e                	slli	a5,a5,0x7
    800016e2:	00008597          	auipc	a1,0x8
    800016e6:	9a658593          	addi	a1,a1,-1626 # 80009088 <cpus+0x8>
    800016ea:	95be                	add	a1,a1,a5
    800016ec:	07048513          	addi	a0,s1,112
    800016f0:	00000097          	auipc	ra,0x0
    800016f4:	59e080e7          	jalr	1438(ra) # 80001c8e <swtch>
    800016f8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016fa:	2781                	sext.w	a5,a5
    800016fc:	079e                	slli	a5,a5,0x7
    800016fe:	993e                	add	s2,s2,a5
    80001700:	0b392623          	sw	s3,172(s2)
}
    80001704:	70a2                	ld	ra,40(sp)
    80001706:	7402                	ld	s0,32(sp)
    80001708:	64e2                	ld	s1,24(sp)
    8000170a:	6942                	ld	s2,16(sp)
    8000170c:	69a2                	ld	s3,8(sp)
    8000170e:	6145                	addi	sp,sp,48
    80001710:	8082                	ret
    panic("sched p->lock");
    80001712:	00007517          	auipc	a0,0x7
    80001716:	aee50513          	addi	a0,a0,-1298 # 80008200 <etext+0x200>
    8000171a:	00004097          	auipc	ra,0x4
    8000171e:	7d2080e7          	jalr	2002(ra) # 80005eec <panic>
    panic("sched locks");
    80001722:	00007517          	auipc	a0,0x7
    80001726:	aee50513          	addi	a0,a0,-1298 # 80008210 <etext+0x210>
    8000172a:	00004097          	auipc	ra,0x4
    8000172e:	7c2080e7          	jalr	1986(ra) # 80005eec <panic>
    panic("sched running");
    80001732:	00007517          	auipc	a0,0x7
    80001736:	aee50513          	addi	a0,a0,-1298 # 80008220 <etext+0x220>
    8000173a:	00004097          	auipc	ra,0x4
    8000173e:	7b2080e7          	jalr	1970(ra) # 80005eec <panic>
    panic("sched interruptible");
    80001742:	00007517          	auipc	a0,0x7
    80001746:	aee50513          	addi	a0,a0,-1298 # 80008230 <etext+0x230>
    8000174a:	00004097          	auipc	ra,0x4
    8000174e:	7a2080e7          	jalr	1954(ra) # 80005eec <panic>

0000000080001752 <yield>:
{
    80001752:	1101                	addi	sp,sp,-32
    80001754:	ec06                	sd	ra,24(sp)
    80001756:	e822                	sd	s0,16(sp)
    80001758:	e426                	sd	s1,8(sp)
    8000175a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000175c:	00000097          	auipc	ra,0x0
    80001760:	8b8080e7          	jalr	-1864(ra) # 80001014 <myproc>
    80001764:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001766:	00005097          	auipc	ra,0x5
    8000176a:	d00080e7          	jalr	-768(ra) # 80006466 <acquire>
  p->state = RUNNABLE;
    8000176e:	478d                	li	a5,3
    80001770:	cc9c                	sw	a5,24(s1)
  sched();
    80001772:	00000097          	auipc	ra,0x0
    80001776:	f0a080e7          	jalr	-246(ra) # 8000167c <sched>
  release(&p->lock);
    8000177a:	8526                	mv	a0,s1
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	d9e080e7          	jalr	-610(ra) # 8000651a <release>
}
    80001784:	60e2                	ld	ra,24(sp)
    80001786:	6442                	ld	s0,16(sp)
    80001788:	64a2                	ld	s1,8(sp)
    8000178a:	6105                	addi	sp,sp,32
    8000178c:	8082                	ret

000000008000178e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000178e:	7179                	addi	sp,sp,-48
    80001790:	f406                	sd	ra,40(sp)
    80001792:	f022                	sd	s0,32(sp)
    80001794:	ec26                	sd	s1,24(sp)
    80001796:	e84a                	sd	s2,16(sp)
    80001798:	e44e                	sd	s3,8(sp)
    8000179a:	1800                	addi	s0,sp,48
    8000179c:	89aa                	mv	s3,a0
    8000179e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800017a0:	00000097          	auipc	ra,0x0
    800017a4:	874080e7          	jalr	-1932(ra) # 80001014 <myproc>
    800017a8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	cbc080e7          	jalr	-836(ra) # 80006466 <acquire>
  release(lk);
    800017b2:	854a                	mv	a0,s2
    800017b4:	00005097          	auipc	ra,0x5
    800017b8:	d66080e7          	jalr	-666(ra) # 8000651a <release>

  // Go to sleep.
  p->chan = chan;
    800017bc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800017c0:	4789                	li	a5,2
    800017c2:	cc9c                	sw	a5,24(s1)

  sched();
    800017c4:	00000097          	auipc	ra,0x0
    800017c8:	eb8080e7          	jalr	-328(ra) # 8000167c <sched>

  // Tidy up.
  p->chan = 0;
    800017cc:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800017d0:	8526                	mv	a0,s1
    800017d2:	00005097          	auipc	ra,0x5
    800017d6:	d48080e7          	jalr	-696(ra) # 8000651a <release>
  acquire(lk);
    800017da:	854a                	mv	a0,s2
    800017dc:	00005097          	auipc	ra,0x5
    800017e0:	c8a080e7          	jalr	-886(ra) # 80006466 <acquire>
}
    800017e4:	70a2                	ld	ra,40(sp)
    800017e6:	7402                	ld	s0,32(sp)
    800017e8:	64e2                	ld	s1,24(sp)
    800017ea:	6942                	ld	s2,16(sp)
    800017ec:	69a2                	ld	s3,8(sp)
    800017ee:	6145                	addi	sp,sp,48
    800017f0:	8082                	ret

00000000800017f2 <wait>:
{
    800017f2:	715d                	addi	sp,sp,-80
    800017f4:	e486                	sd	ra,72(sp)
    800017f6:	e0a2                	sd	s0,64(sp)
    800017f8:	fc26                	sd	s1,56(sp)
    800017fa:	f84a                	sd	s2,48(sp)
    800017fc:	f44e                	sd	s3,40(sp)
    800017fe:	f052                	sd	s4,32(sp)
    80001800:	ec56                	sd	s5,24(sp)
    80001802:	e85a                	sd	s6,16(sp)
    80001804:	e45e                	sd	s7,8(sp)
    80001806:	e062                	sd	s8,0(sp)
    80001808:	0880                	addi	s0,sp,80
    8000180a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000180c:	00000097          	auipc	ra,0x0
    80001810:	808080e7          	jalr	-2040(ra) # 80001014 <myproc>
    80001814:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001816:	00008517          	auipc	a0,0x8
    8000181a:	85250513          	addi	a0,a0,-1966 # 80009068 <wait_lock>
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	c48080e7          	jalr	-952(ra) # 80006466 <acquire>
    havekids = 0;
    80001826:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001828:	4a15                	li	s4,5
        havekids = 1;
    8000182a:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000182c:	0000e997          	auipc	s3,0xe
    80001830:	85498993          	addi	s3,s3,-1964 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001834:	00008c17          	auipc	s8,0x8
    80001838:	834c0c13          	addi	s8,s8,-1996 # 80009068 <wait_lock>
    8000183c:	a87d                	j	800018fa <wait+0x108>
          pid = np->pid;
    8000183e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001842:	000b0e63          	beqz	s6,8000185e <wait+0x6c>
    80001846:	4691                	li	a3,4
    80001848:	02c48613          	addi	a2,s1,44
    8000184c:	85da                	mv	a1,s6
    8000184e:	06093503          	ld	a0,96(s2)
    80001852:	fffff097          	auipc	ra,0xfffff
    80001856:	2c6080e7          	jalr	710(ra) # 80000b18 <copyout>
    8000185a:	04054163          	bltz	a0,8000189c <wait+0xaa>
          freeproc(np);
    8000185e:	8526                	mv	a0,s1
    80001860:	00000097          	auipc	ra,0x0
    80001864:	9d6080e7          	jalr	-1578(ra) # 80001236 <freeproc>
          release(&np->lock);
    80001868:	8526                	mv	a0,s1
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	cb0080e7          	jalr	-848(ra) # 8000651a <release>
          release(&wait_lock);
    80001872:	00007517          	auipc	a0,0x7
    80001876:	7f650513          	addi	a0,a0,2038 # 80009068 <wait_lock>
    8000187a:	00005097          	auipc	ra,0x5
    8000187e:	ca0080e7          	jalr	-864(ra) # 8000651a <release>
}
    80001882:	854e                	mv	a0,s3
    80001884:	60a6                	ld	ra,72(sp)
    80001886:	6406                	ld	s0,64(sp)
    80001888:	74e2                	ld	s1,56(sp)
    8000188a:	7942                	ld	s2,48(sp)
    8000188c:	79a2                	ld	s3,40(sp)
    8000188e:	7a02                	ld	s4,32(sp)
    80001890:	6ae2                	ld	s5,24(sp)
    80001892:	6b42                	ld	s6,16(sp)
    80001894:	6ba2                	ld	s7,8(sp)
    80001896:	6c02                	ld	s8,0(sp)
    80001898:	6161                	addi	sp,sp,80
    8000189a:	8082                	ret
            release(&np->lock);
    8000189c:	8526                	mv	a0,s1
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	c7c080e7          	jalr	-900(ra) # 8000651a <release>
            release(&wait_lock);
    800018a6:	00007517          	auipc	a0,0x7
    800018aa:	7c250513          	addi	a0,a0,1986 # 80009068 <wait_lock>
    800018ae:	00005097          	auipc	ra,0x5
    800018b2:	c6c080e7          	jalr	-916(ra) # 8000651a <release>
            return -1;
    800018b6:	59fd                	li	s3,-1
    800018b8:	b7e9                	j	80001882 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    800018ba:	17048493          	addi	s1,s1,368
    800018be:	03348463          	beq	s1,s3,800018e6 <wait+0xf4>
      if(np->parent == p){
    800018c2:	64bc                	ld	a5,72(s1)
    800018c4:	ff279be3          	bne	a5,s2,800018ba <wait+0xc8>
        acquire(&np->lock);
    800018c8:	8526                	mv	a0,s1
    800018ca:	00005097          	auipc	ra,0x5
    800018ce:	b9c080e7          	jalr	-1124(ra) # 80006466 <acquire>
        if(np->state == ZOMBIE){
    800018d2:	4c9c                	lw	a5,24(s1)
    800018d4:	f74785e3          	beq	a5,s4,8000183e <wait+0x4c>
        release(&np->lock);
    800018d8:	8526                	mv	a0,s1
    800018da:	00005097          	auipc	ra,0x5
    800018de:	c40080e7          	jalr	-960(ra) # 8000651a <release>
        havekids = 1;
    800018e2:	8756                	mv	a4,s5
    800018e4:	bfd9                	j	800018ba <wait+0xc8>
    if(!havekids || p->killed){
    800018e6:	c305                	beqz	a4,80001906 <wait+0x114>
    800018e8:	02892783          	lw	a5,40(s2)
    800018ec:	ef89                	bnez	a5,80001906 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018ee:	85e2                	mv	a1,s8
    800018f0:	854a                	mv	a0,s2
    800018f2:	00000097          	auipc	ra,0x0
    800018f6:	e9c080e7          	jalr	-356(ra) # 8000178e <sleep>
    havekids = 0;
    800018fa:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800018fc:	00008497          	auipc	s1,0x8
    80001900:	b8448493          	addi	s1,s1,-1148 # 80009480 <proc>
    80001904:	bf7d                	j	800018c2 <wait+0xd0>
      release(&wait_lock);
    80001906:	00007517          	auipc	a0,0x7
    8000190a:	76250513          	addi	a0,a0,1890 # 80009068 <wait_lock>
    8000190e:	00005097          	auipc	ra,0x5
    80001912:	c0c080e7          	jalr	-1012(ra) # 8000651a <release>
      return -1;
    80001916:	59fd                	li	s3,-1
    80001918:	b7ad                	j	80001882 <wait+0x90>

000000008000191a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000191a:	7139                	addi	sp,sp,-64
    8000191c:	fc06                	sd	ra,56(sp)
    8000191e:	f822                	sd	s0,48(sp)
    80001920:	f426                	sd	s1,40(sp)
    80001922:	f04a                	sd	s2,32(sp)
    80001924:	ec4e                	sd	s3,24(sp)
    80001926:	e852                	sd	s4,16(sp)
    80001928:	e456                	sd	s5,8(sp)
    8000192a:	0080                	addi	s0,sp,64
    8000192c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000192e:	00008497          	auipc	s1,0x8
    80001932:	b5248493          	addi	s1,s1,-1198 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001936:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001938:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000193a:	0000d917          	auipc	s2,0xd
    8000193e:	74690913          	addi	s2,s2,1862 # 8000f080 <tickslock>
    80001942:	a811                	j	80001956 <wakeup+0x3c>
      }
      release(&p->lock);
    80001944:	8526                	mv	a0,s1
    80001946:	00005097          	auipc	ra,0x5
    8000194a:	bd4080e7          	jalr	-1068(ra) # 8000651a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000194e:	17048493          	addi	s1,s1,368
    80001952:	03248663          	beq	s1,s2,8000197e <wakeup+0x64>
    if(p != myproc()){
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	6be080e7          	jalr	1726(ra) # 80001014 <myproc>
    8000195e:	fea488e3          	beq	s1,a0,8000194e <wakeup+0x34>
      acquire(&p->lock);
    80001962:	8526                	mv	a0,s1
    80001964:	00005097          	auipc	ra,0x5
    80001968:	b02080e7          	jalr	-1278(ra) # 80006466 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000196c:	4c9c                	lw	a5,24(s1)
    8000196e:	fd379be3          	bne	a5,s3,80001944 <wakeup+0x2a>
    80001972:	709c                	ld	a5,32(s1)
    80001974:	fd4798e3          	bne	a5,s4,80001944 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001978:	0154ac23          	sw	s5,24(s1)
    8000197c:	b7e1                	j	80001944 <wakeup+0x2a>
    }
  }
}
    8000197e:	70e2                	ld	ra,56(sp)
    80001980:	7442                	ld	s0,48(sp)
    80001982:	74a2                	ld	s1,40(sp)
    80001984:	7902                	ld	s2,32(sp)
    80001986:	69e2                	ld	s3,24(sp)
    80001988:	6a42                	ld	s4,16(sp)
    8000198a:	6aa2                	ld	s5,8(sp)
    8000198c:	6121                	addi	sp,sp,64
    8000198e:	8082                	ret

0000000080001990 <reparent>:
{
    80001990:	7179                	addi	sp,sp,-48
    80001992:	f406                	sd	ra,40(sp)
    80001994:	f022                	sd	s0,32(sp)
    80001996:	ec26                	sd	s1,24(sp)
    80001998:	e84a                	sd	s2,16(sp)
    8000199a:	e44e                	sd	s3,8(sp)
    8000199c:	e052                	sd	s4,0(sp)
    8000199e:	1800                	addi	s0,sp,48
    800019a0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800019a2:	00008497          	auipc	s1,0x8
    800019a6:	ade48493          	addi	s1,s1,-1314 # 80009480 <proc>
      pp->parent = initproc;
    800019aa:	00007a17          	auipc	s4,0x7
    800019ae:	666a0a13          	addi	s4,s4,1638 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800019b2:	0000d997          	auipc	s3,0xd
    800019b6:	6ce98993          	addi	s3,s3,1742 # 8000f080 <tickslock>
    800019ba:	a029                	j	800019c4 <reparent+0x34>
    800019bc:	17048493          	addi	s1,s1,368
    800019c0:	01348d63          	beq	s1,s3,800019da <reparent+0x4a>
    if(pp->parent == p){
    800019c4:	64bc                	ld	a5,72(s1)
    800019c6:	ff279be3          	bne	a5,s2,800019bc <reparent+0x2c>
      pp->parent = initproc;
    800019ca:	000a3503          	ld	a0,0(s4)
    800019ce:	e4a8                	sd	a0,72(s1)
      wakeup(initproc);
    800019d0:	00000097          	auipc	ra,0x0
    800019d4:	f4a080e7          	jalr	-182(ra) # 8000191a <wakeup>
    800019d8:	b7d5                	j	800019bc <reparent+0x2c>
}
    800019da:	70a2                	ld	ra,40(sp)
    800019dc:	7402                	ld	s0,32(sp)
    800019de:	64e2                	ld	s1,24(sp)
    800019e0:	6942                	ld	s2,16(sp)
    800019e2:	69a2                	ld	s3,8(sp)
    800019e4:	6a02                	ld	s4,0(sp)
    800019e6:	6145                	addi	sp,sp,48
    800019e8:	8082                	ret

00000000800019ea <exit>:
{
    800019ea:	7179                	addi	sp,sp,-48
    800019ec:	f406                	sd	ra,40(sp)
    800019ee:	f022                	sd	s0,32(sp)
    800019f0:	ec26                	sd	s1,24(sp)
    800019f2:	e84a                	sd	s2,16(sp)
    800019f4:	e44e                	sd	s3,8(sp)
    800019f6:	e052                	sd	s4,0(sp)
    800019f8:	1800                	addi	s0,sp,48
    800019fa:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800019fc:	fffff097          	auipc	ra,0xfffff
    80001a00:	618080e7          	jalr	1560(ra) # 80001014 <myproc>
    80001a04:	89aa                	mv	s3,a0
  if(p == initproc)
    80001a06:	00007797          	auipc	a5,0x7
    80001a0a:	60a7b783          	ld	a5,1546(a5) # 80009010 <initproc>
    80001a0e:	0e050493          	addi	s1,a0,224
    80001a12:	16050913          	addi	s2,a0,352
    80001a16:	02a79363          	bne	a5,a0,80001a3c <exit+0x52>
    panic("init exiting");
    80001a1a:	00007517          	auipc	a0,0x7
    80001a1e:	82e50513          	addi	a0,a0,-2002 # 80008248 <etext+0x248>
    80001a22:	00004097          	auipc	ra,0x4
    80001a26:	4ca080e7          	jalr	1226(ra) # 80005eec <panic>
      fileclose(f);
    80001a2a:	00002097          	auipc	ra,0x2
    80001a2e:	1dc080e7          	jalr	476(ra) # 80003c06 <fileclose>
      p->ofile[fd] = 0;
    80001a32:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001a36:	04a1                	addi	s1,s1,8
    80001a38:	01248563          	beq	s1,s2,80001a42 <exit+0x58>
    if(p->ofile[fd]){
    80001a3c:	6088                	ld	a0,0(s1)
    80001a3e:	f575                	bnez	a0,80001a2a <exit+0x40>
    80001a40:	bfdd                	j	80001a36 <exit+0x4c>
  begin_op();
    80001a42:	00002097          	auipc	ra,0x2
    80001a46:	cfa080e7          	jalr	-774(ra) # 8000373c <begin_op>
  iput(p->cwd);
    80001a4a:	1609b503          	ld	a0,352(s3)
    80001a4e:	00001097          	auipc	ra,0x1
    80001a52:	4da080e7          	jalr	1242(ra) # 80002f28 <iput>
  end_op();
    80001a56:	00002097          	auipc	ra,0x2
    80001a5a:	d60080e7          	jalr	-672(ra) # 800037b6 <end_op>
  p->cwd = 0;
    80001a5e:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    80001a62:	00007497          	auipc	s1,0x7
    80001a66:	60648493          	addi	s1,s1,1542 # 80009068 <wait_lock>
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	00005097          	auipc	ra,0x5
    80001a70:	9fa080e7          	jalr	-1542(ra) # 80006466 <acquire>
  reparent(p);
    80001a74:	854e                	mv	a0,s3
    80001a76:	00000097          	auipc	ra,0x0
    80001a7a:	f1a080e7          	jalr	-230(ra) # 80001990 <reparent>
  wakeup(p->parent);
    80001a7e:	0489b503          	ld	a0,72(s3)
    80001a82:	00000097          	auipc	ra,0x0
    80001a86:	e98080e7          	jalr	-360(ra) # 8000191a <wakeup>
  acquire(&p->lock);
    80001a8a:	854e                	mv	a0,s3
    80001a8c:	00005097          	auipc	ra,0x5
    80001a90:	9da080e7          	jalr	-1574(ra) # 80006466 <acquire>
  p->xstate = status;
    80001a94:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a98:	4795                	li	a5,5
    80001a9a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a9e:	8526                	mv	a0,s1
    80001aa0:	00005097          	auipc	ra,0x5
    80001aa4:	a7a080e7          	jalr	-1414(ra) # 8000651a <release>
  sched();
    80001aa8:	00000097          	auipc	ra,0x0
    80001aac:	bd4080e7          	jalr	-1068(ra) # 8000167c <sched>
  panic("zombie exit");
    80001ab0:	00006517          	auipc	a0,0x6
    80001ab4:	7a850513          	addi	a0,a0,1960 # 80008258 <etext+0x258>
    80001ab8:	00004097          	auipc	ra,0x4
    80001abc:	434080e7          	jalr	1076(ra) # 80005eec <panic>

0000000080001ac0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001ac0:	7179                	addi	sp,sp,-48
    80001ac2:	f406                	sd	ra,40(sp)
    80001ac4:	f022                	sd	s0,32(sp)
    80001ac6:	ec26                	sd	s1,24(sp)
    80001ac8:	e84a                	sd	s2,16(sp)
    80001aca:	e44e                	sd	s3,8(sp)
    80001acc:	1800                	addi	s0,sp,48
    80001ace:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001ad0:	00008497          	auipc	s1,0x8
    80001ad4:	9b048493          	addi	s1,s1,-1616 # 80009480 <proc>
    80001ad8:	0000d997          	auipc	s3,0xd
    80001adc:	5a898993          	addi	s3,s3,1448 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001ae0:	8526                	mv	a0,s1
    80001ae2:	00005097          	auipc	ra,0x5
    80001ae6:	984080e7          	jalr	-1660(ra) # 80006466 <acquire>
    if(p->pid == pid){
    80001aea:	589c                	lw	a5,48(s1)
    80001aec:	01278d63          	beq	a5,s2,80001b06 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001af0:	8526                	mv	a0,s1
    80001af2:	00005097          	auipc	ra,0x5
    80001af6:	a28080e7          	jalr	-1496(ra) # 8000651a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001afa:	17048493          	addi	s1,s1,368
    80001afe:	ff3491e3          	bne	s1,s3,80001ae0 <kill+0x20>
  }
  return -1;
    80001b02:	557d                	li	a0,-1
    80001b04:	a829                	j	80001b1e <kill+0x5e>
      p->killed = 1;
    80001b06:	4785                	li	a5,1
    80001b08:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001b0a:	4c98                	lw	a4,24(s1)
    80001b0c:	4789                	li	a5,2
    80001b0e:	00f70f63          	beq	a4,a5,80001b2c <kill+0x6c>
      release(&p->lock);
    80001b12:	8526                	mv	a0,s1
    80001b14:	00005097          	auipc	ra,0x5
    80001b18:	a06080e7          	jalr	-1530(ra) # 8000651a <release>
      return 0;
    80001b1c:	4501                	li	a0,0
}
    80001b1e:	70a2                	ld	ra,40(sp)
    80001b20:	7402                	ld	s0,32(sp)
    80001b22:	64e2                	ld	s1,24(sp)
    80001b24:	6942                	ld	s2,16(sp)
    80001b26:	69a2                	ld	s3,8(sp)
    80001b28:	6145                	addi	sp,sp,48
    80001b2a:	8082                	ret
        p->state = RUNNABLE;
    80001b2c:	478d                	li	a5,3
    80001b2e:	cc9c                	sw	a5,24(s1)
    80001b30:	b7cd                	j	80001b12 <kill+0x52>

0000000080001b32 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b32:	7179                	addi	sp,sp,-48
    80001b34:	f406                	sd	ra,40(sp)
    80001b36:	f022                	sd	s0,32(sp)
    80001b38:	ec26                	sd	s1,24(sp)
    80001b3a:	e84a                	sd	s2,16(sp)
    80001b3c:	e44e                	sd	s3,8(sp)
    80001b3e:	e052                	sd	s4,0(sp)
    80001b40:	1800                	addi	s0,sp,48
    80001b42:	84aa                	mv	s1,a0
    80001b44:	892e                	mv	s2,a1
    80001b46:	89b2                	mv	s3,a2
    80001b48:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b4a:	fffff097          	auipc	ra,0xfffff
    80001b4e:	4ca080e7          	jalr	1226(ra) # 80001014 <myproc>
  if(user_dst){
    80001b52:	c08d                	beqz	s1,80001b74 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b54:	86d2                	mv	a3,s4
    80001b56:	864e                	mv	a2,s3
    80001b58:	85ca                	mv	a1,s2
    80001b5a:	7128                	ld	a0,96(a0)
    80001b5c:	fffff097          	auipc	ra,0xfffff
    80001b60:	fbc080e7          	jalr	-68(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b64:	70a2                	ld	ra,40(sp)
    80001b66:	7402                	ld	s0,32(sp)
    80001b68:	64e2                	ld	s1,24(sp)
    80001b6a:	6942                	ld	s2,16(sp)
    80001b6c:	69a2                	ld	s3,8(sp)
    80001b6e:	6a02                	ld	s4,0(sp)
    80001b70:	6145                	addi	sp,sp,48
    80001b72:	8082                	ret
    memmove((char *)dst, src, len);
    80001b74:	000a061b          	sext.w	a2,s4
    80001b78:	85ce                	mv	a1,s3
    80001b7a:	854a                	mv	a0,s2
    80001b7c:	ffffe097          	auipc	ra,0xffffe
    80001b80:	65a080e7          	jalr	1626(ra) # 800001d6 <memmove>
    return 0;
    80001b84:	8526                	mv	a0,s1
    80001b86:	bff9                	j	80001b64 <either_copyout+0x32>

0000000080001b88 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b88:	7179                	addi	sp,sp,-48
    80001b8a:	f406                	sd	ra,40(sp)
    80001b8c:	f022                	sd	s0,32(sp)
    80001b8e:	ec26                	sd	s1,24(sp)
    80001b90:	e84a                	sd	s2,16(sp)
    80001b92:	e44e                	sd	s3,8(sp)
    80001b94:	e052                	sd	s4,0(sp)
    80001b96:	1800                	addi	s0,sp,48
    80001b98:	892a                	mv	s2,a0
    80001b9a:	84ae                	mv	s1,a1
    80001b9c:	89b2                	mv	s3,a2
    80001b9e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ba0:	fffff097          	auipc	ra,0xfffff
    80001ba4:	474080e7          	jalr	1140(ra) # 80001014 <myproc>
  if(user_src){
    80001ba8:	c08d                	beqz	s1,80001bca <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001baa:	86d2                	mv	a3,s4
    80001bac:	864e                	mv	a2,s3
    80001bae:	85ca                	mv	a1,s2
    80001bb0:	7128                	ld	a0,96(a0)
    80001bb2:	fffff097          	auipc	ra,0xfffff
    80001bb6:	ff2080e7          	jalr	-14(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001bba:	70a2                	ld	ra,40(sp)
    80001bbc:	7402                	ld	s0,32(sp)
    80001bbe:	64e2                	ld	s1,24(sp)
    80001bc0:	6942                	ld	s2,16(sp)
    80001bc2:	69a2                	ld	s3,8(sp)
    80001bc4:	6a02                	ld	s4,0(sp)
    80001bc6:	6145                	addi	sp,sp,48
    80001bc8:	8082                	ret
    memmove(dst, (char*)src, len);
    80001bca:	000a061b          	sext.w	a2,s4
    80001bce:	85ce                	mv	a1,s3
    80001bd0:	854a                	mv	a0,s2
    80001bd2:	ffffe097          	auipc	ra,0xffffe
    80001bd6:	604080e7          	jalr	1540(ra) # 800001d6 <memmove>
    return 0;
    80001bda:	8526                	mv	a0,s1
    80001bdc:	bff9                	j	80001bba <either_copyin+0x32>

0000000080001bde <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001bde:	715d                	addi	sp,sp,-80
    80001be0:	e486                	sd	ra,72(sp)
    80001be2:	e0a2                	sd	s0,64(sp)
    80001be4:	fc26                	sd	s1,56(sp)
    80001be6:	f84a                	sd	s2,48(sp)
    80001be8:	f44e                	sd	s3,40(sp)
    80001bea:	f052                	sd	s4,32(sp)
    80001bec:	ec56                	sd	s5,24(sp)
    80001bee:	e85a                	sd	s6,16(sp)
    80001bf0:	e45e                	sd	s7,8(sp)
    80001bf2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001bf4:	00006517          	auipc	a0,0x6
    80001bf8:	42450513          	addi	a0,a0,1060 # 80008018 <etext+0x18>
    80001bfc:	00004097          	auipc	ra,0x4
    80001c00:	33a080e7          	jalr	826(ra) # 80005f36 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c04:	00008497          	auipc	s1,0x8
    80001c08:	8b048493          	addi	s1,s1,-1872 # 800094b4 <proc+0x34>
    80001c0c:	0000d917          	auipc	s2,0xd
    80001c10:	4a890913          	addi	s2,s2,1192 # 8000f0b4 <bcache+0x1c>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c14:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c16:	00006997          	auipc	s3,0x6
    80001c1a:	65298993          	addi	s3,s3,1618 # 80008268 <etext+0x268>
    printf("%d %s %s", p->pid, state, p->name);
    80001c1e:	00006a97          	auipc	s5,0x6
    80001c22:	652a8a93          	addi	s5,s5,1618 # 80008270 <etext+0x270>
    printf("\n");
    80001c26:	00006a17          	auipc	s4,0x6
    80001c2a:	3f2a0a13          	addi	s4,s4,1010 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c2e:	00007b97          	auipc	s7,0x7
    80001c32:	b32b8b93          	addi	s7,s7,-1230 # 80008760 <states.0>
    80001c36:	a00d                	j	80001c58 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c38:	ffc6a583          	lw	a1,-4(a3)
    80001c3c:	8556                	mv	a0,s5
    80001c3e:	00004097          	auipc	ra,0x4
    80001c42:	2f8080e7          	jalr	760(ra) # 80005f36 <printf>
    printf("\n");
    80001c46:	8552                	mv	a0,s4
    80001c48:	00004097          	auipc	ra,0x4
    80001c4c:	2ee080e7          	jalr	750(ra) # 80005f36 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c50:	17048493          	addi	s1,s1,368
    80001c54:	03248263          	beq	s1,s2,80001c78 <procdump+0x9a>
    if(p->state == UNUSED)
    80001c58:	86a6                	mv	a3,s1
    80001c5a:	fe44a783          	lw	a5,-28(s1)
    80001c5e:	dbed                	beqz	a5,80001c50 <procdump+0x72>
      state = "???";
    80001c60:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c62:	fcfb6be3          	bltu	s6,a5,80001c38 <procdump+0x5a>
    80001c66:	02079713          	slli	a4,a5,0x20
    80001c6a:	01d75793          	srli	a5,a4,0x1d
    80001c6e:	97de                	add	a5,a5,s7
    80001c70:	6390                	ld	a2,0(a5)
    80001c72:	f279                	bnez	a2,80001c38 <procdump+0x5a>
      state = "???";
    80001c74:	864e                	mv	a2,s3
    80001c76:	b7c9                	j	80001c38 <procdump+0x5a>
  }
}
    80001c78:	60a6                	ld	ra,72(sp)
    80001c7a:	6406                	ld	s0,64(sp)
    80001c7c:	74e2                	ld	s1,56(sp)
    80001c7e:	7942                	ld	s2,48(sp)
    80001c80:	79a2                	ld	s3,40(sp)
    80001c82:	7a02                	ld	s4,32(sp)
    80001c84:	6ae2                	ld	s5,24(sp)
    80001c86:	6b42                	ld	s6,16(sp)
    80001c88:	6ba2                	ld	s7,8(sp)
    80001c8a:	6161                	addi	sp,sp,80
    80001c8c:	8082                	ret

0000000080001c8e <swtch>:
    80001c8e:	00153023          	sd	ra,0(a0)
    80001c92:	00253423          	sd	sp,8(a0)
    80001c96:	e900                	sd	s0,16(a0)
    80001c98:	ed04                	sd	s1,24(a0)
    80001c9a:	03253023          	sd	s2,32(a0)
    80001c9e:	03353423          	sd	s3,40(a0)
    80001ca2:	03453823          	sd	s4,48(a0)
    80001ca6:	03553c23          	sd	s5,56(a0)
    80001caa:	05653023          	sd	s6,64(a0)
    80001cae:	05753423          	sd	s7,72(a0)
    80001cb2:	05853823          	sd	s8,80(a0)
    80001cb6:	05953c23          	sd	s9,88(a0)
    80001cba:	07a53023          	sd	s10,96(a0)
    80001cbe:	07b53423          	sd	s11,104(a0)
    80001cc2:	0005b083          	ld	ra,0(a1)
    80001cc6:	0085b103          	ld	sp,8(a1)
    80001cca:	6980                	ld	s0,16(a1)
    80001ccc:	6d84                	ld	s1,24(a1)
    80001cce:	0205b903          	ld	s2,32(a1)
    80001cd2:	0285b983          	ld	s3,40(a1)
    80001cd6:	0305ba03          	ld	s4,48(a1)
    80001cda:	0385ba83          	ld	s5,56(a1)
    80001cde:	0405bb03          	ld	s6,64(a1)
    80001ce2:	0485bb83          	ld	s7,72(a1)
    80001ce6:	0505bc03          	ld	s8,80(a1)
    80001cea:	0585bc83          	ld	s9,88(a1)
    80001cee:	0605bd03          	ld	s10,96(a1)
    80001cf2:	0685bd83          	ld	s11,104(a1)
    80001cf6:	8082                	ret

0000000080001cf8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001cf8:	1141                	addi	sp,sp,-16
    80001cfa:	e406                	sd	ra,8(sp)
    80001cfc:	e022                	sd	s0,0(sp)
    80001cfe:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d00:	00006597          	auipc	a1,0x6
    80001d04:	5a858593          	addi	a1,a1,1448 # 800082a8 <etext+0x2a8>
    80001d08:	0000d517          	auipc	a0,0xd
    80001d0c:	37850513          	addi	a0,a0,888 # 8000f080 <tickslock>
    80001d10:	00004097          	auipc	ra,0x4
    80001d14:	6c6080e7          	jalr	1734(ra) # 800063d6 <initlock>
}
    80001d18:	60a2                	ld	ra,8(sp)
    80001d1a:	6402                	ld	s0,0(sp)
    80001d1c:	0141                	addi	sp,sp,16
    80001d1e:	8082                	ret

0000000080001d20 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d20:	1141                	addi	sp,sp,-16
    80001d22:	e422                	sd	s0,8(sp)
    80001d24:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d26:	00003797          	auipc	a5,0x3
    80001d2a:	5da78793          	addi	a5,a5,1498 # 80005300 <kernelvec>
    80001d2e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d32:	6422                	ld	s0,8(sp)
    80001d34:	0141                	addi	sp,sp,16
    80001d36:	8082                	ret

0000000080001d38 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d38:	1141                	addi	sp,sp,-16
    80001d3a:	e406                	sd	ra,8(sp)
    80001d3c:	e022                	sd	s0,0(sp)
    80001d3e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	2d4080e7          	jalr	724(ra) # 80001014 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d48:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d4c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d4e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001d52:	00005697          	auipc	a3,0x5
    80001d56:	2ae68693          	addi	a3,a3,686 # 80007000 <_trampoline>
    80001d5a:	00005717          	auipc	a4,0x5
    80001d5e:	2a670713          	addi	a4,a4,678 # 80007000 <_trampoline>
    80001d62:	8f15                	sub	a4,a4,a3
    80001d64:	040007b7          	lui	a5,0x4000
    80001d68:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d6a:	07b2                	slli	a5,a5,0xc
    80001d6c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d6e:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d72:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d74:	18002673          	csrr	a2,satp
    80001d78:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d7a:	7530                	ld	a2,104(a0)
    80001d7c:	6938                	ld	a4,80(a0)
    80001d7e:	6585                	lui	a1,0x1
    80001d80:	972e                	add	a4,a4,a1
    80001d82:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d84:	7538                	ld	a4,104(a0)
    80001d86:	00000617          	auipc	a2,0x0
    80001d8a:	14060613          	addi	a2,a2,320 # 80001ec6 <usertrap>
    80001d8e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d90:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d92:	8612                	mv	a2,tp
    80001d94:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d96:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d9a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d9e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001da2:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001da6:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001da8:	6f18                	ld	a4,24(a4)
    80001daa:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001dae:	712c                	ld	a1,96(a0)
    80001db0:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001db2:	00005717          	auipc	a4,0x5
    80001db6:	2de70713          	addi	a4,a4,734 # 80007090 <userret>
    80001dba:	8f15                	sub	a4,a4,a3
    80001dbc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001dbe:	577d                	li	a4,-1
    80001dc0:	177e                	slli	a4,a4,0x3f
    80001dc2:	8dd9                	or	a1,a1,a4
    80001dc4:	02000537          	lui	a0,0x2000
    80001dc8:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001dca:	0536                	slli	a0,a0,0xd
    80001dcc:	9782                	jalr	a5
}
    80001dce:	60a2                	ld	ra,8(sp)
    80001dd0:	6402                	ld	s0,0(sp)
    80001dd2:	0141                	addi	sp,sp,16
    80001dd4:	8082                	ret

0000000080001dd6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001dd6:	1101                	addi	sp,sp,-32
    80001dd8:	ec06                	sd	ra,24(sp)
    80001dda:	e822                	sd	s0,16(sp)
    80001ddc:	e426                	sd	s1,8(sp)
    80001dde:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001de0:	0000d497          	auipc	s1,0xd
    80001de4:	2a048493          	addi	s1,s1,672 # 8000f080 <tickslock>
    80001de8:	8526                	mv	a0,s1
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	67c080e7          	jalr	1660(ra) # 80006466 <acquire>
  ticks++;
    80001df2:	00007517          	auipc	a0,0x7
    80001df6:	22650513          	addi	a0,a0,550 # 80009018 <ticks>
    80001dfa:	411c                	lw	a5,0(a0)
    80001dfc:	2785                	addiw	a5,a5,1
    80001dfe:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e00:	00000097          	auipc	ra,0x0
    80001e04:	b1a080e7          	jalr	-1254(ra) # 8000191a <wakeup>
  release(&tickslock);
    80001e08:	8526                	mv	a0,s1
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	710080e7          	jalr	1808(ra) # 8000651a <release>
}
    80001e12:	60e2                	ld	ra,24(sp)
    80001e14:	6442                	ld	s0,16(sp)
    80001e16:	64a2                	ld	s1,8(sp)
    80001e18:	6105                	addi	sp,sp,32
    80001e1a:	8082                	ret

0000000080001e1c <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e1c:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e20:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001e22:	0a07d163          	bgez	a5,80001ec4 <devintr+0xa8>
{
    80001e26:	1101                	addi	sp,sp,-32
    80001e28:	ec06                	sd	ra,24(sp)
    80001e2a:	e822                	sd	s0,16(sp)
    80001e2c:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001e2e:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001e32:	46a5                	li	a3,9
    80001e34:	00d70c63          	beq	a4,a3,80001e4c <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001e38:	577d                	li	a4,-1
    80001e3a:	177e                	slli	a4,a4,0x3f
    80001e3c:	0705                	addi	a4,a4,1
    return 0;
    80001e3e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e40:	06e78163          	beq	a5,a4,80001ea2 <devintr+0x86>
  }
}
    80001e44:	60e2                	ld	ra,24(sp)
    80001e46:	6442                	ld	s0,16(sp)
    80001e48:	6105                	addi	sp,sp,32
    80001e4a:	8082                	ret
    80001e4c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001e4e:	00003097          	auipc	ra,0x3
    80001e52:	5be080e7          	jalr	1470(ra) # 8000540c <plic_claim>
    80001e56:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e58:	47a9                	li	a5,10
    80001e5a:	00f50963          	beq	a0,a5,80001e6c <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001e5e:	4785                	li	a5,1
    80001e60:	00f50b63          	beq	a0,a5,80001e76 <devintr+0x5a>
    return 1;
    80001e64:	4505                	li	a0,1
    } else if(irq){
    80001e66:	ec89                	bnez	s1,80001e80 <devintr+0x64>
    80001e68:	64a2                	ld	s1,8(sp)
    80001e6a:	bfe9                	j	80001e44 <devintr+0x28>
      uartintr();
    80001e6c:	00004097          	auipc	ra,0x4
    80001e70:	51a080e7          	jalr	1306(ra) # 80006386 <uartintr>
    if(irq)
    80001e74:	a839                	j	80001e92 <devintr+0x76>
      virtio_disk_intr();
    80001e76:	00004097          	auipc	ra,0x4
    80001e7a:	a6a080e7          	jalr	-1430(ra) # 800058e0 <virtio_disk_intr>
    if(irq)
    80001e7e:	a811                	j	80001e92 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e80:	85a6                	mv	a1,s1
    80001e82:	00006517          	auipc	a0,0x6
    80001e86:	42e50513          	addi	a0,a0,1070 # 800082b0 <etext+0x2b0>
    80001e8a:	00004097          	auipc	ra,0x4
    80001e8e:	0ac080e7          	jalr	172(ra) # 80005f36 <printf>
      plic_complete(irq);
    80001e92:	8526                	mv	a0,s1
    80001e94:	00003097          	auipc	ra,0x3
    80001e98:	59c080e7          	jalr	1436(ra) # 80005430 <plic_complete>
    return 1;
    80001e9c:	4505                	li	a0,1
    80001e9e:	64a2                	ld	s1,8(sp)
    80001ea0:	b755                	j	80001e44 <devintr+0x28>
    if(cpuid() == 0){
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	146080e7          	jalr	326(ra) # 80000fe8 <cpuid>
    80001eaa:	c901                	beqz	a0,80001eba <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001eac:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001eb0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001eb2:	14479073          	csrw	sip,a5
    return 2;
    80001eb6:	4509                	li	a0,2
    80001eb8:	b771                	j	80001e44 <devintr+0x28>
      clockintr();
    80001eba:	00000097          	auipc	ra,0x0
    80001ebe:	f1c080e7          	jalr	-228(ra) # 80001dd6 <clockintr>
    80001ec2:	b7ed                	j	80001eac <devintr+0x90>
}
    80001ec4:	8082                	ret

0000000080001ec6 <usertrap>:
{
    80001ec6:	1101                	addi	sp,sp,-32
    80001ec8:	ec06                	sd	ra,24(sp)
    80001eca:	e822                	sd	s0,16(sp)
    80001ecc:	e426                	sd	s1,8(sp)
    80001ece:	e04a                	sd	s2,0(sp)
    80001ed0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ed6:	1007f793          	andi	a5,a5,256
    80001eda:	e3ad                	bnez	a5,80001f3c <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001edc:	00003797          	auipc	a5,0x3
    80001ee0:	42478793          	addi	a5,a5,1060 # 80005300 <kernelvec>
    80001ee4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	12c080e7          	jalr	300(ra) # 80001014 <myproc>
    80001ef0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ef2:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef4:	14102773          	csrr	a4,sepc
    80001ef8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001efa:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001efe:	47a1                	li	a5,8
    80001f00:	04f71c63          	bne	a4,a5,80001f58 <usertrap+0x92>
    if(p->killed)
    80001f04:	551c                	lw	a5,40(a0)
    80001f06:	e3b9                	bnez	a5,80001f4c <usertrap+0x86>
    p->trapframe->epc += 4;
    80001f08:	74b8                	ld	a4,104(s1)
    80001f0a:	6f1c                	ld	a5,24(a4)
    80001f0c:	0791                	addi	a5,a5,4
    80001f0e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f10:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f14:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f18:	10079073          	csrw	sstatus,a5
    syscall();
    80001f1c:	00000097          	auipc	ra,0x0
    80001f20:	2e0080e7          	jalr	736(ra) # 800021fc <syscall>
  if(p->killed)
    80001f24:	549c                	lw	a5,40(s1)
    80001f26:	ebc1                	bnez	a5,80001fb6 <usertrap+0xf0>
  usertrapret();
    80001f28:	00000097          	auipc	ra,0x0
    80001f2c:	e10080e7          	jalr	-496(ra) # 80001d38 <usertrapret>
}
    80001f30:	60e2                	ld	ra,24(sp)
    80001f32:	6442                	ld	s0,16(sp)
    80001f34:	64a2                	ld	s1,8(sp)
    80001f36:	6902                	ld	s2,0(sp)
    80001f38:	6105                	addi	sp,sp,32
    80001f3a:	8082                	ret
    panic("usertrap: not from user mode");
    80001f3c:	00006517          	auipc	a0,0x6
    80001f40:	39450513          	addi	a0,a0,916 # 800082d0 <etext+0x2d0>
    80001f44:	00004097          	auipc	ra,0x4
    80001f48:	fa8080e7          	jalr	-88(ra) # 80005eec <panic>
      exit(-1);
    80001f4c:	557d                	li	a0,-1
    80001f4e:	00000097          	auipc	ra,0x0
    80001f52:	a9c080e7          	jalr	-1380(ra) # 800019ea <exit>
    80001f56:	bf4d                	j	80001f08 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001f58:	00000097          	auipc	ra,0x0
    80001f5c:	ec4080e7          	jalr	-316(ra) # 80001e1c <devintr>
    80001f60:	892a                	mv	s2,a0
    80001f62:	c501                	beqz	a0,80001f6a <usertrap+0xa4>
  if(p->killed)
    80001f64:	549c                	lw	a5,40(s1)
    80001f66:	c3a1                	beqz	a5,80001fa6 <usertrap+0xe0>
    80001f68:	a815                	j	80001f9c <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f6a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f6e:	5890                	lw	a2,48(s1)
    80001f70:	00006517          	auipc	a0,0x6
    80001f74:	38050513          	addi	a0,a0,896 # 800082f0 <etext+0x2f0>
    80001f78:	00004097          	auipc	ra,0x4
    80001f7c:	fbe080e7          	jalr	-66(ra) # 80005f36 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f80:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f84:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f88:	00006517          	auipc	a0,0x6
    80001f8c:	39850513          	addi	a0,a0,920 # 80008320 <etext+0x320>
    80001f90:	00004097          	auipc	ra,0x4
    80001f94:	fa6080e7          	jalr	-90(ra) # 80005f36 <printf>
    p->killed = 1;
    80001f98:	4785                	li	a5,1
    80001f9a:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001f9c:	557d                	li	a0,-1
    80001f9e:	00000097          	auipc	ra,0x0
    80001fa2:	a4c080e7          	jalr	-1460(ra) # 800019ea <exit>
  if(which_dev == 2)
    80001fa6:	4789                	li	a5,2
    80001fa8:	f8f910e3          	bne	s2,a5,80001f28 <usertrap+0x62>
    yield();
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	7a6080e7          	jalr	1958(ra) # 80001752 <yield>
    80001fb4:	bf95                	j	80001f28 <usertrap+0x62>
  int which_dev = 0;
    80001fb6:	4901                	li	s2,0
    80001fb8:	b7d5                	j	80001f9c <usertrap+0xd6>

0000000080001fba <kerneltrap>:
{
    80001fba:	7179                	addi	sp,sp,-48
    80001fbc:	f406                	sd	ra,40(sp)
    80001fbe:	f022                	sd	s0,32(sp)
    80001fc0:	ec26                	sd	s1,24(sp)
    80001fc2:	e84a                	sd	s2,16(sp)
    80001fc4:	e44e                	sd	s3,8(sp)
    80001fc6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fc8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fcc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fd0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fd4:	1004f793          	andi	a5,s1,256
    80001fd8:	cb85                	beqz	a5,80002008 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fda:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fde:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001fe0:	ef85                	bnez	a5,80002018 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	e3a080e7          	jalr	-454(ra) # 80001e1c <devintr>
    80001fea:	cd1d                	beqz	a0,80002028 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fec:	4789                	li	a5,2
    80001fee:	06f50a63          	beq	a0,a5,80002062 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ff2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ff6:	10049073          	csrw	sstatus,s1
}
    80001ffa:	70a2                	ld	ra,40(sp)
    80001ffc:	7402                	ld	s0,32(sp)
    80001ffe:	64e2                	ld	s1,24(sp)
    80002000:	6942                	ld	s2,16(sp)
    80002002:	69a2                	ld	s3,8(sp)
    80002004:	6145                	addi	sp,sp,48
    80002006:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002008:	00006517          	auipc	a0,0x6
    8000200c:	33850513          	addi	a0,a0,824 # 80008340 <etext+0x340>
    80002010:	00004097          	auipc	ra,0x4
    80002014:	edc080e7          	jalr	-292(ra) # 80005eec <panic>
    panic("kerneltrap: interrupts enabled");
    80002018:	00006517          	auipc	a0,0x6
    8000201c:	35050513          	addi	a0,a0,848 # 80008368 <etext+0x368>
    80002020:	00004097          	auipc	ra,0x4
    80002024:	ecc080e7          	jalr	-308(ra) # 80005eec <panic>
    printf("scause %p\n", scause);
    80002028:	85ce                	mv	a1,s3
    8000202a:	00006517          	auipc	a0,0x6
    8000202e:	35e50513          	addi	a0,a0,862 # 80008388 <etext+0x388>
    80002032:	00004097          	auipc	ra,0x4
    80002036:	f04080e7          	jalr	-252(ra) # 80005f36 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000203a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000203e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002042:	00006517          	auipc	a0,0x6
    80002046:	35650513          	addi	a0,a0,854 # 80008398 <etext+0x398>
    8000204a:	00004097          	auipc	ra,0x4
    8000204e:	eec080e7          	jalr	-276(ra) # 80005f36 <printf>
    panic("kerneltrap");
    80002052:	00006517          	auipc	a0,0x6
    80002056:	35e50513          	addi	a0,a0,862 # 800083b0 <etext+0x3b0>
    8000205a:	00004097          	auipc	ra,0x4
    8000205e:	e92080e7          	jalr	-366(ra) # 80005eec <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	fb2080e7          	jalr	-78(ra) # 80001014 <myproc>
    8000206a:	d541                	beqz	a0,80001ff2 <kerneltrap+0x38>
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	fa8080e7          	jalr	-88(ra) # 80001014 <myproc>
    80002074:	4d18                	lw	a4,24(a0)
    80002076:	4791                	li	a5,4
    80002078:	f6f71de3          	bne	a4,a5,80001ff2 <kerneltrap+0x38>
    yield();
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	6d6080e7          	jalr	1750(ra) # 80001752 <yield>
    80002084:	b7bd                	j	80001ff2 <kerneltrap+0x38>

0000000080002086 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002086:	1101                	addi	sp,sp,-32
    80002088:	ec06                	sd	ra,24(sp)
    8000208a:	e822                	sd	s0,16(sp)
    8000208c:	e426                	sd	s1,8(sp)
    8000208e:	1000                	addi	s0,sp,32
    80002090:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002092:	fffff097          	auipc	ra,0xfffff
    80002096:	f82080e7          	jalr	-126(ra) # 80001014 <myproc>
  switch (n) {
    8000209a:	4795                	li	a5,5
    8000209c:	0497e163          	bltu	a5,s1,800020de <argraw+0x58>
    800020a0:	048a                	slli	s1,s1,0x2
    800020a2:	00006717          	auipc	a4,0x6
    800020a6:	6ee70713          	addi	a4,a4,1774 # 80008790 <states.0+0x30>
    800020aa:	94ba                	add	s1,s1,a4
    800020ac:	409c                	lw	a5,0(s1)
    800020ae:	97ba                	add	a5,a5,a4
    800020b0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020b2:	753c                	ld	a5,104(a0)
    800020b4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020b6:	60e2                	ld	ra,24(sp)
    800020b8:	6442                	ld	s0,16(sp)
    800020ba:	64a2                	ld	s1,8(sp)
    800020bc:	6105                	addi	sp,sp,32
    800020be:	8082                	ret
    return p->trapframe->a1;
    800020c0:	753c                	ld	a5,104(a0)
    800020c2:	7fa8                	ld	a0,120(a5)
    800020c4:	bfcd                	j	800020b6 <argraw+0x30>
    return p->trapframe->a2;
    800020c6:	753c                	ld	a5,104(a0)
    800020c8:	63c8                	ld	a0,128(a5)
    800020ca:	b7f5                	j	800020b6 <argraw+0x30>
    return p->trapframe->a3;
    800020cc:	753c                	ld	a5,104(a0)
    800020ce:	67c8                	ld	a0,136(a5)
    800020d0:	b7dd                	j	800020b6 <argraw+0x30>
    return p->trapframe->a4;
    800020d2:	753c                	ld	a5,104(a0)
    800020d4:	6bc8                	ld	a0,144(a5)
    800020d6:	b7c5                	j	800020b6 <argraw+0x30>
    return p->trapframe->a5;
    800020d8:	753c                	ld	a5,104(a0)
    800020da:	6fc8                	ld	a0,152(a5)
    800020dc:	bfe9                	j	800020b6 <argraw+0x30>
  panic("argraw");
    800020de:	00006517          	auipc	a0,0x6
    800020e2:	2e250513          	addi	a0,a0,738 # 800083c0 <etext+0x3c0>
    800020e6:	00004097          	auipc	ra,0x4
    800020ea:	e06080e7          	jalr	-506(ra) # 80005eec <panic>

00000000800020ee <fetchaddr>:
{
    800020ee:	1101                	addi	sp,sp,-32
    800020f0:	ec06                	sd	ra,24(sp)
    800020f2:	e822                	sd	s0,16(sp)
    800020f4:	e426                	sd	s1,8(sp)
    800020f6:	e04a                	sd	s2,0(sp)
    800020f8:	1000                	addi	s0,sp,32
    800020fa:	84aa                	mv	s1,a0
    800020fc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	f16080e7          	jalr	-234(ra) # 80001014 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002106:	6d3c                	ld	a5,88(a0)
    80002108:	02f4f863          	bgeu	s1,a5,80002138 <fetchaddr+0x4a>
    8000210c:	00848713          	addi	a4,s1,8
    80002110:	02e7e663          	bltu	a5,a4,8000213c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002114:	46a1                	li	a3,8
    80002116:	8626                	mv	a2,s1
    80002118:	85ca                	mv	a1,s2
    8000211a:	7128                	ld	a0,96(a0)
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	a88080e7          	jalr	-1400(ra) # 80000ba4 <copyin>
    80002124:	00a03533          	snez	a0,a0
    80002128:	40a00533          	neg	a0,a0
}
    8000212c:	60e2                	ld	ra,24(sp)
    8000212e:	6442                	ld	s0,16(sp)
    80002130:	64a2                	ld	s1,8(sp)
    80002132:	6902                	ld	s2,0(sp)
    80002134:	6105                	addi	sp,sp,32
    80002136:	8082                	ret
    return -1;
    80002138:	557d                	li	a0,-1
    8000213a:	bfcd                	j	8000212c <fetchaddr+0x3e>
    8000213c:	557d                	li	a0,-1
    8000213e:	b7fd                	j	8000212c <fetchaddr+0x3e>

0000000080002140 <fetchstr>:
{
    80002140:	7179                	addi	sp,sp,-48
    80002142:	f406                	sd	ra,40(sp)
    80002144:	f022                	sd	s0,32(sp)
    80002146:	ec26                	sd	s1,24(sp)
    80002148:	e84a                	sd	s2,16(sp)
    8000214a:	e44e                	sd	s3,8(sp)
    8000214c:	1800                	addi	s0,sp,48
    8000214e:	892a                	mv	s2,a0
    80002150:	84ae                	mv	s1,a1
    80002152:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	ec0080e7          	jalr	-320(ra) # 80001014 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000215c:	86ce                	mv	a3,s3
    8000215e:	864a                	mv	a2,s2
    80002160:	85a6                	mv	a1,s1
    80002162:	7128                	ld	a0,96(a0)
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	ace080e7          	jalr	-1330(ra) # 80000c32 <copyinstr>
  if(err < 0)
    8000216c:	00054763          	bltz	a0,8000217a <fetchstr+0x3a>
  return strlen(buf);
    80002170:	8526                	mv	a0,s1
    80002172:	ffffe097          	auipc	ra,0xffffe
    80002176:	17c080e7          	jalr	380(ra) # 800002ee <strlen>
}
    8000217a:	70a2                	ld	ra,40(sp)
    8000217c:	7402                	ld	s0,32(sp)
    8000217e:	64e2                	ld	s1,24(sp)
    80002180:	6942                	ld	s2,16(sp)
    80002182:	69a2                	ld	s3,8(sp)
    80002184:	6145                	addi	sp,sp,48
    80002186:	8082                	ret

0000000080002188 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002188:	1101                	addi	sp,sp,-32
    8000218a:	ec06                	sd	ra,24(sp)
    8000218c:	e822                	sd	s0,16(sp)
    8000218e:	e426                	sd	s1,8(sp)
    80002190:	1000                	addi	s0,sp,32
    80002192:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002194:	00000097          	auipc	ra,0x0
    80002198:	ef2080e7          	jalr	-270(ra) # 80002086 <argraw>
    8000219c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000219e:	4501                	li	a0,0
    800021a0:	60e2                	ld	ra,24(sp)
    800021a2:	6442                	ld	s0,16(sp)
    800021a4:	64a2                	ld	s1,8(sp)
    800021a6:	6105                	addi	sp,sp,32
    800021a8:	8082                	ret

00000000800021aa <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800021aa:	1101                	addi	sp,sp,-32
    800021ac:	ec06                	sd	ra,24(sp)
    800021ae:	e822                	sd	s0,16(sp)
    800021b0:	e426                	sd	s1,8(sp)
    800021b2:	1000                	addi	s0,sp,32
    800021b4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021b6:	00000097          	auipc	ra,0x0
    800021ba:	ed0080e7          	jalr	-304(ra) # 80002086 <argraw>
    800021be:	e088                	sd	a0,0(s1)
  return 0;
}
    800021c0:	4501                	li	a0,0
    800021c2:	60e2                	ld	ra,24(sp)
    800021c4:	6442                	ld	s0,16(sp)
    800021c6:	64a2                	ld	s1,8(sp)
    800021c8:	6105                	addi	sp,sp,32
    800021ca:	8082                	ret

00000000800021cc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021cc:	1101                	addi	sp,sp,-32
    800021ce:	ec06                	sd	ra,24(sp)
    800021d0:	e822                	sd	s0,16(sp)
    800021d2:	e426                	sd	s1,8(sp)
    800021d4:	e04a                	sd	s2,0(sp)
    800021d6:	1000                	addi	s0,sp,32
    800021d8:	84ae                	mv	s1,a1
    800021da:	8932                	mv	s2,a2
  *ip = argraw(n);
    800021dc:	00000097          	auipc	ra,0x0
    800021e0:	eaa080e7          	jalr	-342(ra) # 80002086 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021e4:	864a                	mv	a2,s2
    800021e6:	85a6                	mv	a1,s1
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	f58080e7          	jalr	-168(ra) # 80002140 <fetchstr>
}
    800021f0:	60e2                	ld	ra,24(sp)
    800021f2:	6442                	ld	s0,16(sp)
    800021f4:	64a2                	ld	s1,8(sp)
    800021f6:	6902                	ld	s2,0(sp)
    800021f8:	6105                	addi	sp,sp,32
    800021fa:	8082                	ret

00000000800021fc <syscall>:



void
syscall(void)
{
    800021fc:	1101                	addi	sp,sp,-32
    800021fe:	ec06                	sd	ra,24(sp)
    80002200:	e822                	sd	s0,16(sp)
    80002202:	e426                	sd	s1,8(sp)
    80002204:	e04a                	sd	s2,0(sp)
    80002206:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	e0c080e7          	jalr	-500(ra) # 80001014 <myproc>
    80002210:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002212:	06853903          	ld	s2,104(a0)
    80002216:	0a893783          	ld	a5,168(s2)
    8000221a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000221e:	37fd                	addiw	a5,a5,-1
    80002220:	4775                	li	a4,29
    80002222:	00f76f63          	bltu	a4,a5,80002240 <syscall+0x44>
    80002226:	00369713          	slli	a4,a3,0x3
    8000222a:	00006797          	auipc	a5,0x6
    8000222e:	57e78793          	addi	a5,a5,1406 # 800087a8 <syscalls>
    80002232:	97ba                	add	a5,a5,a4
    80002234:	639c                	ld	a5,0(a5)
    80002236:	c789                	beqz	a5,80002240 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002238:	9782                	jalr	a5
    8000223a:	06a93823          	sd	a0,112(s2)
    8000223e:	a839                	j	8000225c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002240:	03448613          	addi	a2,s1,52
    80002244:	588c                	lw	a1,48(s1)
    80002246:	00006517          	auipc	a0,0x6
    8000224a:	18250513          	addi	a0,a0,386 # 800083c8 <etext+0x3c8>
    8000224e:	00004097          	auipc	ra,0x4
    80002252:	ce8080e7          	jalr	-792(ra) # 80005f36 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002256:	74bc                	ld	a5,104(s1)
    80002258:	577d                	li	a4,-1
    8000225a:	fbb8                	sd	a4,112(a5)
  }
}
    8000225c:	60e2                	ld	ra,24(sp)
    8000225e:	6442                	ld	s0,16(sp)
    80002260:	64a2                	ld	s1,8(sp)
    80002262:	6902                	ld	s2,0(sp)
    80002264:	6105                	addi	sp,sp,32
    80002266:	8082                	ret

0000000080002268 <sys_exit>:

int pgaccess(pagetable_t pagetable, uint64 start_va, int page_num, uint64 result_va);

uint64
sys_exit(void)
{
    80002268:	1101                	addi	sp,sp,-32
    8000226a:	ec06                	sd	ra,24(sp)
    8000226c:	e822                	sd	s0,16(sp)
    8000226e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002270:	fec40593          	addi	a1,s0,-20
    80002274:	4501                	li	a0,0
    80002276:	00000097          	auipc	ra,0x0
    8000227a:	f12080e7          	jalr	-238(ra) # 80002188 <argint>
    return -1;
    8000227e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002280:	00054963          	bltz	a0,80002292 <sys_exit+0x2a>
  exit(n);
    80002284:	fec42503          	lw	a0,-20(s0)
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	762080e7          	jalr	1890(ra) # 800019ea <exit>
  return 0;  // not reached
    80002290:	4781                	li	a5,0
}
    80002292:	853e                	mv	a0,a5
    80002294:	60e2                	ld	ra,24(sp)
    80002296:	6442                	ld	s0,16(sp)
    80002298:	6105                	addi	sp,sp,32
    8000229a:	8082                	ret

000000008000229c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000229c:	1141                	addi	sp,sp,-16
    8000229e:	e406                	sd	ra,8(sp)
    800022a0:	e022                	sd	s0,0(sp)
    800022a2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022a4:	fffff097          	auipc	ra,0xfffff
    800022a8:	d70080e7          	jalr	-656(ra) # 80001014 <myproc>
}
    800022ac:	5908                	lw	a0,48(a0)
    800022ae:	60a2                	ld	ra,8(sp)
    800022b0:	6402                	ld	s0,0(sp)
    800022b2:	0141                	addi	sp,sp,16
    800022b4:	8082                	ret

00000000800022b6 <sys_fork>:

uint64
sys_fork(void)
{
    800022b6:	1141                	addi	sp,sp,-16
    800022b8:	e406                	sd	ra,8(sp)
    800022ba:	e022                	sd	s0,0(sp)
    800022bc:	0800                	addi	s0,sp,16
  return fork();
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	1dc080e7          	jalr	476(ra) # 8000149a <fork>
}
    800022c6:	60a2                	ld	ra,8(sp)
    800022c8:	6402                	ld	s0,0(sp)
    800022ca:	0141                	addi	sp,sp,16
    800022cc:	8082                	ret

00000000800022ce <sys_wait>:

uint64
sys_wait(void)
{
    800022ce:	1101                	addi	sp,sp,-32
    800022d0:	ec06                	sd	ra,24(sp)
    800022d2:	e822                	sd	s0,16(sp)
    800022d4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800022d6:	fe840593          	addi	a1,s0,-24
    800022da:	4501                	li	a0,0
    800022dc:	00000097          	auipc	ra,0x0
    800022e0:	ece080e7          	jalr	-306(ra) # 800021aa <argaddr>
    800022e4:	87aa                	mv	a5,a0
    return -1;
    800022e6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800022e8:	0007c863          	bltz	a5,800022f8 <sys_wait+0x2a>
  return wait(p);
    800022ec:	fe843503          	ld	a0,-24(s0)
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	502080e7          	jalr	1282(ra) # 800017f2 <wait>
}
    800022f8:	60e2                	ld	ra,24(sp)
    800022fa:	6442                	ld	s0,16(sp)
    800022fc:	6105                	addi	sp,sp,32
    800022fe:	8082                	ret

0000000080002300 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002300:	7179                	addi	sp,sp,-48
    80002302:	f406                	sd	ra,40(sp)
    80002304:	f022                	sd	s0,32(sp)
    80002306:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002308:	fdc40593          	addi	a1,s0,-36
    8000230c:	4501                	li	a0,0
    8000230e:	00000097          	auipc	ra,0x0
    80002312:	e7a080e7          	jalr	-390(ra) # 80002188 <argint>
    80002316:	87aa                	mv	a5,a0
    return -1;
    80002318:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000231a:	0207c263          	bltz	a5,8000233e <sys_sbrk+0x3e>
    8000231e:	ec26                	sd	s1,24(sp)
  
  addr = myproc()->sz;
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	cf4080e7          	jalr	-780(ra) # 80001014 <myproc>
    80002328:	4d24                	lw	s1,88(a0)
  if(growproc(n) < 0)
    8000232a:	fdc42503          	lw	a0,-36(s0)
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	0f4080e7          	jalr	244(ra) # 80001422 <growproc>
    80002336:	00054863          	bltz	a0,80002346 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000233a:	8526                	mv	a0,s1
    8000233c:	64e2                	ld	s1,24(sp)
}
    8000233e:	70a2                	ld	ra,40(sp)
    80002340:	7402                	ld	s0,32(sp)
    80002342:	6145                	addi	sp,sp,48
    80002344:	8082                	ret
    return -1;
    80002346:	557d                	li	a0,-1
    80002348:	64e2                	ld	s1,24(sp)
    8000234a:	bfd5                	j	8000233e <sys_sbrk+0x3e>

000000008000234c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000234c:	7139                	addi	sp,sp,-64
    8000234e:	fc06                	sd	ra,56(sp)
    80002350:	f822                	sd	s0,48(sp)
    80002352:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002354:	fcc40593          	addi	a1,s0,-52
    80002358:	4501                	li	a0,0
    8000235a:	00000097          	auipc	ra,0x0
    8000235e:	e2e080e7          	jalr	-466(ra) # 80002188 <argint>
    return -1;
    80002362:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002364:	06054b63          	bltz	a0,800023da <sys_sleep+0x8e>
    80002368:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    8000236a:	0000d517          	auipc	a0,0xd
    8000236e:	d1650513          	addi	a0,a0,-746 # 8000f080 <tickslock>
    80002372:	00004097          	auipc	ra,0x4
    80002376:	0f4080e7          	jalr	244(ra) # 80006466 <acquire>
  ticks0 = ticks;
    8000237a:	00007917          	auipc	s2,0x7
    8000237e:	c9e92903          	lw	s2,-866(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002382:	fcc42783          	lw	a5,-52(s0)
    80002386:	c3a1                	beqz	a5,800023c6 <sys_sleep+0x7a>
    80002388:	f426                	sd	s1,40(sp)
    8000238a:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000238c:	0000d997          	auipc	s3,0xd
    80002390:	cf498993          	addi	s3,s3,-780 # 8000f080 <tickslock>
    80002394:	00007497          	auipc	s1,0x7
    80002398:	c8448493          	addi	s1,s1,-892 # 80009018 <ticks>
    if(myproc()->killed){
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	c78080e7          	jalr	-904(ra) # 80001014 <myproc>
    800023a4:	551c                	lw	a5,40(a0)
    800023a6:	ef9d                	bnez	a5,800023e4 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800023a8:	85ce                	mv	a1,s3
    800023aa:	8526                	mv	a0,s1
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	3e2080e7          	jalr	994(ra) # 8000178e <sleep>
  while(ticks - ticks0 < n){
    800023b4:	409c                	lw	a5,0(s1)
    800023b6:	412787bb          	subw	a5,a5,s2
    800023ba:	fcc42703          	lw	a4,-52(s0)
    800023be:	fce7efe3          	bltu	a5,a4,8000239c <sys_sleep+0x50>
    800023c2:	74a2                	ld	s1,40(sp)
    800023c4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800023c6:	0000d517          	auipc	a0,0xd
    800023ca:	cba50513          	addi	a0,a0,-838 # 8000f080 <tickslock>
    800023ce:	00004097          	auipc	ra,0x4
    800023d2:	14c080e7          	jalr	332(ra) # 8000651a <release>
  return 0;
    800023d6:	4781                	li	a5,0
    800023d8:	7902                	ld	s2,32(sp)
}
    800023da:	853e                	mv	a0,a5
    800023dc:	70e2                	ld	ra,56(sp)
    800023de:	7442                	ld	s0,48(sp)
    800023e0:	6121                	addi	sp,sp,64
    800023e2:	8082                	ret
      release(&tickslock);
    800023e4:	0000d517          	auipc	a0,0xd
    800023e8:	c9c50513          	addi	a0,a0,-868 # 8000f080 <tickslock>
    800023ec:	00004097          	auipc	ra,0x4
    800023f0:	12e080e7          	jalr	302(ra) # 8000651a <release>
      return -1;
    800023f4:	57fd                	li	a5,-1
    800023f6:	74a2                	ld	s1,40(sp)
    800023f8:	7902                	ld	s2,32(sp)
    800023fa:	69e2                	ld	s3,24(sp)
    800023fc:	bff9                	j	800023da <sys_sleep+0x8e>

00000000800023fe <sys_kill>:

// 实现 sys_kill
uint64
sys_kill(void)
{
    800023fe:	1101                	addi	sp,sp,-32
    80002400:	ec06                	sd	ra,24(sp)
    80002402:	e822                	sd	s0,16(sp)
    80002404:	1000                	addi	s0,sp,32
    int pid;
    if (argint(0, &pid) < 0)
    80002406:	fec40593          	addi	a1,s0,-20
    8000240a:	4501                	li	a0,0
    8000240c:	00000097          	auipc	ra,0x0
    80002410:	d7c080e7          	jalr	-644(ra) # 80002188 <argint>
    80002414:	87aa                	mv	a5,a0
        return -1;
    80002416:	557d                	li	a0,-1
    if (argint(0, &pid) < 0)
    80002418:	0007c863          	bltz	a5,80002428 <sys_kill+0x2a>
    return kill(pid);
    8000241c:	fec42503          	lw	a0,-20(s0)
    80002420:	fffff097          	auipc	ra,0xfffff
    80002424:	6a0080e7          	jalr	1696(ra) # 80001ac0 <kill>
}
    80002428:	60e2                	ld	ra,24(sp)
    8000242a:	6442                	ld	s0,16(sp)
    8000242c:	6105                	addi	sp,sp,32
    8000242e:	8082                	ret

0000000080002430 <sys_uptime>:

// 实现 sys_uptime
uint64
sys_uptime(void)
{
    80002430:	1101                	addi	sp,sp,-32
    80002432:	ec06                	sd	ra,24(sp)
    80002434:	e822                	sd	s0,16(sp)
    80002436:	e426                	sd	s1,8(sp)
    80002438:	1000                	addi	s0,sp,32
    uint64 xticks;
    acquire(&tickslock);
    8000243a:	0000d517          	auipc	a0,0xd
    8000243e:	c4650513          	addi	a0,a0,-954 # 8000f080 <tickslock>
    80002442:	00004097          	auipc	ra,0x4
    80002446:	024080e7          	jalr	36(ra) # 80006466 <acquire>
    xticks = ticks;
    8000244a:	00007497          	auipc	s1,0x7
    8000244e:	bce4e483          	lwu	s1,-1074(s1) # 80009018 <ticks>
    release(&tickslock);
    80002452:	0000d517          	auipc	a0,0xd
    80002456:	c2e50513          	addi	a0,a0,-978 # 8000f080 <tickslock>
    8000245a:	00004097          	auipc	ra,0x4
    8000245e:	0c0080e7          	jalr	192(ra) # 8000651a <release>
    return xticks;
}
    80002462:	8526                	mv	a0,s1
    80002464:	60e2                	ld	ra,24(sp)
    80002466:	6442                	ld	s0,16(sp)
    80002468:	64a2                	ld	s1,8(sp)
    8000246a:	6105                	addi	sp,sp,32
    8000246c:	8082                	ret

000000008000246e <sys_pgaccess>:

int
sys_pgaccess(void)
{
    8000246e:	7179                	addi	sp,sp,-48
    80002470:	f406                	sd	ra,40(sp)
    80002472:	f022                	sd	s0,32(sp)
    80002474:	1800                	addi	s0,sp,48
  // lab pgtbl: your code here.
  uint64 start_va;
  if(argaddr(0, &start_va) < 0)
    80002476:	fe840593          	addi	a1,s0,-24
    8000247a:	4501                	li	a0,0
    8000247c:	00000097          	auipc	ra,0x0
    80002480:	d2e080e7          	jalr	-722(ra) # 800021aa <argaddr>
    80002484:	04054963          	bltz	a0,800024d6 <sys_pgaccess+0x68>
    return -1;

  int page_num;
  if(argint(1, &page_num) < 0)
    80002488:	fe440593          	addi	a1,s0,-28
    8000248c:	4505                	li	a0,1
    8000248e:	00000097          	auipc	ra,0x0
    80002492:	cfa080e7          	jalr	-774(ra) # 80002188 <argint>
    80002496:	04054263          	bltz	a0,800024da <sys_pgaccess+0x6c>
    return -1;

  uint64 result_va;
  if(argaddr(2, &result_va) < 0)
    8000249a:	fd840593          	addi	a1,s0,-40
    8000249e:	4509                	li	a0,2
    800024a0:	00000097          	auipc	ra,0x0
    800024a4:	d0a080e7          	jalr	-758(ra) # 800021aa <argaddr>
    800024a8:	02054b63          	bltz	a0,800024de <sys_pgaccess+0x70>
    return -1;

  struct proc *p = myproc();
    800024ac:	fffff097          	auipc	ra,0xfffff
    800024b0:	b68080e7          	jalr	-1176(ra) # 80001014 <myproc>
  if(pgaccess(p->pagetable,start_va,page_num,result_va) < 0)
    800024b4:	fd843683          	ld	a3,-40(s0)
    800024b8:	fe442603          	lw	a2,-28(s0)
    800024bc:	fe843583          	ld	a1,-24(s0)
    800024c0:	7128                	ld	a0,96(a0)
    800024c2:	fffff097          	auipc	ra,0xfffff
    800024c6:	908080e7          	jalr	-1784(ra) # 80000dca <pgaccess>
    800024ca:	41f5551b          	sraiw	a0,a0,0x1f
    return -1;

  return 0;
}
    800024ce:	70a2                	ld	ra,40(sp)
    800024d0:	7402                	ld	s0,32(sp)
    800024d2:	6145                	addi	sp,sp,48
    800024d4:	8082                	ret
    return -1;
    800024d6:	557d                	li	a0,-1
    800024d8:	bfdd                	j	800024ce <sys_pgaccess+0x60>
    return -1;
    800024da:	557d                	li	a0,-1
    800024dc:	bfcd                	j	800024ce <sys_pgaccess+0x60>
    return -1;
    800024de:	557d                	li	a0,-1
    800024e0:	b7fd                	j	800024ce <sys_pgaccess+0x60>

00000000800024e2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024e2:	7179                	addi	sp,sp,-48
    800024e4:	f406                	sd	ra,40(sp)
    800024e6:	f022                	sd	s0,32(sp)
    800024e8:	ec26                	sd	s1,24(sp)
    800024ea:	e84a                	sd	s2,16(sp)
    800024ec:	e44e                	sd	s3,8(sp)
    800024ee:	e052                	sd	s4,0(sp)
    800024f0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024f2:	00006597          	auipc	a1,0x6
    800024f6:	ef658593          	addi	a1,a1,-266 # 800083e8 <etext+0x3e8>
    800024fa:	0000d517          	auipc	a0,0xd
    800024fe:	b9e50513          	addi	a0,a0,-1122 # 8000f098 <bcache>
    80002502:	00004097          	auipc	ra,0x4
    80002506:	ed4080e7          	jalr	-300(ra) # 800063d6 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000250a:	00015797          	auipc	a5,0x15
    8000250e:	b8e78793          	addi	a5,a5,-1138 # 80017098 <bcache+0x8000>
    80002512:	00015717          	auipc	a4,0x15
    80002516:	dee70713          	addi	a4,a4,-530 # 80017300 <bcache+0x8268>
    8000251a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000251e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002522:	0000d497          	auipc	s1,0xd
    80002526:	b8e48493          	addi	s1,s1,-1138 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000252a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000252c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000252e:	00006a17          	auipc	s4,0x6
    80002532:	ec2a0a13          	addi	s4,s4,-318 # 800083f0 <etext+0x3f0>
    b->next = bcache.head.next;
    80002536:	2b893783          	ld	a5,696(s2)
    8000253a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000253c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002540:	85d2                	mv	a1,s4
    80002542:	01048513          	addi	a0,s1,16
    80002546:	00001097          	auipc	ra,0x1
    8000254a:	4b2080e7          	jalr	1202(ra) # 800039f8 <initsleeplock>
    bcache.head.next->prev = b;
    8000254e:	2b893783          	ld	a5,696(s2)
    80002552:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002554:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002558:	45848493          	addi	s1,s1,1112
    8000255c:	fd349de3          	bne	s1,s3,80002536 <binit+0x54>
  }
}
    80002560:	70a2                	ld	ra,40(sp)
    80002562:	7402                	ld	s0,32(sp)
    80002564:	64e2                	ld	s1,24(sp)
    80002566:	6942                	ld	s2,16(sp)
    80002568:	69a2                	ld	s3,8(sp)
    8000256a:	6a02                	ld	s4,0(sp)
    8000256c:	6145                	addi	sp,sp,48
    8000256e:	8082                	ret

0000000080002570 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002570:	7179                	addi	sp,sp,-48
    80002572:	f406                	sd	ra,40(sp)
    80002574:	f022                	sd	s0,32(sp)
    80002576:	ec26                	sd	s1,24(sp)
    80002578:	e84a                	sd	s2,16(sp)
    8000257a:	e44e                	sd	s3,8(sp)
    8000257c:	1800                	addi	s0,sp,48
    8000257e:	892a                	mv	s2,a0
    80002580:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002582:	0000d517          	auipc	a0,0xd
    80002586:	b1650513          	addi	a0,a0,-1258 # 8000f098 <bcache>
    8000258a:	00004097          	auipc	ra,0x4
    8000258e:	edc080e7          	jalr	-292(ra) # 80006466 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002592:	00015497          	auipc	s1,0x15
    80002596:	dbe4b483          	ld	s1,-578(s1) # 80017350 <bcache+0x82b8>
    8000259a:	00015797          	auipc	a5,0x15
    8000259e:	d6678793          	addi	a5,a5,-666 # 80017300 <bcache+0x8268>
    800025a2:	02f48f63          	beq	s1,a5,800025e0 <bread+0x70>
    800025a6:	873e                	mv	a4,a5
    800025a8:	a021                	j	800025b0 <bread+0x40>
    800025aa:	68a4                	ld	s1,80(s1)
    800025ac:	02e48a63          	beq	s1,a4,800025e0 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025b0:	449c                	lw	a5,8(s1)
    800025b2:	ff279ce3          	bne	a5,s2,800025aa <bread+0x3a>
    800025b6:	44dc                	lw	a5,12(s1)
    800025b8:	ff3799e3          	bne	a5,s3,800025aa <bread+0x3a>
      b->refcnt++;
    800025bc:	40bc                	lw	a5,64(s1)
    800025be:	2785                	addiw	a5,a5,1
    800025c0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025c2:	0000d517          	auipc	a0,0xd
    800025c6:	ad650513          	addi	a0,a0,-1322 # 8000f098 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	f50080e7          	jalr	-176(ra) # 8000651a <release>
      acquiresleep(&b->lock);
    800025d2:	01048513          	addi	a0,s1,16
    800025d6:	00001097          	auipc	ra,0x1
    800025da:	45c080e7          	jalr	1116(ra) # 80003a32 <acquiresleep>
      return b;
    800025de:	a8b9                	j	8000263c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025e0:	00015497          	auipc	s1,0x15
    800025e4:	d684b483          	ld	s1,-664(s1) # 80017348 <bcache+0x82b0>
    800025e8:	00015797          	auipc	a5,0x15
    800025ec:	d1878793          	addi	a5,a5,-744 # 80017300 <bcache+0x8268>
    800025f0:	00f48863          	beq	s1,a5,80002600 <bread+0x90>
    800025f4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025f6:	40bc                	lw	a5,64(s1)
    800025f8:	cf81                	beqz	a5,80002610 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025fa:	64a4                	ld	s1,72(s1)
    800025fc:	fee49de3          	bne	s1,a4,800025f6 <bread+0x86>
  panic("bget: no buffers");
    80002600:	00006517          	auipc	a0,0x6
    80002604:	df850513          	addi	a0,a0,-520 # 800083f8 <etext+0x3f8>
    80002608:	00004097          	auipc	ra,0x4
    8000260c:	8e4080e7          	jalr	-1820(ra) # 80005eec <panic>
      b->dev = dev;
    80002610:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002614:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002618:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000261c:	4785                	li	a5,1
    8000261e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002620:	0000d517          	auipc	a0,0xd
    80002624:	a7850513          	addi	a0,a0,-1416 # 8000f098 <bcache>
    80002628:	00004097          	auipc	ra,0x4
    8000262c:	ef2080e7          	jalr	-270(ra) # 8000651a <release>
      acquiresleep(&b->lock);
    80002630:	01048513          	addi	a0,s1,16
    80002634:	00001097          	auipc	ra,0x1
    80002638:	3fe080e7          	jalr	1022(ra) # 80003a32 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000263c:	409c                	lw	a5,0(s1)
    8000263e:	cb89                	beqz	a5,80002650 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002640:	8526                	mv	a0,s1
    80002642:	70a2                	ld	ra,40(sp)
    80002644:	7402                	ld	s0,32(sp)
    80002646:	64e2                	ld	s1,24(sp)
    80002648:	6942                	ld	s2,16(sp)
    8000264a:	69a2                	ld	s3,8(sp)
    8000264c:	6145                	addi	sp,sp,48
    8000264e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002650:	4581                	li	a1,0
    80002652:	8526                	mv	a0,s1
    80002654:	00003097          	auipc	ra,0x3
    80002658:	ffe080e7          	jalr	-2(ra) # 80005652 <virtio_disk_rw>
    b->valid = 1;
    8000265c:	4785                	li	a5,1
    8000265e:	c09c                	sw	a5,0(s1)
  return b;
    80002660:	b7c5                	j	80002640 <bread+0xd0>

0000000080002662 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002662:	1101                	addi	sp,sp,-32
    80002664:	ec06                	sd	ra,24(sp)
    80002666:	e822                	sd	s0,16(sp)
    80002668:	e426                	sd	s1,8(sp)
    8000266a:	1000                	addi	s0,sp,32
    8000266c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000266e:	0541                	addi	a0,a0,16
    80002670:	00001097          	auipc	ra,0x1
    80002674:	45c080e7          	jalr	1116(ra) # 80003acc <holdingsleep>
    80002678:	cd01                	beqz	a0,80002690 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000267a:	4585                	li	a1,1
    8000267c:	8526                	mv	a0,s1
    8000267e:	00003097          	auipc	ra,0x3
    80002682:	fd4080e7          	jalr	-44(ra) # 80005652 <virtio_disk_rw>
}
    80002686:	60e2                	ld	ra,24(sp)
    80002688:	6442                	ld	s0,16(sp)
    8000268a:	64a2                	ld	s1,8(sp)
    8000268c:	6105                	addi	sp,sp,32
    8000268e:	8082                	ret
    panic("bwrite");
    80002690:	00006517          	auipc	a0,0x6
    80002694:	d8050513          	addi	a0,a0,-640 # 80008410 <etext+0x410>
    80002698:	00004097          	auipc	ra,0x4
    8000269c:	854080e7          	jalr	-1964(ra) # 80005eec <panic>

00000000800026a0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026a0:	1101                	addi	sp,sp,-32
    800026a2:	ec06                	sd	ra,24(sp)
    800026a4:	e822                	sd	s0,16(sp)
    800026a6:	e426                	sd	s1,8(sp)
    800026a8:	e04a                	sd	s2,0(sp)
    800026aa:	1000                	addi	s0,sp,32
    800026ac:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026ae:	01050913          	addi	s2,a0,16
    800026b2:	854a                	mv	a0,s2
    800026b4:	00001097          	auipc	ra,0x1
    800026b8:	418080e7          	jalr	1048(ra) # 80003acc <holdingsleep>
    800026bc:	c925                	beqz	a0,8000272c <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800026be:	854a                	mv	a0,s2
    800026c0:	00001097          	auipc	ra,0x1
    800026c4:	3c8080e7          	jalr	968(ra) # 80003a88 <releasesleep>

  acquire(&bcache.lock);
    800026c8:	0000d517          	auipc	a0,0xd
    800026cc:	9d050513          	addi	a0,a0,-1584 # 8000f098 <bcache>
    800026d0:	00004097          	auipc	ra,0x4
    800026d4:	d96080e7          	jalr	-618(ra) # 80006466 <acquire>
  b->refcnt--;
    800026d8:	40bc                	lw	a5,64(s1)
    800026da:	37fd                	addiw	a5,a5,-1
    800026dc:	0007871b          	sext.w	a4,a5
    800026e0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026e2:	e71d                	bnez	a4,80002710 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026e4:	68b8                	ld	a4,80(s1)
    800026e6:	64bc                	ld	a5,72(s1)
    800026e8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800026ea:	68b8                	ld	a4,80(s1)
    800026ec:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026ee:	00015797          	auipc	a5,0x15
    800026f2:	9aa78793          	addi	a5,a5,-1622 # 80017098 <bcache+0x8000>
    800026f6:	2b87b703          	ld	a4,696(a5)
    800026fa:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026fc:	00015717          	auipc	a4,0x15
    80002700:	c0470713          	addi	a4,a4,-1020 # 80017300 <bcache+0x8268>
    80002704:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002706:	2b87b703          	ld	a4,696(a5)
    8000270a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000270c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002710:	0000d517          	auipc	a0,0xd
    80002714:	98850513          	addi	a0,a0,-1656 # 8000f098 <bcache>
    80002718:	00004097          	auipc	ra,0x4
    8000271c:	e02080e7          	jalr	-510(ra) # 8000651a <release>
}
    80002720:	60e2                	ld	ra,24(sp)
    80002722:	6442                	ld	s0,16(sp)
    80002724:	64a2                	ld	s1,8(sp)
    80002726:	6902                	ld	s2,0(sp)
    80002728:	6105                	addi	sp,sp,32
    8000272a:	8082                	ret
    panic("brelse");
    8000272c:	00006517          	auipc	a0,0x6
    80002730:	cec50513          	addi	a0,a0,-788 # 80008418 <etext+0x418>
    80002734:	00003097          	auipc	ra,0x3
    80002738:	7b8080e7          	jalr	1976(ra) # 80005eec <panic>

000000008000273c <bpin>:

void
bpin(struct buf *b) {
    8000273c:	1101                	addi	sp,sp,-32
    8000273e:	ec06                	sd	ra,24(sp)
    80002740:	e822                	sd	s0,16(sp)
    80002742:	e426                	sd	s1,8(sp)
    80002744:	1000                	addi	s0,sp,32
    80002746:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002748:	0000d517          	auipc	a0,0xd
    8000274c:	95050513          	addi	a0,a0,-1712 # 8000f098 <bcache>
    80002750:	00004097          	auipc	ra,0x4
    80002754:	d16080e7          	jalr	-746(ra) # 80006466 <acquire>
  b->refcnt++;
    80002758:	40bc                	lw	a5,64(s1)
    8000275a:	2785                	addiw	a5,a5,1
    8000275c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000275e:	0000d517          	auipc	a0,0xd
    80002762:	93a50513          	addi	a0,a0,-1734 # 8000f098 <bcache>
    80002766:	00004097          	auipc	ra,0x4
    8000276a:	db4080e7          	jalr	-588(ra) # 8000651a <release>
}
    8000276e:	60e2                	ld	ra,24(sp)
    80002770:	6442                	ld	s0,16(sp)
    80002772:	64a2                	ld	s1,8(sp)
    80002774:	6105                	addi	sp,sp,32
    80002776:	8082                	ret

0000000080002778 <bunpin>:

void
bunpin(struct buf *b) {
    80002778:	1101                	addi	sp,sp,-32
    8000277a:	ec06                	sd	ra,24(sp)
    8000277c:	e822                	sd	s0,16(sp)
    8000277e:	e426                	sd	s1,8(sp)
    80002780:	1000                	addi	s0,sp,32
    80002782:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002784:	0000d517          	auipc	a0,0xd
    80002788:	91450513          	addi	a0,a0,-1772 # 8000f098 <bcache>
    8000278c:	00004097          	auipc	ra,0x4
    80002790:	cda080e7          	jalr	-806(ra) # 80006466 <acquire>
  b->refcnt--;
    80002794:	40bc                	lw	a5,64(s1)
    80002796:	37fd                	addiw	a5,a5,-1
    80002798:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000279a:	0000d517          	auipc	a0,0xd
    8000279e:	8fe50513          	addi	a0,a0,-1794 # 8000f098 <bcache>
    800027a2:	00004097          	auipc	ra,0x4
    800027a6:	d78080e7          	jalr	-648(ra) # 8000651a <release>
}
    800027aa:	60e2                	ld	ra,24(sp)
    800027ac:	6442                	ld	s0,16(sp)
    800027ae:	64a2                	ld	s1,8(sp)
    800027b0:	6105                	addi	sp,sp,32
    800027b2:	8082                	ret

00000000800027b4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027b4:	1101                	addi	sp,sp,-32
    800027b6:	ec06                	sd	ra,24(sp)
    800027b8:	e822                	sd	s0,16(sp)
    800027ba:	e426                	sd	s1,8(sp)
    800027bc:	e04a                	sd	s2,0(sp)
    800027be:	1000                	addi	s0,sp,32
    800027c0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027c2:	00d5d59b          	srliw	a1,a1,0xd
    800027c6:	00015797          	auipc	a5,0x15
    800027ca:	fae7a783          	lw	a5,-82(a5) # 80017774 <sb+0x1c>
    800027ce:	9dbd                	addw	a1,a1,a5
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	da0080e7          	jalr	-608(ra) # 80002570 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027d8:	0074f713          	andi	a4,s1,7
    800027dc:	4785                	li	a5,1
    800027de:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027e2:	14ce                	slli	s1,s1,0x33
    800027e4:	90d9                	srli	s1,s1,0x36
    800027e6:	00950733          	add	a4,a0,s1
    800027ea:	05874703          	lbu	a4,88(a4)
    800027ee:	00e7f6b3          	and	a3,a5,a4
    800027f2:	c69d                	beqz	a3,80002820 <bfree+0x6c>
    800027f4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027f6:	94aa                	add	s1,s1,a0
    800027f8:	fff7c793          	not	a5,a5
    800027fc:	8f7d                	and	a4,a4,a5
    800027fe:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002802:	00001097          	auipc	ra,0x1
    80002806:	112080e7          	jalr	274(ra) # 80003914 <log_write>
  brelse(bp);
    8000280a:	854a                	mv	a0,s2
    8000280c:	00000097          	auipc	ra,0x0
    80002810:	e94080e7          	jalr	-364(ra) # 800026a0 <brelse>
}
    80002814:	60e2                	ld	ra,24(sp)
    80002816:	6442                	ld	s0,16(sp)
    80002818:	64a2                	ld	s1,8(sp)
    8000281a:	6902                	ld	s2,0(sp)
    8000281c:	6105                	addi	sp,sp,32
    8000281e:	8082                	ret
    panic("freeing free block");
    80002820:	00006517          	auipc	a0,0x6
    80002824:	c0050513          	addi	a0,a0,-1024 # 80008420 <etext+0x420>
    80002828:	00003097          	auipc	ra,0x3
    8000282c:	6c4080e7          	jalr	1732(ra) # 80005eec <panic>

0000000080002830 <balloc>:
{
    80002830:	711d                	addi	sp,sp,-96
    80002832:	ec86                	sd	ra,88(sp)
    80002834:	e8a2                	sd	s0,80(sp)
    80002836:	e4a6                	sd	s1,72(sp)
    80002838:	e0ca                	sd	s2,64(sp)
    8000283a:	fc4e                	sd	s3,56(sp)
    8000283c:	f852                	sd	s4,48(sp)
    8000283e:	f456                	sd	s5,40(sp)
    80002840:	f05a                	sd	s6,32(sp)
    80002842:	ec5e                	sd	s7,24(sp)
    80002844:	e862                	sd	s8,16(sp)
    80002846:	e466                	sd	s9,8(sp)
    80002848:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000284a:	00015797          	auipc	a5,0x15
    8000284e:	f127a783          	lw	a5,-238(a5) # 8001775c <sb+0x4>
    80002852:	cbc1                	beqz	a5,800028e2 <balloc+0xb2>
    80002854:	8baa                	mv	s7,a0
    80002856:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002858:	00015b17          	auipc	s6,0x15
    8000285c:	f00b0b13          	addi	s6,s6,-256 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002860:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002862:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002864:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002866:	6c89                	lui	s9,0x2
    80002868:	a831                	j	80002884 <balloc+0x54>
    brelse(bp);
    8000286a:	854a                	mv	a0,s2
    8000286c:	00000097          	auipc	ra,0x0
    80002870:	e34080e7          	jalr	-460(ra) # 800026a0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002874:	015c87bb          	addw	a5,s9,s5
    80002878:	00078a9b          	sext.w	s5,a5
    8000287c:	004b2703          	lw	a4,4(s6)
    80002880:	06eaf163          	bgeu	s5,a4,800028e2 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002884:	41fad79b          	sraiw	a5,s5,0x1f
    80002888:	0137d79b          	srliw	a5,a5,0x13
    8000288c:	015787bb          	addw	a5,a5,s5
    80002890:	40d7d79b          	sraiw	a5,a5,0xd
    80002894:	01cb2583          	lw	a1,28(s6)
    80002898:	9dbd                	addw	a1,a1,a5
    8000289a:	855e                	mv	a0,s7
    8000289c:	00000097          	auipc	ra,0x0
    800028a0:	cd4080e7          	jalr	-812(ra) # 80002570 <bread>
    800028a4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028a6:	004b2503          	lw	a0,4(s6)
    800028aa:	000a849b          	sext.w	s1,s5
    800028ae:	8762                	mv	a4,s8
    800028b0:	faa4fde3          	bgeu	s1,a0,8000286a <balloc+0x3a>
      m = 1 << (bi % 8);
    800028b4:	00777693          	andi	a3,a4,7
    800028b8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028bc:	41f7579b          	sraiw	a5,a4,0x1f
    800028c0:	01d7d79b          	srliw	a5,a5,0x1d
    800028c4:	9fb9                	addw	a5,a5,a4
    800028c6:	4037d79b          	sraiw	a5,a5,0x3
    800028ca:	00f90633          	add	a2,s2,a5
    800028ce:	05864603          	lbu	a2,88(a2)
    800028d2:	00c6f5b3          	and	a1,a3,a2
    800028d6:	cd91                	beqz	a1,800028f2 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028d8:	2705                	addiw	a4,a4,1
    800028da:	2485                	addiw	s1,s1,1
    800028dc:	fd471ae3          	bne	a4,s4,800028b0 <balloc+0x80>
    800028e0:	b769                	j	8000286a <balloc+0x3a>
  panic("balloc: out of blocks");
    800028e2:	00006517          	auipc	a0,0x6
    800028e6:	b5650513          	addi	a0,a0,-1194 # 80008438 <etext+0x438>
    800028ea:	00003097          	auipc	ra,0x3
    800028ee:	602080e7          	jalr	1538(ra) # 80005eec <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028f2:	97ca                	add	a5,a5,s2
    800028f4:	8e55                	or	a2,a2,a3
    800028f6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028fa:	854a                	mv	a0,s2
    800028fc:	00001097          	auipc	ra,0x1
    80002900:	018080e7          	jalr	24(ra) # 80003914 <log_write>
        brelse(bp);
    80002904:	854a                	mv	a0,s2
    80002906:	00000097          	auipc	ra,0x0
    8000290a:	d9a080e7          	jalr	-614(ra) # 800026a0 <brelse>
  bp = bread(dev, bno);
    8000290e:	85a6                	mv	a1,s1
    80002910:	855e                	mv	a0,s7
    80002912:	00000097          	auipc	ra,0x0
    80002916:	c5e080e7          	jalr	-930(ra) # 80002570 <bread>
    8000291a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000291c:	40000613          	li	a2,1024
    80002920:	4581                	li	a1,0
    80002922:	05850513          	addi	a0,a0,88
    80002926:	ffffe097          	auipc	ra,0xffffe
    8000292a:	854080e7          	jalr	-1964(ra) # 8000017a <memset>
  log_write(bp);
    8000292e:	854a                	mv	a0,s2
    80002930:	00001097          	auipc	ra,0x1
    80002934:	fe4080e7          	jalr	-28(ra) # 80003914 <log_write>
  brelse(bp);
    80002938:	854a                	mv	a0,s2
    8000293a:	00000097          	auipc	ra,0x0
    8000293e:	d66080e7          	jalr	-666(ra) # 800026a0 <brelse>
}
    80002942:	8526                	mv	a0,s1
    80002944:	60e6                	ld	ra,88(sp)
    80002946:	6446                	ld	s0,80(sp)
    80002948:	64a6                	ld	s1,72(sp)
    8000294a:	6906                	ld	s2,64(sp)
    8000294c:	79e2                	ld	s3,56(sp)
    8000294e:	7a42                	ld	s4,48(sp)
    80002950:	7aa2                	ld	s5,40(sp)
    80002952:	7b02                	ld	s6,32(sp)
    80002954:	6be2                	ld	s7,24(sp)
    80002956:	6c42                	ld	s8,16(sp)
    80002958:	6ca2                	ld	s9,8(sp)
    8000295a:	6125                	addi	sp,sp,96
    8000295c:	8082                	ret

000000008000295e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000295e:	7179                	addi	sp,sp,-48
    80002960:	f406                	sd	ra,40(sp)
    80002962:	f022                	sd	s0,32(sp)
    80002964:	ec26                	sd	s1,24(sp)
    80002966:	e84a                	sd	s2,16(sp)
    80002968:	e44e                	sd	s3,8(sp)
    8000296a:	1800                	addi	s0,sp,48
    8000296c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000296e:	47ad                	li	a5,11
    80002970:	04b7ff63          	bgeu	a5,a1,800029ce <bmap+0x70>
    80002974:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002976:	ff45849b          	addiw	s1,a1,-12
    8000297a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000297e:	0ff00793          	li	a5,255
    80002982:	0ae7e463          	bltu	a5,a4,80002a2a <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002986:	08052583          	lw	a1,128(a0)
    8000298a:	c5b5                	beqz	a1,800029f6 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000298c:	00092503          	lw	a0,0(s2)
    80002990:	00000097          	auipc	ra,0x0
    80002994:	be0080e7          	jalr	-1056(ra) # 80002570 <bread>
    80002998:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000299a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000299e:	02049713          	slli	a4,s1,0x20
    800029a2:	01e75593          	srli	a1,a4,0x1e
    800029a6:	00b784b3          	add	s1,a5,a1
    800029aa:	0004a983          	lw	s3,0(s1)
    800029ae:	04098e63          	beqz	s3,80002a0a <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029b2:	8552                	mv	a0,s4
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	cec080e7          	jalr	-788(ra) # 800026a0 <brelse>
    return addr;
    800029bc:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800029be:	854e                	mv	a0,s3
    800029c0:	70a2                	ld	ra,40(sp)
    800029c2:	7402                	ld	s0,32(sp)
    800029c4:	64e2                	ld	s1,24(sp)
    800029c6:	6942                	ld	s2,16(sp)
    800029c8:	69a2                	ld	s3,8(sp)
    800029ca:	6145                	addi	sp,sp,48
    800029cc:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029ce:	02059793          	slli	a5,a1,0x20
    800029d2:	01e7d593          	srli	a1,a5,0x1e
    800029d6:	00b504b3          	add	s1,a0,a1
    800029da:	0504a983          	lw	s3,80(s1)
    800029de:	fe0990e3          	bnez	s3,800029be <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029e2:	4108                	lw	a0,0(a0)
    800029e4:	00000097          	auipc	ra,0x0
    800029e8:	e4c080e7          	jalr	-436(ra) # 80002830 <balloc>
    800029ec:	0005099b          	sext.w	s3,a0
    800029f0:	0534a823          	sw	s3,80(s1)
    800029f4:	b7e9                	j	800029be <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029f6:	4108                	lw	a0,0(a0)
    800029f8:	00000097          	auipc	ra,0x0
    800029fc:	e38080e7          	jalr	-456(ra) # 80002830 <balloc>
    80002a00:	0005059b          	sext.w	a1,a0
    80002a04:	08b92023          	sw	a1,128(s2)
    80002a08:	b751                	j	8000298c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a0a:	00092503          	lw	a0,0(s2)
    80002a0e:	00000097          	auipc	ra,0x0
    80002a12:	e22080e7          	jalr	-478(ra) # 80002830 <balloc>
    80002a16:	0005099b          	sext.w	s3,a0
    80002a1a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a1e:	8552                	mv	a0,s4
    80002a20:	00001097          	auipc	ra,0x1
    80002a24:	ef4080e7          	jalr	-268(ra) # 80003914 <log_write>
    80002a28:	b769                	j	800029b2 <bmap+0x54>
  panic("bmap: out of range");
    80002a2a:	00006517          	auipc	a0,0x6
    80002a2e:	a2650513          	addi	a0,a0,-1498 # 80008450 <etext+0x450>
    80002a32:	00003097          	auipc	ra,0x3
    80002a36:	4ba080e7          	jalr	1210(ra) # 80005eec <panic>

0000000080002a3a <iget>:
{
    80002a3a:	7179                	addi	sp,sp,-48
    80002a3c:	f406                	sd	ra,40(sp)
    80002a3e:	f022                	sd	s0,32(sp)
    80002a40:	ec26                	sd	s1,24(sp)
    80002a42:	e84a                	sd	s2,16(sp)
    80002a44:	e44e                	sd	s3,8(sp)
    80002a46:	e052                	sd	s4,0(sp)
    80002a48:	1800                	addi	s0,sp,48
    80002a4a:	89aa                	mv	s3,a0
    80002a4c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a4e:	00015517          	auipc	a0,0x15
    80002a52:	d2a50513          	addi	a0,a0,-726 # 80017778 <itable>
    80002a56:	00004097          	auipc	ra,0x4
    80002a5a:	a10080e7          	jalr	-1520(ra) # 80006466 <acquire>
  empty = 0;
    80002a5e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a60:	00015497          	auipc	s1,0x15
    80002a64:	d3048493          	addi	s1,s1,-720 # 80017790 <itable+0x18>
    80002a68:	00016697          	auipc	a3,0x16
    80002a6c:	7b868693          	addi	a3,a3,1976 # 80019220 <log>
    80002a70:	a039                	j	80002a7e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a72:	02090b63          	beqz	s2,80002aa8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a76:	08848493          	addi	s1,s1,136
    80002a7a:	02d48a63          	beq	s1,a3,80002aae <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a7e:	449c                	lw	a5,8(s1)
    80002a80:	fef059e3          	blez	a5,80002a72 <iget+0x38>
    80002a84:	4098                	lw	a4,0(s1)
    80002a86:	ff3716e3          	bne	a4,s3,80002a72 <iget+0x38>
    80002a8a:	40d8                	lw	a4,4(s1)
    80002a8c:	ff4713e3          	bne	a4,s4,80002a72 <iget+0x38>
      ip->ref++;
    80002a90:	2785                	addiw	a5,a5,1
    80002a92:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a94:	00015517          	auipc	a0,0x15
    80002a98:	ce450513          	addi	a0,a0,-796 # 80017778 <itable>
    80002a9c:	00004097          	auipc	ra,0x4
    80002aa0:	a7e080e7          	jalr	-1410(ra) # 8000651a <release>
      return ip;
    80002aa4:	8926                	mv	s2,s1
    80002aa6:	a03d                	j	80002ad4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aa8:	f7f9                	bnez	a5,80002a76 <iget+0x3c>
      empty = ip;
    80002aaa:	8926                	mv	s2,s1
    80002aac:	b7e9                	j	80002a76 <iget+0x3c>
  if(empty == 0)
    80002aae:	02090c63          	beqz	s2,80002ae6 <iget+0xac>
  ip->dev = dev;
    80002ab2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ab6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aba:	4785                	li	a5,1
    80002abc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ac0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ac4:	00015517          	auipc	a0,0x15
    80002ac8:	cb450513          	addi	a0,a0,-844 # 80017778 <itable>
    80002acc:	00004097          	auipc	ra,0x4
    80002ad0:	a4e080e7          	jalr	-1458(ra) # 8000651a <release>
}
    80002ad4:	854a                	mv	a0,s2
    80002ad6:	70a2                	ld	ra,40(sp)
    80002ad8:	7402                	ld	s0,32(sp)
    80002ada:	64e2                	ld	s1,24(sp)
    80002adc:	6942                	ld	s2,16(sp)
    80002ade:	69a2                	ld	s3,8(sp)
    80002ae0:	6a02                	ld	s4,0(sp)
    80002ae2:	6145                	addi	sp,sp,48
    80002ae4:	8082                	ret
    panic("iget: no inodes");
    80002ae6:	00006517          	auipc	a0,0x6
    80002aea:	98250513          	addi	a0,a0,-1662 # 80008468 <etext+0x468>
    80002aee:	00003097          	auipc	ra,0x3
    80002af2:	3fe080e7          	jalr	1022(ra) # 80005eec <panic>

0000000080002af6 <fsinit>:
fsinit(int dev) {
    80002af6:	7179                	addi	sp,sp,-48
    80002af8:	f406                	sd	ra,40(sp)
    80002afa:	f022                	sd	s0,32(sp)
    80002afc:	ec26                	sd	s1,24(sp)
    80002afe:	e84a                	sd	s2,16(sp)
    80002b00:	e44e                	sd	s3,8(sp)
    80002b02:	1800                	addi	s0,sp,48
    80002b04:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b06:	4585                	li	a1,1
    80002b08:	00000097          	auipc	ra,0x0
    80002b0c:	a68080e7          	jalr	-1432(ra) # 80002570 <bread>
    80002b10:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b12:	00015997          	auipc	s3,0x15
    80002b16:	c4698993          	addi	s3,s3,-954 # 80017758 <sb>
    80002b1a:	02000613          	li	a2,32
    80002b1e:	05850593          	addi	a1,a0,88
    80002b22:	854e                	mv	a0,s3
    80002b24:	ffffd097          	auipc	ra,0xffffd
    80002b28:	6b2080e7          	jalr	1714(ra) # 800001d6 <memmove>
  brelse(bp);
    80002b2c:	8526                	mv	a0,s1
    80002b2e:	00000097          	auipc	ra,0x0
    80002b32:	b72080e7          	jalr	-1166(ra) # 800026a0 <brelse>
  if(sb.magic != FSMAGIC)
    80002b36:	0009a703          	lw	a4,0(s3)
    80002b3a:	102037b7          	lui	a5,0x10203
    80002b3e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b42:	02f71263          	bne	a4,a5,80002b66 <fsinit+0x70>
  initlog(dev, &sb);
    80002b46:	00015597          	auipc	a1,0x15
    80002b4a:	c1258593          	addi	a1,a1,-1006 # 80017758 <sb>
    80002b4e:	854a                	mv	a0,s2
    80002b50:	00001097          	auipc	ra,0x1
    80002b54:	b54080e7          	jalr	-1196(ra) # 800036a4 <initlog>
}
    80002b58:	70a2                	ld	ra,40(sp)
    80002b5a:	7402                	ld	s0,32(sp)
    80002b5c:	64e2                	ld	s1,24(sp)
    80002b5e:	6942                	ld	s2,16(sp)
    80002b60:	69a2                	ld	s3,8(sp)
    80002b62:	6145                	addi	sp,sp,48
    80002b64:	8082                	ret
    panic("invalid file system");
    80002b66:	00006517          	auipc	a0,0x6
    80002b6a:	91250513          	addi	a0,a0,-1774 # 80008478 <etext+0x478>
    80002b6e:	00003097          	auipc	ra,0x3
    80002b72:	37e080e7          	jalr	894(ra) # 80005eec <panic>

0000000080002b76 <iinit>:
{
    80002b76:	7179                	addi	sp,sp,-48
    80002b78:	f406                	sd	ra,40(sp)
    80002b7a:	f022                	sd	s0,32(sp)
    80002b7c:	ec26                	sd	s1,24(sp)
    80002b7e:	e84a                	sd	s2,16(sp)
    80002b80:	e44e                	sd	s3,8(sp)
    80002b82:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b84:	00006597          	auipc	a1,0x6
    80002b88:	90c58593          	addi	a1,a1,-1780 # 80008490 <etext+0x490>
    80002b8c:	00015517          	auipc	a0,0x15
    80002b90:	bec50513          	addi	a0,a0,-1044 # 80017778 <itable>
    80002b94:	00004097          	auipc	ra,0x4
    80002b98:	842080e7          	jalr	-1982(ra) # 800063d6 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b9c:	00015497          	auipc	s1,0x15
    80002ba0:	c0448493          	addi	s1,s1,-1020 # 800177a0 <itable+0x28>
    80002ba4:	00016997          	auipc	s3,0x16
    80002ba8:	68c98993          	addi	s3,s3,1676 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bac:	00006917          	auipc	s2,0x6
    80002bb0:	8ec90913          	addi	s2,s2,-1812 # 80008498 <etext+0x498>
    80002bb4:	85ca                	mv	a1,s2
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	00001097          	auipc	ra,0x1
    80002bbc:	e40080e7          	jalr	-448(ra) # 800039f8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bc0:	08848493          	addi	s1,s1,136
    80002bc4:	ff3498e3          	bne	s1,s3,80002bb4 <iinit+0x3e>
}
    80002bc8:	70a2                	ld	ra,40(sp)
    80002bca:	7402                	ld	s0,32(sp)
    80002bcc:	64e2                	ld	s1,24(sp)
    80002bce:	6942                	ld	s2,16(sp)
    80002bd0:	69a2                	ld	s3,8(sp)
    80002bd2:	6145                	addi	sp,sp,48
    80002bd4:	8082                	ret

0000000080002bd6 <ialloc>:
{
    80002bd6:	7139                	addi	sp,sp,-64
    80002bd8:	fc06                	sd	ra,56(sp)
    80002bda:	f822                	sd	s0,48(sp)
    80002bdc:	f426                	sd	s1,40(sp)
    80002bde:	f04a                	sd	s2,32(sp)
    80002be0:	ec4e                	sd	s3,24(sp)
    80002be2:	e852                	sd	s4,16(sp)
    80002be4:	e456                	sd	s5,8(sp)
    80002be6:	e05a                	sd	s6,0(sp)
    80002be8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bea:	00015717          	auipc	a4,0x15
    80002bee:	b7a72703          	lw	a4,-1158(a4) # 80017764 <sb+0xc>
    80002bf2:	4785                	li	a5,1
    80002bf4:	04e7f863          	bgeu	a5,a4,80002c44 <ialloc+0x6e>
    80002bf8:	8aaa                	mv	s5,a0
    80002bfa:	8b2e                	mv	s6,a1
    80002bfc:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bfe:	00015a17          	auipc	s4,0x15
    80002c02:	b5aa0a13          	addi	s4,s4,-1190 # 80017758 <sb>
    80002c06:	00495593          	srli	a1,s2,0x4
    80002c0a:	018a2783          	lw	a5,24(s4)
    80002c0e:	9dbd                	addw	a1,a1,a5
    80002c10:	8556                	mv	a0,s5
    80002c12:	00000097          	auipc	ra,0x0
    80002c16:	95e080e7          	jalr	-1698(ra) # 80002570 <bread>
    80002c1a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c1c:	05850993          	addi	s3,a0,88
    80002c20:	00f97793          	andi	a5,s2,15
    80002c24:	079a                	slli	a5,a5,0x6
    80002c26:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c28:	00099783          	lh	a5,0(s3)
    80002c2c:	c785                	beqz	a5,80002c54 <ialloc+0x7e>
    brelse(bp);
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	a72080e7          	jalr	-1422(ra) # 800026a0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c36:	0905                	addi	s2,s2,1
    80002c38:	00ca2703          	lw	a4,12(s4)
    80002c3c:	0009079b          	sext.w	a5,s2
    80002c40:	fce7e3e3          	bltu	a5,a4,80002c06 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002c44:	00006517          	auipc	a0,0x6
    80002c48:	85c50513          	addi	a0,a0,-1956 # 800084a0 <etext+0x4a0>
    80002c4c:	00003097          	auipc	ra,0x3
    80002c50:	2a0080e7          	jalr	672(ra) # 80005eec <panic>
      memset(dip, 0, sizeof(*dip));
    80002c54:	04000613          	li	a2,64
    80002c58:	4581                	li	a1,0
    80002c5a:	854e                	mv	a0,s3
    80002c5c:	ffffd097          	auipc	ra,0xffffd
    80002c60:	51e080e7          	jalr	1310(ra) # 8000017a <memset>
      dip->type = type;
    80002c64:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c68:	8526                	mv	a0,s1
    80002c6a:	00001097          	auipc	ra,0x1
    80002c6e:	caa080e7          	jalr	-854(ra) # 80003914 <log_write>
      brelse(bp);
    80002c72:	8526                	mv	a0,s1
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	a2c080e7          	jalr	-1492(ra) # 800026a0 <brelse>
      return iget(dev, inum);
    80002c7c:	0009059b          	sext.w	a1,s2
    80002c80:	8556                	mv	a0,s5
    80002c82:	00000097          	auipc	ra,0x0
    80002c86:	db8080e7          	jalr	-584(ra) # 80002a3a <iget>
}
    80002c8a:	70e2                	ld	ra,56(sp)
    80002c8c:	7442                	ld	s0,48(sp)
    80002c8e:	74a2                	ld	s1,40(sp)
    80002c90:	7902                	ld	s2,32(sp)
    80002c92:	69e2                	ld	s3,24(sp)
    80002c94:	6a42                	ld	s4,16(sp)
    80002c96:	6aa2                	ld	s5,8(sp)
    80002c98:	6b02                	ld	s6,0(sp)
    80002c9a:	6121                	addi	sp,sp,64
    80002c9c:	8082                	ret

0000000080002c9e <iupdate>:
{
    80002c9e:	1101                	addi	sp,sp,-32
    80002ca0:	ec06                	sd	ra,24(sp)
    80002ca2:	e822                	sd	s0,16(sp)
    80002ca4:	e426                	sd	s1,8(sp)
    80002ca6:	e04a                	sd	s2,0(sp)
    80002ca8:	1000                	addi	s0,sp,32
    80002caa:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cac:	415c                	lw	a5,4(a0)
    80002cae:	0047d79b          	srliw	a5,a5,0x4
    80002cb2:	00015597          	auipc	a1,0x15
    80002cb6:	abe5a583          	lw	a1,-1346(a1) # 80017770 <sb+0x18>
    80002cba:	9dbd                	addw	a1,a1,a5
    80002cbc:	4108                	lw	a0,0(a0)
    80002cbe:	00000097          	auipc	ra,0x0
    80002cc2:	8b2080e7          	jalr	-1870(ra) # 80002570 <bread>
    80002cc6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cc8:	05850793          	addi	a5,a0,88
    80002ccc:	40d8                	lw	a4,4(s1)
    80002cce:	8b3d                	andi	a4,a4,15
    80002cd0:	071a                	slli	a4,a4,0x6
    80002cd2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002cd4:	04449703          	lh	a4,68(s1)
    80002cd8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002cdc:	04649703          	lh	a4,70(s1)
    80002ce0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ce4:	04849703          	lh	a4,72(s1)
    80002ce8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cec:	04a49703          	lh	a4,74(s1)
    80002cf0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cf4:	44f8                	lw	a4,76(s1)
    80002cf6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cf8:	03400613          	li	a2,52
    80002cfc:	05048593          	addi	a1,s1,80
    80002d00:	00c78513          	addi	a0,a5,12
    80002d04:	ffffd097          	auipc	ra,0xffffd
    80002d08:	4d2080e7          	jalr	1234(ra) # 800001d6 <memmove>
  log_write(bp);
    80002d0c:	854a                	mv	a0,s2
    80002d0e:	00001097          	auipc	ra,0x1
    80002d12:	c06080e7          	jalr	-1018(ra) # 80003914 <log_write>
  brelse(bp);
    80002d16:	854a                	mv	a0,s2
    80002d18:	00000097          	auipc	ra,0x0
    80002d1c:	988080e7          	jalr	-1656(ra) # 800026a0 <brelse>
}
    80002d20:	60e2                	ld	ra,24(sp)
    80002d22:	6442                	ld	s0,16(sp)
    80002d24:	64a2                	ld	s1,8(sp)
    80002d26:	6902                	ld	s2,0(sp)
    80002d28:	6105                	addi	sp,sp,32
    80002d2a:	8082                	ret

0000000080002d2c <idup>:
{
    80002d2c:	1101                	addi	sp,sp,-32
    80002d2e:	ec06                	sd	ra,24(sp)
    80002d30:	e822                	sd	s0,16(sp)
    80002d32:	e426                	sd	s1,8(sp)
    80002d34:	1000                	addi	s0,sp,32
    80002d36:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d38:	00015517          	auipc	a0,0x15
    80002d3c:	a4050513          	addi	a0,a0,-1472 # 80017778 <itable>
    80002d40:	00003097          	auipc	ra,0x3
    80002d44:	726080e7          	jalr	1830(ra) # 80006466 <acquire>
  ip->ref++;
    80002d48:	449c                	lw	a5,8(s1)
    80002d4a:	2785                	addiw	a5,a5,1
    80002d4c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d4e:	00015517          	auipc	a0,0x15
    80002d52:	a2a50513          	addi	a0,a0,-1494 # 80017778 <itable>
    80002d56:	00003097          	auipc	ra,0x3
    80002d5a:	7c4080e7          	jalr	1988(ra) # 8000651a <release>
}
    80002d5e:	8526                	mv	a0,s1
    80002d60:	60e2                	ld	ra,24(sp)
    80002d62:	6442                	ld	s0,16(sp)
    80002d64:	64a2                	ld	s1,8(sp)
    80002d66:	6105                	addi	sp,sp,32
    80002d68:	8082                	ret

0000000080002d6a <ilock>:
{
    80002d6a:	1101                	addi	sp,sp,-32
    80002d6c:	ec06                	sd	ra,24(sp)
    80002d6e:	e822                	sd	s0,16(sp)
    80002d70:	e426                	sd	s1,8(sp)
    80002d72:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d74:	c10d                	beqz	a0,80002d96 <ilock+0x2c>
    80002d76:	84aa                	mv	s1,a0
    80002d78:	451c                	lw	a5,8(a0)
    80002d7a:	00f05e63          	blez	a5,80002d96 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002d7e:	0541                	addi	a0,a0,16
    80002d80:	00001097          	auipc	ra,0x1
    80002d84:	cb2080e7          	jalr	-846(ra) # 80003a32 <acquiresleep>
  if(ip->valid == 0){
    80002d88:	40bc                	lw	a5,64(s1)
    80002d8a:	cf99                	beqz	a5,80002da8 <ilock+0x3e>
}
    80002d8c:	60e2                	ld	ra,24(sp)
    80002d8e:	6442                	ld	s0,16(sp)
    80002d90:	64a2                	ld	s1,8(sp)
    80002d92:	6105                	addi	sp,sp,32
    80002d94:	8082                	ret
    80002d96:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002d98:	00005517          	auipc	a0,0x5
    80002d9c:	72050513          	addi	a0,a0,1824 # 800084b8 <etext+0x4b8>
    80002da0:	00003097          	auipc	ra,0x3
    80002da4:	14c080e7          	jalr	332(ra) # 80005eec <panic>
    80002da8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002daa:	40dc                	lw	a5,4(s1)
    80002dac:	0047d79b          	srliw	a5,a5,0x4
    80002db0:	00015597          	auipc	a1,0x15
    80002db4:	9c05a583          	lw	a1,-1600(a1) # 80017770 <sb+0x18>
    80002db8:	9dbd                	addw	a1,a1,a5
    80002dba:	4088                	lw	a0,0(s1)
    80002dbc:	fffff097          	auipc	ra,0xfffff
    80002dc0:	7b4080e7          	jalr	1972(ra) # 80002570 <bread>
    80002dc4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dc6:	05850593          	addi	a1,a0,88
    80002dca:	40dc                	lw	a5,4(s1)
    80002dcc:	8bbd                	andi	a5,a5,15
    80002dce:	079a                	slli	a5,a5,0x6
    80002dd0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dd2:	00059783          	lh	a5,0(a1)
    80002dd6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dda:	00259783          	lh	a5,2(a1)
    80002dde:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002de2:	00459783          	lh	a5,4(a1)
    80002de6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dea:	00659783          	lh	a5,6(a1)
    80002dee:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002df2:	459c                	lw	a5,8(a1)
    80002df4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002df6:	03400613          	li	a2,52
    80002dfa:	05b1                	addi	a1,a1,12
    80002dfc:	05048513          	addi	a0,s1,80
    80002e00:	ffffd097          	auipc	ra,0xffffd
    80002e04:	3d6080e7          	jalr	982(ra) # 800001d6 <memmove>
    brelse(bp);
    80002e08:	854a                	mv	a0,s2
    80002e0a:	00000097          	auipc	ra,0x0
    80002e0e:	896080e7          	jalr	-1898(ra) # 800026a0 <brelse>
    ip->valid = 1;
    80002e12:	4785                	li	a5,1
    80002e14:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e16:	04449783          	lh	a5,68(s1)
    80002e1a:	c399                	beqz	a5,80002e20 <ilock+0xb6>
    80002e1c:	6902                	ld	s2,0(sp)
    80002e1e:	b7bd                	j	80002d8c <ilock+0x22>
      panic("ilock: no type");
    80002e20:	00005517          	auipc	a0,0x5
    80002e24:	6a050513          	addi	a0,a0,1696 # 800084c0 <etext+0x4c0>
    80002e28:	00003097          	auipc	ra,0x3
    80002e2c:	0c4080e7          	jalr	196(ra) # 80005eec <panic>

0000000080002e30 <iunlock>:
{
    80002e30:	1101                	addi	sp,sp,-32
    80002e32:	ec06                	sd	ra,24(sp)
    80002e34:	e822                	sd	s0,16(sp)
    80002e36:	e426                	sd	s1,8(sp)
    80002e38:	e04a                	sd	s2,0(sp)
    80002e3a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e3c:	c905                	beqz	a0,80002e6c <iunlock+0x3c>
    80002e3e:	84aa                	mv	s1,a0
    80002e40:	01050913          	addi	s2,a0,16
    80002e44:	854a                	mv	a0,s2
    80002e46:	00001097          	auipc	ra,0x1
    80002e4a:	c86080e7          	jalr	-890(ra) # 80003acc <holdingsleep>
    80002e4e:	cd19                	beqz	a0,80002e6c <iunlock+0x3c>
    80002e50:	449c                	lw	a5,8(s1)
    80002e52:	00f05d63          	blez	a5,80002e6c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e56:	854a                	mv	a0,s2
    80002e58:	00001097          	auipc	ra,0x1
    80002e5c:	c30080e7          	jalr	-976(ra) # 80003a88 <releasesleep>
}
    80002e60:	60e2                	ld	ra,24(sp)
    80002e62:	6442                	ld	s0,16(sp)
    80002e64:	64a2                	ld	s1,8(sp)
    80002e66:	6902                	ld	s2,0(sp)
    80002e68:	6105                	addi	sp,sp,32
    80002e6a:	8082                	ret
    panic("iunlock");
    80002e6c:	00005517          	auipc	a0,0x5
    80002e70:	66450513          	addi	a0,a0,1636 # 800084d0 <etext+0x4d0>
    80002e74:	00003097          	auipc	ra,0x3
    80002e78:	078080e7          	jalr	120(ra) # 80005eec <panic>

0000000080002e7c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e7c:	7179                	addi	sp,sp,-48
    80002e7e:	f406                	sd	ra,40(sp)
    80002e80:	f022                	sd	s0,32(sp)
    80002e82:	ec26                	sd	s1,24(sp)
    80002e84:	e84a                	sd	s2,16(sp)
    80002e86:	e44e                	sd	s3,8(sp)
    80002e88:	1800                	addi	s0,sp,48
    80002e8a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e8c:	05050493          	addi	s1,a0,80
    80002e90:	08050913          	addi	s2,a0,128
    80002e94:	a021                	j	80002e9c <itrunc+0x20>
    80002e96:	0491                	addi	s1,s1,4
    80002e98:	01248d63          	beq	s1,s2,80002eb2 <itrunc+0x36>
    if(ip->addrs[i]){
    80002e9c:	408c                	lw	a1,0(s1)
    80002e9e:	dde5                	beqz	a1,80002e96 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002ea0:	0009a503          	lw	a0,0(s3)
    80002ea4:	00000097          	auipc	ra,0x0
    80002ea8:	910080e7          	jalr	-1776(ra) # 800027b4 <bfree>
      ip->addrs[i] = 0;
    80002eac:	0004a023          	sw	zero,0(s1)
    80002eb0:	b7dd                	j	80002e96 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002eb2:	0809a583          	lw	a1,128(s3)
    80002eb6:	ed99                	bnez	a1,80002ed4 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eb8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ebc:	854e                	mv	a0,s3
    80002ebe:	00000097          	auipc	ra,0x0
    80002ec2:	de0080e7          	jalr	-544(ra) # 80002c9e <iupdate>
}
    80002ec6:	70a2                	ld	ra,40(sp)
    80002ec8:	7402                	ld	s0,32(sp)
    80002eca:	64e2                	ld	s1,24(sp)
    80002ecc:	6942                	ld	s2,16(sp)
    80002ece:	69a2                	ld	s3,8(sp)
    80002ed0:	6145                	addi	sp,sp,48
    80002ed2:	8082                	ret
    80002ed4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ed6:	0009a503          	lw	a0,0(s3)
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	696080e7          	jalr	1686(ra) # 80002570 <bread>
    80002ee2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ee4:	05850493          	addi	s1,a0,88
    80002ee8:	45850913          	addi	s2,a0,1112
    80002eec:	a021                	j	80002ef4 <itrunc+0x78>
    80002eee:	0491                	addi	s1,s1,4
    80002ef0:	01248b63          	beq	s1,s2,80002f06 <itrunc+0x8a>
      if(a[j])
    80002ef4:	408c                	lw	a1,0(s1)
    80002ef6:	dde5                	beqz	a1,80002eee <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002ef8:	0009a503          	lw	a0,0(s3)
    80002efc:	00000097          	auipc	ra,0x0
    80002f00:	8b8080e7          	jalr	-1864(ra) # 800027b4 <bfree>
    80002f04:	b7ed                	j	80002eee <itrunc+0x72>
    brelse(bp);
    80002f06:	8552                	mv	a0,s4
    80002f08:	fffff097          	auipc	ra,0xfffff
    80002f0c:	798080e7          	jalr	1944(ra) # 800026a0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f10:	0809a583          	lw	a1,128(s3)
    80002f14:	0009a503          	lw	a0,0(s3)
    80002f18:	00000097          	auipc	ra,0x0
    80002f1c:	89c080e7          	jalr	-1892(ra) # 800027b4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f20:	0809a023          	sw	zero,128(s3)
    80002f24:	6a02                	ld	s4,0(sp)
    80002f26:	bf49                	j	80002eb8 <itrunc+0x3c>

0000000080002f28 <iput>:
{
    80002f28:	1101                	addi	sp,sp,-32
    80002f2a:	ec06                	sd	ra,24(sp)
    80002f2c:	e822                	sd	s0,16(sp)
    80002f2e:	e426                	sd	s1,8(sp)
    80002f30:	1000                	addi	s0,sp,32
    80002f32:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f34:	00015517          	auipc	a0,0x15
    80002f38:	84450513          	addi	a0,a0,-1980 # 80017778 <itable>
    80002f3c:	00003097          	auipc	ra,0x3
    80002f40:	52a080e7          	jalr	1322(ra) # 80006466 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f44:	4498                	lw	a4,8(s1)
    80002f46:	4785                	li	a5,1
    80002f48:	02f70263          	beq	a4,a5,80002f6c <iput+0x44>
  ip->ref--;
    80002f4c:	449c                	lw	a5,8(s1)
    80002f4e:	37fd                	addiw	a5,a5,-1
    80002f50:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f52:	00015517          	auipc	a0,0x15
    80002f56:	82650513          	addi	a0,a0,-2010 # 80017778 <itable>
    80002f5a:	00003097          	auipc	ra,0x3
    80002f5e:	5c0080e7          	jalr	1472(ra) # 8000651a <release>
}
    80002f62:	60e2                	ld	ra,24(sp)
    80002f64:	6442                	ld	s0,16(sp)
    80002f66:	64a2                	ld	s1,8(sp)
    80002f68:	6105                	addi	sp,sp,32
    80002f6a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f6c:	40bc                	lw	a5,64(s1)
    80002f6e:	dff9                	beqz	a5,80002f4c <iput+0x24>
    80002f70:	04a49783          	lh	a5,74(s1)
    80002f74:	ffe1                	bnez	a5,80002f4c <iput+0x24>
    80002f76:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002f78:	01048913          	addi	s2,s1,16
    80002f7c:	854a                	mv	a0,s2
    80002f7e:	00001097          	auipc	ra,0x1
    80002f82:	ab4080e7          	jalr	-1356(ra) # 80003a32 <acquiresleep>
    release(&itable.lock);
    80002f86:	00014517          	auipc	a0,0x14
    80002f8a:	7f250513          	addi	a0,a0,2034 # 80017778 <itable>
    80002f8e:	00003097          	auipc	ra,0x3
    80002f92:	58c080e7          	jalr	1420(ra) # 8000651a <release>
    itrunc(ip);
    80002f96:	8526                	mv	a0,s1
    80002f98:	00000097          	auipc	ra,0x0
    80002f9c:	ee4080e7          	jalr	-284(ra) # 80002e7c <itrunc>
    ip->type = 0;
    80002fa0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	00000097          	auipc	ra,0x0
    80002faa:	cf8080e7          	jalr	-776(ra) # 80002c9e <iupdate>
    ip->valid = 0;
    80002fae:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	00001097          	auipc	ra,0x1
    80002fb8:	ad4080e7          	jalr	-1324(ra) # 80003a88 <releasesleep>
    acquire(&itable.lock);
    80002fbc:	00014517          	auipc	a0,0x14
    80002fc0:	7bc50513          	addi	a0,a0,1980 # 80017778 <itable>
    80002fc4:	00003097          	auipc	ra,0x3
    80002fc8:	4a2080e7          	jalr	1186(ra) # 80006466 <acquire>
    80002fcc:	6902                	ld	s2,0(sp)
    80002fce:	bfbd                	j	80002f4c <iput+0x24>

0000000080002fd0 <iunlockput>:
{
    80002fd0:	1101                	addi	sp,sp,-32
    80002fd2:	ec06                	sd	ra,24(sp)
    80002fd4:	e822                	sd	s0,16(sp)
    80002fd6:	e426                	sd	s1,8(sp)
    80002fd8:	1000                	addi	s0,sp,32
    80002fda:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fdc:	00000097          	auipc	ra,0x0
    80002fe0:	e54080e7          	jalr	-428(ra) # 80002e30 <iunlock>
  iput(ip);
    80002fe4:	8526                	mv	a0,s1
    80002fe6:	00000097          	auipc	ra,0x0
    80002fea:	f42080e7          	jalr	-190(ra) # 80002f28 <iput>
}
    80002fee:	60e2                	ld	ra,24(sp)
    80002ff0:	6442                	ld	s0,16(sp)
    80002ff2:	64a2                	ld	s1,8(sp)
    80002ff4:	6105                	addi	sp,sp,32
    80002ff6:	8082                	ret

0000000080002ff8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ff8:	1141                	addi	sp,sp,-16
    80002ffa:	e422                	sd	s0,8(sp)
    80002ffc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ffe:	411c                	lw	a5,0(a0)
    80003000:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003002:	415c                	lw	a5,4(a0)
    80003004:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003006:	04451783          	lh	a5,68(a0)
    8000300a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000300e:	04a51783          	lh	a5,74(a0)
    80003012:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003016:	04c56783          	lwu	a5,76(a0)
    8000301a:	e99c                	sd	a5,16(a1)
}
    8000301c:	6422                	ld	s0,8(sp)
    8000301e:	0141                	addi	sp,sp,16
    80003020:	8082                	ret

0000000080003022 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003022:	457c                	lw	a5,76(a0)
    80003024:	0ed7ef63          	bltu	a5,a3,80003122 <readi+0x100>
{
    80003028:	7159                	addi	sp,sp,-112
    8000302a:	f486                	sd	ra,104(sp)
    8000302c:	f0a2                	sd	s0,96(sp)
    8000302e:	eca6                	sd	s1,88(sp)
    80003030:	fc56                	sd	s5,56(sp)
    80003032:	f85a                	sd	s6,48(sp)
    80003034:	f45e                	sd	s7,40(sp)
    80003036:	f062                	sd	s8,32(sp)
    80003038:	1880                	addi	s0,sp,112
    8000303a:	8baa                	mv	s7,a0
    8000303c:	8c2e                	mv	s8,a1
    8000303e:	8ab2                	mv	s5,a2
    80003040:	84b6                	mv	s1,a3
    80003042:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003044:	9f35                	addw	a4,a4,a3
    return 0;
    80003046:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003048:	0ad76c63          	bltu	a4,a3,80003100 <readi+0xde>
    8000304c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000304e:	00e7f463          	bgeu	a5,a4,80003056 <readi+0x34>
    n = ip->size - off;
    80003052:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003056:	0c0b0463          	beqz	s6,8000311e <readi+0xfc>
    8000305a:	e8ca                	sd	s2,80(sp)
    8000305c:	e0d2                	sd	s4,64(sp)
    8000305e:	ec66                	sd	s9,24(sp)
    80003060:	e86a                	sd	s10,16(sp)
    80003062:	e46e                	sd	s11,8(sp)
    80003064:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003066:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000306a:	5cfd                	li	s9,-1
    8000306c:	a82d                	j	800030a6 <readi+0x84>
    8000306e:	020a1d93          	slli	s11,s4,0x20
    80003072:	020ddd93          	srli	s11,s11,0x20
    80003076:	05890613          	addi	a2,s2,88
    8000307a:	86ee                	mv	a3,s11
    8000307c:	963a                	add	a2,a2,a4
    8000307e:	85d6                	mv	a1,s5
    80003080:	8562                	mv	a0,s8
    80003082:	fffff097          	auipc	ra,0xfffff
    80003086:	ab0080e7          	jalr	-1360(ra) # 80001b32 <either_copyout>
    8000308a:	05950d63          	beq	a0,s9,800030e4 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000308e:	854a                	mv	a0,s2
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	610080e7          	jalr	1552(ra) # 800026a0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003098:	013a09bb          	addw	s3,s4,s3
    8000309c:	009a04bb          	addw	s1,s4,s1
    800030a0:	9aee                	add	s5,s5,s11
    800030a2:	0769f863          	bgeu	s3,s6,80003112 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030a6:	000ba903          	lw	s2,0(s7)
    800030aa:	00a4d59b          	srliw	a1,s1,0xa
    800030ae:	855e                	mv	a0,s7
    800030b0:	00000097          	auipc	ra,0x0
    800030b4:	8ae080e7          	jalr	-1874(ra) # 8000295e <bmap>
    800030b8:	0005059b          	sext.w	a1,a0
    800030bc:	854a                	mv	a0,s2
    800030be:	fffff097          	auipc	ra,0xfffff
    800030c2:	4b2080e7          	jalr	1202(ra) # 80002570 <bread>
    800030c6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c8:	3ff4f713          	andi	a4,s1,1023
    800030cc:	40ed07bb          	subw	a5,s10,a4
    800030d0:	413b06bb          	subw	a3,s6,s3
    800030d4:	8a3e                	mv	s4,a5
    800030d6:	2781                	sext.w	a5,a5
    800030d8:	0006861b          	sext.w	a2,a3
    800030dc:	f8f679e3          	bgeu	a2,a5,8000306e <readi+0x4c>
    800030e0:	8a36                	mv	s4,a3
    800030e2:	b771                	j	8000306e <readi+0x4c>
      brelse(bp);
    800030e4:	854a                	mv	a0,s2
    800030e6:	fffff097          	auipc	ra,0xfffff
    800030ea:	5ba080e7          	jalr	1466(ra) # 800026a0 <brelse>
      tot = -1;
    800030ee:	59fd                	li	s3,-1
      break;
    800030f0:	6946                	ld	s2,80(sp)
    800030f2:	6a06                	ld	s4,64(sp)
    800030f4:	6ce2                	ld	s9,24(sp)
    800030f6:	6d42                	ld	s10,16(sp)
    800030f8:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800030fa:	0009851b          	sext.w	a0,s3
    800030fe:	69a6                	ld	s3,72(sp)
}
    80003100:	70a6                	ld	ra,104(sp)
    80003102:	7406                	ld	s0,96(sp)
    80003104:	64e6                	ld	s1,88(sp)
    80003106:	7ae2                	ld	s5,56(sp)
    80003108:	7b42                	ld	s6,48(sp)
    8000310a:	7ba2                	ld	s7,40(sp)
    8000310c:	7c02                	ld	s8,32(sp)
    8000310e:	6165                	addi	sp,sp,112
    80003110:	8082                	ret
    80003112:	6946                	ld	s2,80(sp)
    80003114:	6a06                	ld	s4,64(sp)
    80003116:	6ce2                	ld	s9,24(sp)
    80003118:	6d42                	ld	s10,16(sp)
    8000311a:	6da2                	ld	s11,8(sp)
    8000311c:	bff9                	j	800030fa <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000311e:	89da                	mv	s3,s6
    80003120:	bfe9                	j	800030fa <readi+0xd8>
    return 0;
    80003122:	4501                	li	a0,0
}
    80003124:	8082                	ret

0000000080003126 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003126:	457c                	lw	a5,76(a0)
    80003128:	10d7ee63          	bltu	a5,a3,80003244 <writei+0x11e>
{
    8000312c:	7159                	addi	sp,sp,-112
    8000312e:	f486                	sd	ra,104(sp)
    80003130:	f0a2                	sd	s0,96(sp)
    80003132:	e8ca                	sd	s2,80(sp)
    80003134:	fc56                	sd	s5,56(sp)
    80003136:	f85a                	sd	s6,48(sp)
    80003138:	f45e                	sd	s7,40(sp)
    8000313a:	f062                	sd	s8,32(sp)
    8000313c:	1880                	addi	s0,sp,112
    8000313e:	8b2a                	mv	s6,a0
    80003140:	8c2e                	mv	s8,a1
    80003142:	8ab2                	mv	s5,a2
    80003144:	8936                	mv	s2,a3
    80003146:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003148:	00e687bb          	addw	a5,a3,a4
    8000314c:	0ed7ee63          	bltu	a5,a3,80003248 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003150:	00043737          	lui	a4,0x43
    80003154:	0ef76c63          	bltu	a4,a5,8000324c <writei+0x126>
    80003158:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000315a:	0c0b8d63          	beqz	s7,80003234 <writei+0x10e>
    8000315e:	eca6                	sd	s1,88(sp)
    80003160:	e4ce                	sd	s3,72(sp)
    80003162:	ec66                	sd	s9,24(sp)
    80003164:	e86a                	sd	s10,16(sp)
    80003166:	e46e                	sd	s11,8(sp)
    80003168:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000316a:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000316e:	5cfd                	li	s9,-1
    80003170:	a091                	j	800031b4 <writei+0x8e>
    80003172:	02099d93          	slli	s11,s3,0x20
    80003176:	020ddd93          	srli	s11,s11,0x20
    8000317a:	05848513          	addi	a0,s1,88
    8000317e:	86ee                	mv	a3,s11
    80003180:	8656                	mv	a2,s5
    80003182:	85e2                	mv	a1,s8
    80003184:	953a                	add	a0,a0,a4
    80003186:	fffff097          	auipc	ra,0xfffff
    8000318a:	a02080e7          	jalr	-1534(ra) # 80001b88 <either_copyin>
    8000318e:	07950263          	beq	a0,s9,800031f2 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003192:	8526                	mv	a0,s1
    80003194:	00000097          	auipc	ra,0x0
    80003198:	780080e7          	jalr	1920(ra) # 80003914 <log_write>
    brelse(bp);
    8000319c:	8526                	mv	a0,s1
    8000319e:	fffff097          	auipc	ra,0xfffff
    800031a2:	502080e7          	jalr	1282(ra) # 800026a0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031a6:	01498a3b          	addw	s4,s3,s4
    800031aa:	0129893b          	addw	s2,s3,s2
    800031ae:	9aee                	add	s5,s5,s11
    800031b0:	057a7663          	bgeu	s4,s7,800031fc <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031b4:	000b2483          	lw	s1,0(s6)
    800031b8:	00a9559b          	srliw	a1,s2,0xa
    800031bc:	855a                	mv	a0,s6
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	7a0080e7          	jalr	1952(ra) # 8000295e <bmap>
    800031c6:	0005059b          	sext.w	a1,a0
    800031ca:	8526                	mv	a0,s1
    800031cc:	fffff097          	auipc	ra,0xfffff
    800031d0:	3a4080e7          	jalr	932(ra) # 80002570 <bread>
    800031d4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031d6:	3ff97713          	andi	a4,s2,1023
    800031da:	40ed07bb          	subw	a5,s10,a4
    800031de:	414b86bb          	subw	a3,s7,s4
    800031e2:	89be                	mv	s3,a5
    800031e4:	2781                	sext.w	a5,a5
    800031e6:	0006861b          	sext.w	a2,a3
    800031ea:	f8f674e3          	bgeu	a2,a5,80003172 <writei+0x4c>
    800031ee:	89b6                	mv	s3,a3
    800031f0:	b749                	j	80003172 <writei+0x4c>
      brelse(bp);
    800031f2:	8526                	mv	a0,s1
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	4ac080e7          	jalr	1196(ra) # 800026a0 <brelse>
  }

  if(off > ip->size)
    800031fc:	04cb2783          	lw	a5,76(s6)
    80003200:	0327fc63          	bgeu	a5,s2,80003238 <writei+0x112>
    ip->size = off;
    80003204:	052b2623          	sw	s2,76(s6)
    80003208:	64e6                	ld	s1,88(sp)
    8000320a:	69a6                	ld	s3,72(sp)
    8000320c:	6ce2                	ld	s9,24(sp)
    8000320e:	6d42                	ld	s10,16(sp)
    80003210:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003212:	855a                	mv	a0,s6
    80003214:	00000097          	auipc	ra,0x0
    80003218:	a8a080e7          	jalr	-1398(ra) # 80002c9e <iupdate>

  return tot;
    8000321c:	000a051b          	sext.w	a0,s4
    80003220:	6a06                	ld	s4,64(sp)
}
    80003222:	70a6                	ld	ra,104(sp)
    80003224:	7406                	ld	s0,96(sp)
    80003226:	6946                	ld	s2,80(sp)
    80003228:	7ae2                	ld	s5,56(sp)
    8000322a:	7b42                	ld	s6,48(sp)
    8000322c:	7ba2                	ld	s7,40(sp)
    8000322e:	7c02                	ld	s8,32(sp)
    80003230:	6165                	addi	sp,sp,112
    80003232:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003234:	8a5e                	mv	s4,s7
    80003236:	bff1                	j	80003212 <writei+0xec>
    80003238:	64e6                	ld	s1,88(sp)
    8000323a:	69a6                	ld	s3,72(sp)
    8000323c:	6ce2                	ld	s9,24(sp)
    8000323e:	6d42                	ld	s10,16(sp)
    80003240:	6da2                	ld	s11,8(sp)
    80003242:	bfc1                	j	80003212 <writei+0xec>
    return -1;
    80003244:	557d                	li	a0,-1
}
    80003246:	8082                	ret
    return -1;
    80003248:	557d                	li	a0,-1
    8000324a:	bfe1                	j	80003222 <writei+0xfc>
    return -1;
    8000324c:	557d                	li	a0,-1
    8000324e:	bfd1                	j	80003222 <writei+0xfc>

0000000080003250 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003250:	1141                	addi	sp,sp,-16
    80003252:	e406                	sd	ra,8(sp)
    80003254:	e022                	sd	s0,0(sp)
    80003256:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003258:	4639                	li	a2,14
    8000325a:	ffffd097          	auipc	ra,0xffffd
    8000325e:	ff0080e7          	jalr	-16(ra) # 8000024a <strncmp>
}
    80003262:	60a2                	ld	ra,8(sp)
    80003264:	6402                	ld	s0,0(sp)
    80003266:	0141                	addi	sp,sp,16
    80003268:	8082                	ret

000000008000326a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000326a:	7139                	addi	sp,sp,-64
    8000326c:	fc06                	sd	ra,56(sp)
    8000326e:	f822                	sd	s0,48(sp)
    80003270:	f426                	sd	s1,40(sp)
    80003272:	f04a                	sd	s2,32(sp)
    80003274:	ec4e                	sd	s3,24(sp)
    80003276:	e852                	sd	s4,16(sp)
    80003278:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000327a:	04451703          	lh	a4,68(a0)
    8000327e:	4785                	li	a5,1
    80003280:	00f71a63          	bne	a4,a5,80003294 <dirlookup+0x2a>
    80003284:	892a                	mv	s2,a0
    80003286:	89ae                	mv	s3,a1
    80003288:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000328a:	457c                	lw	a5,76(a0)
    8000328c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000328e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003290:	e79d                	bnez	a5,800032be <dirlookup+0x54>
    80003292:	a8a5                	j	8000330a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003294:	00005517          	auipc	a0,0x5
    80003298:	24450513          	addi	a0,a0,580 # 800084d8 <etext+0x4d8>
    8000329c:	00003097          	auipc	ra,0x3
    800032a0:	c50080e7          	jalr	-944(ra) # 80005eec <panic>
      panic("dirlookup read");
    800032a4:	00005517          	auipc	a0,0x5
    800032a8:	24c50513          	addi	a0,a0,588 # 800084f0 <etext+0x4f0>
    800032ac:	00003097          	auipc	ra,0x3
    800032b0:	c40080e7          	jalr	-960(ra) # 80005eec <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032b4:	24c1                	addiw	s1,s1,16
    800032b6:	04c92783          	lw	a5,76(s2)
    800032ba:	04f4f763          	bgeu	s1,a5,80003308 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032be:	4741                	li	a4,16
    800032c0:	86a6                	mv	a3,s1
    800032c2:	fc040613          	addi	a2,s0,-64
    800032c6:	4581                	li	a1,0
    800032c8:	854a                	mv	a0,s2
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	d58080e7          	jalr	-680(ra) # 80003022 <readi>
    800032d2:	47c1                	li	a5,16
    800032d4:	fcf518e3          	bne	a0,a5,800032a4 <dirlookup+0x3a>
    if(de.inum == 0)
    800032d8:	fc045783          	lhu	a5,-64(s0)
    800032dc:	dfe1                	beqz	a5,800032b4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032de:	fc240593          	addi	a1,s0,-62
    800032e2:	854e                	mv	a0,s3
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	f6c080e7          	jalr	-148(ra) # 80003250 <namecmp>
    800032ec:	f561                	bnez	a0,800032b4 <dirlookup+0x4a>
      if(poff)
    800032ee:	000a0463          	beqz	s4,800032f6 <dirlookup+0x8c>
        *poff = off;
    800032f2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032f6:	fc045583          	lhu	a1,-64(s0)
    800032fa:	00092503          	lw	a0,0(s2)
    800032fe:	fffff097          	auipc	ra,0xfffff
    80003302:	73c080e7          	jalr	1852(ra) # 80002a3a <iget>
    80003306:	a011                	j	8000330a <dirlookup+0xa0>
  return 0;
    80003308:	4501                	li	a0,0
}
    8000330a:	70e2                	ld	ra,56(sp)
    8000330c:	7442                	ld	s0,48(sp)
    8000330e:	74a2                	ld	s1,40(sp)
    80003310:	7902                	ld	s2,32(sp)
    80003312:	69e2                	ld	s3,24(sp)
    80003314:	6a42                	ld	s4,16(sp)
    80003316:	6121                	addi	sp,sp,64
    80003318:	8082                	ret

000000008000331a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000331a:	711d                	addi	sp,sp,-96
    8000331c:	ec86                	sd	ra,88(sp)
    8000331e:	e8a2                	sd	s0,80(sp)
    80003320:	e4a6                	sd	s1,72(sp)
    80003322:	e0ca                	sd	s2,64(sp)
    80003324:	fc4e                	sd	s3,56(sp)
    80003326:	f852                	sd	s4,48(sp)
    80003328:	f456                	sd	s5,40(sp)
    8000332a:	f05a                	sd	s6,32(sp)
    8000332c:	ec5e                	sd	s7,24(sp)
    8000332e:	e862                	sd	s8,16(sp)
    80003330:	e466                	sd	s9,8(sp)
    80003332:	1080                	addi	s0,sp,96
    80003334:	84aa                	mv	s1,a0
    80003336:	8b2e                	mv	s6,a1
    80003338:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000333a:	00054703          	lbu	a4,0(a0)
    8000333e:	02f00793          	li	a5,47
    80003342:	02f70263          	beq	a4,a5,80003366 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003346:	ffffe097          	auipc	ra,0xffffe
    8000334a:	cce080e7          	jalr	-818(ra) # 80001014 <myproc>
    8000334e:	16053503          	ld	a0,352(a0)
    80003352:	00000097          	auipc	ra,0x0
    80003356:	9da080e7          	jalr	-1574(ra) # 80002d2c <idup>
    8000335a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000335c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003360:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003362:	4b85                	li	s7,1
    80003364:	a875                	j	80003420 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003366:	4585                	li	a1,1
    80003368:	4505                	li	a0,1
    8000336a:	fffff097          	auipc	ra,0xfffff
    8000336e:	6d0080e7          	jalr	1744(ra) # 80002a3a <iget>
    80003372:	8a2a                	mv	s4,a0
    80003374:	b7e5                	j	8000335c <namex+0x42>
      iunlockput(ip);
    80003376:	8552                	mv	a0,s4
    80003378:	00000097          	auipc	ra,0x0
    8000337c:	c58080e7          	jalr	-936(ra) # 80002fd0 <iunlockput>
      return 0;
    80003380:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003382:	8552                	mv	a0,s4
    80003384:	60e6                	ld	ra,88(sp)
    80003386:	6446                	ld	s0,80(sp)
    80003388:	64a6                	ld	s1,72(sp)
    8000338a:	6906                	ld	s2,64(sp)
    8000338c:	79e2                	ld	s3,56(sp)
    8000338e:	7a42                	ld	s4,48(sp)
    80003390:	7aa2                	ld	s5,40(sp)
    80003392:	7b02                	ld	s6,32(sp)
    80003394:	6be2                	ld	s7,24(sp)
    80003396:	6c42                	ld	s8,16(sp)
    80003398:	6ca2                	ld	s9,8(sp)
    8000339a:	6125                	addi	sp,sp,96
    8000339c:	8082                	ret
      iunlock(ip);
    8000339e:	8552                	mv	a0,s4
    800033a0:	00000097          	auipc	ra,0x0
    800033a4:	a90080e7          	jalr	-1392(ra) # 80002e30 <iunlock>
      return ip;
    800033a8:	bfe9                	j	80003382 <namex+0x68>
      iunlockput(ip);
    800033aa:	8552                	mv	a0,s4
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	c24080e7          	jalr	-988(ra) # 80002fd0 <iunlockput>
      return 0;
    800033b4:	8a4e                	mv	s4,s3
    800033b6:	b7f1                	j	80003382 <namex+0x68>
  len = path - s;
    800033b8:	40998633          	sub	a2,s3,s1
    800033bc:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800033c0:	099c5863          	bge	s8,s9,80003450 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800033c4:	4639                	li	a2,14
    800033c6:	85a6                	mv	a1,s1
    800033c8:	8556                	mv	a0,s5
    800033ca:	ffffd097          	auipc	ra,0xffffd
    800033ce:	e0c080e7          	jalr	-500(ra) # 800001d6 <memmove>
    800033d2:	84ce                	mv	s1,s3
  while(*path == '/')
    800033d4:	0004c783          	lbu	a5,0(s1)
    800033d8:	01279763          	bne	a5,s2,800033e6 <namex+0xcc>
    path++;
    800033dc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033de:	0004c783          	lbu	a5,0(s1)
    800033e2:	ff278de3          	beq	a5,s2,800033dc <namex+0xc2>
    ilock(ip);
    800033e6:	8552                	mv	a0,s4
    800033e8:	00000097          	auipc	ra,0x0
    800033ec:	982080e7          	jalr	-1662(ra) # 80002d6a <ilock>
    if(ip->type != T_DIR){
    800033f0:	044a1783          	lh	a5,68(s4)
    800033f4:	f97791e3          	bne	a5,s7,80003376 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800033f8:	000b0563          	beqz	s6,80003402 <namex+0xe8>
    800033fc:	0004c783          	lbu	a5,0(s1)
    80003400:	dfd9                	beqz	a5,8000339e <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003402:	4601                	li	a2,0
    80003404:	85d6                	mv	a1,s5
    80003406:	8552                	mv	a0,s4
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	e62080e7          	jalr	-414(ra) # 8000326a <dirlookup>
    80003410:	89aa                	mv	s3,a0
    80003412:	dd41                	beqz	a0,800033aa <namex+0x90>
    iunlockput(ip);
    80003414:	8552                	mv	a0,s4
    80003416:	00000097          	auipc	ra,0x0
    8000341a:	bba080e7          	jalr	-1094(ra) # 80002fd0 <iunlockput>
    ip = next;
    8000341e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003420:	0004c783          	lbu	a5,0(s1)
    80003424:	01279763          	bne	a5,s2,80003432 <namex+0x118>
    path++;
    80003428:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000342a:	0004c783          	lbu	a5,0(s1)
    8000342e:	ff278de3          	beq	a5,s2,80003428 <namex+0x10e>
  if(*path == 0)
    80003432:	cb9d                	beqz	a5,80003468 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003434:	0004c783          	lbu	a5,0(s1)
    80003438:	89a6                	mv	s3,s1
  len = path - s;
    8000343a:	4c81                	li	s9,0
    8000343c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000343e:	01278963          	beq	a5,s2,80003450 <namex+0x136>
    80003442:	dbbd                	beqz	a5,800033b8 <namex+0x9e>
    path++;
    80003444:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003446:	0009c783          	lbu	a5,0(s3)
    8000344a:	ff279ce3          	bne	a5,s2,80003442 <namex+0x128>
    8000344e:	b7ad                	j	800033b8 <namex+0x9e>
    memmove(name, s, len);
    80003450:	2601                	sext.w	a2,a2
    80003452:	85a6                	mv	a1,s1
    80003454:	8556                	mv	a0,s5
    80003456:	ffffd097          	auipc	ra,0xffffd
    8000345a:	d80080e7          	jalr	-640(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000345e:	9cd6                	add	s9,s9,s5
    80003460:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003464:	84ce                	mv	s1,s3
    80003466:	b7bd                	j	800033d4 <namex+0xba>
  if(nameiparent){
    80003468:	f00b0de3          	beqz	s6,80003382 <namex+0x68>
    iput(ip);
    8000346c:	8552                	mv	a0,s4
    8000346e:	00000097          	auipc	ra,0x0
    80003472:	aba080e7          	jalr	-1350(ra) # 80002f28 <iput>
    return 0;
    80003476:	4a01                	li	s4,0
    80003478:	b729                	j	80003382 <namex+0x68>

000000008000347a <dirlink>:
{
    8000347a:	7139                	addi	sp,sp,-64
    8000347c:	fc06                	sd	ra,56(sp)
    8000347e:	f822                	sd	s0,48(sp)
    80003480:	f04a                	sd	s2,32(sp)
    80003482:	ec4e                	sd	s3,24(sp)
    80003484:	e852                	sd	s4,16(sp)
    80003486:	0080                	addi	s0,sp,64
    80003488:	892a                	mv	s2,a0
    8000348a:	8a2e                	mv	s4,a1
    8000348c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000348e:	4601                	li	a2,0
    80003490:	00000097          	auipc	ra,0x0
    80003494:	dda080e7          	jalr	-550(ra) # 8000326a <dirlookup>
    80003498:	ed25                	bnez	a0,80003510 <dirlink+0x96>
    8000349a:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000349c:	04c92483          	lw	s1,76(s2)
    800034a0:	c49d                	beqz	s1,800034ce <dirlink+0x54>
    800034a2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034a4:	4741                	li	a4,16
    800034a6:	86a6                	mv	a3,s1
    800034a8:	fc040613          	addi	a2,s0,-64
    800034ac:	4581                	li	a1,0
    800034ae:	854a                	mv	a0,s2
    800034b0:	00000097          	auipc	ra,0x0
    800034b4:	b72080e7          	jalr	-1166(ra) # 80003022 <readi>
    800034b8:	47c1                	li	a5,16
    800034ba:	06f51163          	bne	a0,a5,8000351c <dirlink+0xa2>
    if(de.inum == 0)
    800034be:	fc045783          	lhu	a5,-64(s0)
    800034c2:	c791                	beqz	a5,800034ce <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034c4:	24c1                	addiw	s1,s1,16
    800034c6:	04c92783          	lw	a5,76(s2)
    800034ca:	fcf4ede3          	bltu	s1,a5,800034a4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034ce:	4639                	li	a2,14
    800034d0:	85d2                	mv	a1,s4
    800034d2:	fc240513          	addi	a0,s0,-62
    800034d6:	ffffd097          	auipc	ra,0xffffd
    800034da:	daa080e7          	jalr	-598(ra) # 80000280 <strncpy>
  de.inum = inum;
    800034de:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034e2:	4741                	li	a4,16
    800034e4:	86a6                	mv	a3,s1
    800034e6:	fc040613          	addi	a2,s0,-64
    800034ea:	4581                	li	a1,0
    800034ec:	854a                	mv	a0,s2
    800034ee:	00000097          	auipc	ra,0x0
    800034f2:	c38080e7          	jalr	-968(ra) # 80003126 <writei>
    800034f6:	872a                	mv	a4,a0
    800034f8:	47c1                	li	a5,16
  return 0;
    800034fa:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034fc:	02f71863          	bne	a4,a5,8000352c <dirlink+0xb2>
    80003500:	74a2                	ld	s1,40(sp)
}
    80003502:	70e2                	ld	ra,56(sp)
    80003504:	7442                	ld	s0,48(sp)
    80003506:	7902                	ld	s2,32(sp)
    80003508:	69e2                	ld	s3,24(sp)
    8000350a:	6a42                	ld	s4,16(sp)
    8000350c:	6121                	addi	sp,sp,64
    8000350e:	8082                	ret
    iput(ip);
    80003510:	00000097          	auipc	ra,0x0
    80003514:	a18080e7          	jalr	-1512(ra) # 80002f28 <iput>
    return -1;
    80003518:	557d                	li	a0,-1
    8000351a:	b7e5                	j	80003502 <dirlink+0x88>
      panic("dirlink read");
    8000351c:	00005517          	auipc	a0,0x5
    80003520:	fe450513          	addi	a0,a0,-28 # 80008500 <etext+0x500>
    80003524:	00003097          	auipc	ra,0x3
    80003528:	9c8080e7          	jalr	-1592(ra) # 80005eec <panic>
    panic("dirlink");
    8000352c:	00005517          	auipc	a0,0x5
    80003530:	0dc50513          	addi	a0,a0,220 # 80008608 <etext+0x608>
    80003534:	00003097          	auipc	ra,0x3
    80003538:	9b8080e7          	jalr	-1608(ra) # 80005eec <panic>

000000008000353c <namei>:

struct inode*
namei(char *path)
{
    8000353c:	1101                	addi	sp,sp,-32
    8000353e:	ec06                	sd	ra,24(sp)
    80003540:	e822                	sd	s0,16(sp)
    80003542:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003544:	fe040613          	addi	a2,s0,-32
    80003548:	4581                	li	a1,0
    8000354a:	00000097          	auipc	ra,0x0
    8000354e:	dd0080e7          	jalr	-560(ra) # 8000331a <namex>
}
    80003552:	60e2                	ld	ra,24(sp)
    80003554:	6442                	ld	s0,16(sp)
    80003556:	6105                	addi	sp,sp,32
    80003558:	8082                	ret

000000008000355a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000355a:	1141                	addi	sp,sp,-16
    8000355c:	e406                	sd	ra,8(sp)
    8000355e:	e022                	sd	s0,0(sp)
    80003560:	0800                	addi	s0,sp,16
    80003562:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003564:	4585                	li	a1,1
    80003566:	00000097          	auipc	ra,0x0
    8000356a:	db4080e7          	jalr	-588(ra) # 8000331a <namex>
}
    8000356e:	60a2                	ld	ra,8(sp)
    80003570:	6402                	ld	s0,0(sp)
    80003572:	0141                	addi	sp,sp,16
    80003574:	8082                	ret

0000000080003576 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003576:	1101                	addi	sp,sp,-32
    80003578:	ec06                	sd	ra,24(sp)
    8000357a:	e822                	sd	s0,16(sp)
    8000357c:	e426                	sd	s1,8(sp)
    8000357e:	e04a                	sd	s2,0(sp)
    80003580:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003582:	00016917          	auipc	s2,0x16
    80003586:	c9e90913          	addi	s2,s2,-866 # 80019220 <log>
    8000358a:	01892583          	lw	a1,24(s2)
    8000358e:	02892503          	lw	a0,40(s2)
    80003592:	fffff097          	auipc	ra,0xfffff
    80003596:	fde080e7          	jalr	-34(ra) # 80002570 <bread>
    8000359a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000359c:	02c92603          	lw	a2,44(s2)
    800035a0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035a2:	00c05f63          	blez	a2,800035c0 <write_head+0x4a>
    800035a6:	00016717          	auipc	a4,0x16
    800035aa:	caa70713          	addi	a4,a4,-854 # 80019250 <log+0x30>
    800035ae:	87aa                	mv	a5,a0
    800035b0:	060a                	slli	a2,a2,0x2
    800035b2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800035b4:	4314                	lw	a3,0(a4)
    800035b6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800035b8:	0711                	addi	a4,a4,4
    800035ba:	0791                	addi	a5,a5,4
    800035bc:	fec79ce3          	bne	a5,a2,800035b4 <write_head+0x3e>
  }
  bwrite(buf);
    800035c0:	8526                	mv	a0,s1
    800035c2:	fffff097          	auipc	ra,0xfffff
    800035c6:	0a0080e7          	jalr	160(ra) # 80002662 <bwrite>
  brelse(buf);
    800035ca:	8526                	mv	a0,s1
    800035cc:	fffff097          	auipc	ra,0xfffff
    800035d0:	0d4080e7          	jalr	212(ra) # 800026a0 <brelse>
}
    800035d4:	60e2                	ld	ra,24(sp)
    800035d6:	6442                	ld	s0,16(sp)
    800035d8:	64a2                	ld	s1,8(sp)
    800035da:	6902                	ld	s2,0(sp)
    800035dc:	6105                	addi	sp,sp,32
    800035de:	8082                	ret

00000000800035e0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e0:	00016797          	auipc	a5,0x16
    800035e4:	c6c7a783          	lw	a5,-916(a5) # 8001924c <log+0x2c>
    800035e8:	0af05d63          	blez	a5,800036a2 <install_trans+0xc2>
{
    800035ec:	7139                	addi	sp,sp,-64
    800035ee:	fc06                	sd	ra,56(sp)
    800035f0:	f822                	sd	s0,48(sp)
    800035f2:	f426                	sd	s1,40(sp)
    800035f4:	f04a                	sd	s2,32(sp)
    800035f6:	ec4e                	sd	s3,24(sp)
    800035f8:	e852                	sd	s4,16(sp)
    800035fa:	e456                	sd	s5,8(sp)
    800035fc:	e05a                	sd	s6,0(sp)
    800035fe:	0080                	addi	s0,sp,64
    80003600:	8b2a                	mv	s6,a0
    80003602:	00016a97          	auipc	s5,0x16
    80003606:	c4ea8a93          	addi	s5,s5,-946 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000360a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000360c:	00016997          	auipc	s3,0x16
    80003610:	c1498993          	addi	s3,s3,-1004 # 80019220 <log>
    80003614:	a00d                	j	80003636 <install_trans+0x56>
    brelse(lbuf);
    80003616:	854a                	mv	a0,s2
    80003618:	fffff097          	auipc	ra,0xfffff
    8000361c:	088080e7          	jalr	136(ra) # 800026a0 <brelse>
    brelse(dbuf);
    80003620:	8526                	mv	a0,s1
    80003622:	fffff097          	auipc	ra,0xfffff
    80003626:	07e080e7          	jalr	126(ra) # 800026a0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000362a:	2a05                	addiw	s4,s4,1
    8000362c:	0a91                	addi	s5,s5,4
    8000362e:	02c9a783          	lw	a5,44(s3)
    80003632:	04fa5e63          	bge	s4,a5,8000368e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003636:	0189a583          	lw	a1,24(s3)
    8000363a:	014585bb          	addw	a1,a1,s4
    8000363e:	2585                	addiw	a1,a1,1
    80003640:	0289a503          	lw	a0,40(s3)
    80003644:	fffff097          	auipc	ra,0xfffff
    80003648:	f2c080e7          	jalr	-212(ra) # 80002570 <bread>
    8000364c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000364e:	000aa583          	lw	a1,0(s5)
    80003652:	0289a503          	lw	a0,40(s3)
    80003656:	fffff097          	auipc	ra,0xfffff
    8000365a:	f1a080e7          	jalr	-230(ra) # 80002570 <bread>
    8000365e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003660:	40000613          	li	a2,1024
    80003664:	05890593          	addi	a1,s2,88
    80003668:	05850513          	addi	a0,a0,88
    8000366c:	ffffd097          	auipc	ra,0xffffd
    80003670:	b6a080e7          	jalr	-1174(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003674:	8526                	mv	a0,s1
    80003676:	fffff097          	auipc	ra,0xfffff
    8000367a:	fec080e7          	jalr	-20(ra) # 80002662 <bwrite>
    if(recovering == 0)
    8000367e:	f80b1ce3          	bnez	s6,80003616 <install_trans+0x36>
      bunpin(dbuf);
    80003682:	8526                	mv	a0,s1
    80003684:	fffff097          	auipc	ra,0xfffff
    80003688:	0f4080e7          	jalr	244(ra) # 80002778 <bunpin>
    8000368c:	b769                	j	80003616 <install_trans+0x36>
}
    8000368e:	70e2                	ld	ra,56(sp)
    80003690:	7442                	ld	s0,48(sp)
    80003692:	74a2                	ld	s1,40(sp)
    80003694:	7902                	ld	s2,32(sp)
    80003696:	69e2                	ld	s3,24(sp)
    80003698:	6a42                	ld	s4,16(sp)
    8000369a:	6aa2                	ld	s5,8(sp)
    8000369c:	6b02                	ld	s6,0(sp)
    8000369e:	6121                	addi	sp,sp,64
    800036a0:	8082                	ret
    800036a2:	8082                	ret

00000000800036a4 <initlog>:
{
    800036a4:	7179                	addi	sp,sp,-48
    800036a6:	f406                	sd	ra,40(sp)
    800036a8:	f022                	sd	s0,32(sp)
    800036aa:	ec26                	sd	s1,24(sp)
    800036ac:	e84a                	sd	s2,16(sp)
    800036ae:	e44e                	sd	s3,8(sp)
    800036b0:	1800                	addi	s0,sp,48
    800036b2:	892a                	mv	s2,a0
    800036b4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036b6:	00016497          	auipc	s1,0x16
    800036ba:	b6a48493          	addi	s1,s1,-1174 # 80019220 <log>
    800036be:	00005597          	auipc	a1,0x5
    800036c2:	e5258593          	addi	a1,a1,-430 # 80008510 <etext+0x510>
    800036c6:	8526                	mv	a0,s1
    800036c8:	00003097          	auipc	ra,0x3
    800036cc:	d0e080e7          	jalr	-754(ra) # 800063d6 <initlock>
  log.start = sb->logstart;
    800036d0:	0149a583          	lw	a1,20(s3)
    800036d4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036d6:	0109a783          	lw	a5,16(s3)
    800036da:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036dc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036e0:	854a                	mv	a0,s2
    800036e2:	fffff097          	auipc	ra,0xfffff
    800036e6:	e8e080e7          	jalr	-370(ra) # 80002570 <bread>
  log.lh.n = lh->n;
    800036ea:	4d30                	lw	a2,88(a0)
    800036ec:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036ee:	00c05f63          	blez	a2,8000370c <initlog+0x68>
    800036f2:	87aa                	mv	a5,a0
    800036f4:	00016717          	auipc	a4,0x16
    800036f8:	b5c70713          	addi	a4,a4,-1188 # 80019250 <log+0x30>
    800036fc:	060a                	slli	a2,a2,0x2
    800036fe:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003700:	4ff4                	lw	a3,92(a5)
    80003702:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003704:	0791                	addi	a5,a5,4
    80003706:	0711                	addi	a4,a4,4
    80003708:	fec79ce3          	bne	a5,a2,80003700 <initlog+0x5c>
  brelse(buf);
    8000370c:	fffff097          	auipc	ra,0xfffff
    80003710:	f94080e7          	jalr	-108(ra) # 800026a0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003714:	4505                	li	a0,1
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	eca080e7          	jalr	-310(ra) # 800035e0 <install_trans>
  log.lh.n = 0;
    8000371e:	00016797          	auipc	a5,0x16
    80003722:	b207a723          	sw	zero,-1234(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    80003726:	00000097          	auipc	ra,0x0
    8000372a:	e50080e7          	jalr	-432(ra) # 80003576 <write_head>
}
    8000372e:	70a2                	ld	ra,40(sp)
    80003730:	7402                	ld	s0,32(sp)
    80003732:	64e2                	ld	s1,24(sp)
    80003734:	6942                	ld	s2,16(sp)
    80003736:	69a2                	ld	s3,8(sp)
    80003738:	6145                	addi	sp,sp,48
    8000373a:	8082                	ret

000000008000373c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000373c:	1101                	addi	sp,sp,-32
    8000373e:	ec06                	sd	ra,24(sp)
    80003740:	e822                	sd	s0,16(sp)
    80003742:	e426                	sd	s1,8(sp)
    80003744:	e04a                	sd	s2,0(sp)
    80003746:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003748:	00016517          	auipc	a0,0x16
    8000374c:	ad850513          	addi	a0,a0,-1320 # 80019220 <log>
    80003750:	00003097          	auipc	ra,0x3
    80003754:	d16080e7          	jalr	-746(ra) # 80006466 <acquire>
  while(1){
    if(log.committing){
    80003758:	00016497          	auipc	s1,0x16
    8000375c:	ac848493          	addi	s1,s1,-1336 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003760:	4979                	li	s2,30
    80003762:	a039                	j	80003770 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003764:	85a6                	mv	a1,s1
    80003766:	8526                	mv	a0,s1
    80003768:	ffffe097          	auipc	ra,0xffffe
    8000376c:	026080e7          	jalr	38(ra) # 8000178e <sleep>
    if(log.committing){
    80003770:	50dc                	lw	a5,36(s1)
    80003772:	fbed                	bnez	a5,80003764 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003774:	5098                	lw	a4,32(s1)
    80003776:	2705                	addiw	a4,a4,1
    80003778:	0027179b          	slliw	a5,a4,0x2
    8000377c:	9fb9                	addw	a5,a5,a4
    8000377e:	0017979b          	slliw	a5,a5,0x1
    80003782:	54d4                	lw	a3,44(s1)
    80003784:	9fb5                	addw	a5,a5,a3
    80003786:	00f95963          	bge	s2,a5,80003798 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000378a:	85a6                	mv	a1,s1
    8000378c:	8526                	mv	a0,s1
    8000378e:	ffffe097          	auipc	ra,0xffffe
    80003792:	000080e7          	jalr	ra # 8000178e <sleep>
    80003796:	bfe9                	j	80003770 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003798:	00016517          	auipc	a0,0x16
    8000379c:	a8850513          	addi	a0,a0,-1400 # 80019220 <log>
    800037a0:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800037a2:	00003097          	auipc	ra,0x3
    800037a6:	d78080e7          	jalr	-648(ra) # 8000651a <release>
      break;
    }
  }
}
    800037aa:	60e2                	ld	ra,24(sp)
    800037ac:	6442                	ld	s0,16(sp)
    800037ae:	64a2                	ld	s1,8(sp)
    800037b0:	6902                	ld	s2,0(sp)
    800037b2:	6105                	addi	sp,sp,32
    800037b4:	8082                	ret

00000000800037b6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037b6:	7139                	addi	sp,sp,-64
    800037b8:	fc06                	sd	ra,56(sp)
    800037ba:	f822                	sd	s0,48(sp)
    800037bc:	f426                	sd	s1,40(sp)
    800037be:	f04a                	sd	s2,32(sp)
    800037c0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037c2:	00016497          	auipc	s1,0x16
    800037c6:	a5e48493          	addi	s1,s1,-1442 # 80019220 <log>
    800037ca:	8526                	mv	a0,s1
    800037cc:	00003097          	auipc	ra,0x3
    800037d0:	c9a080e7          	jalr	-870(ra) # 80006466 <acquire>
  log.outstanding -= 1;
    800037d4:	509c                	lw	a5,32(s1)
    800037d6:	37fd                	addiw	a5,a5,-1
    800037d8:	0007891b          	sext.w	s2,a5
    800037dc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037de:	50dc                	lw	a5,36(s1)
    800037e0:	e7b9                	bnez	a5,8000382e <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800037e2:	06091163          	bnez	s2,80003844 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037e6:	00016497          	auipc	s1,0x16
    800037ea:	a3a48493          	addi	s1,s1,-1478 # 80019220 <log>
    800037ee:	4785                	li	a5,1
    800037f0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037f2:	8526                	mv	a0,s1
    800037f4:	00003097          	auipc	ra,0x3
    800037f8:	d26080e7          	jalr	-730(ra) # 8000651a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037fc:	54dc                	lw	a5,44(s1)
    800037fe:	06f04763          	bgtz	a5,8000386c <end_op+0xb6>
    acquire(&log.lock);
    80003802:	00016497          	auipc	s1,0x16
    80003806:	a1e48493          	addi	s1,s1,-1506 # 80019220 <log>
    8000380a:	8526                	mv	a0,s1
    8000380c:	00003097          	auipc	ra,0x3
    80003810:	c5a080e7          	jalr	-934(ra) # 80006466 <acquire>
    log.committing = 0;
    80003814:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003818:	8526                	mv	a0,s1
    8000381a:	ffffe097          	auipc	ra,0xffffe
    8000381e:	100080e7          	jalr	256(ra) # 8000191a <wakeup>
    release(&log.lock);
    80003822:	8526                	mv	a0,s1
    80003824:	00003097          	auipc	ra,0x3
    80003828:	cf6080e7          	jalr	-778(ra) # 8000651a <release>
}
    8000382c:	a815                	j	80003860 <end_op+0xaa>
    8000382e:	ec4e                	sd	s3,24(sp)
    80003830:	e852                	sd	s4,16(sp)
    80003832:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003834:	00005517          	auipc	a0,0x5
    80003838:	ce450513          	addi	a0,a0,-796 # 80008518 <etext+0x518>
    8000383c:	00002097          	auipc	ra,0x2
    80003840:	6b0080e7          	jalr	1712(ra) # 80005eec <panic>
    wakeup(&log);
    80003844:	00016497          	auipc	s1,0x16
    80003848:	9dc48493          	addi	s1,s1,-1572 # 80019220 <log>
    8000384c:	8526                	mv	a0,s1
    8000384e:	ffffe097          	auipc	ra,0xffffe
    80003852:	0cc080e7          	jalr	204(ra) # 8000191a <wakeup>
  release(&log.lock);
    80003856:	8526                	mv	a0,s1
    80003858:	00003097          	auipc	ra,0x3
    8000385c:	cc2080e7          	jalr	-830(ra) # 8000651a <release>
}
    80003860:	70e2                	ld	ra,56(sp)
    80003862:	7442                	ld	s0,48(sp)
    80003864:	74a2                	ld	s1,40(sp)
    80003866:	7902                	ld	s2,32(sp)
    80003868:	6121                	addi	sp,sp,64
    8000386a:	8082                	ret
    8000386c:	ec4e                	sd	s3,24(sp)
    8000386e:	e852                	sd	s4,16(sp)
    80003870:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003872:	00016a97          	auipc	s5,0x16
    80003876:	9dea8a93          	addi	s5,s5,-1570 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000387a:	00016a17          	auipc	s4,0x16
    8000387e:	9a6a0a13          	addi	s4,s4,-1626 # 80019220 <log>
    80003882:	018a2583          	lw	a1,24(s4)
    80003886:	012585bb          	addw	a1,a1,s2
    8000388a:	2585                	addiw	a1,a1,1
    8000388c:	028a2503          	lw	a0,40(s4)
    80003890:	fffff097          	auipc	ra,0xfffff
    80003894:	ce0080e7          	jalr	-800(ra) # 80002570 <bread>
    80003898:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000389a:	000aa583          	lw	a1,0(s5)
    8000389e:	028a2503          	lw	a0,40(s4)
    800038a2:	fffff097          	auipc	ra,0xfffff
    800038a6:	cce080e7          	jalr	-818(ra) # 80002570 <bread>
    800038aa:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038ac:	40000613          	li	a2,1024
    800038b0:	05850593          	addi	a1,a0,88
    800038b4:	05848513          	addi	a0,s1,88
    800038b8:	ffffd097          	auipc	ra,0xffffd
    800038bc:	91e080e7          	jalr	-1762(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800038c0:	8526                	mv	a0,s1
    800038c2:	fffff097          	auipc	ra,0xfffff
    800038c6:	da0080e7          	jalr	-608(ra) # 80002662 <bwrite>
    brelse(from);
    800038ca:	854e                	mv	a0,s3
    800038cc:	fffff097          	auipc	ra,0xfffff
    800038d0:	dd4080e7          	jalr	-556(ra) # 800026a0 <brelse>
    brelse(to);
    800038d4:	8526                	mv	a0,s1
    800038d6:	fffff097          	auipc	ra,0xfffff
    800038da:	dca080e7          	jalr	-566(ra) # 800026a0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038de:	2905                	addiw	s2,s2,1
    800038e0:	0a91                	addi	s5,s5,4
    800038e2:	02ca2783          	lw	a5,44(s4)
    800038e6:	f8f94ee3          	blt	s2,a5,80003882 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038ea:	00000097          	auipc	ra,0x0
    800038ee:	c8c080e7          	jalr	-884(ra) # 80003576 <write_head>
    install_trans(0); // Now install writes to home locations
    800038f2:	4501                	li	a0,0
    800038f4:	00000097          	auipc	ra,0x0
    800038f8:	cec080e7          	jalr	-788(ra) # 800035e0 <install_trans>
    log.lh.n = 0;
    800038fc:	00016797          	auipc	a5,0x16
    80003900:	9407a823          	sw	zero,-1712(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003904:	00000097          	auipc	ra,0x0
    80003908:	c72080e7          	jalr	-910(ra) # 80003576 <write_head>
    8000390c:	69e2                	ld	s3,24(sp)
    8000390e:	6a42                	ld	s4,16(sp)
    80003910:	6aa2                	ld	s5,8(sp)
    80003912:	bdc5                	j	80003802 <end_op+0x4c>

0000000080003914 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003914:	1101                	addi	sp,sp,-32
    80003916:	ec06                	sd	ra,24(sp)
    80003918:	e822                	sd	s0,16(sp)
    8000391a:	e426                	sd	s1,8(sp)
    8000391c:	e04a                	sd	s2,0(sp)
    8000391e:	1000                	addi	s0,sp,32
    80003920:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003922:	00016917          	auipc	s2,0x16
    80003926:	8fe90913          	addi	s2,s2,-1794 # 80019220 <log>
    8000392a:	854a                	mv	a0,s2
    8000392c:	00003097          	auipc	ra,0x3
    80003930:	b3a080e7          	jalr	-1222(ra) # 80006466 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003934:	02c92603          	lw	a2,44(s2)
    80003938:	47f5                	li	a5,29
    8000393a:	06c7c563          	blt	a5,a2,800039a4 <log_write+0x90>
    8000393e:	00016797          	auipc	a5,0x16
    80003942:	8fe7a783          	lw	a5,-1794(a5) # 8001923c <log+0x1c>
    80003946:	37fd                	addiw	a5,a5,-1
    80003948:	04f65e63          	bge	a2,a5,800039a4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000394c:	00016797          	auipc	a5,0x16
    80003950:	8f47a783          	lw	a5,-1804(a5) # 80019240 <log+0x20>
    80003954:	06f05063          	blez	a5,800039b4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003958:	4781                	li	a5,0
    8000395a:	06c05563          	blez	a2,800039c4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000395e:	44cc                	lw	a1,12(s1)
    80003960:	00016717          	auipc	a4,0x16
    80003964:	8f070713          	addi	a4,a4,-1808 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003968:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000396a:	4314                	lw	a3,0(a4)
    8000396c:	04b68c63          	beq	a3,a1,800039c4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003970:	2785                	addiw	a5,a5,1
    80003972:	0711                	addi	a4,a4,4
    80003974:	fef61be3          	bne	a2,a5,8000396a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003978:	0621                	addi	a2,a2,8
    8000397a:	060a                	slli	a2,a2,0x2
    8000397c:	00016797          	auipc	a5,0x16
    80003980:	8a478793          	addi	a5,a5,-1884 # 80019220 <log>
    80003984:	97b2                	add	a5,a5,a2
    80003986:	44d8                	lw	a4,12(s1)
    80003988:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000398a:	8526                	mv	a0,s1
    8000398c:	fffff097          	auipc	ra,0xfffff
    80003990:	db0080e7          	jalr	-592(ra) # 8000273c <bpin>
    log.lh.n++;
    80003994:	00016717          	auipc	a4,0x16
    80003998:	88c70713          	addi	a4,a4,-1908 # 80019220 <log>
    8000399c:	575c                	lw	a5,44(a4)
    8000399e:	2785                	addiw	a5,a5,1
    800039a0:	d75c                	sw	a5,44(a4)
    800039a2:	a82d                	j	800039dc <log_write+0xc8>
    panic("too big a transaction");
    800039a4:	00005517          	auipc	a0,0x5
    800039a8:	b8450513          	addi	a0,a0,-1148 # 80008528 <etext+0x528>
    800039ac:	00002097          	auipc	ra,0x2
    800039b0:	540080e7          	jalr	1344(ra) # 80005eec <panic>
    panic("log_write outside of trans");
    800039b4:	00005517          	auipc	a0,0x5
    800039b8:	b8c50513          	addi	a0,a0,-1140 # 80008540 <etext+0x540>
    800039bc:	00002097          	auipc	ra,0x2
    800039c0:	530080e7          	jalr	1328(ra) # 80005eec <panic>
  log.lh.block[i] = b->blockno;
    800039c4:	00878693          	addi	a3,a5,8
    800039c8:	068a                	slli	a3,a3,0x2
    800039ca:	00016717          	auipc	a4,0x16
    800039ce:	85670713          	addi	a4,a4,-1962 # 80019220 <log>
    800039d2:	9736                	add	a4,a4,a3
    800039d4:	44d4                	lw	a3,12(s1)
    800039d6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039d8:	faf609e3          	beq	a2,a5,8000398a <log_write+0x76>
  }
  release(&log.lock);
    800039dc:	00016517          	auipc	a0,0x16
    800039e0:	84450513          	addi	a0,a0,-1980 # 80019220 <log>
    800039e4:	00003097          	auipc	ra,0x3
    800039e8:	b36080e7          	jalr	-1226(ra) # 8000651a <release>
}
    800039ec:	60e2                	ld	ra,24(sp)
    800039ee:	6442                	ld	s0,16(sp)
    800039f0:	64a2                	ld	s1,8(sp)
    800039f2:	6902                	ld	s2,0(sp)
    800039f4:	6105                	addi	sp,sp,32
    800039f6:	8082                	ret

00000000800039f8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039f8:	1101                	addi	sp,sp,-32
    800039fa:	ec06                	sd	ra,24(sp)
    800039fc:	e822                	sd	s0,16(sp)
    800039fe:	e426                	sd	s1,8(sp)
    80003a00:	e04a                	sd	s2,0(sp)
    80003a02:	1000                	addi	s0,sp,32
    80003a04:	84aa                	mv	s1,a0
    80003a06:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a08:	00005597          	auipc	a1,0x5
    80003a0c:	b5858593          	addi	a1,a1,-1192 # 80008560 <etext+0x560>
    80003a10:	0521                	addi	a0,a0,8
    80003a12:	00003097          	auipc	ra,0x3
    80003a16:	9c4080e7          	jalr	-1596(ra) # 800063d6 <initlock>
  lk->name = name;
    80003a1a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a1e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a22:	0204a423          	sw	zero,40(s1)
}
    80003a26:	60e2                	ld	ra,24(sp)
    80003a28:	6442                	ld	s0,16(sp)
    80003a2a:	64a2                	ld	s1,8(sp)
    80003a2c:	6902                	ld	s2,0(sp)
    80003a2e:	6105                	addi	sp,sp,32
    80003a30:	8082                	ret

0000000080003a32 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a32:	1101                	addi	sp,sp,-32
    80003a34:	ec06                	sd	ra,24(sp)
    80003a36:	e822                	sd	s0,16(sp)
    80003a38:	e426                	sd	s1,8(sp)
    80003a3a:	e04a                	sd	s2,0(sp)
    80003a3c:	1000                	addi	s0,sp,32
    80003a3e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a40:	00850913          	addi	s2,a0,8
    80003a44:	854a                	mv	a0,s2
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	a20080e7          	jalr	-1504(ra) # 80006466 <acquire>
  while (lk->locked) {
    80003a4e:	409c                	lw	a5,0(s1)
    80003a50:	cb89                	beqz	a5,80003a62 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a52:	85ca                	mv	a1,s2
    80003a54:	8526                	mv	a0,s1
    80003a56:	ffffe097          	auipc	ra,0xffffe
    80003a5a:	d38080e7          	jalr	-712(ra) # 8000178e <sleep>
  while (lk->locked) {
    80003a5e:	409c                	lw	a5,0(s1)
    80003a60:	fbed                	bnez	a5,80003a52 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a62:	4785                	li	a5,1
    80003a64:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a66:	ffffd097          	auipc	ra,0xffffd
    80003a6a:	5ae080e7          	jalr	1454(ra) # 80001014 <myproc>
    80003a6e:	591c                	lw	a5,48(a0)
    80003a70:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a72:	854a                	mv	a0,s2
    80003a74:	00003097          	auipc	ra,0x3
    80003a78:	aa6080e7          	jalr	-1370(ra) # 8000651a <release>
}
    80003a7c:	60e2                	ld	ra,24(sp)
    80003a7e:	6442                	ld	s0,16(sp)
    80003a80:	64a2                	ld	s1,8(sp)
    80003a82:	6902                	ld	s2,0(sp)
    80003a84:	6105                	addi	sp,sp,32
    80003a86:	8082                	ret

0000000080003a88 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a88:	1101                	addi	sp,sp,-32
    80003a8a:	ec06                	sd	ra,24(sp)
    80003a8c:	e822                	sd	s0,16(sp)
    80003a8e:	e426                	sd	s1,8(sp)
    80003a90:	e04a                	sd	s2,0(sp)
    80003a92:	1000                	addi	s0,sp,32
    80003a94:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a96:	00850913          	addi	s2,a0,8
    80003a9a:	854a                	mv	a0,s2
    80003a9c:	00003097          	auipc	ra,0x3
    80003aa0:	9ca080e7          	jalr	-1590(ra) # 80006466 <acquire>
  lk->locked = 0;
    80003aa4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aa8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003aac:	8526                	mv	a0,s1
    80003aae:	ffffe097          	auipc	ra,0xffffe
    80003ab2:	e6c080e7          	jalr	-404(ra) # 8000191a <wakeup>
  release(&lk->lk);
    80003ab6:	854a                	mv	a0,s2
    80003ab8:	00003097          	auipc	ra,0x3
    80003abc:	a62080e7          	jalr	-1438(ra) # 8000651a <release>
}
    80003ac0:	60e2                	ld	ra,24(sp)
    80003ac2:	6442                	ld	s0,16(sp)
    80003ac4:	64a2                	ld	s1,8(sp)
    80003ac6:	6902                	ld	s2,0(sp)
    80003ac8:	6105                	addi	sp,sp,32
    80003aca:	8082                	ret

0000000080003acc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003acc:	7179                	addi	sp,sp,-48
    80003ace:	f406                	sd	ra,40(sp)
    80003ad0:	f022                	sd	s0,32(sp)
    80003ad2:	ec26                	sd	s1,24(sp)
    80003ad4:	e84a                	sd	s2,16(sp)
    80003ad6:	1800                	addi	s0,sp,48
    80003ad8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ada:	00850913          	addi	s2,a0,8
    80003ade:	854a                	mv	a0,s2
    80003ae0:	00003097          	auipc	ra,0x3
    80003ae4:	986080e7          	jalr	-1658(ra) # 80006466 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ae8:	409c                	lw	a5,0(s1)
    80003aea:	ef91                	bnez	a5,80003b06 <holdingsleep+0x3a>
    80003aec:	4481                	li	s1,0
  release(&lk->lk);
    80003aee:	854a                	mv	a0,s2
    80003af0:	00003097          	auipc	ra,0x3
    80003af4:	a2a080e7          	jalr	-1494(ra) # 8000651a <release>
  return r;
}
    80003af8:	8526                	mv	a0,s1
    80003afa:	70a2                	ld	ra,40(sp)
    80003afc:	7402                	ld	s0,32(sp)
    80003afe:	64e2                	ld	s1,24(sp)
    80003b00:	6942                	ld	s2,16(sp)
    80003b02:	6145                	addi	sp,sp,48
    80003b04:	8082                	ret
    80003b06:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b08:	0284a983          	lw	s3,40(s1)
    80003b0c:	ffffd097          	auipc	ra,0xffffd
    80003b10:	508080e7          	jalr	1288(ra) # 80001014 <myproc>
    80003b14:	5904                	lw	s1,48(a0)
    80003b16:	413484b3          	sub	s1,s1,s3
    80003b1a:	0014b493          	seqz	s1,s1
    80003b1e:	69a2                	ld	s3,8(sp)
    80003b20:	b7f9                	j	80003aee <holdingsleep+0x22>

0000000080003b22 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b22:	1141                	addi	sp,sp,-16
    80003b24:	e406                	sd	ra,8(sp)
    80003b26:	e022                	sd	s0,0(sp)
    80003b28:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b2a:	00005597          	auipc	a1,0x5
    80003b2e:	a4658593          	addi	a1,a1,-1466 # 80008570 <etext+0x570>
    80003b32:	00016517          	auipc	a0,0x16
    80003b36:	83650513          	addi	a0,a0,-1994 # 80019368 <ftable>
    80003b3a:	00003097          	auipc	ra,0x3
    80003b3e:	89c080e7          	jalr	-1892(ra) # 800063d6 <initlock>
}
    80003b42:	60a2                	ld	ra,8(sp)
    80003b44:	6402                	ld	s0,0(sp)
    80003b46:	0141                	addi	sp,sp,16
    80003b48:	8082                	ret

0000000080003b4a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b4a:	1101                	addi	sp,sp,-32
    80003b4c:	ec06                	sd	ra,24(sp)
    80003b4e:	e822                	sd	s0,16(sp)
    80003b50:	e426                	sd	s1,8(sp)
    80003b52:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b54:	00016517          	auipc	a0,0x16
    80003b58:	81450513          	addi	a0,a0,-2028 # 80019368 <ftable>
    80003b5c:	00003097          	auipc	ra,0x3
    80003b60:	90a080e7          	jalr	-1782(ra) # 80006466 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b64:	00016497          	auipc	s1,0x16
    80003b68:	81c48493          	addi	s1,s1,-2020 # 80019380 <ftable+0x18>
    80003b6c:	00016717          	auipc	a4,0x16
    80003b70:	7b470713          	addi	a4,a4,1972 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b74:	40dc                	lw	a5,4(s1)
    80003b76:	cf99                	beqz	a5,80003b94 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b78:	02848493          	addi	s1,s1,40
    80003b7c:	fee49ce3          	bne	s1,a4,80003b74 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b80:	00015517          	auipc	a0,0x15
    80003b84:	7e850513          	addi	a0,a0,2024 # 80019368 <ftable>
    80003b88:	00003097          	auipc	ra,0x3
    80003b8c:	992080e7          	jalr	-1646(ra) # 8000651a <release>
  return 0;
    80003b90:	4481                	li	s1,0
    80003b92:	a819                	j	80003ba8 <filealloc+0x5e>
      f->ref = 1;
    80003b94:	4785                	li	a5,1
    80003b96:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b98:	00015517          	auipc	a0,0x15
    80003b9c:	7d050513          	addi	a0,a0,2000 # 80019368 <ftable>
    80003ba0:	00003097          	auipc	ra,0x3
    80003ba4:	97a080e7          	jalr	-1670(ra) # 8000651a <release>
}
    80003ba8:	8526                	mv	a0,s1
    80003baa:	60e2                	ld	ra,24(sp)
    80003bac:	6442                	ld	s0,16(sp)
    80003bae:	64a2                	ld	s1,8(sp)
    80003bb0:	6105                	addi	sp,sp,32
    80003bb2:	8082                	ret

0000000080003bb4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bb4:	1101                	addi	sp,sp,-32
    80003bb6:	ec06                	sd	ra,24(sp)
    80003bb8:	e822                	sd	s0,16(sp)
    80003bba:	e426                	sd	s1,8(sp)
    80003bbc:	1000                	addi	s0,sp,32
    80003bbe:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bc0:	00015517          	auipc	a0,0x15
    80003bc4:	7a850513          	addi	a0,a0,1960 # 80019368 <ftable>
    80003bc8:	00003097          	auipc	ra,0x3
    80003bcc:	89e080e7          	jalr	-1890(ra) # 80006466 <acquire>
  if(f->ref < 1)
    80003bd0:	40dc                	lw	a5,4(s1)
    80003bd2:	02f05263          	blez	a5,80003bf6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bd6:	2785                	addiw	a5,a5,1
    80003bd8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bda:	00015517          	auipc	a0,0x15
    80003bde:	78e50513          	addi	a0,a0,1934 # 80019368 <ftable>
    80003be2:	00003097          	auipc	ra,0x3
    80003be6:	938080e7          	jalr	-1736(ra) # 8000651a <release>
  return f;
}
    80003bea:	8526                	mv	a0,s1
    80003bec:	60e2                	ld	ra,24(sp)
    80003bee:	6442                	ld	s0,16(sp)
    80003bf0:	64a2                	ld	s1,8(sp)
    80003bf2:	6105                	addi	sp,sp,32
    80003bf4:	8082                	ret
    panic("filedup");
    80003bf6:	00005517          	auipc	a0,0x5
    80003bfa:	98250513          	addi	a0,a0,-1662 # 80008578 <etext+0x578>
    80003bfe:	00002097          	auipc	ra,0x2
    80003c02:	2ee080e7          	jalr	750(ra) # 80005eec <panic>

0000000080003c06 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c06:	7139                	addi	sp,sp,-64
    80003c08:	fc06                	sd	ra,56(sp)
    80003c0a:	f822                	sd	s0,48(sp)
    80003c0c:	f426                	sd	s1,40(sp)
    80003c0e:	0080                	addi	s0,sp,64
    80003c10:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c12:	00015517          	auipc	a0,0x15
    80003c16:	75650513          	addi	a0,a0,1878 # 80019368 <ftable>
    80003c1a:	00003097          	auipc	ra,0x3
    80003c1e:	84c080e7          	jalr	-1972(ra) # 80006466 <acquire>
  if(f->ref < 1)
    80003c22:	40dc                	lw	a5,4(s1)
    80003c24:	04f05c63          	blez	a5,80003c7c <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003c28:	37fd                	addiw	a5,a5,-1
    80003c2a:	0007871b          	sext.w	a4,a5
    80003c2e:	c0dc                	sw	a5,4(s1)
    80003c30:	06e04263          	bgtz	a4,80003c94 <fileclose+0x8e>
    80003c34:	f04a                	sd	s2,32(sp)
    80003c36:	ec4e                	sd	s3,24(sp)
    80003c38:	e852                	sd	s4,16(sp)
    80003c3a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c3c:	0004a903          	lw	s2,0(s1)
    80003c40:	0094ca83          	lbu	s5,9(s1)
    80003c44:	0104ba03          	ld	s4,16(s1)
    80003c48:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c4c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c50:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c54:	00015517          	auipc	a0,0x15
    80003c58:	71450513          	addi	a0,a0,1812 # 80019368 <ftable>
    80003c5c:	00003097          	auipc	ra,0x3
    80003c60:	8be080e7          	jalr	-1858(ra) # 8000651a <release>

  if(ff.type == FD_PIPE){
    80003c64:	4785                	li	a5,1
    80003c66:	04f90463          	beq	s2,a5,80003cae <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c6a:	3979                	addiw	s2,s2,-2
    80003c6c:	4785                	li	a5,1
    80003c6e:	0527fb63          	bgeu	a5,s2,80003cc4 <fileclose+0xbe>
    80003c72:	7902                	ld	s2,32(sp)
    80003c74:	69e2                	ld	s3,24(sp)
    80003c76:	6a42                	ld	s4,16(sp)
    80003c78:	6aa2                	ld	s5,8(sp)
    80003c7a:	a02d                	j	80003ca4 <fileclose+0x9e>
    80003c7c:	f04a                	sd	s2,32(sp)
    80003c7e:	ec4e                	sd	s3,24(sp)
    80003c80:	e852                	sd	s4,16(sp)
    80003c82:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c84:	00005517          	auipc	a0,0x5
    80003c88:	8fc50513          	addi	a0,a0,-1796 # 80008580 <etext+0x580>
    80003c8c:	00002097          	auipc	ra,0x2
    80003c90:	260080e7          	jalr	608(ra) # 80005eec <panic>
    release(&ftable.lock);
    80003c94:	00015517          	auipc	a0,0x15
    80003c98:	6d450513          	addi	a0,a0,1748 # 80019368 <ftable>
    80003c9c:	00003097          	auipc	ra,0x3
    80003ca0:	87e080e7          	jalr	-1922(ra) # 8000651a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003ca4:	70e2                	ld	ra,56(sp)
    80003ca6:	7442                	ld	s0,48(sp)
    80003ca8:	74a2                	ld	s1,40(sp)
    80003caa:	6121                	addi	sp,sp,64
    80003cac:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cae:	85d6                	mv	a1,s5
    80003cb0:	8552                	mv	a0,s4
    80003cb2:	00000097          	auipc	ra,0x0
    80003cb6:	3a2080e7          	jalr	930(ra) # 80004054 <pipeclose>
    80003cba:	7902                	ld	s2,32(sp)
    80003cbc:	69e2                	ld	s3,24(sp)
    80003cbe:	6a42                	ld	s4,16(sp)
    80003cc0:	6aa2                	ld	s5,8(sp)
    80003cc2:	b7cd                	j	80003ca4 <fileclose+0x9e>
    begin_op();
    80003cc4:	00000097          	auipc	ra,0x0
    80003cc8:	a78080e7          	jalr	-1416(ra) # 8000373c <begin_op>
    iput(ff.ip);
    80003ccc:	854e                	mv	a0,s3
    80003cce:	fffff097          	auipc	ra,0xfffff
    80003cd2:	25a080e7          	jalr	602(ra) # 80002f28 <iput>
    end_op();
    80003cd6:	00000097          	auipc	ra,0x0
    80003cda:	ae0080e7          	jalr	-1312(ra) # 800037b6 <end_op>
    80003cde:	7902                	ld	s2,32(sp)
    80003ce0:	69e2                	ld	s3,24(sp)
    80003ce2:	6a42                	ld	s4,16(sp)
    80003ce4:	6aa2                	ld	s5,8(sp)
    80003ce6:	bf7d                	j	80003ca4 <fileclose+0x9e>

0000000080003ce8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ce8:	715d                	addi	sp,sp,-80
    80003cea:	e486                	sd	ra,72(sp)
    80003cec:	e0a2                	sd	s0,64(sp)
    80003cee:	fc26                	sd	s1,56(sp)
    80003cf0:	f44e                	sd	s3,40(sp)
    80003cf2:	0880                	addi	s0,sp,80
    80003cf4:	84aa                	mv	s1,a0
    80003cf6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cf8:	ffffd097          	auipc	ra,0xffffd
    80003cfc:	31c080e7          	jalr	796(ra) # 80001014 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d00:	409c                	lw	a5,0(s1)
    80003d02:	37f9                	addiw	a5,a5,-2
    80003d04:	4705                	li	a4,1
    80003d06:	04f76863          	bltu	a4,a5,80003d56 <filestat+0x6e>
    80003d0a:	f84a                	sd	s2,48(sp)
    80003d0c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d0e:	6c88                	ld	a0,24(s1)
    80003d10:	fffff097          	auipc	ra,0xfffff
    80003d14:	05a080e7          	jalr	90(ra) # 80002d6a <ilock>
    stati(f->ip, &st);
    80003d18:	fb840593          	addi	a1,s0,-72
    80003d1c:	6c88                	ld	a0,24(s1)
    80003d1e:	fffff097          	auipc	ra,0xfffff
    80003d22:	2da080e7          	jalr	730(ra) # 80002ff8 <stati>
    iunlock(f->ip);
    80003d26:	6c88                	ld	a0,24(s1)
    80003d28:	fffff097          	auipc	ra,0xfffff
    80003d2c:	108080e7          	jalr	264(ra) # 80002e30 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d30:	46e1                	li	a3,24
    80003d32:	fb840613          	addi	a2,s0,-72
    80003d36:	85ce                	mv	a1,s3
    80003d38:	06093503          	ld	a0,96(s2)
    80003d3c:	ffffd097          	auipc	ra,0xffffd
    80003d40:	ddc080e7          	jalr	-548(ra) # 80000b18 <copyout>
    80003d44:	41f5551b          	sraiw	a0,a0,0x1f
    80003d48:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003d4a:	60a6                	ld	ra,72(sp)
    80003d4c:	6406                	ld	s0,64(sp)
    80003d4e:	74e2                	ld	s1,56(sp)
    80003d50:	79a2                	ld	s3,40(sp)
    80003d52:	6161                	addi	sp,sp,80
    80003d54:	8082                	ret
  return -1;
    80003d56:	557d                	li	a0,-1
    80003d58:	bfcd                	j	80003d4a <filestat+0x62>

0000000080003d5a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d5a:	7179                	addi	sp,sp,-48
    80003d5c:	f406                	sd	ra,40(sp)
    80003d5e:	f022                	sd	s0,32(sp)
    80003d60:	e84a                	sd	s2,16(sp)
    80003d62:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d64:	00854783          	lbu	a5,8(a0)
    80003d68:	cbc5                	beqz	a5,80003e18 <fileread+0xbe>
    80003d6a:	ec26                	sd	s1,24(sp)
    80003d6c:	e44e                	sd	s3,8(sp)
    80003d6e:	84aa                	mv	s1,a0
    80003d70:	89ae                	mv	s3,a1
    80003d72:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d74:	411c                	lw	a5,0(a0)
    80003d76:	4705                	li	a4,1
    80003d78:	04e78963          	beq	a5,a4,80003dca <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d7c:	470d                	li	a4,3
    80003d7e:	04e78f63          	beq	a5,a4,80003ddc <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d82:	4709                	li	a4,2
    80003d84:	08e79263          	bne	a5,a4,80003e08 <fileread+0xae>
    ilock(f->ip);
    80003d88:	6d08                	ld	a0,24(a0)
    80003d8a:	fffff097          	auipc	ra,0xfffff
    80003d8e:	fe0080e7          	jalr	-32(ra) # 80002d6a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d92:	874a                	mv	a4,s2
    80003d94:	5094                	lw	a3,32(s1)
    80003d96:	864e                	mv	a2,s3
    80003d98:	4585                	li	a1,1
    80003d9a:	6c88                	ld	a0,24(s1)
    80003d9c:	fffff097          	auipc	ra,0xfffff
    80003da0:	286080e7          	jalr	646(ra) # 80003022 <readi>
    80003da4:	892a                	mv	s2,a0
    80003da6:	00a05563          	blez	a0,80003db0 <fileread+0x56>
      f->off += r;
    80003daa:	509c                	lw	a5,32(s1)
    80003dac:	9fa9                	addw	a5,a5,a0
    80003dae:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003db0:	6c88                	ld	a0,24(s1)
    80003db2:	fffff097          	auipc	ra,0xfffff
    80003db6:	07e080e7          	jalr	126(ra) # 80002e30 <iunlock>
    80003dba:	64e2                	ld	s1,24(sp)
    80003dbc:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003dbe:	854a                	mv	a0,s2
    80003dc0:	70a2                	ld	ra,40(sp)
    80003dc2:	7402                	ld	s0,32(sp)
    80003dc4:	6942                	ld	s2,16(sp)
    80003dc6:	6145                	addi	sp,sp,48
    80003dc8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003dca:	6908                	ld	a0,16(a0)
    80003dcc:	00000097          	auipc	ra,0x0
    80003dd0:	3fa080e7          	jalr	1018(ra) # 800041c6 <piperead>
    80003dd4:	892a                	mv	s2,a0
    80003dd6:	64e2                	ld	s1,24(sp)
    80003dd8:	69a2                	ld	s3,8(sp)
    80003dda:	b7d5                	j	80003dbe <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ddc:	02451783          	lh	a5,36(a0)
    80003de0:	03079693          	slli	a3,a5,0x30
    80003de4:	92c1                	srli	a3,a3,0x30
    80003de6:	4725                	li	a4,9
    80003de8:	02d76a63          	bltu	a4,a3,80003e1c <fileread+0xc2>
    80003dec:	0792                	slli	a5,a5,0x4
    80003dee:	00015717          	auipc	a4,0x15
    80003df2:	4da70713          	addi	a4,a4,1242 # 800192c8 <devsw>
    80003df6:	97ba                	add	a5,a5,a4
    80003df8:	639c                	ld	a5,0(a5)
    80003dfa:	c78d                	beqz	a5,80003e24 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003dfc:	4505                	li	a0,1
    80003dfe:	9782                	jalr	a5
    80003e00:	892a                	mv	s2,a0
    80003e02:	64e2                	ld	s1,24(sp)
    80003e04:	69a2                	ld	s3,8(sp)
    80003e06:	bf65                	j	80003dbe <fileread+0x64>
    panic("fileread");
    80003e08:	00004517          	auipc	a0,0x4
    80003e0c:	78850513          	addi	a0,a0,1928 # 80008590 <etext+0x590>
    80003e10:	00002097          	auipc	ra,0x2
    80003e14:	0dc080e7          	jalr	220(ra) # 80005eec <panic>
    return -1;
    80003e18:	597d                	li	s2,-1
    80003e1a:	b755                	j	80003dbe <fileread+0x64>
      return -1;
    80003e1c:	597d                	li	s2,-1
    80003e1e:	64e2                	ld	s1,24(sp)
    80003e20:	69a2                	ld	s3,8(sp)
    80003e22:	bf71                	j	80003dbe <fileread+0x64>
    80003e24:	597d                	li	s2,-1
    80003e26:	64e2                	ld	s1,24(sp)
    80003e28:	69a2                	ld	s3,8(sp)
    80003e2a:	bf51                	j	80003dbe <fileread+0x64>

0000000080003e2c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003e2c:	00954783          	lbu	a5,9(a0)
    80003e30:	12078963          	beqz	a5,80003f62 <filewrite+0x136>
{
    80003e34:	715d                	addi	sp,sp,-80
    80003e36:	e486                	sd	ra,72(sp)
    80003e38:	e0a2                	sd	s0,64(sp)
    80003e3a:	f84a                	sd	s2,48(sp)
    80003e3c:	f052                	sd	s4,32(sp)
    80003e3e:	e85a                	sd	s6,16(sp)
    80003e40:	0880                	addi	s0,sp,80
    80003e42:	892a                	mv	s2,a0
    80003e44:	8b2e                	mv	s6,a1
    80003e46:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e48:	411c                	lw	a5,0(a0)
    80003e4a:	4705                	li	a4,1
    80003e4c:	02e78763          	beq	a5,a4,80003e7a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e50:	470d                	li	a4,3
    80003e52:	02e78a63          	beq	a5,a4,80003e86 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e56:	4709                	li	a4,2
    80003e58:	0ee79863          	bne	a5,a4,80003f48 <filewrite+0x11c>
    80003e5c:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e5e:	0cc05463          	blez	a2,80003f26 <filewrite+0xfa>
    80003e62:	fc26                	sd	s1,56(sp)
    80003e64:	ec56                	sd	s5,24(sp)
    80003e66:	e45e                	sd	s7,8(sp)
    80003e68:	e062                	sd	s8,0(sp)
    int i = 0;
    80003e6a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003e6c:	6b85                	lui	s7,0x1
    80003e6e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e72:	6c05                	lui	s8,0x1
    80003e74:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e78:	a851                	j	80003f0c <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e7a:	6908                	ld	a0,16(a0)
    80003e7c:	00000097          	auipc	ra,0x0
    80003e80:	248080e7          	jalr	584(ra) # 800040c4 <pipewrite>
    80003e84:	a85d                	j	80003f3a <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e86:	02451783          	lh	a5,36(a0)
    80003e8a:	03079693          	slli	a3,a5,0x30
    80003e8e:	92c1                	srli	a3,a3,0x30
    80003e90:	4725                	li	a4,9
    80003e92:	0cd76a63          	bltu	a4,a3,80003f66 <filewrite+0x13a>
    80003e96:	0792                	slli	a5,a5,0x4
    80003e98:	00015717          	auipc	a4,0x15
    80003e9c:	43070713          	addi	a4,a4,1072 # 800192c8 <devsw>
    80003ea0:	97ba                	add	a5,a5,a4
    80003ea2:	679c                	ld	a5,8(a5)
    80003ea4:	c3f9                	beqz	a5,80003f6a <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003ea6:	4505                	li	a0,1
    80003ea8:	9782                	jalr	a5
    80003eaa:	a841                	j	80003f3a <filewrite+0x10e>
      if(n1 > max)
    80003eac:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003eb0:	00000097          	auipc	ra,0x0
    80003eb4:	88c080e7          	jalr	-1908(ra) # 8000373c <begin_op>
      ilock(f->ip);
    80003eb8:	01893503          	ld	a0,24(s2)
    80003ebc:	fffff097          	auipc	ra,0xfffff
    80003ec0:	eae080e7          	jalr	-338(ra) # 80002d6a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ec4:	8756                	mv	a4,s5
    80003ec6:	02092683          	lw	a3,32(s2)
    80003eca:	01698633          	add	a2,s3,s6
    80003ece:	4585                	li	a1,1
    80003ed0:	01893503          	ld	a0,24(s2)
    80003ed4:	fffff097          	auipc	ra,0xfffff
    80003ed8:	252080e7          	jalr	594(ra) # 80003126 <writei>
    80003edc:	84aa                	mv	s1,a0
    80003ede:	00a05763          	blez	a0,80003eec <filewrite+0xc0>
        f->off += r;
    80003ee2:	02092783          	lw	a5,32(s2)
    80003ee6:	9fa9                	addw	a5,a5,a0
    80003ee8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003eec:	01893503          	ld	a0,24(s2)
    80003ef0:	fffff097          	auipc	ra,0xfffff
    80003ef4:	f40080e7          	jalr	-192(ra) # 80002e30 <iunlock>
      end_op();
    80003ef8:	00000097          	auipc	ra,0x0
    80003efc:	8be080e7          	jalr	-1858(ra) # 800037b6 <end_op>

      if(r != n1){
    80003f00:	029a9563          	bne	s5,s1,80003f2a <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003f04:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f08:	0149da63          	bge	s3,s4,80003f1c <filewrite+0xf0>
      int n1 = n - i;
    80003f0c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003f10:	0004879b          	sext.w	a5,s1
    80003f14:	f8fbdce3          	bge	s7,a5,80003eac <filewrite+0x80>
    80003f18:	84e2                	mv	s1,s8
    80003f1a:	bf49                	j	80003eac <filewrite+0x80>
    80003f1c:	74e2                	ld	s1,56(sp)
    80003f1e:	6ae2                	ld	s5,24(sp)
    80003f20:	6ba2                	ld	s7,8(sp)
    80003f22:	6c02                	ld	s8,0(sp)
    80003f24:	a039                	j	80003f32 <filewrite+0x106>
    int i = 0;
    80003f26:	4981                	li	s3,0
    80003f28:	a029                	j	80003f32 <filewrite+0x106>
    80003f2a:	74e2                	ld	s1,56(sp)
    80003f2c:	6ae2                	ld	s5,24(sp)
    80003f2e:	6ba2                	ld	s7,8(sp)
    80003f30:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003f32:	033a1e63          	bne	s4,s3,80003f6e <filewrite+0x142>
    80003f36:	8552                	mv	a0,s4
    80003f38:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f3a:	60a6                	ld	ra,72(sp)
    80003f3c:	6406                	ld	s0,64(sp)
    80003f3e:	7942                	ld	s2,48(sp)
    80003f40:	7a02                	ld	s4,32(sp)
    80003f42:	6b42                	ld	s6,16(sp)
    80003f44:	6161                	addi	sp,sp,80
    80003f46:	8082                	ret
    80003f48:	fc26                	sd	s1,56(sp)
    80003f4a:	f44e                	sd	s3,40(sp)
    80003f4c:	ec56                	sd	s5,24(sp)
    80003f4e:	e45e                	sd	s7,8(sp)
    80003f50:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003f52:	00004517          	auipc	a0,0x4
    80003f56:	64e50513          	addi	a0,a0,1614 # 800085a0 <etext+0x5a0>
    80003f5a:	00002097          	auipc	ra,0x2
    80003f5e:	f92080e7          	jalr	-110(ra) # 80005eec <panic>
    return -1;
    80003f62:	557d                	li	a0,-1
}
    80003f64:	8082                	ret
      return -1;
    80003f66:	557d                	li	a0,-1
    80003f68:	bfc9                	j	80003f3a <filewrite+0x10e>
    80003f6a:	557d                	li	a0,-1
    80003f6c:	b7f9                	j	80003f3a <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003f6e:	557d                	li	a0,-1
    80003f70:	79a2                	ld	s3,40(sp)
    80003f72:	b7e1                	j	80003f3a <filewrite+0x10e>

0000000080003f74 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f74:	7179                	addi	sp,sp,-48
    80003f76:	f406                	sd	ra,40(sp)
    80003f78:	f022                	sd	s0,32(sp)
    80003f7a:	ec26                	sd	s1,24(sp)
    80003f7c:	e052                	sd	s4,0(sp)
    80003f7e:	1800                	addi	s0,sp,48
    80003f80:	84aa                	mv	s1,a0
    80003f82:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f84:	0005b023          	sd	zero,0(a1)
    80003f88:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	bbe080e7          	jalr	-1090(ra) # 80003b4a <filealloc>
    80003f94:	e088                	sd	a0,0(s1)
    80003f96:	cd49                	beqz	a0,80004030 <pipealloc+0xbc>
    80003f98:	00000097          	auipc	ra,0x0
    80003f9c:	bb2080e7          	jalr	-1102(ra) # 80003b4a <filealloc>
    80003fa0:	00aa3023          	sd	a0,0(s4)
    80003fa4:	c141                	beqz	a0,80004024 <pipealloc+0xb0>
    80003fa6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fa8:	ffffc097          	auipc	ra,0xffffc
    80003fac:	172080e7          	jalr	370(ra) # 8000011a <kalloc>
    80003fb0:	892a                	mv	s2,a0
    80003fb2:	c13d                	beqz	a0,80004018 <pipealloc+0xa4>
    80003fb4:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003fb6:	4985                	li	s3,1
    80003fb8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003fbc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003fc0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003fc4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003fc8:	00004597          	auipc	a1,0x4
    80003fcc:	5e858593          	addi	a1,a1,1512 # 800085b0 <etext+0x5b0>
    80003fd0:	00002097          	auipc	ra,0x2
    80003fd4:	406080e7          	jalr	1030(ra) # 800063d6 <initlock>
  (*f0)->type = FD_PIPE;
    80003fd8:	609c                	ld	a5,0(s1)
    80003fda:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fde:	609c                	ld	a5,0(s1)
    80003fe0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fe4:	609c                	ld	a5,0(s1)
    80003fe6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fea:	609c                	ld	a5,0(s1)
    80003fec:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ff0:	000a3783          	ld	a5,0(s4)
    80003ff4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ff8:	000a3783          	ld	a5,0(s4)
    80003ffc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004000:	000a3783          	ld	a5,0(s4)
    80004004:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004008:	000a3783          	ld	a5,0(s4)
    8000400c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004010:	4501                	li	a0,0
    80004012:	6942                	ld	s2,16(sp)
    80004014:	69a2                	ld	s3,8(sp)
    80004016:	a03d                	j	80004044 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004018:	6088                	ld	a0,0(s1)
    8000401a:	c119                	beqz	a0,80004020 <pipealloc+0xac>
    8000401c:	6942                	ld	s2,16(sp)
    8000401e:	a029                	j	80004028 <pipealloc+0xb4>
    80004020:	6942                	ld	s2,16(sp)
    80004022:	a039                	j	80004030 <pipealloc+0xbc>
    80004024:	6088                	ld	a0,0(s1)
    80004026:	c50d                	beqz	a0,80004050 <pipealloc+0xdc>
    fileclose(*f0);
    80004028:	00000097          	auipc	ra,0x0
    8000402c:	bde080e7          	jalr	-1058(ra) # 80003c06 <fileclose>
  if(*f1)
    80004030:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004034:	557d                	li	a0,-1
  if(*f1)
    80004036:	c799                	beqz	a5,80004044 <pipealloc+0xd0>
    fileclose(*f1);
    80004038:	853e                	mv	a0,a5
    8000403a:	00000097          	auipc	ra,0x0
    8000403e:	bcc080e7          	jalr	-1076(ra) # 80003c06 <fileclose>
  return -1;
    80004042:	557d                	li	a0,-1
}
    80004044:	70a2                	ld	ra,40(sp)
    80004046:	7402                	ld	s0,32(sp)
    80004048:	64e2                	ld	s1,24(sp)
    8000404a:	6a02                	ld	s4,0(sp)
    8000404c:	6145                	addi	sp,sp,48
    8000404e:	8082                	ret
  return -1;
    80004050:	557d                	li	a0,-1
    80004052:	bfcd                	j	80004044 <pipealloc+0xd0>

0000000080004054 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004054:	1101                	addi	sp,sp,-32
    80004056:	ec06                	sd	ra,24(sp)
    80004058:	e822                	sd	s0,16(sp)
    8000405a:	e426                	sd	s1,8(sp)
    8000405c:	e04a                	sd	s2,0(sp)
    8000405e:	1000                	addi	s0,sp,32
    80004060:	84aa                	mv	s1,a0
    80004062:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004064:	00002097          	auipc	ra,0x2
    80004068:	402080e7          	jalr	1026(ra) # 80006466 <acquire>
  if(writable){
    8000406c:	02090d63          	beqz	s2,800040a6 <pipeclose+0x52>
    pi->writeopen = 0;
    80004070:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004074:	21848513          	addi	a0,s1,536
    80004078:	ffffe097          	auipc	ra,0xffffe
    8000407c:	8a2080e7          	jalr	-1886(ra) # 8000191a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004080:	2204b783          	ld	a5,544(s1)
    80004084:	eb95                	bnez	a5,800040b8 <pipeclose+0x64>
    release(&pi->lock);
    80004086:	8526                	mv	a0,s1
    80004088:	00002097          	auipc	ra,0x2
    8000408c:	492080e7          	jalr	1170(ra) # 8000651a <release>
    kfree((char*)pi);
    80004090:	8526                	mv	a0,s1
    80004092:	ffffc097          	auipc	ra,0xffffc
    80004096:	f8a080e7          	jalr	-118(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000409a:	60e2                	ld	ra,24(sp)
    8000409c:	6442                	ld	s0,16(sp)
    8000409e:	64a2                	ld	s1,8(sp)
    800040a0:	6902                	ld	s2,0(sp)
    800040a2:	6105                	addi	sp,sp,32
    800040a4:	8082                	ret
    pi->readopen = 0;
    800040a6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040aa:	21c48513          	addi	a0,s1,540
    800040ae:	ffffe097          	auipc	ra,0xffffe
    800040b2:	86c080e7          	jalr	-1940(ra) # 8000191a <wakeup>
    800040b6:	b7e9                	j	80004080 <pipeclose+0x2c>
    release(&pi->lock);
    800040b8:	8526                	mv	a0,s1
    800040ba:	00002097          	auipc	ra,0x2
    800040be:	460080e7          	jalr	1120(ra) # 8000651a <release>
}
    800040c2:	bfe1                	j	8000409a <pipeclose+0x46>

00000000800040c4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040c4:	711d                	addi	sp,sp,-96
    800040c6:	ec86                	sd	ra,88(sp)
    800040c8:	e8a2                	sd	s0,80(sp)
    800040ca:	e4a6                	sd	s1,72(sp)
    800040cc:	e0ca                	sd	s2,64(sp)
    800040ce:	fc4e                	sd	s3,56(sp)
    800040d0:	f852                	sd	s4,48(sp)
    800040d2:	f456                	sd	s5,40(sp)
    800040d4:	1080                	addi	s0,sp,96
    800040d6:	84aa                	mv	s1,a0
    800040d8:	8aae                	mv	s5,a1
    800040da:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040dc:	ffffd097          	auipc	ra,0xffffd
    800040e0:	f38080e7          	jalr	-200(ra) # 80001014 <myproc>
    800040e4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040e6:	8526                	mv	a0,s1
    800040e8:	00002097          	auipc	ra,0x2
    800040ec:	37e080e7          	jalr	894(ra) # 80006466 <acquire>
  while(i < n){
    800040f0:	0d405563          	blez	s4,800041ba <pipewrite+0xf6>
    800040f4:	f05a                	sd	s6,32(sp)
    800040f6:	ec5e                	sd	s7,24(sp)
    800040f8:	e862                	sd	s8,16(sp)
  int i = 0;
    800040fa:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040fc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040fe:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004102:	21c48b93          	addi	s7,s1,540
    80004106:	a089                	j	80004148 <pipewrite+0x84>
      release(&pi->lock);
    80004108:	8526                	mv	a0,s1
    8000410a:	00002097          	auipc	ra,0x2
    8000410e:	410080e7          	jalr	1040(ra) # 8000651a <release>
      return -1;
    80004112:	597d                	li	s2,-1
    80004114:	7b02                	ld	s6,32(sp)
    80004116:	6be2                	ld	s7,24(sp)
    80004118:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000411a:	854a                	mv	a0,s2
    8000411c:	60e6                	ld	ra,88(sp)
    8000411e:	6446                	ld	s0,80(sp)
    80004120:	64a6                	ld	s1,72(sp)
    80004122:	6906                	ld	s2,64(sp)
    80004124:	79e2                	ld	s3,56(sp)
    80004126:	7a42                	ld	s4,48(sp)
    80004128:	7aa2                	ld	s5,40(sp)
    8000412a:	6125                	addi	sp,sp,96
    8000412c:	8082                	ret
      wakeup(&pi->nread);
    8000412e:	8562                	mv	a0,s8
    80004130:	ffffd097          	auipc	ra,0xffffd
    80004134:	7ea080e7          	jalr	2026(ra) # 8000191a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004138:	85a6                	mv	a1,s1
    8000413a:	855e                	mv	a0,s7
    8000413c:	ffffd097          	auipc	ra,0xffffd
    80004140:	652080e7          	jalr	1618(ra) # 8000178e <sleep>
  while(i < n){
    80004144:	05495c63          	bge	s2,s4,8000419c <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80004148:	2204a783          	lw	a5,544(s1)
    8000414c:	dfd5                	beqz	a5,80004108 <pipewrite+0x44>
    8000414e:	0289a783          	lw	a5,40(s3)
    80004152:	fbdd                	bnez	a5,80004108 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004154:	2184a783          	lw	a5,536(s1)
    80004158:	21c4a703          	lw	a4,540(s1)
    8000415c:	2007879b          	addiw	a5,a5,512
    80004160:	fcf707e3          	beq	a4,a5,8000412e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004164:	4685                	li	a3,1
    80004166:	01590633          	add	a2,s2,s5
    8000416a:	faf40593          	addi	a1,s0,-81
    8000416e:	0609b503          	ld	a0,96(s3)
    80004172:	ffffd097          	auipc	ra,0xffffd
    80004176:	a32080e7          	jalr	-1486(ra) # 80000ba4 <copyin>
    8000417a:	05650263          	beq	a0,s6,800041be <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000417e:	21c4a783          	lw	a5,540(s1)
    80004182:	0017871b          	addiw	a4,a5,1
    80004186:	20e4ae23          	sw	a4,540(s1)
    8000418a:	1ff7f793          	andi	a5,a5,511
    8000418e:	97a6                	add	a5,a5,s1
    80004190:	faf44703          	lbu	a4,-81(s0)
    80004194:	00e78c23          	sb	a4,24(a5)
      i++;
    80004198:	2905                	addiw	s2,s2,1
    8000419a:	b76d                	j	80004144 <pipewrite+0x80>
    8000419c:	7b02                	ld	s6,32(sp)
    8000419e:	6be2                	ld	s7,24(sp)
    800041a0:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800041a2:	21848513          	addi	a0,s1,536
    800041a6:	ffffd097          	auipc	ra,0xffffd
    800041aa:	774080e7          	jalr	1908(ra) # 8000191a <wakeup>
  release(&pi->lock);
    800041ae:	8526                	mv	a0,s1
    800041b0:	00002097          	auipc	ra,0x2
    800041b4:	36a080e7          	jalr	874(ra) # 8000651a <release>
  return i;
    800041b8:	b78d                	j	8000411a <pipewrite+0x56>
  int i = 0;
    800041ba:	4901                	li	s2,0
    800041bc:	b7dd                	j	800041a2 <pipewrite+0xde>
    800041be:	7b02                	ld	s6,32(sp)
    800041c0:	6be2                	ld	s7,24(sp)
    800041c2:	6c42                	ld	s8,16(sp)
    800041c4:	bff9                	j	800041a2 <pipewrite+0xde>

00000000800041c6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041c6:	715d                	addi	sp,sp,-80
    800041c8:	e486                	sd	ra,72(sp)
    800041ca:	e0a2                	sd	s0,64(sp)
    800041cc:	fc26                	sd	s1,56(sp)
    800041ce:	f84a                	sd	s2,48(sp)
    800041d0:	f44e                	sd	s3,40(sp)
    800041d2:	f052                	sd	s4,32(sp)
    800041d4:	ec56                	sd	s5,24(sp)
    800041d6:	0880                	addi	s0,sp,80
    800041d8:	84aa                	mv	s1,a0
    800041da:	892e                	mv	s2,a1
    800041dc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041de:	ffffd097          	auipc	ra,0xffffd
    800041e2:	e36080e7          	jalr	-458(ra) # 80001014 <myproc>
    800041e6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041e8:	8526                	mv	a0,s1
    800041ea:	00002097          	auipc	ra,0x2
    800041ee:	27c080e7          	jalr	636(ra) # 80006466 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041f2:	2184a703          	lw	a4,536(s1)
    800041f6:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041fa:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041fe:	02f71663          	bne	a4,a5,8000422a <piperead+0x64>
    80004202:	2244a783          	lw	a5,548(s1)
    80004206:	cb9d                	beqz	a5,8000423c <piperead+0x76>
    if(pr->killed){
    80004208:	028a2783          	lw	a5,40(s4)
    8000420c:	e38d                	bnez	a5,8000422e <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000420e:	85a6                	mv	a1,s1
    80004210:	854e                	mv	a0,s3
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	57c080e7          	jalr	1404(ra) # 8000178e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000421a:	2184a703          	lw	a4,536(s1)
    8000421e:	21c4a783          	lw	a5,540(s1)
    80004222:	fef700e3          	beq	a4,a5,80004202 <piperead+0x3c>
    80004226:	e85a                	sd	s6,16(sp)
    80004228:	a819                	j	8000423e <piperead+0x78>
    8000422a:	e85a                	sd	s6,16(sp)
    8000422c:	a809                	j	8000423e <piperead+0x78>
      release(&pi->lock);
    8000422e:	8526                	mv	a0,s1
    80004230:	00002097          	auipc	ra,0x2
    80004234:	2ea080e7          	jalr	746(ra) # 8000651a <release>
      return -1;
    80004238:	59fd                	li	s3,-1
    8000423a:	a0a5                	j	800042a2 <piperead+0xdc>
    8000423c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000423e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004240:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004242:	05505463          	blez	s5,8000428a <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004246:	2184a783          	lw	a5,536(s1)
    8000424a:	21c4a703          	lw	a4,540(s1)
    8000424e:	02f70e63          	beq	a4,a5,8000428a <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004252:	0017871b          	addiw	a4,a5,1
    80004256:	20e4ac23          	sw	a4,536(s1)
    8000425a:	1ff7f793          	andi	a5,a5,511
    8000425e:	97a6                	add	a5,a5,s1
    80004260:	0187c783          	lbu	a5,24(a5)
    80004264:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004268:	4685                	li	a3,1
    8000426a:	fbf40613          	addi	a2,s0,-65
    8000426e:	85ca                	mv	a1,s2
    80004270:	060a3503          	ld	a0,96(s4)
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	8a4080e7          	jalr	-1884(ra) # 80000b18 <copyout>
    8000427c:	01650763          	beq	a0,s6,8000428a <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004280:	2985                	addiw	s3,s3,1
    80004282:	0905                	addi	s2,s2,1
    80004284:	fd3a91e3          	bne	s5,s3,80004246 <piperead+0x80>
    80004288:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000428a:	21c48513          	addi	a0,s1,540
    8000428e:	ffffd097          	auipc	ra,0xffffd
    80004292:	68c080e7          	jalr	1676(ra) # 8000191a <wakeup>
  release(&pi->lock);
    80004296:	8526                	mv	a0,s1
    80004298:	00002097          	auipc	ra,0x2
    8000429c:	282080e7          	jalr	642(ra) # 8000651a <release>
    800042a0:	6b42                	ld	s6,16(sp)
  return i;
}
    800042a2:	854e                	mv	a0,s3
    800042a4:	60a6                	ld	ra,72(sp)
    800042a6:	6406                	ld	s0,64(sp)
    800042a8:	74e2                	ld	s1,56(sp)
    800042aa:	7942                	ld	s2,48(sp)
    800042ac:	79a2                	ld	s3,40(sp)
    800042ae:	7a02                	ld	s4,32(sp)
    800042b0:	6ae2                	ld	s5,24(sp)
    800042b2:	6161                	addi	sp,sp,80
    800042b4:	8082                	ret

00000000800042b6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042b6:	df010113          	addi	sp,sp,-528
    800042ba:	20113423          	sd	ra,520(sp)
    800042be:	20813023          	sd	s0,512(sp)
    800042c2:	ffa6                	sd	s1,504(sp)
    800042c4:	fbca                	sd	s2,496(sp)
    800042c6:	0c00                	addi	s0,sp,528
    800042c8:	892a                	mv	s2,a0
    800042ca:	dea43c23          	sd	a0,-520(s0)
    800042ce:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042d2:	ffffd097          	auipc	ra,0xffffd
    800042d6:	d42080e7          	jalr	-702(ra) # 80001014 <myproc>
    800042da:	84aa                	mv	s1,a0

  begin_op();
    800042dc:	fffff097          	auipc	ra,0xfffff
    800042e0:	460080e7          	jalr	1120(ra) # 8000373c <begin_op>

  if((ip = namei(path)) == 0){
    800042e4:	854a                	mv	a0,s2
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	256080e7          	jalr	598(ra) # 8000353c <namei>
    800042ee:	c135                	beqz	a0,80004352 <exec+0x9c>
    800042f0:	f3d2                	sd	s4,480(sp)
    800042f2:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042f4:	fffff097          	auipc	ra,0xfffff
    800042f8:	a76080e7          	jalr	-1418(ra) # 80002d6a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042fc:	04000713          	li	a4,64
    80004300:	4681                	li	a3,0
    80004302:	e5040613          	addi	a2,s0,-432
    80004306:	4581                	li	a1,0
    80004308:	8552                	mv	a0,s4
    8000430a:	fffff097          	auipc	ra,0xfffff
    8000430e:	d18080e7          	jalr	-744(ra) # 80003022 <readi>
    80004312:	04000793          	li	a5,64
    80004316:	00f51a63          	bne	a0,a5,8000432a <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000431a:	e5042703          	lw	a4,-432(s0)
    8000431e:	464c47b7          	lui	a5,0x464c4
    80004322:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004326:	02f70c63          	beq	a4,a5,8000435e <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000432a:	8552                	mv	a0,s4
    8000432c:	fffff097          	auipc	ra,0xfffff
    80004330:	ca4080e7          	jalr	-860(ra) # 80002fd0 <iunlockput>
    end_op();
    80004334:	fffff097          	auipc	ra,0xfffff
    80004338:	482080e7          	jalr	1154(ra) # 800037b6 <end_op>
  }
  return -1;
    8000433c:	557d                	li	a0,-1
    8000433e:	7a1e                	ld	s4,480(sp)
}
    80004340:	20813083          	ld	ra,520(sp)
    80004344:	20013403          	ld	s0,512(sp)
    80004348:	74fe                	ld	s1,504(sp)
    8000434a:	795e                	ld	s2,496(sp)
    8000434c:	21010113          	addi	sp,sp,528
    80004350:	8082                	ret
    end_op();
    80004352:	fffff097          	auipc	ra,0xfffff
    80004356:	464080e7          	jalr	1124(ra) # 800037b6 <end_op>
    return -1;
    8000435a:	557d                	li	a0,-1
    8000435c:	b7d5                	j	80004340 <exec+0x8a>
    8000435e:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004360:	8526                	mv	a0,s1
    80004362:	ffffd097          	auipc	ra,0xffffd
    80004366:	d76080e7          	jalr	-650(ra) # 800010d8 <proc_pagetable>
    8000436a:	8b2a                	mv	s6,a0
    8000436c:	32050163          	beqz	a0,8000468e <exec+0x3d8>
    80004370:	f7ce                	sd	s3,488(sp)
    80004372:	efd6                	sd	s5,472(sp)
    80004374:	e7de                	sd	s7,456(sp)
    80004376:	e3e2                	sd	s8,448(sp)
    80004378:	ff66                	sd	s9,440(sp)
    8000437a:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000437c:	e7042d03          	lw	s10,-400(s0)
    80004380:	e8845783          	lhu	a5,-376(s0)
    80004384:	14078563          	beqz	a5,800044ce <exec+0x218>
    80004388:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000438a:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000438c:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    8000438e:	6c85                	lui	s9,0x1
    80004390:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004394:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004398:	6a85                	lui	s5,0x1
    8000439a:	a0b5                	j	80004406 <exec+0x150>
      panic("loadseg: address should exist");
    8000439c:	00004517          	auipc	a0,0x4
    800043a0:	21c50513          	addi	a0,a0,540 # 800085b8 <etext+0x5b8>
    800043a4:	00002097          	auipc	ra,0x2
    800043a8:	b48080e7          	jalr	-1208(ra) # 80005eec <panic>
    if(sz - i < PGSIZE)
    800043ac:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043ae:	8726                	mv	a4,s1
    800043b0:	012c06bb          	addw	a3,s8,s2
    800043b4:	4581                	li	a1,0
    800043b6:	8552                	mv	a0,s4
    800043b8:	fffff097          	auipc	ra,0xfffff
    800043bc:	c6a080e7          	jalr	-918(ra) # 80003022 <readi>
    800043c0:	2501                	sext.w	a0,a0
    800043c2:	28a49a63          	bne	s1,a0,80004656 <exec+0x3a0>
  for(i = 0; i < sz; i += PGSIZE){
    800043c6:	012a893b          	addw	s2,s5,s2
    800043ca:	03397563          	bgeu	s2,s3,800043f4 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800043ce:	02091593          	slli	a1,s2,0x20
    800043d2:	9181                	srli	a1,a1,0x20
    800043d4:	95de                	add	a1,a1,s7
    800043d6:	855a                	mv	a0,s6
    800043d8:	ffffc097          	auipc	ra,0xffffc
    800043dc:	120080e7          	jalr	288(ra) # 800004f8 <walkaddr>
    800043e0:	862a                	mv	a2,a0
    if(pa == 0)
    800043e2:	dd4d                	beqz	a0,8000439c <exec+0xe6>
    if(sz - i < PGSIZE)
    800043e4:	412984bb          	subw	s1,s3,s2
    800043e8:	0004879b          	sext.w	a5,s1
    800043ec:	fcfcf0e3          	bgeu	s9,a5,800043ac <exec+0xf6>
    800043f0:	84d6                	mv	s1,s5
    800043f2:	bf6d                	j	800043ac <exec+0xf6>
    sz = sz1;
    800043f4:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043f8:	2d85                	addiw	s11,s11,1
    800043fa:	038d0d1b          	addiw	s10,s10,56
    800043fe:	e8845783          	lhu	a5,-376(s0)
    80004402:	06fddf63          	bge	s11,a5,80004480 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004406:	2d01                	sext.w	s10,s10
    80004408:	03800713          	li	a4,56
    8000440c:	86ea                	mv	a3,s10
    8000440e:	e1840613          	addi	a2,s0,-488
    80004412:	4581                	li	a1,0
    80004414:	8552                	mv	a0,s4
    80004416:	fffff097          	auipc	ra,0xfffff
    8000441a:	c0c080e7          	jalr	-1012(ra) # 80003022 <readi>
    8000441e:	03800793          	li	a5,56
    80004422:	20f51463          	bne	a0,a5,8000462a <exec+0x374>
    if(ph.type != ELF_PROG_LOAD)
    80004426:	e1842783          	lw	a5,-488(s0)
    8000442a:	4705                	li	a4,1
    8000442c:	fce796e3          	bne	a5,a4,800043f8 <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004430:	e4043603          	ld	a2,-448(s0)
    80004434:	e3843783          	ld	a5,-456(s0)
    80004438:	1ef66d63          	bltu	a2,a5,80004632 <exec+0x37c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000443c:	e2843783          	ld	a5,-472(s0)
    80004440:	963e                	add	a2,a2,a5
    80004442:	1ef66c63          	bltu	a2,a5,8000463a <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004446:	85a6                	mv	a1,s1
    80004448:	855a                	mv	a0,s6
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	472080e7          	jalr	1138(ra) # 800008bc <uvmalloc>
    80004452:	e0a43423          	sd	a0,-504(s0)
    80004456:	1e050663          	beqz	a0,80004642 <exec+0x38c>
    if((ph.vaddr % PGSIZE) != 0)
    8000445a:	e2843b83          	ld	s7,-472(s0)
    8000445e:	df043783          	ld	a5,-528(s0)
    80004462:	00fbf7b3          	and	a5,s7,a5
    80004466:	1e079663          	bnez	a5,80004652 <exec+0x39c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000446a:	e2042c03          	lw	s8,-480(s0)
    8000446e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004472:	00098463          	beqz	s3,8000447a <exec+0x1c4>
    80004476:	4901                	li	s2,0
    80004478:	bf99                	j	800043ce <exec+0x118>
    sz = sz1;
    8000447a:	e0843483          	ld	s1,-504(s0)
    8000447e:	bfad                	j	800043f8 <exec+0x142>
    80004480:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004482:	8552                	mv	a0,s4
    80004484:	fffff097          	auipc	ra,0xfffff
    80004488:	b4c080e7          	jalr	-1204(ra) # 80002fd0 <iunlockput>
  end_op();
    8000448c:	fffff097          	auipc	ra,0xfffff
    80004490:	32a080e7          	jalr	810(ra) # 800037b6 <end_op>
  p = myproc();
    80004494:	ffffd097          	auipc	ra,0xffffd
    80004498:	b80080e7          	jalr	-1152(ra) # 80001014 <myproc>
    8000449c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000449e:	05853c83          	ld	s9,88(a0)
  sz = PGROUNDUP(sz);
    800044a2:	6985                	lui	s3,0x1
    800044a4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800044a6:	99a6                	add	s3,s3,s1
    800044a8:	77fd                	lui	a5,0xfffff
    800044aa:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800044ae:	6609                	lui	a2,0x2
    800044b0:	964e                	add	a2,a2,s3
    800044b2:	85ce                	mv	a1,s3
    800044b4:	855a                	mv	a0,s6
    800044b6:	ffffc097          	auipc	ra,0xffffc
    800044ba:	406080e7          	jalr	1030(ra) # 800008bc <uvmalloc>
    800044be:	892a                	mv	s2,a0
    800044c0:	e0a43423          	sd	a0,-504(s0)
    800044c4:	e519                	bnez	a0,800044d2 <exec+0x21c>
  if(pagetable)
    800044c6:	e1343423          	sd	s3,-504(s0)
    800044ca:	4a01                	li	s4,0
    800044cc:	a271                	j	80004658 <exec+0x3a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044ce:	4481                	li	s1,0
    800044d0:	bf4d                	j	80004482 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800044d2:	75f9                	lui	a1,0xffffe
    800044d4:	95aa                	add	a1,a1,a0
    800044d6:	855a                	mv	a0,s6
    800044d8:	ffffc097          	auipc	ra,0xffffc
    800044dc:	60e080e7          	jalr	1550(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    800044e0:	7bfd                	lui	s7,0xfffff
    800044e2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800044e4:	e0043783          	ld	a5,-512(s0)
    800044e8:	6388                	ld	a0,0(a5)
    800044ea:	c52d                	beqz	a0,80004554 <exec+0x29e>
    800044ec:	e9040993          	addi	s3,s0,-368
    800044f0:	f9040c13          	addi	s8,s0,-112
    800044f4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800044f6:	ffffc097          	auipc	ra,0xffffc
    800044fa:	df8080e7          	jalr	-520(ra) # 800002ee <strlen>
    800044fe:	0015079b          	addiw	a5,a0,1
    80004502:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004506:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000450a:	15796063          	bltu	s2,s7,8000464a <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000450e:	e0043d03          	ld	s10,-512(s0)
    80004512:	000d3a03          	ld	s4,0(s10)
    80004516:	8552                	mv	a0,s4
    80004518:	ffffc097          	auipc	ra,0xffffc
    8000451c:	dd6080e7          	jalr	-554(ra) # 800002ee <strlen>
    80004520:	0015069b          	addiw	a3,a0,1
    80004524:	8652                	mv	a2,s4
    80004526:	85ca                	mv	a1,s2
    80004528:	855a                	mv	a0,s6
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	5ee080e7          	jalr	1518(ra) # 80000b18 <copyout>
    80004532:	10054e63          	bltz	a0,8000464e <exec+0x398>
    ustack[argc] = sp;
    80004536:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000453a:	0485                	addi	s1,s1,1
    8000453c:	008d0793          	addi	a5,s10,8
    80004540:	e0f43023          	sd	a5,-512(s0)
    80004544:	008d3503          	ld	a0,8(s10)
    80004548:	c909                	beqz	a0,8000455a <exec+0x2a4>
    if(argc >= MAXARG)
    8000454a:	09a1                	addi	s3,s3,8
    8000454c:	fb8995e3          	bne	s3,s8,800044f6 <exec+0x240>
  ip = 0;
    80004550:	4a01                	li	s4,0
    80004552:	a219                	j	80004658 <exec+0x3a2>
  sp = sz;
    80004554:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004558:	4481                	li	s1,0
  ustack[argc] = 0;
    8000455a:	00349793          	slli	a5,s1,0x3
    8000455e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    80004562:	97a2                	add	a5,a5,s0
    80004564:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004568:	00148693          	addi	a3,s1,1
    8000456c:	068e                	slli	a3,a3,0x3
    8000456e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004572:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004576:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000457a:	f57966e3          	bltu	s2,s7,800044c6 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000457e:	e9040613          	addi	a2,s0,-368
    80004582:	85ca                	mv	a1,s2
    80004584:	855a                	mv	a0,s6
    80004586:	ffffc097          	auipc	ra,0xffffc
    8000458a:	592080e7          	jalr	1426(ra) # 80000b18 <copyout>
    8000458e:	10054263          	bltz	a0,80004692 <exec+0x3dc>
  p->trapframe->a1 = sp;
    80004592:	068ab783          	ld	a5,104(s5) # 1068 <_entry-0x7fffef98>
    80004596:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000459a:	df843783          	ld	a5,-520(s0)
    8000459e:	0007c703          	lbu	a4,0(a5)
    800045a2:	cf11                	beqz	a4,800045be <exec+0x308>
    800045a4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045a6:	02f00693          	li	a3,47
    800045aa:	a039                	j	800045b8 <exec+0x302>
      last = s+1;
    800045ac:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800045b0:	0785                	addi	a5,a5,1
    800045b2:	fff7c703          	lbu	a4,-1(a5)
    800045b6:	c701                	beqz	a4,800045be <exec+0x308>
    if(*s == '/')
    800045b8:	fed71ce3          	bne	a4,a3,800045b0 <exec+0x2fa>
    800045bc:	bfc5                	j	800045ac <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    800045be:	4641                	li	a2,16
    800045c0:	df843583          	ld	a1,-520(s0)
    800045c4:	034a8513          	addi	a0,s5,52
    800045c8:	ffffc097          	auipc	ra,0xffffc
    800045cc:	cf4080e7          	jalr	-780(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    800045d0:	060ab503          	ld	a0,96(s5)
  p->pagetable = pagetable;
    800045d4:	076ab023          	sd	s6,96(s5)
  p->sz = sz;
    800045d8:	e0843783          	ld	a5,-504(s0)
    800045dc:	04fabc23          	sd	a5,88(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045e0:	068ab783          	ld	a5,104(s5)
    800045e4:	e6843703          	ld	a4,-408(s0)
    800045e8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045ea:	068ab783          	ld	a5,104(s5)
    800045ee:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045f2:	85e6                	mv	a1,s9
    800045f4:	ffffd097          	auipc	ra,0xffffd
    800045f8:	bda080e7          	jalr	-1062(ra) # 800011ce <proc_freepagetable>
  if (p->pid==1) 
    800045fc:	030aa703          	lw	a4,48(s5)
    80004600:	4785                	li	a5,1
    80004602:	00f70d63          	beq	a4,a5,8000461c <exec+0x366>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004606:	0004851b          	sext.w	a0,s1
    8000460a:	79be                	ld	s3,488(sp)
    8000460c:	7a1e                	ld	s4,480(sp)
    8000460e:	6afe                	ld	s5,472(sp)
    80004610:	6b5e                	ld	s6,464(sp)
    80004612:	6bbe                	ld	s7,456(sp)
    80004614:	6c1e                	ld	s8,448(sp)
    80004616:	7cfa                	ld	s9,440(sp)
    80004618:	7d5a                	ld	s10,432(sp)
    8000461a:	b31d                	j	80004340 <exec+0x8a>
    vmprint(p->pagetable);//输出第一个进程的页表
    8000461c:	060ab503          	ld	a0,96(s5)
    80004620:	ffffc097          	auipc	ra,0xffffc
    80004624:	776080e7          	jalr	1910(ra) # 80000d96 <vmprint>
    80004628:	bff9                	j	80004606 <exec+0x350>
    8000462a:	e0943423          	sd	s1,-504(s0)
    8000462e:	7dba                	ld	s11,424(sp)
    80004630:	a025                	j	80004658 <exec+0x3a2>
    80004632:	e0943423          	sd	s1,-504(s0)
    80004636:	7dba                	ld	s11,424(sp)
    80004638:	a005                	j	80004658 <exec+0x3a2>
    8000463a:	e0943423          	sd	s1,-504(s0)
    8000463e:	7dba                	ld	s11,424(sp)
    80004640:	a821                	j	80004658 <exec+0x3a2>
    80004642:	e0943423          	sd	s1,-504(s0)
    80004646:	7dba                	ld	s11,424(sp)
    80004648:	a801                	j	80004658 <exec+0x3a2>
  ip = 0;
    8000464a:	4a01                	li	s4,0
    8000464c:	a031                	j	80004658 <exec+0x3a2>
    8000464e:	4a01                	li	s4,0
  if(pagetable)
    80004650:	a021                	j	80004658 <exec+0x3a2>
    80004652:	7dba                	ld	s11,424(sp)
    80004654:	a011                	j	80004658 <exec+0x3a2>
    80004656:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004658:	e0843583          	ld	a1,-504(s0)
    8000465c:	855a                	mv	a0,s6
    8000465e:	ffffd097          	auipc	ra,0xffffd
    80004662:	b70080e7          	jalr	-1168(ra) # 800011ce <proc_freepagetable>
  return -1;
    80004666:	557d                	li	a0,-1
  if(ip){
    80004668:	000a1b63          	bnez	s4,8000467e <exec+0x3c8>
    8000466c:	79be                	ld	s3,488(sp)
    8000466e:	7a1e                	ld	s4,480(sp)
    80004670:	6afe                	ld	s5,472(sp)
    80004672:	6b5e                	ld	s6,464(sp)
    80004674:	6bbe                	ld	s7,456(sp)
    80004676:	6c1e                	ld	s8,448(sp)
    80004678:	7cfa                	ld	s9,440(sp)
    8000467a:	7d5a                	ld	s10,432(sp)
    8000467c:	b1d1                	j	80004340 <exec+0x8a>
    8000467e:	79be                	ld	s3,488(sp)
    80004680:	6afe                	ld	s5,472(sp)
    80004682:	6b5e                	ld	s6,464(sp)
    80004684:	6bbe                	ld	s7,456(sp)
    80004686:	6c1e                	ld	s8,448(sp)
    80004688:	7cfa                	ld	s9,440(sp)
    8000468a:	7d5a                	ld	s10,432(sp)
    8000468c:	b979                	j	8000432a <exec+0x74>
    8000468e:	6b5e                	ld	s6,464(sp)
    80004690:	b969                	j	8000432a <exec+0x74>
  sz = sz1;
    80004692:	e0843983          	ld	s3,-504(s0)
    80004696:	bd05                	j	800044c6 <exec+0x210>

0000000080004698 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004698:	7179                	addi	sp,sp,-48
    8000469a:	f406                	sd	ra,40(sp)
    8000469c:	f022                	sd	s0,32(sp)
    8000469e:	ec26                	sd	s1,24(sp)
    800046a0:	e84a                	sd	s2,16(sp)
    800046a2:	1800                	addi	s0,sp,48
    800046a4:	892e                	mv	s2,a1
    800046a6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800046a8:	fdc40593          	addi	a1,s0,-36
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	adc080e7          	jalr	-1316(ra) # 80002188 <argint>
    800046b4:	04054063          	bltz	a0,800046f4 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046b8:	fdc42703          	lw	a4,-36(s0)
    800046bc:	47bd                	li	a5,15
    800046be:	02e7ed63          	bltu	a5,a4,800046f8 <argfd+0x60>
    800046c2:	ffffd097          	auipc	ra,0xffffd
    800046c6:	952080e7          	jalr	-1710(ra) # 80001014 <myproc>
    800046ca:	fdc42703          	lw	a4,-36(s0)
    800046ce:	01c70793          	addi	a5,a4,28
    800046d2:	078e                	slli	a5,a5,0x3
    800046d4:	953e                	add	a0,a0,a5
    800046d6:	611c                	ld	a5,0(a0)
    800046d8:	c395                	beqz	a5,800046fc <argfd+0x64>
    return -1;
  if(pfd)
    800046da:	00090463          	beqz	s2,800046e2 <argfd+0x4a>
    *pfd = fd;
    800046de:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046e2:	4501                	li	a0,0
  if(pf)
    800046e4:	c091                	beqz	s1,800046e8 <argfd+0x50>
    *pf = f;
    800046e6:	e09c                	sd	a5,0(s1)
}
    800046e8:	70a2                	ld	ra,40(sp)
    800046ea:	7402                	ld	s0,32(sp)
    800046ec:	64e2                	ld	s1,24(sp)
    800046ee:	6942                	ld	s2,16(sp)
    800046f0:	6145                	addi	sp,sp,48
    800046f2:	8082                	ret
    return -1;
    800046f4:	557d                	li	a0,-1
    800046f6:	bfcd                	j	800046e8 <argfd+0x50>
    return -1;
    800046f8:	557d                	li	a0,-1
    800046fa:	b7fd                	j	800046e8 <argfd+0x50>
    800046fc:	557d                	li	a0,-1
    800046fe:	b7ed                	j	800046e8 <argfd+0x50>

0000000080004700 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004700:	1101                	addi	sp,sp,-32
    80004702:	ec06                	sd	ra,24(sp)
    80004704:	e822                	sd	s0,16(sp)
    80004706:	e426                	sd	s1,8(sp)
    80004708:	1000                	addi	s0,sp,32
    8000470a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000470c:	ffffd097          	auipc	ra,0xffffd
    80004710:	908080e7          	jalr	-1784(ra) # 80001014 <myproc>
    80004714:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004716:	0e050793          	addi	a5,a0,224
    8000471a:	4501                	li	a0,0
    8000471c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000471e:	6398                	ld	a4,0(a5)
    80004720:	cb19                	beqz	a4,80004736 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004722:	2505                	addiw	a0,a0,1
    80004724:	07a1                	addi	a5,a5,8
    80004726:	fed51ce3          	bne	a0,a3,8000471e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000472a:	557d                	li	a0,-1
}
    8000472c:	60e2                	ld	ra,24(sp)
    8000472e:	6442                	ld	s0,16(sp)
    80004730:	64a2                	ld	s1,8(sp)
    80004732:	6105                	addi	sp,sp,32
    80004734:	8082                	ret
      p->ofile[fd] = f;
    80004736:	01c50793          	addi	a5,a0,28
    8000473a:	078e                	slli	a5,a5,0x3
    8000473c:	963e                	add	a2,a2,a5
    8000473e:	e204                	sd	s1,0(a2)
      return fd;
    80004740:	b7f5                	j	8000472c <fdalloc+0x2c>

0000000080004742 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004742:	715d                	addi	sp,sp,-80
    80004744:	e486                	sd	ra,72(sp)
    80004746:	e0a2                	sd	s0,64(sp)
    80004748:	fc26                	sd	s1,56(sp)
    8000474a:	f84a                	sd	s2,48(sp)
    8000474c:	f44e                	sd	s3,40(sp)
    8000474e:	f052                	sd	s4,32(sp)
    80004750:	ec56                	sd	s5,24(sp)
    80004752:	0880                	addi	s0,sp,80
    80004754:	8aae                	mv	s5,a1
    80004756:	8a32                	mv	s4,a2
    80004758:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000475a:	fb040593          	addi	a1,s0,-80
    8000475e:	fffff097          	auipc	ra,0xfffff
    80004762:	dfc080e7          	jalr	-516(ra) # 8000355a <nameiparent>
    80004766:	892a                	mv	s2,a0
    80004768:	12050c63          	beqz	a0,800048a0 <create+0x15e>
    return 0;

  ilock(dp);
    8000476c:	ffffe097          	auipc	ra,0xffffe
    80004770:	5fe080e7          	jalr	1534(ra) # 80002d6a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004774:	4601                	li	a2,0
    80004776:	fb040593          	addi	a1,s0,-80
    8000477a:	854a                	mv	a0,s2
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	aee080e7          	jalr	-1298(ra) # 8000326a <dirlookup>
    80004784:	84aa                	mv	s1,a0
    80004786:	c539                	beqz	a0,800047d4 <create+0x92>
    iunlockput(dp);
    80004788:	854a                	mv	a0,s2
    8000478a:	fffff097          	auipc	ra,0xfffff
    8000478e:	846080e7          	jalr	-1978(ra) # 80002fd0 <iunlockput>
    ilock(ip);
    80004792:	8526                	mv	a0,s1
    80004794:	ffffe097          	auipc	ra,0xffffe
    80004798:	5d6080e7          	jalr	1494(ra) # 80002d6a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000479c:	4789                	li	a5,2
    8000479e:	02fa9463          	bne	s5,a5,800047c6 <create+0x84>
    800047a2:	0444d783          	lhu	a5,68(s1)
    800047a6:	37f9                	addiw	a5,a5,-2
    800047a8:	17c2                	slli	a5,a5,0x30
    800047aa:	93c1                	srli	a5,a5,0x30
    800047ac:	4705                	li	a4,1
    800047ae:	00f76c63          	bltu	a4,a5,800047c6 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800047b2:	8526                	mv	a0,s1
    800047b4:	60a6                	ld	ra,72(sp)
    800047b6:	6406                	ld	s0,64(sp)
    800047b8:	74e2                	ld	s1,56(sp)
    800047ba:	7942                	ld	s2,48(sp)
    800047bc:	79a2                	ld	s3,40(sp)
    800047be:	7a02                	ld	s4,32(sp)
    800047c0:	6ae2                	ld	s5,24(sp)
    800047c2:	6161                	addi	sp,sp,80
    800047c4:	8082                	ret
    iunlockput(ip);
    800047c6:	8526                	mv	a0,s1
    800047c8:	fffff097          	auipc	ra,0xfffff
    800047cc:	808080e7          	jalr	-2040(ra) # 80002fd0 <iunlockput>
    return 0;
    800047d0:	4481                	li	s1,0
    800047d2:	b7c5                	j	800047b2 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047d4:	85d6                	mv	a1,s5
    800047d6:	00092503          	lw	a0,0(s2)
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	3fc080e7          	jalr	1020(ra) # 80002bd6 <ialloc>
    800047e2:	84aa                	mv	s1,a0
    800047e4:	c139                	beqz	a0,8000482a <create+0xe8>
  ilock(ip);
    800047e6:	ffffe097          	auipc	ra,0xffffe
    800047ea:	584080e7          	jalr	1412(ra) # 80002d6a <ilock>
  ip->major = major;
    800047ee:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800047f2:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800047f6:	4985                	li	s3,1
    800047f8:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800047fc:	8526                	mv	a0,s1
    800047fe:	ffffe097          	auipc	ra,0xffffe
    80004802:	4a0080e7          	jalr	1184(ra) # 80002c9e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004806:	033a8a63          	beq	s5,s3,8000483a <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000480a:	40d0                	lw	a2,4(s1)
    8000480c:	fb040593          	addi	a1,s0,-80
    80004810:	854a                	mv	a0,s2
    80004812:	fffff097          	auipc	ra,0xfffff
    80004816:	c68080e7          	jalr	-920(ra) # 8000347a <dirlink>
    8000481a:	06054b63          	bltz	a0,80004890 <create+0x14e>
  iunlockput(dp);
    8000481e:	854a                	mv	a0,s2
    80004820:	ffffe097          	auipc	ra,0xffffe
    80004824:	7b0080e7          	jalr	1968(ra) # 80002fd0 <iunlockput>
  return ip;
    80004828:	b769                	j	800047b2 <create+0x70>
    panic("create: ialloc");
    8000482a:	00004517          	auipc	a0,0x4
    8000482e:	dae50513          	addi	a0,a0,-594 # 800085d8 <etext+0x5d8>
    80004832:	00001097          	auipc	ra,0x1
    80004836:	6ba080e7          	jalr	1722(ra) # 80005eec <panic>
    dp->nlink++;  // for ".."
    8000483a:	04a95783          	lhu	a5,74(s2)
    8000483e:	2785                	addiw	a5,a5,1
    80004840:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004844:	854a                	mv	a0,s2
    80004846:	ffffe097          	auipc	ra,0xffffe
    8000484a:	458080e7          	jalr	1112(ra) # 80002c9e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000484e:	40d0                	lw	a2,4(s1)
    80004850:	00004597          	auipc	a1,0x4
    80004854:	d9858593          	addi	a1,a1,-616 # 800085e8 <etext+0x5e8>
    80004858:	8526                	mv	a0,s1
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	c20080e7          	jalr	-992(ra) # 8000347a <dirlink>
    80004862:	00054f63          	bltz	a0,80004880 <create+0x13e>
    80004866:	00492603          	lw	a2,4(s2)
    8000486a:	00004597          	auipc	a1,0x4
    8000486e:	8ee58593          	addi	a1,a1,-1810 # 80008158 <etext+0x158>
    80004872:	8526                	mv	a0,s1
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	c06080e7          	jalr	-1018(ra) # 8000347a <dirlink>
    8000487c:	f80557e3          	bgez	a0,8000480a <create+0xc8>
      panic("create dots");
    80004880:	00004517          	auipc	a0,0x4
    80004884:	d7050513          	addi	a0,a0,-656 # 800085f0 <etext+0x5f0>
    80004888:	00001097          	auipc	ra,0x1
    8000488c:	664080e7          	jalr	1636(ra) # 80005eec <panic>
    panic("create: dirlink");
    80004890:	00004517          	auipc	a0,0x4
    80004894:	d7050513          	addi	a0,a0,-656 # 80008600 <etext+0x600>
    80004898:	00001097          	auipc	ra,0x1
    8000489c:	654080e7          	jalr	1620(ra) # 80005eec <panic>
    return 0;
    800048a0:	84aa                	mv	s1,a0
    800048a2:	bf01                	j	800047b2 <create+0x70>

00000000800048a4 <sys_dup>:
{
    800048a4:	7179                	addi	sp,sp,-48
    800048a6:	f406                	sd	ra,40(sp)
    800048a8:	f022                	sd	s0,32(sp)
    800048aa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048ac:	fd840613          	addi	a2,s0,-40
    800048b0:	4581                	li	a1,0
    800048b2:	4501                	li	a0,0
    800048b4:	00000097          	auipc	ra,0x0
    800048b8:	de4080e7          	jalr	-540(ra) # 80004698 <argfd>
    return -1;
    800048bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048be:	02054763          	bltz	a0,800048ec <sys_dup+0x48>
    800048c2:	ec26                	sd	s1,24(sp)
    800048c4:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800048c6:	fd843903          	ld	s2,-40(s0)
    800048ca:	854a                	mv	a0,s2
    800048cc:	00000097          	auipc	ra,0x0
    800048d0:	e34080e7          	jalr	-460(ra) # 80004700 <fdalloc>
    800048d4:	84aa                	mv	s1,a0
    return -1;
    800048d6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048d8:	00054f63          	bltz	a0,800048f6 <sys_dup+0x52>
  filedup(f);
    800048dc:	854a                	mv	a0,s2
    800048de:	fffff097          	auipc	ra,0xfffff
    800048e2:	2d6080e7          	jalr	726(ra) # 80003bb4 <filedup>
  return fd;
    800048e6:	87a6                	mv	a5,s1
    800048e8:	64e2                	ld	s1,24(sp)
    800048ea:	6942                	ld	s2,16(sp)
}
    800048ec:	853e                	mv	a0,a5
    800048ee:	70a2                	ld	ra,40(sp)
    800048f0:	7402                	ld	s0,32(sp)
    800048f2:	6145                	addi	sp,sp,48
    800048f4:	8082                	ret
    800048f6:	64e2                	ld	s1,24(sp)
    800048f8:	6942                	ld	s2,16(sp)
    800048fa:	bfcd                	j	800048ec <sys_dup+0x48>

00000000800048fc <sys_read>:
{
    800048fc:	7179                	addi	sp,sp,-48
    800048fe:	f406                	sd	ra,40(sp)
    80004900:	f022                	sd	s0,32(sp)
    80004902:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004904:	fe840613          	addi	a2,s0,-24
    80004908:	4581                	li	a1,0
    8000490a:	4501                	li	a0,0
    8000490c:	00000097          	auipc	ra,0x0
    80004910:	d8c080e7          	jalr	-628(ra) # 80004698 <argfd>
    return -1;
    80004914:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004916:	04054163          	bltz	a0,80004958 <sys_read+0x5c>
    8000491a:	fe440593          	addi	a1,s0,-28
    8000491e:	4509                	li	a0,2
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	868080e7          	jalr	-1944(ra) # 80002188 <argint>
    return -1;
    80004928:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000492a:	02054763          	bltz	a0,80004958 <sys_read+0x5c>
    8000492e:	fd840593          	addi	a1,s0,-40
    80004932:	4505                	li	a0,1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	876080e7          	jalr	-1930(ra) # 800021aa <argaddr>
    return -1;
    8000493c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000493e:	00054d63          	bltz	a0,80004958 <sys_read+0x5c>
  return fileread(f, p, n);
    80004942:	fe442603          	lw	a2,-28(s0)
    80004946:	fd843583          	ld	a1,-40(s0)
    8000494a:	fe843503          	ld	a0,-24(s0)
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	40c080e7          	jalr	1036(ra) # 80003d5a <fileread>
    80004956:	87aa                	mv	a5,a0
}
    80004958:	853e                	mv	a0,a5
    8000495a:	70a2                	ld	ra,40(sp)
    8000495c:	7402                	ld	s0,32(sp)
    8000495e:	6145                	addi	sp,sp,48
    80004960:	8082                	ret

0000000080004962 <sys_write>:
{
    80004962:	7179                	addi	sp,sp,-48
    80004964:	f406                	sd	ra,40(sp)
    80004966:	f022                	sd	s0,32(sp)
    80004968:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000496a:	fe840613          	addi	a2,s0,-24
    8000496e:	4581                	li	a1,0
    80004970:	4501                	li	a0,0
    80004972:	00000097          	auipc	ra,0x0
    80004976:	d26080e7          	jalr	-730(ra) # 80004698 <argfd>
    return -1;
    8000497a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000497c:	04054163          	bltz	a0,800049be <sys_write+0x5c>
    80004980:	fe440593          	addi	a1,s0,-28
    80004984:	4509                	li	a0,2
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	802080e7          	jalr	-2046(ra) # 80002188 <argint>
    return -1;
    8000498e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004990:	02054763          	bltz	a0,800049be <sys_write+0x5c>
    80004994:	fd840593          	addi	a1,s0,-40
    80004998:	4505                	li	a0,1
    8000499a:	ffffe097          	auipc	ra,0xffffe
    8000499e:	810080e7          	jalr	-2032(ra) # 800021aa <argaddr>
    return -1;
    800049a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049a4:	00054d63          	bltz	a0,800049be <sys_write+0x5c>
  return filewrite(f, p, n);
    800049a8:	fe442603          	lw	a2,-28(s0)
    800049ac:	fd843583          	ld	a1,-40(s0)
    800049b0:	fe843503          	ld	a0,-24(s0)
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	478080e7          	jalr	1144(ra) # 80003e2c <filewrite>
    800049bc:	87aa                	mv	a5,a0
}
    800049be:	853e                	mv	a0,a5
    800049c0:	70a2                	ld	ra,40(sp)
    800049c2:	7402                	ld	s0,32(sp)
    800049c4:	6145                	addi	sp,sp,48
    800049c6:	8082                	ret

00000000800049c8 <sys_close>:
{
    800049c8:	1101                	addi	sp,sp,-32
    800049ca:	ec06                	sd	ra,24(sp)
    800049cc:	e822                	sd	s0,16(sp)
    800049ce:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049d0:	fe040613          	addi	a2,s0,-32
    800049d4:	fec40593          	addi	a1,s0,-20
    800049d8:	4501                	li	a0,0
    800049da:	00000097          	auipc	ra,0x0
    800049de:	cbe080e7          	jalr	-834(ra) # 80004698 <argfd>
    return -1;
    800049e2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049e4:	02054463          	bltz	a0,80004a0c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049e8:	ffffc097          	auipc	ra,0xffffc
    800049ec:	62c080e7          	jalr	1580(ra) # 80001014 <myproc>
    800049f0:	fec42783          	lw	a5,-20(s0)
    800049f4:	07f1                	addi	a5,a5,28
    800049f6:	078e                	slli	a5,a5,0x3
    800049f8:	953e                	add	a0,a0,a5
    800049fa:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800049fe:	fe043503          	ld	a0,-32(s0)
    80004a02:	fffff097          	auipc	ra,0xfffff
    80004a06:	204080e7          	jalr	516(ra) # 80003c06 <fileclose>
  return 0;
    80004a0a:	4781                	li	a5,0
}
    80004a0c:	853e                	mv	a0,a5
    80004a0e:	60e2                	ld	ra,24(sp)
    80004a10:	6442                	ld	s0,16(sp)
    80004a12:	6105                	addi	sp,sp,32
    80004a14:	8082                	ret

0000000080004a16 <sys_fstat>:
{
    80004a16:	1101                	addi	sp,sp,-32
    80004a18:	ec06                	sd	ra,24(sp)
    80004a1a:	e822                	sd	s0,16(sp)
    80004a1c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a1e:	fe840613          	addi	a2,s0,-24
    80004a22:	4581                	li	a1,0
    80004a24:	4501                	li	a0,0
    80004a26:	00000097          	auipc	ra,0x0
    80004a2a:	c72080e7          	jalr	-910(ra) # 80004698 <argfd>
    return -1;
    80004a2e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a30:	02054563          	bltz	a0,80004a5a <sys_fstat+0x44>
    80004a34:	fe040593          	addi	a1,s0,-32
    80004a38:	4505                	li	a0,1
    80004a3a:	ffffd097          	auipc	ra,0xffffd
    80004a3e:	770080e7          	jalr	1904(ra) # 800021aa <argaddr>
    return -1;
    80004a42:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a44:	00054b63          	bltz	a0,80004a5a <sys_fstat+0x44>
  return filestat(f, st);
    80004a48:	fe043583          	ld	a1,-32(s0)
    80004a4c:	fe843503          	ld	a0,-24(s0)
    80004a50:	fffff097          	auipc	ra,0xfffff
    80004a54:	298080e7          	jalr	664(ra) # 80003ce8 <filestat>
    80004a58:	87aa                	mv	a5,a0
}
    80004a5a:	853e                	mv	a0,a5
    80004a5c:	60e2                	ld	ra,24(sp)
    80004a5e:	6442                	ld	s0,16(sp)
    80004a60:	6105                	addi	sp,sp,32
    80004a62:	8082                	ret

0000000080004a64 <sys_link>:
{
    80004a64:	7169                	addi	sp,sp,-304
    80004a66:	f606                	sd	ra,296(sp)
    80004a68:	f222                	sd	s0,288(sp)
    80004a6a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a6c:	08000613          	li	a2,128
    80004a70:	ed040593          	addi	a1,s0,-304
    80004a74:	4501                	li	a0,0
    80004a76:	ffffd097          	auipc	ra,0xffffd
    80004a7a:	756080e7          	jalr	1878(ra) # 800021cc <argstr>
    return -1;
    80004a7e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a80:	12054663          	bltz	a0,80004bac <sys_link+0x148>
    80004a84:	08000613          	li	a2,128
    80004a88:	f5040593          	addi	a1,s0,-176
    80004a8c:	4505                	li	a0,1
    80004a8e:	ffffd097          	auipc	ra,0xffffd
    80004a92:	73e080e7          	jalr	1854(ra) # 800021cc <argstr>
    return -1;
    80004a96:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a98:	10054a63          	bltz	a0,80004bac <sys_link+0x148>
    80004a9c:	ee26                	sd	s1,280(sp)
  begin_op();
    80004a9e:	fffff097          	auipc	ra,0xfffff
    80004aa2:	c9e080e7          	jalr	-866(ra) # 8000373c <begin_op>
  if((ip = namei(old)) == 0){
    80004aa6:	ed040513          	addi	a0,s0,-304
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	a92080e7          	jalr	-1390(ra) # 8000353c <namei>
    80004ab2:	84aa                	mv	s1,a0
    80004ab4:	c949                	beqz	a0,80004b46 <sys_link+0xe2>
  ilock(ip);
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	2b4080e7          	jalr	692(ra) # 80002d6a <ilock>
  if(ip->type == T_DIR){
    80004abe:	04449703          	lh	a4,68(s1)
    80004ac2:	4785                	li	a5,1
    80004ac4:	08f70863          	beq	a4,a5,80004b54 <sys_link+0xf0>
    80004ac8:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004aca:	04a4d783          	lhu	a5,74(s1)
    80004ace:	2785                	addiw	a5,a5,1
    80004ad0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	1c8080e7          	jalr	456(ra) # 80002c9e <iupdate>
  iunlock(ip);
    80004ade:	8526                	mv	a0,s1
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	350080e7          	jalr	848(ra) # 80002e30 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ae8:	fd040593          	addi	a1,s0,-48
    80004aec:	f5040513          	addi	a0,s0,-176
    80004af0:	fffff097          	auipc	ra,0xfffff
    80004af4:	a6a080e7          	jalr	-1430(ra) # 8000355a <nameiparent>
    80004af8:	892a                	mv	s2,a0
    80004afa:	cd35                	beqz	a0,80004b76 <sys_link+0x112>
  ilock(dp);
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	26e080e7          	jalr	622(ra) # 80002d6a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b04:	00092703          	lw	a4,0(s2)
    80004b08:	409c                	lw	a5,0(s1)
    80004b0a:	06f71163          	bne	a4,a5,80004b6c <sys_link+0x108>
    80004b0e:	40d0                	lw	a2,4(s1)
    80004b10:	fd040593          	addi	a1,s0,-48
    80004b14:	854a                	mv	a0,s2
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	964080e7          	jalr	-1692(ra) # 8000347a <dirlink>
    80004b1e:	04054763          	bltz	a0,80004b6c <sys_link+0x108>
  iunlockput(dp);
    80004b22:	854a                	mv	a0,s2
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	4ac080e7          	jalr	1196(ra) # 80002fd0 <iunlockput>
  iput(ip);
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	ffffe097          	auipc	ra,0xffffe
    80004b32:	3fa080e7          	jalr	1018(ra) # 80002f28 <iput>
  end_op();
    80004b36:	fffff097          	auipc	ra,0xfffff
    80004b3a:	c80080e7          	jalr	-896(ra) # 800037b6 <end_op>
  return 0;
    80004b3e:	4781                	li	a5,0
    80004b40:	64f2                	ld	s1,280(sp)
    80004b42:	6952                	ld	s2,272(sp)
    80004b44:	a0a5                	j	80004bac <sys_link+0x148>
    end_op();
    80004b46:	fffff097          	auipc	ra,0xfffff
    80004b4a:	c70080e7          	jalr	-912(ra) # 800037b6 <end_op>
    return -1;
    80004b4e:	57fd                	li	a5,-1
    80004b50:	64f2                	ld	s1,280(sp)
    80004b52:	a8a9                	j	80004bac <sys_link+0x148>
    iunlockput(ip);
    80004b54:	8526                	mv	a0,s1
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	47a080e7          	jalr	1146(ra) # 80002fd0 <iunlockput>
    end_op();
    80004b5e:	fffff097          	auipc	ra,0xfffff
    80004b62:	c58080e7          	jalr	-936(ra) # 800037b6 <end_op>
    return -1;
    80004b66:	57fd                	li	a5,-1
    80004b68:	64f2                	ld	s1,280(sp)
    80004b6a:	a089                	j	80004bac <sys_link+0x148>
    iunlockput(dp);
    80004b6c:	854a                	mv	a0,s2
    80004b6e:	ffffe097          	auipc	ra,0xffffe
    80004b72:	462080e7          	jalr	1122(ra) # 80002fd0 <iunlockput>
  ilock(ip);
    80004b76:	8526                	mv	a0,s1
    80004b78:	ffffe097          	auipc	ra,0xffffe
    80004b7c:	1f2080e7          	jalr	498(ra) # 80002d6a <ilock>
  ip->nlink--;
    80004b80:	04a4d783          	lhu	a5,74(s1)
    80004b84:	37fd                	addiw	a5,a5,-1
    80004b86:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b8a:	8526                	mv	a0,s1
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	112080e7          	jalr	274(ra) # 80002c9e <iupdate>
  iunlockput(ip);
    80004b94:	8526                	mv	a0,s1
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	43a080e7          	jalr	1082(ra) # 80002fd0 <iunlockput>
  end_op();
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	c18080e7          	jalr	-1000(ra) # 800037b6 <end_op>
  return -1;
    80004ba6:	57fd                	li	a5,-1
    80004ba8:	64f2                	ld	s1,280(sp)
    80004baa:	6952                	ld	s2,272(sp)
}
    80004bac:	853e                	mv	a0,a5
    80004bae:	70b2                	ld	ra,296(sp)
    80004bb0:	7412                	ld	s0,288(sp)
    80004bb2:	6155                	addi	sp,sp,304
    80004bb4:	8082                	ret

0000000080004bb6 <sys_unlink>:
{
    80004bb6:	7151                	addi	sp,sp,-240
    80004bb8:	f586                	sd	ra,232(sp)
    80004bba:	f1a2                	sd	s0,224(sp)
    80004bbc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004bbe:	08000613          	li	a2,128
    80004bc2:	f3040593          	addi	a1,s0,-208
    80004bc6:	4501                	li	a0,0
    80004bc8:	ffffd097          	auipc	ra,0xffffd
    80004bcc:	604080e7          	jalr	1540(ra) # 800021cc <argstr>
    80004bd0:	1a054a63          	bltz	a0,80004d84 <sys_unlink+0x1ce>
    80004bd4:	eda6                	sd	s1,216(sp)
  begin_op();
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	b66080e7          	jalr	-1178(ra) # 8000373c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bde:	fb040593          	addi	a1,s0,-80
    80004be2:	f3040513          	addi	a0,s0,-208
    80004be6:	fffff097          	auipc	ra,0xfffff
    80004bea:	974080e7          	jalr	-1676(ra) # 8000355a <nameiparent>
    80004bee:	84aa                	mv	s1,a0
    80004bf0:	cd71                	beqz	a0,80004ccc <sys_unlink+0x116>
  ilock(dp);
    80004bf2:	ffffe097          	auipc	ra,0xffffe
    80004bf6:	178080e7          	jalr	376(ra) # 80002d6a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bfa:	00004597          	auipc	a1,0x4
    80004bfe:	9ee58593          	addi	a1,a1,-1554 # 800085e8 <etext+0x5e8>
    80004c02:	fb040513          	addi	a0,s0,-80
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	64a080e7          	jalr	1610(ra) # 80003250 <namecmp>
    80004c0e:	14050c63          	beqz	a0,80004d66 <sys_unlink+0x1b0>
    80004c12:	00003597          	auipc	a1,0x3
    80004c16:	54658593          	addi	a1,a1,1350 # 80008158 <etext+0x158>
    80004c1a:	fb040513          	addi	a0,s0,-80
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	632080e7          	jalr	1586(ra) # 80003250 <namecmp>
    80004c26:	14050063          	beqz	a0,80004d66 <sys_unlink+0x1b0>
    80004c2a:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c2c:	f2c40613          	addi	a2,s0,-212
    80004c30:	fb040593          	addi	a1,s0,-80
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	634080e7          	jalr	1588(ra) # 8000326a <dirlookup>
    80004c3e:	892a                	mv	s2,a0
    80004c40:	12050263          	beqz	a0,80004d64 <sys_unlink+0x1ae>
  ilock(ip);
    80004c44:	ffffe097          	auipc	ra,0xffffe
    80004c48:	126080e7          	jalr	294(ra) # 80002d6a <ilock>
  if(ip->nlink < 1)
    80004c4c:	04a91783          	lh	a5,74(s2)
    80004c50:	08f05563          	blez	a5,80004cda <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c54:	04491703          	lh	a4,68(s2)
    80004c58:	4785                	li	a5,1
    80004c5a:	08f70963          	beq	a4,a5,80004cec <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004c5e:	4641                	li	a2,16
    80004c60:	4581                	li	a1,0
    80004c62:	fc040513          	addi	a0,s0,-64
    80004c66:	ffffb097          	auipc	ra,0xffffb
    80004c6a:	514080e7          	jalr	1300(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c6e:	4741                	li	a4,16
    80004c70:	f2c42683          	lw	a3,-212(s0)
    80004c74:	fc040613          	addi	a2,s0,-64
    80004c78:	4581                	li	a1,0
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	4aa080e7          	jalr	1194(ra) # 80003126 <writei>
    80004c84:	47c1                	li	a5,16
    80004c86:	0af51b63          	bne	a0,a5,80004d3c <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004c8a:	04491703          	lh	a4,68(s2)
    80004c8e:	4785                	li	a5,1
    80004c90:	0af70f63          	beq	a4,a5,80004d4e <sys_unlink+0x198>
  iunlockput(dp);
    80004c94:	8526                	mv	a0,s1
    80004c96:	ffffe097          	auipc	ra,0xffffe
    80004c9a:	33a080e7          	jalr	826(ra) # 80002fd0 <iunlockput>
  ip->nlink--;
    80004c9e:	04a95783          	lhu	a5,74(s2)
    80004ca2:	37fd                	addiw	a5,a5,-1
    80004ca4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ca8:	854a                	mv	a0,s2
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	ff4080e7          	jalr	-12(ra) # 80002c9e <iupdate>
  iunlockput(ip);
    80004cb2:	854a                	mv	a0,s2
    80004cb4:	ffffe097          	auipc	ra,0xffffe
    80004cb8:	31c080e7          	jalr	796(ra) # 80002fd0 <iunlockput>
  end_op();
    80004cbc:	fffff097          	auipc	ra,0xfffff
    80004cc0:	afa080e7          	jalr	-1286(ra) # 800037b6 <end_op>
  return 0;
    80004cc4:	4501                	li	a0,0
    80004cc6:	64ee                	ld	s1,216(sp)
    80004cc8:	694e                	ld	s2,208(sp)
    80004cca:	a84d                	j	80004d7c <sys_unlink+0x1c6>
    end_op();
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	aea080e7          	jalr	-1302(ra) # 800037b6 <end_op>
    return -1;
    80004cd4:	557d                	li	a0,-1
    80004cd6:	64ee                	ld	s1,216(sp)
    80004cd8:	a055                	j	80004d7c <sys_unlink+0x1c6>
    80004cda:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004cdc:	00004517          	auipc	a0,0x4
    80004ce0:	93450513          	addi	a0,a0,-1740 # 80008610 <etext+0x610>
    80004ce4:	00001097          	auipc	ra,0x1
    80004ce8:	208080e7          	jalr	520(ra) # 80005eec <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cec:	04c92703          	lw	a4,76(s2)
    80004cf0:	02000793          	li	a5,32
    80004cf4:	f6e7f5e3          	bgeu	a5,a4,80004c5e <sys_unlink+0xa8>
    80004cf8:	e5ce                	sd	s3,200(sp)
    80004cfa:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cfe:	4741                	li	a4,16
    80004d00:	86ce                	mv	a3,s3
    80004d02:	f1840613          	addi	a2,s0,-232
    80004d06:	4581                	li	a1,0
    80004d08:	854a                	mv	a0,s2
    80004d0a:	ffffe097          	auipc	ra,0xffffe
    80004d0e:	318080e7          	jalr	792(ra) # 80003022 <readi>
    80004d12:	47c1                	li	a5,16
    80004d14:	00f51c63          	bne	a0,a5,80004d2c <sys_unlink+0x176>
    if(de.inum != 0)
    80004d18:	f1845783          	lhu	a5,-232(s0)
    80004d1c:	e7b5                	bnez	a5,80004d88 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d1e:	29c1                	addiw	s3,s3,16
    80004d20:	04c92783          	lw	a5,76(s2)
    80004d24:	fcf9ede3          	bltu	s3,a5,80004cfe <sys_unlink+0x148>
    80004d28:	69ae                	ld	s3,200(sp)
    80004d2a:	bf15                	j	80004c5e <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004d2c:	00004517          	auipc	a0,0x4
    80004d30:	8fc50513          	addi	a0,a0,-1796 # 80008628 <etext+0x628>
    80004d34:	00001097          	auipc	ra,0x1
    80004d38:	1b8080e7          	jalr	440(ra) # 80005eec <panic>
    80004d3c:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004d3e:	00004517          	auipc	a0,0x4
    80004d42:	90250513          	addi	a0,a0,-1790 # 80008640 <etext+0x640>
    80004d46:	00001097          	auipc	ra,0x1
    80004d4a:	1a6080e7          	jalr	422(ra) # 80005eec <panic>
    dp->nlink--;
    80004d4e:	04a4d783          	lhu	a5,74(s1)
    80004d52:	37fd                	addiw	a5,a5,-1
    80004d54:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d58:	8526                	mv	a0,s1
    80004d5a:	ffffe097          	auipc	ra,0xffffe
    80004d5e:	f44080e7          	jalr	-188(ra) # 80002c9e <iupdate>
    80004d62:	bf0d                	j	80004c94 <sys_unlink+0xde>
    80004d64:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004d66:	8526                	mv	a0,s1
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	268080e7          	jalr	616(ra) # 80002fd0 <iunlockput>
  end_op();
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	a46080e7          	jalr	-1466(ra) # 800037b6 <end_op>
  return -1;
    80004d78:	557d                	li	a0,-1
    80004d7a:	64ee                	ld	s1,216(sp)
}
    80004d7c:	70ae                	ld	ra,232(sp)
    80004d7e:	740e                	ld	s0,224(sp)
    80004d80:	616d                	addi	sp,sp,240
    80004d82:	8082                	ret
    return -1;
    80004d84:	557d                	li	a0,-1
    80004d86:	bfdd                	j	80004d7c <sys_unlink+0x1c6>
    iunlockput(ip);
    80004d88:	854a                	mv	a0,s2
    80004d8a:	ffffe097          	auipc	ra,0xffffe
    80004d8e:	246080e7          	jalr	582(ra) # 80002fd0 <iunlockput>
    goto bad;
    80004d92:	694e                	ld	s2,208(sp)
    80004d94:	69ae                	ld	s3,200(sp)
    80004d96:	bfc1                	j	80004d66 <sys_unlink+0x1b0>

0000000080004d98 <sys_open>:

uint64
sys_open(void)
{
    80004d98:	7131                	addi	sp,sp,-192
    80004d9a:	fd06                	sd	ra,184(sp)
    80004d9c:	f922                	sd	s0,176(sp)
    80004d9e:	f526                	sd	s1,168(sp)
    80004da0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004da2:	08000613          	li	a2,128
    80004da6:	f5040593          	addi	a1,s0,-176
    80004daa:	4501                	li	a0,0
    80004dac:	ffffd097          	auipc	ra,0xffffd
    80004db0:	420080e7          	jalr	1056(ra) # 800021cc <argstr>
    return -1;
    80004db4:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004db6:	0c054463          	bltz	a0,80004e7e <sys_open+0xe6>
    80004dba:	f4c40593          	addi	a1,s0,-180
    80004dbe:	4505                	li	a0,1
    80004dc0:	ffffd097          	auipc	ra,0xffffd
    80004dc4:	3c8080e7          	jalr	968(ra) # 80002188 <argint>
    80004dc8:	0a054b63          	bltz	a0,80004e7e <sys_open+0xe6>
    80004dcc:	f14a                	sd	s2,160(sp)

  begin_op();
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	96e080e7          	jalr	-1682(ra) # 8000373c <begin_op>

  if(omode & O_CREATE){
    80004dd6:	f4c42783          	lw	a5,-180(s0)
    80004dda:	2007f793          	andi	a5,a5,512
    80004dde:	cfc5                	beqz	a5,80004e96 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004de0:	4681                	li	a3,0
    80004de2:	4601                	li	a2,0
    80004de4:	4589                	li	a1,2
    80004de6:	f5040513          	addi	a0,s0,-176
    80004dea:	00000097          	auipc	ra,0x0
    80004dee:	958080e7          	jalr	-1704(ra) # 80004742 <create>
    80004df2:	892a                	mv	s2,a0
    if(ip == 0){
    80004df4:	c959                	beqz	a0,80004e8a <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004df6:	04491703          	lh	a4,68(s2)
    80004dfa:	478d                	li	a5,3
    80004dfc:	00f71763          	bne	a4,a5,80004e0a <sys_open+0x72>
    80004e00:	04695703          	lhu	a4,70(s2)
    80004e04:	47a5                	li	a5,9
    80004e06:	0ce7ef63          	bltu	a5,a4,80004ee4 <sys_open+0x14c>
    80004e0a:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	d3e080e7          	jalr	-706(ra) # 80003b4a <filealloc>
    80004e14:	89aa                	mv	s3,a0
    80004e16:	c965                	beqz	a0,80004f06 <sys_open+0x16e>
    80004e18:	00000097          	auipc	ra,0x0
    80004e1c:	8e8080e7          	jalr	-1816(ra) # 80004700 <fdalloc>
    80004e20:	84aa                	mv	s1,a0
    80004e22:	0c054d63          	bltz	a0,80004efc <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e26:	04491703          	lh	a4,68(s2)
    80004e2a:	478d                	li	a5,3
    80004e2c:	0ef70a63          	beq	a4,a5,80004f20 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e30:	4789                	li	a5,2
    80004e32:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e36:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e3a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e3e:	f4c42783          	lw	a5,-180(s0)
    80004e42:	0017c713          	xori	a4,a5,1
    80004e46:	8b05                	andi	a4,a4,1
    80004e48:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e4c:	0037f713          	andi	a4,a5,3
    80004e50:	00e03733          	snez	a4,a4
    80004e54:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e58:	4007f793          	andi	a5,a5,1024
    80004e5c:	c791                	beqz	a5,80004e68 <sys_open+0xd0>
    80004e5e:	04491703          	lh	a4,68(s2)
    80004e62:	4789                	li	a5,2
    80004e64:	0cf70563          	beq	a4,a5,80004f2e <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004e68:	854a                	mv	a0,s2
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	fc6080e7          	jalr	-58(ra) # 80002e30 <iunlock>
  end_op();
    80004e72:	fffff097          	auipc	ra,0xfffff
    80004e76:	944080e7          	jalr	-1724(ra) # 800037b6 <end_op>
    80004e7a:	790a                	ld	s2,160(sp)
    80004e7c:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004e7e:	8526                	mv	a0,s1
    80004e80:	70ea                	ld	ra,184(sp)
    80004e82:	744a                	ld	s0,176(sp)
    80004e84:	74aa                	ld	s1,168(sp)
    80004e86:	6129                	addi	sp,sp,192
    80004e88:	8082                	ret
      end_op();
    80004e8a:	fffff097          	auipc	ra,0xfffff
    80004e8e:	92c080e7          	jalr	-1748(ra) # 800037b6 <end_op>
      return -1;
    80004e92:	790a                	ld	s2,160(sp)
    80004e94:	b7ed                	j	80004e7e <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004e96:	f5040513          	addi	a0,s0,-176
    80004e9a:	ffffe097          	auipc	ra,0xffffe
    80004e9e:	6a2080e7          	jalr	1698(ra) # 8000353c <namei>
    80004ea2:	892a                	mv	s2,a0
    80004ea4:	c90d                	beqz	a0,80004ed6 <sys_open+0x13e>
    ilock(ip);
    80004ea6:	ffffe097          	auipc	ra,0xffffe
    80004eaa:	ec4080e7          	jalr	-316(ra) # 80002d6a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004eae:	04491703          	lh	a4,68(s2)
    80004eb2:	4785                	li	a5,1
    80004eb4:	f4f711e3          	bne	a4,a5,80004df6 <sys_open+0x5e>
    80004eb8:	f4c42783          	lw	a5,-180(s0)
    80004ebc:	d7b9                	beqz	a5,80004e0a <sys_open+0x72>
      iunlockput(ip);
    80004ebe:	854a                	mv	a0,s2
    80004ec0:	ffffe097          	auipc	ra,0xffffe
    80004ec4:	110080e7          	jalr	272(ra) # 80002fd0 <iunlockput>
      end_op();
    80004ec8:	fffff097          	auipc	ra,0xfffff
    80004ecc:	8ee080e7          	jalr	-1810(ra) # 800037b6 <end_op>
      return -1;
    80004ed0:	54fd                	li	s1,-1
    80004ed2:	790a                	ld	s2,160(sp)
    80004ed4:	b76d                	j	80004e7e <sys_open+0xe6>
      end_op();
    80004ed6:	fffff097          	auipc	ra,0xfffff
    80004eda:	8e0080e7          	jalr	-1824(ra) # 800037b6 <end_op>
      return -1;
    80004ede:	54fd                	li	s1,-1
    80004ee0:	790a                	ld	s2,160(sp)
    80004ee2:	bf71                	j	80004e7e <sys_open+0xe6>
    iunlockput(ip);
    80004ee4:	854a                	mv	a0,s2
    80004ee6:	ffffe097          	auipc	ra,0xffffe
    80004eea:	0ea080e7          	jalr	234(ra) # 80002fd0 <iunlockput>
    end_op();
    80004eee:	fffff097          	auipc	ra,0xfffff
    80004ef2:	8c8080e7          	jalr	-1848(ra) # 800037b6 <end_op>
    return -1;
    80004ef6:	54fd                	li	s1,-1
    80004ef8:	790a                	ld	s2,160(sp)
    80004efa:	b751                	j	80004e7e <sys_open+0xe6>
      fileclose(f);
    80004efc:	854e                	mv	a0,s3
    80004efe:	fffff097          	auipc	ra,0xfffff
    80004f02:	d08080e7          	jalr	-760(ra) # 80003c06 <fileclose>
    iunlockput(ip);
    80004f06:	854a                	mv	a0,s2
    80004f08:	ffffe097          	auipc	ra,0xffffe
    80004f0c:	0c8080e7          	jalr	200(ra) # 80002fd0 <iunlockput>
    end_op();
    80004f10:	fffff097          	auipc	ra,0xfffff
    80004f14:	8a6080e7          	jalr	-1882(ra) # 800037b6 <end_op>
    return -1;
    80004f18:	54fd                	li	s1,-1
    80004f1a:	790a                	ld	s2,160(sp)
    80004f1c:	69ea                	ld	s3,152(sp)
    80004f1e:	b785                	j	80004e7e <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004f20:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f24:	04691783          	lh	a5,70(s2)
    80004f28:	02f99223          	sh	a5,36(s3)
    80004f2c:	b739                	j	80004e3a <sys_open+0xa2>
    itrunc(ip);
    80004f2e:	854a                	mv	a0,s2
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	f4c080e7          	jalr	-180(ra) # 80002e7c <itrunc>
    80004f38:	bf05                	j	80004e68 <sys_open+0xd0>

0000000080004f3a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f3a:	7175                	addi	sp,sp,-144
    80004f3c:	e506                	sd	ra,136(sp)
    80004f3e:	e122                	sd	s0,128(sp)
    80004f40:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	7fa080e7          	jalr	2042(ra) # 8000373c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f4a:	08000613          	li	a2,128
    80004f4e:	f7040593          	addi	a1,s0,-144
    80004f52:	4501                	li	a0,0
    80004f54:	ffffd097          	auipc	ra,0xffffd
    80004f58:	278080e7          	jalr	632(ra) # 800021cc <argstr>
    80004f5c:	02054963          	bltz	a0,80004f8e <sys_mkdir+0x54>
    80004f60:	4681                	li	a3,0
    80004f62:	4601                	li	a2,0
    80004f64:	4585                	li	a1,1
    80004f66:	f7040513          	addi	a0,s0,-144
    80004f6a:	fffff097          	auipc	ra,0xfffff
    80004f6e:	7d8080e7          	jalr	2008(ra) # 80004742 <create>
    80004f72:	cd11                	beqz	a0,80004f8e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f74:	ffffe097          	auipc	ra,0xffffe
    80004f78:	05c080e7          	jalr	92(ra) # 80002fd0 <iunlockput>
  end_op();
    80004f7c:	fffff097          	auipc	ra,0xfffff
    80004f80:	83a080e7          	jalr	-1990(ra) # 800037b6 <end_op>
  return 0;
    80004f84:	4501                	li	a0,0
}
    80004f86:	60aa                	ld	ra,136(sp)
    80004f88:	640a                	ld	s0,128(sp)
    80004f8a:	6149                	addi	sp,sp,144
    80004f8c:	8082                	ret
    end_op();
    80004f8e:	fffff097          	auipc	ra,0xfffff
    80004f92:	828080e7          	jalr	-2008(ra) # 800037b6 <end_op>
    return -1;
    80004f96:	557d                	li	a0,-1
    80004f98:	b7fd                	j	80004f86 <sys_mkdir+0x4c>

0000000080004f9a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f9a:	7135                	addi	sp,sp,-160
    80004f9c:	ed06                	sd	ra,152(sp)
    80004f9e:	e922                	sd	s0,144(sp)
    80004fa0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	79a080e7          	jalr	1946(ra) # 8000373c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004faa:	08000613          	li	a2,128
    80004fae:	f7040593          	addi	a1,s0,-144
    80004fb2:	4501                	li	a0,0
    80004fb4:	ffffd097          	auipc	ra,0xffffd
    80004fb8:	218080e7          	jalr	536(ra) # 800021cc <argstr>
    80004fbc:	04054a63          	bltz	a0,80005010 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004fc0:	f6c40593          	addi	a1,s0,-148
    80004fc4:	4505                	li	a0,1
    80004fc6:	ffffd097          	auipc	ra,0xffffd
    80004fca:	1c2080e7          	jalr	450(ra) # 80002188 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fce:	04054163          	bltz	a0,80005010 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004fd2:	f6840593          	addi	a1,s0,-152
    80004fd6:	4509                	li	a0,2
    80004fd8:	ffffd097          	auipc	ra,0xffffd
    80004fdc:	1b0080e7          	jalr	432(ra) # 80002188 <argint>
     argint(1, &major) < 0 ||
    80004fe0:	02054863          	bltz	a0,80005010 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fe4:	f6841683          	lh	a3,-152(s0)
    80004fe8:	f6c41603          	lh	a2,-148(s0)
    80004fec:	458d                	li	a1,3
    80004fee:	f7040513          	addi	a0,s0,-144
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	750080e7          	jalr	1872(ra) # 80004742 <create>
     argint(2, &minor) < 0 ||
    80004ffa:	c919                	beqz	a0,80005010 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ffc:	ffffe097          	auipc	ra,0xffffe
    80005000:	fd4080e7          	jalr	-44(ra) # 80002fd0 <iunlockput>
  end_op();
    80005004:	ffffe097          	auipc	ra,0xffffe
    80005008:	7b2080e7          	jalr	1970(ra) # 800037b6 <end_op>
  return 0;
    8000500c:	4501                	li	a0,0
    8000500e:	a031                	j	8000501a <sys_mknod+0x80>
    end_op();
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	7a6080e7          	jalr	1958(ra) # 800037b6 <end_op>
    return -1;
    80005018:	557d                	li	a0,-1
}
    8000501a:	60ea                	ld	ra,152(sp)
    8000501c:	644a                	ld	s0,144(sp)
    8000501e:	610d                	addi	sp,sp,160
    80005020:	8082                	ret

0000000080005022 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005022:	7135                	addi	sp,sp,-160
    80005024:	ed06                	sd	ra,152(sp)
    80005026:	e922                	sd	s0,144(sp)
    80005028:	e14a                	sd	s2,128(sp)
    8000502a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000502c:	ffffc097          	auipc	ra,0xffffc
    80005030:	fe8080e7          	jalr	-24(ra) # 80001014 <myproc>
    80005034:	892a                	mv	s2,a0
  
  begin_op();
    80005036:	ffffe097          	auipc	ra,0xffffe
    8000503a:	706080e7          	jalr	1798(ra) # 8000373c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000503e:	08000613          	li	a2,128
    80005042:	f6040593          	addi	a1,s0,-160
    80005046:	4501                	li	a0,0
    80005048:	ffffd097          	auipc	ra,0xffffd
    8000504c:	184080e7          	jalr	388(ra) # 800021cc <argstr>
    80005050:	04054d63          	bltz	a0,800050aa <sys_chdir+0x88>
    80005054:	e526                	sd	s1,136(sp)
    80005056:	f6040513          	addi	a0,s0,-160
    8000505a:	ffffe097          	auipc	ra,0xffffe
    8000505e:	4e2080e7          	jalr	1250(ra) # 8000353c <namei>
    80005062:	84aa                	mv	s1,a0
    80005064:	c131                	beqz	a0,800050a8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005066:	ffffe097          	auipc	ra,0xffffe
    8000506a:	d04080e7          	jalr	-764(ra) # 80002d6a <ilock>
  if(ip->type != T_DIR){
    8000506e:	04449703          	lh	a4,68(s1)
    80005072:	4785                	li	a5,1
    80005074:	04f71163          	bne	a4,a5,800050b6 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005078:	8526                	mv	a0,s1
    8000507a:	ffffe097          	auipc	ra,0xffffe
    8000507e:	db6080e7          	jalr	-586(ra) # 80002e30 <iunlock>
  iput(p->cwd);
    80005082:	16093503          	ld	a0,352(s2)
    80005086:	ffffe097          	auipc	ra,0xffffe
    8000508a:	ea2080e7          	jalr	-350(ra) # 80002f28 <iput>
  end_op();
    8000508e:	ffffe097          	auipc	ra,0xffffe
    80005092:	728080e7          	jalr	1832(ra) # 800037b6 <end_op>
  p->cwd = ip;
    80005096:	16993023          	sd	s1,352(s2)
  return 0;
    8000509a:	4501                	li	a0,0
    8000509c:	64aa                	ld	s1,136(sp)
}
    8000509e:	60ea                	ld	ra,152(sp)
    800050a0:	644a                	ld	s0,144(sp)
    800050a2:	690a                	ld	s2,128(sp)
    800050a4:	610d                	addi	sp,sp,160
    800050a6:	8082                	ret
    800050a8:	64aa                	ld	s1,136(sp)
    end_op();
    800050aa:	ffffe097          	auipc	ra,0xffffe
    800050ae:	70c080e7          	jalr	1804(ra) # 800037b6 <end_op>
    return -1;
    800050b2:	557d                	li	a0,-1
    800050b4:	b7ed                	j	8000509e <sys_chdir+0x7c>
    iunlockput(ip);
    800050b6:	8526                	mv	a0,s1
    800050b8:	ffffe097          	auipc	ra,0xffffe
    800050bc:	f18080e7          	jalr	-232(ra) # 80002fd0 <iunlockput>
    end_op();
    800050c0:	ffffe097          	auipc	ra,0xffffe
    800050c4:	6f6080e7          	jalr	1782(ra) # 800037b6 <end_op>
    return -1;
    800050c8:	557d                	li	a0,-1
    800050ca:	64aa                	ld	s1,136(sp)
    800050cc:	bfc9                	j	8000509e <sys_chdir+0x7c>

00000000800050ce <sys_exec>:

uint64
sys_exec(void)
{
    800050ce:	7121                	addi	sp,sp,-448
    800050d0:	ff06                	sd	ra,440(sp)
    800050d2:	fb22                	sd	s0,432(sp)
    800050d4:	f34a                	sd	s2,416(sp)
    800050d6:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050d8:	08000613          	li	a2,128
    800050dc:	f5040593          	addi	a1,s0,-176
    800050e0:	4501                	li	a0,0
    800050e2:	ffffd097          	auipc	ra,0xffffd
    800050e6:	0ea080e7          	jalr	234(ra) # 800021cc <argstr>
    return -1;
    800050ea:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050ec:	0e054a63          	bltz	a0,800051e0 <sys_exec+0x112>
    800050f0:	e4840593          	addi	a1,s0,-440
    800050f4:	4505                	li	a0,1
    800050f6:	ffffd097          	auipc	ra,0xffffd
    800050fa:	0b4080e7          	jalr	180(ra) # 800021aa <argaddr>
    800050fe:	0e054163          	bltz	a0,800051e0 <sys_exec+0x112>
    80005102:	f726                	sd	s1,424(sp)
    80005104:	ef4e                	sd	s3,408(sp)
    80005106:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005108:	10000613          	li	a2,256
    8000510c:	4581                	li	a1,0
    8000510e:	e5040513          	addi	a0,s0,-432
    80005112:	ffffb097          	auipc	ra,0xffffb
    80005116:	068080e7          	jalr	104(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000511a:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000511e:	89a6                	mv	s3,s1
    80005120:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005122:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005126:	00391513          	slli	a0,s2,0x3
    8000512a:	e4040593          	addi	a1,s0,-448
    8000512e:	e4843783          	ld	a5,-440(s0)
    80005132:	953e                	add	a0,a0,a5
    80005134:	ffffd097          	auipc	ra,0xffffd
    80005138:	fba080e7          	jalr	-70(ra) # 800020ee <fetchaddr>
    8000513c:	02054a63          	bltz	a0,80005170 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005140:	e4043783          	ld	a5,-448(s0)
    80005144:	c7b1                	beqz	a5,80005190 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005146:	ffffb097          	auipc	ra,0xffffb
    8000514a:	fd4080e7          	jalr	-44(ra) # 8000011a <kalloc>
    8000514e:	85aa                	mv	a1,a0
    80005150:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005154:	cd11                	beqz	a0,80005170 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005156:	6605                	lui	a2,0x1
    80005158:	e4043503          	ld	a0,-448(s0)
    8000515c:	ffffd097          	auipc	ra,0xffffd
    80005160:	fe4080e7          	jalr	-28(ra) # 80002140 <fetchstr>
    80005164:	00054663          	bltz	a0,80005170 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005168:	0905                	addi	s2,s2,1
    8000516a:	09a1                	addi	s3,s3,8
    8000516c:	fb491de3          	bne	s2,s4,80005126 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005170:	f5040913          	addi	s2,s0,-176
    80005174:	6088                	ld	a0,0(s1)
    80005176:	c12d                	beqz	a0,800051d8 <sys_exec+0x10a>
    kfree(argv[i]);
    80005178:	ffffb097          	auipc	ra,0xffffb
    8000517c:	ea4080e7          	jalr	-348(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005180:	04a1                	addi	s1,s1,8
    80005182:	ff2499e3          	bne	s1,s2,80005174 <sys_exec+0xa6>
  return -1;
    80005186:	597d                	li	s2,-1
    80005188:	74ba                	ld	s1,424(sp)
    8000518a:	69fa                	ld	s3,408(sp)
    8000518c:	6a5a                	ld	s4,400(sp)
    8000518e:	a889                	j	800051e0 <sys_exec+0x112>
      argv[i] = 0;
    80005190:	0009079b          	sext.w	a5,s2
    80005194:	078e                	slli	a5,a5,0x3
    80005196:	fd078793          	addi	a5,a5,-48
    8000519a:	97a2                	add	a5,a5,s0
    8000519c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800051a0:	e5040593          	addi	a1,s0,-432
    800051a4:	f5040513          	addi	a0,s0,-176
    800051a8:	fffff097          	auipc	ra,0xfffff
    800051ac:	10e080e7          	jalr	270(ra) # 800042b6 <exec>
    800051b0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051b2:	f5040993          	addi	s3,s0,-176
    800051b6:	6088                	ld	a0,0(s1)
    800051b8:	cd01                	beqz	a0,800051d0 <sys_exec+0x102>
    kfree(argv[i]);
    800051ba:	ffffb097          	auipc	ra,0xffffb
    800051be:	e62080e7          	jalr	-414(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051c2:	04a1                	addi	s1,s1,8
    800051c4:	ff3499e3          	bne	s1,s3,800051b6 <sys_exec+0xe8>
    800051c8:	74ba                	ld	s1,424(sp)
    800051ca:	69fa                	ld	s3,408(sp)
    800051cc:	6a5a                	ld	s4,400(sp)
    800051ce:	a809                	j	800051e0 <sys_exec+0x112>
  return ret;
    800051d0:	74ba                	ld	s1,424(sp)
    800051d2:	69fa                	ld	s3,408(sp)
    800051d4:	6a5a                	ld	s4,400(sp)
    800051d6:	a029                	j	800051e0 <sys_exec+0x112>
  return -1;
    800051d8:	597d                	li	s2,-1
    800051da:	74ba                	ld	s1,424(sp)
    800051dc:	69fa                	ld	s3,408(sp)
    800051de:	6a5a                	ld	s4,400(sp)
}
    800051e0:	854a                	mv	a0,s2
    800051e2:	70fa                	ld	ra,440(sp)
    800051e4:	745a                	ld	s0,432(sp)
    800051e6:	791a                	ld	s2,416(sp)
    800051e8:	6139                	addi	sp,sp,448
    800051ea:	8082                	ret

00000000800051ec <sys_pipe>:

uint64
sys_pipe(void)
{
    800051ec:	7139                	addi	sp,sp,-64
    800051ee:	fc06                	sd	ra,56(sp)
    800051f0:	f822                	sd	s0,48(sp)
    800051f2:	f426                	sd	s1,40(sp)
    800051f4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051f6:	ffffc097          	auipc	ra,0xffffc
    800051fa:	e1e080e7          	jalr	-482(ra) # 80001014 <myproc>
    800051fe:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005200:	fd840593          	addi	a1,s0,-40
    80005204:	4501                	li	a0,0
    80005206:	ffffd097          	auipc	ra,0xffffd
    8000520a:	fa4080e7          	jalr	-92(ra) # 800021aa <argaddr>
    return -1;
    8000520e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005210:	0e054063          	bltz	a0,800052f0 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005214:	fc840593          	addi	a1,s0,-56
    80005218:	fd040513          	addi	a0,s0,-48
    8000521c:	fffff097          	auipc	ra,0xfffff
    80005220:	d58080e7          	jalr	-680(ra) # 80003f74 <pipealloc>
    return -1;
    80005224:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005226:	0c054563          	bltz	a0,800052f0 <sys_pipe+0x104>
  fd0 = -1;
    8000522a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000522e:	fd043503          	ld	a0,-48(s0)
    80005232:	fffff097          	auipc	ra,0xfffff
    80005236:	4ce080e7          	jalr	1230(ra) # 80004700 <fdalloc>
    8000523a:	fca42223          	sw	a0,-60(s0)
    8000523e:	08054c63          	bltz	a0,800052d6 <sys_pipe+0xea>
    80005242:	fc843503          	ld	a0,-56(s0)
    80005246:	fffff097          	auipc	ra,0xfffff
    8000524a:	4ba080e7          	jalr	1210(ra) # 80004700 <fdalloc>
    8000524e:	fca42023          	sw	a0,-64(s0)
    80005252:	06054963          	bltz	a0,800052c4 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005256:	4691                	li	a3,4
    80005258:	fc440613          	addi	a2,s0,-60
    8000525c:	fd843583          	ld	a1,-40(s0)
    80005260:	70a8                	ld	a0,96(s1)
    80005262:	ffffc097          	auipc	ra,0xffffc
    80005266:	8b6080e7          	jalr	-1866(ra) # 80000b18 <copyout>
    8000526a:	02054063          	bltz	a0,8000528a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000526e:	4691                	li	a3,4
    80005270:	fc040613          	addi	a2,s0,-64
    80005274:	fd843583          	ld	a1,-40(s0)
    80005278:	0591                	addi	a1,a1,4
    8000527a:	70a8                	ld	a0,96(s1)
    8000527c:	ffffc097          	auipc	ra,0xffffc
    80005280:	89c080e7          	jalr	-1892(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005284:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005286:	06055563          	bgez	a0,800052f0 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000528a:	fc442783          	lw	a5,-60(s0)
    8000528e:	07f1                	addi	a5,a5,28
    80005290:	078e                	slli	a5,a5,0x3
    80005292:	97a6                	add	a5,a5,s1
    80005294:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005298:	fc042783          	lw	a5,-64(s0)
    8000529c:	07f1                	addi	a5,a5,28
    8000529e:	078e                	slli	a5,a5,0x3
    800052a0:	00f48533          	add	a0,s1,a5
    800052a4:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800052a8:	fd043503          	ld	a0,-48(s0)
    800052ac:	fffff097          	auipc	ra,0xfffff
    800052b0:	95a080e7          	jalr	-1702(ra) # 80003c06 <fileclose>
    fileclose(wf);
    800052b4:	fc843503          	ld	a0,-56(s0)
    800052b8:	fffff097          	auipc	ra,0xfffff
    800052bc:	94e080e7          	jalr	-1714(ra) # 80003c06 <fileclose>
    return -1;
    800052c0:	57fd                	li	a5,-1
    800052c2:	a03d                	j	800052f0 <sys_pipe+0x104>
    if(fd0 >= 0)
    800052c4:	fc442783          	lw	a5,-60(s0)
    800052c8:	0007c763          	bltz	a5,800052d6 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800052cc:	07f1                	addi	a5,a5,28
    800052ce:	078e                	slli	a5,a5,0x3
    800052d0:	97a6                	add	a5,a5,s1
    800052d2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800052d6:	fd043503          	ld	a0,-48(s0)
    800052da:	fffff097          	auipc	ra,0xfffff
    800052de:	92c080e7          	jalr	-1748(ra) # 80003c06 <fileclose>
    fileclose(wf);
    800052e2:	fc843503          	ld	a0,-56(s0)
    800052e6:	fffff097          	auipc	ra,0xfffff
    800052ea:	920080e7          	jalr	-1760(ra) # 80003c06 <fileclose>
    return -1;
    800052ee:	57fd                	li	a5,-1
}
    800052f0:	853e                	mv	a0,a5
    800052f2:	70e2                	ld	ra,56(sp)
    800052f4:	7442                	ld	s0,48(sp)
    800052f6:	74a2                	ld	s1,40(sp)
    800052f8:	6121                	addi	sp,sp,64
    800052fa:	8082                	ret
    800052fc:	0000                	unimp
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
    80005340:	c7bfc0ef          	jal	80001fba <kerneltrap>
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
    800053e0:	c0c080e7          	jalr	-1012(ra) # 80000fe8 <cpuid>
  
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
    80005418:	bd4080e7          	jalr	-1068(ra) # 80000fe8 <cpuid>
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
    80005440:	bac080e7          	jalr	-1108(ra) # 80000fe8 <cpuid>
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
    80005468:	00016717          	auipc	a4,0x16
    8000546c:	b9870713          	addi	a4,a4,-1128 # 8001b000 <disk>
    80005470:	972a                	add	a4,a4,a0
    80005472:	6789                	lui	a5,0x2
    80005474:	97ba                	add	a5,a5,a4
    80005476:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000547a:	e7ad                	bnez	a5,800054e4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000547c:	00451793          	slli	a5,a0,0x4
    80005480:	00018717          	auipc	a4,0x18
    80005484:	b8070713          	addi	a4,a4,-1152 # 8001d000 <disk+0x2000>
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
    800054a8:	00016717          	auipc	a4,0x16
    800054ac:	b5870713          	addi	a4,a4,-1192 # 8001b000 <disk>
    800054b0:	972a                	add	a4,a4,a0
    800054b2:	6789                	lui	a5,0x2
    800054b4:	97ba                	add	a5,a5,a4
    800054b6:	4705                	li	a4,1
    800054b8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800054bc:	00018517          	auipc	a0,0x18
    800054c0:	b5c50513          	addi	a0,a0,-1188 # 8001d018 <disk+0x2018>
    800054c4:	ffffc097          	auipc	ra,0xffffc
    800054c8:	456080e7          	jalr	1110(ra) # 8000191a <wakeup>
}
    800054cc:	60a2                	ld	ra,8(sp)
    800054ce:	6402                	ld	s0,0(sp)
    800054d0:	0141                	addi	sp,sp,16
    800054d2:	8082                	ret
    panic("free_desc 1");
    800054d4:	00003517          	auipc	a0,0x3
    800054d8:	17c50513          	addi	a0,a0,380 # 80008650 <etext+0x650>
    800054dc:	00001097          	auipc	ra,0x1
    800054e0:	a10080e7          	jalr	-1520(ra) # 80005eec <panic>
    panic("free_desc 2");
    800054e4:	00003517          	auipc	a0,0x3
    800054e8:	17c50513          	addi	a0,a0,380 # 80008660 <etext+0x660>
    800054ec:	00001097          	auipc	ra,0x1
    800054f0:	a00080e7          	jalr	-1536(ra) # 80005eec <panic>

00000000800054f4 <virtio_disk_init>:
{
    800054f4:	1141                	addi	sp,sp,-16
    800054f6:	e406                	sd	ra,8(sp)
    800054f8:	e022                	sd	s0,0(sp)
    800054fa:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054fc:	00003597          	auipc	a1,0x3
    80005500:	17458593          	addi	a1,a1,372 # 80008670 <etext+0x670>
    80005504:	00018517          	auipc	a0,0x18
    80005508:	c2450513          	addi	a0,a0,-988 # 8001d128 <disk+0x2128>
    8000550c:	00001097          	auipc	ra,0x1
    80005510:	eca080e7          	jalr	-310(ra) # 800063d6 <initlock>
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
    80005572:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
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
    800055b6:	00016517          	auipc	a0,0x16
    800055ba:	a4a50513          	addi	a0,a0,-1462 # 8001b000 <disk>
    800055be:	ffffb097          	auipc	ra,0xffffb
    800055c2:	bbc080e7          	jalr	-1092(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800055c6:	00016697          	auipc	a3,0x16
    800055ca:	a3a68693          	addi	a3,a3,-1478 # 8001b000 <disk>
    800055ce:	00c6d713          	srli	a4,a3,0xc
    800055d2:	2701                	sext.w	a4,a4
    800055d4:	100017b7          	lui	a5,0x10001
    800055d8:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    800055da:	00018797          	auipc	a5,0x18
    800055de:	a2678793          	addi	a5,a5,-1498 # 8001d000 <disk+0x2000>
    800055e2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800055e4:	00016717          	auipc	a4,0x16
    800055e8:	a9c70713          	addi	a4,a4,-1380 # 8001b080 <disk+0x80>
    800055ec:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800055ee:	00017717          	auipc	a4,0x17
    800055f2:	a1270713          	addi	a4,a4,-1518 # 8001c000 <disk+0x1000>
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
    80005626:	05e50513          	addi	a0,a0,94 # 80008680 <etext+0x680>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	8c2080e7          	jalr	-1854(ra) # 80005eec <panic>
    panic("virtio disk has no queue 0");
    80005632:	00003517          	auipc	a0,0x3
    80005636:	06e50513          	addi	a0,a0,110 # 800086a0 <etext+0x6a0>
    8000563a:	00001097          	auipc	ra,0x1
    8000563e:	8b2080e7          	jalr	-1870(ra) # 80005eec <panic>
    panic("virtio disk max queue too short");
    80005642:	00003517          	auipc	a0,0x3
    80005646:	07e50513          	addi	a0,a0,126 # 800086c0 <etext+0x6c0>
    8000564a:	00001097          	auipc	ra,0x1
    8000564e:	8a2080e7          	jalr	-1886(ra) # 80005eec <panic>

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
    8000567e:	00018517          	auipc	a0,0x18
    80005682:	aaa50513          	addi	a0,a0,-1366 # 8001d128 <disk+0x2128>
    80005686:	00001097          	auipc	ra,0x1
    8000568a:	de0080e7          	jalr	-544(ra) # 80006466 <acquire>
  for(int i = 0; i < 3; i++){
    8000568e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005690:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005692:	00016b97          	auipc	s7,0x16
    80005696:	96eb8b93          	addi	s7,s7,-1682 # 8001b000 <disk>
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
    800056ba:	00018717          	auipc	a4,0x18
    800056be:	95e70713          	addi	a4,a4,-1698 # 8001d018 <disk+0x2018>
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
    800056f8:	00018597          	auipc	a1,0x18
    800056fc:	a3058593          	addi	a1,a1,-1488 # 8001d128 <disk+0x2128>
    80005700:	00018517          	auipc	a0,0x18
    80005704:	91850513          	addi	a0,a0,-1768 # 8001d018 <disk+0x2018>
    80005708:	ffffc097          	auipc	ra,0xffffc
    8000570c:	086080e7          	jalr	134(ra) # 8000178e <sleep>
  for(int i = 0; i < 3; i++){
    80005710:	f9040613          	addi	a2,s0,-112
    80005714:	894e                	mv	s2,s3
    80005716:	b74d                	j	800056b8 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005718:	00018717          	auipc	a4,0x18
    8000571c:	8e873703          	ld	a4,-1816(a4) # 8001d000 <disk+0x2000>
    80005720:	973e                	add	a4,a4,a5
    80005722:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005726:	00016897          	auipc	a7,0x16
    8000572a:	8da88893          	addi	a7,a7,-1830 # 8001b000 <disk>
    8000572e:	00018717          	auipc	a4,0x18
    80005732:	8d270713          	addi	a4,a4,-1838 # 8001d000 <disk+0x2000>
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
    800057ce:	00018917          	auipc	s2,0x18
    800057d2:	95a90913          	addi	s2,s2,-1702 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800057d6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057d8:	85ca                	mv	a1,s2
    800057da:	8552                	mv	a0,s4
    800057dc:	ffffc097          	auipc	ra,0xffffc
    800057e0:	fb2080e7          	jalr	-78(ra) # 8000178e <sleep>
  while(b->disk == 1) {
    800057e4:	004a2783          	lw	a5,4(s4)
    800057e8:	fe9788e3          	beq	a5,s1,800057d8 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800057ec:	f9042903          	lw	s2,-112(s0)
    800057f0:	20090713          	addi	a4,s2,512
    800057f4:	0712                	slli	a4,a4,0x4
    800057f6:	00016797          	auipc	a5,0x16
    800057fa:	80a78793          	addi	a5,a5,-2038 # 8001b000 <disk>
    800057fe:	97ba                	add	a5,a5,a4
    80005800:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005804:	00017997          	auipc	s3,0x17
    80005808:	7fc98993          	addi	s3,s3,2044 # 8001d000 <disk+0x2000>
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
    8000582c:	00018517          	auipc	a0,0x18
    80005830:	8fc50513          	addi	a0,a0,-1796 # 8001d128 <disk+0x2128>
    80005834:	00001097          	auipc	ra,0x1
    80005838:	ce6080e7          	jalr	-794(ra) # 8000651a <release>
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
    8000585e:	00015597          	auipc	a1,0x15
    80005862:	7a258593          	addi	a1,a1,1954 # 8001b000 <disk>
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
    8000587e:	00017717          	auipc	a4,0x17
    80005882:	78270713          	addi	a4,a4,1922 # 8001d000 <disk+0x2000>
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
    800058ba:	058a0593          	addi	a1,s4,88
    800058be:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    800058c0:	6318                	ld	a4,0(a4)
    800058c2:	973e                	add	a4,a4,a5
    800058c4:	40000693          	li	a3,1024
    800058c8:	c714                	sw	a3,8(a4)
  if(write)
    800058ca:	e40c97e3          	bnez	s9,80005718 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058ce:	00017717          	auipc	a4,0x17
    800058d2:	73273703          	ld	a4,1842(a4) # 8001d000 <disk+0x2000>
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
    800058e8:	00018517          	auipc	a0,0x18
    800058ec:	84050513          	addi	a0,a0,-1984 # 8001d128 <disk+0x2128>
    800058f0:	00001097          	auipc	ra,0x1
    800058f4:	b76080e7          	jalr	-1162(ra) # 80006466 <acquire>
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
    8000590a:	00017797          	auipc	a5,0x17
    8000590e:	6f678793          	addi	a5,a5,1782 # 8001d000 <disk+0x2000>
    80005912:	6b94                	ld	a3,16(a5)
    80005914:	0207d703          	lhu	a4,32(a5)
    80005918:	0026d783          	lhu	a5,2(a3)
    8000591c:	06f70563          	beq	a4,a5,80005986 <virtio_disk_intr+0xa6>
    80005920:	e426                	sd	s1,8(sp)
    80005922:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005924:	00015917          	auipc	s2,0x15
    80005928:	6dc90913          	addi	s2,s2,1756 # 8001b000 <disk>
    8000592c:	00017497          	auipc	s1,0x17
    80005930:	6d448493          	addi	s1,s1,1748 # 8001d000 <disk+0x2000>
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
    80005966:	fb8080e7          	jalr	-72(ra) # 8000191a <wakeup>

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
    80005986:	00017517          	auipc	a0,0x17
    8000598a:	7a250513          	addi	a0,a0,1954 # 8001d128 <disk+0x2128>
    8000598e:	00001097          	auipc	ra,0x1
    80005992:	b8c080e7          	jalr	-1140(ra) # 8000651a <release>
}
    80005996:	60e2                	ld	ra,24(sp)
    80005998:	6442                	ld	s0,16(sp)
    8000599a:	6105                	addi	sp,sp,32
    8000599c:	8082                	ret
      panic("virtio_disk_intr status");
    8000599e:	00003517          	auipc	a0,0x3
    800059a2:	d4250513          	addi	a0,a0,-702 # 800086e0 <etext+0x6e0>
    800059a6:	00000097          	auipc	ra,0x0
    800059aa:	546080e7          	jalr	1350(ra) # 80005eec <panic>

00000000800059ae <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800059ae:	1141                	addi	sp,sp,-16
    800059b0:	e422                	sd	s0,8(sp)
    800059b2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059b4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800059b8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800059bc:	0037979b          	slliw	a5,a5,0x3
    800059c0:	02004737          	lui	a4,0x2004
    800059c4:	97ba                	add	a5,a5,a4
    800059c6:	0200c737          	lui	a4,0x200c
    800059ca:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    800059cc:	6318                	ld	a4,0(a4)
    800059ce:	000f4637          	lui	a2,0xf4
    800059d2:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059d6:	9732                	add	a4,a4,a2
    800059d8:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059da:	00259693          	slli	a3,a1,0x2
    800059de:	96ae                	add	a3,a3,a1
    800059e0:	068e                	slli	a3,a3,0x3
    800059e2:	00018717          	auipc	a4,0x18
    800059e6:	61e70713          	addi	a4,a4,1566 # 8001e000 <timer_scratch>
    800059ea:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059ec:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059ee:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059f0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059f4:	00000797          	auipc	a5,0x0
    800059f8:	99c78793          	addi	a5,a5,-1636 # 80005390 <timervec>
    800059fc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a00:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a04:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a08:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005a0c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a10:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a14:	30479073          	csrw	mie,a5
}
    80005a18:	6422                	ld	s0,8(sp)
    80005a1a:	0141                	addi	sp,sp,16
    80005a1c:	8082                	ret

0000000080005a1e <start>:
{
    80005a1e:	1141                	addi	sp,sp,-16
    80005a20:	e406                	sd	ra,8(sp)
    80005a22:	e022                	sd	s0,0(sp)
    80005a24:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a26:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a2a:	7779                	lui	a4,0xffffe
    80005a2c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005a30:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a32:	6705                	lui	a4,0x1
    80005a34:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a38:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a3a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a3e:	ffffb797          	auipc	a5,0xffffb
    80005a42:	8da78793          	addi	a5,a5,-1830 # 80000318 <main>
    80005a46:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a4a:	4781                	li	a5,0
    80005a4c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a50:	67c1                	lui	a5,0x10
    80005a52:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a54:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a58:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a5c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a60:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a64:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a68:	57fd                	li	a5,-1
    80005a6a:	83a9                	srli	a5,a5,0xa
    80005a6c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a70:	47bd                	li	a5,15
    80005a72:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a76:	00000097          	auipc	ra,0x0
    80005a7a:	f38080e7          	jalr	-200(ra) # 800059ae <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a7e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a82:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a84:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a86:	30200073          	mret
}
    80005a8a:	60a2                	ld	ra,8(sp)
    80005a8c:	6402                	ld	s0,0(sp)
    80005a8e:	0141                	addi	sp,sp,16
    80005a90:	8082                	ret

0000000080005a92 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a92:	715d                	addi	sp,sp,-80
    80005a94:	e486                	sd	ra,72(sp)
    80005a96:	e0a2                	sd	s0,64(sp)
    80005a98:	f84a                	sd	s2,48(sp)
    80005a9a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a9c:	04c05663          	blez	a2,80005ae8 <consolewrite+0x56>
    80005aa0:	fc26                	sd	s1,56(sp)
    80005aa2:	f44e                	sd	s3,40(sp)
    80005aa4:	f052                	sd	s4,32(sp)
    80005aa6:	ec56                	sd	s5,24(sp)
    80005aa8:	8a2a                	mv	s4,a0
    80005aaa:	84ae                	mv	s1,a1
    80005aac:	89b2                	mv	s3,a2
    80005aae:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005ab0:	5afd                	li	s5,-1
    80005ab2:	4685                	li	a3,1
    80005ab4:	8626                	mv	a2,s1
    80005ab6:	85d2                	mv	a1,s4
    80005ab8:	fbf40513          	addi	a0,s0,-65
    80005abc:	ffffc097          	auipc	ra,0xffffc
    80005ac0:	0cc080e7          	jalr	204(ra) # 80001b88 <either_copyin>
    80005ac4:	03550463          	beq	a0,s5,80005aec <consolewrite+0x5a>
      break;
    uartputc(c);
    80005ac8:	fbf44503          	lbu	a0,-65(s0)
    80005acc:	00000097          	auipc	ra,0x0
    80005ad0:	7de080e7          	jalr	2014(ra) # 800062aa <uartputc>
  for(i = 0; i < n; i++){
    80005ad4:	2905                	addiw	s2,s2,1
    80005ad6:	0485                	addi	s1,s1,1
    80005ad8:	fd299de3          	bne	s3,s2,80005ab2 <consolewrite+0x20>
    80005adc:	894e                	mv	s2,s3
    80005ade:	74e2                	ld	s1,56(sp)
    80005ae0:	79a2                	ld	s3,40(sp)
    80005ae2:	7a02                	ld	s4,32(sp)
    80005ae4:	6ae2                	ld	s5,24(sp)
    80005ae6:	a039                	j	80005af4 <consolewrite+0x62>
    80005ae8:	4901                	li	s2,0
    80005aea:	a029                	j	80005af4 <consolewrite+0x62>
    80005aec:	74e2                	ld	s1,56(sp)
    80005aee:	79a2                	ld	s3,40(sp)
    80005af0:	7a02                	ld	s4,32(sp)
    80005af2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005af4:	854a                	mv	a0,s2
    80005af6:	60a6                	ld	ra,72(sp)
    80005af8:	6406                	ld	s0,64(sp)
    80005afa:	7942                	ld	s2,48(sp)
    80005afc:	6161                	addi	sp,sp,80
    80005afe:	8082                	ret

0000000080005b00 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005b00:	711d                	addi	sp,sp,-96
    80005b02:	ec86                	sd	ra,88(sp)
    80005b04:	e8a2                	sd	s0,80(sp)
    80005b06:	e4a6                	sd	s1,72(sp)
    80005b08:	e0ca                	sd	s2,64(sp)
    80005b0a:	fc4e                	sd	s3,56(sp)
    80005b0c:	f852                	sd	s4,48(sp)
    80005b0e:	f456                	sd	s5,40(sp)
    80005b10:	f05a                	sd	s6,32(sp)
    80005b12:	1080                	addi	s0,sp,96
    80005b14:	8aaa                	mv	s5,a0
    80005b16:	8a2e                	mv	s4,a1
    80005b18:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b1a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005b1e:	00020517          	auipc	a0,0x20
    80005b22:	62250513          	addi	a0,a0,1570 # 80026140 <cons>
    80005b26:	00001097          	auipc	ra,0x1
    80005b2a:	940080e7          	jalr	-1728(ra) # 80006466 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b2e:	00020497          	auipc	s1,0x20
    80005b32:	61248493          	addi	s1,s1,1554 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b36:	00020917          	auipc	s2,0x20
    80005b3a:	6a290913          	addi	s2,s2,1698 # 800261d8 <cons+0x98>
  while(n > 0){
    80005b3e:	0d305463          	blez	s3,80005c06 <consoleread+0x106>
    while(cons.r == cons.w){
    80005b42:	0984a783          	lw	a5,152(s1)
    80005b46:	09c4a703          	lw	a4,156(s1)
    80005b4a:	0af71963          	bne	a4,a5,80005bfc <consoleread+0xfc>
      if(myproc()->killed){
    80005b4e:	ffffb097          	auipc	ra,0xffffb
    80005b52:	4c6080e7          	jalr	1222(ra) # 80001014 <myproc>
    80005b56:	551c                	lw	a5,40(a0)
    80005b58:	e7ad                	bnez	a5,80005bc2 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005b5a:	85a6                	mv	a1,s1
    80005b5c:	854a                	mv	a0,s2
    80005b5e:	ffffc097          	auipc	ra,0xffffc
    80005b62:	c30080e7          	jalr	-976(ra) # 8000178e <sleep>
    while(cons.r == cons.w){
    80005b66:	0984a783          	lw	a5,152(s1)
    80005b6a:	09c4a703          	lw	a4,156(s1)
    80005b6e:	fef700e3          	beq	a4,a5,80005b4e <consoleread+0x4e>
    80005b72:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005b74:	00020717          	auipc	a4,0x20
    80005b78:	5cc70713          	addi	a4,a4,1484 # 80026140 <cons>
    80005b7c:	0017869b          	addiw	a3,a5,1
    80005b80:	08d72c23          	sw	a3,152(a4)
    80005b84:	07f7f693          	andi	a3,a5,127
    80005b88:	9736                	add	a4,a4,a3
    80005b8a:	01874703          	lbu	a4,24(a4)
    80005b8e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005b92:	4691                	li	a3,4
    80005b94:	04db8a63          	beq	s7,a3,80005be8 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b98:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b9c:	4685                	li	a3,1
    80005b9e:	faf40613          	addi	a2,s0,-81
    80005ba2:	85d2                	mv	a1,s4
    80005ba4:	8556                	mv	a0,s5
    80005ba6:	ffffc097          	auipc	ra,0xffffc
    80005baa:	f8c080e7          	jalr	-116(ra) # 80001b32 <either_copyout>
    80005bae:	57fd                	li	a5,-1
    80005bb0:	04f50a63          	beq	a0,a5,80005c04 <consoleread+0x104>
      break;

    dst++;
    80005bb4:	0a05                	addi	s4,s4,1
    --n;
    80005bb6:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005bb8:	47a9                	li	a5,10
    80005bba:	06fb8163          	beq	s7,a5,80005c1c <consoleread+0x11c>
    80005bbe:	6be2                	ld	s7,24(sp)
    80005bc0:	bfbd                	j	80005b3e <consoleread+0x3e>
        release(&cons.lock);
    80005bc2:	00020517          	auipc	a0,0x20
    80005bc6:	57e50513          	addi	a0,a0,1406 # 80026140 <cons>
    80005bca:	00001097          	auipc	ra,0x1
    80005bce:	950080e7          	jalr	-1712(ra) # 8000651a <release>
        return -1;
    80005bd2:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005bd4:	60e6                	ld	ra,88(sp)
    80005bd6:	6446                	ld	s0,80(sp)
    80005bd8:	64a6                	ld	s1,72(sp)
    80005bda:	6906                	ld	s2,64(sp)
    80005bdc:	79e2                	ld	s3,56(sp)
    80005bde:	7a42                	ld	s4,48(sp)
    80005be0:	7aa2                	ld	s5,40(sp)
    80005be2:	7b02                	ld	s6,32(sp)
    80005be4:	6125                	addi	sp,sp,96
    80005be6:	8082                	ret
      if(n < target){
    80005be8:	0009871b          	sext.w	a4,s3
    80005bec:	01677a63          	bgeu	a4,s6,80005c00 <consoleread+0x100>
        cons.r--;
    80005bf0:	00020717          	auipc	a4,0x20
    80005bf4:	5ef72423          	sw	a5,1512(a4) # 800261d8 <cons+0x98>
    80005bf8:	6be2                	ld	s7,24(sp)
    80005bfa:	a031                	j	80005c06 <consoleread+0x106>
    80005bfc:	ec5e                	sd	s7,24(sp)
    80005bfe:	bf9d                	j	80005b74 <consoleread+0x74>
    80005c00:	6be2                	ld	s7,24(sp)
    80005c02:	a011                	j	80005c06 <consoleread+0x106>
    80005c04:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005c06:	00020517          	auipc	a0,0x20
    80005c0a:	53a50513          	addi	a0,a0,1338 # 80026140 <cons>
    80005c0e:	00001097          	auipc	ra,0x1
    80005c12:	90c080e7          	jalr	-1780(ra) # 8000651a <release>
  return target - n;
    80005c16:	413b053b          	subw	a0,s6,s3
    80005c1a:	bf6d                	j	80005bd4 <consoleread+0xd4>
    80005c1c:	6be2                	ld	s7,24(sp)
    80005c1e:	b7e5                	j	80005c06 <consoleread+0x106>

0000000080005c20 <consputc>:
{
    80005c20:	1141                	addi	sp,sp,-16
    80005c22:	e406                	sd	ra,8(sp)
    80005c24:	e022                	sd	s0,0(sp)
    80005c26:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c28:	10000793          	li	a5,256
    80005c2c:	00f50a63          	beq	a0,a5,80005c40 <consputc+0x20>
    uartputc_sync(c);
    80005c30:	00000097          	auipc	ra,0x0
    80005c34:	59c080e7          	jalr	1436(ra) # 800061cc <uartputc_sync>
}
    80005c38:	60a2                	ld	ra,8(sp)
    80005c3a:	6402                	ld	s0,0(sp)
    80005c3c:	0141                	addi	sp,sp,16
    80005c3e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c40:	4521                	li	a0,8
    80005c42:	00000097          	auipc	ra,0x0
    80005c46:	58a080e7          	jalr	1418(ra) # 800061cc <uartputc_sync>
    80005c4a:	02000513          	li	a0,32
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	57e080e7          	jalr	1406(ra) # 800061cc <uartputc_sync>
    80005c56:	4521                	li	a0,8
    80005c58:	00000097          	auipc	ra,0x0
    80005c5c:	574080e7          	jalr	1396(ra) # 800061cc <uartputc_sync>
    80005c60:	bfe1                	j	80005c38 <consputc+0x18>

0000000080005c62 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c62:	1101                	addi	sp,sp,-32
    80005c64:	ec06                	sd	ra,24(sp)
    80005c66:	e822                	sd	s0,16(sp)
    80005c68:	e426                	sd	s1,8(sp)
    80005c6a:	1000                	addi	s0,sp,32
    80005c6c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c6e:	00020517          	auipc	a0,0x20
    80005c72:	4d250513          	addi	a0,a0,1234 # 80026140 <cons>
    80005c76:	00000097          	auipc	ra,0x0
    80005c7a:	7f0080e7          	jalr	2032(ra) # 80006466 <acquire>

  switch(c){
    80005c7e:	47d5                	li	a5,21
    80005c80:	0af48563          	beq	s1,a5,80005d2a <consoleintr+0xc8>
    80005c84:	0297c963          	blt	a5,s1,80005cb6 <consoleintr+0x54>
    80005c88:	47a1                	li	a5,8
    80005c8a:	0ef48c63          	beq	s1,a5,80005d82 <consoleintr+0x120>
    80005c8e:	47c1                	li	a5,16
    80005c90:	10f49f63          	bne	s1,a5,80005dae <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005c94:	ffffc097          	auipc	ra,0xffffc
    80005c98:	f4a080e7          	jalr	-182(ra) # 80001bde <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c9c:	00020517          	auipc	a0,0x20
    80005ca0:	4a450513          	addi	a0,a0,1188 # 80026140 <cons>
    80005ca4:	00001097          	auipc	ra,0x1
    80005ca8:	876080e7          	jalr	-1930(ra) # 8000651a <release>
}
    80005cac:	60e2                	ld	ra,24(sp)
    80005cae:	6442                	ld	s0,16(sp)
    80005cb0:	64a2                	ld	s1,8(sp)
    80005cb2:	6105                	addi	sp,sp,32
    80005cb4:	8082                	ret
  switch(c){
    80005cb6:	07f00793          	li	a5,127
    80005cba:	0cf48463          	beq	s1,a5,80005d82 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cbe:	00020717          	auipc	a4,0x20
    80005cc2:	48270713          	addi	a4,a4,1154 # 80026140 <cons>
    80005cc6:	0a072783          	lw	a5,160(a4)
    80005cca:	09872703          	lw	a4,152(a4)
    80005cce:	9f99                	subw	a5,a5,a4
    80005cd0:	07f00713          	li	a4,127
    80005cd4:	fcf764e3          	bltu	a4,a5,80005c9c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005cd8:	47b5                	li	a5,13
    80005cda:	0cf48d63          	beq	s1,a5,80005db4 <consoleintr+0x152>
      consputc(c);
    80005cde:	8526                	mv	a0,s1
    80005ce0:	00000097          	auipc	ra,0x0
    80005ce4:	f40080e7          	jalr	-192(ra) # 80005c20 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ce8:	00020797          	auipc	a5,0x20
    80005cec:	45878793          	addi	a5,a5,1112 # 80026140 <cons>
    80005cf0:	0a07a703          	lw	a4,160(a5)
    80005cf4:	0017069b          	addiw	a3,a4,1
    80005cf8:	0006861b          	sext.w	a2,a3
    80005cfc:	0ad7a023          	sw	a3,160(a5)
    80005d00:	07f77713          	andi	a4,a4,127
    80005d04:	97ba                	add	a5,a5,a4
    80005d06:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005d0a:	47a9                	li	a5,10
    80005d0c:	0cf48b63          	beq	s1,a5,80005de2 <consoleintr+0x180>
    80005d10:	4791                	li	a5,4
    80005d12:	0cf48863          	beq	s1,a5,80005de2 <consoleintr+0x180>
    80005d16:	00020797          	auipc	a5,0x20
    80005d1a:	4c27a783          	lw	a5,1218(a5) # 800261d8 <cons+0x98>
    80005d1e:	0807879b          	addiw	a5,a5,128
    80005d22:	f6f61de3          	bne	a2,a5,80005c9c <consoleintr+0x3a>
    80005d26:	863e                	mv	a2,a5
    80005d28:	a86d                	j	80005de2 <consoleintr+0x180>
    80005d2a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005d2c:	00020717          	auipc	a4,0x20
    80005d30:	41470713          	addi	a4,a4,1044 # 80026140 <cons>
    80005d34:	0a072783          	lw	a5,160(a4)
    80005d38:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d3c:	00020497          	auipc	s1,0x20
    80005d40:	40448493          	addi	s1,s1,1028 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005d44:	4929                	li	s2,10
    80005d46:	02f70a63          	beq	a4,a5,80005d7a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d4a:	37fd                	addiw	a5,a5,-1
    80005d4c:	07f7f713          	andi	a4,a5,127
    80005d50:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d52:	01874703          	lbu	a4,24(a4)
    80005d56:	03270463          	beq	a4,s2,80005d7e <consoleintr+0x11c>
      cons.e--;
    80005d5a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d5e:	10000513          	li	a0,256
    80005d62:	00000097          	auipc	ra,0x0
    80005d66:	ebe080e7          	jalr	-322(ra) # 80005c20 <consputc>
    while(cons.e != cons.w &&
    80005d6a:	0a04a783          	lw	a5,160(s1)
    80005d6e:	09c4a703          	lw	a4,156(s1)
    80005d72:	fcf71ce3          	bne	a4,a5,80005d4a <consoleintr+0xe8>
    80005d76:	6902                	ld	s2,0(sp)
    80005d78:	b715                	j	80005c9c <consoleintr+0x3a>
    80005d7a:	6902                	ld	s2,0(sp)
    80005d7c:	b705                	j	80005c9c <consoleintr+0x3a>
    80005d7e:	6902                	ld	s2,0(sp)
    80005d80:	bf31                	j	80005c9c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005d82:	00020717          	auipc	a4,0x20
    80005d86:	3be70713          	addi	a4,a4,958 # 80026140 <cons>
    80005d8a:	0a072783          	lw	a5,160(a4)
    80005d8e:	09c72703          	lw	a4,156(a4)
    80005d92:	f0f705e3          	beq	a4,a5,80005c9c <consoleintr+0x3a>
      cons.e--;
    80005d96:	37fd                	addiw	a5,a5,-1
    80005d98:	00020717          	auipc	a4,0x20
    80005d9c:	44f72423          	sw	a5,1096(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005da0:	10000513          	li	a0,256
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	e7c080e7          	jalr	-388(ra) # 80005c20 <consputc>
    80005dac:	bdc5                	j	80005c9c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005dae:	ee0487e3          	beqz	s1,80005c9c <consoleintr+0x3a>
    80005db2:	b731                	j	80005cbe <consoleintr+0x5c>
      consputc(c);
    80005db4:	4529                	li	a0,10
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	e6a080e7          	jalr	-406(ra) # 80005c20 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005dbe:	00020797          	auipc	a5,0x20
    80005dc2:	38278793          	addi	a5,a5,898 # 80026140 <cons>
    80005dc6:	0a07a703          	lw	a4,160(a5)
    80005dca:	0017069b          	addiw	a3,a4,1
    80005dce:	0006861b          	sext.w	a2,a3
    80005dd2:	0ad7a023          	sw	a3,160(a5)
    80005dd6:	07f77713          	andi	a4,a4,127
    80005dda:	97ba                	add	a5,a5,a4
    80005ddc:	4729                	li	a4,10
    80005dde:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005de2:	00020797          	auipc	a5,0x20
    80005de6:	3ec7ad23          	sw	a2,1018(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005dea:	00020517          	auipc	a0,0x20
    80005dee:	3ee50513          	addi	a0,a0,1006 # 800261d8 <cons+0x98>
    80005df2:	ffffc097          	auipc	ra,0xffffc
    80005df6:	b28080e7          	jalr	-1240(ra) # 8000191a <wakeup>
    80005dfa:	b54d                	j	80005c9c <consoleintr+0x3a>

0000000080005dfc <consoleinit>:

void
consoleinit(void)
{
    80005dfc:	1141                	addi	sp,sp,-16
    80005dfe:	e406                	sd	ra,8(sp)
    80005e00:	e022                	sd	s0,0(sp)
    80005e02:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e04:	00003597          	auipc	a1,0x3
    80005e08:	8f458593          	addi	a1,a1,-1804 # 800086f8 <etext+0x6f8>
    80005e0c:	00020517          	auipc	a0,0x20
    80005e10:	33450513          	addi	a0,a0,820 # 80026140 <cons>
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	5c2080e7          	jalr	1474(ra) # 800063d6 <initlock>

  uartinit();
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	354080e7          	jalr	852(ra) # 80006170 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e24:	00013797          	auipc	a5,0x13
    80005e28:	4a478793          	addi	a5,a5,1188 # 800192c8 <devsw>
    80005e2c:	00000717          	auipc	a4,0x0
    80005e30:	cd470713          	addi	a4,a4,-812 # 80005b00 <consoleread>
    80005e34:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e36:	00000717          	auipc	a4,0x0
    80005e3a:	c5c70713          	addi	a4,a4,-932 # 80005a92 <consolewrite>
    80005e3e:	ef98                	sd	a4,24(a5)
}
    80005e40:	60a2                	ld	ra,8(sp)
    80005e42:	6402                	ld	s0,0(sp)
    80005e44:	0141                	addi	sp,sp,16
    80005e46:	8082                	ret

0000000080005e48 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e48:	7179                	addi	sp,sp,-48
    80005e4a:	f406                	sd	ra,40(sp)
    80005e4c:	f022                	sd	s0,32(sp)
    80005e4e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e50:	c219                	beqz	a2,80005e56 <printint+0xe>
    80005e52:	08054963          	bltz	a0,80005ee4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e56:	2501                	sext.w	a0,a0
    80005e58:	4881                	li	a7,0
    80005e5a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e5e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e60:	2581                	sext.w	a1,a1
    80005e62:	00003617          	auipc	a2,0x3
    80005e66:	a3e60613          	addi	a2,a2,-1474 # 800088a0 <digits>
    80005e6a:	883a                	mv	a6,a4
    80005e6c:	2705                	addiw	a4,a4,1
    80005e6e:	02b577bb          	remuw	a5,a0,a1
    80005e72:	1782                	slli	a5,a5,0x20
    80005e74:	9381                	srli	a5,a5,0x20
    80005e76:	97b2                	add	a5,a5,a2
    80005e78:	0007c783          	lbu	a5,0(a5)
    80005e7c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e80:	0005079b          	sext.w	a5,a0
    80005e84:	02b5553b          	divuw	a0,a0,a1
    80005e88:	0685                	addi	a3,a3,1
    80005e8a:	feb7f0e3          	bgeu	a5,a1,80005e6a <printint+0x22>

  if(sign)
    80005e8e:	00088c63          	beqz	a7,80005ea6 <printint+0x5e>
    buf[i++] = '-';
    80005e92:	fe070793          	addi	a5,a4,-32
    80005e96:	00878733          	add	a4,a5,s0
    80005e9a:	02d00793          	li	a5,45
    80005e9e:	fef70823          	sb	a5,-16(a4)
    80005ea2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ea6:	02e05b63          	blez	a4,80005edc <printint+0x94>
    80005eaa:	ec26                	sd	s1,24(sp)
    80005eac:	e84a                	sd	s2,16(sp)
    80005eae:	fd040793          	addi	a5,s0,-48
    80005eb2:	00e784b3          	add	s1,a5,a4
    80005eb6:	fff78913          	addi	s2,a5,-1
    80005eba:	993a                	add	s2,s2,a4
    80005ebc:	377d                	addiw	a4,a4,-1
    80005ebe:	1702                	slli	a4,a4,0x20
    80005ec0:	9301                	srli	a4,a4,0x20
    80005ec2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005ec6:	fff4c503          	lbu	a0,-1(s1)
    80005eca:	00000097          	auipc	ra,0x0
    80005ece:	d56080e7          	jalr	-682(ra) # 80005c20 <consputc>
  while(--i >= 0)
    80005ed2:	14fd                	addi	s1,s1,-1
    80005ed4:	ff2499e3          	bne	s1,s2,80005ec6 <printint+0x7e>
    80005ed8:	64e2                	ld	s1,24(sp)
    80005eda:	6942                	ld	s2,16(sp)
}
    80005edc:	70a2                	ld	ra,40(sp)
    80005ede:	7402                	ld	s0,32(sp)
    80005ee0:	6145                	addi	sp,sp,48
    80005ee2:	8082                	ret
    x = -xx;
    80005ee4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ee8:	4885                	li	a7,1
    x = -xx;
    80005eea:	bf85                	j	80005e5a <printint+0x12>

0000000080005eec <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005eec:	1101                	addi	sp,sp,-32
    80005eee:	ec06                	sd	ra,24(sp)
    80005ef0:	e822                	sd	s0,16(sp)
    80005ef2:	e426                	sd	s1,8(sp)
    80005ef4:	1000                	addi	s0,sp,32
    80005ef6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ef8:	00020797          	auipc	a5,0x20
    80005efc:	3007a423          	sw	zero,776(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005f00:	00003517          	auipc	a0,0x3
    80005f04:	80050513          	addi	a0,a0,-2048 # 80008700 <etext+0x700>
    80005f08:	00000097          	auipc	ra,0x0
    80005f0c:	02e080e7          	jalr	46(ra) # 80005f36 <printf>
  printf(s);
    80005f10:	8526                	mv	a0,s1
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	024080e7          	jalr	36(ra) # 80005f36 <printf>
  printf("\n");
    80005f1a:	00002517          	auipc	a0,0x2
    80005f1e:	0fe50513          	addi	a0,a0,254 # 80008018 <etext+0x18>
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	014080e7          	jalr	20(ra) # 80005f36 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f2a:	4785                	li	a5,1
    80005f2c:	00003717          	auipc	a4,0x3
    80005f30:	0ef72823          	sw	a5,240(a4) # 8000901c <panicked>
  for(;;)
    80005f34:	a001                	j	80005f34 <panic+0x48>

0000000080005f36 <printf>:
{
    80005f36:	7131                	addi	sp,sp,-192
    80005f38:	fc86                	sd	ra,120(sp)
    80005f3a:	f8a2                	sd	s0,112(sp)
    80005f3c:	e8d2                	sd	s4,80(sp)
    80005f3e:	f06a                	sd	s10,32(sp)
    80005f40:	0100                	addi	s0,sp,128
    80005f42:	8a2a                	mv	s4,a0
    80005f44:	e40c                	sd	a1,8(s0)
    80005f46:	e810                	sd	a2,16(s0)
    80005f48:	ec14                	sd	a3,24(s0)
    80005f4a:	f018                	sd	a4,32(s0)
    80005f4c:	f41c                	sd	a5,40(s0)
    80005f4e:	03043823          	sd	a6,48(s0)
    80005f52:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f56:	00020d17          	auipc	s10,0x20
    80005f5a:	2aad2d03          	lw	s10,682(s10) # 80026200 <pr+0x18>
  if(locking)
    80005f5e:	040d1463          	bnez	s10,80005fa6 <printf+0x70>
  if (fmt == 0)
    80005f62:	040a0b63          	beqz	s4,80005fb8 <printf+0x82>
  va_start(ap, fmt);
    80005f66:	00840793          	addi	a5,s0,8
    80005f6a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f6e:	000a4503          	lbu	a0,0(s4)
    80005f72:	18050b63          	beqz	a0,80006108 <printf+0x1d2>
    80005f76:	f4a6                	sd	s1,104(sp)
    80005f78:	f0ca                	sd	s2,96(sp)
    80005f7a:	ecce                	sd	s3,88(sp)
    80005f7c:	e4d6                	sd	s5,72(sp)
    80005f7e:	e0da                	sd	s6,64(sp)
    80005f80:	fc5e                	sd	s7,56(sp)
    80005f82:	f862                	sd	s8,48(sp)
    80005f84:	f466                	sd	s9,40(sp)
    80005f86:	ec6e                	sd	s11,24(sp)
    80005f88:	4981                	li	s3,0
    if(c != '%'){
    80005f8a:	02500b13          	li	s6,37
    switch(c){
    80005f8e:	07000b93          	li	s7,112
  consputc('x');
    80005f92:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f94:	00003a97          	auipc	s5,0x3
    80005f98:	90ca8a93          	addi	s5,s5,-1780 # 800088a0 <digits>
    switch(c){
    80005f9c:	07300c13          	li	s8,115
    80005fa0:	06400d93          	li	s11,100
    80005fa4:	a0b1                	j	80005ff0 <printf+0xba>
    acquire(&pr.lock);
    80005fa6:	00020517          	auipc	a0,0x20
    80005faa:	24250513          	addi	a0,a0,578 # 800261e8 <pr>
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	4b8080e7          	jalr	1208(ra) # 80006466 <acquire>
    80005fb6:	b775                	j	80005f62 <printf+0x2c>
    80005fb8:	f4a6                	sd	s1,104(sp)
    80005fba:	f0ca                	sd	s2,96(sp)
    80005fbc:	ecce                	sd	s3,88(sp)
    80005fbe:	e4d6                	sd	s5,72(sp)
    80005fc0:	e0da                	sd	s6,64(sp)
    80005fc2:	fc5e                	sd	s7,56(sp)
    80005fc4:	f862                	sd	s8,48(sp)
    80005fc6:	f466                	sd	s9,40(sp)
    80005fc8:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005fca:	00002517          	auipc	a0,0x2
    80005fce:	74650513          	addi	a0,a0,1862 # 80008710 <etext+0x710>
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	f1a080e7          	jalr	-230(ra) # 80005eec <panic>
      consputc(c);
    80005fda:	00000097          	auipc	ra,0x0
    80005fde:	c46080e7          	jalr	-954(ra) # 80005c20 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fe2:	2985                	addiw	s3,s3,1
    80005fe4:	013a07b3          	add	a5,s4,s3
    80005fe8:	0007c503          	lbu	a0,0(a5)
    80005fec:	10050563          	beqz	a0,800060f6 <printf+0x1c0>
    if(c != '%'){
    80005ff0:	ff6515e3          	bne	a0,s6,80005fda <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005ff4:	2985                	addiw	s3,s3,1
    80005ff6:	013a07b3          	add	a5,s4,s3
    80005ffa:	0007c783          	lbu	a5,0(a5)
    80005ffe:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006002:	10078b63          	beqz	a5,80006118 <printf+0x1e2>
    switch(c){
    80006006:	05778a63          	beq	a5,s7,8000605a <printf+0x124>
    8000600a:	02fbf663          	bgeu	s7,a5,80006036 <printf+0x100>
    8000600e:	09878863          	beq	a5,s8,8000609e <printf+0x168>
    80006012:	07800713          	li	a4,120
    80006016:	0ce79563          	bne	a5,a4,800060e0 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000601a:	f8843783          	ld	a5,-120(s0)
    8000601e:	00878713          	addi	a4,a5,8
    80006022:	f8e43423          	sd	a4,-120(s0)
    80006026:	4605                	li	a2,1
    80006028:	85e6                	mv	a1,s9
    8000602a:	4388                	lw	a0,0(a5)
    8000602c:	00000097          	auipc	ra,0x0
    80006030:	e1c080e7          	jalr	-484(ra) # 80005e48 <printint>
      break;
    80006034:	b77d                	j	80005fe2 <printf+0xac>
    switch(c){
    80006036:	09678f63          	beq	a5,s6,800060d4 <printf+0x19e>
    8000603a:	0bb79363          	bne	a5,s11,800060e0 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    8000603e:	f8843783          	ld	a5,-120(s0)
    80006042:	00878713          	addi	a4,a5,8
    80006046:	f8e43423          	sd	a4,-120(s0)
    8000604a:	4605                	li	a2,1
    8000604c:	45a9                	li	a1,10
    8000604e:	4388                	lw	a0,0(a5)
    80006050:	00000097          	auipc	ra,0x0
    80006054:	df8080e7          	jalr	-520(ra) # 80005e48 <printint>
      break;
    80006058:	b769                	j	80005fe2 <printf+0xac>
      printptr(va_arg(ap, uint64));
    8000605a:	f8843783          	ld	a5,-120(s0)
    8000605e:	00878713          	addi	a4,a5,8
    80006062:	f8e43423          	sd	a4,-120(s0)
    80006066:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000606a:	03000513          	li	a0,48
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	bb2080e7          	jalr	-1102(ra) # 80005c20 <consputc>
  consputc('x');
    80006076:	07800513          	li	a0,120
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	ba6080e7          	jalr	-1114(ra) # 80005c20 <consputc>
    80006082:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006084:	03c95793          	srli	a5,s2,0x3c
    80006088:	97d6                	add	a5,a5,s5
    8000608a:	0007c503          	lbu	a0,0(a5)
    8000608e:	00000097          	auipc	ra,0x0
    80006092:	b92080e7          	jalr	-1134(ra) # 80005c20 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006096:	0912                	slli	s2,s2,0x4
    80006098:	34fd                	addiw	s1,s1,-1
    8000609a:	f4ed                	bnez	s1,80006084 <printf+0x14e>
    8000609c:	b799                	j	80005fe2 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000609e:	f8843783          	ld	a5,-120(s0)
    800060a2:	00878713          	addi	a4,a5,8
    800060a6:	f8e43423          	sd	a4,-120(s0)
    800060aa:	6384                	ld	s1,0(a5)
    800060ac:	cc89                	beqz	s1,800060c6 <printf+0x190>
      for(; *s; s++)
    800060ae:	0004c503          	lbu	a0,0(s1)
    800060b2:	d905                	beqz	a0,80005fe2 <printf+0xac>
        consputc(*s);
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	b6c080e7          	jalr	-1172(ra) # 80005c20 <consputc>
      for(; *s; s++)
    800060bc:	0485                	addi	s1,s1,1
    800060be:	0004c503          	lbu	a0,0(s1)
    800060c2:	f96d                	bnez	a0,800060b4 <printf+0x17e>
    800060c4:	bf39                	j	80005fe2 <printf+0xac>
        s = "(null)";
    800060c6:	00002497          	auipc	s1,0x2
    800060ca:	64248493          	addi	s1,s1,1602 # 80008708 <etext+0x708>
      for(; *s; s++)
    800060ce:	02800513          	li	a0,40
    800060d2:	b7cd                	j	800060b4 <printf+0x17e>
      consputc('%');
    800060d4:	855a                	mv	a0,s6
    800060d6:	00000097          	auipc	ra,0x0
    800060da:	b4a080e7          	jalr	-1206(ra) # 80005c20 <consputc>
      break;
    800060de:	b711                	j	80005fe2 <printf+0xac>
      consputc('%');
    800060e0:	855a                	mv	a0,s6
    800060e2:	00000097          	auipc	ra,0x0
    800060e6:	b3e080e7          	jalr	-1218(ra) # 80005c20 <consputc>
      consputc(c);
    800060ea:	8526                	mv	a0,s1
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	b34080e7          	jalr	-1228(ra) # 80005c20 <consputc>
      break;
    800060f4:	b5fd                	j	80005fe2 <printf+0xac>
    800060f6:	74a6                	ld	s1,104(sp)
    800060f8:	7906                	ld	s2,96(sp)
    800060fa:	69e6                	ld	s3,88(sp)
    800060fc:	6aa6                	ld	s5,72(sp)
    800060fe:	6b06                	ld	s6,64(sp)
    80006100:	7be2                	ld	s7,56(sp)
    80006102:	7c42                	ld	s8,48(sp)
    80006104:	7ca2                	ld	s9,40(sp)
    80006106:	6de2                	ld	s11,24(sp)
  if(locking)
    80006108:	020d1263          	bnez	s10,8000612c <printf+0x1f6>
}
    8000610c:	70e6                	ld	ra,120(sp)
    8000610e:	7446                	ld	s0,112(sp)
    80006110:	6a46                	ld	s4,80(sp)
    80006112:	7d02                	ld	s10,32(sp)
    80006114:	6129                	addi	sp,sp,192
    80006116:	8082                	ret
    80006118:	74a6                	ld	s1,104(sp)
    8000611a:	7906                	ld	s2,96(sp)
    8000611c:	69e6                	ld	s3,88(sp)
    8000611e:	6aa6                	ld	s5,72(sp)
    80006120:	6b06                	ld	s6,64(sp)
    80006122:	7be2                	ld	s7,56(sp)
    80006124:	7c42                	ld	s8,48(sp)
    80006126:	7ca2                	ld	s9,40(sp)
    80006128:	6de2                	ld	s11,24(sp)
    8000612a:	bff9                	j	80006108 <printf+0x1d2>
    release(&pr.lock);
    8000612c:	00020517          	auipc	a0,0x20
    80006130:	0bc50513          	addi	a0,a0,188 # 800261e8 <pr>
    80006134:	00000097          	auipc	ra,0x0
    80006138:	3e6080e7          	jalr	998(ra) # 8000651a <release>
}
    8000613c:	bfc1                	j	8000610c <printf+0x1d6>

000000008000613e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000613e:	1101                	addi	sp,sp,-32
    80006140:	ec06                	sd	ra,24(sp)
    80006142:	e822                	sd	s0,16(sp)
    80006144:	e426                	sd	s1,8(sp)
    80006146:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006148:	00020497          	auipc	s1,0x20
    8000614c:	0a048493          	addi	s1,s1,160 # 800261e8 <pr>
    80006150:	00002597          	auipc	a1,0x2
    80006154:	5d058593          	addi	a1,a1,1488 # 80008720 <etext+0x720>
    80006158:	8526                	mv	a0,s1
    8000615a:	00000097          	auipc	ra,0x0
    8000615e:	27c080e7          	jalr	636(ra) # 800063d6 <initlock>
  pr.locking = 1;
    80006162:	4785                	li	a5,1
    80006164:	cc9c                	sw	a5,24(s1)
}
    80006166:	60e2                	ld	ra,24(sp)
    80006168:	6442                	ld	s0,16(sp)
    8000616a:	64a2                	ld	s1,8(sp)
    8000616c:	6105                	addi	sp,sp,32
    8000616e:	8082                	ret

0000000080006170 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006170:	1141                	addi	sp,sp,-16
    80006172:	e406                	sd	ra,8(sp)
    80006174:	e022                	sd	s0,0(sp)
    80006176:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006178:	100007b7          	lui	a5,0x10000
    8000617c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006180:	10000737          	lui	a4,0x10000
    80006184:	f8000693          	li	a3,-128
    80006188:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000618c:	468d                	li	a3,3
    8000618e:	10000637          	lui	a2,0x10000
    80006192:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006196:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000619a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000619e:	10000737          	lui	a4,0x10000
    800061a2:	461d                	li	a2,7
    800061a4:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800061a8:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800061ac:	00002597          	auipc	a1,0x2
    800061b0:	57c58593          	addi	a1,a1,1404 # 80008728 <etext+0x728>
    800061b4:	00020517          	auipc	a0,0x20
    800061b8:	05450513          	addi	a0,a0,84 # 80026208 <uart_tx_lock>
    800061bc:	00000097          	auipc	ra,0x0
    800061c0:	21a080e7          	jalr	538(ra) # 800063d6 <initlock>
}
    800061c4:	60a2                	ld	ra,8(sp)
    800061c6:	6402                	ld	s0,0(sp)
    800061c8:	0141                	addi	sp,sp,16
    800061ca:	8082                	ret

00000000800061cc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800061cc:	1101                	addi	sp,sp,-32
    800061ce:	ec06                	sd	ra,24(sp)
    800061d0:	e822                	sd	s0,16(sp)
    800061d2:	e426                	sd	s1,8(sp)
    800061d4:	1000                	addi	s0,sp,32
    800061d6:	84aa                	mv	s1,a0
  push_off();
    800061d8:	00000097          	auipc	ra,0x0
    800061dc:	242080e7          	jalr	578(ra) # 8000641a <push_off>

  if(panicked){
    800061e0:	00003797          	auipc	a5,0x3
    800061e4:	e3c7a783          	lw	a5,-452(a5) # 8000901c <panicked>
    800061e8:	eb85                	bnez	a5,80006218 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061ea:	10000737          	lui	a4,0x10000
    800061ee:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800061f0:	00074783          	lbu	a5,0(a4)
    800061f4:	0207f793          	andi	a5,a5,32
    800061f8:	dfe5                	beqz	a5,800061f0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800061fa:	0ff4f513          	zext.b	a0,s1
    800061fe:	100007b7          	lui	a5,0x10000
    80006202:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006206:	00000097          	auipc	ra,0x0
    8000620a:	2b4080e7          	jalr	692(ra) # 800064ba <pop_off>
}
    8000620e:	60e2                	ld	ra,24(sp)
    80006210:	6442                	ld	s0,16(sp)
    80006212:	64a2                	ld	s1,8(sp)
    80006214:	6105                	addi	sp,sp,32
    80006216:	8082                	ret
    for(;;)
    80006218:	a001                	j	80006218 <uartputc_sync+0x4c>

000000008000621a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000621a:	00003797          	auipc	a5,0x3
    8000621e:	e067b783          	ld	a5,-506(a5) # 80009020 <uart_tx_r>
    80006222:	00003717          	auipc	a4,0x3
    80006226:	e0673703          	ld	a4,-506(a4) # 80009028 <uart_tx_w>
    8000622a:	06f70f63          	beq	a4,a5,800062a8 <uartstart+0x8e>
{
    8000622e:	7139                	addi	sp,sp,-64
    80006230:	fc06                	sd	ra,56(sp)
    80006232:	f822                	sd	s0,48(sp)
    80006234:	f426                	sd	s1,40(sp)
    80006236:	f04a                	sd	s2,32(sp)
    80006238:	ec4e                	sd	s3,24(sp)
    8000623a:	e852                	sd	s4,16(sp)
    8000623c:	e456                	sd	s5,8(sp)
    8000623e:	e05a                	sd	s6,0(sp)
    80006240:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006242:	10000937          	lui	s2,0x10000
    80006246:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006248:	00020a97          	auipc	s5,0x20
    8000624c:	fc0a8a93          	addi	s5,s5,-64 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80006250:	00003497          	auipc	s1,0x3
    80006254:	dd048493          	addi	s1,s1,-560 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006258:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000625c:	00003997          	auipc	s3,0x3
    80006260:	dcc98993          	addi	s3,s3,-564 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006264:	00094703          	lbu	a4,0(s2)
    80006268:	02077713          	andi	a4,a4,32
    8000626c:	c705                	beqz	a4,80006294 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000626e:	01f7f713          	andi	a4,a5,31
    80006272:	9756                	add	a4,a4,s5
    80006274:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006278:	0785                	addi	a5,a5,1
    8000627a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000627c:	8526                	mv	a0,s1
    8000627e:	ffffb097          	auipc	ra,0xffffb
    80006282:	69c080e7          	jalr	1692(ra) # 8000191a <wakeup>
    WriteReg(THR, c);
    80006286:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000628a:	609c                	ld	a5,0(s1)
    8000628c:	0009b703          	ld	a4,0(s3)
    80006290:	fcf71ae3          	bne	a4,a5,80006264 <uartstart+0x4a>
  }
}
    80006294:	70e2                	ld	ra,56(sp)
    80006296:	7442                	ld	s0,48(sp)
    80006298:	74a2                	ld	s1,40(sp)
    8000629a:	7902                	ld	s2,32(sp)
    8000629c:	69e2                	ld	s3,24(sp)
    8000629e:	6a42                	ld	s4,16(sp)
    800062a0:	6aa2                	ld	s5,8(sp)
    800062a2:	6b02                	ld	s6,0(sp)
    800062a4:	6121                	addi	sp,sp,64
    800062a6:	8082                	ret
    800062a8:	8082                	ret

00000000800062aa <uartputc>:
{
    800062aa:	7179                	addi	sp,sp,-48
    800062ac:	f406                	sd	ra,40(sp)
    800062ae:	f022                	sd	s0,32(sp)
    800062b0:	e052                	sd	s4,0(sp)
    800062b2:	1800                	addi	s0,sp,48
    800062b4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800062b6:	00020517          	auipc	a0,0x20
    800062ba:	f5250513          	addi	a0,a0,-174 # 80026208 <uart_tx_lock>
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	1a8080e7          	jalr	424(ra) # 80006466 <acquire>
  if(panicked){
    800062c6:	00003797          	auipc	a5,0x3
    800062ca:	d567a783          	lw	a5,-682(a5) # 8000901c <panicked>
    800062ce:	c391                	beqz	a5,800062d2 <uartputc+0x28>
    for(;;)
    800062d0:	a001                	j	800062d0 <uartputc+0x26>
    800062d2:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062d4:	00003717          	auipc	a4,0x3
    800062d8:	d5473703          	ld	a4,-684(a4) # 80009028 <uart_tx_w>
    800062dc:	00003797          	auipc	a5,0x3
    800062e0:	d447b783          	ld	a5,-700(a5) # 80009020 <uart_tx_r>
    800062e4:	02078793          	addi	a5,a5,32
    800062e8:	02e79f63          	bne	a5,a4,80006326 <uartputc+0x7c>
    800062ec:	e84a                	sd	s2,16(sp)
    800062ee:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800062f0:	00020997          	auipc	s3,0x20
    800062f4:	f1898993          	addi	s3,s3,-232 # 80026208 <uart_tx_lock>
    800062f8:	00003497          	auipc	s1,0x3
    800062fc:	d2848493          	addi	s1,s1,-728 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006300:	00003917          	auipc	s2,0x3
    80006304:	d2890913          	addi	s2,s2,-728 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006308:	85ce                	mv	a1,s3
    8000630a:	8526                	mv	a0,s1
    8000630c:	ffffb097          	auipc	ra,0xffffb
    80006310:	482080e7          	jalr	1154(ra) # 8000178e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006314:	00093703          	ld	a4,0(s2)
    80006318:	609c                	ld	a5,0(s1)
    8000631a:	02078793          	addi	a5,a5,32
    8000631e:	fee785e3          	beq	a5,a4,80006308 <uartputc+0x5e>
    80006322:	6942                	ld	s2,16(sp)
    80006324:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006326:	00020497          	auipc	s1,0x20
    8000632a:	ee248493          	addi	s1,s1,-286 # 80026208 <uart_tx_lock>
    8000632e:	01f77793          	andi	a5,a4,31
    80006332:	97a6                	add	a5,a5,s1
    80006334:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006338:	0705                	addi	a4,a4,1
    8000633a:	00003797          	auipc	a5,0x3
    8000633e:	cee7b723          	sd	a4,-786(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006342:	00000097          	auipc	ra,0x0
    80006346:	ed8080e7          	jalr	-296(ra) # 8000621a <uartstart>
      release(&uart_tx_lock);
    8000634a:	8526                	mv	a0,s1
    8000634c:	00000097          	auipc	ra,0x0
    80006350:	1ce080e7          	jalr	462(ra) # 8000651a <release>
    80006354:	64e2                	ld	s1,24(sp)
}
    80006356:	70a2                	ld	ra,40(sp)
    80006358:	7402                	ld	s0,32(sp)
    8000635a:	6a02                	ld	s4,0(sp)
    8000635c:	6145                	addi	sp,sp,48
    8000635e:	8082                	ret

0000000080006360 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006360:	1141                	addi	sp,sp,-16
    80006362:	e422                	sd	s0,8(sp)
    80006364:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006366:	100007b7          	lui	a5,0x10000
    8000636a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000636c:	0007c783          	lbu	a5,0(a5)
    80006370:	8b85                	andi	a5,a5,1
    80006372:	cb81                	beqz	a5,80006382 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006374:	100007b7          	lui	a5,0x10000
    80006378:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000637c:	6422                	ld	s0,8(sp)
    8000637e:	0141                	addi	sp,sp,16
    80006380:	8082                	ret
    return -1;
    80006382:	557d                	li	a0,-1
    80006384:	bfe5                	j	8000637c <uartgetc+0x1c>

0000000080006386 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006386:	1101                	addi	sp,sp,-32
    80006388:	ec06                	sd	ra,24(sp)
    8000638a:	e822                	sd	s0,16(sp)
    8000638c:	e426                	sd	s1,8(sp)
    8000638e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006390:	54fd                	li	s1,-1
    80006392:	a029                	j	8000639c <uartintr+0x16>
      break;
    consoleintr(c);
    80006394:	00000097          	auipc	ra,0x0
    80006398:	8ce080e7          	jalr	-1842(ra) # 80005c62 <consoleintr>
    int c = uartgetc();
    8000639c:	00000097          	auipc	ra,0x0
    800063a0:	fc4080e7          	jalr	-60(ra) # 80006360 <uartgetc>
    if(c == -1)
    800063a4:	fe9518e3          	bne	a0,s1,80006394 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800063a8:	00020497          	auipc	s1,0x20
    800063ac:	e6048493          	addi	s1,s1,-416 # 80026208 <uart_tx_lock>
    800063b0:	8526                	mv	a0,s1
    800063b2:	00000097          	auipc	ra,0x0
    800063b6:	0b4080e7          	jalr	180(ra) # 80006466 <acquire>
  uartstart();
    800063ba:	00000097          	auipc	ra,0x0
    800063be:	e60080e7          	jalr	-416(ra) # 8000621a <uartstart>
  release(&uart_tx_lock);
    800063c2:	8526                	mv	a0,s1
    800063c4:	00000097          	auipc	ra,0x0
    800063c8:	156080e7          	jalr	342(ra) # 8000651a <release>
}
    800063cc:	60e2                	ld	ra,24(sp)
    800063ce:	6442                	ld	s0,16(sp)
    800063d0:	64a2                	ld	s1,8(sp)
    800063d2:	6105                	addi	sp,sp,32
    800063d4:	8082                	ret

00000000800063d6 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800063d6:	1141                	addi	sp,sp,-16
    800063d8:	e422                	sd	s0,8(sp)
    800063da:	0800                	addi	s0,sp,16
  lk->name = name;
    800063dc:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800063de:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800063e2:	00053823          	sd	zero,16(a0)
}
    800063e6:	6422                	ld	s0,8(sp)
    800063e8:	0141                	addi	sp,sp,16
    800063ea:	8082                	ret

00000000800063ec <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800063ec:	411c                	lw	a5,0(a0)
    800063ee:	e399                	bnez	a5,800063f4 <holding+0x8>
    800063f0:	4501                	li	a0,0
  return r;
}
    800063f2:	8082                	ret
{
    800063f4:	1101                	addi	sp,sp,-32
    800063f6:	ec06                	sd	ra,24(sp)
    800063f8:	e822                	sd	s0,16(sp)
    800063fa:	e426                	sd	s1,8(sp)
    800063fc:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063fe:	6904                	ld	s1,16(a0)
    80006400:	ffffb097          	auipc	ra,0xffffb
    80006404:	bf8080e7          	jalr	-1032(ra) # 80000ff8 <mycpu>
    80006408:	40a48533          	sub	a0,s1,a0
    8000640c:	00153513          	seqz	a0,a0
}
    80006410:	60e2                	ld	ra,24(sp)
    80006412:	6442                	ld	s0,16(sp)
    80006414:	64a2                	ld	s1,8(sp)
    80006416:	6105                	addi	sp,sp,32
    80006418:	8082                	ret

000000008000641a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000641a:	1101                	addi	sp,sp,-32
    8000641c:	ec06                	sd	ra,24(sp)
    8000641e:	e822                	sd	s0,16(sp)
    80006420:	e426                	sd	s1,8(sp)
    80006422:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006424:	100024f3          	csrr	s1,sstatus
    80006428:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000642c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000642e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006432:	ffffb097          	auipc	ra,0xffffb
    80006436:	bc6080e7          	jalr	-1082(ra) # 80000ff8 <mycpu>
    8000643a:	5d3c                	lw	a5,120(a0)
    8000643c:	cf89                	beqz	a5,80006456 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000643e:	ffffb097          	auipc	ra,0xffffb
    80006442:	bba080e7          	jalr	-1094(ra) # 80000ff8 <mycpu>
    80006446:	5d3c                	lw	a5,120(a0)
    80006448:	2785                	addiw	a5,a5,1
    8000644a:	dd3c                	sw	a5,120(a0)
}
    8000644c:	60e2                	ld	ra,24(sp)
    8000644e:	6442                	ld	s0,16(sp)
    80006450:	64a2                	ld	s1,8(sp)
    80006452:	6105                	addi	sp,sp,32
    80006454:	8082                	ret
    mycpu()->intena = old;
    80006456:	ffffb097          	auipc	ra,0xffffb
    8000645a:	ba2080e7          	jalr	-1118(ra) # 80000ff8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000645e:	8085                	srli	s1,s1,0x1
    80006460:	8885                	andi	s1,s1,1
    80006462:	dd64                	sw	s1,124(a0)
    80006464:	bfe9                	j	8000643e <push_off+0x24>

0000000080006466 <acquire>:
{
    80006466:	1101                	addi	sp,sp,-32
    80006468:	ec06                	sd	ra,24(sp)
    8000646a:	e822                	sd	s0,16(sp)
    8000646c:	e426                	sd	s1,8(sp)
    8000646e:	1000                	addi	s0,sp,32
    80006470:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006472:	00000097          	auipc	ra,0x0
    80006476:	fa8080e7          	jalr	-88(ra) # 8000641a <push_off>
  if(holding(lk))
    8000647a:	8526                	mv	a0,s1
    8000647c:	00000097          	auipc	ra,0x0
    80006480:	f70080e7          	jalr	-144(ra) # 800063ec <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006484:	4705                	li	a4,1
  if(holding(lk))
    80006486:	e115                	bnez	a0,800064aa <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006488:	87ba                	mv	a5,a4
    8000648a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000648e:	2781                	sext.w	a5,a5
    80006490:	ffe5                	bnez	a5,80006488 <acquire+0x22>
  __sync_synchronize();
    80006492:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006496:	ffffb097          	auipc	ra,0xffffb
    8000649a:	b62080e7          	jalr	-1182(ra) # 80000ff8 <mycpu>
    8000649e:	e888                	sd	a0,16(s1)
}
    800064a0:	60e2                	ld	ra,24(sp)
    800064a2:	6442                	ld	s0,16(sp)
    800064a4:	64a2                	ld	s1,8(sp)
    800064a6:	6105                	addi	sp,sp,32
    800064a8:	8082                	ret
    panic("acquire");
    800064aa:	00002517          	auipc	a0,0x2
    800064ae:	28650513          	addi	a0,a0,646 # 80008730 <etext+0x730>
    800064b2:	00000097          	auipc	ra,0x0
    800064b6:	a3a080e7          	jalr	-1478(ra) # 80005eec <panic>

00000000800064ba <pop_off>:

void
pop_off(void)
{
    800064ba:	1141                	addi	sp,sp,-16
    800064bc:	e406                	sd	ra,8(sp)
    800064be:	e022                	sd	s0,0(sp)
    800064c0:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800064c2:	ffffb097          	auipc	ra,0xffffb
    800064c6:	b36080e7          	jalr	-1226(ra) # 80000ff8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064ca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800064ce:	8b89                	andi	a5,a5,2
  if(intr_get())
    800064d0:	e78d                	bnez	a5,800064fa <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800064d2:	5d3c                	lw	a5,120(a0)
    800064d4:	02f05b63          	blez	a5,8000650a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800064d8:	37fd                	addiw	a5,a5,-1
    800064da:	0007871b          	sext.w	a4,a5
    800064de:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800064e0:	eb09                	bnez	a4,800064f2 <pop_off+0x38>
    800064e2:	5d7c                	lw	a5,124(a0)
    800064e4:	c799                	beqz	a5,800064f2 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064e6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800064ea:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064ee:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800064f2:	60a2                	ld	ra,8(sp)
    800064f4:	6402                	ld	s0,0(sp)
    800064f6:	0141                	addi	sp,sp,16
    800064f8:	8082                	ret
    panic("pop_off - interruptible");
    800064fa:	00002517          	auipc	a0,0x2
    800064fe:	23e50513          	addi	a0,a0,574 # 80008738 <etext+0x738>
    80006502:	00000097          	auipc	ra,0x0
    80006506:	9ea080e7          	jalr	-1558(ra) # 80005eec <panic>
    panic("pop_off");
    8000650a:	00002517          	auipc	a0,0x2
    8000650e:	24650513          	addi	a0,a0,582 # 80008750 <etext+0x750>
    80006512:	00000097          	auipc	ra,0x0
    80006516:	9da080e7          	jalr	-1574(ra) # 80005eec <panic>

000000008000651a <release>:
{
    8000651a:	1101                	addi	sp,sp,-32
    8000651c:	ec06                	sd	ra,24(sp)
    8000651e:	e822                	sd	s0,16(sp)
    80006520:	e426                	sd	s1,8(sp)
    80006522:	1000                	addi	s0,sp,32
    80006524:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006526:	00000097          	auipc	ra,0x0
    8000652a:	ec6080e7          	jalr	-314(ra) # 800063ec <holding>
    8000652e:	c115                	beqz	a0,80006552 <release+0x38>
  lk->cpu = 0;
    80006530:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006534:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006538:	0f50000f          	fence	iorw,ow
    8000653c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006540:	00000097          	auipc	ra,0x0
    80006544:	f7a080e7          	jalr	-134(ra) # 800064ba <pop_off>
}
    80006548:	60e2                	ld	ra,24(sp)
    8000654a:	6442                	ld	s0,16(sp)
    8000654c:	64a2                	ld	s1,8(sp)
    8000654e:	6105                	addi	sp,sp,32
    80006550:	8082                	ret
    panic("release");
    80006552:	00002517          	auipc	a0,0x2
    80006556:	20650513          	addi	a0,a0,518 # 80008758 <etext+0x758>
    8000655a:	00000097          	auipc	ra,0x0
    8000655e:	992080e7          	jalr	-1646(ra) # 80005eec <panic>
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
