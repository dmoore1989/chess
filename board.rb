class Board
  def initialize
    @grid = Array.new(8){ Array.new(8) }
    place_pieces
  end

  def place_pieces
    @grid.each_with_index |row, i|
      if i < 2 || i > 5
        row.each{ |el| @grid << Piece.new }
      end
    end
  end

  class ChessError << StandardError
  end

  def [](pos)
    x, y = pos
    @grid[x][y] 
  end

  def start_test(start)
    raise ChessError.new "No piece at start point" if
  end

  def move(start, end)

  end

end
