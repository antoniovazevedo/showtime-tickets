class Ticket < ApplicationRecord
  belongs_to :event
  has_secure_token :token
end
