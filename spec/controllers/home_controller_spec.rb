require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "#index"  do
    it "正常にレスポンスを返却すること" do
      get :index
      expect(response).to be_success
    end

    it "200レスポンスを返却すること" do
      get :index
      expect(response).to have_http_status "200"
    end
  end
end
