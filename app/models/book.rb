# == Schema Information
#
# Table name: books
#
#  id          :bigint           not null, primary key
#  author      :string
#  cover       :string
#  description :string
#  genre       :string
#  price       :decimal(, )      default(0.0)
#  publisher   :string
#  slug        :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_books_on_slug  (slug) UNIQUE
#

class Book < ApplicationRecord

  extend FriendlyId
  friendly_id :title, use: :slugged

  mount_uploader :cover, CoverUploader

  validates :title, :author, :description, presence: true   
  validates :price, presence: true, numericality: {:greater_than => 0}   
  
end
