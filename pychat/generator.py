from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5 as Cipher_pkcs1_v1_5
import base64
from Crypto import Random


# 伪随机数生成器
random_generator = Random.new().read
# rsa算法生成实例
rsa = RSA.generate(1024, random_generator)

# for master
private_pem = rsa.exportKey()
encrypt_dir = "../encrypt/"

#--------------------------生成公私钥对文件-----------------------
with open(encrypt_dir + 'master-private.pem', 'wb') as f:
    f.write(private_pem)
#    print("server::",private_pem)


public_pem = rsa.publickey().exportKey()
with open(encrypt_dir + 'master-public.pem', 'wb') as f:
    f.write(public_pem)

#---------------------------------------------------
# for ghost
private_pem = rsa.exportKey()
with open(encrypt_dir + 'client-private.pem', 'wb') as f:
    f.write(private_pem)
#    print("client::",private_pem)

public_pem = rsa.publickey().exportKey()
with open(encrypt_dir + 'client-public.pem', 'wb') as f:
    f.write(public_pem)

#-----------------------------------生成的公私钥文件类似于如下形式-------------------------------------------------------
# 私钥

def enencrypt(my_msg):
    with open(encrypt_dir + 'client-public.pem',"r") as f:
        key = f.read()
        rsakey = RSA.importKey(key)  # 导入读取到的公钥 
        cipher = Cipher_pkcs1_v1_5.new(rsakey)  # 生成对象
        cipher_text = base64.b64encode(cipher.encrypt(my_msg.encode(encoding="utf-8"))).decode("utf-8")  # 通过生成的对象加密message明文，注意，在python3中加密的数据必须是bytes类型的数据，不能是str类型的数据
#        print("cipher:",cipher_text)
        return cipher_text

def dedecrypt(cipher_text):
    with open(encrypt_dir + 'client-private.pem') as f:
        key = f.read()
#    print("private",key)
        rsakey = RSA.importKey(key)  # 导入读取到的私钥
        cipher = Cipher_pkcs1_v1_5.new(rsakey)  # 生成对象
        text = cipher.decrypt(base64.b64decode(cipher_text), "ERROR").decode("utf-8")  # 将密文解密成明文，返回的是一个bytes类型数据，需要自己转换成str
        return text

en=enencrypt("bello")
print("en:type::",type(en))
print(en)
#print("en:type::",type(enen))


