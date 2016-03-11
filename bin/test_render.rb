#!/usr/bin/env ruby

require 'bundler/setup'
require 'beetree'

node = Beetree::Node.new(50)

(1..100).to_a.shuffle.shuffle.take(32).each do |num|
  node.insert(num)
end

render = Beetree::Render.new node

puts "loaded with 'node' and 'render'"
Pry.start
