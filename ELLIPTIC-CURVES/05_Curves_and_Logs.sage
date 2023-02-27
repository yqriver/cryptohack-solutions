from hashlib import sha1

E = EllipticCurve( GF(9739), [497, 1768] )
QA = E(815, 3190)
S = QA * 1829
x = S.xy()[0]
hash = sha1(str(x).encode()).hexdigest()
print("crypto{%s}" % hash)
