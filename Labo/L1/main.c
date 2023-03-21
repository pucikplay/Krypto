#include <stdio.h>
#include <stddef.h>
#include <string.h>
#include <stdbool.h>
#include "mbedtls/md5.h"

bool make_uuid_md5(const char* name, char* uuid, size_t uuid_len) {
  mbedtls_md5_context ctx;
  mbedtls_md5_init(&ctx);
  mbedtls_md5_starts(&ctx);
  mbedtls_md5_update(&ctx, (const uint8_t*) name, strlen(name));

  uint8_t hash[16];
  mbedtls_md5_finish(&ctx, hash);

  uuid_from_hash(hash, uuid, uuid_len);

  mbedtls_md5_free(&ctx);
  return true;
}

int main(void) {
  int M_0[32] = {0x2dd31d1, 0xc4eee6c5, 0x69a3d69, 0x5cf9af98, 0x87b5ca2f, 0xab7e4612, 0x3e580440, 0x897ffbb8, 0x634ad55, 0x2b3f409, 0x8388e483, 0x5a417125, 0xe8255108, 0x9fc9cdf7, 0xf2bd1dd9, 0x5b3c3780};
  
  char const* payload = "Hello world this is hush hush";
  int size = 16;
  char hashResult[(size * 2) + 1];

  make_uuid_md5((const char*)payload, hashResult, (size_t)size);

  printf("hash in hex result: %s", hashResult);
}