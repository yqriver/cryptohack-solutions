from pwn import remote
from json import loads, dumps
from tqdm import tqdm

io = remote("socket.cryptohack.org", "13412")
p = 257
q = 6007
delta = int(round(q/p))

def send(data):
    io.sendline(dumps(data).encode())
    recv = loads(io.readline())
    A, b = eval(recv["A"]), eval(recv["b"])
    return vector(A), b

def solve_S():
    AA = []
    bb = []
    for _ in tqdm(range(512)):
        A, b = send({"option": "encrypt", "message": "0"})
        AA.append(A)
        bb.append(b)
    AA = Matrix(AA)
    bb = vector(bb)
    M = (identity_matrix(512).augment(AA.transpose())).stack(vector([0]*512 + list(-bb)))  
    M = M.LLL()
    S = M[-1][:512]
    return S

def solve_flag(S):
    flag = ""
    for i in range(46):
        A, b = send({"option": "get_flag", "index": i})
        x = int((b - A*vector(S)))
        flag += chr(int(round(x / delta)))
        print(flag)

def main():
    io.readline()
    S = solve_S()
    solve_flag(S)

if __name__ == "__main__":
    main()
