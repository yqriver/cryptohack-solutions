import requests
url = "https://web.cryptohack.org/digestive/"

def sign(username):
    return requests.get(url + "/sign/" + username).json()

def verify(msg, signature):
    return requests.get(url + "/verify/" + msg + "/" + signature).text

print(verify('{"admin": false, "username": "user", "admin":true}', sign("user")["signature"]))
