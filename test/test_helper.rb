ENV['RACK_ENV'] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'tilt/erb'

DatabaseCleaner[:sequel, { :connection => Sequel.sqlite('db/robot_world_test.sqlite3') }].strategy = :truncation

class Minitest::Test
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def build_new(num)
    num.times do |n|
      RobotWorld.build({ :name       => "name #{n+1}",
                         :city       => "city #{n+1}",
                         :state      => "state #{n+1}",
                         :avatar     => "avatar #{n+1}",
                         :birthdate  => "birthdate #{n+1}",
                         :date_hired => "date_hired #{n+1}",
                         :department => "department #{n+1}"})
    end
  end
end

Capybara.app = RobotWorldApp

class FeatureTest < Minitest::Test
  include Capybara::DSL
end
