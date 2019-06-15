require "pry"
require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id
  
  def initialize(id = nil, name, grade)
    @id = id 
    @name = name 
    @grade = grade
  end 
  
  def self.create_table 
     sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end 

  def self.drop_table
    sql =  <<-SQL
    DROP TABLE students 
    SQL
  
    DB[:conn].execute(sql)
  end 

  def save
  #inserts a new row into the db 
  #assigns the id to the object that has been inserted 
    if self.id
      self.update
    else
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
 
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end 
  end
  
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end
  
  def self.new_from_db(row)
    # takes in an argument of an array 
    # the array contains the id, name, and grade
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end 
  
  def self.find_by_name(name)
    # queries the database table for a record that has the name of the argument name 
    # use self.new_from_db to create a new student object
    sql = "SELECT * FROM students WHERE name = ?"
    DB[:conn].execute(sql, name).map { |row| new_from_db(row) }.first
  end 
  
  def update 
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end

