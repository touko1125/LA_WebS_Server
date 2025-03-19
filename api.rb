require 'sinatra'
require './utils/account.rb'
require './utils/hair.rb'

post '/api/signin', provides: :json do
    params = JSON.parse(request.body.read)
    email = params['email']
    password = params['password']
    user = signin(email, password)
    if user.nil?
        status 500
        return {user: nil, message: @errorMessage }.to_json
    else
        status 200
        user_json = user.to_json(except: [:password_digest])
        return {user: user_json, message: nil}.to_json
    end
end

post '/api/signup' do
    name = params['name']
    email = params['email']
    password = params['password']
    image_file = params['image_file']
    user = signup(name, email, password, image_file)
    if user.nil?
        status 500
        return {user: nil, message: @errorMessage }.to_json
    else
        status 200
        user_json = user.to_json(except: [:password_digest])
        return {user: user_json, message: nil}.to_json
    end
end

post '/api/hair_history' do
    user_id = params[:user_id]
    stylist_name = params[:stylist_name]
    evaluation = params[:evaluation]
    memo = params[:memo]
    day1_img_link = params[:img_link]
    color_type = params[:color_type]
    hair_colors = params[:hair_colors]
    salon_data = params[:salon]

    user = User.find(user_id)
    salon = register_salon(salon_data)
    stylist = register_stylist(salon, stylist_name)
    hair_week = register_hair_week(day1_img_link)
    hair_history = register_hair_history(user, salon, stylist, hair_week, evaluation, memo, color_type)
    hair_colors = register_hair_colors(hair_history, hair_colors)

    status 200
    return {message: "髪色履歴の登録に成功しました"}.to_json
rescue ActiveRecord::RecordInvalid => e
    message = handle_error(e)
    return {message: message}.to_json
end

post '/api/hair_history/:history_id/day/:index' do
    history_id = params[:history_id]
    index = params[:index]
    img_link = params[:img_link]
    memo = params[:memo]
    hair_history = HairHistory.find(history_id)
    register_hair_day(hair_history, index, img_link, memo)
    status 200
    return {message: "髪色経過の登録に成功しました"}.to_json
rescue ActiveRecord::RecordInvalid => e
    message = handle_error(e)
    return {message: message}.to_json
end

get '/api/hair_history/trend' do
    trend_hair_history_ids = get_trend_hair_history_ids()
    response = convert_hair_histories_to_client_post(trend_hair_history_ids)
    status 200
    return response
end

get '/api/hair_history/new' do
    new_hair_history_ids = get_new_hair_history_ids()
    response = convert_hair_histories_to_client_post(new_hair_history_ids)
    status 200
    return response
end

get '/api/hair_history/:history_id' do    
    response = convert_hair_history_to_client_detail(params[:history_id])
    status 200
    return response
end

get '/api/user/:user_id/friend/hair_history' do
    user = User.find(params[:user_id])
    friend_hair_history_ids = get_friend_hair_history_ids(user)
    response = convert_hair_histories_to_client_post(friend_hair_history_ids)
    status 200
    return response
end

post '/api/user/:user_id/hair_history/:history_id/like' do
    like_hair_history(params[:user_id], params[:history_id])
    status 200
    return {message: "いいねに成功しました。"}.to_json
rescue ActiveRecord::RecordInvalid => e
    message = handle_error(e)
    return {message: message}.to_json
end

post '/api/user/:user_id/hair_history/:history_id/bookmark' do
    bookmark_hair_history(params[:user_id], params[:history_id])
    status 200
    return {message: "ブックマークに成功しました。"}.to_json
rescue ActiveRecord::RecordInvalid => e
    message = handle_error(e)
    return {message: message}.to_json
end

get '/api/user/:user_id/hair_history' do
    user = User.find(params[:user_id])
    user_hair_history_ids = get_user_hair_history_ids(user)
    response = convert_hair_histories_to_client_post(user_hair_history_ids)
    status 200
    return response
end