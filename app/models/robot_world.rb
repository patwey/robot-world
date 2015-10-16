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
    # (O_o)
    # -||-
    # _||_
    stats = {:avg_age     => nil,
             :years_hired => {},
             :departments => {},
             :cities      => {},
             :states      => {}}
    robots = all
    return stats if robots.empty?

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
end
