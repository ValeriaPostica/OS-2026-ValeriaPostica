
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "user/user.h"
#include "kernel/fs.h"

void
find(char *path, char *target)
{
   0:	da010113          	addi	sp,sp,-608
   4:	24113c23          	sd	ra,600(sp)
   8:	24813823          	sd	s0,592(sp)
   c:	25213023          	sd	s2,576(sp)
  10:	23313c23          	sd	s3,568(sp)
  14:	1480                	addi	s0,sp,608
  16:	892a                	mv	s2,a0
  18:	89ae                	mv	s3,a1
  char *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  1a:	4581                	li	a1,0
  1c:	4aa000ef          	jal	4c6 <open>
  20:	04054063          	bltz	a0,60 <find+0x60>
  24:	24913423          	sd	s1,584(sp)
  28:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  2a:	da840593          	addi	a1,s0,-600
  2e:	4b0000ef          	jal	4de <fstat>
  32:	04054063          	bltz	a0,72 <find+0x72>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  if(st.type != T_DIR){
  36:	db041703          	lh	a4,-592(s0)
  3a:	4785                	li	a5,1
  3c:	04f70963          	beq	a4,a5,8e <find+0x8e>
    close(fd);
  40:	8526                	mv	a0,s1
  42:	46c000ef          	jal	4ae <close>
    return;
  46:	24813483          	ld	s1,584(sp)
    if(st.type == T_DIR){
      find(buf, target);
    }
  }
  close(fd);
}
  4a:	25813083          	ld	ra,600(sp)
  4e:	25013403          	ld	s0,592(sp)
  52:	24013903          	ld	s2,576(sp)
  56:	23813983          	ld	s3,568(sp)
  5a:	26010113          	addi	sp,sp,608
  5e:	8082                	ret
    fprintf(2, "find: cannot open %s\n", path);
  60:	864a                	mv	a2,s2
  62:	00001597          	auipc	a1,0x1
  66:	a2e58593          	addi	a1,a1,-1490 # a90 <malloc+0xfc>
  6a:	4509                	li	a0,2
  6c:	047000ef          	jal	8b2 <fprintf>
    return;
  70:	bfe9                	j	4a <find+0x4a>
    fprintf(2, "find: cannot stat %s\n", path);
  72:	864a                	mv	a2,s2
  74:	00001597          	auipc	a1,0x1
  78:	a3c58593          	addi	a1,a1,-1476 # ab0 <malloc+0x11c>
  7c:	4509                	li	a0,2
  7e:	035000ef          	jal	8b2 <fprintf>
    close(fd);
  82:	8526                	mv	a0,s1
  84:	42a000ef          	jal	4ae <close>
    return;
  88:	24813483          	ld	s1,584(sp)
  8c:	bf7d                	j	4a <find+0x4a>
  if(strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)){
  8e:	854a                	mv	a0,s2
  90:	1a0000ef          	jal	230 <strlen>
  94:	2541                	addiw	a0,a0,16
  96:	20000793          	li	a5,512
  9a:	0aa7ea63          	bltu	a5,a0,14e <find+0x14e>
  9e:	23413823          	sd	s4,560(sp)
  strcpy(buf, path);
  a2:	85ca                	mv	a1,s2
  a4:	dd040513          	addi	a0,s0,-560
  a8:	138000ef          	jal	1e0 <strcpy>
  p = buf+strlen(buf);
  ac:	dd040513          	addi	a0,s0,-560
  b0:	180000ef          	jal	230 <strlen>
  b4:	1502                	slli	a0,a0,0x20
  b6:	9101                	srli	a0,a0,0x20
  b8:	dd040793          	addi	a5,s0,-560
  bc:	00a78733          	add	a4,a5,a0
  c0:	893a                	mv	s2,a4
  *p++ = '/';
  c2:	00170793          	addi	a5,a4,1
  c6:	8a3e                	mv	s4,a5
  c8:	02f00793          	li	a5,47
  cc:	00f70023          	sb	a5,0(a4)
  while(read(fd, &de, sizeof(de)) == sizeof(de)){
  d0:	4641                	li	a2,16
  d2:	dc040593          	addi	a1,s0,-576
  d6:	8526                	mv	a0,s1
  d8:	3c6000ef          	jal	49e <read>
  dc:	47c1                	li	a5,16
  de:	0af51863          	bne	a0,a5,18e <find+0x18e>
    if(de.inum == 0)
  e2:	dc045783          	lhu	a5,-576(s0)
  e6:	d7ed                	beqz	a5,d0 <find+0xd0>
    if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
  e8:	00001597          	auipc	a1,0x1
  ec:	9f858593          	addi	a1,a1,-1544 # ae0 <malloc+0x14c>
  f0:	dc240513          	addi	a0,s0,-574
  f4:	10c000ef          	jal	200 <strcmp>
  f8:	dd61                	beqz	a0,d0 <find+0xd0>
  fa:	00001597          	auipc	a1,0x1
  fe:	9ee58593          	addi	a1,a1,-1554 # ae8 <malloc+0x154>
 102:	dc240513          	addi	a0,s0,-574
 106:	0fa000ef          	jal	200 <strcmp>
 10a:	d179                	beqz	a0,d0 <find+0xd0>
    memmove(p, de.name, DIRSIZ);
 10c:	4639                	li	a2,14
 10e:	dc240593          	addi	a1,s0,-574
 112:	8552                	mv	a0,s4
 114:	294000ef          	jal	3a8 <memmove>
    p[DIRSIZ] = 0;
 118:	000907a3          	sb	zero,15(s2)
    if(stat(buf, &st) < 0){
 11c:	da840593          	addi	a1,s0,-600
 120:	dd040513          	addi	a0,s0,-560
 124:	1fc000ef          	jal	320 <stat>
 128:	04054063          	bltz	a0,168 <find+0x168>
    if(strcmp(de.name, target) == 0){
 12c:	85ce                	mv	a1,s3
 12e:	dc240513          	addi	a0,s0,-574
 132:	0ce000ef          	jal	200 <strcmp>
 136:	c139                	beqz	a0,17c <find+0x17c>
    if(st.type == T_DIR){
 138:	db041703          	lh	a4,-592(s0)
 13c:	4785                	li	a5,1
 13e:	f8f719e3          	bne	a4,a5,d0 <find+0xd0>
      find(buf, target);
 142:	85ce                	mv	a1,s3
 144:	dd040513          	addi	a0,s0,-560
 148:	eb9ff0ef          	jal	0 <find>
 14c:	b751                	j	d0 <find+0xd0>
    fprintf(2, "find: path too long\n");
 14e:	00001597          	auipc	a1,0x1
 152:	97a58593          	addi	a1,a1,-1670 # ac8 <malloc+0x134>
 156:	4509                	li	a0,2
 158:	75a000ef          	jal	8b2 <fprintf>
    close(fd);
 15c:	8526                	mv	a0,s1
 15e:	350000ef          	jal	4ae <close>
    return;
 162:	24813483          	ld	s1,584(sp)
 166:	b5d5                	j	4a <find+0x4a>
      fprintf(2, "find: cannot stat %s\n", buf);
 168:	dd040613          	addi	a2,s0,-560
 16c:	00001597          	auipc	a1,0x1
 170:	94458593          	addi	a1,a1,-1724 # ab0 <malloc+0x11c>
 174:	4509                	li	a0,2
 176:	73c000ef          	jal	8b2 <fprintf>
      continue;
 17a:	bf99                	j	d0 <find+0xd0>
      printf("%s\n", buf);
 17c:	dd040593          	addi	a1,s0,-560
 180:	00001517          	auipc	a0,0x1
 184:	97050513          	addi	a0,a0,-1680 # af0 <malloc+0x15c>
 188:	754000ef          	jal	8dc <printf>
 18c:	b775                	j	138 <find+0x138>
  close(fd);
 18e:	8526                	mv	a0,s1
 190:	31e000ef          	jal	4ae <close>
 194:	24813483          	ld	s1,584(sp)
 198:	23013a03          	ld	s4,560(sp)
 19c:	b57d                	j	4a <find+0x4a>

000000000000019e <main>:

int
main(int argc, char *argv[])
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e406                	sd	ra,8(sp)
 1a2:	e022                	sd	s0,0(sp)
 1a4:	0800                	addi	s0,sp,16
  if(argc != 3){
 1a6:	470d                	li	a4,3
 1a8:	00e50c63          	beq	a0,a4,1c0 <main+0x22>
    fprintf(2, "Usage: find <directory> <name>\n");
 1ac:	00001597          	auipc	a1,0x1
 1b0:	94c58593          	addi	a1,a1,-1716 # af8 <malloc+0x164>
 1b4:	4509                	li	a0,2
 1b6:	6fc000ef          	jal	8b2 <fprintf>
    exit(1);
 1ba:	4505                	li	a0,1
 1bc:	2ca000ef          	jal	486 <exit>
 1c0:	87ae                	mv	a5,a1
  }
  find(argv[1], argv[2]);
 1c2:	698c                	ld	a1,16(a1)
 1c4:	6788                	ld	a0,8(a5)
 1c6:	e3bff0ef          	jal	0 <find>
  exit(0);
 1ca:	4501                	li	a0,0
 1cc:	2ba000ef          	jal	486 <exit>

00000000000001d0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e406                	sd	ra,8(sp)
 1d4:	e022                	sd	s0,0(sp)
 1d6:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1d8:	fc7ff0ef          	jal	19e <main>
  exit(r);
 1dc:	2aa000ef          	jal	486 <exit>

00000000000001e0 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e406                	sd	ra,8(sp)
 1e4:	e022                	sd	s0,0(sp)
 1e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 1e8:	87aa                	mv	a5,a0
 1ea:	0585                	addi	a1,a1,1
 1ec:	0785                	addi	a5,a5,1
 1ee:	fff5c703          	lbu	a4,-1(a1)
 1f2:	fee78fa3          	sb	a4,-1(a5)
 1f6:	fb75                	bnez	a4,1ea <strcpy+0xa>
    ;
  return os;
}
 1f8:	60a2                	ld	ra,8(sp)
 1fa:	6402                	ld	s0,0(sp)
 1fc:	0141                	addi	sp,sp,16
 1fe:	8082                	ret

0000000000000200 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 200:	1141                	addi	sp,sp,-16
 202:	e406                	sd	ra,8(sp)
 204:	e022                	sd	s0,0(sp)
 206:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 208:	00054783          	lbu	a5,0(a0)
 20c:	cb91                	beqz	a5,220 <strcmp+0x20>
 20e:	0005c703          	lbu	a4,0(a1)
 212:	00f71763          	bne	a4,a5,220 <strcmp+0x20>
    p++, q++;
 216:	0505                	addi	a0,a0,1
 218:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 21a:	00054783          	lbu	a5,0(a0)
 21e:	fbe5                	bnez	a5,20e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 220:	0005c503          	lbu	a0,0(a1)
}
 224:	40a7853b          	subw	a0,a5,a0
 228:	60a2                	ld	ra,8(sp)
 22a:	6402                	ld	s0,0(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret

0000000000000230 <strlen>:

uint
strlen(const char *s)
{
 230:	1141                	addi	sp,sp,-16
 232:	e406                	sd	ra,8(sp)
 234:	e022                	sd	s0,0(sp)
 236:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 238:	00054783          	lbu	a5,0(a0)
 23c:	cf91                	beqz	a5,258 <strlen+0x28>
 23e:	00150793          	addi	a5,a0,1
 242:	86be                	mv	a3,a5
 244:	0785                	addi	a5,a5,1
 246:	fff7c703          	lbu	a4,-1(a5)
 24a:	ff65                	bnez	a4,242 <strlen+0x12>
 24c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 250:	60a2                	ld	ra,8(sp)
 252:	6402                	ld	s0,0(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  for (n = 0; s[n]; n++)
 258:	4501                	li	a0,0
 25a:	bfdd                	j	250 <strlen+0x20>

000000000000025c <memset>:

void *
memset(void *dst, int c, uint n)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 264:	ca19                	beqz	a2,27a <memset+0x1e>
 266:	87aa                	mv	a5,a0
 268:	1602                	slli	a2,a2,0x20
 26a:	9201                	srli	a2,a2,0x20
 26c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 270:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 274:	0785                	addi	a5,a5,1
 276:	fee79de3          	bne	a5,a4,270 <memset+0x14>
  }
  return dst;
}
 27a:	60a2                	ld	ra,8(sp)
 27c:	6402                	ld	s0,0(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret

0000000000000282 <strchr>:

char *
strchr(const char *s, char c)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  for (; *s; s++)
 28a:	00054783          	lbu	a5,0(a0)
 28e:	cf81                	beqz	a5,2a6 <strchr+0x24>
    if (*s == c)
 290:	00f58763          	beq	a1,a5,29e <strchr+0x1c>
  for (; *s; s++)
 294:	0505                	addi	a0,a0,1
 296:	00054783          	lbu	a5,0(a0)
 29a:	fbfd                	bnez	a5,290 <strchr+0xe>
      return (char *)s;
  return 0;
 29c:	4501                	li	a0,0
}
 29e:	60a2                	ld	ra,8(sp)
 2a0:	6402                	ld	s0,0(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
  return 0;
 2a6:	4501                	li	a0,0
 2a8:	bfdd                	j	29e <strchr+0x1c>

00000000000002aa <gets>:

char *
gets(char *buf, int max)
{
 2aa:	711d                	addi	sp,sp,-96
 2ac:	ec86                	sd	ra,88(sp)
 2ae:	e8a2                	sd	s0,80(sp)
 2b0:	e4a6                	sd	s1,72(sp)
 2b2:	e0ca                	sd	s2,64(sp)
 2b4:	fc4e                	sd	s3,56(sp)
 2b6:	f852                	sd	s4,48(sp)
 2b8:	f456                	sd	s5,40(sp)
 2ba:	f05a                	sd	s6,32(sp)
 2bc:	ec5e                	sd	s7,24(sp)
 2be:	e862                	sd	s8,16(sp)
 2c0:	1080                	addi	s0,sp,96
 2c2:	8baa                	mv	s7,a0
 2c4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 2c6:	892a                	mv	s2,a0
 2c8:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2ca:	faf40b13          	addi	s6,s0,-81
 2ce:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 2d0:	8c26                	mv	s8,s1
 2d2:	0014899b          	addiw	s3,s1,1
 2d6:	84ce                	mv	s1,s3
 2d8:	0349d463          	bge	s3,s4,300 <gets+0x56>
    cc = read(0, &c, 1);
 2dc:	8656                	mv	a2,s5
 2de:	85da                	mv	a1,s6
 2e0:	4501                	li	a0,0
 2e2:	1bc000ef          	jal	49e <read>
    if (cc < 1)
 2e6:	00a05d63          	blez	a0,300 <gets+0x56>
      break;
    buf[i++] = c;
 2ea:	faf44783          	lbu	a5,-81(s0)
 2ee:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 2f2:	0905                	addi	s2,s2,1
 2f4:	ff678713          	addi	a4,a5,-10
 2f8:	c319                	beqz	a4,2fe <gets+0x54>
 2fa:	17cd                	addi	a5,a5,-13
 2fc:	fbf1                	bnez	a5,2d0 <gets+0x26>
    buf[i++] = c;
 2fe:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 300:	9c5e                	add	s8,s8,s7
 302:	000c0023          	sb	zero,0(s8)
  return buf;
}
 306:	855e                	mv	a0,s7
 308:	60e6                	ld	ra,88(sp)
 30a:	6446                	ld	s0,80(sp)
 30c:	64a6                	ld	s1,72(sp)
 30e:	6906                	ld	s2,64(sp)
 310:	79e2                	ld	s3,56(sp)
 312:	7a42                	ld	s4,48(sp)
 314:	7aa2                	ld	s5,40(sp)
 316:	7b02                	ld	s6,32(sp)
 318:	6be2                	ld	s7,24(sp)
 31a:	6c42                	ld	s8,16(sp)
 31c:	6125                	addi	sp,sp,96
 31e:	8082                	ret

0000000000000320 <stat>:

int
stat(const char *n, struct stat *st)
{
 320:	1101                	addi	sp,sp,-32
 322:	ec06                	sd	ra,24(sp)
 324:	e822                	sd	s0,16(sp)
 326:	e04a                	sd	s2,0(sp)
 328:	1000                	addi	s0,sp,32
 32a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32c:	4581                	li	a1,0
 32e:	198000ef          	jal	4c6 <open>
  if (fd < 0)
 332:	02054263          	bltz	a0,356 <stat+0x36>
 336:	e426                	sd	s1,8(sp)
 338:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 33a:	85ca                	mv	a1,s2
 33c:	1a2000ef          	jal	4de <fstat>
 340:	892a                	mv	s2,a0
  close(fd);
 342:	8526                	mv	a0,s1
 344:	16a000ef          	jal	4ae <close>
  return r;
 348:	64a2                	ld	s1,8(sp)
}
 34a:	854a                	mv	a0,s2
 34c:	60e2                	ld	ra,24(sp)
 34e:	6442                	ld	s0,16(sp)
 350:	6902                	ld	s2,0(sp)
 352:	6105                	addi	sp,sp,32
 354:	8082                	ret
    return -1;
 356:	57fd                	li	a5,-1
 358:	893e                	mv	s2,a5
 35a:	bfc5                	j	34a <stat+0x2a>

000000000000035c <atoi>:

int
atoi(const char *s)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e406                	sd	ra,8(sp)
 360:	e022                	sd	s0,0(sp)
 362:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 364:	00054683          	lbu	a3,0(a0)
 368:	fd06879b          	addiw	a5,a3,-48
 36c:	0ff7f793          	zext.b	a5,a5
 370:	4625                	li	a2,9
 372:	02f66963          	bltu	a2,a5,3a4 <atoi+0x48>
 376:	872a                	mv	a4,a0
  n = 0;
 378:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 37a:	0705                	addi	a4,a4,1
 37c:	0025179b          	slliw	a5,a0,0x2
 380:	9fa9                	addw	a5,a5,a0
 382:	0017979b          	slliw	a5,a5,0x1
 386:	9fb5                	addw	a5,a5,a3
 388:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 38c:	00074683          	lbu	a3,0(a4)
 390:	fd06879b          	addiw	a5,a3,-48
 394:	0ff7f793          	zext.b	a5,a5
 398:	fef671e3          	bgeu	a2,a5,37a <atoi+0x1e>
  return n;
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret
  n = 0;
 3a4:	4501                	li	a0,0
 3a6:	bfdd                	j	39c <atoi+0x40>

00000000000003a8 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e406                	sd	ra,8(sp)
 3ac:	e022                	sd	s0,0(sp)
 3ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3b0:	02b57563          	bgeu	a0,a1,3da <memmove+0x32>
    while (n-- > 0)
 3b4:	00c05f63          	blez	a2,3d2 <memmove+0x2a>
 3b8:	1602                	slli	a2,a2,0x20
 3ba:	9201                	srli	a2,a2,0x20
 3bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3c2:	0585                	addi	a1,a1,1
 3c4:	0705                	addi	a4,a4,1
 3c6:	fff5c683          	lbu	a3,-1(a1)
 3ca:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 3ce:	fee79ae3          	bne	a5,a4,3c2 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3d2:	60a2                	ld	ra,8(sp)
 3d4:	6402                	ld	s0,0(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret
    while (n-- > 0)
 3da:	fec05ce3          	blez	a2,3d2 <memmove+0x2a>
    dst += n;
 3de:	00c50733          	add	a4,a0,a2
    src += n;
 3e2:	95b2                	add	a1,a1,a2
 3e4:	fff6079b          	addiw	a5,a2,-1
 3e8:	1782                	slli	a5,a5,0x20
 3ea:	9381                	srli	a5,a5,0x20
 3ec:	fff7c793          	not	a5,a5
 3f0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3f2:	15fd                	addi	a1,a1,-1
 3f4:	177d                	addi	a4,a4,-1
 3f6:	0005c683          	lbu	a3,0(a1)
 3fa:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 3fe:	fef71ae3          	bne	a4,a5,3f2 <memmove+0x4a>
 402:	bfc1                	j	3d2 <memmove+0x2a>

0000000000000404 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 404:	1141                	addi	sp,sp,-16
 406:	e406                	sd	ra,8(sp)
 408:	e022                	sd	s0,0(sp)
 40a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 40c:	c61d                	beqz	a2,43a <memcmp+0x36>
 40e:	1602                	slli	a2,a2,0x20
 410:	9201                	srli	a2,a2,0x20
 412:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 416:	00054783          	lbu	a5,0(a0)
 41a:	0005c703          	lbu	a4,0(a1)
 41e:	00e79863          	bne	a5,a4,42e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 422:	0505                	addi	a0,a0,1
    p2++;
 424:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 426:	fed518e3          	bne	a0,a3,416 <memcmp+0x12>
  }
  return 0;
 42a:	4501                	li	a0,0
 42c:	a019                	j	432 <memcmp+0x2e>
      return *p1 - *p2;
 42e:	40e7853b          	subw	a0,a5,a4
}
 432:	60a2                	ld	ra,8(sp)
 434:	6402                	ld	s0,0(sp)
 436:	0141                	addi	sp,sp,16
 438:	8082                	ret
  return 0;
 43a:	4501                	li	a0,0
 43c:	bfdd                	j	432 <memcmp+0x2e>

000000000000043e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 43e:	1141                	addi	sp,sp,-16
 440:	e406                	sd	ra,8(sp)
 442:	e022                	sd	s0,0(sp)
 444:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 446:	f63ff0ef          	jal	3a8 <memmove>
}
 44a:	60a2                	ld	ra,8(sp)
 44c:	6402                	ld	s0,0(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret

0000000000000452 <sbrk>:

char *
sbrk(int n)
{
 452:	1141                	addi	sp,sp,-16
 454:	e406                	sd	ra,8(sp)
 456:	e022                	sd	s0,0(sp)
 458:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 45a:	4585                	li	a1,1
 45c:	0b2000ef          	jal	50e <sys_sbrk>
}
 460:	60a2                	ld	ra,8(sp)
 462:	6402                	ld	s0,0(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret

0000000000000468 <sbrklazy>:

char *
sbrklazy(int n)
{
 468:	1141                	addi	sp,sp,-16
 46a:	e406                	sd	ra,8(sp)
 46c:	e022                	sd	s0,0(sp)
 46e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 470:	4589                	li	a1,2
 472:	09c000ef          	jal	50e <sys_sbrk>
}
 476:	60a2                	ld	ra,8(sp)
 478:	6402                	ld	s0,0(sp)
 47a:	0141                	addi	sp,sp,16
 47c:	8082                	ret

000000000000047e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 47e:	4885                	li	a7,1
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <exit>:
.global exit
exit:
 li a7, SYS_exit
 486:	4889                	li	a7,2
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <wait>:
.global wait
wait:
 li a7, SYS_wait
 48e:	488d                	li	a7,3
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 496:	4891                	li	a7,4
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <read>:
.global read
read:
 li a7, SYS_read
 49e:	4895                	li	a7,5
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <write>:
.global write
write:
 li a7, SYS_write
 4a6:	48c1                	li	a7,16
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <close>:
.global close
close:
 li a7, SYS_close
 4ae:	48d5                	li	a7,21
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b6:	4899                	li	a7,6
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <exec>:
.global exec
exec:
 li a7, SYS_exec
 4be:	489d                	li	a7,7
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <open>:
.global open
open:
 li a7, SYS_open
 4c6:	48bd                	li	a7,15
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4ce:	48c5                	li	a7,17
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d6:	48c9                	li	a7,18
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4de:	48a1                	li	a7,8
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <link>:
.global link
link:
 li a7, SYS_link
 4e6:	48cd                	li	a7,19
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ee:	48d1                	li	a7,20
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f6:	48a5                	li	a7,9
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <dup>:
.global dup
dup:
 li a7, SYS_dup
 4fe:	48a9                	li	a7,10
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 506:	48ad                	li	a7,11
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 50e:	48b1                	li	a7,12
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <pause>:
.global pause
pause:
 li a7, SYS_pause
 516:	48b5                	li	a7,13
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 51e:	48b9                	li	a7,14
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <sync>:
.global sync
sync:
 li a7, SYS_sync
 526:	48d9                	li	a7,22
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <trace>:
.global trace
trace:
 li a7, SYS_trace
 52e:	48dd                	li	a7,23
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 536:	1101                	addi	sp,sp,-32
 538:	ec06                	sd	ra,24(sp)
 53a:	e822                	sd	s0,16(sp)
 53c:	1000                	addi	s0,sp,32
 53e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 542:	4605                	li	a2,1
 544:	fef40593          	addi	a1,s0,-17
 548:	f5fff0ef          	jal	4a6 <write>
}
 54c:	60e2                	ld	ra,24(sp)
 54e:	6442                	ld	s0,16(sp)
 550:	6105                	addi	sp,sp,32
 552:	8082                	ret

0000000000000554 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 554:	715d                	addi	sp,sp,-80
 556:	e486                	sd	ra,72(sp)
 558:	e0a2                	sd	s0,64(sp)
 55a:	f84a                	sd	s2,48(sp)
 55c:	f44e                	sd	s3,40(sp)
 55e:	0880                	addi	s0,sp,80
 560:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 562:	c6d1                	beqz	a3,5ee <printint+0x9a>
 564:	0805d563          	bgez	a1,5ee <printint+0x9a>
    neg = 1;
    x = -xx;
 568:	40b005b3          	neg	a1,a1
    neg = 1;
 56c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 56e:	fb840993          	addi	s3,s0,-72
  neg = 0;
 572:	86ce                	mv	a3,s3
  i = 0;
 574:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 576:	00000817          	auipc	a6,0x0
 57a:	5aa80813          	addi	a6,a6,1450 # b20 <digits>
 57e:	88ba                	mv	a7,a4
 580:	0017051b          	addiw	a0,a4,1
 584:	872a                	mv	a4,a0
 586:	02c5f7b3          	remu	a5,a1,a2
 58a:	97c2                	add	a5,a5,a6
 58c:	0007c783          	lbu	a5,0(a5)
 590:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 594:	87ae                	mv	a5,a1
 596:	02c5d5b3          	divu	a1,a1,a2
 59a:	0685                	addi	a3,a3,1
 59c:	fec7f1e3          	bgeu	a5,a2,57e <printint+0x2a>
  if (neg)
 5a0:	00030c63          	beqz	t1,5b8 <printint+0x64>
    buf[i++] = '-';
 5a4:	fd050793          	addi	a5,a0,-48
 5a8:	00878533          	add	a0,a5,s0
 5ac:	02d00793          	li	a5,45
 5b0:	fef50423          	sb	a5,-24(a0)
 5b4:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 5b8:	02e05563          	blez	a4,5e2 <printint+0x8e>
 5bc:	fc26                	sd	s1,56(sp)
 5be:	377d                	addiw	a4,a4,-1
 5c0:	00e984b3          	add	s1,s3,a4
 5c4:	19fd                	addi	s3,s3,-1
 5c6:	99ba                	add	s3,s3,a4
 5c8:	1702                	slli	a4,a4,0x20
 5ca:	9301                	srli	a4,a4,0x20
 5cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5d0:	0004c583          	lbu	a1,0(s1)
 5d4:	854a                	mv	a0,s2
 5d6:	f61ff0ef          	jal	536 <putc>
  while (--i >= 0)
 5da:	14fd                	addi	s1,s1,-1
 5dc:	ff349ae3          	bne	s1,s3,5d0 <printint+0x7c>
 5e0:	74e2                	ld	s1,56(sp)
}
 5e2:	60a6                	ld	ra,72(sp)
 5e4:	6406                	ld	s0,64(sp)
 5e6:	7942                	ld	s2,48(sp)
 5e8:	79a2                	ld	s3,40(sp)
 5ea:	6161                	addi	sp,sp,80
 5ec:	8082                	ret
  neg = 0;
 5ee:	4301                	li	t1,0
 5f0:	bfbd                	j	56e <printint+0x1a>

00000000000005f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5f2:	711d                	addi	sp,sp,-96
 5f4:	ec86                	sd	ra,88(sp)
 5f6:	e8a2                	sd	s0,80(sp)
 5f8:	e4a6                	sd	s1,72(sp)
 5fa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 5fc:	0005c483          	lbu	s1,0(a1)
 600:	22048363          	beqz	s1,826 <vprintf+0x234>
 604:	e0ca                	sd	s2,64(sp)
 606:	fc4e                	sd	s3,56(sp)
 608:	f852                	sd	s4,48(sp)
 60a:	f456                	sd	s5,40(sp)
 60c:	f05a                	sd	s6,32(sp)
 60e:	ec5e                	sd	s7,24(sp)
 610:	e862                	sd	s8,16(sp)
 612:	8b2a                	mv	s6,a0
 614:	8a2e                	mv	s4,a1
 616:	8bb2                	mv	s7,a2
  state = 0;
 618:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 61a:	4901                	li	s2,0
 61c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 61e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 622:	06400c13          	li	s8,100
 626:	a00d                	j	648 <vprintf+0x56>
        putc(fd, c0);
 628:	85a6                	mv	a1,s1
 62a:	855a                	mv	a0,s6
 62c:	f0bff0ef          	jal	536 <putc>
 630:	a019                	j	636 <vprintf+0x44>
    } else if (state == '%') {
 632:	03598363          	beq	s3,s5,658 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 636:	0019079b          	addiw	a5,s2,1
 63a:	893e                	mv	s2,a5
 63c:	873e                	mv	a4,a5
 63e:	97d2                	add	a5,a5,s4
 640:	0007c483          	lbu	s1,0(a5)
 644:	1c048a63          	beqz	s1,818 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 648:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 64c:	fe0993e3          	bnez	s3,632 <vprintf+0x40>
      if (c0 == '%') {
 650:	fd579ce3          	bne	a5,s5,628 <vprintf+0x36>
        state = '%';
 654:	89be                	mv	s3,a5
 656:	b7c5                	j	636 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 658:	00ea06b3          	add	a3,s4,a4
 65c:	0016c603          	lbu	a2,1(a3)
      if (c1)
 660:	1c060863          	beqz	a2,830 <vprintf+0x23e>
      if (c0 == 'd') {
 664:	03878763          	beq	a5,s8,692 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 668:	f9478693          	addi	a3,a5,-108
 66c:	0016b693          	seqz	a3,a3
 670:	f9c60593          	addi	a1,a2,-100
 674:	e99d                	bnez	a1,6aa <vprintf+0xb8>
 676:	ca95                	beqz	a3,6aa <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 678:	008b8493          	addi	s1,s7,8
 67c:	4685                	li	a3,1
 67e:	4629                	li	a2,10
 680:	000bb583          	ld	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	ecfff0ef          	jal	554 <printint>
        i += 1;
 68a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 68c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 68e:	4981                	li	s3,0
 690:	b75d                	j	636 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 692:	008b8493          	addi	s1,s7,8
 696:	4685                	li	a3,1
 698:	4629                	li	a2,10
 69a:	000ba583          	lw	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	eb5ff0ef          	jal	554 <printint>
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b779                	j	636 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 6aa:	9752                	add	a4,a4,s4
 6ac:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6b0:	f9460713          	addi	a4,a2,-108
 6b4:	00173713          	seqz	a4,a4
 6b8:	8f75                	and	a4,a4,a3
 6ba:	f9c58513          	addi	a0,a1,-100
 6be:	18051363          	bnez	a0,844 <vprintf+0x252>
 6c2:	18070163          	beqz	a4,844 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c6:	008b8493          	addi	s1,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000bb583          	ld	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e81ff0ef          	jal	554 <printint>
        i += 2;
 6d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6da:	8ba6                	mv	s7,s1
      state = 0;
 6dc:	4981                	li	s3,0
        i += 2;
 6de:	bfa1                	j	636 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6e0:	008b8493          	addi	s1,s7,8
 6e4:	4681                	li	a3,0
 6e6:	4629                	li	a2,10
 6e8:	000be583          	lwu	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	e67ff0ef          	jal	554 <printint>
 6f2:	8ba6                	mv	s7,s1
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b781                	j	636 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f8:	008b8493          	addi	s1,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4629                	li	a2,10
 700:	000bb583          	ld	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e4fff0ef          	jal	554 <printint>
        i += 1;
 70a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 70c:	8ba6                	mv	s7,s1
      state = 0;
 70e:	4981                	li	s3,0
 710:	b71d                	j	636 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 712:	008b8493          	addi	s1,s7,8
 716:	4681                	li	a3,0
 718:	4629                	li	a2,10
 71a:	000bb583          	ld	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	e35ff0ef          	jal	554 <printint>
        i += 2;
 724:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 726:	8ba6                	mv	s7,s1
      state = 0;
 728:	4981                	li	s3,0
        i += 2;
 72a:	b731                	j	636 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 72c:	008b8493          	addi	s1,s7,8
 730:	4681                	li	a3,0
 732:	4641                	li	a2,16
 734:	000be583          	lwu	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	e1bff0ef          	jal	554 <printint>
 73e:	8ba6                	mv	s7,s1
      state = 0;
 740:	4981                	li	s3,0
 742:	bdd5                	j	636 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 744:	008b8493          	addi	s1,s7,8
 748:	4681                	li	a3,0
 74a:	4641                	li	a2,16
 74c:	000bb583          	ld	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	e03ff0ef          	jal	554 <printint>
        i += 1;
 756:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 758:	8ba6                	mv	s7,s1
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bde9                	j	636 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 75e:	008b8493          	addi	s1,s7,8
 762:	4681                	li	a3,0
 764:	4641                	li	a2,16
 766:	000bb583          	ld	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	de9ff0ef          	jal	554 <printint>
        i += 2;
 770:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 772:	8ba6                	mv	s7,s1
      state = 0;
 774:	4981                	li	s3,0
        i += 2;
 776:	b5c1                	j	636 <vprintf+0x44>
 778:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 77a:	008b8793          	addi	a5,s7,8
 77e:	8cbe                	mv	s9,a5
 780:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 784:	03000593          	li	a1,48
 788:	855a                	mv	a0,s6
 78a:	dadff0ef          	jal	536 <putc>
  putc(fd, 'x');
 78e:	07800593          	li	a1,120
 792:	855a                	mv	a0,s6
 794:	da3ff0ef          	jal	536 <putc>
 798:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 79a:	00000b97          	auipc	s7,0x0
 79e:	386b8b93          	addi	s7,s7,902 # b20 <digits>
 7a2:	03c9d793          	srli	a5,s3,0x3c
 7a6:	97de                	add	a5,a5,s7
 7a8:	0007c583          	lbu	a1,0(a5)
 7ac:	855a                	mv	a0,s6
 7ae:	d89ff0ef          	jal	536 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b2:	0992                	slli	s3,s3,0x4
 7b4:	34fd                	addiw	s1,s1,-1
 7b6:	f4f5                	bnez	s1,7a2 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 7b8:	8be6                	mv	s7,s9
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	6ca2                	ld	s9,8(sp)
 7be:	bda5                	j	636 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 7c0:	008b8493          	addi	s1,s7,8
 7c4:	000bc583          	lbu	a1,0(s7)
 7c8:	855a                	mv	a0,s6
 7ca:	d6dff0ef          	jal	536 <putc>
 7ce:	8ba6                	mv	s7,s1
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b595                	j	636 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 7d4:	008b8993          	addi	s3,s7,8
 7d8:	000bb483          	ld	s1,0(s7)
 7dc:	cc91                	beqz	s1,7f8 <vprintf+0x206>
        for (; *s; s++)
 7de:	0004c583          	lbu	a1,0(s1)
 7e2:	c985                	beqz	a1,812 <vprintf+0x220>
          putc(fd, *s);
 7e4:	855a                	mv	a0,s6
 7e6:	d51ff0ef          	jal	536 <putc>
        for (; *s; s++)
 7ea:	0485                	addi	s1,s1,1
 7ec:	0004c583          	lbu	a1,0(s1)
 7f0:	f9f5                	bnez	a1,7e4 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 7f2:	8bce                	mv	s7,s3
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	b581                	j	636 <vprintf+0x44>
          s = "(null)";
 7f8:	00000497          	auipc	s1,0x0
 7fc:	32048493          	addi	s1,s1,800 # b18 <malloc+0x184>
        for (; *s; s++)
 800:	02800593          	li	a1,40
 804:	b7c5                	j	7e4 <vprintf+0x1f2>
        putc(fd, '%');
 806:	85be                	mv	a1,a5
 808:	855a                	mv	a0,s6
 80a:	d2dff0ef          	jal	536 <putc>
      state = 0;
 80e:	4981                	li	s3,0
 810:	b51d                	j	636 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 812:	8bce                	mv	s7,s3
      state = 0;
 814:	4981                	li	s3,0
 816:	b505                	j	636 <vprintf+0x44>
 818:	6906                	ld	s2,64(sp)
 81a:	79e2                	ld	s3,56(sp)
 81c:	7a42                	ld	s4,48(sp)
 81e:	7aa2                	ld	s5,40(sp)
 820:	7b02                	ld	s6,32(sp)
 822:	6be2                	ld	s7,24(sp)
 824:	6c42                	ld	s8,16(sp)
    }
  }
}
 826:	60e6                	ld	ra,88(sp)
 828:	6446                	ld	s0,80(sp)
 82a:	64a6                	ld	s1,72(sp)
 82c:	6125                	addi	sp,sp,96
 82e:	8082                	ret
      if (c0 == 'd') {
 830:	06400713          	li	a4,100
 834:	e4e78fe3          	beq	a5,a4,692 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 838:	f9478693          	addi	a3,a5,-108
 83c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 840:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 842:	4701                	li	a4,0
      } else if (c0 == 'u') {
 844:	07500513          	li	a0,117
 848:	e8a78ce3          	beq	a5,a0,6e0 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 84c:	f8b60513          	addi	a0,a2,-117
 850:	e119                	bnez	a0,856 <vprintf+0x264>
 852:	ea0693e3          	bnez	a3,6f8 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 856:	f8b58513          	addi	a0,a1,-117
 85a:	e119                	bnez	a0,860 <vprintf+0x26e>
 85c:	ea071be3          	bnez	a4,712 <vprintf+0x120>
      } else if (c0 == 'x') {
 860:	07800513          	li	a0,120
 864:	eca784e3          	beq	a5,a0,72c <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 868:	f8860613          	addi	a2,a2,-120
 86c:	e219                	bnez	a2,872 <vprintf+0x280>
 86e:	ec069be3          	bnez	a3,744 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 872:	f8858593          	addi	a1,a1,-120
 876:	e199                	bnez	a1,87c <vprintf+0x28a>
 878:	ee0713e3          	bnez	a4,75e <vprintf+0x16c>
      } else if (c0 == 'p') {
 87c:	07000713          	li	a4,112
 880:	eee78ce3          	beq	a5,a4,778 <vprintf+0x186>
      } else if (c0 == 'c') {
 884:	06300713          	li	a4,99
 888:	f2e78ce3          	beq	a5,a4,7c0 <vprintf+0x1ce>
      } else if (c0 == 's') {
 88c:	07300713          	li	a4,115
 890:	f4e782e3          	beq	a5,a4,7d4 <vprintf+0x1e2>
      } else if (c0 == '%') {
 894:	02500713          	li	a4,37
 898:	f6e787e3          	beq	a5,a4,806 <vprintf+0x214>
        putc(fd, '%');
 89c:	02500593          	li	a1,37
 8a0:	855a                	mv	a0,s6
 8a2:	c95ff0ef          	jal	536 <putc>
        putc(fd, c0);
 8a6:	85a6                	mv	a1,s1
 8a8:	855a                	mv	a0,s6
 8aa:	c8dff0ef          	jal	536 <putc>
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	b359                	j	636 <vprintf+0x44>

00000000000008b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b2:	715d                	addi	sp,sp,-80
 8b4:	ec06                	sd	ra,24(sp)
 8b6:	e822                	sd	s0,16(sp)
 8b8:	1000                	addi	s0,sp,32
 8ba:	e010                	sd	a2,0(s0)
 8bc:	e414                	sd	a3,8(s0)
 8be:	e818                	sd	a4,16(s0)
 8c0:	ec1c                	sd	a5,24(s0)
 8c2:	03043023          	sd	a6,32(s0)
 8c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ca:	8622                	mv	a2,s0
 8cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d0:	d23ff0ef          	jal	5f2 <vprintf>
}
 8d4:	60e2                	ld	ra,24(sp)
 8d6:	6442                	ld	s0,16(sp)
 8d8:	6161                	addi	sp,sp,80
 8da:	8082                	ret

00000000000008dc <printf>:

void
printf(const char *fmt, ...)
{
 8dc:	711d                	addi	sp,sp,-96
 8de:	ec06                	sd	ra,24(sp)
 8e0:	e822                	sd	s0,16(sp)
 8e2:	1000                	addi	s0,sp,32
 8e4:	e40c                	sd	a1,8(s0)
 8e6:	e810                	sd	a2,16(s0)
 8e8:	ec14                	sd	a3,24(s0)
 8ea:	f018                	sd	a4,32(s0)
 8ec:	f41c                	sd	a5,40(s0)
 8ee:	03043823          	sd	a6,48(s0)
 8f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f6:	00840613          	addi	a2,s0,8
 8fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8fe:	85aa                	mv	a1,a0
 900:	4505                	li	a0,1
 902:	cf1ff0ef          	jal	5f2 <vprintf>
}
 906:	60e2                	ld	ra,24(sp)
 908:	6442                	ld	s0,16(sp)
 90a:	6125                	addi	sp,sp,96
 90c:	8082                	ret

000000000000090e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90e:	1141                	addi	sp,sp,-16
 910:	e406                	sd	ra,8(sp)
 912:	e022                	sd	s0,0(sp)
 914:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 916:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91a:	00000797          	auipc	a5,0x0
 91e:	6e67b783          	ld	a5,1766(a5) # 1000 <freep>
 922:	a039                	j	930 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 924:	6398                	ld	a4,0(a5)
 926:	00e7e463          	bltu	a5,a4,92e <free+0x20>
 92a:	00e6ea63          	bltu	a3,a4,93e <free+0x30>
{
 92e:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 930:	fed7fae3          	bgeu	a5,a3,924 <free+0x16>
 934:	6398                	ld	a4,0(a5)
 936:	00e6e463          	bltu	a3,a4,93e <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93a:	fee7eae3          	bltu	a5,a4,92e <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 93e:	ff852583          	lw	a1,-8(a0)
 942:	6390                	ld	a2,0(a5)
 944:	02059813          	slli	a6,a1,0x20
 948:	01c85713          	srli	a4,a6,0x1c
 94c:	9736                	add	a4,a4,a3
 94e:	02e60563          	beq	a2,a4,978 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 952:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 956:	4790                	lw	a2,8(a5)
 958:	02061593          	slli	a1,a2,0x20
 95c:	01c5d713          	srli	a4,a1,0x1c
 960:	973e                	add	a4,a4,a5
 962:	02e68263          	beq	a3,a4,986 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 966:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 968:	00000717          	auipc	a4,0x0
 96c:	68f73c23          	sd	a5,1688(a4) # 1000 <freep>
}
 970:	60a2                	ld	ra,8(sp)
 972:	6402                	ld	s0,0(sp)
 974:	0141                	addi	sp,sp,16
 976:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 978:	4618                	lw	a4,8(a2)
 97a:	9f2d                	addw	a4,a4,a1
 97c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 980:	6398                	ld	a4,0(a5)
 982:	6310                	ld	a2,0(a4)
 984:	b7f9                	j	952 <free+0x44>
    p->s.size += bp->s.size;
 986:	ff852703          	lw	a4,-8(a0)
 98a:	9f31                	addw	a4,a4,a2
 98c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 98e:	ff053683          	ld	a3,-16(a0)
 992:	bfd1                	j	966 <free+0x58>

0000000000000994 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 994:	7139                	addi	sp,sp,-64
 996:	fc06                	sd	ra,56(sp)
 998:	f822                	sd	s0,48(sp)
 99a:	f04a                	sd	s2,32(sp)
 99c:	ec4e                	sd	s3,24(sp)
 99e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9a0:	02051993          	slli	s3,a0,0x20
 9a4:	0209d993          	srli	s3,s3,0x20
 9a8:	09bd                	addi	s3,s3,15
 9aa:	0049d993          	srli	s3,s3,0x4
 9ae:	2985                	addiw	s3,s3,1
 9b0:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 9b2:	00000517          	auipc	a0,0x0
 9b6:	64e53503          	ld	a0,1614(a0) # 1000 <freep>
 9ba:	c905                	beqz	a0,9ea <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9bc:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9be:	4798                	lw	a4,8(a5)
 9c0:	09377663          	bgeu	a4,s3,a4c <malloc+0xb8>
 9c4:	f426                	sd	s1,40(sp)
 9c6:	e852                	sd	s4,16(sp)
 9c8:	e456                	sd	s5,8(sp)
 9ca:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 9cc:	8a4e                	mv	s4,s3
 9ce:	6705                	lui	a4,0x1
 9d0:	00e9f363          	bgeu	s3,a4,9d6 <malloc+0x42>
 9d4:	6a05                	lui	s4,0x1
 9d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 9de:	00000497          	auipc	s1,0x0
 9e2:	62248493          	addi	s1,s1,1570 # 1000 <freep>
  if (p == SBRK_ERROR)
 9e6:	5afd                	li	s5,-1
 9e8:	a83d                	j	a26 <malloc+0x92>
 9ea:	f426                	sd	s1,40(sp)
 9ec:	e852                	sd	s4,16(sp)
 9ee:	e456                	sd	s5,8(sp)
 9f0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9f2:	00000797          	auipc	a5,0x0
 9f6:	61e78793          	addi	a5,a5,1566 # 1010 <base>
 9fa:	00000717          	auipc	a4,0x0
 9fe:	60f73323          	sd	a5,1542(a4) # 1000 <freep>
 a02:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a04:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a08:	b7d1                	j	9cc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a0a:	6398                	ld	a4,0(a5)
 a0c:	e118                	sd	a4,0(a0)
 a0e:	a899                	j	a64 <malloc+0xd0>
  hp->s.size = nu;
 a10:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a14:	0541                	addi	a0,a0,16
 a16:	ef9ff0ef          	jal	90e <free>
  return freep;
 a1a:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 a1c:	c125                	beqz	a0,a7c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a1e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a20:	4798                	lw	a4,8(a5)
 a22:	03277163          	bgeu	a4,s2,a44 <malloc+0xb0>
    if (p == freep)
 a26:	6098                	ld	a4,0(s1)
 a28:	853e                	mv	a0,a5
 a2a:	fef71ae3          	bne	a4,a5,a1e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a2e:	8552                	mv	a0,s4
 a30:	a23ff0ef          	jal	452 <sbrk>
  if (p == SBRK_ERROR)
 a34:	fd551ee3          	bne	a0,s5,a10 <malloc+0x7c>
        return 0;
 a38:	4501                	li	a0,0
 a3a:	74a2                	ld	s1,40(sp)
 a3c:	6a42                	ld	s4,16(sp)
 a3e:	6aa2                	ld	s5,8(sp)
 a40:	6b02                	ld	s6,0(sp)
 a42:	a03d                	j	a70 <malloc+0xdc>
 a44:	74a2                	ld	s1,40(sp)
 a46:	6a42                	ld	s4,16(sp)
 a48:	6aa2                	ld	s5,8(sp)
 a4a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 a4c:	fae90fe3          	beq	s2,a4,a0a <malloc+0x76>
        p->s.size -= nunits;
 a50:	4137073b          	subw	a4,a4,s3
 a54:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a56:	02071693          	slli	a3,a4,0x20
 a5a:	01c6d713          	srli	a4,a3,0x1c
 a5e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a60:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a64:	00000717          	auipc	a4,0x0
 a68:	58a73e23          	sd	a0,1436(a4) # 1000 <freep>
      return (void *)(p + 1);
 a6c:	01078513          	addi	a0,a5,16
  }
}
 a70:	70e2                	ld	ra,56(sp)
 a72:	7442                	ld	s0,48(sp)
 a74:	7902                	ld	s2,32(sp)
 a76:	69e2                	ld	s3,24(sp)
 a78:	6121                	addi	sp,sp,64
 a7a:	8082                	ret
 a7c:	74a2                	ld	s1,40(sp)
 a7e:	6a42                	ld	s4,16(sp)
 a80:	6aa2                	ld	s5,8(sp)
 a82:	6b02                	ld	s6,0(sp)
 a84:	b7f5                	j	a70 <malloc+0xdc>
