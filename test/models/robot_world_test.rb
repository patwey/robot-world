require_relative '../test_helper'

class RobotWorldTest < Minitest::Test
  def build_new(num)
    num.times { RobotWorld.build({ 'name'       => "name #{num}",
                                   'city'       => "city #{num}",
                                   'state'      => "state #{num}",
                                   'avatar'     => "avatar #{num}",
                                   'birthdate'  => "birthdate #{num}",
                                   'date_hired' => "date_hired #{num}",
                                   'department' => "department #{num}"}) }
  end

  def test_find_returns_a_robot_with_given_id
    # relies on RobotWorld#build
    build_new(1)
    robot = RobotWorld.find(1)

    assert robot.class == Robot
    assert_equal 1, robot.id
  end

  def test_build_creates_a_new_robot
    # relies on RobotWorld#find
    RobotWorld.build({ 'name'       => "name 1",
                       'city'       => "city 1",
                       'state'      => "state 1",
                       'avatar'     => "avatar 1",
                       'birthdate'  => "birthdate 1",
                       'date_hired' => "date_hired 1",
                       'department' => "department 1"})
    robot = RobotWorld.find(1)

    assert_equal 1, robot.id
    assert_equal 'name 1', robot.name
    assert_equal 'city 1', robot.city
    assert_equal 'state 1', robot.state
    assert_equal 'avatar 1', robot.avatar
    assert_equal 'birthdate 1', robot.birthdate
  end

  def test_all_returns_all_robots_in_db
    # relies on RobotWorld#build
    build_new(2)
    robots = RobotWorld.all

    assert_equal 2, robots.count
  end

  def test_reprogram_edits_the_robot_with_given_id
    # relies on RobotWorld#find
    build_new(2)
    RobotWorld.reprogram(2, { 'name'       => "name 3",
                              'city'       => "city 3",
                              'state'      => "state 3",
                              'avatar'     => "avatar 3",
                              'birthdate'  => "birthdate 3",
                              'date_hired' => "date_hired 3",
                              'department' => "department 3"})
    robot = RobotWorld.find(2)

    assert_equal 2, robot.id
    assert_equal 'name 3', robot.name
    assert_equal 'city 3', robot.city
    assert_equal 'state 3', robot.state
    assert_equal 'avatar 3', robot.avatar
    assert_equal 'birthdate 3', robot.birthdate
  end

  def test_unplug_removes_the_robot_with_given_id
    build_new(3)
    RobotWorld.unplug(2)
    robots = RobotWorld.all

    assert_equal 2, robots.count
    assert_equal 1, robots.first.id
    assert_equal 3, robots.last.id
  end
end
