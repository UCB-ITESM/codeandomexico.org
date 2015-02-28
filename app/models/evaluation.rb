class Evaluation < ActiveRecord::Base
  attr_accessible :judge_id, :challenge_id

  belongs_to :challenge
  belongs_to :judge
  has_many :report_cards
  has_many :entries, through: :report_cards

  validates :challenge_id, uniqueness: { scope: :judge_id }

  def initialize_report_cards
    self.challenge.entries.each { |e| new_report_card(e) }
  end

  def status
    # this method return an integer
    # 0: Has not started to evaluate entries
    # 1: Has started but hasn't finished
    # 2: Has finished evaluating this challenge

    # how many entries are left to be evaluated?
    case entries_left_to_evaluate
    when challenge.entries.count then NOT_STARTED_EVALUATING_CHALLENGE
    when (1..challenge.entries.count-1) then STARTED_EVALUATING_CHALLENGE
    when 0 then FINISHED_EVALUATING_CHALLENGE
    end
  end

  def number_of_entries_graded
    # let's return the number of entries graded
    report_cards.map { |r| r.criteria_and_grades_are_valid? ? 1 : 0 }.reduce(:+) || 0
  end

  def entries_left_to_evaluate
    challenge.entries.count - number_of_entries_graded
  end

  def total_number_of_entries
    challenge.entries.count
  end

  private

  def new_report_card(entry)
    ReportCard.create! do |r|
      r.evaluation_id = self.id
      r.entry_id = entry.id
      r.grades = ReportCard.duplicate_criteria(self.challenge.evaluation_criteria)
    end
  end
end