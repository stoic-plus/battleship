require 'pry'
require './lib/board'

class Computer
  LETTERS = ["A","B","C","D"]
  DIRECTIONS = [:H, :V]
  attr_reader :board
  def initialize(board)
    @board = board
    @shot_history = []
    assign_board_owner
  end

  def assign_board_owner
    @board.add_owner(self)
  end

  def get_coordinates(ship_length, previous_ship = false)
    direction = DIRECTIONS[rand(2)]
    letter, number = generate_start_coordinate(direction, ship_length)
    puts "#{direction} #{letter} #{number}"
    if previous_ship
      if not valid_coordinate?(letter.to_sym, number)
        letter, number = generate_valid_start_coordinate(ship_length)
      end
      coordinates = generate_coordinates(letter, number, direction, ship_length)
      if not valid_coordinates?(coordinates)
        coordinates = generate_valid_coordinates(letter, number, direction, ship_length)
      end
    else
      coordinates = generate_coordinates(letter, number, direction, ship_length)
    end
    coordinates
  end

  def generate_valid_start_coordinate(ship_length)
    valid = false
    until valid
      direction = DIRECTIONS[rand(2)]
      letter, number = generate_start_coordinate(direction, ship_length)
      puts "coordinates: #{letter} #{number}"
      valid = valid_coordinate?(letter.to_sym, number)
    end
    return letter, number, direction
  end

  def generate_valid_coordinates(letter, number, direction, ship_length)
    valid = false
    until valid
      coordinates = generate_coordinates(letter, number, direction, ship_length)
      valid = valid_coordinates?(coordinates)
    end
    coordinates
  end

  def generate_start_coordinate(direction, ship_length)
    if direction == :H
      letter = LETTERS[rand(4)]
      number = generate_random_number(ship_length)
    else
      number = rand(4) + 1
      letter = generate_random_letter(ship_length)
    end
    return letter, number
  end

  def generate_coordinates(letter, number, direction, ship_length)
    letter_start_index = LETTERS.index(letter)
    coordinates = ["#{letter}#{number}"]
    (1..ship_length - 1).each do |i|
      if direction == :H
        number += 1
        coordinates << "#{letter}#{number}"
      else
        letter = LETTERS[letter_start_index += 1]
        coordinates << "#{letter}#{number}"
      end
    end
    coordinates
  end

  def generate_random_letter(ship_length)
    letter_constraint = @board.size - ship_length
    letter = LETTERS[rand(letter_constraint)]
  end

  def generate_random_number(ship_length)
    number_constraint = @board.size - ship_length + 1
    number = rand(number_constraint) + 1
  end

  def valid_coordinate?(letter, number)
    @board.board_info[letter][number - 1] != "\u{26F5}"
  end

  def valid_coordinates?(coordinates)
    is_valid = coordinates.reduce(true) do |valid, coordinate|
      letter, number = coordinate.split("")
      valid = false if not valid_coordinate?(letter.to_sym, number.to_i)
      valid
    end
  end
end

board = Board.new
apple = Computer.new(board)

apple.get_coordinates(3)