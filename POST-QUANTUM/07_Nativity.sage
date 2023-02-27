from requests import Session
import numpy as np

def decrypt(sk, c):
    return sk.dot(c) & 1

def readlines(URL):
    return Session().get(URL).text.strip().split("\n")

public_key_URL = "https://cryptohack.org/static/challenges/public_key_dbd7dcf356ea5c595d390470faad2c29.txt"
ciphertexts_URL = "https://cryptohack.org/static/challenges/ciphertexts_453500a870e03399fe8e5ed3674b6030.txt"

pk = [[int(x) for x in line.split()] for line in readlines(public_key_URL)]
ct = [np.array([int(x) for x in line.split()]) for line in readlines(ciphertexts_URL)]
sk = np.array([int(i) for i in Matrix(GF(2), pk).left_kernel()[1]])
msg = [str(decrypt(sk, c)) for c in ct]
print(bytes.fromhex(hex(int("".join(msg), 2))[2:]).decode())
