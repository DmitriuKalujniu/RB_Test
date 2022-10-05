class Review < ApplicationRecord
  belongs_to :room
  enum area: { airbnb: 0}.freeze
end
