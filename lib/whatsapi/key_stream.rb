require 'openssl'
module Whatsapi
	class KeyStream
		AUTH_METHOD = "WAUTH-2"
		DROP = 768

		def initialize(key, mac_key)
			@rc4 = Rc4.new(key, DROP)
			@mac_key = mac_key			
		end

		def self.generate_keys(password, nonce)
			arr = ["key", "key", "key", "key"]
			arr2 = [1, 2 ,3 , 4]
			nonce += "0"
			
			arr.each_with_index do |elem, idx|
				nonce[nonce.length -1] = arr2[idx].chr()
				foo = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, nonce, 2, 20)
				arr[idx] = foo
			end
			arr
		end

		def decode_message buffer, macOffset, offset, length
			mac = KeyStream.compute_mac buffer, offset, length
			4.times do
				i = 1
				foo = (buffer[macOffset + i]).ord
				bar = mac[i].ord
				if foo != bar
					raise "MAC mismatch: #{foo != bar}"
				end
				i += 1
			end
			OpenSSL::Cipher::RC4.new(buffer, offset, length)
		end

		def encode_message buffer, macOffset, offset, length
			data = OpenSSL::Cipher::RC4.new(buffer, offset, length)
			mac = KeyStream.compute_mac date, offset, length
			str[start, length]
			data[0, macOffset] + mac[0, 4] + data[macOffset + 4]
		end

		private

			def self.compute_mac
				#         $hmac = hash_init("sha1", HASH_HMAC, $this->macKey);
				#         hash_update($hmac, substr($buffer, $offset, $length));
				#         $array = chr($this->seq >> 24)
				#             . chr($this->seq >> 16)
				#             . chr($this->seq >> 8)
				#             . chr($this->seq);
				#         hash_update($hmac, $array);
				#         $this->seq++;
				#         return hash_final($hmac, true);
				#     }
				
			end
	end
end


# class KeyStream {
#     public static $AuthMethod = "WAUTH-2";
#     const DROP = 768;
#     private $rc4;
#     private $seq;
#     private $macKey;

#     public function __construct($key, $macKey)
#     {
#         $this->rc4 = new rc4($key, self::DROP);
#         $this->macKey = $macKey;
#     }

#     public static function GenerateKeys($password, $nonce)
#     {
#         $array = array(
#             "key",//placeholders
#             "key",
#             "key",
#             "key"
#         );
#         $array2 = array(1, 2, 3, 4);
#         $nonce .= '0';
#         for($j = 0; $j < count($array); $j++)
#         {
#             $nonce[(strlen($nonce) - 1)] = chr($array2[$j]);
#             $foo = wa_pbkdf2("sha1", $password, $nonce, 2, 20, true);
#             $array[$j] = $foo;
#         }
#         return $array;
#     }

#     public function DecodeMessage($buffer, $macOffset, $offset, $length)
#     {
#         $mac = $this->computeMac($buffer, $offset, $length);
#         # validate mac
#         for($i = 0; $i < 4; $i++)
#         {
#             $foo = ord($buffer[$macOffset + $i]);
#             $bar = ord($mac[$i]);
#             if($foo !== $bar)
#             {
#                 throw new Exception("MAC mismatch: $foo != $bar");
#             }
#         }
#         return $this->rc4->cipher($buffer, $offset, $length);
#     }

#     public function EncodeMessage($buffer, $macOffset, $offset, $length)
#     {
#         $data = $this->rc4->cipher($buffer, $offset, $length);
#         $mac = $this->computeMac($data, $offset, $length);
#         return substr($data, 0, $macOffset).substr($mac, 0, 4).substr($data, $macOffset + 4);
#     }

#     private function computeMac($buffer, $offset, $length)
#     {
#         $hmac = hash_init("sha1", HASH_HMAC, $this->macKey);
#         hash_update($hmac, substr($buffer, $offset, $length));
#         $array = chr($this->seq >> 24)
#             . chr($this->seq >> 16)
#             . chr($this->seq >> 8)
#             . chr($this->seq);
#         hash_update($hmac, $array);
#         $this->seq++;
#         return hash_final($hmac, true);
#     }
# }