require 'pry'

class Dog

  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name:, breed:, id:)
    @name = name
    @breed = breed
    @id = id
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

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    breed = row[2]
    new_name = self.new(name, breed, id)
    new_name
    
  end



end
