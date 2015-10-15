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
