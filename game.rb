

require_relative 'board'

class Game

  def initialize(player1, player2)
    @board = Board.new
    @players = {:red => Player.new(player1, self), :black => Player.new(player2, self)}
    @current_player = @players[:red]
  end

  def play
    until board.checkmate
      @current_player.play_turn
      switch_players
    end
    puts "Winner is #{@players[board.checkmate]}"
  end

  def switch_players
    @current_player == @players[:red] ? @current_player = @players[:black] : @current_player = @players[:red]
  end

  def start_test(pos, player)
    color = @players.invert[player]
    @board.start_test(pos, color)
  end

  def end_test(end_pos, start_pos)
    @board.end_test(end_pos, start_pos)
  end

  def move(start, end_pos)
    @board.move(start, end_pos)
  end

end

class Player

  attr_writer :name

  def initialize(name, game)
    @name = name
    @game = game
  end

  def play_turn
    begin
      puts "Enter piece you would like to move"
      start_piece = gets.chomp.split(", ").map(&:to_i)
      @game.start_test(start_piece, self)
    rescue ChessError => e
      puts e.message
      retry
    end
    begin
      puts "Enter where you want to move this piece"
      end_piece = gets.chomp.split(", ").map(&:to_i)
      @game.end_test(end_piece, start_piece)
    rescue ChessError => e
      puts e.message
      retry
    end
    @game.move(start_piece, end_piece)
  end
end
