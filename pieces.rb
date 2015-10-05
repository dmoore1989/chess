class Piece
  attr_reader :board
  def initialize(board)
    @value = :x
    @board = board
  end

  def to_s
    @value.to_s
  end

  def moves

  end



end

class SlidingPiece < Piece
  def movedirs
    piece_position = board.position(self)
    move_arr = self.class::COORDINATES.map do |c|
      i = 1
      x, y = piece_position
      dx, dy = c
      [x + dx, y + dy]
    end
    valid_moves = []
    move_arr.each do |move|
      test_move = move.dup
      while board.in_bounds?(test_move) && !board.contact?(test_move)
        move << test_move
        test_move = [move[0] + dx, move[1] + dy]
      end
    end
    move
  end
end

class Queen < SlidingPiece
  COORDINATES= [
    [0,1], [1,0], [-1, 0], [-1, -1], [1, 1], [0, -1], [-1,1], [1,-1]
  ]

end

class Rook < SlidingPiece
  COORDINATES= [
    [0,1], [1,0], [-1, 0], [0, -1]
  ]
end

class Bishop < SlidingPiece
  COORDINATES= [
      [-1, -1], [1, 1],[-1,1], [1,-1]
  ]
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


end

class King < SteppingPiece
  COORDINATES= [
    [0,1], [1,0], [-1, 0], [-1, -1], [1, 1], [0, -1], [-1,1], [1,-1]
  ]
end
