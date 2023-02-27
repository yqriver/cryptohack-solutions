from pwn import remote
from json import loads, dumps
from tqdm import tqdm

q = 0x10001
io = remote("socket.cryptohack.org", "13411")

def send(data):
    io.sendline(dumps(data).encode())
    recv = loads(io.readline())
    A, b = eval(recv["A"]), eval(recv["b"])
    return vector(GF(q), A), b

def solve_S():
    AA = []
    bb = []
    for _ in tqdm(range(64)):
        A, b = send({"option": "encrypt", "message": "0"})
        AA.append(A)
        bb.append(b)
    AA = Matrix(GF(q), AA)
    bb = vector(GF(q), bb)
    return AA.inverse() * bb

def solve_flag(S):
    flag = ""
    for i in range(32):
        A, b = send({"option": "get_flag", "index": i})
        flag += chr(b - A*S)
        print(flag)

def main():
    io.readline()
    S = solve_S()
    solve_flag(S)

if __name__ == "__main__":
    main()
