require './lib/prompts'
require './lib/computer'
require './lib/player'
require './lib/board'

require 'pry'

class Game
  attr_reader :player, :watson, :board
  def initialize
   @player = Player.new(Board.new)
   @watson = Computer.new(Board.new)
   @board = Board.new
  end

  def show_start_prompt
    start_prompt = "#{Prompts::WELCOME}\n#{Prompts::START}> "
    # print start_prompt
    start_prompt
  end

  def run
    # puts show_start_prompt
    input = gets.chomp
    sanitized_input = input.downcase
    play if sanitized_input == "p" || sanitized_input == "play"
    show_instructions if sanitized_input == "i" || sanitized_input == "instructions"
    quit if sanitized_input == "q" || sanitized_input == "quit"
  end

  def play
    place_all_ships
    player_shot_sequence # refactor for until game_won 
    computer_shot_sequence
  end

  def show_instructions
    puts Prompts::INSTRUCTIONS
  end

  def quit
    puts "k bai \u{1F630}"
  end

  def player_shot_sequence
    puts "Make your shot by entering a single coordinate:"
    valid_shot = get_player_shot
    place_player_shot(valid_shot)
    # render_new_board(self)
    all_ships_sunk?(@watson)
  end

  def computer_shot_sequence

  end

  def get_player_shot
    shot = gets.chomp
    valid = @player.coord_inside_board?(shot)
    until valid
      puts "Incorrect, remember to place your shot on the grid of A-D and 1-4."
      shot = gets.chomp
      valid = @player.coord_inside_board?(shot)
    end

    puts 'Shot has been made...'
    shot
  end

  def place_player_shot(shot)
    letter, number = shot.split('')
    letter = letter.upcase.to_sym
    number = number.to_i
    coordinate = @watson.board.board_info[letter][number - 1]
    boat_hit = coordinate == "\u{26F5}"
    if boat_hit
      update_board(letter, number, boat_hit, @watson)
      update_ships(shot, @watson)
    else
      update_board(letter, number, boat_hit, @watson)
    end
    # record in shot history
    give_feedback(boat_hit)
  end

  def give_feedback(boat_hit)
    if boat_hit
      puts Prompts::BOAT_HIT
    else
      puts Prompts::BOAT_MISS
    end
  end

  def update_board(letter, number, boat_hit, owner)
    owner.board.board_info[letter][number - 1 ] = boat_hit ? "H" : "M"
  end

  def update_ships(shot, owner)
    shot = shot.upcase
    owner.ships.each do |ship|
      ship[shot.to_sym] = true if ship.keys.include?(shot.to_sym)
    end
  end

  def place_all_ships
    @watson.place_ships
    ship_1 = get_player_ship_coordinates('two')
    ship_2 = get_player_ship_coordinates('three')
    @player.place_ship(ship_1)
    @player.place_ship(ship_2)
    Prompts.print_empty_board
  end

  def get_player_ship_coordinates(length)
    p Prompts::GET_PLAYER_COORDINATE % length
    ship_choice = gets.chomp
    valid_choice = @player.valid_choice?(ship_choice)
    until valid_choice
      puts "Incorrect, remember to place your ship on the grid of A-D and 1-4 and dont overlap ships."
      ship_choice = gets.chomp
      valid_choice= @player.valid_choice?(ship_choice)
    end

    puts 'That ship has been placed!'
    valid_choice
  end

  def render_new_board(owner)
    new_board = owner.board.board_info.reduce("") do |board_string, (row_name, columns)|
      printable_row = columns.reduce("") do |row_string, spot|
        row_string += "#{spot} "
        row_string 
      end
      board_string += "#{row_name.to_s} #{printable_row} \n"
      board_string
    end
    
    print "#{Prompts::TOP}#{new_board}#{Prompts::BOTTOM}"
    new_board
  end

  def all_ships_sunk?(owner)
    owner.ships.reduce(true) do |game_over, ship|
      game_over = false if ship.values.include?(false)
      game_over
    end
  end
end
