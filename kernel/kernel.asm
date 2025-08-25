
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
    80000016:	0d9050ef          	jal	800058ee <start>

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
    8000005e:	338080e7          	jalr	824(ra) # 80006392 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3d8080e7          	jalr	984(ra) # 80006446 <release>
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
    8000008e:	d32080e7          	jalr	-718(ra) # 80005dbc <panic>

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
    800000fa:	20c080e7          	jalr	524(ra) # 80006302 <initlock>
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
    80000132:	264080e7          	jalr	612(ra) # 80006392 <acquire>
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
    8000014a:	300080e7          	jalr	768(ra) # 80006446 <release>

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
    80000174:	2d6080e7          	jalr	726(ra) # 80006446 <release>
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
    80000352:	ab8080e7          	jalr	-1352(ra) # 80005e06 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	846080e7          	jalr	-1978(ra) # 80001ba4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	f3e080e7          	jalr	-194(ra) # 800052a4 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	072080e7          	jalr	114(ra) # 800013e0 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	956080e7          	jalr	-1706(ra) # 80005ccc <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	c90080e7          	jalr	-880(ra) # 8000600e <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	a78080e7          	jalr	-1416(ra) # 80005e06 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	a68080e7          	jalr	-1432(ra) # 80005e06 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	a58080e7          	jalr	-1448(ra) # 80005e06 <printf>
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
    800003da:	7a6080e7          	jalr	1958(ra) # 80001b7c <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	7c6080e7          	jalr	1990(ra) # 80001ba4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	ea4080e7          	jalr	-348(ra) # 8000528a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	eb6080e7          	jalr	-330(ra) # 800052a4 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	fca080e7          	jalr	-54(ra) # 800023c0 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	656080e7          	jalr	1622(ra) # 80002a54 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	5fa080e7          	jalr	1530(ra) # 80003a00 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	fb6080e7          	jalr	-74(ra) # 800053c4 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d8e080e7          	jalr	-626(ra) # 800011a4 <userinit>
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
    80000484:	93c080e7          	jalr	-1732(ra) # 80005dbc <panic>
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
    800005aa:	816080e7          	jalr	-2026(ra) # 80005dbc <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	806080e7          	jalr	-2042(ra) # 80005dbc <panic>
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
    80000602:	00005097          	auipc	ra,0x5
    80000606:	7ba080e7          	jalr	1978(ra) # 80005dbc <panic>

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
    8000074c:	674080e7          	jalr	1652(ra) # 80005dbc <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	664080e7          	jalr	1636(ra) # 80005dbc <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	654080e7          	jalr	1620(ra) # 80005dbc <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	644080e7          	jalr	1604(ra) # 80005dbc <panic>
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
    80000870:	550080e7          	jalr	1360(ra) # 80005dbc <panic>

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
    800009bc:	404080e7          	jalr	1028(ra) # 80005dbc <panic>
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
    80000a9a:	326080e7          	jalr	806(ra) # 80005dbc <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	316080e7          	jalr	790(ra) # 80005dbc <panic>
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
    80000b14:	2ac080e7          	jalr	684(ra) # 80005dbc <panic>

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
    80000d0e:	ff8f6937          	lui	s2,0xff8f6
    80000d12:	c2990913          	addi	s2,s2,-983 # ffffffffff8f5c29 <end+0xffffffff7f8cf9e9>
    80000d16:	093e                	slli	s2,s2,0xf
    80000d18:	ae190913          	addi	s2,s2,-1311
    80000d1c:	0932                	slli	s2,s2,0xc
    80000d1e:	47b90913          	addi	s2,s2,1147
    80000d22:	0936                	slli	s2,s2,0xd
    80000d24:	c2990913          	addi	s2,s2,-983
    80000d28:	040009b7          	lui	s3,0x4000
    80000d2c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d2e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d30:	0000fa97          	auipc	s5,0xf
    80000d34:	b50a8a93          	addi	s5,s5,-1200 # 8000f880 <tickslock>
    char *pa = kalloc();
    80000d38:	fffff097          	auipc	ra,0xfffff
    80000d3c:	3e2080e7          	jalr	994(ra) # 8000011a <kalloc>
    80000d40:	862a                	mv	a2,a0
    if(pa == 0)
    80000d42:	c121                	beqz	a0,80000d82 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d44:	416485b3          	sub	a1,s1,s6
    80000d48:	8591                	srai	a1,a1,0x4
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
    80000d66:	19048493          	addi	s1,s1,400
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
    80000d8e:	032080e7          	jalr	50(ra) # 80005dbc <panic>

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
    80000dba:	54c080e7          	jalr	1356(ra) # 80006302 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	addi	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	00008517          	auipc	a0,0x8
    80000dca:	2a250513          	addi	a0,a0,674 # 80009068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	534080e7          	jalr	1332(ra) # 80006302 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	00008497          	auipc	s1,0x8
    80000dda:	6aa48493          	addi	s1,s1,1706 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dde:	00007b17          	auipc	s6,0x7
    80000de2:	39ab0b13          	addi	s6,s6,922 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	8aa6                	mv	s5,s1
    80000de8:	ff8f6937          	lui	s2,0xff8f6
    80000dec:	c2990913          	addi	s2,s2,-983 # ffffffffff8f5c29 <end+0xffffffff7f8cf9e9>
    80000df0:	093e                	slli	s2,s2,0xf
    80000df2:	ae190913          	addi	s2,s2,-1311
    80000df6:	0932                	slli	s2,s2,0xc
    80000df8:	47b90913          	addi	s2,s2,1147
    80000dfc:	0936                	slli	s2,s2,0xd
    80000dfe:	c2990913          	addi	s2,s2,-983
    80000e02:	040009b7          	lui	s3,0x4000
    80000e06:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e08:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	0000fa17          	auipc	s4,0xf
    80000e0e:	a76a0a13          	addi	s4,s4,-1418 # 8000f880 <tickslock>
      initlock(&p->lock, "proc");
    80000e12:	85da                	mv	a1,s6
    80000e14:	8526                	mv	a0,s1
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	4ec080e7          	jalr	1260(ra) # 80006302 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e1e:	415487b3          	sub	a5,s1,s5
    80000e22:	8791                	srai	a5,a5,0x4
    80000e24:	032787b3          	mul	a5,a5,s2
    80000e28:	2785                	addiw	a5,a5,1
    80000e2a:	00d7979b          	slliw	a5,a5,0xd
    80000e2e:	40f987b3          	sub	a5,s3,a5
    80000e32:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	19048493          	addi	s1,s1,400
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
    80000e8a:	4c0080e7          	jalr	1216(ra) # 80006346 <push_off>
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
    80000ea4:	546080e7          	jalr	1350(ra) # 800063e6 <pop_off>
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
    80000ec8:	582080e7          	jalr	1410(ra) # 80006446 <release>

  if (first) {
    80000ecc:	00008797          	auipc	a5,0x8
    80000ed0:	9647a783          	lw	a5,-1692(a5) # 80008830 <first.1>
    80000ed4:	eb89                	bnez	a5,80000ee6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	ce6080e7          	jalr	-794(ra) # 80001bbc <usertrapret>
}
    80000ede:	60a2                	ld	ra,8(sp)
    80000ee0:	6402                	ld	s0,0(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
    first = 0;
    80000ee6:	00008797          	auipc	a5,0x8
    80000eea:	9407a523          	sw	zero,-1718(a5) # 80008830 <first.1>
    fsinit(ROOTDEV);
    80000eee:	4505                	li	a0,1
    80000ef0:	00002097          	auipc	ra,0x2
    80000ef4:	ae4080e7          	jalr	-1308(ra) # 800029d4 <fsinit>
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
    80000f14:	482080e7          	jalr	1154(ra) # 80006392 <acquire>
  pid = nextpid;
    80000f18:	00008797          	auipc	a5,0x8
    80000f1c:	91c78793          	addi	a5,a5,-1764 # 80008834 <nextpid>
    80000f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f22:	0014871b          	addiw	a4,s1,1
    80000f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	51c080e7          	jalr	1308(ra) # 80006446 <release>
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
  if(p->alarm_trapframe)
    8000104a:	1804b503          	ld	a0,384(s1)
    8000104e:	c509                	beqz	a0,80001058 <freeproc+0x2a>
    kfree((void*)p->alarm_trapframe);
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	fcc080e7          	jalr	-52(ra) # 8000001c <kfree>
  p->alarm_trapframe = 0;
    80001058:	1804b023          	sd	zero,384(s1)
  if(p->pagetable)
    8000105c:	68a8                	ld	a0,80(s1)
    8000105e:	c511                	beqz	a0,8000106a <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    80001060:	64ac                	ld	a1,72(s1)
    80001062:	00000097          	auipc	ra,0x0
    80001066:	f7a080e7          	jalr	-134(ra) # 80000fdc <proc_freepagetable>
  p->pagetable = 0;
    8000106a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000106e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001072:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001076:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000107a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000107e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001082:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001086:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000108a:	0004ac23          	sw	zero,24(s1)
  p->alarm_interval = 0;
    8000108e:	1604a423          	sw	zero,360(s1)
  p->alarm_handler = 0;
    80001092:	1604b823          	sd	zero,368(s1)
  p->alarm_ticks = 0;
    80001096:	1604ac23          	sw	zero,376(s1)
  p->alarm_goingoff = 0;
    8000109a:	1804a423          	sw	zero,392(s1)
}
    8000109e:	60e2                	ld	ra,24(sp)
    800010a0:	6442                	ld	s0,16(sp)
    800010a2:	64a2                	ld	s1,8(sp)
    800010a4:	6105                	addi	sp,sp,32
    800010a6:	8082                	ret

00000000800010a8 <allocproc>:
{
    800010a8:	1101                	addi	sp,sp,-32
    800010aa:	ec06                	sd	ra,24(sp)
    800010ac:	e822                	sd	s0,16(sp)
    800010ae:	e426                	sd	s1,8(sp)
    800010b0:	e04a                	sd	s2,0(sp)
    800010b2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b4:	00008497          	auipc	s1,0x8
    800010b8:	3cc48493          	addi	s1,s1,972 # 80009480 <proc>
    800010bc:	0000e917          	auipc	s2,0xe
    800010c0:	7c490913          	addi	s2,s2,1988 # 8000f880 <tickslock>
    acquire(&p->lock);
    800010c4:	8526                	mv	a0,s1
    800010c6:	00005097          	auipc	ra,0x5
    800010ca:	2cc080e7          	jalr	716(ra) # 80006392 <acquire>
    if(p->state == UNUSED) {
    800010ce:	4c9c                	lw	a5,24(s1)
    800010d0:	cf81                	beqz	a5,800010e8 <allocproc+0x40>
      release(&p->lock);
    800010d2:	8526                	mv	a0,s1
    800010d4:	00005097          	auipc	ra,0x5
    800010d8:	372080e7          	jalr	882(ra) # 80006446 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010dc:	19048493          	addi	s1,s1,400
    800010e0:	ff2492e3          	bne	s1,s2,800010c4 <allocproc+0x1c>
  return 0;
    800010e4:	4481                	li	s1,0
    800010e6:	a88d                	j	80001158 <allocproc+0xb0>
  p->pid = allocpid();
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	e12080e7          	jalr	-494(ra) # 80000efa <allocpid>
    800010f0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010f2:	4785                	li	a5,1
    800010f4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010f6:	fffff097          	auipc	ra,0xfffff
    800010fa:	024080e7          	jalr	36(ra) # 8000011a <kalloc>
    800010fe:	892a                	mv	s2,a0
    80001100:	eca8                	sd	a0,88(s1)
    80001102:	c135                	beqz	a0,80001166 <allocproc+0xbe>
  if((p->alarm_trapframe = (struct trapframe *)kalloc()) == 0){
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	016080e7          	jalr	22(ra) # 8000011a <kalloc>
    8000110c:	892a                	mv	s2,a0
    8000110e:	18a4b023          	sd	a0,384(s1)
    80001112:	c535                	beqz	a0,8000117e <allocproc+0xd6>
  p->alarm_interval = 0;
    80001114:	1604a423          	sw	zero,360(s1)
  p->alarm_handler = 0;
    80001118:	1604b823          	sd	zero,368(s1)
  p->alarm_ticks = 0;
    8000111c:	1604ac23          	sw	zero,376(s1)
  p->alarm_goingoff = 0;
    80001120:	1804a423          	sw	zero,392(s1)
  p->pagetable = proc_pagetable(p);
    80001124:	8526                	mv	a0,s1
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	e1a080e7          	jalr	-486(ra) # 80000f40 <proc_pagetable>
    8000112e:	892a                	mv	s2,a0
    80001130:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001132:	cd29                	beqz	a0,8000118c <allocproc+0xe4>
  memset(&p->context, 0, sizeof(p->context));
    80001134:	07000613          	li	a2,112
    80001138:	4581                	li	a1,0
    8000113a:	06048513          	addi	a0,s1,96
    8000113e:	fffff097          	auipc	ra,0xfffff
    80001142:	03c080e7          	jalr	60(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001146:	00000797          	auipc	a5,0x0
    8000114a:	d6e78793          	addi	a5,a5,-658 # 80000eb4 <forkret>
    8000114e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001150:	60bc                	ld	a5,64(s1)
    80001152:	6705                	lui	a4,0x1
    80001154:	97ba                	add	a5,a5,a4
    80001156:	f4bc                	sd	a5,104(s1)
}
    80001158:	8526                	mv	a0,s1
    8000115a:	60e2                	ld	ra,24(sp)
    8000115c:	6442                	ld	s0,16(sp)
    8000115e:	64a2                	ld	s1,8(sp)
    80001160:	6902                	ld	s2,0(sp)
    80001162:	6105                	addi	sp,sp,32
    80001164:	8082                	ret
    freeproc(p);
    80001166:	8526                	mv	a0,s1
    80001168:	00000097          	auipc	ra,0x0
    8000116c:	ec6080e7          	jalr	-314(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001170:	8526                	mv	a0,s1
    80001172:	00005097          	auipc	ra,0x5
    80001176:	2d4080e7          	jalr	724(ra) # 80006446 <release>
    return 0;
    8000117a:	84ca                	mv	s1,s2
    8000117c:	bff1                	j	80001158 <allocproc+0xb0>
    release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00005097          	auipc	ra,0x5
    80001184:	2c6080e7          	jalr	710(ra) # 80006446 <release>
    return 0;
    80001188:	84ca                	mv	s1,s2
    8000118a:	b7f9                	j	80001158 <allocproc+0xb0>
    freeproc(p);
    8000118c:	8526                	mv	a0,s1
    8000118e:	00000097          	auipc	ra,0x0
    80001192:	ea0080e7          	jalr	-352(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001196:	8526                	mv	a0,s1
    80001198:	00005097          	auipc	ra,0x5
    8000119c:	2ae080e7          	jalr	686(ra) # 80006446 <release>
    return 0;
    800011a0:	84ca                	mv	s1,s2
    800011a2:	bf5d                	j	80001158 <allocproc+0xb0>

00000000800011a4 <userinit>:
{
    800011a4:	1101                	addi	sp,sp,-32
    800011a6:	ec06                	sd	ra,24(sp)
    800011a8:	e822                	sd	s0,16(sp)
    800011aa:	e426                	sd	s1,8(sp)
    800011ac:	1000                	addi	s0,sp,32
  p = allocproc();
    800011ae:	00000097          	auipc	ra,0x0
    800011b2:	efa080e7          	jalr	-262(ra) # 800010a8 <allocproc>
    800011b6:	84aa                	mv	s1,a0
  initproc = p;
    800011b8:	00008797          	auipc	a5,0x8
    800011bc:	e4a7bc23          	sd	a0,-424(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800011c0:	03400613          	li	a2,52
    800011c4:	00007597          	auipc	a1,0x7
    800011c8:	67c58593          	addi	a1,a1,1660 # 80008840 <initcode>
    800011cc:	6928                	ld	a0,80(a0)
    800011ce:	fffff097          	auipc	ra,0xfffff
    800011d2:	634080e7          	jalr	1588(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    800011d6:	6785                	lui	a5,0x1
    800011d8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011da:	6cb8                	ld	a4,88(s1)
    800011dc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011e0:	6cb8                	ld	a4,88(s1)
    800011e2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011e4:	4641                	li	a2,16
    800011e6:	00007597          	auipc	a1,0x7
    800011ea:	f9a58593          	addi	a1,a1,-102 # 80008180 <etext+0x180>
    800011ee:	15848513          	addi	a0,s1,344
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	0ca080e7          	jalr	202(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800011fa:	00007517          	auipc	a0,0x7
    800011fe:	f9650513          	addi	a0,a0,-106 # 80008190 <etext+0x190>
    80001202:	00002097          	auipc	ra,0x2
    80001206:	218080e7          	jalr	536(ra) # 8000341a <namei>
    8000120a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000120e:	478d                	li	a5,3
    80001210:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001212:	8526                	mv	a0,s1
    80001214:	00005097          	auipc	ra,0x5
    80001218:	232080e7          	jalr	562(ra) # 80006446 <release>
}
    8000121c:	60e2                	ld	ra,24(sp)
    8000121e:	6442                	ld	s0,16(sp)
    80001220:	64a2                	ld	s1,8(sp)
    80001222:	6105                	addi	sp,sp,32
    80001224:	8082                	ret

0000000080001226 <growproc>:
{
    80001226:	1101                	addi	sp,sp,-32
    80001228:	ec06                	sd	ra,24(sp)
    8000122a:	e822                	sd	s0,16(sp)
    8000122c:	e426                	sd	s1,8(sp)
    8000122e:	e04a                	sd	s2,0(sp)
    80001230:	1000                	addi	s0,sp,32
    80001232:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001234:	00000097          	auipc	ra,0x0
    80001238:	c48080e7          	jalr	-952(ra) # 80000e7c <myproc>
    8000123c:	892a                	mv	s2,a0
  sz = p->sz;
    8000123e:	652c                	ld	a1,72(a0)
    80001240:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001244:	00904f63          	bgtz	s1,80001262 <growproc+0x3c>
  } else if(n < 0){
    80001248:	0204cd63          	bltz	s1,80001282 <growproc+0x5c>
  p->sz = sz;
    8000124c:	1782                	slli	a5,a5,0x20
    8000124e:	9381                	srli	a5,a5,0x20
    80001250:	04f93423          	sd	a5,72(s2)
  return 0;
    80001254:	4501                	li	a0,0
}
    80001256:	60e2                	ld	ra,24(sp)
    80001258:	6442                	ld	s0,16(sp)
    8000125a:	64a2                	ld	s1,8(sp)
    8000125c:	6902                	ld	s2,0(sp)
    8000125e:	6105                	addi	sp,sp,32
    80001260:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001262:	00f4863b          	addw	a2,s1,a5
    80001266:	1602                	slli	a2,a2,0x20
    80001268:	9201                	srli	a2,a2,0x20
    8000126a:	1582                	slli	a1,a1,0x20
    8000126c:	9181                	srli	a1,a1,0x20
    8000126e:	6928                	ld	a0,80(a0)
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	64c080e7          	jalr	1612(ra) # 800008bc <uvmalloc>
    80001278:	0005079b          	sext.w	a5,a0
    8000127c:	fbe1                	bnez	a5,8000124c <growproc+0x26>
      return -1;
    8000127e:	557d                	li	a0,-1
    80001280:	bfd9                	j	80001256 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001282:	00f4863b          	addw	a2,s1,a5
    80001286:	1602                	slli	a2,a2,0x20
    80001288:	9201                	srli	a2,a2,0x20
    8000128a:	1582                	slli	a1,a1,0x20
    8000128c:	9181                	srli	a1,a1,0x20
    8000128e:	6928                	ld	a0,80(a0)
    80001290:	fffff097          	auipc	ra,0xfffff
    80001294:	5e4080e7          	jalr	1508(ra) # 80000874 <uvmdealloc>
    80001298:	0005079b          	sext.w	a5,a0
    8000129c:	bf45                	j	8000124c <growproc+0x26>

000000008000129e <fork>:
{
    8000129e:	7139                	addi	sp,sp,-64
    800012a0:	fc06                	sd	ra,56(sp)
    800012a2:	f822                	sd	s0,48(sp)
    800012a4:	f04a                	sd	s2,32(sp)
    800012a6:	e456                	sd	s5,8(sp)
    800012a8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	bd2080e7          	jalr	-1070(ra) # 80000e7c <myproc>
    800012b2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012b4:	00000097          	auipc	ra,0x0
    800012b8:	df4080e7          	jalr	-524(ra) # 800010a8 <allocproc>
    800012bc:	12050063          	beqz	a0,800013dc <fork+0x13e>
    800012c0:	e852                	sd	s4,16(sp)
    800012c2:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012c4:	048ab603          	ld	a2,72(s5)
    800012c8:	692c                	ld	a1,80(a0)
    800012ca:	050ab503          	ld	a0,80(s5)
    800012ce:	fffff097          	auipc	ra,0xfffff
    800012d2:	746080e7          	jalr	1862(ra) # 80000a14 <uvmcopy>
    800012d6:	04054a63          	bltz	a0,8000132a <fork+0x8c>
    800012da:	f426                	sd	s1,40(sp)
    800012dc:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800012de:	048ab783          	ld	a5,72(s5)
    800012e2:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012e6:	058ab683          	ld	a3,88(s5)
    800012ea:	87b6                	mv	a5,a3
    800012ec:	058a3703          	ld	a4,88(s4)
    800012f0:	12068693          	addi	a3,a3,288
    800012f4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012f8:	6788                	ld	a0,8(a5)
    800012fa:	6b8c                	ld	a1,16(a5)
    800012fc:	6f90                	ld	a2,24(a5)
    800012fe:	01073023          	sd	a6,0(a4)
    80001302:	e708                	sd	a0,8(a4)
    80001304:	eb0c                	sd	a1,16(a4)
    80001306:	ef10                	sd	a2,24(a4)
    80001308:	02078793          	addi	a5,a5,32
    8000130c:	02070713          	addi	a4,a4,32
    80001310:	fed792e3          	bne	a5,a3,800012f4 <fork+0x56>
  np->trapframe->a0 = 0;
    80001314:	058a3783          	ld	a5,88(s4)
    80001318:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000131c:	0d0a8493          	addi	s1,s5,208
    80001320:	0d0a0913          	addi	s2,s4,208
    80001324:	150a8993          	addi	s3,s5,336
    80001328:	a015                	j	8000134c <fork+0xae>
    freeproc(np);
    8000132a:	8552                	mv	a0,s4
    8000132c:	00000097          	auipc	ra,0x0
    80001330:	d02080e7          	jalr	-766(ra) # 8000102e <freeproc>
    release(&np->lock);
    80001334:	8552                	mv	a0,s4
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	110080e7          	jalr	272(ra) # 80006446 <release>
    return -1;
    8000133e:	597d                	li	s2,-1
    80001340:	6a42                	ld	s4,16(sp)
    80001342:	a071                	j	800013ce <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001344:	04a1                	addi	s1,s1,8
    80001346:	0921                	addi	s2,s2,8
    80001348:	01348b63          	beq	s1,s3,8000135e <fork+0xc0>
    if(p->ofile[i])
    8000134c:	6088                	ld	a0,0(s1)
    8000134e:	d97d                	beqz	a0,80001344 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001350:	00002097          	auipc	ra,0x2
    80001354:	742080e7          	jalr	1858(ra) # 80003a92 <filedup>
    80001358:	00a93023          	sd	a0,0(s2)
    8000135c:	b7e5                	j	80001344 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000135e:	150ab503          	ld	a0,336(s5)
    80001362:	00002097          	auipc	ra,0x2
    80001366:	8a8080e7          	jalr	-1880(ra) # 80002c0a <idup>
    8000136a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000136e:	4641                	li	a2,16
    80001370:	158a8593          	addi	a1,s5,344
    80001374:	158a0513          	addi	a0,s4,344
    80001378:	fffff097          	auipc	ra,0xfffff
    8000137c:	f44080e7          	jalr	-188(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001380:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001384:	8552                	mv	a0,s4
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	0c0080e7          	jalr	192(ra) # 80006446 <release>
  acquire(&wait_lock);
    8000138e:	00008497          	auipc	s1,0x8
    80001392:	cda48493          	addi	s1,s1,-806 # 80009068 <wait_lock>
    80001396:	8526                	mv	a0,s1
    80001398:	00005097          	auipc	ra,0x5
    8000139c:	ffa080e7          	jalr	-6(ra) # 80006392 <acquire>
  np->parent = p;
    800013a0:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800013a4:	8526                	mv	a0,s1
    800013a6:	00005097          	auipc	ra,0x5
    800013aa:	0a0080e7          	jalr	160(ra) # 80006446 <release>
  acquire(&np->lock);
    800013ae:	8552                	mv	a0,s4
    800013b0:	00005097          	auipc	ra,0x5
    800013b4:	fe2080e7          	jalr	-30(ra) # 80006392 <acquire>
  np->state = RUNNABLE;
    800013b8:	478d                	li	a5,3
    800013ba:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013be:	8552                	mv	a0,s4
    800013c0:	00005097          	auipc	ra,0x5
    800013c4:	086080e7          	jalr	134(ra) # 80006446 <release>
  return pid;
    800013c8:	74a2                	ld	s1,40(sp)
    800013ca:	69e2                	ld	s3,24(sp)
    800013cc:	6a42                	ld	s4,16(sp)
}
    800013ce:	854a                	mv	a0,s2
    800013d0:	70e2                	ld	ra,56(sp)
    800013d2:	7442                	ld	s0,48(sp)
    800013d4:	7902                	ld	s2,32(sp)
    800013d6:	6aa2                	ld	s5,8(sp)
    800013d8:	6121                	addi	sp,sp,64
    800013da:	8082                	ret
    return -1;
    800013dc:	597d                	li	s2,-1
    800013de:	bfc5                	j	800013ce <fork+0x130>

00000000800013e0 <scheduler>:
{
    800013e0:	7139                	addi	sp,sp,-64
    800013e2:	fc06                	sd	ra,56(sp)
    800013e4:	f822                	sd	s0,48(sp)
    800013e6:	f426                	sd	s1,40(sp)
    800013e8:	f04a                	sd	s2,32(sp)
    800013ea:	ec4e                	sd	s3,24(sp)
    800013ec:	e852                	sd	s4,16(sp)
    800013ee:	e456                	sd	s5,8(sp)
    800013f0:	e05a                	sd	s6,0(sp)
    800013f2:	0080                	addi	s0,sp,64
    800013f4:	8792                	mv	a5,tp
  int id = r_tp();
    800013f6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013f8:	00779a93          	slli	s5,a5,0x7
    800013fc:	00008717          	auipc	a4,0x8
    80001400:	c5470713          	addi	a4,a4,-940 # 80009050 <pid_lock>
    80001404:	9756                	add	a4,a4,s5
    80001406:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000140a:	00008717          	auipc	a4,0x8
    8000140e:	c7e70713          	addi	a4,a4,-898 # 80009088 <cpus+0x8>
    80001412:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001414:	498d                	li	s3,3
        p->state = RUNNING;
    80001416:	4b11                	li	s6,4
        c->proc = p;
    80001418:	079e                	slli	a5,a5,0x7
    8000141a:	00008a17          	auipc	s4,0x8
    8000141e:	c36a0a13          	addi	s4,s4,-970 # 80009050 <pid_lock>
    80001422:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001424:	0000e917          	auipc	s2,0xe
    80001428:	45c90913          	addi	s2,s2,1116 # 8000f880 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001430:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001434:	10079073          	csrw	sstatus,a5
    80001438:	00008497          	auipc	s1,0x8
    8000143c:	04848493          	addi	s1,s1,72 # 80009480 <proc>
    80001440:	a811                	j	80001454 <scheduler+0x74>
      release(&p->lock);
    80001442:	8526                	mv	a0,s1
    80001444:	00005097          	auipc	ra,0x5
    80001448:	002080e7          	jalr	2(ra) # 80006446 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000144c:	19048493          	addi	s1,s1,400
    80001450:	fd248ee3          	beq	s1,s2,8000142c <scheduler+0x4c>
      acquire(&p->lock);
    80001454:	8526                	mv	a0,s1
    80001456:	00005097          	auipc	ra,0x5
    8000145a:	f3c080e7          	jalr	-196(ra) # 80006392 <acquire>
      if(p->state == RUNNABLE) {
    8000145e:	4c9c                	lw	a5,24(s1)
    80001460:	ff3791e3          	bne	a5,s3,80001442 <scheduler+0x62>
        p->state = RUNNING;
    80001464:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001468:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000146c:	06048593          	addi	a1,s1,96
    80001470:	8556                	mv	a0,s5
    80001472:	00000097          	auipc	ra,0x0
    80001476:	620080e7          	jalr	1568(ra) # 80001a92 <swtch>
        c->proc = 0;
    8000147a:	020a3823          	sd	zero,48(s4)
    8000147e:	b7d1                	j	80001442 <scheduler+0x62>

0000000080001480 <sched>:
{
    80001480:	7179                	addi	sp,sp,-48
    80001482:	f406                	sd	ra,40(sp)
    80001484:	f022                	sd	s0,32(sp)
    80001486:	ec26                	sd	s1,24(sp)
    80001488:	e84a                	sd	s2,16(sp)
    8000148a:	e44e                	sd	s3,8(sp)
    8000148c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000148e:	00000097          	auipc	ra,0x0
    80001492:	9ee080e7          	jalr	-1554(ra) # 80000e7c <myproc>
    80001496:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001498:	00005097          	auipc	ra,0x5
    8000149c:	e80080e7          	jalr	-384(ra) # 80006318 <holding>
    800014a0:	c93d                	beqz	a0,80001516 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014a4:	2781                	sext.w	a5,a5
    800014a6:	079e                	slli	a5,a5,0x7
    800014a8:	00008717          	auipc	a4,0x8
    800014ac:	ba870713          	addi	a4,a4,-1112 # 80009050 <pid_lock>
    800014b0:	97ba                	add	a5,a5,a4
    800014b2:	0a87a703          	lw	a4,168(a5)
    800014b6:	4785                	li	a5,1
    800014b8:	06f71763          	bne	a4,a5,80001526 <sched+0xa6>
  if(p->state == RUNNING)
    800014bc:	4c98                	lw	a4,24(s1)
    800014be:	4791                	li	a5,4
    800014c0:	06f70b63          	beq	a4,a5,80001536 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014c4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014c8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014ca:	efb5                	bnez	a5,80001546 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014cc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014ce:	00008917          	auipc	s2,0x8
    800014d2:	b8290913          	addi	s2,s2,-1150 # 80009050 <pid_lock>
    800014d6:	2781                	sext.w	a5,a5
    800014d8:	079e                	slli	a5,a5,0x7
    800014da:	97ca                	add	a5,a5,s2
    800014dc:	0ac7a983          	lw	s3,172(a5)
    800014e0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014e2:	2781                	sext.w	a5,a5
    800014e4:	079e                	slli	a5,a5,0x7
    800014e6:	00008597          	auipc	a1,0x8
    800014ea:	ba258593          	addi	a1,a1,-1118 # 80009088 <cpus+0x8>
    800014ee:	95be                	add	a1,a1,a5
    800014f0:	06048513          	addi	a0,s1,96
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	59e080e7          	jalr	1438(ra) # 80001a92 <swtch>
    800014fc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014fe:	2781                	sext.w	a5,a5
    80001500:	079e                	slli	a5,a5,0x7
    80001502:	993e                	add	s2,s2,a5
    80001504:	0b392623          	sw	s3,172(s2)
}
    80001508:	70a2                	ld	ra,40(sp)
    8000150a:	7402                	ld	s0,32(sp)
    8000150c:	64e2                	ld	s1,24(sp)
    8000150e:	6942                	ld	s2,16(sp)
    80001510:	69a2                	ld	s3,8(sp)
    80001512:	6145                	addi	sp,sp,48
    80001514:	8082                	ret
    panic("sched p->lock");
    80001516:	00007517          	auipc	a0,0x7
    8000151a:	c8250513          	addi	a0,a0,-894 # 80008198 <etext+0x198>
    8000151e:	00005097          	auipc	ra,0x5
    80001522:	89e080e7          	jalr	-1890(ra) # 80005dbc <panic>
    panic("sched locks");
    80001526:	00007517          	auipc	a0,0x7
    8000152a:	c8250513          	addi	a0,a0,-894 # 800081a8 <etext+0x1a8>
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	88e080e7          	jalr	-1906(ra) # 80005dbc <panic>
    panic("sched running");
    80001536:	00007517          	auipc	a0,0x7
    8000153a:	c8250513          	addi	a0,a0,-894 # 800081b8 <etext+0x1b8>
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	87e080e7          	jalr	-1922(ra) # 80005dbc <panic>
    panic("sched interruptible");
    80001546:	00007517          	auipc	a0,0x7
    8000154a:	c8250513          	addi	a0,a0,-894 # 800081c8 <etext+0x1c8>
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	86e080e7          	jalr	-1938(ra) # 80005dbc <panic>

0000000080001556 <yield>:
{
    80001556:	1101                	addi	sp,sp,-32
    80001558:	ec06                	sd	ra,24(sp)
    8000155a:	e822                	sd	s0,16(sp)
    8000155c:	e426                	sd	s1,8(sp)
    8000155e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001560:	00000097          	auipc	ra,0x0
    80001564:	91c080e7          	jalr	-1764(ra) # 80000e7c <myproc>
    80001568:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000156a:	00005097          	auipc	ra,0x5
    8000156e:	e28080e7          	jalr	-472(ra) # 80006392 <acquire>
  p->state = RUNNABLE;
    80001572:	478d                	li	a5,3
    80001574:	cc9c                	sw	a5,24(s1)
  sched();
    80001576:	00000097          	auipc	ra,0x0
    8000157a:	f0a080e7          	jalr	-246(ra) # 80001480 <sched>
  release(&p->lock);
    8000157e:	8526                	mv	a0,s1
    80001580:	00005097          	auipc	ra,0x5
    80001584:	ec6080e7          	jalr	-314(ra) # 80006446 <release>
}
    80001588:	60e2                	ld	ra,24(sp)
    8000158a:	6442                	ld	s0,16(sp)
    8000158c:	64a2                	ld	s1,8(sp)
    8000158e:	6105                	addi	sp,sp,32
    80001590:	8082                	ret

0000000080001592 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001592:	7179                	addi	sp,sp,-48
    80001594:	f406                	sd	ra,40(sp)
    80001596:	f022                	sd	s0,32(sp)
    80001598:	ec26                	sd	s1,24(sp)
    8000159a:	e84a                	sd	s2,16(sp)
    8000159c:	e44e                	sd	s3,8(sp)
    8000159e:	1800                	addi	s0,sp,48
    800015a0:	89aa                	mv	s3,a0
    800015a2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	8d8080e7          	jalr	-1832(ra) # 80000e7c <myproc>
    800015ac:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	de4080e7          	jalr	-540(ra) # 80006392 <acquire>
  release(lk);
    800015b6:	854a                	mv	a0,s2
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	e8e080e7          	jalr	-370(ra) # 80006446 <release>

  // Go to sleep.
  p->chan = chan;
    800015c0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015c4:	4789                	li	a5,2
    800015c6:	cc9c                	sw	a5,24(s1)

  sched();
    800015c8:	00000097          	auipc	ra,0x0
    800015cc:	eb8080e7          	jalr	-328(ra) # 80001480 <sched>

  // Tidy up.
  p->chan = 0;
    800015d0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015d4:	8526                	mv	a0,s1
    800015d6:	00005097          	auipc	ra,0x5
    800015da:	e70080e7          	jalr	-400(ra) # 80006446 <release>
  acquire(lk);
    800015de:	854a                	mv	a0,s2
    800015e0:	00005097          	auipc	ra,0x5
    800015e4:	db2080e7          	jalr	-590(ra) # 80006392 <acquire>
}
    800015e8:	70a2                	ld	ra,40(sp)
    800015ea:	7402                	ld	s0,32(sp)
    800015ec:	64e2                	ld	s1,24(sp)
    800015ee:	6942                	ld	s2,16(sp)
    800015f0:	69a2                	ld	s3,8(sp)
    800015f2:	6145                	addi	sp,sp,48
    800015f4:	8082                	ret

00000000800015f6 <wait>:
{
    800015f6:	715d                	addi	sp,sp,-80
    800015f8:	e486                	sd	ra,72(sp)
    800015fa:	e0a2                	sd	s0,64(sp)
    800015fc:	fc26                	sd	s1,56(sp)
    800015fe:	f84a                	sd	s2,48(sp)
    80001600:	f44e                	sd	s3,40(sp)
    80001602:	f052                	sd	s4,32(sp)
    80001604:	ec56                	sd	s5,24(sp)
    80001606:	e85a                	sd	s6,16(sp)
    80001608:	e45e                	sd	s7,8(sp)
    8000160a:	e062                	sd	s8,0(sp)
    8000160c:	0880                	addi	s0,sp,80
    8000160e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001610:	00000097          	auipc	ra,0x0
    80001614:	86c080e7          	jalr	-1940(ra) # 80000e7c <myproc>
    80001618:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000161a:	00008517          	auipc	a0,0x8
    8000161e:	a4e50513          	addi	a0,a0,-1458 # 80009068 <wait_lock>
    80001622:	00005097          	auipc	ra,0x5
    80001626:	d70080e7          	jalr	-656(ra) # 80006392 <acquire>
    havekids = 0;
    8000162a:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000162c:	4a15                	li	s4,5
        havekids = 1;
    8000162e:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001630:	0000e997          	auipc	s3,0xe
    80001634:	25098993          	addi	s3,s3,592 # 8000f880 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001638:	00008c17          	auipc	s8,0x8
    8000163c:	a30c0c13          	addi	s8,s8,-1488 # 80009068 <wait_lock>
    80001640:	a87d                	j	800016fe <wait+0x108>
          pid = np->pid;
    80001642:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001646:	000b0e63          	beqz	s6,80001662 <wait+0x6c>
    8000164a:	4691                	li	a3,4
    8000164c:	02c48613          	addi	a2,s1,44
    80001650:	85da                	mv	a1,s6
    80001652:	05093503          	ld	a0,80(s2)
    80001656:	fffff097          	auipc	ra,0xfffff
    8000165a:	4c2080e7          	jalr	1218(ra) # 80000b18 <copyout>
    8000165e:	04054163          	bltz	a0,800016a0 <wait+0xaa>
          freeproc(np);
    80001662:	8526                	mv	a0,s1
    80001664:	00000097          	auipc	ra,0x0
    80001668:	9ca080e7          	jalr	-1590(ra) # 8000102e <freeproc>
          release(&np->lock);
    8000166c:	8526                	mv	a0,s1
    8000166e:	00005097          	auipc	ra,0x5
    80001672:	dd8080e7          	jalr	-552(ra) # 80006446 <release>
          release(&wait_lock);
    80001676:	00008517          	auipc	a0,0x8
    8000167a:	9f250513          	addi	a0,a0,-1550 # 80009068 <wait_lock>
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	dc8080e7          	jalr	-568(ra) # 80006446 <release>
}
    80001686:	854e                	mv	a0,s3
    80001688:	60a6                	ld	ra,72(sp)
    8000168a:	6406                	ld	s0,64(sp)
    8000168c:	74e2                	ld	s1,56(sp)
    8000168e:	7942                	ld	s2,48(sp)
    80001690:	79a2                	ld	s3,40(sp)
    80001692:	7a02                	ld	s4,32(sp)
    80001694:	6ae2                	ld	s5,24(sp)
    80001696:	6b42                	ld	s6,16(sp)
    80001698:	6ba2                	ld	s7,8(sp)
    8000169a:	6c02                	ld	s8,0(sp)
    8000169c:	6161                	addi	sp,sp,80
    8000169e:	8082                	ret
            release(&np->lock);
    800016a0:	8526                	mv	a0,s1
    800016a2:	00005097          	auipc	ra,0x5
    800016a6:	da4080e7          	jalr	-604(ra) # 80006446 <release>
            release(&wait_lock);
    800016aa:	00008517          	auipc	a0,0x8
    800016ae:	9be50513          	addi	a0,a0,-1602 # 80009068 <wait_lock>
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	d94080e7          	jalr	-620(ra) # 80006446 <release>
            return -1;
    800016ba:	59fd                	li	s3,-1
    800016bc:	b7e9                	j	80001686 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    800016be:	19048493          	addi	s1,s1,400
    800016c2:	03348463          	beq	s1,s3,800016ea <wait+0xf4>
      if(np->parent == p){
    800016c6:	7c9c                	ld	a5,56(s1)
    800016c8:	ff279be3          	bne	a5,s2,800016be <wait+0xc8>
        acquire(&np->lock);
    800016cc:	8526                	mv	a0,s1
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	cc4080e7          	jalr	-828(ra) # 80006392 <acquire>
        if(np->state == ZOMBIE){
    800016d6:	4c9c                	lw	a5,24(s1)
    800016d8:	f74785e3          	beq	a5,s4,80001642 <wait+0x4c>
        release(&np->lock);
    800016dc:	8526                	mv	a0,s1
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	d68080e7          	jalr	-664(ra) # 80006446 <release>
        havekids = 1;
    800016e6:	8756                	mv	a4,s5
    800016e8:	bfd9                	j	800016be <wait+0xc8>
    if(!havekids || p->killed){
    800016ea:	c305                	beqz	a4,8000170a <wait+0x114>
    800016ec:	02892783          	lw	a5,40(s2)
    800016f0:	ef89                	bnez	a5,8000170a <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016f2:	85e2                	mv	a1,s8
    800016f4:	854a                	mv	a0,s2
    800016f6:	00000097          	auipc	ra,0x0
    800016fa:	e9c080e7          	jalr	-356(ra) # 80001592 <sleep>
    havekids = 0;
    800016fe:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001700:	00008497          	auipc	s1,0x8
    80001704:	d8048493          	addi	s1,s1,-640 # 80009480 <proc>
    80001708:	bf7d                	j	800016c6 <wait+0xd0>
      release(&wait_lock);
    8000170a:	00008517          	auipc	a0,0x8
    8000170e:	95e50513          	addi	a0,a0,-1698 # 80009068 <wait_lock>
    80001712:	00005097          	auipc	ra,0x5
    80001716:	d34080e7          	jalr	-716(ra) # 80006446 <release>
      return -1;
    8000171a:	59fd                	li	s3,-1
    8000171c:	b7ad                	j	80001686 <wait+0x90>

000000008000171e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000171e:	7139                	addi	sp,sp,-64
    80001720:	fc06                	sd	ra,56(sp)
    80001722:	f822                	sd	s0,48(sp)
    80001724:	f426                	sd	s1,40(sp)
    80001726:	f04a                	sd	s2,32(sp)
    80001728:	ec4e                	sd	s3,24(sp)
    8000172a:	e852                	sd	s4,16(sp)
    8000172c:	e456                	sd	s5,8(sp)
    8000172e:	0080                	addi	s0,sp,64
    80001730:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001732:	00008497          	auipc	s1,0x8
    80001736:	d4e48493          	addi	s1,s1,-690 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000173a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000173c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000173e:	0000e917          	auipc	s2,0xe
    80001742:	14290913          	addi	s2,s2,322 # 8000f880 <tickslock>
    80001746:	a811                	j	8000175a <wakeup+0x3c>
      }
      release(&p->lock);
    80001748:	8526                	mv	a0,s1
    8000174a:	00005097          	auipc	ra,0x5
    8000174e:	cfc080e7          	jalr	-772(ra) # 80006446 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001752:	19048493          	addi	s1,s1,400
    80001756:	03248663          	beq	s1,s2,80001782 <wakeup+0x64>
    if(p != myproc()){
    8000175a:	fffff097          	auipc	ra,0xfffff
    8000175e:	722080e7          	jalr	1826(ra) # 80000e7c <myproc>
    80001762:	fea488e3          	beq	s1,a0,80001752 <wakeup+0x34>
      acquire(&p->lock);
    80001766:	8526                	mv	a0,s1
    80001768:	00005097          	auipc	ra,0x5
    8000176c:	c2a080e7          	jalr	-982(ra) # 80006392 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001770:	4c9c                	lw	a5,24(s1)
    80001772:	fd379be3          	bne	a5,s3,80001748 <wakeup+0x2a>
    80001776:	709c                	ld	a5,32(s1)
    80001778:	fd4798e3          	bne	a5,s4,80001748 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000177c:	0154ac23          	sw	s5,24(s1)
    80001780:	b7e1                	j	80001748 <wakeup+0x2a>
    }
  }
}
    80001782:	70e2                	ld	ra,56(sp)
    80001784:	7442                	ld	s0,48(sp)
    80001786:	74a2                	ld	s1,40(sp)
    80001788:	7902                	ld	s2,32(sp)
    8000178a:	69e2                	ld	s3,24(sp)
    8000178c:	6a42                	ld	s4,16(sp)
    8000178e:	6aa2                	ld	s5,8(sp)
    80001790:	6121                	addi	sp,sp,64
    80001792:	8082                	ret

0000000080001794 <reparent>:
{
    80001794:	7179                	addi	sp,sp,-48
    80001796:	f406                	sd	ra,40(sp)
    80001798:	f022                	sd	s0,32(sp)
    8000179a:	ec26                	sd	s1,24(sp)
    8000179c:	e84a                	sd	s2,16(sp)
    8000179e:	e44e                	sd	s3,8(sp)
    800017a0:	e052                	sd	s4,0(sp)
    800017a2:	1800                	addi	s0,sp,48
    800017a4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017a6:	00008497          	auipc	s1,0x8
    800017aa:	cda48493          	addi	s1,s1,-806 # 80009480 <proc>
      pp->parent = initproc;
    800017ae:	00008a17          	auipc	s4,0x8
    800017b2:	862a0a13          	addi	s4,s4,-1950 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017b6:	0000e997          	auipc	s3,0xe
    800017ba:	0ca98993          	addi	s3,s3,202 # 8000f880 <tickslock>
    800017be:	a029                	j	800017c8 <reparent+0x34>
    800017c0:	19048493          	addi	s1,s1,400
    800017c4:	01348d63          	beq	s1,s3,800017de <reparent+0x4a>
    if(pp->parent == p){
    800017c8:	7c9c                	ld	a5,56(s1)
    800017ca:	ff279be3          	bne	a5,s2,800017c0 <reparent+0x2c>
      pp->parent = initproc;
    800017ce:	000a3503          	ld	a0,0(s4)
    800017d2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017d4:	00000097          	auipc	ra,0x0
    800017d8:	f4a080e7          	jalr	-182(ra) # 8000171e <wakeup>
    800017dc:	b7d5                	j	800017c0 <reparent+0x2c>
}
    800017de:	70a2                	ld	ra,40(sp)
    800017e0:	7402                	ld	s0,32(sp)
    800017e2:	64e2                	ld	s1,24(sp)
    800017e4:	6942                	ld	s2,16(sp)
    800017e6:	69a2                	ld	s3,8(sp)
    800017e8:	6a02                	ld	s4,0(sp)
    800017ea:	6145                	addi	sp,sp,48
    800017ec:	8082                	ret

00000000800017ee <exit>:
{
    800017ee:	7179                	addi	sp,sp,-48
    800017f0:	f406                	sd	ra,40(sp)
    800017f2:	f022                	sd	s0,32(sp)
    800017f4:	ec26                	sd	s1,24(sp)
    800017f6:	e84a                	sd	s2,16(sp)
    800017f8:	e44e                	sd	s3,8(sp)
    800017fa:	e052                	sd	s4,0(sp)
    800017fc:	1800                	addi	s0,sp,48
    800017fe:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001800:	fffff097          	auipc	ra,0xfffff
    80001804:	67c080e7          	jalr	1660(ra) # 80000e7c <myproc>
    80001808:	89aa                	mv	s3,a0
  if(p == initproc)
    8000180a:	00008797          	auipc	a5,0x8
    8000180e:	8067b783          	ld	a5,-2042(a5) # 80009010 <initproc>
    80001812:	0d050493          	addi	s1,a0,208
    80001816:	15050913          	addi	s2,a0,336
    8000181a:	02a79363          	bne	a5,a0,80001840 <exit+0x52>
    panic("init exiting");
    8000181e:	00007517          	auipc	a0,0x7
    80001822:	9c250513          	addi	a0,a0,-1598 # 800081e0 <etext+0x1e0>
    80001826:	00004097          	auipc	ra,0x4
    8000182a:	596080e7          	jalr	1430(ra) # 80005dbc <panic>
      fileclose(f);
    8000182e:	00002097          	auipc	ra,0x2
    80001832:	2b6080e7          	jalr	694(ra) # 80003ae4 <fileclose>
      p->ofile[fd] = 0;
    80001836:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000183a:	04a1                	addi	s1,s1,8
    8000183c:	01248563          	beq	s1,s2,80001846 <exit+0x58>
    if(p->ofile[fd]){
    80001840:	6088                	ld	a0,0(s1)
    80001842:	f575                	bnez	a0,8000182e <exit+0x40>
    80001844:	bfdd                	j	8000183a <exit+0x4c>
  begin_op();
    80001846:	00002097          	auipc	ra,0x2
    8000184a:	dd4080e7          	jalr	-556(ra) # 8000361a <begin_op>
  iput(p->cwd);
    8000184e:	1509b503          	ld	a0,336(s3)
    80001852:	00001097          	auipc	ra,0x1
    80001856:	5b4080e7          	jalr	1460(ra) # 80002e06 <iput>
  end_op();
    8000185a:	00002097          	auipc	ra,0x2
    8000185e:	e3a080e7          	jalr	-454(ra) # 80003694 <end_op>
  p->cwd = 0;
    80001862:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001866:	00008497          	auipc	s1,0x8
    8000186a:	80248493          	addi	s1,s1,-2046 # 80009068 <wait_lock>
    8000186e:	8526                	mv	a0,s1
    80001870:	00005097          	auipc	ra,0x5
    80001874:	b22080e7          	jalr	-1246(ra) # 80006392 <acquire>
  reparent(p);
    80001878:	854e                	mv	a0,s3
    8000187a:	00000097          	auipc	ra,0x0
    8000187e:	f1a080e7          	jalr	-230(ra) # 80001794 <reparent>
  wakeup(p->parent);
    80001882:	0389b503          	ld	a0,56(s3)
    80001886:	00000097          	auipc	ra,0x0
    8000188a:	e98080e7          	jalr	-360(ra) # 8000171e <wakeup>
  acquire(&p->lock);
    8000188e:	854e                	mv	a0,s3
    80001890:	00005097          	auipc	ra,0x5
    80001894:	b02080e7          	jalr	-1278(ra) # 80006392 <acquire>
  p->xstate = status;
    80001898:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000189c:	4795                	li	a5,5
    8000189e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018a2:	8526                	mv	a0,s1
    800018a4:	00005097          	auipc	ra,0x5
    800018a8:	ba2080e7          	jalr	-1118(ra) # 80006446 <release>
  sched();
    800018ac:	00000097          	auipc	ra,0x0
    800018b0:	bd4080e7          	jalr	-1068(ra) # 80001480 <sched>
  panic("zombie exit");
    800018b4:	00007517          	auipc	a0,0x7
    800018b8:	93c50513          	addi	a0,a0,-1732 # 800081f0 <etext+0x1f0>
    800018bc:	00004097          	auipc	ra,0x4
    800018c0:	500080e7          	jalr	1280(ra) # 80005dbc <panic>

00000000800018c4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018c4:	7179                	addi	sp,sp,-48
    800018c6:	f406                	sd	ra,40(sp)
    800018c8:	f022                	sd	s0,32(sp)
    800018ca:	ec26                	sd	s1,24(sp)
    800018cc:	e84a                	sd	s2,16(sp)
    800018ce:	e44e                	sd	s3,8(sp)
    800018d0:	1800                	addi	s0,sp,48
    800018d2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018d4:	00008497          	auipc	s1,0x8
    800018d8:	bac48493          	addi	s1,s1,-1108 # 80009480 <proc>
    800018dc:	0000e997          	auipc	s3,0xe
    800018e0:	fa498993          	addi	s3,s3,-92 # 8000f880 <tickslock>
    acquire(&p->lock);
    800018e4:	8526                	mv	a0,s1
    800018e6:	00005097          	auipc	ra,0x5
    800018ea:	aac080e7          	jalr	-1364(ra) # 80006392 <acquire>
    if(p->pid == pid){
    800018ee:	589c                	lw	a5,48(s1)
    800018f0:	01278d63          	beq	a5,s2,8000190a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018f4:	8526                	mv	a0,s1
    800018f6:	00005097          	auipc	ra,0x5
    800018fa:	b50080e7          	jalr	-1200(ra) # 80006446 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018fe:	19048493          	addi	s1,s1,400
    80001902:	ff3491e3          	bne	s1,s3,800018e4 <kill+0x20>
  }
  return -1;
    80001906:	557d                	li	a0,-1
    80001908:	a829                	j	80001922 <kill+0x5e>
      p->killed = 1;
    8000190a:	4785                	li	a5,1
    8000190c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000190e:	4c98                	lw	a4,24(s1)
    80001910:	4789                	li	a5,2
    80001912:	00f70f63          	beq	a4,a5,80001930 <kill+0x6c>
      release(&p->lock);
    80001916:	8526                	mv	a0,s1
    80001918:	00005097          	auipc	ra,0x5
    8000191c:	b2e080e7          	jalr	-1234(ra) # 80006446 <release>
      return 0;
    80001920:	4501                	li	a0,0
}
    80001922:	70a2                	ld	ra,40(sp)
    80001924:	7402                	ld	s0,32(sp)
    80001926:	64e2                	ld	s1,24(sp)
    80001928:	6942                	ld	s2,16(sp)
    8000192a:	69a2                	ld	s3,8(sp)
    8000192c:	6145                	addi	sp,sp,48
    8000192e:	8082                	ret
        p->state = RUNNABLE;
    80001930:	478d                	li	a5,3
    80001932:	cc9c                	sw	a5,24(s1)
    80001934:	b7cd                	j	80001916 <kill+0x52>

0000000080001936 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001936:	7179                	addi	sp,sp,-48
    80001938:	f406                	sd	ra,40(sp)
    8000193a:	f022                	sd	s0,32(sp)
    8000193c:	ec26                	sd	s1,24(sp)
    8000193e:	e84a                	sd	s2,16(sp)
    80001940:	e44e                	sd	s3,8(sp)
    80001942:	e052                	sd	s4,0(sp)
    80001944:	1800                	addi	s0,sp,48
    80001946:	84aa                	mv	s1,a0
    80001948:	892e                	mv	s2,a1
    8000194a:	89b2                	mv	s3,a2
    8000194c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	52e080e7          	jalr	1326(ra) # 80000e7c <myproc>
  if(user_dst){
    80001956:	c08d                	beqz	s1,80001978 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001958:	86d2                	mv	a3,s4
    8000195a:	864e                	mv	a2,s3
    8000195c:	85ca                	mv	a1,s2
    8000195e:	6928                	ld	a0,80(a0)
    80001960:	fffff097          	auipc	ra,0xfffff
    80001964:	1b8080e7          	jalr	440(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
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
    memmove((char *)dst, src, len);
    80001978:	000a061b          	sext.w	a2,s4
    8000197c:	85ce                	mv	a1,s3
    8000197e:	854a                	mv	a0,s2
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	856080e7          	jalr	-1962(ra) # 800001d6 <memmove>
    return 0;
    80001988:	8526                	mv	a0,s1
    8000198a:	bff9                	j	80001968 <either_copyout+0x32>

000000008000198c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000198c:	7179                	addi	sp,sp,-48
    8000198e:	f406                	sd	ra,40(sp)
    80001990:	f022                	sd	s0,32(sp)
    80001992:	ec26                	sd	s1,24(sp)
    80001994:	e84a                	sd	s2,16(sp)
    80001996:	e44e                	sd	s3,8(sp)
    80001998:	e052                	sd	s4,0(sp)
    8000199a:	1800                	addi	s0,sp,48
    8000199c:	892a                	mv	s2,a0
    8000199e:	84ae                	mv	s1,a1
    800019a0:	89b2                	mv	s3,a2
    800019a2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	4d8080e7          	jalr	1240(ra) # 80000e7c <myproc>
  if(user_src){
    800019ac:	c08d                	beqz	s1,800019ce <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019ae:	86d2                	mv	a3,s4
    800019b0:	864e                	mv	a2,s3
    800019b2:	85ca                	mv	a1,s2
    800019b4:	6928                	ld	a0,80(a0)
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	1ee080e7          	jalr	494(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019be:	70a2                	ld	ra,40(sp)
    800019c0:	7402                	ld	s0,32(sp)
    800019c2:	64e2                	ld	s1,24(sp)
    800019c4:	6942                	ld	s2,16(sp)
    800019c6:	69a2                	ld	s3,8(sp)
    800019c8:	6a02                	ld	s4,0(sp)
    800019ca:	6145                	addi	sp,sp,48
    800019cc:	8082                	ret
    memmove(dst, (char*)src, len);
    800019ce:	000a061b          	sext.w	a2,s4
    800019d2:	85ce                	mv	a1,s3
    800019d4:	854a                	mv	a0,s2
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	800080e7          	jalr	-2048(ra) # 800001d6 <memmove>
    return 0;
    800019de:	8526                	mv	a0,s1
    800019e0:	bff9                	j	800019be <either_copyin+0x32>

00000000800019e2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019e2:	715d                	addi	sp,sp,-80
    800019e4:	e486                	sd	ra,72(sp)
    800019e6:	e0a2                	sd	s0,64(sp)
    800019e8:	fc26                	sd	s1,56(sp)
    800019ea:	f84a                	sd	s2,48(sp)
    800019ec:	f44e                	sd	s3,40(sp)
    800019ee:	f052                	sd	s4,32(sp)
    800019f0:	ec56                	sd	s5,24(sp)
    800019f2:	e85a                	sd	s6,16(sp)
    800019f4:	e45e                	sd	s7,8(sp)
    800019f6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019f8:	00006517          	auipc	a0,0x6
    800019fc:	62050513          	addi	a0,a0,1568 # 80008018 <etext+0x18>
    80001a00:	00004097          	auipc	ra,0x4
    80001a04:	406080e7          	jalr	1030(ra) # 80005e06 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a08:	00008497          	auipc	s1,0x8
    80001a0c:	bd048493          	addi	s1,s1,-1072 # 800095d8 <proc+0x158>
    80001a10:	0000e917          	auipc	s2,0xe
    80001a14:	fc890913          	addi	s2,s2,-56 # 8000f9d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a18:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a1a:	00006997          	auipc	s3,0x6
    80001a1e:	7e698993          	addi	s3,s3,2022 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a22:	00006a97          	auipc	s5,0x6
    80001a26:	7e6a8a93          	addi	s5,s5,2022 # 80008208 <etext+0x208>
    printf("\n");
    80001a2a:	00006a17          	auipc	s4,0x6
    80001a2e:	5eea0a13          	addi	s4,s4,1518 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a32:	00007b97          	auipc	s7,0x7
    80001a36:	cd6b8b93          	addi	s7,s7,-810 # 80008708 <states.0>
    80001a3a:	a00d                	j	80001a5c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a3c:	ed86a583          	lw	a1,-296(a3)
    80001a40:	8556                	mv	a0,s5
    80001a42:	00004097          	auipc	ra,0x4
    80001a46:	3c4080e7          	jalr	964(ra) # 80005e06 <printf>
    printf("\n");
    80001a4a:	8552                	mv	a0,s4
    80001a4c:	00004097          	auipc	ra,0x4
    80001a50:	3ba080e7          	jalr	954(ra) # 80005e06 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a54:	19048493          	addi	s1,s1,400
    80001a58:	03248263          	beq	s1,s2,80001a7c <procdump+0x9a>
    if(p->state == UNUSED)
    80001a5c:	86a6                	mv	a3,s1
    80001a5e:	ec04a783          	lw	a5,-320(s1)
    80001a62:	dbed                	beqz	a5,80001a54 <procdump+0x72>
      state = "???";
    80001a64:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a66:	fcfb6be3          	bltu	s6,a5,80001a3c <procdump+0x5a>
    80001a6a:	02079713          	slli	a4,a5,0x20
    80001a6e:	01d75793          	srli	a5,a4,0x1d
    80001a72:	97de                	add	a5,a5,s7
    80001a74:	6390                	ld	a2,0(a5)
    80001a76:	f279                	bnez	a2,80001a3c <procdump+0x5a>
      state = "???";
    80001a78:	864e                	mv	a2,s3
    80001a7a:	b7c9                	j	80001a3c <procdump+0x5a>
  }
}
    80001a7c:	60a6                	ld	ra,72(sp)
    80001a7e:	6406                	ld	s0,64(sp)
    80001a80:	74e2                	ld	s1,56(sp)
    80001a82:	7942                	ld	s2,48(sp)
    80001a84:	79a2                	ld	s3,40(sp)
    80001a86:	7a02                	ld	s4,32(sp)
    80001a88:	6ae2                	ld	s5,24(sp)
    80001a8a:	6b42                	ld	s6,16(sp)
    80001a8c:	6ba2                	ld	s7,8(sp)
    80001a8e:	6161                	addi	sp,sp,80
    80001a90:	8082                	ret

0000000080001a92 <swtch>:
    80001a92:	00153023          	sd	ra,0(a0)
    80001a96:	00253423          	sd	sp,8(a0)
    80001a9a:	e900                	sd	s0,16(a0)
    80001a9c:	ed04                	sd	s1,24(a0)
    80001a9e:	03253023          	sd	s2,32(a0)
    80001aa2:	03353423          	sd	s3,40(a0)
    80001aa6:	03453823          	sd	s4,48(a0)
    80001aaa:	03553c23          	sd	s5,56(a0)
    80001aae:	05653023          	sd	s6,64(a0)
    80001ab2:	05753423          	sd	s7,72(a0)
    80001ab6:	05853823          	sd	s8,80(a0)
    80001aba:	05953c23          	sd	s9,88(a0)
    80001abe:	07a53023          	sd	s10,96(a0)
    80001ac2:	07b53423          	sd	s11,104(a0)
    80001ac6:	0005b083          	ld	ra,0(a1)
    80001aca:	0085b103          	ld	sp,8(a1)
    80001ace:	6980                	ld	s0,16(a1)
    80001ad0:	6d84                	ld	s1,24(a1)
    80001ad2:	0205b903          	ld	s2,32(a1)
    80001ad6:	0285b983          	ld	s3,40(a1)
    80001ada:	0305ba03          	ld	s4,48(a1)
    80001ade:	0385ba83          	ld	s5,56(a1)
    80001ae2:	0405bb03          	ld	s6,64(a1)
    80001ae6:	0485bb83          	ld	s7,72(a1)
    80001aea:	0505bc03          	ld	s8,80(a1)
    80001aee:	0585bc83          	ld	s9,88(a1)
    80001af2:	0605bd03          	ld	s10,96(a1)
    80001af6:	0685bd83          	ld	s11,104(a1)
    80001afa:	8082                	ret

0000000080001afc <sigalarm>:

extern int devintr();



int sigalarm(int ticks, void(*handler)()) {
    80001afc:	1101                	addi	sp,sp,-32
    80001afe:	ec06                	sd	ra,24(sp)
    80001b00:	e822                	sd	s0,16(sp)
    80001b02:	e426                	sd	s1,8(sp)
    80001b04:	e04a                	sd	s2,0(sp)
    80001b06:	1000                	addi	s0,sp,32
    80001b08:	84aa                	mv	s1,a0
    80001b0a:	892e                	mv	s2,a1
  // 设置 myproc 中的相关属性
  struct proc *p = myproc();
    80001b0c:	fffff097          	auipc	ra,0xfffff
    80001b10:	370080e7          	jalr	880(ra) # 80000e7c <myproc>
  p->alarm_interval = ticks;
    80001b14:	16952423          	sw	s1,360(a0)
  p->alarm_handler = handler;
    80001b18:	17253823          	sd	s2,368(a0)
  p->alarm_ticks = ticks;
    80001b1c:	16952c23          	sw	s1,376(a0)
  return 0;
}
    80001b20:	4501                	li	a0,0
    80001b22:	60e2                	ld	ra,24(sp)
    80001b24:	6442                	ld	s0,16(sp)
    80001b26:	64a2                	ld	s1,8(sp)
    80001b28:	6902                	ld	s2,0(sp)
    80001b2a:	6105                	addi	sp,sp,32
    80001b2c:	8082                	ret

0000000080001b2e <sigreturn>:

int sigreturn() {
    80001b2e:	1141                	addi	sp,sp,-16
    80001b30:	e406                	sd	ra,8(sp)
    80001b32:	e022                	sd	s0,0(sp)
    80001b34:	0800                	addi	s0,sp,16
  // 将 trapframe 恢复到时钟中断之前的状态，恢复原本正在执行的程序流
  struct proc *p = myproc();
    80001b36:	fffff097          	auipc	ra,0xfffff
    80001b3a:	346080e7          	jalr	838(ra) # 80000e7c <myproc>
  *p->trapframe = *p->alarm_trapframe;
    80001b3e:	18053683          	ld	a3,384(a0)
    80001b42:	87b6                	mv	a5,a3
    80001b44:	6d38                	ld	a4,88(a0)
    80001b46:	12068693          	addi	a3,a3,288
    80001b4a:	0007b883          	ld	a7,0(a5)
    80001b4e:	0087b803          	ld	a6,8(a5)
    80001b52:	6b8c                	ld	a1,16(a5)
    80001b54:	6f90                	ld	a2,24(a5)
    80001b56:	01173023          	sd	a7,0(a4)
    80001b5a:	01073423          	sd	a6,8(a4)
    80001b5e:	eb0c                	sd	a1,16(a4)
    80001b60:	ef10                	sd	a2,24(a4)
    80001b62:	02078793          	addi	a5,a5,32
    80001b66:	02070713          	addi	a4,a4,32
    80001b6a:	fed790e3          	bne	a5,a3,80001b4a <sigreturn+0x1c>
  p->alarm_goingoff = 0;
    80001b6e:	18052423          	sw	zero,392(a0)
  return 0;
}
    80001b72:	4501                	li	a0,0
    80001b74:	60a2                	ld	ra,8(sp)
    80001b76:	6402                	ld	s0,0(sp)
    80001b78:	0141                	addi	sp,sp,16
    80001b7a:	8082                	ret

0000000080001b7c <trapinit>:


void
trapinit(void)
{
    80001b7c:	1141                	addi	sp,sp,-16
    80001b7e:	e406                	sd	ra,8(sp)
    80001b80:	e022                	sd	s0,0(sp)
    80001b82:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b84:	00006597          	auipc	a1,0x6
    80001b88:	6bc58593          	addi	a1,a1,1724 # 80008240 <etext+0x240>
    80001b8c:	0000e517          	auipc	a0,0xe
    80001b90:	cf450513          	addi	a0,a0,-780 # 8000f880 <tickslock>
    80001b94:	00004097          	auipc	ra,0x4
    80001b98:	76e080e7          	jalr	1902(ra) # 80006302 <initlock>
}
    80001b9c:	60a2                	ld	ra,8(sp)
    80001b9e:	6402                	ld	s0,0(sp)
    80001ba0:	0141                	addi	sp,sp,16
    80001ba2:	8082                	ret

0000000080001ba4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ba4:	1141                	addi	sp,sp,-16
    80001ba6:	e422                	sd	s0,8(sp)
    80001ba8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001baa:	00003797          	auipc	a5,0x3
    80001bae:	62678793          	addi	a5,a5,1574 # 800051d0 <kernelvec>
    80001bb2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bb6:	6422                	ld	s0,8(sp)
    80001bb8:	0141                	addi	sp,sp,16
    80001bba:	8082                	ret

0000000080001bbc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bbc:	1141                	addi	sp,sp,-16
    80001bbe:	e406                	sd	ra,8(sp)
    80001bc0:	e022                	sd	s0,0(sp)
    80001bc2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bc4:	fffff097          	auipc	ra,0xfffff
    80001bc8:	2b8080e7          	jalr	696(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bcc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bd0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001bd6:	00005697          	auipc	a3,0x5
    80001bda:	42a68693          	addi	a3,a3,1066 # 80007000 <_trampoline>
    80001bde:	00005717          	auipc	a4,0x5
    80001be2:	42270713          	addi	a4,a4,1058 # 80007000 <_trampoline>
    80001be6:	8f15                	sub	a4,a4,a3
    80001be8:	040007b7          	lui	a5,0x4000
    80001bec:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bee:	07b2                	slli	a5,a5,0xc
    80001bf0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bf2:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bf6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bf8:	18002673          	csrr	a2,satp
    80001bfc:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bfe:	6d30                	ld	a2,88(a0)
    80001c00:	6138                	ld	a4,64(a0)
    80001c02:	6585                	lui	a1,0x1
    80001c04:	972e                	add	a4,a4,a1
    80001c06:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c08:	6d38                	ld	a4,88(a0)
    80001c0a:	00000617          	auipc	a2,0x0
    80001c0e:	14060613          	addi	a2,a2,320 # 80001d4a <usertrap>
    80001c12:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c14:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c16:	8612                	mv	a2,tp
    80001c18:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c1a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c1e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c22:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c26:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c2a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c2c:	6f18                	ld	a4,24(a4)
    80001c2e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c32:	692c                	ld	a1,80(a0)
    80001c34:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c36:	00005717          	auipc	a4,0x5
    80001c3a:	45a70713          	addi	a4,a4,1114 # 80007090 <userret>
    80001c3e:	8f15                	sub	a4,a4,a3
    80001c40:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c42:	577d                	li	a4,-1
    80001c44:	177e                	slli	a4,a4,0x3f
    80001c46:	8dd9                	or	a1,a1,a4
    80001c48:	02000537          	lui	a0,0x2000
    80001c4c:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c4e:	0536                	slli	a0,a0,0xd
    80001c50:	9782                	jalr	a5
}
    80001c52:	60a2                	ld	ra,8(sp)
    80001c54:	6402                	ld	s0,0(sp)
    80001c56:	0141                	addi	sp,sp,16
    80001c58:	8082                	ret

0000000080001c5a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c5a:	1101                	addi	sp,sp,-32
    80001c5c:	ec06                	sd	ra,24(sp)
    80001c5e:	e822                	sd	s0,16(sp)
    80001c60:	e426                	sd	s1,8(sp)
    80001c62:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c64:	0000e497          	auipc	s1,0xe
    80001c68:	c1c48493          	addi	s1,s1,-996 # 8000f880 <tickslock>
    80001c6c:	8526                	mv	a0,s1
    80001c6e:	00004097          	auipc	ra,0x4
    80001c72:	724080e7          	jalr	1828(ra) # 80006392 <acquire>
  ticks++;
    80001c76:	00007517          	auipc	a0,0x7
    80001c7a:	3a250513          	addi	a0,a0,930 # 80009018 <ticks>
    80001c7e:	411c                	lw	a5,0(a0)
    80001c80:	2785                	addiw	a5,a5,1
    80001c82:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c84:	00000097          	auipc	ra,0x0
    80001c88:	a9a080e7          	jalr	-1382(ra) # 8000171e <wakeup>
  release(&tickslock);
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	00004097          	auipc	ra,0x4
    80001c92:	7b8080e7          	jalr	1976(ra) # 80006446 <release>
}
    80001c96:	60e2                	ld	ra,24(sp)
    80001c98:	6442                	ld	s0,16(sp)
    80001c9a:	64a2                	ld	s1,8(sp)
    80001c9c:	6105                	addi	sp,sp,32
    80001c9e:	8082                	ret

0000000080001ca0 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ca0:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ca4:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001ca6:	0a07d163          	bgez	a5,80001d48 <devintr+0xa8>
{
    80001caa:	1101                	addi	sp,sp,-32
    80001cac:	ec06                	sd	ra,24(sp)
    80001cae:	e822                	sd	s0,16(sp)
    80001cb0:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001cb2:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001cb6:	46a5                	li	a3,9
    80001cb8:	00d70c63          	beq	a4,a3,80001cd0 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001cbc:	577d                	li	a4,-1
    80001cbe:	177e                	slli	a4,a4,0x3f
    80001cc0:	0705                	addi	a4,a4,1
    return 0;
    80001cc2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cc4:	06e78163          	beq	a5,a4,80001d26 <devintr+0x86>
  }
}
    80001cc8:	60e2                	ld	ra,24(sp)
    80001cca:	6442                	ld	s0,16(sp)
    80001ccc:	6105                	addi	sp,sp,32
    80001cce:	8082                	ret
    80001cd0:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001cd2:	00003097          	auipc	ra,0x3
    80001cd6:	60a080e7          	jalr	1546(ra) # 800052dc <plic_claim>
    80001cda:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cdc:	47a9                	li	a5,10
    80001cde:	00f50963          	beq	a0,a5,80001cf0 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001ce2:	4785                	li	a5,1
    80001ce4:	00f50b63          	beq	a0,a5,80001cfa <devintr+0x5a>
    return 1;
    80001ce8:	4505                	li	a0,1
    } else if(irq){
    80001cea:	ec89                	bnez	s1,80001d04 <devintr+0x64>
    80001cec:	64a2                	ld	s1,8(sp)
    80001cee:	bfe9                	j	80001cc8 <devintr+0x28>
      uartintr();
    80001cf0:	00004097          	auipc	ra,0x4
    80001cf4:	5c2080e7          	jalr	1474(ra) # 800062b2 <uartintr>
    if(irq)
    80001cf8:	a839                	j	80001d16 <devintr+0x76>
      virtio_disk_intr();
    80001cfa:	00004097          	auipc	ra,0x4
    80001cfe:	ab6080e7          	jalr	-1354(ra) # 800057b0 <virtio_disk_intr>
    if(irq)
    80001d02:	a811                	j	80001d16 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d04:	85a6                	mv	a1,s1
    80001d06:	00006517          	auipc	a0,0x6
    80001d0a:	54250513          	addi	a0,a0,1346 # 80008248 <etext+0x248>
    80001d0e:	00004097          	auipc	ra,0x4
    80001d12:	0f8080e7          	jalr	248(ra) # 80005e06 <printf>
      plic_complete(irq);
    80001d16:	8526                	mv	a0,s1
    80001d18:	00003097          	auipc	ra,0x3
    80001d1c:	5e8080e7          	jalr	1512(ra) # 80005300 <plic_complete>
    return 1;
    80001d20:	4505                	li	a0,1
    80001d22:	64a2                	ld	s1,8(sp)
    80001d24:	b755                	j	80001cc8 <devintr+0x28>
    if(cpuid() == 0){
    80001d26:	fffff097          	auipc	ra,0xfffff
    80001d2a:	12a080e7          	jalr	298(ra) # 80000e50 <cpuid>
    80001d2e:	c901                	beqz	a0,80001d3e <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d30:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d34:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d36:	14479073          	csrw	sip,a5
    return 2;
    80001d3a:	4509                	li	a0,2
    80001d3c:	b771                	j	80001cc8 <devintr+0x28>
      clockintr();
    80001d3e:	00000097          	auipc	ra,0x0
    80001d42:	f1c080e7          	jalr	-228(ra) # 80001c5a <clockintr>
    80001d46:	b7ed                	j	80001d30 <devintr+0x90>
}
    80001d48:	8082                	ret

0000000080001d4a <usertrap>:
{
    80001d4a:	1101                	addi	sp,sp,-32
    80001d4c:	ec06                	sd	ra,24(sp)
    80001d4e:	e822                	sd	s0,16(sp)
    80001d50:	e426                	sd	s1,8(sp)
    80001d52:	e04a                	sd	s2,0(sp)
    80001d54:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d56:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d5a:	1007f793          	andi	a5,a5,256
    80001d5e:	e3ad                	bnez	a5,80001dc0 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d60:	00003797          	auipc	a5,0x3
    80001d64:	47078793          	addi	a5,a5,1136 # 800051d0 <kernelvec>
    80001d68:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d6c:	fffff097          	auipc	ra,0xfffff
    80001d70:	110080e7          	jalr	272(ra) # 80000e7c <myproc>
    80001d74:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d76:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d78:	14102773          	csrr	a4,sepc
    80001d7c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d82:	47a1                	li	a5,8
    80001d84:	04f71c63          	bne	a4,a5,80001ddc <usertrap+0x92>
    if(p->killed)
    80001d88:	551c                	lw	a5,40(a0)
    80001d8a:	e3b9                	bnez	a5,80001dd0 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d8c:	6cb8                	ld	a4,88(s1)
    80001d8e:	6f1c                	ld	a5,24(a4)
    80001d90:	0791                	addi	a5,a5,4
    80001d92:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d98:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d9c:	10079073          	csrw	sstatus,a5
    syscall();
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	33e080e7          	jalr	830(ra) # 800020de <syscall>
  if(p->killed)
    80001da8:	549c                	lw	a5,40(s1)
    80001daa:	e7c5                	bnez	a5,80001e52 <usertrap+0x108>
  usertrapret();
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	e10080e7          	jalr	-496(ra) # 80001bbc <usertrapret>
}
    80001db4:	60e2                	ld	ra,24(sp)
    80001db6:	6442                	ld	s0,16(sp)
    80001db8:	64a2                	ld	s1,8(sp)
    80001dba:	6902                	ld	s2,0(sp)
    80001dbc:	6105                	addi	sp,sp,32
    80001dbe:	8082                	ret
    panic("usertrap: not from user mode");
    80001dc0:	00006517          	auipc	a0,0x6
    80001dc4:	4a850513          	addi	a0,a0,1192 # 80008268 <etext+0x268>
    80001dc8:	00004097          	auipc	ra,0x4
    80001dcc:	ff4080e7          	jalr	-12(ra) # 80005dbc <panic>
      exit(-1);
    80001dd0:	557d                	li	a0,-1
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	a1c080e7          	jalr	-1508(ra) # 800017ee <exit>
    80001dda:	bf4d                	j	80001d8c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	ec4080e7          	jalr	-316(ra) # 80001ca0 <devintr>
    80001de4:	892a                	mv	s2,a0
    80001de6:	c501                	beqz	a0,80001dee <usertrap+0xa4>
  if(p->killed)
    80001de8:	549c                	lw	a5,40(s1)
    80001dea:	c3a1                	beqz	a5,80001e2a <usertrap+0xe0>
    80001dec:	a815                	j	80001e20 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dee:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001df2:	5890                	lw	a2,48(s1)
    80001df4:	00006517          	auipc	a0,0x6
    80001df8:	49450513          	addi	a0,a0,1172 # 80008288 <etext+0x288>
    80001dfc:	00004097          	auipc	ra,0x4
    80001e00:	00a080e7          	jalr	10(ra) # 80005e06 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e04:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e08:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e0c:	00006517          	auipc	a0,0x6
    80001e10:	4ac50513          	addi	a0,a0,1196 # 800082b8 <etext+0x2b8>
    80001e14:	00004097          	auipc	ra,0x4
    80001e18:	ff2080e7          	jalr	-14(ra) # 80005e06 <printf>
    p->killed = 1;
    80001e1c:	4785                	li	a5,1
    80001e1e:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001e20:	557d                	li	a0,-1
    80001e22:	00000097          	auipc	ra,0x0
    80001e26:	9cc080e7          	jalr	-1588(ra) # 800017ee <exit>
  if(which_dev == 2) {
    80001e2a:	4789                	li	a5,2
    80001e2c:	f8f910e3          	bne	s2,a5,80001dac <usertrap+0x62>
    if(p->alarm_interval != 0) { // 如果设定了时钟事件
    80001e30:	1684a703          	lw	a4,360(s1)
    80001e34:	cb11                	beqz	a4,80001e48 <usertrap+0xfe>
      if(--p->alarm_ticks <= 0) { // 时钟倒计时 -1 tick，如果已经到达或超过设定的 tick 数
    80001e36:	1784a783          	lw	a5,376(s1)
    80001e3a:	37fd                	addiw	a5,a5,-1
    80001e3c:	0007869b          	sext.w	a3,a5
    80001e40:	16f4ac23          	sw	a5,376(s1)
    80001e44:	00d05963          	blez	a3,80001e56 <usertrap+0x10c>
    yield();
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	70e080e7          	jalr	1806(ra) # 80001556 <yield>
    80001e50:	bfb1                	j	80001dac <usertrap+0x62>
  int which_dev = 0;
    80001e52:	4901                	li	s2,0
    80001e54:	b7f1                	j	80001e20 <usertrap+0xd6>
        if(!p->alarm_goingoff) { // 确保没有时钟正在运行
    80001e56:	1884a783          	lw	a5,392(s1)
    80001e5a:	f7fd                	bnez	a5,80001e48 <usertrap+0xfe>
          p->alarm_ticks = p->alarm_interval;
    80001e5c:	16e4ac23          	sw	a4,376(s1)
          *p->alarm_trapframe = *p->trapframe; // backup trapframe
    80001e60:	6cb4                	ld	a3,88(s1)
    80001e62:	87b6                	mv	a5,a3
    80001e64:	1804b703          	ld	a4,384(s1)
    80001e68:	12068693          	addi	a3,a3,288
    80001e6c:	0007b803          	ld	a6,0(a5)
    80001e70:	6788                	ld	a0,8(a5)
    80001e72:	6b8c                	ld	a1,16(a5)
    80001e74:	6f90                	ld	a2,24(a5)
    80001e76:	01073023          	sd	a6,0(a4)
    80001e7a:	e708                	sd	a0,8(a4)
    80001e7c:	eb0c                	sd	a1,16(a4)
    80001e7e:	ef10                	sd	a2,24(a4)
    80001e80:	02078793          	addi	a5,a5,32
    80001e84:	02070713          	addi	a4,a4,32
    80001e88:	fed792e3          	bne	a5,a3,80001e6c <usertrap+0x122>
          p->trapframe->epc = (uint64)p->alarm_handler;
    80001e8c:	6cbc                	ld	a5,88(s1)
    80001e8e:	1704b703          	ld	a4,368(s1)
    80001e92:	ef98                	sd	a4,24(a5)
          p->alarm_goingoff = 1;
    80001e94:	4785                	li	a5,1
    80001e96:	18f4a423          	sw	a5,392(s1)
    80001e9a:	b77d                	j	80001e48 <usertrap+0xfe>

0000000080001e9c <kerneltrap>:
{
    80001e9c:	7179                	addi	sp,sp,-48
    80001e9e:	f406                	sd	ra,40(sp)
    80001ea0:	f022                	sd	s0,32(sp)
    80001ea2:	ec26                	sd	s1,24(sp)
    80001ea4:	e84a                	sd	s2,16(sp)
    80001ea6:	e44e                	sd	s3,8(sp)
    80001ea8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eaa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eae:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eb2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001eb6:	1004f793          	andi	a5,s1,256
    80001eba:	cb85                	beqz	a5,80001eea <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ebc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ec0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ec2:	ef85                	bnez	a5,80001efa <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ec4:	00000097          	auipc	ra,0x0
    80001ec8:	ddc080e7          	jalr	-548(ra) # 80001ca0 <devintr>
    80001ecc:	cd1d                	beqz	a0,80001f0a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ece:	4789                	li	a5,2
    80001ed0:	06f50a63          	beq	a0,a5,80001f44 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ed4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ed8:	10049073          	csrw	sstatus,s1
}
    80001edc:	70a2                	ld	ra,40(sp)
    80001ede:	7402                	ld	s0,32(sp)
    80001ee0:	64e2                	ld	s1,24(sp)
    80001ee2:	6942                	ld	s2,16(sp)
    80001ee4:	69a2                	ld	s3,8(sp)
    80001ee6:	6145                	addi	sp,sp,48
    80001ee8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001eea:	00006517          	auipc	a0,0x6
    80001eee:	3ee50513          	addi	a0,a0,1006 # 800082d8 <etext+0x2d8>
    80001ef2:	00004097          	auipc	ra,0x4
    80001ef6:	eca080e7          	jalr	-310(ra) # 80005dbc <panic>
    panic("kerneltrap: interrupts enabled");
    80001efa:	00006517          	auipc	a0,0x6
    80001efe:	40650513          	addi	a0,a0,1030 # 80008300 <etext+0x300>
    80001f02:	00004097          	auipc	ra,0x4
    80001f06:	eba080e7          	jalr	-326(ra) # 80005dbc <panic>
    printf("scause %p\n", scause);
    80001f0a:	85ce                	mv	a1,s3
    80001f0c:	00006517          	auipc	a0,0x6
    80001f10:	41450513          	addi	a0,a0,1044 # 80008320 <etext+0x320>
    80001f14:	00004097          	auipc	ra,0x4
    80001f18:	ef2080e7          	jalr	-270(ra) # 80005e06 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f1c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f20:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f24:	00006517          	auipc	a0,0x6
    80001f28:	40c50513          	addi	a0,a0,1036 # 80008330 <etext+0x330>
    80001f2c:	00004097          	auipc	ra,0x4
    80001f30:	eda080e7          	jalr	-294(ra) # 80005e06 <printf>
    panic("kerneltrap");
    80001f34:	00006517          	auipc	a0,0x6
    80001f38:	41450513          	addi	a0,a0,1044 # 80008348 <etext+0x348>
    80001f3c:	00004097          	auipc	ra,0x4
    80001f40:	e80080e7          	jalr	-384(ra) # 80005dbc <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	f38080e7          	jalr	-200(ra) # 80000e7c <myproc>
    80001f4c:	d541                	beqz	a0,80001ed4 <kerneltrap+0x38>
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	f2e080e7          	jalr	-210(ra) # 80000e7c <myproc>
    80001f56:	4d18                	lw	a4,24(a0)
    80001f58:	4791                	li	a5,4
    80001f5a:	f6f71de3          	bne	a4,a5,80001ed4 <kerneltrap+0x38>
    yield();
    80001f5e:	fffff097          	auipc	ra,0xfffff
    80001f62:	5f8080e7          	jalr	1528(ra) # 80001556 <yield>
    80001f66:	b7bd                	j	80001ed4 <kerneltrap+0x38>

0000000080001f68 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f68:	1101                	addi	sp,sp,-32
    80001f6a:	ec06                	sd	ra,24(sp)
    80001f6c:	e822                	sd	s0,16(sp)
    80001f6e:	e426                	sd	s1,8(sp)
    80001f70:	1000                	addi	s0,sp,32
    80001f72:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	f08080e7          	jalr	-248(ra) # 80000e7c <myproc>
  switch (n) {
    80001f7c:	4795                	li	a5,5
    80001f7e:	0497e163          	bltu	a5,s1,80001fc0 <argraw+0x58>
    80001f82:	048a                	slli	s1,s1,0x2
    80001f84:	00006717          	auipc	a4,0x6
    80001f88:	7b470713          	addi	a4,a4,1972 # 80008738 <states.0+0x30>
    80001f8c:	94ba                	add	s1,s1,a4
    80001f8e:	409c                	lw	a5,0(s1)
    80001f90:	97ba                	add	a5,a5,a4
    80001f92:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f94:	6d3c                	ld	a5,88(a0)
    80001f96:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f98:	60e2                	ld	ra,24(sp)
    80001f9a:	6442                	ld	s0,16(sp)
    80001f9c:	64a2                	ld	s1,8(sp)
    80001f9e:	6105                	addi	sp,sp,32
    80001fa0:	8082                	ret
    return p->trapframe->a1;
    80001fa2:	6d3c                	ld	a5,88(a0)
    80001fa4:	7fa8                	ld	a0,120(a5)
    80001fa6:	bfcd                	j	80001f98 <argraw+0x30>
    return p->trapframe->a2;
    80001fa8:	6d3c                	ld	a5,88(a0)
    80001faa:	63c8                	ld	a0,128(a5)
    80001fac:	b7f5                	j	80001f98 <argraw+0x30>
    return p->trapframe->a3;
    80001fae:	6d3c                	ld	a5,88(a0)
    80001fb0:	67c8                	ld	a0,136(a5)
    80001fb2:	b7dd                	j	80001f98 <argraw+0x30>
    return p->trapframe->a4;
    80001fb4:	6d3c                	ld	a5,88(a0)
    80001fb6:	6bc8                	ld	a0,144(a5)
    80001fb8:	b7c5                	j	80001f98 <argraw+0x30>
    return p->trapframe->a5;
    80001fba:	6d3c                	ld	a5,88(a0)
    80001fbc:	6fc8                	ld	a0,152(a5)
    80001fbe:	bfe9                	j	80001f98 <argraw+0x30>
  panic("argraw");
    80001fc0:	00006517          	auipc	a0,0x6
    80001fc4:	39850513          	addi	a0,a0,920 # 80008358 <etext+0x358>
    80001fc8:	00004097          	auipc	ra,0x4
    80001fcc:	df4080e7          	jalr	-524(ra) # 80005dbc <panic>

0000000080001fd0 <fetchaddr>:
{
    80001fd0:	1101                	addi	sp,sp,-32
    80001fd2:	ec06                	sd	ra,24(sp)
    80001fd4:	e822                	sd	s0,16(sp)
    80001fd6:	e426                	sd	s1,8(sp)
    80001fd8:	e04a                	sd	s2,0(sp)
    80001fda:	1000                	addi	s0,sp,32
    80001fdc:	84aa                	mv	s1,a0
    80001fde:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	e9c080e7          	jalr	-356(ra) # 80000e7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001fe8:	653c                	ld	a5,72(a0)
    80001fea:	02f4f863          	bgeu	s1,a5,8000201a <fetchaddr+0x4a>
    80001fee:	00848713          	addi	a4,s1,8
    80001ff2:	02e7e663          	bltu	a5,a4,8000201e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ff6:	46a1                	li	a3,8
    80001ff8:	8626                	mv	a2,s1
    80001ffa:	85ca                	mv	a1,s2
    80001ffc:	6928                	ld	a0,80(a0)
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	ba6080e7          	jalr	-1114(ra) # 80000ba4 <copyin>
    80002006:	00a03533          	snez	a0,a0
    8000200a:	40a00533          	neg	a0,a0
}
    8000200e:	60e2                	ld	ra,24(sp)
    80002010:	6442                	ld	s0,16(sp)
    80002012:	64a2                	ld	s1,8(sp)
    80002014:	6902                	ld	s2,0(sp)
    80002016:	6105                	addi	sp,sp,32
    80002018:	8082                	ret
    return -1;
    8000201a:	557d                	li	a0,-1
    8000201c:	bfcd                	j	8000200e <fetchaddr+0x3e>
    8000201e:	557d                	li	a0,-1
    80002020:	b7fd                	j	8000200e <fetchaddr+0x3e>

0000000080002022 <fetchstr>:
{
    80002022:	7179                	addi	sp,sp,-48
    80002024:	f406                	sd	ra,40(sp)
    80002026:	f022                	sd	s0,32(sp)
    80002028:	ec26                	sd	s1,24(sp)
    8000202a:	e84a                	sd	s2,16(sp)
    8000202c:	e44e                	sd	s3,8(sp)
    8000202e:	1800                	addi	s0,sp,48
    80002030:	892a                	mv	s2,a0
    80002032:	84ae                	mv	s1,a1
    80002034:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	e46080e7          	jalr	-442(ra) # 80000e7c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000203e:	86ce                	mv	a3,s3
    80002040:	864a                	mv	a2,s2
    80002042:	85a6                	mv	a1,s1
    80002044:	6928                	ld	a0,80(a0)
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	bec080e7          	jalr	-1044(ra) # 80000c32 <copyinstr>
  if(err < 0)
    8000204e:	00054763          	bltz	a0,8000205c <fetchstr+0x3a>
  return strlen(buf);
    80002052:	8526                	mv	a0,s1
    80002054:	ffffe097          	auipc	ra,0xffffe
    80002058:	29a080e7          	jalr	666(ra) # 800002ee <strlen>
}
    8000205c:	70a2                	ld	ra,40(sp)
    8000205e:	7402                	ld	s0,32(sp)
    80002060:	64e2                	ld	s1,24(sp)
    80002062:	6942                	ld	s2,16(sp)
    80002064:	69a2                	ld	s3,8(sp)
    80002066:	6145                	addi	sp,sp,48
    80002068:	8082                	ret

000000008000206a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000206a:	1101                	addi	sp,sp,-32
    8000206c:	ec06                	sd	ra,24(sp)
    8000206e:	e822                	sd	s0,16(sp)
    80002070:	e426                	sd	s1,8(sp)
    80002072:	1000                	addi	s0,sp,32
    80002074:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	ef2080e7          	jalr	-270(ra) # 80001f68 <argraw>
    8000207e:	c088                	sw	a0,0(s1)
  return 0;
}
    80002080:	4501                	li	a0,0
    80002082:	60e2                	ld	ra,24(sp)
    80002084:	6442                	ld	s0,16(sp)
    80002086:	64a2                	ld	s1,8(sp)
    80002088:	6105                	addi	sp,sp,32
    8000208a:	8082                	ret

000000008000208c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000208c:	1101                	addi	sp,sp,-32
    8000208e:	ec06                	sd	ra,24(sp)
    80002090:	e822                	sd	s0,16(sp)
    80002092:	e426                	sd	s1,8(sp)
    80002094:	1000                	addi	s0,sp,32
    80002096:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002098:	00000097          	auipc	ra,0x0
    8000209c:	ed0080e7          	jalr	-304(ra) # 80001f68 <argraw>
    800020a0:	e088                	sd	a0,0(s1)
  return 0;
}
    800020a2:	4501                	li	a0,0
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	64a2                	ld	s1,8(sp)
    800020aa:	6105                	addi	sp,sp,32
    800020ac:	8082                	ret

00000000800020ae <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	e426                	sd	s1,8(sp)
    800020b6:	e04a                	sd	s2,0(sp)
    800020b8:	1000                	addi	s0,sp,32
    800020ba:	84ae                	mv	s1,a1
    800020bc:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020be:	00000097          	auipc	ra,0x0
    800020c2:	eaa080e7          	jalr	-342(ra) # 80001f68 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020c6:	864a                	mv	a2,s2
    800020c8:	85a6                	mv	a1,s1
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	f58080e7          	jalr	-168(ra) # 80002022 <fetchstr>
}
    800020d2:	60e2                	ld	ra,24(sp)
    800020d4:	6442                	ld	s0,16(sp)
    800020d6:	64a2                	ld	s1,8(sp)
    800020d8:	6902                	ld	s2,0(sp)
    800020da:	6105                	addi	sp,sp,32
    800020dc:	8082                	ret

00000000800020de <syscall>:
};


void
syscall(void)
{
    800020de:	1101                	addi	sp,sp,-32
    800020e0:	ec06                	sd	ra,24(sp)
    800020e2:	e822                	sd	s0,16(sp)
    800020e4:	e426                	sd	s1,8(sp)
    800020e6:	e04a                	sd	s2,0(sp)
    800020e8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	d92080e7          	jalr	-622(ra) # 80000e7c <myproc>
    800020f2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020f4:	05853903          	ld	s2,88(a0)
    800020f8:	0a893783          	ld	a5,168(s2)
    800020fc:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002100:	37fd                	addiw	a5,a5,-1
    80002102:	4759                	li	a4,22
    80002104:	00f76f63          	bltu	a4,a5,80002122 <syscall+0x44>
    80002108:	00369713          	slli	a4,a3,0x3
    8000210c:	00006797          	auipc	a5,0x6
    80002110:	64478793          	addi	a5,a5,1604 # 80008750 <syscalls>
    80002114:	97ba                	add	a5,a5,a4
    80002116:	639c                	ld	a5,0(a5)
    80002118:	c789                	beqz	a5,80002122 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000211a:	9782                	jalr	a5
    8000211c:	06a93823          	sd	a0,112(s2)
    80002120:	a839                	j	8000213e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002122:	15848613          	addi	a2,s1,344
    80002126:	588c                	lw	a1,48(s1)
    80002128:	00006517          	auipc	a0,0x6
    8000212c:	23850513          	addi	a0,a0,568 # 80008360 <etext+0x360>
    80002130:	00004097          	auipc	ra,0x4
    80002134:	cd6080e7          	jalr	-810(ra) # 80005e06 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002138:	6cbc                	ld	a5,88(s1)
    8000213a:	577d                	li	a4,-1
    8000213c:	fbb8                	sd	a4,112(a5)
  }
}
    8000213e:	60e2                	ld	ra,24(sp)
    80002140:	6442                	ld	s0,16(sp)
    80002142:	64a2                	ld	s1,8(sp)
    80002144:	6902                	ld	s2,0(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret

000000008000214a <sys_sigalarm>:
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 
sys_sigalarm(void) {//add lab4
    8000214a:	1101                	addi	sp,sp,-32
    8000214c:	ec06                	sd	ra,24(sp)
    8000214e:	e822                	sd	s0,16(sp)
    80002150:	1000                	addi	s0,sp,32
  int n;
  uint64 fn;
  if(argint(0, &n) < 0)
    80002152:	fec40593          	addi	a1,s0,-20
    80002156:	4501                	li	a0,0
    80002158:	00000097          	auipc	ra,0x0
    8000215c:	f12080e7          	jalr	-238(ra) # 8000206a <argint>
    return -1;
    80002160:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002162:	02054563          	bltz	a0,8000218c <sys_sigalarm+0x42>
  if(argaddr(1, &fn) < 0)
    80002166:	fe040593          	addi	a1,s0,-32
    8000216a:	4505                	li	a0,1
    8000216c:	00000097          	auipc	ra,0x0
    80002170:	f20080e7          	jalr	-224(ra) # 8000208c <argaddr>
    return -1;
    80002174:	57fd                	li	a5,-1
  if(argaddr(1, &fn) < 0)
    80002176:	00054b63          	bltz	a0,8000218c <sys_sigalarm+0x42>
  
  return sigalarm(n, (void(*)())(fn));
    8000217a:	fe043583          	ld	a1,-32(s0)
    8000217e:	fec42503          	lw	a0,-20(s0)
    80002182:	00000097          	auipc	ra,0x0
    80002186:	97a080e7          	jalr	-1670(ra) # 80001afc <sigalarm>
    8000218a:	87aa                	mv	a5,a0
}
    8000218c:	853e                	mv	a0,a5
    8000218e:	60e2                	ld	ra,24(sp)
    80002190:	6442                	ld	s0,16(sp)
    80002192:	6105                	addi	sp,sp,32
    80002194:	8082                	ret

0000000080002196 <sys_sigreturn>:

uint64 
sys_sigreturn(void) {//add lab4
    80002196:	1141                	addi	sp,sp,-16
    80002198:	e406                	sd	ra,8(sp)
    8000219a:	e022                	sd	s0,0(sp)
    8000219c:	0800                	addi	s0,sp,16
	return sigreturn();
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	990080e7          	jalr	-1648(ra) # 80001b2e <sigreturn>
}
    800021a6:	60a2                	ld	ra,8(sp)
    800021a8:	6402                	ld	s0,0(sp)
    800021aa:	0141                	addi	sp,sp,16
    800021ac:	8082                	ret

00000000800021ae <sys_exit>:


uint64
sys_exit(void)
{
    800021ae:	1101                	addi	sp,sp,-32
    800021b0:	ec06                	sd	ra,24(sp)
    800021b2:	e822                	sd	s0,16(sp)
    800021b4:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021b6:	fec40593          	addi	a1,s0,-20
    800021ba:	4501                	li	a0,0
    800021bc:	00000097          	auipc	ra,0x0
    800021c0:	eae080e7          	jalr	-338(ra) # 8000206a <argint>
    return -1;
    800021c4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021c6:	00054963          	bltz	a0,800021d8 <sys_exit+0x2a>
  exit(n);
    800021ca:	fec42503          	lw	a0,-20(s0)
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	620080e7          	jalr	1568(ra) # 800017ee <exit>
  return 0;  // not reached
    800021d6:	4781                	li	a5,0
}
    800021d8:	853e                	mv	a0,a5
    800021da:	60e2                	ld	ra,24(sp)
    800021dc:	6442                	ld	s0,16(sp)
    800021de:	6105                	addi	sp,sp,32
    800021e0:	8082                	ret

00000000800021e2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021e2:	1141                	addi	sp,sp,-16
    800021e4:	e406                	sd	ra,8(sp)
    800021e6:	e022                	sd	s0,0(sp)
    800021e8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	c92080e7          	jalr	-878(ra) # 80000e7c <myproc>
}
    800021f2:	5908                	lw	a0,48(a0)
    800021f4:	60a2                	ld	ra,8(sp)
    800021f6:	6402                	ld	s0,0(sp)
    800021f8:	0141                	addi	sp,sp,16
    800021fa:	8082                	ret

00000000800021fc <sys_fork>:

uint64
sys_fork(void)
{
    800021fc:	1141                	addi	sp,sp,-16
    800021fe:	e406                	sd	ra,8(sp)
    80002200:	e022                	sd	s0,0(sp)
    80002202:	0800                	addi	s0,sp,16
  return fork();
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	09a080e7          	jalr	154(ra) # 8000129e <fork>
}
    8000220c:	60a2                	ld	ra,8(sp)
    8000220e:	6402                	ld	s0,0(sp)
    80002210:	0141                	addi	sp,sp,16
    80002212:	8082                	ret

0000000080002214 <sys_wait>:

uint64
sys_wait(void)
{
    80002214:	1101                	addi	sp,sp,-32
    80002216:	ec06                	sd	ra,24(sp)
    80002218:	e822                	sd	s0,16(sp)
    8000221a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000221c:	fe840593          	addi	a1,s0,-24
    80002220:	4501                	li	a0,0
    80002222:	00000097          	auipc	ra,0x0
    80002226:	e6a080e7          	jalr	-406(ra) # 8000208c <argaddr>
    8000222a:	87aa                	mv	a5,a0
    return -1;
    8000222c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000222e:	0007c863          	bltz	a5,8000223e <sys_wait+0x2a>
  return wait(p);
    80002232:	fe843503          	ld	a0,-24(s0)
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	3c0080e7          	jalr	960(ra) # 800015f6 <wait>
}
    8000223e:	60e2                	ld	ra,24(sp)
    80002240:	6442                	ld	s0,16(sp)
    80002242:	6105                	addi	sp,sp,32
    80002244:	8082                	ret

0000000080002246 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002246:	7179                	addi	sp,sp,-48
    80002248:	f406                	sd	ra,40(sp)
    8000224a:	f022                	sd	s0,32(sp)
    8000224c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000224e:	fdc40593          	addi	a1,s0,-36
    80002252:	4501                	li	a0,0
    80002254:	00000097          	auipc	ra,0x0
    80002258:	e16080e7          	jalr	-490(ra) # 8000206a <argint>
    8000225c:	87aa                	mv	a5,a0
    return -1;
    8000225e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002260:	0207c263          	bltz	a5,80002284 <sys_sbrk+0x3e>
    80002264:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	c16080e7          	jalr	-1002(ra) # 80000e7c <myproc>
    8000226e:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002270:	fdc42503          	lw	a0,-36(s0)
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	fb2080e7          	jalr	-78(ra) # 80001226 <growproc>
    8000227c:	00054863          	bltz	a0,8000228c <sys_sbrk+0x46>
    return -1;
  return addr;
    80002280:	8526                	mv	a0,s1
    80002282:	64e2                	ld	s1,24(sp)
}
    80002284:	70a2                	ld	ra,40(sp)
    80002286:	7402                	ld	s0,32(sp)
    80002288:	6145                	addi	sp,sp,48
    8000228a:	8082                	ret
    return -1;
    8000228c:	557d                	li	a0,-1
    8000228e:	64e2                	ld	s1,24(sp)
    80002290:	bfd5                	j	80002284 <sys_sbrk+0x3e>

0000000080002292 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002292:	7139                	addi	sp,sp,-64
    80002294:	fc06                	sd	ra,56(sp)
    80002296:	f822                	sd	s0,48(sp)
    80002298:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;
  
  
  
  backtrace();//add
    8000229a:	00004097          	auipc	ra,0x4
    8000229e:	da6080e7          	jalr	-602(ra) # 80006040 <backtrace>
  
  if(argint(0, &n) < 0)
    800022a2:	fcc40593          	addi	a1,s0,-52
    800022a6:	4501                	li	a0,0
    800022a8:	00000097          	auipc	ra,0x0
    800022ac:	dc2080e7          	jalr	-574(ra) # 8000206a <argint>
    return -1;
    800022b0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022b2:	06054b63          	bltz	a0,80002328 <sys_sleep+0x96>
    800022b6:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800022b8:	0000d517          	auipc	a0,0xd
    800022bc:	5c850513          	addi	a0,a0,1480 # 8000f880 <tickslock>
    800022c0:	00004097          	auipc	ra,0x4
    800022c4:	0d2080e7          	jalr	210(ra) # 80006392 <acquire>
  ticks0 = ticks;
    800022c8:	00007917          	auipc	s2,0x7
    800022cc:	d5092903          	lw	s2,-688(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022d0:	fcc42783          	lw	a5,-52(s0)
    800022d4:	c3a1                	beqz	a5,80002314 <sys_sleep+0x82>
    800022d6:	f426                	sd	s1,40(sp)
    800022d8:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022da:	0000d997          	auipc	s3,0xd
    800022de:	5a698993          	addi	s3,s3,1446 # 8000f880 <tickslock>
    800022e2:	00007497          	auipc	s1,0x7
    800022e6:	d3648493          	addi	s1,s1,-714 # 80009018 <ticks>
    if(myproc()->killed){
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	b92080e7          	jalr	-1134(ra) # 80000e7c <myproc>
    800022f2:	551c                	lw	a5,40(a0)
    800022f4:	ef9d                	bnez	a5,80002332 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    800022f6:	85ce                	mv	a1,s3
    800022f8:	8526                	mv	a0,s1
    800022fa:	fffff097          	auipc	ra,0xfffff
    800022fe:	298080e7          	jalr	664(ra) # 80001592 <sleep>
  while(ticks - ticks0 < n){
    80002302:	409c                	lw	a5,0(s1)
    80002304:	412787bb          	subw	a5,a5,s2
    80002308:	fcc42703          	lw	a4,-52(s0)
    8000230c:	fce7efe3          	bltu	a5,a4,800022ea <sys_sleep+0x58>
    80002310:	74a2                	ld	s1,40(sp)
    80002312:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002314:	0000d517          	auipc	a0,0xd
    80002318:	56c50513          	addi	a0,a0,1388 # 8000f880 <tickslock>
    8000231c:	00004097          	auipc	ra,0x4
    80002320:	12a080e7          	jalr	298(ra) # 80006446 <release>
  return 0;
    80002324:	4781                	li	a5,0
    80002326:	7902                	ld	s2,32(sp)
}
    80002328:	853e                	mv	a0,a5
    8000232a:	70e2                	ld	ra,56(sp)
    8000232c:	7442                	ld	s0,48(sp)
    8000232e:	6121                	addi	sp,sp,64
    80002330:	8082                	ret
      release(&tickslock);
    80002332:	0000d517          	auipc	a0,0xd
    80002336:	54e50513          	addi	a0,a0,1358 # 8000f880 <tickslock>
    8000233a:	00004097          	auipc	ra,0x4
    8000233e:	10c080e7          	jalr	268(ra) # 80006446 <release>
      return -1;
    80002342:	57fd                	li	a5,-1
    80002344:	74a2                	ld	s1,40(sp)
    80002346:	7902                	ld	s2,32(sp)
    80002348:	69e2                	ld	s3,24(sp)
    8000234a:	bff9                	j	80002328 <sys_sleep+0x96>

000000008000234c <sys_kill>:

uint64
sys_kill(void)
{
    8000234c:	1101                	addi	sp,sp,-32
    8000234e:	ec06                	sd	ra,24(sp)
    80002350:	e822                	sd	s0,16(sp)
    80002352:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002354:	fec40593          	addi	a1,s0,-20
    80002358:	4501                	li	a0,0
    8000235a:	00000097          	auipc	ra,0x0
    8000235e:	d10080e7          	jalr	-752(ra) # 8000206a <argint>
    80002362:	87aa                	mv	a5,a0
    return -1;
    80002364:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002366:	0007c863          	bltz	a5,80002376 <sys_kill+0x2a>
  return kill(pid);
    8000236a:	fec42503          	lw	a0,-20(s0)
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	556080e7          	jalr	1366(ra) # 800018c4 <kill>
}
    80002376:	60e2                	ld	ra,24(sp)
    80002378:	6442                	ld	s0,16(sp)
    8000237a:	6105                	addi	sp,sp,32
    8000237c:	8082                	ret

000000008000237e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000237e:	1101                	addi	sp,sp,-32
    80002380:	ec06                	sd	ra,24(sp)
    80002382:	e822                	sd	s0,16(sp)
    80002384:	e426                	sd	s1,8(sp)
    80002386:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002388:	0000d517          	auipc	a0,0xd
    8000238c:	4f850513          	addi	a0,a0,1272 # 8000f880 <tickslock>
    80002390:	00004097          	auipc	ra,0x4
    80002394:	002080e7          	jalr	2(ra) # 80006392 <acquire>
  xticks = ticks;
    80002398:	00007497          	auipc	s1,0x7
    8000239c:	c804a483          	lw	s1,-896(s1) # 80009018 <ticks>
  release(&tickslock);
    800023a0:	0000d517          	auipc	a0,0xd
    800023a4:	4e050513          	addi	a0,a0,1248 # 8000f880 <tickslock>
    800023a8:	00004097          	auipc	ra,0x4
    800023ac:	09e080e7          	jalr	158(ra) # 80006446 <release>
  return xticks;
}
    800023b0:	02049513          	slli	a0,s1,0x20
    800023b4:	9101                	srli	a0,a0,0x20
    800023b6:	60e2                	ld	ra,24(sp)
    800023b8:	6442                	ld	s0,16(sp)
    800023ba:	64a2                	ld	s1,8(sp)
    800023bc:	6105                	addi	sp,sp,32
    800023be:	8082                	ret

00000000800023c0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023c0:	7179                	addi	sp,sp,-48
    800023c2:	f406                	sd	ra,40(sp)
    800023c4:	f022                	sd	s0,32(sp)
    800023c6:	ec26                	sd	s1,24(sp)
    800023c8:	e84a                	sd	s2,16(sp)
    800023ca:	e44e                	sd	s3,8(sp)
    800023cc:	e052                	sd	s4,0(sp)
    800023ce:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023d0:	00006597          	auipc	a1,0x6
    800023d4:	fb058593          	addi	a1,a1,-80 # 80008380 <etext+0x380>
    800023d8:	0000d517          	auipc	a0,0xd
    800023dc:	4c050513          	addi	a0,a0,1216 # 8000f898 <bcache>
    800023e0:	00004097          	auipc	ra,0x4
    800023e4:	f22080e7          	jalr	-222(ra) # 80006302 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023e8:	00015797          	auipc	a5,0x15
    800023ec:	4b078793          	addi	a5,a5,1200 # 80017898 <bcache+0x8000>
    800023f0:	00015717          	auipc	a4,0x15
    800023f4:	71070713          	addi	a4,a4,1808 # 80017b00 <bcache+0x8268>
    800023f8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023fc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002400:	0000d497          	auipc	s1,0xd
    80002404:	4b048493          	addi	s1,s1,1200 # 8000f8b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002408:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000240a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000240c:	00006a17          	auipc	s4,0x6
    80002410:	f7ca0a13          	addi	s4,s4,-132 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    80002414:	2b893783          	ld	a5,696(s2)
    80002418:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000241a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000241e:	85d2                	mv	a1,s4
    80002420:	01048513          	addi	a0,s1,16
    80002424:	00001097          	auipc	ra,0x1
    80002428:	4b2080e7          	jalr	1202(ra) # 800038d6 <initsleeplock>
    bcache.head.next->prev = b;
    8000242c:	2b893783          	ld	a5,696(s2)
    80002430:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002432:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002436:	45848493          	addi	s1,s1,1112
    8000243a:	fd349de3          	bne	s1,s3,80002414 <binit+0x54>
  }
}
    8000243e:	70a2                	ld	ra,40(sp)
    80002440:	7402                	ld	s0,32(sp)
    80002442:	64e2                	ld	s1,24(sp)
    80002444:	6942                	ld	s2,16(sp)
    80002446:	69a2                	ld	s3,8(sp)
    80002448:	6a02                	ld	s4,0(sp)
    8000244a:	6145                	addi	sp,sp,48
    8000244c:	8082                	ret

000000008000244e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000244e:	7179                	addi	sp,sp,-48
    80002450:	f406                	sd	ra,40(sp)
    80002452:	f022                	sd	s0,32(sp)
    80002454:	ec26                	sd	s1,24(sp)
    80002456:	e84a                	sd	s2,16(sp)
    80002458:	e44e                	sd	s3,8(sp)
    8000245a:	1800                	addi	s0,sp,48
    8000245c:	892a                	mv	s2,a0
    8000245e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002460:	0000d517          	auipc	a0,0xd
    80002464:	43850513          	addi	a0,a0,1080 # 8000f898 <bcache>
    80002468:	00004097          	auipc	ra,0x4
    8000246c:	f2a080e7          	jalr	-214(ra) # 80006392 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002470:	00015497          	auipc	s1,0x15
    80002474:	6e04b483          	ld	s1,1760(s1) # 80017b50 <bcache+0x82b8>
    80002478:	00015797          	auipc	a5,0x15
    8000247c:	68878793          	addi	a5,a5,1672 # 80017b00 <bcache+0x8268>
    80002480:	02f48f63          	beq	s1,a5,800024be <bread+0x70>
    80002484:	873e                	mv	a4,a5
    80002486:	a021                	j	8000248e <bread+0x40>
    80002488:	68a4                	ld	s1,80(s1)
    8000248a:	02e48a63          	beq	s1,a4,800024be <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000248e:	449c                	lw	a5,8(s1)
    80002490:	ff279ce3          	bne	a5,s2,80002488 <bread+0x3a>
    80002494:	44dc                	lw	a5,12(s1)
    80002496:	ff3799e3          	bne	a5,s3,80002488 <bread+0x3a>
      b->refcnt++;
    8000249a:	40bc                	lw	a5,64(s1)
    8000249c:	2785                	addiw	a5,a5,1
    8000249e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024a0:	0000d517          	auipc	a0,0xd
    800024a4:	3f850513          	addi	a0,a0,1016 # 8000f898 <bcache>
    800024a8:	00004097          	auipc	ra,0x4
    800024ac:	f9e080e7          	jalr	-98(ra) # 80006446 <release>
      acquiresleep(&b->lock);
    800024b0:	01048513          	addi	a0,s1,16
    800024b4:	00001097          	auipc	ra,0x1
    800024b8:	45c080e7          	jalr	1116(ra) # 80003910 <acquiresleep>
      return b;
    800024bc:	a8b9                	j	8000251a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024be:	00015497          	auipc	s1,0x15
    800024c2:	68a4b483          	ld	s1,1674(s1) # 80017b48 <bcache+0x82b0>
    800024c6:	00015797          	auipc	a5,0x15
    800024ca:	63a78793          	addi	a5,a5,1594 # 80017b00 <bcache+0x8268>
    800024ce:	00f48863          	beq	s1,a5,800024de <bread+0x90>
    800024d2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024d4:	40bc                	lw	a5,64(s1)
    800024d6:	cf81                	beqz	a5,800024ee <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024d8:	64a4                	ld	s1,72(s1)
    800024da:	fee49de3          	bne	s1,a4,800024d4 <bread+0x86>
  panic("bget: no buffers");
    800024de:	00006517          	auipc	a0,0x6
    800024e2:	eb250513          	addi	a0,a0,-334 # 80008390 <etext+0x390>
    800024e6:	00004097          	auipc	ra,0x4
    800024ea:	8d6080e7          	jalr	-1834(ra) # 80005dbc <panic>
      b->dev = dev;
    800024ee:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024f2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024f6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024fa:	4785                	li	a5,1
    800024fc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024fe:	0000d517          	auipc	a0,0xd
    80002502:	39a50513          	addi	a0,a0,922 # 8000f898 <bcache>
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	f40080e7          	jalr	-192(ra) # 80006446 <release>
      acquiresleep(&b->lock);
    8000250e:	01048513          	addi	a0,s1,16
    80002512:	00001097          	auipc	ra,0x1
    80002516:	3fe080e7          	jalr	1022(ra) # 80003910 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000251a:	409c                	lw	a5,0(s1)
    8000251c:	cb89                	beqz	a5,8000252e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000251e:	8526                	mv	a0,s1
    80002520:	70a2                	ld	ra,40(sp)
    80002522:	7402                	ld	s0,32(sp)
    80002524:	64e2                	ld	s1,24(sp)
    80002526:	6942                	ld	s2,16(sp)
    80002528:	69a2                	ld	s3,8(sp)
    8000252a:	6145                	addi	sp,sp,48
    8000252c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000252e:	4581                	li	a1,0
    80002530:	8526                	mv	a0,s1
    80002532:	00003097          	auipc	ra,0x3
    80002536:	ff0080e7          	jalr	-16(ra) # 80005522 <virtio_disk_rw>
    b->valid = 1;
    8000253a:	4785                	li	a5,1
    8000253c:	c09c                	sw	a5,0(s1)
  return b;
    8000253e:	b7c5                	j	8000251e <bread+0xd0>

0000000080002540 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002540:	1101                	addi	sp,sp,-32
    80002542:	ec06                	sd	ra,24(sp)
    80002544:	e822                	sd	s0,16(sp)
    80002546:	e426                	sd	s1,8(sp)
    80002548:	1000                	addi	s0,sp,32
    8000254a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000254c:	0541                	addi	a0,a0,16
    8000254e:	00001097          	auipc	ra,0x1
    80002552:	45c080e7          	jalr	1116(ra) # 800039aa <holdingsleep>
    80002556:	cd01                	beqz	a0,8000256e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002558:	4585                	li	a1,1
    8000255a:	8526                	mv	a0,s1
    8000255c:	00003097          	auipc	ra,0x3
    80002560:	fc6080e7          	jalr	-58(ra) # 80005522 <virtio_disk_rw>
}
    80002564:	60e2                	ld	ra,24(sp)
    80002566:	6442                	ld	s0,16(sp)
    80002568:	64a2                	ld	s1,8(sp)
    8000256a:	6105                	addi	sp,sp,32
    8000256c:	8082                	ret
    panic("bwrite");
    8000256e:	00006517          	auipc	a0,0x6
    80002572:	e3a50513          	addi	a0,a0,-454 # 800083a8 <etext+0x3a8>
    80002576:	00004097          	auipc	ra,0x4
    8000257a:	846080e7          	jalr	-1978(ra) # 80005dbc <panic>

000000008000257e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000257e:	1101                	addi	sp,sp,-32
    80002580:	ec06                	sd	ra,24(sp)
    80002582:	e822                	sd	s0,16(sp)
    80002584:	e426                	sd	s1,8(sp)
    80002586:	e04a                	sd	s2,0(sp)
    80002588:	1000                	addi	s0,sp,32
    8000258a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000258c:	01050913          	addi	s2,a0,16
    80002590:	854a                	mv	a0,s2
    80002592:	00001097          	auipc	ra,0x1
    80002596:	418080e7          	jalr	1048(ra) # 800039aa <holdingsleep>
    8000259a:	c925                	beqz	a0,8000260a <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000259c:	854a                	mv	a0,s2
    8000259e:	00001097          	auipc	ra,0x1
    800025a2:	3c8080e7          	jalr	968(ra) # 80003966 <releasesleep>

  acquire(&bcache.lock);
    800025a6:	0000d517          	auipc	a0,0xd
    800025aa:	2f250513          	addi	a0,a0,754 # 8000f898 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	de4080e7          	jalr	-540(ra) # 80006392 <acquire>
  b->refcnt--;
    800025b6:	40bc                	lw	a5,64(s1)
    800025b8:	37fd                	addiw	a5,a5,-1
    800025ba:	0007871b          	sext.w	a4,a5
    800025be:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025c0:	e71d                	bnez	a4,800025ee <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025c2:	68b8                	ld	a4,80(s1)
    800025c4:	64bc                	ld	a5,72(s1)
    800025c6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800025c8:	68b8                	ld	a4,80(s1)
    800025ca:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025cc:	00015797          	auipc	a5,0x15
    800025d0:	2cc78793          	addi	a5,a5,716 # 80017898 <bcache+0x8000>
    800025d4:	2b87b703          	ld	a4,696(a5)
    800025d8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025da:	00015717          	auipc	a4,0x15
    800025de:	52670713          	addi	a4,a4,1318 # 80017b00 <bcache+0x8268>
    800025e2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025e4:	2b87b703          	ld	a4,696(a5)
    800025e8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025ea:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025ee:	0000d517          	auipc	a0,0xd
    800025f2:	2aa50513          	addi	a0,a0,682 # 8000f898 <bcache>
    800025f6:	00004097          	auipc	ra,0x4
    800025fa:	e50080e7          	jalr	-432(ra) # 80006446 <release>
}
    800025fe:	60e2                	ld	ra,24(sp)
    80002600:	6442                	ld	s0,16(sp)
    80002602:	64a2                	ld	s1,8(sp)
    80002604:	6902                	ld	s2,0(sp)
    80002606:	6105                	addi	sp,sp,32
    80002608:	8082                	ret
    panic("brelse");
    8000260a:	00006517          	auipc	a0,0x6
    8000260e:	da650513          	addi	a0,a0,-602 # 800083b0 <etext+0x3b0>
    80002612:	00003097          	auipc	ra,0x3
    80002616:	7aa080e7          	jalr	1962(ra) # 80005dbc <panic>

000000008000261a <bpin>:

void
bpin(struct buf *b) {
    8000261a:	1101                	addi	sp,sp,-32
    8000261c:	ec06                	sd	ra,24(sp)
    8000261e:	e822                	sd	s0,16(sp)
    80002620:	e426                	sd	s1,8(sp)
    80002622:	1000                	addi	s0,sp,32
    80002624:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002626:	0000d517          	auipc	a0,0xd
    8000262a:	27250513          	addi	a0,a0,626 # 8000f898 <bcache>
    8000262e:	00004097          	auipc	ra,0x4
    80002632:	d64080e7          	jalr	-668(ra) # 80006392 <acquire>
  b->refcnt++;
    80002636:	40bc                	lw	a5,64(s1)
    80002638:	2785                	addiw	a5,a5,1
    8000263a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000263c:	0000d517          	auipc	a0,0xd
    80002640:	25c50513          	addi	a0,a0,604 # 8000f898 <bcache>
    80002644:	00004097          	auipc	ra,0x4
    80002648:	e02080e7          	jalr	-510(ra) # 80006446 <release>
}
    8000264c:	60e2                	ld	ra,24(sp)
    8000264e:	6442                	ld	s0,16(sp)
    80002650:	64a2                	ld	s1,8(sp)
    80002652:	6105                	addi	sp,sp,32
    80002654:	8082                	ret

0000000080002656 <bunpin>:

void
bunpin(struct buf *b) {
    80002656:	1101                	addi	sp,sp,-32
    80002658:	ec06                	sd	ra,24(sp)
    8000265a:	e822                	sd	s0,16(sp)
    8000265c:	e426                	sd	s1,8(sp)
    8000265e:	1000                	addi	s0,sp,32
    80002660:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002662:	0000d517          	auipc	a0,0xd
    80002666:	23650513          	addi	a0,a0,566 # 8000f898 <bcache>
    8000266a:	00004097          	auipc	ra,0x4
    8000266e:	d28080e7          	jalr	-728(ra) # 80006392 <acquire>
  b->refcnt--;
    80002672:	40bc                	lw	a5,64(s1)
    80002674:	37fd                	addiw	a5,a5,-1
    80002676:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002678:	0000d517          	auipc	a0,0xd
    8000267c:	22050513          	addi	a0,a0,544 # 8000f898 <bcache>
    80002680:	00004097          	auipc	ra,0x4
    80002684:	dc6080e7          	jalr	-570(ra) # 80006446 <release>
}
    80002688:	60e2                	ld	ra,24(sp)
    8000268a:	6442                	ld	s0,16(sp)
    8000268c:	64a2                	ld	s1,8(sp)
    8000268e:	6105                	addi	sp,sp,32
    80002690:	8082                	ret

0000000080002692 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002692:	1101                	addi	sp,sp,-32
    80002694:	ec06                	sd	ra,24(sp)
    80002696:	e822                	sd	s0,16(sp)
    80002698:	e426                	sd	s1,8(sp)
    8000269a:	e04a                	sd	s2,0(sp)
    8000269c:	1000                	addi	s0,sp,32
    8000269e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026a0:	00d5d59b          	srliw	a1,a1,0xd
    800026a4:	00016797          	auipc	a5,0x16
    800026a8:	8d07a783          	lw	a5,-1840(a5) # 80017f74 <sb+0x1c>
    800026ac:	9dbd                	addw	a1,a1,a5
    800026ae:	00000097          	auipc	ra,0x0
    800026b2:	da0080e7          	jalr	-608(ra) # 8000244e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026b6:	0074f713          	andi	a4,s1,7
    800026ba:	4785                	li	a5,1
    800026bc:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026c0:	14ce                	slli	s1,s1,0x33
    800026c2:	90d9                	srli	s1,s1,0x36
    800026c4:	00950733          	add	a4,a0,s1
    800026c8:	05874703          	lbu	a4,88(a4)
    800026cc:	00e7f6b3          	and	a3,a5,a4
    800026d0:	c69d                	beqz	a3,800026fe <bfree+0x6c>
    800026d2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026d4:	94aa                	add	s1,s1,a0
    800026d6:	fff7c793          	not	a5,a5
    800026da:	8f7d                	and	a4,a4,a5
    800026dc:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026e0:	00001097          	auipc	ra,0x1
    800026e4:	112080e7          	jalr	274(ra) # 800037f2 <log_write>
  brelse(bp);
    800026e8:	854a                	mv	a0,s2
    800026ea:	00000097          	auipc	ra,0x0
    800026ee:	e94080e7          	jalr	-364(ra) # 8000257e <brelse>
}
    800026f2:	60e2                	ld	ra,24(sp)
    800026f4:	6442                	ld	s0,16(sp)
    800026f6:	64a2                	ld	s1,8(sp)
    800026f8:	6902                	ld	s2,0(sp)
    800026fa:	6105                	addi	sp,sp,32
    800026fc:	8082                	ret
    panic("freeing free block");
    800026fe:	00006517          	auipc	a0,0x6
    80002702:	cba50513          	addi	a0,a0,-838 # 800083b8 <etext+0x3b8>
    80002706:	00003097          	auipc	ra,0x3
    8000270a:	6b6080e7          	jalr	1718(ra) # 80005dbc <panic>

000000008000270e <balloc>:
{
    8000270e:	711d                	addi	sp,sp,-96
    80002710:	ec86                	sd	ra,88(sp)
    80002712:	e8a2                	sd	s0,80(sp)
    80002714:	e4a6                	sd	s1,72(sp)
    80002716:	e0ca                	sd	s2,64(sp)
    80002718:	fc4e                	sd	s3,56(sp)
    8000271a:	f852                	sd	s4,48(sp)
    8000271c:	f456                	sd	s5,40(sp)
    8000271e:	f05a                	sd	s6,32(sp)
    80002720:	ec5e                	sd	s7,24(sp)
    80002722:	e862                	sd	s8,16(sp)
    80002724:	e466                	sd	s9,8(sp)
    80002726:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002728:	00016797          	auipc	a5,0x16
    8000272c:	8347a783          	lw	a5,-1996(a5) # 80017f5c <sb+0x4>
    80002730:	cbc1                	beqz	a5,800027c0 <balloc+0xb2>
    80002732:	8baa                	mv	s7,a0
    80002734:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002736:	00016b17          	auipc	s6,0x16
    8000273a:	822b0b13          	addi	s6,s6,-2014 # 80017f58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000273e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002740:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002742:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002744:	6c89                	lui	s9,0x2
    80002746:	a831                	j	80002762 <balloc+0x54>
    brelse(bp);
    80002748:	854a                	mv	a0,s2
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	e34080e7          	jalr	-460(ra) # 8000257e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002752:	015c87bb          	addw	a5,s9,s5
    80002756:	00078a9b          	sext.w	s5,a5
    8000275a:	004b2703          	lw	a4,4(s6)
    8000275e:	06eaf163          	bgeu	s5,a4,800027c0 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002762:	41fad79b          	sraiw	a5,s5,0x1f
    80002766:	0137d79b          	srliw	a5,a5,0x13
    8000276a:	015787bb          	addw	a5,a5,s5
    8000276e:	40d7d79b          	sraiw	a5,a5,0xd
    80002772:	01cb2583          	lw	a1,28(s6)
    80002776:	9dbd                	addw	a1,a1,a5
    80002778:	855e                	mv	a0,s7
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	cd4080e7          	jalr	-812(ra) # 8000244e <bread>
    80002782:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002784:	004b2503          	lw	a0,4(s6)
    80002788:	000a849b          	sext.w	s1,s5
    8000278c:	8762                	mv	a4,s8
    8000278e:	faa4fde3          	bgeu	s1,a0,80002748 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002792:	00777693          	andi	a3,a4,7
    80002796:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000279a:	41f7579b          	sraiw	a5,a4,0x1f
    8000279e:	01d7d79b          	srliw	a5,a5,0x1d
    800027a2:	9fb9                	addw	a5,a5,a4
    800027a4:	4037d79b          	sraiw	a5,a5,0x3
    800027a8:	00f90633          	add	a2,s2,a5
    800027ac:	05864603          	lbu	a2,88(a2)
    800027b0:	00c6f5b3          	and	a1,a3,a2
    800027b4:	cd91                	beqz	a1,800027d0 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027b6:	2705                	addiw	a4,a4,1
    800027b8:	2485                	addiw	s1,s1,1
    800027ba:	fd471ae3          	bne	a4,s4,8000278e <balloc+0x80>
    800027be:	b769                	j	80002748 <balloc+0x3a>
  panic("balloc: out of blocks");
    800027c0:	00006517          	auipc	a0,0x6
    800027c4:	c1050513          	addi	a0,a0,-1008 # 800083d0 <etext+0x3d0>
    800027c8:	00003097          	auipc	ra,0x3
    800027cc:	5f4080e7          	jalr	1524(ra) # 80005dbc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027d0:	97ca                	add	a5,a5,s2
    800027d2:	8e55                	or	a2,a2,a3
    800027d4:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800027d8:	854a                	mv	a0,s2
    800027da:	00001097          	auipc	ra,0x1
    800027de:	018080e7          	jalr	24(ra) # 800037f2 <log_write>
        brelse(bp);
    800027e2:	854a                	mv	a0,s2
    800027e4:	00000097          	auipc	ra,0x0
    800027e8:	d9a080e7          	jalr	-614(ra) # 8000257e <brelse>
  bp = bread(dev, bno);
    800027ec:	85a6                	mv	a1,s1
    800027ee:	855e                	mv	a0,s7
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	c5e080e7          	jalr	-930(ra) # 8000244e <bread>
    800027f8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027fa:	40000613          	li	a2,1024
    800027fe:	4581                	li	a1,0
    80002800:	05850513          	addi	a0,a0,88
    80002804:	ffffe097          	auipc	ra,0xffffe
    80002808:	976080e7          	jalr	-1674(ra) # 8000017a <memset>
  log_write(bp);
    8000280c:	854a                	mv	a0,s2
    8000280e:	00001097          	auipc	ra,0x1
    80002812:	fe4080e7          	jalr	-28(ra) # 800037f2 <log_write>
  brelse(bp);
    80002816:	854a                	mv	a0,s2
    80002818:	00000097          	auipc	ra,0x0
    8000281c:	d66080e7          	jalr	-666(ra) # 8000257e <brelse>
}
    80002820:	8526                	mv	a0,s1
    80002822:	60e6                	ld	ra,88(sp)
    80002824:	6446                	ld	s0,80(sp)
    80002826:	64a6                	ld	s1,72(sp)
    80002828:	6906                	ld	s2,64(sp)
    8000282a:	79e2                	ld	s3,56(sp)
    8000282c:	7a42                	ld	s4,48(sp)
    8000282e:	7aa2                	ld	s5,40(sp)
    80002830:	7b02                	ld	s6,32(sp)
    80002832:	6be2                	ld	s7,24(sp)
    80002834:	6c42                	ld	s8,16(sp)
    80002836:	6ca2                	ld	s9,8(sp)
    80002838:	6125                	addi	sp,sp,96
    8000283a:	8082                	ret

000000008000283c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000283c:	7179                	addi	sp,sp,-48
    8000283e:	f406                	sd	ra,40(sp)
    80002840:	f022                	sd	s0,32(sp)
    80002842:	ec26                	sd	s1,24(sp)
    80002844:	e84a                	sd	s2,16(sp)
    80002846:	e44e                	sd	s3,8(sp)
    80002848:	1800                	addi	s0,sp,48
    8000284a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000284c:	47ad                	li	a5,11
    8000284e:	04b7ff63          	bgeu	a5,a1,800028ac <bmap+0x70>
    80002852:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002854:	ff45849b          	addiw	s1,a1,-12
    80002858:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000285c:	0ff00793          	li	a5,255
    80002860:	0ae7e463          	bltu	a5,a4,80002908 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002864:	08052583          	lw	a1,128(a0)
    80002868:	c5b5                	beqz	a1,800028d4 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000286a:	00092503          	lw	a0,0(s2)
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	be0080e7          	jalr	-1056(ra) # 8000244e <bread>
    80002876:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002878:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000287c:	02049713          	slli	a4,s1,0x20
    80002880:	01e75593          	srli	a1,a4,0x1e
    80002884:	00b784b3          	add	s1,a5,a1
    80002888:	0004a983          	lw	s3,0(s1)
    8000288c:	04098e63          	beqz	s3,800028e8 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002890:	8552                	mv	a0,s4
    80002892:	00000097          	auipc	ra,0x0
    80002896:	cec080e7          	jalr	-788(ra) # 8000257e <brelse>
    return addr;
    8000289a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000289c:	854e                	mv	a0,s3
    8000289e:	70a2                	ld	ra,40(sp)
    800028a0:	7402                	ld	s0,32(sp)
    800028a2:	64e2                	ld	s1,24(sp)
    800028a4:	6942                	ld	s2,16(sp)
    800028a6:	69a2                	ld	s3,8(sp)
    800028a8:	6145                	addi	sp,sp,48
    800028aa:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800028ac:	02059793          	slli	a5,a1,0x20
    800028b0:	01e7d593          	srli	a1,a5,0x1e
    800028b4:	00b504b3          	add	s1,a0,a1
    800028b8:	0504a983          	lw	s3,80(s1)
    800028bc:	fe0990e3          	bnez	s3,8000289c <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800028c0:	4108                	lw	a0,0(a0)
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	e4c080e7          	jalr	-436(ra) # 8000270e <balloc>
    800028ca:	0005099b          	sext.w	s3,a0
    800028ce:	0534a823          	sw	s3,80(s1)
    800028d2:	b7e9                	j	8000289c <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800028d4:	4108                	lw	a0,0(a0)
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	e38080e7          	jalr	-456(ra) # 8000270e <balloc>
    800028de:	0005059b          	sext.w	a1,a0
    800028e2:	08b92023          	sw	a1,128(s2)
    800028e6:	b751                	j	8000286a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800028e8:	00092503          	lw	a0,0(s2)
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	e22080e7          	jalr	-478(ra) # 8000270e <balloc>
    800028f4:	0005099b          	sext.w	s3,a0
    800028f8:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028fc:	8552                	mv	a0,s4
    800028fe:	00001097          	auipc	ra,0x1
    80002902:	ef4080e7          	jalr	-268(ra) # 800037f2 <log_write>
    80002906:	b769                	j	80002890 <bmap+0x54>
  panic("bmap: out of range");
    80002908:	00006517          	auipc	a0,0x6
    8000290c:	ae050513          	addi	a0,a0,-1312 # 800083e8 <etext+0x3e8>
    80002910:	00003097          	auipc	ra,0x3
    80002914:	4ac080e7          	jalr	1196(ra) # 80005dbc <panic>

0000000080002918 <iget>:
{
    80002918:	7179                	addi	sp,sp,-48
    8000291a:	f406                	sd	ra,40(sp)
    8000291c:	f022                	sd	s0,32(sp)
    8000291e:	ec26                	sd	s1,24(sp)
    80002920:	e84a                	sd	s2,16(sp)
    80002922:	e44e                	sd	s3,8(sp)
    80002924:	e052                	sd	s4,0(sp)
    80002926:	1800                	addi	s0,sp,48
    80002928:	89aa                	mv	s3,a0
    8000292a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000292c:	00015517          	auipc	a0,0x15
    80002930:	64c50513          	addi	a0,a0,1612 # 80017f78 <itable>
    80002934:	00004097          	auipc	ra,0x4
    80002938:	a5e080e7          	jalr	-1442(ra) # 80006392 <acquire>
  empty = 0;
    8000293c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000293e:	00015497          	auipc	s1,0x15
    80002942:	65248493          	addi	s1,s1,1618 # 80017f90 <itable+0x18>
    80002946:	00017697          	auipc	a3,0x17
    8000294a:	0da68693          	addi	a3,a3,218 # 80019a20 <log>
    8000294e:	a039                	j	8000295c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002950:	02090b63          	beqz	s2,80002986 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002954:	08848493          	addi	s1,s1,136
    80002958:	02d48a63          	beq	s1,a3,8000298c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000295c:	449c                	lw	a5,8(s1)
    8000295e:	fef059e3          	blez	a5,80002950 <iget+0x38>
    80002962:	4098                	lw	a4,0(s1)
    80002964:	ff3716e3          	bne	a4,s3,80002950 <iget+0x38>
    80002968:	40d8                	lw	a4,4(s1)
    8000296a:	ff4713e3          	bne	a4,s4,80002950 <iget+0x38>
      ip->ref++;
    8000296e:	2785                	addiw	a5,a5,1
    80002970:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002972:	00015517          	auipc	a0,0x15
    80002976:	60650513          	addi	a0,a0,1542 # 80017f78 <itable>
    8000297a:	00004097          	auipc	ra,0x4
    8000297e:	acc080e7          	jalr	-1332(ra) # 80006446 <release>
      return ip;
    80002982:	8926                	mv	s2,s1
    80002984:	a03d                	j	800029b2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002986:	f7f9                	bnez	a5,80002954 <iget+0x3c>
      empty = ip;
    80002988:	8926                	mv	s2,s1
    8000298a:	b7e9                	j	80002954 <iget+0x3c>
  if(empty == 0)
    8000298c:	02090c63          	beqz	s2,800029c4 <iget+0xac>
  ip->dev = dev;
    80002990:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002994:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002998:	4785                	li	a5,1
    8000299a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000299e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029a2:	00015517          	auipc	a0,0x15
    800029a6:	5d650513          	addi	a0,a0,1494 # 80017f78 <itable>
    800029aa:	00004097          	auipc	ra,0x4
    800029ae:	a9c080e7          	jalr	-1380(ra) # 80006446 <release>
}
    800029b2:	854a                	mv	a0,s2
    800029b4:	70a2                	ld	ra,40(sp)
    800029b6:	7402                	ld	s0,32(sp)
    800029b8:	64e2                	ld	s1,24(sp)
    800029ba:	6942                	ld	s2,16(sp)
    800029bc:	69a2                	ld	s3,8(sp)
    800029be:	6a02                	ld	s4,0(sp)
    800029c0:	6145                	addi	sp,sp,48
    800029c2:	8082                	ret
    panic("iget: no inodes");
    800029c4:	00006517          	auipc	a0,0x6
    800029c8:	a3c50513          	addi	a0,a0,-1476 # 80008400 <etext+0x400>
    800029cc:	00003097          	auipc	ra,0x3
    800029d0:	3f0080e7          	jalr	1008(ra) # 80005dbc <panic>

00000000800029d4 <fsinit>:
fsinit(int dev) {
    800029d4:	7179                	addi	sp,sp,-48
    800029d6:	f406                	sd	ra,40(sp)
    800029d8:	f022                	sd	s0,32(sp)
    800029da:	ec26                	sd	s1,24(sp)
    800029dc:	e84a                	sd	s2,16(sp)
    800029de:	e44e                	sd	s3,8(sp)
    800029e0:	1800                	addi	s0,sp,48
    800029e2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029e4:	4585                	li	a1,1
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	a68080e7          	jalr	-1432(ra) # 8000244e <bread>
    800029ee:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029f0:	00015997          	auipc	s3,0x15
    800029f4:	56898993          	addi	s3,s3,1384 # 80017f58 <sb>
    800029f8:	02000613          	li	a2,32
    800029fc:	05850593          	addi	a1,a0,88
    80002a00:	854e                	mv	a0,s3
    80002a02:	ffffd097          	auipc	ra,0xffffd
    80002a06:	7d4080e7          	jalr	2004(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a0a:	8526                	mv	a0,s1
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	b72080e7          	jalr	-1166(ra) # 8000257e <brelse>
  if(sb.magic != FSMAGIC)
    80002a14:	0009a703          	lw	a4,0(s3)
    80002a18:	102037b7          	lui	a5,0x10203
    80002a1c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a20:	02f71263          	bne	a4,a5,80002a44 <fsinit+0x70>
  initlog(dev, &sb);
    80002a24:	00015597          	auipc	a1,0x15
    80002a28:	53458593          	addi	a1,a1,1332 # 80017f58 <sb>
    80002a2c:	854a                	mv	a0,s2
    80002a2e:	00001097          	auipc	ra,0x1
    80002a32:	b54080e7          	jalr	-1196(ra) # 80003582 <initlog>
}
    80002a36:	70a2                	ld	ra,40(sp)
    80002a38:	7402                	ld	s0,32(sp)
    80002a3a:	64e2                	ld	s1,24(sp)
    80002a3c:	6942                	ld	s2,16(sp)
    80002a3e:	69a2                	ld	s3,8(sp)
    80002a40:	6145                	addi	sp,sp,48
    80002a42:	8082                	ret
    panic("invalid file system");
    80002a44:	00006517          	auipc	a0,0x6
    80002a48:	9cc50513          	addi	a0,a0,-1588 # 80008410 <etext+0x410>
    80002a4c:	00003097          	auipc	ra,0x3
    80002a50:	370080e7          	jalr	880(ra) # 80005dbc <panic>

0000000080002a54 <iinit>:
{
    80002a54:	7179                	addi	sp,sp,-48
    80002a56:	f406                	sd	ra,40(sp)
    80002a58:	f022                	sd	s0,32(sp)
    80002a5a:	ec26                	sd	s1,24(sp)
    80002a5c:	e84a                	sd	s2,16(sp)
    80002a5e:	e44e                	sd	s3,8(sp)
    80002a60:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a62:	00006597          	auipc	a1,0x6
    80002a66:	9c658593          	addi	a1,a1,-1594 # 80008428 <etext+0x428>
    80002a6a:	00015517          	auipc	a0,0x15
    80002a6e:	50e50513          	addi	a0,a0,1294 # 80017f78 <itable>
    80002a72:	00004097          	auipc	ra,0x4
    80002a76:	890080e7          	jalr	-1904(ra) # 80006302 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a7a:	00015497          	auipc	s1,0x15
    80002a7e:	52648493          	addi	s1,s1,1318 # 80017fa0 <itable+0x28>
    80002a82:	00017997          	auipc	s3,0x17
    80002a86:	fae98993          	addi	s3,s3,-82 # 80019a30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a8a:	00006917          	auipc	s2,0x6
    80002a8e:	9a690913          	addi	s2,s2,-1626 # 80008430 <etext+0x430>
    80002a92:	85ca                	mv	a1,s2
    80002a94:	8526                	mv	a0,s1
    80002a96:	00001097          	auipc	ra,0x1
    80002a9a:	e40080e7          	jalr	-448(ra) # 800038d6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a9e:	08848493          	addi	s1,s1,136
    80002aa2:	ff3498e3          	bne	s1,s3,80002a92 <iinit+0x3e>
}
    80002aa6:	70a2                	ld	ra,40(sp)
    80002aa8:	7402                	ld	s0,32(sp)
    80002aaa:	64e2                	ld	s1,24(sp)
    80002aac:	6942                	ld	s2,16(sp)
    80002aae:	69a2                	ld	s3,8(sp)
    80002ab0:	6145                	addi	sp,sp,48
    80002ab2:	8082                	ret

0000000080002ab4 <ialloc>:
{
    80002ab4:	7139                	addi	sp,sp,-64
    80002ab6:	fc06                	sd	ra,56(sp)
    80002ab8:	f822                	sd	s0,48(sp)
    80002aba:	f426                	sd	s1,40(sp)
    80002abc:	f04a                	sd	s2,32(sp)
    80002abe:	ec4e                	sd	s3,24(sp)
    80002ac0:	e852                	sd	s4,16(sp)
    80002ac2:	e456                	sd	s5,8(sp)
    80002ac4:	e05a                	sd	s6,0(sp)
    80002ac6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ac8:	00015717          	auipc	a4,0x15
    80002acc:	49c72703          	lw	a4,1180(a4) # 80017f64 <sb+0xc>
    80002ad0:	4785                	li	a5,1
    80002ad2:	04e7f863          	bgeu	a5,a4,80002b22 <ialloc+0x6e>
    80002ad6:	8aaa                	mv	s5,a0
    80002ad8:	8b2e                	mv	s6,a1
    80002ada:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002adc:	00015a17          	auipc	s4,0x15
    80002ae0:	47ca0a13          	addi	s4,s4,1148 # 80017f58 <sb>
    80002ae4:	00495593          	srli	a1,s2,0x4
    80002ae8:	018a2783          	lw	a5,24(s4)
    80002aec:	9dbd                	addw	a1,a1,a5
    80002aee:	8556                	mv	a0,s5
    80002af0:	00000097          	auipc	ra,0x0
    80002af4:	95e080e7          	jalr	-1698(ra) # 8000244e <bread>
    80002af8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002afa:	05850993          	addi	s3,a0,88
    80002afe:	00f97793          	andi	a5,s2,15
    80002b02:	079a                	slli	a5,a5,0x6
    80002b04:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b06:	00099783          	lh	a5,0(s3)
    80002b0a:	c785                	beqz	a5,80002b32 <ialloc+0x7e>
    brelse(bp);
    80002b0c:	00000097          	auipc	ra,0x0
    80002b10:	a72080e7          	jalr	-1422(ra) # 8000257e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b14:	0905                	addi	s2,s2,1
    80002b16:	00ca2703          	lw	a4,12(s4)
    80002b1a:	0009079b          	sext.w	a5,s2
    80002b1e:	fce7e3e3          	bltu	a5,a4,80002ae4 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002b22:	00006517          	auipc	a0,0x6
    80002b26:	91650513          	addi	a0,a0,-1770 # 80008438 <etext+0x438>
    80002b2a:	00003097          	auipc	ra,0x3
    80002b2e:	292080e7          	jalr	658(ra) # 80005dbc <panic>
      memset(dip, 0, sizeof(*dip));
    80002b32:	04000613          	li	a2,64
    80002b36:	4581                	li	a1,0
    80002b38:	854e                	mv	a0,s3
    80002b3a:	ffffd097          	auipc	ra,0xffffd
    80002b3e:	640080e7          	jalr	1600(ra) # 8000017a <memset>
      dip->type = type;
    80002b42:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b46:	8526                	mv	a0,s1
    80002b48:	00001097          	auipc	ra,0x1
    80002b4c:	caa080e7          	jalr	-854(ra) # 800037f2 <log_write>
      brelse(bp);
    80002b50:	8526                	mv	a0,s1
    80002b52:	00000097          	auipc	ra,0x0
    80002b56:	a2c080e7          	jalr	-1492(ra) # 8000257e <brelse>
      return iget(dev, inum);
    80002b5a:	0009059b          	sext.w	a1,s2
    80002b5e:	8556                	mv	a0,s5
    80002b60:	00000097          	auipc	ra,0x0
    80002b64:	db8080e7          	jalr	-584(ra) # 80002918 <iget>
}
    80002b68:	70e2                	ld	ra,56(sp)
    80002b6a:	7442                	ld	s0,48(sp)
    80002b6c:	74a2                	ld	s1,40(sp)
    80002b6e:	7902                	ld	s2,32(sp)
    80002b70:	69e2                	ld	s3,24(sp)
    80002b72:	6a42                	ld	s4,16(sp)
    80002b74:	6aa2                	ld	s5,8(sp)
    80002b76:	6b02                	ld	s6,0(sp)
    80002b78:	6121                	addi	sp,sp,64
    80002b7a:	8082                	ret

0000000080002b7c <iupdate>:
{
    80002b7c:	1101                	addi	sp,sp,-32
    80002b7e:	ec06                	sd	ra,24(sp)
    80002b80:	e822                	sd	s0,16(sp)
    80002b82:	e426                	sd	s1,8(sp)
    80002b84:	e04a                	sd	s2,0(sp)
    80002b86:	1000                	addi	s0,sp,32
    80002b88:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b8a:	415c                	lw	a5,4(a0)
    80002b8c:	0047d79b          	srliw	a5,a5,0x4
    80002b90:	00015597          	auipc	a1,0x15
    80002b94:	3e05a583          	lw	a1,992(a1) # 80017f70 <sb+0x18>
    80002b98:	9dbd                	addw	a1,a1,a5
    80002b9a:	4108                	lw	a0,0(a0)
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	8b2080e7          	jalr	-1870(ra) # 8000244e <bread>
    80002ba4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ba6:	05850793          	addi	a5,a0,88
    80002baa:	40d8                	lw	a4,4(s1)
    80002bac:	8b3d                	andi	a4,a4,15
    80002bae:	071a                	slli	a4,a4,0x6
    80002bb0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bb2:	04449703          	lh	a4,68(s1)
    80002bb6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bba:	04649703          	lh	a4,70(s1)
    80002bbe:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002bc2:	04849703          	lh	a4,72(s1)
    80002bc6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002bca:	04a49703          	lh	a4,74(s1)
    80002bce:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002bd2:	44f8                	lw	a4,76(s1)
    80002bd4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bd6:	03400613          	li	a2,52
    80002bda:	05048593          	addi	a1,s1,80
    80002bde:	00c78513          	addi	a0,a5,12
    80002be2:	ffffd097          	auipc	ra,0xffffd
    80002be6:	5f4080e7          	jalr	1524(ra) # 800001d6 <memmove>
  log_write(bp);
    80002bea:	854a                	mv	a0,s2
    80002bec:	00001097          	auipc	ra,0x1
    80002bf0:	c06080e7          	jalr	-1018(ra) # 800037f2 <log_write>
  brelse(bp);
    80002bf4:	854a                	mv	a0,s2
    80002bf6:	00000097          	auipc	ra,0x0
    80002bfa:	988080e7          	jalr	-1656(ra) # 8000257e <brelse>
}
    80002bfe:	60e2                	ld	ra,24(sp)
    80002c00:	6442                	ld	s0,16(sp)
    80002c02:	64a2                	ld	s1,8(sp)
    80002c04:	6902                	ld	s2,0(sp)
    80002c06:	6105                	addi	sp,sp,32
    80002c08:	8082                	ret

0000000080002c0a <idup>:
{
    80002c0a:	1101                	addi	sp,sp,-32
    80002c0c:	ec06                	sd	ra,24(sp)
    80002c0e:	e822                	sd	s0,16(sp)
    80002c10:	e426                	sd	s1,8(sp)
    80002c12:	1000                	addi	s0,sp,32
    80002c14:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c16:	00015517          	auipc	a0,0x15
    80002c1a:	36250513          	addi	a0,a0,866 # 80017f78 <itable>
    80002c1e:	00003097          	auipc	ra,0x3
    80002c22:	774080e7          	jalr	1908(ra) # 80006392 <acquire>
  ip->ref++;
    80002c26:	449c                	lw	a5,8(s1)
    80002c28:	2785                	addiw	a5,a5,1
    80002c2a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c2c:	00015517          	auipc	a0,0x15
    80002c30:	34c50513          	addi	a0,a0,844 # 80017f78 <itable>
    80002c34:	00004097          	auipc	ra,0x4
    80002c38:	812080e7          	jalr	-2030(ra) # 80006446 <release>
}
    80002c3c:	8526                	mv	a0,s1
    80002c3e:	60e2                	ld	ra,24(sp)
    80002c40:	6442                	ld	s0,16(sp)
    80002c42:	64a2                	ld	s1,8(sp)
    80002c44:	6105                	addi	sp,sp,32
    80002c46:	8082                	ret

0000000080002c48 <ilock>:
{
    80002c48:	1101                	addi	sp,sp,-32
    80002c4a:	ec06                	sd	ra,24(sp)
    80002c4c:	e822                	sd	s0,16(sp)
    80002c4e:	e426                	sd	s1,8(sp)
    80002c50:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c52:	c10d                	beqz	a0,80002c74 <ilock+0x2c>
    80002c54:	84aa                	mv	s1,a0
    80002c56:	451c                	lw	a5,8(a0)
    80002c58:	00f05e63          	blez	a5,80002c74 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c5c:	0541                	addi	a0,a0,16
    80002c5e:	00001097          	auipc	ra,0x1
    80002c62:	cb2080e7          	jalr	-846(ra) # 80003910 <acquiresleep>
  if(ip->valid == 0){
    80002c66:	40bc                	lw	a5,64(s1)
    80002c68:	cf99                	beqz	a5,80002c86 <ilock+0x3e>
}
    80002c6a:	60e2                	ld	ra,24(sp)
    80002c6c:	6442                	ld	s0,16(sp)
    80002c6e:	64a2                	ld	s1,8(sp)
    80002c70:	6105                	addi	sp,sp,32
    80002c72:	8082                	ret
    80002c74:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002c76:	00005517          	auipc	a0,0x5
    80002c7a:	7da50513          	addi	a0,a0,2010 # 80008450 <etext+0x450>
    80002c7e:	00003097          	auipc	ra,0x3
    80002c82:	13e080e7          	jalr	318(ra) # 80005dbc <panic>
    80002c86:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c88:	40dc                	lw	a5,4(s1)
    80002c8a:	0047d79b          	srliw	a5,a5,0x4
    80002c8e:	00015597          	auipc	a1,0x15
    80002c92:	2e25a583          	lw	a1,738(a1) # 80017f70 <sb+0x18>
    80002c96:	9dbd                	addw	a1,a1,a5
    80002c98:	4088                	lw	a0,0(s1)
    80002c9a:	fffff097          	auipc	ra,0xfffff
    80002c9e:	7b4080e7          	jalr	1972(ra) # 8000244e <bread>
    80002ca2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ca4:	05850593          	addi	a1,a0,88
    80002ca8:	40dc                	lw	a5,4(s1)
    80002caa:	8bbd                	andi	a5,a5,15
    80002cac:	079a                	slli	a5,a5,0x6
    80002cae:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cb0:	00059783          	lh	a5,0(a1)
    80002cb4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cb8:	00259783          	lh	a5,2(a1)
    80002cbc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cc0:	00459783          	lh	a5,4(a1)
    80002cc4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cc8:	00659783          	lh	a5,6(a1)
    80002ccc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cd0:	459c                	lw	a5,8(a1)
    80002cd2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cd4:	03400613          	li	a2,52
    80002cd8:	05b1                	addi	a1,a1,12
    80002cda:	05048513          	addi	a0,s1,80
    80002cde:	ffffd097          	auipc	ra,0xffffd
    80002ce2:	4f8080e7          	jalr	1272(ra) # 800001d6 <memmove>
    brelse(bp);
    80002ce6:	854a                	mv	a0,s2
    80002ce8:	00000097          	auipc	ra,0x0
    80002cec:	896080e7          	jalr	-1898(ra) # 8000257e <brelse>
    ip->valid = 1;
    80002cf0:	4785                	li	a5,1
    80002cf2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cf4:	04449783          	lh	a5,68(s1)
    80002cf8:	c399                	beqz	a5,80002cfe <ilock+0xb6>
    80002cfa:	6902                	ld	s2,0(sp)
    80002cfc:	b7bd                	j	80002c6a <ilock+0x22>
      panic("ilock: no type");
    80002cfe:	00005517          	auipc	a0,0x5
    80002d02:	75a50513          	addi	a0,a0,1882 # 80008458 <etext+0x458>
    80002d06:	00003097          	auipc	ra,0x3
    80002d0a:	0b6080e7          	jalr	182(ra) # 80005dbc <panic>

0000000080002d0e <iunlock>:
{
    80002d0e:	1101                	addi	sp,sp,-32
    80002d10:	ec06                	sd	ra,24(sp)
    80002d12:	e822                	sd	s0,16(sp)
    80002d14:	e426                	sd	s1,8(sp)
    80002d16:	e04a                	sd	s2,0(sp)
    80002d18:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d1a:	c905                	beqz	a0,80002d4a <iunlock+0x3c>
    80002d1c:	84aa                	mv	s1,a0
    80002d1e:	01050913          	addi	s2,a0,16
    80002d22:	854a                	mv	a0,s2
    80002d24:	00001097          	auipc	ra,0x1
    80002d28:	c86080e7          	jalr	-890(ra) # 800039aa <holdingsleep>
    80002d2c:	cd19                	beqz	a0,80002d4a <iunlock+0x3c>
    80002d2e:	449c                	lw	a5,8(s1)
    80002d30:	00f05d63          	blez	a5,80002d4a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d34:	854a                	mv	a0,s2
    80002d36:	00001097          	auipc	ra,0x1
    80002d3a:	c30080e7          	jalr	-976(ra) # 80003966 <releasesleep>
}
    80002d3e:	60e2                	ld	ra,24(sp)
    80002d40:	6442                	ld	s0,16(sp)
    80002d42:	64a2                	ld	s1,8(sp)
    80002d44:	6902                	ld	s2,0(sp)
    80002d46:	6105                	addi	sp,sp,32
    80002d48:	8082                	ret
    panic("iunlock");
    80002d4a:	00005517          	auipc	a0,0x5
    80002d4e:	71e50513          	addi	a0,a0,1822 # 80008468 <etext+0x468>
    80002d52:	00003097          	auipc	ra,0x3
    80002d56:	06a080e7          	jalr	106(ra) # 80005dbc <panic>

0000000080002d5a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d5a:	7179                	addi	sp,sp,-48
    80002d5c:	f406                	sd	ra,40(sp)
    80002d5e:	f022                	sd	s0,32(sp)
    80002d60:	ec26                	sd	s1,24(sp)
    80002d62:	e84a                	sd	s2,16(sp)
    80002d64:	e44e                	sd	s3,8(sp)
    80002d66:	1800                	addi	s0,sp,48
    80002d68:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d6a:	05050493          	addi	s1,a0,80
    80002d6e:	08050913          	addi	s2,a0,128
    80002d72:	a021                	j	80002d7a <itrunc+0x20>
    80002d74:	0491                	addi	s1,s1,4
    80002d76:	01248d63          	beq	s1,s2,80002d90 <itrunc+0x36>
    if(ip->addrs[i]){
    80002d7a:	408c                	lw	a1,0(s1)
    80002d7c:	dde5                	beqz	a1,80002d74 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d7e:	0009a503          	lw	a0,0(s3)
    80002d82:	00000097          	auipc	ra,0x0
    80002d86:	910080e7          	jalr	-1776(ra) # 80002692 <bfree>
      ip->addrs[i] = 0;
    80002d8a:	0004a023          	sw	zero,0(s1)
    80002d8e:	b7dd                	j	80002d74 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d90:	0809a583          	lw	a1,128(s3)
    80002d94:	ed99                	bnez	a1,80002db2 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d96:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d9a:	854e                	mv	a0,s3
    80002d9c:	00000097          	auipc	ra,0x0
    80002da0:	de0080e7          	jalr	-544(ra) # 80002b7c <iupdate>
}
    80002da4:	70a2                	ld	ra,40(sp)
    80002da6:	7402                	ld	s0,32(sp)
    80002da8:	64e2                	ld	s1,24(sp)
    80002daa:	6942                	ld	s2,16(sp)
    80002dac:	69a2                	ld	s3,8(sp)
    80002dae:	6145                	addi	sp,sp,48
    80002db0:	8082                	ret
    80002db2:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002db4:	0009a503          	lw	a0,0(s3)
    80002db8:	fffff097          	auipc	ra,0xfffff
    80002dbc:	696080e7          	jalr	1686(ra) # 8000244e <bread>
    80002dc0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dc2:	05850493          	addi	s1,a0,88
    80002dc6:	45850913          	addi	s2,a0,1112
    80002dca:	a021                	j	80002dd2 <itrunc+0x78>
    80002dcc:	0491                	addi	s1,s1,4
    80002dce:	01248b63          	beq	s1,s2,80002de4 <itrunc+0x8a>
      if(a[j])
    80002dd2:	408c                	lw	a1,0(s1)
    80002dd4:	dde5                	beqz	a1,80002dcc <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002dd6:	0009a503          	lw	a0,0(s3)
    80002dda:	00000097          	auipc	ra,0x0
    80002dde:	8b8080e7          	jalr	-1864(ra) # 80002692 <bfree>
    80002de2:	b7ed                	j	80002dcc <itrunc+0x72>
    brelse(bp);
    80002de4:	8552                	mv	a0,s4
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	798080e7          	jalr	1944(ra) # 8000257e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dee:	0809a583          	lw	a1,128(s3)
    80002df2:	0009a503          	lw	a0,0(s3)
    80002df6:	00000097          	auipc	ra,0x0
    80002dfa:	89c080e7          	jalr	-1892(ra) # 80002692 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dfe:	0809a023          	sw	zero,128(s3)
    80002e02:	6a02                	ld	s4,0(sp)
    80002e04:	bf49                	j	80002d96 <itrunc+0x3c>

0000000080002e06 <iput>:
{
    80002e06:	1101                	addi	sp,sp,-32
    80002e08:	ec06                	sd	ra,24(sp)
    80002e0a:	e822                	sd	s0,16(sp)
    80002e0c:	e426                	sd	s1,8(sp)
    80002e0e:	1000                	addi	s0,sp,32
    80002e10:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e12:	00015517          	auipc	a0,0x15
    80002e16:	16650513          	addi	a0,a0,358 # 80017f78 <itable>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	578080e7          	jalr	1400(ra) # 80006392 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e22:	4498                	lw	a4,8(s1)
    80002e24:	4785                	li	a5,1
    80002e26:	02f70263          	beq	a4,a5,80002e4a <iput+0x44>
  ip->ref--;
    80002e2a:	449c                	lw	a5,8(s1)
    80002e2c:	37fd                	addiw	a5,a5,-1
    80002e2e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e30:	00015517          	auipc	a0,0x15
    80002e34:	14850513          	addi	a0,a0,328 # 80017f78 <itable>
    80002e38:	00003097          	auipc	ra,0x3
    80002e3c:	60e080e7          	jalr	1550(ra) # 80006446 <release>
}
    80002e40:	60e2                	ld	ra,24(sp)
    80002e42:	6442                	ld	s0,16(sp)
    80002e44:	64a2                	ld	s1,8(sp)
    80002e46:	6105                	addi	sp,sp,32
    80002e48:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e4a:	40bc                	lw	a5,64(s1)
    80002e4c:	dff9                	beqz	a5,80002e2a <iput+0x24>
    80002e4e:	04a49783          	lh	a5,74(s1)
    80002e52:	ffe1                	bnez	a5,80002e2a <iput+0x24>
    80002e54:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e56:	01048913          	addi	s2,s1,16
    80002e5a:	854a                	mv	a0,s2
    80002e5c:	00001097          	auipc	ra,0x1
    80002e60:	ab4080e7          	jalr	-1356(ra) # 80003910 <acquiresleep>
    release(&itable.lock);
    80002e64:	00015517          	auipc	a0,0x15
    80002e68:	11450513          	addi	a0,a0,276 # 80017f78 <itable>
    80002e6c:	00003097          	auipc	ra,0x3
    80002e70:	5da080e7          	jalr	1498(ra) # 80006446 <release>
    itrunc(ip);
    80002e74:	8526                	mv	a0,s1
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	ee4080e7          	jalr	-284(ra) # 80002d5a <itrunc>
    ip->type = 0;
    80002e7e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e82:	8526                	mv	a0,s1
    80002e84:	00000097          	auipc	ra,0x0
    80002e88:	cf8080e7          	jalr	-776(ra) # 80002b7c <iupdate>
    ip->valid = 0;
    80002e8c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e90:	854a                	mv	a0,s2
    80002e92:	00001097          	auipc	ra,0x1
    80002e96:	ad4080e7          	jalr	-1324(ra) # 80003966 <releasesleep>
    acquire(&itable.lock);
    80002e9a:	00015517          	auipc	a0,0x15
    80002e9e:	0de50513          	addi	a0,a0,222 # 80017f78 <itable>
    80002ea2:	00003097          	auipc	ra,0x3
    80002ea6:	4f0080e7          	jalr	1264(ra) # 80006392 <acquire>
    80002eaa:	6902                	ld	s2,0(sp)
    80002eac:	bfbd                	j	80002e2a <iput+0x24>

0000000080002eae <iunlockput>:
{
    80002eae:	1101                	addi	sp,sp,-32
    80002eb0:	ec06                	sd	ra,24(sp)
    80002eb2:	e822                	sd	s0,16(sp)
    80002eb4:	e426                	sd	s1,8(sp)
    80002eb6:	1000                	addi	s0,sp,32
    80002eb8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002eba:	00000097          	auipc	ra,0x0
    80002ebe:	e54080e7          	jalr	-428(ra) # 80002d0e <iunlock>
  iput(ip);
    80002ec2:	8526                	mv	a0,s1
    80002ec4:	00000097          	auipc	ra,0x0
    80002ec8:	f42080e7          	jalr	-190(ra) # 80002e06 <iput>
}
    80002ecc:	60e2                	ld	ra,24(sp)
    80002ece:	6442                	ld	s0,16(sp)
    80002ed0:	64a2                	ld	s1,8(sp)
    80002ed2:	6105                	addi	sp,sp,32
    80002ed4:	8082                	ret

0000000080002ed6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ed6:	1141                	addi	sp,sp,-16
    80002ed8:	e422                	sd	s0,8(sp)
    80002eda:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002edc:	411c                	lw	a5,0(a0)
    80002ede:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ee0:	415c                	lw	a5,4(a0)
    80002ee2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ee4:	04451783          	lh	a5,68(a0)
    80002ee8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002eec:	04a51783          	lh	a5,74(a0)
    80002ef0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ef4:	04c56783          	lwu	a5,76(a0)
    80002ef8:	e99c                	sd	a5,16(a1)
}
    80002efa:	6422                	ld	s0,8(sp)
    80002efc:	0141                	addi	sp,sp,16
    80002efe:	8082                	ret

0000000080002f00 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f00:	457c                	lw	a5,76(a0)
    80002f02:	0ed7ef63          	bltu	a5,a3,80003000 <readi+0x100>
{
    80002f06:	7159                	addi	sp,sp,-112
    80002f08:	f486                	sd	ra,104(sp)
    80002f0a:	f0a2                	sd	s0,96(sp)
    80002f0c:	eca6                	sd	s1,88(sp)
    80002f0e:	fc56                	sd	s5,56(sp)
    80002f10:	f85a                	sd	s6,48(sp)
    80002f12:	f45e                	sd	s7,40(sp)
    80002f14:	f062                	sd	s8,32(sp)
    80002f16:	1880                	addi	s0,sp,112
    80002f18:	8baa                	mv	s7,a0
    80002f1a:	8c2e                	mv	s8,a1
    80002f1c:	8ab2                	mv	s5,a2
    80002f1e:	84b6                	mv	s1,a3
    80002f20:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f22:	9f35                	addw	a4,a4,a3
    return 0;
    80002f24:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f26:	0ad76c63          	bltu	a4,a3,80002fde <readi+0xde>
    80002f2a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002f2c:	00e7f463          	bgeu	a5,a4,80002f34 <readi+0x34>
    n = ip->size - off;
    80002f30:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f34:	0c0b0463          	beqz	s6,80002ffc <readi+0xfc>
    80002f38:	e8ca                	sd	s2,80(sp)
    80002f3a:	e0d2                	sd	s4,64(sp)
    80002f3c:	ec66                	sd	s9,24(sp)
    80002f3e:	e86a                	sd	s10,16(sp)
    80002f40:	e46e                	sd	s11,8(sp)
    80002f42:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f44:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f48:	5cfd                	li	s9,-1
    80002f4a:	a82d                	j	80002f84 <readi+0x84>
    80002f4c:	020a1d93          	slli	s11,s4,0x20
    80002f50:	020ddd93          	srli	s11,s11,0x20
    80002f54:	05890613          	addi	a2,s2,88
    80002f58:	86ee                	mv	a3,s11
    80002f5a:	963a                	add	a2,a2,a4
    80002f5c:	85d6                	mv	a1,s5
    80002f5e:	8562                	mv	a0,s8
    80002f60:	fffff097          	auipc	ra,0xfffff
    80002f64:	9d6080e7          	jalr	-1578(ra) # 80001936 <either_copyout>
    80002f68:	05950d63          	beq	a0,s9,80002fc2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f6c:	854a                	mv	a0,s2
    80002f6e:	fffff097          	auipc	ra,0xfffff
    80002f72:	610080e7          	jalr	1552(ra) # 8000257e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f76:	013a09bb          	addw	s3,s4,s3
    80002f7a:	009a04bb          	addw	s1,s4,s1
    80002f7e:	9aee                	add	s5,s5,s11
    80002f80:	0769f863          	bgeu	s3,s6,80002ff0 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f84:	000ba903          	lw	s2,0(s7)
    80002f88:	00a4d59b          	srliw	a1,s1,0xa
    80002f8c:	855e                	mv	a0,s7
    80002f8e:	00000097          	auipc	ra,0x0
    80002f92:	8ae080e7          	jalr	-1874(ra) # 8000283c <bmap>
    80002f96:	0005059b          	sext.w	a1,a0
    80002f9a:	854a                	mv	a0,s2
    80002f9c:	fffff097          	auipc	ra,0xfffff
    80002fa0:	4b2080e7          	jalr	1202(ra) # 8000244e <bread>
    80002fa4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa6:	3ff4f713          	andi	a4,s1,1023
    80002faa:	40ed07bb          	subw	a5,s10,a4
    80002fae:	413b06bb          	subw	a3,s6,s3
    80002fb2:	8a3e                	mv	s4,a5
    80002fb4:	2781                	sext.w	a5,a5
    80002fb6:	0006861b          	sext.w	a2,a3
    80002fba:	f8f679e3          	bgeu	a2,a5,80002f4c <readi+0x4c>
    80002fbe:	8a36                	mv	s4,a3
    80002fc0:	b771                	j	80002f4c <readi+0x4c>
      brelse(bp);
    80002fc2:	854a                	mv	a0,s2
    80002fc4:	fffff097          	auipc	ra,0xfffff
    80002fc8:	5ba080e7          	jalr	1466(ra) # 8000257e <brelse>
      tot = -1;
    80002fcc:	59fd                	li	s3,-1
      break;
    80002fce:	6946                	ld	s2,80(sp)
    80002fd0:	6a06                	ld	s4,64(sp)
    80002fd2:	6ce2                	ld	s9,24(sp)
    80002fd4:	6d42                	ld	s10,16(sp)
    80002fd6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002fd8:	0009851b          	sext.w	a0,s3
    80002fdc:	69a6                	ld	s3,72(sp)
}
    80002fde:	70a6                	ld	ra,104(sp)
    80002fe0:	7406                	ld	s0,96(sp)
    80002fe2:	64e6                	ld	s1,88(sp)
    80002fe4:	7ae2                	ld	s5,56(sp)
    80002fe6:	7b42                	ld	s6,48(sp)
    80002fe8:	7ba2                	ld	s7,40(sp)
    80002fea:	7c02                	ld	s8,32(sp)
    80002fec:	6165                	addi	sp,sp,112
    80002fee:	8082                	ret
    80002ff0:	6946                	ld	s2,80(sp)
    80002ff2:	6a06                	ld	s4,64(sp)
    80002ff4:	6ce2                	ld	s9,24(sp)
    80002ff6:	6d42                	ld	s10,16(sp)
    80002ff8:	6da2                	ld	s11,8(sp)
    80002ffa:	bff9                	j	80002fd8 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ffc:	89da                	mv	s3,s6
    80002ffe:	bfe9                	j	80002fd8 <readi+0xd8>
    return 0;
    80003000:	4501                	li	a0,0
}
    80003002:	8082                	ret

0000000080003004 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003004:	457c                	lw	a5,76(a0)
    80003006:	10d7ee63          	bltu	a5,a3,80003122 <writei+0x11e>
{
    8000300a:	7159                	addi	sp,sp,-112
    8000300c:	f486                	sd	ra,104(sp)
    8000300e:	f0a2                	sd	s0,96(sp)
    80003010:	e8ca                	sd	s2,80(sp)
    80003012:	fc56                	sd	s5,56(sp)
    80003014:	f85a                	sd	s6,48(sp)
    80003016:	f45e                	sd	s7,40(sp)
    80003018:	f062                	sd	s8,32(sp)
    8000301a:	1880                	addi	s0,sp,112
    8000301c:	8b2a                	mv	s6,a0
    8000301e:	8c2e                	mv	s8,a1
    80003020:	8ab2                	mv	s5,a2
    80003022:	8936                	mv	s2,a3
    80003024:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003026:	00e687bb          	addw	a5,a3,a4
    8000302a:	0ed7ee63          	bltu	a5,a3,80003126 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000302e:	00043737          	lui	a4,0x43
    80003032:	0ef76c63          	bltu	a4,a5,8000312a <writei+0x126>
    80003036:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003038:	0c0b8d63          	beqz	s7,80003112 <writei+0x10e>
    8000303c:	eca6                	sd	s1,88(sp)
    8000303e:	e4ce                	sd	s3,72(sp)
    80003040:	ec66                	sd	s9,24(sp)
    80003042:	e86a                	sd	s10,16(sp)
    80003044:	e46e                	sd	s11,8(sp)
    80003046:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003048:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000304c:	5cfd                	li	s9,-1
    8000304e:	a091                	j	80003092 <writei+0x8e>
    80003050:	02099d93          	slli	s11,s3,0x20
    80003054:	020ddd93          	srli	s11,s11,0x20
    80003058:	05848513          	addi	a0,s1,88
    8000305c:	86ee                	mv	a3,s11
    8000305e:	8656                	mv	a2,s5
    80003060:	85e2                	mv	a1,s8
    80003062:	953a                	add	a0,a0,a4
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	928080e7          	jalr	-1752(ra) # 8000198c <either_copyin>
    8000306c:	07950263          	beq	a0,s9,800030d0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003070:	8526                	mv	a0,s1
    80003072:	00000097          	auipc	ra,0x0
    80003076:	780080e7          	jalr	1920(ra) # 800037f2 <log_write>
    brelse(bp);
    8000307a:	8526                	mv	a0,s1
    8000307c:	fffff097          	auipc	ra,0xfffff
    80003080:	502080e7          	jalr	1282(ra) # 8000257e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003084:	01498a3b          	addw	s4,s3,s4
    80003088:	0129893b          	addw	s2,s3,s2
    8000308c:	9aee                	add	s5,s5,s11
    8000308e:	057a7663          	bgeu	s4,s7,800030da <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003092:	000b2483          	lw	s1,0(s6)
    80003096:	00a9559b          	srliw	a1,s2,0xa
    8000309a:	855a                	mv	a0,s6
    8000309c:	fffff097          	auipc	ra,0xfffff
    800030a0:	7a0080e7          	jalr	1952(ra) # 8000283c <bmap>
    800030a4:	0005059b          	sext.w	a1,a0
    800030a8:	8526                	mv	a0,s1
    800030aa:	fffff097          	auipc	ra,0xfffff
    800030ae:	3a4080e7          	jalr	932(ra) # 8000244e <bread>
    800030b2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030b4:	3ff97713          	andi	a4,s2,1023
    800030b8:	40ed07bb          	subw	a5,s10,a4
    800030bc:	414b86bb          	subw	a3,s7,s4
    800030c0:	89be                	mv	s3,a5
    800030c2:	2781                	sext.w	a5,a5
    800030c4:	0006861b          	sext.w	a2,a3
    800030c8:	f8f674e3          	bgeu	a2,a5,80003050 <writei+0x4c>
    800030cc:	89b6                	mv	s3,a3
    800030ce:	b749                	j	80003050 <writei+0x4c>
      brelse(bp);
    800030d0:	8526                	mv	a0,s1
    800030d2:	fffff097          	auipc	ra,0xfffff
    800030d6:	4ac080e7          	jalr	1196(ra) # 8000257e <brelse>
  }

  if(off > ip->size)
    800030da:	04cb2783          	lw	a5,76(s6)
    800030de:	0327fc63          	bgeu	a5,s2,80003116 <writei+0x112>
    ip->size = off;
    800030e2:	052b2623          	sw	s2,76(s6)
    800030e6:	64e6                	ld	s1,88(sp)
    800030e8:	69a6                	ld	s3,72(sp)
    800030ea:	6ce2                	ld	s9,24(sp)
    800030ec:	6d42                	ld	s10,16(sp)
    800030ee:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030f0:	855a                	mv	a0,s6
    800030f2:	00000097          	auipc	ra,0x0
    800030f6:	a8a080e7          	jalr	-1398(ra) # 80002b7c <iupdate>

  return tot;
    800030fa:	000a051b          	sext.w	a0,s4
    800030fe:	6a06                	ld	s4,64(sp)
}
    80003100:	70a6                	ld	ra,104(sp)
    80003102:	7406                	ld	s0,96(sp)
    80003104:	6946                	ld	s2,80(sp)
    80003106:	7ae2                	ld	s5,56(sp)
    80003108:	7b42                	ld	s6,48(sp)
    8000310a:	7ba2                	ld	s7,40(sp)
    8000310c:	7c02                	ld	s8,32(sp)
    8000310e:	6165                	addi	sp,sp,112
    80003110:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003112:	8a5e                	mv	s4,s7
    80003114:	bff1                	j	800030f0 <writei+0xec>
    80003116:	64e6                	ld	s1,88(sp)
    80003118:	69a6                	ld	s3,72(sp)
    8000311a:	6ce2                	ld	s9,24(sp)
    8000311c:	6d42                	ld	s10,16(sp)
    8000311e:	6da2                	ld	s11,8(sp)
    80003120:	bfc1                	j	800030f0 <writei+0xec>
    return -1;
    80003122:	557d                	li	a0,-1
}
    80003124:	8082                	ret
    return -1;
    80003126:	557d                	li	a0,-1
    80003128:	bfe1                	j	80003100 <writei+0xfc>
    return -1;
    8000312a:	557d                	li	a0,-1
    8000312c:	bfd1                	j	80003100 <writei+0xfc>

000000008000312e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000312e:	1141                	addi	sp,sp,-16
    80003130:	e406                	sd	ra,8(sp)
    80003132:	e022                	sd	s0,0(sp)
    80003134:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003136:	4639                	li	a2,14
    80003138:	ffffd097          	auipc	ra,0xffffd
    8000313c:	112080e7          	jalr	274(ra) # 8000024a <strncmp>
}
    80003140:	60a2                	ld	ra,8(sp)
    80003142:	6402                	ld	s0,0(sp)
    80003144:	0141                	addi	sp,sp,16
    80003146:	8082                	ret

0000000080003148 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003148:	7139                	addi	sp,sp,-64
    8000314a:	fc06                	sd	ra,56(sp)
    8000314c:	f822                	sd	s0,48(sp)
    8000314e:	f426                	sd	s1,40(sp)
    80003150:	f04a                	sd	s2,32(sp)
    80003152:	ec4e                	sd	s3,24(sp)
    80003154:	e852                	sd	s4,16(sp)
    80003156:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003158:	04451703          	lh	a4,68(a0)
    8000315c:	4785                	li	a5,1
    8000315e:	00f71a63          	bne	a4,a5,80003172 <dirlookup+0x2a>
    80003162:	892a                	mv	s2,a0
    80003164:	89ae                	mv	s3,a1
    80003166:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003168:	457c                	lw	a5,76(a0)
    8000316a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000316c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000316e:	e79d                	bnez	a5,8000319c <dirlookup+0x54>
    80003170:	a8a5                	j	800031e8 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003172:	00005517          	auipc	a0,0x5
    80003176:	2fe50513          	addi	a0,a0,766 # 80008470 <etext+0x470>
    8000317a:	00003097          	auipc	ra,0x3
    8000317e:	c42080e7          	jalr	-958(ra) # 80005dbc <panic>
      panic("dirlookup read");
    80003182:	00005517          	auipc	a0,0x5
    80003186:	30650513          	addi	a0,a0,774 # 80008488 <etext+0x488>
    8000318a:	00003097          	auipc	ra,0x3
    8000318e:	c32080e7          	jalr	-974(ra) # 80005dbc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003192:	24c1                	addiw	s1,s1,16
    80003194:	04c92783          	lw	a5,76(s2)
    80003198:	04f4f763          	bgeu	s1,a5,800031e6 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000319c:	4741                	li	a4,16
    8000319e:	86a6                	mv	a3,s1
    800031a0:	fc040613          	addi	a2,s0,-64
    800031a4:	4581                	li	a1,0
    800031a6:	854a                	mv	a0,s2
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	d58080e7          	jalr	-680(ra) # 80002f00 <readi>
    800031b0:	47c1                	li	a5,16
    800031b2:	fcf518e3          	bne	a0,a5,80003182 <dirlookup+0x3a>
    if(de.inum == 0)
    800031b6:	fc045783          	lhu	a5,-64(s0)
    800031ba:	dfe1                	beqz	a5,80003192 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031bc:	fc240593          	addi	a1,s0,-62
    800031c0:	854e                	mv	a0,s3
    800031c2:	00000097          	auipc	ra,0x0
    800031c6:	f6c080e7          	jalr	-148(ra) # 8000312e <namecmp>
    800031ca:	f561                	bnez	a0,80003192 <dirlookup+0x4a>
      if(poff)
    800031cc:	000a0463          	beqz	s4,800031d4 <dirlookup+0x8c>
        *poff = off;
    800031d0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031d4:	fc045583          	lhu	a1,-64(s0)
    800031d8:	00092503          	lw	a0,0(s2)
    800031dc:	fffff097          	auipc	ra,0xfffff
    800031e0:	73c080e7          	jalr	1852(ra) # 80002918 <iget>
    800031e4:	a011                	j	800031e8 <dirlookup+0xa0>
  return 0;
    800031e6:	4501                	li	a0,0
}
    800031e8:	70e2                	ld	ra,56(sp)
    800031ea:	7442                	ld	s0,48(sp)
    800031ec:	74a2                	ld	s1,40(sp)
    800031ee:	7902                	ld	s2,32(sp)
    800031f0:	69e2                	ld	s3,24(sp)
    800031f2:	6a42                	ld	s4,16(sp)
    800031f4:	6121                	addi	sp,sp,64
    800031f6:	8082                	ret

00000000800031f8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031f8:	711d                	addi	sp,sp,-96
    800031fa:	ec86                	sd	ra,88(sp)
    800031fc:	e8a2                	sd	s0,80(sp)
    800031fe:	e4a6                	sd	s1,72(sp)
    80003200:	e0ca                	sd	s2,64(sp)
    80003202:	fc4e                	sd	s3,56(sp)
    80003204:	f852                	sd	s4,48(sp)
    80003206:	f456                	sd	s5,40(sp)
    80003208:	f05a                	sd	s6,32(sp)
    8000320a:	ec5e                	sd	s7,24(sp)
    8000320c:	e862                	sd	s8,16(sp)
    8000320e:	e466                	sd	s9,8(sp)
    80003210:	1080                	addi	s0,sp,96
    80003212:	84aa                	mv	s1,a0
    80003214:	8b2e                	mv	s6,a1
    80003216:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003218:	00054703          	lbu	a4,0(a0)
    8000321c:	02f00793          	li	a5,47
    80003220:	02f70263          	beq	a4,a5,80003244 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003224:	ffffe097          	auipc	ra,0xffffe
    80003228:	c58080e7          	jalr	-936(ra) # 80000e7c <myproc>
    8000322c:	15053503          	ld	a0,336(a0)
    80003230:	00000097          	auipc	ra,0x0
    80003234:	9da080e7          	jalr	-1574(ra) # 80002c0a <idup>
    80003238:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000323a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000323e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003240:	4b85                	li	s7,1
    80003242:	a875                	j	800032fe <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003244:	4585                	li	a1,1
    80003246:	4505                	li	a0,1
    80003248:	fffff097          	auipc	ra,0xfffff
    8000324c:	6d0080e7          	jalr	1744(ra) # 80002918 <iget>
    80003250:	8a2a                	mv	s4,a0
    80003252:	b7e5                	j	8000323a <namex+0x42>
      iunlockput(ip);
    80003254:	8552                	mv	a0,s4
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	c58080e7          	jalr	-936(ra) # 80002eae <iunlockput>
      return 0;
    8000325e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003260:	8552                	mv	a0,s4
    80003262:	60e6                	ld	ra,88(sp)
    80003264:	6446                	ld	s0,80(sp)
    80003266:	64a6                	ld	s1,72(sp)
    80003268:	6906                	ld	s2,64(sp)
    8000326a:	79e2                	ld	s3,56(sp)
    8000326c:	7a42                	ld	s4,48(sp)
    8000326e:	7aa2                	ld	s5,40(sp)
    80003270:	7b02                	ld	s6,32(sp)
    80003272:	6be2                	ld	s7,24(sp)
    80003274:	6c42                	ld	s8,16(sp)
    80003276:	6ca2                	ld	s9,8(sp)
    80003278:	6125                	addi	sp,sp,96
    8000327a:	8082                	ret
      iunlock(ip);
    8000327c:	8552                	mv	a0,s4
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	a90080e7          	jalr	-1392(ra) # 80002d0e <iunlock>
      return ip;
    80003286:	bfe9                	j	80003260 <namex+0x68>
      iunlockput(ip);
    80003288:	8552                	mv	a0,s4
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	c24080e7          	jalr	-988(ra) # 80002eae <iunlockput>
      return 0;
    80003292:	8a4e                	mv	s4,s3
    80003294:	b7f1                	j	80003260 <namex+0x68>
  len = path - s;
    80003296:	40998633          	sub	a2,s3,s1
    8000329a:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000329e:	099c5863          	bge	s8,s9,8000332e <namex+0x136>
    memmove(name, s, DIRSIZ);
    800032a2:	4639                	li	a2,14
    800032a4:	85a6                	mv	a1,s1
    800032a6:	8556                	mv	a0,s5
    800032a8:	ffffd097          	auipc	ra,0xffffd
    800032ac:	f2e080e7          	jalr	-210(ra) # 800001d6 <memmove>
    800032b0:	84ce                	mv	s1,s3
  while(*path == '/')
    800032b2:	0004c783          	lbu	a5,0(s1)
    800032b6:	01279763          	bne	a5,s2,800032c4 <namex+0xcc>
    path++;
    800032ba:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032bc:	0004c783          	lbu	a5,0(s1)
    800032c0:	ff278de3          	beq	a5,s2,800032ba <namex+0xc2>
    ilock(ip);
    800032c4:	8552                	mv	a0,s4
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	982080e7          	jalr	-1662(ra) # 80002c48 <ilock>
    if(ip->type != T_DIR){
    800032ce:	044a1783          	lh	a5,68(s4)
    800032d2:	f97791e3          	bne	a5,s7,80003254 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800032d6:	000b0563          	beqz	s6,800032e0 <namex+0xe8>
    800032da:	0004c783          	lbu	a5,0(s1)
    800032de:	dfd9                	beqz	a5,8000327c <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032e0:	4601                	li	a2,0
    800032e2:	85d6                	mv	a1,s5
    800032e4:	8552                	mv	a0,s4
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	e62080e7          	jalr	-414(ra) # 80003148 <dirlookup>
    800032ee:	89aa                	mv	s3,a0
    800032f0:	dd41                	beqz	a0,80003288 <namex+0x90>
    iunlockput(ip);
    800032f2:	8552                	mv	a0,s4
    800032f4:	00000097          	auipc	ra,0x0
    800032f8:	bba080e7          	jalr	-1094(ra) # 80002eae <iunlockput>
    ip = next;
    800032fc:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032fe:	0004c783          	lbu	a5,0(s1)
    80003302:	01279763          	bne	a5,s2,80003310 <namex+0x118>
    path++;
    80003306:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003308:	0004c783          	lbu	a5,0(s1)
    8000330c:	ff278de3          	beq	a5,s2,80003306 <namex+0x10e>
  if(*path == 0)
    80003310:	cb9d                	beqz	a5,80003346 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003312:	0004c783          	lbu	a5,0(s1)
    80003316:	89a6                	mv	s3,s1
  len = path - s;
    80003318:	4c81                	li	s9,0
    8000331a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000331c:	01278963          	beq	a5,s2,8000332e <namex+0x136>
    80003320:	dbbd                	beqz	a5,80003296 <namex+0x9e>
    path++;
    80003322:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003324:	0009c783          	lbu	a5,0(s3)
    80003328:	ff279ce3          	bne	a5,s2,80003320 <namex+0x128>
    8000332c:	b7ad                	j	80003296 <namex+0x9e>
    memmove(name, s, len);
    8000332e:	2601                	sext.w	a2,a2
    80003330:	85a6                	mv	a1,s1
    80003332:	8556                	mv	a0,s5
    80003334:	ffffd097          	auipc	ra,0xffffd
    80003338:	ea2080e7          	jalr	-350(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000333c:	9cd6                	add	s9,s9,s5
    8000333e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003342:	84ce                	mv	s1,s3
    80003344:	b7bd                	j	800032b2 <namex+0xba>
  if(nameiparent){
    80003346:	f00b0de3          	beqz	s6,80003260 <namex+0x68>
    iput(ip);
    8000334a:	8552                	mv	a0,s4
    8000334c:	00000097          	auipc	ra,0x0
    80003350:	aba080e7          	jalr	-1350(ra) # 80002e06 <iput>
    return 0;
    80003354:	4a01                	li	s4,0
    80003356:	b729                	j	80003260 <namex+0x68>

0000000080003358 <dirlink>:
{
    80003358:	7139                	addi	sp,sp,-64
    8000335a:	fc06                	sd	ra,56(sp)
    8000335c:	f822                	sd	s0,48(sp)
    8000335e:	f04a                	sd	s2,32(sp)
    80003360:	ec4e                	sd	s3,24(sp)
    80003362:	e852                	sd	s4,16(sp)
    80003364:	0080                	addi	s0,sp,64
    80003366:	892a                	mv	s2,a0
    80003368:	8a2e                	mv	s4,a1
    8000336a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000336c:	4601                	li	a2,0
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	dda080e7          	jalr	-550(ra) # 80003148 <dirlookup>
    80003376:	ed25                	bnez	a0,800033ee <dirlink+0x96>
    80003378:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000337a:	04c92483          	lw	s1,76(s2)
    8000337e:	c49d                	beqz	s1,800033ac <dirlink+0x54>
    80003380:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003382:	4741                	li	a4,16
    80003384:	86a6                	mv	a3,s1
    80003386:	fc040613          	addi	a2,s0,-64
    8000338a:	4581                	li	a1,0
    8000338c:	854a                	mv	a0,s2
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	b72080e7          	jalr	-1166(ra) # 80002f00 <readi>
    80003396:	47c1                	li	a5,16
    80003398:	06f51163          	bne	a0,a5,800033fa <dirlink+0xa2>
    if(de.inum == 0)
    8000339c:	fc045783          	lhu	a5,-64(s0)
    800033a0:	c791                	beqz	a5,800033ac <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033a2:	24c1                	addiw	s1,s1,16
    800033a4:	04c92783          	lw	a5,76(s2)
    800033a8:	fcf4ede3          	bltu	s1,a5,80003382 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033ac:	4639                	li	a2,14
    800033ae:	85d2                	mv	a1,s4
    800033b0:	fc240513          	addi	a0,s0,-62
    800033b4:	ffffd097          	auipc	ra,0xffffd
    800033b8:	ecc080e7          	jalr	-308(ra) # 80000280 <strncpy>
  de.inum = inum;
    800033bc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033c0:	4741                	li	a4,16
    800033c2:	86a6                	mv	a3,s1
    800033c4:	fc040613          	addi	a2,s0,-64
    800033c8:	4581                	li	a1,0
    800033ca:	854a                	mv	a0,s2
    800033cc:	00000097          	auipc	ra,0x0
    800033d0:	c38080e7          	jalr	-968(ra) # 80003004 <writei>
    800033d4:	872a                	mv	a4,a0
    800033d6:	47c1                	li	a5,16
  return 0;
    800033d8:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033da:	02f71863          	bne	a4,a5,8000340a <dirlink+0xb2>
    800033de:	74a2                	ld	s1,40(sp)
}
    800033e0:	70e2                	ld	ra,56(sp)
    800033e2:	7442                	ld	s0,48(sp)
    800033e4:	7902                	ld	s2,32(sp)
    800033e6:	69e2                	ld	s3,24(sp)
    800033e8:	6a42                	ld	s4,16(sp)
    800033ea:	6121                	addi	sp,sp,64
    800033ec:	8082                	ret
    iput(ip);
    800033ee:	00000097          	auipc	ra,0x0
    800033f2:	a18080e7          	jalr	-1512(ra) # 80002e06 <iput>
    return -1;
    800033f6:	557d                	li	a0,-1
    800033f8:	b7e5                	j	800033e0 <dirlink+0x88>
      panic("dirlink read");
    800033fa:	00005517          	auipc	a0,0x5
    800033fe:	09e50513          	addi	a0,a0,158 # 80008498 <etext+0x498>
    80003402:	00003097          	auipc	ra,0x3
    80003406:	9ba080e7          	jalr	-1606(ra) # 80005dbc <panic>
    panic("dirlink");
    8000340a:	00005517          	auipc	a0,0x5
    8000340e:	19e50513          	addi	a0,a0,414 # 800085a8 <etext+0x5a8>
    80003412:	00003097          	auipc	ra,0x3
    80003416:	9aa080e7          	jalr	-1622(ra) # 80005dbc <panic>

000000008000341a <namei>:

struct inode*
namei(char *path)
{
    8000341a:	1101                	addi	sp,sp,-32
    8000341c:	ec06                	sd	ra,24(sp)
    8000341e:	e822                	sd	s0,16(sp)
    80003420:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003422:	fe040613          	addi	a2,s0,-32
    80003426:	4581                	li	a1,0
    80003428:	00000097          	auipc	ra,0x0
    8000342c:	dd0080e7          	jalr	-560(ra) # 800031f8 <namex>
}
    80003430:	60e2                	ld	ra,24(sp)
    80003432:	6442                	ld	s0,16(sp)
    80003434:	6105                	addi	sp,sp,32
    80003436:	8082                	ret

0000000080003438 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003438:	1141                	addi	sp,sp,-16
    8000343a:	e406                	sd	ra,8(sp)
    8000343c:	e022                	sd	s0,0(sp)
    8000343e:	0800                	addi	s0,sp,16
    80003440:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003442:	4585                	li	a1,1
    80003444:	00000097          	auipc	ra,0x0
    80003448:	db4080e7          	jalr	-588(ra) # 800031f8 <namex>
}
    8000344c:	60a2                	ld	ra,8(sp)
    8000344e:	6402                	ld	s0,0(sp)
    80003450:	0141                	addi	sp,sp,16
    80003452:	8082                	ret

0000000080003454 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003454:	1101                	addi	sp,sp,-32
    80003456:	ec06                	sd	ra,24(sp)
    80003458:	e822                	sd	s0,16(sp)
    8000345a:	e426                	sd	s1,8(sp)
    8000345c:	e04a                	sd	s2,0(sp)
    8000345e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003460:	00016917          	auipc	s2,0x16
    80003464:	5c090913          	addi	s2,s2,1472 # 80019a20 <log>
    80003468:	01892583          	lw	a1,24(s2)
    8000346c:	02892503          	lw	a0,40(s2)
    80003470:	fffff097          	auipc	ra,0xfffff
    80003474:	fde080e7          	jalr	-34(ra) # 8000244e <bread>
    80003478:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000347a:	02c92603          	lw	a2,44(s2)
    8000347e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003480:	00c05f63          	blez	a2,8000349e <write_head+0x4a>
    80003484:	00016717          	auipc	a4,0x16
    80003488:	5cc70713          	addi	a4,a4,1484 # 80019a50 <log+0x30>
    8000348c:	87aa                	mv	a5,a0
    8000348e:	060a                	slli	a2,a2,0x2
    80003490:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003492:	4314                	lw	a3,0(a4)
    80003494:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003496:	0711                	addi	a4,a4,4
    80003498:	0791                	addi	a5,a5,4
    8000349a:	fec79ce3          	bne	a5,a2,80003492 <write_head+0x3e>
  }
  bwrite(buf);
    8000349e:	8526                	mv	a0,s1
    800034a0:	fffff097          	auipc	ra,0xfffff
    800034a4:	0a0080e7          	jalr	160(ra) # 80002540 <bwrite>
  brelse(buf);
    800034a8:	8526                	mv	a0,s1
    800034aa:	fffff097          	auipc	ra,0xfffff
    800034ae:	0d4080e7          	jalr	212(ra) # 8000257e <brelse>
}
    800034b2:	60e2                	ld	ra,24(sp)
    800034b4:	6442                	ld	s0,16(sp)
    800034b6:	64a2                	ld	s1,8(sp)
    800034b8:	6902                	ld	s2,0(sp)
    800034ba:	6105                	addi	sp,sp,32
    800034bc:	8082                	ret

00000000800034be <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034be:	00016797          	auipc	a5,0x16
    800034c2:	58e7a783          	lw	a5,1422(a5) # 80019a4c <log+0x2c>
    800034c6:	0af05d63          	blez	a5,80003580 <install_trans+0xc2>
{
    800034ca:	7139                	addi	sp,sp,-64
    800034cc:	fc06                	sd	ra,56(sp)
    800034ce:	f822                	sd	s0,48(sp)
    800034d0:	f426                	sd	s1,40(sp)
    800034d2:	f04a                	sd	s2,32(sp)
    800034d4:	ec4e                	sd	s3,24(sp)
    800034d6:	e852                	sd	s4,16(sp)
    800034d8:	e456                	sd	s5,8(sp)
    800034da:	e05a                	sd	s6,0(sp)
    800034dc:	0080                	addi	s0,sp,64
    800034de:	8b2a                	mv	s6,a0
    800034e0:	00016a97          	auipc	s5,0x16
    800034e4:	570a8a93          	addi	s5,s5,1392 # 80019a50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034e8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ea:	00016997          	auipc	s3,0x16
    800034ee:	53698993          	addi	s3,s3,1334 # 80019a20 <log>
    800034f2:	a00d                	j	80003514 <install_trans+0x56>
    brelse(lbuf);
    800034f4:	854a                	mv	a0,s2
    800034f6:	fffff097          	auipc	ra,0xfffff
    800034fa:	088080e7          	jalr	136(ra) # 8000257e <brelse>
    brelse(dbuf);
    800034fe:	8526                	mv	a0,s1
    80003500:	fffff097          	auipc	ra,0xfffff
    80003504:	07e080e7          	jalr	126(ra) # 8000257e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003508:	2a05                	addiw	s4,s4,1
    8000350a:	0a91                	addi	s5,s5,4
    8000350c:	02c9a783          	lw	a5,44(s3)
    80003510:	04fa5e63          	bge	s4,a5,8000356c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003514:	0189a583          	lw	a1,24(s3)
    80003518:	014585bb          	addw	a1,a1,s4
    8000351c:	2585                	addiw	a1,a1,1
    8000351e:	0289a503          	lw	a0,40(s3)
    80003522:	fffff097          	auipc	ra,0xfffff
    80003526:	f2c080e7          	jalr	-212(ra) # 8000244e <bread>
    8000352a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000352c:	000aa583          	lw	a1,0(s5)
    80003530:	0289a503          	lw	a0,40(s3)
    80003534:	fffff097          	auipc	ra,0xfffff
    80003538:	f1a080e7          	jalr	-230(ra) # 8000244e <bread>
    8000353c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000353e:	40000613          	li	a2,1024
    80003542:	05890593          	addi	a1,s2,88
    80003546:	05850513          	addi	a0,a0,88
    8000354a:	ffffd097          	auipc	ra,0xffffd
    8000354e:	c8c080e7          	jalr	-884(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003552:	8526                	mv	a0,s1
    80003554:	fffff097          	auipc	ra,0xfffff
    80003558:	fec080e7          	jalr	-20(ra) # 80002540 <bwrite>
    if(recovering == 0)
    8000355c:	f80b1ce3          	bnez	s6,800034f4 <install_trans+0x36>
      bunpin(dbuf);
    80003560:	8526                	mv	a0,s1
    80003562:	fffff097          	auipc	ra,0xfffff
    80003566:	0f4080e7          	jalr	244(ra) # 80002656 <bunpin>
    8000356a:	b769                	j	800034f4 <install_trans+0x36>
}
    8000356c:	70e2                	ld	ra,56(sp)
    8000356e:	7442                	ld	s0,48(sp)
    80003570:	74a2                	ld	s1,40(sp)
    80003572:	7902                	ld	s2,32(sp)
    80003574:	69e2                	ld	s3,24(sp)
    80003576:	6a42                	ld	s4,16(sp)
    80003578:	6aa2                	ld	s5,8(sp)
    8000357a:	6b02                	ld	s6,0(sp)
    8000357c:	6121                	addi	sp,sp,64
    8000357e:	8082                	ret
    80003580:	8082                	ret

0000000080003582 <initlog>:
{
    80003582:	7179                	addi	sp,sp,-48
    80003584:	f406                	sd	ra,40(sp)
    80003586:	f022                	sd	s0,32(sp)
    80003588:	ec26                	sd	s1,24(sp)
    8000358a:	e84a                	sd	s2,16(sp)
    8000358c:	e44e                	sd	s3,8(sp)
    8000358e:	1800                	addi	s0,sp,48
    80003590:	892a                	mv	s2,a0
    80003592:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003594:	00016497          	auipc	s1,0x16
    80003598:	48c48493          	addi	s1,s1,1164 # 80019a20 <log>
    8000359c:	00005597          	auipc	a1,0x5
    800035a0:	f0c58593          	addi	a1,a1,-244 # 800084a8 <etext+0x4a8>
    800035a4:	8526                	mv	a0,s1
    800035a6:	00003097          	auipc	ra,0x3
    800035aa:	d5c080e7          	jalr	-676(ra) # 80006302 <initlock>
  log.start = sb->logstart;
    800035ae:	0149a583          	lw	a1,20(s3)
    800035b2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035b4:	0109a783          	lw	a5,16(s3)
    800035b8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035ba:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035be:	854a                	mv	a0,s2
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	e8e080e7          	jalr	-370(ra) # 8000244e <bread>
  log.lh.n = lh->n;
    800035c8:	4d30                	lw	a2,88(a0)
    800035ca:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035cc:	00c05f63          	blez	a2,800035ea <initlog+0x68>
    800035d0:	87aa                	mv	a5,a0
    800035d2:	00016717          	auipc	a4,0x16
    800035d6:	47e70713          	addi	a4,a4,1150 # 80019a50 <log+0x30>
    800035da:	060a                	slli	a2,a2,0x2
    800035dc:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035de:	4ff4                	lw	a3,92(a5)
    800035e0:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035e2:	0791                	addi	a5,a5,4
    800035e4:	0711                	addi	a4,a4,4
    800035e6:	fec79ce3          	bne	a5,a2,800035de <initlog+0x5c>
  brelse(buf);
    800035ea:	fffff097          	auipc	ra,0xfffff
    800035ee:	f94080e7          	jalr	-108(ra) # 8000257e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035f2:	4505                	li	a0,1
    800035f4:	00000097          	auipc	ra,0x0
    800035f8:	eca080e7          	jalr	-310(ra) # 800034be <install_trans>
  log.lh.n = 0;
    800035fc:	00016797          	auipc	a5,0x16
    80003600:	4407a823          	sw	zero,1104(a5) # 80019a4c <log+0x2c>
  write_head(); // clear the log
    80003604:	00000097          	auipc	ra,0x0
    80003608:	e50080e7          	jalr	-432(ra) # 80003454 <write_head>
}
    8000360c:	70a2                	ld	ra,40(sp)
    8000360e:	7402                	ld	s0,32(sp)
    80003610:	64e2                	ld	s1,24(sp)
    80003612:	6942                	ld	s2,16(sp)
    80003614:	69a2                	ld	s3,8(sp)
    80003616:	6145                	addi	sp,sp,48
    80003618:	8082                	ret

000000008000361a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000361a:	1101                	addi	sp,sp,-32
    8000361c:	ec06                	sd	ra,24(sp)
    8000361e:	e822                	sd	s0,16(sp)
    80003620:	e426                	sd	s1,8(sp)
    80003622:	e04a                	sd	s2,0(sp)
    80003624:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003626:	00016517          	auipc	a0,0x16
    8000362a:	3fa50513          	addi	a0,a0,1018 # 80019a20 <log>
    8000362e:	00003097          	auipc	ra,0x3
    80003632:	d64080e7          	jalr	-668(ra) # 80006392 <acquire>
  while(1){
    if(log.committing){
    80003636:	00016497          	auipc	s1,0x16
    8000363a:	3ea48493          	addi	s1,s1,1002 # 80019a20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000363e:	4979                	li	s2,30
    80003640:	a039                	j	8000364e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003642:	85a6                	mv	a1,s1
    80003644:	8526                	mv	a0,s1
    80003646:	ffffe097          	auipc	ra,0xffffe
    8000364a:	f4c080e7          	jalr	-180(ra) # 80001592 <sleep>
    if(log.committing){
    8000364e:	50dc                	lw	a5,36(s1)
    80003650:	fbed                	bnez	a5,80003642 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003652:	5098                	lw	a4,32(s1)
    80003654:	2705                	addiw	a4,a4,1
    80003656:	0027179b          	slliw	a5,a4,0x2
    8000365a:	9fb9                	addw	a5,a5,a4
    8000365c:	0017979b          	slliw	a5,a5,0x1
    80003660:	54d4                	lw	a3,44(s1)
    80003662:	9fb5                	addw	a5,a5,a3
    80003664:	00f95963          	bge	s2,a5,80003676 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003668:	85a6                	mv	a1,s1
    8000366a:	8526                	mv	a0,s1
    8000366c:	ffffe097          	auipc	ra,0xffffe
    80003670:	f26080e7          	jalr	-218(ra) # 80001592 <sleep>
    80003674:	bfe9                	j	8000364e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003676:	00016517          	auipc	a0,0x16
    8000367a:	3aa50513          	addi	a0,a0,938 # 80019a20 <log>
    8000367e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003680:	00003097          	auipc	ra,0x3
    80003684:	dc6080e7          	jalr	-570(ra) # 80006446 <release>
      break;
    }
  }
}
    80003688:	60e2                	ld	ra,24(sp)
    8000368a:	6442                	ld	s0,16(sp)
    8000368c:	64a2                	ld	s1,8(sp)
    8000368e:	6902                	ld	s2,0(sp)
    80003690:	6105                	addi	sp,sp,32
    80003692:	8082                	ret

0000000080003694 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003694:	7139                	addi	sp,sp,-64
    80003696:	fc06                	sd	ra,56(sp)
    80003698:	f822                	sd	s0,48(sp)
    8000369a:	f426                	sd	s1,40(sp)
    8000369c:	f04a                	sd	s2,32(sp)
    8000369e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036a0:	00016497          	auipc	s1,0x16
    800036a4:	38048493          	addi	s1,s1,896 # 80019a20 <log>
    800036a8:	8526                	mv	a0,s1
    800036aa:	00003097          	auipc	ra,0x3
    800036ae:	ce8080e7          	jalr	-792(ra) # 80006392 <acquire>
  log.outstanding -= 1;
    800036b2:	509c                	lw	a5,32(s1)
    800036b4:	37fd                	addiw	a5,a5,-1
    800036b6:	0007891b          	sext.w	s2,a5
    800036ba:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036bc:	50dc                	lw	a5,36(s1)
    800036be:	e7b9                	bnez	a5,8000370c <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800036c0:	06091163          	bnez	s2,80003722 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036c4:	00016497          	auipc	s1,0x16
    800036c8:	35c48493          	addi	s1,s1,860 # 80019a20 <log>
    800036cc:	4785                	li	a5,1
    800036ce:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036d0:	8526                	mv	a0,s1
    800036d2:	00003097          	auipc	ra,0x3
    800036d6:	d74080e7          	jalr	-652(ra) # 80006446 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036da:	54dc                	lw	a5,44(s1)
    800036dc:	06f04763          	bgtz	a5,8000374a <end_op+0xb6>
    acquire(&log.lock);
    800036e0:	00016497          	auipc	s1,0x16
    800036e4:	34048493          	addi	s1,s1,832 # 80019a20 <log>
    800036e8:	8526                	mv	a0,s1
    800036ea:	00003097          	auipc	ra,0x3
    800036ee:	ca8080e7          	jalr	-856(ra) # 80006392 <acquire>
    log.committing = 0;
    800036f2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036f6:	8526                	mv	a0,s1
    800036f8:	ffffe097          	auipc	ra,0xffffe
    800036fc:	026080e7          	jalr	38(ra) # 8000171e <wakeup>
    release(&log.lock);
    80003700:	8526                	mv	a0,s1
    80003702:	00003097          	auipc	ra,0x3
    80003706:	d44080e7          	jalr	-700(ra) # 80006446 <release>
}
    8000370a:	a815                	j	8000373e <end_op+0xaa>
    8000370c:	ec4e                	sd	s3,24(sp)
    8000370e:	e852                	sd	s4,16(sp)
    80003710:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003712:	00005517          	auipc	a0,0x5
    80003716:	d9e50513          	addi	a0,a0,-610 # 800084b0 <etext+0x4b0>
    8000371a:	00002097          	auipc	ra,0x2
    8000371e:	6a2080e7          	jalr	1698(ra) # 80005dbc <panic>
    wakeup(&log);
    80003722:	00016497          	auipc	s1,0x16
    80003726:	2fe48493          	addi	s1,s1,766 # 80019a20 <log>
    8000372a:	8526                	mv	a0,s1
    8000372c:	ffffe097          	auipc	ra,0xffffe
    80003730:	ff2080e7          	jalr	-14(ra) # 8000171e <wakeup>
  release(&log.lock);
    80003734:	8526                	mv	a0,s1
    80003736:	00003097          	auipc	ra,0x3
    8000373a:	d10080e7          	jalr	-752(ra) # 80006446 <release>
}
    8000373e:	70e2                	ld	ra,56(sp)
    80003740:	7442                	ld	s0,48(sp)
    80003742:	74a2                	ld	s1,40(sp)
    80003744:	7902                	ld	s2,32(sp)
    80003746:	6121                	addi	sp,sp,64
    80003748:	8082                	ret
    8000374a:	ec4e                	sd	s3,24(sp)
    8000374c:	e852                	sd	s4,16(sp)
    8000374e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003750:	00016a97          	auipc	s5,0x16
    80003754:	300a8a93          	addi	s5,s5,768 # 80019a50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003758:	00016a17          	auipc	s4,0x16
    8000375c:	2c8a0a13          	addi	s4,s4,712 # 80019a20 <log>
    80003760:	018a2583          	lw	a1,24(s4)
    80003764:	012585bb          	addw	a1,a1,s2
    80003768:	2585                	addiw	a1,a1,1
    8000376a:	028a2503          	lw	a0,40(s4)
    8000376e:	fffff097          	auipc	ra,0xfffff
    80003772:	ce0080e7          	jalr	-800(ra) # 8000244e <bread>
    80003776:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003778:	000aa583          	lw	a1,0(s5)
    8000377c:	028a2503          	lw	a0,40(s4)
    80003780:	fffff097          	auipc	ra,0xfffff
    80003784:	cce080e7          	jalr	-818(ra) # 8000244e <bread>
    80003788:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000378a:	40000613          	li	a2,1024
    8000378e:	05850593          	addi	a1,a0,88
    80003792:	05848513          	addi	a0,s1,88
    80003796:	ffffd097          	auipc	ra,0xffffd
    8000379a:	a40080e7          	jalr	-1472(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000379e:	8526                	mv	a0,s1
    800037a0:	fffff097          	auipc	ra,0xfffff
    800037a4:	da0080e7          	jalr	-608(ra) # 80002540 <bwrite>
    brelse(from);
    800037a8:	854e                	mv	a0,s3
    800037aa:	fffff097          	auipc	ra,0xfffff
    800037ae:	dd4080e7          	jalr	-556(ra) # 8000257e <brelse>
    brelse(to);
    800037b2:	8526                	mv	a0,s1
    800037b4:	fffff097          	auipc	ra,0xfffff
    800037b8:	dca080e7          	jalr	-566(ra) # 8000257e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037bc:	2905                	addiw	s2,s2,1
    800037be:	0a91                	addi	s5,s5,4
    800037c0:	02ca2783          	lw	a5,44(s4)
    800037c4:	f8f94ee3          	blt	s2,a5,80003760 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037c8:	00000097          	auipc	ra,0x0
    800037cc:	c8c080e7          	jalr	-884(ra) # 80003454 <write_head>
    install_trans(0); // Now install writes to home locations
    800037d0:	4501                	li	a0,0
    800037d2:	00000097          	auipc	ra,0x0
    800037d6:	cec080e7          	jalr	-788(ra) # 800034be <install_trans>
    log.lh.n = 0;
    800037da:	00016797          	auipc	a5,0x16
    800037de:	2607a923          	sw	zero,626(a5) # 80019a4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037e2:	00000097          	auipc	ra,0x0
    800037e6:	c72080e7          	jalr	-910(ra) # 80003454 <write_head>
    800037ea:	69e2                	ld	s3,24(sp)
    800037ec:	6a42                	ld	s4,16(sp)
    800037ee:	6aa2                	ld	s5,8(sp)
    800037f0:	bdc5                	j	800036e0 <end_op+0x4c>

00000000800037f2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037f2:	1101                	addi	sp,sp,-32
    800037f4:	ec06                	sd	ra,24(sp)
    800037f6:	e822                	sd	s0,16(sp)
    800037f8:	e426                	sd	s1,8(sp)
    800037fa:	e04a                	sd	s2,0(sp)
    800037fc:	1000                	addi	s0,sp,32
    800037fe:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003800:	00016917          	auipc	s2,0x16
    80003804:	22090913          	addi	s2,s2,544 # 80019a20 <log>
    80003808:	854a                	mv	a0,s2
    8000380a:	00003097          	auipc	ra,0x3
    8000380e:	b88080e7          	jalr	-1144(ra) # 80006392 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003812:	02c92603          	lw	a2,44(s2)
    80003816:	47f5                	li	a5,29
    80003818:	06c7c563          	blt	a5,a2,80003882 <log_write+0x90>
    8000381c:	00016797          	auipc	a5,0x16
    80003820:	2207a783          	lw	a5,544(a5) # 80019a3c <log+0x1c>
    80003824:	37fd                	addiw	a5,a5,-1
    80003826:	04f65e63          	bge	a2,a5,80003882 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000382a:	00016797          	auipc	a5,0x16
    8000382e:	2167a783          	lw	a5,534(a5) # 80019a40 <log+0x20>
    80003832:	06f05063          	blez	a5,80003892 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003836:	4781                	li	a5,0
    80003838:	06c05563          	blez	a2,800038a2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000383c:	44cc                	lw	a1,12(s1)
    8000383e:	00016717          	auipc	a4,0x16
    80003842:	21270713          	addi	a4,a4,530 # 80019a50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003846:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003848:	4314                	lw	a3,0(a4)
    8000384a:	04b68c63          	beq	a3,a1,800038a2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000384e:	2785                	addiw	a5,a5,1
    80003850:	0711                	addi	a4,a4,4
    80003852:	fef61be3          	bne	a2,a5,80003848 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003856:	0621                	addi	a2,a2,8
    80003858:	060a                	slli	a2,a2,0x2
    8000385a:	00016797          	auipc	a5,0x16
    8000385e:	1c678793          	addi	a5,a5,454 # 80019a20 <log>
    80003862:	97b2                	add	a5,a5,a2
    80003864:	44d8                	lw	a4,12(s1)
    80003866:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003868:	8526                	mv	a0,s1
    8000386a:	fffff097          	auipc	ra,0xfffff
    8000386e:	db0080e7          	jalr	-592(ra) # 8000261a <bpin>
    log.lh.n++;
    80003872:	00016717          	auipc	a4,0x16
    80003876:	1ae70713          	addi	a4,a4,430 # 80019a20 <log>
    8000387a:	575c                	lw	a5,44(a4)
    8000387c:	2785                	addiw	a5,a5,1
    8000387e:	d75c                	sw	a5,44(a4)
    80003880:	a82d                	j	800038ba <log_write+0xc8>
    panic("too big a transaction");
    80003882:	00005517          	auipc	a0,0x5
    80003886:	c3e50513          	addi	a0,a0,-962 # 800084c0 <etext+0x4c0>
    8000388a:	00002097          	auipc	ra,0x2
    8000388e:	532080e7          	jalr	1330(ra) # 80005dbc <panic>
    panic("log_write outside of trans");
    80003892:	00005517          	auipc	a0,0x5
    80003896:	c4650513          	addi	a0,a0,-954 # 800084d8 <etext+0x4d8>
    8000389a:	00002097          	auipc	ra,0x2
    8000389e:	522080e7          	jalr	1314(ra) # 80005dbc <panic>
  log.lh.block[i] = b->blockno;
    800038a2:	00878693          	addi	a3,a5,8
    800038a6:	068a                	slli	a3,a3,0x2
    800038a8:	00016717          	auipc	a4,0x16
    800038ac:	17870713          	addi	a4,a4,376 # 80019a20 <log>
    800038b0:	9736                	add	a4,a4,a3
    800038b2:	44d4                	lw	a3,12(s1)
    800038b4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038b6:	faf609e3          	beq	a2,a5,80003868 <log_write+0x76>
  }
  release(&log.lock);
    800038ba:	00016517          	auipc	a0,0x16
    800038be:	16650513          	addi	a0,a0,358 # 80019a20 <log>
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	b84080e7          	jalr	-1148(ra) # 80006446 <release>
}
    800038ca:	60e2                	ld	ra,24(sp)
    800038cc:	6442                	ld	s0,16(sp)
    800038ce:	64a2                	ld	s1,8(sp)
    800038d0:	6902                	ld	s2,0(sp)
    800038d2:	6105                	addi	sp,sp,32
    800038d4:	8082                	ret

00000000800038d6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038d6:	1101                	addi	sp,sp,-32
    800038d8:	ec06                	sd	ra,24(sp)
    800038da:	e822                	sd	s0,16(sp)
    800038dc:	e426                	sd	s1,8(sp)
    800038de:	e04a                	sd	s2,0(sp)
    800038e0:	1000                	addi	s0,sp,32
    800038e2:	84aa                	mv	s1,a0
    800038e4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038e6:	00005597          	auipc	a1,0x5
    800038ea:	c1258593          	addi	a1,a1,-1006 # 800084f8 <etext+0x4f8>
    800038ee:	0521                	addi	a0,a0,8
    800038f0:	00003097          	auipc	ra,0x3
    800038f4:	a12080e7          	jalr	-1518(ra) # 80006302 <initlock>
  lk->name = name;
    800038f8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038fc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003900:	0204a423          	sw	zero,40(s1)
}
    80003904:	60e2                	ld	ra,24(sp)
    80003906:	6442                	ld	s0,16(sp)
    80003908:	64a2                	ld	s1,8(sp)
    8000390a:	6902                	ld	s2,0(sp)
    8000390c:	6105                	addi	sp,sp,32
    8000390e:	8082                	ret

0000000080003910 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003910:	1101                	addi	sp,sp,-32
    80003912:	ec06                	sd	ra,24(sp)
    80003914:	e822                	sd	s0,16(sp)
    80003916:	e426                	sd	s1,8(sp)
    80003918:	e04a                	sd	s2,0(sp)
    8000391a:	1000                	addi	s0,sp,32
    8000391c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000391e:	00850913          	addi	s2,a0,8
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	a6e080e7          	jalr	-1426(ra) # 80006392 <acquire>
  while (lk->locked) {
    8000392c:	409c                	lw	a5,0(s1)
    8000392e:	cb89                	beqz	a5,80003940 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003930:	85ca                	mv	a1,s2
    80003932:	8526                	mv	a0,s1
    80003934:	ffffe097          	auipc	ra,0xffffe
    80003938:	c5e080e7          	jalr	-930(ra) # 80001592 <sleep>
  while (lk->locked) {
    8000393c:	409c                	lw	a5,0(s1)
    8000393e:	fbed                	bnez	a5,80003930 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003940:	4785                	li	a5,1
    80003942:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003944:	ffffd097          	auipc	ra,0xffffd
    80003948:	538080e7          	jalr	1336(ra) # 80000e7c <myproc>
    8000394c:	591c                	lw	a5,48(a0)
    8000394e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003950:	854a                	mv	a0,s2
    80003952:	00003097          	auipc	ra,0x3
    80003956:	af4080e7          	jalr	-1292(ra) # 80006446 <release>
}
    8000395a:	60e2                	ld	ra,24(sp)
    8000395c:	6442                	ld	s0,16(sp)
    8000395e:	64a2                	ld	s1,8(sp)
    80003960:	6902                	ld	s2,0(sp)
    80003962:	6105                	addi	sp,sp,32
    80003964:	8082                	ret

0000000080003966 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003966:	1101                	addi	sp,sp,-32
    80003968:	ec06                	sd	ra,24(sp)
    8000396a:	e822                	sd	s0,16(sp)
    8000396c:	e426                	sd	s1,8(sp)
    8000396e:	e04a                	sd	s2,0(sp)
    80003970:	1000                	addi	s0,sp,32
    80003972:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003974:	00850913          	addi	s2,a0,8
    80003978:	854a                	mv	a0,s2
    8000397a:	00003097          	auipc	ra,0x3
    8000397e:	a18080e7          	jalr	-1512(ra) # 80006392 <acquire>
  lk->locked = 0;
    80003982:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003986:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000398a:	8526                	mv	a0,s1
    8000398c:	ffffe097          	auipc	ra,0xffffe
    80003990:	d92080e7          	jalr	-622(ra) # 8000171e <wakeup>
  release(&lk->lk);
    80003994:	854a                	mv	a0,s2
    80003996:	00003097          	auipc	ra,0x3
    8000399a:	ab0080e7          	jalr	-1360(ra) # 80006446 <release>
}
    8000399e:	60e2                	ld	ra,24(sp)
    800039a0:	6442                	ld	s0,16(sp)
    800039a2:	64a2                	ld	s1,8(sp)
    800039a4:	6902                	ld	s2,0(sp)
    800039a6:	6105                	addi	sp,sp,32
    800039a8:	8082                	ret

00000000800039aa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039aa:	7179                	addi	sp,sp,-48
    800039ac:	f406                	sd	ra,40(sp)
    800039ae:	f022                	sd	s0,32(sp)
    800039b0:	ec26                	sd	s1,24(sp)
    800039b2:	e84a                	sd	s2,16(sp)
    800039b4:	1800                	addi	s0,sp,48
    800039b6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039b8:	00850913          	addi	s2,a0,8
    800039bc:	854a                	mv	a0,s2
    800039be:	00003097          	auipc	ra,0x3
    800039c2:	9d4080e7          	jalr	-1580(ra) # 80006392 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039c6:	409c                	lw	a5,0(s1)
    800039c8:	ef91                	bnez	a5,800039e4 <holdingsleep+0x3a>
    800039ca:	4481                	li	s1,0
  release(&lk->lk);
    800039cc:	854a                	mv	a0,s2
    800039ce:	00003097          	auipc	ra,0x3
    800039d2:	a78080e7          	jalr	-1416(ra) # 80006446 <release>
  return r;
}
    800039d6:	8526                	mv	a0,s1
    800039d8:	70a2                	ld	ra,40(sp)
    800039da:	7402                	ld	s0,32(sp)
    800039dc:	64e2                	ld	s1,24(sp)
    800039de:	6942                	ld	s2,16(sp)
    800039e0:	6145                	addi	sp,sp,48
    800039e2:	8082                	ret
    800039e4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800039e6:	0284a983          	lw	s3,40(s1)
    800039ea:	ffffd097          	auipc	ra,0xffffd
    800039ee:	492080e7          	jalr	1170(ra) # 80000e7c <myproc>
    800039f2:	5904                	lw	s1,48(a0)
    800039f4:	413484b3          	sub	s1,s1,s3
    800039f8:	0014b493          	seqz	s1,s1
    800039fc:	69a2                	ld	s3,8(sp)
    800039fe:	b7f9                	j	800039cc <holdingsleep+0x22>

0000000080003a00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a00:	1141                	addi	sp,sp,-16
    80003a02:	e406                	sd	ra,8(sp)
    80003a04:	e022                	sd	s0,0(sp)
    80003a06:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a08:	00005597          	auipc	a1,0x5
    80003a0c:	b0058593          	addi	a1,a1,-1280 # 80008508 <etext+0x508>
    80003a10:	00016517          	auipc	a0,0x16
    80003a14:	15850513          	addi	a0,a0,344 # 80019b68 <ftable>
    80003a18:	00003097          	auipc	ra,0x3
    80003a1c:	8ea080e7          	jalr	-1814(ra) # 80006302 <initlock>
}
    80003a20:	60a2                	ld	ra,8(sp)
    80003a22:	6402                	ld	s0,0(sp)
    80003a24:	0141                	addi	sp,sp,16
    80003a26:	8082                	ret

0000000080003a28 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a28:	1101                	addi	sp,sp,-32
    80003a2a:	ec06                	sd	ra,24(sp)
    80003a2c:	e822                	sd	s0,16(sp)
    80003a2e:	e426                	sd	s1,8(sp)
    80003a30:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a32:	00016517          	auipc	a0,0x16
    80003a36:	13650513          	addi	a0,a0,310 # 80019b68 <ftable>
    80003a3a:	00003097          	auipc	ra,0x3
    80003a3e:	958080e7          	jalr	-1704(ra) # 80006392 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a42:	00016497          	auipc	s1,0x16
    80003a46:	13e48493          	addi	s1,s1,318 # 80019b80 <ftable+0x18>
    80003a4a:	00017717          	auipc	a4,0x17
    80003a4e:	0d670713          	addi	a4,a4,214 # 8001ab20 <ftable+0xfb8>
    if(f->ref == 0){
    80003a52:	40dc                	lw	a5,4(s1)
    80003a54:	cf99                	beqz	a5,80003a72 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a56:	02848493          	addi	s1,s1,40
    80003a5a:	fee49ce3          	bne	s1,a4,80003a52 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a5e:	00016517          	auipc	a0,0x16
    80003a62:	10a50513          	addi	a0,a0,266 # 80019b68 <ftable>
    80003a66:	00003097          	auipc	ra,0x3
    80003a6a:	9e0080e7          	jalr	-1568(ra) # 80006446 <release>
  return 0;
    80003a6e:	4481                	li	s1,0
    80003a70:	a819                	j	80003a86 <filealloc+0x5e>
      f->ref = 1;
    80003a72:	4785                	li	a5,1
    80003a74:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a76:	00016517          	auipc	a0,0x16
    80003a7a:	0f250513          	addi	a0,a0,242 # 80019b68 <ftable>
    80003a7e:	00003097          	auipc	ra,0x3
    80003a82:	9c8080e7          	jalr	-1592(ra) # 80006446 <release>
}
    80003a86:	8526                	mv	a0,s1
    80003a88:	60e2                	ld	ra,24(sp)
    80003a8a:	6442                	ld	s0,16(sp)
    80003a8c:	64a2                	ld	s1,8(sp)
    80003a8e:	6105                	addi	sp,sp,32
    80003a90:	8082                	ret

0000000080003a92 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a92:	1101                	addi	sp,sp,-32
    80003a94:	ec06                	sd	ra,24(sp)
    80003a96:	e822                	sd	s0,16(sp)
    80003a98:	e426                	sd	s1,8(sp)
    80003a9a:	1000                	addi	s0,sp,32
    80003a9c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a9e:	00016517          	auipc	a0,0x16
    80003aa2:	0ca50513          	addi	a0,a0,202 # 80019b68 <ftable>
    80003aa6:	00003097          	auipc	ra,0x3
    80003aaa:	8ec080e7          	jalr	-1812(ra) # 80006392 <acquire>
  if(f->ref < 1)
    80003aae:	40dc                	lw	a5,4(s1)
    80003ab0:	02f05263          	blez	a5,80003ad4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ab4:	2785                	addiw	a5,a5,1
    80003ab6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ab8:	00016517          	auipc	a0,0x16
    80003abc:	0b050513          	addi	a0,a0,176 # 80019b68 <ftable>
    80003ac0:	00003097          	auipc	ra,0x3
    80003ac4:	986080e7          	jalr	-1658(ra) # 80006446 <release>
  return f;
}
    80003ac8:	8526                	mv	a0,s1
    80003aca:	60e2                	ld	ra,24(sp)
    80003acc:	6442                	ld	s0,16(sp)
    80003ace:	64a2                	ld	s1,8(sp)
    80003ad0:	6105                	addi	sp,sp,32
    80003ad2:	8082                	ret
    panic("filedup");
    80003ad4:	00005517          	auipc	a0,0x5
    80003ad8:	a3c50513          	addi	a0,a0,-1476 # 80008510 <etext+0x510>
    80003adc:	00002097          	auipc	ra,0x2
    80003ae0:	2e0080e7          	jalr	736(ra) # 80005dbc <panic>

0000000080003ae4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ae4:	7139                	addi	sp,sp,-64
    80003ae6:	fc06                	sd	ra,56(sp)
    80003ae8:	f822                	sd	s0,48(sp)
    80003aea:	f426                	sd	s1,40(sp)
    80003aec:	0080                	addi	s0,sp,64
    80003aee:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003af0:	00016517          	auipc	a0,0x16
    80003af4:	07850513          	addi	a0,a0,120 # 80019b68 <ftable>
    80003af8:	00003097          	auipc	ra,0x3
    80003afc:	89a080e7          	jalr	-1894(ra) # 80006392 <acquire>
  if(f->ref < 1)
    80003b00:	40dc                	lw	a5,4(s1)
    80003b02:	04f05c63          	blez	a5,80003b5a <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003b06:	37fd                	addiw	a5,a5,-1
    80003b08:	0007871b          	sext.w	a4,a5
    80003b0c:	c0dc                	sw	a5,4(s1)
    80003b0e:	06e04263          	bgtz	a4,80003b72 <fileclose+0x8e>
    80003b12:	f04a                	sd	s2,32(sp)
    80003b14:	ec4e                	sd	s3,24(sp)
    80003b16:	e852                	sd	s4,16(sp)
    80003b18:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b1a:	0004a903          	lw	s2,0(s1)
    80003b1e:	0094ca83          	lbu	s5,9(s1)
    80003b22:	0104ba03          	ld	s4,16(s1)
    80003b26:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b2a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b2e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b32:	00016517          	auipc	a0,0x16
    80003b36:	03650513          	addi	a0,a0,54 # 80019b68 <ftable>
    80003b3a:	00003097          	auipc	ra,0x3
    80003b3e:	90c080e7          	jalr	-1780(ra) # 80006446 <release>

  if(ff.type == FD_PIPE){
    80003b42:	4785                	li	a5,1
    80003b44:	04f90463          	beq	s2,a5,80003b8c <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b48:	3979                	addiw	s2,s2,-2
    80003b4a:	4785                	li	a5,1
    80003b4c:	0527fb63          	bgeu	a5,s2,80003ba2 <fileclose+0xbe>
    80003b50:	7902                	ld	s2,32(sp)
    80003b52:	69e2                	ld	s3,24(sp)
    80003b54:	6a42                	ld	s4,16(sp)
    80003b56:	6aa2                	ld	s5,8(sp)
    80003b58:	a02d                	j	80003b82 <fileclose+0x9e>
    80003b5a:	f04a                	sd	s2,32(sp)
    80003b5c:	ec4e                	sd	s3,24(sp)
    80003b5e:	e852                	sd	s4,16(sp)
    80003b60:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b62:	00005517          	auipc	a0,0x5
    80003b66:	9b650513          	addi	a0,a0,-1610 # 80008518 <etext+0x518>
    80003b6a:	00002097          	auipc	ra,0x2
    80003b6e:	252080e7          	jalr	594(ra) # 80005dbc <panic>
    release(&ftable.lock);
    80003b72:	00016517          	auipc	a0,0x16
    80003b76:	ff650513          	addi	a0,a0,-10 # 80019b68 <ftable>
    80003b7a:	00003097          	auipc	ra,0x3
    80003b7e:	8cc080e7          	jalr	-1844(ra) # 80006446 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b82:	70e2                	ld	ra,56(sp)
    80003b84:	7442                	ld	s0,48(sp)
    80003b86:	74a2                	ld	s1,40(sp)
    80003b88:	6121                	addi	sp,sp,64
    80003b8a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b8c:	85d6                	mv	a1,s5
    80003b8e:	8552                	mv	a0,s4
    80003b90:	00000097          	auipc	ra,0x0
    80003b94:	3a2080e7          	jalr	930(ra) # 80003f32 <pipeclose>
    80003b98:	7902                	ld	s2,32(sp)
    80003b9a:	69e2                	ld	s3,24(sp)
    80003b9c:	6a42                	ld	s4,16(sp)
    80003b9e:	6aa2                	ld	s5,8(sp)
    80003ba0:	b7cd                	j	80003b82 <fileclose+0x9e>
    begin_op();
    80003ba2:	00000097          	auipc	ra,0x0
    80003ba6:	a78080e7          	jalr	-1416(ra) # 8000361a <begin_op>
    iput(ff.ip);
    80003baa:	854e                	mv	a0,s3
    80003bac:	fffff097          	auipc	ra,0xfffff
    80003bb0:	25a080e7          	jalr	602(ra) # 80002e06 <iput>
    end_op();
    80003bb4:	00000097          	auipc	ra,0x0
    80003bb8:	ae0080e7          	jalr	-1312(ra) # 80003694 <end_op>
    80003bbc:	7902                	ld	s2,32(sp)
    80003bbe:	69e2                	ld	s3,24(sp)
    80003bc0:	6a42                	ld	s4,16(sp)
    80003bc2:	6aa2                	ld	s5,8(sp)
    80003bc4:	bf7d                	j	80003b82 <fileclose+0x9e>

0000000080003bc6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bc6:	715d                	addi	sp,sp,-80
    80003bc8:	e486                	sd	ra,72(sp)
    80003bca:	e0a2                	sd	s0,64(sp)
    80003bcc:	fc26                	sd	s1,56(sp)
    80003bce:	f44e                	sd	s3,40(sp)
    80003bd0:	0880                	addi	s0,sp,80
    80003bd2:	84aa                	mv	s1,a0
    80003bd4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bd6:	ffffd097          	auipc	ra,0xffffd
    80003bda:	2a6080e7          	jalr	678(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bde:	409c                	lw	a5,0(s1)
    80003be0:	37f9                	addiw	a5,a5,-2
    80003be2:	4705                	li	a4,1
    80003be4:	04f76863          	bltu	a4,a5,80003c34 <filestat+0x6e>
    80003be8:	f84a                	sd	s2,48(sp)
    80003bea:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bec:	6c88                	ld	a0,24(s1)
    80003bee:	fffff097          	auipc	ra,0xfffff
    80003bf2:	05a080e7          	jalr	90(ra) # 80002c48 <ilock>
    stati(f->ip, &st);
    80003bf6:	fb840593          	addi	a1,s0,-72
    80003bfa:	6c88                	ld	a0,24(s1)
    80003bfc:	fffff097          	auipc	ra,0xfffff
    80003c00:	2da080e7          	jalr	730(ra) # 80002ed6 <stati>
    iunlock(f->ip);
    80003c04:	6c88                	ld	a0,24(s1)
    80003c06:	fffff097          	auipc	ra,0xfffff
    80003c0a:	108080e7          	jalr	264(ra) # 80002d0e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c0e:	46e1                	li	a3,24
    80003c10:	fb840613          	addi	a2,s0,-72
    80003c14:	85ce                	mv	a1,s3
    80003c16:	05093503          	ld	a0,80(s2)
    80003c1a:	ffffd097          	auipc	ra,0xffffd
    80003c1e:	efe080e7          	jalr	-258(ra) # 80000b18 <copyout>
    80003c22:	41f5551b          	sraiw	a0,a0,0x1f
    80003c26:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c28:	60a6                	ld	ra,72(sp)
    80003c2a:	6406                	ld	s0,64(sp)
    80003c2c:	74e2                	ld	s1,56(sp)
    80003c2e:	79a2                	ld	s3,40(sp)
    80003c30:	6161                	addi	sp,sp,80
    80003c32:	8082                	ret
  return -1;
    80003c34:	557d                	li	a0,-1
    80003c36:	bfcd                	j	80003c28 <filestat+0x62>

0000000080003c38 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c38:	7179                	addi	sp,sp,-48
    80003c3a:	f406                	sd	ra,40(sp)
    80003c3c:	f022                	sd	s0,32(sp)
    80003c3e:	e84a                	sd	s2,16(sp)
    80003c40:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c42:	00854783          	lbu	a5,8(a0)
    80003c46:	cbc5                	beqz	a5,80003cf6 <fileread+0xbe>
    80003c48:	ec26                	sd	s1,24(sp)
    80003c4a:	e44e                	sd	s3,8(sp)
    80003c4c:	84aa                	mv	s1,a0
    80003c4e:	89ae                	mv	s3,a1
    80003c50:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c52:	411c                	lw	a5,0(a0)
    80003c54:	4705                	li	a4,1
    80003c56:	04e78963          	beq	a5,a4,80003ca8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c5a:	470d                	li	a4,3
    80003c5c:	04e78f63          	beq	a5,a4,80003cba <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c60:	4709                	li	a4,2
    80003c62:	08e79263          	bne	a5,a4,80003ce6 <fileread+0xae>
    ilock(f->ip);
    80003c66:	6d08                	ld	a0,24(a0)
    80003c68:	fffff097          	auipc	ra,0xfffff
    80003c6c:	fe0080e7          	jalr	-32(ra) # 80002c48 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c70:	874a                	mv	a4,s2
    80003c72:	5094                	lw	a3,32(s1)
    80003c74:	864e                	mv	a2,s3
    80003c76:	4585                	li	a1,1
    80003c78:	6c88                	ld	a0,24(s1)
    80003c7a:	fffff097          	auipc	ra,0xfffff
    80003c7e:	286080e7          	jalr	646(ra) # 80002f00 <readi>
    80003c82:	892a                	mv	s2,a0
    80003c84:	00a05563          	blez	a0,80003c8e <fileread+0x56>
      f->off += r;
    80003c88:	509c                	lw	a5,32(s1)
    80003c8a:	9fa9                	addw	a5,a5,a0
    80003c8c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c8e:	6c88                	ld	a0,24(s1)
    80003c90:	fffff097          	auipc	ra,0xfffff
    80003c94:	07e080e7          	jalr	126(ra) # 80002d0e <iunlock>
    80003c98:	64e2                	ld	s1,24(sp)
    80003c9a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c9c:	854a                	mv	a0,s2
    80003c9e:	70a2                	ld	ra,40(sp)
    80003ca0:	7402                	ld	s0,32(sp)
    80003ca2:	6942                	ld	s2,16(sp)
    80003ca4:	6145                	addi	sp,sp,48
    80003ca6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ca8:	6908                	ld	a0,16(a0)
    80003caa:	00000097          	auipc	ra,0x0
    80003cae:	3fa080e7          	jalr	1018(ra) # 800040a4 <piperead>
    80003cb2:	892a                	mv	s2,a0
    80003cb4:	64e2                	ld	s1,24(sp)
    80003cb6:	69a2                	ld	s3,8(sp)
    80003cb8:	b7d5                	j	80003c9c <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cba:	02451783          	lh	a5,36(a0)
    80003cbe:	03079693          	slli	a3,a5,0x30
    80003cc2:	92c1                	srli	a3,a3,0x30
    80003cc4:	4725                	li	a4,9
    80003cc6:	02d76a63          	bltu	a4,a3,80003cfa <fileread+0xc2>
    80003cca:	0792                	slli	a5,a5,0x4
    80003ccc:	00016717          	auipc	a4,0x16
    80003cd0:	dfc70713          	addi	a4,a4,-516 # 80019ac8 <devsw>
    80003cd4:	97ba                	add	a5,a5,a4
    80003cd6:	639c                	ld	a5,0(a5)
    80003cd8:	c78d                	beqz	a5,80003d02 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003cda:	4505                	li	a0,1
    80003cdc:	9782                	jalr	a5
    80003cde:	892a                	mv	s2,a0
    80003ce0:	64e2                	ld	s1,24(sp)
    80003ce2:	69a2                	ld	s3,8(sp)
    80003ce4:	bf65                	j	80003c9c <fileread+0x64>
    panic("fileread");
    80003ce6:	00005517          	auipc	a0,0x5
    80003cea:	84250513          	addi	a0,a0,-1982 # 80008528 <etext+0x528>
    80003cee:	00002097          	auipc	ra,0x2
    80003cf2:	0ce080e7          	jalr	206(ra) # 80005dbc <panic>
    return -1;
    80003cf6:	597d                	li	s2,-1
    80003cf8:	b755                	j	80003c9c <fileread+0x64>
      return -1;
    80003cfa:	597d                	li	s2,-1
    80003cfc:	64e2                	ld	s1,24(sp)
    80003cfe:	69a2                	ld	s3,8(sp)
    80003d00:	bf71                	j	80003c9c <fileread+0x64>
    80003d02:	597d                	li	s2,-1
    80003d04:	64e2                	ld	s1,24(sp)
    80003d06:	69a2                	ld	s3,8(sp)
    80003d08:	bf51                	j	80003c9c <fileread+0x64>

0000000080003d0a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003d0a:	00954783          	lbu	a5,9(a0)
    80003d0e:	12078963          	beqz	a5,80003e40 <filewrite+0x136>
{
    80003d12:	715d                	addi	sp,sp,-80
    80003d14:	e486                	sd	ra,72(sp)
    80003d16:	e0a2                	sd	s0,64(sp)
    80003d18:	f84a                	sd	s2,48(sp)
    80003d1a:	f052                	sd	s4,32(sp)
    80003d1c:	e85a                	sd	s6,16(sp)
    80003d1e:	0880                	addi	s0,sp,80
    80003d20:	892a                	mv	s2,a0
    80003d22:	8b2e                	mv	s6,a1
    80003d24:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d26:	411c                	lw	a5,0(a0)
    80003d28:	4705                	li	a4,1
    80003d2a:	02e78763          	beq	a5,a4,80003d58 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d2e:	470d                	li	a4,3
    80003d30:	02e78a63          	beq	a5,a4,80003d64 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d34:	4709                	li	a4,2
    80003d36:	0ee79863          	bne	a5,a4,80003e26 <filewrite+0x11c>
    80003d3a:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d3c:	0cc05463          	blez	a2,80003e04 <filewrite+0xfa>
    80003d40:	fc26                	sd	s1,56(sp)
    80003d42:	ec56                	sd	s5,24(sp)
    80003d44:	e45e                	sd	s7,8(sp)
    80003d46:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d48:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d4a:	6b85                	lui	s7,0x1
    80003d4c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d50:	6c05                	lui	s8,0x1
    80003d52:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d56:	a851                	j	80003dea <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d58:	6908                	ld	a0,16(a0)
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	248080e7          	jalr	584(ra) # 80003fa2 <pipewrite>
    80003d62:	a85d                	j	80003e18 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d64:	02451783          	lh	a5,36(a0)
    80003d68:	03079693          	slli	a3,a5,0x30
    80003d6c:	92c1                	srli	a3,a3,0x30
    80003d6e:	4725                	li	a4,9
    80003d70:	0cd76a63          	bltu	a4,a3,80003e44 <filewrite+0x13a>
    80003d74:	0792                	slli	a5,a5,0x4
    80003d76:	00016717          	auipc	a4,0x16
    80003d7a:	d5270713          	addi	a4,a4,-686 # 80019ac8 <devsw>
    80003d7e:	97ba                	add	a5,a5,a4
    80003d80:	679c                	ld	a5,8(a5)
    80003d82:	c3f9                	beqz	a5,80003e48 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d84:	4505                	li	a0,1
    80003d86:	9782                	jalr	a5
    80003d88:	a841                	j	80003e18 <filewrite+0x10e>
      if(n1 > max)
    80003d8a:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	88c080e7          	jalr	-1908(ra) # 8000361a <begin_op>
      ilock(f->ip);
    80003d96:	01893503          	ld	a0,24(s2)
    80003d9a:	fffff097          	auipc	ra,0xfffff
    80003d9e:	eae080e7          	jalr	-338(ra) # 80002c48 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003da2:	8756                	mv	a4,s5
    80003da4:	02092683          	lw	a3,32(s2)
    80003da8:	01698633          	add	a2,s3,s6
    80003dac:	4585                	li	a1,1
    80003dae:	01893503          	ld	a0,24(s2)
    80003db2:	fffff097          	auipc	ra,0xfffff
    80003db6:	252080e7          	jalr	594(ra) # 80003004 <writei>
    80003dba:	84aa                	mv	s1,a0
    80003dbc:	00a05763          	blez	a0,80003dca <filewrite+0xc0>
        f->off += r;
    80003dc0:	02092783          	lw	a5,32(s2)
    80003dc4:	9fa9                	addw	a5,a5,a0
    80003dc6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dca:	01893503          	ld	a0,24(s2)
    80003dce:	fffff097          	auipc	ra,0xfffff
    80003dd2:	f40080e7          	jalr	-192(ra) # 80002d0e <iunlock>
      end_op();
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	8be080e7          	jalr	-1858(ra) # 80003694 <end_op>

      if(r != n1){
    80003dde:	029a9563          	bne	s5,s1,80003e08 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003de2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003de6:	0149da63          	bge	s3,s4,80003dfa <filewrite+0xf0>
      int n1 = n - i;
    80003dea:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003dee:	0004879b          	sext.w	a5,s1
    80003df2:	f8fbdce3          	bge	s7,a5,80003d8a <filewrite+0x80>
    80003df6:	84e2                	mv	s1,s8
    80003df8:	bf49                	j	80003d8a <filewrite+0x80>
    80003dfa:	74e2                	ld	s1,56(sp)
    80003dfc:	6ae2                	ld	s5,24(sp)
    80003dfe:	6ba2                	ld	s7,8(sp)
    80003e00:	6c02                	ld	s8,0(sp)
    80003e02:	a039                	j	80003e10 <filewrite+0x106>
    int i = 0;
    80003e04:	4981                	li	s3,0
    80003e06:	a029                	j	80003e10 <filewrite+0x106>
    80003e08:	74e2                	ld	s1,56(sp)
    80003e0a:	6ae2                	ld	s5,24(sp)
    80003e0c:	6ba2                	ld	s7,8(sp)
    80003e0e:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003e10:	033a1e63          	bne	s4,s3,80003e4c <filewrite+0x142>
    80003e14:	8552                	mv	a0,s4
    80003e16:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e18:	60a6                	ld	ra,72(sp)
    80003e1a:	6406                	ld	s0,64(sp)
    80003e1c:	7942                	ld	s2,48(sp)
    80003e1e:	7a02                	ld	s4,32(sp)
    80003e20:	6b42                	ld	s6,16(sp)
    80003e22:	6161                	addi	sp,sp,80
    80003e24:	8082                	ret
    80003e26:	fc26                	sd	s1,56(sp)
    80003e28:	f44e                	sd	s3,40(sp)
    80003e2a:	ec56                	sd	s5,24(sp)
    80003e2c:	e45e                	sd	s7,8(sp)
    80003e2e:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003e30:	00004517          	auipc	a0,0x4
    80003e34:	70850513          	addi	a0,a0,1800 # 80008538 <etext+0x538>
    80003e38:	00002097          	auipc	ra,0x2
    80003e3c:	f84080e7          	jalr	-124(ra) # 80005dbc <panic>
    return -1;
    80003e40:	557d                	li	a0,-1
}
    80003e42:	8082                	ret
      return -1;
    80003e44:	557d                	li	a0,-1
    80003e46:	bfc9                	j	80003e18 <filewrite+0x10e>
    80003e48:	557d                	li	a0,-1
    80003e4a:	b7f9                	j	80003e18 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e4c:	557d                	li	a0,-1
    80003e4e:	79a2                	ld	s3,40(sp)
    80003e50:	b7e1                	j	80003e18 <filewrite+0x10e>

0000000080003e52 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e52:	7179                	addi	sp,sp,-48
    80003e54:	f406                	sd	ra,40(sp)
    80003e56:	f022                	sd	s0,32(sp)
    80003e58:	ec26                	sd	s1,24(sp)
    80003e5a:	e052                	sd	s4,0(sp)
    80003e5c:	1800                	addi	s0,sp,48
    80003e5e:	84aa                	mv	s1,a0
    80003e60:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e62:	0005b023          	sd	zero,0(a1)
    80003e66:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e6a:	00000097          	auipc	ra,0x0
    80003e6e:	bbe080e7          	jalr	-1090(ra) # 80003a28 <filealloc>
    80003e72:	e088                	sd	a0,0(s1)
    80003e74:	cd49                	beqz	a0,80003f0e <pipealloc+0xbc>
    80003e76:	00000097          	auipc	ra,0x0
    80003e7a:	bb2080e7          	jalr	-1102(ra) # 80003a28 <filealloc>
    80003e7e:	00aa3023          	sd	a0,0(s4)
    80003e82:	c141                	beqz	a0,80003f02 <pipealloc+0xb0>
    80003e84:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e86:	ffffc097          	auipc	ra,0xffffc
    80003e8a:	294080e7          	jalr	660(ra) # 8000011a <kalloc>
    80003e8e:	892a                	mv	s2,a0
    80003e90:	c13d                	beqz	a0,80003ef6 <pipealloc+0xa4>
    80003e92:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e94:	4985                	li	s3,1
    80003e96:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e9a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e9e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ea2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ea6:	00004597          	auipc	a1,0x4
    80003eaa:	6a258593          	addi	a1,a1,1698 # 80008548 <etext+0x548>
    80003eae:	00002097          	auipc	ra,0x2
    80003eb2:	454080e7          	jalr	1108(ra) # 80006302 <initlock>
  (*f0)->type = FD_PIPE;
    80003eb6:	609c                	ld	a5,0(s1)
    80003eb8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ebc:	609c                	ld	a5,0(s1)
    80003ebe:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ec2:	609c                	ld	a5,0(s1)
    80003ec4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ec8:	609c                	ld	a5,0(s1)
    80003eca:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ece:	000a3783          	ld	a5,0(s4)
    80003ed2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ed6:	000a3783          	ld	a5,0(s4)
    80003eda:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ede:	000a3783          	ld	a5,0(s4)
    80003ee2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ee6:	000a3783          	ld	a5,0(s4)
    80003eea:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eee:	4501                	li	a0,0
    80003ef0:	6942                	ld	s2,16(sp)
    80003ef2:	69a2                	ld	s3,8(sp)
    80003ef4:	a03d                	j	80003f22 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ef6:	6088                	ld	a0,0(s1)
    80003ef8:	c119                	beqz	a0,80003efe <pipealloc+0xac>
    80003efa:	6942                	ld	s2,16(sp)
    80003efc:	a029                	j	80003f06 <pipealloc+0xb4>
    80003efe:	6942                	ld	s2,16(sp)
    80003f00:	a039                	j	80003f0e <pipealloc+0xbc>
    80003f02:	6088                	ld	a0,0(s1)
    80003f04:	c50d                	beqz	a0,80003f2e <pipealloc+0xdc>
    fileclose(*f0);
    80003f06:	00000097          	auipc	ra,0x0
    80003f0a:	bde080e7          	jalr	-1058(ra) # 80003ae4 <fileclose>
  if(*f1)
    80003f0e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f12:	557d                	li	a0,-1
  if(*f1)
    80003f14:	c799                	beqz	a5,80003f22 <pipealloc+0xd0>
    fileclose(*f1);
    80003f16:	853e                	mv	a0,a5
    80003f18:	00000097          	auipc	ra,0x0
    80003f1c:	bcc080e7          	jalr	-1076(ra) # 80003ae4 <fileclose>
  return -1;
    80003f20:	557d                	li	a0,-1
}
    80003f22:	70a2                	ld	ra,40(sp)
    80003f24:	7402                	ld	s0,32(sp)
    80003f26:	64e2                	ld	s1,24(sp)
    80003f28:	6a02                	ld	s4,0(sp)
    80003f2a:	6145                	addi	sp,sp,48
    80003f2c:	8082                	ret
  return -1;
    80003f2e:	557d                	li	a0,-1
    80003f30:	bfcd                	j	80003f22 <pipealloc+0xd0>

0000000080003f32 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f32:	1101                	addi	sp,sp,-32
    80003f34:	ec06                	sd	ra,24(sp)
    80003f36:	e822                	sd	s0,16(sp)
    80003f38:	e426                	sd	s1,8(sp)
    80003f3a:	e04a                	sd	s2,0(sp)
    80003f3c:	1000                	addi	s0,sp,32
    80003f3e:	84aa                	mv	s1,a0
    80003f40:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f42:	00002097          	auipc	ra,0x2
    80003f46:	450080e7          	jalr	1104(ra) # 80006392 <acquire>
  if(writable){
    80003f4a:	02090d63          	beqz	s2,80003f84 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f4e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f52:	21848513          	addi	a0,s1,536
    80003f56:	ffffd097          	auipc	ra,0xffffd
    80003f5a:	7c8080e7          	jalr	1992(ra) # 8000171e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f5e:	2204b783          	ld	a5,544(s1)
    80003f62:	eb95                	bnez	a5,80003f96 <pipeclose+0x64>
    release(&pi->lock);
    80003f64:	8526                	mv	a0,s1
    80003f66:	00002097          	auipc	ra,0x2
    80003f6a:	4e0080e7          	jalr	1248(ra) # 80006446 <release>
    kfree((char*)pi);
    80003f6e:	8526                	mv	a0,s1
    80003f70:	ffffc097          	auipc	ra,0xffffc
    80003f74:	0ac080e7          	jalr	172(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f78:	60e2                	ld	ra,24(sp)
    80003f7a:	6442                	ld	s0,16(sp)
    80003f7c:	64a2                	ld	s1,8(sp)
    80003f7e:	6902                	ld	s2,0(sp)
    80003f80:	6105                	addi	sp,sp,32
    80003f82:	8082                	ret
    pi->readopen = 0;
    80003f84:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f88:	21c48513          	addi	a0,s1,540
    80003f8c:	ffffd097          	auipc	ra,0xffffd
    80003f90:	792080e7          	jalr	1938(ra) # 8000171e <wakeup>
    80003f94:	b7e9                	j	80003f5e <pipeclose+0x2c>
    release(&pi->lock);
    80003f96:	8526                	mv	a0,s1
    80003f98:	00002097          	auipc	ra,0x2
    80003f9c:	4ae080e7          	jalr	1198(ra) # 80006446 <release>
}
    80003fa0:	bfe1                	j	80003f78 <pipeclose+0x46>

0000000080003fa2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fa2:	711d                	addi	sp,sp,-96
    80003fa4:	ec86                	sd	ra,88(sp)
    80003fa6:	e8a2                	sd	s0,80(sp)
    80003fa8:	e4a6                	sd	s1,72(sp)
    80003faa:	e0ca                	sd	s2,64(sp)
    80003fac:	fc4e                	sd	s3,56(sp)
    80003fae:	f852                	sd	s4,48(sp)
    80003fb0:	f456                	sd	s5,40(sp)
    80003fb2:	1080                	addi	s0,sp,96
    80003fb4:	84aa                	mv	s1,a0
    80003fb6:	8aae                	mv	s5,a1
    80003fb8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fba:	ffffd097          	auipc	ra,0xffffd
    80003fbe:	ec2080e7          	jalr	-318(ra) # 80000e7c <myproc>
    80003fc2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fc4:	8526                	mv	a0,s1
    80003fc6:	00002097          	auipc	ra,0x2
    80003fca:	3cc080e7          	jalr	972(ra) # 80006392 <acquire>
  while(i < n){
    80003fce:	0d405563          	blez	s4,80004098 <pipewrite+0xf6>
    80003fd2:	f05a                	sd	s6,32(sp)
    80003fd4:	ec5e                	sd	s7,24(sp)
    80003fd6:	e862                	sd	s8,16(sp)
  int i = 0;
    80003fd8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fda:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fdc:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fe0:	21c48b93          	addi	s7,s1,540
    80003fe4:	a089                	j	80004026 <pipewrite+0x84>
      release(&pi->lock);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	00002097          	auipc	ra,0x2
    80003fec:	45e080e7          	jalr	1118(ra) # 80006446 <release>
      return -1;
    80003ff0:	597d                	li	s2,-1
    80003ff2:	7b02                	ld	s6,32(sp)
    80003ff4:	6be2                	ld	s7,24(sp)
    80003ff6:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ff8:	854a                	mv	a0,s2
    80003ffa:	60e6                	ld	ra,88(sp)
    80003ffc:	6446                	ld	s0,80(sp)
    80003ffe:	64a6                	ld	s1,72(sp)
    80004000:	6906                	ld	s2,64(sp)
    80004002:	79e2                	ld	s3,56(sp)
    80004004:	7a42                	ld	s4,48(sp)
    80004006:	7aa2                	ld	s5,40(sp)
    80004008:	6125                	addi	sp,sp,96
    8000400a:	8082                	ret
      wakeup(&pi->nread);
    8000400c:	8562                	mv	a0,s8
    8000400e:	ffffd097          	auipc	ra,0xffffd
    80004012:	710080e7          	jalr	1808(ra) # 8000171e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004016:	85a6                	mv	a1,s1
    80004018:	855e                	mv	a0,s7
    8000401a:	ffffd097          	auipc	ra,0xffffd
    8000401e:	578080e7          	jalr	1400(ra) # 80001592 <sleep>
  while(i < n){
    80004022:	05495c63          	bge	s2,s4,8000407a <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80004026:	2204a783          	lw	a5,544(s1)
    8000402a:	dfd5                	beqz	a5,80003fe6 <pipewrite+0x44>
    8000402c:	0289a783          	lw	a5,40(s3)
    80004030:	fbdd                	bnez	a5,80003fe6 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004032:	2184a783          	lw	a5,536(s1)
    80004036:	21c4a703          	lw	a4,540(s1)
    8000403a:	2007879b          	addiw	a5,a5,512
    8000403e:	fcf707e3          	beq	a4,a5,8000400c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004042:	4685                	li	a3,1
    80004044:	01590633          	add	a2,s2,s5
    80004048:	faf40593          	addi	a1,s0,-81
    8000404c:	0509b503          	ld	a0,80(s3)
    80004050:	ffffd097          	auipc	ra,0xffffd
    80004054:	b54080e7          	jalr	-1196(ra) # 80000ba4 <copyin>
    80004058:	05650263          	beq	a0,s6,8000409c <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000405c:	21c4a783          	lw	a5,540(s1)
    80004060:	0017871b          	addiw	a4,a5,1
    80004064:	20e4ae23          	sw	a4,540(s1)
    80004068:	1ff7f793          	andi	a5,a5,511
    8000406c:	97a6                	add	a5,a5,s1
    8000406e:	faf44703          	lbu	a4,-81(s0)
    80004072:	00e78c23          	sb	a4,24(a5)
      i++;
    80004076:	2905                	addiw	s2,s2,1
    80004078:	b76d                	j	80004022 <pipewrite+0x80>
    8000407a:	7b02                	ld	s6,32(sp)
    8000407c:	6be2                	ld	s7,24(sp)
    8000407e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004080:	21848513          	addi	a0,s1,536
    80004084:	ffffd097          	auipc	ra,0xffffd
    80004088:	69a080e7          	jalr	1690(ra) # 8000171e <wakeup>
  release(&pi->lock);
    8000408c:	8526                	mv	a0,s1
    8000408e:	00002097          	auipc	ra,0x2
    80004092:	3b8080e7          	jalr	952(ra) # 80006446 <release>
  return i;
    80004096:	b78d                	j	80003ff8 <pipewrite+0x56>
  int i = 0;
    80004098:	4901                	li	s2,0
    8000409a:	b7dd                	j	80004080 <pipewrite+0xde>
    8000409c:	7b02                	ld	s6,32(sp)
    8000409e:	6be2                	ld	s7,24(sp)
    800040a0:	6c42                	ld	s8,16(sp)
    800040a2:	bff9                	j	80004080 <pipewrite+0xde>

00000000800040a4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040a4:	715d                	addi	sp,sp,-80
    800040a6:	e486                	sd	ra,72(sp)
    800040a8:	e0a2                	sd	s0,64(sp)
    800040aa:	fc26                	sd	s1,56(sp)
    800040ac:	f84a                	sd	s2,48(sp)
    800040ae:	f44e                	sd	s3,40(sp)
    800040b0:	f052                	sd	s4,32(sp)
    800040b2:	ec56                	sd	s5,24(sp)
    800040b4:	0880                	addi	s0,sp,80
    800040b6:	84aa                	mv	s1,a0
    800040b8:	892e                	mv	s2,a1
    800040ba:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040bc:	ffffd097          	auipc	ra,0xffffd
    800040c0:	dc0080e7          	jalr	-576(ra) # 80000e7c <myproc>
    800040c4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040c6:	8526                	mv	a0,s1
    800040c8:	00002097          	auipc	ra,0x2
    800040cc:	2ca080e7          	jalr	714(ra) # 80006392 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040d0:	2184a703          	lw	a4,536(s1)
    800040d4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040d8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040dc:	02f71663          	bne	a4,a5,80004108 <piperead+0x64>
    800040e0:	2244a783          	lw	a5,548(s1)
    800040e4:	cb9d                	beqz	a5,8000411a <piperead+0x76>
    if(pr->killed){
    800040e6:	028a2783          	lw	a5,40(s4)
    800040ea:	e38d                	bnez	a5,8000410c <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040ec:	85a6                	mv	a1,s1
    800040ee:	854e                	mv	a0,s3
    800040f0:	ffffd097          	auipc	ra,0xffffd
    800040f4:	4a2080e7          	jalr	1186(ra) # 80001592 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040f8:	2184a703          	lw	a4,536(s1)
    800040fc:	21c4a783          	lw	a5,540(s1)
    80004100:	fef700e3          	beq	a4,a5,800040e0 <piperead+0x3c>
    80004104:	e85a                	sd	s6,16(sp)
    80004106:	a819                	j	8000411c <piperead+0x78>
    80004108:	e85a                	sd	s6,16(sp)
    8000410a:	a809                	j	8000411c <piperead+0x78>
      release(&pi->lock);
    8000410c:	8526                	mv	a0,s1
    8000410e:	00002097          	auipc	ra,0x2
    80004112:	338080e7          	jalr	824(ra) # 80006446 <release>
      return -1;
    80004116:	59fd                	li	s3,-1
    80004118:	a0a5                	j	80004180 <piperead+0xdc>
    8000411a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000411c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000411e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004120:	05505463          	blez	s5,80004168 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004124:	2184a783          	lw	a5,536(s1)
    80004128:	21c4a703          	lw	a4,540(s1)
    8000412c:	02f70e63          	beq	a4,a5,80004168 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004130:	0017871b          	addiw	a4,a5,1
    80004134:	20e4ac23          	sw	a4,536(s1)
    80004138:	1ff7f793          	andi	a5,a5,511
    8000413c:	97a6                	add	a5,a5,s1
    8000413e:	0187c783          	lbu	a5,24(a5)
    80004142:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004146:	4685                	li	a3,1
    80004148:	fbf40613          	addi	a2,s0,-65
    8000414c:	85ca                	mv	a1,s2
    8000414e:	050a3503          	ld	a0,80(s4)
    80004152:	ffffd097          	auipc	ra,0xffffd
    80004156:	9c6080e7          	jalr	-1594(ra) # 80000b18 <copyout>
    8000415a:	01650763          	beq	a0,s6,80004168 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000415e:	2985                	addiw	s3,s3,1
    80004160:	0905                	addi	s2,s2,1
    80004162:	fd3a91e3          	bne	s5,s3,80004124 <piperead+0x80>
    80004166:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004168:	21c48513          	addi	a0,s1,540
    8000416c:	ffffd097          	auipc	ra,0xffffd
    80004170:	5b2080e7          	jalr	1458(ra) # 8000171e <wakeup>
  release(&pi->lock);
    80004174:	8526                	mv	a0,s1
    80004176:	00002097          	auipc	ra,0x2
    8000417a:	2d0080e7          	jalr	720(ra) # 80006446 <release>
    8000417e:	6b42                	ld	s6,16(sp)
  return i;
}
    80004180:	854e                	mv	a0,s3
    80004182:	60a6                	ld	ra,72(sp)
    80004184:	6406                	ld	s0,64(sp)
    80004186:	74e2                	ld	s1,56(sp)
    80004188:	7942                	ld	s2,48(sp)
    8000418a:	79a2                	ld	s3,40(sp)
    8000418c:	7a02                	ld	s4,32(sp)
    8000418e:	6ae2                	ld	s5,24(sp)
    80004190:	6161                	addi	sp,sp,80
    80004192:	8082                	ret

0000000080004194 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004194:	df010113          	addi	sp,sp,-528
    80004198:	20113423          	sd	ra,520(sp)
    8000419c:	20813023          	sd	s0,512(sp)
    800041a0:	ffa6                	sd	s1,504(sp)
    800041a2:	fbca                	sd	s2,496(sp)
    800041a4:	0c00                	addi	s0,sp,528
    800041a6:	892a                	mv	s2,a0
    800041a8:	dea43c23          	sd	a0,-520(s0)
    800041ac:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041b0:	ffffd097          	auipc	ra,0xffffd
    800041b4:	ccc080e7          	jalr	-820(ra) # 80000e7c <myproc>
    800041b8:	84aa                	mv	s1,a0

  begin_op();
    800041ba:	fffff097          	auipc	ra,0xfffff
    800041be:	460080e7          	jalr	1120(ra) # 8000361a <begin_op>

  if((ip = namei(path)) == 0){
    800041c2:	854a                	mv	a0,s2
    800041c4:	fffff097          	auipc	ra,0xfffff
    800041c8:	256080e7          	jalr	598(ra) # 8000341a <namei>
    800041cc:	c135                	beqz	a0,80004230 <exec+0x9c>
    800041ce:	f3d2                	sd	s4,480(sp)
    800041d0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041d2:	fffff097          	auipc	ra,0xfffff
    800041d6:	a76080e7          	jalr	-1418(ra) # 80002c48 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041da:	04000713          	li	a4,64
    800041de:	4681                	li	a3,0
    800041e0:	e5040613          	addi	a2,s0,-432
    800041e4:	4581                	li	a1,0
    800041e6:	8552                	mv	a0,s4
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	d18080e7          	jalr	-744(ra) # 80002f00 <readi>
    800041f0:	04000793          	li	a5,64
    800041f4:	00f51a63          	bne	a0,a5,80004208 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041f8:	e5042703          	lw	a4,-432(s0)
    800041fc:	464c47b7          	lui	a5,0x464c4
    80004200:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004204:	02f70c63          	beq	a4,a5,8000423c <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004208:	8552                	mv	a0,s4
    8000420a:	fffff097          	auipc	ra,0xfffff
    8000420e:	ca4080e7          	jalr	-860(ra) # 80002eae <iunlockput>
    end_op();
    80004212:	fffff097          	auipc	ra,0xfffff
    80004216:	482080e7          	jalr	1154(ra) # 80003694 <end_op>
  }
  return -1;
    8000421a:	557d                	li	a0,-1
    8000421c:	7a1e                	ld	s4,480(sp)
}
    8000421e:	20813083          	ld	ra,520(sp)
    80004222:	20013403          	ld	s0,512(sp)
    80004226:	74fe                	ld	s1,504(sp)
    80004228:	795e                	ld	s2,496(sp)
    8000422a:	21010113          	addi	sp,sp,528
    8000422e:	8082                	ret
    end_op();
    80004230:	fffff097          	auipc	ra,0xfffff
    80004234:	464080e7          	jalr	1124(ra) # 80003694 <end_op>
    return -1;
    80004238:	557d                	li	a0,-1
    8000423a:	b7d5                	j	8000421e <exec+0x8a>
    8000423c:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000423e:	8526                	mv	a0,s1
    80004240:	ffffd097          	auipc	ra,0xffffd
    80004244:	d00080e7          	jalr	-768(ra) # 80000f40 <proc_pagetable>
    80004248:	8b2a                	mv	s6,a0
    8000424a:	30050563          	beqz	a0,80004554 <exec+0x3c0>
    8000424e:	f7ce                	sd	s3,488(sp)
    80004250:	efd6                	sd	s5,472(sp)
    80004252:	e7de                	sd	s7,456(sp)
    80004254:	e3e2                	sd	s8,448(sp)
    80004256:	ff66                	sd	s9,440(sp)
    80004258:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000425a:	e7042d03          	lw	s10,-400(s0)
    8000425e:	e8845783          	lhu	a5,-376(s0)
    80004262:	14078563          	beqz	a5,800043ac <exec+0x218>
    80004266:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004268:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000426a:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    8000426c:	6c85                	lui	s9,0x1
    8000426e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004272:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004276:	6a85                	lui	s5,0x1
    80004278:	a0b5                	j	800042e4 <exec+0x150>
      panic("loadseg: address should exist");
    8000427a:	00004517          	auipc	a0,0x4
    8000427e:	2d650513          	addi	a0,a0,726 # 80008550 <etext+0x550>
    80004282:	00002097          	auipc	ra,0x2
    80004286:	b3a080e7          	jalr	-1222(ra) # 80005dbc <panic>
    if(sz - i < PGSIZE)
    8000428a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000428c:	8726                	mv	a4,s1
    8000428e:	012c06bb          	addw	a3,s8,s2
    80004292:	4581                	li	a1,0
    80004294:	8552                	mv	a0,s4
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	c6a080e7          	jalr	-918(ra) # 80002f00 <readi>
    8000429e:	2501                	sext.w	a0,a0
    800042a0:	26a49e63          	bne	s1,a0,8000451c <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800042a4:	012a893b          	addw	s2,s5,s2
    800042a8:	03397563          	bgeu	s2,s3,800042d2 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800042ac:	02091593          	slli	a1,s2,0x20
    800042b0:	9181                	srli	a1,a1,0x20
    800042b2:	95de                	add	a1,a1,s7
    800042b4:	855a                	mv	a0,s6
    800042b6:	ffffc097          	auipc	ra,0xffffc
    800042ba:	242080e7          	jalr	578(ra) # 800004f8 <walkaddr>
    800042be:	862a                	mv	a2,a0
    if(pa == 0)
    800042c0:	dd4d                	beqz	a0,8000427a <exec+0xe6>
    if(sz - i < PGSIZE)
    800042c2:	412984bb          	subw	s1,s3,s2
    800042c6:	0004879b          	sext.w	a5,s1
    800042ca:	fcfcf0e3          	bgeu	s9,a5,8000428a <exec+0xf6>
    800042ce:	84d6                	mv	s1,s5
    800042d0:	bf6d                	j	8000428a <exec+0xf6>
    sz = sz1;
    800042d2:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042d6:	2d85                	addiw	s11,s11,1
    800042d8:	038d0d1b          	addiw	s10,s10,56
    800042dc:	e8845783          	lhu	a5,-376(s0)
    800042e0:	06fddf63          	bge	s11,a5,8000435e <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042e4:	2d01                	sext.w	s10,s10
    800042e6:	03800713          	li	a4,56
    800042ea:	86ea                	mv	a3,s10
    800042ec:	e1840613          	addi	a2,s0,-488
    800042f0:	4581                	li	a1,0
    800042f2:	8552                	mv	a0,s4
    800042f4:	fffff097          	auipc	ra,0xfffff
    800042f8:	c0c080e7          	jalr	-1012(ra) # 80002f00 <readi>
    800042fc:	03800793          	li	a5,56
    80004300:	1ef51863          	bne	a0,a5,800044f0 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    80004304:	e1842783          	lw	a5,-488(s0)
    80004308:	4705                	li	a4,1
    8000430a:	fce796e3          	bne	a5,a4,800042d6 <exec+0x142>
    if(ph.memsz < ph.filesz)
    8000430e:	e4043603          	ld	a2,-448(s0)
    80004312:	e3843783          	ld	a5,-456(s0)
    80004316:	1ef66163          	bltu	a2,a5,800044f8 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000431a:	e2843783          	ld	a5,-472(s0)
    8000431e:	963e                	add	a2,a2,a5
    80004320:	1ef66063          	bltu	a2,a5,80004500 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004324:	85a6                	mv	a1,s1
    80004326:	855a                	mv	a0,s6
    80004328:	ffffc097          	auipc	ra,0xffffc
    8000432c:	594080e7          	jalr	1428(ra) # 800008bc <uvmalloc>
    80004330:	e0a43423          	sd	a0,-504(s0)
    80004334:	1c050a63          	beqz	a0,80004508 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004338:	e2843b83          	ld	s7,-472(s0)
    8000433c:	df043783          	ld	a5,-528(s0)
    80004340:	00fbf7b3          	and	a5,s7,a5
    80004344:	1c079a63          	bnez	a5,80004518 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004348:	e2042c03          	lw	s8,-480(s0)
    8000434c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004350:	00098463          	beqz	s3,80004358 <exec+0x1c4>
    80004354:	4901                	li	s2,0
    80004356:	bf99                	j	800042ac <exec+0x118>
    sz = sz1;
    80004358:	e0843483          	ld	s1,-504(s0)
    8000435c:	bfad                	j	800042d6 <exec+0x142>
    8000435e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004360:	8552                	mv	a0,s4
    80004362:	fffff097          	auipc	ra,0xfffff
    80004366:	b4c080e7          	jalr	-1204(ra) # 80002eae <iunlockput>
  end_op();
    8000436a:	fffff097          	auipc	ra,0xfffff
    8000436e:	32a080e7          	jalr	810(ra) # 80003694 <end_op>
  p = myproc();
    80004372:	ffffd097          	auipc	ra,0xffffd
    80004376:	b0a080e7          	jalr	-1270(ra) # 80000e7c <myproc>
    8000437a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000437c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004380:	6985                	lui	s3,0x1
    80004382:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004384:	99a6                	add	s3,s3,s1
    80004386:	77fd                	lui	a5,0xfffff
    80004388:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000438c:	6609                	lui	a2,0x2
    8000438e:	964e                	add	a2,a2,s3
    80004390:	85ce                	mv	a1,s3
    80004392:	855a                	mv	a0,s6
    80004394:	ffffc097          	auipc	ra,0xffffc
    80004398:	528080e7          	jalr	1320(ra) # 800008bc <uvmalloc>
    8000439c:	892a                	mv	s2,a0
    8000439e:	e0a43423          	sd	a0,-504(s0)
    800043a2:	e519                	bnez	a0,800043b0 <exec+0x21c>
  if(pagetable)
    800043a4:	e1343423          	sd	s3,-504(s0)
    800043a8:	4a01                	li	s4,0
    800043aa:	aa95                	j	8000451e <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043ac:	4481                	li	s1,0
    800043ae:	bf4d                	j	80004360 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043b0:	75f9                	lui	a1,0xffffe
    800043b2:	95aa                	add	a1,a1,a0
    800043b4:	855a                	mv	a0,s6
    800043b6:	ffffc097          	auipc	ra,0xffffc
    800043ba:	730080e7          	jalr	1840(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    800043be:	7bfd                	lui	s7,0xfffff
    800043c0:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800043c2:	e0043783          	ld	a5,-512(s0)
    800043c6:	6388                	ld	a0,0(a5)
    800043c8:	c52d                	beqz	a0,80004432 <exec+0x29e>
    800043ca:	e9040993          	addi	s3,s0,-368
    800043ce:	f9040c13          	addi	s8,s0,-112
    800043d2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043d4:	ffffc097          	auipc	ra,0xffffc
    800043d8:	f1a080e7          	jalr	-230(ra) # 800002ee <strlen>
    800043dc:	0015079b          	addiw	a5,a0,1
    800043e0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043e4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043e8:	13796463          	bltu	s2,s7,80004510 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043ec:	e0043d03          	ld	s10,-512(s0)
    800043f0:	000d3a03          	ld	s4,0(s10)
    800043f4:	8552                	mv	a0,s4
    800043f6:	ffffc097          	auipc	ra,0xffffc
    800043fa:	ef8080e7          	jalr	-264(ra) # 800002ee <strlen>
    800043fe:	0015069b          	addiw	a3,a0,1
    80004402:	8652                	mv	a2,s4
    80004404:	85ca                	mv	a1,s2
    80004406:	855a                	mv	a0,s6
    80004408:	ffffc097          	auipc	ra,0xffffc
    8000440c:	710080e7          	jalr	1808(ra) # 80000b18 <copyout>
    80004410:	10054263          	bltz	a0,80004514 <exec+0x380>
    ustack[argc] = sp;
    80004414:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004418:	0485                	addi	s1,s1,1
    8000441a:	008d0793          	addi	a5,s10,8
    8000441e:	e0f43023          	sd	a5,-512(s0)
    80004422:	008d3503          	ld	a0,8(s10)
    80004426:	c909                	beqz	a0,80004438 <exec+0x2a4>
    if(argc >= MAXARG)
    80004428:	09a1                	addi	s3,s3,8
    8000442a:	fb8995e3          	bne	s3,s8,800043d4 <exec+0x240>
  ip = 0;
    8000442e:	4a01                	li	s4,0
    80004430:	a0fd                	j	8000451e <exec+0x38a>
  sp = sz;
    80004432:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004436:	4481                	li	s1,0
  ustack[argc] = 0;
    80004438:	00349793          	slli	a5,s1,0x3
    8000443c:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    80004440:	97a2                	add	a5,a5,s0
    80004442:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004446:	00148693          	addi	a3,s1,1
    8000444a:	068e                	slli	a3,a3,0x3
    8000444c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004450:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004454:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004458:	f57966e3          	bltu	s2,s7,800043a4 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000445c:	e9040613          	addi	a2,s0,-368
    80004460:	85ca                	mv	a1,s2
    80004462:	855a                	mv	a0,s6
    80004464:	ffffc097          	auipc	ra,0xffffc
    80004468:	6b4080e7          	jalr	1716(ra) # 80000b18 <copyout>
    8000446c:	0e054663          	bltz	a0,80004558 <exec+0x3c4>
  p->trapframe->a1 = sp;
    80004470:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004474:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004478:	df843783          	ld	a5,-520(s0)
    8000447c:	0007c703          	lbu	a4,0(a5)
    80004480:	cf11                	beqz	a4,8000449c <exec+0x308>
    80004482:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004484:	02f00693          	li	a3,47
    80004488:	a039                	j	80004496 <exec+0x302>
      last = s+1;
    8000448a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000448e:	0785                	addi	a5,a5,1
    80004490:	fff7c703          	lbu	a4,-1(a5)
    80004494:	c701                	beqz	a4,8000449c <exec+0x308>
    if(*s == '/')
    80004496:	fed71ce3          	bne	a4,a3,8000448e <exec+0x2fa>
    8000449a:	bfc5                	j	8000448a <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    8000449c:	4641                	li	a2,16
    8000449e:	df843583          	ld	a1,-520(s0)
    800044a2:	158a8513          	addi	a0,s5,344
    800044a6:	ffffc097          	auipc	ra,0xffffc
    800044aa:	e16080e7          	jalr	-490(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    800044ae:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044b2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800044b6:	e0843783          	ld	a5,-504(s0)
    800044ba:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044be:	058ab783          	ld	a5,88(s5)
    800044c2:	e6843703          	ld	a4,-408(s0)
    800044c6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044c8:	058ab783          	ld	a5,88(s5)
    800044cc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044d0:	85e6                	mv	a1,s9
    800044d2:	ffffd097          	auipc	ra,0xffffd
    800044d6:	b0a080e7          	jalr	-1270(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044da:	0004851b          	sext.w	a0,s1
    800044de:	79be                	ld	s3,488(sp)
    800044e0:	7a1e                	ld	s4,480(sp)
    800044e2:	6afe                	ld	s5,472(sp)
    800044e4:	6b5e                	ld	s6,464(sp)
    800044e6:	6bbe                	ld	s7,456(sp)
    800044e8:	6c1e                	ld	s8,448(sp)
    800044ea:	7cfa                	ld	s9,440(sp)
    800044ec:	7d5a                	ld	s10,432(sp)
    800044ee:	bb05                	j	8000421e <exec+0x8a>
    800044f0:	e0943423          	sd	s1,-504(s0)
    800044f4:	7dba                	ld	s11,424(sp)
    800044f6:	a025                	j	8000451e <exec+0x38a>
    800044f8:	e0943423          	sd	s1,-504(s0)
    800044fc:	7dba                	ld	s11,424(sp)
    800044fe:	a005                	j	8000451e <exec+0x38a>
    80004500:	e0943423          	sd	s1,-504(s0)
    80004504:	7dba                	ld	s11,424(sp)
    80004506:	a821                	j	8000451e <exec+0x38a>
    80004508:	e0943423          	sd	s1,-504(s0)
    8000450c:	7dba                	ld	s11,424(sp)
    8000450e:	a801                	j	8000451e <exec+0x38a>
  ip = 0;
    80004510:	4a01                	li	s4,0
    80004512:	a031                	j	8000451e <exec+0x38a>
    80004514:	4a01                	li	s4,0
  if(pagetable)
    80004516:	a021                	j	8000451e <exec+0x38a>
    80004518:	7dba                	ld	s11,424(sp)
    8000451a:	a011                	j	8000451e <exec+0x38a>
    8000451c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000451e:	e0843583          	ld	a1,-504(s0)
    80004522:	855a                	mv	a0,s6
    80004524:	ffffd097          	auipc	ra,0xffffd
    80004528:	ab8080e7          	jalr	-1352(ra) # 80000fdc <proc_freepagetable>
  return -1;
    8000452c:	557d                	li	a0,-1
  if(ip){
    8000452e:	000a1b63          	bnez	s4,80004544 <exec+0x3b0>
    80004532:	79be                	ld	s3,488(sp)
    80004534:	7a1e                	ld	s4,480(sp)
    80004536:	6afe                	ld	s5,472(sp)
    80004538:	6b5e                	ld	s6,464(sp)
    8000453a:	6bbe                	ld	s7,456(sp)
    8000453c:	6c1e                	ld	s8,448(sp)
    8000453e:	7cfa                	ld	s9,440(sp)
    80004540:	7d5a                	ld	s10,432(sp)
    80004542:	b9f1                	j	8000421e <exec+0x8a>
    80004544:	79be                	ld	s3,488(sp)
    80004546:	6afe                	ld	s5,472(sp)
    80004548:	6b5e                	ld	s6,464(sp)
    8000454a:	6bbe                	ld	s7,456(sp)
    8000454c:	6c1e                	ld	s8,448(sp)
    8000454e:	7cfa                	ld	s9,440(sp)
    80004550:	7d5a                	ld	s10,432(sp)
    80004552:	b95d                	j	80004208 <exec+0x74>
    80004554:	6b5e                	ld	s6,464(sp)
    80004556:	b94d                	j	80004208 <exec+0x74>
  sz = sz1;
    80004558:	e0843983          	ld	s3,-504(s0)
    8000455c:	b5a1                	j	800043a4 <exec+0x210>

000000008000455e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000455e:	7179                	addi	sp,sp,-48
    80004560:	f406                	sd	ra,40(sp)
    80004562:	f022                	sd	s0,32(sp)
    80004564:	ec26                	sd	s1,24(sp)
    80004566:	e84a                	sd	s2,16(sp)
    80004568:	1800                	addi	s0,sp,48
    8000456a:	892e                	mv	s2,a1
    8000456c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000456e:	fdc40593          	addi	a1,s0,-36
    80004572:	ffffe097          	auipc	ra,0xffffe
    80004576:	af8080e7          	jalr	-1288(ra) # 8000206a <argint>
    8000457a:	04054063          	bltz	a0,800045ba <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000457e:	fdc42703          	lw	a4,-36(s0)
    80004582:	47bd                	li	a5,15
    80004584:	02e7ed63          	bltu	a5,a4,800045be <argfd+0x60>
    80004588:	ffffd097          	auipc	ra,0xffffd
    8000458c:	8f4080e7          	jalr	-1804(ra) # 80000e7c <myproc>
    80004590:	fdc42703          	lw	a4,-36(s0)
    80004594:	01a70793          	addi	a5,a4,26
    80004598:	078e                	slli	a5,a5,0x3
    8000459a:	953e                	add	a0,a0,a5
    8000459c:	611c                	ld	a5,0(a0)
    8000459e:	c395                	beqz	a5,800045c2 <argfd+0x64>
    return -1;
  if(pfd)
    800045a0:	00090463          	beqz	s2,800045a8 <argfd+0x4a>
    *pfd = fd;
    800045a4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045a8:	4501                	li	a0,0
  if(pf)
    800045aa:	c091                	beqz	s1,800045ae <argfd+0x50>
    *pf = f;
    800045ac:	e09c                	sd	a5,0(s1)
}
    800045ae:	70a2                	ld	ra,40(sp)
    800045b0:	7402                	ld	s0,32(sp)
    800045b2:	64e2                	ld	s1,24(sp)
    800045b4:	6942                	ld	s2,16(sp)
    800045b6:	6145                	addi	sp,sp,48
    800045b8:	8082                	ret
    return -1;
    800045ba:	557d                	li	a0,-1
    800045bc:	bfcd                	j	800045ae <argfd+0x50>
    return -1;
    800045be:	557d                	li	a0,-1
    800045c0:	b7fd                	j	800045ae <argfd+0x50>
    800045c2:	557d                	li	a0,-1
    800045c4:	b7ed                	j	800045ae <argfd+0x50>

00000000800045c6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045c6:	1101                	addi	sp,sp,-32
    800045c8:	ec06                	sd	ra,24(sp)
    800045ca:	e822                	sd	s0,16(sp)
    800045cc:	e426                	sd	s1,8(sp)
    800045ce:	1000                	addi	s0,sp,32
    800045d0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045d2:	ffffd097          	auipc	ra,0xffffd
    800045d6:	8aa080e7          	jalr	-1878(ra) # 80000e7c <myproc>
    800045da:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045dc:	0d050793          	addi	a5,a0,208
    800045e0:	4501                	li	a0,0
    800045e2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045e4:	6398                	ld	a4,0(a5)
    800045e6:	cb19                	beqz	a4,800045fc <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045e8:	2505                	addiw	a0,a0,1
    800045ea:	07a1                	addi	a5,a5,8
    800045ec:	fed51ce3          	bne	a0,a3,800045e4 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045f0:	557d                	li	a0,-1
}
    800045f2:	60e2                	ld	ra,24(sp)
    800045f4:	6442                	ld	s0,16(sp)
    800045f6:	64a2                	ld	s1,8(sp)
    800045f8:	6105                	addi	sp,sp,32
    800045fa:	8082                	ret
      p->ofile[fd] = f;
    800045fc:	01a50793          	addi	a5,a0,26
    80004600:	078e                	slli	a5,a5,0x3
    80004602:	963e                	add	a2,a2,a5
    80004604:	e204                	sd	s1,0(a2)
      return fd;
    80004606:	b7f5                	j	800045f2 <fdalloc+0x2c>

0000000080004608 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004608:	715d                	addi	sp,sp,-80
    8000460a:	e486                	sd	ra,72(sp)
    8000460c:	e0a2                	sd	s0,64(sp)
    8000460e:	fc26                	sd	s1,56(sp)
    80004610:	f84a                	sd	s2,48(sp)
    80004612:	f44e                	sd	s3,40(sp)
    80004614:	f052                	sd	s4,32(sp)
    80004616:	ec56                	sd	s5,24(sp)
    80004618:	0880                	addi	s0,sp,80
    8000461a:	8aae                	mv	s5,a1
    8000461c:	8a32                	mv	s4,a2
    8000461e:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004620:	fb040593          	addi	a1,s0,-80
    80004624:	fffff097          	auipc	ra,0xfffff
    80004628:	e14080e7          	jalr	-492(ra) # 80003438 <nameiparent>
    8000462c:	892a                	mv	s2,a0
    8000462e:	12050c63          	beqz	a0,80004766 <create+0x15e>
    return 0;

  ilock(dp);
    80004632:	ffffe097          	auipc	ra,0xffffe
    80004636:	616080e7          	jalr	1558(ra) # 80002c48 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000463a:	4601                	li	a2,0
    8000463c:	fb040593          	addi	a1,s0,-80
    80004640:	854a                	mv	a0,s2
    80004642:	fffff097          	auipc	ra,0xfffff
    80004646:	b06080e7          	jalr	-1274(ra) # 80003148 <dirlookup>
    8000464a:	84aa                	mv	s1,a0
    8000464c:	c539                	beqz	a0,8000469a <create+0x92>
    iunlockput(dp);
    8000464e:	854a                	mv	a0,s2
    80004650:	fffff097          	auipc	ra,0xfffff
    80004654:	85e080e7          	jalr	-1954(ra) # 80002eae <iunlockput>
    ilock(ip);
    80004658:	8526                	mv	a0,s1
    8000465a:	ffffe097          	auipc	ra,0xffffe
    8000465e:	5ee080e7          	jalr	1518(ra) # 80002c48 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004662:	4789                	li	a5,2
    80004664:	02fa9463          	bne	s5,a5,8000468c <create+0x84>
    80004668:	0444d783          	lhu	a5,68(s1)
    8000466c:	37f9                	addiw	a5,a5,-2
    8000466e:	17c2                	slli	a5,a5,0x30
    80004670:	93c1                	srli	a5,a5,0x30
    80004672:	4705                	li	a4,1
    80004674:	00f76c63          	bltu	a4,a5,8000468c <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004678:	8526                	mv	a0,s1
    8000467a:	60a6                	ld	ra,72(sp)
    8000467c:	6406                	ld	s0,64(sp)
    8000467e:	74e2                	ld	s1,56(sp)
    80004680:	7942                	ld	s2,48(sp)
    80004682:	79a2                	ld	s3,40(sp)
    80004684:	7a02                	ld	s4,32(sp)
    80004686:	6ae2                	ld	s5,24(sp)
    80004688:	6161                	addi	sp,sp,80
    8000468a:	8082                	ret
    iunlockput(ip);
    8000468c:	8526                	mv	a0,s1
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	820080e7          	jalr	-2016(ra) # 80002eae <iunlockput>
    return 0;
    80004696:	4481                	li	s1,0
    80004698:	b7c5                	j	80004678 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000469a:	85d6                	mv	a1,s5
    8000469c:	00092503          	lw	a0,0(s2)
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	414080e7          	jalr	1044(ra) # 80002ab4 <ialloc>
    800046a8:	84aa                	mv	s1,a0
    800046aa:	c139                	beqz	a0,800046f0 <create+0xe8>
  ilock(ip);
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	59c080e7          	jalr	1436(ra) # 80002c48 <ilock>
  ip->major = major;
    800046b4:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800046b8:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800046bc:	4985                	li	s3,1
    800046be:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800046c2:	8526                	mv	a0,s1
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	4b8080e7          	jalr	1208(ra) # 80002b7c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046cc:	033a8a63          	beq	s5,s3,80004700 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800046d0:	40d0                	lw	a2,4(s1)
    800046d2:	fb040593          	addi	a1,s0,-80
    800046d6:	854a                	mv	a0,s2
    800046d8:	fffff097          	auipc	ra,0xfffff
    800046dc:	c80080e7          	jalr	-896(ra) # 80003358 <dirlink>
    800046e0:	06054b63          	bltz	a0,80004756 <create+0x14e>
  iunlockput(dp);
    800046e4:	854a                	mv	a0,s2
    800046e6:	ffffe097          	auipc	ra,0xffffe
    800046ea:	7c8080e7          	jalr	1992(ra) # 80002eae <iunlockput>
  return ip;
    800046ee:	b769                	j	80004678 <create+0x70>
    panic("create: ialloc");
    800046f0:	00004517          	auipc	a0,0x4
    800046f4:	e8050513          	addi	a0,a0,-384 # 80008570 <etext+0x570>
    800046f8:	00001097          	auipc	ra,0x1
    800046fc:	6c4080e7          	jalr	1732(ra) # 80005dbc <panic>
    dp->nlink++;  // for ".."
    80004700:	04a95783          	lhu	a5,74(s2)
    80004704:	2785                	addiw	a5,a5,1
    80004706:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000470a:	854a                	mv	a0,s2
    8000470c:	ffffe097          	auipc	ra,0xffffe
    80004710:	470080e7          	jalr	1136(ra) # 80002b7c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004714:	40d0                	lw	a2,4(s1)
    80004716:	00004597          	auipc	a1,0x4
    8000471a:	e6a58593          	addi	a1,a1,-406 # 80008580 <etext+0x580>
    8000471e:	8526                	mv	a0,s1
    80004720:	fffff097          	auipc	ra,0xfffff
    80004724:	c38080e7          	jalr	-968(ra) # 80003358 <dirlink>
    80004728:	00054f63          	bltz	a0,80004746 <create+0x13e>
    8000472c:	00492603          	lw	a2,4(s2)
    80004730:	00004597          	auipc	a1,0x4
    80004734:	e5858593          	addi	a1,a1,-424 # 80008588 <etext+0x588>
    80004738:	8526                	mv	a0,s1
    8000473a:	fffff097          	auipc	ra,0xfffff
    8000473e:	c1e080e7          	jalr	-994(ra) # 80003358 <dirlink>
    80004742:	f80557e3          	bgez	a0,800046d0 <create+0xc8>
      panic("create dots");
    80004746:	00004517          	auipc	a0,0x4
    8000474a:	e4a50513          	addi	a0,a0,-438 # 80008590 <etext+0x590>
    8000474e:	00001097          	auipc	ra,0x1
    80004752:	66e080e7          	jalr	1646(ra) # 80005dbc <panic>
    panic("create: dirlink");
    80004756:	00004517          	auipc	a0,0x4
    8000475a:	e4a50513          	addi	a0,a0,-438 # 800085a0 <etext+0x5a0>
    8000475e:	00001097          	auipc	ra,0x1
    80004762:	65e080e7          	jalr	1630(ra) # 80005dbc <panic>
    return 0;
    80004766:	84aa                	mv	s1,a0
    80004768:	bf01                	j	80004678 <create+0x70>

000000008000476a <sys_dup>:
{
    8000476a:	7179                	addi	sp,sp,-48
    8000476c:	f406                	sd	ra,40(sp)
    8000476e:	f022                	sd	s0,32(sp)
    80004770:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004772:	fd840613          	addi	a2,s0,-40
    80004776:	4581                	li	a1,0
    80004778:	4501                	li	a0,0
    8000477a:	00000097          	auipc	ra,0x0
    8000477e:	de4080e7          	jalr	-540(ra) # 8000455e <argfd>
    return -1;
    80004782:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004784:	02054763          	bltz	a0,800047b2 <sys_dup+0x48>
    80004788:	ec26                	sd	s1,24(sp)
    8000478a:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000478c:	fd843903          	ld	s2,-40(s0)
    80004790:	854a                	mv	a0,s2
    80004792:	00000097          	auipc	ra,0x0
    80004796:	e34080e7          	jalr	-460(ra) # 800045c6 <fdalloc>
    8000479a:	84aa                	mv	s1,a0
    return -1;
    8000479c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000479e:	00054f63          	bltz	a0,800047bc <sys_dup+0x52>
  filedup(f);
    800047a2:	854a                	mv	a0,s2
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	2ee080e7          	jalr	750(ra) # 80003a92 <filedup>
  return fd;
    800047ac:	87a6                	mv	a5,s1
    800047ae:	64e2                	ld	s1,24(sp)
    800047b0:	6942                	ld	s2,16(sp)
}
    800047b2:	853e                	mv	a0,a5
    800047b4:	70a2                	ld	ra,40(sp)
    800047b6:	7402                	ld	s0,32(sp)
    800047b8:	6145                	addi	sp,sp,48
    800047ba:	8082                	ret
    800047bc:	64e2                	ld	s1,24(sp)
    800047be:	6942                	ld	s2,16(sp)
    800047c0:	bfcd                	j	800047b2 <sys_dup+0x48>

00000000800047c2 <sys_read>:
{
    800047c2:	7179                	addi	sp,sp,-48
    800047c4:	f406                	sd	ra,40(sp)
    800047c6:	f022                	sd	s0,32(sp)
    800047c8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ca:	fe840613          	addi	a2,s0,-24
    800047ce:	4581                	li	a1,0
    800047d0:	4501                	li	a0,0
    800047d2:	00000097          	auipc	ra,0x0
    800047d6:	d8c080e7          	jalr	-628(ra) # 8000455e <argfd>
    return -1;
    800047da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047dc:	04054163          	bltz	a0,8000481e <sys_read+0x5c>
    800047e0:	fe440593          	addi	a1,s0,-28
    800047e4:	4509                	li	a0,2
    800047e6:	ffffe097          	auipc	ra,0xffffe
    800047ea:	884080e7          	jalr	-1916(ra) # 8000206a <argint>
    return -1;
    800047ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047f0:	02054763          	bltz	a0,8000481e <sys_read+0x5c>
    800047f4:	fd840593          	addi	a1,s0,-40
    800047f8:	4505                	li	a0,1
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	892080e7          	jalr	-1902(ra) # 8000208c <argaddr>
    return -1;
    80004802:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004804:	00054d63          	bltz	a0,8000481e <sys_read+0x5c>
  return fileread(f, p, n);
    80004808:	fe442603          	lw	a2,-28(s0)
    8000480c:	fd843583          	ld	a1,-40(s0)
    80004810:	fe843503          	ld	a0,-24(s0)
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	424080e7          	jalr	1060(ra) # 80003c38 <fileread>
    8000481c:	87aa                	mv	a5,a0
}
    8000481e:	853e                	mv	a0,a5
    80004820:	70a2                	ld	ra,40(sp)
    80004822:	7402                	ld	s0,32(sp)
    80004824:	6145                	addi	sp,sp,48
    80004826:	8082                	ret

0000000080004828 <sys_write>:
{
    80004828:	7179                	addi	sp,sp,-48
    8000482a:	f406                	sd	ra,40(sp)
    8000482c:	f022                	sd	s0,32(sp)
    8000482e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004830:	fe840613          	addi	a2,s0,-24
    80004834:	4581                	li	a1,0
    80004836:	4501                	li	a0,0
    80004838:	00000097          	auipc	ra,0x0
    8000483c:	d26080e7          	jalr	-730(ra) # 8000455e <argfd>
    return -1;
    80004840:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004842:	04054163          	bltz	a0,80004884 <sys_write+0x5c>
    80004846:	fe440593          	addi	a1,s0,-28
    8000484a:	4509                	li	a0,2
    8000484c:	ffffe097          	auipc	ra,0xffffe
    80004850:	81e080e7          	jalr	-2018(ra) # 8000206a <argint>
    return -1;
    80004854:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004856:	02054763          	bltz	a0,80004884 <sys_write+0x5c>
    8000485a:	fd840593          	addi	a1,s0,-40
    8000485e:	4505                	li	a0,1
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	82c080e7          	jalr	-2004(ra) # 8000208c <argaddr>
    return -1;
    80004868:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486a:	00054d63          	bltz	a0,80004884 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000486e:	fe442603          	lw	a2,-28(s0)
    80004872:	fd843583          	ld	a1,-40(s0)
    80004876:	fe843503          	ld	a0,-24(s0)
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	490080e7          	jalr	1168(ra) # 80003d0a <filewrite>
    80004882:	87aa                	mv	a5,a0
}
    80004884:	853e                	mv	a0,a5
    80004886:	70a2                	ld	ra,40(sp)
    80004888:	7402                	ld	s0,32(sp)
    8000488a:	6145                	addi	sp,sp,48
    8000488c:	8082                	ret

000000008000488e <sys_close>:
{
    8000488e:	1101                	addi	sp,sp,-32
    80004890:	ec06                	sd	ra,24(sp)
    80004892:	e822                	sd	s0,16(sp)
    80004894:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004896:	fe040613          	addi	a2,s0,-32
    8000489a:	fec40593          	addi	a1,s0,-20
    8000489e:	4501                	li	a0,0
    800048a0:	00000097          	auipc	ra,0x0
    800048a4:	cbe080e7          	jalr	-834(ra) # 8000455e <argfd>
    return -1;
    800048a8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048aa:	02054463          	bltz	a0,800048d2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048ae:	ffffc097          	auipc	ra,0xffffc
    800048b2:	5ce080e7          	jalr	1486(ra) # 80000e7c <myproc>
    800048b6:	fec42783          	lw	a5,-20(s0)
    800048ba:	07e9                	addi	a5,a5,26
    800048bc:	078e                	slli	a5,a5,0x3
    800048be:	953e                	add	a0,a0,a5
    800048c0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800048c4:	fe043503          	ld	a0,-32(s0)
    800048c8:	fffff097          	auipc	ra,0xfffff
    800048cc:	21c080e7          	jalr	540(ra) # 80003ae4 <fileclose>
  return 0;
    800048d0:	4781                	li	a5,0
}
    800048d2:	853e                	mv	a0,a5
    800048d4:	60e2                	ld	ra,24(sp)
    800048d6:	6442                	ld	s0,16(sp)
    800048d8:	6105                	addi	sp,sp,32
    800048da:	8082                	ret

00000000800048dc <sys_fstat>:
{
    800048dc:	1101                	addi	sp,sp,-32
    800048de:	ec06                	sd	ra,24(sp)
    800048e0:	e822                	sd	s0,16(sp)
    800048e2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048e4:	fe840613          	addi	a2,s0,-24
    800048e8:	4581                	li	a1,0
    800048ea:	4501                	li	a0,0
    800048ec:	00000097          	auipc	ra,0x0
    800048f0:	c72080e7          	jalr	-910(ra) # 8000455e <argfd>
    return -1;
    800048f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048f6:	02054563          	bltz	a0,80004920 <sys_fstat+0x44>
    800048fa:	fe040593          	addi	a1,s0,-32
    800048fe:	4505                	li	a0,1
    80004900:	ffffd097          	auipc	ra,0xffffd
    80004904:	78c080e7          	jalr	1932(ra) # 8000208c <argaddr>
    return -1;
    80004908:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000490a:	00054b63          	bltz	a0,80004920 <sys_fstat+0x44>
  return filestat(f, st);
    8000490e:	fe043583          	ld	a1,-32(s0)
    80004912:	fe843503          	ld	a0,-24(s0)
    80004916:	fffff097          	auipc	ra,0xfffff
    8000491a:	2b0080e7          	jalr	688(ra) # 80003bc6 <filestat>
    8000491e:	87aa                	mv	a5,a0
}
    80004920:	853e                	mv	a0,a5
    80004922:	60e2                	ld	ra,24(sp)
    80004924:	6442                	ld	s0,16(sp)
    80004926:	6105                	addi	sp,sp,32
    80004928:	8082                	ret

000000008000492a <sys_link>:
{
    8000492a:	7169                	addi	sp,sp,-304
    8000492c:	f606                	sd	ra,296(sp)
    8000492e:	f222                	sd	s0,288(sp)
    80004930:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004932:	08000613          	li	a2,128
    80004936:	ed040593          	addi	a1,s0,-304
    8000493a:	4501                	li	a0,0
    8000493c:	ffffd097          	auipc	ra,0xffffd
    80004940:	772080e7          	jalr	1906(ra) # 800020ae <argstr>
    return -1;
    80004944:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004946:	12054663          	bltz	a0,80004a72 <sys_link+0x148>
    8000494a:	08000613          	li	a2,128
    8000494e:	f5040593          	addi	a1,s0,-176
    80004952:	4505                	li	a0,1
    80004954:	ffffd097          	auipc	ra,0xffffd
    80004958:	75a080e7          	jalr	1882(ra) # 800020ae <argstr>
    return -1;
    8000495c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000495e:	10054a63          	bltz	a0,80004a72 <sys_link+0x148>
    80004962:	ee26                	sd	s1,280(sp)
  begin_op();
    80004964:	fffff097          	auipc	ra,0xfffff
    80004968:	cb6080e7          	jalr	-842(ra) # 8000361a <begin_op>
  if((ip = namei(old)) == 0){
    8000496c:	ed040513          	addi	a0,s0,-304
    80004970:	fffff097          	auipc	ra,0xfffff
    80004974:	aaa080e7          	jalr	-1366(ra) # 8000341a <namei>
    80004978:	84aa                	mv	s1,a0
    8000497a:	c949                	beqz	a0,80004a0c <sys_link+0xe2>
  ilock(ip);
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	2cc080e7          	jalr	716(ra) # 80002c48 <ilock>
  if(ip->type == T_DIR){
    80004984:	04449703          	lh	a4,68(s1)
    80004988:	4785                	li	a5,1
    8000498a:	08f70863          	beq	a4,a5,80004a1a <sys_link+0xf0>
    8000498e:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004990:	04a4d783          	lhu	a5,74(s1)
    80004994:	2785                	addiw	a5,a5,1
    80004996:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000499a:	8526                	mv	a0,s1
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	1e0080e7          	jalr	480(ra) # 80002b7c <iupdate>
  iunlock(ip);
    800049a4:	8526                	mv	a0,s1
    800049a6:	ffffe097          	auipc	ra,0xffffe
    800049aa:	368080e7          	jalr	872(ra) # 80002d0e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049ae:	fd040593          	addi	a1,s0,-48
    800049b2:	f5040513          	addi	a0,s0,-176
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	a82080e7          	jalr	-1406(ra) # 80003438 <nameiparent>
    800049be:	892a                	mv	s2,a0
    800049c0:	cd35                	beqz	a0,80004a3c <sys_link+0x112>
  ilock(dp);
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	286080e7          	jalr	646(ra) # 80002c48 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049ca:	00092703          	lw	a4,0(s2)
    800049ce:	409c                	lw	a5,0(s1)
    800049d0:	06f71163          	bne	a4,a5,80004a32 <sys_link+0x108>
    800049d4:	40d0                	lw	a2,4(s1)
    800049d6:	fd040593          	addi	a1,s0,-48
    800049da:	854a                	mv	a0,s2
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	97c080e7          	jalr	-1668(ra) # 80003358 <dirlink>
    800049e4:	04054763          	bltz	a0,80004a32 <sys_link+0x108>
  iunlockput(dp);
    800049e8:	854a                	mv	a0,s2
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	4c4080e7          	jalr	1220(ra) # 80002eae <iunlockput>
  iput(ip);
    800049f2:	8526                	mv	a0,s1
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	412080e7          	jalr	1042(ra) # 80002e06 <iput>
  end_op();
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	c98080e7          	jalr	-872(ra) # 80003694 <end_op>
  return 0;
    80004a04:	4781                	li	a5,0
    80004a06:	64f2                	ld	s1,280(sp)
    80004a08:	6952                	ld	s2,272(sp)
    80004a0a:	a0a5                	j	80004a72 <sys_link+0x148>
    end_op();
    80004a0c:	fffff097          	auipc	ra,0xfffff
    80004a10:	c88080e7          	jalr	-888(ra) # 80003694 <end_op>
    return -1;
    80004a14:	57fd                	li	a5,-1
    80004a16:	64f2                	ld	s1,280(sp)
    80004a18:	a8a9                	j	80004a72 <sys_link+0x148>
    iunlockput(ip);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	492080e7          	jalr	1170(ra) # 80002eae <iunlockput>
    end_op();
    80004a24:	fffff097          	auipc	ra,0xfffff
    80004a28:	c70080e7          	jalr	-912(ra) # 80003694 <end_op>
    return -1;
    80004a2c:	57fd                	li	a5,-1
    80004a2e:	64f2                	ld	s1,280(sp)
    80004a30:	a089                	j	80004a72 <sys_link+0x148>
    iunlockput(dp);
    80004a32:	854a                	mv	a0,s2
    80004a34:	ffffe097          	auipc	ra,0xffffe
    80004a38:	47a080e7          	jalr	1146(ra) # 80002eae <iunlockput>
  ilock(ip);
    80004a3c:	8526                	mv	a0,s1
    80004a3e:	ffffe097          	auipc	ra,0xffffe
    80004a42:	20a080e7          	jalr	522(ra) # 80002c48 <ilock>
  ip->nlink--;
    80004a46:	04a4d783          	lhu	a5,74(s1)
    80004a4a:	37fd                	addiw	a5,a5,-1
    80004a4c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a50:	8526                	mv	a0,s1
    80004a52:	ffffe097          	auipc	ra,0xffffe
    80004a56:	12a080e7          	jalr	298(ra) # 80002b7c <iupdate>
  iunlockput(ip);
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	452080e7          	jalr	1106(ra) # 80002eae <iunlockput>
  end_op();
    80004a64:	fffff097          	auipc	ra,0xfffff
    80004a68:	c30080e7          	jalr	-976(ra) # 80003694 <end_op>
  return -1;
    80004a6c:	57fd                	li	a5,-1
    80004a6e:	64f2                	ld	s1,280(sp)
    80004a70:	6952                	ld	s2,272(sp)
}
    80004a72:	853e                	mv	a0,a5
    80004a74:	70b2                	ld	ra,296(sp)
    80004a76:	7412                	ld	s0,288(sp)
    80004a78:	6155                	addi	sp,sp,304
    80004a7a:	8082                	ret

0000000080004a7c <sys_unlink>:
{
    80004a7c:	7151                	addi	sp,sp,-240
    80004a7e:	f586                	sd	ra,232(sp)
    80004a80:	f1a2                	sd	s0,224(sp)
    80004a82:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a84:	08000613          	li	a2,128
    80004a88:	f3040593          	addi	a1,s0,-208
    80004a8c:	4501                	li	a0,0
    80004a8e:	ffffd097          	auipc	ra,0xffffd
    80004a92:	620080e7          	jalr	1568(ra) # 800020ae <argstr>
    80004a96:	1a054a63          	bltz	a0,80004c4a <sys_unlink+0x1ce>
    80004a9a:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	b7e080e7          	jalr	-1154(ra) # 8000361a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004aa4:	fb040593          	addi	a1,s0,-80
    80004aa8:	f3040513          	addi	a0,s0,-208
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	98c080e7          	jalr	-1652(ra) # 80003438 <nameiparent>
    80004ab4:	84aa                	mv	s1,a0
    80004ab6:	cd71                	beqz	a0,80004b92 <sys_unlink+0x116>
  ilock(dp);
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	190080e7          	jalr	400(ra) # 80002c48 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ac0:	00004597          	auipc	a1,0x4
    80004ac4:	ac058593          	addi	a1,a1,-1344 # 80008580 <etext+0x580>
    80004ac8:	fb040513          	addi	a0,s0,-80
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	662080e7          	jalr	1634(ra) # 8000312e <namecmp>
    80004ad4:	14050c63          	beqz	a0,80004c2c <sys_unlink+0x1b0>
    80004ad8:	00004597          	auipc	a1,0x4
    80004adc:	ab058593          	addi	a1,a1,-1360 # 80008588 <etext+0x588>
    80004ae0:	fb040513          	addi	a0,s0,-80
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	64a080e7          	jalr	1610(ra) # 8000312e <namecmp>
    80004aec:	14050063          	beqz	a0,80004c2c <sys_unlink+0x1b0>
    80004af0:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004af2:	f2c40613          	addi	a2,s0,-212
    80004af6:	fb040593          	addi	a1,s0,-80
    80004afa:	8526                	mv	a0,s1
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	64c080e7          	jalr	1612(ra) # 80003148 <dirlookup>
    80004b04:	892a                	mv	s2,a0
    80004b06:	12050263          	beqz	a0,80004c2a <sys_unlink+0x1ae>
  ilock(ip);
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	13e080e7          	jalr	318(ra) # 80002c48 <ilock>
  if(ip->nlink < 1)
    80004b12:	04a91783          	lh	a5,74(s2)
    80004b16:	08f05563          	blez	a5,80004ba0 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b1a:	04491703          	lh	a4,68(s2)
    80004b1e:	4785                	li	a5,1
    80004b20:	08f70963          	beq	a4,a5,80004bb2 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004b24:	4641                	li	a2,16
    80004b26:	4581                	li	a1,0
    80004b28:	fc040513          	addi	a0,s0,-64
    80004b2c:	ffffb097          	auipc	ra,0xffffb
    80004b30:	64e080e7          	jalr	1614(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b34:	4741                	li	a4,16
    80004b36:	f2c42683          	lw	a3,-212(s0)
    80004b3a:	fc040613          	addi	a2,s0,-64
    80004b3e:	4581                	li	a1,0
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	4c2080e7          	jalr	1218(ra) # 80003004 <writei>
    80004b4a:	47c1                	li	a5,16
    80004b4c:	0af51b63          	bne	a0,a5,80004c02 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b50:	04491703          	lh	a4,68(s2)
    80004b54:	4785                	li	a5,1
    80004b56:	0af70f63          	beq	a4,a5,80004c14 <sys_unlink+0x198>
  iunlockput(dp);
    80004b5a:	8526                	mv	a0,s1
    80004b5c:	ffffe097          	auipc	ra,0xffffe
    80004b60:	352080e7          	jalr	850(ra) # 80002eae <iunlockput>
  ip->nlink--;
    80004b64:	04a95783          	lhu	a5,74(s2)
    80004b68:	37fd                	addiw	a5,a5,-1
    80004b6a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b6e:	854a                	mv	a0,s2
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	00c080e7          	jalr	12(ra) # 80002b7c <iupdate>
  iunlockput(ip);
    80004b78:	854a                	mv	a0,s2
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	334080e7          	jalr	820(ra) # 80002eae <iunlockput>
  end_op();
    80004b82:	fffff097          	auipc	ra,0xfffff
    80004b86:	b12080e7          	jalr	-1262(ra) # 80003694 <end_op>
  return 0;
    80004b8a:	4501                	li	a0,0
    80004b8c:	64ee                	ld	s1,216(sp)
    80004b8e:	694e                	ld	s2,208(sp)
    80004b90:	a84d                	j	80004c42 <sys_unlink+0x1c6>
    end_op();
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	b02080e7          	jalr	-1278(ra) # 80003694 <end_op>
    return -1;
    80004b9a:	557d                	li	a0,-1
    80004b9c:	64ee                	ld	s1,216(sp)
    80004b9e:	a055                	j	80004c42 <sys_unlink+0x1c6>
    80004ba0:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004ba2:	00004517          	auipc	a0,0x4
    80004ba6:	a0e50513          	addi	a0,a0,-1522 # 800085b0 <etext+0x5b0>
    80004baa:	00001097          	auipc	ra,0x1
    80004bae:	212080e7          	jalr	530(ra) # 80005dbc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bb2:	04c92703          	lw	a4,76(s2)
    80004bb6:	02000793          	li	a5,32
    80004bba:	f6e7f5e3          	bgeu	a5,a4,80004b24 <sys_unlink+0xa8>
    80004bbe:	e5ce                	sd	s3,200(sp)
    80004bc0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bc4:	4741                	li	a4,16
    80004bc6:	86ce                	mv	a3,s3
    80004bc8:	f1840613          	addi	a2,s0,-232
    80004bcc:	4581                	li	a1,0
    80004bce:	854a                	mv	a0,s2
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	330080e7          	jalr	816(ra) # 80002f00 <readi>
    80004bd8:	47c1                	li	a5,16
    80004bda:	00f51c63          	bne	a0,a5,80004bf2 <sys_unlink+0x176>
    if(de.inum != 0)
    80004bde:	f1845783          	lhu	a5,-232(s0)
    80004be2:	e7b5                	bnez	a5,80004c4e <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004be4:	29c1                	addiw	s3,s3,16
    80004be6:	04c92783          	lw	a5,76(s2)
    80004bea:	fcf9ede3          	bltu	s3,a5,80004bc4 <sys_unlink+0x148>
    80004bee:	69ae                	ld	s3,200(sp)
    80004bf0:	bf15                	j	80004b24 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004bf2:	00004517          	auipc	a0,0x4
    80004bf6:	9d650513          	addi	a0,a0,-1578 # 800085c8 <etext+0x5c8>
    80004bfa:	00001097          	auipc	ra,0x1
    80004bfe:	1c2080e7          	jalr	450(ra) # 80005dbc <panic>
    80004c02:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004c04:	00004517          	auipc	a0,0x4
    80004c08:	9dc50513          	addi	a0,a0,-1572 # 800085e0 <etext+0x5e0>
    80004c0c:	00001097          	auipc	ra,0x1
    80004c10:	1b0080e7          	jalr	432(ra) # 80005dbc <panic>
    dp->nlink--;
    80004c14:	04a4d783          	lhu	a5,74(s1)
    80004c18:	37fd                	addiw	a5,a5,-1
    80004c1a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	f5c080e7          	jalr	-164(ra) # 80002b7c <iupdate>
    80004c28:	bf0d                	j	80004b5a <sys_unlink+0xde>
    80004c2a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004c2c:	8526                	mv	a0,s1
    80004c2e:	ffffe097          	auipc	ra,0xffffe
    80004c32:	280080e7          	jalr	640(ra) # 80002eae <iunlockput>
  end_op();
    80004c36:	fffff097          	auipc	ra,0xfffff
    80004c3a:	a5e080e7          	jalr	-1442(ra) # 80003694 <end_op>
  return -1;
    80004c3e:	557d                	li	a0,-1
    80004c40:	64ee                	ld	s1,216(sp)
}
    80004c42:	70ae                	ld	ra,232(sp)
    80004c44:	740e                	ld	s0,224(sp)
    80004c46:	616d                	addi	sp,sp,240
    80004c48:	8082                	ret
    return -1;
    80004c4a:	557d                	li	a0,-1
    80004c4c:	bfdd                	j	80004c42 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c4e:	854a                	mv	a0,s2
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	25e080e7          	jalr	606(ra) # 80002eae <iunlockput>
    goto bad;
    80004c58:	694e                	ld	s2,208(sp)
    80004c5a:	69ae                	ld	s3,200(sp)
    80004c5c:	bfc1                	j	80004c2c <sys_unlink+0x1b0>

0000000080004c5e <sys_open>:

uint64
sys_open(void)
{
    80004c5e:	7131                	addi	sp,sp,-192
    80004c60:	fd06                	sd	ra,184(sp)
    80004c62:	f922                	sd	s0,176(sp)
    80004c64:	f526                	sd	s1,168(sp)
    80004c66:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c68:	08000613          	li	a2,128
    80004c6c:	f5040593          	addi	a1,s0,-176
    80004c70:	4501                	li	a0,0
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	43c080e7          	jalr	1084(ra) # 800020ae <argstr>
    return -1;
    80004c7a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c7c:	0c054463          	bltz	a0,80004d44 <sys_open+0xe6>
    80004c80:	f4c40593          	addi	a1,s0,-180
    80004c84:	4505                	li	a0,1
    80004c86:	ffffd097          	auipc	ra,0xffffd
    80004c8a:	3e4080e7          	jalr	996(ra) # 8000206a <argint>
    80004c8e:	0a054b63          	bltz	a0,80004d44 <sys_open+0xe6>
    80004c92:	f14a                	sd	s2,160(sp)

  begin_op();
    80004c94:	fffff097          	auipc	ra,0xfffff
    80004c98:	986080e7          	jalr	-1658(ra) # 8000361a <begin_op>

  if(omode & O_CREATE){
    80004c9c:	f4c42783          	lw	a5,-180(s0)
    80004ca0:	2007f793          	andi	a5,a5,512
    80004ca4:	cfc5                	beqz	a5,80004d5c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ca6:	4681                	li	a3,0
    80004ca8:	4601                	li	a2,0
    80004caa:	4589                	li	a1,2
    80004cac:	f5040513          	addi	a0,s0,-176
    80004cb0:	00000097          	auipc	ra,0x0
    80004cb4:	958080e7          	jalr	-1704(ra) # 80004608 <create>
    80004cb8:	892a                	mv	s2,a0
    if(ip == 0){
    80004cba:	c959                	beqz	a0,80004d50 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cbc:	04491703          	lh	a4,68(s2)
    80004cc0:	478d                	li	a5,3
    80004cc2:	00f71763          	bne	a4,a5,80004cd0 <sys_open+0x72>
    80004cc6:	04695703          	lhu	a4,70(s2)
    80004cca:	47a5                	li	a5,9
    80004ccc:	0ce7ef63          	bltu	a5,a4,80004daa <sys_open+0x14c>
    80004cd0:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cd2:	fffff097          	auipc	ra,0xfffff
    80004cd6:	d56080e7          	jalr	-682(ra) # 80003a28 <filealloc>
    80004cda:	89aa                	mv	s3,a0
    80004cdc:	c965                	beqz	a0,80004dcc <sys_open+0x16e>
    80004cde:	00000097          	auipc	ra,0x0
    80004ce2:	8e8080e7          	jalr	-1816(ra) # 800045c6 <fdalloc>
    80004ce6:	84aa                	mv	s1,a0
    80004ce8:	0c054d63          	bltz	a0,80004dc2 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cec:	04491703          	lh	a4,68(s2)
    80004cf0:	478d                	li	a5,3
    80004cf2:	0ef70a63          	beq	a4,a5,80004de6 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cf6:	4789                	li	a5,2
    80004cf8:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cfc:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d00:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d04:	f4c42783          	lw	a5,-180(s0)
    80004d08:	0017c713          	xori	a4,a5,1
    80004d0c:	8b05                	andi	a4,a4,1
    80004d0e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d12:	0037f713          	andi	a4,a5,3
    80004d16:	00e03733          	snez	a4,a4
    80004d1a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d1e:	4007f793          	andi	a5,a5,1024
    80004d22:	c791                	beqz	a5,80004d2e <sys_open+0xd0>
    80004d24:	04491703          	lh	a4,68(s2)
    80004d28:	4789                	li	a5,2
    80004d2a:	0cf70563          	beq	a4,a5,80004df4 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004d2e:	854a                	mv	a0,s2
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	fde080e7          	jalr	-34(ra) # 80002d0e <iunlock>
  end_op();
    80004d38:	fffff097          	auipc	ra,0xfffff
    80004d3c:	95c080e7          	jalr	-1700(ra) # 80003694 <end_op>
    80004d40:	790a                	ld	s2,160(sp)
    80004d42:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004d44:	8526                	mv	a0,s1
    80004d46:	70ea                	ld	ra,184(sp)
    80004d48:	744a                	ld	s0,176(sp)
    80004d4a:	74aa                	ld	s1,168(sp)
    80004d4c:	6129                	addi	sp,sp,192
    80004d4e:	8082                	ret
      end_op();
    80004d50:	fffff097          	auipc	ra,0xfffff
    80004d54:	944080e7          	jalr	-1724(ra) # 80003694 <end_op>
      return -1;
    80004d58:	790a                	ld	s2,160(sp)
    80004d5a:	b7ed                	j	80004d44 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004d5c:	f5040513          	addi	a0,s0,-176
    80004d60:	ffffe097          	auipc	ra,0xffffe
    80004d64:	6ba080e7          	jalr	1722(ra) # 8000341a <namei>
    80004d68:	892a                	mv	s2,a0
    80004d6a:	c90d                	beqz	a0,80004d9c <sys_open+0x13e>
    ilock(ip);
    80004d6c:	ffffe097          	auipc	ra,0xffffe
    80004d70:	edc080e7          	jalr	-292(ra) # 80002c48 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d74:	04491703          	lh	a4,68(s2)
    80004d78:	4785                	li	a5,1
    80004d7a:	f4f711e3          	bne	a4,a5,80004cbc <sys_open+0x5e>
    80004d7e:	f4c42783          	lw	a5,-180(s0)
    80004d82:	d7b9                	beqz	a5,80004cd0 <sys_open+0x72>
      iunlockput(ip);
    80004d84:	854a                	mv	a0,s2
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	128080e7          	jalr	296(ra) # 80002eae <iunlockput>
      end_op();
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	906080e7          	jalr	-1786(ra) # 80003694 <end_op>
      return -1;
    80004d96:	54fd                	li	s1,-1
    80004d98:	790a                	ld	s2,160(sp)
    80004d9a:	b76d                	j	80004d44 <sys_open+0xe6>
      end_op();
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	8f8080e7          	jalr	-1800(ra) # 80003694 <end_op>
      return -1;
    80004da4:	54fd                	li	s1,-1
    80004da6:	790a                	ld	s2,160(sp)
    80004da8:	bf71                	j	80004d44 <sys_open+0xe6>
    iunlockput(ip);
    80004daa:	854a                	mv	a0,s2
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	102080e7          	jalr	258(ra) # 80002eae <iunlockput>
    end_op();
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	8e0080e7          	jalr	-1824(ra) # 80003694 <end_op>
    return -1;
    80004dbc:	54fd                	li	s1,-1
    80004dbe:	790a                	ld	s2,160(sp)
    80004dc0:	b751                	j	80004d44 <sys_open+0xe6>
      fileclose(f);
    80004dc2:	854e                	mv	a0,s3
    80004dc4:	fffff097          	auipc	ra,0xfffff
    80004dc8:	d20080e7          	jalr	-736(ra) # 80003ae4 <fileclose>
    iunlockput(ip);
    80004dcc:	854a                	mv	a0,s2
    80004dce:	ffffe097          	auipc	ra,0xffffe
    80004dd2:	0e0080e7          	jalr	224(ra) # 80002eae <iunlockput>
    end_op();
    80004dd6:	fffff097          	auipc	ra,0xfffff
    80004dda:	8be080e7          	jalr	-1858(ra) # 80003694 <end_op>
    return -1;
    80004dde:	54fd                	li	s1,-1
    80004de0:	790a                	ld	s2,160(sp)
    80004de2:	69ea                	ld	s3,152(sp)
    80004de4:	b785                	j	80004d44 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004de6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dea:	04691783          	lh	a5,70(s2)
    80004dee:	02f99223          	sh	a5,36(s3)
    80004df2:	b739                	j	80004d00 <sys_open+0xa2>
    itrunc(ip);
    80004df4:	854a                	mv	a0,s2
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	f64080e7          	jalr	-156(ra) # 80002d5a <itrunc>
    80004dfe:	bf05                	j	80004d2e <sys_open+0xd0>

0000000080004e00 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e00:	7175                	addi	sp,sp,-144
    80004e02:	e506                	sd	ra,136(sp)
    80004e04:	e122                	sd	s0,128(sp)
    80004e06:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	812080e7          	jalr	-2030(ra) # 8000361a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e10:	08000613          	li	a2,128
    80004e14:	f7040593          	addi	a1,s0,-144
    80004e18:	4501                	li	a0,0
    80004e1a:	ffffd097          	auipc	ra,0xffffd
    80004e1e:	294080e7          	jalr	660(ra) # 800020ae <argstr>
    80004e22:	02054963          	bltz	a0,80004e54 <sys_mkdir+0x54>
    80004e26:	4681                	li	a3,0
    80004e28:	4601                	li	a2,0
    80004e2a:	4585                	li	a1,1
    80004e2c:	f7040513          	addi	a0,s0,-144
    80004e30:	fffff097          	auipc	ra,0xfffff
    80004e34:	7d8080e7          	jalr	2008(ra) # 80004608 <create>
    80004e38:	cd11                	beqz	a0,80004e54 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	074080e7          	jalr	116(ra) # 80002eae <iunlockput>
  end_op();
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	852080e7          	jalr	-1966(ra) # 80003694 <end_op>
  return 0;
    80004e4a:	4501                	li	a0,0
}
    80004e4c:	60aa                	ld	ra,136(sp)
    80004e4e:	640a                	ld	s0,128(sp)
    80004e50:	6149                	addi	sp,sp,144
    80004e52:	8082                	ret
    end_op();
    80004e54:	fffff097          	auipc	ra,0xfffff
    80004e58:	840080e7          	jalr	-1984(ra) # 80003694 <end_op>
    return -1;
    80004e5c:	557d                	li	a0,-1
    80004e5e:	b7fd                	j	80004e4c <sys_mkdir+0x4c>

0000000080004e60 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e60:	7135                	addi	sp,sp,-160
    80004e62:	ed06                	sd	ra,152(sp)
    80004e64:	e922                	sd	s0,144(sp)
    80004e66:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e68:	ffffe097          	auipc	ra,0xffffe
    80004e6c:	7b2080e7          	jalr	1970(ra) # 8000361a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e70:	08000613          	li	a2,128
    80004e74:	f7040593          	addi	a1,s0,-144
    80004e78:	4501                	li	a0,0
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	234080e7          	jalr	564(ra) # 800020ae <argstr>
    80004e82:	04054a63          	bltz	a0,80004ed6 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e86:	f6c40593          	addi	a1,s0,-148
    80004e8a:	4505                	li	a0,1
    80004e8c:	ffffd097          	auipc	ra,0xffffd
    80004e90:	1de080e7          	jalr	478(ra) # 8000206a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e94:	04054163          	bltz	a0,80004ed6 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e98:	f6840593          	addi	a1,s0,-152
    80004e9c:	4509                	li	a0,2
    80004e9e:	ffffd097          	auipc	ra,0xffffd
    80004ea2:	1cc080e7          	jalr	460(ra) # 8000206a <argint>
     argint(1, &major) < 0 ||
    80004ea6:	02054863          	bltz	a0,80004ed6 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004eaa:	f6841683          	lh	a3,-152(s0)
    80004eae:	f6c41603          	lh	a2,-148(s0)
    80004eb2:	458d                	li	a1,3
    80004eb4:	f7040513          	addi	a0,s0,-144
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	750080e7          	jalr	1872(ra) # 80004608 <create>
     argint(2, &minor) < 0 ||
    80004ec0:	c919                	beqz	a0,80004ed6 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	fec080e7          	jalr	-20(ra) # 80002eae <iunlockput>
  end_op();
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	7ca080e7          	jalr	1994(ra) # 80003694 <end_op>
  return 0;
    80004ed2:	4501                	li	a0,0
    80004ed4:	a031                	j	80004ee0 <sys_mknod+0x80>
    end_op();
    80004ed6:	ffffe097          	auipc	ra,0xffffe
    80004eda:	7be080e7          	jalr	1982(ra) # 80003694 <end_op>
    return -1;
    80004ede:	557d                	li	a0,-1
}
    80004ee0:	60ea                	ld	ra,152(sp)
    80004ee2:	644a                	ld	s0,144(sp)
    80004ee4:	610d                	addi	sp,sp,160
    80004ee6:	8082                	ret

0000000080004ee8 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ee8:	7135                	addi	sp,sp,-160
    80004eea:	ed06                	sd	ra,152(sp)
    80004eec:	e922                	sd	s0,144(sp)
    80004eee:	e14a                	sd	s2,128(sp)
    80004ef0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ef2:	ffffc097          	auipc	ra,0xffffc
    80004ef6:	f8a080e7          	jalr	-118(ra) # 80000e7c <myproc>
    80004efa:	892a                	mv	s2,a0
  
  begin_op();
    80004efc:	ffffe097          	auipc	ra,0xffffe
    80004f00:	71e080e7          	jalr	1822(ra) # 8000361a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f04:	08000613          	li	a2,128
    80004f08:	f6040593          	addi	a1,s0,-160
    80004f0c:	4501                	li	a0,0
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	1a0080e7          	jalr	416(ra) # 800020ae <argstr>
    80004f16:	04054d63          	bltz	a0,80004f70 <sys_chdir+0x88>
    80004f1a:	e526                	sd	s1,136(sp)
    80004f1c:	f6040513          	addi	a0,s0,-160
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	4fa080e7          	jalr	1274(ra) # 8000341a <namei>
    80004f28:	84aa                	mv	s1,a0
    80004f2a:	c131                	beqz	a0,80004f6e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f2c:	ffffe097          	auipc	ra,0xffffe
    80004f30:	d1c080e7          	jalr	-740(ra) # 80002c48 <ilock>
  if(ip->type != T_DIR){
    80004f34:	04449703          	lh	a4,68(s1)
    80004f38:	4785                	li	a5,1
    80004f3a:	04f71163          	bne	a4,a5,80004f7c <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f3e:	8526                	mv	a0,s1
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	dce080e7          	jalr	-562(ra) # 80002d0e <iunlock>
  iput(p->cwd);
    80004f48:	15093503          	ld	a0,336(s2)
    80004f4c:	ffffe097          	auipc	ra,0xffffe
    80004f50:	eba080e7          	jalr	-326(ra) # 80002e06 <iput>
  end_op();
    80004f54:	ffffe097          	auipc	ra,0xffffe
    80004f58:	740080e7          	jalr	1856(ra) # 80003694 <end_op>
  p->cwd = ip;
    80004f5c:	14993823          	sd	s1,336(s2)
  return 0;
    80004f60:	4501                	li	a0,0
    80004f62:	64aa                	ld	s1,136(sp)
}
    80004f64:	60ea                	ld	ra,152(sp)
    80004f66:	644a                	ld	s0,144(sp)
    80004f68:	690a                	ld	s2,128(sp)
    80004f6a:	610d                	addi	sp,sp,160
    80004f6c:	8082                	ret
    80004f6e:	64aa                	ld	s1,136(sp)
    end_op();
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	724080e7          	jalr	1828(ra) # 80003694 <end_op>
    return -1;
    80004f78:	557d                	li	a0,-1
    80004f7a:	b7ed                	j	80004f64 <sys_chdir+0x7c>
    iunlockput(ip);
    80004f7c:	8526                	mv	a0,s1
    80004f7e:	ffffe097          	auipc	ra,0xffffe
    80004f82:	f30080e7          	jalr	-208(ra) # 80002eae <iunlockput>
    end_op();
    80004f86:	ffffe097          	auipc	ra,0xffffe
    80004f8a:	70e080e7          	jalr	1806(ra) # 80003694 <end_op>
    return -1;
    80004f8e:	557d                	li	a0,-1
    80004f90:	64aa                	ld	s1,136(sp)
    80004f92:	bfc9                	j	80004f64 <sys_chdir+0x7c>

0000000080004f94 <sys_exec>:

uint64
sys_exec(void)
{
    80004f94:	7121                	addi	sp,sp,-448
    80004f96:	ff06                	sd	ra,440(sp)
    80004f98:	fb22                	sd	s0,432(sp)
    80004f9a:	f34a                	sd	s2,416(sp)
    80004f9c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f9e:	08000613          	li	a2,128
    80004fa2:	f5040593          	addi	a1,s0,-176
    80004fa6:	4501                	li	a0,0
    80004fa8:	ffffd097          	auipc	ra,0xffffd
    80004fac:	106080e7          	jalr	262(ra) # 800020ae <argstr>
    return -1;
    80004fb0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fb2:	0e054a63          	bltz	a0,800050a6 <sys_exec+0x112>
    80004fb6:	e4840593          	addi	a1,s0,-440
    80004fba:	4505                	li	a0,1
    80004fbc:	ffffd097          	auipc	ra,0xffffd
    80004fc0:	0d0080e7          	jalr	208(ra) # 8000208c <argaddr>
    80004fc4:	0e054163          	bltz	a0,800050a6 <sys_exec+0x112>
    80004fc8:	f726                	sd	s1,424(sp)
    80004fca:	ef4e                	sd	s3,408(sp)
    80004fcc:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004fce:	10000613          	li	a2,256
    80004fd2:	4581                	li	a1,0
    80004fd4:	e5040513          	addi	a0,s0,-432
    80004fd8:	ffffb097          	auipc	ra,0xffffb
    80004fdc:	1a2080e7          	jalr	418(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fe0:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004fe4:	89a6                	mv	s3,s1
    80004fe6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fe8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fec:	00391513          	slli	a0,s2,0x3
    80004ff0:	e4040593          	addi	a1,s0,-448
    80004ff4:	e4843783          	ld	a5,-440(s0)
    80004ff8:	953e                	add	a0,a0,a5
    80004ffa:	ffffd097          	auipc	ra,0xffffd
    80004ffe:	fd6080e7          	jalr	-42(ra) # 80001fd0 <fetchaddr>
    80005002:	02054a63          	bltz	a0,80005036 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005006:	e4043783          	ld	a5,-448(s0)
    8000500a:	c7b1                	beqz	a5,80005056 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000500c:	ffffb097          	auipc	ra,0xffffb
    80005010:	10e080e7          	jalr	270(ra) # 8000011a <kalloc>
    80005014:	85aa                	mv	a1,a0
    80005016:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000501a:	cd11                	beqz	a0,80005036 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000501c:	6605                	lui	a2,0x1
    8000501e:	e4043503          	ld	a0,-448(s0)
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	000080e7          	jalr	ra # 80002022 <fetchstr>
    8000502a:	00054663          	bltz	a0,80005036 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    8000502e:	0905                	addi	s2,s2,1
    80005030:	09a1                	addi	s3,s3,8
    80005032:	fb491de3          	bne	s2,s4,80004fec <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005036:	f5040913          	addi	s2,s0,-176
    8000503a:	6088                	ld	a0,0(s1)
    8000503c:	c12d                	beqz	a0,8000509e <sys_exec+0x10a>
    kfree(argv[i]);
    8000503e:	ffffb097          	auipc	ra,0xffffb
    80005042:	fde080e7          	jalr	-34(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005046:	04a1                	addi	s1,s1,8
    80005048:	ff2499e3          	bne	s1,s2,8000503a <sys_exec+0xa6>
  return -1;
    8000504c:	597d                	li	s2,-1
    8000504e:	74ba                	ld	s1,424(sp)
    80005050:	69fa                	ld	s3,408(sp)
    80005052:	6a5a                	ld	s4,400(sp)
    80005054:	a889                	j	800050a6 <sys_exec+0x112>
      argv[i] = 0;
    80005056:	0009079b          	sext.w	a5,s2
    8000505a:	078e                	slli	a5,a5,0x3
    8000505c:	fd078793          	addi	a5,a5,-48
    80005060:	97a2                	add	a5,a5,s0
    80005062:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005066:	e5040593          	addi	a1,s0,-432
    8000506a:	f5040513          	addi	a0,s0,-176
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	126080e7          	jalr	294(ra) # 80004194 <exec>
    80005076:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005078:	f5040993          	addi	s3,s0,-176
    8000507c:	6088                	ld	a0,0(s1)
    8000507e:	cd01                	beqz	a0,80005096 <sys_exec+0x102>
    kfree(argv[i]);
    80005080:	ffffb097          	auipc	ra,0xffffb
    80005084:	f9c080e7          	jalr	-100(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005088:	04a1                	addi	s1,s1,8
    8000508a:	ff3499e3          	bne	s1,s3,8000507c <sys_exec+0xe8>
    8000508e:	74ba                	ld	s1,424(sp)
    80005090:	69fa                	ld	s3,408(sp)
    80005092:	6a5a                	ld	s4,400(sp)
    80005094:	a809                	j	800050a6 <sys_exec+0x112>
  return ret;
    80005096:	74ba                	ld	s1,424(sp)
    80005098:	69fa                	ld	s3,408(sp)
    8000509a:	6a5a                	ld	s4,400(sp)
    8000509c:	a029                	j	800050a6 <sys_exec+0x112>
  return -1;
    8000509e:	597d                	li	s2,-1
    800050a0:	74ba                	ld	s1,424(sp)
    800050a2:	69fa                	ld	s3,408(sp)
    800050a4:	6a5a                	ld	s4,400(sp)
}
    800050a6:	854a                	mv	a0,s2
    800050a8:	70fa                	ld	ra,440(sp)
    800050aa:	745a                	ld	s0,432(sp)
    800050ac:	791a                	ld	s2,416(sp)
    800050ae:	6139                	addi	sp,sp,448
    800050b0:	8082                	ret

00000000800050b2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050b2:	7139                	addi	sp,sp,-64
    800050b4:	fc06                	sd	ra,56(sp)
    800050b6:	f822                	sd	s0,48(sp)
    800050b8:	f426                	sd	s1,40(sp)
    800050ba:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050bc:	ffffc097          	auipc	ra,0xffffc
    800050c0:	dc0080e7          	jalr	-576(ra) # 80000e7c <myproc>
    800050c4:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050c6:	fd840593          	addi	a1,s0,-40
    800050ca:	4501                	li	a0,0
    800050cc:	ffffd097          	auipc	ra,0xffffd
    800050d0:	fc0080e7          	jalr	-64(ra) # 8000208c <argaddr>
    return -1;
    800050d4:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050d6:	0e054063          	bltz	a0,800051b6 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050da:	fc840593          	addi	a1,s0,-56
    800050de:	fd040513          	addi	a0,s0,-48
    800050e2:	fffff097          	auipc	ra,0xfffff
    800050e6:	d70080e7          	jalr	-656(ra) # 80003e52 <pipealloc>
    return -1;
    800050ea:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050ec:	0c054563          	bltz	a0,800051b6 <sys_pipe+0x104>
  fd0 = -1;
    800050f0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050f4:	fd043503          	ld	a0,-48(s0)
    800050f8:	fffff097          	auipc	ra,0xfffff
    800050fc:	4ce080e7          	jalr	1230(ra) # 800045c6 <fdalloc>
    80005100:	fca42223          	sw	a0,-60(s0)
    80005104:	08054c63          	bltz	a0,8000519c <sys_pipe+0xea>
    80005108:	fc843503          	ld	a0,-56(s0)
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	4ba080e7          	jalr	1210(ra) # 800045c6 <fdalloc>
    80005114:	fca42023          	sw	a0,-64(s0)
    80005118:	06054963          	bltz	a0,8000518a <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000511c:	4691                	li	a3,4
    8000511e:	fc440613          	addi	a2,s0,-60
    80005122:	fd843583          	ld	a1,-40(s0)
    80005126:	68a8                	ld	a0,80(s1)
    80005128:	ffffc097          	auipc	ra,0xffffc
    8000512c:	9f0080e7          	jalr	-1552(ra) # 80000b18 <copyout>
    80005130:	02054063          	bltz	a0,80005150 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005134:	4691                	li	a3,4
    80005136:	fc040613          	addi	a2,s0,-64
    8000513a:	fd843583          	ld	a1,-40(s0)
    8000513e:	0591                	addi	a1,a1,4
    80005140:	68a8                	ld	a0,80(s1)
    80005142:	ffffc097          	auipc	ra,0xffffc
    80005146:	9d6080e7          	jalr	-1578(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000514a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000514c:	06055563          	bgez	a0,800051b6 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005150:	fc442783          	lw	a5,-60(s0)
    80005154:	07e9                	addi	a5,a5,26
    80005156:	078e                	slli	a5,a5,0x3
    80005158:	97a6                	add	a5,a5,s1
    8000515a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000515e:	fc042783          	lw	a5,-64(s0)
    80005162:	07e9                	addi	a5,a5,26
    80005164:	078e                	slli	a5,a5,0x3
    80005166:	00f48533          	add	a0,s1,a5
    8000516a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000516e:	fd043503          	ld	a0,-48(s0)
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	972080e7          	jalr	-1678(ra) # 80003ae4 <fileclose>
    fileclose(wf);
    8000517a:	fc843503          	ld	a0,-56(s0)
    8000517e:	fffff097          	auipc	ra,0xfffff
    80005182:	966080e7          	jalr	-1690(ra) # 80003ae4 <fileclose>
    return -1;
    80005186:	57fd                	li	a5,-1
    80005188:	a03d                	j	800051b6 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000518a:	fc442783          	lw	a5,-60(s0)
    8000518e:	0007c763          	bltz	a5,8000519c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005192:	07e9                	addi	a5,a5,26
    80005194:	078e                	slli	a5,a5,0x3
    80005196:	97a6                	add	a5,a5,s1
    80005198:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000519c:	fd043503          	ld	a0,-48(s0)
    800051a0:	fffff097          	auipc	ra,0xfffff
    800051a4:	944080e7          	jalr	-1724(ra) # 80003ae4 <fileclose>
    fileclose(wf);
    800051a8:	fc843503          	ld	a0,-56(s0)
    800051ac:	fffff097          	auipc	ra,0xfffff
    800051b0:	938080e7          	jalr	-1736(ra) # 80003ae4 <fileclose>
    return -1;
    800051b4:	57fd                	li	a5,-1
}
    800051b6:	853e                	mv	a0,a5
    800051b8:	70e2                	ld	ra,56(sp)
    800051ba:	7442                	ld	s0,48(sp)
    800051bc:	74a2                	ld	s1,40(sp)
    800051be:	6121                	addi	sp,sp,64
    800051c0:	8082                	ret
	...

00000000800051d0 <kernelvec>:
    800051d0:	7111                	addi	sp,sp,-256
    800051d2:	e006                	sd	ra,0(sp)
    800051d4:	e40a                	sd	sp,8(sp)
    800051d6:	e80e                	sd	gp,16(sp)
    800051d8:	ec12                	sd	tp,24(sp)
    800051da:	f016                	sd	t0,32(sp)
    800051dc:	f41a                	sd	t1,40(sp)
    800051de:	f81e                	sd	t2,48(sp)
    800051e0:	fc22                	sd	s0,56(sp)
    800051e2:	e0a6                	sd	s1,64(sp)
    800051e4:	e4aa                	sd	a0,72(sp)
    800051e6:	e8ae                	sd	a1,80(sp)
    800051e8:	ecb2                	sd	a2,88(sp)
    800051ea:	f0b6                	sd	a3,96(sp)
    800051ec:	f4ba                	sd	a4,104(sp)
    800051ee:	f8be                	sd	a5,112(sp)
    800051f0:	fcc2                	sd	a6,120(sp)
    800051f2:	e146                	sd	a7,128(sp)
    800051f4:	e54a                	sd	s2,136(sp)
    800051f6:	e94e                	sd	s3,144(sp)
    800051f8:	ed52                	sd	s4,152(sp)
    800051fa:	f156                	sd	s5,160(sp)
    800051fc:	f55a                	sd	s6,168(sp)
    800051fe:	f95e                	sd	s7,176(sp)
    80005200:	fd62                	sd	s8,184(sp)
    80005202:	e1e6                	sd	s9,192(sp)
    80005204:	e5ea                	sd	s10,200(sp)
    80005206:	e9ee                	sd	s11,208(sp)
    80005208:	edf2                	sd	t3,216(sp)
    8000520a:	f1f6                	sd	t4,224(sp)
    8000520c:	f5fa                	sd	t5,232(sp)
    8000520e:	f9fe                	sd	t6,240(sp)
    80005210:	c8dfc0ef          	jal	80001e9c <kerneltrap>
    80005214:	6082                	ld	ra,0(sp)
    80005216:	6122                	ld	sp,8(sp)
    80005218:	61c2                	ld	gp,16(sp)
    8000521a:	7282                	ld	t0,32(sp)
    8000521c:	7322                	ld	t1,40(sp)
    8000521e:	73c2                	ld	t2,48(sp)
    80005220:	7462                	ld	s0,56(sp)
    80005222:	6486                	ld	s1,64(sp)
    80005224:	6526                	ld	a0,72(sp)
    80005226:	65c6                	ld	a1,80(sp)
    80005228:	6666                	ld	a2,88(sp)
    8000522a:	7686                	ld	a3,96(sp)
    8000522c:	7726                	ld	a4,104(sp)
    8000522e:	77c6                	ld	a5,112(sp)
    80005230:	7866                	ld	a6,120(sp)
    80005232:	688a                	ld	a7,128(sp)
    80005234:	692a                	ld	s2,136(sp)
    80005236:	69ca                	ld	s3,144(sp)
    80005238:	6a6a                	ld	s4,152(sp)
    8000523a:	7a8a                	ld	s5,160(sp)
    8000523c:	7b2a                	ld	s6,168(sp)
    8000523e:	7bca                	ld	s7,176(sp)
    80005240:	7c6a                	ld	s8,184(sp)
    80005242:	6c8e                	ld	s9,192(sp)
    80005244:	6d2e                	ld	s10,200(sp)
    80005246:	6dce                	ld	s11,208(sp)
    80005248:	6e6e                	ld	t3,216(sp)
    8000524a:	7e8e                	ld	t4,224(sp)
    8000524c:	7f2e                	ld	t5,232(sp)
    8000524e:	7fce                	ld	t6,240(sp)
    80005250:	6111                	addi	sp,sp,256
    80005252:	10200073          	sret
    80005256:	00000013          	nop
    8000525a:	00000013          	nop
    8000525e:	0001                	nop

0000000080005260 <timervec>:
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	e10c                	sd	a1,0(a0)
    80005266:	e510                	sd	a2,8(a0)
    80005268:	e914                	sd	a3,16(a0)
    8000526a:	6d0c                	ld	a1,24(a0)
    8000526c:	7110                	ld	a2,32(a0)
    8000526e:	6194                	ld	a3,0(a1)
    80005270:	96b2                	add	a3,a3,a2
    80005272:	e194                	sd	a3,0(a1)
    80005274:	4589                	li	a1,2
    80005276:	14459073          	csrw	sip,a1
    8000527a:	6914                	ld	a3,16(a0)
    8000527c:	6510                	ld	a2,8(a0)
    8000527e:	610c                	ld	a1,0(a0)
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	30200073          	mret
	...

000000008000528a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000528a:	1141                	addi	sp,sp,-16
    8000528c:	e422                	sd	s0,8(sp)
    8000528e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005290:	0c0007b7          	lui	a5,0xc000
    80005294:	4705                	li	a4,1
    80005296:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005298:	0c0007b7          	lui	a5,0xc000
    8000529c:	c3d8                	sw	a4,4(a5)
}
    8000529e:	6422                	ld	s0,8(sp)
    800052a0:	0141                	addi	sp,sp,16
    800052a2:	8082                	ret

00000000800052a4 <plicinithart>:

void
plicinithart(void)
{
    800052a4:	1141                	addi	sp,sp,-16
    800052a6:	e406                	sd	ra,8(sp)
    800052a8:	e022                	sd	s0,0(sp)
    800052aa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052ac:	ffffc097          	auipc	ra,0xffffc
    800052b0:	ba4080e7          	jalr	-1116(ra) # 80000e50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052b4:	0085171b          	slliw	a4,a0,0x8
    800052b8:	0c0027b7          	lui	a5,0xc002
    800052bc:	97ba                	add	a5,a5,a4
    800052be:	40200713          	li	a4,1026
    800052c2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052c6:	00d5151b          	slliw	a0,a0,0xd
    800052ca:	0c2017b7          	lui	a5,0xc201
    800052ce:	97aa                	add	a5,a5,a0
    800052d0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052d4:	60a2                	ld	ra,8(sp)
    800052d6:	6402                	ld	s0,0(sp)
    800052d8:	0141                	addi	sp,sp,16
    800052da:	8082                	ret

00000000800052dc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052dc:	1141                	addi	sp,sp,-16
    800052de:	e406                	sd	ra,8(sp)
    800052e0:	e022                	sd	s0,0(sp)
    800052e2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052e4:	ffffc097          	auipc	ra,0xffffc
    800052e8:	b6c080e7          	jalr	-1172(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052ec:	00d5151b          	slliw	a0,a0,0xd
    800052f0:	0c2017b7          	lui	a5,0xc201
    800052f4:	97aa                	add	a5,a5,a0
  return irq;
}
    800052f6:	43c8                	lw	a0,4(a5)
    800052f8:	60a2                	ld	ra,8(sp)
    800052fa:	6402                	ld	s0,0(sp)
    800052fc:	0141                	addi	sp,sp,16
    800052fe:	8082                	ret

0000000080005300 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005300:	1101                	addi	sp,sp,-32
    80005302:	ec06                	sd	ra,24(sp)
    80005304:	e822                	sd	s0,16(sp)
    80005306:	e426                	sd	s1,8(sp)
    80005308:	1000                	addi	s0,sp,32
    8000530a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000530c:	ffffc097          	auipc	ra,0xffffc
    80005310:	b44080e7          	jalr	-1212(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005314:	00d5151b          	slliw	a0,a0,0xd
    80005318:	0c2017b7          	lui	a5,0xc201
    8000531c:	97aa                	add	a5,a5,a0
    8000531e:	c3c4                	sw	s1,4(a5)
}
    80005320:	60e2                	ld	ra,24(sp)
    80005322:	6442                	ld	s0,16(sp)
    80005324:	64a2                	ld	s1,8(sp)
    80005326:	6105                	addi	sp,sp,32
    80005328:	8082                	ret

000000008000532a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000532a:	1141                	addi	sp,sp,-16
    8000532c:	e406                	sd	ra,8(sp)
    8000532e:	e022                	sd	s0,0(sp)
    80005330:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005332:	479d                	li	a5,7
    80005334:	06a7c863          	blt	a5,a0,800053a4 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005338:	00016717          	auipc	a4,0x16
    8000533c:	cc870713          	addi	a4,a4,-824 # 8001b000 <disk>
    80005340:	972a                	add	a4,a4,a0
    80005342:	6789                	lui	a5,0x2
    80005344:	97ba                	add	a5,a5,a4
    80005346:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000534a:	e7ad                	bnez	a5,800053b4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000534c:	00451793          	slli	a5,a0,0x4
    80005350:	00018717          	auipc	a4,0x18
    80005354:	cb070713          	addi	a4,a4,-848 # 8001d000 <disk+0x2000>
    80005358:	6314                	ld	a3,0(a4)
    8000535a:	96be                	add	a3,a3,a5
    8000535c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005360:	6314                	ld	a3,0(a4)
    80005362:	96be                	add	a3,a3,a5
    80005364:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005368:	6314                	ld	a3,0(a4)
    8000536a:	96be                	add	a3,a3,a5
    8000536c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005370:	6318                	ld	a4,0(a4)
    80005372:	97ba                	add	a5,a5,a4
    80005374:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005378:	00016717          	auipc	a4,0x16
    8000537c:	c8870713          	addi	a4,a4,-888 # 8001b000 <disk>
    80005380:	972a                	add	a4,a4,a0
    80005382:	6789                	lui	a5,0x2
    80005384:	97ba                	add	a5,a5,a4
    80005386:	4705                	li	a4,1
    80005388:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000538c:	00018517          	auipc	a0,0x18
    80005390:	c8c50513          	addi	a0,a0,-884 # 8001d018 <disk+0x2018>
    80005394:	ffffc097          	auipc	ra,0xffffc
    80005398:	38a080e7          	jalr	906(ra) # 8000171e <wakeup>
}
    8000539c:	60a2                	ld	ra,8(sp)
    8000539e:	6402                	ld	s0,0(sp)
    800053a0:	0141                	addi	sp,sp,16
    800053a2:	8082                	ret
    panic("free_desc 1");
    800053a4:	00003517          	auipc	a0,0x3
    800053a8:	24c50513          	addi	a0,a0,588 # 800085f0 <etext+0x5f0>
    800053ac:	00001097          	auipc	ra,0x1
    800053b0:	a10080e7          	jalr	-1520(ra) # 80005dbc <panic>
    panic("free_desc 2");
    800053b4:	00003517          	auipc	a0,0x3
    800053b8:	24c50513          	addi	a0,a0,588 # 80008600 <etext+0x600>
    800053bc:	00001097          	auipc	ra,0x1
    800053c0:	a00080e7          	jalr	-1536(ra) # 80005dbc <panic>

00000000800053c4 <virtio_disk_init>:
{
    800053c4:	1141                	addi	sp,sp,-16
    800053c6:	e406                	sd	ra,8(sp)
    800053c8:	e022                	sd	s0,0(sp)
    800053ca:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053cc:	00003597          	auipc	a1,0x3
    800053d0:	24458593          	addi	a1,a1,580 # 80008610 <etext+0x610>
    800053d4:	00018517          	auipc	a0,0x18
    800053d8:	d5450513          	addi	a0,a0,-684 # 8001d128 <disk+0x2128>
    800053dc:	00001097          	auipc	ra,0x1
    800053e0:	f26080e7          	jalr	-218(ra) # 80006302 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e4:	100017b7          	lui	a5,0x10001
    800053e8:	4398                	lw	a4,0(a5)
    800053ea:	2701                	sext.w	a4,a4
    800053ec:	747277b7          	lui	a5,0x74727
    800053f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053f4:	0ef71f63          	bne	a4,a5,800054f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800053fe:	439c                	lw	a5,0(a5)
    80005400:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005402:	4705                	li	a4,1
    80005404:	0ee79763          	bne	a5,a4,800054f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005408:	100017b7          	lui	a5,0x10001
    8000540c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000540e:	439c                	lw	a5,0(a5)
    80005410:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005412:	4709                	li	a4,2
    80005414:	0ce79f63          	bne	a5,a4,800054f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005418:	100017b7          	lui	a5,0x10001
    8000541c:	47d8                	lw	a4,12(a5)
    8000541e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005420:	554d47b7          	lui	a5,0x554d4
    80005424:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005428:	0cf71563          	bne	a4,a5,800054f2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000542c:	100017b7          	lui	a5,0x10001
    80005430:	4705                	li	a4,1
    80005432:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005434:	470d                	li	a4,3
    80005436:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005438:	10001737          	lui	a4,0x10001
    8000543c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000543e:	c7ffe737          	lui	a4,0xc7ffe
    80005442:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005446:	8ef9                	and	a3,a3,a4
    80005448:	10001737          	lui	a4,0x10001
    8000544c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000544e:	472d                	li	a4,11
    80005450:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005452:	473d                	li	a4,15
    80005454:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005456:	100017b7          	lui	a5,0x10001
    8000545a:	6705                	lui	a4,0x1
    8000545c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000545e:	100017b7          	lui	a5,0x10001
    80005462:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005466:	100017b7          	lui	a5,0x10001
    8000546a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000546e:	439c                	lw	a5,0(a5)
    80005470:	2781                	sext.w	a5,a5
  if(max == 0)
    80005472:	cbc1                	beqz	a5,80005502 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005474:	471d                	li	a4,7
    80005476:	08f77e63          	bgeu	a4,a5,80005512 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000547a:	100017b7          	lui	a5,0x10001
    8000547e:	4721                	li	a4,8
    80005480:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005482:	6609                	lui	a2,0x2
    80005484:	4581                	li	a1,0
    80005486:	00016517          	auipc	a0,0x16
    8000548a:	b7a50513          	addi	a0,a0,-1158 # 8001b000 <disk>
    8000548e:	ffffb097          	auipc	ra,0xffffb
    80005492:	cec080e7          	jalr	-788(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005496:	00016697          	auipc	a3,0x16
    8000549a:	b6a68693          	addi	a3,a3,-1174 # 8001b000 <disk>
    8000549e:	00c6d713          	srli	a4,a3,0xc
    800054a2:	2701                	sext.w	a4,a4
    800054a4:	100017b7          	lui	a5,0x10001
    800054a8:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054aa:	00018797          	auipc	a5,0x18
    800054ae:	b5678793          	addi	a5,a5,-1194 # 8001d000 <disk+0x2000>
    800054b2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054b4:	00016717          	auipc	a4,0x16
    800054b8:	bcc70713          	addi	a4,a4,-1076 # 8001b080 <disk+0x80>
    800054bc:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054be:	00017717          	auipc	a4,0x17
    800054c2:	b4270713          	addi	a4,a4,-1214 # 8001c000 <disk+0x1000>
    800054c6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054c8:	4705                	li	a4,1
    800054ca:	00e78c23          	sb	a4,24(a5)
    800054ce:	00e78ca3          	sb	a4,25(a5)
    800054d2:	00e78d23          	sb	a4,26(a5)
    800054d6:	00e78da3          	sb	a4,27(a5)
    800054da:	00e78e23          	sb	a4,28(a5)
    800054de:	00e78ea3          	sb	a4,29(a5)
    800054e2:	00e78f23          	sb	a4,30(a5)
    800054e6:	00e78fa3          	sb	a4,31(a5)
}
    800054ea:	60a2                	ld	ra,8(sp)
    800054ec:	6402                	ld	s0,0(sp)
    800054ee:	0141                	addi	sp,sp,16
    800054f0:	8082                	ret
    panic("could not find virtio disk");
    800054f2:	00003517          	auipc	a0,0x3
    800054f6:	12e50513          	addi	a0,a0,302 # 80008620 <etext+0x620>
    800054fa:	00001097          	auipc	ra,0x1
    800054fe:	8c2080e7          	jalr	-1854(ra) # 80005dbc <panic>
    panic("virtio disk has no queue 0");
    80005502:	00003517          	auipc	a0,0x3
    80005506:	13e50513          	addi	a0,a0,318 # 80008640 <etext+0x640>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	8b2080e7          	jalr	-1870(ra) # 80005dbc <panic>
    panic("virtio disk max queue too short");
    80005512:	00003517          	auipc	a0,0x3
    80005516:	14e50513          	addi	a0,a0,334 # 80008660 <etext+0x660>
    8000551a:	00001097          	auipc	ra,0x1
    8000551e:	8a2080e7          	jalr	-1886(ra) # 80005dbc <panic>

0000000080005522 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005522:	7159                	addi	sp,sp,-112
    80005524:	f486                	sd	ra,104(sp)
    80005526:	f0a2                	sd	s0,96(sp)
    80005528:	eca6                	sd	s1,88(sp)
    8000552a:	e8ca                	sd	s2,80(sp)
    8000552c:	e4ce                	sd	s3,72(sp)
    8000552e:	e0d2                	sd	s4,64(sp)
    80005530:	fc56                	sd	s5,56(sp)
    80005532:	f85a                	sd	s6,48(sp)
    80005534:	f45e                	sd	s7,40(sp)
    80005536:	f062                	sd	s8,32(sp)
    80005538:	ec66                	sd	s9,24(sp)
    8000553a:	1880                	addi	s0,sp,112
    8000553c:	8a2a                	mv	s4,a0
    8000553e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005540:	00c52c03          	lw	s8,12(a0)
    80005544:	001c1c1b          	slliw	s8,s8,0x1
    80005548:	1c02                	slli	s8,s8,0x20
    8000554a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000554e:	00018517          	auipc	a0,0x18
    80005552:	bda50513          	addi	a0,a0,-1062 # 8001d128 <disk+0x2128>
    80005556:	00001097          	auipc	ra,0x1
    8000555a:	e3c080e7          	jalr	-452(ra) # 80006392 <acquire>
  for(int i = 0; i < 3; i++){
    8000555e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005560:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005562:	00016b97          	auipc	s7,0x16
    80005566:	a9eb8b93          	addi	s7,s7,-1378 # 8001b000 <disk>
    8000556a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000556c:	4a8d                	li	s5,3
    8000556e:	a88d                	j	800055e0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005570:	00fb8733          	add	a4,s7,a5
    80005574:	975a                	add	a4,a4,s6
    80005576:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000557a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000557c:	0207c563          	bltz	a5,800055a6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005580:	2905                	addiw	s2,s2,1
    80005582:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005584:	1b590163          	beq	s2,s5,80005726 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005588:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000558a:	00018717          	auipc	a4,0x18
    8000558e:	a8e70713          	addi	a4,a4,-1394 # 8001d018 <disk+0x2018>
    80005592:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005594:	00074683          	lbu	a3,0(a4)
    80005598:	fee1                	bnez	a3,80005570 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000559a:	2785                	addiw	a5,a5,1
    8000559c:	0705                	addi	a4,a4,1
    8000559e:	fe979be3          	bne	a5,s1,80005594 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800055a2:	57fd                	li	a5,-1
    800055a4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055a6:	03205163          	blez	s2,800055c8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800055aa:	f9042503          	lw	a0,-112(s0)
    800055ae:	00000097          	auipc	ra,0x0
    800055b2:	d7c080e7          	jalr	-644(ra) # 8000532a <free_desc>
      for(int j = 0; j < i; j++)
    800055b6:	4785                	li	a5,1
    800055b8:	0127d863          	bge	a5,s2,800055c8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800055bc:	f9442503          	lw	a0,-108(s0)
    800055c0:	00000097          	auipc	ra,0x0
    800055c4:	d6a080e7          	jalr	-662(ra) # 8000532a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055c8:	00018597          	auipc	a1,0x18
    800055cc:	b6058593          	addi	a1,a1,-1184 # 8001d128 <disk+0x2128>
    800055d0:	00018517          	auipc	a0,0x18
    800055d4:	a4850513          	addi	a0,a0,-1464 # 8001d018 <disk+0x2018>
    800055d8:	ffffc097          	auipc	ra,0xffffc
    800055dc:	fba080e7          	jalr	-70(ra) # 80001592 <sleep>
  for(int i = 0; i < 3; i++){
    800055e0:	f9040613          	addi	a2,s0,-112
    800055e4:	894e                	mv	s2,s3
    800055e6:	b74d                	j	80005588 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055e8:	00018717          	auipc	a4,0x18
    800055ec:	a1873703          	ld	a4,-1512(a4) # 8001d000 <disk+0x2000>
    800055f0:	973e                	add	a4,a4,a5
    800055f2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055f6:	00016897          	auipc	a7,0x16
    800055fa:	a0a88893          	addi	a7,a7,-1526 # 8001b000 <disk>
    800055fe:	00018717          	auipc	a4,0x18
    80005602:	a0270713          	addi	a4,a4,-1534 # 8001d000 <disk+0x2000>
    80005606:	6314                	ld	a3,0(a4)
    80005608:	96be                	add	a3,a3,a5
    8000560a:	00c6d583          	lhu	a1,12(a3)
    8000560e:	0015e593          	ori	a1,a1,1
    80005612:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005616:	f9842683          	lw	a3,-104(s0)
    8000561a:	630c                	ld	a1,0(a4)
    8000561c:	97ae                	add	a5,a5,a1
    8000561e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005622:	20050593          	addi	a1,a0,512
    80005626:	0592                	slli	a1,a1,0x4
    80005628:	95c6                	add	a1,a1,a7
    8000562a:	57fd                	li	a5,-1
    8000562c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005630:	00469793          	slli	a5,a3,0x4
    80005634:	00073803          	ld	a6,0(a4)
    80005638:	983e                	add	a6,a6,a5
    8000563a:	6689                	lui	a3,0x2
    8000563c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005640:	96b2                	add	a3,a3,a2
    80005642:	96c6                	add	a3,a3,a7
    80005644:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005648:	6314                	ld	a3,0(a4)
    8000564a:	96be                	add	a3,a3,a5
    8000564c:	4605                	li	a2,1
    8000564e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005650:	6314                	ld	a3,0(a4)
    80005652:	96be                	add	a3,a3,a5
    80005654:	4809                	li	a6,2
    80005656:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000565a:	6314                	ld	a3,0(a4)
    8000565c:	97b6                	add	a5,a5,a3
    8000565e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005662:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005666:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000566a:	6714                	ld	a3,8(a4)
    8000566c:	0026d783          	lhu	a5,2(a3)
    80005670:	8b9d                	andi	a5,a5,7
    80005672:	0786                	slli	a5,a5,0x1
    80005674:	96be                	add	a3,a3,a5
    80005676:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000567a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000567e:	6718                	ld	a4,8(a4)
    80005680:	00275783          	lhu	a5,2(a4)
    80005684:	2785                	addiw	a5,a5,1
    80005686:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000568a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000568e:	100017b7          	lui	a5,0x10001
    80005692:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005696:	004a2783          	lw	a5,4(s4)
    8000569a:	02c79163          	bne	a5,a2,800056bc <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000569e:	00018917          	auipc	s2,0x18
    800056a2:	a8a90913          	addi	s2,s2,-1398 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800056a6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056a8:	85ca                	mv	a1,s2
    800056aa:	8552                	mv	a0,s4
    800056ac:	ffffc097          	auipc	ra,0xffffc
    800056b0:	ee6080e7          	jalr	-282(ra) # 80001592 <sleep>
  while(b->disk == 1) {
    800056b4:	004a2783          	lw	a5,4(s4)
    800056b8:	fe9788e3          	beq	a5,s1,800056a8 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800056bc:	f9042903          	lw	s2,-112(s0)
    800056c0:	20090713          	addi	a4,s2,512
    800056c4:	0712                	slli	a4,a4,0x4
    800056c6:	00016797          	auipc	a5,0x16
    800056ca:	93a78793          	addi	a5,a5,-1734 # 8001b000 <disk>
    800056ce:	97ba                	add	a5,a5,a4
    800056d0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056d4:	00018997          	auipc	s3,0x18
    800056d8:	92c98993          	addi	s3,s3,-1748 # 8001d000 <disk+0x2000>
    800056dc:	00491713          	slli	a4,s2,0x4
    800056e0:	0009b783          	ld	a5,0(s3)
    800056e4:	97ba                	add	a5,a5,a4
    800056e6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056ea:	854a                	mv	a0,s2
    800056ec:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056f0:	00000097          	auipc	ra,0x0
    800056f4:	c3a080e7          	jalr	-966(ra) # 8000532a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056f8:	8885                	andi	s1,s1,1
    800056fa:	f0ed                	bnez	s1,800056dc <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056fc:	00018517          	auipc	a0,0x18
    80005700:	a2c50513          	addi	a0,a0,-1492 # 8001d128 <disk+0x2128>
    80005704:	00001097          	auipc	ra,0x1
    80005708:	d42080e7          	jalr	-702(ra) # 80006446 <release>
}
    8000570c:	70a6                	ld	ra,104(sp)
    8000570e:	7406                	ld	s0,96(sp)
    80005710:	64e6                	ld	s1,88(sp)
    80005712:	6946                	ld	s2,80(sp)
    80005714:	69a6                	ld	s3,72(sp)
    80005716:	6a06                	ld	s4,64(sp)
    80005718:	7ae2                	ld	s5,56(sp)
    8000571a:	7b42                	ld	s6,48(sp)
    8000571c:	7ba2                	ld	s7,40(sp)
    8000571e:	7c02                	ld	s8,32(sp)
    80005720:	6ce2                	ld	s9,24(sp)
    80005722:	6165                	addi	sp,sp,112
    80005724:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005726:	f9042503          	lw	a0,-112(s0)
    8000572a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000572e:	00016597          	auipc	a1,0x16
    80005732:	8d258593          	addi	a1,a1,-1838 # 8001b000 <disk>
    80005736:	20050793          	addi	a5,a0,512
    8000573a:	0792                	slli	a5,a5,0x4
    8000573c:	97ae                	add	a5,a5,a1
    8000573e:	01903733          	snez	a4,s9
    80005742:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005746:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000574a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000574e:	00018717          	auipc	a4,0x18
    80005752:	8b270713          	addi	a4,a4,-1870 # 8001d000 <disk+0x2000>
    80005756:	6314                	ld	a3,0(a4)
    80005758:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000575a:	6789                	lui	a5,0x2
    8000575c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005760:	97b2                	add	a5,a5,a2
    80005762:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005764:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005766:	631c                	ld	a5,0(a4)
    80005768:	97b2                	add	a5,a5,a2
    8000576a:	46c1                	li	a3,16
    8000576c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000576e:	631c                	ld	a5,0(a4)
    80005770:	97b2                	add	a5,a5,a2
    80005772:	4685                	li	a3,1
    80005774:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005778:	f9442783          	lw	a5,-108(s0)
    8000577c:	6314                	ld	a3,0(a4)
    8000577e:	96b2                	add	a3,a3,a2
    80005780:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005784:	0792                	slli	a5,a5,0x4
    80005786:	6314                	ld	a3,0(a4)
    80005788:	96be                	add	a3,a3,a5
    8000578a:	058a0593          	addi	a1,s4,88
    8000578e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005790:	6318                	ld	a4,0(a4)
    80005792:	973e                	add	a4,a4,a5
    80005794:	40000693          	li	a3,1024
    80005798:	c714                	sw	a3,8(a4)
  if(write)
    8000579a:	e40c97e3          	bnez	s9,800055e8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000579e:	00018717          	auipc	a4,0x18
    800057a2:	86273703          	ld	a4,-1950(a4) # 8001d000 <disk+0x2000>
    800057a6:	973e                	add	a4,a4,a5
    800057a8:	4689                	li	a3,2
    800057aa:	00d71623          	sh	a3,12(a4)
    800057ae:	b5a1                	j	800055f6 <virtio_disk_rw+0xd4>

00000000800057b0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057b0:	1101                	addi	sp,sp,-32
    800057b2:	ec06                	sd	ra,24(sp)
    800057b4:	e822                	sd	s0,16(sp)
    800057b6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057b8:	00018517          	auipc	a0,0x18
    800057bc:	97050513          	addi	a0,a0,-1680 # 8001d128 <disk+0x2128>
    800057c0:	00001097          	auipc	ra,0x1
    800057c4:	bd2080e7          	jalr	-1070(ra) # 80006392 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057c8:	100017b7          	lui	a5,0x10001
    800057cc:	53b8                	lw	a4,96(a5)
    800057ce:	8b0d                	andi	a4,a4,3
    800057d0:	100017b7          	lui	a5,0x10001
    800057d4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800057d6:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057da:	00018797          	auipc	a5,0x18
    800057de:	82678793          	addi	a5,a5,-2010 # 8001d000 <disk+0x2000>
    800057e2:	6b94                	ld	a3,16(a5)
    800057e4:	0207d703          	lhu	a4,32(a5)
    800057e8:	0026d783          	lhu	a5,2(a3)
    800057ec:	06f70563          	beq	a4,a5,80005856 <virtio_disk_intr+0xa6>
    800057f0:	e426                	sd	s1,8(sp)
    800057f2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057f4:	00016917          	auipc	s2,0x16
    800057f8:	80c90913          	addi	s2,s2,-2036 # 8001b000 <disk>
    800057fc:	00018497          	auipc	s1,0x18
    80005800:	80448493          	addi	s1,s1,-2044 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005804:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005808:	6898                	ld	a4,16(s1)
    8000580a:	0204d783          	lhu	a5,32(s1)
    8000580e:	8b9d                	andi	a5,a5,7
    80005810:	078e                	slli	a5,a5,0x3
    80005812:	97ba                	add	a5,a5,a4
    80005814:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005816:	20078713          	addi	a4,a5,512
    8000581a:	0712                	slli	a4,a4,0x4
    8000581c:	974a                	add	a4,a4,s2
    8000581e:	03074703          	lbu	a4,48(a4)
    80005822:	e731                	bnez	a4,8000586e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005824:	20078793          	addi	a5,a5,512
    80005828:	0792                	slli	a5,a5,0x4
    8000582a:	97ca                	add	a5,a5,s2
    8000582c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000582e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005832:	ffffc097          	auipc	ra,0xffffc
    80005836:	eec080e7          	jalr	-276(ra) # 8000171e <wakeup>

    disk.used_idx += 1;
    8000583a:	0204d783          	lhu	a5,32(s1)
    8000583e:	2785                	addiw	a5,a5,1
    80005840:	17c2                	slli	a5,a5,0x30
    80005842:	93c1                	srli	a5,a5,0x30
    80005844:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005848:	6898                	ld	a4,16(s1)
    8000584a:	00275703          	lhu	a4,2(a4)
    8000584e:	faf71be3          	bne	a4,a5,80005804 <virtio_disk_intr+0x54>
    80005852:	64a2                	ld	s1,8(sp)
    80005854:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005856:	00018517          	auipc	a0,0x18
    8000585a:	8d250513          	addi	a0,a0,-1838 # 8001d128 <disk+0x2128>
    8000585e:	00001097          	auipc	ra,0x1
    80005862:	be8080e7          	jalr	-1048(ra) # 80006446 <release>
}
    80005866:	60e2                	ld	ra,24(sp)
    80005868:	6442                	ld	s0,16(sp)
    8000586a:	6105                	addi	sp,sp,32
    8000586c:	8082                	ret
      panic("virtio_disk_intr status");
    8000586e:	00003517          	auipc	a0,0x3
    80005872:	e1250513          	addi	a0,a0,-494 # 80008680 <etext+0x680>
    80005876:	00000097          	auipc	ra,0x0
    8000587a:	546080e7          	jalr	1350(ra) # 80005dbc <panic>

000000008000587e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000587e:	1141                	addi	sp,sp,-16
    80005880:	e422                	sd	s0,8(sp)
    80005882:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005884:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005888:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000588c:	0037979b          	slliw	a5,a5,0x3
    80005890:	02004737          	lui	a4,0x2004
    80005894:	97ba                	add	a5,a5,a4
    80005896:	0200c737          	lui	a4,0x200c
    8000589a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000589c:	6318                	ld	a4,0(a4)
    8000589e:	000f4637          	lui	a2,0xf4
    800058a2:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058a6:	9732                	add	a4,a4,a2
    800058a8:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058aa:	00259693          	slli	a3,a1,0x2
    800058ae:	96ae                	add	a3,a3,a1
    800058b0:	068e                	slli	a3,a3,0x3
    800058b2:	00018717          	auipc	a4,0x18
    800058b6:	74e70713          	addi	a4,a4,1870 # 8001e000 <timer_scratch>
    800058ba:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058bc:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058be:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058c0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058c4:	00000797          	auipc	a5,0x0
    800058c8:	99c78793          	addi	a5,a5,-1636 # 80005260 <timervec>
    800058cc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058d0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058d4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058d8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058dc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058e0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058e4:	30479073          	csrw	mie,a5
}
    800058e8:	6422                	ld	s0,8(sp)
    800058ea:	0141                	addi	sp,sp,16
    800058ec:	8082                	ret

00000000800058ee <start>:
{
    800058ee:	1141                	addi	sp,sp,-16
    800058f0:	e406                	sd	ra,8(sp)
    800058f2:	e022                	sd	s0,0(sp)
    800058f4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058f6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058fa:	7779                	lui	a4,0xffffe
    800058fc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005900:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005902:	6705                	lui	a4,0x1
    80005904:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005908:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000590a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000590e:	ffffb797          	auipc	a5,0xffffb
    80005912:	a0a78793          	addi	a5,a5,-1526 # 80000318 <main>
    80005916:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000591a:	4781                	li	a5,0
    8000591c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005920:	67c1                	lui	a5,0x10
    80005922:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005924:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005928:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000592c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005930:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005934:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005938:	57fd                	li	a5,-1
    8000593a:	83a9                	srli	a5,a5,0xa
    8000593c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005940:	47bd                	li	a5,15
    80005942:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005946:	00000097          	auipc	ra,0x0
    8000594a:	f38080e7          	jalr	-200(ra) # 8000587e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000594e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005952:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005954:	823e                	mv	tp,a5
  asm volatile("mret");
    80005956:	30200073          	mret
}
    8000595a:	60a2                	ld	ra,8(sp)
    8000595c:	6402                	ld	s0,0(sp)
    8000595e:	0141                	addi	sp,sp,16
    80005960:	8082                	ret

0000000080005962 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005962:	715d                	addi	sp,sp,-80
    80005964:	e486                	sd	ra,72(sp)
    80005966:	e0a2                	sd	s0,64(sp)
    80005968:	f84a                	sd	s2,48(sp)
    8000596a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000596c:	04c05663          	blez	a2,800059b8 <consolewrite+0x56>
    80005970:	fc26                	sd	s1,56(sp)
    80005972:	f44e                	sd	s3,40(sp)
    80005974:	f052                	sd	s4,32(sp)
    80005976:	ec56                	sd	s5,24(sp)
    80005978:	8a2a                	mv	s4,a0
    8000597a:	84ae                	mv	s1,a1
    8000597c:	89b2                	mv	s3,a2
    8000597e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005980:	5afd                	li	s5,-1
    80005982:	4685                	li	a3,1
    80005984:	8626                	mv	a2,s1
    80005986:	85d2                	mv	a1,s4
    80005988:	fbf40513          	addi	a0,s0,-65
    8000598c:	ffffc097          	auipc	ra,0xffffc
    80005990:	000080e7          	jalr	ra # 8000198c <either_copyin>
    80005994:	03550463          	beq	a0,s5,800059bc <consolewrite+0x5a>
      break;
    uartputc(c);
    80005998:	fbf44503          	lbu	a0,-65(s0)
    8000599c:	00001097          	auipc	ra,0x1
    800059a0:	83a080e7          	jalr	-1990(ra) # 800061d6 <uartputc>
  for(i = 0; i < n; i++){
    800059a4:	2905                	addiw	s2,s2,1
    800059a6:	0485                	addi	s1,s1,1
    800059a8:	fd299de3          	bne	s3,s2,80005982 <consolewrite+0x20>
    800059ac:	894e                	mv	s2,s3
    800059ae:	74e2                	ld	s1,56(sp)
    800059b0:	79a2                	ld	s3,40(sp)
    800059b2:	7a02                	ld	s4,32(sp)
    800059b4:	6ae2                	ld	s5,24(sp)
    800059b6:	a039                	j	800059c4 <consolewrite+0x62>
    800059b8:	4901                	li	s2,0
    800059ba:	a029                	j	800059c4 <consolewrite+0x62>
    800059bc:	74e2                	ld	s1,56(sp)
    800059be:	79a2                	ld	s3,40(sp)
    800059c0:	7a02                	ld	s4,32(sp)
    800059c2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    800059c4:	854a                	mv	a0,s2
    800059c6:	60a6                	ld	ra,72(sp)
    800059c8:	6406                	ld	s0,64(sp)
    800059ca:	7942                	ld	s2,48(sp)
    800059cc:	6161                	addi	sp,sp,80
    800059ce:	8082                	ret

00000000800059d0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059d0:	711d                	addi	sp,sp,-96
    800059d2:	ec86                	sd	ra,88(sp)
    800059d4:	e8a2                	sd	s0,80(sp)
    800059d6:	e4a6                	sd	s1,72(sp)
    800059d8:	e0ca                	sd	s2,64(sp)
    800059da:	fc4e                	sd	s3,56(sp)
    800059dc:	f852                	sd	s4,48(sp)
    800059de:	f456                	sd	s5,40(sp)
    800059e0:	f05a                	sd	s6,32(sp)
    800059e2:	1080                	addi	s0,sp,96
    800059e4:	8aaa                	mv	s5,a0
    800059e6:	8a2e                	mv	s4,a1
    800059e8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059ea:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059ee:	00020517          	auipc	a0,0x20
    800059f2:	75250513          	addi	a0,a0,1874 # 80026140 <cons>
    800059f6:	00001097          	auipc	ra,0x1
    800059fa:	99c080e7          	jalr	-1636(ra) # 80006392 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059fe:	00020497          	auipc	s1,0x20
    80005a02:	74248493          	addi	s1,s1,1858 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a06:	00020917          	auipc	s2,0x20
    80005a0a:	7d290913          	addi	s2,s2,2002 # 800261d8 <cons+0x98>
  while(n > 0){
    80005a0e:	0d305463          	blez	s3,80005ad6 <consoleread+0x106>
    while(cons.r == cons.w){
    80005a12:	0984a783          	lw	a5,152(s1)
    80005a16:	09c4a703          	lw	a4,156(s1)
    80005a1a:	0af71963          	bne	a4,a5,80005acc <consoleread+0xfc>
      if(myproc()->killed){
    80005a1e:	ffffb097          	auipc	ra,0xffffb
    80005a22:	45e080e7          	jalr	1118(ra) # 80000e7c <myproc>
    80005a26:	551c                	lw	a5,40(a0)
    80005a28:	e7ad                	bnez	a5,80005a92 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005a2a:	85a6                	mv	a1,s1
    80005a2c:	854a                	mv	a0,s2
    80005a2e:	ffffc097          	auipc	ra,0xffffc
    80005a32:	b64080e7          	jalr	-1180(ra) # 80001592 <sleep>
    while(cons.r == cons.w){
    80005a36:	0984a783          	lw	a5,152(s1)
    80005a3a:	09c4a703          	lw	a4,156(s1)
    80005a3e:	fef700e3          	beq	a4,a5,80005a1e <consoleread+0x4e>
    80005a42:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a44:	00020717          	auipc	a4,0x20
    80005a48:	6fc70713          	addi	a4,a4,1788 # 80026140 <cons>
    80005a4c:	0017869b          	addiw	a3,a5,1
    80005a50:	08d72c23          	sw	a3,152(a4)
    80005a54:	07f7f693          	andi	a3,a5,127
    80005a58:	9736                	add	a4,a4,a3
    80005a5a:	01874703          	lbu	a4,24(a4)
    80005a5e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a62:	4691                	li	a3,4
    80005a64:	04db8a63          	beq	s7,a3,80005ab8 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a68:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a6c:	4685                	li	a3,1
    80005a6e:	faf40613          	addi	a2,s0,-81
    80005a72:	85d2                	mv	a1,s4
    80005a74:	8556                	mv	a0,s5
    80005a76:	ffffc097          	auipc	ra,0xffffc
    80005a7a:	ec0080e7          	jalr	-320(ra) # 80001936 <either_copyout>
    80005a7e:	57fd                	li	a5,-1
    80005a80:	04f50a63          	beq	a0,a5,80005ad4 <consoleread+0x104>
      break;

    dst++;
    80005a84:	0a05                	addi	s4,s4,1
    --n;
    80005a86:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005a88:	47a9                	li	a5,10
    80005a8a:	06fb8163          	beq	s7,a5,80005aec <consoleread+0x11c>
    80005a8e:	6be2                	ld	s7,24(sp)
    80005a90:	bfbd                	j	80005a0e <consoleread+0x3e>
        release(&cons.lock);
    80005a92:	00020517          	auipc	a0,0x20
    80005a96:	6ae50513          	addi	a0,a0,1710 # 80026140 <cons>
    80005a9a:	00001097          	auipc	ra,0x1
    80005a9e:	9ac080e7          	jalr	-1620(ra) # 80006446 <release>
        return -1;
    80005aa2:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005aa4:	60e6                	ld	ra,88(sp)
    80005aa6:	6446                	ld	s0,80(sp)
    80005aa8:	64a6                	ld	s1,72(sp)
    80005aaa:	6906                	ld	s2,64(sp)
    80005aac:	79e2                	ld	s3,56(sp)
    80005aae:	7a42                	ld	s4,48(sp)
    80005ab0:	7aa2                	ld	s5,40(sp)
    80005ab2:	7b02                	ld	s6,32(sp)
    80005ab4:	6125                	addi	sp,sp,96
    80005ab6:	8082                	ret
      if(n < target){
    80005ab8:	0009871b          	sext.w	a4,s3
    80005abc:	01677a63          	bgeu	a4,s6,80005ad0 <consoleread+0x100>
        cons.r--;
    80005ac0:	00020717          	auipc	a4,0x20
    80005ac4:	70f72c23          	sw	a5,1816(a4) # 800261d8 <cons+0x98>
    80005ac8:	6be2                	ld	s7,24(sp)
    80005aca:	a031                	j	80005ad6 <consoleread+0x106>
    80005acc:	ec5e                	sd	s7,24(sp)
    80005ace:	bf9d                	j	80005a44 <consoleread+0x74>
    80005ad0:	6be2                	ld	s7,24(sp)
    80005ad2:	a011                	j	80005ad6 <consoleread+0x106>
    80005ad4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005ad6:	00020517          	auipc	a0,0x20
    80005ada:	66a50513          	addi	a0,a0,1642 # 80026140 <cons>
    80005ade:	00001097          	auipc	ra,0x1
    80005ae2:	968080e7          	jalr	-1688(ra) # 80006446 <release>
  return target - n;
    80005ae6:	413b053b          	subw	a0,s6,s3
    80005aea:	bf6d                	j	80005aa4 <consoleread+0xd4>
    80005aec:	6be2                	ld	s7,24(sp)
    80005aee:	b7e5                	j	80005ad6 <consoleread+0x106>

0000000080005af0 <consputc>:
{
    80005af0:	1141                	addi	sp,sp,-16
    80005af2:	e406                	sd	ra,8(sp)
    80005af4:	e022                	sd	s0,0(sp)
    80005af6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005af8:	10000793          	li	a5,256
    80005afc:	00f50a63          	beq	a0,a5,80005b10 <consputc+0x20>
    uartputc_sync(c);
    80005b00:	00000097          	auipc	ra,0x0
    80005b04:	5f8080e7          	jalr	1528(ra) # 800060f8 <uartputc_sync>
}
    80005b08:	60a2                	ld	ra,8(sp)
    80005b0a:	6402                	ld	s0,0(sp)
    80005b0c:	0141                	addi	sp,sp,16
    80005b0e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b10:	4521                	li	a0,8
    80005b12:	00000097          	auipc	ra,0x0
    80005b16:	5e6080e7          	jalr	1510(ra) # 800060f8 <uartputc_sync>
    80005b1a:	02000513          	li	a0,32
    80005b1e:	00000097          	auipc	ra,0x0
    80005b22:	5da080e7          	jalr	1498(ra) # 800060f8 <uartputc_sync>
    80005b26:	4521                	li	a0,8
    80005b28:	00000097          	auipc	ra,0x0
    80005b2c:	5d0080e7          	jalr	1488(ra) # 800060f8 <uartputc_sync>
    80005b30:	bfe1                	j	80005b08 <consputc+0x18>

0000000080005b32 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b32:	1101                	addi	sp,sp,-32
    80005b34:	ec06                	sd	ra,24(sp)
    80005b36:	e822                	sd	s0,16(sp)
    80005b38:	e426                	sd	s1,8(sp)
    80005b3a:	1000                	addi	s0,sp,32
    80005b3c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b3e:	00020517          	auipc	a0,0x20
    80005b42:	60250513          	addi	a0,a0,1538 # 80026140 <cons>
    80005b46:	00001097          	auipc	ra,0x1
    80005b4a:	84c080e7          	jalr	-1972(ra) # 80006392 <acquire>

  switch(c){
    80005b4e:	47d5                	li	a5,21
    80005b50:	0af48563          	beq	s1,a5,80005bfa <consoleintr+0xc8>
    80005b54:	0297c963          	blt	a5,s1,80005b86 <consoleintr+0x54>
    80005b58:	47a1                	li	a5,8
    80005b5a:	0ef48c63          	beq	s1,a5,80005c52 <consoleintr+0x120>
    80005b5e:	47c1                	li	a5,16
    80005b60:	10f49f63          	bne	s1,a5,80005c7e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005b64:	ffffc097          	auipc	ra,0xffffc
    80005b68:	e7e080e7          	jalr	-386(ra) # 800019e2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b6c:	00020517          	auipc	a0,0x20
    80005b70:	5d450513          	addi	a0,a0,1492 # 80026140 <cons>
    80005b74:	00001097          	auipc	ra,0x1
    80005b78:	8d2080e7          	jalr	-1838(ra) # 80006446 <release>
}
    80005b7c:	60e2                	ld	ra,24(sp)
    80005b7e:	6442                	ld	s0,16(sp)
    80005b80:	64a2                	ld	s1,8(sp)
    80005b82:	6105                	addi	sp,sp,32
    80005b84:	8082                	ret
  switch(c){
    80005b86:	07f00793          	li	a5,127
    80005b8a:	0cf48463          	beq	s1,a5,80005c52 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b8e:	00020717          	auipc	a4,0x20
    80005b92:	5b270713          	addi	a4,a4,1458 # 80026140 <cons>
    80005b96:	0a072783          	lw	a5,160(a4)
    80005b9a:	09872703          	lw	a4,152(a4)
    80005b9e:	9f99                	subw	a5,a5,a4
    80005ba0:	07f00713          	li	a4,127
    80005ba4:	fcf764e3          	bltu	a4,a5,80005b6c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005ba8:	47b5                	li	a5,13
    80005baa:	0cf48d63          	beq	s1,a5,80005c84 <consoleintr+0x152>
      consputc(c);
    80005bae:	8526                	mv	a0,s1
    80005bb0:	00000097          	auipc	ra,0x0
    80005bb4:	f40080e7          	jalr	-192(ra) # 80005af0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bb8:	00020797          	auipc	a5,0x20
    80005bbc:	58878793          	addi	a5,a5,1416 # 80026140 <cons>
    80005bc0:	0a07a703          	lw	a4,160(a5)
    80005bc4:	0017069b          	addiw	a3,a4,1
    80005bc8:	0006861b          	sext.w	a2,a3
    80005bcc:	0ad7a023          	sw	a3,160(a5)
    80005bd0:	07f77713          	andi	a4,a4,127
    80005bd4:	97ba                	add	a5,a5,a4
    80005bd6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bda:	47a9                	li	a5,10
    80005bdc:	0cf48b63          	beq	s1,a5,80005cb2 <consoleintr+0x180>
    80005be0:	4791                	li	a5,4
    80005be2:	0cf48863          	beq	s1,a5,80005cb2 <consoleintr+0x180>
    80005be6:	00020797          	auipc	a5,0x20
    80005bea:	5f27a783          	lw	a5,1522(a5) # 800261d8 <cons+0x98>
    80005bee:	0807879b          	addiw	a5,a5,128
    80005bf2:	f6f61de3          	bne	a2,a5,80005b6c <consoleintr+0x3a>
    80005bf6:	863e                	mv	a2,a5
    80005bf8:	a86d                	j	80005cb2 <consoleintr+0x180>
    80005bfa:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005bfc:	00020717          	auipc	a4,0x20
    80005c00:	54470713          	addi	a4,a4,1348 # 80026140 <cons>
    80005c04:	0a072783          	lw	a5,160(a4)
    80005c08:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c0c:	00020497          	auipc	s1,0x20
    80005c10:	53448493          	addi	s1,s1,1332 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005c14:	4929                	li	s2,10
    80005c16:	02f70a63          	beq	a4,a5,80005c4a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c1a:	37fd                	addiw	a5,a5,-1
    80005c1c:	07f7f713          	andi	a4,a5,127
    80005c20:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c22:	01874703          	lbu	a4,24(a4)
    80005c26:	03270463          	beq	a4,s2,80005c4e <consoleintr+0x11c>
      cons.e--;
    80005c2a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c2e:	10000513          	li	a0,256
    80005c32:	00000097          	auipc	ra,0x0
    80005c36:	ebe080e7          	jalr	-322(ra) # 80005af0 <consputc>
    while(cons.e != cons.w &&
    80005c3a:	0a04a783          	lw	a5,160(s1)
    80005c3e:	09c4a703          	lw	a4,156(s1)
    80005c42:	fcf71ce3          	bne	a4,a5,80005c1a <consoleintr+0xe8>
    80005c46:	6902                	ld	s2,0(sp)
    80005c48:	b715                	j	80005b6c <consoleintr+0x3a>
    80005c4a:	6902                	ld	s2,0(sp)
    80005c4c:	b705                	j	80005b6c <consoleintr+0x3a>
    80005c4e:	6902                	ld	s2,0(sp)
    80005c50:	bf31                	j	80005b6c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005c52:	00020717          	auipc	a4,0x20
    80005c56:	4ee70713          	addi	a4,a4,1262 # 80026140 <cons>
    80005c5a:	0a072783          	lw	a5,160(a4)
    80005c5e:	09c72703          	lw	a4,156(a4)
    80005c62:	f0f705e3          	beq	a4,a5,80005b6c <consoleintr+0x3a>
      cons.e--;
    80005c66:	37fd                	addiw	a5,a5,-1
    80005c68:	00020717          	auipc	a4,0x20
    80005c6c:	56f72c23          	sw	a5,1400(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c70:	10000513          	li	a0,256
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	e7c080e7          	jalr	-388(ra) # 80005af0 <consputc>
    80005c7c:	bdc5                	j	80005b6c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c7e:	ee0487e3          	beqz	s1,80005b6c <consoleintr+0x3a>
    80005c82:	b731                	j	80005b8e <consoleintr+0x5c>
      consputc(c);
    80005c84:	4529                	li	a0,10
    80005c86:	00000097          	auipc	ra,0x0
    80005c8a:	e6a080e7          	jalr	-406(ra) # 80005af0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c8e:	00020797          	auipc	a5,0x20
    80005c92:	4b278793          	addi	a5,a5,1202 # 80026140 <cons>
    80005c96:	0a07a703          	lw	a4,160(a5)
    80005c9a:	0017069b          	addiw	a3,a4,1
    80005c9e:	0006861b          	sext.w	a2,a3
    80005ca2:	0ad7a023          	sw	a3,160(a5)
    80005ca6:	07f77713          	andi	a4,a4,127
    80005caa:	97ba                	add	a5,a5,a4
    80005cac:	4729                	li	a4,10
    80005cae:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cb2:	00020797          	auipc	a5,0x20
    80005cb6:	52c7a523          	sw	a2,1322(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005cba:	00020517          	auipc	a0,0x20
    80005cbe:	51e50513          	addi	a0,a0,1310 # 800261d8 <cons+0x98>
    80005cc2:	ffffc097          	auipc	ra,0xffffc
    80005cc6:	a5c080e7          	jalr	-1444(ra) # 8000171e <wakeup>
    80005cca:	b54d                	j	80005b6c <consoleintr+0x3a>

0000000080005ccc <consoleinit>:

void
consoleinit(void)
{
    80005ccc:	1141                	addi	sp,sp,-16
    80005cce:	e406                	sd	ra,8(sp)
    80005cd0:	e022                	sd	s0,0(sp)
    80005cd2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cd4:	00003597          	auipc	a1,0x3
    80005cd8:	9c458593          	addi	a1,a1,-1596 # 80008698 <etext+0x698>
    80005cdc:	00020517          	auipc	a0,0x20
    80005ce0:	46450513          	addi	a0,a0,1124 # 80026140 <cons>
    80005ce4:	00000097          	auipc	ra,0x0
    80005ce8:	61e080e7          	jalr	1566(ra) # 80006302 <initlock>

  uartinit();
    80005cec:	00000097          	auipc	ra,0x0
    80005cf0:	3b0080e7          	jalr	944(ra) # 8000609c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cf4:	00014797          	auipc	a5,0x14
    80005cf8:	dd478793          	addi	a5,a5,-556 # 80019ac8 <devsw>
    80005cfc:	00000717          	auipc	a4,0x0
    80005d00:	cd470713          	addi	a4,a4,-812 # 800059d0 <consoleread>
    80005d04:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d06:	00000717          	auipc	a4,0x0
    80005d0a:	c5c70713          	addi	a4,a4,-932 # 80005962 <consolewrite>
    80005d0e:	ef98                	sd	a4,24(a5)
}
    80005d10:	60a2                	ld	ra,8(sp)
    80005d12:	6402                	ld	s0,0(sp)
    80005d14:	0141                	addi	sp,sp,16
    80005d16:	8082                	ret

0000000080005d18 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d18:	7179                	addi	sp,sp,-48
    80005d1a:	f406                	sd	ra,40(sp)
    80005d1c:	f022                	sd	s0,32(sp)
    80005d1e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d20:	c219                	beqz	a2,80005d26 <printint+0xe>
    80005d22:	08054963          	bltz	a0,80005db4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d26:	2501                	sext.w	a0,a0
    80005d28:	4881                	li	a7,0
    80005d2a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d2e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d30:	2581                	sext.w	a1,a1
    80005d32:	00003617          	auipc	a2,0x3
    80005d36:	ade60613          	addi	a2,a2,-1314 # 80008810 <digits>
    80005d3a:	883a                	mv	a6,a4
    80005d3c:	2705                	addiw	a4,a4,1
    80005d3e:	02b577bb          	remuw	a5,a0,a1
    80005d42:	1782                	slli	a5,a5,0x20
    80005d44:	9381                	srli	a5,a5,0x20
    80005d46:	97b2                	add	a5,a5,a2
    80005d48:	0007c783          	lbu	a5,0(a5)
    80005d4c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d50:	0005079b          	sext.w	a5,a0
    80005d54:	02b5553b          	divuw	a0,a0,a1
    80005d58:	0685                	addi	a3,a3,1
    80005d5a:	feb7f0e3          	bgeu	a5,a1,80005d3a <printint+0x22>

  if(sign)
    80005d5e:	00088c63          	beqz	a7,80005d76 <printint+0x5e>
    buf[i++] = '-';
    80005d62:	fe070793          	addi	a5,a4,-32
    80005d66:	00878733          	add	a4,a5,s0
    80005d6a:	02d00793          	li	a5,45
    80005d6e:	fef70823          	sb	a5,-16(a4)
    80005d72:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d76:	02e05b63          	blez	a4,80005dac <printint+0x94>
    80005d7a:	ec26                	sd	s1,24(sp)
    80005d7c:	e84a                	sd	s2,16(sp)
    80005d7e:	fd040793          	addi	a5,s0,-48
    80005d82:	00e784b3          	add	s1,a5,a4
    80005d86:	fff78913          	addi	s2,a5,-1
    80005d8a:	993a                	add	s2,s2,a4
    80005d8c:	377d                	addiw	a4,a4,-1
    80005d8e:	1702                	slli	a4,a4,0x20
    80005d90:	9301                	srli	a4,a4,0x20
    80005d92:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d96:	fff4c503          	lbu	a0,-1(s1)
    80005d9a:	00000097          	auipc	ra,0x0
    80005d9e:	d56080e7          	jalr	-682(ra) # 80005af0 <consputc>
  while(--i >= 0)
    80005da2:	14fd                	addi	s1,s1,-1
    80005da4:	ff2499e3          	bne	s1,s2,80005d96 <printint+0x7e>
    80005da8:	64e2                	ld	s1,24(sp)
    80005daa:	6942                	ld	s2,16(sp)
}
    80005dac:	70a2                	ld	ra,40(sp)
    80005dae:	7402                	ld	s0,32(sp)
    80005db0:	6145                	addi	sp,sp,48
    80005db2:	8082                	ret
    x = -xx;
    80005db4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005db8:	4885                	li	a7,1
    x = -xx;
    80005dba:	bf85                	j	80005d2a <printint+0x12>

0000000080005dbc <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dbc:	1101                	addi	sp,sp,-32
    80005dbe:	ec06                	sd	ra,24(sp)
    80005dc0:	e822                	sd	s0,16(sp)
    80005dc2:	e426                	sd	s1,8(sp)
    80005dc4:	1000                	addi	s0,sp,32
    80005dc6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dc8:	00020797          	auipc	a5,0x20
    80005dcc:	4207ac23          	sw	zero,1080(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005dd0:	00003517          	auipc	a0,0x3
    80005dd4:	8d050513          	addi	a0,a0,-1840 # 800086a0 <etext+0x6a0>
    80005dd8:	00000097          	auipc	ra,0x0
    80005ddc:	02e080e7          	jalr	46(ra) # 80005e06 <printf>
  printf(s);
    80005de0:	8526                	mv	a0,s1
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	024080e7          	jalr	36(ra) # 80005e06 <printf>
  printf("\n");
    80005dea:	00002517          	auipc	a0,0x2
    80005dee:	22e50513          	addi	a0,a0,558 # 80008018 <etext+0x18>
    80005df2:	00000097          	auipc	ra,0x0
    80005df6:	014080e7          	jalr	20(ra) # 80005e06 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dfa:	4785                	li	a5,1
    80005dfc:	00003717          	auipc	a4,0x3
    80005e00:	22f72023          	sw	a5,544(a4) # 8000901c <panicked>
  for(;;)
    80005e04:	a001                	j	80005e04 <panic+0x48>

0000000080005e06 <printf>:
{
    80005e06:	7131                	addi	sp,sp,-192
    80005e08:	fc86                	sd	ra,120(sp)
    80005e0a:	f8a2                	sd	s0,112(sp)
    80005e0c:	e8d2                	sd	s4,80(sp)
    80005e0e:	f06a                	sd	s10,32(sp)
    80005e10:	0100                	addi	s0,sp,128
    80005e12:	8a2a                	mv	s4,a0
    80005e14:	e40c                	sd	a1,8(s0)
    80005e16:	e810                	sd	a2,16(s0)
    80005e18:	ec14                	sd	a3,24(s0)
    80005e1a:	f018                	sd	a4,32(s0)
    80005e1c:	f41c                	sd	a5,40(s0)
    80005e1e:	03043823          	sd	a6,48(s0)
    80005e22:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e26:	00020d17          	auipc	s10,0x20
    80005e2a:	3dad2d03          	lw	s10,986(s10) # 80026200 <pr+0x18>
  if(locking)
    80005e2e:	040d1463          	bnez	s10,80005e76 <printf+0x70>
  if (fmt == 0)
    80005e32:	040a0b63          	beqz	s4,80005e88 <printf+0x82>
  va_start(ap, fmt);
    80005e36:	00840793          	addi	a5,s0,8
    80005e3a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e3e:	000a4503          	lbu	a0,0(s4)
    80005e42:	18050b63          	beqz	a0,80005fd8 <printf+0x1d2>
    80005e46:	f4a6                	sd	s1,104(sp)
    80005e48:	f0ca                	sd	s2,96(sp)
    80005e4a:	ecce                	sd	s3,88(sp)
    80005e4c:	e4d6                	sd	s5,72(sp)
    80005e4e:	e0da                	sd	s6,64(sp)
    80005e50:	fc5e                	sd	s7,56(sp)
    80005e52:	f862                	sd	s8,48(sp)
    80005e54:	f466                	sd	s9,40(sp)
    80005e56:	ec6e                	sd	s11,24(sp)
    80005e58:	4981                	li	s3,0
    if(c != '%'){
    80005e5a:	02500b13          	li	s6,37
    switch(c){
    80005e5e:	07000b93          	li	s7,112
  consputc('x');
    80005e62:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e64:	00003a97          	auipc	s5,0x3
    80005e68:	9aca8a93          	addi	s5,s5,-1620 # 80008810 <digits>
    switch(c){
    80005e6c:	07300c13          	li	s8,115
    80005e70:	06400d93          	li	s11,100
    80005e74:	a0b1                	j	80005ec0 <printf+0xba>
    acquire(&pr.lock);
    80005e76:	00020517          	auipc	a0,0x20
    80005e7a:	37250513          	addi	a0,a0,882 # 800261e8 <pr>
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	514080e7          	jalr	1300(ra) # 80006392 <acquire>
    80005e86:	b775                	j	80005e32 <printf+0x2c>
    80005e88:	f4a6                	sd	s1,104(sp)
    80005e8a:	f0ca                	sd	s2,96(sp)
    80005e8c:	ecce                	sd	s3,88(sp)
    80005e8e:	e4d6                	sd	s5,72(sp)
    80005e90:	e0da                	sd	s6,64(sp)
    80005e92:	fc5e                	sd	s7,56(sp)
    80005e94:	f862                	sd	s8,48(sp)
    80005e96:	f466                	sd	s9,40(sp)
    80005e98:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005e9a:	00003517          	auipc	a0,0x3
    80005e9e:	81650513          	addi	a0,a0,-2026 # 800086b0 <etext+0x6b0>
    80005ea2:	00000097          	auipc	ra,0x0
    80005ea6:	f1a080e7          	jalr	-230(ra) # 80005dbc <panic>
      consputc(c);
    80005eaa:	00000097          	auipc	ra,0x0
    80005eae:	c46080e7          	jalr	-954(ra) # 80005af0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eb2:	2985                	addiw	s3,s3,1
    80005eb4:	013a07b3          	add	a5,s4,s3
    80005eb8:	0007c503          	lbu	a0,0(a5)
    80005ebc:	10050563          	beqz	a0,80005fc6 <printf+0x1c0>
    if(c != '%'){
    80005ec0:	ff6515e3          	bne	a0,s6,80005eaa <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005ec4:	2985                	addiw	s3,s3,1
    80005ec6:	013a07b3          	add	a5,s4,s3
    80005eca:	0007c783          	lbu	a5,0(a5)
    80005ece:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ed2:	10078b63          	beqz	a5,80005fe8 <printf+0x1e2>
    switch(c){
    80005ed6:	05778a63          	beq	a5,s7,80005f2a <printf+0x124>
    80005eda:	02fbf663          	bgeu	s7,a5,80005f06 <printf+0x100>
    80005ede:	09878863          	beq	a5,s8,80005f6e <printf+0x168>
    80005ee2:	07800713          	li	a4,120
    80005ee6:	0ce79563          	bne	a5,a4,80005fb0 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005eea:	f8843783          	ld	a5,-120(s0)
    80005eee:	00878713          	addi	a4,a5,8
    80005ef2:	f8e43423          	sd	a4,-120(s0)
    80005ef6:	4605                	li	a2,1
    80005ef8:	85e6                	mv	a1,s9
    80005efa:	4388                	lw	a0,0(a5)
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	e1c080e7          	jalr	-484(ra) # 80005d18 <printint>
      break;
    80005f04:	b77d                	j	80005eb2 <printf+0xac>
    switch(c){
    80005f06:	09678f63          	beq	a5,s6,80005fa4 <printf+0x19e>
    80005f0a:	0bb79363          	bne	a5,s11,80005fb0 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005f0e:	f8843783          	ld	a5,-120(s0)
    80005f12:	00878713          	addi	a4,a5,8
    80005f16:	f8e43423          	sd	a4,-120(s0)
    80005f1a:	4605                	li	a2,1
    80005f1c:	45a9                	li	a1,10
    80005f1e:	4388                	lw	a0,0(a5)
    80005f20:	00000097          	auipc	ra,0x0
    80005f24:	df8080e7          	jalr	-520(ra) # 80005d18 <printint>
      break;
    80005f28:	b769                	j	80005eb2 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005f2a:	f8843783          	ld	a5,-120(s0)
    80005f2e:	00878713          	addi	a4,a5,8
    80005f32:	f8e43423          	sd	a4,-120(s0)
    80005f36:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f3a:	03000513          	li	a0,48
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	bb2080e7          	jalr	-1102(ra) # 80005af0 <consputc>
  consputc('x');
    80005f46:	07800513          	li	a0,120
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	ba6080e7          	jalr	-1114(ra) # 80005af0 <consputc>
    80005f52:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f54:	03c95793          	srli	a5,s2,0x3c
    80005f58:	97d6                	add	a5,a5,s5
    80005f5a:	0007c503          	lbu	a0,0(a5)
    80005f5e:	00000097          	auipc	ra,0x0
    80005f62:	b92080e7          	jalr	-1134(ra) # 80005af0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f66:	0912                	slli	s2,s2,0x4
    80005f68:	34fd                	addiw	s1,s1,-1
    80005f6a:	f4ed                	bnez	s1,80005f54 <printf+0x14e>
    80005f6c:	b799                	j	80005eb2 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005f6e:	f8843783          	ld	a5,-120(s0)
    80005f72:	00878713          	addi	a4,a5,8
    80005f76:	f8e43423          	sd	a4,-120(s0)
    80005f7a:	6384                	ld	s1,0(a5)
    80005f7c:	cc89                	beqz	s1,80005f96 <printf+0x190>
      for(; *s; s++)
    80005f7e:	0004c503          	lbu	a0,0(s1)
    80005f82:	d905                	beqz	a0,80005eb2 <printf+0xac>
        consputc(*s);
    80005f84:	00000097          	auipc	ra,0x0
    80005f88:	b6c080e7          	jalr	-1172(ra) # 80005af0 <consputc>
      for(; *s; s++)
    80005f8c:	0485                	addi	s1,s1,1
    80005f8e:	0004c503          	lbu	a0,0(s1)
    80005f92:	f96d                	bnez	a0,80005f84 <printf+0x17e>
    80005f94:	bf39                	j	80005eb2 <printf+0xac>
        s = "(null)";
    80005f96:	00002497          	auipc	s1,0x2
    80005f9a:	71248493          	addi	s1,s1,1810 # 800086a8 <etext+0x6a8>
      for(; *s; s++)
    80005f9e:	02800513          	li	a0,40
    80005fa2:	b7cd                	j	80005f84 <printf+0x17e>
      consputc('%');
    80005fa4:	855a                	mv	a0,s6
    80005fa6:	00000097          	auipc	ra,0x0
    80005faa:	b4a080e7          	jalr	-1206(ra) # 80005af0 <consputc>
      break;
    80005fae:	b711                	j	80005eb2 <printf+0xac>
      consputc('%');
    80005fb0:	855a                	mv	a0,s6
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	b3e080e7          	jalr	-1218(ra) # 80005af0 <consputc>
      consputc(c);
    80005fba:	8526                	mv	a0,s1
    80005fbc:	00000097          	auipc	ra,0x0
    80005fc0:	b34080e7          	jalr	-1228(ra) # 80005af0 <consputc>
      break;
    80005fc4:	b5fd                	j	80005eb2 <printf+0xac>
    80005fc6:	74a6                	ld	s1,104(sp)
    80005fc8:	7906                	ld	s2,96(sp)
    80005fca:	69e6                	ld	s3,88(sp)
    80005fcc:	6aa6                	ld	s5,72(sp)
    80005fce:	6b06                	ld	s6,64(sp)
    80005fd0:	7be2                	ld	s7,56(sp)
    80005fd2:	7c42                	ld	s8,48(sp)
    80005fd4:	7ca2                	ld	s9,40(sp)
    80005fd6:	6de2                	ld	s11,24(sp)
  if(locking)
    80005fd8:	020d1263          	bnez	s10,80005ffc <printf+0x1f6>
}
    80005fdc:	70e6                	ld	ra,120(sp)
    80005fde:	7446                	ld	s0,112(sp)
    80005fe0:	6a46                	ld	s4,80(sp)
    80005fe2:	7d02                	ld	s10,32(sp)
    80005fe4:	6129                	addi	sp,sp,192
    80005fe6:	8082                	ret
    80005fe8:	74a6                	ld	s1,104(sp)
    80005fea:	7906                	ld	s2,96(sp)
    80005fec:	69e6                	ld	s3,88(sp)
    80005fee:	6aa6                	ld	s5,72(sp)
    80005ff0:	6b06                	ld	s6,64(sp)
    80005ff2:	7be2                	ld	s7,56(sp)
    80005ff4:	7c42                	ld	s8,48(sp)
    80005ff6:	7ca2                	ld	s9,40(sp)
    80005ff8:	6de2                	ld	s11,24(sp)
    80005ffa:	bff9                	j	80005fd8 <printf+0x1d2>
    release(&pr.lock);
    80005ffc:	00020517          	auipc	a0,0x20
    80006000:	1ec50513          	addi	a0,a0,492 # 800261e8 <pr>
    80006004:	00000097          	auipc	ra,0x0
    80006008:	442080e7          	jalr	1090(ra) # 80006446 <release>
}
    8000600c:	bfc1                	j	80005fdc <printf+0x1d6>

000000008000600e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000600e:	1101                	addi	sp,sp,-32
    80006010:	ec06                	sd	ra,24(sp)
    80006012:	e822                	sd	s0,16(sp)
    80006014:	e426                	sd	s1,8(sp)
    80006016:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006018:	00020497          	auipc	s1,0x20
    8000601c:	1d048493          	addi	s1,s1,464 # 800261e8 <pr>
    80006020:	00002597          	auipc	a1,0x2
    80006024:	6a058593          	addi	a1,a1,1696 # 800086c0 <etext+0x6c0>
    80006028:	8526                	mv	a0,s1
    8000602a:	00000097          	auipc	ra,0x0
    8000602e:	2d8080e7          	jalr	728(ra) # 80006302 <initlock>
  pr.locking = 1;
    80006032:	4785                	li	a5,1
    80006034:	cc9c                	sw	a5,24(s1)
}
    80006036:	60e2                	ld	ra,24(sp)
    80006038:	6442                	ld	s0,16(sp)
    8000603a:	64a2                	ld	s1,8(sp)
    8000603c:	6105                	addi	sp,sp,32
    8000603e:	8082                	ret

0000000080006040 <backtrace>:

void backtrace(){
    80006040:	7179                	addi	sp,sp,-48
    80006042:	f406                	sd	ra,40(sp)
    80006044:	f022                	sd	s0,32(sp)
    80006046:	ec26                	sd	s1,24(sp)
    80006048:	1800                	addi	s0,sp,48
	asm volatile("mv %0, s0" : "=r" (x));
    8000604a:	84a2                	mv	s1,s0
	uint64 fp = r_fp();
	while(fp != PGROUNDUP(fp)){
    8000604c:	6785                	lui	a5,0x1
    8000604e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80006050:	97a6                	add	a5,a5,s1
    80006052:	777d                	lui	a4,0xfffff
    80006054:	8ff9                	and	a5,a5,a4
    80006056:	02f48e63          	beq	s1,a5,80006092 <backtrace+0x52>
    8000605a:	e84a                	sd	s2,16(sp)
    8000605c:	e44e                	sd	s3,8(sp)
    8000605e:	e052                	sd	s4,0(sp)
		uint64 ra = *(uint64*)(fp - 8);
		printf("%p\n", ra);
    80006060:	00002a17          	auipc	s4,0x2
    80006064:	668a0a13          	addi	s4,s4,1640 # 800086c8 <etext+0x6c8>
	while(fp != PGROUNDUP(fp)){
    80006068:	6905                	lui	s2,0x1
    8000606a:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    8000606c:	79fd                	lui	s3,0xfffff
		printf("%p\n", ra);
    8000606e:	ff84b583          	ld	a1,-8(s1)
    80006072:	8552                	mv	a0,s4
    80006074:	00000097          	auipc	ra,0x0
    80006078:	d92080e7          	jalr	-622(ra) # 80005e06 <printf>
		fp =  *(uint64*)(fp - 16);
    8000607c:	ff04b483          	ld	s1,-16(s1)
	while(fp != PGROUNDUP(fp)){
    80006080:	012487b3          	add	a5,s1,s2
    80006084:	0137f7b3          	and	a5,a5,s3
    80006088:	fe9793e3          	bne	a5,s1,8000606e <backtrace+0x2e>
    8000608c:	6942                	ld	s2,16(sp)
    8000608e:	69a2                	ld	s3,8(sp)
    80006090:	6a02                	ld	s4,0(sp)
	}
}
    80006092:	70a2                	ld	ra,40(sp)
    80006094:	7402                	ld	s0,32(sp)
    80006096:	64e2                	ld	s1,24(sp)
    80006098:	6145                	addi	sp,sp,48
    8000609a:	8082                	ret

000000008000609c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000609c:	1141                	addi	sp,sp,-16
    8000609e:	e406                	sd	ra,8(sp)
    800060a0:	e022                	sd	s0,0(sp)
    800060a2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060a4:	100007b7          	lui	a5,0x10000
    800060a8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060ac:	10000737          	lui	a4,0x10000
    800060b0:	f8000693          	li	a3,-128
    800060b4:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060b8:	468d                	li	a3,3
    800060ba:	10000637          	lui	a2,0x10000
    800060be:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060c2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060c6:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060ca:	10000737          	lui	a4,0x10000
    800060ce:	461d                	li	a2,7
    800060d0:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060d4:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060d8:	00002597          	auipc	a1,0x2
    800060dc:	5f858593          	addi	a1,a1,1528 # 800086d0 <etext+0x6d0>
    800060e0:	00020517          	auipc	a0,0x20
    800060e4:	12850513          	addi	a0,a0,296 # 80026208 <uart_tx_lock>
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	21a080e7          	jalr	538(ra) # 80006302 <initlock>
}
    800060f0:	60a2                	ld	ra,8(sp)
    800060f2:	6402                	ld	s0,0(sp)
    800060f4:	0141                	addi	sp,sp,16
    800060f6:	8082                	ret

00000000800060f8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060f8:	1101                	addi	sp,sp,-32
    800060fa:	ec06                	sd	ra,24(sp)
    800060fc:	e822                	sd	s0,16(sp)
    800060fe:	e426                	sd	s1,8(sp)
    80006100:	1000                	addi	s0,sp,32
    80006102:	84aa                	mv	s1,a0
  push_off();
    80006104:	00000097          	auipc	ra,0x0
    80006108:	242080e7          	jalr	578(ra) # 80006346 <push_off>

  if(panicked){
    8000610c:	00003797          	auipc	a5,0x3
    80006110:	f107a783          	lw	a5,-240(a5) # 8000901c <panicked>
    80006114:	eb85                	bnez	a5,80006144 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006116:	10000737          	lui	a4,0x10000
    8000611a:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000611c:	00074783          	lbu	a5,0(a4)
    80006120:	0207f793          	andi	a5,a5,32
    80006124:	dfe5                	beqz	a5,8000611c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006126:	0ff4f513          	zext.b	a0,s1
    8000612a:	100007b7          	lui	a5,0x10000
    8000612e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006132:	00000097          	auipc	ra,0x0
    80006136:	2b4080e7          	jalr	692(ra) # 800063e6 <pop_off>
}
    8000613a:	60e2                	ld	ra,24(sp)
    8000613c:	6442                	ld	s0,16(sp)
    8000613e:	64a2                	ld	s1,8(sp)
    80006140:	6105                	addi	sp,sp,32
    80006142:	8082                	ret
    for(;;)
    80006144:	a001                	j	80006144 <uartputc_sync+0x4c>

0000000080006146 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006146:	00003797          	auipc	a5,0x3
    8000614a:	eda7b783          	ld	a5,-294(a5) # 80009020 <uart_tx_r>
    8000614e:	00003717          	auipc	a4,0x3
    80006152:	eda73703          	ld	a4,-294(a4) # 80009028 <uart_tx_w>
    80006156:	06f70f63          	beq	a4,a5,800061d4 <uartstart+0x8e>
{
    8000615a:	7139                	addi	sp,sp,-64
    8000615c:	fc06                	sd	ra,56(sp)
    8000615e:	f822                	sd	s0,48(sp)
    80006160:	f426                	sd	s1,40(sp)
    80006162:	f04a                	sd	s2,32(sp)
    80006164:	ec4e                	sd	s3,24(sp)
    80006166:	e852                	sd	s4,16(sp)
    80006168:	e456                	sd	s5,8(sp)
    8000616a:	e05a                	sd	s6,0(sp)
    8000616c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000616e:	10000937          	lui	s2,0x10000
    80006172:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006174:	00020a97          	auipc	s5,0x20
    80006178:	094a8a93          	addi	s5,s5,148 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    8000617c:	00003497          	auipc	s1,0x3
    80006180:	ea448493          	addi	s1,s1,-348 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006184:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006188:	00003997          	auipc	s3,0x3
    8000618c:	ea098993          	addi	s3,s3,-352 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006190:	00094703          	lbu	a4,0(s2)
    80006194:	02077713          	andi	a4,a4,32
    80006198:	c705                	beqz	a4,800061c0 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000619a:	01f7f713          	andi	a4,a5,31
    8000619e:	9756                	add	a4,a4,s5
    800061a0:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800061a4:	0785                	addi	a5,a5,1
    800061a6:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800061a8:	8526                	mv	a0,s1
    800061aa:	ffffb097          	auipc	ra,0xffffb
    800061ae:	574080e7          	jalr	1396(ra) # 8000171e <wakeup>
    WriteReg(THR, c);
    800061b2:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800061b6:	609c                	ld	a5,0(s1)
    800061b8:	0009b703          	ld	a4,0(s3)
    800061bc:	fcf71ae3          	bne	a4,a5,80006190 <uartstart+0x4a>
  }
}
    800061c0:	70e2                	ld	ra,56(sp)
    800061c2:	7442                	ld	s0,48(sp)
    800061c4:	74a2                	ld	s1,40(sp)
    800061c6:	7902                	ld	s2,32(sp)
    800061c8:	69e2                	ld	s3,24(sp)
    800061ca:	6a42                	ld	s4,16(sp)
    800061cc:	6aa2                	ld	s5,8(sp)
    800061ce:	6b02                	ld	s6,0(sp)
    800061d0:	6121                	addi	sp,sp,64
    800061d2:	8082                	ret
    800061d4:	8082                	ret

00000000800061d6 <uartputc>:
{
    800061d6:	7179                	addi	sp,sp,-48
    800061d8:	f406                	sd	ra,40(sp)
    800061da:	f022                	sd	s0,32(sp)
    800061dc:	e052                	sd	s4,0(sp)
    800061de:	1800                	addi	s0,sp,48
    800061e0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800061e2:	00020517          	auipc	a0,0x20
    800061e6:	02650513          	addi	a0,a0,38 # 80026208 <uart_tx_lock>
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	1a8080e7          	jalr	424(ra) # 80006392 <acquire>
  if(panicked){
    800061f2:	00003797          	auipc	a5,0x3
    800061f6:	e2a7a783          	lw	a5,-470(a5) # 8000901c <panicked>
    800061fa:	c391                	beqz	a5,800061fe <uartputc+0x28>
    for(;;)
    800061fc:	a001                	j	800061fc <uartputc+0x26>
    800061fe:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006200:	00003717          	auipc	a4,0x3
    80006204:	e2873703          	ld	a4,-472(a4) # 80009028 <uart_tx_w>
    80006208:	00003797          	auipc	a5,0x3
    8000620c:	e187b783          	ld	a5,-488(a5) # 80009020 <uart_tx_r>
    80006210:	02078793          	addi	a5,a5,32
    80006214:	02e79f63          	bne	a5,a4,80006252 <uartputc+0x7c>
    80006218:	e84a                	sd	s2,16(sp)
    8000621a:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    8000621c:	00020997          	auipc	s3,0x20
    80006220:	fec98993          	addi	s3,s3,-20 # 80026208 <uart_tx_lock>
    80006224:	00003497          	auipc	s1,0x3
    80006228:	dfc48493          	addi	s1,s1,-516 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000622c:	00003917          	auipc	s2,0x3
    80006230:	dfc90913          	addi	s2,s2,-516 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006234:	85ce                	mv	a1,s3
    80006236:	8526                	mv	a0,s1
    80006238:	ffffb097          	auipc	ra,0xffffb
    8000623c:	35a080e7          	jalr	858(ra) # 80001592 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006240:	00093703          	ld	a4,0(s2)
    80006244:	609c                	ld	a5,0(s1)
    80006246:	02078793          	addi	a5,a5,32
    8000624a:	fee785e3          	beq	a5,a4,80006234 <uartputc+0x5e>
    8000624e:	6942                	ld	s2,16(sp)
    80006250:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006252:	00020497          	auipc	s1,0x20
    80006256:	fb648493          	addi	s1,s1,-74 # 80026208 <uart_tx_lock>
    8000625a:	01f77793          	andi	a5,a4,31
    8000625e:	97a6                	add	a5,a5,s1
    80006260:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006264:	0705                	addi	a4,a4,1
    80006266:	00003797          	auipc	a5,0x3
    8000626a:	dce7b123          	sd	a4,-574(a5) # 80009028 <uart_tx_w>
      uartstart();
    8000626e:	00000097          	auipc	ra,0x0
    80006272:	ed8080e7          	jalr	-296(ra) # 80006146 <uartstart>
      release(&uart_tx_lock);
    80006276:	8526                	mv	a0,s1
    80006278:	00000097          	auipc	ra,0x0
    8000627c:	1ce080e7          	jalr	462(ra) # 80006446 <release>
    80006280:	64e2                	ld	s1,24(sp)
}
    80006282:	70a2                	ld	ra,40(sp)
    80006284:	7402                	ld	s0,32(sp)
    80006286:	6a02                	ld	s4,0(sp)
    80006288:	6145                	addi	sp,sp,48
    8000628a:	8082                	ret

000000008000628c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000628c:	1141                	addi	sp,sp,-16
    8000628e:	e422                	sd	s0,8(sp)
    80006290:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006292:	100007b7          	lui	a5,0x10000
    80006296:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006298:	0007c783          	lbu	a5,0(a5)
    8000629c:	8b85                	andi	a5,a5,1
    8000629e:	cb81                	beqz	a5,800062ae <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800062a0:	100007b7          	lui	a5,0x10000
    800062a4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800062a8:	6422                	ld	s0,8(sp)
    800062aa:	0141                	addi	sp,sp,16
    800062ac:	8082                	ret
    return -1;
    800062ae:	557d                	li	a0,-1
    800062b0:	bfe5                	j	800062a8 <uartgetc+0x1c>

00000000800062b2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800062b2:	1101                	addi	sp,sp,-32
    800062b4:	ec06                	sd	ra,24(sp)
    800062b6:	e822                	sd	s0,16(sp)
    800062b8:	e426                	sd	s1,8(sp)
    800062ba:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062bc:	54fd                	li	s1,-1
    800062be:	a029                	j	800062c8 <uartintr+0x16>
      break;
    consoleintr(c);
    800062c0:	00000097          	auipc	ra,0x0
    800062c4:	872080e7          	jalr	-1934(ra) # 80005b32 <consoleintr>
    int c = uartgetc();
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	fc4080e7          	jalr	-60(ra) # 8000628c <uartgetc>
    if(c == -1)
    800062d0:	fe9518e3          	bne	a0,s1,800062c0 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062d4:	00020497          	auipc	s1,0x20
    800062d8:	f3448493          	addi	s1,s1,-204 # 80026208 <uart_tx_lock>
    800062dc:	8526                	mv	a0,s1
    800062de:	00000097          	auipc	ra,0x0
    800062e2:	0b4080e7          	jalr	180(ra) # 80006392 <acquire>
  uartstart();
    800062e6:	00000097          	auipc	ra,0x0
    800062ea:	e60080e7          	jalr	-416(ra) # 80006146 <uartstart>
  release(&uart_tx_lock);
    800062ee:	8526                	mv	a0,s1
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	156080e7          	jalr	342(ra) # 80006446 <release>
}
    800062f8:	60e2                	ld	ra,24(sp)
    800062fa:	6442                	ld	s0,16(sp)
    800062fc:	64a2                	ld	s1,8(sp)
    800062fe:	6105                	addi	sp,sp,32
    80006300:	8082                	ret

0000000080006302 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006302:	1141                	addi	sp,sp,-16
    80006304:	e422                	sd	s0,8(sp)
    80006306:	0800                	addi	s0,sp,16
  lk->name = name;
    80006308:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000630a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000630e:	00053823          	sd	zero,16(a0)
}
    80006312:	6422                	ld	s0,8(sp)
    80006314:	0141                	addi	sp,sp,16
    80006316:	8082                	ret

0000000080006318 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006318:	411c                	lw	a5,0(a0)
    8000631a:	e399                	bnez	a5,80006320 <holding+0x8>
    8000631c:	4501                	li	a0,0
  return r;
}
    8000631e:	8082                	ret
{
    80006320:	1101                	addi	sp,sp,-32
    80006322:	ec06                	sd	ra,24(sp)
    80006324:	e822                	sd	s0,16(sp)
    80006326:	e426                	sd	s1,8(sp)
    80006328:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000632a:	6904                	ld	s1,16(a0)
    8000632c:	ffffb097          	auipc	ra,0xffffb
    80006330:	b34080e7          	jalr	-1228(ra) # 80000e60 <mycpu>
    80006334:	40a48533          	sub	a0,s1,a0
    80006338:	00153513          	seqz	a0,a0
}
    8000633c:	60e2                	ld	ra,24(sp)
    8000633e:	6442                	ld	s0,16(sp)
    80006340:	64a2                	ld	s1,8(sp)
    80006342:	6105                	addi	sp,sp,32
    80006344:	8082                	ret

0000000080006346 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006346:	1101                	addi	sp,sp,-32
    80006348:	ec06                	sd	ra,24(sp)
    8000634a:	e822                	sd	s0,16(sp)
    8000634c:	e426                	sd	s1,8(sp)
    8000634e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006350:	100024f3          	csrr	s1,sstatus
    80006354:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006358:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000635a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000635e:	ffffb097          	auipc	ra,0xffffb
    80006362:	b02080e7          	jalr	-1278(ra) # 80000e60 <mycpu>
    80006366:	5d3c                	lw	a5,120(a0)
    80006368:	cf89                	beqz	a5,80006382 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000636a:	ffffb097          	auipc	ra,0xffffb
    8000636e:	af6080e7          	jalr	-1290(ra) # 80000e60 <mycpu>
    80006372:	5d3c                	lw	a5,120(a0)
    80006374:	2785                	addiw	a5,a5,1
    80006376:	dd3c                	sw	a5,120(a0)
}
    80006378:	60e2                	ld	ra,24(sp)
    8000637a:	6442                	ld	s0,16(sp)
    8000637c:	64a2                	ld	s1,8(sp)
    8000637e:	6105                	addi	sp,sp,32
    80006380:	8082                	ret
    mycpu()->intena = old;
    80006382:	ffffb097          	auipc	ra,0xffffb
    80006386:	ade080e7          	jalr	-1314(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000638a:	8085                	srli	s1,s1,0x1
    8000638c:	8885                	andi	s1,s1,1
    8000638e:	dd64                	sw	s1,124(a0)
    80006390:	bfe9                	j	8000636a <push_off+0x24>

0000000080006392 <acquire>:
{
    80006392:	1101                	addi	sp,sp,-32
    80006394:	ec06                	sd	ra,24(sp)
    80006396:	e822                	sd	s0,16(sp)
    80006398:	e426                	sd	s1,8(sp)
    8000639a:	1000                	addi	s0,sp,32
    8000639c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000639e:	00000097          	auipc	ra,0x0
    800063a2:	fa8080e7          	jalr	-88(ra) # 80006346 <push_off>
  if(holding(lk))
    800063a6:	8526                	mv	a0,s1
    800063a8:	00000097          	auipc	ra,0x0
    800063ac:	f70080e7          	jalr	-144(ra) # 80006318 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063b0:	4705                	li	a4,1
  if(holding(lk))
    800063b2:	e115                	bnez	a0,800063d6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063b4:	87ba                	mv	a5,a4
    800063b6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063ba:	2781                	sext.w	a5,a5
    800063bc:	ffe5                	bnez	a5,800063b4 <acquire+0x22>
  __sync_synchronize();
    800063be:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063c2:	ffffb097          	auipc	ra,0xffffb
    800063c6:	a9e080e7          	jalr	-1378(ra) # 80000e60 <mycpu>
    800063ca:	e888                	sd	a0,16(s1)
}
    800063cc:	60e2                	ld	ra,24(sp)
    800063ce:	6442                	ld	s0,16(sp)
    800063d0:	64a2                	ld	s1,8(sp)
    800063d2:	6105                	addi	sp,sp,32
    800063d4:	8082                	ret
    panic("acquire");
    800063d6:	00002517          	auipc	a0,0x2
    800063da:	30250513          	addi	a0,a0,770 # 800086d8 <etext+0x6d8>
    800063de:	00000097          	auipc	ra,0x0
    800063e2:	9de080e7          	jalr	-1570(ra) # 80005dbc <panic>

00000000800063e6 <pop_off>:

void
pop_off(void)
{
    800063e6:	1141                	addi	sp,sp,-16
    800063e8:	e406                	sd	ra,8(sp)
    800063ea:	e022                	sd	s0,0(sp)
    800063ec:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063ee:	ffffb097          	auipc	ra,0xffffb
    800063f2:	a72080e7          	jalr	-1422(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063f6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063fa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063fc:	e78d                	bnez	a5,80006426 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063fe:	5d3c                	lw	a5,120(a0)
    80006400:	02f05b63          	blez	a5,80006436 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006404:	37fd                	addiw	a5,a5,-1
    80006406:	0007871b          	sext.w	a4,a5
    8000640a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000640c:	eb09                	bnez	a4,8000641e <pop_off+0x38>
    8000640e:	5d7c                	lw	a5,124(a0)
    80006410:	c799                	beqz	a5,8000641e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006412:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006416:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000641a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000641e:	60a2                	ld	ra,8(sp)
    80006420:	6402                	ld	s0,0(sp)
    80006422:	0141                	addi	sp,sp,16
    80006424:	8082                	ret
    panic("pop_off - interruptible");
    80006426:	00002517          	auipc	a0,0x2
    8000642a:	2ba50513          	addi	a0,a0,698 # 800086e0 <etext+0x6e0>
    8000642e:	00000097          	auipc	ra,0x0
    80006432:	98e080e7          	jalr	-1650(ra) # 80005dbc <panic>
    panic("pop_off");
    80006436:	00002517          	auipc	a0,0x2
    8000643a:	2c250513          	addi	a0,a0,706 # 800086f8 <etext+0x6f8>
    8000643e:	00000097          	auipc	ra,0x0
    80006442:	97e080e7          	jalr	-1666(ra) # 80005dbc <panic>

0000000080006446 <release>:
{
    80006446:	1101                	addi	sp,sp,-32
    80006448:	ec06                	sd	ra,24(sp)
    8000644a:	e822                	sd	s0,16(sp)
    8000644c:	e426                	sd	s1,8(sp)
    8000644e:	1000                	addi	s0,sp,32
    80006450:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006452:	00000097          	auipc	ra,0x0
    80006456:	ec6080e7          	jalr	-314(ra) # 80006318 <holding>
    8000645a:	c115                	beqz	a0,8000647e <release+0x38>
  lk->cpu = 0;
    8000645c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006460:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006464:	0f50000f          	fence	iorw,ow
    80006468:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000646c:	00000097          	auipc	ra,0x0
    80006470:	f7a080e7          	jalr	-134(ra) # 800063e6 <pop_off>
}
    80006474:	60e2                	ld	ra,24(sp)
    80006476:	6442                	ld	s0,16(sp)
    80006478:	64a2                	ld	s1,8(sp)
    8000647a:	6105                	addi	sp,sp,32
    8000647c:	8082                	ret
    panic("release");
    8000647e:	00002517          	auipc	a0,0x2
    80006482:	28250513          	addi	a0,a0,642 # 80008700 <etext+0x700>
    80006486:	00000097          	auipc	ra,0x0
    8000648a:	936080e7          	jalr	-1738(ra) # 80005dbc <panic>
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
