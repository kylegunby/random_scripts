#!/usr/bin/env ruby

class B64
  ASCII_CHARS = ('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a + ['+', '/']
  BIT_LENGTH = 6
  
  def self.encode(str)
    new(str).encode
  end

  def initialize(str)
    @str = str
  end

  def encode
    binary_array.each_with_object([]) do |b, obj|
      padding = ((BIT_LENGTH - b.size) % BIT_LENGTH) % BIT_LENGTH
      b += ("0" * padding)
      char = ASCII_CHARS[b.to_i(2)].to_s + ("=" * (padding / 2))
      obj.push(char)
    end.join('')
  end

  private

  def binary_string
    @binary_string ||= @str.split('').map { |x| "%08b" % x.ord }.join('')
  end

  def binary_array
    @binary_array ||= build_binary_array
  end
      
  def build_binary_array
    (0...binary_string.size).step(BIT_LENGTH).each_with_object([]) do |i, obj|
      obj.push(binary_string[i..(i + 5)])
    end
  end
end

abort("No input string provided") unless ARGV[0]
input_string = ARGV[0]

puts B64.encode(input_string)
