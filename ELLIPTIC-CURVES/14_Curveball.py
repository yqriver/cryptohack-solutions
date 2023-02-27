from pwn import remote
import json
import fastecdsa
from fastecdsa.point import Point

x = pow(n := 69420, -1, fastecdsa.curve.P256.G.curve.q)
mal_G = Point(0x3B827FF5E8EA151E6E51F8D0ABF08D90F571914A595891F9998A5BD49DFA3531, 0xAB61705C502CA0F7AA127DEC096B2BBDC9BD3B4281808B3740C320810888592A) * n
(io := remote("socket.cryptohack.org", 13382)).recv()
io.sendline(json.dumps({"host": "www.bing.com", 
                        "generator": [mal_G.x, mal_G.y], 
                        "curve": "secp256r1", 
                        "private_key": x
                        }).encode())
print(io.recvline().decode())
