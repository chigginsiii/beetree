require 'delegate'

module Beetree
	module Render
		class BoardRenderer
			attr_reader :board

			def initialize(board)
				@board = board.board
			end

			def render
				lines = []
				each_row do |row|
					cells = row.map { |c| c.nil? ? '' : c.render }
					lines << sprintf(row_format, *cells)
				end
				lines.join("\n")
			end

			private

			def each_row
				@board.each do |row|
					yield row
				end
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