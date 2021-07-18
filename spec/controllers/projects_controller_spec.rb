require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index"  do
    context "認証済みユーザー" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "正常にレスポンスを返却すること" do
        sign_in @user
        get :index
        expect(response).to be_success
      end

      it "200レスポンスを返却すること" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "ゲストユーザー" do
      it "302レスポンスを返却すること" do
        get :index
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "認証済みユーザー" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "正常にレスポンスを返却すること" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_success
      end
    end

    context "ゲストユーザー" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it "ダッシュボードにリダイレクトすること" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    context "認証済みユーザー" do
        before do
          @user = FactoryBot.create(:user)
        end

        context "有効な属性値の場合" do
          it "プロジェクトを追加できること" do
            project_params = FactoryBot.attributes_for(:project)
            sign_in @user
            expect {
              post :create, params: { project: project_params }
            }.to change(@user.projects, :count).by(1)
          end
        end

        context "無効な属性値の場合" do
          it "プロジェクトを追加できないこと" do
            project_params = FactoryBot.attributes_for(:project, :invalid)
            sign_in @user
            expect {
              post :create, params: { project: project_params }
            }.to_not change(@user.projects, :count)
        end
      end
    end

    context "ゲストユーザー" do
      it "302レスポンスを返却すること" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    context "認証済みユーザー" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "プロジェクトを更新できること" do
        project_params = FactoryBot.attributes_for(:project, name: "new pj name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "new pj name"
      end
    end

    context "非認可ユーザー" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user, name: "same old name")
      end

      it "プロジェクトを更新できないこと" do
        project_params = FactoryBot.attributes_for(:project, name: "new name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "same old name"
      end

      it "ダッシュボードへリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストユーザー" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "302レスポンスを返却すること" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#destroy" do
    context "認証済みユーザー" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "プロジェクトを削除できること" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to change(@user.projects, :count).by(-1)
      end
    end

    context "非認可ユーザー" do
        before do
          @user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: other_user)
        end

        it "プロジェクトを削除できないこと" do
          sign_in @user
          expect {
            delete :destroy, params: { id: @project.id }
          }.to_not change(Project, :count)
        end

        it "ダッシュボードにリダイレクトすること" do
          sign_in @user
          delete :destroy, params: {id: @project.id}
          expect(response).to redirect_to root_path
        end
    end

    context "ゲストユーザー" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "302レスポンスを返却すること" do
        delete :destroy, params: {id: @project.id}
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        delete :destroy, params: {id: @project.id}
        expect(response).to redirect_to "/users/sign_in"
      end

      it "プロジェクトを削除できないこと" do
        expect {
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end
    end
  end
end
