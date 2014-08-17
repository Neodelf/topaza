class Publication < ActiveRecord::Base
  validates_presence_of :title, :body, :short_body, :seo_title, :seo_description, :seo_keywords, :images
  validates_associated :images

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :images
end
