FactoryBot.define do
  factory :event do
    name { "Amazing Show" }
    description { "This show is really, really amazing." }
    starts_at { 1.week.from_now }
    ends_at { instance.starts_at + 1.hour }
    location { "Amazing Venue" }
    capacity { 100 }
  end
end
