
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
    80000016:	359050ef          	jal	80005b6e <start>

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
    8000002c:	efd1                	bnez	a5,800000c8 <kfree+0xac>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	08f56863          	bltu	a0,a5,800000c8 <kfree+0xac>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	08f57463          	bgeu	a0,a5,800000c8 <kfree+0xac>
    panic("kfree");
    
  acquire(&kmem.lock);
    80000044:	00009917          	auipc	s2,0x9
    80000048:	fec90913          	addi	s2,s2,-20 # 80009030 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	00006097          	auipc	ra,0x6
    80000052:	568080e7          	jalr	1384(ra) # 800065b6 <acquire>
   return ((char*)pa - (char*)PGROUNDUP((uint64)end)) >> 12;
    80000056:	00027797          	auipc	a5,0x27
    8000005a:	1e978793          	addi	a5,a5,489 # 8002723f <end+0xfff>
    8000005e:	777d                	lui	a4,0xfffff
    80000060:	8ff9                	and	a5,a5,a4
    80000062:	40f487b3          	sub	a5,s1,a5
    80000066:	87b1                	srai	a5,a5,0xc
  if(--kmem.ref_count[kgetrefindex(pa)]){
    80000068:	2781                	sext.w	a5,a5
    8000006a:	078a                	slli	a5,a5,0x2
    8000006c:	03893703          	ld	a4,56(s2)
    80000070:	97ba                	add	a5,a5,a4
    80000072:	4398                	lw	a4,0(a5)
    80000074:	377d                	addiw	a4,a4,-1 # ffffffffffffefff <end+0xffffffff7ffd8dbf>
    80000076:	0007069b          	sext.w	a3,a4
    8000007a:	c398                	sw	a4,0(a5)
    8000007c:	eeb1                	bnez	a3,800000d8 <kfree+0xbc>
    release(&kmem.lock);
    return;
    }
  release(&kmem.lock);
    8000007e:	00009917          	auipc	s2,0x9
    80000082:	fb290913          	addi	s2,s2,-78 # 80009030 <kmem>
    80000086:	854a                	mv	a0,s2
    80000088:	00006097          	auipc	ra,0x6
    8000008c:	5e2080e7          	jalr	1506(ra) # 8000666a <release>
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000090:	6605                	lui	a2,0x1
    80000092:	4585                	li	a1,1
    80000094:	8526                	mv	a0,s1
    80000096:	00000097          	auipc	ra,0x0
    8000009a:	25a080e7          	jalr	602(ra) # 800002f0 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000009e:	854a                	mv	a0,s2
    800000a0:	00006097          	auipc	ra,0x6
    800000a4:	516080e7          	jalr	1302(ra) # 800065b6 <acquire>
  r->next = kmem.freelist;
    800000a8:	01893783          	ld	a5,24(s2)
    800000ac:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000ae:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800000b2:	854a                	mv	a0,s2
    800000b4:	00006097          	auipc	ra,0x6
    800000b8:	5b6080e7          	jalr	1462(ra) # 8000666a <release>
}
    800000bc:	60e2                	ld	ra,24(sp)
    800000be:	6442                	ld	s0,16(sp)
    800000c0:	64a2                	ld	s1,8(sp)
    800000c2:	6902                	ld	s2,0(sp)
    800000c4:	6105                	addi	sp,sp,32
    800000c6:	8082                	ret
    panic("kfree");
    800000c8:	00008517          	auipc	a0,0x8
    800000cc:	f3850513          	addi	a0,a0,-200 # 80008000 <etext>
    800000d0:	00006097          	auipc	ra,0x6
    800000d4:	f6c080e7          	jalr	-148(ra) # 8000603c <panic>
    release(&kmem.lock);
    800000d8:	854a                	mv	a0,s2
    800000da:	00006097          	auipc	ra,0x6
    800000de:	590080e7          	jalr	1424(ra) # 8000666a <release>
    return;
    800000e2:	bfe9                	j	800000bc <kfree+0xa0>

00000000800000e4 <freerange>:
{
    800000e4:	715d                	addi	sp,sp,-80
    800000e6:	e486                	sd	ra,72(sp)
    800000e8:	e0a2                	sd	s0,64(sp)
    800000ea:	fc26                	sd	s1,56(sp)
    800000ec:	0880                	addi	s0,sp,80
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000ee:	6785                	lui	a5,0x1
    800000f0:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000f4:	00e504b3          	add	s1,a0,a4
    800000f8:	777d                	lui	a4,0xfffff
    800000fa:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000fc:	94be                	add	s1,s1,a5
    800000fe:	0495ef63          	bltu	a1,s1,8000015c <freerange+0x78>
    80000102:	f84a                	sd	s2,48(sp)
    80000104:	f44e                	sd	s3,40(sp)
    80000106:	f052                	sd	s4,32(sp)
    80000108:	ec56                	sd	s5,24(sp)
    8000010a:	e85a                	sd	s6,16(sp)
    8000010c:	e45e                	sd	s7,8(sp)
    8000010e:	892e                	mv	s2,a1
    80000110:	7a7d                	lui	s4,0xfffff
     kmem.ref_count[kgetrefindex((void *)p)] = 1;
    80000112:	00009b97          	auipc	s7,0x9
    80000116:	f1eb8b93          	addi	s7,s7,-226 # 80009030 <kmem>
   return ((char*)pa - (char*)PGROUNDUP((uint64)end)) >> 12;
    8000011a:	6b05                	lui	s6,0x1
    8000011c:	00027997          	auipc	s3,0x27
    80000120:	12398993          	addi	s3,s3,291 # 8002723f <end+0xfff>
    80000124:	0149f9b3          	and	s3,s3,s4
     kmem.ref_count[kgetrefindex((void *)p)] = 1;
    80000128:	4a85                	li	s5,1
    8000012a:	01448533          	add	a0,s1,s4
   return ((char*)pa - (char*)PGROUNDUP((uint64)end)) >> 12;
    8000012e:	413507b3          	sub	a5,a0,s3
    80000132:	87b1                	srai	a5,a5,0xc
     kmem.ref_count[kgetrefindex((void *)p)] = 1;
    80000134:	2781                	sext.w	a5,a5
    80000136:	038bb703          	ld	a4,56(s7)
    8000013a:	078a                	slli	a5,a5,0x2
    8000013c:	97ba                	add	a5,a5,a4
    8000013e:	0157a023          	sw	s5,0(a5)
    kfree(p);
    80000142:	00000097          	auipc	ra,0x0
    80000146:	eda080e7          	jalr	-294(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000014a:	94da                	add	s1,s1,s6
    8000014c:	fc997fe3          	bgeu	s2,s1,8000012a <freerange+0x46>
    80000150:	7942                	ld	s2,48(sp)
    80000152:	79a2                	ld	s3,40(sp)
    80000154:	7a02                	ld	s4,32(sp)
    80000156:	6ae2                	ld	s5,24(sp)
    80000158:	6b42                	ld	s6,16(sp)
    8000015a:	6ba2                	ld	s7,8(sp)
}
    8000015c:	60a6                	ld	ra,72(sp)
    8000015e:	6406                	ld	s0,64(sp)
    80000160:	74e2                	ld	s1,56(sp)
    80000162:	6161                	addi	sp,sp,80
    80000164:	8082                	ret

0000000080000166 <kinit>:
{
    80000166:	1101                	addi	sp,sp,-32
    80000168:	ec06                	sd	ra,24(sp)
    8000016a:	e822                	sd	s0,16(sp)
    8000016c:	e426                	sd	s1,8(sp)
    8000016e:	1000                	addi	s0,sp,32
  initlock(&kmem.lock, "kmem");
    80000170:	00009497          	auipc	s1,0x9
    80000174:	ec048493          	addi	s1,s1,-320 # 80009030 <kmem>
    80000178:	00008597          	auipc	a1,0x8
    8000017c:	e9858593          	addi	a1,a1,-360 # 80008010 <etext+0x10>
    80000180:	8526                	mv	a0,s1
    80000182:	00006097          	auipc	ra,0x6
    80000186:	3a4080e7          	jalr	932(ra) # 80006526 <initlock>
  initlock(&kmem.reflock,"kmemref");
    8000018a:	00008597          	auipc	a1,0x8
    8000018e:	e8e58593          	addi	a1,a1,-370 # 80008018 <etext+0x18>
    80000192:	00009517          	auipc	a0,0x9
    80000196:	ebe50513          	addi	a0,a0,-322 # 80009050 <kmem+0x20>
    8000019a:	00006097          	auipc	ra,0x6
    8000019e:	38c080e7          	jalr	908(ra) # 80006526 <initlock>
  uint64 rc_pages = ((PHYSTOP - (uint64)end) >> 12) +1; // 物理页数
    800001a2:	45c5                	li	a1,17
    800001a4:	05ee                	slli	a1,a1,0x1b
    800001a6:	00026517          	auipc	a0,0x26
    800001aa:	09a50513          	addi	a0,a0,154 # 80026240 <end>
    800001ae:	40a587b3          	sub	a5,a1,a0
    800001b2:	83b1                	srli	a5,a5,0xc
    800001b4:	0785                	addi	a5,a5,1
  rc_pages = ((rc_pages * sizeof(uint)) >> 12) + 1;
    800001b6:	83a9                	srli	a5,a5,0xa
  kmem.ref_count = (uint*)end;
    800001b8:	fc88                	sd	a0,56(s1)
  rc_pages = ((rc_pages * sizeof(uint)) >> 12) + 1;
    800001ba:	0785                	addi	a5,a5,1
  uint64 rc_offset = rc_pages << 12;  
    800001bc:	07b2                	slli	a5,a5,0xc
  freerange(end + rc_offset, (void*)PHYSTOP);
    800001be:	953e                	add	a0,a0,a5
    800001c0:	00000097          	auipc	ra,0x0
    800001c4:	f24080e7          	jalr	-220(ra) # 800000e4 <freerange>
}
    800001c8:	60e2                	ld	ra,24(sp)
    800001ca:	6442                	ld	s0,16(sp)
    800001cc:	64a2                	ld	s1,8(sp)
    800001ce:	6105                	addi	sp,sp,32
    800001d0:	8082                	ret

00000000800001d2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800001d2:	1101                	addi	sp,sp,-32
    800001d4:	ec06                	sd	ra,24(sp)
    800001d6:	e822                	sd	s0,16(sp)
    800001d8:	e426                	sd	s1,8(sp)
    800001da:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001dc:	00009497          	auipc	s1,0x9
    800001e0:	e5448493          	addi	s1,s1,-428 # 80009030 <kmem>
    800001e4:	8526                	mv	a0,s1
    800001e6:	00006097          	auipc	ra,0x6
    800001ea:	3d0080e7          	jalr	976(ra) # 800065b6 <acquire>
  r = kmem.freelist;
    800001ee:	6c84                	ld	s1,24(s1)
  if(r){
    800001f0:	c4b9                	beqz	s1,8000023e <kalloc+0x6c>
    kmem.freelist = r->next;
    800001f2:	609c                	ld	a5,0(s1)
    800001f4:	00009517          	auipc	a0,0x9
    800001f8:	e3c50513          	addi	a0,a0,-452 # 80009030 <kmem>
    800001fc:	ed1c                	sd	a5,24(a0)
   return ((char*)pa - (char*)PGROUNDUP((uint64)end)) >> 12;
    800001fe:	00027797          	auipc	a5,0x27
    80000202:	04178793          	addi	a5,a5,65 # 8002723f <end+0xfff>
    80000206:	777d                	lui	a4,0xfffff
    80000208:	8ff9                	and	a5,a5,a4
    8000020a:	40f487b3          	sub	a5,s1,a5
    8000020e:	87b1                	srai	a5,a5,0xc
    kmem.ref_count[kgetrefindex((void *)r)] = 1;
    80000210:	2781                	sext.w	a5,a5
    80000212:	7d18                	ld	a4,56(a0)
    80000214:	078a                	slli	a5,a5,0x2
    80000216:	97ba                	add	a5,a5,a4
    80000218:	4705                	li	a4,1
    8000021a:	c398                	sw	a4,0(a5)
    }
  release(&kmem.lock);
    8000021c:	00006097          	auipc	ra,0x6
    80000220:	44e080e7          	jalr	1102(ra) # 8000666a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000224:	6605                	lui	a2,0x1
    80000226:	4595                	li	a1,5
    80000228:	8526                	mv	a0,s1
    8000022a:	00000097          	auipc	ra,0x0
    8000022e:	0c6080e7          	jalr	198(ra) # 800002f0 <memset>
  return (void*)r;
}
    80000232:	8526                	mv	a0,s1
    80000234:	60e2                	ld	ra,24(sp)
    80000236:	6442                	ld	s0,16(sp)
    80000238:	64a2                	ld	s1,8(sp)
    8000023a:	6105                	addi	sp,sp,32
    8000023c:	8082                	ret
  release(&kmem.lock);
    8000023e:	00009517          	auipc	a0,0x9
    80000242:	df250513          	addi	a0,a0,-526 # 80009030 <kmem>
    80000246:	00006097          	auipc	ra,0x6
    8000024a:	424080e7          	jalr	1060(ra) # 8000666a <release>
  if(r)
    8000024e:	b7d5                	j	80000232 <kalloc+0x60>

0000000080000250 <kgetref>:

int
kgetref(void *pa){
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
   return ((char*)pa - (char*)PGROUNDUP((uint64)end)) >> 12;
    80000256:	00027797          	auipc	a5,0x27
    8000025a:	fe978793          	addi	a5,a5,-23 # 8002723f <end+0xfff>
    8000025e:	777d                	lui	a4,0xfffff
    80000260:	8ff9                	and	a5,a5,a4
    80000262:	40f507b3          	sub	a5,a0,a5
    80000266:	87b1                	srai	a5,a5,0xc
  return kmem.ref_count[kgetrefindex(pa)];
    80000268:	2781                	sext.w	a5,a5
    8000026a:	078a                	slli	a5,a5,0x2
    8000026c:	00009717          	auipc	a4,0x9
    80000270:	dfc73703          	ld	a4,-516(a4) # 80009068 <kmem+0x38>
    80000274:	97ba                	add	a5,a5,a4
}
    80000276:	4388                	lw	a0,0(a5)
    80000278:	6422                	ld	s0,8(sp)
    8000027a:	0141                	addi	sp,sp,16
    8000027c:	8082                	ret

000000008000027e <kaddref>:

void
kaddref(void *pa){
    8000027e:	1141                	addi	sp,sp,-16
    80000280:	e422                	sd	s0,8(sp)
    80000282:	0800                	addi	s0,sp,16
   return ((char*)pa - (char*)PGROUNDUP((uint64)end)) >> 12;
    80000284:	00027797          	auipc	a5,0x27
    80000288:	fbb78793          	addi	a5,a5,-69 # 8002723f <end+0xfff>
    8000028c:	777d                	lui	a4,0xfffff
    8000028e:	8ff9                	and	a5,a5,a4
    80000290:	40f507b3          	sub	a5,a0,a5
    80000294:	87b1                	srai	a5,a5,0xc
  kmem.ref_count[kgetrefindex(pa)]++;
    80000296:	2781                	sext.w	a5,a5
    80000298:	078a                	slli	a5,a5,0x2
    8000029a:	00009717          	auipc	a4,0x9
    8000029e:	dce73703          	ld	a4,-562(a4) # 80009068 <kmem+0x38>
    800002a2:	97ba                	add	a5,a5,a4
    800002a4:	4398                	lw	a4,0(a5)
    800002a6:	2705                	addiw	a4,a4,1
    800002a8:	c398                	sw	a4,0(a5)
}
    800002aa:	6422                	ld	s0,8(sp)
    800002ac:	0141                	addi	sp,sp,16
    800002ae:	8082                	ret

00000000800002b0 <acquire_refcnt>:

inline void
acquire_refcnt(){
    800002b0:	1141                	addi	sp,sp,-16
    800002b2:	e406                	sd	ra,8(sp)
    800002b4:	e022                	sd	s0,0(sp)
    800002b6:	0800                	addi	s0,sp,16
  acquire(&kmem.reflock);
    800002b8:	00009517          	auipc	a0,0x9
    800002bc:	d9850513          	addi	a0,a0,-616 # 80009050 <kmem+0x20>
    800002c0:	00006097          	auipc	ra,0x6
    800002c4:	2f6080e7          	jalr	758(ra) # 800065b6 <acquire>
}
    800002c8:	60a2                	ld	ra,8(sp)
    800002ca:	6402                	ld	s0,0(sp)
    800002cc:	0141                	addi	sp,sp,16
    800002ce:	8082                	ret

00000000800002d0 <release_refcnt>:

inline void
release_refcnt(){
    800002d0:	1141                	addi	sp,sp,-16
    800002d2:	e406                	sd	ra,8(sp)
    800002d4:	e022                	sd	s0,0(sp)
    800002d6:	0800                	addi	s0,sp,16
  release(&kmem.reflock);
    800002d8:	00009517          	auipc	a0,0x9
    800002dc:	d7850513          	addi	a0,a0,-648 # 80009050 <kmem+0x20>
    800002e0:	00006097          	auipc	ra,0x6
    800002e4:	38a080e7          	jalr	906(ra) # 8000666a <release>
}
    800002e8:	60a2                	ld	ra,8(sp)
    800002ea:	6402                	ld	s0,0(sp)
    800002ec:	0141                	addi	sp,sp,16
    800002ee:	8082                	ret

00000000800002f0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002f0:	1141                	addi	sp,sp,-16
    800002f2:	e422                	sd	s0,8(sp)
    800002f4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002f6:	ca19                	beqz	a2,8000030c <memset+0x1c>
    800002f8:	87aa                	mv	a5,a0
    800002fa:	1602                	slli	a2,a2,0x20
    800002fc:	9201                	srli	a2,a2,0x20
    800002fe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000302:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000306:	0785                	addi	a5,a5,1
    80000308:	fee79de3          	bne	a5,a4,80000302 <memset+0x12>
  }
  return dst;
}
    8000030c:	6422                	ld	s0,8(sp)
    8000030e:	0141                	addi	sp,sp,16
    80000310:	8082                	ret

0000000080000312 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000312:	1141                	addi	sp,sp,-16
    80000314:	e422                	sd	s0,8(sp)
    80000316:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000318:	ca05                	beqz	a2,80000348 <memcmp+0x36>
    8000031a:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000031e:	1682                	slli	a3,a3,0x20
    80000320:	9281                	srli	a3,a3,0x20
    80000322:	0685                	addi	a3,a3,1
    80000324:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000326:	00054783          	lbu	a5,0(a0)
    8000032a:	0005c703          	lbu	a4,0(a1)
    8000032e:	00e79863          	bne	a5,a4,8000033e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000332:	0505                	addi	a0,a0,1
    80000334:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000336:	fed518e3          	bne	a0,a3,80000326 <memcmp+0x14>
  }

  return 0;
    8000033a:	4501                	li	a0,0
    8000033c:	a019                	j	80000342 <memcmp+0x30>
      return *s1 - *s2;
    8000033e:	40e7853b          	subw	a0,a5,a4
}
    80000342:	6422                	ld	s0,8(sp)
    80000344:	0141                	addi	sp,sp,16
    80000346:	8082                	ret
  return 0;
    80000348:	4501                	li	a0,0
    8000034a:	bfe5                	j	80000342 <memcmp+0x30>

000000008000034c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000034c:	1141                	addi	sp,sp,-16
    8000034e:	e422                	sd	s0,8(sp)
    80000350:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000352:	c205                	beqz	a2,80000372 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000354:	02a5e263          	bltu	a1,a0,80000378 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000358:	1602                	slli	a2,a2,0x20
    8000035a:	9201                	srli	a2,a2,0x20
    8000035c:	00c587b3          	add	a5,a1,a2
{
    80000360:	872a                	mv	a4,a0
      *d++ = *s++;
    80000362:	0585                	addi	a1,a1,1
    80000364:	0705                	addi	a4,a4,1
    80000366:	fff5c683          	lbu	a3,-1(a1)
    8000036a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000036e:	feb79ae3          	bne	a5,a1,80000362 <memmove+0x16>

  return dst;
}
    80000372:	6422                	ld	s0,8(sp)
    80000374:	0141                	addi	sp,sp,16
    80000376:	8082                	ret
  if(s < d && s + n > d){
    80000378:	02061693          	slli	a3,a2,0x20
    8000037c:	9281                	srli	a3,a3,0x20
    8000037e:	00d58733          	add	a4,a1,a3
    80000382:	fce57be3          	bgeu	a0,a4,80000358 <memmove+0xc>
    d += n;
    80000386:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000388:	fff6079b          	addiw	a5,a2,-1
    8000038c:	1782                	slli	a5,a5,0x20
    8000038e:	9381                	srli	a5,a5,0x20
    80000390:	fff7c793          	not	a5,a5
    80000394:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000396:	177d                	addi	a4,a4,-1
    80000398:	16fd                	addi	a3,a3,-1
    8000039a:	00074603          	lbu	a2,0(a4)
    8000039e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800003a2:	fef71ae3          	bne	a4,a5,80000396 <memmove+0x4a>
    800003a6:	b7f1                	j	80000372 <memmove+0x26>

00000000800003a8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800003a8:	1141                	addi	sp,sp,-16
    800003aa:	e406                	sd	ra,8(sp)
    800003ac:	e022                	sd	s0,0(sp)
    800003ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800003b0:	00000097          	auipc	ra,0x0
    800003b4:	f9c080e7          	jalr	-100(ra) # 8000034c <memmove>
}
    800003b8:	60a2                	ld	ra,8(sp)
    800003ba:	6402                	ld	s0,0(sp)
    800003bc:	0141                	addi	sp,sp,16
    800003be:	8082                	ret

00000000800003c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800003c0:	1141                	addi	sp,sp,-16
    800003c2:	e422                	sd	s0,8(sp)
    800003c4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800003c6:	ce11                	beqz	a2,800003e2 <strncmp+0x22>
    800003c8:	00054783          	lbu	a5,0(a0)
    800003cc:	cf89                	beqz	a5,800003e6 <strncmp+0x26>
    800003ce:	0005c703          	lbu	a4,0(a1)
    800003d2:	00f71a63          	bne	a4,a5,800003e6 <strncmp+0x26>
    n--, p++, q++;
    800003d6:	367d                	addiw	a2,a2,-1
    800003d8:	0505                	addi	a0,a0,1
    800003da:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003dc:	f675                	bnez	a2,800003c8 <strncmp+0x8>
  if(n == 0)
    return 0;
    800003de:	4501                	li	a0,0
    800003e0:	a801                	j	800003f0 <strncmp+0x30>
    800003e2:	4501                	li	a0,0
    800003e4:	a031                	j	800003f0 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800003e6:	00054503          	lbu	a0,0(a0)
    800003ea:	0005c783          	lbu	a5,0(a1)
    800003ee:	9d1d                	subw	a0,a0,a5
}
    800003f0:	6422                	ld	s0,8(sp)
    800003f2:	0141                	addi	sp,sp,16
    800003f4:	8082                	ret

00000000800003f6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003f6:	1141                	addi	sp,sp,-16
    800003f8:	e422                	sd	s0,8(sp)
    800003fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003fc:	87aa                	mv	a5,a0
    800003fe:	86b2                	mv	a3,a2
    80000400:	367d                	addiw	a2,a2,-1
    80000402:	02d05563          	blez	a3,8000042c <strncpy+0x36>
    80000406:	0785                	addi	a5,a5,1
    80000408:	0005c703          	lbu	a4,0(a1)
    8000040c:	fee78fa3          	sb	a4,-1(a5)
    80000410:	0585                	addi	a1,a1,1
    80000412:	f775                	bnez	a4,800003fe <strncpy+0x8>
    ;
  while(n-- > 0)
    80000414:	873e                	mv	a4,a5
    80000416:	9fb5                	addw	a5,a5,a3
    80000418:	37fd                	addiw	a5,a5,-1
    8000041a:	00c05963          	blez	a2,8000042c <strncpy+0x36>
    *s++ = 0;
    8000041e:	0705                	addi	a4,a4,1
    80000420:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000424:	40e786bb          	subw	a3,a5,a4
    80000428:	fed04be3          	bgtz	a3,8000041e <strncpy+0x28>
  return os;
}
    8000042c:	6422                	ld	s0,8(sp)
    8000042e:	0141                	addi	sp,sp,16
    80000430:	8082                	ret

0000000080000432 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000432:	1141                	addi	sp,sp,-16
    80000434:	e422                	sd	s0,8(sp)
    80000436:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000438:	02c05363          	blez	a2,8000045e <safestrcpy+0x2c>
    8000043c:	fff6069b          	addiw	a3,a2,-1
    80000440:	1682                	slli	a3,a3,0x20
    80000442:	9281                	srli	a3,a3,0x20
    80000444:	96ae                	add	a3,a3,a1
    80000446:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000448:	00d58963          	beq	a1,a3,8000045a <safestrcpy+0x28>
    8000044c:	0585                	addi	a1,a1,1
    8000044e:	0785                	addi	a5,a5,1
    80000450:	fff5c703          	lbu	a4,-1(a1)
    80000454:	fee78fa3          	sb	a4,-1(a5)
    80000458:	fb65                	bnez	a4,80000448 <safestrcpy+0x16>
    ;
  *s = 0;
    8000045a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <strlen>:

int
strlen(const char *s)
{
    80000464:	1141                	addi	sp,sp,-16
    80000466:	e422                	sd	s0,8(sp)
    80000468:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000046a:	00054783          	lbu	a5,0(a0)
    8000046e:	cf91                	beqz	a5,8000048a <strlen+0x26>
    80000470:	0505                	addi	a0,a0,1
    80000472:	87aa                	mv	a5,a0
    80000474:	86be                	mv	a3,a5
    80000476:	0785                	addi	a5,a5,1
    80000478:	fff7c703          	lbu	a4,-1(a5)
    8000047c:	ff65                	bnez	a4,80000474 <strlen+0x10>
    8000047e:	40a6853b          	subw	a0,a3,a0
    80000482:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000484:	6422                	ld	s0,8(sp)
    80000486:	0141                	addi	sp,sp,16
    80000488:	8082                	ret
  for(n = 0; s[n]; n++)
    8000048a:	4501                	li	a0,0
    8000048c:	bfe5                	j	80000484 <strlen+0x20>

000000008000048e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000048e:	1141                	addi	sp,sp,-16
    80000490:	e406                	sd	ra,8(sp)
    80000492:	e022                	sd	s0,0(sp)
    80000494:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000496:	00001097          	auipc	ra,0x1
    8000049a:	c66080e7          	jalr	-922(ra) # 800010fc <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000049e:	00009717          	auipc	a4,0x9
    800004a2:	b6270713          	addi	a4,a4,-1182 # 80009000 <started>
  if(cpuid() == 0){
    800004a6:	c139                	beqz	a0,800004ec <main+0x5e>
    while(started == 0)
    800004a8:	431c                	lw	a5,0(a4)
    800004aa:	2781                	sext.w	a5,a5
    800004ac:	dff5                	beqz	a5,800004a8 <main+0x1a>
      ;
    __sync_synchronize();
    800004ae:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800004b2:	00001097          	auipc	ra,0x1
    800004b6:	c4a080e7          	jalr	-950(ra) # 800010fc <cpuid>
    800004ba:	85aa                	mv	a1,a0
    800004bc:	00008517          	auipc	a0,0x8
    800004c0:	b7c50513          	addi	a0,a0,-1156 # 80008038 <etext+0x38>
    800004c4:	00006097          	auipc	ra,0x6
    800004c8:	bc2080e7          	jalr	-1086(ra) # 80006086 <printf>
    kvminithart();    // turn on paging
    800004cc:	00000097          	auipc	ra,0x0
    800004d0:	0d8080e7          	jalr	216(ra) # 800005a4 <kvminithart>
    trapinithart();   // install kernel trap vector
    800004d4:	00002097          	auipc	ra,0x2
    800004d8:	8ac080e7          	jalr	-1876(ra) # 80001d80 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004dc:	00005097          	auipc	ra,0x5
    800004e0:	048080e7          	jalr	72(ra) # 80005524 <plicinithart>
  }

  scheduler();        
    800004e4:	00001097          	auipc	ra,0x1
    800004e8:	158080e7          	jalr	344(ra) # 8000163c <scheduler>
    consoleinit();
    800004ec:	00006097          	auipc	ra,0x6
    800004f0:	a60080e7          	jalr	-1440(ra) # 80005f4c <consoleinit>
    printfinit();
    800004f4:	00006097          	auipc	ra,0x6
    800004f8:	d9a080e7          	jalr	-614(ra) # 8000628e <printfinit>
    printf("\n");
    800004fc:	00008517          	auipc	a0,0x8
    80000500:	db450513          	addi	a0,a0,-588 # 800082b0 <etext+0x2b0>
    80000504:	00006097          	auipc	ra,0x6
    80000508:	b82080e7          	jalr	-1150(ra) # 80006086 <printf>
    printf("xv6 kernel is booting\n");
    8000050c:	00008517          	auipc	a0,0x8
    80000510:	b1450513          	addi	a0,a0,-1260 # 80008020 <etext+0x20>
    80000514:	00006097          	auipc	ra,0x6
    80000518:	b72080e7          	jalr	-1166(ra) # 80006086 <printf>
    printf("\n");
    8000051c:	00008517          	auipc	a0,0x8
    80000520:	d9450513          	addi	a0,a0,-620 # 800082b0 <etext+0x2b0>
    80000524:	00006097          	auipc	ra,0x6
    80000528:	b62080e7          	jalr	-1182(ra) # 80006086 <printf>
    kinit();         // physical page allocator
    8000052c:	00000097          	auipc	ra,0x0
    80000530:	c3a080e7          	jalr	-966(ra) # 80000166 <kinit>
    kvminit();       // create kernel page table
    80000534:	00000097          	auipc	ra,0x0
    80000538:	30c080e7          	jalr	780(ra) # 80000840 <kvminit>
    kvminithart();   // turn on paging
    8000053c:	00000097          	auipc	ra,0x0
    80000540:	068080e7          	jalr	104(ra) # 800005a4 <kvminithart>
    procinit();      // process table
    80000544:	00001097          	auipc	ra,0x1
    80000548:	afa080e7          	jalr	-1286(ra) # 8000103e <procinit>
    trapinit();      // trap vectors
    8000054c:	00002097          	auipc	ra,0x2
    80000550:	80c080e7          	jalr	-2036(ra) # 80001d58 <trapinit>
    trapinithart();  // install kernel trap vector
    80000554:	00002097          	auipc	ra,0x2
    80000558:	82c080e7          	jalr	-2004(ra) # 80001d80 <trapinithart>
    plicinit();      // set up interrupt controller
    8000055c:	00005097          	auipc	ra,0x5
    80000560:	fae080e7          	jalr	-82(ra) # 8000550a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000564:	00005097          	auipc	ra,0x5
    80000568:	fc0080e7          	jalr	-64(ra) # 80005524 <plicinithart>
    binit();         // buffer cache
    8000056c:	00002097          	auipc	ra,0x2
    80000570:	0de080e7          	jalr	222(ra) # 8000264a <binit>
    iinit();         // inode table
    80000574:	00002097          	auipc	ra,0x2
    80000578:	76a080e7          	jalr	1898(ra) # 80002cde <iinit>
    fileinit();      // file table
    8000057c:	00003097          	auipc	ra,0x3
    80000580:	70e080e7          	jalr	1806(ra) # 80003c8a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000584:	00005097          	auipc	ra,0x5
    80000588:	0c0080e7          	jalr	192(ra) # 80005644 <virtio_disk_init>
    userinit();      // first user process
    8000058c:	00001097          	auipc	ra,0x1
    80000590:	e74080e7          	jalr	-396(ra) # 80001400 <userinit>
    __sync_synchronize();
    80000594:	0ff0000f          	fence
    started = 1;
    80000598:	4785                	li	a5,1
    8000059a:	00009717          	auipc	a4,0x9
    8000059e:	a6f72323          	sw	a5,-1434(a4) # 80009000 <started>
    800005a2:	b789                	j	800004e4 <main+0x56>

00000000800005a4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800005a4:	1141                	addi	sp,sp,-16
    800005a6:	e422                	sd	s0,8(sp)
    800005a8:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800005aa:	00009797          	auipc	a5,0x9
    800005ae:	a5e7b783          	ld	a5,-1442(a5) # 80009008 <kernel_pagetable>
    800005b2:	83b1                	srli	a5,a5,0xc
    800005b4:	577d                	li	a4,-1
    800005b6:	177e                	slli	a4,a4,0x3f
    800005b8:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800005ba:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800005be:	12000073          	sfence.vma
  sfence_vma();
}
    800005c2:	6422                	ld	s0,8(sp)
    800005c4:	0141                	addi	sp,sp,16
    800005c6:	8082                	ret

00000000800005c8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005c8:	7139                	addi	sp,sp,-64
    800005ca:	fc06                	sd	ra,56(sp)
    800005cc:	f822                	sd	s0,48(sp)
    800005ce:	f426                	sd	s1,40(sp)
    800005d0:	f04a                	sd	s2,32(sp)
    800005d2:	ec4e                	sd	s3,24(sp)
    800005d4:	e852                	sd	s4,16(sp)
    800005d6:	e456                	sd	s5,8(sp)
    800005d8:	e05a                	sd	s6,0(sp)
    800005da:	0080                	addi	s0,sp,64
    800005dc:	84aa                	mv	s1,a0
    800005de:	89ae                	mv	s3,a1
    800005e0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800005e2:	57fd                	li	a5,-1
    800005e4:	83e9                	srli	a5,a5,0x1a
    800005e6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800005e8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005ea:	04b7f263          	bgeu	a5,a1,8000062e <walk+0x66>
    panic("walk");
    800005ee:	00008517          	auipc	a0,0x8
    800005f2:	a6250513          	addi	a0,a0,-1438 # 80008050 <etext+0x50>
    800005f6:	00006097          	auipc	ra,0x6
    800005fa:	a46080e7          	jalr	-1466(ra) # 8000603c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005fe:	060a8663          	beqz	s5,8000066a <walk+0xa2>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	bd0080e7          	jalr	-1072(ra) # 800001d2 <kalloc>
    8000060a:	84aa                	mv	s1,a0
    8000060c:	c529                	beqz	a0,80000656 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000060e:	6605                	lui	a2,0x1
    80000610:	4581                	li	a1,0
    80000612:	00000097          	auipc	ra,0x0
    80000616:	cde080e7          	jalr	-802(ra) # 800002f0 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000061a:	00c4d793          	srli	a5,s1,0xc
    8000061e:	07aa                	slli	a5,a5,0xa
    80000620:	0017e793          	ori	a5,a5,1
    80000624:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000628:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    8000062a:	036a0063          	beq	s4,s6,8000064a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000062e:	0149d933          	srl	s2,s3,s4
    80000632:	1ff97913          	andi	s2,s2,511
    80000636:	090e                	slli	s2,s2,0x3
    80000638:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000063a:	00093483          	ld	s1,0(s2)
    8000063e:	0014f793          	andi	a5,s1,1
    80000642:	dfd5                	beqz	a5,800005fe <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000644:	80a9                	srli	s1,s1,0xa
    80000646:	04b2                	slli	s1,s1,0xc
    80000648:	b7c5                	j	80000628 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000064a:	00c9d513          	srli	a0,s3,0xc
    8000064e:	1ff57513          	andi	a0,a0,511
    80000652:	050e                	slli	a0,a0,0x3
    80000654:	9526                	add	a0,a0,s1
}
    80000656:	70e2                	ld	ra,56(sp)
    80000658:	7442                	ld	s0,48(sp)
    8000065a:	74a2                	ld	s1,40(sp)
    8000065c:	7902                	ld	s2,32(sp)
    8000065e:	69e2                	ld	s3,24(sp)
    80000660:	6a42                	ld	s4,16(sp)
    80000662:	6aa2                	ld	s5,8(sp)
    80000664:	6b02                	ld	s6,0(sp)
    80000666:	6121                	addi	sp,sp,64
    80000668:	8082                	ret
        return 0;
    8000066a:	4501                	li	a0,0
    8000066c:	b7ed                	j	80000656 <walk+0x8e>

000000008000066e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000066e:	57fd                	li	a5,-1
    80000670:	83e9                	srli	a5,a5,0x1a
    80000672:	00b7f463          	bgeu	a5,a1,8000067a <walkaddr+0xc>
    return 0;
    80000676:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000678:	8082                	ret
{
    8000067a:	1141                	addi	sp,sp,-16
    8000067c:	e406                	sd	ra,8(sp)
    8000067e:	e022                	sd	s0,0(sp)
    80000680:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000682:	4601                	li	a2,0
    80000684:	00000097          	auipc	ra,0x0
    80000688:	f44080e7          	jalr	-188(ra) # 800005c8 <walk>
  if(pte == 0)
    8000068c:	c105                	beqz	a0,800006ac <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000068e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000690:	0117f693          	andi	a3,a5,17
    80000694:	4745                	li	a4,17
    return 0;
    80000696:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000698:	00e68663          	beq	a3,a4,800006a4 <walkaddr+0x36>
}
    8000069c:	60a2                	ld	ra,8(sp)
    8000069e:	6402                	ld	s0,0(sp)
    800006a0:	0141                	addi	sp,sp,16
    800006a2:	8082                	ret
  pa = PTE2PA(*pte);
    800006a4:	83a9                	srli	a5,a5,0xa
    800006a6:	00c79513          	slli	a0,a5,0xc
  return pa;
    800006aa:	bfcd                	j	8000069c <walkaddr+0x2e>
    return 0;
    800006ac:	4501                	li	a0,0
    800006ae:	b7fd                	j	8000069c <walkaddr+0x2e>

00000000800006b0 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800006b0:	715d                	addi	sp,sp,-80
    800006b2:	e486                	sd	ra,72(sp)
    800006b4:	e0a2                	sd	s0,64(sp)
    800006b6:	fc26                	sd	s1,56(sp)
    800006b8:	f84a                	sd	s2,48(sp)
    800006ba:	f44e                	sd	s3,40(sp)
    800006bc:	f052                	sd	s4,32(sp)
    800006be:	ec56                	sd	s5,24(sp)
    800006c0:	e85a                	sd	s6,16(sp)
    800006c2:	e45e                	sd	s7,8(sp)
    800006c4:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800006c6:	c621                	beqz	a2,8000070e <mappages+0x5e>
    800006c8:	8aaa                	mv	s5,a0
    800006ca:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800006cc:	777d                	lui	a4,0xfffff
    800006ce:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800006d2:	fff58993          	addi	s3,a1,-1
    800006d6:	99b2                	add	s3,s3,a2
    800006d8:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800006dc:	893e                	mv	s2,a5
    800006de:	40f68a33          	sub	s4,a3,a5
   // if(*pte & PTE_V)
    //  panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800006e2:	6b85                	lui	s7,0x1
    800006e4:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800006e8:	4605                	li	a2,1
    800006ea:	85ca                	mv	a1,s2
    800006ec:	8556                	mv	a0,s5
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	eda080e7          	jalr	-294(ra) # 800005c8 <walk>
    800006f6:	c505                	beqz	a0,8000071e <mappages+0x6e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006f8:	80b1                	srli	s1,s1,0xc
    800006fa:	04aa                	slli	s1,s1,0xa
    800006fc:	0164e4b3          	or	s1,s1,s6
    80000700:	0014e493          	ori	s1,s1,1
    80000704:	e104                	sd	s1,0(a0)
    if(a == last)
    80000706:	03390863          	beq	s2,s3,80000736 <mappages+0x86>
    a += PGSIZE;
    8000070a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000070c:	bfe1                	j	800006e4 <mappages+0x34>
    panic("mappages: size");
    8000070e:	00008517          	auipc	a0,0x8
    80000712:	94a50513          	addi	a0,a0,-1718 # 80008058 <etext+0x58>
    80000716:	00006097          	auipc	ra,0x6
    8000071a:	926080e7          	jalr	-1754(ra) # 8000603c <panic>
      return -1;
    8000071e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000720:	60a6                	ld	ra,72(sp)
    80000722:	6406                	ld	s0,64(sp)
    80000724:	74e2                	ld	s1,56(sp)
    80000726:	7942                	ld	s2,48(sp)
    80000728:	79a2                	ld	s3,40(sp)
    8000072a:	7a02                	ld	s4,32(sp)
    8000072c:	6ae2                	ld	s5,24(sp)
    8000072e:	6b42                	ld	s6,16(sp)
    80000730:	6ba2                	ld	s7,8(sp)
    80000732:	6161                	addi	sp,sp,80
    80000734:	8082                	ret
  return 0;
    80000736:	4501                	li	a0,0
    80000738:	b7e5                	j	80000720 <mappages+0x70>

000000008000073a <kvmmap>:
{
    8000073a:	1141                	addi	sp,sp,-16
    8000073c:	e406                	sd	ra,8(sp)
    8000073e:	e022                	sd	s0,0(sp)
    80000740:	0800                	addi	s0,sp,16
    80000742:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000744:	86b2                	mv	a3,a2
    80000746:	863e                	mv	a2,a5
    80000748:	00000097          	auipc	ra,0x0
    8000074c:	f68080e7          	jalr	-152(ra) # 800006b0 <mappages>
    80000750:	e509                	bnez	a0,8000075a <kvmmap+0x20>
}
    80000752:	60a2                	ld	ra,8(sp)
    80000754:	6402                	ld	s0,0(sp)
    80000756:	0141                	addi	sp,sp,16
    80000758:	8082                	ret
    panic("kvmmap");
    8000075a:	00008517          	auipc	a0,0x8
    8000075e:	90e50513          	addi	a0,a0,-1778 # 80008068 <etext+0x68>
    80000762:	00006097          	auipc	ra,0x6
    80000766:	8da080e7          	jalr	-1830(ra) # 8000603c <panic>

000000008000076a <kvmmake>:
{
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	e04a                	sd	s2,0(sp)
    80000774:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000776:	00000097          	auipc	ra,0x0
    8000077a:	a5c080e7          	jalr	-1444(ra) # 800001d2 <kalloc>
    8000077e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000780:	6605                	lui	a2,0x1
    80000782:	4581                	li	a1,0
    80000784:	00000097          	auipc	ra,0x0
    80000788:	b6c080e7          	jalr	-1172(ra) # 800002f0 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000078c:	4719                	li	a4,6
    8000078e:	6685                	lui	a3,0x1
    80000790:	10000637          	lui	a2,0x10000
    80000794:	100005b7          	lui	a1,0x10000
    80000798:	8526                	mv	a0,s1
    8000079a:	00000097          	auipc	ra,0x0
    8000079e:	fa0080e7          	jalr	-96(ra) # 8000073a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007a2:	4719                	li	a4,6
    800007a4:	6685                	lui	a3,0x1
    800007a6:	10001637          	lui	a2,0x10001
    800007aa:	100015b7          	lui	a1,0x10001
    800007ae:	8526                	mv	a0,s1
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	f8a080e7          	jalr	-118(ra) # 8000073a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007b8:	4719                	li	a4,6
    800007ba:	004006b7          	lui	a3,0x400
    800007be:	0c000637          	lui	a2,0xc000
    800007c2:	0c0005b7          	lui	a1,0xc000
    800007c6:	8526                	mv	a0,s1
    800007c8:	00000097          	auipc	ra,0x0
    800007cc:	f72080e7          	jalr	-142(ra) # 8000073a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800007d0:	00008917          	auipc	s2,0x8
    800007d4:	83090913          	addi	s2,s2,-2000 # 80008000 <etext>
    800007d8:	4729                	li	a4,10
    800007da:	80008697          	auipc	a3,0x80008
    800007de:	82668693          	addi	a3,a3,-2010 # 8000 <_entry-0x7fff8000>
    800007e2:	4605                	li	a2,1
    800007e4:	067e                	slli	a2,a2,0x1f
    800007e6:	85b2                	mv	a1,a2
    800007e8:	8526                	mv	a0,s1
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	f50080e7          	jalr	-176(ra) # 8000073a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007f2:	46c5                	li	a3,17
    800007f4:	06ee                	slli	a3,a3,0x1b
    800007f6:	4719                	li	a4,6
    800007f8:	412686b3          	sub	a3,a3,s2
    800007fc:	864a                	mv	a2,s2
    800007fe:	85ca                	mv	a1,s2
    80000800:	8526                	mv	a0,s1
    80000802:	00000097          	auipc	ra,0x0
    80000806:	f38080e7          	jalr	-200(ra) # 8000073a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000080a:	4729                	li	a4,10
    8000080c:	6685                	lui	a3,0x1
    8000080e:	00006617          	auipc	a2,0x6
    80000812:	7f260613          	addi	a2,a2,2034 # 80007000 <_trampoline>
    80000816:	040005b7          	lui	a1,0x4000
    8000081a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000081c:	05b2                	slli	a1,a1,0xc
    8000081e:	8526                	mv	a0,s1
    80000820:	00000097          	auipc	ra,0x0
    80000824:	f1a080e7          	jalr	-230(ra) # 8000073a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000828:	8526                	mv	a0,s1
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	770080e7          	jalr	1904(ra) # 80000f9a <proc_mapstacks>
}
    80000832:	8526                	mv	a0,s1
    80000834:	60e2                	ld	ra,24(sp)
    80000836:	6442                	ld	s0,16(sp)
    80000838:	64a2                	ld	s1,8(sp)
    8000083a:	6902                	ld	s2,0(sp)
    8000083c:	6105                	addi	sp,sp,32
    8000083e:	8082                	ret

0000000080000840 <kvminit>:
{
    80000840:	1141                	addi	sp,sp,-16
    80000842:	e406                	sd	ra,8(sp)
    80000844:	e022                	sd	s0,0(sp)
    80000846:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	f22080e7          	jalr	-222(ra) # 8000076a <kvmmake>
    80000850:	00008797          	auipc	a5,0x8
    80000854:	7aa7bc23          	sd	a0,1976(a5) # 80009008 <kernel_pagetable>
}
    80000858:	60a2                	ld	ra,8(sp)
    8000085a:	6402                	ld	s0,0(sp)
    8000085c:	0141                	addi	sp,sp,16
    8000085e:	8082                	ret

0000000080000860 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000860:	715d                	addi	sp,sp,-80
    80000862:	e486                	sd	ra,72(sp)
    80000864:	e0a2                	sd	s0,64(sp)
    80000866:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000868:	03459793          	slli	a5,a1,0x34
    8000086c:	e39d                	bnez	a5,80000892 <uvmunmap+0x32>
    8000086e:	f84a                	sd	s2,48(sp)
    80000870:	f44e                	sd	s3,40(sp)
    80000872:	f052                	sd	s4,32(sp)
    80000874:	ec56                	sd	s5,24(sp)
    80000876:	e85a                	sd	s6,16(sp)
    80000878:	e45e                	sd	s7,8(sp)
    8000087a:	8a2a                	mv	s4,a0
    8000087c:	892e                	mv	s2,a1
    8000087e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000880:	0632                	slli	a2,a2,0xc
    80000882:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000886:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000888:	6b05                	lui	s6,0x1
    8000088a:	0935fb63          	bgeu	a1,s3,80000920 <uvmunmap+0xc0>
    8000088e:	fc26                	sd	s1,56(sp)
    80000890:	a8a9                	j	800008ea <uvmunmap+0x8a>
    80000892:	fc26                	sd	s1,56(sp)
    80000894:	f84a                	sd	s2,48(sp)
    80000896:	f44e                	sd	s3,40(sp)
    80000898:	f052                	sd	s4,32(sp)
    8000089a:	ec56                	sd	s5,24(sp)
    8000089c:	e85a                	sd	s6,16(sp)
    8000089e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800008a0:	00007517          	auipc	a0,0x7
    800008a4:	7d050513          	addi	a0,a0,2000 # 80008070 <etext+0x70>
    800008a8:	00005097          	auipc	ra,0x5
    800008ac:	794080e7          	jalr	1940(ra) # 8000603c <panic>
      panic("uvmunmap: walk");
    800008b0:	00007517          	auipc	a0,0x7
    800008b4:	7d850513          	addi	a0,a0,2008 # 80008088 <etext+0x88>
    800008b8:	00005097          	auipc	ra,0x5
    800008bc:	784080e7          	jalr	1924(ra) # 8000603c <panic>
      panic("uvmunmap: not mapped");
    800008c0:	00007517          	auipc	a0,0x7
    800008c4:	7d850513          	addi	a0,a0,2008 # 80008098 <etext+0x98>
    800008c8:	00005097          	auipc	ra,0x5
    800008cc:	774080e7          	jalr	1908(ra) # 8000603c <panic>
      panic("uvmunmap: not a leaf");
    800008d0:	00007517          	auipc	a0,0x7
    800008d4:	7e050513          	addi	a0,a0,2016 # 800080b0 <etext+0xb0>
    800008d8:	00005097          	auipc	ra,0x5
    800008dc:	764080e7          	jalr	1892(ra) # 8000603c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800008e0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008e4:	995a                	add	s2,s2,s6
    800008e6:	03397c63          	bgeu	s2,s3,8000091e <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008ea:	4601                	li	a2,0
    800008ec:	85ca                	mv	a1,s2
    800008ee:	8552                	mv	a0,s4
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	cd8080e7          	jalr	-808(ra) # 800005c8 <walk>
    800008f8:	84aa                	mv	s1,a0
    800008fa:	d95d                	beqz	a0,800008b0 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800008fc:	6108                	ld	a0,0(a0)
    800008fe:	00157793          	andi	a5,a0,1
    80000902:	dfdd                	beqz	a5,800008c0 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000904:	3ff57793          	andi	a5,a0,1023
    80000908:	fd7784e3          	beq	a5,s7,800008d0 <uvmunmap+0x70>
    if(do_free){
    8000090c:	fc0a8ae3          	beqz	s5,800008e0 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80000910:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000912:	0532                	slli	a0,a0,0xc
    80000914:	fffff097          	auipc	ra,0xfffff
    80000918:	708080e7          	jalr	1800(ra) # 8000001c <kfree>
    8000091c:	b7d1                	j	800008e0 <uvmunmap+0x80>
    8000091e:	74e2                	ld	s1,56(sp)
    80000920:	7942                	ld	s2,48(sp)
    80000922:	79a2                	ld	s3,40(sp)
    80000924:	7a02                	ld	s4,32(sp)
    80000926:	6ae2                	ld	s5,24(sp)
    80000928:	6b42                	ld	s6,16(sp)
    8000092a:	6ba2                	ld	s7,8(sp)
  }
}
    8000092c:	60a6                	ld	ra,72(sp)
    8000092e:	6406                	ld	s0,64(sp)
    80000930:	6161                	addi	sp,sp,80
    80000932:	8082                	ret

0000000080000934 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000934:	1101                	addi	sp,sp,-32
    80000936:	ec06                	sd	ra,24(sp)
    80000938:	e822                	sd	s0,16(sp)
    8000093a:	e426                	sd	s1,8(sp)
    8000093c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000093e:	00000097          	auipc	ra,0x0
    80000942:	894080e7          	jalr	-1900(ra) # 800001d2 <kalloc>
    80000946:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000948:	c519                	beqz	a0,80000956 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000094a:	6605                	lui	a2,0x1
    8000094c:	4581                	li	a1,0
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	9a2080e7          	jalr	-1630(ra) # 800002f0 <memset>
  return pagetable;
}
    80000956:	8526                	mv	a0,s1
    80000958:	60e2                	ld	ra,24(sp)
    8000095a:	6442                	ld	s0,16(sp)
    8000095c:	64a2                	ld	s1,8(sp)
    8000095e:	6105                	addi	sp,sp,32
    80000960:	8082                	ret

0000000080000962 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000962:	7179                	addi	sp,sp,-48
    80000964:	f406                	sd	ra,40(sp)
    80000966:	f022                	sd	s0,32(sp)
    80000968:	ec26                	sd	s1,24(sp)
    8000096a:	e84a                	sd	s2,16(sp)
    8000096c:	e44e                	sd	s3,8(sp)
    8000096e:	e052                	sd	s4,0(sp)
    80000970:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000972:	6785                	lui	a5,0x1
    80000974:	04f67863          	bgeu	a2,a5,800009c4 <uvminit+0x62>
    80000978:	8a2a                	mv	s4,a0
    8000097a:	89ae                	mv	s3,a1
    8000097c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000097e:	00000097          	auipc	ra,0x0
    80000982:	854080e7          	jalr	-1964(ra) # 800001d2 <kalloc>
    80000986:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000988:	6605                	lui	a2,0x1
    8000098a:	4581                	li	a1,0
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	964080e7          	jalr	-1692(ra) # 800002f0 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000994:	4779                	li	a4,30
    80000996:	86ca                	mv	a3,s2
    80000998:	6605                	lui	a2,0x1
    8000099a:	4581                	li	a1,0
    8000099c:	8552                	mv	a0,s4
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	d12080e7          	jalr	-750(ra) # 800006b0 <mappages>
  memmove(mem, src, sz);
    800009a6:	8626                	mv	a2,s1
    800009a8:	85ce                	mv	a1,s3
    800009aa:	854a                	mv	a0,s2
    800009ac:	00000097          	auipc	ra,0x0
    800009b0:	9a0080e7          	jalr	-1632(ra) # 8000034c <memmove>
}
    800009b4:	70a2                	ld	ra,40(sp)
    800009b6:	7402                	ld	s0,32(sp)
    800009b8:	64e2                	ld	s1,24(sp)
    800009ba:	6942                	ld	s2,16(sp)
    800009bc:	69a2                	ld	s3,8(sp)
    800009be:	6a02                	ld	s4,0(sp)
    800009c0:	6145                	addi	sp,sp,48
    800009c2:	8082                	ret
    panic("inituvm: more than a page");
    800009c4:	00007517          	auipc	a0,0x7
    800009c8:	70450513          	addi	a0,a0,1796 # 800080c8 <etext+0xc8>
    800009cc:	00005097          	auipc	ra,0x5
    800009d0:	670080e7          	jalr	1648(ra) # 8000603c <panic>

00000000800009d4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009d4:	1101                	addi	sp,sp,-32
    800009d6:	ec06                	sd	ra,24(sp)
    800009d8:	e822                	sd	s0,16(sp)
    800009da:	e426                	sd	s1,8(sp)
    800009dc:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800009de:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800009e0:	00b67d63          	bgeu	a2,a1,800009fa <uvmdealloc+0x26>
    800009e4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009e6:	6785                	lui	a5,0x1
    800009e8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009ea:	00f60733          	add	a4,a2,a5
    800009ee:	76fd                	lui	a3,0xfffff
    800009f0:	8f75                	and	a4,a4,a3
    800009f2:	97ae                	add	a5,a5,a1
    800009f4:	8ff5                	and	a5,a5,a3
    800009f6:	00f76863          	bltu	a4,a5,80000a06 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009fa:	8526                	mv	a0,s1
    800009fc:	60e2                	ld	ra,24(sp)
    800009fe:	6442                	ld	s0,16(sp)
    80000a00:	64a2                	ld	s1,8(sp)
    80000a02:	6105                	addi	sp,sp,32
    80000a04:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a06:	8f99                	sub	a5,a5,a4
    80000a08:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a0a:	4685                	li	a3,1
    80000a0c:	0007861b          	sext.w	a2,a5
    80000a10:	85ba                	mv	a1,a4
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	e4e080e7          	jalr	-434(ra) # 80000860 <uvmunmap>
    80000a1a:	b7c5                	j	800009fa <uvmdealloc+0x26>

0000000080000a1c <uvmalloc>:
  if(newsz < oldsz)
    80000a1c:	0ab66563          	bltu	a2,a1,80000ac6 <uvmalloc+0xaa>
{
    80000a20:	7139                	addi	sp,sp,-64
    80000a22:	fc06                	sd	ra,56(sp)
    80000a24:	f822                	sd	s0,48(sp)
    80000a26:	ec4e                	sd	s3,24(sp)
    80000a28:	e852                	sd	s4,16(sp)
    80000a2a:	e456                	sd	s5,8(sp)
    80000a2c:	0080                	addi	s0,sp,64
    80000a2e:	8aaa                	mv	s5,a0
    80000a30:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a32:	6785                	lui	a5,0x1
    80000a34:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a36:	95be                	add	a1,a1,a5
    80000a38:	77fd                	lui	a5,0xfffff
    80000a3a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a3e:	08c9f663          	bgeu	s3,a2,80000aca <uvmalloc+0xae>
    80000a42:	f426                	sd	s1,40(sp)
    80000a44:	f04a                	sd	s2,32(sp)
    80000a46:	894e                	mv	s2,s3
    mem = kalloc();
    80000a48:	fffff097          	auipc	ra,0xfffff
    80000a4c:	78a080e7          	jalr	1930(ra) # 800001d2 <kalloc>
    80000a50:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a52:	c90d                	beqz	a0,80000a84 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	4581                	li	a1,0
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	898080e7          	jalr	-1896(ra) # 800002f0 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a60:	4779                	li	a4,30
    80000a62:	86a6                	mv	a3,s1
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85ca                	mv	a1,s2
    80000a68:	8556                	mv	a0,s5
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	c46080e7          	jalr	-954(ra) # 800006b0 <mappages>
    80000a72:	e915                	bnez	a0,80000aa6 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a74:	6785                	lui	a5,0x1
    80000a76:	993e                	add	s2,s2,a5
    80000a78:	fd4968e3          	bltu	s2,s4,80000a48 <uvmalloc+0x2c>
  return newsz;
    80000a7c:	8552                	mv	a0,s4
    80000a7e:	74a2                	ld	s1,40(sp)
    80000a80:	7902                	ld	s2,32(sp)
    80000a82:	a819                	j	80000a98 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000a84:	864e                	mv	a2,s3
    80000a86:	85ca                	mv	a1,s2
    80000a88:	8556                	mv	a0,s5
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	f4a080e7          	jalr	-182(ra) # 800009d4 <uvmdealloc>
      return 0;
    80000a92:	4501                	li	a0,0
    80000a94:	74a2                	ld	s1,40(sp)
    80000a96:	7902                	ld	s2,32(sp)
}
    80000a98:	70e2                	ld	ra,56(sp)
    80000a9a:	7442                	ld	s0,48(sp)
    80000a9c:	69e2                	ld	s3,24(sp)
    80000a9e:	6a42                	ld	s4,16(sp)
    80000aa0:	6aa2                	ld	s5,8(sp)
    80000aa2:	6121                	addi	sp,sp,64
    80000aa4:	8082                	ret
      kfree(mem);
    80000aa6:	8526                	mv	a0,s1
    80000aa8:	fffff097          	auipc	ra,0xfffff
    80000aac:	574080e7          	jalr	1396(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000ab0:	864e                	mv	a2,s3
    80000ab2:	85ca                	mv	a1,s2
    80000ab4:	8556                	mv	a0,s5
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	f1e080e7          	jalr	-226(ra) # 800009d4 <uvmdealloc>
      return 0;
    80000abe:	4501                	li	a0,0
    80000ac0:	74a2                	ld	s1,40(sp)
    80000ac2:	7902                	ld	s2,32(sp)
    80000ac4:	bfd1                	j	80000a98 <uvmalloc+0x7c>
    return oldsz;
    80000ac6:	852e                	mv	a0,a1
}
    80000ac8:	8082                	ret
  return newsz;
    80000aca:	8532                	mv	a0,a2
    80000acc:	b7f1                	j	80000a98 <uvmalloc+0x7c>

0000000080000ace <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000ace:	7179                	addi	sp,sp,-48
    80000ad0:	f406                	sd	ra,40(sp)
    80000ad2:	f022                	sd	s0,32(sp)
    80000ad4:	ec26                	sd	s1,24(sp)
    80000ad6:	e84a                	sd	s2,16(sp)
    80000ad8:	e44e                	sd	s3,8(sp)
    80000ada:	e052                	sd	s4,0(sp)
    80000adc:	1800                	addi	s0,sp,48
    80000ade:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000ae0:	84aa                	mv	s1,a0
    80000ae2:	6905                	lui	s2,0x1
    80000ae4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ae6:	4985                	li	s3,1
    80000ae8:	a829                	j	80000b02 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000aea:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000aec:	00c79513          	slli	a0,a5,0xc
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	fde080e7          	jalr	-34(ra) # 80000ace <freewalk>
      pagetable[i] = 0;
    80000af8:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000afc:	04a1                	addi	s1,s1,8
    80000afe:	03248163          	beq	s1,s2,80000b20 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000b02:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b04:	00f7f713          	andi	a4,a5,15
    80000b08:	ff3701e3          	beq	a4,s3,80000aea <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b0c:	8b85                	andi	a5,a5,1
    80000b0e:	d7fd                	beqz	a5,80000afc <freewalk+0x2e>
      panic("freewalk: leaf");
    80000b10:	00007517          	auipc	a0,0x7
    80000b14:	5d850513          	addi	a0,a0,1496 # 800080e8 <etext+0xe8>
    80000b18:	00005097          	auipc	ra,0x5
    80000b1c:	524080e7          	jalr	1316(ra) # 8000603c <panic>
    }
  }
  kfree((void*)pagetable);
    80000b20:	8552                	mv	a0,s4
    80000b22:	fffff097          	auipc	ra,0xfffff
    80000b26:	4fa080e7          	jalr	1274(ra) # 8000001c <kfree>
}
    80000b2a:	70a2                	ld	ra,40(sp)
    80000b2c:	7402                	ld	s0,32(sp)
    80000b2e:	64e2                	ld	s1,24(sp)
    80000b30:	6942                	ld	s2,16(sp)
    80000b32:	69a2                	ld	s3,8(sp)
    80000b34:	6a02                	ld	s4,0(sp)
    80000b36:	6145                	addi	sp,sp,48
    80000b38:	8082                	ret

0000000080000b3a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b3a:	1101                	addi	sp,sp,-32
    80000b3c:	ec06                	sd	ra,24(sp)
    80000b3e:	e822                	sd	s0,16(sp)
    80000b40:	e426                	sd	s1,8(sp)
    80000b42:	1000                	addi	s0,sp,32
    80000b44:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b46:	e999                	bnez	a1,80000b5c <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b48:	8526                	mv	a0,s1
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	f84080e7          	jalr	-124(ra) # 80000ace <freewalk>
}
    80000b52:	60e2                	ld	ra,24(sp)
    80000b54:	6442                	ld	s0,16(sp)
    80000b56:	64a2                	ld	s1,8(sp)
    80000b58:	6105                	addi	sp,sp,32
    80000b5a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b5c:	6785                	lui	a5,0x1
    80000b5e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b60:	95be                	add	a1,a1,a5
    80000b62:	4685                	li	a3,1
    80000b64:	00c5d613          	srli	a2,a1,0xc
    80000b68:	4581                	li	a1,0
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	cf6080e7          	jalr	-778(ra) # 80000860 <uvmunmap>
    80000b72:	bfd9                	j	80000b48 <uvmfree+0xe>

0000000080000b74 <uvmcopy>:
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.

int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000b74:	7139                	addi	sp,sp,-64
    80000b76:	fc06                	sd	ra,56(sp)
    80000b78:	f822                	sd	s0,48(sp)
    80000b7a:	e05a                	sd	s6,0(sp)
    80000b7c:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000b7e:	ce55                	beqz	a2,80000c3a <uvmcopy+0xc6>
    80000b80:	f426                	sd	s1,40(sp)
    80000b82:	f04a                	sd	s2,32(sp)
    80000b84:	ec4e                	sd	s3,24(sp)
    80000b86:	e852                	sd	s4,16(sp)
    80000b88:	e456                	sd	s5,8(sp)
    80000b8a:	8aaa                	mv	s5,a0
    80000b8c:	8a2e                	mv	s4,a1
    80000b8e:	89b2                	mv	s3,a2
    80000b90:	4481                	li	s1,0
    if((pte = walk(old, i, 0)) == 0)
    80000b92:	4601                	li	a2,0
    80000b94:	85a6                	mv	a1,s1
    80000b96:	8556                	mv	a0,s5
    80000b98:	00000097          	auipc	ra,0x0
    80000b9c:	a30080e7          	jalr	-1488(ra) # 800005c8 <walk>
    80000ba0:	c921                	beqz	a0,80000bf0 <uvmcopy+0x7c>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000ba2:	6118                	ld	a4,0(a0)
    80000ba4:	00177793          	andi	a5,a4,1
    80000ba8:	cfa1                	beqz	a5,80000c00 <uvmcopy+0x8c>
      panic("uvmcopy: page not present");
    // 设置父进程的PTE_W为不可写，且为COW页
    *pte = ((*pte) & (~PTE_W)) | PTE_COW; 
    80000baa:	efb77713          	andi	a4,a4,-261
    80000bae:	10076713          	ori	a4,a4,256
    80000bb2:	e118                	sd	a4,0(a0)
    flags = PTE_FLAGS(*pte);
    pa = PTE2PA(*pte);  
    80000bb4:	00a75913          	srli	s2,a4,0xa
    80000bb8:	0932                	slli	s2,s2,0xc
    // 不为子进程分配内存，指向pa，页表属性设置为flags即可
    if(mappages(new, i, PGSIZE, pa, flags) != 0) {
    80000bba:	3fb77713          	andi	a4,a4,1019
    80000bbe:	86ca                	mv	a3,s2
    80000bc0:	6605                	lui	a2,0x1
    80000bc2:	85a6                	mv	a1,s1
    80000bc4:	8552                	mv	a0,s4
    80000bc6:	00000097          	auipc	ra,0x0
    80000bca:	aea080e7          	jalr	-1302(ra) # 800006b0 <mappages>
    80000bce:	8b2a                	mv	s6,a0
    80000bd0:	e121                	bnez	a0,80000c10 <uvmcopy+0x9c>
      goto err;
    }
    kaddref((void*)pa);
    80000bd2:	854a                	mv	a0,s2
    80000bd4:	fffff097          	auipc	ra,0xfffff
    80000bd8:	6aa080e7          	jalr	1706(ra) # 8000027e <kaddref>
  for(i = 0; i < sz; i += PGSIZE){
    80000bdc:	6785                	lui	a5,0x1
    80000bde:	94be                	add	s1,s1,a5
    80000be0:	fb34e9e3          	bltu	s1,s3,80000b92 <uvmcopy+0x1e>
    80000be4:	74a2                	ld	s1,40(sp)
    80000be6:	7902                	ld	s2,32(sp)
    80000be8:	69e2                	ld	s3,24(sp)
    80000bea:	6a42                	ld	s4,16(sp)
    80000bec:	6aa2                	ld	s5,8(sp)
    80000bee:	a081                	j	80000c2e <uvmcopy+0xba>
      panic("uvmcopy: pte should exist");
    80000bf0:	00007517          	auipc	a0,0x7
    80000bf4:	50850513          	addi	a0,a0,1288 # 800080f8 <etext+0xf8>
    80000bf8:	00005097          	auipc	ra,0x5
    80000bfc:	444080e7          	jalr	1092(ra) # 8000603c <panic>
      panic("uvmcopy: page not present");
    80000c00:	00007517          	auipc	a0,0x7
    80000c04:	51850513          	addi	a0,a0,1304 # 80008118 <etext+0x118>
    80000c08:	00005097          	auipc	ra,0x5
    80000c0c:	434080e7          	jalr	1076(ra) # 8000603c <panic>

 err:
  // 当发生错误时，是否需要恢复错误之前对父进程
  // 页表的修改？如果不恢复，后面的程序是否能够纠正？
  // 在设计后面的程序时需要考虑到这一点
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c10:	4685                	li	a3,1
    80000c12:	00c4d613          	srli	a2,s1,0xc
    80000c16:	4581                	li	a1,0
    80000c18:	8552                	mv	a0,s4
    80000c1a:	00000097          	auipc	ra,0x0
    80000c1e:	c46080e7          	jalr	-954(ra) # 80000860 <uvmunmap>
  return -1;
    80000c22:	5b7d                	li	s6,-1
    80000c24:	74a2                	ld	s1,40(sp)
    80000c26:	7902                	ld	s2,32(sp)
    80000c28:	69e2                	ld	s3,24(sp)
    80000c2a:	6a42                	ld	s4,16(sp)
    80000c2c:	6aa2                	ld	s5,8(sp)
}
    80000c2e:	855a                	mv	a0,s6
    80000c30:	70e2                	ld	ra,56(sp)
    80000c32:	7442                	ld	s0,48(sp)
    80000c34:	6b02                	ld	s6,0(sp)
    80000c36:	6121                	addi	sp,sp,64
    80000c38:	8082                	ret
  return 0;
    80000c3a:	4b01                	li	s6,0
    80000c3c:	bfcd                	j	80000c2e <uvmcopy+0xba>

0000000080000c3e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c3e:	1141                	addi	sp,sp,-16
    80000c40:	e406                	sd	ra,8(sp)
    80000c42:	e022                	sd	s0,0(sp)
    80000c44:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c46:	4601                	li	a2,0
    80000c48:	00000097          	auipc	ra,0x0
    80000c4c:	980080e7          	jalr	-1664(ra) # 800005c8 <walk>
  if(pte == 0)
    80000c50:	c901                	beqz	a0,80000c60 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c52:	611c                	ld	a5,0(a0)
    80000c54:	9bbd                	andi	a5,a5,-17
    80000c56:	e11c                	sd	a5,0(a0)
}
    80000c58:	60a2                	ld	ra,8(sp)
    80000c5a:	6402                	ld	s0,0(sp)
    80000c5c:	0141                	addi	sp,sp,16
    80000c5e:	8082                	ret
    panic("uvmclear");
    80000c60:	00007517          	auipc	a0,0x7
    80000c64:	4d850513          	addi	a0,a0,1240 # 80008138 <etext+0x138>
    80000c68:	00005097          	auipc	ra,0x5
    80000c6c:	3d4080e7          	jalr	980(ra) # 8000603c <panic>

0000000080000c70 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c70:	caa5                	beqz	a3,80000ce0 <copyin+0x70>
{
    80000c72:	715d                	addi	sp,sp,-80
    80000c74:	e486                	sd	ra,72(sp)
    80000c76:	e0a2                	sd	s0,64(sp)
    80000c78:	fc26                	sd	s1,56(sp)
    80000c7a:	f84a                	sd	s2,48(sp)
    80000c7c:	f44e                	sd	s3,40(sp)
    80000c7e:	f052                	sd	s4,32(sp)
    80000c80:	ec56                	sd	s5,24(sp)
    80000c82:	e85a                	sd	s6,16(sp)
    80000c84:	e45e                	sd	s7,8(sp)
    80000c86:	e062                	sd	s8,0(sp)
    80000c88:	0880                	addi	s0,sp,80
    80000c8a:	8b2a                	mv	s6,a0
    80000c8c:	8a2e                	mv	s4,a1
    80000c8e:	8c32                	mv	s8,a2
    80000c90:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c92:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c94:	6a85                	lui	s5,0x1
    80000c96:	a01d                	j	80000cbc <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c98:	018505b3          	add	a1,a0,s8
    80000c9c:	0004861b          	sext.w	a2,s1
    80000ca0:	412585b3          	sub	a1,a1,s2
    80000ca4:	8552                	mv	a0,s4
    80000ca6:	fffff097          	auipc	ra,0xfffff
    80000caa:	6a6080e7          	jalr	1702(ra) # 8000034c <memmove>

    len -= n;
    80000cae:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cb2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cb4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cb8:	02098263          	beqz	s3,80000cdc <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000cbc:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cc0:	85ca                	mv	a1,s2
    80000cc2:	855a                	mv	a0,s6
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	9aa080e7          	jalr	-1622(ra) # 8000066e <walkaddr>
    if(pa0 == 0)
    80000ccc:	cd01                	beqz	a0,80000ce4 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000cce:	418904b3          	sub	s1,s2,s8
    80000cd2:	94d6                	add	s1,s1,s5
    if(n > len)
    80000cd4:	fc99f2e3          	bgeu	s3,s1,80000c98 <copyin+0x28>
    80000cd8:	84ce                	mv	s1,s3
    80000cda:	bf7d                	j	80000c98 <copyin+0x28>
  }
  return 0;
    80000cdc:	4501                	li	a0,0
    80000cde:	a021                	j	80000ce6 <copyin+0x76>
    80000ce0:	4501                	li	a0,0
}
    80000ce2:	8082                	ret
      return -1;
    80000ce4:	557d                	li	a0,-1
}
    80000ce6:	60a6                	ld	ra,72(sp)
    80000ce8:	6406                	ld	s0,64(sp)
    80000cea:	74e2                	ld	s1,56(sp)
    80000cec:	7942                	ld	s2,48(sp)
    80000cee:	79a2                	ld	s3,40(sp)
    80000cf0:	7a02                	ld	s4,32(sp)
    80000cf2:	6ae2                	ld	s5,24(sp)
    80000cf4:	6b42                	ld	s6,16(sp)
    80000cf6:	6ba2                	ld	s7,8(sp)
    80000cf8:	6c02                	ld	s8,0(sp)
    80000cfa:	6161                	addi	sp,sp,80
    80000cfc:	8082                	ret

0000000080000cfe <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000cfe:	cacd                	beqz	a3,80000db0 <copyinstr+0xb2>
{
    80000d00:	715d                	addi	sp,sp,-80
    80000d02:	e486                	sd	ra,72(sp)
    80000d04:	e0a2                	sd	s0,64(sp)
    80000d06:	fc26                	sd	s1,56(sp)
    80000d08:	f84a                	sd	s2,48(sp)
    80000d0a:	f44e                	sd	s3,40(sp)
    80000d0c:	f052                	sd	s4,32(sp)
    80000d0e:	ec56                	sd	s5,24(sp)
    80000d10:	e85a                	sd	s6,16(sp)
    80000d12:	e45e                	sd	s7,8(sp)
    80000d14:	0880                	addi	s0,sp,80
    80000d16:	8a2a                	mv	s4,a0
    80000d18:	8b2e                	mv	s6,a1
    80000d1a:	8bb2                	mv	s7,a2
    80000d1c:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000d1e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d20:	6985                	lui	s3,0x1
    80000d22:	a825                	j	80000d5a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d24:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d28:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d2a:	37fd                	addiw	a5,a5,-1
    80000d2c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d30:	60a6                	ld	ra,72(sp)
    80000d32:	6406                	ld	s0,64(sp)
    80000d34:	74e2                	ld	s1,56(sp)
    80000d36:	7942                	ld	s2,48(sp)
    80000d38:	79a2                	ld	s3,40(sp)
    80000d3a:	7a02                	ld	s4,32(sp)
    80000d3c:	6ae2                	ld	s5,24(sp)
    80000d3e:	6b42                	ld	s6,16(sp)
    80000d40:	6ba2                	ld	s7,8(sp)
    80000d42:	6161                	addi	sp,sp,80
    80000d44:	8082                	ret
    80000d46:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d4a:	9742                	add	a4,a4,a6
      --max;
    80000d4c:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d50:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000d54:	04e58663          	beq	a1,a4,80000da0 <copyinstr+0xa2>
{
    80000d58:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d5a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d5e:	85a6                	mv	a1,s1
    80000d60:	8552                	mv	a0,s4
    80000d62:	00000097          	auipc	ra,0x0
    80000d66:	90c080e7          	jalr	-1780(ra) # 8000066e <walkaddr>
    if(pa0 == 0)
    80000d6a:	cd0d                	beqz	a0,80000da4 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000d6c:	417486b3          	sub	a3,s1,s7
    80000d70:	96ce                	add	a3,a3,s3
    if(n > max)
    80000d72:	00d97363          	bgeu	s2,a3,80000d78 <copyinstr+0x7a>
    80000d76:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000d78:	955e                	add	a0,a0,s7
    80000d7a:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000d7c:	c695                	beqz	a3,80000da8 <copyinstr+0xaa>
    80000d7e:	87da                	mv	a5,s6
    80000d80:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d82:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d86:	96da                	add	a3,a3,s6
    80000d88:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d8a:	00f60733          	add	a4,a2,a5
    80000d8e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000d92:	db49                	beqz	a4,80000d24 <copyinstr+0x26>
        *dst = *p;
    80000d94:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d98:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d9a:	fed797e3          	bne	a5,a3,80000d88 <copyinstr+0x8a>
    80000d9e:	b765                	j	80000d46 <copyinstr+0x48>
    80000da0:	4781                	li	a5,0
    80000da2:	b761                	j	80000d2a <copyinstr+0x2c>
      return -1;
    80000da4:	557d                	li	a0,-1
    80000da6:	b769                	j	80000d30 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000da8:	6b85                	lui	s7,0x1
    80000daa:	9ba6                	add	s7,s7,s1
    80000dac:	87da                	mv	a5,s6
    80000dae:	b76d                	j	80000d58 <copyinstr+0x5a>
  int got_null = 0;
    80000db0:	4781                	li	a5,0
  if(got_null){
    80000db2:	37fd                	addiw	a5,a5,-1
    80000db4:	0007851b          	sext.w	a0,a5
}
    80000db8:	8082                	ret

0000000080000dba <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t* pte;    // add

  while(len > 0){
    80000dba:	18068463          	beqz	a3,80000f42 <copyout+0x188>
{
    80000dbe:	7119                	addi	sp,sp,-128
    80000dc0:	fc86                	sd	ra,120(sp)
    80000dc2:	f8a2                	sd	s0,112(sp)
    80000dc4:	f4a6                	sd	s1,104(sp)
    80000dc6:	e8d2                	sd	s4,80(sp)
    80000dc8:	e4d6                	sd	s5,72(sp)
    80000dca:	e0da                	sd	s6,64(sp)
    80000dcc:	fc5e                	sd	s7,56(sp)
    80000dce:	0100                	addi	s0,sp,128
    80000dd0:	8baa                	mv	s7,a0
    80000dd2:	8aae                	mv	s5,a1
    80000dd4:	8b32                	mv	s6,a2
    80000dd6:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000dd8:	74fd                	lui	s1,0xfffff
    80000dda:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)  
    80000ddc:	57fd                	li	a5,-1
    80000dde:	83e9                	srli	a5,a5,0x1a
    80000de0:	1697e363          	bltu	a5,s1,80000f46 <copyout+0x18c>
    80000de4:	f0ca                	sd	s2,96(sp)
    80000de6:	ecce                	sd	s3,88(sp)
    80000de8:	f862                	sd	s8,48(sp)
    80000dea:	f466                	sd	s9,40(sp)
    80000dec:	f06a                	sd	s10,32(sp)
    80000dee:	ec6e                	sd	s11,24(sp)
      return -1;
    if((pte = walk(pagetable, va0, 0)) == 0)
      return -1;
    if (((*pte & PTE_V) == 0) || ((*pte & PTE_U)) == 0) 
    80000df0:	4cc5                	li	s9,17
      return -1;
    pa0 = PTE2PA(*pte);
    if(((*pte & PTE_W) == 0) && (*pte & PTE_COW)) {
    80000df2:	10000d13          	li	s10,256
      acquire_refcnt();
      if(kgetref((void*)pa0) == 1) {
    80000df6:	4d85                	li	s11,1
    if(va0 >= MAXVA)  
    80000df8:	8c3e                	mv	s8,a5
    80000dfa:	a8d5                	j	80000eee <copyout+0x134>
      acquire_refcnt();
    80000dfc:	fffff097          	auipc	ra,0xfffff
    80000e00:	4b4080e7          	jalr	1204(ra) # 800002b0 <acquire_refcnt>
    pa0 = PTE2PA(*pte);
    80000e04:	00a9d993          	srli	s3,s3,0xa
    80000e08:	09b2                	slli	s3,s3,0xc
      if(kgetref((void*)pa0) == 1) {
    80000e0a:	854e                	mv	a0,s3
    80000e0c:	fffff097          	auipc	ra,0xfffff
    80000e10:	444080e7          	jalr	1092(ra) # 80000250 <kgetref>
    80000e14:	01b51f63          	bne	a0,s11,80000e32 <copyout+0x78>
        *pte = (*pte | PTE_W) & (~PTE_COW);       
    80000e18:	00093783          	ld	a5,0(s2)
    80000e1c:	efb7f793          	andi	a5,a5,-261
    80000e20:	0047e793          	ori	a5,a5,4
    80000e24:	00f93023          	sd	a5,0(s2)
          release_refcnt();
          return -1;
      }
      kfree((void*)pa0);
      }    
      release_refcnt();
    80000e28:	fffff097          	auipc	ra,0xfffff
    80000e2c:	4a8080e7          	jalr	1192(ra) # 800002d0 <release_refcnt>
    80000e30:	a0d5                	j	80000f14 <copyout+0x15a>
        char* mem = kalloc();
    80000e32:	fffff097          	auipc	ra,0xfffff
    80000e36:	3a0080e7          	jalr	928(ra) # 800001d2 <kalloc>
    80000e3a:	f8a43423          	sd	a0,-120(s0)
        if(mem == 0) {
    80000e3e:	cd1d                	beqz	a0,80000e7c <copyout+0xc2>
        memmove(mem, (void*)pa0, PGSIZE);
    80000e40:	6605                	lui	a2,0x1
    80000e42:	85ce                	mv	a1,s3
    80000e44:	f8843503          	ld	a0,-120(s0)
    80000e48:	fffff097          	auipc	ra,0xfffff
    80000e4c:	504080e7          	jalr	1284(ra) # 8000034c <memmove>
        uint newflags = (PTE_FLAGS(*pte) & (~PTE_COW)) | PTE_W;
    80000e50:	00093703          	ld	a4,0(s2)
    80000e54:	2fb77713          	andi	a4,a4,763
        if(mappages(pagetable, va0, PGSIZE, (uint64)mem, newflags) != 0) {
    80000e58:	00476713          	ori	a4,a4,4
    80000e5c:	f8843683          	ld	a3,-120(s0)
    80000e60:	6605                	lui	a2,0x1
    80000e62:	85a6                	mv	a1,s1
    80000e64:	855e                	mv	a0,s7
    80000e66:	00000097          	auipc	ra,0x0
    80000e6a:	84a080e7          	jalr	-1974(ra) # 800006b0 <mappages>
    80000e6e:	e91d                	bnez	a0,80000ea4 <copyout+0xea>
      kfree((void*)pa0);
    80000e70:	854e                	mv	a0,s3
    80000e72:	fffff097          	auipc	ra,0xfffff
    80000e76:	1aa080e7          	jalr	426(ra) # 8000001c <kfree>
    80000e7a:	b77d                	j	80000e28 <copyout+0x6e>
          printf("copyout(): memery alloc fault\n");
    80000e7c:	00007517          	auipc	a0,0x7
    80000e80:	2cc50513          	addi	a0,a0,716 # 80008148 <etext+0x148>
    80000e84:	00005097          	auipc	ra,0x5
    80000e88:	202080e7          	jalr	514(ra) # 80006086 <printf>
          release_refcnt();
    80000e8c:	fffff097          	auipc	ra,0xfffff
    80000e90:	444080e7          	jalr	1092(ra) # 800002d0 <release_refcnt>
          return -1;
    80000e94:	557d                	li	a0,-1
    80000e96:	7906                	ld	s2,96(sp)
    80000e98:	69e6                	ld	s3,88(sp)
    80000e9a:	7c42                	ld	s8,48(sp)
    80000e9c:	7ca2                	ld	s9,40(sp)
    80000e9e:	7d02                	ld	s10,32(sp)
    80000ea0:	6de2                	ld	s11,24(sp)
    80000ea2:	a0d9                	j	80000f68 <copyout+0x1ae>
          kfree(mem);
    80000ea4:	f8843503          	ld	a0,-120(s0)
    80000ea8:	fffff097          	auipc	ra,0xfffff
    80000eac:	174080e7          	jalr	372(ra) # 8000001c <kfree>
          release_refcnt();
    80000eb0:	fffff097          	auipc	ra,0xfffff
    80000eb4:	420080e7          	jalr	1056(ra) # 800002d0 <release_refcnt>
          return -1;
    80000eb8:	557d                	li	a0,-1
    80000eba:	7906                	ld	s2,96(sp)
    80000ebc:	69e6                	ld	s3,88(sp)
    80000ebe:	7c42                	ld	s8,48(sp)
    80000ec0:	7ca2                	ld	s9,40(sp)
    80000ec2:	7d02                	ld	s10,32(sp)
    80000ec4:	6de2                	ld	s11,24(sp)
    80000ec6:	a04d                	j	80000f68 <copyout+0x1ae>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ec8:	409a84b3          	sub	s1,s5,s1
    80000ecc:	0009861b          	sext.w	a2,s3
    80000ed0:	85da                	mv	a1,s6
    80000ed2:	9526                	add	a0,a0,s1
    80000ed4:	fffff097          	auipc	ra,0xfffff
    80000ed8:	478080e7          	jalr	1144(ra) # 8000034c <memmove>

    len -= n;
    80000edc:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000ee0:	9b4e                	add	s6,s6,s3
  while(len > 0){
    80000ee2:	040a0863          	beqz	s4,80000f32 <copyout+0x178>
    if(va0 >= MAXVA)  
    80000ee6:	072c6263          	bltu	s8,s2,80000f4a <copyout+0x190>
    80000eea:	84ca                	mv	s1,s2
    80000eec:	8aca                	mv	s5,s2
    if((pte = walk(pagetable, va0, 0)) == 0)
    80000eee:	4601                	li	a2,0
    80000ef0:	85a6                	mv	a1,s1
    80000ef2:	855e                	mv	a0,s7
    80000ef4:	fffff097          	auipc	ra,0xfffff
    80000ef8:	6d4080e7          	jalr	1748(ra) # 800005c8 <walk>
    80000efc:	892a                	mv	s2,a0
    80000efe:	cd31                	beqz	a0,80000f5a <copyout+0x1a0>
    if (((*pte & PTE_V) == 0) || ((*pte & PTE_U)) == 0) 
    80000f00:	00053983          	ld	s3,0(a0)
    80000f04:	0119f793          	andi	a5,s3,17
    80000f08:	07979963          	bne	a5,s9,80000f7a <copyout+0x1c0>
    if(((*pte & PTE_W) == 0) && (*pte & PTE_COW)) {
    80000f0c:	1049f793          	andi	a5,s3,260
    80000f10:	efa786e3          	beq	a5,s10,80000dfc <copyout+0x42>
    pa0 = walkaddr(pagetable, va0);
    80000f14:	85a6                	mv	a1,s1
    80000f16:	855e                	mv	a0,s7
    80000f18:	fffff097          	auipc	ra,0xfffff
    80000f1c:	756080e7          	jalr	1878(ra) # 8000066e <walkaddr>
    if(pa0 == 0)
    80000f20:	c52d                	beqz	a0,80000f8a <copyout+0x1d0>
    n = PGSIZE - (dstva - va0);
    80000f22:	6905                	lui	s2,0x1
    80000f24:	9926                	add	s2,s2,s1
    80000f26:	415909b3          	sub	s3,s2,s5
    if(n > len)
    80000f2a:	f93a7fe3          	bgeu	s4,s3,80000ec8 <copyout+0x10e>
    80000f2e:	89d2                	mv	s3,s4
    80000f30:	bf61                	j	80000ec8 <copyout+0x10e>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000f32:	4501                	li	a0,0
    80000f34:	7906                	ld	s2,96(sp)
    80000f36:	69e6                	ld	s3,88(sp)
    80000f38:	7c42                	ld	s8,48(sp)
    80000f3a:	7ca2                	ld	s9,40(sp)
    80000f3c:	7d02                	ld	s10,32(sp)
    80000f3e:	6de2                	ld	s11,24(sp)
    80000f40:	a025                	j	80000f68 <copyout+0x1ae>
    80000f42:	4501                	li	a0,0
}
    80000f44:	8082                	ret
      return -1;
    80000f46:	557d                	li	a0,-1
    80000f48:	a005                	j	80000f68 <copyout+0x1ae>
    80000f4a:	557d                	li	a0,-1
    80000f4c:	7906                	ld	s2,96(sp)
    80000f4e:	69e6                	ld	s3,88(sp)
    80000f50:	7c42                	ld	s8,48(sp)
    80000f52:	7ca2                	ld	s9,40(sp)
    80000f54:	7d02                	ld	s10,32(sp)
    80000f56:	6de2                	ld	s11,24(sp)
    80000f58:	a801                	j	80000f68 <copyout+0x1ae>
      return -1;
    80000f5a:	557d                	li	a0,-1
    80000f5c:	7906                	ld	s2,96(sp)
    80000f5e:	69e6                	ld	s3,88(sp)
    80000f60:	7c42                	ld	s8,48(sp)
    80000f62:	7ca2                	ld	s9,40(sp)
    80000f64:	7d02                	ld	s10,32(sp)
    80000f66:	6de2                	ld	s11,24(sp)
}
    80000f68:	70e6                	ld	ra,120(sp)
    80000f6a:	7446                	ld	s0,112(sp)
    80000f6c:	74a6                	ld	s1,104(sp)
    80000f6e:	6a46                	ld	s4,80(sp)
    80000f70:	6aa6                	ld	s5,72(sp)
    80000f72:	6b06                	ld	s6,64(sp)
    80000f74:	7be2                	ld	s7,56(sp)
    80000f76:	6109                	addi	sp,sp,128
    80000f78:	8082                	ret
      return -1;
    80000f7a:	557d                	li	a0,-1
    80000f7c:	7906                	ld	s2,96(sp)
    80000f7e:	69e6                	ld	s3,88(sp)
    80000f80:	7c42                	ld	s8,48(sp)
    80000f82:	7ca2                	ld	s9,40(sp)
    80000f84:	7d02                	ld	s10,32(sp)
    80000f86:	6de2                	ld	s11,24(sp)
    80000f88:	b7c5                	j	80000f68 <copyout+0x1ae>
      return -1;
    80000f8a:	557d                	li	a0,-1
    80000f8c:	7906                	ld	s2,96(sp)
    80000f8e:	69e6                	ld	s3,88(sp)
    80000f90:	7c42                	ld	s8,48(sp)
    80000f92:	7ca2                	ld	s9,40(sp)
    80000f94:	7d02                	ld	s10,32(sp)
    80000f96:	6de2                	ld	s11,24(sp)
    80000f98:	bfc1                	j	80000f68 <copyout+0x1ae>

0000000080000f9a <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000f9a:	7139                	addi	sp,sp,-64
    80000f9c:	fc06                	sd	ra,56(sp)
    80000f9e:	f822                	sd	s0,48(sp)
    80000fa0:	f426                	sd	s1,40(sp)
    80000fa2:	f04a                	sd	s2,32(sp)
    80000fa4:	ec4e                	sd	s3,24(sp)
    80000fa6:	e852                	sd	s4,16(sp)
    80000fa8:	e456                	sd	s5,8(sp)
    80000faa:	e05a                	sd	s6,0(sp)
    80000fac:	0080                	addi	s0,sp,64
    80000fae:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb0:	00008497          	auipc	s1,0x8
    80000fb4:	4f048493          	addi	s1,s1,1264 # 800094a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000fb8:	8b26                	mv	s6,s1
    80000fba:	04fa5937          	lui	s2,0x4fa5
    80000fbe:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000fc2:	0932                	slli	s2,s2,0xc
    80000fc4:	fa590913          	addi	s2,s2,-91
    80000fc8:	0932                	slli	s2,s2,0xc
    80000fca:	fa590913          	addi	s2,s2,-91
    80000fce:	0932                	slli	s2,s2,0xc
    80000fd0:	fa590913          	addi	s2,s2,-91
    80000fd4:	040009b7          	lui	s3,0x4000
    80000fd8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000fda:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fdc:	0000ea97          	auipc	s5,0xe
    80000fe0:	ec4a8a93          	addi	s5,s5,-316 # 8000eea0 <tickslock>
    char *pa = kalloc();
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	1ee080e7          	jalr	494(ra) # 800001d2 <kalloc>
    80000fec:	862a                	mv	a2,a0
    if(pa == 0)
    80000fee:	c121                	beqz	a0,8000102e <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000ff0:	416485b3          	sub	a1,s1,s6
    80000ff4:	858d                	srai	a1,a1,0x3
    80000ff6:	032585b3          	mul	a1,a1,s2
    80000ffa:	2585                	addiw	a1,a1,1
    80000ffc:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001000:	4719                	li	a4,6
    80001002:	6685                	lui	a3,0x1
    80001004:	40b985b3          	sub	a1,s3,a1
    80001008:	8552                	mv	a0,s4
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	730080e7          	jalr	1840(ra) # 8000073a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001012:	16848493          	addi	s1,s1,360
    80001016:	fd5497e3          	bne	s1,s5,80000fe4 <proc_mapstacks+0x4a>
  }
}
    8000101a:	70e2                	ld	ra,56(sp)
    8000101c:	7442                	ld	s0,48(sp)
    8000101e:	74a2                	ld	s1,40(sp)
    80001020:	7902                	ld	s2,32(sp)
    80001022:	69e2                	ld	s3,24(sp)
    80001024:	6a42                	ld	s4,16(sp)
    80001026:	6aa2                	ld	s5,8(sp)
    80001028:	6b02                	ld	s6,0(sp)
    8000102a:	6121                	addi	sp,sp,64
    8000102c:	8082                	ret
      panic("kalloc");
    8000102e:	00007517          	auipc	a0,0x7
    80001032:	13a50513          	addi	a0,a0,314 # 80008168 <etext+0x168>
    80001036:	00005097          	auipc	ra,0x5
    8000103a:	006080e7          	jalr	6(ra) # 8000603c <panic>

000000008000103e <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    8000103e:	7139                	addi	sp,sp,-64
    80001040:	fc06                	sd	ra,56(sp)
    80001042:	f822                	sd	s0,48(sp)
    80001044:	f426                	sd	s1,40(sp)
    80001046:	f04a                	sd	s2,32(sp)
    80001048:	ec4e                	sd	s3,24(sp)
    8000104a:	e852                	sd	s4,16(sp)
    8000104c:	e456                	sd	s5,8(sp)
    8000104e:	e05a                	sd	s6,0(sp)
    80001050:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001052:	00007597          	auipc	a1,0x7
    80001056:	11e58593          	addi	a1,a1,286 # 80008170 <etext+0x170>
    8000105a:	00008517          	auipc	a0,0x8
    8000105e:	01650513          	addi	a0,a0,22 # 80009070 <pid_lock>
    80001062:	00005097          	auipc	ra,0x5
    80001066:	4c4080e7          	jalr	1220(ra) # 80006526 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000106a:	00007597          	auipc	a1,0x7
    8000106e:	10e58593          	addi	a1,a1,270 # 80008178 <etext+0x178>
    80001072:	00008517          	auipc	a0,0x8
    80001076:	01650513          	addi	a0,a0,22 # 80009088 <wait_lock>
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	4ac080e7          	jalr	1196(ra) # 80006526 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001082:	00008497          	auipc	s1,0x8
    80001086:	41e48493          	addi	s1,s1,1054 # 800094a0 <proc>
      initlock(&p->lock, "proc");
    8000108a:	00007b17          	auipc	s6,0x7
    8000108e:	0feb0b13          	addi	s6,s6,254 # 80008188 <etext+0x188>
      p->kstack = KSTACK((int) (p - proc));
    80001092:	8aa6                	mv	s5,s1
    80001094:	04fa5937          	lui	s2,0x4fa5
    80001098:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    8000109c:	0932                	slli	s2,s2,0xc
    8000109e:	fa590913          	addi	s2,s2,-91
    800010a2:	0932                	slli	s2,s2,0xc
    800010a4:	fa590913          	addi	s2,s2,-91
    800010a8:	0932                	slli	s2,s2,0xc
    800010aa:	fa590913          	addi	s2,s2,-91
    800010ae:	040009b7          	lui	s3,0x4000
    800010b2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800010b4:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b6:	0000ea17          	auipc	s4,0xe
    800010ba:	deaa0a13          	addi	s4,s4,-534 # 8000eea0 <tickslock>
      initlock(&p->lock, "proc");
    800010be:	85da                	mv	a1,s6
    800010c0:	8526                	mv	a0,s1
    800010c2:	00005097          	auipc	ra,0x5
    800010c6:	464080e7          	jalr	1124(ra) # 80006526 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    800010ca:	415487b3          	sub	a5,s1,s5
    800010ce:	878d                	srai	a5,a5,0x3
    800010d0:	032787b3          	mul	a5,a5,s2
    800010d4:	2785                	addiw	a5,a5,1
    800010d6:	00d7979b          	slliw	a5,a5,0xd
    800010da:	40f987b3          	sub	a5,s3,a5
    800010de:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800010e0:	16848493          	addi	s1,s1,360
    800010e4:	fd449de3          	bne	s1,s4,800010be <procinit+0x80>
  }
}
    800010e8:	70e2                	ld	ra,56(sp)
    800010ea:	7442                	ld	s0,48(sp)
    800010ec:	74a2                	ld	s1,40(sp)
    800010ee:	7902                	ld	s2,32(sp)
    800010f0:	69e2                	ld	s3,24(sp)
    800010f2:	6a42                	ld	s4,16(sp)
    800010f4:	6aa2                	ld	s5,8(sp)
    800010f6:	6b02                	ld	s6,0(sp)
    800010f8:	6121                	addi	sp,sp,64
    800010fa:	8082                	ret

00000000800010fc <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800010fc:	1141                	addi	sp,sp,-16
    800010fe:	e422                	sd	s0,8(sp)
    80001100:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001102:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001104:	2501                	sext.w	a0,a0
    80001106:	6422                	ld	s0,8(sp)
    80001108:	0141                	addi	sp,sp,16
    8000110a:	8082                	ret

000000008000110c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    8000110c:	1141                	addi	sp,sp,-16
    8000110e:	e422                	sd	s0,8(sp)
    80001110:	0800                	addi	s0,sp,16
    80001112:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001114:	2781                	sext.w	a5,a5
    80001116:	079e                	slli	a5,a5,0x7
  return c;
}
    80001118:	00008517          	auipc	a0,0x8
    8000111c:	f8850513          	addi	a0,a0,-120 # 800090a0 <cpus>
    80001120:	953e                	add	a0,a0,a5
    80001122:	6422                	ld	s0,8(sp)
    80001124:	0141                	addi	sp,sp,16
    80001126:	8082                	ret

0000000080001128 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001128:	1101                	addi	sp,sp,-32
    8000112a:	ec06                	sd	ra,24(sp)
    8000112c:	e822                	sd	s0,16(sp)
    8000112e:	e426                	sd	s1,8(sp)
    80001130:	1000                	addi	s0,sp,32
  push_off();
    80001132:	00005097          	auipc	ra,0x5
    80001136:	438080e7          	jalr	1080(ra) # 8000656a <push_off>
    8000113a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000113c:	2781                	sext.w	a5,a5
    8000113e:	079e                	slli	a5,a5,0x7
    80001140:	00008717          	auipc	a4,0x8
    80001144:	f3070713          	addi	a4,a4,-208 # 80009070 <pid_lock>
    80001148:	97ba                	add	a5,a5,a4
    8000114a:	7b84                	ld	s1,48(a5)
  pop_off();
    8000114c:	00005097          	auipc	ra,0x5
    80001150:	4be080e7          	jalr	1214(ra) # 8000660a <pop_off>
  return p;
}
    80001154:	8526                	mv	a0,s1
    80001156:	60e2                	ld	ra,24(sp)
    80001158:	6442                	ld	s0,16(sp)
    8000115a:	64a2                	ld	s1,8(sp)
    8000115c:	6105                	addi	sp,sp,32
    8000115e:	8082                	ret

0000000080001160 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001160:	1141                	addi	sp,sp,-16
    80001162:	e406                	sd	ra,8(sp)
    80001164:	e022                	sd	s0,0(sp)
    80001166:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001168:	00000097          	auipc	ra,0x0
    8000116c:	fc0080e7          	jalr	-64(ra) # 80001128 <myproc>
    80001170:	00005097          	auipc	ra,0x5
    80001174:	4fa080e7          	jalr	1274(ra) # 8000666a <release>

  if (first) {
    80001178:	00007797          	auipc	a5,0x7
    8000117c:	7787a783          	lw	a5,1912(a5) # 800088f0 <first.1>
    80001180:	eb89                	bnez	a5,80001192 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001182:	00001097          	auipc	ra,0x1
    80001186:	c16080e7          	jalr	-1002(ra) # 80001d98 <usertrapret>
}
    8000118a:	60a2                	ld	ra,8(sp)
    8000118c:	6402                	ld	s0,0(sp)
    8000118e:	0141                	addi	sp,sp,16
    80001190:	8082                	ret
    first = 0;
    80001192:	00007797          	auipc	a5,0x7
    80001196:	7407af23          	sw	zero,1886(a5) # 800088f0 <first.1>
    fsinit(ROOTDEV);
    8000119a:	4505                	li	a0,1
    8000119c:	00002097          	auipc	ra,0x2
    800011a0:	ac2080e7          	jalr	-1342(ra) # 80002c5e <fsinit>
    800011a4:	bff9                	j	80001182 <forkret+0x22>

00000000800011a6 <allocpid>:
allocpid() {
    800011a6:	1101                	addi	sp,sp,-32
    800011a8:	ec06                	sd	ra,24(sp)
    800011aa:	e822                	sd	s0,16(sp)
    800011ac:	e426                	sd	s1,8(sp)
    800011ae:	e04a                	sd	s2,0(sp)
    800011b0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800011b2:	00008917          	auipc	s2,0x8
    800011b6:	ebe90913          	addi	s2,s2,-322 # 80009070 <pid_lock>
    800011ba:	854a                	mv	a0,s2
    800011bc:	00005097          	auipc	ra,0x5
    800011c0:	3fa080e7          	jalr	1018(ra) # 800065b6 <acquire>
  pid = nextpid;
    800011c4:	00007797          	auipc	a5,0x7
    800011c8:	73078793          	addi	a5,a5,1840 # 800088f4 <nextpid>
    800011cc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800011ce:	0014871b          	addiw	a4,s1,1
    800011d2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800011d4:	854a                	mv	a0,s2
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	494080e7          	jalr	1172(ra) # 8000666a <release>
}
    800011de:	8526                	mv	a0,s1
    800011e0:	60e2                	ld	ra,24(sp)
    800011e2:	6442                	ld	s0,16(sp)
    800011e4:	64a2                	ld	s1,8(sp)
    800011e6:	6902                	ld	s2,0(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <proc_pagetable>:
{
    800011ec:	1101                	addi	sp,sp,-32
    800011ee:	ec06                	sd	ra,24(sp)
    800011f0:	e822                	sd	s0,16(sp)
    800011f2:	e426                	sd	s1,8(sp)
    800011f4:	e04a                	sd	s2,0(sp)
    800011f6:	1000                	addi	s0,sp,32
    800011f8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800011fa:	fffff097          	auipc	ra,0xfffff
    800011fe:	73a080e7          	jalr	1850(ra) # 80000934 <uvmcreate>
    80001202:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001204:	c121                	beqz	a0,80001244 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001206:	4729                	li	a4,10
    80001208:	00006697          	auipc	a3,0x6
    8000120c:	df868693          	addi	a3,a3,-520 # 80007000 <_trampoline>
    80001210:	6605                	lui	a2,0x1
    80001212:	040005b7          	lui	a1,0x4000
    80001216:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001218:	05b2                	slli	a1,a1,0xc
    8000121a:	fffff097          	auipc	ra,0xfffff
    8000121e:	496080e7          	jalr	1174(ra) # 800006b0 <mappages>
    80001222:	02054863          	bltz	a0,80001252 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001226:	4719                	li	a4,6
    80001228:	05893683          	ld	a3,88(s2)
    8000122c:	6605                	lui	a2,0x1
    8000122e:	020005b7          	lui	a1,0x2000
    80001232:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001234:	05b6                	slli	a1,a1,0xd
    80001236:	8526                	mv	a0,s1
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	478080e7          	jalr	1144(ra) # 800006b0 <mappages>
    80001240:	02054163          	bltz	a0,80001262 <proc_pagetable+0x76>
}
    80001244:	8526                	mv	a0,s1
    80001246:	60e2                	ld	ra,24(sp)
    80001248:	6442                	ld	s0,16(sp)
    8000124a:	64a2                	ld	s1,8(sp)
    8000124c:	6902                	ld	s2,0(sp)
    8000124e:	6105                	addi	sp,sp,32
    80001250:	8082                	ret
    uvmfree(pagetable, 0);
    80001252:	4581                	li	a1,0
    80001254:	8526                	mv	a0,s1
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	8e4080e7          	jalr	-1820(ra) # 80000b3a <uvmfree>
    return 0;
    8000125e:	4481                	li	s1,0
    80001260:	b7d5                	j	80001244 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001262:	4681                	li	a3,0
    80001264:	4605                	li	a2,1
    80001266:	040005b7          	lui	a1,0x4000
    8000126a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000126c:	05b2                	slli	a1,a1,0xc
    8000126e:	8526                	mv	a0,s1
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	5f0080e7          	jalr	1520(ra) # 80000860 <uvmunmap>
    uvmfree(pagetable, 0);
    80001278:	4581                	li	a1,0
    8000127a:	8526                	mv	a0,s1
    8000127c:	00000097          	auipc	ra,0x0
    80001280:	8be080e7          	jalr	-1858(ra) # 80000b3a <uvmfree>
    return 0;
    80001284:	4481                	li	s1,0
    80001286:	bf7d                	j	80001244 <proc_pagetable+0x58>

0000000080001288 <proc_freepagetable>:
{
    80001288:	1101                	addi	sp,sp,-32
    8000128a:	ec06                	sd	ra,24(sp)
    8000128c:	e822                	sd	s0,16(sp)
    8000128e:	e426                	sd	s1,8(sp)
    80001290:	e04a                	sd	s2,0(sp)
    80001292:	1000                	addi	s0,sp,32
    80001294:	84aa                	mv	s1,a0
    80001296:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001298:	4681                	li	a3,0
    8000129a:	4605                	li	a2,1
    8000129c:	040005b7          	lui	a1,0x4000
    800012a0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012a2:	05b2                	slli	a1,a1,0xc
    800012a4:	fffff097          	auipc	ra,0xfffff
    800012a8:	5bc080e7          	jalr	1468(ra) # 80000860 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800012ac:	4681                	li	a3,0
    800012ae:	4605                	li	a2,1
    800012b0:	020005b7          	lui	a1,0x2000
    800012b4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800012b6:	05b6                	slli	a1,a1,0xd
    800012b8:	8526                	mv	a0,s1
    800012ba:	fffff097          	auipc	ra,0xfffff
    800012be:	5a6080e7          	jalr	1446(ra) # 80000860 <uvmunmap>
  uvmfree(pagetable, sz);
    800012c2:	85ca                	mv	a1,s2
    800012c4:	8526                	mv	a0,s1
    800012c6:	00000097          	auipc	ra,0x0
    800012ca:	874080e7          	jalr	-1932(ra) # 80000b3a <uvmfree>
}
    800012ce:	60e2                	ld	ra,24(sp)
    800012d0:	6442                	ld	s0,16(sp)
    800012d2:	64a2                	ld	s1,8(sp)
    800012d4:	6902                	ld	s2,0(sp)
    800012d6:	6105                	addi	sp,sp,32
    800012d8:	8082                	ret

00000000800012da <freeproc>:
{
    800012da:	1101                	addi	sp,sp,-32
    800012dc:	ec06                	sd	ra,24(sp)
    800012de:	e822                	sd	s0,16(sp)
    800012e0:	e426                	sd	s1,8(sp)
    800012e2:	1000                	addi	s0,sp,32
    800012e4:	84aa                	mv	s1,a0
  if(p->trapframe)
    800012e6:	6d28                	ld	a0,88(a0)
    800012e8:	c509                	beqz	a0,800012f2 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800012ea:	fffff097          	auipc	ra,0xfffff
    800012ee:	d32080e7          	jalr	-718(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800012f2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800012f6:	68a8                	ld	a0,80(s1)
    800012f8:	c511                	beqz	a0,80001304 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800012fa:	64ac                	ld	a1,72(s1)
    800012fc:	00000097          	auipc	ra,0x0
    80001300:	f8c080e7          	jalr	-116(ra) # 80001288 <proc_freepagetable>
  p->pagetable = 0;
    80001304:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001308:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000130c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001310:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001314:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001318:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000131c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001320:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001324:	0004ac23          	sw	zero,24(s1)
}
    80001328:	60e2                	ld	ra,24(sp)
    8000132a:	6442                	ld	s0,16(sp)
    8000132c:	64a2                	ld	s1,8(sp)
    8000132e:	6105                	addi	sp,sp,32
    80001330:	8082                	ret

0000000080001332 <allocproc>:
{
    80001332:	1101                	addi	sp,sp,-32
    80001334:	ec06                	sd	ra,24(sp)
    80001336:	e822                	sd	s0,16(sp)
    80001338:	e426                	sd	s1,8(sp)
    8000133a:	e04a                	sd	s2,0(sp)
    8000133c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000133e:	00008497          	auipc	s1,0x8
    80001342:	16248493          	addi	s1,s1,354 # 800094a0 <proc>
    80001346:	0000e917          	auipc	s2,0xe
    8000134a:	b5a90913          	addi	s2,s2,-1190 # 8000eea0 <tickslock>
    acquire(&p->lock);
    8000134e:	8526                	mv	a0,s1
    80001350:	00005097          	auipc	ra,0x5
    80001354:	266080e7          	jalr	614(ra) # 800065b6 <acquire>
    if(p->state == UNUSED) {
    80001358:	4c9c                	lw	a5,24(s1)
    8000135a:	cf81                	beqz	a5,80001372 <allocproc+0x40>
      release(&p->lock);
    8000135c:	8526                	mv	a0,s1
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	30c080e7          	jalr	780(ra) # 8000666a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001366:	16848493          	addi	s1,s1,360
    8000136a:	ff2492e3          	bne	s1,s2,8000134e <allocproc+0x1c>
  return 0;
    8000136e:	4481                	li	s1,0
    80001370:	a889                	j	800013c2 <allocproc+0x90>
  p->pid = allocpid();
    80001372:	00000097          	auipc	ra,0x0
    80001376:	e34080e7          	jalr	-460(ra) # 800011a6 <allocpid>
    8000137a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000137c:	4785                	li	a5,1
    8000137e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001380:	fffff097          	auipc	ra,0xfffff
    80001384:	e52080e7          	jalr	-430(ra) # 800001d2 <kalloc>
    80001388:	892a                	mv	s2,a0
    8000138a:	eca8                	sd	a0,88(s1)
    8000138c:	c131                	beqz	a0,800013d0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000138e:	8526                	mv	a0,s1
    80001390:	00000097          	auipc	ra,0x0
    80001394:	e5c080e7          	jalr	-420(ra) # 800011ec <proc_pagetable>
    80001398:	892a                	mv	s2,a0
    8000139a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000139c:	c531                	beqz	a0,800013e8 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000139e:	07000613          	li	a2,112
    800013a2:	4581                	li	a1,0
    800013a4:	06048513          	addi	a0,s1,96
    800013a8:	fffff097          	auipc	ra,0xfffff
    800013ac:	f48080e7          	jalr	-184(ra) # 800002f0 <memset>
  p->context.ra = (uint64)forkret;
    800013b0:	00000797          	auipc	a5,0x0
    800013b4:	db078793          	addi	a5,a5,-592 # 80001160 <forkret>
    800013b8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800013ba:	60bc                	ld	a5,64(s1)
    800013bc:	6705                	lui	a4,0x1
    800013be:	97ba                	add	a5,a5,a4
    800013c0:	f4bc                	sd	a5,104(s1)
}
    800013c2:	8526                	mv	a0,s1
    800013c4:	60e2                	ld	ra,24(sp)
    800013c6:	6442                	ld	s0,16(sp)
    800013c8:	64a2                	ld	s1,8(sp)
    800013ca:	6902                	ld	s2,0(sp)
    800013cc:	6105                	addi	sp,sp,32
    800013ce:	8082                	ret
    freeproc(p);
    800013d0:	8526                	mv	a0,s1
    800013d2:	00000097          	auipc	ra,0x0
    800013d6:	f08080e7          	jalr	-248(ra) # 800012da <freeproc>
    release(&p->lock);
    800013da:	8526                	mv	a0,s1
    800013dc:	00005097          	auipc	ra,0x5
    800013e0:	28e080e7          	jalr	654(ra) # 8000666a <release>
    return 0;
    800013e4:	84ca                	mv	s1,s2
    800013e6:	bff1                	j	800013c2 <allocproc+0x90>
    freeproc(p);
    800013e8:	8526                	mv	a0,s1
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	ef0080e7          	jalr	-272(ra) # 800012da <freeproc>
    release(&p->lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	00005097          	auipc	ra,0x5
    800013f8:	276080e7          	jalr	630(ra) # 8000666a <release>
    return 0;
    800013fc:	84ca                	mv	s1,s2
    800013fe:	b7d1                	j	800013c2 <allocproc+0x90>

0000000080001400 <userinit>:
{
    80001400:	1101                	addi	sp,sp,-32
    80001402:	ec06                	sd	ra,24(sp)
    80001404:	e822                	sd	s0,16(sp)
    80001406:	e426                	sd	s1,8(sp)
    80001408:	1000                	addi	s0,sp,32
  p = allocproc();
    8000140a:	00000097          	auipc	ra,0x0
    8000140e:	f28080e7          	jalr	-216(ra) # 80001332 <allocproc>
    80001412:	84aa                	mv	s1,a0
  initproc = p;
    80001414:	00008797          	auipc	a5,0x8
    80001418:	bea7be23          	sd	a0,-1028(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000141c:	03400613          	li	a2,52
    80001420:	00007597          	auipc	a1,0x7
    80001424:	4e058593          	addi	a1,a1,1248 # 80008900 <initcode>
    80001428:	6928                	ld	a0,80(a0)
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	538080e7          	jalr	1336(ra) # 80000962 <uvminit>
  p->sz = PGSIZE;
    80001432:	6785                	lui	a5,0x1
    80001434:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001436:	6cb8                	ld	a4,88(s1)
    80001438:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000143c:	6cb8                	ld	a4,88(s1)
    8000143e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001440:	4641                	li	a2,16
    80001442:	00007597          	auipc	a1,0x7
    80001446:	d4e58593          	addi	a1,a1,-690 # 80008190 <etext+0x190>
    8000144a:	15848513          	addi	a0,s1,344
    8000144e:	fffff097          	auipc	ra,0xfffff
    80001452:	fe4080e7          	jalr	-28(ra) # 80000432 <safestrcpy>
  p->cwd = namei("/");
    80001456:	00007517          	auipc	a0,0x7
    8000145a:	d4a50513          	addi	a0,a0,-694 # 800081a0 <etext+0x1a0>
    8000145e:	00002097          	auipc	ra,0x2
    80001462:	246080e7          	jalr	582(ra) # 800036a4 <namei>
    80001466:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000146a:	478d                	li	a5,3
    8000146c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000146e:	8526                	mv	a0,s1
    80001470:	00005097          	auipc	ra,0x5
    80001474:	1fa080e7          	jalr	506(ra) # 8000666a <release>
}
    80001478:	60e2                	ld	ra,24(sp)
    8000147a:	6442                	ld	s0,16(sp)
    8000147c:	64a2                	ld	s1,8(sp)
    8000147e:	6105                	addi	sp,sp,32
    80001480:	8082                	ret

0000000080001482 <growproc>:
{
    80001482:	1101                	addi	sp,sp,-32
    80001484:	ec06                	sd	ra,24(sp)
    80001486:	e822                	sd	s0,16(sp)
    80001488:	e426                	sd	s1,8(sp)
    8000148a:	e04a                	sd	s2,0(sp)
    8000148c:	1000                	addi	s0,sp,32
    8000148e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001490:	00000097          	auipc	ra,0x0
    80001494:	c98080e7          	jalr	-872(ra) # 80001128 <myproc>
    80001498:	892a                	mv	s2,a0
  sz = p->sz;
    8000149a:	652c                	ld	a1,72(a0)
    8000149c:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800014a0:	00904f63          	bgtz	s1,800014be <growproc+0x3c>
  } else if(n < 0){
    800014a4:	0204cd63          	bltz	s1,800014de <growproc+0x5c>
  p->sz = sz;
    800014a8:	1782                	slli	a5,a5,0x20
    800014aa:	9381                	srli	a5,a5,0x20
    800014ac:	04f93423          	sd	a5,72(s2)
  return 0;
    800014b0:	4501                	li	a0,0
}
    800014b2:	60e2                	ld	ra,24(sp)
    800014b4:	6442                	ld	s0,16(sp)
    800014b6:	64a2                	ld	s1,8(sp)
    800014b8:	6902                	ld	s2,0(sp)
    800014ba:	6105                	addi	sp,sp,32
    800014bc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800014be:	00f4863b          	addw	a2,s1,a5
    800014c2:	1602                	slli	a2,a2,0x20
    800014c4:	9201                	srli	a2,a2,0x20
    800014c6:	1582                	slli	a1,a1,0x20
    800014c8:	9181                	srli	a1,a1,0x20
    800014ca:	6928                	ld	a0,80(a0)
    800014cc:	fffff097          	auipc	ra,0xfffff
    800014d0:	550080e7          	jalr	1360(ra) # 80000a1c <uvmalloc>
    800014d4:	0005079b          	sext.w	a5,a0
    800014d8:	fbe1                	bnez	a5,800014a8 <growproc+0x26>
      return -1;
    800014da:	557d                	li	a0,-1
    800014dc:	bfd9                	j	800014b2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800014de:	00f4863b          	addw	a2,s1,a5
    800014e2:	1602                	slli	a2,a2,0x20
    800014e4:	9201                	srli	a2,a2,0x20
    800014e6:	1582                	slli	a1,a1,0x20
    800014e8:	9181                	srli	a1,a1,0x20
    800014ea:	6928                	ld	a0,80(a0)
    800014ec:	fffff097          	auipc	ra,0xfffff
    800014f0:	4e8080e7          	jalr	1256(ra) # 800009d4 <uvmdealloc>
    800014f4:	0005079b          	sext.w	a5,a0
    800014f8:	bf45                	j	800014a8 <growproc+0x26>

00000000800014fa <fork>:
{
    800014fa:	7139                	addi	sp,sp,-64
    800014fc:	fc06                	sd	ra,56(sp)
    800014fe:	f822                	sd	s0,48(sp)
    80001500:	f04a                	sd	s2,32(sp)
    80001502:	e456                	sd	s5,8(sp)
    80001504:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001506:	00000097          	auipc	ra,0x0
    8000150a:	c22080e7          	jalr	-990(ra) # 80001128 <myproc>
    8000150e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001510:	00000097          	auipc	ra,0x0
    80001514:	e22080e7          	jalr	-478(ra) # 80001332 <allocproc>
    80001518:	12050063          	beqz	a0,80001638 <fork+0x13e>
    8000151c:	e852                	sd	s4,16(sp)
    8000151e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001520:	048ab603          	ld	a2,72(s5)
    80001524:	692c                	ld	a1,80(a0)
    80001526:	050ab503          	ld	a0,80(s5)
    8000152a:	fffff097          	auipc	ra,0xfffff
    8000152e:	64a080e7          	jalr	1610(ra) # 80000b74 <uvmcopy>
    80001532:	04054a63          	bltz	a0,80001586 <fork+0x8c>
    80001536:	f426                	sd	s1,40(sp)
    80001538:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000153a:	048ab783          	ld	a5,72(s5)
    8000153e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001542:	058ab683          	ld	a3,88(s5)
    80001546:	87b6                	mv	a5,a3
    80001548:	058a3703          	ld	a4,88(s4)
    8000154c:	12068693          	addi	a3,a3,288
    80001550:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001554:	6788                	ld	a0,8(a5)
    80001556:	6b8c                	ld	a1,16(a5)
    80001558:	6f90                	ld	a2,24(a5)
    8000155a:	01073023          	sd	a6,0(a4)
    8000155e:	e708                	sd	a0,8(a4)
    80001560:	eb0c                	sd	a1,16(a4)
    80001562:	ef10                	sd	a2,24(a4)
    80001564:	02078793          	addi	a5,a5,32
    80001568:	02070713          	addi	a4,a4,32
    8000156c:	fed792e3          	bne	a5,a3,80001550 <fork+0x56>
  np->trapframe->a0 = 0;
    80001570:	058a3783          	ld	a5,88(s4)
    80001574:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001578:	0d0a8493          	addi	s1,s5,208
    8000157c:	0d0a0913          	addi	s2,s4,208
    80001580:	150a8993          	addi	s3,s5,336
    80001584:	a015                	j	800015a8 <fork+0xae>
    freeproc(np);
    80001586:	8552                	mv	a0,s4
    80001588:	00000097          	auipc	ra,0x0
    8000158c:	d52080e7          	jalr	-686(ra) # 800012da <freeproc>
    release(&np->lock);
    80001590:	8552                	mv	a0,s4
    80001592:	00005097          	auipc	ra,0x5
    80001596:	0d8080e7          	jalr	216(ra) # 8000666a <release>
    return -1;
    8000159a:	597d                	li	s2,-1
    8000159c:	6a42                	ld	s4,16(sp)
    8000159e:	a071                	j	8000162a <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800015a0:	04a1                	addi	s1,s1,8
    800015a2:	0921                	addi	s2,s2,8
    800015a4:	01348b63          	beq	s1,s3,800015ba <fork+0xc0>
    if(p->ofile[i])
    800015a8:	6088                	ld	a0,0(s1)
    800015aa:	d97d                	beqz	a0,800015a0 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800015ac:	00002097          	auipc	ra,0x2
    800015b0:	770080e7          	jalr	1904(ra) # 80003d1c <filedup>
    800015b4:	00a93023          	sd	a0,0(s2)
    800015b8:	b7e5                	j	800015a0 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800015ba:	150ab503          	ld	a0,336(s5)
    800015be:	00002097          	auipc	ra,0x2
    800015c2:	8d6080e7          	jalr	-1834(ra) # 80002e94 <idup>
    800015c6:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800015ca:	4641                	li	a2,16
    800015cc:	158a8593          	addi	a1,s5,344
    800015d0:	158a0513          	addi	a0,s4,344
    800015d4:	fffff097          	auipc	ra,0xfffff
    800015d8:	e5e080e7          	jalr	-418(ra) # 80000432 <safestrcpy>
  pid = np->pid;
    800015dc:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800015e0:	8552                	mv	a0,s4
    800015e2:	00005097          	auipc	ra,0x5
    800015e6:	088080e7          	jalr	136(ra) # 8000666a <release>
  acquire(&wait_lock);
    800015ea:	00008497          	auipc	s1,0x8
    800015ee:	a9e48493          	addi	s1,s1,-1378 # 80009088 <wait_lock>
    800015f2:	8526                	mv	a0,s1
    800015f4:	00005097          	auipc	ra,0x5
    800015f8:	fc2080e7          	jalr	-62(ra) # 800065b6 <acquire>
  np->parent = p;
    800015fc:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001600:	8526                	mv	a0,s1
    80001602:	00005097          	auipc	ra,0x5
    80001606:	068080e7          	jalr	104(ra) # 8000666a <release>
  acquire(&np->lock);
    8000160a:	8552                	mv	a0,s4
    8000160c:	00005097          	auipc	ra,0x5
    80001610:	faa080e7          	jalr	-86(ra) # 800065b6 <acquire>
  np->state = RUNNABLE;
    80001614:	478d                	li	a5,3
    80001616:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000161a:	8552                	mv	a0,s4
    8000161c:	00005097          	auipc	ra,0x5
    80001620:	04e080e7          	jalr	78(ra) # 8000666a <release>
  return pid;
    80001624:	74a2                	ld	s1,40(sp)
    80001626:	69e2                	ld	s3,24(sp)
    80001628:	6a42                	ld	s4,16(sp)
}
    8000162a:	854a                	mv	a0,s2
    8000162c:	70e2                	ld	ra,56(sp)
    8000162e:	7442                	ld	s0,48(sp)
    80001630:	7902                	ld	s2,32(sp)
    80001632:	6aa2                	ld	s5,8(sp)
    80001634:	6121                	addi	sp,sp,64
    80001636:	8082                	ret
    return -1;
    80001638:	597d                	li	s2,-1
    8000163a:	bfc5                	j	8000162a <fork+0x130>

000000008000163c <scheduler>:
{
    8000163c:	7139                	addi	sp,sp,-64
    8000163e:	fc06                	sd	ra,56(sp)
    80001640:	f822                	sd	s0,48(sp)
    80001642:	f426                	sd	s1,40(sp)
    80001644:	f04a                	sd	s2,32(sp)
    80001646:	ec4e                	sd	s3,24(sp)
    80001648:	e852                	sd	s4,16(sp)
    8000164a:	e456                	sd	s5,8(sp)
    8000164c:	e05a                	sd	s6,0(sp)
    8000164e:	0080                	addi	s0,sp,64
    80001650:	8792                	mv	a5,tp
  int id = r_tp();
    80001652:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001654:	00779a93          	slli	s5,a5,0x7
    80001658:	00008717          	auipc	a4,0x8
    8000165c:	a1870713          	addi	a4,a4,-1512 # 80009070 <pid_lock>
    80001660:	9756                	add	a4,a4,s5
    80001662:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001666:	00008717          	auipc	a4,0x8
    8000166a:	a4270713          	addi	a4,a4,-1470 # 800090a8 <cpus+0x8>
    8000166e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001670:	498d                	li	s3,3
        p->state = RUNNING;
    80001672:	4b11                	li	s6,4
        c->proc = p;
    80001674:	079e                	slli	a5,a5,0x7
    80001676:	00008a17          	auipc	s4,0x8
    8000167a:	9faa0a13          	addi	s4,s4,-1542 # 80009070 <pid_lock>
    8000167e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001680:	0000e917          	auipc	s2,0xe
    80001684:	82090913          	addi	s2,s2,-2016 # 8000eea0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001688:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000168c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001690:	10079073          	csrw	sstatus,a5
    80001694:	00008497          	auipc	s1,0x8
    80001698:	e0c48493          	addi	s1,s1,-500 # 800094a0 <proc>
    8000169c:	a811                	j	800016b0 <scheduler+0x74>
      release(&p->lock);
    8000169e:	8526                	mv	a0,s1
    800016a0:	00005097          	auipc	ra,0x5
    800016a4:	fca080e7          	jalr	-54(ra) # 8000666a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800016a8:	16848493          	addi	s1,s1,360
    800016ac:	fd248ee3          	beq	s1,s2,80001688 <scheduler+0x4c>
      acquire(&p->lock);
    800016b0:	8526                	mv	a0,s1
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	f04080e7          	jalr	-252(ra) # 800065b6 <acquire>
      if(p->state == RUNNABLE) {
    800016ba:	4c9c                	lw	a5,24(s1)
    800016bc:	ff3791e3          	bne	a5,s3,8000169e <scheduler+0x62>
        p->state = RUNNING;
    800016c0:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800016c4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800016c8:	06048593          	addi	a1,s1,96
    800016cc:	8556                	mv	a0,s5
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	620080e7          	jalr	1568(ra) # 80001cee <swtch>
        c->proc = 0;
    800016d6:	020a3823          	sd	zero,48(s4)
    800016da:	b7d1                	j	8000169e <scheduler+0x62>

00000000800016dc <sched>:
{
    800016dc:	7179                	addi	sp,sp,-48
    800016de:	f406                	sd	ra,40(sp)
    800016e0:	f022                	sd	s0,32(sp)
    800016e2:	ec26                	sd	s1,24(sp)
    800016e4:	e84a                	sd	s2,16(sp)
    800016e6:	e44e                	sd	s3,8(sp)
    800016e8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800016ea:	00000097          	auipc	ra,0x0
    800016ee:	a3e080e7          	jalr	-1474(ra) # 80001128 <myproc>
    800016f2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800016f4:	00005097          	auipc	ra,0x5
    800016f8:	e48080e7          	jalr	-440(ra) # 8000653c <holding>
    800016fc:	c93d                	beqz	a0,80001772 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800016fe:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001700:	2781                	sext.w	a5,a5
    80001702:	079e                	slli	a5,a5,0x7
    80001704:	00008717          	auipc	a4,0x8
    80001708:	96c70713          	addi	a4,a4,-1684 # 80009070 <pid_lock>
    8000170c:	97ba                	add	a5,a5,a4
    8000170e:	0a87a703          	lw	a4,168(a5)
    80001712:	4785                	li	a5,1
    80001714:	06f71763          	bne	a4,a5,80001782 <sched+0xa6>
  if(p->state == RUNNING)
    80001718:	4c98                	lw	a4,24(s1)
    8000171a:	4791                	li	a5,4
    8000171c:	06f70b63          	beq	a4,a5,80001792 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001720:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001724:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001726:	efb5                	bnez	a5,800017a2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001728:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000172a:	00008917          	auipc	s2,0x8
    8000172e:	94690913          	addi	s2,s2,-1722 # 80009070 <pid_lock>
    80001732:	2781                	sext.w	a5,a5
    80001734:	079e                	slli	a5,a5,0x7
    80001736:	97ca                	add	a5,a5,s2
    80001738:	0ac7a983          	lw	s3,172(a5)
    8000173c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000173e:	2781                	sext.w	a5,a5
    80001740:	079e                	slli	a5,a5,0x7
    80001742:	00008597          	auipc	a1,0x8
    80001746:	96658593          	addi	a1,a1,-1690 # 800090a8 <cpus+0x8>
    8000174a:	95be                	add	a1,a1,a5
    8000174c:	06048513          	addi	a0,s1,96
    80001750:	00000097          	auipc	ra,0x0
    80001754:	59e080e7          	jalr	1438(ra) # 80001cee <swtch>
    80001758:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000175a:	2781                	sext.w	a5,a5
    8000175c:	079e                	slli	a5,a5,0x7
    8000175e:	993e                	add	s2,s2,a5
    80001760:	0b392623          	sw	s3,172(s2)
}
    80001764:	70a2                	ld	ra,40(sp)
    80001766:	7402                	ld	s0,32(sp)
    80001768:	64e2                	ld	s1,24(sp)
    8000176a:	6942                	ld	s2,16(sp)
    8000176c:	69a2                	ld	s3,8(sp)
    8000176e:	6145                	addi	sp,sp,48
    80001770:	8082                	ret
    panic("sched p->lock");
    80001772:	00007517          	auipc	a0,0x7
    80001776:	a3650513          	addi	a0,a0,-1482 # 800081a8 <etext+0x1a8>
    8000177a:	00005097          	auipc	ra,0x5
    8000177e:	8c2080e7          	jalr	-1854(ra) # 8000603c <panic>
    panic("sched locks");
    80001782:	00007517          	auipc	a0,0x7
    80001786:	a3650513          	addi	a0,a0,-1482 # 800081b8 <etext+0x1b8>
    8000178a:	00005097          	auipc	ra,0x5
    8000178e:	8b2080e7          	jalr	-1870(ra) # 8000603c <panic>
    panic("sched running");
    80001792:	00007517          	auipc	a0,0x7
    80001796:	a3650513          	addi	a0,a0,-1482 # 800081c8 <etext+0x1c8>
    8000179a:	00005097          	auipc	ra,0x5
    8000179e:	8a2080e7          	jalr	-1886(ra) # 8000603c <panic>
    panic("sched interruptible");
    800017a2:	00007517          	auipc	a0,0x7
    800017a6:	a3650513          	addi	a0,a0,-1482 # 800081d8 <etext+0x1d8>
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	892080e7          	jalr	-1902(ra) # 8000603c <panic>

00000000800017b2 <yield>:
{
    800017b2:	1101                	addi	sp,sp,-32
    800017b4:	ec06                	sd	ra,24(sp)
    800017b6:	e822                	sd	s0,16(sp)
    800017b8:	e426                	sd	s1,8(sp)
    800017ba:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800017bc:	00000097          	auipc	ra,0x0
    800017c0:	96c080e7          	jalr	-1684(ra) # 80001128 <myproc>
    800017c4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017c6:	00005097          	auipc	ra,0x5
    800017ca:	df0080e7          	jalr	-528(ra) # 800065b6 <acquire>
  p->state = RUNNABLE;
    800017ce:	478d                	li	a5,3
    800017d0:	cc9c                	sw	a5,24(s1)
  sched();
    800017d2:	00000097          	auipc	ra,0x0
    800017d6:	f0a080e7          	jalr	-246(ra) # 800016dc <sched>
  release(&p->lock);
    800017da:	8526                	mv	a0,s1
    800017dc:	00005097          	auipc	ra,0x5
    800017e0:	e8e080e7          	jalr	-370(ra) # 8000666a <release>
}
    800017e4:	60e2                	ld	ra,24(sp)
    800017e6:	6442                	ld	s0,16(sp)
    800017e8:	64a2                	ld	s1,8(sp)
    800017ea:	6105                	addi	sp,sp,32
    800017ec:	8082                	ret

00000000800017ee <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800017ee:	7179                	addi	sp,sp,-48
    800017f0:	f406                	sd	ra,40(sp)
    800017f2:	f022                	sd	s0,32(sp)
    800017f4:	ec26                	sd	s1,24(sp)
    800017f6:	e84a                	sd	s2,16(sp)
    800017f8:	e44e                	sd	s3,8(sp)
    800017fa:	1800                	addi	s0,sp,48
    800017fc:	89aa                	mv	s3,a0
    800017fe:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001800:	00000097          	auipc	ra,0x0
    80001804:	928080e7          	jalr	-1752(ra) # 80001128 <myproc>
    80001808:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000180a:	00005097          	auipc	ra,0x5
    8000180e:	dac080e7          	jalr	-596(ra) # 800065b6 <acquire>
  release(lk);
    80001812:	854a                	mv	a0,s2
    80001814:	00005097          	auipc	ra,0x5
    80001818:	e56080e7          	jalr	-426(ra) # 8000666a <release>

  // Go to sleep.
  p->chan = chan;
    8000181c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001820:	4789                	li	a5,2
    80001822:	cc9c                	sw	a5,24(s1)

  sched();
    80001824:	00000097          	auipc	ra,0x0
    80001828:	eb8080e7          	jalr	-328(ra) # 800016dc <sched>

  // Tidy up.
  p->chan = 0;
    8000182c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001830:	8526                	mv	a0,s1
    80001832:	00005097          	auipc	ra,0x5
    80001836:	e38080e7          	jalr	-456(ra) # 8000666a <release>
  acquire(lk);
    8000183a:	854a                	mv	a0,s2
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	d7a080e7          	jalr	-646(ra) # 800065b6 <acquire>
}
    80001844:	70a2                	ld	ra,40(sp)
    80001846:	7402                	ld	s0,32(sp)
    80001848:	64e2                	ld	s1,24(sp)
    8000184a:	6942                	ld	s2,16(sp)
    8000184c:	69a2                	ld	s3,8(sp)
    8000184e:	6145                	addi	sp,sp,48
    80001850:	8082                	ret

0000000080001852 <wait>:
{
    80001852:	715d                	addi	sp,sp,-80
    80001854:	e486                	sd	ra,72(sp)
    80001856:	e0a2                	sd	s0,64(sp)
    80001858:	fc26                	sd	s1,56(sp)
    8000185a:	f84a                	sd	s2,48(sp)
    8000185c:	f44e                	sd	s3,40(sp)
    8000185e:	f052                	sd	s4,32(sp)
    80001860:	ec56                	sd	s5,24(sp)
    80001862:	e85a                	sd	s6,16(sp)
    80001864:	e45e                	sd	s7,8(sp)
    80001866:	e062                	sd	s8,0(sp)
    80001868:	0880                	addi	s0,sp,80
    8000186a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000186c:	00000097          	auipc	ra,0x0
    80001870:	8bc080e7          	jalr	-1860(ra) # 80001128 <myproc>
    80001874:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001876:	00008517          	auipc	a0,0x8
    8000187a:	81250513          	addi	a0,a0,-2030 # 80009088 <wait_lock>
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	d38080e7          	jalr	-712(ra) # 800065b6 <acquire>
    havekids = 0;
    80001886:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001888:	4a15                	li	s4,5
        havekids = 1;
    8000188a:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000188c:	0000d997          	auipc	s3,0xd
    80001890:	61498993          	addi	s3,s3,1556 # 8000eea0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001894:	00007c17          	auipc	s8,0x7
    80001898:	7f4c0c13          	addi	s8,s8,2036 # 80009088 <wait_lock>
    8000189c:	a87d                	j	8000195a <wait+0x108>
          pid = np->pid;
    8000189e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800018a2:	000b0e63          	beqz	s6,800018be <wait+0x6c>
    800018a6:	4691                	li	a3,4
    800018a8:	02c48613          	addi	a2,s1,44
    800018ac:	85da                	mv	a1,s6
    800018ae:	05093503          	ld	a0,80(s2)
    800018b2:	fffff097          	auipc	ra,0xfffff
    800018b6:	508080e7          	jalr	1288(ra) # 80000dba <copyout>
    800018ba:	04054163          	bltz	a0,800018fc <wait+0xaa>
          freeproc(np);
    800018be:	8526                	mv	a0,s1
    800018c0:	00000097          	auipc	ra,0x0
    800018c4:	a1a080e7          	jalr	-1510(ra) # 800012da <freeproc>
          release(&np->lock);
    800018c8:	8526                	mv	a0,s1
    800018ca:	00005097          	auipc	ra,0x5
    800018ce:	da0080e7          	jalr	-608(ra) # 8000666a <release>
          release(&wait_lock);
    800018d2:	00007517          	auipc	a0,0x7
    800018d6:	7b650513          	addi	a0,a0,1974 # 80009088 <wait_lock>
    800018da:	00005097          	auipc	ra,0x5
    800018de:	d90080e7          	jalr	-624(ra) # 8000666a <release>
}
    800018e2:	854e                	mv	a0,s3
    800018e4:	60a6                	ld	ra,72(sp)
    800018e6:	6406                	ld	s0,64(sp)
    800018e8:	74e2                	ld	s1,56(sp)
    800018ea:	7942                	ld	s2,48(sp)
    800018ec:	79a2                	ld	s3,40(sp)
    800018ee:	7a02                	ld	s4,32(sp)
    800018f0:	6ae2                	ld	s5,24(sp)
    800018f2:	6b42                	ld	s6,16(sp)
    800018f4:	6ba2                	ld	s7,8(sp)
    800018f6:	6c02                	ld	s8,0(sp)
    800018f8:	6161                	addi	sp,sp,80
    800018fa:	8082                	ret
            release(&np->lock);
    800018fc:	8526                	mv	a0,s1
    800018fe:	00005097          	auipc	ra,0x5
    80001902:	d6c080e7          	jalr	-660(ra) # 8000666a <release>
            release(&wait_lock);
    80001906:	00007517          	auipc	a0,0x7
    8000190a:	78250513          	addi	a0,a0,1922 # 80009088 <wait_lock>
    8000190e:	00005097          	auipc	ra,0x5
    80001912:	d5c080e7          	jalr	-676(ra) # 8000666a <release>
            return -1;
    80001916:	59fd                	li	s3,-1
    80001918:	b7e9                	j	800018e2 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    8000191a:	16848493          	addi	s1,s1,360
    8000191e:	03348463          	beq	s1,s3,80001946 <wait+0xf4>
      if(np->parent == p){
    80001922:	7c9c                	ld	a5,56(s1)
    80001924:	ff279be3          	bne	a5,s2,8000191a <wait+0xc8>
        acquire(&np->lock);
    80001928:	8526                	mv	a0,s1
    8000192a:	00005097          	auipc	ra,0x5
    8000192e:	c8c080e7          	jalr	-884(ra) # 800065b6 <acquire>
        if(np->state == ZOMBIE){
    80001932:	4c9c                	lw	a5,24(s1)
    80001934:	f74785e3          	beq	a5,s4,8000189e <wait+0x4c>
        release(&np->lock);
    80001938:	8526                	mv	a0,s1
    8000193a:	00005097          	auipc	ra,0x5
    8000193e:	d30080e7          	jalr	-720(ra) # 8000666a <release>
        havekids = 1;
    80001942:	8756                	mv	a4,s5
    80001944:	bfd9                	j	8000191a <wait+0xc8>
    if(!havekids || p->killed){
    80001946:	c305                	beqz	a4,80001966 <wait+0x114>
    80001948:	02892783          	lw	a5,40(s2)
    8000194c:	ef89                	bnez	a5,80001966 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000194e:	85e2                	mv	a1,s8
    80001950:	854a                	mv	a0,s2
    80001952:	00000097          	auipc	ra,0x0
    80001956:	e9c080e7          	jalr	-356(ra) # 800017ee <sleep>
    havekids = 0;
    8000195a:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000195c:	00008497          	auipc	s1,0x8
    80001960:	b4448493          	addi	s1,s1,-1212 # 800094a0 <proc>
    80001964:	bf7d                	j	80001922 <wait+0xd0>
      release(&wait_lock);
    80001966:	00007517          	auipc	a0,0x7
    8000196a:	72250513          	addi	a0,a0,1826 # 80009088 <wait_lock>
    8000196e:	00005097          	auipc	ra,0x5
    80001972:	cfc080e7          	jalr	-772(ra) # 8000666a <release>
      return -1;
    80001976:	59fd                	li	s3,-1
    80001978:	b7ad                	j	800018e2 <wait+0x90>

000000008000197a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000197a:	7139                	addi	sp,sp,-64
    8000197c:	fc06                	sd	ra,56(sp)
    8000197e:	f822                	sd	s0,48(sp)
    80001980:	f426                	sd	s1,40(sp)
    80001982:	f04a                	sd	s2,32(sp)
    80001984:	ec4e                	sd	s3,24(sp)
    80001986:	e852                	sd	s4,16(sp)
    80001988:	e456                	sd	s5,8(sp)
    8000198a:	0080                	addi	s0,sp,64
    8000198c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000198e:	00008497          	auipc	s1,0x8
    80001992:	b1248493          	addi	s1,s1,-1262 # 800094a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001996:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001998:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000199a:	0000d917          	auipc	s2,0xd
    8000199e:	50690913          	addi	s2,s2,1286 # 8000eea0 <tickslock>
    800019a2:	a811                	j	800019b6 <wakeup+0x3c>
      }
      release(&p->lock);
    800019a4:	8526                	mv	a0,s1
    800019a6:	00005097          	auipc	ra,0x5
    800019aa:	cc4080e7          	jalr	-828(ra) # 8000666a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019ae:	16848493          	addi	s1,s1,360
    800019b2:	03248663          	beq	s1,s2,800019de <wakeup+0x64>
    if(p != myproc()){
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	772080e7          	jalr	1906(ra) # 80001128 <myproc>
    800019be:	fea488e3          	beq	s1,a0,800019ae <wakeup+0x34>
      acquire(&p->lock);
    800019c2:	8526                	mv	a0,s1
    800019c4:	00005097          	auipc	ra,0x5
    800019c8:	bf2080e7          	jalr	-1038(ra) # 800065b6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800019cc:	4c9c                	lw	a5,24(s1)
    800019ce:	fd379be3          	bne	a5,s3,800019a4 <wakeup+0x2a>
    800019d2:	709c                	ld	a5,32(s1)
    800019d4:	fd4798e3          	bne	a5,s4,800019a4 <wakeup+0x2a>
        p->state = RUNNABLE;
    800019d8:	0154ac23          	sw	s5,24(s1)
    800019dc:	b7e1                	j	800019a4 <wakeup+0x2a>
    }
  }
}
    800019de:	70e2                	ld	ra,56(sp)
    800019e0:	7442                	ld	s0,48(sp)
    800019e2:	74a2                	ld	s1,40(sp)
    800019e4:	7902                	ld	s2,32(sp)
    800019e6:	69e2                	ld	s3,24(sp)
    800019e8:	6a42                	ld	s4,16(sp)
    800019ea:	6aa2                	ld	s5,8(sp)
    800019ec:	6121                	addi	sp,sp,64
    800019ee:	8082                	ret

00000000800019f0 <reparent>:
{
    800019f0:	7179                	addi	sp,sp,-48
    800019f2:	f406                	sd	ra,40(sp)
    800019f4:	f022                	sd	s0,32(sp)
    800019f6:	ec26                	sd	s1,24(sp)
    800019f8:	e84a                	sd	s2,16(sp)
    800019fa:	e44e                	sd	s3,8(sp)
    800019fc:	e052                	sd	s4,0(sp)
    800019fe:	1800                	addi	s0,sp,48
    80001a00:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a02:	00008497          	auipc	s1,0x8
    80001a06:	a9e48493          	addi	s1,s1,-1378 # 800094a0 <proc>
      pp->parent = initproc;
    80001a0a:	00007a17          	auipc	s4,0x7
    80001a0e:	606a0a13          	addi	s4,s4,1542 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a12:	0000d997          	auipc	s3,0xd
    80001a16:	48e98993          	addi	s3,s3,1166 # 8000eea0 <tickslock>
    80001a1a:	a029                	j	80001a24 <reparent+0x34>
    80001a1c:	16848493          	addi	s1,s1,360
    80001a20:	01348d63          	beq	s1,s3,80001a3a <reparent+0x4a>
    if(pp->parent == p){
    80001a24:	7c9c                	ld	a5,56(s1)
    80001a26:	ff279be3          	bne	a5,s2,80001a1c <reparent+0x2c>
      pp->parent = initproc;
    80001a2a:	000a3503          	ld	a0,0(s4)
    80001a2e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001a30:	00000097          	auipc	ra,0x0
    80001a34:	f4a080e7          	jalr	-182(ra) # 8000197a <wakeup>
    80001a38:	b7d5                	j	80001a1c <reparent+0x2c>
}
    80001a3a:	70a2                	ld	ra,40(sp)
    80001a3c:	7402                	ld	s0,32(sp)
    80001a3e:	64e2                	ld	s1,24(sp)
    80001a40:	6942                	ld	s2,16(sp)
    80001a42:	69a2                	ld	s3,8(sp)
    80001a44:	6a02                	ld	s4,0(sp)
    80001a46:	6145                	addi	sp,sp,48
    80001a48:	8082                	ret

0000000080001a4a <exit>:
{
    80001a4a:	7179                	addi	sp,sp,-48
    80001a4c:	f406                	sd	ra,40(sp)
    80001a4e:	f022                	sd	s0,32(sp)
    80001a50:	ec26                	sd	s1,24(sp)
    80001a52:	e84a                	sd	s2,16(sp)
    80001a54:	e44e                	sd	s3,8(sp)
    80001a56:	e052                	sd	s4,0(sp)
    80001a58:	1800                	addi	s0,sp,48
    80001a5a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001a5c:	fffff097          	auipc	ra,0xfffff
    80001a60:	6cc080e7          	jalr	1740(ra) # 80001128 <myproc>
    80001a64:	89aa                	mv	s3,a0
  if(p == initproc)
    80001a66:	00007797          	auipc	a5,0x7
    80001a6a:	5aa7b783          	ld	a5,1450(a5) # 80009010 <initproc>
    80001a6e:	0d050493          	addi	s1,a0,208
    80001a72:	15050913          	addi	s2,a0,336
    80001a76:	02a79363          	bne	a5,a0,80001a9c <exit+0x52>
    panic("init exiting");
    80001a7a:	00006517          	auipc	a0,0x6
    80001a7e:	77650513          	addi	a0,a0,1910 # 800081f0 <etext+0x1f0>
    80001a82:	00004097          	auipc	ra,0x4
    80001a86:	5ba080e7          	jalr	1466(ra) # 8000603c <panic>
      fileclose(f);
    80001a8a:	00002097          	auipc	ra,0x2
    80001a8e:	2e4080e7          	jalr	740(ra) # 80003d6e <fileclose>
      p->ofile[fd] = 0;
    80001a92:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001a96:	04a1                	addi	s1,s1,8
    80001a98:	01248563          	beq	s1,s2,80001aa2 <exit+0x58>
    if(p->ofile[fd]){
    80001a9c:	6088                	ld	a0,0(s1)
    80001a9e:	f575                	bnez	a0,80001a8a <exit+0x40>
    80001aa0:	bfdd                	j	80001a96 <exit+0x4c>
  begin_op();
    80001aa2:	00002097          	auipc	ra,0x2
    80001aa6:	e02080e7          	jalr	-510(ra) # 800038a4 <begin_op>
  iput(p->cwd);
    80001aaa:	1509b503          	ld	a0,336(s3)
    80001aae:	00001097          	auipc	ra,0x1
    80001ab2:	5e2080e7          	jalr	1506(ra) # 80003090 <iput>
  end_op();
    80001ab6:	00002097          	auipc	ra,0x2
    80001aba:	e68080e7          	jalr	-408(ra) # 8000391e <end_op>
  p->cwd = 0;
    80001abe:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001ac2:	00007497          	auipc	s1,0x7
    80001ac6:	5c648493          	addi	s1,s1,1478 # 80009088 <wait_lock>
    80001aca:	8526                	mv	a0,s1
    80001acc:	00005097          	auipc	ra,0x5
    80001ad0:	aea080e7          	jalr	-1302(ra) # 800065b6 <acquire>
  reparent(p);
    80001ad4:	854e                	mv	a0,s3
    80001ad6:	00000097          	auipc	ra,0x0
    80001ada:	f1a080e7          	jalr	-230(ra) # 800019f0 <reparent>
  wakeup(p->parent);
    80001ade:	0389b503          	ld	a0,56(s3)
    80001ae2:	00000097          	auipc	ra,0x0
    80001ae6:	e98080e7          	jalr	-360(ra) # 8000197a <wakeup>
  acquire(&p->lock);
    80001aea:	854e                	mv	a0,s3
    80001aec:	00005097          	auipc	ra,0x5
    80001af0:	aca080e7          	jalr	-1334(ra) # 800065b6 <acquire>
  p->xstate = status;
    80001af4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001af8:	4795                	li	a5,5
    80001afa:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001afe:	8526                	mv	a0,s1
    80001b00:	00005097          	auipc	ra,0x5
    80001b04:	b6a080e7          	jalr	-1174(ra) # 8000666a <release>
  sched();
    80001b08:	00000097          	auipc	ra,0x0
    80001b0c:	bd4080e7          	jalr	-1068(ra) # 800016dc <sched>
  panic("zombie exit");
    80001b10:	00006517          	auipc	a0,0x6
    80001b14:	6f050513          	addi	a0,a0,1776 # 80008200 <etext+0x200>
    80001b18:	00004097          	auipc	ra,0x4
    80001b1c:	524080e7          	jalr	1316(ra) # 8000603c <panic>

0000000080001b20 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001b20:	7179                	addi	sp,sp,-48
    80001b22:	f406                	sd	ra,40(sp)
    80001b24:	f022                	sd	s0,32(sp)
    80001b26:	ec26                	sd	s1,24(sp)
    80001b28:	e84a                	sd	s2,16(sp)
    80001b2a:	e44e                	sd	s3,8(sp)
    80001b2c:	1800                	addi	s0,sp,48
    80001b2e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001b30:	00008497          	auipc	s1,0x8
    80001b34:	97048493          	addi	s1,s1,-1680 # 800094a0 <proc>
    80001b38:	0000d997          	auipc	s3,0xd
    80001b3c:	36898993          	addi	s3,s3,872 # 8000eea0 <tickslock>
    acquire(&p->lock);
    80001b40:	8526                	mv	a0,s1
    80001b42:	00005097          	auipc	ra,0x5
    80001b46:	a74080e7          	jalr	-1420(ra) # 800065b6 <acquire>
    if(p->pid == pid){
    80001b4a:	589c                	lw	a5,48(s1)
    80001b4c:	01278d63          	beq	a5,s2,80001b66 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001b50:	8526                	mv	a0,s1
    80001b52:	00005097          	auipc	ra,0x5
    80001b56:	b18080e7          	jalr	-1256(ra) # 8000666a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b5a:	16848493          	addi	s1,s1,360
    80001b5e:	ff3491e3          	bne	s1,s3,80001b40 <kill+0x20>
  }
  return -1;
    80001b62:	557d                	li	a0,-1
    80001b64:	a829                	j	80001b7e <kill+0x5e>
      p->killed = 1;
    80001b66:	4785                	li	a5,1
    80001b68:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001b6a:	4c98                	lw	a4,24(s1)
    80001b6c:	4789                	li	a5,2
    80001b6e:	00f70f63          	beq	a4,a5,80001b8c <kill+0x6c>
      release(&p->lock);
    80001b72:	8526                	mv	a0,s1
    80001b74:	00005097          	auipc	ra,0x5
    80001b78:	af6080e7          	jalr	-1290(ra) # 8000666a <release>
      return 0;
    80001b7c:	4501                	li	a0,0
}
    80001b7e:	70a2                	ld	ra,40(sp)
    80001b80:	7402                	ld	s0,32(sp)
    80001b82:	64e2                	ld	s1,24(sp)
    80001b84:	6942                	ld	s2,16(sp)
    80001b86:	69a2                	ld	s3,8(sp)
    80001b88:	6145                	addi	sp,sp,48
    80001b8a:	8082                	ret
        p->state = RUNNABLE;
    80001b8c:	478d                	li	a5,3
    80001b8e:	cc9c                	sw	a5,24(s1)
    80001b90:	b7cd                	j	80001b72 <kill+0x52>

0000000080001b92 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b92:	7179                	addi	sp,sp,-48
    80001b94:	f406                	sd	ra,40(sp)
    80001b96:	f022                	sd	s0,32(sp)
    80001b98:	ec26                	sd	s1,24(sp)
    80001b9a:	e84a                	sd	s2,16(sp)
    80001b9c:	e44e                	sd	s3,8(sp)
    80001b9e:	e052                	sd	s4,0(sp)
    80001ba0:	1800                	addi	s0,sp,48
    80001ba2:	84aa                	mv	s1,a0
    80001ba4:	892e                	mv	s2,a1
    80001ba6:	89b2                	mv	s3,a2
    80001ba8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001baa:	fffff097          	auipc	ra,0xfffff
    80001bae:	57e080e7          	jalr	1406(ra) # 80001128 <myproc>
  if(user_dst){
    80001bb2:	c08d                	beqz	s1,80001bd4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001bb4:	86d2                	mv	a3,s4
    80001bb6:	864e                	mv	a2,s3
    80001bb8:	85ca                	mv	a1,s2
    80001bba:	6928                	ld	a0,80(a0)
    80001bbc:	fffff097          	auipc	ra,0xfffff
    80001bc0:	1fe080e7          	jalr	510(ra) # 80000dba <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001bc4:	70a2                	ld	ra,40(sp)
    80001bc6:	7402                	ld	s0,32(sp)
    80001bc8:	64e2                	ld	s1,24(sp)
    80001bca:	6942                	ld	s2,16(sp)
    80001bcc:	69a2                	ld	s3,8(sp)
    80001bce:	6a02                	ld	s4,0(sp)
    80001bd0:	6145                	addi	sp,sp,48
    80001bd2:	8082                	ret
    memmove((char *)dst, src, len);
    80001bd4:	000a061b          	sext.w	a2,s4
    80001bd8:	85ce                	mv	a1,s3
    80001bda:	854a                	mv	a0,s2
    80001bdc:	ffffe097          	auipc	ra,0xffffe
    80001be0:	770080e7          	jalr	1904(ra) # 8000034c <memmove>
    return 0;
    80001be4:	8526                	mv	a0,s1
    80001be6:	bff9                	j	80001bc4 <either_copyout+0x32>

0000000080001be8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001be8:	7179                	addi	sp,sp,-48
    80001bea:	f406                	sd	ra,40(sp)
    80001bec:	f022                	sd	s0,32(sp)
    80001bee:	ec26                	sd	s1,24(sp)
    80001bf0:	e84a                	sd	s2,16(sp)
    80001bf2:	e44e                	sd	s3,8(sp)
    80001bf4:	e052                	sd	s4,0(sp)
    80001bf6:	1800                	addi	s0,sp,48
    80001bf8:	892a                	mv	s2,a0
    80001bfa:	84ae                	mv	s1,a1
    80001bfc:	89b2                	mv	s3,a2
    80001bfe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c00:	fffff097          	auipc	ra,0xfffff
    80001c04:	528080e7          	jalr	1320(ra) # 80001128 <myproc>
  if(user_src){
    80001c08:	c08d                	beqz	s1,80001c2a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001c0a:	86d2                	mv	a3,s4
    80001c0c:	864e                	mv	a2,s3
    80001c0e:	85ca                	mv	a1,s2
    80001c10:	6928                	ld	a0,80(a0)
    80001c12:	fffff097          	auipc	ra,0xfffff
    80001c16:	05e080e7          	jalr	94(ra) # 80000c70 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001c1a:	70a2                	ld	ra,40(sp)
    80001c1c:	7402                	ld	s0,32(sp)
    80001c1e:	64e2                	ld	s1,24(sp)
    80001c20:	6942                	ld	s2,16(sp)
    80001c22:	69a2                	ld	s3,8(sp)
    80001c24:	6a02                	ld	s4,0(sp)
    80001c26:	6145                	addi	sp,sp,48
    80001c28:	8082                	ret
    memmove(dst, (char*)src, len);
    80001c2a:	000a061b          	sext.w	a2,s4
    80001c2e:	85ce                	mv	a1,s3
    80001c30:	854a                	mv	a0,s2
    80001c32:	ffffe097          	auipc	ra,0xffffe
    80001c36:	71a080e7          	jalr	1818(ra) # 8000034c <memmove>
    return 0;
    80001c3a:	8526                	mv	a0,s1
    80001c3c:	bff9                	j	80001c1a <either_copyin+0x32>

0000000080001c3e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001c3e:	715d                	addi	sp,sp,-80
    80001c40:	e486                	sd	ra,72(sp)
    80001c42:	e0a2                	sd	s0,64(sp)
    80001c44:	fc26                	sd	s1,56(sp)
    80001c46:	f84a                	sd	s2,48(sp)
    80001c48:	f44e                	sd	s3,40(sp)
    80001c4a:	f052                	sd	s4,32(sp)
    80001c4c:	ec56                	sd	s5,24(sp)
    80001c4e:	e85a                	sd	s6,16(sp)
    80001c50:	e45e                	sd	s7,8(sp)
    80001c52:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001c54:	00006517          	auipc	a0,0x6
    80001c58:	65c50513          	addi	a0,a0,1628 # 800082b0 <etext+0x2b0>
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	42a080e7          	jalr	1066(ra) # 80006086 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c64:	00008497          	auipc	s1,0x8
    80001c68:	99448493          	addi	s1,s1,-1644 # 800095f8 <proc+0x158>
    80001c6c:	0000d917          	auipc	s2,0xd
    80001c70:	38c90913          	addi	s2,s2,908 # 8000eff8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c74:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c76:	00006997          	auipc	s3,0x6
    80001c7a:	59a98993          	addi	s3,s3,1434 # 80008210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80001c7e:	00006a97          	auipc	s5,0x6
    80001c82:	59aa8a93          	addi	s5,s5,1434 # 80008218 <etext+0x218>
    printf("\n");
    80001c86:	00006a17          	auipc	s4,0x6
    80001c8a:	62aa0a13          	addi	s4,s4,1578 # 800082b0 <etext+0x2b0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c8e:	00007b97          	auipc	s7,0x7
    80001c92:	b4ab8b93          	addi	s7,s7,-1206 # 800087d8 <states.0>
    80001c96:	a00d                	j	80001cb8 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c98:	ed86a583          	lw	a1,-296(a3)
    80001c9c:	8556                	mv	a0,s5
    80001c9e:	00004097          	auipc	ra,0x4
    80001ca2:	3e8080e7          	jalr	1000(ra) # 80006086 <printf>
    printf("\n");
    80001ca6:	8552                	mv	a0,s4
    80001ca8:	00004097          	auipc	ra,0x4
    80001cac:	3de080e7          	jalr	990(ra) # 80006086 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001cb0:	16848493          	addi	s1,s1,360
    80001cb4:	03248263          	beq	s1,s2,80001cd8 <procdump+0x9a>
    if(p->state == UNUSED)
    80001cb8:	86a6                	mv	a3,s1
    80001cba:	ec04a783          	lw	a5,-320(s1)
    80001cbe:	dbed                	beqz	a5,80001cb0 <procdump+0x72>
      state = "???";
    80001cc0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001cc2:	fcfb6be3          	bltu	s6,a5,80001c98 <procdump+0x5a>
    80001cc6:	02079713          	slli	a4,a5,0x20
    80001cca:	01d75793          	srli	a5,a4,0x1d
    80001cce:	97de                	add	a5,a5,s7
    80001cd0:	6390                	ld	a2,0(a5)
    80001cd2:	f279                	bnez	a2,80001c98 <procdump+0x5a>
      state = "???";
    80001cd4:	864e                	mv	a2,s3
    80001cd6:	b7c9                	j	80001c98 <procdump+0x5a>
  }
}
    80001cd8:	60a6                	ld	ra,72(sp)
    80001cda:	6406                	ld	s0,64(sp)
    80001cdc:	74e2                	ld	s1,56(sp)
    80001cde:	7942                	ld	s2,48(sp)
    80001ce0:	79a2                	ld	s3,40(sp)
    80001ce2:	7a02                	ld	s4,32(sp)
    80001ce4:	6ae2                	ld	s5,24(sp)
    80001ce6:	6b42                	ld	s6,16(sp)
    80001ce8:	6ba2                	ld	s7,8(sp)
    80001cea:	6161                	addi	sp,sp,80
    80001cec:	8082                	ret

0000000080001cee <swtch>:
    80001cee:	00153023          	sd	ra,0(a0)
    80001cf2:	00253423          	sd	sp,8(a0)
    80001cf6:	e900                	sd	s0,16(a0)
    80001cf8:	ed04                	sd	s1,24(a0)
    80001cfa:	03253023          	sd	s2,32(a0)
    80001cfe:	03353423          	sd	s3,40(a0)
    80001d02:	03453823          	sd	s4,48(a0)
    80001d06:	03553c23          	sd	s5,56(a0)
    80001d0a:	05653023          	sd	s6,64(a0)
    80001d0e:	05753423          	sd	s7,72(a0)
    80001d12:	05853823          	sd	s8,80(a0)
    80001d16:	05953c23          	sd	s9,88(a0)
    80001d1a:	07a53023          	sd	s10,96(a0)
    80001d1e:	07b53423          	sd	s11,104(a0)
    80001d22:	0005b083          	ld	ra,0(a1)
    80001d26:	0085b103          	ld	sp,8(a1)
    80001d2a:	6980                	ld	s0,16(a1)
    80001d2c:	6d84                	ld	s1,24(a1)
    80001d2e:	0205b903          	ld	s2,32(a1)
    80001d32:	0285b983          	ld	s3,40(a1)
    80001d36:	0305ba03          	ld	s4,48(a1)
    80001d3a:	0385ba83          	ld	s5,56(a1)
    80001d3e:	0405bb03          	ld	s6,64(a1)
    80001d42:	0485bb83          	ld	s7,72(a1)
    80001d46:	0505bc03          	ld	s8,80(a1)
    80001d4a:	0585bc83          	ld	s9,88(a1)
    80001d4e:	0605bd03          	ld	s10,96(a1)
    80001d52:	0685bd83          	ld	s11,104(a1)
    80001d56:	8082                	ret

0000000080001d58 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001d58:	1141                	addi	sp,sp,-16
    80001d5a:	e406                	sd	ra,8(sp)
    80001d5c:	e022                	sd	s0,0(sp)
    80001d5e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d60:	00006597          	auipc	a1,0x6
    80001d64:	4f058593          	addi	a1,a1,1264 # 80008250 <etext+0x250>
    80001d68:	0000d517          	auipc	a0,0xd
    80001d6c:	13850513          	addi	a0,a0,312 # 8000eea0 <tickslock>
    80001d70:	00004097          	auipc	ra,0x4
    80001d74:	7b6080e7          	jalr	1974(ra) # 80006526 <initlock>
}
    80001d78:	60a2                	ld	ra,8(sp)
    80001d7a:	6402                	ld	s0,0(sp)
    80001d7c:	0141                	addi	sp,sp,16
    80001d7e:	8082                	ret

0000000080001d80 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d80:	1141                	addi	sp,sp,-16
    80001d82:	e422                	sd	s0,8(sp)
    80001d84:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d86:	00003797          	auipc	a5,0x3
    80001d8a:	6ca78793          	addi	a5,a5,1738 # 80005450 <kernelvec>
    80001d8e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d92:	6422                	ld	s0,8(sp)
    80001d94:	0141                	addi	sp,sp,16
    80001d96:	8082                	ret

0000000080001d98 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d98:	1141                	addi	sp,sp,-16
    80001d9a:	e406                	sd	ra,8(sp)
    80001d9c:	e022                	sd	s0,0(sp)
    80001d9e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001da0:	fffff097          	auipc	ra,0xfffff
    80001da4:	388080e7          	jalr	904(ra) # 80001128 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001dac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dae:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001db2:	00005697          	auipc	a3,0x5
    80001db6:	24e68693          	addi	a3,a3,590 # 80007000 <_trampoline>
    80001dba:	00005717          	auipc	a4,0x5
    80001dbe:	24670713          	addi	a4,a4,582 # 80007000 <_trampoline>
    80001dc2:	8f15                	sub	a4,a4,a3
    80001dc4:	040007b7          	lui	a5,0x4000
    80001dc8:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001dca:	07b2                	slli	a5,a5,0xc
    80001dcc:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001dce:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001dd2:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001dd4:	18002673          	csrr	a2,satp
    80001dd8:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001dda:	6d30                	ld	a2,88(a0)
    80001ddc:	6138                	ld	a4,64(a0)
    80001dde:	6585                	lui	a1,0x1
    80001de0:	972e                	add	a4,a4,a1
    80001de2:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001de4:	6d38                	ld	a4,88(a0)
    80001de6:	00000617          	auipc	a2,0x0
    80001dea:	14060613          	addi	a2,a2,320 # 80001f26 <usertrap>
    80001dee:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001df0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001df2:	8612                	mv	a2,tp
    80001df4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df6:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001dfa:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001dfe:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e02:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001e06:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e08:	6f18                	ld	a4,24(a4)
    80001e0a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001e0e:	692c                	ld	a1,80(a0)
    80001e10:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001e12:	00005717          	auipc	a4,0x5
    80001e16:	27e70713          	addi	a4,a4,638 # 80007090 <userret>
    80001e1a:	8f15                	sub	a4,a4,a3
    80001e1c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001e1e:	577d                	li	a4,-1
    80001e20:	177e                	slli	a4,a4,0x3f
    80001e22:	8dd9                	or	a1,a1,a4
    80001e24:	02000537          	lui	a0,0x2000
    80001e28:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001e2a:	0536                	slli	a0,a0,0xd
    80001e2c:	9782                	jalr	a5
}
    80001e2e:	60a2                	ld	ra,8(sp)
    80001e30:	6402                	ld	s0,0(sp)
    80001e32:	0141                	addi	sp,sp,16
    80001e34:	8082                	ret

0000000080001e36 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001e36:	1101                	addi	sp,sp,-32
    80001e38:	ec06                	sd	ra,24(sp)
    80001e3a:	e822                	sd	s0,16(sp)
    80001e3c:	e426                	sd	s1,8(sp)
    80001e3e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e40:	0000d497          	auipc	s1,0xd
    80001e44:	06048493          	addi	s1,s1,96 # 8000eea0 <tickslock>
    80001e48:	8526                	mv	a0,s1
    80001e4a:	00004097          	auipc	ra,0x4
    80001e4e:	76c080e7          	jalr	1900(ra) # 800065b6 <acquire>
  ticks++;
    80001e52:	00007517          	auipc	a0,0x7
    80001e56:	1c650513          	addi	a0,a0,454 # 80009018 <ticks>
    80001e5a:	411c                	lw	a5,0(a0)
    80001e5c:	2785                	addiw	a5,a5,1
    80001e5e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e60:	00000097          	auipc	ra,0x0
    80001e64:	b1a080e7          	jalr	-1254(ra) # 8000197a <wakeup>
  release(&tickslock);
    80001e68:	8526                	mv	a0,s1
    80001e6a:	00005097          	auipc	ra,0x5
    80001e6e:	800080e7          	jalr	-2048(ra) # 8000666a <release>
}
    80001e72:	60e2                	ld	ra,24(sp)
    80001e74:	6442                	ld	s0,16(sp)
    80001e76:	64a2                	ld	s1,8(sp)
    80001e78:	6105                	addi	sp,sp,32
    80001e7a:	8082                	ret

0000000080001e7c <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e7c:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e80:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001e82:	0a07d163          	bgez	a5,80001f24 <devintr+0xa8>
{
    80001e86:	1101                	addi	sp,sp,-32
    80001e88:	ec06                	sd	ra,24(sp)
    80001e8a:	e822                	sd	s0,16(sp)
    80001e8c:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001e8e:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001e92:	46a5                	li	a3,9
    80001e94:	00d70c63          	beq	a4,a3,80001eac <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001e98:	577d                	li	a4,-1
    80001e9a:	177e                	slli	a4,a4,0x3f
    80001e9c:	0705                	addi	a4,a4,1
    return 0;
    80001e9e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001ea0:	06e78163          	beq	a5,a4,80001f02 <devintr+0x86>
  }
}
    80001ea4:	60e2                	ld	ra,24(sp)
    80001ea6:	6442                	ld	s0,16(sp)
    80001ea8:	6105                	addi	sp,sp,32
    80001eaa:	8082                	ret
    80001eac:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001eae:	00003097          	auipc	ra,0x3
    80001eb2:	6ae080e7          	jalr	1710(ra) # 8000555c <plic_claim>
    80001eb6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001eb8:	47a9                	li	a5,10
    80001eba:	00f50963          	beq	a0,a5,80001ecc <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001ebe:	4785                	li	a5,1
    80001ec0:	00f50b63          	beq	a0,a5,80001ed6 <devintr+0x5a>
    return 1;
    80001ec4:	4505                	li	a0,1
    } else if(irq){
    80001ec6:	ec89                	bnez	s1,80001ee0 <devintr+0x64>
    80001ec8:	64a2                	ld	s1,8(sp)
    80001eca:	bfe9                	j	80001ea4 <devintr+0x28>
      uartintr();
    80001ecc:	00004097          	auipc	ra,0x4
    80001ed0:	60a080e7          	jalr	1546(ra) # 800064d6 <uartintr>
    if(irq)
    80001ed4:	a839                	j	80001ef2 <devintr+0x76>
      virtio_disk_intr();
    80001ed6:	00004097          	auipc	ra,0x4
    80001eda:	b5a080e7          	jalr	-1190(ra) # 80005a30 <virtio_disk_intr>
    if(irq)
    80001ede:	a811                	j	80001ef2 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ee0:	85a6                	mv	a1,s1
    80001ee2:	00006517          	auipc	a0,0x6
    80001ee6:	37650513          	addi	a0,a0,886 # 80008258 <etext+0x258>
    80001eea:	00004097          	auipc	ra,0x4
    80001eee:	19c080e7          	jalr	412(ra) # 80006086 <printf>
      plic_complete(irq);
    80001ef2:	8526                	mv	a0,s1
    80001ef4:	00003097          	auipc	ra,0x3
    80001ef8:	68c080e7          	jalr	1676(ra) # 80005580 <plic_complete>
    return 1;
    80001efc:	4505                	li	a0,1
    80001efe:	64a2                	ld	s1,8(sp)
    80001f00:	b755                	j	80001ea4 <devintr+0x28>
    if(cpuid() == 0){
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	1fa080e7          	jalr	506(ra) # 800010fc <cpuid>
    80001f0a:	c901                	beqz	a0,80001f1a <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001f0c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001f10:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001f12:	14479073          	csrw	sip,a5
    return 2;
    80001f16:	4509                	li	a0,2
    80001f18:	b771                	j	80001ea4 <devintr+0x28>
      clockintr();
    80001f1a:	00000097          	auipc	ra,0x0
    80001f1e:	f1c080e7          	jalr	-228(ra) # 80001e36 <clockintr>
    80001f22:	b7ed                	j	80001f0c <devintr+0x90>
}
    80001f24:	8082                	ret

0000000080001f26 <usertrap>:
{
    80001f26:	7139                	addi	sp,sp,-64
    80001f28:	fc06                	sd	ra,56(sp)
    80001f2a:	f822                	sd	s0,48(sp)
    80001f2c:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f2e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001f32:	1007f793          	andi	a5,a5,256
    80001f36:	e7d1                	bnez	a5,80001fc2 <usertrap+0x9c>
    80001f38:	f426                	sd	s1,40(sp)
    80001f3a:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f3c:	00003797          	auipc	a5,0x3
    80001f40:	51478793          	addi	a5,a5,1300 # 80005450 <kernelvec>
    80001f44:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	1e0080e7          	jalr	480(ra) # 80001128 <myproc>
    80001f50:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f52:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f54:	14102773          	csrr	a4,sepc
    80001f58:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f5a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f5e:	47a1                	li	a5,8
    80001f60:	06f70e63          	beq	a4,a5,80001fdc <usertrap+0xb6>
    80001f64:	14202773          	csrr	a4,scause
  } else if(r_scause() == 15) { // 写页面错
    80001f68:	47bd                	li	a5,15
    80001f6a:	1cf71263          	bne	a4,a5,8000212e <usertrap+0x208>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f6e:	14302973          	csrr	s2,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001f72:	77fd                	lui	a5,0xfffff
    80001f74:	00f97933          	and	s2,s2,a5
    if(va >= MAXVA) { // 虚拟地址错
    80001f78:	57fd                	li	a5,-1
    80001f7a:	83e9                	srli	a5,a5,0x1a
    80001f7c:	0b27e363          	bltu	a5,s2,80002022 <usertrap+0xfc>
    if(va > p->sz){ // 虚拟地址超出进程的地址空间
    80001f80:	653c                	ld	a5,72(a0)
    80001f82:	0b27e963          	bltu	a5,s2,80002034 <usertrap+0x10e>
    80001f86:	ec4e                	sd	s3,24(sp)
    if((pte = walk(p->pagetable, va, 0)) == 0) {
    80001f88:	4601                	li	a2,0
    80001f8a:	85ca                	mv	a1,s2
    80001f8c:	6928                	ld	a0,80(a0)
    80001f8e:	ffffe097          	auipc	ra,0xffffe
    80001f92:	63a080e7          	jalr	1594(ra) # 800005c8 <walk>
    80001f96:	89aa                	mv	s3,a0
    80001f98:	c55d                	beqz	a0,80002046 <usertrap+0x120>
    80001f9a:	e852                	sd	s4,16(sp)
    if(((*pte) & PTE_COW) == 0 ||((*pte) & PTE_V) == 0 || ((*pte) & PTE_U) == 0) {
    80001f9c:	00053a03          	ld	s4,0(a0)
    80001fa0:	111a7713          	andi	a4,s4,273
    80001fa4:	11100793          	li	a5,273
    80001fa8:	0af70963          	beq	a4,a5,8000205a <usertrap+0x134>
      printf("usertrap: pte not exist or it's not cow page\n");
    80001fac:	00006517          	auipc	a0,0x6
    80001fb0:	34450513          	addi	a0,a0,836 # 800082f0 <etext+0x2f0>
    80001fb4:	00004097          	auipc	ra,0x4
    80001fb8:	0d2080e7          	jalr	210(ra) # 80006086 <printf>
      goto end;
    80001fbc:	69e2                	ld	s3,24(sp)
    80001fbe:	6a42                	ld	s4,16(sp)
    80001fc0:	a27d                	j	8000216e <usertrap+0x248>
    80001fc2:	f426                	sd	s1,40(sp)
    80001fc4:	f04a                	sd	s2,32(sp)
    80001fc6:	ec4e                	sd	s3,24(sp)
    80001fc8:	e852                	sd	s4,16(sp)
    80001fca:	e456                	sd	s5,8(sp)
    panic("usertrap: not from user mode");
    80001fcc:	00006517          	auipc	a0,0x6
    80001fd0:	2ac50513          	addi	a0,a0,684 # 80008278 <etext+0x278>
    80001fd4:	00004097          	auipc	ra,0x4
    80001fd8:	068080e7          	jalr	104(ra) # 8000603c <panic>
    if(p->killed)
    80001fdc:	551c                	lw	a5,40(a0)
    80001fde:	ef85                	bnez	a5,80002016 <usertrap+0xf0>
    p->trapframe->epc += 4;
    80001fe0:	6cb8                	ld	a4,88(s1)
    80001fe2:	6f1c                	ld	a5,24(a4)
    80001fe4:	0791                	addi	a5,a5,4 # fffffffffffff004 <end+0xffffffff7ffd8dc4>
    80001fe6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ff0:	10079073          	csrw	sstatus,a5
    syscall();
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	3e0080e7          	jalr	992(ra) # 800023d4 <syscall>
  if(p->killed)
    80001ffc:	549c                	lw	a5,40(s1)
    80001ffe:	18079863          	bnez	a5,8000218e <usertrap+0x268>
  usertrapret();
    80002002:	00000097          	auipc	ra,0x0
    80002006:	d96080e7          	jalr	-618(ra) # 80001d98 <usertrapret>
    8000200a:	74a2                	ld	s1,40(sp)
    8000200c:	7902                	ld	s2,32(sp)
}
    8000200e:	70e2                	ld	ra,56(sp)
    80002010:	7442                	ld	s0,48(sp)
    80002012:	6121                	addi	sp,sp,64
    80002014:	8082                	ret
      exit(-1);
    80002016:	557d                	li	a0,-1
    80002018:	00000097          	auipc	ra,0x0
    8000201c:	a32080e7          	jalr	-1486(ra) # 80001a4a <exit>
    80002020:	b7c1                	j	80001fe0 <usertrap+0xba>
      printf("va is larger than MAXVA!\n");
    80002022:	00006517          	auipc	a0,0x6
    80002026:	27650513          	addi	a0,a0,630 # 80008298 <etext+0x298>
    8000202a:	00004097          	auipc	ra,0x4
    8000202e:	05c080e7          	jalr	92(ra) # 80006086 <printf>
      goto end;
    80002032:	aa35                	j	8000216e <usertrap+0x248>
      printf("va is larger than sz!\n");
    80002034:	00006517          	auipc	a0,0x6
    80002038:	28450513          	addi	a0,a0,644 # 800082b8 <etext+0x2b8>
    8000203c:	00004097          	auipc	ra,0x4
    80002040:	04a080e7          	jalr	74(ra) # 80006086 <printf>
      goto end;
    80002044:	a22d                	j	8000216e <usertrap+0x248>
      printf("usertrap(): page not found\n");
    80002046:	00006517          	auipc	a0,0x6
    8000204a:	28a50513          	addi	a0,a0,650 # 800082d0 <etext+0x2d0>
    8000204e:	00004097          	auipc	ra,0x4
    80002052:	038080e7          	jalr	56(ra) # 80006086 <printf>
      goto end;
    80002056:	69e2                	ld	s3,24(sp)
    80002058:	aa19                	j	8000216e <usertrap+0x248>
    acquire_refcnt();
    8000205a:	ffffe097          	auipc	ra,0xffffe
    8000205e:	256080e7          	jalr	598(ra) # 800002b0 <acquire_refcnt>
    uint64 pa = PTE2PA(*pte);
    80002062:	00aa5a13          	srli	s4,s4,0xa
    80002066:	0a32                	slli	s4,s4,0xc
    uint ref = kgetref((void*)pa);
    80002068:	8552                	mv	a0,s4
    8000206a:	ffffe097          	auipc	ra,0xffffe
    8000206e:	1e6080e7          	jalr	486(ra) # 80000250 <kgetref>
    if(ref == 1) { // 引用次数为1，直接使用该页
    80002072:	4785                	li	a5,1
    80002074:	02f51163          	bne	a0,a5,80002096 <usertrap+0x170>
      *pte = ((*pte) & (~PTE_COW)) | PTE_W;
    80002078:	0009b783          	ld	a5,0(s3)
    8000207c:	efb7f793          	andi	a5,a5,-261
    80002080:	0047e793          	ori	a5,a5,4
    80002084:	00f9b023          	sd	a5,0(s3)
    release_refcnt();
    80002088:	ffffe097          	auipc	ra,0xffffe
    8000208c:	248080e7          	jalr	584(ra) # 800002d0 <release_refcnt>
    80002090:	69e2                	ld	s3,24(sp)
    80002092:	6a42                	ld	s4,16(sp)
    80002094:	b7a5                	j	80001ffc <usertrap+0xd6>
    80002096:	e456                	sd	s5,8(sp)
      char* mem = kalloc();
    80002098:	ffffe097          	auipc	ra,0xffffe
    8000209c:	13a080e7          	jalr	314(ra) # 800001d2 <kalloc>
    800020a0:	8aaa                	mv	s5,a0
      if(mem == 0) {
    800020a2:	cd0d                	beqz	a0,800020dc <usertrap+0x1b6>
      memmove(mem, (char*)pa, PGSIZE);
    800020a4:	6605                	lui	a2,0x1
    800020a6:	85d2                	mv	a1,s4
    800020a8:	ffffe097          	auipc	ra,0xffffe
    800020ac:	2a4080e7          	jalr	676(ra) # 8000034c <memmove>
      uint flag = (PTE_FLAGS(*pte) | PTE_W) & (~PTE_COW);
    800020b0:	0009b703          	ld	a4,0(s3)
    800020b4:	2fb77713          	andi	a4,a4,763
      if(mappages(p->pagetable, va, PGSIZE, (uint64)mem, flag) != 0) {
    800020b8:	00476713          	ori	a4,a4,4
    800020bc:	86d6                	mv	a3,s5
    800020be:	6605                	lui	a2,0x1
    800020c0:	85ca                	mv	a1,s2
    800020c2:	68a8                	ld	a0,80(s1)
    800020c4:	ffffe097          	auipc	ra,0xffffe
    800020c8:	5ec080e7          	jalr	1516(ra) # 800006b0 <mappages>
    800020cc:	e915                	bnez	a0,80002100 <usertrap+0x1da>
      kfree((void*)pa); //旧页引用次数减1
    800020ce:	8552                	mv	a0,s4
    800020d0:	ffffe097          	auipc	ra,0xffffe
    800020d4:	f4c080e7          	jalr	-180(ra) # 8000001c <kfree>
    800020d8:	6aa2                	ld	s5,8(sp)
    800020da:	b77d                	j	80002088 <usertrap+0x162>
        printf("usertrap(): memery alloc fault\n");
    800020dc:	00006517          	auipc	a0,0x6
    800020e0:	24450513          	addi	a0,a0,580 # 80008320 <etext+0x320>
    800020e4:	00004097          	auipc	ra,0x4
    800020e8:	fa2080e7          	jalr	-94(ra) # 80006086 <printf>
        p->killed = 1;
    800020ec:	4785                	li	a5,1
    800020ee:	d49c                	sw	a5,40(s1)
        release_refcnt();
    800020f0:	ffffe097          	auipc	ra,0xffffe
    800020f4:	1e0080e7          	jalr	480(ra) # 800002d0 <release_refcnt>
        goto end;
    800020f8:	69e2                	ld	s3,24(sp)
    800020fa:	6a42                	ld	s4,16(sp)
    800020fc:	6aa2                	ld	s5,8(sp)
    800020fe:	bdfd                	j	80001ffc <usertrap+0xd6>
        kfree(mem);
    80002100:	8556                	mv	a0,s5
    80002102:	ffffe097          	auipc	ra,0xffffe
    80002106:	f1a080e7          	jalr	-230(ra) # 8000001c <kfree>
        printf("usertrap(): can not map page\n");
    8000210a:	00006517          	auipc	a0,0x6
    8000210e:	23650513          	addi	a0,a0,566 # 80008340 <etext+0x340>
    80002112:	00004097          	auipc	ra,0x4
    80002116:	f74080e7          	jalr	-140(ra) # 80006086 <printf>
        p->killed = 1;
    8000211a:	4785                	li	a5,1
    8000211c:	d49c                	sw	a5,40(s1)
        release_refcnt();
    8000211e:	ffffe097          	auipc	ra,0xffffe
    80002122:	1b2080e7          	jalr	434(ra) # 800002d0 <release_refcnt>
        goto end;
    80002126:	69e2                	ld	s3,24(sp)
    80002128:	6a42                	ld	s4,16(sp)
    8000212a:	6aa2                	ld	s5,8(sp)
    8000212c:	bdc1                	j	80001ffc <usertrap+0xd6>
  } else if((which_dev = devintr()) != 0){
    8000212e:	00000097          	auipc	ra,0x0
    80002132:	d4e080e7          	jalr	-690(ra) # 80001e7c <devintr>
    80002136:	892a                	mv	s2,a0
    80002138:	c501                	beqz	a0,80002140 <usertrap+0x21a>
  if(p->killed)
    8000213a:	549c                	lw	a5,40(s1)
    8000213c:	c3a9                	beqz	a5,8000217e <usertrap+0x258>
    8000213e:	a81d                	j	80002174 <usertrap+0x24e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002140:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002144:	5890                	lw	a2,48(s1)
    80002146:	00006517          	auipc	a0,0x6
    8000214a:	21a50513          	addi	a0,a0,538 # 80008360 <etext+0x360>
    8000214e:	00004097          	auipc	ra,0x4
    80002152:	f38080e7          	jalr	-200(ra) # 80006086 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002156:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000215a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000215e:	00006517          	auipc	a0,0x6
    80002162:	23250513          	addi	a0,a0,562 # 80008390 <etext+0x390>
    80002166:	00004097          	auipc	ra,0x4
    8000216a:	f20080e7          	jalr	-224(ra) # 80006086 <printf>
    p->killed = 1;
    8000216e:	4785                	li	a5,1
    80002170:	d49c                	sw	a5,40(s1)
    80002172:	4901                	li	s2,0
    exit(-1);
    80002174:	557d                	li	a0,-1
    80002176:	00000097          	auipc	ra,0x0
    8000217a:	8d4080e7          	jalr	-1836(ra) # 80001a4a <exit>
  if(which_dev == 2)
    8000217e:	4789                	li	a5,2
    80002180:	e8f911e3          	bne	s2,a5,80002002 <usertrap+0xdc>
    yield();
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	62e080e7          	jalr	1582(ra) # 800017b2 <yield>
    8000218c:	bd9d                	j	80002002 <usertrap+0xdc>
  if(p->killed)
    8000218e:	4901                	li	s2,0
    80002190:	b7d5                	j	80002174 <usertrap+0x24e>

0000000080002192 <kerneltrap>:
{
    80002192:	7179                	addi	sp,sp,-48
    80002194:	f406                	sd	ra,40(sp)
    80002196:	f022                	sd	s0,32(sp)
    80002198:	ec26                	sd	s1,24(sp)
    8000219a:	e84a                	sd	s2,16(sp)
    8000219c:	e44e                	sd	s3,8(sp)
    8000219e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800021a0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800021a4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800021a8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800021ac:	1004f793          	andi	a5,s1,256
    800021b0:	cb85                	beqz	a5,800021e0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800021b2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800021b6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800021b8:	ef85                	bnez	a5,800021f0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800021ba:	00000097          	auipc	ra,0x0
    800021be:	cc2080e7          	jalr	-830(ra) # 80001e7c <devintr>
    800021c2:	cd1d                	beqz	a0,80002200 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800021c4:	4789                	li	a5,2
    800021c6:	06f50a63          	beq	a0,a5,8000223a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800021ca:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800021ce:	10049073          	csrw	sstatus,s1
}
    800021d2:	70a2                	ld	ra,40(sp)
    800021d4:	7402                	ld	s0,32(sp)
    800021d6:	64e2                	ld	s1,24(sp)
    800021d8:	6942                	ld	s2,16(sp)
    800021da:	69a2                	ld	s3,8(sp)
    800021dc:	6145                	addi	sp,sp,48
    800021de:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800021e0:	00006517          	auipc	a0,0x6
    800021e4:	1d050513          	addi	a0,a0,464 # 800083b0 <etext+0x3b0>
    800021e8:	00004097          	auipc	ra,0x4
    800021ec:	e54080e7          	jalr	-428(ra) # 8000603c <panic>
    panic("kerneltrap: interrupts enabled");
    800021f0:	00006517          	auipc	a0,0x6
    800021f4:	1e850513          	addi	a0,a0,488 # 800083d8 <etext+0x3d8>
    800021f8:	00004097          	auipc	ra,0x4
    800021fc:	e44080e7          	jalr	-444(ra) # 8000603c <panic>
    printf("scause %p\n", scause);
    80002200:	85ce                	mv	a1,s3
    80002202:	00006517          	auipc	a0,0x6
    80002206:	1f650513          	addi	a0,a0,502 # 800083f8 <etext+0x3f8>
    8000220a:	00004097          	auipc	ra,0x4
    8000220e:	e7c080e7          	jalr	-388(ra) # 80006086 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002212:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002216:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000221a:	00006517          	auipc	a0,0x6
    8000221e:	1ee50513          	addi	a0,a0,494 # 80008408 <etext+0x408>
    80002222:	00004097          	auipc	ra,0x4
    80002226:	e64080e7          	jalr	-412(ra) # 80006086 <printf>
    panic("kerneltrap");
    8000222a:	00006517          	auipc	a0,0x6
    8000222e:	1f650513          	addi	a0,a0,502 # 80008420 <etext+0x420>
    80002232:	00004097          	auipc	ra,0x4
    80002236:	e0a080e7          	jalr	-502(ra) # 8000603c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	eee080e7          	jalr	-274(ra) # 80001128 <myproc>
    80002242:	d541                	beqz	a0,800021ca <kerneltrap+0x38>
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	ee4080e7          	jalr	-284(ra) # 80001128 <myproc>
    8000224c:	4d18                	lw	a4,24(a0)
    8000224e:	4791                	li	a5,4
    80002250:	f6f71de3          	bne	a4,a5,800021ca <kerneltrap+0x38>
    yield();
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	55e080e7          	jalr	1374(ra) # 800017b2 <yield>
    8000225c:	b7bd                	j	800021ca <kerneltrap+0x38>

000000008000225e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000225e:	1101                	addi	sp,sp,-32
    80002260:	ec06                	sd	ra,24(sp)
    80002262:	e822                	sd	s0,16(sp)
    80002264:	e426                	sd	s1,8(sp)
    80002266:	1000                	addi	s0,sp,32
    80002268:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	ebe080e7          	jalr	-322(ra) # 80001128 <myproc>
  switch (n) {
    80002272:	4795                	li	a5,5
    80002274:	0497e163          	bltu	a5,s1,800022b6 <argraw+0x58>
    80002278:	048a                	slli	s1,s1,0x2
    8000227a:	00006717          	auipc	a4,0x6
    8000227e:	58e70713          	addi	a4,a4,1422 # 80008808 <states.0+0x30>
    80002282:	94ba                	add	s1,s1,a4
    80002284:	409c                	lw	a5,0(s1)
    80002286:	97ba                	add	a5,a5,a4
    80002288:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000228a:	6d3c                	ld	a5,88(a0)
    8000228c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000228e:	60e2                	ld	ra,24(sp)
    80002290:	6442                	ld	s0,16(sp)
    80002292:	64a2                	ld	s1,8(sp)
    80002294:	6105                	addi	sp,sp,32
    80002296:	8082                	ret
    return p->trapframe->a1;
    80002298:	6d3c                	ld	a5,88(a0)
    8000229a:	7fa8                	ld	a0,120(a5)
    8000229c:	bfcd                	j	8000228e <argraw+0x30>
    return p->trapframe->a2;
    8000229e:	6d3c                	ld	a5,88(a0)
    800022a0:	63c8                	ld	a0,128(a5)
    800022a2:	b7f5                	j	8000228e <argraw+0x30>
    return p->trapframe->a3;
    800022a4:	6d3c                	ld	a5,88(a0)
    800022a6:	67c8                	ld	a0,136(a5)
    800022a8:	b7dd                	j	8000228e <argraw+0x30>
    return p->trapframe->a4;
    800022aa:	6d3c                	ld	a5,88(a0)
    800022ac:	6bc8                	ld	a0,144(a5)
    800022ae:	b7c5                	j	8000228e <argraw+0x30>
    return p->trapframe->a5;
    800022b0:	6d3c                	ld	a5,88(a0)
    800022b2:	6fc8                	ld	a0,152(a5)
    800022b4:	bfe9                	j	8000228e <argraw+0x30>
  panic("argraw");
    800022b6:	00006517          	auipc	a0,0x6
    800022ba:	17a50513          	addi	a0,a0,378 # 80008430 <etext+0x430>
    800022be:	00004097          	auipc	ra,0x4
    800022c2:	d7e080e7          	jalr	-642(ra) # 8000603c <panic>

00000000800022c6 <fetchaddr>:
{
    800022c6:	1101                	addi	sp,sp,-32
    800022c8:	ec06                	sd	ra,24(sp)
    800022ca:	e822                	sd	s0,16(sp)
    800022cc:	e426                	sd	s1,8(sp)
    800022ce:	e04a                	sd	s2,0(sp)
    800022d0:	1000                	addi	s0,sp,32
    800022d2:	84aa                	mv	s1,a0
    800022d4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	e52080e7          	jalr	-430(ra) # 80001128 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800022de:	653c                	ld	a5,72(a0)
    800022e0:	02f4f863          	bgeu	s1,a5,80002310 <fetchaddr+0x4a>
    800022e4:	00848713          	addi	a4,s1,8
    800022e8:	02e7e663          	bltu	a5,a4,80002314 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800022ec:	46a1                	li	a3,8
    800022ee:	8626                	mv	a2,s1
    800022f0:	85ca                	mv	a1,s2
    800022f2:	6928                	ld	a0,80(a0)
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	97c080e7          	jalr	-1668(ra) # 80000c70 <copyin>
    800022fc:	00a03533          	snez	a0,a0
    80002300:	40a00533          	neg	a0,a0
}
    80002304:	60e2                	ld	ra,24(sp)
    80002306:	6442                	ld	s0,16(sp)
    80002308:	64a2                	ld	s1,8(sp)
    8000230a:	6902                	ld	s2,0(sp)
    8000230c:	6105                	addi	sp,sp,32
    8000230e:	8082                	ret
    return -1;
    80002310:	557d                	li	a0,-1
    80002312:	bfcd                	j	80002304 <fetchaddr+0x3e>
    80002314:	557d                	li	a0,-1
    80002316:	b7fd                	j	80002304 <fetchaddr+0x3e>

0000000080002318 <fetchstr>:
{
    80002318:	7179                	addi	sp,sp,-48
    8000231a:	f406                	sd	ra,40(sp)
    8000231c:	f022                	sd	s0,32(sp)
    8000231e:	ec26                	sd	s1,24(sp)
    80002320:	e84a                	sd	s2,16(sp)
    80002322:	e44e                	sd	s3,8(sp)
    80002324:	1800                	addi	s0,sp,48
    80002326:	892a                	mv	s2,a0
    80002328:	84ae                	mv	s1,a1
    8000232a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000232c:	fffff097          	auipc	ra,0xfffff
    80002330:	dfc080e7          	jalr	-516(ra) # 80001128 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002334:	86ce                	mv	a3,s3
    80002336:	864a                	mv	a2,s2
    80002338:	85a6                	mv	a1,s1
    8000233a:	6928                	ld	a0,80(a0)
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	9c2080e7          	jalr	-1598(ra) # 80000cfe <copyinstr>
  if(err < 0)
    80002344:	00054763          	bltz	a0,80002352 <fetchstr+0x3a>
  return strlen(buf);
    80002348:	8526                	mv	a0,s1
    8000234a:	ffffe097          	auipc	ra,0xffffe
    8000234e:	11a080e7          	jalr	282(ra) # 80000464 <strlen>
}
    80002352:	70a2                	ld	ra,40(sp)
    80002354:	7402                	ld	s0,32(sp)
    80002356:	64e2                	ld	s1,24(sp)
    80002358:	6942                	ld	s2,16(sp)
    8000235a:	69a2                	ld	s3,8(sp)
    8000235c:	6145                	addi	sp,sp,48
    8000235e:	8082                	ret

0000000080002360 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002360:	1101                	addi	sp,sp,-32
    80002362:	ec06                	sd	ra,24(sp)
    80002364:	e822                	sd	s0,16(sp)
    80002366:	e426                	sd	s1,8(sp)
    80002368:	1000                	addi	s0,sp,32
    8000236a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000236c:	00000097          	auipc	ra,0x0
    80002370:	ef2080e7          	jalr	-270(ra) # 8000225e <argraw>
    80002374:	c088                	sw	a0,0(s1)
  return 0;
}
    80002376:	4501                	li	a0,0
    80002378:	60e2                	ld	ra,24(sp)
    8000237a:	6442                	ld	s0,16(sp)
    8000237c:	64a2                	ld	s1,8(sp)
    8000237e:	6105                	addi	sp,sp,32
    80002380:	8082                	ret

0000000080002382 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002382:	1101                	addi	sp,sp,-32
    80002384:	ec06                	sd	ra,24(sp)
    80002386:	e822                	sd	s0,16(sp)
    80002388:	e426                	sd	s1,8(sp)
    8000238a:	1000                	addi	s0,sp,32
    8000238c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000238e:	00000097          	auipc	ra,0x0
    80002392:	ed0080e7          	jalr	-304(ra) # 8000225e <argraw>
    80002396:	e088                	sd	a0,0(s1)
  return 0;
}
    80002398:	4501                	li	a0,0
    8000239a:	60e2                	ld	ra,24(sp)
    8000239c:	6442                	ld	s0,16(sp)
    8000239e:	64a2                	ld	s1,8(sp)
    800023a0:	6105                	addi	sp,sp,32
    800023a2:	8082                	ret

00000000800023a4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800023a4:	1101                	addi	sp,sp,-32
    800023a6:	ec06                	sd	ra,24(sp)
    800023a8:	e822                	sd	s0,16(sp)
    800023aa:	e426                	sd	s1,8(sp)
    800023ac:	e04a                	sd	s2,0(sp)
    800023ae:	1000                	addi	s0,sp,32
    800023b0:	84ae                	mv	s1,a1
    800023b2:	8932                	mv	s2,a2
  *ip = argraw(n);
    800023b4:	00000097          	auipc	ra,0x0
    800023b8:	eaa080e7          	jalr	-342(ra) # 8000225e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800023bc:	864a                	mv	a2,s2
    800023be:	85a6                	mv	a1,s1
    800023c0:	00000097          	auipc	ra,0x0
    800023c4:	f58080e7          	jalr	-168(ra) # 80002318 <fetchstr>
}
    800023c8:	60e2                	ld	ra,24(sp)
    800023ca:	6442                	ld	s0,16(sp)
    800023cc:	64a2                	ld	s1,8(sp)
    800023ce:	6902                	ld	s2,0(sp)
    800023d0:	6105                	addi	sp,sp,32
    800023d2:	8082                	ret

00000000800023d4 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800023d4:	1101                	addi	sp,sp,-32
    800023d6:	ec06                	sd	ra,24(sp)
    800023d8:	e822                	sd	s0,16(sp)
    800023da:	e426                	sd	s1,8(sp)
    800023dc:	e04a                	sd	s2,0(sp)
    800023de:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800023e0:	fffff097          	auipc	ra,0xfffff
    800023e4:	d48080e7          	jalr	-696(ra) # 80001128 <myproc>
    800023e8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800023ea:	05853903          	ld	s2,88(a0)
    800023ee:	0a893783          	ld	a5,168(s2)
    800023f2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800023f6:	37fd                	addiw	a5,a5,-1
    800023f8:	4751                	li	a4,20
    800023fa:	00f76f63          	bltu	a4,a5,80002418 <syscall+0x44>
    800023fe:	00369713          	slli	a4,a3,0x3
    80002402:	00006797          	auipc	a5,0x6
    80002406:	41e78793          	addi	a5,a5,1054 # 80008820 <syscalls>
    8000240a:	97ba                	add	a5,a5,a4
    8000240c:	639c                	ld	a5,0(a5)
    8000240e:	c789                	beqz	a5,80002418 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002410:	9782                	jalr	a5
    80002412:	06a93823          	sd	a0,112(s2)
    80002416:	a839                	j	80002434 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002418:	15848613          	addi	a2,s1,344
    8000241c:	588c                	lw	a1,48(s1)
    8000241e:	00006517          	auipc	a0,0x6
    80002422:	01a50513          	addi	a0,a0,26 # 80008438 <etext+0x438>
    80002426:	00004097          	auipc	ra,0x4
    8000242a:	c60080e7          	jalr	-928(ra) # 80006086 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000242e:	6cbc                	ld	a5,88(s1)
    80002430:	577d                	li	a4,-1
    80002432:	fbb8                	sd	a4,112(a5)
  }
}
    80002434:	60e2                	ld	ra,24(sp)
    80002436:	6442                	ld	s0,16(sp)
    80002438:	64a2                	ld	s1,8(sp)
    8000243a:	6902                	ld	s2,0(sp)
    8000243c:	6105                	addi	sp,sp,32
    8000243e:	8082                	ret

0000000080002440 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002440:	1101                	addi	sp,sp,-32
    80002442:	ec06                	sd	ra,24(sp)
    80002444:	e822                	sd	s0,16(sp)
    80002446:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002448:	fec40593          	addi	a1,s0,-20
    8000244c:	4501                	li	a0,0
    8000244e:	00000097          	auipc	ra,0x0
    80002452:	f12080e7          	jalr	-238(ra) # 80002360 <argint>
    return -1;
    80002456:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002458:	00054963          	bltz	a0,8000246a <sys_exit+0x2a>
  exit(n);
    8000245c:	fec42503          	lw	a0,-20(s0)
    80002460:	fffff097          	auipc	ra,0xfffff
    80002464:	5ea080e7          	jalr	1514(ra) # 80001a4a <exit>
  return 0;  // not reached
    80002468:	4781                	li	a5,0
}
    8000246a:	853e                	mv	a0,a5
    8000246c:	60e2                	ld	ra,24(sp)
    8000246e:	6442                	ld	s0,16(sp)
    80002470:	6105                	addi	sp,sp,32
    80002472:	8082                	ret

0000000080002474 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002474:	1141                	addi	sp,sp,-16
    80002476:	e406                	sd	ra,8(sp)
    80002478:	e022                	sd	s0,0(sp)
    8000247a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000247c:	fffff097          	auipc	ra,0xfffff
    80002480:	cac080e7          	jalr	-852(ra) # 80001128 <myproc>
}
    80002484:	5908                	lw	a0,48(a0)
    80002486:	60a2                	ld	ra,8(sp)
    80002488:	6402                	ld	s0,0(sp)
    8000248a:	0141                	addi	sp,sp,16
    8000248c:	8082                	ret

000000008000248e <sys_fork>:

uint64
sys_fork(void)
{
    8000248e:	1141                	addi	sp,sp,-16
    80002490:	e406                	sd	ra,8(sp)
    80002492:	e022                	sd	s0,0(sp)
    80002494:	0800                	addi	s0,sp,16
  return fork();
    80002496:	fffff097          	auipc	ra,0xfffff
    8000249a:	064080e7          	jalr	100(ra) # 800014fa <fork>
}
    8000249e:	60a2                	ld	ra,8(sp)
    800024a0:	6402                	ld	s0,0(sp)
    800024a2:	0141                	addi	sp,sp,16
    800024a4:	8082                	ret

00000000800024a6 <sys_wait>:

uint64
sys_wait(void)
{
    800024a6:	1101                	addi	sp,sp,-32
    800024a8:	ec06                	sd	ra,24(sp)
    800024aa:	e822                	sd	s0,16(sp)
    800024ac:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800024ae:	fe840593          	addi	a1,s0,-24
    800024b2:	4501                	li	a0,0
    800024b4:	00000097          	auipc	ra,0x0
    800024b8:	ece080e7          	jalr	-306(ra) # 80002382 <argaddr>
    800024bc:	87aa                	mv	a5,a0
    return -1;
    800024be:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800024c0:	0007c863          	bltz	a5,800024d0 <sys_wait+0x2a>
  return wait(p);
    800024c4:	fe843503          	ld	a0,-24(s0)
    800024c8:	fffff097          	auipc	ra,0xfffff
    800024cc:	38a080e7          	jalr	906(ra) # 80001852 <wait>
}
    800024d0:	60e2                	ld	ra,24(sp)
    800024d2:	6442                	ld	s0,16(sp)
    800024d4:	6105                	addi	sp,sp,32
    800024d6:	8082                	ret

00000000800024d8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800024d8:	7179                	addi	sp,sp,-48
    800024da:	f406                	sd	ra,40(sp)
    800024dc:	f022                	sd	s0,32(sp)
    800024de:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800024e0:	fdc40593          	addi	a1,s0,-36
    800024e4:	4501                	li	a0,0
    800024e6:	00000097          	auipc	ra,0x0
    800024ea:	e7a080e7          	jalr	-390(ra) # 80002360 <argint>
    800024ee:	87aa                	mv	a5,a0
    return -1;
    800024f0:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800024f2:	0207c263          	bltz	a5,80002516 <sys_sbrk+0x3e>
    800024f6:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800024f8:	fffff097          	auipc	ra,0xfffff
    800024fc:	c30080e7          	jalr	-976(ra) # 80001128 <myproc>
    80002500:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002502:	fdc42503          	lw	a0,-36(s0)
    80002506:	fffff097          	auipc	ra,0xfffff
    8000250a:	f7c080e7          	jalr	-132(ra) # 80001482 <growproc>
    8000250e:	00054863          	bltz	a0,8000251e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002512:	8526                	mv	a0,s1
    80002514:	64e2                	ld	s1,24(sp)
}
    80002516:	70a2                	ld	ra,40(sp)
    80002518:	7402                	ld	s0,32(sp)
    8000251a:	6145                	addi	sp,sp,48
    8000251c:	8082                	ret
    return -1;
    8000251e:	557d                	li	a0,-1
    80002520:	64e2                	ld	s1,24(sp)
    80002522:	bfd5                	j	80002516 <sys_sbrk+0x3e>

0000000080002524 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002524:	7139                	addi	sp,sp,-64
    80002526:	fc06                	sd	ra,56(sp)
    80002528:	f822                	sd	s0,48(sp)
    8000252a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000252c:	fcc40593          	addi	a1,s0,-52
    80002530:	4501                	li	a0,0
    80002532:	00000097          	auipc	ra,0x0
    80002536:	e2e080e7          	jalr	-466(ra) # 80002360 <argint>
    return -1;
    8000253a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000253c:	06054b63          	bltz	a0,800025b2 <sys_sleep+0x8e>
    80002540:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002542:	0000d517          	auipc	a0,0xd
    80002546:	95e50513          	addi	a0,a0,-1698 # 8000eea0 <tickslock>
    8000254a:	00004097          	auipc	ra,0x4
    8000254e:	06c080e7          	jalr	108(ra) # 800065b6 <acquire>
  ticks0 = ticks;
    80002552:	00007917          	auipc	s2,0x7
    80002556:	ac692903          	lw	s2,-1338(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000255a:	fcc42783          	lw	a5,-52(s0)
    8000255e:	c3a1                	beqz	a5,8000259e <sys_sleep+0x7a>
    80002560:	f426                	sd	s1,40(sp)
    80002562:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002564:	0000d997          	auipc	s3,0xd
    80002568:	93c98993          	addi	s3,s3,-1732 # 8000eea0 <tickslock>
    8000256c:	00007497          	auipc	s1,0x7
    80002570:	aac48493          	addi	s1,s1,-1364 # 80009018 <ticks>
    if(myproc()->killed){
    80002574:	fffff097          	auipc	ra,0xfffff
    80002578:	bb4080e7          	jalr	-1100(ra) # 80001128 <myproc>
    8000257c:	551c                	lw	a5,40(a0)
    8000257e:	ef9d                	bnez	a5,800025bc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002580:	85ce                	mv	a1,s3
    80002582:	8526                	mv	a0,s1
    80002584:	fffff097          	auipc	ra,0xfffff
    80002588:	26a080e7          	jalr	618(ra) # 800017ee <sleep>
  while(ticks - ticks0 < n){
    8000258c:	409c                	lw	a5,0(s1)
    8000258e:	412787bb          	subw	a5,a5,s2
    80002592:	fcc42703          	lw	a4,-52(s0)
    80002596:	fce7efe3          	bltu	a5,a4,80002574 <sys_sleep+0x50>
    8000259a:	74a2                	ld	s1,40(sp)
    8000259c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000259e:	0000d517          	auipc	a0,0xd
    800025a2:	90250513          	addi	a0,a0,-1790 # 8000eea0 <tickslock>
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	0c4080e7          	jalr	196(ra) # 8000666a <release>
  return 0;
    800025ae:	4781                	li	a5,0
    800025b0:	7902                	ld	s2,32(sp)
}
    800025b2:	853e                	mv	a0,a5
    800025b4:	70e2                	ld	ra,56(sp)
    800025b6:	7442                	ld	s0,48(sp)
    800025b8:	6121                	addi	sp,sp,64
    800025ba:	8082                	ret
      release(&tickslock);
    800025bc:	0000d517          	auipc	a0,0xd
    800025c0:	8e450513          	addi	a0,a0,-1820 # 8000eea0 <tickslock>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	0a6080e7          	jalr	166(ra) # 8000666a <release>
      return -1;
    800025cc:	57fd                	li	a5,-1
    800025ce:	74a2                	ld	s1,40(sp)
    800025d0:	7902                	ld	s2,32(sp)
    800025d2:	69e2                	ld	s3,24(sp)
    800025d4:	bff9                	j	800025b2 <sys_sleep+0x8e>

00000000800025d6 <sys_kill>:

uint64
sys_kill(void)
{
    800025d6:	1101                	addi	sp,sp,-32
    800025d8:	ec06                	sd	ra,24(sp)
    800025da:	e822                	sd	s0,16(sp)
    800025dc:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800025de:	fec40593          	addi	a1,s0,-20
    800025e2:	4501                	li	a0,0
    800025e4:	00000097          	auipc	ra,0x0
    800025e8:	d7c080e7          	jalr	-644(ra) # 80002360 <argint>
    800025ec:	87aa                	mv	a5,a0
    return -1;
    800025ee:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800025f0:	0007c863          	bltz	a5,80002600 <sys_kill+0x2a>
  return kill(pid);
    800025f4:	fec42503          	lw	a0,-20(s0)
    800025f8:	fffff097          	auipc	ra,0xfffff
    800025fc:	528080e7          	jalr	1320(ra) # 80001b20 <kill>
}
    80002600:	60e2                	ld	ra,24(sp)
    80002602:	6442                	ld	s0,16(sp)
    80002604:	6105                	addi	sp,sp,32
    80002606:	8082                	ret

0000000080002608 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002608:	1101                	addi	sp,sp,-32
    8000260a:	ec06                	sd	ra,24(sp)
    8000260c:	e822                	sd	s0,16(sp)
    8000260e:	e426                	sd	s1,8(sp)
    80002610:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002612:	0000d517          	auipc	a0,0xd
    80002616:	88e50513          	addi	a0,a0,-1906 # 8000eea0 <tickslock>
    8000261a:	00004097          	auipc	ra,0x4
    8000261e:	f9c080e7          	jalr	-100(ra) # 800065b6 <acquire>
  xticks = ticks;
    80002622:	00007497          	auipc	s1,0x7
    80002626:	9f64a483          	lw	s1,-1546(s1) # 80009018 <ticks>
  release(&tickslock);
    8000262a:	0000d517          	auipc	a0,0xd
    8000262e:	87650513          	addi	a0,a0,-1930 # 8000eea0 <tickslock>
    80002632:	00004097          	auipc	ra,0x4
    80002636:	038080e7          	jalr	56(ra) # 8000666a <release>
  return xticks;
}
    8000263a:	02049513          	slli	a0,s1,0x20
    8000263e:	9101                	srli	a0,a0,0x20
    80002640:	60e2                	ld	ra,24(sp)
    80002642:	6442                	ld	s0,16(sp)
    80002644:	64a2                	ld	s1,8(sp)
    80002646:	6105                	addi	sp,sp,32
    80002648:	8082                	ret

000000008000264a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000264a:	7179                	addi	sp,sp,-48
    8000264c:	f406                	sd	ra,40(sp)
    8000264e:	f022                	sd	s0,32(sp)
    80002650:	ec26                	sd	s1,24(sp)
    80002652:	e84a                	sd	s2,16(sp)
    80002654:	e44e                	sd	s3,8(sp)
    80002656:	e052                	sd	s4,0(sp)
    80002658:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000265a:	00006597          	auipc	a1,0x6
    8000265e:	dfe58593          	addi	a1,a1,-514 # 80008458 <etext+0x458>
    80002662:	0000d517          	auipc	a0,0xd
    80002666:	85650513          	addi	a0,a0,-1962 # 8000eeb8 <bcache>
    8000266a:	00004097          	auipc	ra,0x4
    8000266e:	ebc080e7          	jalr	-324(ra) # 80006526 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002672:	00015797          	auipc	a5,0x15
    80002676:	84678793          	addi	a5,a5,-1978 # 80016eb8 <bcache+0x8000>
    8000267a:	00015717          	auipc	a4,0x15
    8000267e:	aa670713          	addi	a4,a4,-1370 # 80017120 <bcache+0x8268>
    80002682:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002686:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000268a:	0000d497          	auipc	s1,0xd
    8000268e:	84648493          	addi	s1,s1,-1978 # 8000eed0 <bcache+0x18>
    b->next = bcache.head.next;
    80002692:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002694:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002696:	00006a17          	auipc	s4,0x6
    8000269a:	dcaa0a13          	addi	s4,s4,-566 # 80008460 <etext+0x460>
    b->next = bcache.head.next;
    8000269e:	2b893783          	ld	a5,696(s2)
    800026a2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800026a4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800026a8:	85d2                	mv	a1,s4
    800026aa:	01048513          	addi	a0,s1,16
    800026ae:	00001097          	auipc	ra,0x1
    800026b2:	4b2080e7          	jalr	1202(ra) # 80003b60 <initsleeplock>
    bcache.head.next->prev = b;
    800026b6:	2b893783          	ld	a5,696(s2)
    800026ba:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800026bc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800026c0:	45848493          	addi	s1,s1,1112
    800026c4:	fd349de3          	bne	s1,s3,8000269e <binit+0x54>
  }
}
    800026c8:	70a2                	ld	ra,40(sp)
    800026ca:	7402                	ld	s0,32(sp)
    800026cc:	64e2                	ld	s1,24(sp)
    800026ce:	6942                	ld	s2,16(sp)
    800026d0:	69a2                	ld	s3,8(sp)
    800026d2:	6a02                	ld	s4,0(sp)
    800026d4:	6145                	addi	sp,sp,48
    800026d6:	8082                	ret

00000000800026d8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800026d8:	7179                	addi	sp,sp,-48
    800026da:	f406                	sd	ra,40(sp)
    800026dc:	f022                	sd	s0,32(sp)
    800026de:	ec26                	sd	s1,24(sp)
    800026e0:	e84a                	sd	s2,16(sp)
    800026e2:	e44e                	sd	s3,8(sp)
    800026e4:	1800                	addi	s0,sp,48
    800026e6:	892a                	mv	s2,a0
    800026e8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800026ea:	0000c517          	auipc	a0,0xc
    800026ee:	7ce50513          	addi	a0,a0,1998 # 8000eeb8 <bcache>
    800026f2:	00004097          	auipc	ra,0x4
    800026f6:	ec4080e7          	jalr	-316(ra) # 800065b6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800026fa:	00015497          	auipc	s1,0x15
    800026fe:	a764b483          	ld	s1,-1418(s1) # 80017170 <bcache+0x82b8>
    80002702:	00015797          	auipc	a5,0x15
    80002706:	a1e78793          	addi	a5,a5,-1506 # 80017120 <bcache+0x8268>
    8000270a:	02f48f63          	beq	s1,a5,80002748 <bread+0x70>
    8000270e:	873e                	mv	a4,a5
    80002710:	a021                	j	80002718 <bread+0x40>
    80002712:	68a4                	ld	s1,80(s1)
    80002714:	02e48a63          	beq	s1,a4,80002748 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002718:	449c                	lw	a5,8(s1)
    8000271a:	ff279ce3          	bne	a5,s2,80002712 <bread+0x3a>
    8000271e:	44dc                	lw	a5,12(s1)
    80002720:	ff3799e3          	bne	a5,s3,80002712 <bread+0x3a>
      b->refcnt++;
    80002724:	40bc                	lw	a5,64(s1)
    80002726:	2785                	addiw	a5,a5,1
    80002728:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000272a:	0000c517          	auipc	a0,0xc
    8000272e:	78e50513          	addi	a0,a0,1934 # 8000eeb8 <bcache>
    80002732:	00004097          	auipc	ra,0x4
    80002736:	f38080e7          	jalr	-200(ra) # 8000666a <release>
      acquiresleep(&b->lock);
    8000273a:	01048513          	addi	a0,s1,16
    8000273e:	00001097          	auipc	ra,0x1
    80002742:	45c080e7          	jalr	1116(ra) # 80003b9a <acquiresleep>
      return b;
    80002746:	a8b9                	j	800027a4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002748:	00015497          	auipc	s1,0x15
    8000274c:	a204b483          	ld	s1,-1504(s1) # 80017168 <bcache+0x82b0>
    80002750:	00015797          	auipc	a5,0x15
    80002754:	9d078793          	addi	a5,a5,-1584 # 80017120 <bcache+0x8268>
    80002758:	00f48863          	beq	s1,a5,80002768 <bread+0x90>
    8000275c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000275e:	40bc                	lw	a5,64(s1)
    80002760:	cf81                	beqz	a5,80002778 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002762:	64a4                	ld	s1,72(s1)
    80002764:	fee49de3          	bne	s1,a4,8000275e <bread+0x86>
  panic("bget: no buffers");
    80002768:	00006517          	auipc	a0,0x6
    8000276c:	d0050513          	addi	a0,a0,-768 # 80008468 <etext+0x468>
    80002770:	00004097          	auipc	ra,0x4
    80002774:	8cc080e7          	jalr	-1844(ra) # 8000603c <panic>
      b->dev = dev;
    80002778:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000277c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002780:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002784:	4785                	li	a5,1
    80002786:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002788:	0000c517          	auipc	a0,0xc
    8000278c:	73050513          	addi	a0,a0,1840 # 8000eeb8 <bcache>
    80002790:	00004097          	auipc	ra,0x4
    80002794:	eda080e7          	jalr	-294(ra) # 8000666a <release>
      acquiresleep(&b->lock);
    80002798:	01048513          	addi	a0,s1,16
    8000279c:	00001097          	auipc	ra,0x1
    800027a0:	3fe080e7          	jalr	1022(ra) # 80003b9a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800027a4:	409c                	lw	a5,0(s1)
    800027a6:	cb89                	beqz	a5,800027b8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800027a8:	8526                	mv	a0,s1
    800027aa:	70a2                	ld	ra,40(sp)
    800027ac:	7402                	ld	s0,32(sp)
    800027ae:	64e2                	ld	s1,24(sp)
    800027b0:	6942                	ld	s2,16(sp)
    800027b2:	69a2                	ld	s3,8(sp)
    800027b4:	6145                	addi	sp,sp,48
    800027b6:	8082                	ret
    virtio_disk_rw(b, 0);
    800027b8:	4581                	li	a1,0
    800027ba:	8526                	mv	a0,s1
    800027bc:	00003097          	auipc	ra,0x3
    800027c0:	fe6080e7          	jalr	-26(ra) # 800057a2 <virtio_disk_rw>
    b->valid = 1;
    800027c4:	4785                	li	a5,1
    800027c6:	c09c                	sw	a5,0(s1)
  return b;
    800027c8:	b7c5                	j	800027a8 <bread+0xd0>

00000000800027ca <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800027ca:	1101                	addi	sp,sp,-32
    800027cc:	ec06                	sd	ra,24(sp)
    800027ce:	e822                	sd	s0,16(sp)
    800027d0:	e426                	sd	s1,8(sp)
    800027d2:	1000                	addi	s0,sp,32
    800027d4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800027d6:	0541                	addi	a0,a0,16
    800027d8:	00001097          	auipc	ra,0x1
    800027dc:	45c080e7          	jalr	1116(ra) # 80003c34 <holdingsleep>
    800027e0:	cd01                	beqz	a0,800027f8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800027e2:	4585                	li	a1,1
    800027e4:	8526                	mv	a0,s1
    800027e6:	00003097          	auipc	ra,0x3
    800027ea:	fbc080e7          	jalr	-68(ra) # 800057a2 <virtio_disk_rw>
}
    800027ee:	60e2                	ld	ra,24(sp)
    800027f0:	6442                	ld	s0,16(sp)
    800027f2:	64a2                	ld	s1,8(sp)
    800027f4:	6105                	addi	sp,sp,32
    800027f6:	8082                	ret
    panic("bwrite");
    800027f8:	00006517          	auipc	a0,0x6
    800027fc:	c8850513          	addi	a0,a0,-888 # 80008480 <etext+0x480>
    80002800:	00004097          	auipc	ra,0x4
    80002804:	83c080e7          	jalr	-1988(ra) # 8000603c <panic>

0000000080002808 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002808:	1101                	addi	sp,sp,-32
    8000280a:	ec06                	sd	ra,24(sp)
    8000280c:	e822                	sd	s0,16(sp)
    8000280e:	e426                	sd	s1,8(sp)
    80002810:	e04a                	sd	s2,0(sp)
    80002812:	1000                	addi	s0,sp,32
    80002814:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002816:	01050913          	addi	s2,a0,16
    8000281a:	854a                	mv	a0,s2
    8000281c:	00001097          	auipc	ra,0x1
    80002820:	418080e7          	jalr	1048(ra) # 80003c34 <holdingsleep>
    80002824:	c925                	beqz	a0,80002894 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002826:	854a                	mv	a0,s2
    80002828:	00001097          	auipc	ra,0x1
    8000282c:	3c8080e7          	jalr	968(ra) # 80003bf0 <releasesleep>

  acquire(&bcache.lock);
    80002830:	0000c517          	auipc	a0,0xc
    80002834:	68850513          	addi	a0,a0,1672 # 8000eeb8 <bcache>
    80002838:	00004097          	auipc	ra,0x4
    8000283c:	d7e080e7          	jalr	-642(ra) # 800065b6 <acquire>
  b->refcnt--;
    80002840:	40bc                	lw	a5,64(s1)
    80002842:	37fd                	addiw	a5,a5,-1
    80002844:	0007871b          	sext.w	a4,a5
    80002848:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000284a:	e71d                	bnez	a4,80002878 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000284c:	68b8                	ld	a4,80(s1)
    8000284e:	64bc                	ld	a5,72(s1)
    80002850:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002852:	68b8                	ld	a4,80(s1)
    80002854:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002856:	00014797          	auipc	a5,0x14
    8000285a:	66278793          	addi	a5,a5,1634 # 80016eb8 <bcache+0x8000>
    8000285e:	2b87b703          	ld	a4,696(a5)
    80002862:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002864:	00015717          	auipc	a4,0x15
    80002868:	8bc70713          	addi	a4,a4,-1860 # 80017120 <bcache+0x8268>
    8000286c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000286e:	2b87b703          	ld	a4,696(a5)
    80002872:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002874:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002878:	0000c517          	auipc	a0,0xc
    8000287c:	64050513          	addi	a0,a0,1600 # 8000eeb8 <bcache>
    80002880:	00004097          	auipc	ra,0x4
    80002884:	dea080e7          	jalr	-534(ra) # 8000666a <release>
}
    80002888:	60e2                	ld	ra,24(sp)
    8000288a:	6442                	ld	s0,16(sp)
    8000288c:	64a2                	ld	s1,8(sp)
    8000288e:	6902                	ld	s2,0(sp)
    80002890:	6105                	addi	sp,sp,32
    80002892:	8082                	ret
    panic("brelse");
    80002894:	00006517          	auipc	a0,0x6
    80002898:	bf450513          	addi	a0,a0,-1036 # 80008488 <etext+0x488>
    8000289c:	00003097          	auipc	ra,0x3
    800028a0:	7a0080e7          	jalr	1952(ra) # 8000603c <panic>

00000000800028a4 <bpin>:

void
bpin(struct buf *b) {
    800028a4:	1101                	addi	sp,sp,-32
    800028a6:	ec06                	sd	ra,24(sp)
    800028a8:	e822                	sd	s0,16(sp)
    800028aa:	e426                	sd	s1,8(sp)
    800028ac:	1000                	addi	s0,sp,32
    800028ae:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800028b0:	0000c517          	auipc	a0,0xc
    800028b4:	60850513          	addi	a0,a0,1544 # 8000eeb8 <bcache>
    800028b8:	00004097          	auipc	ra,0x4
    800028bc:	cfe080e7          	jalr	-770(ra) # 800065b6 <acquire>
  b->refcnt++;
    800028c0:	40bc                	lw	a5,64(s1)
    800028c2:	2785                	addiw	a5,a5,1
    800028c4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800028c6:	0000c517          	auipc	a0,0xc
    800028ca:	5f250513          	addi	a0,a0,1522 # 8000eeb8 <bcache>
    800028ce:	00004097          	auipc	ra,0x4
    800028d2:	d9c080e7          	jalr	-612(ra) # 8000666a <release>
}
    800028d6:	60e2                	ld	ra,24(sp)
    800028d8:	6442                	ld	s0,16(sp)
    800028da:	64a2                	ld	s1,8(sp)
    800028dc:	6105                	addi	sp,sp,32
    800028de:	8082                	ret

00000000800028e0 <bunpin>:

void
bunpin(struct buf *b) {
    800028e0:	1101                	addi	sp,sp,-32
    800028e2:	ec06                	sd	ra,24(sp)
    800028e4:	e822                	sd	s0,16(sp)
    800028e6:	e426                	sd	s1,8(sp)
    800028e8:	1000                	addi	s0,sp,32
    800028ea:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800028ec:	0000c517          	auipc	a0,0xc
    800028f0:	5cc50513          	addi	a0,a0,1484 # 8000eeb8 <bcache>
    800028f4:	00004097          	auipc	ra,0x4
    800028f8:	cc2080e7          	jalr	-830(ra) # 800065b6 <acquire>
  b->refcnt--;
    800028fc:	40bc                	lw	a5,64(s1)
    800028fe:	37fd                	addiw	a5,a5,-1
    80002900:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002902:	0000c517          	auipc	a0,0xc
    80002906:	5b650513          	addi	a0,a0,1462 # 8000eeb8 <bcache>
    8000290a:	00004097          	auipc	ra,0x4
    8000290e:	d60080e7          	jalr	-672(ra) # 8000666a <release>
}
    80002912:	60e2                	ld	ra,24(sp)
    80002914:	6442                	ld	s0,16(sp)
    80002916:	64a2                	ld	s1,8(sp)
    80002918:	6105                	addi	sp,sp,32
    8000291a:	8082                	ret

000000008000291c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000291c:	1101                	addi	sp,sp,-32
    8000291e:	ec06                	sd	ra,24(sp)
    80002920:	e822                	sd	s0,16(sp)
    80002922:	e426                	sd	s1,8(sp)
    80002924:	e04a                	sd	s2,0(sp)
    80002926:	1000                	addi	s0,sp,32
    80002928:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000292a:	00d5d59b          	srliw	a1,a1,0xd
    8000292e:	00015797          	auipc	a5,0x15
    80002932:	c667a783          	lw	a5,-922(a5) # 80017594 <sb+0x1c>
    80002936:	9dbd                	addw	a1,a1,a5
    80002938:	00000097          	auipc	ra,0x0
    8000293c:	da0080e7          	jalr	-608(ra) # 800026d8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002940:	0074f713          	andi	a4,s1,7
    80002944:	4785                	li	a5,1
    80002946:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000294a:	14ce                	slli	s1,s1,0x33
    8000294c:	90d9                	srli	s1,s1,0x36
    8000294e:	00950733          	add	a4,a0,s1
    80002952:	05874703          	lbu	a4,88(a4)
    80002956:	00e7f6b3          	and	a3,a5,a4
    8000295a:	c69d                	beqz	a3,80002988 <bfree+0x6c>
    8000295c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000295e:	94aa                	add	s1,s1,a0
    80002960:	fff7c793          	not	a5,a5
    80002964:	8f7d                	and	a4,a4,a5
    80002966:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000296a:	00001097          	auipc	ra,0x1
    8000296e:	112080e7          	jalr	274(ra) # 80003a7c <log_write>
  brelse(bp);
    80002972:	854a                	mv	a0,s2
    80002974:	00000097          	auipc	ra,0x0
    80002978:	e94080e7          	jalr	-364(ra) # 80002808 <brelse>
}
    8000297c:	60e2                	ld	ra,24(sp)
    8000297e:	6442                	ld	s0,16(sp)
    80002980:	64a2                	ld	s1,8(sp)
    80002982:	6902                	ld	s2,0(sp)
    80002984:	6105                	addi	sp,sp,32
    80002986:	8082                	ret
    panic("freeing free block");
    80002988:	00006517          	auipc	a0,0x6
    8000298c:	b0850513          	addi	a0,a0,-1272 # 80008490 <etext+0x490>
    80002990:	00003097          	auipc	ra,0x3
    80002994:	6ac080e7          	jalr	1708(ra) # 8000603c <panic>

0000000080002998 <balloc>:
{
    80002998:	711d                	addi	sp,sp,-96
    8000299a:	ec86                	sd	ra,88(sp)
    8000299c:	e8a2                	sd	s0,80(sp)
    8000299e:	e4a6                	sd	s1,72(sp)
    800029a0:	e0ca                	sd	s2,64(sp)
    800029a2:	fc4e                	sd	s3,56(sp)
    800029a4:	f852                	sd	s4,48(sp)
    800029a6:	f456                	sd	s5,40(sp)
    800029a8:	f05a                	sd	s6,32(sp)
    800029aa:	ec5e                	sd	s7,24(sp)
    800029ac:	e862                	sd	s8,16(sp)
    800029ae:	e466                	sd	s9,8(sp)
    800029b0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800029b2:	00015797          	auipc	a5,0x15
    800029b6:	bca7a783          	lw	a5,-1078(a5) # 8001757c <sb+0x4>
    800029ba:	cbc1                	beqz	a5,80002a4a <balloc+0xb2>
    800029bc:	8baa                	mv	s7,a0
    800029be:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800029c0:	00015b17          	auipc	s6,0x15
    800029c4:	bb8b0b13          	addi	s6,s6,-1096 # 80017578 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029c8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800029ca:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029cc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800029ce:	6c89                	lui	s9,0x2
    800029d0:	a831                	j	800029ec <balloc+0x54>
    brelse(bp);
    800029d2:	854a                	mv	a0,s2
    800029d4:	00000097          	auipc	ra,0x0
    800029d8:	e34080e7          	jalr	-460(ra) # 80002808 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800029dc:	015c87bb          	addw	a5,s9,s5
    800029e0:	00078a9b          	sext.w	s5,a5
    800029e4:	004b2703          	lw	a4,4(s6)
    800029e8:	06eaf163          	bgeu	s5,a4,80002a4a <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800029ec:	41fad79b          	sraiw	a5,s5,0x1f
    800029f0:	0137d79b          	srliw	a5,a5,0x13
    800029f4:	015787bb          	addw	a5,a5,s5
    800029f8:	40d7d79b          	sraiw	a5,a5,0xd
    800029fc:	01cb2583          	lw	a1,28(s6)
    80002a00:	9dbd                	addw	a1,a1,a5
    80002a02:	855e                	mv	a0,s7
    80002a04:	00000097          	auipc	ra,0x0
    80002a08:	cd4080e7          	jalr	-812(ra) # 800026d8 <bread>
    80002a0c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a0e:	004b2503          	lw	a0,4(s6)
    80002a12:	000a849b          	sext.w	s1,s5
    80002a16:	8762                	mv	a4,s8
    80002a18:	faa4fde3          	bgeu	s1,a0,800029d2 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002a1c:	00777693          	andi	a3,a4,7
    80002a20:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002a24:	41f7579b          	sraiw	a5,a4,0x1f
    80002a28:	01d7d79b          	srliw	a5,a5,0x1d
    80002a2c:	9fb9                	addw	a5,a5,a4
    80002a2e:	4037d79b          	sraiw	a5,a5,0x3
    80002a32:	00f90633          	add	a2,s2,a5
    80002a36:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80002a3a:	00c6f5b3          	and	a1,a3,a2
    80002a3e:	cd91                	beqz	a1,80002a5a <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a40:	2705                	addiw	a4,a4,1
    80002a42:	2485                	addiw	s1,s1,1
    80002a44:	fd471ae3          	bne	a4,s4,80002a18 <balloc+0x80>
    80002a48:	b769                	j	800029d2 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002a4a:	00006517          	auipc	a0,0x6
    80002a4e:	a5e50513          	addi	a0,a0,-1442 # 800084a8 <etext+0x4a8>
    80002a52:	00003097          	auipc	ra,0x3
    80002a56:	5ea080e7          	jalr	1514(ra) # 8000603c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002a5a:	97ca                	add	a5,a5,s2
    80002a5c:	8e55                	or	a2,a2,a3
    80002a5e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002a62:	854a                	mv	a0,s2
    80002a64:	00001097          	auipc	ra,0x1
    80002a68:	018080e7          	jalr	24(ra) # 80003a7c <log_write>
        brelse(bp);
    80002a6c:	854a                	mv	a0,s2
    80002a6e:	00000097          	auipc	ra,0x0
    80002a72:	d9a080e7          	jalr	-614(ra) # 80002808 <brelse>
  bp = bread(dev, bno);
    80002a76:	85a6                	mv	a1,s1
    80002a78:	855e                	mv	a0,s7
    80002a7a:	00000097          	auipc	ra,0x0
    80002a7e:	c5e080e7          	jalr	-930(ra) # 800026d8 <bread>
    80002a82:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002a84:	40000613          	li	a2,1024
    80002a88:	4581                	li	a1,0
    80002a8a:	05850513          	addi	a0,a0,88
    80002a8e:	ffffe097          	auipc	ra,0xffffe
    80002a92:	862080e7          	jalr	-1950(ra) # 800002f0 <memset>
  log_write(bp);
    80002a96:	854a                	mv	a0,s2
    80002a98:	00001097          	auipc	ra,0x1
    80002a9c:	fe4080e7          	jalr	-28(ra) # 80003a7c <log_write>
  brelse(bp);
    80002aa0:	854a                	mv	a0,s2
    80002aa2:	00000097          	auipc	ra,0x0
    80002aa6:	d66080e7          	jalr	-666(ra) # 80002808 <brelse>
}
    80002aaa:	8526                	mv	a0,s1
    80002aac:	60e6                	ld	ra,88(sp)
    80002aae:	6446                	ld	s0,80(sp)
    80002ab0:	64a6                	ld	s1,72(sp)
    80002ab2:	6906                	ld	s2,64(sp)
    80002ab4:	79e2                	ld	s3,56(sp)
    80002ab6:	7a42                	ld	s4,48(sp)
    80002ab8:	7aa2                	ld	s5,40(sp)
    80002aba:	7b02                	ld	s6,32(sp)
    80002abc:	6be2                	ld	s7,24(sp)
    80002abe:	6c42                	ld	s8,16(sp)
    80002ac0:	6ca2                	ld	s9,8(sp)
    80002ac2:	6125                	addi	sp,sp,96
    80002ac4:	8082                	ret

0000000080002ac6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002ac6:	7179                	addi	sp,sp,-48
    80002ac8:	f406                	sd	ra,40(sp)
    80002aca:	f022                	sd	s0,32(sp)
    80002acc:	ec26                	sd	s1,24(sp)
    80002ace:	e84a                	sd	s2,16(sp)
    80002ad0:	e44e                	sd	s3,8(sp)
    80002ad2:	1800                	addi	s0,sp,48
    80002ad4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002ad6:	47ad                	li	a5,11
    80002ad8:	04b7ff63          	bgeu	a5,a1,80002b36 <bmap+0x70>
    80002adc:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002ade:	ff45849b          	addiw	s1,a1,-12
    80002ae2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002ae6:	0ff00793          	li	a5,255
    80002aea:	0ae7e463          	bltu	a5,a4,80002b92 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002aee:	08052583          	lw	a1,128(a0)
    80002af2:	c5b5                	beqz	a1,80002b5e <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002af4:	00092503          	lw	a0,0(s2)
    80002af8:	00000097          	auipc	ra,0x0
    80002afc:	be0080e7          	jalr	-1056(ra) # 800026d8 <bread>
    80002b00:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002b02:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002b06:	02049713          	slli	a4,s1,0x20
    80002b0a:	01e75593          	srli	a1,a4,0x1e
    80002b0e:	00b784b3          	add	s1,a5,a1
    80002b12:	0004a983          	lw	s3,0(s1)
    80002b16:	04098e63          	beqz	s3,80002b72 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002b1a:	8552                	mv	a0,s4
    80002b1c:	00000097          	auipc	ra,0x0
    80002b20:	cec080e7          	jalr	-788(ra) # 80002808 <brelse>
    return addr;
    80002b24:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002b26:	854e                	mv	a0,s3
    80002b28:	70a2                	ld	ra,40(sp)
    80002b2a:	7402                	ld	s0,32(sp)
    80002b2c:	64e2                	ld	s1,24(sp)
    80002b2e:	6942                	ld	s2,16(sp)
    80002b30:	69a2                	ld	s3,8(sp)
    80002b32:	6145                	addi	sp,sp,48
    80002b34:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002b36:	02059793          	slli	a5,a1,0x20
    80002b3a:	01e7d593          	srli	a1,a5,0x1e
    80002b3e:	00b504b3          	add	s1,a0,a1
    80002b42:	0504a983          	lw	s3,80(s1)
    80002b46:	fe0990e3          	bnez	s3,80002b26 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002b4a:	4108                	lw	a0,0(a0)
    80002b4c:	00000097          	auipc	ra,0x0
    80002b50:	e4c080e7          	jalr	-436(ra) # 80002998 <balloc>
    80002b54:	0005099b          	sext.w	s3,a0
    80002b58:	0534a823          	sw	s3,80(s1)
    80002b5c:	b7e9                	j	80002b26 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002b5e:	4108                	lw	a0,0(a0)
    80002b60:	00000097          	auipc	ra,0x0
    80002b64:	e38080e7          	jalr	-456(ra) # 80002998 <balloc>
    80002b68:	0005059b          	sext.w	a1,a0
    80002b6c:	08b92023          	sw	a1,128(s2)
    80002b70:	b751                	j	80002af4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002b72:	00092503          	lw	a0,0(s2)
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	e22080e7          	jalr	-478(ra) # 80002998 <balloc>
    80002b7e:	0005099b          	sext.w	s3,a0
    80002b82:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002b86:	8552                	mv	a0,s4
    80002b88:	00001097          	auipc	ra,0x1
    80002b8c:	ef4080e7          	jalr	-268(ra) # 80003a7c <log_write>
    80002b90:	b769                	j	80002b1a <bmap+0x54>
  panic("bmap: out of range");
    80002b92:	00006517          	auipc	a0,0x6
    80002b96:	92e50513          	addi	a0,a0,-1746 # 800084c0 <etext+0x4c0>
    80002b9a:	00003097          	auipc	ra,0x3
    80002b9e:	4a2080e7          	jalr	1186(ra) # 8000603c <panic>

0000000080002ba2 <iget>:
{
    80002ba2:	7179                	addi	sp,sp,-48
    80002ba4:	f406                	sd	ra,40(sp)
    80002ba6:	f022                	sd	s0,32(sp)
    80002ba8:	ec26                	sd	s1,24(sp)
    80002baa:	e84a                	sd	s2,16(sp)
    80002bac:	e44e                	sd	s3,8(sp)
    80002bae:	e052                	sd	s4,0(sp)
    80002bb0:	1800                	addi	s0,sp,48
    80002bb2:	89aa                	mv	s3,a0
    80002bb4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002bb6:	00015517          	auipc	a0,0x15
    80002bba:	9e250513          	addi	a0,a0,-1566 # 80017598 <itable>
    80002bbe:	00004097          	auipc	ra,0x4
    80002bc2:	9f8080e7          	jalr	-1544(ra) # 800065b6 <acquire>
  empty = 0;
    80002bc6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002bc8:	00015497          	auipc	s1,0x15
    80002bcc:	9e848493          	addi	s1,s1,-1560 # 800175b0 <itable+0x18>
    80002bd0:	00016697          	auipc	a3,0x16
    80002bd4:	47068693          	addi	a3,a3,1136 # 80019040 <log>
    80002bd8:	a039                	j	80002be6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002bda:	02090b63          	beqz	s2,80002c10 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002bde:	08848493          	addi	s1,s1,136
    80002be2:	02d48a63          	beq	s1,a3,80002c16 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002be6:	449c                	lw	a5,8(s1)
    80002be8:	fef059e3          	blez	a5,80002bda <iget+0x38>
    80002bec:	4098                	lw	a4,0(s1)
    80002bee:	ff3716e3          	bne	a4,s3,80002bda <iget+0x38>
    80002bf2:	40d8                	lw	a4,4(s1)
    80002bf4:	ff4713e3          	bne	a4,s4,80002bda <iget+0x38>
      ip->ref++;
    80002bf8:	2785                	addiw	a5,a5,1
    80002bfa:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002bfc:	00015517          	auipc	a0,0x15
    80002c00:	99c50513          	addi	a0,a0,-1636 # 80017598 <itable>
    80002c04:	00004097          	auipc	ra,0x4
    80002c08:	a66080e7          	jalr	-1434(ra) # 8000666a <release>
      return ip;
    80002c0c:	8926                	mv	s2,s1
    80002c0e:	a03d                	j	80002c3c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002c10:	f7f9                	bnez	a5,80002bde <iget+0x3c>
      empty = ip;
    80002c12:	8926                	mv	s2,s1
    80002c14:	b7e9                	j	80002bde <iget+0x3c>
  if(empty == 0)
    80002c16:	02090c63          	beqz	s2,80002c4e <iget+0xac>
  ip->dev = dev;
    80002c1a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002c1e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002c22:	4785                	li	a5,1
    80002c24:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002c28:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002c2c:	00015517          	auipc	a0,0x15
    80002c30:	96c50513          	addi	a0,a0,-1684 # 80017598 <itable>
    80002c34:	00004097          	auipc	ra,0x4
    80002c38:	a36080e7          	jalr	-1482(ra) # 8000666a <release>
}
    80002c3c:	854a                	mv	a0,s2
    80002c3e:	70a2                	ld	ra,40(sp)
    80002c40:	7402                	ld	s0,32(sp)
    80002c42:	64e2                	ld	s1,24(sp)
    80002c44:	6942                	ld	s2,16(sp)
    80002c46:	69a2                	ld	s3,8(sp)
    80002c48:	6a02                	ld	s4,0(sp)
    80002c4a:	6145                	addi	sp,sp,48
    80002c4c:	8082                	ret
    panic("iget: no inodes");
    80002c4e:	00006517          	auipc	a0,0x6
    80002c52:	88a50513          	addi	a0,a0,-1910 # 800084d8 <etext+0x4d8>
    80002c56:	00003097          	auipc	ra,0x3
    80002c5a:	3e6080e7          	jalr	998(ra) # 8000603c <panic>

0000000080002c5e <fsinit>:
fsinit(int dev) {
    80002c5e:	7179                	addi	sp,sp,-48
    80002c60:	f406                	sd	ra,40(sp)
    80002c62:	f022                	sd	s0,32(sp)
    80002c64:	ec26                	sd	s1,24(sp)
    80002c66:	e84a                	sd	s2,16(sp)
    80002c68:	e44e                	sd	s3,8(sp)
    80002c6a:	1800                	addi	s0,sp,48
    80002c6c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002c6e:	4585                	li	a1,1
    80002c70:	00000097          	auipc	ra,0x0
    80002c74:	a68080e7          	jalr	-1432(ra) # 800026d8 <bread>
    80002c78:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002c7a:	00015997          	auipc	s3,0x15
    80002c7e:	8fe98993          	addi	s3,s3,-1794 # 80017578 <sb>
    80002c82:	02000613          	li	a2,32
    80002c86:	05850593          	addi	a1,a0,88
    80002c8a:	854e                	mv	a0,s3
    80002c8c:	ffffd097          	auipc	ra,0xffffd
    80002c90:	6c0080e7          	jalr	1728(ra) # 8000034c <memmove>
  brelse(bp);
    80002c94:	8526                	mv	a0,s1
    80002c96:	00000097          	auipc	ra,0x0
    80002c9a:	b72080e7          	jalr	-1166(ra) # 80002808 <brelse>
  if(sb.magic != FSMAGIC)
    80002c9e:	0009a703          	lw	a4,0(s3)
    80002ca2:	102037b7          	lui	a5,0x10203
    80002ca6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002caa:	02f71263          	bne	a4,a5,80002cce <fsinit+0x70>
  initlog(dev, &sb);
    80002cae:	00015597          	auipc	a1,0x15
    80002cb2:	8ca58593          	addi	a1,a1,-1846 # 80017578 <sb>
    80002cb6:	854a                	mv	a0,s2
    80002cb8:	00001097          	auipc	ra,0x1
    80002cbc:	b54080e7          	jalr	-1196(ra) # 8000380c <initlog>
}
    80002cc0:	70a2                	ld	ra,40(sp)
    80002cc2:	7402                	ld	s0,32(sp)
    80002cc4:	64e2                	ld	s1,24(sp)
    80002cc6:	6942                	ld	s2,16(sp)
    80002cc8:	69a2                	ld	s3,8(sp)
    80002cca:	6145                	addi	sp,sp,48
    80002ccc:	8082                	ret
    panic("invalid file system");
    80002cce:	00006517          	auipc	a0,0x6
    80002cd2:	81a50513          	addi	a0,a0,-2022 # 800084e8 <etext+0x4e8>
    80002cd6:	00003097          	auipc	ra,0x3
    80002cda:	366080e7          	jalr	870(ra) # 8000603c <panic>

0000000080002cde <iinit>:
{
    80002cde:	7179                	addi	sp,sp,-48
    80002ce0:	f406                	sd	ra,40(sp)
    80002ce2:	f022                	sd	s0,32(sp)
    80002ce4:	ec26                	sd	s1,24(sp)
    80002ce6:	e84a                	sd	s2,16(sp)
    80002ce8:	e44e                	sd	s3,8(sp)
    80002cea:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002cec:	00006597          	auipc	a1,0x6
    80002cf0:	81458593          	addi	a1,a1,-2028 # 80008500 <etext+0x500>
    80002cf4:	00015517          	auipc	a0,0x15
    80002cf8:	8a450513          	addi	a0,a0,-1884 # 80017598 <itable>
    80002cfc:	00004097          	auipc	ra,0x4
    80002d00:	82a080e7          	jalr	-2006(ra) # 80006526 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002d04:	00015497          	auipc	s1,0x15
    80002d08:	8bc48493          	addi	s1,s1,-1860 # 800175c0 <itable+0x28>
    80002d0c:	00016997          	auipc	s3,0x16
    80002d10:	34498993          	addi	s3,s3,836 # 80019050 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002d14:	00005917          	auipc	s2,0x5
    80002d18:	7f490913          	addi	s2,s2,2036 # 80008508 <etext+0x508>
    80002d1c:	85ca                	mv	a1,s2
    80002d1e:	8526                	mv	a0,s1
    80002d20:	00001097          	auipc	ra,0x1
    80002d24:	e40080e7          	jalr	-448(ra) # 80003b60 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002d28:	08848493          	addi	s1,s1,136
    80002d2c:	ff3498e3          	bne	s1,s3,80002d1c <iinit+0x3e>
}
    80002d30:	70a2                	ld	ra,40(sp)
    80002d32:	7402                	ld	s0,32(sp)
    80002d34:	64e2                	ld	s1,24(sp)
    80002d36:	6942                	ld	s2,16(sp)
    80002d38:	69a2                	ld	s3,8(sp)
    80002d3a:	6145                	addi	sp,sp,48
    80002d3c:	8082                	ret

0000000080002d3e <ialloc>:
{
    80002d3e:	7139                	addi	sp,sp,-64
    80002d40:	fc06                	sd	ra,56(sp)
    80002d42:	f822                	sd	s0,48(sp)
    80002d44:	f426                	sd	s1,40(sp)
    80002d46:	f04a                	sd	s2,32(sp)
    80002d48:	ec4e                	sd	s3,24(sp)
    80002d4a:	e852                	sd	s4,16(sp)
    80002d4c:	e456                	sd	s5,8(sp)
    80002d4e:	e05a                	sd	s6,0(sp)
    80002d50:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d52:	00015717          	auipc	a4,0x15
    80002d56:	83272703          	lw	a4,-1998(a4) # 80017584 <sb+0xc>
    80002d5a:	4785                	li	a5,1
    80002d5c:	04e7f863          	bgeu	a5,a4,80002dac <ialloc+0x6e>
    80002d60:	8aaa                	mv	s5,a0
    80002d62:	8b2e                	mv	s6,a1
    80002d64:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002d66:	00015a17          	auipc	s4,0x15
    80002d6a:	812a0a13          	addi	s4,s4,-2030 # 80017578 <sb>
    80002d6e:	00495593          	srli	a1,s2,0x4
    80002d72:	018a2783          	lw	a5,24(s4)
    80002d76:	9dbd                	addw	a1,a1,a5
    80002d78:	8556                	mv	a0,s5
    80002d7a:	00000097          	auipc	ra,0x0
    80002d7e:	95e080e7          	jalr	-1698(ra) # 800026d8 <bread>
    80002d82:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002d84:	05850993          	addi	s3,a0,88
    80002d88:	00f97793          	andi	a5,s2,15
    80002d8c:	079a                	slli	a5,a5,0x6
    80002d8e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002d90:	00099783          	lh	a5,0(s3)
    80002d94:	c785                	beqz	a5,80002dbc <ialloc+0x7e>
    brelse(bp);
    80002d96:	00000097          	auipc	ra,0x0
    80002d9a:	a72080e7          	jalr	-1422(ra) # 80002808 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d9e:	0905                	addi	s2,s2,1
    80002da0:	00ca2703          	lw	a4,12(s4)
    80002da4:	0009079b          	sext.w	a5,s2
    80002da8:	fce7e3e3          	bltu	a5,a4,80002d6e <ialloc+0x30>
  panic("ialloc: no inodes");
    80002dac:	00005517          	auipc	a0,0x5
    80002db0:	76450513          	addi	a0,a0,1892 # 80008510 <etext+0x510>
    80002db4:	00003097          	auipc	ra,0x3
    80002db8:	288080e7          	jalr	648(ra) # 8000603c <panic>
      memset(dip, 0, sizeof(*dip));
    80002dbc:	04000613          	li	a2,64
    80002dc0:	4581                	li	a1,0
    80002dc2:	854e                	mv	a0,s3
    80002dc4:	ffffd097          	auipc	ra,0xffffd
    80002dc8:	52c080e7          	jalr	1324(ra) # 800002f0 <memset>
      dip->type = type;
    80002dcc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002dd0:	8526                	mv	a0,s1
    80002dd2:	00001097          	auipc	ra,0x1
    80002dd6:	caa080e7          	jalr	-854(ra) # 80003a7c <log_write>
      brelse(bp);
    80002dda:	8526                	mv	a0,s1
    80002ddc:	00000097          	auipc	ra,0x0
    80002de0:	a2c080e7          	jalr	-1492(ra) # 80002808 <brelse>
      return iget(dev, inum);
    80002de4:	0009059b          	sext.w	a1,s2
    80002de8:	8556                	mv	a0,s5
    80002dea:	00000097          	auipc	ra,0x0
    80002dee:	db8080e7          	jalr	-584(ra) # 80002ba2 <iget>
}
    80002df2:	70e2                	ld	ra,56(sp)
    80002df4:	7442                	ld	s0,48(sp)
    80002df6:	74a2                	ld	s1,40(sp)
    80002df8:	7902                	ld	s2,32(sp)
    80002dfa:	69e2                	ld	s3,24(sp)
    80002dfc:	6a42                	ld	s4,16(sp)
    80002dfe:	6aa2                	ld	s5,8(sp)
    80002e00:	6b02                	ld	s6,0(sp)
    80002e02:	6121                	addi	sp,sp,64
    80002e04:	8082                	ret

0000000080002e06 <iupdate>:
{
    80002e06:	1101                	addi	sp,sp,-32
    80002e08:	ec06                	sd	ra,24(sp)
    80002e0a:	e822                	sd	s0,16(sp)
    80002e0c:	e426                	sd	s1,8(sp)
    80002e0e:	e04a                	sd	s2,0(sp)
    80002e10:	1000                	addi	s0,sp,32
    80002e12:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e14:	415c                	lw	a5,4(a0)
    80002e16:	0047d79b          	srliw	a5,a5,0x4
    80002e1a:	00014597          	auipc	a1,0x14
    80002e1e:	7765a583          	lw	a1,1910(a1) # 80017590 <sb+0x18>
    80002e22:	9dbd                	addw	a1,a1,a5
    80002e24:	4108                	lw	a0,0(a0)
    80002e26:	00000097          	auipc	ra,0x0
    80002e2a:	8b2080e7          	jalr	-1870(ra) # 800026d8 <bread>
    80002e2e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e30:	05850793          	addi	a5,a0,88
    80002e34:	40d8                	lw	a4,4(s1)
    80002e36:	8b3d                	andi	a4,a4,15
    80002e38:	071a                	slli	a4,a4,0x6
    80002e3a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002e3c:	04449703          	lh	a4,68(s1)
    80002e40:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002e44:	04649703          	lh	a4,70(s1)
    80002e48:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002e4c:	04849703          	lh	a4,72(s1)
    80002e50:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002e54:	04a49703          	lh	a4,74(s1)
    80002e58:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002e5c:	44f8                	lw	a4,76(s1)
    80002e5e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002e60:	03400613          	li	a2,52
    80002e64:	05048593          	addi	a1,s1,80
    80002e68:	00c78513          	addi	a0,a5,12
    80002e6c:	ffffd097          	auipc	ra,0xffffd
    80002e70:	4e0080e7          	jalr	1248(ra) # 8000034c <memmove>
  log_write(bp);
    80002e74:	854a                	mv	a0,s2
    80002e76:	00001097          	auipc	ra,0x1
    80002e7a:	c06080e7          	jalr	-1018(ra) # 80003a7c <log_write>
  brelse(bp);
    80002e7e:	854a                	mv	a0,s2
    80002e80:	00000097          	auipc	ra,0x0
    80002e84:	988080e7          	jalr	-1656(ra) # 80002808 <brelse>
}
    80002e88:	60e2                	ld	ra,24(sp)
    80002e8a:	6442                	ld	s0,16(sp)
    80002e8c:	64a2                	ld	s1,8(sp)
    80002e8e:	6902                	ld	s2,0(sp)
    80002e90:	6105                	addi	sp,sp,32
    80002e92:	8082                	ret

0000000080002e94 <idup>:
{
    80002e94:	1101                	addi	sp,sp,-32
    80002e96:	ec06                	sd	ra,24(sp)
    80002e98:	e822                	sd	s0,16(sp)
    80002e9a:	e426                	sd	s1,8(sp)
    80002e9c:	1000                	addi	s0,sp,32
    80002e9e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ea0:	00014517          	auipc	a0,0x14
    80002ea4:	6f850513          	addi	a0,a0,1784 # 80017598 <itable>
    80002ea8:	00003097          	auipc	ra,0x3
    80002eac:	70e080e7          	jalr	1806(ra) # 800065b6 <acquire>
  ip->ref++;
    80002eb0:	449c                	lw	a5,8(s1)
    80002eb2:	2785                	addiw	a5,a5,1
    80002eb4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002eb6:	00014517          	auipc	a0,0x14
    80002eba:	6e250513          	addi	a0,a0,1762 # 80017598 <itable>
    80002ebe:	00003097          	auipc	ra,0x3
    80002ec2:	7ac080e7          	jalr	1964(ra) # 8000666a <release>
}
    80002ec6:	8526                	mv	a0,s1
    80002ec8:	60e2                	ld	ra,24(sp)
    80002eca:	6442                	ld	s0,16(sp)
    80002ecc:	64a2                	ld	s1,8(sp)
    80002ece:	6105                	addi	sp,sp,32
    80002ed0:	8082                	ret

0000000080002ed2 <ilock>:
{
    80002ed2:	1101                	addi	sp,sp,-32
    80002ed4:	ec06                	sd	ra,24(sp)
    80002ed6:	e822                	sd	s0,16(sp)
    80002ed8:	e426                	sd	s1,8(sp)
    80002eda:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002edc:	c10d                	beqz	a0,80002efe <ilock+0x2c>
    80002ede:	84aa                	mv	s1,a0
    80002ee0:	451c                	lw	a5,8(a0)
    80002ee2:	00f05e63          	blez	a5,80002efe <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002ee6:	0541                	addi	a0,a0,16
    80002ee8:	00001097          	auipc	ra,0x1
    80002eec:	cb2080e7          	jalr	-846(ra) # 80003b9a <acquiresleep>
  if(ip->valid == 0){
    80002ef0:	40bc                	lw	a5,64(s1)
    80002ef2:	cf99                	beqz	a5,80002f10 <ilock+0x3e>
}
    80002ef4:	60e2                	ld	ra,24(sp)
    80002ef6:	6442                	ld	s0,16(sp)
    80002ef8:	64a2                	ld	s1,8(sp)
    80002efa:	6105                	addi	sp,sp,32
    80002efc:	8082                	ret
    80002efe:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002f00:	00005517          	auipc	a0,0x5
    80002f04:	62850513          	addi	a0,a0,1576 # 80008528 <etext+0x528>
    80002f08:	00003097          	auipc	ra,0x3
    80002f0c:	134080e7          	jalr	308(ra) # 8000603c <panic>
    80002f10:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002f12:	40dc                	lw	a5,4(s1)
    80002f14:	0047d79b          	srliw	a5,a5,0x4
    80002f18:	00014597          	auipc	a1,0x14
    80002f1c:	6785a583          	lw	a1,1656(a1) # 80017590 <sb+0x18>
    80002f20:	9dbd                	addw	a1,a1,a5
    80002f22:	4088                	lw	a0,0(s1)
    80002f24:	fffff097          	auipc	ra,0xfffff
    80002f28:	7b4080e7          	jalr	1972(ra) # 800026d8 <bread>
    80002f2c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002f2e:	05850593          	addi	a1,a0,88
    80002f32:	40dc                	lw	a5,4(s1)
    80002f34:	8bbd                	andi	a5,a5,15
    80002f36:	079a                	slli	a5,a5,0x6
    80002f38:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002f3a:	00059783          	lh	a5,0(a1)
    80002f3e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002f42:	00259783          	lh	a5,2(a1)
    80002f46:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002f4a:	00459783          	lh	a5,4(a1)
    80002f4e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002f52:	00659783          	lh	a5,6(a1)
    80002f56:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002f5a:	459c                	lw	a5,8(a1)
    80002f5c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002f5e:	03400613          	li	a2,52
    80002f62:	05b1                	addi	a1,a1,12
    80002f64:	05048513          	addi	a0,s1,80
    80002f68:	ffffd097          	auipc	ra,0xffffd
    80002f6c:	3e4080e7          	jalr	996(ra) # 8000034c <memmove>
    brelse(bp);
    80002f70:	854a                	mv	a0,s2
    80002f72:	00000097          	auipc	ra,0x0
    80002f76:	896080e7          	jalr	-1898(ra) # 80002808 <brelse>
    ip->valid = 1;
    80002f7a:	4785                	li	a5,1
    80002f7c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002f7e:	04449783          	lh	a5,68(s1)
    80002f82:	c399                	beqz	a5,80002f88 <ilock+0xb6>
    80002f84:	6902                	ld	s2,0(sp)
    80002f86:	b7bd                	j	80002ef4 <ilock+0x22>
      panic("ilock: no type");
    80002f88:	00005517          	auipc	a0,0x5
    80002f8c:	5a850513          	addi	a0,a0,1448 # 80008530 <etext+0x530>
    80002f90:	00003097          	auipc	ra,0x3
    80002f94:	0ac080e7          	jalr	172(ra) # 8000603c <panic>

0000000080002f98 <iunlock>:
{
    80002f98:	1101                	addi	sp,sp,-32
    80002f9a:	ec06                	sd	ra,24(sp)
    80002f9c:	e822                	sd	s0,16(sp)
    80002f9e:	e426                	sd	s1,8(sp)
    80002fa0:	e04a                	sd	s2,0(sp)
    80002fa2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002fa4:	c905                	beqz	a0,80002fd4 <iunlock+0x3c>
    80002fa6:	84aa                	mv	s1,a0
    80002fa8:	01050913          	addi	s2,a0,16
    80002fac:	854a                	mv	a0,s2
    80002fae:	00001097          	auipc	ra,0x1
    80002fb2:	c86080e7          	jalr	-890(ra) # 80003c34 <holdingsleep>
    80002fb6:	cd19                	beqz	a0,80002fd4 <iunlock+0x3c>
    80002fb8:	449c                	lw	a5,8(s1)
    80002fba:	00f05d63          	blez	a5,80002fd4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002fbe:	854a                	mv	a0,s2
    80002fc0:	00001097          	auipc	ra,0x1
    80002fc4:	c30080e7          	jalr	-976(ra) # 80003bf0 <releasesleep>
}
    80002fc8:	60e2                	ld	ra,24(sp)
    80002fca:	6442                	ld	s0,16(sp)
    80002fcc:	64a2                	ld	s1,8(sp)
    80002fce:	6902                	ld	s2,0(sp)
    80002fd0:	6105                	addi	sp,sp,32
    80002fd2:	8082                	ret
    panic("iunlock");
    80002fd4:	00005517          	auipc	a0,0x5
    80002fd8:	56c50513          	addi	a0,a0,1388 # 80008540 <etext+0x540>
    80002fdc:	00003097          	auipc	ra,0x3
    80002fe0:	060080e7          	jalr	96(ra) # 8000603c <panic>

0000000080002fe4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002fe4:	7179                	addi	sp,sp,-48
    80002fe6:	f406                	sd	ra,40(sp)
    80002fe8:	f022                	sd	s0,32(sp)
    80002fea:	ec26                	sd	s1,24(sp)
    80002fec:	e84a                	sd	s2,16(sp)
    80002fee:	e44e                	sd	s3,8(sp)
    80002ff0:	1800                	addi	s0,sp,48
    80002ff2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ff4:	05050493          	addi	s1,a0,80
    80002ff8:	08050913          	addi	s2,a0,128
    80002ffc:	a021                	j	80003004 <itrunc+0x20>
    80002ffe:	0491                	addi	s1,s1,4
    80003000:	01248d63          	beq	s1,s2,8000301a <itrunc+0x36>
    if(ip->addrs[i]){
    80003004:	408c                	lw	a1,0(s1)
    80003006:	dde5                	beqz	a1,80002ffe <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003008:	0009a503          	lw	a0,0(s3)
    8000300c:	00000097          	auipc	ra,0x0
    80003010:	910080e7          	jalr	-1776(ra) # 8000291c <bfree>
      ip->addrs[i] = 0;
    80003014:	0004a023          	sw	zero,0(s1)
    80003018:	b7dd                	j	80002ffe <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000301a:	0809a583          	lw	a1,128(s3)
    8000301e:	ed99                	bnez	a1,8000303c <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003020:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003024:	854e                	mv	a0,s3
    80003026:	00000097          	auipc	ra,0x0
    8000302a:	de0080e7          	jalr	-544(ra) # 80002e06 <iupdate>
}
    8000302e:	70a2                	ld	ra,40(sp)
    80003030:	7402                	ld	s0,32(sp)
    80003032:	64e2                	ld	s1,24(sp)
    80003034:	6942                	ld	s2,16(sp)
    80003036:	69a2                	ld	s3,8(sp)
    80003038:	6145                	addi	sp,sp,48
    8000303a:	8082                	ret
    8000303c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000303e:	0009a503          	lw	a0,0(s3)
    80003042:	fffff097          	auipc	ra,0xfffff
    80003046:	696080e7          	jalr	1686(ra) # 800026d8 <bread>
    8000304a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000304c:	05850493          	addi	s1,a0,88
    80003050:	45850913          	addi	s2,a0,1112
    80003054:	a021                	j	8000305c <itrunc+0x78>
    80003056:	0491                	addi	s1,s1,4
    80003058:	01248b63          	beq	s1,s2,8000306e <itrunc+0x8a>
      if(a[j])
    8000305c:	408c                	lw	a1,0(s1)
    8000305e:	dde5                	beqz	a1,80003056 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003060:	0009a503          	lw	a0,0(s3)
    80003064:	00000097          	auipc	ra,0x0
    80003068:	8b8080e7          	jalr	-1864(ra) # 8000291c <bfree>
    8000306c:	b7ed                	j	80003056 <itrunc+0x72>
    brelse(bp);
    8000306e:	8552                	mv	a0,s4
    80003070:	fffff097          	auipc	ra,0xfffff
    80003074:	798080e7          	jalr	1944(ra) # 80002808 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003078:	0809a583          	lw	a1,128(s3)
    8000307c:	0009a503          	lw	a0,0(s3)
    80003080:	00000097          	auipc	ra,0x0
    80003084:	89c080e7          	jalr	-1892(ra) # 8000291c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003088:	0809a023          	sw	zero,128(s3)
    8000308c:	6a02                	ld	s4,0(sp)
    8000308e:	bf49                	j	80003020 <itrunc+0x3c>

0000000080003090 <iput>:
{
    80003090:	1101                	addi	sp,sp,-32
    80003092:	ec06                	sd	ra,24(sp)
    80003094:	e822                	sd	s0,16(sp)
    80003096:	e426                	sd	s1,8(sp)
    80003098:	1000                	addi	s0,sp,32
    8000309a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000309c:	00014517          	auipc	a0,0x14
    800030a0:	4fc50513          	addi	a0,a0,1276 # 80017598 <itable>
    800030a4:	00003097          	auipc	ra,0x3
    800030a8:	512080e7          	jalr	1298(ra) # 800065b6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800030ac:	4498                	lw	a4,8(s1)
    800030ae:	4785                	li	a5,1
    800030b0:	02f70263          	beq	a4,a5,800030d4 <iput+0x44>
  ip->ref--;
    800030b4:	449c                	lw	a5,8(s1)
    800030b6:	37fd                	addiw	a5,a5,-1
    800030b8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800030ba:	00014517          	auipc	a0,0x14
    800030be:	4de50513          	addi	a0,a0,1246 # 80017598 <itable>
    800030c2:	00003097          	auipc	ra,0x3
    800030c6:	5a8080e7          	jalr	1448(ra) # 8000666a <release>
}
    800030ca:	60e2                	ld	ra,24(sp)
    800030cc:	6442                	ld	s0,16(sp)
    800030ce:	64a2                	ld	s1,8(sp)
    800030d0:	6105                	addi	sp,sp,32
    800030d2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800030d4:	40bc                	lw	a5,64(s1)
    800030d6:	dff9                	beqz	a5,800030b4 <iput+0x24>
    800030d8:	04a49783          	lh	a5,74(s1)
    800030dc:	ffe1                	bnez	a5,800030b4 <iput+0x24>
    800030de:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800030e0:	01048913          	addi	s2,s1,16
    800030e4:	854a                	mv	a0,s2
    800030e6:	00001097          	auipc	ra,0x1
    800030ea:	ab4080e7          	jalr	-1356(ra) # 80003b9a <acquiresleep>
    release(&itable.lock);
    800030ee:	00014517          	auipc	a0,0x14
    800030f2:	4aa50513          	addi	a0,a0,1194 # 80017598 <itable>
    800030f6:	00003097          	auipc	ra,0x3
    800030fa:	574080e7          	jalr	1396(ra) # 8000666a <release>
    itrunc(ip);
    800030fe:	8526                	mv	a0,s1
    80003100:	00000097          	auipc	ra,0x0
    80003104:	ee4080e7          	jalr	-284(ra) # 80002fe4 <itrunc>
    ip->type = 0;
    80003108:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000310c:	8526                	mv	a0,s1
    8000310e:	00000097          	auipc	ra,0x0
    80003112:	cf8080e7          	jalr	-776(ra) # 80002e06 <iupdate>
    ip->valid = 0;
    80003116:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000311a:	854a                	mv	a0,s2
    8000311c:	00001097          	auipc	ra,0x1
    80003120:	ad4080e7          	jalr	-1324(ra) # 80003bf0 <releasesleep>
    acquire(&itable.lock);
    80003124:	00014517          	auipc	a0,0x14
    80003128:	47450513          	addi	a0,a0,1140 # 80017598 <itable>
    8000312c:	00003097          	auipc	ra,0x3
    80003130:	48a080e7          	jalr	1162(ra) # 800065b6 <acquire>
    80003134:	6902                	ld	s2,0(sp)
    80003136:	bfbd                	j	800030b4 <iput+0x24>

0000000080003138 <iunlockput>:
{
    80003138:	1101                	addi	sp,sp,-32
    8000313a:	ec06                	sd	ra,24(sp)
    8000313c:	e822                	sd	s0,16(sp)
    8000313e:	e426                	sd	s1,8(sp)
    80003140:	1000                	addi	s0,sp,32
    80003142:	84aa                	mv	s1,a0
  iunlock(ip);
    80003144:	00000097          	auipc	ra,0x0
    80003148:	e54080e7          	jalr	-428(ra) # 80002f98 <iunlock>
  iput(ip);
    8000314c:	8526                	mv	a0,s1
    8000314e:	00000097          	auipc	ra,0x0
    80003152:	f42080e7          	jalr	-190(ra) # 80003090 <iput>
}
    80003156:	60e2                	ld	ra,24(sp)
    80003158:	6442                	ld	s0,16(sp)
    8000315a:	64a2                	ld	s1,8(sp)
    8000315c:	6105                	addi	sp,sp,32
    8000315e:	8082                	ret

0000000080003160 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003160:	1141                	addi	sp,sp,-16
    80003162:	e422                	sd	s0,8(sp)
    80003164:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003166:	411c                	lw	a5,0(a0)
    80003168:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000316a:	415c                	lw	a5,4(a0)
    8000316c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000316e:	04451783          	lh	a5,68(a0)
    80003172:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003176:	04a51783          	lh	a5,74(a0)
    8000317a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000317e:	04c56783          	lwu	a5,76(a0)
    80003182:	e99c                	sd	a5,16(a1)
}
    80003184:	6422                	ld	s0,8(sp)
    80003186:	0141                	addi	sp,sp,16
    80003188:	8082                	ret

000000008000318a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000318a:	457c                	lw	a5,76(a0)
    8000318c:	0ed7ef63          	bltu	a5,a3,8000328a <readi+0x100>
{
    80003190:	7159                	addi	sp,sp,-112
    80003192:	f486                	sd	ra,104(sp)
    80003194:	f0a2                	sd	s0,96(sp)
    80003196:	eca6                	sd	s1,88(sp)
    80003198:	fc56                	sd	s5,56(sp)
    8000319a:	f85a                	sd	s6,48(sp)
    8000319c:	f45e                	sd	s7,40(sp)
    8000319e:	f062                	sd	s8,32(sp)
    800031a0:	1880                	addi	s0,sp,112
    800031a2:	8baa                	mv	s7,a0
    800031a4:	8c2e                	mv	s8,a1
    800031a6:	8ab2                	mv	s5,a2
    800031a8:	84b6                	mv	s1,a3
    800031aa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800031ac:	9f35                	addw	a4,a4,a3
    return 0;
    800031ae:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800031b0:	0ad76c63          	bltu	a4,a3,80003268 <readi+0xde>
    800031b4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800031b6:	00e7f463          	bgeu	a5,a4,800031be <readi+0x34>
    n = ip->size - off;
    800031ba:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031be:	0c0b0463          	beqz	s6,80003286 <readi+0xfc>
    800031c2:	e8ca                	sd	s2,80(sp)
    800031c4:	e0d2                	sd	s4,64(sp)
    800031c6:	ec66                	sd	s9,24(sp)
    800031c8:	e86a                	sd	s10,16(sp)
    800031ca:	e46e                	sd	s11,8(sp)
    800031cc:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800031ce:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800031d2:	5cfd                	li	s9,-1
    800031d4:	a82d                	j	8000320e <readi+0x84>
    800031d6:	020a1d93          	slli	s11,s4,0x20
    800031da:	020ddd93          	srli	s11,s11,0x20
    800031de:	05890613          	addi	a2,s2,88
    800031e2:	86ee                	mv	a3,s11
    800031e4:	963a                	add	a2,a2,a4
    800031e6:	85d6                	mv	a1,s5
    800031e8:	8562                	mv	a0,s8
    800031ea:	fffff097          	auipc	ra,0xfffff
    800031ee:	9a8080e7          	jalr	-1624(ra) # 80001b92 <either_copyout>
    800031f2:	05950d63          	beq	a0,s9,8000324c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800031f6:	854a                	mv	a0,s2
    800031f8:	fffff097          	auipc	ra,0xfffff
    800031fc:	610080e7          	jalr	1552(ra) # 80002808 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003200:	013a09bb          	addw	s3,s4,s3
    80003204:	009a04bb          	addw	s1,s4,s1
    80003208:	9aee                	add	s5,s5,s11
    8000320a:	0769f863          	bgeu	s3,s6,8000327a <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000320e:	000ba903          	lw	s2,0(s7)
    80003212:	00a4d59b          	srliw	a1,s1,0xa
    80003216:	855e                	mv	a0,s7
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	8ae080e7          	jalr	-1874(ra) # 80002ac6 <bmap>
    80003220:	0005059b          	sext.w	a1,a0
    80003224:	854a                	mv	a0,s2
    80003226:	fffff097          	auipc	ra,0xfffff
    8000322a:	4b2080e7          	jalr	1202(ra) # 800026d8 <bread>
    8000322e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003230:	3ff4f713          	andi	a4,s1,1023
    80003234:	40ed07bb          	subw	a5,s10,a4
    80003238:	413b06bb          	subw	a3,s6,s3
    8000323c:	8a3e                	mv	s4,a5
    8000323e:	2781                	sext.w	a5,a5
    80003240:	0006861b          	sext.w	a2,a3
    80003244:	f8f679e3          	bgeu	a2,a5,800031d6 <readi+0x4c>
    80003248:	8a36                	mv	s4,a3
    8000324a:	b771                	j	800031d6 <readi+0x4c>
      brelse(bp);
    8000324c:	854a                	mv	a0,s2
    8000324e:	fffff097          	auipc	ra,0xfffff
    80003252:	5ba080e7          	jalr	1466(ra) # 80002808 <brelse>
      tot = -1;
    80003256:	59fd                	li	s3,-1
      break;
    80003258:	6946                	ld	s2,80(sp)
    8000325a:	6a06                	ld	s4,64(sp)
    8000325c:	6ce2                	ld	s9,24(sp)
    8000325e:	6d42                	ld	s10,16(sp)
    80003260:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003262:	0009851b          	sext.w	a0,s3
    80003266:	69a6                	ld	s3,72(sp)
}
    80003268:	70a6                	ld	ra,104(sp)
    8000326a:	7406                	ld	s0,96(sp)
    8000326c:	64e6                	ld	s1,88(sp)
    8000326e:	7ae2                	ld	s5,56(sp)
    80003270:	7b42                	ld	s6,48(sp)
    80003272:	7ba2                	ld	s7,40(sp)
    80003274:	7c02                	ld	s8,32(sp)
    80003276:	6165                	addi	sp,sp,112
    80003278:	8082                	ret
    8000327a:	6946                	ld	s2,80(sp)
    8000327c:	6a06                	ld	s4,64(sp)
    8000327e:	6ce2                	ld	s9,24(sp)
    80003280:	6d42                	ld	s10,16(sp)
    80003282:	6da2                	ld	s11,8(sp)
    80003284:	bff9                	j	80003262 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003286:	89da                	mv	s3,s6
    80003288:	bfe9                	j	80003262 <readi+0xd8>
    return 0;
    8000328a:	4501                	li	a0,0
}
    8000328c:	8082                	ret

000000008000328e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000328e:	457c                	lw	a5,76(a0)
    80003290:	10d7ee63          	bltu	a5,a3,800033ac <writei+0x11e>
{
    80003294:	7159                	addi	sp,sp,-112
    80003296:	f486                	sd	ra,104(sp)
    80003298:	f0a2                	sd	s0,96(sp)
    8000329a:	e8ca                	sd	s2,80(sp)
    8000329c:	fc56                	sd	s5,56(sp)
    8000329e:	f85a                	sd	s6,48(sp)
    800032a0:	f45e                	sd	s7,40(sp)
    800032a2:	f062                	sd	s8,32(sp)
    800032a4:	1880                	addi	s0,sp,112
    800032a6:	8b2a                	mv	s6,a0
    800032a8:	8c2e                	mv	s8,a1
    800032aa:	8ab2                	mv	s5,a2
    800032ac:	8936                	mv	s2,a3
    800032ae:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800032b0:	00e687bb          	addw	a5,a3,a4
    800032b4:	0ed7ee63          	bltu	a5,a3,800033b0 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800032b8:	00043737          	lui	a4,0x43
    800032bc:	0ef76c63          	bltu	a4,a5,800033b4 <writei+0x126>
    800032c0:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032c2:	0c0b8d63          	beqz	s7,8000339c <writei+0x10e>
    800032c6:	eca6                	sd	s1,88(sp)
    800032c8:	e4ce                	sd	s3,72(sp)
    800032ca:	ec66                	sd	s9,24(sp)
    800032cc:	e86a                	sd	s10,16(sp)
    800032ce:	e46e                	sd	s11,8(sp)
    800032d0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800032d2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800032d6:	5cfd                	li	s9,-1
    800032d8:	a091                	j	8000331c <writei+0x8e>
    800032da:	02099d93          	slli	s11,s3,0x20
    800032de:	020ddd93          	srli	s11,s11,0x20
    800032e2:	05848513          	addi	a0,s1,88
    800032e6:	86ee                	mv	a3,s11
    800032e8:	8656                	mv	a2,s5
    800032ea:	85e2                	mv	a1,s8
    800032ec:	953a                	add	a0,a0,a4
    800032ee:	fffff097          	auipc	ra,0xfffff
    800032f2:	8fa080e7          	jalr	-1798(ra) # 80001be8 <either_copyin>
    800032f6:	07950263          	beq	a0,s9,8000335a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800032fa:	8526                	mv	a0,s1
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	780080e7          	jalr	1920(ra) # 80003a7c <log_write>
    brelse(bp);
    80003304:	8526                	mv	a0,s1
    80003306:	fffff097          	auipc	ra,0xfffff
    8000330a:	502080e7          	jalr	1282(ra) # 80002808 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000330e:	01498a3b          	addw	s4,s3,s4
    80003312:	0129893b          	addw	s2,s3,s2
    80003316:	9aee                	add	s5,s5,s11
    80003318:	057a7663          	bgeu	s4,s7,80003364 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000331c:	000b2483          	lw	s1,0(s6)
    80003320:	00a9559b          	srliw	a1,s2,0xa
    80003324:	855a                	mv	a0,s6
    80003326:	fffff097          	auipc	ra,0xfffff
    8000332a:	7a0080e7          	jalr	1952(ra) # 80002ac6 <bmap>
    8000332e:	0005059b          	sext.w	a1,a0
    80003332:	8526                	mv	a0,s1
    80003334:	fffff097          	auipc	ra,0xfffff
    80003338:	3a4080e7          	jalr	932(ra) # 800026d8 <bread>
    8000333c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000333e:	3ff97713          	andi	a4,s2,1023
    80003342:	40ed07bb          	subw	a5,s10,a4
    80003346:	414b86bb          	subw	a3,s7,s4
    8000334a:	89be                	mv	s3,a5
    8000334c:	2781                	sext.w	a5,a5
    8000334e:	0006861b          	sext.w	a2,a3
    80003352:	f8f674e3          	bgeu	a2,a5,800032da <writei+0x4c>
    80003356:	89b6                	mv	s3,a3
    80003358:	b749                	j	800032da <writei+0x4c>
      brelse(bp);
    8000335a:	8526                	mv	a0,s1
    8000335c:	fffff097          	auipc	ra,0xfffff
    80003360:	4ac080e7          	jalr	1196(ra) # 80002808 <brelse>
  }

  if(off > ip->size)
    80003364:	04cb2783          	lw	a5,76(s6)
    80003368:	0327fc63          	bgeu	a5,s2,800033a0 <writei+0x112>
    ip->size = off;
    8000336c:	052b2623          	sw	s2,76(s6)
    80003370:	64e6                	ld	s1,88(sp)
    80003372:	69a6                	ld	s3,72(sp)
    80003374:	6ce2                	ld	s9,24(sp)
    80003376:	6d42                	ld	s10,16(sp)
    80003378:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000337a:	855a                	mv	a0,s6
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	a8a080e7          	jalr	-1398(ra) # 80002e06 <iupdate>

  return tot;
    80003384:	000a051b          	sext.w	a0,s4
    80003388:	6a06                	ld	s4,64(sp)
}
    8000338a:	70a6                	ld	ra,104(sp)
    8000338c:	7406                	ld	s0,96(sp)
    8000338e:	6946                	ld	s2,80(sp)
    80003390:	7ae2                	ld	s5,56(sp)
    80003392:	7b42                	ld	s6,48(sp)
    80003394:	7ba2                	ld	s7,40(sp)
    80003396:	7c02                	ld	s8,32(sp)
    80003398:	6165                	addi	sp,sp,112
    8000339a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000339c:	8a5e                	mv	s4,s7
    8000339e:	bff1                	j	8000337a <writei+0xec>
    800033a0:	64e6                	ld	s1,88(sp)
    800033a2:	69a6                	ld	s3,72(sp)
    800033a4:	6ce2                	ld	s9,24(sp)
    800033a6:	6d42                	ld	s10,16(sp)
    800033a8:	6da2                	ld	s11,8(sp)
    800033aa:	bfc1                	j	8000337a <writei+0xec>
    return -1;
    800033ac:	557d                	li	a0,-1
}
    800033ae:	8082                	ret
    return -1;
    800033b0:	557d                	li	a0,-1
    800033b2:	bfe1                	j	8000338a <writei+0xfc>
    return -1;
    800033b4:	557d                	li	a0,-1
    800033b6:	bfd1                	j	8000338a <writei+0xfc>

00000000800033b8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800033b8:	1141                	addi	sp,sp,-16
    800033ba:	e406                	sd	ra,8(sp)
    800033bc:	e022                	sd	s0,0(sp)
    800033be:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800033c0:	4639                	li	a2,14
    800033c2:	ffffd097          	auipc	ra,0xffffd
    800033c6:	ffe080e7          	jalr	-2(ra) # 800003c0 <strncmp>
}
    800033ca:	60a2                	ld	ra,8(sp)
    800033cc:	6402                	ld	s0,0(sp)
    800033ce:	0141                	addi	sp,sp,16
    800033d0:	8082                	ret

00000000800033d2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800033d2:	7139                	addi	sp,sp,-64
    800033d4:	fc06                	sd	ra,56(sp)
    800033d6:	f822                	sd	s0,48(sp)
    800033d8:	f426                	sd	s1,40(sp)
    800033da:	f04a                	sd	s2,32(sp)
    800033dc:	ec4e                	sd	s3,24(sp)
    800033de:	e852                	sd	s4,16(sp)
    800033e0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800033e2:	04451703          	lh	a4,68(a0)
    800033e6:	4785                	li	a5,1
    800033e8:	00f71a63          	bne	a4,a5,800033fc <dirlookup+0x2a>
    800033ec:	892a                	mv	s2,a0
    800033ee:	89ae                	mv	s3,a1
    800033f0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800033f2:	457c                	lw	a5,76(a0)
    800033f4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800033f6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033f8:	e79d                	bnez	a5,80003426 <dirlookup+0x54>
    800033fa:	a8a5                	j	80003472 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800033fc:	00005517          	auipc	a0,0x5
    80003400:	14c50513          	addi	a0,a0,332 # 80008548 <etext+0x548>
    80003404:	00003097          	auipc	ra,0x3
    80003408:	c38080e7          	jalr	-968(ra) # 8000603c <panic>
      panic("dirlookup read");
    8000340c:	00005517          	auipc	a0,0x5
    80003410:	15450513          	addi	a0,a0,340 # 80008560 <etext+0x560>
    80003414:	00003097          	auipc	ra,0x3
    80003418:	c28080e7          	jalr	-984(ra) # 8000603c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000341c:	24c1                	addiw	s1,s1,16
    8000341e:	04c92783          	lw	a5,76(s2)
    80003422:	04f4f763          	bgeu	s1,a5,80003470 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003426:	4741                	li	a4,16
    80003428:	86a6                	mv	a3,s1
    8000342a:	fc040613          	addi	a2,s0,-64
    8000342e:	4581                	li	a1,0
    80003430:	854a                	mv	a0,s2
    80003432:	00000097          	auipc	ra,0x0
    80003436:	d58080e7          	jalr	-680(ra) # 8000318a <readi>
    8000343a:	47c1                	li	a5,16
    8000343c:	fcf518e3          	bne	a0,a5,8000340c <dirlookup+0x3a>
    if(de.inum == 0)
    80003440:	fc045783          	lhu	a5,-64(s0)
    80003444:	dfe1                	beqz	a5,8000341c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003446:	fc240593          	addi	a1,s0,-62
    8000344a:	854e                	mv	a0,s3
    8000344c:	00000097          	auipc	ra,0x0
    80003450:	f6c080e7          	jalr	-148(ra) # 800033b8 <namecmp>
    80003454:	f561                	bnez	a0,8000341c <dirlookup+0x4a>
      if(poff)
    80003456:	000a0463          	beqz	s4,8000345e <dirlookup+0x8c>
        *poff = off;
    8000345a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000345e:	fc045583          	lhu	a1,-64(s0)
    80003462:	00092503          	lw	a0,0(s2)
    80003466:	fffff097          	auipc	ra,0xfffff
    8000346a:	73c080e7          	jalr	1852(ra) # 80002ba2 <iget>
    8000346e:	a011                	j	80003472 <dirlookup+0xa0>
  return 0;
    80003470:	4501                	li	a0,0
}
    80003472:	70e2                	ld	ra,56(sp)
    80003474:	7442                	ld	s0,48(sp)
    80003476:	74a2                	ld	s1,40(sp)
    80003478:	7902                	ld	s2,32(sp)
    8000347a:	69e2                	ld	s3,24(sp)
    8000347c:	6a42                	ld	s4,16(sp)
    8000347e:	6121                	addi	sp,sp,64
    80003480:	8082                	ret

0000000080003482 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003482:	711d                	addi	sp,sp,-96
    80003484:	ec86                	sd	ra,88(sp)
    80003486:	e8a2                	sd	s0,80(sp)
    80003488:	e4a6                	sd	s1,72(sp)
    8000348a:	e0ca                	sd	s2,64(sp)
    8000348c:	fc4e                	sd	s3,56(sp)
    8000348e:	f852                	sd	s4,48(sp)
    80003490:	f456                	sd	s5,40(sp)
    80003492:	f05a                	sd	s6,32(sp)
    80003494:	ec5e                	sd	s7,24(sp)
    80003496:	e862                	sd	s8,16(sp)
    80003498:	e466                	sd	s9,8(sp)
    8000349a:	1080                	addi	s0,sp,96
    8000349c:	84aa                	mv	s1,a0
    8000349e:	8b2e                	mv	s6,a1
    800034a0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800034a2:	00054703          	lbu	a4,0(a0)
    800034a6:	02f00793          	li	a5,47
    800034aa:	02f70263          	beq	a4,a5,800034ce <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800034ae:	ffffe097          	auipc	ra,0xffffe
    800034b2:	c7a080e7          	jalr	-902(ra) # 80001128 <myproc>
    800034b6:	15053503          	ld	a0,336(a0)
    800034ba:	00000097          	auipc	ra,0x0
    800034be:	9da080e7          	jalr	-1574(ra) # 80002e94 <idup>
    800034c2:	8a2a                	mv	s4,a0
  while(*path == '/')
    800034c4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800034c8:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800034ca:	4b85                	li	s7,1
    800034cc:	a875                	j	80003588 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800034ce:	4585                	li	a1,1
    800034d0:	4505                	li	a0,1
    800034d2:	fffff097          	auipc	ra,0xfffff
    800034d6:	6d0080e7          	jalr	1744(ra) # 80002ba2 <iget>
    800034da:	8a2a                	mv	s4,a0
    800034dc:	b7e5                	j	800034c4 <namex+0x42>
      iunlockput(ip);
    800034de:	8552                	mv	a0,s4
    800034e0:	00000097          	auipc	ra,0x0
    800034e4:	c58080e7          	jalr	-936(ra) # 80003138 <iunlockput>
      return 0;
    800034e8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800034ea:	8552                	mv	a0,s4
    800034ec:	60e6                	ld	ra,88(sp)
    800034ee:	6446                	ld	s0,80(sp)
    800034f0:	64a6                	ld	s1,72(sp)
    800034f2:	6906                	ld	s2,64(sp)
    800034f4:	79e2                	ld	s3,56(sp)
    800034f6:	7a42                	ld	s4,48(sp)
    800034f8:	7aa2                	ld	s5,40(sp)
    800034fa:	7b02                	ld	s6,32(sp)
    800034fc:	6be2                	ld	s7,24(sp)
    800034fe:	6c42                	ld	s8,16(sp)
    80003500:	6ca2                	ld	s9,8(sp)
    80003502:	6125                	addi	sp,sp,96
    80003504:	8082                	ret
      iunlock(ip);
    80003506:	8552                	mv	a0,s4
    80003508:	00000097          	auipc	ra,0x0
    8000350c:	a90080e7          	jalr	-1392(ra) # 80002f98 <iunlock>
      return ip;
    80003510:	bfe9                	j	800034ea <namex+0x68>
      iunlockput(ip);
    80003512:	8552                	mv	a0,s4
    80003514:	00000097          	auipc	ra,0x0
    80003518:	c24080e7          	jalr	-988(ra) # 80003138 <iunlockput>
      return 0;
    8000351c:	8a4e                	mv	s4,s3
    8000351e:	b7f1                	j	800034ea <namex+0x68>
  len = path - s;
    80003520:	40998633          	sub	a2,s3,s1
    80003524:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003528:	099c5863          	bge	s8,s9,800035b8 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000352c:	4639                	li	a2,14
    8000352e:	85a6                	mv	a1,s1
    80003530:	8556                	mv	a0,s5
    80003532:	ffffd097          	auipc	ra,0xffffd
    80003536:	e1a080e7          	jalr	-486(ra) # 8000034c <memmove>
    8000353a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000353c:	0004c783          	lbu	a5,0(s1)
    80003540:	01279763          	bne	a5,s2,8000354e <namex+0xcc>
    path++;
    80003544:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003546:	0004c783          	lbu	a5,0(s1)
    8000354a:	ff278de3          	beq	a5,s2,80003544 <namex+0xc2>
    ilock(ip);
    8000354e:	8552                	mv	a0,s4
    80003550:	00000097          	auipc	ra,0x0
    80003554:	982080e7          	jalr	-1662(ra) # 80002ed2 <ilock>
    if(ip->type != T_DIR){
    80003558:	044a1783          	lh	a5,68(s4)
    8000355c:	f97791e3          	bne	a5,s7,800034de <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003560:	000b0563          	beqz	s6,8000356a <namex+0xe8>
    80003564:	0004c783          	lbu	a5,0(s1)
    80003568:	dfd9                	beqz	a5,80003506 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000356a:	4601                	li	a2,0
    8000356c:	85d6                	mv	a1,s5
    8000356e:	8552                	mv	a0,s4
    80003570:	00000097          	auipc	ra,0x0
    80003574:	e62080e7          	jalr	-414(ra) # 800033d2 <dirlookup>
    80003578:	89aa                	mv	s3,a0
    8000357a:	dd41                	beqz	a0,80003512 <namex+0x90>
    iunlockput(ip);
    8000357c:	8552                	mv	a0,s4
    8000357e:	00000097          	auipc	ra,0x0
    80003582:	bba080e7          	jalr	-1094(ra) # 80003138 <iunlockput>
    ip = next;
    80003586:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003588:	0004c783          	lbu	a5,0(s1)
    8000358c:	01279763          	bne	a5,s2,8000359a <namex+0x118>
    path++;
    80003590:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003592:	0004c783          	lbu	a5,0(s1)
    80003596:	ff278de3          	beq	a5,s2,80003590 <namex+0x10e>
  if(*path == 0)
    8000359a:	cb9d                	beqz	a5,800035d0 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000359c:	0004c783          	lbu	a5,0(s1)
    800035a0:	89a6                	mv	s3,s1
  len = path - s;
    800035a2:	4c81                	li	s9,0
    800035a4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800035a6:	01278963          	beq	a5,s2,800035b8 <namex+0x136>
    800035aa:	dbbd                	beqz	a5,80003520 <namex+0x9e>
    path++;
    800035ac:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800035ae:	0009c783          	lbu	a5,0(s3)
    800035b2:	ff279ce3          	bne	a5,s2,800035aa <namex+0x128>
    800035b6:	b7ad                	j	80003520 <namex+0x9e>
    memmove(name, s, len);
    800035b8:	2601                	sext.w	a2,a2
    800035ba:	85a6                	mv	a1,s1
    800035bc:	8556                	mv	a0,s5
    800035be:	ffffd097          	auipc	ra,0xffffd
    800035c2:	d8e080e7          	jalr	-626(ra) # 8000034c <memmove>
    name[len] = 0;
    800035c6:	9cd6                	add	s9,s9,s5
    800035c8:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800035cc:	84ce                	mv	s1,s3
    800035ce:	b7bd                	j	8000353c <namex+0xba>
  if(nameiparent){
    800035d0:	f00b0de3          	beqz	s6,800034ea <namex+0x68>
    iput(ip);
    800035d4:	8552                	mv	a0,s4
    800035d6:	00000097          	auipc	ra,0x0
    800035da:	aba080e7          	jalr	-1350(ra) # 80003090 <iput>
    return 0;
    800035de:	4a01                	li	s4,0
    800035e0:	b729                	j	800034ea <namex+0x68>

00000000800035e2 <dirlink>:
{
    800035e2:	7139                	addi	sp,sp,-64
    800035e4:	fc06                	sd	ra,56(sp)
    800035e6:	f822                	sd	s0,48(sp)
    800035e8:	f04a                	sd	s2,32(sp)
    800035ea:	ec4e                	sd	s3,24(sp)
    800035ec:	e852                	sd	s4,16(sp)
    800035ee:	0080                	addi	s0,sp,64
    800035f0:	892a                	mv	s2,a0
    800035f2:	8a2e                	mv	s4,a1
    800035f4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800035f6:	4601                	li	a2,0
    800035f8:	00000097          	auipc	ra,0x0
    800035fc:	dda080e7          	jalr	-550(ra) # 800033d2 <dirlookup>
    80003600:	ed25                	bnez	a0,80003678 <dirlink+0x96>
    80003602:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003604:	04c92483          	lw	s1,76(s2)
    80003608:	c49d                	beqz	s1,80003636 <dirlink+0x54>
    8000360a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000360c:	4741                	li	a4,16
    8000360e:	86a6                	mv	a3,s1
    80003610:	fc040613          	addi	a2,s0,-64
    80003614:	4581                	li	a1,0
    80003616:	854a                	mv	a0,s2
    80003618:	00000097          	auipc	ra,0x0
    8000361c:	b72080e7          	jalr	-1166(ra) # 8000318a <readi>
    80003620:	47c1                	li	a5,16
    80003622:	06f51163          	bne	a0,a5,80003684 <dirlink+0xa2>
    if(de.inum == 0)
    80003626:	fc045783          	lhu	a5,-64(s0)
    8000362a:	c791                	beqz	a5,80003636 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000362c:	24c1                	addiw	s1,s1,16
    8000362e:	04c92783          	lw	a5,76(s2)
    80003632:	fcf4ede3          	bltu	s1,a5,8000360c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003636:	4639                	li	a2,14
    80003638:	85d2                	mv	a1,s4
    8000363a:	fc240513          	addi	a0,s0,-62
    8000363e:	ffffd097          	auipc	ra,0xffffd
    80003642:	db8080e7          	jalr	-584(ra) # 800003f6 <strncpy>
  de.inum = inum;
    80003646:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000364a:	4741                	li	a4,16
    8000364c:	86a6                	mv	a3,s1
    8000364e:	fc040613          	addi	a2,s0,-64
    80003652:	4581                	li	a1,0
    80003654:	854a                	mv	a0,s2
    80003656:	00000097          	auipc	ra,0x0
    8000365a:	c38080e7          	jalr	-968(ra) # 8000328e <writei>
    8000365e:	872a                	mv	a4,a0
    80003660:	47c1                	li	a5,16
  return 0;
    80003662:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003664:	02f71863          	bne	a4,a5,80003694 <dirlink+0xb2>
    80003668:	74a2                	ld	s1,40(sp)
}
    8000366a:	70e2                	ld	ra,56(sp)
    8000366c:	7442                	ld	s0,48(sp)
    8000366e:	7902                	ld	s2,32(sp)
    80003670:	69e2                	ld	s3,24(sp)
    80003672:	6a42                	ld	s4,16(sp)
    80003674:	6121                	addi	sp,sp,64
    80003676:	8082                	ret
    iput(ip);
    80003678:	00000097          	auipc	ra,0x0
    8000367c:	a18080e7          	jalr	-1512(ra) # 80003090 <iput>
    return -1;
    80003680:	557d                	li	a0,-1
    80003682:	b7e5                	j	8000366a <dirlink+0x88>
      panic("dirlink read");
    80003684:	00005517          	auipc	a0,0x5
    80003688:	eec50513          	addi	a0,a0,-276 # 80008570 <etext+0x570>
    8000368c:	00003097          	auipc	ra,0x3
    80003690:	9b0080e7          	jalr	-1616(ra) # 8000603c <panic>
    panic("dirlink");
    80003694:	00005517          	auipc	a0,0x5
    80003698:	fec50513          	addi	a0,a0,-20 # 80008680 <etext+0x680>
    8000369c:	00003097          	auipc	ra,0x3
    800036a0:	9a0080e7          	jalr	-1632(ra) # 8000603c <panic>

00000000800036a4 <namei>:

struct inode*
namei(char *path)
{
    800036a4:	1101                	addi	sp,sp,-32
    800036a6:	ec06                	sd	ra,24(sp)
    800036a8:	e822                	sd	s0,16(sp)
    800036aa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800036ac:	fe040613          	addi	a2,s0,-32
    800036b0:	4581                	li	a1,0
    800036b2:	00000097          	auipc	ra,0x0
    800036b6:	dd0080e7          	jalr	-560(ra) # 80003482 <namex>
}
    800036ba:	60e2                	ld	ra,24(sp)
    800036bc:	6442                	ld	s0,16(sp)
    800036be:	6105                	addi	sp,sp,32
    800036c0:	8082                	ret

00000000800036c2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800036c2:	1141                	addi	sp,sp,-16
    800036c4:	e406                	sd	ra,8(sp)
    800036c6:	e022                	sd	s0,0(sp)
    800036c8:	0800                	addi	s0,sp,16
    800036ca:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800036cc:	4585                	li	a1,1
    800036ce:	00000097          	auipc	ra,0x0
    800036d2:	db4080e7          	jalr	-588(ra) # 80003482 <namex>
}
    800036d6:	60a2                	ld	ra,8(sp)
    800036d8:	6402                	ld	s0,0(sp)
    800036da:	0141                	addi	sp,sp,16
    800036dc:	8082                	ret

00000000800036de <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800036de:	1101                	addi	sp,sp,-32
    800036e0:	ec06                	sd	ra,24(sp)
    800036e2:	e822                	sd	s0,16(sp)
    800036e4:	e426                	sd	s1,8(sp)
    800036e6:	e04a                	sd	s2,0(sp)
    800036e8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800036ea:	00016917          	auipc	s2,0x16
    800036ee:	95690913          	addi	s2,s2,-1706 # 80019040 <log>
    800036f2:	01892583          	lw	a1,24(s2)
    800036f6:	02892503          	lw	a0,40(s2)
    800036fa:	fffff097          	auipc	ra,0xfffff
    800036fe:	fde080e7          	jalr	-34(ra) # 800026d8 <bread>
    80003702:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003704:	02c92603          	lw	a2,44(s2)
    80003708:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000370a:	00c05f63          	blez	a2,80003728 <write_head+0x4a>
    8000370e:	00016717          	auipc	a4,0x16
    80003712:	96270713          	addi	a4,a4,-1694 # 80019070 <log+0x30>
    80003716:	87aa                	mv	a5,a0
    80003718:	060a                	slli	a2,a2,0x2
    8000371a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000371c:	4314                	lw	a3,0(a4)
    8000371e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003720:	0711                	addi	a4,a4,4
    80003722:	0791                	addi	a5,a5,4
    80003724:	fec79ce3          	bne	a5,a2,8000371c <write_head+0x3e>
  }
  bwrite(buf);
    80003728:	8526                	mv	a0,s1
    8000372a:	fffff097          	auipc	ra,0xfffff
    8000372e:	0a0080e7          	jalr	160(ra) # 800027ca <bwrite>
  brelse(buf);
    80003732:	8526                	mv	a0,s1
    80003734:	fffff097          	auipc	ra,0xfffff
    80003738:	0d4080e7          	jalr	212(ra) # 80002808 <brelse>
}
    8000373c:	60e2                	ld	ra,24(sp)
    8000373e:	6442                	ld	s0,16(sp)
    80003740:	64a2                	ld	s1,8(sp)
    80003742:	6902                	ld	s2,0(sp)
    80003744:	6105                	addi	sp,sp,32
    80003746:	8082                	ret

0000000080003748 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003748:	00016797          	auipc	a5,0x16
    8000374c:	9247a783          	lw	a5,-1756(a5) # 8001906c <log+0x2c>
    80003750:	0af05d63          	blez	a5,8000380a <install_trans+0xc2>
{
    80003754:	7139                	addi	sp,sp,-64
    80003756:	fc06                	sd	ra,56(sp)
    80003758:	f822                	sd	s0,48(sp)
    8000375a:	f426                	sd	s1,40(sp)
    8000375c:	f04a                	sd	s2,32(sp)
    8000375e:	ec4e                	sd	s3,24(sp)
    80003760:	e852                	sd	s4,16(sp)
    80003762:	e456                	sd	s5,8(sp)
    80003764:	e05a                	sd	s6,0(sp)
    80003766:	0080                	addi	s0,sp,64
    80003768:	8b2a                	mv	s6,a0
    8000376a:	00016a97          	auipc	s5,0x16
    8000376e:	906a8a93          	addi	s5,s5,-1786 # 80019070 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003772:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003774:	00016997          	auipc	s3,0x16
    80003778:	8cc98993          	addi	s3,s3,-1844 # 80019040 <log>
    8000377c:	a00d                	j	8000379e <install_trans+0x56>
    brelse(lbuf);
    8000377e:	854a                	mv	a0,s2
    80003780:	fffff097          	auipc	ra,0xfffff
    80003784:	088080e7          	jalr	136(ra) # 80002808 <brelse>
    brelse(dbuf);
    80003788:	8526                	mv	a0,s1
    8000378a:	fffff097          	auipc	ra,0xfffff
    8000378e:	07e080e7          	jalr	126(ra) # 80002808 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003792:	2a05                	addiw	s4,s4,1
    80003794:	0a91                	addi	s5,s5,4
    80003796:	02c9a783          	lw	a5,44(s3)
    8000379a:	04fa5e63          	bge	s4,a5,800037f6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000379e:	0189a583          	lw	a1,24(s3)
    800037a2:	014585bb          	addw	a1,a1,s4
    800037a6:	2585                	addiw	a1,a1,1
    800037a8:	0289a503          	lw	a0,40(s3)
    800037ac:	fffff097          	auipc	ra,0xfffff
    800037b0:	f2c080e7          	jalr	-212(ra) # 800026d8 <bread>
    800037b4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800037b6:	000aa583          	lw	a1,0(s5)
    800037ba:	0289a503          	lw	a0,40(s3)
    800037be:	fffff097          	auipc	ra,0xfffff
    800037c2:	f1a080e7          	jalr	-230(ra) # 800026d8 <bread>
    800037c6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800037c8:	40000613          	li	a2,1024
    800037cc:	05890593          	addi	a1,s2,88
    800037d0:	05850513          	addi	a0,a0,88
    800037d4:	ffffd097          	auipc	ra,0xffffd
    800037d8:	b78080e7          	jalr	-1160(ra) # 8000034c <memmove>
    bwrite(dbuf);  // write dst to disk
    800037dc:	8526                	mv	a0,s1
    800037de:	fffff097          	auipc	ra,0xfffff
    800037e2:	fec080e7          	jalr	-20(ra) # 800027ca <bwrite>
    if(recovering == 0)
    800037e6:	f80b1ce3          	bnez	s6,8000377e <install_trans+0x36>
      bunpin(dbuf);
    800037ea:	8526                	mv	a0,s1
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	0f4080e7          	jalr	244(ra) # 800028e0 <bunpin>
    800037f4:	b769                	j	8000377e <install_trans+0x36>
}
    800037f6:	70e2                	ld	ra,56(sp)
    800037f8:	7442                	ld	s0,48(sp)
    800037fa:	74a2                	ld	s1,40(sp)
    800037fc:	7902                	ld	s2,32(sp)
    800037fe:	69e2                	ld	s3,24(sp)
    80003800:	6a42                	ld	s4,16(sp)
    80003802:	6aa2                	ld	s5,8(sp)
    80003804:	6b02                	ld	s6,0(sp)
    80003806:	6121                	addi	sp,sp,64
    80003808:	8082                	ret
    8000380a:	8082                	ret

000000008000380c <initlog>:
{
    8000380c:	7179                	addi	sp,sp,-48
    8000380e:	f406                	sd	ra,40(sp)
    80003810:	f022                	sd	s0,32(sp)
    80003812:	ec26                	sd	s1,24(sp)
    80003814:	e84a                	sd	s2,16(sp)
    80003816:	e44e                	sd	s3,8(sp)
    80003818:	1800                	addi	s0,sp,48
    8000381a:	892a                	mv	s2,a0
    8000381c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000381e:	00016497          	auipc	s1,0x16
    80003822:	82248493          	addi	s1,s1,-2014 # 80019040 <log>
    80003826:	00005597          	auipc	a1,0x5
    8000382a:	d5a58593          	addi	a1,a1,-678 # 80008580 <etext+0x580>
    8000382e:	8526                	mv	a0,s1
    80003830:	00003097          	auipc	ra,0x3
    80003834:	cf6080e7          	jalr	-778(ra) # 80006526 <initlock>
  log.start = sb->logstart;
    80003838:	0149a583          	lw	a1,20(s3)
    8000383c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000383e:	0109a783          	lw	a5,16(s3)
    80003842:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003844:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003848:	854a                	mv	a0,s2
    8000384a:	fffff097          	auipc	ra,0xfffff
    8000384e:	e8e080e7          	jalr	-370(ra) # 800026d8 <bread>
  log.lh.n = lh->n;
    80003852:	4d30                	lw	a2,88(a0)
    80003854:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003856:	00c05f63          	blez	a2,80003874 <initlog+0x68>
    8000385a:	87aa                	mv	a5,a0
    8000385c:	00016717          	auipc	a4,0x16
    80003860:	81470713          	addi	a4,a4,-2028 # 80019070 <log+0x30>
    80003864:	060a                	slli	a2,a2,0x2
    80003866:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003868:	4ff4                	lw	a3,92(a5)
    8000386a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000386c:	0791                	addi	a5,a5,4
    8000386e:	0711                	addi	a4,a4,4
    80003870:	fec79ce3          	bne	a5,a2,80003868 <initlog+0x5c>
  brelse(buf);
    80003874:	fffff097          	auipc	ra,0xfffff
    80003878:	f94080e7          	jalr	-108(ra) # 80002808 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000387c:	4505                	li	a0,1
    8000387e:	00000097          	auipc	ra,0x0
    80003882:	eca080e7          	jalr	-310(ra) # 80003748 <install_trans>
  log.lh.n = 0;
    80003886:	00015797          	auipc	a5,0x15
    8000388a:	7e07a323          	sw	zero,2022(a5) # 8001906c <log+0x2c>
  write_head(); // clear the log
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	e50080e7          	jalr	-432(ra) # 800036de <write_head>
}
    80003896:	70a2                	ld	ra,40(sp)
    80003898:	7402                	ld	s0,32(sp)
    8000389a:	64e2                	ld	s1,24(sp)
    8000389c:	6942                	ld	s2,16(sp)
    8000389e:	69a2                	ld	s3,8(sp)
    800038a0:	6145                	addi	sp,sp,48
    800038a2:	8082                	ret

00000000800038a4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800038a4:	1101                	addi	sp,sp,-32
    800038a6:	ec06                	sd	ra,24(sp)
    800038a8:	e822                	sd	s0,16(sp)
    800038aa:	e426                	sd	s1,8(sp)
    800038ac:	e04a                	sd	s2,0(sp)
    800038ae:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800038b0:	00015517          	auipc	a0,0x15
    800038b4:	79050513          	addi	a0,a0,1936 # 80019040 <log>
    800038b8:	00003097          	auipc	ra,0x3
    800038bc:	cfe080e7          	jalr	-770(ra) # 800065b6 <acquire>
  while(1){
    if(log.committing){
    800038c0:	00015497          	auipc	s1,0x15
    800038c4:	78048493          	addi	s1,s1,1920 # 80019040 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800038c8:	4979                	li	s2,30
    800038ca:	a039                	j	800038d8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800038cc:	85a6                	mv	a1,s1
    800038ce:	8526                	mv	a0,s1
    800038d0:	ffffe097          	auipc	ra,0xffffe
    800038d4:	f1e080e7          	jalr	-226(ra) # 800017ee <sleep>
    if(log.committing){
    800038d8:	50dc                	lw	a5,36(s1)
    800038da:	fbed                	bnez	a5,800038cc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800038dc:	5098                	lw	a4,32(s1)
    800038de:	2705                	addiw	a4,a4,1
    800038e0:	0027179b          	slliw	a5,a4,0x2
    800038e4:	9fb9                	addw	a5,a5,a4
    800038e6:	0017979b          	slliw	a5,a5,0x1
    800038ea:	54d4                	lw	a3,44(s1)
    800038ec:	9fb5                	addw	a5,a5,a3
    800038ee:	00f95963          	bge	s2,a5,80003900 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800038f2:	85a6                	mv	a1,s1
    800038f4:	8526                	mv	a0,s1
    800038f6:	ffffe097          	auipc	ra,0xffffe
    800038fa:	ef8080e7          	jalr	-264(ra) # 800017ee <sleep>
    800038fe:	bfe9                	j	800038d8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003900:	00015517          	auipc	a0,0x15
    80003904:	74050513          	addi	a0,a0,1856 # 80019040 <log>
    80003908:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000390a:	00003097          	auipc	ra,0x3
    8000390e:	d60080e7          	jalr	-672(ra) # 8000666a <release>
      break;
    }
  }
}
    80003912:	60e2                	ld	ra,24(sp)
    80003914:	6442                	ld	s0,16(sp)
    80003916:	64a2                	ld	s1,8(sp)
    80003918:	6902                	ld	s2,0(sp)
    8000391a:	6105                	addi	sp,sp,32
    8000391c:	8082                	ret

000000008000391e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000391e:	7139                	addi	sp,sp,-64
    80003920:	fc06                	sd	ra,56(sp)
    80003922:	f822                	sd	s0,48(sp)
    80003924:	f426                	sd	s1,40(sp)
    80003926:	f04a                	sd	s2,32(sp)
    80003928:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000392a:	00015497          	auipc	s1,0x15
    8000392e:	71648493          	addi	s1,s1,1814 # 80019040 <log>
    80003932:	8526                	mv	a0,s1
    80003934:	00003097          	auipc	ra,0x3
    80003938:	c82080e7          	jalr	-894(ra) # 800065b6 <acquire>
  log.outstanding -= 1;
    8000393c:	509c                	lw	a5,32(s1)
    8000393e:	37fd                	addiw	a5,a5,-1
    80003940:	0007891b          	sext.w	s2,a5
    80003944:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003946:	50dc                	lw	a5,36(s1)
    80003948:	e7b9                	bnez	a5,80003996 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000394a:	06091163          	bnez	s2,800039ac <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000394e:	00015497          	auipc	s1,0x15
    80003952:	6f248493          	addi	s1,s1,1778 # 80019040 <log>
    80003956:	4785                	li	a5,1
    80003958:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000395a:	8526                	mv	a0,s1
    8000395c:	00003097          	auipc	ra,0x3
    80003960:	d0e080e7          	jalr	-754(ra) # 8000666a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003964:	54dc                	lw	a5,44(s1)
    80003966:	06f04763          	bgtz	a5,800039d4 <end_op+0xb6>
    acquire(&log.lock);
    8000396a:	00015497          	auipc	s1,0x15
    8000396e:	6d648493          	addi	s1,s1,1750 # 80019040 <log>
    80003972:	8526                	mv	a0,s1
    80003974:	00003097          	auipc	ra,0x3
    80003978:	c42080e7          	jalr	-958(ra) # 800065b6 <acquire>
    log.committing = 0;
    8000397c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003980:	8526                	mv	a0,s1
    80003982:	ffffe097          	auipc	ra,0xffffe
    80003986:	ff8080e7          	jalr	-8(ra) # 8000197a <wakeup>
    release(&log.lock);
    8000398a:	8526                	mv	a0,s1
    8000398c:	00003097          	auipc	ra,0x3
    80003990:	cde080e7          	jalr	-802(ra) # 8000666a <release>
}
    80003994:	a815                	j	800039c8 <end_op+0xaa>
    80003996:	ec4e                	sd	s3,24(sp)
    80003998:	e852                	sd	s4,16(sp)
    8000399a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000399c:	00005517          	auipc	a0,0x5
    800039a0:	bec50513          	addi	a0,a0,-1044 # 80008588 <etext+0x588>
    800039a4:	00002097          	auipc	ra,0x2
    800039a8:	698080e7          	jalr	1688(ra) # 8000603c <panic>
    wakeup(&log);
    800039ac:	00015497          	auipc	s1,0x15
    800039b0:	69448493          	addi	s1,s1,1684 # 80019040 <log>
    800039b4:	8526                	mv	a0,s1
    800039b6:	ffffe097          	auipc	ra,0xffffe
    800039ba:	fc4080e7          	jalr	-60(ra) # 8000197a <wakeup>
  release(&log.lock);
    800039be:	8526                	mv	a0,s1
    800039c0:	00003097          	auipc	ra,0x3
    800039c4:	caa080e7          	jalr	-854(ra) # 8000666a <release>
}
    800039c8:	70e2                	ld	ra,56(sp)
    800039ca:	7442                	ld	s0,48(sp)
    800039cc:	74a2                	ld	s1,40(sp)
    800039ce:	7902                	ld	s2,32(sp)
    800039d0:	6121                	addi	sp,sp,64
    800039d2:	8082                	ret
    800039d4:	ec4e                	sd	s3,24(sp)
    800039d6:	e852                	sd	s4,16(sp)
    800039d8:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800039da:	00015a97          	auipc	s5,0x15
    800039de:	696a8a93          	addi	s5,s5,1686 # 80019070 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800039e2:	00015a17          	auipc	s4,0x15
    800039e6:	65ea0a13          	addi	s4,s4,1630 # 80019040 <log>
    800039ea:	018a2583          	lw	a1,24(s4)
    800039ee:	012585bb          	addw	a1,a1,s2
    800039f2:	2585                	addiw	a1,a1,1
    800039f4:	028a2503          	lw	a0,40(s4)
    800039f8:	fffff097          	auipc	ra,0xfffff
    800039fc:	ce0080e7          	jalr	-800(ra) # 800026d8 <bread>
    80003a00:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003a02:	000aa583          	lw	a1,0(s5)
    80003a06:	028a2503          	lw	a0,40(s4)
    80003a0a:	fffff097          	auipc	ra,0xfffff
    80003a0e:	cce080e7          	jalr	-818(ra) # 800026d8 <bread>
    80003a12:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003a14:	40000613          	li	a2,1024
    80003a18:	05850593          	addi	a1,a0,88
    80003a1c:	05848513          	addi	a0,s1,88
    80003a20:	ffffd097          	auipc	ra,0xffffd
    80003a24:	92c080e7          	jalr	-1748(ra) # 8000034c <memmove>
    bwrite(to);  // write the log
    80003a28:	8526                	mv	a0,s1
    80003a2a:	fffff097          	auipc	ra,0xfffff
    80003a2e:	da0080e7          	jalr	-608(ra) # 800027ca <bwrite>
    brelse(from);
    80003a32:	854e                	mv	a0,s3
    80003a34:	fffff097          	auipc	ra,0xfffff
    80003a38:	dd4080e7          	jalr	-556(ra) # 80002808 <brelse>
    brelse(to);
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	fffff097          	auipc	ra,0xfffff
    80003a42:	dca080e7          	jalr	-566(ra) # 80002808 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a46:	2905                	addiw	s2,s2,1
    80003a48:	0a91                	addi	s5,s5,4
    80003a4a:	02ca2783          	lw	a5,44(s4)
    80003a4e:	f8f94ee3          	blt	s2,a5,800039ea <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003a52:	00000097          	auipc	ra,0x0
    80003a56:	c8c080e7          	jalr	-884(ra) # 800036de <write_head>
    install_trans(0); // Now install writes to home locations
    80003a5a:	4501                	li	a0,0
    80003a5c:	00000097          	auipc	ra,0x0
    80003a60:	cec080e7          	jalr	-788(ra) # 80003748 <install_trans>
    log.lh.n = 0;
    80003a64:	00015797          	auipc	a5,0x15
    80003a68:	6007a423          	sw	zero,1544(a5) # 8001906c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003a6c:	00000097          	auipc	ra,0x0
    80003a70:	c72080e7          	jalr	-910(ra) # 800036de <write_head>
    80003a74:	69e2                	ld	s3,24(sp)
    80003a76:	6a42                	ld	s4,16(sp)
    80003a78:	6aa2                	ld	s5,8(sp)
    80003a7a:	bdc5                	j	8000396a <end_op+0x4c>

0000000080003a7c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003a7c:	1101                	addi	sp,sp,-32
    80003a7e:	ec06                	sd	ra,24(sp)
    80003a80:	e822                	sd	s0,16(sp)
    80003a82:	e426                	sd	s1,8(sp)
    80003a84:	e04a                	sd	s2,0(sp)
    80003a86:	1000                	addi	s0,sp,32
    80003a88:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003a8a:	00015917          	auipc	s2,0x15
    80003a8e:	5b690913          	addi	s2,s2,1462 # 80019040 <log>
    80003a92:	854a                	mv	a0,s2
    80003a94:	00003097          	auipc	ra,0x3
    80003a98:	b22080e7          	jalr	-1246(ra) # 800065b6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a9c:	02c92603          	lw	a2,44(s2)
    80003aa0:	47f5                	li	a5,29
    80003aa2:	06c7c563          	blt	a5,a2,80003b0c <log_write+0x90>
    80003aa6:	00015797          	auipc	a5,0x15
    80003aaa:	5b67a783          	lw	a5,1462(a5) # 8001905c <log+0x1c>
    80003aae:	37fd                	addiw	a5,a5,-1
    80003ab0:	04f65e63          	bge	a2,a5,80003b0c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003ab4:	00015797          	auipc	a5,0x15
    80003ab8:	5ac7a783          	lw	a5,1452(a5) # 80019060 <log+0x20>
    80003abc:	06f05063          	blez	a5,80003b1c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003ac0:	4781                	li	a5,0
    80003ac2:	06c05563          	blez	a2,80003b2c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ac6:	44cc                	lw	a1,12(s1)
    80003ac8:	00015717          	auipc	a4,0x15
    80003acc:	5a870713          	addi	a4,a4,1448 # 80019070 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003ad0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ad2:	4314                	lw	a3,0(a4)
    80003ad4:	04b68c63          	beq	a3,a1,80003b2c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003ad8:	2785                	addiw	a5,a5,1
    80003ada:	0711                	addi	a4,a4,4
    80003adc:	fef61be3          	bne	a2,a5,80003ad2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003ae0:	0621                	addi	a2,a2,8
    80003ae2:	060a                	slli	a2,a2,0x2
    80003ae4:	00015797          	auipc	a5,0x15
    80003ae8:	55c78793          	addi	a5,a5,1372 # 80019040 <log>
    80003aec:	97b2                	add	a5,a5,a2
    80003aee:	44d8                	lw	a4,12(s1)
    80003af0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003af2:	8526                	mv	a0,s1
    80003af4:	fffff097          	auipc	ra,0xfffff
    80003af8:	db0080e7          	jalr	-592(ra) # 800028a4 <bpin>
    log.lh.n++;
    80003afc:	00015717          	auipc	a4,0x15
    80003b00:	54470713          	addi	a4,a4,1348 # 80019040 <log>
    80003b04:	575c                	lw	a5,44(a4)
    80003b06:	2785                	addiw	a5,a5,1
    80003b08:	d75c                	sw	a5,44(a4)
    80003b0a:	a82d                	j	80003b44 <log_write+0xc8>
    panic("too big a transaction");
    80003b0c:	00005517          	auipc	a0,0x5
    80003b10:	a8c50513          	addi	a0,a0,-1396 # 80008598 <etext+0x598>
    80003b14:	00002097          	auipc	ra,0x2
    80003b18:	528080e7          	jalr	1320(ra) # 8000603c <panic>
    panic("log_write outside of trans");
    80003b1c:	00005517          	auipc	a0,0x5
    80003b20:	a9450513          	addi	a0,a0,-1388 # 800085b0 <etext+0x5b0>
    80003b24:	00002097          	auipc	ra,0x2
    80003b28:	518080e7          	jalr	1304(ra) # 8000603c <panic>
  log.lh.block[i] = b->blockno;
    80003b2c:	00878693          	addi	a3,a5,8
    80003b30:	068a                	slli	a3,a3,0x2
    80003b32:	00015717          	auipc	a4,0x15
    80003b36:	50e70713          	addi	a4,a4,1294 # 80019040 <log>
    80003b3a:	9736                	add	a4,a4,a3
    80003b3c:	44d4                	lw	a3,12(s1)
    80003b3e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003b40:	faf609e3          	beq	a2,a5,80003af2 <log_write+0x76>
  }
  release(&log.lock);
    80003b44:	00015517          	auipc	a0,0x15
    80003b48:	4fc50513          	addi	a0,a0,1276 # 80019040 <log>
    80003b4c:	00003097          	auipc	ra,0x3
    80003b50:	b1e080e7          	jalr	-1250(ra) # 8000666a <release>
}
    80003b54:	60e2                	ld	ra,24(sp)
    80003b56:	6442                	ld	s0,16(sp)
    80003b58:	64a2                	ld	s1,8(sp)
    80003b5a:	6902                	ld	s2,0(sp)
    80003b5c:	6105                	addi	sp,sp,32
    80003b5e:	8082                	ret

0000000080003b60 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003b60:	1101                	addi	sp,sp,-32
    80003b62:	ec06                	sd	ra,24(sp)
    80003b64:	e822                	sd	s0,16(sp)
    80003b66:	e426                	sd	s1,8(sp)
    80003b68:	e04a                	sd	s2,0(sp)
    80003b6a:	1000                	addi	s0,sp,32
    80003b6c:	84aa                	mv	s1,a0
    80003b6e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003b70:	00005597          	auipc	a1,0x5
    80003b74:	a6058593          	addi	a1,a1,-1440 # 800085d0 <etext+0x5d0>
    80003b78:	0521                	addi	a0,a0,8
    80003b7a:	00003097          	auipc	ra,0x3
    80003b7e:	9ac080e7          	jalr	-1620(ra) # 80006526 <initlock>
  lk->name = name;
    80003b82:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003b86:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b8a:	0204a423          	sw	zero,40(s1)
}
    80003b8e:	60e2                	ld	ra,24(sp)
    80003b90:	6442                	ld	s0,16(sp)
    80003b92:	64a2                	ld	s1,8(sp)
    80003b94:	6902                	ld	s2,0(sp)
    80003b96:	6105                	addi	sp,sp,32
    80003b98:	8082                	ret

0000000080003b9a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b9a:	1101                	addi	sp,sp,-32
    80003b9c:	ec06                	sd	ra,24(sp)
    80003b9e:	e822                	sd	s0,16(sp)
    80003ba0:	e426                	sd	s1,8(sp)
    80003ba2:	e04a                	sd	s2,0(sp)
    80003ba4:	1000                	addi	s0,sp,32
    80003ba6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ba8:	00850913          	addi	s2,a0,8
    80003bac:	854a                	mv	a0,s2
    80003bae:	00003097          	auipc	ra,0x3
    80003bb2:	a08080e7          	jalr	-1528(ra) # 800065b6 <acquire>
  while (lk->locked) {
    80003bb6:	409c                	lw	a5,0(s1)
    80003bb8:	cb89                	beqz	a5,80003bca <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003bba:	85ca                	mv	a1,s2
    80003bbc:	8526                	mv	a0,s1
    80003bbe:	ffffe097          	auipc	ra,0xffffe
    80003bc2:	c30080e7          	jalr	-976(ra) # 800017ee <sleep>
  while (lk->locked) {
    80003bc6:	409c                	lw	a5,0(s1)
    80003bc8:	fbed                	bnez	a5,80003bba <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003bca:	4785                	li	a5,1
    80003bcc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003bce:	ffffd097          	auipc	ra,0xffffd
    80003bd2:	55a080e7          	jalr	1370(ra) # 80001128 <myproc>
    80003bd6:	591c                	lw	a5,48(a0)
    80003bd8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003bda:	854a                	mv	a0,s2
    80003bdc:	00003097          	auipc	ra,0x3
    80003be0:	a8e080e7          	jalr	-1394(ra) # 8000666a <release>
}
    80003be4:	60e2                	ld	ra,24(sp)
    80003be6:	6442                	ld	s0,16(sp)
    80003be8:	64a2                	ld	s1,8(sp)
    80003bea:	6902                	ld	s2,0(sp)
    80003bec:	6105                	addi	sp,sp,32
    80003bee:	8082                	ret

0000000080003bf0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003bf0:	1101                	addi	sp,sp,-32
    80003bf2:	ec06                	sd	ra,24(sp)
    80003bf4:	e822                	sd	s0,16(sp)
    80003bf6:	e426                	sd	s1,8(sp)
    80003bf8:	e04a                	sd	s2,0(sp)
    80003bfa:	1000                	addi	s0,sp,32
    80003bfc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003bfe:	00850913          	addi	s2,a0,8
    80003c02:	854a                	mv	a0,s2
    80003c04:	00003097          	auipc	ra,0x3
    80003c08:	9b2080e7          	jalr	-1614(ra) # 800065b6 <acquire>
  lk->locked = 0;
    80003c0c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c10:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003c14:	8526                	mv	a0,s1
    80003c16:	ffffe097          	auipc	ra,0xffffe
    80003c1a:	d64080e7          	jalr	-668(ra) # 8000197a <wakeup>
  release(&lk->lk);
    80003c1e:	854a                	mv	a0,s2
    80003c20:	00003097          	auipc	ra,0x3
    80003c24:	a4a080e7          	jalr	-1462(ra) # 8000666a <release>
}
    80003c28:	60e2                	ld	ra,24(sp)
    80003c2a:	6442                	ld	s0,16(sp)
    80003c2c:	64a2                	ld	s1,8(sp)
    80003c2e:	6902                	ld	s2,0(sp)
    80003c30:	6105                	addi	sp,sp,32
    80003c32:	8082                	ret

0000000080003c34 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003c34:	7179                	addi	sp,sp,-48
    80003c36:	f406                	sd	ra,40(sp)
    80003c38:	f022                	sd	s0,32(sp)
    80003c3a:	ec26                	sd	s1,24(sp)
    80003c3c:	e84a                	sd	s2,16(sp)
    80003c3e:	1800                	addi	s0,sp,48
    80003c40:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003c42:	00850913          	addi	s2,a0,8
    80003c46:	854a                	mv	a0,s2
    80003c48:	00003097          	auipc	ra,0x3
    80003c4c:	96e080e7          	jalr	-1682(ra) # 800065b6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c50:	409c                	lw	a5,0(s1)
    80003c52:	ef91                	bnez	a5,80003c6e <holdingsleep+0x3a>
    80003c54:	4481                	li	s1,0
  release(&lk->lk);
    80003c56:	854a                	mv	a0,s2
    80003c58:	00003097          	auipc	ra,0x3
    80003c5c:	a12080e7          	jalr	-1518(ra) # 8000666a <release>
  return r;
}
    80003c60:	8526                	mv	a0,s1
    80003c62:	70a2                	ld	ra,40(sp)
    80003c64:	7402                	ld	s0,32(sp)
    80003c66:	64e2                	ld	s1,24(sp)
    80003c68:	6942                	ld	s2,16(sp)
    80003c6a:	6145                	addi	sp,sp,48
    80003c6c:	8082                	ret
    80003c6e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c70:	0284a983          	lw	s3,40(s1)
    80003c74:	ffffd097          	auipc	ra,0xffffd
    80003c78:	4b4080e7          	jalr	1204(ra) # 80001128 <myproc>
    80003c7c:	5904                	lw	s1,48(a0)
    80003c7e:	413484b3          	sub	s1,s1,s3
    80003c82:	0014b493          	seqz	s1,s1
    80003c86:	69a2                	ld	s3,8(sp)
    80003c88:	b7f9                	j	80003c56 <holdingsleep+0x22>

0000000080003c8a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003c8a:	1141                	addi	sp,sp,-16
    80003c8c:	e406                	sd	ra,8(sp)
    80003c8e:	e022                	sd	s0,0(sp)
    80003c90:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003c92:	00005597          	auipc	a1,0x5
    80003c96:	94e58593          	addi	a1,a1,-1714 # 800085e0 <etext+0x5e0>
    80003c9a:	00015517          	auipc	a0,0x15
    80003c9e:	4ee50513          	addi	a0,a0,1262 # 80019188 <ftable>
    80003ca2:	00003097          	auipc	ra,0x3
    80003ca6:	884080e7          	jalr	-1916(ra) # 80006526 <initlock>
}
    80003caa:	60a2                	ld	ra,8(sp)
    80003cac:	6402                	ld	s0,0(sp)
    80003cae:	0141                	addi	sp,sp,16
    80003cb0:	8082                	ret

0000000080003cb2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003cb2:	1101                	addi	sp,sp,-32
    80003cb4:	ec06                	sd	ra,24(sp)
    80003cb6:	e822                	sd	s0,16(sp)
    80003cb8:	e426                	sd	s1,8(sp)
    80003cba:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003cbc:	00015517          	auipc	a0,0x15
    80003cc0:	4cc50513          	addi	a0,a0,1228 # 80019188 <ftable>
    80003cc4:	00003097          	auipc	ra,0x3
    80003cc8:	8f2080e7          	jalr	-1806(ra) # 800065b6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ccc:	00015497          	auipc	s1,0x15
    80003cd0:	4d448493          	addi	s1,s1,1236 # 800191a0 <ftable+0x18>
    80003cd4:	00016717          	auipc	a4,0x16
    80003cd8:	46c70713          	addi	a4,a4,1132 # 8001a140 <ftable+0xfb8>
    if(f->ref == 0){
    80003cdc:	40dc                	lw	a5,4(s1)
    80003cde:	cf99                	beqz	a5,80003cfc <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ce0:	02848493          	addi	s1,s1,40
    80003ce4:	fee49ce3          	bne	s1,a4,80003cdc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ce8:	00015517          	auipc	a0,0x15
    80003cec:	4a050513          	addi	a0,a0,1184 # 80019188 <ftable>
    80003cf0:	00003097          	auipc	ra,0x3
    80003cf4:	97a080e7          	jalr	-1670(ra) # 8000666a <release>
  return 0;
    80003cf8:	4481                	li	s1,0
    80003cfa:	a819                	j	80003d10 <filealloc+0x5e>
      f->ref = 1;
    80003cfc:	4785                	li	a5,1
    80003cfe:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003d00:	00015517          	auipc	a0,0x15
    80003d04:	48850513          	addi	a0,a0,1160 # 80019188 <ftable>
    80003d08:	00003097          	auipc	ra,0x3
    80003d0c:	962080e7          	jalr	-1694(ra) # 8000666a <release>
}
    80003d10:	8526                	mv	a0,s1
    80003d12:	60e2                	ld	ra,24(sp)
    80003d14:	6442                	ld	s0,16(sp)
    80003d16:	64a2                	ld	s1,8(sp)
    80003d18:	6105                	addi	sp,sp,32
    80003d1a:	8082                	ret

0000000080003d1c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003d1c:	1101                	addi	sp,sp,-32
    80003d1e:	ec06                	sd	ra,24(sp)
    80003d20:	e822                	sd	s0,16(sp)
    80003d22:	e426                	sd	s1,8(sp)
    80003d24:	1000                	addi	s0,sp,32
    80003d26:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003d28:	00015517          	auipc	a0,0x15
    80003d2c:	46050513          	addi	a0,a0,1120 # 80019188 <ftable>
    80003d30:	00003097          	auipc	ra,0x3
    80003d34:	886080e7          	jalr	-1914(ra) # 800065b6 <acquire>
  if(f->ref < 1)
    80003d38:	40dc                	lw	a5,4(s1)
    80003d3a:	02f05263          	blez	a5,80003d5e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003d3e:	2785                	addiw	a5,a5,1
    80003d40:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003d42:	00015517          	auipc	a0,0x15
    80003d46:	44650513          	addi	a0,a0,1094 # 80019188 <ftable>
    80003d4a:	00003097          	auipc	ra,0x3
    80003d4e:	920080e7          	jalr	-1760(ra) # 8000666a <release>
  return f;
}
    80003d52:	8526                	mv	a0,s1
    80003d54:	60e2                	ld	ra,24(sp)
    80003d56:	6442                	ld	s0,16(sp)
    80003d58:	64a2                	ld	s1,8(sp)
    80003d5a:	6105                	addi	sp,sp,32
    80003d5c:	8082                	ret
    panic("filedup");
    80003d5e:	00005517          	auipc	a0,0x5
    80003d62:	88a50513          	addi	a0,a0,-1910 # 800085e8 <etext+0x5e8>
    80003d66:	00002097          	auipc	ra,0x2
    80003d6a:	2d6080e7          	jalr	726(ra) # 8000603c <panic>

0000000080003d6e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003d6e:	7139                	addi	sp,sp,-64
    80003d70:	fc06                	sd	ra,56(sp)
    80003d72:	f822                	sd	s0,48(sp)
    80003d74:	f426                	sd	s1,40(sp)
    80003d76:	0080                	addi	s0,sp,64
    80003d78:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003d7a:	00015517          	auipc	a0,0x15
    80003d7e:	40e50513          	addi	a0,a0,1038 # 80019188 <ftable>
    80003d82:	00003097          	auipc	ra,0x3
    80003d86:	834080e7          	jalr	-1996(ra) # 800065b6 <acquire>
  if(f->ref < 1)
    80003d8a:	40dc                	lw	a5,4(s1)
    80003d8c:	04f05c63          	blez	a5,80003de4 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003d90:	37fd                	addiw	a5,a5,-1
    80003d92:	0007871b          	sext.w	a4,a5
    80003d96:	c0dc                	sw	a5,4(s1)
    80003d98:	06e04263          	bgtz	a4,80003dfc <fileclose+0x8e>
    80003d9c:	f04a                	sd	s2,32(sp)
    80003d9e:	ec4e                	sd	s3,24(sp)
    80003da0:	e852                	sd	s4,16(sp)
    80003da2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003da4:	0004a903          	lw	s2,0(s1)
    80003da8:	0094ca83          	lbu	s5,9(s1)
    80003dac:	0104ba03          	ld	s4,16(s1)
    80003db0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003db4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003db8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003dbc:	00015517          	auipc	a0,0x15
    80003dc0:	3cc50513          	addi	a0,a0,972 # 80019188 <ftable>
    80003dc4:	00003097          	auipc	ra,0x3
    80003dc8:	8a6080e7          	jalr	-1882(ra) # 8000666a <release>

  if(ff.type == FD_PIPE){
    80003dcc:	4785                	li	a5,1
    80003dce:	04f90463          	beq	s2,a5,80003e16 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003dd2:	3979                	addiw	s2,s2,-2
    80003dd4:	4785                	li	a5,1
    80003dd6:	0527fb63          	bgeu	a5,s2,80003e2c <fileclose+0xbe>
    80003dda:	7902                	ld	s2,32(sp)
    80003ddc:	69e2                	ld	s3,24(sp)
    80003dde:	6a42                	ld	s4,16(sp)
    80003de0:	6aa2                	ld	s5,8(sp)
    80003de2:	a02d                	j	80003e0c <fileclose+0x9e>
    80003de4:	f04a                	sd	s2,32(sp)
    80003de6:	ec4e                	sd	s3,24(sp)
    80003de8:	e852                	sd	s4,16(sp)
    80003dea:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003dec:	00005517          	auipc	a0,0x5
    80003df0:	80450513          	addi	a0,a0,-2044 # 800085f0 <etext+0x5f0>
    80003df4:	00002097          	auipc	ra,0x2
    80003df8:	248080e7          	jalr	584(ra) # 8000603c <panic>
    release(&ftable.lock);
    80003dfc:	00015517          	auipc	a0,0x15
    80003e00:	38c50513          	addi	a0,a0,908 # 80019188 <ftable>
    80003e04:	00003097          	auipc	ra,0x3
    80003e08:	866080e7          	jalr	-1946(ra) # 8000666a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003e0c:	70e2                	ld	ra,56(sp)
    80003e0e:	7442                	ld	s0,48(sp)
    80003e10:	74a2                	ld	s1,40(sp)
    80003e12:	6121                	addi	sp,sp,64
    80003e14:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003e16:	85d6                	mv	a1,s5
    80003e18:	8552                	mv	a0,s4
    80003e1a:	00000097          	auipc	ra,0x0
    80003e1e:	3a2080e7          	jalr	930(ra) # 800041bc <pipeclose>
    80003e22:	7902                	ld	s2,32(sp)
    80003e24:	69e2                	ld	s3,24(sp)
    80003e26:	6a42                	ld	s4,16(sp)
    80003e28:	6aa2                	ld	s5,8(sp)
    80003e2a:	b7cd                	j	80003e0c <fileclose+0x9e>
    begin_op();
    80003e2c:	00000097          	auipc	ra,0x0
    80003e30:	a78080e7          	jalr	-1416(ra) # 800038a4 <begin_op>
    iput(ff.ip);
    80003e34:	854e                	mv	a0,s3
    80003e36:	fffff097          	auipc	ra,0xfffff
    80003e3a:	25a080e7          	jalr	602(ra) # 80003090 <iput>
    end_op();
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	ae0080e7          	jalr	-1312(ra) # 8000391e <end_op>
    80003e46:	7902                	ld	s2,32(sp)
    80003e48:	69e2                	ld	s3,24(sp)
    80003e4a:	6a42                	ld	s4,16(sp)
    80003e4c:	6aa2                	ld	s5,8(sp)
    80003e4e:	bf7d                	j	80003e0c <fileclose+0x9e>

0000000080003e50 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003e50:	715d                	addi	sp,sp,-80
    80003e52:	e486                	sd	ra,72(sp)
    80003e54:	e0a2                	sd	s0,64(sp)
    80003e56:	fc26                	sd	s1,56(sp)
    80003e58:	f44e                	sd	s3,40(sp)
    80003e5a:	0880                	addi	s0,sp,80
    80003e5c:	84aa                	mv	s1,a0
    80003e5e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003e60:	ffffd097          	auipc	ra,0xffffd
    80003e64:	2c8080e7          	jalr	712(ra) # 80001128 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003e68:	409c                	lw	a5,0(s1)
    80003e6a:	37f9                	addiw	a5,a5,-2
    80003e6c:	4705                	li	a4,1
    80003e6e:	04f76863          	bltu	a4,a5,80003ebe <filestat+0x6e>
    80003e72:	f84a                	sd	s2,48(sp)
    80003e74:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e76:	6c88                	ld	a0,24(s1)
    80003e78:	fffff097          	auipc	ra,0xfffff
    80003e7c:	05a080e7          	jalr	90(ra) # 80002ed2 <ilock>
    stati(f->ip, &st);
    80003e80:	fb840593          	addi	a1,s0,-72
    80003e84:	6c88                	ld	a0,24(s1)
    80003e86:	fffff097          	auipc	ra,0xfffff
    80003e8a:	2da080e7          	jalr	730(ra) # 80003160 <stati>
    iunlock(f->ip);
    80003e8e:	6c88                	ld	a0,24(s1)
    80003e90:	fffff097          	auipc	ra,0xfffff
    80003e94:	108080e7          	jalr	264(ra) # 80002f98 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e98:	46e1                	li	a3,24
    80003e9a:	fb840613          	addi	a2,s0,-72
    80003e9e:	85ce                	mv	a1,s3
    80003ea0:	05093503          	ld	a0,80(s2)
    80003ea4:	ffffd097          	auipc	ra,0xffffd
    80003ea8:	f16080e7          	jalr	-234(ra) # 80000dba <copyout>
    80003eac:	41f5551b          	sraiw	a0,a0,0x1f
    80003eb0:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003eb2:	60a6                	ld	ra,72(sp)
    80003eb4:	6406                	ld	s0,64(sp)
    80003eb6:	74e2                	ld	s1,56(sp)
    80003eb8:	79a2                	ld	s3,40(sp)
    80003eba:	6161                	addi	sp,sp,80
    80003ebc:	8082                	ret
  return -1;
    80003ebe:	557d                	li	a0,-1
    80003ec0:	bfcd                	j	80003eb2 <filestat+0x62>

0000000080003ec2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ec2:	7179                	addi	sp,sp,-48
    80003ec4:	f406                	sd	ra,40(sp)
    80003ec6:	f022                	sd	s0,32(sp)
    80003ec8:	e84a                	sd	s2,16(sp)
    80003eca:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ecc:	00854783          	lbu	a5,8(a0)
    80003ed0:	cbc5                	beqz	a5,80003f80 <fileread+0xbe>
    80003ed2:	ec26                	sd	s1,24(sp)
    80003ed4:	e44e                	sd	s3,8(sp)
    80003ed6:	84aa                	mv	s1,a0
    80003ed8:	89ae                	mv	s3,a1
    80003eda:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003edc:	411c                	lw	a5,0(a0)
    80003ede:	4705                	li	a4,1
    80003ee0:	04e78963          	beq	a5,a4,80003f32 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ee4:	470d                	li	a4,3
    80003ee6:	04e78f63          	beq	a5,a4,80003f44 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003eea:	4709                	li	a4,2
    80003eec:	08e79263          	bne	a5,a4,80003f70 <fileread+0xae>
    ilock(f->ip);
    80003ef0:	6d08                	ld	a0,24(a0)
    80003ef2:	fffff097          	auipc	ra,0xfffff
    80003ef6:	fe0080e7          	jalr	-32(ra) # 80002ed2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003efa:	874a                	mv	a4,s2
    80003efc:	5094                	lw	a3,32(s1)
    80003efe:	864e                	mv	a2,s3
    80003f00:	4585                	li	a1,1
    80003f02:	6c88                	ld	a0,24(s1)
    80003f04:	fffff097          	auipc	ra,0xfffff
    80003f08:	286080e7          	jalr	646(ra) # 8000318a <readi>
    80003f0c:	892a                	mv	s2,a0
    80003f0e:	00a05563          	blez	a0,80003f18 <fileread+0x56>
      f->off += r;
    80003f12:	509c                	lw	a5,32(s1)
    80003f14:	9fa9                	addw	a5,a5,a0
    80003f16:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003f18:	6c88                	ld	a0,24(s1)
    80003f1a:	fffff097          	auipc	ra,0xfffff
    80003f1e:	07e080e7          	jalr	126(ra) # 80002f98 <iunlock>
    80003f22:	64e2                	ld	s1,24(sp)
    80003f24:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003f26:	854a                	mv	a0,s2
    80003f28:	70a2                	ld	ra,40(sp)
    80003f2a:	7402                	ld	s0,32(sp)
    80003f2c:	6942                	ld	s2,16(sp)
    80003f2e:	6145                	addi	sp,sp,48
    80003f30:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003f32:	6908                	ld	a0,16(a0)
    80003f34:	00000097          	auipc	ra,0x0
    80003f38:	3fa080e7          	jalr	1018(ra) # 8000432e <piperead>
    80003f3c:	892a                	mv	s2,a0
    80003f3e:	64e2                	ld	s1,24(sp)
    80003f40:	69a2                	ld	s3,8(sp)
    80003f42:	b7d5                	j	80003f26 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003f44:	02451783          	lh	a5,36(a0)
    80003f48:	03079693          	slli	a3,a5,0x30
    80003f4c:	92c1                	srli	a3,a3,0x30
    80003f4e:	4725                	li	a4,9
    80003f50:	02d76a63          	bltu	a4,a3,80003f84 <fileread+0xc2>
    80003f54:	0792                	slli	a5,a5,0x4
    80003f56:	00015717          	auipc	a4,0x15
    80003f5a:	19270713          	addi	a4,a4,402 # 800190e8 <devsw>
    80003f5e:	97ba                	add	a5,a5,a4
    80003f60:	639c                	ld	a5,0(a5)
    80003f62:	c78d                	beqz	a5,80003f8c <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003f64:	4505                	li	a0,1
    80003f66:	9782                	jalr	a5
    80003f68:	892a                	mv	s2,a0
    80003f6a:	64e2                	ld	s1,24(sp)
    80003f6c:	69a2                	ld	s3,8(sp)
    80003f6e:	bf65                	j	80003f26 <fileread+0x64>
    panic("fileread");
    80003f70:	00004517          	auipc	a0,0x4
    80003f74:	69050513          	addi	a0,a0,1680 # 80008600 <etext+0x600>
    80003f78:	00002097          	auipc	ra,0x2
    80003f7c:	0c4080e7          	jalr	196(ra) # 8000603c <panic>
    return -1;
    80003f80:	597d                	li	s2,-1
    80003f82:	b755                	j	80003f26 <fileread+0x64>
      return -1;
    80003f84:	597d                	li	s2,-1
    80003f86:	64e2                	ld	s1,24(sp)
    80003f88:	69a2                	ld	s3,8(sp)
    80003f8a:	bf71                	j	80003f26 <fileread+0x64>
    80003f8c:	597d                	li	s2,-1
    80003f8e:	64e2                	ld	s1,24(sp)
    80003f90:	69a2                	ld	s3,8(sp)
    80003f92:	bf51                	j	80003f26 <fileread+0x64>

0000000080003f94 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003f94:	00954783          	lbu	a5,9(a0)
    80003f98:	12078963          	beqz	a5,800040ca <filewrite+0x136>
{
    80003f9c:	715d                	addi	sp,sp,-80
    80003f9e:	e486                	sd	ra,72(sp)
    80003fa0:	e0a2                	sd	s0,64(sp)
    80003fa2:	f84a                	sd	s2,48(sp)
    80003fa4:	f052                	sd	s4,32(sp)
    80003fa6:	e85a                	sd	s6,16(sp)
    80003fa8:	0880                	addi	s0,sp,80
    80003faa:	892a                	mv	s2,a0
    80003fac:	8b2e                	mv	s6,a1
    80003fae:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003fb0:	411c                	lw	a5,0(a0)
    80003fb2:	4705                	li	a4,1
    80003fb4:	02e78763          	beq	a5,a4,80003fe2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003fb8:	470d                	li	a4,3
    80003fba:	02e78a63          	beq	a5,a4,80003fee <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003fbe:	4709                	li	a4,2
    80003fc0:	0ee79863          	bne	a5,a4,800040b0 <filewrite+0x11c>
    80003fc4:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003fc6:	0cc05463          	blez	a2,8000408e <filewrite+0xfa>
    80003fca:	fc26                	sd	s1,56(sp)
    80003fcc:	ec56                	sd	s5,24(sp)
    80003fce:	e45e                	sd	s7,8(sp)
    80003fd0:	e062                	sd	s8,0(sp)
    int i = 0;
    80003fd2:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003fd4:	6b85                	lui	s7,0x1
    80003fd6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003fda:	6c05                	lui	s8,0x1
    80003fdc:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003fe0:	a851                	j	80004074 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003fe2:	6908                	ld	a0,16(a0)
    80003fe4:	00000097          	auipc	ra,0x0
    80003fe8:	248080e7          	jalr	584(ra) # 8000422c <pipewrite>
    80003fec:	a85d                	j	800040a2 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003fee:	02451783          	lh	a5,36(a0)
    80003ff2:	03079693          	slli	a3,a5,0x30
    80003ff6:	92c1                	srli	a3,a3,0x30
    80003ff8:	4725                	li	a4,9
    80003ffa:	0cd76a63          	bltu	a4,a3,800040ce <filewrite+0x13a>
    80003ffe:	0792                	slli	a5,a5,0x4
    80004000:	00015717          	auipc	a4,0x15
    80004004:	0e870713          	addi	a4,a4,232 # 800190e8 <devsw>
    80004008:	97ba                	add	a5,a5,a4
    8000400a:	679c                	ld	a5,8(a5)
    8000400c:	c3f9                	beqz	a5,800040d2 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    8000400e:	4505                	li	a0,1
    80004010:	9782                	jalr	a5
    80004012:	a841                	j	800040a2 <filewrite+0x10e>
      if(n1 > max)
    80004014:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004018:	00000097          	auipc	ra,0x0
    8000401c:	88c080e7          	jalr	-1908(ra) # 800038a4 <begin_op>
      ilock(f->ip);
    80004020:	01893503          	ld	a0,24(s2)
    80004024:	fffff097          	auipc	ra,0xfffff
    80004028:	eae080e7          	jalr	-338(ra) # 80002ed2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000402c:	8756                	mv	a4,s5
    8000402e:	02092683          	lw	a3,32(s2)
    80004032:	01698633          	add	a2,s3,s6
    80004036:	4585                	li	a1,1
    80004038:	01893503          	ld	a0,24(s2)
    8000403c:	fffff097          	auipc	ra,0xfffff
    80004040:	252080e7          	jalr	594(ra) # 8000328e <writei>
    80004044:	84aa                	mv	s1,a0
    80004046:	00a05763          	blez	a0,80004054 <filewrite+0xc0>
        f->off += r;
    8000404a:	02092783          	lw	a5,32(s2)
    8000404e:	9fa9                	addw	a5,a5,a0
    80004050:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004054:	01893503          	ld	a0,24(s2)
    80004058:	fffff097          	auipc	ra,0xfffff
    8000405c:	f40080e7          	jalr	-192(ra) # 80002f98 <iunlock>
      end_op();
    80004060:	00000097          	auipc	ra,0x0
    80004064:	8be080e7          	jalr	-1858(ra) # 8000391e <end_op>

      if(r != n1){
    80004068:	029a9563          	bne	s5,s1,80004092 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    8000406c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004070:	0149da63          	bge	s3,s4,80004084 <filewrite+0xf0>
      int n1 = n - i;
    80004074:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004078:	0004879b          	sext.w	a5,s1
    8000407c:	f8fbdce3          	bge	s7,a5,80004014 <filewrite+0x80>
    80004080:	84e2                	mv	s1,s8
    80004082:	bf49                	j	80004014 <filewrite+0x80>
    80004084:	74e2                	ld	s1,56(sp)
    80004086:	6ae2                	ld	s5,24(sp)
    80004088:	6ba2                	ld	s7,8(sp)
    8000408a:	6c02                	ld	s8,0(sp)
    8000408c:	a039                	j	8000409a <filewrite+0x106>
    int i = 0;
    8000408e:	4981                	li	s3,0
    80004090:	a029                	j	8000409a <filewrite+0x106>
    80004092:	74e2                	ld	s1,56(sp)
    80004094:	6ae2                	ld	s5,24(sp)
    80004096:	6ba2                	ld	s7,8(sp)
    80004098:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000409a:	033a1e63          	bne	s4,s3,800040d6 <filewrite+0x142>
    8000409e:	8552                	mv	a0,s4
    800040a0:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800040a2:	60a6                	ld	ra,72(sp)
    800040a4:	6406                	ld	s0,64(sp)
    800040a6:	7942                	ld	s2,48(sp)
    800040a8:	7a02                	ld	s4,32(sp)
    800040aa:	6b42                	ld	s6,16(sp)
    800040ac:	6161                	addi	sp,sp,80
    800040ae:	8082                	ret
    800040b0:	fc26                	sd	s1,56(sp)
    800040b2:	f44e                	sd	s3,40(sp)
    800040b4:	ec56                	sd	s5,24(sp)
    800040b6:	e45e                	sd	s7,8(sp)
    800040b8:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800040ba:	00004517          	auipc	a0,0x4
    800040be:	55650513          	addi	a0,a0,1366 # 80008610 <etext+0x610>
    800040c2:	00002097          	auipc	ra,0x2
    800040c6:	f7a080e7          	jalr	-134(ra) # 8000603c <panic>
    return -1;
    800040ca:	557d                	li	a0,-1
}
    800040cc:	8082                	ret
      return -1;
    800040ce:	557d                	li	a0,-1
    800040d0:	bfc9                	j	800040a2 <filewrite+0x10e>
    800040d2:	557d                	li	a0,-1
    800040d4:	b7f9                	j	800040a2 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    800040d6:	557d                	li	a0,-1
    800040d8:	79a2                	ld	s3,40(sp)
    800040da:	b7e1                	j	800040a2 <filewrite+0x10e>

00000000800040dc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800040dc:	7179                	addi	sp,sp,-48
    800040de:	f406                	sd	ra,40(sp)
    800040e0:	f022                	sd	s0,32(sp)
    800040e2:	ec26                	sd	s1,24(sp)
    800040e4:	e052                	sd	s4,0(sp)
    800040e6:	1800                	addi	s0,sp,48
    800040e8:	84aa                	mv	s1,a0
    800040ea:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800040ec:	0005b023          	sd	zero,0(a1)
    800040f0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800040f4:	00000097          	auipc	ra,0x0
    800040f8:	bbe080e7          	jalr	-1090(ra) # 80003cb2 <filealloc>
    800040fc:	e088                	sd	a0,0(s1)
    800040fe:	cd49                	beqz	a0,80004198 <pipealloc+0xbc>
    80004100:	00000097          	auipc	ra,0x0
    80004104:	bb2080e7          	jalr	-1102(ra) # 80003cb2 <filealloc>
    80004108:	00aa3023          	sd	a0,0(s4)
    8000410c:	c141                	beqz	a0,8000418c <pipealloc+0xb0>
    8000410e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004110:	ffffc097          	auipc	ra,0xffffc
    80004114:	0c2080e7          	jalr	194(ra) # 800001d2 <kalloc>
    80004118:	892a                	mv	s2,a0
    8000411a:	c13d                	beqz	a0,80004180 <pipealloc+0xa4>
    8000411c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000411e:	4985                	li	s3,1
    80004120:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004124:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004128:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000412c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004130:	00004597          	auipc	a1,0x4
    80004134:	4f058593          	addi	a1,a1,1264 # 80008620 <etext+0x620>
    80004138:	00002097          	auipc	ra,0x2
    8000413c:	3ee080e7          	jalr	1006(ra) # 80006526 <initlock>
  (*f0)->type = FD_PIPE;
    80004140:	609c                	ld	a5,0(s1)
    80004142:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004146:	609c                	ld	a5,0(s1)
    80004148:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000414c:	609c                	ld	a5,0(s1)
    8000414e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004152:	609c                	ld	a5,0(s1)
    80004154:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004158:	000a3783          	ld	a5,0(s4)
    8000415c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004160:	000a3783          	ld	a5,0(s4)
    80004164:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004168:	000a3783          	ld	a5,0(s4)
    8000416c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004170:	000a3783          	ld	a5,0(s4)
    80004174:	0127b823          	sd	s2,16(a5)
  return 0;
    80004178:	4501                	li	a0,0
    8000417a:	6942                	ld	s2,16(sp)
    8000417c:	69a2                	ld	s3,8(sp)
    8000417e:	a03d                	j	800041ac <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004180:	6088                	ld	a0,0(s1)
    80004182:	c119                	beqz	a0,80004188 <pipealloc+0xac>
    80004184:	6942                	ld	s2,16(sp)
    80004186:	a029                	j	80004190 <pipealloc+0xb4>
    80004188:	6942                	ld	s2,16(sp)
    8000418a:	a039                	j	80004198 <pipealloc+0xbc>
    8000418c:	6088                	ld	a0,0(s1)
    8000418e:	c50d                	beqz	a0,800041b8 <pipealloc+0xdc>
    fileclose(*f0);
    80004190:	00000097          	auipc	ra,0x0
    80004194:	bde080e7          	jalr	-1058(ra) # 80003d6e <fileclose>
  if(*f1)
    80004198:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000419c:	557d                	li	a0,-1
  if(*f1)
    8000419e:	c799                	beqz	a5,800041ac <pipealloc+0xd0>
    fileclose(*f1);
    800041a0:	853e                	mv	a0,a5
    800041a2:	00000097          	auipc	ra,0x0
    800041a6:	bcc080e7          	jalr	-1076(ra) # 80003d6e <fileclose>
  return -1;
    800041aa:	557d                	li	a0,-1
}
    800041ac:	70a2                	ld	ra,40(sp)
    800041ae:	7402                	ld	s0,32(sp)
    800041b0:	64e2                	ld	s1,24(sp)
    800041b2:	6a02                	ld	s4,0(sp)
    800041b4:	6145                	addi	sp,sp,48
    800041b6:	8082                	ret
  return -1;
    800041b8:	557d                	li	a0,-1
    800041ba:	bfcd                	j	800041ac <pipealloc+0xd0>

00000000800041bc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800041bc:	1101                	addi	sp,sp,-32
    800041be:	ec06                	sd	ra,24(sp)
    800041c0:	e822                	sd	s0,16(sp)
    800041c2:	e426                	sd	s1,8(sp)
    800041c4:	e04a                	sd	s2,0(sp)
    800041c6:	1000                	addi	s0,sp,32
    800041c8:	84aa                	mv	s1,a0
    800041ca:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800041cc:	00002097          	auipc	ra,0x2
    800041d0:	3ea080e7          	jalr	1002(ra) # 800065b6 <acquire>
  if(writable){
    800041d4:	02090d63          	beqz	s2,8000420e <pipeclose+0x52>
    pi->writeopen = 0;
    800041d8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800041dc:	21848513          	addi	a0,s1,536
    800041e0:	ffffd097          	auipc	ra,0xffffd
    800041e4:	79a080e7          	jalr	1946(ra) # 8000197a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800041e8:	2204b783          	ld	a5,544(s1)
    800041ec:	eb95                	bnez	a5,80004220 <pipeclose+0x64>
    release(&pi->lock);
    800041ee:	8526                	mv	a0,s1
    800041f0:	00002097          	auipc	ra,0x2
    800041f4:	47a080e7          	jalr	1146(ra) # 8000666a <release>
    kfree((char*)pi);
    800041f8:	8526                	mv	a0,s1
    800041fa:	ffffc097          	auipc	ra,0xffffc
    800041fe:	e22080e7          	jalr	-478(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004202:	60e2                	ld	ra,24(sp)
    80004204:	6442                	ld	s0,16(sp)
    80004206:	64a2                	ld	s1,8(sp)
    80004208:	6902                	ld	s2,0(sp)
    8000420a:	6105                	addi	sp,sp,32
    8000420c:	8082                	ret
    pi->readopen = 0;
    8000420e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004212:	21c48513          	addi	a0,s1,540
    80004216:	ffffd097          	auipc	ra,0xffffd
    8000421a:	764080e7          	jalr	1892(ra) # 8000197a <wakeup>
    8000421e:	b7e9                	j	800041e8 <pipeclose+0x2c>
    release(&pi->lock);
    80004220:	8526                	mv	a0,s1
    80004222:	00002097          	auipc	ra,0x2
    80004226:	448080e7          	jalr	1096(ra) # 8000666a <release>
}
    8000422a:	bfe1                	j	80004202 <pipeclose+0x46>

000000008000422c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000422c:	711d                	addi	sp,sp,-96
    8000422e:	ec86                	sd	ra,88(sp)
    80004230:	e8a2                	sd	s0,80(sp)
    80004232:	e4a6                	sd	s1,72(sp)
    80004234:	e0ca                	sd	s2,64(sp)
    80004236:	fc4e                	sd	s3,56(sp)
    80004238:	f852                	sd	s4,48(sp)
    8000423a:	f456                	sd	s5,40(sp)
    8000423c:	1080                	addi	s0,sp,96
    8000423e:	84aa                	mv	s1,a0
    80004240:	8aae                	mv	s5,a1
    80004242:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004244:	ffffd097          	auipc	ra,0xffffd
    80004248:	ee4080e7          	jalr	-284(ra) # 80001128 <myproc>
    8000424c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000424e:	8526                	mv	a0,s1
    80004250:	00002097          	auipc	ra,0x2
    80004254:	366080e7          	jalr	870(ra) # 800065b6 <acquire>
  while(i < n){
    80004258:	0d405563          	blez	s4,80004322 <pipewrite+0xf6>
    8000425c:	f05a                	sd	s6,32(sp)
    8000425e:	ec5e                	sd	s7,24(sp)
    80004260:	e862                	sd	s8,16(sp)
  int i = 0;
    80004262:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004264:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004266:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000426a:	21c48b93          	addi	s7,s1,540
    8000426e:	a089                	j	800042b0 <pipewrite+0x84>
      release(&pi->lock);
    80004270:	8526                	mv	a0,s1
    80004272:	00002097          	auipc	ra,0x2
    80004276:	3f8080e7          	jalr	1016(ra) # 8000666a <release>
      return -1;
    8000427a:	597d                	li	s2,-1
    8000427c:	7b02                	ld	s6,32(sp)
    8000427e:	6be2                	ld	s7,24(sp)
    80004280:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004282:	854a                	mv	a0,s2
    80004284:	60e6                	ld	ra,88(sp)
    80004286:	6446                	ld	s0,80(sp)
    80004288:	64a6                	ld	s1,72(sp)
    8000428a:	6906                	ld	s2,64(sp)
    8000428c:	79e2                	ld	s3,56(sp)
    8000428e:	7a42                	ld	s4,48(sp)
    80004290:	7aa2                	ld	s5,40(sp)
    80004292:	6125                	addi	sp,sp,96
    80004294:	8082                	ret
      wakeup(&pi->nread);
    80004296:	8562                	mv	a0,s8
    80004298:	ffffd097          	auipc	ra,0xffffd
    8000429c:	6e2080e7          	jalr	1762(ra) # 8000197a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800042a0:	85a6                	mv	a1,s1
    800042a2:	855e                	mv	a0,s7
    800042a4:	ffffd097          	auipc	ra,0xffffd
    800042a8:	54a080e7          	jalr	1354(ra) # 800017ee <sleep>
  while(i < n){
    800042ac:	05495c63          	bge	s2,s4,80004304 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    800042b0:	2204a783          	lw	a5,544(s1)
    800042b4:	dfd5                	beqz	a5,80004270 <pipewrite+0x44>
    800042b6:	0289a783          	lw	a5,40(s3)
    800042ba:	fbdd                	bnez	a5,80004270 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800042bc:	2184a783          	lw	a5,536(s1)
    800042c0:	21c4a703          	lw	a4,540(s1)
    800042c4:	2007879b          	addiw	a5,a5,512
    800042c8:	fcf707e3          	beq	a4,a5,80004296 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800042cc:	4685                	li	a3,1
    800042ce:	01590633          	add	a2,s2,s5
    800042d2:	faf40593          	addi	a1,s0,-81
    800042d6:	0509b503          	ld	a0,80(s3)
    800042da:	ffffd097          	auipc	ra,0xffffd
    800042de:	996080e7          	jalr	-1642(ra) # 80000c70 <copyin>
    800042e2:	05650263          	beq	a0,s6,80004326 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800042e6:	21c4a783          	lw	a5,540(s1)
    800042ea:	0017871b          	addiw	a4,a5,1
    800042ee:	20e4ae23          	sw	a4,540(s1)
    800042f2:	1ff7f793          	andi	a5,a5,511
    800042f6:	97a6                	add	a5,a5,s1
    800042f8:	faf44703          	lbu	a4,-81(s0)
    800042fc:	00e78c23          	sb	a4,24(a5)
      i++;
    80004300:	2905                	addiw	s2,s2,1
    80004302:	b76d                	j	800042ac <pipewrite+0x80>
    80004304:	7b02                	ld	s6,32(sp)
    80004306:	6be2                	ld	s7,24(sp)
    80004308:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000430a:	21848513          	addi	a0,s1,536
    8000430e:	ffffd097          	auipc	ra,0xffffd
    80004312:	66c080e7          	jalr	1644(ra) # 8000197a <wakeup>
  release(&pi->lock);
    80004316:	8526                	mv	a0,s1
    80004318:	00002097          	auipc	ra,0x2
    8000431c:	352080e7          	jalr	850(ra) # 8000666a <release>
  return i;
    80004320:	b78d                	j	80004282 <pipewrite+0x56>
  int i = 0;
    80004322:	4901                	li	s2,0
    80004324:	b7dd                	j	8000430a <pipewrite+0xde>
    80004326:	7b02                	ld	s6,32(sp)
    80004328:	6be2                	ld	s7,24(sp)
    8000432a:	6c42                	ld	s8,16(sp)
    8000432c:	bff9                	j	8000430a <pipewrite+0xde>

000000008000432e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000432e:	715d                	addi	sp,sp,-80
    80004330:	e486                	sd	ra,72(sp)
    80004332:	e0a2                	sd	s0,64(sp)
    80004334:	fc26                	sd	s1,56(sp)
    80004336:	f84a                	sd	s2,48(sp)
    80004338:	f44e                	sd	s3,40(sp)
    8000433a:	f052                	sd	s4,32(sp)
    8000433c:	ec56                	sd	s5,24(sp)
    8000433e:	0880                	addi	s0,sp,80
    80004340:	84aa                	mv	s1,a0
    80004342:	892e                	mv	s2,a1
    80004344:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004346:	ffffd097          	auipc	ra,0xffffd
    8000434a:	de2080e7          	jalr	-542(ra) # 80001128 <myproc>
    8000434e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004350:	8526                	mv	a0,s1
    80004352:	00002097          	auipc	ra,0x2
    80004356:	264080e7          	jalr	612(ra) # 800065b6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000435a:	2184a703          	lw	a4,536(s1)
    8000435e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004362:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004366:	02f71663          	bne	a4,a5,80004392 <piperead+0x64>
    8000436a:	2244a783          	lw	a5,548(s1)
    8000436e:	cb9d                	beqz	a5,800043a4 <piperead+0x76>
    if(pr->killed){
    80004370:	028a2783          	lw	a5,40(s4)
    80004374:	e38d                	bnez	a5,80004396 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004376:	85a6                	mv	a1,s1
    80004378:	854e                	mv	a0,s3
    8000437a:	ffffd097          	auipc	ra,0xffffd
    8000437e:	474080e7          	jalr	1140(ra) # 800017ee <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004382:	2184a703          	lw	a4,536(s1)
    80004386:	21c4a783          	lw	a5,540(s1)
    8000438a:	fef700e3          	beq	a4,a5,8000436a <piperead+0x3c>
    8000438e:	e85a                	sd	s6,16(sp)
    80004390:	a819                	j	800043a6 <piperead+0x78>
    80004392:	e85a                	sd	s6,16(sp)
    80004394:	a809                	j	800043a6 <piperead+0x78>
      release(&pi->lock);
    80004396:	8526                	mv	a0,s1
    80004398:	00002097          	auipc	ra,0x2
    8000439c:	2d2080e7          	jalr	722(ra) # 8000666a <release>
      return -1;
    800043a0:	59fd                	li	s3,-1
    800043a2:	a0a5                	j	8000440a <piperead+0xdc>
    800043a4:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043a6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800043a8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043aa:	05505463          	blez	s5,800043f2 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    800043ae:	2184a783          	lw	a5,536(s1)
    800043b2:	21c4a703          	lw	a4,540(s1)
    800043b6:	02f70e63          	beq	a4,a5,800043f2 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800043ba:	0017871b          	addiw	a4,a5,1
    800043be:	20e4ac23          	sw	a4,536(s1)
    800043c2:	1ff7f793          	andi	a5,a5,511
    800043c6:	97a6                	add	a5,a5,s1
    800043c8:	0187c783          	lbu	a5,24(a5)
    800043cc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800043d0:	4685                	li	a3,1
    800043d2:	fbf40613          	addi	a2,s0,-65
    800043d6:	85ca                	mv	a1,s2
    800043d8:	050a3503          	ld	a0,80(s4)
    800043dc:	ffffd097          	auipc	ra,0xffffd
    800043e0:	9de080e7          	jalr	-1570(ra) # 80000dba <copyout>
    800043e4:	01650763          	beq	a0,s6,800043f2 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043e8:	2985                	addiw	s3,s3,1
    800043ea:	0905                	addi	s2,s2,1
    800043ec:	fd3a91e3          	bne	s5,s3,800043ae <piperead+0x80>
    800043f0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800043f2:	21c48513          	addi	a0,s1,540
    800043f6:	ffffd097          	auipc	ra,0xffffd
    800043fa:	584080e7          	jalr	1412(ra) # 8000197a <wakeup>
  release(&pi->lock);
    800043fe:	8526                	mv	a0,s1
    80004400:	00002097          	auipc	ra,0x2
    80004404:	26a080e7          	jalr	618(ra) # 8000666a <release>
    80004408:	6b42                	ld	s6,16(sp)
  return i;
}
    8000440a:	854e                	mv	a0,s3
    8000440c:	60a6                	ld	ra,72(sp)
    8000440e:	6406                	ld	s0,64(sp)
    80004410:	74e2                	ld	s1,56(sp)
    80004412:	7942                	ld	s2,48(sp)
    80004414:	79a2                	ld	s3,40(sp)
    80004416:	7a02                	ld	s4,32(sp)
    80004418:	6ae2                	ld	s5,24(sp)
    8000441a:	6161                	addi	sp,sp,80
    8000441c:	8082                	ret

000000008000441e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000441e:	df010113          	addi	sp,sp,-528
    80004422:	20113423          	sd	ra,520(sp)
    80004426:	20813023          	sd	s0,512(sp)
    8000442a:	ffa6                	sd	s1,504(sp)
    8000442c:	fbca                	sd	s2,496(sp)
    8000442e:	0c00                	addi	s0,sp,528
    80004430:	892a                	mv	s2,a0
    80004432:	dea43c23          	sd	a0,-520(s0)
    80004436:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000443a:	ffffd097          	auipc	ra,0xffffd
    8000443e:	cee080e7          	jalr	-786(ra) # 80001128 <myproc>
    80004442:	84aa                	mv	s1,a0

  begin_op();
    80004444:	fffff097          	auipc	ra,0xfffff
    80004448:	460080e7          	jalr	1120(ra) # 800038a4 <begin_op>

  if((ip = namei(path)) == 0){
    8000444c:	854a                	mv	a0,s2
    8000444e:	fffff097          	auipc	ra,0xfffff
    80004452:	256080e7          	jalr	598(ra) # 800036a4 <namei>
    80004456:	c135                	beqz	a0,800044ba <exec+0x9c>
    80004458:	f3d2                	sd	s4,480(sp)
    8000445a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000445c:	fffff097          	auipc	ra,0xfffff
    80004460:	a76080e7          	jalr	-1418(ra) # 80002ed2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004464:	04000713          	li	a4,64
    80004468:	4681                	li	a3,0
    8000446a:	e5040613          	addi	a2,s0,-432
    8000446e:	4581                	li	a1,0
    80004470:	8552                	mv	a0,s4
    80004472:	fffff097          	auipc	ra,0xfffff
    80004476:	d18080e7          	jalr	-744(ra) # 8000318a <readi>
    8000447a:	04000793          	li	a5,64
    8000447e:	00f51a63          	bne	a0,a5,80004492 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004482:	e5042703          	lw	a4,-432(s0)
    80004486:	464c47b7          	lui	a5,0x464c4
    8000448a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000448e:	02f70c63          	beq	a4,a5,800044c6 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004492:	8552                	mv	a0,s4
    80004494:	fffff097          	auipc	ra,0xfffff
    80004498:	ca4080e7          	jalr	-860(ra) # 80003138 <iunlockput>
    end_op();
    8000449c:	fffff097          	auipc	ra,0xfffff
    800044a0:	482080e7          	jalr	1154(ra) # 8000391e <end_op>
  }
  return -1;
    800044a4:	557d                	li	a0,-1
    800044a6:	7a1e                	ld	s4,480(sp)
}
    800044a8:	20813083          	ld	ra,520(sp)
    800044ac:	20013403          	ld	s0,512(sp)
    800044b0:	74fe                	ld	s1,504(sp)
    800044b2:	795e                	ld	s2,496(sp)
    800044b4:	21010113          	addi	sp,sp,528
    800044b8:	8082                	ret
    end_op();
    800044ba:	fffff097          	auipc	ra,0xfffff
    800044be:	464080e7          	jalr	1124(ra) # 8000391e <end_op>
    return -1;
    800044c2:	557d                	li	a0,-1
    800044c4:	b7d5                	j	800044a8 <exec+0x8a>
    800044c6:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800044c8:	8526                	mv	a0,s1
    800044ca:	ffffd097          	auipc	ra,0xffffd
    800044ce:	d22080e7          	jalr	-734(ra) # 800011ec <proc_pagetable>
    800044d2:	8b2a                	mv	s6,a0
    800044d4:	30050563          	beqz	a0,800047de <exec+0x3c0>
    800044d8:	f7ce                	sd	s3,488(sp)
    800044da:	efd6                	sd	s5,472(sp)
    800044dc:	e7de                	sd	s7,456(sp)
    800044de:	e3e2                	sd	s8,448(sp)
    800044e0:	ff66                	sd	s9,440(sp)
    800044e2:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044e4:	e7042d03          	lw	s10,-400(s0)
    800044e8:	e8845783          	lhu	a5,-376(s0)
    800044ec:	14078563          	beqz	a5,80004636 <exec+0x218>
    800044f0:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044f2:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044f4:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    800044f6:	6c85                	lui	s9,0x1
    800044f8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800044fc:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004500:	6a85                	lui	s5,0x1
    80004502:	a0b5                	j	8000456e <exec+0x150>
      panic("loadseg: address should exist");
    80004504:	00004517          	auipc	a0,0x4
    80004508:	12450513          	addi	a0,a0,292 # 80008628 <etext+0x628>
    8000450c:	00002097          	auipc	ra,0x2
    80004510:	b30080e7          	jalr	-1232(ra) # 8000603c <panic>
    if(sz - i < PGSIZE)
    80004514:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004516:	8726                	mv	a4,s1
    80004518:	012c06bb          	addw	a3,s8,s2
    8000451c:	4581                	li	a1,0
    8000451e:	8552                	mv	a0,s4
    80004520:	fffff097          	auipc	ra,0xfffff
    80004524:	c6a080e7          	jalr	-918(ra) # 8000318a <readi>
    80004528:	2501                	sext.w	a0,a0
    8000452a:	26a49e63          	bne	s1,a0,800047a6 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000452e:	012a893b          	addw	s2,s5,s2
    80004532:	03397563          	bgeu	s2,s3,8000455c <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004536:	02091593          	slli	a1,s2,0x20
    8000453a:	9181                	srli	a1,a1,0x20
    8000453c:	95de                	add	a1,a1,s7
    8000453e:	855a                	mv	a0,s6
    80004540:	ffffc097          	auipc	ra,0xffffc
    80004544:	12e080e7          	jalr	302(ra) # 8000066e <walkaddr>
    80004548:	862a                	mv	a2,a0
    if(pa == 0)
    8000454a:	dd4d                	beqz	a0,80004504 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000454c:	412984bb          	subw	s1,s3,s2
    80004550:	0004879b          	sext.w	a5,s1
    80004554:	fcfcf0e3          	bgeu	s9,a5,80004514 <exec+0xf6>
    80004558:	84d6                	mv	s1,s5
    8000455a:	bf6d                	j	80004514 <exec+0xf6>
    sz = sz1;
    8000455c:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004560:	2d85                	addiw	s11,s11,1
    80004562:	038d0d1b          	addiw	s10,s10,56
    80004566:	e8845783          	lhu	a5,-376(s0)
    8000456a:	06fddf63          	bge	s11,a5,800045e8 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000456e:	2d01                	sext.w	s10,s10
    80004570:	03800713          	li	a4,56
    80004574:	86ea                	mv	a3,s10
    80004576:	e1840613          	addi	a2,s0,-488
    8000457a:	4581                	li	a1,0
    8000457c:	8552                	mv	a0,s4
    8000457e:	fffff097          	auipc	ra,0xfffff
    80004582:	c0c080e7          	jalr	-1012(ra) # 8000318a <readi>
    80004586:	03800793          	li	a5,56
    8000458a:	1ef51863          	bne	a0,a5,8000477a <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    8000458e:	e1842783          	lw	a5,-488(s0)
    80004592:	4705                	li	a4,1
    80004594:	fce796e3          	bne	a5,a4,80004560 <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004598:	e4043603          	ld	a2,-448(s0)
    8000459c:	e3843783          	ld	a5,-456(s0)
    800045a0:	1ef66163          	bltu	a2,a5,80004782 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045a4:	e2843783          	ld	a5,-472(s0)
    800045a8:	963e                	add	a2,a2,a5
    800045aa:	1ef66063          	bltu	a2,a5,8000478a <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045ae:	85a6                	mv	a1,s1
    800045b0:	855a                	mv	a0,s6
    800045b2:	ffffc097          	auipc	ra,0xffffc
    800045b6:	46a080e7          	jalr	1130(ra) # 80000a1c <uvmalloc>
    800045ba:	e0a43423          	sd	a0,-504(s0)
    800045be:	1c050a63          	beqz	a0,80004792 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    800045c2:	e2843b83          	ld	s7,-472(s0)
    800045c6:	df043783          	ld	a5,-528(s0)
    800045ca:	00fbf7b3          	and	a5,s7,a5
    800045ce:	1c079a63          	bnez	a5,800047a2 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045d2:	e2042c03          	lw	s8,-480(s0)
    800045d6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045da:	00098463          	beqz	s3,800045e2 <exec+0x1c4>
    800045de:	4901                	li	s2,0
    800045e0:	bf99                	j	80004536 <exec+0x118>
    sz = sz1;
    800045e2:	e0843483          	ld	s1,-504(s0)
    800045e6:	bfad                	j	80004560 <exec+0x142>
    800045e8:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800045ea:	8552                	mv	a0,s4
    800045ec:	fffff097          	auipc	ra,0xfffff
    800045f0:	b4c080e7          	jalr	-1204(ra) # 80003138 <iunlockput>
  end_op();
    800045f4:	fffff097          	auipc	ra,0xfffff
    800045f8:	32a080e7          	jalr	810(ra) # 8000391e <end_op>
  p = myproc();
    800045fc:	ffffd097          	auipc	ra,0xffffd
    80004600:	b2c080e7          	jalr	-1236(ra) # 80001128 <myproc>
    80004604:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004606:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000460a:	6985                	lui	s3,0x1
    8000460c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000460e:	99a6                	add	s3,s3,s1
    80004610:	77fd                	lui	a5,0xfffff
    80004612:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004616:	6609                	lui	a2,0x2
    80004618:	964e                	add	a2,a2,s3
    8000461a:	85ce                	mv	a1,s3
    8000461c:	855a                	mv	a0,s6
    8000461e:	ffffc097          	auipc	ra,0xffffc
    80004622:	3fe080e7          	jalr	1022(ra) # 80000a1c <uvmalloc>
    80004626:	892a                	mv	s2,a0
    80004628:	e0a43423          	sd	a0,-504(s0)
    8000462c:	e519                	bnez	a0,8000463a <exec+0x21c>
  if(pagetable)
    8000462e:	e1343423          	sd	s3,-504(s0)
    80004632:	4a01                	li	s4,0
    80004634:	aa95                	j	800047a8 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004636:	4481                	li	s1,0
    80004638:	bf4d                	j	800045ea <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000463a:	75f9                	lui	a1,0xffffe
    8000463c:	95aa                	add	a1,a1,a0
    8000463e:	855a                	mv	a0,s6
    80004640:	ffffc097          	auipc	ra,0xffffc
    80004644:	5fe080e7          	jalr	1534(ra) # 80000c3e <uvmclear>
  stackbase = sp - PGSIZE;
    80004648:	7bfd                	lui	s7,0xfffff
    8000464a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000464c:	e0043783          	ld	a5,-512(s0)
    80004650:	6388                	ld	a0,0(a5)
    80004652:	c52d                	beqz	a0,800046bc <exec+0x29e>
    80004654:	e9040993          	addi	s3,s0,-368
    80004658:	f9040c13          	addi	s8,s0,-112
    8000465c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000465e:	ffffc097          	auipc	ra,0xffffc
    80004662:	e06080e7          	jalr	-506(ra) # 80000464 <strlen>
    80004666:	0015079b          	addiw	a5,a0,1
    8000466a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000466e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004672:	13796463          	bltu	s2,s7,8000479a <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004676:	e0043d03          	ld	s10,-512(s0)
    8000467a:	000d3a03          	ld	s4,0(s10)
    8000467e:	8552                	mv	a0,s4
    80004680:	ffffc097          	auipc	ra,0xffffc
    80004684:	de4080e7          	jalr	-540(ra) # 80000464 <strlen>
    80004688:	0015069b          	addiw	a3,a0,1
    8000468c:	8652                	mv	a2,s4
    8000468e:	85ca                	mv	a1,s2
    80004690:	855a                	mv	a0,s6
    80004692:	ffffc097          	auipc	ra,0xffffc
    80004696:	728080e7          	jalr	1832(ra) # 80000dba <copyout>
    8000469a:	10054263          	bltz	a0,8000479e <exec+0x380>
    ustack[argc] = sp;
    8000469e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800046a2:	0485                	addi	s1,s1,1
    800046a4:	008d0793          	addi	a5,s10,8
    800046a8:	e0f43023          	sd	a5,-512(s0)
    800046ac:	008d3503          	ld	a0,8(s10)
    800046b0:	c909                	beqz	a0,800046c2 <exec+0x2a4>
    if(argc >= MAXARG)
    800046b2:	09a1                	addi	s3,s3,8
    800046b4:	fb8995e3          	bne	s3,s8,8000465e <exec+0x240>
  ip = 0;
    800046b8:	4a01                	li	s4,0
    800046ba:	a0fd                	j	800047a8 <exec+0x38a>
  sp = sz;
    800046bc:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800046c0:	4481                	li	s1,0
  ustack[argc] = 0;
    800046c2:	00349793          	slli	a5,s1,0x3
    800046c6:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    800046ca:	97a2                	add	a5,a5,s0
    800046cc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800046d0:	00148693          	addi	a3,s1,1
    800046d4:	068e                	slli	a3,a3,0x3
    800046d6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800046da:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800046de:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800046e2:	f57966e3          	bltu	s2,s7,8000462e <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800046e6:	e9040613          	addi	a2,s0,-368
    800046ea:	85ca                	mv	a1,s2
    800046ec:	855a                	mv	a0,s6
    800046ee:	ffffc097          	auipc	ra,0xffffc
    800046f2:	6cc080e7          	jalr	1740(ra) # 80000dba <copyout>
    800046f6:	0e054663          	bltz	a0,800047e2 <exec+0x3c4>
  p->trapframe->a1 = sp;
    800046fa:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800046fe:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004702:	df843783          	ld	a5,-520(s0)
    80004706:	0007c703          	lbu	a4,0(a5)
    8000470a:	cf11                	beqz	a4,80004726 <exec+0x308>
    8000470c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000470e:	02f00693          	li	a3,47
    80004712:	a039                	j	80004720 <exec+0x302>
      last = s+1;
    80004714:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004718:	0785                	addi	a5,a5,1
    8000471a:	fff7c703          	lbu	a4,-1(a5)
    8000471e:	c701                	beqz	a4,80004726 <exec+0x308>
    if(*s == '/')
    80004720:	fed71ce3          	bne	a4,a3,80004718 <exec+0x2fa>
    80004724:	bfc5                	j	80004714 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004726:	4641                	li	a2,16
    80004728:	df843583          	ld	a1,-520(s0)
    8000472c:	158a8513          	addi	a0,s5,344
    80004730:	ffffc097          	auipc	ra,0xffffc
    80004734:	d02080e7          	jalr	-766(ra) # 80000432 <safestrcpy>
  oldpagetable = p->pagetable;
    80004738:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000473c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004740:	e0843783          	ld	a5,-504(s0)
    80004744:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004748:	058ab783          	ld	a5,88(s5)
    8000474c:	e6843703          	ld	a4,-408(s0)
    80004750:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004752:	058ab783          	ld	a5,88(s5)
    80004756:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000475a:	85e6                	mv	a1,s9
    8000475c:	ffffd097          	auipc	ra,0xffffd
    80004760:	b2c080e7          	jalr	-1236(ra) # 80001288 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004764:	0004851b          	sext.w	a0,s1
    80004768:	79be                	ld	s3,488(sp)
    8000476a:	7a1e                	ld	s4,480(sp)
    8000476c:	6afe                	ld	s5,472(sp)
    8000476e:	6b5e                	ld	s6,464(sp)
    80004770:	6bbe                	ld	s7,456(sp)
    80004772:	6c1e                	ld	s8,448(sp)
    80004774:	7cfa                	ld	s9,440(sp)
    80004776:	7d5a                	ld	s10,432(sp)
    80004778:	bb05                	j	800044a8 <exec+0x8a>
    8000477a:	e0943423          	sd	s1,-504(s0)
    8000477e:	7dba                	ld	s11,424(sp)
    80004780:	a025                	j	800047a8 <exec+0x38a>
    80004782:	e0943423          	sd	s1,-504(s0)
    80004786:	7dba                	ld	s11,424(sp)
    80004788:	a005                	j	800047a8 <exec+0x38a>
    8000478a:	e0943423          	sd	s1,-504(s0)
    8000478e:	7dba                	ld	s11,424(sp)
    80004790:	a821                	j	800047a8 <exec+0x38a>
    80004792:	e0943423          	sd	s1,-504(s0)
    80004796:	7dba                	ld	s11,424(sp)
    80004798:	a801                	j	800047a8 <exec+0x38a>
  ip = 0;
    8000479a:	4a01                	li	s4,0
    8000479c:	a031                	j	800047a8 <exec+0x38a>
    8000479e:	4a01                	li	s4,0
  if(pagetable)
    800047a0:	a021                	j	800047a8 <exec+0x38a>
    800047a2:	7dba                	ld	s11,424(sp)
    800047a4:	a011                	j	800047a8 <exec+0x38a>
    800047a6:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800047a8:	e0843583          	ld	a1,-504(s0)
    800047ac:	855a                	mv	a0,s6
    800047ae:	ffffd097          	auipc	ra,0xffffd
    800047b2:	ada080e7          	jalr	-1318(ra) # 80001288 <proc_freepagetable>
  return -1;
    800047b6:	557d                	li	a0,-1
  if(ip){
    800047b8:	000a1b63          	bnez	s4,800047ce <exec+0x3b0>
    800047bc:	79be                	ld	s3,488(sp)
    800047be:	7a1e                	ld	s4,480(sp)
    800047c0:	6afe                	ld	s5,472(sp)
    800047c2:	6b5e                	ld	s6,464(sp)
    800047c4:	6bbe                	ld	s7,456(sp)
    800047c6:	6c1e                	ld	s8,448(sp)
    800047c8:	7cfa                	ld	s9,440(sp)
    800047ca:	7d5a                	ld	s10,432(sp)
    800047cc:	b9f1                	j	800044a8 <exec+0x8a>
    800047ce:	79be                	ld	s3,488(sp)
    800047d0:	6afe                	ld	s5,472(sp)
    800047d2:	6b5e                	ld	s6,464(sp)
    800047d4:	6bbe                	ld	s7,456(sp)
    800047d6:	6c1e                	ld	s8,448(sp)
    800047d8:	7cfa                	ld	s9,440(sp)
    800047da:	7d5a                	ld	s10,432(sp)
    800047dc:	b95d                	j	80004492 <exec+0x74>
    800047de:	6b5e                	ld	s6,464(sp)
    800047e0:	b94d                	j	80004492 <exec+0x74>
  sz = sz1;
    800047e2:	e0843983          	ld	s3,-504(s0)
    800047e6:	b5a1                	j	8000462e <exec+0x210>

00000000800047e8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800047e8:	7179                	addi	sp,sp,-48
    800047ea:	f406                	sd	ra,40(sp)
    800047ec:	f022                	sd	s0,32(sp)
    800047ee:	ec26                	sd	s1,24(sp)
    800047f0:	e84a                	sd	s2,16(sp)
    800047f2:	1800                	addi	s0,sp,48
    800047f4:	892e                	mv	s2,a1
    800047f6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800047f8:	fdc40593          	addi	a1,s0,-36
    800047fc:	ffffe097          	auipc	ra,0xffffe
    80004800:	b64080e7          	jalr	-1180(ra) # 80002360 <argint>
    80004804:	04054063          	bltz	a0,80004844 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004808:	fdc42703          	lw	a4,-36(s0)
    8000480c:	47bd                	li	a5,15
    8000480e:	02e7ed63          	bltu	a5,a4,80004848 <argfd+0x60>
    80004812:	ffffd097          	auipc	ra,0xffffd
    80004816:	916080e7          	jalr	-1770(ra) # 80001128 <myproc>
    8000481a:	fdc42703          	lw	a4,-36(s0)
    8000481e:	01a70793          	addi	a5,a4,26
    80004822:	078e                	slli	a5,a5,0x3
    80004824:	953e                	add	a0,a0,a5
    80004826:	611c                	ld	a5,0(a0)
    80004828:	c395                	beqz	a5,8000484c <argfd+0x64>
    return -1;
  if(pfd)
    8000482a:	00090463          	beqz	s2,80004832 <argfd+0x4a>
    *pfd = fd;
    8000482e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004832:	4501                	li	a0,0
  if(pf)
    80004834:	c091                	beqz	s1,80004838 <argfd+0x50>
    *pf = f;
    80004836:	e09c                	sd	a5,0(s1)
}
    80004838:	70a2                	ld	ra,40(sp)
    8000483a:	7402                	ld	s0,32(sp)
    8000483c:	64e2                	ld	s1,24(sp)
    8000483e:	6942                	ld	s2,16(sp)
    80004840:	6145                	addi	sp,sp,48
    80004842:	8082                	ret
    return -1;
    80004844:	557d                	li	a0,-1
    80004846:	bfcd                	j	80004838 <argfd+0x50>
    return -1;
    80004848:	557d                	li	a0,-1
    8000484a:	b7fd                	j	80004838 <argfd+0x50>
    8000484c:	557d                	li	a0,-1
    8000484e:	b7ed                	j	80004838 <argfd+0x50>

0000000080004850 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004850:	1101                	addi	sp,sp,-32
    80004852:	ec06                	sd	ra,24(sp)
    80004854:	e822                	sd	s0,16(sp)
    80004856:	e426                	sd	s1,8(sp)
    80004858:	1000                	addi	s0,sp,32
    8000485a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000485c:	ffffd097          	auipc	ra,0xffffd
    80004860:	8cc080e7          	jalr	-1844(ra) # 80001128 <myproc>
    80004864:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004866:	0d050793          	addi	a5,a0,208
    8000486a:	4501                	li	a0,0
    8000486c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000486e:	6398                	ld	a4,0(a5)
    80004870:	cb19                	beqz	a4,80004886 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004872:	2505                	addiw	a0,a0,1
    80004874:	07a1                	addi	a5,a5,8
    80004876:	fed51ce3          	bne	a0,a3,8000486e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000487a:	557d                	li	a0,-1
}
    8000487c:	60e2                	ld	ra,24(sp)
    8000487e:	6442                	ld	s0,16(sp)
    80004880:	64a2                	ld	s1,8(sp)
    80004882:	6105                	addi	sp,sp,32
    80004884:	8082                	ret
      p->ofile[fd] = f;
    80004886:	01a50793          	addi	a5,a0,26
    8000488a:	078e                	slli	a5,a5,0x3
    8000488c:	963e                	add	a2,a2,a5
    8000488e:	e204                	sd	s1,0(a2)
      return fd;
    80004890:	b7f5                	j	8000487c <fdalloc+0x2c>

0000000080004892 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004892:	715d                	addi	sp,sp,-80
    80004894:	e486                	sd	ra,72(sp)
    80004896:	e0a2                	sd	s0,64(sp)
    80004898:	fc26                	sd	s1,56(sp)
    8000489a:	f84a                	sd	s2,48(sp)
    8000489c:	f44e                	sd	s3,40(sp)
    8000489e:	f052                	sd	s4,32(sp)
    800048a0:	ec56                	sd	s5,24(sp)
    800048a2:	0880                	addi	s0,sp,80
    800048a4:	8aae                	mv	s5,a1
    800048a6:	8a32                	mv	s4,a2
    800048a8:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800048aa:	fb040593          	addi	a1,s0,-80
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	e14080e7          	jalr	-492(ra) # 800036c2 <nameiparent>
    800048b6:	892a                	mv	s2,a0
    800048b8:	12050c63          	beqz	a0,800049f0 <create+0x15e>
    return 0;

  ilock(dp);
    800048bc:	ffffe097          	auipc	ra,0xffffe
    800048c0:	616080e7          	jalr	1558(ra) # 80002ed2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800048c4:	4601                	li	a2,0
    800048c6:	fb040593          	addi	a1,s0,-80
    800048ca:	854a                	mv	a0,s2
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	b06080e7          	jalr	-1274(ra) # 800033d2 <dirlookup>
    800048d4:	84aa                	mv	s1,a0
    800048d6:	c539                	beqz	a0,80004924 <create+0x92>
    iunlockput(dp);
    800048d8:	854a                	mv	a0,s2
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	85e080e7          	jalr	-1954(ra) # 80003138 <iunlockput>
    ilock(ip);
    800048e2:	8526                	mv	a0,s1
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	5ee080e7          	jalr	1518(ra) # 80002ed2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800048ec:	4789                	li	a5,2
    800048ee:	02fa9463          	bne	s5,a5,80004916 <create+0x84>
    800048f2:	0444d783          	lhu	a5,68(s1)
    800048f6:	37f9                	addiw	a5,a5,-2
    800048f8:	17c2                	slli	a5,a5,0x30
    800048fa:	93c1                	srli	a5,a5,0x30
    800048fc:	4705                	li	a4,1
    800048fe:	00f76c63          	bltu	a4,a5,80004916 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004902:	8526                	mv	a0,s1
    80004904:	60a6                	ld	ra,72(sp)
    80004906:	6406                	ld	s0,64(sp)
    80004908:	74e2                	ld	s1,56(sp)
    8000490a:	7942                	ld	s2,48(sp)
    8000490c:	79a2                	ld	s3,40(sp)
    8000490e:	7a02                	ld	s4,32(sp)
    80004910:	6ae2                	ld	s5,24(sp)
    80004912:	6161                	addi	sp,sp,80
    80004914:	8082                	ret
    iunlockput(ip);
    80004916:	8526                	mv	a0,s1
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	820080e7          	jalr	-2016(ra) # 80003138 <iunlockput>
    return 0;
    80004920:	4481                	li	s1,0
    80004922:	b7c5                	j	80004902 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004924:	85d6                	mv	a1,s5
    80004926:	00092503          	lw	a0,0(s2)
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	414080e7          	jalr	1044(ra) # 80002d3e <ialloc>
    80004932:	84aa                	mv	s1,a0
    80004934:	c139                	beqz	a0,8000497a <create+0xe8>
  ilock(ip);
    80004936:	ffffe097          	auipc	ra,0xffffe
    8000493a:	59c080e7          	jalr	1436(ra) # 80002ed2 <ilock>
  ip->major = major;
    8000493e:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004942:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004946:	4985                	li	s3,1
    80004948:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000494c:	8526                	mv	a0,s1
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	4b8080e7          	jalr	1208(ra) # 80002e06 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004956:	033a8a63          	beq	s5,s3,8000498a <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000495a:	40d0                	lw	a2,4(s1)
    8000495c:	fb040593          	addi	a1,s0,-80
    80004960:	854a                	mv	a0,s2
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	c80080e7          	jalr	-896(ra) # 800035e2 <dirlink>
    8000496a:	06054b63          	bltz	a0,800049e0 <create+0x14e>
  iunlockput(dp);
    8000496e:	854a                	mv	a0,s2
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	7c8080e7          	jalr	1992(ra) # 80003138 <iunlockput>
  return ip;
    80004978:	b769                	j	80004902 <create+0x70>
    panic("create: ialloc");
    8000497a:	00004517          	auipc	a0,0x4
    8000497e:	cce50513          	addi	a0,a0,-818 # 80008648 <etext+0x648>
    80004982:	00001097          	auipc	ra,0x1
    80004986:	6ba080e7          	jalr	1722(ra) # 8000603c <panic>
    dp->nlink++;  // for ".."
    8000498a:	04a95783          	lhu	a5,74(s2)
    8000498e:	2785                	addiw	a5,a5,1
    80004990:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004994:	854a                	mv	a0,s2
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	470080e7          	jalr	1136(ra) # 80002e06 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000499e:	40d0                	lw	a2,4(s1)
    800049a0:	00004597          	auipc	a1,0x4
    800049a4:	cb858593          	addi	a1,a1,-840 # 80008658 <etext+0x658>
    800049a8:	8526                	mv	a0,s1
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	c38080e7          	jalr	-968(ra) # 800035e2 <dirlink>
    800049b2:	00054f63          	bltz	a0,800049d0 <create+0x13e>
    800049b6:	00492603          	lw	a2,4(s2)
    800049ba:	00004597          	auipc	a1,0x4
    800049be:	ca658593          	addi	a1,a1,-858 # 80008660 <etext+0x660>
    800049c2:	8526                	mv	a0,s1
    800049c4:	fffff097          	auipc	ra,0xfffff
    800049c8:	c1e080e7          	jalr	-994(ra) # 800035e2 <dirlink>
    800049cc:	f80557e3          	bgez	a0,8000495a <create+0xc8>
      panic("create dots");
    800049d0:	00004517          	auipc	a0,0x4
    800049d4:	c9850513          	addi	a0,a0,-872 # 80008668 <etext+0x668>
    800049d8:	00001097          	auipc	ra,0x1
    800049dc:	664080e7          	jalr	1636(ra) # 8000603c <panic>
    panic("create: dirlink");
    800049e0:	00004517          	auipc	a0,0x4
    800049e4:	c9850513          	addi	a0,a0,-872 # 80008678 <etext+0x678>
    800049e8:	00001097          	auipc	ra,0x1
    800049ec:	654080e7          	jalr	1620(ra) # 8000603c <panic>
    return 0;
    800049f0:	84aa                	mv	s1,a0
    800049f2:	bf01                	j	80004902 <create+0x70>

00000000800049f4 <sys_dup>:
{
    800049f4:	7179                	addi	sp,sp,-48
    800049f6:	f406                	sd	ra,40(sp)
    800049f8:	f022                	sd	s0,32(sp)
    800049fa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800049fc:	fd840613          	addi	a2,s0,-40
    80004a00:	4581                	li	a1,0
    80004a02:	4501                	li	a0,0
    80004a04:	00000097          	auipc	ra,0x0
    80004a08:	de4080e7          	jalr	-540(ra) # 800047e8 <argfd>
    return -1;
    80004a0c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004a0e:	02054763          	bltz	a0,80004a3c <sys_dup+0x48>
    80004a12:	ec26                	sd	s1,24(sp)
    80004a14:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004a16:	fd843903          	ld	s2,-40(s0)
    80004a1a:	854a                	mv	a0,s2
    80004a1c:	00000097          	auipc	ra,0x0
    80004a20:	e34080e7          	jalr	-460(ra) # 80004850 <fdalloc>
    80004a24:	84aa                	mv	s1,a0
    return -1;
    80004a26:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004a28:	00054f63          	bltz	a0,80004a46 <sys_dup+0x52>
  filedup(f);
    80004a2c:	854a                	mv	a0,s2
    80004a2e:	fffff097          	auipc	ra,0xfffff
    80004a32:	2ee080e7          	jalr	750(ra) # 80003d1c <filedup>
  return fd;
    80004a36:	87a6                	mv	a5,s1
    80004a38:	64e2                	ld	s1,24(sp)
    80004a3a:	6942                	ld	s2,16(sp)
}
    80004a3c:	853e                	mv	a0,a5
    80004a3e:	70a2                	ld	ra,40(sp)
    80004a40:	7402                	ld	s0,32(sp)
    80004a42:	6145                	addi	sp,sp,48
    80004a44:	8082                	ret
    80004a46:	64e2                	ld	s1,24(sp)
    80004a48:	6942                	ld	s2,16(sp)
    80004a4a:	bfcd                	j	80004a3c <sys_dup+0x48>

0000000080004a4c <sys_read>:
{
    80004a4c:	7179                	addi	sp,sp,-48
    80004a4e:	f406                	sd	ra,40(sp)
    80004a50:	f022                	sd	s0,32(sp)
    80004a52:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a54:	fe840613          	addi	a2,s0,-24
    80004a58:	4581                	li	a1,0
    80004a5a:	4501                	li	a0,0
    80004a5c:	00000097          	auipc	ra,0x0
    80004a60:	d8c080e7          	jalr	-628(ra) # 800047e8 <argfd>
    return -1;
    80004a64:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a66:	04054163          	bltz	a0,80004aa8 <sys_read+0x5c>
    80004a6a:	fe440593          	addi	a1,s0,-28
    80004a6e:	4509                	li	a0,2
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	8f0080e7          	jalr	-1808(ra) # 80002360 <argint>
    return -1;
    80004a78:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a7a:	02054763          	bltz	a0,80004aa8 <sys_read+0x5c>
    80004a7e:	fd840593          	addi	a1,s0,-40
    80004a82:	4505                	li	a0,1
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	8fe080e7          	jalr	-1794(ra) # 80002382 <argaddr>
    return -1;
    80004a8c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a8e:	00054d63          	bltz	a0,80004aa8 <sys_read+0x5c>
  return fileread(f, p, n);
    80004a92:	fe442603          	lw	a2,-28(s0)
    80004a96:	fd843583          	ld	a1,-40(s0)
    80004a9a:	fe843503          	ld	a0,-24(s0)
    80004a9e:	fffff097          	auipc	ra,0xfffff
    80004aa2:	424080e7          	jalr	1060(ra) # 80003ec2 <fileread>
    80004aa6:	87aa                	mv	a5,a0
}
    80004aa8:	853e                	mv	a0,a5
    80004aaa:	70a2                	ld	ra,40(sp)
    80004aac:	7402                	ld	s0,32(sp)
    80004aae:	6145                	addi	sp,sp,48
    80004ab0:	8082                	ret

0000000080004ab2 <sys_write>:
{
    80004ab2:	7179                	addi	sp,sp,-48
    80004ab4:	f406                	sd	ra,40(sp)
    80004ab6:	f022                	sd	s0,32(sp)
    80004ab8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004aba:	fe840613          	addi	a2,s0,-24
    80004abe:	4581                	li	a1,0
    80004ac0:	4501                	li	a0,0
    80004ac2:	00000097          	auipc	ra,0x0
    80004ac6:	d26080e7          	jalr	-730(ra) # 800047e8 <argfd>
    return -1;
    80004aca:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004acc:	04054163          	bltz	a0,80004b0e <sys_write+0x5c>
    80004ad0:	fe440593          	addi	a1,s0,-28
    80004ad4:	4509                	li	a0,2
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	88a080e7          	jalr	-1910(ra) # 80002360 <argint>
    return -1;
    80004ade:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004ae0:	02054763          	bltz	a0,80004b0e <sys_write+0x5c>
    80004ae4:	fd840593          	addi	a1,s0,-40
    80004ae8:	4505                	li	a0,1
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	898080e7          	jalr	-1896(ra) # 80002382 <argaddr>
    return -1;
    80004af2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004af4:	00054d63          	bltz	a0,80004b0e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004af8:	fe442603          	lw	a2,-28(s0)
    80004afc:	fd843583          	ld	a1,-40(s0)
    80004b00:	fe843503          	ld	a0,-24(s0)
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	490080e7          	jalr	1168(ra) # 80003f94 <filewrite>
    80004b0c:	87aa                	mv	a5,a0
}
    80004b0e:	853e                	mv	a0,a5
    80004b10:	70a2                	ld	ra,40(sp)
    80004b12:	7402                	ld	s0,32(sp)
    80004b14:	6145                	addi	sp,sp,48
    80004b16:	8082                	ret

0000000080004b18 <sys_close>:
{
    80004b18:	1101                	addi	sp,sp,-32
    80004b1a:	ec06                	sd	ra,24(sp)
    80004b1c:	e822                	sd	s0,16(sp)
    80004b1e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004b20:	fe040613          	addi	a2,s0,-32
    80004b24:	fec40593          	addi	a1,s0,-20
    80004b28:	4501                	li	a0,0
    80004b2a:	00000097          	auipc	ra,0x0
    80004b2e:	cbe080e7          	jalr	-834(ra) # 800047e8 <argfd>
    return -1;
    80004b32:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004b34:	02054463          	bltz	a0,80004b5c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004b38:	ffffc097          	auipc	ra,0xffffc
    80004b3c:	5f0080e7          	jalr	1520(ra) # 80001128 <myproc>
    80004b40:	fec42783          	lw	a5,-20(s0)
    80004b44:	07e9                	addi	a5,a5,26
    80004b46:	078e                	slli	a5,a5,0x3
    80004b48:	953e                	add	a0,a0,a5
    80004b4a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004b4e:	fe043503          	ld	a0,-32(s0)
    80004b52:	fffff097          	auipc	ra,0xfffff
    80004b56:	21c080e7          	jalr	540(ra) # 80003d6e <fileclose>
  return 0;
    80004b5a:	4781                	li	a5,0
}
    80004b5c:	853e                	mv	a0,a5
    80004b5e:	60e2                	ld	ra,24(sp)
    80004b60:	6442                	ld	s0,16(sp)
    80004b62:	6105                	addi	sp,sp,32
    80004b64:	8082                	ret

0000000080004b66 <sys_fstat>:
{
    80004b66:	1101                	addi	sp,sp,-32
    80004b68:	ec06                	sd	ra,24(sp)
    80004b6a:	e822                	sd	s0,16(sp)
    80004b6c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b6e:	fe840613          	addi	a2,s0,-24
    80004b72:	4581                	li	a1,0
    80004b74:	4501                	li	a0,0
    80004b76:	00000097          	auipc	ra,0x0
    80004b7a:	c72080e7          	jalr	-910(ra) # 800047e8 <argfd>
    return -1;
    80004b7e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b80:	02054563          	bltz	a0,80004baa <sys_fstat+0x44>
    80004b84:	fe040593          	addi	a1,s0,-32
    80004b88:	4505                	li	a0,1
    80004b8a:	ffffd097          	auipc	ra,0xffffd
    80004b8e:	7f8080e7          	jalr	2040(ra) # 80002382 <argaddr>
    return -1;
    80004b92:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b94:	00054b63          	bltz	a0,80004baa <sys_fstat+0x44>
  return filestat(f, st);
    80004b98:	fe043583          	ld	a1,-32(s0)
    80004b9c:	fe843503          	ld	a0,-24(s0)
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	2b0080e7          	jalr	688(ra) # 80003e50 <filestat>
    80004ba8:	87aa                	mv	a5,a0
}
    80004baa:	853e                	mv	a0,a5
    80004bac:	60e2                	ld	ra,24(sp)
    80004bae:	6442                	ld	s0,16(sp)
    80004bb0:	6105                	addi	sp,sp,32
    80004bb2:	8082                	ret

0000000080004bb4 <sys_link>:
{
    80004bb4:	7169                	addi	sp,sp,-304
    80004bb6:	f606                	sd	ra,296(sp)
    80004bb8:	f222                	sd	s0,288(sp)
    80004bba:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bbc:	08000613          	li	a2,128
    80004bc0:	ed040593          	addi	a1,s0,-304
    80004bc4:	4501                	li	a0,0
    80004bc6:	ffffd097          	auipc	ra,0xffffd
    80004bca:	7de080e7          	jalr	2014(ra) # 800023a4 <argstr>
    return -1;
    80004bce:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bd0:	12054663          	bltz	a0,80004cfc <sys_link+0x148>
    80004bd4:	08000613          	li	a2,128
    80004bd8:	f5040593          	addi	a1,s0,-176
    80004bdc:	4505                	li	a0,1
    80004bde:	ffffd097          	auipc	ra,0xffffd
    80004be2:	7c6080e7          	jalr	1990(ra) # 800023a4 <argstr>
    return -1;
    80004be6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004be8:	10054a63          	bltz	a0,80004cfc <sys_link+0x148>
    80004bec:	ee26                	sd	s1,280(sp)
  begin_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	cb6080e7          	jalr	-842(ra) # 800038a4 <begin_op>
  if((ip = namei(old)) == 0){
    80004bf6:	ed040513          	addi	a0,s0,-304
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	aaa080e7          	jalr	-1366(ra) # 800036a4 <namei>
    80004c02:	84aa                	mv	s1,a0
    80004c04:	c949                	beqz	a0,80004c96 <sys_link+0xe2>
  ilock(ip);
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	2cc080e7          	jalr	716(ra) # 80002ed2 <ilock>
  if(ip->type == T_DIR){
    80004c0e:	04449703          	lh	a4,68(s1)
    80004c12:	4785                	li	a5,1
    80004c14:	08f70863          	beq	a4,a5,80004ca4 <sys_link+0xf0>
    80004c18:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004c1a:	04a4d783          	lhu	a5,74(s1)
    80004c1e:	2785                	addiw	a5,a5,1
    80004c20:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c24:	8526                	mv	a0,s1
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	1e0080e7          	jalr	480(ra) # 80002e06 <iupdate>
  iunlock(ip);
    80004c2e:	8526                	mv	a0,s1
    80004c30:	ffffe097          	auipc	ra,0xffffe
    80004c34:	368080e7          	jalr	872(ra) # 80002f98 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004c38:	fd040593          	addi	a1,s0,-48
    80004c3c:	f5040513          	addi	a0,s0,-176
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	a82080e7          	jalr	-1406(ra) # 800036c2 <nameiparent>
    80004c48:	892a                	mv	s2,a0
    80004c4a:	cd35                	beqz	a0,80004cc6 <sys_link+0x112>
  ilock(dp);
    80004c4c:	ffffe097          	auipc	ra,0xffffe
    80004c50:	286080e7          	jalr	646(ra) # 80002ed2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004c54:	00092703          	lw	a4,0(s2)
    80004c58:	409c                	lw	a5,0(s1)
    80004c5a:	06f71163          	bne	a4,a5,80004cbc <sys_link+0x108>
    80004c5e:	40d0                	lw	a2,4(s1)
    80004c60:	fd040593          	addi	a1,s0,-48
    80004c64:	854a                	mv	a0,s2
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	97c080e7          	jalr	-1668(ra) # 800035e2 <dirlink>
    80004c6e:	04054763          	bltz	a0,80004cbc <sys_link+0x108>
  iunlockput(dp);
    80004c72:	854a                	mv	a0,s2
    80004c74:	ffffe097          	auipc	ra,0xffffe
    80004c78:	4c4080e7          	jalr	1220(ra) # 80003138 <iunlockput>
  iput(ip);
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	412080e7          	jalr	1042(ra) # 80003090 <iput>
  end_op();
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	c98080e7          	jalr	-872(ra) # 8000391e <end_op>
  return 0;
    80004c8e:	4781                	li	a5,0
    80004c90:	64f2                	ld	s1,280(sp)
    80004c92:	6952                	ld	s2,272(sp)
    80004c94:	a0a5                	j	80004cfc <sys_link+0x148>
    end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	c88080e7          	jalr	-888(ra) # 8000391e <end_op>
    return -1;
    80004c9e:	57fd                	li	a5,-1
    80004ca0:	64f2                	ld	s1,280(sp)
    80004ca2:	a8a9                	j	80004cfc <sys_link+0x148>
    iunlockput(ip);
    80004ca4:	8526                	mv	a0,s1
    80004ca6:	ffffe097          	auipc	ra,0xffffe
    80004caa:	492080e7          	jalr	1170(ra) # 80003138 <iunlockput>
    end_op();
    80004cae:	fffff097          	auipc	ra,0xfffff
    80004cb2:	c70080e7          	jalr	-912(ra) # 8000391e <end_op>
    return -1;
    80004cb6:	57fd                	li	a5,-1
    80004cb8:	64f2                	ld	s1,280(sp)
    80004cba:	a089                	j	80004cfc <sys_link+0x148>
    iunlockput(dp);
    80004cbc:	854a                	mv	a0,s2
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	47a080e7          	jalr	1146(ra) # 80003138 <iunlockput>
  ilock(ip);
    80004cc6:	8526                	mv	a0,s1
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	20a080e7          	jalr	522(ra) # 80002ed2 <ilock>
  ip->nlink--;
    80004cd0:	04a4d783          	lhu	a5,74(s1)
    80004cd4:	37fd                	addiw	a5,a5,-1
    80004cd6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004cda:	8526                	mv	a0,s1
    80004cdc:	ffffe097          	auipc	ra,0xffffe
    80004ce0:	12a080e7          	jalr	298(ra) # 80002e06 <iupdate>
  iunlockput(ip);
    80004ce4:	8526                	mv	a0,s1
    80004ce6:	ffffe097          	auipc	ra,0xffffe
    80004cea:	452080e7          	jalr	1106(ra) # 80003138 <iunlockput>
  end_op();
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	c30080e7          	jalr	-976(ra) # 8000391e <end_op>
  return -1;
    80004cf6:	57fd                	li	a5,-1
    80004cf8:	64f2                	ld	s1,280(sp)
    80004cfa:	6952                	ld	s2,272(sp)
}
    80004cfc:	853e                	mv	a0,a5
    80004cfe:	70b2                	ld	ra,296(sp)
    80004d00:	7412                	ld	s0,288(sp)
    80004d02:	6155                	addi	sp,sp,304
    80004d04:	8082                	ret

0000000080004d06 <sys_unlink>:
{
    80004d06:	7151                	addi	sp,sp,-240
    80004d08:	f586                	sd	ra,232(sp)
    80004d0a:	f1a2                	sd	s0,224(sp)
    80004d0c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004d0e:	08000613          	li	a2,128
    80004d12:	f3040593          	addi	a1,s0,-208
    80004d16:	4501                	li	a0,0
    80004d18:	ffffd097          	auipc	ra,0xffffd
    80004d1c:	68c080e7          	jalr	1676(ra) # 800023a4 <argstr>
    80004d20:	1a054a63          	bltz	a0,80004ed4 <sys_unlink+0x1ce>
    80004d24:	eda6                	sd	s1,216(sp)
  begin_op();
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	b7e080e7          	jalr	-1154(ra) # 800038a4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004d2e:	fb040593          	addi	a1,s0,-80
    80004d32:	f3040513          	addi	a0,s0,-208
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	98c080e7          	jalr	-1652(ra) # 800036c2 <nameiparent>
    80004d3e:	84aa                	mv	s1,a0
    80004d40:	cd71                	beqz	a0,80004e1c <sys_unlink+0x116>
  ilock(dp);
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	190080e7          	jalr	400(ra) # 80002ed2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004d4a:	00004597          	auipc	a1,0x4
    80004d4e:	90e58593          	addi	a1,a1,-1778 # 80008658 <etext+0x658>
    80004d52:	fb040513          	addi	a0,s0,-80
    80004d56:	ffffe097          	auipc	ra,0xffffe
    80004d5a:	662080e7          	jalr	1634(ra) # 800033b8 <namecmp>
    80004d5e:	14050c63          	beqz	a0,80004eb6 <sys_unlink+0x1b0>
    80004d62:	00004597          	auipc	a1,0x4
    80004d66:	8fe58593          	addi	a1,a1,-1794 # 80008660 <etext+0x660>
    80004d6a:	fb040513          	addi	a0,s0,-80
    80004d6e:	ffffe097          	auipc	ra,0xffffe
    80004d72:	64a080e7          	jalr	1610(ra) # 800033b8 <namecmp>
    80004d76:	14050063          	beqz	a0,80004eb6 <sys_unlink+0x1b0>
    80004d7a:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004d7c:	f2c40613          	addi	a2,s0,-212
    80004d80:	fb040593          	addi	a1,s0,-80
    80004d84:	8526                	mv	a0,s1
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	64c080e7          	jalr	1612(ra) # 800033d2 <dirlookup>
    80004d8e:	892a                	mv	s2,a0
    80004d90:	12050263          	beqz	a0,80004eb4 <sys_unlink+0x1ae>
  ilock(ip);
    80004d94:	ffffe097          	auipc	ra,0xffffe
    80004d98:	13e080e7          	jalr	318(ra) # 80002ed2 <ilock>
  if(ip->nlink < 1)
    80004d9c:	04a91783          	lh	a5,74(s2)
    80004da0:	08f05563          	blez	a5,80004e2a <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004da4:	04491703          	lh	a4,68(s2)
    80004da8:	4785                	li	a5,1
    80004daa:	08f70963          	beq	a4,a5,80004e3c <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004dae:	4641                	li	a2,16
    80004db0:	4581                	li	a1,0
    80004db2:	fc040513          	addi	a0,s0,-64
    80004db6:	ffffb097          	auipc	ra,0xffffb
    80004dba:	53a080e7          	jalr	1338(ra) # 800002f0 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dbe:	4741                	li	a4,16
    80004dc0:	f2c42683          	lw	a3,-212(s0)
    80004dc4:	fc040613          	addi	a2,s0,-64
    80004dc8:	4581                	li	a1,0
    80004dca:	8526                	mv	a0,s1
    80004dcc:	ffffe097          	auipc	ra,0xffffe
    80004dd0:	4c2080e7          	jalr	1218(ra) # 8000328e <writei>
    80004dd4:	47c1                	li	a5,16
    80004dd6:	0af51b63          	bne	a0,a5,80004e8c <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004dda:	04491703          	lh	a4,68(s2)
    80004dde:	4785                	li	a5,1
    80004de0:	0af70f63          	beq	a4,a5,80004e9e <sys_unlink+0x198>
  iunlockput(dp);
    80004de4:	8526                	mv	a0,s1
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	352080e7          	jalr	850(ra) # 80003138 <iunlockput>
  ip->nlink--;
    80004dee:	04a95783          	lhu	a5,74(s2)
    80004df2:	37fd                	addiw	a5,a5,-1
    80004df4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004df8:	854a                	mv	a0,s2
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	00c080e7          	jalr	12(ra) # 80002e06 <iupdate>
  iunlockput(ip);
    80004e02:	854a                	mv	a0,s2
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	334080e7          	jalr	820(ra) # 80003138 <iunlockput>
  end_op();
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	b12080e7          	jalr	-1262(ra) # 8000391e <end_op>
  return 0;
    80004e14:	4501                	li	a0,0
    80004e16:	64ee                	ld	s1,216(sp)
    80004e18:	694e                	ld	s2,208(sp)
    80004e1a:	a84d                	j	80004ecc <sys_unlink+0x1c6>
    end_op();
    80004e1c:	fffff097          	auipc	ra,0xfffff
    80004e20:	b02080e7          	jalr	-1278(ra) # 8000391e <end_op>
    return -1;
    80004e24:	557d                	li	a0,-1
    80004e26:	64ee                	ld	s1,216(sp)
    80004e28:	a055                	j	80004ecc <sys_unlink+0x1c6>
    80004e2a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004e2c:	00004517          	auipc	a0,0x4
    80004e30:	85c50513          	addi	a0,a0,-1956 # 80008688 <etext+0x688>
    80004e34:	00001097          	auipc	ra,0x1
    80004e38:	208080e7          	jalr	520(ra) # 8000603c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e3c:	04c92703          	lw	a4,76(s2)
    80004e40:	02000793          	li	a5,32
    80004e44:	f6e7f5e3          	bgeu	a5,a4,80004dae <sys_unlink+0xa8>
    80004e48:	e5ce                	sd	s3,200(sp)
    80004e4a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e4e:	4741                	li	a4,16
    80004e50:	86ce                	mv	a3,s3
    80004e52:	f1840613          	addi	a2,s0,-232
    80004e56:	4581                	li	a1,0
    80004e58:	854a                	mv	a0,s2
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	330080e7          	jalr	816(ra) # 8000318a <readi>
    80004e62:	47c1                	li	a5,16
    80004e64:	00f51c63          	bne	a0,a5,80004e7c <sys_unlink+0x176>
    if(de.inum != 0)
    80004e68:	f1845783          	lhu	a5,-232(s0)
    80004e6c:	e7b5                	bnez	a5,80004ed8 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e6e:	29c1                	addiw	s3,s3,16
    80004e70:	04c92783          	lw	a5,76(s2)
    80004e74:	fcf9ede3          	bltu	s3,a5,80004e4e <sys_unlink+0x148>
    80004e78:	69ae                	ld	s3,200(sp)
    80004e7a:	bf15                	j	80004dae <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004e7c:	00004517          	auipc	a0,0x4
    80004e80:	82450513          	addi	a0,a0,-2012 # 800086a0 <etext+0x6a0>
    80004e84:	00001097          	auipc	ra,0x1
    80004e88:	1b8080e7          	jalr	440(ra) # 8000603c <panic>
    80004e8c:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004e8e:	00004517          	auipc	a0,0x4
    80004e92:	82a50513          	addi	a0,a0,-2006 # 800086b8 <etext+0x6b8>
    80004e96:	00001097          	auipc	ra,0x1
    80004e9a:	1a6080e7          	jalr	422(ra) # 8000603c <panic>
    dp->nlink--;
    80004e9e:	04a4d783          	lhu	a5,74(s1)
    80004ea2:	37fd                	addiw	a5,a5,-1
    80004ea4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ea8:	8526                	mv	a0,s1
    80004eaa:	ffffe097          	auipc	ra,0xffffe
    80004eae:	f5c080e7          	jalr	-164(ra) # 80002e06 <iupdate>
    80004eb2:	bf0d                	j	80004de4 <sys_unlink+0xde>
    80004eb4:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004eb6:	8526                	mv	a0,s1
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	280080e7          	jalr	640(ra) # 80003138 <iunlockput>
  end_op();
    80004ec0:	fffff097          	auipc	ra,0xfffff
    80004ec4:	a5e080e7          	jalr	-1442(ra) # 8000391e <end_op>
  return -1;
    80004ec8:	557d                	li	a0,-1
    80004eca:	64ee                	ld	s1,216(sp)
}
    80004ecc:	70ae                	ld	ra,232(sp)
    80004ece:	740e                	ld	s0,224(sp)
    80004ed0:	616d                	addi	sp,sp,240
    80004ed2:	8082                	ret
    return -1;
    80004ed4:	557d                	li	a0,-1
    80004ed6:	bfdd                	j	80004ecc <sys_unlink+0x1c6>
    iunlockput(ip);
    80004ed8:	854a                	mv	a0,s2
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	25e080e7          	jalr	606(ra) # 80003138 <iunlockput>
    goto bad;
    80004ee2:	694e                	ld	s2,208(sp)
    80004ee4:	69ae                	ld	s3,200(sp)
    80004ee6:	bfc1                	j	80004eb6 <sys_unlink+0x1b0>

0000000080004ee8 <sys_open>:

uint64
sys_open(void)
{
    80004ee8:	7131                	addi	sp,sp,-192
    80004eea:	fd06                	sd	ra,184(sp)
    80004eec:	f922                	sd	s0,176(sp)
    80004eee:	f526                	sd	s1,168(sp)
    80004ef0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ef2:	08000613          	li	a2,128
    80004ef6:	f5040593          	addi	a1,s0,-176
    80004efa:	4501                	li	a0,0
    80004efc:	ffffd097          	auipc	ra,0xffffd
    80004f00:	4a8080e7          	jalr	1192(ra) # 800023a4 <argstr>
    return -1;
    80004f04:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004f06:	0c054463          	bltz	a0,80004fce <sys_open+0xe6>
    80004f0a:	f4c40593          	addi	a1,s0,-180
    80004f0e:	4505                	li	a0,1
    80004f10:	ffffd097          	auipc	ra,0xffffd
    80004f14:	450080e7          	jalr	1104(ra) # 80002360 <argint>
    80004f18:	0a054b63          	bltz	a0,80004fce <sys_open+0xe6>
    80004f1c:	f14a                	sd	s2,160(sp)

  begin_op();
    80004f1e:	fffff097          	auipc	ra,0xfffff
    80004f22:	986080e7          	jalr	-1658(ra) # 800038a4 <begin_op>

  if(omode & O_CREATE){
    80004f26:	f4c42783          	lw	a5,-180(s0)
    80004f2a:	2007f793          	andi	a5,a5,512
    80004f2e:	cfc5                	beqz	a5,80004fe6 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004f30:	4681                	li	a3,0
    80004f32:	4601                	li	a2,0
    80004f34:	4589                	li	a1,2
    80004f36:	f5040513          	addi	a0,s0,-176
    80004f3a:	00000097          	auipc	ra,0x0
    80004f3e:	958080e7          	jalr	-1704(ra) # 80004892 <create>
    80004f42:	892a                	mv	s2,a0
    if(ip == 0){
    80004f44:	c959                	beqz	a0,80004fda <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004f46:	04491703          	lh	a4,68(s2)
    80004f4a:	478d                	li	a5,3
    80004f4c:	00f71763          	bne	a4,a5,80004f5a <sys_open+0x72>
    80004f50:	04695703          	lhu	a4,70(s2)
    80004f54:	47a5                	li	a5,9
    80004f56:	0ce7ef63          	bltu	a5,a4,80005034 <sys_open+0x14c>
    80004f5a:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f5c:	fffff097          	auipc	ra,0xfffff
    80004f60:	d56080e7          	jalr	-682(ra) # 80003cb2 <filealloc>
    80004f64:	89aa                	mv	s3,a0
    80004f66:	c965                	beqz	a0,80005056 <sys_open+0x16e>
    80004f68:	00000097          	auipc	ra,0x0
    80004f6c:	8e8080e7          	jalr	-1816(ra) # 80004850 <fdalloc>
    80004f70:	84aa                	mv	s1,a0
    80004f72:	0c054d63          	bltz	a0,8000504c <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f76:	04491703          	lh	a4,68(s2)
    80004f7a:	478d                	li	a5,3
    80004f7c:	0ef70a63          	beq	a4,a5,80005070 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f80:	4789                	li	a5,2
    80004f82:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f86:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f8a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f8e:	f4c42783          	lw	a5,-180(s0)
    80004f92:	0017c713          	xori	a4,a5,1
    80004f96:	8b05                	andi	a4,a4,1
    80004f98:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f9c:	0037f713          	andi	a4,a5,3
    80004fa0:	00e03733          	snez	a4,a4
    80004fa4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004fa8:	4007f793          	andi	a5,a5,1024
    80004fac:	c791                	beqz	a5,80004fb8 <sys_open+0xd0>
    80004fae:	04491703          	lh	a4,68(s2)
    80004fb2:	4789                	li	a5,2
    80004fb4:	0cf70563          	beq	a4,a5,8000507e <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004fb8:	854a                	mv	a0,s2
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	fde080e7          	jalr	-34(ra) # 80002f98 <iunlock>
  end_op();
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	95c080e7          	jalr	-1700(ra) # 8000391e <end_op>
    80004fca:	790a                	ld	s2,160(sp)
    80004fcc:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004fce:	8526                	mv	a0,s1
    80004fd0:	70ea                	ld	ra,184(sp)
    80004fd2:	744a                	ld	s0,176(sp)
    80004fd4:	74aa                	ld	s1,168(sp)
    80004fd6:	6129                	addi	sp,sp,192
    80004fd8:	8082                	ret
      end_op();
    80004fda:	fffff097          	auipc	ra,0xfffff
    80004fde:	944080e7          	jalr	-1724(ra) # 8000391e <end_op>
      return -1;
    80004fe2:	790a                	ld	s2,160(sp)
    80004fe4:	b7ed                	j	80004fce <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004fe6:	f5040513          	addi	a0,s0,-176
    80004fea:	ffffe097          	auipc	ra,0xffffe
    80004fee:	6ba080e7          	jalr	1722(ra) # 800036a4 <namei>
    80004ff2:	892a                	mv	s2,a0
    80004ff4:	c90d                	beqz	a0,80005026 <sys_open+0x13e>
    ilock(ip);
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	edc080e7          	jalr	-292(ra) # 80002ed2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ffe:	04491703          	lh	a4,68(s2)
    80005002:	4785                	li	a5,1
    80005004:	f4f711e3          	bne	a4,a5,80004f46 <sys_open+0x5e>
    80005008:	f4c42783          	lw	a5,-180(s0)
    8000500c:	d7b9                	beqz	a5,80004f5a <sys_open+0x72>
      iunlockput(ip);
    8000500e:	854a                	mv	a0,s2
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	128080e7          	jalr	296(ra) # 80003138 <iunlockput>
      end_op();
    80005018:	fffff097          	auipc	ra,0xfffff
    8000501c:	906080e7          	jalr	-1786(ra) # 8000391e <end_op>
      return -1;
    80005020:	54fd                	li	s1,-1
    80005022:	790a                	ld	s2,160(sp)
    80005024:	b76d                	j	80004fce <sys_open+0xe6>
      end_op();
    80005026:	fffff097          	auipc	ra,0xfffff
    8000502a:	8f8080e7          	jalr	-1800(ra) # 8000391e <end_op>
      return -1;
    8000502e:	54fd                	li	s1,-1
    80005030:	790a                	ld	s2,160(sp)
    80005032:	bf71                	j	80004fce <sys_open+0xe6>
    iunlockput(ip);
    80005034:	854a                	mv	a0,s2
    80005036:	ffffe097          	auipc	ra,0xffffe
    8000503a:	102080e7          	jalr	258(ra) # 80003138 <iunlockput>
    end_op();
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	8e0080e7          	jalr	-1824(ra) # 8000391e <end_op>
    return -1;
    80005046:	54fd                	li	s1,-1
    80005048:	790a                	ld	s2,160(sp)
    8000504a:	b751                	j	80004fce <sys_open+0xe6>
      fileclose(f);
    8000504c:	854e                	mv	a0,s3
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	d20080e7          	jalr	-736(ra) # 80003d6e <fileclose>
    iunlockput(ip);
    80005056:	854a                	mv	a0,s2
    80005058:	ffffe097          	auipc	ra,0xffffe
    8000505c:	0e0080e7          	jalr	224(ra) # 80003138 <iunlockput>
    end_op();
    80005060:	fffff097          	auipc	ra,0xfffff
    80005064:	8be080e7          	jalr	-1858(ra) # 8000391e <end_op>
    return -1;
    80005068:	54fd                	li	s1,-1
    8000506a:	790a                	ld	s2,160(sp)
    8000506c:	69ea                	ld	s3,152(sp)
    8000506e:	b785                	j	80004fce <sys_open+0xe6>
    f->type = FD_DEVICE;
    80005070:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005074:	04691783          	lh	a5,70(s2)
    80005078:	02f99223          	sh	a5,36(s3)
    8000507c:	b739                	j	80004f8a <sys_open+0xa2>
    itrunc(ip);
    8000507e:	854a                	mv	a0,s2
    80005080:	ffffe097          	auipc	ra,0xffffe
    80005084:	f64080e7          	jalr	-156(ra) # 80002fe4 <itrunc>
    80005088:	bf05                	j	80004fb8 <sys_open+0xd0>

000000008000508a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000508a:	7175                	addi	sp,sp,-144
    8000508c:	e506                	sd	ra,136(sp)
    8000508e:	e122                	sd	s0,128(sp)
    80005090:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	812080e7          	jalr	-2030(ra) # 800038a4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000509a:	08000613          	li	a2,128
    8000509e:	f7040593          	addi	a1,s0,-144
    800050a2:	4501                	li	a0,0
    800050a4:	ffffd097          	auipc	ra,0xffffd
    800050a8:	300080e7          	jalr	768(ra) # 800023a4 <argstr>
    800050ac:	02054963          	bltz	a0,800050de <sys_mkdir+0x54>
    800050b0:	4681                	li	a3,0
    800050b2:	4601                	li	a2,0
    800050b4:	4585                	li	a1,1
    800050b6:	f7040513          	addi	a0,s0,-144
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	7d8080e7          	jalr	2008(ra) # 80004892 <create>
    800050c2:	cd11                	beqz	a0,800050de <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050c4:	ffffe097          	auipc	ra,0xffffe
    800050c8:	074080e7          	jalr	116(ra) # 80003138 <iunlockput>
  end_op();
    800050cc:	fffff097          	auipc	ra,0xfffff
    800050d0:	852080e7          	jalr	-1966(ra) # 8000391e <end_op>
  return 0;
    800050d4:	4501                	li	a0,0
}
    800050d6:	60aa                	ld	ra,136(sp)
    800050d8:	640a                	ld	s0,128(sp)
    800050da:	6149                	addi	sp,sp,144
    800050dc:	8082                	ret
    end_op();
    800050de:	fffff097          	auipc	ra,0xfffff
    800050e2:	840080e7          	jalr	-1984(ra) # 8000391e <end_op>
    return -1;
    800050e6:	557d                	li	a0,-1
    800050e8:	b7fd                	j	800050d6 <sys_mkdir+0x4c>

00000000800050ea <sys_mknod>:

uint64
sys_mknod(void)
{
    800050ea:	7135                	addi	sp,sp,-160
    800050ec:	ed06                	sd	ra,152(sp)
    800050ee:	e922                	sd	s0,144(sp)
    800050f0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050f2:	ffffe097          	auipc	ra,0xffffe
    800050f6:	7b2080e7          	jalr	1970(ra) # 800038a4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050fa:	08000613          	li	a2,128
    800050fe:	f7040593          	addi	a1,s0,-144
    80005102:	4501                	li	a0,0
    80005104:	ffffd097          	auipc	ra,0xffffd
    80005108:	2a0080e7          	jalr	672(ra) # 800023a4 <argstr>
    8000510c:	04054a63          	bltz	a0,80005160 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005110:	f6c40593          	addi	a1,s0,-148
    80005114:	4505                	li	a0,1
    80005116:	ffffd097          	auipc	ra,0xffffd
    8000511a:	24a080e7          	jalr	586(ra) # 80002360 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000511e:	04054163          	bltz	a0,80005160 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005122:	f6840593          	addi	a1,s0,-152
    80005126:	4509                	li	a0,2
    80005128:	ffffd097          	auipc	ra,0xffffd
    8000512c:	238080e7          	jalr	568(ra) # 80002360 <argint>
     argint(1, &major) < 0 ||
    80005130:	02054863          	bltz	a0,80005160 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005134:	f6841683          	lh	a3,-152(s0)
    80005138:	f6c41603          	lh	a2,-148(s0)
    8000513c:	458d                	li	a1,3
    8000513e:	f7040513          	addi	a0,s0,-144
    80005142:	fffff097          	auipc	ra,0xfffff
    80005146:	750080e7          	jalr	1872(ra) # 80004892 <create>
     argint(2, &minor) < 0 ||
    8000514a:	c919                	beqz	a0,80005160 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000514c:	ffffe097          	auipc	ra,0xffffe
    80005150:	fec080e7          	jalr	-20(ra) # 80003138 <iunlockput>
  end_op();
    80005154:	ffffe097          	auipc	ra,0xffffe
    80005158:	7ca080e7          	jalr	1994(ra) # 8000391e <end_op>
  return 0;
    8000515c:	4501                	li	a0,0
    8000515e:	a031                	j	8000516a <sys_mknod+0x80>
    end_op();
    80005160:	ffffe097          	auipc	ra,0xffffe
    80005164:	7be080e7          	jalr	1982(ra) # 8000391e <end_op>
    return -1;
    80005168:	557d                	li	a0,-1
}
    8000516a:	60ea                	ld	ra,152(sp)
    8000516c:	644a                	ld	s0,144(sp)
    8000516e:	610d                	addi	sp,sp,160
    80005170:	8082                	ret

0000000080005172 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005172:	7135                	addi	sp,sp,-160
    80005174:	ed06                	sd	ra,152(sp)
    80005176:	e922                	sd	s0,144(sp)
    80005178:	e14a                	sd	s2,128(sp)
    8000517a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000517c:	ffffc097          	auipc	ra,0xffffc
    80005180:	fac080e7          	jalr	-84(ra) # 80001128 <myproc>
    80005184:	892a                	mv	s2,a0
  
  begin_op();
    80005186:	ffffe097          	auipc	ra,0xffffe
    8000518a:	71e080e7          	jalr	1822(ra) # 800038a4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000518e:	08000613          	li	a2,128
    80005192:	f6040593          	addi	a1,s0,-160
    80005196:	4501                	li	a0,0
    80005198:	ffffd097          	auipc	ra,0xffffd
    8000519c:	20c080e7          	jalr	524(ra) # 800023a4 <argstr>
    800051a0:	04054d63          	bltz	a0,800051fa <sys_chdir+0x88>
    800051a4:	e526                	sd	s1,136(sp)
    800051a6:	f6040513          	addi	a0,s0,-160
    800051aa:	ffffe097          	auipc	ra,0xffffe
    800051ae:	4fa080e7          	jalr	1274(ra) # 800036a4 <namei>
    800051b2:	84aa                	mv	s1,a0
    800051b4:	c131                	beqz	a0,800051f8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800051b6:	ffffe097          	auipc	ra,0xffffe
    800051ba:	d1c080e7          	jalr	-740(ra) # 80002ed2 <ilock>
  if(ip->type != T_DIR){
    800051be:	04449703          	lh	a4,68(s1)
    800051c2:	4785                	li	a5,1
    800051c4:	04f71163          	bne	a4,a5,80005206 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800051c8:	8526                	mv	a0,s1
    800051ca:	ffffe097          	auipc	ra,0xffffe
    800051ce:	dce080e7          	jalr	-562(ra) # 80002f98 <iunlock>
  iput(p->cwd);
    800051d2:	15093503          	ld	a0,336(s2)
    800051d6:	ffffe097          	auipc	ra,0xffffe
    800051da:	eba080e7          	jalr	-326(ra) # 80003090 <iput>
  end_op();
    800051de:	ffffe097          	auipc	ra,0xffffe
    800051e2:	740080e7          	jalr	1856(ra) # 8000391e <end_op>
  p->cwd = ip;
    800051e6:	14993823          	sd	s1,336(s2)
  return 0;
    800051ea:	4501                	li	a0,0
    800051ec:	64aa                	ld	s1,136(sp)
}
    800051ee:	60ea                	ld	ra,152(sp)
    800051f0:	644a                	ld	s0,144(sp)
    800051f2:	690a                	ld	s2,128(sp)
    800051f4:	610d                	addi	sp,sp,160
    800051f6:	8082                	ret
    800051f8:	64aa                	ld	s1,136(sp)
    end_op();
    800051fa:	ffffe097          	auipc	ra,0xffffe
    800051fe:	724080e7          	jalr	1828(ra) # 8000391e <end_op>
    return -1;
    80005202:	557d                	li	a0,-1
    80005204:	b7ed                	j	800051ee <sys_chdir+0x7c>
    iunlockput(ip);
    80005206:	8526                	mv	a0,s1
    80005208:	ffffe097          	auipc	ra,0xffffe
    8000520c:	f30080e7          	jalr	-208(ra) # 80003138 <iunlockput>
    end_op();
    80005210:	ffffe097          	auipc	ra,0xffffe
    80005214:	70e080e7          	jalr	1806(ra) # 8000391e <end_op>
    return -1;
    80005218:	557d                	li	a0,-1
    8000521a:	64aa                	ld	s1,136(sp)
    8000521c:	bfc9                	j	800051ee <sys_chdir+0x7c>

000000008000521e <sys_exec>:

uint64
sys_exec(void)
{
    8000521e:	7121                	addi	sp,sp,-448
    80005220:	ff06                	sd	ra,440(sp)
    80005222:	fb22                	sd	s0,432(sp)
    80005224:	f34a                	sd	s2,416(sp)
    80005226:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005228:	08000613          	li	a2,128
    8000522c:	f5040593          	addi	a1,s0,-176
    80005230:	4501                	li	a0,0
    80005232:	ffffd097          	auipc	ra,0xffffd
    80005236:	172080e7          	jalr	370(ra) # 800023a4 <argstr>
    return -1;
    8000523a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000523c:	0e054a63          	bltz	a0,80005330 <sys_exec+0x112>
    80005240:	e4840593          	addi	a1,s0,-440
    80005244:	4505                	li	a0,1
    80005246:	ffffd097          	auipc	ra,0xffffd
    8000524a:	13c080e7          	jalr	316(ra) # 80002382 <argaddr>
    8000524e:	0e054163          	bltz	a0,80005330 <sys_exec+0x112>
    80005252:	f726                	sd	s1,424(sp)
    80005254:	ef4e                	sd	s3,408(sp)
    80005256:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005258:	10000613          	li	a2,256
    8000525c:	4581                	li	a1,0
    8000525e:	e5040513          	addi	a0,s0,-432
    80005262:	ffffb097          	auipc	ra,0xffffb
    80005266:	08e080e7          	jalr	142(ra) # 800002f0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000526a:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000526e:	89a6                	mv	s3,s1
    80005270:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005272:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005276:	00391513          	slli	a0,s2,0x3
    8000527a:	e4040593          	addi	a1,s0,-448
    8000527e:	e4843783          	ld	a5,-440(s0)
    80005282:	953e                	add	a0,a0,a5
    80005284:	ffffd097          	auipc	ra,0xffffd
    80005288:	042080e7          	jalr	66(ra) # 800022c6 <fetchaddr>
    8000528c:	02054a63          	bltz	a0,800052c0 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005290:	e4043783          	ld	a5,-448(s0)
    80005294:	c7b1                	beqz	a5,800052e0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005296:	ffffb097          	auipc	ra,0xffffb
    8000529a:	f3c080e7          	jalr	-196(ra) # 800001d2 <kalloc>
    8000529e:	85aa                	mv	a1,a0
    800052a0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800052a4:	cd11                	beqz	a0,800052c0 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800052a6:	6605                	lui	a2,0x1
    800052a8:	e4043503          	ld	a0,-448(s0)
    800052ac:	ffffd097          	auipc	ra,0xffffd
    800052b0:	06c080e7          	jalr	108(ra) # 80002318 <fetchstr>
    800052b4:	00054663          	bltz	a0,800052c0 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    800052b8:	0905                	addi	s2,s2,1
    800052ba:	09a1                	addi	s3,s3,8
    800052bc:	fb491de3          	bne	s2,s4,80005276 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052c0:	f5040913          	addi	s2,s0,-176
    800052c4:	6088                	ld	a0,0(s1)
    800052c6:	c12d                	beqz	a0,80005328 <sys_exec+0x10a>
    kfree(argv[i]);
    800052c8:	ffffb097          	auipc	ra,0xffffb
    800052cc:	d54080e7          	jalr	-684(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052d0:	04a1                	addi	s1,s1,8
    800052d2:	ff2499e3          	bne	s1,s2,800052c4 <sys_exec+0xa6>
  return -1;
    800052d6:	597d                	li	s2,-1
    800052d8:	74ba                	ld	s1,424(sp)
    800052da:	69fa                	ld	s3,408(sp)
    800052dc:	6a5a                	ld	s4,400(sp)
    800052de:	a889                	j	80005330 <sys_exec+0x112>
      argv[i] = 0;
    800052e0:	0009079b          	sext.w	a5,s2
    800052e4:	078e                	slli	a5,a5,0x3
    800052e6:	fd078793          	addi	a5,a5,-48
    800052ea:	97a2                	add	a5,a5,s0
    800052ec:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800052f0:	e5040593          	addi	a1,s0,-432
    800052f4:	f5040513          	addi	a0,s0,-176
    800052f8:	fffff097          	auipc	ra,0xfffff
    800052fc:	126080e7          	jalr	294(ra) # 8000441e <exec>
    80005300:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005302:	f5040993          	addi	s3,s0,-176
    80005306:	6088                	ld	a0,0(s1)
    80005308:	cd01                	beqz	a0,80005320 <sys_exec+0x102>
    kfree(argv[i]);
    8000530a:	ffffb097          	auipc	ra,0xffffb
    8000530e:	d12080e7          	jalr	-750(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005312:	04a1                	addi	s1,s1,8
    80005314:	ff3499e3          	bne	s1,s3,80005306 <sys_exec+0xe8>
    80005318:	74ba                	ld	s1,424(sp)
    8000531a:	69fa                	ld	s3,408(sp)
    8000531c:	6a5a                	ld	s4,400(sp)
    8000531e:	a809                	j	80005330 <sys_exec+0x112>
  return ret;
    80005320:	74ba                	ld	s1,424(sp)
    80005322:	69fa                	ld	s3,408(sp)
    80005324:	6a5a                	ld	s4,400(sp)
    80005326:	a029                	j	80005330 <sys_exec+0x112>
  return -1;
    80005328:	597d                	li	s2,-1
    8000532a:	74ba                	ld	s1,424(sp)
    8000532c:	69fa                	ld	s3,408(sp)
    8000532e:	6a5a                	ld	s4,400(sp)
}
    80005330:	854a                	mv	a0,s2
    80005332:	70fa                	ld	ra,440(sp)
    80005334:	745a                	ld	s0,432(sp)
    80005336:	791a                	ld	s2,416(sp)
    80005338:	6139                	addi	sp,sp,448
    8000533a:	8082                	ret

000000008000533c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000533c:	7139                	addi	sp,sp,-64
    8000533e:	fc06                	sd	ra,56(sp)
    80005340:	f822                	sd	s0,48(sp)
    80005342:	f426                	sd	s1,40(sp)
    80005344:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005346:	ffffc097          	auipc	ra,0xffffc
    8000534a:	de2080e7          	jalr	-542(ra) # 80001128 <myproc>
    8000534e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005350:	fd840593          	addi	a1,s0,-40
    80005354:	4501                	li	a0,0
    80005356:	ffffd097          	auipc	ra,0xffffd
    8000535a:	02c080e7          	jalr	44(ra) # 80002382 <argaddr>
    return -1;
    8000535e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005360:	0e054063          	bltz	a0,80005440 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005364:	fc840593          	addi	a1,s0,-56
    80005368:	fd040513          	addi	a0,s0,-48
    8000536c:	fffff097          	auipc	ra,0xfffff
    80005370:	d70080e7          	jalr	-656(ra) # 800040dc <pipealloc>
    return -1;
    80005374:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005376:	0c054563          	bltz	a0,80005440 <sys_pipe+0x104>
  fd0 = -1;
    8000537a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000537e:	fd043503          	ld	a0,-48(s0)
    80005382:	fffff097          	auipc	ra,0xfffff
    80005386:	4ce080e7          	jalr	1230(ra) # 80004850 <fdalloc>
    8000538a:	fca42223          	sw	a0,-60(s0)
    8000538e:	08054c63          	bltz	a0,80005426 <sys_pipe+0xea>
    80005392:	fc843503          	ld	a0,-56(s0)
    80005396:	fffff097          	auipc	ra,0xfffff
    8000539a:	4ba080e7          	jalr	1210(ra) # 80004850 <fdalloc>
    8000539e:	fca42023          	sw	a0,-64(s0)
    800053a2:	06054963          	bltz	a0,80005414 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800053a6:	4691                	li	a3,4
    800053a8:	fc440613          	addi	a2,s0,-60
    800053ac:	fd843583          	ld	a1,-40(s0)
    800053b0:	68a8                	ld	a0,80(s1)
    800053b2:	ffffc097          	auipc	ra,0xffffc
    800053b6:	a08080e7          	jalr	-1528(ra) # 80000dba <copyout>
    800053ba:	02054063          	bltz	a0,800053da <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800053be:	4691                	li	a3,4
    800053c0:	fc040613          	addi	a2,s0,-64
    800053c4:	fd843583          	ld	a1,-40(s0)
    800053c8:	0591                	addi	a1,a1,4
    800053ca:	68a8                	ld	a0,80(s1)
    800053cc:	ffffc097          	auipc	ra,0xffffc
    800053d0:	9ee080e7          	jalr	-1554(ra) # 80000dba <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800053d4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800053d6:	06055563          	bgez	a0,80005440 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800053da:	fc442783          	lw	a5,-60(s0)
    800053de:	07e9                	addi	a5,a5,26
    800053e0:	078e                	slli	a5,a5,0x3
    800053e2:	97a6                	add	a5,a5,s1
    800053e4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800053e8:	fc042783          	lw	a5,-64(s0)
    800053ec:	07e9                	addi	a5,a5,26
    800053ee:	078e                	slli	a5,a5,0x3
    800053f0:	00f48533          	add	a0,s1,a5
    800053f4:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800053f8:	fd043503          	ld	a0,-48(s0)
    800053fc:	fffff097          	auipc	ra,0xfffff
    80005400:	972080e7          	jalr	-1678(ra) # 80003d6e <fileclose>
    fileclose(wf);
    80005404:	fc843503          	ld	a0,-56(s0)
    80005408:	fffff097          	auipc	ra,0xfffff
    8000540c:	966080e7          	jalr	-1690(ra) # 80003d6e <fileclose>
    return -1;
    80005410:	57fd                	li	a5,-1
    80005412:	a03d                	j	80005440 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005414:	fc442783          	lw	a5,-60(s0)
    80005418:	0007c763          	bltz	a5,80005426 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000541c:	07e9                	addi	a5,a5,26
    8000541e:	078e                	slli	a5,a5,0x3
    80005420:	97a6                	add	a5,a5,s1
    80005422:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005426:	fd043503          	ld	a0,-48(s0)
    8000542a:	fffff097          	auipc	ra,0xfffff
    8000542e:	944080e7          	jalr	-1724(ra) # 80003d6e <fileclose>
    fileclose(wf);
    80005432:	fc843503          	ld	a0,-56(s0)
    80005436:	fffff097          	auipc	ra,0xfffff
    8000543a:	938080e7          	jalr	-1736(ra) # 80003d6e <fileclose>
    return -1;
    8000543e:	57fd                	li	a5,-1
}
    80005440:	853e                	mv	a0,a5
    80005442:	70e2                	ld	ra,56(sp)
    80005444:	7442                	ld	s0,48(sp)
    80005446:	74a2                	ld	s1,40(sp)
    80005448:	6121                	addi	sp,sp,64
    8000544a:	8082                	ret
    8000544c:	0000                	unimp
	...

0000000080005450 <kernelvec>:
    80005450:	7111                	addi	sp,sp,-256
    80005452:	e006                	sd	ra,0(sp)
    80005454:	e40a                	sd	sp,8(sp)
    80005456:	e80e                	sd	gp,16(sp)
    80005458:	ec12                	sd	tp,24(sp)
    8000545a:	f016                	sd	t0,32(sp)
    8000545c:	f41a                	sd	t1,40(sp)
    8000545e:	f81e                	sd	t2,48(sp)
    80005460:	fc22                	sd	s0,56(sp)
    80005462:	e0a6                	sd	s1,64(sp)
    80005464:	e4aa                	sd	a0,72(sp)
    80005466:	e8ae                	sd	a1,80(sp)
    80005468:	ecb2                	sd	a2,88(sp)
    8000546a:	f0b6                	sd	a3,96(sp)
    8000546c:	f4ba                	sd	a4,104(sp)
    8000546e:	f8be                	sd	a5,112(sp)
    80005470:	fcc2                	sd	a6,120(sp)
    80005472:	e146                	sd	a7,128(sp)
    80005474:	e54a                	sd	s2,136(sp)
    80005476:	e94e                	sd	s3,144(sp)
    80005478:	ed52                	sd	s4,152(sp)
    8000547a:	f156                	sd	s5,160(sp)
    8000547c:	f55a                	sd	s6,168(sp)
    8000547e:	f95e                	sd	s7,176(sp)
    80005480:	fd62                	sd	s8,184(sp)
    80005482:	e1e6                	sd	s9,192(sp)
    80005484:	e5ea                	sd	s10,200(sp)
    80005486:	e9ee                	sd	s11,208(sp)
    80005488:	edf2                	sd	t3,216(sp)
    8000548a:	f1f6                	sd	t4,224(sp)
    8000548c:	f5fa                	sd	t5,232(sp)
    8000548e:	f9fe                	sd	t6,240(sp)
    80005490:	d03fc0ef          	jal	80002192 <kerneltrap>
    80005494:	6082                	ld	ra,0(sp)
    80005496:	6122                	ld	sp,8(sp)
    80005498:	61c2                	ld	gp,16(sp)
    8000549a:	7282                	ld	t0,32(sp)
    8000549c:	7322                	ld	t1,40(sp)
    8000549e:	73c2                	ld	t2,48(sp)
    800054a0:	7462                	ld	s0,56(sp)
    800054a2:	6486                	ld	s1,64(sp)
    800054a4:	6526                	ld	a0,72(sp)
    800054a6:	65c6                	ld	a1,80(sp)
    800054a8:	6666                	ld	a2,88(sp)
    800054aa:	7686                	ld	a3,96(sp)
    800054ac:	7726                	ld	a4,104(sp)
    800054ae:	77c6                	ld	a5,112(sp)
    800054b0:	7866                	ld	a6,120(sp)
    800054b2:	688a                	ld	a7,128(sp)
    800054b4:	692a                	ld	s2,136(sp)
    800054b6:	69ca                	ld	s3,144(sp)
    800054b8:	6a6a                	ld	s4,152(sp)
    800054ba:	7a8a                	ld	s5,160(sp)
    800054bc:	7b2a                	ld	s6,168(sp)
    800054be:	7bca                	ld	s7,176(sp)
    800054c0:	7c6a                	ld	s8,184(sp)
    800054c2:	6c8e                	ld	s9,192(sp)
    800054c4:	6d2e                	ld	s10,200(sp)
    800054c6:	6dce                	ld	s11,208(sp)
    800054c8:	6e6e                	ld	t3,216(sp)
    800054ca:	7e8e                	ld	t4,224(sp)
    800054cc:	7f2e                	ld	t5,232(sp)
    800054ce:	7fce                	ld	t6,240(sp)
    800054d0:	6111                	addi	sp,sp,256
    800054d2:	10200073          	sret
    800054d6:	00000013          	nop
    800054da:	00000013          	nop
    800054de:	0001                	nop

00000000800054e0 <timervec>:
    800054e0:	34051573          	csrrw	a0,mscratch,a0
    800054e4:	e10c                	sd	a1,0(a0)
    800054e6:	e510                	sd	a2,8(a0)
    800054e8:	e914                	sd	a3,16(a0)
    800054ea:	6d0c                	ld	a1,24(a0)
    800054ec:	7110                	ld	a2,32(a0)
    800054ee:	6194                	ld	a3,0(a1)
    800054f0:	96b2                	add	a3,a3,a2
    800054f2:	e194                	sd	a3,0(a1)
    800054f4:	4589                	li	a1,2
    800054f6:	14459073          	csrw	sip,a1
    800054fa:	6914                	ld	a3,16(a0)
    800054fc:	6510                	ld	a2,8(a0)
    800054fe:	610c                	ld	a1,0(a0)
    80005500:	34051573          	csrrw	a0,mscratch,a0
    80005504:	30200073          	mret
	...

000000008000550a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000550a:	1141                	addi	sp,sp,-16
    8000550c:	e422                	sd	s0,8(sp)
    8000550e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005510:	0c0007b7          	lui	a5,0xc000
    80005514:	4705                	li	a4,1
    80005516:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005518:	0c0007b7          	lui	a5,0xc000
    8000551c:	c3d8                	sw	a4,4(a5)
}
    8000551e:	6422                	ld	s0,8(sp)
    80005520:	0141                	addi	sp,sp,16
    80005522:	8082                	ret

0000000080005524 <plicinithart>:

void
plicinithart(void)
{
    80005524:	1141                	addi	sp,sp,-16
    80005526:	e406                	sd	ra,8(sp)
    80005528:	e022                	sd	s0,0(sp)
    8000552a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000552c:	ffffc097          	auipc	ra,0xffffc
    80005530:	bd0080e7          	jalr	-1072(ra) # 800010fc <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005534:	0085171b          	slliw	a4,a0,0x8
    80005538:	0c0027b7          	lui	a5,0xc002
    8000553c:	97ba                	add	a5,a5,a4
    8000553e:	40200713          	li	a4,1026
    80005542:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005546:	00d5151b          	slliw	a0,a0,0xd
    8000554a:	0c2017b7          	lui	a5,0xc201
    8000554e:	97aa                	add	a5,a5,a0
    80005550:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005554:	60a2                	ld	ra,8(sp)
    80005556:	6402                	ld	s0,0(sp)
    80005558:	0141                	addi	sp,sp,16
    8000555a:	8082                	ret

000000008000555c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000555c:	1141                	addi	sp,sp,-16
    8000555e:	e406                	sd	ra,8(sp)
    80005560:	e022                	sd	s0,0(sp)
    80005562:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005564:	ffffc097          	auipc	ra,0xffffc
    80005568:	b98080e7          	jalr	-1128(ra) # 800010fc <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000556c:	00d5151b          	slliw	a0,a0,0xd
    80005570:	0c2017b7          	lui	a5,0xc201
    80005574:	97aa                	add	a5,a5,a0
  return irq;
}
    80005576:	43c8                	lw	a0,4(a5)
    80005578:	60a2                	ld	ra,8(sp)
    8000557a:	6402                	ld	s0,0(sp)
    8000557c:	0141                	addi	sp,sp,16
    8000557e:	8082                	ret

0000000080005580 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005580:	1101                	addi	sp,sp,-32
    80005582:	ec06                	sd	ra,24(sp)
    80005584:	e822                	sd	s0,16(sp)
    80005586:	e426                	sd	s1,8(sp)
    80005588:	1000                	addi	s0,sp,32
    8000558a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000558c:	ffffc097          	auipc	ra,0xffffc
    80005590:	b70080e7          	jalr	-1168(ra) # 800010fc <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005594:	00d5151b          	slliw	a0,a0,0xd
    80005598:	0c2017b7          	lui	a5,0xc201
    8000559c:	97aa                	add	a5,a5,a0
    8000559e:	c3c4                	sw	s1,4(a5)
}
    800055a0:	60e2                	ld	ra,24(sp)
    800055a2:	6442                	ld	s0,16(sp)
    800055a4:	64a2                	ld	s1,8(sp)
    800055a6:	6105                	addi	sp,sp,32
    800055a8:	8082                	ret

00000000800055aa <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800055aa:	1141                	addi	sp,sp,-16
    800055ac:	e406                	sd	ra,8(sp)
    800055ae:	e022                	sd	s0,0(sp)
    800055b0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800055b2:	479d                	li	a5,7
    800055b4:	06a7c863          	blt	a5,a0,80005624 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800055b8:	00016717          	auipc	a4,0x16
    800055bc:	a4870713          	addi	a4,a4,-1464 # 8001b000 <disk>
    800055c0:	972a                	add	a4,a4,a0
    800055c2:	6789                	lui	a5,0x2
    800055c4:	97ba                	add	a5,a5,a4
    800055c6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800055ca:	e7ad                	bnez	a5,80005634 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800055cc:	00451793          	slli	a5,a0,0x4
    800055d0:	00018717          	auipc	a4,0x18
    800055d4:	a3070713          	addi	a4,a4,-1488 # 8001d000 <disk+0x2000>
    800055d8:	6314                	ld	a3,0(a4)
    800055da:	96be                	add	a3,a3,a5
    800055dc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800055e0:	6314                	ld	a3,0(a4)
    800055e2:	96be                	add	a3,a3,a5
    800055e4:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800055e8:	6314                	ld	a3,0(a4)
    800055ea:	96be                	add	a3,a3,a5
    800055ec:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800055f0:	6318                	ld	a4,0(a4)
    800055f2:	97ba                	add	a5,a5,a4
    800055f4:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800055f8:	00016717          	auipc	a4,0x16
    800055fc:	a0870713          	addi	a4,a4,-1528 # 8001b000 <disk>
    80005600:	972a                	add	a4,a4,a0
    80005602:	6789                	lui	a5,0x2
    80005604:	97ba                	add	a5,a5,a4
    80005606:	4705                	li	a4,1
    80005608:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000560c:	00018517          	auipc	a0,0x18
    80005610:	a0c50513          	addi	a0,a0,-1524 # 8001d018 <disk+0x2018>
    80005614:	ffffc097          	auipc	ra,0xffffc
    80005618:	366080e7          	jalr	870(ra) # 8000197a <wakeup>
}
    8000561c:	60a2                	ld	ra,8(sp)
    8000561e:	6402                	ld	s0,0(sp)
    80005620:	0141                	addi	sp,sp,16
    80005622:	8082                	ret
    panic("free_desc 1");
    80005624:	00003517          	auipc	a0,0x3
    80005628:	0a450513          	addi	a0,a0,164 # 800086c8 <etext+0x6c8>
    8000562c:	00001097          	auipc	ra,0x1
    80005630:	a10080e7          	jalr	-1520(ra) # 8000603c <panic>
    panic("free_desc 2");
    80005634:	00003517          	auipc	a0,0x3
    80005638:	0a450513          	addi	a0,a0,164 # 800086d8 <etext+0x6d8>
    8000563c:	00001097          	auipc	ra,0x1
    80005640:	a00080e7          	jalr	-1536(ra) # 8000603c <panic>

0000000080005644 <virtio_disk_init>:
{
    80005644:	1141                	addi	sp,sp,-16
    80005646:	e406                	sd	ra,8(sp)
    80005648:	e022                	sd	s0,0(sp)
    8000564a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000564c:	00003597          	auipc	a1,0x3
    80005650:	09c58593          	addi	a1,a1,156 # 800086e8 <etext+0x6e8>
    80005654:	00018517          	auipc	a0,0x18
    80005658:	ad450513          	addi	a0,a0,-1324 # 8001d128 <disk+0x2128>
    8000565c:	00001097          	auipc	ra,0x1
    80005660:	eca080e7          	jalr	-310(ra) # 80006526 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005664:	100017b7          	lui	a5,0x10001
    80005668:	4398                	lw	a4,0(a5)
    8000566a:	2701                	sext.w	a4,a4
    8000566c:	747277b7          	lui	a5,0x74727
    80005670:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005674:	0ef71f63          	bne	a4,a5,80005772 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005678:	100017b7          	lui	a5,0x10001
    8000567c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000567e:	439c                	lw	a5,0(a5)
    80005680:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005682:	4705                	li	a4,1
    80005684:	0ee79763          	bne	a5,a4,80005772 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005688:	100017b7          	lui	a5,0x10001
    8000568c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000568e:	439c                	lw	a5,0(a5)
    80005690:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005692:	4709                	li	a4,2
    80005694:	0ce79f63          	bne	a5,a4,80005772 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005698:	100017b7          	lui	a5,0x10001
    8000569c:	47d8                	lw	a4,12(a5)
    8000569e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056a0:	554d47b7          	lui	a5,0x554d4
    800056a4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800056a8:	0cf71563          	bne	a4,a5,80005772 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056ac:	100017b7          	lui	a5,0x10001
    800056b0:	4705                	li	a4,1
    800056b2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056b4:	470d                	li	a4,3
    800056b6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800056b8:	10001737          	lui	a4,0x10001
    800056bc:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800056be:	c7ffe737          	lui	a4,0xc7ffe
    800056c2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800056c6:	8ef9                	and	a3,a3,a4
    800056c8:	10001737          	lui	a4,0x10001
    800056cc:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056ce:	472d                	li	a4,11
    800056d0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056d2:	473d                	li	a4,15
    800056d4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800056d6:	100017b7          	lui	a5,0x10001
    800056da:	6705                	lui	a4,0x1
    800056dc:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800056de:	100017b7          	lui	a5,0x10001
    800056e2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800056e6:	100017b7          	lui	a5,0x10001
    800056ea:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800056ee:	439c                	lw	a5,0(a5)
    800056f0:	2781                	sext.w	a5,a5
  if(max == 0)
    800056f2:	cbc1                	beqz	a5,80005782 <virtio_disk_init+0x13e>
  if(max < NUM)
    800056f4:	471d                	li	a4,7
    800056f6:	08f77e63          	bgeu	a4,a5,80005792 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056fa:	100017b7          	lui	a5,0x10001
    800056fe:	4721                	li	a4,8
    80005700:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005702:	6609                	lui	a2,0x2
    80005704:	4581                	li	a1,0
    80005706:	00016517          	auipc	a0,0x16
    8000570a:	8fa50513          	addi	a0,a0,-1798 # 8001b000 <disk>
    8000570e:	ffffb097          	auipc	ra,0xffffb
    80005712:	be2080e7          	jalr	-1054(ra) # 800002f0 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005716:	00016697          	auipc	a3,0x16
    8000571a:	8ea68693          	addi	a3,a3,-1814 # 8001b000 <disk>
    8000571e:	00c6d713          	srli	a4,a3,0xc
    80005722:	2701                	sext.w	a4,a4
    80005724:	100017b7          	lui	a5,0x10001
    80005728:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000572a:	00018797          	auipc	a5,0x18
    8000572e:	8d678793          	addi	a5,a5,-1834 # 8001d000 <disk+0x2000>
    80005732:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005734:	00016717          	auipc	a4,0x16
    80005738:	94c70713          	addi	a4,a4,-1716 # 8001b080 <disk+0x80>
    8000573c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000573e:	00017717          	auipc	a4,0x17
    80005742:	8c270713          	addi	a4,a4,-1854 # 8001c000 <disk+0x1000>
    80005746:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005748:	4705                	li	a4,1
    8000574a:	00e78c23          	sb	a4,24(a5)
    8000574e:	00e78ca3          	sb	a4,25(a5)
    80005752:	00e78d23          	sb	a4,26(a5)
    80005756:	00e78da3          	sb	a4,27(a5)
    8000575a:	00e78e23          	sb	a4,28(a5)
    8000575e:	00e78ea3          	sb	a4,29(a5)
    80005762:	00e78f23          	sb	a4,30(a5)
    80005766:	00e78fa3          	sb	a4,31(a5)
}
    8000576a:	60a2                	ld	ra,8(sp)
    8000576c:	6402                	ld	s0,0(sp)
    8000576e:	0141                	addi	sp,sp,16
    80005770:	8082                	ret
    panic("could not find virtio disk");
    80005772:	00003517          	auipc	a0,0x3
    80005776:	f8650513          	addi	a0,a0,-122 # 800086f8 <etext+0x6f8>
    8000577a:	00001097          	auipc	ra,0x1
    8000577e:	8c2080e7          	jalr	-1854(ra) # 8000603c <panic>
    panic("virtio disk has no queue 0");
    80005782:	00003517          	auipc	a0,0x3
    80005786:	f9650513          	addi	a0,a0,-106 # 80008718 <etext+0x718>
    8000578a:	00001097          	auipc	ra,0x1
    8000578e:	8b2080e7          	jalr	-1870(ra) # 8000603c <panic>
    panic("virtio disk max queue too short");
    80005792:	00003517          	auipc	a0,0x3
    80005796:	fa650513          	addi	a0,a0,-90 # 80008738 <etext+0x738>
    8000579a:	00001097          	auipc	ra,0x1
    8000579e:	8a2080e7          	jalr	-1886(ra) # 8000603c <panic>

00000000800057a2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057a2:	7159                	addi	sp,sp,-112
    800057a4:	f486                	sd	ra,104(sp)
    800057a6:	f0a2                	sd	s0,96(sp)
    800057a8:	eca6                	sd	s1,88(sp)
    800057aa:	e8ca                	sd	s2,80(sp)
    800057ac:	e4ce                	sd	s3,72(sp)
    800057ae:	e0d2                	sd	s4,64(sp)
    800057b0:	fc56                	sd	s5,56(sp)
    800057b2:	f85a                	sd	s6,48(sp)
    800057b4:	f45e                	sd	s7,40(sp)
    800057b6:	f062                	sd	s8,32(sp)
    800057b8:	ec66                	sd	s9,24(sp)
    800057ba:	1880                	addi	s0,sp,112
    800057bc:	8a2a                	mv	s4,a0
    800057be:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800057c0:	00c52c03          	lw	s8,12(a0)
    800057c4:	001c1c1b          	slliw	s8,s8,0x1
    800057c8:	1c02                	slli	s8,s8,0x20
    800057ca:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800057ce:	00018517          	auipc	a0,0x18
    800057d2:	95a50513          	addi	a0,a0,-1702 # 8001d128 <disk+0x2128>
    800057d6:	00001097          	auipc	ra,0x1
    800057da:	de0080e7          	jalr	-544(ra) # 800065b6 <acquire>
  for(int i = 0; i < 3; i++){
    800057de:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800057e0:	44a1                	li	s1,8
      disk.free[i] = 0;
    800057e2:	00016b97          	auipc	s7,0x16
    800057e6:	81eb8b93          	addi	s7,s7,-2018 # 8001b000 <disk>
    800057ea:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800057ec:	4a8d                	li	s5,3
    800057ee:	a88d                	j	80005860 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    800057f0:	00fb8733          	add	a4,s7,a5
    800057f4:	975a                	add	a4,a4,s6
    800057f6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800057fa:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800057fc:	0207c563          	bltz	a5,80005826 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005800:	2905                	addiw	s2,s2,1
    80005802:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005804:	1b590163          	beq	s2,s5,800059a6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005808:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000580a:	00018717          	auipc	a4,0x18
    8000580e:	80e70713          	addi	a4,a4,-2034 # 8001d018 <disk+0x2018>
    80005812:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005814:	00074683          	lbu	a3,0(a4)
    80005818:	fee1                	bnez	a3,800057f0 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000581a:	2785                	addiw	a5,a5,1
    8000581c:	0705                	addi	a4,a4,1
    8000581e:	fe979be3          	bne	a5,s1,80005814 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005822:	57fd                	li	a5,-1
    80005824:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005826:	03205163          	blez	s2,80005848 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000582a:	f9042503          	lw	a0,-112(s0)
    8000582e:	00000097          	auipc	ra,0x0
    80005832:	d7c080e7          	jalr	-644(ra) # 800055aa <free_desc>
      for(int j = 0; j < i; j++)
    80005836:	4785                	li	a5,1
    80005838:	0127d863          	bge	a5,s2,80005848 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000583c:	f9442503          	lw	a0,-108(s0)
    80005840:	00000097          	auipc	ra,0x0
    80005844:	d6a080e7          	jalr	-662(ra) # 800055aa <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005848:	00018597          	auipc	a1,0x18
    8000584c:	8e058593          	addi	a1,a1,-1824 # 8001d128 <disk+0x2128>
    80005850:	00017517          	auipc	a0,0x17
    80005854:	7c850513          	addi	a0,a0,1992 # 8001d018 <disk+0x2018>
    80005858:	ffffc097          	auipc	ra,0xffffc
    8000585c:	f96080e7          	jalr	-106(ra) # 800017ee <sleep>
  for(int i = 0; i < 3; i++){
    80005860:	f9040613          	addi	a2,s0,-112
    80005864:	894e                	mv	s2,s3
    80005866:	b74d                	j	80005808 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005868:	00017717          	auipc	a4,0x17
    8000586c:	79873703          	ld	a4,1944(a4) # 8001d000 <disk+0x2000>
    80005870:	973e                	add	a4,a4,a5
    80005872:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005876:	00015897          	auipc	a7,0x15
    8000587a:	78a88893          	addi	a7,a7,1930 # 8001b000 <disk>
    8000587e:	00017717          	auipc	a4,0x17
    80005882:	78270713          	addi	a4,a4,1922 # 8001d000 <disk+0x2000>
    80005886:	6314                	ld	a3,0(a4)
    80005888:	96be                	add	a3,a3,a5
    8000588a:	00c6d583          	lhu	a1,12(a3)
    8000588e:	0015e593          	ori	a1,a1,1
    80005892:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005896:	f9842683          	lw	a3,-104(s0)
    8000589a:	630c                	ld	a1,0(a4)
    8000589c:	97ae                	add	a5,a5,a1
    8000589e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058a2:	20050593          	addi	a1,a0,512
    800058a6:	0592                	slli	a1,a1,0x4
    800058a8:	95c6                	add	a1,a1,a7
    800058aa:	57fd                	li	a5,-1
    800058ac:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058b0:	00469793          	slli	a5,a3,0x4
    800058b4:	00073803          	ld	a6,0(a4)
    800058b8:	983e                	add	a6,a6,a5
    800058ba:	6689                	lui	a3,0x2
    800058bc:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800058c0:	96b2                	add	a3,a3,a2
    800058c2:	96c6                	add	a3,a3,a7
    800058c4:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800058c8:	6314                	ld	a3,0(a4)
    800058ca:	96be                	add	a3,a3,a5
    800058cc:	4605                	li	a2,1
    800058ce:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058d0:	6314                	ld	a3,0(a4)
    800058d2:	96be                	add	a3,a3,a5
    800058d4:	4809                	li	a6,2
    800058d6:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800058da:	6314                	ld	a3,0(a4)
    800058dc:	97b6                	add	a5,a5,a3
    800058de:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058e2:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    800058e6:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058ea:	6714                	ld	a3,8(a4)
    800058ec:	0026d783          	lhu	a5,2(a3)
    800058f0:	8b9d                	andi	a5,a5,7
    800058f2:	0786                	slli	a5,a5,0x1
    800058f4:	96be                	add	a3,a3,a5
    800058f6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800058fa:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800058fe:	6718                	ld	a4,8(a4)
    80005900:	00275783          	lhu	a5,2(a4)
    80005904:	2785                	addiw	a5,a5,1
    80005906:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000590a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000590e:	100017b7          	lui	a5,0x10001
    80005912:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005916:	004a2783          	lw	a5,4(s4)
    8000591a:	02c79163          	bne	a5,a2,8000593c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000591e:	00018917          	auipc	s2,0x18
    80005922:	80a90913          	addi	s2,s2,-2038 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005926:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005928:	85ca                	mv	a1,s2
    8000592a:	8552                	mv	a0,s4
    8000592c:	ffffc097          	auipc	ra,0xffffc
    80005930:	ec2080e7          	jalr	-318(ra) # 800017ee <sleep>
  while(b->disk == 1) {
    80005934:	004a2783          	lw	a5,4(s4)
    80005938:	fe9788e3          	beq	a5,s1,80005928 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000593c:	f9042903          	lw	s2,-112(s0)
    80005940:	20090713          	addi	a4,s2,512
    80005944:	0712                	slli	a4,a4,0x4
    80005946:	00015797          	auipc	a5,0x15
    8000594a:	6ba78793          	addi	a5,a5,1722 # 8001b000 <disk>
    8000594e:	97ba                	add	a5,a5,a4
    80005950:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005954:	00017997          	auipc	s3,0x17
    80005958:	6ac98993          	addi	s3,s3,1708 # 8001d000 <disk+0x2000>
    8000595c:	00491713          	slli	a4,s2,0x4
    80005960:	0009b783          	ld	a5,0(s3)
    80005964:	97ba                	add	a5,a5,a4
    80005966:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000596a:	854a                	mv	a0,s2
    8000596c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005970:	00000097          	auipc	ra,0x0
    80005974:	c3a080e7          	jalr	-966(ra) # 800055aa <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005978:	8885                	andi	s1,s1,1
    8000597a:	f0ed                	bnez	s1,8000595c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000597c:	00017517          	auipc	a0,0x17
    80005980:	7ac50513          	addi	a0,a0,1964 # 8001d128 <disk+0x2128>
    80005984:	00001097          	auipc	ra,0x1
    80005988:	ce6080e7          	jalr	-794(ra) # 8000666a <release>
}
    8000598c:	70a6                	ld	ra,104(sp)
    8000598e:	7406                	ld	s0,96(sp)
    80005990:	64e6                	ld	s1,88(sp)
    80005992:	6946                	ld	s2,80(sp)
    80005994:	69a6                	ld	s3,72(sp)
    80005996:	6a06                	ld	s4,64(sp)
    80005998:	7ae2                	ld	s5,56(sp)
    8000599a:	7b42                	ld	s6,48(sp)
    8000599c:	7ba2                	ld	s7,40(sp)
    8000599e:	7c02                	ld	s8,32(sp)
    800059a0:	6ce2                	ld	s9,24(sp)
    800059a2:	6165                	addi	sp,sp,112
    800059a4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059a6:	f9042503          	lw	a0,-112(s0)
    800059aa:	00451613          	slli	a2,a0,0x4
  if(write)
    800059ae:	00015597          	auipc	a1,0x15
    800059b2:	65258593          	addi	a1,a1,1618 # 8001b000 <disk>
    800059b6:	20050793          	addi	a5,a0,512
    800059ba:	0792                	slli	a5,a5,0x4
    800059bc:	97ae                	add	a5,a5,a1
    800059be:	01903733          	snez	a4,s9
    800059c2:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800059c6:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800059ca:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800059ce:	00017717          	auipc	a4,0x17
    800059d2:	63270713          	addi	a4,a4,1586 # 8001d000 <disk+0x2000>
    800059d6:	6314                	ld	a3,0(a4)
    800059d8:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059da:	6789                	lui	a5,0x2
    800059dc:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800059e0:	97b2                	add	a5,a5,a2
    800059e2:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800059e4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800059e6:	631c                	ld	a5,0(a4)
    800059e8:	97b2                	add	a5,a5,a2
    800059ea:	46c1                	li	a3,16
    800059ec:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800059ee:	631c                	ld	a5,0(a4)
    800059f0:	97b2                	add	a5,a5,a2
    800059f2:	4685                	li	a3,1
    800059f4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800059f8:	f9442783          	lw	a5,-108(s0)
    800059fc:	6314                	ld	a3,0(a4)
    800059fe:	96b2                	add	a3,a3,a2
    80005a00:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005a04:	0792                	slli	a5,a5,0x4
    80005a06:	6314                	ld	a3,0(a4)
    80005a08:	96be                	add	a3,a3,a5
    80005a0a:	058a0593          	addi	a1,s4,88
    80005a0e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005a10:	6318                	ld	a4,0(a4)
    80005a12:	973e                	add	a4,a4,a5
    80005a14:	40000693          	li	a3,1024
    80005a18:	c714                	sw	a3,8(a4)
  if(write)
    80005a1a:	e40c97e3          	bnez	s9,80005868 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005a1e:	00017717          	auipc	a4,0x17
    80005a22:	5e273703          	ld	a4,1506(a4) # 8001d000 <disk+0x2000>
    80005a26:	973e                	add	a4,a4,a5
    80005a28:	4689                	li	a3,2
    80005a2a:	00d71623          	sh	a3,12(a4)
    80005a2e:	b5a1                	j	80005876 <virtio_disk_rw+0xd4>

0000000080005a30 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a30:	1101                	addi	sp,sp,-32
    80005a32:	ec06                	sd	ra,24(sp)
    80005a34:	e822                	sd	s0,16(sp)
    80005a36:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a38:	00017517          	auipc	a0,0x17
    80005a3c:	6f050513          	addi	a0,a0,1776 # 8001d128 <disk+0x2128>
    80005a40:	00001097          	auipc	ra,0x1
    80005a44:	b76080e7          	jalr	-1162(ra) # 800065b6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a48:	100017b7          	lui	a5,0x10001
    80005a4c:	53b8                	lw	a4,96(a5)
    80005a4e:	8b0d                	andi	a4,a4,3
    80005a50:	100017b7          	lui	a5,0x10001
    80005a54:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005a56:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a5a:	00017797          	auipc	a5,0x17
    80005a5e:	5a678793          	addi	a5,a5,1446 # 8001d000 <disk+0x2000>
    80005a62:	6b94                	ld	a3,16(a5)
    80005a64:	0207d703          	lhu	a4,32(a5)
    80005a68:	0026d783          	lhu	a5,2(a3)
    80005a6c:	06f70563          	beq	a4,a5,80005ad6 <virtio_disk_intr+0xa6>
    80005a70:	e426                	sd	s1,8(sp)
    80005a72:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a74:	00015917          	auipc	s2,0x15
    80005a78:	58c90913          	addi	s2,s2,1420 # 8001b000 <disk>
    80005a7c:	00017497          	auipc	s1,0x17
    80005a80:	58448493          	addi	s1,s1,1412 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005a84:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a88:	6898                	ld	a4,16(s1)
    80005a8a:	0204d783          	lhu	a5,32(s1)
    80005a8e:	8b9d                	andi	a5,a5,7
    80005a90:	078e                	slli	a5,a5,0x3
    80005a92:	97ba                	add	a5,a5,a4
    80005a94:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a96:	20078713          	addi	a4,a5,512
    80005a9a:	0712                	slli	a4,a4,0x4
    80005a9c:	974a                	add	a4,a4,s2
    80005a9e:	03074703          	lbu	a4,48(a4)
    80005aa2:	e731                	bnez	a4,80005aee <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005aa4:	20078793          	addi	a5,a5,512
    80005aa8:	0792                	slli	a5,a5,0x4
    80005aaa:	97ca                	add	a5,a5,s2
    80005aac:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005aae:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005ab2:	ffffc097          	auipc	ra,0xffffc
    80005ab6:	ec8080e7          	jalr	-312(ra) # 8000197a <wakeup>

    disk.used_idx += 1;
    80005aba:	0204d783          	lhu	a5,32(s1)
    80005abe:	2785                	addiw	a5,a5,1
    80005ac0:	17c2                	slli	a5,a5,0x30
    80005ac2:	93c1                	srli	a5,a5,0x30
    80005ac4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005ac8:	6898                	ld	a4,16(s1)
    80005aca:	00275703          	lhu	a4,2(a4)
    80005ace:	faf71be3          	bne	a4,a5,80005a84 <virtio_disk_intr+0x54>
    80005ad2:	64a2                	ld	s1,8(sp)
    80005ad4:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005ad6:	00017517          	auipc	a0,0x17
    80005ada:	65250513          	addi	a0,a0,1618 # 8001d128 <disk+0x2128>
    80005ade:	00001097          	auipc	ra,0x1
    80005ae2:	b8c080e7          	jalr	-1140(ra) # 8000666a <release>
}
    80005ae6:	60e2                	ld	ra,24(sp)
    80005ae8:	6442                	ld	s0,16(sp)
    80005aea:	6105                	addi	sp,sp,32
    80005aec:	8082                	ret
      panic("virtio_disk_intr status");
    80005aee:	00003517          	auipc	a0,0x3
    80005af2:	c6a50513          	addi	a0,a0,-918 # 80008758 <etext+0x758>
    80005af6:	00000097          	auipc	ra,0x0
    80005afa:	546080e7          	jalr	1350(ra) # 8000603c <panic>

0000000080005afe <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005afe:	1141                	addi	sp,sp,-16
    80005b00:	e422                	sd	s0,8(sp)
    80005b02:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b04:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005b08:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005b0c:	0037979b          	slliw	a5,a5,0x3
    80005b10:	02004737          	lui	a4,0x2004
    80005b14:	97ba                	add	a5,a5,a4
    80005b16:	0200c737          	lui	a4,0x200c
    80005b1a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005b1c:	6318                	ld	a4,0(a4)
    80005b1e:	000f4637          	lui	a2,0xf4
    80005b22:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b26:	9732                	add	a4,a4,a2
    80005b28:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b2a:	00259693          	slli	a3,a1,0x2
    80005b2e:	96ae                	add	a3,a3,a1
    80005b30:	068e                	slli	a3,a3,0x3
    80005b32:	00018717          	auipc	a4,0x18
    80005b36:	4ce70713          	addi	a4,a4,1230 # 8001e000 <timer_scratch>
    80005b3a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b3c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b3e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b40:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b44:	00000797          	auipc	a5,0x0
    80005b48:	99c78793          	addi	a5,a5,-1636 # 800054e0 <timervec>
    80005b4c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b50:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b54:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b58:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b5c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b60:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b64:	30479073          	csrw	mie,a5
}
    80005b68:	6422                	ld	s0,8(sp)
    80005b6a:	0141                	addi	sp,sp,16
    80005b6c:	8082                	ret

0000000080005b6e <start>:
{
    80005b6e:	1141                	addi	sp,sp,-16
    80005b70:	e406                	sd	ra,8(sp)
    80005b72:	e022                	sd	s0,0(sp)
    80005b74:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b76:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b7a:	7779                	lui	a4,0xffffe
    80005b7c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005b80:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b82:	6705                	lui	a4,0x1
    80005b84:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b88:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b8a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b8e:	ffffb797          	auipc	a5,0xffffb
    80005b92:	90078793          	addi	a5,a5,-1792 # 8000048e <main>
    80005b96:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b9a:	4781                	li	a5,0
    80005b9c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005ba0:	67c1                	lui	a5,0x10
    80005ba2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005ba4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005ba8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005bac:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005bb0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005bb4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005bb8:	57fd                	li	a5,-1
    80005bba:	83a9                	srli	a5,a5,0xa
    80005bbc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005bc0:	47bd                	li	a5,15
    80005bc2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005bc6:	00000097          	auipc	ra,0x0
    80005bca:	f38080e7          	jalr	-200(ra) # 80005afe <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bce:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005bd2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005bd4:	823e                	mv	tp,a5
  asm volatile("mret");
    80005bd6:	30200073          	mret
}
    80005bda:	60a2                	ld	ra,8(sp)
    80005bdc:	6402                	ld	s0,0(sp)
    80005bde:	0141                	addi	sp,sp,16
    80005be0:	8082                	ret

0000000080005be2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005be2:	715d                	addi	sp,sp,-80
    80005be4:	e486                	sd	ra,72(sp)
    80005be6:	e0a2                	sd	s0,64(sp)
    80005be8:	f84a                	sd	s2,48(sp)
    80005bea:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005bec:	04c05663          	blez	a2,80005c38 <consolewrite+0x56>
    80005bf0:	fc26                	sd	s1,56(sp)
    80005bf2:	f44e                	sd	s3,40(sp)
    80005bf4:	f052                	sd	s4,32(sp)
    80005bf6:	ec56                	sd	s5,24(sp)
    80005bf8:	8a2a                	mv	s4,a0
    80005bfa:	84ae                	mv	s1,a1
    80005bfc:	89b2                	mv	s3,a2
    80005bfe:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005c00:	5afd                	li	s5,-1
    80005c02:	4685                	li	a3,1
    80005c04:	8626                	mv	a2,s1
    80005c06:	85d2                	mv	a1,s4
    80005c08:	fbf40513          	addi	a0,s0,-65
    80005c0c:	ffffc097          	auipc	ra,0xffffc
    80005c10:	fdc080e7          	jalr	-36(ra) # 80001be8 <either_copyin>
    80005c14:	03550463          	beq	a0,s5,80005c3c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005c18:	fbf44503          	lbu	a0,-65(s0)
    80005c1c:	00000097          	auipc	ra,0x0
    80005c20:	7de080e7          	jalr	2014(ra) # 800063fa <uartputc>
  for(i = 0; i < n; i++){
    80005c24:	2905                	addiw	s2,s2,1
    80005c26:	0485                	addi	s1,s1,1
    80005c28:	fd299de3          	bne	s3,s2,80005c02 <consolewrite+0x20>
    80005c2c:	894e                	mv	s2,s3
    80005c2e:	74e2                	ld	s1,56(sp)
    80005c30:	79a2                	ld	s3,40(sp)
    80005c32:	7a02                	ld	s4,32(sp)
    80005c34:	6ae2                	ld	s5,24(sp)
    80005c36:	a039                	j	80005c44 <consolewrite+0x62>
    80005c38:	4901                	li	s2,0
    80005c3a:	a029                	j	80005c44 <consolewrite+0x62>
    80005c3c:	74e2                	ld	s1,56(sp)
    80005c3e:	79a2                	ld	s3,40(sp)
    80005c40:	7a02                	ld	s4,32(sp)
    80005c42:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005c44:	854a                	mv	a0,s2
    80005c46:	60a6                	ld	ra,72(sp)
    80005c48:	6406                	ld	s0,64(sp)
    80005c4a:	7942                	ld	s2,48(sp)
    80005c4c:	6161                	addi	sp,sp,80
    80005c4e:	8082                	ret

0000000080005c50 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c50:	711d                	addi	sp,sp,-96
    80005c52:	ec86                	sd	ra,88(sp)
    80005c54:	e8a2                	sd	s0,80(sp)
    80005c56:	e4a6                	sd	s1,72(sp)
    80005c58:	e0ca                	sd	s2,64(sp)
    80005c5a:	fc4e                	sd	s3,56(sp)
    80005c5c:	f852                	sd	s4,48(sp)
    80005c5e:	f456                	sd	s5,40(sp)
    80005c60:	f05a                	sd	s6,32(sp)
    80005c62:	1080                	addi	s0,sp,96
    80005c64:	8aaa                	mv	s5,a0
    80005c66:	8a2e                	mv	s4,a1
    80005c68:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c6a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005c6e:	00020517          	auipc	a0,0x20
    80005c72:	4d250513          	addi	a0,a0,1234 # 80026140 <cons>
    80005c76:	00001097          	auipc	ra,0x1
    80005c7a:	940080e7          	jalr	-1728(ra) # 800065b6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c7e:	00020497          	auipc	s1,0x20
    80005c82:	4c248493          	addi	s1,s1,1218 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c86:	00020917          	auipc	s2,0x20
    80005c8a:	55290913          	addi	s2,s2,1362 # 800261d8 <cons+0x98>
  while(n > 0){
    80005c8e:	0d305463          	blez	s3,80005d56 <consoleread+0x106>
    while(cons.r == cons.w){
    80005c92:	0984a783          	lw	a5,152(s1)
    80005c96:	09c4a703          	lw	a4,156(s1)
    80005c9a:	0af71963          	bne	a4,a5,80005d4c <consoleread+0xfc>
      if(myproc()->killed){
    80005c9e:	ffffb097          	auipc	ra,0xffffb
    80005ca2:	48a080e7          	jalr	1162(ra) # 80001128 <myproc>
    80005ca6:	551c                	lw	a5,40(a0)
    80005ca8:	e7ad                	bnez	a5,80005d12 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005caa:	85a6                	mv	a1,s1
    80005cac:	854a                	mv	a0,s2
    80005cae:	ffffc097          	auipc	ra,0xffffc
    80005cb2:	b40080e7          	jalr	-1216(ra) # 800017ee <sleep>
    while(cons.r == cons.w){
    80005cb6:	0984a783          	lw	a5,152(s1)
    80005cba:	09c4a703          	lw	a4,156(s1)
    80005cbe:	fef700e3          	beq	a4,a5,80005c9e <consoleread+0x4e>
    80005cc2:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005cc4:	00020717          	auipc	a4,0x20
    80005cc8:	47c70713          	addi	a4,a4,1148 # 80026140 <cons>
    80005ccc:	0017869b          	addiw	a3,a5,1
    80005cd0:	08d72c23          	sw	a3,152(a4)
    80005cd4:	07f7f693          	andi	a3,a5,127
    80005cd8:	9736                	add	a4,a4,a3
    80005cda:	01874703          	lbu	a4,24(a4)
    80005cde:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005ce2:	4691                	li	a3,4
    80005ce4:	04db8a63          	beq	s7,a3,80005d38 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005ce8:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cec:	4685                	li	a3,1
    80005cee:	faf40613          	addi	a2,s0,-81
    80005cf2:	85d2                	mv	a1,s4
    80005cf4:	8556                	mv	a0,s5
    80005cf6:	ffffc097          	auipc	ra,0xffffc
    80005cfa:	e9c080e7          	jalr	-356(ra) # 80001b92 <either_copyout>
    80005cfe:	57fd                	li	a5,-1
    80005d00:	04f50a63          	beq	a0,a5,80005d54 <consoleread+0x104>
      break;

    dst++;
    80005d04:	0a05                	addi	s4,s4,1
    --n;
    80005d06:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005d08:	47a9                	li	a5,10
    80005d0a:	06fb8163          	beq	s7,a5,80005d6c <consoleread+0x11c>
    80005d0e:	6be2                	ld	s7,24(sp)
    80005d10:	bfbd                	j	80005c8e <consoleread+0x3e>
        release(&cons.lock);
    80005d12:	00020517          	auipc	a0,0x20
    80005d16:	42e50513          	addi	a0,a0,1070 # 80026140 <cons>
    80005d1a:	00001097          	auipc	ra,0x1
    80005d1e:	950080e7          	jalr	-1712(ra) # 8000666a <release>
        return -1;
    80005d22:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005d24:	60e6                	ld	ra,88(sp)
    80005d26:	6446                	ld	s0,80(sp)
    80005d28:	64a6                	ld	s1,72(sp)
    80005d2a:	6906                	ld	s2,64(sp)
    80005d2c:	79e2                	ld	s3,56(sp)
    80005d2e:	7a42                	ld	s4,48(sp)
    80005d30:	7aa2                	ld	s5,40(sp)
    80005d32:	7b02                	ld	s6,32(sp)
    80005d34:	6125                	addi	sp,sp,96
    80005d36:	8082                	ret
      if(n < target){
    80005d38:	0009871b          	sext.w	a4,s3
    80005d3c:	01677a63          	bgeu	a4,s6,80005d50 <consoleread+0x100>
        cons.r--;
    80005d40:	00020717          	auipc	a4,0x20
    80005d44:	48f72c23          	sw	a5,1176(a4) # 800261d8 <cons+0x98>
    80005d48:	6be2                	ld	s7,24(sp)
    80005d4a:	a031                	j	80005d56 <consoleread+0x106>
    80005d4c:	ec5e                	sd	s7,24(sp)
    80005d4e:	bf9d                	j	80005cc4 <consoleread+0x74>
    80005d50:	6be2                	ld	s7,24(sp)
    80005d52:	a011                	j	80005d56 <consoleread+0x106>
    80005d54:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005d56:	00020517          	auipc	a0,0x20
    80005d5a:	3ea50513          	addi	a0,a0,1002 # 80026140 <cons>
    80005d5e:	00001097          	auipc	ra,0x1
    80005d62:	90c080e7          	jalr	-1780(ra) # 8000666a <release>
  return target - n;
    80005d66:	413b053b          	subw	a0,s6,s3
    80005d6a:	bf6d                	j	80005d24 <consoleread+0xd4>
    80005d6c:	6be2                	ld	s7,24(sp)
    80005d6e:	b7e5                	j	80005d56 <consoleread+0x106>

0000000080005d70 <consputc>:
{
    80005d70:	1141                	addi	sp,sp,-16
    80005d72:	e406                	sd	ra,8(sp)
    80005d74:	e022                	sd	s0,0(sp)
    80005d76:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005d78:	10000793          	li	a5,256
    80005d7c:	00f50a63          	beq	a0,a5,80005d90 <consputc+0x20>
    uartputc_sync(c);
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	59c080e7          	jalr	1436(ra) # 8000631c <uartputc_sync>
}
    80005d88:	60a2                	ld	ra,8(sp)
    80005d8a:	6402                	ld	s0,0(sp)
    80005d8c:	0141                	addi	sp,sp,16
    80005d8e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d90:	4521                	li	a0,8
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	58a080e7          	jalr	1418(ra) # 8000631c <uartputc_sync>
    80005d9a:	02000513          	li	a0,32
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	57e080e7          	jalr	1406(ra) # 8000631c <uartputc_sync>
    80005da6:	4521                	li	a0,8
    80005da8:	00000097          	auipc	ra,0x0
    80005dac:	574080e7          	jalr	1396(ra) # 8000631c <uartputc_sync>
    80005db0:	bfe1                	j	80005d88 <consputc+0x18>

0000000080005db2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005db2:	1101                	addi	sp,sp,-32
    80005db4:	ec06                	sd	ra,24(sp)
    80005db6:	e822                	sd	s0,16(sp)
    80005db8:	e426                	sd	s1,8(sp)
    80005dba:	1000                	addi	s0,sp,32
    80005dbc:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005dbe:	00020517          	auipc	a0,0x20
    80005dc2:	38250513          	addi	a0,a0,898 # 80026140 <cons>
    80005dc6:	00000097          	auipc	ra,0x0
    80005dca:	7f0080e7          	jalr	2032(ra) # 800065b6 <acquire>

  switch(c){
    80005dce:	47d5                	li	a5,21
    80005dd0:	0af48563          	beq	s1,a5,80005e7a <consoleintr+0xc8>
    80005dd4:	0297c963          	blt	a5,s1,80005e06 <consoleintr+0x54>
    80005dd8:	47a1                	li	a5,8
    80005dda:	0ef48c63          	beq	s1,a5,80005ed2 <consoleintr+0x120>
    80005dde:	47c1                	li	a5,16
    80005de0:	10f49f63          	bne	s1,a5,80005efe <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005de4:	ffffc097          	auipc	ra,0xffffc
    80005de8:	e5a080e7          	jalr	-422(ra) # 80001c3e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005dec:	00020517          	auipc	a0,0x20
    80005df0:	35450513          	addi	a0,a0,852 # 80026140 <cons>
    80005df4:	00001097          	auipc	ra,0x1
    80005df8:	876080e7          	jalr	-1930(ra) # 8000666a <release>
}
    80005dfc:	60e2                	ld	ra,24(sp)
    80005dfe:	6442                	ld	s0,16(sp)
    80005e00:	64a2                	ld	s1,8(sp)
    80005e02:	6105                	addi	sp,sp,32
    80005e04:	8082                	ret
  switch(c){
    80005e06:	07f00793          	li	a5,127
    80005e0a:	0cf48463          	beq	s1,a5,80005ed2 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e0e:	00020717          	auipc	a4,0x20
    80005e12:	33270713          	addi	a4,a4,818 # 80026140 <cons>
    80005e16:	0a072783          	lw	a5,160(a4)
    80005e1a:	09872703          	lw	a4,152(a4)
    80005e1e:	9f99                	subw	a5,a5,a4
    80005e20:	07f00713          	li	a4,127
    80005e24:	fcf764e3          	bltu	a4,a5,80005dec <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005e28:	47b5                	li	a5,13
    80005e2a:	0cf48d63          	beq	s1,a5,80005f04 <consoleintr+0x152>
      consputc(c);
    80005e2e:	8526                	mv	a0,s1
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	f40080e7          	jalr	-192(ra) # 80005d70 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e38:	00020797          	auipc	a5,0x20
    80005e3c:	30878793          	addi	a5,a5,776 # 80026140 <cons>
    80005e40:	0a07a703          	lw	a4,160(a5)
    80005e44:	0017069b          	addiw	a3,a4,1
    80005e48:	0006861b          	sext.w	a2,a3
    80005e4c:	0ad7a023          	sw	a3,160(a5)
    80005e50:	07f77713          	andi	a4,a4,127
    80005e54:	97ba                	add	a5,a5,a4
    80005e56:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005e5a:	47a9                	li	a5,10
    80005e5c:	0cf48b63          	beq	s1,a5,80005f32 <consoleintr+0x180>
    80005e60:	4791                	li	a5,4
    80005e62:	0cf48863          	beq	s1,a5,80005f32 <consoleintr+0x180>
    80005e66:	00020797          	auipc	a5,0x20
    80005e6a:	3727a783          	lw	a5,882(a5) # 800261d8 <cons+0x98>
    80005e6e:	0807879b          	addiw	a5,a5,128
    80005e72:	f6f61de3          	bne	a2,a5,80005dec <consoleintr+0x3a>
    80005e76:	863e                	mv	a2,a5
    80005e78:	a86d                	j	80005f32 <consoleintr+0x180>
    80005e7a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005e7c:	00020717          	auipc	a4,0x20
    80005e80:	2c470713          	addi	a4,a4,708 # 80026140 <cons>
    80005e84:	0a072783          	lw	a5,160(a4)
    80005e88:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e8c:	00020497          	auipc	s1,0x20
    80005e90:	2b448493          	addi	s1,s1,692 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005e94:	4929                	li	s2,10
    80005e96:	02f70a63          	beq	a4,a5,80005eca <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e9a:	37fd                	addiw	a5,a5,-1
    80005e9c:	07f7f713          	andi	a4,a5,127
    80005ea0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ea2:	01874703          	lbu	a4,24(a4)
    80005ea6:	03270463          	beq	a4,s2,80005ece <consoleintr+0x11c>
      cons.e--;
    80005eaa:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005eae:	10000513          	li	a0,256
    80005eb2:	00000097          	auipc	ra,0x0
    80005eb6:	ebe080e7          	jalr	-322(ra) # 80005d70 <consputc>
    while(cons.e != cons.w &&
    80005eba:	0a04a783          	lw	a5,160(s1)
    80005ebe:	09c4a703          	lw	a4,156(s1)
    80005ec2:	fcf71ce3          	bne	a4,a5,80005e9a <consoleintr+0xe8>
    80005ec6:	6902                	ld	s2,0(sp)
    80005ec8:	b715                	j	80005dec <consoleintr+0x3a>
    80005eca:	6902                	ld	s2,0(sp)
    80005ecc:	b705                	j	80005dec <consoleintr+0x3a>
    80005ece:	6902                	ld	s2,0(sp)
    80005ed0:	bf31                	j	80005dec <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005ed2:	00020717          	auipc	a4,0x20
    80005ed6:	26e70713          	addi	a4,a4,622 # 80026140 <cons>
    80005eda:	0a072783          	lw	a5,160(a4)
    80005ede:	09c72703          	lw	a4,156(a4)
    80005ee2:	f0f705e3          	beq	a4,a5,80005dec <consoleintr+0x3a>
      cons.e--;
    80005ee6:	37fd                	addiw	a5,a5,-1
    80005ee8:	00020717          	auipc	a4,0x20
    80005eec:	2ef72c23          	sw	a5,760(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005ef0:	10000513          	li	a0,256
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	e7c080e7          	jalr	-388(ra) # 80005d70 <consputc>
    80005efc:	bdc5                	j	80005dec <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005efe:	ee0487e3          	beqz	s1,80005dec <consoleintr+0x3a>
    80005f02:	b731                	j	80005e0e <consoleintr+0x5c>
      consputc(c);
    80005f04:	4529                	li	a0,10
    80005f06:	00000097          	auipc	ra,0x0
    80005f0a:	e6a080e7          	jalr	-406(ra) # 80005d70 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f0e:	00020797          	auipc	a5,0x20
    80005f12:	23278793          	addi	a5,a5,562 # 80026140 <cons>
    80005f16:	0a07a703          	lw	a4,160(a5)
    80005f1a:	0017069b          	addiw	a3,a4,1
    80005f1e:	0006861b          	sext.w	a2,a3
    80005f22:	0ad7a023          	sw	a3,160(a5)
    80005f26:	07f77713          	andi	a4,a4,127
    80005f2a:	97ba                	add	a5,a5,a4
    80005f2c:	4729                	li	a4,10
    80005f2e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005f32:	00020797          	auipc	a5,0x20
    80005f36:	2ac7a523          	sw	a2,682(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005f3a:	00020517          	auipc	a0,0x20
    80005f3e:	29e50513          	addi	a0,a0,670 # 800261d8 <cons+0x98>
    80005f42:	ffffc097          	auipc	ra,0xffffc
    80005f46:	a38080e7          	jalr	-1480(ra) # 8000197a <wakeup>
    80005f4a:	b54d                	j	80005dec <consoleintr+0x3a>

0000000080005f4c <consoleinit>:

void
consoleinit(void)
{
    80005f4c:	1141                	addi	sp,sp,-16
    80005f4e:	e406                	sd	ra,8(sp)
    80005f50:	e022                	sd	s0,0(sp)
    80005f52:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f54:	00003597          	auipc	a1,0x3
    80005f58:	81c58593          	addi	a1,a1,-2020 # 80008770 <etext+0x770>
    80005f5c:	00020517          	auipc	a0,0x20
    80005f60:	1e450513          	addi	a0,a0,484 # 80026140 <cons>
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	5c2080e7          	jalr	1474(ra) # 80006526 <initlock>

  uartinit();
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	354080e7          	jalr	852(ra) # 800062c0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f74:	00013797          	auipc	a5,0x13
    80005f78:	17478793          	addi	a5,a5,372 # 800190e8 <devsw>
    80005f7c:	00000717          	auipc	a4,0x0
    80005f80:	cd470713          	addi	a4,a4,-812 # 80005c50 <consoleread>
    80005f84:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f86:	00000717          	auipc	a4,0x0
    80005f8a:	c5c70713          	addi	a4,a4,-932 # 80005be2 <consolewrite>
    80005f8e:	ef98                	sd	a4,24(a5)
}
    80005f90:	60a2                	ld	ra,8(sp)
    80005f92:	6402                	ld	s0,0(sp)
    80005f94:	0141                	addi	sp,sp,16
    80005f96:	8082                	ret

0000000080005f98 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f98:	7179                	addi	sp,sp,-48
    80005f9a:	f406                	sd	ra,40(sp)
    80005f9c:	f022                	sd	s0,32(sp)
    80005f9e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005fa0:	c219                	beqz	a2,80005fa6 <printint+0xe>
    80005fa2:	08054963          	bltz	a0,80006034 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005fa6:	2501                	sext.w	a0,a0
    80005fa8:	4881                	li	a7,0
    80005faa:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005fae:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005fb0:	2581                	sext.w	a1,a1
    80005fb2:	00003617          	auipc	a2,0x3
    80005fb6:	91e60613          	addi	a2,a2,-1762 # 800088d0 <digits>
    80005fba:	883a                	mv	a6,a4
    80005fbc:	2705                	addiw	a4,a4,1
    80005fbe:	02b577bb          	remuw	a5,a0,a1
    80005fc2:	1782                	slli	a5,a5,0x20
    80005fc4:	9381                	srli	a5,a5,0x20
    80005fc6:	97b2                	add	a5,a5,a2
    80005fc8:	0007c783          	lbu	a5,0(a5)
    80005fcc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005fd0:	0005079b          	sext.w	a5,a0
    80005fd4:	02b5553b          	divuw	a0,a0,a1
    80005fd8:	0685                	addi	a3,a3,1
    80005fda:	feb7f0e3          	bgeu	a5,a1,80005fba <printint+0x22>

  if(sign)
    80005fde:	00088c63          	beqz	a7,80005ff6 <printint+0x5e>
    buf[i++] = '-';
    80005fe2:	fe070793          	addi	a5,a4,-32
    80005fe6:	00878733          	add	a4,a5,s0
    80005fea:	02d00793          	li	a5,45
    80005fee:	fef70823          	sb	a5,-16(a4)
    80005ff2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ff6:	02e05b63          	blez	a4,8000602c <printint+0x94>
    80005ffa:	ec26                	sd	s1,24(sp)
    80005ffc:	e84a                	sd	s2,16(sp)
    80005ffe:	fd040793          	addi	a5,s0,-48
    80006002:	00e784b3          	add	s1,a5,a4
    80006006:	fff78913          	addi	s2,a5,-1
    8000600a:	993a                	add	s2,s2,a4
    8000600c:	377d                	addiw	a4,a4,-1
    8000600e:	1702                	slli	a4,a4,0x20
    80006010:	9301                	srli	a4,a4,0x20
    80006012:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006016:	fff4c503          	lbu	a0,-1(s1)
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	d56080e7          	jalr	-682(ra) # 80005d70 <consputc>
  while(--i >= 0)
    80006022:	14fd                	addi	s1,s1,-1
    80006024:	ff2499e3          	bne	s1,s2,80006016 <printint+0x7e>
    80006028:	64e2                	ld	s1,24(sp)
    8000602a:	6942                	ld	s2,16(sp)
}
    8000602c:	70a2                	ld	ra,40(sp)
    8000602e:	7402                	ld	s0,32(sp)
    80006030:	6145                	addi	sp,sp,48
    80006032:	8082                	ret
    x = -xx;
    80006034:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006038:	4885                	li	a7,1
    x = -xx;
    8000603a:	bf85                	j	80005faa <printint+0x12>

000000008000603c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000603c:	1101                	addi	sp,sp,-32
    8000603e:	ec06                	sd	ra,24(sp)
    80006040:	e822                	sd	s0,16(sp)
    80006042:	e426                	sd	s1,8(sp)
    80006044:	1000                	addi	s0,sp,32
    80006046:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006048:	00020797          	auipc	a5,0x20
    8000604c:	1a07ac23          	sw	zero,440(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80006050:	00002517          	auipc	a0,0x2
    80006054:	72850513          	addi	a0,a0,1832 # 80008778 <etext+0x778>
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	02e080e7          	jalr	46(ra) # 80006086 <printf>
  printf(s);
    80006060:	8526                	mv	a0,s1
    80006062:	00000097          	auipc	ra,0x0
    80006066:	024080e7          	jalr	36(ra) # 80006086 <printf>
  printf("\n");
    8000606a:	00002517          	auipc	a0,0x2
    8000606e:	24650513          	addi	a0,a0,582 # 800082b0 <etext+0x2b0>
    80006072:	00000097          	auipc	ra,0x0
    80006076:	014080e7          	jalr	20(ra) # 80006086 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000607a:	4785                	li	a5,1
    8000607c:	00003717          	auipc	a4,0x3
    80006080:	faf72023          	sw	a5,-96(a4) # 8000901c <panicked>
  for(;;)
    80006084:	a001                	j	80006084 <panic+0x48>

0000000080006086 <printf>:
{
    80006086:	7131                	addi	sp,sp,-192
    80006088:	fc86                	sd	ra,120(sp)
    8000608a:	f8a2                	sd	s0,112(sp)
    8000608c:	e8d2                	sd	s4,80(sp)
    8000608e:	f06a                	sd	s10,32(sp)
    80006090:	0100                	addi	s0,sp,128
    80006092:	8a2a                	mv	s4,a0
    80006094:	e40c                	sd	a1,8(s0)
    80006096:	e810                	sd	a2,16(s0)
    80006098:	ec14                	sd	a3,24(s0)
    8000609a:	f018                	sd	a4,32(s0)
    8000609c:	f41c                	sd	a5,40(s0)
    8000609e:	03043823          	sd	a6,48(s0)
    800060a2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800060a6:	00020d17          	auipc	s10,0x20
    800060aa:	15ad2d03          	lw	s10,346(s10) # 80026200 <pr+0x18>
  if(locking)
    800060ae:	040d1463          	bnez	s10,800060f6 <printf+0x70>
  if (fmt == 0)
    800060b2:	040a0b63          	beqz	s4,80006108 <printf+0x82>
  va_start(ap, fmt);
    800060b6:	00840793          	addi	a5,s0,8
    800060ba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060be:	000a4503          	lbu	a0,0(s4)
    800060c2:	18050b63          	beqz	a0,80006258 <printf+0x1d2>
    800060c6:	f4a6                	sd	s1,104(sp)
    800060c8:	f0ca                	sd	s2,96(sp)
    800060ca:	ecce                	sd	s3,88(sp)
    800060cc:	e4d6                	sd	s5,72(sp)
    800060ce:	e0da                	sd	s6,64(sp)
    800060d0:	fc5e                	sd	s7,56(sp)
    800060d2:	f862                	sd	s8,48(sp)
    800060d4:	f466                	sd	s9,40(sp)
    800060d6:	ec6e                	sd	s11,24(sp)
    800060d8:	4981                	li	s3,0
    if(c != '%'){
    800060da:	02500b13          	li	s6,37
    switch(c){
    800060de:	07000b93          	li	s7,112
  consputc('x');
    800060e2:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060e4:	00002a97          	auipc	s5,0x2
    800060e8:	7eca8a93          	addi	s5,s5,2028 # 800088d0 <digits>
    switch(c){
    800060ec:	07300c13          	li	s8,115
    800060f0:	06400d93          	li	s11,100
    800060f4:	a0b1                	j	80006140 <printf+0xba>
    acquire(&pr.lock);
    800060f6:	00020517          	auipc	a0,0x20
    800060fa:	0f250513          	addi	a0,a0,242 # 800261e8 <pr>
    800060fe:	00000097          	auipc	ra,0x0
    80006102:	4b8080e7          	jalr	1208(ra) # 800065b6 <acquire>
    80006106:	b775                	j	800060b2 <printf+0x2c>
    80006108:	f4a6                	sd	s1,104(sp)
    8000610a:	f0ca                	sd	s2,96(sp)
    8000610c:	ecce                	sd	s3,88(sp)
    8000610e:	e4d6                	sd	s5,72(sp)
    80006110:	e0da                	sd	s6,64(sp)
    80006112:	fc5e                	sd	s7,56(sp)
    80006114:	f862                	sd	s8,48(sp)
    80006116:	f466                	sd	s9,40(sp)
    80006118:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000611a:	00002517          	auipc	a0,0x2
    8000611e:	66e50513          	addi	a0,a0,1646 # 80008788 <etext+0x788>
    80006122:	00000097          	auipc	ra,0x0
    80006126:	f1a080e7          	jalr	-230(ra) # 8000603c <panic>
      consputc(c);
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	c46080e7          	jalr	-954(ra) # 80005d70 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006132:	2985                	addiw	s3,s3,1
    80006134:	013a07b3          	add	a5,s4,s3
    80006138:	0007c503          	lbu	a0,0(a5)
    8000613c:	10050563          	beqz	a0,80006246 <printf+0x1c0>
    if(c != '%'){
    80006140:	ff6515e3          	bne	a0,s6,8000612a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80006144:	2985                	addiw	s3,s3,1
    80006146:	013a07b3          	add	a5,s4,s3
    8000614a:	0007c783          	lbu	a5,0(a5)
    8000614e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006152:	10078b63          	beqz	a5,80006268 <printf+0x1e2>
    switch(c){
    80006156:	05778a63          	beq	a5,s7,800061aa <printf+0x124>
    8000615a:	02fbf663          	bgeu	s7,a5,80006186 <printf+0x100>
    8000615e:	09878863          	beq	a5,s8,800061ee <printf+0x168>
    80006162:	07800713          	li	a4,120
    80006166:	0ce79563          	bne	a5,a4,80006230 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000616a:	f8843783          	ld	a5,-120(s0)
    8000616e:	00878713          	addi	a4,a5,8
    80006172:	f8e43423          	sd	a4,-120(s0)
    80006176:	4605                	li	a2,1
    80006178:	85e6                	mv	a1,s9
    8000617a:	4388                	lw	a0,0(a5)
    8000617c:	00000097          	auipc	ra,0x0
    80006180:	e1c080e7          	jalr	-484(ra) # 80005f98 <printint>
      break;
    80006184:	b77d                	j	80006132 <printf+0xac>
    switch(c){
    80006186:	09678f63          	beq	a5,s6,80006224 <printf+0x19e>
    8000618a:	0bb79363          	bne	a5,s11,80006230 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    8000618e:	f8843783          	ld	a5,-120(s0)
    80006192:	00878713          	addi	a4,a5,8
    80006196:	f8e43423          	sd	a4,-120(s0)
    8000619a:	4605                	li	a2,1
    8000619c:	45a9                	li	a1,10
    8000619e:	4388                	lw	a0,0(a5)
    800061a0:	00000097          	auipc	ra,0x0
    800061a4:	df8080e7          	jalr	-520(ra) # 80005f98 <printint>
      break;
    800061a8:	b769                	j	80006132 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800061aa:	f8843783          	ld	a5,-120(s0)
    800061ae:	00878713          	addi	a4,a5,8
    800061b2:	f8e43423          	sd	a4,-120(s0)
    800061b6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800061ba:	03000513          	li	a0,48
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	bb2080e7          	jalr	-1102(ra) # 80005d70 <consputc>
  consputc('x');
    800061c6:	07800513          	li	a0,120
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	ba6080e7          	jalr	-1114(ra) # 80005d70 <consputc>
    800061d2:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061d4:	03c95793          	srli	a5,s2,0x3c
    800061d8:	97d6                	add	a5,a5,s5
    800061da:	0007c503          	lbu	a0,0(a5)
    800061de:	00000097          	auipc	ra,0x0
    800061e2:	b92080e7          	jalr	-1134(ra) # 80005d70 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800061e6:	0912                	slli	s2,s2,0x4
    800061e8:	34fd                	addiw	s1,s1,-1
    800061ea:	f4ed                	bnez	s1,800061d4 <printf+0x14e>
    800061ec:	b799                	j	80006132 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800061ee:	f8843783          	ld	a5,-120(s0)
    800061f2:	00878713          	addi	a4,a5,8
    800061f6:	f8e43423          	sd	a4,-120(s0)
    800061fa:	6384                	ld	s1,0(a5)
    800061fc:	cc89                	beqz	s1,80006216 <printf+0x190>
      for(; *s; s++)
    800061fe:	0004c503          	lbu	a0,0(s1)
    80006202:	d905                	beqz	a0,80006132 <printf+0xac>
        consputc(*s);
    80006204:	00000097          	auipc	ra,0x0
    80006208:	b6c080e7          	jalr	-1172(ra) # 80005d70 <consputc>
      for(; *s; s++)
    8000620c:	0485                	addi	s1,s1,1
    8000620e:	0004c503          	lbu	a0,0(s1)
    80006212:	f96d                	bnez	a0,80006204 <printf+0x17e>
    80006214:	bf39                	j	80006132 <printf+0xac>
        s = "(null)";
    80006216:	00002497          	auipc	s1,0x2
    8000621a:	56a48493          	addi	s1,s1,1386 # 80008780 <etext+0x780>
      for(; *s; s++)
    8000621e:	02800513          	li	a0,40
    80006222:	b7cd                	j	80006204 <printf+0x17e>
      consputc('%');
    80006224:	855a                	mv	a0,s6
    80006226:	00000097          	auipc	ra,0x0
    8000622a:	b4a080e7          	jalr	-1206(ra) # 80005d70 <consputc>
      break;
    8000622e:	b711                	j	80006132 <printf+0xac>
      consputc('%');
    80006230:	855a                	mv	a0,s6
    80006232:	00000097          	auipc	ra,0x0
    80006236:	b3e080e7          	jalr	-1218(ra) # 80005d70 <consputc>
      consputc(c);
    8000623a:	8526                	mv	a0,s1
    8000623c:	00000097          	auipc	ra,0x0
    80006240:	b34080e7          	jalr	-1228(ra) # 80005d70 <consputc>
      break;
    80006244:	b5fd                	j	80006132 <printf+0xac>
    80006246:	74a6                	ld	s1,104(sp)
    80006248:	7906                	ld	s2,96(sp)
    8000624a:	69e6                	ld	s3,88(sp)
    8000624c:	6aa6                	ld	s5,72(sp)
    8000624e:	6b06                	ld	s6,64(sp)
    80006250:	7be2                	ld	s7,56(sp)
    80006252:	7c42                	ld	s8,48(sp)
    80006254:	7ca2                	ld	s9,40(sp)
    80006256:	6de2                	ld	s11,24(sp)
  if(locking)
    80006258:	020d1263          	bnez	s10,8000627c <printf+0x1f6>
}
    8000625c:	70e6                	ld	ra,120(sp)
    8000625e:	7446                	ld	s0,112(sp)
    80006260:	6a46                	ld	s4,80(sp)
    80006262:	7d02                	ld	s10,32(sp)
    80006264:	6129                	addi	sp,sp,192
    80006266:	8082                	ret
    80006268:	74a6                	ld	s1,104(sp)
    8000626a:	7906                	ld	s2,96(sp)
    8000626c:	69e6                	ld	s3,88(sp)
    8000626e:	6aa6                	ld	s5,72(sp)
    80006270:	6b06                	ld	s6,64(sp)
    80006272:	7be2                	ld	s7,56(sp)
    80006274:	7c42                	ld	s8,48(sp)
    80006276:	7ca2                	ld	s9,40(sp)
    80006278:	6de2                	ld	s11,24(sp)
    8000627a:	bff9                	j	80006258 <printf+0x1d2>
    release(&pr.lock);
    8000627c:	00020517          	auipc	a0,0x20
    80006280:	f6c50513          	addi	a0,a0,-148 # 800261e8 <pr>
    80006284:	00000097          	auipc	ra,0x0
    80006288:	3e6080e7          	jalr	998(ra) # 8000666a <release>
}
    8000628c:	bfc1                	j	8000625c <printf+0x1d6>

000000008000628e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000628e:	1101                	addi	sp,sp,-32
    80006290:	ec06                	sd	ra,24(sp)
    80006292:	e822                	sd	s0,16(sp)
    80006294:	e426                	sd	s1,8(sp)
    80006296:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006298:	00020497          	auipc	s1,0x20
    8000629c:	f5048493          	addi	s1,s1,-176 # 800261e8 <pr>
    800062a0:	00002597          	auipc	a1,0x2
    800062a4:	4f858593          	addi	a1,a1,1272 # 80008798 <etext+0x798>
    800062a8:	8526                	mv	a0,s1
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	27c080e7          	jalr	636(ra) # 80006526 <initlock>
  pr.locking = 1;
    800062b2:	4785                	li	a5,1
    800062b4:	cc9c                	sw	a5,24(s1)
}
    800062b6:	60e2                	ld	ra,24(sp)
    800062b8:	6442                	ld	s0,16(sp)
    800062ba:	64a2                	ld	s1,8(sp)
    800062bc:	6105                	addi	sp,sp,32
    800062be:	8082                	ret

00000000800062c0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800062c0:	1141                	addi	sp,sp,-16
    800062c2:	e406                	sd	ra,8(sp)
    800062c4:	e022                	sd	s0,0(sp)
    800062c6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800062c8:	100007b7          	lui	a5,0x10000
    800062cc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800062d0:	10000737          	lui	a4,0x10000
    800062d4:	f8000693          	li	a3,-128
    800062d8:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800062dc:	468d                	li	a3,3
    800062de:	10000637          	lui	a2,0x10000
    800062e2:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800062e6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800062ea:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800062ee:	10000737          	lui	a4,0x10000
    800062f2:	461d                	li	a2,7
    800062f4:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800062f8:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800062fc:	00002597          	auipc	a1,0x2
    80006300:	4a458593          	addi	a1,a1,1188 # 800087a0 <etext+0x7a0>
    80006304:	00020517          	auipc	a0,0x20
    80006308:	f0450513          	addi	a0,a0,-252 # 80026208 <uart_tx_lock>
    8000630c:	00000097          	auipc	ra,0x0
    80006310:	21a080e7          	jalr	538(ra) # 80006526 <initlock>
}
    80006314:	60a2                	ld	ra,8(sp)
    80006316:	6402                	ld	s0,0(sp)
    80006318:	0141                	addi	sp,sp,16
    8000631a:	8082                	ret

000000008000631c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000631c:	1101                	addi	sp,sp,-32
    8000631e:	ec06                	sd	ra,24(sp)
    80006320:	e822                	sd	s0,16(sp)
    80006322:	e426                	sd	s1,8(sp)
    80006324:	1000                	addi	s0,sp,32
    80006326:	84aa                	mv	s1,a0
  push_off();
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	242080e7          	jalr	578(ra) # 8000656a <push_off>

  if(panicked){
    80006330:	00003797          	auipc	a5,0x3
    80006334:	cec7a783          	lw	a5,-788(a5) # 8000901c <panicked>
    80006338:	eb85                	bnez	a5,80006368 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000633a:	10000737          	lui	a4,0x10000
    8000633e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006340:	00074783          	lbu	a5,0(a4)
    80006344:	0207f793          	andi	a5,a5,32
    80006348:	dfe5                	beqz	a5,80006340 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000634a:	0ff4f513          	zext.b	a0,s1
    8000634e:	100007b7          	lui	a5,0x10000
    80006352:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006356:	00000097          	auipc	ra,0x0
    8000635a:	2b4080e7          	jalr	692(ra) # 8000660a <pop_off>
}
    8000635e:	60e2                	ld	ra,24(sp)
    80006360:	6442                	ld	s0,16(sp)
    80006362:	64a2                	ld	s1,8(sp)
    80006364:	6105                	addi	sp,sp,32
    80006366:	8082                	ret
    for(;;)
    80006368:	a001                	j	80006368 <uartputc_sync+0x4c>

000000008000636a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000636a:	00003797          	auipc	a5,0x3
    8000636e:	cb67b783          	ld	a5,-842(a5) # 80009020 <uart_tx_r>
    80006372:	00003717          	auipc	a4,0x3
    80006376:	cb673703          	ld	a4,-842(a4) # 80009028 <uart_tx_w>
    8000637a:	06f70f63          	beq	a4,a5,800063f8 <uartstart+0x8e>
{
    8000637e:	7139                	addi	sp,sp,-64
    80006380:	fc06                	sd	ra,56(sp)
    80006382:	f822                	sd	s0,48(sp)
    80006384:	f426                	sd	s1,40(sp)
    80006386:	f04a                	sd	s2,32(sp)
    80006388:	ec4e                	sd	s3,24(sp)
    8000638a:	e852                	sd	s4,16(sp)
    8000638c:	e456                	sd	s5,8(sp)
    8000638e:	e05a                	sd	s6,0(sp)
    80006390:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006392:	10000937          	lui	s2,0x10000
    80006396:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006398:	00020a97          	auipc	s5,0x20
    8000639c:	e70a8a93          	addi	s5,s5,-400 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800063a0:	00003497          	auipc	s1,0x3
    800063a4:	c8048493          	addi	s1,s1,-896 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800063a8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800063ac:	00003997          	auipc	s3,0x3
    800063b0:	c7c98993          	addi	s3,s3,-900 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063b4:	00094703          	lbu	a4,0(s2)
    800063b8:	02077713          	andi	a4,a4,32
    800063bc:	c705                	beqz	a4,800063e4 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063be:	01f7f713          	andi	a4,a5,31
    800063c2:	9756                	add	a4,a4,s5
    800063c4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800063c8:	0785                	addi	a5,a5,1
    800063ca:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800063cc:	8526                	mv	a0,s1
    800063ce:	ffffb097          	auipc	ra,0xffffb
    800063d2:	5ac080e7          	jalr	1452(ra) # 8000197a <wakeup>
    WriteReg(THR, c);
    800063d6:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800063da:	609c                	ld	a5,0(s1)
    800063dc:	0009b703          	ld	a4,0(s3)
    800063e0:	fcf71ae3          	bne	a4,a5,800063b4 <uartstart+0x4a>
  }
}
    800063e4:	70e2                	ld	ra,56(sp)
    800063e6:	7442                	ld	s0,48(sp)
    800063e8:	74a2                	ld	s1,40(sp)
    800063ea:	7902                	ld	s2,32(sp)
    800063ec:	69e2                	ld	s3,24(sp)
    800063ee:	6a42                	ld	s4,16(sp)
    800063f0:	6aa2                	ld	s5,8(sp)
    800063f2:	6b02                	ld	s6,0(sp)
    800063f4:	6121                	addi	sp,sp,64
    800063f6:	8082                	ret
    800063f8:	8082                	ret

00000000800063fa <uartputc>:
{
    800063fa:	7179                	addi	sp,sp,-48
    800063fc:	f406                	sd	ra,40(sp)
    800063fe:	f022                	sd	s0,32(sp)
    80006400:	e052                	sd	s4,0(sp)
    80006402:	1800                	addi	s0,sp,48
    80006404:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006406:	00020517          	auipc	a0,0x20
    8000640a:	e0250513          	addi	a0,a0,-510 # 80026208 <uart_tx_lock>
    8000640e:	00000097          	auipc	ra,0x0
    80006412:	1a8080e7          	jalr	424(ra) # 800065b6 <acquire>
  if(panicked){
    80006416:	00003797          	auipc	a5,0x3
    8000641a:	c067a783          	lw	a5,-1018(a5) # 8000901c <panicked>
    8000641e:	c391                	beqz	a5,80006422 <uartputc+0x28>
    for(;;)
    80006420:	a001                	j	80006420 <uartputc+0x26>
    80006422:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006424:	00003717          	auipc	a4,0x3
    80006428:	c0473703          	ld	a4,-1020(a4) # 80009028 <uart_tx_w>
    8000642c:	00003797          	auipc	a5,0x3
    80006430:	bf47b783          	ld	a5,-1036(a5) # 80009020 <uart_tx_r>
    80006434:	02078793          	addi	a5,a5,32
    80006438:	02e79f63          	bne	a5,a4,80006476 <uartputc+0x7c>
    8000643c:	e84a                	sd	s2,16(sp)
    8000643e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006440:	00020997          	auipc	s3,0x20
    80006444:	dc898993          	addi	s3,s3,-568 # 80026208 <uart_tx_lock>
    80006448:	00003497          	auipc	s1,0x3
    8000644c:	bd848493          	addi	s1,s1,-1064 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006450:	00003917          	auipc	s2,0x3
    80006454:	bd890913          	addi	s2,s2,-1064 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006458:	85ce                	mv	a1,s3
    8000645a:	8526                	mv	a0,s1
    8000645c:	ffffb097          	auipc	ra,0xffffb
    80006460:	392080e7          	jalr	914(ra) # 800017ee <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006464:	00093703          	ld	a4,0(s2)
    80006468:	609c                	ld	a5,0(s1)
    8000646a:	02078793          	addi	a5,a5,32
    8000646e:	fee785e3          	beq	a5,a4,80006458 <uartputc+0x5e>
    80006472:	6942                	ld	s2,16(sp)
    80006474:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006476:	00020497          	auipc	s1,0x20
    8000647a:	d9248493          	addi	s1,s1,-622 # 80026208 <uart_tx_lock>
    8000647e:	01f77793          	andi	a5,a4,31
    80006482:	97a6                	add	a5,a5,s1
    80006484:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006488:	0705                	addi	a4,a4,1
    8000648a:	00003797          	auipc	a5,0x3
    8000648e:	b8e7bf23          	sd	a4,-1122(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006492:	00000097          	auipc	ra,0x0
    80006496:	ed8080e7          	jalr	-296(ra) # 8000636a <uartstart>
      release(&uart_tx_lock);
    8000649a:	8526                	mv	a0,s1
    8000649c:	00000097          	auipc	ra,0x0
    800064a0:	1ce080e7          	jalr	462(ra) # 8000666a <release>
    800064a4:	64e2                	ld	s1,24(sp)
}
    800064a6:	70a2                	ld	ra,40(sp)
    800064a8:	7402                	ld	s0,32(sp)
    800064aa:	6a02                	ld	s4,0(sp)
    800064ac:	6145                	addi	sp,sp,48
    800064ae:	8082                	ret

00000000800064b0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800064b0:	1141                	addi	sp,sp,-16
    800064b2:	e422                	sd	s0,8(sp)
    800064b4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800064b6:	100007b7          	lui	a5,0x10000
    800064ba:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800064bc:	0007c783          	lbu	a5,0(a5)
    800064c0:	8b85                	andi	a5,a5,1
    800064c2:	cb81                	beqz	a5,800064d2 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800064c4:	100007b7          	lui	a5,0x10000
    800064c8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800064cc:	6422                	ld	s0,8(sp)
    800064ce:	0141                	addi	sp,sp,16
    800064d0:	8082                	ret
    return -1;
    800064d2:	557d                	li	a0,-1
    800064d4:	bfe5                	j	800064cc <uartgetc+0x1c>

00000000800064d6 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800064d6:	1101                	addi	sp,sp,-32
    800064d8:	ec06                	sd	ra,24(sp)
    800064da:	e822                	sd	s0,16(sp)
    800064dc:	e426                	sd	s1,8(sp)
    800064de:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800064e0:	54fd                	li	s1,-1
    800064e2:	a029                	j	800064ec <uartintr+0x16>
      break;
    consoleintr(c);
    800064e4:	00000097          	auipc	ra,0x0
    800064e8:	8ce080e7          	jalr	-1842(ra) # 80005db2 <consoleintr>
    int c = uartgetc();
    800064ec:	00000097          	auipc	ra,0x0
    800064f0:	fc4080e7          	jalr	-60(ra) # 800064b0 <uartgetc>
    if(c == -1)
    800064f4:	fe9518e3          	bne	a0,s1,800064e4 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800064f8:	00020497          	auipc	s1,0x20
    800064fc:	d1048493          	addi	s1,s1,-752 # 80026208 <uart_tx_lock>
    80006500:	8526                	mv	a0,s1
    80006502:	00000097          	auipc	ra,0x0
    80006506:	0b4080e7          	jalr	180(ra) # 800065b6 <acquire>
  uartstart();
    8000650a:	00000097          	auipc	ra,0x0
    8000650e:	e60080e7          	jalr	-416(ra) # 8000636a <uartstart>
  release(&uart_tx_lock);
    80006512:	8526                	mv	a0,s1
    80006514:	00000097          	auipc	ra,0x0
    80006518:	156080e7          	jalr	342(ra) # 8000666a <release>
}
    8000651c:	60e2                	ld	ra,24(sp)
    8000651e:	6442                	ld	s0,16(sp)
    80006520:	64a2                	ld	s1,8(sp)
    80006522:	6105                	addi	sp,sp,32
    80006524:	8082                	ret

0000000080006526 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006526:	1141                	addi	sp,sp,-16
    80006528:	e422                	sd	s0,8(sp)
    8000652a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000652c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000652e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006532:	00053823          	sd	zero,16(a0)
}
    80006536:	6422                	ld	s0,8(sp)
    80006538:	0141                	addi	sp,sp,16
    8000653a:	8082                	ret

000000008000653c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000653c:	411c                	lw	a5,0(a0)
    8000653e:	e399                	bnez	a5,80006544 <holding+0x8>
    80006540:	4501                	li	a0,0
  return r;
}
    80006542:	8082                	ret
{
    80006544:	1101                	addi	sp,sp,-32
    80006546:	ec06                	sd	ra,24(sp)
    80006548:	e822                	sd	s0,16(sp)
    8000654a:	e426                	sd	s1,8(sp)
    8000654c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000654e:	6904                	ld	s1,16(a0)
    80006550:	ffffb097          	auipc	ra,0xffffb
    80006554:	bbc080e7          	jalr	-1092(ra) # 8000110c <mycpu>
    80006558:	40a48533          	sub	a0,s1,a0
    8000655c:	00153513          	seqz	a0,a0
}
    80006560:	60e2                	ld	ra,24(sp)
    80006562:	6442                	ld	s0,16(sp)
    80006564:	64a2                	ld	s1,8(sp)
    80006566:	6105                	addi	sp,sp,32
    80006568:	8082                	ret

000000008000656a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000656a:	1101                	addi	sp,sp,-32
    8000656c:	ec06                	sd	ra,24(sp)
    8000656e:	e822                	sd	s0,16(sp)
    80006570:	e426                	sd	s1,8(sp)
    80006572:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006574:	100024f3          	csrr	s1,sstatus
    80006578:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000657c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000657e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006582:	ffffb097          	auipc	ra,0xffffb
    80006586:	b8a080e7          	jalr	-1142(ra) # 8000110c <mycpu>
    8000658a:	5d3c                	lw	a5,120(a0)
    8000658c:	cf89                	beqz	a5,800065a6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000658e:	ffffb097          	auipc	ra,0xffffb
    80006592:	b7e080e7          	jalr	-1154(ra) # 8000110c <mycpu>
    80006596:	5d3c                	lw	a5,120(a0)
    80006598:	2785                	addiw	a5,a5,1
    8000659a:	dd3c                	sw	a5,120(a0)
}
    8000659c:	60e2                	ld	ra,24(sp)
    8000659e:	6442                	ld	s0,16(sp)
    800065a0:	64a2                	ld	s1,8(sp)
    800065a2:	6105                	addi	sp,sp,32
    800065a4:	8082                	ret
    mycpu()->intena = old;
    800065a6:	ffffb097          	auipc	ra,0xffffb
    800065aa:	b66080e7          	jalr	-1178(ra) # 8000110c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800065ae:	8085                	srli	s1,s1,0x1
    800065b0:	8885                	andi	s1,s1,1
    800065b2:	dd64                	sw	s1,124(a0)
    800065b4:	bfe9                	j	8000658e <push_off+0x24>

00000000800065b6 <acquire>:
{
    800065b6:	1101                	addi	sp,sp,-32
    800065b8:	ec06                	sd	ra,24(sp)
    800065ba:	e822                	sd	s0,16(sp)
    800065bc:	e426                	sd	s1,8(sp)
    800065be:	1000                	addi	s0,sp,32
    800065c0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800065c2:	00000097          	auipc	ra,0x0
    800065c6:	fa8080e7          	jalr	-88(ra) # 8000656a <push_off>
  if(holding(lk))
    800065ca:	8526                	mv	a0,s1
    800065cc:	00000097          	auipc	ra,0x0
    800065d0:	f70080e7          	jalr	-144(ra) # 8000653c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800065d4:	4705                	li	a4,1
  if(holding(lk))
    800065d6:	e115                	bnez	a0,800065fa <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800065d8:	87ba                	mv	a5,a4
    800065da:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800065de:	2781                	sext.w	a5,a5
    800065e0:	ffe5                	bnez	a5,800065d8 <acquire+0x22>
  __sync_synchronize();
    800065e2:	0ff0000f          	fence
  lk->cpu = mycpu();
    800065e6:	ffffb097          	auipc	ra,0xffffb
    800065ea:	b26080e7          	jalr	-1242(ra) # 8000110c <mycpu>
    800065ee:	e888                	sd	a0,16(s1)
}
    800065f0:	60e2                	ld	ra,24(sp)
    800065f2:	6442                	ld	s0,16(sp)
    800065f4:	64a2                	ld	s1,8(sp)
    800065f6:	6105                	addi	sp,sp,32
    800065f8:	8082                	ret
    panic("acquire");
    800065fa:	00002517          	auipc	a0,0x2
    800065fe:	1ae50513          	addi	a0,a0,430 # 800087a8 <etext+0x7a8>
    80006602:	00000097          	auipc	ra,0x0
    80006606:	a3a080e7          	jalr	-1478(ra) # 8000603c <panic>

000000008000660a <pop_off>:

void
pop_off(void)
{
    8000660a:	1141                	addi	sp,sp,-16
    8000660c:	e406                	sd	ra,8(sp)
    8000660e:	e022                	sd	s0,0(sp)
    80006610:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006612:	ffffb097          	auipc	ra,0xffffb
    80006616:	afa080e7          	jalr	-1286(ra) # 8000110c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000661a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000661e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006620:	e78d                	bnez	a5,8000664a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006622:	5d3c                	lw	a5,120(a0)
    80006624:	02f05b63          	blez	a5,8000665a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006628:	37fd                	addiw	a5,a5,-1
    8000662a:	0007871b          	sext.w	a4,a5
    8000662e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006630:	eb09                	bnez	a4,80006642 <pop_off+0x38>
    80006632:	5d7c                	lw	a5,124(a0)
    80006634:	c799                	beqz	a5,80006642 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006636:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000663a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000663e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006642:	60a2                	ld	ra,8(sp)
    80006644:	6402                	ld	s0,0(sp)
    80006646:	0141                	addi	sp,sp,16
    80006648:	8082                	ret
    panic("pop_off - interruptible");
    8000664a:	00002517          	auipc	a0,0x2
    8000664e:	16650513          	addi	a0,a0,358 # 800087b0 <etext+0x7b0>
    80006652:	00000097          	auipc	ra,0x0
    80006656:	9ea080e7          	jalr	-1558(ra) # 8000603c <panic>
    panic("pop_off");
    8000665a:	00002517          	auipc	a0,0x2
    8000665e:	16e50513          	addi	a0,a0,366 # 800087c8 <etext+0x7c8>
    80006662:	00000097          	auipc	ra,0x0
    80006666:	9da080e7          	jalr	-1574(ra) # 8000603c <panic>

000000008000666a <release>:
{
    8000666a:	1101                	addi	sp,sp,-32
    8000666c:	ec06                	sd	ra,24(sp)
    8000666e:	e822                	sd	s0,16(sp)
    80006670:	e426                	sd	s1,8(sp)
    80006672:	1000                	addi	s0,sp,32
    80006674:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006676:	00000097          	auipc	ra,0x0
    8000667a:	ec6080e7          	jalr	-314(ra) # 8000653c <holding>
    8000667e:	c115                	beqz	a0,800066a2 <release+0x38>
  lk->cpu = 0;
    80006680:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006684:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006688:	0f50000f          	fence	iorw,ow
    8000668c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006690:	00000097          	auipc	ra,0x0
    80006694:	f7a080e7          	jalr	-134(ra) # 8000660a <pop_off>
}
    80006698:	60e2                	ld	ra,24(sp)
    8000669a:	6442                	ld	s0,16(sp)
    8000669c:	64a2                	ld	s1,8(sp)
    8000669e:	6105                	addi	sp,sp,32
    800066a0:	8082                	ret
    panic("release");
    800066a2:	00002517          	auipc	a0,0x2
    800066a6:	12e50513          	addi	a0,a0,302 # 800087d0 <etext+0x7d0>
    800066aa:	00000097          	auipc	ra,0x0
    800066ae:	992080e7          	jalr	-1646(ra) # 8000603c <panic>
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
