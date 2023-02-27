from requests import Session

p = 257
q = 0x10001
delta = int(round(q/p))
output_url = "https://cryptohack.org/static/challenges/output_575f13474e5a8cc76e938508bce813c2.txt"
output = Session().get(output_url).text
exec(output)
A = vector(A)
S = vector(S)
x = int((b - A*S) % q)
print(int(round(x / delta)))
