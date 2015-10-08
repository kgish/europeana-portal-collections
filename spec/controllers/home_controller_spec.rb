require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET index' do
    before do
      get :index
    end

    it 'should not get total record count from API' do
      expect(an_api_search_request).not_to have_been_made
    end

    it 'renders the homepage Mustache template' do
      expect(response.status).to eq(200)
      expect(response).to render_template('home/index')
    end
  end
end
