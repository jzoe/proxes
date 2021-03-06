# frozen_string_literal: true
require 'proxes/controllers/application'

module ProxES
  # Manage your Elasticsearch cluster, user and user sessions
  class App < Application
    get '/' do
      authenticate!
      haml :index, locals: { title: 'Dashboard' }
    end

    ['/unauthenticated', '/_proxes/unauthenticated'].each do |path|
      get path do
        redirect '/auth/identity'
      end
    end

    post '/auth/identity/new' do
      identity = Identity.new(params['identity'])
      if identity.valid? && identity.save
        user = User.find_or_create(email: identity.username)
        user.add_identity identity

        log_action(:identity_register, user: user)
        flash[:info] = 'Successfully Registered. Please log in'
        redirect '/auth/identity'
      else
        flash.now[:warning] = 'Could not complete the registration. Please try again.'
        haml :'identity/register', locals: { identity: identity }
      end
    end

    post '/auth/identity/callback' do
      user = User.find(email: env['omniauth.auth']['info']['email'])
      self.current_user = user
      log_action(:identity_login, user: user)
      flash[:success] = 'Logged In'
      redirect '/_proxes'
    end

    delete '/auth/identity' do
      log_action(:identity_logout)
      logout
      flash[:info] = 'Logged Out'

      redirect '/_proxes'
    end
  end
end
