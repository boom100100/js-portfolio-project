class User < ApplicationRecord
  has_many :links
  has_many :topics, through :links
end
