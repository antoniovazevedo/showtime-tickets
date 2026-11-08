require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it "has a valid factory" do
    expect(build(:ticket)).to be_valid
  end

  it "gets a token" do
    ticket = build(:ticket)
    expect(ticket.token).to be_present
  end

  it "does not allow change of token" do
    ticket = create(:ticket)
    expect {
      ticket.token = "new-token"
    }.to raise_error(ActiveRecord::ReadonlyAttributeError)
  end

  it "does not allow change of event" do
    ticket = create(:ticket)
    other_event = create(:event)
    expect {
      ticket.event = other_event
     }.to raise_error(ActiveRecord::ReadonlyAttributeError)
  end

  it "requires holder_name" do
    ticket = build(:ticket, holder_name: nil)
    expect(ticket).not_to be_valid
    expect(ticket.errors).to be_of_kind(:holder_name, :blank)
  end

  it "requires holder_name to be at most 100 characters" do
    ticket = build(:ticket, holder_name: "a" * 101)
    expect(ticket).not_to be_valid
    expect(ticket.errors).to be_of_kind(:holder_name, :too_long)

    ticket = build(:ticket, holder_name: "a" * 100)
    expect(ticket).to be_valid
  end

  it "requires a valid email address" do
    ticket = build(:ticket, holder_email: "invalid-email")
    expect(ticket).not_to be_valid
    expect(ticket.errors).to be_of_kind(:holder_email, :invalid)

    ticket = build(:ticket, holder_email: "guest@example.com")
    expect(ticket).to be_valid
  end

  it "requires holder_email to be at most 254 characters" do
    ticket = build(:ticket, holder_email: "a" * 243 + "@example.com")
    expect(ticket).not_to be_valid
    expect(ticket.errors).to be_of_kind(:holder_email, :too_long)
  end

  it "normalizes email address" do
    ticket = build(:ticket, holder_email: "GUEST@EXAMPLE.COM")
    expect(ticket.holder_email).to eq("guest@example.com")

    ticket = build(:ticket, holder_email: " guest@example.com ")
    expect(ticket.holder_email).to eq("guest@example.com")
  end

  it "requires email or phone number" do
    ticket = build(:ticket, holder_email: nil, holder_phone_number: nil)
    expect(ticket).not_to be_valid
    expect(ticket.errors).to be_of_kind(:base, "Email or phone number required")

    ticket = build(:ticket, holder_email: "guest@example.com", holder_phone_number: nil)
    expect(ticket).to be_valid

    ticket = build(:ticket, holder_email: nil, holder_phone_number: "912345678")
    expect(ticket).to be_valid
  end

  it "is invalid when the event is full" do
    event = create(:event, capacity: 1)
    create(:ticket, event:)

    ticket = build(:ticket, event:)
    expect(ticket).not_to be_valid
    expect(ticket.errors).to be_of_kind(:base, "Event capacity reached")
  end

  it "is invalid once the event starts" do
    time = Time.zone.local(2026, 1, 1, 21, 0)
    event = create(:event, starts_at: time)

    travel_to(time - 1.second)
    ticket = build(:ticket, event:)
    expect(ticket).to be_valid

    travel_to(time)
    ticket = build(:ticket, event:)
    expect(ticket).not_to be_valid
    expect(ticket.errors).to be_of_kind(:base, "Event has already started")

    travel_to(time + 1.second)
    ticket = build(:ticket, event:)
    expect(ticket).not_to be_valid
    expect(ticket.errors).to be_of_kind(:base, "Event has already started")
  end

  it "keeps existing ticket valid after the event starts" do
    time = Time.zone.local(2026, 1, 1, 21, 0)
    event = create(:event, starts_at: time)

    travel_to(time - 1.second)
    ticket = create(:ticket, event:)

    travel_to(time + 1.second)
    expect(ticket.update(checked_in_at: Time.current)).to be true

    ticket.reload
    expect(ticket.checked_in_at).to be_within(1.second).of(Time.current)
  end
end
