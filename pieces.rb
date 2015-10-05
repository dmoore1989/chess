class Piece

  def initialize
    @value = :x
  end

  def to_s
    @value.to_s
  end

  def moves

  end

  def position
  end


end

class SlidingPiece < Piece

end

class SteppingPiece < Piece

end

class Knight < SteppingPiece
  COORDINATES = [
    [2,1], [1,2], [-1, -2], [-2, -1], [-1, 2], [-2, 1], [1, -2], [2, -1]
  ]
  def movedirs
    COORDINATES.each{ |c| }
  end

end
