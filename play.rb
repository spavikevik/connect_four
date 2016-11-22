# Gameplay wrapper
require_relative 'lib/game_board'
game = GameBoard.new
puts "Welcome to connect 4!\n\n"

print game.format_board

loop do
  print "#{game.player == 'p1' ? 'Player 1' : 'Player 2'}'s move: "
  coords = gets
  game.drop_disc(coords.split(',').map(&:to_i))
  game.toggle_player
  print game.format_board
  if game.get_winner
    puts "\n#{game.get_winner == 'p1' ? 'Player 1' : 'Player 2'} won the game\n"
    break
  end
end