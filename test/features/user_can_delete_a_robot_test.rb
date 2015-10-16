require_relative '../test_helper'

class DeleteRobotTest < FeatureTest
  def test_user_can_delete_a_robot
  # As a user, when I navigate to the robots index, and I click on an unplug
  # button, then the corresponding robot will be deleted.
    build_new(1)
    robot = RobotWorld.all.first

    visit '/robots'
    assert_equal '/robots', current_path
    assert has_css?("#robot-#{robot.id}")

    within('form') do
      assert has_button?('Unplug')
      click_button('Unplug')
    end

    within('.robot-index') do
      refute has_css?("#robot-#{robot.id}")
    end
  end
end
