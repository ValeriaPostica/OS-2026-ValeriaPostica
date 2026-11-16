
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    int p2c[2], c2p[2]; // parent-to-child, child-to-parent
    char b;

    if (pipe(p2c) < 0 || pipe(c2p) < 0) {
   8:	fe840513          	addi	a0,s0,-24
   c:	404000ef          	jal	410 <pipe>
  10:	00054863          	bltz	a0,20 <main+0x20>
  14:	fe040513          	addi	a0,s0,-32
  18:	3f8000ef          	jal	410 <pipe>
  1c:	00055b63          	bgez	a0,32 <main+0x32>
        printf("pipe failed\n");
  20:	00001517          	auipc	a0,0x1
  24:	9e050513          	addi	a0,a0,-1568 # a00 <malloc+0xf2>
  28:	02f000ef          	jal	856 <printf>
        exit(1);
  2c:	4505                	li	a0,1
  2e:	3d2000ef          	jal	400 <exit>
    }

    if(fork() == 0){
  32:	3c6000ef          	jal	3f8 <fork>
  36:	e159                	bnez	a0,bc <main+0xbc>
        close(p2c[1]); close(c2p[0]); // the ends the child does not use
  38:	fec42503          	lw	a0,-20(s0)
  3c:	3ec000ef          	jal	428 <close>
  40:	fe042503          	lw	a0,-32(s0)
  44:	3e4000ef          	jal	428 <close>

        // Read 1 byte from parent-to-child pipe
        if (read(p2c[0], &b, 1) != 1) {
  48:	4605                	li	a2,1
  4a:	fdf40593          	addi	a1,s0,-33
  4e:	fe842503          	lw	a0,-24(s0)
  52:	3c6000ef          	jal	418 <read>
  56:	4785                	li	a5,1
  58:	00f50b63          	beq	a0,a5,6e <main+0x6e>
            printf("child read failed\n");
  5c:	00001517          	auipc	a0,0x1
  60:	9bc50513          	addi	a0,a0,-1604 # a18 <malloc+0x10a>
  64:	7f2000ef          	jal	856 <printf>
            exit(1);
  68:	4505                	li	a0,1
  6a:	396000ef          	jal	400 <exit>
        }
        printf("%d: received ping\n", getpid());
  6e:	412000ef          	jal	480 <getpid>
  72:	85aa                	mv	a1,a0
  74:	00001517          	auipc	a0,0x1
  78:	9bc50513          	addi	a0,a0,-1604 # a30 <malloc+0x122>
  7c:	7da000ef          	jal	856 <printf>

        // Write the byte b into child-to-parent pipe
        if (write(c2p[1], &b, 1) != 1) {
  80:	4605                	li	a2,1
  82:	fdf40593          	addi	a1,s0,-33
  86:	fe442503          	lw	a0,-28(s0)
  8a:	396000ef          	jal	420 <write>
  8e:	4785                	li	a5,1
  90:	00f50b63          	beq	a0,a5,a6 <main+0xa6>
            printf("child write failed\n");
  94:	00001517          	auipc	a0,0x1
  98:	9b450513          	addi	a0,a0,-1612 # a48 <malloc+0x13a>
  9c:	7ba000ef          	jal	856 <printf>
            exit(1);
  a0:	4505                	li	a0,1
  a2:	35e000ef          	jal	400 <exit>
        }

        close(p2c[0]); close(c2p[1]);
  a6:	fe842503          	lw	a0,-24(s0)
  aa:	37e000ef          	jal	428 <close>
  ae:	fe442503          	lw	a0,-28(s0)
  b2:	376000ef          	jal	428 <close>
        exit(0);
  b6:	4501                	li	a0,0
  b8:	348000ef          	jal	400 <exit>
    }

    close(p2c[0]); close(c2p[1]); // the ends the parent does not use
  bc:	fe842503          	lw	a0,-24(s0)
  c0:	368000ef          	jal	428 <close>
  c4:	fe442503          	lw	a0,-28(s0)
  c8:	360000ef          	jal	428 <close>

    // Write 1 byte into parent-to-child pipe to start the game
    if (write(p2c[1], "x", 1) != 1) {
  cc:	4605                	li	a2,1
  ce:	00001597          	auipc	a1,0x1
  d2:	99258593          	addi	a1,a1,-1646 # a60 <malloc+0x152>
  d6:	fec42503          	lw	a0,-20(s0)
  da:	346000ef          	jal	420 <write>
  de:	4785                	li	a5,1
  e0:	00f50b63          	beq	a0,a5,f6 <main+0xf6>
        printf("parent write failed\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	98450513          	addi	a0,a0,-1660 # a68 <malloc+0x15a>
  ec:	76a000ef          	jal	856 <printf>
        exit(1);
  f0:	4505                	li	a0,1
  f2:	30e000ef          	jal	400 <exit>
    }

    // Read 1 byte from child-to-parent pipe
    if (read(c2p[0], &b, 1) != 1) {
  f6:	4605                	li	a2,1
  f8:	fdf40593          	addi	a1,s0,-33
  fc:	fe042503          	lw	a0,-32(s0)
 100:	318000ef          	jal	418 <read>
 104:	4785                	li	a5,1
 106:	00f50b63          	beq	a0,a5,11c <main+0x11c>
        printf("parent read failed\n");
 10a:	00001517          	auipc	a0,0x1
 10e:	97650513          	addi	a0,a0,-1674 # a80 <malloc+0x172>
 112:	744000ef          	jal	856 <printf>
        exit(1);
 116:	4505                	li	a0,1
 118:	2e8000ef          	jal	400 <exit>
    }
    printf("%d: received pong\n", getpid());
 11c:	364000ef          	jal	480 <getpid>
 120:	85aa                	mv	a1,a0
 122:	00001517          	auipc	a0,0x1
 126:	97650513          	addi	a0,a0,-1674 # a98 <malloc+0x18a>
 12a:	72c000ef          	jal	856 <printf>

    close(p2c[1]); close(c2p[0]);
 12e:	fec42503          	lw	a0,-20(s0)
 132:	2f6000ef          	jal	428 <close>
 136:	fe042503          	lw	a0,-32(s0)
 13a:	2ee000ef          	jal	428 <close>
    wait(0);
 13e:	4501                	li	a0,0
 140:	2c8000ef          	jal	408 <wait>
    exit(0);
 144:	4501                	li	a0,0
 146:	2ba000ef          	jal	400 <exit>

000000000000014a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 152:	eafff0ef          	jal	0 <main>
  exit(r);
 156:	2aa000ef          	jal	400 <exit>

000000000000015a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e406                	sd	ra,8(sp)
 15e:	e022                	sd	s0,0(sp)
 160:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 162:	87aa                	mv	a5,a0
 164:	0585                	addi	a1,a1,1
 166:	0785                	addi	a5,a5,1
 168:	fff5c703          	lbu	a4,-1(a1)
 16c:	fee78fa3          	sb	a4,-1(a5)
 170:	fb75                	bnez	a4,164 <strcpy+0xa>
    ;
  return os;
}
 172:	60a2                	ld	ra,8(sp)
 174:	6402                	ld	s0,0(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e406                	sd	ra,8(sp)
 17e:	e022                	sd	s0,0(sp)
 180:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	cb91                	beqz	a5,19a <strcmp+0x20>
 188:	0005c703          	lbu	a4,0(a1)
 18c:	00f71763          	bne	a4,a5,19a <strcmp+0x20>
    p++, q++;
 190:	0505                	addi	a0,a0,1
 192:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	fbe5                	bnez	a5,188 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 19a:	0005c503          	lbu	a0,0(a1)
}
 19e:	40a7853b          	subw	a0,a5,a0
 1a2:	60a2                	ld	ra,8(sp)
 1a4:	6402                	ld	s0,0(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strlen>:

uint
strlen(const char *s)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	cf91                	beqz	a5,1d2 <strlen+0x28>
 1b8:	00150793          	addi	a5,a0,1
 1bc:	86be                	mv	a3,a5
 1be:	0785                	addi	a5,a5,1
 1c0:	fff7c703          	lbu	a4,-1(a5)
 1c4:	ff65                	bnez	a4,1bc <strlen+0x12>
 1c6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1ca:	60a2                	ld	ra,8(sp)
 1cc:	6402                	ld	s0,0(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  for (n = 0; s[n]; n++)
 1d2:	4501                	li	a0,0
 1d4:	bfdd                	j	1ca <strlen+0x20>

00000000000001d6 <memset>:

void *
memset(void *dst, int c, uint n)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e406                	sd	ra,8(sp)
 1da:	e022                	sd	s0,0(sp)
 1dc:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 1de:	ca19                	beqz	a2,1f4 <memset+0x1e>
 1e0:	87aa                	mv	a5,a0
 1e2:	1602                	slli	a2,a2,0x20
 1e4:	9201                	srli	a2,a2,0x20
 1e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ea:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 1ee:	0785                	addi	a5,a5,1
 1f0:	fee79de3          	bne	a5,a4,1ea <memset+0x14>
  }
  return dst;
}
 1f4:	60a2                	ld	ra,8(sp)
 1f6:	6402                	ld	s0,0(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret

00000000000001fc <strchr>:

char *
strchr(const char *s, char c)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e406                	sd	ra,8(sp)
 200:	e022                	sd	s0,0(sp)
 202:	0800                	addi	s0,sp,16
  for (; *s; s++)
 204:	00054783          	lbu	a5,0(a0)
 208:	cf81                	beqz	a5,220 <strchr+0x24>
    if (*s == c)
 20a:	00f58763          	beq	a1,a5,218 <strchr+0x1c>
  for (; *s; s++)
 20e:	0505                	addi	a0,a0,1
 210:	00054783          	lbu	a5,0(a0)
 214:	fbfd                	bnez	a5,20a <strchr+0xe>
      return (char *)s;
  return 0;
 216:	4501                	li	a0,0
}
 218:	60a2                	ld	ra,8(sp)
 21a:	6402                	ld	s0,0(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret
  return 0;
 220:	4501                	li	a0,0
 222:	bfdd                	j	218 <strchr+0x1c>

0000000000000224 <gets>:

char *
gets(char *buf, int max)
{
 224:	711d                	addi	sp,sp,-96
 226:	ec86                	sd	ra,88(sp)
 228:	e8a2                	sd	s0,80(sp)
 22a:	e4a6                	sd	s1,72(sp)
 22c:	e0ca                	sd	s2,64(sp)
 22e:	fc4e                	sd	s3,56(sp)
 230:	f852                	sd	s4,48(sp)
 232:	f456                	sd	s5,40(sp)
 234:	f05a                	sd	s6,32(sp)
 236:	ec5e                	sd	s7,24(sp)
 238:	e862                	sd	s8,16(sp)
 23a:	1080                	addi	s0,sp,96
 23c:	8baa                	mv	s7,a0
 23e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 240:	892a                	mv	s2,a0
 242:	4481                	li	s1,0
    cc = read(0, &c, 1);
 244:	faf40b13          	addi	s6,s0,-81
 248:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 24a:	8c26                	mv	s8,s1
 24c:	0014899b          	addiw	s3,s1,1
 250:	84ce                	mv	s1,s3
 252:	0349d463          	bge	s3,s4,27a <gets+0x56>
    cc = read(0, &c, 1);
 256:	8656                	mv	a2,s5
 258:	85da                	mv	a1,s6
 25a:	4501                	li	a0,0
 25c:	1bc000ef          	jal	418 <read>
    if (cc < 1)
 260:	00a05d63          	blez	a0,27a <gets+0x56>
      break;
    buf[i++] = c;
 264:	faf44783          	lbu	a5,-81(s0)
 268:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 26c:	0905                	addi	s2,s2,1
 26e:	ff678713          	addi	a4,a5,-10
 272:	c319                	beqz	a4,278 <gets+0x54>
 274:	17cd                	addi	a5,a5,-13
 276:	fbf1                	bnez	a5,24a <gets+0x26>
    buf[i++] = c;
 278:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 27a:	9c5e                	add	s8,s8,s7
 27c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 280:	855e                	mv	a0,s7
 282:	60e6                	ld	ra,88(sp)
 284:	6446                	ld	s0,80(sp)
 286:	64a6                	ld	s1,72(sp)
 288:	6906                	ld	s2,64(sp)
 28a:	79e2                	ld	s3,56(sp)
 28c:	7a42                	ld	s4,48(sp)
 28e:	7aa2                	ld	s5,40(sp)
 290:	7b02                	ld	s6,32(sp)
 292:	6be2                	ld	s7,24(sp)
 294:	6c42                	ld	s8,16(sp)
 296:	6125                	addi	sp,sp,96
 298:	8082                	ret

000000000000029a <stat>:

int
stat(const char *n, struct stat *st)
{
 29a:	1101                	addi	sp,sp,-32
 29c:	ec06                	sd	ra,24(sp)
 29e:	e822                	sd	s0,16(sp)
 2a0:	e04a                	sd	s2,0(sp)
 2a2:	1000                	addi	s0,sp,32
 2a4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a6:	4581                	li	a1,0
 2a8:	198000ef          	jal	440 <open>
  if (fd < 0)
 2ac:	02054263          	bltz	a0,2d0 <stat+0x36>
 2b0:	e426                	sd	s1,8(sp)
 2b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b4:	85ca                	mv	a1,s2
 2b6:	1a2000ef          	jal	458 <fstat>
 2ba:	892a                	mv	s2,a0
  close(fd);
 2bc:	8526                	mv	a0,s1
 2be:	16a000ef          	jal	428 <close>
  return r;
 2c2:	64a2                	ld	s1,8(sp)
}
 2c4:	854a                	mv	a0,s2
 2c6:	60e2                	ld	ra,24(sp)
 2c8:	6442                	ld	s0,16(sp)
 2ca:	6902                	ld	s2,0(sp)
 2cc:	6105                	addi	sp,sp,32
 2ce:	8082                	ret
    return -1;
 2d0:	57fd                	li	a5,-1
 2d2:	893e                	mv	s2,a5
 2d4:	bfc5                	j	2c4 <stat+0x2a>

00000000000002d6 <atoi>:

int
atoi(const char *s)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 2de:	00054683          	lbu	a3,0(a0)
 2e2:	fd06879b          	addiw	a5,a3,-48
 2e6:	0ff7f793          	zext.b	a5,a5
 2ea:	4625                	li	a2,9
 2ec:	02f66963          	bltu	a2,a5,31e <atoi+0x48>
 2f0:	872a                	mv	a4,a0
  n = 0;
 2f2:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2f4:	0705                	addi	a4,a4,1
 2f6:	0025179b          	slliw	a5,a0,0x2
 2fa:	9fa9                	addw	a5,a5,a0
 2fc:	0017979b          	slliw	a5,a5,0x1
 300:	9fb5                	addw	a5,a5,a3
 302:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 306:	00074683          	lbu	a3,0(a4)
 30a:	fd06879b          	addiw	a5,a3,-48
 30e:	0ff7f793          	zext.b	a5,a5
 312:	fef671e3          	bgeu	a2,a5,2f4 <atoi+0x1e>
  return n;
}
 316:	60a2                	ld	ra,8(sp)
 318:	6402                	ld	s0,0(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
  n = 0;
 31e:	4501                	li	a0,0
 320:	bfdd                	j	316 <atoi+0x40>

0000000000000322 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e406                	sd	ra,8(sp)
 326:	e022                	sd	s0,0(sp)
 328:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 32a:	02b57563          	bgeu	a0,a1,354 <memmove+0x32>
    while (n-- > 0)
 32e:	00c05f63          	blez	a2,34c <memmove+0x2a>
 332:	1602                	slli	a2,a2,0x20
 334:	9201                	srli	a2,a2,0x20
 336:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 33a:	872a                	mv	a4,a0
      *dst++ = *src++;
 33c:	0585                	addi	a1,a1,1
 33e:	0705                	addi	a4,a4,1
 340:	fff5c683          	lbu	a3,-1(a1)
 344:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 348:	fee79ae3          	bne	a5,a4,33c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret
    while (n-- > 0)
 354:	fec05ce3          	blez	a2,34c <memmove+0x2a>
    dst += n;
 358:	00c50733          	add	a4,a0,a2
    src += n;
 35c:	95b2                	add	a1,a1,a2
 35e:	fff6079b          	addiw	a5,a2,-1
 362:	1782                	slli	a5,a5,0x20
 364:	9381                	srli	a5,a5,0x20
 366:	fff7c793          	not	a5,a5
 36a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36c:	15fd                	addi	a1,a1,-1
 36e:	177d                	addi	a4,a4,-1
 370:	0005c683          	lbu	a3,0(a1)
 374:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 378:	fef71ae3          	bne	a4,a5,36c <memmove+0x4a>
 37c:	bfc1                	j	34c <memmove+0x2a>

000000000000037e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 386:	c61d                	beqz	a2,3b4 <memcmp+0x36>
 388:	1602                	slli	a2,a2,0x20
 38a:	9201                	srli	a2,a2,0x20
 38c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 390:	00054783          	lbu	a5,0(a0)
 394:	0005c703          	lbu	a4,0(a1)
 398:	00e79863          	bne	a5,a4,3a8 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 39c:	0505                	addi	a0,a0,1
    p2++;
 39e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a0:	fed518e3          	bne	a0,a3,390 <memcmp+0x12>
  }
  return 0;
 3a4:	4501                	li	a0,0
 3a6:	a019                	j	3ac <memcmp+0x2e>
      return *p1 - *p2;
 3a8:	40e7853b          	subw	a0,a5,a4
}
 3ac:	60a2                	ld	ra,8(sp)
 3ae:	6402                	ld	s0,0(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
  return 0;
 3b4:	4501                	li	a0,0
 3b6:	bfdd                	j	3ac <memcmp+0x2e>

00000000000003b8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e406                	sd	ra,8(sp)
 3bc:	e022                	sd	s0,0(sp)
 3be:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3c0:	f63ff0ef          	jal	322 <memmove>
}
 3c4:	60a2                	ld	ra,8(sp)
 3c6:	6402                	ld	s0,0(sp)
 3c8:	0141                	addi	sp,sp,16
 3ca:	8082                	ret

00000000000003cc <sbrk>:

char *
sbrk(int n)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e406                	sd	ra,8(sp)
 3d0:	e022                	sd	s0,0(sp)
 3d2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3d4:	4585                	li	a1,1
 3d6:	0b2000ef          	jal	488 <sys_sbrk>
}
 3da:	60a2                	ld	ra,8(sp)
 3dc:	6402                	ld	s0,0(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <sbrklazy>:

char *
sbrklazy(int n)
{
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e406                	sd	ra,8(sp)
 3e6:	e022                	sd	s0,0(sp)
 3e8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3ea:	4589                	li	a1,2
 3ec:	09c000ef          	jal	488 <sys_sbrk>
}
 3f0:	60a2                	ld	ra,8(sp)
 3f2:	6402                	ld	s0,0(sp)
 3f4:	0141                	addi	sp,sp,16
 3f6:	8082                	ret

00000000000003f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f8:	4885                	li	a7,1
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <exit>:
.global exit
exit:
 li a7, SYS_exit
 400:	4889                	li	a7,2
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <wait>:
.global wait
wait:
 li a7, SYS_wait
 408:	488d                	li	a7,3
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 410:	4891                	li	a7,4
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <read>:
.global read
read:
 li a7, SYS_read
 418:	4895                	li	a7,5
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <write>:
.global write
write:
 li a7, SYS_write
 420:	48c1                	li	a7,16
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <close>:
.global close
close:
 li a7, SYS_close
 428:	48d5                	li	a7,21
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <kill>:
.global kill
kill:
 li a7, SYS_kill
 430:	4899                	li	a7,6
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <exec>:
.global exec
exec:
 li a7, SYS_exec
 438:	489d                	li	a7,7
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <open>:
.global open
open:
 li a7, SYS_open
 440:	48bd                	li	a7,15
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 448:	48c5                	li	a7,17
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 450:	48c9                	li	a7,18
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 458:	48a1                	li	a7,8
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <link>:
.global link
link:
 li a7, SYS_link
 460:	48cd                	li	a7,19
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 468:	48d1                	li	a7,20
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 470:	48a5                	li	a7,9
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <dup>:
.global dup
dup:
 li a7, SYS_dup
 478:	48a9                	li	a7,10
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 480:	48ad                	li	a7,11
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 488:	48b1                	li	a7,12
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <pause>:
.global pause
pause:
 li a7, SYS_pause
 490:	48b5                	li	a7,13
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 498:	48b9                	li	a7,14
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <sync>:
.global sync
sync:
 li a7, SYS_sync
 4a0:	48d9                	li	a7,22
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <trace>:
.global trace
trace:
 li a7, SYS_trace
 4a8:	48dd                	li	a7,23
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b0:	1101                	addi	sp,sp,-32
 4b2:	ec06                	sd	ra,24(sp)
 4b4:	e822                	sd	s0,16(sp)
 4b6:	1000                	addi	s0,sp,32
 4b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4bc:	4605                	li	a2,1
 4be:	fef40593          	addi	a1,s0,-17
 4c2:	f5fff0ef          	jal	420 <write>
}
 4c6:	60e2                	ld	ra,24(sp)
 4c8:	6442                	ld	s0,16(sp)
 4ca:	6105                	addi	sp,sp,32
 4cc:	8082                	ret

00000000000004ce <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4ce:	715d                	addi	sp,sp,-80
 4d0:	e486                	sd	ra,72(sp)
 4d2:	e0a2                	sd	s0,64(sp)
 4d4:	f84a                	sd	s2,48(sp)
 4d6:	f44e                	sd	s3,40(sp)
 4d8:	0880                	addi	s0,sp,80
 4da:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 4dc:	c6d1                	beqz	a3,568 <printint+0x9a>
 4de:	0805d563          	bgez	a1,568 <printint+0x9a>
    neg = 1;
    x = -xx;
 4e2:	40b005b3          	neg	a1,a1
    neg = 1;
 4e6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4e8:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4ec:	86ce                	mv	a3,s3
  i = 0;
 4ee:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4f0:	00000817          	auipc	a6,0x0
 4f4:	5c880813          	addi	a6,a6,1480 # ab8 <digits>
 4f8:	88ba                	mv	a7,a4
 4fa:	0017051b          	addiw	a0,a4,1
 4fe:	872a                	mv	a4,a0
 500:	02c5f7b3          	remu	a5,a1,a2
 504:	97c2                	add	a5,a5,a6
 506:	0007c783          	lbu	a5,0(a5)
 50a:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 50e:	87ae                	mv	a5,a1
 510:	02c5d5b3          	divu	a1,a1,a2
 514:	0685                	addi	a3,a3,1
 516:	fec7f1e3          	bgeu	a5,a2,4f8 <printint+0x2a>
  if (neg)
 51a:	00030c63          	beqz	t1,532 <printint+0x64>
    buf[i++] = '-';
 51e:	fd050793          	addi	a5,a0,-48
 522:	00878533          	add	a0,a5,s0
 526:	02d00793          	li	a5,45
 52a:	fef50423          	sb	a5,-24(a0)
 52e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 532:	02e05563          	blez	a4,55c <printint+0x8e>
 536:	fc26                	sd	s1,56(sp)
 538:	377d                	addiw	a4,a4,-1
 53a:	00e984b3          	add	s1,s3,a4
 53e:	19fd                	addi	s3,s3,-1
 540:	99ba                	add	s3,s3,a4
 542:	1702                	slli	a4,a4,0x20
 544:	9301                	srli	a4,a4,0x20
 546:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 54a:	0004c583          	lbu	a1,0(s1)
 54e:	854a                	mv	a0,s2
 550:	f61ff0ef          	jal	4b0 <putc>
  while (--i >= 0)
 554:	14fd                	addi	s1,s1,-1
 556:	ff349ae3          	bne	s1,s3,54a <printint+0x7c>
 55a:	74e2                	ld	s1,56(sp)
}
 55c:	60a6                	ld	ra,72(sp)
 55e:	6406                	ld	s0,64(sp)
 560:	7942                	ld	s2,48(sp)
 562:	79a2                	ld	s3,40(sp)
 564:	6161                	addi	sp,sp,80
 566:	8082                	ret
  neg = 0;
 568:	4301                	li	t1,0
 56a:	bfbd                	j	4e8 <printint+0x1a>

000000000000056c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 56c:	711d                	addi	sp,sp,-96
 56e:	ec86                	sd	ra,88(sp)
 570:	e8a2                	sd	s0,80(sp)
 572:	e4a6                	sd	s1,72(sp)
 574:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 576:	0005c483          	lbu	s1,0(a1)
 57a:	22048363          	beqz	s1,7a0 <vprintf+0x234>
 57e:	e0ca                	sd	s2,64(sp)
 580:	fc4e                	sd	s3,56(sp)
 582:	f852                	sd	s4,48(sp)
 584:	f456                	sd	s5,40(sp)
 586:	f05a                	sd	s6,32(sp)
 588:	ec5e                	sd	s7,24(sp)
 58a:	e862                	sd	s8,16(sp)
 58c:	8b2a                	mv	s6,a0
 58e:	8a2e                	mv	s4,a1
 590:	8bb2                	mv	s7,a2
  state = 0;
 592:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 594:	4901                	li	s2,0
 596:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 598:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 59c:	06400c13          	li	s8,100
 5a0:	a00d                	j	5c2 <vprintf+0x56>
        putc(fd, c0);
 5a2:	85a6                	mv	a1,s1
 5a4:	855a                	mv	a0,s6
 5a6:	f0bff0ef          	jal	4b0 <putc>
 5aa:	a019                	j	5b0 <vprintf+0x44>
    } else if (state == '%') {
 5ac:	03598363          	beq	s3,s5,5d2 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 5b0:	0019079b          	addiw	a5,s2,1
 5b4:	893e                	mv	s2,a5
 5b6:	873e                	mv	a4,a5
 5b8:	97d2                	add	a5,a5,s4
 5ba:	0007c483          	lbu	s1,0(a5)
 5be:	1c048a63          	beqz	s1,792 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5c2:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 5c6:	fe0993e3          	bnez	s3,5ac <vprintf+0x40>
      if (c0 == '%') {
 5ca:	fd579ce3          	bne	a5,s5,5a2 <vprintf+0x36>
        state = '%';
 5ce:	89be                	mv	s3,a5
 5d0:	b7c5                	j	5b0 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 5d2:	00ea06b3          	add	a3,s4,a4
 5d6:	0016c603          	lbu	a2,1(a3)
      if (c1)
 5da:	1c060863          	beqz	a2,7aa <vprintf+0x23e>
      if (c0 == 'd') {
 5de:	03878763          	beq	a5,s8,60c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5e2:	f9478693          	addi	a3,a5,-108
 5e6:	0016b693          	seqz	a3,a3
 5ea:	f9c60593          	addi	a1,a2,-100
 5ee:	e99d                	bnez	a1,624 <vprintf+0xb8>
 5f0:	ca95                	beqz	a3,624 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	008b8493          	addi	s1,s7,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	ecfff0ef          	jal	4ce <printint>
        i += 1;
 604:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 606:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 608:	4981                	li	s3,0
 60a:	b75d                	j	5b0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 60c:	008b8493          	addi	s1,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000ba583          	lw	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	eb5ff0ef          	jal	4ce <printint>
 61e:	8ba6                	mv	s7,s1
      state = 0;
 620:	4981                	li	s3,0
 622:	b779                	j	5b0 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 624:	9752                	add	a4,a4,s4
 626:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 62a:	f9460713          	addi	a4,a2,-108
 62e:	00173713          	seqz	a4,a4
 632:	8f75                	and	a4,a4,a3
 634:	f9c58513          	addi	a0,a1,-100
 638:	18051363          	bnez	a0,7be <vprintf+0x252>
 63c:	18070163          	beqz	a4,7be <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 640:	008b8493          	addi	s1,s7,8
 644:	4685                	li	a3,1
 646:	4629                	li	a2,10
 648:	000bb583          	ld	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	e81ff0ef          	jal	4ce <printint>
        i += 2;
 652:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
        i += 2;
 658:	bfa1                	j	5b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000be583          	lwu	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	e67ff0ef          	jal	4ce <printint>
 66c:	8ba6                	mv	s7,s1
      state = 0;
 66e:	4981                	li	s3,0
 670:	b781                	j	5b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 672:	008b8493          	addi	s1,s7,8
 676:	4681                	li	a3,0
 678:	4629                	li	a2,10
 67a:	000bb583          	ld	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	e4fff0ef          	jal	4ce <printint>
        i += 1;
 684:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 686:	8ba6                	mv	s7,s1
      state = 0;
 688:	4981                	li	s3,0
 68a:	b71d                	j	5b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	008b8493          	addi	s1,s7,8
 690:	4681                	li	a3,0
 692:	4629                	li	a2,10
 694:	000bb583          	ld	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	e35ff0ef          	jal	4ce <printint>
        i += 2;
 69e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
        i += 2;
 6a4:	b731                	j	5b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6a6:	008b8493          	addi	s1,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4641                	li	a2,16
 6ae:	000be583          	lwu	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	e1bff0ef          	jal	4ce <printint>
 6b8:	8ba6                	mv	s7,s1
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bdd5                	j	5b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6be:	008b8493          	addi	s1,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4641                	li	a2,16
 6c6:	000bb583          	ld	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	e03ff0ef          	jal	4ce <printint>
        i += 1;
 6d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d2:	8ba6                	mv	s7,s1
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bde9                	j	5b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d8:	008b8493          	addi	s1,s7,8
 6dc:	4681                	li	a3,0
 6de:	4641                	li	a2,16
 6e0:	000bb583          	ld	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	de9ff0ef          	jal	4ce <printint>
        i += 2;
 6ea:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	8ba6                	mv	s7,s1
      state = 0;
 6ee:	4981                	li	s3,0
        i += 2;
 6f0:	b5c1                	j	5b0 <vprintf+0x44>
 6f2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6f4:	008b8793          	addi	a5,s7,8
 6f8:	8cbe                	mv	s9,a5
 6fa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6fe:	03000593          	li	a1,48
 702:	855a                	mv	a0,s6
 704:	dadff0ef          	jal	4b0 <putc>
  putc(fd, 'x');
 708:	07800593          	li	a1,120
 70c:	855a                	mv	a0,s6
 70e:	da3ff0ef          	jal	4b0 <putc>
 712:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 714:	00000b97          	auipc	s7,0x0
 718:	3a4b8b93          	addi	s7,s7,932 # ab8 <digits>
 71c:	03c9d793          	srli	a5,s3,0x3c
 720:	97de                	add	a5,a5,s7
 722:	0007c583          	lbu	a1,0(a5)
 726:	855a                	mv	a0,s6
 728:	d89ff0ef          	jal	4b0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72c:	0992                	slli	s3,s3,0x4
 72e:	34fd                	addiw	s1,s1,-1
 730:	f4f5                	bnez	s1,71c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 732:	8be6                	mv	s7,s9
      state = 0;
 734:	4981                	li	s3,0
 736:	6ca2                	ld	s9,8(sp)
 738:	bda5                	j	5b0 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 73a:	008b8493          	addi	s1,s7,8
 73e:	000bc583          	lbu	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	d6dff0ef          	jal	4b0 <putc>
 748:	8ba6                	mv	s7,s1
      state = 0;
 74a:	4981                	li	s3,0
 74c:	b595                	j	5b0 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 74e:	008b8993          	addi	s3,s7,8
 752:	000bb483          	ld	s1,0(s7)
 756:	cc91                	beqz	s1,772 <vprintf+0x206>
        for (; *s; s++)
 758:	0004c583          	lbu	a1,0(s1)
 75c:	c985                	beqz	a1,78c <vprintf+0x220>
          putc(fd, *s);
 75e:	855a                	mv	a0,s6
 760:	d51ff0ef          	jal	4b0 <putc>
        for (; *s; s++)
 764:	0485                	addi	s1,s1,1
 766:	0004c583          	lbu	a1,0(s1)
 76a:	f9f5                	bnez	a1,75e <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 76c:	8bce                	mv	s7,s3
      state = 0;
 76e:	4981                	li	s3,0
 770:	b581                	j	5b0 <vprintf+0x44>
          s = "(null)";
 772:	00000497          	auipc	s1,0x0
 776:	33e48493          	addi	s1,s1,830 # ab0 <malloc+0x1a2>
        for (; *s; s++)
 77a:	02800593          	li	a1,40
 77e:	b7c5                	j	75e <vprintf+0x1f2>
        putc(fd, '%');
 780:	85be                	mv	a1,a5
 782:	855a                	mv	a0,s6
 784:	d2dff0ef          	jal	4b0 <putc>
      state = 0;
 788:	4981                	li	s3,0
 78a:	b51d                	j	5b0 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 78c:	8bce                	mv	s7,s3
      state = 0;
 78e:	4981                	li	s3,0
 790:	b505                	j	5b0 <vprintf+0x44>
 792:	6906                	ld	s2,64(sp)
 794:	79e2                	ld	s3,56(sp)
 796:	7a42                	ld	s4,48(sp)
 798:	7aa2                	ld	s5,40(sp)
 79a:	7b02                	ld	s6,32(sp)
 79c:	6be2                	ld	s7,24(sp)
 79e:	6c42                	ld	s8,16(sp)
    }
  }
}
 7a0:	60e6                	ld	ra,88(sp)
 7a2:	6446                	ld	s0,80(sp)
 7a4:	64a6                	ld	s1,72(sp)
 7a6:	6125                	addi	sp,sp,96
 7a8:	8082                	ret
      if (c0 == 'd') {
 7aa:	06400713          	li	a4,100
 7ae:	e4e78fe3          	beq	a5,a4,60c <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 7b2:	f9478693          	addi	a3,a5,-108
 7b6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7ba:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7bc:	4701                	li	a4,0
      } else if (c0 == 'u') {
 7be:	07500513          	li	a0,117
 7c2:	e8a78ce3          	beq	a5,a0,65a <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 7c6:	f8b60513          	addi	a0,a2,-117
 7ca:	e119                	bnez	a0,7d0 <vprintf+0x264>
 7cc:	ea0693e3          	bnez	a3,672 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 7d0:	f8b58513          	addi	a0,a1,-117
 7d4:	e119                	bnez	a0,7da <vprintf+0x26e>
 7d6:	ea071be3          	bnez	a4,68c <vprintf+0x120>
      } else if (c0 == 'x') {
 7da:	07800513          	li	a0,120
 7de:	eca784e3          	beq	a5,a0,6a6 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 7e2:	f8860613          	addi	a2,a2,-120
 7e6:	e219                	bnez	a2,7ec <vprintf+0x280>
 7e8:	ec069be3          	bnez	a3,6be <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 7ec:	f8858593          	addi	a1,a1,-120
 7f0:	e199                	bnez	a1,7f6 <vprintf+0x28a>
 7f2:	ee0713e3          	bnez	a4,6d8 <vprintf+0x16c>
      } else if (c0 == 'p') {
 7f6:	07000713          	li	a4,112
 7fa:	eee78ce3          	beq	a5,a4,6f2 <vprintf+0x186>
      } else if (c0 == 'c') {
 7fe:	06300713          	li	a4,99
 802:	f2e78ce3          	beq	a5,a4,73a <vprintf+0x1ce>
      } else if (c0 == 's') {
 806:	07300713          	li	a4,115
 80a:	f4e782e3          	beq	a5,a4,74e <vprintf+0x1e2>
      } else if (c0 == '%') {
 80e:	02500713          	li	a4,37
 812:	f6e787e3          	beq	a5,a4,780 <vprintf+0x214>
        putc(fd, '%');
 816:	02500593          	li	a1,37
 81a:	855a                	mv	a0,s6
 81c:	c95ff0ef          	jal	4b0 <putc>
        putc(fd, c0);
 820:	85a6                	mv	a1,s1
 822:	855a                	mv	a0,s6
 824:	c8dff0ef          	jal	4b0 <putc>
      state = 0;
 828:	4981                	li	s3,0
 82a:	b359                	j	5b0 <vprintf+0x44>

000000000000082c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 82c:	715d                	addi	sp,sp,-80
 82e:	ec06                	sd	ra,24(sp)
 830:	e822                	sd	s0,16(sp)
 832:	1000                	addi	s0,sp,32
 834:	e010                	sd	a2,0(s0)
 836:	e414                	sd	a3,8(s0)
 838:	e818                	sd	a4,16(s0)
 83a:	ec1c                	sd	a5,24(s0)
 83c:	03043023          	sd	a6,32(s0)
 840:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 844:	8622                	mv	a2,s0
 846:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 84a:	d23ff0ef          	jal	56c <vprintf>
}
 84e:	60e2                	ld	ra,24(sp)
 850:	6442                	ld	s0,16(sp)
 852:	6161                	addi	sp,sp,80
 854:	8082                	ret

0000000000000856 <printf>:

void
printf(const char *fmt, ...)
{
 856:	711d                	addi	sp,sp,-96
 858:	ec06                	sd	ra,24(sp)
 85a:	e822                	sd	s0,16(sp)
 85c:	1000                	addi	s0,sp,32
 85e:	e40c                	sd	a1,8(s0)
 860:	e810                	sd	a2,16(s0)
 862:	ec14                	sd	a3,24(s0)
 864:	f018                	sd	a4,32(s0)
 866:	f41c                	sd	a5,40(s0)
 868:	03043823          	sd	a6,48(s0)
 86c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	00840613          	addi	a2,s0,8
 874:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 878:	85aa                	mv	a1,a0
 87a:	4505                	li	a0,1
 87c:	cf1ff0ef          	jal	56c <vprintf>
}
 880:	60e2                	ld	ra,24(sp)
 882:	6442                	ld	s0,16(sp)
 884:	6125                	addi	sp,sp,96
 886:	8082                	ret

0000000000000888 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 888:	1141                	addi	sp,sp,-16
 88a:	e406                	sd	ra,8(sp)
 88c:	e022                	sd	s0,0(sp)
 88e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 890:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 894:	00000797          	auipc	a5,0x0
 898:	76c7b783          	ld	a5,1900(a5) # 1000 <freep>
 89c:	a039                	j	8aa <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	6398                	ld	a4,0(a5)
 8a0:	00e7e463          	bltu	a5,a4,8a8 <free+0x20>
 8a4:	00e6ea63          	bltu	a3,a4,8b8 <free+0x30>
{
 8a8:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8aa:	fed7fae3          	bgeu	a5,a3,89e <free+0x16>
 8ae:	6398                	ld	a4,0(a5)
 8b0:	00e6e463          	bltu	a3,a4,8b8 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b4:	fee7eae3          	bltu	a5,a4,8a8 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 8b8:	ff852583          	lw	a1,-8(a0)
 8bc:	6390                	ld	a2,0(a5)
 8be:	02059813          	slli	a6,a1,0x20
 8c2:	01c85713          	srli	a4,a6,0x1c
 8c6:	9736                	add	a4,a4,a3
 8c8:	02e60563          	beq	a2,a4,8f2 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8cc:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 8d0:	4790                	lw	a2,8(a5)
 8d2:	02061593          	slli	a1,a2,0x20
 8d6:	01c5d713          	srli	a4,a1,0x1c
 8da:	973e                	add	a4,a4,a5
 8dc:	02e68263          	beq	a3,a4,900 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8e0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8e2:	00000717          	auipc	a4,0x0
 8e6:	70f73f23          	sd	a5,1822(a4) # 1000 <freep>
}
 8ea:	60a2                	ld	ra,8(sp)
 8ec:	6402                	ld	s0,0(sp)
 8ee:	0141                	addi	sp,sp,16
 8f0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8f2:	4618                	lw	a4,8(a2)
 8f4:	9f2d                	addw	a4,a4,a1
 8f6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8fa:	6398                	ld	a4,0(a5)
 8fc:	6310                	ld	a2,0(a4)
 8fe:	b7f9                	j	8cc <free+0x44>
    p->s.size += bp->s.size;
 900:	ff852703          	lw	a4,-8(a0)
 904:	9f31                	addw	a4,a4,a2
 906:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 908:	ff053683          	ld	a3,-16(a0)
 90c:	bfd1                	j	8e0 <free+0x58>

000000000000090e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 90e:	7139                	addi	sp,sp,-64
 910:	fc06                	sd	ra,56(sp)
 912:	f822                	sd	s0,48(sp)
 914:	f04a                	sd	s2,32(sp)
 916:	ec4e                	sd	s3,24(sp)
 918:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 91a:	02051993          	slli	s3,a0,0x20
 91e:	0209d993          	srli	s3,s3,0x20
 922:	09bd                	addi	s3,s3,15
 924:	0049d993          	srli	s3,s3,0x4
 928:	2985                	addiw	s3,s3,1
 92a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 92c:	00000517          	auipc	a0,0x0
 930:	6d453503          	ld	a0,1748(a0) # 1000 <freep>
 934:	c905                	beqz	a0,964 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 936:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 938:	4798                	lw	a4,8(a5)
 93a:	09377663          	bgeu	a4,s3,9c6 <malloc+0xb8>
 93e:	f426                	sd	s1,40(sp)
 940:	e852                	sd	s4,16(sp)
 942:	e456                	sd	s5,8(sp)
 944:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 946:	8a4e                	mv	s4,s3
 948:	6705                	lui	a4,0x1
 94a:	00e9f363          	bgeu	s3,a4,950 <malloc+0x42>
 94e:	6a05                	lui	s4,0x1
 950:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 954:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 958:	00000497          	auipc	s1,0x0
 95c:	6a848493          	addi	s1,s1,1704 # 1000 <freep>
  if (p == SBRK_ERROR)
 960:	5afd                	li	s5,-1
 962:	a83d                	j	9a0 <malloc+0x92>
 964:	f426                	sd	s1,40(sp)
 966:	e852                	sd	s4,16(sp)
 968:	e456                	sd	s5,8(sp)
 96a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 96c:	00000797          	auipc	a5,0x0
 970:	6a478793          	addi	a5,a5,1700 # 1010 <base>
 974:	00000717          	auipc	a4,0x0
 978:	68f73623          	sd	a5,1676(a4) # 1000 <freep>
 97c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 982:	b7d1                	j	946 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 984:	6398                	ld	a4,0(a5)
 986:	e118                	sd	a4,0(a0)
 988:	a899                	j	9de <malloc+0xd0>
  hp->s.size = nu;
 98a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 98e:	0541                	addi	a0,a0,16
 990:	ef9ff0ef          	jal	888 <free>
  return freep;
 994:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 996:	c125                	beqz	a0,9f6 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 998:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 99a:	4798                	lw	a4,8(a5)
 99c:	03277163          	bgeu	a4,s2,9be <malloc+0xb0>
    if (p == freep)
 9a0:	6098                	ld	a4,0(s1)
 9a2:	853e                	mv	a0,a5
 9a4:	fef71ae3          	bne	a4,a5,998 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9a8:	8552                	mv	a0,s4
 9aa:	a23ff0ef          	jal	3cc <sbrk>
  if (p == SBRK_ERROR)
 9ae:	fd551ee3          	bne	a0,s5,98a <malloc+0x7c>
        return 0;
 9b2:	4501                	li	a0,0
 9b4:	74a2                	ld	s1,40(sp)
 9b6:	6a42                	ld	s4,16(sp)
 9b8:	6aa2                	ld	s5,8(sp)
 9ba:	6b02                	ld	s6,0(sp)
 9bc:	a03d                	j	9ea <malloc+0xdc>
 9be:	74a2                	ld	s1,40(sp)
 9c0:	6a42                	ld	s4,16(sp)
 9c2:	6aa2                	ld	s5,8(sp)
 9c4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9c6:	fae90fe3          	beq	s2,a4,984 <malloc+0x76>
        p->s.size -= nunits;
 9ca:	4137073b          	subw	a4,a4,s3
 9ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d0:	02071693          	slli	a3,a4,0x20
 9d4:	01c6d713          	srli	a4,a3,0x1c
 9d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9de:	00000717          	auipc	a4,0x0
 9e2:	62a73123          	sd	a0,1570(a4) # 1000 <freep>
      return (void *)(p + 1);
 9e6:	01078513          	addi	a0,a5,16
  }
}
 9ea:	70e2                	ld	ra,56(sp)
 9ec:	7442                	ld	s0,48(sp)
 9ee:	7902                	ld	s2,32(sp)
 9f0:	69e2                	ld	s3,24(sp)
 9f2:	6121                	addi	sp,sp,64
 9f4:	8082                	ret
 9f6:	74a2                	ld	s1,40(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
 9fe:	b7f5                	j	9ea <malloc+0xdc>
