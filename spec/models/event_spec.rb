require 'rails_helper'

RSpec.describe Event, type: :model do
  it "has a valid factory" do
    expect(build(:event)).to be_valid
  end

  it "requires name, starts_at, ends_at, location, capacity" do
    event = build(:event, name: nil, starts_at: nil, ends_at: nil, location: nil, capacity: nil)
    expect(event).not_to be_valid
    expect(event.errors.of_kind? :name, :blank).to be true
    expect(event.errors.of_kind? :starts_at, :blank).to be true
    expect(event.errors.of_kind? :ends_at, :blank).to be true
    expect(event.errors.of_kind? :location, :blank).to be true
    expect(event.errors.of_kind? :capacity, :not_a_number).to be true
  end

  it "requires name to be at most 200 characters long" do
    event = build(:event, name: "a" * 201)
    expect(event).not_to be_valid
    expect(event.errors.of_kind? :name, :too_long).to be true

    event = build(:event, name: "a" * 200)
    expect(event).to be_valid
  end

  it "requires location to be at most 200 characters long" do
    event = build(:event, location: "a" * 201)
    expect(event).not_to be_valid
    expect(event.errors.of_kind? :location, :too_long).to be true

    event = build(:event, location: "a" * 200)
    expect(event).to be_valid
  end

  it "requires ends_at to be after starts_at" do
    event = build(:event, ends_at: 1.day.ago)
    expect(event).not_to be_valid
    expect(event.errors.of_kind? :ends_at, :greater_than).to be true

    time = 1.day.from_now
    event = build(:event, starts_at: time, ends_at: time)
    expect(event).not_to be_valid
    expect(event.errors.of_kind? :ends_at, :greater_than).to be true
  end

  it "requires capacity to be a number" do
    event = build(:event, capacity: "a")
    expect(event).not_to be_valid
    expect(event.errors.of_kind? :capacity, :not_a_number).to be true
  end

  it "requires capacity to be an integer greater than zero" do
    event = build(:event, capacity: 0)
    expect(event).not_to be_valid
    expect(event.errors.of_kind? :capacity, :greater_than).to be true

    event = build(:event, capacity: 1.5)
    expect(event).not_to be_valid
    expect(event.errors.of_kind? :capacity, :not_an_integer).to be true

    event = build(:event, capacity: 1)
    expect(event).to be_valid
  end
end
