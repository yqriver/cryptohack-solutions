E = EllipticCurve(GF(2**255-19), [0,486662,0,1,0])
G = E.lift_x(9)
Q = G * 0x1337c0decafe
print("crypto{%d}" % Q.xy()[0])
