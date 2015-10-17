class RobotWorld
  def self.database
    if ENV['RACK_ENV'] == 'test'
      @database ||= Sequel.sqlite("db/robot_world_test.sqlite3")
    else
      @database ||= Sequel.sqlite("db/robot_world_development.sqlite3")
    end
  end

  def self.table
    database.from(:robots)
  end

  def self.all
    robots = table.to_a
    robots.map { |data| Robot.new(data) }
  end

  def self.build(robot)
    table.insert(robot)
  end

  def self.find(id)
    data = table.where(:id => id).to_a.first
    Robot.new(data)
  end

  def self.reprogram(id, data)
    table.where(:id => id).update(data)
  end

  def self.unplug(id)
    table.where(:id => id).delete
  end

  def self.statistics
    return {} if table.empty?
    stats_for({ :avg_age     => :birthdate,
                :years_hired => :date_hired,
                :departments => :department,
                :cities      => :city,
                :states      => :state })
  end

  def self.stats_for(pairs)
    stats = {}
    pairs.each do |stat_key, robot_attr|
      if stat_key == :avg_age
        now = Time.now
        stats[stat_key] = RobotWorld.average_age(now, robot_attr)
      else
        stats[stat_key] = RobotWorld.num_bots_with_same(robot_attr)
      end
    end
    stats
  end

  def self.average_age(now, robot_attr)
    this_year = now.year
    robots = formatted_robots

    ages = robots.map { |robot| this_year - robot.send(robot_attr) }
    ages.reduce(:+) / ages.count
  end

  def self.num_bots_with_same(robot_attr)
    robots = formatted_robots
    stats = {}
    data = robots.map { |robot| robot.send(robot_attr) }.uniq
    data.each do |row|
      stats[row] = 0
      robots.each do |robot|
        stats[row] += 1 if row == robot.send(robot_attr)
      end
    end
    stats
  end

  def self.formatted_robots
    robots = all
    robots.each do |robot|
      robot.birthdate = robot.birthdate.split('/').last.to_i
      robot.date_hired = robot.date_hired.split('/').last.to_i
    end
    robots
  end
end
