class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :blog

  after_create_commit { CommentBroadcastJob.perform_later(self) }
  
  validates :content, presence: :true, length: { minimum: 5, maximum: 1000}
end
