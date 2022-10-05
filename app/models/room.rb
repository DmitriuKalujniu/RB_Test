class Room < ApplicationRecord
  validates :name,:link, presence: true

  has_many :reviews
  has_one :user

  #  add validation for uniq link
end
