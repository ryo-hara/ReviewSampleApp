class User < ApplicationRecord

    attr_accessor   :remember_token, :activation_token
    before_save     { email.downcase! }
    before_create   :create_activation_digest
    VALID_EMAIL_REGAX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :name,    presence: true, length: {maximum: 50,   minimum: 2}
    validates :email,   presence: true, length: {maximum: 255,  minimum: 2}
    validates :email,   format:{with: VALID_EMAIL_REGAX},   uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true
    
    
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
    
    def forget
        update_attribute(:remember_digest, nil)
    end
    
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    def activate
        update_columns(activated: true , activated_at: Time.zone.now)
    end
    
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    
    private 
    
        def downcase_email
            self.email = email.downcase
        end
        
        def create_activation_digest
            self.activation_token   = User.new_token
            self.activation_digest  = User.digest(activation_token)
        end
end
