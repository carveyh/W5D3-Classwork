require 'sqlite3'
require 'singleton'  

class QuestionsDatabase < SQLite3::Database
	include Singleton

	def initialize
		super('questions.db')
		self.type_translation = true 
		self.results_as_hash = true 
	end 
end

class Question

	attr_accessor :id, :title, :body, :user_id

	def self.find_by_id(id)
		data = QuestionsDatabase.instance.execute(<<-SQL, id) 
		SELECT 
	    *
		FROM questions
        WHERE id = ?  
		SQL
		data.map { |datum| Question.new(datum) }
	end
	
	def initialize(options)
		@id = options['id']
		@title = options['title']
		@body = options['body']
		@user_id = options['user_id']
	end
end

class Reply

	attr_accessor :id, :user_id, :question_id, :parent_id, :body

	def self.find_by_id(id)
		data = QuestionsDatabase.instance.execute(<<-SQL, id)
		SELECT 
	    *
		FROM replies
        WHERE id = ?  
		SQL
		data.map { |datum| Question.new(datum) }
	end

	def initialize(options)
        @id = options['id']
		@user_id = options['user_id']
		@question_id = options['question_id']
		@parent_id = options['parent_id']
		@body = options['body']
	end

end

class QuestionLike

	attr_accessor :id, :user_id, :question_id

	def self.find_by_id(id)
		data = QuestionsDatabase.instance.execute(<<-SQL, id)
		SELECT 
	    *
		FROM question_likes
        WHERE id = ?  
		SQL
		data.map { |datum| Question.new(datum) }
	end
	
	def initialize(options)
        @id = options['id']
		@user_id = options['user_id']
		@question_id = options['question_id']
	end 

end

class QuestionFollow

	attr_accessor :id, :user_id, :question_id

	def self.find_by_id(id)
		data = QuestionsDatabase.instance.execute(<<-SQL, id)
		SELECT 
	    *
		FROM question_follows
        WHERE id = ?  
		SQL
		data.map { |datum| Question.new(datum) }
	end

	def initialize(options)
        @id = options['id']
		@user_id = options['user_id']
		@question_id = options['question_id']
	end 

end

class User

	attr_accessor :id, :fname, :lname

	def self.find_by_id(id)
		data = QuestionsDatabase.instance.execute(<<-SQL, id)
		SELECT 
	    *
		FROM users
        WHERE id = ?  
		SQL
		data.map { |datum| Question.new(datum) }
	end

	def initialize(options)
        @id = options['id']
		@fname = options['fname']
		@lname = options['lname']
	end
end