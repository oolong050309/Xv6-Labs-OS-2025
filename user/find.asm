
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/fs.h"

void find(char *path, char *filename)
{
   0:	d9010113          	addi	sp,sp,-624
   4:	26113423          	sd	ra,616(sp)
   8:	26813023          	sd	s0,608(sp)
   c:	25213823          	sd	s2,592(sp)
  10:	25313423          	sd	s3,584(sp)
  14:	1c80                	addi	s0,sp,624
  16:	892a                	mv	s2,a0
  18:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0)
  1a:	4581                	li	a1,0
  1c:	00000097          	auipc	ra,0x0
  20:	4e0080e7          	jalr	1248(ra) # 4fc <open>
  24:	04054e63          	bltz	a0,80 <find+0x80>
  28:	24913c23          	sd	s1,600(sp)
  2c:	84aa                	mv	s1,a0
    {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }
    if (fstat(fd, &st) < 0)
  2e:	d9840593          	addi	a1,s0,-616
  32:	00000097          	auipc	ra,0x0
  36:	4e2080e7          	jalr	1250(ra) # 514 <fstat>
  3a:	04054e63          	bltz	a0,96 <find+0x96>
    {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }
    if (st.type != T_DIR)
  3e:	da041703          	lh	a4,-608(s0)
  42:	4785                	li	a5,1
  44:	06f70b63          	beq	a4,a5,ba <find+0xba>
    {
        fprintf(2, "find: %s is not a directory\n", path);
  48:	864a                	mv	a2,s2
  4a:	00001597          	auipc	a1,0x1
  4e:	9ce58593          	addi	a1,a1,-1586 # a18 <malloc+0x13c>
  52:	4509                	li	a0,2
  54:	00000097          	auipc	ra,0x0
  58:	7a2080e7          	jalr	1954(ra) # 7f6 <fprintf>
        close(fd);
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	486080e7          	jalr	1158(ra) # 4e4 <close>
        return;
  66:	25813483          	ld	s1,600(sp)
        {
            printf("%s\n", buf);
        }
    }
    close(fd);
}
  6a:	26813083          	ld	ra,616(sp)
  6e:	26013403          	ld	s0,608(sp)
  72:	25013903          	ld	s2,592(sp)
  76:	24813983          	ld	s3,584(sp)
  7a:	27010113          	addi	sp,sp,624
  7e:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);
  80:	864a                	mv	a2,s2
  82:	00001597          	auipc	a1,0x1
  86:	95e58593          	addi	a1,a1,-1698 # 9e0 <malloc+0x104>
  8a:	4509                	li	a0,2
  8c:	00000097          	auipc	ra,0x0
  90:	76a080e7          	jalr	1898(ra) # 7f6 <fprintf>
        return;
  94:	bfd9                	j	6a <find+0x6a>
        fprintf(2, "find: cannot stat %s\n", path);
  96:	864a                	mv	a2,s2
  98:	00001597          	auipc	a1,0x1
  9c:	96858593          	addi	a1,a1,-1688 # a00 <malloc+0x124>
  a0:	4509                	li	a0,2
  a2:	00000097          	auipc	ra,0x0
  a6:	754080e7          	jalr	1876(ra) # 7f6 <fprintf>
        close(fd);
  aa:	8526                	mv	a0,s1
  ac:	00000097          	auipc	ra,0x0
  b0:	438080e7          	jalr	1080(ra) # 4e4 <close>
        return;
  b4:	25813483          	ld	s1,600(sp)
  b8:	bf4d                	j	6a <find+0x6a>
    if (strlen(path) + 1 > sizeof buf)
  ba:	854a                	mv	a0,s2
  bc:	00000097          	auipc	ra,0x0
  c0:	1dc080e7          	jalr	476(ra) # 298 <strlen>
  c4:	2505                	addiw	a0,a0,1
  c6:	20000793          	li	a5,512
  ca:	0ea7e363          	bltu	a5,a0,1b0 <find+0x1b0>
  ce:	25413023          	sd	s4,576(sp)
  d2:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
  d6:	85ca                	mv	a1,s2
  d8:	dc040513          	addi	a0,s0,-576
  dc:	00000097          	auipc	ra,0x0
  e0:	174080e7          	jalr	372(ra) # 250 <strcpy>
    p = buf + strlen(buf);
  e4:	dc040513          	addi	a0,s0,-576
  e8:	00000097          	auipc	ra,0x0
  ec:	1b0080e7          	jalr	432(ra) # 298 <strlen>
  f0:	1502                	slli	a0,a0,0x20
  f2:	9101                	srli	a0,a0,0x20
  f4:	dc040793          	addi	a5,s0,-576
  f8:	00a78933          	add	s2,a5,a0
    *p++ = '/';
  fc:	00190a93          	addi	s5,s2,1
 100:	02f00793          	li	a5,47
 104:	00f90023          	sb	a5,0(s2)
        if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 108:	00001a17          	auipc	s4,0x1
 10c:	948a0a13          	addi	s4,s4,-1720 # a50 <malloc+0x174>
    while (read(fd, &de, sizeof(de)) == sizeof(de))
 110:	4641                	li	a2,16
 112:	db040593          	addi	a1,s0,-592
 116:	8526                	mv	a0,s1
 118:	00000097          	auipc	ra,0x0
 11c:	3bc080e7          	jalr	956(ra) # 4d4 <read>
 120:	47c1                	li	a5,16
 122:	0cf51a63          	bne	a0,a5,1f6 <find+0x1f6>
        if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 126:	db045783          	lhu	a5,-592(s0)
 12a:	d3fd                	beqz	a5,110 <find+0x110>
 12c:	85d2                	mv	a1,s4
 12e:	db240513          	addi	a0,s0,-590
 132:	00000097          	auipc	ra,0x0
 136:	13a080e7          	jalr	314(ra) # 26c <strcmp>
 13a:	d979                	beqz	a0,110 <find+0x110>
 13c:	00001597          	auipc	a1,0x1
 140:	91c58593          	addi	a1,a1,-1764 # a58 <malloc+0x17c>
 144:	db240513          	addi	a0,s0,-590
 148:	00000097          	auipc	ra,0x0
 14c:	124080e7          	jalr	292(ra) # 26c <strcmp>
 150:	d161                	beqz	a0,110 <find+0x110>
        memmove(p, de.name, DIRSIZ);
 152:	4639                	li	a2,14
 154:	db240593          	addi	a1,s0,-590
 158:	8556                	mv	a0,s5
 15a:	00000097          	auipc	ra,0x0
 15e:	2b0080e7          	jalr	688(ra) # 40a <memmove>
        p[DIRSIZ] = 0;
 162:	000907a3          	sb	zero,15(s2)
        if (stat(buf, &st) < 0)
 166:	d9840593          	addi	a1,s0,-616
 16a:	dc040513          	addi	a0,s0,-576
 16e:	00000097          	auipc	ra,0x0
 172:	20e080e7          	jalr	526(ra) # 37c <stat>
 176:	04054d63          	bltz	a0,1d0 <find+0x1d0>
        if (st.type == T_DIR)
 17a:	da041783          	lh	a5,-608(s0)
 17e:	4705                	li	a4,1
 180:	06e78363          	beq	a5,a4,1e6 <find+0x1e6>
        else if (st.type == T_FILE && strcmp(de.name, filename) == 0)
 184:	4709                	li	a4,2
 186:	f8e795e3          	bne	a5,a4,110 <find+0x110>
 18a:	85ce                	mv	a1,s3
 18c:	db240513          	addi	a0,s0,-590
 190:	00000097          	auipc	ra,0x0
 194:	0dc080e7          	jalr	220(ra) # 26c <strcmp>
 198:	fd25                	bnez	a0,110 <find+0x110>
            printf("%s\n", buf);
 19a:	dc040593          	addi	a1,s0,-576
 19e:	00001517          	auipc	a0,0x1
 1a2:	8c250513          	addi	a0,a0,-1854 # a60 <malloc+0x184>
 1a6:	00000097          	auipc	ra,0x0
 1aa:	67e080e7          	jalr	1662(ra) # 824 <printf>
 1ae:	b78d                	j	110 <find+0x110>
        printf("find: path too long\n");
 1b0:	00001517          	auipc	a0,0x1
 1b4:	88850513          	addi	a0,a0,-1912 # a38 <malloc+0x15c>
 1b8:	00000097          	auipc	ra,0x0
 1bc:	66c080e7          	jalr	1644(ra) # 824 <printf>
        close(fd);
 1c0:	8526                	mv	a0,s1
 1c2:	00000097          	auipc	ra,0x0
 1c6:	322080e7          	jalr	802(ra) # 4e4 <close>
        return;
 1ca:	25813483          	ld	s1,600(sp)
 1ce:	bd71                	j	6a <find+0x6a>
            printf("find: cannot stat %s\n", buf);
 1d0:	dc040593          	addi	a1,s0,-576
 1d4:	00001517          	auipc	a0,0x1
 1d8:	82c50513          	addi	a0,a0,-2004 # a00 <malloc+0x124>
 1dc:	00000097          	auipc	ra,0x0
 1e0:	648080e7          	jalr	1608(ra) # 824 <printf>
            continue;
 1e4:	b735                	j	110 <find+0x110>
            find(buf, filename);
 1e6:	85ce                	mv	a1,s3
 1e8:	dc040513          	addi	a0,s0,-576
 1ec:	00000097          	auipc	ra,0x0
 1f0:	e14080e7          	jalr	-492(ra) # 0 <find>
 1f4:	bf31                	j	110 <find+0x110>
    close(fd);
 1f6:	8526                	mv	a0,s1
 1f8:	00000097          	auipc	ra,0x0
 1fc:	2ec080e7          	jalr	748(ra) # 4e4 <close>
 200:	25813483          	ld	s1,600(sp)
 204:	24013a03          	ld	s4,576(sp)
 208:	23813a83          	ld	s5,568(sp)
 20c:	bdb9                	j	6a <find+0x6a>

000000000000020e <main>:

int main(int argc, char *argv[])
{
 20e:	1141                	addi	sp,sp,-16
 210:	e406                	sd	ra,8(sp)
 212:	e022                	sd	s0,0(sp)
 214:	0800                	addi	s0,sp,16
    if (argc != 3)
 216:	470d                	li	a4,3
 218:	02e50063          	beq	a0,a4,238 <main+0x2a>
    {
        fprintf(2, "usage: find path filename...\n");
 21c:	00001597          	auipc	a1,0x1
 220:	84c58593          	addi	a1,a1,-1972 # a68 <malloc+0x18c>
 224:	4509                	li	a0,2
 226:	00000097          	auipc	ra,0x0
 22a:	5d0080e7          	jalr	1488(ra) # 7f6 <fprintf>
        exit(1);
 22e:	4505                	li	a0,1
 230:	00000097          	auipc	ra,0x0
 234:	28c080e7          	jalr	652(ra) # 4bc <exit>
 238:	87ae                	mv	a5,a1
    }
    find(argv[1], argv[2]);
 23a:	698c                	ld	a1,16(a1)
 23c:	6788                	ld	a0,8(a5)
 23e:	00000097          	auipc	ra,0x0
 242:	dc2080e7          	jalr	-574(ra) # 0 <find>
    exit(0);
 246:	4501                	li	a0,0
 248:	00000097          	auipc	ra,0x0
 24c:	274080e7          	jalr	628(ra) # 4bc <exit>

0000000000000250 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 256:	87aa                	mv	a5,a0
 258:	0585                	addi	a1,a1,1
 25a:	0785                	addi	a5,a5,1
 25c:	fff5c703          	lbu	a4,-1(a1)
 260:	fee78fa3          	sb	a4,-1(a5)
 264:	fb75                	bnez	a4,258 <strcpy+0x8>
    ;
  return os;
}
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret

000000000000026c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 272:	00054783          	lbu	a5,0(a0)
 276:	cb91                	beqz	a5,28a <strcmp+0x1e>
 278:	0005c703          	lbu	a4,0(a1)
 27c:	00f71763          	bne	a4,a5,28a <strcmp+0x1e>
    p++, q++;
 280:	0505                	addi	a0,a0,1
 282:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 284:	00054783          	lbu	a5,0(a0)
 288:	fbe5                	bnez	a5,278 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 28a:	0005c503          	lbu	a0,0(a1)
}
 28e:	40a7853b          	subw	a0,a5,a0
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <strlen>:

uint
strlen(const char *s)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	cf91                	beqz	a5,2be <strlen+0x26>
 2a4:	0505                	addi	a0,a0,1
 2a6:	87aa                	mv	a5,a0
 2a8:	86be                	mv	a3,a5
 2aa:	0785                	addi	a5,a5,1
 2ac:	fff7c703          	lbu	a4,-1(a5)
 2b0:	ff65                	bnez	a4,2a8 <strlen+0x10>
 2b2:	40a6853b          	subw	a0,a3,a0
 2b6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret
  for(n = 0; s[n]; n++)
 2be:	4501                	li	a0,0
 2c0:	bfe5                	j	2b8 <strlen+0x20>

00000000000002c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2c8:	ca19                	beqz	a2,2de <memset+0x1c>
 2ca:	87aa                	mv	a5,a0
 2cc:	1602                	slli	a2,a2,0x20
 2ce:	9201                	srli	a2,a2,0x20
 2d0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2d4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2d8:	0785                	addi	a5,a5,1
 2da:	fee79de3          	bne	a5,a4,2d4 <memset+0x12>
  }
  return dst;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <strchr>:

char*
strchr(const char *s, char c)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2ea:	00054783          	lbu	a5,0(a0)
 2ee:	cb99                	beqz	a5,304 <strchr+0x20>
    if(*s == c)
 2f0:	00f58763          	beq	a1,a5,2fe <strchr+0x1a>
  for(; *s; s++)
 2f4:	0505                	addi	a0,a0,1
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	fbfd                	bnez	a5,2f0 <strchr+0xc>
      return (char*)s;
  return 0;
 2fc:	4501                	li	a0,0
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
  return 0;
 304:	4501                	li	a0,0
 306:	bfe5                	j	2fe <strchr+0x1a>

0000000000000308 <gets>:

char*
gets(char *buf, int max)
{
 308:	711d                	addi	sp,sp,-96
 30a:	ec86                	sd	ra,88(sp)
 30c:	e8a2                	sd	s0,80(sp)
 30e:	e4a6                	sd	s1,72(sp)
 310:	e0ca                	sd	s2,64(sp)
 312:	fc4e                	sd	s3,56(sp)
 314:	f852                	sd	s4,48(sp)
 316:	f456                	sd	s5,40(sp)
 318:	f05a                	sd	s6,32(sp)
 31a:	ec5e                	sd	s7,24(sp)
 31c:	1080                	addi	s0,sp,96
 31e:	8baa                	mv	s7,a0
 320:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 322:	892a                	mv	s2,a0
 324:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 326:	4aa9                	li	s5,10
 328:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 32a:	89a6                	mv	s3,s1
 32c:	2485                	addiw	s1,s1,1
 32e:	0344d863          	bge	s1,s4,35e <gets+0x56>
    cc = read(0, &c, 1);
 332:	4605                	li	a2,1
 334:	faf40593          	addi	a1,s0,-81
 338:	4501                	li	a0,0
 33a:	00000097          	auipc	ra,0x0
 33e:	19a080e7          	jalr	410(ra) # 4d4 <read>
    if(cc < 1)
 342:	00a05e63          	blez	a0,35e <gets+0x56>
    buf[i++] = c;
 346:	faf44783          	lbu	a5,-81(s0)
 34a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 34e:	01578763          	beq	a5,s5,35c <gets+0x54>
 352:	0905                	addi	s2,s2,1
 354:	fd679be3          	bne	a5,s6,32a <gets+0x22>
    buf[i++] = c;
 358:	89a6                	mv	s3,s1
 35a:	a011                	j	35e <gets+0x56>
 35c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 35e:	99de                	add	s3,s3,s7
 360:	00098023          	sb	zero,0(s3)
  return buf;
}
 364:	855e                	mv	a0,s7
 366:	60e6                	ld	ra,88(sp)
 368:	6446                	ld	s0,80(sp)
 36a:	64a6                	ld	s1,72(sp)
 36c:	6906                	ld	s2,64(sp)
 36e:	79e2                	ld	s3,56(sp)
 370:	7a42                	ld	s4,48(sp)
 372:	7aa2                	ld	s5,40(sp)
 374:	7b02                	ld	s6,32(sp)
 376:	6be2                	ld	s7,24(sp)
 378:	6125                	addi	sp,sp,96
 37a:	8082                	ret

000000000000037c <stat>:

int
stat(const char *n, struct stat *st)
{
 37c:	1101                	addi	sp,sp,-32
 37e:	ec06                	sd	ra,24(sp)
 380:	e822                	sd	s0,16(sp)
 382:	e04a                	sd	s2,0(sp)
 384:	1000                	addi	s0,sp,32
 386:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 388:	4581                	li	a1,0
 38a:	00000097          	auipc	ra,0x0
 38e:	172080e7          	jalr	370(ra) # 4fc <open>
  if(fd < 0)
 392:	02054663          	bltz	a0,3be <stat+0x42>
 396:	e426                	sd	s1,8(sp)
 398:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 39a:	85ca                	mv	a1,s2
 39c:	00000097          	auipc	ra,0x0
 3a0:	178080e7          	jalr	376(ra) # 514 <fstat>
 3a4:	892a                	mv	s2,a0
  close(fd);
 3a6:	8526                	mv	a0,s1
 3a8:	00000097          	auipc	ra,0x0
 3ac:	13c080e7          	jalr	316(ra) # 4e4 <close>
  return r;
 3b0:	64a2                	ld	s1,8(sp)
}
 3b2:	854a                	mv	a0,s2
 3b4:	60e2                	ld	ra,24(sp)
 3b6:	6442                	ld	s0,16(sp)
 3b8:	6902                	ld	s2,0(sp)
 3ba:	6105                	addi	sp,sp,32
 3bc:	8082                	ret
    return -1;
 3be:	597d                	li	s2,-1
 3c0:	bfcd                	j	3b2 <stat+0x36>

00000000000003c2 <atoi>:

int
atoi(const char *s)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e422                	sd	s0,8(sp)
 3c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c8:	00054683          	lbu	a3,0(a0)
 3cc:	fd06879b          	addiw	a5,a3,-48
 3d0:	0ff7f793          	zext.b	a5,a5
 3d4:	4625                	li	a2,9
 3d6:	02f66863          	bltu	a2,a5,406 <atoi+0x44>
 3da:	872a                	mv	a4,a0
  n = 0;
 3dc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3de:	0705                	addi	a4,a4,1
 3e0:	0025179b          	slliw	a5,a0,0x2
 3e4:	9fa9                	addw	a5,a5,a0
 3e6:	0017979b          	slliw	a5,a5,0x1
 3ea:	9fb5                	addw	a5,a5,a3
 3ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3f0:	00074683          	lbu	a3,0(a4)
 3f4:	fd06879b          	addiw	a5,a3,-48
 3f8:	0ff7f793          	zext.b	a5,a5
 3fc:	fef671e3          	bgeu	a2,a5,3de <atoi+0x1c>
  return n;
}
 400:	6422                	ld	s0,8(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret
  n = 0;
 406:	4501                	li	a0,0
 408:	bfe5                	j	400 <atoi+0x3e>

000000000000040a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 40a:	1141                	addi	sp,sp,-16
 40c:	e422                	sd	s0,8(sp)
 40e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 410:	02b57463          	bgeu	a0,a1,438 <memmove+0x2e>
    while(n-- > 0)
 414:	00c05f63          	blez	a2,432 <memmove+0x28>
 418:	1602                	slli	a2,a2,0x20
 41a:	9201                	srli	a2,a2,0x20
 41c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 420:	872a                	mv	a4,a0
      *dst++ = *src++;
 422:	0585                	addi	a1,a1,1
 424:	0705                	addi	a4,a4,1
 426:	fff5c683          	lbu	a3,-1(a1)
 42a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 42e:	fef71ae3          	bne	a4,a5,422 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 432:	6422                	ld	s0,8(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret
    dst += n;
 438:	00c50733          	add	a4,a0,a2
    src += n;
 43c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 43e:	fec05ae3          	blez	a2,432 <memmove+0x28>
 442:	fff6079b          	addiw	a5,a2,-1
 446:	1782                	slli	a5,a5,0x20
 448:	9381                	srli	a5,a5,0x20
 44a:	fff7c793          	not	a5,a5
 44e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 450:	15fd                	addi	a1,a1,-1
 452:	177d                	addi	a4,a4,-1
 454:	0005c683          	lbu	a3,0(a1)
 458:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 45c:	fee79ae3          	bne	a5,a4,450 <memmove+0x46>
 460:	bfc9                	j	432 <memmove+0x28>

0000000000000462 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 462:	1141                	addi	sp,sp,-16
 464:	e422                	sd	s0,8(sp)
 466:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 468:	ca05                	beqz	a2,498 <memcmp+0x36>
 46a:	fff6069b          	addiw	a3,a2,-1
 46e:	1682                	slli	a3,a3,0x20
 470:	9281                	srli	a3,a3,0x20
 472:	0685                	addi	a3,a3,1
 474:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 476:	00054783          	lbu	a5,0(a0)
 47a:	0005c703          	lbu	a4,0(a1)
 47e:	00e79863          	bne	a5,a4,48e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 482:	0505                	addi	a0,a0,1
    p2++;
 484:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 486:	fed518e3          	bne	a0,a3,476 <memcmp+0x14>
  }
  return 0;
 48a:	4501                	li	a0,0
 48c:	a019                	j	492 <memcmp+0x30>
      return *p1 - *p2;
 48e:	40e7853b          	subw	a0,a5,a4
}
 492:	6422                	ld	s0,8(sp)
 494:	0141                	addi	sp,sp,16
 496:	8082                	ret
  return 0;
 498:	4501                	li	a0,0
 49a:	bfe5                	j	492 <memcmp+0x30>

000000000000049c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e406                	sd	ra,8(sp)
 4a0:	e022                	sd	s0,0(sp)
 4a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a4:	00000097          	auipc	ra,0x0
 4a8:	f66080e7          	jalr	-154(ra) # 40a <memmove>
}
 4ac:	60a2                	ld	ra,8(sp)
 4ae:	6402                	ld	s0,0(sp)
 4b0:	0141                	addi	sp,sp,16
 4b2:	8082                	ret

00000000000004b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b4:	4885                	li	a7,1
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 4bc:	4889                	li	a7,2
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c4:	488d                	li	a7,3
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4cc:	4891                	li	a7,4
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <read>:
.global read
read:
 li a7, SYS_read
 4d4:	4895                	li	a7,5
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <write>:
.global write
write:
 li a7, SYS_write
 4dc:	48c1                	li	a7,16
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <close>:
.global close
close:
 li a7, SYS_close
 4e4:	48d5                	li	a7,21
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ec:	4899                	li	a7,6
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f4:	489d                	li	a7,7
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <open>:
.global open
open:
 li a7, SYS_open
 4fc:	48bd                	li	a7,15
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 504:	48c5                	li	a7,17
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 50c:	48c9                	li	a7,18
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 514:	48a1                	li	a7,8
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <link>:
.global link
link:
 li a7, SYS_link
 51c:	48cd                	li	a7,19
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 524:	48d1                	li	a7,20
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 52c:	48a5                	li	a7,9
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <dup>:
.global dup
dup:
 li a7, SYS_dup
 534:	48a9                	li	a7,10
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53c:	48ad                	li	a7,11
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 544:	48b1                	li	a7,12
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 54c:	48b5                	li	a7,13
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 554:	48b9                	li	a7,14
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 55c:	1101                	addi	sp,sp,-32
 55e:	ec06                	sd	ra,24(sp)
 560:	e822                	sd	s0,16(sp)
 562:	1000                	addi	s0,sp,32
 564:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 568:	4605                	li	a2,1
 56a:	fef40593          	addi	a1,s0,-17
 56e:	00000097          	auipc	ra,0x0
 572:	f6e080e7          	jalr	-146(ra) # 4dc <write>
}
 576:	60e2                	ld	ra,24(sp)
 578:	6442                	ld	s0,16(sp)
 57a:	6105                	addi	sp,sp,32
 57c:	8082                	ret

000000000000057e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57e:	7139                	addi	sp,sp,-64
 580:	fc06                	sd	ra,56(sp)
 582:	f822                	sd	s0,48(sp)
 584:	f426                	sd	s1,40(sp)
 586:	0080                	addi	s0,sp,64
 588:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58a:	c299                	beqz	a3,590 <printint+0x12>
 58c:	0805cb63          	bltz	a1,622 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 590:	2581                	sext.w	a1,a1
  neg = 0;
 592:	4881                	li	a7,0
 594:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 598:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 59a:	2601                	sext.w	a2,a2
 59c:	00000517          	auipc	a0,0x0
 5a0:	54c50513          	addi	a0,a0,1356 # ae8 <digits>
 5a4:	883a                	mv	a6,a4
 5a6:	2705                	addiw	a4,a4,1
 5a8:	02c5f7bb          	remuw	a5,a1,a2
 5ac:	1782                	slli	a5,a5,0x20
 5ae:	9381                	srli	a5,a5,0x20
 5b0:	97aa                	add	a5,a5,a0
 5b2:	0007c783          	lbu	a5,0(a5)
 5b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ba:	0005879b          	sext.w	a5,a1
 5be:	02c5d5bb          	divuw	a1,a1,a2
 5c2:	0685                	addi	a3,a3,1
 5c4:	fec7f0e3          	bgeu	a5,a2,5a4 <printint+0x26>
  if(neg)
 5c8:	00088c63          	beqz	a7,5e0 <printint+0x62>
    buf[i++] = '-';
 5cc:	fd070793          	addi	a5,a4,-48
 5d0:	00878733          	add	a4,a5,s0
 5d4:	02d00793          	li	a5,45
 5d8:	fef70823          	sb	a5,-16(a4)
 5dc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e0:	02e05c63          	blez	a4,618 <printint+0x9a>
 5e4:	f04a                	sd	s2,32(sp)
 5e6:	ec4e                	sd	s3,24(sp)
 5e8:	fc040793          	addi	a5,s0,-64
 5ec:	00e78933          	add	s2,a5,a4
 5f0:	fff78993          	addi	s3,a5,-1
 5f4:	99ba                	add	s3,s3,a4
 5f6:	377d                	addiw	a4,a4,-1
 5f8:	1702                	slli	a4,a4,0x20
 5fa:	9301                	srli	a4,a4,0x20
 5fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 600:	fff94583          	lbu	a1,-1(s2)
 604:	8526                	mv	a0,s1
 606:	00000097          	auipc	ra,0x0
 60a:	f56080e7          	jalr	-170(ra) # 55c <putc>
  while(--i >= 0)
 60e:	197d                	addi	s2,s2,-1
 610:	ff3918e3          	bne	s2,s3,600 <printint+0x82>
 614:	7902                	ld	s2,32(sp)
 616:	69e2                	ld	s3,24(sp)
}
 618:	70e2                	ld	ra,56(sp)
 61a:	7442                	ld	s0,48(sp)
 61c:	74a2                	ld	s1,40(sp)
 61e:	6121                	addi	sp,sp,64
 620:	8082                	ret
    x = -xx;
 622:	40b005bb          	negw	a1,a1
    neg = 1;
 626:	4885                	li	a7,1
    x = -xx;
 628:	b7b5                	j	594 <printint+0x16>

000000000000062a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 62a:	715d                	addi	sp,sp,-80
 62c:	e486                	sd	ra,72(sp)
 62e:	e0a2                	sd	s0,64(sp)
 630:	f84a                	sd	s2,48(sp)
 632:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 634:	0005c903          	lbu	s2,0(a1)
 638:	1a090a63          	beqz	s2,7ec <vprintf+0x1c2>
 63c:	fc26                	sd	s1,56(sp)
 63e:	f44e                	sd	s3,40(sp)
 640:	f052                	sd	s4,32(sp)
 642:	ec56                	sd	s5,24(sp)
 644:	e85a                	sd	s6,16(sp)
 646:	e45e                	sd	s7,8(sp)
 648:	8aaa                	mv	s5,a0
 64a:	8bb2                	mv	s7,a2
 64c:	00158493          	addi	s1,a1,1
  state = 0;
 650:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 652:	02500a13          	li	s4,37
 656:	4b55                	li	s6,21
 658:	a839                	j	676 <vprintf+0x4c>
        putc(fd, c);
 65a:	85ca                	mv	a1,s2
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	efe080e7          	jalr	-258(ra) # 55c <putc>
 666:	a019                	j	66c <vprintf+0x42>
    } else if(state == '%'){
 668:	01498d63          	beq	s3,s4,682 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 66c:	0485                	addi	s1,s1,1
 66e:	fff4c903          	lbu	s2,-1(s1)
 672:	16090763          	beqz	s2,7e0 <vprintf+0x1b6>
    if(state == 0){
 676:	fe0999e3          	bnez	s3,668 <vprintf+0x3e>
      if(c == '%'){
 67a:	ff4910e3          	bne	s2,s4,65a <vprintf+0x30>
        state = '%';
 67e:	89d2                	mv	s3,s4
 680:	b7f5                	j	66c <vprintf+0x42>
      if(c == 'd'){
 682:	13490463          	beq	s2,s4,7aa <vprintf+0x180>
 686:	f9d9079b          	addiw	a5,s2,-99
 68a:	0ff7f793          	zext.b	a5,a5
 68e:	12fb6763          	bltu	s6,a5,7bc <vprintf+0x192>
 692:	f9d9079b          	addiw	a5,s2,-99
 696:	0ff7f713          	zext.b	a4,a5
 69a:	12eb6163          	bltu	s6,a4,7bc <vprintf+0x192>
 69e:	00271793          	slli	a5,a4,0x2
 6a2:	00000717          	auipc	a4,0x0
 6a6:	3ee70713          	addi	a4,a4,1006 # a90 <malloc+0x1b4>
 6aa:	97ba                	add	a5,a5,a4
 6ac:	439c                	lw	a5,0(a5)
 6ae:	97ba                	add	a5,a5,a4
 6b0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6b2:	008b8913          	addi	s2,s7,8
 6b6:	4685                	li	a3,1
 6b8:	4629                	li	a2,10
 6ba:	000ba583          	lw	a1,0(s7)
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	ebe080e7          	jalr	-322(ra) # 57e <printint>
 6c8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b745                	j	66c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4629                	li	a2,10
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	ea2080e7          	jalr	-350(ra) # 57e <printint>
 6e4:	8bca                	mv	s7,s2
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b751                	j	66c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	e86080e7          	jalr	-378(ra) # 57e <printint>
 700:	8bca                	mv	s7,s2
      state = 0;
 702:	4981                	li	s3,0
 704:	b7a5                	j	66c <vprintf+0x42>
 706:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 708:	008b8c13          	addi	s8,s7,8
 70c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 710:	03000593          	li	a1,48
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	e46080e7          	jalr	-442(ra) # 55c <putc>
  putc(fd, 'x');
 71e:	07800593          	li	a1,120
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	e38080e7          	jalr	-456(ra) # 55c <putc>
 72c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72e:	00000b97          	auipc	s7,0x0
 732:	3bab8b93          	addi	s7,s7,954 # ae8 <digits>
 736:	03c9d793          	srli	a5,s3,0x3c
 73a:	97de                	add	a5,a5,s7
 73c:	0007c583          	lbu	a1,0(a5)
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	e1a080e7          	jalr	-486(ra) # 55c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74a:	0992                	slli	s3,s3,0x4
 74c:	397d                	addiw	s2,s2,-1
 74e:	fe0914e3          	bnez	s2,736 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 752:	8be2                	mv	s7,s8
      state = 0;
 754:	4981                	li	s3,0
 756:	6c02                	ld	s8,0(sp)
 758:	bf11                	j	66c <vprintf+0x42>
        s = va_arg(ap, char*);
 75a:	008b8993          	addi	s3,s7,8
 75e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 762:	02090163          	beqz	s2,784 <vprintf+0x15a>
        while(*s != 0){
 766:	00094583          	lbu	a1,0(s2)
 76a:	c9a5                	beqz	a1,7da <vprintf+0x1b0>
          putc(fd, *s);
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	dee080e7          	jalr	-530(ra) # 55c <putc>
          s++;
 776:	0905                	addi	s2,s2,1
        while(*s != 0){
 778:	00094583          	lbu	a1,0(s2)
 77c:	f9e5                	bnez	a1,76c <vprintf+0x142>
        s = va_arg(ap, char*);
 77e:	8bce                	mv	s7,s3
      state = 0;
 780:	4981                	li	s3,0
 782:	b5ed                	j	66c <vprintf+0x42>
          s = "(null)";
 784:	00000917          	auipc	s2,0x0
 788:	30490913          	addi	s2,s2,772 # a88 <malloc+0x1ac>
        while(*s != 0){
 78c:	02800593          	li	a1,40
 790:	bff1                	j	76c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 792:	008b8913          	addi	s2,s7,8
 796:	000bc583          	lbu	a1,0(s7)
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	dc0080e7          	jalr	-576(ra) # 55c <putc>
 7a4:	8bca                	mv	s7,s2
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	b5d1                	j	66c <vprintf+0x42>
        putc(fd, c);
 7aa:	02500593          	li	a1,37
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	dac080e7          	jalr	-596(ra) # 55c <putc>
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	bd4d                	j	66c <vprintf+0x42>
        putc(fd, '%');
 7bc:	02500593          	li	a1,37
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	d9a080e7          	jalr	-614(ra) # 55c <putc>
        putc(fd, c);
 7ca:	85ca                	mv	a1,s2
 7cc:	8556                	mv	a0,s5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	d8e080e7          	jalr	-626(ra) # 55c <putc>
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	bd51                	j	66c <vprintf+0x42>
        s = va_arg(ap, char*);
 7da:	8bce                	mv	s7,s3
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b579                	j	66c <vprintf+0x42>
 7e0:	74e2                	ld	s1,56(sp)
 7e2:	79a2                	ld	s3,40(sp)
 7e4:	7a02                	ld	s4,32(sp)
 7e6:	6ae2                	ld	s5,24(sp)
 7e8:	6b42                	ld	s6,16(sp)
 7ea:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7ec:	60a6                	ld	ra,72(sp)
 7ee:	6406                	ld	s0,64(sp)
 7f0:	7942                	ld	s2,48(sp)
 7f2:	6161                	addi	sp,sp,80
 7f4:	8082                	ret

00000000000007f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f6:	715d                	addi	sp,sp,-80
 7f8:	ec06                	sd	ra,24(sp)
 7fa:	e822                	sd	s0,16(sp)
 7fc:	1000                	addi	s0,sp,32
 7fe:	e010                	sd	a2,0(s0)
 800:	e414                	sd	a3,8(s0)
 802:	e818                	sd	a4,16(s0)
 804:	ec1c                	sd	a5,24(s0)
 806:	03043023          	sd	a6,32(s0)
 80a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 80e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 812:	8622                	mv	a2,s0
 814:	00000097          	auipc	ra,0x0
 818:	e16080e7          	jalr	-490(ra) # 62a <vprintf>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6161                	addi	sp,sp,80
 822:	8082                	ret

0000000000000824 <printf>:

void
printf(const char *fmt, ...)
{
 824:	711d                	addi	sp,sp,-96
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e40c                	sd	a1,8(s0)
 82e:	e810                	sd	a2,16(s0)
 830:	ec14                	sd	a3,24(s0)
 832:	f018                	sd	a4,32(s0)
 834:	f41c                	sd	a5,40(s0)
 836:	03043823          	sd	a6,48(s0)
 83a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 83e:	00840613          	addi	a2,s0,8
 842:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 846:	85aa                	mv	a1,a0
 848:	4505                	li	a0,1
 84a:	00000097          	auipc	ra,0x0
 84e:	de0080e7          	jalr	-544(ra) # 62a <vprintf>
}
 852:	60e2                	ld	ra,24(sp)
 854:	6442                	ld	s0,16(sp)
 856:	6125                	addi	sp,sp,96
 858:	8082                	ret

000000000000085a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 85a:	1141                	addi	sp,sp,-16
 85c:	e422                	sd	s0,8(sp)
 85e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 860:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 864:	00000797          	auipc	a5,0x0
 868:	29c7b783          	ld	a5,668(a5) # b00 <freep>
 86c:	a02d                	j	896 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 86e:	4618                	lw	a4,8(a2)
 870:	9f2d                	addw	a4,a4,a1
 872:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	6310                	ld	a2,0(a4)
 87a:	a83d                	j	8b8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 87c:	ff852703          	lw	a4,-8(a0)
 880:	9f31                	addw	a4,a4,a2
 882:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 884:	ff053683          	ld	a3,-16(a0)
 888:	a091                	j	8cc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88a:	6398                	ld	a4,0(a5)
 88c:	00e7e463          	bltu	a5,a4,894 <free+0x3a>
 890:	00e6ea63          	bltu	a3,a4,8a4 <free+0x4a>
{
 894:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 896:	fed7fae3          	bgeu	a5,a3,88a <free+0x30>
 89a:	6398                	ld	a4,0(a5)
 89c:	00e6e463          	bltu	a3,a4,8a4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	fee7eae3          	bltu	a5,a4,894 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8a4:	ff852583          	lw	a1,-8(a0)
 8a8:	6390                	ld	a2,0(a5)
 8aa:	02059813          	slli	a6,a1,0x20
 8ae:	01c85713          	srli	a4,a6,0x1c
 8b2:	9736                	add	a4,a4,a3
 8b4:	fae60de3          	beq	a2,a4,86e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8bc:	4790                	lw	a2,8(a5)
 8be:	02061593          	slli	a1,a2,0x20
 8c2:	01c5d713          	srli	a4,a1,0x1c
 8c6:	973e                	add	a4,a4,a5
 8c8:	fae68ae3          	beq	a3,a4,87c <free+0x22>
    p->s.ptr = bp->s.ptr;
 8cc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ce:	00000717          	auipc	a4,0x0
 8d2:	22f73923          	sd	a5,562(a4) # b00 <freep>
}
 8d6:	6422                	ld	s0,8(sp)
 8d8:	0141                	addi	sp,sp,16
 8da:	8082                	ret

00000000000008dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8dc:	7139                	addi	sp,sp,-64
 8de:	fc06                	sd	ra,56(sp)
 8e0:	f822                	sd	s0,48(sp)
 8e2:	f426                	sd	s1,40(sp)
 8e4:	ec4e                	sd	s3,24(sp)
 8e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e8:	02051493          	slli	s1,a0,0x20
 8ec:	9081                	srli	s1,s1,0x20
 8ee:	04bd                	addi	s1,s1,15
 8f0:	8091                	srli	s1,s1,0x4
 8f2:	0014899b          	addiw	s3,s1,1
 8f6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8f8:	00000517          	auipc	a0,0x0
 8fc:	20853503          	ld	a0,520(a0) # b00 <freep>
 900:	c915                	beqz	a0,934 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 902:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 904:	4798                	lw	a4,8(a5)
 906:	08977e63          	bgeu	a4,s1,9a2 <malloc+0xc6>
 90a:	f04a                	sd	s2,32(sp)
 90c:	e852                	sd	s4,16(sp)
 90e:	e456                	sd	s5,8(sp)
 910:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 912:	8a4e                	mv	s4,s3
 914:	0009871b          	sext.w	a4,s3
 918:	6685                	lui	a3,0x1
 91a:	00d77363          	bgeu	a4,a3,920 <malloc+0x44>
 91e:	6a05                	lui	s4,0x1
 920:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 924:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 928:	00000917          	auipc	s2,0x0
 92c:	1d890913          	addi	s2,s2,472 # b00 <freep>
  if(p == (char*)-1)
 930:	5afd                	li	s5,-1
 932:	a091                	j	976 <malloc+0x9a>
 934:	f04a                	sd	s2,32(sp)
 936:	e852                	sd	s4,16(sp)
 938:	e456                	sd	s5,8(sp)
 93a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 93c:	00000797          	auipc	a5,0x0
 940:	1cc78793          	addi	a5,a5,460 # b08 <base>
 944:	00000717          	auipc	a4,0x0
 948:	1af73e23          	sd	a5,444(a4) # b00 <freep>
 94c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 952:	b7c1                	j	912 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 954:	6398                	ld	a4,0(a5)
 956:	e118                	sd	a4,0(a0)
 958:	a08d                	j	9ba <malloc+0xde>
  hp->s.size = nu;
 95a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 95e:	0541                	addi	a0,a0,16
 960:	00000097          	auipc	ra,0x0
 964:	efa080e7          	jalr	-262(ra) # 85a <free>
  return freep;
 968:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 96c:	c13d                	beqz	a0,9d2 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 970:	4798                	lw	a4,8(a5)
 972:	02977463          	bgeu	a4,s1,99a <malloc+0xbe>
    if(p == freep)
 976:	00093703          	ld	a4,0(s2)
 97a:	853e                	mv	a0,a5
 97c:	fef719e3          	bne	a4,a5,96e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 980:	8552                	mv	a0,s4
 982:	00000097          	auipc	ra,0x0
 986:	bc2080e7          	jalr	-1086(ra) # 544 <sbrk>
  if(p == (char*)-1)
 98a:	fd5518e3          	bne	a0,s5,95a <malloc+0x7e>
        return 0;
 98e:	4501                	li	a0,0
 990:	7902                	ld	s2,32(sp)
 992:	6a42                	ld	s4,16(sp)
 994:	6aa2                	ld	s5,8(sp)
 996:	6b02                	ld	s6,0(sp)
 998:	a03d                	j	9c6 <malloc+0xea>
 99a:	7902                	ld	s2,32(sp)
 99c:	6a42                	ld	s4,16(sp)
 99e:	6aa2                	ld	s5,8(sp)
 9a0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9a2:	fae489e3          	beq	s1,a4,954 <malloc+0x78>
        p->s.size -= nunits;
 9a6:	4137073b          	subw	a4,a4,s3
 9aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ac:	02071693          	slli	a3,a4,0x20
 9b0:	01c6d713          	srli	a4,a3,0x1c
 9b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ba:	00000717          	auipc	a4,0x0
 9be:	14a73323          	sd	a0,326(a4) # b00 <freep>
      return (void*)(p + 1);
 9c2:	01078513          	addi	a0,a5,16
  }
}
 9c6:	70e2                	ld	ra,56(sp)
 9c8:	7442                	ld	s0,48(sp)
 9ca:	74a2                	ld	s1,40(sp)
 9cc:	69e2                	ld	s3,24(sp)
 9ce:	6121                	addi	sp,sp,64
 9d0:	8082                	ret
 9d2:	7902                	ld	s2,32(sp)
 9d4:	6a42                	ld	s4,16(sp)
 9d6:	6aa2                	ld	s5,8(sp)
 9d8:	6b02                	ld	s6,0(sp)
 9da:	b7f5                	j	9c6 <malloc+0xea>
