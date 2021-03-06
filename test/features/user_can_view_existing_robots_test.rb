require_relative '../test_helper'

class ViewRobotsTest < FeatureTest
  def test_user_can_view_all_robots
  # As a user, when I navigate to the homepage, and I click the Meet the Robots
  # button, then I can see all the existing robots.
    build_new(3)
    robots = RobotWorld.all

    visit '/'
    assert_equal '/', current_path

    click_link('Meet the Robots')

    assert_equal '/robots', current_path
    assert has_css?('.robot-index')

    within('.robot-index') do
      robots.each do |robot|
        assert has_css?("#robot-#{robot.id}")
      end
    end
  end

  def test_user_can_view_a_specific_robots_information
  # As a user, when I navigate to the robots index, and I click on the link
  # of a robot's name, then I see the robot's information
    build_new(1)
    robot = RobotWorld.all.first
    visit '/robots'
    assert_equal '/robots', current_path
    assert has_css?('.robot-index')

    within('.robot-index') do
      assert has_css?("#robot-#{robot.id}")
      click_link('name 1')
    end

    assert_equal "/robots/#{robot.id}", current_path
    assert has_content?('City: city 1')
    assert has_content?('State: state 1')
    assert has_content?('Birthdate: birthdate 1')
    assert has_content?('Date Hired: date_hired 1')
    assert has_content?('Department: department 1')
  end

  def test_user_can_view_robots_statistics
  # As a user, when I navigate to the homepage, then I can see statistics
  # about all the existing robots
    skip
  end
end
