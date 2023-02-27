from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
import hashlib

def is_pkcs7_padded(message):
    padding = message[-message[-1]:]
    return all(padding[i] == len(padding) for i in range(0, len(padding)))

def decrypt_flag(shared_secret: int, iv: str, ciphertext: str):
    # Derive AES key from shared secret
    sha1 = hashlib.sha1()
    sha1.update(str(shared_secret).encode('ascii'))
    key = sha1.digest()[:16]
    # Decrypt flag
    ciphertext = bytes.fromhex(ciphertext)
    iv = bytes.fromhex(iv)
    cipher = AES.new(key, AES.MODE_CBC, iv)
    plaintext = cipher.decrypt(ciphertext)

    if is_pkcs7_padded(plaintext):
        return unpad(plaintext, 16).decode('ascii')
    else:
        return plaintext.decode('ascii')
##############################################

p = 110791754886372871786646216601736686131457908663834453133932404548926481065303
G = (0, 11)
A = (0, 109790246752332785586117900442206937983841168568097606235725839233151034058387)
B = (0, 45290526009220141417047094490842138744068991614521518736097631206718264930032)
n_a = discrete_log(mod(A[1], p), mod(G[1], p))
shared_secret = pow(B[1], n_a, p)

iv = "31068e75b880bece9686243fa4dc67d0"
ciphertext = "e2ef82f2cde7d44e9f9810b34acc885891dad8118c1d9a07801639be0629b186dc8a192529703b2c947c20c4fe5ff2c8"
print(decrypt_flag(shared_secret, iv, ciphertext))
