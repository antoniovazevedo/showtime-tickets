class Event < ApplicationRecord
  has_many :tickets, dependent: :restrict_with_error

  validates :name, :starts_at, :ends_at, :location, presence: true
  validates :name, :location, length: { maximum: 200 }
  validates :ends_at, comparison: { greater_than: :starts_at }, if: :starts_at?
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }

  validate :capacity_not_below_issued_tickets, if: :capacity_changed?

  private
  def capacity_not_below_issued_tickets
    return if capacity.nil?
    errors.add(:capacity, "cannot be below issued tickets") if capacity < tickets.count
  end
end
