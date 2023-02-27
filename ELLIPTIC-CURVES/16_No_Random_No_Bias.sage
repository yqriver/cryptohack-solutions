from hashlib import sha1
from ecdsa.ecdsa import curve_256, generator_256
from ecdsa import ellipticcurve
from Crypto.Util.number import long_to_bytes

m1 = b'I have hidden the secret flag as a point of an elliptic curve using my private key.'
m2 = b'The discrete logarithm problem is very hard to solve, so it will remain a secret forever.'
m3 = b'Good luck!'
h1 = int(sha1(m1).hexdigest(), 16)
h2 = int(sha1(m2).hexdigest(), 16)
h3 = int(sha1(m3).hexdigest(), 16)
r1 = 0x91f66ac7557233b41b3044ab9daf0ad891a8ffcaf99820c3cd8a44fc709ed3ae
r2 = 0xe8875e56b79956d446d24f06604b7705905edac466d5469f815547dea7a3171c
r3 = 0x566ce1db407edae4f32a20defc381f7efb63f712493c3106cf8e85f464351ca6
s1 = 0x1dd0a378454692eb4ad68c86732404af3e73c6bf23a8ecc5449500fcab05208d
s2 = 0x582ecf967e0e3acf5e3853dbe65a84ba59c3ec8a43951bcff08c64cb614023f8
s3 = 0x9e4304a36d2c83ef94e19a60fb98f659fa874bfb999712ceb58382e2ccda26ba

G = generator_256
q = int(G.order()) 
B = 2**160 

def make_matrix():
    t1 = r1 * pow(s1, -1, q)
    t2 = r2 * pow(s2, -1, q)
    t3 = r3 * pow(s3, -1, q)

    a1 = h1 * pow(s1, -1, q)
    a2 = h2 * pow(s2, -1, q)
    a3 = h3 * pow(s3, -1, q)

    basis = [ [q,           0,           0,            0,                  0],
              [0,           q,           0,            0,                  0],
              [0,           0,           q,            0,                  0],
              [t1,          t2,          t3,           (2**160) / q,       0],
              [a1,          a2,          a3,           0,             2**160]
             ]
    return Matrix(QQ, basis)

def attack():
    M = make_matrix()
    k = M.LLL()[1][0]
    d = (s1*Mod(k, q) - h1) * pow(r1, -1, q)
    return d

d = attack()
T = (16807196250009982482930925323199249441776811719221084165690521045921016398804, 72892323560996016030675756815328265928288098939353836408589138718802282948311)
Q = ellipticcurve.Point(curve_256, T[0], T[1]) * int(pow(d,-1,q))
flag = long_to_bytes(Q.x())
print(flag.decode())
