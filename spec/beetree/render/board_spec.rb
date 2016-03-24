require 'spec_helper'
require 'pp'

describe Beetree::Render::Board do
  let(:array) { [7, 2, 5, 8, 12, 18, 11, 6, 9, 19, 14, 4, 10, 3, 1, 17] }
  let(:node) { Beetree::Node.from_array(array) }
  let(:board) { described_class.new node}

  it 'makes a board' do
    puts board.inspect
  end

end

=begin
 
putting the graph lines into the beetree render:

  0 1 2 3 4 5
0 . . . 4 . .
1 . 2 . . . .
2 . . 3 . . .

       400
       / \______
     32         54
    /
  25

- make a new board, with each row representing the graphs from the row above to the row below
- the first row then is the paths connecting the root to its children:
  - if there's a left child:
    - look one row down, first non-empty col on the left: LEFT CHILD
    - if left child is cell-1, should be able to just put down the slash
    - if left child is farther than cell-1:
      - the cells between cell and left child will connect the nodes with a line

  - applying the slash:
    - start with space as wide as this cell's column
    - if left node, replace char[0] with '/'
    - if right node, replace char[-1] with '\'
    - put it into the row[0] paths at the parent cell column

  - applying the trees:
    - for each cell between the parent and child:
      - make an underbar from the width: '_' * column_width[col_i]
      - put it in this cell for rendering

  NOTE: HEY could totally use something like PathCell 
        to render the '_______' '/    \' '___' stuff.

=end