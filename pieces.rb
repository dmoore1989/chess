
require 'byebug'

class Piece
  attr_reader :board
  def initialize(board, color)
    @value = :x
    @board = board
    @color = color
  end

  def to_s
    @value.to_s
  end

  def moves

  end



end

class SlidingPiece < Piece
  def movedirs
    x, y = board.position(self)
    valid_moves = []
    self.class::COORDINATES.each do |change|
      dx, dy = change
      test_move = [x + dx, y + dy]
      # byebug
      while board.in_bounds?(test_move) && !board.contact?(test_move)
        valid_moves << test_move
        x, y = test_move
        test_move = [x + dx, y + dy]
      end
    end
    valid_moves
  end

  def move
    movedirs
  end

end



class Queen < SlidingPiece
  COORDINATES= [
    [0,1], [1,0], [-1, 0], [-1, -1], [1, 1], [0, -1], [-1,1], [1,-1]
  ]

  def initialize(board,color)
    super(board,color)
    @value = :q
  end


end

class Rook < SlidingPiece
  COORDINATES= [
    [0,1], [1,0], [-1, 0], [0, -1]
  ]

  def initialize(board,color)
    super(board,color)
    @value = :r
  end

end

class Bishop < SlidingPiece
  COORDINATES= [
      [-1, -1], [1, 1],[-1,1], [1,-1]
  ]

  def initialize(board,color)
    super(board,color)
    @value = :b
  end

end

class SteppingPiece < Piece
  def movedirs
    piece_position = board.position(self)
    self.class::COORDINATES.map do |c|
      x, y = piece_position
      dx, dy = c
      [x + dx, y + dy]
    end
  end

  def moves
    move_arr = movedirs
    move_arr.select{|move| board.in_bounds?(move) && !board.contact?(move) }
  end
end

class Knight < SteppingPiece
  COORDINATES = [
    [2,1], [1,2], [-1, -2], [-2, -1], [-1, 2], [-2, 1], [1, -2], [2, -1]
  ]
  def initialize(board,color)
    super(board,color)
    @value = :kn
  end

end

class King < SteppingPiece
  COORDINATES= [
    [0,1], [1,0], [-1, 0], [-1, -1], [1, 1], [0, -1], [-1,1], [1,-1]
  ]
  def initialize(board,color)
    super(board,color)
    @value = :k
  end
end

class Pawn < Piece

  def initialize(board,color)
    super(board,color)
    @value = :p
  end

  def moves
    x, y = board.position(self)
    if self.color == :red
      [x-1, y]
    else
      [x+1, y]
    end
  end
end
