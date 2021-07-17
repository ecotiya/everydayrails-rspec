require 'rails_helper'

RSpec.describe Project, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user = User.create(
      first_name: "kuraudo",
      last_name: "Tester",
      email: "tester@example.com",
      password: "mouri-kun.com",
    )

    user.projects.create(
      name: "Test Project",
    )

    new_project = user.projects.build(
      name: "Test Project",
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    user = User.create(
      first_name: "kuraudo",
      last_name: "Tester",
      email: "kuraudotester@example.com",
      password: "mouri-kun.com",
    )

    user.projects.create(
      name: "Test Project",
    )

    other_user = User.create(
      first_name: "kurarisu",
      last_name: "Tester",
      email: "kurarisutester@example.com",
      password: "mouri-kun.com",
    )

    other_project = other_user.projects.build(
      name: "Test Project",
    )

    expect(other_project).to be_valid
  end
end
