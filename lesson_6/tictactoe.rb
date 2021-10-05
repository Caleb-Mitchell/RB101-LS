require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals
POINTS_TO_WIN = 5

def prompt(msg)
  puts "=> #{msg}"
end

def display_welcome
  welcome_message = <<-MSG
  ====Welcome to TicTacToe====
  Would you like to choose who goes first?
  (If not, the computer will choose randomly)
  Please enter (y)es or (n)o:
  MSG
  prompt(welcome_message)
end

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def display_board(brd, player_score, computer_score)
  system 'clear'
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts "--Current Score-- (First to #{POINTS_TO_WIN} wins!)"
  puts "Player: #{player_score}"
  puts "Computer: #{computer_score}"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, delimeter=', ', word='or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimeter)
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd), '; ', 'and')}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  # square = if possible_comp_win?(brd)
  square = if board_threat?(brd, COMPUTER_MARKER)
             threat_location(brd, COMPUTER_MARKER)
           elsif board_threat?(brd, PLAYER_MARKER)
             threat_location(brd, PLAYER_MARKER)
           elsif brd[5] == INITIAL_MARKER
             5
           else
             empty_squares(brd).sample
           end
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def line_threat?(brd, line, marker)
  brd.values_at(*line).count(marker) == 2 &&
    brd.values_at(*line).count(" ") == 1
end

def board_threat?(brd, marker)
  WINNING_LINES.each do |line|
    return true if brd.values_at(*line).count(marker) == 2 &&
                   brd.values_at(*line).count(" ") == 1
  end
  false
end

def threat_location(brd, marker)
  WINNING_LINES.each do |line|
    if line_threat?(brd, line, marker)
      return brd.select { |k, v| line.include?(k) && v == ' ' }.keys.first
    end
  end
end

loop do
  display_welcome
  player_choice = gets.chomp.downcase.chr == 'y'
  
  # if player_choice == true, as the player who should go first
  # if false, have the computer choose randomly
  # implement alternate_player and place_piece TODO

  # First player to POINTS_TO_WIN wins
  player_score = 0
  computer_score = 0

  loop do
    board = initialize_board

    loop do
      display_board(board, player_score, computer_score)

      player_places_piece!(board)
      break if someone_won?(board) || board_full?(board)

      computer_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board, player_score, computer_score)

    if someone_won?(board)
      prompt "#{detect_winner(board)} won!"
      prompt "Hit any key to continue"
      gets
      detect_winner(board) == 'Player' ? player_score += 1 : computer_score += 1
    else
      prompt "It's a tie!"
    end

    break if player_score == POINTS_TO_WIN || computer_score == POINTS_TO_WIN
  end

  if player_score == POINTS_TO_WIN
    prompt "You are the grand winner!"
  elsif computer_score == POINTS_TO_WIN
    prompt "Sorry, the computer wins this time."
  end

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break if answer.downcase.start_with?('n')
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"
# TODO add any necessary explanation comments of code that doesn't explain
# itself
