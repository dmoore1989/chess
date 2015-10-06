

require_relative 'board'
require_relative 'display'

class Game

  attr_reader :display, :board

  def initialize(player1, player2)
    @board = Board.new

    @players = {:red => Player.new(player1, self), :black => Player.new(player2, self)}
    @current_player = @players[:black]
    @display = Display.new(@board)
  end

  def play
    until @board.checkmate?
      @current_player.play_turn
      switch_players
    end
    puts "Winner is #{@players[board.checkmate?].name}"
  end

  def switch_players
    @current_player == @players[:red] ? @current_player = @players[:black] : @current_player = @players[:red]
  end

  def start_test(pos, player)
    color = player_color(player)
    @board.start_test(pos, color)
  end

  def end_test(end_pos, start_pos)
    @board.end_test(end_pos, start_pos)
  end

  def move(start, end_pos)
    @board.move(start, end_pos)
  end

  def player_color(player)
    @players.invert[player]
  end

end

class Player

  attr_accessor :name

  def initialize(name, game)
    @name = name
    @game = game
  end

  def play_turn
    messages = []
    messages << "Board is in check" if @game.board.in_check?(@game.player_color(self))
    end_piece = []
    messages << "#{@name}'s turn!!!'"
    begin
      messages << "Enter piece you would like to move"
      start_piece = @game.display.move(messages)
      @game.start_test(start_piece, self)
    rescue ChessError => e
      messages.pop
      messages << e.message
      retry
    end
    messages.pop
    messages << "You selected #{@game.board[start_piece]} at position #{start_piece}"
    begin
      messages << "Enter where you want to move this piece (escape to try again)"
      end_piece = @game.display.move(messages)
      if end_piece == [-1, -1]
        message = []
        return play_turn
      end
      @game.end_test(end_piece, start_piece)
    rescue ChessError => e
      messages.pop
      messages << e.message
      retry
    end
    system("clear")
    messages = []
    @game.move(start_piece, end_piece)
  end
end

if $PROGRAM_NAME == __FILE__
  a = Game.new("a","b")
  a.play
end
