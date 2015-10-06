require_relative 'pieces'
require 'byebug'

class Board

  attr_accessor :grid

  def initialize(new_game = true)
    @grid = Array.new(8){ Array.new(8) }
    place_pieces if new_game
  end

  def checked_king
    @grid[0][0] = King.new(self,:black)
    #@grid[2][0] = Queen.new(self,:red)
    #@grid[2][2] = Queen.new(self,:red)
    @grid[0][2] = Queen.new(self,:red)
  end

  def place_pieces
    @grid.each_with_index do |row, i|
      if i == 1
        row.map!{ |el| el = Pawn.new(self, :red) }
      elsif i == 6
        row.map!{ |el| el = Pawn.new(self, :black) }
      elsif i == 0
        row.each_with_index do |el, j|
          @grid[i][j] = map_back_pieces(j, :red)
        end
      elsif i == 7
        row.each_with_index do |el, j|
          @grid[i][j] = map_back_pieces(j, :black)
        end
      end
    end
  end

  def map_back_pieces(element, color)
    case element
    when 0 , 7
      Rook.new(self, color)
    when 1 , 6
      Knight.new(self, color)
    when 2 , 5
      Bishop.new(self, color)
    when 4
      King.new(self, color)
    when 3
      Queen.new(self, color)
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

  def end_test(end_pos, start)
    raise ChessError.new "End position is off the board" if !in_bounds?(end_pos)
    raise ChessError.new "Position has your own piece" if self[end_pos].is_a?(Piece) && self[end_pos].color == setart.color
    unless start.valid_moves.include?(end_pos)
      raise ChessError.new "Position is not a valid move and would leave the King in check"
    end
  end

  def move(start, end_pos)
    start_piece = self[start]
    begin
      start_test(start)
      end_test(end_pos, start_piece)

    rescue ChessError => e
      puts e.message
      return nil
    end
    move!(start, end_pos)



  end


  def move!(start, end_pos)
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
     in_check?(color) && valid_moves(color).empty?
  end

  def valid_moves(color)
    valid = []
    @grid.each_with_index do |row, i|
      row.each_with_index do |item, j|
        if (item) && (item.color == color)
          valid += item.valid_moves
        end
      end
    end
    valid
  end

  def dup
    dup_board = Board.new(false)
    @grid.each_with_index do |row, i|
      row.each_with_index do |item, j|
        if item.is_a?(Piece)
          # byebug
          dup_board[[i,j]] = create_piece(item, dup_board)
        end
      end
    end
    dup_board
  end

  def create_piece(item, board)
    case item.class.to_s
    when "Pawn"
      Pawn.new(board, item.color)
    when "Rook"
      Rook.new(board, item.color)
    when "Bishop"
      Bishop.new(board, item.color)
    when "Knight"
      Knight.new(board, item.color)
    when "Queen"
      Queen.new(board, item.color)
    when "King"
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
