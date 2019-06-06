require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade, :id
  def initialize(name, grade, id= nil)
    @name = name
    @grade = grade
  end

  def self.create_table
  sql = <<-SQL
  CREATE TABLE students
  (id INTEGER PRIMARY KEY AUTOINCREMENT,
  NAME TEXT,
  GRADE TEXT)
  SQL
  DB[:conn].execute(sql)
  end

  def self.drop_table
  sql = <<-SQL
  DROP TABLE students
  SQL
  DB[:conn].execute(sql)
  end

  def save
    sql2 = <<-SQL
    SELECT COUNT(*) FROM students
    SQL
    
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)    
    SQL
    
    sql3 = <<-SQL
    UPDATE students 
    SET name = ?, grade = ?
     WHERE id = ?
    SQL
    
    if self.id == nil
    DB[:conn].execute(sql,self.name,self.grade)
    self.id =  DB[:conn].execute(sql2)[0][0]
    else
      DB[:conn].execute(sql3, self.name, self.grade, self.id)
    end
  end

  def update
    sql3 = <<-SQL
    UPDATE students 
    SET name = ?, grade = ?
     WHERE id = ?
    SQL
    DB[:conn].execute(sql3, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
    newStudent = Student.new(name, grade)
    
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)    
    SQL
    DB[:conn].execute(sql,newStudent.name,newStudent.grade)

    sql2 = <<-SQL
    SELECT COUNT(*) FROM students
    SQL
    newStudent.id = DB[:conn].execute(sql2)
  end
    
  def self.new_from_db(row)
    #binding.pry
    newStudent = Student.new(row[1],row[2])
    newStudent.id = row[0]
    newStudent
   end

   def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL

    x = DB[:conn].execute(sql, name)
    newStudent = Student.new(x[0][1], x[0][2])
    newStudent.id = x[0][0]
    newStudent
   end

  

end
