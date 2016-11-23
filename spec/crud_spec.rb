require 'spec_helper'
require 'proxes/controllers'
require 'support/crud_shared_examples'

{
  '/users' => ProxES::Users,
}.each do |route, controller|
  describe controller do
    def app
      described_class
    end

    context 'as super_admin_user' do
      let(:user) { create(:super_admin_user) }
      let(:model) { create(app.model_class.name.to_sym) }

      before(:each) do
        # Log in
        warden = double(Warden::Proxy)
        allow(warden).to receive(:user).and_return(user)
        env 'warden', warden
      end

      it_behaves_like 'a CRUD Controller', route
    end

    context 'as user' do
      let(:user) { create(:user) }
      let(:model) { create(app.model_class.name.to_sym) }

      before(:each) do
        # Log in
        warden = double(Warden::Proxy)
        allow(warden).to receive(:user).and_return(user)
        env 'warden', warden
      end

      it_behaves_like 'a CRUD Controller', route
    end
  end
end
