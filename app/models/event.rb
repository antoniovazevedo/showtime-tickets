class Event < ApplicationRecord
  has_many :tickets, dependent: :restrict_with_error
end
