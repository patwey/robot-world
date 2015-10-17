require_relative '../test_helper'

class BuildRobotTest < FeatureTest
  def test_user_can_view_build_robot_form
  # As a user, when I navigate to the homepage, and I click on a build robot
  # button, then I will see a new robot form.
    visit '/'
    assert_equal '/', current_path

    within('.landing') do
      click_link('Build a Robot')
    end
    assert_equal '/robots/new', current_path

    within('form') do
      assert has_css?('.robot-name')
      assert has_css?('.robot-city')
      assert has_css?('.robot-state')
      assert has_css?('.robot-birthdate')
      assert has_css?('.robot-date-hired')
      assert has_css?('.robot-department')
      assert has_button?('Submit')
    end
  end

  def test_user_can_submit_form_to_build_robot
  # As a user, when I navigate to the new robot page, and I fill out the form,
  # and I click on the submit button, then a new robot will be created.
    visit '/robots/new'
    assert_equal '/robots/new', current_path

    within('form') do
      fill_in('robot[name]', with: 'Pat')
      fill_in('robot[city]', with: 'Pittsburgh')
      fill_in('robot[state]', with: 'PA')
      fill_in('robot[birthdate]', with: '03/21/1991')
      fill_in('robot[date_hired]', with: '10/15/2015')
      fill_in('robot[department]', with: 'Maintenance')
      click_button('Submit')
    end

    assert_equal '/robots', current_path
  end
end
