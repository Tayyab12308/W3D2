require_relative 'questions.rb'
class QuestionLike

  attr_accessor :id, :user_id, :question_id
  
  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        question_likes
      WHERE
        id = ?
    SQL

    q_like = data.first
    QuestionLike.new(q_like)
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end