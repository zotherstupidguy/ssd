require 'openssl'
require 'digest/sha1'

# Get SHA256 Hash of a file
# puts Digest::SHA256.hexdigest File.read "data.dat"
# # Get MD5 Hash of a file
# puts Digest::MD5.hexdigest File.read "data.dat"
# # Get MD5 Hash of a string
# puts Digest::SHA256.hexdigest "Hello World"
#
# # Get SHA256 Hash of a string using update
# sha256 = Digest::SHA256.new
# sha256.update "Hello"
# sha256.update " World"
# puts sha256.hexdigest

c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
c.encrypt
# your pass is what is used to encrypt/decrypt
# puts Digest::SHA256.hexdigest "Hello World"
c.key = key = Digest::SHA256.hexdigest "user_id_1232131313123131313135341"
#Digest::SHA1.hexdigest("yourpass")
c.iv = iv = c.random_iv
e = c.update("this is verylongwithmany special characters jsonfile")
e << c.final
puts "encrypted: #{e}\n"
c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
c.decrypt
c.key = key
c.iv = iv
d = c.update(e)
d << c.final
puts "decrypted: #{d}\n"
