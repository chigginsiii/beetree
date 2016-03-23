require 'spec_helper'

describe Beetree::Render do
  let(:random_array) { (1..50).to_a.sample(20) }
  let(:root) { Beetree::Node.from_array random_array }
  let(:renderer) { Beetree::Render.new root }


end