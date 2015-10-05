require_relative 'pieces'
require 'byebug'

class Board
  RED_ORIGINAL_POSITIONS = {
  7 => Rook.new(self, :red),
  6 => Knight.new(self,:red),
  5 => Bishop.new(self, :red),
  4 => King.new(self, :red),
  3 => Queen.new(self, :red),
  2 => Bishop.new(self, :red),
  1 => Knight.new(self, :red),
  0 => Rook.new(self,:red)
  }
  BLACK_ORIGINAL_POSITIONS = {
  7 => Rook.new(self, :black),
  6 => Knight.new(self,:black),
  5 => Bishop.new(self, :black),
  4 => King.new(self, :black),
  3 => Queen.new(self, :black),
  2 => Bishop.new(self, :black),
  1 => Knight.new(self, :black),
  0 => Rook.new(self,:black)
  }

  attr_accessor :grid

  def initialize(new_game = true)
    @grid = Array.new(8){ Array.new(8) }
    place_pieces if new_game
  end

  def checked_king
    @grid[1][1] = King.new(self,:black)
    @grid[2][2] = Queen.new(self,:red)
  end

  def place_pieces
    #byebug
    @grid.each_with_index do |row, i|
      if i == 1
        row.map!{ |el| el = Pawn.new(self, :red) }
      elsif i == 6
        row.map!{ |el| el = Pawn.new(self, :black) }
      elsif i == 0
        row.each_with_index do |el, j|
          @grid[i][j] = RED_ORIGINAL_POSITIONS[j]
        end
      elsif i == 7
        row.each_with_index do |el, j|
          @grid[i][j] = BLACK_ORIGINAL_POSITIONS[j]
        end
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

  def contact?(piece, pos)
    self[pos].is_a?(Piece) && self[pos].color == piece.color
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

  def in_check?(color)
    position = find_king(color)
    opposing_pieces = find_opposing_pieces(color)
    opposing_pieces.each do |piece|
      return true if piece.moves.include?(position)
    end
    false
  end

  def checkmate?(color)
     in_check?(color) && valid_moves.nil?
  end

  def dup
    dup_board = Board.new(false)
    @grid.each_with_index do |row, i|
      row.each_with_index do |item, j|
        if item.is_a?(Piece)
          dup_board[[i,j]] = create_piece(item, dup_board)
        end
      end
    end
  end

  def create_piece(item, board)
    case item.class
    when Pawn
      Pawn.new(board, item.color)
    when Rook
      Rook.new(board, item.color)
    when Bishop
      Bishop.new(board, item.color)
    when Knight
      Knight.new(board, item.color)
    when Queen
      Queen.new(board, item.color)
    when King
      King.new(board, item.color)
    end
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
