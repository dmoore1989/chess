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

  def start_test(pos)
    @board.start_test(pos)
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
      @game.start_test(start_piece)
    rescue ChessError => e
      puts e.message
      retry
    end



  end
end
