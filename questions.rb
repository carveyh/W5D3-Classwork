require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
	include Singleton


end

class Question
	def self.find_by_id(id)
		data = QuestionsDatabase.instance.execute("")
	end
end

class Reply
	def self.find_by_id
	end
end

class QuestionLike
	def self.find_by_id
	end
end

class QuestionFollow
	def self.find_by_id
	end
end

class User
	def self.find_by_id
	end
end