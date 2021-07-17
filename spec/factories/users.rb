FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name { "kuraudo" }
    last_name { "ohishi" }
    sequence(:email) { |n| "chahurin#{n}@examle.com" }
    password { "mouri-kun.com" }

    # 別のユーザ検証用
    trait :other_user do
      first_name { "kurarisu" }
      last_name { "Tester" }
      sequence(:email) { |n| "kurarisutester#{n}@examle.com" }
    end
  end
end
