FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name { "kuraudo" }
    last_name { "ohishi" }
    sequence(:email) { |n| "chahurin#{n}@examle.com" }
    password { "mouri-kun.com" }
  end
end
