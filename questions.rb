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

class User

	attr_accessor :id, :fname, :lname

	def self.find_by_id(id)
		data = QuestionsDatabase.instance.execute(<<-SQL, id)
		SELECT 
	    *
		FROM users
        WHERE id = ?  
		SQL
		data.map { |datum| User.new(datum) }
	end

	def self.find_by_name(fname, lname)
		data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
		SELECT 
	    *
		FROM 
			users
		WHERE 
			fname = ? AND lname = ?
		SQL
		data.map { |datum| User.new(datum) }
	end

	def initialize(options)
        @id = options['id']
		@fname = options['fname']
		@lname = options['lname']
	end

	def authored_questions
		Question.find_by_author_id(self.id)
	end

	def authored_replies
		Reply.find_by_user_id(self.id)
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

	def self.find_by_author_id(author_id)
		data = QuestionsDatabase.instance.execute(<<-SQL, author_id) 
			SELECT
				*
			FROM
				questions
			WHERE
				user_id = ?
		SQL
		data.map { |datum| Question.new(datum) }
	end
	
	def initialize(options)
		@id = options['id']
		@title = options['title']
		@body = options['body']
		@user_id = options['user_id']
	end

	def author 
		data = QuestionsDatabase.instance.execute(<<-SQL,self.id)
			SELECT
				*
			FROM
				questions
			INNER JOIN 
				users ON questions.user_id = users.id
			WHERE
				 questions.id = ? 
		SQL
		data.map { |datum| User.new(datum) }
	end 	

	def replies
		Reply.find_by_question_id(self.id)
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
		data.map { |datum| Reply.new(datum) }
	end

	def self.find_by_user_id(user_id)
		data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
			SELECT
				*
			FROM
				replies
			WHERE
				user_id = ?
		SQL
		data.map { |datum| Reply.new(datum) }
	end

	def self.find_by_question_id(question_id)
		data = QuestionsDatabase.instance.execute(<<-SQL, question_id) 
			SELECT
				*
			FROM
				replies
			WHERE
				question_id = ?
		SQL
		data.map { |datum| Reply.new(datum) }
	end

	def initialize(options)
        @id = options['id']
		@user_id = options['user_id']
		@question_id = options['question_id']
		@parent_id = options['parent_id']
		@body = options['body']
	end

	def author 
		data = QuestionsDatabase.instance.execute(<<-SQL, self.id)
		    SELECT
                *
            FROM
                replies
			INNER JOIN 
                users ON replies.user_id = users.id
            WHERE
			    replies.id = ?
            SQL
			data.map { |datum| User.new(datum) }
	end
	
	def question 
		data = QuestionsDatabase.instance.execute(<<-SQL, self.id)
			SELECT
                *
            FROM
                replies 
			INNER JOIN 
                questions ON replies.question_id = questions.id
            WHERE
			    replies.id =?
            SQL
			data.map { |datum| Question.new(datum) }
	end 

	def parent_reply 
		data = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
		    SELECT
					*
				FROM
					replies
				WHERE
			    id = ?
		SQL
		data.map { |datum| Reply.new(datum) }
	end 

	def child_replies 
		data = QuestionsDatabase.instance.execute(<<-SQL, self.id)
		    SELECT
						*
				FROM
						replies
				WHERE
			    parent_id = ?
		SQL
		data.map { |datum| Reply.new(datum) }
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
		data.map { |datum| QuestionLike.new(datum) }
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
		data.map { |datum| QuestionFollow.new(datum) }
	end
	
	def self.followers_for_question_id(question_id) 
		data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
		SELECT 
			*
        FROM question_follows
		INNER JOIN users ON users.id = question_follows.user_id
		WHERE question_id = ? 
        SQL
		data.map { |datum| User.new(datum) }
	end 

	def initialize(options)
        @id = options['id']
		@user_id = options['user_id']
		@question_id = options['question_id']
	end 


end

