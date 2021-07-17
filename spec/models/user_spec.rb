require 'rails_helper'

RSpec.describe User, type: :model do
  it "姓、名、メール、パスワードがあれば有効な状態であること" do
    user = User.new(
      first_name: "kuraudo",
      last_name: "ohishi",
      email: "chahurin@examle.com",
      password: "mouri-kun.com",
    )
    expect(user).to be_valid
  end

  it "名がなければ無効な状態であること" do
    user = User.new(first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "姓がなければ無効な状態であること" do
    user = User.new(last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it "重複したメールアドレスなら無効な状態であること" do
    User.create(
      first_name: "kuraudo",
      last_name: "ohishi",
      email: "chahurin@example.com",
      password: "mouri-kun.com",
    )

    user = User.new(
      first_name: "kuraudo",
      last_name: "tester",
      email: "chahurin@example.com",
      password: "mouri-kun.com",
    )
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")

  end

  it "ユーザーのフルネームを文字列として返すこと" do
    user = User.new(
      first_name: "kuraudo",
      last_name: "ohishi",
      email: "ko@example.com",
    )

    expect(user.name).to eq "kuraudo ohishi"
  end
end
