class Topic < ApplicationRecord
  has_many :blogs

  def self.with_blogs
    includes(:blogs).where.not(blogs: { id: nil})
  end
  
  validates_presence_of :title
end
