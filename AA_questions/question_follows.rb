require_relative 'questions.rb'
class QuestionFollow

  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    q_follow = data.first
    QuestionFollow.new(q_follow)
  end

  def followers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question)
    SELECT
      users.*
    FROM
      question_follows
    JOIN
      users ON user_id = users.id
    WHERE
      question_id = ?;
    SQL

    data.map {  |user| User.new(user) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end