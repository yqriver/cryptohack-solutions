E = EllipticCurve(GF(9739), [497, 1768])
P = E(8045,6936)
Q = -P
Qx, Qy = Q.xy()
print("crypto{%d,%d}" % (Qx,Qy))
