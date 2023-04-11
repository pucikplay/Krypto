#ifndef _MD5CRACK_H_

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>

#define A1_0 0x0a000820
#define A1_1 0x84200000
//#define A1_P 0x00000000
#define D1_0 0x02208026
#define D1_1 0x8c000800
#define D1_P 0x701f10c0
#define C1_0 0x40201080
#define C1_1 0xbe1f0966
#define C1_P 0x00000018
#define B1_0 0x443b19ee
#define B1_1 0xba040010
#define B1_P 0x00000601
#define A2_0 0xb41011af
#define A2_1 0x482f0e50
//#define A2_P 0x00000000
#define D2_0 0x9a1113a9
#define D2_1 0x04220c56
//#define D2_P 0x00000000
#define C2_0 0x083201c0
#define C2_1 0x96011e01
#define C2_P 0x01808000
#define B2_0 0x1b810001
#define B2_1 0x843283c0
#define B2_P 0x00000002
#define A3_0 0x03828202
#define A3_1 0x9c0101c1
#define A3_P 0x00001000
#define D3_0 0x00041003
#define D3_1 0x878383c0
//#define D3_P 0x00000000
#define C3_0 0x00021000
#define C3_1 0x800583c3
#define C3_P 0x00086000
#define B3_0 0x0007e000
#define B3_1 0x80081080
#define B3_P 0x7f000000
#define A4_0 0xc0000080
#define A4_1 0x3f0fe008
//#define A4_P 0x00000000
#define D4_0 0xbf040000
#define D4_1 0x400be088
//#define D4_P 0x00000000
#define C4_0 0x82008008
#define C4_1 0x7d000000
//#define C4_P 0x00000000
#define B4_0 0x80000000
#define B4_1 0x20000000
//#define B4_P 0x00000000

/* Constants for MD5Transform routine.
 */
#define S11 7
#define S12 12
#define S13 17
#define S14 22
#define S21 5
#define S22 9
#define S23 14
#define S24 20
#define S31 4
#define S32 11
#define S33 16
#define S34 23
#define S41 6
#define S42 10
#define S43 15
#define S44 21

/* F, G, H and I are basic MD5 functions.
 */
#define F(x, y, z) (((x) & (y)) | ((~x) & (z)))
#define G(x, y, z) (((x) & (z)) | ((y) & (~z)))
#define H(x, y, z) ((x) ^ (y) ^ (z))
#define I(x, y, z) ((y) ^ ((x) | (~z)))

/* ROTATE_LEFT rotates x left n bits.
 */
#define ROTATE_LEFT(x, n) (((x) << (n)) | ((x) >> (32-(n))))
#define ROTATE_RIGHT(x, n) (((x) >> (n)) | ((x) << (32-(n))))

/* FF, GG, HH, and II transformations for rounds 1, 2, 3, and 4.
   Rotation is separate from addition to prevent recomputation.
 */
#define FF(a, b, c, d, x, s, ac) { \
    (a) += F ((b), (c), (d)) + (x) + (UINT4)(ac); \
    (a) = ROTATE_LEFT ((a), (s)); \
    (a) += (b); \
  }
#define GG(a, b, c, d, x, s, ac) { \
    (a) += G ((b), (c), (d)) + (x) + (UINT4)(ac); \
    (a) = ROTATE_LEFT ((a), (s)); \
    (a) += (b); \
  }
#define HH(a, b, c, d, x, s, ac) { \
    (a) += H ((b), (c), (d)) + (x) + (UINT4)(ac); \
    (a) = ROTATE_LEFT ((a), (s)); \
    (a) += (b); \
  }
#define II(a, b, c, d, x, s, ac) { \
    (a) += I ((b), (c), (d)) + (x) + (UINT4)(ac); \
    (a) = ROTATE_LEFT ((a), (s)); \
    (a) += (b); \
  }

#define FF_1(a, ap, b, c, d, x, s, ac) { \
    (x) = (a); \
    (x) -= (b); \
    (x) = ROTATE_RIGHT ((x),(s)); \
    (x) -= (F ((b), (c), (d)) + (UINT4)(ac) + (ap)); \
  }


#define MASK_0(a, mask) (a) &= (~mask)
#define MASK_1(a, mask) (a) |= (mask)
#define MASK_P(a, mask, prev) (a) = ((a) & (~mask)) | ((prev) & (mask))

/* POINTER defines a generic pointer type */
typedef unsigned char *POINTER;

/* UINT2 defines a two byte word */
typedef uint16_t UINT2;

/* UINT4 defines a four byte word */
typedef uint32_t UINT4;

typedef uint64_t UINT8;

/* MD5 context. */
typedef struct {
  UINT4 state[4];                                   /* state (ABCD) */
  UINT4 count[2];        /* number of bits, modulo 2^64 (lsb first) */
  unsigned char buffer[64];                         /* input buffer */
} MD5_CTX;

void updateAndAlter(MD5_CTX *, unsigned char *);
void m0Init(MD5_CTX *);
void m1Init(MD5_CTX *);
MD5_CTX getCorrect();

#endif //_MD5CRACK_H_
