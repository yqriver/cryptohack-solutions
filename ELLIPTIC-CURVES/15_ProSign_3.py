import hashlib
from Crypto.Util.number import bytes_to_long
from ecdsa.ecdsa import Public_key, Private_key, Signature, generator_192
import json
from pwn import remote

def sha1(data):
    return bytes_to_long(hashlib.sha1(data.encode()).digest())

def recv():
    io.sendline(b'{"option":"sign_time"}')
    sig = json.loads(io.recvline().decode())
    msg = sig['msg']
    r = int(sig['r'],16)
    s = int(sig['s'],16)
    return msg,r,s

g = generator_192
n = g.order()
io = remote("socket.cryptohack.org", "13381")
io.recvline()
msg, r, s = recv()

for k in range(1,60):
    hsh = sha1(msg)
    d = ((s*k - hsh) * pow(r, -1, n)) % n
    pub = Public_key(g, g * d)
    priv = Private_key(pub, d)
    if pub.verifies(hsh, Signature(r, s)):
        break


msg = "unlock"
hsh = sha1(msg)
sig = priv.sign(hsh, 420)
tosend = {"option":"verify","msg": msg, "r": hex(sig.r), "s": hex(sig.s)}
io.sendline(json.dumps(tosend).encode())
print(io.recv().decode())
