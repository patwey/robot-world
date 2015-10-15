require_relative '../test_helper'

class DeleteRobotTest < FeatureTest
  def test_user_can_delete_a_robot
  # As a user, when I navigate to the robots index, and I click on an unplug
  # button, then the corresponding robot will be deleted.
    build_new(1)

    visit '/robots'
    assert_equal '/robots', current_path

    within('form') do
      assert has_button?('Unplug')
      click_button('Unplug')
    end

    within('ul') do
      refute has_css?('li')
    end
  end
end
