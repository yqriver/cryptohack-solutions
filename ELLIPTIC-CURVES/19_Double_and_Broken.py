from Crypto.Util.number import long_to_bytes
from requests import get
import numpy as np

url = "https://cryptohack.org/static/challenges/collected_data_3b1eecad8d7b9a4e92b93efcdbf8113b.txt"
collected_data = eval(get(url).text)
data = np.array(collected_data).mean(axis=0, dtype=int)[::-1]
bits = [ '1' if i > np.mean(data) else '0' for i in data ]
print(long_to_bytes(int(''.join(bits), 2)))
