require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @user.projects.create(
      name: "Test Project",
    )
  end

  it "ユーザー単位では重複したプロジェクト名を許可しないこと" do
    new_project = @user.projects.build(
      name: "Test Project",
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "二人のユーザーが同じ名前を使うことは許可すること" do
    other_user = FactoryBot.create(:user, :other_user)
    other_project = other_user.projects.build(
      name: "Test Project",
    )

    expect(other_project).to be_valid
  end

  describe "遅延ステータス" do
    it "締切日が過ぎていれば、遅延していること" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it "締切日が今日ならスケジュール通りであること" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    it "締切日が未来ならスケジュール通りであること" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end

  it "たくさんのメモが付いていること" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
