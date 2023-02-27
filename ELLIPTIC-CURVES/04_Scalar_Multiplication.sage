E = EllipticCurve( GF(9739), [497, 1768] )
P = E(2339, 2213)
Q = P * 7863
Qx, Qy = Q.xy()
print("crypto{%d,%d}" % (Qx,Qy))
