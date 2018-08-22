class Game
  def initialize #todo validate input
    clear_screen
    @game_rounds = 0
    @game_won = false
    puts "--GAME SETUP--"
    print "Guesses allowed per round (10 recommended): "
    @total_guesses = gets.chomp.to_i
    print "Number of rounds per player: "
    @total_rounds = gets.chomp.to_i * 2
    @code_maker = Player.new("one")
    @code_breaker = Player.new("two")
    reset_round
  end

  def score
    puts "The score is #{@code_maker.name}: #{@code_maker.score} #{@code_breaker.name}: #{@code_breaker.score} "
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
      @code_maker, @code_breaker = @code_breaker, @code_maker
      clear_screen
      puts "Round #{@game_rounds}!"
      @code = get_ints("SET", @code_maker.name)
      play_turn
    end
      end_game
  end

  def clear_screen
    puts "\e[H\e[2J"
  end

  def play_turn
    while @guess_array.length < @total_guesses &&
          @guess_array[-1] != @code
      display_board
      guess = get_ints("GUESS", @code_breaker.name)
      @guess_array.push(guess)
      answer = @code #todo fix this later, for testing
      @answer_array.push(answer)
    end
    clear_screen
    if @guess_array[-1] == @code
      puts "The code is broken!"
      @code_breaker.won_round
    else
      puts "The code remains unsolved! (it was #{@code})"
      @code_maker.won_round
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
      reversed_guess[counter].each {|x| print x; print " "}
      print "|  | "
      reversed_answer[counter].each {|x| print x; print " "}
      puts "|"
      counter += 1
    end
    print_line
  end

  #Get 4 digits and validate
  def get_ints(heading, name)
    input = ""
    until (/^[1-6]{4}$/) =~ input do
      print "\t--#{heading} THE CODE--\n#{name} - Enter 4 digits, each one 1-6: "
      input = gets.chomp
    end
    answer = []
    input.each_char do |char|
      answer.push(char.to_i)
    end
    answer
  end

  def print_line
    puts "------------------------"
  end

  def evaluate_guess
    #todo evaluate the guess, add answer to answer_array
  end

  def end_game
    clear_screen
    score
    winner = @code_maker.score > code_breaker.score ? @code_maker.name : @code_breaker.name
    puts "The winner is #{winner}!"
  end
end

class Player
attr_reader :name, :score

  def initialize(num)
    print "Enter player #{num} name: "
    @name = gets.chomp
    @score = 0
  end

  def won_round
    @score += 1
    puts "#{@name} won the round!"
  end
end

game = Game.new