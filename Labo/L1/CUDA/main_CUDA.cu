#include <cuda_runtime.h>
#include "md5_CUDA.cuh"

#define NO_OF_THREADS_PER_BLOCK 256
#define NO_OF_BLOCKS 16
#define NO_OF_THREADS NO_OF_BLOCKS*NO_OF_THREADS_PER_BLOCK

__device__ static void Decode(UINT4 *output, unsigned char *input, unsigned int len) {
  unsigned int i, j;

  for (i = 0, j = 0; j < len; i++, j += 4)
    output[i] = ((UINT4)input[j]) | (((UINT4)input[j+1]) << 8) |
    (((UINT4)input[j+2]) << 16) | (((UINT4)input[j+3]) << 24);
}

__device__ void m0Init(MD5_CTX *context) {
  context->count[0] = context->count[1] = 0;
  context->state[0] = 0x52589324;
  context->state[1] = 0x3093d7ca;
  context->state[2] = 0x2a06dc54;
  context->state[3] = 0x20c5be06;
}

__device__ void m1Init(MD5_CTX *context) {
  context->count[0] = context->count[1] = 0;
  context->state[0] = 0xd2589324;
  context->state[1] = 0xb293d7ca;
  context->state[2] = 0xac06dc54;
  context->state[3] = 0xa2c5be06;
}

__device__ void h0Init(MD5_CTX *context) {
  context->state[0] = 0x9603161f;
  context->state[1] = 0xa30f9dbf;
  context->state[2] = 0x9f65ffbc;
  context->state[3] = 0xf41fc7ef;
}

__device__ void alterTransform(UINT4 state[4], unsigned char block[64]) {
  UINT4 a = state[0], b = state[1], c = state[2], d = state[3], x[16];
  UINT4 ap = state[0], bp = state[1], cp = state[2], dp = state[3];

  Decode(x, block, 64);

  FF (a, b, c, d, x[ 0], S11, 0xd76aa478); /* 1 */
  MASK_0(a,A1_0);
  MASK_1(a,A1_1);
  FF_1 (a, ap, b, c, d, x[ 0], S11, 0xd76aa478);
  ap = a;
  
  FF (d, a, b, c, x[ 1], S12, 0xe8c7b756); /* 2 */
  MASK_0(d,D1_0);
  MASK_1(d,D1_1);
  MASK_P(d,D1_P,a);
  FF_1 (d, dp, a, b, c, x[ 1], S12, 0xe8c7b756);
  dp = d;

  FF (c, d, a, b, x[ 2], S13, 0x242070db); /* 3 */
  MASK_0(c,C1_0);
  MASK_1(c,C1_1);
  MASK_P(c,C1_P,d);
  FF_1 (c, cp, d, a, b, x[ 2], S13, 0x242070db);
  cp = c;

  FF (b, c, d, a, x[ 3], S14, 0xc1bdceee); /* 4 */
  MASK_0(b,B1_0);
  MASK_1(b,B1_1);
  MASK_P(b,B1_P,c);
  FF_1 (b, bp, c, d, a, x[ 3], S14, 0xc1bdceee);
  bp = b;

  FF (a, b, c, d, x[ 4], S11, 0xf57c0faf); /* 5 */
  MASK_0(a,A2_0);
  MASK_1(a,A2_1);
  FF_1 (a, ap, b, c, d, x[ 4], S11, 0xf57c0faf);
  ap = a;

  FF (d, a, b, c, x[ 5], S12, 0x4787c62a); /* 6 */
  MASK_0(d,D2_0);
  MASK_1(d,D2_1);
  FF_1 (d, dp, a, b, c, x[ 5], S12, 0x4787c62a);
  dp = d;

  FF (c, d, a, b, x[ 6], S13, 0xa8304613); /* 7 */
  MASK_0(c,C2_0);
  MASK_1(c,C2_1);
  MASK_P(c,C2_P,d);
  FF_1 (c, cp, d, a, b, x[ 6], S13, 0xa8304613);
  cp = c;

  FF (b, c, d, a, x[ 7], S14, 0xfd469501); /* 8 */
  MASK_0(b,B2_0);
  MASK_1(b,B2_1);
  MASK_P(b,B2_P,c);
  FF_1 (b, bp, c, d, a, x[ 7], S14, 0xfd469501);
  bp = b;

  FF (a, b, c, d, x[ 8], S11, 0x698098d8); /* 9 */
  MASK_0(a,A3_0);
  MASK_1(a,A3_1);
  MASK_P(a,A3_P,b);
  FF_1 (a, ap, b, c, d, x[ 8], S11, 0x698098d8);
  ap = a;

  FF (d, a, b, c, x[ 9], S12, 0x8b44f7af); /* 10 */
  MASK_0(d,D3_0);
  MASK_1(d,D3_1);
  FF_1 (d, dp, a, b, c, x[ 9], S12, 0x8b44f7af);
  dp = d;

  FF (c, d, a, b, x[10], S13, 0xffff5bb1); /* 11 */
  MASK_0(c,C3_0);
  MASK_1(c,C3_1);
  MASK_P(c,C3_P,d);
  FF_1 (c, cp, d, a, b, x[10], S13, 0xffff5bb1);
  cp = c;

  FF (b, c, d, a, x[11], S14, 0x895cd7be); /* 12 */
  MASK_0(b,B3_0);
  MASK_1(b,B3_1);
  MASK_P(b,B3_P,c);
  FF_1 (b, bp, c, d, a, x[11], S14, 0x895cd7be);
  bp = b;

  FF (a, b, c, d, x[12], S11, 0x6b901122); /* 13 */
  MASK_0(a,A4_0);
  MASK_1(a,A4_1);
  FF_1 (a, ap, b, c, d, x[12], S11, 0x6b901122);

  FF (d, a, b, c, x[13], S12, 0xfd987193); /* 14 */
  MASK_0(d,D4_0);
  MASK_1(d,D4_1);
  FF_1 (d, dp, a, b, c, x[13], S12, 0xfd987193);

  FF (c, d, a, b, x[14], S13, 0xa679438e); /* 15 */
  MASK_0(c,C4_0);
  MASK_1(c,C4_1);
  FF_1 (c, cp, d, a, b, x[14], S13, 0xa679438e);

  FF (b, c, d, a, x[15], S14, 0x49b40821); /* 16 */
  MASK_0(b,B4_0);
  MASK_1(b,B4_1);
  FF_1 (b, bp, c, d, a, x[15], S14, 0x49b40821);

  /* Round 2 */
  GG (a, b, c, d, x[ 1], S21, 0xf61e2562); /* 17 */
  GG (d, a, b, c, x[ 6], S22, 0xc040b340); /* 18 */
  GG (c, d, a, b, x[11], S23, 0x265e5a51); /* 19 */
  GG (b, c, d, a, x[ 0], S24, 0xe9b6c7aa); /* 20 */
  GG (a, b, c, d, x[ 5], S21, 0xd62f105d); /* 21 */
  GG (d, a, b, c, x[10], S22,  0x2441453); /* 22 */
  GG (c, d, a, b, x[15], S23, 0xd8a1e681); /* 23 */
  GG (b, c, d, a, x[ 4], S24, 0xe7d3fbc8); /* 24 */
  GG (a, b, c, d, x[ 9], S21, 0x21e1cde6); /* 25 */
  GG (d, a, b, c, x[14], S22, 0xc33707d6); /* 26 */
  GG (c, d, a, b, x[ 3], S23, 0xf4d50d87); /* 27 */
  GG (b, c, d, a, x[ 8], S24, 0x455a14ed); /* 28 */
  GG (a, b, c, d, x[13], S21, 0xa9e3e905); /* 29 */
  GG (d, a, b, c, x[ 2], S22, 0xfcefa3f8); /* 30 */
  GG (c, d, a, b, x[ 7], S23, 0x676f02d9); /* 31 */
  GG (b, c, d, a, x[12], S24, 0x8d2a4c8a); /* 32 */

  /* Round 3 */
  HH (a, b, c, d, x[ 5], S31, 0xfffa3942); /* 33 */
  HH (d, a, b, c, x[ 8], S32, 0x8771f681); /* 34 */
  HH (c, d, a, b, x[11], S33, 0x6d9d6122); /* 35 */
  HH (b, c, d, a, x[14], S34, 0xfde5380c); /* 36 */
  HH (a, b, c, d, x[ 1], S31, 0xa4beea44); /* 37 */
  HH (d, a, b, c, x[ 4], S32, 0x4bdecfa9); /* 38 */
  HH (c, d, a, b, x[ 7], S33, 0xf6bb4b60); /* 39 */
  HH (b, c, d, a, x[10], S34, 0xbebfbc70); /* 40 */
  HH (a, b, c, d, x[13], S31, 0x289b7ec6); /* 41 */
  HH (d, a, b, c, x[ 0], S32, 0xeaa127fa); /* 42 */
  HH (c, d, a, b, x[ 3], S33, 0xd4ef3085); /* 43 */
  HH (b, c, d, a, x[ 6], S34,  0x4881d05); /* 44 */
  HH (a, b, c, d, x[ 9], S31, 0xd9d4d039); /* 45 */
  HH (d, a, b, c, x[12], S32, 0xe6db99e5); /* 46 */
  HH (c, d, a, b, x[15], S33, 0x1fa27cf8); /* 47 */
  HH (b, c, d, a, x[ 2], S34, 0xc4ac5665); /* 48 */

  /* Round 4 */
  II (a, b, c, d, x[ 0], S41, 0xf4292244); /* 49 */
  II (d, a, b, c, x[ 7], S42, 0x432aff97); /* 50 */
  II (c, d, a, b, x[14], S43, 0xab9423a7); /* 51 */
  II (b, c, d, a, x[ 5], S44, 0xfc93a039); /* 52 */
  II (a, b, c, d, x[12], S41, 0x655b59c3); /* 53 */
  II (d, a, b, c, x[ 3], S42, 0x8f0ccc92); /* 54 */
  II (c, d, a, b, x[10], S43, 0xffeff47d); /* 55 */
  II (b, c, d, a, x[ 1], S44, 0x85845dd1); /* 56 */
  II (a, b, c, d, x[ 8], S41, 0x6fa87e4f); /* 57 */
  II (d, a, b, c, x[15], S42, 0xfe2ce6e0); /* 58 */
  II (c, d, a, b, x[ 6], S43, 0xa3014314); /* 59 */
  II (b, c, d, a, x[13], S44, 0x4e0811a1); /* 60 */
  II (a, b, c, d, x[ 4], S41, 0xf7537e82); /* 61 */
  II (d, a, b, c, x[11], S42, 0xbd3af235); /* 62 */
  II (c, d, a, b, x[ 2], S43, 0x2ad7d2bb); /* 63 */
  II (b, c, d, a, x[ 9], S44, 0xeb86d391); /* 64 */

  state[0] += a;
  state[1] += b;
  state[2] += c;
  state[3] += d;
}

__device__ void transform(UINT4 state[4], unsigned char block[64]) {
  UINT4 a = state[0], b = state[1], c = state[2], d = state[3], x[16];
  
  Decode(x, block, 64);

  /* Round 1 */
  FF (a, b, c, d, x[ 0], S11, 0xd76aa478); /* 1 */
  FF (d, a, b, c, x[ 1], S12, 0xe8c7b756); /* 2 */
  FF (c, d, a, b, x[ 2], S13, 0x242070db); /* 3 */
  FF (b, c, d, a, x[ 3], S14, 0xc1bdceee); /* 4 */
  FF (a, b, c, d, x[ 4], S11, 0xf57c0faf); /* 5 */
  FF (d, a, b, c, x[ 5], S12, 0x4787c62a); /* 6 */
  FF (c, d, a, b, x[ 6], S13, 0xa8304613); /* 7 */
  FF (b, c, d, a, x[ 7], S14, 0xfd469501); /* 8 */
  FF (a, b, c, d, x[ 8], S11, 0x698098d8); /* 9 */
  FF (d, a, b, c, x[ 9], S12, 0x8b44f7af); /* 10 */
  FF (c, d, a, b, x[10], S13, 0xffff5bb1); /* 11 */
  FF (b, c, d, a, x[11], S14, 0x895cd7be); /* 12 */
  FF (a, b, c, d, x[12], S11, 0x6b901122); /* 13 */
  FF (d, a, b, c, x[13], S12, 0xfd987193); /* 14 */
  FF (c, d, a, b, x[14], S13, 0xa679438e); /* 15 */
  FF (b, c, d, a, x[15], S14, 0x49b40821); /* 16 */

  /* Round 2 */
  GG (a, b, c, d, x[ 1], S21, 0xf61e2562); /* 17 */
  GG (d, a, b, c, x[ 6], S22, 0xc040b340); /* 18 */
  GG (c, d, a, b, x[11], S23, 0x265e5a51); /* 19 */
  GG (b, c, d, a, x[ 0], S24, 0xe9b6c7aa); /* 20 */
  GG (a, b, c, d, x[ 5], S21, 0xd62f105d); /* 21 */
  GG (d, a, b, c, x[10], S22,  0x2441453); /* 22 */
  GG (c, d, a, b, x[15], S23, 0xd8a1e681); /* 23 */
  GG (b, c, d, a, x[ 4], S24, 0xe7d3fbc8); /* 24 */
  GG (a, b, c, d, x[ 9], S21, 0x21e1cde6); /* 25 */
  GG (d, a, b, c, x[14], S22, 0xc33707d6); /* 26 */
  GG (c, d, a, b, x[ 3], S23, 0xf4d50d87); /* 27 */
  GG (b, c, d, a, x[ 8], S24, 0x455a14ed); /* 28 */
  GG (a, b, c, d, x[13], S21, 0xa9e3e905); /* 29 */
  GG (d, a, b, c, x[ 2], S22, 0xfcefa3f8); /* 30 */
  GG (c, d, a, b, x[ 7], S23, 0x676f02d9); /* 31 */
  GG (b, c, d, a, x[12], S24, 0x8d2a4c8a); /* 32 */

  /* Round 3 */
  HH (a, b, c, d, x[ 5], S31, 0xfffa3942); /* 33 */
  HH (d, a, b, c, x[ 8], S32, 0x8771f681); /* 34 */
  HH (c, d, a, b, x[11], S33, 0x6d9d6122); /* 35 */
  HH (b, c, d, a, x[14], S34, 0xfde5380c); /* 36 */
  HH (a, b, c, d, x[ 1], S31, 0xa4beea44); /* 37 */
  HH (d, a, b, c, x[ 4], S32, 0x4bdecfa9); /* 38 */
  HH (c, d, a, b, x[ 7], S33, 0xf6bb4b60); /* 39 */
  HH (b, c, d, a, x[10], S34, 0xbebfbc70); /* 40 */
  HH (a, b, c, d, x[13], S31, 0x289b7ec6); /* 41 */
  HH (d, a, b, c, x[ 0], S32, 0xeaa127fa); /* 42 */
  HH (c, d, a, b, x[ 3], S33, 0xd4ef3085); /* 43 */
  HH (b, c, d, a, x[ 6], S34,  0x4881d05); /* 44 */
  HH (a, b, c, d, x[ 9], S31, 0xd9d4d039); /* 45 */
  HH (d, a, b, c, x[12], S32, 0xe6db99e5); /* 46 */
  HH (c, d, a, b, x[15], S33, 0x1fa27cf8); /* 47 */
  HH (b, c, d, a, x[ 2], S34, 0xc4ac5665); /* 48 */

  /* Round 4 */
  II (a, b, c, d, x[ 0], S41, 0xf4292244); /* 49 */
  II (d, a, b, c, x[ 7], S42, 0x432aff97); /* 50 */
  II (c, d, a, b, x[14], S43, 0xab9423a7); /* 51 */
  II (b, c, d, a, x[ 5], S44, 0xfc93a039); /* 52 */
  II (a, b, c, d, x[12], S41, 0x655b59c3); /* 53 */
  II (d, a, b, c, x[ 3], S42, 0x8f0ccc92); /* 54 */
  II (c, d, a, b, x[10], S43, 0xffeff47d); /* 55 */
  II (b, c, d, a, x[ 1], S44, 0x85845dd1); /* 56 */
  II (a, b, c, d, x[ 8], S41, 0x6fa87e4f); /* 57 */
  II (d, a, b, c, x[15], S42, 0xfe2ce6e0); /* 58 */
  II (c, d, a, b, x[ 6], S43, 0xa3014314); /* 59 */
  II (b, c, d, a, x[13], S44, 0x4e0811a1); /* 60 */
  II (a, b, c, d, x[ 4], S41, 0xf7537e82); /* 61 */
  II (d, a, b, c, x[11], S42, 0xbd3af235); /* 62 */
  II (c, d, a, b, x[ 2], S43, 0x2ad7d2bb); /* 63 */
  II (b, c, d, a, x[ 9], S44, 0xeb86d391); /* 64 */

  state[0] += a;
  state[1] += b;
  state[2] += c;
  state[3] += d;
}

__device__ void checkCollision(MD5_CTX *context1, MD5_CTX *context2, unsigned char *input) {
//   memcpy((POINTER)&context1->buffer[0], (POINTER)input, 64);
  alterTransform(context1->state, input);
  input[4*4+3] += 0x80;
  input[11*4+1] -= 0x80;
  input[14*4+3] += 0x80;
  transform(context2->state, input);
}


__device__ bool equalHash(MD5_CTX *context1, MD5_CTX *context2) {
  for (size_t i = 0; i < 4; i++){
    if (context1->state[i] != context2->state[i]) {
      return false;
    }
  }
  return true;
}

//jsf64 random:
typedef struct ranctx { UINT8 a; UINT8 b; UINT8 c; UINT8 d; } ranctx;
#define rot64(x,k) (((x)<<(k))|((x)>>(64-(k))))
__device__ UINT8 ranval(ranctx *x) {
  UINT8 e = x->a - rot64(x->b, 7);
  x->a = x->b ^ rot64(x->c, 13);
  x->b = x->c + rot64(x->d, 37);
  x->c = x->d + e;
  x->d = e + x->a;
  return x->d;
}

__device__ void raninit(ranctx *x, UINT8 seed) {
  UINT8 i;
  x->a = 0xf1ea5eed, x->b = x->c = x->d = seed;
  for (i = 0; i < 20; ++i) {
    (void)ranval(x);
  }
}

__global__ void cracking(unsigned char* out, volatile bool *found) {
  size_t i = 0;
  ranctx x;
  UINT8 a;
  const uint32_t index = blockIdx.x * blockDim.x + threadIdx.x;
  MD5_CTX H_0, H_1;
  unsigned char M[64];
  volatile __shared__ bool foundIt;
  volatile __shared__ size_t iters[NO_OF_THREADS];
  __shared__ bool whoFound[NO_OF_THREADS];

  if (threadIdx.x == 0) {foundIt = *found;}
  if (index == NO_OF_THREADS-1) printf("Threads: %d\n", NO_OF_THREADS);
  __syncthreads();

  raninit(&x, 1 << 30 - index);
  for (size_t b = 0; b < 8; b++) {
    a = ranval(&x);
    memcpy(&(M[b*8]), &a, 8);
  }
  m0Init(&H_0);
  m1Init(&H_1);
  checkCollision(&H_0, &H_1, M);

  while(!foundIt) {
    i++;
    if (i % 5000000 == 0 && index == 0) {
      size_t iter_sum = 0;
      for (size_t idx = 0; idx < NO_OF_THREADS; idx++) {
        iter_sum += iters[idx];
      }
      printf("Iterations passed: %ld\n", iter_sum);
    }
    for (size_t b = 0; b < 8; b++) {
      a = ranval(&x);
      memcpy(&(M[b*8]), &a, 8);
    }
    m0Init(&H_0);
    m1Init(&H_1);
    checkCollision(&H_0, &H_1, M);

    bool iFoundIt = equalHash(&H_0,&H_1);

    if (iFoundIt) { foundIt = true; *found = true; whoFound[index] = true;}
    if (threadIdx.x == 0 && *found) foundIt = true;

    if (i % 5000000 == 0) {
      iters[index] += 5000000;
    }
    __syncthreads();
  }

  if (whoFound[index]) {
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
  }
}

// __global__ void testKernel(unsigned char* M) {
//   printf("[%d, %d]:\t\tValue is:%d\n", blockIdx.y * gridDim.x + blockIdx.x,
//          threadIdx.z * blockDim.x * blockDim.y + threadIdx.y * blockDim.x +
//              threadIdx.x, 14);
// }

int main(void) {

  unsigned char* h_M = (unsigned char*)malloc(64);
  volatile bool* found;
  unsigned char* d_M;
  cudaMalloc(&d_M, 64);
  cudaMalloc(&found, sizeof(bool));

  cracking<<<NO_OF_BLOCKS,NO_OF_THREADS_PER_BLOCK>>>(h_M, found);

  cudaMemcpy(h_M, d_M, 64, cudaMemcpyDeviceToHost);
  cudaFree(d_M);

  // for (size_t b = 0; b < 64; b++) {
  //   printf("%02x", h_M[b]);
  // }
  // printf("\n");

  // h_M[4*4+3] += 0x80;
  // h_M[11*4+1] -= 0x80;
  // h_M[14*4+3] += 0x80;

  // for (size_t b = 0; b < 64; b++) {
  //   printf("%02x", h_M[b]);
  // }
  // printf("\n");
  
  return 0;
}
