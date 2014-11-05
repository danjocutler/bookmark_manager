get '/users/new' do
  @user = User.new
  erb :"users/new"
  # note the view is in views/users/new.erb
  # we need the quotes because otherwise
  # ruby would divide the symbol :users by the
  # variable new (which makes no sense)
end

post '/users' do
	@user = User.new(email: params[:email],
				      password: params[:password],
              password_confirmation: params[:password_confirmation])
  if @user.save
  	session[:user_id] = @user.id
  	redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

  get '/users/reset_password' do
    erb :"users/reset_password"
  end

  post '/users/reset_password' do
    @email = params[:email]
    user = User.first(:email => @email)
    # avoid having to memorise ascii codes
    user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token_timestamp = Time.now
    user.save
    erb :"users/reset_password"
  end

  get '/users/new_password' do 
    @token = params[:token]
    user = User.first(password_token: @token)
    erb :"users/new_password"
  end