#!/usr/bin/env ruby

require_relative "../lib/generate"

begin
  SilverStripeDocset::Generate.new(ARGV).run()
rescue Errno::ENOENT => err
  abort "SilverStripeDocset: #{err.message}"
end