=begin
class User < ActiveRecord::Base
  has_secure_password
end
=end

class User < ApplicationRecord
  #has_secure_password

  #has_many :links
  #has_many :topics, through: :links
end
