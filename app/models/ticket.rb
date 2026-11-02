class Ticket < ApplicationRecord
  belongs_to :event
  has_secure_token :token

  attr_readonly :event_id, :token

  normalizes :holder_email, with: ->(email) { email.strip.downcase }

  validates :holder_name, presence: true, length: { maximum: 100 }
  validates :holder_email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }, length: { maximum: 254 }
  validate :email_or_phone_number_required
  validate :respects_event_capacity, :no_tickets_once_event_starts, on: :create

  private
  def email_or_phone_number_required
    errors.add(:base, "Email or phone number required") unless holder_email.present? || holder_phone_number.present?
  end

  def respects_event_capacity
    return unless event
    errors.add(:base, "Event capacity reached") if event.tickets.count >= event.capacity
  end

  def no_tickets_once_event_starts
    return unless event
    errors.add(:base, "Event has already started") if event.starts_at < Time.current
  end
end
