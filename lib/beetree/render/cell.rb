module Beetree
  module Render
    class Cell
      attr_reader :node, :row, :col
      def initialize(node, row:, col:)
        @node  = node
        @row   = row
        @col   = col
      end

      def value
        node.value
      end

      def render
        "[ #{node.value} ]"
      end

      def width
        render.length
      end

      # position query

      def right
        @col + 1
      end

      def left
        @col - 1
      end

      def up
        @row - 1
      end

      def down
        @row + 1
      end

      # position command

      def move_left
        @col -= 1
      end

      def move_right
        @col += 1
      end

      # debug

      def inspect
        "#{value} (#{row},#{col})"
      end
    end
  end
end