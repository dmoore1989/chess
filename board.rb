require_relative 'pieces'
require 'byebug'

class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8){ Array.new(8) }
    place_pieces
  end

  def place_pieces
    #byebug
    @grid.each_with_index do |row, i|
      if i < 2 || i > 5
        row.map!{ |el| el = Queen.new(self) }
        
      end
    end
  end

  class ChessError < StandardError
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def in_bounds?(pos)
    pos.none?{ |el| el > 7 || el < 0}
  end

  def contact?(pos)
    self[pos].is_a?(Piece)
  end

  def start_test(start)
    raise ChessError.new "No piece at start point" if self[start].nil?
  end

  def end_test(end_pos)
    raise ChessError.new "End position is off the board" if !in_bounds?(end_pos)
    raise ChessError.new "Position has your own piece" if self[end_pos].is_a?(Piece)
  end

  def move(start, end_pos)
    begin
      start_test(start)
      end_test(end_pos)
      rescue ChessError => e
        puts e.message
        return nil
      end
      move = self[start]
      self[start] = nil
      self[end_pos] = move
  end

  def position(piece)
    @grid.each_with_index do |row, i|
      row.each_with_index do |item, j|
        return [i,j] if item == piece
      end
    end
  end

  def in_check(color)
    position = find_king(color)
    opposing_pieces = find_opposing_pieces(color)
    opposing_pieces.each do |piece|
      return true if piece.moves.include?(position)
    end
    false
  end

  def find_king(color)
    @grid.each_with_index do |row, i|
      row.each_with_index do |item, j|
        if item.is_a?(King) && item.color == color
          return [i, j]
        end
      end
    end
  end

  def find_opposing_pieces(color)
    pieces = []
    @grid.each_with_index do |row, i|
      row.each_with_index do |item, j|
        if item.is_a?(Piece) && item.color != color
          pieces << item
        end
      end
    end
    return pieces
  end

end
