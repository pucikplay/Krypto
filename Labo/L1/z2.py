M_0 = '''
2dd31d1 c4eee6c5  69a3d69 5cf9af98 87b5ca2f ab7e4612 3e580440 897ffbb8
634ad55  2b3f409 8388e483 5a417125 e8255108 9fc9cdf7 f2bd1dd9 5b3c3780
'''
M_1 = '''
d11d0b96 9c7b41dc f497d8e4 d555655a c79a7335  cfdebf0 66f12930 8fb109d1
797f2775 eb5cd530 baade822 5c15cc79 ddcb74ed 6dd3c55f d80a9bb1 e3a7cc35
'''
_M_0 = '''
2dd31d1 c4eee6c5  69a3d69 5cf9af98  7b5ca2f ab7e4612 3e580440 897ffbb8
634ad55  2b3f409 8388e483 5a41f125 e8255108 9fc9cdf7 72bd1dd9 5b3c3780
'''
_M_1 = '''
d11d0b96 9c7b41dc f497d8e4 d555655a 479a7335  cfdebf0 66f12930 8fb109d1
797f2775 eb5cd530 baade822 5c154c79 ddcb74ed 6dd3c55f 580a9bb1 e3a7cc35
'''

import hashlib

T_0 = [int(m, base=16) for m in M_0.strip().split()]
T_1 = [int(m, base=16) for m in M_1.strip().split()]
U_0 = b''.join(t.to_bytes(4, 'little') for t in T_0)
U_1 = b''.join(t.to_bytes(4, 'little') for t in T_1)

T_00 = [int(m, base=16) for m in M_0.strip().split()]
T_11 = [int(m, base=16) for m in M_1.strip().split()]
T_00[4] = (T_00[4] + 2**31) % 2**32
T_00[11] = (T_00[11] + 2**15) % 2**32
T_00[14] = (T_00[14] + 2**31) % 2**32
T_11[4] = (T_11[4] + 2**31) % 2**32
T_11[11] = (T_11[11] - 2**15) % 2**32
T_11[14] = (T_11[14] + 2**31) % 2**32
U_00 = b''.join(t.to_bytes(4, 'little') for t in T_00)
U_11 = b''.join(t.to_bytes(4, 'little') for t in T_11)

Ua = b''.join([U_0, U_1])
Ub = b''.join([U_00, U_11])

print(Ua.hex())
print(Ub.hex())

print(hashlib.md5(Ua).hexdigest())
print(hashlib.md5(Ub).hexdigest())