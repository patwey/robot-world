require_relative '../test_helper'

class UpdateRobotTest < FeatureTest
  def test_user_can_view_update_robot_form
  # As a user, when I navigate to the robots index page, and I click on a
  # reprogram button, then I see an update page with that robots information
  # filled into the inputs.
    build_new(1)
    robot = RobotWorld.all.first

    visit '/robots'
    assert_equal '/robots', current_path

    assert has_link?('Reprogram')
    click_link('Reprogram')
    assert_equal "/robots/#{robot.id}/reprogram", current_path

    within('form') do
      assert has_css?('.robot-name')
      assert_equal 'name 1', find_field('robot[name]').value

      assert has_css?('.robot-city')
      assert_equal 'city 1', find_field('robot[city]').value

      assert has_css?('.robot-state')
      assert_equal 'state 1', find_field('robot[state]').value

      assert has_css?('.robot-birthdate')
      assert_equal 'birthdate 1', find_field('robot[birthdate]').value

      assert has_css?('.robot-date-hired')
      assert_equal 'date_hired 1', find_field('robot[date_hired]').value

      assert has_css?('.robot-department')
      assert_equal 'department 1', find_field('robot[department]').value

      assert has_button?('Submit')
    end
  end

  def test_user_can_submit_form_to_update_robot
  # As a user, when I navigate to the update robot form, and I fill out the
  # updated information, and I click submit, then the robot is updated.
    build_new(1)
    robot = RobotWorld.all.first
    visit "/robots/#{robot.id}/reprogram"
    assert_equal "/robots/#{robot.id}/reprogram", current_path

    within('form') do
      fill_in('robot[name]', with: 'Mr. Robot')
      click_button('Submit')
    end

    assert_equal '/robots', current_path
    assert has_link?('Mr. Robot')
  end
end
