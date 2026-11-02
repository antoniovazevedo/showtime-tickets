FactoryBot.define do
  factory :event do
    name { "MyString" }
    description { "MyText" }
    start { "2026-11-02 22:49:11" }
    ends_at { "2026-11-02 22:49:11" }
    location { "MyString" }
    capacity { 1 }
  end
end
