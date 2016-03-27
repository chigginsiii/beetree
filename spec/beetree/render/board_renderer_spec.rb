require 'spec_helper'
require 'pp'

describe Beetree::Render::BoardRenderer do
  let(:array) { (1..20).to_a.sample(16) }
  let(:node) { Beetree::Node.from_array array }
  let(:board) { Beetree::Render::Board.new node }
  let(:renderer) { described_class.new board }

  it 'renders a board' do
    puts "ARRAY: #{array}"

    puts "NODE: #{node.inspect}"

    puts "BOARD:"
    puts board.pretty_inspect

    puts "RENDERED:"
    puts renderer.render
  end

end