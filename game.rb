class Game

  def initialize(player1, player2)
    @board = Board.new
    @player1 = {:red => player1}
    @player2 = {:black => player2}
    @current_player = player1
  end

  def play
    until board.checkmate
      play_turn
      switch_players
    end
    puts "Winner is #{board.checkmate}"
  end

  def switch_players
    @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
  end

  def play_turn

  end

end

class Player

  attr_writer :name

  def initialize(name)
    @name = name
  end
end
