def save_image(file, path)
    File.open(path, 'wb') do |f|
        f.write(file.read)
    end

    response = Cloudinary::Uploader.upload(path)
    image_url = response['url']
    return image_url
end

def signup(name, email, password, image_file)
    # ユーザアイコンの保存とアップロード
    save_path = "./public/dynamic/user/#{image_file[:filename]}"
    image_url = save_image(image_file[:tempfile], save_path)

    # ひとまず確定でお客さんロールとして登録するようにする
    user = User.create!(name: name, email: email, password: password, profile_img_link: image_url, role: :customer)
    return user
rescue ActiveRecord::RecordInvalid => e
    @isError = true
    @errorMessage = e.record.errors.full_messages.join(', ')
    return nil
end

def signin(email, password)
    user = User.find_by(email: email)
    if user && user.authenticate(password)
        return user
    else
        @isError = true
        if user.nil?
            @errorMessage = "このメールアドレスは登録されていません"
        else
            @errorMessage = "パスワードが間違っています"
        end
        return nil
    end
end