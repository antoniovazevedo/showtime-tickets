FactoryBot.define do
  factory :ticket do
    event { nil }
    holder_name { "MyString" }
    holder_email { "MyString" }
    holder_phone_number { "MyString" }
    checked_in_at { "2026-11-02 23:02:57" }
  end
end
