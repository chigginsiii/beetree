require 'spec_helper'

RSpec.describe Beetree::Node do
	let(:test_value) { 7 }
	let(:node) { described_class.new test_value}

	describe '#value' do
		it 'returns node value' do
			expect(node.value).to eq test_value
		end
	end

	[:left, :right].each do |side|
		describe "##{side}" do
			let(:test_value) { "test_#{side}" }
			it "returns the #{side} node" do
				node.instance_variable_set "@#{side}".to_sym, test_value
				expect(node.send side).to eq test_value
			end
		end

		describe "#{side}=" do
			let(:test_value) { "test_#{side}" }
			it "sets the #{side} node" do
				node.send "#{side}=".to_sym, test_value
				expect(node.send side).to eq test_value
			end
		end
	end

	describe '#insert' do
		context 'when value less than node value' do
			let(:test_insert) { 3 }

			context 'when there is a left node' do				
				let(:left_node) { Beetree::Node.new(5) }
				before { node.instance_variable_set :@left, left_node }
				it 'inserts value into left node' do
					expect(left_node).to receive(:insert).with(test_insert)
					node.insert test_insert
				end
			end

			context 'when there is no left node' do
				it 'creates a left node' do
					expect(node).to receive(:left=).with(Beetree::Node)
					node.insert test_insert
				end
			end
		end

		context 'when value greater than node value' do
			let(:test_insert) { 10 }

			context 'when there is a right node' do				
				let(:right_node) { Beetree::Node.new(8) }
				before { node.instance_variable_set :@right, right_node }
				it 'inserts value into right node' do
					expect(right_node).to receive(:insert).with(test_insert)
					node.insert test_insert
				end
			end

			context 'when there is no right node' do
				it 'creates a right node' do
					expect(node).to receive(:right=).with(Beetree::Node)
					node.insert test_insert
				end
			end
		end
	end

	describe '#include?'

	describe '#each' do
		let(:root) { described_class.new 7 }
		before do
			root.insert(3)
			root.insert(12)
			root.insert(8)
			root.insert(5)
		end
		it 'returns inorder traversed nodes' do
			expect(root.map(&:value)).to eq [3, 5, 7, 8, 12]
		end
	end

	describe '#inspect'	do
		let(:root) { described_class.new 7 }
		before do
			root.insert(3)
			root.insert(12)
			root.insert(8)
			root.insert(5)
		end
		it 'prints out tree' do
			puts root.inspect
		end
	end
end