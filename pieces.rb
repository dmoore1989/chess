
require 'byebug'

class Piece
  attr_reader :board, :color
  def initialize(board, color)
    @value = :x
    @board = board
    @color = color
  end

  def to_s
    case @value
    when :k
      "\u2654".colorize(color)
    when :q
      "\u2655".colorize(color)
    when :r
      "\u2656".colorize(color)
    when :b
      "\u2657".colorize(color)
    when :kn
      "\u2658".colorize(color)
    when :p
      "\u2659".colorize(color)
    end
  end

  def valid_moves

    valid_moves = []
    start = board.position(self)
    test_moves = self.moves
    test_moves.each do |move|
      dup_board = board.dup
      dup_board.move!(start, move)
      valid_moves << move unless dup_board.in_check?(color)
    end
    valid_moves
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
      while board.in_bounds?(test_move) && !board.contact?(self, test_move)
        valid_moves << test_move
        break if board[test_move].is_a?(Piece) && board[test_move].color != self.color
        x, y = test_move
        test_move = [x + dx, y + dy]
      end
      x, y = board.position(self)
    end
    valid_moves
  end

  def moves
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
    move_arr.select{|move| board.in_bounds?(move) && !board.contact?(self, move) }
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
    moves = []
    x, y = board.position(self)
    if self.color == :red && !board.contact?(self, [x + 1, y])
      moves << [x+1, y]
    elsif !board.contact?(self, [x-1, y])
      moves << [x-1, y]
    end
    [[ 1, 1], [1, -1]].each do |pos|
      dx, dy = pos
      if (self.color == :red) && board[[x + dx , y + dy] ].is_a?(Piece) && board[[x + dx , y + dy]].color != self.color && @board.in_bounds?([x + dx, y + dy])
        moves << [x + dx , y + dy]
      end
    end
    [[ -1, 1], [-1, -1]].each do |pos|
      dx, dy = pos
      if board[[x + dx , y + dy ]].is_a?(Piece) && board[[x + dx , y + dy]].color != self.color && @board.in_bounds?([x + dx, y + dy])
        moves << [x + dx , y + dy]
      end
    end

    moves
  end
end
