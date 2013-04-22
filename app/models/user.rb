class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :username, :password, :password_confirmation, :remember_me, :nickname, :department, :student_id
  attr_accessor :login

  after_initialize :initialize_with_defaults

  has_many :assessments
  has_many :lectures, through: :assessments

  validates :username, uniqueness: true, presence: true
  validates :nickname, uniqueness: true, presence: true

  REGISTRATION_FINISHED_AFTER_ASSESSING = 3

  def initialize_with_defaults
    if id
      self.assessment_count ||= assessments.count
    end
  end

  def assessments_count_to_finished
    REGISTRATION_FINISHED_AFTER_ASSESSING - assessment_count
  end

  def finished_registration?
    assessment_count >= REGISTRATION_FINISHED_AFTER_ASSESSING
  end

  def update_assessment_count
    update_attribute :assessment_count, assessments.count
  end

  def assessment_for(lecture)
    assessments.where(lecture_id: lecture.id).first
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['lower(username) = :value', { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
