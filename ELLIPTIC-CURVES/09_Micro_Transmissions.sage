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

p = 99061670249353652702595159229088680425828208953931838069069584252923270946291
a = 1
b = 4
E = EllipticCurve(GF(p), [a,b])
G = E(43190960452218023575787899214023014938926631792651638044680168600989609069200, 20971936269255296908588589778128791635639992476076894152303569022736123671173)
A = E.lift_x(87360200456784002948566700858113190957688355783112995047798140117594305287669)
B = E.lift_x(6082896373499126624029343293750138460137531774473450341235217699497602895121)

primes = [p for p, _ in E.order().factor()][:-2]
dlogs = []
for fac in primes:
    t = int(G.order()) // int(fac)
    dlog = (t*G).discrete_log(t*A)
    dlogs += [dlog]
d = crt(dlogs, primes)
shared_secret = (d*B).xy()[0]

iv = "ceb34a8c174d77136455971f08641cc5"
ciphertext = "b503bf04df71cfbd3f464aec2083e9b79c825803a4d4a43697889ad29eb75453"
print(decrypt_flag(shared_secret, iv, ciphertext))
