#include "md5crack.h"

bool equalHash(MD5_CTX *, MD5_CTX *);

//jsf32 random:
typedef struct ranctx { UINT8 a; UINT8 b; UINT8 c; UINT8 d; } ranctx;
#define rot64(x,k) (((x)<<(k))|((x)>>(64-(k))))
UINT8 ranval(ranctx *x) {
  UINT8 e = x->a - rot64(x->b, 7);
  x->a = x->b ^ rot64(x->c, 13);
  x->b = x->c + rot64(x->d, 37);
  x->c = x->d + e;
  x->d = e + x->a;
  return x->d;
}

void raninit(ranctx *x, UINT8 seed) {
  UINT8 i;
  x->a = 0xf1ea5eed, x->b = x->c = x->d = seed;
  for (i = 0; i < 20; ++i) {
    (void)ranval(x);
  }
}

int main(void) {
  UINT4 M_0_0[16] = {0x2dd31d1, 0xc4eee6c5, 0x69a3d69, 0x5cf9af98, 
                  0x87b5ca2f, 0xab7e4612, 0x3e580440, 0x897ffbb8, 
                  0x634ad55, 0x2b3f409, 0x8388e483, 0x5a417125, 
                  0xe8255108, 0x9fc9cdf7, 0xf2bd1dd9, 0x5b3c3780};

  UINT4 M_1_0[16] = {0xd11d0b96, 0x9c7b41dc, 0xf497d8e4, 0xd555655a,
                  0xc79a7335, 0xcfdebf0, 0x66f12930, 0x8fb109d1,
                  0x797f2775, 0xeb5cd530, 0xbaade822, 0x5c15cc79,
                  0xddcb74ed, 0x6dd3c55f, 0xd80a9bb1, 0xe3a7cc35};

  UINT4 M_0_1[16] = {0x2dd31d1, 0xc4eee6c5, 0x69a3d69, 0x5cf9af98,
                    0x7b5ca2f, 0xab7e4612, 0x3e580440, 0x897ffbb8,
                    0x634ad55, 0x2b3f409, 0x8388e483, 0x5a41f125,
                    0xe8255108, 0x9fc9cdf7, 0x72bd1dd9, 0x5b3c3780};

  UINT4 M_1_1[16] = {0xd11d0b96, 0x9c7b41dc, 0xf497d8e4, 0xd555655a,
                    0x479a7335, 0xcfdebf0, 0x66f12930, 0x8fb109d1,
                    0x797f2775, 0xeb5cd530, 0xbaade822, 0x5c154c79,
                    0xddcb74ed, 0x6dd3c55f, 0x580a9bb1, 0xe3a7cc35};
  
  // POINTER M_0 = malloc(128);
  // POINTER M_1 = malloc(128);

  // memcpy(M_0, M_0_0, 64);
  // memcpy(&(M_0[64]), M_1_0, 64);

  // memcpy(M_1, M_0_1, 64);
  // memcpy(&(M_1[64]), M_1_1, 64);

  size_t i = 0;
  ranctx x;
  UINT8 a;

  raninit(&x, 1);

  POINTER M = malloc(64);

  for (size_t b = 0; b < 8; b++) {
    a = ranval(&x);
    memcpy(&(M[b*8]), &a, 8);
  }

  MD5_CTX H_0, H_1;
  m0Init(&H_0);
  m1Init(&H_1);
  checkCollision(&H_0, &H_1, (unsigned char*)M);

  while(!equalHash(&H_0,&H_1)) {
    i++;
    if (i % 10000000 == 0) printf("%ld\n",i);
    for (size_t b = 0; b < 8; b++) {
      a = ranval(&x);
      memcpy(&(M[b*8]), &a, 8);
    }
    m0Init(&H_0);
    m1Init(&H_1);
    checkCollision(&H_0, &H_1, (char*)M);
  }

  for (size_t b = 0; b < 64; b++) {
    printf("%02x", M[b]);
  }
  printf("\n");

  M[4*4+3] += 0x80;
  M[11*4+1] -= 0x80;
  M[14*4+3] += 0x80;

  for (size_t b = 0; b < 64; b++) {
    printf("%02x", M[b]);
  }
  printf("\n");

  for (size_t i = 0; i < 4; i++) {
    printf("%02x", H_0.state[i]);
  }
  printf("\n");

  for (size_t i = 0; i < 4; i++) {
    printf("%02x", H_1.state[i]);
  }
  printf("\n");

  return 0;
}

bool equalHash(MD5_CTX *context1, MD5_CTX *context2) {
  bool equal = true;
  for (size_t i = 0; i < 4; i++){
    if (context1->state[i] != context2->state[i]) {
      return false;
    }
  }
  return true;
}
