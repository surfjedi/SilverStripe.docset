#!/usr/bin/env ruby
#/ Usage: <progname> [options]...
#/	--use-working Use the current working directory contents rather than refetch
require 'optparse'
require_relative "../lib/generate"

options = {}
options[:use_working] = false

file = __FILE__

ARGV.options do |opts|
  opts.on("-w", "--use-working") do |v|
  	options[:use_working] = v
  end
end.parse!

begin
  SilverStripeDocset::Generate.new(options).run()
rescue Errno::ENOENT => err
  abort "SilverStripeDocset: #{err.message}"
end