#!/usr/bin/env ruby

ASCII_CHARS = ('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a + ['+', '/']

def get_binary_string(str)
  str.split('').map { |x| "%08b" % x.ord }.join('')
end

def create_binary_array(b_str)
  b_arr = []
  for i in (0..(b_str.size - 1)).step(6) do
    b_arr.push(b_str[i..(i + 5)])
  end

  b_arr
end

def encode_binary(b_array)
  # Todo: Clean this up
  b_array.each_with_object([]) do |b, obj|
    case b.size % 6
    when 0
      obj.push(ASCII_CHARS[b.to_i(2)])
    when 2
      b += "0000"
      obj.push(ASCII_CHARS[b.to_i(2)])
      obj.push('==')
    when 4
      b += "00"
      obj.push(ASCII_CHARS[b.to_i(2)])
      obj.push("=")
    end
  end.join('')
end


abort("No input string provided") unless ARGV[0]
input_string = ARGV[0]

binary_string = get_binary_string(input_string)
binary_array = create_binary_array(binary_string)

puts encode_binary(binary_array)
