require 'delegate'

module Beetree
	class Render
		attr_reader :node

		def initialize(node, level=1)
			@node = node
			@level = level
		end

		def render
			"#{render_value}\n
			#{render_children}"
		end

		def render_value
			@value_rendered ||= "level #{@level}: [#{node.value}]"
		end

		def render_left
			@left_rendered ||= node.left ? Render.new(node.left, @level + 1).render : ''
		end

		def render_right
			@right_rendered ||= node.right ? Render.new(node.right, @level + 1).render : ''
		end

		def render_children
			[render_left, render_right].join(' ')
		end

		# rendered value: [value]

		# rendered child: node ? node.val : nil

    #      __[687]__
		#     /         \
		#   [40]       [898]
		#   /  \      /    \
		# [3] [589] [776] [900]
		#

	end
end