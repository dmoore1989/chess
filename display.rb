require "colorize"
require_relative "cursorable"
require_relative "board"

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
    @selected = false
  end

  def build_grid
    @board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      if piece.nil?
        "   ".colorize(color_options)
      else
        " #{piece.to_s} ".colorize(color_options)
     end
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).odd?
      bg = :white
    else
      bg = :grey
    end
    { background: bg}
  end

  def render(messages, errors)
    system("clear")
    # byebug
    puts "Arrow keys or WASD to move, space or enter to confirm."
    build_grid.each { |row| puts row.join }
    messages.each { |message| puts message }
    puts errors.colorize(:red)
  end

  def move(messages, error)
    result = nil
    until result
      render(messages, error)
      result = get_input
    end
    @selected = true
    result
  end

  def play
    start = move
    end_pos = move
    @board.move(start, end_pos)
  end

end
