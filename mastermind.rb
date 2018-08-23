class Game
  def initialize #todo validate input
    clear_screen
    @game_rounds = 0
    @game_won = false
    puts "--GAME SETUP--"
    print "Guesses allowed per round (10 recommended): "
    @total_guesses = gets.chomp.to_i
    print "Number of rounds: "
    @total_rounds = gets.chomp.to_i
    print "Enter player name: "
    name = gets.chomp
    @human = Player.new(name)
    @computer = Player.new("Computer")
    reset_round
  end

  def score
    puts "The score is #{@human.name}: #{@human.score} #{@computer.name}: #{@computer.score} "
    puts "Press enter to continue"
    continue = gets
  end

  private
  #initialize current round variables .. a round consists of multiple turns
  def reset_round
    while @game_rounds < @total_rounds
      @game_rounds += 1
      @guess_array = []
      @answer_array = []
      clear_screen
      puts "Round #{@game_rounds}!"
      @code = random_4_digits
      puts "TEST @code: #{@code}" #todo remove test code
      play_turn
    end
      end_game
  end

  def clear_screen
    puts "\e[H\e[2J"
  end

  def play_turn
    while @guess_array.length < @total_guesses
      display_board
      guess = get_4_digits
      @guess_array.push(guess)
      answer = evaluate_guess(guess)
      @answer_array.push(answer)
      break if match?(@guess_array[-1])
    end
    clear_screen
    if match?(@guess_array[-1])
      puts "The code is broken!"
      @human.won_round
    else
      puts "The code remains unsolved! (it was #{@code})"
      @computer.won_round
    end
    score
  end

  #print out the current game board
  def display_board
    clear_screen
    print_line
    blank_rows = @total_guesses - @guess_array.length
    puts "   CODE         HINTS"
    print_line
    blank_rows.times do
      puts "| O O O O |  | * * * * |"
    end
    filled_rows = @total_guesses - blank_rows
    counter = 0
    reversed_guess = @guess_array.reverse
    reversed_answer = @answer_array.reverse
    filled_rows.times do
      print "| "
      reversed_guess[counter].chars {|x| print x; print " "}
      print "|  | "
      reversed_answer[counter].chars {|x| print x; print " "}
      puts "|"
      counter += 1
    end
    print_line
  end

  #Get 4 digits and validate
  def get_4_digits
    input = ""
    puts "Hints: 2 means correct number in correct location,\nand 1 means correct number in wrong location"
    until (/^[1-6]{4}$/) =~ input do
      print "\t--GUESS THE CODE--\n#{@human.name} - Enter 4 digits, each one 1-6: "
      input = gets.chomp
    end
    input
  end

  def random_4_digits
    "1234"
  end

  def print_line
    puts "------------------------"
  end

  def match?(guess)
    return false if [nil].include?(guess)
    return @code == guess ? true : false
  end

  def evaluate_guess(guess)
    code_array = @code.chars
    guess_array = guess.chars
    puts "code_array is #{code_array}" #todo remove test code
    puts "guess_array is #{guess_array}" #todo remove test code
    (0..3).each do |num|
      "1234" #todo write the evaluation
    end
  end

  def end_game
    clear_screen
    score
    winner = @human.score > computer.score ? @human.name : @computer.name
    puts "The winner is #{winner}!"
  end
end

class Player
attr_reader :name, :score

  def initialize(name)
    @name = name
    @score = 0
  end

  def won_round
    @score += 1
    puts "#{@name} won the round!"
  end
end

game = Game.new