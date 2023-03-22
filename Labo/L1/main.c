#include "md5.h"

bool equalHash(POINTER, POINTER);

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
  
  POINTER M_0 = malloc(128);
  POINTER M_1 = malloc(128);

  memcpy(M_0, M_0_0, 64);
  memcpy(&(M_0[64]), M_1_0, 64);

  memcpy(M_1, M_0_1, 64);
  memcpy(&(M_1[64]), M_1_1, 64);

  printf("\n%d\n", equalHash(MD5String((char*)M_0, false), MD5String((char*)M_1, false)));
  
  return 0;
}

bool equalHash(POINTER digest1, POINTER digest2) {
  bool equal = true;
  for (size_t i = 0; i < 16; i++){
    printf("%02x", digest1[i]);
    if (digest1[i] != digest2[i]) {
      return false;
    }
  }
  return true;
}
