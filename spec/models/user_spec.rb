require 'rails_helper'

RSpec.describe User, type: :model do

  it "有効なファクトリを持つこと" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "名がなければ無効な状態であること" do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "姓がなければ無効な状態であること" do
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it "メールアドレスがなければ無効な状態であること" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "重複したメールアドレスなら無効な状態であること" do
    FactoryBot.create(:user, email: "test@examle.com")
    user = FactoryBot.build(:user, email: "test@examle.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "ユーザーのフルネームを文字列として返すこと" do
    user = FactoryBot.build(:user, first_name: "Kuraudo", last_name: "Ohishi")
    expect(user.name).to eq "Kuraudo Ohishi"
  end

  it "複数のユーザーで何かする" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    expect(true).to be_truthy
  end
end
