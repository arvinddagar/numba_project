class User < ActiveRecord::Base
include ActiveModel::ForbiddenAttributesProtection
  has_many :emails

  attr_accessor :password
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  validates :name, :length => { :within => 8..25 }, :uniqueness => false
  validates :email, :presence => true, :length => { :maximum => 100 }, 
    :format => EMAIL_REGEX, :uniqueness => true


  before_save :create_hashed_password
  after_save :clear_password

  attr_protected :password, :salt

  def self.authenticate(email="", password="")
    user = User.find_by_email(email)
    if user && true
      return user
    else
      return false
    end
  end

# The same password string with the same hash method and salt
  # should always generate the same hashed_password.
  def password_match?(password="")
    password == User.hash_with_salt(password, salt)
  end
  
  def self.make_salt(email="")
    Digest::SHA1.hexdigest("Use #{email} with #{Time.now} to make salt")
  end
  
  def self.hash_with_salt(password="", salt="")
    Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
  end
  
  private
  
  def create_hashed_password
    # Whenever :password has a value hashing is needed
    unless password.blank?
      # always use "self" when assigning values
      self.salt = User.make_salt(email) if salt.blank?
      self.password = User.hash_with_salt(password, salt)
    end
  end

  def clear_password
    # for security and b/c hashing is not needed
    self.password = nil
  end
  
end
