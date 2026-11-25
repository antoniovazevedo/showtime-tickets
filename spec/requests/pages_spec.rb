require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "renders the home page" do
      get root_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("coming soon")
    end
  end
end
