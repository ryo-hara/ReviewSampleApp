class User < ApplicationRecord

    attr_accessor :remember_token
    before_save { email.downcase! }
    VALID_EMAIL_REGAX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :name,    presence: true, length: {maximum: 50,   minimum: 2}
    validates :email,   presence: true, length: {maximum: 255,  minimum: 2}
    validates :email,   format:{with: VALID_EMAIL_REGAX},   uniqueness: { case_sensitive: false }
    has_secure_password
    
    validates :password, presence: true, length: {minimum: 6}
    
    
    def self.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    def self.new_token
        SecureRandom.urlsafe_base64
    end
    
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
end
