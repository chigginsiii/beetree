module Beetree
	class Node
		include Enumerable

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
		# INSERTION:
		#
		# less than 	 == down the left  (recurse insert or new node)
		# greater than == down the right (recurse insert or new node)
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