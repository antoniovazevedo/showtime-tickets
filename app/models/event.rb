class Event < ApplicationRecord
  has_many :tickets, dependent: :restrict_with_error

  validates :name, :starts_at, :ends_at, :location, presence: true
  validates :name, :location, length: { maximum: 200 }
  validates :ends_at, comparison: { greater_than: :starts_at }, if: :starts_at?
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
end
