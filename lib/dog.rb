require 'pry'

class Dog

  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name:, breed:, id:'nil')
    @id = nil
    @name = name
    @breed = breed

  end

 def self.create_table
   sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT)
    SQL

    DB[:conn].execute(sql)
 end

 def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<~SQL
        INSERT INTO dogs(name, breed) VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

    end
    self

  end

  def self.create(attribute_hash)
    dog = Dog.new(attribute_hash)
    dog.save
    dog

  end

  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]
    Dog.new(attribute_hash)
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    breed = row[2]
    new_dog = self.new(id, name, breed)
    new_dog
  end

  def self.find_by_name(name)
      sql = <<~SQL
        SELECT * FROM dogs
        WHERE name = ?
        LIMIT 1
        SQL

        DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
      end.first
    end



    def update
      sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name, self.breed, self.id)
    end


    def self.find_or_create_by(name:, breed:)
      dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
      if !dog.empty?
        dog_data = song[0]
        dog= Dog.new(dog_data[0], dog_data[1], dog_data[2])
      else
        dog = self.create(name: name, breed: breed)
      end
      dog
    end
end
