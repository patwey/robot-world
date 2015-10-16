require_relative '../test_helper'

class RobotTest < Minitest::Test
  def test_it_gets_assigned_the_right_attributes
    robot = Robot.new({ :id         => 1,
                        :name       => 'robot1',
                        :city       => 'city1',
                        :state      => 'state1',
                        :avatar     => 'avatar1',
                        :birthdate  => 'birthdate1',
                        :date_hired => 'date_hired1',
                        :department => 'department'})

    assert_equal 1, robot.id
    assert_equal 'robot1', robot.name
    assert_equal 'city1', robot.city
    assert_equal 'state1', robot.state
    assert_equal 'avatar1', robot.avatar
    assert_equal 'birthdate1', robot.birthdate
  end
end
