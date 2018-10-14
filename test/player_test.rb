require './test/test_helper'
require './lib/player'
require './lib/board'

class PlayerTest < Minitest::Test
  def setup
    @board = Board.new
    @player = Player.new(@board)
  end

  def test_it_exists
    assert_instance_of Player, @player
  end

  def test_it_has_a_board
    assert_instance_of Board, @player.board
  end

  def test_it_can_validate_placement_choice
    choice = "B2 B3 B4"
    assert_equal ["B2", "B3", "B4"], @player.valid_choice?(choice)
  end

  def test_it_returns_false_if_placement_is_overboard
    bad_choice = "B3 B4 B5"

    refute @player.valid_choice?(bad_choice)
  end

  def test_it_can_validate_placement_doesnt_overlap
    @player.board.create_ship(['A1', 'B1'])
    choice = "A2 A3 A4"

    assert_equal ["A2", "A3", "A4"], @player.valid_choice?(choice)
  end

  def test_it_returns_false_if_placement_overlaps_previous_ship
    @player.board.create_ship(['A1', 'B1'])
    bad_choice = "A1 A2 A3"

    refute @player.valid_choice?(bad_choice)
  end

  def test_it_checks_for_consecutive_coordinates
    skip
  end

  def test_it_converts_coordinates_to_hash

  end

  def test_it_checks_for_valid_vertical_coordinate_hash
    skip
  end

  def test_it_checks_for_valid_horizontal_coordinate_hash
    skip
  end

  def test_it_can_place_a_ship
    skip
    @player.place_ship(['A1', 'B1'])
    #integration test
  end

  def test_it_adds_to_ships
    ship_1_coordinates = ["A1", "A2"]

    @player.add_to_ships(ship_1_coordinates)
    assert_equal 1, @player.ships.length
    assert_equal 2, @player.ships[0].length
  end

end
