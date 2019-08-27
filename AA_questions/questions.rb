require "sqlite3"
require "singleton"
require_relative 'users.rb'
require_relative 'replies.rb'

class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super("./questions.db")
    self.type_translation = true
    self.results_as_hash = true
  end

end

class Question

  attr_accessor :id, :title, :body, :user_id
  
  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    question = data.first
    Question.new(question)
  end 
  
  def self.find_by_author_id(author_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL

    data.map { |author| Question.new(author) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    User.find_by_id(user_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

end

