require 'delegate'

module Beetree
	module Render
		class BoardRenderer
			attr_reader :board

			def initialize(board)
				@board = board.board
			end

			def render
				node_lines = render_node_lines
				path_lines = render_path_lines

				node_lines.zip(path_lines).join("\n")
			end

			def render_node_lines
				lines = []
				each_row do |row|
					cells = row.map { |c| c.nil? ? '' : c.render }
					lines << sprintf(row_format, *cells)
				end
				lines
			end

			def render_path_lines

				path_rows = []

				# start with the descenders from the nodes...
				each_row do |row|
					path_cells = []
					row.each do |cell|
						if cell.nil?
							path_cells << '' 
						else
							descenders = ' ' * column_widths[cell.col]
							descenders[0] = "/"   if cell.node.left.value
							descenders[-1] = '\\' if cell.node.right.value
							path_cells << descenders
						end
					end
					path_rows << path_cells
				end

				# then fill in the lines that run between...
				each_row do |row|
					row.reject(&:nil?).each do |parent|

						# LEFT:
						left_child = find_left_child(parent)
						# no lines necessary
						if left_child && !(left_child.right == parent.col)
						 	cols_to_fill = (parent.left).downto(left_child.right)
						 	cols_to_fill.each do |col_to_fill|
							  line = '_' * column_widths[col_to_fill]
						    path_rows[parent.row][col_to_fill] = line
						  end
						end

						# RIGHT:
						right_child = find_right_child(parent)
						# no lines necessary
						if right_child && !(right_child.left == parent.col)
						 	cols_to_fill = (parent.right).upto(right_child.left)
						 	cols_to_fill.each do |col_to_fill|
							  line = '_' * column_widths[col_to_fill]
						    path_rows[parent.row][col_to_fill] = line
						  end
						end
					end
				end

				path_rows.map{|row| sprintf(row_format, *row)}

			end

			private

			def each_row
				@board.each do |row|
					yield row
				end
			end

			def find_left_child(parent)
				# no left child if no left child
				return unless parent.node.left.value
				child_row     = parent.down
				child_col_min = parent.left
				row = board[child_row]
				search = row[0..child_col_min].reverse
				search.find{|cell| !cell.nil?}
			end

			def find_right_child(parent)
				# no left child if no left child
				return unless parent.node.right.value
				child_row     = parent.down
				child_col_max = parent.right
				row = board[child_row]
				search = row[child_col_max..-1]
				search.find{|cell| !cell.nil?}
			end

			def column_widths
				@col_widths ||= find_column_widths
			end

			def row_format
				@row_format ||= column_widths.map {|width| "%#{width}s"}.join
			end

			def find_column_widths
				widths = []
				each_row do |row|
					row.select {|cell| !cell.nil? }.each do |cell|
						widths[cell.col] = cell.width
					end
				end
				widths
			end
		end
	end
end