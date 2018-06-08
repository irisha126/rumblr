require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models'
require 'byebug'

# to generate a random string in the irb:
#  require 'securerandom'
#  SecureRandom.hex
set :session_secret, ENV['RUMBLR_SESSION_SECRET']
enable :sessions

get ('/') do
    user = User.find_by(username: params[:username])
    unless session[:user_id].nil?
      @user = User.find(session[:user_id])
    end
    erb(:index) 
end


get('/signup')do
#    @user = User.find(session[:user_id])
    erb(:signup) 
end


post ('/signup') do
    @user = User.create(
        username: params[:username],
        password: params[:password],
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        birthday: params[:birthday]
    )
    session[:user_id] = @user.id

    redirect('/user_page_feed')
end

get ('/login') do
    
  erb(:login)  
end



post ('/login') do
    user = User.find_by(username: params[:username])
    if user.nil?
        flash[:warning] = "User does not exist. Please create an account"
        redirect '/login'
    elsif 
    unless user && user.password == params[:password]
      flash[:warning] = "Username or password is incorrect."
      redirect '/login'
    end
  end
    session[:user_id] = user.id
    redirect('/user_page_feed')
end


get ('/profile/:id') do    
    @user = User.find(session[:user_id]) if session[:user_id]

    erb(:profile)
end

get ('/profile/update/:id') do
    @user = User.find(session[:user_id]) if session[:user_id]
    erb(:profile_update)
end


post ('/profile/update/:id') do 
    user = User.find(session[:user_id]) 
    user_new = user.update(
        username: params[:username],
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        birthday: params[:birthday]
    )

    redirect ("/profile/#{session[:user_id]}")
end


get ('/user_post_create') do
    @user = User.find(session[:user_id]) if session[:user_id]
    erb(:user_post_create)
end

post ('/user_post_create') do
    @user = User.find(session[:user_id])
    @post = Post.create(
    title: params[:post_name],
    post: params[:new_post],
    user_id: @user.id
  )
    redirect ('/user_page_feed')
end

get ('/user_page_feed') do
    @user = User.find(session[:user_id]) if session[:user_id]
    @posts = Post.all.reverse
    erb :user_page_feed
end

get ('/update_post/:id') do
    @user = User.find(session[:user_id])
    @post = Post.find(params[:id])
    erb(:update_post)
end

post ('/update_post/:id') do
    post = Post.find(params[:id])
    post.update(
        title: params[:post_name],
        post: params[:new_post]
    )
    redirect ('/my_posts')
end

get ('/my_posts') do
    @user = User.find(session[:user_id])
    @my_posts = Post.where(user_id: @user.id)
    erb(:my_posts)
end

get ('/logout') do
    session[:user_id] = nil
    flash[:notice] = 'You are successfully logged out'
    redirect '/'
end

get ('/delete_post/:id') do
    post = Post.find(params[:id])
    post.destroy
    flash[:warning] = "Post '#{post.title}' has been deleted."
    redirect ('/my_posts')
end

get ('/profile/delete_user/:id') do
    user=User.find(params[:id])
    user.destroy
    flash[:warning] = "Your profile has been deleted."
    redirect('/')
end
