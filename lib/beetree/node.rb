module Beetree
	class Node
		include Enumerable

		def self.from_array(array)
			node = new array.shift
			until array.empty?
				node.insert array.shift
			end
			node
		end

		attr_reader :value
		attr_accessor :left, :right

		def initialize(value)
			@value = value
			#
			# NilNodes return false when you try to #insert or #include?
			#
			@left  = NilNode.new
			@right = NilNode.new
		end

		#
		# inorder_traversal
		#
		def inorder_traverse
			collection = []
			collection.push *(left.inorder_traverse) if left.value
			collection << self
			collection.push *(right.inorder_traverse) if right.value
			collection
		end
		#
		# enumerable
		#
		def each
			inorder_traverse.each do |node|
				yield(node)
			end
		end

		#
		# INSERTION:
		#
		# less than 	 -> down the left  (recurse insert or new node)
		# greater than -> down the right (recurse insert or new node)
		#
		def insert(insert_val)
			case value <=> insert_val
			when 1 
				insert_left  insert_val
			when -1
			  insert_right insert_val
			when 0
			  false
			end
		end

		#
		# SEARCH: same deal: less than goes left, greater than right,
		#         match is true, NilNode is false (not found). Perfect.
		#		
		def include?(search_val)
			case value <=> search_val
			when 1
				left.include?(search_val)
			when -1
				right.include?(search_val)
			when 0
				true
			end
		end

		#
		# accounting
		#

		def nodes_left
			return 0 unless left.value
			1 + left.nodes_left + left.nodes_right
		end

		def nodes_right
			return 0 unless right.value
			1 + right.nodes_left + right.nodes_right
		end

		def nodes_deep
		  left_deep = left.value ? 1 + left.nodes_deep : 0
			right_deep = right.value ? 1 + right.nodes_deep : 0
			left_deep > right_deep ? left_deep : right_deep
		end

		#
		# output
		#
		def inspect
			"{#{value}::#{left.inspect}|#{right.inspect}}"
		end

		private

		#
		# if there's a node there, insert the value into it
		# if it's a NilNode, it'll be false, then make a new node
		#
		def insert_left(val)
			left.insert(val) or self.left = Node.new(val)
		end

		def insert_right(val)
			right.insert(val) or self.right = Node.new(val)
		end

	end
end