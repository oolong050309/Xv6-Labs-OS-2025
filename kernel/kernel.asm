
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
    80000016:	089050ef          	jal	8000589e <start>

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
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	28c080e7          	jalr	652(ra) # 800062e6 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	32c080e7          	jalr	812(ra) # 8000639a <release>
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
    8000008e:	ce2080e7          	jalr	-798(ra) # 80005d6c <panic>

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
    800000fa:	160080e7          	jalr	352(ra) # 80006256 <initlock>
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
    80000132:	1b8080e7          	jalr	440(ra) # 800062e6 <acquire>
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
    8000014a:	254080e7          	jalr	596(ra) # 8000639a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
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
    80000174:	22a080e7          	jalr	554(ra) # 8000639a <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <count_free_mem>:

uint64 count_free_mem(void)
{
    8000017a:	1101                	addi	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	addi	s0,sp,32
	acquire(&kmem.lock);
    80000184:	00009497          	auipc	s1,0x9
    80000188:	eac48493          	addi	s1,s1,-340 # 80009030 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	158080e7          	jalr	344(ra) # 800062e6 <acquire>
	//The memory management structure must be locked first to prevent race conditions from occurring
	//Count the number of free pages. Multiply the page size PGSIZE to get the number of free memory bytes.
	uint64 mem_bytes = 0;
	struct run *r = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
	while(r){
    80000198:	c785                	beqz	a5,800001c0 <count_free_mem+0x46>
	uint64 mem_bytes = 0;
    8000019a:	4481                	li	s1,0
		mem_bytes += PGSIZE;
    8000019c:	6705                	lui	a4,0x1
    8000019e:	94ba                	add	s1,s1,a4
		r = r->next;
    800001a0:	639c                	ld	a5,0(a5)
	while(r){
    800001a2:	fff5                	bnez	a5,8000019e <count_free_mem+0x24>
	}
	
	release(&kmem.lock);
    800001a4:	00009517          	auipc	a0,0x9
    800001a8:	e8c50513          	addi	a0,a0,-372 # 80009030 <kmem>
    800001ac:	00006097          	auipc	ra,0x6
    800001b0:	1ee080e7          	jalr	494(ra) # 8000639a <release>
	return mem_bytes;
}
    800001b4:	8526                	mv	a0,s1
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	addi	sp,sp,32
    800001be:	8082                	ret
	uint64 mem_bytes = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7cd                	j	800001a4 <count_free_mem+0x2a>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	slli	a2,a2,0x20
    800001d0:	9201                	srli	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	addi	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	addi	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	addi	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	slli	a3,a3,0x20
    800001f4:	9281                	srli	a3,a3,0x20
    800001f6:	0685                	addi	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	addi	a0,a0,1
    80000208:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	addi	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	addi	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	slli	a2,a2,0x20
    8000022e:	9201                	srli	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	addi	a1,a1,1
    80000238:	0705                	addi	a4,a4,1 # 1001 <_entry-0x7fffefff>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	feb79ae3          	bne	a5,a1,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	addi	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	slli	a3,a2,0x20
    80000250:	9281                	srli	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addiw	a5,a2,-1
    80000260:	1782                	slli	a5,a5,0x20
    80000262:	9381                	srli	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	addi	a4,a4,-1
    8000026c:	16fd                	addi	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fef71ae3          	bne	a4,a5,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	addi	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addiw	a2,a2,-1
    800002ac:	0505                	addi	a0,a0,1
    800002ae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a801                	j	800002c4 <strncmp+0x30>
    800002b6:	4501                	li	a0,0
    800002b8:	a031                	j	800002c4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800002ba:	00054503          	lbu	a0,0(a0)
    800002be:	0005c783          	lbu	a5,0(a1)
    800002c2:	9d1d                	subw	a0,a0,a5
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d0:	87aa                	mv	a5,a0
    800002d2:	86b2                	mv	a3,a2
    800002d4:	367d                	addiw	a2,a2,-1
    800002d6:	02d05563          	blez	a3,80000300 <strncpy+0x36>
    800002da:	0785                	addi	a5,a5,1
    800002dc:	0005c703          	lbu	a4,0(a1)
    800002e0:	fee78fa3          	sb	a4,-1(a5)
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	f775                	bnez	a4,800002d2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002e8:	873e                	mv	a4,a5
    800002ea:	9fb5                	addw	a5,a5,a3
    800002ec:	37fd                	addiw	a5,a5,-1
    800002ee:	00c05963          	blez	a2,80000300 <strncpy+0x36>
    *s++ = 0;
    800002f2:	0705                	addi	a4,a4,1
    800002f4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002f8:	40e786bb          	subw	a3,a5,a4
    800002fc:	fed04be3          	bgtz	a3,800002f2 <strncpy+0x28>
  return os;
}
    80000300:	6422                	ld	s0,8(sp)
    80000302:	0141                	addi	sp,sp,16
    80000304:	8082                	ret

0000000080000306 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000306:	1141                	addi	sp,sp,-16
    80000308:	e422                	sd	s0,8(sp)
    8000030a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000030c:	02c05363          	blez	a2,80000332 <safestrcpy+0x2c>
    80000310:	fff6069b          	addiw	a3,a2,-1
    80000314:	1682                	slli	a3,a3,0x20
    80000316:	9281                	srli	a3,a3,0x20
    80000318:	96ae                	add	a3,a3,a1
    8000031a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000031c:	00d58963          	beq	a1,a3,8000032e <safestrcpy+0x28>
    80000320:	0585                	addi	a1,a1,1
    80000322:	0785                	addi	a5,a5,1
    80000324:	fff5c703          	lbu	a4,-1(a1)
    80000328:	fee78fa3          	sb	a4,-1(a5)
    8000032c:	fb65                	bnez	a4,8000031c <safestrcpy+0x16>
    ;
  *s = 0;
    8000032e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000332:	6422                	ld	s0,8(sp)
    80000334:	0141                	addi	sp,sp,16
    80000336:	8082                	ret

0000000080000338 <strlen>:

int
strlen(const char *s)
{
    80000338:	1141                	addi	sp,sp,-16
    8000033a:	e422                	sd	s0,8(sp)
    8000033c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000033e:	00054783          	lbu	a5,0(a0)
    80000342:	cf91                	beqz	a5,8000035e <strlen+0x26>
    80000344:	0505                	addi	a0,a0,1
    80000346:	87aa                	mv	a5,a0
    80000348:	86be                	mv	a3,a5
    8000034a:	0785                	addi	a5,a5,1
    8000034c:	fff7c703          	lbu	a4,-1(a5)
    80000350:	ff65                	bnez	a4,80000348 <strlen+0x10>
    80000352:	40a6853b          	subw	a0,a3,a0
    80000356:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000358:	6422                	ld	s0,8(sp)
    8000035a:	0141                	addi	sp,sp,16
    8000035c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000035e:	4501                	li	a0,0
    80000360:	bfe5                	j	80000358 <strlen+0x20>

0000000080000362 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000362:	1141                	addi	sp,sp,-16
    80000364:	e406                	sd	ra,8(sp)
    80000366:	e022                	sd	s0,0(sp)
    80000368:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000036a:	00001097          	auipc	ra,0x1
    8000036e:	b30080e7          	jalr	-1232(ra) # 80000e9a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000372:	00009717          	auipc	a4,0x9
    80000376:	c8e70713          	addi	a4,a4,-882 # 80009000 <started>
  if(cpuid() == 0){
    8000037a:	c139                	beqz	a0,800003c0 <main+0x5e>
    while(started == 0)
    8000037c:	431c                	lw	a5,0(a4)
    8000037e:	2781                	sext.w	a5,a5
    80000380:	dff5                	beqz	a5,8000037c <main+0x1a>
      ;
    __sync_synchronize();
    80000382:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000386:	00001097          	auipc	ra,0x1
    8000038a:	b14080e7          	jalr	-1260(ra) # 80000e9a <cpuid>
    8000038e:	85aa                	mv	a1,a0
    80000390:	00008517          	auipc	a0,0x8
    80000394:	ca850513          	addi	a0,a0,-856 # 80008038 <etext+0x38>
    80000398:	00006097          	auipc	ra,0x6
    8000039c:	a1e080e7          	jalr	-1506(ra) # 80005db6 <printf>
    kvminithart();    // turn on paging
    800003a0:	00000097          	auipc	ra,0x0
    800003a4:	0d8080e7          	jalr	216(ra) # 80000478 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003a8:	00001097          	auipc	ra,0x1
    800003ac:	7b0080e7          	jalr	1968(ra) # 80001b58 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b0:	00005097          	auipc	ra,0x5
    800003b4:	ea4080e7          	jalr	-348(ra) # 80005254 <plicinithart>
  }

  scheduler();        
    800003b8:	00001097          	auipc	ra,0x1
    800003bc:	02e080e7          	jalr	46(ra) # 800013e6 <scheduler>
    consoleinit();
    800003c0:	00006097          	auipc	ra,0x6
    800003c4:	8bc080e7          	jalr	-1860(ra) # 80005c7c <consoleinit>
    printfinit();
    800003c8:	00006097          	auipc	ra,0x6
    800003cc:	bf6080e7          	jalr	-1034(ra) # 80005fbe <printfinit>
    printf("\n");
    800003d0:	00008517          	auipc	a0,0x8
    800003d4:	c4850513          	addi	a0,a0,-952 # 80008018 <etext+0x18>
    800003d8:	00006097          	auipc	ra,0x6
    800003dc:	9de080e7          	jalr	-1570(ra) # 80005db6 <printf>
    printf("xv6 kernel is booting\n");
    800003e0:	00008517          	auipc	a0,0x8
    800003e4:	c4050513          	addi	a0,a0,-960 # 80008020 <etext+0x20>
    800003e8:	00006097          	auipc	ra,0x6
    800003ec:	9ce080e7          	jalr	-1586(ra) # 80005db6 <printf>
    printf("\n");
    800003f0:	00008517          	auipc	a0,0x8
    800003f4:	c2850513          	addi	a0,a0,-984 # 80008018 <etext+0x18>
    800003f8:	00006097          	auipc	ra,0x6
    800003fc:	9be080e7          	jalr	-1602(ra) # 80005db6 <printf>
    kinit();         // physical page allocator
    80000400:	00000097          	auipc	ra,0x0
    80000404:	cde080e7          	jalr	-802(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	322080e7          	jalr	802(ra) # 8000072a <kvminit>
    kvminithart();   // turn on paging
    80000410:	00000097          	auipc	ra,0x0
    80000414:	068080e7          	jalr	104(ra) # 80000478 <kvminithart>
    procinit();      // process table
    80000418:	00001097          	auipc	ra,0x1
    8000041c:	9c4080e7          	jalr	-1596(ra) # 80000ddc <procinit>
    trapinit();      // trap vectors
    80000420:	00001097          	auipc	ra,0x1
    80000424:	710080e7          	jalr	1808(ra) # 80001b30 <trapinit>
    trapinithart();  // install kernel trap vector
    80000428:	00001097          	auipc	ra,0x1
    8000042c:	730080e7          	jalr	1840(ra) # 80001b58 <trapinithart>
    plicinit();      // set up interrupt controller
    80000430:	00005097          	auipc	ra,0x5
    80000434:	e0a080e7          	jalr	-502(ra) # 8000523a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000438:	00005097          	auipc	ra,0x5
    8000043c:	e1c080e7          	jalr	-484(ra) # 80005254 <plicinithart>
    binit();         // buffer cache
    80000440:	00002097          	auipc	ra,0x2
    80000444:	f38080e7          	jalr	-200(ra) # 80002378 <binit>
    iinit();         // inode table
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	5c4080e7          	jalr	1476(ra) # 80002a0c <iinit>
    fileinit();      // file table
    80000450:	00003097          	auipc	ra,0x3
    80000454:	568080e7          	jalr	1384(ra) # 800039b8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000458:	00005097          	auipc	ra,0x5
    8000045c:	f1c080e7          	jalr	-228(ra) # 80005374 <virtio_disk_init>
    userinit();      // first user process
    80000460:	00001097          	auipc	ra,0x1
    80000464:	d42080e7          	jalr	-702(ra) # 800011a2 <userinit>
    __sync_synchronize();
    80000468:	0ff0000f          	fence
    started = 1;
    8000046c:	4785                	li	a5,1
    8000046e:	00009717          	auipc	a4,0x9
    80000472:	b8f72923          	sw	a5,-1134(a4) # 80009000 <started>
    80000476:	b789                	j	800003b8 <main+0x56>

0000000080000478 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000478:	1141                	addi	sp,sp,-16
    8000047a:	e422                	sd	s0,8(sp)
    8000047c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000047e:	00009797          	auipc	a5,0x9
    80000482:	b8a7b783          	ld	a5,-1142(a5) # 80009008 <kernel_pagetable>
    80000486:	83b1                	srli	a5,a5,0xc
    80000488:	577d                	li	a4,-1
    8000048a:	177e                	slli	a4,a4,0x3f
    8000048c:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000048e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000492:	12000073          	sfence.vma
  sfence_vma();
}
    80000496:	6422                	ld	s0,8(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000049c:	7139                	addi	sp,sp,-64
    8000049e:	fc06                	sd	ra,56(sp)
    800004a0:	f822                	sd	s0,48(sp)
    800004a2:	f426                	sd	s1,40(sp)
    800004a4:	f04a                	sd	s2,32(sp)
    800004a6:	ec4e                	sd	s3,24(sp)
    800004a8:	e852                	sd	s4,16(sp)
    800004aa:	e456                	sd	s5,8(sp)
    800004ac:	e05a                	sd	s6,0(sp)
    800004ae:	0080                	addi	s0,sp,64
    800004b0:	84aa                	mv	s1,a0
    800004b2:	89ae                	mv	s3,a1
    800004b4:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004b6:	57fd                	li	a5,-1
    800004b8:	83e9                	srli	a5,a5,0x1a
    800004ba:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004bc:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004be:	04b7f263          	bgeu	a5,a1,80000502 <walk+0x66>
    panic("walk");
    800004c2:	00008517          	auipc	a0,0x8
    800004c6:	b8e50513          	addi	a0,a0,-1138 # 80008050 <etext+0x50>
    800004ca:	00006097          	auipc	ra,0x6
    800004ce:	8a2080e7          	jalr	-1886(ra) # 80005d6c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004d2:	060a8663          	beqz	s5,8000053e <walk+0xa2>
    800004d6:	00000097          	auipc	ra,0x0
    800004da:	c44080e7          	jalr	-956(ra) # 8000011a <kalloc>
    800004de:	84aa                	mv	s1,a0
    800004e0:	c529                	beqz	a0,8000052a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004e2:	6605                	lui	a2,0x1
    800004e4:	4581                	li	a1,0
    800004e6:	00000097          	auipc	ra,0x0
    800004ea:	cde080e7          	jalr	-802(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ee:	00c4d793          	srli	a5,s1,0xc
    800004f2:	07aa                	slli	a5,a5,0xa
    800004f4:	0017e793          	ori	a5,a5,1
    800004f8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004fe:	036a0063          	beq	s4,s6,8000051e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000502:	0149d933          	srl	s2,s3,s4
    80000506:	1ff97913          	andi	s2,s2,511
    8000050a:	090e                	slli	s2,s2,0x3
    8000050c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000050e:	00093483          	ld	s1,0(s2)
    80000512:	0014f793          	andi	a5,s1,1
    80000516:	dfd5                	beqz	a5,800004d2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000518:	80a9                	srli	s1,s1,0xa
    8000051a:	04b2                	slli	s1,s1,0xc
    8000051c:	b7c5                	j	800004fc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000051e:	00c9d513          	srli	a0,s3,0xc
    80000522:	1ff57513          	andi	a0,a0,511
    80000526:	050e                	slli	a0,a0,0x3
    80000528:	9526                	add	a0,a0,s1
}
    8000052a:	70e2                	ld	ra,56(sp)
    8000052c:	7442                	ld	s0,48(sp)
    8000052e:	74a2                	ld	s1,40(sp)
    80000530:	7902                	ld	s2,32(sp)
    80000532:	69e2                	ld	s3,24(sp)
    80000534:	6a42                	ld	s4,16(sp)
    80000536:	6aa2                	ld	s5,8(sp)
    80000538:	6b02                	ld	s6,0(sp)
    8000053a:	6121                	addi	sp,sp,64
    8000053c:	8082                	ret
        return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7ed                	j	8000052a <walk+0x8e>

0000000080000542 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000542:	57fd                	li	a5,-1
    80000544:	83e9                	srli	a5,a5,0x1a
    80000546:	00b7f463          	bgeu	a5,a1,8000054e <walkaddr+0xc>
    return 0;
    8000054a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000054c:	8082                	ret
{
    8000054e:	1141                	addi	sp,sp,-16
    80000550:	e406                	sd	ra,8(sp)
    80000552:	e022                	sd	s0,0(sp)
    80000554:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000556:	4601                	li	a2,0
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	f44080e7          	jalr	-188(ra) # 8000049c <walk>
  if(pte == 0)
    80000560:	c105                	beqz	a0,80000580 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000562:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000564:	0117f693          	andi	a3,a5,17
    80000568:	4745                	li	a4,17
    return 0;
    8000056a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000056c:	00e68663          	beq	a3,a4,80000578 <walkaddr+0x36>
}
    80000570:	60a2                	ld	ra,8(sp)
    80000572:	6402                	ld	s0,0(sp)
    80000574:	0141                	addi	sp,sp,16
    80000576:	8082                	ret
  pa = PTE2PA(*pte);
    80000578:	83a9                	srli	a5,a5,0xa
    8000057a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000057e:	bfcd                	j	80000570 <walkaddr+0x2e>
    return 0;
    80000580:	4501                	li	a0,0
    80000582:	b7fd                	j	80000570 <walkaddr+0x2e>

0000000080000584 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000584:	715d                	addi	sp,sp,-80
    80000586:	e486                	sd	ra,72(sp)
    80000588:	e0a2                	sd	s0,64(sp)
    8000058a:	fc26                	sd	s1,56(sp)
    8000058c:	f84a                	sd	s2,48(sp)
    8000058e:	f44e                	sd	s3,40(sp)
    80000590:	f052                	sd	s4,32(sp)
    80000592:	ec56                	sd	s5,24(sp)
    80000594:	e85a                	sd	s6,16(sp)
    80000596:	e45e                	sd	s7,8(sp)
    80000598:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000059a:	c639                	beqz	a2,800005e8 <mappages+0x64>
    8000059c:	8aaa                	mv	s5,a0
    8000059e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005a0:	777d                	lui	a4,0xfffff
    800005a2:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005a6:	fff58993          	addi	s3,a1,-1
    800005aa:	99b2                	add	s3,s3,a2
    800005ac:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005b0:	893e                	mv	s2,a5
    800005b2:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005b6:	6b85                	lui	s7,0x1
    800005b8:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800005bc:	4605                	li	a2,1
    800005be:	85ca                	mv	a1,s2
    800005c0:	8556                	mv	a0,s5
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	eda080e7          	jalr	-294(ra) # 8000049c <walk>
    800005ca:	cd1d                	beqz	a0,80000608 <mappages+0x84>
    if(*pte & PTE_V)
    800005cc:	611c                	ld	a5,0(a0)
    800005ce:	8b85                	andi	a5,a5,1
    800005d0:	e785                	bnez	a5,800005f8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005d2:	80b1                	srli	s1,s1,0xc
    800005d4:	04aa                	slli	s1,s1,0xa
    800005d6:	0164e4b3          	or	s1,s1,s6
    800005da:	0014e493          	ori	s1,s1,1
    800005de:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e0:	05390063          	beq	s2,s3,80000620 <mappages+0x9c>
    a += PGSIZE;
    800005e4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005e6:	bfc9                	j	800005b8 <mappages+0x34>
    panic("mappages: size");
    800005e8:	00008517          	auipc	a0,0x8
    800005ec:	a7050513          	addi	a0,a0,-1424 # 80008058 <etext+0x58>
    800005f0:	00005097          	auipc	ra,0x5
    800005f4:	77c080e7          	jalr	1916(ra) # 80005d6c <panic>
      panic("mappages: remap");
    800005f8:	00008517          	auipc	a0,0x8
    800005fc:	a7050513          	addi	a0,a0,-1424 # 80008068 <etext+0x68>
    80000600:	00005097          	auipc	ra,0x5
    80000604:	76c080e7          	jalr	1900(ra) # 80005d6c <panic>
      return -1;
    80000608:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000060a:	60a6                	ld	ra,72(sp)
    8000060c:	6406                	ld	s0,64(sp)
    8000060e:	74e2                	ld	s1,56(sp)
    80000610:	7942                	ld	s2,48(sp)
    80000612:	79a2                	ld	s3,40(sp)
    80000614:	7a02                	ld	s4,32(sp)
    80000616:	6ae2                	ld	s5,24(sp)
    80000618:	6b42                	ld	s6,16(sp)
    8000061a:	6ba2                	ld	s7,8(sp)
    8000061c:	6161                	addi	sp,sp,80
    8000061e:	8082                	ret
  return 0;
    80000620:	4501                	li	a0,0
    80000622:	b7e5                	j	8000060a <mappages+0x86>

0000000080000624 <kvmmap>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
    8000062c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000062e:	86b2                	mv	a3,a2
    80000630:	863e                	mv	a2,a5
    80000632:	00000097          	auipc	ra,0x0
    80000636:	f52080e7          	jalr	-174(ra) # 80000584 <mappages>
    8000063a:	e509                	bnez	a0,80000644 <kvmmap+0x20>
}
    8000063c:	60a2                	ld	ra,8(sp)
    8000063e:	6402                	ld	s0,0(sp)
    80000640:	0141                	addi	sp,sp,16
    80000642:	8082                	ret
    panic("kvmmap");
    80000644:	00008517          	auipc	a0,0x8
    80000648:	a3450513          	addi	a0,a0,-1484 # 80008078 <etext+0x78>
    8000064c:	00005097          	auipc	ra,0x5
    80000650:	720080e7          	jalr	1824(ra) # 80005d6c <panic>

0000000080000654 <kvmmake>:
{
    80000654:	1101                	addi	sp,sp,-32
    80000656:	ec06                	sd	ra,24(sp)
    80000658:	e822                	sd	s0,16(sp)
    8000065a:	e426                	sd	s1,8(sp)
    8000065c:	e04a                	sd	s2,0(sp)
    8000065e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000660:	00000097          	auipc	ra,0x0
    80000664:	aba080e7          	jalr	-1350(ra) # 8000011a <kalloc>
    80000668:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000066a:	6605                	lui	a2,0x1
    8000066c:	4581                	li	a1,0
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	b56080e7          	jalr	-1194(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000676:	4719                	li	a4,6
    80000678:	6685                	lui	a3,0x1
    8000067a:	10000637          	lui	a2,0x10000
    8000067e:	100005b7          	lui	a1,0x10000
    80000682:	8526                	mv	a0,s1
    80000684:	00000097          	auipc	ra,0x0
    80000688:	fa0080e7          	jalr	-96(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000068c:	4719                	li	a4,6
    8000068e:	6685                	lui	a3,0x1
    80000690:	10001637          	lui	a2,0x10001
    80000694:	100015b7          	lui	a1,0x10001
    80000698:	8526                	mv	a0,s1
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	f8a080e7          	jalr	-118(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006a2:	4719                	li	a4,6
    800006a4:	004006b7          	lui	a3,0x400
    800006a8:	0c000637          	lui	a2,0xc000
    800006ac:	0c0005b7          	lui	a1,0xc000
    800006b0:	8526                	mv	a0,s1
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	f72080e7          	jalr	-142(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006ba:	00008917          	auipc	s2,0x8
    800006be:	94690913          	addi	s2,s2,-1722 # 80008000 <etext>
    800006c2:	4729                	li	a4,10
    800006c4:	80008697          	auipc	a3,0x80008
    800006c8:	93c68693          	addi	a3,a3,-1732 # 8000 <_entry-0x7fff8000>
    800006cc:	4605                	li	a2,1
    800006ce:	067e                	slli	a2,a2,0x1f
    800006d0:	85b2                	mv	a1,a2
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	f50080e7          	jalr	-176(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006dc:	46c5                	li	a3,17
    800006de:	06ee                	slli	a3,a3,0x1b
    800006e0:	4719                	li	a4,6
    800006e2:	412686b3          	sub	a3,a3,s2
    800006e6:	864a                	mv	a2,s2
    800006e8:	85ca                	mv	a1,s2
    800006ea:	8526                	mv	a0,s1
    800006ec:	00000097          	auipc	ra,0x0
    800006f0:	f38080e7          	jalr	-200(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006f4:	4729                	li	a4,10
    800006f6:	6685                	lui	a3,0x1
    800006f8:	00007617          	auipc	a2,0x7
    800006fc:	90860613          	addi	a2,a2,-1784 # 80007000 <_trampoline>
    80000700:	040005b7          	lui	a1,0x4000
    80000704:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000706:	05b2                	slli	a1,a1,0xc
    80000708:	8526                	mv	a0,s1
    8000070a:	00000097          	auipc	ra,0x0
    8000070e:	f1a080e7          	jalr	-230(ra) # 80000624 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	624080e7          	jalr	1572(ra) # 80000d38 <proc_mapstacks>
}
    8000071c:	8526                	mv	a0,s1
    8000071e:	60e2                	ld	ra,24(sp)
    80000720:	6442                	ld	s0,16(sp)
    80000722:	64a2                	ld	s1,8(sp)
    80000724:	6902                	ld	s2,0(sp)
    80000726:	6105                	addi	sp,sp,32
    80000728:	8082                	ret

000000008000072a <kvminit>:
{
    8000072a:	1141                	addi	sp,sp,-16
    8000072c:	e406                	sd	ra,8(sp)
    8000072e:	e022                	sd	s0,0(sp)
    80000730:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000732:	00000097          	auipc	ra,0x0
    80000736:	f22080e7          	jalr	-222(ra) # 80000654 <kvmmake>
    8000073a:	00009797          	auipc	a5,0x9
    8000073e:	8ca7b723          	sd	a0,-1842(a5) # 80009008 <kernel_pagetable>
}
    80000742:	60a2                	ld	ra,8(sp)
    80000744:	6402                	ld	s0,0(sp)
    80000746:	0141                	addi	sp,sp,16
    80000748:	8082                	ret

000000008000074a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000074a:	715d                	addi	sp,sp,-80
    8000074c:	e486                	sd	ra,72(sp)
    8000074e:	e0a2                	sd	s0,64(sp)
    80000750:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000752:	03459793          	slli	a5,a1,0x34
    80000756:	e39d                	bnez	a5,8000077c <uvmunmap+0x32>
    80000758:	f84a                	sd	s2,48(sp)
    8000075a:	f44e                	sd	s3,40(sp)
    8000075c:	f052                	sd	s4,32(sp)
    8000075e:	ec56                	sd	s5,24(sp)
    80000760:	e85a                	sd	s6,16(sp)
    80000762:	e45e                	sd	s7,8(sp)
    80000764:	8a2a                	mv	s4,a0
    80000766:	892e                	mv	s2,a1
    80000768:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000076a:	0632                	slli	a2,a2,0xc
    8000076c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000770:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000772:	6b05                	lui	s6,0x1
    80000774:	0935fb63          	bgeu	a1,s3,8000080a <uvmunmap+0xc0>
    80000778:	fc26                	sd	s1,56(sp)
    8000077a:	a8a9                	j	800007d4 <uvmunmap+0x8a>
    8000077c:	fc26                	sd	s1,56(sp)
    8000077e:	f84a                	sd	s2,48(sp)
    80000780:	f44e                	sd	s3,40(sp)
    80000782:	f052                	sd	s4,32(sp)
    80000784:	ec56                	sd	s5,24(sp)
    80000786:	e85a                	sd	s6,16(sp)
    80000788:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000078a:	00008517          	auipc	a0,0x8
    8000078e:	8f650513          	addi	a0,a0,-1802 # 80008080 <etext+0x80>
    80000792:	00005097          	auipc	ra,0x5
    80000796:	5da080e7          	jalr	1498(ra) # 80005d6c <panic>
      panic("uvmunmap: walk");
    8000079a:	00008517          	auipc	a0,0x8
    8000079e:	8fe50513          	addi	a0,a0,-1794 # 80008098 <etext+0x98>
    800007a2:	00005097          	auipc	ra,0x5
    800007a6:	5ca080e7          	jalr	1482(ra) # 80005d6c <panic>
      panic("uvmunmap: not mapped");
    800007aa:	00008517          	auipc	a0,0x8
    800007ae:	8fe50513          	addi	a0,a0,-1794 # 800080a8 <etext+0xa8>
    800007b2:	00005097          	auipc	ra,0x5
    800007b6:	5ba080e7          	jalr	1466(ra) # 80005d6c <panic>
      panic("uvmunmap: not a leaf");
    800007ba:	00008517          	auipc	a0,0x8
    800007be:	90650513          	addi	a0,a0,-1786 # 800080c0 <etext+0xc0>
    800007c2:	00005097          	auipc	ra,0x5
    800007c6:	5aa080e7          	jalr	1450(ra) # 80005d6c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007ca:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ce:	995a                	add	s2,s2,s6
    800007d0:	03397c63          	bgeu	s2,s3,80000808 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d4:	4601                	li	a2,0
    800007d6:	85ca                	mv	a1,s2
    800007d8:	8552                	mv	a0,s4
    800007da:	00000097          	auipc	ra,0x0
    800007de:	cc2080e7          	jalr	-830(ra) # 8000049c <walk>
    800007e2:	84aa                	mv	s1,a0
    800007e4:	d95d                	beqz	a0,8000079a <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800007e6:	6108                	ld	a0,0(a0)
    800007e8:	00157793          	andi	a5,a0,1
    800007ec:	dfdd                	beqz	a5,800007aa <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ee:	3ff57793          	andi	a5,a0,1023
    800007f2:	fd7784e3          	beq	a5,s7,800007ba <uvmunmap+0x70>
    if(do_free){
    800007f6:	fc0a8ae3          	beqz	s5,800007ca <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007fa:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007fc:	0532                	slli	a0,a0,0xc
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	81e080e7          	jalr	-2018(ra) # 8000001c <kfree>
    80000806:	b7d1                	j	800007ca <uvmunmap+0x80>
    80000808:	74e2                	ld	s1,56(sp)
    8000080a:	7942                	ld	s2,48(sp)
    8000080c:	79a2                	ld	s3,40(sp)
    8000080e:	7a02                	ld	s4,32(sp)
    80000810:	6ae2                	ld	s5,24(sp)
    80000812:	6b42                	ld	s6,16(sp)
    80000814:	6ba2                	ld	s7,8(sp)
  }
}
    80000816:	60a6                	ld	ra,72(sp)
    80000818:	6406                	ld	s0,64(sp)
    8000081a:	6161                	addi	sp,sp,80
    8000081c:	8082                	ret

000000008000081e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081e:	1101                	addi	sp,sp,-32
    80000820:	ec06                	sd	ra,24(sp)
    80000822:	e822                	sd	s0,16(sp)
    80000824:	e426                	sd	s1,8(sp)
    80000826:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	8f2080e7          	jalr	-1806(ra) # 8000011a <kalloc>
    80000830:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000832:	c519                	beqz	a0,80000840 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	98c080e7          	jalr	-1652(ra) # 800001c4 <memset>
  return pagetable;
}
    80000840:	8526                	mv	a0,s1
    80000842:	60e2                	ld	ra,24(sp)
    80000844:	6442                	ld	s0,16(sp)
    80000846:	64a2                	ld	s1,8(sp)
    80000848:	6105                	addi	sp,sp,32
    8000084a:	8082                	ret

000000008000084c <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084c:	7179                	addi	sp,sp,-48
    8000084e:	f406                	sd	ra,40(sp)
    80000850:	f022                	sd	s0,32(sp)
    80000852:	ec26                	sd	s1,24(sp)
    80000854:	e84a                	sd	s2,16(sp)
    80000856:	e44e                	sd	s3,8(sp)
    80000858:	e052                	sd	s4,0(sp)
    8000085a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085c:	6785                	lui	a5,0x1
    8000085e:	04f67863          	bgeu	a2,a5,800008ae <uvminit+0x62>
    80000862:	8a2a                	mv	s4,a0
    80000864:	89ae                	mv	s3,a1
    80000866:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	8b2080e7          	jalr	-1870(ra) # 8000011a <kalloc>
    80000870:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000872:	6605                	lui	a2,0x1
    80000874:	4581                	li	a1,0
    80000876:	00000097          	auipc	ra,0x0
    8000087a:	94e080e7          	jalr	-1714(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087e:	4779                	li	a4,30
    80000880:	86ca                	mv	a3,s2
    80000882:	6605                	lui	a2,0x1
    80000884:	4581                	li	a1,0
    80000886:	8552                	mv	a0,s4
    80000888:	00000097          	auipc	ra,0x0
    8000088c:	cfc080e7          	jalr	-772(ra) # 80000584 <mappages>
  memmove(mem, src, sz);
    80000890:	8626                	mv	a2,s1
    80000892:	85ce                	mv	a1,s3
    80000894:	854a                	mv	a0,s2
    80000896:	00000097          	auipc	ra,0x0
    8000089a:	98a080e7          	jalr	-1654(ra) # 80000220 <memmove>
}
    8000089e:	70a2                	ld	ra,40(sp)
    800008a0:	7402                	ld	s0,32(sp)
    800008a2:	64e2                	ld	s1,24(sp)
    800008a4:	6942                	ld	s2,16(sp)
    800008a6:	69a2                	ld	s3,8(sp)
    800008a8:	6a02                	ld	s4,0(sp)
    800008aa:	6145                	addi	sp,sp,48
    800008ac:	8082                	ret
    panic("inituvm: more than a page");
    800008ae:	00008517          	auipc	a0,0x8
    800008b2:	82a50513          	addi	a0,a0,-2006 # 800080d8 <etext+0xd8>
    800008b6:	00005097          	auipc	ra,0x5
    800008ba:	4b6080e7          	jalr	1206(ra) # 80005d6c <panic>

00000000800008be <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008be:	1101                	addi	sp,sp,-32
    800008c0:	ec06                	sd	ra,24(sp)
    800008c2:	e822                	sd	s0,16(sp)
    800008c4:	e426                	sd	s1,8(sp)
    800008c6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008ca:	00b67d63          	bgeu	a2,a1,800008e4 <uvmdealloc+0x26>
    800008ce:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d0:	6785                	lui	a5,0x1
    800008d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d4:	00f60733          	add	a4,a2,a5
    800008d8:	76fd                	lui	a3,0xfffff
    800008da:	8f75                	and	a4,a4,a3
    800008dc:	97ae                	add	a5,a5,a1
    800008de:	8ff5                	and	a5,a5,a3
    800008e0:	00f76863          	bltu	a4,a5,800008f0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e4:	8526                	mv	a0,s1
    800008e6:	60e2                	ld	ra,24(sp)
    800008e8:	6442                	ld	s0,16(sp)
    800008ea:	64a2                	ld	s1,8(sp)
    800008ec:	6105                	addi	sp,sp,32
    800008ee:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f0:	8f99                	sub	a5,a5,a4
    800008f2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f4:	4685                	li	a3,1
    800008f6:	0007861b          	sext.w	a2,a5
    800008fa:	85ba                	mv	a1,a4
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	e4e080e7          	jalr	-434(ra) # 8000074a <uvmunmap>
    80000904:	b7c5                	j	800008e4 <uvmdealloc+0x26>

0000000080000906 <uvmalloc>:
  if(newsz < oldsz)
    80000906:	0ab66563          	bltu	a2,a1,800009b0 <uvmalloc+0xaa>
{
    8000090a:	7139                	addi	sp,sp,-64
    8000090c:	fc06                	sd	ra,56(sp)
    8000090e:	f822                	sd	s0,48(sp)
    80000910:	ec4e                	sd	s3,24(sp)
    80000912:	e852                	sd	s4,16(sp)
    80000914:	e456                	sd	s5,8(sp)
    80000916:	0080                	addi	s0,sp,64
    80000918:	8aaa                	mv	s5,a0
    8000091a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091c:	6785                	lui	a5,0x1
    8000091e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000920:	95be                	add	a1,a1,a5
    80000922:	77fd                	lui	a5,0xfffff
    80000924:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000928:	08c9f663          	bgeu	s3,a2,800009b4 <uvmalloc+0xae>
    8000092c:	f426                	sd	s1,40(sp)
    8000092e:	f04a                	sd	s2,32(sp)
    80000930:	894e                	mv	s2,s3
    mem = kalloc();
    80000932:	fffff097          	auipc	ra,0xfffff
    80000936:	7e8080e7          	jalr	2024(ra) # 8000011a <kalloc>
    8000093a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093c:	c90d                	beqz	a0,8000096e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    8000093e:	6605                	lui	a2,0x1
    80000940:	4581                	li	a1,0
    80000942:	00000097          	auipc	ra,0x0
    80000946:	882080e7          	jalr	-1918(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000094a:	4779                	li	a4,30
    8000094c:	86a6                	mv	a3,s1
    8000094e:	6605                	lui	a2,0x1
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	c30080e7          	jalr	-976(ra) # 80000584 <mappages>
    8000095c:	e915                	bnez	a0,80000990 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095e:	6785                	lui	a5,0x1
    80000960:	993e                	add	s2,s2,a5
    80000962:	fd4968e3          	bltu	s2,s4,80000932 <uvmalloc+0x2c>
  return newsz;
    80000966:	8552                	mv	a0,s4
    80000968:	74a2                	ld	s1,40(sp)
    8000096a:	7902                	ld	s2,32(sp)
    8000096c:	a819                	j	80000982 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000096e:	864e                	mv	a2,s3
    80000970:	85ca                	mv	a1,s2
    80000972:	8556                	mv	a0,s5
    80000974:	00000097          	auipc	ra,0x0
    80000978:	f4a080e7          	jalr	-182(ra) # 800008be <uvmdealloc>
      return 0;
    8000097c:	4501                	li	a0,0
    8000097e:	74a2                	ld	s1,40(sp)
    80000980:	7902                	ld	s2,32(sp)
}
    80000982:	70e2                	ld	ra,56(sp)
    80000984:	7442                	ld	s0,48(sp)
    80000986:	69e2                	ld	s3,24(sp)
    80000988:	6a42                	ld	s4,16(sp)
    8000098a:	6aa2                	ld	s5,8(sp)
    8000098c:	6121                	addi	sp,sp,64
    8000098e:	8082                	ret
      kfree(mem);
    80000990:	8526                	mv	a0,s1
    80000992:	fffff097          	auipc	ra,0xfffff
    80000996:	68a080e7          	jalr	1674(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000099a:	864e                	mv	a2,s3
    8000099c:	85ca                	mv	a1,s2
    8000099e:	8556                	mv	a0,s5
    800009a0:	00000097          	auipc	ra,0x0
    800009a4:	f1e080e7          	jalr	-226(ra) # 800008be <uvmdealloc>
      return 0;
    800009a8:	4501                	li	a0,0
    800009aa:	74a2                	ld	s1,40(sp)
    800009ac:	7902                	ld	s2,32(sp)
    800009ae:	bfd1                	j	80000982 <uvmalloc+0x7c>
    return oldsz;
    800009b0:	852e                	mv	a0,a1
}
    800009b2:	8082                	ret
  return newsz;
    800009b4:	8532                	mv	a0,a2
    800009b6:	b7f1                	j	80000982 <uvmalloc+0x7c>

00000000800009b8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b8:	7179                	addi	sp,sp,-48
    800009ba:	f406                	sd	ra,40(sp)
    800009bc:	f022                	sd	s0,32(sp)
    800009be:	ec26                	sd	s1,24(sp)
    800009c0:	e84a                	sd	s2,16(sp)
    800009c2:	e44e                	sd	s3,8(sp)
    800009c4:	e052                	sd	s4,0(sp)
    800009c6:	1800                	addi	s0,sp,48
    800009c8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009ca:	84aa                	mv	s1,a0
    800009cc:	6905                	lui	s2,0x1
    800009ce:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d0:	4985                	li	s3,1
    800009d2:	a829                	j	800009ec <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009d6:	00c79513          	slli	a0,a5,0xc
    800009da:	00000097          	auipc	ra,0x0
    800009de:	fde080e7          	jalr	-34(ra) # 800009b8 <freewalk>
      pagetable[i] = 0;
    800009e2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e6:	04a1                	addi	s1,s1,8
    800009e8:	03248163          	beq	s1,s2,80000a0a <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009ec:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ee:	00f7f713          	andi	a4,a5,15
    800009f2:	ff3701e3          	beq	a4,s3,800009d4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f6:	8b85                	andi	a5,a5,1
    800009f8:	d7fd                	beqz	a5,800009e6 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009fa:	00007517          	auipc	a0,0x7
    800009fe:	6fe50513          	addi	a0,a0,1790 # 800080f8 <etext+0xf8>
    80000a02:	00005097          	auipc	ra,0x5
    80000a06:	36a080e7          	jalr	874(ra) # 80005d6c <panic>
    }
  }
  kfree((void*)pagetable);
    80000a0a:	8552                	mv	a0,s4
    80000a0c:	fffff097          	auipc	ra,0xfffff
    80000a10:	610080e7          	jalr	1552(ra) # 8000001c <kfree>
}
    80000a14:	70a2                	ld	ra,40(sp)
    80000a16:	7402                	ld	s0,32(sp)
    80000a18:	64e2                	ld	s1,24(sp)
    80000a1a:	6942                	ld	s2,16(sp)
    80000a1c:	69a2                	ld	s3,8(sp)
    80000a1e:	6a02                	ld	s4,0(sp)
    80000a20:	6145                	addi	sp,sp,48
    80000a22:	8082                	ret

0000000080000a24 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a24:	1101                	addi	sp,sp,-32
    80000a26:	ec06                	sd	ra,24(sp)
    80000a28:	e822                	sd	s0,16(sp)
    80000a2a:	e426                	sd	s1,8(sp)
    80000a2c:	1000                	addi	s0,sp,32
    80000a2e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a30:	e999                	bnez	a1,80000a46 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a32:	8526                	mv	a0,s1
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	f84080e7          	jalr	-124(ra) # 800009b8 <freewalk>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6105                	addi	sp,sp,32
    80000a44:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a46:	6785                	lui	a5,0x1
    80000a48:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a4a:	95be                	add	a1,a1,a5
    80000a4c:	4685                	li	a3,1
    80000a4e:	00c5d613          	srli	a2,a1,0xc
    80000a52:	4581                	li	a1,0
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	cf6080e7          	jalr	-778(ra) # 8000074a <uvmunmap>
    80000a5c:	bfd9                	j	80000a32 <uvmfree+0xe>

0000000080000a5e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a5e:	c679                	beqz	a2,80000b2c <uvmcopy+0xce>
{
    80000a60:	715d                	addi	sp,sp,-80
    80000a62:	e486                	sd	ra,72(sp)
    80000a64:	e0a2                	sd	s0,64(sp)
    80000a66:	fc26                	sd	s1,56(sp)
    80000a68:	f84a                	sd	s2,48(sp)
    80000a6a:	f44e                	sd	s3,40(sp)
    80000a6c:	f052                	sd	s4,32(sp)
    80000a6e:	ec56                	sd	s5,24(sp)
    80000a70:	e85a                	sd	s6,16(sp)
    80000a72:	e45e                	sd	s7,8(sp)
    80000a74:	0880                	addi	s0,sp,80
    80000a76:	8b2a                	mv	s6,a0
    80000a78:	8aae                	mv	s5,a1
    80000a7a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a7c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a7e:	4601                	li	a2,0
    80000a80:	85ce                	mv	a1,s3
    80000a82:	855a                	mv	a0,s6
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	a18080e7          	jalr	-1512(ra) # 8000049c <walk>
    80000a8c:	c531                	beqz	a0,80000ad8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a8e:	6118                	ld	a4,0(a0)
    80000a90:	00177793          	andi	a5,a4,1
    80000a94:	cbb1                	beqz	a5,80000ae8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a96:	00a75593          	srli	a1,a4,0xa
    80000a9a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a9e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	678080e7          	jalr	1656(ra) # 8000011a <kalloc>
    80000aaa:	892a                	mv	s2,a0
    80000aac:	c939                	beqz	a0,80000b02 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aae:	6605                	lui	a2,0x1
    80000ab0:	85de                	mv	a1,s7
    80000ab2:	fffff097          	auipc	ra,0xfffff
    80000ab6:	76e080e7          	jalr	1902(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aba:	8726                	mv	a4,s1
    80000abc:	86ca                	mv	a3,s2
    80000abe:	6605                	lui	a2,0x1
    80000ac0:	85ce                	mv	a1,s3
    80000ac2:	8556                	mv	a0,s5
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	ac0080e7          	jalr	-1344(ra) # 80000584 <mappages>
    80000acc:	e515                	bnez	a0,80000af8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ace:	6785                	lui	a5,0x1
    80000ad0:	99be                	add	s3,s3,a5
    80000ad2:	fb49e6e3          	bltu	s3,s4,80000a7e <uvmcopy+0x20>
    80000ad6:	a081                	j	80000b16 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad8:	00007517          	auipc	a0,0x7
    80000adc:	63050513          	addi	a0,a0,1584 # 80008108 <etext+0x108>
    80000ae0:	00005097          	auipc	ra,0x5
    80000ae4:	28c080e7          	jalr	652(ra) # 80005d6c <panic>
      panic("uvmcopy: page not present");
    80000ae8:	00007517          	auipc	a0,0x7
    80000aec:	64050513          	addi	a0,a0,1600 # 80008128 <etext+0x128>
    80000af0:	00005097          	auipc	ra,0x5
    80000af4:	27c080e7          	jalr	636(ra) # 80005d6c <panic>
      kfree(mem);
    80000af8:	854a                	mv	a0,s2
    80000afa:	fffff097          	auipc	ra,0xfffff
    80000afe:	522080e7          	jalr	1314(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b02:	4685                	li	a3,1
    80000b04:	00c9d613          	srli	a2,s3,0xc
    80000b08:	4581                	li	a1,0
    80000b0a:	8556                	mv	a0,s5
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	c3e080e7          	jalr	-962(ra) # 8000074a <uvmunmap>
  return -1;
    80000b14:	557d                	li	a0,-1
}
    80000b16:	60a6                	ld	ra,72(sp)
    80000b18:	6406                	ld	s0,64(sp)
    80000b1a:	74e2                	ld	s1,56(sp)
    80000b1c:	7942                	ld	s2,48(sp)
    80000b1e:	79a2                	ld	s3,40(sp)
    80000b20:	7a02                	ld	s4,32(sp)
    80000b22:	6ae2                	ld	s5,24(sp)
    80000b24:	6b42                	ld	s6,16(sp)
    80000b26:	6ba2                	ld	s7,8(sp)
    80000b28:	6161                	addi	sp,sp,80
    80000b2a:	8082                	ret
  return 0;
    80000b2c:	4501                	li	a0,0
}
    80000b2e:	8082                	ret

0000000080000b30 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b30:	1141                	addi	sp,sp,-16
    80000b32:	e406                	sd	ra,8(sp)
    80000b34:	e022                	sd	s0,0(sp)
    80000b36:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b38:	4601                	li	a2,0
    80000b3a:	00000097          	auipc	ra,0x0
    80000b3e:	962080e7          	jalr	-1694(ra) # 8000049c <walk>
  if(pte == 0)
    80000b42:	c901                	beqz	a0,80000b52 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b44:	611c                	ld	a5,0(a0)
    80000b46:	9bbd                	andi	a5,a5,-17
    80000b48:	e11c                	sd	a5,0(a0)
}
    80000b4a:	60a2                	ld	ra,8(sp)
    80000b4c:	6402                	ld	s0,0(sp)
    80000b4e:	0141                	addi	sp,sp,16
    80000b50:	8082                	ret
    panic("uvmclear");
    80000b52:	00007517          	auipc	a0,0x7
    80000b56:	5f650513          	addi	a0,a0,1526 # 80008148 <etext+0x148>
    80000b5a:	00005097          	auipc	ra,0x5
    80000b5e:	212080e7          	jalr	530(ra) # 80005d6c <panic>

0000000080000b62 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b62:	c6bd                	beqz	a3,80000bd0 <copyout+0x6e>
{
    80000b64:	715d                	addi	sp,sp,-80
    80000b66:	e486                	sd	ra,72(sp)
    80000b68:	e0a2                	sd	s0,64(sp)
    80000b6a:	fc26                	sd	s1,56(sp)
    80000b6c:	f84a                	sd	s2,48(sp)
    80000b6e:	f44e                	sd	s3,40(sp)
    80000b70:	f052                	sd	s4,32(sp)
    80000b72:	ec56                	sd	s5,24(sp)
    80000b74:	e85a                	sd	s6,16(sp)
    80000b76:	e45e                	sd	s7,8(sp)
    80000b78:	e062                	sd	s8,0(sp)
    80000b7a:	0880                	addi	s0,sp,80
    80000b7c:	8b2a                	mv	s6,a0
    80000b7e:	8c2e                	mv	s8,a1
    80000b80:	8a32                	mv	s4,a2
    80000b82:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b84:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b86:	6a85                	lui	s5,0x1
    80000b88:	a015                	j	80000bac <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8a:	9562                	add	a0,a0,s8
    80000b8c:	0004861b          	sext.w	a2,s1
    80000b90:	85d2                	mv	a1,s4
    80000b92:	41250533          	sub	a0,a0,s2
    80000b96:	fffff097          	auipc	ra,0xfffff
    80000b9a:	68a080e7          	jalr	1674(ra) # 80000220 <memmove>

    len -= n;
    80000b9e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000ba2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000ba4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba8:	02098263          	beqz	s3,80000bcc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bac:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bb0:	85ca                	mv	a1,s2
    80000bb2:	855a                	mv	a0,s6
    80000bb4:	00000097          	auipc	ra,0x0
    80000bb8:	98e080e7          	jalr	-1650(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000bbc:	cd01                	beqz	a0,80000bd4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bbe:	418904b3          	sub	s1,s2,s8
    80000bc2:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bc4:	fc99f3e3          	bgeu	s3,s1,80000b8a <copyout+0x28>
    80000bc8:	84ce                	mv	s1,s3
    80000bca:	b7c1                	j	80000b8a <copyout+0x28>
  }
  return 0;
    80000bcc:	4501                	li	a0,0
    80000bce:	a021                	j	80000bd6 <copyout+0x74>
    80000bd0:	4501                	li	a0,0
}
    80000bd2:	8082                	ret
      return -1;
    80000bd4:	557d                	li	a0,-1
}
    80000bd6:	60a6                	ld	ra,72(sp)
    80000bd8:	6406                	ld	s0,64(sp)
    80000bda:	74e2                	ld	s1,56(sp)
    80000bdc:	7942                	ld	s2,48(sp)
    80000bde:	79a2                	ld	s3,40(sp)
    80000be0:	7a02                	ld	s4,32(sp)
    80000be2:	6ae2                	ld	s5,24(sp)
    80000be4:	6b42                	ld	s6,16(sp)
    80000be6:	6ba2                	ld	s7,8(sp)
    80000be8:	6c02                	ld	s8,0(sp)
    80000bea:	6161                	addi	sp,sp,80
    80000bec:	8082                	ret

0000000080000bee <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bee:	caa5                	beqz	a3,80000c5e <copyin+0x70>
{
    80000bf0:	715d                	addi	sp,sp,-80
    80000bf2:	e486                	sd	ra,72(sp)
    80000bf4:	e0a2                	sd	s0,64(sp)
    80000bf6:	fc26                	sd	s1,56(sp)
    80000bf8:	f84a                	sd	s2,48(sp)
    80000bfa:	f44e                	sd	s3,40(sp)
    80000bfc:	f052                	sd	s4,32(sp)
    80000bfe:	ec56                	sd	s5,24(sp)
    80000c00:	e85a                	sd	s6,16(sp)
    80000c02:	e45e                	sd	s7,8(sp)
    80000c04:	e062                	sd	s8,0(sp)
    80000c06:	0880                	addi	s0,sp,80
    80000c08:	8b2a                	mv	s6,a0
    80000c0a:	8a2e                	mv	s4,a1
    80000c0c:	8c32                	mv	s8,a2
    80000c0e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c10:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c12:	6a85                	lui	s5,0x1
    80000c14:	a01d                	j	80000c3a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c16:	018505b3          	add	a1,a0,s8
    80000c1a:	0004861b          	sext.w	a2,s1
    80000c1e:	412585b3          	sub	a1,a1,s2
    80000c22:	8552                	mv	a0,s4
    80000c24:	fffff097          	auipc	ra,0xfffff
    80000c28:	5fc080e7          	jalr	1532(ra) # 80000220 <memmove>

    len -= n;
    80000c2c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c30:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c32:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c36:	02098263          	beqz	s3,80000c5a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c3a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c3e:	85ca                	mv	a1,s2
    80000c40:	855a                	mv	a0,s6
    80000c42:	00000097          	auipc	ra,0x0
    80000c46:	900080e7          	jalr	-1792(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000c4a:	cd01                	beqz	a0,80000c62 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c4c:	418904b3          	sub	s1,s2,s8
    80000c50:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c52:	fc99f2e3          	bgeu	s3,s1,80000c16 <copyin+0x28>
    80000c56:	84ce                	mv	s1,s3
    80000c58:	bf7d                	j	80000c16 <copyin+0x28>
  }
  return 0;
    80000c5a:	4501                	li	a0,0
    80000c5c:	a021                	j	80000c64 <copyin+0x76>
    80000c5e:	4501                	li	a0,0
}
    80000c60:	8082                	ret
      return -1;
    80000c62:	557d                	li	a0,-1
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
    80000c76:	6c02                	ld	s8,0(sp)
    80000c78:	6161                	addi	sp,sp,80
    80000c7a:	8082                	ret

0000000080000c7c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c7c:	cacd                	beqz	a3,80000d2e <copyinstr+0xb2>
{
    80000c7e:	715d                	addi	sp,sp,-80
    80000c80:	e486                	sd	ra,72(sp)
    80000c82:	e0a2                	sd	s0,64(sp)
    80000c84:	fc26                	sd	s1,56(sp)
    80000c86:	f84a                	sd	s2,48(sp)
    80000c88:	f44e                	sd	s3,40(sp)
    80000c8a:	f052                	sd	s4,32(sp)
    80000c8c:	ec56                	sd	s5,24(sp)
    80000c8e:	e85a                	sd	s6,16(sp)
    80000c90:	e45e                	sd	s7,8(sp)
    80000c92:	0880                	addi	s0,sp,80
    80000c94:	8a2a                	mv	s4,a0
    80000c96:	8b2e                	mv	s6,a1
    80000c98:	8bb2                	mv	s7,a2
    80000c9a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c9e:	6985                	lui	s3,0x1
    80000ca0:	a825                	j	80000cd8 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ca2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ca8:	37fd                	addiw	a5,a5,-1
    80000caa:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cae:	60a6                	ld	ra,72(sp)
    80000cb0:	6406                	ld	s0,64(sp)
    80000cb2:	74e2                	ld	s1,56(sp)
    80000cb4:	7942                	ld	s2,48(sp)
    80000cb6:	79a2                	ld	s3,40(sp)
    80000cb8:	7a02                	ld	s4,32(sp)
    80000cba:	6ae2                	ld	s5,24(sp)
    80000cbc:	6b42                	ld	s6,16(sp)
    80000cbe:	6ba2                	ld	s7,8(sp)
    80000cc0:	6161                	addi	sp,sp,80
    80000cc2:	8082                	ret
    80000cc4:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000cc8:	9742                	add	a4,a4,a6
      --max;
    80000cca:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000cce:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000cd2:	04e58663          	beq	a1,a4,80000d1e <copyinstr+0xa2>
{
    80000cd6:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000cd8:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cdc:	85a6                	mv	a1,s1
    80000cde:	8552                	mv	a0,s4
    80000ce0:	00000097          	auipc	ra,0x0
    80000ce4:	862080e7          	jalr	-1950(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000ce8:	cd0d                	beqz	a0,80000d22 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000cea:	417486b3          	sub	a3,s1,s7
    80000cee:	96ce                	add	a3,a3,s3
    if(n > max)
    80000cf0:	00d97363          	bgeu	s2,a3,80000cf6 <copyinstr+0x7a>
    80000cf4:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf6:	955e                	add	a0,a0,s7
    80000cf8:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000cfa:	c695                	beqz	a3,80000d26 <copyinstr+0xaa>
    80000cfc:	87da                	mv	a5,s6
    80000cfe:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d00:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d04:	96da                	add	a3,a3,s6
    80000d06:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d08:	00f60733          	add	a4,a2,a5
    80000d0c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000d10:	db49                	beqz	a4,80000ca2 <copyinstr+0x26>
        *dst = *p;
    80000d12:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d16:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d18:	fed797e3          	bne	a5,a3,80000d06 <copyinstr+0x8a>
    80000d1c:	b765                	j	80000cc4 <copyinstr+0x48>
    80000d1e:	4781                	li	a5,0
    80000d20:	b761                	j	80000ca8 <copyinstr+0x2c>
      return -1;
    80000d22:	557d                	li	a0,-1
    80000d24:	b769                	j	80000cae <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000d26:	6b85                	lui	s7,0x1
    80000d28:	9ba6                	add	s7,s7,s1
    80000d2a:	87da                	mv	a5,s6
    80000d2c:	b76d                	j	80000cd6 <copyinstr+0x5a>
  int got_null = 0;
    80000d2e:	4781                	li	a5,0
  if(got_null){
    80000d30:	37fd                	addiw	a5,a5,-1
    80000d32:	0007851b          	sext.w	a0,a5
}
    80000d36:	8082                	ret

0000000080000d38 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d38:	7139                	addi	sp,sp,-64
    80000d3a:	fc06                	sd	ra,56(sp)
    80000d3c:	f822                	sd	s0,48(sp)
    80000d3e:	f426                	sd	s1,40(sp)
    80000d40:	f04a                	sd	s2,32(sp)
    80000d42:	ec4e                	sd	s3,24(sp)
    80000d44:	e852                	sd	s4,16(sp)
    80000d46:	e456                	sd	s5,8(sp)
    80000d48:	e05a                	sd	s6,0(sp)
    80000d4a:	0080                	addi	s0,sp,64
    80000d4c:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4e:	00008497          	auipc	s1,0x8
    80000d52:	73248493          	addi	s1,s1,1842 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d56:	8b26                	mv	s6,s1
    80000d58:	ff4df937          	lui	s2,0xff4df
    80000d5c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000d60:	0936                	slli	s2,s2,0xd
    80000d62:	6f590913          	addi	s2,s2,1781
    80000d66:	0936                	slli	s2,s2,0xd
    80000d68:	bd390913          	addi	s2,s2,-1069
    80000d6c:	0932                	slli	s2,s2,0xc
    80000d6e:	7a790913          	addi	s2,s2,1959
    80000d72:	040009b7          	lui	s3,0x4000
    80000d76:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d78:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d7a:	0000ea97          	auipc	s5,0xe
    80000d7e:	306a8a93          	addi	s5,s5,774 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d82:	fffff097          	auipc	ra,0xfffff
    80000d86:	398080e7          	jalr	920(ra) # 8000011a <kalloc>
    80000d8a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d8c:	c121                	beqz	a0,80000dcc <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d8e:	416485b3          	sub	a1,s1,s6
    80000d92:	8591                	srai	a1,a1,0x4
    80000d94:	032585b3          	mul	a1,a1,s2
    80000d98:	2585                	addiw	a1,a1,1
    80000d9a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d9e:	4719                	li	a4,6
    80000da0:	6685                	lui	a3,0x1
    80000da2:	40b985b3          	sub	a1,s3,a1
    80000da6:	8552                	mv	a0,s4
    80000da8:	00000097          	auipc	ra,0x0
    80000dac:	87c080e7          	jalr	-1924(ra) # 80000624 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	17048493          	addi	s1,s1,368
    80000db4:	fd5497e3          	bne	s1,s5,80000d82 <proc_mapstacks+0x4a>
  }
}
    80000db8:	70e2                	ld	ra,56(sp)
    80000dba:	7442                	ld	s0,48(sp)
    80000dbc:	74a2                	ld	s1,40(sp)
    80000dbe:	7902                	ld	s2,32(sp)
    80000dc0:	69e2                	ld	s3,24(sp)
    80000dc2:	6a42                	ld	s4,16(sp)
    80000dc4:	6aa2                	ld	s5,8(sp)
    80000dc6:	6b02                	ld	s6,0(sp)
    80000dc8:	6121                	addi	sp,sp,64
    80000dca:	8082                	ret
      panic("kalloc");
    80000dcc:	00007517          	auipc	a0,0x7
    80000dd0:	38c50513          	addi	a0,a0,908 # 80008158 <etext+0x158>
    80000dd4:	00005097          	auipc	ra,0x5
    80000dd8:	f98080e7          	jalr	-104(ra) # 80005d6c <panic>

0000000080000ddc <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000ddc:	7139                	addi	sp,sp,-64
    80000dde:	fc06                	sd	ra,56(sp)
    80000de0:	f822                	sd	s0,48(sp)
    80000de2:	f426                	sd	s1,40(sp)
    80000de4:	f04a                	sd	s2,32(sp)
    80000de6:	ec4e                	sd	s3,24(sp)
    80000de8:	e852                	sd	s4,16(sp)
    80000dea:	e456                	sd	s5,8(sp)
    80000dec:	e05a                	sd	s6,0(sp)
    80000dee:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000df0:	00007597          	auipc	a1,0x7
    80000df4:	37058593          	addi	a1,a1,880 # 80008160 <etext+0x160>
    80000df8:	00008517          	auipc	a0,0x8
    80000dfc:	25850513          	addi	a0,a0,600 # 80009050 <pid_lock>
    80000e00:	00005097          	auipc	ra,0x5
    80000e04:	456080e7          	jalr	1110(ra) # 80006256 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e08:	00007597          	auipc	a1,0x7
    80000e0c:	36058593          	addi	a1,a1,864 # 80008168 <etext+0x168>
    80000e10:	00008517          	auipc	a0,0x8
    80000e14:	25850513          	addi	a0,a0,600 # 80009068 <wait_lock>
    80000e18:	00005097          	auipc	ra,0x5
    80000e1c:	43e080e7          	jalr	1086(ra) # 80006256 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e20:	00008497          	auipc	s1,0x8
    80000e24:	66048493          	addi	s1,s1,1632 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e28:	00007b17          	auipc	s6,0x7
    80000e2c:	350b0b13          	addi	s6,s6,848 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e30:	8aa6                	mv	s5,s1
    80000e32:	ff4df937          	lui	s2,0xff4df
    80000e36:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000e3a:	0936                	slli	s2,s2,0xd
    80000e3c:	6f590913          	addi	s2,s2,1781
    80000e40:	0936                	slli	s2,s2,0xd
    80000e42:	bd390913          	addi	s2,s2,-1069
    80000e46:	0932                	slli	s2,s2,0xc
    80000e48:	7a790913          	addi	s2,s2,1959
    80000e4c:	040009b7          	lui	s3,0x4000
    80000e50:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e52:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e54:	0000ea17          	auipc	s4,0xe
    80000e58:	22ca0a13          	addi	s4,s4,556 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000e5c:	85da                	mv	a1,s6
    80000e5e:	8526                	mv	a0,s1
    80000e60:	00005097          	auipc	ra,0x5
    80000e64:	3f6080e7          	jalr	1014(ra) # 80006256 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e68:	415487b3          	sub	a5,s1,s5
    80000e6c:	8791                	srai	a5,a5,0x4
    80000e6e:	032787b3          	mul	a5,a5,s2
    80000e72:	2785                	addiw	a5,a5,1
    80000e74:	00d7979b          	slliw	a5,a5,0xd
    80000e78:	40f987b3          	sub	a5,s3,a5
    80000e7c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e7e:	17048493          	addi	s1,s1,368
    80000e82:	fd449de3          	bne	s1,s4,80000e5c <procinit+0x80>
  }
}
    80000e86:	70e2                	ld	ra,56(sp)
    80000e88:	7442                	ld	s0,48(sp)
    80000e8a:	74a2                	ld	s1,40(sp)
    80000e8c:	7902                	ld	s2,32(sp)
    80000e8e:	69e2                	ld	s3,24(sp)
    80000e90:	6a42                	ld	s4,16(sp)
    80000e92:	6aa2                	ld	s5,8(sp)
    80000e94:	6b02                	ld	s6,0(sp)
    80000e96:	6121                	addi	sp,sp,64
    80000e98:	8082                	ret

0000000080000e9a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e9a:	1141                	addi	sp,sp,-16
    80000e9c:	e422                	sd	s0,8(sp)
    80000e9e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ea0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ea2:	2501                	sext.w	a0,a0
    80000ea4:	6422                	ld	s0,8(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret

0000000080000eaa <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000eaa:	1141                	addi	sp,sp,-16
    80000eac:	e422                	sd	s0,8(sp)
    80000eae:	0800                	addi	s0,sp,16
    80000eb0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000eb2:	2781                	sext.w	a5,a5
    80000eb4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000eb6:	00008517          	auipc	a0,0x8
    80000eba:	1ca50513          	addi	a0,a0,458 # 80009080 <cpus>
    80000ebe:	953e                	add	a0,a0,a5
    80000ec0:	6422                	ld	s0,8(sp)
    80000ec2:	0141                	addi	sp,sp,16
    80000ec4:	8082                	ret

0000000080000ec6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	1000                	addi	s0,sp,32
  push_off();
    80000ed0:	00005097          	auipc	ra,0x5
    80000ed4:	3ca080e7          	jalr	970(ra) # 8000629a <push_off>
    80000ed8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eda:	2781                	sext.w	a5,a5
    80000edc:	079e                	slli	a5,a5,0x7
    80000ede:	00008717          	auipc	a4,0x8
    80000ee2:	17270713          	addi	a4,a4,370 # 80009050 <pid_lock>
    80000ee6:	97ba                	add	a5,a5,a4
    80000ee8:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eea:	00005097          	auipc	ra,0x5
    80000eee:	450080e7          	jalr	1104(ra) # 8000633a <pop_off>
  return p;
}
    80000ef2:	8526                	mv	a0,s1
    80000ef4:	60e2                	ld	ra,24(sp)
    80000ef6:	6442                	ld	s0,16(sp)
    80000ef8:	64a2                	ld	s1,8(sp)
    80000efa:	6105                	addi	sp,sp,32
    80000efc:	8082                	ret

0000000080000efe <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000efe:	1141                	addi	sp,sp,-16
    80000f00:	e406                	sd	ra,8(sp)
    80000f02:	e022                	sd	s0,0(sp)
    80000f04:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f06:	00000097          	auipc	ra,0x0
    80000f0a:	fc0080e7          	jalr	-64(ra) # 80000ec6 <myproc>
    80000f0e:	00005097          	auipc	ra,0x5
    80000f12:	48c080e7          	jalr	1164(ra) # 8000639a <release>

  if (first) {
    80000f16:	00008797          	auipc	a5,0x8
    80000f1a:	9ca7a783          	lw	a5,-1590(a5) # 800088e0 <first.1>
    80000f1e:	eb89                	bnez	a5,80000f30 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f20:	00001097          	auipc	ra,0x1
    80000f24:	c50080e7          	jalr	-944(ra) # 80001b70 <usertrapret>
}
    80000f28:	60a2                	ld	ra,8(sp)
    80000f2a:	6402                	ld	s0,0(sp)
    80000f2c:	0141                	addi	sp,sp,16
    80000f2e:	8082                	ret
    first = 0;
    80000f30:	00008797          	auipc	a5,0x8
    80000f34:	9a07a823          	sw	zero,-1616(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80000f38:	4505                	li	a0,1
    80000f3a:	00002097          	auipc	ra,0x2
    80000f3e:	a52080e7          	jalr	-1454(ra) # 8000298c <fsinit>
    80000f42:	bff9                	j	80000f20 <forkret+0x22>

0000000080000f44 <allocpid>:
allocpid() {
    80000f44:	1101                	addi	sp,sp,-32
    80000f46:	ec06                	sd	ra,24(sp)
    80000f48:	e822                	sd	s0,16(sp)
    80000f4a:	e426                	sd	s1,8(sp)
    80000f4c:	e04a                	sd	s2,0(sp)
    80000f4e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f50:	00008917          	auipc	s2,0x8
    80000f54:	10090913          	addi	s2,s2,256 # 80009050 <pid_lock>
    80000f58:	854a                	mv	a0,s2
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	38c080e7          	jalr	908(ra) # 800062e6 <acquire>
  pid = nextpid;
    80000f62:	00008797          	auipc	a5,0x8
    80000f66:	98278793          	addi	a5,a5,-1662 # 800088e4 <nextpid>
    80000f6a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f6c:	0014871b          	addiw	a4,s1,1
    80000f70:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f72:	854a                	mv	a0,s2
    80000f74:	00005097          	auipc	ra,0x5
    80000f78:	426080e7          	jalr	1062(ra) # 8000639a <release>
}
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	60e2                	ld	ra,24(sp)
    80000f80:	6442                	ld	s0,16(sp)
    80000f82:	64a2                	ld	s1,8(sp)
    80000f84:	6902                	ld	s2,0(sp)
    80000f86:	6105                	addi	sp,sp,32
    80000f88:	8082                	ret

0000000080000f8a <proc_pagetable>:
{
    80000f8a:	1101                	addi	sp,sp,-32
    80000f8c:	ec06                	sd	ra,24(sp)
    80000f8e:	e822                	sd	s0,16(sp)
    80000f90:	e426                	sd	s1,8(sp)
    80000f92:	e04a                	sd	s2,0(sp)
    80000f94:	1000                	addi	s0,sp,32
    80000f96:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	886080e7          	jalr	-1914(ra) # 8000081e <uvmcreate>
    80000fa0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fa2:	c121                	beqz	a0,80000fe2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fa4:	4729                	li	a4,10
    80000fa6:	00006697          	auipc	a3,0x6
    80000faa:	05a68693          	addi	a3,a3,90 # 80007000 <_trampoline>
    80000fae:	6605                	lui	a2,0x1
    80000fb0:	040005b7          	lui	a1,0x4000
    80000fb4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb6:	05b2                	slli	a1,a1,0xc
    80000fb8:	fffff097          	auipc	ra,0xfffff
    80000fbc:	5cc080e7          	jalr	1484(ra) # 80000584 <mappages>
    80000fc0:	02054863          	bltz	a0,80000ff0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fc4:	4719                	li	a4,6
    80000fc6:	05893683          	ld	a3,88(s2)
    80000fca:	6605                	lui	a2,0x1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	5ae080e7          	jalr	1454(ra) # 80000584 <mappages>
    80000fde:	02054163          	bltz	a0,80001000 <proc_pagetable+0x76>
}
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6902                	ld	s2,0(sp)
    80000fec:	6105                	addi	sp,sp,32
    80000fee:	8082                	ret
    uvmfree(pagetable, 0);
    80000ff0:	4581                	li	a1,0
    80000ff2:	8526                	mv	a0,s1
    80000ff4:	00000097          	auipc	ra,0x0
    80000ff8:	a30080e7          	jalr	-1488(ra) # 80000a24 <uvmfree>
    return 0;
    80000ffc:	4481                	li	s1,0
    80000ffe:	b7d5                	j	80000fe2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	040005b7          	lui	a1,0x4000
    80001008:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000100a:	05b2                	slli	a1,a1,0xc
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	73c080e7          	jalr	1852(ra) # 8000074a <uvmunmap>
    uvmfree(pagetable, 0);
    80001016:	4581                	li	a1,0
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	a0a080e7          	jalr	-1526(ra) # 80000a24 <uvmfree>
    return 0;
    80001022:	4481                	li	s1,0
    80001024:	bf7d                	j	80000fe2 <proc_pagetable+0x58>

0000000080001026 <proc_freepagetable>:
{
    80001026:	1101                	addi	sp,sp,-32
    80001028:	ec06                	sd	ra,24(sp)
    8000102a:	e822                	sd	s0,16(sp)
    8000102c:	e426                	sd	s1,8(sp)
    8000102e:	e04a                	sd	s2,0(sp)
    80001030:	1000                	addi	s0,sp,32
    80001032:	84aa                	mv	s1,a0
    80001034:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001036:	4681                	li	a3,0
    80001038:	4605                	li	a2,1
    8000103a:	040005b7          	lui	a1,0x4000
    8000103e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001040:	05b2                	slli	a1,a1,0xc
    80001042:	fffff097          	auipc	ra,0xfffff
    80001046:	708080e7          	jalr	1800(ra) # 8000074a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000104a:	4681                	li	a3,0
    8000104c:	4605                	li	a2,1
    8000104e:	020005b7          	lui	a1,0x2000
    80001052:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001054:	05b6                	slli	a1,a1,0xd
    80001056:	8526                	mv	a0,s1
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	6f2080e7          	jalr	1778(ra) # 8000074a <uvmunmap>
  uvmfree(pagetable, sz);
    80001060:	85ca                	mv	a1,s2
    80001062:	8526                	mv	a0,s1
    80001064:	00000097          	auipc	ra,0x0
    80001068:	9c0080e7          	jalr	-1600(ra) # 80000a24 <uvmfree>
}
    8000106c:	60e2                	ld	ra,24(sp)
    8000106e:	6442                	ld	s0,16(sp)
    80001070:	64a2                	ld	s1,8(sp)
    80001072:	6902                	ld	s2,0(sp)
    80001074:	6105                	addi	sp,sp,32
    80001076:	8082                	ret

0000000080001078 <freeproc>:
{
    80001078:	1101                	addi	sp,sp,-32
    8000107a:	ec06                	sd	ra,24(sp)
    8000107c:	e822                	sd	s0,16(sp)
    8000107e:	e426                	sd	s1,8(sp)
    80001080:	1000                	addi	s0,sp,32
    80001082:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001084:	6d28                	ld	a0,88(a0)
    80001086:	c509                	beqz	a0,80001090 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001088:	fffff097          	auipc	ra,0xfffff
    8000108c:	f94080e7          	jalr	-108(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001090:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001094:	68a8                	ld	a0,80(s1)
    80001096:	c511                	beqz	a0,800010a2 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001098:	64ac                	ld	a1,72(s1)
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	f8c080e7          	jalr	-116(ra) # 80001026 <proc_freepagetable>
  p->pagetable = 0;
    800010a2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010a6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010aa:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010ae:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010b2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010b6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010ba:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010be:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010c2:	0004ac23          	sw	zero,24(s1)
}
    800010c6:	60e2                	ld	ra,24(sp)
    800010c8:	6442                	ld	s0,16(sp)
    800010ca:	64a2                	ld	s1,8(sp)
    800010cc:	6105                	addi	sp,sp,32
    800010ce:	8082                	ret

00000000800010d0 <allocproc>:
{
    800010d0:	1101                	addi	sp,sp,-32
    800010d2:	ec06                	sd	ra,24(sp)
    800010d4:	e822                	sd	s0,16(sp)
    800010d6:	e426                	sd	s1,8(sp)
    800010d8:	e04a                	sd	s2,0(sp)
    800010da:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010dc:	00008497          	auipc	s1,0x8
    800010e0:	3a448493          	addi	s1,s1,932 # 80009480 <proc>
    800010e4:	0000e917          	auipc	s2,0xe
    800010e8:	f9c90913          	addi	s2,s2,-100 # 8000f080 <tickslock>
    acquire(&p->lock);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00005097          	auipc	ra,0x5
    800010f2:	1f8080e7          	jalr	504(ra) # 800062e6 <acquire>
    if(p->state == UNUSED) {
    800010f6:	4c9c                	lw	a5,24(s1)
    800010f8:	cf81                	beqz	a5,80001110 <allocproc+0x40>
      release(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	29e080e7          	jalr	670(ra) # 8000639a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001104:	17048493          	addi	s1,s1,368
    80001108:	ff2492e3          	bne	s1,s2,800010ec <allocproc+0x1c>
  return 0;
    8000110c:	4481                	li	s1,0
    8000110e:	a899                	j	80001164 <allocproc+0x94>
  p->pid = allocpid();
    80001110:	00000097          	auipc	ra,0x0
    80001114:	e34080e7          	jalr	-460(ra) # 80000f44 <allocpid>
    80001118:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000111a:	4785                	li	a5,1
    8000111c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000111e:	fffff097          	auipc	ra,0xfffff
    80001122:	ffc080e7          	jalr	-4(ra) # 8000011a <kalloc>
    80001126:	892a                	mv	s2,a0
    80001128:	eca8                	sd	a0,88(s1)
    8000112a:	c521                	beqz	a0,80001172 <allocproc+0xa2>
  p->pagetable = proc_pagetable(p);
    8000112c:	8526                	mv	a0,s1
    8000112e:	00000097          	auipc	ra,0x0
    80001132:	e5c080e7          	jalr	-420(ra) # 80000f8a <proc_pagetable>
    80001136:	892a                	mv	s2,a0
    80001138:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000113a:	c921                	beqz	a0,8000118a <allocproc+0xba>
  memset(&p->context, 0, sizeof(p->context));
    8000113c:	07000613          	li	a2,112
    80001140:	4581                	li	a1,0
    80001142:	06048513          	addi	a0,s1,96
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	07e080e7          	jalr	126(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    8000114e:	00000797          	auipc	a5,0x0
    80001152:	db078793          	addi	a5,a5,-592 # 80000efe <forkret>
    80001156:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001158:	60bc                	ld	a5,64(s1)
    8000115a:	6705                	lui	a4,0x1
    8000115c:	97ba                	add	a5,a5,a4
    8000115e:	f4bc                	sd	a5,104(s1)
  p->syscall_trace = 0; //syscall_trace init with 0
    80001160:	1604b423          	sd	zero,360(s1)
}
    80001164:	8526                	mv	a0,s1
    80001166:	60e2                	ld	ra,24(sp)
    80001168:	6442                	ld	s0,16(sp)
    8000116a:	64a2                	ld	s1,8(sp)
    8000116c:	6902                	ld	s2,0(sp)
    8000116e:	6105                	addi	sp,sp,32
    80001170:	8082                	ret
    freeproc(p);
    80001172:	8526                	mv	a0,s1
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f04080e7          	jalr	-252(ra) # 80001078 <freeproc>
    release(&p->lock);
    8000117c:	8526                	mv	a0,s1
    8000117e:	00005097          	auipc	ra,0x5
    80001182:	21c080e7          	jalr	540(ra) # 8000639a <release>
    return 0;
    80001186:	84ca                	mv	s1,s2
    80001188:	bff1                	j	80001164 <allocproc+0x94>
    freeproc(p);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00000097          	auipc	ra,0x0
    80001190:	eec080e7          	jalr	-276(ra) # 80001078 <freeproc>
    release(&p->lock);
    80001194:	8526                	mv	a0,s1
    80001196:	00005097          	auipc	ra,0x5
    8000119a:	204080e7          	jalr	516(ra) # 8000639a <release>
    return 0;
    8000119e:	84ca                	mv	s1,s2
    800011a0:	b7d1                	j	80001164 <allocproc+0x94>

00000000800011a2 <userinit>:
{
    800011a2:	1101                	addi	sp,sp,-32
    800011a4:	ec06                	sd	ra,24(sp)
    800011a6:	e822                	sd	s0,16(sp)
    800011a8:	e426                	sd	s1,8(sp)
    800011aa:	1000                	addi	s0,sp,32
  p = allocproc();
    800011ac:	00000097          	auipc	ra,0x0
    800011b0:	f24080e7          	jalr	-220(ra) # 800010d0 <allocproc>
    800011b4:	84aa                	mv	s1,a0
  initproc = p;
    800011b6:	00008797          	auipc	a5,0x8
    800011ba:	e4a7bd23          	sd	a0,-422(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800011be:	03400613          	li	a2,52
    800011c2:	00007597          	auipc	a1,0x7
    800011c6:	72e58593          	addi	a1,a1,1838 # 800088f0 <initcode>
    800011ca:	6928                	ld	a0,80(a0)
    800011cc:	fffff097          	auipc	ra,0xfffff
    800011d0:	680080e7          	jalr	1664(ra) # 8000084c <uvminit>
  p->sz = PGSIZE;
    800011d4:	6785                	lui	a5,0x1
    800011d6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011d8:	6cb8                	ld	a4,88(s1)
    800011da:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011de:	6cb8                	ld	a4,88(s1)
    800011e0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011e2:	4641                	li	a2,16
    800011e4:	00007597          	auipc	a1,0x7
    800011e8:	f9c58593          	addi	a1,a1,-100 # 80008180 <etext+0x180>
    800011ec:	15848513          	addi	a0,s1,344
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	116080e7          	jalr	278(ra) # 80000306 <safestrcpy>
  p->cwd = namei("/");
    800011f8:	00007517          	auipc	a0,0x7
    800011fc:	f9850513          	addi	a0,a0,-104 # 80008190 <etext+0x190>
    80001200:	00002097          	auipc	ra,0x2
    80001204:	1d2080e7          	jalr	466(ra) # 800033d2 <namei>
    80001208:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000120c:	478d                	li	a5,3
    8000120e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001210:	8526                	mv	a0,s1
    80001212:	00005097          	auipc	ra,0x5
    80001216:	188080e7          	jalr	392(ra) # 8000639a <release>
}
    8000121a:	60e2                	ld	ra,24(sp)
    8000121c:	6442                	ld	s0,16(sp)
    8000121e:	64a2                	ld	s1,8(sp)
    80001220:	6105                	addi	sp,sp,32
    80001222:	8082                	ret

0000000080001224 <growproc>:
{
    80001224:	1101                	addi	sp,sp,-32
    80001226:	ec06                	sd	ra,24(sp)
    80001228:	e822                	sd	s0,16(sp)
    8000122a:	e426                	sd	s1,8(sp)
    8000122c:	e04a                	sd	s2,0(sp)
    8000122e:	1000                	addi	s0,sp,32
    80001230:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001232:	00000097          	auipc	ra,0x0
    80001236:	c94080e7          	jalr	-876(ra) # 80000ec6 <myproc>
    8000123a:	892a                	mv	s2,a0
  sz = p->sz;
    8000123c:	652c                	ld	a1,72(a0)
    8000123e:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001242:	00904f63          	bgtz	s1,80001260 <growproc+0x3c>
  } else if(n < 0){
    80001246:	0204cd63          	bltz	s1,80001280 <growproc+0x5c>
  p->sz = sz;
    8000124a:	1782                	slli	a5,a5,0x20
    8000124c:	9381                	srli	a5,a5,0x20
    8000124e:	04f93423          	sd	a5,72(s2)
  return 0;
    80001252:	4501                	li	a0,0
}
    80001254:	60e2                	ld	ra,24(sp)
    80001256:	6442                	ld	s0,16(sp)
    80001258:	64a2                	ld	s1,8(sp)
    8000125a:	6902                	ld	s2,0(sp)
    8000125c:	6105                	addi	sp,sp,32
    8000125e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001260:	00f4863b          	addw	a2,s1,a5
    80001264:	1602                	slli	a2,a2,0x20
    80001266:	9201                	srli	a2,a2,0x20
    80001268:	1582                	slli	a1,a1,0x20
    8000126a:	9181                	srli	a1,a1,0x20
    8000126c:	6928                	ld	a0,80(a0)
    8000126e:	fffff097          	auipc	ra,0xfffff
    80001272:	698080e7          	jalr	1688(ra) # 80000906 <uvmalloc>
    80001276:	0005079b          	sext.w	a5,a0
    8000127a:	fbe1                	bnez	a5,8000124a <growproc+0x26>
      return -1;
    8000127c:	557d                	li	a0,-1
    8000127e:	bfd9                	j	80001254 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001280:	00f4863b          	addw	a2,s1,a5
    80001284:	1602                	slli	a2,a2,0x20
    80001286:	9201                	srli	a2,a2,0x20
    80001288:	1582                	slli	a1,a1,0x20
    8000128a:	9181                	srli	a1,a1,0x20
    8000128c:	6928                	ld	a0,80(a0)
    8000128e:	fffff097          	auipc	ra,0xfffff
    80001292:	630080e7          	jalr	1584(ra) # 800008be <uvmdealloc>
    80001296:	0005079b          	sext.w	a5,a0
    8000129a:	bf45                	j	8000124a <growproc+0x26>

000000008000129c <fork>:
{
    8000129c:	7139                	addi	sp,sp,-64
    8000129e:	fc06                	sd	ra,56(sp)
    800012a0:	f822                	sd	s0,48(sp)
    800012a2:	f04a                	sd	s2,32(sp)
    800012a4:	e456                	sd	s5,8(sp)
    800012a6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	c1e080e7          	jalr	-994(ra) # 80000ec6 <myproc>
    800012b0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	e1e080e7          	jalr	-482(ra) # 800010d0 <allocproc>
    800012ba:	12050463          	beqz	a0,800013e2 <fork+0x146>
    800012be:	ec4e                	sd	s3,24(sp)
    800012c0:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012c2:	048ab603          	ld	a2,72(s5)
    800012c6:	692c                	ld	a1,80(a0)
    800012c8:	050ab503          	ld	a0,80(s5)
    800012cc:	fffff097          	auipc	ra,0xfffff
    800012d0:	792080e7          	jalr	1938(ra) # 80000a5e <uvmcopy>
    800012d4:	04054a63          	bltz	a0,80001328 <fork+0x8c>
    800012d8:	f426                	sd	s1,40(sp)
    800012da:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800012dc:	048ab783          	ld	a5,72(s5)
    800012e0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012e4:	058ab683          	ld	a3,88(s5)
    800012e8:	87b6                	mv	a5,a3
    800012ea:	0589b703          	ld	a4,88(s3)
    800012ee:	12068693          	addi	a3,a3,288
    800012f2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012f6:	6788                	ld	a0,8(a5)
    800012f8:	6b8c                	ld	a1,16(a5)
    800012fa:	6f90                	ld	a2,24(a5)
    800012fc:	01073023          	sd	a6,0(a4)
    80001300:	e708                	sd	a0,8(a4)
    80001302:	eb0c                	sd	a1,16(a4)
    80001304:	ef10                	sd	a2,24(a4)
    80001306:	02078793          	addi	a5,a5,32
    8000130a:	02070713          	addi	a4,a4,32
    8000130e:	fed792e3          	bne	a5,a3,800012f2 <fork+0x56>
  np->trapframe->a0 = 0;
    80001312:	0589b783          	ld	a5,88(s3)
    80001316:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000131a:	0d0a8493          	addi	s1,s5,208
    8000131e:	0d098913          	addi	s2,s3,208
    80001322:	150a8a13          	addi	s4,s5,336
    80001326:	a015                	j	8000134a <fork+0xae>
    freeproc(np);
    80001328:	854e                	mv	a0,s3
    8000132a:	00000097          	auipc	ra,0x0
    8000132e:	d4e080e7          	jalr	-690(ra) # 80001078 <freeproc>
    release(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	066080e7          	jalr	102(ra) # 8000639a <release>
    return -1;
    8000133c:	597d                	li	s2,-1
    8000133e:	69e2                	ld	s3,24(sp)
    80001340:	a851                	j	800013d4 <fork+0x138>
  for(i = 0; i < NOFILE; i++)
    80001342:	04a1                	addi	s1,s1,8
    80001344:	0921                	addi	s2,s2,8
    80001346:	01448b63          	beq	s1,s4,8000135c <fork+0xc0>
    if(p->ofile[i])
    8000134a:	6088                	ld	a0,0(s1)
    8000134c:	d97d                	beqz	a0,80001342 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000134e:	00002097          	auipc	ra,0x2
    80001352:	6fc080e7          	jalr	1788(ra) # 80003a4a <filedup>
    80001356:	00a93023          	sd	a0,0(s2)
    8000135a:	b7e5                	j	80001342 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000135c:	150ab503          	ld	a0,336(s5)
    80001360:	00002097          	auipc	ra,0x2
    80001364:	862080e7          	jalr	-1950(ra) # 80002bc2 <idup>
    80001368:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000136c:	4641                	li	a2,16
    8000136e:	158a8593          	addi	a1,s5,344
    80001372:	15898513          	addi	a0,s3,344
    80001376:	fffff097          	auipc	ra,0xfffff
    8000137a:	f90080e7          	jalr	-112(ra) # 80000306 <safestrcpy>
  np->syscall_trace = p->syscall_trace;
    8000137e:	168ab783          	ld	a5,360(s5)
    80001382:	16f9b423          	sd	a5,360(s3)
  pid = np->pid;
    80001386:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000138a:	854e                	mv	a0,s3
    8000138c:	00005097          	auipc	ra,0x5
    80001390:	00e080e7          	jalr	14(ra) # 8000639a <release>
  acquire(&wait_lock);
    80001394:	00008497          	auipc	s1,0x8
    80001398:	cd448493          	addi	s1,s1,-812 # 80009068 <wait_lock>
    8000139c:	8526                	mv	a0,s1
    8000139e:	00005097          	auipc	ra,0x5
    800013a2:	f48080e7          	jalr	-184(ra) # 800062e6 <acquire>
  np->parent = p;
    800013a6:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	00005097          	auipc	ra,0x5
    800013b0:	fee080e7          	jalr	-18(ra) # 8000639a <release>
  acquire(&np->lock);
    800013b4:	854e                	mv	a0,s3
    800013b6:	00005097          	auipc	ra,0x5
    800013ba:	f30080e7          	jalr	-208(ra) # 800062e6 <acquire>
  np->state = RUNNABLE;
    800013be:	478d                	li	a5,3
    800013c0:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800013c4:	854e                	mv	a0,s3
    800013c6:	00005097          	auipc	ra,0x5
    800013ca:	fd4080e7          	jalr	-44(ra) # 8000639a <release>
  return pid;
    800013ce:	74a2                	ld	s1,40(sp)
    800013d0:	69e2                	ld	s3,24(sp)
    800013d2:	6a42                	ld	s4,16(sp)
}
    800013d4:	854a                	mv	a0,s2
    800013d6:	70e2                	ld	ra,56(sp)
    800013d8:	7442                	ld	s0,48(sp)
    800013da:	7902                	ld	s2,32(sp)
    800013dc:	6aa2                	ld	s5,8(sp)
    800013de:	6121                	addi	sp,sp,64
    800013e0:	8082                	ret
    return -1;
    800013e2:	597d                	li	s2,-1
    800013e4:	bfc5                	j	800013d4 <fork+0x138>

00000000800013e6 <scheduler>:
{
    800013e6:	7139                	addi	sp,sp,-64
    800013e8:	fc06                	sd	ra,56(sp)
    800013ea:	f822                	sd	s0,48(sp)
    800013ec:	f426                	sd	s1,40(sp)
    800013ee:	f04a                	sd	s2,32(sp)
    800013f0:	ec4e                	sd	s3,24(sp)
    800013f2:	e852                	sd	s4,16(sp)
    800013f4:	e456                	sd	s5,8(sp)
    800013f6:	e05a                	sd	s6,0(sp)
    800013f8:	0080                	addi	s0,sp,64
    800013fa:	8792                	mv	a5,tp
  int id = r_tp();
    800013fc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013fe:	00779a93          	slli	s5,a5,0x7
    80001402:	00008717          	auipc	a4,0x8
    80001406:	c4e70713          	addi	a4,a4,-946 # 80009050 <pid_lock>
    8000140a:	9756                	add	a4,a4,s5
    8000140c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001410:	00008717          	auipc	a4,0x8
    80001414:	c7870713          	addi	a4,a4,-904 # 80009088 <cpus+0x8>
    80001418:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000141a:	498d                	li	s3,3
        p->state = RUNNING;
    8000141c:	4b11                	li	s6,4
        c->proc = p;
    8000141e:	079e                	slli	a5,a5,0x7
    80001420:	00008a17          	auipc	s4,0x8
    80001424:	c30a0a13          	addi	s4,s4,-976 # 80009050 <pid_lock>
    80001428:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142a:	0000e917          	auipc	s2,0xe
    8000142e:	c5690913          	addi	s2,s2,-938 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001432:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001436:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000143a:	10079073          	csrw	sstatus,a5
    8000143e:	00008497          	auipc	s1,0x8
    80001442:	04248493          	addi	s1,s1,66 # 80009480 <proc>
    80001446:	a811                	j	8000145a <scheduler+0x74>
      release(&p->lock);
    80001448:	8526                	mv	a0,s1
    8000144a:	00005097          	auipc	ra,0x5
    8000144e:	f50080e7          	jalr	-176(ra) # 8000639a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001452:	17048493          	addi	s1,s1,368
    80001456:	fd248ee3          	beq	s1,s2,80001432 <scheduler+0x4c>
      acquire(&p->lock);
    8000145a:	8526                	mv	a0,s1
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	e8a080e7          	jalr	-374(ra) # 800062e6 <acquire>
      if(p->state == RUNNABLE) {
    80001464:	4c9c                	lw	a5,24(s1)
    80001466:	ff3791e3          	bne	a5,s3,80001448 <scheduler+0x62>
        p->state = RUNNING;
    8000146a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000146e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001472:	06048593          	addi	a1,s1,96
    80001476:	8556                	mv	a0,s5
    80001478:	00000097          	auipc	ra,0x0
    8000147c:	64e080e7          	jalr	1614(ra) # 80001ac6 <swtch>
        c->proc = 0;
    80001480:	020a3823          	sd	zero,48(s4)
    80001484:	b7d1                	j	80001448 <scheduler+0x62>

0000000080001486 <sched>:
{
    80001486:	7179                	addi	sp,sp,-48
    80001488:	f406                	sd	ra,40(sp)
    8000148a:	f022                	sd	s0,32(sp)
    8000148c:	ec26                	sd	s1,24(sp)
    8000148e:	e84a                	sd	s2,16(sp)
    80001490:	e44e                	sd	s3,8(sp)
    80001492:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001494:	00000097          	auipc	ra,0x0
    80001498:	a32080e7          	jalr	-1486(ra) # 80000ec6 <myproc>
    8000149c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	dce080e7          	jalr	-562(ra) # 8000626c <holding>
    800014a6:	c93d                	beqz	a0,8000151c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014aa:	2781                	sext.w	a5,a5
    800014ac:	079e                	slli	a5,a5,0x7
    800014ae:	00008717          	auipc	a4,0x8
    800014b2:	ba270713          	addi	a4,a4,-1118 # 80009050 <pid_lock>
    800014b6:	97ba                	add	a5,a5,a4
    800014b8:	0a87a703          	lw	a4,168(a5)
    800014bc:	4785                	li	a5,1
    800014be:	06f71763          	bne	a4,a5,8000152c <sched+0xa6>
  if(p->state == RUNNING)
    800014c2:	4c98                	lw	a4,24(s1)
    800014c4:	4791                	li	a5,4
    800014c6:	06f70b63          	beq	a4,a5,8000153c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ce:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014d0:	efb5                	bnez	a5,8000154c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014d2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014d4:	00008917          	auipc	s2,0x8
    800014d8:	b7c90913          	addi	s2,s2,-1156 # 80009050 <pid_lock>
    800014dc:	2781                	sext.w	a5,a5
    800014de:	079e                	slli	a5,a5,0x7
    800014e0:	97ca                	add	a5,a5,s2
    800014e2:	0ac7a983          	lw	s3,172(a5)
    800014e6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014e8:	2781                	sext.w	a5,a5
    800014ea:	079e                	slli	a5,a5,0x7
    800014ec:	00008597          	auipc	a1,0x8
    800014f0:	b9c58593          	addi	a1,a1,-1124 # 80009088 <cpus+0x8>
    800014f4:	95be                	add	a1,a1,a5
    800014f6:	06048513          	addi	a0,s1,96
    800014fa:	00000097          	auipc	ra,0x0
    800014fe:	5cc080e7          	jalr	1484(ra) # 80001ac6 <swtch>
    80001502:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001504:	2781                	sext.w	a5,a5
    80001506:	079e                	slli	a5,a5,0x7
    80001508:	993e                	add	s2,s2,a5
    8000150a:	0b392623          	sw	s3,172(s2)
}
    8000150e:	70a2                	ld	ra,40(sp)
    80001510:	7402                	ld	s0,32(sp)
    80001512:	64e2                	ld	s1,24(sp)
    80001514:	6942                	ld	s2,16(sp)
    80001516:	69a2                	ld	s3,8(sp)
    80001518:	6145                	addi	sp,sp,48
    8000151a:	8082                	ret
    panic("sched p->lock");
    8000151c:	00007517          	auipc	a0,0x7
    80001520:	c7c50513          	addi	a0,a0,-900 # 80008198 <etext+0x198>
    80001524:	00005097          	auipc	ra,0x5
    80001528:	848080e7          	jalr	-1976(ra) # 80005d6c <panic>
    panic("sched locks");
    8000152c:	00007517          	auipc	a0,0x7
    80001530:	c7c50513          	addi	a0,a0,-900 # 800081a8 <etext+0x1a8>
    80001534:	00005097          	auipc	ra,0x5
    80001538:	838080e7          	jalr	-1992(ra) # 80005d6c <panic>
    panic("sched running");
    8000153c:	00007517          	auipc	a0,0x7
    80001540:	c7c50513          	addi	a0,a0,-900 # 800081b8 <etext+0x1b8>
    80001544:	00005097          	auipc	ra,0x5
    80001548:	828080e7          	jalr	-2008(ra) # 80005d6c <panic>
    panic("sched interruptible");
    8000154c:	00007517          	auipc	a0,0x7
    80001550:	c7c50513          	addi	a0,a0,-900 # 800081c8 <etext+0x1c8>
    80001554:	00005097          	auipc	ra,0x5
    80001558:	818080e7          	jalr	-2024(ra) # 80005d6c <panic>

000000008000155c <yield>:
{
    8000155c:	1101                	addi	sp,sp,-32
    8000155e:	ec06                	sd	ra,24(sp)
    80001560:	e822                	sd	s0,16(sp)
    80001562:	e426                	sd	s1,8(sp)
    80001564:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	960080e7          	jalr	-1696(ra) # 80000ec6 <myproc>
    8000156e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001570:	00005097          	auipc	ra,0x5
    80001574:	d76080e7          	jalr	-650(ra) # 800062e6 <acquire>
  p->state = RUNNABLE;
    80001578:	478d                	li	a5,3
    8000157a:	cc9c                	sw	a5,24(s1)
  sched();
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	f0a080e7          	jalr	-246(ra) # 80001486 <sched>
  release(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	e14080e7          	jalr	-492(ra) # 8000639a <release>
}
    8000158e:	60e2                	ld	ra,24(sp)
    80001590:	6442                	ld	s0,16(sp)
    80001592:	64a2                	ld	s1,8(sp)
    80001594:	6105                	addi	sp,sp,32
    80001596:	8082                	ret

0000000080001598 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001598:	7179                	addi	sp,sp,-48
    8000159a:	f406                	sd	ra,40(sp)
    8000159c:	f022                	sd	s0,32(sp)
    8000159e:	ec26                	sd	s1,24(sp)
    800015a0:	e84a                	sd	s2,16(sp)
    800015a2:	e44e                	sd	s3,8(sp)
    800015a4:	1800                	addi	s0,sp,48
    800015a6:	89aa                	mv	s3,a0
    800015a8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	91c080e7          	jalr	-1764(ra) # 80000ec6 <myproc>
    800015b2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015b4:	00005097          	auipc	ra,0x5
    800015b8:	d32080e7          	jalr	-718(ra) # 800062e6 <acquire>
  release(lk);
    800015bc:	854a                	mv	a0,s2
    800015be:	00005097          	auipc	ra,0x5
    800015c2:	ddc080e7          	jalr	-548(ra) # 8000639a <release>

  // Go to sleep.
  p->chan = chan;
    800015c6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015ca:	4789                	li	a5,2
    800015cc:	cc9c                	sw	a5,24(s1)

  sched();
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	eb8080e7          	jalr	-328(ra) # 80001486 <sched>

  // Tidy up.
  p->chan = 0;
    800015d6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015da:	8526                	mv	a0,s1
    800015dc:	00005097          	auipc	ra,0x5
    800015e0:	dbe080e7          	jalr	-578(ra) # 8000639a <release>
  acquire(lk);
    800015e4:	854a                	mv	a0,s2
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	d00080e7          	jalr	-768(ra) # 800062e6 <acquire>
}
    800015ee:	70a2                	ld	ra,40(sp)
    800015f0:	7402                	ld	s0,32(sp)
    800015f2:	64e2                	ld	s1,24(sp)
    800015f4:	6942                	ld	s2,16(sp)
    800015f6:	69a2                	ld	s3,8(sp)
    800015f8:	6145                	addi	sp,sp,48
    800015fa:	8082                	ret

00000000800015fc <wait>:
{
    800015fc:	715d                	addi	sp,sp,-80
    800015fe:	e486                	sd	ra,72(sp)
    80001600:	e0a2                	sd	s0,64(sp)
    80001602:	fc26                	sd	s1,56(sp)
    80001604:	f84a                	sd	s2,48(sp)
    80001606:	f44e                	sd	s3,40(sp)
    80001608:	f052                	sd	s4,32(sp)
    8000160a:	ec56                	sd	s5,24(sp)
    8000160c:	e85a                	sd	s6,16(sp)
    8000160e:	e45e                	sd	s7,8(sp)
    80001610:	e062                	sd	s8,0(sp)
    80001612:	0880                	addi	s0,sp,80
    80001614:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	8b0080e7          	jalr	-1872(ra) # 80000ec6 <myproc>
    8000161e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001620:	00008517          	auipc	a0,0x8
    80001624:	a4850513          	addi	a0,a0,-1464 # 80009068 <wait_lock>
    80001628:	00005097          	auipc	ra,0x5
    8000162c:	cbe080e7          	jalr	-834(ra) # 800062e6 <acquire>
    havekids = 0;
    80001630:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001632:	4a15                	li	s4,5
        havekids = 1;
    80001634:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001636:	0000e997          	auipc	s3,0xe
    8000163a:	a4a98993          	addi	s3,s3,-1462 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000163e:	00008c17          	auipc	s8,0x8
    80001642:	a2ac0c13          	addi	s8,s8,-1494 # 80009068 <wait_lock>
    80001646:	a87d                	j	80001704 <wait+0x108>
          pid = np->pid;
    80001648:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000164c:	000b0e63          	beqz	s6,80001668 <wait+0x6c>
    80001650:	4691                	li	a3,4
    80001652:	02c48613          	addi	a2,s1,44
    80001656:	85da                	mv	a1,s6
    80001658:	05093503          	ld	a0,80(s2)
    8000165c:	fffff097          	auipc	ra,0xfffff
    80001660:	506080e7          	jalr	1286(ra) # 80000b62 <copyout>
    80001664:	04054163          	bltz	a0,800016a6 <wait+0xaa>
          freeproc(np);
    80001668:	8526                	mv	a0,s1
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	a0e080e7          	jalr	-1522(ra) # 80001078 <freeproc>
          release(&np->lock);
    80001672:	8526                	mv	a0,s1
    80001674:	00005097          	auipc	ra,0x5
    80001678:	d26080e7          	jalr	-730(ra) # 8000639a <release>
          release(&wait_lock);
    8000167c:	00008517          	auipc	a0,0x8
    80001680:	9ec50513          	addi	a0,a0,-1556 # 80009068 <wait_lock>
    80001684:	00005097          	auipc	ra,0x5
    80001688:	d16080e7          	jalr	-746(ra) # 8000639a <release>
}
    8000168c:	854e                	mv	a0,s3
    8000168e:	60a6                	ld	ra,72(sp)
    80001690:	6406                	ld	s0,64(sp)
    80001692:	74e2                	ld	s1,56(sp)
    80001694:	7942                	ld	s2,48(sp)
    80001696:	79a2                	ld	s3,40(sp)
    80001698:	7a02                	ld	s4,32(sp)
    8000169a:	6ae2                	ld	s5,24(sp)
    8000169c:	6b42                	ld	s6,16(sp)
    8000169e:	6ba2                	ld	s7,8(sp)
    800016a0:	6c02                	ld	s8,0(sp)
    800016a2:	6161                	addi	sp,sp,80
    800016a4:	8082                	ret
            release(&np->lock);
    800016a6:	8526                	mv	a0,s1
    800016a8:	00005097          	auipc	ra,0x5
    800016ac:	cf2080e7          	jalr	-782(ra) # 8000639a <release>
            release(&wait_lock);
    800016b0:	00008517          	auipc	a0,0x8
    800016b4:	9b850513          	addi	a0,a0,-1608 # 80009068 <wait_lock>
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	ce2080e7          	jalr	-798(ra) # 8000639a <release>
            return -1;
    800016c0:	59fd                	li	s3,-1
    800016c2:	b7e9                	j	8000168c <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    800016c4:	17048493          	addi	s1,s1,368
    800016c8:	03348463          	beq	s1,s3,800016f0 <wait+0xf4>
      if(np->parent == p){
    800016cc:	7c9c                	ld	a5,56(s1)
    800016ce:	ff279be3          	bne	a5,s2,800016c4 <wait+0xc8>
        acquire(&np->lock);
    800016d2:	8526                	mv	a0,s1
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	c12080e7          	jalr	-1006(ra) # 800062e6 <acquire>
        if(np->state == ZOMBIE){
    800016dc:	4c9c                	lw	a5,24(s1)
    800016de:	f74785e3          	beq	a5,s4,80001648 <wait+0x4c>
        release(&np->lock);
    800016e2:	8526                	mv	a0,s1
    800016e4:	00005097          	auipc	ra,0x5
    800016e8:	cb6080e7          	jalr	-842(ra) # 8000639a <release>
        havekids = 1;
    800016ec:	8756                	mv	a4,s5
    800016ee:	bfd9                	j	800016c4 <wait+0xc8>
    if(!havekids || p->killed){
    800016f0:	c305                	beqz	a4,80001710 <wait+0x114>
    800016f2:	02892783          	lw	a5,40(s2)
    800016f6:	ef89                	bnez	a5,80001710 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016f8:	85e2                	mv	a1,s8
    800016fa:	854a                	mv	a0,s2
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	e9c080e7          	jalr	-356(ra) # 80001598 <sleep>
    havekids = 0;
    80001704:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001706:	00008497          	auipc	s1,0x8
    8000170a:	d7a48493          	addi	s1,s1,-646 # 80009480 <proc>
    8000170e:	bf7d                	j	800016cc <wait+0xd0>
      release(&wait_lock);
    80001710:	00008517          	auipc	a0,0x8
    80001714:	95850513          	addi	a0,a0,-1704 # 80009068 <wait_lock>
    80001718:	00005097          	auipc	ra,0x5
    8000171c:	c82080e7          	jalr	-894(ra) # 8000639a <release>
      return -1;
    80001720:	59fd                	li	s3,-1
    80001722:	b7ad                	j	8000168c <wait+0x90>

0000000080001724 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001724:	7139                	addi	sp,sp,-64
    80001726:	fc06                	sd	ra,56(sp)
    80001728:	f822                	sd	s0,48(sp)
    8000172a:	f426                	sd	s1,40(sp)
    8000172c:	f04a                	sd	s2,32(sp)
    8000172e:	ec4e                	sd	s3,24(sp)
    80001730:	e852                	sd	s4,16(sp)
    80001732:	e456                	sd	s5,8(sp)
    80001734:	0080                	addi	s0,sp,64
    80001736:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001738:	00008497          	auipc	s1,0x8
    8000173c:	d4848493          	addi	s1,s1,-696 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001740:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001742:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001744:	0000e917          	auipc	s2,0xe
    80001748:	93c90913          	addi	s2,s2,-1732 # 8000f080 <tickslock>
    8000174c:	a811                	j	80001760 <wakeup+0x3c>
      }
      release(&p->lock);
    8000174e:	8526                	mv	a0,s1
    80001750:	00005097          	auipc	ra,0x5
    80001754:	c4a080e7          	jalr	-950(ra) # 8000639a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001758:	17048493          	addi	s1,s1,368
    8000175c:	03248663          	beq	s1,s2,80001788 <wakeup+0x64>
    if(p != myproc()){
    80001760:	fffff097          	auipc	ra,0xfffff
    80001764:	766080e7          	jalr	1894(ra) # 80000ec6 <myproc>
    80001768:	fea488e3          	beq	s1,a0,80001758 <wakeup+0x34>
      acquire(&p->lock);
    8000176c:	8526                	mv	a0,s1
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	b78080e7          	jalr	-1160(ra) # 800062e6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001776:	4c9c                	lw	a5,24(s1)
    80001778:	fd379be3          	bne	a5,s3,8000174e <wakeup+0x2a>
    8000177c:	709c                	ld	a5,32(s1)
    8000177e:	fd4798e3          	bne	a5,s4,8000174e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001782:	0154ac23          	sw	s5,24(s1)
    80001786:	b7e1                	j	8000174e <wakeup+0x2a>
    }
  }
}
    80001788:	70e2                	ld	ra,56(sp)
    8000178a:	7442                	ld	s0,48(sp)
    8000178c:	74a2                	ld	s1,40(sp)
    8000178e:	7902                	ld	s2,32(sp)
    80001790:	69e2                	ld	s3,24(sp)
    80001792:	6a42                	ld	s4,16(sp)
    80001794:	6aa2                	ld	s5,8(sp)
    80001796:	6121                	addi	sp,sp,64
    80001798:	8082                	ret

000000008000179a <reparent>:
{
    8000179a:	7179                	addi	sp,sp,-48
    8000179c:	f406                	sd	ra,40(sp)
    8000179e:	f022                	sd	s0,32(sp)
    800017a0:	ec26                	sd	s1,24(sp)
    800017a2:	e84a                	sd	s2,16(sp)
    800017a4:	e44e                	sd	s3,8(sp)
    800017a6:	e052                	sd	s4,0(sp)
    800017a8:	1800                	addi	s0,sp,48
    800017aa:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017ac:	00008497          	auipc	s1,0x8
    800017b0:	cd448493          	addi	s1,s1,-812 # 80009480 <proc>
      pp->parent = initproc;
    800017b4:	00008a17          	auipc	s4,0x8
    800017b8:	85ca0a13          	addi	s4,s4,-1956 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017bc:	0000e997          	auipc	s3,0xe
    800017c0:	8c498993          	addi	s3,s3,-1852 # 8000f080 <tickslock>
    800017c4:	a029                	j	800017ce <reparent+0x34>
    800017c6:	17048493          	addi	s1,s1,368
    800017ca:	01348d63          	beq	s1,s3,800017e4 <reparent+0x4a>
    if(pp->parent == p){
    800017ce:	7c9c                	ld	a5,56(s1)
    800017d0:	ff279be3          	bne	a5,s2,800017c6 <reparent+0x2c>
      pp->parent = initproc;
    800017d4:	000a3503          	ld	a0,0(s4)
    800017d8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017da:	00000097          	auipc	ra,0x0
    800017de:	f4a080e7          	jalr	-182(ra) # 80001724 <wakeup>
    800017e2:	b7d5                	j	800017c6 <reparent+0x2c>
}
    800017e4:	70a2                	ld	ra,40(sp)
    800017e6:	7402                	ld	s0,32(sp)
    800017e8:	64e2                	ld	s1,24(sp)
    800017ea:	6942                	ld	s2,16(sp)
    800017ec:	69a2                	ld	s3,8(sp)
    800017ee:	6a02                	ld	s4,0(sp)
    800017f0:	6145                	addi	sp,sp,48
    800017f2:	8082                	ret

00000000800017f4 <exit>:
{
    800017f4:	7179                	addi	sp,sp,-48
    800017f6:	f406                	sd	ra,40(sp)
    800017f8:	f022                	sd	s0,32(sp)
    800017fa:	ec26                	sd	s1,24(sp)
    800017fc:	e84a                	sd	s2,16(sp)
    800017fe:	e44e                	sd	s3,8(sp)
    80001800:	e052                	sd	s4,0(sp)
    80001802:	1800                	addi	s0,sp,48
    80001804:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001806:	fffff097          	auipc	ra,0xfffff
    8000180a:	6c0080e7          	jalr	1728(ra) # 80000ec6 <myproc>
    8000180e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001810:	00008797          	auipc	a5,0x8
    80001814:	8007b783          	ld	a5,-2048(a5) # 80009010 <initproc>
    80001818:	0d050493          	addi	s1,a0,208
    8000181c:	15050913          	addi	s2,a0,336
    80001820:	02a79363          	bne	a5,a0,80001846 <exit+0x52>
    panic("init exiting");
    80001824:	00007517          	auipc	a0,0x7
    80001828:	9bc50513          	addi	a0,a0,-1604 # 800081e0 <etext+0x1e0>
    8000182c:	00004097          	auipc	ra,0x4
    80001830:	540080e7          	jalr	1344(ra) # 80005d6c <panic>
      fileclose(f);
    80001834:	00002097          	auipc	ra,0x2
    80001838:	268080e7          	jalr	616(ra) # 80003a9c <fileclose>
      p->ofile[fd] = 0;
    8000183c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001840:	04a1                	addi	s1,s1,8
    80001842:	01248563          	beq	s1,s2,8000184c <exit+0x58>
    if(p->ofile[fd]){
    80001846:	6088                	ld	a0,0(s1)
    80001848:	f575                	bnez	a0,80001834 <exit+0x40>
    8000184a:	bfdd                	j	80001840 <exit+0x4c>
  begin_op();
    8000184c:	00002097          	auipc	ra,0x2
    80001850:	d86080e7          	jalr	-634(ra) # 800035d2 <begin_op>
  iput(p->cwd);
    80001854:	1509b503          	ld	a0,336(s3)
    80001858:	00001097          	auipc	ra,0x1
    8000185c:	566080e7          	jalr	1382(ra) # 80002dbe <iput>
  end_op();
    80001860:	00002097          	auipc	ra,0x2
    80001864:	dec080e7          	jalr	-532(ra) # 8000364c <end_op>
  p->cwd = 0;
    80001868:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000186c:	00007497          	auipc	s1,0x7
    80001870:	7fc48493          	addi	s1,s1,2044 # 80009068 <wait_lock>
    80001874:	8526                	mv	a0,s1
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	a70080e7          	jalr	-1424(ra) # 800062e6 <acquire>
  reparent(p);
    8000187e:	854e                	mv	a0,s3
    80001880:	00000097          	auipc	ra,0x0
    80001884:	f1a080e7          	jalr	-230(ra) # 8000179a <reparent>
  wakeup(p->parent);
    80001888:	0389b503          	ld	a0,56(s3)
    8000188c:	00000097          	auipc	ra,0x0
    80001890:	e98080e7          	jalr	-360(ra) # 80001724 <wakeup>
  acquire(&p->lock);
    80001894:	854e                	mv	a0,s3
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	a50080e7          	jalr	-1456(ra) # 800062e6 <acquire>
  p->xstate = status;
    8000189e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018a2:	4795                	li	a5,5
    800018a4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	af0080e7          	jalr	-1296(ra) # 8000639a <release>
  sched();
    800018b2:	00000097          	auipc	ra,0x0
    800018b6:	bd4080e7          	jalr	-1068(ra) # 80001486 <sched>
  panic("zombie exit");
    800018ba:	00007517          	auipc	a0,0x7
    800018be:	93650513          	addi	a0,a0,-1738 # 800081f0 <etext+0x1f0>
    800018c2:	00004097          	auipc	ra,0x4
    800018c6:	4aa080e7          	jalr	1194(ra) # 80005d6c <panic>

00000000800018ca <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018ca:	7179                	addi	sp,sp,-48
    800018cc:	f406                	sd	ra,40(sp)
    800018ce:	f022                	sd	s0,32(sp)
    800018d0:	ec26                	sd	s1,24(sp)
    800018d2:	e84a                	sd	s2,16(sp)
    800018d4:	e44e                	sd	s3,8(sp)
    800018d6:	1800                	addi	s0,sp,48
    800018d8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018da:	00008497          	auipc	s1,0x8
    800018de:	ba648493          	addi	s1,s1,-1114 # 80009480 <proc>
    800018e2:	0000d997          	auipc	s3,0xd
    800018e6:	79e98993          	addi	s3,s3,1950 # 8000f080 <tickslock>
    acquire(&p->lock);
    800018ea:	8526                	mv	a0,s1
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	9fa080e7          	jalr	-1542(ra) # 800062e6 <acquire>
    if(p->pid == pid){
    800018f4:	589c                	lw	a5,48(s1)
    800018f6:	01278d63          	beq	a5,s2,80001910 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018fa:	8526                	mv	a0,s1
    800018fc:	00005097          	auipc	ra,0x5
    80001900:	a9e080e7          	jalr	-1378(ra) # 8000639a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001904:	17048493          	addi	s1,s1,368
    80001908:	ff3491e3          	bne	s1,s3,800018ea <kill+0x20>
  }
  return -1;
    8000190c:	557d                	li	a0,-1
    8000190e:	a829                	j	80001928 <kill+0x5e>
      p->killed = 1;
    80001910:	4785                	li	a5,1
    80001912:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001914:	4c98                	lw	a4,24(s1)
    80001916:	4789                	li	a5,2
    80001918:	00f70f63          	beq	a4,a5,80001936 <kill+0x6c>
      release(&p->lock);
    8000191c:	8526                	mv	a0,s1
    8000191e:	00005097          	auipc	ra,0x5
    80001922:	a7c080e7          	jalr	-1412(ra) # 8000639a <release>
      return 0;
    80001926:	4501                	li	a0,0
}
    80001928:	70a2                	ld	ra,40(sp)
    8000192a:	7402                	ld	s0,32(sp)
    8000192c:	64e2                	ld	s1,24(sp)
    8000192e:	6942                	ld	s2,16(sp)
    80001930:	69a2                	ld	s3,8(sp)
    80001932:	6145                	addi	sp,sp,48
    80001934:	8082                	ret
        p->state = RUNNABLE;
    80001936:	478d                	li	a5,3
    80001938:	cc9c                	sw	a5,24(s1)
    8000193a:	b7cd                	j	8000191c <kill+0x52>

000000008000193c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000193c:	7179                	addi	sp,sp,-48
    8000193e:	f406                	sd	ra,40(sp)
    80001940:	f022                	sd	s0,32(sp)
    80001942:	ec26                	sd	s1,24(sp)
    80001944:	e84a                	sd	s2,16(sp)
    80001946:	e44e                	sd	s3,8(sp)
    80001948:	e052                	sd	s4,0(sp)
    8000194a:	1800                	addi	s0,sp,48
    8000194c:	84aa                	mv	s1,a0
    8000194e:	892e                	mv	s2,a1
    80001950:	89b2                	mv	s3,a2
    80001952:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	572080e7          	jalr	1394(ra) # 80000ec6 <myproc>
  if(user_dst){
    8000195c:	c08d                	beqz	s1,8000197e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000195e:	86d2                	mv	a3,s4
    80001960:	864e                	mv	a2,s3
    80001962:	85ca                	mv	a1,s2
    80001964:	6928                	ld	a0,80(a0)
    80001966:	fffff097          	auipc	ra,0xfffff
    8000196a:	1fc080e7          	jalr	508(ra) # 80000b62 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000196e:	70a2                	ld	ra,40(sp)
    80001970:	7402                	ld	s0,32(sp)
    80001972:	64e2                	ld	s1,24(sp)
    80001974:	6942                	ld	s2,16(sp)
    80001976:	69a2                	ld	s3,8(sp)
    80001978:	6a02                	ld	s4,0(sp)
    8000197a:	6145                	addi	sp,sp,48
    8000197c:	8082                	ret
    memmove((char *)dst, src, len);
    8000197e:	000a061b          	sext.w	a2,s4
    80001982:	85ce                	mv	a1,s3
    80001984:	854a                	mv	a0,s2
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	89a080e7          	jalr	-1894(ra) # 80000220 <memmove>
    return 0;
    8000198e:	8526                	mv	a0,s1
    80001990:	bff9                	j	8000196e <either_copyout+0x32>

0000000080001992 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001992:	7179                	addi	sp,sp,-48
    80001994:	f406                	sd	ra,40(sp)
    80001996:	f022                	sd	s0,32(sp)
    80001998:	ec26                	sd	s1,24(sp)
    8000199a:	e84a                	sd	s2,16(sp)
    8000199c:	e44e                	sd	s3,8(sp)
    8000199e:	e052                	sd	s4,0(sp)
    800019a0:	1800                	addi	s0,sp,48
    800019a2:	892a                	mv	s2,a0
    800019a4:	84ae                	mv	s1,a1
    800019a6:	89b2                	mv	s3,a2
    800019a8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019aa:	fffff097          	auipc	ra,0xfffff
    800019ae:	51c080e7          	jalr	1308(ra) # 80000ec6 <myproc>
  if(user_src){
    800019b2:	c08d                	beqz	s1,800019d4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019b4:	86d2                	mv	a3,s4
    800019b6:	864e                	mv	a2,s3
    800019b8:	85ca                	mv	a1,s2
    800019ba:	6928                	ld	a0,80(a0)
    800019bc:	fffff097          	auipc	ra,0xfffff
    800019c0:	232080e7          	jalr	562(ra) # 80000bee <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019c4:	70a2                	ld	ra,40(sp)
    800019c6:	7402                	ld	s0,32(sp)
    800019c8:	64e2                	ld	s1,24(sp)
    800019ca:	6942                	ld	s2,16(sp)
    800019cc:	69a2                	ld	s3,8(sp)
    800019ce:	6a02                	ld	s4,0(sp)
    800019d0:	6145                	addi	sp,sp,48
    800019d2:	8082                	ret
    memmove(dst, (char*)src, len);
    800019d4:	000a061b          	sext.w	a2,s4
    800019d8:	85ce                	mv	a1,s3
    800019da:	854a                	mv	a0,s2
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	844080e7          	jalr	-1980(ra) # 80000220 <memmove>
    return 0;
    800019e4:	8526                	mv	a0,s1
    800019e6:	bff9                	j	800019c4 <either_copyin+0x32>

00000000800019e8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019e8:	715d                	addi	sp,sp,-80
    800019ea:	e486                	sd	ra,72(sp)
    800019ec:	e0a2                	sd	s0,64(sp)
    800019ee:	fc26                	sd	s1,56(sp)
    800019f0:	f84a                	sd	s2,48(sp)
    800019f2:	f44e                	sd	s3,40(sp)
    800019f4:	f052                	sd	s4,32(sp)
    800019f6:	ec56                	sd	s5,24(sp)
    800019f8:	e85a                	sd	s6,16(sp)
    800019fa:	e45e                	sd	s7,8(sp)
    800019fc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019fe:	00006517          	auipc	a0,0x6
    80001a02:	61a50513          	addi	a0,a0,1562 # 80008018 <etext+0x18>
    80001a06:	00004097          	auipc	ra,0x4
    80001a0a:	3b0080e7          	jalr	944(ra) # 80005db6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a0e:	00008497          	auipc	s1,0x8
    80001a12:	bca48493          	addi	s1,s1,-1078 # 800095d8 <proc+0x158>
    80001a16:	0000d917          	auipc	s2,0xd
    80001a1a:	7c290913          	addi	s2,s2,1986 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a1e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a20:	00006997          	auipc	s3,0x6
    80001a24:	7e098993          	addi	s3,s3,2016 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a28:	00006a97          	auipc	s5,0x6
    80001a2c:	7e0a8a93          	addi	s5,s5,2016 # 80008208 <etext+0x208>
    printf("\n");
    80001a30:	00006a17          	auipc	s4,0x6
    80001a34:	5e8a0a13          	addi	s4,s4,1512 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a38:	00007b97          	auipc	s7,0x7
    80001a3c:	d88b8b93          	addi	s7,s7,-632 # 800087c0 <states.0>
    80001a40:	a00d                	j	80001a62 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a42:	ed86a583          	lw	a1,-296(a3)
    80001a46:	8556                	mv	a0,s5
    80001a48:	00004097          	auipc	ra,0x4
    80001a4c:	36e080e7          	jalr	878(ra) # 80005db6 <printf>
    printf("\n");
    80001a50:	8552                	mv	a0,s4
    80001a52:	00004097          	auipc	ra,0x4
    80001a56:	364080e7          	jalr	868(ra) # 80005db6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a5a:	17048493          	addi	s1,s1,368
    80001a5e:	03248263          	beq	s1,s2,80001a82 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a62:	86a6                	mv	a3,s1
    80001a64:	ec04a783          	lw	a5,-320(s1)
    80001a68:	dbed                	beqz	a5,80001a5a <procdump+0x72>
      state = "???";
    80001a6a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a6c:	fcfb6be3          	bltu	s6,a5,80001a42 <procdump+0x5a>
    80001a70:	02079713          	slli	a4,a5,0x20
    80001a74:	01d75793          	srli	a5,a4,0x1d
    80001a78:	97de                	add	a5,a5,s7
    80001a7a:	6390                	ld	a2,0(a5)
    80001a7c:	f279                	bnez	a2,80001a42 <procdump+0x5a>
      state = "???";
    80001a7e:	864e                	mv	a2,s3
    80001a80:	b7c9                	j	80001a42 <procdump+0x5a>
  }
}
    80001a82:	60a6                	ld	ra,72(sp)
    80001a84:	6406                	ld	s0,64(sp)
    80001a86:	74e2                	ld	s1,56(sp)
    80001a88:	7942                	ld	s2,48(sp)
    80001a8a:	79a2                	ld	s3,40(sp)
    80001a8c:	7a02                	ld	s4,32(sp)
    80001a8e:	6ae2                	ld	s5,24(sp)
    80001a90:	6b42                	ld	s6,16(sp)
    80001a92:	6ba2                	ld	s7,8(sp)
    80001a94:	6161                	addi	sp,sp,80
    80001a96:	8082                	ret

0000000080001a98 <count_process>:


//this is function we add for count process mem (lab2-syscallinfo)
uint64 count_process(void){
    80001a98:	1141                	addi	sp,sp,-16
    80001a9a:	e422                	sd	s0,8(sp)
    80001a9c:	0800                	addi	s0,sp,16
	uint64 cnt = 0;
	for(struct proc *p = proc; p < &proc[NPROC];p++){
    80001a9e:	00008797          	auipc	a5,0x8
    80001aa2:	9e278793          	addi	a5,a5,-1566 # 80009480 <proc>
	uint64 cnt = 0;
    80001aa6:	4501                	li	a0,0
	for(struct proc *p = proc; p < &proc[NPROC];p++){
    80001aa8:	0000d697          	auipc	a3,0xd
    80001aac:	5d868693          	addi	a3,a3,1496 # 8000f080 <tickslock>
		if(p->state != UNUSED){
    80001ab0:	4f98                	lw	a4,24(a5)
			cnt++;
    80001ab2:	00e03733          	snez	a4,a4
    80001ab6:	953a                	add	a0,a0,a4
	for(struct proc *p = proc; p < &proc[NPROC];p++){
    80001ab8:	17078793          	addi	a5,a5,368
    80001abc:	fed79ae3          	bne	a5,a3,80001ab0 <count_process+0x18>
		}
	}
	return cnt;
}
    80001ac0:	6422                	ld	s0,8(sp)
    80001ac2:	0141                	addi	sp,sp,16
    80001ac4:	8082                	ret

0000000080001ac6 <swtch>:
    80001ac6:	00153023          	sd	ra,0(a0)
    80001aca:	00253423          	sd	sp,8(a0)
    80001ace:	e900                	sd	s0,16(a0)
    80001ad0:	ed04                	sd	s1,24(a0)
    80001ad2:	03253023          	sd	s2,32(a0)
    80001ad6:	03353423          	sd	s3,40(a0)
    80001ada:	03453823          	sd	s4,48(a0)
    80001ade:	03553c23          	sd	s5,56(a0)
    80001ae2:	05653023          	sd	s6,64(a0)
    80001ae6:	05753423          	sd	s7,72(a0)
    80001aea:	05853823          	sd	s8,80(a0)
    80001aee:	05953c23          	sd	s9,88(a0)
    80001af2:	07a53023          	sd	s10,96(a0)
    80001af6:	07b53423          	sd	s11,104(a0)
    80001afa:	0005b083          	ld	ra,0(a1)
    80001afe:	0085b103          	ld	sp,8(a1)
    80001b02:	6980                	ld	s0,16(a1)
    80001b04:	6d84                	ld	s1,24(a1)
    80001b06:	0205b903          	ld	s2,32(a1)
    80001b0a:	0285b983          	ld	s3,40(a1)
    80001b0e:	0305ba03          	ld	s4,48(a1)
    80001b12:	0385ba83          	ld	s5,56(a1)
    80001b16:	0405bb03          	ld	s6,64(a1)
    80001b1a:	0485bb83          	ld	s7,72(a1)
    80001b1e:	0505bc03          	ld	s8,80(a1)
    80001b22:	0585bc83          	ld	s9,88(a1)
    80001b26:	0605bd03          	ld	s10,96(a1)
    80001b2a:	0685bd83          	ld	s11,104(a1)
    80001b2e:	8082                	ret

0000000080001b30 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b30:	1141                	addi	sp,sp,-16
    80001b32:	e406                	sd	ra,8(sp)
    80001b34:	e022                	sd	s0,0(sp)
    80001b36:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b38:	00006597          	auipc	a1,0x6
    80001b3c:	70858593          	addi	a1,a1,1800 # 80008240 <etext+0x240>
    80001b40:	0000d517          	auipc	a0,0xd
    80001b44:	54050513          	addi	a0,a0,1344 # 8000f080 <tickslock>
    80001b48:	00004097          	auipc	ra,0x4
    80001b4c:	70e080e7          	jalr	1806(ra) # 80006256 <initlock>
}
    80001b50:	60a2                	ld	ra,8(sp)
    80001b52:	6402                	ld	s0,0(sp)
    80001b54:	0141                	addi	sp,sp,16
    80001b56:	8082                	ret

0000000080001b58 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b58:	1141                	addi	sp,sp,-16
    80001b5a:	e422                	sd	s0,8(sp)
    80001b5c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b5e:	00003797          	auipc	a5,0x3
    80001b62:	62278793          	addi	a5,a5,1570 # 80005180 <kernelvec>
    80001b66:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b6a:	6422                	ld	s0,8(sp)
    80001b6c:	0141                	addi	sp,sp,16
    80001b6e:	8082                	ret

0000000080001b70 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b70:	1141                	addi	sp,sp,-16
    80001b72:	e406                	sd	ra,8(sp)
    80001b74:	e022                	sd	s0,0(sp)
    80001b76:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b78:	fffff097          	auipc	ra,0xfffff
    80001b7c:	34e080e7          	jalr	846(ra) # 80000ec6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b80:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b84:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b86:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b8a:	00005697          	auipc	a3,0x5
    80001b8e:	47668693          	addi	a3,a3,1142 # 80007000 <_trampoline>
    80001b92:	00005717          	auipc	a4,0x5
    80001b96:	46e70713          	addi	a4,a4,1134 # 80007000 <_trampoline>
    80001b9a:	8f15                	sub	a4,a4,a3
    80001b9c:	040007b7          	lui	a5,0x4000
    80001ba0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ba2:	07b2                	slli	a5,a5,0xc
    80001ba4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ba6:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001baa:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bac:	18002673          	csrr	a2,satp
    80001bb0:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bb2:	6d30                	ld	a2,88(a0)
    80001bb4:	6138                	ld	a4,64(a0)
    80001bb6:	6585                	lui	a1,0x1
    80001bb8:	972e                	add	a4,a4,a1
    80001bba:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bbc:	6d38                	ld	a4,88(a0)
    80001bbe:	00000617          	auipc	a2,0x0
    80001bc2:	14060613          	addi	a2,a2,320 # 80001cfe <usertrap>
    80001bc6:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bc8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bca:	8612                	mv	a2,tp
    80001bcc:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bce:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bd2:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bd6:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bda:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bde:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001be0:	6f18                	ld	a4,24(a4)
    80001be2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001be6:	692c                	ld	a1,80(a0)
    80001be8:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bea:	00005717          	auipc	a4,0x5
    80001bee:	4a670713          	addi	a4,a4,1190 # 80007090 <userret>
    80001bf2:	8f15                	sub	a4,a4,a3
    80001bf4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bf6:	577d                	li	a4,-1
    80001bf8:	177e                	slli	a4,a4,0x3f
    80001bfa:	8dd9                	or	a1,a1,a4
    80001bfc:	02000537          	lui	a0,0x2000
    80001c00:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c02:	0536                	slli	a0,a0,0xd
    80001c04:	9782                	jalr	a5
}
    80001c06:	60a2                	ld	ra,8(sp)
    80001c08:	6402                	ld	s0,0(sp)
    80001c0a:	0141                	addi	sp,sp,16
    80001c0c:	8082                	ret

0000000080001c0e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c0e:	1101                	addi	sp,sp,-32
    80001c10:	ec06                	sd	ra,24(sp)
    80001c12:	e822                	sd	s0,16(sp)
    80001c14:	e426                	sd	s1,8(sp)
    80001c16:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c18:	0000d497          	auipc	s1,0xd
    80001c1c:	46848493          	addi	s1,s1,1128 # 8000f080 <tickslock>
    80001c20:	8526                	mv	a0,s1
    80001c22:	00004097          	auipc	ra,0x4
    80001c26:	6c4080e7          	jalr	1732(ra) # 800062e6 <acquire>
  ticks++;
    80001c2a:	00007517          	auipc	a0,0x7
    80001c2e:	3ee50513          	addi	a0,a0,1006 # 80009018 <ticks>
    80001c32:	411c                	lw	a5,0(a0)
    80001c34:	2785                	addiw	a5,a5,1
    80001c36:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c38:	00000097          	auipc	ra,0x0
    80001c3c:	aec080e7          	jalr	-1300(ra) # 80001724 <wakeup>
  release(&tickslock);
    80001c40:	8526                	mv	a0,s1
    80001c42:	00004097          	auipc	ra,0x4
    80001c46:	758080e7          	jalr	1880(ra) # 8000639a <release>
}
    80001c4a:	60e2                	ld	ra,24(sp)
    80001c4c:	6442                	ld	s0,16(sp)
    80001c4e:	64a2                	ld	s1,8(sp)
    80001c50:	6105                	addi	sp,sp,32
    80001c52:	8082                	ret

0000000080001c54 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c54:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c58:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c5a:	0a07d163          	bgez	a5,80001cfc <devintr+0xa8>
{
    80001c5e:	1101                	addi	sp,sp,-32
    80001c60:	ec06                	sd	ra,24(sp)
    80001c62:	e822                	sd	s0,16(sp)
    80001c64:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c66:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c6a:	46a5                	li	a3,9
    80001c6c:	00d70c63          	beq	a4,a3,80001c84 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c70:	577d                	li	a4,-1
    80001c72:	177e                	slli	a4,a4,0x3f
    80001c74:	0705                	addi	a4,a4,1
    return 0;
    80001c76:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c78:	06e78163          	beq	a5,a4,80001cda <devintr+0x86>
  }
}
    80001c7c:	60e2                	ld	ra,24(sp)
    80001c7e:	6442                	ld	s0,16(sp)
    80001c80:	6105                	addi	sp,sp,32
    80001c82:	8082                	ret
    80001c84:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c86:	00003097          	auipc	ra,0x3
    80001c8a:	606080e7          	jalr	1542(ra) # 8000528c <plic_claim>
    80001c8e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c90:	47a9                	li	a5,10
    80001c92:	00f50963          	beq	a0,a5,80001ca4 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c96:	4785                	li	a5,1
    80001c98:	00f50b63          	beq	a0,a5,80001cae <devintr+0x5a>
    return 1;
    80001c9c:	4505                	li	a0,1
    } else if(irq){
    80001c9e:	ec89                	bnez	s1,80001cb8 <devintr+0x64>
    80001ca0:	64a2                	ld	s1,8(sp)
    80001ca2:	bfe9                	j	80001c7c <devintr+0x28>
      uartintr();
    80001ca4:	00004097          	auipc	ra,0x4
    80001ca8:	562080e7          	jalr	1378(ra) # 80006206 <uartintr>
    if(irq)
    80001cac:	a839                	j	80001cca <devintr+0x76>
      virtio_disk_intr();
    80001cae:	00004097          	auipc	ra,0x4
    80001cb2:	ab2080e7          	jalr	-1358(ra) # 80005760 <virtio_disk_intr>
    if(irq)
    80001cb6:	a811                	j	80001cca <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cb8:	85a6                	mv	a1,s1
    80001cba:	00006517          	auipc	a0,0x6
    80001cbe:	58e50513          	addi	a0,a0,1422 # 80008248 <etext+0x248>
    80001cc2:	00004097          	auipc	ra,0x4
    80001cc6:	0f4080e7          	jalr	244(ra) # 80005db6 <printf>
      plic_complete(irq);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	00003097          	auipc	ra,0x3
    80001cd0:	5e4080e7          	jalr	1508(ra) # 800052b0 <plic_complete>
    return 1;
    80001cd4:	4505                	li	a0,1
    80001cd6:	64a2                	ld	s1,8(sp)
    80001cd8:	b755                	j	80001c7c <devintr+0x28>
    if(cpuid() == 0){
    80001cda:	fffff097          	auipc	ra,0xfffff
    80001cde:	1c0080e7          	jalr	448(ra) # 80000e9a <cpuid>
    80001ce2:	c901                	beqz	a0,80001cf2 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ce4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ce8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cea:	14479073          	csrw	sip,a5
    return 2;
    80001cee:	4509                	li	a0,2
    80001cf0:	b771                	j	80001c7c <devintr+0x28>
      clockintr();
    80001cf2:	00000097          	auipc	ra,0x0
    80001cf6:	f1c080e7          	jalr	-228(ra) # 80001c0e <clockintr>
    80001cfa:	b7ed                	j	80001ce4 <devintr+0x90>
}
    80001cfc:	8082                	ret

0000000080001cfe <usertrap>:
{
    80001cfe:	1101                	addi	sp,sp,-32
    80001d00:	ec06                	sd	ra,24(sp)
    80001d02:	e822                	sd	s0,16(sp)
    80001d04:	e426                	sd	s1,8(sp)
    80001d06:	e04a                	sd	s2,0(sp)
    80001d08:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d0e:	1007f793          	andi	a5,a5,256
    80001d12:	e3ad                	bnez	a5,80001d74 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d14:	00003797          	auipc	a5,0x3
    80001d18:	46c78793          	addi	a5,a5,1132 # 80005180 <kernelvec>
    80001d1c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d20:	fffff097          	auipc	ra,0xfffff
    80001d24:	1a6080e7          	jalr	422(ra) # 80000ec6 <myproc>
    80001d28:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d2a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d2c:	14102773          	csrr	a4,sepc
    80001d30:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d32:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d36:	47a1                	li	a5,8
    80001d38:	04f71c63          	bne	a4,a5,80001d90 <usertrap+0x92>
    if(p->killed)
    80001d3c:	551c                	lw	a5,40(a0)
    80001d3e:	e3b9                	bnez	a5,80001d84 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d40:	6cb8                	ld	a4,88(s1)
    80001d42:	6f1c                	ld	a5,24(a4)
    80001d44:	0791                	addi	a5,a5,4
    80001d46:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d48:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d4c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d50:	10079073          	csrw	sstatus,a5
    syscall();
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	2e0080e7          	jalr	736(ra) # 80002034 <syscall>
  if(p->killed)
    80001d5c:	549c                	lw	a5,40(s1)
    80001d5e:	ebc1                	bnez	a5,80001dee <usertrap+0xf0>
  usertrapret();
    80001d60:	00000097          	auipc	ra,0x0
    80001d64:	e10080e7          	jalr	-496(ra) # 80001b70 <usertrapret>
}
    80001d68:	60e2                	ld	ra,24(sp)
    80001d6a:	6442                	ld	s0,16(sp)
    80001d6c:	64a2                	ld	s1,8(sp)
    80001d6e:	6902                	ld	s2,0(sp)
    80001d70:	6105                	addi	sp,sp,32
    80001d72:	8082                	ret
    panic("usertrap: not from user mode");
    80001d74:	00006517          	auipc	a0,0x6
    80001d78:	4f450513          	addi	a0,a0,1268 # 80008268 <etext+0x268>
    80001d7c:	00004097          	auipc	ra,0x4
    80001d80:	ff0080e7          	jalr	-16(ra) # 80005d6c <panic>
      exit(-1);
    80001d84:	557d                	li	a0,-1
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	a6e080e7          	jalr	-1426(ra) # 800017f4 <exit>
    80001d8e:	bf4d                	j	80001d40 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d90:	00000097          	auipc	ra,0x0
    80001d94:	ec4080e7          	jalr	-316(ra) # 80001c54 <devintr>
    80001d98:	892a                	mv	s2,a0
    80001d9a:	c501                	beqz	a0,80001da2 <usertrap+0xa4>
  if(p->killed)
    80001d9c:	549c                	lw	a5,40(s1)
    80001d9e:	c3a1                	beqz	a5,80001dde <usertrap+0xe0>
    80001da0:	a815                	j	80001dd4 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001da6:	5890                	lw	a2,48(s1)
    80001da8:	00006517          	auipc	a0,0x6
    80001dac:	4e050513          	addi	a0,a0,1248 # 80008288 <etext+0x288>
    80001db0:	00004097          	auipc	ra,0x4
    80001db4:	006080e7          	jalr	6(ra) # 80005db6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dbc:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dc0:	00006517          	auipc	a0,0x6
    80001dc4:	4f850513          	addi	a0,a0,1272 # 800082b8 <etext+0x2b8>
    80001dc8:	00004097          	auipc	ra,0x4
    80001dcc:	fee080e7          	jalr	-18(ra) # 80005db6 <printf>
    p->killed = 1;
    80001dd0:	4785                	li	a5,1
    80001dd2:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001dd4:	557d                	li	a0,-1
    80001dd6:	00000097          	auipc	ra,0x0
    80001dda:	a1e080e7          	jalr	-1506(ra) # 800017f4 <exit>
  if(which_dev == 2)
    80001dde:	4789                	li	a5,2
    80001de0:	f8f910e3          	bne	s2,a5,80001d60 <usertrap+0x62>
    yield();
    80001de4:	fffff097          	auipc	ra,0xfffff
    80001de8:	778080e7          	jalr	1912(ra) # 8000155c <yield>
    80001dec:	bf95                	j	80001d60 <usertrap+0x62>
  int which_dev = 0;
    80001dee:	4901                	li	s2,0
    80001df0:	b7d5                	j	80001dd4 <usertrap+0xd6>

0000000080001df2 <kerneltrap>:
{
    80001df2:	7179                	addi	sp,sp,-48
    80001df4:	f406                	sd	ra,40(sp)
    80001df6:	f022                	sd	s0,32(sp)
    80001df8:	ec26                	sd	s1,24(sp)
    80001dfa:	e84a                	sd	s2,16(sp)
    80001dfc:	e44e                	sd	s3,8(sp)
    80001dfe:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e00:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e04:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e08:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e0c:	1004f793          	andi	a5,s1,256
    80001e10:	cb85                	beqz	a5,80001e40 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e12:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e16:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e18:	ef85                	bnez	a5,80001e50 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e1a:	00000097          	auipc	ra,0x0
    80001e1e:	e3a080e7          	jalr	-454(ra) # 80001c54 <devintr>
    80001e22:	cd1d                	beqz	a0,80001e60 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e24:	4789                	li	a5,2
    80001e26:	06f50a63          	beq	a0,a5,80001e9a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e2a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2e:	10049073          	csrw	sstatus,s1
}
    80001e32:	70a2                	ld	ra,40(sp)
    80001e34:	7402                	ld	s0,32(sp)
    80001e36:	64e2                	ld	s1,24(sp)
    80001e38:	6942                	ld	s2,16(sp)
    80001e3a:	69a2                	ld	s3,8(sp)
    80001e3c:	6145                	addi	sp,sp,48
    80001e3e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e40:	00006517          	auipc	a0,0x6
    80001e44:	49850513          	addi	a0,a0,1176 # 800082d8 <etext+0x2d8>
    80001e48:	00004097          	auipc	ra,0x4
    80001e4c:	f24080e7          	jalr	-220(ra) # 80005d6c <panic>
    panic("kerneltrap: interrupts enabled");
    80001e50:	00006517          	auipc	a0,0x6
    80001e54:	4b050513          	addi	a0,a0,1200 # 80008300 <etext+0x300>
    80001e58:	00004097          	auipc	ra,0x4
    80001e5c:	f14080e7          	jalr	-236(ra) # 80005d6c <panic>
    printf("scause %p\n", scause);
    80001e60:	85ce                	mv	a1,s3
    80001e62:	00006517          	auipc	a0,0x6
    80001e66:	4be50513          	addi	a0,a0,1214 # 80008320 <etext+0x320>
    80001e6a:	00004097          	auipc	ra,0x4
    80001e6e:	f4c080e7          	jalr	-180(ra) # 80005db6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e72:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e76:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e7a:	00006517          	auipc	a0,0x6
    80001e7e:	4b650513          	addi	a0,a0,1206 # 80008330 <etext+0x330>
    80001e82:	00004097          	auipc	ra,0x4
    80001e86:	f34080e7          	jalr	-204(ra) # 80005db6 <printf>
    panic("kerneltrap");
    80001e8a:	00006517          	auipc	a0,0x6
    80001e8e:	4be50513          	addi	a0,a0,1214 # 80008348 <etext+0x348>
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	eda080e7          	jalr	-294(ra) # 80005d6c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e9a:	fffff097          	auipc	ra,0xfffff
    80001e9e:	02c080e7          	jalr	44(ra) # 80000ec6 <myproc>
    80001ea2:	d541                	beqz	a0,80001e2a <kerneltrap+0x38>
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	022080e7          	jalr	34(ra) # 80000ec6 <myproc>
    80001eac:	4d18                	lw	a4,24(a0)
    80001eae:	4791                	li	a5,4
    80001eb0:	f6f71de3          	bne	a4,a5,80001e2a <kerneltrap+0x38>
    yield();
    80001eb4:	fffff097          	auipc	ra,0xfffff
    80001eb8:	6a8080e7          	jalr	1704(ra) # 8000155c <yield>
    80001ebc:	b7bd                	j	80001e2a <kerneltrap+0x38>

0000000080001ebe <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ebe:	1101                	addi	sp,sp,-32
    80001ec0:	ec06                	sd	ra,24(sp)
    80001ec2:	e822                	sd	s0,16(sp)
    80001ec4:	e426                	sd	s1,8(sp)
    80001ec6:	1000                	addi	s0,sp,32
    80001ec8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	ffc080e7          	jalr	-4(ra) # 80000ec6 <myproc>
  switch (n) {
    80001ed2:	4795                	li	a5,5
    80001ed4:	0497e163          	bltu	a5,s1,80001f16 <argraw+0x58>
    80001ed8:	048a                	slli	s1,s1,0x2
    80001eda:	00007717          	auipc	a4,0x7
    80001ede:	91670713          	addi	a4,a4,-1770 # 800087f0 <states.0+0x30>
    80001ee2:	94ba                	add	s1,s1,a4
    80001ee4:	409c                	lw	a5,0(s1)
    80001ee6:	97ba                	add	a5,a5,a4
    80001ee8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eea:	6d3c                	ld	a5,88(a0)
    80001eec:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eee:	60e2                	ld	ra,24(sp)
    80001ef0:	6442                	ld	s0,16(sp)
    80001ef2:	64a2                	ld	s1,8(sp)
    80001ef4:	6105                	addi	sp,sp,32
    80001ef6:	8082                	ret
    return p->trapframe->a1;
    80001ef8:	6d3c                	ld	a5,88(a0)
    80001efa:	7fa8                	ld	a0,120(a5)
    80001efc:	bfcd                	j	80001eee <argraw+0x30>
    return p->trapframe->a2;
    80001efe:	6d3c                	ld	a5,88(a0)
    80001f00:	63c8                	ld	a0,128(a5)
    80001f02:	b7f5                	j	80001eee <argraw+0x30>
    return p->trapframe->a3;
    80001f04:	6d3c                	ld	a5,88(a0)
    80001f06:	67c8                	ld	a0,136(a5)
    80001f08:	b7dd                	j	80001eee <argraw+0x30>
    return p->trapframe->a4;
    80001f0a:	6d3c                	ld	a5,88(a0)
    80001f0c:	6bc8                	ld	a0,144(a5)
    80001f0e:	b7c5                	j	80001eee <argraw+0x30>
    return p->trapframe->a5;
    80001f10:	6d3c                	ld	a5,88(a0)
    80001f12:	6fc8                	ld	a0,152(a5)
    80001f14:	bfe9                	j	80001eee <argraw+0x30>
  panic("argraw");
    80001f16:	00006517          	auipc	a0,0x6
    80001f1a:	44250513          	addi	a0,a0,1090 # 80008358 <etext+0x358>
    80001f1e:	00004097          	auipc	ra,0x4
    80001f22:	e4e080e7          	jalr	-434(ra) # 80005d6c <panic>

0000000080001f26 <fetchaddr>:
{
    80001f26:	1101                	addi	sp,sp,-32
    80001f28:	ec06                	sd	ra,24(sp)
    80001f2a:	e822                	sd	s0,16(sp)
    80001f2c:	e426                	sd	s1,8(sp)
    80001f2e:	e04a                	sd	s2,0(sp)
    80001f30:	1000                	addi	s0,sp,32
    80001f32:	84aa                	mv	s1,a0
    80001f34:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	f90080e7          	jalr	-112(ra) # 80000ec6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f3e:	653c                	ld	a5,72(a0)
    80001f40:	02f4f863          	bgeu	s1,a5,80001f70 <fetchaddr+0x4a>
    80001f44:	00848713          	addi	a4,s1,8
    80001f48:	02e7e663          	bltu	a5,a4,80001f74 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f4c:	46a1                	li	a3,8
    80001f4e:	8626                	mv	a2,s1
    80001f50:	85ca                	mv	a1,s2
    80001f52:	6928                	ld	a0,80(a0)
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	c9a080e7          	jalr	-870(ra) # 80000bee <copyin>
    80001f5c:	00a03533          	snez	a0,a0
    80001f60:	40a00533          	neg	a0,a0
}
    80001f64:	60e2                	ld	ra,24(sp)
    80001f66:	6442                	ld	s0,16(sp)
    80001f68:	64a2                	ld	s1,8(sp)
    80001f6a:	6902                	ld	s2,0(sp)
    80001f6c:	6105                	addi	sp,sp,32
    80001f6e:	8082                	ret
    return -1;
    80001f70:	557d                	li	a0,-1
    80001f72:	bfcd                	j	80001f64 <fetchaddr+0x3e>
    80001f74:	557d                	li	a0,-1
    80001f76:	b7fd                	j	80001f64 <fetchaddr+0x3e>

0000000080001f78 <fetchstr>:
{
    80001f78:	7179                	addi	sp,sp,-48
    80001f7a:	f406                	sd	ra,40(sp)
    80001f7c:	f022                	sd	s0,32(sp)
    80001f7e:	ec26                	sd	s1,24(sp)
    80001f80:	e84a                	sd	s2,16(sp)
    80001f82:	e44e                	sd	s3,8(sp)
    80001f84:	1800                	addi	s0,sp,48
    80001f86:	892a                	mv	s2,a0
    80001f88:	84ae                	mv	s1,a1
    80001f8a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	f3a080e7          	jalr	-198(ra) # 80000ec6 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f94:	86ce                	mv	a3,s3
    80001f96:	864a                	mv	a2,s2
    80001f98:	85a6                	mv	a1,s1
    80001f9a:	6928                	ld	a0,80(a0)
    80001f9c:	fffff097          	auipc	ra,0xfffff
    80001fa0:	ce0080e7          	jalr	-800(ra) # 80000c7c <copyinstr>
  if(err < 0)
    80001fa4:	00054763          	bltz	a0,80001fb2 <fetchstr+0x3a>
  return strlen(buf);
    80001fa8:	8526                	mv	a0,s1
    80001faa:	ffffe097          	auipc	ra,0xffffe
    80001fae:	38e080e7          	jalr	910(ra) # 80000338 <strlen>
}
    80001fb2:	70a2                	ld	ra,40(sp)
    80001fb4:	7402                	ld	s0,32(sp)
    80001fb6:	64e2                	ld	s1,24(sp)
    80001fb8:	6942                	ld	s2,16(sp)
    80001fba:	69a2                	ld	s3,8(sp)
    80001fbc:	6145                	addi	sp,sp,48
    80001fbe:	8082                	ret

0000000080001fc0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fc0:	1101                	addi	sp,sp,-32
    80001fc2:	ec06                	sd	ra,24(sp)
    80001fc4:	e822                	sd	s0,16(sp)
    80001fc6:	e426                	sd	s1,8(sp)
    80001fc8:	1000                	addi	s0,sp,32
    80001fca:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fcc:	00000097          	auipc	ra,0x0
    80001fd0:	ef2080e7          	jalr	-270(ra) # 80001ebe <argraw>
    80001fd4:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fd6:	4501                	li	a0,0
    80001fd8:	60e2                	ld	ra,24(sp)
    80001fda:	6442                	ld	s0,16(sp)
    80001fdc:	64a2                	ld	s1,8(sp)
    80001fde:	6105                	addi	sp,sp,32
    80001fe0:	8082                	ret

0000000080001fe2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fe2:	1101                	addi	sp,sp,-32
    80001fe4:	ec06                	sd	ra,24(sp)
    80001fe6:	e822                	sd	s0,16(sp)
    80001fe8:	e426                	sd	s1,8(sp)
    80001fea:	1000                	addi	s0,sp,32
    80001fec:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	ed0080e7          	jalr	-304(ra) # 80001ebe <argraw>
    80001ff6:	e088                	sd	a0,0(s1)
  return 0;
}
    80001ff8:	4501                	li	a0,0
    80001ffa:	60e2                	ld	ra,24(sp)
    80001ffc:	6442                	ld	s0,16(sp)
    80001ffe:	64a2                	ld	s1,8(sp)
    80002000:	6105                	addi	sp,sp,32
    80002002:	8082                	ret

0000000080002004 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002004:	1101                	addi	sp,sp,-32
    80002006:	ec06                	sd	ra,24(sp)
    80002008:	e822                	sd	s0,16(sp)
    8000200a:	e426                	sd	s1,8(sp)
    8000200c:	e04a                	sd	s2,0(sp)
    8000200e:	1000                	addi	s0,sp,32
    80002010:	84ae                	mv	s1,a1
    80002012:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002014:	00000097          	auipc	ra,0x0
    80002018:	eaa080e7          	jalr	-342(ra) # 80001ebe <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000201c:	864a                	mv	a2,s2
    8000201e:	85a6                	mv	a1,s1
    80002020:	00000097          	auipc	ra,0x0
    80002024:	f58080e7          	jalr	-168(ra) # 80001f78 <fetchstr>
}
    80002028:	60e2                	ld	ra,24(sp)
    8000202a:	6442                	ld	s0,16(sp)
    8000202c:	64a2                	ld	s1,8(sp)
    8000202e:	6902                	ld	s2,0(sp)
    80002030:	6105                	addi	sp,sp,32
    80002032:	8082                	ret

0000000080002034 <syscall>:
};


void
syscall(void)
{
    80002034:	7179                	addi	sp,sp,-48
    80002036:	f406                	sd	ra,40(sp)
    80002038:	f022                	sd	s0,32(sp)
    8000203a:	ec26                	sd	s1,24(sp)
    8000203c:	e84a                	sd	s2,16(sp)
    8000203e:	e44e                	sd	s3,8(sp)
    80002040:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002042:	fffff097          	auipc	ra,0xfffff
    80002046:	e84080e7          	jalr	-380(ra) # 80000ec6 <myproc>
    8000204a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000204c:	05853903          	ld	s2,88(a0)
    80002050:	0a893783          	ld	a5,168(s2)
    80002054:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002058:	37fd                	addiw	a5,a5,-1
    8000205a:	4759                	li	a4,22
    8000205c:	04f76763          	bltu	a4,a5,800020aa <syscall+0x76>
    80002060:	00399713          	slli	a4,s3,0x3
    80002064:	00006797          	auipc	a5,0x6
    80002068:	7a478793          	addi	a5,a5,1956 # 80008808 <syscalls>
    8000206c:	97ba                	add	a5,a5,a4
    8000206e:	639c                	ld	a5,0(a5)
    80002070:	cf8d                	beqz	a5,800020aa <syscall+0x76>
    p->trapframe->a0 = syscalls[num]();
    80002072:	9782                	jalr	a5
    80002074:	06a93823          	sd	a0,112(s2)
    if((p->syscall_trace >> num) &1){
    80002078:	1684b783          	ld	a5,360(s1)
    8000207c:	0137d7b3          	srl	a5,a5,s3
    80002080:	8b85                	andi	a5,a5,1
    80002082:	c3b9                	beqz	a5,800020c8 <syscall+0x94>
        printf("%d: syscall %s -> %d\n",p->pid, syscall_names[num], p->trapframe->a0);
    80002084:	6cb8                	ld	a4,88(s1)
    80002086:	098e                	slli	s3,s3,0x3
    80002088:	00007797          	auipc	a5,0x7
    8000208c:	8a078793          	addi	a5,a5,-1888 # 80008928 <syscall_names>
    80002090:	97ce                	add	a5,a5,s3
    80002092:	7b34                	ld	a3,112(a4)
    80002094:	6390                	ld	a2,0(a5)
    80002096:	588c                	lw	a1,48(s1)
    80002098:	00006517          	auipc	a0,0x6
    8000209c:	2c850513          	addi	a0,a0,712 # 80008360 <etext+0x360>
    800020a0:	00004097          	auipc	ra,0x4
    800020a4:	d16080e7          	jalr	-746(ra) # 80005db6 <printf>
    800020a8:	a005                	j	800020c8 <syscall+0x94>
	}
  } 
  else {
    printf("%d %s: unknown sys call %d\n",
    800020aa:	86ce                	mv	a3,s3
    800020ac:	15848613          	addi	a2,s1,344
    800020b0:	588c                	lw	a1,48(s1)
    800020b2:	00006517          	auipc	a0,0x6
    800020b6:	2c650513          	addi	a0,a0,710 # 80008378 <etext+0x378>
    800020ba:	00004097          	auipc	ra,0x4
    800020be:	cfc080e7          	jalr	-772(ra) # 80005db6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020c2:	6cbc                	ld	a5,88(s1)
    800020c4:	577d                	li	a4,-1
    800020c6:	fbb8                	sd	a4,112(a5)
  }
}
    800020c8:	70a2                	ld	ra,40(sp)
    800020ca:	7402                	ld	s0,32(sp)
    800020cc:	64e2                	ld	s1,24(sp)
    800020ce:	6942                	ld	s2,16(sp)
    800020d0:	69a2                	ld	s3,8(sp)
    800020d2:	6145                	addi	sp,sp,48
    800020d4:	8082                	ret

00000000800020d6 <sys_trace>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_trace(void)//add for lab2
{
    800020d6:	7179                	addi	sp,sp,-48
    800020d8:	f406                	sd	ra,40(sp)
    800020da:	f022                	sd	s0,32(sp)
    800020dc:	1800                	addi	s0,sp,48
   int mask;
   if(argint(0, &mask)<0)
    800020de:	fdc40593          	addi	a1,s0,-36
    800020e2:	4501                	li	a0,0
    800020e4:	00000097          	auipc	ra,0x0
    800020e8:	edc080e7          	jalr	-292(ra) # 80001fc0 <argint>
      return -1;
    800020ec:	57fd                	li	a5,-1
   if(argint(0, &mask)<0)
    800020ee:	00054d63          	bltz	a0,80002108 <sys_trace+0x32>
    800020f2:	ec26                	sd	s1,24(sp)
   myproc()->syscall_trace = mask;
    800020f4:	fdc42483          	lw	s1,-36(s0)
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	dce080e7          	jalr	-562(ra) # 80000ec6 <myproc>
    80002100:	16953423          	sd	s1,360(a0)
   return 0;
    80002104:	4781                	li	a5,0
    80002106:	64e2                	ld	s1,24(sp)
}
    80002108:	853e                	mv	a0,a5
    8000210a:	70a2                	ld	ra,40(sp)
    8000210c:	7402                	ld	s0,32(sp)
    8000210e:	6145                	addi	sp,sp,48
    80002110:	8082                	ret

0000000080002112 <sys_sysinfo>:

uint64
sys_sysinfo(void)//add for lab2
{
    80002112:	7179                	addi	sp,sp,-48
    80002114:	f406                	sd	ra,40(sp)
    80002116:	f022                	sd	s0,32(sp)
    80002118:	1800                	addi	s0,sp,48
  // 从用户态读入一个指针，作为存放 sysinfo 结构的缓冲区
  uint64 addr;
  if(argaddr(0, &addr) < 0)
    8000211a:	fe840593          	addi	a1,s0,-24
    8000211e:	4501                	li	a0,0
    80002120:	00000097          	auipc	ra,0x0
    80002124:	ec2080e7          	jalr	-318(ra) # 80001fe2 <argaddr>
    80002128:	87aa                	mv	a5,a0
    return -1;
    8000212a:	557d                	li	a0,-1
  if(argaddr(0, &addr) < 0)
    8000212c:	0207cd63          	bltz	a5,80002166 <sys_sysinfo+0x54>
  
  struct sysinfo sinfo;
  sinfo.freemem = count_free_mem(); // kalloc.c
    80002130:	ffffe097          	auipc	ra,0xffffe
    80002134:	04a080e7          	jalr	74(ra) # 8000017a <count_free_mem>
    80002138:	fca43c23          	sd	a0,-40(s0)
  sinfo.nproc = count_process(); // proc.c
    8000213c:	00000097          	auipc	ra,0x0
    80002140:	95c080e7          	jalr	-1700(ra) # 80001a98 <count_process>
    80002144:	fea43023          	sd	a0,-32(s0)
  copyout(p->pagetable, addr, (char *)&data, sizeof(data)); // 将内核态的 data 变量（常为struct），结合进程的页表，写到进程内存空间内的 addr 地址处。

  */
  // 使用 copyout，结合当前进程的页表，获得进程传进来的指针（逻辑地址）对应的物理地址
  // 然后将 &sinfo 中的数据复制到该指针所指位置，供用户进程使用。
  if(copyout(myproc()->pagetable, addr, (char *)&sinfo, sizeof(sinfo)) < 0)
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	d7e080e7          	jalr	-642(ra) # 80000ec6 <myproc>
    80002150:	46c1                	li	a3,16
    80002152:	fd840613          	addi	a2,s0,-40
    80002156:	fe843583          	ld	a1,-24(s0)
    8000215a:	6928                	ld	a0,80(a0)
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	a06080e7          	jalr	-1530(ra) # 80000b62 <copyout>
    80002164:	957d                	srai	a0,a0,0x3f
    return -1;
  return 0;
}
    80002166:	70a2                	ld	ra,40(sp)
    80002168:	7402                	ld	s0,32(sp)
    8000216a:	6145                	addi	sp,sp,48
    8000216c:	8082                	ret

000000008000216e <sys_exit>:

uint64
sys_exit(void)
{
    8000216e:	1101                	addi	sp,sp,-32
    80002170:	ec06                	sd	ra,24(sp)
    80002172:	e822                	sd	s0,16(sp)
    80002174:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002176:	fec40593          	addi	a1,s0,-20
    8000217a:	4501                	li	a0,0
    8000217c:	00000097          	auipc	ra,0x0
    80002180:	e44080e7          	jalr	-444(ra) # 80001fc0 <argint>
    return -1;
    80002184:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002186:	00054963          	bltz	a0,80002198 <sys_exit+0x2a>
  exit(n);
    8000218a:	fec42503          	lw	a0,-20(s0)
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	666080e7          	jalr	1638(ra) # 800017f4 <exit>
  return 0;  // not reached
    80002196:	4781                	li	a5,0
}
    80002198:	853e                	mv	a0,a5
    8000219a:	60e2                	ld	ra,24(sp)
    8000219c:	6442                	ld	s0,16(sp)
    8000219e:	6105                	addi	sp,sp,32
    800021a0:	8082                	ret

00000000800021a2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021a2:	1141                	addi	sp,sp,-16
    800021a4:	e406                	sd	ra,8(sp)
    800021a6:	e022                	sd	s0,0(sp)
    800021a8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	d1c080e7          	jalr	-740(ra) # 80000ec6 <myproc>
}
    800021b2:	5908                	lw	a0,48(a0)
    800021b4:	60a2                	ld	ra,8(sp)
    800021b6:	6402                	ld	s0,0(sp)
    800021b8:	0141                	addi	sp,sp,16
    800021ba:	8082                	ret

00000000800021bc <sys_fork>:

uint64
sys_fork(void)
{
    800021bc:	1141                	addi	sp,sp,-16
    800021be:	e406                	sd	ra,8(sp)
    800021c0:	e022                	sd	s0,0(sp)
    800021c2:	0800                	addi	s0,sp,16
  return fork();
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	0d8080e7          	jalr	216(ra) # 8000129c <fork>
}
    800021cc:	60a2                	ld	ra,8(sp)
    800021ce:	6402                	ld	s0,0(sp)
    800021d0:	0141                	addi	sp,sp,16
    800021d2:	8082                	ret

00000000800021d4 <sys_wait>:

uint64
sys_wait(void)
{
    800021d4:	1101                	addi	sp,sp,-32
    800021d6:	ec06                	sd	ra,24(sp)
    800021d8:	e822                	sd	s0,16(sp)
    800021da:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021dc:	fe840593          	addi	a1,s0,-24
    800021e0:	4501                	li	a0,0
    800021e2:	00000097          	auipc	ra,0x0
    800021e6:	e00080e7          	jalr	-512(ra) # 80001fe2 <argaddr>
    800021ea:	87aa                	mv	a5,a0
    return -1;
    800021ec:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021ee:	0007c863          	bltz	a5,800021fe <sys_wait+0x2a>
  return wait(p);
    800021f2:	fe843503          	ld	a0,-24(s0)
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	406080e7          	jalr	1030(ra) # 800015fc <wait>
}
    800021fe:	60e2                	ld	ra,24(sp)
    80002200:	6442                	ld	s0,16(sp)
    80002202:	6105                	addi	sp,sp,32
    80002204:	8082                	ret

0000000080002206 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002206:	7179                	addi	sp,sp,-48
    80002208:	f406                	sd	ra,40(sp)
    8000220a:	f022                	sd	s0,32(sp)
    8000220c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000220e:	fdc40593          	addi	a1,s0,-36
    80002212:	4501                	li	a0,0
    80002214:	00000097          	auipc	ra,0x0
    80002218:	dac080e7          	jalr	-596(ra) # 80001fc0 <argint>
    8000221c:	87aa                	mv	a5,a0
    return -1;
    8000221e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002220:	0207c263          	bltz	a5,80002244 <sys_sbrk+0x3e>
    80002224:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    80002226:	fffff097          	auipc	ra,0xfffff
    8000222a:	ca0080e7          	jalr	-864(ra) # 80000ec6 <myproc>
    8000222e:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002230:	fdc42503          	lw	a0,-36(s0)
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	ff0080e7          	jalr	-16(ra) # 80001224 <growproc>
    8000223c:	00054863          	bltz	a0,8000224c <sys_sbrk+0x46>
    return -1;
  return addr;
    80002240:	8526                	mv	a0,s1
    80002242:	64e2                	ld	s1,24(sp)
}
    80002244:	70a2                	ld	ra,40(sp)
    80002246:	7402                	ld	s0,32(sp)
    80002248:	6145                	addi	sp,sp,48
    8000224a:	8082                	ret
    return -1;
    8000224c:	557d                	li	a0,-1
    8000224e:	64e2                	ld	s1,24(sp)
    80002250:	bfd5                	j	80002244 <sys_sbrk+0x3e>

0000000080002252 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002252:	7139                	addi	sp,sp,-64
    80002254:	fc06                	sd	ra,56(sp)
    80002256:	f822                	sd	s0,48(sp)
    80002258:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000225a:	fcc40593          	addi	a1,s0,-52
    8000225e:	4501                	li	a0,0
    80002260:	00000097          	auipc	ra,0x0
    80002264:	d60080e7          	jalr	-672(ra) # 80001fc0 <argint>
    return -1;
    80002268:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000226a:	06054b63          	bltz	a0,800022e0 <sys_sleep+0x8e>
    8000226e:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002270:	0000d517          	auipc	a0,0xd
    80002274:	e1050513          	addi	a0,a0,-496 # 8000f080 <tickslock>
    80002278:	00004097          	auipc	ra,0x4
    8000227c:	06e080e7          	jalr	110(ra) # 800062e6 <acquire>
  ticks0 = ticks;
    80002280:	00007917          	auipc	s2,0x7
    80002284:	d9892903          	lw	s2,-616(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002288:	fcc42783          	lw	a5,-52(s0)
    8000228c:	c3a1                	beqz	a5,800022cc <sys_sleep+0x7a>
    8000228e:	f426                	sd	s1,40(sp)
    80002290:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002292:	0000d997          	auipc	s3,0xd
    80002296:	dee98993          	addi	s3,s3,-530 # 8000f080 <tickslock>
    8000229a:	00007497          	auipc	s1,0x7
    8000229e:	d7e48493          	addi	s1,s1,-642 # 80009018 <ticks>
    if(myproc()->killed){
    800022a2:	fffff097          	auipc	ra,0xfffff
    800022a6:	c24080e7          	jalr	-988(ra) # 80000ec6 <myproc>
    800022aa:	551c                	lw	a5,40(a0)
    800022ac:	ef9d                	bnez	a5,800022ea <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022ae:	85ce                	mv	a1,s3
    800022b0:	8526                	mv	a0,s1
    800022b2:	fffff097          	auipc	ra,0xfffff
    800022b6:	2e6080e7          	jalr	742(ra) # 80001598 <sleep>
  while(ticks - ticks0 < n){
    800022ba:	409c                	lw	a5,0(s1)
    800022bc:	412787bb          	subw	a5,a5,s2
    800022c0:	fcc42703          	lw	a4,-52(s0)
    800022c4:	fce7efe3          	bltu	a5,a4,800022a2 <sys_sleep+0x50>
    800022c8:	74a2                	ld	s1,40(sp)
    800022ca:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800022cc:	0000d517          	auipc	a0,0xd
    800022d0:	db450513          	addi	a0,a0,-588 # 8000f080 <tickslock>
    800022d4:	00004097          	auipc	ra,0x4
    800022d8:	0c6080e7          	jalr	198(ra) # 8000639a <release>
  return 0;
    800022dc:	4781                	li	a5,0
    800022de:	7902                	ld	s2,32(sp)
}
    800022e0:	853e                	mv	a0,a5
    800022e2:	70e2                	ld	ra,56(sp)
    800022e4:	7442                	ld	s0,48(sp)
    800022e6:	6121                	addi	sp,sp,64
    800022e8:	8082                	ret
      release(&tickslock);
    800022ea:	0000d517          	auipc	a0,0xd
    800022ee:	d9650513          	addi	a0,a0,-618 # 8000f080 <tickslock>
    800022f2:	00004097          	auipc	ra,0x4
    800022f6:	0a8080e7          	jalr	168(ra) # 8000639a <release>
      return -1;
    800022fa:	57fd                	li	a5,-1
    800022fc:	74a2                	ld	s1,40(sp)
    800022fe:	7902                	ld	s2,32(sp)
    80002300:	69e2                	ld	s3,24(sp)
    80002302:	bff9                	j	800022e0 <sys_sleep+0x8e>

0000000080002304 <sys_kill>:

uint64
sys_kill(void)
{
    80002304:	1101                	addi	sp,sp,-32
    80002306:	ec06                	sd	ra,24(sp)
    80002308:	e822                	sd	s0,16(sp)
    8000230a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000230c:	fec40593          	addi	a1,s0,-20
    80002310:	4501                	li	a0,0
    80002312:	00000097          	auipc	ra,0x0
    80002316:	cae080e7          	jalr	-850(ra) # 80001fc0 <argint>
    8000231a:	87aa                	mv	a5,a0
    return -1;
    8000231c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000231e:	0007c863          	bltz	a5,8000232e <sys_kill+0x2a>
  return kill(pid);
    80002322:	fec42503          	lw	a0,-20(s0)
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	5a4080e7          	jalr	1444(ra) # 800018ca <kill>
}
    8000232e:	60e2                	ld	ra,24(sp)
    80002330:	6442                	ld	s0,16(sp)
    80002332:	6105                	addi	sp,sp,32
    80002334:	8082                	ret

0000000080002336 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002336:	1101                	addi	sp,sp,-32
    80002338:	ec06                	sd	ra,24(sp)
    8000233a:	e822                	sd	s0,16(sp)
    8000233c:	e426                	sd	s1,8(sp)
    8000233e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002340:	0000d517          	auipc	a0,0xd
    80002344:	d4050513          	addi	a0,a0,-704 # 8000f080 <tickslock>
    80002348:	00004097          	auipc	ra,0x4
    8000234c:	f9e080e7          	jalr	-98(ra) # 800062e6 <acquire>
  xticks = ticks;
    80002350:	00007497          	auipc	s1,0x7
    80002354:	cc84a483          	lw	s1,-824(s1) # 80009018 <ticks>
  release(&tickslock);
    80002358:	0000d517          	auipc	a0,0xd
    8000235c:	d2850513          	addi	a0,a0,-728 # 8000f080 <tickslock>
    80002360:	00004097          	auipc	ra,0x4
    80002364:	03a080e7          	jalr	58(ra) # 8000639a <release>
  return xticks;
}
    80002368:	02049513          	slli	a0,s1,0x20
    8000236c:	9101                	srli	a0,a0,0x20
    8000236e:	60e2                	ld	ra,24(sp)
    80002370:	6442                	ld	s0,16(sp)
    80002372:	64a2                	ld	s1,8(sp)
    80002374:	6105                	addi	sp,sp,32
    80002376:	8082                	ret

0000000080002378 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002378:	7179                	addi	sp,sp,-48
    8000237a:	f406                	sd	ra,40(sp)
    8000237c:	f022                	sd	s0,32(sp)
    8000237e:	ec26                	sd	s1,24(sp)
    80002380:	e84a                	sd	s2,16(sp)
    80002382:	e44e                	sd	s3,8(sp)
    80002384:	e052                	sd	s4,0(sp)
    80002386:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002388:	00006597          	auipc	a1,0x6
    8000238c:	0c058593          	addi	a1,a1,192 # 80008448 <etext+0x448>
    80002390:	0000d517          	auipc	a0,0xd
    80002394:	d0850513          	addi	a0,a0,-760 # 8000f098 <bcache>
    80002398:	00004097          	auipc	ra,0x4
    8000239c:	ebe080e7          	jalr	-322(ra) # 80006256 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023a0:	00015797          	auipc	a5,0x15
    800023a4:	cf878793          	addi	a5,a5,-776 # 80017098 <bcache+0x8000>
    800023a8:	00015717          	auipc	a4,0x15
    800023ac:	f5870713          	addi	a4,a4,-168 # 80017300 <bcache+0x8268>
    800023b0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023b4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023b8:	0000d497          	auipc	s1,0xd
    800023bc:	cf848493          	addi	s1,s1,-776 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800023c0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023c2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023c4:	00006a17          	auipc	s4,0x6
    800023c8:	08ca0a13          	addi	s4,s4,140 # 80008450 <etext+0x450>
    b->next = bcache.head.next;
    800023cc:	2b893783          	ld	a5,696(s2)
    800023d0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023d2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023d6:	85d2                	mv	a1,s4
    800023d8:	01048513          	addi	a0,s1,16
    800023dc:	00001097          	auipc	ra,0x1
    800023e0:	4b2080e7          	jalr	1202(ra) # 8000388e <initsleeplock>
    bcache.head.next->prev = b;
    800023e4:	2b893783          	ld	a5,696(s2)
    800023e8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023ea:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ee:	45848493          	addi	s1,s1,1112
    800023f2:	fd349de3          	bne	s1,s3,800023cc <binit+0x54>
  }
}
    800023f6:	70a2                	ld	ra,40(sp)
    800023f8:	7402                	ld	s0,32(sp)
    800023fa:	64e2                	ld	s1,24(sp)
    800023fc:	6942                	ld	s2,16(sp)
    800023fe:	69a2                	ld	s3,8(sp)
    80002400:	6a02                	ld	s4,0(sp)
    80002402:	6145                	addi	sp,sp,48
    80002404:	8082                	ret

0000000080002406 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002406:	7179                	addi	sp,sp,-48
    80002408:	f406                	sd	ra,40(sp)
    8000240a:	f022                	sd	s0,32(sp)
    8000240c:	ec26                	sd	s1,24(sp)
    8000240e:	e84a                	sd	s2,16(sp)
    80002410:	e44e                	sd	s3,8(sp)
    80002412:	1800                	addi	s0,sp,48
    80002414:	892a                	mv	s2,a0
    80002416:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002418:	0000d517          	auipc	a0,0xd
    8000241c:	c8050513          	addi	a0,a0,-896 # 8000f098 <bcache>
    80002420:	00004097          	auipc	ra,0x4
    80002424:	ec6080e7          	jalr	-314(ra) # 800062e6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002428:	00015497          	auipc	s1,0x15
    8000242c:	f284b483          	ld	s1,-216(s1) # 80017350 <bcache+0x82b8>
    80002430:	00015797          	auipc	a5,0x15
    80002434:	ed078793          	addi	a5,a5,-304 # 80017300 <bcache+0x8268>
    80002438:	02f48f63          	beq	s1,a5,80002476 <bread+0x70>
    8000243c:	873e                	mv	a4,a5
    8000243e:	a021                	j	80002446 <bread+0x40>
    80002440:	68a4                	ld	s1,80(s1)
    80002442:	02e48a63          	beq	s1,a4,80002476 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002446:	449c                	lw	a5,8(s1)
    80002448:	ff279ce3          	bne	a5,s2,80002440 <bread+0x3a>
    8000244c:	44dc                	lw	a5,12(s1)
    8000244e:	ff3799e3          	bne	a5,s3,80002440 <bread+0x3a>
      b->refcnt++;
    80002452:	40bc                	lw	a5,64(s1)
    80002454:	2785                	addiw	a5,a5,1
    80002456:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002458:	0000d517          	auipc	a0,0xd
    8000245c:	c4050513          	addi	a0,a0,-960 # 8000f098 <bcache>
    80002460:	00004097          	auipc	ra,0x4
    80002464:	f3a080e7          	jalr	-198(ra) # 8000639a <release>
      acquiresleep(&b->lock);
    80002468:	01048513          	addi	a0,s1,16
    8000246c:	00001097          	auipc	ra,0x1
    80002470:	45c080e7          	jalr	1116(ra) # 800038c8 <acquiresleep>
      return b;
    80002474:	a8b9                	j	800024d2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002476:	00015497          	auipc	s1,0x15
    8000247a:	ed24b483          	ld	s1,-302(s1) # 80017348 <bcache+0x82b0>
    8000247e:	00015797          	auipc	a5,0x15
    80002482:	e8278793          	addi	a5,a5,-382 # 80017300 <bcache+0x8268>
    80002486:	00f48863          	beq	s1,a5,80002496 <bread+0x90>
    8000248a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000248c:	40bc                	lw	a5,64(s1)
    8000248e:	cf81                	beqz	a5,800024a6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002490:	64a4                	ld	s1,72(s1)
    80002492:	fee49de3          	bne	s1,a4,8000248c <bread+0x86>
  panic("bget: no buffers");
    80002496:	00006517          	auipc	a0,0x6
    8000249a:	fc250513          	addi	a0,a0,-62 # 80008458 <etext+0x458>
    8000249e:	00004097          	auipc	ra,0x4
    800024a2:	8ce080e7          	jalr	-1842(ra) # 80005d6c <panic>
      b->dev = dev;
    800024a6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024aa:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024ae:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024b2:	4785                	li	a5,1
    800024b4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024b6:	0000d517          	auipc	a0,0xd
    800024ba:	be250513          	addi	a0,a0,-1054 # 8000f098 <bcache>
    800024be:	00004097          	auipc	ra,0x4
    800024c2:	edc080e7          	jalr	-292(ra) # 8000639a <release>
      acquiresleep(&b->lock);
    800024c6:	01048513          	addi	a0,s1,16
    800024ca:	00001097          	auipc	ra,0x1
    800024ce:	3fe080e7          	jalr	1022(ra) # 800038c8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024d2:	409c                	lw	a5,0(s1)
    800024d4:	cb89                	beqz	a5,800024e6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024d6:	8526                	mv	a0,s1
    800024d8:	70a2                	ld	ra,40(sp)
    800024da:	7402                	ld	s0,32(sp)
    800024dc:	64e2                	ld	s1,24(sp)
    800024de:	6942                	ld	s2,16(sp)
    800024e0:	69a2                	ld	s3,8(sp)
    800024e2:	6145                	addi	sp,sp,48
    800024e4:	8082                	ret
    virtio_disk_rw(b, 0);
    800024e6:	4581                	li	a1,0
    800024e8:	8526                	mv	a0,s1
    800024ea:	00003097          	auipc	ra,0x3
    800024ee:	fe8080e7          	jalr	-24(ra) # 800054d2 <virtio_disk_rw>
    b->valid = 1;
    800024f2:	4785                	li	a5,1
    800024f4:	c09c                	sw	a5,0(s1)
  return b;
    800024f6:	b7c5                	j	800024d6 <bread+0xd0>

00000000800024f8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024f8:	1101                	addi	sp,sp,-32
    800024fa:	ec06                	sd	ra,24(sp)
    800024fc:	e822                	sd	s0,16(sp)
    800024fe:	e426                	sd	s1,8(sp)
    80002500:	1000                	addi	s0,sp,32
    80002502:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002504:	0541                	addi	a0,a0,16
    80002506:	00001097          	auipc	ra,0x1
    8000250a:	45c080e7          	jalr	1116(ra) # 80003962 <holdingsleep>
    8000250e:	cd01                	beqz	a0,80002526 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002510:	4585                	li	a1,1
    80002512:	8526                	mv	a0,s1
    80002514:	00003097          	auipc	ra,0x3
    80002518:	fbe080e7          	jalr	-66(ra) # 800054d2 <virtio_disk_rw>
}
    8000251c:	60e2                	ld	ra,24(sp)
    8000251e:	6442                	ld	s0,16(sp)
    80002520:	64a2                	ld	s1,8(sp)
    80002522:	6105                	addi	sp,sp,32
    80002524:	8082                	ret
    panic("bwrite");
    80002526:	00006517          	auipc	a0,0x6
    8000252a:	f4a50513          	addi	a0,a0,-182 # 80008470 <etext+0x470>
    8000252e:	00004097          	auipc	ra,0x4
    80002532:	83e080e7          	jalr	-1986(ra) # 80005d6c <panic>

0000000080002536 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002536:	1101                	addi	sp,sp,-32
    80002538:	ec06                	sd	ra,24(sp)
    8000253a:	e822                	sd	s0,16(sp)
    8000253c:	e426                	sd	s1,8(sp)
    8000253e:	e04a                	sd	s2,0(sp)
    80002540:	1000                	addi	s0,sp,32
    80002542:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002544:	01050913          	addi	s2,a0,16
    80002548:	854a                	mv	a0,s2
    8000254a:	00001097          	auipc	ra,0x1
    8000254e:	418080e7          	jalr	1048(ra) # 80003962 <holdingsleep>
    80002552:	c925                	beqz	a0,800025c2 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002554:	854a                	mv	a0,s2
    80002556:	00001097          	auipc	ra,0x1
    8000255a:	3c8080e7          	jalr	968(ra) # 8000391e <releasesleep>

  acquire(&bcache.lock);
    8000255e:	0000d517          	auipc	a0,0xd
    80002562:	b3a50513          	addi	a0,a0,-1222 # 8000f098 <bcache>
    80002566:	00004097          	auipc	ra,0x4
    8000256a:	d80080e7          	jalr	-640(ra) # 800062e6 <acquire>
  b->refcnt--;
    8000256e:	40bc                	lw	a5,64(s1)
    80002570:	37fd                	addiw	a5,a5,-1
    80002572:	0007871b          	sext.w	a4,a5
    80002576:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002578:	e71d                	bnez	a4,800025a6 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000257a:	68b8                	ld	a4,80(s1)
    8000257c:	64bc                	ld	a5,72(s1)
    8000257e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002580:	68b8                	ld	a4,80(s1)
    80002582:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002584:	00015797          	auipc	a5,0x15
    80002588:	b1478793          	addi	a5,a5,-1260 # 80017098 <bcache+0x8000>
    8000258c:	2b87b703          	ld	a4,696(a5)
    80002590:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002592:	00015717          	auipc	a4,0x15
    80002596:	d6e70713          	addi	a4,a4,-658 # 80017300 <bcache+0x8268>
    8000259a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000259c:	2b87b703          	ld	a4,696(a5)
    800025a0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025a2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025a6:	0000d517          	auipc	a0,0xd
    800025aa:	af250513          	addi	a0,a0,-1294 # 8000f098 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	dec080e7          	jalr	-532(ra) # 8000639a <release>
}
    800025b6:	60e2                	ld	ra,24(sp)
    800025b8:	6442                	ld	s0,16(sp)
    800025ba:	64a2                	ld	s1,8(sp)
    800025bc:	6902                	ld	s2,0(sp)
    800025be:	6105                	addi	sp,sp,32
    800025c0:	8082                	ret
    panic("brelse");
    800025c2:	00006517          	auipc	a0,0x6
    800025c6:	eb650513          	addi	a0,a0,-330 # 80008478 <etext+0x478>
    800025ca:	00003097          	auipc	ra,0x3
    800025ce:	7a2080e7          	jalr	1954(ra) # 80005d6c <panic>

00000000800025d2 <bpin>:

void
bpin(struct buf *b) {
    800025d2:	1101                	addi	sp,sp,-32
    800025d4:	ec06                	sd	ra,24(sp)
    800025d6:	e822                	sd	s0,16(sp)
    800025d8:	e426                	sd	s1,8(sp)
    800025da:	1000                	addi	s0,sp,32
    800025dc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025de:	0000d517          	auipc	a0,0xd
    800025e2:	aba50513          	addi	a0,a0,-1350 # 8000f098 <bcache>
    800025e6:	00004097          	auipc	ra,0x4
    800025ea:	d00080e7          	jalr	-768(ra) # 800062e6 <acquire>
  b->refcnt++;
    800025ee:	40bc                	lw	a5,64(s1)
    800025f0:	2785                	addiw	a5,a5,1
    800025f2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025f4:	0000d517          	auipc	a0,0xd
    800025f8:	aa450513          	addi	a0,a0,-1372 # 8000f098 <bcache>
    800025fc:	00004097          	auipc	ra,0x4
    80002600:	d9e080e7          	jalr	-610(ra) # 8000639a <release>
}
    80002604:	60e2                	ld	ra,24(sp)
    80002606:	6442                	ld	s0,16(sp)
    80002608:	64a2                	ld	s1,8(sp)
    8000260a:	6105                	addi	sp,sp,32
    8000260c:	8082                	ret

000000008000260e <bunpin>:

void
bunpin(struct buf *b) {
    8000260e:	1101                	addi	sp,sp,-32
    80002610:	ec06                	sd	ra,24(sp)
    80002612:	e822                	sd	s0,16(sp)
    80002614:	e426                	sd	s1,8(sp)
    80002616:	1000                	addi	s0,sp,32
    80002618:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000261a:	0000d517          	auipc	a0,0xd
    8000261e:	a7e50513          	addi	a0,a0,-1410 # 8000f098 <bcache>
    80002622:	00004097          	auipc	ra,0x4
    80002626:	cc4080e7          	jalr	-828(ra) # 800062e6 <acquire>
  b->refcnt--;
    8000262a:	40bc                	lw	a5,64(s1)
    8000262c:	37fd                	addiw	a5,a5,-1
    8000262e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002630:	0000d517          	auipc	a0,0xd
    80002634:	a6850513          	addi	a0,a0,-1432 # 8000f098 <bcache>
    80002638:	00004097          	auipc	ra,0x4
    8000263c:	d62080e7          	jalr	-670(ra) # 8000639a <release>
}
    80002640:	60e2                	ld	ra,24(sp)
    80002642:	6442                	ld	s0,16(sp)
    80002644:	64a2                	ld	s1,8(sp)
    80002646:	6105                	addi	sp,sp,32
    80002648:	8082                	ret

000000008000264a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000264a:	1101                	addi	sp,sp,-32
    8000264c:	ec06                	sd	ra,24(sp)
    8000264e:	e822                	sd	s0,16(sp)
    80002650:	e426                	sd	s1,8(sp)
    80002652:	e04a                	sd	s2,0(sp)
    80002654:	1000                	addi	s0,sp,32
    80002656:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002658:	00d5d59b          	srliw	a1,a1,0xd
    8000265c:	00015797          	auipc	a5,0x15
    80002660:	1187a783          	lw	a5,280(a5) # 80017774 <sb+0x1c>
    80002664:	9dbd                	addw	a1,a1,a5
    80002666:	00000097          	auipc	ra,0x0
    8000266a:	da0080e7          	jalr	-608(ra) # 80002406 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000266e:	0074f713          	andi	a4,s1,7
    80002672:	4785                	li	a5,1
    80002674:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002678:	14ce                	slli	s1,s1,0x33
    8000267a:	90d9                	srli	s1,s1,0x36
    8000267c:	00950733          	add	a4,a0,s1
    80002680:	05874703          	lbu	a4,88(a4)
    80002684:	00e7f6b3          	and	a3,a5,a4
    80002688:	c69d                	beqz	a3,800026b6 <bfree+0x6c>
    8000268a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000268c:	94aa                	add	s1,s1,a0
    8000268e:	fff7c793          	not	a5,a5
    80002692:	8f7d                	and	a4,a4,a5
    80002694:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002698:	00001097          	auipc	ra,0x1
    8000269c:	112080e7          	jalr	274(ra) # 800037aa <log_write>
  brelse(bp);
    800026a0:	854a                	mv	a0,s2
    800026a2:	00000097          	auipc	ra,0x0
    800026a6:	e94080e7          	jalr	-364(ra) # 80002536 <brelse>
}
    800026aa:	60e2                	ld	ra,24(sp)
    800026ac:	6442                	ld	s0,16(sp)
    800026ae:	64a2                	ld	s1,8(sp)
    800026b0:	6902                	ld	s2,0(sp)
    800026b2:	6105                	addi	sp,sp,32
    800026b4:	8082                	ret
    panic("freeing free block");
    800026b6:	00006517          	auipc	a0,0x6
    800026ba:	dca50513          	addi	a0,a0,-566 # 80008480 <etext+0x480>
    800026be:	00003097          	auipc	ra,0x3
    800026c2:	6ae080e7          	jalr	1710(ra) # 80005d6c <panic>

00000000800026c6 <balloc>:
{
    800026c6:	711d                	addi	sp,sp,-96
    800026c8:	ec86                	sd	ra,88(sp)
    800026ca:	e8a2                	sd	s0,80(sp)
    800026cc:	e4a6                	sd	s1,72(sp)
    800026ce:	e0ca                	sd	s2,64(sp)
    800026d0:	fc4e                	sd	s3,56(sp)
    800026d2:	f852                	sd	s4,48(sp)
    800026d4:	f456                	sd	s5,40(sp)
    800026d6:	f05a                	sd	s6,32(sp)
    800026d8:	ec5e                	sd	s7,24(sp)
    800026da:	e862                	sd	s8,16(sp)
    800026dc:	e466                	sd	s9,8(sp)
    800026de:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026e0:	00015797          	auipc	a5,0x15
    800026e4:	07c7a783          	lw	a5,124(a5) # 8001775c <sb+0x4>
    800026e8:	cbc1                	beqz	a5,80002778 <balloc+0xb2>
    800026ea:	8baa                	mv	s7,a0
    800026ec:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026ee:	00015b17          	auipc	s6,0x15
    800026f2:	06ab0b13          	addi	s6,s6,106 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026f6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026f8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026fa:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026fc:	6c89                	lui	s9,0x2
    800026fe:	a831                	j	8000271a <balloc+0x54>
    brelse(bp);
    80002700:	854a                	mv	a0,s2
    80002702:	00000097          	auipc	ra,0x0
    80002706:	e34080e7          	jalr	-460(ra) # 80002536 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000270a:	015c87bb          	addw	a5,s9,s5
    8000270e:	00078a9b          	sext.w	s5,a5
    80002712:	004b2703          	lw	a4,4(s6)
    80002716:	06eaf163          	bgeu	s5,a4,80002778 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000271a:	41fad79b          	sraiw	a5,s5,0x1f
    8000271e:	0137d79b          	srliw	a5,a5,0x13
    80002722:	015787bb          	addw	a5,a5,s5
    80002726:	40d7d79b          	sraiw	a5,a5,0xd
    8000272a:	01cb2583          	lw	a1,28(s6)
    8000272e:	9dbd                	addw	a1,a1,a5
    80002730:	855e                	mv	a0,s7
    80002732:	00000097          	auipc	ra,0x0
    80002736:	cd4080e7          	jalr	-812(ra) # 80002406 <bread>
    8000273a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000273c:	004b2503          	lw	a0,4(s6)
    80002740:	000a849b          	sext.w	s1,s5
    80002744:	8762                	mv	a4,s8
    80002746:	faa4fde3          	bgeu	s1,a0,80002700 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000274a:	00777693          	andi	a3,a4,7
    8000274e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002752:	41f7579b          	sraiw	a5,a4,0x1f
    80002756:	01d7d79b          	srliw	a5,a5,0x1d
    8000275a:	9fb9                	addw	a5,a5,a4
    8000275c:	4037d79b          	sraiw	a5,a5,0x3
    80002760:	00f90633          	add	a2,s2,a5
    80002764:	05864603          	lbu	a2,88(a2)
    80002768:	00c6f5b3          	and	a1,a3,a2
    8000276c:	cd91                	beqz	a1,80002788 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000276e:	2705                	addiw	a4,a4,1
    80002770:	2485                	addiw	s1,s1,1
    80002772:	fd471ae3          	bne	a4,s4,80002746 <balloc+0x80>
    80002776:	b769                	j	80002700 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002778:	00006517          	auipc	a0,0x6
    8000277c:	d2050513          	addi	a0,a0,-736 # 80008498 <etext+0x498>
    80002780:	00003097          	auipc	ra,0x3
    80002784:	5ec080e7          	jalr	1516(ra) # 80005d6c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002788:	97ca                	add	a5,a5,s2
    8000278a:	8e55                	or	a2,a2,a3
    8000278c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002790:	854a                	mv	a0,s2
    80002792:	00001097          	auipc	ra,0x1
    80002796:	018080e7          	jalr	24(ra) # 800037aa <log_write>
        brelse(bp);
    8000279a:	854a                	mv	a0,s2
    8000279c:	00000097          	auipc	ra,0x0
    800027a0:	d9a080e7          	jalr	-614(ra) # 80002536 <brelse>
  bp = bread(dev, bno);
    800027a4:	85a6                	mv	a1,s1
    800027a6:	855e                	mv	a0,s7
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	c5e080e7          	jalr	-930(ra) # 80002406 <bread>
    800027b0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027b2:	40000613          	li	a2,1024
    800027b6:	4581                	li	a1,0
    800027b8:	05850513          	addi	a0,a0,88
    800027bc:	ffffe097          	auipc	ra,0xffffe
    800027c0:	a08080e7          	jalr	-1528(ra) # 800001c4 <memset>
  log_write(bp);
    800027c4:	854a                	mv	a0,s2
    800027c6:	00001097          	auipc	ra,0x1
    800027ca:	fe4080e7          	jalr	-28(ra) # 800037aa <log_write>
  brelse(bp);
    800027ce:	854a                	mv	a0,s2
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	d66080e7          	jalr	-666(ra) # 80002536 <brelse>
}
    800027d8:	8526                	mv	a0,s1
    800027da:	60e6                	ld	ra,88(sp)
    800027dc:	6446                	ld	s0,80(sp)
    800027de:	64a6                	ld	s1,72(sp)
    800027e0:	6906                	ld	s2,64(sp)
    800027e2:	79e2                	ld	s3,56(sp)
    800027e4:	7a42                	ld	s4,48(sp)
    800027e6:	7aa2                	ld	s5,40(sp)
    800027e8:	7b02                	ld	s6,32(sp)
    800027ea:	6be2                	ld	s7,24(sp)
    800027ec:	6c42                	ld	s8,16(sp)
    800027ee:	6ca2                	ld	s9,8(sp)
    800027f0:	6125                	addi	sp,sp,96
    800027f2:	8082                	ret

00000000800027f4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027f4:	7179                	addi	sp,sp,-48
    800027f6:	f406                	sd	ra,40(sp)
    800027f8:	f022                	sd	s0,32(sp)
    800027fa:	ec26                	sd	s1,24(sp)
    800027fc:	e84a                	sd	s2,16(sp)
    800027fe:	e44e                	sd	s3,8(sp)
    80002800:	1800                	addi	s0,sp,48
    80002802:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002804:	47ad                	li	a5,11
    80002806:	04b7ff63          	bgeu	a5,a1,80002864 <bmap+0x70>
    8000280a:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000280c:	ff45849b          	addiw	s1,a1,-12
    80002810:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002814:	0ff00793          	li	a5,255
    80002818:	0ae7e463          	bltu	a5,a4,800028c0 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000281c:	08052583          	lw	a1,128(a0)
    80002820:	c5b5                	beqz	a1,8000288c <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002822:	00092503          	lw	a0,0(s2)
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	be0080e7          	jalr	-1056(ra) # 80002406 <bread>
    8000282e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002830:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002834:	02049713          	slli	a4,s1,0x20
    80002838:	01e75593          	srli	a1,a4,0x1e
    8000283c:	00b784b3          	add	s1,a5,a1
    80002840:	0004a983          	lw	s3,0(s1)
    80002844:	04098e63          	beqz	s3,800028a0 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002848:	8552                	mv	a0,s4
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	cec080e7          	jalr	-788(ra) # 80002536 <brelse>
    return addr;
    80002852:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002854:	854e                	mv	a0,s3
    80002856:	70a2                	ld	ra,40(sp)
    80002858:	7402                	ld	s0,32(sp)
    8000285a:	64e2                	ld	s1,24(sp)
    8000285c:	6942                	ld	s2,16(sp)
    8000285e:	69a2                	ld	s3,8(sp)
    80002860:	6145                	addi	sp,sp,48
    80002862:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002864:	02059793          	slli	a5,a1,0x20
    80002868:	01e7d593          	srli	a1,a5,0x1e
    8000286c:	00b504b3          	add	s1,a0,a1
    80002870:	0504a983          	lw	s3,80(s1)
    80002874:	fe0990e3          	bnez	s3,80002854 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002878:	4108                	lw	a0,0(a0)
    8000287a:	00000097          	auipc	ra,0x0
    8000287e:	e4c080e7          	jalr	-436(ra) # 800026c6 <balloc>
    80002882:	0005099b          	sext.w	s3,a0
    80002886:	0534a823          	sw	s3,80(s1)
    8000288a:	b7e9                	j	80002854 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000288c:	4108                	lw	a0,0(a0)
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	e38080e7          	jalr	-456(ra) # 800026c6 <balloc>
    80002896:	0005059b          	sext.w	a1,a0
    8000289a:	08b92023          	sw	a1,128(s2)
    8000289e:	b751                	j	80002822 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800028a0:	00092503          	lw	a0,0(s2)
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	e22080e7          	jalr	-478(ra) # 800026c6 <balloc>
    800028ac:	0005099b          	sext.w	s3,a0
    800028b0:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028b4:	8552                	mv	a0,s4
    800028b6:	00001097          	auipc	ra,0x1
    800028ba:	ef4080e7          	jalr	-268(ra) # 800037aa <log_write>
    800028be:	b769                	j	80002848 <bmap+0x54>
  panic("bmap: out of range");
    800028c0:	00006517          	auipc	a0,0x6
    800028c4:	bf050513          	addi	a0,a0,-1040 # 800084b0 <etext+0x4b0>
    800028c8:	00003097          	auipc	ra,0x3
    800028cc:	4a4080e7          	jalr	1188(ra) # 80005d6c <panic>

00000000800028d0 <iget>:
{
    800028d0:	7179                	addi	sp,sp,-48
    800028d2:	f406                	sd	ra,40(sp)
    800028d4:	f022                	sd	s0,32(sp)
    800028d6:	ec26                	sd	s1,24(sp)
    800028d8:	e84a                	sd	s2,16(sp)
    800028da:	e44e                	sd	s3,8(sp)
    800028dc:	e052                	sd	s4,0(sp)
    800028de:	1800                	addi	s0,sp,48
    800028e0:	89aa                	mv	s3,a0
    800028e2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028e4:	00015517          	auipc	a0,0x15
    800028e8:	e9450513          	addi	a0,a0,-364 # 80017778 <itable>
    800028ec:	00004097          	auipc	ra,0x4
    800028f0:	9fa080e7          	jalr	-1542(ra) # 800062e6 <acquire>
  empty = 0;
    800028f4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028f6:	00015497          	auipc	s1,0x15
    800028fa:	e9a48493          	addi	s1,s1,-358 # 80017790 <itable+0x18>
    800028fe:	00017697          	auipc	a3,0x17
    80002902:	92268693          	addi	a3,a3,-1758 # 80019220 <log>
    80002906:	a039                	j	80002914 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002908:	02090b63          	beqz	s2,8000293e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000290c:	08848493          	addi	s1,s1,136
    80002910:	02d48a63          	beq	s1,a3,80002944 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002914:	449c                	lw	a5,8(s1)
    80002916:	fef059e3          	blez	a5,80002908 <iget+0x38>
    8000291a:	4098                	lw	a4,0(s1)
    8000291c:	ff3716e3          	bne	a4,s3,80002908 <iget+0x38>
    80002920:	40d8                	lw	a4,4(s1)
    80002922:	ff4713e3          	bne	a4,s4,80002908 <iget+0x38>
      ip->ref++;
    80002926:	2785                	addiw	a5,a5,1
    80002928:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000292a:	00015517          	auipc	a0,0x15
    8000292e:	e4e50513          	addi	a0,a0,-434 # 80017778 <itable>
    80002932:	00004097          	auipc	ra,0x4
    80002936:	a68080e7          	jalr	-1432(ra) # 8000639a <release>
      return ip;
    8000293a:	8926                	mv	s2,s1
    8000293c:	a03d                	j	8000296a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000293e:	f7f9                	bnez	a5,8000290c <iget+0x3c>
      empty = ip;
    80002940:	8926                	mv	s2,s1
    80002942:	b7e9                	j	8000290c <iget+0x3c>
  if(empty == 0)
    80002944:	02090c63          	beqz	s2,8000297c <iget+0xac>
  ip->dev = dev;
    80002948:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000294c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002950:	4785                	li	a5,1
    80002952:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002956:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000295a:	00015517          	auipc	a0,0x15
    8000295e:	e1e50513          	addi	a0,a0,-482 # 80017778 <itable>
    80002962:	00004097          	auipc	ra,0x4
    80002966:	a38080e7          	jalr	-1480(ra) # 8000639a <release>
}
    8000296a:	854a                	mv	a0,s2
    8000296c:	70a2                	ld	ra,40(sp)
    8000296e:	7402                	ld	s0,32(sp)
    80002970:	64e2                	ld	s1,24(sp)
    80002972:	6942                	ld	s2,16(sp)
    80002974:	69a2                	ld	s3,8(sp)
    80002976:	6a02                	ld	s4,0(sp)
    80002978:	6145                	addi	sp,sp,48
    8000297a:	8082                	ret
    panic("iget: no inodes");
    8000297c:	00006517          	auipc	a0,0x6
    80002980:	b4c50513          	addi	a0,a0,-1204 # 800084c8 <etext+0x4c8>
    80002984:	00003097          	auipc	ra,0x3
    80002988:	3e8080e7          	jalr	1000(ra) # 80005d6c <panic>

000000008000298c <fsinit>:
fsinit(int dev) {
    8000298c:	7179                	addi	sp,sp,-48
    8000298e:	f406                	sd	ra,40(sp)
    80002990:	f022                	sd	s0,32(sp)
    80002992:	ec26                	sd	s1,24(sp)
    80002994:	e84a                	sd	s2,16(sp)
    80002996:	e44e                	sd	s3,8(sp)
    80002998:	1800                	addi	s0,sp,48
    8000299a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000299c:	4585                	li	a1,1
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	a68080e7          	jalr	-1432(ra) # 80002406 <bread>
    800029a6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029a8:	00015997          	auipc	s3,0x15
    800029ac:	db098993          	addi	s3,s3,-592 # 80017758 <sb>
    800029b0:	02000613          	li	a2,32
    800029b4:	05850593          	addi	a1,a0,88
    800029b8:	854e                	mv	a0,s3
    800029ba:	ffffe097          	auipc	ra,0xffffe
    800029be:	866080e7          	jalr	-1946(ra) # 80000220 <memmove>
  brelse(bp);
    800029c2:	8526                	mv	a0,s1
    800029c4:	00000097          	auipc	ra,0x0
    800029c8:	b72080e7          	jalr	-1166(ra) # 80002536 <brelse>
  if(sb.magic != FSMAGIC)
    800029cc:	0009a703          	lw	a4,0(s3)
    800029d0:	102037b7          	lui	a5,0x10203
    800029d4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029d8:	02f71263          	bne	a4,a5,800029fc <fsinit+0x70>
  initlog(dev, &sb);
    800029dc:	00015597          	auipc	a1,0x15
    800029e0:	d7c58593          	addi	a1,a1,-644 # 80017758 <sb>
    800029e4:	854a                	mv	a0,s2
    800029e6:	00001097          	auipc	ra,0x1
    800029ea:	b54080e7          	jalr	-1196(ra) # 8000353a <initlog>
}
    800029ee:	70a2                	ld	ra,40(sp)
    800029f0:	7402                	ld	s0,32(sp)
    800029f2:	64e2                	ld	s1,24(sp)
    800029f4:	6942                	ld	s2,16(sp)
    800029f6:	69a2                	ld	s3,8(sp)
    800029f8:	6145                	addi	sp,sp,48
    800029fa:	8082                	ret
    panic("invalid file system");
    800029fc:	00006517          	auipc	a0,0x6
    80002a00:	adc50513          	addi	a0,a0,-1316 # 800084d8 <etext+0x4d8>
    80002a04:	00003097          	auipc	ra,0x3
    80002a08:	368080e7          	jalr	872(ra) # 80005d6c <panic>

0000000080002a0c <iinit>:
{
    80002a0c:	7179                	addi	sp,sp,-48
    80002a0e:	f406                	sd	ra,40(sp)
    80002a10:	f022                	sd	s0,32(sp)
    80002a12:	ec26                	sd	s1,24(sp)
    80002a14:	e84a                	sd	s2,16(sp)
    80002a16:	e44e                	sd	s3,8(sp)
    80002a18:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a1a:	00006597          	auipc	a1,0x6
    80002a1e:	ad658593          	addi	a1,a1,-1322 # 800084f0 <etext+0x4f0>
    80002a22:	00015517          	auipc	a0,0x15
    80002a26:	d5650513          	addi	a0,a0,-682 # 80017778 <itable>
    80002a2a:	00004097          	auipc	ra,0x4
    80002a2e:	82c080e7          	jalr	-2004(ra) # 80006256 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a32:	00015497          	auipc	s1,0x15
    80002a36:	d6e48493          	addi	s1,s1,-658 # 800177a0 <itable+0x28>
    80002a3a:	00016997          	auipc	s3,0x16
    80002a3e:	7f698993          	addi	s3,s3,2038 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a42:	00006917          	auipc	s2,0x6
    80002a46:	ab690913          	addi	s2,s2,-1354 # 800084f8 <etext+0x4f8>
    80002a4a:	85ca                	mv	a1,s2
    80002a4c:	8526                	mv	a0,s1
    80002a4e:	00001097          	auipc	ra,0x1
    80002a52:	e40080e7          	jalr	-448(ra) # 8000388e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a56:	08848493          	addi	s1,s1,136
    80002a5a:	ff3498e3          	bne	s1,s3,80002a4a <iinit+0x3e>
}
    80002a5e:	70a2                	ld	ra,40(sp)
    80002a60:	7402                	ld	s0,32(sp)
    80002a62:	64e2                	ld	s1,24(sp)
    80002a64:	6942                	ld	s2,16(sp)
    80002a66:	69a2                	ld	s3,8(sp)
    80002a68:	6145                	addi	sp,sp,48
    80002a6a:	8082                	ret

0000000080002a6c <ialloc>:
{
    80002a6c:	7139                	addi	sp,sp,-64
    80002a6e:	fc06                	sd	ra,56(sp)
    80002a70:	f822                	sd	s0,48(sp)
    80002a72:	f426                	sd	s1,40(sp)
    80002a74:	f04a                	sd	s2,32(sp)
    80002a76:	ec4e                	sd	s3,24(sp)
    80002a78:	e852                	sd	s4,16(sp)
    80002a7a:	e456                	sd	s5,8(sp)
    80002a7c:	e05a                	sd	s6,0(sp)
    80002a7e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a80:	00015717          	auipc	a4,0x15
    80002a84:	ce472703          	lw	a4,-796(a4) # 80017764 <sb+0xc>
    80002a88:	4785                	li	a5,1
    80002a8a:	04e7f863          	bgeu	a5,a4,80002ada <ialloc+0x6e>
    80002a8e:	8aaa                	mv	s5,a0
    80002a90:	8b2e                	mv	s6,a1
    80002a92:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a94:	00015a17          	auipc	s4,0x15
    80002a98:	cc4a0a13          	addi	s4,s4,-828 # 80017758 <sb>
    80002a9c:	00495593          	srli	a1,s2,0x4
    80002aa0:	018a2783          	lw	a5,24(s4)
    80002aa4:	9dbd                	addw	a1,a1,a5
    80002aa6:	8556                	mv	a0,s5
    80002aa8:	00000097          	auipc	ra,0x0
    80002aac:	95e080e7          	jalr	-1698(ra) # 80002406 <bread>
    80002ab0:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ab2:	05850993          	addi	s3,a0,88
    80002ab6:	00f97793          	andi	a5,s2,15
    80002aba:	079a                	slli	a5,a5,0x6
    80002abc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002abe:	00099783          	lh	a5,0(s3)
    80002ac2:	c785                	beqz	a5,80002aea <ialloc+0x7e>
    brelse(bp);
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	a72080e7          	jalr	-1422(ra) # 80002536 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002acc:	0905                	addi	s2,s2,1
    80002ace:	00ca2703          	lw	a4,12(s4)
    80002ad2:	0009079b          	sext.w	a5,s2
    80002ad6:	fce7e3e3          	bltu	a5,a4,80002a9c <ialloc+0x30>
  panic("ialloc: no inodes");
    80002ada:	00006517          	auipc	a0,0x6
    80002ade:	a2650513          	addi	a0,a0,-1498 # 80008500 <etext+0x500>
    80002ae2:	00003097          	auipc	ra,0x3
    80002ae6:	28a080e7          	jalr	650(ra) # 80005d6c <panic>
      memset(dip, 0, sizeof(*dip));
    80002aea:	04000613          	li	a2,64
    80002aee:	4581                	li	a1,0
    80002af0:	854e                	mv	a0,s3
    80002af2:	ffffd097          	auipc	ra,0xffffd
    80002af6:	6d2080e7          	jalr	1746(ra) # 800001c4 <memset>
      dip->type = type;
    80002afa:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002afe:	8526                	mv	a0,s1
    80002b00:	00001097          	auipc	ra,0x1
    80002b04:	caa080e7          	jalr	-854(ra) # 800037aa <log_write>
      brelse(bp);
    80002b08:	8526                	mv	a0,s1
    80002b0a:	00000097          	auipc	ra,0x0
    80002b0e:	a2c080e7          	jalr	-1492(ra) # 80002536 <brelse>
      return iget(dev, inum);
    80002b12:	0009059b          	sext.w	a1,s2
    80002b16:	8556                	mv	a0,s5
    80002b18:	00000097          	auipc	ra,0x0
    80002b1c:	db8080e7          	jalr	-584(ra) # 800028d0 <iget>
}
    80002b20:	70e2                	ld	ra,56(sp)
    80002b22:	7442                	ld	s0,48(sp)
    80002b24:	74a2                	ld	s1,40(sp)
    80002b26:	7902                	ld	s2,32(sp)
    80002b28:	69e2                	ld	s3,24(sp)
    80002b2a:	6a42                	ld	s4,16(sp)
    80002b2c:	6aa2                	ld	s5,8(sp)
    80002b2e:	6b02                	ld	s6,0(sp)
    80002b30:	6121                	addi	sp,sp,64
    80002b32:	8082                	ret

0000000080002b34 <iupdate>:
{
    80002b34:	1101                	addi	sp,sp,-32
    80002b36:	ec06                	sd	ra,24(sp)
    80002b38:	e822                	sd	s0,16(sp)
    80002b3a:	e426                	sd	s1,8(sp)
    80002b3c:	e04a                	sd	s2,0(sp)
    80002b3e:	1000                	addi	s0,sp,32
    80002b40:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b42:	415c                	lw	a5,4(a0)
    80002b44:	0047d79b          	srliw	a5,a5,0x4
    80002b48:	00015597          	auipc	a1,0x15
    80002b4c:	c285a583          	lw	a1,-984(a1) # 80017770 <sb+0x18>
    80002b50:	9dbd                	addw	a1,a1,a5
    80002b52:	4108                	lw	a0,0(a0)
    80002b54:	00000097          	auipc	ra,0x0
    80002b58:	8b2080e7          	jalr	-1870(ra) # 80002406 <bread>
    80002b5c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b5e:	05850793          	addi	a5,a0,88
    80002b62:	40d8                	lw	a4,4(s1)
    80002b64:	8b3d                	andi	a4,a4,15
    80002b66:	071a                	slli	a4,a4,0x6
    80002b68:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b6a:	04449703          	lh	a4,68(s1)
    80002b6e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b72:	04649703          	lh	a4,70(s1)
    80002b76:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b7a:	04849703          	lh	a4,72(s1)
    80002b7e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b82:	04a49703          	lh	a4,74(s1)
    80002b86:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b8a:	44f8                	lw	a4,76(s1)
    80002b8c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b8e:	03400613          	li	a2,52
    80002b92:	05048593          	addi	a1,s1,80
    80002b96:	00c78513          	addi	a0,a5,12
    80002b9a:	ffffd097          	auipc	ra,0xffffd
    80002b9e:	686080e7          	jalr	1670(ra) # 80000220 <memmove>
  log_write(bp);
    80002ba2:	854a                	mv	a0,s2
    80002ba4:	00001097          	auipc	ra,0x1
    80002ba8:	c06080e7          	jalr	-1018(ra) # 800037aa <log_write>
  brelse(bp);
    80002bac:	854a                	mv	a0,s2
    80002bae:	00000097          	auipc	ra,0x0
    80002bb2:	988080e7          	jalr	-1656(ra) # 80002536 <brelse>
}
    80002bb6:	60e2                	ld	ra,24(sp)
    80002bb8:	6442                	ld	s0,16(sp)
    80002bba:	64a2                	ld	s1,8(sp)
    80002bbc:	6902                	ld	s2,0(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret

0000000080002bc2 <idup>:
{
    80002bc2:	1101                	addi	sp,sp,-32
    80002bc4:	ec06                	sd	ra,24(sp)
    80002bc6:	e822                	sd	s0,16(sp)
    80002bc8:	e426                	sd	s1,8(sp)
    80002bca:	1000                	addi	s0,sp,32
    80002bcc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bce:	00015517          	auipc	a0,0x15
    80002bd2:	baa50513          	addi	a0,a0,-1110 # 80017778 <itable>
    80002bd6:	00003097          	auipc	ra,0x3
    80002bda:	710080e7          	jalr	1808(ra) # 800062e6 <acquire>
  ip->ref++;
    80002bde:	449c                	lw	a5,8(s1)
    80002be0:	2785                	addiw	a5,a5,1
    80002be2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002be4:	00015517          	auipc	a0,0x15
    80002be8:	b9450513          	addi	a0,a0,-1132 # 80017778 <itable>
    80002bec:	00003097          	auipc	ra,0x3
    80002bf0:	7ae080e7          	jalr	1966(ra) # 8000639a <release>
}
    80002bf4:	8526                	mv	a0,s1
    80002bf6:	60e2                	ld	ra,24(sp)
    80002bf8:	6442                	ld	s0,16(sp)
    80002bfa:	64a2                	ld	s1,8(sp)
    80002bfc:	6105                	addi	sp,sp,32
    80002bfe:	8082                	ret

0000000080002c00 <ilock>:
{
    80002c00:	1101                	addi	sp,sp,-32
    80002c02:	ec06                	sd	ra,24(sp)
    80002c04:	e822                	sd	s0,16(sp)
    80002c06:	e426                	sd	s1,8(sp)
    80002c08:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c0a:	c10d                	beqz	a0,80002c2c <ilock+0x2c>
    80002c0c:	84aa                	mv	s1,a0
    80002c0e:	451c                	lw	a5,8(a0)
    80002c10:	00f05e63          	blez	a5,80002c2c <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c14:	0541                	addi	a0,a0,16
    80002c16:	00001097          	auipc	ra,0x1
    80002c1a:	cb2080e7          	jalr	-846(ra) # 800038c8 <acquiresleep>
  if(ip->valid == 0){
    80002c1e:	40bc                	lw	a5,64(s1)
    80002c20:	cf99                	beqz	a5,80002c3e <ilock+0x3e>
}
    80002c22:	60e2                	ld	ra,24(sp)
    80002c24:	6442                	ld	s0,16(sp)
    80002c26:	64a2                	ld	s1,8(sp)
    80002c28:	6105                	addi	sp,sp,32
    80002c2a:	8082                	ret
    80002c2c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002c2e:	00006517          	auipc	a0,0x6
    80002c32:	8ea50513          	addi	a0,a0,-1814 # 80008518 <etext+0x518>
    80002c36:	00003097          	auipc	ra,0x3
    80002c3a:	136080e7          	jalr	310(ra) # 80005d6c <panic>
    80002c3e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c40:	40dc                	lw	a5,4(s1)
    80002c42:	0047d79b          	srliw	a5,a5,0x4
    80002c46:	00015597          	auipc	a1,0x15
    80002c4a:	b2a5a583          	lw	a1,-1238(a1) # 80017770 <sb+0x18>
    80002c4e:	9dbd                	addw	a1,a1,a5
    80002c50:	4088                	lw	a0,0(s1)
    80002c52:	fffff097          	auipc	ra,0xfffff
    80002c56:	7b4080e7          	jalr	1972(ra) # 80002406 <bread>
    80002c5a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c5c:	05850593          	addi	a1,a0,88
    80002c60:	40dc                	lw	a5,4(s1)
    80002c62:	8bbd                	andi	a5,a5,15
    80002c64:	079a                	slli	a5,a5,0x6
    80002c66:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c68:	00059783          	lh	a5,0(a1)
    80002c6c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c70:	00259783          	lh	a5,2(a1)
    80002c74:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c78:	00459783          	lh	a5,4(a1)
    80002c7c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c80:	00659783          	lh	a5,6(a1)
    80002c84:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c88:	459c                	lw	a5,8(a1)
    80002c8a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c8c:	03400613          	li	a2,52
    80002c90:	05b1                	addi	a1,a1,12
    80002c92:	05048513          	addi	a0,s1,80
    80002c96:	ffffd097          	auipc	ra,0xffffd
    80002c9a:	58a080e7          	jalr	1418(ra) # 80000220 <memmove>
    brelse(bp);
    80002c9e:	854a                	mv	a0,s2
    80002ca0:	00000097          	auipc	ra,0x0
    80002ca4:	896080e7          	jalr	-1898(ra) # 80002536 <brelse>
    ip->valid = 1;
    80002ca8:	4785                	li	a5,1
    80002caa:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cac:	04449783          	lh	a5,68(s1)
    80002cb0:	c399                	beqz	a5,80002cb6 <ilock+0xb6>
    80002cb2:	6902                	ld	s2,0(sp)
    80002cb4:	b7bd                	j	80002c22 <ilock+0x22>
      panic("ilock: no type");
    80002cb6:	00006517          	auipc	a0,0x6
    80002cba:	86a50513          	addi	a0,a0,-1942 # 80008520 <etext+0x520>
    80002cbe:	00003097          	auipc	ra,0x3
    80002cc2:	0ae080e7          	jalr	174(ra) # 80005d6c <panic>

0000000080002cc6 <iunlock>:
{
    80002cc6:	1101                	addi	sp,sp,-32
    80002cc8:	ec06                	sd	ra,24(sp)
    80002cca:	e822                	sd	s0,16(sp)
    80002ccc:	e426                	sd	s1,8(sp)
    80002cce:	e04a                	sd	s2,0(sp)
    80002cd0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cd2:	c905                	beqz	a0,80002d02 <iunlock+0x3c>
    80002cd4:	84aa                	mv	s1,a0
    80002cd6:	01050913          	addi	s2,a0,16
    80002cda:	854a                	mv	a0,s2
    80002cdc:	00001097          	auipc	ra,0x1
    80002ce0:	c86080e7          	jalr	-890(ra) # 80003962 <holdingsleep>
    80002ce4:	cd19                	beqz	a0,80002d02 <iunlock+0x3c>
    80002ce6:	449c                	lw	a5,8(s1)
    80002ce8:	00f05d63          	blez	a5,80002d02 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cec:	854a                	mv	a0,s2
    80002cee:	00001097          	auipc	ra,0x1
    80002cf2:	c30080e7          	jalr	-976(ra) # 8000391e <releasesleep>
}
    80002cf6:	60e2                	ld	ra,24(sp)
    80002cf8:	6442                	ld	s0,16(sp)
    80002cfa:	64a2                	ld	s1,8(sp)
    80002cfc:	6902                	ld	s2,0(sp)
    80002cfe:	6105                	addi	sp,sp,32
    80002d00:	8082                	ret
    panic("iunlock");
    80002d02:	00006517          	auipc	a0,0x6
    80002d06:	82e50513          	addi	a0,a0,-2002 # 80008530 <etext+0x530>
    80002d0a:	00003097          	auipc	ra,0x3
    80002d0e:	062080e7          	jalr	98(ra) # 80005d6c <panic>

0000000080002d12 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d12:	7179                	addi	sp,sp,-48
    80002d14:	f406                	sd	ra,40(sp)
    80002d16:	f022                	sd	s0,32(sp)
    80002d18:	ec26                	sd	s1,24(sp)
    80002d1a:	e84a                	sd	s2,16(sp)
    80002d1c:	e44e                	sd	s3,8(sp)
    80002d1e:	1800                	addi	s0,sp,48
    80002d20:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d22:	05050493          	addi	s1,a0,80
    80002d26:	08050913          	addi	s2,a0,128
    80002d2a:	a021                	j	80002d32 <itrunc+0x20>
    80002d2c:	0491                	addi	s1,s1,4
    80002d2e:	01248d63          	beq	s1,s2,80002d48 <itrunc+0x36>
    if(ip->addrs[i]){
    80002d32:	408c                	lw	a1,0(s1)
    80002d34:	dde5                	beqz	a1,80002d2c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d36:	0009a503          	lw	a0,0(s3)
    80002d3a:	00000097          	auipc	ra,0x0
    80002d3e:	910080e7          	jalr	-1776(ra) # 8000264a <bfree>
      ip->addrs[i] = 0;
    80002d42:	0004a023          	sw	zero,0(s1)
    80002d46:	b7dd                	j	80002d2c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d48:	0809a583          	lw	a1,128(s3)
    80002d4c:	ed99                	bnez	a1,80002d6a <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d4e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d52:	854e                	mv	a0,s3
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	de0080e7          	jalr	-544(ra) # 80002b34 <iupdate>
}
    80002d5c:	70a2                	ld	ra,40(sp)
    80002d5e:	7402                	ld	s0,32(sp)
    80002d60:	64e2                	ld	s1,24(sp)
    80002d62:	6942                	ld	s2,16(sp)
    80002d64:	69a2                	ld	s3,8(sp)
    80002d66:	6145                	addi	sp,sp,48
    80002d68:	8082                	ret
    80002d6a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d6c:	0009a503          	lw	a0,0(s3)
    80002d70:	fffff097          	auipc	ra,0xfffff
    80002d74:	696080e7          	jalr	1686(ra) # 80002406 <bread>
    80002d78:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d7a:	05850493          	addi	s1,a0,88
    80002d7e:	45850913          	addi	s2,a0,1112
    80002d82:	a021                	j	80002d8a <itrunc+0x78>
    80002d84:	0491                	addi	s1,s1,4
    80002d86:	01248b63          	beq	s1,s2,80002d9c <itrunc+0x8a>
      if(a[j])
    80002d8a:	408c                	lw	a1,0(s1)
    80002d8c:	dde5                	beqz	a1,80002d84 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002d8e:	0009a503          	lw	a0,0(s3)
    80002d92:	00000097          	auipc	ra,0x0
    80002d96:	8b8080e7          	jalr	-1864(ra) # 8000264a <bfree>
    80002d9a:	b7ed                	j	80002d84 <itrunc+0x72>
    brelse(bp);
    80002d9c:	8552                	mv	a0,s4
    80002d9e:	fffff097          	auipc	ra,0xfffff
    80002da2:	798080e7          	jalr	1944(ra) # 80002536 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002da6:	0809a583          	lw	a1,128(s3)
    80002daa:	0009a503          	lw	a0,0(s3)
    80002dae:	00000097          	auipc	ra,0x0
    80002db2:	89c080e7          	jalr	-1892(ra) # 8000264a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002db6:	0809a023          	sw	zero,128(s3)
    80002dba:	6a02                	ld	s4,0(sp)
    80002dbc:	bf49                	j	80002d4e <itrunc+0x3c>

0000000080002dbe <iput>:
{
    80002dbe:	1101                	addi	sp,sp,-32
    80002dc0:	ec06                	sd	ra,24(sp)
    80002dc2:	e822                	sd	s0,16(sp)
    80002dc4:	e426                	sd	s1,8(sp)
    80002dc6:	1000                	addi	s0,sp,32
    80002dc8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dca:	00015517          	auipc	a0,0x15
    80002dce:	9ae50513          	addi	a0,a0,-1618 # 80017778 <itable>
    80002dd2:	00003097          	auipc	ra,0x3
    80002dd6:	514080e7          	jalr	1300(ra) # 800062e6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dda:	4498                	lw	a4,8(s1)
    80002ddc:	4785                	li	a5,1
    80002dde:	02f70263          	beq	a4,a5,80002e02 <iput+0x44>
  ip->ref--;
    80002de2:	449c                	lw	a5,8(s1)
    80002de4:	37fd                	addiw	a5,a5,-1
    80002de6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002de8:	00015517          	auipc	a0,0x15
    80002dec:	99050513          	addi	a0,a0,-1648 # 80017778 <itable>
    80002df0:	00003097          	auipc	ra,0x3
    80002df4:	5aa080e7          	jalr	1450(ra) # 8000639a <release>
}
    80002df8:	60e2                	ld	ra,24(sp)
    80002dfa:	6442                	ld	s0,16(sp)
    80002dfc:	64a2                	ld	s1,8(sp)
    80002dfe:	6105                	addi	sp,sp,32
    80002e00:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e02:	40bc                	lw	a5,64(s1)
    80002e04:	dff9                	beqz	a5,80002de2 <iput+0x24>
    80002e06:	04a49783          	lh	a5,74(s1)
    80002e0a:	ffe1                	bnez	a5,80002de2 <iput+0x24>
    80002e0c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e0e:	01048913          	addi	s2,s1,16
    80002e12:	854a                	mv	a0,s2
    80002e14:	00001097          	auipc	ra,0x1
    80002e18:	ab4080e7          	jalr	-1356(ra) # 800038c8 <acquiresleep>
    release(&itable.lock);
    80002e1c:	00015517          	auipc	a0,0x15
    80002e20:	95c50513          	addi	a0,a0,-1700 # 80017778 <itable>
    80002e24:	00003097          	auipc	ra,0x3
    80002e28:	576080e7          	jalr	1398(ra) # 8000639a <release>
    itrunc(ip);
    80002e2c:	8526                	mv	a0,s1
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	ee4080e7          	jalr	-284(ra) # 80002d12 <itrunc>
    ip->type = 0;
    80002e36:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e3a:	8526                	mv	a0,s1
    80002e3c:	00000097          	auipc	ra,0x0
    80002e40:	cf8080e7          	jalr	-776(ra) # 80002b34 <iupdate>
    ip->valid = 0;
    80002e44:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e48:	854a                	mv	a0,s2
    80002e4a:	00001097          	auipc	ra,0x1
    80002e4e:	ad4080e7          	jalr	-1324(ra) # 8000391e <releasesleep>
    acquire(&itable.lock);
    80002e52:	00015517          	auipc	a0,0x15
    80002e56:	92650513          	addi	a0,a0,-1754 # 80017778 <itable>
    80002e5a:	00003097          	auipc	ra,0x3
    80002e5e:	48c080e7          	jalr	1164(ra) # 800062e6 <acquire>
    80002e62:	6902                	ld	s2,0(sp)
    80002e64:	bfbd                	j	80002de2 <iput+0x24>

0000000080002e66 <iunlockput>:
{
    80002e66:	1101                	addi	sp,sp,-32
    80002e68:	ec06                	sd	ra,24(sp)
    80002e6a:	e822                	sd	s0,16(sp)
    80002e6c:	e426                	sd	s1,8(sp)
    80002e6e:	1000                	addi	s0,sp,32
    80002e70:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e72:	00000097          	auipc	ra,0x0
    80002e76:	e54080e7          	jalr	-428(ra) # 80002cc6 <iunlock>
  iput(ip);
    80002e7a:	8526                	mv	a0,s1
    80002e7c:	00000097          	auipc	ra,0x0
    80002e80:	f42080e7          	jalr	-190(ra) # 80002dbe <iput>
}
    80002e84:	60e2                	ld	ra,24(sp)
    80002e86:	6442                	ld	s0,16(sp)
    80002e88:	64a2                	ld	s1,8(sp)
    80002e8a:	6105                	addi	sp,sp,32
    80002e8c:	8082                	ret

0000000080002e8e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e8e:	1141                	addi	sp,sp,-16
    80002e90:	e422                	sd	s0,8(sp)
    80002e92:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e94:	411c                	lw	a5,0(a0)
    80002e96:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e98:	415c                	lw	a5,4(a0)
    80002e9a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e9c:	04451783          	lh	a5,68(a0)
    80002ea0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ea4:	04a51783          	lh	a5,74(a0)
    80002ea8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002eac:	04c56783          	lwu	a5,76(a0)
    80002eb0:	e99c                	sd	a5,16(a1)
}
    80002eb2:	6422                	ld	s0,8(sp)
    80002eb4:	0141                	addi	sp,sp,16
    80002eb6:	8082                	ret

0000000080002eb8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eb8:	457c                	lw	a5,76(a0)
    80002eba:	0ed7ef63          	bltu	a5,a3,80002fb8 <readi+0x100>
{
    80002ebe:	7159                	addi	sp,sp,-112
    80002ec0:	f486                	sd	ra,104(sp)
    80002ec2:	f0a2                	sd	s0,96(sp)
    80002ec4:	eca6                	sd	s1,88(sp)
    80002ec6:	fc56                	sd	s5,56(sp)
    80002ec8:	f85a                	sd	s6,48(sp)
    80002eca:	f45e                	sd	s7,40(sp)
    80002ecc:	f062                	sd	s8,32(sp)
    80002ece:	1880                	addi	s0,sp,112
    80002ed0:	8baa                	mv	s7,a0
    80002ed2:	8c2e                	mv	s8,a1
    80002ed4:	8ab2                	mv	s5,a2
    80002ed6:	84b6                	mv	s1,a3
    80002ed8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eda:	9f35                	addw	a4,a4,a3
    return 0;
    80002edc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ede:	0ad76c63          	bltu	a4,a3,80002f96 <readi+0xde>
    80002ee2:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002ee4:	00e7f463          	bgeu	a5,a4,80002eec <readi+0x34>
    n = ip->size - off;
    80002ee8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eec:	0c0b0463          	beqz	s6,80002fb4 <readi+0xfc>
    80002ef0:	e8ca                	sd	s2,80(sp)
    80002ef2:	e0d2                	sd	s4,64(sp)
    80002ef4:	ec66                	sd	s9,24(sp)
    80002ef6:	e86a                	sd	s10,16(sp)
    80002ef8:	e46e                	sd	s11,8(sp)
    80002efa:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002efc:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f00:	5cfd                	li	s9,-1
    80002f02:	a82d                	j	80002f3c <readi+0x84>
    80002f04:	020a1d93          	slli	s11,s4,0x20
    80002f08:	020ddd93          	srli	s11,s11,0x20
    80002f0c:	05890613          	addi	a2,s2,88
    80002f10:	86ee                	mv	a3,s11
    80002f12:	963a                	add	a2,a2,a4
    80002f14:	85d6                	mv	a1,s5
    80002f16:	8562                	mv	a0,s8
    80002f18:	fffff097          	auipc	ra,0xfffff
    80002f1c:	a24080e7          	jalr	-1500(ra) # 8000193c <either_copyout>
    80002f20:	05950d63          	beq	a0,s9,80002f7a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f24:	854a                	mv	a0,s2
    80002f26:	fffff097          	auipc	ra,0xfffff
    80002f2a:	610080e7          	jalr	1552(ra) # 80002536 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f2e:	013a09bb          	addw	s3,s4,s3
    80002f32:	009a04bb          	addw	s1,s4,s1
    80002f36:	9aee                	add	s5,s5,s11
    80002f38:	0769f863          	bgeu	s3,s6,80002fa8 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f3c:	000ba903          	lw	s2,0(s7)
    80002f40:	00a4d59b          	srliw	a1,s1,0xa
    80002f44:	855e                	mv	a0,s7
    80002f46:	00000097          	auipc	ra,0x0
    80002f4a:	8ae080e7          	jalr	-1874(ra) # 800027f4 <bmap>
    80002f4e:	0005059b          	sext.w	a1,a0
    80002f52:	854a                	mv	a0,s2
    80002f54:	fffff097          	auipc	ra,0xfffff
    80002f58:	4b2080e7          	jalr	1202(ra) # 80002406 <bread>
    80002f5c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f5e:	3ff4f713          	andi	a4,s1,1023
    80002f62:	40ed07bb          	subw	a5,s10,a4
    80002f66:	413b06bb          	subw	a3,s6,s3
    80002f6a:	8a3e                	mv	s4,a5
    80002f6c:	2781                	sext.w	a5,a5
    80002f6e:	0006861b          	sext.w	a2,a3
    80002f72:	f8f679e3          	bgeu	a2,a5,80002f04 <readi+0x4c>
    80002f76:	8a36                	mv	s4,a3
    80002f78:	b771                	j	80002f04 <readi+0x4c>
      brelse(bp);
    80002f7a:	854a                	mv	a0,s2
    80002f7c:	fffff097          	auipc	ra,0xfffff
    80002f80:	5ba080e7          	jalr	1466(ra) # 80002536 <brelse>
      tot = -1;
    80002f84:	59fd                	li	s3,-1
      break;
    80002f86:	6946                	ld	s2,80(sp)
    80002f88:	6a06                	ld	s4,64(sp)
    80002f8a:	6ce2                	ld	s9,24(sp)
    80002f8c:	6d42                	ld	s10,16(sp)
    80002f8e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002f90:	0009851b          	sext.w	a0,s3
    80002f94:	69a6                	ld	s3,72(sp)
}
    80002f96:	70a6                	ld	ra,104(sp)
    80002f98:	7406                	ld	s0,96(sp)
    80002f9a:	64e6                	ld	s1,88(sp)
    80002f9c:	7ae2                	ld	s5,56(sp)
    80002f9e:	7b42                	ld	s6,48(sp)
    80002fa0:	7ba2                	ld	s7,40(sp)
    80002fa2:	7c02                	ld	s8,32(sp)
    80002fa4:	6165                	addi	sp,sp,112
    80002fa6:	8082                	ret
    80002fa8:	6946                	ld	s2,80(sp)
    80002faa:	6a06                	ld	s4,64(sp)
    80002fac:	6ce2                	ld	s9,24(sp)
    80002fae:	6d42                	ld	s10,16(sp)
    80002fb0:	6da2                	ld	s11,8(sp)
    80002fb2:	bff9                	j	80002f90 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fb4:	89da                	mv	s3,s6
    80002fb6:	bfe9                	j	80002f90 <readi+0xd8>
    return 0;
    80002fb8:	4501                	li	a0,0
}
    80002fba:	8082                	ret

0000000080002fbc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fbc:	457c                	lw	a5,76(a0)
    80002fbe:	10d7ee63          	bltu	a5,a3,800030da <writei+0x11e>
{
    80002fc2:	7159                	addi	sp,sp,-112
    80002fc4:	f486                	sd	ra,104(sp)
    80002fc6:	f0a2                	sd	s0,96(sp)
    80002fc8:	e8ca                	sd	s2,80(sp)
    80002fca:	fc56                	sd	s5,56(sp)
    80002fcc:	f85a                	sd	s6,48(sp)
    80002fce:	f45e                	sd	s7,40(sp)
    80002fd0:	f062                	sd	s8,32(sp)
    80002fd2:	1880                	addi	s0,sp,112
    80002fd4:	8b2a                	mv	s6,a0
    80002fd6:	8c2e                	mv	s8,a1
    80002fd8:	8ab2                	mv	s5,a2
    80002fda:	8936                	mv	s2,a3
    80002fdc:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fde:	00e687bb          	addw	a5,a3,a4
    80002fe2:	0ed7ee63          	bltu	a5,a3,800030de <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fe6:	00043737          	lui	a4,0x43
    80002fea:	0ef76c63          	bltu	a4,a5,800030e2 <writei+0x126>
    80002fee:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff0:	0c0b8d63          	beqz	s7,800030ca <writei+0x10e>
    80002ff4:	eca6                	sd	s1,88(sp)
    80002ff6:	e4ce                	sd	s3,72(sp)
    80002ff8:	ec66                	sd	s9,24(sp)
    80002ffa:	e86a                	sd	s10,16(sp)
    80002ffc:	e46e                	sd	s11,8(sp)
    80002ffe:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003000:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003004:	5cfd                	li	s9,-1
    80003006:	a091                	j	8000304a <writei+0x8e>
    80003008:	02099d93          	slli	s11,s3,0x20
    8000300c:	020ddd93          	srli	s11,s11,0x20
    80003010:	05848513          	addi	a0,s1,88
    80003014:	86ee                	mv	a3,s11
    80003016:	8656                	mv	a2,s5
    80003018:	85e2                	mv	a1,s8
    8000301a:	953a                	add	a0,a0,a4
    8000301c:	fffff097          	auipc	ra,0xfffff
    80003020:	976080e7          	jalr	-1674(ra) # 80001992 <either_copyin>
    80003024:	07950263          	beq	a0,s9,80003088 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003028:	8526                	mv	a0,s1
    8000302a:	00000097          	auipc	ra,0x0
    8000302e:	780080e7          	jalr	1920(ra) # 800037aa <log_write>
    brelse(bp);
    80003032:	8526                	mv	a0,s1
    80003034:	fffff097          	auipc	ra,0xfffff
    80003038:	502080e7          	jalr	1282(ra) # 80002536 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000303c:	01498a3b          	addw	s4,s3,s4
    80003040:	0129893b          	addw	s2,s3,s2
    80003044:	9aee                	add	s5,s5,s11
    80003046:	057a7663          	bgeu	s4,s7,80003092 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000304a:	000b2483          	lw	s1,0(s6)
    8000304e:	00a9559b          	srliw	a1,s2,0xa
    80003052:	855a                	mv	a0,s6
    80003054:	fffff097          	auipc	ra,0xfffff
    80003058:	7a0080e7          	jalr	1952(ra) # 800027f4 <bmap>
    8000305c:	0005059b          	sext.w	a1,a0
    80003060:	8526                	mv	a0,s1
    80003062:	fffff097          	auipc	ra,0xfffff
    80003066:	3a4080e7          	jalr	932(ra) # 80002406 <bread>
    8000306a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000306c:	3ff97713          	andi	a4,s2,1023
    80003070:	40ed07bb          	subw	a5,s10,a4
    80003074:	414b86bb          	subw	a3,s7,s4
    80003078:	89be                	mv	s3,a5
    8000307a:	2781                	sext.w	a5,a5
    8000307c:	0006861b          	sext.w	a2,a3
    80003080:	f8f674e3          	bgeu	a2,a5,80003008 <writei+0x4c>
    80003084:	89b6                	mv	s3,a3
    80003086:	b749                	j	80003008 <writei+0x4c>
      brelse(bp);
    80003088:	8526                	mv	a0,s1
    8000308a:	fffff097          	auipc	ra,0xfffff
    8000308e:	4ac080e7          	jalr	1196(ra) # 80002536 <brelse>
  }

  if(off > ip->size)
    80003092:	04cb2783          	lw	a5,76(s6)
    80003096:	0327fc63          	bgeu	a5,s2,800030ce <writei+0x112>
    ip->size = off;
    8000309a:	052b2623          	sw	s2,76(s6)
    8000309e:	64e6                	ld	s1,88(sp)
    800030a0:	69a6                	ld	s3,72(sp)
    800030a2:	6ce2                	ld	s9,24(sp)
    800030a4:	6d42                	ld	s10,16(sp)
    800030a6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030a8:	855a                	mv	a0,s6
    800030aa:	00000097          	auipc	ra,0x0
    800030ae:	a8a080e7          	jalr	-1398(ra) # 80002b34 <iupdate>

  return tot;
    800030b2:	000a051b          	sext.w	a0,s4
    800030b6:	6a06                	ld	s4,64(sp)
}
    800030b8:	70a6                	ld	ra,104(sp)
    800030ba:	7406                	ld	s0,96(sp)
    800030bc:	6946                	ld	s2,80(sp)
    800030be:	7ae2                	ld	s5,56(sp)
    800030c0:	7b42                	ld	s6,48(sp)
    800030c2:	7ba2                	ld	s7,40(sp)
    800030c4:	7c02                	ld	s8,32(sp)
    800030c6:	6165                	addi	sp,sp,112
    800030c8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ca:	8a5e                	mv	s4,s7
    800030cc:	bff1                	j	800030a8 <writei+0xec>
    800030ce:	64e6                	ld	s1,88(sp)
    800030d0:	69a6                	ld	s3,72(sp)
    800030d2:	6ce2                	ld	s9,24(sp)
    800030d4:	6d42                	ld	s10,16(sp)
    800030d6:	6da2                	ld	s11,8(sp)
    800030d8:	bfc1                	j	800030a8 <writei+0xec>
    return -1;
    800030da:	557d                	li	a0,-1
}
    800030dc:	8082                	ret
    return -1;
    800030de:	557d                	li	a0,-1
    800030e0:	bfe1                	j	800030b8 <writei+0xfc>
    return -1;
    800030e2:	557d                	li	a0,-1
    800030e4:	bfd1                	j	800030b8 <writei+0xfc>

00000000800030e6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030e6:	1141                	addi	sp,sp,-16
    800030e8:	e406                	sd	ra,8(sp)
    800030ea:	e022                	sd	s0,0(sp)
    800030ec:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030ee:	4639                	li	a2,14
    800030f0:	ffffd097          	auipc	ra,0xffffd
    800030f4:	1a4080e7          	jalr	420(ra) # 80000294 <strncmp>
}
    800030f8:	60a2                	ld	ra,8(sp)
    800030fa:	6402                	ld	s0,0(sp)
    800030fc:	0141                	addi	sp,sp,16
    800030fe:	8082                	ret

0000000080003100 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003100:	7139                	addi	sp,sp,-64
    80003102:	fc06                	sd	ra,56(sp)
    80003104:	f822                	sd	s0,48(sp)
    80003106:	f426                	sd	s1,40(sp)
    80003108:	f04a                	sd	s2,32(sp)
    8000310a:	ec4e                	sd	s3,24(sp)
    8000310c:	e852                	sd	s4,16(sp)
    8000310e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003110:	04451703          	lh	a4,68(a0)
    80003114:	4785                	li	a5,1
    80003116:	00f71a63          	bne	a4,a5,8000312a <dirlookup+0x2a>
    8000311a:	892a                	mv	s2,a0
    8000311c:	89ae                	mv	s3,a1
    8000311e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003120:	457c                	lw	a5,76(a0)
    80003122:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003124:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003126:	e79d                	bnez	a5,80003154 <dirlookup+0x54>
    80003128:	a8a5                	j	800031a0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000312a:	00005517          	auipc	a0,0x5
    8000312e:	40e50513          	addi	a0,a0,1038 # 80008538 <etext+0x538>
    80003132:	00003097          	auipc	ra,0x3
    80003136:	c3a080e7          	jalr	-966(ra) # 80005d6c <panic>
      panic("dirlookup read");
    8000313a:	00005517          	auipc	a0,0x5
    8000313e:	41650513          	addi	a0,a0,1046 # 80008550 <etext+0x550>
    80003142:	00003097          	auipc	ra,0x3
    80003146:	c2a080e7          	jalr	-982(ra) # 80005d6c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000314a:	24c1                	addiw	s1,s1,16
    8000314c:	04c92783          	lw	a5,76(s2)
    80003150:	04f4f763          	bgeu	s1,a5,8000319e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003154:	4741                	li	a4,16
    80003156:	86a6                	mv	a3,s1
    80003158:	fc040613          	addi	a2,s0,-64
    8000315c:	4581                	li	a1,0
    8000315e:	854a                	mv	a0,s2
    80003160:	00000097          	auipc	ra,0x0
    80003164:	d58080e7          	jalr	-680(ra) # 80002eb8 <readi>
    80003168:	47c1                	li	a5,16
    8000316a:	fcf518e3          	bne	a0,a5,8000313a <dirlookup+0x3a>
    if(de.inum == 0)
    8000316e:	fc045783          	lhu	a5,-64(s0)
    80003172:	dfe1                	beqz	a5,8000314a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003174:	fc240593          	addi	a1,s0,-62
    80003178:	854e                	mv	a0,s3
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	f6c080e7          	jalr	-148(ra) # 800030e6 <namecmp>
    80003182:	f561                	bnez	a0,8000314a <dirlookup+0x4a>
      if(poff)
    80003184:	000a0463          	beqz	s4,8000318c <dirlookup+0x8c>
        *poff = off;
    80003188:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000318c:	fc045583          	lhu	a1,-64(s0)
    80003190:	00092503          	lw	a0,0(s2)
    80003194:	fffff097          	auipc	ra,0xfffff
    80003198:	73c080e7          	jalr	1852(ra) # 800028d0 <iget>
    8000319c:	a011                	j	800031a0 <dirlookup+0xa0>
  return 0;
    8000319e:	4501                	li	a0,0
}
    800031a0:	70e2                	ld	ra,56(sp)
    800031a2:	7442                	ld	s0,48(sp)
    800031a4:	74a2                	ld	s1,40(sp)
    800031a6:	7902                	ld	s2,32(sp)
    800031a8:	69e2                	ld	s3,24(sp)
    800031aa:	6a42                	ld	s4,16(sp)
    800031ac:	6121                	addi	sp,sp,64
    800031ae:	8082                	ret

00000000800031b0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031b0:	711d                	addi	sp,sp,-96
    800031b2:	ec86                	sd	ra,88(sp)
    800031b4:	e8a2                	sd	s0,80(sp)
    800031b6:	e4a6                	sd	s1,72(sp)
    800031b8:	e0ca                	sd	s2,64(sp)
    800031ba:	fc4e                	sd	s3,56(sp)
    800031bc:	f852                	sd	s4,48(sp)
    800031be:	f456                	sd	s5,40(sp)
    800031c0:	f05a                	sd	s6,32(sp)
    800031c2:	ec5e                	sd	s7,24(sp)
    800031c4:	e862                	sd	s8,16(sp)
    800031c6:	e466                	sd	s9,8(sp)
    800031c8:	1080                	addi	s0,sp,96
    800031ca:	84aa                	mv	s1,a0
    800031cc:	8b2e                	mv	s6,a1
    800031ce:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031d0:	00054703          	lbu	a4,0(a0)
    800031d4:	02f00793          	li	a5,47
    800031d8:	02f70263          	beq	a4,a5,800031fc <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031dc:	ffffe097          	auipc	ra,0xffffe
    800031e0:	cea080e7          	jalr	-790(ra) # 80000ec6 <myproc>
    800031e4:	15053503          	ld	a0,336(a0)
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	9da080e7          	jalr	-1574(ra) # 80002bc2 <idup>
    800031f0:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031f2:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031f6:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031f8:	4b85                	li	s7,1
    800031fa:	a875                	j	800032b6 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800031fc:	4585                	li	a1,1
    800031fe:	4505                	li	a0,1
    80003200:	fffff097          	auipc	ra,0xfffff
    80003204:	6d0080e7          	jalr	1744(ra) # 800028d0 <iget>
    80003208:	8a2a                	mv	s4,a0
    8000320a:	b7e5                	j	800031f2 <namex+0x42>
      iunlockput(ip);
    8000320c:	8552                	mv	a0,s4
    8000320e:	00000097          	auipc	ra,0x0
    80003212:	c58080e7          	jalr	-936(ra) # 80002e66 <iunlockput>
      return 0;
    80003216:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003218:	8552                	mv	a0,s4
    8000321a:	60e6                	ld	ra,88(sp)
    8000321c:	6446                	ld	s0,80(sp)
    8000321e:	64a6                	ld	s1,72(sp)
    80003220:	6906                	ld	s2,64(sp)
    80003222:	79e2                	ld	s3,56(sp)
    80003224:	7a42                	ld	s4,48(sp)
    80003226:	7aa2                	ld	s5,40(sp)
    80003228:	7b02                	ld	s6,32(sp)
    8000322a:	6be2                	ld	s7,24(sp)
    8000322c:	6c42                	ld	s8,16(sp)
    8000322e:	6ca2                	ld	s9,8(sp)
    80003230:	6125                	addi	sp,sp,96
    80003232:	8082                	ret
      iunlock(ip);
    80003234:	8552                	mv	a0,s4
    80003236:	00000097          	auipc	ra,0x0
    8000323a:	a90080e7          	jalr	-1392(ra) # 80002cc6 <iunlock>
      return ip;
    8000323e:	bfe9                	j	80003218 <namex+0x68>
      iunlockput(ip);
    80003240:	8552                	mv	a0,s4
    80003242:	00000097          	auipc	ra,0x0
    80003246:	c24080e7          	jalr	-988(ra) # 80002e66 <iunlockput>
      return 0;
    8000324a:	8a4e                	mv	s4,s3
    8000324c:	b7f1                	j	80003218 <namex+0x68>
  len = path - s;
    8000324e:	40998633          	sub	a2,s3,s1
    80003252:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003256:	099c5863          	bge	s8,s9,800032e6 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000325a:	4639                	li	a2,14
    8000325c:	85a6                	mv	a1,s1
    8000325e:	8556                	mv	a0,s5
    80003260:	ffffd097          	auipc	ra,0xffffd
    80003264:	fc0080e7          	jalr	-64(ra) # 80000220 <memmove>
    80003268:	84ce                	mv	s1,s3
  while(*path == '/')
    8000326a:	0004c783          	lbu	a5,0(s1)
    8000326e:	01279763          	bne	a5,s2,8000327c <namex+0xcc>
    path++;
    80003272:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003274:	0004c783          	lbu	a5,0(s1)
    80003278:	ff278de3          	beq	a5,s2,80003272 <namex+0xc2>
    ilock(ip);
    8000327c:	8552                	mv	a0,s4
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	982080e7          	jalr	-1662(ra) # 80002c00 <ilock>
    if(ip->type != T_DIR){
    80003286:	044a1783          	lh	a5,68(s4)
    8000328a:	f97791e3          	bne	a5,s7,8000320c <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000328e:	000b0563          	beqz	s6,80003298 <namex+0xe8>
    80003292:	0004c783          	lbu	a5,0(s1)
    80003296:	dfd9                	beqz	a5,80003234 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003298:	4601                	li	a2,0
    8000329a:	85d6                	mv	a1,s5
    8000329c:	8552                	mv	a0,s4
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	e62080e7          	jalr	-414(ra) # 80003100 <dirlookup>
    800032a6:	89aa                	mv	s3,a0
    800032a8:	dd41                	beqz	a0,80003240 <namex+0x90>
    iunlockput(ip);
    800032aa:	8552                	mv	a0,s4
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	bba080e7          	jalr	-1094(ra) # 80002e66 <iunlockput>
    ip = next;
    800032b4:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032b6:	0004c783          	lbu	a5,0(s1)
    800032ba:	01279763          	bne	a5,s2,800032c8 <namex+0x118>
    path++;
    800032be:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032c0:	0004c783          	lbu	a5,0(s1)
    800032c4:	ff278de3          	beq	a5,s2,800032be <namex+0x10e>
  if(*path == 0)
    800032c8:	cb9d                	beqz	a5,800032fe <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032ca:	0004c783          	lbu	a5,0(s1)
    800032ce:	89a6                	mv	s3,s1
  len = path - s;
    800032d0:	4c81                	li	s9,0
    800032d2:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032d4:	01278963          	beq	a5,s2,800032e6 <namex+0x136>
    800032d8:	dbbd                	beqz	a5,8000324e <namex+0x9e>
    path++;
    800032da:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032dc:	0009c783          	lbu	a5,0(s3)
    800032e0:	ff279ce3          	bne	a5,s2,800032d8 <namex+0x128>
    800032e4:	b7ad                	j	8000324e <namex+0x9e>
    memmove(name, s, len);
    800032e6:	2601                	sext.w	a2,a2
    800032e8:	85a6                	mv	a1,s1
    800032ea:	8556                	mv	a0,s5
    800032ec:	ffffd097          	auipc	ra,0xffffd
    800032f0:	f34080e7          	jalr	-204(ra) # 80000220 <memmove>
    name[len] = 0;
    800032f4:	9cd6                	add	s9,s9,s5
    800032f6:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032fa:	84ce                	mv	s1,s3
    800032fc:	b7bd                	j	8000326a <namex+0xba>
  if(nameiparent){
    800032fe:	f00b0de3          	beqz	s6,80003218 <namex+0x68>
    iput(ip);
    80003302:	8552                	mv	a0,s4
    80003304:	00000097          	auipc	ra,0x0
    80003308:	aba080e7          	jalr	-1350(ra) # 80002dbe <iput>
    return 0;
    8000330c:	4a01                	li	s4,0
    8000330e:	b729                	j	80003218 <namex+0x68>

0000000080003310 <dirlink>:
{
    80003310:	7139                	addi	sp,sp,-64
    80003312:	fc06                	sd	ra,56(sp)
    80003314:	f822                	sd	s0,48(sp)
    80003316:	f04a                	sd	s2,32(sp)
    80003318:	ec4e                	sd	s3,24(sp)
    8000331a:	e852                	sd	s4,16(sp)
    8000331c:	0080                	addi	s0,sp,64
    8000331e:	892a                	mv	s2,a0
    80003320:	8a2e                	mv	s4,a1
    80003322:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003324:	4601                	li	a2,0
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	dda080e7          	jalr	-550(ra) # 80003100 <dirlookup>
    8000332e:	ed25                	bnez	a0,800033a6 <dirlink+0x96>
    80003330:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003332:	04c92483          	lw	s1,76(s2)
    80003336:	c49d                	beqz	s1,80003364 <dirlink+0x54>
    80003338:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000333a:	4741                	li	a4,16
    8000333c:	86a6                	mv	a3,s1
    8000333e:	fc040613          	addi	a2,s0,-64
    80003342:	4581                	li	a1,0
    80003344:	854a                	mv	a0,s2
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	b72080e7          	jalr	-1166(ra) # 80002eb8 <readi>
    8000334e:	47c1                	li	a5,16
    80003350:	06f51163          	bne	a0,a5,800033b2 <dirlink+0xa2>
    if(de.inum == 0)
    80003354:	fc045783          	lhu	a5,-64(s0)
    80003358:	c791                	beqz	a5,80003364 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000335a:	24c1                	addiw	s1,s1,16
    8000335c:	04c92783          	lw	a5,76(s2)
    80003360:	fcf4ede3          	bltu	s1,a5,8000333a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003364:	4639                	li	a2,14
    80003366:	85d2                	mv	a1,s4
    80003368:	fc240513          	addi	a0,s0,-62
    8000336c:	ffffd097          	auipc	ra,0xffffd
    80003370:	f5e080e7          	jalr	-162(ra) # 800002ca <strncpy>
  de.inum = inum;
    80003374:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003378:	4741                	li	a4,16
    8000337a:	86a6                	mv	a3,s1
    8000337c:	fc040613          	addi	a2,s0,-64
    80003380:	4581                	li	a1,0
    80003382:	854a                	mv	a0,s2
    80003384:	00000097          	auipc	ra,0x0
    80003388:	c38080e7          	jalr	-968(ra) # 80002fbc <writei>
    8000338c:	872a                	mv	a4,a0
    8000338e:	47c1                	li	a5,16
  return 0;
    80003390:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003392:	02f71863          	bne	a4,a5,800033c2 <dirlink+0xb2>
    80003396:	74a2                	ld	s1,40(sp)
}
    80003398:	70e2                	ld	ra,56(sp)
    8000339a:	7442                	ld	s0,48(sp)
    8000339c:	7902                	ld	s2,32(sp)
    8000339e:	69e2                	ld	s3,24(sp)
    800033a0:	6a42                	ld	s4,16(sp)
    800033a2:	6121                	addi	sp,sp,64
    800033a4:	8082                	ret
    iput(ip);
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	a18080e7          	jalr	-1512(ra) # 80002dbe <iput>
    return -1;
    800033ae:	557d                	li	a0,-1
    800033b0:	b7e5                	j	80003398 <dirlink+0x88>
      panic("dirlink read");
    800033b2:	00005517          	auipc	a0,0x5
    800033b6:	1ae50513          	addi	a0,a0,430 # 80008560 <etext+0x560>
    800033ba:	00003097          	auipc	ra,0x3
    800033be:	9b2080e7          	jalr	-1614(ra) # 80005d6c <panic>
    panic("dirlink");
    800033c2:	00005517          	auipc	a0,0x5
    800033c6:	2a650513          	addi	a0,a0,678 # 80008668 <etext+0x668>
    800033ca:	00003097          	auipc	ra,0x3
    800033ce:	9a2080e7          	jalr	-1630(ra) # 80005d6c <panic>

00000000800033d2 <namei>:

struct inode*
namei(char *path)
{
    800033d2:	1101                	addi	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033da:	fe040613          	addi	a2,s0,-32
    800033de:	4581                	li	a1,0
    800033e0:	00000097          	auipc	ra,0x0
    800033e4:	dd0080e7          	jalr	-560(ra) # 800031b0 <namex>
}
    800033e8:	60e2                	ld	ra,24(sp)
    800033ea:	6442                	ld	s0,16(sp)
    800033ec:	6105                	addi	sp,sp,32
    800033ee:	8082                	ret

00000000800033f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033f0:	1141                	addi	sp,sp,-16
    800033f2:	e406                	sd	ra,8(sp)
    800033f4:	e022                	sd	s0,0(sp)
    800033f6:	0800                	addi	s0,sp,16
    800033f8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033fa:	4585                	li	a1,1
    800033fc:	00000097          	auipc	ra,0x0
    80003400:	db4080e7          	jalr	-588(ra) # 800031b0 <namex>
}
    80003404:	60a2                	ld	ra,8(sp)
    80003406:	6402                	ld	s0,0(sp)
    80003408:	0141                	addi	sp,sp,16
    8000340a:	8082                	ret

000000008000340c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000340c:	1101                	addi	sp,sp,-32
    8000340e:	ec06                	sd	ra,24(sp)
    80003410:	e822                	sd	s0,16(sp)
    80003412:	e426                	sd	s1,8(sp)
    80003414:	e04a                	sd	s2,0(sp)
    80003416:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003418:	00016917          	auipc	s2,0x16
    8000341c:	e0890913          	addi	s2,s2,-504 # 80019220 <log>
    80003420:	01892583          	lw	a1,24(s2)
    80003424:	02892503          	lw	a0,40(s2)
    80003428:	fffff097          	auipc	ra,0xfffff
    8000342c:	fde080e7          	jalr	-34(ra) # 80002406 <bread>
    80003430:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003432:	02c92603          	lw	a2,44(s2)
    80003436:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003438:	00c05f63          	blez	a2,80003456 <write_head+0x4a>
    8000343c:	00016717          	auipc	a4,0x16
    80003440:	e1470713          	addi	a4,a4,-492 # 80019250 <log+0x30>
    80003444:	87aa                	mv	a5,a0
    80003446:	060a                	slli	a2,a2,0x2
    80003448:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000344a:	4314                	lw	a3,0(a4)
    8000344c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000344e:	0711                	addi	a4,a4,4
    80003450:	0791                	addi	a5,a5,4
    80003452:	fec79ce3          	bne	a5,a2,8000344a <write_head+0x3e>
  }
  bwrite(buf);
    80003456:	8526                	mv	a0,s1
    80003458:	fffff097          	auipc	ra,0xfffff
    8000345c:	0a0080e7          	jalr	160(ra) # 800024f8 <bwrite>
  brelse(buf);
    80003460:	8526                	mv	a0,s1
    80003462:	fffff097          	auipc	ra,0xfffff
    80003466:	0d4080e7          	jalr	212(ra) # 80002536 <brelse>
}
    8000346a:	60e2                	ld	ra,24(sp)
    8000346c:	6442                	ld	s0,16(sp)
    8000346e:	64a2                	ld	s1,8(sp)
    80003470:	6902                	ld	s2,0(sp)
    80003472:	6105                	addi	sp,sp,32
    80003474:	8082                	ret

0000000080003476 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003476:	00016797          	auipc	a5,0x16
    8000347a:	dd67a783          	lw	a5,-554(a5) # 8001924c <log+0x2c>
    8000347e:	0af05d63          	blez	a5,80003538 <install_trans+0xc2>
{
    80003482:	7139                	addi	sp,sp,-64
    80003484:	fc06                	sd	ra,56(sp)
    80003486:	f822                	sd	s0,48(sp)
    80003488:	f426                	sd	s1,40(sp)
    8000348a:	f04a                	sd	s2,32(sp)
    8000348c:	ec4e                	sd	s3,24(sp)
    8000348e:	e852                	sd	s4,16(sp)
    80003490:	e456                	sd	s5,8(sp)
    80003492:	e05a                	sd	s6,0(sp)
    80003494:	0080                	addi	s0,sp,64
    80003496:	8b2a                	mv	s6,a0
    80003498:	00016a97          	auipc	s5,0x16
    8000349c:	db8a8a93          	addi	s5,s5,-584 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a2:	00016997          	auipc	s3,0x16
    800034a6:	d7e98993          	addi	s3,s3,-642 # 80019220 <log>
    800034aa:	a00d                	j	800034cc <install_trans+0x56>
    brelse(lbuf);
    800034ac:	854a                	mv	a0,s2
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	088080e7          	jalr	136(ra) # 80002536 <brelse>
    brelse(dbuf);
    800034b6:	8526                	mv	a0,s1
    800034b8:	fffff097          	auipc	ra,0xfffff
    800034bc:	07e080e7          	jalr	126(ra) # 80002536 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c0:	2a05                	addiw	s4,s4,1
    800034c2:	0a91                	addi	s5,s5,4
    800034c4:	02c9a783          	lw	a5,44(s3)
    800034c8:	04fa5e63          	bge	s4,a5,80003524 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034cc:	0189a583          	lw	a1,24(s3)
    800034d0:	014585bb          	addw	a1,a1,s4
    800034d4:	2585                	addiw	a1,a1,1
    800034d6:	0289a503          	lw	a0,40(s3)
    800034da:	fffff097          	auipc	ra,0xfffff
    800034de:	f2c080e7          	jalr	-212(ra) # 80002406 <bread>
    800034e2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034e4:	000aa583          	lw	a1,0(s5)
    800034e8:	0289a503          	lw	a0,40(s3)
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	f1a080e7          	jalr	-230(ra) # 80002406 <bread>
    800034f4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034f6:	40000613          	li	a2,1024
    800034fa:	05890593          	addi	a1,s2,88
    800034fe:	05850513          	addi	a0,a0,88
    80003502:	ffffd097          	auipc	ra,0xffffd
    80003506:	d1e080e7          	jalr	-738(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000350a:	8526                	mv	a0,s1
    8000350c:	fffff097          	auipc	ra,0xfffff
    80003510:	fec080e7          	jalr	-20(ra) # 800024f8 <bwrite>
    if(recovering == 0)
    80003514:	f80b1ce3          	bnez	s6,800034ac <install_trans+0x36>
      bunpin(dbuf);
    80003518:	8526                	mv	a0,s1
    8000351a:	fffff097          	auipc	ra,0xfffff
    8000351e:	0f4080e7          	jalr	244(ra) # 8000260e <bunpin>
    80003522:	b769                	j	800034ac <install_trans+0x36>
}
    80003524:	70e2                	ld	ra,56(sp)
    80003526:	7442                	ld	s0,48(sp)
    80003528:	74a2                	ld	s1,40(sp)
    8000352a:	7902                	ld	s2,32(sp)
    8000352c:	69e2                	ld	s3,24(sp)
    8000352e:	6a42                	ld	s4,16(sp)
    80003530:	6aa2                	ld	s5,8(sp)
    80003532:	6b02                	ld	s6,0(sp)
    80003534:	6121                	addi	sp,sp,64
    80003536:	8082                	ret
    80003538:	8082                	ret

000000008000353a <initlog>:
{
    8000353a:	7179                	addi	sp,sp,-48
    8000353c:	f406                	sd	ra,40(sp)
    8000353e:	f022                	sd	s0,32(sp)
    80003540:	ec26                	sd	s1,24(sp)
    80003542:	e84a                	sd	s2,16(sp)
    80003544:	e44e                	sd	s3,8(sp)
    80003546:	1800                	addi	s0,sp,48
    80003548:	892a                	mv	s2,a0
    8000354a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000354c:	00016497          	auipc	s1,0x16
    80003550:	cd448493          	addi	s1,s1,-812 # 80019220 <log>
    80003554:	00005597          	auipc	a1,0x5
    80003558:	01c58593          	addi	a1,a1,28 # 80008570 <etext+0x570>
    8000355c:	8526                	mv	a0,s1
    8000355e:	00003097          	auipc	ra,0x3
    80003562:	cf8080e7          	jalr	-776(ra) # 80006256 <initlock>
  log.start = sb->logstart;
    80003566:	0149a583          	lw	a1,20(s3)
    8000356a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000356c:	0109a783          	lw	a5,16(s3)
    80003570:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003572:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003576:	854a                	mv	a0,s2
    80003578:	fffff097          	auipc	ra,0xfffff
    8000357c:	e8e080e7          	jalr	-370(ra) # 80002406 <bread>
  log.lh.n = lh->n;
    80003580:	4d30                	lw	a2,88(a0)
    80003582:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003584:	00c05f63          	blez	a2,800035a2 <initlog+0x68>
    80003588:	87aa                	mv	a5,a0
    8000358a:	00016717          	auipc	a4,0x16
    8000358e:	cc670713          	addi	a4,a4,-826 # 80019250 <log+0x30>
    80003592:	060a                	slli	a2,a2,0x2
    80003594:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003596:	4ff4                	lw	a3,92(a5)
    80003598:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000359a:	0791                	addi	a5,a5,4
    8000359c:	0711                	addi	a4,a4,4
    8000359e:	fec79ce3          	bne	a5,a2,80003596 <initlog+0x5c>
  brelse(buf);
    800035a2:	fffff097          	auipc	ra,0xfffff
    800035a6:	f94080e7          	jalr	-108(ra) # 80002536 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035aa:	4505                	li	a0,1
    800035ac:	00000097          	auipc	ra,0x0
    800035b0:	eca080e7          	jalr	-310(ra) # 80003476 <install_trans>
  log.lh.n = 0;
    800035b4:	00016797          	auipc	a5,0x16
    800035b8:	c807ac23          	sw	zero,-872(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800035bc:	00000097          	auipc	ra,0x0
    800035c0:	e50080e7          	jalr	-432(ra) # 8000340c <write_head>
}
    800035c4:	70a2                	ld	ra,40(sp)
    800035c6:	7402                	ld	s0,32(sp)
    800035c8:	64e2                	ld	s1,24(sp)
    800035ca:	6942                	ld	s2,16(sp)
    800035cc:	69a2                	ld	s3,8(sp)
    800035ce:	6145                	addi	sp,sp,48
    800035d0:	8082                	ret

00000000800035d2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035d2:	1101                	addi	sp,sp,-32
    800035d4:	ec06                	sd	ra,24(sp)
    800035d6:	e822                	sd	s0,16(sp)
    800035d8:	e426                	sd	s1,8(sp)
    800035da:	e04a                	sd	s2,0(sp)
    800035dc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035de:	00016517          	auipc	a0,0x16
    800035e2:	c4250513          	addi	a0,a0,-958 # 80019220 <log>
    800035e6:	00003097          	auipc	ra,0x3
    800035ea:	d00080e7          	jalr	-768(ra) # 800062e6 <acquire>
  while(1){
    if(log.committing){
    800035ee:	00016497          	auipc	s1,0x16
    800035f2:	c3248493          	addi	s1,s1,-974 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035f6:	4979                	li	s2,30
    800035f8:	a039                	j	80003606 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035fa:	85a6                	mv	a1,s1
    800035fc:	8526                	mv	a0,s1
    800035fe:	ffffe097          	auipc	ra,0xffffe
    80003602:	f9a080e7          	jalr	-102(ra) # 80001598 <sleep>
    if(log.committing){
    80003606:	50dc                	lw	a5,36(s1)
    80003608:	fbed                	bnez	a5,800035fa <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000360a:	5098                	lw	a4,32(s1)
    8000360c:	2705                	addiw	a4,a4,1
    8000360e:	0027179b          	slliw	a5,a4,0x2
    80003612:	9fb9                	addw	a5,a5,a4
    80003614:	0017979b          	slliw	a5,a5,0x1
    80003618:	54d4                	lw	a3,44(s1)
    8000361a:	9fb5                	addw	a5,a5,a3
    8000361c:	00f95963          	bge	s2,a5,8000362e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003620:	85a6                	mv	a1,s1
    80003622:	8526                	mv	a0,s1
    80003624:	ffffe097          	auipc	ra,0xffffe
    80003628:	f74080e7          	jalr	-140(ra) # 80001598 <sleep>
    8000362c:	bfe9                	j	80003606 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000362e:	00016517          	auipc	a0,0x16
    80003632:	bf250513          	addi	a0,a0,-1038 # 80019220 <log>
    80003636:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003638:	00003097          	auipc	ra,0x3
    8000363c:	d62080e7          	jalr	-670(ra) # 8000639a <release>
      break;
    }
  }
}
    80003640:	60e2                	ld	ra,24(sp)
    80003642:	6442                	ld	s0,16(sp)
    80003644:	64a2                	ld	s1,8(sp)
    80003646:	6902                	ld	s2,0(sp)
    80003648:	6105                	addi	sp,sp,32
    8000364a:	8082                	ret

000000008000364c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000364c:	7139                	addi	sp,sp,-64
    8000364e:	fc06                	sd	ra,56(sp)
    80003650:	f822                	sd	s0,48(sp)
    80003652:	f426                	sd	s1,40(sp)
    80003654:	f04a                	sd	s2,32(sp)
    80003656:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003658:	00016497          	auipc	s1,0x16
    8000365c:	bc848493          	addi	s1,s1,-1080 # 80019220 <log>
    80003660:	8526                	mv	a0,s1
    80003662:	00003097          	auipc	ra,0x3
    80003666:	c84080e7          	jalr	-892(ra) # 800062e6 <acquire>
  log.outstanding -= 1;
    8000366a:	509c                	lw	a5,32(s1)
    8000366c:	37fd                	addiw	a5,a5,-1
    8000366e:	0007891b          	sext.w	s2,a5
    80003672:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003674:	50dc                	lw	a5,36(s1)
    80003676:	e7b9                	bnez	a5,800036c4 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80003678:	06091163          	bnez	s2,800036da <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000367c:	00016497          	auipc	s1,0x16
    80003680:	ba448493          	addi	s1,s1,-1116 # 80019220 <log>
    80003684:	4785                	li	a5,1
    80003686:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003688:	8526                	mv	a0,s1
    8000368a:	00003097          	auipc	ra,0x3
    8000368e:	d10080e7          	jalr	-752(ra) # 8000639a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003692:	54dc                	lw	a5,44(s1)
    80003694:	06f04763          	bgtz	a5,80003702 <end_op+0xb6>
    acquire(&log.lock);
    80003698:	00016497          	auipc	s1,0x16
    8000369c:	b8848493          	addi	s1,s1,-1144 # 80019220 <log>
    800036a0:	8526                	mv	a0,s1
    800036a2:	00003097          	auipc	ra,0x3
    800036a6:	c44080e7          	jalr	-956(ra) # 800062e6 <acquire>
    log.committing = 0;
    800036aa:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036ae:	8526                	mv	a0,s1
    800036b0:	ffffe097          	auipc	ra,0xffffe
    800036b4:	074080e7          	jalr	116(ra) # 80001724 <wakeup>
    release(&log.lock);
    800036b8:	8526                	mv	a0,s1
    800036ba:	00003097          	auipc	ra,0x3
    800036be:	ce0080e7          	jalr	-800(ra) # 8000639a <release>
}
    800036c2:	a815                	j	800036f6 <end_op+0xaa>
    800036c4:	ec4e                	sd	s3,24(sp)
    800036c6:	e852                	sd	s4,16(sp)
    800036c8:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800036ca:	00005517          	auipc	a0,0x5
    800036ce:	eae50513          	addi	a0,a0,-338 # 80008578 <etext+0x578>
    800036d2:	00002097          	auipc	ra,0x2
    800036d6:	69a080e7          	jalr	1690(ra) # 80005d6c <panic>
    wakeup(&log);
    800036da:	00016497          	auipc	s1,0x16
    800036de:	b4648493          	addi	s1,s1,-1210 # 80019220 <log>
    800036e2:	8526                	mv	a0,s1
    800036e4:	ffffe097          	auipc	ra,0xffffe
    800036e8:	040080e7          	jalr	64(ra) # 80001724 <wakeup>
  release(&log.lock);
    800036ec:	8526                	mv	a0,s1
    800036ee:	00003097          	auipc	ra,0x3
    800036f2:	cac080e7          	jalr	-852(ra) # 8000639a <release>
}
    800036f6:	70e2                	ld	ra,56(sp)
    800036f8:	7442                	ld	s0,48(sp)
    800036fa:	74a2                	ld	s1,40(sp)
    800036fc:	7902                	ld	s2,32(sp)
    800036fe:	6121                	addi	sp,sp,64
    80003700:	8082                	ret
    80003702:	ec4e                	sd	s3,24(sp)
    80003704:	e852                	sd	s4,16(sp)
    80003706:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003708:	00016a97          	auipc	s5,0x16
    8000370c:	b48a8a93          	addi	s5,s5,-1208 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003710:	00016a17          	auipc	s4,0x16
    80003714:	b10a0a13          	addi	s4,s4,-1264 # 80019220 <log>
    80003718:	018a2583          	lw	a1,24(s4)
    8000371c:	012585bb          	addw	a1,a1,s2
    80003720:	2585                	addiw	a1,a1,1
    80003722:	028a2503          	lw	a0,40(s4)
    80003726:	fffff097          	auipc	ra,0xfffff
    8000372a:	ce0080e7          	jalr	-800(ra) # 80002406 <bread>
    8000372e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003730:	000aa583          	lw	a1,0(s5)
    80003734:	028a2503          	lw	a0,40(s4)
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	cce080e7          	jalr	-818(ra) # 80002406 <bread>
    80003740:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003742:	40000613          	li	a2,1024
    80003746:	05850593          	addi	a1,a0,88
    8000374a:	05848513          	addi	a0,s1,88
    8000374e:	ffffd097          	auipc	ra,0xffffd
    80003752:	ad2080e7          	jalr	-1326(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    80003756:	8526                	mv	a0,s1
    80003758:	fffff097          	auipc	ra,0xfffff
    8000375c:	da0080e7          	jalr	-608(ra) # 800024f8 <bwrite>
    brelse(from);
    80003760:	854e                	mv	a0,s3
    80003762:	fffff097          	auipc	ra,0xfffff
    80003766:	dd4080e7          	jalr	-556(ra) # 80002536 <brelse>
    brelse(to);
    8000376a:	8526                	mv	a0,s1
    8000376c:	fffff097          	auipc	ra,0xfffff
    80003770:	dca080e7          	jalr	-566(ra) # 80002536 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003774:	2905                	addiw	s2,s2,1
    80003776:	0a91                	addi	s5,s5,4
    80003778:	02ca2783          	lw	a5,44(s4)
    8000377c:	f8f94ee3          	blt	s2,a5,80003718 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003780:	00000097          	auipc	ra,0x0
    80003784:	c8c080e7          	jalr	-884(ra) # 8000340c <write_head>
    install_trans(0); // Now install writes to home locations
    80003788:	4501                	li	a0,0
    8000378a:	00000097          	auipc	ra,0x0
    8000378e:	cec080e7          	jalr	-788(ra) # 80003476 <install_trans>
    log.lh.n = 0;
    80003792:	00016797          	auipc	a5,0x16
    80003796:	aa07ad23          	sw	zero,-1350(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000379a:	00000097          	auipc	ra,0x0
    8000379e:	c72080e7          	jalr	-910(ra) # 8000340c <write_head>
    800037a2:	69e2                	ld	s3,24(sp)
    800037a4:	6a42                	ld	s4,16(sp)
    800037a6:	6aa2                	ld	s5,8(sp)
    800037a8:	bdc5                	j	80003698 <end_op+0x4c>

00000000800037aa <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037aa:	1101                	addi	sp,sp,-32
    800037ac:	ec06                	sd	ra,24(sp)
    800037ae:	e822                	sd	s0,16(sp)
    800037b0:	e426                	sd	s1,8(sp)
    800037b2:	e04a                	sd	s2,0(sp)
    800037b4:	1000                	addi	s0,sp,32
    800037b6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037b8:	00016917          	auipc	s2,0x16
    800037bc:	a6890913          	addi	s2,s2,-1432 # 80019220 <log>
    800037c0:	854a                	mv	a0,s2
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	b24080e7          	jalr	-1244(ra) # 800062e6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037ca:	02c92603          	lw	a2,44(s2)
    800037ce:	47f5                	li	a5,29
    800037d0:	06c7c563          	blt	a5,a2,8000383a <log_write+0x90>
    800037d4:	00016797          	auipc	a5,0x16
    800037d8:	a687a783          	lw	a5,-1432(a5) # 8001923c <log+0x1c>
    800037dc:	37fd                	addiw	a5,a5,-1
    800037de:	04f65e63          	bge	a2,a5,8000383a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037e2:	00016797          	auipc	a5,0x16
    800037e6:	a5e7a783          	lw	a5,-1442(a5) # 80019240 <log+0x20>
    800037ea:	06f05063          	blez	a5,8000384a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037ee:	4781                	li	a5,0
    800037f0:	06c05563          	blez	a2,8000385a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037f4:	44cc                	lw	a1,12(s1)
    800037f6:	00016717          	auipc	a4,0x16
    800037fa:	a5a70713          	addi	a4,a4,-1446 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037fe:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003800:	4314                	lw	a3,0(a4)
    80003802:	04b68c63          	beq	a3,a1,8000385a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003806:	2785                	addiw	a5,a5,1
    80003808:	0711                	addi	a4,a4,4
    8000380a:	fef61be3          	bne	a2,a5,80003800 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000380e:	0621                	addi	a2,a2,8
    80003810:	060a                	slli	a2,a2,0x2
    80003812:	00016797          	auipc	a5,0x16
    80003816:	a0e78793          	addi	a5,a5,-1522 # 80019220 <log>
    8000381a:	97b2                	add	a5,a5,a2
    8000381c:	44d8                	lw	a4,12(s1)
    8000381e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003820:	8526                	mv	a0,s1
    80003822:	fffff097          	auipc	ra,0xfffff
    80003826:	db0080e7          	jalr	-592(ra) # 800025d2 <bpin>
    log.lh.n++;
    8000382a:	00016717          	auipc	a4,0x16
    8000382e:	9f670713          	addi	a4,a4,-1546 # 80019220 <log>
    80003832:	575c                	lw	a5,44(a4)
    80003834:	2785                	addiw	a5,a5,1
    80003836:	d75c                	sw	a5,44(a4)
    80003838:	a82d                	j	80003872 <log_write+0xc8>
    panic("too big a transaction");
    8000383a:	00005517          	auipc	a0,0x5
    8000383e:	d4e50513          	addi	a0,a0,-690 # 80008588 <etext+0x588>
    80003842:	00002097          	auipc	ra,0x2
    80003846:	52a080e7          	jalr	1322(ra) # 80005d6c <panic>
    panic("log_write outside of trans");
    8000384a:	00005517          	auipc	a0,0x5
    8000384e:	d5650513          	addi	a0,a0,-682 # 800085a0 <etext+0x5a0>
    80003852:	00002097          	auipc	ra,0x2
    80003856:	51a080e7          	jalr	1306(ra) # 80005d6c <panic>
  log.lh.block[i] = b->blockno;
    8000385a:	00878693          	addi	a3,a5,8
    8000385e:	068a                	slli	a3,a3,0x2
    80003860:	00016717          	auipc	a4,0x16
    80003864:	9c070713          	addi	a4,a4,-1600 # 80019220 <log>
    80003868:	9736                	add	a4,a4,a3
    8000386a:	44d4                	lw	a3,12(s1)
    8000386c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000386e:	faf609e3          	beq	a2,a5,80003820 <log_write+0x76>
  }
  release(&log.lock);
    80003872:	00016517          	auipc	a0,0x16
    80003876:	9ae50513          	addi	a0,a0,-1618 # 80019220 <log>
    8000387a:	00003097          	auipc	ra,0x3
    8000387e:	b20080e7          	jalr	-1248(ra) # 8000639a <release>
}
    80003882:	60e2                	ld	ra,24(sp)
    80003884:	6442                	ld	s0,16(sp)
    80003886:	64a2                	ld	s1,8(sp)
    80003888:	6902                	ld	s2,0(sp)
    8000388a:	6105                	addi	sp,sp,32
    8000388c:	8082                	ret

000000008000388e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000388e:	1101                	addi	sp,sp,-32
    80003890:	ec06                	sd	ra,24(sp)
    80003892:	e822                	sd	s0,16(sp)
    80003894:	e426                	sd	s1,8(sp)
    80003896:	e04a                	sd	s2,0(sp)
    80003898:	1000                	addi	s0,sp,32
    8000389a:	84aa                	mv	s1,a0
    8000389c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000389e:	00005597          	auipc	a1,0x5
    800038a2:	d2258593          	addi	a1,a1,-734 # 800085c0 <etext+0x5c0>
    800038a6:	0521                	addi	a0,a0,8
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	9ae080e7          	jalr	-1618(ra) # 80006256 <initlock>
  lk->name = name;
    800038b0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038b4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038b8:	0204a423          	sw	zero,40(s1)
}
    800038bc:	60e2                	ld	ra,24(sp)
    800038be:	6442                	ld	s0,16(sp)
    800038c0:	64a2                	ld	s1,8(sp)
    800038c2:	6902                	ld	s2,0(sp)
    800038c4:	6105                	addi	sp,sp,32
    800038c6:	8082                	ret

00000000800038c8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038c8:	1101                	addi	sp,sp,-32
    800038ca:	ec06                	sd	ra,24(sp)
    800038cc:	e822                	sd	s0,16(sp)
    800038ce:	e426                	sd	s1,8(sp)
    800038d0:	e04a                	sd	s2,0(sp)
    800038d2:	1000                	addi	s0,sp,32
    800038d4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d6:	00850913          	addi	s2,a0,8
    800038da:	854a                	mv	a0,s2
    800038dc:	00003097          	auipc	ra,0x3
    800038e0:	a0a080e7          	jalr	-1526(ra) # 800062e6 <acquire>
  while (lk->locked) {
    800038e4:	409c                	lw	a5,0(s1)
    800038e6:	cb89                	beqz	a5,800038f8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038e8:	85ca                	mv	a1,s2
    800038ea:	8526                	mv	a0,s1
    800038ec:	ffffe097          	auipc	ra,0xffffe
    800038f0:	cac080e7          	jalr	-852(ra) # 80001598 <sleep>
  while (lk->locked) {
    800038f4:	409c                	lw	a5,0(s1)
    800038f6:	fbed                	bnez	a5,800038e8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038f8:	4785                	li	a5,1
    800038fa:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038fc:	ffffd097          	auipc	ra,0xffffd
    80003900:	5ca080e7          	jalr	1482(ra) # 80000ec6 <myproc>
    80003904:	591c                	lw	a5,48(a0)
    80003906:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003908:	854a                	mv	a0,s2
    8000390a:	00003097          	auipc	ra,0x3
    8000390e:	a90080e7          	jalr	-1392(ra) # 8000639a <release>
}
    80003912:	60e2                	ld	ra,24(sp)
    80003914:	6442                	ld	s0,16(sp)
    80003916:	64a2                	ld	s1,8(sp)
    80003918:	6902                	ld	s2,0(sp)
    8000391a:	6105                	addi	sp,sp,32
    8000391c:	8082                	ret

000000008000391e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000391e:	1101                	addi	sp,sp,-32
    80003920:	ec06                	sd	ra,24(sp)
    80003922:	e822                	sd	s0,16(sp)
    80003924:	e426                	sd	s1,8(sp)
    80003926:	e04a                	sd	s2,0(sp)
    80003928:	1000                	addi	s0,sp,32
    8000392a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000392c:	00850913          	addi	s2,a0,8
    80003930:	854a                	mv	a0,s2
    80003932:	00003097          	auipc	ra,0x3
    80003936:	9b4080e7          	jalr	-1612(ra) # 800062e6 <acquire>
  lk->locked = 0;
    8000393a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000393e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003942:	8526                	mv	a0,s1
    80003944:	ffffe097          	auipc	ra,0xffffe
    80003948:	de0080e7          	jalr	-544(ra) # 80001724 <wakeup>
  release(&lk->lk);
    8000394c:	854a                	mv	a0,s2
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	a4c080e7          	jalr	-1460(ra) # 8000639a <release>
}
    80003956:	60e2                	ld	ra,24(sp)
    80003958:	6442                	ld	s0,16(sp)
    8000395a:	64a2                	ld	s1,8(sp)
    8000395c:	6902                	ld	s2,0(sp)
    8000395e:	6105                	addi	sp,sp,32
    80003960:	8082                	ret

0000000080003962 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003962:	7179                	addi	sp,sp,-48
    80003964:	f406                	sd	ra,40(sp)
    80003966:	f022                	sd	s0,32(sp)
    80003968:	ec26                	sd	s1,24(sp)
    8000396a:	e84a                	sd	s2,16(sp)
    8000396c:	1800                	addi	s0,sp,48
    8000396e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003970:	00850913          	addi	s2,a0,8
    80003974:	854a                	mv	a0,s2
    80003976:	00003097          	auipc	ra,0x3
    8000397a:	970080e7          	jalr	-1680(ra) # 800062e6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000397e:	409c                	lw	a5,0(s1)
    80003980:	ef91                	bnez	a5,8000399c <holdingsleep+0x3a>
    80003982:	4481                	li	s1,0
  release(&lk->lk);
    80003984:	854a                	mv	a0,s2
    80003986:	00003097          	auipc	ra,0x3
    8000398a:	a14080e7          	jalr	-1516(ra) # 8000639a <release>
  return r;
}
    8000398e:	8526                	mv	a0,s1
    80003990:	70a2                	ld	ra,40(sp)
    80003992:	7402                	ld	s0,32(sp)
    80003994:	64e2                	ld	s1,24(sp)
    80003996:	6942                	ld	s2,16(sp)
    80003998:	6145                	addi	sp,sp,48
    8000399a:	8082                	ret
    8000399c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399e:	0284a983          	lw	s3,40(s1)
    800039a2:	ffffd097          	auipc	ra,0xffffd
    800039a6:	524080e7          	jalr	1316(ra) # 80000ec6 <myproc>
    800039aa:	5904                	lw	s1,48(a0)
    800039ac:	413484b3          	sub	s1,s1,s3
    800039b0:	0014b493          	seqz	s1,s1
    800039b4:	69a2                	ld	s3,8(sp)
    800039b6:	b7f9                	j	80003984 <holdingsleep+0x22>

00000000800039b8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039b8:	1141                	addi	sp,sp,-16
    800039ba:	e406                	sd	ra,8(sp)
    800039bc:	e022                	sd	s0,0(sp)
    800039be:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039c0:	00005597          	auipc	a1,0x5
    800039c4:	c1058593          	addi	a1,a1,-1008 # 800085d0 <etext+0x5d0>
    800039c8:	00016517          	auipc	a0,0x16
    800039cc:	9a050513          	addi	a0,a0,-1632 # 80019368 <ftable>
    800039d0:	00003097          	auipc	ra,0x3
    800039d4:	886080e7          	jalr	-1914(ra) # 80006256 <initlock>
}
    800039d8:	60a2                	ld	ra,8(sp)
    800039da:	6402                	ld	s0,0(sp)
    800039dc:	0141                	addi	sp,sp,16
    800039de:	8082                	ret

00000000800039e0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039e0:	1101                	addi	sp,sp,-32
    800039e2:	ec06                	sd	ra,24(sp)
    800039e4:	e822                	sd	s0,16(sp)
    800039e6:	e426                	sd	s1,8(sp)
    800039e8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039ea:	00016517          	auipc	a0,0x16
    800039ee:	97e50513          	addi	a0,a0,-1666 # 80019368 <ftable>
    800039f2:	00003097          	auipc	ra,0x3
    800039f6:	8f4080e7          	jalr	-1804(ra) # 800062e6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039fa:	00016497          	auipc	s1,0x16
    800039fe:	98648493          	addi	s1,s1,-1658 # 80019380 <ftable+0x18>
    80003a02:	00017717          	auipc	a4,0x17
    80003a06:	91e70713          	addi	a4,a4,-1762 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003a0a:	40dc                	lw	a5,4(s1)
    80003a0c:	cf99                	beqz	a5,80003a2a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a0e:	02848493          	addi	s1,s1,40
    80003a12:	fee49ce3          	bne	s1,a4,80003a0a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a16:	00016517          	auipc	a0,0x16
    80003a1a:	95250513          	addi	a0,a0,-1710 # 80019368 <ftable>
    80003a1e:	00003097          	auipc	ra,0x3
    80003a22:	97c080e7          	jalr	-1668(ra) # 8000639a <release>
  return 0;
    80003a26:	4481                	li	s1,0
    80003a28:	a819                	j	80003a3e <filealloc+0x5e>
      f->ref = 1;
    80003a2a:	4785                	li	a5,1
    80003a2c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a2e:	00016517          	auipc	a0,0x16
    80003a32:	93a50513          	addi	a0,a0,-1734 # 80019368 <ftable>
    80003a36:	00003097          	auipc	ra,0x3
    80003a3a:	964080e7          	jalr	-1692(ra) # 8000639a <release>
}
    80003a3e:	8526                	mv	a0,s1
    80003a40:	60e2                	ld	ra,24(sp)
    80003a42:	6442                	ld	s0,16(sp)
    80003a44:	64a2                	ld	s1,8(sp)
    80003a46:	6105                	addi	sp,sp,32
    80003a48:	8082                	ret

0000000080003a4a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a4a:	1101                	addi	sp,sp,-32
    80003a4c:	ec06                	sd	ra,24(sp)
    80003a4e:	e822                	sd	s0,16(sp)
    80003a50:	e426                	sd	s1,8(sp)
    80003a52:	1000                	addi	s0,sp,32
    80003a54:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a56:	00016517          	auipc	a0,0x16
    80003a5a:	91250513          	addi	a0,a0,-1774 # 80019368 <ftable>
    80003a5e:	00003097          	auipc	ra,0x3
    80003a62:	888080e7          	jalr	-1912(ra) # 800062e6 <acquire>
  if(f->ref < 1)
    80003a66:	40dc                	lw	a5,4(s1)
    80003a68:	02f05263          	blez	a5,80003a8c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a6c:	2785                	addiw	a5,a5,1
    80003a6e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a70:	00016517          	auipc	a0,0x16
    80003a74:	8f850513          	addi	a0,a0,-1800 # 80019368 <ftable>
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	922080e7          	jalr	-1758(ra) # 8000639a <release>
  return f;
}
    80003a80:	8526                	mv	a0,s1
    80003a82:	60e2                	ld	ra,24(sp)
    80003a84:	6442                	ld	s0,16(sp)
    80003a86:	64a2                	ld	s1,8(sp)
    80003a88:	6105                	addi	sp,sp,32
    80003a8a:	8082                	ret
    panic("filedup");
    80003a8c:	00005517          	auipc	a0,0x5
    80003a90:	b4c50513          	addi	a0,a0,-1204 # 800085d8 <etext+0x5d8>
    80003a94:	00002097          	auipc	ra,0x2
    80003a98:	2d8080e7          	jalr	728(ra) # 80005d6c <panic>

0000000080003a9c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a9c:	7139                	addi	sp,sp,-64
    80003a9e:	fc06                	sd	ra,56(sp)
    80003aa0:	f822                	sd	s0,48(sp)
    80003aa2:	f426                	sd	s1,40(sp)
    80003aa4:	0080                	addi	s0,sp,64
    80003aa6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aa8:	00016517          	auipc	a0,0x16
    80003aac:	8c050513          	addi	a0,a0,-1856 # 80019368 <ftable>
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	836080e7          	jalr	-1994(ra) # 800062e6 <acquire>
  if(f->ref < 1)
    80003ab8:	40dc                	lw	a5,4(s1)
    80003aba:	04f05c63          	blez	a5,80003b12 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003abe:	37fd                	addiw	a5,a5,-1
    80003ac0:	0007871b          	sext.w	a4,a5
    80003ac4:	c0dc                	sw	a5,4(s1)
    80003ac6:	06e04263          	bgtz	a4,80003b2a <fileclose+0x8e>
    80003aca:	f04a                	sd	s2,32(sp)
    80003acc:	ec4e                	sd	s3,24(sp)
    80003ace:	e852                	sd	s4,16(sp)
    80003ad0:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ad2:	0004a903          	lw	s2,0(s1)
    80003ad6:	0094ca83          	lbu	s5,9(s1)
    80003ada:	0104ba03          	ld	s4,16(s1)
    80003ade:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ae2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ae6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003aea:	00016517          	auipc	a0,0x16
    80003aee:	87e50513          	addi	a0,a0,-1922 # 80019368 <ftable>
    80003af2:	00003097          	auipc	ra,0x3
    80003af6:	8a8080e7          	jalr	-1880(ra) # 8000639a <release>

  if(ff.type == FD_PIPE){
    80003afa:	4785                	li	a5,1
    80003afc:	04f90463          	beq	s2,a5,80003b44 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b00:	3979                	addiw	s2,s2,-2
    80003b02:	4785                	li	a5,1
    80003b04:	0527fb63          	bgeu	a5,s2,80003b5a <fileclose+0xbe>
    80003b08:	7902                	ld	s2,32(sp)
    80003b0a:	69e2                	ld	s3,24(sp)
    80003b0c:	6a42                	ld	s4,16(sp)
    80003b0e:	6aa2                	ld	s5,8(sp)
    80003b10:	a02d                	j	80003b3a <fileclose+0x9e>
    80003b12:	f04a                	sd	s2,32(sp)
    80003b14:	ec4e                	sd	s3,24(sp)
    80003b16:	e852                	sd	s4,16(sp)
    80003b18:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b1a:	00005517          	auipc	a0,0x5
    80003b1e:	ac650513          	addi	a0,a0,-1338 # 800085e0 <etext+0x5e0>
    80003b22:	00002097          	auipc	ra,0x2
    80003b26:	24a080e7          	jalr	586(ra) # 80005d6c <panic>
    release(&ftable.lock);
    80003b2a:	00016517          	auipc	a0,0x16
    80003b2e:	83e50513          	addi	a0,a0,-1986 # 80019368 <ftable>
    80003b32:	00003097          	auipc	ra,0x3
    80003b36:	868080e7          	jalr	-1944(ra) # 8000639a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b3a:	70e2                	ld	ra,56(sp)
    80003b3c:	7442                	ld	s0,48(sp)
    80003b3e:	74a2                	ld	s1,40(sp)
    80003b40:	6121                	addi	sp,sp,64
    80003b42:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b44:	85d6                	mv	a1,s5
    80003b46:	8552                	mv	a0,s4
    80003b48:	00000097          	auipc	ra,0x0
    80003b4c:	3a2080e7          	jalr	930(ra) # 80003eea <pipeclose>
    80003b50:	7902                	ld	s2,32(sp)
    80003b52:	69e2                	ld	s3,24(sp)
    80003b54:	6a42                	ld	s4,16(sp)
    80003b56:	6aa2                	ld	s5,8(sp)
    80003b58:	b7cd                	j	80003b3a <fileclose+0x9e>
    begin_op();
    80003b5a:	00000097          	auipc	ra,0x0
    80003b5e:	a78080e7          	jalr	-1416(ra) # 800035d2 <begin_op>
    iput(ff.ip);
    80003b62:	854e                	mv	a0,s3
    80003b64:	fffff097          	auipc	ra,0xfffff
    80003b68:	25a080e7          	jalr	602(ra) # 80002dbe <iput>
    end_op();
    80003b6c:	00000097          	auipc	ra,0x0
    80003b70:	ae0080e7          	jalr	-1312(ra) # 8000364c <end_op>
    80003b74:	7902                	ld	s2,32(sp)
    80003b76:	69e2                	ld	s3,24(sp)
    80003b78:	6a42                	ld	s4,16(sp)
    80003b7a:	6aa2                	ld	s5,8(sp)
    80003b7c:	bf7d                	j	80003b3a <fileclose+0x9e>

0000000080003b7e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b7e:	715d                	addi	sp,sp,-80
    80003b80:	e486                	sd	ra,72(sp)
    80003b82:	e0a2                	sd	s0,64(sp)
    80003b84:	fc26                	sd	s1,56(sp)
    80003b86:	f44e                	sd	s3,40(sp)
    80003b88:	0880                	addi	s0,sp,80
    80003b8a:	84aa                	mv	s1,a0
    80003b8c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b8e:	ffffd097          	auipc	ra,0xffffd
    80003b92:	338080e7          	jalr	824(ra) # 80000ec6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b96:	409c                	lw	a5,0(s1)
    80003b98:	37f9                	addiw	a5,a5,-2
    80003b9a:	4705                	li	a4,1
    80003b9c:	04f76863          	bltu	a4,a5,80003bec <filestat+0x6e>
    80003ba0:	f84a                	sd	s2,48(sp)
    80003ba2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ba4:	6c88                	ld	a0,24(s1)
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	05a080e7          	jalr	90(ra) # 80002c00 <ilock>
    stati(f->ip, &st);
    80003bae:	fb840593          	addi	a1,s0,-72
    80003bb2:	6c88                	ld	a0,24(s1)
    80003bb4:	fffff097          	auipc	ra,0xfffff
    80003bb8:	2da080e7          	jalr	730(ra) # 80002e8e <stati>
    iunlock(f->ip);
    80003bbc:	6c88                	ld	a0,24(s1)
    80003bbe:	fffff097          	auipc	ra,0xfffff
    80003bc2:	108080e7          	jalr	264(ra) # 80002cc6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bc6:	46e1                	li	a3,24
    80003bc8:	fb840613          	addi	a2,s0,-72
    80003bcc:	85ce                	mv	a1,s3
    80003bce:	05093503          	ld	a0,80(s2)
    80003bd2:	ffffd097          	auipc	ra,0xffffd
    80003bd6:	f90080e7          	jalr	-112(ra) # 80000b62 <copyout>
    80003bda:	41f5551b          	sraiw	a0,a0,0x1f
    80003bde:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003be0:	60a6                	ld	ra,72(sp)
    80003be2:	6406                	ld	s0,64(sp)
    80003be4:	74e2                	ld	s1,56(sp)
    80003be6:	79a2                	ld	s3,40(sp)
    80003be8:	6161                	addi	sp,sp,80
    80003bea:	8082                	ret
  return -1;
    80003bec:	557d                	li	a0,-1
    80003bee:	bfcd                	j	80003be0 <filestat+0x62>

0000000080003bf0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bf0:	7179                	addi	sp,sp,-48
    80003bf2:	f406                	sd	ra,40(sp)
    80003bf4:	f022                	sd	s0,32(sp)
    80003bf6:	e84a                	sd	s2,16(sp)
    80003bf8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bfa:	00854783          	lbu	a5,8(a0)
    80003bfe:	cbc5                	beqz	a5,80003cae <fileread+0xbe>
    80003c00:	ec26                	sd	s1,24(sp)
    80003c02:	e44e                	sd	s3,8(sp)
    80003c04:	84aa                	mv	s1,a0
    80003c06:	89ae                	mv	s3,a1
    80003c08:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c0a:	411c                	lw	a5,0(a0)
    80003c0c:	4705                	li	a4,1
    80003c0e:	04e78963          	beq	a5,a4,80003c60 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c12:	470d                	li	a4,3
    80003c14:	04e78f63          	beq	a5,a4,80003c72 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c18:	4709                	li	a4,2
    80003c1a:	08e79263          	bne	a5,a4,80003c9e <fileread+0xae>
    ilock(f->ip);
    80003c1e:	6d08                	ld	a0,24(a0)
    80003c20:	fffff097          	auipc	ra,0xfffff
    80003c24:	fe0080e7          	jalr	-32(ra) # 80002c00 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c28:	874a                	mv	a4,s2
    80003c2a:	5094                	lw	a3,32(s1)
    80003c2c:	864e                	mv	a2,s3
    80003c2e:	4585                	li	a1,1
    80003c30:	6c88                	ld	a0,24(s1)
    80003c32:	fffff097          	auipc	ra,0xfffff
    80003c36:	286080e7          	jalr	646(ra) # 80002eb8 <readi>
    80003c3a:	892a                	mv	s2,a0
    80003c3c:	00a05563          	blez	a0,80003c46 <fileread+0x56>
      f->off += r;
    80003c40:	509c                	lw	a5,32(s1)
    80003c42:	9fa9                	addw	a5,a5,a0
    80003c44:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c46:	6c88                	ld	a0,24(s1)
    80003c48:	fffff097          	auipc	ra,0xfffff
    80003c4c:	07e080e7          	jalr	126(ra) # 80002cc6 <iunlock>
    80003c50:	64e2                	ld	s1,24(sp)
    80003c52:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c54:	854a                	mv	a0,s2
    80003c56:	70a2                	ld	ra,40(sp)
    80003c58:	7402                	ld	s0,32(sp)
    80003c5a:	6942                	ld	s2,16(sp)
    80003c5c:	6145                	addi	sp,sp,48
    80003c5e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c60:	6908                	ld	a0,16(a0)
    80003c62:	00000097          	auipc	ra,0x0
    80003c66:	3fa080e7          	jalr	1018(ra) # 8000405c <piperead>
    80003c6a:	892a                	mv	s2,a0
    80003c6c:	64e2                	ld	s1,24(sp)
    80003c6e:	69a2                	ld	s3,8(sp)
    80003c70:	b7d5                	j	80003c54 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c72:	02451783          	lh	a5,36(a0)
    80003c76:	03079693          	slli	a3,a5,0x30
    80003c7a:	92c1                	srli	a3,a3,0x30
    80003c7c:	4725                	li	a4,9
    80003c7e:	02d76a63          	bltu	a4,a3,80003cb2 <fileread+0xc2>
    80003c82:	0792                	slli	a5,a5,0x4
    80003c84:	00015717          	auipc	a4,0x15
    80003c88:	64470713          	addi	a4,a4,1604 # 800192c8 <devsw>
    80003c8c:	97ba                	add	a5,a5,a4
    80003c8e:	639c                	ld	a5,0(a5)
    80003c90:	c78d                	beqz	a5,80003cba <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003c92:	4505                	li	a0,1
    80003c94:	9782                	jalr	a5
    80003c96:	892a                	mv	s2,a0
    80003c98:	64e2                	ld	s1,24(sp)
    80003c9a:	69a2                	ld	s3,8(sp)
    80003c9c:	bf65                	j	80003c54 <fileread+0x64>
    panic("fileread");
    80003c9e:	00005517          	auipc	a0,0x5
    80003ca2:	95250513          	addi	a0,a0,-1710 # 800085f0 <etext+0x5f0>
    80003ca6:	00002097          	auipc	ra,0x2
    80003caa:	0c6080e7          	jalr	198(ra) # 80005d6c <panic>
    return -1;
    80003cae:	597d                	li	s2,-1
    80003cb0:	b755                	j	80003c54 <fileread+0x64>
      return -1;
    80003cb2:	597d                	li	s2,-1
    80003cb4:	64e2                	ld	s1,24(sp)
    80003cb6:	69a2                	ld	s3,8(sp)
    80003cb8:	bf71                	j	80003c54 <fileread+0x64>
    80003cba:	597d                	li	s2,-1
    80003cbc:	64e2                	ld	s1,24(sp)
    80003cbe:	69a2                	ld	s3,8(sp)
    80003cc0:	bf51                	j	80003c54 <fileread+0x64>

0000000080003cc2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003cc2:	00954783          	lbu	a5,9(a0)
    80003cc6:	12078963          	beqz	a5,80003df8 <filewrite+0x136>
{
    80003cca:	715d                	addi	sp,sp,-80
    80003ccc:	e486                	sd	ra,72(sp)
    80003cce:	e0a2                	sd	s0,64(sp)
    80003cd0:	f84a                	sd	s2,48(sp)
    80003cd2:	f052                	sd	s4,32(sp)
    80003cd4:	e85a                	sd	s6,16(sp)
    80003cd6:	0880                	addi	s0,sp,80
    80003cd8:	892a                	mv	s2,a0
    80003cda:	8b2e                	mv	s6,a1
    80003cdc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cde:	411c                	lw	a5,0(a0)
    80003ce0:	4705                	li	a4,1
    80003ce2:	02e78763          	beq	a5,a4,80003d10 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ce6:	470d                	li	a4,3
    80003ce8:	02e78a63          	beq	a5,a4,80003d1c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cec:	4709                	li	a4,2
    80003cee:	0ee79863          	bne	a5,a4,80003dde <filewrite+0x11c>
    80003cf2:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cf4:	0cc05463          	blez	a2,80003dbc <filewrite+0xfa>
    80003cf8:	fc26                	sd	s1,56(sp)
    80003cfa:	ec56                	sd	s5,24(sp)
    80003cfc:	e45e                	sd	s7,8(sp)
    80003cfe:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d00:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d02:	6b85                	lui	s7,0x1
    80003d04:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d08:	6c05                	lui	s8,0x1
    80003d0a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d0e:	a851                	j	80003da2 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d10:	6908                	ld	a0,16(a0)
    80003d12:	00000097          	auipc	ra,0x0
    80003d16:	248080e7          	jalr	584(ra) # 80003f5a <pipewrite>
    80003d1a:	a85d                	j	80003dd0 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d1c:	02451783          	lh	a5,36(a0)
    80003d20:	03079693          	slli	a3,a5,0x30
    80003d24:	92c1                	srli	a3,a3,0x30
    80003d26:	4725                	li	a4,9
    80003d28:	0cd76a63          	bltu	a4,a3,80003dfc <filewrite+0x13a>
    80003d2c:	0792                	slli	a5,a5,0x4
    80003d2e:	00015717          	auipc	a4,0x15
    80003d32:	59a70713          	addi	a4,a4,1434 # 800192c8 <devsw>
    80003d36:	97ba                	add	a5,a5,a4
    80003d38:	679c                	ld	a5,8(a5)
    80003d3a:	c3f9                	beqz	a5,80003e00 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d3c:	4505                	li	a0,1
    80003d3e:	9782                	jalr	a5
    80003d40:	a841                	j	80003dd0 <filewrite+0x10e>
      if(n1 > max)
    80003d42:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	88c080e7          	jalr	-1908(ra) # 800035d2 <begin_op>
      ilock(f->ip);
    80003d4e:	01893503          	ld	a0,24(s2)
    80003d52:	fffff097          	auipc	ra,0xfffff
    80003d56:	eae080e7          	jalr	-338(ra) # 80002c00 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d5a:	8756                	mv	a4,s5
    80003d5c:	02092683          	lw	a3,32(s2)
    80003d60:	01698633          	add	a2,s3,s6
    80003d64:	4585                	li	a1,1
    80003d66:	01893503          	ld	a0,24(s2)
    80003d6a:	fffff097          	auipc	ra,0xfffff
    80003d6e:	252080e7          	jalr	594(ra) # 80002fbc <writei>
    80003d72:	84aa                	mv	s1,a0
    80003d74:	00a05763          	blez	a0,80003d82 <filewrite+0xc0>
        f->off += r;
    80003d78:	02092783          	lw	a5,32(s2)
    80003d7c:	9fa9                	addw	a5,a5,a0
    80003d7e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d82:	01893503          	ld	a0,24(s2)
    80003d86:	fffff097          	auipc	ra,0xfffff
    80003d8a:	f40080e7          	jalr	-192(ra) # 80002cc6 <iunlock>
      end_op();
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	8be080e7          	jalr	-1858(ra) # 8000364c <end_op>

      if(r != n1){
    80003d96:	029a9563          	bne	s5,s1,80003dc0 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003d9a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d9e:	0149da63          	bge	s3,s4,80003db2 <filewrite+0xf0>
      int n1 = n - i;
    80003da2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003da6:	0004879b          	sext.w	a5,s1
    80003daa:	f8fbdce3          	bge	s7,a5,80003d42 <filewrite+0x80>
    80003dae:	84e2                	mv	s1,s8
    80003db0:	bf49                	j	80003d42 <filewrite+0x80>
    80003db2:	74e2                	ld	s1,56(sp)
    80003db4:	6ae2                	ld	s5,24(sp)
    80003db6:	6ba2                	ld	s7,8(sp)
    80003db8:	6c02                	ld	s8,0(sp)
    80003dba:	a039                	j	80003dc8 <filewrite+0x106>
    int i = 0;
    80003dbc:	4981                	li	s3,0
    80003dbe:	a029                	j	80003dc8 <filewrite+0x106>
    80003dc0:	74e2                	ld	s1,56(sp)
    80003dc2:	6ae2                	ld	s5,24(sp)
    80003dc4:	6ba2                	ld	s7,8(sp)
    80003dc6:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003dc8:	033a1e63          	bne	s4,s3,80003e04 <filewrite+0x142>
    80003dcc:	8552                	mv	a0,s4
    80003dce:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dd0:	60a6                	ld	ra,72(sp)
    80003dd2:	6406                	ld	s0,64(sp)
    80003dd4:	7942                	ld	s2,48(sp)
    80003dd6:	7a02                	ld	s4,32(sp)
    80003dd8:	6b42                	ld	s6,16(sp)
    80003dda:	6161                	addi	sp,sp,80
    80003ddc:	8082                	ret
    80003dde:	fc26                	sd	s1,56(sp)
    80003de0:	f44e                	sd	s3,40(sp)
    80003de2:	ec56                	sd	s5,24(sp)
    80003de4:	e45e                	sd	s7,8(sp)
    80003de6:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003de8:	00005517          	auipc	a0,0x5
    80003dec:	81850513          	addi	a0,a0,-2024 # 80008600 <etext+0x600>
    80003df0:	00002097          	auipc	ra,0x2
    80003df4:	f7c080e7          	jalr	-132(ra) # 80005d6c <panic>
    return -1;
    80003df8:	557d                	li	a0,-1
}
    80003dfa:	8082                	ret
      return -1;
    80003dfc:	557d                	li	a0,-1
    80003dfe:	bfc9                	j	80003dd0 <filewrite+0x10e>
    80003e00:	557d                	li	a0,-1
    80003e02:	b7f9                	j	80003dd0 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e04:	557d                	li	a0,-1
    80003e06:	79a2                	ld	s3,40(sp)
    80003e08:	b7e1                	j	80003dd0 <filewrite+0x10e>

0000000080003e0a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e0a:	7179                	addi	sp,sp,-48
    80003e0c:	f406                	sd	ra,40(sp)
    80003e0e:	f022                	sd	s0,32(sp)
    80003e10:	ec26                	sd	s1,24(sp)
    80003e12:	e052                	sd	s4,0(sp)
    80003e14:	1800                	addi	s0,sp,48
    80003e16:	84aa                	mv	s1,a0
    80003e18:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e1a:	0005b023          	sd	zero,0(a1)
    80003e1e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e22:	00000097          	auipc	ra,0x0
    80003e26:	bbe080e7          	jalr	-1090(ra) # 800039e0 <filealloc>
    80003e2a:	e088                	sd	a0,0(s1)
    80003e2c:	cd49                	beqz	a0,80003ec6 <pipealloc+0xbc>
    80003e2e:	00000097          	auipc	ra,0x0
    80003e32:	bb2080e7          	jalr	-1102(ra) # 800039e0 <filealloc>
    80003e36:	00aa3023          	sd	a0,0(s4)
    80003e3a:	c141                	beqz	a0,80003eba <pipealloc+0xb0>
    80003e3c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e3e:	ffffc097          	auipc	ra,0xffffc
    80003e42:	2dc080e7          	jalr	732(ra) # 8000011a <kalloc>
    80003e46:	892a                	mv	s2,a0
    80003e48:	c13d                	beqz	a0,80003eae <pipealloc+0xa4>
    80003e4a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e4c:	4985                	li	s3,1
    80003e4e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e52:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e56:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e5a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e5e:	00004597          	auipc	a1,0x4
    80003e62:	55258593          	addi	a1,a1,1362 # 800083b0 <etext+0x3b0>
    80003e66:	00002097          	auipc	ra,0x2
    80003e6a:	3f0080e7          	jalr	1008(ra) # 80006256 <initlock>
  (*f0)->type = FD_PIPE;
    80003e6e:	609c                	ld	a5,0(s1)
    80003e70:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e74:	609c                	ld	a5,0(s1)
    80003e76:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e7a:	609c                	ld	a5,0(s1)
    80003e7c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e80:	609c                	ld	a5,0(s1)
    80003e82:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e86:	000a3783          	ld	a5,0(s4)
    80003e8a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e8e:	000a3783          	ld	a5,0(s4)
    80003e92:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e96:	000a3783          	ld	a5,0(s4)
    80003e9a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e9e:	000a3783          	ld	a5,0(s4)
    80003ea2:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ea6:	4501                	li	a0,0
    80003ea8:	6942                	ld	s2,16(sp)
    80003eaa:	69a2                	ld	s3,8(sp)
    80003eac:	a03d                	j	80003eda <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003eae:	6088                	ld	a0,0(s1)
    80003eb0:	c119                	beqz	a0,80003eb6 <pipealloc+0xac>
    80003eb2:	6942                	ld	s2,16(sp)
    80003eb4:	a029                	j	80003ebe <pipealloc+0xb4>
    80003eb6:	6942                	ld	s2,16(sp)
    80003eb8:	a039                	j	80003ec6 <pipealloc+0xbc>
    80003eba:	6088                	ld	a0,0(s1)
    80003ebc:	c50d                	beqz	a0,80003ee6 <pipealloc+0xdc>
    fileclose(*f0);
    80003ebe:	00000097          	auipc	ra,0x0
    80003ec2:	bde080e7          	jalr	-1058(ra) # 80003a9c <fileclose>
  if(*f1)
    80003ec6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eca:	557d                	li	a0,-1
  if(*f1)
    80003ecc:	c799                	beqz	a5,80003eda <pipealloc+0xd0>
    fileclose(*f1);
    80003ece:	853e                	mv	a0,a5
    80003ed0:	00000097          	auipc	ra,0x0
    80003ed4:	bcc080e7          	jalr	-1076(ra) # 80003a9c <fileclose>
  return -1;
    80003ed8:	557d                	li	a0,-1
}
    80003eda:	70a2                	ld	ra,40(sp)
    80003edc:	7402                	ld	s0,32(sp)
    80003ede:	64e2                	ld	s1,24(sp)
    80003ee0:	6a02                	ld	s4,0(sp)
    80003ee2:	6145                	addi	sp,sp,48
    80003ee4:	8082                	ret
  return -1;
    80003ee6:	557d                	li	a0,-1
    80003ee8:	bfcd                	j	80003eda <pipealloc+0xd0>

0000000080003eea <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003eea:	1101                	addi	sp,sp,-32
    80003eec:	ec06                	sd	ra,24(sp)
    80003eee:	e822                	sd	s0,16(sp)
    80003ef0:	e426                	sd	s1,8(sp)
    80003ef2:	e04a                	sd	s2,0(sp)
    80003ef4:	1000                	addi	s0,sp,32
    80003ef6:	84aa                	mv	s1,a0
    80003ef8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003efa:	00002097          	auipc	ra,0x2
    80003efe:	3ec080e7          	jalr	1004(ra) # 800062e6 <acquire>
  if(writable){
    80003f02:	02090d63          	beqz	s2,80003f3c <pipeclose+0x52>
    pi->writeopen = 0;
    80003f06:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f0a:	21848513          	addi	a0,s1,536
    80003f0e:	ffffe097          	auipc	ra,0xffffe
    80003f12:	816080e7          	jalr	-2026(ra) # 80001724 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f16:	2204b783          	ld	a5,544(s1)
    80003f1a:	eb95                	bnez	a5,80003f4e <pipeclose+0x64>
    release(&pi->lock);
    80003f1c:	8526                	mv	a0,s1
    80003f1e:	00002097          	auipc	ra,0x2
    80003f22:	47c080e7          	jalr	1148(ra) # 8000639a <release>
    kfree((char*)pi);
    80003f26:	8526                	mv	a0,s1
    80003f28:	ffffc097          	auipc	ra,0xffffc
    80003f2c:	0f4080e7          	jalr	244(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f30:	60e2                	ld	ra,24(sp)
    80003f32:	6442                	ld	s0,16(sp)
    80003f34:	64a2                	ld	s1,8(sp)
    80003f36:	6902                	ld	s2,0(sp)
    80003f38:	6105                	addi	sp,sp,32
    80003f3a:	8082                	ret
    pi->readopen = 0;
    80003f3c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f40:	21c48513          	addi	a0,s1,540
    80003f44:	ffffd097          	auipc	ra,0xffffd
    80003f48:	7e0080e7          	jalr	2016(ra) # 80001724 <wakeup>
    80003f4c:	b7e9                	j	80003f16 <pipeclose+0x2c>
    release(&pi->lock);
    80003f4e:	8526                	mv	a0,s1
    80003f50:	00002097          	auipc	ra,0x2
    80003f54:	44a080e7          	jalr	1098(ra) # 8000639a <release>
}
    80003f58:	bfe1                	j	80003f30 <pipeclose+0x46>

0000000080003f5a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f5a:	711d                	addi	sp,sp,-96
    80003f5c:	ec86                	sd	ra,88(sp)
    80003f5e:	e8a2                	sd	s0,80(sp)
    80003f60:	e4a6                	sd	s1,72(sp)
    80003f62:	e0ca                	sd	s2,64(sp)
    80003f64:	fc4e                	sd	s3,56(sp)
    80003f66:	f852                	sd	s4,48(sp)
    80003f68:	f456                	sd	s5,40(sp)
    80003f6a:	1080                	addi	s0,sp,96
    80003f6c:	84aa                	mv	s1,a0
    80003f6e:	8aae                	mv	s5,a1
    80003f70:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f72:	ffffd097          	auipc	ra,0xffffd
    80003f76:	f54080e7          	jalr	-172(ra) # 80000ec6 <myproc>
    80003f7a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f7c:	8526                	mv	a0,s1
    80003f7e:	00002097          	auipc	ra,0x2
    80003f82:	368080e7          	jalr	872(ra) # 800062e6 <acquire>
  while(i < n){
    80003f86:	0d405563          	blez	s4,80004050 <pipewrite+0xf6>
    80003f8a:	f05a                	sd	s6,32(sp)
    80003f8c:	ec5e                	sd	s7,24(sp)
    80003f8e:	e862                	sd	s8,16(sp)
  int i = 0;
    80003f90:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f92:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f94:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f98:	21c48b93          	addi	s7,s1,540
    80003f9c:	a089                	j	80003fde <pipewrite+0x84>
      release(&pi->lock);
    80003f9e:	8526                	mv	a0,s1
    80003fa0:	00002097          	auipc	ra,0x2
    80003fa4:	3fa080e7          	jalr	1018(ra) # 8000639a <release>
      return -1;
    80003fa8:	597d                	li	s2,-1
    80003faa:	7b02                	ld	s6,32(sp)
    80003fac:	6be2                	ld	s7,24(sp)
    80003fae:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fb0:	854a                	mv	a0,s2
    80003fb2:	60e6                	ld	ra,88(sp)
    80003fb4:	6446                	ld	s0,80(sp)
    80003fb6:	64a6                	ld	s1,72(sp)
    80003fb8:	6906                	ld	s2,64(sp)
    80003fba:	79e2                	ld	s3,56(sp)
    80003fbc:	7a42                	ld	s4,48(sp)
    80003fbe:	7aa2                	ld	s5,40(sp)
    80003fc0:	6125                	addi	sp,sp,96
    80003fc2:	8082                	ret
      wakeup(&pi->nread);
    80003fc4:	8562                	mv	a0,s8
    80003fc6:	ffffd097          	auipc	ra,0xffffd
    80003fca:	75e080e7          	jalr	1886(ra) # 80001724 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fce:	85a6                	mv	a1,s1
    80003fd0:	855e                	mv	a0,s7
    80003fd2:	ffffd097          	auipc	ra,0xffffd
    80003fd6:	5c6080e7          	jalr	1478(ra) # 80001598 <sleep>
  while(i < n){
    80003fda:	05495c63          	bge	s2,s4,80004032 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80003fde:	2204a783          	lw	a5,544(s1)
    80003fe2:	dfd5                	beqz	a5,80003f9e <pipewrite+0x44>
    80003fe4:	0289a783          	lw	a5,40(s3)
    80003fe8:	fbdd                	bnez	a5,80003f9e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fea:	2184a783          	lw	a5,536(s1)
    80003fee:	21c4a703          	lw	a4,540(s1)
    80003ff2:	2007879b          	addiw	a5,a5,512
    80003ff6:	fcf707e3          	beq	a4,a5,80003fc4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ffa:	4685                	li	a3,1
    80003ffc:	01590633          	add	a2,s2,s5
    80004000:	faf40593          	addi	a1,s0,-81
    80004004:	0509b503          	ld	a0,80(s3)
    80004008:	ffffd097          	auipc	ra,0xffffd
    8000400c:	be6080e7          	jalr	-1050(ra) # 80000bee <copyin>
    80004010:	05650263          	beq	a0,s6,80004054 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004014:	21c4a783          	lw	a5,540(s1)
    80004018:	0017871b          	addiw	a4,a5,1
    8000401c:	20e4ae23          	sw	a4,540(s1)
    80004020:	1ff7f793          	andi	a5,a5,511
    80004024:	97a6                	add	a5,a5,s1
    80004026:	faf44703          	lbu	a4,-81(s0)
    8000402a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000402e:	2905                	addiw	s2,s2,1
    80004030:	b76d                	j	80003fda <pipewrite+0x80>
    80004032:	7b02                	ld	s6,32(sp)
    80004034:	6be2                	ld	s7,24(sp)
    80004036:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004038:	21848513          	addi	a0,s1,536
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	6e8080e7          	jalr	1768(ra) # 80001724 <wakeup>
  release(&pi->lock);
    80004044:	8526                	mv	a0,s1
    80004046:	00002097          	auipc	ra,0x2
    8000404a:	354080e7          	jalr	852(ra) # 8000639a <release>
  return i;
    8000404e:	b78d                	j	80003fb0 <pipewrite+0x56>
  int i = 0;
    80004050:	4901                	li	s2,0
    80004052:	b7dd                	j	80004038 <pipewrite+0xde>
    80004054:	7b02                	ld	s6,32(sp)
    80004056:	6be2                	ld	s7,24(sp)
    80004058:	6c42                	ld	s8,16(sp)
    8000405a:	bff9                	j	80004038 <pipewrite+0xde>

000000008000405c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000405c:	715d                	addi	sp,sp,-80
    8000405e:	e486                	sd	ra,72(sp)
    80004060:	e0a2                	sd	s0,64(sp)
    80004062:	fc26                	sd	s1,56(sp)
    80004064:	f84a                	sd	s2,48(sp)
    80004066:	f44e                	sd	s3,40(sp)
    80004068:	f052                	sd	s4,32(sp)
    8000406a:	ec56                	sd	s5,24(sp)
    8000406c:	0880                	addi	s0,sp,80
    8000406e:	84aa                	mv	s1,a0
    80004070:	892e                	mv	s2,a1
    80004072:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004074:	ffffd097          	auipc	ra,0xffffd
    80004078:	e52080e7          	jalr	-430(ra) # 80000ec6 <myproc>
    8000407c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000407e:	8526                	mv	a0,s1
    80004080:	00002097          	auipc	ra,0x2
    80004084:	266080e7          	jalr	614(ra) # 800062e6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004088:	2184a703          	lw	a4,536(s1)
    8000408c:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004090:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004094:	02f71663          	bne	a4,a5,800040c0 <piperead+0x64>
    80004098:	2244a783          	lw	a5,548(s1)
    8000409c:	cb9d                	beqz	a5,800040d2 <piperead+0x76>
    if(pr->killed){
    8000409e:	028a2783          	lw	a5,40(s4)
    800040a2:	e38d                	bnez	a5,800040c4 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040a4:	85a6                	mv	a1,s1
    800040a6:	854e                	mv	a0,s3
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	4f0080e7          	jalr	1264(ra) # 80001598 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b0:	2184a703          	lw	a4,536(s1)
    800040b4:	21c4a783          	lw	a5,540(s1)
    800040b8:	fef700e3          	beq	a4,a5,80004098 <piperead+0x3c>
    800040bc:	e85a                	sd	s6,16(sp)
    800040be:	a819                	j	800040d4 <piperead+0x78>
    800040c0:	e85a                	sd	s6,16(sp)
    800040c2:	a809                	j	800040d4 <piperead+0x78>
      release(&pi->lock);
    800040c4:	8526                	mv	a0,s1
    800040c6:	00002097          	auipc	ra,0x2
    800040ca:	2d4080e7          	jalr	724(ra) # 8000639a <release>
      return -1;
    800040ce:	59fd                	li	s3,-1
    800040d0:	a0a5                	j	80004138 <piperead+0xdc>
    800040d2:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040d4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040d6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040d8:	05505463          	blez	s5,80004120 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    800040dc:	2184a783          	lw	a5,536(s1)
    800040e0:	21c4a703          	lw	a4,540(s1)
    800040e4:	02f70e63          	beq	a4,a5,80004120 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040e8:	0017871b          	addiw	a4,a5,1
    800040ec:	20e4ac23          	sw	a4,536(s1)
    800040f0:	1ff7f793          	andi	a5,a5,511
    800040f4:	97a6                	add	a5,a5,s1
    800040f6:	0187c783          	lbu	a5,24(a5)
    800040fa:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040fe:	4685                	li	a3,1
    80004100:	fbf40613          	addi	a2,s0,-65
    80004104:	85ca                	mv	a1,s2
    80004106:	050a3503          	ld	a0,80(s4)
    8000410a:	ffffd097          	auipc	ra,0xffffd
    8000410e:	a58080e7          	jalr	-1448(ra) # 80000b62 <copyout>
    80004112:	01650763          	beq	a0,s6,80004120 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004116:	2985                	addiw	s3,s3,1
    80004118:	0905                	addi	s2,s2,1
    8000411a:	fd3a91e3          	bne	s5,s3,800040dc <piperead+0x80>
    8000411e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004120:	21c48513          	addi	a0,s1,540
    80004124:	ffffd097          	auipc	ra,0xffffd
    80004128:	600080e7          	jalr	1536(ra) # 80001724 <wakeup>
  release(&pi->lock);
    8000412c:	8526                	mv	a0,s1
    8000412e:	00002097          	auipc	ra,0x2
    80004132:	26c080e7          	jalr	620(ra) # 8000639a <release>
    80004136:	6b42                	ld	s6,16(sp)
  return i;
}
    80004138:	854e                	mv	a0,s3
    8000413a:	60a6                	ld	ra,72(sp)
    8000413c:	6406                	ld	s0,64(sp)
    8000413e:	74e2                	ld	s1,56(sp)
    80004140:	7942                	ld	s2,48(sp)
    80004142:	79a2                	ld	s3,40(sp)
    80004144:	7a02                	ld	s4,32(sp)
    80004146:	6ae2                	ld	s5,24(sp)
    80004148:	6161                	addi	sp,sp,80
    8000414a:	8082                	ret

000000008000414c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000414c:	df010113          	addi	sp,sp,-528
    80004150:	20113423          	sd	ra,520(sp)
    80004154:	20813023          	sd	s0,512(sp)
    80004158:	ffa6                	sd	s1,504(sp)
    8000415a:	fbca                	sd	s2,496(sp)
    8000415c:	0c00                	addi	s0,sp,528
    8000415e:	892a                	mv	s2,a0
    80004160:	dea43c23          	sd	a0,-520(s0)
    80004164:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004168:	ffffd097          	auipc	ra,0xffffd
    8000416c:	d5e080e7          	jalr	-674(ra) # 80000ec6 <myproc>
    80004170:	84aa                	mv	s1,a0

  begin_op();
    80004172:	fffff097          	auipc	ra,0xfffff
    80004176:	460080e7          	jalr	1120(ra) # 800035d2 <begin_op>

  if((ip = namei(path)) == 0){
    8000417a:	854a                	mv	a0,s2
    8000417c:	fffff097          	auipc	ra,0xfffff
    80004180:	256080e7          	jalr	598(ra) # 800033d2 <namei>
    80004184:	c135                	beqz	a0,800041e8 <exec+0x9c>
    80004186:	f3d2                	sd	s4,480(sp)
    80004188:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000418a:	fffff097          	auipc	ra,0xfffff
    8000418e:	a76080e7          	jalr	-1418(ra) # 80002c00 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004192:	04000713          	li	a4,64
    80004196:	4681                	li	a3,0
    80004198:	e5040613          	addi	a2,s0,-432
    8000419c:	4581                	li	a1,0
    8000419e:	8552                	mv	a0,s4
    800041a0:	fffff097          	auipc	ra,0xfffff
    800041a4:	d18080e7          	jalr	-744(ra) # 80002eb8 <readi>
    800041a8:	04000793          	li	a5,64
    800041ac:	00f51a63          	bne	a0,a5,800041c0 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041b0:	e5042703          	lw	a4,-432(s0)
    800041b4:	464c47b7          	lui	a5,0x464c4
    800041b8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041bc:	02f70c63          	beq	a4,a5,800041f4 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041c0:	8552                	mv	a0,s4
    800041c2:	fffff097          	auipc	ra,0xfffff
    800041c6:	ca4080e7          	jalr	-860(ra) # 80002e66 <iunlockput>
    end_op();
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	482080e7          	jalr	1154(ra) # 8000364c <end_op>
  }
  return -1;
    800041d2:	557d                	li	a0,-1
    800041d4:	7a1e                	ld	s4,480(sp)
}
    800041d6:	20813083          	ld	ra,520(sp)
    800041da:	20013403          	ld	s0,512(sp)
    800041de:	74fe                	ld	s1,504(sp)
    800041e0:	795e                	ld	s2,496(sp)
    800041e2:	21010113          	addi	sp,sp,528
    800041e6:	8082                	ret
    end_op();
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	464080e7          	jalr	1124(ra) # 8000364c <end_op>
    return -1;
    800041f0:	557d                	li	a0,-1
    800041f2:	b7d5                	j	800041d6 <exec+0x8a>
    800041f4:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800041f6:	8526                	mv	a0,s1
    800041f8:	ffffd097          	auipc	ra,0xffffd
    800041fc:	d92080e7          	jalr	-622(ra) # 80000f8a <proc_pagetable>
    80004200:	8b2a                	mv	s6,a0
    80004202:	30050563          	beqz	a0,8000450c <exec+0x3c0>
    80004206:	f7ce                	sd	s3,488(sp)
    80004208:	efd6                	sd	s5,472(sp)
    8000420a:	e7de                	sd	s7,456(sp)
    8000420c:	e3e2                	sd	s8,448(sp)
    8000420e:	ff66                	sd	s9,440(sp)
    80004210:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004212:	e7042d03          	lw	s10,-400(s0)
    80004216:	e8845783          	lhu	a5,-376(s0)
    8000421a:	14078563          	beqz	a5,80004364 <exec+0x218>
    8000421e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004220:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004222:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004224:	6c85                	lui	s9,0x1
    80004226:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000422a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000422e:	6a85                	lui	s5,0x1
    80004230:	a0b5                	j	8000429c <exec+0x150>
      panic("loadseg: address should exist");
    80004232:	00004517          	auipc	a0,0x4
    80004236:	3de50513          	addi	a0,a0,990 # 80008610 <etext+0x610>
    8000423a:	00002097          	auipc	ra,0x2
    8000423e:	b32080e7          	jalr	-1230(ra) # 80005d6c <panic>
    if(sz - i < PGSIZE)
    80004242:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004244:	8726                	mv	a4,s1
    80004246:	012c06bb          	addw	a3,s8,s2
    8000424a:	4581                	li	a1,0
    8000424c:	8552                	mv	a0,s4
    8000424e:	fffff097          	auipc	ra,0xfffff
    80004252:	c6a080e7          	jalr	-918(ra) # 80002eb8 <readi>
    80004256:	2501                	sext.w	a0,a0
    80004258:	26a49e63          	bne	s1,a0,800044d4 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000425c:	012a893b          	addw	s2,s5,s2
    80004260:	03397563          	bgeu	s2,s3,8000428a <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004264:	02091593          	slli	a1,s2,0x20
    80004268:	9181                	srli	a1,a1,0x20
    8000426a:	95de                	add	a1,a1,s7
    8000426c:	855a                	mv	a0,s6
    8000426e:	ffffc097          	auipc	ra,0xffffc
    80004272:	2d4080e7          	jalr	724(ra) # 80000542 <walkaddr>
    80004276:	862a                	mv	a2,a0
    if(pa == 0)
    80004278:	dd4d                	beqz	a0,80004232 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000427a:	412984bb          	subw	s1,s3,s2
    8000427e:	0004879b          	sext.w	a5,s1
    80004282:	fcfcf0e3          	bgeu	s9,a5,80004242 <exec+0xf6>
    80004286:	84d6                	mv	s1,s5
    80004288:	bf6d                	j	80004242 <exec+0xf6>
    sz = sz1;
    8000428a:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000428e:	2d85                	addiw	s11,s11,1
    80004290:	038d0d1b          	addiw	s10,s10,56
    80004294:	e8845783          	lhu	a5,-376(s0)
    80004298:	06fddf63          	bge	s11,a5,80004316 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000429c:	2d01                	sext.w	s10,s10
    8000429e:	03800713          	li	a4,56
    800042a2:	86ea                	mv	a3,s10
    800042a4:	e1840613          	addi	a2,s0,-488
    800042a8:	4581                	li	a1,0
    800042aa:	8552                	mv	a0,s4
    800042ac:	fffff097          	auipc	ra,0xfffff
    800042b0:	c0c080e7          	jalr	-1012(ra) # 80002eb8 <readi>
    800042b4:	03800793          	li	a5,56
    800042b8:	1ef51863          	bne	a0,a5,800044a8 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800042bc:	e1842783          	lw	a5,-488(s0)
    800042c0:	4705                	li	a4,1
    800042c2:	fce796e3          	bne	a5,a4,8000428e <exec+0x142>
    if(ph.memsz < ph.filesz)
    800042c6:	e4043603          	ld	a2,-448(s0)
    800042ca:	e3843783          	ld	a5,-456(s0)
    800042ce:	1ef66163          	bltu	a2,a5,800044b0 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042d2:	e2843783          	ld	a5,-472(s0)
    800042d6:	963e                	add	a2,a2,a5
    800042d8:	1ef66063          	bltu	a2,a5,800044b8 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042dc:	85a6                	mv	a1,s1
    800042de:	855a                	mv	a0,s6
    800042e0:	ffffc097          	auipc	ra,0xffffc
    800042e4:	626080e7          	jalr	1574(ra) # 80000906 <uvmalloc>
    800042e8:	e0a43423          	sd	a0,-504(s0)
    800042ec:	1c050a63          	beqz	a0,800044c0 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    800042f0:	e2843b83          	ld	s7,-472(s0)
    800042f4:	df043783          	ld	a5,-528(s0)
    800042f8:	00fbf7b3          	and	a5,s7,a5
    800042fc:	1c079a63          	bnez	a5,800044d0 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004300:	e2042c03          	lw	s8,-480(s0)
    80004304:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004308:	00098463          	beqz	s3,80004310 <exec+0x1c4>
    8000430c:	4901                	li	s2,0
    8000430e:	bf99                	j	80004264 <exec+0x118>
    sz = sz1;
    80004310:	e0843483          	ld	s1,-504(s0)
    80004314:	bfad                	j	8000428e <exec+0x142>
    80004316:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004318:	8552                	mv	a0,s4
    8000431a:	fffff097          	auipc	ra,0xfffff
    8000431e:	b4c080e7          	jalr	-1204(ra) # 80002e66 <iunlockput>
  end_op();
    80004322:	fffff097          	auipc	ra,0xfffff
    80004326:	32a080e7          	jalr	810(ra) # 8000364c <end_op>
  p = myproc();
    8000432a:	ffffd097          	auipc	ra,0xffffd
    8000432e:	b9c080e7          	jalr	-1124(ra) # 80000ec6 <myproc>
    80004332:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004334:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004338:	6985                	lui	s3,0x1
    8000433a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000433c:	99a6                	add	s3,s3,s1
    8000433e:	77fd                	lui	a5,0xfffff
    80004340:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004344:	6609                	lui	a2,0x2
    80004346:	964e                	add	a2,a2,s3
    80004348:	85ce                	mv	a1,s3
    8000434a:	855a                	mv	a0,s6
    8000434c:	ffffc097          	auipc	ra,0xffffc
    80004350:	5ba080e7          	jalr	1466(ra) # 80000906 <uvmalloc>
    80004354:	892a                	mv	s2,a0
    80004356:	e0a43423          	sd	a0,-504(s0)
    8000435a:	e519                	bnez	a0,80004368 <exec+0x21c>
  if(pagetable)
    8000435c:	e1343423          	sd	s3,-504(s0)
    80004360:	4a01                	li	s4,0
    80004362:	aa95                	j	800044d6 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004364:	4481                	li	s1,0
    80004366:	bf4d                	j	80004318 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004368:	75f9                	lui	a1,0xffffe
    8000436a:	95aa                	add	a1,a1,a0
    8000436c:	855a                	mv	a0,s6
    8000436e:	ffffc097          	auipc	ra,0xffffc
    80004372:	7c2080e7          	jalr	1986(ra) # 80000b30 <uvmclear>
  stackbase = sp - PGSIZE;
    80004376:	7bfd                	lui	s7,0xfffff
    80004378:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000437a:	e0043783          	ld	a5,-512(s0)
    8000437e:	6388                	ld	a0,0(a5)
    80004380:	c52d                	beqz	a0,800043ea <exec+0x29e>
    80004382:	e9040993          	addi	s3,s0,-368
    80004386:	f9040c13          	addi	s8,s0,-112
    8000438a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000438c:	ffffc097          	auipc	ra,0xffffc
    80004390:	fac080e7          	jalr	-84(ra) # 80000338 <strlen>
    80004394:	0015079b          	addiw	a5,a0,1
    80004398:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000439c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043a0:	13796463          	bltu	s2,s7,800044c8 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043a4:	e0043d03          	ld	s10,-512(s0)
    800043a8:	000d3a03          	ld	s4,0(s10)
    800043ac:	8552                	mv	a0,s4
    800043ae:	ffffc097          	auipc	ra,0xffffc
    800043b2:	f8a080e7          	jalr	-118(ra) # 80000338 <strlen>
    800043b6:	0015069b          	addiw	a3,a0,1
    800043ba:	8652                	mv	a2,s4
    800043bc:	85ca                	mv	a1,s2
    800043be:	855a                	mv	a0,s6
    800043c0:	ffffc097          	auipc	ra,0xffffc
    800043c4:	7a2080e7          	jalr	1954(ra) # 80000b62 <copyout>
    800043c8:	10054263          	bltz	a0,800044cc <exec+0x380>
    ustack[argc] = sp;
    800043cc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043d0:	0485                	addi	s1,s1,1
    800043d2:	008d0793          	addi	a5,s10,8
    800043d6:	e0f43023          	sd	a5,-512(s0)
    800043da:	008d3503          	ld	a0,8(s10)
    800043de:	c909                	beqz	a0,800043f0 <exec+0x2a4>
    if(argc >= MAXARG)
    800043e0:	09a1                	addi	s3,s3,8
    800043e2:	fb8995e3          	bne	s3,s8,8000438c <exec+0x240>
  ip = 0;
    800043e6:	4a01                	li	s4,0
    800043e8:	a0fd                	j	800044d6 <exec+0x38a>
  sp = sz;
    800043ea:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800043ee:	4481                	li	s1,0
  ustack[argc] = 0;
    800043f0:	00349793          	slli	a5,s1,0x3
    800043f4:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    800043f8:	97a2                	add	a5,a5,s0
    800043fa:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043fe:	00148693          	addi	a3,s1,1
    80004402:	068e                	slli	a3,a3,0x3
    80004404:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004408:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000440c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004410:	f57966e3          	bltu	s2,s7,8000435c <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004414:	e9040613          	addi	a2,s0,-368
    80004418:	85ca                	mv	a1,s2
    8000441a:	855a                	mv	a0,s6
    8000441c:	ffffc097          	auipc	ra,0xffffc
    80004420:	746080e7          	jalr	1862(ra) # 80000b62 <copyout>
    80004424:	0e054663          	bltz	a0,80004510 <exec+0x3c4>
  p->trapframe->a1 = sp;
    80004428:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000442c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004430:	df843783          	ld	a5,-520(s0)
    80004434:	0007c703          	lbu	a4,0(a5)
    80004438:	cf11                	beqz	a4,80004454 <exec+0x308>
    8000443a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000443c:	02f00693          	li	a3,47
    80004440:	a039                	j	8000444e <exec+0x302>
      last = s+1;
    80004442:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004446:	0785                	addi	a5,a5,1
    80004448:	fff7c703          	lbu	a4,-1(a5)
    8000444c:	c701                	beqz	a4,80004454 <exec+0x308>
    if(*s == '/')
    8000444e:	fed71ce3          	bne	a4,a3,80004446 <exec+0x2fa>
    80004452:	bfc5                	j	80004442 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004454:	4641                	li	a2,16
    80004456:	df843583          	ld	a1,-520(s0)
    8000445a:	158a8513          	addi	a0,s5,344
    8000445e:	ffffc097          	auipc	ra,0xffffc
    80004462:	ea8080e7          	jalr	-344(ra) # 80000306 <safestrcpy>
  oldpagetable = p->pagetable;
    80004466:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000446a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000446e:	e0843783          	ld	a5,-504(s0)
    80004472:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004476:	058ab783          	ld	a5,88(s5)
    8000447a:	e6843703          	ld	a4,-408(s0)
    8000447e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004480:	058ab783          	ld	a5,88(s5)
    80004484:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004488:	85e6                	mv	a1,s9
    8000448a:	ffffd097          	auipc	ra,0xffffd
    8000448e:	b9c080e7          	jalr	-1124(ra) # 80001026 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004492:	0004851b          	sext.w	a0,s1
    80004496:	79be                	ld	s3,488(sp)
    80004498:	7a1e                	ld	s4,480(sp)
    8000449a:	6afe                	ld	s5,472(sp)
    8000449c:	6b5e                	ld	s6,464(sp)
    8000449e:	6bbe                	ld	s7,456(sp)
    800044a0:	6c1e                	ld	s8,448(sp)
    800044a2:	7cfa                	ld	s9,440(sp)
    800044a4:	7d5a                	ld	s10,432(sp)
    800044a6:	bb05                	j	800041d6 <exec+0x8a>
    800044a8:	e0943423          	sd	s1,-504(s0)
    800044ac:	7dba                	ld	s11,424(sp)
    800044ae:	a025                	j	800044d6 <exec+0x38a>
    800044b0:	e0943423          	sd	s1,-504(s0)
    800044b4:	7dba                	ld	s11,424(sp)
    800044b6:	a005                	j	800044d6 <exec+0x38a>
    800044b8:	e0943423          	sd	s1,-504(s0)
    800044bc:	7dba                	ld	s11,424(sp)
    800044be:	a821                	j	800044d6 <exec+0x38a>
    800044c0:	e0943423          	sd	s1,-504(s0)
    800044c4:	7dba                	ld	s11,424(sp)
    800044c6:	a801                	j	800044d6 <exec+0x38a>
  ip = 0;
    800044c8:	4a01                	li	s4,0
    800044ca:	a031                	j	800044d6 <exec+0x38a>
    800044cc:	4a01                	li	s4,0
  if(pagetable)
    800044ce:	a021                	j	800044d6 <exec+0x38a>
    800044d0:	7dba                	ld	s11,424(sp)
    800044d2:	a011                	j	800044d6 <exec+0x38a>
    800044d4:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800044d6:	e0843583          	ld	a1,-504(s0)
    800044da:	855a                	mv	a0,s6
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	b4a080e7          	jalr	-1206(ra) # 80001026 <proc_freepagetable>
  return -1;
    800044e4:	557d                	li	a0,-1
  if(ip){
    800044e6:	000a1b63          	bnez	s4,800044fc <exec+0x3b0>
    800044ea:	79be                	ld	s3,488(sp)
    800044ec:	7a1e                	ld	s4,480(sp)
    800044ee:	6afe                	ld	s5,472(sp)
    800044f0:	6b5e                	ld	s6,464(sp)
    800044f2:	6bbe                	ld	s7,456(sp)
    800044f4:	6c1e                	ld	s8,448(sp)
    800044f6:	7cfa                	ld	s9,440(sp)
    800044f8:	7d5a                	ld	s10,432(sp)
    800044fa:	b9f1                	j	800041d6 <exec+0x8a>
    800044fc:	79be                	ld	s3,488(sp)
    800044fe:	6afe                	ld	s5,472(sp)
    80004500:	6b5e                	ld	s6,464(sp)
    80004502:	6bbe                	ld	s7,456(sp)
    80004504:	6c1e                	ld	s8,448(sp)
    80004506:	7cfa                	ld	s9,440(sp)
    80004508:	7d5a                	ld	s10,432(sp)
    8000450a:	b95d                	j	800041c0 <exec+0x74>
    8000450c:	6b5e                	ld	s6,464(sp)
    8000450e:	b94d                	j	800041c0 <exec+0x74>
  sz = sz1;
    80004510:	e0843983          	ld	s3,-504(s0)
    80004514:	b5a1                	j	8000435c <exec+0x210>

0000000080004516 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004516:	7179                	addi	sp,sp,-48
    80004518:	f406                	sd	ra,40(sp)
    8000451a:	f022                	sd	s0,32(sp)
    8000451c:	ec26                	sd	s1,24(sp)
    8000451e:	e84a                	sd	s2,16(sp)
    80004520:	1800                	addi	s0,sp,48
    80004522:	892e                	mv	s2,a1
    80004524:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004526:	fdc40593          	addi	a1,s0,-36
    8000452a:	ffffe097          	auipc	ra,0xffffe
    8000452e:	a96080e7          	jalr	-1386(ra) # 80001fc0 <argint>
    80004532:	04054063          	bltz	a0,80004572 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004536:	fdc42703          	lw	a4,-36(s0)
    8000453a:	47bd                	li	a5,15
    8000453c:	02e7ed63          	bltu	a5,a4,80004576 <argfd+0x60>
    80004540:	ffffd097          	auipc	ra,0xffffd
    80004544:	986080e7          	jalr	-1658(ra) # 80000ec6 <myproc>
    80004548:	fdc42703          	lw	a4,-36(s0)
    8000454c:	01a70793          	addi	a5,a4,26
    80004550:	078e                	slli	a5,a5,0x3
    80004552:	953e                	add	a0,a0,a5
    80004554:	611c                	ld	a5,0(a0)
    80004556:	c395                	beqz	a5,8000457a <argfd+0x64>
    return -1;
  if(pfd)
    80004558:	00090463          	beqz	s2,80004560 <argfd+0x4a>
    *pfd = fd;
    8000455c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004560:	4501                	li	a0,0
  if(pf)
    80004562:	c091                	beqz	s1,80004566 <argfd+0x50>
    *pf = f;
    80004564:	e09c                	sd	a5,0(s1)
}
    80004566:	70a2                	ld	ra,40(sp)
    80004568:	7402                	ld	s0,32(sp)
    8000456a:	64e2                	ld	s1,24(sp)
    8000456c:	6942                	ld	s2,16(sp)
    8000456e:	6145                	addi	sp,sp,48
    80004570:	8082                	ret
    return -1;
    80004572:	557d                	li	a0,-1
    80004574:	bfcd                	j	80004566 <argfd+0x50>
    return -1;
    80004576:	557d                	li	a0,-1
    80004578:	b7fd                	j	80004566 <argfd+0x50>
    8000457a:	557d                	li	a0,-1
    8000457c:	b7ed                	j	80004566 <argfd+0x50>

000000008000457e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000457e:	1101                	addi	sp,sp,-32
    80004580:	ec06                	sd	ra,24(sp)
    80004582:	e822                	sd	s0,16(sp)
    80004584:	e426                	sd	s1,8(sp)
    80004586:	1000                	addi	s0,sp,32
    80004588:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000458a:	ffffd097          	auipc	ra,0xffffd
    8000458e:	93c080e7          	jalr	-1732(ra) # 80000ec6 <myproc>
    80004592:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004594:	0d050793          	addi	a5,a0,208
    80004598:	4501                	li	a0,0
    8000459a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000459c:	6398                	ld	a4,0(a5)
    8000459e:	cb19                	beqz	a4,800045b4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045a0:	2505                	addiw	a0,a0,1
    800045a2:	07a1                	addi	a5,a5,8
    800045a4:	fed51ce3          	bne	a0,a3,8000459c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045a8:	557d                	li	a0,-1
}
    800045aa:	60e2                	ld	ra,24(sp)
    800045ac:	6442                	ld	s0,16(sp)
    800045ae:	64a2                	ld	s1,8(sp)
    800045b0:	6105                	addi	sp,sp,32
    800045b2:	8082                	ret
      p->ofile[fd] = f;
    800045b4:	01a50793          	addi	a5,a0,26
    800045b8:	078e                	slli	a5,a5,0x3
    800045ba:	963e                	add	a2,a2,a5
    800045bc:	e204                	sd	s1,0(a2)
      return fd;
    800045be:	b7f5                	j	800045aa <fdalloc+0x2c>

00000000800045c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045c0:	715d                	addi	sp,sp,-80
    800045c2:	e486                	sd	ra,72(sp)
    800045c4:	e0a2                	sd	s0,64(sp)
    800045c6:	fc26                	sd	s1,56(sp)
    800045c8:	f84a                	sd	s2,48(sp)
    800045ca:	f44e                	sd	s3,40(sp)
    800045cc:	f052                	sd	s4,32(sp)
    800045ce:	ec56                	sd	s5,24(sp)
    800045d0:	0880                	addi	s0,sp,80
    800045d2:	8aae                	mv	s5,a1
    800045d4:	8a32                	mv	s4,a2
    800045d6:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045d8:	fb040593          	addi	a1,s0,-80
    800045dc:	fffff097          	auipc	ra,0xfffff
    800045e0:	e14080e7          	jalr	-492(ra) # 800033f0 <nameiparent>
    800045e4:	892a                	mv	s2,a0
    800045e6:	12050c63          	beqz	a0,8000471e <create+0x15e>
    return 0;

  ilock(dp);
    800045ea:	ffffe097          	auipc	ra,0xffffe
    800045ee:	616080e7          	jalr	1558(ra) # 80002c00 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045f2:	4601                	li	a2,0
    800045f4:	fb040593          	addi	a1,s0,-80
    800045f8:	854a                	mv	a0,s2
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	b06080e7          	jalr	-1274(ra) # 80003100 <dirlookup>
    80004602:	84aa                	mv	s1,a0
    80004604:	c539                	beqz	a0,80004652 <create+0x92>
    iunlockput(dp);
    80004606:	854a                	mv	a0,s2
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	85e080e7          	jalr	-1954(ra) # 80002e66 <iunlockput>
    ilock(ip);
    80004610:	8526                	mv	a0,s1
    80004612:	ffffe097          	auipc	ra,0xffffe
    80004616:	5ee080e7          	jalr	1518(ra) # 80002c00 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000461a:	4789                	li	a5,2
    8000461c:	02fa9463          	bne	s5,a5,80004644 <create+0x84>
    80004620:	0444d783          	lhu	a5,68(s1)
    80004624:	37f9                	addiw	a5,a5,-2
    80004626:	17c2                	slli	a5,a5,0x30
    80004628:	93c1                	srli	a5,a5,0x30
    8000462a:	4705                	li	a4,1
    8000462c:	00f76c63          	bltu	a4,a5,80004644 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004630:	8526                	mv	a0,s1
    80004632:	60a6                	ld	ra,72(sp)
    80004634:	6406                	ld	s0,64(sp)
    80004636:	74e2                	ld	s1,56(sp)
    80004638:	7942                	ld	s2,48(sp)
    8000463a:	79a2                	ld	s3,40(sp)
    8000463c:	7a02                	ld	s4,32(sp)
    8000463e:	6ae2                	ld	s5,24(sp)
    80004640:	6161                	addi	sp,sp,80
    80004642:	8082                	ret
    iunlockput(ip);
    80004644:	8526                	mv	a0,s1
    80004646:	fffff097          	auipc	ra,0xfffff
    8000464a:	820080e7          	jalr	-2016(ra) # 80002e66 <iunlockput>
    return 0;
    8000464e:	4481                	li	s1,0
    80004650:	b7c5                	j	80004630 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004652:	85d6                	mv	a1,s5
    80004654:	00092503          	lw	a0,0(s2)
    80004658:	ffffe097          	auipc	ra,0xffffe
    8000465c:	414080e7          	jalr	1044(ra) # 80002a6c <ialloc>
    80004660:	84aa                	mv	s1,a0
    80004662:	c139                	beqz	a0,800046a8 <create+0xe8>
  ilock(ip);
    80004664:	ffffe097          	auipc	ra,0xffffe
    80004668:	59c080e7          	jalr	1436(ra) # 80002c00 <ilock>
  ip->major = major;
    8000466c:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004670:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004674:	4985                	li	s3,1
    80004676:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000467a:	8526                	mv	a0,s1
    8000467c:	ffffe097          	auipc	ra,0xffffe
    80004680:	4b8080e7          	jalr	1208(ra) # 80002b34 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004684:	033a8a63          	beq	s5,s3,800046b8 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004688:	40d0                	lw	a2,4(s1)
    8000468a:	fb040593          	addi	a1,s0,-80
    8000468e:	854a                	mv	a0,s2
    80004690:	fffff097          	auipc	ra,0xfffff
    80004694:	c80080e7          	jalr	-896(ra) # 80003310 <dirlink>
    80004698:	06054b63          	bltz	a0,8000470e <create+0x14e>
  iunlockput(dp);
    8000469c:	854a                	mv	a0,s2
    8000469e:	ffffe097          	auipc	ra,0xffffe
    800046a2:	7c8080e7          	jalr	1992(ra) # 80002e66 <iunlockput>
  return ip;
    800046a6:	b769                	j	80004630 <create+0x70>
    panic("create: ialloc");
    800046a8:	00004517          	auipc	a0,0x4
    800046ac:	f8850513          	addi	a0,a0,-120 # 80008630 <etext+0x630>
    800046b0:	00001097          	auipc	ra,0x1
    800046b4:	6bc080e7          	jalr	1724(ra) # 80005d6c <panic>
    dp->nlink++;  // for ".."
    800046b8:	04a95783          	lhu	a5,74(s2)
    800046bc:	2785                	addiw	a5,a5,1
    800046be:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046c2:	854a                	mv	a0,s2
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	470080e7          	jalr	1136(ra) # 80002b34 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046cc:	40d0                	lw	a2,4(s1)
    800046ce:	00004597          	auipc	a1,0x4
    800046d2:	f7258593          	addi	a1,a1,-142 # 80008640 <etext+0x640>
    800046d6:	8526                	mv	a0,s1
    800046d8:	fffff097          	auipc	ra,0xfffff
    800046dc:	c38080e7          	jalr	-968(ra) # 80003310 <dirlink>
    800046e0:	00054f63          	bltz	a0,800046fe <create+0x13e>
    800046e4:	00492603          	lw	a2,4(s2)
    800046e8:	00004597          	auipc	a1,0x4
    800046ec:	f6058593          	addi	a1,a1,-160 # 80008648 <etext+0x648>
    800046f0:	8526                	mv	a0,s1
    800046f2:	fffff097          	auipc	ra,0xfffff
    800046f6:	c1e080e7          	jalr	-994(ra) # 80003310 <dirlink>
    800046fa:	f80557e3          	bgez	a0,80004688 <create+0xc8>
      panic("create dots");
    800046fe:	00004517          	auipc	a0,0x4
    80004702:	f5250513          	addi	a0,a0,-174 # 80008650 <etext+0x650>
    80004706:	00001097          	auipc	ra,0x1
    8000470a:	666080e7          	jalr	1638(ra) # 80005d6c <panic>
    panic("create: dirlink");
    8000470e:	00004517          	auipc	a0,0x4
    80004712:	f5250513          	addi	a0,a0,-174 # 80008660 <etext+0x660>
    80004716:	00001097          	auipc	ra,0x1
    8000471a:	656080e7          	jalr	1622(ra) # 80005d6c <panic>
    return 0;
    8000471e:	84aa                	mv	s1,a0
    80004720:	bf01                	j	80004630 <create+0x70>

0000000080004722 <sys_dup>:
{
    80004722:	7179                	addi	sp,sp,-48
    80004724:	f406                	sd	ra,40(sp)
    80004726:	f022                	sd	s0,32(sp)
    80004728:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000472a:	fd840613          	addi	a2,s0,-40
    8000472e:	4581                	li	a1,0
    80004730:	4501                	li	a0,0
    80004732:	00000097          	auipc	ra,0x0
    80004736:	de4080e7          	jalr	-540(ra) # 80004516 <argfd>
    return -1;
    8000473a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000473c:	02054763          	bltz	a0,8000476a <sys_dup+0x48>
    80004740:	ec26                	sd	s1,24(sp)
    80004742:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004744:	fd843903          	ld	s2,-40(s0)
    80004748:	854a                	mv	a0,s2
    8000474a:	00000097          	auipc	ra,0x0
    8000474e:	e34080e7          	jalr	-460(ra) # 8000457e <fdalloc>
    80004752:	84aa                	mv	s1,a0
    return -1;
    80004754:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004756:	00054f63          	bltz	a0,80004774 <sys_dup+0x52>
  filedup(f);
    8000475a:	854a                	mv	a0,s2
    8000475c:	fffff097          	auipc	ra,0xfffff
    80004760:	2ee080e7          	jalr	750(ra) # 80003a4a <filedup>
  return fd;
    80004764:	87a6                	mv	a5,s1
    80004766:	64e2                	ld	s1,24(sp)
    80004768:	6942                	ld	s2,16(sp)
}
    8000476a:	853e                	mv	a0,a5
    8000476c:	70a2                	ld	ra,40(sp)
    8000476e:	7402                	ld	s0,32(sp)
    80004770:	6145                	addi	sp,sp,48
    80004772:	8082                	ret
    80004774:	64e2                	ld	s1,24(sp)
    80004776:	6942                	ld	s2,16(sp)
    80004778:	bfcd                	j	8000476a <sys_dup+0x48>

000000008000477a <sys_read>:
{
    8000477a:	7179                	addi	sp,sp,-48
    8000477c:	f406                	sd	ra,40(sp)
    8000477e:	f022                	sd	s0,32(sp)
    80004780:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004782:	fe840613          	addi	a2,s0,-24
    80004786:	4581                	li	a1,0
    80004788:	4501                	li	a0,0
    8000478a:	00000097          	auipc	ra,0x0
    8000478e:	d8c080e7          	jalr	-628(ra) # 80004516 <argfd>
    return -1;
    80004792:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004794:	04054163          	bltz	a0,800047d6 <sys_read+0x5c>
    80004798:	fe440593          	addi	a1,s0,-28
    8000479c:	4509                	li	a0,2
    8000479e:	ffffe097          	auipc	ra,0xffffe
    800047a2:	822080e7          	jalr	-2014(ra) # 80001fc0 <argint>
    return -1;
    800047a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047a8:	02054763          	bltz	a0,800047d6 <sys_read+0x5c>
    800047ac:	fd840593          	addi	a1,s0,-40
    800047b0:	4505                	li	a0,1
    800047b2:	ffffe097          	auipc	ra,0xffffe
    800047b6:	830080e7          	jalr	-2000(ra) # 80001fe2 <argaddr>
    return -1;
    800047ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047bc:	00054d63          	bltz	a0,800047d6 <sys_read+0x5c>
  return fileread(f, p, n);
    800047c0:	fe442603          	lw	a2,-28(s0)
    800047c4:	fd843583          	ld	a1,-40(s0)
    800047c8:	fe843503          	ld	a0,-24(s0)
    800047cc:	fffff097          	auipc	ra,0xfffff
    800047d0:	424080e7          	jalr	1060(ra) # 80003bf0 <fileread>
    800047d4:	87aa                	mv	a5,a0
}
    800047d6:	853e                	mv	a0,a5
    800047d8:	70a2                	ld	ra,40(sp)
    800047da:	7402                	ld	s0,32(sp)
    800047dc:	6145                	addi	sp,sp,48
    800047de:	8082                	ret

00000000800047e0 <sys_write>:
{
    800047e0:	7179                	addi	sp,sp,-48
    800047e2:	f406                	sd	ra,40(sp)
    800047e4:	f022                	sd	s0,32(sp)
    800047e6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047e8:	fe840613          	addi	a2,s0,-24
    800047ec:	4581                	li	a1,0
    800047ee:	4501                	li	a0,0
    800047f0:	00000097          	auipc	ra,0x0
    800047f4:	d26080e7          	jalr	-730(ra) # 80004516 <argfd>
    return -1;
    800047f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047fa:	04054163          	bltz	a0,8000483c <sys_write+0x5c>
    800047fe:	fe440593          	addi	a1,s0,-28
    80004802:	4509                	li	a0,2
    80004804:	ffffd097          	auipc	ra,0xffffd
    80004808:	7bc080e7          	jalr	1980(ra) # 80001fc0 <argint>
    return -1;
    8000480c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000480e:	02054763          	bltz	a0,8000483c <sys_write+0x5c>
    80004812:	fd840593          	addi	a1,s0,-40
    80004816:	4505                	li	a0,1
    80004818:	ffffd097          	auipc	ra,0xffffd
    8000481c:	7ca080e7          	jalr	1994(ra) # 80001fe2 <argaddr>
    return -1;
    80004820:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004822:	00054d63          	bltz	a0,8000483c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004826:	fe442603          	lw	a2,-28(s0)
    8000482a:	fd843583          	ld	a1,-40(s0)
    8000482e:	fe843503          	ld	a0,-24(s0)
    80004832:	fffff097          	auipc	ra,0xfffff
    80004836:	490080e7          	jalr	1168(ra) # 80003cc2 <filewrite>
    8000483a:	87aa                	mv	a5,a0
}
    8000483c:	853e                	mv	a0,a5
    8000483e:	70a2                	ld	ra,40(sp)
    80004840:	7402                	ld	s0,32(sp)
    80004842:	6145                	addi	sp,sp,48
    80004844:	8082                	ret

0000000080004846 <sys_close>:
{
    80004846:	1101                	addi	sp,sp,-32
    80004848:	ec06                	sd	ra,24(sp)
    8000484a:	e822                	sd	s0,16(sp)
    8000484c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000484e:	fe040613          	addi	a2,s0,-32
    80004852:	fec40593          	addi	a1,s0,-20
    80004856:	4501                	li	a0,0
    80004858:	00000097          	auipc	ra,0x0
    8000485c:	cbe080e7          	jalr	-834(ra) # 80004516 <argfd>
    return -1;
    80004860:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004862:	02054463          	bltz	a0,8000488a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004866:	ffffc097          	auipc	ra,0xffffc
    8000486a:	660080e7          	jalr	1632(ra) # 80000ec6 <myproc>
    8000486e:	fec42783          	lw	a5,-20(s0)
    80004872:	07e9                	addi	a5,a5,26
    80004874:	078e                	slli	a5,a5,0x3
    80004876:	953e                	add	a0,a0,a5
    80004878:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000487c:	fe043503          	ld	a0,-32(s0)
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	21c080e7          	jalr	540(ra) # 80003a9c <fileclose>
  return 0;
    80004888:	4781                	li	a5,0
}
    8000488a:	853e                	mv	a0,a5
    8000488c:	60e2                	ld	ra,24(sp)
    8000488e:	6442                	ld	s0,16(sp)
    80004890:	6105                	addi	sp,sp,32
    80004892:	8082                	ret

0000000080004894 <sys_fstat>:
{
    80004894:	1101                	addi	sp,sp,-32
    80004896:	ec06                	sd	ra,24(sp)
    80004898:	e822                	sd	s0,16(sp)
    8000489a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000489c:	fe840613          	addi	a2,s0,-24
    800048a0:	4581                	li	a1,0
    800048a2:	4501                	li	a0,0
    800048a4:	00000097          	auipc	ra,0x0
    800048a8:	c72080e7          	jalr	-910(ra) # 80004516 <argfd>
    return -1;
    800048ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048ae:	02054563          	bltz	a0,800048d8 <sys_fstat+0x44>
    800048b2:	fe040593          	addi	a1,s0,-32
    800048b6:	4505                	li	a0,1
    800048b8:	ffffd097          	auipc	ra,0xffffd
    800048bc:	72a080e7          	jalr	1834(ra) # 80001fe2 <argaddr>
    return -1;
    800048c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048c2:	00054b63          	bltz	a0,800048d8 <sys_fstat+0x44>
  return filestat(f, st);
    800048c6:	fe043583          	ld	a1,-32(s0)
    800048ca:	fe843503          	ld	a0,-24(s0)
    800048ce:	fffff097          	auipc	ra,0xfffff
    800048d2:	2b0080e7          	jalr	688(ra) # 80003b7e <filestat>
    800048d6:	87aa                	mv	a5,a0
}
    800048d8:	853e                	mv	a0,a5
    800048da:	60e2                	ld	ra,24(sp)
    800048dc:	6442                	ld	s0,16(sp)
    800048de:	6105                	addi	sp,sp,32
    800048e0:	8082                	ret

00000000800048e2 <sys_link>:
{
    800048e2:	7169                	addi	sp,sp,-304
    800048e4:	f606                	sd	ra,296(sp)
    800048e6:	f222                	sd	s0,288(sp)
    800048e8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048ea:	08000613          	li	a2,128
    800048ee:	ed040593          	addi	a1,s0,-304
    800048f2:	4501                	li	a0,0
    800048f4:	ffffd097          	auipc	ra,0xffffd
    800048f8:	710080e7          	jalr	1808(ra) # 80002004 <argstr>
    return -1;
    800048fc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048fe:	12054663          	bltz	a0,80004a2a <sys_link+0x148>
    80004902:	08000613          	li	a2,128
    80004906:	f5040593          	addi	a1,s0,-176
    8000490a:	4505                	li	a0,1
    8000490c:	ffffd097          	auipc	ra,0xffffd
    80004910:	6f8080e7          	jalr	1784(ra) # 80002004 <argstr>
    return -1;
    80004914:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004916:	10054a63          	bltz	a0,80004a2a <sys_link+0x148>
    8000491a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	cb6080e7          	jalr	-842(ra) # 800035d2 <begin_op>
  if((ip = namei(old)) == 0){
    80004924:	ed040513          	addi	a0,s0,-304
    80004928:	fffff097          	auipc	ra,0xfffff
    8000492c:	aaa080e7          	jalr	-1366(ra) # 800033d2 <namei>
    80004930:	84aa                	mv	s1,a0
    80004932:	c949                	beqz	a0,800049c4 <sys_link+0xe2>
  ilock(ip);
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	2cc080e7          	jalr	716(ra) # 80002c00 <ilock>
  if(ip->type == T_DIR){
    8000493c:	04449703          	lh	a4,68(s1)
    80004940:	4785                	li	a5,1
    80004942:	08f70863          	beq	a4,a5,800049d2 <sys_link+0xf0>
    80004946:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004948:	04a4d783          	lhu	a5,74(s1)
    8000494c:	2785                	addiw	a5,a5,1
    8000494e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004952:	8526                	mv	a0,s1
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	1e0080e7          	jalr	480(ra) # 80002b34 <iupdate>
  iunlock(ip);
    8000495c:	8526                	mv	a0,s1
    8000495e:	ffffe097          	auipc	ra,0xffffe
    80004962:	368080e7          	jalr	872(ra) # 80002cc6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004966:	fd040593          	addi	a1,s0,-48
    8000496a:	f5040513          	addi	a0,s0,-176
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	a82080e7          	jalr	-1406(ra) # 800033f0 <nameiparent>
    80004976:	892a                	mv	s2,a0
    80004978:	cd35                	beqz	a0,800049f4 <sys_link+0x112>
  ilock(dp);
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	286080e7          	jalr	646(ra) # 80002c00 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004982:	00092703          	lw	a4,0(s2)
    80004986:	409c                	lw	a5,0(s1)
    80004988:	06f71163          	bne	a4,a5,800049ea <sys_link+0x108>
    8000498c:	40d0                	lw	a2,4(s1)
    8000498e:	fd040593          	addi	a1,s0,-48
    80004992:	854a                	mv	a0,s2
    80004994:	fffff097          	auipc	ra,0xfffff
    80004998:	97c080e7          	jalr	-1668(ra) # 80003310 <dirlink>
    8000499c:	04054763          	bltz	a0,800049ea <sys_link+0x108>
  iunlockput(dp);
    800049a0:	854a                	mv	a0,s2
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	4c4080e7          	jalr	1220(ra) # 80002e66 <iunlockput>
  iput(ip);
    800049aa:	8526                	mv	a0,s1
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	412080e7          	jalr	1042(ra) # 80002dbe <iput>
  end_op();
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	c98080e7          	jalr	-872(ra) # 8000364c <end_op>
  return 0;
    800049bc:	4781                	li	a5,0
    800049be:	64f2                	ld	s1,280(sp)
    800049c0:	6952                	ld	s2,272(sp)
    800049c2:	a0a5                	j	80004a2a <sys_link+0x148>
    end_op();
    800049c4:	fffff097          	auipc	ra,0xfffff
    800049c8:	c88080e7          	jalr	-888(ra) # 8000364c <end_op>
    return -1;
    800049cc:	57fd                	li	a5,-1
    800049ce:	64f2                	ld	s1,280(sp)
    800049d0:	a8a9                	j	80004a2a <sys_link+0x148>
    iunlockput(ip);
    800049d2:	8526                	mv	a0,s1
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	492080e7          	jalr	1170(ra) # 80002e66 <iunlockput>
    end_op();
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	c70080e7          	jalr	-912(ra) # 8000364c <end_op>
    return -1;
    800049e4:	57fd                	li	a5,-1
    800049e6:	64f2                	ld	s1,280(sp)
    800049e8:	a089                	j	80004a2a <sys_link+0x148>
    iunlockput(dp);
    800049ea:	854a                	mv	a0,s2
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	47a080e7          	jalr	1146(ra) # 80002e66 <iunlockput>
  ilock(ip);
    800049f4:	8526                	mv	a0,s1
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	20a080e7          	jalr	522(ra) # 80002c00 <ilock>
  ip->nlink--;
    800049fe:	04a4d783          	lhu	a5,74(s1)
    80004a02:	37fd                	addiw	a5,a5,-1
    80004a04:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	12a080e7          	jalr	298(ra) # 80002b34 <iupdate>
  iunlockput(ip);
    80004a12:	8526                	mv	a0,s1
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	452080e7          	jalr	1106(ra) # 80002e66 <iunlockput>
  end_op();
    80004a1c:	fffff097          	auipc	ra,0xfffff
    80004a20:	c30080e7          	jalr	-976(ra) # 8000364c <end_op>
  return -1;
    80004a24:	57fd                	li	a5,-1
    80004a26:	64f2                	ld	s1,280(sp)
    80004a28:	6952                	ld	s2,272(sp)
}
    80004a2a:	853e                	mv	a0,a5
    80004a2c:	70b2                	ld	ra,296(sp)
    80004a2e:	7412                	ld	s0,288(sp)
    80004a30:	6155                	addi	sp,sp,304
    80004a32:	8082                	ret

0000000080004a34 <sys_unlink>:
{
    80004a34:	7151                	addi	sp,sp,-240
    80004a36:	f586                	sd	ra,232(sp)
    80004a38:	f1a2                	sd	s0,224(sp)
    80004a3a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a3c:	08000613          	li	a2,128
    80004a40:	f3040593          	addi	a1,s0,-208
    80004a44:	4501                	li	a0,0
    80004a46:	ffffd097          	auipc	ra,0xffffd
    80004a4a:	5be080e7          	jalr	1470(ra) # 80002004 <argstr>
    80004a4e:	1a054a63          	bltz	a0,80004c02 <sys_unlink+0x1ce>
    80004a52:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	b7e080e7          	jalr	-1154(ra) # 800035d2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a5c:	fb040593          	addi	a1,s0,-80
    80004a60:	f3040513          	addi	a0,s0,-208
    80004a64:	fffff097          	auipc	ra,0xfffff
    80004a68:	98c080e7          	jalr	-1652(ra) # 800033f0 <nameiparent>
    80004a6c:	84aa                	mv	s1,a0
    80004a6e:	cd71                	beqz	a0,80004b4a <sys_unlink+0x116>
  ilock(dp);
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	190080e7          	jalr	400(ra) # 80002c00 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a78:	00004597          	auipc	a1,0x4
    80004a7c:	bc858593          	addi	a1,a1,-1080 # 80008640 <etext+0x640>
    80004a80:	fb040513          	addi	a0,s0,-80
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	662080e7          	jalr	1634(ra) # 800030e6 <namecmp>
    80004a8c:	14050c63          	beqz	a0,80004be4 <sys_unlink+0x1b0>
    80004a90:	00004597          	auipc	a1,0x4
    80004a94:	bb858593          	addi	a1,a1,-1096 # 80008648 <etext+0x648>
    80004a98:	fb040513          	addi	a0,s0,-80
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	64a080e7          	jalr	1610(ra) # 800030e6 <namecmp>
    80004aa4:	14050063          	beqz	a0,80004be4 <sys_unlink+0x1b0>
    80004aa8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004aaa:	f2c40613          	addi	a2,s0,-212
    80004aae:	fb040593          	addi	a1,s0,-80
    80004ab2:	8526                	mv	a0,s1
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	64c080e7          	jalr	1612(ra) # 80003100 <dirlookup>
    80004abc:	892a                	mv	s2,a0
    80004abe:	12050263          	beqz	a0,80004be2 <sys_unlink+0x1ae>
  ilock(ip);
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	13e080e7          	jalr	318(ra) # 80002c00 <ilock>
  if(ip->nlink < 1)
    80004aca:	04a91783          	lh	a5,74(s2)
    80004ace:	08f05563          	blez	a5,80004b58 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ad2:	04491703          	lh	a4,68(s2)
    80004ad6:	4785                	li	a5,1
    80004ad8:	08f70963          	beq	a4,a5,80004b6a <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004adc:	4641                	li	a2,16
    80004ade:	4581                	li	a1,0
    80004ae0:	fc040513          	addi	a0,s0,-64
    80004ae4:	ffffb097          	auipc	ra,0xffffb
    80004ae8:	6e0080e7          	jalr	1760(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aec:	4741                	li	a4,16
    80004aee:	f2c42683          	lw	a3,-212(s0)
    80004af2:	fc040613          	addi	a2,s0,-64
    80004af6:	4581                	li	a1,0
    80004af8:	8526                	mv	a0,s1
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	4c2080e7          	jalr	1218(ra) # 80002fbc <writei>
    80004b02:	47c1                	li	a5,16
    80004b04:	0af51b63          	bne	a0,a5,80004bba <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b08:	04491703          	lh	a4,68(s2)
    80004b0c:	4785                	li	a5,1
    80004b0e:	0af70f63          	beq	a4,a5,80004bcc <sys_unlink+0x198>
  iunlockput(dp);
    80004b12:	8526                	mv	a0,s1
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	352080e7          	jalr	850(ra) # 80002e66 <iunlockput>
  ip->nlink--;
    80004b1c:	04a95783          	lhu	a5,74(s2)
    80004b20:	37fd                	addiw	a5,a5,-1
    80004b22:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b26:	854a                	mv	a0,s2
    80004b28:	ffffe097          	auipc	ra,0xffffe
    80004b2c:	00c080e7          	jalr	12(ra) # 80002b34 <iupdate>
  iunlockput(ip);
    80004b30:	854a                	mv	a0,s2
    80004b32:	ffffe097          	auipc	ra,0xffffe
    80004b36:	334080e7          	jalr	820(ra) # 80002e66 <iunlockput>
  end_op();
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	b12080e7          	jalr	-1262(ra) # 8000364c <end_op>
  return 0;
    80004b42:	4501                	li	a0,0
    80004b44:	64ee                	ld	s1,216(sp)
    80004b46:	694e                	ld	s2,208(sp)
    80004b48:	a84d                	j	80004bfa <sys_unlink+0x1c6>
    end_op();
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	b02080e7          	jalr	-1278(ra) # 8000364c <end_op>
    return -1;
    80004b52:	557d                	li	a0,-1
    80004b54:	64ee                	ld	s1,216(sp)
    80004b56:	a055                	j	80004bfa <sys_unlink+0x1c6>
    80004b58:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b5a:	00004517          	auipc	a0,0x4
    80004b5e:	b1650513          	addi	a0,a0,-1258 # 80008670 <etext+0x670>
    80004b62:	00001097          	auipc	ra,0x1
    80004b66:	20a080e7          	jalr	522(ra) # 80005d6c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b6a:	04c92703          	lw	a4,76(s2)
    80004b6e:	02000793          	li	a5,32
    80004b72:	f6e7f5e3          	bgeu	a5,a4,80004adc <sys_unlink+0xa8>
    80004b76:	e5ce                	sd	s3,200(sp)
    80004b78:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7c:	4741                	li	a4,16
    80004b7e:	86ce                	mv	a3,s3
    80004b80:	f1840613          	addi	a2,s0,-232
    80004b84:	4581                	li	a1,0
    80004b86:	854a                	mv	a0,s2
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	330080e7          	jalr	816(ra) # 80002eb8 <readi>
    80004b90:	47c1                	li	a5,16
    80004b92:	00f51c63          	bne	a0,a5,80004baa <sys_unlink+0x176>
    if(de.inum != 0)
    80004b96:	f1845783          	lhu	a5,-232(s0)
    80004b9a:	e7b5                	bnez	a5,80004c06 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b9c:	29c1                	addiw	s3,s3,16
    80004b9e:	04c92783          	lw	a5,76(s2)
    80004ba2:	fcf9ede3          	bltu	s3,a5,80004b7c <sys_unlink+0x148>
    80004ba6:	69ae                	ld	s3,200(sp)
    80004ba8:	bf15                	j	80004adc <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004baa:	00004517          	auipc	a0,0x4
    80004bae:	ade50513          	addi	a0,a0,-1314 # 80008688 <etext+0x688>
    80004bb2:	00001097          	auipc	ra,0x1
    80004bb6:	1ba080e7          	jalr	442(ra) # 80005d6c <panic>
    80004bba:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004bbc:	00004517          	auipc	a0,0x4
    80004bc0:	ae450513          	addi	a0,a0,-1308 # 800086a0 <etext+0x6a0>
    80004bc4:	00001097          	auipc	ra,0x1
    80004bc8:	1a8080e7          	jalr	424(ra) # 80005d6c <panic>
    dp->nlink--;
    80004bcc:	04a4d783          	lhu	a5,74(s1)
    80004bd0:	37fd                	addiw	a5,a5,-1
    80004bd2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bd6:	8526                	mv	a0,s1
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	f5c080e7          	jalr	-164(ra) # 80002b34 <iupdate>
    80004be0:	bf0d                	j	80004b12 <sys_unlink+0xde>
    80004be2:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004be4:	8526                	mv	a0,s1
    80004be6:	ffffe097          	auipc	ra,0xffffe
    80004bea:	280080e7          	jalr	640(ra) # 80002e66 <iunlockput>
  end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	a5e080e7          	jalr	-1442(ra) # 8000364c <end_op>
  return -1;
    80004bf6:	557d                	li	a0,-1
    80004bf8:	64ee                	ld	s1,216(sp)
}
    80004bfa:	70ae                	ld	ra,232(sp)
    80004bfc:	740e                	ld	s0,224(sp)
    80004bfe:	616d                	addi	sp,sp,240
    80004c00:	8082                	ret
    return -1;
    80004c02:	557d                	li	a0,-1
    80004c04:	bfdd                	j	80004bfa <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c06:	854a                	mv	a0,s2
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	25e080e7          	jalr	606(ra) # 80002e66 <iunlockput>
    goto bad;
    80004c10:	694e                	ld	s2,208(sp)
    80004c12:	69ae                	ld	s3,200(sp)
    80004c14:	bfc1                	j	80004be4 <sys_unlink+0x1b0>

0000000080004c16 <sys_open>:

uint64
sys_open(void)
{
    80004c16:	7131                	addi	sp,sp,-192
    80004c18:	fd06                	sd	ra,184(sp)
    80004c1a:	f922                	sd	s0,176(sp)
    80004c1c:	f526                	sd	s1,168(sp)
    80004c1e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c20:	08000613          	li	a2,128
    80004c24:	f5040593          	addi	a1,s0,-176
    80004c28:	4501                	li	a0,0
    80004c2a:	ffffd097          	auipc	ra,0xffffd
    80004c2e:	3da080e7          	jalr	986(ra) # 80002004 <argstr>
    return -1;
    80004c32:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c34:	0c054463          	bltz	a0,80004cfc <sys_open+0xe6>
    80004c38:	f4c40593          	addi	a1,s0,-180
    80004c3c:	4505                	li	a0,1
    80004c3e:	ffffd097          	auipc	ra,0xffffd
    80004c42:	382080e7          	jalr	898(ra) # 80001fc0 <argint>
    80004c46:	0a054b63          	bltz	a0,80004cfc <sys_open+0xe6>
    80004c4a:	f14a                	sd	s2,160(sp)

  begin_op();
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	986080e7          	jalr	-1658(ra) # 800035d2 <begin_op>

  if(omode & O_CREATE){
    80004c54:	f4c42783          	lw	a5,-180(s0)
    80004c58:	2007f793          	andi	a5,a5,512
    80004c5c:	cfc5                	beqz	a5,80004d14 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c5e:	4681                	li	a3,0
    80004c60:	4601                	li	a2,0
    80004c62:	4589                	li	a1,2
    80004c64:	f5040513          	addi	a0,s0,-176
    80004c68:	00000097          	auipc	ra,0x0
    80004c6c:	958080e7          	jalr	-1704(ra) # 800045c0 <create>
    80004c70:	892a                	mv	s2,a0
    if(ip == 0){
    80004c72:	c959                	beqz	a0,80004d08 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c74:	04491703          	lh	a4,68(s2)
    80004c78:	478d                	li	a5,3
    80004c7a:	00f71763          	bne	a4,a5,80004c88 <sys_open+0x72>
    80004c7e:	04695703          	lhu	a4,70(s2)
    80004c82:	47a5                	li	a5,9
    80004c84:	0ce7ef63          	bltu	a5,a4,80004d62 <sys_open+0x14c>
    80004c88:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	d56080e7          	jalr	-682(ra) # 800039e0 <filealloc>
    80004c92:	89aa                	mv	s3,a0
    80004c94:	c965                	beqz	a0,80004d84 <sys_open+0x16e>
    80004c96:	00000097          	auipc	ra,0x0
    80004c9a:	8e8080e7          	jalr	-1816(ra) # 8000457e <fdalloc>
    80004c9e:	84aa                	mv	s1,a0
    80004ca0:	0c054d63          	bltz	a0,80004d7a <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ca4:	04491703          	lh	a4,68(s2)
    80004ca8:	478d                	li	a5,3
    80004caa:	0ef70a63          	beq	a4,a5,80004d9e <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cae:	4789                	li	a5,2
    80004cb0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cb4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cb8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cbc:	f4c42783          	lw	a5,-180(s0)
    80004cc0:	0017c713          	xori	a4,a5,1
    80004cc4:	8b05                	andi	a4,a4,1
    80004cc6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cca:	0037f713          	andi	a4,a5,3
    80004cce:	00e03733          	snez	a4,a4
    80004cd2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cd6:	4007f793          	andi	a5,a5,1024
    80004cda:	c791                	beqz	a5,80004ce6 <sys_open+0xd0>
    80004cdc:	04491703          	lh	a4,68(s2)
    80004ce0:	4789                	li	a5,2
    80004ce2:	0cf70563          	beq	a4,a5,80004dac <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004ce6:	854a                	mv	a0,s2
    80004ce8:	ffffe097          	auipc	ra,0xffffe
    80004cec:	fde080e7          	jalr	-34(ra) # 80002cc6 <iunlock>
  end_op();
    80004cf0:	fffff097          	auipc	ra,0xfffff
    80004cf4:	95c080e7          	jalr	-1700(ra) # 8000364c <end_op>
    80004cf8:	790a                	ld	s2,160(sp)
    80004cfa:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004cfc:	8526                	mv	a0,s1
    80004cfe:	70ea                	ld	ra,184(sp)
    80004d00:	744a                	ld	s0,176(sp)
    80004d02:	74aa                	ld	s1,168(sp)
    80004d04:	6129                	addi	sp,sp,192
    80004d06:	8082                	ret
      end_op();
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	944080e7          	jalr	-1724(ra) # 8000364c <end_op>
      return -1;
    80004d10:	790a                	ld	s2,160(sp)
    80004d12:	b7ed                	j	80004cfc <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004d14:	f5040513          	addi	a0,s0,-176
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	6ba080e7          	jalr	1722(ra) # 800033d2 <namei>
    80004d20:	892a                	mv	s2,a0
    80004d22:	c90d                	beqz	a0,80004d54 <sys_open+0x13e>
    ilock(ip);
    80004d24:	ffffe097          	auipc	ra,0xffffe
    80004d28:	edc080e7          	jalr	-292(ra) # 80002c00 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d2c:	04491703          	lh	a4,68(s2)
    80004d30:	4785                	li	a5,1
    80004d32:	f4f711e3          	bne	a4,a5,80004c74 <sys_open+0x5e>
    80004d36:	f4c42783          	lw	a5,-180(s0)
    80004d3a:	d7b9                	beqz	a5,80004c88 <sys_open+0x72>
      iunlockput(ip);
    80004d3c:	854a                	mv	a0,s2
    80004d3e:	ffffe097          	auipc	ra,0xffffe
    80004d42:	128080e7          	jalr	296(ra) # 80002e66 <iunlockput>
      end_op();
    80004d46:	fffff097          	auipc	ra,0xfffff
    80004d4a:	906080e7          	jalr	-1786(ra) # 8000364c <end_op>
      return -1;
    80004d4e:	54fd                	li	s1,-1
    80004d50:	790a                	ld	s2,160(sp)
    80004d52:	b76d                	j	80004cfc <sys_open+0xe6>
      end_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	8f8080e7          	jalr	-1800(ra) # 8000364c <end_op>
      return -1;
    80004d5c:	54fd                	li	s1,-1
    80004d5e:	790a                	ld	s2,160(sp)
    80004d60:	bf71                	j	80004cfc <sys_open+0xe6>
    iunlockput(ip);
    80004d62:	854a                	mv	a0,s2
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	102080e7          	jalr	258(ra) # 80002e66 <iunlockput>
    end_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	8e0080e7          	jalr	-1824(ra) # 8000364c <end_op>
    return -1;
    80004d74:	54fd                	li	s1,-1
    80004d76:	790a                	ld	s2,160(sp)
    80004d78:	b751                	j	80004cfc <sys_open+0xe6>
      fileclose(f);
    80004d7a:	854e                	mv	a0,s3
    80004d7c:	fffff097          	auipc	ra,0xfffff
    80004d80:	d20080e7          	jalr	-736(ra) # 80003a9c <fileclose>
    iunlockput(ip);
    80004d84:	854a                	mv	a0,s2
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	0e0080e7          	jalr	224(ra) # 80002e66 <iunlockput>
    end_op();
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	8be080e7          	jalr	-1858(ra) # 8000364c <end_op>
    return -1;
    80004d96:	54fd                	li	s1,-1
    80004d98:	790a                	ld	s2,160(sp)
    80004d9a:	69ea                	ld	s3,152(sp)
    80004d9c:	b785                	j	80004cfc <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004d9e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004da2:	04691783          	lh	a5,70(s2)
    80004da6:	02f99223          	sh	a5,36(s3)
    80004daa:	b739                	j	80004cb8 <sys_open+0xa2>
    itrunc(ip);
    80004dac:	854a                	mv	a0,s2
    80004dae:	ffffe097          	auipc	ra,0xffffe
    80004db2:	f64080e7          	jalr	-156(ra) # 80002d12 <itrunc>
    80004db6:	bf05                	j	80004ce6 <sys_open+0xd0>

0000000080004db8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004db8:	7175                	addi	sp,sp,-144
    80004dba:	e506                	sd	ra,136(sp)
    80004dbc:	e122                	sd	s0,128(sp)
    80004dbe:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dc0:	fffff097          	auipc	ra,0xfffff
    80004dc4:	812080e7          	jalr	-2030(ra) # 800035d2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dc8:	08000613          	li	a2,128
    80004dcc:	f7040593          	addi	a1,s0,-144
    80004dd0:	4501                	li	a0,0
    80004dd2:	ffffd097          	auipc	ra,0xffffd
    80004dd6:	232080e7          	jalr	562(ra) # 80002004 <argstr>
    80004dda:	02054963          	bltz	a0,80004e0c <sys_mkdir+0x54>
    80004dde:	4681                	li	a3,0
    80004de0:	4601                	li	a2,0
    80004de2:	4585                	li	a1,1
    80004de4:	f7040513          	addi	a0,s0,-144
    80004de8:	fffff097          	auipc	ra,0xfffff
    80004dec:	7d8080e7          	jalr	2008(ra) # 800045c0 <create>
    80004df0:	cd11                	beqz	a0,80004e0c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	074080e7          	jalr	116(ra) # 80002e66 <iunlockput>
  end_op();
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	852080e7          	jalr	-1966(ra) # 8000364c <end_op>
  return 0;
    80004e02:	4501                	li	a0,0
}
    80004e04:	60aa                	ld	ra,136(sp)
    80004e06:	640a                	ld	s0,128(sp)
    80004e08:	6149                	addi	sp,sp,144
    80004e0a:	8082                	ret
    end_op();
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	840080e7          	jalr	-1984(ra) # 8000364c <end_op>
    return -1;
    80004e14:	557d                	li	a0,-1
    80004e16:	b7fd                	j	80004e04 <sys_mkdir+0x4c>

0000000080004e18 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e18:	7135                	addi	sp,sp,-160
    80004e1a:	ed06                	sd	ra,152(sp)
    80004e1c:	e922                	sd	s0,144(sp)
    80004e1e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	7b2080e7          	jalr	1970(ra) # 800035d2 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e28:	08000613          	li	a2,128
    80004e2c:	f7040593          	addi	a1,s0,-144
    80004e30:	4501                	li	a0,0
    80004e32:	ffffd097          	auipc	ra,0xffffd
    80004e36:	1d2080e7          	jalr	466(ra) # 80002004 <argstr>
    80004e3a:	04054a63          	bltz	a0,80004e8e <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e3e:	f6c40593          	addi	a1,s0,-148
    80004e42:	4505                	li	a0,1
    80004e44:	ffffd097          	auipc	ra,0xffffd
    80004e48:	17c080e7          	jalr	380(ra) # 80001fc0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e4c:	04054163          	bltz	a0,80004e8e <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e50:	f6840593          	addi	a1,s0,-152
    80004e54:	4509                	li	a0,2
    80004e56:	ffffd097          	auipc	ra,0xffffd
    80004e5a:	16a080e7          	jalr	362(ra) # 80001fc0 <argint>
     argint(1, &major) < 0 ||
    80004e5e:	02054863          	bltz	a0,80004e8e <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e62:	f6841683          	lh	a3,-152(s0)
    80004e66:	f6c41603          	lh	a2,-148(s0)
    80004e6a:	458d                	li	a1,3
    80004e6c:	f7040513          	addi	a0,s0,-144
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	750080e7          	jalr	1872(ra) # 800045c0 <create>
     argint(2, &minor) < 0 ||
    80004e78:	c919                	beqz	a0,80004e8e <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e7a:	ffffe097          	auipc	ra,0xffffe
    80004e7e:	fec080e7          	jalr	-20(ra) # 80002e66 <iunlockput>
  end_op();
    80004e82:	ffffe097          	auipc	ra,0xffffe
    80004e86:	7ca080e7          	jalr	1994(ra) # 8000364c <end_op>
  return 0;
    80004e8a:	4501                	li	a0,0
    80004e8c:	a031                	j	80004e98 <sys_mknod+0x80>
    end_op();
    80004e8e:	ffffe097          	auipc	ra,0xffffe
    80004e92:	7be080e7          	jalr	1982(ra) # 8000364c <end_op>
    return -1;
    80004e96:	557d                	li	a0,-1
}
    80004e98:	60ea                	ld	ra,152(sp)
    80004e9a:	644a                	ld	s0,144(sp)
    80004e9c:	610d                	addi	sp,sp,160
    80004e9e:	8082                	ret

0000000080004ea0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ea0:	7135                	addi	sp,sp,-160
    80004ea2:	ed06                	sd	ra,152(sp)
    80004ea4:	e922                	sd	s0,144(sp)
    80004ea6:	e14a                	sd	s2,128(sp)
    80004ea8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004eaa:	ffffc097          	auipc	ra,0xffffc
    80004eae:	01c080e7          	jalr	28(ra) # 80000ec6 <myproc>
    80004eb2:	892a                	mv	s2,a0
  
  begin_op();
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	71e080e7          	jalr	1822(ra) # 800035d2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ebc:	08000613          	li	a2,128
    80004ec0:	f6040593          	addi	a1,s0,-160
    80004ec4:	4501                	li	a0,0
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	13e080e7          	jalr	318(ra) # 80002004 <argstr>
    80004ece:	04054d63          	bltz	a0,80004f28 <sys_chdir+0x88>
    80004ed2:	e526                	sd	s1,136(sp)
    80004ed4:	f6040513          	addi	a0,s0,-160
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	4fa080e7          	jalr	1274(ra) # 800033d2 <namei>
    80004ee0:	84aa                	mv	s1,a0
    80004ee2:	c131                	beqz	a0,80004f26 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ee4:	ffffe097          	auipc	ra,0xffffe
    80004ee8:	d1c080e7          	jalr	-740(ra) # 80002c00 <ilock>
  if(ip->type != T_DIR){
    80004eec:	04449703          	lh	a4,68(s1)
    80004ef0:	4785                	li	a5,1
    80004ef2:	04f71163          	bne	a4,a5,80004f34 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ef6:	8526                	mv	a0,s1
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	dce080e7          	jalr	-562(ra) # 80002cc6 <iunlock>
  iput(p->cwd);
    80004f00:	15093503          	ld	a0,336(s2)
    80004f04:	ffffe097          	auipc	ra,0xffffe
    80004f08:	eba080e7          	jalr	-326(ra) # 80002dbe <iput>
  end_op();
    80004f0c:	ffffe097          	auipc	ra,0xffffe
    80004f10:	740080e7          	jalr	1856(ra) # 8000364c <end_op>
  p->cwd = ip;
    80004f14:	14993823          	sd	s1,336(s2)
  return 0;
    80004f18:	4501                	li	a0,0
    80004f1a:	64aa                	ld	s1,136(sp)
}
    80004f1c:	60ea                	ld	ra,152(sp)
    80004f1e:	644a                	ld	s0,144(sp)
    80004f20:	690a                	ld	s2,128(sp)
    80004f22:	610d                	addi	sp,sp,160
    80004f24:	8082                	ret
    80004f26:	64aa                	ld	s1,136(sp)
    end_op();
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	724080e7          	jalr	1828(ra) # 8000364c <end_op>
    return -1;
    80004f30:	557d                	li	a0,-1
    80004f32:	b7ed                	j	80004f1c <sys_chdir+0x7c>
    iunlockput(ip);
    80004f34:	8526                	mv	a0,s1
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	f30080e7          	jalr	-208(ra) # 80002e66 <iunlockput>
    end_op();
    80004f3e:	ffffe097          	auipc	ra,0xffffe
    80004f42:	70e080e7          	jalr	1806(ra) # 8000364c <end_op>
    return -1;
    80004f46:	557d                	li	a0,-1
    80004f48:	64aa                	ld	s1,136(sp)
    80004f4a:	bfc9                	j	80004f1c <sys_chdir+0x7c>

0000000080004f4c <sys_exec>:

uint64
sys_exec(void)
{
    80004f4c:	7121                	addi	sp,sp,-448
    80004f4e:	ff06                	sd	ra,440(sp)
    80004f50:	fb22                	sd	s0,432(sp)
    80004f52:	f34a                	sd	s2,416(sp)
    80004f54:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f56:	08000613          	li	a2,128
    80004f5a:	f5040593          	addi	a1,s0,-176
    80004f5e:	4501                	li	a0,0
    80004f60:	ffffd097          	auipc	ra,0xffffd
    80004f64:	0a4080e7          	jalr	164(ra) # 80002004 <argstr>
    return -1;
    80004f68:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f6a:	0e054a63          	bltz	a0,8000505e <sys_exec+0x112>
    80004f6e:	e4840593          	addi	a1,s0,-440
    80004f72:	4505                	li	a0,1
    80004f74:	ffffd097          	auipc	ra,0xffffd
    80004f78:	06e080e7          	jalr	110(ra) # 80001fe2 <argaddr>
    80004f7c:	0e054163          	bltz	a0,8000505e <sys_exec+0x112>
    80004f80:	f726                	sd	s1,424(sp)
    80004f82:	ef4e                	sd	s3,408(sp)
    80004f84:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004f86:	10000613          	li	a2,256
    80004f8a:	4581                	li	a1,0
    80004f8c:	e5040513          	addi	a0,s0,-432
    80004f90:	ffffb097          	auipc	ra,0xffffb
    80004f94:	234080e7          	jalr	564(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f98:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f9c:	89a6                	mv	s3,s1
    80004f9e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fa0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fa4:	00391513          	slli	a0,s2,0x3
    80004fa8:	e4040593          	addi	a1,s0,-448
    80004fac:	e4843783          	ld	a5,-440(s0)
    80004fb0:	953e                	add	a0,a0,a5
    80004fb2:	ffffd097          	auipc	ra,0xffffd
    80004fb6:	f74080e7          	jalr	-140(ra) # 80001f26 <fetchaddr>
    80004fba:	02054a63          	bltz	a0,80004fee <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004fbe:	e4043783          	ld	a5,-448(s0)
    80004fc2:	c7b1                	beqz	a5,8000500e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fc4:	ffffb097          	auipc	ra,0xffffb
    80004fc8:	156080e7          	jalr	342(ra) # 8000011a <kalloc>
    80004fcc:	85aa                	mv	a1,a0
    80004fce:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fd2:	cd11                	beqz	a0,80004fee <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fd4:	6605                	lui	a2,0x1
    80004fd6:	e4043503          	ld	a0,-448(s0)
    80004fda:	ffffd097          	auipc	ra,0xffffd
    80004fde:	f9e080e7          	jalr	-98(ra) # 80001f78 <fetchstr>
    80004fe2:	00054663          	bltz	a0,80004fee <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004fe6:	0905                	addi	s2,s2,1
    80004fe8:	09a1                	addi	s3,s3,8
    80004fea:	fb491de3          	bne	s2,s4,80004fa4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fee:	f5040913          	addi	s2,s0,-176
    80004ff2:	6088                	ld	a0,0(s1)
    80004ff4:	c12d                	beqz	a0,80005056 <sys_exec+0x10a>
    kfree(argv[i]);
    80004ff6:	ffffb097          	auipc	ra,0xffffb
    80004ffa:	026080e7          	jalr	38(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ffe:	04a1                	addi	s1,s1,8
    80005000:	ff2499e3          	bne	s1,s2,80004ff2 <sys_exec+0xa6>
  return -1;
    80005004:	597d                	li	s2,-1
    80005006:	74ba                	ld	s1,424(sp)
    80005008:	69fa                	ld	s3,408(sp)
    8000500a:	6a5a                	ld	s4,400(sp)
    8000500c:	a889                	j	8000505e <sys_exec+0x112>
      argv[i] = 0;
    8000500e:	0009079b          	sext.w	a5,s2
    80005012:	078e                	slli	a5,a5,0x3
    80005014:	fd078793          	addi	a5,a5,-48
    80005018:	97a2                	add	a5,a5,s0
    8000501a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000501e:	e5040593          	addi	a1,s0,-432
    80005022:	f5040513          	addi	a0,s0,-176
    80005026:	fffff097          	auipc	ra,0xfffff
    8000502a:	126080e7          	jalr	294(ra) # 8000414c <exec>
    8000502e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005030:	f5040993          	addi	s3,s0,-176
    80005034:	6088                	ld	a0,0(s1)
    80005036:	cd01                	beqz	a0,8000504e <sys_exec+0x102>
    kfree(argv[i]);
    80005038:	ffffb097          	auipc	ra,0xffffb
    8000503c:	fe4080e7          	jalr	-28(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005040:	04a1                	addi	s1,s1,8
    80005042:	ff3499e3          	bne	s1,s3,80005034 <sys_exec+0xe8>
    80005046:	74ba                	ld	s1,424(sp)
    80005048:	69fa                	ld	s3,408(sp)
    8000504a:	6a5a                	ld	s4,400(sp)
    8000504c:	a809                	j	8000505e <sys_exec+0x112>
  return ret;
    8000504e:	74ba                	ld	s1,424(sp)
    80005050:	69fa                	ld	s3,408(sp)
    80005052:	6a5a                	ld	s4,400(sp)
    80005054:	a029                	j	8000505e <sys_exec+0x112>
  return -1;
    80005056:	597d                	li	s2,-1
    80005058:	74ba                	ld	s1,424(sp)
    8000505a:	69fa                	ld	s3,408(sp)
    8000505c:	6a5a                	ld	s4,400(sp)
}
    8000505e:	854a                	mv	a0,s2
    80005060:	70fa                	ld	ra,440(sp)
    80005062:	745a                	ld	s0,432(sp)
    80005064:	791a                	ld	s2,416(sp)
    80005066:	6139                	addi	sp,sp,448
    80005068:	8082                	ret

000000008000506a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000506a:	7139                	addi	sp,sp,-64
    8000506c:	fc06                	sd	ra,56(sp)
    8000506e:	f822                	sd	s0,48(sp)
    80005070:	f426                	sd	s1,40(sp)
    80005072:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005074:	ffffc097          	auipc	ra,0xffffc
    80005078:	e52080e7          	jalr	-430(ra) # 80000ec6 <myproc>
    8000507c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000507e:	fd840593          	addi	a1,s0,-40
    80005082:	4501                	li	a0,0
    80005084:	ffffd097          	auipc	ra,0xffffd
    80005088:	f5e080e7          	jalr	-162(ra) # 80001fe2 <argaddr>
    return -1;
    8000508c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000508e:	0e054063          	bltz	a0,8000516e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005092:	fc840593          	addi	a1,s0,-56
    80005096:	fd040513          	addi	a0,s0,-48
    8000509a:	fffff097          	auipc	ra,0xfffff
    8000509e:	d70080e7          	jalr	-656(ra) # 80003e0a <pipealloc>
    return -1;
    800050a2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050a4:	0c054563          	bltz	a0,8000516e <sys_pipe+0x104>
  fd0 = -1;
    800050a8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050ac:	fd043503          	ld	a0,-48(s0)
    800050b0:	fffff097          	auipc	ra,0xfffff
    800050b4:	4ce080e7          	jalr	1230(ra) # 8000457e <fdalloc>
    800050b8:	fca42223          	sw	a0,-60(s0)
    800050bc:	08054c63          	bltz	a0,80005154 <sys_pipe+0xea>
    800050c0:	fc843503          	ld	a0,-56(s0)
    800050c4:	fffff097          	auipc	ra,0xfffff
    800050c8:	4ba080e7          	jalr	1210(ra) # 8000457e <fdalloc>
    800050cc:	fca42023          	sw	a0,-64(s0)
    800050d0:	06054963          	bltz	a0,80005142 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050d4:	4691                	li	a3,4
    800050d6:	fc440613          	addi	a2,s0,-60
    800050da:	fd843583          	ld	a1,-40(s0)
    800050de:	68a8                	ld	a0,80(s1)
    800050e0:	ffffc097          	auipc	ra,0xffffc
    800050e4:	a82080e7          	jalr	-1406(ra) # 80000b62 <copyout>
    800050e8:	02054063          	bltz	a0,80005108 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050ec:	4691                	li	a3,4
    800050ee:	fc040613          	addi	a2,s0,-64
    800050f2:	fd843583          	ld	a1,-40(s0)
    800050f6:	0591                	addi	a1,a1,4
    800050f8:	68a8                	ld	a0,80(s1)
    800050fa:	ffffc097          	auipc	ra,0xffffc
    800050fe:	a68080e7          	jalr	-1432(ra) # 80000b62 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005102:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005104:	06055563          	bgez	a0,8000516e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005108:	fc442783          	lw	a5,-60(s0)
    8000510c:	07e9                	addi	a5,a5,26
    8000510e:	078e                	slli	a5,a5,0x3
    80005110:	97a6                	add	a5,a5,s1
    80005112:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005116:	fc042783          	lw	a5,-64(s0)
    8000511a:	07e9                	addi	a5,a5,26
    8000511c:	078e                	slli	a5,a5,0x3
    8000511e:	00f48533          	add	a0,s1,a5
    80005122:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005126:	fd043503          	ld	a0,-48(s0)
    8000512a:	fffff097          	auipc	ra,0xfffff
    8000512e:	972080e7          	jalr	-1678(ra) # 80003a9c <fileclose>
    fileclose(wf);
    80005132:	fc843503          	ld	a0,-56(s0)
    80005136:	fffff097          	auipc	ra,0xfffff
    8000513a:	966080e7          	jalr	-1690(ra) # 80003a9c <fileclose>
    return -1;
    8000513e:	57fd                	li	a5,-1
    80005140:	a03d                	j	8000516e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005142:	fc442783          	lw	a5,-60(s0)
    80005146:	0007c763          	bltz	a5,80005154 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000514a:	07e9                	addi	a5,a5,26
    8000514c:	078e                	slli	a5,a5,0x3
    8000514e:	97a6                	add	a5,a5,s1
    80005150:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005154:	fd043503          	ld	a0,-48(s0)
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	944080e7          	jalr	-1724(ra) # 80003a9c <fileclose>
    fileclose(wf);
    80005160:	fc843503          	ld	a0,-56(s0)
    80005164:	fffff097          	auipc	ra,0xfffff
    80005168:	938080e7          	jalr	-1736(ra) # 80003a9c <fileclose>
    return -1;
    8000516c:	57fd                	li	a5,-1
}
    8000516e:	853e                	mv	a0,a5
    80005170:	70e2                	ld	ra,56(sp)
    80005172:	7442                	ld	s0,48(sp)
    80005174:	74a2                	ld	s1,40(sp)
    80005176:	6121                	addi	sp,sp,64
    80005178:	8082                	ret
    8000517a:	0000                	unimp
    8000517c:	0000                	unimp
	...

0000000080005180 <kernelvec>:
    80005180:	7111                	addi	sp,sp,-256
    80005182:	e006                	sd	ra,0(sp)
    80005184:	e40a                	sd	sp,8(sp)
    80005186:	e80e                	sd	gp,16(sp)
    80005188:	ec12                	sd	tp,24(sp)
    8000518a:	f016                	sd	t0,32(sp)
    8000518c:	f41a                	sd	t1,40(sp)
    8000518e:	f81e                	sd	t2,48(sp)
    80005190:	fc22                	sd	s0,56(sp)
    80005192:	e0a6                	sd	s1,64(sp)
    80005194:	e4aa                	sd	a0,72(sp)
    80005196:	e8ae                	sd	a1,80(sp)
    80005198:	ecb2                	sd	a2,88(sp)
    8000519a:	f0b6                	sd	a3,96(sp)
    8000519c:	f4ba                	sd	a4,104(sp)
    8000519e:	f8be                	sd	a5,112(sp)
    800051a0:	fcc2                	sd	a6,120(sp)
    800051a2:	e146                	sd	a7,128(sp)
    800051a4:	e54a                	sd	s2,136(sp)
    800051a6:	e94e                	sd	s3,144(sp)
    800051a8:	ed52                	sd	s4,152(sp)
    800051aa:	f156                	sd	s5,160(sp)
    800051ac:	f55a                	sd	s6,168(sp)
    800051ae:	f95e                	sd	s7,176(sp)
    800051b0:	fd62                	sd	s8,184(sp)
    800051b2:	e1e6                	sd	s9,192(sp)
    800051b4:	e5ea                	sd	s10,200(sp)
    800051b6:	e9ee                	sd	s11,208(sp)
    800051b8:	edf2                	sd	t3,216(sp)
    800051ba:	f1f6                	sd	t4,224(sp)
    800051bc:	f5fa                	sd	t5,232(sp)
    800051be:	f9fe                	sd	t6,240(sp)
    800051c0:	c33fc0ef          	jal	80001df2 <kerneltrap>
    800051c4:	6082                	ld	ra,0(sp)
    800051c6:	6122                	ld	sp,8(sp)
    800051c8:	61c2                	ld	gp,16(sp)
    800051ca:	7282                	ld	t0,32(sp)
    800051cc:	7322                	ld	t1,40(sp)
    800051ce:	73c2                	ld	t2,48(sp)
    800051d0:	7462                	ld	s0,56(sp)
    800051d2:	6486                	ld	s1,64(sp)
    800051d4:	6526                	ld	a0,72(sp)
    800051d6:	65c6                	ld	a1,80(sp)
    800051d8:	6666                	ld	a2,88(sp)
    800051da:	7686                	ld	a3,96(sp)
    800051dc:	7726                	ld	a4,104(sp)
    800051de:	77c6                	ld	a5,112(sp)
    800051e0:	7866                	ld	a6,120(sp)
    800051e2:	688a                	ld	a7,128(sp)
    800051e4:	692a                	ld	s2,136(sp)
    800051e6:	69ca                	ld	s3,144(sp)
    800051e8:	6a6a                	ld	s4,152(sp)
    800051ea:	7a8a                	ld	s5,160(sp)
    800051ec:	7b2a                	ld	s6,168(sp)
    800051ee:	7bca                	ld	s7,176(sp)
    800051f0:	7c6a                	ld	s8,184(sp)
    800051f2:	6c8e                	ld	s9,192(sp)
    800051f4:	6d2e                	ld	s10,200(sp)
    800051f6:	6dce                	ld	s11,208(sp)
    800051f8:	6e6e                	ld	t3,216(sp)
    800051fa:	7e8e                	ld	t4,224(sp)
    800051fc:	7f2e                	ld	t5,232(sp)
    800051fe:	7fce                	ld	t6,240(sp)
    80005200:	6111                	addi	sp,sp,256
    80005202:	10200073          	sret
    80005206:	00000013          	nop
    8000520a:	00000013          	nop
    8000520e:	0001                	nop

0000000080005210 <timervec>:
    80005210:	34051573          	csrrw	a0,mscratch,a0
    80005214:	e10c                	sd	a1,0(a0)
    80005216:	e510                	sd	a2,8(a0)
    80005218:	e914                	sd	a3,16(a0)
    8000521a:	6d0c                	ld	a1,24(a0)
    8000521c:	7110                	ld	a2,32(a0)
    8000521e:	6194                	ld	a3,0(a1)
    80005220:	96b2                	add	a3,a3,a2
    80005222:	e194                	sd	a3,0(a1)
    80005224:	4589                	li	a1,2
    80005226:	14459073          	csrw	sip,a1
    8000522a:	6914                	ld	a3,16(a0)
    8000522c:	6510                	ld	a2,8(a0)
    8000522e:	610c                	ld	a1,0(a0)
    80005230:	34051573          	csrrw	a0,mscratch,a0
    80005234:	30200073          	mret
	...

000000008000523a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000523a:	1141                	addi	sp,sp,-16
    8000523c:	e422                	sd	s0,8(sp)
    8000523e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005240:	0c0007b7          	lui	a5,0xc000
    80005244:	4705                	li	a4,1
    80005246:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005248:	0c0007b7          	lui	a5,0xc000
    8000524c:	c3d8                	sw	a4,4(a5)
}
    8000524e:	6422                	ld	s0,8(sp)
    80005250:	0141                	addi	sp,sp,16
    80005252:	8082                	ret

0000000080005254 <plicinithart>:

void
plicinithart(void)
{
    80005254:	1141                	addi	sp,sp,-16
    80005256:	e406                	sd	ra,8(sp)
    80005258:	e022                	sd	s0,0(sp)
    8000525a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000525c:	ffffc097          	auipc	ra,0xffffc
    80005260:	c3e080e7          	jalr	-962(ra) # 80000e9a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005264:	0085171b          	slliw	a4,a0,0x8
    80005268:	0c0027b7          	lui	a5,0xc002
    8000526c:	97ba                	add	a5,a5,a4
    8000526e:	40200713          	li	a4,1026
    80005272:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005276:	00d5151b          	slliw	a0,a0,0xd
    8000527a:	0c2017b7          	lui	a5,0xc201
    8000527e:	97aa                	add	a5,a5,a0
    80005280:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005284:	60a2                	ld	ra,8(sp)
    80005286:	6402                	ld	s0,0(sp)
    80005288:	0141                	addi	sp,sp,16
    8000528a:	8082                	ret

000000008000528c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000528c:	1141                	addi	sp,sp,-16
    8000528e:	e406                	sd	ra,8(sp)
    80005290:	e022                	sd	s0,0(sp)
    80005292:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005294:	ffffc097          	auipc	ra,0xffffc
    80005298:	c06080e7          	jalr	-1018(ra) # 80000e9a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000529c:	00d5151b          	slliw	a0,a0,0xd
    800052a0:	0c2017b7          	lui	a5,0xc201
    800052a4:	97aa                	add	a5,a5,a0
  return irq;
}
    800052a6:	43c8                	lw	a0,4(a5)
    800052a8:	60a2                	ld	ra,8(sp)
    800052aa:	6402                	ld	s0,0(sp)
    800052ac:	0141                	addi	sp,sp,16
    800052ae:	8082                	ret

00000000800052b0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052b0:	1101                	addi	sp,sp,-32
    800052b2:	ec06                	sd	ra,24(sp)
    800052b4:	e822                	sd	s0,16(sp)
    800052b6:	e426                	sd	s1,8(sp)
    800052b8:	1000                	addi	s0,sp,32
    800052ba:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052bc:	ffffc097          	auipc	ra,0xffffc
    800052c0:	bde080e7          	jalr	-1058(ra) # 80000e9a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052c4:	00d5151b          	slliw	a0,a0,0xd
    800052c8:	0c2017b7          	lui	a5,0xc201
    800052cc:	97aa                	add	a5,a5,a0
    800052ce:	c3c4                	sw	s1,4(a5)
}
    800052d0:	60e2                	ld	ra,24(sp)
    800052d2:	6442                	ld	s0,16(sp)
    800052d4:	64a2                	ld	s1,8(sp)
    800052d6:	6105                	addi	sp,sp,32
    800052d8:	8082                	ret

00000000800052da <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052da:	1141                	addi	sp,sp,-16
    800052dc:	e406                	sd	ra,8(sp)
    800052de:	e022                	sd	s0,0(sp)
    800052e0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052e2:	479d                	li	a5,7
    800052e4:	06a7c863          	blt	a5,a0,80005354 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800052e8:	00016717          	auipc	a4,0x16
    800052ec:	d1870713          	addi	a4,a4,-744 # 8001b000 <disk>
    800052f0:	972a                	add	a4,a4,a0
    800052f2:	6789                	lui	a5,0x2
    800052f4:	97ba                	add	a5,a5,a4
    800052f6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052fa:	e7ad                	bnez	a5,80005364 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052fc:	00451793          	slli	a5,a0,0x4
    80005300:	00018717          	auipc	a4,0x18
    80005304:	d0070713          	addi	a4,a4,-768 # 8001d000 <disk+0x2000>
    80005308:	6314                	ld	a3,0(a4)
    8000530a:	96be                	add	a3,a3,a5
    8000530c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005310:	6314                	ld	a3,0(a4)
    80005312:	96be                	add	a3,a3,a5
    80005314:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005318:	6314                	ld	a3,0(a4)
    8000531a:	96be                	add	a3,a3,a5
    8000531c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005320:	6318                	ld	a4,0(a4)
    80005322:	97ba                	add	a5,a5,a4
    80005324:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005328:	00016717          	auipc	a4,0x16
    8000532c:	cd870713          	addi	a4,a4,-808 # 8001b000 <disk>
    80005330:	972a                	add	a4,a4,a0
    80005332:	6789                	lui	a5,0x2
    80005334:	97ba                	add	a5,a5,a4
    80005336:	4705                	li	a4,1
    80005338:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000533c:	00018517          	auipc	a0,0x18
    80005340:	cdc50513          	addi	a0,a0,-804 # 8001d018 <disk+0x2018>
    80005344:	ffffc097          	auipc	ra,0xffffc
    80005348:	3e0080e7          	jalr	992(ra) # 80001724 <wakeup>
}
    8000534c:	60a2                	ld	ra,8(sp)
    8000534e:	6402                	ld	s0,0(sp)
    80005350:	0141                	addi	sp,sp,16
    80005352:	8082                	ret
    panic("free_desc 1");
    80005354:	00003517          	auipc	a0,0x3
    80005358:	35c50513          	addi	a0,a0,860 # 800086b0 <etext+0x6b0>
    8000535c:	00001097          	auipc	ra,0x1
    80005360:	a10080e7          	jalr	-1520(ra) # 80005d6c <panic>
    panic("free_desc 2");
    80005364:	00003517          	auipc	a0,0x3
    80005368:	35c50513          	addi	a0,a0,860 # 800086c0 <etext+0x6c0>
    8000536c:	00001097          	auipc	ra,0x1
    80005370:	a00080e7          	jalr	-1536(ra) # 80005d6c <panic>

0000000080005374 <virtio_disk_init>:
{
    80005374:	1141                	addi	sp,sp,-16
    80005376:	e406                	sd	ra,8(sp)
    80005378:	e022                	sd	s0,0(sp)
    8000537a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000537c:	00003597          	auipc	a1,0x3
    80005380:	35458593          	addi	a1,a1,852 # 800086d0 <etext+0x6d0>
    80005384:	00018517          	auipc	a0,0x18
    80005388:	da450513          	addi	a0,a0,-604 # 8001d128 <disk+0x2128>
    8000538c:	00001097          	auipc	ra,0x1
    80005390:	eca080e7          	jalr	-310(ra) # 80006256 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005394:	100017b7          	lui	a5,0x10001
    80005398:	4398                	lw	a4,0(a5)
    8000539a:	2701                	sext.w	a4,a4
    8000539c:	747277b7          	lui	a5,0x74727
    800053a0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053a4:	0ef71f63          	bne	a4,a5,800054a2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053a8:	100017b7          	lui	a5,0x10001
    800053ac:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800053ae:	439c                	lw	a5,0(a5)
    800053b0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053b2:	4705                	li	a4,1
    800053b4:	0ee79763          	bne	a5,a4,800054a2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053b8:	100017b7          	lui	a5,0x10001
    800053bc:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053be:	439c                	lw	a5,0(a5)
    800053c0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053c2:	4709                	li	a4,2
    800053c4:	0ce79f63          	bne	a5,a4,800054a2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053c8:	100017b7          	lui	a5,0x10001
    800053cc:	47d8                	lw	a4,12(a5)
    800053ce:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053d0:	554d47b7          	lui	a5,0x554d4
    800053d4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053d8:	0cf71563          	bne	a4,a5,800054a2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053dc:	100017b7          	lui	a5,0x10001
    800053e0:	4705                	li	a4,1
    800053e2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e4:	470d                	li	a4,3
    800053e6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053e8:	10001737          	lui	a4,0x10001
    800053ec:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053ee:	c7ffe737          	lui	a4,0xc7ffe
    800053f2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053f6:	8ef9                	and	a3,a3,a4
    800053f8:	10001737          	lui	a4,0x10001
    800053fc:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053fe:	472d                	li	a4,11
    80005400:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005402:	473d                	li	a4,15
    80005404:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	6705                	lui	a4,0x1
    8000540c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000540e:	100017b7          	lui	a5,0x10001
    80005412:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005416:	100017b7          	lui	a5,0x10001
    8000541a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000541e:	439c                	lw	a5,0(a5)
    80005420:	2781                	sext.w	a5,a5
  if(max == 0)
    80005422:	cbc1                	beqz	a5,800054b2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005424:	471d                	li	a4,7
    80005426:	08f77e63          	bgeu	a4,a5,800054c2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000542a:	100017b7          	lui	a5,0x10001
    8000542e:	4721                	li	a4,8
    80005430:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005432:	6609                	lui	a2,0x2
    80005434:	4581                	li	a1,0
    80005436:	00016517          	auipc	a0,0x16
    8000543a:	bca50513          	addi	a0,a0,-1078 # 8001b000 <disk>
    8000543e:	ffffb097          	auipc	ra,0xffffb
    80005442:	d86080e7          	jalr	-634(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005446:	00016697          	auipc	a3,0x16
    8000544a:	bba68693          	addi	a3,a3,-1094 # 8001b000 <disk>
    8000544e:	00c6d713          	srli	a4,a3,0xc
    80005452:	2701                	sext.w	a4,a4
    80005454:	100017b7          	lui	a5,0x10001
    80005458:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000545a:	00018797          	auipc	a5,0x18
    8000545e:	ba678793          	addi	a5,a5,-1114 # 8001d000 <disk+0x2000>
    80005462:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005464:	00016717          	auipc	a4,0x16
    80005468:	c1c70713          	addi	a4,a4,-996 # 8001b080 <disk+0x80>
    8000546c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000546e:	00017717          	auipc	a4,0x17
    80005472:	b9270713          	addi	a4,a4,-1134 # 8001c000 <disk+0x1000>
    80005476:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005478:	4705                	li	a4,1
    8000547a:	00e78c23          	sb	a4,24(a5)
    8000547e:	00e78ca3          	sb	a4,25(a5)
    80005482:	00e78d23          	sb	a4,26(a5)
    80005486:	00e78da3          	sb	a4,27(a5)
    8000548a:	00e78e23          	sb	a4,28(a5)
    8000548e:	00e78ea3          	sb	a4,29(a5)
    80005492:	00e78f23          	sb	a4,30(a5)
    80005496:	00e78fa3          	sb	a4,31(a5)
}
    8000549a:	60a2                	ld	ra,8(sp)
    8000549c:	6402                	ld	s0,0(sp)
    8000549e:	0141                	addi	sp,sp,16
    800054a0:	8082                	ret
    panic("could not find virtio disk");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	23e50513          	addi	a0,a0,574 # 800086e0 <etext+0x6e0>
    800054aa:	00001097          	auipc	ra,0x1
    800054ae:	8c2080e7          	jalr	-1854(ra) # 80005d6c <panic>
    panic("virtio disk has no queue 0");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	24e50513          	addi	a0,a0,590 # 80008700 <etext+0x700>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	8b2080e7          	jalr	-1870(ra) # 80005d6c <panic>
    panic("virtio disk max queue too short");
    800054c2:	00003517          	auipc	a0,0x3
    800054c6:	25e50513          	addi	a0,a0,606 # 80008720 <etext+0x720>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	8a2080e7          	jalr	-1886(ra) # 80005d6c <panic>

00000000800054d2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054d2:	7159                	addi	sp,sp,-112
    800054d4:	f486                	sd	ra,104(sp)
    800054d6:	f0a2                	sd	s0,96(sp)
    800054d8:	eca6                	sd	s1,88(sp)
    800054da:	e8ca                	sd	s2,80(sp)
    800054dc:	e4ce                	sd	s3,72(sp)
    800054de:	e0d2                	sd	s4,64(sp)
    800054e0:	fc56                	sd	s5,56(sp)
    800054e2:	f85a                	sd	s6,48(sp)
    800054e4:	f45e                	sd	s7,40(sp)
    800054e6:	f062                	sd	s8,32(sp)
    800054e8:	ec66                	sd	s9,24(sp)
    800054ea:	1880                	addi	s0,sp,112
    800054ec:	8a2a                	mv	s4,a0
    800054ee:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054f0:	00c52c03          	lw	s8,12(a0)
    800054f4:	001c1c1b          	slliw	s8,s8,0x1
    800054f8:	1c02                	slli	s8,s8,0x20
    800054fa:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800054fe:	00018517          	auipc	a0,0x18
    80005502:	c2a50513          	addi	a0,a0,-982 # 8001d128 <disk+0x2128>
    80005506:	00001097          	auipc	ra,0x1
    8000550a:	de0080e7          	jalr	-544(ra) # 800062e6 <acquire>
  for(int i = 0; i < 3; i++){
    8000550e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005510:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005512:	00016b97          	auipc	s7,0x16
    80005516:	aeeb8b93          	addi	s7,s7,-1298 # 8001b000 <disk>
    8000551a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000551c:	4a8d                	li	s5,3
    8000551e:	a88d                	j	80005590 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005520:	00fb8733          	add	a4,s7,a5
    80005524:	975a                	add	a4,a4,s6
    80005526:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000552a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000552c:	0207c563          	bltz	a5,80005556 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005530:	2905                	addiw	s2,s2,1
    80005532:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005534:	1b590163          	beq	s2,s5,800056d6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005538:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000553a:	00018717          	auipc	a4,0x18
    8000553e:	ade70713          	addi	a4,a4,-1314 # 8001d018 <disk+0x2018>
    80005542:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005544:	00074683          	lbu	a3,0(a4)
    80005548:	fee1                	bnez	a3,80005520 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000554a:	2785                	addiw	a5,a5,1
    8000554c:	0705                	addi	a4,a4,1
    8000554e:	fe979be3          	bne	a5,s1,80005544 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005552:	57fd                	li	a5,-1
    80005554:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005556:	03205163          	blez	s2,80005578 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000555a:	f9042503          	lw	a0,-112(s0)
    8000555e:	00000097          	auipc	ra,0x0
    80005562:	d7c080e7          	jalr	-644(ra) # 800052da <free_desc>
      for(int j = 0; j < i; j++)
    80005566:	4785                	li	a5,1
    80005568:	0127d863          	bge	a5,s2,80005578 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000556c:	f9442503          	lw	a0,-108(s0)
    80005570:	00000097          	auipc	ra,0x0
    80005574:	d6a080e7          	jalr	-662(ra) # 800052da <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005578:	00018597          	auipc	a1,0x18
    8000557c:	bb058593          	addi	a1,a1,-1104 # 8001d128 <disk+0x2128>
    80005580:	00018517          	auipc	a0,0x18
    80005584:	a9850513          	addi	a0,a0,-1384 # 8001d018 <disk+0x2018>
    80005588:	ffffc097          	auipc	ra,0xffffc
    8000558c:	010080e7          	jalr	16(ra) # 80001598 <sleep>
  for(int i = 0; i < 3; i++){
    80005590:	f9040613          	addi	a2,s0,-112
    80005594:	894e                	mv	s2,s3
    80005596:	b74d                	j	80005538 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005598:	00018717          	auipc	a4,0x18
    8000559c:	a6873703          	ld	a4,-1432(a4) # 8001d000 <disk+0x2000>
    800055a0:	973e                	add	a4,a4,a5
    800055a2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055a6:	00016897          	auipc	a7,0x16
    800055aa:	a5a88893          	addi	a7,a7,-1446 # 8001b000 <disk>
    800055ae:	00018717          	auipc	a4,0x18
    800055b2:	a5270713          	addi	a4,a4,-1454 # 8001d000 <disk+0x2000>
    800055b6:	6314                	ld	a3,0(a4)
    800055b8:	96be                	add	a3,a3,a5
    800055ba:	00c6d583          	lhu	a1,12(a3)
    800055be:	0015e593          	ori	a1,a1,1
    800055c2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055c6:	f9842683          	lw	a3,-104(s0)
    800055ca:	630c                	ld	a1,0(a4)
    800055cc:	97ae                	add	a5,a5,a1
    800055ce:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055d2:	20050593          	addi	a1,a0,512
    800055d6:	0592                	slli	a1,a1,0x4
    800055d8:	95c6                	add	a1,a1,a7
    800055da:	57fd                	li	a5,-1
    800055dc:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055e0:	00469793          	slli	a5,a3,0x4
    800055e4:	00073803          	ld	a6,0(a4)
    800055e8:	983e                	add	a6,a6,a5
    800055ea:	6689                	lui	a3,0x2
    800055ec:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800055f0:	96b2                	add	a3,a3,a2
    800055f2:	96c6                	add	a3,a3,a7
    800055f4:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800055f8:	6314                	ld	a3,0(a4)
    800055fa:	96be                	add	a3,a3,a5
    800055fc:	4605                	li	a2,1
    800055fe:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005600:	6314                	ld	a3,0(a4)
    80005602:	96be                	add	a3,a3,a5
    80005604:	4809                	li	a6,2
    80005606:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000560a:	6314                	ld	a3,0(a4)
    8000560c:	97b6                	add	a5,a5,a3
    8000560e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005612:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005616:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000561a:	6714                	ld	a3,8(a4)
    8000561c:	0026d783          	lhu	a5,2(a3)
    80005620:	8b9d                	andi	a5,a5,7
    80005622:	0786                	slli	a5,a5,0x1
    80005624:	96be                	add	a3,a3,a5
    80005626:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000562a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000562e:	6718                	ld	a4,8(a4)
    80005630:	00275783          	lhu	a5,2(a4)
    80005634:	2785                	addiw	a5,a5,1
    80005636:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000563a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000563e:	100017b7          	lui	a5,0x10001
    80005642:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005646:	004a2783          	lw	a5,4(s4)
    8000564a:	02c79163          	bne	a5,a2,8000566c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000564e:	00018917          	auipc	s2,0x18
    80005652:	ada90913          	addi	s2,s2,-1318 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005656:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005658:	85ca                	mv	a1,s2
    8000565a:	8552                	mv	a0,s4
    8000565c:	ffffc097          	auipc	ra,0xffffc
    80005660:	f3c080e7          	jalr	-196(ra) # 80001598 <sleep>
  while(b->disk == 1) {
    80005664:	004a2783          	lw	a5,4(s4)
    80005668:	fe9788e3          	beq	a5,s1,80005658 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000566c:	f9042903          	lw	s2,-112(s0)
    80005670:	20090713          	addi	a4,s2,512
    80005674:	0712                	slli	a4,a4,0x4
    80005676:	00016797          	auipc	a5,0x16
    8000567a:	98a78793          	addi	a5,a5,-1654 # 8001b000 <disk>
    8000567e:	97ba                	add	a5,a5,a4
    80005680:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005684:	00018997          	auipc	s3,0x18
    80005688:	97c98993          	addi	s3,s3,-1668 # 8001d000 <disk+0x2000>
    8000568c:	00491713          	slli	a4,s2,0x4
    80005690:	0009b783          	ld	a5,0(s3)
    80005694:	97ba                	add	a5,a5,a4
    80005696:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000569a:	854a                	mv	a0,s2
    8000569c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056a0:	00000097          	auipc	ra,0x0
    800056a4:	c3a080e7          	jalr	-966(ra) # 800052da <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056a8:	8885                	andi	s1,s1,1
    800056aa:	f0ed                	bnez	s1,8000568c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056ac:	00018517          	auipc	a0,0x18
    800056b0:	a7c50513          	addi	a0,a0,-1412 # 8001d128 <disk+0x2128>
    800056b4:	00001097          	auipc	ra,0x1
    800056b8:	ce6080e7          	jalr	-794(ra) # 8000639a <release>
}
    800056bc:	70a6                	ld	ra,104(sp)
    800056be:	7406                	ld	s0,96(sp)
    800056c0:	64e6                	ld	s1,88(sp)
    800056c2:	6946                	ld	s2,80(sp)
    800056c4:	69a6                	ld	s3,72(sp)
    800056c6:	6a06                	ld	s4,64(sp)
    800056c8:	7ae2                	ld	s5,56(sp)
    800056ca:	7b42                	ld	s6,48(sp)
    800056cc:	7ba2                	ld	s7,40(sp)
    800056ce:	7c02                	ld	s8,32(sp)
    800056d0:	6ce2                	ld	s9,24(sp)
    800056d2:	6165                	addi	sp,sp,112
    800056d4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056d6:	f9042503          	lw	a0,-112(s0)
    800056da:	00451613          	slli	a2,a0,0x4
  if(write)
    800056de:	00016597          	auipc	a1,0x16
    800056e2:	92258593          	addi	a1,a1,-1758 # 8001b000 <disk>
    800056e6:	20050793          	addi	a5,a0,512
    800056ea:	0792                	slli	a5,a5,0x4
    800056ec:	97ae                	add	a5,a5,a1
    800056ee:	01903733          	snez	a4,s9
    800056f2:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800056f6:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800056fa:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056fe:	00018717          	auipc	a4,0x18
    80005702:	90270713          	addi	a4,a4,-1790 # 8001d000 <disk+0x2000>
    80005706:	6314                	ld	a3,0(a4)
    80005708:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000570a:	6789                	lui	a5,0x2
    8000570c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005710:	97b2                	add	a5,a5,a2
    80005712:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005714:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005716:	631c                	ld	a5,0(a4)
    80005718:	97b2                	add	a5,a5,a2
    8000571a:	46c1                	li	a3,16
    8000571c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000571e:	631c                	ld	a5,0(a4)
    80005720:	97b2                	add	a5,a5,a2
    80005722:	4685                	li	a3,1
    80005724:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005728:	f9442783          	lw	a5,-108(s0)
    8000572c:	6314                	ld	a3,0(a4)
    8000572e:	96b2                	add	a3,a3,a2
    80005730:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005734:	0792                	slli	a5,a5,0x4
    80005736:	6314                	ld	a3,0(a4)
    80005738:	96be                	add	a3,a3,a5
    8000573a:	058a0593          	addi	a1,s4,88
    8000573e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005740:	6318                	ld	a4,0(a4)
    80005742:	973e                	add	a4,a4,a5
    80005744:	40000693          	li	a3,1024
    80005748:	c714                	sw	a3,8(a4)
  if(write)
    8000574a:	e40c97e3          	bnez	s9,80005598 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000574e:	00018717          	auipc	a4,0x18
    80005752:	8b273703          	ld	a4,-1870(a4) # 8001d000 <disk+0x2000>
    80005756:	973e                	add	a4,a4,a5
    80005758:	4689                	li	a3,2
    8000575a:	00d71623          	sh	a3,12(a4)
    8000575e:	b5a1                	j	800055a6 <virtio_disk_rw+0xd4>

0000000080005760 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005760:	1101                	addi	sp,sp,-32
    80005762:	ec06                	sd	ra,24(sp)
    80005764:	e822                	sd	s0,16(sp)
    80005766:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005768:	00018517          	auipc	a0,0x18
    8000576c:	9c050513          	addi	a0,a0,-1600 # 8001d128 <disk+0x2128>
    80005770:	00001097          	auipc	ra,0x1
    80005774:	b76080e7          	jalr	-1162(ra) # 800062e6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005778:	100017b7          	lui	a5,0x10001
    8000577c:	53b8                	lw	a4,96(a5)
    8000577e:	8b0d                	andi	a4,a4,3
    80005780:	100017b7          	lui	a5,0x10001
    80005784:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005786:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000578a:	00018797          	auipc	a5,0x18
    8000578e:	87678793          	addi	a5,a5,-1930 # 8001d000 <disk+0x2000>
    80005792:	6b94                	ld	a3,16(a5)
    80005794:	0207d703          	lhu	a4,32(a5)
    80005798:	0026d783          	lhu	a5,2(a3)
    8000579c:	06f70563          	beq	a4,a5,80005806 <virtio_disk_intr+0xa6>
    800057a0:	e426                	sd	s1,8(sp)
    800057a2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057a4:	00016917          	auipc	s2,0x16
    800057a8:	85c90913          	addi	s2,s2,-1956 # 8001b000 <disk>
    800057ac:	00018497          	auipc	s1,0x18
    800057b0:	85448493          	addi	s1,s1,-1964 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057b4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057b8:	6898                	ld	a4,16(s1)
    800057ba:	0204d783          	lhu	a5,32(s1)
    800057be:	8b9d                	andi	a5,a5,7
    800057c0:	078e                	slli	a5,a5,0x3
    800057c2:	97ba                	add	a5,a5,a4
    800057c4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057c6:	20078713          	addi	a4,a5,512
    800057ca:	0712                	slli	a4,a4,0x4
    800057cc:	974a                	add	a4,a4,s2
    800057ce:	03074703          	lbu	a4,48(a4)
    800057d2:	e731                	bnez	a4,8000581e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057d4:	20078793          	addi	a5,a5,512
    800057d8:	0792                	slli	a5,a5,0x4
    800057da:	97ca                	add	a5,a5,s2
    800057dc:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057de:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057e2:	ffffc097          	auipc	ra,0xffffc
    800057e6:	f42080e7          	jalr	-190(ra) # 80001724 <wakeup>

    disk.used_idx += 1;
    800057ea:	0204d783          	lhu	a5,32(s1)
    800057ee:	2785                	addiw	a5,a5,1
    800057f0:	17c2                	slli	a5,a5,0x30
    800057f2:	93c1                	srli	a5,a5,0x30
    800057f4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057f8:	6898                	ld	a4,16(s1)
    800057fa:	00275703          	lhu	a4,2(a4)
    800057fe:	faf71be3          	bne	a4,a5,800057b4 <virtio_disk_intr+0x54>
    80005802:	64a2                	ld	s1,8(sp)
    80005804:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005806:	00018517          	auipc	a0,0x18
    8000580a:	92250513          	addi	a0,a0,-1758 # 8001d128 <disk+0x2128>
    8000580e:	00001097          	auipc	ra,0x1
    80005812:	b8c080e7          	jalr	-1140(ra) # 8000639a <release>
}
    80005816:	60e2                	ld	ra,24(sp)
    80005818:	6442                	ld	s0,16(sp)
    8000581a:	6105                	addi	sp,sp,32
    8000581c:	8082                	ret
      panic("virtio_disk_intr status");
    8000581e:	00003517          	auipc	a0,0x3
    80005822:	f2250513          	addi	a0,a0,-222 # 80008740 <etext+0x740>
    80005826:	00000097          	auipc	ra,0x0
    8000582a:	546080e7          	jalr	1350(ra) # 80005d6c <panic>

000000008000582e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000582e:	1141                	addi	sp,sp,-16
    80005830:	e422                	sd	s0,8(sp)
    80005832:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005834:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005838:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000583c:	0037979b          	slliw	a5,a5,0x3
    80005840:	02004737          	lui	a4,0x2004
    80005844:	97ba                	add	a5,a5,a4
    80005846:	0200c737          	lui	a4,0x200c
    8000584a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000584c:	6318                	ld	a4,0(a4)
    8000584e:	000f4637          	lui	a2,0xf4
    80005852:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005856:	9732                	add	a4,a4,a2
    80005858:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000585a:	00259693          	slli	a3,a1,0x2
    8000585e:	96ae                	add	a3,a3,a1
    80005860:	068e                	slli	a3,a3,0x3
    80005862:	00018717          	auipc	a4,0x18
    80005866:	79e70713          	addi	a4,a4,1950 # 8001e000 <timer_scratch>
    8000586a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000586c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000586e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005870:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005874:	00000797          	auipc	a5,0x0
    80005878:	99c78793          	addi	a5,a5,-1636 # 80005210 <timervec>
    8000587c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005880:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005884:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005888:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000588c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005890:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005894:	30479073          	csrw	mie,a5
}
    80005898:	6422                	ld	s0,8(sp)
    8000589a:	0141                	addi	sp,sp,16
    8000589c:	8082                	ret

000000008000589e <start>:
{
    8000589e:	1141                	addi	sp,sp,-16
    800058a0:	e406                	sd	ra,8(sp)
    800058a2:	e022                	sd	s0,0(sp)
    800058a4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058a6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058aa:	7779                	lui	a4,0xffffe
    800058ac:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058b0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058b2:	6705                	lui	a4,0x1
    800058b4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058ba:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058be:	ffffb797          	auipc	a5,0xffffb
    800058c2:	aa478793          	addi	a5,a5,-1372 # 80000362 <main>
    800058c6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058ca:	4781                	li	a5,0
    800058cc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058d0:	67c1                	lui	a5,0x10
    800058d2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058d4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058d8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058dc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058e0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058e4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058e8:	57fd                	li	a5,-1
    800058ea:	83a9                	srli	a5,a5,0xa
    800058ec:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058f0:	47bd                	li	a5,15
    800058f2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058f6:	00000097          	auipc	ra,0x0
    800058fa:	f38080e7          	jalr	-200(ra) # 8000582e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058fe:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005902:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005904:	823e                	mv	tp,a5
  asm volatile("mret");
    80005906:	30200073          	mret
}
    8000590a:	60a2                	ld	ra,8(sp)
    8000590c:	6402                	ld	s0,0(sp)
    8000590e:	0141                	addi	sp,sp,16
    80005910:	8082                	ret

0000000080005912 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005912:	715d                	addi	sp,sp,-80
    80005914:	e486                	sd	ra,72(sp)
    80005916:	e0a2                	sd	s0,64(sp)
    80005918:	f84a                	sd	s2,48(sp)
    8000591a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000591c:	04c05663          	blez	a2,80005968 <consolewrite+0x56>
    80005920:	fc26                	sd	s1,56(sp)
    80005922:	f44e                	sd	s3,40(sp)
    80005924:	f052                	sd	s4,32(sp)
    80005926:	ec56                	sd	s5,24(sp)
    80005928:	8a2a                	mv	s4,a0
    8000592a:	84ae                	mv	s1,a1
    8000592c:	89b2                	mv	s3,a2
    8000592e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005930:	5afd                	li	s5,-1
    80005932:	4685                	li	a3,1
    80005934:	8626                	mv	a2,s1
    80005936:	85d2                	mv	a1,s4
    80005938:	fbf40513          	addi	a0,s0,-65
    8000593c:	ffffc097          	auipc	ra,0xffffc
    80005940:	056080e7          	jalr	86(ra) # 80001992 <either_copyin>
    80005944:	03550463          	beq	a0,s5,8000596c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005948:	fbf44503          	lbu	a0,-65(s0)
    8000594c:	00000097          	auipc	ra,0x0
    80005950:	7de080e7          	jalr	2014(ra) # 8000612a <uartputc>
  for(i = 0; i < n; i++){
    80005954:	2905                	addiw	s2,s2,1
    80005956:	0485                	addi	s1,s1,1
    80005958:	fd299de3          	bne	s3,s2,80005932 <consolewrite+0x20>
    8000595c:	894e                	mv	s2,s3
    8000595e:	74e2                	ld	s1,56(sp)
    80005960:	79a2                	ld	s3,40(sp)
    80005962:	7a02                	ld	s4,32(sp)
    80005964:	6ae2                	ld	s5,24(sp)
    80005966:	a039                	j	80005974 <consolewrite+0x62>
    80005968:	4901                	li	s2,0
    8000596a:	a029                	j	80005974 <consolewrite+0x62>
    8000596c:	74e2                	ld	s1,56(sp)
    8000596e:	79a2                	ld	s3,40(sp)
    80005970:	7a02                	ld	s4,32(sp)
    80005972:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005974:	854a                	mv	a0,s2
    80005976:	60a6                	ld	ra,72(sp)
    80005978:	6406                	ld	s0,64(sp)
    8000597a:	7942                	ld	s2,48(sp)
    8000597c:	6161                	addi	sp,sp,80
    8000597e:	8082                	ret

0000000080005980 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005980:	711d                	addi	sp,sp,-96
    80005982:	ec86                	sd	ra,88(sp)
    80005984:	e8a2                	sd	s0,80(sp)
    80005986:	e4a6                	sd	s1,72(sp)
    80005988:	e0ca                	sd	s2,64(sp)
    8000598a:	fc4e                	sd	s3,56(sp)
    8000598c:	f852                	sd	s4,48(sp)
    8000598e:	f456                	sd	s5,40(sp)
    80005990:	f05a                	sd	s6,32(sp)
    80005992:	1080                	addi	s0,sp,96
    80005994:	8aaa                	mv	s5,a0
    80005996:	8a2e                	mv	s4,a1
    80005998:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000599a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000599e:	00020517          	auipc	a0,0x20
    800059a2:	7a250513          	addi	a0,a0,1954 # 80026140 <cons>
    800059a6:	00001097          	auipc	ra,0x1
    800059aa:	940080e7          	jalr	-1728(ra) # 800062e6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059ae:	00020497          	auipc	s1,0x20
    800059b2:	79248493          	addi	s1,s1,1938 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059b6:	00021917          	auipc	s2,0x21
    800059ba:	82290913          	addi	s2,s2,-2014 # 800261d8 <cons+0x98>
  while(n > 0){
    800059be:	0d305463          	blez	s3,80005a86 <consoleread+0x106>
    while(cons.r == cons.w){
    800059c2:	0984a783          	lw	a5,152(s1)
    800059c6:	09c4a703          	lw	a4,156(s1)
    800059ca:	0af71963          	bne	a4,a5,80005a7c <consoleread+0xfc>
      if(myproc()->killed){
    800059ce:	ffffb097          	auipc	ra,0xffffb
    800059d2:	4f8080e7          	jalr	1272(ra) # 80000ec6 <myproc>
    800059d6:	551c                	lw	a5,40(a0)
    800059d8:	e7ad                	bnez	a5,80005a42 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    800059da:	85a6                	mv	a1,s1
    800059dc:	854a                	mv	a0,s2
    800059de:	ffffc097          	auipc	ra,0xffffc
    800059e2:	bba080e7          	jalr	-1094(ra) # 80001598 <sleep>
    while(cons.r == cons.w){
    800059e6:	0984a783          	lw	a5,152(s1)
    800059ea:	09c4a703          	lw	a4,156(s1)
    800059ee:	fef700e3          	beq	a4,a5,800059ce <consoleread+0x4e>
    800059f2:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    800059f4:	00020717          	auipc	a4,0x20
    800059f8:	74c70713          	addi	a4,a4,1868 # 80026140 <cons>
    800059fc:	0017869b          	addiw	a3,a5,1
    80005a00:	08d72c23          	sw	a3,152(a4)
    80005a04:	07f7f693          	andi	a3,a5,127
    80005a08:	9736                	add	a4,a4,a3
    80005a0a:	01874703          	lbu	a4,24(a4)
    80005a0e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a12:	4691                	li	a3,4
    80005a14:	04db8a63          	beq	s7,a3,80005a68 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a18:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a1c:	4685                	li	a3,1
    80005a1e:	faf40613          	addi	a2,s0,-81
    80005a22:	85d2                	mv	a1,s4
    80005a24:	8556                	mv	a0,s5
    80005a26:	ffffc097          	auipc	ra,0xffffc
    80005a2a:	f16080e7          	jalr	-234(ra) # 8000193c <either_copyout>
    80005a2e:	57fd                	li	a5,-1
    80005a30:	04f50a63          	beq	a0,a5,80005a84 <consoleread+0x104>
      break;

    dst++;
    80005a34:	0a05                	addi	s4,s4,1
    --n;
    80005a36:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005a38:	47a9                	li	a5,10
    80005a3a:	06fb8163          	beq	s7,a5,80005a9c <consoleread+0x11c>
    80005a3e:	6be2                	ld	s7,24(sp)
    80005a40:	bfbd                	j	800059be <consoleread+0x3e>
        release(&cons.lock);
    80005a42:	00020517          	auipc	a0,0x20
    80005a46:	6fe50513          	addi	a0,a0,1790 # 80026140 <cons>
    80005a4a:	00001097          	auipc	ra,0x1
    80005a4e:	950080e7          	jalr	-1712(ra) # 8000639a <release>
        return -1;
    80005a52:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005a54:	60e6                	ld	ra,88(sp)
    80005a56:	6446                	ld	s0,80(sp)
    80005a58:	64a6                	ld	s1,72(sp)
    80005a5a:	6906                	ld	s2,64(sp)
    80005a5c:	79e2                	ld	s3,56(sp)
    80005a5e:	7a42                	ld	s4,48(sp)
    80005a60:	7aa2                	ld	s5,40(sp)
    80005a62:	7b02                	ld	s6,32(sp)
    80005a64:	6125                	addi	sp,sp,96
    80005a66:	8082                	ret
      if(n < target){
    80005a68:	0009871b          	sext.w	a4,s3
    80005a6c:	01677a63          	bgeu	a4,s6,80005a80 <consoleread+0x100>
        cons.r--;
    80005a70:	00020717          	auipc	a4,0x20
    80005a74:	76f72423          	sw	a5,1896(a4) # 800261d8 <cons+0x98>
    80005a78:	6be2                	ld	s7,24(sp)
    80005a7a:	a031                	j	80005a86 <consoleread+0x106>
    80005a7c:	ec5e                	sd	s7,24(sp)
    80005a7e:	bf9d                	j	800059f4 <consoleread+0x74>
    80005a80:	6be2                	ld	s7,24(sp)
    80005a82:	a011                	j	80005a86 <consoleread+0x106>
    80005a84:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005a86:	00020517          	auipc	a0,0x20
    80005a8a:	6ba50513          	addi	a0,a0,1722 # 80026140 <cons>
    80005a8e:	00001097          	auipc	ra,0x1
    80005a92:	90c080e7          	jalr	-1780(ra) # 8000639a <release>
  return target - n;
    80005a96:	413b053b          	subw	a0,s6,s3
    80005a9a:	bf6d                	j	80005a54 <consoleread+0xd4>
    80005a9c:	6be2                	ld	s7,24(sp)
    80005a9e:	b7e5                	j	80005a86 <consoleread+0x106>

0000000080005aa0 <consputc>:
{
    80005aa0:	1141                	addi	sp,sp,-16
    80005aa2:	e406                	sd	ra,8(sp)
    80005aa4:	e022                	sd	s0,0(sp)
    80005aa6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005aa8:	10000793          	li	a5,256
    80005aac:	00f50a63          	beq	a0,a5,80005ac0 <consputc+0x20>
    uartputc_sync(c);
    80005ab0:	00000097          	auipc	ra,0x0
    80005ab4:	59c080e7          	jalr	1436(ra) # 8000604c <uartputc_sync>
}
    80005ab8:	60a2                	ld	ra,8(sp)
    80005aba:	6402                	ld	s0,0(sp)
    80005abc:	0141                	addi	sp,sp,16
    80005abe:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ac0:	4521                	li	a0,8
    80005ac2:	00000097          	auipc	ra,0x0
    80005ac6:	58a080e7          	jalr	1418(ra) # 8000604c <uartputc_sync>
    80005aca:	02000513          	li	a0,32
    80005ace:	00000097          	auipc	ra,0x0
    80005ad2:	57e080e7          	jalr	1406(ra) # 8000604c <uartputc_sync>
    80005ad6:	4521                	li	a0,8
    80005ad8:	00000097          	auipc	ra,0x0
    80005adc:	574080e7          	jalr	1396(ra) # 8000604c <uartputc_sync>
    80005ae0:	bfe1                	j	80005ab8 <consputc+0x18>

0000000080005ae2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ae2:	1101                	addi	sp,sp,-32
    80005ae4:	ec06                	sd	ra,24(sp)
    80005ae6:	e822                	sd	s0,16(sp)
    80005ae8:	e426                	sd	s1,8(sp)
    80005aea:	1000                	addi	s0,sp,32
    80005aec:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005aee:	00020517          	auipc	a0,0x20
    80005af2:	65250513          	addi	a0,a0,1618 # 80026140 <cons>
    80005af6:	00000097          	auipc	ra,0x0
    80005afa:	7f0080e7          	jalr	2032(ra) # 800062e6 <acquire>

  switch(c){
    80005afe:	47d5                	li	a5,21
    80005b00:	0af48563          	beq	s1,a5,80005baa <consoleintr+0xc8>
    80005b04:	0297c963          	blt	a5,s1,80005b36 <consoleintr+0x54>
    80005b08:	47a1                	li	a5,8
    80005b0a:	0ef48c63          	beq	s1,a5,80005c02 <consoleintr+0x120>
    80005b0e:	47c1                	li	a5,16
    80005b10:	10f49f63          	bne	s1,a5,80005c2e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005b14:	ffffc097          	auipc	ra,0xffffc
    80005b18:	ed4080e7          	jalr	-300(ra) # 800019e8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b1c:	00020517          	auipc	a0,0x20
    80005b20:	62450513          	addi	a0,a0,1572 # 80026140 <cons>
    80005b24:	00001097          	auipc	ra,0x1
    80005b28:	876080e7          	jalr	-1930(ra) # 8000639a <release>
}
    80005b2c:	60e2                	ld	ra,24(sp)
    80005b2e:	6442                	ld	s0,16(sp)
    80005b30:	64a2                	ld	s1,8(sp)
    80005b32:	6105                	addi	sp,sp,32
    80005b34:	8082                	ret
  switch(c){
    80005b36:	07f00793          	li	a5,127
    80005b3a:	0cf48463          	beq	s1,a5,80005c02 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b3e:	00020717          	auipc	a4,0x20
    80005b42:	60270713          	addi	a4,a4,1538 # 80026140 <cons>
    80005b46:	0a072783          	lw	a5,160(a4)
    80005b4a:	09872703          	lw	a4,152(a4)
    80005b4e:	9f99                	subw	a5,a5,a4
    80005b50:	07f00713          	li	a4,127
    80005b54:	fcf764e3          	bltu	a4,a5,80005b1c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005b58:	47b5                	li	a5,13
    80005b5a:	0cf48d63          	beq	s1,a5,80005c34 <consoleintr+0x152>
      consputc(c);
    80005b5e:	8526                	mv	a0,s1
    80005b60:	00000097          	auipc	ra,0x0
    80005b64:	f40080e7          	jalr	-192(ra) # 80005aa0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b68:	00020797          	auipc	a5,0x20
    80005b6c:	5d878793          	addi	a5,a5,1496 # 80026140 <cons>
    80005b70:	0a07a703          	lw	a4,160(a5)
    80005b74:	0017069b          	addiw	a3,a4,1
    80005b78:	0006861b          	sext.w	a2,a3
    80005b7c:	0ad7a023          	sw	a3,160(a5)
    80005b80:	07f77713          	andi	a4,a4,127
    80005b84:	97ba                	add	a5,a5,a4
    80005b86:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b8a:	47a9                	li	a5,10
    80005b8c:	0cf48b63          	beq	s1,a5,80005c62 <consoleintr+0x180>
    80005b90:	4791                	li	a5,4
    80005b92:	0cf48863          	beq	s1,a5,80005c62 <consoleintr+0x180>
    80005b96:	00020797          	auipc	a5,0x20
    80005b9a:	6427a783          	lw	a5,1602(a5) # 800261d8 <cons+0x98>
    80005b9e:	0807879b          	addiw	a5,a5,128
    80005ba2:	f6f61de3          	bne	a2,a5,80005b1c <consoleintr+0x3a>
    80005ba6:	863e                	mv	a2,a5
    80005ba8:	a86d                	j	80005c62 <consoleintr+0x180>
    80005baa:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005bac:	00020717          	auipc	a4,0x20
    80005bb0:	59470713          	addi	a4,a4,1428 # 80026140 <cons>
    80005bb4:	0a072783          	lw	a5,160(a4)
    80005bb8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bbc:	00020497          	auipc	s1,0x20
    80005bc0:	58448493          	addi	s1,s1,1412 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005bc4:	4929                	li	s2,10
    80005bc6:	02f70a63          	beq	a4,a5,80005bfa <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bca:	37fd                	addiw	a5,a5,-1
    80005bcc:	07f7f713          	andi	a4,a5,127
    80005bd0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bd2:	01874703          	lbu	a4,24(a4)
    80005bd6:	03270463          	beq	a4,s2,80005bfe <consoleintr+0x11c>
      cons.e--;
    80005bda:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bde:	10000513          	li	a0,256
    80005be2:	00000097          	auipc	ra,0x0
    80005be6:	ebe080e7          	jalr	-322(ra) # 80005aa0 <consputc>
    while(cons.e != cons.w &&
    80005bea:	0a04a783          	lw	a5,160(s1)
    80005bee:	09c4a703          	lw	a4,156(s1)
    80005bf2:	fcf71ce3          	bne	a4,a5,80005bca <consoleintr+0xe8>
    80005bf6:	6902                	ld	s2,0(sp)
    80005bf8:	b715                	j	80005b1c <consoleintr+0x3a>
    80005bfa:	6902                	ld	s2,0(sp)
    80005bfc:	b705                	j	80005b1c <consoleintr+0x3a>
    80005bfe:	6902                	ld	s2,0(sp)
    80005c00:	bf31                	j	80005b1c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005c02:	00020717          	auipc	a4,0x20
    80005c06:	53e70713          	addi	a4,a4,1342 # 80026140 <cons>
    80005c0a:	0a072783          	lw	a5,160(a4)
    80005c0e:	09c72703          	lw	a4,156(a4)
    80005c12:	f0f705e3          	beq	a4,a5,80005b1c <consoleintr+0x3a>
      cons.e--;
    80005c16:	37fd                	addiw	a5,a5,-1
    80005c18:	00020717          	auipc	a4,0x20
    80005c1c:	5cf72423          	sw	a5,1480(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c20:	10000513          	li	a0,256
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	e7c080e7          	jalr	-388(ra) # 80005aa0 <consputc>
    80005c2c:	bdc5                	j	80005b1c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c2e:	ee0487e3          	beqz	s1,80005b1c <consoleintr+0x3a>
    80005c32:	b731                	j	80005b3e <consoleintr+0x5c>
      consputc(c);
    80005c34:	4529                	li	a0,10
    80005c36:	00000097          	auipc	ra,0x0
    80005c3a:	e6a080e7          	jalr	-406(ra) # 80005aa0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c3e:	00020797          	auipc	a5,0x20
    80005c42:	50278793          	addi	a5,a5,1282 # 80026140 <cons>
    80005c46:	0a07a703          	lw	a4,160(a5)
    80005c4a:	0017069b          	addiw	a3,a4,1
    80005c4e:	0006861b          	sext.w	a2,a3
    80005c52:	0ad7a023          	sw	a3,160(a5)
    80005c56:	07f77713          	andi	a4,a4,127
    80005c5a:	97ba                	add	a5,a5,a4
    80005c5c:	4729                	li	a4,10
    80005c5e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c62:	00020797          	auipc	a5,0x20
    80005c66:	56c7ad23          	sw	a2,1402(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c6a:	00020517          	auipc	a0,0x20
    80005c6e:	56e50513          	addi	a0,a0,1390 # 800261d8 <cons+0x98>
    80005c72:	ffffc097          	auipc	ra,0xffffc
    80005c76:	ab2080e7          	jalr	-1358(ra) # 80001724 <wakeup>
    80005c7a:	b54d                	j	80005b1c <consoleintr+0x3a>

0000000080005c7c <consoleinit>:

void
consoleinit(void)
{
    80005c7c:	1141                	addi	sp,sp,-16
    80005c7e:	e406                	sd	ra,8(sp)
    80005c80:	e022                	sd	s0,0(sp)
    80005c82:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c84:	00003597          	auipc	a1,0x3
    80005c88:	ad458593          	addi	a1,a1,-1324 # 80008758 <etext+0x758>
    80005c8c:	00020517          	auipc	a0,0x20
    80005c90:	4b450513          	addi	a0,a0,1204 # 80026140 <cons>
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	5c2080e7          	jalr	1474(ra) # 80006256 <initlock>

  uartinit();
    80005c9c:	00000097          	auipc	ra,0x0
    80005ca0:	354080e7          	jalr	852(ra) # 80005ff0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ca4:	00013797          	auipc	a5,0x13
    80005ca8:	62478793          	addi	a5,a5,1572 # 800192c8 <devsw>
    80005cac:	00000717          	auipc	a4,0x0
    80005cb0:	cd470713          	addi	a4,a4,-812 # 80005980 <consoleread>
    80005cb4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cb6:	00000717          	auipc	a4,0x0
    80005cba:	c5c70713          	addi	a4,a4,-932 # 80005912 <consolewrite>
    80005cbe:	ef98                	sd	a4,24(a5)
}
    80005cc0:	60a2                	ld	ra,8(sp)
    80005cc2:	6402                	ld	s0,0(sp)
    80005cc4:	0141                	addi	sp,sp,16
    80005cc6:	8082                	ret

0000000080005cc8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cc8:	7179                	addi	sp,sp,-48
    80005cca:	f406                	sd	ra,40(sp)
    80005ccc:	f022                	sd	s0,32(sp)
    80005cce:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cd0:	c219                	beqz	a2,80005cd6 <printint+0xe>
    80005cd2:	08054963          	bltz	a0,80005d64 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cd6:	2501                	sext.w	a0,a0
    80005cd8:	4881                	li	a7,0
    80005cda:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cde:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ce0:	2581                	sext.w	a1,a1
    80005ce2:	00003617          	auipc	a2,0x3
    80005ce6:	be660613          	addi	a2,a2,-1050 # 800088c8 <digits>
    80005cea:	883a                	mv	a6,a4
    80005cec:	2705                	addiw	a4,a4,1
    80005cee:	02b577bb          	remuw	a5,a0,a1
    80005cf2:	1782                	slli	a5,a5,0x20
    80005cf4:	9381                	srli	a5,a5,0x20
    80005cf6:	97b2                	add	a5,a5,a2
    80005cf8:	0007c783          	lbu	a5,0(a5)
    80005cfc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d00:	0005079b          	sext.w	a5,a0
    80005d04:	02b5553b          	divuw	a0,a0,a1
    80005d08:	0685                	addi	a3,a3,1
    80005d0a:	feb7f0e3          	bgeu	a5,a1,80005cea <printint+0x22>

  if(sign)
    80005d0e:	00088c63          	beqz	a7,80005d26 <printint+0x5e>
    buf[i++] = '-';
    80005d12:	fe070793          	addi	a5,a4,-32
    80005d16:	00878733          	add	a4,a5,s0
    80005d1a:	02d00793          	li	a5,45
    80005d1e:	fef70823          	sb	a5,-16(a4)
    80005d22:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d26:	02e05b63          	blez	a4,80005d5c <printint+0x94>
    80005d2a:	ec26                	sd	s1,24(sp)
    80005d2c:	e84a                	sd	s2,16(sp)
    80005d2e:	fd040793          	addi	a5,s0,-48
    80005d32:	00e784b3          	add	s1,a5,a4
    80005d36:	fff78913          	addi	s2,a5,-1
    80005d3a:	993a                	add	s2,s2,a4
    80005d3c:	377d                	addiw	a4,a4,-1
    80005d3e:	1702                	slli	a4,a4,0x20
    80005d40:	9301                	srli	a4,a4,0x20
    80005d42:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d46:	fff4c503          	lbu	a0,-1(s1)
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	d56080e7          	jalr	-682(ra) # 80005aa0 <consputc>
  while(--i >= 0)
    80005d52:	14fd                	addi	s1,s1,-1
    80005d54:	ff2499e3          	bne	s1,s2,80005d46 <printint+0x7e>
    80005d58:	64e2                	ld	s1,24(sp)
    80005d5a:	6942                	ld	s2,16(sp)
}
    80005d5c:	70a2                	ld	ra,40(sp)
    80005d5e:	7402                	ld	s0,32(sp)
    80005d60:	6145                	addi	sp,sp,48
    80005d62:	8082                	ret
    x = -xx;
    80005d64:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d68:	4885                	li	a7,1
    x = -xx;
    80005d6a:	bf85                	j	80005cda <printint+0x12>

0000000080005d6c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d6c:	1101                	addi	sp,sp,-32
    80005d6e:	ec06                	sd	ra,24(sp)
    80005d70:	e822                	sd	s0,16(sp)
    80005d72:	e426                	sd	s1,8(sp)
    80005d74:	1000                	addi	s0,sp,32
    80005d76:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d78:	00020797          	auipc	a5,0x20
    80005d7c:	4807a423          	sw	zero,1160(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005d80:	00003517          	auipc	a0,0x3
    80005d84:	9e050513          	addi	a0,a0,-1568 # 80008760 <etext+0x760>
    80005d88:	00000097          	auipc	ra,0x0
    80005d8c:	02e080e7          	jalr	46(ra) # 80005db6 <printf>
  printf(s);
    80005d90:	8526                	mv	a0,s1
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	024080e7          	jalr	36(ra) # 80005db6 <printf>
  printf("\n");
    80005d9a:	00002517          	auipc	a0,0x2
    80005d9e:	27e50513          	addi	a0,a0,638 # 80008018 <etext+0x18>
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	014080e7          	jalr	20(ra) # 80005db6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005daa:	4785                	li	a5,1
    80005dac:	00003717          	auipc	a4,0x3
    80005db0:	26f72823          	sw	a5,624(a4) # 8000901c <panicked>
  for(;;)
    80005db4:	a001                	j	80005db4 <panic+0x48>

0000000080005db6 <printf>:
{
    80005db6:	7131                	addi	sp,sp,-192
    80005db8:	fc86                	sd	ra,120(sp)
    80005dba:	f8a2                	sd	s0,112(sp)
    80005dbc:	e8d2                	sd	s4,80(sp)
    80005dbe:	f06a                	sd	s10,32(sp)
    80005dc0:	0100                	addi	s0,sp,128
    80005dc2:	8a2a                	mv	s4,a0
    80005dc4:	e40c                	sd	a1,8(s0)
    80005dc6:	e810                	sd	a2,16(s0)
    80005dc8:	ec14                	sd	a3,24(s0)
    80005dca:	f018                	sd	a4,32(s0)
    80005dcc:	f41c                	sd	a5,40(s0)
    80005dce:	03043823          	sd	a6,48(s0)
    80005dd2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dd6:	00020d17          	auipc	s10,0x20
    80005dda:	42ad2d03          	lw	s10,1066(s10) # 80026200 <pr+0x18>
  if(locking)
    80005dde:	040d1463          	bnez	s10,80005e26 <printf+0x70>
  if (fmt == 0)
    80005de2:	040a0b63          	beqz	s4,80005e38 <printf+0x82>
  va_start(ap, fmt);
    80005de6:	00840793          	addi	a5,s0,8
    80005dea:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dee:	000a4503          	lbu	a0,0(s4)
    80005df2:	18050b63          	beqz	a0,80005f88 <printf+0x1d2>
    80005df6:	f4a6                	sd	s1,104(sp)
    80005df8:	f0ca                	sd	s2,96(sp)
    80005dfa:	ecce                	sd	s3,88(sp)
    80005dfc:	e4d6                	sd	s5,72(sp)
    80005dfe:	e0da                	sd	s6,64(sp)
    80005e00:	fc5e                	sd	s7,56(sp)
    80005e02:	f862                	sd	s8,48(sp)
    80005e04:	f466                	sd	s9,40(sp)
    80005e06:	ec6e                	sd	s11,24(sp)
    80005e08:	4981                	li	s3,0
    if(c != '%'){
    80005e0a:	02500b13          	li	s6,37
    switch(c){
    80005e0e:	07000b93          	li	s7,112
  consputc('x');
    80005e12:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e14:	00003a97          	auipc	s5,0x3
    80005e18:	ab4a8a93          	addi	s5,s5,-1356 # 800088c8 <digits>
    switch(c){
    80005e1c:	07300c13          	li	s8,115
    80005e20:	06400d93          	li	s11,100
    80005e24:	a0b1                	j	80005e70 <printf+0xba>
    acquire(&pr.lock);
    80005e26:	00020517          	auipc	a0,0x20
    80005e2a:	3c250513          	addi	a0,a0,962 # 800261e8 <pr>
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	4b8080e7          	jalr	1208(ra) # 800062e6 <acquire>
    80005e36:	b775                	j	80005de2 <printf+0x2c>
    80005e38:	f4a6                	sd	s1,104(sp)
    80005e3a:	f0ca                	sd	s2,96(sp)
    80005e3c:	ecce                	sd	s3,88(sp)
    80005e3e:	e4d6                	sd	s5,72(sp)
    80005e40:	e0da                	sd	s6,64(sp)
    80005e42:	fc5e                	sd	s7,56(sp)
    80005e44:	f862                	sd	s8,48(sp)
    80005e46:	f466                	sd	s9,40(sp)
    80005e48:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005e4a:	00003517          	auipc	a0,0x3
    80005e4e:	92650513          	addi	a0,a0,-1754 # 80008770 <etext+0x770>
    80005e52:	00000097          	auipc	ra,0x0
    80005e56:	f1a080e7          	jalr	-230(ra) # 80005d6c <panic>
      consputc(c);
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	c46080e7          	jalr	-954(ra) # 80005aa0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e62:	2985                	addiw	s3,s3,1
    80005e64:	013a07b3          	add	a5,s4,s3
    80005e68:	0007c503          	lbu	a0,0(a5)
    80005e6c:	10050563          	beqz	a0,80005f76 <printf+0x1c0>
    if(c != '%'){
    80005e70:	ff6515e3          	bne	a0,s6,80005e5a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005e74:	2985                	addiw	s3,s3,1
    80005e76:	013a07b3          	add	a5,s4,s3
    80005e7a:	0007c783          	lbu	a5,0(a5)
    80005e7e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e82:	10078b63          	beqz	a5,80005f98 <printf+0x1e2>
    switch(c){
    80005e86:	05778a63          	beq	a5,s7,80005eda <printf+0x124>
    80005e8a:	02fbf663          	bgeu	s7,a5,80005eb6 <printf+0x100>
    80005e8e:	09878863          	beq	a5,s8,80005f1e <printf+0x168>
    80005e92:	07800713          	li	a4,120
    80005e96:	0ce79563          	bne	a5,a4,80005f60 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005e9a:	f8843783          	ld	a5,-120(s0)
    80005e9e:	00878713          	addi	a4,a5,8
    80005ea2:	f8e43423          	sd	a4,-120(s0)
    80005ea6:	4605                	li	a2,1
    80005ea8:	85e6                	mv	a1,s9
    80005eaa:	4388                	lw	a0,0(a5)
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	e1c080e7          	jalr	-484(ra) # 80005cc8 <printint>
      break;
    80005eb4:	b77d                	j	80005e62 <printf+0xac>
    switch(c){
    80005eb6:	09678f63          	beq	a5,s6,80005f54 <printf+0x19e>
    80005eba:	0bb79363          	bne	a5,s11,80005f60 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005ebe:	f8843783          	ld	a5,-120(s0)
    80005ec2:	00878713          	addi	a4,a5,8
    80005ec6:	f8e43423          	sd	a4,-120(s0)
    80005eca:	4605                	li	a2,1
    80005ecc:	45a9                	li	a1,10
    80005ece:	4388                	lw	a0,0(a5)
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	df8080e7          	jalr	-520(ra) # 80005cc8 <printint>
      break;
    80005ed8:	b769                	j	80005e62 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005eda:	f8843783          	ld	a5,-120(s0)
    80005ede:	00878713          	addi	a4,a5,8
    80005ee2:	f8e43423          	sd	a4,-120(s0)
    80005ee6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005eea:	03000513          	li	a0,48
    80005eee:	00000097          	auipc	ra,0x0
    80005ef2:	bb2080e7          	jalr	-1102(ra) # 80005aa0 <consputc>
  consputc('x');
    80005ef6:	07800513          	li	a0,120
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	ba6080e7          	jalr	-1114(ra) # 80005aa0 <consputc>
    80005f02:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f04:	03c95793          	srli	a5,s2,0x3c
    80005f08:	97d6                	add	a5,a5,s5
    80005f0a:	0007c503          	lbu	a0,0(a5)
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	b92080e7          	jalr	-1134(ra) # 80005aa0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f16:	0912                	slli	s2,s2,0x4
    80005f18:	34fd                	addiw	s1,s1,-1
    80005f1a:	f4ed                	bnez	s1,80005f04 <printf+0x14e>
    80005f1c:	b799                	j	80005e62 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005f1e:	f8843783          	ld	a5,-120(s0)
    80005f22:	00878713          	addi	a4,a5,8
    80005f26:	f8e43423          	sd	a4,-120(s0)
    80005f2a:	6384                	ld	s1,0(a5)
    80005f2c:	cc89                	beqz	s1,80005f46 <printf+0x190>
      for(; *s; s++)
    80005f2e:	0004c503          	lbu	a0,0(s1)
    80005f32:	d905                	beqz	a0,80005e62 <printf+0xac>
        consputc(*s);
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	b6c080e7          	jalr	-1172(ra) # 80005aa0 <consputc>
      for(; *s; s++)
    80005f3c:	0485                	addi	s1,s1,1
    80005f3e:	0004c503          	lbu	a0,0(s1)
    80005f42:	f96d                	bnez	a0,80005f34 <printf+0x17e>
    80005f44:	bf39                	j	80005e62 <printf+0xac>
        s = "(null)";
    80005f46:	00003497          	auipc	s1,0x3
    80005f4a:	82248493          	addi	s1,s1,-2014 # 80008768 <etext+0x768>
      for(; *s; s++)
    80005f4e:	02800513          	li	a0,40
    80005f52:	b7cd                	j	80005f34 <printf+0x17e>
      consputc('%');
    80005f54:	855a                	mv	a0,s6
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	b4a080e7          	jalr	-1206(ra) # 80005aa0 <consputc>
      break;
    80005f5e:	b711                	j	80005e62 <printf+0xac>
      consputc('%');
    80005f60:	855a                	mv	a0,s6
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	b3e080e7          	jalr	-1218(ra) # 80005aa0 <consputc>
      consputc(c);
    80005f6a:	8526                	mv	a0,s1
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	b34080e7          	jalr	-1228(ra) # 80005aa0 <consputc>
      break;
    80005f74:	b5fd                	j	80005e62 <printf+0xac>
    80005f76:	74a6                	ld	s1,104(sp)
    80005f78:	7906                	ld	s2,96(sp)
    80005f7a:	69e6                	ld	s3,88(sp)
    80005f7c:	6aa6                	ld	s5,72(sp)
    80005f7e:	6b06                	ld	s6,64(sp)
    80005f80:	7be2                	ld	s7,56(sp)
    80005f82:	7c42                	ld	s8,48(sp)
    80005f84:	7ca2                	ld	s9,40(sp)
    80005f86:	6de2                	ld	s11,24(sp)
  if(locking)
    80005f88:	020d1263          	bnez	s10,80005fac <printf+0x1f6>
}
    80005f8c:	70e6                	ld	ra,120(sp)
    80005f8e:	7446                	ld	s0,112(sp)
    80005f90:	6a46                	ld	s4,80(sp)
    80005f92:	7d02                	ld	s10,32(sp)
    80005f94:	6129                	addi	sp,sp,192
    80005f96:	8082                	ret
    80005f98:	74a6                	ld	s1,104(sp)
    80005f9a:	7906                	ld	s2,96(sp)
    80005f9c:	69e6                	ld	s3,88(sp)
    80005f9e:	6aa6                	ld	s5,72(sp)
    80005fa0:	6b06                	ld	s6,64(sp)
    80005fa2:	7be2                	ld	s7,56(sp)
    80005fa4:	7c42                	ld	s8,48(sp)
    80005fa6:	7ca2                	ld	s9,40(sp)
    80005fa8:	6de2                	ld	s11,24(sp)
    80005faa:	bff9                	j	80005f88 <printf+0x1d2>
    release(&pr.lock);
    80005fac:	00020517          	auipc	a0,0x20
    80005fb0:	23c50513          	addi	a0,a0,572 # 800261e8 <pr>
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	3e6080e7          	jalr	998(ra) # 8000639a <release>
}
    80005fbc:	bfc1                	j	80005f8c <printf+0x1d6>

0000000080005fbe <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fbe:	1101                	addi	sp,sp,-32
    80005fc0:	ec06                	sd	ra,24(sp)
    80005fc2:	e822                	sd	s0,16(sp)
    80005fc4:	e426                	sd	s1,8(sp)
    80005fc6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fc8:	00020497          	auipc	s1,0x20
    80005fcc:	22048493          	addi	s1,s1,544 # 800261e8 <pr>
    80005fd0:	00002597          	auipc	a1,0x2
    80005fd4:	7b058593          	addi	a1,a1,1968 # 80008780 <etext+0x780>
    80005fd8:	8526                	mv	a0,s1
    80005fda:	00000097          	auipc	ra,0x0
    80005fde:	27c080e7          	jalr	636(ra) # 80006256 <initlock>
  pr.locking = 1;
    80005fe2:	4785                	li	a5,1
    80005fe4:	cc9c                	sw	a5,24(s1)
}
    80005fe6:	60e2                	ld	ra,24(sp)
    80005fe8:	6442                	ld	s0,16(sp)
    80005fea:	64a2                	ld	s1,8(sp)
    80005fec:	6105                	addi	sp,sp,32
    80005fee:	8082                	ret

0000000080005ff0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ff0:	1141                	addi	sp,sp,-16
    80005ff2:	e406                	sd	ra,8(sp)
    80005ff4:	e022                	sd	s0,0(sp)
    80005ff6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ff8:	100007b7          	lui	a5,0x10000
    80005ffc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006000:	10000737          	lui	a4,0x10000
    80006004:	f8000693          	li	a3,-128
    80006008:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000600c:	468d                	li	a3,3
    8000600e:	10000637          	lui	a2,0x10000
    80006012:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006016:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000601a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000601e:	10000737          	lui	a4,0x10000
    80006022:	461d                	li	a2,7
    80006024:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006028:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000602c:	00002597          	auipc	a1,0x2
    80006030:	75c58593          	addi	a1,a1,1884 # 80008788 <etext+0x788>
    80006034:	00020517          	auipc	a0,0x20
    80006038:	1d450513          	addi	a0,a0,468 # 80026208 <uart_tx_lock>
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	21a080e7          	jalr	538(ra) # 80006256 <initlock>
}
    80006044:	60a2                	ld	ra,8(sp)
    80006046:	6402                	ld	s0,0(sp)
    80006048:	0141                	addi	sp,sp,16
    8000604a:	8082                	ret

000000008000604c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000604c:	1101                	addi	sp,sp,-32
    8000604e:	ec06                	sd	ra,24(sp)
    80006050:	e822                	sd	s0,16(sp)
    80006052:	e426                	sd	s1,8(sp)
    80006054:	1000                	addi	s0,sp,32
    80006056:	84aa                	mv	s1,a0
  push_off();
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	242080e7          	jalr	578(ra) # 8000629a <push_off>

  if(panicked){
    80006060:	00003797          	auipc	a5,0x3
    80006064:	fbc7a783          	lw	a5,-68(a5) # 8000901c <panicked>
    80006068:	eb85                	bnez	a5,80006098 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000606a:	10000737          	lui	a4,0x10000
    8000606e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006070:	00074783          	lbu	a5,0(a4)
    80006074:	0207f793          	andi	a5,a5,32
    80006078:	dfe5                	beqz	a5,80006070 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000607a:	0ff4f513          	zext.b	a0,s1
    8000607e:	100007b7          	lui	a5,0x10000
    80006082:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	2b4080e7          	jalr	692(ra) # 8000633a <pop_off>
}
    8000608e:	60e2                	ld	ra,24(sp)
    80006090:	6442                	ld	s0,16(sp)
    80006092:	64a2                	ld	s1,8(sp)
    80006094:	6105                	addi	sp,sp,32
    80006096:	8082                	ret
    for(;;)
    80006098:	a001                	j	80006098 <uartputc_sync+0x4c>

000000008000609a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000609a:	00003797          	auipc	a5,0x3
    8000609e:	f867b783          	ld	a5,-122(a5) # 80009020 <uart_tx_r>
    800060a2:	00003717          	auipc	a4,0x3
    800060a6:	f8673703          	ld	a4,-122(a4) # 80009028 <uart_tx_w>
    800060aa:	06f70f63          	beq	a4,a5,80006128 <uartstart+0x8e>
{
    800060ae:	7139                	addi	sp,sp,-64
    800060b0:	fc06                	sd	ra,56(sp)
    800060b2:	f822                	sd	s0,48(sp)
    800060b4:	f426                	sd	s1,40(sp)
    800060b6:	f04a                	sd	s2,32(sp)
    800060b8:	ec4e                	sd	s3,24(sp)
    800060ba:	e852                	sd	s4,16(sp)
    800060bc:	e456                	sd	s5,8(sp)
    800060be:	e05a                	sd	s6,0(sp)
    800060c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060c2:	10000937          	lui	s2,0x10000
    800060c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060c8:	00020a97          	auipc	s5,0x20
    800060cc:	140a8a93          	addi	s5,s5,320 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060d0:	00003497          	auipc	s1,0x3
    800060d4:	f5048493          	addi	s1,s1,-176 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800060d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800060dc:	00003997          	auipc	s3,0x3
    800060e0:	f4c98993          	addi	s3,s3,-180 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060e4:	00094703          	lbu	a4,0(s2)
    800060e8:	02077713          	andi	a4,a4,32
    800060ec:	c705                	beqz	a4,80006114 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060ee:	01f7f713          	andi	a4,a5,31
    800060f2:	9756                	add	a4,a4,s5
    800060f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800060f8:	0785                	addi	a5,a5,1
    800060fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800060fc:	8526                	mv	a0,s1
    800060fe:	ffffb097          	auipc	ra,0xffffb
    80006102:	626080e7          	jalr	1574(ra) # 80001724 <wakeup>
    WriteReg(THR, c);
    80006106:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000610a:	609c                	ld	a5,0(s1)
    8000610c:	0009b703          	ld	a4,0(s3)
    80006110:	fcf71ae3          	bne	a4,a5,800060e4 <uartstart+0x4a>
  }
}
    80006114:	70e2                	ld	ra,56(sp)
    80006116:	7442                	ld	s0,48(sp)
    80006118:	74a2                	ld	s1,40(sp)
    8000611a:	7902                	ld	s2,32(sp)
    8000611c:	69e2                	ld	s3,24(sp)
    8000611e:	6a42                	ld	s4,16(sp)
    80006120:	6aa2                	ld	s5,8(sp)
    80006122:	6b02                	ld	s6,0(sp)
    80006124:	6121                	addi	sp,sp,64
    80006126:	8082                	ret
    80006128:	8082                	ret

000000008000612a <uartputc>:
{
    8000612a:	7179                	addi	sp,sp,-48
    8000612c:	f406                	sd	ra,40(sp)
    8000612e:	f022                	sd	s0,32(sp)
    80006130:	e052                	sd	s4,0(sp)
    80006132:	1800                	addi	s0,sp,48
    80006134:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006136:	00020517          	auipc	a0,0x20
    8000613a:	0d250513          	addi	a0,a0,210 # 80026208 <uart_tx_lock>
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	1a8080e7          	jalr	424(ra) # 800062e6 <acquire>
  if(panicked){
    80006146:	00003797          	auipc	a5,0x3
    8000614a:	ed67a783          	lw	a5,-298(a5) # 8000901c <panicked>
    8000614e:	c391                	beqz	a5,80006152 <uartputc+0x28>
    for(;;)
    80006150:	a001                	j	80006150 <uartputc+0x26>
    80006152:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006154:	00003717          	auipc	a4,0x3
    80006158:	ed473703          	ld	a4,-300(a4) # 80009028 <uart_tx_w>
    8000615c:	00003797          	auipc	a5,0x3
    80006160:	ec47b783          	ld	a5,-316(a5) # 80009020 <uart_tx_r>
    80006164:	02078793          	addi	a5,a5,32
    80006168:	02e79f63          	bne	a5,a4,800061a6 <uartputc+0x7c>
    8000616c:	e84a                	sd	s2,16(sp)
    8000616e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006170:	00020997          	auipc	s3,0x20
    80006174:	09898993          	addi	s3,s3,152 # 80026208 <uart_tx_lock>
    80006178:	00003497          	auipc	s1,0x3
    8000617c:	ea848493          	addi	s1,s1,-344 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006180:	00003917          	auipc	s2,0x3
    80006184:	ea890913          	addi	s2,s2,-344 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006188:	85ce                	mv	a1,s3
    8000618a:	8526                	mv	a0,s1
    8000618c:	ffffb097          	auipc	ra,0xffffb
    80006190:	40c080e7          	jalr	1036(ra) # 80001598 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006194:	00093703          	ld	a4,0(s2)
    80006198:	609c                	ld	a5,0(s1)
    8000619a:	02078793          	addi	a5,a5,32
    8000619e:	fee785e3          	beq	a5,a4,80006188 <uartputc+0x5e>
    800061a2:	6942                	ld	s2,16(sp)
    800061a4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061a6:	00020497          	auipc	s1,0x20
    800061aa:	06248493          	addi	s1,s1,98 # 80026208 <uart_tx_lock>
    800061ae:	01f77793          	andi	a5,a4,31
    800061b2:	97a6                	add	a5,a5,s1
    800061b4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800061b8:	0705                	addi	a4,a4,1
    800061ba:	00003797          	auipc	a5,0x3
    800061be:	e6e7b723          	sd	a4,-402(a5) # 80009028 <uart_tx_w>
      uartstart();
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	ed8080e7          	jalr	-296(ra) # 8000609a <uartstart>
      release(&uart_tx_lock);
    800061ca:	8526                	mv	a0,s1
    800061cc:	00000097          	auipc	ra,0x0
    800061d0:	1ce080e7          	jalr	462(ra) # 8000639a <release>
    800061d4:	64e2                	ld	s1,24(sp)
}
    800061d6:	70a2                	ld	ra,40(sp)
    800061d8:	7402                	ld	s0,32(sp)
    800061da:	6a02                	ld	s4,0(sp)
    800061dc:	6145                	addi	sp,sp,48
    800061de:	8082                	ret

00000000800061e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061e0:	1141                	addi	sp,sp,-16
    800061e2:	e422                	sd	s0,8(sp)
    800061e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061e6:	100007b7          	lui	a5,0x10000
    800061ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800061ec:	0007c783          	lbu	a5,0(a5)
    800061f0:	8b85                	andi	a5,a5,1
    800061f2:	cb81                	beqz	a5,80006202 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800061f4:	100007b7          	lui	a5,0x10000
    800061f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061fc:	6422                	ld	s0,8(sp)
    800061fe:	0141                	addi	sp,sp,16
    80006200:	8082                	ret
    return -1;
    80006202:	557d                	li	a0,-1
    80006204:	bfe5                	j	800061fc <uartgetc+0x1c>

0000000080006206 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006206:	1101                	addi	sp,sp,-32
    80006208:	ec06                	sd	ra,24(sp)
    8000620a:	e822                	sd	s0,16(sp)
    8000620c:	e426                	sd	s1,8(sp)
    8000620e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006210:	54fd                	li	s1,-1
    80006212:	a029                	j	8000621c <uartintr+0x16>
      break;
    consoleintr(c);
    80006214:	00000097          	auipc	ra,0x0
    80006218:	8ce080e7          	jalr	-1842(ra) # 80005ae2 <consoleintr>
    int c = uartgetc();
    8000621c:	00000097          	auipc	ra,0x0
    80006220:	fc4080e7          	jalr	-60(ra) # 800061e0 <uartgetc>
    if(c == -1)
    80006224:	fe9518e3          	bne	a0,s1,80006214 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006228:	00020497          	auipc	s1,0x20
    8000622c:	fe048493          	addi	s1,s1,-32 # 80026208 <uart_tx_lock>
    80006230:	8526                	mv	a0,s1
    80006232:	00000097          	auipc	ra,0x0
    80006236:	0b4080e7          	jalr	180(ra) # 800062e6 <acquire>
  uartstart();
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	e60080e7          	jalr	-416(ra) # 8000609a <uartstart>
  release(&uart_tx_lock);
    80006242:	8526                	mv	a0,s1
    80006244:	00000097          	auipc	ra,0x0
    80006248:	156080e7          	jalr	342(ra) # 8000639a <release>
}
    8000624c:	60e2                	ld	ra,24(sp)
    8000624e:	6442                	ld	s0,16(sp)
    80006250:	64a2                	ld	s1,8(sp)
    80006252:	6105                	addi	sp,sp,32
    80006254:	8082                	ret

0000000080006256 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006256:	1141                	addi	sp,sp,-16
    80006258:	e422                	sd	s0,8(sp)
    8000625a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000625c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000625e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006262:	00053823          	sd	zero,16(a0)
}
    80006266:	6422                	ld	s0,8(sp)
    80006268:	0141                	addi	sp,sp,16
    8000626a:	8082                	ret

000000008000626c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000626c:	411c                	lw	a5,0(a0)
    8000626e:	e399                	bnez	a5,80006274 <holding+0x8>
    80006270:	4501                	li	a0,0
  return r;
}
    80006272:	8082                	ret
{
    80006274:	1101                	addi	sp,sp,-32
    80006276:	ec06                	sd	ra,24(sp)
    80006278:	e822                	sd	s0,16(sp)
    8000627a:	e426                	sd	s1,8(sp)
    8000627c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000627e:	6904                	ld	s1,16(a0)
    80006280:	ffffb097          	auipc	ra,0xffffb
    80006284:	c2a080e7          	jalr	-982(ra) # 80000eaa <mycpu>
    80006288:	40a48533          	sub	a0,s1,a0
    8000628c:	00153513          	seqz	a0,a0
}
    80006290:	60e2                	ld	ra,24(sp)
    80006292:	6442                	ld	s0,16(sp)
    80006294:	64a2                	ld	s1,8(sp)
    80006296:	6105                	addi	sp,sp,32
    80006298:	8082                	ret

000000008000629a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000629a:	1101                	addi	sp,sp,-32
    8000629c:	ec06                	sd	ra,24(sp)
    8000629e:	e822                	sd	s0,16(sp)
    800062a0:	e426                	sd	s1,8(sp)
    800062a2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062a4:	100024f3          	csrr	s1,sstatus
    800062a8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062ac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062ae:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062b2:	ffffb097          	auipc	ra,0xffffb
    800062b6:	bf8080e7          	jalr	-1032(ra) # 80000eaa <mycpu>
    800062ba:	5d3c                	lw	a5,120(a0)
    800062bc:	cf89                	beqz	a5,800062d6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062be:	ffffb097          	auipc	ra,0xffffb
    800062c2:	bec080e7          	jalr	-1044(ra) # 80000eaa <mycpu>
    800062c6:	5d3c                	lw	a5,120(a0)
    800062c8:	2785                	addiw	a5,a5,1
    800062ca:	dd3c                	sw	a5,120(a0)
}
    800062cc:	60e2                	ld	ra,24(sp)
    800062ce:	6442                	ld	s0,16(sp)
    800062d0:	64a2                	ld	s1,8(sp)
    800062d2:	6105                	addi	sp,sp,32
    800062d4:	8082                	ret
    mycpu()->intena = old;
    800062d6:	ffffb097          	auipc	ra,0xffffb
    800062da:	bd4080e7          	jalr	-1068(ra) # 80000eaa <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062de:	8085                	srli	s1,s1,0x1
    800062e0:	8885                	andi	s1,s1,1
    800062e2:	dd64                	sw	s1,124(a0)
    800062e4:	bfe9                	j	800062be <push_off+0x24>

00000000800062e6 <acquire>:
{
    800062e6:	1101                	addi	sp,sp,-32
    800062e8:	ec06                	sd	ra,24(sp)
    800062ea:	e822                	sd	s0,16(sp)
    800062ec:	e426                	sd	s1,8(sp)
    800062ee:	1000                	addi	s0,sp,32
    800062f0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062f2:	00000097          	auipc	ra,0x0
    800062f6:	fa8080e7          	jalr	-88(ra) # 8000629a <push_off>
  if(holding(lk))
    800062fa:	8526                	mv	a0,s1
    800062fc:	00000097          	auipc	ra,0x0
    80006300:	f70080e7          	jalr	-144(ra) # 8000626c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006304:	4705                	li	a4,1
  if(holding(lk))
    80006306:	e115                	bnez	a0,8000632a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006308:	87ba                	mv	a5,a4
    8000630a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000630e:	2781                	sext.w	a5,a5
    80006310:	ffe5                	bnez	a5,80006308 <acquire+0x22>
  __sync_synchronize();
    80006312:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006316:	ffffb097          	auipc	ra,0xffffb
    8000631a:	b94080e7          	jalr	-1132(ra) # 80000eaa <mycpu>
    8000631e:	e888                	sd	a0,16(s1)
}
    80006320:	60e2                	ld	ra,24(sp)
    80006322:	6442                	ld	s0,16(sp)
    80006324:	64a2                	ld	s1,8(sp)
    80006326:	6105                	addi	sp,sp,32
    80006328:	8082                	ret
    panic("acquire");
    8000632a:	00002517          	auipc	a0,0x2
    8000632e:	46650513          	addi	a0,a0,1126 # 80008790 <etext+0x790>
    80006332:	00000097          	auipc	ra,0x0
    80006336:	a3a080e7          	jalr	-1478(ra) # 80005d6c <panic>

000000008000633a <pop_off>:

void
pop_off(void)
{
    8000633a:	1141                	addi	sp,sp,-16
    8000633c:	e406                	sd	ra,8(sp)
    8000633e:	e022                	sd	s0,0(sp)
    80006340:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006342:	ffffb097          	auipc	ra,0xffffb
    80006346:	b68080e7          	jalr	-1176(ra) # 80000eaa <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000634a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000634e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006350:	e78d                	bnez	a5,8000637a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006352:	5d3c                	lw	a5,120(a0)
    80006354:	02f05b63          	blez	a5,8000638a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006358:	37fd                	addiw	a5,a5,-1
    8000635a:	0007871b          	sext.w	a4,a5
    8000635e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006360:	eb09                	bnez	a4,80006372 <pop_off+0x38>
    80006362:	5d7c                	lw	a5,124(a0)
    80006364:	c799                	beqz	a5,80006372 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006366:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000636a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000636e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006372:	60a2                	ld	ra,8(sp)
    80006374:	6402                	ld	s0,0(sp)
    80006376:	0141                	addi	sp,sp,16
    80006378:	8082                	ret
    panic("pop_off - interruptible");
    8000637a:	00002517          	auipc	a0,0x2
    8000637e:	41e50513          	addi	a0,a0,1054 # 80008798 <etext+0x798>
    80006382:	00000097          	auipc	ra,0x0
    80006386:	9ea080e7          	jalr	-1558(ra) # 80005d6c <panic>
    panic("pop_off");
    8000638a:	00002517          	auipc	a0,0x2
    8000638e:	42650513          	addi	a0,a0,1062 # 800087b0 <etext+0x7b0>
    80006392:	00000097          	auipc	ra,0x0
    80006396:	9da080e7          	jalr	-1574(ra) # 80005d6c <panic>

000000008000639a <release>:
{
    8000639a:	1101                	addi	sp,sp,-32
    8000639c:	ec06                	sd	ra,24(sp)
    8000639e:	e822                	sd	s0,16(sp)
    800063a0:	e426                	sd	s1,8(sp)
    800063a2:	1000                	addi	s0,sp,32
    800063a4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063a6:	00000097          	auipc	ra,0x0
    800063aa:	ec6080e7          	jalr	-314(ra) # 8000626c <holding>
    800063ae:	c115                	beqz	a0,800063d2 <release+0x38>
  lk->cpu = 0;
    800063b0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063b4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063b8:	0f50000f          	fence	iorw,ow
    800063bc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063c0:	00000097          	auipc	ra,0x0
    800063c4:	f7a080e7          	jalr	-134(ra) # 8000633a <pop_off>
}
    800063c8:	60e2                	ld	ra,24(sp)
    800063ca:	6442                	ld	s0,16(sp)
    800063cc:	64a2                	ld	s1,8(sp)
    800063ce:	6105                	addi	sp,sp,32
    800063d0:	8082                	ret
    panic("release");
    800063d2:	00002517          	auipc	a0,0x2
    800063d6:	3e650513          	addi	a0,a0,998 # 800087b8 <etext+0x7b8>
    800063da:	00000097          	auipc	ra,0x0
    800063de:	992080e7          	jalr	-1646(ra) # 80005d6c <panic>
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
