#!/usr/bin/env ruby

require_relative "../lib/ring"

username = "CHANGEME"
password = "CHANGEME"

ring = Ring.new(username: username, password: password)
ring.authenticate

puts ring.dings
puts ring.devices
