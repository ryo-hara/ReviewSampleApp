class User < ApplicationRecord
    before_save { email.downcase! }
    VALID_EMAIL_REGAX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :name,    presence: true, length: {maximum: 50,   minimum: 2}
    validates :email,   presence: true, length: {maximum: 255,  minimum: 2}
    validates :email,   format:{with: VALID_EMAIL_REGAX},   uniqueness: { case_sensitive: false }

end
