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

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def start_test(start)
    raise ChessError.new "No piece at start point" if self[start].nil?
  end

  def end_test(end_pos)
    raise ChessError.new "End position is off the board" if end_pos.any?{ |pos| pos > 7 || pos < 0 }
    raise ChessError.new "Position has your own piece" if self[end_pos].is_a?(Piece)
  end

  def move(start, end_pos)
    start_test(start)
    end_test(end_pos)
    rescue ChessError => e
      puts e.message
      #retry
  end

end
