from pwn import remote
from tqdm import tqdm
import json

s = remote("socket.cryptohack.org", "13413")
s.recvuntil(b"?\n")
op = json.dumps({"option": "encrypt", "message": "0"}) + "\n"

n = 64
p = 257
q = 1048583
pinv = pow(p, -1, q)
samples = 100
mat = []
m = []
v = []

# get samples
for i in tqdm(range(samples)):
    s.sendline(op.encode())
    data = json.loads(s.recvline().decode())
    A = json.loads(data["A"])
    b = int(data["b"])
    A = [int((a * pinv) % q) for a in A]
    b = int((b * pinv) % q)
    mat.append([b] + A)
    m.append(A)
    v.append(b)

mat.append([q] + [0] * 64)
M = Matrix(ZZ, mat)
M = M.transpose()
M = M.stack(diagonal_matrix(samples + 1, [q] * samples))
M = M.dense_matrix()
print("doing LLL")
res = M.LLL()
print("LLL done")

# Solve for S after recovering error term
error = list(res[-1])
if error[-1] < 0:
    error = [e * -1 for e in error]

assert error[-1] == q
assert all([abs(e) <= 1 for e in error[:-1]])
m = Matrix(GF(q), m)
v = [b - e for b, e in zip(v, error)]
v = vector(GF(q), v)
S = m.solve_right(v)

flag = []
for i in range(32):
    s.sendline(json.dumps({"option": "get_flag", "index": i}).encode())
    data = json.loads(s.recvline().decode())
    A = json.loads(data["A"])
    b = int(data["b"])

    A = [int((a * pinv) % q) for a in A]
    b = int((b * pinv) % q)
    v = vector(GF(q), A)
    c = (p * int(b - int(S*v))) % q
    c = c if c < q/2 else c - q
    flag.append(c % p)
    print(bytes(flag))
