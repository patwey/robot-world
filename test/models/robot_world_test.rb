require_relative '../test_helper'

class RobotWorldTest < Minitest::Test
  # make method for RobotWorld.all.first ?
  def test_find_returns_a_robot_with_given_id
    build_new(1)
    robot = RobotWorld.find(RobotWorld.all.first.id)

    assert robot.class == Robot
    assert_equal RobotWorld.all.first.id, robot.id
  end

  def test_build_creates_a_new_robot
    RobotWorld.build({ :name       => "name 1",
                       :city       => "city 1",
                       :state      => "state 1",
                       :avatar     => "avatar 1",
                       :birthdate  => "birthdate 1",
                       :date_hired => "date_hired 1",
                       :department => "department 1"})
    robot = RobotWorld.find(RobotWorld.all.first.id)

    assert_equal RobotWorld.all.first.id, robot.id
    assert_equal 'name 1', robot.name
    assert_equal 'city 1', robot.city
    assert_equal 'state 1', robot.state
    assert_equal 'avatar 1', robot.avatar
    assert_equal 'birthdate 1', robot.birthdate
  end

  def test_all_returns_all_robots_in_db
    build_new(2)
    robots = RobotWorld.all

    assert_equal 2, robots.count
    assert_equal 'name 1', robots.first.name
    assert_equal 'name 2', robots.last.name
  end

  def test_reprogram_edits_the_robot_with_given_id
    build_new(2)
    RobotWorld.reprogram(RobotWorld.all.first.id, { :name       => "name 3",
                                                    :city       => "city 3",
                                                    :state      => "state 3",
                                                    :avatar     => "avatar 3",
                                                    :birthdate  => "birthdate 3",
                                                    :date_hired => "date_hired 3",
                                                    :department => "department 3"})
    robot = RobotWorld.find(RobotWorld.all.first.id)

    assert_equal RobotWorld.all.first.id, robot.id
    assert_equal 'name 3', robot.name
    assert_equal 'city 3', robot.city
    assert_equal 'state 3', robot.state
    assert_equal 'avatar 3', robot.avatar
    assert_equal 'birthdate 3', robot.birthdate
  end

  def test_unplug_removes_the_robot_with_given_id
    build_new(3)
    total = RobotWorld.all.count
    RobotWorld.unplug(RobotWorld.all.first.id)
    robots = RobotWorld.all

    assert_equal (total - 1), robots.count
    assert_equal RobotWorld.all.first.id, robots.first.id
    assert_equal RobotWorld.all.last.id, robots.last.id
  end
end
