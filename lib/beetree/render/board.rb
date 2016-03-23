module Beetree
  module Render
    class Board
      attr_reader :root, :num_rows, :num_cols

      def initialize(root_node)
        @root = root_node
        setup_board
      end

      def board
        @board ||= Array.new(num_rows) { Array.new(num_cols) }
      end

      def inspect
        format = "|"
        format += "%10s|" * num_cols
        lines = board.map do |row|
          values = row.map {|cell| cell.nil? ? '.   ' : cell.inspect }
          sprintf(format, *values)
        end
        lines.join("\n")
      end

      private

      def num_rows
        @num_rows ||= 1 + root.nodes_deep
      end

      def num_cols
        @num_cols ||= 1 + root.nodes_right + root.nodes_left
      end

      def root_col
        # number of nodes left, +1 (root), -1 (index)
        root.nodes_left
      end

      def setup_board
        root_cell = Cell.new(root, row: 0, col: root_col)
        insert(root_cell)
      end

      def insert(cell)
        # is there an ancestor?
        ancestor_row = ancestor_row_index(cell)

        if ancestor_row 
          # which side of root node are we on?
          left_side_of_root = cell.value < root.value ? true : false
          # which side of parent are we on?
          left_side_of_parent = board[cell.up][cell.right] ? true : false

          case
          # left-of-root,left-of-parent:
          when left_side_of_root && left_side_of_parent
            # shift ancestor left
            shift_cols(cell.col, :left)
          # left-of-root,right-of-parent:
          when left_side_of_root && !left_side_of_parent
            # shift parent left, place right of new parent col
            cell.move_left
            shift_cols(cell.col, :left)
          # right-of-root, left-of-parent:
          when !left_side_of_root && left_side_of_parent 
            # shift parent right, place left of new parent col
            cell.move_right
            shift_cols(cell.col, :right)
          # right-of-root, right-of-parent:
          when !left_side_of_root && !left_side_of_parent 
            # shift ancestor right, place right of parent
            shift_cols(cell.col, :right)
          end
        end

        board[cell.row][cell.col] = cell
        node = cell.node

        if node.left.value
          insert(Cell.new(node.left, row: cell.row+1, col: cell.col-1))
        end

        if node.right.value
          insert(Cell.new(node.right, row: cell.row+1, col: cell.col+1))
        end
      end

      def ancestor_row_index(cell)
        # any non-nil/false in 'col_i' above 'row_i'
        rows_to_search = (cell.up).downto(0)
        rows_to_search.find do |row|
          board[row][cell.col]
        end
      end

      def shift_cols(from_col, direction)
        # shift all cells from from_col to to_col
        # where to_col is the next-to-last row.
        cols = direction == :left ? (1..from_col).to_a : (from_col..num_cols-2).to_a
        # every row:
        board[1..-1].each do |row|
          cells = cols.map{ |col| row[col] }.reject(&:nil?)
          cells.each do |cell|
            move_cell(cell, direction)
          end
        end
      end

      def shift_cols_left(col_max)
        # every row:
        board[1..-1].each do |row|
          # cells from this col left, except for first col
          cells = row[1..col_max].reject(&:nil?).reverse
          cells.each do |cell|
            move_cell(cell, :left)
          end
        end
      end

      def shift_cols_right(col_min)
        # every row:
        board[1..-1].each do |row|
          # cells from this col right, except for last col
          cells = row[col_min..num_cols-2].reject(&:nil?)
          cells.each do |cell|
            move_cell(cell, :right)
          end
        end
      end

      def move_cell(cell, direction)
        board[cell.row][cell.col] = nil
        cell.send "move_#{direction}".to_sym
        board[cell.row][cell.col] = cell
      end
    end
  end
end