class Micropost < ApplicationRecord
  belongs_to :user
  vilidates :user_id, presence: true
end
