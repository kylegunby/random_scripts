#!/usr/bin/env ruby

ASCII_CHARS = ('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a + ['+', '/']

def get_binary_string(str)
  str.split('').map { |x| "%08b" % x.ord }.join('')
end

def create_binary_array(b_str)
  current = ''
  arr = []
  for i in 0...(b_str.size) do
    # Handle the last character in the string
    if i == (b_str.size - 1)
      if i % 6 == 0
        arr.push(current)
        arr.push(b_str[i])
      else
        current += b_str[i]
        arr.push(current)
      end

      break
    end
    
    if i != 0 && i % 6 == 0
      arr.push(current)
      current = b_str[i]
    else
      current += b_str[i]
    end
  end
  
  arr
end

def encode_binary(b_array)
  # This needs to be rewritten to account for padding
  b_array.map { |c| ASCII_CHARS[c.to_i(2)] }.join('')
end

def os_endianness
  return "Big Endian" if [1].pack('I') == [1].pack("N")

  "Little Endian"
end


#abort("No input provided") unless ARGV[0]
input_string = ARGV[0] || "Kyle"

binary_string = get_binary_string(input_string)
binary_array = create_binary_array(binary_string)

print binary_array
