# サロンの情報を取得するためのユーティリティ
def register_salon(salon_data)
    salon = Salon.find_by(place_id: salon_data['place_id'])
    if salon.nil?
        #TODO:ひとまずサロンはpending状態で登録する。オーナーが登録して初めてverifiedされる
        salon = Salon.create!(
            place_id: salon_data['place_id'], 
            name: salon_data['name'], 
            address: salon_data['address'], 
            phone_number: salon_data['phone_number'],
            website: salon_data['website'],
            latitude: salon_data['latitude'], 
            longitude: salon_data['longitude'],
            status: :pending)
    end
    return salon
end

# スタイリストの登録
def register_stylist(salon, stylist_name)
    # TODO:スタイリストは後から自身の名前で登録するようにする
    # スタイリストの検索
    staffs = salon.staffs
    stylist = staffs.find_by(name: stylist_name)
    if stylist.nil?
        stylist = User.create!(name: stylist_name, email: nil, password: nil, profile_img_link: nil, role: :stylist)
        SalonStaff.create!(user: stylist, salon: salon)
    end
    return stylist
end

# 髪色経過の保存
def register_hair_week(img_link)
    hair_day1 = HairDay.create!(img_link: img_link)
    hair_week = HairWeek.create!(day1_hair: hair_day1)
    return hair_week
end

# 髪色履歴の保存
def register_hair_history(user, salon, stylist, hair_week, evaluation, memo, color_type)
    start_date = Date.today
    end_date = start_date + 2.weeks
    hair_history = HairHistory.create!(
        user: user, 
        salon: salon, 
        stylist: stylist, 
        hair_week: hair_week,
        evaluation: evaluation, 
        memo: memo, 
        color_type: color_type.to_i,
        start_date: start_date,
        end_date: end_date
    )
    return hair_history
end

# 髪色経過の保存
def register_hair_day(hair_history, index, img_link, memo)
    index = index.to_i
    hair_day = HairDay.create!(img_link: img_link, memo: memo)
    hair_week = hair_history.hair_week
    case index
        when 2
            hair_week.day2_hair_id = hair_day.id
        when 3
            hair_week.day3_hair_id = hair_day.id
        when 4
            hair_week.day4_hair_id = hair_day.id
        when 5
            hair_week.day5_hair_id = hair_day.id
        when 6
            hair_week.day6_hair_id = hair_day.id
        when 7
            hair_week.day7_hair_id = hair_day.id
        when 8
            hair_week.day8_hair_id = hair_day.id
        when 9
            hair_week.day9_hair_id = hair_day.id
        when 10
            hair_week.day10_hair_id = hair_day.id
        when 11
            hair_week.day11_hair_id = hair_day.id
        when 12
            hair_week.day12_hair_id = hair_day.id
        when 13
            hair_week.day13_hair_id = hair_day.id
        when 14
            hair_week.day14_hair_id = hair_day.id
    end
    hair_week.save!
    p hair_week
end

# 髪色経過の保存
def register_hair_colors(hair_history, hair_colors)
    hair_color_array = []
    hair_colors.each_value do |color_data|
        hair_color = HairColor.find_by(hex_code: color_data['hex_code'])
        if hair_color.nil?
            hair_color = HairColor.create!(name: color_data['name'], hex_code: color_data['hex_code'])
        end
        HairHistoryColor.create!(hair_history: hair_history, hair_color: hair_color, percentage: color_data['percentage'].to_i)
        hair_color_array.push(hair_color)
    end
    return hair_color_array
end

# 髪色履歴に対するいいね/いいね解除
def like_hair_history(user_id, history_id)
    user = User.find(user_id)
    hair_history = HairHistory.find(history_id)
    if hair_history.like_users.include?(user)
        hair_history.like_users.delete(user)
    else
        hair_history.like_users.push(user)
    end
end

# 髪色履歴に対するブックマーク/ブックマーク解除
def bookmark_hair_history(user_id, history_id)
    user = User.find(user_id)
    hair_history = HairHistory.find(history_id)
    if hair_history.bookmark_users.include?(user)
        hair_history.bookmark_users.delete(user)
    else
        hair_history.bookmark_users.push(user)
    end
end

# トレンドの髪色履歴のIDの配列を取得する
LIKE_WEIGHT = 1.0
BOOKMARK_WEIGHT = 1.5
TIME_WEIGHT = 0.5
TIME_SHIFT = 1.0
def get_trend_hair_history_ids()
    all_hair_histories = HairHistory.all
    all_hair_history_scores = {}
    all_hair_histories.each do |hair_history|
        like_count = hair_history.like_users.count
        bookmark_count = hair_history.bookmark_users.count
        passed_time = (Date.today - hair_history.created_at.to_date).to_i
        weight = (like_count * LIKE_WEIGHT + bookmark_count * BOOKMARK_WEIGHT) / (passed_time * TIME_WEIGHT + TIME_SHIFT)
        all_hair_history_scores[hair_history.id] = weight
    end
    return all_hair_history_scores.sort_by{|k, v| -v}.take(10).to_h.keys
end

# 新着の髪色履歴のIDの配列を取得する
def get_new_hair_history_ids()
    return HairHistory.all.order(created_at: :desc).take(10).map(&:id)
end

# ユーザーのフォローしているユーザーの髪色履歴のIDの配列を取得する
def get_friend_hair_history_ids(user)
    return user.followings.map { |followed_user| followed_user.hair_histories.order_by(created_at: :desc).take(3).map(&:id) }.flatten
end

# ユーザの髪色履歴のIDの配列を取得する
def get_user_hair_history_ids(user)
    return user.hair_histories.map(&:id)
end

# 髪色履歴のIDの配列を一括でクライアントサイドで投稿として表示するために必要なHairHistoryのModelに変換する
def convert_hair_histories_to_models(hair_histories)
    return hair_histories.map { |hair_history_id| HairHistory.find(hair_history_id) }
end

# 髪色履歴の配列を一括でクライアントサイドで投稿として表示するために必要なJsonに変換する
def convert_hair_histories_to_client_post(hair_histories)
    data = hair_histories.map { |hair_history_id| convert_hair_history_to_client_post(hair_history_id) }
    return {posts: data}.to_json
end

# 髪色履歴をクライアントサイドで投稿として表示するために必要なデータに変換する
def convert_hair_history_to_client_post(hair_history_id)
    hair_history = HairHistory.find(hair_history_id)
    hair_history_colors = hair_history.hair_history_colors.map { |hair_history_color| convert_hair_color_to_client_post(hair_history_color) }
    user_history_colors = hair_history.user.hair_histories.map { |user_hair_history| user_hair_history.hair_history_colors.map { |hair_history_color| convert_hair_color_to_client_post(hair_history_color) } }.take(3)
    user_history_color_array = user_history_colors + Array.new([0, 3 - user_history_colors.size].max, nil)
    like_user_ids = hair_history.like_users.map(&:id)
    bookmark_user_ids = hair_history.bookmark_users.map(&:id)

    return {
        id: hair_history.id,
        userId: hair_history.user.id,
        userName: hair_history.user.name,
        hairColors: hair_history_colors,
        userHistoryColors: user_history_color_array,
        startDate: hair_history.start_date,
        endDate: hair_history.end_date,
        daysImages: convert_hair_day_images_to_client_post(hair_history.hair_week),
        likeUsers: like_user_ids,
        bookmarkUsers: bookmark_user_ids,
    }
end

# 髪色履歴をクライアントサイドで投稿として表示するために必要なデータに変換する
def convert_hair_history_to_client_detail(hair_history_id)
    hair_history = HairHistory.find(hair_history_id)
    hair_history_colors = hair_history.hair_history_colors.map { |hair_history_color| convert_hair_color_to_client_post(hair_history_color) }

    return {
        id: hair_history.id,
        startDate: hair_history.start_date,
        endDate: hair_history.end_date,
        likeCount: hair_history.like_users.count,
        bookmarkCount: hair_history.bookmark_users.count,
        hairColors: hair_history_colors,
        salon: convert_salon_to_client_post(hair_history.salon),
        stylistName: hair_history.stylist.name,
        evaluation: hair_history.evaluation,
        memo: hair_history.memo,
        weekData: convert_hair_days_to_client_post(hair_history.hair_week),
    }.to_json
end

# 髪色履歴の色情報をクライアントサイドで投稿として表示するために必要なデータに変換する
def convert_hair_color_to_client_post(hair_history_color)
    return {
        color: {
            name: hair_history_color.hair_color.name,
            hex_code: hair_history_color.hair_color.hex_code
        },
        order: hair_history_color.order,
        ratio: hair_history_color.percentage / 100.0,
    }
end

def convert_salon_to_client_post(salon)
    return {
        id: salon.id,
        name: salon.name,
        lat: salon.latitude,
        lng: salon.longitude,
        website: salon.website,
        address: salon.address,
        phone_number: salon.phone_number,
    }
end

def convert_hair_day_to_client_data(hair_day,index)
    return {
        dayIndex: index,
        imageUrl: hair_day.img_link,
        memo: hair_day.memo
    }
end

# 髪色経過の色情報をクライアントサイドで投稿として表示するために必要なデータに変換する
def convert_hair_days_to_client_post(hair_week)
    return [
        convert_hair_day_to_client_data(hair_week.day1_hair,1),
        (convert_hair_day_to_client_data(hair_week.day2_hair,2) if hair_week.day2_hair),
        (convert_hair_day_to_client_data(hair_week.day3_hair,3) if hair_week.day3_hair),
        (convert_hair_day_to_client_data(hair_week.day4_hair,4) if hair_week.day4_hair),
        (convert_hair_day_to_client_data(hair_week.day5_hair,5) if hair_week.day5_hair),
        (convert_hair_day_to_client_data(hair_week.day6_hair,6) if hair_week.day6_hair),
        (convert_hair_day_to_client_data(hair_week.day7_hair,7) if hair_week.day7_hair),
        (convert_hair_day_to_client_data(hair_week.day8_hair,8) if hair_week.day8_hair),
        (convert_hair_day_to_client_data(hair_week.day9_hair,9) if hair_week.day9_hair),
        (convert_hair_day_to_client_data(hair_week.day10_hair,10) if hair_week.day10_hair),
        (convert_hair_day_to_client_data(hair_week.day11_hair,11) if hair_week.day11_hair),
        (convert_hair_day_to_client_data(hair_week.day12_hair,12) if hair_week.day12_hair),
        (convert_hair_day_to_client_data(hair_week.day13_hair,13) if hair_week.day13_hair),
        (convert_hair_day_to_client_data(hair_week.day14_hair,14) if hair_week.day14_hair)
    ].compact
end

# 髪色経過の画像リンクをクライアントサイドで投稿として表示するために必要なデータに変換する
def convert_hair_day_images_to_client_post(hair_week)
    return [
        hair_week.day1_hair.img_link,
        (hair_week.day2_hair.img_link if hair_week.day2_hair),
        (hair_week.day3_hair.img_link if hair_week.day3_hair),
        (hair_week.day4_hair.img_link if hair_week.day4_hair),
        (hair_week.day5_hair.img_link if hair_week.day5_hair),
        (hair_week.day6_hair.img_link if hair_week.day6_hair),
        (hair_week.day7_hair.img_link if hair_week.day7_hair),
        (hair_week.day8_hair.img_link if hair_week.day8_hair),
        (hair_week.day9_hair.img_link if hair_week.day9_hair),
        (hair_week.day10_hair.img_link if hair_week.day10_hair),
        (hair_week.day11_hair.img_link if hair_week.day11_hair),
        (hair_week.day12_hair.img_link if hair_week.day12_hair),
        (hair_week.day13_hair.img_link if hair_week.day13_hair),
        (hair_week.day14_hair.img_link if hair_week.day14_hair)
    ].compact
end