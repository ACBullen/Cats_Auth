class User < ActiveRecord::Base
  validates :username, :password_digest, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  before_validation :ensure_session_token

  attr_reader :password



  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil unless user
    user.is_password?(password) ? user : nil
  end

  # def ensure_session_token
  #   self.session_token ||= User.generate_session_token
  # end
  #
  # def reset_session_token!
  #   self.session_token = User.generate_session_token
  #   self.save!
  #   self.session_token
  # end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat,
    dependent: :destroy

  has_many :requests,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :CatRentalRequest,
    dependent: :destroy

  has_many :sessions
end
