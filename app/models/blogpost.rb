class Blogpost < ActiveRecord::Base
  has_many :comments
end
