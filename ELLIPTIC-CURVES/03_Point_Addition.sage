E = EllipticCurve( GF(9739), [497, 1768] )
P = E(493, 5564)
Q = E(1539, 4742)
R = E(4403,5202) 
S = P + P + Q + R
Sx, Sy = S.xy()
print("crypto{%d,%d}" % (Sx,Sy))
