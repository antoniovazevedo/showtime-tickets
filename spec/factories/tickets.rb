FactoryBot.define do
  factory :ticket do
    association :event
    holder_name { "John Doe" }
    holder_phone_number { "912345678" }
    checked_in_at { nil }

    sequence(:holder_email) { |n| "guest#{n}@example.com" }

    trait :checked_in do
      checked_in_at { Time.current }
    end
  end
end
