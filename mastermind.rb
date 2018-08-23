class Game
  def initialize
    clear_screen
    @game_rounds = 0
    @game_won = false
    puts <<-INTRO
WELCOME TO MASTERMIND!
In this game you pit your mind against the computer.
Using the clues provided you need to guess the 4 digit code,
with each digit being a number from one to six.

--GAME SETUP--
    INTRO

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
    blank_rows = @total_guesses - @guess_array.length
    filled_rows = @total_guesses - blank_rows
    counter = 0

    clear_screen
    print_line
    puts "   CODE         HINTS"
    print_line
    filled_rows.times do
      print "| "
      @guess_array[counter].chars.each {|x| print x; print " "}
      print "|  | "
      @answer_array[counter].chars.each {|x| print x; print " "}
      puts "|"
      counter += 1
    end
    blank_rows.times do
      puts "| O O O O |  | * * * * |"
    end
    print_line
  end

  #Get 4 digits and validate
  def get_4_digits
    input = ""
    puts "Hints: 2 means correct number in correct location"
    puts "and 1 means correct number in wrong location\n"
    until (/^[1-6]{4}$/) =~ input do
      print "\t--GUESS THE CODE--\n#{@human.name} - Enter 4 digits, each one 1-6: "
      input = gets.chomp
    end
    input
  end

  def random_4_digits
    answer = ""
    4.times do
      answer += (rand(5)+1).to_s
    end
    answer
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
    hint_string = ""
    evaluated = []
    (0..3).each do |num|
      if code_array[num] == guess_array[num]
        puts "Match for 2! #{code_array[num]}, #{guess_array[num]}"
        evaluated.push(num)
        hint_string += "2"
      end
    end
    evaluated.reverse.each do |num|
      code_array.delete_at(num)
      guess_array.delete_at(num)
    end
    guess_array.each do |char|
      if code_array.include?(char)
        code_array.delete(char)
        hint_string += "1"
      end
    end
    (4-hint_string.length).times {hint_string += "0"}
    hint_string
  end

  def end_game
    clear_screen
    score
    winner = @human.score > @computer.score ? @human.name : @computer.name
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