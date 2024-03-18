#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'socket'
require 'ipaddr'

# Ideas: 
#  - Support for domain name to ip resolution
#     Example: ip-convert google.com -f hybrid #=> 0330.0072.0327.0116
#  - hybrid format specification
#     Example: ip-convert 216.58.215.78 --hybrid-format=dword.octal.decimal.decimal
#     The way format is expressed is TBD 

FORMAT_ALIASES = {
  "h": "hybrid",
  "o": "octal",
  "w": "dword",
  "x": "hex",
  "d": "decimal"
}

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: ip-convert ip [options]'
  format_list = FORMAT_ALIASES.map { |k, v| [v, k.to_s] }.flatten

  opts.on('-f', '--format [FORMAT]', 'Specify output format', "#{format_list}") do |o|
    
    abort("Invalid format option - '#{o}'\nExpected one of #{format_list}") unless format_list.include? o
    options[:format] = o
  end

  opts.on('-i', '--ip [ip address]', 'Specify ipv4 address to be converted') do |o|
    
    ip = IPAddr.new(o)
    options[:ip] = ip.to_s
  rescue IPAddr::InvalidAddressError
    abort('Invalid IP address')
  end


  opts.on('-h', '--host [hostname]', 'Specify hostname to be converted', 'example.com, www.example.com') do |o|

    ip = IPSocket.getaddress(o)
    options[:hostname] = o
    options[:ip] = ip
  rescue SocketError
    abort('Hostname not found. Check the spelling, or make sure it\'s in use')
  end
end.parse!


class Converter
  def initialize(options)
    @ip_arr = options[:ip].split('.').map { |x| x.to_i }
    @options = options
    @conversions = {
      'hex': [],
      'dword': '',
      'decimal': '',
      'octal': [],
      'hybrid': []
    }
  end

  def message
    build_message
  end

  private

  def build_message
    if @options[:format]
      case @options[:format]
      when 'hex', 'x'
        hex_convert
        return @conversions[:hex].map { |x| "#{x}\n"}
      when 'dword', 'w'
        dword_convert
        return @conversions[:dword]
      when 'octal', 'o'
        octal_convert
        return @conversions[:octal].map { |x| "#{x}\n"}
      when 'decimal', 'd'
        return decimal_convert
      end
    end

    convert

    target = @options[:hostname] ? @options[:hostname] : @options[:ip]

    message = "\nShowing results for #{target}\n\n"

    if @options[:hostname]
      message += "Decimal\n#{'-' * 25}\n"
      message += "#{@options[:ip]}\n\n"
    end

    message += "Hex\n#{'-' * 25}\n"
    message += "#{@conversions[:hex].map { |x| x }.join("\n")}"
    message += "\n\n"

    message += "Dword\n#{'-' * 25}\n"
    message += "#{@conversions[:dword]}"
    message += "\n\n"

    message += "Octal\n#{'-' * 25}\n"
    message += "#{@conversions[:octal].map { |x| x }.join("\n")}"
    message += "\n\n"

    message
  end

  def convert
    hex_convert
    octal_convert
    dword_convert
    #hybrid_convert
  end

  def hex_convert
    hex_arr = @ip_arr.map { |x| x.to_s(16) }
    @conversions[:hex].push(hex_arr.map { |x| "0x#{x}" }.join('.'))
    @conversions[:hex].push("0x#{hex_arr.join('')}")
  end

  def octal_convert
    octal_arr = @ip_arr.map { |x| x.to_s(8) }
    @conversions[:octal].push(octal_arr.join('.'))
    @conversions[:octal].push(octal_arr.map { |x| x.rjust(10, "0") }.join('.'))
  end
  
  def dword_convert
    @conversions[:dword] = @ip_arr.map { |x| "%08b" % x }.join('').to_i(2)
  end
  
  def hybrid_convert
    'Not implemented'
  end

  def decimal_convert
    # Currently only returns ipv4 address if hostname is given
    @options[:ip]
  end
end

abort("No IP address provided") unless options.has_key? :ip

con = Converter.new(options)
puts con.message
