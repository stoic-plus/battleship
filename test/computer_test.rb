require './test/test_helper'
require './lib/computer'
require './lib/board'
require 'pry'
class ComputerTest < Minitest::Test
  def setup
    @board = Board.new
    @computer = Computer.new(@board)
  end

  def test_it_gets_coordinates_length_of_two_no_previous_ship
    coordinates = @computer.get_coordinates(2)

    assert (/[ABCD]/) =~ coordinates[0].split("")[0]
    assert (/[1234]/) =~ coordinates[0].split("")[1]
    assert (/[ABCD]/) =~ coordinates[1].split("")[0]
    assert (/[1234]/) =~ coordinates[1].split("")[1]
  end

  def test_it_gets_coordinates_length_of_three_no_previous_ship
    coordinates = @computer.get_coordinates(3)

    assert (/[ABCD]/) =~ coordinates[0].split("")[0]
    assert (/[1234]/) =~ coordinates[0].split("")[1]
    assert (/[ABCD]/) =~ coordinates[1].split("")[0]
    assert (/[1234]/) =~ coordinates[1].split("")[1]
    assert (/[ABCD]/) =~ coordinates[2].split("")[0]
    assert (/[1234]/) =~ coordinates[2].split("")[1]
  end

  def test_it_gets_coordinates_length_of_three_previous_ship
    @board.board_info = {
      A: ["\u{26F5}","\u{26F5}","\u{26F5}","\u{26F5}"],
      B: ["\u{26F5}","\u{26F5}"," ","\u{26F5}"],
      C: ["\u{26F5}","\u{26F5}"," ","\u{26F5}"],
      D: ["\u{26F5}","\u{26F5}"," ","\u{26F5}"]
    }
    coordinates = @computer.get_coordinates(3, true)
  end

  # def test_it_gets_coordinates_length_of_three_previous_ship
  #
  # end

  def test_it_generates_start_coordinate_length_of_two_horizontal
    letter, number = @computer.generate_start_coordinate(:H, 2)

    assert (/[ABCD]/) =~ letter
    assert (/[123]/) =~ number.to_s
  end

  def test_it_generates_start_coordinate_length_of_two_vertical
    letter, number = @computer.generate_start_coordinate(:V, 2)

    assert (/[ABC]/) =~ letter
    assert (/[1-4]/) =~ number.to_s
  end

  def test_it_generates_start_coordinate_length_of_three_horizontal
    letter, number = @computer.generate_start_coordinate(:H, 3)

    assert (/[ABCD]/) =~ letter
    assert (/[12]/) =~ number.to_s
  end

  def test_it_generates_start_coordinate_length_of_three_vertical
    letter, number = @computer.generate_start_coordinate(:V, 3)

    assert (/[AB]/) =~ letter
    assert (/[1-4]/) =~ number.to_s
  end

  def test_it_generates_coordinates_for_horizontal_placement_length_two_row_a
    assert_equal ["A1", "A2"], @computer.generate_coordinates("A", 1, :H, 2)
  end

  def test_it_generates_coordinates_for_horizontal_placement_length_two_row_b
    assert_equal ["B1", "B2"], @computer.generate_coordinates("B", 1, :H, 2)
  end

  def test_it_generates_coordinates_for_horizontal_placement_length_three_row_a
    assert_equal ["A1", "A2", "A3"], @computer.generate_coordinates("A", 1, :H, 3)
  end

  def test_it_generates_coordinates_for_horizontal_placement_length_three_row_b
    assert_equal ["B1", "B2", "B3"], @computer.generate_coordinates("B", 1, :H, 3)
  end

  def test_it_generates_coordinates_for_vertical_placement_length_two_column_1
    assert_equal ["A1", "B1"], @computer.generate_coordinates("A", 1, :V, 2)
  end

  def test_it_generates_coordinates_for_vertical_placement_length_two_column_2
    assert_equal ["A2", "B2"], @computer.generate_coordinates("A", 2, :V, 2)
  end

  def test_it_generates_coordinates_for_vertical_placement_length_three_column_1
    assert_equal ["A1", "B1", "C1"], @computer.generate_coordinates("A", 1, :V, 3)
  end

  def test_it_generates_coordinates_for_vertical_placement_length_three_column_2
    assert_equal ["A2", "B2", "C2"], @computer.generate_coordinates("A", 2, :V, 3)
  end

  def test_generates_random_letter_length_of_three
    assert /[AB]/ =~ @computer.generate_random_letter(3)
  end

  def test_generates_random_letter_length_of_two
    assert /[ABC]/ =~ @computer.generate_random_letter(2)
  end

  def test_generates_random_number_length_of_three
    assert /[12]/ =~ @computer.generate_random_number(3).to_s
  end

  def test_generates_random_number_length_of_two
    assert /[123]/ =~ @computer.generate_random_number(2).to_s
  end
end
