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

  before_create :set_default_cover


  def set_default_cover
    self.remote_cover_url = "https://softcover.s3.amazonaws.com/636/ruby_on_rails_tutorial_solutions_manual/images/cover-web.png" if self.cover.nil?
  end

  def formated_price
    helper.number_to_currency(self.price, unit: "IDR ", precision: 0)
  end
  
end
