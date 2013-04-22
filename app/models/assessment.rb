class Assessment < ActiveRecord::Base
  attr_accessible :content, :presentation_score, :workload_score, :grading_score

  belongs_to :lecture
  belongs_to :user

  before_create :calculate_overall_score
  after_create :update_assessment_count_of_lecture
  after_create :update_assessment_count_of_user

  after_initialize :initialize_with_defaults

  validates :user_id, presence: true, uniqueness: { scope: :lecture_id }
  validates :content, presence: true
  validates :presentation_score, presence: true, inclusion: { in: 1..10 }
  validates :workload_score, presence: true, inclusion: { in: 1..10 }
  validates :grading_score, presence: true, inclusion: { in: 1..10 }

  default_scope { order 'id DESC' }

  def self.per_page
    10
  end

  private
    def initialize_with_defaults
      self.presentation_score ||= 1
      self.workload_score ||= 1
      self.grading_score ||= 1
    end

    def calculate_overall_score
      self.overall_score = (presentation_score + workload_score + grading_score) / 3.0
    end

    def update_assessment_count_of_lecture
      lecture.update_assessment_count
    end

    def update_assessment_count_of_user
      user.update_assessment_count
    end
end
