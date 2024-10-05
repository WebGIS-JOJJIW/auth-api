class User < ApplicationRecord
  has_secure_password validations: false
  belongs_to :role
end
