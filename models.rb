require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password validations: false
    validates :name, presence: true
    validates :email, uniqueness: true, format: { with: /\A\S+@\S+\.\S+\z/i }, unless: :stylist?
    validates :password, presence: true, format: { with: /\A(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}\z/ }, unless: :stylist?
    validates :profile_img_link, format: { with: /\Ahttps?:\/\/[\w\/:%#\$&\?\(\)~\.=\+\-]+\z/ }, allow_blank: true, unless: :stylist?

    has_many :hair_history_likes
    has_many :hair_history_bookmarks
    has_many :like_hair_histories, through: :hair_history_likes, source: :hair_history
    has_many :bookmark_hair_histories, through: :hair_history_bookmarks, source: :hair_history
    has_many :hair_histories, dependent: :destroy
    
    # 自分がフォローしているユーザーとの関係
    has_many :following_relationships,
        class_name: 'UserFollows',
        foreign_key: 'follower_id',
        dependent: :destroy
    has_many :followings,
        through: :following_relationships,
        source: :followee

    # 自分をフォローしているユーザーとの関係
    has_many :follower_relationships,
        class_name: 'UserFollows',
        foreign_key: 'followed_id',
        dependent: :destroy
    has_many :followers,
        through: :follower_relationships,
        source: :follower

    enum role: { customer: 0, stylist: 1, owner: 2 }
end

class Salon < ActiveRecord::Base
    validates :name, presence: true
    validates :address, presence: true
    validates :website, allow_blank: true, format: { with: /\Ahttps?:\/\/[\w\/:%#\$&\?\(\)~\.=\+\-]+\z/ }
    validates :phone_number, allow_blank: true, format: { with: /\A(?:0\d{1,4}-\d{1,4}-\d{4}|0[789]0-\d{4}-\d{4}|0120-\d{3}-\d{3}|0120-\d{4}-\d{4}|050-\d{4}-\d{4}|0\d{9,10})\z/ }
    validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
    validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

    has_many :salon_staffs
    has_many :staffs, through: :salon_staffs, source: :user
    enum status: { pending: 0, verified: 1 }
end

class HairHistory < ActiveRecord::Base
    validates :evaluation, presence: true, inclusion: { in: 0..3 }
    belongs_to :user
    belongs_to :salon
    belongs_to :stylist, class_name: 'User', foreign_key: 'stylist_id'
    belongs_to :hair_week, dependent: :destroy
    has_many :hair_history_colors
    has_many :hair_colors, through: :hair_history_colors, source: :hair_color
    has_many :hair_history_likes
    has_many :hair_history_bookmarks
    has_many :like_users, through: :hair_history_likes, source: :user
    has_many :bookmark_users, through: :hair_history_bookmarks, source: :user
    enum color_type: { solid: 0, gradient: 1 }
end

class HairColor < ActiveRecord::Base
    validates :hex_code, presence: true, format: { with: /\A#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})\z/ }
    has_many :hair_history_colors
    has_many :hair_histories, through: :hair_history_colors, source: :hair_history
end

class HairHistoryColor < ActiveRecord::Base
    validates :percentage, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
    belongs_to :hair_history
    belongs_to :hair_color
end

class SalonStaff < ActiveRecord::Base
    belongs_to :user
    belongs_to :salon
end

class HairDay < ActiveRecord::Base
    validates :img_link, presence: true, format: { with: /\Ahttps?:\/\/[\w\/:%#\$&\?\(\)~\.=\+\-]+\z/ }
    belongs_to :hair_week
end

class HairWeek < ActiveRecord::Base
    has_one :hair_history
    belongs_to :day1_hair, class_name: 'HairDay', foreign_key: 'day1_hair_id', dependent: :destroy
    belongs_to :day2_hair, class_name: 'HairDay', foreign_key: 'day2_hair_id', dependent: :destroy, optional: true
    belongs_to :day3_hair, class_name: 'HairDay', foreign_key: 'day3_hair_id', dependent: :destroy, optional: true
    belongs_to :day4_hair, class_name: 'HairDay', foreign_key: 'day4_hair_id', dependent: :destroy, optional: true
    belongs_to :day5_hair, class_name: 'HairDay', foreign_key: 'day5_hair_id', dependent: :destroy, optional: true
    belongs_to :day6_hair, class_name: 'HairDay', foreign_key: 'day6_hair_id', dependent: :destroy, optional: true
    belongs_to :day7_hair, class_name: 'HairDay', foreign_key: 'day7_hair_id', dependent: :destroy, optional: true
    belongs_to :day8_hair, class_name: 'HairDay', foreign_key: 'day8_hair_id', dependent: :destroy, optional: true
    belongs_to :day9_hair, class_name: 'HairDay', foreign_key: 'day9_hair_id', dependent: :destroy, optional: true
    belongs_to :day10_hair, class_name: 'HairDay', foreign_key: 'day10_hair_id', dependent: :destroy, optional: true
    belongs_to :day11_hair, class_name: 'HairDay', foreign_key: 'day11_hair_id', dependent: :destroy, optional: true
    belongs_to :day12_hair, class_name: 'HairDay', foreign_key: 'day12_hair_id', dependent: :destroy, optional: true
    belongs_to :day13_hair, class_name: 'HairDay', foreign_key: 'day13_hair_id', dependent: :destroy, optional: true
    belongs_to :day14_hair, class_name: 'HairDay', foreign_key: 'day14_hair_id', dependent: :destroy, optional: true
end

class HairHistoryLike < ActiveRecord::Base
    belongs_to :user
    belongs_to :hair_history
end

class HairHistoryBookmark < ActiveRecord::Base
    belongs_to :user
    belongs_to :hair_history
end

class UserFollows < ActiveRecord::Base
    belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
    belongs_to :followee, class_name: 'User', foreign_key: 'followed_id'
end