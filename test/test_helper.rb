ENV['RACK_ENV'] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'tilt/erb'

class Minitest::Test
# add on to minitest::test so everything that inherits it can use the
# teardown behavior
  def teardown
    RobotWorld.delete_all
  end
end

Capybara.app = RobotWorldApp

class FeatureTest < Minitest::Test
  include Capybara::DSL

  def build_new(num)
    num.times { RobotWorld.build({ 'name'       => "name #{num}",
                                   'city'       => "city #{num}",
                                   'state'      => "state #{num}",
                                   'avatar'     => "avatar #{num}",
                                   'birthdate'  => "birthdate #{num}",
                                   'date_hired' => "date_hired #{num}",
                                   'department' => "department #{num}"}) }
  end
end
