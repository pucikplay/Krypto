#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include "md5.h"

static void MD5Print(unsigned char digest[16]);
static void MD5String(char *string, bool);
inline static uint32_t reverse32(uint32_t);

int main(void) {
  UINT4 M_0[16] = {0x2dd31d1, 0xc4eee6c5, 0x69a3d69, 0x5cf9af98, 
                  0x87b5ca2f, 0xab7e4612, 0x3e580440, 0x897ffbb8, 
                  0x634ad55, 0x2b3f409, 0x8388e483, 0x5a417125, 
                  0xe8255108, 0x9fc9cdf7, 0xf2bd1dd9, 0x5b3c3780};

  UINT4 M_1[16] = {0xd11d0b96, 0x9c7b41dc, 0xf497d8e4, 0xd555655a,
                  0xc79a7335, 0xcfdebf0, 0x66f12930, 0x8fb109d1,
                  0x797f2775, 0xeb5cd530, 0xbaade822, 0x5c15cc79,
                  0xddcb74ed, 0x6dd3c55f, 0xd80a9bb1, 0xe3a7cc35};

  UINT4 M[32] = {0x2dd31d1, 0xc4eee6c5, 0x69a3d69, 0x5cf9af98, 
                0x87b5ca2f, 0xab7e4612, 0x3e580440, 0x897ffbb8, 
                0x634ad55, 0x2b3f409, 0x8388e483, 0x5a417125, 
                0xe8255108, 0x9fc9cdf7, 0xf2bd1dd9, 0x5b3c3780,
                0xd11d0b96, 0x9c7b41dc, 0xf497d8e4, 0xd555655a,
                0xc79a7335, 0xcfdebf0, 0x66f12930, 0x8fb109d1,
                0x797f2775, 0xeb5cd530, 0xbaade822, 0x5c15cc79,
                0xddcb74ed, 0x6dd3c55f, 0xd80a9bb1, 0xe3a7cc35};
  
  for (size_t i = 0; i < 16; i++) {
    M_0[i] = reverse32(M_0[i]);
    M_1[i] = reverse32(M_1[i]);
  }

  MD5String((char*)M, true);
  MD5String((char*)M, false);
  
  return 0;
}

static void MD5String(char *string, bool padding) {
  MD5_CTX context;
  unsigned char digest[16];
  unsigned int len = strlen(string);

  MD5Init(&context);
  MD5Update(&context, string, len);
  MD5Final(digest, &context, padding);

  //printf("MD5 (\"%s\") = ", string);
  MD5Print(digest);
  printf("\n");
}

static void MD5Print(unsigned char digest[16]) {
  unsigned int i;
  for (i = 0; i < 16; i++)
    printf ("%02x", digest[i]);
}

inline static uint32_t reverse32(uint32_t value)  {
    return (((value & 0x000000FF) << 24) |
            ((value & 0x0000FF00) <<  8) |
            ((value & 0x00FF0000) >>  8) |
            ((value & 0xFF000000) >> 24));
}