require 'yaml/store'

class RobotWorld
  def self.database
    # returns an instance of YAML::Store
    if ENV['RACK_ENV'] == 'test'
      @database ||= YAML::Store.new("db/robot_world_test")
    else
      @database ||= YAML::Store.new("db/robot_world")
    end
  end

  def self.raw_robots
    database.transaction do
      database['robots'] || []
    end
  end

  def self.raw_robot(id)
    raw_robots.find { |robot| robot['id'] == id }
  end

  def self.all
    raw_robots.map { |data| Robot.new(data) }
  end

  def self.statistics
    stats = {}
    robots = all

    # average robot age
    birthdates = robots.map { |robot| robot.birthdate }
    ages = birthdates.map {|date| Time.now.year - date.split('/').last.to_i }
    stats[:avg_age] = ages.reduce(:+) / ages.count

    # robots hired each year
    years_hired = robots.map { |robot| robot.date_hired.split('/').last }
    stats[:years_hired] = {}
    years_hired.each do |year|
      year = year.to_i
      stats[:years_hired][year] = 0
      robots.each do |robot|
        stats[:years_hired][year] += 1 if year == robot.date_hired.split('/').last.to_i
      end
    end

    # robots in each department
    departments = robots.map { |robot| robot.department }
    stats[:departments] = {}
    departments.each do |dept|
      stats[:departments][dept] = 0
      robots.each do |robot|
        stats[:departments][dept] += 1 if dept == robot.department
      end
    end

    # robots in each city
    cities = robots.map { |robot| robot.city }
    stats[:cities] = {}
    cities.each do |city|
      stats[:cities][city] = 0
      robots.each do |robot|
        stats[:cities][city] += 1 if city == robot.city
      end
    end
    # robots in each state
    states = robots.map { |robot| robot.state }
    stats[:states] = {}
    states.each do |state|
      stats[:states][state] = 0
      robots.each do |robot|
        stats[:states][state] += 1 if state == robot.state
      end
    end
    stats
  end

  def self.build(robot)
    database.transaction do
      database['robots'] ||= []
      database['total'] ||= 0
      database['total'] += 1
      database['robots'] << { "id"         => database['total'],
                              "name"       => robot['name'],
                              "city"       => robot['city'],
                              "state"      => robot['state'],
                              "avatar"     => robot['avatar'],
                              "birthdate"  => robot['birthdate'],
                              "date_hired" => robot['date_hired'],
                              "department" => robot['department'] }
    end
  end

  def self.find(id)
    Robot.new(raw_robot(id))
  end

  def self.reprogram(id, robot)
    database.transaction do
      target = database['robots'].find { |robot| robot['id'] == id }
      target['name'] = robot['name']
      target['city'] = robot['city']
      target['state'] = robot['state']
      target['avatar'] = robot['avatar']
      target['birthdate'] = robot['birthdate']
      target['date_hired'] = robot['date_hired']
      target['department'] = robot['department']
    end
  end

  def self.unplug(id)
    database.transaction do
      database['robots'].delete_if { |robot| robot["id"] == id }
      # database['robots'].delete_if { |robot| robot['id'] == id }
    end
  end

  def self.delete_all
    database.transaction do
      database['robots'] = []
      database['total'] = 0
    end
  end
end
