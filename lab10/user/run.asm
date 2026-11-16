
user/_run:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

// the three steps of the shell, inside xv6: echo hello from the child
int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
    printf("parent: my pid is %d\n", getpid());
   8:	3c8000ef          	jal	3d0 <getpid>
   c:	85aa                	mv	a1,a0
   e:	00001517          	auipc	a0,0x1
  12:	94250513          	addi	a0,a0,-1726 # 950 <malloc+0xf2>
  16:	790000ef          	jal	7a6 <printf>
    int pid = fork();
  1a:	32e000ef          	jal	348 <fork>

    if(pid < 0){
  1e:	04054463          	bltz	a0,66 <main+0x66>
  22:	f426                	sd	s1,40(sp)
  24:	84aa                	mv	s1,a0
        printf("fork failed\n");
        exit(1);
    }

    if(pid == 0) {
  26:	e931                	bnez	a0,7a <main+0x7a>
        // only the child runs this
        printf("child: my pid is %d\n", getpid());
  28:	3a8000ef          	jal	3d0 <getpid>
  2c:	85aa                	mv	a1,a0
  2e:	00001517          	auipc	a0,0x1
  32:	94a50513          	addi	a0,a0,-1718 # 978 <malloc+0x11a>
  36:	770000ef          	jal	7a6 <printf>
        char *args[] = { "nosuchprog", 0};
  3a:	00001797          	auipc	a5,0x1
  3e:	95678793          	addi	a5,a5,-1706 # 990 <malloc+0x132>
  42:	fcf43423          	sd	a5,-56(s0)
  46:	fc043823          	sd	zero,-48(s0)
        exec("nosuchprog", args);
  4a:	fc840593          	addi	a1,s0,-56
  4e:	853e                	mv	a0,a5
  50:	338000ef          	jal	388 <exec>
        printf("exec failed\n"); // runs only if exec failed
  54:	00001517          	auipc	a0,0x1
  58:	94c50513          	addi	a0,a0,-1716 # 9a0 <malloc+0x142>
  5c:	74a000ef          	jal	7a6 <printf>
        exit(1);
  60:	4505                	li	a0,1
  62:	2ee000ef          	jal	350 <exit>
  66:	f426                	sd	s1,40(sp)
        printf("fork failed\n");
  68:	00001517          	auipc	a0,0x1
  6c:	90050513          	addi	a0,a0,-1792 # 968 <malloc+0x10a>
  70:	736000ef          	jal	7a6 <printf>
        exit(1);
  74:	4505                	li	a0,1
  76:	2da000ef          	jal	350 <exit>
    }

    int status;
    wait(&status); // step 3: wait for the child
  7a:	fdc40513          	addi	a0,s0,-36
  7e:	2da000ef          	jal	358 <wait>
    printf("parent: child %d ended with status %d\n", pid, status);
  82:	fdc42603          	lw	a2,-36(s0)
  86:	85a6                	mv	a1,s1
  88:	00001517          	auipc	a0,0x1
  8c:	92850513          	addi	a0,a0,-1752 # 9b0 <malloc+0x152>
  90:	716000ef          	jal	7a6 <printf>

    exit(0);
  94:	4501                	li	a0,0
  96:	2ba000ef          	jal	350 <exit>

000000000000009a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e406                	sd	ra,8(sp)
  9e:	e022                	sd	s0,0(sp)
  a0:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  a2:	f5fff0ef          	jal	0 <main>
  exit(r);
  a6:	2aa000ef          	jal	350 <exit>

00000000000000aa <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  b2:	87aa                	mv	a5,a0
  b4:	0585                	addi	a1,a1,1
  b6:	0785                	addi	a5,a5,1
  b8:	fff5c703          	lbu	a4,-1(a1)
  bc:	fee78fa3          	sb	a4,-1(a5)
  c0:	fb75                	bnez	a4,b4 <strcpy+0xa>
    ;
  return os;
}
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cb91                	beqz	a5,ea <strcmp+0x20>
  d8:	0005c703          	lbu	a4,0(a1)
  dc:	00f71763          	bne	a4,a5,ea <strcmp+0x20>
    p++, q++;
  e0:	0505                	addi	a0,a0,1
  e2:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbe5                	bnez	a5,d8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ea:	0005c503          	lbu	a0,0(a1)
}
  ee:	40a7853b          	subw	a0,a5,a0
  f2:	60a2                	ld	ra,8(sp)
  f4:	6402                	ld	s0,0(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strlen>:

uint
strlen(const char *s)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 102:	00054783          	lbu	a5,0(a0)
 106:	cf91                	beqz	a5,122 <strlen+0x28>
 108:	00150793          	addi	a5,a0,1
 10c:	86be                	mv	a3,a5
 10e:	0785                	addi	a5,a5,1
 110:	fff7c703          	lbu	a4,-1(a5)
 114:	ff65                	bnez	a4,10c <strlen+0x12>
 116:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 11a:	60a2                	ld	ra,8(sp)
 11c:	6402                	ld	s0,0(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret
  for (n = 0; s[n]; n++)
 122:	4501                	li	a0,0
 124:	bfdd                	j	11a <strlen+0x20>

0000000000000126 <memset>:

void *
memset(void *dst, int c, uint n)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 12e:	ca19                	beqz	a2,144 <memset+0x1e>
 130:	87aa                	mv	a5,a0
 132:	1602                	slli	a2,a2,0x20
 134:	9201                	srli	a2,a2,0x20
 136:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 13e:	0785                	addi	a5,a5,1
 140:	fee79de3          	bne	a5,a4,13a <memset+0x14>
  }
  return dst;
}
 144:	60a2                	ld	ra,8(sp)
 146:	6402                	ld	s0,0(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret

000000000000014c <strchr>:

char *
strchr(const char *s, char c)
{
 14c:	1141                	addi	sp,sp,-16
 14e:	e406                	sd	ra,8(sp)
 150:	e022                	sd	s0,0(sp)
 152:	0800                	addi	s0,sp,16
  for (; *s; s++)
 154:	00054783          	lbu	a5,0(a0)
 158:	cf81                	beqz	a5,170 <strchr+0x24>
    if (*s == c)
 15a:	00f58763          	beq	a1,a5,168 <strchr+0x1c>
  for (; *s; s++)
 15e:	0505                	addi	a0,a0,1
 160:	00054783          	lbu	a5,0(a0)
 164:	fbfd                	bnez	a5,15a <strchr+0xe>
      return (char *)s;
  return 0;
 166:	4501                	li	a0,0
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret
  return 0;
 170:	4501                	li	a0,0
 172:	bfdd                	j	168 <strchr+0x1c>

0000000000000174 <gets>:

char *
gets(char *buf, int max)
{
 174:	711d                	addi	sp,sp,-96
 176:	ec86                	sd	ra,88(sp)
 178:	e8a2                	sd	s0,80(sp)
 17a:	e4a6                	sd	s1,72(sp)
 17c:	e0ca                	sd	s2,64(sp)
 17e:	fc4e                	sd	s3,56(sp)
 180:	f852                	sd	s4,48(sp)
 182:	f456                	sd	s5,40(sp)
 184:	f05a                	sd	s6,32(sp)
 186:	ec5e                	sd	s7,24(sp)
 188:	e862                	sd	s8,16(sp)
 18a:	1080                	addi	s0,sp,96
 18c:	8baa                	mv	s7,a0
 18e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 190:	892a                	mv	s2,a0
 192:	4481                	li	s1,0
    cc = read(0, &c, 1);
 194:	faf40b13          	addi	s6,s0,-81
 198:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 19a:	8c26                	mv	s8,s1
 19c:	0014899b          	addiw	s3,s1,1
 1a0:	84ce                	mv	s1,s3
 1a2:	0349d463          	bge	s3,s4,1ca <gets+0x56>
    cc = read(0, &c, 1);
 1a6:	8656                	mv	a2,s5
 1a8:	85da                	mv	a1,s6
 1aa:	4501                	li	a0,0
 1ac:	1bc000ef          	jal	368 <read>
    if (cc < 1)
 1b0:	00a05d63          	blez	a0,1ca <gets+0x56>
      break;
    buf[i++] = c;
 1b4:	faf44783          	lbu	a5,-81(s0)
 1b8:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1bc:	0905                	addi	s2,s2,1
 1be:	ff678713          	addi	a4,a5,-10
 1c2:	c319                	beqz	a4,1c8 <gets+0x54>
 1c4:	17cd                	addi	a5,a5,-13
 1c6:	fbf1                	bnez	a5,19a <gets+0x26>
    buf[i++] = c;
 1c8:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ca:	9c5e                	add	s8,s8,s7
 1cc:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1d0:	855e                	mv	a0,s7
 1d2:	60e6                	ld	ra,88(sp)
 1d4:	6446                	ld	s0,80(sp)
 1d6:	64a6                	ld	s1,72(sp)
 1d8:	6906                	ld	s2,64(sp)
 1da:	79e2                	ld	s3,56(sp)
 1dc:	7a42                	ld	s4,48(sp)
 1de:	7aa2                	ld	s5,40(sp)
 1e0:	7b02                	ld	s6,32(sp)
 1e2:	6be2                	ld	s7,24(sp)
 1e4:	6c42                	ld	s8,16(sp)
 1e6:	6125                	addi	sp,sp,96
 1e8:	8082                	ret

00000000000001ea <stat>:

int
stat(const char *n, struct stat *st)
{
 1ea:	1101                	addi	sp,sp,-32
 1ec:	ec06                	sd	ra,24(sp)
 1ee:	e822                	sd	s0,16(sp)
 1f0:	e04a                	sd	s2,0(sp)
 1f2:	1000                	addi	s0,sp,32
 1f4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f6:	4581                	li	a1,0
 1f8:	198000ef          	jal	390 <open>
  if (fd < 0)
 1fc:	02054263          	bltz	a0,220 <stat+0x36>
 200:	e426                	sd	s1,8(sp)
 202:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 204:	85ca                	mv	a1,s2
 206:	1a2000ef          	jal	3a8 <fstat>
 20a:	892a                	mv	s2,a0
  close(fd);
 20c:	8526                	mv	a0,s1
 20e:	16a000ef          	jal	378 <close>
  return r;
 212:	64a2                	ld	s1,8(sp)
}
 214:	854a                	mv	a0,s2
 216:	60e2                	ld	ra,24(sp)
 218:	6442                	ld	s0,16(sp)
 21a:	6902                	ld	s2,0(sp)
 21c:	6105                	addi	sp,sp,32
 21e:	8082                	ret
    return -1;
 220:	57fd                	li	a5,-1
 222:	893e                	mv	s2,a5
 224:	bfc5                	j	214 <stat+0x2a>

0000000000000226 <atoi>:

int
atoi(const char *s)
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 22e:	00054683          	lbu	a3,0(a0)
 232:	fd06879b          	addiw	a5,a3,-48
 236:	0ff7f793          	zext.b	a5,a5
 23a:	4625                	li	a2,9
 23c:	02f66963          	bltu	a2,a5,26e <atoi+0x48>
 240:	872a                	mv	a4,a0
  n = 0;
 242:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 244:	0705                	addi	a4,a4,1
 246:	0025179b          	slliw	a5,a0,0x2
 24a:	9fa9                	addw	a5,a5,a0
 24c:	0017979b          	slliw	a5,a5,0x1
 250:	9fb5                	addw	a5,a5,a3
 252:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 256:	00074683          	lbu	a3,0(a4)
 25a:	fd06879b          	addiw	a5,a3,-48
 25e:	0ff7f793          	zext.b	a5,a5
 262:	fef671e3          	bgeu	a2,a5,244 <atoi+0x1e>
  return n;
}
 266:	60a2                	ld	ra,8(sp)
 268:	6402                	ld	s0,0(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
  n = 0;
 26e:	4501                	li	a0,0
 270:	bfdd                	j	266 <atoi+0x40>

0000000000000272 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 272:	1141                	addi	sp,sp,-16
 274:	e406                	sd	ra,8(sp)
 276:	e022                	sd	s0,0(sp)
 278:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27a:	02b57563          	bgeu	a0,a1,2a4 <memmove+0x32>
    while (n-- > 0)
 27e:	00c05f63          	blez	a2,29c <memmove+0x2a>
 282:	1602                	slli	a2,a2,0x20
 284:	9201                	srli	a2,a2,0x20
 286:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28a:	872a                	mv	a4,a0
      *dst++ = *src++;
 28c:	0585                	addi	a1,a1,1
 28e:	0705                	addi	a4,a4,1
 290:	fff5c683          	lbu	a3,-1(a1)
 294:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 298:	fee79ae3          	bne	a5,a4,28c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
    while (n-- > 0)
 2a4:	fec05ce3          	blez	a2,29c <memmove+0x2a>
    dst += n;
 2a8:	00c50733          	add	a4,a0,a2
    src += n;
 2ac:	95b2                	add	a1,a1,a2
 2ae:	fff6079b          	addiw	a5,a2,-1
 2b2:	1782                	slli	a5,a5,0x20
 2b4:	9381                	srli	a5,a5,0x20
 2b6:	fff7c793          	not	a5,a5
 2ba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2bc:	15fd                	addi	a1,a1,-1
 2be:	177d                	addi	a4,a4,-1
 2c0:	0005c683          	lbu	a3,0(a1)
 2c4:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2c8:	fef71ae3          	bne	a4,a5,2bc <memmove+0x4a>
 2cc:	bfc1                	j	29c <memmove+0x2a>

00000000000002ce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d6:	c61d                	beqz	a2,304 <memcmp+0x36>
 2d8:	1602                	slli	a2,a2,0x20
 2da:	9201                	srli	a2,a2,0x20
 2dc:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2e0:	00054783          	lbu	a5,0(a0)
 2e4:	0005c703          	lbu	a4,0(a1)
 2e8:	00e79863          	bne	a5,a4,2f8 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2ec:	0505                	addi	a0,a0,1
    p2++;
 2ee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f0:	fed518e3          	bne	a0,a3,2e0 <memcmp+0x12>
  }
  return 0;
 2f4:	4501                	li	a0,0
 2f6:	a019                	j	2fc <memcmp+0x2e>
      return *p1 - *p2;
 2f8:	40e7853b          	subw	a0,a5,a4
}
 2fc:	60a2                	ld	ra,8(sp)
 2fe:	6402                	ld	s0,0(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
  return 0;
 304:	4501                	li	a0,0
 306:	bfdd                	j	2fc <memcmp+0x2e>

0000000000000308 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e406                	sd	ra,8(sp)
 30c:	e022                	sd	s0,0(sp)
 30e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 310:	f63ff0ef          	jal	272 <memmove>
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <sbrk>:

char *
sbrk(int n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 324:	4585                	li	a1,1
 326:	0b2000ef          	jal	3d8 <sys_sbrk>
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret

0000000000000332 <sbrklazy>:

char *
sbrklazy(int n)
{
 332:	1141                	addi	sp,sp,-16
 334:	e406                	sd	ra,8(sp)
 336:	e022                	sd	s0,0(sp)
 338:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 33a:	4589                	li	a1,2
 33c:	09c000ef          	jal	3d8 <sys_sbrk>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 348:	4885                	li	a7,1
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <exit>:
.global exit
exit:
 li a7, SYS_exit
 350:	4889                	li	a7,2
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <wait>:
.global wait
wait:
 li a7, SYS_wait
 358:	488d                	li	a7,3
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 360:	4891                	li	a7,4
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <read>:
.global read
read:
 li a7, SYS_read
 368:	4895                	li	a7,5
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <write>:
.global write
write:
 li a7, SYS_write
 370:	48c1                	li	a7,16
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <close>:
.global close
close:
 li a7, SYS_close
 378:	48d5                	li	a7,21
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <kill>:
.global kill
kill:
 li a7, SYS_kill
 380:	4899                	li	a7,6
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exec>:
.global exec
exec:
 li a7, SYS_exec
 388:	489d                	li	a7,7
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <open>:
.global open
open:
 li a7, SYS_open
 390:	48bd                	li	a7,15
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 398:	48c5                	li	a7,17
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a0:	48c9                	li	a7,18
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a8:	48a1                	li	a7,8
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <link>:
.global link
link:
 li a7, SYS_link
 3b0:	48cd                	li	a7,19
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b8:	48d1                	li	a7,20
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c0:	48a5                	li	a7,9
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c8:	48a9                	li	a7,10
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d0:	48ad                	li	a7,11
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3d8:	48b1                	li	a7,12
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3e0:	48b5                	li	a7,13
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e8:	48b9                	li	a7,14
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3f0:	48d9                	li	a7,22
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3f8:	48dd                	li	a7,23
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 400:	1101                	addi	sp,sp,-32
 402:	ec06                	sd	ra,24(sp)
 404:	e822                	sd	s0,16(sp)
 406:	1000                	addi	s0,sp,32
 408:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40c:	4605                	li	a2,1
 40e:	fef40593          	addi	a1,s0,-17
 412:	f5fff0ef          	jal	370 <write>
}
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	6105                	addi	sp,sp,32
 41c:	8082                	ret

000000000000041e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 41e:	715d                	addi	sp,sp,-80
 420:	e486                	sd	ra,72(sp)
 422:	e0a2                	sd	s0,64(sp)
 424:	f84a                	sd	s2,48(sp)
 426:	f44e                	sd	s3,40(sp)
 428:	0880                	addi	s0,sp,80
 42a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 42c:	c6d1                	beqz	a3,4b8 <printint+0x9a>
 42e:	0805d563          	bgez	a1,4b8 <printint+0x9a>
    neg = 1;
    x = -xx;
 432:	40b005b3          	neg	a1,a1
    neg = 1;
 436:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 438:	fb840993          	addi	s3,s0,-72
  neg = 0;
 43c:	86ce                	mv	a3,s3
  i = 0;
 43e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 440:	00000817          	auipc	a6,0x0
 444:	5a080813          	addi	a6,a6,1440 # 9e0 <digits>
 448:	88ba                	mv	a7,a4
 44a:	0017051b          	addiw	a0,a4,1
 44e:	872a                	mv	a4,a0
 450:	02c5f7b3          	remu	a5,a1,a2
 454:	97c2                	add	a5,a5,a6
 456:	0007c783          	lbu	a5,0(a5)
 45a:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 45e:	87ae                	mv	a5,a1
 460:	02c5d5b3          	divu	a1,a1,a2
 464:	0685                	addi	a3,a3,1
 466:	fec7f1e3          	bgeu	a5,a2,448 <printint+0x2a>
  if (neg)
 46a:	00030c63          	beqz	t1,482 <printint+0x64>
    buf[i++] = '-';
 46e:	fd050793          	addi	a5,a0,-48
 472:	00878533          	add	a0,a5,s0
 476:	02d00793          	li	a5,45
 47a:	fef50423          	sb	a5,-24(a0)
 47e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 482:	02e05563          	blez	a4,4ac <printint+0x8e>
 486:	fc26                	sd	s1,56(sp)
 488:	377d                	addiw	a4,a4,-1
 48a:	00e984b3          	add	s1,s3,a4
 48e:	19fd                	addi	s3,s3,-1
 490:	99ba                	add	s3,s3,a4
 492:	1702                	slli	a4,a4,0x20
 494:	9301                	srli	a4,a4,0x20
 496:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 49a:	0004c583          	lbu	a1,0(s1)
 49e:	854a                	mv	a0,s2
 4a0:	f61ff0ef          	jal	400 <putc>
  while (--i >= 0)
 4a4:	14fd                	addi	s1,s1,-1
 4a6:	ff349ae3          	bne	s1,s3,49a <printint+0x7c>
 4aa:	74e2                	ld	s1,56(sp)
}
 4ac:	60a6                	ld	ra,72(sp)
 4ae:	6406                	ld	s0,64(sp)
 4b0:	7942                	ld	s2,48(sp)
 4b2:	79a2                	ld	s3,40(sp)
 4b4:	6161                	addi	sp,sp,80
 4b6:	8082                	ret
  neg = 0;
 4b8:	4301                	li	t1,0
 4ba:	bfbd                	j	438 <printint+0x1a>

00000000000004bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4bc:	711d                	addi	sp,sp,-96
 4be:	ec86                	sd	ra,88(sp)
 4c0:	e8a2                	sd	s0,80(sp)
 4c2:	e4a6                	sd	s1,72(sp)
 4c4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4c6:	0005c483          	lbu	s1,0(a1)
 4ca:	22048363          	beqz	s1,6f0 <vprintf+0x234>
 4ce:	e0ca                	sd	s2,64(sp)
 4d0:	fc4e                	sd	s3,56(sp)
 4d2:	f852                	sd	s4,48(sp)
 4d4:	f456                	sd	s5,40(sp)
 4d6:	f05a                	sd	s6,32(sp)
 4d8:	ec5e                	sd	s7,24(sp)
 4da:	e862                	sd	s8,16(sp)
 4dc:	8b2a                	mv	s6,a0
 4de:	8a2e                	mv	s4,a1
 4e0:	8bb2                	mv	s7,a2
  state = 0;
 4e2:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4e4:	4901                	li	s2,0
 4e6:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4e8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4ec:	06400c13          	li	s8,100
 4f0:	a00d                	j	512 <vprintf+0x56>
        putc(fd, c0);
 4f2:	85a6                	mv	a1,s1
 4f4:	855a                	mv	a0,s6
 4f6:	f0bff0ef          	jal	400 <putc>
 4fa:	a019                	j	500 <vprintf+0x44>
    } else if (state == '%') {
 4fc:	03598363          	beq	s3,s5,522 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 500:	0019079b          	addiw	a5,s2,1
 504:	893e                	mv	s2,a5
 506:	873e                	mv	a4,a5
 508:	97d2                	add	a5,a5,s4
 50a:	0007c483          	lbu	s1,0(a5)
 50e:	1c048a63          	beqz	s1,6e2 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 512:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 516:	fe0993e3          	bnez	s3,4fc <vprintf+0x40>
      if (c0 == '%') {
 51a:	fd579ce3          	bne	a5,s5,4f2 <vprintf+0x36>
        state = '%';
 51e:	89be                	mv	s3,a5
 520:	b7c5                	j	500 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 522:	00ea06b3          	add	a3,s4,a4
 526:	0016c603          	lbu	a2,1(a3)
      if (c1)
 52a:	1c060863          	beqz	a2,6fa <vprintf+0x23e>
      if (c0 == 'd') {
 52e:	03878763          	beq	a5,s8,55c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 532:	f9478693          	addi	a3,a5,-108
 536:	0016b693          	seqz	a3,a3
 53a:	f9c60593          	addi	a1,a2,-100
 53e:	e99d                	bnez	a1,574 <vprintf+0xb8>
 540:	ca95                	beqz	a3,574 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 542:	008b8493          	addi	s1,s7,8
 546:	4685                	li	a3,1
 548:	4629                	li	a2,10
 54a:	000bb583          	ld	a1,0(s7)
 54e:	855a                	mv	a0,s6
 550:	ecfff0ef          	jal	41e <printint>
        i += 1;
 554:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 556:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 558:	4981                	li	s3,0
 55a:	b75d                	j	500 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 55c:	008b8493          	addi	s1,s7,8
 560:	4685                	li	a3,1
 562:	4629                	li	a2,10
 564:	000ba583          	lw	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	eb5ff0ef          	jal	41e <printint>
 56e:	8ba6                	mv	s7,s1
      state = 0;
 570:	4981                	li	s3,0
 572:	b779                	j	500 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 574:	9752                	add	a4,a4,s4
 576:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 57a:	f9460713          	addi	a4,a2,-108
 57e:	00173713          	seqz	a4,a4
 582:	8f75                	and	a4,a4,a3
 584:	f9c58513          	addi	a0,a1,-100
 588:	18051363          	bnez	a0,70e <vprintf+0x252>
 58c:	18070163          	beqz	a4,70e <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 590:	008b8493          	addi	s1,s7,8
 594:	4685                	li	a3,1
 596:	4629                	li	a2,10
 598:	000bb583          	ld	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e81ff0ef          	jal	41e <printint>
        i += 2;
 5a2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a4:	8ba6                	mv	s7,s1
      state = 0;
 5a6:	4981                	li	s3,0
        i += 2;
 5a8:	bfa1                	j	500 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5aa:	008b8493          	addi	s1,s7,8
 5ae:	4681                	li	a3,0
 5b0:	4629                	li	a2,10
 5b2:	000be583          	lwu	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	e67ff0ef          	jal	41e <printint>
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b781                	j	500 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4629                	li	a2,10
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e4fff0ef          	jal	41e <printint>
        i += 1;
 5d4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b71d                	j	500 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	008b8493          	addi	s1,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4629                	li	a2,10
 5e4:	000bb583          	ld	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e35ff0ef          	jal	41e <printint>
        i += 2;
 5ee:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	8ba6                	mv	s7,s1
      state = 0;
 5f2:	4981                	li	s3,0
        i += 2;
 5f4:	b731                	j	500 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5f6:	008b8493          	addi	s1,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4641                	li	a2,16
 5fe:	000be583          	lwu	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	e1bff0ef          	jal	41e <printint>
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bdd5                	j	500 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 60e:	008b8493          	addi	s1,s7,8
 612:	4681                	li	a3,0
 614:	4641                	li	a2,16
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	e03ff0ef          	jal	41e <printint>
        i += 1;
 620:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	8ba6                	mv	s7,s1
      state = 0;
 624:	4981                	li	s3,0
 626:	bde9                	j	500 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	008b8493          	addi	s1,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	de9ff0ef          	jal	41e <printint>
        i += 2;
 63a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	8ba6                	mv	s7,s1
      state = 0;
 63e:	4981                	li	s3,0
        i += 2;
 640:	b5c1                	j	500 <vprintf+0x44>
 642:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 644:	008b8793          	addi	a5,s7,8
 648:	8cbe                	mv	s9,a5
 64a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 64e:	03000593          	li	a1,48
 652:	855a                	mv	a0,s6
 654:	dadff0ef          	jal	400 <putc>
  putc(fd, 'x');
 658:	07800593          	li	a1,120
 65c:	855a                	mv	a0,s6
 65e:	da3ff0ef          	jal	400 <putc>
 662:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 664:	00000b97          	auipc	s7,0x0
 668:	37cb8b93          	addi	s7,s7,892 # 9e0 <digits>
 66c:	03c9d793          	srli	a5,s3,0x3c
 670:	97de                	add	a5,a5,s7
 672:	0007c583          	lbu	a1,0(a5)
 676:	855a                	mv	a0,s6
 678:	d89ff0ef          	jal	400 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 67c:	0992                	slli	s3,s3,0x4
 67e:	34fd                	addiw	s1,s1,-1
 680:	f4f5                	bnez	s1,66c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 682:	8be6                	mv	s7,s9
      state = 0;
 684:	4981                	li	s3,0
 686:	6ca2                	ld	s9,8(sp)
 688:	bda5                	j	500 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 68a:	008b8493          	addi	s1,s7,8
 68e:	000bc583          	lbu	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	d6dff0ef          	jal	400 <putc>
 698:	8ba6                	mv	s7,s1
      state = 0;
 69a:	4981                	li	s3,0
 69c:	b595                	j	500 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 69e:	008b8993          	addi	s3,s7,8
 6a2:	000bb483          	ld	s1,0(s7)
 6a6:	cc91                	beqz	s1,6c2 <vprintf+0x206>
        for (; *s; s++)
 6a8:	0004c583          	lbu	a1,0(s1)
 6ac:	c985                	beqz	a1,6dc <vprintf+0x220>
          putc(fd, *s);
 6ae:	855a                	mv	a0,s6
 6b0:	d51ff0ef          	jal	400 <putc>
        for (; *s; s++)
 6b4:	0485                	addi	s1,s1,1
 6b6:	0004c583          	lbu	a1,0(s1)
 6ba:	f9f5                	bnez	a1,6ae <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 6bc:	8bce                	mv	s7,s3
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b581                	j	500 <vprintf+0x44>
          s = "(null)";
 6c2:	00000497          	auipc	s1,0x0
 6c6:	31648493          	addi	s1,s1,790 # 9d8 <malloc+0x17a>
        for (; *s; s++)
 6ca:	02800593          	li	a1,40
 6ce:	b7c5                	j	6ae <vprintf+0x1f2>
        putc(fd, '%');
 6d0:	85be                	mv	a1,a5
 6d2:	855a                	mv	a0,s6
 6d4:	d2dff0ef          	jal	400 <putc>
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b51d                	j	500 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6dc:	8bce                	mv	s7,s3
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b505                	j	500 <vprintf+0x44>
 6e2:	6906                	ld	s2,64(sp)
 6e4:	79e2                	ld	s3,56(sp)
 6e6:	7a42                	ld	s4,48(sp)
 6e8:	7aa2                	ld	s5,40(sp)
 6ea:	7b02                	ld	s6,32(sp)
 6ec:	6be2                	ld	s7,24(sp)
 6ee:	6c42                	ld	s8,16(sp)
    }
  }
}
 6f0:	60e6                	ld	ra,88(sp)
 6f2:	6446                	ld	s0,80(sp)
 6f4:	64a6                	ld	s1,72(sp)
 6f6:	6125                	addi	sp,sp,96
 6f8:	8082                	ret
      if (c0 == 'd') {
 6fa:	06400713          	li	a4,100
 6fe:	e4e78fe3          	beq	a5,a4,55c <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 702:	f9478693          	addi	a3,a5,-108
 706:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 70a:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 70c:	4701                	li	a4,0
      } else if (c0 == 'u') {
 70e:	07500513          	li	a0,117
 712:	e8a78ce3          	beq	a5,a0,5aa <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 716:	f8b60513          	addi	a0,a2,-117
 71a:	e119                	bnez	a0,720 <vprintf+0x264>
 71c:	ea0693e3          	bnez	a3,5c2 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 720:	f8b58513          	addi	a0,a1,-117
 724:	e119                	bnez	a0,72a <vprintf+0x26e>
 726:	ea071be3          	bnez	a4,5dc <vprintf+0x120>
      } else if (c0 == 'x') {
 72a:	07800513          	li	a0,120
 72e:	eca784e3          	beq	a5,a0,5f6 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 732:	f8860613          	addi	a2,a2,-120
 736:	e219                	bnez	a2,73c <vprintf+0x280>
 738:	ec069be3          	bnez	a3,60e <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 73c:	f8858593          	addi	a1,a1,-120
 740:	e199                	bnez	a1,746 <vprintf+0x28a>
 742:	ee0713e3          	bnez	a4,628 <vprintf+0x16c>
      } else if (c0 == 'p') {
 746:	07000713          	li	a4,112
 74a:	eee78ce3          	beq	a5,a4,642 <vprintf+0x186>
      } else if (c0 == 'c') {
 74e:	06300713          	li	a4,99
 752:	f2e78ce3          	beq	a5,a4,68a <vprintf+0x1ce>
      } else if (c0 == 's') {
 756:	07300713          	li	a4,115
 75a:	f4e782e3          	beq	a5,a4,69e <vprintf+0x1e2>
      } else if (c0 == '%') {
 75e:	02500713          	li	a4,37
 762:	f6e787e3          	beq	a5,a4,6d0 <vprintf+0x214>
        putc(fd, '%');
 766:	02500593          	li	a1,37
 76a:	855a                	mv	a0,s6
 76c:	c95ff0ef          	jal	400 <putc>
        putc(fd, c0);
 770:	85a6                	mv	a1,s1
 772:	855a                	mv	a0,s6
 774:	c8dff0ef          	jal	400 <putc>
      state = 0;
 778:	4981                	li	s3,0
 77a:	b359                	j	500 <vprintf+0x44>

000000000000077c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77c:	715d                	addi	sp,sp,-80
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	e010                	sd	a2,0(s0)
 786:	e414                	sd	a3,8(s0)
 788:	e818                	sd	a4,16(s0)
 78a:	ec1c                	sd	a5,24(s0)
 78c:	03043023          	sd	a6,32(s0)
 790:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 794:	8622                	mv	a2,s0
 796:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79a:	d23ff0ef          	jal	4bc <vprintf>
}
 79e:	60e2                	ld	ra,24(sp)
 7a0:	6442                	ld	s0,16(sp)
 7a2:	6161                	addi	sp,sp,80
 7a4:	8082                	ret

00000000000007a6 <printf>:

void
printf(const char *fmt, ...)
{
 7a6:	711d                	addi	sp,sp,-96
 7a8:	ec06                	sd	ra,24(sp)
 7aa:	e822                	sd	s0,16(sp)
 7ac:	1000                	addi	s0,sp,32
 7ae:	e40c                	sd	a1,8(s0)
 7b0:	e810                	sd	a2,16(s0)
 7b2:	ec14                	sd	a3,24(s0)
 7b4:	f018                	sd	a4,32(s0)
 7b6:	f41c                	sd	a5,40(s0)
 7b8:	03043823          	sd	a6,48(s0)
 7bc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c0:	00840613          	addi	a2,s0,8
 7c4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c8:	85aa                	mv	a1,a0
 7ca:	4505                	li	a0,1
 7cc:	cf1ff0ef          	jal	4bc <vprintf>
}
 7d0:	60e2                	ld	ra,24(sp)
 7d2:	6442                	ld	s0,16(sp)
 7d4:	6125                	addi	sp,sp,96
 7d6:	8082                	ret

00000000000007d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d8:	1141                	addi	sp,sp,-16
 7da:	e406                	sd	ra,8(sp)
 7dc:	e022                	sd	s0,0(sp)
 7de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7e0:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	00001797          	auipc	a5,0x1
 7e8:	81c7b783          	ld	a5,-2020(a5) # 1000 <freep>
 7ec:	a039                	j	7fa <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ee:	6398                	ld	a4,0(a5)
 7f0:	00e7e463          	bltu	a5,a4,7f8 <free+0x20>
 7f4:	00e6ea63          	bltu	a3,a4,808 <free+0x30>
{
 7f8:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	fed7fae3          	bgeu	a5,a3,7ee <free+0x16>
 7fe:	6398                	ld	a4,0(a5)
 800:	00e6e463          	bltu	a3,a4,808 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	fee7eae3          	bltu	a5,a4,7f8 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 808:	ff852583          	lw	a1,-8(a0)
 80c:	6390                	ld	a2,0(a5)
 80e:	02059813          	slli	a6,a1,0x20
 812:	01c85713          	srli	a4,a6,0x1c
 816:	9736                	add	a4,a4,a3
 818:	02e60563          	beq	a2,a4,842 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 81c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 820:	4790                	lw	a2,8(a5)
 822:	02061593          	slli	a1,a2,0x20
 826:	01c5d713          	srli	a4,a1,0x1c
 82a:	973e                	add	a4,a4,a5
 82c:	02e68263          	beq	a3,a4,850 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 830:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 832:	00000717          	auipc	a4,0x0
 836:	7cf73723          	sd	a5,1998(a4) # 1000 <freep>
}
 83a:	60a2                	ld	ra,8(sp)
 83c:	6402                	ld	s0,0(sp)
 83e:	0141                	addi	sp,sp,16
 840:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 842:	4618                	lw	a4,8(a2)
 844:	9f2d                	addw	a4,a4,a1
 846:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 84a:	6398                	ld	a4,0(a5)
 84c:	6310                	ld	a2,0(a4)
 84e:	b7f9                	j	81c <free+0x44>
    p->s.size += bp->s.size;
 850:	ff852703          	lw	a4,-8(a0)
 854:	9f31                	addw	a4,a4,a2
 856:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 858:	ff053683          	ld	a3,-16(a0)
 85c:	bfd1                	j	830 <free+0x58>

000000000000085e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 85e:	7139                	addi	sp,sp,-64
 860:	fc06                	sd	ra,56(sp)
 862:	f822                	sd	s0,48(sp)
 864:	f04a                	sd	s2,32(sp)
 866:	ec4e                	sd	s3,24(sp)
 868:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 86a:	02051993          	slli	s3,a0,0x20
 86e:	0209d993          	srli	s3,s3,0x20
 872:	09bd                	addi	s3,s3,15
 874:	0049d993          	srli	s3,s3,0x4
 878:	2985                	addiw	s3,s3,1
 87a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 87c:	00000517          	auipc	a0,0x0
 880:	78453503          	ld	a0,1924(a0) # 1000 <freep>
 884:	c905                	beqz	a0,8b4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 886:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 888:	4798                	lw	a4,8(a5)
 88a:	09377663          	bgeu	a4,s3,916 <malloc+0xb8>
 88e:	f426                	sd	s1,40(sp)
 890:	e852                	sd	s4,16(sp)
 892:	e456                	sd	s5,8(sp)
 894:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 896:	8a4e                	mv	s4,s3
 898:	6705                	lui	a4,0x1
 89a:	00e9f363          	bgeu	s3,a4,8a0 <malloc+0x42>
 89e:	6a05                	lui	s4,0x1
 8a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8a8:	00000497          	auipc	s1,0x0
 8ac:	75848493          	addi	s1,s1,1880 # 1000 <freep>
  if (p == SBRK_ERROR)
 8b0:	5afd                	li	s5,-1
 8b2:	a83d                	j	8f0 <malloc+0x92>
 8b4:	f426                	sd	s1,40(sp)
 8b6:	e852                	sd	s4,16(sp)
 8b8:	e456                	sd	s5,8(sp)
 8ba:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8bc:	00000797          	auipc	a5,0x0
 8c0:	75478793          	addi	a5,a5,1876 # 1010 <base>
 8c4:	00000717          	auipc	a4,0x0
 8c8:	72f73e23          	sd	a5,1852(a4) # 1000 <freep>
 8cc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ce:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8d2:	b7d1                	j	896 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8d4:	6398                	ld	a4,0(a5)
 8d6:	e118                	sd	a4,0(a0)
 8d8:	a899                	j	92e <malloc+0xd0>
  hp->s.size = nu;
 8da:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8de:	0541                	addi	a0,a0,16
 8e0:	ef9ff0ef          	jal	7d8 <free>
  return freep;
 8e4:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8e6:	c125                	beqz	a0,946 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8e8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8ea:	4798                	lw	a4,8(a5)
 8ec:	03277163          	bgeu	a4,s2,90e <malloc+0xb0>
    if (p == freep)
 8f0:	6098                	ld	a4,0(s1)
 8f2:	853e                	mv	a0,a5
 8f4:	fef71ae3          	bne	a4,a5,8e8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8f8:	8552                	mv	a0,s4
 8fa:	a23ff0ef          	jal	31c <sbrk>
  if (p == SBRK_ERROR)
 8fe:	fd551ee3          	bne	a0,s5,8da <malloc+0x7c>
        return 0;
 902:	4501                	li	a0,0
 904:	74a2                	ld	s1,40(sp)
 906:	6a42                	ld	s4,16(sp)
 908:	6aa2                	ld	s5,8(sp)
 90a:	6b02                	ld	s6,0(sp)
 90c:	a03d                	j	93a <malloc+0xdc>
 90e:	74a2                	ld	s1,40(sp)
 910:	6a42                	ld	s4,16(sp)
 912:	6aa2                	ld	s5,8(sp)
 914:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 916:	fae90fe3          	beq	s2,a4,8d4 <malloc+0x76>
        p->s.size -= nunits;
 91a:	4137073b          	subw	a4,a4,s3
 91e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 920:	02071693          	slli	a3,a4,0x20
 924:	01c6d713          	srli	a4,a3,0x1c
 928:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 92a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92e:	00000717          	auipc	a4,0x0
 932:	6ca73923          	sd	a0,1746(a4) # 1000 <freep>
      return (void *)(p + 1);
 936:	01078513          	addi	a0,a5,16
  }
}
 93a:	70e2                	ld	ra,56(sp)
 93c:	7442                	ld	s0,48(sp)
 93e:	7902                	ld	s2,32(sp)
 940:	69e2                	ld	s3,24(sp)
 942:	6121                	addi	sp,sp,64
 944:	8082                	ret
 946:	74a2                	ld	s1,40(sp)
 948:	6a42                	ld	s4,16(sp)
 94a:	6aa2                	ld	s5,8(sp)
 94c:	6b02                	ld	s6,0(sp)
 94e:	b7f5                	j	93a <malloc+0xdc>
