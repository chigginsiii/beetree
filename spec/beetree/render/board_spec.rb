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
 
part of the problem is the order of the swapping/placing.

so this should shift the '2' (parent node) and everything under it left

.    .    .    7    .
.    .    2    .    .
.    1    .    5    .

NEW ORDER:
- want to place '5' right of parent '2'
- there is an acestor above that spot, the 7 which does not move.
- move everything from parent-left one space left
- decrement the parent's col
- insert the '5' one row down, one col right

but this should push the '1' (ancestor node) in row 3 left:

  .    .    .    .    .    7 
  .    .    .    2    .    . 
  .    1    .    .    5    . 
  .    .    4    .    .    . 
  .    3    .    .    .    . 

So the problem is that the value's already been placed. if it went
like this instead:

- want to place the 3 left of 4
- ancestor is above...
- PARENT CANNOT MOVE RIGHT, as we are left of the root!
- ANCESTOR/CHILDREN must move left one col
- '3' may now be placed one row below, one col left of '4' (parent)


My guess is that this is reflected on the right side. So:

LEFT OF ROOT:
- left hand inserts 
  - move the ancestor left
  - inserts val one left of cur parent col
- right hand inserts
  - move the parent left
  - insert val one right of new parent col

RIGHT OF ROOT: etc, etc
- left hand inserts 
  - move the parent right
  - insert val one left of new parent col
- right hand inserts
  - move the ancestor right
  - inserts val one right of cur parent col


=end