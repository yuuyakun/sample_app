class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desk) } # 古い投稿した順番にする
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
