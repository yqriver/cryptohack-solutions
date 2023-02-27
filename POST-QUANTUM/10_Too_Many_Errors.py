from pwn import remote
import json

def reset():
    io.sendline(json.dumps({"option": "reset"}).encode())
    return json.loads(io.readline())

def get_sample():
    io.sendline(json.dumps({"option": "get_sample"}).encode())
    response = json.loads(io.readline())
    return response["a"], response["b"]

q = 127
io = remote('socket.cryptohack.org', '13390')
io.readline()

flag = list("crypto{????????????????????}")
while flag.count("?") != 0:
    while True:
        reset()
        a1, b1 = get_sample()
        reset()
        a2, b2 = get_sample()
        diff = [abs(x - y) for x, y in zip(a1, a2)]
        if diff.count(0) == len(a1) - 1:
            break
    i = diff.index(next(filter(lambda x: x != 0, diff)))
    c = chr(pow(a1[i] - a2[i], -1, q) * (b1 - b2) % q)
    flag[i] = c
    print("".join(flag))
