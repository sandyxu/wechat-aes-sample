require "openssl"
require "digest"
require "base64"

# 解密算法如下:
# 1)对称解密使用的算法为 AES-128-CBC，数据采用PKCS#7填充。
# 2)对称解密的目标密文为 Base64_Decode(encryptedData)。
# 3)对称解密秘钥 aeskey = Base64_Decode(session_key), aeskey 是16字节。
# 4)对称解密算法初始向量 为Base64_Decode(iv)，其中iv由数据接口返回。
# decipher = OpenSSL::Cipher::AES.new(128, :CBC)
# decipher.decrypt
# decipher.key = key
# decipher.iv = iv
# plain = decipher.update(encrypted) + decipher.final

class WXBizDataCrypt
  def initialize(appid, session_key)
    @appid = appid
    @session_key = session_key
  end

  def decryptData(encryptedData, iv)
   decipher = OpenSSL::Cipher.new('AES-128-CBC')
   decipher.decrypt
   decipher.padding = 7
   decipher.key = Base64.decode64(@session_key).slice(0, 16)
   decipher.iv = Base64.decode64(iv)
   decipher.update(Base64.decode64(encryptedData)) + decipher.final
  end
end

appId = 'wx4f4bc4dec97d474b'
sessionKey = 'tiihtNczf5v6AKRyjwEUhQ=='
encryptedData = 'CiyLU1Aw2KjvrjMdj8YKliAjtP4gsMZMQmRzooG2xrDcvSnxIMXFufNstNGTyaGS9uT5geRa0W4oTOb1WT7fJlAC+oNPdbB+3hVbJSRgv+4lGOETKUQz6OYStslQ142dNCuabNPGBzlooOmB231qMM85d2/fV6ChevvXvQP8Hkue1poOFtnEtpyxVLW1zAo6/1Xx1COxFvrc2d7UL/lmHInNlxuacJXwu0fjpXfz/YqYzBIBzD6WUfTIF9GRHpOn/Hz7saL8xz+W//FRAUid1OksQaQx4CMs8LOddcQhULW4ucetDf96JcR3g0gfRK4PC7E/r7Z6xNrXd2UIeorGj5Ef7b1pJAYB6Y5anaHqZ9J6nKEBvB4DnNLIVWSgARns/8wR2SiRS7MNACwTyrGvt9ts8p12PKFdlqYTopNHR1Vf7XjfhQlVsAJdNiKdYmYVoKlaRv85IfVunYzO0IKXsyl7JCUjCpoG20f0a04COwfneQAGGwd5oa+T8yO5hzuyDb/XcxxmK01EpqOyuxINew=='
iv = 'r7BXXKkLb8qrSNn05n0qiA=='

pc = WXBizDataCrypt.new(appId, sessionKey)
puts pc.decryptData(encryptedData, iv)