class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy


  def liked_by?(user)
    likes.find_by(user: user).present?
  end

  def likes_count
    likes.count
  end
end
